#!/usr/bin/env bash
# Run-start cases: POST /api/v1/instant-evals with a statement. Prints the raw HTTP result, then every statement
# the LangWatchQL identity ran on each server since the request (full text), and a count.
# Usage: 13-run-start.sh <caseid> <keyvar> <keyname> <sql>   Output dir: $OUT
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
B=http://127.0.0.1:45560/api/v1/instant-evals
chq() { curl -s -u "default:$CH_PASSWORD" --data-binary "$2" "http://127.0.0.1:$1/"; }
id=$1; keyvar=$2; keyname=$3; sql=$4
body=$(python3 -I -c 'import json,sys; print(json.dumps({"sql":sys.argv[1]}))' "$sql")
T0=$(date -u +"%Y-%m-%d %H:%M:%S")
{
echo "=== case $id"
echo "POST $B   X-Auth-Token: <$keyname>"
echo "body: $body"
curl -s -m 60 -X POST "$B" -H "X-Auth-Token: ${!keyvar}" -H 'content-type: application/json' -d "$body" -w "\nHTTP %{http_code}\n"
sleep 3
for s in "48123 SHARED proof_shared" "48124 PRIVATE proof_private"; do set -- $s
  chq "$1" "SYSTEM FLUSH LOGS" >/dev/null
  W="event_time >= toDateTime('$T0') - 1 AND type != 'QueryStart' AND user = '$LWQL_CLICKHOUSE_USER' AND query NOT LIKE '%system.query_log%'"
  echo "--- system.query_log on the $2 ClickHouse (database name $3), LangWatchQL identity, since $T0 UTC"
  chq "$1" "SELECT event_time, user, type, exception_code, current_database, databases, tables, replaceRegexpAll(query, '\\\\s+', ' ') AS query_text FROM system.query_log WHERE $W ORDER BY event_time FORMAT Vertical"
  echo "rows on $2: $(chq $1 "SELECT count() FROM system.query_log WHERE $W")"
done
} > "$OUT/case-$id.txt" 2>&1
