/* Copyright (c) 2023 Renmin University of China
RMDB is licensed under Mulan PSL v2.
You can use this software according to the terms and conditions of the Mulan PSL v2.
You may obtain a copy of Mulan PSL v2 at:
        http://license.coscl.org.cn/MulanPSL2
THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
See the Mulan PSL v2 for more details. */

#include "lock_manager.h"

namespace {
bool compatible(LockManager::LockMode held, LockManager::LockMode requested) {
    return held == LockManager::LockMode::SHARED && requested == LockManager::LockMode::SHARED;
}

bool lock_on_data(Transaction *txn, const LockDataId &lock_data_id, LockManager::LockMode lock_mode,
                  std::unordered_map<LockDataId, LockManager::LockRequestQueue> &lock_table,
                  std::mutex &latch) {
    if (txn == nullptr) return true;
    if (txn->get_state() == TransactionState::SHRINKING) {
        throw TransactionAbortException(txn->get_transaction_id(), AbortReason::LOCK_ON_SHIRINKING);
    }
    std::unique_lock<std::mutex> lock(latch);
    auto &queue = lock_table[lock_data_id];
    for (auto &request : queue.request_queue_) {
        if (request.txn_id_ == txn->get_transaction_id()) {
            if (request.lock_mode_ == lock_mode || request.lock_mode_ == LockManager::LockMode::EXLUCSIVE) return true;
            if (queue.request_queue_.size() > 1) {
                throw TransactionAbortException(txn->get_transaction_id(), AbortReason::DEADLOCK_PREVENTION);
            }
            request.lock_mode_ = lock_mode;
            request.granted_ = true;
            txn->get_lock_set()->insert(lock_data_id);
            return true;
        }
        if (request.granted_ && !compatible(request.lock_mode_, lock_mode)) {
            throw TransactionAbortException(txn->get_transaction_id(), AbortReason::DEADLOCK_PREVENTION);
        }
    }
    queue.request_queue_.emplace_back(txn->get_transaction_id(), lock_mode);
    queue.request_queue_.back().granted_ = true;
    queue.group_lock_mode_ = lock_mode == LockManager::LockMode::SHARED ? LockManager::GroupLockMode::S
                                                                        : LockManager::GroupLockMode::X;
    txn->get_lock_set()->insert(lock_data_id);
    return true;
}
}

/**
 * @description: 申请行级共享锁
 * @return {bool} 加锁是否成功
 * @param {Transaction*} txn 要申请锁的事务对象指针
 * @param {Rid&} rid 加锁的目标记录ID 记录所在的表的fd
 * @param {int} tab_fd
 */
bool LockManager::lock_shared_on_record(Transaction* txn, const Rid& rid, int tab_fd) {
    return lock_on_data(txn, LockDataId(tab_fd, rid, LockDataType::RECORD), LockMode::SHARED, lock_table_, latch_);
}

/**
 * @description: 申请行级排他锁
 * @return {bool} 加锁是否成功
 * @param {Transaction*} txn 要申请锁的事务对象指针
 * @param {Rid&} rid 加锁的目标记录ID
 * @param {int} tab_fd 记录所在的表的fd
 */
bool LockManager::lock_exclusive_on_record(Transaction* txn, const Rid& rid, int tab_fd) {
    return lock_on_data(txn, LockDataId(tab_fd, rid, LockDataType::RECORD), LockMode::EXLUCSIVE, lock_table_, latch_);
}

/**
 * @description: 申请表级读锁
 * @return {bool} 返回加锁是否成功
 * @param {Transaction*} txn 要申请锁的事务对象指针
 * @param {int} tab_fd 目标表的fd
 */
bool LockManager::lock_shared_on_table(Transaction* txn, int tab_fd) {
    return lock_on_data(txn, LockDataId(tab_fd, LockDataType::TABLE), LockMode::SHARED, lock_table_, latch_);
}

/**
 * @description: 申请表级写锁
 * @return {bool} 返回加锁是否成功
 * @param {Transaction*} txn 要申请锁的事务对象指针
 * @param {int} tab_fd 目标表的fd
 */
bool LockManager::lock_exclusive_on_table(Transaction* txn, int tab_fd) {
    return lock_on_data(txn, LockDataId(tab_fd, LockDataType::TABLE), LockMode::EXLUCSIVE, lock_table_, latch_);
}

/**
 * @description: 申请表级意向读锁
 * @return {bool} 返回加锁是否成功
 * @param {Transaction*} txn 要申请锁的事务对象指针
 * @param {int} tab_fd 目标表的fd
 */
bool LockManager::lock_IS_on_table(Transaction* txn, int tab_fd) {
    return lock_shared_on_table(txn, tab_fd);
}

/**
 * @description: 申请表级意向写锁
 * @return {bool} 返回加锁是否成功
 * @param {Transaction*} txn 要申请锁的事务对象指针
 * @param {int} tab_fd 目标表的fd
 */
bool LockManager::lock_IX_on_table(Transaction* txn, int tab_fd) {
    return lock_exclusive_on_table(txn, tab_fd);
}

/**
 * @description: 释放锁
 * @return {bool} 返回解锁是否成功
 * @param {Transaction*} txn 要释放锁的事务对象指针
 * @param {LockDataId} lock_data_id 要释放的锁ID
 */
bool LockManager::unlock(Transaction* txn, LockDataId lock_data_id) {
    if (txn == nullptr) return true;
    std::unique_lock<std::mutex> lock(latch_);
    auto it = lock_table_.find(lock_data_id);
    if (it == lock_table_.end()) return false;
    auto &queue = it->second.request_queue_;
    for (auto req = queue.begin(); req != queue.end(); ++req) {
        if (req->txn_id_ == txn->get_transaction_id()) {
            queue.erase(req);
            break;
        }
    }
    if (queue.empty()) lock_table_.erase(it);
    txn->get_lock_set()->erase(lock_data_id);
    if (txn->get_state() == TransactionState::GROWING) txn->set_state(TransactionState::SHRINKING);
    return true;
}
