# Sourced by the other scripts. Exports a stack that touches only the proof containers.
: "${SECRETS:?}"
set -a; . "$SECRETS/env"; set +a
export NODE_ENV=development
export DATABASE_URL="postgresql://prisma:${PG_PASSWORD}@127.0.0.1:15432/proof9253?schema=public"
export CLICKHOUSE_URL="http://default:${CH_PASSWORD}@127.0.0.1:18123/proof_shared"
export REDIS_URL="redis://127.0.0.1:16379"
export PORT=15560 API_PORT=15560 BASE_HOST=http://localhost:15560 NEXTAUTH_URL=http://localhost:15560
export AUTH_PROVIDER=email
export LWQL_CLICKHOUSE_USER=langwatch_lwql_proof
export LWQL_POSTGRES_HOST=pg9253
export LWQL_ACCESS_MODEL_MODE=sql
export CLICKHOUSE_CLUSTER=
export SKIP_PRIVATE_DATAPLANE_PROVISION=
export WORKER_METRICS_PORT=15999
