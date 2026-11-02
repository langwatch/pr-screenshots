# AC11 "Existing boards are unaffected": use-proof in the running app

PR: https://github.com/langwatch/langwatch/pull/9070 (head `059c15d6832`, rebased on main).
Spec: `modules/dashboard/specs/dashboards-v2.feature`, AC11.

## Setup (what a member had before v2)

- Local stack from worktree `issue8763/launch-critical-tests` at `059c15d6832`: `pnpm dev` on port 5680, own Postgres database, own ClickHouse server, `FEATURE_FLAG_FORCE_ENABLE=release_dashboards,release_lwql_workbench`. Signed in as `browser-test@langwatch.ai` in headless Chromium (Playwright).
- Board and widget made through the normal tRPC procedures (`boards.create`, `dashboardWidgets.create`, script: [create-old-widget.cjs](create-old-widget.cjs)) with the old shape: `version: 1`, `code`, `queries`, and **no** `description`, `prompt` or `source`. The stored row ([db-row-after.json](db-row-after.json)) has keys `code, queries, version` only.
- Widget code (its own number format, no cents, no thousands separator):

```js
export default function Widget() {
  const n = LW.useChartQuery("main", {}).data?.[0]?.n ?? 0;
  return <span>{"$" + Number(n).toFixed(0)}</span>;
}
```

- Stored SQL: `SELECT count() + 1234.567 AS n FROM traces` (the project has 0 traces, so n = 1234.567; checked with `analytics.lwql.query`, answer `{"n":1234.567}`).

## Evidence

| # | Claim | What I ran, on which surface | Evidence | Verdict |
|---|-------|------------------------------|----------|---------|
| 1 | Label: the card keeps its stored title | Opened `/<project>/dashboards/<board>` in Chromium as the member; read the card | [01-board-open.png](01-board-open.png), close-up [03-widget-card.png](03-widget-card.png): card title **"Requests (old label)"** | PROVEN |
| 2 | Number format: the card shows the stored code's format, not the v2 format | Same page; read the text inside the widget's sandboxed frame on open and after reload | Frame text `["$1235"]` on open and on reload. Value is 1234.567: the stored code's `toFixed(0)` gives `$1235`; the v2 money format (cents, AC4) would give `$1,234.57`. Screenshots 01 and [02-board-after-reload.png](02-board-after-reload.png) | PROVEN |
| 3 | Code unchanged, no writes on open + reload | Logged every `/api/*` request the page sent during one open, then one reload (12 s wait each); read `dashboardWidgets.list` before and after (tRPC, same session) and the Postgres row after | [network.tsv](network.tsv): 52 requests; only non-GET is `POST analytics.lwql.query` (one per open, the widget's read). **Zero** `boards.*` or `dashboardWidgets.*` mutations (no `update`, `updateLayout`, `batchUpdateLayouts`). [list-before.json](list-before.json) vs [list-after.json](list-after.json): `graph` byte-identical; `updatedAt` = `createdAt` = `2026-11-02T11:40:39.331Z` in the DB row | PROVEN |

Script that drove the open, reload and capture: [open-board.cjs](open-board.cjs).

## Finding: the PR's test fixture code does not run in the real app

The integration test's `SAVED` widget code calls `LW.useQuery("main")`. The real widget runtime has no `LW.useQuery` (the API is `LW.useChartQuery`). Stored as-is and opened in the running app, that card shows **"Widget crashed while rendering / LW.useQuery is not a function"**: [04-test-fixture-code-crashes.png](04-test-fixture-code-crashes.png) (its board also sent no writes: [network-fixture-board.tsv](network-fixture-board.tsv)). The test still passes because it only checks the code string handed to the frame, never runs it. The proof above uses the same widget with `LW.useChartQuery`. Suggest the fixture use `LW.useChartQuery("main", {})` so it is a widget that could really have been stored.
