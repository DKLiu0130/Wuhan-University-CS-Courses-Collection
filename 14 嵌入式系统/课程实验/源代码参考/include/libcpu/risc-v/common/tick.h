/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2018/10/28     Bernard      The unify RISC-V porting code.
 */

#ifndef TICK_H__
#define TICK_H__

// 使用新的定时器寄存器地址
#define PTC_TIME                (D_MTIME_ADDRESS)
#define PTC_TIMECMP(hartid)     (D_MTIMECMP_ADDRESS)

int tick_isr(void);
int rt_hw_tick_init(void);

#endif

