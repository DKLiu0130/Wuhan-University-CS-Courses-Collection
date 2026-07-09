#!/usr/bin/env python3
# 题目四：DATETIME 类型测试。
# 按题面两个测试点执行合法时间增删改查和非法时间检查，并导出 output.txt。

from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '04_datetime'
out_dir.mkdir(parents=True, exist_ok=True)

cases = {
    # 测试点 1：插入两个合法 datetime，删除其中一个，再按 datetime 条件更新另一条。
    #  datetime 存、查、删、改。
    'test1_datetime_crud': [
        "create table t(id int , time datetime);",
        "insert into t values(1, '2023-05-18 09:12:19');",
        "insert into t values(2, '2023-05-30 12:34:32');",
        "select * from t;",
        "delete from t where time = '2023-05-30 12:34:32';",
        "update t set id = 2023 where time = '2023-05-18 09:12:19';",
        "select * from t;",
    ],
    # 测试点 2：先插入一个合法时间，再连续插入多个非法时间。
    # 非法：月份越界、格式长度不对、日期为 0、年份过小、2 月 30 日、秒数越界。
    'test2_datetime_validation': [
        "create table t(time datetime, temperature float);",
        "insert into t values('1999-07-07 12:30:00' , 36.0);",
        "select * from t;",
        "insert into t values('1999-13-07 12:30:00' , 36.0);",
        "insert into t values('1999-1-07 12:30:00' , 36.0);",
        "insert into t values('1999-00-07 12:30:00' , 36.0);",
        "insert into t values('1999-07-00 12:30:00' , 36.0);",
        "insert into t values('0001-07-10 12:30:00' , 36.0);",
        "insert into t values('1999-02-30 12:30:00' , 36.0);",
        "insert into t values('1999-02-28 12:30:61' , 36.0);",
        "select * from t;",
    ],
}

rows = []
parts = []
for name, sqls in cases.items():
    db = 'datetime_test_db_' + name
    run_sql_case(db, sqls, [], clean=True)
    text = (ROOT / db / 'output.txt').read_text(encoding='utf-8')
    (out_dir / f'{name}_output.txt').write_text(text, encoding='utf-8')
    parts.append(f'===== {name} =====\n{text}')
    rows.append(CaseResult(name, bool(text.strip()), f'saved to {out_dir / (name + "_output.txt")}'))

all_text = '\n'.join(parts)
(out_dir / 'datetime_all_outputs.txt').write_text(all_text, encoding='utf-8')
raise SystemExit(write_report('04_datetime', 'Task 4 DATETIME Xiji Examples', rows, all_text))
