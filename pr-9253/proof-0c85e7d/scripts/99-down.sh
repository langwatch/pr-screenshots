#!/usr/bin/env bash
# Stops what the proof started: the app (by its recorded pid only) and the containers plus the network.
set -uo pipefail
PIDFILE="${PIDFILE:?}"
[ -f "$PIDFILE" ] && kill "$(cat "$PIDFILE")" 2>/dev/null
sleep 5
sudo docker rm -f proof9253c-ch-shared proof9253c-ch-private proof9253c-pg proof9253c-redis
sudo docker network rm proof9253c
