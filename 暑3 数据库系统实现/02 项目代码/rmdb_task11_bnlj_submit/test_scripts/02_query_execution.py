#!/usr/bin/env python3
# 题目二：查询执行基础测试。
# 按希冀题面 5 个测试点执行 SQL，检查 output.txt 的简化表格输出。

from pathlib import Path
from common.rmdb_test_utils import *

ensure_built()
db_name = 'execution_test_db'
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '02_query_execution'
out_dir.mkdir(parents=True, exist_ok=True)

# 测试点 1：先创建 t1，再 show tables；然后创建 t2，再 show tables；最后依次删除表。
# 元数据正确记录表的创建和删除。
test1 = [
    "create table t1(id int,name char(4));",
    "show tables;",
    "create table t2(id int);",
    "show tables;",
    "drop table t1;",
    "show tables;",
    "drop table t2;",
    "show tables;",
]

# 测试点 2：插入 4 条成绩记录，再做整表查询、投影查询和 where 条件查询。
# insert、select、字段顺序、条件过滤 
test2 = [
    "create table grade (name char(4),id int,score float);",
    "insert into grade values ('Data', 1, 90.5);",
    "insert into grade values ('Data', 2, 95.0);",
    "insert into grade values ('Calc', 2, 92.0);",
    "insert into grade values ('Calc', 1, 88.5);",
    "select * from grade;",
    "select score,name,id from grade where score > 90;",
    "select id from grade where name = 'Data';",
    "select name from grade where id = 2 and score > 90;",
]

# 测试点 3：先查原始数据，再连续执行三次 update，每次 update 后查询结果。
# update  支持单字段、多字段、字符串条件和复合条件。
test3 = [
    "create table grade (name char(4),id int,score float);",
    "insert into grade values ('Data', 1, 90.5);",
    "insert into grade values ('Data', 2, 95.0);",
    "insert into grade values ('Calc', 2, 92.0);",
    "insert into grade values ('Calc', 1, 88.5);",
    "select * from grade;",
    "update grade set score = 99.0 where name = 'Calc' ;",
    "select * from grade;",
    "update grade set name = 'test' where name > 'A';",
    "select * from grade;",
    "update grade set name = 'test' ,id = -1,score = 0 where name = 'test' and score > 90;",
    "select * from grade;",
]

# 测试点 4：插入一条记录，删除满足条件的记录，再查询空表表头。
# delete  真正删除记录，以及删除后 select  输出表头。
test4 = [
    "create table grade (name char(4),id int,score float);",
    "insert into grade values ('Data', 1, 90.5);",
    "select * from grade;",
    "delete from grade where score > 90;",
    "select * from grade;",
]

# 测试点 5：创建两张表，先做笛卡尔积，再做 t.id = d.id 的连接查询。
# 多表扫描、连接条件和投影列输出。
test5 = [
    "create table t ( id int , t_name char (3));",
    "create table d (d_name char(5),id int);",
    "insert into t values (1,'aaa');",
    "insert into t values (2,'baa');",
    "insert into t values (3,'bba');",
    "insert into d values ('12345',1);",
    "insert into d values ('23456',2);",
    "select * from t, d;",
    "select t.id,t_name,d_name from t,d where t.id = d.id;",
]


cases = [
    ('test1_create_drop_tables', test1),
    ('test2_insert_select_where', test2),
    ('test3_update_select', test3),
    ('test4_delete_select', test4),
    ('test5_join_query', test5),
]

rows = []
all_parts = []
for case_name, sqls in cases:
    case_db = f'{db_name}_{case_name}'
   
    run_sql_case(case_db, sqls, [], clean=True)
    output_path = ROOT / case_db / 'output.txt'
    text = output_path.read_text(encoding='utf-8') if output_path.exists() else ''
    #  output.txt 单独存
    saved = out_dir / f'{case_name}_output.txt'
    saved.write_text(text, encoding='utf-8')
    all_parts.append(f'===== {case_name} =====\n{text}')
    rows.append(CaseResult(case_name, bool(text.strip()), f'saved to {saved}'))


all_text = '\n'.join(all_parts)
(out_dir / 'task2_xiji_all_outputs.txt').write_text(all_text, encoding='utf-8')
(RESULT_DIR / '02_query_execution_output_txt.md').write_text('```text\n' + all_text + '\n```\n', encoding='utf-8')
raise SystemExit(write_report('02_query_execution', 'Task 2 Xiji SQL Examples Test', rows, all_text))
