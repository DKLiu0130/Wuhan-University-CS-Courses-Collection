#if defined(D_NEXYS_A7)
#include <bsp_printf.h>
#include <bsp_mem_map.h>
#include <bsp_version.h>
#else
PRE_COMPILED_MSG("no platform was defined")
#endif
#include <psp_api.h>
#include <rtthread.h>

#define uart_data (*(volatile unsigned int *)0x80002000)
#define uart_lsr (*(volatile unsigned int *)0x80002014)
 
#define uart_lsr_r_mask 0x01
#define uart_lsr_w_mask 0x20

#define SegEn_ADDR    0x80001038
#define SegDig_ADDR   0x8000103C
#define WRITE_7Seg(dir, value) { (*(volatile unsigned *)dir) = (value); }

int SegDig_Value=0;

char uart_getchar(void)
{
    char c;

    while((uart_lsr_r_mask & uart_lsr) == 0){
		rt_thread_yield();
	}
    c = uart_data;

    return c;
}
 

int uart_putchar(char c)
{
    while((uart_lsr_w_mask & uart_lsr) == 0){
		rt_thread_yield();
	}
    uart_data = c;

    return 0;
}


int SevSegDispl(char c)
{
    int i=0, j;
    
    i = (int)c;

    if (i>47 && i<58) j=i-48;
    else if (i>96 && i<103) j=i-87;
    else if (i>64 && i<71) j=i-55;
    else j=0;

    SegDig_Value = SegDig_Value << 4;
    SegDig_Value = SegDig_Value | j;

    WRITE_7Seg(SegDig_ADDR, SegDig_Value);

    return 0;
}

/**
 * Redefine "rt\u hw\u console\u getchar" function to realize finsh function
 */
char rt_hw_console_getchar(void)
{
	int ch = -1;

	ch = uart_getchar();
	
	return ch;
}