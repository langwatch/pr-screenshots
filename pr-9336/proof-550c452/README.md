# Use-proof: built-in versus user-written LangWatchQL failures, head 550c452

Head: `550c452830dc740010a6cc81c586e45ce71ee71a` (`git rev-parse HEAD` matched; worktree clean before and after; no git writes, no code edits, no vitest, no typecheck, no lint, no formatter). Each evidence file names the head on its first line.
All labels are invented. Secrets were generated in one private shell and passed by environment only. Evidence masks `hostname`, `userId` and client addresses, drops stack traces, time and process ids, and replaces hosts, ports and container names. Scripts and raw logs not published.
Same harness, stack, invented members and case definitions as the run at `ea791be`. Changes to the harness only: the metrics read now also prints `lwql_queries_total` (main's run counter), and each case file also keeps the lines of main's run logger `langwatch:analytics:lwql`, so a double count would show.

## Stack and members
Local containers (Postgres, Redis, ClickHouse); api+worker in one process with the Flight Deck and workbench switches on and a metrics endpoint with a scrape key. Same two invented users, made the same way: an organisation ADMIN who made the organisation and project through the app, and a "lite member" (`invite.createInvites` with organisation role `EXTERNAL`, team role `VIEWER`, then sign-up and `invite.acceptInvite`; no database edit). Read back from the database: `EXTERNAL` in the organisation and `VIEWER` on the shared team. P1b answered 200 and the cost and gateway reads were refused, as before.
New at this head: the app reads a query-hash key at start (`analytics.app.ts` `queryHashKey`, first set of `API_KEY_PEPPER`, `CREDENTIALS_SECRET`, `NEXTAUTH_SECRET`). The private shell already generated `CREDENTIALS_SECRET` and `NEXTAUTH_SECRET`, so the app started with no other change. The Prisma client was generated again for the merged schema (ignored path; `git status` clean).
"S" = stock `top-models/traffic`, hash `7ad695dd...de02ce4`. "Broken view" = `trace_metrics` replaced by a copy without `Source` (column count 0); restored before teardown (count 1). The live view text at this head was the same as at `ea791be` (byte diff empty), so the same broken and restore text was used.

## Results (`evidence/case-<id>.txt`; counter reads `metrics-before-<id>.txt` and `metrics-after-<id>.txt`, read per case)
`bi` = `lwql_query_failure_total{origin="built_in"}`, `uw` = `user_written`. A counter shows only after its first increment. `run` = sum of `lwql_queries_total` over failure outcomes (main's counter).

| Case | Request | HTTP | New-logger line | Counter before -> after | Old (`ea791be`) |
|---|---|---|---|---|---|
| E | S, good view | 200 | none | none -> none | same |
| A | S, broken view, tRPC query route | 400 `lwql_unknown_identifier` | ONE `error`: built_in, errorCode, projectId, statementHash (S) | bi none -> 1; run 7 -> 8 | same |
| B | S + trailing space | 400 same | none | uw 3 -> 4 | same |
| C | typo `TraceIdd` | 400 same | none | uw 4 -> 5 | same |
| D | REST S | 400 same | none (`warn` hono only) | bi/uw unchanged; run +1 | same |
| F1 | S + unreadable project id | 404 `project_not_found` | none | bi/uw unchanged; run +1 | same |
| F2 | S + reserved parameter | 400 `lwql_reserved_parameter_supplied` | none | bi/uw unchanged; run +1 | same |
| F3 | `SELEC broken (` + reserved parameter | 400 same code | none | bi/uw unchanged; run +1 | same |
| F4 | REST S + reserved parameter | 400 same code | none | bi/uw unchanged; run +1 | same |
| **F5a** | S, no `timeWindow` | 400 `lwql_parameter_missing` (period start and end) | **none** | **bi 1 -> 1**; run +1 | ONE line, bi 1 -> 2 |
| F5b | window start after end | 400 `lwql_unknown_identifier` (reached the database) | ONE `error`, hash of S | bi 1 -> 2 | same (was bi 2 -> 3) |
| **F5c** | `traffic/main`, no `granularitySeconds` | 400 `lwql_parameter_missing` (granularity) | **none** | **bi 2 -> 2**; run +1 | ONE line, bi 3 -> 4 |
| PV | S + `parameters {"zz_probe":"VALUEMARK_7f3a9c"}` | 400 `lwql_unknown_identifier` | ONE `error`, hash of S | bi 2 -> 3 | same (was bi 4 -> 5) |
| G0 | `dashboards.sourcePresence`, admin, nothing broken | 200, all six `absent` | none | unchanged | same |
| G1 | same, `traces` probe broken | 200, `traces: "failed"` | ONE `error`: built_in, errorCode `lwql_unavailable`, projectId, `"source": "traces"`, no statementHash | bi 3 -> 4 | same (was bi 5 -> 6) |

Only F5a and F5c changed in kind. The later `bi` start values are two lower because F5a and F5c no longer count. The `uw` start for B (3) matches the old run, but the order changed: P4n ran before P5 this time (see P4 and P5).

### Case A: the workbench-door failure through `#countingFailures`
The request goes to `analytics.lwql.query`, which calls `executeWorkbenchQuery` (`analytics-lwql.trpc.ts:137`). That body runs inside `#countingFailures` (main's `runTelemetry.recordFailed`) and, inside it, `reportingFailures` (this PR's built-in line and count). The one request wrote, in `case-A.txt`:
```
{"level": "error", "hostname": "<masked>", "name": "langwatch:analytics:lwql:query-failure", "service": "langwatch-worker", "traceId": "94bcf6024476d01d0e9cb9bc1d72b0af", "spanId": "4bcac8b0de132a12", "projectId": "project_0003VIWozMYPmhgH4sSVWUcyGenEV", "userId": "<masked>", "origin": "built_in", "errorCode": "lwql_unknown_identifier", "statementHash": "7ad695ddac786f00e57055860b37d478b36dd6e274e0d0496e42af28cde02ce4", "msg": "built-in LangWatchQL statement failed"}
{"level": "info", "hostname": "<masked>", "name": "langwatch:analytics:lwql", "service": "langwatch-app", "traceId": "94bcf6024476d01d0e9cb9bc1d72b0af", "spanId": "4bcac8b0de132a12", "projectId": "project_0003VIWozMYPmhgH4sSVWUcyGenEV", "userId": "<masked>", "caller": "workbench", "queryHash": "cbeb97d9acb1be5b", "outcome": "lwql_unknown_identifier", "msg": "LangWatchQL failed"}
```
Counters: `lwql_query_failure_total{origin="built_in"}` none -> 1; `lwql_queries_total{caller="workbench",outcome="lwql_unknown_identifier"}` none -> 1.

### Double-count check
- Per case: every failing request moved main's failure sum (`run`) by exactly 1 (24 cases read; 20 failing requests or probes, 20 steps of +1; the 4 that answered, +0). `lwql_query_failure_total` moved by 0 or 1, never 2.
- Per case log slices: each failing request wrote exactly one `LangWatchQL failed` line; A, F5b, PV and G1 also wrote exactly one new-logger line; no slice had two of either.
- Whole run: 20 `LangWatchQL failed` lines, 4 new-logger lines, final `bi` 4 and `uw` 5 (4 + 5 = the 4 built-in lines plus the 5 counted user-written failures P4n, P5-20, P5-21, B, C).

### P1: member without `cost:view`, stock statement reading a cost column
`spend/main` (reads `TotalCost`), tRPC, lite member, good view. HTTP 400 `lwql_not_permitted`, one `GATED_COLUMN` violation (`TotalCost`, `missingGates ["cost:view"]`), `fault: "customer"`. No new-logger line. Counter: no series before, none after. Control (`P1-admin`, admin): 200, no line. Same as before.

### P2: member without `gatewayUsage:view`, `dashboards.sourcePresence`
Body: `{"traces":"absent","scenarios":"absent","judges":"absent","feedback":"absent","gateway":"failed","codingAgents":"absent"}` (HTTP 200). One `warn` from `langwatch:dashboard:source-presence`, error code `lwql_not_permitted`, `"source": "gateway"`; NO new-logger line; `lwql_query_failure_total` none -> none. Same as before. (Main's counter adds `source_presence` / `lwql_not_permitted` +1.)

### P3: same member, stock statement on `gateway_request_spend`
`fd-gateway/main`, tRPC. HTTP 400 `lwql_not_permitted`; three violations: `TABLE_NOT_ALLOWED` (view `gateway_request_spend`), `GATED_COLUMN` `CostNanoUSD` and `cost` (`missingGates ["cost:view"]`); `fault: "customer"`. No new-logger line; counter none -> none. Same as before.

### P4: a view no grant can show
NOT RUN, for the same reason as before: the validator's view list is the catalogue's own, read from code at start; a running app cannot be given a view with no catalogue entry without a code change.
Nearest live path, as before: `SELECT 1 AS x FROM no_such_view_anywhere`, user-written, lite member: HTTP 400 `lwql_not_permitted`, one `TABLE_NOT_ALLOWED`; uw none -> 1 (ran first this time; was 2 -> 3); no line.

### P5: refusal cut off at the cap
Built-in side NOT RUN (fixed text cannot hold 20 violations). User-written, lite member: 19 columns -> 19 violations, uw 1 -> 1 (not counted); 20 -> 20 violations, uw 1 -> 2; 21 -> capped at 20 violations, uw 2 -> 3. Same behaviour as before. A first try of these three had a wrong argument order in my driver: the request script failed before sending (no log slice written); the three were then run again, and the files here are from the second run.

### Greps (`evidence/log-greps.txt`)
The new logger wrote 4 lines in the whole run: A, F5b, PV, G1 (`traces`). Was 6: the F5a and F5c lines are gone. On these 4 lines, all 0: `dashboard_context_sources`, `trace_metrics.Source`, `uniqExact`, `FROM trace_metrics`, `SELEC`, `SELECT`, `TraceIdd`, `top-models`, `VALUEMARK_7f3a9c`, `zz_probe`, `TotalCost`, `gateway_request_spend`, `no_such_view_anywhere`. The same tokens on main's 20 `LangWatchQL failed` lines: all 0. Control, other loggers' lines: `dashboard_context_sources` 5, `TraceIdd` 3, `SELEC` 15, `FROM trace_metrics` 6, `TotalCost` 6, `gateway_request_spend` 2 (was 4), `no_such_view_anywhere` 1. The parameter value is 0 on every logger, so that one grep has no positive control.

### Scrub check
Over `evidence/*.txt` (73 files), no timestamp filter: `[a-z0-9-]+:[0-9]{2,5}` 0 matches; `port [0-9]+` 0 matches. Also searched for machine name, home and temp paths, config paths, email, loopback, container names, private addresses, cookie names, key prefixes, process ids and the invented user and organisation names: none. (A regex `.config` matched 5 view names such as `model_default_config_scopes`; the fixed-string search for `.config` found 0.)

## Differences and not run
- F5a and F5c: no new-logger line and no `lwql_query_failure_total` change (was one line and bi +1 each). Main's run counter still counts them (`lwql_parameter_missing`).
- All other rows: same HTTP code, same lines, same counter step as at `ea791be`.
- P4 (built-in, view with no catalogue entry) and the built-in side of P5: not reachable on a running app without a code change.
- No comparison against a running previous-head app; the "Old" column is the `ea791be` evidence.
- No browser walk; no data ingested.

## Teardown
View restored (`Source` column count 1); table renamed back (`trace_analytics` present 1); app stopped by its recorded process id (`kill -0` afterwards: no such process; no pattern kill used); the three containers and the network removed (0 left); the six ports free; private shell closed; the sign-in output file deleted.
