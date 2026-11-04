#!/usr/bin/env bash
# Runs cases A1, A2, A3, B1, B2, B3, C, D, E in order, as the old proof defined them (D and E are new).
# Needs: environment from 00-session.sh, $OUT, $S.   Output: $OUT/case-*.txt
set -uo pipefail
EV='eval(CapturedOutput, '"'"'The answer is polite'"'"') AS polite'
S="${S:?}"
bash $S/13-run-start.sh A1 K_PRIVATE K_PRIVATE "SELECT TraceId, 'pm-A1-' AS marker, $EV FROM proof_shared.traces"
bash $S/13-run-start.sh A2 K_PRIVATE K_PRIVATE "SELECT TraceId, 'pm-A2-' AS marker, $EV FROM proof_private.traces"
bash $S/13-run-start.sh A3 K_PRIVATE K_PRIVATE "SELECT TraceId, 'pm-A3-' AS marker, $EV FROM traces"
bash $S/13-run-start.sh B1 K_DASH K_DASH "SELECT TraceId, 'pm-B1-' AS marker, $EV FROM traces"
bash $S/13-run-start.sh B2 K_DASH K_DASH "SELECT TraceId, 'pm-B2-' AS marker, $EV FROM acme-db.traces"
bash $S/11-cases.sh B3 K_DASH K_DASH "SELECT 'pm-B3-' AS marker, count() AS traces FROM traces WHERE OccurredAt > now() - INTERVAL 1 DAY"
. $S/env.sh
chq() { curl -s -u "default:$CH_PASSWORD" --data-binary "$2" "http://127.0.0.1:$1/"; }
{ for p in 48123 48124; do echo "any-user statements mentioning pm-B or acme-db on :$p: $(chq $p "SELECT count() FROM system.query_log WHERE (query LIKE '%pm-B%' OR query LIKE '%acme-db%') AND query NOT LIKE '%system.query_log%'")"; done; } > "$OUT/case-B-anyuser-count.txt"
bash $S/14-clickhouse-names.sh
bash $S/15-private-path-cases.sh D K_SYS K_SYS
bash $S/15-private-path-cases.sh E K_ACME K_ACME
