# Task 4 DATETIME Xiji Examples

| Test | Result | Detail |
|---|---:|---|
| test1_datetime_crud | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/04_datetime/test1_datetime_crud_output.txt |
| test2_datetime_validation | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/04_datetime/test2_datetime_validation_output.txt |

## Output

```text
===== test1_datetime_crud =====
| id | time |
| 1 | 2023-05-18 09:12:19 |
| 2 | 2023-05-30 12:34:32 |
| id | time |
| 2023 | 2023-05-18 09:12:19 |

===== test2_datetime_validation =====
| time | temperature |
| 1999-07-07 12:30:00 | 36.000000 |
failure
failure
failure
failure
failure
failure
failure
| time | temperature |
| 1999-07-07 12:30:00 | 36.000000 |

```
