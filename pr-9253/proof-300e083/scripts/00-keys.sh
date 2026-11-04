#!/usr/bin/env bash
# Adds random legacy project keys to the generated env file (never printed).
set -euo pipefail
: "${SECRETS:?}"
for k in K_SHARED K_PRIVATE K_NOROUTE K_BADROUTE K_DOWN K_FTP; do grep -q "^$k=" "$SECRETS/env" || echo "$k=sk-lw-$(openssl rand -hex 24)" >> "$SECRETS/env"; done
