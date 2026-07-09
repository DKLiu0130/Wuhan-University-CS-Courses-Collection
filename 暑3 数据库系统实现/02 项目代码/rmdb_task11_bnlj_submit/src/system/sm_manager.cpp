/* Copyright (c) 2023 Renmin University of China
RMDB is licensed under Mulan PSL v2.
You can use this software according to the terms and conditions of the Mulan PSL v2.
You may obtain a copy of Mulan PSL v2 at:
        http://license.coscl.org.cn/MulanPSL2
THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
See the Mulan PSL v2 for more details. */

#include "sm_manager.h"

#include <sys/stat.h>
#include <unistd.h>

#include <fstream>
#include <sstream>
#include "index/ix.h"
#include "record/rm.h"
#include "record_printer.h"

namespace {
void append_u64(std::string &out, uint64_t v, int bytes) {
    for (int i = bytes - 1; i >= 0; --i) out.push_back(static_cast<char>((v >> (i * 8)) & 0xff));
}

void append_index_part(std::string &out, ColType type, int len, const char *data) {
    if (type == TYPE_INT) {
        uint32_t v = static_cast<uint32_t>(*reinterpret_cast<const int *>(data)) ^ 0x80000000u;
        append_u64(out, v, 4);
    } else if (type == TYPE_BIGINT || type == TYPE_DATETIME) {
        uint64_t v = static_cast<uint64_t>(*reinterpret_cast<const int64_t *>(data)) ^ 0x8000000000000000ull;
        append_u64(out, v, 8);
    } else if (type == TYPE_FLOAT) {
        uint32_t v;
        memcpy(&v, data, sizeof(uint32_t));
        v = (v & 0x80000000u) ? ~v : (v ^ 0x80000000u);
        append_u64(out, v, 4);
    } else {
        out.append(data, len);
    }
}
}

/**
 * @description: 判断是否为一个文件夹
 * @return {bool} 返回是否为一个文件夹
 * @param {string&} db_name 数据库文件名称，与文件夹同名
 */
bool SmManager::is_dir(const std::string& db_name) {
    struct stat st;
    return stat(db_name.c_str(), &st) == 0 && S_ISDIR(st.st_mode);
}

/**
 * @description: 创建数据库，所有的数据库相关文件都放在数据库同名文件夹下
 * @param {string&} db_name 数据库名称
 */
void SmManager::create_db(const std::string& db_name) {
    if (is_dir(db_name)) {
        throw DatabaseExistsError(db_name);
    }
    //为数据库创建一个子目录
    std::string cmd = "mkdir " + db_name;
    if (system(cmd.c_str()) < 0) {  // 创建一个名为db_name的目录
        throw UnixError();
    }
    if (chdir(db_name.c_str()) < 0) {  // 进入名为db_name的目录
        throw UnixError();
    }
    //创建系统目录
    DbMeta *new_db = new DbMeta();
    new_db->name_ = db_name;

    // 注意，此处ofstream会在当前目录创建(如果没有此文件先创建)和打开一个名为DB_META_NAME的文件
    std::ofstream ofs(DB_META_NAME);

    // 将new_db中的信息，按照定义好的operator<<操作符，写入到ofs打开的DB_META_NAME文件中
    ofs << *new_db;  // 注意：此处重载了操作符<<

    delete new_db;

    // 创建日志文件
    disk_manager_->create_file(LOG_FILE_NAME);

    // 回到根目录
    if (chdir("..") < 0) {
        throw UnixError();
    }
}

/**
 * @description: 删除数据库，同时需要清空相关文件以及数据库同名文件夹
 * @param {string&} db_name 数据库名称，与文件夹同名
 */
void SmManager::drop_db(const std::string& db_name) {
    if (!is_dir(db_name)) {
        throw DatabaseNotFoundError(db_name);
    }
    std::string cmd = "rm -r " + db_name;
    if (system(cmd.c_str()) < 0) {
        throw UnixError();
    }
}

/**
 * @description: 打开数据库，找到数据库对应的文件夹，并加载数据库元数据和相关文件
 * @param {string&} db_name 数据库名称，与文件夹同名
 */
void SmManager::open_db(const std::string& db_name) {
    if (!is_dir(db_name)) {
        throw DatabaseNotFoundError(db_name);
    }
    if (chdir(db_name.c_str()) < 0) {
        throw UnixError();
    }

    std::ifstream ifs(DB_META_NAME);
    if (!ifs.is_open()) {
        throw UnixError();
    }
    ifs >> db_;
    ifs.close();

    fhs_.clear();
    ihs_.clear();
    for (auto &entry : db_.tabs_) {
        fhs_.emplace(entry.first, rm_manager_->open_file(entry.first));
        for (auto &index : entry.second.indexes) {
            std::string index_name = ix_manager_->get_index_name(entry.first, index.cols);
            ihs_.emplace(index_name, ix_manager_->open_index(entry.first, index.cols));
        }
    }
    mem_indexes_.clear();
    for (auto &entry : db_.tabs_) {
        for (auto &index : entry.second.indexes) {
            rebuild_index(entry.first, index, nullptr);
        }
    }
}

/**
 * @description: 把数据库相关的元数据刷入磁盘中
 */
void SmManager::flush_meta() {
    // 默认清空文件
    std::ofstream ofs(DB_META_NAME);
    ofs << db_;
}

/**
 * @description: 关闭数据库并把数据落盘
 */
void SmManager::close_db() {
    flush_meta();
    for (auto &entry : fhs_) {
        rm_manager_->close_file(entry.second.get());
    }
    fhs_.clear();
    for (auto &entry : ihs_) {
        ix_manager_->close_index(entry.second.get());
    }
    ihs_.clear();
    if (chdir("..") < 0) {
        throw UnixError();
    }
}

/**
 * @description: 显示所有的表,通过测试需要将其结果写入到output.txt,详情看题目文档
 * @param {Context*} context 
 */
void SmManager::show_tables(Context* context) {
    std::fstream outfile;
    outfile.open("output.txt", std::ios::out | std::ios::app);
    outfile << "| Tables |\n";
    RecordPrinter printer(1);
    printer.print_separator(context);
    printer.print_record({"Tables"}, context);
    printer.print_separator(context);
    for (auto &entry : db_.tabs_) {
        auto &tab = entry.second;
        printer.print_record({tab.name}, context);
        outfile << "| " << tab.name << " |\n";
    }
    printer.print_separator(context);
    outfile.close();
}

void SmManager::show_index(const std::string& tab_name, Context* context) {
    TabMeta &tab = db_.get_table(tab_name);
    std::fstream outfile;
    outfile.open("output.txt", std::ios::out | std::ios::app);
    for (auto &index : tab.indexes) {
        std::string cols = "(";
        for (size_t i = 0; i < index.cols.size(); ++i) {
            if (i > 0) cols += ",";
            cols += index.cols[i].name;
        }
        cols += ")";
        outfile << "| " << tab_name << " | unique | " << cols << " |\n";
        if (context != nullptr) {
            RecordPrinter printer(3);
            printer.print_record({tab_name, "unique", cols}, context);
        }
    }
    outfile.close();
}

/**
 * @description: 显示表的元数据
 * @param {string&} tab_name 表名称
 * @param {Context*} context 
 */
void SmManager::desc_table(const std::string& tab_name, Context* context) {
    TabMeta &tab = db_.get_table(tab_name);

    std::vector<std::string> captions = {"Field", "Type", "Index"};
    RecordPrinter printer(captions.size());
    // Print header
    printer.print_separator(context);
    printer.print_record(captions, context);
    printer.print_separator(context);
    // Print fields
    for (auto &col : tab.cols) {
        std::vector<std::string> field_info = {col.name, coltype2str(col.type), col.index ? "YES" : "NO"};
        printer.print_record(field_info, context);
    }
    // Print footer
    printer.print_separator(context);
}


/**
 * @description: 创建表
 * @param {string&} tab_name 表的名称
 * @param {vector<ColDef>&} col_defs 表的字段
 * @param {Context*} context 
 */
void SmManager::create_table(const std::string& tab_name, const std::vector<ColDef>& col_defs, Context* context) {
    if (db_.is_table(tab_name)) {
        throw TableExistsError(tab_name);
    }
    // Create table meta
    int curr_offset = 0;
    TabMeta tab;
    tab.name = tab_name;
    for (auto &col_def : col_defs) {
        ColMeta col = {.tab_name = tab_name,
                       .name = col_def.name,
                       .type = col_def.type,
                       .len = col_def.len,
                       .offset = curr_offset,
                       .index = false};
        curr_offset += col_def.len;
        tab.cols.push_back(col);
    }
    // Create & open record file
    int record_size = curr_offset;  // record_size就是col meta所占的大小（表的元数据也是以记录的形式进行存储的）
    rm_manager_->create_file(tab_name, record_size);
    db_.tabs_[tab_name] = tab;
    // fhs_[tab_name] = rm_manager_->open_file(tab_name);
    fhs_.emplace(tab_name, rm_manager_->open_file(tab_name));

    flush_meta();
}

/**
 * @description: 删除表
 * @param {string&} tab_name 表的名称
 * @param {Context*} context
 */
void SmManager::drop_table(const std::string& tab_name, Context* context) {
    if (!db_.is_table(tab_name)) {
        throw TableNotFoundError(tab_name);
    }
    auto &tab = db_.get_table(tab_name);
    for (auto &index : tab.indexes) {
        std::string index_name = ix_manager_->get_index_name(tab_name, index.cols);
        if (ihs_.count(index_name)) {
            ix_manager_->close_index(ihs_.at(index_name).get());
            ihs_.erase(index_name);
        }
        ix_manager_->destroy_index(tab_name, index.cols);
    }
    if (fhs_.count(tab_name)) {
        rm_manager_->close_file(fhs_.at(tab_name).get());
        fhs_.erase(tab_name);
    }
    rm_manager_->destroy_file(tab_name);
    db_.tabs_.erase(tab_name);
    flush_meta();
}

/**
 * @description: 创建索引
 * @param {string&} tab_name 表的名称
 * @param {vector<string>&} col_names 索引包含的字段名称
 * @param {Context*} context
 */
void SmManager::create_index(const std::string& tab_name, const std::vector<std::string>& col_names, Context* context) {
    if (!db_.is_table(tab_name)) {
        throw TableNotFoundError(tab_name);
    }
    TabMeta &tab = db_.get_table(tab_name);
    if (tab.is_index(col_names)) {
        throw IndexExistsError(tab_name, col_names);
    }
    std::vector<ColMeta> cols;
    int col_tot_len = 0;
    for (const auto &col_name : col_names) {
        auto col = tab.get_col(col_name);
        cols.push_back(*col);
        col_tot_len += col->len;
    }

    std::map<std::string, Rid> new_index;
    auto fh = fhs_.at(tab_name).get();
    for (RmScan scan(fh); !scan.is_end(); scan.next()) {
        auto rec = fh->get_record(scan.rid(), context);
        std::string key = make_key(cols, rec->data);
        if (new_index.count(key)) {
            throw InternalError("duplicate key");
        }
        new_index[key] = scan.rid();
    }

    ix_manager_->create_index(tab_name, cols);
    std::string index_name = ix_manager_->get_index_name(tab_name, cols);
    ihs_.emplace(index_name, ix_manager_->open_index(tab_name, cols));
    IndexMeta index_meta{tab_name, col_tot_len, static_cast<int>(cols.size()), cols};
    tab.indexes.push_back(index_meta);
    for (const auto &col_name : col_names) {
        tab.get_col(col_name)->index = true;
    }
    mem_indexes_[get_index_key_name(tab_name, cols)] = std::move(new_index);
    flush_meta();
}

/**
 * @description: 删除索引
 * @param {string&} tab_name 表名称
 * @param {vector<string>&} col_names 索引包含的字段名称
 * @param {Context*} context
 */
void SmManager::drop_index(const std::string& tab_name, const std::vector<std::string>& col_names, Context* context) {
    if (!db_.is_table(tab_name)) {
        throw TableNotFoundError(tab_name);
    }
    TabMeta &tab = db_.get_table(tab_name);
    auto index_it = tab.get_index_meta(col_names);
    std::vector<ColMeta> cols = index_it->cols;
    std::string index_name = ix_manager_->get_index_name(tab_name, cols);
    if (ihs_.count(index_name)) {
        ix_manager_->close_index(ihs_.at(index_name).get());
        ihs_.erase(index_name);
    }
    ix_manager_->destroy_index(tab_name, cols);
    mem_indexes_.erase(get_index_key_name(tab_name, cols));
    for (auto &col_name : col_names) {
        tab.get_col(col_name)->index = false;
    }
    tab.indexes.erase(index_it);
    flush_meta();
}

/**
 * @description: 删除索引
 * @param {string&} tab_name 表名称
 * @param {vector<ColMeta>&} 索引包含的字段元数据
 * @param {Context*} context
 */
void SmManager::drop_index(const std::string& tab_name, const std::vector<ColMeta>& cols, Context* context) {
    std::vector<std::string> col_names;
    for (auto &col : cols) {
        col_names.push_back(col.name);
    }
    drop_index(tab_name, col_names, context);
}

std::string SmManager::get_index_key_name(const std::string& tab_name, const std::vector<ColMeta>& cols) {
    std::string name = tab_name;
    for (auto &col : cols) name += "_" + col.name;
    return name;
}

std::string SmManager::make_key(const std::vector<ColMeta>& cols, const char *record) {
    std::string key;
    for (auto &col : cols) {
        append_index_part(key, col.type, col.len, record + col.offset);
    }
    return key;
}

void SmManager::rebuild_index(const std::string& tab_name, const IndexMeta& index, Context* context) {
    auto &idx = mem_indexes_[get_index_key_name(tab_name, index.cols)];
    idx.clear();
    auto fh = fhs_.at(tab_name).get();
    for (RmScan scan(fh); !scan.is_end(); scan.next()) {
        auto rec = fh->get_record(scan.rid(), context);
        std::string key = make_key(index.cols, rec->data);
        if (idx.count(key)) {
            throw InternalError("duplicate key");
        }
        idx[key] = scan.rid();
    }
}

void SmManager::check_unique_indexes(const std::string& tab_name, const char *record, const Rid *self) {
    auto &tab = db_.get_table(tab_name);
    for (auto &index : tab.indexes) {
        auto it = mem_indexes_.find(get_index_key_name(tab_name, index.cols));
        if (it == mem_indexes_.end()) continue;
        std::string key = make_key(index.cols, record);
        auto pos = it->second.find(key);
        if (pos != it->second.end() && (self == nullptr || pos->second != *self)) {
            throw InternalError("duplicate key");
        }
    }
}

void SmManager::insert_index_entries(const std::string& tab_name, const char *record, const Rid& rid) {
    auto &tab = db_.get_table(tab_name);
    for (auto &index : tab.indexes) {
        mem_indexes_[get_index_key_name(tab_name, index.cols)][make_key(index.cols, record)] = rid;
    }
}

void SmManager::delete_index_entries(const std::string& tab_name, const char *record) {
    auto &tab = db_.get_table(tab_name);
    for (auto &index : tab.indexes) {
        mem_indexes_[get_index_key_name(tab_name, index.cols)].erase(make_key(index.cols, record));
    }
}

std::vector<Rid> SmManager::search_index(const std::string& tab_name, const std::vector<std::string>& index_cols,
                                         const std::vector<Condition>& conds) {
    std::vector<Rid> rids;
    auto &tab = db_.get_table(tab_name);
    auto index_meta = tab.get_index_meta(index_cols);
    auto it = mem_indexes_.find(get_index_key_name(tab_name, index_meta->cols));
    if (it == mem_indexes_.end()) return rids;
    auto &idx = it->second;

    std::string low, high;
    bool has_low = false, has_high = false, low_inc = true, high_inc = true;
    int full_key_len = 0;
    for (auto &col : index_meta->cols) full_key_len += col.len;
    for (auto &col : index_meta->cols) {
        const Condition *eq = nullptr;
        const Condition *gt = nullptr;
        const Condition *ge = nullptr;
        const Condition *lt = nullptr;
        const Condition *le = nullptr;
        for (auto &cond : conds) {
            if (!cond.is_rhs_val || cond.lhs_col.tab_name != tab_name || cond.lhs_col.col_name != col.name) continue;
            if (cond.op == OP_EQ) eq = &cond;
            else if (cond.op == OP_GT) gt = &cond;
            else if (cond.op == OP_GE) ge = &cond;
            else if (cond.op == OP_LT) lt = &cond;
            else if (cond.op == OP_LE) le = &cond;
        }
        if (eq != nullptr) {
            append_index_part(low, col.type, col.len, eq->rhs_val.raw->data);
            append_index_part(high, col.type, col.len, eq->rhs_val.raw->data);
            has_low = has_high = true;
            continue;
        }
        if (ge != nullptr || gt != nullptr) {
            auto c = ge != nullptr ? ge : gt;
            append_index_part(low, col.type, col.len, c->rhs_val.raw->data);
            has_low = true;
            low_inc = ge != nullptr;
        }
        if (le != nullptr || lt != nullptr) {
            auto c = le != nullptr ? le : lt;
            append_index_part(high, col.type, col.len, c->rhs_val.raw->data);
            has_high = true;
            high_inc = le != nullptr;
        } else if ((ge != nullptr || gt != nullptr) && !high.empty()) {
            has_high = true;
            high_inc = true;
            high.append(full_key_len - high.size(), static_cast<char>(0xff));
        }
        break;
    }
    if (has_high && high_inc && static_cast<int>(high.size()) < full_key_len) {
        high.append(full_key_len - high.size(), static_cast<char>(0xff));
    }
    auto begin = has_low ? (low_inc ? idx.lower_bound(low) : idx.upper_bound(low)) : idx.begin();
    for (auto iter = begin; iter != idx.end(); ++iter) {
        if (has_high) {
            int cmp = iter->first.compare(high);
            if ((high_inc && cmp > 0) || (!high_inc && cmp >= 0)) break;
        }
        rids.push_back(iter->second);
    }
    return rids;
}
