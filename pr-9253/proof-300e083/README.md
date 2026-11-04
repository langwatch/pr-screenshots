# Use-proof: LangWatchQL routed to an organization's private ClickHouse

Head proven: `300e08315cb` (worktree clean, no source changed). Everything ran locally: own containers, nothing shared touched.
Cases 1 to 8 ran on one app run; case 9 ran later on a stack rebuilt from the same scripts at the same head.
All names (organizations, labels, databases, hosts) are invented for this run.

## Stack
- Postgres, Redis, and two ClickHouse servers (same image): "shared" (database `proof_shared`, port 18123) and "private" (database `proof_private`, port 18124). The two database names differ on purpose.
- App: api + worker in one process on port 15560, from the head above.
- The private server was provisioned with the repo's own tasks (provisioning of a private server is outside the PR).
- Routes set on the app (environment family `CLICKHOUSE_URL__<label>__<organizationId>`):
  - `orgprivate` (label `proof`): a valid route to the private server.
  - `orgnoroute` (label `proof`): recorded as private, NO route variable.
  - `orgbadroute` (label `badlabel`): value is not a URL.
  - `orgftp` (label `ftplabel`): value is an ftp URL (parses, not http/https).
  - `orgdown` (label `downlabel`): valid URL, nothing listens on that port.
  - `orgshared`: no private label.
- Requests: `POST /api/v1/query` with a legacy project key (one project per organization). Keys are random per run and never written here.
- Each `evidence/case-<id>.txt` holds: request, raw body, `HTTP <status>`, and the rows of `system.query_log` on BOTH servers whose statement carries the case marker (`pm-<id>-`). Script: `scripts/11-cases.sh` (case 9: `scripts/12-case-windowed.sh`).
- App log lines per request: `evidence/app-log-excerpts.txt`.

## Results

| # | Case | Result |
|---|------|--------|
| 1a | Private org, unqualified `FROM traces` | PASS: HTTP 200, one row on the private server only |
| 1b | Private org, unqualified `FROM trace_metrics` | PASS: same |
| 2 | Private org, `FROM proof_private.traces` | PASS: HTTP 200, private server only |
| 3a | Private org naming `proof_shared.traces` | PASS (refused): HTTP 400 `lwql_not_permitted`, no statement on either server |
| 3b | Shared org naming `proof_private.traces` | PASS (refused): HTTP 400 `lwql_not_permitted`, no statement on either server |
| 4a/4b | Shared org, unqualified and `proof_shared.traces` | PASS: HTTP 200, shared server only |
| 5a | Private org, route variable missing | PASS: HTTP 503 `private_dataplane_unavailable` |
| 5b | Route value not a URL | HTTP 503 `private_dataplane_unavailable`, `problem: malformed` (not `lwql_unavailable`) |
| 5c | Route value is an ftp URL | HTTP 503 `internal_error` on the wire; app log `lwql_unavailable` (see notes) |
| 6 | Bad statement plus unusable route | PASS: route refusal comes first (6a missing, 6b malformed, 6d ftp). Control 6c: bad statement on a good route gives 400 `lwql_unparseable` |
| 7 | One query naming two organizations | Not reached: HTTP 404 `project_not_found` first (7a, 7b) |
| 8 | Private route unreachable | HTTP 503 `clickhouse_unavailable` on the wire (first run of this case; the earlier proof had no unreachable-route case) |
| 9 | Windowed statement, private org (completeness read) | PASS: HTTP 200 with `completeness`; both statements on the private server only, `rows on SHARED: 0` |
| 10 | Dated member window on the private route | Not run (see below) |

### 1. Unqualified statement, private org (the main point)
Request body: `SELECT 'pm-1a-' AS marker, count() AS traces FROM traces WHERE OccurredAt > now() - INTERVAL 1 DAY` -> `HTTP 200`, `"rows":[{"marker":"pm-1a-","traces":1}]`.

Private server `system.query_log` (`evidence/case-1a.txt`):
```
user:             langwatch_lwql_proof
type:             QueryFinish
current_database: proof_private
databases:        ['proof_private']
tables:           ['proof_private.lwql_api_key_tenant_map','proof_private.trace_summaries','proof_private.traces']
rows on SHARED: 0
```
1b (`trace_metrics`): `current_database: proof_private`, `tables: [... 'proof_private.trace_analytics','proof_private.trace_metrics']`, `rows on SHARED: 0`.
The database is the route's, never the shared one.

### 2. Qualified with the private database
`HTTP 200`; private log row `current_database: proof_private`, `databases: ['proof_private']`; `rows on SHARED: 0`.

### 3. Naming the other database
3a body: `{"type":"bad_request","code":"lwql_not_permitted",... "message":"The view \"proof_shared.traces\" is not available to you. ..."` -> `HTTP 400`. `rows on SHARED: 0`, `rows on PRIVATE: 0`. 3b is the mirror on the shared org (`proof_private.traces`), same code, same zero rows.

### 4. Shared org
`HTTP 200`, shared log row `current_database: proof_shared`, `tables: ['proof_shared.lwql_api_key_tenant_map','proof_shared.trace_summaries','proof_shared.traces']`, `rows on PRIVATE: 0`.

### 5. Wire case for an unusable route
5a, missing variable, full body:
```
{"type":"internal_error","code":"private_dataplane_unavailable","message":"This organization keeps its data on its own ClickHouse, which this deployment cannot reach","retryable":false,"meta":{"organizationId":"orgnoroute","kind":"clickhouse","variable":"CLICKHOUSE_URL__proof__orgnoroute","problem":"missing"},"trace_id":"...","span_id":"...","trace":{...},"tips":["Set the variable this error names (CLICKHOUSE_URL__<label>__<orgId> or DATAPLANE_S3__<label>__<orgId>) and restart the api and worker","If it is set, check its value parses: a ClickHouse URL, or S3 JSON with endpoint, bucket, accessKeyId and secretAccessKey"],"fault":"platform"}
HTTP 503
```
- Meta is on the wire: yes (`organizationId`, `kind`, `variable`, `problem`).
- `variable` is shown by name; the label is the invented `proof`; the value is never shown (5b's value `this is not a url` appears nowhere in the body or log).
- `reasons` does not appear in these bodies.
- Matches `specs/lwql/api.feature:765` (503 `private_dataplane_unavailable`).
- No row on either server (`rows on SHARED: 0`, `rows on PRIVATE: 0`).

Malformed value (5b): same shape, `"problem":"malformed"`, still `private_dataplane_unavailable`; the router refuses it before the executor sees it.

ftp value (5c): `HTTP 503`, body `{"type":"internal_error","code":"internal_error","message":"An unknown error occurred",...}` with no meta. App log: `"error.code": "lwql_unavailable", "error.message": "LangWatchQL is not available for this organization's ClickHouse."`, `statusCode 503`. So `lwql_unavailable` exists, is raised only for a URL that parses but is not http(s), names no URL, user or password (neither in body nor log), and is masked as `internal_error` on the REST wire.

### 6. Bad statement plus unusable route
`SELEC nonsense 'pm-6a-' FROM` on `orgnoroute` -> `private_dataplane_unavailable` 503 (not a parse error). Same on `orgbadroute` (6b) and `orgftp` (6d, masked `internal_error`, log `lwql_unavailable`). Control 6c on the good route: `HTTP 400 lwql_unparseable`. No statement on either server in any of them.

### 7. Statement spanning two organizations
Both orders (7a, 7b): `{"type":"not_found","code":"project_not_found","message":"Project not found",...}` `HTTP 404`. The 404 comes first, so the "set spans organizations" refusal is not reached from REST with a project key (as the spec scenario states). No statement on either server.

### 8. Private route unreachable
`HTTP 503`, body `{"type":"internal_error","code":"clickhouse_unavailable","message":"Database temporarily unavailable","retryable":false,"meta":{"reasons":[{"code":"unknown","message":"unknown","retryable":false}]},...,"fault":"platform"}`. App log: `statusCode 503`, `error.code: clickhouse_unavailable`. The earlier proof had no unreachable-route case: its `internal_error` / log `lwql_unavailable` was for the MISSING route (its case 3), which now answers `private_dataplane_unavailable` (case 5a). Here `reasons` is on the wire (all `unknown`). No statement on the shared server.
Source: the private executor's connection failure (`ECONNREFUSED`) goes through `translateClickHouseQueryError` (`modules/analytics/process/src/repositories/clickhouse/clickhouse.query-error-translation.mapper.ts:301-302`, called from `clickhouse.langwatch-ql-executor.repository.ts:144`). The code is kept through the 503 mask by `packages/handled-error/src/handled-error.ts:402`. Neither file changed between the two heads.
Presentation text for this code (`packages/handled-error/src/presentation.ts:803-810`): title "This could not be loaded right now", description "We're on it. Try again in a moment."; the wire message is "Database temporarily unavailable".

### 9. Windowed statement (completeness read), private org
Script `scripts/12-case-windowed.sh`; evidence `evidence/case-9.txt`. Request: `traces` bound to `{dashboard_context_period_start}` / `{dashboard_context_period_end}` with a `timeWindow` in the body.
Answer: `HTTP 200`, `"rows":[{"marker":"pm-9-","traces":1}]`, `"followsTimeWindow":true`, `"completeness":{"state":"complete","unit":"traces","total":1,"fields":[]}`.
Private server `system.query_log`, the two statements of the request (raw):
```
current_database: proof_private
databases:        ['proof_private']
tables:           ['proof_private.lwql_api_key_tenant_map','proof_private.trace_summaries','proof_private.traces']
query_text:       SELECT 'pm-9-' AS marker, count() AS traces FROM traces WHERE (OccurredAt >= _CAST(1793711772, 'DateTime')) AND (OccurredAt < _CAST(1793801772, 'DateTime')) LIMIT 10000 FORMAT JSON
query_text:       SELECT count() AS n FROM proof_private.traces WHERE (OccurredAt >= _CAST(1793711772, 'DateTime')) AND (OccurredAt < _CAST(1793801772, 'DateTime')) FORMAT JSON
rows on SHARED: 0   (every statement of the LangWatchQL identity since the request, not only marked ones)
```
The completeness read names `proof_private.traces` itself; the main query is unqualified and runs with `current_database: proof_private`.
Setup note: the key-map rows must exist on each server (`scripts/07-key-map.mjs`); without them the same request returned `traces: 0` and `completeness.state: no_traffic` (row policy), an empty-map artefact, not a routing result.

### 10. Dated member window on the private route: not run
`scopeLangWatchQL` rewrites to `FROM <database>.<view>` only when `memberWindows` holds a window with `from > 0`. Those come only from an aggregate project's member scope (`analytics.app.ts:865-872`, `executeLangWatchQL`, the signed-in member path). The REST key door (`analytics.app.ts:772-783`) never passes `memberWindows`, so it cannot reach this code. Setting it up needs an aggregate project with members and shared-window grants, a signed-in member session, and a private route for that organization: more than one script, so not forced.

## Not checked
- Organization-scoped or personal API keys, and the member (browser) path.
- The "set spans organizations" refusal itself (not reachable from REST).
- `pass` and dated member-window statements on a private route (case 10 not run).
- Completeness with granularity buckets, and views with nullable fields (case 9 read a `count()` only).

## Teardown
`scripts/99-down.sh` stopped the app and removed all containers and the network; no listener remained on ports 15560, 15999, 18123, 18124, 15432, 16379.
