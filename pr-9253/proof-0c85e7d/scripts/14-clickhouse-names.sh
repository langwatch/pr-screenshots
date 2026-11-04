#!/usr/bin/env bash
# Case C: what ClickHouse itself does with a hyphenated database name, written bare into SQL versus quoted.
# Uses a throwaway database on the PRIVATE proof server, dropped at the end. Output dir: $OUT
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
q() { echo "--- $1"; curl -s -u "default:$CH_PASSWORD" --data-binary "$1" "http://127.0.0.1:48124/${2:-}" | head -c 400; echo; }
{
echo "=== case C (private proof ClickHouse, throwaway names)"
q 'CREATE DATABASE `pm-c-db`'
q 'CREATE TABLE `pm-c-db`.t (x UInt8) ENGINE = Memory'
q 'INSERT INTO `pm-c-db`.t VALUES (1)'
q 'SELECT count() FROM `pm-c-db`.t'
q 'SELECT count() FROM pm-c-db.t'
q 'SELECT count() FROM pm_c_db.t'
echo "--- as the dialled database (client option, no SQL text): ?database=pm-c-db"
curl -s -u "default:$CH_PASSWORD" --data-binary 'SELECT count() FROM t' "http://127.0.0.1:48124/?database=pm-c-db" | head -c 300; echo
echo "--- as the dialled database: ?database=acme-db (does not exist here)"
curl -s -u "default:$CH_PASSWORD" --data-binary 'SELECT 1' "http://127.0.0.1:48124/?database=acme-db" | head -c 300; echo
q 'DROP DATABASE `pm-c-db`'
} > "$OUT/case-C.txt" 2>&1
