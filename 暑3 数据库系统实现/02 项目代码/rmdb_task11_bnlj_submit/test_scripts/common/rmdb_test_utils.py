#!/usr/bin/env python3
import argparse
import os
import shutil
import signal
import socket
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BIN = ROOT / "build" / "bin" / "rmdb"
RESULT_DIR = ROOT / "test_scripts" / "results"
PORT = 8765

@dataclass
class CaseResult:
    name: str
    passed: bool
    detail: str


def wait_port(timeout=5.0):
    start = time.time()
    last = None
    while time.time() - start < timeout:
        try:
            s = socket.create_connection(("127.0.0.1", PORT), timeout=0.3)
            return s
        except Exception as e:
            last = e
            time.sleep(0.1)
    raise RuntimeError(f"server not ready: {last}")


def send_sqls(sqls, timeout=5.0, keep_socket=False):
    s = wait_port(timeout)
    outs = []
    for sql in sqls:
        s.sendall(sql.encode() + b"\0")
        if sql.strip().lower() == "crash":
            time.sleep(0.2)
            outs.append("<crash sent>")
            break
        if sql.strip().lower() in ("exit", "exit;"):
            break
        data = s.recv(1024 * 1024)
        outs.append(data.decode(errors="ignore").replace("\x00", ""))
        time.sleep(0.03)
    if keep_socket:
        return s, outs
    try:
        s.sendall(b"exit\0")
    except Exception:
        pass
    try:
        s.close()
    except Exception:
        pass
    return outs


def start_server(db_name, clean=True):
    if clean:
        shutil.rmtree(ROOT / db_name, ignore_errors=True)
    log = RESULT_DIR / f"{db_name}.server.log"
    fh = open(log, "w", encoding="utf-8", errors="ignore")
    proc = subprocess.Popen([str(BIN), db_name], cwd=ROOT, stdout=fh, stderr=subprocess.STDOUT, preexec_fn=os.setsid)
    time.sleep(1.0)
    return proc, fh, log


def stop_server(proc, fh=None):
    if proc.poll() is None:
        try:
            os.killpg(proc.pid, signal.SIGINT)
            proc.wait(timeout=3)
        except Exception:
            try:
                os.killpg(proc.pid, signal.SIGKILL)
            except Exception:
                pass
    if fh:
        try: fh.close()
        except Exception: pass


def run_sql_case(db_name, sqls, checks, clean=True):
    proc, fh, log = start_server(db_name, clean=clean)
    try:
        outs = send_sqls(sqls)
    finally:
        stop_server(proc, fh)
    joined = "\n".join(outs)
    results = []
    for desc, needle in checks:
        results.append(CaseResult(desc, needle in joined, f"expect contains `{needle}`"))
    return outs, results, log


def markdown_table(title, rows):
    lines = [f"# {title}", "", "| Test | Result | Detail |", "|---|---:|---|"]
    for r in rows:
        lines.append(f"| {r.name} | {'PASS' if r.passed else 'FAIL'} | {r.detail.replace('|','/')} |")
    return "\n".join(lines) + "\n"


def write_report(script_name, title, rows, extra=""):
    RESULT_DIR.mkdir(parents=True, exist_ok=True)
    path = RESULT_DIR / f"{script_name}.md"
    text = markdown_table(title, rows)
    if extra:
        text += "\n## Output\n\n```text\n" + extra[-8000:] + "\n```\n"
    path.write_text(text, encoding="utf-8")
    print(text)
    print(f"Saved: {path}")
    return 0 if all(r.passed for r in rows) else 1


def ensure_built():
    if not BIN.exists():
        raise SystemExit(f"rmdb binary not found: {BIN}. Run: cmake --build build --target rmdb -j4")

