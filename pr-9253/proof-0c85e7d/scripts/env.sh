# Sourced by the other scripts. The generated values must already be in the environment (see 00-session.sh).
: "${PG_PASSWORD:?run 00-session.sh in this shell first}" "${CH_PASSWORD:?}"
export NODE_ENV=development
export DATABASE_URL="postgresql://prisma:${PG_PASSWORD}@127.0.0.1:45432/proof9253?schema=public"
export CLICKHOUSE_URL="http://default:${CH_PASSWORD}@127.0.0.1:48123/proof_shared"
export REDIS_URL="redis://127.0.0.1:46379"
export PORT=45560 API_PORT=45560 BASE_HOST=http://localhost:45560 NEXTAUTH_URL=http://localhost:45560
export AUTH_PROVIDER=email
export LWQL_CLICKHOUSE_USER=langwatch_lwql_proof
export LWQL_POSTGRES_HOST=pg9253c
export LWQL_ACCESS_MODEL_MODE=sql
export CLICKHOUSE_CLUSTER=
export SKIP_PRIVATE_DATAPLANE_PROVISION=
export WORKER_METRICS_PORT=45999
