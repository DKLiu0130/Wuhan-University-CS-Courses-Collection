#include "bsp_flash_fs.h"
#include "bsp_printf.h"
#include <rtthread.h>
#include <string.h>
#include <stdlib.h>

static int cmd_ls(int argc, char **argv)
{
    s32_t ret;
    
    if (fs_init() != 0) {
        rt_kprintf("File system init failed\n");
        return -1;
    }
    
    ret = fs_list_files();
    if (ret != 0) {
        rt_kprintf("List files failed: %d\n", ret);
        return -1;
    }
    return 0;
}
MSH_CMD_EXPORT_ALIAS(cmd_ls, fls, list files in flash file system);

static int cmd_cat(int argc, char **argv)
{
    fs_file_handle_t handle;
    u08_t buffer[512];
    s32_t ret;
    u32_t i;
    u32_t total_read = 0;
    
    if (argc < 2) {
        rt_kprintf("Usage: cat <filename>\n");
        return -1;
    }
    
    if (fs_open(argv[1], &handle) != 0) {
        rt_kprintf("File '%s' not found\n", argv[1]);
        return -1;
    }
    
    fs_file_entry_t info;
    if (fs_get_file_info(argv[1], &info) == 0) {
        u32_t file_size = info.size;
        
        while (total_read < file_size) {
            u32_t read_size = file_size - total_read;
            if (read_size > sizeof(buffer)) {
                read_size = sizeof(buffer);
            }
            
            ret = fs_read(&handle, buffer, read_size);
            if (ret <= 0) {
                break;
            }
            
            u32_t printable_count = 0;
            for (i = 0; i < ret; i++) {
                u08_t ch = buffer[i];
                if (ch >= 32 && ch < 127) {
                    printable_count++;
                }
            }
            
            if (printable_count * 2 < ret) {
                for (i = 0; i < ret; i++) {
                    if (i > 0 && i % 16 == 0) {
                        rt_kprintf("\n");
                    } else if (i > 0 && i % 8 == 0) {
                        rt_kprintf(" ");
                    }
                    rt_kprintf("%02X ", buffer[i]);
                }
            } else {
                for (i = 0; i < ret; i++) {
                    u08_t ch = buffer[i];
                    if (ch >= 32 && ch < 127) {
                        rt_kprintf("%c", ch);
                    } else if (ch == '\n') {
                        rt_kprintf("\n");
                    } else if (ch == '\r') {
                    } else if (ch == '\t') {
                        rt_kprintf("    ");
                    } else {
                        rt_kprintf("\\x%02X", ch);
                    }
                }
            }
            
            total_read += ret;
        }
        rt_kprintf("\n");
    } else {
        rt_kprintf("Failed to get file info\n");
        return -1;
    }
    
    return 0;
}
MSH_CMD_EXPORT_ALIAS(cmd_cat, fcat, display file content in character format);

static int cmd_touch(int argc, char **argv)
{
    u32_t size = 1024;
    s32_t ret;
    
    if (argc < 2) {
        rt_kprintf("Usage: touch <filename> [size]\n");
        return -1;
    }
    
    if (argc >= 3) {
        size = strtoul(argv[2], NULL, 0);
        if (size == 0) {
            size = 1024;
        }
    }
    
    ret = fs_create(argv[1], size);
    if (ret >= 0) {
        rt_kprintf("File '%s' created (size: %d bytes)\n", argv[1], size);
        return 0;
    } else {
        rt_kprintf("Create file failed: %d\n", ret);
        return -1;
    }
}
MSH_CMD_EXPORT_ALIAS(cmd_touch, ftouch, create a file in flash file system);

static int cmd_edit(int argc, char **argv)
{
    fs_file_handle_t handle;
    u08_t *file_buffer = RT_NULL;
    u32_t file_size;
    fs_file_entry_t info;
    s32_t ret;
    u32_t i;
    u32_t data_len;
    
    if (argc < 2) {
        rt_kprintf("Usage: edit <filename> <data_string>\n");
        rt_kprintf("  or:  edit <filename> (to read current content)\n");
        return -1;
    }
    
    if (fs_open(argv[1], &handle) != 0) {
        rt_kprintf("File '%s' not found\n", argv[1]);
        return -1;
    }
    
    if (fs_get_file_info(argv[1], &info) != 0) {
        rt_kprintf("Failed to get file info\n");
        return -1;
    }
    
    file_size = info.size;
    
    if (argc >= 3) {
        data_len = strlen(argv[2]);
        
        if (data_len > file_size) {
            rt_kprintf("Error: data size (%d) exceeds file size (%d)\n", data_len, file_size);
            return -1;
        }
        
        file_buffer = (u08_t *)rt_malloc(file_size);
        if (file_buffer == RT_NULL) {
            rt_kprintf("Failed to allocate memory\n");
            return -1;
        }
        
        memset(file_buffer, 0xFF, file_size);
        memcpy(file_buffer, argv[2], data_len);
        
        if (fs_seek(&handle, 0) != 0) {
            rt_kprintf("Seek failed\n");
            rt_free(file_buffer);
            return -1;
        }
        
        ret = fs_write(&handle, file_buffer, file_size);
        if (ret == file_size) {
            rt_kprintf("File '%s' updated successfully (%d bytes written)\n", argv[1], data_len);
            rt_free(file_buffer);
            return 0;
        } else {
            rt_kprintf("Write failed: wrote %d bytes\n", ret);
            rt_free(file_buffer);
            return -1;
        }
    } else {
        file_buffer = (u08_t *)rt_malloc(file_size);
        if (file_buffer == RT_NULL) {
            rt_kprintf("Failed to allocate memory\n");
            return -1;
        }
        
        if (fs_seek(&handle, 0) != 0) {
            rt_kprintf("Seek failed\n");
            rt_free(file_buffer);
            return -1;
        }
        
        ret = fs_read(&handle, file_buffer, file_size);
        if (ret == file_size) {
            rt_kprintf("Current content of '%s' (%d bytes):\n", argv[1], file_size);
            for (i = 0; i < file_size; i++) {
                u08_t ch = file_buffer[i];
                if (ch >= 32 && ch < 127) {
                    rt_kprintf("%c", ch);
                } else if (ch == '\n') {
                    rt_kprintf("\n");
                } else if (ch == '\r') {
                } else if (ch == '\t') {
                    rt_kprintf("    ");
                } else if (ch == 0xFF) {
                    rt_kprintf(".");
                } else {
                    rt_kprintf("\\x%02X", ch);
                }
            }
            rt_kprintf("\n");
        } else {
            rt_kprintf("Read failed: read %d bytes\n", ret);
        }
        
        rt_free(file_buffer);
        return (ret == file_size) ? 0 : -1;
    }
}
MSH_CMD_EXPORT_ALIAS(cmd_edit, edit, edit file content in flash file system);

