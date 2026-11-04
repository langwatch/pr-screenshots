#!/usr/bin/env bash
# (1) The refusal reason text per request, read from the app log line "REST request failed" (error.reasons[0].message).
# (2) The worker event-store lines that carry the route's database name (a different code path from LangWatchQL), and
# what the private server saw from that path. Usage: 19-reasons-and-writer.sh <applog>   Env: $OUT
set -uo pipefail
LOG=$1; . "$(dirname "$0")/env.sh"
t() { grep -o '"trace_id":"[0-9a-f]*"' "$OUT/case-$1.txt" | head -1 | cut -d'"' -f4; }
{
echo "=== (1) refusal reason per request: logger, msg, error.code, error.reasons[].message (stack not copied)"
for c in B1 B2 B3 D E; do
  python3 -I - "$LOG" "$c" "$(t $c)" <<'PY'
import json, sys
log, case, trace = sys.argv[1:4]
for line in open(log):
    if trace not in line: continue
    try: d = json.loads(line)
    except ValueError: continue
    e = d.get("error") or {}
    if e.get("reasons"):
        print(case, d.get("name"), "|", d.get("msg"), "| code:", e.get("code"), "| reasons:", [r.get("message") for r in e["reasons"]])
PY
done
echo
echo "=== (2) worker event-store failures in the whole log, by organization and error (counts at the time of this read)"
python3 -I - "$LOG" <<'PY'
import json, sys, re, collections
c = collections.Counter()
for line in open(sys.argv[1]):
    try: d = json.loads(line)
    except ValueError: continue
    if d.get("name") == "langwatch:trace-processing:event-store:clickhouse" and d.get("level") == "error":
        e = d.get("error") or {}
        c[(d.get("tenantId"), e.get("type"), re.sub(r"\s+", " ", e.get("message", ""))[:90])] += 1
for k, v in sorted(c.items(), key=str): print(v, k)
PY
echo
echo "=== (2b) the same path on the private server: failed statements of the server's admin user naming the route databases, since start (system.query_log)"
curl -s -u "default:$CH_PASSWORD" --data-binary "SYSTEM FLUSH LOGS" http://127.0.0.1:48124/ >/dev/null
curl -s -u "default:$CH_PASSWORD" --data-binary "SELECT user, type, exception_code, count() AS n, substring(replaceRegexpAll(any(query), '\\\\s+', ' '), 1, 120) AS sample FROM system.query_log WHERE type LIKE 'Exception%' AND (query LIKE '%AcmeDB%' OR query LIKE '%acme-db%' OR query LIKE '%system.event_log%') AND query NOT LIKE '%system.query_log%' GROUP BY user, type, exception_code FORMAT PrettyCompactMonoBlock" http://127.0.0.1:48124/
echo "LangWatchQL identity, any statement naming AcmeDB / acme-db / system.event_log, either server:"
for p in 48123 48124; do curl -s -u "default:$CH_PASSWORD" --data-binary "SELECT count() FROM system.query_log WHERE user = '$LWQL_CLICKHOUSE_USER' AND (query LIKE '%AcmeDB%' OR query LIKE '%acme-db%' OR query LIKE '%system.event_log%')" http://127.0.0.1:$p/; done
} > "$OUT/reasons-and-writer.txt" 2>&1
