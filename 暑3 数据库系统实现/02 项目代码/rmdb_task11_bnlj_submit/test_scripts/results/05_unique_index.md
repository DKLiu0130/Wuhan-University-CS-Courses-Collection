# Task 5 Unique Index Xiji Examples

| Test | Result | Detail |
|---|---:|---|
| test1_create_drop_show_index | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/05_unique_index/test1_create_drop_show_index_output.txt |
| test2_index_query | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/05_unique_index/test2_index_query_output.txt |
| test3_index_maintenance | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/05_unique_index/test3_index_maintenance_output.txt |

## Output

```text
===== test1_create_drop_show_index =====
| warehouse | unique | (id) |
| warehouse | unique | (id) |
| warehouse | unique | (id,name) |

===== test2_index_query =====
| w_id | name |
| 10 | qweruiop |
| w_id | name |
| 500 | bgtyhnmj |
| w_id | name |
| 10 | qweruiop |
| w_id | name |
| 10 | qweruiop |
| w_id | name |
| 500 | bgtyhnmj |
| w_id | name |
| 100 | qwerghjk |
| w_id | name |
| 10 | qweruiop |
| 100 | qwerghjk |

===== test3_index_maintenance =====
| w_id | name |
| 10 | qweruiop |
| w_id | name |
| w_id | name |
| 10 | qweruiop |
| w_id | name |
| 500 | lastdanc |
| 507 | asdfhjkl |

```
