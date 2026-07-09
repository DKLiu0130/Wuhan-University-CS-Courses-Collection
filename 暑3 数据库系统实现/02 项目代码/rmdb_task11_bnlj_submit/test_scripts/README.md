# 十道题测试脚本使用说明

## 脚本位置

所有脚本已经放在 WSL 的项目目录中：

```bash
/root/workspace/datalab/db2023/rmdb/test_scripts
```

结果目录：

```bash
/root/workspace/datalab/db2023/rmdb/test_scripts/results
```

每个脚本运行后都会在 `results/` 下生成一个 Markdown 结果文件，结果用表格展示 PASS/FAIL 和检查内容。

## 使用前准备

先进入项目目录并编译：

```bash
cd /root/workspace/datalab/db2023/rmdb
cmake --build build --target rmdb -j4
```

如果要跑全部测试：

```bash
cd /root/workspace/datalab/db2023/rmdb
./test_scripts/run_all_tests.sh
```

如果只跑某一道题：

```bash
python3 test_scripts/08_transaction.py
```

每个脚本会自动启动 `./build/bin/rmdb` 服务端，发送 SQL，收集客户端返回字符串，再关闭服务端。

## 题目 1：存储管理测试

脚本：

```bash
python3 test_scripts/01_storage_smoke.py
```

测试内容是创建表、插入记录、删除记录、再次插入记录并查询。它主要验证底层记录插入、删除、空闲 slot 复用和顺序扫描是否正常。

脚本检查三件事：`id=2` 的记录仍然存在，`id=3` 的新记录插入成功，删除后的 `id=1` 不再出现在结果中，并且总记录数为 2。

结果文件：

```bash
test_scripts/results/01_storage_smoke.md
```

## 题目 2：查询执行测试

脚本：

```bash
python3 test_scripts/02_query_execution.py
```

测试内容包括建表、插入多条记录、update、delete 和带 where 条件的 select。它覆盖 DDL、DML、DQL 和基本条件过滤。

脚本检查更新后的 `99.000000` 是否出现，删除后剩余记录数是否符合预期，以及查询结果中是否还能看到应保留的 `Data` 记录。

结果文件：

```bash
test_scripts/results/02_query_execution.md
```

## 题目 3：BIGINT 测试

脚本：

```bash
python3 test_scripts/03_bigint.py
```

测试内容是创建带 bigint 字段的表，插入一个较大的正数、一个较大的负数，再插入一个超出 bigint 范围的数。

脚本检查合法大整数是否能正确存储和输出，非法越界值是否输出 `failure`。

结果文件：

```bash
test_scripts/results/03_bigint.md
```

## 题目 4：DATETIME 测试

脚本：

```bash
python3 test_scripts/04_datetime.py
```

测试内容是创建 datetime 字段，插入合法时间，插入非法日期，并通过 datetime 条件执行 update。

脚本检查合法时间 `2023-05-18 09:12:19` 是否能保存，非法日期 `1999-02-30` 是否被拒绝，以及根据 datetime 条件更新后的 id 是否变为 `2023`。

结果文件：

```bash
test_scripts/results/04_datetime.md
```

## 题目 5：唯一索引测试

脚本：

```bash
python3 test_scripts/05_unique_index.py
```

测试内容是创建唯一索引、插入重复 key、展示索引、使用索引字段查询。

脚本检查 `show index` 是否输出 `| warehouse | unique | (w_id) |`，重复插入是否输出 `failure`，以及 `where w_id = 10` 是否能查到原记录。

结果文件：

```bash
test_scripts/results/05_unique_index.md
```

## 题目 6：聚合测试

脚本：

```bash
python3 test_scripts/06_aggregate.py
```

测试内容是插入三条数值记录，并查询原始数据。这个脚本主要用于确认聚合题前置的数据准备、扫描和数值输出正常。如果当前分支已经完整支持聚合语法，也可以在这个脚本基础上把 SQL 改成 `count`、`sum` 等聚合查询。

脚本检查三条输入记录是否都能正确写入和读出。它是轻量烟测，用于确认聚合功能依赖的表扫描和数值读取没有坏掉。

结果文件：

```bash
test_scripts/results/06_aggregate.md
```

## 题目 7：ORDER BY 和 LIMIT 测试

脚本：

```bash
python3 test_scripts/07_order_by_limit.py
```

测试内容是插入四条订单记录，并执行：

```sql
select company, order_number from orders order by order_number asc limit 2;
```

脚本检查结果是否只有两条，最小订单号对应的 `ACA` 是否出现，第二小订单号对应的 `AAA` 是否出现。

结果文件：

```bash
test_scripts/results/07_order_by_limit.md
```

## 题目 8：事务控制测试

脚本：

```bash
python3 test_scripts/08_transaction.py
```

测试内容是先插入一条初始记录，然后开启事务，在事务内插入并删除另一条记录，最后 abort，再查询表。

脚本检查初始记录 `xiaohong` 是否仍然存在，事务内记录是否没有残留，以及总记录数是否为 1。它主要验证事务写集和 abort 倒序撤销逻辑。

结果文件：

```bash
test_scripts/results/08_transaction.md
```

## 题目 9：并发控制测试

脚本：

```bash
python3 test_scripts/09_concurrency.py
```

测试内容是启动两个客户端连接。事务 1 先更新表并持有排他锁，事务 2 再尝试读取同一张表。

脚本检查事务 2 是否收到 `abort`。这个测试用于验证表级 S/X 锁和 no-wait 死锁预防策略是否生效。

结果文件：

```bash
test_scripts/results/09_concurrency.md
```

## 题目 10：故障恢复测试

脚本：

```bash
python3 test_scripts/10_crash_recovery.py
```

测试内容是模拟崩溃恢复。脚本先创建表，提交插入 `(1,1)`，再开启另一个事务插入 `(2,2)` 但不提交，然后发送 `crash` 让服务端退出。之后脚本重新启动数据库并查询表。

脚本检查已提交的 `(1,1)` 是否保留，未提交的 `(2,2)` 是否被 undo。这个测试覆盖 redo、undo，以及最新修复的新页恢复问题。

结果文件：

```bash
test_scripts/results/10_crash_recovery.md
```

## 结果怎么看

每个脚本会在终端输出类似这样的 Markdown 表格：

```markdown
| Test | Result | Detail |
|---|---:|---|
| committed row redone | PASS | id=1 should remain |
| uncommitted row undone | PASS | id=2 should be absent |
```

如果 `Result` 是 `PASS`，说明脚本检查项通过。如果是 `FAIL`，可以打开对应的 `results/*.md` 查看脚本保存的客户端输出。

这些脚本是功能烟测，不等价于平台隐藏测试。它们的作用是快速确认每道题的核心功能没有明显坏掉，尤其适合提交前本地自查。
