# Use-proof for PR 9253: LangWatchQL routed to an organization's private ClickHouse

PR: https://github.com/langwatch/langwatch/pull/9253
Head SHA proven: `b34307d192dd288bb58cf59518ac42bb2eaba958` (branch `fix/lwql-private-clickhouse-routing`, worktree clean, no source changed).

Local stack, seeded with SQL, no customer data. Test ids and passwords were generated per run; the app and both ClickHouse servers ran on 127.0.0.1 only.

Later head `8d6d580bf4e48bf905f1857d6885b58385eb3f3a` changes only `specs/lwql/api.feature`, so this proof was not re-run on it.

Setup scripts are not published; the `scripts/` names below describe the steps.

## Verdict

| Case | Result |
|------|--------|
| 1. Private org's query lands on the private server | PASS |
| 2. Shared org's query lands on the shared server | PASS |
| 3. Private org with its route missing is refused | PASS on behaviour (HTTP 503, handled code `lwql_unavailable` in the server log). One wire finding below. |
| 4. Query spanning a private org and another org is refused | NOT PROVABLE through `POST /api/v1/query` (see below). The door refuses the attempt earlier, with HTTP 404 `project_not_found`. |

## Stack (all local, own containers, nothing shared touched)

Variables used below: `REPO` = the PR checkout, `PROOF` = this directory, `SECRETS` = a private directory outside it
that holds a generated env file (mode 600; passwords and keys are random per run and never written here).

| Piece | How |
|-------|-----|
| Postgres | own container `proof9253-pg`, host port 15432, database `proof9253` |
| "Shared" ClickHouse | own container `proof9253-ch-shared`, host port 18123, database `proof_shared` |
| "Private" ClickHouse | own container `proof9253-ch-private`, host port 18124, database `proof_private` |
| Redis | own container `proof9253-redis`, host port 16379 |
| App | `tools/dev-runtime` (api + worker in one process) on port 15560 from the PR checkout |

Both ClickHouse servers are the same image (`clickhouse/clickhouse-server:25.10.2.65`) with the `custom_` settings prefix and
admin access management that LangWatchQL provisioning needs (`scripts/*.xml`). I used my own pair rather than the
machine's existing ClickHouse because LangWatchQL provisioning creates server-wide users, profiles and row policies.

Routes, exactly as `modules/analytics/README.md` and ARCHITECTURE section on the `clickhouse` member describe: the env family
`CLICKHOUSE_URL__<label>__<organizationId>`. Only one route is set (`scripts/05-start-app.sh`):

```
CLICKHOUSE_URL__proof__orgprivate = <private server, database proof_private, user default>
```

Organizations (seeded by `scripts/04-seed-postgres.sh`, one project each):

| Organization | `privateClickHouseLabel` | Route set | Project |
|--------------|--------------------------|-----------|---------|
| `orgshared` | none | none | `projshared` |
| `orgprivate` | `proof` | yes | `projprivate` |
| `orgnoroute` | `proof` (recorded as private) | NO | `projnoroute` |

## Steps (re-runnable; run from this directory with `SECRETS` and `REPO` exported)

1. `scripts/01-infra-up.sh`: network, Postgres, two ClickHouse servers, Redis.
2. `scripts/02-migrate.sh`: `pnpm task upgrade` against Postgres and the shared server (migrations plus LangWatchQL provisioning).
3. `scripts/03-provision-private.sh`: the same repo tasks against the private server (stand-in for "part B", which the PR leaves out). The repo's own provisioning created the LangWatchQL user `langwatch_lwql_proof`, row policies and views there.
4. `scripts/04-seed-postgres.sh`: organizations, teams, projects.
5. `scripts/05-start-app.sh`: starts the app (background).
6. `scripts/07-key-map.mjs`: writes each project's LangWatchQL key-map row to the server its organization routes to, with the repo's own capability function. The app does this on a "project created" event; the seed used SQL, so no event fired.
7. `scripts/08-ingest-traces.sh`: one OTLP trace per project sent to the app; each landed on its own server (`stored_spans` had `projshared` on 18123 only and `projprivate` on 18124 only).
8. `scripts/09-cases.sh`: the cases below. Full raw output: `evidence/cases-raw.txt`. Case 3 log excerpt: `evidence/case3-app-log.txt` (`scripts/10-log-excerpt.sh`).

Prerequisite I had to do: the worktree's `node_modules` was older than HEAD (`@langwatch/user-contract` missing), so I ran `pnpm install --frozen-lockfile --ignore-scripts` in it. No tracked file changed.

## Case 1: private org, lands on the private server (PASS)

```
POST /api/v1/query   X-Auth-Token: <projprivate legacy project key>
{"sql":"SELECT 'proof9253-case1' AS marker, count() AS traces FROM traces WHERE OccurredAt > now() - INTERVAL 1 DAY"}
-> HTTP 200
{"columns":[{"name":"marker","type":"String"},{"name":"traces","type":"UInt64"}],"rows":[{"marker":"proof9253-case1","traces":1}], ...}
```

`system.query_log` on the PRIVATE server (port 18124):

```
event_time           user                  type         current_database  query_head
2026-11-04 09:18:52  langwatch_lwql_proof  QueryFinish  proof_private     SELECT 'proof9253-case1' AS marker, count() AS traces FROM traces WHERE OccurredAt > now() - INTERVAL 1 DAY LI...
```

Marker counts: private server has `proof9253-case1` x1; shared server has no `proof9253-case1` row (table below). The row returned (`traces: 1`) is the trace that was ingested for `projprivate`, which lives only on the private server. The user is the LangWatchQL identity, not the route's `default` user.

## Case 2: shared org, lands on the shared server (PASS)

```
POST /api/v1/query   X-Auth-Token: <projshared legacy project key>
{"sql":"SELECT 'proof9253-case2' AS marker, count() AS traces FROM traces WHERE OccurredAt > now() - INTERVAL 1 DAY"}
-> HTTP 200   rows: [{"marker":"proof9253-case2","traces":1}]
```

`system.query_log` on the SHARED server (port 18123):

```
2026-11-04 09:18:52  langwatch_lwql_proof  QueryFinish  proof_shared  SELECT 'proof9253-case2' AS marker, count() AS traces FROM traces WHERE OccurredAt > now() - INTERVAL 1 DAY LI...
```

Marker counts (whole run, both servers): shared server `proof9253-case2` x1 only; private server `proof9253-case1` x1 only. Cases 3 and 4 appear on neither: no statement ran anywhere for them.

## Case 3: private org, route missing, refused (PASS, with a wire finding)

```
POST /api/v1/query   X-Auth-Token: <projnoroute legacy project key>
{"sql":"SELECT 'proof9253-case3' AS marker, count() AS traces FROM traces WHERE OccurredAt > now() - INTERVAL 1 DAY"}
-> HTTP 503
{"type":"internal_error","code":"internal_error","message":"An unknown error occurred","retryable":false,"trace_id":"606f0922cbbfc2852e87890a1a4667fe", ...}
```

App log for that trace (`evidence/case3-app-log.txt`):

```
{"logger": "langwatch:api:hono", "msg": "error handling request", "statusCode": 503, "error.code": "lwql_unavailable", "error.type": "LangWatchQLUnavailableError", "error.message": "LangWatchQL is not available for this organization's ClickHouse."}
```

An earlier identical request also logged `Private dataplane unavailable: refusing the organization's reads and writes` for `variable CLICKHOUSE_URL__proof__orgnoroute`, `problem: missing`.
No `proof9253-case3` statement on either server (query_log marker counts). It was refused, not answered from the shared server.

**Finding:** the handled error is `lwql_unavailable` with status 503 (server side), but the REST wire body shows `internal_error` / "An unknown error occurred": the framework masks a 503 platform-fault HandledError on the wire. The spec scenario says the request "is refused with error code lwql_unavailable"; a caller sees HTTP 503 and a generic code. I did not check whether this masking also applies to the pre-existing "no restricted identity" refusal.

## Case 4: spanning organizations (not provable through this door)

What I ran (both refused before any routing, HTTP 404 `project_not_found`, no statement on either server):

```
POST /api/v1/query   <projprivate key>   {"sql": ..., "projects":["projprivate","projshared"]}  -> HTTP 404 {"code":"project_not_found", ...}
POST /api/v1/query   <projshared key>    {"sql": ..., "projects":["projshared","projprivate"]}  -> HTTP 404 {"code":"project_not_found", ...}
```

Why no key can do better: a legacy project key reads only its own project, and every other key kind lists readable projects with
`projects.listByOrganization({ organizationId: reach.organizationId })` (`modules/analytics/process/src/services/langwatch-ql-query-scope.service.ts`, `readableProjects`),
so a project of another organization is dropped as not found before `routeTenantSet` runs. The member (browser) path does the same
(`judgeMembers`, anchored on one organization). So the "set spans organizations" guard in `routeTenantSet` is defence in depth that no request I can build reaches.
I did not exercise it, and I did not substitute a unit test. A way to reach it on a running app would be a stale tenant-to-organization cache (move a project between organizations while the router cache still holds the old one, then fan out with an organization-scoped API key); I did not set that up (needs an organization-scoped key, which needs a signed-in session).

## Limits and notes

- Keys used were legacy project keys (one project each). No organization-scoped or personal API key was tried.
- The private server was provisioned with the repo's own tasks (part B is not in the PR) so the restricted user and views exist there.
- The existing local ClickHouse/Postgres/Redis were not used or modified.
- Teardown: `scripts/99-down.sh` stops the app (recorded pid only), removes the containers and network.
