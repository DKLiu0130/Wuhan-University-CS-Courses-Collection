#ifndef __BSP_SPI_FLASH_H__
#define __BSP_SPI_FLASH_H__

#include "bsp_mem_map.h"
#include "psp_types.h"

#define SPI_FLASH_BASE D_SPI_FLASH_BASE_ADDRESS

#define SPI_FLASH_SPCR_OFFSET  0x000
#define SPI_FLASH_SPSR_OFFSET  0x008
#define SPI_FLASH_DATA_OFFSET  0x010
#define SPI_FLASH_SPER_OFFSET  0x018
#define SPI_FLASH_SS_OFFSET    0x020

#define SPI_FLASH_SPCR (SPI_FLASH_BASE + SPI_FLASH_SPCR_OFFSET)
#define SPI_FLASH_SPSR (SPI_FLASH_BASE + SPI_FLASH_SPSR_OFFSET)
#define SPI_FLASH_DATA (SPI_FLASH_BASE + SPI_FLASH_DATA_OFFSET)
#define SPI_FLASH_SPER (SPI_FLASH_BASE + SPI_FLASH_SPER_OFFSET)
#define SPI_FLASH_SS   (SPI_FLASH_BASE + SPI_FLASH_SS_OFFSET)

#define M_SPI_WR_REG32(addr, val) (*((volatile u32_t *)(addr)) = (val))
#define M_SPI_RD_REG32(addr) (*((volatile u32_t *)(addr)))

#define SPI_SPCR_SPIE (1 << 7)
#define SPI_SPCR_SPE  (1 << 6)
#define SPI_SPCR_MSTR (1 << 4)
#define SPI_SPCR_CPOL (1 << 3)
#define SPI_SPCR_CPHA (1 << 2)

#define SPI_SPSR_SPIF  (1 << 7)
#define SPI_SPSR_WCOL  (1 << 6)
#define SPI_SPSR_WFFULL  (1 << 3)
#define SPI_SPSR_WFEMPTY (1 << 2)
#define SPI_SPSR_RFFULL  (1 << 1)
#define SPI_SPSR_RFEMPTY (1 << 0)

#define FLASH_CMD_RDID     0x9F
#define FLASH_CMD_READ     0x03
#define FLASH_CMD_WREN     0x06
#define FLASH_CMD_WRDI     0x04
#define FLASH_CMD_RDSR     0x05
#define FLASH_CMD_WRSR     0x01
#define FLASH_CMD_PP       0x02
#define FLASH_CMD_SE       0xD8
#define FLASH_CMD_BE       0xC7
#define FLASH_CMD_DP       0xB9
#define FLASH_CMD_RDP      0xAB

#define FLASH_SR_WIP       (1 << 0)
#define FLASH_SR_WEL       (1 << 1)

#define FLASH_TEST_ADDR    0x10000

void spi_flash_init(void);
void spi_flash_delay(void);
u08_t spi_flash_read_byte(void);
void spi_flash_write_byte(u08_t data);
void spi_flash_wait_ready(void);
u08_t spi_flash_read_status(void);
void spi_flash_write_enable(void);
void spi_flash_cs_select(void);
void spi_flash_cs_deselect(void);
u32_t spi_flash_read_id(void);
u08_t spi_flash_read_data(u32_t addr);
void spi_flash_write_data(u32_t addr, u08_t data);
void spi_flash_sector_erase(u32_t addr);
void spi_flash_chip_erase(void);
u32_t flash_storage_read(void);
void flash_storage_write(u32_t value);

#endif

