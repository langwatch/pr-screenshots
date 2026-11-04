#!/usr/bin/env bash
# One case per call: raw HTTP status + body, then both servers' system.query_log rows for the case marker.
# Usage: 11-cases.sh <caseid> <keyvar> <keyname> <sql> [projects-json]   Output dir: $OUT
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
B=http://127.0.0.1:45560/api/v1/query
chq() { curl -s -u "default:$CH_PASSWORD" --data-binary "$2" "http://127.0.0.1:$1/"; }
id=$1; keyvar=$2; keyname=$3; sql=$4; projects=${5:-}
body=$(python3 -I -c 'import json,sys; d={"sql":sys.argv[1]}; 
if sys.argv[2]: d["projects"]=json.loads(sys.argv[2])
print(json.dumps(d))' "$sql" "$projects")
T0=$(date -u +"%Y-%m-%d %H:%M:%S")
{
echo "=== case $id"
echo "POST $B   X-Auth-Token: <$keyname>"
echo "body: $body"
curl -s -m 60 -X POST "$B" -H "X-Auth-Token: ${!keyvar}" -H 'content-type: application/json' -d "$body" -w "\nHTTP %{http_code}\n"
sleep 2
for s in "48123 SHARED proof_shared" "48124 PRIVATE proof_private"; do set -- $s
  chq "$1" "SYSTEM FLUSH LOGS" >/dev/null
  echo "--- system.query_log on the $2 ClickHouse (database name $3), statements of this case, since $T0 UTC"
  chq "$1" "SELECT event_time, user, type, exception_code, current_database, databases, tables, substring(replaceRegexpAll(query, '\\\\s+', ' '), 1, 150) AS query_head FROM system.query_log WHERE event_time >= toDateTime('$T0') - 1 AND type != 'QueryStart' AND query LIKE '%pm-$id-%' AND query NOT LIKE '%system.query_log%' ORDER BY event_time FORMAT Vertical"
  echo "rows on $2: $(chq $1 "SELECT count() FROM system.query_log WHERE event_time >= toDateTime('$T0') - 1 AND type != 'QueryStart' AND query LIKE '%pm-$id-%' AND query NOT LIKE '%system.query_log%'")"
done
} > "$OUT/case-$id.txt" 2>&1
