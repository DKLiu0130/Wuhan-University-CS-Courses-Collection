#include <rtthread.h>
#include <rthw.h>
#include "appdef.h"
#include "board.h"
#include "bsp_external_interrupts.h"
#include "psp_ext_interrupts_eh1.h"
#include "psp_api.h"

#define RGPIO_INTE      0x8000140C
#define RGPIO_PTRIG     0x80001410
#define RGPIO_CTRL      0x80001418
#define RGPIO_INTS      0x8000141C
#define Select_INT      0x80001018

#define PARKING_TOTAL_SPACES 16
#define SW_ENTER_BIT    15
#define SW_EXIT_BIT     14

typedef struct {
    rt_uint16_t occupied_mask;
    rt_uint8_t total_spaces;
    rt_uint8_t occupied_count;
    rt_uint8_t free_count;
    struct rt_mutex mutex;
    rt_bool_t initialized;
} parking_lot_t;

static parking_lot_t parking;
static rt_thread_t display_thread = RT_NULL;
static rt_thread_t uart_thread = RT_NULL;

static void update_display(void)
{
    rt_uint16_t led_mask;
    rt_uint8_t free_count;
    rt_uint8_t tens, ones;
    rt_uint32_t seg_value;
    
    rt_mutex_take(&parking.mutex, RT_WAITING_FOREVER);
    led_mask = parking.occupied_mask;
    free_count = parking.free_count;
    rt_mutex_release(&parking.mutex);
    
    SET_LED(led_mask);
    
    tens = free_count / 10;
    ones = free_count % 10;
    
    seg_value = ((rt_uint32_t)tens << 4) | ones;
    SET_SegDig(seg_value);
}

static void print_parking_info(void)
{
    rt_uint8_t total, occupied, free;
    
    rt_mutex_take(&parking.mutex, RT_WAITING_FOREVER);
    total = parking.total_spaces;
    occupied = parking.occupied_count;
    free = parking.free_count;
    rt_mutex_release(&parking.mutex);
    
    rt_kprintf("停车场信息: 总车位=%d, 已占用=%d, 剩余=%d\n", total, occupied, free);
}

static rt_bool_t car_enter(void)
{
    rt_uint16_t mask;
    rt_uint8_t i;
    rt_bool_t success = RT_FALSE;
    
    rt_mutex_take(&parking.mutex, RT_WAITING_FOREVER);
    
    if (parking.occupied_count < PARKING_TOTAL_SPACES) {
        mask = parking.occupied_mask;
        for (i = 0; i < PARKING_TOTAL_SPACES; i++) {
            if (!(mask & (1 << i))) {
                parking.occupied_mask |= (1 << i);
                parking.occupied_count++;
                parking.free_count--;
                success = RT_TRUE;
                rt_kprintf("车辆进入，占用车位 %d\n", i + 1);
                break;
            }
        }
    } else {
        rt_kprintf("停车场已满，无法进入\n");
    }
    
    rt_mutex_release(&parking.mutex);
    return success;
}

static rt_bool_t car_exit(void)
{
    rt_uint16_t mask;
    rt_uint8_t i;
    rt_bool_t success = RT_FALSE;
    
    rt_mutex_take(&parking.mutex, RT_WAITING_FOREVER);
    
    if (parking.occupied_count > 0) {
        mask = parking.occupied_mask;
        for (i = 0; i < PARKING_TOTAL_SPACES; i++) {
            if (mask & (1 << i)) {
                parking.occupied_mask &= ~(1 << i);
                parking.occupied_count--;
                parking.free_count++;
                success = RT_TRUE;
                rt_kprintf("车辆离开，释放车位 %d\n", i + 1);
                break;
            }
        }
    } else {
        rt_kprintf("停车场为空，无车辆可出\n");
    }
    
    rt_mutex_release(&parking.mutex);
    return success;
}

static void display_thread_entry(void *parameter)
{
    rt_tick_t last_tick = rt_tick_get();
    rt_tick_t current_tick;
    
    while (1) {
        update_display();
        
        current_tick = rt_tick_get();
        while (current_tick == last_tick) {
            rt_thread_yield();
            current_tick = rt_tick_get();
        }
        last_tick = current_tick;
    }
}

static void uart_thread_entry(void *parameter)
{
    rt_tick_t last_tick;
    rt_tick_t current_tick;
    rt_tick_t target_tick;
    rt_uint32_t wait_count = 0;
    
    rt_kprintf("串口线程已启动\n");
    
    while (1) {
        print_parking_info();
        
        last_tick = rt_tick_get();
        target_tick = last_tick + 4;
        wait_count = 0;
        
        while (1) {
            current_tick = rt_tick_get();
            if (current_tick >= target_tick) {
                break;
            }
            wait_count++;
            if (wait_count > 1000000) {
                rt_kprintf("串口线程延迟超时，强制继续\n");
                break;
            }
            rt_thread_yield();
        }
    }
}

static void GPIO_ISR(void)
{
    rt_uint32_t int_status;
    rt_uint16_t current_sw;
    
    int_status = M_PSP_READ_REGISTER_32(RGPIO_INTS);
    
    current_sw = READ_SW();
    
    if (current_sw & (1 << SW_ENTER_BIT)) {
        car_enter();
    }
    
    if (current_sw & (1 << SW_EXIT_BIT)) {
        car_exit();
    }
    
    M_PSP_WRITE_REGISTER_32(RGPIO_INTS, 0x0);
    
    bspClearExtInterrupt(D_BSP_IRQ_4);
}

extern pspInterruptHandler_t G_Ext_Interrupt_Handlers[];

static void ExternalIntLine_Initialization(u32_t uiSourceId, u32_t priority, pspInterruptHandler_t pTestIsr)
{
    pspExternalInterruptSetVectorTableAddress(G_Ext_Interrupt_Handlers);
    pspExtInterruptSetType(uiSourceId, D_PSP_EXT_INT_LEVEL_TRIG_TYPE);
    pspExtInterruptSetPolarity(uiSourceId, D_PSP_EXT_INT_ACTIVE_HIGH);
    pspExtInterruptClearPendingInt(uiSourceId);
    pspExtInterruptSetPriority(uiSourceId, priority);
    pspExternalInterruptEnableNumber(uiSourceId);
    G_Ext_Interrupt_Handlers[uiSourceId] = pTestIsr;
}

static void GPIO_Initialization(void)
{
    M_PSP_WRITE_REGISTER_32(GPIO_INOUT, 0xFFFF);
    M_PSP_WRITE_REGISTER_32(GPIO_LEDs, 0x0);
    M_PSP_WRITE_REGISTER_32(RGPIO_INTE, 0xC0000000);
    M_PSP_WRITE_REGISTER_32(RGPIO_PTRIG, 0xC0000000);
    M_PSP_WRITE_REGISTER_32(RGPIO_INTS, 0x0);
    M_PSP_WRITE_REGISTER_32(RGPIO_CTRL, 0x1);
    rt_kprintf("GPIO初始化完成\n");
}

static void parking_lot_init(void)
{
    if (!parking.initialized) {
        rt_mutex_init(&parking.mutex, "parking_mutex", RT_IPC_FLAG_FIFO);
    }
    parking.occupied_mask = 0;
    parking.total_spaces = PARKING_TOTAL_SPACES;
    parking.occupied_count = 0;
    parking.free_count = PARKING_TOTAL_SPACES;
    parking.initialized = RT_TRUE;
    
    SET_SegEn(0x00);
    {
        rt_uint8_t tens = parking.free_count / 10;
        rt_uint8_t ones = parking.free_count % 10;
        rt_uint32_t seg_value = ((rt_uint32_t)tens << 4) | ones;
        SET_SegDig(seg_value);
    }
    SET_LED(0);
}

int parkinglot(void)
{
    if (display_thread != RT_NULL || uart_thread != RT_NULL) {
        rt_kprintf("停车场管理系统已在运行\n");
        rt_kprintf("显示线程: %s\n", display_thread ? "运行中" : "未创建");
        rt_kprintf("串口线程: %s\n", uart_thread ? "运行中" : "未创建");
        return 0;
    }
    
    rt_kprintf("正在初始化停车场管理系统...\n");
    parking.initialized = RT_FALSE;
    parking_lot_init();
    
    pspExtInterruptsSetThreshold(M_PSP_EXT_INT_THRESHOLD_UNMASK_ALL_VALUE);
    ExternalIntLine_Initialization(D_BSP_IRQ_4, D_PSP_EXT_INT_PRIORITY_6, GPIO_ISR);
    GPIO_Initialization();
    M_PSP_WRITE_REGISTER_32(Select_INT, 0x1);
    pspInterruptsEnable();
    M_PSP_SET_CSR(D_PSP_MIE_NUM, D_PSP_MIE_MEIE_MASK);
    rt_kprintf("GPIO_Initialization完成\n");
    display_thread = rt_thread_create("display_th",
                                     display_thread_entry,
                                     RT_NULL,
                                     THREAD_STACK_SIZE * 2,
                                     THREAD_PRIORITY,
                                     THREAD_TIMESLICE);
    rt_kprintf("display_thread创建完成\n");
    if (display_thread != RT_NULL) {
        rt_err_t result = rt_thread_startup(display_thread);
        rt_kprintf("显示线程启动结果: %d\n", result);
        rt_thread_yield();
        rt_kprintf("显示线程创建成功\n");
    } else {
        rt_kprintf("创建显示线程失败\n");
        return -1;
    }
    
    uart_thread = rt_thread_create("uart_th",
                                  uart_thread_entry,
                                  RT_NULL,
                                  THREAD_STACK_SIZE * 2,
                                  THREAD_PRIORITY - 1,
                                  THREAD_TIMESLICE);
    if (uart_thread != RT_NULL) {
        rt_err_t result = rt_thread_startup(uart_thread);
        rt_kprintf("串口线程创建成功，启动结果: %d\n", result);
        rt_thread_yield();
    } else {
        rt_kprintf("创建串口线程失败\n");
        if (display_thread != RT_NULL) {
            rt_thread_delete(display_thread);
            display_thread = RT_NULL;
        }
        return -1;
    }
    
    rt_kprintf("停车场管理系统启动成功\n");
    rt_kprintf("使用拨码开关: sw[15]进库, sw[14]出库\n");
    
    return 0;
}

MSH_CMD_EXPORT(parkinglot, parking lot management system);

int test_tick(void)
{
    rt_tick_t tick1, tick2, last_tick;
    rt_uint32_t i, count;
    
    rt_kprintf("=== 系统时钟测试 ===\n");
    rt_kprintf("RT_TICK_PER_SECOND = %d (每秒tick数)\n", RT_TICK_PER_SECOND);
    
    rt_kprintf("\n方法1: 观察tick值是否增长（不使用线程延迟）\n");
    tick1 = rt_tick_get();
    rt_kprintf("当前tick = %d\n", tick1);
    
    last_tick = tick1;
    count = 0;
    while (count < 1000000) {
        tick2 = rt_tick_get();
        if (tick2 != last_tick) {
            break;
        }
        count++;
        rt_thread_yield();
    }
    rt_kprintf("等待tick增长后: tick = %d (循环%d次)\n", tick2, count);
    rt_kprintf("tick增长 = %d\n", tick2 - tick1);
    
    if (tick2 > tick1) {
        rt_kprintf("系统时钟正常！tick在增长\n");
    } else {
        rt_kprintf("系统时钟异常！tick没有增长\n");
    }
    
    rt_kprintf("\n方法2: 连续读取tick值（观察变化）\n");
    for (i = 0; i < 10; i++) {
        tick1 = rt_tick_get();
        rt_kprintf("第%d次: tick = %d\n", i + 1, tick1);
        last_tick = tick1;
        count = 0;
        while (count < 500000 && rt_tick_get() == last_tick) {
            count++;
            rt_thread_yield();
        }
    }
    
    rt_kprintf("\n=== 测试完成 ===\n");
    rt_kprintf("注意：如果系统时钟配置异常，rt_thread_mdelay可能无法正常工作\n");
    rt_kprintf("本测试使用轮询方式避免使用rt_thread_mdelay\n");
    
    return 0;
}

MSH_CMD_EXPORT(test_tick, test system tick);
