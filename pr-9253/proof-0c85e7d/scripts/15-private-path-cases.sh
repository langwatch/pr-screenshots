#!/usr/bin/env bash
# Cases D and E: POST /api/v1/query as an organization whose private route path is a reserved (/system) or a
# capitalised (/AcmeDB) database. Prints the raw HTTP result, then, on EACH server, every statement the LangWatchQL
# identity ran since the request (full text) and its count, plus the count of statements by ANY user that carry
# the case marker. Usage: 15-private-path-cases.sh <caseid> <keyvar> <keyname>   Output dir: $OUT
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
B=http://127.0.0.1:45560/api/v1/query
chq() { curl -s -u "default:$CH_PASSWORD" --data-binary "$2" "http://127.0.0.1:$1/"; }
id=$1; keyvar=$2; keyname=$3
body=$(python3 -I -c 'import json,sys; print(json.dumps({"sql":"SELECT \x27pm-%s-\x27 AS marker, count() AS traces FROM traces WHERE OccurredAt > now() - INTERVAL 1 DAY" % sys.argv[1]}))' "$id")
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
  echo "rows on $2 (LangWatchQL identity): $(chq $1 "SELECT count() FROM system.query_log WHERE $W")"
  echo "rows on $2 (any user, marker pm-$id-): $(chq $1 "SELECT count() FROM system.query_log WHERE event_time >= toDateTime('$T0') - 1 AND query LIKE '%pm-$id-%' AND query NOT LIKE '%system.query_log%'")"
done
} > "$OUT/case-$id.txt" 2>&1
