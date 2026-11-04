# SOURCE this once in the shell that runs the proof (a private tmux shell). It generates every random
# value and exports it into that shell's environment only. Nothing is written to any file, nothing is printed.
# Child scripts inherit the values; closing the shell discards them.
_r() { openssl rand -hex "$1"; }
export PG_PASSWORD="$(_r 16)" CH_PASSWORD="$(_r 16)" LWQL_CLICKHOUSE_PASSWORD="$(_r 16)" LWQL_POSTGRES_READER_PASSWORD="$(_r 16)"
for n in NEXTAUTH_SECRET CREDENTIALS_SECRET API_TOKEN_JWT_SECRET LW_VIRTUAL_KEY_PEPPER LW_GATEWAY_INTERNAL_SECRET LW_GATEWAY_JWT_SECRET LANGY_INTERNAL_SECRET LANGWATCH_NLP_INTERNAL_SECRET; do export "$n=$(_r 32)"; done
for k in K_SHARED K_PRIVATE K_NOROUTE K_BADROUTE K_DOWN K_FTP K_DASH K_SYS K_ACME; do export "$k=sk-lw-$(_r 24)"; done
unset -f _r
