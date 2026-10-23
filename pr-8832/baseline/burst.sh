#!/usr/bin/env bash
# usage: burst.sh <run-label> <N>
set -u
B=http://127.0.0.1:34483
K=<seeded local dev user PAT>
RUN=$1; N=$2; OUT=/tmp/proof-8832/$RUN; mkdir -p $OUT
echo "start $(date -u +%FT%T.%3NZ)" > $OUT/summary.txt
for i in $(seq 1 $N); do
  id="burst-$RUN-$i-$RANDOM"
  ( curl -s -m 170 -o $OUT/resp-$i.json -w "%{http_code} %{time_total}s" \
      -H "Authorization: Bearer $K" -H "X-Project-Id: local-dev-project" \
      -H "Content-Type: application/json" -H "Prefer: wait=120" \
      -X POST "$B/api/langy/conversations/$id/messages" \
      -d "{\"messages\":[{\"role\":\"user\",\"content\":\"say hi\"}],\"idempotencyKey\":\"$id\",\"adoptConversationId\":true}" \
      > $OUT/status-$i.txt ) &
done
wait
echo "end $(date -u +%FT%T.%3NZ)" >> $OUT/summary.txt
for i in $(seq 1 $N); do echo "req $i: HTTP $(cat $OUT/status-$i.txt) $(head -c 220 $OUT/resp-$i.json)"; done >> $OUT/summary.txt
