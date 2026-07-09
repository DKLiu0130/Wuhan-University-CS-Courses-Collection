/* Copyright (c) 2023 Renmin University of China
RMDB is licensed under Mulan PSL v2. */

#pragma once

#include <algorithm>
#include "execution_defs.h"
#include "execution_manager.h"
#include "executor_abstract.h"
#include "index/ix.h"
#include "system/sm.h"

class SortExecutor : public AbstractExecutor {
   private:
    std::unique_ptr<AbstractExecutor> prev_;
    std::vector<ColMeta> sort_cols_;
    std::vector<bool> is_descs_;
    std::vector<ColMeta> cols_;
    size_t len_ = 0;
    int limit_ = -1;
    size_t cursor_ = 0;
    std::vector<std::unique_ptr<RmRecord>> tuples_;

    int cmp_col(const RmRecord *a, const RmRecord *b, const ColMeta &col) const {
        const char *lhs = a->data + col.offset;
        const char *rhs = b->data + col.offset;
        if (col.type == TYPE_INT) {
            int x = *reinterpret_cast<const int *>(lhs), y = *reinterpret_cast<const int *>(rhs);
            return (x > y) - (x < y);
        }
        if (col.type == TYPE_BIGINT || col.type == TYPE_DATETIME) {
            int64_t x = *reinterpret_cast<const int64_t *>(lhs), y = *reinterpret_cast<const int64_t *>(rhs);
            return (x > y) - (x < y);
        }
        if (col.type == TYPE_FLOAT) {
            float x = *reinterpret_cast<const float *>(lhs), y = *reinterpret_cast<const float *>(rhs);
            return (x > y) - (x < y);
        }
        return memcmp(lhs, rhs, col.len);
    }

   public:
    SortExecutor(std::unique_ptr<AbstractExecutor> prev, const std::vector<TabCol> &sel_cols,
                 const std::vector<bool> &is_descs, int limit) {
        prev_ = std::move(prev);
        cols_ = prev_->cols();
        len_ = prev_->tupleLen();
        is_descs_ = is_descs;
        limit_ = limit;
        for (auto &sel_col : sel_cols) {
            sort_cols_.push_back(prev_->get_col_offset(sel_col));
        }
    }

    void beginTuple() override {
        tuples_.clear();
        cursor_ = 0;
        for (prev_->beginTuple(); !prev_->is_end(); prev_->nextTuple()) {
            tuples_.push_back(prev_->Next());
        }
        std::sort(tuples_.begin(), tuples_.end(), [&](const auto &a, const auto &b) {
            for (size_t i = 0; i < sort_cols_.size(); ++i) {
                int cmp = cmp_col(a.get(), b.get(), sort_cols_[i]);
                if (cmp != 0) {
                    return is_descs_[i] ? cmp > 0 : cmp < 0;
                }
            }
            return false;
        });
        if (limit_ >= 0 && tuples_.size() > static_cast<size_t>(limit_)) {
            tuples_.resize(limit_);
        }
    }

    void nextTuple() override { ++cursor_; }

    std::unique_ptr<RmRecord> Next() override {
        return std::make_unique<RmRecord>(*tuples_[cursor_]);
    }

    Rid &rid() override { return _abstract_rid; }

    bool is_end() const override { return cursor_ >= tuples_.size(); }

    size_t tupleLen() const override { return len_; }

    const std::vector<ColMeta> &cols() const override { return cols_; }

    ColMeta get_col_offset(const TabCol &target) override { return *get_col(cols_, target); }
};
