#!/usr/bin/env python3
# 题目三：BIGINT 类型测试。
# 按题面示例插入合法和非法 BIGINT，并导出 output.txt。

from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '03_bigint'
out_dir.mkdir(parents=True, exist_ok=True)
db_name = 'bigint_test_db'

# 先建一张含 bigint 和 int 的表。
# 前两条 insert 是合法大整数，应该成功写入。
# 第三条 insert 超出有符号 BIGINT 范围，应该输出 failure。
# 两次 select 用来对比非法插入前后，表中应该仍然只有两条合法数据。
sqls = [
    "create table t(bid bigint,sid int);",
    "insert into t values(372036854775807,233421);",
    "insert into t values(-922337203685477580,124332);",
    "select * from t;",
    "insert into t values(9223372036854775809,12345);",
    "select * from t;",
]

run_sql_case(db_name, sqls, [], clean=True)
text = (ROOT / db_name / 'output.txt').read_text(encoding='utf-8')
(out_dir / 'bigint_output.txt').write_text(text, encoding='utf-8')

# 两个合法 bigint 能查到，非法值触发 failure。
rows = [
    CaseResult('large positive stored', '372036854775807' in text, 'output.txt contains positive bigint'),
    CaseResult('large negative stored', '-922337203685477580' in text, 'output.txt contains negative bigint'),
    CaseResult('overflow rejected', 'failure' in text, 'output.txt contains failure'),
]
raise SystemExit(write_report('03_bigint', 'Task 3 BIGINT Xiji Example', rows, text))
