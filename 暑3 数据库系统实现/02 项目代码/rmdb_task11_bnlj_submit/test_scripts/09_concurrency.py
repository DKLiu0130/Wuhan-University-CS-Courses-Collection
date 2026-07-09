#!/usr/bin/env python3
# 题目九：可串行化隔离级别测试。
# 分别测试脏写、脏读、丢失更新、不可重复读、幻读五类并发异常。

from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '09_concurrency'
out_dir.mkdir(parents=True, exist_ok=True)

# 并发题主要看客户端返回字符串；发生 no-wait 锁冲突时，冲突事务应该收到 abort。
def recv_text(sock):
    return sock.recv(65536).decode(errors='ignore').replace('\x00', '')

# 每个场景单独启动一个数据库，避免前一个场景的锁和数据影响后一个场景。
def run_conflict_case(case_name, setup_sqls, t1_sql, t2_sql, after_sqls=None):
    proc, fh, log = start_server('concurrency_' + case_name, clean=True)
    try:
        # 建表并插入基础数据。
        send_sqls(setup_sqls)
        # 两个长连接分别代表两个并发事务。
        s1, _ = send_sqls(["begin;"], keep_socket=True)
        s2, _ = send_sqls(["begin;"], keep_socket=True)
        # 事务 1 先执行操作并持锁。
        s1.sendall(t1_sql.encode() + b"\0")
        out1 = recv_text(s1)
        # 事务 2 再访问冲突的数据或范围，应该被 no-wait 直接 abort。
        s2.sendall(t2_sql.encode() + b"\0")
        out2 = recv_text(s2)
        # 回滚事务 1，恢复现场。
        s1.sendall(b"abort;\0")
        out3 = recv_text(s1)
        # 可选的后续查询，用来展示数据最终没有被破坏。
        out4 = ''
        for sql in after_sqls or []:
            s1.sendall(sql.encode() + b"\0")
            out4 += recv_text(s1)
        try:
            s1.sendall(b"exit\0")
            s2.sendall(b"exit\0")
        except Exception:
            pass
    finally:
        stop_server(proc, fh)
    text = out1 + out2 + out3 + out4
    (out_dir / f'{case_name}_client_output.txt').write_text(text, encoding='utf-8')
    return CaseResult(case_name, 'abort' in out2, f'saved to {out_dir / (case_name + "_client_output.txt")}'), text

base_setup = [
    "create table concurrency_test (id int, name char(8), score float);",
    "insert into concurrency_test values (1, 'xiaohong', 90.0);",
    "insert into concurrency_test values (2, 'xiaoming', 95.0);",
    "insert into concurrency_test values (3, 'zhanghua', 88.5);",
]

cases = []

# 脏写：事务 1 修改 id=2 未提交，事务 2 也修改 id=2；第二个写应该 abort。
cases.append(run_conflict_case(
    'dirty_write',
    base_setup,
    "update concurrency_test set score = 100.0 where id = 2;",
    "update concurrency_test set score = 80.0 where id = 2;",
    ["select * from concurrency_test where id = 2;"],
))

# 脏读：事务 1 修改 id=2 未提交，事务 2 读取 id=2；读到未提交数据前应被 abort。
cases.append(run_conflict_case(
    'dirty_read',
    base_setup,
    "update concurrency_test set score = 100.0 where id = 2;",
    "select * from concurrency_test where id = 2;",
    ["select * from concurrency_test where id = 2;"],
))

# 丢失更新：事务 1 更新 id=2 未提交，事务 2 也基于同一行更新；事务 2 应 abort，避免覆盖事务 1。
cases.append(run_conflict_case(
    'lost_update',
    base_setup,
    "update concurrency_test set score = 96.0 where id = 2;",
    "update concurrency_test set score = 97.0 where id = 2;",
    ["select * from concurrency_test where id = 2;"],
))

# 不可重复读：事务 1 先读 id=2 并持读锁，事务 2 尝试修改同一行；写事务应 abort。
cases.append(run_conflict_case(
    'non_repeatable_read',
    base_setup,
    "select * from concurrency_test where id = 2;",
    "update concurrency_test set score = 70.0 where id = 2;",
    ["select * from concurrency_test where id = 2;"],
))

# 幻读：事务 1 做范围查询并持范围/表级读锁，事务 2 尝试插入会进入该范围的新记录；插入应 abort。
cases.append(run_conflict_case(
    'phantom_read',
    base_setup,
    "select * from concurrency_test where score > 90;",
    "insert into concurrency_test values (4, 'newstu', 99.0);",
    ["select * from concurrency_test where score > 90;"],
))

rows = [r for r, _ in cases]
all_text = '\n'.join(f'===== {r.name} =====\n{text}' for r, text in cases)
(out_dir / 'concurrency_all_client_outputs.txt').write_text(all_text, encoding='utf-8')
raise SystemExit(write_report('09_concurrency', 'Task 9 Serializable / No-Wait Five Anomaly Tests', rows, all_text))
