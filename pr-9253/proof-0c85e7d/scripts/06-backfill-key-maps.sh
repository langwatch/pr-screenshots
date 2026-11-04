#!/usr/bin/env bash
# Re-runs the repo's lwql-provision task on each server so the seeded projects' keys land in its lwql_api_key_tenant_map.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
cd "${REPO:?}/apps/tasks"
pnpm --silent task lwql-provision
CLICKHOUSE_URL="http://default:${CH_PASSWORD}@127.0.0.1:48124/proof_private" pnpm --silent task lwql-provision
