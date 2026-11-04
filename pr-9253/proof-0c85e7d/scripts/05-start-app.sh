#!/usr/bin/env bash
# Starts the api + worker (one process, tools/dev-runtime) on :45560 against the proof containers only.
# The one private route: organization "orgprivate" -> the private ClickHouse. "orgnoroute" has none.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; . "$HERE/env.sh"
export "CLICKHOUSE_URL__proof__orgprivate=http://default:${CH_PASSWORD}@127.0.0.1:48124/proof_private"
# malformed value (not a URL) and an unreachable server (nothing listens on 48199)
export "CLICKHOUSE_URL__badlabel__orgbadroute=this is not a url"
export "CLICKHOUSE_URL__downlabel__orgdown=http://default:${CH_PASSWORD}@127.0.0.1:48199/proof_down"
# a valid server and credentials, but the path names a database with a hyphen
export "CLICKHOUSE_URL__dashlabel__orgdash=http://default:${CH_PASSWORD}@127.0.0.1:48124/acme-db"
# a valid server and credentials, but the path names a reserved database, and a capitalised one
export "CLICKHOUSE_URL__syslabel__orgsys=http://default:${CH_PASSWORD}@127.0.0.1:48124/system"
export "CLICKHOUSE_URL__acmelabel__orgacme=http://default:${CH_PASSWORD}@127.0.0.1:48124/AcmeDB"
# Instant evals: the release flag on, and the in-memory stand-in judge (refused in production, allowed here)
export RELEASE_INSTANT_EVALS=1 INSTANT_EVAL_CLASSIFIER=memory
# parses as a URL but is not http(s); invented credentials
export "CLICKHOUSE_URL__ftplabel__orgftp=ftp://invented_user:invented_pass@ch.invalid:9000/proof_ftp"
cd "${REPO:?}/tools/dev-runtime"
echo $$ > "${PIDFILE:?}"   # the recorded pid, for the down script
exec node --experimental-transform-types --disable-warning=ExperimentalWarning src/app.entrypoint.ts
