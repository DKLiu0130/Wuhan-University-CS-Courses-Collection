# Task 2 Xiji SQL Examples Test

| Test | Result | Detail |
|---|---:|---|
| test1_create_drop_tables | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/02_query_execution/test1_create_drop_tables_output.txt |
| test2_insert_select_where | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/02_query_execution/test2_insert_select_where_output.txt |
| test3_update_select | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/02_query_execution/test3_update_select_output.txt |
| test4_delete_select | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/02_query_execution/test4_delete_select_output.txt |
| test5_join_query | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/02_query_execution/test5_join_query_output.txt |

## Output

```text
===== test1_create_drop_tables =====
| Tables |
| t1 |
| Tables |
| t1 |
| t2 |
| Tables |
| t2 |
| Tables |

===== test2_insert_select_where =====
| name | id | score |
| Data | 1 | 90.500000 |
| Data | 2 | 95.000000 |
| Calc | 2 | 92.000000 |
| Calc | 1 | 88.500000 |
| score | name | id |
| 90.500000 | Data | 1 |
| 95.000000 | Data | 2 |
| 92.000000 | Calc | 2 |
| id |
| 1 |
| 2 |
| name |
| Data |
| Calc |

===== test3_update_select =====
| name | id | score |
| Data | 1 | 90.500000 |
| Data | 2 | 95.000000 |
| Calc | 2 | 92.000000 |
| Calc | 1 | 88.500000 |
| name | id | score |
| Data | 1 | 90.500000 |
| Data | 2 | 95.000000 |
| Calc | 2 | 99.000000 |
| Calc | 1 | 99.000000 |
| name | id | score |
| test | 1 | 90.500000 |
| test | 2 | 95.000000 |
| test | 2 | 99.000000 |
| test | 1 | 99.000000 |
| name | id | score |
| test | -1 | 0.000000 |
| test | -1 | 0.000000 |
| test | -1 | 0.000000 |
| test | -1 | 0.000000 |

===== test4_delete_select =====
| name | id | score |
| Data | 1 | 90.500000 |
| name | id | score |

===== test5_join_query =====
| id | t_name | d_name | id |
| 1 | aaa | 12345 | 1 |
| 2 | baa | 12345 | 1 |
| 3 | bba | 12345 | 1 |
| 1 | aaa | 23456 | 2 |
| 2 | baa | 23456 | 2 |
| 3 | bba | 23456 | 2 |
| id | t_name | d_name |
| 1 | aaa | 12345 |
| 2 | baa | 23456 |

```
