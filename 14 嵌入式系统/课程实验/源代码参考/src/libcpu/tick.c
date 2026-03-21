#include <rthw.h>
#include <rtthread.h>
#include <stdint.h>
#include "tick.h"
#include <psp_attributes.h>
#include <psp_types.h>
#define CLOCK_RATE (D_CLOCK_RATE)
D_PSP_TEXT_SECTION void pspTimerSetupMachineTimer(u32_t uiPeriodCycles);

int tick_isr(void)
{
    int tick_cycles = CLOCK_RATE / RT_TICK_PER_SECOND;
    rt_tick_increase();

#ifdef RISCV_S_MODE
    sbi_set_timer(pspTimerCounterGet(E_MACHINE_TIMER) + tick_cycles);
#else
    pspTimerSetupMachineTimer(tick_cycles);  // 使用现有的定时器设置函数
#endif

    return 0;
}

/* Sets and enable the timer interrupt */
int rt_hw_tick_init(void)
{
    unsigned long interval = CLOCK_RATE / RT_TICK_PER_SECOND;

#ifdef RISCV_S_MODE
    clear_csr(sie, SIP_STIP);
    sbi_set_timer(pspTimerCounterGet(E_MACHINE_TIMER) + interval);
    set_csr(sie, SIP_STIP);
#else
    pspTimerSetupMachineTimer(interval);  // 使用现有的定时器设置函数
#endif

    return 0;
}
