# Use-proof: built-in versus user-written LangWatchQL failures, head 05e2c99

PR head at publish is `2243c8d1a1197ae8080ab729f819852e0efdd841`. The diff from the proof head is one commit, a unit test file and `specs/lwql/query-origin.feature`, +28 -0, no production line. This proof was not re-run at that head.

Head: `05e2c99b1083b541498fd4cb25968502992eeffc` (`git rev-parse HEAD` matched; `git status` clean; no tracked file edited, no commit, no push, no vitest, no typecheck). Each evidence file names the head on its first line.
All names are invented. Secrets were generated in one private shell and passed by environment only. Evidence masks `hostname`, `userId`, client addresses, container names, hosts, ports (also inside error messages) and drops stack traces, `time` and `pid`; request clock times show colons as dashes. Scripts and raw logs not published. The view text came from `SHOW CREATE VIEW` on this run's database.

## Stack
Local containers (Postgres, Redis, ClickHouse), api+worker in one process started with `RELEASE_LWQL_WORKBENCH=1 RELEASE_DASHBOARDS=1` and a Prometheus metrics endpoint with a scrape key. Two invented users: the first (org and team owner, org role ADMIN) made the org and project through the app; the second is the permission-limited member below.
"S" = stock `top-models/traffic`, hash `7ad695dd...de02ce4`. "Broken view" = `trace_metrics` replaced by a copy without `Source` (checked: the `Source` column count was 0). Restored from the saved text (Source present: 1) before teardown.

## The limited member (how, and which permissions)
Made through the app's own path, no database edit: the admin called `invite.createInvites` with org role `EXTERNAL` ("lite member") and team role `VIEWER`; the second user signed up, signed in, and called `invite.acceptInvite`. I read the invite code from the local database to do it (a read only).
Permissions by reading `modules/authz/contract/src/roles.ts` (lite-member list): has `analytics:view`, `traces:view` (also project, annotations, evaluations, datasets, ... views); does NOT have `cost:view`, `gatewayUsage:view` or `virtualKeys:view`. What the run showed: P1b (a trace-metrics statement with no cost field) answered 200 (so analytics and traces view held); cost fields and the gateway view were refused (below). The admin (org ADMIN) has `cost:view` and `gatewayUsage:view` (roles.ts) and its gateway probe answered `absent`, not `failed` (G1).

## Results (`evidence/case-<id>.txt`; counter reads `metrics-before-<id>.txt` / `metrics-after-<id>.txt`, read per case)
`bi` = `lwql_query_failure_total{origin="built_in"}`, `uw` = `user_written`. A counter shows only after its first increment.

| Case | Door / request | HTTP | New-logger line | Request lines | Counter before -> after |
|---|---|---|---|---|---|
| E | tRPC S, good view | 200 | none | info trpc, info hono (+ one unrelated warn) | no series -> no series |
| A | tRPC S, broken view | 400 `lwql_unknown_identifier` | ONE `error`: built_in, errorCode `lwql_unknown_identifier`, projectId, statementHash (S) | warn trpc 400, warn hono 400 | bi 1 -> 2 (the 1 is the P2 feedback probe, see below) |
| B | S + trailing space | 400 same | none | warn trpc, warn hono | uw 0 -> 1 |
| C | invented `SELECT uniqExact(TraceIdd) AS traces FROM trace_metrics` | 400 same (identifier `TraceIdd`) | none | warn trpc, warn hono | uw 1 -> 2 |
| D | REST S, broken view | 400 same | none | warn hono 400 | unchanged |
| F1 | S + unreadable `projects` id | 404 `project_not_found` | none | warn trpc, warn hono | unchanged |
| F2 | S + reserved parameter | 400 `lwql_reserved_parameter_supplied` | none | warn trpc, warn hono | unchanged |
| F3 | `SELEC broken (` + reserved parameter | 400 `lwql_reserved_parameter_supplied` | none | warn trpc, warn hono | unchanged |
| F4 | REST S + reserved parameter | 400 `lwql_reserved_parameter_supplied` | none | warn hono 400 | unchanged |
| F5a | S, no `timeWindow` | 400 `lwql_parameter_missing` | ONE `error`, hash of S | warn x2 | bi 2 -> 3 |
| F5b | window start after end | 400 `lwql_unknown_identifier` (reached the database; not a window refusal) | ONE `error`, hash of S | warn x2 | bi 3 -> 4 |
| F5c | `traffic/main`, no `granularitySeconds` | 400 `lwql_parameter_missing` | ONE `error`, its own hash | warn x2 | bi 4 -> 5 |
| PV | S + `parameters {"zz_probe":"VALUEMARK_7f3a9c"}`, broken view | 400 `lwql_unknown_identifier` | ONE `error`, hash of S | warn x2 | bi 5 -> 6 |
| G0 | `dashboards.sourcePresence`, admin, good view | 200 `feedback: failed`, rest `absent` | ONE `error` for `feedback` | info x2 | bi 6 -> 7 |
| G1 | same, `traces` probe broken | 200 `traces: failed`, `feedback: failed` | TWO `error`: `traces` and `feedback` | info x2 | bi 7 -> 9 |

A, quoted fields: level `error`, name `langwatch:analytics:lwql:query-failure`, `origin: "built_in"`, `errorCode: "lwql_unknown_identifier"`, `projectId`, `statementHash`, `service`, `traceId`, `spanId`, `userId` (masked), `msg: "built-in LangWatchQL statement failed"`.
F1, F2, F3, F4 behave as expected (no line, no count), same as at 19d1dd6. F4 REST status and code: 400 `lwql_reserved_parameter_supplied`. F5: the missing-window and missing-parameter refusals write the built-in line (as the spec says); I found no malformed window refused before the database (F5b). A declared non-reserved parameter missing cannot be done: every stock statement declares only reserved names.

### G1: the `traces` line now carries `source`
`{"level": "error", "name": "langwatch:analytics:lwql:query-failure", "origin": "built_in", "errorCode": "lwql_unavailable", "projectId": "<local id>", "source": "traces", "msg": "built-in LangWatchQL statement failed"}` and no `statementHash`. The `feedback` line: errorCode `614`, `source: "feedback"`. (I broke the `traces` probe by temporarily renaming the table behind the view, then renaming it back. The `feedback` probe fails in this setup on its own: the Postgres bridge address in my environment is wrong for the container network.)

### P1: member without `cost:view`, stock statement reading a cost column
Statement `spend/main` (reads `TotalCost`), tRPC, limited member, good view. HTTP 400. Body (first part, full text in `case-P1.txt`):
`{"error":{"message":"lwql_not_permitted","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,"path":"analytics.lwql.query","cause":null,"error":{"code":"lwql_not_permitted","kind":"lwql_not_permitted","meta":{"violations":[{"code":"GATED_COLUMN","clause":"projection","message":"The field \"TotalCost\" is not available to you. Remove it from the query.", ... "view":"<db>.trace_metrics","missingGates":["cost:view"]}]}, ... "fault":"customer","retryable":false, ...`
Lines: `warn` trpc 400 and `warn` hono 400 only; no new-logger line. Counter: no series before, no series after (unchanged). Control `P1-admin`: same statement, admin: 200, no line.

### P2: member without `gatewayUsage:view`, `dashboards.sourcePresence`
Body: `{"result":{"data":{"traces":"absent","scenarios":"absent","judges":"absent","feedback":"failed","gateway":"failed","codingAgents":"absent"}}}` (HTTP 200). Two probes failed:
- `gateway`: refused as not permitted (`lwql_not_permitted`); one `warn` from `langwatch:dashboard:source-presence` (the line is cut in `case-P2.txt` before its `source` field; it names `gateway_request_spend`); NO new-logger line for it.
- `feedback`: the environment's bridge failure; `warn` plus one new-logger `error` line, errorCode `614`, `source: "feedback"`.
Counter: no series -> bi 1. That one count is the `feedback` line. No line named source `gateway`. (The "answer kept" check: `gateway: "failed"` is still the answer.) Weakness: because `feedback` also fails, the unchanged-metric check for `gateway` alone is read from the lines (zero `source: "gateway"`), not from the counter.
Reading the code (not run): `dashboards.sourcePresence` is a declared tRPC query (`modules/dashboard/process/src/transport/dashboard.trpc.ts`, permission `analytics:view`); it runs six one-row probes in parallel. I searched the whole repository for `sourcePresence` / `getSourcePresence` and found no caller in any browser module or `apps/ui` at this head: only the contract, the process module, the README. So I cannot say where or how often the Flight Deck calls it per page load; at this head I found no caller.

### P3: same member, stock statement on `gateway_request_spend`
Statement `fd-gateway/main`, tRPC, limited member. HTTP 400, body (full in `case-P3.txt`): `message: "lwql_not_permitted"`, `code: "lwql_not_permitted"`, violations: (1) `TABLE_NOT_ALLOWED` clause `from`: "The view "gateway_request_spend" is not available to you. ..." with `availableViews` (74 views; I checked `gateway_request_spend` is not among them); (2) `GATED_COLUMN` `CostNanoUSD`, `missingGates ["cost:view"]`; (3) `GATED_COLUMN` `cost`, `missingGates ["cost:view"]`; `fault: "customer"`. Lines: `warn` trpc, `warn` hono; no new-logger line. Counter: no series before or after.

### P4: control with the permissions
Admin, S on the broken view = case A: one line, bi +1 (1 -> 2). A serves as the control. G1 (admin) shows the `traces` line carrying `source`. 

### P5: a view the catalogue lacks
Not run. It is reported only if built-in, and a stock statement cannot name such a view; I did not fake one. Whether the mark reaches the report in this running process: P1 and P3 show it: both refusals reached the workbench door's report path and wrote nothing and counted nothing, and a non-access failure (A) in the same process still does. That is the mark working for "gate lacked" (P1, P3 columns) and "hidden view" (P3). It does not show the "catalogue lacks" side.

### Comparison with the previous head
I could not compare a P1 or P3 response with the previous head's: no old checkout or app was available and I did not run one. By reading the diff `19d1dd6..05e2c99`, the mark is held in a `WeakSet` on the server and the error that is thrown is unchanged, so the response should be the same; this is reading, not seen.

### Greps (`evidence/log-greps.txt`)
The new logger wrote 9 lines (A, F5a, F5b, F5c, PV, P2 feedback, G0 feedback, G1 feedback and traces); `source` values: `feedback` 3, `traces` 1. Counts on those lines, all 0: `dashboard_context_sources`, `trace_metrics.Source`, `uniqExact`, `FROM trace_metrics`, `SELEC`, `SELECT`, `TraceIdd`, `top-models`, `VALUEMARK_7f3a9c`, `zz_probe`, `TotalCost`, `gateway_request_spend`. Control on other loggers' lines: `dashboard_context_sources` 5, `TraceIdd` 3, `SELEC` 13, `FROM trace_metrics` 6, `TotalCost` 4, `gateway_request_spend` 5. The parameter value `VALUEMARK_7f3a9c` is 0 on every logger, so that grep has no positive control.

### Scrub check
Over `evidence/*.txt` and this README, with no timestamp filter: pattern `[a-z0-9-]+:[0-9]{2,5}`: leftover matches in evidence 0 (README: 0 after the final check); pattern `port [0-9]+`: 0. Also searched for the host name, home paths, email, localhost/loopback addresses, container names, docker addresses, cookie names, key prefixes: none. One match for `@` is a package name in a log line of case E.

## Differences / not run
- The error line also carries `userId`, `traceId`, `spanId`, `service` (request context).
- P2 cannot isolate the counter for the gateway probe because `feedback` fails by itself here.
- Where the Flight Deck calls `sourcePresence`: no caller found.
- P5 not run; previous-head response comparison not run; no browser walk; engine failures other than unknown column, missing table, bridge refusal were not produced; no data ingested.

## Teardown
View restored; table renamed back; app stopped; three containers and the network removed; ports free; private shell closed.
