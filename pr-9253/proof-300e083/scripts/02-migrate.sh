#!/usr/bin/env bash
# Runs `pnpm task upgrade` (Postgres + ClickHouse migrations + LangWatchQL provisioning) against the SHARED server.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
cd "${REPO:?}/apps/tasks" && pnpm --silent task upgrade
