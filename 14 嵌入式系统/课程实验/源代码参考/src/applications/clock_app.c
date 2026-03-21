#include <rtthread.h>
#include <rthw.h>
#include "appdef.h"
#include "board.h"
#include "bsp_external_interrupts.h"
#include "psp_ext_interrupts_eh1.h"
#include "psp_api.h"
#include "bsp_flash_fs.h"
#include "crypto.h"
#include <string.h>

#define RGPIO_INTE      0x8000140C
#define RGPIO_PTRIG     0x80001410
#define RGPIO_CTRL      0x80001418
#define RGPIO_INTS      0x8000141C
#define Select_INT      0x80001018

#define SW_MODE_SWITCH       0
#define SW_SET_MODE          1
#define SW_ALARM_TOGGLE      2
#define SW_SET_ALARM         3
#define SW_SEL_NEXT          4
#define SW_INC               5
#define SW_DEC               6
#define SW_EXIT              7
#define SW_AUTO_SAVE         8
#define SW_LOAD_TIME         9
#define SW_12_24_SWITCH     10
#define SW_SAVE_TIME        11

typedef enum {
    DISPLAY_TIME = 0,
    DISPLAY_DATE = 1
} display_mode_t;

typedef enum {
    SET_NONE = 0,
    SET_YEAR = 1,
    SET_MONTH = 2,
    SET_DAY = 3,
    SET_HOUR = 4,
    SET_MINUTE = 5,
    SET_SECOND = 6
} set_item_t;

// 全局时间变量（由时钟中断累加）
static rt_uint16_t g_clock_year = 2025;
static rt_uint8_t g_clock_month = 1;
static rt_uint8_t g_clock_day = 1;
static rt_uint8_t g_clock_hour = 0;
static rt_uint8_t g_clock_minute = 0;
static rt_uint8_t g_clock_second = 0;
static struct rt_mutex g_clock_time_mutex;
static rt_bool_t g_clock_time_mutex_inited = RT_FALSE;
static struct rt_mutex g_clock_app_mutex;
static rt_bool_t g_clock_app_mutex_inited = RT_FALSE;
static rt_bool_t g_clock_paused = RT_FALSE;

// 全局显示模式（可在中断中使用）
static display_mode_t g_display_mode = DISPLAY_TIME;
static rt_bool_t g_is_12hour = RT_FALSE;
static rt_bool_t g_in_alarm_set_mode = RT_FALSE;
static rt_uint8_t g_alarm_hour = 0;
static rt_uint8_t g_alarm_minute = 0;
static rt_bool_t g_auto_save_enabled = RT_FALSE;
static rt_uint8_t g_last_save_second = 255;
static rt_bool_t g_auto_save_pending = RT_FALSE;

// 全局时间更新函数（由时钟中断调用）
void global_clock_update_second(void);
void global_clock_update_display(void);

typedef struct {
    rt_bool_t is_12hour;
    rt_bool_t alarm_enabled;
    rt_uint8_t alarm_hour;
    rt_uint8_t alarm_minute;
    display_mode_t display_mode;
    rt_bool_t in_set_mode;
    rt_bool_t in_alarm_set_mode;
    set_item_t set_item;
    rt_uint16_t last_sw_state;
    rt_bool_t initialized;
    rt_bool_t auto_save_enabled;
} clock_app_t;

static clock_app_t clock;
static rt_bool_t clock_running = RT_FALSE;

static const rt_uint8_t sm4_time_key[SM4_KEY_SIZE] = {
    0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
    0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10
};


static rt_uint8_t password_hash[SM3_HASH_SIZE];

static rt_uint8_t password_hash_read(void)
{
    fs_file_handle_t handle;
    if (fs_init() != 0) return 1;
    if (fs_get_free_space() == FS_SECTOR_SIZE * 255) {
        fs_file_entry_t info;
        if (fs_get_file_info("_pwd_guard", &info) != 0) fs_create("_pwd_guard", 1);
        if (fs_get_file_info("_pwd", &info) != 0) fs_create("_pwd", SM3_HASH_SIZE);
        if (fs_get_file_info("_time_guard", &info) != 0) fs_create("_time_guard", 1);
        if (fs_get_file_info("time", &info) != 0) fs_create("time", SM4_BLOCK_SIZE);
    }
    if (fs_open("_pwd", &handle) != 0) {
        return 1;
    }
    
    fs_file_entry_t info;
    if (fs_get_file_info("_pwd", &info) != 0 || info.size != SM3_HASH_SIZE) {
        return 1;
    }
    
    rt_uint8_t stored_hash[SM3_HASH_SIZE];
    if (fs_seek(&handle, 0) == 0) {
        if (fs_read(&handle, stored_hash, SM3_HASH_SIZE) == SM3_HASH_SIZE) {
            rt_uint32_t is_all_ff = 1;
            for (rt_uint32_t i = 0; i < SM3_HASH_SIZE; i++) {
                if (stored_hash[i] != 0xFF) {
                    is_all_ff = 0;
                    break;
                }
            }
            if (!is_all_ff) {
                memcpy(password_hash, stored_hash, SM3_HASH_SIZE);
                return 0;
            }
        }
    }
    return 1;
}

static rt_uint8_t password_hash_save(void)
{
    fs_file_handle_t handle;
    
    if (fs_init() != 0) return 1;
    
    if (fs_open("_pwd", &handle) == 0) {
        fs_delete("_pwd");
    }
    
    if (fs_open("_pwd_guard", &handle) != 0) {
        fs_create("_pwd_guard", 1);
    }
    
    if (fs_create("_pwd", SM3_HASH_SIZE) < 0) {
        return 1;
    }
    
    if (fs_open("_pwd", &handle) != 0) {
        return 1;
    }
    
    if (fs_seek(&handle, 0) == 0) {
        if (fs_write(&handle, password_hash, SM3_HASH_SIZE) == SM3_HASH_SIZE) {
            return 0;
        }
    }
    return 1;
}

static rt_uint8_t password_verify(const char *password)
{
    rt_uint8_t computed_hash[SM3_HASH_SIZE];
    sm3_hash((rt_uint8_t *)password, strlen(password), computed_hash);
    return (memcmp(computed_hash, password_hash, SM3_HASH_SIZE) == 0) ? 0 : 1;
}

static rt_uint8_t password_init(void)
{
    if (password_hash_read() == 0) {
        return 0;
    }
    
    const char *default_password = "111111";
    sm3_hash((rt_uint8_t *)default_password, strlen(default_password), password_hash);
    return password_hash_save();
}

static void save_time_to_file(void)
{
    rt_uint16_t year;
    rt_uint8_t month, day, hour, minute, second;
    
    rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
    year = g_clock_year;
    month = g_clock_month;
    day = g_clock_day;
    hour = g_clock_hour;
    minute = g_clock_minute;
    second = g_clock_second;
    rt_mutex_release(&g_clock_time_mutex);
    
    if (fs_init() != 0) return;
    
    fs_file_handle_t handle;
    rt_uint8_t time_data[8];
    rt_uint8_t plaintext[SM4_BLOCK_SIZE];
    rt_uint8_t ciphertext[SM4_BLOCK_SIZE];
    
    time_data[0] = (rt_uint8_t)(year & 0xFF);
    time_data[1] = (rt_uint8_t)((year >> 8) & 0xFF);
    time_data[2] = month;
    time_data[3] = day;
    time_data[4] = hour;
    time_data[5] = minute;
    time_data[6] = second;
    time_data[7] = 0;
    
    memcpy(plaintext, time_data, 8);
    memset(plaintext + 8, 0, SM4_BLOCK_SIZE - 8);
    
    sm4_encrypt(plaintext, sm4_time_key, ciphertext);
    
    if (fs_open("_time_guard", &handle) != 0) {
        fs_create("_time_guard", 1);
    }
    
    if (fs_open("time", &handle) == 0) {
        fs_delete("time");
    }
    
    if (fs_create("time", SM4_BLOCK_SIZE) < 0) {
        return;
    }
    
    if (fs_open("time", &handle) != 0) {
        return;
    }
    
    if (fs_seek(&handle, 0) == 0) {
        if (fs_write(&handle, ciphertext, SM4_BLOCK_SIZE) == SM4_BLOCK_SIZE) {
        }
    }
}

// 全局时间更新函数（由时钟中断调用，每秒调用一次）
void global_clock_update_second(void)
{
    if (!g_clock_time_mutex_inited) {
        return;
    }
    
    // 如果时间暂停，不更新时间
    if (g_clock_paused) {
        return;
    }
    
    rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
    
    g_clock_second++;
    if (g_clock_second >= 60) {
        g_clock_second = 0;
        g_clock_minute++;
        if (g_clock_minute >= 60) {
            g_clock_minute = 0;
            g_clock_hour++;
            if (g_clock_hour >= 24) {
                g_clock_hour = 0;
                g_clock_day++;
                rt_uint8_t days_in_month[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
                rt_uint8_t max_days = days_in_month[g_clock_month - 1];
                if (g_clock_month == 2 && ((g_clock_year % 4 == 0 && g_clock_year % 100 != 0) || (g_clock_year % 400 == 0))) {
                    max_days = 29;
                }
                if (g_clock_day > max_days) {
                    g_clock_day = 1;
                    g_clock_month++;
                    if (g_clock_month > 12) {
                        g_clock_month = 1;
                        g_clock_year++;
                    }
                }
            }
        }
    }
    
    rt_mutex_release(&g_clock_time_mutex);
    
    global_clock_update_display();
    
    if (g_clock_app_mutex_inited && clock.initialized && rt_mutex_trytake(&g_clock_app_mutex) == RT_EOK) {
        if (clock.alarm_enabled && !clock.in_alarm_set_mode) {
            if (g_clock_hour == clock.alarm_hour && g_clock_minute == clock.alarm_minute && g_clock_second == 0) {
                rt_kprintf("\n闹钟提醒，现在时间为 %04d-%02d-%02d %02d:%02d:%02d\n",
                          g_clock_year, g_clock_month, g_clock_day, g_clock_hour, g_clock_minute, g_clock_second);
            }
        }
        
        if (clock.auto_save_enabled) {
            rt_uint8_t current_second = g_clock_second;
            if (g_last_save_second == 255) {
                g_last_save_second = current_second;
            } else {
                rt_uint8_t diff;
                if (current_second >= g_last_save_second) {
                    diff = current_second - g_last_save_second;
                } else {
                    diff = (60 - g_last_save_second) + current_second;
                }
                if (diff >= 30) {
                    g_auto_save_pending = RT_TRUE;
                    g_last_save_second = current_second;
                }
            }
        } else {
            g_last_save_second = 255;
            g_auto_save_pending = RT_FALSE;
        }
        
        rt_mutex_release(&g_clock_app_mutex);
    }
}

static void display_time_internal(rt_uint32_t *seg_value, rt_uint8_t hour, rt_uint8_t minute, rt_uint8_t second, rt_bool_t is_12hour)
{
    rt_uint8_t h1, h2, m1, m2, s1, s2;
    
    if (is_12hour) {
        if (hour == 0) {
            hour = 12;
        } else if (hour > 12) {
            hour = hour - 12;
        }
    }
    
    h1 = hour / 10;
    h2 = hour % 10;
    m1 = minute / 10;
    m2 = minute % 10;
    s1 = second / 10;
    s2 = second % 10;
    
    *seg_value = ((rt_uint32_t)0 << 28) | ((rt_uint32_t)0 << 24) |
                 ((rt_uint32_t)h1 << 20) | ((rt_uint32_t)h2 << 16) |
                 ((rt_uint32_t)m1 << 12) | ((rt_uint32_t)m2 << 8) |
                 ((rt_uint32_t)s1 << 4) | ((rt_uint32_t)s2 << 0);
}

static void display_time(rt_uint32_t *seg_value)
{
    rt_uint8_t hour, minute, second;
    rt_bool_t is_12hour;
    
    rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
    hour = g_clock_hour;
    minute = g_clock_minute;
    second = g_clock_second;
    rt_mutex_release(&g_clock_time_mutex);
    
    rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
    is_12hour = clock.is_12hour;
    rt_mutex_release(&g_clock_app_mutex);
    
    display_time_internal(seg_value, hour, minute, second, is_12hour);
}

static void display_date_internal(rt_uint32_t *seg_value, rt_uint16_t year, rt_uint8_t month, rt_uint8_t day)
{
    rt_uint8_t y3, y4, m1, m2, d1, d2;
    
    y3 = (year % 100) / 10;
    y4 = year % 10;
    m1 = month / 10;
    m2 = month % 10;
    d1 = day / 10;
    d2 = day % 10;
    
    *seg_value = ((rt_uint32_t)0 << 28) | ((rt_uint32_t)0 << 24) |
                 ((rt_uint32_t)y3 << 20) | ((rt_uint32_t)y4 << 16) |
                 ((rt_uint32_t)m1 << 12) | ((rt_uint32_t)m2 << 8) |
                 ((rt_uint32_t)d1 << 4) | ((rt_uint32_t)d2 << 0);
}

static void display_date(rt_uint32_t *seg_value)
{
    rt_uint16_t year;
    rt_uint8_t month, day;
    
    rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
    year = g_clock_year;
    month = g_clock_month;
    day = g_clock_day;
    rt_mutex_release(&g_clock_time_mutex);
    
    display_date_internal(seg_value, year, month, day);
}

static void display_alarm_time_internal(rt_uint32_t *seg_value, rt_uint8_t hour, rt_uint8_t minute, rt_bool_t is_12hour)
{
    rt_uint8_t h1, h2, m1, m2;
    
    if (is_12hour) {
        if (hour == 0) {
            hour = 12;
        } else if (hour > 12) {
            hour = hour - 12;
        }
    }
    
    h1 = hour / 10;
    h2 = hour % 10;
    m1 = minute / 10;
    m2 = minute % 10;
    
    *seg_value = ((rt_uint32_t)0 << 28) | ((rt_uint32_t)0 << 24) |
                 ((rt_uint32_t)0 << 20) | ((rt_uint32_t)0 << 16) |
                 ((rt_uint32_t)h1 << 12) | ((rt_uint32_t)h2 << 8) |
                 ((rt_uint32_t)m1 << 4) | ((rt_uint32_t)m2 << 0);
}

void global_clock_update_display(void)
{
    rt_uint32_t seg_value = 0;
    rt_uint16_t year;
    rt_uint8_t month, day, hour, minute, second;
    display_mode_t mode;
    rt_bool_t in_alarm_set_mode, is_12hour;
    rt_uint8_t alarm_hour, alarm_minute;
    
    if (!g_clock_time_mutex_inited) {
        return;
    }
    
    if (rt_mutex_trytake(&g_clock_time_mutex) != RT_EOK) {
        return;
    }
    year = g_clock_year;
    month = g_clock_month;
    day = g_clock_day;
    hour = g_clock_hour;
    minute = g_clock_minute;
    second = g_clock_second;
    rt_mutex_release(&g_clock_time_mutex);
    
    mode = g_display_mode;
    in_alarm_set_mode = g_in_alarm_set_mode;
    is_12hour = g_is_12hour;
    alarm_hour = g_alarm_hour;
    alarm_minute = g_alarm_minute;
    
    if (in_alarm_set_mode) {
        display_alarm_time_internal(&seg_value, alarm_hour, alarm_minute, is_12hour);
    } else if (mode == DISPLAY_TIME) {
        display_time_internal(&seg_value, hour, minute, second, is_12hour);
    } else {
        display_date_internal(&seg_value, year, month, day);
    }
    
    SET_SegDig(seg_value);
}

static void display_alarm_time(rt_uint32_t *seg_value)
{
    rt_uint8_t hour, minute;
    rt_bool_t is_12hour;
    
    rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
    hour = clock.alarm_hour;
    minute = clock.alarm_minute;
    is_12hour = clock.is_12hour;
    rt_mutex_release(&g_clock_app_mutex);
    
    display_alarm_time_internal(seg_value, hour, minute, is_12hour);
}

static void update_display(void)
{
    rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
    g_display_mode = clock.display_mode;
    g_in_alarm_set_mode = clock.in_alarm_set_mode;
    g_is_12hour = clock.is_12hour;
    g_alarm_hour = clock.alarm_hour;
    g_alarm_minute = clock.alarm_minute;
    g_auto_save_enabled = clock.auto_save_enabled;
    rt_mutex_release(&g_clock_app_mutex);
    
    global_clock_update_display();
}

static void handle_switch_input(void)
{
    rt_uint16_t current_sw = READ_SW();
    rt_uint16_t sw_changed = current_sw ^ clock.last_sw_state;
    rt_uint16_t sw_rising = sw_changed & current_sw;
    
    if (!sw_rising) {
        clock.last_sw_state = current_sw;
        return;
    }
    
    rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
    
    // 检查退出开关
    if (sw_rising & (1 << SW_EXIT)) {
        rt_mutex_release(&g_clock_app_mutex);
        clock_running = RT_FALSE;
        // rt_kprintf("退出时钟应用\n");
        return;
    }
    
    if (sw_rising & (1 << SW_MODE_SWITCH)) {
        clock.display_mode = (clock.display_mode == DISPLAY_TIME) ? DISPLAY_DATE : DISPLAY_TIME;
        rt_kprintf("%s\n", clock.display_mode == DISPLAY_TIME ? "time" : "date");
        rt_mutex_release(&g_clock_app_mutex);
        update_display(); // 立即更新显示
        rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
    }
    
    if (sw_rising & (1 << SW_SET_MODE)) {
        if (clock.in_set_mode) {
            clock.in_set_mode = RT_FALSE;
            clock.set_item = SET_NONE;
            g_clock_paused = RT_FALSE;
            rt_kprintf("exit setting mode\n");
        } else if (!clock.in_alarm_set_mode) {
            clock.in_set_mode = RT_TRUE;
            clock.set_item = SET_YEAR;
            g_clock_paused = RT_TRUE;
            rt_kprintf("enter setting mode\n");
        }
    }
    
    if (sw_rising & (1 << SW_12_24_SWITCH)) {
        clock.is_12hour = !clock.is_12hour;
        rt_kprintf("switch time format: %s\n", clock.is_12hour ? "12h" : "24h");
    }
    
    if (sw_rising & (1 << SW_ALARM_TOGGLE)) {
        clock.alarm_enabled = !clock.alarm_enabled;
        rt_kprintf("alarm: %s\n", clock.alarm_enabled ? "on" : "off");
    }
    
    if (sw_rising & (1 << SW_SET_ALARM)) {
        if (clock.in_alarm_set_mode) {
            clock.in_alarm_set_mode = RT_FALSE;
            clock.set_item = SET_NONE;
            rt_kprintf("exit alarm setting mode\n");
            rt_mutex_release(&g_clock_app_mutex);
            update_display();
            rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
        } else if (!clock.in_set_mode) {
            clock.in_alarm_set_mode = RT_TRUE;
            clock.set_item = SET_HOUR;
            rt_kprintf("enter alarm setting mode\n");
            rt_mutex_release(&g_clock_app_mutex);
            update_display();
            rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
        }
    }
    
    if (clock.in_set_mode || clock.in_alarm_set_mode) {
        if (sw_rising & (1 << SW_SEL_NEXT)) {
            if (clock.in_set_mode) {
                if (clock.set_item < SET_SECOND) {
                    clock.set_item++;
                } else {
                    clock.set_item = SET_YEAR;
                }
            } else {
                if (clock.set_item == SET_HOUR) {
                    clock.set_item = SET_MINUTE;
                } else {
                    clock.set_item = SET_HOUR;
                }
            }
            rt_kprintf("select item: %d\n", clock.set_item);
        }
        
        if (sw_rising & (1 << SW_INC)) {
            rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
            switch (clock.set_item) {
                case SET_YEAR:
                    g_clock_year++;
                    if (g_clock_year > 2099) g_clock_year = 2000;
                    break;
                case SET_MONTH:
                    g_clock_month++;
                    if (g_clock_month > 12) g_clock_month = 1;
                    break;
                case SET_DAY:
                    g_clock_day++;
                    rt_uint8_t days_in_month[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
                    rt_uint8_t max_days = days_in_month[g_clock_month - 1];
                    if (g_clock_month == 2 && ((g_clock_year % 4 == 0 && g_clock_year % 100 != 0) || (g_clock_year % 400 == 0))) {
                        max_days = 29;
                    }
                    if (g_clock_day > max_days) g_clock_day = 1;
                    break;
                case SET_HOUR:
                    if (clock.in_alarm_set_mode) {
                        rt_mutex_release(&g_clock_time_mutex);
                        clock.alarm_hour++;
                        if (clock.alarm_hour >= 24) {
                            clock.alarm_hour = 0;
                        }
                        rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
                    } else {
                        g_clock_hour++;
                        if (g_clock_hour >= 24) {
                            g_clock_hour = 0;
                        }
                    }
                    break;
                case SET_MINUTE:
                    if (clock.in_alarm_set_mode) {
                        rt_mutex_release(&g_clock_time_mutex);
                        clock.alarm_minute++;
                        if (clock.alarm_minute >= 60) clock.alarm_minute = 0;
                        rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
                    } else {
                        g_clock_minute++;
                        if (g_clock_minute >= 60) g_clock_minute = 0;
                    }
                    break;
                case SET_SECOND:
                    g_clock_second++;
                    if (g_clock_second >= 60) g_clock_second = 0;
                    break;
                default:
                    break;
            }
            rt_mutex_release(&g_clock_time_mutex);
            rt_kprintf("+1\n");
            if (clock.in_alarm_set_mode) {
                rt_mutex_release(&g_clock_app_mutex);
                update_display();
                rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
            }
        }
        
        if (sw_rising & (1 << SW_DEC)) {
            rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
            switch (clock.set_item) {
                case SET_YEAR:
                    g_clock_year--;
                    if (g_clock_year < 2000) g_clock_year = 2099;
                    break;
                case SET_MONTH:
                    g_clock_month--;
                    if (g_clock_month < 1) g_clock_month = 12;
                    break;
                case SET_DAY:
                    g_clock_day--;
                    rt_uint8_t days_in_month[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
                    rt_uint8_t max_days = days_in_month[g_clock_month - 1];
                    if (g_clock_month == 2 && ((g_clock_year % 4 == 0 && g_clock_year % 100 != 0) || (g_clock_year % 400 == 0))) {
                        max_days = 29;
                    }
                    if (g_clock_day < 1) g_clock_day = max_days;
                    break;
                case SET_HOUR:
                    if (clock.in_alarm_set_mode) {
                        rt_mutex_release(&g_clock_time_mutex);
                        if (clock.alarm_hour == 0) {
                            clock.alarm_hour = 23;
                        } else {
                            clock.alarm_hour--;
                        }
                        rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
                    } else {
                        if (g_clock_hour == 0) {
                            g_clock_hour = 23;
                        } else {
                            g_clock_hour--;
                        }
                    }
                    break;
                case SET_MINUTE:
                    if (clock.in_alarm_set_mode) {
                        rt_mutex_release(&g_clock_time_mutex);
                        clock.alarm_minute--;
                        if (clock.alarm_minute >= 60) clock.alarm_minute = 59;
                        rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
                    } else {
                        g_clock_minute--;
                        if (g_clock_minute >= 60) g_clock_minute = 59;
                    }
                    break;
                case SET_SECOND:
                    g_clock_second--;
                    if (g_clock_second >= 60) g_clock_second = 59;
                    break;
                default:
                    break;
            }
            rt_mutex_release(&g_clock_time_mutex);
            rt_kprintf("-1\n");
            if (clock.in_alarm_set_mode) {
                rt_mutex_release(&g_clock_app_mutex);
                update_display();
                rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
            }
        }
    }
    
    if (sw_rising & (1 << SW_AUTO_SAVE)) {
        clock.auto_save_enabled = !clock.auto_save_enabled;
        g_auto_save_enabled = clock.auto_save_enabled;
        g_last_save_second = 255;
        g_auto_save_pending = RT_FALSE;
        rt_kprintf("auto save: %s\n", clock.auto_save_enabled ? "on" : "off");
    }
    
    if (sw_rising & (1 << SW_SAVE_TIME)) {
        if (!clock.auto_save_enabled) {
            rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
            rt_uint16_t year = g_clock_year;
            rt_uint8_t month = g_clock_month;
            rt_uint8_t day = g_clock_day;
            rt_uint8_t hour = g_clock_hour;
            rt_uint8_t minute = g_clock_minute;
            rt_uint8_t second = g_clock_second;
            rt_mutex_release(&g_clock_time_mutex);
            
            save_time_to_file();
            rt_kprintf("save: %04d-%02d-%02d %02d:%02d:%02d\n",
                      year, month, day, hour, minute, second);
        } else {
            rt_kprintf("auto save is on, manual save is off\n");
        }
    }
    
    if (sw_rising & (1 << SW_LOAD_TIME)) {
        if (fs_init() != 0) {
            rt_kprintf("error: file system initialization failed\n");
        } else {
            fs_file_handle_t handle;
            if (fs_open("time", &handle) != 0) {
                rt_kprintf("error: time file not found\n");
            } else {
                fs_file_entry_t info;
                if (fs_get_file_info("time", &info) == 0 && info.size == SM4_BLOCK_SIZE) {
                    rt_uint8_t ciphertext[SM4_BLOCK_SIZE];
                    rt_uint8_t plaintext[SM4_BLOCK_SIZE];
                    rt_uint8_t time_data[8];
                    if (fs_seek(&handle, 0) == 0) {
                        s32_t read_ret = fs_read(&handle, ciphertext, SM4_BLOCK_SIZE);
                        if (read_ret == SM4_BLOCK_SIZE) {
                            rt_uint32_t is_all_ff = 1;
                            for (rt_uint32_t i = 0; i < SM4_BLOCK_SIZE; i++) {
                                if (ciphertext[i] != 0xFF) {
                                    is_all_ff = 0;
                                    break;
                                }
                            }
                            if (is_all_ff) {
                                rt_kprintf("error: time file is empty(all 0xFF)\n");
                            } else {
                                sm4_decrypt(ciphertext, sm4_time_key, plaintext);
                                memcpy(time_data, plaintext, 8);
                                
                                rt_uint16_t year = time_data[0] | ((rt_uint16_t)time_data[1] << 8);
                                rt_uint8_t month = time_data[2];
                                rt_uint8_t day = time_data[3];
                                rt_uint8_t hour = time_data[4];
                                rt_uint8_t minute = time_data[5];
                                rt_uint8_t second = time_data[6];
                                
                                if (year >= 2000 && year <= 2099 &&
                                    month >= 1 && month <= 12 &&
                                    day >= 1 && day <= 31 &&
                                    hour < 24 && minute < 60 && second < 60) {
                                    rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
                                    g_clock_year = year;
                                    g_clock_month = month;
                                    g_clock_day = day;
                                    g_clock_hour = hour;
                                    g_clock_minute = minute;
                                    g_clock_second = second;
                                    rt_mutex_release(&g_clock_time_mutex);
                                    rt_kprintf("%04d-%02d-%02d %02d:%02d:%02d\n",
                                              year, month, day, hour, minute, second);
                                    rt_mutex_release(&g_clock_app_mutex);
                                    update_display();
                                    rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
                                } else {
                                    rt_kprintf("error: time data invalid year=%d month=%d day=%d hour=%d minute=%d second=%d\n",
                                              year, month, day, hour, minute, second);
                                }
                            }
                        } else {
                            rt_kprintf("error: read data failed, return value=%d\n", read_ret);
                        }
                    }
                } else {
                    rt_kprintf("error: time file size mismatch(expected %d bytes)\n", SM4_BLOCK_SIZE);
                }
            }
        }
    }
    
    rt_mutex_release(&g_clock_app_mutex);
    clock.last_sw_state = current_sw;
}


static void GPIO_ISR(void)
{
    M_PSP_WRITE_REGISTER_32(RGPIO_INTS, 0x0);
    bspClearExtInterrupt(D_BSP_IRQ_4);
}

extern pspInterruptHandler_t G_Ext_Interrupt_Handlers[];

static void ExternalIntLine_Initialization(u32_t uiSourceId, u32_t priority, pspInterruptHandler_t pTestIsr)
{
    pspExternalInterruptSetVectorTableAddress(G_Ext_Interrupt_Handlers);
    pspExtInterruptSetType(uiSourceId, D_PSP_EXT_INT_LEVEL_TRIG_TYPE);
    pspExtInterruptSetPolarity(uiSourceId, D_PSP_EXT_INT_ACTIVE_HIGH);
    pspExtInterruptClearPendingInt(uiSourceId);
    pspExtInterruptSetPriority(uiSourceId, priority);
    pspExternalInterruptEnableNumber(uiSourceId);
    G_Ext_Interrupt_Handlers[uiSourceId] = pTestIsr;
}

static void GPIO_Initialization(void)
{
    M_PSP_WRITE_REGISTER_32(GPIO_INOUT, 0xFFFF);
    M_PSP_WRITE_REGISTER_32(GPIO_LEDs, 0x0);
    M_PSP_WRITE_REGISTER_32(RGPIO_INTE, 0xFF000000);
    M_PSP_WRITE_REGISTER_32(RGPIO_PTRIG, 0xFF000000);
    M_PSP_WRITE_REGISTER_32(RGPIO_INTS, 0x0);
    M_PSP_WRITE_REGISTER_32(RGPIO_CTRL, 0x1);
}

// 系统启动时初始化全局时间（在应用启动之前）
static int global_clock_time_init(void)
{
    rt_mutex_init(&g_clock_time_mutex, "clock_time_mutex", RT_IPC_FLAG_FIFO);
    g_clock_time_mutex_inited = RT_TRUE;
    g_clock_year = 2025;
    g_clock_month = 1;
    g_clock_day = 1;
    g_clock_hour = 0;
    g_clock_minute = 0;
    g_clock_second = 0;
    SET_SegEn(0x00);
    return 0;
}
INIT_COMPONENT_EXPORT(global_clock_time_init);

static void clock_init(void)
{
    // 初始化clock应用相关的mutex（只在第一次初始化时）
    if (!g_clock_app_mutex_inited) {
        rt_mutex_init(&g_clock_app_mutex, "clock_app_mutex", RT_IPC_FLAG_FIFO);
        g_clock_app_mutex_inited = RT_TRUE;
    }
    clock.is_12hour = RT_FALSE;
    clock.alarm_enabled = RT_FALSE;
    clock.alarm_hour = 0;
    clock.alarm_minute = 0;
    clock.display_mode = DISPLAY_TIME;
    clock.in_set_mode = RT_FALSE;
    clock.in_alarm_set_mode = RT_FALSE;
    clock.set_item = SET_NONE;
    clock.last_sw_state = 0;
    clock.initialized = RT_TRUE;
    clock.auto_save_enabled = RT_FALSE;
    g_auto_save_enabled = RT_FALSE;
    g_last_save_second = 255;
    g_auto_save_pending = RT_FALSE;
    
    SET_SegEn(0x00);
    SET_SegDig(0);
    SET_LED(0);
}

static void clock_loop(void)
{
    rt_uint32_t loop_count = 0;
    
    update_display();
    
    while (clock_running) {
        handle_switch_input();
        update_display();
        
        if (g_auto_save_pending) {
            rt_mutex_take(&g_clock_app_mutex, RT_WAITING_FOREVER);
            if (clock.auto_save_enabled && g_auto_save_pending) {
                g_auto_save_pending = RT_FALSE;
                rt_mutex_release(&g_clock_app_mutex);
                
                rt_mutex_take(&g_clock_time_mutex, RT_WAITING_FOREVER);
                rt_uint16_t year = g_clock_year;
                rt_uint8_t month = g_clock_month;
                rt_uint8_t day = g_clock_day;
                rt_uint8_t hour = g_clock_hour;
                rt_uint8_t minute = g_clock_minute;
                rt_uint8_t second = g_clock_second;
                rt_mutex_release(&g_clock_time_mutex);
                
                save_time_to_file();
                rt_kprintf("自动保存时间(加密): %04d-%02d-%02d %02d:%02d:%02d\n",
                          year, month, day, hour, minute, second);
            } else {
                rt_mutex_release(&g_clock_app_mutex);
            }
        }
        
        loop_count++;
        if (loop_count > 10000) {
            loop_count = 0;
            rt_thread_yield();
        }
    }
}

int clock_start(int argc, char **argv)
{
    if (clock_running) {
        // rt_kprintf("时钟应用已在运行\n");
        return 0;
    }
    
    if (password_init() != 0) {
        // rt_kprintf("密码系统初始化失败\n");
        return -1;
    }
    
    if (argc < 2) {
        // rt_kprintf("用法: clock_start <密码>\n");
        return -1;
    }
    
    if (password_verify(argv[1]) != 0) {
        rt_kprintf("error password\n");
        return -1;
    }
    
    rt_kprintf("success\n");
    // rt_kprintf("正在初始化时钟应用...\n");
    clock.initialized = RT_FALSE;
    clock_init();
    
    pspExtInterruptsSetThreshold(M_PSP_EXT_INT_THRESHOLD_UNMASK_ALL_VALUE);
    ExternalIntLine_Initialization(D_BSP_IRQ_4, D_PSP_EXT_INT_PRIORITY_6, GPIO_ISR);
    GPIO_Initialization();
    M_PSP_WRITE_REGISTER_32(Select_INT, 0x1);
    pspInterruptsEnable();
    M_PSP_SET_CSR(D_PSP_MIE_NUM, D_PSP_MIE_MEIE_MASK);
    
    // rt_kprintf("时钟应用启动成功\n");
    // rt_kprintf("开关功能:\n");
    rt_kprintf("  0:  date/time\n");
    rt_kprintf("  1:  setting mode\n");
    rt_kprintf("  2:  alarm on/off\n");
    rt_kprintf("  3:  alarm setting mode\n");
    rt_kprintf("  4:  switch item\n");
    rt_kprintf("  5:  +1\n");
    rt_kprintf("  6:  -1\n");
    rt_kprintf("  7:  exit\n");
    rt_kprintf("  8:  auto save on/off\n");
    rt_kprintf("  9:  load time from file\n");
    
    clock_running = RT_TRUE;
    clock_loop();
    clock_running = RT_FALSE;
    
    // rt_kprintf("时钟应用已停止\n");
    return 0;
}

int clock_stop(void)
{
    clock_running = RT_FALSE;
    // rt_kprintf("正在停止时钟应用...\n");
    return 0;
}

static int change_password(int argc, char **argv)
{
    if (argc < 3) {
        // rt_kprintf("用法: change_password <旧密码> <新密码>\n");
        return -1;
    }
    
    if (password_init() != 0) {
        // rt_kprintf("密码系统初始化失败\n");
        return -1;
    }
    
    if (password_verify(argv[1]) != 0) {
        rt_kprintf("error\n");
        return -1;
    }
    
    sm3_hash((rt_uint8_t *)argv[2], strlen(argv[2]), password_hash);
    if (password_hash_save() != 0) {
        rt_kprintf("error\n");
        return -1;
    }
    
    // rt_kprintf("密码设置成功\n");
    return 0;
}

MSH_CMD_EXPORT(clock_start, clock application with alarm);
MSH_CMD_EXPORT(clock_stop, stop clock application);
MSH_CMD_EXPORT(change_password, set clock application password);

