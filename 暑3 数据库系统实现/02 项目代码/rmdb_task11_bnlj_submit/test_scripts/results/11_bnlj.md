# Task 11 Block Nested-Loop Join Test

| Test | Result | Detail |
|---|---:|---|
| equi join row 1 | PASS | id=1 should join t_id=1 |
| equi join row 2 | PASS | id=2 should join t_id=2 |
| non-equi join keeps t_id 4 | PASS | 3 < 4 and 4 < 1000 |
| non-equi excludes t_id 1000 | PASS | t2.t_id < 1000 filters it out |

## Output

```text
| id | name | t_id | value |
| 1 | a | 1 | 10 |
| 2 | b | 2 | 20 |
| id | name | t_id | value |
| 1 | a | 2 | 20 |
| 1 | a | 4 | 40 |
| 2 | b | 4 | 40 |
| 3 | c | 4 | 40 |

```
