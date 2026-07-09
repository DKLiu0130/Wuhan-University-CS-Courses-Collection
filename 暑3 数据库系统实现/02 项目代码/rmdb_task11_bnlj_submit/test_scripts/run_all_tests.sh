#!/usr/bin/env bash
set -u
cd "$(dirname "$0")"
mkdir -p results
status=0
for t in 01_storage_smoke.py 02_query_execution.py 03_bigint.py 04_datetime.py 05_unique_index.py 06_aggregate.py 07_order_by_limit.py 08_transaction.py 09_concurrency.py 10_crash_recovery.py 11_bnlj.py; do
  echo "===== $t ====="
  python3 "$t" || status=1
  echo
  pkill -INT -f "build/bin/rmdb" 2>/dev/null || true
  sleep 0.2
done
exit $status
