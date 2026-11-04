# Use-proof: private route database names, at head 0c85e7d (PR 9253)

Head proven: `0c85e7daff8a7ae6937fc77313efb0890958506f` (checked with `git rev-parse HEAD` before the run; no source edited, nothing committed or pushed). Everything ran locally in own containers. All organization names, labels and databases are invented. Passwords and keys were generated in one private shell session and passed to children by environment only: no script writes them to a file, and none is printed here.

## Stack
Same layout as the earlier proof (folder `proof-2b6639a`), scripts copied and changed:
- Postgres, Redis, two ClickHouse servers: "shared" (`proof_shared`, port 48123) and "private" (`proof_private`, port 48124). Api and worker in one process on port 45560. Ports and container names differ from the earlier run; all ports were checked free first.
- One app start served every case. Instant Evals on from the start (`RELEASE_INSTANT_EVALS=1`, `INSTANT_EVAL_CLASSIFIER=memory`, the repo's own stand-in judge).
- Private routes (label, then URL; credentials of the local private server):
  - `orgprivate`: path `/proof_private` (the working route)
  - `orgdash`: path `/acme-db` (case B)
  - `orgsys`: path `/system` (case D, new)
  - `orgacme`: path `/AcmeDB` (case E, new)
- Counting method for every case: after the request, `SYSTEM FLUSH LOGS`, then read `system.query_log` on each server for every statement by the LangWatchQL identity (`langwatch_lwql_proof`) since the request, with its count. D and E also count statements of any user that carry the case marker.
- Final head: tests and spec were changed after this head; no source line. The PR body names the diff.
- Scripts: `scripts/`. `00-session.sh` generates the values; `17-run-cases.sh` runs the cases; `99-down.sh` stops everything. Nothing secret is on disk in this folder.
- The raw app log and step outputs are not published.

## Results

| Case | What was run | Result |
|------|--------------|--------|
| A1 | Run start (`POST /api/v1/instant-evals`), private org, `FROM proof_shared.traces` | HTTP 422, `instant_eval_query_invalid`, violation `TABLE_NOT_ALLOWED`. Statements by the LangWatchQL identity: shared 0, private 0 |
| A2 | Same, `FROM proof_private.traces` | HTTP 202, run `queued`. Shared 0; private 3 (see note) |
| A3 | Same, `FROM traces` | HTTP 202, `queued`. Shared 0; private 3 |
| B1 | Run start, org routed to `/acme-db`, `FROM traces` | HTTP 503, shared 0, private 0 |
| B2 | Same, `FROM acme-db.traces` | HTTP 503, shared 0, private 0 |
| B3 | `POST /api/v1/query` as the same org | HTTP 503, shared 0, private 0 |
| C | ClickHouse and a hyphenated database name | as before, see below |
| D | `POST /api/v1/query`, org routed to `/system` | HTTP 503, shared 0, private 0 |
| E | `POST /api/v1/query`, org routed to `/AcmeDB` | HTTP 503, shared 0, private 0 |

Same statements as the earlier proof for A1 to A3 and B1 to B3 (the SQL text is in each `evidence/case-*.txt`). Counting is the same script as before for each: A1 to A3, B1, B2 count every statement by the LangWatchQL identity since the request; B3 counts statements carrying its marker `pm-B3-`, any user (as in the earlier proof). D and E use the identity count and the marker count both.

### A (run start on a private route)
- A1: refused with HTTP 422 and the code `instant_eval_query_invalid`; `availableViews` lists only `proof_private.*` names. 0 statements on either server. `analytics.traces` itself was not run; the refusal shown is for this stack's shared name.
- A2 and A3: HTTP 202. The private server shows 3 statements by the LangWatchQL identity (two `LIMIT 0` probes and a `count()`), all with `current_database: proof_private`; none on the shared server. The earlier proof showed 7 for A2 and A3. This run read the log 3 seconds after the request; the queued run may not have gone further by then. I did not check which is why. The shared-server count is 0 in both runs.

### B (route path `/acme-db`), what comes back as read
- Wire: HTTP 503, body `{"type":"internal_error","code":"internal_error","message":"An unknown error occurred","retryable":false,"trace_id":...}`. The code `lwql_unavailable` is not in the body.
- App log (`evidence/app-log-excerpts.txt`): for each of B1, B2, B3 the lines `REST request failed` (logger `langwatch:api:rest`) and `error handling request` (logger `langwatch:api:hono`) carry `error.code: lwql_unavailable`, `LangWatchQLUnavailableError`, message `LangWatchQL is not available for this organization's ClickHouse.`, status 503.
- Against the code: this differs from what the code means to do. The status agrees (503), but the validate catch passes this code through by `ROUTE_REFUSAL_CODES` so a caller can see it, and the body shows the generic internal error instead. Same masking as the earlier proof. Follow-up: https://github.com/langwatch/tasks/issues/1098
- Statements: 0 and 0 by the LangWatchQL identity. By any user, no statement on either server mentions `pm-B` or `acme-db` (`evidence/case-B-anyuser-count.txt`: 0 and 0).
- A warn line `legacy project key outside its scopes` appears for these requests. Expected for a proof key: `legacy_project_key_scope_enforced` is off by default, these routes name no scope flag, the line shows `routeScopes: []`, `enforced: false`, and logs once per project, route, permission and kind per 60 s (`LEGACY_PROJECT_KEY_LOG_WINDOW_MS`). From reading, not changed by this PR.

### C (ClickHouse and a hyphenated name, `evidence/case-C.txt`, throwaway database, dropped)
- Quoted in SQL (`` `pm-c-db`.t ``): works, returns 1.
- Bare in SQL (`FROM pm-c-db.t`): `Code: 62 ... Syntax error: failed at position 23 (-)`.
- Dialled as the connection's database (`?database=pm-c-db`): works, returns 1. A missing one (`?database=acme-db`): `UNKNOWN_DATABASE`.

### D (route `/system`) and E (route `/AcmeDB`)
- D: HTTP 503, body `{"type":"internal_error","code":"internal_error","message":"An unknown error occurred","retryable":false,"trace_id":"8fc54f32a0fe350c50085efef31b6c07",...}`. Log: `lwql_unavailable`, status 503. Statements by the LangWatchQL identity: shared 0, private 0. By any user with marker `pm-D-`: 0 and 0.
- E: HTTP 503, same body shape (trace id `77dd5778cc29b82ca391cc307ebd4c22`). Log: `lwql_unavailable`, status 503. Statements by the LangWatchQL identity: shared 0, private 0. By any user with marker `pm-E-`: 0 and 0.
- Reason text, shown in the log. Not in the `error.message` field but in `error.reasons[0].message` of the line `REST request failed` (logger `langwatch:api:rest`; read with `scripts/19-reasons-and-writer.sh`, output `evidence/reasons-and-writer.txt`):
  - D: `reasons: ['reserved database']`
  - E: `reasons: ['bad name shape']` (`AcmeDB` fails the lower-case rule)
  - B1, B2, B3: `reasons: ['bad name shape']` (the hyphen)
  - Whole log: `reserved database` appears on 1 line, `bad name shape` on 4 lines (B1, B2, B3, E).
  - The first script (`16-log-search.sh`) printed only `error.message`, so its per-request section does not show the reason; the reason lines are in `evidence/reasons-and-writer.txt`.
- Search of the whole raw app log (`evidence/log-search-D-E.txt`, fixed-string `grep -c`, run after the cases and re-run later; counts below are from the later run):
  - `127.0.0.1:48124/system`, `127.0.0.1:48124/AcmeDB`, `48124/system`, `48124/AcmeDB`, `@127.0.0.1:48124`, `default:`, `http://default`: 0 each.
  - The generated password (searched by its value from the environment, only the count printed): 0.
  - On the log lines carrying the D and E trace ids: the password, `48124`, `/system`, `AcmeDB`, `default:`: 0 each.
- Found, not covered by the above: the database part of the route URL does appear in the app log, from the worker, not from the D or E requests. The worker's event store (logger `langwatch:trace-processing:event-store:clickhouse`, line `Failed: EventingClickHouseEventStore.storeEvents`, retried) dials each route as written. Whole-log counts: `AcmeDB` on 56 lines (message `Database AcmeDB does not exist.`, organization `orgacme`) and `acme-db` on 56 lines (organization `orgdash`). For `orgsys` the same path reports `Table system.event_log does not exist`, and the private server's `system.query_log` shows 74 failed statements (code 60) by its admin user with `current_database: system`, plus 21 in `proof_private` (`evidence/writer-path-private-server.txt`). These are not LangWatchQL statements (the LangWatchQL identity count stays 0, and 0 statements by that identity name `AcmeDB`, `acme-db` or `system.event_log` on either server). They show that outside the query path the route path is not refused. That those 74 statements are the worker's is inferred: their text was not read. This is outside what the earlier cases covered, and I did not look further. The password and host:port never appear.
- One of my reads came back empty and cannot tell us anything: `evidence/reasons-and-writer.txt` section 2b searched `system.query_log` for statements whose text names `AcmeDB`, `acme-db` or `system.event_log`; the worker's statements carry the database as a connection option, not in the text, so the search could not match them. The count of failed statements in `evidence/writer-path-private-server.txt` is the read that works.

## Not run
- Earlier cases 1a to 9 (unqualified and qualified reads on both servers, the other-database refusals 3a/3b, 4a/4b, 5a, windowed 9): not re-run. They stand at head `2b6639af1cd`, in `proof-2b6639a`. The changed code at this head is in the route refusal (`privateConnectionOf`); the shared-server reads are not touched by the diff, but I did not re-prove that.
- Organization-scoped or personal keys, and the member (browser) path.
- Cases 3 to 8 of the first proof (malformed route, ftp route, unreachable server, two-organization sets): not re-run.
- What a queued run does after it is accepted (judging, results): not read.
- Percent-encoded and trailing-slash route paths against a live stack: unit tests only.
- No vitest, no typecheck.

## Teardown
`scripts/99-down.sh` was run. The app was stopped by its recorded pid, the four containers and the network were removed, and the private shell session (which held the generated values) was closed. Ports 45432, 46379, 48123, 48124, 45560, 45999 were checked free afterwards.
