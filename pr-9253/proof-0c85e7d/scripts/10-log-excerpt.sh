#!/usr/bin/env bash
# Prints the app log lines of one request (by trace id) as name / message / error code / HTTP status.
set -euo pipefail
python3 -I - "$1" "$2" <<'PY'
import json, sys
log, trace = sys.argv[1], sys.argv[2]
for line in open(log):
    if trace not in line: continue
    try: d = json.loads(line)
    except ValueError: continue
    if d.get("level") not in ("error", "warn"): continue
    e = d.get("error") or {}
    print(json.dumps({k: v for k, v in {"level": d["level"], "logger": d.get("name"), "msg": d.get("msg"), "organizationId": d.get("organizationId"), "variable": d.get("variable"), "problem": d.get("problem"), "statusCode": d.get("statusCode"), "error.code": e.get("code"), "error.type": e.get("type"), "error.message": e.get("message")}.items() if v is not None}))
PY
