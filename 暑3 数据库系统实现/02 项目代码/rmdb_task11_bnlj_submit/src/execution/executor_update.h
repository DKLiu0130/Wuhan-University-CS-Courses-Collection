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
#include "execution_defs.h"
#include "execution_manager.h"
#include "executor_abstract.h"
#include "index/ix.h"
#include "system/sm.h"

class UpdateExecutor : public AbstractExecutor {
   private:
    TabMeta tab_;
    std::vector<Condition> conds_;
    RmFileHandle *fh_;
    std::vector<Rid> rids_;
    std::string tab_name_;
    std::vector<SetClause> set_clauses_;
    SmManager *sm_manager_;

   public:
    UpdateExecutor(SmManager *sm_manager, const std::string &tab_name, std::vector<SetClause> set_clauses,
                   std::vector<Condition> conds, std::vector<Rid> rids, Context *context) {
        sm_manager_ = sm_manager;
        tab_name_ = tab_name;
        set_clauses_ = set_clauses;
        tab_ = sm_manager_->db_.get_table(tab_name);
        fh_ = sm_manager_->fhs_.at(tab_name).get();
        conds_ = conds;
        rids_ = rids;
        context_ = context;
        if (context_ != nullptr && context_->lock_mgr_ != nullptr && context_->txn_ != nullptr) {
            context_->lock_mgr_->lock_exclusive_on_table(context_->txn_, fh_->GetFd());
        }
    }
    std::unique_ptr<RmRecord> Next() override {
        for (const auto &rid : rids_) {
            auto rec = fh_->get_record(rid, context_);
            auto old_rec = std::make_unique<RmRecord>(*rec);
            for (auto &set_clause : set_clauses_) {
                auto col = tab_.get_col(set_clause.lhs.col_name);
                if (col->type == TYPE_BIGINT && set_clause.rhs.type == TYPE_INT) {
                    set_clause.rhs.set_bigint(static_cast<int64_t>(set_clause.rhs.int_val));
                } else if (col->type == TYPE_DATETIME && set_clause.rhs.type == TYPE_STRING) {
                    set_clause.rhs.set_datetime(set_clause.rhs.str_val);
                } else if (col->type == TYPE_FLOAT && set_clause.rhs.type == TYPE_INT) {
                    set_clause.rhs.set_float(static_cast<float>(set_clause.rhs.int_val));
                }
                if (col->type != set_clause.rhs.type) {
                    throw IncompatibleTypeError(coltype2str(col->type), coltype2str(set_clause.rhs.type));
                }
                set_clause.rhs.init_raw(col->len);
                memcpy(rec->data + col->offset, set_clause.rhs.raw->data, col->len);
            }
            sm_manager_->check_unique_indexes(tab_name_, rec->data, &rid);
            sm_manager_->delete_index_entries(tab_name_, old_rec->data);
            fh_->update_record(rid, rec->data, context_);
            sm_manager_->insert_index_entries(tab_name_, rec->data, rid);
            if (context_ != nullptr && context_->txn_ != nullptr) {
                if (context_->log_mgr_ != nullptr) {
                    UpdateLogRecord log(context_->txn_->get_transaction_id(), *old_rec, *rec, const_cast<Rid&>(rid), tab_name_);
                    context_->txn_->set_prev_lsn(context_->log_mgr_->add_log_to_buffer(&log));
                    context_->log_mgr_->flush_log_to_disk();
                }
                context_->txn_->append_write_record(new WriteRecord(WType::UPDATE_TUPLE, tab_name_, rid, *old_rec));
            }
        }
        return nullptr;
    }

    Rid &rid() override { return _abstract_rid; }
};
