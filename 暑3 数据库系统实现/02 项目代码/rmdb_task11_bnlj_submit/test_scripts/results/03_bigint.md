# Task 3 BIGINT Xiji Example

| Test | Result | Detail |
|---|---:|---|
| large positive stored | PASS | output.txt contains positive bigint |
| large negative stored | PASS | output.txt contains negative bigint |
| overflow rejected | PASS | output.txt contains failure |

## Output

```text
| bid | sid |
| 372036854775807 | 233421 |
| -922337203685477580 | 124332 |
failure
| bid | sid |
| 372036854775807 | 233421 |
| -922337203685477580 | 124332 |

```
