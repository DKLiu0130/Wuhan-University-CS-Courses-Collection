# 题目 5 EFE 版本代码改动说明

本文档说明 `task5_EFE` 分支中唯一索引功能的实现思路、主要改动文件和测试关注点。

## 实现目标

题目要求在已有查询执行系统上增加唯一索引功能，支持：

- `create index table_name(col)`
- `create index table_name(col1,col2)`
- `drop index table_name(col)`
- `drop index table_name(col1,col2)`
- `show index from table_name`
- 建索引后的单点查询和范围查询
- 插入、删除、更新时同步维护索引
- 唯一性约束检查

本版本是在题目 7 的基础上继续实现的，分支名为 `task5_EFE`。

## 总体思路

框架原本提供了 B+ 树相关代码，但其中仍有较多 TODO。题目提示允许使用其他类型索引，因此本版本采用了一个更稳的实现方式：

- 元数据层仍然使用框架已有的 `IndexMeta` 保存索引定义。
- SQL 层仍然支持 `create/drop/show index`。
- 查询计划层仍然生成 `IndexScan`，使索引查询走独立路径。
- 具体索引结构使用 `std::map<std::string, Rid>` 在内存中维护。
- key 由索引列的原始值编码拼接而成，`std::map` 按字典序有序保存。
- 执行范围查询时，用 `lower_bound` / `upper_bound` 快速定位范围。
- `IndexScanExecutor` 拿到候选 rid 后，再用原有 `eval_conds` 做一次完整过滤，保证结果正确。

这个方案的好处是改动集中、行为可控，并且可以支持题目要求的唯一索引、单点查询、范围查询和 DML 同步维护。

## 主要改动文件

### `src/parser/ast.h`

新增 AST 节点：

```cpp
struct ShowIndex : public TreeNode {
    std::string tab_name;
};
```

用于表示：

```sql
show index from warehouse;
```

### `src/parser/yacc.y`

新增语法：

```yacc
SHOW INDEX FROM tbName
```

解析后生成 `ShowIndex` 节点。

同时复用已有的：

```sql
create index table_name(col1,col2);
drop index table_name(col1,col2);
```

### `src/optimizer/plan.h`

新增计划类型：

```cpp
T_ShowIndex
```

用于区分 `show index from table` 语句。

### `src/optimizer/planner.cpp`

主要改动：

- 识别 `ShowIndex` AST，生成 `OtherPlan(T_ShowIndex)`。
- 修改 `get_index_cols`，支持最左匹配原则。

最左匹配规则大致是：

- 对每个索引，按索引列顺序检查查询条件。
- 只要索引最左列存在条件，就可以考虑使用该索引。
- 如果当前列是等值条件，可以继续匹配下一列。
- 如果当前列是范围条件，则到当前列为止。
- 选择匹配长度最长的索引。

因此可以支持：

```sql
where id = 1
where id > 1
where id = 1 and name = 'abcd'
where name = 'abcd' and id = 1
where id = 1 and name > 'abcd'
```

### `src/system/sm_manager.h`

新增内存索引结构：

```cpp
std::unordered_map<std::string, std::map<std::string, Rid>> mem_indexes_;
```

其中：

- 外层 key 是索引名，例如 `warehouse_w_id_name`。
- 内层 `std::map` 保存编码后的索引 key 到 `Rid` 的映射。
- 因为是唯一索引，所以一个 key 只对应一个 `Rid`。

新增辅助接口：

- `show_index`
- `get_index_key_name`
- `make_key`
- `rebuild_index`
- `check_unique_indexes`
- `insert_index_entries`
- `delete_index_entries`
- `search_index`

### `src/system/sm_manager.cpp`

这是题目 5 的核心文件。

#### 1. 打开数据库时重建内存索引

在 `open_db` 中：

- 读取 `db.meta`。
- 打开表文件。
- 打开已有索引文件。
- 根据表中已有记录重建 `mem_indexes_`。

这样数据库重启后，索引仍然可用。

#### 2. `show index from table`

`show_index` 遍历表上的 `tab.indexes`，输出格式：

```text
| table_name | unique | (column_name,column_name) |
```

注意多个字段之间逗号后没有空格，符合题目要求。

#### 3. 创建索引

`create_index` 的流程：

1. 检查表是否存在。
2. 检查索引是否已经存在。
3. 检查索引列是否存在。
4. 遍历表中已有记录，构造临时 `std::map`。
5. 如果发现重复 key，直接抛错，输出 `failure`。
6. 确认无重复后，才创建索引文件、写元数据、写入内存索引。

这里后续修复过一个隐藏测试风险：原先如果已有重复值，可能先污染索引元数据再 `failure`。现在改成先完整检查，确认成功后再修改元数据。

#### 4. 删除索引

`drop_index` 的流程：

1. 检查表是否存在。
2. 查找索引元数据。
3. 关闭并删除索引文件。
4. 从 `tab.indexes` 删除对应元数据。
5. 清理 `mem_indexes_` 中对应内存索引。
6. 刷新元数据。

这里也修复过一个隐藏测试风险：删除索引后必须同步清掉内存索引，否则同名索引重建或后续查询可能被旧数据影响。

#### 5. key 编码

内存索引用 `std::string` 拼接字节作为 key。

为了让 `std::map` 的字典序和数据库类型的大小关系一致，不能直接拼小端原始内存，因此做了编码：

- `INT`：转成大端，并翻转符号位。
- `BIGINT` / `DATETIME`：转成大端，并翻转符号位。
- `FLOAT`：转换成可排序的 IEEE 编码。
- `CHAR(n)`：直接按固定长度字节拼接。

这样 `std::map` 的顺序就能用于范围查询。

#### 6. 查询索引

`search_index` 根据索引列和查询条件生成范围边界：

- 等值条件同时扩展 `low` 和 `high`。
- 大于 / 大于等于条件扩展 `low`。
- 小于 / 小于等于条件扩展 `high`。
- 只使用最左连续可用前缀。
- 返回范围内的候选 `Rid`。

返回的候选记录还会在 `IndexScanExecutor` 里调用 `eval_conds` 再过滤，因此即使范围略宽，也不会返回错误数据。

#### 7. storage_test4 修复点

最新提交 `d209220` 主要修复了高概率导致 `storage_test4` mismatch 的问题：

- 创建唯一索引时，先检查已有数据是否重复，成功后才写入索引元数据。
- 删除索引时同步清理内存索引。
- 修正联合索引最左前缀边界，例如：

```sql
where a = 1
where a = 1 and b > 'aaaa'
```

- 防止范围扫描 begin/end 反向时迭代异常。

### `src/execution/executor_index_scan.h`

原来的 `IndexScanExecutor` 实际仍然偏向顺序扫描。

本版本改成：

1. 调用 `SmManager::search_index` 获取候选 `Rid` 列表。
2. 用 `cursor_` 遍历这些候选记录。
3. 对每条候选记录调用 `eval_conds` 做完整条件过滤。
4. 返回满足条件的记录。

这样查询会真正走索引路径。

### `src/execution/executor_insert.h`

插入记录时：

1. 构造完整记录。
2. 调用 `check_unique_indexes` 检查唯一性。
3. 插入表文件。
4. 调用 `insert_index_entries` 把新记录加入所有相关索引。

如果违反唯一性约束，会输出 `failure`。

### `src/execution/executor_delete.h`

删除记录时：

1. 先读取旧记录。
2. 调用 `delete_index_entries` 删除旧索引项。
3. 再删除表文件中的记录。

### `src/execution/executor_update.h`

更新记录时：

1. 读取旧记录。
2. 深拷贝旧记录用于删除旧索引项。
3. 修改记录内容。
4. 调用 `check_unique_indexes` 检查更新后的记录是否违反唯一性。
5. 删除旧索引项。
6. 更新表文件记录。
7. 插入新索引项。

`RmRecord` 已确认实现了深拷贝构造函数，所以：

```cpp
auto old_rec = std::make_unique<RmRecord>(*rec);
```

不会和 `rec->data` 共用同一块内存。

## 验证情况

本地验证过题目给出的主要场景：

### 创建、删除、展示索引

```sql
create table warehouse (id int, name char(8));
create index warehouse (id);
show index from warehouse;
create index warehouse (id,name);
show index from warehouse;
drop index warehouse (id);
drop index warehouse (id,name);
show index from warehouse;
```

输出格式符合：

```text
| warehouse | unique | (id) |
| warehouse | unique | (id) |
| warehouse | unique | (id,name) |
```

### 索引查询

验证了：

```sql
select * from warehouse where w_id = 10;
select * from warehouse where w_id < 534 and w_id > 100;
select * from warehouse where name = 'qweruiop';
select * from warehouse where name > 'qwerghjk';
select * from warehouse where name > 'aszdefgh' and name < 'qweraaaa';
select * from warehouse where w_id = 100 and name = 'qwerghjk';
select * from warehouse where w_id < 600 and name > 'bztyhnmj';
```

输出与题目样例一致。

### 索引维护

验证了：

- 建索引后插入新记录，索引可查到。
- 更新索引列后，旧 key 被删除，新 key 可查到。
- 删除记录后，索引中对应项被删除。
- 插入重复唯一 key 时输出 `failure`。

## 分支和提交

GitHub 分支：

```text
task5_EFE
```

关键提交：

```text
c165a22 Implement unique index EFE
d209220 Fix index build and prefix range scan
```

提交 zip：

```text
M:\workspace\DBlab\rmdb_task5_EFE_submit.zip
```

## 合并提醒

题目 5 和题目 6/7 都改到了 parser、planner、portal、execution 等模块。合并时重点看：

- `src/parser/ast.h`
- `src/parser/yacc.y`
- `src/parser/lex.l`
- `src/optimizer/plan.h`
- `src/optimizer/planner.cpp`
- `src/execution/executor_index_scan.h`
- `src/execution/executor_insert.h`
- `src/execution/executor_delete.h`
- `src/execution/executor_update.h`
- `src/system/sm_manager.h`
- `src/system/sm_manager.cpp`

建议用 Git 分支合并，不建议复制 zip 直接覆盖。
