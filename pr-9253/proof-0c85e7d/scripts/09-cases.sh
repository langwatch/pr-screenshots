#!/usr/bin/env bash
# Runs the cases against the running app and prints raw request/response, then both servers' system.query_log.
# Keys are shown by name only (the real values never reach the output).
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
B=http://127.0.0.1:45560/api/v1/query
WINDOW="OccurredAt > now() - INTERVAL 1 DAY"
chq() { curl -s -u "default:$CH_PASSWORD" --data-binary "$2" "http://127.0.0.1:$1/"; }
T0=$(date -u +"%Y-%m-%d %H:%M:%S")
run() { # label, keyvar, keyname, body
  echo "=== $1"
  echo "POST $B   X-Auth-Token: <$3>"
  echo "body: $4"
  curl -s -m 60 -X POST "$B" -H "X-Auth-Token: ${!2}" -H 'content-type: application/json' -d "$4" -w "\nHTTP %{http_code}\n"
  echo
}
run "case 1: private org (orgprivate / projprivate)" K_PRIVATE K_PRIVATE "{\"sql\":\"SELECT 'proof9253c-case1' AS marker, count() AS traces FROM traces WHERE $WINDOW\"}"
run "case 2: shared org (orgshared / projshared)"   K_SHARED  K_SHARED  "{\"sql\":\"SELECT 'proof9253c-case2' AS marker, count() AS traces FROM traces WHERE $WINDOW\"}"
run "case 3: private org, route missing (orgnoroute / projnoroute)" K_NOROUTE K_NOROUTE "{\"sql\":\"SELECT 'proof9253c-case3' AS marker, count() AS traces FROM traces WHERE $WINDOW\"}"
run "case 4 attempt: projprivate key naming projprivate + projshared" K_PRIVATE K_PRIVATE "{\"sql\":\"SELECT 'proof9253c-case4' AS marker, count() AS traces FROM traces WHERE $WINDOW\",\"projects\":[\"projprivate\",\"projshared\"]}"
run "case 4 attempt: projshared key naming projshared + projprivate" K_SHARED K_SHARED "{\"sql\":\"SELECT 'proof9253c-case4b' AS marker, count() AS traces FROM traces WHERE $WINDOW\",\"projects\":[\"projshared\",\"projprivate\"]}"
sleep 2
for s in "48123 SHARED" "48124 PRIVATE"; do set -- $s
  chq "$1" "SYSTEM FLUSH LOGS" >/dev/null
  echo "=== system.query_log on the $2 ClickHouse (port $1), LangWatchQL identity, since $T0 UTC"
  chq "$1" "SELECT event_time, user, type, current_database, substring(replaceRegexpAll(query, '\\\\s+', ' '), 1, 110) AS query_head FROM system.query_log WHERE event_time >= toDateTime('$T0') AND user = '$LWQL_CLICKHOUSE_USER' AND type = 'QueryFinish' AND query LIKE '%proof9253c-case%' AND query NOT LIKE '%system.query_log%' ORDER BY event_time FORMAT PrettyCompactMonoBlock"
  echo "--- marker counts on the $2 server:"
  chq "$1" "SELECT extract(query, 'proof9253c-case[0-9a-z]*') AS marker, count() AS statements FROM system.query_log WHERE event_time >= toDateTime('$T0') AND type = 'QueryFinish' AND query LIKE '%proof9253c-case%' AND query NOT LIKE '%system.query_log%' GROUP BY marker ORDER BY marker FORMAT PrettyCompactMonoBlock"
  echo
done
