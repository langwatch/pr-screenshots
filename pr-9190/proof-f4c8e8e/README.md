# PR 9190 use-proof at f4c8e8eb54e (re-proof after fix batch 1)

PR: https://github.com/langwatch/langwatch/pull/9190, head `f4c8e8eb54e`.
Issues: https://github.com/langwatch/tasks/issues/1003 (product events), https://github.com/langwatch/tasks/issues/1005 (query telemetry).
Spec: `modules/dashboard/specs/dashboards-telemetry.feature`.
Earlier proof (at `c0f103c`): https://github.com/langwatch/pr-screenshots/blob/main/pr-9190/proof-c0f103c/README.md

## How it was run

- Same setup as the earlier proof: an own stack from the PR worktree at `f4c8e8eb54e`, with its own Postgres and ClickHouse database `pd9190` and Redis DB 13. The other agent's stack on :5650 was not touched.
- `apps/api` ran alone on **:5680**, with a Prometheus door on :9471. The dev runtime on :5670 ran as the worker.
- The UI bundle was rebuilt at the new head before the run (`apps/ui/dist/client.dev`, built 06:05 UTC).
- `IS_SAAS=1` with a dummy PostHog key, so the **real PostHog destination** is on. A Playwright route at `https://proof-stub.posthog.com` answered and decoded every capture, so nothing left the machine.
- Browser: Playwright 1.63 Chromium, account `proof9190@example.com`, project `local_project_0001ReVLLbolTXMtUdiwoLpP9fenQ`.

## Focus of this re-proof (the fix batch)

| Fix | Verdict | Evidence |
|---|---|---|
| (a) Widgets on a From LangWatch board count as `dashboard_widget` with `dashboardId: curated/<template>`. No workbench runs unless the editor or workbench is opened. | **PASS** | I opened "Release check" and "Data". That gave 29 log lines, every one `caller:"dashboard_widget"`, with `dashboardId:"curated/release"` or `"curated/data"` and `widgetId`/`templateId` set to the widget key (for example `ship-verdict`, `data-health`). There were 0 workbench lines. The only 2 workbench lines from the browser were at 06:10:31, from the editor preview after "Edit code" (`trace_metrics`), which is expected. `lwql-log-lines.jsonl`, `shots/01-*`, `shots/02-*` |
| (b) `asked.langy` fires only when a person asks | **PASS** | Sends **nothing**: catalogue add (06:10:07–06:10:23: `viewed`, `added.widget{catalogue}`), "Edit code" (06:10:23–06:10:45: `viewed` only), "Duplicate to edit" (`created{duplicate_curated,release}`), a template opened from a new board, a template made from the Templates library (`created{template,cockpit__voice}`). Sends **exactly one** `asked.langy {}`: a question typed in the board ask bar (06:10:57), a suggested question "Where does my money go?" on an empty board (06:13:11), and text typed in "Add a widget" then "Ask Langy" (06:13:25). `events-catalogue_add+…json`, `events-suggested+addwidget_ask.json`, `events-duplicate_curated+…json`, `events-templatelib.json`, `shots/04-*` to `shots/10-*`, `shots/14-*` |
| (c) projectId is unregistered on a load with no project in scope | **PARTIAL** | Every page I loaded while signed in has a project in scope. `/settings`, `/settings/directory`, `/account`, `/me` and `/onboarding/welcome` all keep a projectId (`/me` resolves the second project), so the new unregister branch is not reachable in the browser while a member has a project. On a signed-out full load (`/auth/signin` after dropping the session cookie), the identity hook is not mounted, and PostHog's storage still holds `projectId: local_project_0001ReVLL…`. The unit test covers the branch. A real sign-out runs `reset()` on unmount (not driven). `projectid-reload.json`, `shots/13-*`, `shots/15-*` |
| (d) The Grafana error rate does not count `aborted` | **PASS (static)** | The panel query is `outcome!~"ok\|empty\|aborted"`, and its description says why. The JSON parses. A live `aborted` run was not produced: the client hung up after 15 ms, the server had already answered, and it logged `ok`. `grafana-queries.txt` |

## Per-AC regression

| # | AC / scenario | Verdict | Evidence |
|---|---|---|---|
| 1 | Opening a board sends `viewed.dashboard` (kind, widgetCount, templateId on curated) | **PASS** | `{curated,5,release}`, `{curated,4,data}`, `{stored,0}` |
| 2 | Making a board sends `created.dashboard` with createdFrom; a refused make sends nothing | **PASS** | `blank`, `duplicate_curated`+`release`, `template`+`cockpit__voice`. With `boards.create` answered 500 there is no event (`events-r2-refuse.json`, `shots/233-*`) |
| 3 | Widget add / edit / delete send their events; a refused change sends nothing | **PASS (add, delete); carried (edit, refusals)** | `added.widget{catalogue}`, `deleted.widget`. Edit-save and refused widget changes are unchanged since `c0f103c` and were proven there |
| 4 | Deleting a board sends `deleted.dashboard` only when the server agrees | **PASS** | With `boards.delete` answered 500 there is no event. A real delete sends `deleted.dashboard` (`events-r2-del.json`, `shots/231-*`, `232-*`) |
| 5 | Asking Langy sends `asked.langy` | **PASS** | See (b). `askKind` is gone; the event has no attributes |
| 6 | Saving with Langy traces added or removed sends `toggled.langy_traces` | **carried** | Code unchanged since `c0f103c`, where it was PASS |
| 7 | Starring sends `favourited.dashboard` | **PASS** | `starred:true` on "Release check" (`shots/11-*`) |
| 8 | projectId on every event; changes with the project; goes away with no project | **PARTIAL** | It is on every captured event. Removal: see (c) |
| 9 | The log line carries caller, outcome, queryHash and the widget ids; the hash ignores extra whitespace; never SQL | **PASS** | 97 lwql log lines, 0 holding SQL text (`grep -cE 'SELECT\|FROM \|no_such_table'` gives 0). Plain SQL and the same SQL with spaces, newlines and a tab both log `d15e2476d077e338`, which equals `sha256("SELECT count() AS traces FROM traces")[0:16]` |
| 10 | A refused or failed run logs "LangWatchQL failed" with its code and is counted | **PASS** | tRPC and REST: `project_not_found` (404) and `lwql_not_permitted` (400), each logged and counted under its caller (`trpc-calls.json`, `rest-calls.json`, `metrics-lwql.txt`) |
| 11 | Metrics carry only low-cardinality labels | **PASS** | `/metrics` returns 401 without the token. Label keys on lwql series: `caller` 136, `le` 105, `outcome` 11, nothing else |
| 12 | The server sets caller; the browser cannot | **PASS, all 5 callers live** | Seen live: `dashboard_widget`, `workbench`, `rest_api`, **`source_presence`** (`dashboards.sourcePresence`, 6 runs, `empty`) and **`saved_chart`** (`analytics.savedWorkbenchCharts.create` then `.run`, logged `saved_chart ok d15e2476d077e338`). `telemetry.caller` from the browser gets **400**. A top-level `caller` is still dropped without an error (tRPC 200 logged `workbench`; REST 200 logged `rest_api`) |
| 13 | Grafana dashboard | **PASS (static)** | Parses; uses the live metric names; error rate excludes aborted |
| 14 | 1003 done-when: events in PostHog after a prod deploy | **UNPROVEN** | Needs prod |
| 15 | 1005 done-when: Grafana shows prod numbers; an alert fires | **UNPROVEN** | Needs prod; the PR has no alert rule |
| 16 | 1003 event 8: empty-state setup CTA | **NOT IN PR** | |

## Findings

No Must Fix. Should improve (not blocking):
1. **A stale projectId survives a signed-out load.** On pages outside the app chrome (sign-in) the identity hook does not mount, so a projectId PostHog stored earlier stays registered when a session expires. A real sign-out runs `reset()`. Where: `apps/ui/src/shell/use-analytics-identity.ts` runs only inside `UiAppChrome`.
2. **Read-only boards' ask bar sends no ask.** On a From LangWatch board the ask bar opens Langy with the board as context (`board-langy.tsx`, the `!onOpenPicker` branch). The member then types in Langy's own composer, which is outside dashboards and not counted. This is a gap in what the ask count covers, not an over-count.
3. **The "Ask Langy" button with an empty box** counts as an ask of "Help me build a dashboard" (`block-picker-dialog.tsx`, `askLangy`). A person pressed it, so this is defensible.
4. Carried from the earlier proof: a top-level `caller` field is dropped silently rather than refused.

## Files

- `shots/`: 20 screenshots
- `events-*.json`: the PostHog stub captures and console sink per walk, with phase start times
- `lwql-log-lines.jsonl`: every `langwatch:analytics:lwql` line of the run (hostname, pid, trace ids and userId removed)
- `metrics-lwql.txt`: lwql series from `/metrics`
- `trpc-calls.json`, `rest-calls.json`, `door-calls-saved.json`: the direct calls with status and response
- `grafana-queries.txt`: every query in the Grafana JSON
- `projectid-reload.json`, `ls-project.json`: PostHog storage before and after the loads
