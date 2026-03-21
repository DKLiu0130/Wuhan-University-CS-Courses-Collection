#include "bsp_flash_fs.h"
#include "bsp_printf.h"
#include <rtthread.h>
#include <string.h>
#include <stdlib.h>

static int cmd_fs_format(int argc, char **argv)
{
    s32_t ret;
    rt_kprintf("Formatting Flash file system...\n");
    ret = fs_format();
    if (ret == 0) {
        rt_kprintf("File system formatted successfully.\n");
        return 0;
    } else {
        rt_kprintf("Format failed: %d\n", ret);
        return -1;
    }
}

MSH_CMD_EXPORT_ALIAS(cmd_fs_format, fformat, format flash file system);

static int cmd_fs_list(int argc, char **argv)
{
    s32_t ret;
    ret = fs_list_files();
    if (ret != 0) {
        rt_kprintf("List files failed: %d\n", ret);
        return -1;
    }
    return 0;
}

static int cmd_fs_create(int argc, char **argv)
{
    s32_t ret;
    u32_t size;
    if (argc < 3) {
        rt_kprintf("Usage: fs_create <filename> <size>\n");
        return -1;
    }
    size = strtoul(argv[2], NULL, 0);
    rt_kprintf("Creating file '%s' with size %d bytes...\n", argv[1], size);
    ret = fs_create(argv[1], size);
    if (ret >= 0) {
        rt_kprintf("File created successfully with ID: %d\n", ret);
        return 0;
    } else {
        rt_kprintf("Create file failed: %d\n", ret);
        return -1;
    }
}

static int cmd_fs_write(int argc, char **argv)
{
    s32_t ret;
    fs_file_handle_t handle;
    u08_t *buffer;
    u32_t size, i;
    if (argc < 3) {
        rt_kprintf("Usage: fs_write <filename> <data_string>\n");
        return -1;
    }
    if (fs_open(argv[1], &handle) != 0) {
        rt_kprintf("Open file failed!\n");
        return -1;
    }
    size = strlen(argv[2]);
    buffer = (u08_t *)argv[2];
    rt_kprintf("Writing %d bytes to file '%s'...\n", size, argv[1]);
    ret = fs_write(&handle, buffer, size);
    if (ret == size) {
        rt_kprintf("Write successful: %d bytes written.\n", ret);
        return 0;
    } else {
        rt_kprintf("Write failed: wrote %d bytes\n", ret);
        return -1;
    }
}

static int cmd_fs_read(int argc, char **argv)
{
    s32_t ret;
    fs_file_handle_t handle;
    u08_t buffer[256];
    u32_t size = 256;
    u32_t i;
    if (argc < 2) {
        rt_kprintf("Usage: fs_read <filename> [size]\n");
        return -1;
    }
    if (argc >= 3) {
        size = strtoul(argv[2], NULL, 0);
        if (size > 256) {
            size = 256;
        }
    }
    if (fs_open(argv[1], &handle) != 0) {
        rt_kprintf("Open file failed!\n");
        return -1;
    }
    memset(buffer, 0, 256);
    rt_kprintf("Reading %d bytes from file '%s'...\n", size, argv[1]);
    ret = fs_read(&handle, buffer, size);
    if (ret > 0) {
        rt_kprintf("Read successful: %d bytes read.\n", ret);
        rt_kprintf("Data: ");
        for (i = 0; i < ret; i++) {
            if (buffer[i] >= 32 && buffer[i] < 127) {
                rt_kprintf("%c", buffer[i]);
            } else {
                rt_kprintf("\\x%02X", buffer[i]);
            }
        }
        rt_kprintf("\n");
        return 0;
    } else {
        rt_kprintf("Read failed: %d\n", ret);
        return -1;
    }
}

static int cmd_fs_delete(int argc, char **argv)
{
    s32_t ret;
    if (argc < 2) {
        rt_kprintf("Usage: fs_delete <filename>\n");
        return -1;
    }
    rt_kprintf("Deleting file '%s'...\n", argv[1]);
    ret = fs_delete(argv[1]);
    if (ret == 0) {
        rt_kprintf("File deleted successfully.\n");
        return 0;
    } else {
        rt_kprintf("Delete failed: %d\n", ret);
        return -1;
    }
}

static int cmd_fs_info(int argc, char **argv)
{
    fs_file_entry_t info;
    s32_t ret;
    if (argc < 2) {
        rt_kprintf("Usage: fs_info <filename>\n");
        return -1;
    }
    ret = fs_get_file_info(argv[1], &info);
    if (ret == 0) {
        rt_kprintf("File: %s\n", info.name);
        rt_kprintf("Size: %d bytes\n", info.size);
        rt_kprintf("Sector: 0x%08X\n", info.sector);
        rt_kprintf("Offset: 0x%08X\n", info.offset);
        return 0;
    } else {
        rt_kprintf("Get file info failed: %d\n", ret);
        return -1;
    }
}

static int cmd_fs_free(int argc, char **argv)
{
    u32_t free_space;
    if (fs_init() != 0) {
        rt_kprintf("File system init failed!\n");
        return -1;
    }
    free_space = fs_get_free_space();
    rt_kprintf("Free space: %d bytes (%.2f KB)\n", free_space, free_space / 1024.0);
    return 0;
}

static int cmd_fs_test(int argc, char **argv)
{
    fs_file_handle_t handle;
    u08_t write_buf[64];
    u08_t read_buf[64];
    u32_t i;
    s32_t ret;
    
    rt_kprintf("\n=== Flash File System Test ===\n");
    
    if (fs_init() != 0) {
        rt_kprintf("FS init failed, formatting...\n");
        if (fs_format() != 0) {
            rt_kprintf("FS format failed!\n");
            return -1;
        }
        rt_kprintf("FS formatted successfully.\n");
    } else {
        rt_kprintf("FS initialized successfully.\n");
    }
    
    fs_list_files();
    
    rt_kprintf("\n--- Creating test file 'test.txt' ---\n");
    ret = fs_create("test.txt", 64);
    if (ret < 0) {
        rt_kprintf("Create file failed: %d\n", ret);
        rt_kprintf("Trying to format file system first...\n");
        if (fs_format() != 0) {
            rt_kprintf("Format failed!\n");
            return -1;
        }
        rt_kprintf("Format successful, retrying create...\n");
        ret = fs_create("test.txt", 64);
        if (ret < 0) {
            rt_kprintf("Create file failed again: %d\n", ret);
            return -1;
        }
    }
    rt_kprintf("File created with ID: %d\n", ret);
    
    for (i = 0; i < 64; i++) {
        write_buf[i] = 'A' + (i % 26);
    }
    
    rt_kprintf("\n--- Opening file 'test.txt' ---\n");
    if (fs_open("test.txt", &handle) != 0) {
        rt_kprintf("Open file failed!\n");
        return -1;
    }
    rt_kprintf("File opened successfully.\n");
    
    rt_kprintf("\n--- Writing data to file ---\n");
    ret = fs_write(&handle, write_buf, 64);
    if (ret != 64) {
        rt_kprintf("Write failed: wrote %d bytes\n", ret);
        return -1;
    }
    rt_kprintf("Wrote %d bytes successfully.\n", ret);
    
    rt_kprintf("\n--- Seeking to beginning ---\n");
    if (fs_seek(&handle, 0) != 0) {
        rt_kprintf("Seek failed!\n");
        return -1;
    }
    
    rt_kprintf("\n--- Reading data from file ---\n");
    memset(read_buf, 0, 64);
    ret = fs_read(&handle, read_buf, 64);
    if (ret != 64) {
        rt_kprintf("Read failed: read %d bytes\n", ret);
        return -1;
    }
    rt_kprintf("Read %d bytes successfully.\n", ret);
    rt_kprintf("Data: ");
    for (i = 0; i < 64; i++) {
        rt_kprintf("%c", read_buf[i]);
    }
    rt_kprintf("\n");
    
    rt_kprintf("\n--- Verifying data ---\n");
    if (memcmp(write_buf, read_buf, 64) == 0) {
        rt_kprintf("Data verification PASSED!\n");
    } else {
        rt_kprintf("Data verification FAILED!\n");
    }
    
    rt_kprintf("\n--- File list after operations ---\n");
    fs_list_files();
    
    rt_kprintf("\n--- Free space ---\n");
    rt_kprintf("Free space: %d bytes\n", fs_get_free_space());
    
    rt_kprintf("\n=== Test Complete ===\n\n");
    return 0;
}
