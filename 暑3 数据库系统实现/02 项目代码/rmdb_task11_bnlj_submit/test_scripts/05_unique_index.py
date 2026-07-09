#!/usr/bin/env python3
# 题目五：唯一索引测试。
# 按题面三个测试点执行创建展示索引、索引查询、索引维护，并导出 output.txt。

from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '05_unique_index'
out_dir.mkdir(parents=True, exist_ok=True)

cases = {
    # 测试点 1：创建单列索引和联合索引，并用 show index 查看。
    # 后面再删除两个索引，最后一次 show index 应该没有输出内容。
    'test1_create_drop_show_index': [
        "create table warehouse (id int, name char(8));",
        "create index warehouse (id);",
        "show index from warehouse;",
        "create index warehouse (id,name);",
        "show index from warehouse;",
        "drop index warehouse (id);",
        "drop index warehouse (id,name);",
        "show index from warehouse;",
    ],
    # 测试点 2：在单列索引和联合索引上做等值查询、范围查询和最左前缀查询。
    # 这个测试主要看索引是否真的能查到正确记录。
    'test2_index_query': [
        "create table warehouse (w_id int, name char(8));",
        "insert into warehouse values (10 , 'qweruiop');",
        "insert into warehouse values (534, 'asdfhjkl');",
        "insert into warehouse values (100,'qwerghjk');",
        "insert into warehouse values (500,'bgtyhnmj');",
        "create index warehouse(w_id);",
        "select * from warehouse where w_id = 10;",
        "select * from warehouse where w_id < 534 and w_id > 100;",
        "drop index warehouse(w_id);",
        "create index warehouse(name);",
        "select * from warehouse where name = 'qweruiop';",
        "select * from warehouse where name > 'qwerghjk';",
        "select * from warehouse where name > 'aszdefgh' and name < 'qweraaaa';",
        "drop index warehouse(name);",
        "create index warehouse(w_id,name);",
        "select * from warehouse where w_id = 100 and name = 'qwerghjk';",
        "select * from warehouse where w_id < 600 and name > 'bztyhnmj';",
    ],
    # 测试点 3：建索引后继续插入和更新数据。
    # 这个测试主要看基表变化后，索引内容是否同步维护。
    'test3_index_maintenance': [
        "create table warehouse (w_id int, name char(8));",
        "insert into warehouse values (10 , 'qweruiop');",
        "insert into warehouse values (534, 'asdfhjkl');",
        "select * from warehouse where w_id = 10;",
        "select * from warehouse where w_id < 534 and w_id > 100;",
        "create index warehouse(w_id);",
        "insert into warehouse values (500, 'lastdanc');",
        "update warehouse set w_id = 507 where w_id = 534;",
        "select * from warehouse where w_id = 10;",
        "select * from warehouse where w_id < 534 and w_id > 100;",
    ],
}

rows = []
parts = []
for name, sqls in cases.items():
    db = 'index_test_db_' + name
    run_sql_case(db, sqls, [], clean=True)
    text = (ROOT / db / 'output.txt').read_text(encoding='utf-8')
    (out_dir / f'{name}_output.txt').write_text(text, encoding='utf-8')
    parts.append(f'===== {name} =====\n{text}')
    rows.append(CaseResult(name, bool(text.strip()), f'saved to {out_dir / (name + "_output.txt")}'))

all_text = '\n'.join(parts)
(out_dir / 'index_all_outputs.txt').write_text(all_text, encoding='utf-8')
raise SystemExit(write_report('05_unique_index', 'Task 5 Unique Index Xiji Examples', rows, all_text))
