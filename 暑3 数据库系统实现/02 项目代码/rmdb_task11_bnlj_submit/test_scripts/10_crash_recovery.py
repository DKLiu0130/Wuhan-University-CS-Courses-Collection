#!/usr/bin/env python3
# 题目十：故障恢复测试。
# 按题面示例提交一条记录、崩溃前插入未提交记录，重启后导出恢复查询 output.txt。

from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '10_crash_recovery'
out_dir.mkdir(parents=True, exist_ok=True)
db_name = 'crash_recovery_test_db'

# 第一次启动数据库，执行崩溃前的事务。
proc, fh, log1 = start_server(db_name, clean=True)
try:
    # 第一段事务插入 id=1 并 commit，所以崩溃恢复后应该保留。
    # 第二段事务插入 id=2 但没有 commit，随后 crash，所以恢复后应该撤销。
    send_sqls([
        "create table t1 (id int, num int);",
        "begin;",
        "insert into t1 values(1, 1);",
        "commit;",
        "begin;",
        "insert into t1 values(2, 2);",
        "crash",
    ])
except Exception:
    # crash连接断开
    pass
try:
    stop_server(proc, fh)
except Exception:
    pass

# 第二次启动同一个数据库，测试恢复
proc2, fh2, log2 = start_server(db_name, clean=False)
try:
    # 恢复完成后查询 t1，正确结果应该只有已提交的 id=1。
    send_sqls(["select * from t1;"])
finally:
    stop_server(proc2, fh2)

text = (ROOT / db_name / 'output.txt').read_text(encoding='utf-8')
(out_dir / 'crash_recovery_output.txt').write_text(text, encoding='utf-8')
rows = [CaseResult('recovery output generated', bool(text.strip()), f'saved to {out_dir / "crash_recovery_output.txt"}')]
raise SystemExit(write_report('10_crash_recovery', 'Task 10 Crash Recovery Xiji Example', rows, text))
