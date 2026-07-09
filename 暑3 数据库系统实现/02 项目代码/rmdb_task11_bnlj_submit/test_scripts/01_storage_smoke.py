#!/usr/bin/env python3
# 题目一：存储管理测试。
# 这个脚本直接运行框架自带 unit_test，主要看磁盘管理、缓冲池、记录管理这些底层功能是否通过。

import subprocess
from pathlib import Path
from common.rmdb_test_utils import *

ensure_built()
out_dir = ROOT / 'test_scripts' / 'xiji_outputs' / '01_storage'
out_dir.mkdir(parents=True, exist_ok=True)

# 调用编译后的 unit_test，可理解为运行题目一的本地单元测试合集。
proc = subprocess.run(
    [str(ROOT / 'build' / 'bin' / 'unit_test')],
    cwd=ROOT,
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    timeout=60,
)

# 保存 unit_test 的完整终端输出，方便演示时直接查看。
text = proc.stdout
(out_dir / 'unit_test_output.txt').write_text(text, encoding='utf-8')

# 返回码为 0 表示所有 gtest 测试通过。
rows = [CaseResult('unit_test exits successfully', proc.returncode == 0, f'return code {proc.returncode}')]
raise SystemExit(write_report('01_storage_smoke', 'Task 1 Storage Unit Test', rows, text))
