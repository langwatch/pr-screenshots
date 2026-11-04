#!/usr/bin/env bash
# Starts proof infra: own docker network, Postgres, two ClickHouse servers (shared + private), Redis.
# Secrets come from the shell environment (00-session.sh); nothing is written to a file.
set -euo pipefail
: "${PG_PASSWORD:?}" "${CH_PASSWORD:?}"
HERE="$(cd "$(dirname "$0")" && pwd)"
DOCKER="sudo docker"
NET=proof9253c
CH_IMAGE=clickhouse/clickhouse-server:25.10.2.65
$DOCKER network inspect $NET >/dev/null 2>&1 || $DOCKER network create $NET >/dev/null
run() { $DOCKER inspect "$1" >/dev/null 2>&1 || $DOCKER run -d --name "$@" >/dev/null; }
run proof9253c-pg --network $NET --network-alias pg9253c -p 127.0.0.1:45432:5432 \
  -e POSTGRES_USER=prisma -e POSTGRES_PASSWORD="$PG_PASSWORD" -e POSTGRES_DB=proof9253 postgres:16
run proof9253c-ch-shared --network $NET -p 127.0.0.1:48123:8123 \
  -e CLICKHOUSE_PASSWORD="$CH_PASSWORD" -e CLICKHOUSE_DB=proof_shared -e CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 -v "$HERE/clickhouse-default-admin.xml:/etc/clickhouse-server/users.d/zz-admin.xml:ro" -v "$HERE/clickhouse-custom-settings-prefix.xml:/etc/clickhouse-server/config.d/custom-settings-prefix.xml:ro" $CH_IMAGE
run proof9253c-ch-private --network $NET -p 127.0.0.1:48124:8123 \
  -e CLICKHOUSE_PASSWORD="$CH_PASSWORD" -e CLICKHOUSE_DB=proof_private -e CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 -v "$HERE/clickhouse-default-admin.xml:/etc/clickhouse-server/users.d/zz-admin.xml:ro" -v "$HERE/clickhouse-custom-settings-prefix.xml:/etc/clickhouse-server/config.d/custom-settings-prefix.xml:ro" $CH_IMAGE
run proof9253c-redis --network $NET -p 127.0.0.1:46379:6379 redis:alpine
for i in $(seq 60); do
  curl -fs http://127.0.0.1:48123/ping >/dev/null && curl -fs http://127.0.0.1:48124/ping >/dev/null && $DOCKER exec proof9253c-pg pg_isready -U prisma >/dev/null && break; sleep 1
done
echo up
