# Use-proof: built-in versus user-written LangWatchQL failures, head 19d1dd6

Head: `19d1dd6e7879c83ecd16c39e8303978ee0b0732a` (`git rev-parse HEAD` matched before and after; `git status` clean; no tracked file edited, no commit, no push, no vitest, no typecheck). Each evidence file names the head on its first line.
All names are invented. Passwords, keys, the session cookie and the metrics key were generated in one private tmux shell and passed by environment only. Evidence masks `hostname`, `userId` and client address; no cookie, token, email or password is in the evidence. Raw logs are in `private/` (not for publishing). The sign-in output that held a session token was deleted.

Disclosure: I read `trace_metrics.broken.sql` from the earlier proof's `private/` folder once, before I saw the brief's "do not read" line applied to it. It is a view definition with no secret. I did not copy it: I made my own saved original, broken and restore texts from `SHOW CREATE VIEW` on this run's database.

## Stack (local, own containers, torn down)
Postgres, Redis, one ClickHouse (database `proof_shared`), api+worker in one process, started with `RELEASE_LWQL_WORKBENCH=1 RELEASE_DASHBOARDS=1 OTEL_METRICS_EXPORTER=prometheus` and a scrape key; pid 1221849. Scripts not published.
Statement S = stock `top-models/traffic`, sent unchanged, sha256 `7ad695dd...de02ce4`. Extras on S cases: `timeWindow 2026-10-01..2026-11-04`, `sources ["application"]`.
"Broken view" = `CREATE OR REPLACE VIEW proof_shared.trace_metrics` without `Source` (checked: `system.columns` count of `Source` is 0). Done once for A..F5/PV after `lwql-provision` had run (so no re-provision undid it). Restored from the saved text at the end (Source present again, checked).

## Results (`evidence/case-<id>.txt`; metrics in `evidence/metrics-before-<id>.txt` and `metrics-after-<id>.txt`)

Metric reads are before and after each case, read from the scrape (not by arithmetic). `bi` = built_in, `uw` = user_written.

| Case | Door / request | HTTP | New-logger line | Request lines (level) | Metric before -> after |
|---|---|---|---|---|---|
| E | tRPC S, good view | 200 | none | info trpc, info hono | no series (counter shows after first increment) |
| A | tRPC S, broken view | 400 `lwql_unknown_identifier` | ONE, `error`, origin built_in, errorCode `lwql_unknown_identifier`, projectId, statementHash (S) | warn trpc 400, warn hono 400 | none -> bi 1 |
| B | tRPC S + trailing space, broken view | 400 same code | none | warn trpc, warn hono | bi 1 -> bi 1, uw 1 |
| C | tRPC invented `SELECT uniqExact(TraceIdd) AS traces FROM trace_metrics` | 400 same code (meta.identifier `TraceIdd`) | none | warn trpc, warn hono | uw 1 -> uw 2 |
| D | REST `POST /api/v1/query`, S, broken view | 400 same code | none | warn hono 400 only | bi 1, uw 2 -> unchanged (not counted) |
| F1 | tRPC S + `projects ["project_invented_unreadable"]` | 404 `project_not_found` | none | warn trpc 404, warn hono 404 | bi 1, uw 2 -> unchanged |
| F2 | tRPC S + `parameters {"dashboard_context_sources":"x"}` | 400 `lwql_reserved_parameter_supplied` | none | warn trpc, warn hono | unchanged |
| F3 | tRPC `SELEC broken (` + same reserved parameter | 400 `lwql_reserved_parameter_supplied` | none | warn trpc, warn hono | unchanged |
| F4 | REST S + same reserved parameter as F2 | 400 `lwql_reserved_parameter_supplied` | none | warn hono 400 | unchanged |

A, quoted (hostname and userId masked in evidence): level `error`, name `langwatch:analytics:lwql:query-failure`, fields beyond the four: `service`, `traceId`, `spanId`, `userId`, `time`, `pid`, `hostname`, `msg` "built-in LangWatchQL statement failed".

### F5: time-window and missing-parameter refusals on a stock statement (the spec says these write the built-in line)
- F5a: S with NO `timeWindow` -> 400 `lwql_parameter_missing`; ONE `error` line, built_in, errorCode `lwql_parameter_missing`, hash of S; metric bi 1 -> 2. Matches the spec.
- F5c: stock `traffic/main` (declares the granularity name) sent without `granularitySeconds` -> 400 `lwql_parameter_missing`; ONE `error` line with its own hash (`9f4f0c55...`); bi 3 -> 4. Matches the spec.
- F5b: window with start after end -> NOT a window refusal: the request got through to the database and failed on the broken view (400 `lwql_unknown_identifier`), one `error` line, bi 2 -> 3. I did not find a malformed-window input that is refused earlier; so a "time window problem" other than the missing window was not shown.
Every stock statement declares only reserved names, so "a declared non-reserved parameter left missing" cannot be done with a stock statement; F5a and F5c are the reserved-name-missing kind.

### G: presence probe
G0 (good view, nothing broken): `dashboards.sourcePresence` -> 200 `traces: absent`, `feedback: failed`. The `feedback` probe fails by itself in this environment (its Postgres bridge host/port setting is wrong for the container network); it writes one `error` line, errorCode `614`, no statementHash, plus a `warn` from `langwatch:dashboard:source-presence`.
G1: I made the `traces` probe fail by temporarily renaming the table the view reads (`trace_analytics`), then renamed it back. Route answered 200 with `traces: "failed"` (and `feedback: "failed"`). Two `error` lines: the feedback one (`614`) and the traces one: origin built_in, errorCode `lwql_unavailable`, projectId, NO `statementHash`. Plus a `warn` from `langwatch:dashboard:source-presence` for each. Metric across G0+G1: bi 4 -> 7 (1 + 2).

### PV: parameter value on a built-in failure
S + `parameters {"zz_probe":"VALUEMARK_7f3a9c"}`, broken view: 400 `lwql_unknown_identifier`, ONE `error` built-in line with hash of S, bi 7 -> 8.

### Log greps (`evidence/log-greps.txt`)
The new logger wrote 8 lines in the whole run: A, F5a, F5b, F5c, G0 (feedback), G1 (feedback, traces), PV. Counts of matching lines on the new logger's lines, all 0: `dashboard_context_sources`, `trace_metrics.Source`, `uniqExact`, `FROM trace_metrics`, `SELEC`, `SELECT`, `TraceIdd`, `top-models`, `VALUEMARK_7f3a9c`, `zz_probe`. Control on other loggers' lines: `dashboard_context_sources` 5, `TraceIdd` 3, `SELEC` 9, `FROM trace_metrics` 7 - so the grep sees statement text where it is.
Limit: `VALUEMARK_7f3a9c` is 0 on every logger, not only the new one, so the parameter-value grep has no positive control. It shows the value is nowhere in the app log, not that the new logger would have shown it.

## Differences from expected / notes
- The error line adds `userId`, `traceId`, `spanId` beyond the four fields (same as the earlier proof; spec now allows request-context fields).
- B (trailing space) is counted `user_written` (the hash differs), writes no line.
- F4 (REST, reserved name): 400 `lwql_reserved_parameter_supplied`. The earlier proof ran no REST reserved-name case, so I cannot say whether this matches that head.
- Compared to the earlier proof: F1 and F2 now write NO built-in line and are not counted (they did at 2bb3fda). That is the change under test.
- REST failures (D) are still not counted.

## Not run
- Browser UI walk; only tRPC and REST.
- Engine failures other than unknown column / missing table / bridge refusal (no scan ceiling, timeout, unreachable database).
- A malformed time window refused before the database (see F5b); a declared non-reserved parameter missing.
- No data ingested; E returned 0 traces.
- No positive control for the parameter-value grep.

## Teardown
View restored (Source present); app stopped by its recorded pid 1221849 (`kill -0` afterwards: no such process); three containers and the network removed; ports free; private tmux session closed.
