#!/usr/bin/env bash
# Starts the api + worker (one process, tools/dev-runtime) on :15560 against the proof containers only.
# The one private route: organization "orgprivate" -> the private ClickHouse. "orgnoroute" has none.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
export "CLICKHOUSE_URL__proof__orgprivate=http://default:${CH_PASSWORD}@127.0.0.1:18124/proof_private"
# malformed value (not a URL) and an unreachable server (nothing listens on 18199)
export "CLICKHOUSE_URL__badlabel__orgbadroute=this is not a url"
export "CLICKHOUSE_URL__downlabel__orgdown=http://default:${CH_PASSWORD}@127.0.0.1:18199/proof_down"
# parses as a URL but is not http(s); invented credentials
export "CLICKHOUSE_URL__ftplabel__orgftp=ftp://invented_user:invented_pass@ch.invalid:9000/proof_ftp"
cd "${REPO:?}/tools/dev-runtime"
exec node --experimental-transform-types --disable-warning=ExperimentalWarning src/app.entrypoint.ts
