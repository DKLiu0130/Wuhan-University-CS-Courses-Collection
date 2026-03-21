#include "bsp_spi_flash.h"
#include "psp_api.h"
#include "bsp_printf.h"

#define M_SPI_WR_REG(offset, val) (*((volatile u32_t *)(SPI_FLASH_BASE + offset)) = (val))
#define M_SPI_RD_REG(offset) (*((volatile u32_t *)(SPI_FLASH_BASE + offset)))

void spi_flash_delay(void)
{
    volatile int i;
    for (i = 0; i < 1000; i++);
}

static void spi_flash_release_power_down(void)
{
    spi_flash_cs_select();
    spi_flash_write_byte(FLASH_CMD_RDP);
    spi_flash_cs_deselect();
    spi_flash_delay();
    spi_flash_delay();
}

static void spi_flash_flush_fifo(void)
{
    while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
        (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
    }
}

void spi_flash_init(void)
{
    M_SPI_WR_REG(SPI_FLASH_SPCR_OFFSET, SPI_SPCR_SPE | SPI_SPCR_MSTR | 0x03);
    M_SPI_WR_REG(SPI_FLASH_SPER_OFFSET, 0x00);
    M_SPI_WR_REG(SPI_FLASH_SS_OFFSET, 0x00);
    spi_flash_delay();
    spi_flash_delay();
    spi_flash_delay();
    
    spi_flash_release_power_down();
}

void spi_flash_cs_select(void)
{
    M_SPI_WR_REG(SPI_FLASH_SS_OFFSET, 0x01);
    spi_flash_delay();
}

void spi_flash_cs_deselect(void)
{
    M_SPI_WR_REG(SPI_FLASH_SS_OFFSET, 0x00);
    spi_flash_delay();
}

u08_t spi_flash_read_byte(void)
{
    u08_t data;
    u32_t status;
    while (M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_WFFULL);
    M_SPI_WR_REG(SPI_FLASH_DATA_OFFSET, 0xFF);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    while (M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY);
    data = (u08_t)(M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET) & 0xFF);
    status = M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET);
    M_SPI_WR_REG(SPI_FLASH_SPSR_OFFSET, status & 0x7F);
    return data;
}

void spi_flash_write_byte(u08_t data)
{
    while (M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_WFFULL);
    M_SPI_WR_REG(SPI_FLASH_DATA_OFFSET, data);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
}

static u08_t spi_flash_read_byte_after_write(void)
{
    u08_t data;
    u32_t status;
    while (M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY);
    data = (u08_t)(M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET) & 0xFF);
    status = M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET);
    M_SPI_WR_REG(SPI_FLASH_SPSR_OFFSET, status & 0x7F);
    return data;
}

void spi_flash_wait_ready(void)
{
    u08_t status;
    u32_t timeout = 0;
    do {
        spi_flash_delay();
        spi_flash_delay();
        spi_flash_flush_fifo();
        spi_flash_cs_select();
        spi_flash_delay();
        spi_flash_write_byte(FLASH_CMD_RDSR);
        (void)spi_flash_read_byte_after_write();
        status = spi_flash_read_byte();
        spi_flash_cs_deselect();
        spi_flash_delay();
        timeout++;
        if (timeout > 1000000) {
            break;
        }
    } while (status & FLASH_SR_WIP);
}

u08_t spi_flash_read_status(void)
{
    u08_t status;
    spi_flash_flush_fifo();
    spi_flash_cs_select();
    spi_flash_write_byte(FLASH_CMD_RDSR);
    (void)spi_flash_read_byte_after_write();
    status = spi_flash_read_byte();
    spi_flash_cs_deselect();
    return status;
}


void spi_flash_write_enable(void)
{
    spi_flash_flush_fifo();
    spi_flash_cs_select();
    spi_flash_delay();
    spi_flash_write_byte(FLASH_CMD_WREN);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    spi_flash_delay();
    spi_flash_cs_deselect();
    spi_flash_delay();
    spi_flash_delay();
}

u32_t spi_flash_read_id(void)
{
    u32_t id = 0;
    spi_flash_flush_fifo();
    spi_flash_cs_select();
    spi_flash_write_byte(FLASH_CMD_RDID);
    (void)spi_flash_read_byte_after_write();
    id = (u32_t)spi_flash_read_byte() << 16;
    id |= (u32_t)spi_flash_read_byte() << 8;
    id |= (u32_t)spi_flash_read_byte();
    spi_flash_cs_deselect();
    return id;
}

u08_t spi_flash_read_data(u32_t addr)
{
    u08_t data;
    spi_flash_flush_fifo();
    spi_flash_cs_select();
    spi_flash_delay();
    spi_flash_write_byte(FLASH_CMD_READ);
    (void)spi_flash_read_byte_after_write();
    spi_flash_write_byte((addr >> 16) & 0xFF);
    (void)spi_flash_read_byte_after_write();
    spi_flash_write_byte((addr >> 8) & 0xFF);
    (void)spi_flash_read_byte_after_write();
    spi_flash_write_byte(addr & 0xFF);
    (void)spi_flash_read_byte_after_write();
    spi_flash_delay();
    spi_flash_delay();
    data = spi_flash_read_byte();
    spi_flash_cs_deselect();
    return data;
}

void spi_flash_write_data(u32_t addr, u08_t data)
{
    spi_flash_write_enable();
    spi_flash_cs_select();
    spi_flash_write_byte(FLASH_CMD_PP);
    spi_flash_write_byte((addr >> 16) & 0xFF);
    spi_flash_write_byte((addr >> 8) & 0xFF);
    spi_flash_write_byte(addr & 0xFF);
    spi_flash_write_byte(data);
    spi_flash_cs_deselect();
    spi_flash_wait_ready();
}

void spi_flash_sector_erase(u32_t addr)
{
    u08_t status;
    spi_flash_write_enable();
    spi_flash_delay();
    status = spi_flash_read_status();
    if (!(status & FLASH_SR_WEL)) {
        spi_flash_write_enable();
        spi_flash_delay();
    }
    spi_flash_flush_fifo();
    spi_flash_cs_select();
    spi_flash_delay();
    spi_flash_write_byte(FLASH_CMD_SE);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    spi_flash_write_byte((addr >> 16) & 0xFF);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    spi_flash_write_byte((addr >> 8) & 0xFF);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    spi_flash_write_byte(addr & 0xFF);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    spi_flash_delay();
    spi_flash_cs_deselect();
    spi_flash_delay();
    spi_flash_wait_ready();
    spi_flash_delay();
    spi_flash_delay();
}

void spi_flash_chip_erase(void)
{
    spi_flash_write_enable();
    spi_flash_cs_select();
    spi_flash_write_byte(FLASH_CMD_BE);
    spi_flash_cs_deselect();
    spi_flash_wait_ready();
}

u32_t flash_storage_read(void)
{
    u32_t value = 0;
    u08_t i;
    for (i = 0; i < 4; i++) {
        value |= ((u32_t)spi_flash_read_data(FLASH_TEST_ADDR + i)) << (i * 8);
    }
    return value;
}

void flash_storage_write(u32_t value)
{
    u32_t addr = FLASH_TEST_ADDR;
    u08_t i;
    u08_t status;
    spi_flash_write_enable();
    status = spi_flash_read_status();
    if (!(status & FLASH_SR_WEL)) {
        spi_flash_write_enable();
        spi_flash_delay();
    }
    spi_flash_sector_erase(addr & 0xFF0000);
    spi_flash_wait_ready();
    spi_flash_delay();
    spi_flash_delay();
    status = spi_flash_read_status();
    if (status & FLASH_SR_WIP) {
        spi_flash_wait_ready();
    }
    spi_flash_write_enable();
    spi_flash_delay();
    status = spi_flash_read_status();
    if (!(status & FLASH_SR_WEL)) {
        return;
    }
    spi_flash_flush_fifo();
    spi_flash_cs_select();
    spi_flash_delay();
    spi_flash_write_byte(FLASH_CMD_PP);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
        (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
    }
    spi_flash_write_byte((addr >> 16) & 0xFF);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
        (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
    }
    spi_flash_write_byte((addr >> 8) & 0xFF);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
        (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
    }
    spi_flash_write_byte(addr & 0xFF);
    while ((M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_SPIF) == 0);
    while (!(M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_RFEMPTY)) {
        (void)M_SPI_RD_REG(SPI_FLASH_DATA_OFFSET);
    }
    for (i = 0; i < 4; i++) {
        while (M_SPI_RD_REG(SPI_FLASH_SPSR_OFFSET) & SPI_SPSR_WFFULL);
        M_SPI_WR_REG(SPI_FLASH_DATA_OFFSET, (value >> (i * 8)) & 0xFF);
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
    spi_flash_delay();
}

