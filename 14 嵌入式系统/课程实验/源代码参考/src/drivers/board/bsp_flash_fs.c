#include "bsp_flash_fs.h"
#include "bsp_spi_flash.h"
#include "bsp_printf.h"
#include <string.h>

#include "bsp_mem_map.h"
#define M_SPI_WR_REG(offset, val) (*((volatile u32_t *)(D_SPI_FLASH_BASE_ADDRESS + offset)) = (val))
#define M_SPI_RD_REG(offset) (*((volatile u32_t *)(D_SPI_FLASH_BASE_ADDRESS + offset)))
#define SPI_FLASH_SPSR_OFFSET  0x008
#define SPI_FLASH_DATA_OFFSET  0x010
#define SPI_SPSR_SPIF  (1 << 7)
#define SPI_SPSR_WFFULL  (1 << 3)
#define SPI_SPSR_RFEMPTY (1 << 0)
#define FLASH_CMD_PP       0x02

static fs_metadata_t g_fs_metadata;
static u08_t g_fs_initialized = 0;

static s32_t fs_read_metadata(void)
{
    u32_t i;
    u08_t *p = (u08_t *)&g_fs_metadata;
    for (i = 0; i < sizeof(fs_metadata_t); i++) {
        p[i] = spi_flash_read_data(FS_METADATA_SECTOR + i);
    }
    if (g_fs_metadata.magic != FS_MAGIC) {
        return -1;
    }
    if (g_fs_metadata.version != FS_VERSION) {
        return -1;
    }
    return 0;
}

static s32_t fs_write_metadata(void)
{
    u32_t i, j;
    u08_t *p = (u08_t *)&g_fs_metadata;
    u32_t addr = FS_METADATA_SECTOR;
    u32_t size = sizeof(fs_metadata_t);
    u32_t page_start;
    u32_t page_end;
    u32_t page_addr;
    u32_t written = 0;
    spi_flash_write_enable();
    spi_flash_sector_erase(FS_METADATA_SECTOR);
    spi_flash_wait_ready();
    spi_flash_delay();
    spi_flash_delay();
    page_start = (addr / FS_PAGE_SIZE) * FS_PAGE_SIZE;
    page_end = ((addr + size - 1) / FS_PAGE_SIZE) * FS_PAGE_SIZE;
    for (page_addr = page_start; page_addr <= page_end; page_addr += FS_PAGE_SIZE) {
        u32_t page_offset = written;
        u32_t page_size = FS_PAGE_SIZE;
        if (page_addr == page_start) {
            page_size = FS_PAGE_SIZE - (addr - page_addr);
        }
        if (page_size > size - written) {
            page_size = size - written;
        }
        spi_flash_write_enable();
        spi_flash_cs_select();
        spi_flash_delay();
        spi_flash_write_byte(FLASH_CMD_PP);
        while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
        while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
            (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
        }
        spi_flash_write_byte((page_addr >> 16) & 0xFF);
        while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
        while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
            (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
        }
        spi_flash_write_byte((page_addr >> 8) & 0xFF);
        while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
        while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
            (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
        }
        spi_flash_write_byte(page_addr & 0xFF);
        while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
        while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
            (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
        }
        for (j = 0; j < page_size; j++) {
            while (M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_WFFULL);
            M_SPI_WR_REG(SPI_FLASH_DATA_OFFSET, p[written + j]);
            while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
            while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
                (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
            }
        }
        spi_flash_delay();
        spi_flash_cs_deselect();
        spi_flash_delay();
        spi_flash_delay();
        spi_flash_wait_ready();
        spi_flash_delay();
        written += page_size;
        if (written >= size) {
            break;
        }
    }
    return 0;
}

s32_t fs_init(void)
{
    if (g_fs_initialized) {
        return 0;
    }
    spi_flash_init();
    if (fs_read_metadata() != 0) {
        return fs_format();
    }
    g_fs_initialized = 1;
    return 0;
}

s32_t fs_format(void)
{
    u32_t i;
    if (!g_fs_initialized) {
        spi_flash_init();
    }
    memset(&g_fs_metadata, 0xFF, sizeof(fs_metadata_t));
    g_fs_metadata.magic = FS_MAGIC;
    g_fs_metadata.version = FS_VERSION;
    g_fs_metadata.file_count = 0;
    g_fs_metadata.free_sectors = 255;
    for (i = 0; i < FS_MAX_FILES; i++) {
        g_fs_metadata.files[i].status = FS_FILE_FREE;
        memset(g_fs_metadata.files[i].name, 0, FS_MAX_FILENAME_LEN);
        g_fs_metadata.files[i].size = 0;
        g_fs_metadata.files[i].offset = 0;
        g_fs_metadata.files[i].sector = 0;
    }
    if (fs_write_metadata() != 0) {
        return -1;
    }
    g_fs_initialized = 1;
    return 0;
}

s32_t fs_create(const char *name, u32_t size)
{
    u32_t i;
    u32_t free_sector = FS_DATA_START_SECTOR;
    u32_t file_id = FS_MAX_FILES;
    s32_t ret;
    if (!g_fs_initialized) {
        ret = fs_init();
        if (ret != 0) {
            return -1;
        }
    }
    ret = fs_read_metadata();
    if (ret != 0) {
        ret = fs_format();
        if (ret != 0) {
            return -1;
        }
    }
    for (i = 0; i < FS_MAX_FILES; i++) {
        if (g_fs_metadata.files[i].status == FS_FILE_FREE) {
            file_id = i;
            break;
        }
    }
    if (file_id == FS_MAX_FILES) {
        return -2;
    }
    for (i = 0; i < FS_MAX_FILES; i++) {
        if (g_fs_metadata.files[i].status == FS_FILE_USED) {
            free_sector = g_fs_metadata.files[i].sector + FS_SECTOR_SIZE;
        }
    }
    u32_t sectors_needed = (size + FS_SECTOR_SIZE - 1) / FS_SECTOR_SIZE;
    if (free_sector + sectors_needed * FS_SECTOR_SIZE > 0x1000000) {
        return -3;
    }
    g_fs_metadata.files[file_id].status = FS_FILE_USED;
    strncpy((char *)g_fs_metadata.files[file_id].name, name, FS_MAX_FILENAME_LEN - 1);
    g_fs_metadata.files[file_id].name[FS_MAX_FILENAME_LEN - 1] = 0;
    g_fs_metadata.files[file_id].size = size;
    g_fs_metadata.files[file_id].offset = 0;
    g_fs_metadata.files[file_id].sector = free_sector;
    g_fs_metadata.file_count++;
    g_fs_metadata.free_sectors -= sectors_needed;
    if (fs_write_metadata() != 0) {
        return -1;
    }
    spi_flash_write_enable();
    spi_flash_sector_erase(free_sector);
    spi_flash_wait_ready();
    spi_flash_delay();
    spi_flash_delay();
    return file_id;
}

s32_t fs_open(const char *name, fs_file_handle_t *handle)
{
    u32_t i;
    if (!g_fs_initialized) {
        if (fs_init() != 0) {
            return -1;
        }
    }
    if (fs_read_metadata() != 0) {
        return -1;
    }
    for (i = 0; i < FS_MAX_FILES; i++) {
        if (g_fs_metadata.files[i].status == FS_FILE_USED) {
            if (strcmp((char *)g_fs_metadata.files[i].name, name) == 0) {
                handle->file_id = i;
                handle->position = 0;
                return 0;
            }
        }
    }
    return -2;
}

s32_t fs_read(fs_file_handle_t *handle, void *buffer, u32_t size)
{
    u32_t i;
    u08_t *buf = (u08_t *)buffer;
    fs_file_entry_t *file;
    if (!g_fs_initialized) {
        return -1;
    }
    if (fs_read_metadata() != 0) {
        return -1;
    }
    if (handle->file_id >= FS_MAX_FILES) {
        return -2;
    }
    file = &g_fs_metadata.files[handle->file_id];
    if (file->status != FS_FILE_USED) {
        return -3;
    }
    if (handle->position + size > file->size) {
        size = file->size - handle->position;
    }
    for (i = 0; i < size; i++) {
        buf[i] = spi_flash_read_data(file->sector + file->offset + handle->position + i);
    }
    handle->position += size;
    return size;
}

s32_t fs_write(fs_file_handle_t *handle, const void *buffer, u32_t size)
{
    u32_t i, j;
    u08_t *buf = (u08_t *)buffer;
    fs_file_entry_t *file;
    u32_t addr;
    u32_t page_start;
    u32_t page_end;
    u32_t page_addr;
    u32_t written = 0;
    if (!g_fs_initialized) {
        return -1;
    }
    if (fs_read_metadata() != 0) {
        return -1;
    }
    if (handle->file_id >= FS_MAX_FILES) {
        return -2;
    }
    file = &g_fs_metadata.files[handle->file_id];
    if (file->status != FS_FILE_USED) {
        return -3;
    }
    if (handle->position + size > file->size) {
        size = file->size - handle->position;
    }
    addr = file->sector + file->offset + handle->position;
    page_start = (addr / FS_PAGE_SIZE) * FS_PAGE_SIZE;
    page_end = ((addr + size - 1) / FS_PAGE_SIZE) * FS_PAGE_SIZE;
    for (page_addr = page_start; page_addr <= page_end; page_addr += FS_PAGE_SIZE) {
        u32_t page_offset = addr + written - page_addr;
        u32_t page_size = FS_PAGE_SIZE - page_offset;
        if (page_size > size - written) {
            page_size = size - written;
        }
        spi_flash_write_enable();
        spi_flash_cs_select();
        spi_flash_delay();
        spi_flash_write_byte(FLASH_CMD_PP);
        while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
        while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
            (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
        }
        spi_flash_write_byte((page_addr >> 16) & 0xFF);
        while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
        while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
            (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
        }
        spi_flash_write_byte((page_addr >> 8) & 0xFF);
        while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
        while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
            (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
        }
        spi_flash_write_byte(page_addr & 0xFF);
        while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
        while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
            (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
        }
        for (j = 0; j < page_size; j++) {
            while (M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_WFFULL);
            M_SPI_WR_REG(SPI_FLASH_DATA_OFFSET, buf[written + j]);
            while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
            while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
                (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
            }
        }
        spi_flash_delay();
        spi_flash_cs_deselect();
        spi_flash_delay();
        spi_flash_delay();
        spi_flash_wait_ready();
        spi_flash_delay();
        written += page_size;
        if (written >= size) {
            break;
        }
    }
    handle->position += written;
    return written;
}

s32_t fs_seek(fs_file_handle_t *handle, u32_t offset)
{
    if (!g_fs_initialized) {
        return -1;
    }
    if (fs_read_metadata() != 0) {
        return -1;
    }
    if (handle->file_id >= FS_MAX_FILES) {
        return -2;
    }
    if (offset > g_fs_metadata.files[handle->file_id].size) {
        return -3;
    }
    handle->position = offset;
    return 0;
}

s32_t fs_delete(const char *name)
{
    u32_t i;
    if (!g_fs_initialized) {
        if (fs_init() != 0) {
            return -1;
        }
    }
    if (fs_read_metadata() != 0) {
        return -1;
    }
    for (i = 0; i < FS_MAX_FILES; i++) {
        if (g_fs_metadata.files[i].status == FS_FILE_USED) {
            if (strcmp((char *)g_fs_metadata.files[i].name, name) == 0) {
                g_fs_metadata.files[i].status = FS_FILE_DELETED;
                g_fs_metadata.file_count--;
                if (fs_write_metadata() != 0) {
                    return -1;
                }
                return 0;
            }
        }
    }
    return -2;
}

s32_t fs_list_files(void)
{
    u32_t i;
    if (!g_fs_initialized) {
        if (fs_init() != 0) {
            return -1;
        }
    } else {
        if (fs_read_metadata() != 0) {
            return -1;
        }
    }
    printfNexys("\n=== Flash File System ===\n");
    printfNexys("Total files: %d\n", g_fs_metadata.file_count);
    printfNexys("Free sectors: %d\n", g_fs_metadata.free_sectors);
    printfNexys("\nFile List:\n");
    printfNexys("%-16s %10s %10s\n", "Name", "Size", "Sector");
    printfNexys("----------------------------------------\n");
    for (i = 0; i < FS_MAX_FILES; i++) {
        if (g_fs_metadata.files[i].status == FS_FILE_USED) {
            printfNexys("%-16s %10d %10X\n", 
                g_fs_metadata.files[i].name,
                g_fs_metadata.files[i].size,
                g_fs_metadata.files[i].sector);
        }
    }
    return 0;
}

s32_t fs_get_file_info(const char *name, fs_file_entry_t *info)
{
    u32_t i;
    if (!g_fs_initialized) {
        if (fs_init() != 0) {
            return -1;
        }
    }
    if (fs_read_metadata() != 0) {
        return -1;
    }
    for (i = 0; i < FS_MAX_FILES; i++) {
        if (g_fs_metadata.files[i].status == FS_FILE_USED) {
            if (strcmp((char *)g_fs_metadata.files[i].name, name) == 0) {
                *info = g_fs_metadata.files[i];
                return 0;
            }
        }
    }
    return -2;
}

u32_t fs_get_free_space(void)
{
    if (!g_fs_initialized) {
        if (fs_init() != 0) {
            return 0;
        }
    }
    if (fs_read_metadata() != 0) {
        return 0;
    }
    return g_fs_metadata.free_sectors * FS_SECTOR_SIZE;
}

