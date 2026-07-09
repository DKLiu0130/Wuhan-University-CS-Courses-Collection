#!/usr/bin/env python3
# 题目六：聚合函数测试。
# 这里使用本项目实现文档里的聚合示例，因为题面没有给完整固定样例。

from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '06_aggregate'
out_dir.mkdir(parents=True, exist_ok=True)
db_name = 'aggregator_test_db'

# 先建一张简单数值表，插入三条数据。
# 后面分别测试 sum、max、min、count(*)、count(col)，以及 where 过滤后的 count。
sqls = [
    "create table aggregate (id int, val float);",
    "insert into aggregate values (1, 10.0);",
    "insert into aggregate values (3, 8.0);",
    "insert into aggregate values (5, 2.0);",
    "select sum(id) as sum_id from aggregate;",
    "select sum(val) as sum_val from aggregate;",
    "select max(id) as max_id from aggregate;",
    "select min(val) as min_val from aggregate;",
    "select count(*) as count_row from aggregate;",
    "select count(id) as count_id from aggregate;",
    "select count(id) as cnt_id from aggregate where val = 2.0;",
]

run_sql_case(db_name, sqls, [], clean=True)
text = (ROOT / db_name / 'output.txt').read_text(encoding='utf-8')
(out_dir / 'aggregate_output.txt').write_text(text, encoding='utf-8')


rows = [CaseResult('aggregate output generated', bool(text.strip()), f'saved to {out_dir / "aggregate_output.txt"}')]
raise SystemExit(write_report('06_aggregate', 'Task 6 Aggregate Examples', rows, text))
