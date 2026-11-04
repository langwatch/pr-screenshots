#!/usr/bin/env bash
# Searches the raw app log (kept in the private dir) for the D/E requests. Prints counts and the refusal lines,
# never a secret: the password is searched by value from the environment and only its match COUNT is printed.
# Usage: 16-log-search.sh <applog> <traceD> <traceE>   Output dir: $OUT
set -uo pipefail
LOG=$1; TD=$2; TE=$3
{
for pair in "D $TD" "E $TE"; do set -- $pair
  echo "=== app log lines of case $1 (trace $2), level warn/error, selected fields"
  python3 -I - "$LOG" "$2" <<'PY'
import json, sys
log, trace = sys.argv[1], sys.argv[2]
for line in open(log):
    if trace not in line: continue
    try: d = json.loads(line)
    except ValueError: continue
    e = d.get("error") or {}
    print(json.dumps({k: v for k, v in {"level": d.get("level"), "logger": d.get("name") or d.get("logger"), "msg": d.get("msg"), "organizationId": d.get("organizationId"), "statusCode": d.get("statusCode"), "error.code": e.get("code"), "error.type": e.get("type"), "error.message": e.get("message")}.items() if v is not None}))
PY
  echo "keys of every JSON line mentioning the trace (to see whether a reason field exists):"
  grep -F "$2" "$LOG" | python3 -I -c 'import json,sys
ks=set()
for l in sys.stdin:
    try: d=json.loads(l)
    except ValueError: continue
    ks.update(d.keys()); ks.update("error."+k for k in (d.get("error") or {}))
print(sorted(ks))'
done
echo "=== reason texts anywhere in the whole log"
echo "'reserved database': $(grep -cF 'reserved database' "$LOG")"
echo "'bad name shape': $(grep -cF 'bad name shape' "$LOG")"
echo "=== route URL and password anywhere in the whole log (counts; -F fixed strings)"
for needle in '127.0.0.1:48124/system' '127.0.0.1:48124/AcmeDB' '48124/system' '48124/AcmeDB' 'AcmeDB' 'acme-db' 'default:' 'http://default' '@127.0.0.1:48124'; do echo "'$needle': $(grep -cF -- "$needle" "$LOG")"; done
echo "CH_PASSWORD value: $(grep -cF -- "$CH_PASSWORD" "$LOG")"
echo "=== log lines of D and E only: any of the above"
for t in "$TD" "$TE"; do echo "trace $t: password $(grep -F "$t" "$LOG" | grep -cF -- "$CH_PASSWORD"), '48124' $(grep -F "$t" "$LOG" | grep -cF '48124'), '/system' $(grep -F "$t" "$LOG" | grep -cF '/system'), 'AcmeDB' $(grep -F "$t" "$LOG" | grep -cF 'AcmeDB'), 'default:' $(grep -F "$t" "$LOG" | grep -cF 'default:')"; done
} > "$OUT/log-search-D-E.txt" 2>&1
