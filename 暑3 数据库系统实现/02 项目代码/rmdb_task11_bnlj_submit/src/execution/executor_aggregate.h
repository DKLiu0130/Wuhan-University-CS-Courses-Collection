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

#include "executor_abstract.h"

class AggregateExecutor : public AbstractExecutor {
   private:
    std::unique_ptr<AbstractExecutor> prev_;
    std::vector<std::shared_ptr<ast::AggFunc>> agg_funcs_;
    std::vector<ColMeta> cols_;
    size_t len_ = 0;
    bool produced_ = false;

   public:
    AggregateExecutor(std::unique_ptr<AbstractExecutor> prev, std::vector<std::shared_ptr<ast::AggFunc>> agg_funcs)
        : prev_(std::move(prev)), agg_funcs_(std::move(agg_funcs)) {
        size_t offset = 0;
        for (auto &agg : agg_funcs_) {
            ColMeta col;
            col.tab_name = "";
            col.name = agg->alias;
            if (agg->agg_type == ast::AGG_COUNT || agg->agg_type == ast::AGG_COUNT_STAR) {
                col.type = TYPE_INT;
                col.len = sizeof(int);
            } else {
                auto src = prev_->get_col_offset({agg->col->tab_name, agg->col->col_name});
                col.type = src.type;
                col.len = src.len;
            }
            col.offset = offset;
            offset += col.len;
            cols_.push_back(col);
        }
        len_ = offset;
    }

    void beginTuple() override { produced_ = false; }

    void nextTuple() override { produced_ = true; }

    std::unique_ptr<RmRecord> Next() override {
        auto out = std::make_unique<RmRecord>(len_);
        prev_->beginTuple();
        for (size_t i = 0; i < agg_funcs_.size(); ++i) {
            auto &agg = agg_funcs_[i];
            auto &dst = cols_[i];
            if (agg->agg_type == ast::AGG_COUNT_STAR) {
                int cnt = 0;
                for (; !prev_->is_end(); prev_->nextTuple()) cnt++;
                memcpy(out->data + dst.offset, &cnt, sizeof(int));
                prev_->beginTuple();
                continue;
            }

            auto src = prev_->get_col_offset({agg->col->tab_name, agg->col->col_name});
            bool first = true;
            int int_acc = 0;
            int64_t bigint_acc = 0;
            float float_acc = 0;
            std::vector<char> best(dst.len);

            for (; !prev_->is_end(); prev_->nextTuple()) {
                auto rec = prev_->Next();
                char *ptr = rec->data + src.offset;
                if (agg->agg_type == ast::AGG_COUNT) {
                    int_acc++;
                } else if (agg->agg_type == ast::AGG_SUM) {
                    if (src.type == TYPE_INT) int_acc += *(int *)ptr;
                    else if (src.type == TYPE_BIGINT) bigint_acc += *(int64_t *)ptr;
                    else float_acc += *(float *)ptr;
                } else if (first) {
                    memcpy(best.data(), ptr, dst.len);
                    first = false;
                } else {
                    int cmp = 0;
                    if (src.type == TYPE_INT) {
                        int a = *(int *)ptr, b = *(int *)best.data();
                        cmp = (a > b) - (a < b);
                    } else if (src.type == TYPE_BIGINT || src.type == TYPE_DATETIME) {
                        int64_t a = *(int64_t *)ptr, b = *(int64_t *)best.data();
                        cmp = (a > b) - (a < b);
                    } else if (src.type == TYPE_FLOAT) {
                        float a = *(float *)ptr, b = *(float *)best.data();
                        cmp = (a > b) - (a < b);
                    } else {
                        cmp = memcmp(ptr, best.data(), dst.len);
                    }
                    if ((agg->agg_type == ast::AGG_MAX && cmp > 0) || (agg->agg_type == ast::AGG_MIN && cmp < 0)) {
                        memcpy(best.data(), ptr, dst.len);
                    }
                }
            }

            if (agg->agg_type == ast::AGG_COUNT) {
                memcpy(out->data + dst.offset, &int_acc, sizeof(int));
            } else if (agg->agg_type == ast::AGG_SUM) {
                if (src.type == TYPE_INT) memcpy(out->data + dst.offset, &int_acc, sizeof(int));
                else if (src.type == TYPE_BIGINT) memcpy(out->data + dst.offset, &bigint_acc, sizeof(int64_t));
                else memcpy(out->data + dst.offset, &float_acc, sizeof(float));
            } else if (!first) {
                memcpy(out->data + dst.offset, best.data(), dst.len);
            } else {
                memset(out->data + dst.offset, 0, dst.len);
            }
            prev_->beginTuple();
        }
        return out;
    }

    Rid &rid() override { return _abstract_rid; }

    bool is_end() const override { return produced_; }

    size_t tupleLen() const override { return len_; }

    const std::vector<ColMeta> &cols() const override { return cols_; }
};
