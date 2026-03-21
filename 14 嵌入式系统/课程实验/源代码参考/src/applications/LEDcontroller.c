#include "board.h"
#include <rthw.h>
#include "rtthread.h"
#include "appdef.h"

static uint32_t LED_SPEED = 8000;
static uint16_t LED_CONSTANT_MASK;
static uint16_t LED_ALTER_MASK;
static uint16_t LED_ALTER_MASK_CUR;
static rt_thread_t ledCont = RT_NULL;


void setLED_speed(uint32_t spd){
    LED_SPEED = spd;
}
void setLED_alt(uint16_t mask){
    LED_ALTER_MASK |= mask;
    LED_ALTER_MASK_CUR = LED_ALTER_MASK;
}
void writeLED_alt(uint16_t mask){
    LED_ALTER_MASK = mask;
    LED_ALTER_MASK_CUR = LED_ALTER_MASK;
}
void delLED_alt(uint16_t mask){
    LED_ALTER_MASK &= ~mask;
    LED_ALTER_MASK_CUR = LED_ALTER_MASK;
}

void setLED_const(uint16_t mask){
    LED_CONSTANT_MASK |= mask;
}
void writeLED_const(uint16_t mask){
    LED_CONSTANT_MASK = mask;
}
void delLED_const(uint16_t mask){
    LED_CONSTANT_MASK &= ~mask;
}

void ledContHandler(){
    while(1){
        SET_LED(LED_CONSTANT_MASK|LED_ALTER_MASK_CUR);
        LED_ALTER_MASK_CUR = (LED_ALTER_MASK_CUR == 0)?LED_ALTER_MASK:0;
        rt_thread_mdelay(LED_SPEED);
    }
}

int createLEDController(void)
{
    if(ledCont != RT_NULL){
        return 0;
    }
    /* 创建 t1 线程 */
    ledCont = rt_thread_create("ledCont", ledContHandler, NULL,
                              THREAD_STACK_SIZE,
                              THREAD_PRIORITY, THREAD_TIMESLICE);
    if (ledCont != RT_NULL)
        rt_thread_startup(ledCont);
    return 0;
}