#!/usr/bin/env python3
# 题目十一：块嵌套循环连接 BNLJ 测试。
# 按题面示例构造两张表，测试等值连接、非等值连接，以及 order by 后的输出。

from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '11_bnlj'
out_dir.mkdir(parents=True, exist_ok=True)
db_name = 'BNLJ_test_db'

# t1 是外表，t2 是内表。
# 数据量不大，主要用于本地确认语义正确；评测会使用超过内存的大数据。
# 第一条 select 测试 t1.id = t2.t_id 的等值连接，并按 t1.id 排序。
# 第二条 select 测试非等值连接：t1.id < t2.t_id 且 t2.t_id < 1000。
sqls = [
    "create table t1 (id int, name char(8));",
    "create table t2 (t_id int, value int);",
    "insert into t1 values (1, 'a');",
    "insert into t1 values (2, 'b');",
    "insert into t1 values (3, 'c');",
    "insert into t2 values (1, 10);",
    "insert into t2 values (2, 20);",
    "insert into t2 values (4, 40);",
    "insert into t2 values (1000, 100);",
    "select * from t1, t2 where t1.id = t2.t_id order by t1.id;",
    "select * from t1, t2 where t1.id < t2.t_id and t2.t_id < 1000;",
]

run_sql_case(db_name, sqls, [], clean=True)
text = (ROOT / db_name / 'output.txt').read_text(encoding='utf-8')
(out_dir / 'bnlj_output.txt').write_text(text, encoding='utf-8')

rows = [
    CaseResult('equi join row 1', '| 1 | a | 1 | 10 |' in text, 'id=1 should join t_id=1'),
    CaseResult('equi join row 2', '| 2 | b | 2 | 20 |' in text, 'id=2 should join t_id=2'),
    CaseResult('non-equi join keeps t_id 4', '| 3 | c | 4 | 40 |' in text, '3 < 4 and 4 < 1000'),
    CaseResult('non-equi excludes t_id 1000', '| 1000 | 100 |' not in text, 't2.t_id < 1000 filters it out'),
]
raise SystemExit(write_report('11_bnlj', 'Task 11 Block Nested-Loop Join Test', rows, text))