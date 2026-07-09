#include "log_recovery.h"
#include <vector>
static std::string log_table_name(char *name, size_t size) { return std::string(name, size); }
static std::shared_ptr<LogRecord> make_log_record(const char *buf) {
    LogType type = *reinterpret_cast<const LogType*>(buf + OFFSET_LOG_TYPE);
    std::shared_ptr<LogRecord> rec;
    if (type == LogType::begin) rec = std::make_shared<BeginLogRecord>();
    else if (type == LogType::commit) rec = std::make_shared<CommitLogRecord>();
    else if (type == LogType::ABORT) rec = std::make_shared<AbortLogRecord>();
    else if (type == LogType::INSERT) rec = std::make_shared<InsertLogRecord>();
    else if (type == LogType::DELETE) rec = std::make_shared<DeleteLogRecord>();
    else if (type == LogType::UPDATE) rec = std::make_shared<UpdateLogRecord>();
    else rec = std::make_shared<LogRecord>();
    rec->deserialize(buf);
    return rec;
}
void RecoveryManager::analyze() {
    logs_.clear(); committed_.clear(); aborted_.clear();
    int file_size = disk_manager_->get_file_size(LOG_FILE_NAME), offset = 0;
    while (offset + LOG_HEADER_SIZE <= file_size) {
        char header[LOG_HEADER_SIZE];
        if (disk_manager_->read_log(header, LOG_HEADER_SIZE, offset) <= 0) break;
        uint32_t len = *reinterpret_cast<uint32_t*>(header + OFFSET_LOG_TOT_LEN);
        if (len < LOG_HEADER_SIZE || offset + static_cast<int>(len) > file_size) break;
        std::vector<char> buf(len); disk_manager_->read_log(buf.data(), len, offset);
        auto rec = make_log_record(buf.data()); logs_.push_back(rec);
        if (rec->log_type_ == LogType::commit) committed_.insert(rec->log_tid_);
        if (rec->log_type_ == LogType::ABORT) aborted_.insert(rec->log_tid_);
        offset += len;
    }
}
void RecoveryManager::redo() {
    for (auto &rec : logs_) {
        if (!committed_.count(rec->log_tid_)) continue;
        if (rec->log_type_ == LogType::INSERT) { auto r=std::static_pointer_cast<InsertLogRecord>(rec); auto fh=sm_manager_->fhs_.at(log_table_name(r->table_name_,r->table_name_size_)).get(); if(!fh->is_record(r->rid_)) fh->insert_record(r->rid_,r->insert_value_.data); else fh->update_record(r->rid_,r->insert_value_.data,nullptr); }
        else if (rec->log_type_ == LogType::DELETE) { auto r=std::static_pointer_cast<DeleteLogRecord>(rec); auto fh=sm_manager_->fhs_.at(log_table_name(r->table_name_,r->table_name_size_)).get(); if(fh->is_record(r->rid_)) fh->delete_record(r->rid_,nullptr); }
        else if (rec->log_type_ == LogType::UPDATE) { auto r=std::static_pointer_cast<UpdateLogRecord>(rec); auto fh=sm_manager_->fhs_.at(log_table_name(r->table_name_,r->table_name_size_)).get(); if(fh->is_record(r->rid_)) fh->update_record(r->rid_,r->new_value_.data,nullptr); }
    }
}
void RecoveryManager::undo() {
    for (auto it=logs_.rbegin(); it!=logs_.rend(); ++it) {
        auto rec=*it; if (committed_.count(rec->log_tid_) || aborted_.count(rec->log_tid_)) continue;
        if (rec->log_type_ == LogType::INSERT) { auto r=std::static_pointer_cast<InsertLogRecord>(rec); auto fh=sm_manager_->fhs_.at(log_table_name(r->table_name_,r->table_name_size_)).get(); if(fh->is_record(r->rid_)) fh->delete_record(r->rid_,nullptr); }
        else if (rec->log_type_ == LogType::DELETE) { auto r=std::static_pointer_cast<DeleteLogRecord>(rec); auto fh=sm_manager_->fhs_.at(log_table_name(r->table_name_,r->table_name_size_)).get(); if(!fh->is_record(r->rid_)) fh->insert_record(r->rid_,r->delete_value_.data); }
        else if (rec->log_type_ == LogType::UPDATE) { auto r=std::static_pointer_cast<UpdateLogRecord>(rec); auto fh=sm_manager_->fhs_.at(log_table_name(r->table_name_,r->table_name_size_)).get(); if(fh->is_record(r->rid_)) fh->update_record(r->rid_,r->old_value_.data,nullptr); }
    }
    for (auto &tab : sm_manager_->db_.tabs_) for (auto &idx : tab.second.indexes) sm_manager_->rebuild_index(tab.first, idx, nullptr);
    for (auto &entry : sm_manager_->fhs_) buffer_pool_manager_->flush_all_pages(entry.second->GetFd());
}
