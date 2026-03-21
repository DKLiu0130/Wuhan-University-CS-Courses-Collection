#if defined(D_NEXYS_A7)
   #include "bsp_printf.h"
   #include "bsp_mem_map.h"
   #include "bsp_version.h"
   #include "bsp_external_interrupts.h"
   #include "bsp_timer.h"
#else
   PRE_COMPILED_MSG("no platform was defined")
#endif
#include "psp_api.h"
#include <rtthread.h>
#include "bsp_spi_flash.h"

#include "tick.h"
#include "appdef.h"

extern void flash_storage_test(void);

void continue_next(void) {
}

int main(void) {
    flash_storage_test();
    return 0;
}