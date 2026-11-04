#!/usr/bin/env bash
# Sends one OTLP/JSON trace per seeded project through the app, so each lands on the server its organization routes to.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
BASE=http://127.0.0.1:15560
now=$(date +%s%N); end=$((now+1000000000))
send() { # key, traceId(32 hex), spanId(16 hex), name
  curl -s -m 30 -X POST "$BASE/api/otel/v1/traces" -H "X-Auth-Token: $1" -H 'content-type: application/json' -w " HTTP %{http_code}\n" -d "{\"resourceSpans\":[{\"resource\":{\"attributes\":[{\"key\":\"service.name\",\"value\":{\"stringValue\":\"proof9253\"}}]},\"scopeSpans\":[{\"scope\":{\"name\":\"proof\"},\"spans\":[{\"traceId\":\"$2\",\"spanId\":\"$3\",\"name\":\"$4\",\"kind\":1,\"startTimeUnixNano\":\"$now\",\"endTimeUnixNano\":\"$end\",\"status\":{\"code\":1}}]}]}]}"
}
send $K_SHARED  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1 aaaaaaaaaaaaaaa1 proof9253-shared-trace
send $K_PRIVATE bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb2 bbbbbbbbbbbbbbb2 proof9253-private-trace
