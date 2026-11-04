#!/usr/bin/env bash
# Starts proof infra: own docker network, Postgres, two ClickHouse servers (shared + private), Redis.
# Secrets are generated into $SECRETS/env (mode 600, outside the output dir) and never printed.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SECRETS="${SECRETS:?dir for the generated env file}"
DOCKER="sudo docker"
NET=proof9253
CH_IMAGE=clickhouse/clickhouse-server:25.10.2.65
if [ ! -f "$SECRETS/env" ]; then
  umask 077
  {
    echo "PG_PASSWORD=$(openssl rand -hex 16)"
    echo "CH_PASSWORD=$(openssl rand -hex 16)"
    echo "LWQL_CLICKHOUSE_PASSWORD=$(openssl rand -hex 16)"
    echo "LWQL_POSTGRES_READER_PASSWORD=$(openssl rand -hex 16)"
    for n in NEXTAUTH_SECRET CREDENTIALS_SECRET API_TOKEN_JWT_SECRET LW_VIRTUAL_KEY_PEPPER LW_GATEWAY_INTERNAL_SECRET LW_GATEWAY_JWT_SECRET LANGY_INTERNAL_SECRET LANGWATCH_NLP_INTERNAL_SECRET; do echo "$n=$(openssl rand -hex 32)"; done
  } > "$SECRETS/env"
fi
set -a; . "$SECRETS/env"; set +a
$DOCKER network inspect $NET >/dev/null 2>&1 || $DOCKER network create $NET >/dev/null
run() { $DOCKER inspect "$1" >/dev/null 2>&1 || $DOCKER run -d --name "$@" >/dev/null; }
run proof9253-pg --network $NET --network-alias pg9253 -p 127.0.0.1:15432:5432 \
  -e POSTGRES_USER=prisma -e POSTGRES_PASSWORD="$PG_PASSWORD" -e POSTGRES_DB=proof9253 postgres:16
run proof9253-ch-shared --network $NET -p 127.0.0.1:18123:8123 \
  -e CLICKHOUSE_PASSWORD="$CH_PASSWORD" -e CLICKHOUSE_DB=proof_shared -e CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 -v "$HERE/clickhouse-default-admin.xml:/etc/clickhouse-server/users.d/zz-admin.xml:ro" -v "$HERE/clickhouse-custom-settings-prefix.xml:/etc/clickhouse-server/config.d/custom-settings-prefix.xml:ro" $CH_IMAGE
run proof9253-ch-private --network $NET -p 127.0.0.1:18124:8123 \
  -e CLICKHOUSE_PASSWORD="$CH_PASSWORD" -e CLICKHOUSE_DB=proof_private -e CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 -v "$HERE/clickhouse-default-admin.xml:/etc/clickhouse-server/users.d/zz-admin.xml:ro" -v "$HERE/clickhouse-custom-settings-prefix.xml:/etc/clickhouse-server/config.d/custom-settings-prefix.xml:ro" $CH_IMAGE
run proof9253-redis --network $NET -p 127.0.0.1:16379:6379 redis:alpine
for i in $(seq 60); do
  curl -fs http://127.0.0.1:18123/ping >/dev/null && curl -fs http://127.0.0.1:18124/ping >/dev/null && $DOCKER exec proof9253-pg pg_isready -U prisma >/dev/null && break; sleep 1
done
echo up
