/*
 * Copyright (c) 2006-2018, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2018-11-22     Jesven       first version
 */
#include <rthw.h>
#include <rtthread.h>
#include <stdint.h>

#include "board.h"
#include "bsp_timer.h"
#include "bsp_external_interrupts.h"
#include "interrupt.h"
#include "components.h"
#include "rtdef.h"
#include "drv_timer.h"
#include "psp_interrupts_eh1.h"
#include "psp_api.h"

#define TIMER_HW_BASE                   D_TIMER_DURATION_SETUP_ADDRESS  // 使用新的定时器基地址

#include "psp_api.h"
extern void pspTimerSetupMachineTimer(u32_t uiPeriodMseconds);
// 外部声明全局时间更新函数
extern void global_clock_update_second(void);

void rt_hw_timer_isr(void)
{
    static rt_tick_t tick_count = 0;
    
    pspDisableInterruptNumberMachineLevel(D_PSP_INTERRUPTS_MACHINE_TIMER);
    /* enter interrupt */
    rt_interrupt_enter();

    rt_tick_increase();
    tick_count++;
    
    // 每秒更新全局时钟时间（每RT_TICK_PER_SECOND个tick调用一次）
    if (tick_count % RT_TICK_PER_SECOND == 0) {
        global_clock_update_second();
    }
    
	//Add this !!!
    pspTimerSetupMachineTimer(D_CLOCK_RATE / RT_TICK_PER_SECOND);
    /* leave interrupt */
    rt_interrupt_leave();
    pspEnableInterruptNumberMachineLevel(D_PSP_INTERRUPTS_MACHINE_TIMER);
}

int rt_hw_timer_init(void)
{
    pspInterruptsSetVectorTableAddress(&psp_vect_table);
    pspRegisterInterruptHandler((pspInterruptHandler_t)rt_hw_timer_isr, E_MACHINE_TIMER_CAUSE);
    pspTimerSetupMachineTimer(D_CLOCK_RATE / RT_TICK_PER_SECOND); // Fix this !!!
    //Add this !!!
    pspEnableInterruptNumberMachineLevel(D_PSP_INTERRUPTS_MACHINE_TIMER); // 启用定时器中断

    return 0;

}

INIT_BOARD_EXPORT(rt_hw_timer_init);


void timer_clear_pending(int timer)
{
#ifdef RT_USING_OLD
    // 假设每个定时器有不同的清除中断地址
    if (timer == 0)
    {
        TIMER_INTCLR(TIMER01_HW_BASE) = 0x01;
    } 
    else
    {
        TIMER_INTCLR(TIMER23_HW_BASE) = 0x01;
    }
#else
    M_PSP_WRITE_CSR(D_PSP_MITBND0_NUM, 0x01);
    M_PSP_WRITE_CSR(D_PSP_MITBND1_NUM, 0x01);
}
#endif