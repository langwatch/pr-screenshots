#!/usr/bin/env bash
# Stops what the proof started: the app (by its recorded pid) and the four containers plus the network.
set -uo pipefail
SECRETS="${SECRETS:?}"
[ -f "$SECRETS/app.pid" ] && kill "$(cat "$SECRETS/app.pid")" 2>/dev/null
sleep 5
sudo docker rm -f proof9253-ch-shared proof9253-ch-private proof9253-pg proof9253-redis
sudo docker network rm proof9253
