# Task 9 Serializable / No-Wait Five Anomaly Tests

| Test | Result | Detail |
|---|---:|---|
| dirty_write | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/09_concurrency/dirty_write_client_output.txt |
| dirty_read | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/09_concurrency/dirty_read_client_output.txt |
| lost_update | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/09_concurrency/lost_update_client_output.txt |
| non_repeatable_read | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/09_concurrency/non_repeatable_read_client_output.txt |
| phantom_read | PASS | saved to /root/workspace/datalab/db2023/rmdb/test_scripts/xiji_outputs/09_concurrency/phantom_read_client_output.txt |

## Output

```text
===== dirty_write =====
abort
+------------------+------------------+------------------+
|               id |             name |            score |
+------------------+------------------+------------------+
|                2 |         xiaoming |        95.000000 |
+------------------+------------------+------------------+
Total record(s): 1

===== dirty_read =====
abort
+------------------+------------------+------------------+
|               id |             name |            score |
+------------------+------------------+------------------+
|                2 |         xiaoming |        95.000000 |
+------------------+------------------+------------------+
Total record(s): 1

===== lost_update =====
abort
+------------------+------------------+------------------+
|               id |             name |            score |
+------------------+------------------+------------------+
|                2 |         xiaoming |        95.000000 |
+------------------+------------------+------------------+
Total record(s): 1

===== non_repeatable_read =====
+------------------+------------------+------------------+
|               id |             name |            score |
+------------------+------------------+------------------+
|                2 |         xiaoming |        95.000000 |
+------------------+------------------+------------------+
Total record(s): 1
abort
+------------------+------------------+------------------+
|               id |             name |            score |
+------------------+------------------+------------------+
|                2 |         xiaoming |        95.000000 |
+------------------+------------------+------------------+
Total record(s): 1

===== phantom_read =====
+------------------+------------------+------------------+
|               id |             name |            score |
+------------------+------------------+------------------+
|                2 |         xiaoming |        95.000000 |
+------------------+------------------+------------------+
Total record(s): 1
abort
+------------------+------------------+------------------+
|               id |             name |            score |
+------------------+------------------+------------------+
|                2 |         xiaoming |        95.000000 |
+------------------+------------------+------------------+
Total record(s): 1

```
