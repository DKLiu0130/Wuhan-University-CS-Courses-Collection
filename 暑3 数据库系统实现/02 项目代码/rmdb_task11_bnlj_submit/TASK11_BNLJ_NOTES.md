# 题目十一：Block Nested-Loop Join 改动说明

本次在现有查询执行框架的基础上实现块嵌套循环连接算法。原来的连接执行器是普通 Nested Loop Join，它的执行方式是左表每取一条记录，就把右表从头扫一遍。这个做法在数据量很大时会频繁重复扫描右表，题目十一要求改成 Block Nested-Loop Join，所以我把连接执行器内部改成按块处理左表记录。

主要改动文件是 `src/execution/executor_nestedloop_join.h`。为了尽量少影响 planner 和 portal，我没有新增新的 plan 类型，而是保留原来的 `NestedLoopJoinExecutor` 类名和接口，让原来所有 JoinPlan 仍然能正常转换成这个执行器。区别在于执行器内部逻辑已经从“单条左记录 + 全右表扫描”改成了“左表一块记录 + 全右表扫描”。这样不用改解析层、优化层和 portal 的调用方式，已有 join 查询会自动使用新的 BNLJ 实现。

实现里定义了一个 `JOIN_BUFFER_SIZE`，当前设置为 8MB。执行开始时，`load_left_block()` 会从左子执行器连续读取记录，把这些记录拷贝到 `left_block_` 里，直到达到块大小或者左表读完。然后右子执行器从头开始扫描，每取到一条右表记录，就和当前左块里的所有记录依次拼接成 join 后的记录，再用原有的 `eval_conds` 判断连接条件是否满足。满足条件时就把拼接结果作为当前输出记录返回。

当一个右表记录和当前左块匹配完成后，执行器继续读取下一条右表记录。如果右表扫完了，就加载下一块左表记录，并重新从头扫描右表。所有左表块都处理完后，执行器结束。这个流程就是典型的块嵌套循环连接。相比原来的逐条左表记录扫描右表，BNLJ 会把右表扫描次数从“左表记录数次”减少到“左表块数次”，在测试数据大于内存时会更适合题目要求。

连接条件没有限制为等值条件，仍然复用原来的条件判断函数，所以 `t1.id = t2.t_id`、`t1.id < t2.t_id`、`t2.t_id < 1000` 这类等值和非等值条件都能处理。输出列的组织方式也保持原来逻辑：左表字段在前，右表字段在后，右表字段的 offset 会整体加上左表记录长度。

本地新增了测试脚本 `test_scripts/11_bnlj.py`。脚本创建 `t1` 和 `t2` 两张表，插入少量数据，然后执行题面给出的两类查询：一类是等值 join 加 `order by t1.id`，另一类是非等值 join。脚本会读取数据库目录里的 `output.txt`，并保存到 `test_scripts/xiji_outputs/11_bnlj/bnlj_output.txt`，同时生成 Markdown 测试报告 `test_scripts/results/11_bnlj.md`。

运行方式如下：

```bash
cd /root/workspace/datalab/db2023/rmdb
cmake --build build --target rmdb -j4
python3 test_scripts/11_bnlj.py
```

也可以运行包含前面题目的总测试：

```bash
./test_scripts/run_all_tests.sh
```

本地验证结果中，等值连接输出了 `id=1` 和 `id=2` 对应的匹配行；非等值连接输出了满足 `t1.id < t2.t_id and t2.t_id < 1000` 的记录，并排除了 `t2.t_id = 1000` 的记录。完整输出保存在：

```text
/root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/11_bnlj/bnlj_output.txt
```

本次验证已通过编译，并运行了 `./test_scripts/run_all_tests.sh`，包含新增的 `11_bnlj.py`，全部脚本通过。