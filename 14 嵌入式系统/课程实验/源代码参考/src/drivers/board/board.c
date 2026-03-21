/*
 * Copyright (c) 2006-2024, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2024-05-07     RealThread   first version
 */

#include <rtthread.h>
#include "board.h"
#include <drv_common.h>
#include <stdint.h>
#include "bsp_printf.h"
#include "bsp_mem_map.h"
#include "bsp_version.h"

void hw_board_init(char *clock_src, int32_t clock_src_freq, int32_t clock_target_freq);
void UartInit(void);
char heap[500*1024];
rt_weak void rt_hw_board_init()
{
#if defined(RT_USING_HEAP)
    rt_system_heap_init(heap, heap+500*1024);
#endif
    hw_board_init(BSP_CLOCK_SOURCE, BSP_CLOCK_SOURCE_FREQ_MHZ, BSP_CLOCK_SYSTEM_FREQ_MHZ);
    /* Set the shell console output device */
#if defined(RT_USING_DEVICE) && defined(RT_USING_CONSOLE)
    rt_console_set_device(RT_CONSOLE_DEVICE_NAME);
#endif
    /* Board underlying hardware initialization */
#ifdef RT_USING_COMPONENTS_INIT
    rt_components_board_init();
#endif
        /* Heap initialization */
}

void hw_board_init(char *clock_src, int32_t clock_src_freq, int32_t clock_target_freq){
    UartInit();
}

void UartInit(void)
{
#ifdef D_HI_FIVE1
   /* Empty implementation */
#endif
#ifdef D_SWERV_EH1
  swervolfVersion_t stSwervolfVersion;

  versionGetSwervolfVer(&stSwervolfVersion);

 /* Whisper bypass - force UART state to be "non-busy" (== 0) so print via UART will be displayed on console
  * when running with Whisper */
  u32_t* pUartState = (u32_t*)(D_UART_BASE_ADDRESS+0x8);
  *pUartState = 0 ;

  /* init uart */
  uartInit();
#endif
}