#include <rtthread.h>
#include "bsp_printf.h"
#include <string.h>

#ifdef RT_USING_HEAP

static int cmd_memory_info(int argc, char **argv)
{
    rt_size_t total = 0, used = 0, max_used = 0;
    
    rt_kprintf("\n=== System Memory Information ===\n");
    
    rt_memory_info(&total, &used, &max_used);
    
    {
        rt_uint32_t total_kb = total / 1024;
        rt_uint32_t total_mb = total / (1024 * 1024);
        rt_uint32_t total_kb_frac = ((total % 1024) * 100) / 1024;
        rt_uint32_t total_mb_frac = ((total % (1024 * 1024)) * 100) / (1024 * 1024);
        rt_kprintf("Total RAM:     %d bytes (%d.%02d KB, %d.%02d MB)\n", 
                   total, total_kb, total_kb_frac, total_mb, total_mb_frac);
    }
    {
        rt_uint32_t used_kb = used / 1024;
        rt_uint32_t used_mb = used / (1024 * 1024);
        rt_uint32_t used_kb_frac = ((used % 1024) * 100) / 1024;
        rt_uint32_t used_mb_frac = ((used % (1024 * 1024)) * 100) / (1024 * 1024);
        rt_kprintf("Used RAM:      %d bytes (%d.%02d KB, %d.%02d MB)\n", 
                   used, used_kb, used_kb_frac, used_mb, used_mb_frac);
    }
    {
        rt_uint32_t free = total - used;
        rt_uint32_t free_kb = free / 1024;
        rt_uint32_t free_mb = free / (1024 * 1024);
        rt_uint32_t free_kb_frac = ((free % 1024) * 100) / 1024;
        rt_uint32_t free_mb_frac = ((free % (1024 * 1024)) * 100) / (1024 * 1024);
        rt_kprintf("Free RAM:      %d bytes (%d.%02d KB, %d.%02d MB)\n", 
                   free, free_kb, free_kb_frac, free_mb, free_mb_frac);
    }
    {
        rt_uint32_t max_kb = max_used / 1024;
        rt_uint32_t max_mb = max_used / (1024 * 1024);
        rt_uint32_t max_kb_frac = ((max_used % 1024) * 100) / 1024;
        rt_uint32_t max_mb_frac = ((max_used % (1024 * 1024)) * 100) / (1024 * 1024);
        rt_kprintf("Max Used:      %d bytes (%d.%02d KB, %d.%02d MB)\n", 
                   max_used, max_kb, max_kb_frac, max_mb, max_mb_frac);
    }
    
    if (total > 0) {
        rt_uint32_t usage_percent = (used * 100) / total;
        rt_kprintf("Usage:         %d%%\n", usage_percent);
    }
    
    rt_kprintf("\n=== Memory Regions (from link.lds) ===\n");
    rt_kprintf("RAM:           0x00000000 - 0x03FFFFFF (64 MB)\n");
    rt_kprintf("RAM2:          0x04000000 - 0x07FFFFFF (64 MB)\n");
    rt_kprintf("DCCM:          0xF0040000 - 0xF004FFFF (64 KB)\n");
    rt_kprintf("Total RAM:     128 MB + 64 KB\n");
    
    rt_kprintf("\n=== Flash Storage ===\n");
    rt_kprintf("Flash Chip:    S25FL128S\n");
    rt_kprintf("Flash Size:    16 MB (128 Mbit)\n");
    rt_kprintf("Address Range: 0x000000 - 0xFFFFFF\n");
    
    rt_kprintf("\n=== Flash File System ===\n");
    {
        extern u32_t fs_get_free_space(void);
        u32_t flash_free = fs_get_free_space();
        rt_kprintf("Total Flash:   16 MB\n");
        {
            rt_uint32_t flash_free_kb = flash_free / 1024;
            rt_uint32_t flash_free_mb = flash_free / (1024 * 1024);
            rt_uint32_t flash_free_kb_frac = ((flash_free % 1024) * 100) / 1024;
            rt_uint32_t flash_free_mb_frac = ((flash_free % (1024 * 1024)) * 100) / (1024 * 1024);
            rt_kprintf("Free Space:    %d bytes (%d.%02d KB, %d.%02d MB)\n", 
                       flash_free, flash_free_kb, flash_free_kb_frac, 
                       flash_free_mb, flash_free_mb_frac);
        }
        {
            rt_uint32_t flash_used = 16 * 1024 * 1024 - flash_free;
            rt_uint32_t flash_used_kb = flash_used / 1024;
            rt_uint32_t flash_used_mb = flash_used / (1024 * 1024);
            rt_uint32_t flash_used_kb_frac = ((flash_used % 1024) * 100) / 1024;
            rt_uint32_t flash_used_mb_frac = ((flash_used % (1024 * 1024)) * 100) / (1024 * 1024);
            rt_kprintf("Used Space:    %d bytes (%d.%02d KB, %d.%02d MB)\n", 
                       flash_used, flash_used_kb, flash_used_kb_frac, 
                       flash_used_mb, flash_used_mb_frac);
        }
    }
    
    rt_kprintf("\n=== Test Complete ===\n\n");
    
    return 0;
}
MSH_CMD_EXPORT(cmd_memory_info, show system memory information);

#else

static int cmd_memory_info(int argc, char **argv)
{
    rt_kprintf("Memory heap is not enabled in this system.\n");
    rt_kprintf("\n=== Memory Regions (from link.lds) ===\n");
    rt_kprintf("RAM:           0x00000000 - 0x03FFFFFF (64 MB)\n");
    rt_kprintf("RAM2:          0x04000000 - 0x07FFFFFF (64 MB)\n");
    rt_kprintf("DCCM:          0xF0040000 - 0xF004FFFF (64 KB)\n");
    rt_kprintf("Total RAM:     128 MB + 64 KB\n");
    rt_kprintf("\n=== Flash Storage ===\n");
    rt_kprintf("Flash Chip:    S25FL128S\n");
    rt_kprintf("Flash Size:    16 MB (128 Mbit)\n");
    return 0;
}
MSH_CMD_EXPORT(cmd_memory_info, show system memory information);

#endif

