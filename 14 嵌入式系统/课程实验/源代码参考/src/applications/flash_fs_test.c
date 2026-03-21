#include "bsp_flash_fs.h"
#include "bsp_printf.h"

void flash_fs_test(void)
{
    fs_file_handle_t handle;
    u08_t write_buf[64];
    u08_t read_buf[64];
    u32_t i;
    s32_t ret;
    
    printfNexys("\n=== Flash File System Test ===\n");
    
    if (fs_init() != 0) {
        printfNexys("FS init failed, formatting...\n");
        if (fs_format() != 0) {
            printfNexys("FS format failed!\n");
            return;
        }
        printfNexys("FS formatted successfully.\n");
    } else {
        printfNexys("FS initialized successfully.\n");
    }
    
    fs_list_files();
    
    printfNexys("\n--- Creating test file 'test.txt' ---\n");
    ret = fs_create("test.txt", 64);
    if (ret < 0) {
        printfNexys("Create file failed: %d\n", ret);
        return;
    }
    printfNexys("File created with ID: %d\n", ret);
    
    for (i = 0; i < 64; i++) {
        write_buf[i] = 'A' + (i % 26);
    }
    
    printfNexys("\n--- Opening file 'test.txt' ---\n");
    if (fs_open("test.txt", &handle) != 0) {
        printfNexys("Open file failed!\n");
        return;
    }
    printfNexys("File opened successfully.\n");
    
    printfNexys("\n--- Writing data to file ---\n");
    ret = fs_write(&handle, write_buf, 64);
    if (ret != 64) {
        printfNexys("Write failed: wrote %d bytes\n", ret);
        return;
    }
    printfNexys("Wrote %d bytes successfully.\n", ret);
    
    printfNexys("\n--- Seeking to beginning ---\n");
    if (fs_seek(&handle, 0) != 0) {
        printfNexys("Seek failed!\n");
        return;
    }
    
    printfNexys("\n--- Reading data from file ---\n");
    memset(read_buf, 0, 64);
    ret = fs_read(&handle, read_buf, 64);
    if (ret != 64) {
        printfNexys("Read failed: read %d bytes\n", ret);
        return;
    }
    printfNexys("Read %d bytes successfully.\n", ret);
    printfNexys("Data: ");
    for (i = 0; i < 64; i++) {
        printfNexys("%c", read_buf[i]);
    }
    printfNexys("\n");
    
    printfNexys("\n--- Verifying data ---\n");
    if (memcmp(write_buf, read_buf, 64) == 0) {
        printfNexys("Data verification PASSED!\n");
    } else {
        printfNexys("Data verification FAILED!\n");
    }
    
    printfNexys("\n--- File list after operations ---\n");
    fs_list_files();
    
    printfNexys("\n--- Free space ---\n");
    printfNexys("Free space: %d bytes\n", fs_get_free_space());
    
    printfNexys("\n=== Test Complete ===\n\n");
}

