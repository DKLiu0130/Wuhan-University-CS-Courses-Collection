#!/usr/bin/env python3
# 题目八：事务控制语句测试。
# 按题面示例执行 begin、abort 和 select，并导出 output.txt。

from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '08_transaction'
out_dir.mkdir(parents=True, exist_ok=True)
db_name = 'transaction_test_db'

# 先插入事务外的 xiaohong，这条记录应该一直存在。
# begin 后插入 xiaoming，又在同一个事务里删除它。
# abort 会回滚事务内操作，最后 select 应该只看到 xiaohong。
sqls = [
    "create table student (id int, name char(8), score float);",
    "insert into student values (1, 'xiaohong', 90.0);",
    "begin;",
    "insert into student values (2, 'xiaoming', 99.0);",
    "delete from student where id = 2;",
    "abort;",
    "select * from student;",
]

run_sql_case(db_name, sqls, [], clean=True)
text = (ROOT / db_name / 'output.txt').read_text(encoding='utf-8')
(out_dir / 'transaction_output.txt').write_text(text, encoding='utf-8')
rows = [CaseResult('transaction output generated', bool(text.strip()), f'saved to {out_dir / "transaction_output.txt"}')]
raise SystemExit(write_report('08_transaction', 'Task 8 Transaction Xiji Example', rows, text))
