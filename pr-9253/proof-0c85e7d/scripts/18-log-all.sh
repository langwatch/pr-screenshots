#!/usr/bin/env bash
# Log excerpts for A1 and B1 to B3 (as before), then the D/E search. Usage: 18-log-all.sh <applog>   Env: $OUT, $S
set -uo pipefail
LOG=$1
t() { grep -o '"trace_id":"[0-9a-f]*"' "$OUT/case-$1.txt" | head -1 | cut -d'"' -f4; }
{ for c in A1 B1 B2 B3; do echo "=== $c trace $(t $c)"; bash $S/10-log-excerpt.sh "$LOG" "$(t $c)"; done; } > "$OUT/app-log-excerpts.txt"
bash $S/16-log-search.sh "$LOG" "$(t D)" "$(t E)"
