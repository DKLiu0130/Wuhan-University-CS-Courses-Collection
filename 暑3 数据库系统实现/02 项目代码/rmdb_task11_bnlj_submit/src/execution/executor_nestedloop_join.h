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

#include <algorithm>
#include <cstddef>
#include <memory>
#include <vector>

#include "execution_defs.h"
#include "execution_manager.h"
#include "executor_abstract.h"
#include "index/ix.h"
#include "system/sm.h"

class NestedLoopJoinExecutor : public AbstractExecutor {
   private:
    // Keep one block of left tuples in memory. 8MB is far below the 2GB limit
    // and avoids rescanning the right input for every single left tuple.
    static constexpr size_t JOIN_BUFFER_SIZE = 8 * 1024 * 1024;

    std::unique_ptr<AbstractExecutor> left_;
    std::unique_ptr<AbstractExecutor> right_;
    size_t len_;
    std::vector<ColMeta> cols_;
    std::vector<Condition> fed_conds_;

    bool isend_ = false;
    size_t left_cursor_ = 0;
    std::vector<std::unique_ptr<RmRecord>> left_block_;
    std::unique_ptr<RmRecord> right_tuple_;
    std::unique_ptr<RmRecord> current_tuple_;

   public:
    NestedLoopJoinExecutor(std::unique_ptr<AbstractExecutor> left, std::unique_ptr<AbstractExecutor> right,
                           std::vector<Condition> conds) {
        left_ = std::move(left);
        right_ = std::move(right);
        len_ = left_->tupleLen() + right_->tupleLen();
        cols_ = left_->cols();
        auto right_cols = right_->cols();
        for (auto &col : right_cols) {
            col.offset += left_->tupleLen();
        }
        cols_.insert(cols_.end(), right_cols.begin(), right_cols.end());
        fed_conds_ = std::move(conds);
    }

    void beginTuple() override {
        left_->beginTuple();
        isend_ = false;
        current_tuple_ = nullptr;
        right_tuple_ = nullptr;
        left_cursor_ = 0;

        load_left_block();
        if (left_block_.empty()) {
            isend_ = true;
            return;
        }

        right_->beginTuple();
        if (right_->is_end()) {
            isend_ = true;
            return;
        }
        right_tuple_ = right_->Next();
        find_next();
    }

    void nextTuple() override {
        if (isend_) {
            return;
        }
        ++left_cursor_;
        find_next();
    }

    std::unique_ptr<RmRecord> Next() override {
        if (current_tuple_ == nullptr) {
            return nullptr;
        }
        return std::make_unique<RmRecord>(*current_tuple_);
    }

    Rid &rid() override { return _abstract_rid; }

    bool is_end() const override { return isend_; }

    size_t tupleLen() const override { return len_; }

    const std::vector<ColMeta> &cols() const override { return cols_; }

    ColMeta get_col_offset(const TabCol &target) override { return *get_col(cols_, target); }

   private:
    void load_left_block() {
        left_block_.clear();
        left_cursor_ = 0;
        size_t used = 0;
        const size_t tuple_len = std::max<size_t>(left_->tupleLen(), 1);
        const size_t max_tuples = std::max<size_t>(1, JOIN_BUFFER_SIZE / tuple_len);

        while (!left_->is_end() && left_block_.size() < max_tuples) {
            auto rec = left_->Next();
            used += rec->size;
            left_block_.push_back(std::move(rec));
            left_->nextTuple();
            if (used >= JOIN_BUFFER_SIZE && !left_block_.empty()) {
                break;
            }
        }
    }

    void advance_right_or_block() {
        if (!right_->is_end()) {
            right_->nextTuple();
        }

        while (right_->is_end()) {
            load_left_block();
            if (left_block_.empty()) {
                isend_ = true;
                current_tuple_ = nullptr;
                right_tuple_ = nullptr;
                return;
            }
            right_->beginTuple();
            if (right_->is_end()) {
                isend_ = true;
                current_tuple_ = nullptr;
                right_tuple_ = nullptr;
                return;
            }
        }

        right_tuple_ = right_->Next();
        left_cursor_ = 0;
    }

    void find_next() {
        current_tuple_ = nullptr;
        while (!isend_) {
            if (right_tuple_ == nullptr) {
                advance_right_or_block();
                if (isend_) {
                    return;
                }
            }

            while (left_cursor_ < left_block_.size()) {
                auto joined = std::make_unique<RmRecord>(len_);
                memcpy(joined->data, left_block_[left_cursor_]->data, left_->tupleLen());
                memcpy(joined->data + left_->tupleLen(), right_tuple_->data, right_->tupleLen());
                if (eval_conds(cols_, joined.get(), fed_conds_)) {
                    current_tuple_ = std::move(joined);
                    return;
                }
                ++left_cursor_;
            }

            advance_right_or_block();
        }
    }
};