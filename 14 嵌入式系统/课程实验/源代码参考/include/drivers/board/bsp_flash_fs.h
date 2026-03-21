#ifndef __BSP_FLASH_FS_H__
#define __BSP_FLASH_FS_H__

#include "psp_types.h"

#define FS_MAX_FILES           32
#define FS_MAX_FILENAME_LEN    16
#define FS_SECTOR_SIZE         0x10000
#define FS_PAGE_SIZE           256
#define FS_METADATA_SECTOR     0x00000
#define FS_DATA_START_SECTOR   0x10000

#define FS_MAGIC               0x46534653
#define FS_VERSION              1

#define FS_FILE_FREE            0xFF
#define FS_FILE_USED            0x01
#define FS_FILE_DELETED        0x02

typedef struct {
    u08_t status;
    u08_t name[FS_MAX_FILENAME_LEN];
    u32_t size;
    u32_t offset;
    u32_t sector;
} fs_file_entry_t;

typedef struct {
    u32_t magic;
    u32_t version;
    u32_t file_count;
    u32_t free_sectors;
    fs_file_entry_t files[FS_MAX_FILES];
} fs_metadata_t;

typedef struct {
    u32_t file_id;
    u32_t position;
} fs_file_handle_t;

s32_t fs_init(void);
s32_t fs_format(void);
s32_t fs_create(const char *name, u32_t size);
s32_t fs_open(const char *name, fs_file_handle_t *handle);
s32_t fs_read(fs_file_handle_t *handle, void *buffer, u32_t size);
s32_t fs_write(fs_file_handle_t *handle, const void *buffer, u32_t size);
s32_t fs_seek(fs_file_handle_t *handle, u32_t offset);
s32_t fs_delete(const char *name);
s32_t fs_list_files(void);
s32_t fs_get_file_info(const char *name, fs_file_entry_t *info);
u32_t fs_get_free_space(void);

#endif

