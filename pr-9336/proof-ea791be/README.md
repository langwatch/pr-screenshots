# Use-proof: built-in versus user-written LangWatchQL failures, head ea791be

Head: `ea791bef5e0c6842b7c1ceba53fe5644ed07fa12` (`git rev-parse HEAD` matched; worktree clean; no git writes, no code edits, no vitest, no typecheck). Each evidence file names the head on its first line.
All labels are invented. Secrets were generated in one private shell and passed by environment only. Evidence masks `hostname`, `userId` and client addresses, drops stack traces, time and process ids, and replaces hosts, ports and container names. Scripts and raw logs not published.

## Stack and members
Local containers (Postgres, Redis, ClickHouse); api+worker in one process with the Flight Deck and workbench switches on and a metrics endpoint with a scrape key. Two invented users: the first (organisation ADMIN) made the organisation and project through the app; the second is a "lite member" made through the app's own path (`invite.createInvites` with organisation role `EXTERNAL`, team role `VIEWER`, then sign-up and `invite.acceptInvite`; no database edit, the invite code was read from the local database). By the role table (`roles.ts`) the lite member has `analytics:view` and `traces:view` and lacks `cost:view` and `gatewayUsage:view`. The run agrees: P1b (no cost field) answered 200, cost fields and the gateway view were refused. The admin holds both permissions.
"S" = stock `top-models/traffic`, hash `7ad695dd...de02ce4`. "Broken view" = `trace_metrics` replaced by a copy without `Source` (column count 0); restored before teardown (count 1).

## Fix to the last run: the `feedback` probe
Last run it failed (code 614, connection refused) because the database bridge dialled the host-mapped port of Postgres, which was not the port listening inside the container network. I started the local Postgres container listening on that same port inside the network. Result: G0 now answers every probe `absent` (`feedback: "absent"`), so the `feedback` error line is gone and the counter now isolates the other probes. Nothing in the repository changed. The long `availableViews` field is no longer cut: the P2 `warn` line is complete (74 views, then `source`).

## Results (`evidence/case-<id>.txt`; counter reads `metrics-before-<id>.txt` and `metrics-after-<id>.txt`, read per case)
`bi` = `lwql_query_failure_total{origin="built_in"}`, `uw` = `user_written`. A counter shows only after its first increment.

| Case | Request | HTTP | New-logger line | Counter before -> after |
|---|---|---|---|---|
| E | S, good view | 200 | none | none -> none |
| A | S, broken view | 400 `lwql_unknown_identifier` | ONE `error`: built_in, errorCode, projectId, statementHash (S) | bi none -> 1 |
| B | S + trailing space | 400 same | none | uw 3 -> 4 |
| C | typo `TraceIdd` | 400 same | none | uw 4 -> 5 |
| D | REST S | 400 same | none (`warn` hono only) | unchanged |
| F1 | S + unreadable project id | 404 `project_not_found` | none | unchanged |
| F2 | S + reserved parameter | 400 `lwql_reserved_parameter_supplied` | none | unchanged |
| F3 | `SELEC broken (` + reserved parameter | 400 same code | none | unchanged |
| F4 | REST S + reserved parameter | 400 same code | none | unchanged |
| F5a | S, no `timeWindow` | 400 `lwql_parameter_missing` | ONE `error`, hash of S | bi 1 -> 2 |
| F5b | window start after end | 400 `lwql_unknown_identifier` (reached the database; not a window refusal) | ONE `error`, hash of S | bi 2 -> 3 |
| F5c | `traffic/main`, no `granularitySeconds` | 400 `lwql_parameter_missing` | ONE `error`, own hash | bi 3 -> 4 |
| PV | S + `parameters {"zz_probe":"VALUEMARK_7f3a9c"}` | 400 `lwql_unknown_identifier` | ONE `error`, hash of S | bi 4 -> 5 |
| G0 | `dashboards.sourcePresence`, admin, nothing broken | 200, all six `absent` | none | unchanged |
| G1 | same, `traces` probe broken | 200, `traces: "failed"` | ONE `error`: built_in, errorCode `lwql_unavailable`, projectId, `"source": "traces"`, no statementHash | bi 5 -> 6 |

(The earlier-case counter values for B and C start at uw 3 because P4n and P5 ran first, on the good view.)

### P1: member without `cost:view`, stock statement reading a cost column
`spend/main` (reads `TotalCost`), tRPC, lite member, good view. HTTP 400. Body: `{"error":{"message":"lwql_not_permitted","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,...,"error":{"code":"lwql_not_permitted",...,"meta":{"violations":[{"code":"GATED_COLUMN","clause":"projection","message":"The field \"TotalCost\" is not available to you. Remove it from the query.",...,"missingGates":["cost:view"]}]},...,"fault":"customer",...}}}}`. Request lines: `warn` trpc and `warn` hono. New-logger line: none. Counter: no series before, none after. Control (`P1-admin`, same statement, admin): 200, no line.

### P2: member without `gatewayUsage:view`, `dashboards.sourcePresence`
Body: `{"traces":"absent","scenarios":"absent","judges":"absent","feedback":"absent","gateway":"failed","codingAgents":"absent"}` (HTTP 200). One probe failed: `gateway`. Lines: one `warn` from `langwatch:dashboard:source-presence` with error code `lwql_not_permitted` and `"source": "gateway"` (uncut, `availableViews` of 74 entries before it); NO new-logger line. Counter: no series before, none after. This time the counter alone shows "unchanged for gateway", because no other probe fails.
Reading the code (not run): the route is a declared query (`analytics:view`) that runs six one-row probes in parallel. I searched the repository for `sourcePresence` / `getSourcePresence`: only the contract, the process module and the README mention it. I found no caller in any browser module or the UI app at this head, so I cannot say where the Flight Deck calls it or how often per page load.

### P3: same member, stock statement on `gateway_request_spend`
`fd-gateway/main`, tRPC. HTTP 400. Body (full text in `case-P3.txt`): `message "lwql_not_permitted"`; three violations: `TABLE_NOT_ALLOWED` clause `from` ("The view "gateway_request_spend" is not available to you. ..."), `GATED_COLUMN` `CostNanoUSD` (`missingGates ["cost:view"]`), `GATED_COLUMN` `cost` (`missingGates ["cost:view"]`); `fault: "customer"`. Lines: `warn` trpc, `warn` hono; no new-logger line; counter none -> none.

### P4: a view no grant can show (new)
NOT RUN as asked, and cannot be on a running app without a code change. The list of views the validator uses is the catalogue's own list, read at start-up from code; the live database does not add to it. A "views entry with no catalogue table" is therefore only possible by changing code or injecting a list in a test. Nothing was faked.
What I did run, labelled as the nearest live path and not as P4: `SELECT 1 AS x FROM no_such_view_anywhere` (a view the catalogue lacks), user-written, tRPC, lite member: HTTP 400 `lwql_not_permitted` with one `TABLE_NOT_ALLOWED` violation; counter uw 2 -> 3; no line (user-written statements never write a line). So the live path shows a "catalogue lacks" refusal IS counted; it does not show the built-in line, because a built-in statement's text is fixed and cannot name such a view.

### P5: refusal cut off at the cap (new)
A built-in statement cannot be given 20 violations (its text is fixed), so the built-in line is NOT RUN for this row. What ran, user-written, lite member, tRPC: `SELECT TotalCost AS c0, ..., TotalCost AS cN-1 FROM trace_metrics LIMIT 1`, each a gated column.
- 19 columns: HTTP 400, response lists 19 violations (all `GATED_COLUMN`); counter unchanged (none -> none); no line.
- 20 columns: HTTP 400, 20 violations; counter uw 0 -> 1 (counted, reported as a failure).
- 21 columns: HTTP 400, response capped at 20 violations; counter uw 1 -> 2.
So the cap is seen live: below 20 the access refusal is not counted, at 20 or more it is. No new-logger line for these, as expected for user-written. The count-only reading is what a built-in would add a line to; that part is not seen.

### Greps (`evidence/log-greps.txt`)
The new logger wrote 6 lines in the whole run: A, F5a, F5b, F5c, PV, G1 (`traces`). Counts of matching lines on them, all 0: `dashboard_context_sources`, `trace_metrics.Source`, `uniqExact`, `FROM trace_metrics`, `SELEC`, `SELECT`, `TraceIdd`, `top-models`, `VALUEMARK_7f3a9c`, `zz_probe`, `TotalCost`, `gateway_request_spend`, `no_such_view_anywhere`. Control, other loggers' lines: `dashboard_context_sources` 5, `TraceIdd` 3, `SELEC` 15, `TotalCost` 6, `gateway_request_spend` 4, `no_such_view_anywhere` 1. The parameter value is 0 on every logger, so that one grep has no positive control.

### Scrub check
Over `evidence/*.txt`, no timestamp filter: `[a-z0-9-]+:[0-9]{2,5}` 0 matches; `port [0-9]+` 0 matches. Also searched for machine name, home and temp paths, config paths, email, loopback, container names, private addresses, cookie names, key prefixes and process ids: none.

## Differences and not run
- The error line also carries `userId`, `traceId`, `spanId`, `service`.
- P4 (built-in, view with no catalogue entry) and the built-in side of P5: not reachable on a running app without a code change; the live nearest paths above are user-written only.
- No comparison with the previous head's responses (no previous-head app was run).
- No browser walk; no engine failures other than unknown column, missing table, missing parameter; no data ingested.

## Teardown
View restored; table renamed back; app stopped by its recorded process id (`kill -0` afterwards: no such process; no pattern kill used); the three containers and the network removed; ports free; private shell closed; no sign-in output left.
