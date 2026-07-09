/* Copyright (c) 2023 Renmin University of China
RMDB is licensed under Mulan PSL v2.
You can use this software according to the terms and conditions of the Mulan PSL v2.
You may obtain a copy of Mulan PSL v2 at:
        http://license.coscl.org.cn/MulanPSL2
THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
See the Mulan PSL v2 for more details. */

#pragma once

#include <cassert>
#include <cstdint>
#include <cstring>
#include <cstdio>
#include <memory>
#include <string>
#include <vector>
#include "defs.h"
#include "record/rm_defs.h"


struct TabCol {
    std::string tab_name;
    std::string col_name;

    friend bool operator<(const TabCol &x, const TabCol &y) {
        return std::make_pair(x.tab_name, x.col_name) < std::make_pair(y.tab_name, y.col_name);
    }
};

struct Value {
    ColType type;  // type of value
    union {
        int int_val;      // int value
        float float_val;  // float value
        int64_t bigint_val;  // bigint value
        int64_t datetime_val;  // datetime value
    };
    std::string str_val;  // string value

    std::shared_ptr<RmRecord> raw;  // raw record buffer

    void set_int(int int_val_) {
        type = TYPE_INT;
        int_val = int_val_;
    }

    void set_float(float float_val_) {
        type = TYPE_FLOAT;
        float_val = float_val_;
    }

    void set_bigint(int64_t bigint_val_) {
        type = TYPE_BIGINT;
        bigint_val = bigint_val_;
    }

    void set_str(std::string str_val_) {
        type = TYPE_STRING;
        str_val = std::move(str_val_);
    }

    static bool parse_datetime(const std::string &s, int64_t *out) {
        if (s.size() != 19 || s[4] != '-' || s[7] != '-' || s[10] != ' ' || s[13] != ':' || s[16] != ':') return false;
        for (int i : {0,1,2,3,5,6,8,9,11,12,14,15,17,18}) if (s[i] < '0' || s[i] > '9') return false;
        int y, mo, d, h, mi, sec;
        if (sscanf(s.c_str(), "%4d-%2d-%2d %2d:%2d:%2d", &y, &mo, &d, &h, &mi, &sec) != 6) return false;
        if (y < 1000 || y > 9999 || mo < 1 || mo > 12 || h < 0 || h > 23 || mi < 0 || mi > 59 || sec < 0 || sec > 59) return false;
        int mdays[] = {0,31,28,31,30,31,30,31,31,30,31,30,31};
        bool leap = (y % 400 == 0) || (y % 4 == 0 && y % 100 != 0);
        if (leap) mdays[2] = 29;
        if (d < 1 || d > mdays[mo]) return false;
        *out = (((((int64_t)y * 100 + mo) * 100 + d) * 100 + h) * 100 + mi) * 100 + sec;
        return true;
    }

    static std::string datetime_to_string(int64_t v) {
        int sec = v % 100; v /= 100;
        int mi = v % 100; v /= 100;
        int h = v % 100; v /= 100;
        int d = v % 100; v /= 100;
        int mo = v % 100; v /= 100;
        int y = v;
        char buf[20];
        snprintf(buf, sizeof(buf), "%04d-%02d-%02d %02d:%02d:%02d", y, mo, d, h, mi, sec);
        return std::string(buf);
    }

    void set_datetime(const std::string &str_val_) {
        type = TYPE_DATETIME;
        str_val = str_val_;
        if (!parse_datetime(str_val_, &datetime_val)) throw IncompatibleTypeError("DATETIME", "STRING");
    }

    void init_raw(int len) {
        if (raw == nullptr || raw->size != len) {
            raw = std::make_shared<RmRecord>(len);
        }
        if (type == TYPE_INT) {
            assert(len == sizeof(int));
            *(int *)(raw->data) = int_val;
        } else if (type == TYPE_FLOAT) {
            assert(len == sizeof(float));
            *(float *)(raw->data) = float_val;
        } else if (type == TYPE_BIGINT) {
            assert(len == sizeof(int64_t));
            *(int64_t *)(raw->data) = bigint_val;
        } else if (type == TYPE_DATETIME) {
            assert(len == sizeof(int64_t));
            *(int64_t *)(raw->data) = datetime_val;
        } else if (type == TYPE_STRING) {
            if (len < (int)str_val.size()) {
                throw StringOverflowError();
            }
            memset(raw->data, 0, len);
            memcpy(raw->data, str_val.c_str(), str_val.size());
        }
    }
};

enum CompOp { OP_EQ, OP_NE, OP_LT, OP_GT, OP_LE, OP_GE };

struct Condition {
    TabCol lhs_col;   // left-hand side column
    CompOp op;        // comparison operator
    bool is_rhs_val;  // true if right-hand side is a value (not a column)
    TabCol rhs_col;   // right-hand side column
    Value rhs_val;    // right-hand side value
};

struct SetClause {
    TabCol lhs;
    Value rhs;
};
