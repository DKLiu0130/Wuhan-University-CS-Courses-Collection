# RMDB 1-4题改动说明

这份文档用于给队友快速同步我们在 RMDB 上做过的 1-4 题修改。  
这里的 `1-4` 按我们实际推进顺序整理为：

1. 题目一：存储管理
2. 前置题目：查询执行
3. BIGINT 类型支持
4. DATETIME 类型支持

文档重点写三件事：

- 改了哪些文件
- 每块代码的实现思路
- 核心逻辑是怎么走的

---

## 1. 题目一：存储管理

### 1.1 修改文件

- `src/storage/disk_manager.cpp`
- `src/storage/disk_manager.h`
- `src/storage/buffer_pool_manager.cpp`
- `src/replacer/lru_replacer.cpp`
- `src/record/rm_file_handle.cpp`
- `src/record/rm_file_handle.h`
- `src/record/rm_scan.cpp`

### 1.2 DiskManager

#### 改动位置

- `src/storage/disk_manager.cpp`
- `src/storage/disk_manager.h`

#### 实现内容

实现了：

- `create_file`
- `open_file`
- `close_file`
- `destroy_file`
- `write_page`
- `read_page`

#### 思路

`DiskManager` 是最底层的文件管理模块，核心目标是：

- 能正确创建、打开、关闭、删除文件
- 能按 `page_no * PAGE_SIZE` 的偏移定位页面
- 文件重开后，上层看到的 fd 要稳定
- 并发下读写不能因为共享文件偏移而串页

#### 核心逻辑

1. 文件创建/删除

- `create_file` 先检查文件是否已存在，存在就抛 `FileExistsError`
- `destroy_file` 先检查文件是否存在、是否仍处于打开状态，再删除

2. 文件打开/关闭

- `open_file` 不直接把 OS 返回的原始 fd 暴露给上层
- 我们额外维护了一个“稳定虚拟 fd”
- 同一路径文件即使 `close` 后重新 `open`，上层拿到的还是同一个虚拟 fd

这样做的原因是：

- `BufferPoolManager` 的页表 key 里带有 `fd`
- `DiskManager::fd2pageno_` 也是按 `fd` 记录页号分配状态
- 如果文件重开后 fd 变了，缓存页、页号分配器、记录层会错位

3. 页面读写

- `write_page` 使用 `pwrite`
- `read_page` 使用 `pread`

原因：

- 原来如果用 `lseek + read/write`，多个线程共享同一个文件时会共享文件偏移
- 并发读写时可能出现“一个线程刚 seek，另一个线程又改了 offset”的问题
- `pread/pwrite` 直接按显式偏移读写，不依赖共享文件指针，更稳

4. 短读处理

- `read_page` 如果读到文件尾、不足一页，剩余部分补 0

这样做的目的是让“还没真正写满整个页”的内容读回时有确定结果。

---

### 1.3 LRUReplacer

#### 改动位置

- `src/replacer/lru_replacer.cpp`

#### 实现内容

实现了：

- `victim`
- `pin`
- `unpin`

#### 思路

这里按 LRU 的最基本实现来做：

- 用链表维护“可被替换的 frame”
- 用哈希表维护 `frame_id -> 链表位置`

#### 核心逻辑

1. `unpin(frame_id)`

- 页面不再被使用时，说明它可以被淘汰
- 如果它不在 LRU 里，就插到链表头部

2. `pin(frame_id)`

- 页面正在被使用时，不允许被替换
- 如果它在 LRU 里，就把它从 LRU 结构里删掉

3. `victim(frame_id*)`

- 从链表尾部取最久未使用的 frame
- 删除并返回

这里的链表语义是：

- 头部：最近刚进入可替换集合
- 尾部：最久没被访问，优先淘汰

---

### 1.4 BufferPoolManager

#### 改动位置

- `src/storage/buffer_pool_manager.cpp`

#### 实现内容

实现了：

- `new_page`
- `fetch_page`
- `find_victim_page`
- `update_page`
- `unpin_page`
- `delete_page`
- `flush_page`
- `flush_all_pages`

#### 思路

缓冲池的核心就是三件事：

- 页在不在内存里
- 不在内存时怎么找一个 frame 装进来
- 淘汰旧页时怎么保证脏页落盘

#### 核心逻辑

1. `find_victim_page`

- 优先从 `free_list_` 取空闲 frame
- 如果没有空闲 frame，再从 `replacer_` 里挑 victim

2. `fetch_page(page_id)`

- 如果页已经在 `page_table_` 中：
  - `pin_count++`
  - 从 replacer 中移除
  - 直接返回页面
- 如果页不在缓冲池：
  - 找 victim frame
  - 若 victim 是脏页，先落盘
  - 更新 `page_table_`
  - 从磁盘读入目标页
  - 设置 `pin_count = 1`

3. `new_page(page_id*)`

- 找一个可用 frame
- 调用 `disk_manager_->allocate_page(fd)` 分配新页号
- 用 `update_page` 把旧映射清掉
- 返回一个全新的页

4. `unpin_page`

- 页面使用结束后 `pin_count--`
- 如果减到 0，说明页面可以进入 replacer
- 如果调用时传入 `is_dirty=true`，页面会被标脏

5. `update_page`

- 被替换页如果是脏页，先写回磁盘
- 从页表删掉旧 `PageId`
- 清空页内容和元信息
- 绑定新页号到新 frame

6. `delete_page`

- 如果页不在缓冲池，直接视为删除成功
- 如果页在缓冲池但仍被 pin，不能删
- 如果可删，就清掉页表项，把 frame 放回 `free_list_`

7. `flush_page / flush_all_pages`

- 把页内容强制写回磁盘
- 写完后清掉 `is_dirty`

---

### 1.5 Record Manager

#### 改动位置

- `src/record/rm_file_handle.cpp`
- `src/record/rm_file_handle.h`
- `src/record/rm_scan.cpp`

#### 实现内容

实现了：

- `RmFileHandle::get_record`
- `RmFileHandle::insert_record(char *buf, Context *context)`
- `RmFileHandle::insert_record(const Rid &rid, char *buf)`
- `RmFileHandle::delete_record`
- `RmFileHandle::update_record`
- `RmFileHandle::fetch_page_handle`
- `RmFileHandle::create_new_page_handle`
- `RmFileHandle::create_page_handle`
- `RmFileHandle::release_page_handle`
- `RmScan::RmScan`
- `RmScan::next`
- `RmScan::is_end`

#### 思路

记录管理的关键是“页内 bitmap + 空闲页链表”。

- 每个记录页用 bitmap 标记 slot 是否被占用
- 文件头 `first_free_page_no` 指向第一个仍有空闲 slot 的页
- 满页删记录后，需要把该页重新挂回空闲页链

#### 核心逻辑

1. `get_record`

- 先拿到记录所在页
- 检查 `slot_no` 是否越界、bitmap 是否置位
- 合法就拷贝出一份 `RmRecord`

2. 无位置插入 `insert_record(buf, ...)`

- 先通过 `create_page_handle()` 拿一个有空位的页
- 用 bitmap 找第一个空闲 slot
- 写入数据、bitmap 置位、`num_records++`
- 如果该页写满：
  - 从空闲页链头部摘掉

3. 固定位置插入 `insert_record(rid, buf)`

- 主要用于回滚/恢复
- 先检查目标位置是否合法
- 如果该 slot 已经有记录，直接报错，不覆盖
- 否则置位 bitmap，写入数据
- 如果该页因此变满，需要把它从空闲页链中删除

4. 删除记录

- bitmap 清零
- `num_records--`
- 如果删之前该页是满页，说明它现在重新有空位：
  - 调用 `release_page_handle`
  - 重新挂回空闲页链

5. `release_page_handle`

- 把当前页挂到 `first_free_page_no` 前面
- 额外做了“防重复入链”检查

6. `create_new_page_handle`

- 通过缓冲池分配新页
- 初始化页头、bitmap
- 更新文件头的 `num_pages` 和 `first_free_page_no`

7. `RmScan`

- 从第一页记录页开始扫描
- 每页用 `Bitmap::next_bit(true, ...)` 找下一个有效记录
- 找不到就切到下一页

8. `is_record`

- 先判断 `Rid` 是否越界
- 再读取 bitmap 判断该 slot 是否真的存在记录
- 注意读取后会立刻 `unpin`

---

## 2. 前置题目：查询执行

### 2.1 修改文件

- `src/system/sm_manager.cpp`
- `src/analyze/analyze.cpp`
- `src/optimizer/planner.cpp`
- `src/optimizer/plan.h`
- `src/execution/execution_manager.cpp`
- `src/execution/executor_seq_scan.h`
- `src/execution/executor_index_scan.h`
- `src/execution/executor_nestedloop_join.h`
- `src/execution/executor_projection.h`
- `src/execution/executor_update.h`
- `src/execution/executor_delete.h`
- `src/portal.h`
- `src/rmdb.cpp`
- `src/transaction/transaction_manager.cpp`

### 2.2 元数据与 DDL

#### 改动位置

- `src/system/sm_manager.cpp`

#### 实现内容

补了数据库打开/关闭、删表等元数据流程，使系统能真正管理表和文件。

#### 思路

DDL 这块的核心是“元数据和实际文件同步”：

- 打开数据库时要把已存在的表都打开
- 删除表时要把对应数据文件、索引文件、句柄、元数据都清掉

#### 核心逻辑

1. `open_db`

- 读 `db.meta`
- 打开所有表文件
- 如果表上有索引，也一起打开索引文件

2. `close_db`

- 先刷元数据
- 再关闭所有 record/index 文件

3. `drop_table`

- 先删表上的所有索引
- 再关表文件、删表文件
- 最后删表元数据

---

### 2.3 语义分析

#### 改动位置

- `src/analyze/analyze.cpp`

#### 实现内容

补了：

- 列存在性检查
- 歧义列检查
- where 条件类型检查
- update 的 set 子句分析
- `int -> float` 自动兼容

#### 思路

分析器的角色不是执行 SQL，而是把“用户写的 SQL”整理成一个类型合法、列名明确的内部表示。

#### 核心逻辑

1. `check_column`

- 没写表名前缀时，在所有表列里推断
- 如果找到多个同名列，报歧义错误

2. `check_clause`

- where 左右两边类型必须匹配
- 对 `float = int` 这类情况做自动提升

3. `UpdateStmt`

- 把 `set a = ...` 变成内部 `SetClause`
- 在这里提前做类型校验

---

### 2.4 查询计划生成

#### 改动位置

- `src/optimizer/planner.cpp`
- `src/optimizer/plan.h`

#### 实现内容

实现了：

- 单表扫描计划
- 多表 Nested Loop Join
- Projection
- Update/Delete 的扫描子计划

#### 思路

为了先过功能测试，没有做复杂优化，而是：

- 单表：直接扫
- 多表：直接 Nested Loop Join
- select 最后再做 Projection

#### 核心逻辑

1. `make_one_rel`

- 单表时，直接生成一个 scan plan
- 多表时：
  - 先为每张表生成 scan
  - 再把连接条件拼成 join 树

2. `generate_select_plan`

- 先物理计划
- 再外包一层 `ProjectionPlan`

3. `do_planner`

- 根据 AST 类型分流：
  - create/drop table/index -> DDLPlan
  - insert/update/delete/select -> DMLPlan

---

### 2.5 执行器

#### 改动位置

- `src/execution/executor_seq_scan.h`
- `src/execution/executor_nestedloop_join.h`
- `src/execution/executor_projection.h`
- `src/execution/executor_update.h`
- `src/execution/executor_delete.h`
- `src/execution/executor_abstract.h`
- `src/execution/execution_manager.cpp`
- `src/portal.h`

#### 实现内容

实现了：

- 顺序扫描
- 嵌套循环连接
- 投影
- 更新
- 删除
- select 输出写入 `output.txt`

#### 思路

执行器层就是把 planner 给出的计划树逐层跑起来。

#### 核心逻辑

1. `SeqScanExecutor`

- 遍历表里所有记录
- 用 `eval_conds` 判断是否满足 where 条件

2. `NestedLoopJoinExecutor`

- 左表每条记录去配右表所有记录
- 满足连接条件就输出拼接后的结果

3. `ProjectionExecutor`

- 根据 select 列表从子执行器结果里裁出目标列

4. `UpdateExecutor`

- 先用扫描执行器找出所有满足 where 的 `Rid`
- 再逐条修改记录内容

5. `DeleteExecutor`

- 同样先扫出所有满足条件的 `Rid`
- 再逐条删记录

6. `execution_manager.cpp`

- `select_from` 同时负责：
  - 控制台输出
  - `output.txt` 输出

7. `rmdb.cpp`

- 语法错误时补了 `failure` 输出

---

## 3. BIGINT 类型支持

### 3.1 修改文件

- `src/defs.h`
- `src/common/common.h`
- `src/parser/ast.h`
- `src/parser/yacc.y`
- `src/parser/lex.l`
- `src/parser/ast_printer.h`
- `src/optimizer/planner.h`
- `src/analyze/analyze.cpp`
- `src/execution/executor_insert.h`
- `src/execution/executor_update.h`
- `src/execution/executor_abstract.h`
- `src/execution/execution_manager.cpp`
- `src/index/ix_index_handle.h`

### 3.2 思路

BIGINT 支持本质上要打通一整条链：

- parser 能识别
- AST 能表示
- analyze 能做类型检查
- 执行器能写进去
- 比较逻辑能比较
- 输出逻辑能打印

### 3.3 核心逻辑

1. 类型系统

- `defs.h` 增加 `TYPE_BIGINT`
- `common.h` 的 `Value` 增加 `int64_t bigint_val`
- 增加 `set_bigint`

2. parser

- `ast.h` 增加 `SV_TYPE_BIGINT` 和 `BigIntLit`
- `lex.l` 中：
  - 关键字支持 `BIGINT`
  - 整数字面量用 `strtoll`
  - 在 `int` 范围内返回 `VALUE_INT`
  - 超出 `int` 但仍合法时返回 `VALUE_BIGINT`
  - 溢出时故意回退成字符串，后续统一报 `failure`

3. planner / analyze

- `planner.h` 建立 `SV_TYPE_BIGINT -> TYPE_BIGINT` 映射
- `analyze.cpp` 支持：
  - `BigIntLit -> Value`
  - `int -> bigint` 自动提升

4. 执行器

- `executor_insert.h` / `executor_update.h`
  - 如果列类型是 `BIGINT`，而值是 `INT`，自动提升

5. 比较和输出

- `executor_abstract.h` 里增加 `TYPE_BIGINT` 比较逻辑
- `execution_manager.cpp` 里增加 BIGINT 输出
- `ix_index_handle.h` 里增加 BIGINT 索引键比较

---

## 4. DATETIME 类型支持

### 4.1 修改文件

- `src/defs.h`
- `src/common/common.h`
- `src/parser/ast.h`
- `src/parser/yacc.y`
- `src/parser/lex.l`
- `src/parser/ast_printer.h`
- `src/optimizer/planner.h`
- `src/analyze/analyze.cpp`
- `src/execution/executor_insert.h`
- `src/execution/executor_update.h`
- `src/execution/executor_abstract.h`
- `src/execution/execution_manager.cpp`
- `src/index/ix_index_handle.h`

### 4.2 思路

DATETIME 也需要走完整链路，但和 BIGINT 不同的是：

- 输入来源本质上是字符串字面量
- 需要做合法性校验
- 内部最好转成固定长度、可比较的 8 字节整数存储

所以我们把 DATETIME 编码成：

- `YYYYMMDDHHMMSS` 形式的 `int64_t`

这样好处是：

- 固定 8 字节
- 按整数比较就等价于按时间先后比较
- 写盘、索引、where 比较都方便

### 4.3 核心逻辑

1. 类型系统

- `defs.h` 增加 `TYPE_DATETIME`
- `common.h` 的 `Value` 增加 `datetime_val`

2. 合法性校验

- `common.h` 里增加：
  - `parse_datetime`
  - `datetime_to_string`
  - `set_datetime`

`parse_datetime` 负责检查：

- 长度必须是 19
- 格式必须是 `YYYY-MM-DD HH:MM:SS`
- 年范围 `1000~9999`
- 月 `1~12`
- 日必须符合月份和闰年规则
- 时 `0~23`
- 分秒 `0~59`

3. parser

- `yacc.y` 中支持 `DATETIME` 作为列类型
- 字面量仍走 `VALUE_STRING`
- 因为 SQL 里 datetime 写法本来就是 `'2023-05-18 09:12:19'`

4. analyze / executor

- 当目标列是 `TYPE_DATETIME` 且右值是字符串时：
  - `set_datetime`
  - 不合法直接抛类型错误

5. 比较和输出

- `executor_abstract.h` 对 DATETIME 按 `int64_t` 比较
- `execution_manager.cpp` 输出时再转回 `YYYY-MM-DD HH:MM:SS`
- `ix_index_handle.h` 支持 DATETIME 索引比较

---

## 5. 给队友的总总结

### 5.1 我们这 1-4 题整体做法

整体策略不是大重构，而是“顺着框架补链路”：

- 存储层：先把文件、页、记录、缓冲池补完整
- 查询层：先用最简单可过测试的执行框架把 DDL/DML/DQL 跑起来
- 新类型：沿着 parser -> analyze -> executor -> compare -> output 全链路打通

### 5.2 风险点

目前代码里最复杂、最容易继续出问题的点有两个：

- `DiskManager + BufferPoolManager + RmFileHandle` 这条存储链
- 索引功能目前不是把框架里的 B+ 树 TODO 全部补完，而是用了更轻量的内存索引同步方案

如果后面队友要继续改：

- 先不要随便动 `fd` 语义和 `page_table_` 逻辑
- 先确认 `Value` 类型扩展会不会影响 parser/analyze/executor 全链路
- 若要回归真正 B+ 树索引，需要重新补 `src/index` 下的 TODO，而不是只改执行层

### 5.3 建议队友阅读顺序

如果要快速接手，建议按这个顺序看：

1. `src/storage/disk_manager.cpp`
2. `src/storage/buffer_pool_manager.cpp`
3. `src/record/rm_file_handle.cpp`
4. `src/analyze/analyze.cpp`
5. `src/optimizer/planner.cpp`
6. `src/execution/execution_manager.cpp`
7. `src/common/common.h`
8. `src/parser/lex.l` + `src/parser/yacc.y`

这样能先理解底层数据怎么存，再理解 SQL 怎么一路变成执行结果。
