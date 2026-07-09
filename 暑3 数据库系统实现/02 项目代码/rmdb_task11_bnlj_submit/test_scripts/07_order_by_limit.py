#!/usr/bin/env python3
# 题目七：ORDER BY 和 LIMIT 测试。
# 按题面示例执行多种排序和 limit 查询，并导出 output.txt。

from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '07_order_by_limit'
out_dir.mkdir(parents=True, exist_ok=True)
db_name = 'order_test_db'


# 第一条 select 按数字列升序排序。
# 第二条 select 按 company、order_number 两列升序排序。
# 第三条 select 按 company 降序，再按 order_number 升序。
# 第四条 select 按 order_number 升序排序后，只保留前两条。
sqls = [
    "create table orders (company char(10), order_number int);",
    "insert into orders values('AAA',12);",
    "insert into orders values('ABB',13);",
    "insert into orders values('ABC',19);",
    "insert into orders values('ACA',1);",
    "SELECT company, order_number FROM orders ORDER BY order_number;",
    "SELECT company, order_number FROM orders ORDER BY company, order_number;",
    "SELECT company, order_number FROM orders ORDER BY company DESC, order_number ASC;",
    "SELECT company, order_number FROM orders ORDER BY order_number ASC LIMIT 2;",
]

run_sql_case(db_name, sqls, [], clean=True)
text = (ROOT / db_name / 'output.txt').read_text(encoding='utf-8')
(out_dir / 'order_by_limit_output.txt').write_text(text, encoding='utf-8')
rows = [CaseResult('order by output generated', bool(text.strip()), f'saved to {out_dir / "order_by_limit_output.txt"}')]
raise SystemExit(write_report('07_order_by_limit', 'Task 7 ORDER BY / LIMIT Xiji Example', rows, text))
