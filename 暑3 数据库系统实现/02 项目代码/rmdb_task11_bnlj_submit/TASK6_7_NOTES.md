# 题目 6 / 题目 7 代码改动说明

本文档用于和队友说明题目 6、题目 7 的实现思路、主要改动文件和验证方式。

## 题目 6：聚合函数

### 实现目标

支持无 `GROUP BY` 的基础聚合查询：

- `COUNT(*) AS alias`
- `COUNT(col) AS alias`
- `SUM(col) AS alias`
- `MAX(col) AS alias`
- `MIN(col) AS alias`

聚合函数可以和 `WHERE` 条件一起使用，先筛选记录，再对筛选结果做聚合。

### 解析层改动

主要文件：

- `src/parser/ast.h`
- `src/parser/yacc.y`
- `src/parser/lex.l`
- `src/parser/yacc.tab.cpp`
- `src/parser/yacc.tab.h`
- `src/parser/lex.yy.cpp`

改动内容：

- 在 AST 中新增 `AggType` 枚举，用来区分 `COUNT`、`COUNT(*)`、`SUM`、`MAX`、`MIN`。
- 新增 `AggFunc` 节点，保存聚合类型、聚合列和输出别名。
- `SelectStmt` 增加 `agg_funcs` 字段，用来保存 select 里的聚合函数列表。
- 词法分析中加入 `AS`、`COUNT`、`SUM`、`MAX`、`MIN` 关键字。
- 语法分析中新增 `aggFunc` 和 `aggFuncList`，支持多个聚合函数同时查询。

示例：

```sql
select count(*) as count_row from t;
select sum(score) as total_score, max(id) as max_id from t where score > 90;
```

### 语义分析改动

主要文件：

- `src/analyze/analyze.h`
- `src/analyze/analyze.cpp`

改动内容：

- `Query` 增加 `agg_funcs` 字段，把 parser 解析出的聚合函数传给 planner。
- `select *` 的展开逻辑改成：只有普通投影列和聚合函数都为空时，才展开全部列。
- 对聚合函数中的列做语义检查：
  - 自动补全未指定表名的列，例如 `sum(id)` 补成 `sum(t.id)`。
  - 检查列是否存在。
  - 多表同名列未指定表名时抛出歧义错误。
  - `SUM` 只允许数值类型：`INT`、`FLOAT`、`BIGINT`。

### 计划层改动

主要文件：

- `src/optimizer/plan.h`
- `src/optimizer/planner.cpp`

改动内容：

- 新增 `T_Aggregate` 计划类型。
- 新增 `AggregatePlan`，保存子计划和聚合函数列表。
- 生成 select 计划时：
  - 如果是普通 select，仍然生成 `ProjectionPlan`。
  - 如果包含聚合函数，生成 `AggregatePlan`。

整体执行顺序：

```text
Scan / Join / Where
        |
   Aggregate
        |
   输出一行聚合结果
```

### 执行层改动

主要文件：

- `src/execution/executor_aggregate.h`
- `src/portal.h`
- `src/execution/execution_manager.cpp`

改动内容：

- 新增 `AggregateExecutor`。
- 执行时遍历子算子的全部结果，计算聚合值。
- `COUNT(*)` 和 `COUNT(col)` 输出 `INT`。
- `SUM(INT)` 输出 `INT`。
- `SUM(FLOAT)` 输出 `FLOAT`。
- `SUM(BIGINT)` 输出 `BIGINT`。
- `MAX/MIN` 支持 `INT`、`FLOAT`、`BIGINT`、`DATETIME`、`CHAR`。
- `portal.h` 中增加 `AggregatePlan` 到 `AggregateExecutor` 的转换。
- 输出列名使用 SQL 中的别名，例如 `count_row`、`sum_id`。

### 与前置题目的兼容

题目 6 会用到前面题目的类型系统，因此聚合执行器中也兼容了：

- `BIGINT`
- `DATETIME`
- `CHAR(n)`

其中 `DATETIME` 内部按 8 字节整数比较，输出时仍由原来的输出逻辑转成时间字符串。

### 验证情况

本地验证过：

```sql
select sum(id) as sum_id from aggregate;
select sum(val) as sum_val from aggregate;
select max(id) as max_id from aggregate;
select min(val) as min_val from aggregate;
select count(*) as count_row from aggregate;
select count(id) as count_id from aggregate;
select count(id) as cnt_id from aggregate where val = 2.0;
```

输出结果符合预期：

```text
| sum_id |
| 9 |
| sum_val |
| 20.000000 |
| max_id |
| 5 |
| min_val |
| 2.000000 |
| count_row |
| 3 |
| count_id |
| 3 |
| cnt_id |
| 1 |
```

还验证了：

- `sum(bigint)` 正常。
- `max(datetime)` 正常。
- `min(char)` 正常。
- `sum(char)` 输出 `failure`。

## 题目 7：ORDER BY 操作符

### 实现目标

支持：

- 单列排序。
- 多列排序。
- 每个排序列单独指定 `ASC` 或 `DESC`。
- 未指定方向时默认升序。
- `LIMIT n` 限制输出条数。

示例：

```sql
select company, order_number from orders order by order_number;
select company, order_number from orders order by company, order_number;
select company, order_number from orders order by company desc, order_number asc;
select company, order_number from orders order by order_number asc limit 2;
```

### 解析层改动

主要文件：

- `src/parser/ast.h`
- `src/parser/yacc.y`
- `src/parser/lex.l`
- `src/parser/yacc.tab.cpp`
- `src/parser/yacc.tab.h`
- `src/parser/lex.yy.cpp`

改动内容：

- `OrderBy` 结构从单列改为多列：
  - `std::vector<std::shared_ptr<Col>> cols`
  - `std::vector<OrderByDir> orderby_dirs`
  - `int limit`
- 词法分析新增 `LIMIT` 关键字。
- 语法分析新增：
  - `order_item`
  - `order_item_list`
  - `opt_limit`
- 支持 `ORDER BY col1 DESC, col2 ASC LIMIT 2` 这种组合。

### 计划层改动

主要文件：

- `src/optimizer/plan.h`
- `src/optimizer/planner.cpp`

改动内容：

- `SortPlan` 从保存单个排序列改为保存多个排序列。
- `SortPlan` 增加 `limit_`。
- planner 在生成排序计划时：
  - 对每个排序列做列名检查。
  - 自动补全未指定表名的列。
  - 如果多表中有同名列且未指定表名，抛出歧义错误。
  - 保存每个排序列的升序/降序方向。

整体执行顺序：

```text
Scan / Join / Where
        |
      Sort
        |
   Projection
        |
      Output
```

这样可以支持 `ORDER BY` 的列不一定出现在最终 select 列中。

### 执行层改动

主要文件：

- `src/execution/execution_sort.h`
- `src/portal.h`

改动内容：

- 重写 `SortExecutor`。
- `beginTuple()` 时把子算子的所有结果读入内存。
- 使用 `std::sort` 按多个排序键依次比较。
- 如果第一个排序键相等，就比较第二个，以此类推。
- 每个排序键按自己的方向排序：
  - `ASC`：小的在前。
  - `DESC`：大的在前。
- 排序后如果存在 `LIMIT n`，只保留前 `n` 条。
- `Next()` 返回排序后的当前记录副本。
- `portal.h` 中更新 `SortPlan` 到 `SortExecutor` 的构造参数。

### 类型比较规则

排序比较支持当前系统已有类型：

- `INT`：按整数大小比较。
- `FLOAT`：按浮点数大小比较。
- `BIGINT`：按 64 位整数大小比较。
- `DATETIME`：按内部 8 字节时间整数比较。
- `CHAR(n)`：按固定长度字符串字节序比较。

### 验证情况

题目样例已验证，输出和期待一致：

```sql
SELECT company, order_number FROM orders ORDER BY order_number;
SELECT company, order_number FROM orders ORDER BY company, order_number;
SELECT company, order_number FROM orders ORDER BY company DESC, order_number ASC;
SELECT company, order_number FROM orders ORDER BY order_number ASC LIMIT 2;
```

额外验证：

```sql
select * from t order by a asc, b desc limit 2;
select a,d from t where c > 10 order by d desc;
```

验证了：

- `WHERE` 后排序正常。
- `LIMIT` 生效。
- 多列排序正常。
- `FLOAT`、`BIGINT`、`DATETIME` 类型排序正常。

## 提交与分支

题目 6：

- GitHub 分支：`task6-aggregate`
- 本地提交：`4d8adad`
- 提交 zip：`M:\workspace\DBlab\rmdb_task6_submit.zip`

题目 7：

- GitHub 分支：`task7-orderby`
- 本地提交：`33927e0`
- 提交 zip：`M:\workspace\DBlab\rmdb_task7_submit.zip`

## 合并提醒

题目 5 的索引功能和题目 6、7 都会修改 parser、planner、portal、execution 等模块，合并时重点看这些文件：

- `src/parser/ast.h`
- `src/parser/yacc.y`
- `src/parser/lex.l`
- `src/analyze/analyze.cpp`
- `src/optimizer/plan.h`
- `src/optimizer/planner.cpp`
- `src/portal.h`
- `src/execution/*`
- `src/system/sm_manager.*`

建议用 Git 分支合并，不建议直接复制 zip 覆盖文件。
