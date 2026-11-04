#!/usr/bin/env bash
# Case 9: a statement bound to a time window on the private route, so the completeness read runs after it.
# Prints the raw HTTP result, then every statement the LangWatchQL identity ran on each server since the request
# (the main query and the completeness read, whose literal text carries no marker), full text, plus a count.
# Usage: 12-case-windowed.sh <caseid> <keyvar> <keyname>   Output dir: $OUT
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
B=http://127.0.0.1:15560/api/v1/query
chq() { curl -s -u "default:$CH_PASSWORD" --data-binary "$2" "http://127.0.0.1:$1/"; }
id=$1; keyvar=$2; keyname=$3
start=$(date -u -d '-1 day' +%Y-%m-%dT%H:%M:%S.000Z); end=$(date -u -d '+1 hour' +%Y-%m-%dT%H:%M:%S.000Z)
body=$(python3 -I -c 'import json,sys; print(json.dumps({"sql":"SELECT \x27pm-%s-\x27 AS marker, count() AS traces FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}" % sys.argv[1], "timeWindow":{"start":sys.argv[2],"end":sys.argv[3]}}))' "$id" "$start" "$end")
T0=$(date -u +"%Y-%m-%d %H:%M:%S")
{
echo "=== case $id"
echo "POST $B   X-Auth-Token: <$keyname>"
echo "body: $body"
curl -s -m 60 -X POST "$B" -H "X-Auth-Token: ${!keyvar}" -H 'content-type: application/json' -d "$body" -w "\nHTTP %{http_code}\n"
sleep 2
for s in "18123 SHARED proof_shared" "18124 PRIVATE proof_private"; do set -- $s
  chq "$1" "SYSTEM FLUSH LOGS" >/dev/null
  W="event_time >= toDateTime('$T0') - 1 AND type != 'QueryStart' AND user = '$LWQL_CLICKHOUSE_USER' AND query NOT LIKE '%system.query_log%'"
  echo "--- system.query_log on the $2 ClickHouse (database name $3), LangWatchQL identity, since $T0 UTC"
  chq "$1" "SELECT event_time, user, type, exception_code, current_database, databases, tables, replaceRegexpAll(query, '\\\\s+', ' ') AS query_text FROM system.query_log WHERE $W ORDER BY event_time FORMAT Vertical"
  echo "rows on $2: $(chq $1 "SELECT count() FROM system.query_log WHERE $W")"
done
} > "$OUT/case-$id.txt" 2>&1
