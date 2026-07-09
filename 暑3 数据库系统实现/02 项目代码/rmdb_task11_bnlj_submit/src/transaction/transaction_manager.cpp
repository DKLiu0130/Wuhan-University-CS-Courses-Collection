/* Copyright (c) 2023 Renmin University of China
RMDB is licensed under Mulan PSL v2.
You can use this software according to the terms and conditions of the Mulan PSL v2.
You may obtain a copy of Mulan PSL v2 at:
        http://license.coscl.org.cn/MulanPSL2
THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
See the Mulan PSL v2 for more details. */

#include "transaction_manager.h"
#include "record/rm_file_handle.h"
#include "system/sm_manager.h"

std::unordered_map<txn_id_t, Transaction *> TransactionManager::txn_map = {};

/**
 * @description: 事务的开始方法
 * @return {Transaction*} 开始事务的指针
 * @param {Transaction*} txn 事务指针，空指针代表需要创建新事务，否则开始已有事务
 * @param {LogManager*} log_manager 日志管理器指针
 */
Transaction * TransactionManager::begin(Transaction* txn, LogManager* log_manager) {
    if (txn == nullptr) {
        txn = new Transaction(next_txn_id_++);
    }
    txn->set_start_ts(next_timestamp_++);
    txn->set_state(TransactionState::GROWING);
    if (log_manager != nullptr) {
        BeginLogRecord log(txn->get_transaction_id());
        txn->set_prev_lsn(log_manager->add_log_to_buffer(&log));
    }
    std::unique_lock<std::mutex> lock(latch_);
    txn_map[txn->get_transaction_id()] = txn;
    return txn;
}

/**
 * @description: 事务的提交方法
 * @param {Transaction*} txn 需要提交的事务
 * @param {LogManager*} log_manager 日志管理器指针
 */
void TransactionManager::commit(Transaction* txn, LogManager* log_manager) {
    if (txn == nullptr) {
        return;
    }
    if (log_manager != nullptr) {
        CommitLogRecord log(txn->get_transaction_id());
        txn->set_prev_lsn(log_manager->add_log_to_buffer(&log));
        log_manager->flush_log_to_disk();
    }
    while (!txn->get_lock_set()->empty()) {
        lock_manager_->unlock(txn, *txn->get_lock_set()->begin());
    }
    for (auto write_record : *txn->get_write_set()) {
        delete write_record;
    }
    txn->get_write_set()->clear();
    txn->set_state(TransactionState::COMMITTED);
}

/**
 * @description: 事务的终止（回滚）方法
 * @param {Transaction *} txn 需要回滚的事务
 * @param {LogManager} *log_manager 日志管理器指针
 */
void TransactionManager::abort(Transaction * txn, LogManager *log_manager) {
    if (txn == nullptr) {
        return;
    }
    auto write_set = txn->get_write_set();
    for (auto iter = write_set->rbegin(); iter != write_set->rend(); ++iter) {
        WriteRecord *write_record = *iter;
        const std::string tab_name = write_record->GetTableName();
        RmFileHandle *fh = sm_manager_->fhs_.at(tab_name).get();
        Rid rid = write_record->GetRid();

        if (write_record->GetWriteType() == WType::INSERT_TUPLE) {
            auto rec = fh->get_record(rid, nullptr);
            sm_manager_->delete_index_entries(tab_name, rec->data);
            fh->delete_record(rid, nullptr);
        } else if (write_record->GetWriteType() == WType::DELETE_TUPLE) {
            RmRecord &old_rec = write_record->GetRecord();
            fh->insert_record(rid, old_rec.data);
            sm_manager_->insert_index_entries(tab_name, old_rec.data, rid);
        } else if (write_record->GetWriteType() == WType::UPDATE_TUPLE) {
            RmRecord &old_rec = write_record->GetRecord();
            auto cur_rec = fh->get_record(rid, nullptr);
            sm_manager_->delete_index_entries(tab_name, cur_rec->data);
            fh->update_record(rid, old_rec.data, nullptr);
            sm_manager_->insert_index_entries(tab_name, old_rec.data, rid);
        }
        delete write_record;
    }
    while (!txn->get_lock_set()->empty()) {
        lock_manager_->unlock(txn, *txn->get_lock_set()->begin());
    }
    txn->get_write_set()->clear();
    if (log_manager != nullptr) {
        AbortLogRecord log(txn->get_transaction_id());
        txn->set_prev_lsn(log_manager->add_log_to_buffer(&log));
        log_manager->flush_log_to_disk();
    }
    txn->set_state(TransactionState::ABORTED);
}
