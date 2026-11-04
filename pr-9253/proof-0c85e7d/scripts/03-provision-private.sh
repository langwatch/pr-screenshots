#!/usr/bin/env bash
# Stands in for "part B" (provisioning on a private server, out of scope of the PR): applies the ClickHouse
# migrations and LangWatchQL objects to the PRIVATE server with the repo's own tasks, run as the server's admin.
# A scratch Postgres database absorbs the upgrade ledger so the real one still lets the migrations run here.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
cd "${REPO:?}/apps/tasks"
sudo docker exec proof9253c-pg psql -U prisma -d postgres -c "DROP DATABASE IF EXISTS proof9253c_scratch WITH (FORCE)" -c "CREATE DATABASE proof9253c_scratch" >/dev/null
export CLICKHOUSE_URL="http://default:${CH_PASSWORD}@127.0.0.1:48124/proof_private"
REAL_DB="$DATABASE_URL"
DATABASE_URL="${REAL_DB/\/proof9253?/\/proof9253c_scratch?}" pnpm --silent task upgrade
DATABASE_URL="$REAL_DB" pnpm --silent task lwql-provision
