# PR 9137 user-side proof at a6a2e809aa21dcd2f3b6bb719c1a17ba4537cafc

PR: https://github.com/langwatch/langwatch/pull/9137
Captured (UTC): 2026-10-29T05:04Z. Stack: https://drew-sweatshop.tailf32ef6.ts.net:6571 (worktree wt-9137-shots detached at a6a2e809aa2, `pnpm dev`, databases shots9137, LANGWATCH_SKIP_NLP/SKIP_AIGATEWAY=1).
Screenshots: https://github.com/langwatch/pr-screenshots/tree/main/pr-9137/proof-a6a2e809 (commit https://github.com/langwatch/pr-screenshots/commit/9099a1629f1b51de6c4f6fb1f05431ad3083cd5b). Every screenshot was opened and checked by eye.

Scope: the scenarios this PR adds or changes in `modules/dashboard/specs/dashboards-v2.feature`: AC190-AC195, AC200-AC200o, AC201, AC201b (21). AC196, AC197 and AC199* sit inside the AC190..AC201b line range of the file but this PR does not touch them (`git diff origin/main...a6a2e809 -- modules/dashboard/specs/dashboards-v2.feature`), so they are out of scope.

Data. OTLP seed into the personal project (riley): 4 traces with no origin key, 1 with origin "", 2 "application", 3 "langy" named `langy.turn`, 2 evaluation, 5 simulation, 1 each of sample, ai_tool, coding_agent, gateway, workflow, playground, 2 "brand_new_origin". The 46b167fc seed (3 application, 2 langy, 1 evaluation) was still there. Every OTLP trace on this stack lands with SourceType "gateway", so the `langy.turn` traces are gateway-stored Langy turns. Expected counts (ClickHouse ground truth): application 10, langy 5, other 2, every source 31, every source but langy 26, `langy.turn` 3. A later evaluation seed added 2 unstamped and 3 langy traces (application 12, langy 8, every 36, `langy.turn` 6).

Setup done straight in a store, not through a product door (named in the raw captures): (a) `sources` removed from two widgets to make widgets saved before queries had sources (AC200f, AC201b); (b) 3 Langy usage events and 2 Langy messages put into ClickHouse (AC192): this stack has no Langy model, so no real turn can write them.

Users: riley@example.com (org admin) and vic.viewer@example.com, signed up at /auth/signup, invited by riley as a Lite Member (team role Viewer) through Settings > Directory > Invite people, joined through the invite link. Team project "Team Proof" made through New Project. The passwords and keys are in 1Password ("shots9137 local ..." items); every key in this file is redacted.

## Per-AC table

| AC | What was run | Surface | Evidence | Result |
|---|---|---|---|---|
| AC190 | A board widget with sources [application], its editor preview, and the LangWatchQL door over spans and evaluations with [application], every source but langy, and every source | UI + tRPC LWQL door | Card 10 = preview 10 (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/00-board-counts-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/01-editor-pills-dark.png). spans: [application] 10 spans/10 traces, every but langy 26/26, every 31/31. evaluations: [application] 2, [langy] 3, every 5 (the evaluations of the 3 langy traces are left out) | MET |
| AC191 | `trace_metrics WHERE Origin IN ('', 'application')` with every source, every source but langy, [application] | tRPC LWQL door | 10 / 10 / 10 | MET |
| AC192 | `SELECT count() FROM langy_usage_events` and `langy_conversation_messages` with sources [application] | tRPC LWQL door | 3 and 2 = every row seeded (rows seeded straight into ClickHouse, see setup) | MET |
| AC193 | Widget with every source on the board; door with every source over traces and spans | UI + door | Card 31 (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/00-board-counts-light.png); door n=31, langy_turns=3; spans 31 | MET |
| AC194 | `POST /api/v1/query` with no sources | REST | 200, n=31, langy_turns=3 | MET |
| AC195 | `trace_metrics_by_minute` and `model_usage_by_minute` with [application] and with every source | door | 25/25 and 31/31: sources change nothing; 31 includes the langy rows | MET |
| AC200 | Editor > Edit code > Queries tab on a stored widget; Add source menu; the card footers; a two-query widget with different lists | UI | Pills lead Parameters, "Add parameter" shown, "No parameters declared yet" absent (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/01-editor-pills-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/01-editor-pills-light.png). Menu offers the 10 sources not counted yet (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/02-add-source-menu-dark.png). Footer "Sources: application, langy" and, for two queries, "Sources: mine: application · langys: langy, other" (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/10-board-after-dark.png) | MET |
| AC200b | Add langy in the editor > Save; REST read; list every widget | UI + REST | Card 10 -> 15, footer "application, langy" (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/04-save-undo-b-saved-dark.png); REST ["application","langy"]; the 8 other widgets keep their own lists | MET |
| AC200d | Lite Member (Viewer) opens the Team Proof board; the same member's session calls `dashboardWidgets.update`; the member's key PATCHes sources | UI + tRPC + REST | Footers shown, card menu only "Copy widget id" and "Export CSV", no "Add a widget" (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/13-viewer-board-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/13-viewer-board-light.png). tRPC 401 `lite_member_restricted`. REST PATCH 403 `api_key_permission_denied` (analytics:update). Stored list unchanged | MET |
| AC200f | Widget with no stored sources (personal and team): REST read, editor, card, a rename PATCH | REST + UI + Postgres check | REST read shows no sources, DB still none after the read; editor pill "application", preview 10 (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/06-legacy-editor-dark.png); the card sends `"sources":null` and shows 10 / "Sources: application"; rename PATCH 200, DB still none. Team project: "Sources: application", 0 Langy turns (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/12-team-board-riley-dark.png) | MET |
| AC200g | Add langy in the editor, then Cancel, reload | UI + REST | Preview 10 -> 15, one new `analytics.lwql.query` with ["application","langy"] (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/03-preview-rerun-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/03-preview-rerun-light.png); after Cancel card 10, REST ["application"]. Removing the last pill re-runs too (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/07-remove-last-a-edited-dark.png) | MET |
| AC200h | Open From LangWatch "Release check" in the personal and the team project | UI (network capture) | All 13 runs in each send every source but langy; footers say so (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/08-from-langwatch-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/14-from-langwatch-team-light.png). A catalogue widget added now stores the same 10 | MET |
| AC200i | Read the dashboard-widgets skill text Langy loads (`services/langyagent/internal/assets/skills/dashboard-widgets/SKILL.md`) and its recipe copies at a6a2e809 | Skill text | Names all 11 sources, the default ["application"], `--sources` and the queries-file `sources`, and tells Langy to add langy or simulation. No live Langy turn: this stack has no model | MET (text only) |
| AC200j | REST create with ["langy","other"] + a query with none; read; PATCH without sources; PATCH with null. CLI `widget add --sources application,langy`, `get`, `update --sources langy,simulation` | REST + CLI | Read back ["langy","other"]; omitted -> kept; null -> cleared (DB: no key) so it counts application. CLI stores and reads ["application","langy"], then ["langy","simulation"]. MCP add/update stores [application, langy] and then [langy] | MET |
| AC200k | Save a sources-only change, then press Undo in the "Widget saved" toast; once on a stored list and once on a widget that stored none | UI + REST + DB | ["application","langy"] -> Undo -> ["application"]; the widget that stored none: ["application","langy"] -> Undo -> no sources key (DB has_sources=false) (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/05-legacy-undo-c-undone-dark.png) | MET |
| AC200l | Door with [application], [other] and each listed origin | door | application 10 (4 key missing + 1 empty + 5 stamped), other 2 (brand_new_origin), sample 1, ai_tool 1, simulation 5, evaluation 3, coding_agent 1, gateway 1, workflow 1, playground 1. NULL: evaluations with a NULL Origin on unstamped traces count under application (2) | MET |
| AC200m | Remove the last pill > Save; REST read; Undo | UI + REST | Preview and card say "No sources picked" (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/07-remove-last-a-edited-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/07-remove-last-b-saved-dark.png); REST []; Undo -> ["application"] | MET |
| AC200n | ["bogus"] over REST create and PATCH; the editor's tRPC save with a rewritten body; the LangWatchQL door; CLI flag and queries file; MCP add and update | every door | REST 422 `validation_error` with the 11 allowed values; tRPC `dashboardWidgets.update` 422 (toast "Check your input", https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/09-trpc-unknown-source-dark.png); LWQL door 422 `validation_error` on sources; CLI refused locally (exit 1) and the server answers 422 for a queries file; MCP -32602 with the list | MET |
| AC200o | New widget through "Add a widget > I'll build it myself" (tRPC); REST create without sources; CLI add without --sources | UI + REST + CLI | Each stored ["application"] (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/11-new-widget-editor-dark.png) | MET |
| AC201 | Widget counting `TraceName = 'langy.turn'` with ["application","langy"] (the traces are gateway-stored, origin langy) | UI + door | Card 3 (https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9137/proof-a6a2e809/00-board-counts-dark.png); door 3; after the second seed card 6 | MET |
| AC201b | The same query with the default (stored ["application"], sources not sent, and a team widget that stores none) | UI + door | Card 0 in both projects; the door with null and with ["application"] -> 0 (completeness total 10, application) | MET |

**Verdict: READY.** All 21 rows are MET. Caveats: AC192 data was put straight into ClickHouse; AC200i is proven on the skill text only.

## Rough UX edges found

1. Long footers are cut short with an ellipsis ("Sources: application, simulation, …, workflow,…") on every-source widgets and on every From LangWatch card, where the same 10-origin list repeats on every card.
2. Stored lists do not grow. Catalogue widgets added at the earlier head store 8 origins ("every but langy" then) and now leave out sample and ai_tool without a sign. Any origin added later will do the same.
3. With no source picked, the preview says "No sources picked" but the query header still shows the last run ("1 row · 24ms").
4. The "No sources picked" card has no About (i) icon, and the text shows twice (body and footer).
5. A Lite Member's tRPC update is refused with 401 `lite_member_restricted`, not 403.
6. MCP `add_dashboard_widget` does not echo the stored sources (`update` does).
7. "Edit code" also opens the Langy side panel ("Langy needs a model") each time.
8. A Lite Member cannot make a key with update rights, so the PATCH 403 is at the key-permission check (analytics:update). The role-level refusal was seen on tRPC only.

## Raw captures (keys redacted)

Note: the REST create calls of the first 8 widgets ran before the capture helper was fixed. Their stored lists are in the first "REST list widgets" capture below.


### REST list widgets on the proof board

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "data": [
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
      "name": "All traces, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.113Z",
      "updatedAt": "2026-10-29T04:33:11.113Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 0,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszL",
      "name": "All traces, application+langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.988Z",
      "updatedAt": "2026-10-29T04:33:11.988Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 3,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CzzlR8vvKQpiq4zSVAjFNH0b",
      "name": "All traces, langy only",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:12.827Z",
      "updatedAt": "2026-10-29T04:33:12.827Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 6,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074DWAM6HoJzCB99pZqsrbwBf1t",
      "name": "All traces, other",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:13.69Z",
      "updatedAt": "2026-10-29T04:33:13.69Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 9,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074E2KwlQgidxWZTaAFGYUd033A",
      "name": "All traces, every source",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "langy",
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:14.59Z",
      "updatedAt": "2026-10-29T04:33:14.59Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 12,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074EYVXQZZ7IirznKkdeFNJoR4T",
      "name": "Langy turns, sources hold langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:15.487Z",
      "updatedAt": "2026-10-29T04:33:15.487Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 15,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074F4g85iRVxUDQ75L21wG0cp5v",
      "name": "Langy turns, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:16.38Z",
      "updatedAt": "2026-10-29T04:33:16.38Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 18,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074FaqikrJucFYqQpvQPd8hRD77",
      "name": "All traces, no source picked",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": []
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:17.282Z",
      "updatedAt": "2026-10-29T04:33:17.282Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 21,
      "colSpan": 4,
      "rowSpan": 3
    }
  ]
}
```

### REST create: a widget to turn into a pre-sources (legacy) widget

```
$ curl -sS -X POST 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"name":"Legacy widget, stores none","code":"export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}","queries":[{"name":"main","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"}]}'

HTTP 201
{
  "id": "widget_00075CkK8PBLFZIxEkUqFyThQ5NUA",
  "name": "Legacy widget, stores none",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:35:11.357Z",
  "updatedAt": "2026-10-29T04:35:11.357Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 24,
  "colSpan": 4,
  "rowSpan": 3
}
```

### Setup (store, not a product door): strip `sources` from widget_00075CkK8PBLFZIxEkUqFyThQ5NUA to make a pre-sources widget

```
UPDATE "DashboardWidget" SET definition = jsonb_set(definition, '{queries,0}', (definition->'queries'->0) - 'sources') WHERE id = 'widget_00075CkK8PBLFZIxEkUqFyThQ5NUA'
-> has_sources: false
```

### REST read the legacy widget (AC200f: reading stores none)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00075CkK8PBLFZIxEkUqFyThQ5NUA' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_00075CkK8PBLFZIxEkUqFyThQ5NUA",
  "name": "Legacy widget, stores none",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:35:11.357Z",
  "updatedAt": "2026-10-29T04:35:11.357Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 24,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST read after the editor was closed with Cancel (AC200g)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00074CTpAm03WffUIWKP47TqYYszK' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
  "name": "All traces, sources not sent",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:33:11.113Z",
  "updatedAt": "2026-10-29T04:33:11.113Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 0,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST read after Save (04-save-undo)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00074CTpAm03WffUIWKP47TqYYszK' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
  "name": "All traces, sources not sent",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application",
          "langy"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:33:11.113Z",
  "updatedAt": "2026-10-29T04:37:30.572Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 0,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST read after Undo (04-save-undo)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00074CTpAm03WffUIWKP47TqYYszK' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
  "name": "All traces, sources not sent",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:33:11.113Z",
  "updatedAt": "2026-10-29T04:37:34.225Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 0,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST read after Save (05-legacy-undo)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00075CkK8PBLFZIxEkUqFyThQ5NUA' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_00075CkK8PBLFZIxEkUqFyThQ5NUA",
  "name": "Legacy widget, stores none",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application",
          "langy"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:35:11.357Z",
  "updatedAt": "2026-10-29T04:38:07.858Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 24,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST list every widget after Save (05-legacy-undo)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "data": [
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
      "name": "All traces, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.113Z",
      "updatedAt": "2026-10-29T04:37:34.225Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 0,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszL",
      "name": "All traces, application+langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.988Z",
      "updatedAt": "2026-10-29T04:33:11.988Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 3,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CzzlR8vvKQpiq4zSVAjFNH0b",
      "name": "All traces, langy only",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:12.827Z",
      "updatedAt": "2026-10-29T04:33:12.827Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 6,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074DWAM6HoJzCB99pZqsrbwBf1t",
      "name": "All traces, other",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:13.69Z",
      "updatedAt": "2026-10-29T04:33:13.69Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 9,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074E2KwlQgidxWZTaAFGYUd033A",
      "name": "All traces, every source",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "langy",
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:14.59Z",
      "updatedAt": "2026-10-29T04:33:14.59Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 12,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074EYVXQZZ7IirznKkdeFNJoR4T",
      "name": "Langy turns, sources hold langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:15.487Z",
      "updatedAt": "2026-10-29T04:33:15.487Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 15,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074F4g85iRVxUDQ75L21wG0cp5v",
      "name": "Langy turns, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:16.38Z",
      "updatedAt": "2026-10-29T04:33:16.38Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 18,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074FaqikrJucFYqQpvQPd8hRD77",
      "name": "All traces, no source picked",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": []
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:17.282Z",
      "updatedAt": "2026-10-29T04:33:17.282Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 21,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00075CkK8PBLFZIxEkUqFyThQ5NUA",
      "name": "Legacy widget, stores none",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:35:11.357Z",
      "updatedAt": "2026-10-29T04:38:07.858Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 24,
      "colSpan": 4,
      "rowSpan": 3
    }
  ]
}
```

### REST read after Undo (05-legacy-undo)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00075CkK8PBLFZIxEkUqFyThQ5NUA' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_00075CkK8PBLFZIxEkUqFyThQ5NUA",
  "name": "Legacy widget, stores none",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:35:11.357Z",
  "updatedAt": "2026-10-29T04:38:12.42Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 24,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST PATCH legacy widget: rename only (AC200f: saving another change stores none)

```
$ curl -sS -X PATCH 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00075CkK8PBLFZIxEkUqFyThQ5NUA' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"name":"Legacy widget, stores none (renamed)"}'

HTTP 200
{
  "id": "widget_00075CkK8PBLFZIxEkUqFyThQ5NUA",
  "name": "Legacy widget, stores none (renamed)",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:35:11.357Z",
  "updatedAt": "2026-10-29T04:38:48.871Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 24,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST read after Save (07-remove-last)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00074CTpAm03WffUIWKP47TqYYszK' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
  "name": "All traces, sources not sent",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": []
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:33:11.113Z",
  "updatedAt": "2026-10-29T04:39:17.193Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 0,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST list every widget after Save (07-remove-last)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "data": [
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
      "name": "All traces, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": []
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.113Z",
      "updatedAt": "2026-10-29T04:39:17.193Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 0,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszL",
      "name": "All traces, application+langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.988Z",
      "updatedAt": "2026-10-29T04:33:11.988Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 3,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CzzlR8vvKQpiq4zSVAjFNH0b",
      "name": "All traces, langy only",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:12.827Z",
      "updatedAt": "2026-10-29T04:33:12.827Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 6,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074DWAM6HoJzCB99pZqsrbwBf1t",
      "name": "All traces, other",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:13.69Z",
      "updatedAt": "2026-10-29T04:33:13.69Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 9,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074E2KwlQgidxWZTaAFGYUd033A",
      "name": "All traces, every source",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "langy",
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:14.59Z",
      "updatedAt": "2026-10-29T04:33:14.59Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 12,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074EYVXQZZ7IirznKkdeFNJoR4T",
      "name": "Langy turns, sources hold langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:15.487Z",
      "updatedAt": "2026-10-29T04:33:15.487Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 15,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074F4g85iRVxUDQ75L21wG0cp5v",
      "name": "Langy turns, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:16.38Z",
      "updatedAt": "2026-10-29T04:33:16.38Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 18,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074FaqikrJucFYqQpvQPd8hRD77",
      "name": "All traces, no source picked",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": []
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:17.282Z",
      "updatedAt": "2026-10-29T04:33:17.282Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 21,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00075CkK8PBLFZIxEkUqFyThQ5NUA",
      "name": "Legacy widget, stores none (renamed)",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:35:11.357Z",
      "updatedAt": "2026-10-29T04:38:48.871Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 24,
      "colSpan": 4,
      "rowSpan": 3
    }
  ]
}
```

### REST read after Undo (07-remove-last)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00074CTpAm03WffUIWKP47TqYYszK' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
  "name": "All traces, sources not sent",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:33:11.113Z",
  "updatedAt": "2026-10-29T04:39:21.737Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 0,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST list widgets on My dashboard (made at the earlier head)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_0008N984fDsZaIOPY3FJR8WV29yjo/widgets' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "data": [
    {
      "id": "widget_0008NSKOXmB2IceCFq31zH78aEJVY",
      "name": "How much work did my agent handle?",
      "definition": {
        "version": 1,
        "code": "// Traces per bucket, with the period total and the busiest and quietest buckets.\nimport { ResponsiveContainer, ComposedChart, CartesianGrid, XAxis, YAxis, Tooltip, Bar, Line } from \"recharts\";\nimport { mergeBuckets } from \"@langwatch/charts\";\n\nconst dark = LW.theme === \"dark\";\nconst C = {\n  text: dark ? \"#f4f4f5\" : \"#18181b\",\n  subtle: dark ? \"#a1a1aa\" : \"#52525b\",\n  faint: dark ? \"#71717a\" : \"#a1a1aa\",\n  border: dark ? \"#27272a\" : \"#e4e4e7\",\n  strong: dark ? \"#3f3f46\" : \"#d4d4d8\",\n  muted: dark ? \"#27272a\" : \"#f4f4f5\",\n  panel: dark ? \"#18181b\" : \"#ffffff\",\n  teal: dark ? \"#2dd4bf\" : \"#0d9488\",\n  orange: \"#ed8926\",\n  pink: \"#ed64a6\",\n  red: dark ? \"#f87171\" : \"#dc2626\",\n  green: dark ? \"#4ade80\" : \"#16a34a\",\n};\n\n// null, undefined, NaN and \"\" stay null: a gap, never 0.\nconst num = (value) =>\n  value === null || value === undefined || value === \"\" || !Number.isFinite(Number(value))\n    ? null\n    : Number(value);\nconst known = (value) => num(value) !== null;\n// The known values summed; null only when none is known.\nconst add = (...values) =>\n  values.some(known) ? values.filter(known).reduce((sum, value) => sum + num(value), 0) : null;\n// A share, or null when the part is unknown or the whole is not above zero.\nconst ratio = (part, whole) => (known(part) && num(whole) > 0 ? num(part) / num(whole) : null);\nconst GAP = \"–\";\nconst compact = new Intl.NumberFormat(\"en-US\", { notation: \"compact\", maximumFractionDigits: 1 });\nconst count = (value) => (known(value) ? compact.format(num(value)) : GAP);\nconst pct = (value, digits = 1) => (known(value) ? (num(value) * 100).toFixed(digits) + \"%\" : GAP);\nfunction usd(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value === 0) return \"$0.00\";\n  const abs = Math.abs(value);\n  const sign = value < 0 ? \"-$\" : \"$\";\n  if (abs < 1000) return sign + abs.toFixed(abs < 0.01 ? 4 : 2);\n  return sign + compact.format(abs);\n}\nfunction ms(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value >= 1000) return (value / 1000).toFixed(value >= 10000 ? 0 : 1) + \"s\";\n  return Math.round(value) + \"ms\";\n}\n\nconst utc = (value) => new Date(String(value).replace(\" \", \"T\") + \"Z\");\nfunction bucketLabel(value) {\n  const daily = LW.dashboardContext.granularitySeconds >= 86400;\n  const parts = daily ? { month: \"short\", day: \"numeric\" } : { day: \"numeric\", hour: \"numeric\" };\n  return utc(value).toLocaleString(\"en-US\", parts);\n}\n\nconst AXIS = { fontSize: 14, fill: dark ? C.faint : \"#666666\" };\nconst TIP = { background: C.panel, border: \"1px solid \" + C.border, borderRadius: 8, fontSize: 12 };\nconst dot = (color) => ({ width: 8, height: 8, borderRadius: 4, background: color });\n\nfunction Legend({ items }) {\n  return (\n    <div style={{ display: \"flex\", gap: 12, marginBottom: 4, fontSize: 10.5, color: C.subtle }}>\n      {items.map(([color, label, dashed]) => (\n        <span key={label} style={{ display: \"flex\", alignItems: \"center\", gap: 6 }}>\n          <span style={dashed ? { width: 12, borderTop: \"2px dashed \" + color } : dot(color)} />\n          {label}\n        </span>\n      ))}\n    </div>\n  );\n}\n\nconst signed = (value) => (known(value) ? (value > 0 ? \"+\" : \"\") + pct(value, 0) : GAP);\n// The change from the first value to the last, as a share of the first; null when unknown.\nconst drift = (first, last) => (known(last) && num(first) > 0 ? (last - first) / first : null);\n\nfunction Headline({ value, label }) {\n  return (\n    <div style={{ display: \"flex\", alignItems: \"baseline\", gap: 8, marginBottom: 8 }}>\n      <span style={{ fontSize: 22, fontWeight: 600 }}>{value}</span>\n      <span style={{ fontSize: 11, color: C.subtle }}>{label}</span>\n    </div>\n  );\n}\n\n// series: keys, or { key, kind: \"count\" } for a count, whose empty bucket is a real 0.\nfunction withBuckets(query, series, rows = query.data) {\n  const buckets = query.completeness?.buckets || [];\n  const starts = new Set(buckets.map((bucket) => Date.parse(bucket.start)));\n  const aligned = buckets.length > 0 && rows.every((row) => starts.has(utc(row.bucket).getTime()));\n  if (!aligned) return [...rows];\n  return mergeBuckets({ rows, buckets, x: \"bucket\", series });\n}\n// \"Lately\" is the last bucket with a value: an empty one never stands in for it.\nconst latest = (points, key) =>\n  [...points].reverse().find((point) => known(point[key]))?.[key] ?? null;\nconst earliest = (points, key) => points.find((point) => known(point[key]))?.[key] ?? null;\n\nfunction bridge({ key, colour, yAxisId }) {\n  return (\n    <Line key={key + \"-bridge\"} yAxisId={yAxisId} type=\"monotone\" dataKey={key} stroke={colour}\n      strokeOpacity={0.4} strokeWidth={1} strokeDasharray=\"2 3\" dot={false} connectNulls\n      legendType=\"none\" tooltipType=\"none\" isAnimationActive={false} />\n  );\n}\n// An empty bucket of a measure has no value: the hover says so instead of showing 0.\nconst tipValue = (format) => (value, name) => [known(value) ? format(value) : \"No data\", name];\n\n// series: { key, label, colour, dashed?, bars? }; format labels the axis and the tooltip.\nfunction SeriesChart({ points, series, format, domain }) {\n  const legend = series.map((item) => [item.colour, item.label, item.dashed]);\n  return (\n    <div style={{ flex: 1, minHeight: 0, display: \"flex\", flexDirection: \"column\" }}>\n      <Legend items={legend} />\n      <div style={{ flex: 1, minHeight: 0 }}>\n        <ResponsiveContainer width=\"100%\" height=\"100%\">\n          <ComposedChart data={points} margin={{ top: 6, right: 4, bottom: 0, left: 0 }}>\n            <CartesianGrid vertical={false} stroke={C.border} />\n            <XAxis dataKey=\"x\" tick={AXIS} tickLine={false} axisLine={false} minTickGap={28}\n              dy={4} />\n            <YAxis tick={AXIS} tickLine={false} axisLine={false} width={48} domain={domain}\n              tickFormatter={format} />\n            <Tooltip contentStyle={TIP} formatter={tipValue(format)} filterNull={false} />\n            {series.filter((item) => !item.bars).map(bridge)}\n            {series.map((item) => item.bars ? (\n              <Bar key={item.key} dataKey={item.key} name={item.label} fill={item.colour}\n                radius={[2, 2, 0, 0]} isAnimationActive={false} />\n            ) : (\n              <Line key={item.key} type=\"monotone\" dataKey={item.key} name={item.label}\n                stroke={item.colour} strokeWidth={2} dot={false} isAnimationActive={false}\n                strokeDasharray={item.dashed ? \"4 3\" : undefined} />\n            ))}\n          </ComposedChart>\n        </ResponsiveContainer>\n      </div>\n    </div>\n  );\n}\n\nconst CENTRED = { display: \"flex\", flexDirection: \"column\", alignItems: \"center\",\n  justifyContent: \"center\" };\nconst FRAME_CSS = '@import url(\"https://fonts.googleapis.com/css2?family=Inter:wght@400..700' +\n  '&display=swap\"); body { padding: 6px 8px 8px; } ' + \".lw-row { display: none; }\\n@media (max-height: 219px) { .lw-icon { display: none !important; } }\\n@media (max-height: 179px) {\\n  .lw-full { display: none !important; }\\n  .lw-row { display: flex !important; }\\n  .lw-setup { padding: 8px 12px !important; }\\n}\";\n\nfunction Panel({ children }) {\n  return (\n    <div style={{ height: \"100%\", display: \"flex\", flexDirection: \"column\", color: C.text,\n      fontFamily: \"Inter, system-ui, sans-serif\", fontSize: 13, lineHeight: 1.5 }}>\n      <style>{FRAME_CSS}</style>\n      {children}\n    </div>\n  );\n}\n\nfunction Note({ children, color = C.faint }) {\n  return <div style={{ flex: 1, ...CENTRED, fontSize: 11.5, color }}>{children}</div>;\n}\n\nconst BUTTON = {\n  flexShrink: 0,\n  height: 28,\n  padding: \"0 10px\",\n  border: 0,\n  borderRadius: 8,\n  background: C.teal,\n  color: \"#ffffff\",\n  fontFamily: \"inherit\",\n  fontSize: 12,\n  fontWeight: 500,\n  whiteSpace: \"nowrap\",\n  cursor: \"pointer\",\n};\nconst DASHED = { border: \"1px dashed \" + C.strong, borderRadius: 8, background: C.muted + \"4d\" };\nconst CTA_CLIP = { overflow: \"hidden\", textOverflow: \"ellipsis\", whiteSpace: \"nowrap\" };\n\nfunction CallToAction() {\n  const present = LW.useChartQuery(\"present\", {});\n  if (present.isError) return <Note color={C.red}>{present.error.message}</Note>;\n  if (!present.data) return <Note>Loading</Note>;\n  if (present.data.length > 0) return <Note>No traces in this period.</Note>;\n  return (\n    <div style={{ flex: 1, minHeight: 0, display: \"flex\", flexDirection: \"column\" }}>\n      <div className=\"lw-full\" style={{ ...DASHED, flex: 1, ...CENTRED, gap: 8,\n        padding: \"24px 20px\", textAlign: \"center\" }}>\n        <div className=\"lw-icon\"\n        style={{ ...CENTRED, flexShrink: 0, width: 36, height: 36, borderRadius: 8,\n        background: C.muted }}>\n        <svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke={C.teal}\n          strokeWidth=\"1.8\" strokeLinecap=\"round\" strokeLinejoin=\"round\">\n          <path d=\"M8 5h13M13 12h8M13 19h8M3 10a2 2 0 0 0 2 2h3M3 5v12a2 2 0 0 0 2 2h3\" />\n        </svg>\n      </div>\n        <div style={{ fontSize: 13, fontWeight: 600 }}>Connect traces to continue</div>\n        <div style={{ fontSize: 11.5, color: C.subtle, maxWidth: 320 }}>\n          Send your agent's traces to LangWatch and this panel fills with its own traffic, errors and latency.\n        </div>\n        <div style={{ marginTop: 4 }}>\n          <button style={BUTTON} onClick={() => LW.navigate(\"traces\", {})}>\n        Connect traces\n      </button>\n        </div>\n      </div>\n      <div className=\"lw-row\"\n      style={{ ...DASHED, alignItems: \"center\", gap: 12,\n      padding: \"12px 16px\" }}>\n      <div\n        style={{ ...CENTRED, flexShrink: 0, width: 36, height: 36, borderRadius: 8,\n        background: C.muted }}>\n        <svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke={C.teal}\n          strokeWidth=\"1.8\" strokeLinecap=\"round\" strokeLinejoin=\"round\">\n          <path d=\"M8 5h13M13 12h8M13 19h8M3 10a2 2 0 0 0 2 2h3M3 5v12a2 2 0 0 0 2 2h3\" />\n        </svg>\n      </div>\n      <div style={{ flex: 1, minWidth: 0 }}>\n        <div style={{ fontSize: 13, fontWeight: 600, ...CTA_CLIP }}>Connect traces to continue</div>\n        <div style={{ fontSize: 11.5, color: C.subtle, ...CTA_CLIP }}>Send your agent's traces to LangWatch and this panel fills with its own traffic, errors and latency.</div>\n      </div>\n      <button style={BUTTON} onClick={() => LW.navigate(\"traces\", {})}>\n        Connect traces\n      </button>\n    </div>\n    </div>\n  );\n}\n\nexport default function Widget() {\n  const main = LW.useChartQuery(\"main\", {});\n  const failed = [main].find((query) => query.isError);\n  if (failed) return <Panel><Note color={C.red}>{failed.error.message}</Note></Panel>;\n  if (!main.data) return <Panel><Note>Loading</Note></Panel>;\n  if (main.data.length === 0) return <Panel><CallToAction /></Panel>;\n  const points = withBuckets(main, [{ key: \"traces\", kind: \"count\" }])\n    .map((row) => ({ x: bucketLabel(row.bucket), traces: num(row.traces) }));\n  const total = points.reduce((sum, point) => sum + point.traces, 0);\n  const busiest = points.toSorted((a, b) => b.traces - a.traces)[0];\n  const label = \"traces · busiest \" + busiest.x + \" (\" + count(busiest.traces) + \")\";\n  return (\n    <Panel>\n      <Headline value={count(total)} label={label} />\n      <SeriesChart points={points} format={count}\n        series={[{ key: \"traces\", label: \"traces\", colour: C.orange, bars: true }]} />\n    </Panel>\n  );\n}\n",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT addSeconds(toStartOfInterval(subtractSeconds(OccurredAt, 345600), INTERVAL {dashboard_context_granularity_seconds:UInt32} SECOND), 345600) AS bucket, uniqExact(TraceId) AS traces\nFROM trace_metrics\nWHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}\nGROUP BY bucket\nORDER BY bucket",
            "parameters": [],
            "sources": [
              "application",
              "langy"
            ]
          },
          {
            "name": "present",
            "sql": "SELECT 1 AS present\nFROM trace_metrics\nWHERE OccurredAt >= subtractDays(now(), 90)\nLIMIT 1",
            "parameters": [],
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "coding_agent",
              "gateway",
              "workflow",
              "playground",
              "other"
            ]
          }
        ],
        "description": "Every trace that arrived, interval by interval. An interval with no traces reads 0\n\nTraces per bucket, with the period total and the busiest and quietest buckets.",
        "prompt": "How much work did my agent handle? Query the LangWatchQL view trace_metrics over the dashboard period, bucketed at the dashboard grain: count traces with uniqExact(TraceId) per bucket of OccurredAt. Answer with the total for the period, the busiest and the quietest bucket with their counts, and a short series of traces per bucket. Quote the real numbers from the query result. If a query returns no rows, say plainly that there is no data for the dashboard period rather than guessing.",
        "source": {
          "kind": "catalogue",
          "catalogueId": "traffic"
        }
      },
      "createdAt": "2026-10-28T13:02:44.641Z",
      "updatedAt": "2026-10-28T13:05:56.669Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_0008N984fDsZaIOPY3FJR8WV29yjo",
      "dashboardId": "dashboard_0008N984fDsZaIOPY3FJR8WV29yjo",
      "gridColumn": 0,
      "gridRow": 0,
      "colSpan": 8,
      "rowSpan": 6
    },
    {
      "id": "widget_0008NeGK92TDRkD91AKX241QSvDzE",
      "name": "Are conversations with my agent getting longer?",
      "definition": {
        "version": 1,
        "code": "// Average traces per conversation in each bucket, and its change first to last.\nimport { ResponsiveContainer, ComposedChart, CartesianGrid, XAxis, YAxis, Tooltip, Bar, Line } from \"recharts\";\nimport { mergeBuckets } from \"@langwatch/charts\";\n\nconst dark = LW.theme === \"dark\";\nconst C = {\n  text: dark ? \"#f4f4f5\" : \"#18181b\",\n  subtle: dark ? \"#a1a1aa\" : \"#52525b\",\n  faint: dark ? \"#71717a\" : \"#a1a1aa\",\n  border: dark ? \"#27272a\" : \"#e4e4e7\",\n  strong: dark ? \"#3f3f46\" : \"#d4d4d8\",\n  muted: dark ? \"#27272a\" : \"#f4f4f5\",\n  panel: dark ? \"#18181b\" : \"#ffffff\",\n  teal: dark ? \"#2dd4bf\" : \"#0d9488\",\n  orange: \"#ed8926\",\n  pink: \"#ed64a6\",\n  red: dark ? \"#f87171\" : \"#dc2626\",\n  green: dark ? \"#4ade80\" : \"#16a34a\",\n};\n\n// null, undefined, NaN and \"\" stay null: a gap, never 0.\nconst num = (value) =>\n  value === null || value === undefined || value === \"\" || !Number.isFinite(Number(value))\n    ? null\n    : Number(value);\nconst known = (value) => num(value) !== null;\n// The known values summed; null only when none is known.\nconst add = (...values) =>\n  values.some(known) ? values.filter(known).reduce((sum, value) => sum + num(value), 0) : null;\n// A share, or null when the part is unknown or the whole is not above zero.\nconst ratio = (part, whole) => (known(part) && num(whole) > 0 ? num(part) / num(whole) : null);\nconst GAP = \"–\";\nconst compact = new Intl.NumberFormat(\"en-US\", { notation: \"compact\", maximumFractionDigits: 1 });\nconst count = (value) => (known(value) ? compact.format(num(value)) : GAP);\nconst pct = (value, digits = 1) => (known(value) ? (num(value) * 100).toFixed(digits) + \"%\" : GAP);\nfunction usd(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value === 0) return \"$0.00\";\n  const abs = Math.abs(value);\n  const sign = value < 0 ? \"-$\" : \"$\";\n  if (abs < 1000) return sign + abs.toFixed(abs < 0.01 ? 4 : 2);\n  return sign + compact.format(abs);\n}\nfunction ms(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value >= 1000) return (value / 1000).toFixed(value >= 10000 ? 0 : 1) + \"s\";\n  return Math.round(value) + \"ms\";\n}\n\nconst utc = (value) => new Date(String(value).replace(\" \", \"T\") + \"Z\");\nfunction bucketLabel(value) {\n  const daily = LW.dashboardContext.granularitySeconds >= 86400;\n  const parts = daily ? { month: \"short\", day: \"numeric\" } : { day: \"numeric\", hour: \"numeric\" };\n  return utc(value).toLocaleString(\"en-US\", parts);\n}\n\nconst AXIS = { fontSize: 14, fill: dark ? C.faint : \"#666666\" };\nconst TIP = { background: C.panel, border: \"1px solid \" + C.border, borderRadius: 8, fontSize: 12 };\nconst dot = (color) => ({ width: 8, height: 8, borderRadius: 4, background: color });\n\nfunction Legend({ items }) {\n  return (\n    <div style={{ display: \"flex\", gap: 12, marginBottom: 4, fontSize: 10.5, color: C.subtle }}>\n      {items.map(([color, label, dashed]) => (\n        <span key={label} style={{ display: \"flex\", alignItems: \"center\", gap: 6 }}>\n          <span style={dashed ? { width: 12, borderTop: \"2px dashed \" + color } : dot(color)} />\n          {label}\n        </span>\n      ))}\n    </div>\n  );\n}\n\nconst signed = (value) => (known(value) ? (value > 0 ? \"+\" : \"\") + pct(value, 0) : GAP);\n// The change from the first value to the last, as a share of the first; null when unknown.\nconst drift = (first, last) => (known(last) && num(first) > 0 ? (last - first) / first : null);\n\nfunction Headline({ value, label }) {\n  return (\n    <div style={{ display: \"flex\", alignItems: \"baseline\", gap: 8, marginBottom: 8 }}>\n      <span style={{ fontSize: 22, fontWeight: 600 }}>{value}</span>\n      <span style={{ fontSize: 11, color: C.subtle }}>{label}</span>\n    </div>\n  );\n}\n\n// series: keys, or { key, kind: \"count\" } for a count, whose empty bucket is a real 0.\nfunction withBuckets(query, series, rows = query.data) {\n  const buckets = query.completeness?.buckets || [];\n  const starts = new Set(buckets.map((bucket) => Date.parse(bucket.start)));\n  const aligned = buckets.length > 0 && rows.every((row) => starts.has(utc(row.bucket).getTime()));\n  if (!aligned) return [...rows];\n  return mergeBuckets({ rows, buckets, x: \"bucket\", series });\n}\n// \"Lately\" is the last bucket with a value: an empty one never stands in for it.\nconst latest = (points, key) =>\n  [...points].reverse().find((point) => known(point[key]))?.[key] ?? null;\nconst earliest = (points, key) => points.find((point) => known(point[key]))?.[key] ?? null;\n\nfunction bridge({ key, colour, yAxisId }) {\n  return (\n    <Line key={key + \"-bridge\"} yAxisId={yAxisId} type=\"monotone\" dataKey={key} stroke={colour}\n      strokeOpacity={0.4} strokeWidth={1} strokeDasharray=\"2 3\" dot={false} connectNulls\n      legendType=\"none\" tooltipType=\"none\" isAnimationActive={false} />\n  );\n}\n// An empty bucket of a measure has no value: the hover says so instead of showing 0.\nconst tipValue = (format) => (value, name) => [known(value) ? format(value) : \"No data\", name];\n\n// series: { key, label, colour, dashed?, bars? }; format labels the axis and the tooltip.\nfunction SeriesChart({ points, series, format, domain }) {\n  const legend = series.map((item) => [item.colour, item.label, item.dashed]);\n  return (\n    <div style={{ flex: 1, minHeight: 0, display: \"flex\", flexDirection: \"column\" }}>\n      <Legend items={legend} />\n      <div style={{ flex: 1, minHeight: 0 }}>\n        <ResponsiveContainer width=\"100%\" height=\"100%\">\n          <ComposedChart data={points} margin={{ top: 6, right: 4, bottom: 0, left: 0 }}>\n            <CartesianGrid vertical={false} stroke={C.border} />\n            <XAxis dataKey=\"x\" tick={AXIS} tickLine={false} axisLine={false} minTickGap={28}\n              dy={4} />\n            <YAxis tick={AXIS} tickLine={false} axisLine={false} width={48} domain={domain}\n              tickFormatter={format} />\n            <Tooltip contentStyle={TIP} formatter={tipValue(format)} filterNull={false} />\n            {series.filter((item) => !item.bars).map(bridge)}\n            {series.map((item) => item.bars ? (\n              <Bar key={item.key} dataKey={item.key} name={item.label} fill={item.colour}\n                radius={[2, 2, 0, 0]} isAnimationActive={false} />\n            ) : (\n              <Line key={item.key} type=\"monotone\" dataKey={item.key} name={item.label}\n                stroke={item.colour} strokeWidth={2} dot={false} isAnimationActive={false}\n                strokeDasharray={item.dashed ? \"4 3\" : undefined} />\n            ))}\n          </ComposedChart>\n        </ResponsiveContainer>\n      </div>\n    </div>\n  );\n}\n\nconst CENTRED = { display: \"flex\", flexDirection: \"column\", alignItems: \"center\",\n  justifyContent: \"center\" };\nconst FRAME_CSS = '@import url(\"https://fonts.googleapis.com/css2?family=Inter:wght@400..700' +\n  '&display=swap\"); body { padding: 6px 8px 8px; } ' + \".lw-row { display: none; }\\n@media (max-height: 219px) { .lw-icon { display: none !important; } }\\n@media (max-height: 179px) {\\n  .lw-full { display: none !important; }\\n  .lw-row { display: flex !important; }\\n  .lw-setup { padding: 8px 12px !important; }\\n}\";\n\nfunction Panel({ children }) {\n  return (\n    <div style={{ height: \"100%\", display: \"flex\", flexDirection: \"column\", color: C.text,\n      fontFamily: \"Inter, system-ui, sans-serif\", fontSize: 13, lineHeight: 1.5 }}>\n      <style>{FRAME_CSS}</style>\n      {children}\n    </div>\n  );\n}\n\nfunction Note({ children, color = C.faint }) {\n  return <div style={{ flex: 1, ...CENTRED, fontSize: 11.5, color }}>{children}</div>;\n}\n\nexport default function Widget() {\n  const main = LW.useChartQuery(\"main\", {});\n  const failed = [main].find((query) => query.isError);\n  if (failed) return <Panel><Note color={C.red}>{failed.error.message}</Note></Panel>;\n  if (!main.data) return <Panel><Note>Loading</Note></Panel>;\n  if (main.data.length === 0) {\n    return <Panel><Note>No conversations in this period.</Note></Panel>;\n  }\n  const turns = (value) => (known(value) ? num(value).toFixed(1) : GAP);\n  const points = withBuckets(main, [\"turns\"])\n    .map((row) => ({ x: bucketLabel(row.bucket), turns: num(row.turns) }));\n  const first = earliest(points, \"turns\");\n  const last = latest(points, \"turns\");\n  const label = \"turns per conversation lately, \" + signed(drift(first, last)) + \" since the first\";\n  return (\n    <Panel>\n      <Headline value={turns(last)} label={label} />\n      <SeriesChart points={points} format={turns}\n        series={[{ key: \"turns\", label: \"turns per conversation\", colour: C.teal }]} />\n    </Panel>\n  );\n}\n",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT bucket, avg(turns) AS turns, count() AS conversations\nFROM (\n  SELECT addSeconds(toStartOfInterval(subtractSeconds(OccurredAt, 345600), INTERVAL {dashboard_context_granularity_seconds:UInt32} SECOND), 345600) AS bucket, ConversationId, uniqExact(TraceId) AS turns\n  FROM trace_metrics\n  WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}\n    AND ConversationId IS NOT NULL\n    AND ConversationId != ''\n  GROUP BY bucket, ConversationId\n)\nGROUP BY bucket\nORDER BY bucket",
            "parameters": [],
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "description": "More turns per thread can mean users are not getting answers\n\nAverage traces per conversation in each bucket, and its change first to last.",
        "prompt": "Are conversations with my agent getting longer? Query the LangWatchQL view trace_metrics over the dashboard period, bucketed at the dashboard grain: per bucket of OccurredAt, count uniqExact(TraceId) for each non-empty ConversationId, then average those counts. Answer with a series of average traces per conversation per bucket, and the change from the first bucket to the last. Quote the real numbers from the query result. If a query returns no rows, say plainly that there is no data for the dashboard period rather than guessing.",
        "source": {
          "kind": "catalogue",
          "catalogueId": "conversation-length"
        }
      },
      "createdAt": "2026-10-28T13:03:07.665Z",
      "updatedAt": "2026-10-28T13:07:31.075Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_0008N984fDsZaIOPY3FJR8WV29yjo",
      "dashboardId": "dashboard_0008N984fDsZaIOPY3FJR8WV29yjo",
      "gridColumn": 0,
      "gridRow": 6,
      "colSpan": 8,
      "rowSpan": 6
    },
    {
      "id": "widget_0008NgL0Vh2j2NGWiRKsbamxEAm4P",
      "name": "What do users ask my agent about most?",
      "definition": {
        "version": 1,
        "code": "// The ten topics with the most traces, their share, and the topic that grew most.\nconst dark = LW.theme === \"dark\";\nconst C = {\n  text: dark ? \"#f4f4f5\" : \"#18181b\",\n  subtle: dark ? \"#a1a1aa\" : \"#52525b\",\n  faint: dark ? \"#71717a\" : \"#a1a1aa\",\n  border: dark ? \"#27272a\" : \"#e4e4e7\",\n  strong: dark ? \"#3f3f46\" : \"#d4d4d8\",\n  muted: dark ? \"#27272a\" : \"#f4f4f5\",\n  panel: dark ? \"#18181b\" : \"#ffffff\",\n  teal: dark ? \"#2dd4bf\" : \"#0d9488\",\n  orange: \"#ed8926\",\n  pink: \"#ed64a6\",\n  red: dark ? \"#f87171\" : \"#dc2626\",\n  green: dark ? \"#4ade80\" : \"#16a34a\",\n};\n\n// null, undefined, NaN and \"\" stay null: a gap, never 0.\nconst num = (value) =>\n  value === null || value === undefined || value === \"\" || !Number.isFinite(Number(value))\n    ? null\n    : Number(value);\nconst known = (value) => num(value) !== null;\n// The known values summed; null only when none is known.\nconst add = (...values) =>\n  values.some(known) ? values.filter(known).reduce((sum, value) => sum + num(value), 0) : null;\n// A share, or null when the part is unknown or the whole is not above zero.\nconst ratio = (part, whole) => (known(part) && num(whole) > 0 ? num(part) / num(whole) : null);\nconst GAP = \"–\";\nconst compact = new Intl.NumberFormat(\"en-US\", { notation: \"compact\", maximumFractionDigits: 1 });\nconst count = (value) => (known(value) ? compact.format(num(value)) : GAP);\nconst pct = (value, digits = 1) => (known(value) ? (num(value) * 100).toFixed(digits) + \"%\" : GAP);\nfunction usd(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value === 0) return \"$0.00\";\n  const abs = Math.abs(value);\n  const sign = value < 0 ? \"-$\" : \"$\";\n  if (abs < 1000) return sign + abs.toFixed(abs < 0.01 ? 4 : 2);\n  return sign + compact.format(abs);\n}\nfunction ms(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value >= 1000) return (value / 1000).toFixed(value >= 10000 ? 0 : 1) + \"s\";\n  return Math.round(value) + \"ms\";\n}\n\n// rowPadding is the space above and below each cell, in px.\nfunction Table({ columns, rows, rowPadding = 4 }) {\n  const cell = (column, index) => ({\n    textAlign: column.align || \"left\",\n    padding: rowPadding + \"px 0\",\n    paddingRight: index === columns.length - 1 ? 0 : 6,\n    fontWeight: 500,\n  });\n  return (\n    <div style={{ overflowX: \"auto\" }}>\n      <table style={{ width: \"100%\", borderCollapse: \"collapse\", fontSize: 11.5,\n        fontVariantNumeric: \"tabular-nums\" }}>\n        <thead>\n          <tr style={{ color: C.faint }}>\n            {columns.map((column, index) => (\n              <th key={column.header} style={cell(column, index)}>{column.header}</th>\n            ))}\n          </tr>\n        </thead>\n        <tbody>\n          {rows.map((row, rowIndex) => (\n            <tr key={rowIndex} style={{ borderTop: \"1px solid \" + C.border }}>\n              {columns.map((column, index) => (\n                <td key={column.header} style={{ ...cell(column, index), fontWeight: 400 }}>\n                  {column.cell(row)}\n                </td>\n              ))}\n            </tr>\n          ))}\n        </tbody>\n      </table>\n    </div>\n  );\n}\nconst mono = (text, color = C.subtle) => (\n  <span style={{ fontFamily: \"ui-monospace, monospace\", fontSize: 10.5, color }}>{text}</span>\n);\n\nconst signed = (value) => (known(value) ? (value > 0 ? \"+\" : \"\") + pct(value, 0) : GAP);\n// The change from the first value to the last, as a share of the first; null when unknown.\nconst drift = (first, last) => (known(last) && num(first) > 0 ? (last - first) / first : null);\n\nfunction Headline({ value, label }) {\n  return (\n    <div style={{ display: \"flex\", alignItems: \"baseline\", gap: 8, marginBottom: 8 }}>\n      <span style={{ fontSize: 22, fontWeight: 600 }}>{value}</span>\n      <span style={{ fontSize: 11, color: C.subtle }}>{label}</span>\n    </div>\n  );\n}\n\nconst share = (part, whole) => pct(ratio(part, whole), 0);\n\nconst CENTRED = { display: \"flex\", flexDirection: \"column\", alignItems: \"center\",\n  justifyContent: \"center\" };\nconst FRAME_CSS = '@import url(\"https://fonts.googleapis.com/css2?family=Inter:wght@400..700' +\n  '&display=swap\"); body { padding: 6px 8px 8px; } ' + \".lw-row { display: none; }\\n@media (max-height: 219px) { .lw-icon { display: none !important; } }\\n@media (max-height: 179px) {\\n  .lw-full { display: none !important; }\\n  .lw-row { display: flex !important; }\\n  .lw-setup { padding: 8px 12px !important; }\\n}\";\n\nfunction Panel({ children }) {\n  return (\n    <div style={{ height: \"100%\", display: \"flex\", flexDirection: \"column\", color: C.text,\n      fontFamily: \"Inter, system-ui, sans-serif\", fontSize: 13, lineHeight: 1.5 }}>\n      <style>{FRAME_CSS}</style>\n      {children}\n    </div>\n  );\n}\n\nfunction Note({ children, color = C.faint }) {\n  return <div style={{ flex: 1, ...CENTRED, fontSize: 11.5, color }}>{children}</div>;\n}\n\nexport default function Widget() {\n  const topics = LW.useChartQuery(\"topics\", {});\n  const topicTraffic = LW.useChartQuery(\"topicTraffic\", {});\n  const failed = [topics, topicTraffic].find((query) => query.isError);\n  if (failed) return <Panel><Note color={C.red}>{failed.error.message}</Note></Panel>;\n  if (!topics.data || !topicTraffic.data) return <Panel><Note>Loading</Note></Panel>;\n  if (topics.data.length === 0) {\n    return <Panel><Note>No traces with a topic in this period.</Note></Panel>;\n  }\n  const total = num(topicTraffic.data[0]?.traces);\n  const name = (row) => row.topic || row.topic_id;\n  const grew = topics.data.reduce((top, row) => (num(row.growth) > num(top.growth) ? row : top));\n  const change = (value) => (value > 0 ? \"+\" : \"\") + count(value);\n  const columns = [\n    { header: \"Topic\", cell: (row) => name(row) },\n    { header: \"Traces\", align: \"right\", cell: (row) => count(num(row.traces)) },\n    { header: \"Share\", align: \"right\", cell: (row) => share(num(row.traces), total) },\n    {\n      header: \"Second half\",\n      align: \"right\",\n      cell: (row) => <span style={{ color: C.subtle }}>{change(num(row.growth))}</span>,\n    },\n  ];\n  return (\n    <Panel>\n      <Headline value={name(grew)}\n        label={\"grew most, \" + change(num(grew.growth)) + \" traces in the second half\"} />\n      <Table columns={columns} rows={topics.data} rowPadding={3} />\n    </Panel>\n  );\n}\n",
        "queries": [
          {
            "name": "topics",
            "sql": "SELECT t.TopicId AS topic_id,\n  any(p.TopicName) AS topic,\n  uniqExact(t.TraceId) AS traces,\n  uniqExactIf(t.TraceId, t.OccurredAt >= subtractSeconds({dashboard_context_period_end:DateTime}, intDiv(dateDiff('second', {dashboard_context_period_start:DateTime}, {dashboard_context_period_end:DateTime}), 2)))\n    - uniqExactIf(t.TraceId, t.OccurredAt < subtractSeconds({dashboard_context_period_end:DateTime}, intDiv(dateDiff('second', {dashboard_context_period_start:DateTime}, {dashboard_context_period_end:DateTime}), 2))) AS growth\nFROM trace_metrics AS t\nLEFT JOIN topics AS p ON p.TopicId = t.TopicId\nWHERE t.OccurredAt >= {dashboard_context_period_start:DateTime} AND t.OccurredAt < {dashboard_context_period_end:DateTime}\n  AND t.TopicId IS NOT NULL\n  AND t.TopicId != ''\nGROUP BY topic_id\nORDER BY traces DESC\nLIMIT 10",
            "parameters": [],
            "sources": []
          },
          {
            "name": "topicTraffic",
            "sql": "SELECT uniqExact(TraceId) AS traces\nFROM trace_metrics\nWHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}\n  AND TopicId IS NOT NULL\n  AND TopicId != ''",
            "parameters": [],
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "coding_agent",
              "gateway",
              "workflow",
              "playground",
              "other"
            ]
          }
        ],
        "description": "Turn the most common questions into a roadmap\n\nThe ten topics with the most traces, their share, and the topic that grew most.",
        "prompt": "What do users ask my agent about most? Query the LangWatchQL view trace_metrics over the dashboard period: uniqExact(TraceId) per non-empty TopicId, joined to the topics view for TopicName. Answer with a top-10 table of topics: name, traces and share of all traces with a topic, and name the one topic that grew most across the period. Quote the real numbers from the query result. If a query returns no rows, say plainly that there is no data for the dashboard period rather than guessing.",
        "source": {
          "kind": "catalogue",
          "catalogueId": "topics"
        }
      },
      "createdAt": "2026-10-28T13:03:11.858Z",
      "updatedAt": "2026-10-28T13:07:49.636Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_0008N984fDsZaIOPY3FJR8WV29yjo",
      "dashboardId": "dashboard_0008N984fDsZaIOPY3FJR8WV29yjo",
      "gridColumn": 0,
      "gridRow": 12,
      "colSpan": 8,
      "rowSpan": 4
    }
  ]
}
```

### REST list after adding the catalogue widget 'How much work did my agent handle?' from Add a widget (AC200h note)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "data": [
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
      "name": "All traces, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.113Z",
      "updatedAt": "2026-10-29T04:39:21.737Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 0,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszL",
      "name": "All traces, application+langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.988Z",
      "updatedAt": "2026-10-29T04:33:11.988Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 3,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CzzlR8vvKQpiq4zSVAjFNH0b",
      "name": "All traces, langy only",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:12.827Z",
      "updatedAt": "2026-10-29T04:33:12.827Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 6,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074DWAM6HoJzCB99pZqsrbwBf1t",
      "name": "All traces, other",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:13.69Z",
      "updatedAt": "2026-10-29T04:33:13.69Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 9,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074E2KwlQgidxWZTaAFGYUd033A",
      "name": "All traces, every source",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "langy",
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:14.59Z",
      "updatedAt": "2026-10-29T04:33:14.59Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 12,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074EYVXQZZ7IirznKkdeFNJoR4T",
      "name": "Langy turns, sources hold langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:15.487Z",
      "updatedAt": "2026-10-29T04:33:15.487Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 15,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074F4g85iRVxUDQ75L21wG0cp5v",
      "name": "Langy turns, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:16.38Z",
      "updatedAt": "2026-10-29T04:33:16.38Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 18,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074FaqikrJucFYqQpvQPd8hRD77",
      "name": "All traces, no source picked",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": []
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:17.282Z",
      "updatedAt": "2026-10-29T04:33:17.282Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 21,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00075CkK8PBLFZIxEkUqFyThQ5NUA",
      "name": "Legacy widget, stores none (renamed)",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:35:11.357Z",
      "updatedAt": "2026-10-29T04:38:48.871Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 24,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00078BT8ee9gpd9yM9zoG0hjFPItW",
      "name": "How much work did my agent handle?",
      "definition": {
        "version": 1,
        "code": "// Traces per bucket, with the period total and the busiest and quietest buckets.\nimport { ResponsiveContainer, ComposedChart, CartesianGrid, XAxis, YAxis, Tooltip, Bar, Line } from \"recharts\";\nimport { mergeBuckets } from \"@langwatch/charts\";\n\nconst dark = LW.theme === \"dark\";\nconst C = {\n  text: dark ? \"#f4f4f5\" : \"#18181b\",\n  subtle: dark ? \"#a1a1aa\" : \"#52525b\",\n  faint: dark ? \"#71717a\" : \"#a1a1aa\",\n  border: dark ? \"#27272a\" : \"#e4e4e7\",\n  strong: dark ? \"#3f3f46\" : \"#d4d4d8\",\n  muted: dark ? \"#27272a\" : \"#f4f4f5\",\n  panel: dark ? \"#18181b\" : \"#ffffff\",\n  teal: dark ? \"#2dd4bf\" : \"#0d9488\",\n  orange: \"#ed8926\",\n  pink: \"#ed64a6\",\n  red: dark ? \"#f87171\" : \"#dc2626\",\n  green: dark ? \"#4ade80\" : \"#16a34a\",\n};\n\n// null, undefined, NaN and \"\" stay null: a gap, never 0.\nconst num = (value) =>\n  value === null || value === undefined || value === \"\" || !Number.isFinite(Number(value))\n    ? null\n    : Number(value);\nconst known = (value) => num(value) !== null;\n// The known values summed; null only when none is known.\nconst add = (...values) =>\n  values.some(known) ? values.filter(known).reduce((sum, value) => sum + num(value), 0) : null;\n// A share, or null when the part is unknown or the whole is not above zero.\nconst ratio = (part, whole) => (known(part) && num(whole) > 0 ? num(part) / num(whole) : null);\nconst GAP = \"–\";\nconst compact = new Intl.NumberFormat(\"en-US\", { notation: \"compact\", maximumFractionDigits: 1 });\nconst count = (value) => (known(value) ? compact.format(num(value)) : GAP);\nconst pct = (value, digits = 1) => (known(value) ? (num(value) * 100).toFixed(digits) + \"%\" : GAP);\nfunction usd(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value === 0) return \"$0.00\";\n  const abs = Math.abs(value);\n  const sign = value < 0 ? \"-$\" : \"$\";\n  if (abs < 1000) return sign + abs.toFixed(abs < 0.01 ? 4 : 2);\n  return sign + compact.format(abs);\n}\nfunction ms(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value >= 1000) return (value / 1000).toFixed(value >= 10000 ? 0 : 1) + \"s\";\n  return Math.round(value) + \"ms\";\n}\n\nconst utc = (value) => new Date(String(value).replace(\" \", \"T\") + \"Z\");\nfunction bucketLabel(value) {\n  const daily = LW.dashboardContext.granularitySeconds >= 86400;\n  const parts = daily ? { month: \"short\", day: \"numeric\" } : { day: \"numeric\", hour: \"numeric\" };\n  return utc(value).toLocaleString(\"en-US\", parts);\n}\n\nconst AXIS = { fontSize: 14, fill: dark ? C.faint : \"#666666\" };\nconst TIP = { background: C.panel, border: \"1px solid \" + C.border, borderRadius: 8, fontSize: 12 };\nconst dot = (color) => ({ width: 8, height: 8, borderRadius: 4, background: color });\n\nfunction Legend({ items }) {\n  return (\n    <div style={{ display: \"flex\", gap: 12, marginBottom: 4, fontSize: 10.5, color: C.subtle }}>\n      {items.map(([color, label, dashed]) => (\n        <span key={label} style={{ display: \"flex\", alignItems: \"center\", gap: 6 }}>\n          <span style={dashed ? { width: 12, borderTop: \"2px dashed \" + color } : dot(color)} />\n          {label}\n        </span>\n      ))}\n    </div>\n  );\n}\n\nconst signed = (value) => (known(value) ? (value > 0 ? \"+\" : \"\") + pct(value, 0) : GAP);\n// The change from the first value to the last, as a share of the first; null when unknown.\nconst drift = (first, last) => (known(last) && num(first) > 0 ? (last - first) / first : null);\n\nfunction Headline({ value, label }) {\n  return (\n    <div style={{ display: \"flex\", alignItems: \"baseline\", gap: 8, marginBottom: 8 }}>\n      <span style={{ fontSize: 22, fontWeight: 600 }}>{value}</span>\n      <span style={{ fontSize: 11, color: C.subtle }}>{label}</span>\n    </div>\n  );\n}\n\n// series: keys, or { key, kind: \"count\" } for a count, whose empty bucket is a real 0.\nfunction withBuckets(query, series, rows = query.data) {\n  const buckets = query.completeness?.buckets || [];\n  const starts = new Set(buckets.map((bucket) => Date.parse(bucket.start)));\n  const aligned = buckets.length > 0 && rows.every((row) => starts.has(utc(row.bucket).getTime()));\n  if (!aligned) return [...rows];\n  return mergeBuckets({ rows, buckets, x: \"bucket\", series });\n}\n// \"Lately\" is the last bucket with a value: an empty one never stands in for it.\nconst latest = (points, key) =>\n  [...points].reverse().find((point) => known(point[key]))?.[key] ?? null;\nconst earliest = (points, key) => points.find((point) => known(point[key]))?.[key] ?? null;\n\nfunction bridge({ key, colour, yAxisId }) {\n  return (\n    <Line key={key + \"-bridge\"} yAxisId={yAxisId} type=\"monotone\" dataKey={key} stroke={colour}\n      strokeOpacity={0.4} strokeWidth={1} strokeDasharray=\"2 3\" dot={false} connectNulls\n      legendType=\"none\" tooltipType=\"none\" isAnimationActive={false} />\n  );\n}\n// An empty bucket of a measure has no value: the hover says so instead of showing 0.\nconst tipValue = (format) => (value, name) => [known(value) ? format(value) : \"No data\", name];\n\n// series: { key, label, colour, dashed?, bars? }; format labels the axis and the tooltip.\nfunction SeriesChart({ points, series, format, domain }) {\n  const legend = series.map((item) => [item.colour, item.label, item.dashed]);\n  return (\n    <div style={{ flex: 1, minHeight: 0, display: \"flex\", flexDirection: \"column\" }}>\n      <Legend items={legend} />\n      <div style={{ flex: 1, minHeight: 0 }}>\n        <ResponsiveContainer width=\"100%\" height=\"100%\">\n          <ComposedChart data={points} margin={{ top: 6, right: 4, bottom: 0, left: 0 }}>\n            <CartesianGrid vertical={false} stroke={C.border} />\n            <XAxis dataKey=\"x\" tick={AXIS} tickLine={false} axisLine={false} minTickGap={28}\n              dy={4} />\n            <YAxis tick={AXIS} tickLine={false} axisLine={false} width={48} domain={domain}\n              tickFormatter={format} />\n            <Tooltip contentStyle={TIP} formatter={tipValue(format)} filterNull={false} />\n            {series.filter((item) => !item.bars).map(bridge)}\n            {series.map((item) => item.bars ? (\n              <Bar key={item.key} dataKey={item.key} name={item.label} fill={item.colour}\n                radius={[2, 2, 0, 0]} isAnimationActive={false} />\n            ) : (\n              <Line key={item.key} type=\"monotone\" dataKey={item.key} name={item.label}\n                stroke={item.colour} strokeWidth={2} dot={false} isAnimationActive={false}\n                strokeDasharray={item.dashed ? \"4 3\" : undefined} />\n            ))}\n          </ComposedChart>\n        </ResponsiveContainer>\n      </div>\n    </div>\n  );\n}\n\nconst CENTRED = { display: \"flex\", flexDirection: \"column\", alignItems: \"center\",\n  justifyContent: \"center\" };\nconst FRAME_CSS = '@import url(\"https://fonts.googleapis.com/css2?family=Inter:wght@400..700' +\n  '&display=swap\"); body { padding: 6px 8px 8px; } ' + \".lw-row { display: none; }\\n@media (max-height: 219px) { .lw-icon { display: none !important; } }\\n@media (max-height: 179px) {\\n  .lw-full { display: none !important; }\\n  .lw-row { display: flex !important; }\\n  .lw-setup { padding: 8px 12px !important; }\\n}\";\n\nfunction Panel({ children }) {\n  return (\n    <div style={{ height: \"100%\", display: \"flex\", flexDirection: \"column\", color: C.text,\n      fontFamily: \"Inter, system-ui, sans-serif\", fontSize: 13, lineHeight: 1.5 }}>\n      <style>{FRAME_CSS}</style>\n      {children}\n    </div>\n  );\n}\n\nfunction Note({ children, color = C.faint }) {\n  return <div style={{ flex: 1, ...CENTRED, fontSize: 11.5, color }}>{children}</div>;\n}\n\nconst BUTTON = {\n  flexShrink: 0,\n  height: 28,\n  padding: \"0 10px\",\n  border: 0,\n  borderRadius: 8,\n  background: C.teal,\n  color: \"#ffffff\",\n  fontFamily: \"inherit\",\n  fontSize: 12,\n  fontWeight: 500,\n  whiteSpace: \"nowrap\",\n  cursor: \"pointer\",\n};\nconst DASHED = { border: \"1px dashed \" + C.strong, borderRadius: 8, background: C.muted + \"4d\" };\nconst CTA_CLIP = { overflow: \"hidden\", textOverflow: \"ellipsis\", whiteSpace: \"nowrap\" };\n\nfunction CallToAction() {\n  const present = LW.useChartQuery(\"present\", {});\n  if (present.isError) return <Note color={C.red}>{present.error.message}</Note>;\n  if (!present.data) return <Note>Loading</Note>;\n  if (present.data.length > 0) return <Note>No traces in this period.</Note>;\n  return (\n    <div style={{ flex: 1, minHeight: 0, display: \"flex\", flexDirection: \"column\" }}>\n      <div className=\"lw-full\" style={{ ...DASHED, flex: 1, ...CENTRED, gap: 8,\n        padding: \"24px 20px\", textAlign: \"center\" }}>\n        <div className=\"lw-icon\"\n        style={{ ...CENTRED, flexShrink: 0, width: 36, height: 36, borderRadius: 8,\n        background: C.muted }}>\n        <svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke={C.teal}\n          strokeWidth=\"1.8\" strokeLinecap=\"round\" strokeLinejoin=\"round\">\n          <path d=\"M8 5h13M13 12h8M13 19h8M3 10a2 2 0 0 0 2 2h3M3 5v12a2 2 0 0 0 2 2h3\" />\n        </svg>\n      </div>\n        <div style={{ fontSize: 13, fontWeight: 600 }}>Connect traces to continue</div>\n        <div style={{ fontSize: 11.5, color: C.subtle, maxWidth: 320 }}>\n          Send your agent's traces to LangWatch and this panel fills with its own traffic, errors and latency.\n        </div>\n        <div style={{ marginTop: 4 }}>\n          <button style={BUTTON} onClick={() => LW.navigate(\"traces\", {})}>\n        Connect traces\n      </button>\n        </div>\n      </div>\n      <div className=\"lw-row\"\n      style={{ ...DASHED, alignItems: \"center\", gap: 12,\n      padding: \"12px 16px\" }}>\n      <div\n        style={{ ...CENTRED, flexShrink: 0, width: 36, height: 36, borderRadius: 8,\n        background: C.muted }}>\n        <svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke={C.teal}\n          strokeWidth=\"1.8\" strokeLinecap=\"round\" strokeLinejoin=\"round\">\n          <path d=\"M8 5h13M13 12h8M13 19h8M3 10a2 2 0 0 0 2 2h3M3 5v12a2 2 0 0 0 2 2h3\" />\n        </svg>\n      </div>\n      <div style={{ flex: 1, minWidth: 0 }}>\n        <div style={{ fontSize: 13, fontWeight: 600, ...CTA_CLIP }}>Connect traces to continue</div>\n        <div style={{ fontSize: 11.5, color: C.subtle, ...CTA_CLIP }}>Send your agent's traces to LangWatch and this panel fills with its own traffic, errors and latency.</div>\n      </div>\n      <button style={BUTTON} onClick={() => LW.navigate(\"traces\", {})}>\n        Connect traces\n      </button>\n    </div>\n    </div>\n  );\n}\n\nexport default function Widget() {\n  const main = LW.useChartQuery(\"main\", {});\n  const failed = [main].find((query) => query.isError);\n  if (failed) return <Panel><Note color={C.red}>{failed.error.message}</Note></Panel>;\n  if (!main.data) return <Panel><Note>Loading</Note></Panel>;\n  if (main.data.length === 0) return <Panel><CallToAction /></Panel>;\n  const points = withBuckets(main, [{ key: \"traces\", kind: \"count\" }])\n    .map((row) => ({ x: bucketLabel(row.bucket), traces: num(row.traces) }));\n  const total = points.reduce((sum, point) => sum + point.traces, 0);\n  const busiest = points.toSorted((a, b) => b.traces - a.traces)[0];\n  const label = \"traces · busiest \" + busiest.x + \" (\" + count(busiest.traces) + \")\";\n  return (\n    <Panel>\n      <Headline value={count(total)} label={label} />\n      <SeriesChart points={points} format={count}\n        series={[{ key: \"traces\", label: \"traces\", colour: C.orange, bars: true }]} />\n    </Panel>\n  );\n}\n",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT addSeconds(toStartOfInterval(subtractSeconds(OccurredAt, 345600), INTERVAL {dashboard_context_granularity_seconds:UInt32} SECOND), 345600) AS bucket, uniqExact(TraceId) AS traces\nFROM trace_metrics\nWHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}\nGROUP BY bucket\nORDER BY bucket",
            "parameters": [],
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "other"
            ]
          },
          {
            "name": "present",
            "sql": "SELECT 1 AS present\nFROM trace_metrics\nWHERE OccurredAt >= subtractDays(now(), 90)\nLIMIT 1",
            "parameters": [],
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "other"
            ]
          }
        ],
        "description": "Every trace that arrived, interval by interval. An interval with no traces reads 0\n\nTraces per bucket, with the period total and the busiest and quietest buckets.",
        "prompt": "How much work did my agent handle? Query the LangWatchQL view trace_metrics over the dashboard period, bucketed at the dashboard grain: count traces with uniqExact(TraceId) per bucket of OccurredAt. Answer with the total for the period, the busiest and the quietest bucket with their counts, and a short series of traces per bucket. Quote the real numbers from the query result. If a query returns no rows, say plainly that there is no data for the dashboard period rather than guessing.",
        "source": {
          "kind": "catalogue",
          "catalogueId": "traffic"
        }
      },
      "createdAt": "2026-10-29T04:41:07.882Z",
      "updatedAt": "2026-10-29T04:41:07.969Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 27,
      "colSpan": 8,
      "rowSpan": 6
    }
  ]
}
```

### REST /api/v1/query, no sources named (AC194): every origin, Langy's included

```
$ curl -sS -X POST 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/query' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"sql":"SELECT count() AS n, countIf(TraceName = 'langy.turn') AS langy_turns FROM traces WHERE OccurredAt >= now() - INTERVAL 30 DAY LIMIT 10"}'

HTTP 200
{
  "columns": [
    {
      "name": "n",
      "type": "UInt64"
    },
    {
      "name": "langy_turns",
      "type": "UInt64"
    }
  ],
  "rows": [
    {
      "n": 31,
      "langy_turns": 3
    }
  ],
  "statistics": {
    "elapsedMs": 5,
    "rowsRead": 37,
    "bytesRead": 4608,
    "rowsReturned": 1
  },
  "diagnostics": [],
  "followsTimeWindow": false,
  "followsGranularity": false
}
```

### Setup (store, not a product door): Langy own-data rows for AC192 (no Langy model is set up on this stack, so no real turn can write them)

```
INSERT INTO langy_analytics_events (TenantId, EventId, EventType, EventVersion, AggregateId, OccurredAt, AcceptedAt) VALUES ('project_0008MjBX62ihhQD8K7fxm1wOVWbhL','proof-ev-1','turn_started','1','proof-conv-1',now64(3),now64(3)),('project_0008MjBX62ihhQD8K7fxm1wOVWbhL','proof-ev-2','turn_finished','1','proof-conv-1',now64(3),now64(3)),('project_0008MjBX62ihhQD8K7fxm1wOVWbhL','proof-ev-3','tool_called','1','proof-conv-1',now64(3),now64(3))
INSERT INTO langy_messages (TenantId, ConversationId, MessageId, Role, Parts, CreatedAt, UpdatedAt) VALUES ('project_0008MjBX62ihhQD8K7fxm1wOVWbhL','proof-conv-1','proof-m-1','user','[]',now64(3),now64(3)),('project_0008MjBX62ihhQD8K7fxm1wOVWbhL','proof-conv-1','proof-m-2','assistant','[]',now64(3),now64(3))
-> langy_usage_events rows: 3, langy_conversation_messages rows: 2
```

### REST create (AC200j): a widget whose query sends sources [langy, other], and a second query that sends none

```
$ curl -sS -X POST 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"name":"Two queries, different sources","code":"export default function Widget() {\n  const a = LW.useChartQuery(\"mine\", {});\n  const b = LW.useChartQuery(\"langys\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (a.isError || b.isError) return <div style={{ color: \"#dc2626\" }}>{(a.error || b.error).message}</div>;\n  if (!a.data || !b.data) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={a.data[0].n + \"/\" + b.data[0].n} style={{ color: fg, fontSize: 28 }}>mine {String(a.data[0].n)} · langy {String(b.data[0].n)}</div>;\n}","queries":[{"name":"mine","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"},{"name":"langys","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","sources":["langy","other"]}]}'

HTTP 201
{
  "id": "widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ",
  "name": "Two queries, different sources",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const a = LW.useChartQuery(\"mine\", {});\n  const b = LW.useChartQuery(\"langys\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (a.isError || b.isError) return <div style={{ color: \"#dc2626\" }}>{(a.error || b.error).message}</div>;\n  if (!a.data || !b.data) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={a.data[0].n + \"/\" + b.data[0].n} style={{ color: fg, fontSize: 28 }}>mine {String(a.data[0].n)} · langy {String(b.data[0].n)}</div>;\n}",
    "queries": [
      {
        "name": "mine",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      },
      {
        "name": "langys",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "langy",
          "other"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:44:33.558Z",
  "updatedAt": "2026-10-29T04:44:33.558Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 33,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST read back (AC200j)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ",
  "name": "Two queries, different sources",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const a = LW.useChartQuery(\"mine\", {});\n  const b = LW.useChartQuery(\"langys\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (a.isError || b.isError) return <div style={{ color: \"#dc2626\" }}>{(a.error || b.error).message}</div>;\n  if (!a.data || !b.data) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={a.data[0].n + \"/\" + b.data[0].n} style={{ color: fg, fontSize: 28 }}>mine {String(a.data[0].n)} · langy {String(b.data[0].n)}</div>;\n}",
    "queries": [
      {
        "name": "mine",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      },
      {
        "name": "langys",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "langy",
          "other"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:44:33.558Z",
  "updatedAt": "2026-10-29T04:44:33.558Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 33,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST PATCH (AC200j): queries resent with no sources key: each keeps the list stored under its name

```
$ curl -sS -X PATCH 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"code":"export default function Widget() {\n  const a = LW.useChartQuery(\"mine\", {});\n  const b = LW.useChartQuery(\"langys\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (a.isError || b.isError) return <div style={{ color: \"#dc2626\" }}>{(a.error || b.error).message}</div>;\n  if (!a.data || !b.data) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={a.data[0].n + \"/\" + b.data[0].n} style={{ color: fg, fontSize: 28 }}>mine {String(a.data[0].n)} · langy {String(b.data[0].n)}</div>;\n}","queries":[{"name":"mine","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"},{"name":"langys","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"}]}'

HTTP 200
{
  "id": "widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ",
  "name": "Two queries, different sources",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const a = LW.useChartQuery(\"mine\", {});\n  const b = LW.useChartQuery(\"langys\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (a.isError || b.isError) return <div style={{ color: \"#dc2626\" }}>{(a.error || b.error).message}</div>;\n  if (!a.data || !b.data) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={a.data[0].n + \"/\" + b.data[0].n} style={{ color: fg, fontSize: 28 }}>mine {String(a.data[0].n)} · langy {String(b.data[0].n)}</div>;\n}",
    "queries": [
      {
        "name": "mine",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      },
      {
        "name": "langys",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "langy",
          "other"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:44:33.558Z",
  "updatedAt": "2026-10-29T04:44:44.695Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 33,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST PATCH (AC200j): langys sends sources null: cleared, so it counts application

```
$ curl -sS -X PATCH 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"code":"export default function Widget() {\n  const a = LW.useChartQuery(\"mine\", {});\n  const b = LW.useChartQuery(\"langys\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (a.isError || b.isError) return <div style={{ color: \"#dc2626\" }}>{(a.error || b.error).message}</div>;\n  if (!a.data || !b.data) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={a.data[0].n + \"/\" + b.data[0].n} style={{ color: fg, fontSize: 28 }}>mine {String(a.data[0].n)} · langy {String(b.data[0].n)}</div>;\n}","queries":[{"name":"mine","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"},{"name":"langys","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","sources":null}]}'

HTTP 200
{
  "id": "widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ",
  "name": "Two queries, different sources",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const a = LW.useChartQuery(\"mine\", {});\n  const b = LW.useChartQuery(\"langys\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (a.isError || b.isError) return <div style={{ color: \"#dc2626\" }}>{(a.error || b.error).message}</div>;\n  if (!a.data || !b.data) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={a.data[0].n + \"/\" + b.data[0].n} style={{ color: fg, fontSize: 28 }}>mine {String(a.data[0].n)} · langy {String(b.data[0].n)}</div>;\n}",
    "queries": [
      {
        "name": "mine",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      },
      {
        "name": "langys",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:44:33.558Z",
  "updatedAt": "2026-10-29T04:44:45.577Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 33,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST PATCH: langys back to [langy, other] (queries only, no code)

```
$ curl -sS -X PATCH 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"queries":[{"name":"mine","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"},{"name":"langys","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","sources":["langy","other"]}]}'

HTTP 200
{
  "id": "widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ",
  "name": "Two queries, different sources",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const a = LW.useChartQuery(\"mine\", {});\n  const b = LW.useChartQuery(\"langys\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (a.isError || b.isError) return <div style={{ color: \"#dc2626\" }}>{(a.error || b.error).message}</div>;\n  if (!a.data || !b.data) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={a.data[0].n + \"/\" + b.data[0].n} style={{ color: fg, fontSize: 28 }}>mine {String(a.data[0].n)} · langy {String(b.data[0].n)}</div>;\n}",
    "queries": [
      {
        "name": "mine",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      },
      {
        "name": "langys",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "langy",
          "other"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:44:33.558Z",
  "updatedAt": "2026-10-29T04:44:56.891Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 33,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST create with sources [sample, ai_tool] (the new origins are accepted)

```
$ curl -sS -X POST 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"name":"Sample and ai_tool","code":"export default function Widget() { const { data } = LW.useChartQuery(\"main\", {}); return <div data-count={String(data?.[0]?.n ?? 0)} style={{ fontSize: 44, color: LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\" }}>{String(data?.[0]?.n ?? \"\")}</div>; }","queries":[{"name":"main","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","sources":["sample","ai_tool"]}]}'

HTTP 201
{
  "id": "widget_0007A6oQfH5UIqnRzQoohtmc4KPgH",
  "name": "Sample and ai_tool",
  "definition": {
    "version": 1,
    "code": "export default function Widget() { const { data } = LW.useChartQuery(\"main\", {}); return <div data-count={String(data?.[0]?.n ?? 0)} style={{ fontSize: 44, color: LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\" }}>{String(data?.[0]?.n ?? \"\")}</div>; }",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "sample",
          "ai_tool"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:44:57.788Z",
  "updatedAt": "2026-10-29T04:44:57.788Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 36,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST create with an unknown source (AC200n): refused

```
$ curl -sS -X POST 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"name":"bogus","code":"export default function Widget() { return null; }","queries":[{"name":"main","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","sources":["bogus"]}]}'

HTTP 422
{
  "type": "unprocessable_entity",
  "code": "validation_error",
  "message": "The request body didn't match the expected shape.",
  "retryable": false,
  "meta": {
    "target": "json",
    "fields": [
      "queries.0.sources.0"
    ],
    "reasons": [
      {
        "code": "schema_failure",
        "message": "Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"",
        "retryable": false,
        "meta": {
          "field": "queries.0.sources.0",
          "type": "invalid_value",
          "message": "Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"",
          "expected": [
            "application",
            "simulation",
            "evaluation",
            "sample",
            "coding_agent",
            "ai_tool",
            "gateway",
            "workflow",
            "playground",
            "langy",
            "other"
          ],
          "received": "bogus"
        }
      }
    ]
  },
  "trace_id": "96c4bb4c71937e8b0a0735daa72795b9",
  "span_id": "924b4cb9a2d0ff9c",
  "trace": {
    "traceId": "96c4bb4c71937e8b0a0735daa72795b9",
    "spanId": "924b4cb9a2d0ff9c"
  },
  "tips": [
    "Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected",
    "Fix those fields and send the request again; retrying it unchanged will fail identically"
  ],
  "fault": "customer"
}
```

### REST PATCH with an unknown source (AC200n): refused

```
$ curl -sS -X PATCH 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ' -H 'X-Auth-Token: <redacted riley personal key>' -H 'Content-Type: application/json' --data '{"queries":[{"name":"mine","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","sources":["application","Langy"]}]}'

HTTP 422
{
  "type": "unprocessable_entity",
  "code": "validation_error",
  "message": "The request body didn't match the expected shape.",
  "retryable": false,
  "meta": {
    "target": "json",
    "fields": [
      "queries.0.sources.1"
    ],
    "reasons": [
      {
        "code": "schema_failure",
        "message": "Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"",
        "retryable": false,
        "meta": {
          "field": "queries.0.sources.1",
          "type": "invalid_value",
          "message": "Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"",
          "expected": [
            "application",
            "simulation",
            "evaluation",
            "sample",
            "coding_agent",
            "ai_tool",
            "gateway",
            "workflow",
            "playground",
            "langy",
            "other"
          ],
          "received": "Langy"
        }
      }
    ]
  },
  "trace_id": "3f4724cf5471f7479c576beeb977a6e2",
  "span_id": "906bd27ac8e4f1ff",
  "trace": {
    "traceId": "3f4724cf5471f7479c576beeb977a6e2",
    "spanId": "906bd27ac8e4f1ff"
  },
  "tips": [
    "Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected",
    "Fix those fields and send the request again; retrying it unchanged will fail identically"
  ],
  "fault": "customer"
}
```

### REST read after the refused tRPC save

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_0007A6oQfH5UIqnRzQoohtmc4KPgH' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_0007A6oQfH5UIqnRzQoohtmc4KPgH",
  "name": "Sample and ai_tool",
  "definition": {
    "version": 1,
    "code": "export default function Widget() { const { data } = LW.useChartQuery(\"main\", {}); return <div data-count={String(data?.[0]?.n ?? 0)} style={{ fontSize: 44, color: LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\" }}>{String(data?.[0]?.n ?? \"\")}</div>; }",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "sample",
          "ai_tool"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:44:57.788Z",
  "updatedAt": "2026-10-29T04:44:57.788Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 36,
  "colSpan": 4,
  "rowSpan": 3
}
```

### CLI version

```
$ LANGWATCH_API_KEY=<redacted> LANGWATCH_ENDPOINT=https://drew-sweatshop.tailf32ef6.ts.net:6571 langwatch --version
2.0.0
(exit 0)
```

### CLI help: widget add

```
$ LANGWATCH_API_KEY=<redacted> LANGWATCH_ENDPOINT=https://drew-sweatshop.tailf32ef6.ts.net:6571 langwatch dashboard widget add --help
Usage: langwatch dashboard widget add [options] <dashboardId>

Add a widget to a dashboard from a React source file and its queries

Options:
  --name <name>                Widget name
  --description <description>  What the widget shows
  --code <code>                The widget's React source
  --code-file <path>           Read the widget's React source from a file
  --queries-file <path>        JSON file: an array of { name, sql, parameters?,
                               sources? }
  --sources <list>             Comma list of the trace origins every query
                               counts: application, simulation, evaluation,
                               coding_agent, gateway, workflow, playground,
                               langy, other
  -f, --format <format>        Output format: table (default) or json (default:
                               "table")
  --project <idOrSlug>         Project to run against, by id or slug (default:
                               your personal project). Needs a login that
                               reaches it; `langwatch projects list` shows which
                               ones do
  -h, --help                   display help for command

Global Options:
  -v, --version                Display the current version
  -o, --output <format>        Output format: table (default), json, agents
                               (compact single-line JSON), or yaml (choices:
                               "table", "json", "agents", "yaml")
  --json <fields>              Emit JSON with only the given comma-separated
                               fields
  --jq <expr>                  Filter output with a path expression (e.g.
                               .traces[].traceId, .traces[0], length)
  --agent                      Agent mode: compact JSON output, no colour, no
                               spinners (auto-detected from agent env vars)
(exit 0)
```

### CLI add with --sources application,langy (AC200j)

```
$ LANGWATCH_API_KEY=<redacted> LANGWATCH_ENDPOINT=https://drew-sweatshop.tailf32ef6.ts.net:6571 langwatch dashboard widget add dashboard_000740XtZVhsNY6XXC2u1KZYfryVc --name CLI\ widget --code-file w.tsx --queries-file q.json --sources application\,langy -f json
Using API key for project "Personal Workspace". Switch: langwatch login --project | --device
{
  "id": "widget_0007BErUUrPvzbt6IRG3nU9hI2iUU",
  "name": "CLI widget",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application",
          "langy"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:47:12.306Z",
  "updatedAt": "2026-10-29T04:47:12.306Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 39,
  "colSpan": 4,
  "rowSpan": 3
}
(exit 0)
```

### CLI get: the widget added with --sources (AC200j)

```
$ LANGWATCH_API_KEY=<redacted> LANGWATCH_ENDPOINT=https://drew-sweatshop.tailf32ef6.ts.net:6571 langwatch dashboard widget get dashboard_000740XtZVhsNY6XXC2u1KZYfryVc widget_0007BErUUrPvzbt6IRG3nU9hI2iUU -f json
{
  "id": "widget_0007BErUUrPvzbt6IRG3nU9hI2iUU",
  "name": "CLI widget",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application",
          "langy"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:47:12.306Z",
  "updatedAt": "2026-10-29T04:47:12.306Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 39,
  "colSpan": 4,
  "rowSpan": 3
}
(exit 0)
```

### CLI update --sources langy,simulation (AC200j)

```
$ LANGWATCH_API_KEY=<redacted> LANGWATCH_ENDPOINT=https://drew-sweatshop.tailf32ef6.ts.net:6571 langwatch dashboard widget update dashboard_000740XtZVhsNY6XXC2u1KZYfryVc widget_0007BErUUrPvzbt6IRG3nU9hI2iUU --sources langy\,simulation -f json
{
  "id": "widget_0007BErUUrPvzbt6IRG3nU9hI2iUU",
  "name": "CLI widget",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "langy",
          "simulation"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:47:12.306Z",
  "updatedAt": "2026-10-29T04:47:23.612Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 39,
  "colSpan": 4,
  "rowSpan": 3
}
(exit 0)
```

### CLI add with no --sources and a queries file with no sources (AC200o)

```
$ LANGWATCH_API_KEY=<redacted> LANGWATCH_ENDPOINT=https://drew-sweatshop.tailf32ef6.ts.net:6571 langwatch dashboard widget add dashboard_000740XtZVhsNY6XXC2u1KZYfryVc --name CLI\ widget\,\ default --code-file w.tsx --queries-file q.json -f json
{
  "id": "widget_0007BL5Xap8SlV3FOGH6W4SHZnMjy",
  "name": "CLI widget, default",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:47:24.591Z",
  "updatedAt": "2026-10-29T04:47:24.591Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 42,
  "colSpan": 4,
  "rowSpan": 3
}
(exit 0)
```

### CLI update with an unknown source (AC200n)

```
$ LANGWATCH_API_KEY=<redacted> LANGWATCH_ENDPOINT=https://drew-sweatshop.tailf32ef6.ts.net:6571 langwatch dashboard widget update dashboard_000740XtZVhsNY6XXC2u1KZYfryVc widget_0007BErUUrPvzbt6IRG3nU9hI2iUU --sources application\,bogus -f json
Error: --sources: unknown source "bogus"; pass a comma list of application, simulation, evaluation, sample, coding_agent, ai_tool, gateway, workflow, playground, langy, other
(exit 1)
```

### CLI update --sources with an empty list

```
$ LANGWATCH_API_KEY=<redacted> LANGWATCH_ENDPOINT=https://drew-sweatshop.tailf32ef6.ts.net:6571 langwatch dashboard widget update dashboard_000740XtZVhsNY6XXC2u1KZYfryVc widget_0007BErUUrPvzbt6IRG3nU9hI2iUU --sources '' -f json
Error: --sources: pass a comma list of application, simulation, evaluation, sample, coding_agent, ai_tool, gateway, workflow, playground, langy, other
(exit 1)
```

### CLI add with a queries file naming an unknown source (AC200n)

```
$ LANGWATCH_API_KEY=<redacted> LANGWATCH_ENDPOINT=https://drew-sweatshop.tailf32ef6.ts.net:6571 langwatch dashboard widget add dashboard_000740XtZVhsNY6XXC2u1KZYfryVc --name bad --code-file w.tsx --queries-file qbad.json -f json
{
  "ok": false,
  "error": {
    "code": "validation_error",
    "kind": "validation_error",
    "message": "The request body didn't match the expected shape.",
    "httpStatus": 422,
    "meta": {
      "target": "json",
      "fields": [
        "queries.0.sources.0"
      ],
      "reasons": [
        {
          "code": "schema_failure",
          "message": "Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"",
          "retryable": false,
          "meta": {
            "field": "queries.0.sources.0",
            "type": "invalid_value",
            "message": "Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"",
            "expected": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "langy",
              "other"
            ],
            "received": "bogus"
          }
        }
      ]
    },
    "isHandled": true,
    "retryable": false,
    "traceId": "d284a6edc466cbe4f36d9fcb8266a76a",
    "suggestions": [
      "Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected",
      "Fix those fields and send the request again; retrying it unchanged will fail identically"
    ],
    "terminal": false
  }
}
Failed to create dashboard widget: The request body didn't match the expected shape.
(exit 1)
```

### REST read the widget MCP added with sources [application, langy]

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo",
  "name": "MCP widget",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application",
          "langy"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:47:58.158Z",
  "updatedAt": "2026-10-29T04:47:58.158Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 45,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST read after MCP update_dashboard_widget sources [langy]

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets/widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "id": "widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo",
  "name": "MCP widget",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "langy"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:47:58.158Z",
  "updatedAt": "2026-10-29T04:48:08.398Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
  "gridColumn": 0,
  "gridRow": 45,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST list after a widget was made in the editor with I'll build it myself (AC200o)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc/widgets' -H 'X-Auth-Token: <redacted riley personal key>'

HTTP 200
{
  "data": [
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszK",
      "name": "All traces, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.113Z",
      "updatedAt": "2026-10-29T04:39:21.737Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 0,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CTpAm03WffUIWKP47TqYYszL",
      "name": "All traces, application+langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:11.988Z",
      "updatedAt": "2026-10-29T04:33:11.988Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 3,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074CzzlR8vvKQpiq4zSVAjFNH0b",
      "name": "All traces, langy only",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:12.827Z",
      "updatedAt": "2026-10-29T04:33:12.827Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 6,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074DWAM6HoJzCB99pZqsrbwBf1t",
      "name": "All traces, other",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:13.69Z",
      "updatedAt": "2026-10-29T04:33:13.69Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 9,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074E2KwlQgidxWZTaAFGYUd033A",
      "name": "All traces, every source",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "langy",
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:14.59Z",
      "updatedAt": "2026-10-29T04:33:14.59Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 12,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074EYVXQZZ7IirznKkdeFNJoR4T",
      "name": "Langy turns, sources hold langy",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application",
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:15.487Z",
      "updatedAt": "2026-10-29T04:33:15.487Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 15,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074F4g85iRVxUDQ75L21wG0cp5v",
      "name": "Langy turns, sources not sent",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:16.38Z",
      "updatedAt": "2026-10-29T04:33:16.38Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 18,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00074FaqikrJucFYqQpvQPd8hRD77",
      "name": "All traces, no source picked",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": []
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:33:17.282Z",
      "updatedAt": "2026-10-29T04:33:17.282Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 21,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00075CkK8PBLFZIxEkUqFyThQ5NUA",
      "name": "Legacy widget, stores none (renamed)",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:35:11.357Z",
      "updatedAt": "2026-10-29T04:38:48.871Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 24,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_00078BT8ee9gpd9yM9zoG0hjFPItW",
      "name": "How much work did my agent handle?",
      "definition": {
        "version": 1,
        "code": "// Traces per bucket, with the period total and the busiest and quietest buckets.\nimport { ResponsiveContainer, ComposedChart, CartesianGrid, XAxis, YAxis, Tooltip, Bar, Line } from \"recharts\";\nimport { mergeBuckets } from \"@langwatch/charts\";\n\nconst dark = LW.theme === \"dark\";\nconst C = {\n  text: dark ? \"#f4f4f5\" : \"#18181b\",\n  subtle: dark ? \"#a1a1aa\" : \"#52525b\",\n  faint: dark ? \"#71717a\" : \"#a1a1aa\",\n  border: dark ? \"#27272a\" : \"#e4e4e7\",\n  strong: dark ? \"#3f3f46\" : \"#d4d4d8\",\n  muted: dark ? \"#27272a\" : \"#f4f4f5\",\n  panel: dark ? \"#18181b\" : \"#ffffff\",\n  teal: dark ? \"#2dd4bf\" : \"#0d9488\",\n  orange: \"#ed8926\",\n  pink: \"#ed64a6\",\n  red: dark ? \"#f87171\" : \"#dc2626\",\n  green: dark ? \"#4ade80\" : \"#16a34a\",\n};\n\n// null, undefined, NaN and \"\" stay null: a gap, never 0.\nconst num = (value) =>\n  value === null || value === undefined || value === \"\" || !Number.isFinite(Number(value))\n    ? null\n    : Number(value);\nconst known = (value) => num(value) !== null;\n// The known values summed; null only when none is known.\nconst add = (...values) =>\n  values.some(known) ? values.filter(known).reduce((sum, value) => sum + num(value), 0) : null;\n// A share, or null when the part is unknown or the whole is not above zero.\nconst ratio = (part, whole) => (known(part) && num(whole) > 0 ? num(part) / num(whole) : null);\nconst GAP = \"–\";\nconst compact = new Intl.NumberFormat(\"en-US\", { notation: \"compact\", maximumFractionDigits: 1 });\nconst count = (value) => (known(value) ? compact.format(num(value)) : GAP);\nconst pct = (value, digits = 1) => (known(value) ? (num(value) * 100).toFixed(digits) + \"%\" : GAP);\nfunction usd(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value === 0) return \"$0.00\";\n  const abs = Math.abs(value);\n  const sign = value < 0 ? \"-$\" : \"$\";\n  if (abs < 1000) return sign + abs.toFixed(abs < 0.01 ? 4 : 2);\n  return sign + compact.format(abs);\n}\nfunction ms(raw) {\n  const value = num(raw);\n  if (value === null) return GAP;\n  if (value >= 1000) return (value / 1000).toFixed(value >= 10000 ? 0 : 1) + \"s\";\n  return Math.round(value) + \"ms\";\n}\n\nconst utc = (value) => new Date(String(value).replace(\" \", \"T\") + \"Z\");\nfunction bucketLabel(value) {\n  const daily = LW.dashboardContext.granularitySeconds >= 86400;\n  const parts = daily ? { month: \"short\", day: \"numeric\" } : { day: \"numeric\", hour: \"numeric\" };\n  return utc(value).toLocaleString(\"en-US\", parts);\n}\n\nconst AXIS = { fontSize: 14, fill: dark ? C.faint : \"#666666\" };\nconst TIP = { background: C.panel, border: \"1px solid \" + C.border, borderRadius: 8, fontSize: 12 };\nconst dot = (color) => ({ width: 8, height: 8, borderRadius: 4, background: color });\n\nfunction Legend({ items }) {\n  return (\n    <div style={{ display: \"flex\", gap: 12, marginBottom: 4, fontSize: 10.5, color: C.subtle }}>\n      {items.map(([color, label, dashed]) => (\n        <span key={label} style={{ display: \"flex\", alignItems: \"center\", gap: 6 }}>\n          <span style={dashed ? { width: 12, borderTop: \"2px dashed \" + color } : dot(color)} />\n          {label}\n        </span>\n      ))}\n    </div>\n  );\n}\n\nconst signed = (value) => (known(value) ? (value > 0 ? \"+\" : \"\") + pct(value, 0) : GAP);\n// The change from the first value to the last, as a share of the first; null when unknown.\nconst drift = (first, last) => (known(last) && num(first) > 0 ? (last - first) / first : null);\n\nfunction Headline({ value, label }) {\n  return (\n    <div style={{ display: \"flex\", alignItems: \"baseline\", gap: 8, marginBottom: 8 }}>\n      <span style={{ fontSize: 22, fontWeight: 600 }}>{value}</span>\n      <span style={{ fontSize: 11, color: C.subtle }}>{label}</span>\n    </div>\n  );\n}\n\n// series: keys, or { key, kind: \"count\" } for a count, whose empty bucket is a real 0.\nfunction withBuckets(query, series, rows = query.data) {\n  const buckets = query.completeness?.buckets || [];\n  const starts = new Set(buckets.map((bucket) => Date.parse(bucket.start)));\n  const aligned = buckets.length > 0 && rows.every((row) => starts.has(utc(row.bucket).getTime()));\n  if (!aligned) return [...rows];\n  return mergeBuckets({ rows, buckets, x: \"bucket\", series });\n}\n// \"Lately\" is the last bucket with a value: an empty one never stands in for it.\nconst latest = (points, key) =>\n  [...points].reverse().find((point) => known(point[key]))?.[key] ?? null;\nconst earliest = (points, key) => points.find((point) => known(point[key]))?.[key] ?? null;\n\nfunction bridge({ key, colour, yAxisId }) {\n  return (\n    <Line key={key + \"-bridge\"} yAxisId={yAxisId} type=\"monotone\" dataKey={key} stroke={colour}\n      strokeOpacity={0.4} strokeWidth={1} strokeDasharray=\"2 3\" dot={false} connectNulls\n      legendType=\"none\" tooltipType=\"none\" isAnimationActive={false} />\n  );\n}\n// An empty bucket of a measure has no value: the hover says so instead of showing 0.\nconst tipValue = (format) => (value, name) => [known(value) ? format(value) : \"No data\", name];\n\n// series: { key, label, colour, dashed?, bars? }; format labels the axis and the tooltip.\nfunction SeriesChart({ points, series, format, domain }) {\n  const legend = series.map((item) => [item.colour, item.label, item.dashed]);\n  return (\n    <div style={{ flex: 1, minHeight: 0, display: \"flex\", flexDirection: \"column\" }}>\n      <Legend items={legend} />\n      <div style={{ flex: 1, minHeight: 0 }}>\n        <ResponsiveContainer width=\"100%\" height=\"100%\">\n          <ComposedChart data={points} margin={{ top: 6, right: 4, bottom: 0, left: 0 }}>\n            <CartesianGrid vertical={false} stroke={C.border} />\n            <XAxis dataKey=\"x\" tick={AXIS} tickLine={false} axisLine={false} minTickGap={28}\n              dy={4} />\n            <YAxis tick={AXIS} tickLine={false} axisLine={false} width={48} domain={domain}\n              tickFormatter={format} />\n            <Tooltip contentStyle={TIP} formatter={tipValue(format)} filterNull={false} />\n            {series.filter((item) => !item.bars).map(bridge)}\n            {series.map((item) => item.bars ? (\n              <Bar key={item.key} dataKey={item.key} name={item.label} fill={item.colour}\n                radius={[2, 2, 0, 0]} isAnimationActive={false} />\n            ) : (\n              <Line key={item.key} type=\"monotone\" dataKey={item.key} name={item.label}\n                stroke={item.colour} strokeWidth={2} dot={false} isAnimationActive={false}\n                strokeDasharray={item.dashed ? \"4 3\" : undefined} />\n            ))}\n          </ComposedChart>\n        </ResponsiveContainer>\n      </div>\n    </div>\n  );\n}\n\nconst CENTRED = { display: \"flex\", flexDirection: \"column\", alignItems: \"center\",\n  justifyContent: \"center\" };\nconst FRAME_CSS = '@import url(\"https://fonts.googleapis.com/css2?family=Inter:wght@400..700' +\n  '&display=swap\"); body { padding: 6px 8px 8px; } ' + \".lw-row { display: none; }\\n@media (max-height: 219px) { .lw-icon { display: none !important; } }\\n@media (max-height: 179px) {\\n  .lw-full { display: none !important; }\\n  .lw-row { display: flex !important; }\\n  .lw-setup { padding: 8px 12px !important; }\\n}\";\n\nfunction Panel({ children }) {\n  return (\n    <div style={{ height: \"100%\", display: \"flex\", flexDirection: \"column\", color: C.text,\n      fontFamily: \"Inter, system-ui, sans-serif\", fontSize: 13, lineHeight: 1.5 }}>\n      <style>{FRAME_CSS}</style>\n      {children}\n    </div>\n  );\n}\n\nfunction Note({ children, color = C.faint }) {\n  return <div style={{ flex: 1, ...CENTRED, fontSize: 11.5, color }}>{children}</div>;\n}\n\nconst BUTTON = {\n  flexShrink: 0,\n  height: 28,\n  padding: \"0 10px\",\n  border: 0,\n  borderRadius: 8,\n  background: C.teal,\n  color: \"#ffffff\",\n  fontFamily: \"inherit\",\n  fontSize: 12,\n  fontWeight: 500,\n  whiteSpace: \"nowrap\",\n  cursor: \"pointer\",\n};\nconst DASHED = { border: \"1px dashed \" + C.strong, borderRadius: 8, background: C.muted + \"4d\" };\nconst CTA_CLIP = { overflow: \"hidden\", textOverflow: \"ellipsis\", whiteSpace: \"nowrap\" };\n\nfunction CallToAction() {\n  const present = LW.useChartQuery(\"present\", {});\n  if (present.isError) return <Note color={C.red}>{present.error.message}</Note>;\n  if (!present.data) return <Note>Loading</Note>;\n  if (present.data.length > 0) return <Note>No traces in this period.</Note>;\n  return (\n    <div style={{ flex: 1, minHeight: 0, display: \"flex\", flexDirection: \"column\" }}>\n      <div className=\"lw-full\" style={{ ...DASHED, flex: 1, ...CENTRED, gap: 8,\n        padding: \"24px 20px\", textAlign: \"center\" }}>\n        <div className=\"lw-icon\"\n        style={{ ...CENTRED, flexShrink: 0, width: 36, height: 36, borderRadius: 8,\n        background: C.muted }}>\n        <svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke={C.teal}\n          strokeWidth=\"1.8\" strokeLinecap=\"round\" strokeLinejoin=\"round\">\n          <path d=\"M8 5h13M13 12h8M13 19h8M3 10a2 2 0 0 0 2 2h3M3 5v12a2 2 0 0 0 2 2h3\" />\n        </svg>\n      </div>\n        <div style={{ fontSize: 13, fontWeight: 600 }}>Connect traces to continue</div>\n        <div style={{ fontSize: 11.5, color: C.subtle, maxWidth: 320 }}>\n          Send your agent's traces to LangWatch and this panel fills with its own traffic, errors and latency.\n        </div>\n        <div style={{ marginTop: 4 }}>\n          <button style={BUTTON} onClick={() => LW.navigate(\"traces\", {})}>\n        Connect traces\n      </button>\n        </div>\n      </div>\n      <div className=\"lw-row\"\n      style={{ ...DASHED, alignItems: \"center\", gap: 12,\n      padding: \"12px 16px\" }}>\n      <div\n        style={{ ...CENTRED, flexShrink: 0, width: 36, height: 36, borderRadius: 8,\n        background: C.muted }}>\n        <svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke={C.teal}\n          strokeWidth=\"1.8\" strokeLinecap=\"round\" strokeLinejoin=\"round\">\n          <path d=\"M8 5h13M13 12h8M13 19h8M3 10a2 2 0 0 0 2 2h3M3 5v12a2 2 0 0 0 2 2h3\" />\n        </svg>\n      </div>\n      <div style={{ flex: 1, minWidth: 0 }}>\n        <div style={{ fontSize: 13, fontWeight: 600, ...CTA_CLIP }}>Connect traces to continue</div>\n        <div style={{ fontSize: 11.5, color: C.subtle, ...CTA_CLIP }}>Send your agent's traces to LangWatch and this panel fills with its own traffic, errors and latency.</div>\n      </div>\n      <button style={BUTTON} onClick={() => LW.navigate(\"traces\", {})}>\n        Connect traces\n      </button>\n    </div>\n    </div>\n  );\n}\n\nexport default function Widget() {\n  const main = LW.useChartQuery(\"main\", {});\n  const failed = [main].find((query) => query.isError);\n  if (failed) return <Panel><Note color={C.red}>{failed.error.message}</Note></Panel>;\n  if (!main.data) return <Panel><Note>Loading</Note></Panel>;\n  if (main.data.length === 0) return <Panel><CallToAction /></Panel>;\n  const points = withBuckets(main, [{ key: \"traces\", kind: \"count\" }])\n    .map((row) => ({ x: bucketLabel(row.bucket), traces: num(row.traces) }));\n  const total = points.reduce((sum, point) => sum + point.traces, 0);\n  const busiest = points.toSorted((a, b) => b.traces - a.traces)[0];\n  const label = \"traces · busiest \" + busiest.x + \" (\" + count(busiest.traces) + \")\";\n  return (\n    <Panel>\n      <Headline value={count(total)} label={label} />\n      <SeriesChart points={points} format={count}\n        series={[{ key: \"traces\", label: \"traces\", colour: C.orange, bars: true }]} />\n    </Panel>\n  );\n}\n",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT addSeconds(toStartOfInterval(subtractSeconds(OccurredAt, 345600), INTERVAL {dashboard_context_granularity_seconds:UInt32} SECOND), 345600) AS bucket, uniqExact(TraceId) AS traces\nFROM trace_metrics\nWHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}\nGROUP BY bucket\nORDER BY bucket",
            "parameters": [],
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "other"
            ]
          },
          {
            "name": "present",
            "sql": "SELECT 1 AS present\nFROM trace_metrics\nWHERE OccurredAt >= subtractDays(now(), 90)\nLIMIT 1",
            "parameters": [],
            "sources": [
              "application",
              "simulation",
              "evaluation",
              "sample",
              "coding_agent",
              "ai_tool",
              "gateway",
              "workflow",
              "playground",
              "other"
            ]
          }
        ],
        "description": "Every trace that arrived, interval by interval. An interval with no traces reads 0\n\nTraces per bucket, with the period total and the busiest and quietest buckets.",
        "prompt": "How much work did my agent handle? Query the LangWatchQL view trace_metrics over the dashboard period, bucketed at the dashboard grain: count traces with uniqExact(TraceId) per bucket of OccurredAt. Answer with the total for the period, the busiest and the quietest bucket with their counts, and a short series of traces per bucket. Quote the real numbers from the query result. If a query returns no rows, say plainly that there is no data for the dashboard period rather than guessing.",
        "source": {
          "kind": "catalogue",
          "catalogueId": "traffic"
        }
      },
      "createdAt": "2026-10-29T04:41:07.882Z",
      "updatedAt": "2026-10-29T04:41:07.969Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 27,
      "colSpan": 8,
      "rowSpan": 6
    },
    {
      "id": "widget_00079uMKTLeQl4T9nmmjGjBRUp7BJ",
      "name": "Two queries, different sources",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const a = LW.useChartQuery(\"mine\", {});\n  const b = LW.useChartQuery(\"langys\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (a.isError || b.isError) return <div style={{ color: \"#dc2626\" }}>{(a.error || b.error).message}</div>;\n  if (!a.data || !b.data) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={a.data[0].n + \"/\" + b.data[0].n} style={{ color: fg, fontSize: 28 }}>mine {String(a.data[0].n)} · langy {String(b.data[0].n)}</div>;\n}",
        "queries": [
          {
            "name": "mine",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          },
          {
            "name": "langys",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "langy",
              "other"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:44:33.558Z",
      "updatedAt": "2026-10-29T04:44:56.891Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 33,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_0007A6oQfH5UIqnRzQoohtmc4KPgH",
      "name": "Sample and ai_tool",
      "definition": {
        "version": 1,
        "code": "export default function Widget() { const { data } = LW.useChartQuery(\"main\", {}); return <div data-count={String(data?.[0]?.n ?? 0)} style={{ fontSize: 44, color: LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\" }}>{String(data?.[0]?.n ?? \"\")}</div>; }",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "sample",
              "ai_tool"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:44:57.788Z",
      "updatedAt": "2026-10-29T04:44:57.788Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 36,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_0007BErUUrPvzbt6IRG3nU9hI2iUU",
      "name": "CLI widget",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "langy",
              "simulation"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:47:12.306Z",
      "updatedAt": "2026-10-29T04:47:23.612Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 39,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_0007BL5Xap8SlV3FOGH6W4SHZnMjy",
      "name": "CLI widget, default",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:47:24.591Z",
      "updatedAt": "2026-10-29T04:47:24.591Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 42,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo",
      "name": "MCP widget",
      "definition": {
        "version": 1,
        "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
            "sources": [
              "langy"
            ]
          }
        ],
        "source": {
          "kind": "api"
        }
      },
      "createdAt": "2026-10-29T04:47:58.158Z",
      "updatedAt": "2026-10-29T04:48:08.398Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 45,
      "colSpan": 4,
      "rowSpan": 3
    },
    {
      "id": "widget_0007BwRqAbRdOq27xCNMpaFnIJGEr",
      "name": "New widget",
      "definition": {
        "version": 1,
        "code": "import { Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from \"recharts\";\n\nexport default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n\n  const status = isError\n    ? error.message\n    : isLoading\n      ? \"Loading...\"\n      : data.length + \" rows\";\n\n  const rows = (data || []).map(function (row) {\n    return { bucket: String(row.bucket).slice(5, 16), events: Number(row.events) };\n  });\n\n  return (\n    <div style={{ height: \"100%\", display: \"flex\", flexDirection: \"column\" }}>\n      <div style={{ fontSize: \"11px\", color: \"var(--chakra-colors-fg-subtle)\", marginBottom: 4, flexShrink: 0 }}>{status}</div>\n      <div style={{ flex: 1, minHeight: 0 }}>\n        <ResponsiveContainer width=\"100%\" height=\"100%\">\n          <BarChart data={rows} margin={{ top: 6, right: 8, bottom: 0, left: 0 }}>\n            <CartesianGrid strokeDasharray=\"3 3\" vertical={false} />\n            <XAxis dataKey=\"bucket\" axisLine={false} tickLine={false} tick={{ fontSize: 10 }} />\n            <YAxis allowDecimals={false} axisLine={false} tickLine={false} width={48} tick={{ fontSize: 11 }} />\n            <Tooltip />\n            <Bar dataKey=\"events\" fill=\"var(--chakra-colors-chart-1)\" />\n          </BarChart>\n        </ResponsiveContainer>\n      </div>\n    </div>\n  );\n}\n",
        "queries": [
          {
            "name": "main",
            "sql": "SELECT toStartOfInterval(OccurredAt, INTERVAL {dashboard_context_granularity_seconds:UInt32} SECOND) AS bucket,\n  count() AS events\nFROM traces\nWHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}\nGROUP BY bucket\nORDER BY bucket",
            "sources": [
              "application"
            ]
          }
        ],
        "source": {
          "kind": "code"
        }
      },
      "createdAt": "2026-10-29T04:48:36.407Z",
      "updatedAt": "2026-10-29T04:48:36.527Z",
      "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/personal-r3nzcioaw0ly-c1pgqr/dashboards/dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "dashboardId": "dashboard_000740XtZVhsNY6XXC2u1KZYfryVc",
      "gridColumn": 0,
      "gridRow": 48,
      "colSpan": 4,
      "rowSpan": 5
    }
  ]
}
```

### REST create a board in the team project Team Proof

```
$ curl -sS -X POST 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards' -H 'X-Auth-Token: <redacted riley Team Proof key>' -H 'Content-Type: application/json' --data '{"name":"Team sources proof"}'

HTTP 201
{
  "id": "dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "name": "Team sources proof",
  "description": null,
  "scope": "PROJECT",
  "createdById": "r3nZciOaw0Ly_lVN_kbvR",
  "createdAt": "2026-10-29T04:55:46.746Z",
  "updatedAt": "2026-10-29T04:55:46.746Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/team-proof-7OaCeg/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh"
}
```

### REST create in Team Proof: Team: all traces, default

```
$ curl -sS -X POST 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh/widgets' -H 'X-Auth-Token: <redacted riley Team Proof key>' -H 'Content-Type: application/json' --data '{"name":"Team: all traces, default","code":"export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}","queries":[{"name":"main","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"}]}'

HTTP 201
{
  "id": "widget_0007FdHAxFaYmmnW9gkEG6Gnoi7Pu",
  "name": "Team: all traces, default",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:55:57.209Z",
  "updatedAt": "2026-10-29T04:55:57.209Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/team-proof-7OaCeg/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "dashboardId": "dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "gridColumn": 0,
  "gridRow": 0,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST create in Team Proof: Team: all traces, application+langy

```
$ curl -sS -X POST 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh/widgets' -H 'X-Auth-Token: <redacted riley Team Proof key>' -H 'Content-Type: application/json' --data '{"name":"Team: all traces, application+langy","code":"export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}","queries":[{"name":"main","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","sources":["application","langy"]}]}'

HTTP 201
{
  "id": "widget_0007FdnLXujRBRYra0UoeTxgVWVRA",
  "name": "Team: all traces, application+langy",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application",
          "langy"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:55:58.066Z",
  "updatedAt": "2026-10-29T04:55:58.066Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/team-proof-7OaCeg/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "dashboardId": "dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "gridColumn": 0,
  "gridRow": 3,
  "colSpan": 4,
  "rowSpan": 3
}
```

### REST create in Team Proof: Team: Langy turns, legacy none

```
$ curl -sS -X POST 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh/widgets' -H 'X-Auth-Token: <redacted riley Team Proof key>' -H 'Content-Type: application/json' --data '{"name":"Team: Langy turns, legacy none","code":"export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}","queries":[{"name":"main","sql":"SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}"}]}'

HTTP 201
{
  "id": "widget_0007FeJW8ZsJa6KD0KFP2reZCKtSS",
  "name": "Team: Langy turns, legacy none",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:55:59.051Z",
  "updatedAt": "2026-10-29T04:55:59.051Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/team-proof-7OaCeg/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "dashboardId": "dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "gridColumn": 0,
  "gridRow": 6,
  "colSpan": 4,
  "rowSpan": 3
}
```

### Setup (store): strip sources from widget_0007FeJW8ZsJa6KD0KFP2reZCKtSS (Team Proof) to make a pre-sources widget in a non-personal project

```
-> has_sources: false
```

### Viewer key: REST read the widget (AC200d: reads its sources)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh/widgets/widget_0007FdHAxFaYmmnW9gkEG6Gnoi7Pu' -H 'X-Auth-Token: <redacted viewer (Lite Member) key, Analytics Read, Team Proof>'

HTTP 200
{
  "id": "widget_0007FdHAxFaYmmnW9gkEG6Gnoi7Pu",
  "name": "Team: all traces, default",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:55:57.209Z",
  "updatedAt": "2026-10-29T04:55:57.209Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/team-proof-7OaCeg/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "dashboardId": "dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "gridColumn": 0,
  "gridRow": 0,
  "colSpan": 4,
  "rowSpan": 3
}
```

### Viewer key: REST PATCH with sources (AC200d): refused

```
$ curl -sS -X PATCH 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh/widgets/widget_0007FdHAxFaYmmnW9gkEG6Gnoi7Pu' -H 'X-Auth-Token: <redacted viewer (Lite Member) key, Analytics Read, Team Proof>' -H 'Content-Type: application/json' --data '{"queries":[{"name":"main","sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","sources":["application","langy"]}]}'

HTTP 403
{
  "type": "permission_denied",
  "code": "api_key_permission_denied",
  "message": "API Key does not grant required permission: analytics:update",
  "retryable": false,
  "meta": {
    "permission": "analytics:update"
  },
  "trace_id": "2281cfd1c1521b4ed78c886850223a8d",
  "span_id": "8efc729844aa2668",
  "trace": {
    "traceId": "2281cfd1c1521b4ed78c886850223a8d",
    "spanId": "8efc729844aa2668"
  },
  "tips": [
    "Re-create the API key with the required scope, or ask an admin to raise your role"
  ],
  "docs_url": "https://docs.langwatch.ai/api-reference/api-keys/create-api-key",
  "fault": "customer"
}
```

### Owner key: REST read after the refused PATCH (unchanged)

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh/widgets/widget_0007FdHAxFaYmmnW9gkEG6Gnoi7Pu' -H 'X-Auth-Token: <redacted riley Team Proof key>'

HTTP 200
{
  "id": "widget_0007FdHAxFaYmmnW9gkEG6Gnoi7Pu",
  "name": "Team: all traces, default",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:55:57.209Z",
  "updatedAt": "2026-10-29T04:55:57.209Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/team-proof-7OaCeg/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "dashboardId": "dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "gridColumn": 0,
  "gridRow": 0,
  "colSpan": 4,
  "rowSpan": 3
}
```

### Owner key: REST read after the viewer's refused tRPC update

```
$ curl -sS -X GET 'https://drew-sweatshop.tailf32ef6.ts.net:6571/api/v1/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh/widgets/widget_0007FdHAxFaYmmnW9gkEG6Gnoi7Pu' -H 'X-Auth-Token: <redacted riley Team Proof key>'

HTTP 200
{
  "id": "widget_0007FdHAxFaYmmnW9gkEG6Gnoi7Pu",
  "name": "Team: all traces, default",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data, isLoading, isError, error } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  if (isError) return <div style={{ color: \"#dc2626\", fontSize: 12 }}>{error.message}</div>;\n  if (isLoading || data === null) return <div style={{ color: fg }}>Loading</div>;\n  return <div data-count={String(data[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data[0]?.n ?? 0)}<span style={{ fontSize: 14, fontWeight: 400 }}> traces</span></div>;\n}",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}",
        "sources": [
          "application"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T04:55:57.209Z",
  "updatedAt": "2026-10-29T04:55:57.209Z",
  "platformUrl": "https://drew-sweatshop.tailf32ef6.ts.net:6571/team-proof-7OaCeg/dashboards/dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "dashboardId": "dashboard_0007FXZIRx0uPYOiUBTlvtf6DlrBh",
  "gridColumn": 0,
  "gridRow": 0,
  "colSpan": 4,
  "rowSpan": 3
}
```

### Ground truth straight from ClickHouse (shots9137), personal project, after both seeds

```
trace_analytics by Origin (empty = unstamped):
ai_tool	1
application	12
brand_new_origin	2
coding_agent	1
evaluation	3
gateway	1
langy	8
playground	1
sample	1
simulation	5
workflow	1
langy.turn traces: 6 (SourceType of every OTLP trace here: ['gateway'])
```

### tRPC LangWatchQL door (signed-in riley session, POST /api/trpc/analytics.lwql.query; the body is the one the board itself sent, with only sources/sql changed). Personal project, 30d window, before the evaluation seed

```
captured url: /api/trpc/analytics.lwql.query
captured body: {"sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","parameters":{},"granularitySeconds":86400,"sources":["application"],"timeWindow":{"start":"2026-09-29T04:43:00.000Z","end":"2026-10-29T04:43:00.000Z"},"projectId":"project_0008MjBX62ihhQD8K7fxm1wOVWbhL"}

### tRPC LWQL door, unknown source (AC200n)
POST /api/trpc/analytics.lwql.query sources=["bogus"]
-> 400 {"error":{"message":"validation_error","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,"path":"analytics.lwql.query","cause":null,"error":{"code":"validation_error","kind":"validation_error","meta":{"fieldErrors":{"sources":["Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\""]},"formErrors":[]},"httpStatus":422,"fault":"customer","retryable":false,"reasons":[]},"authored":false}}}

### tRPC LWQL door, langy turns with application+langy (AC201)
POST /api/trpc/analytics.lwql.query sources=["application","langy"] sql=SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":3}],

### tRPC LWQL door, langy turns with the default (null) (AC201b)
POST /api/trpc/analytics.lwql.query sources=null sql=SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":0}],

### tRPC LWQL door, langy turns with application (AC201b)
POST /api/trpc/analytics.lwql.query sources=["application"] sql=SELECT count() AS n FROM traces WHERE TraceName = 'langy.turn' AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":0}],
captured url: /api/trpc/analytics.lwql.query
captured body: {"sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","parameters":{},"granularitySeconds":86400,"sources":["application"],"timeWindow":{"start":"2026-09-29T04:44:00.000Z","end":"2026-10-29T04:44:00.000Z"},"projectId":"project_0008MjBX62ihhQD8K7fxm1wOVWbhL"}

### AC190 spans, sources application
POST /api/trpc/analytics.lwql.query sources=["application"] sql=SELECT count() AS spans, uniqExact(TraceId) AS traces FROM spans
-> 200 {"result":{"data":{"columns":[{"name":"spans","type":"UInt64"},{"name":"traces","type":"UInt64"}],"rows":[{"spans":10,"traces":10}],

### AC190 spans, every source but langy
POST /api/trpc/analytics.lwql.query sources=["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","other"] sql=SELECT count() AS spans, uniqExact(TraceId) AS traces FROM spans
-> 200 {"result":{"data":{"columns":[{"name":"spans","type":"UInt64"},{"name":"traces","type":"UInt64"}],"rows":[{"spans":26,"traces":26}],

### AC190/AC193 spans, every source
POST /api/trpc/analytics.lwql.query sources=["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"] sql=SELECT count() AS spans, uniqExact(TraceId) AS traces FROM spans
-> 200 {"result":{"data":{"columns":[{"name":"spans","type":"UInt64"},{"name":"traces","type":"UInt64"}],"rows":[{"spans":31,"traces":31}],

### AC193 traces, every source
POST /api/trpc/analytics.lwql.query sources=["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"] sql=SELECT count() AS n, countIf(TraceName = 'langy.turn') AS langy_turns FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"},{"name":"langy_turns","type":"UInt64"}],"rows":[{"n":31,"langy_turns":3}],

### AC191 own origin filter, every source
POST /api/trpc/analytics.lwql.query sources=["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"] sql=SELECT count() AS n FROM trace_metrics WHERE Origin IN ('', 'application') AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":10}],

### AC191 own origin filter, every source but langy
POST /api/trpc/analytics.lwql.query sources=["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","other"] sql=SELECT count() AS n FROM trace_metrics WHERE Origin IN ('', 'application') AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":10}],

### AC191 own origin filter, sources application
POST /api/trpc/analytics.lwql.query sources=["application"] sql=SELECT count() AS n FROM trace_metrics WHERE Origin IN ('', 'application') AND OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":10}],

### AC192 langy_usage_events, sources application
POST /api/trpc/analytics.lwql.query sources=["application"] sql=SELECT count() AS n FROM langy_usage_events
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":3}],

### AC192 langy_conversation_messages, sources application
POST /api/trpc/analytics.lwql.query sources=["application"] sql=SELECT count() AS n FROM langy_conversation_messages
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":2}],

### AC195 trace_metrics_by_minute, sources application
POST /api/trpc/analytics.lwql.query sources=["application"] sql=SELECT count() AS n FROM trace_metrics_by_minute
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":25}],

### AC195 trace_metrics_by_minute, every source
POST /api/trpc/analytics.lwql.query sources=["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"] sql=SELECT count() AS n FROM trace_metrics_by_minute
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":25}],

### AC195 model_usage_by_minute, sources application
POST /api/trpc/analytics.lwql.query sources=["application"] sql=SELECT count() AS n FROM model_usage_by_minute
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":31}],

### AC195 model_usage_by_minute, every source
POST /api/trpc/analytics.lwql.query sources=["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"] sql=SELECT count() AS n FROM model_usage_by_minute
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":31}],

### AC200l traces, sources other
POST /api/trpc/analytics.lwql.query sources=["other"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":2}],

### AC200l traces, sources application
POST /api/trpc/analytics.lwql.query sources=["application"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":10}],

### AC200l traces, sources sample
POST /api/trpc/analytics.lwql.query sources=["sample"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":1}],

### AC200l traces, sources ai_tool
POST /api/trpc/analytics.lwql.query sources=["ai_tool"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":1}],

### AC200l traces, sources simulation
POST /api/trpc/analytics.lwql.query sources=["simulation"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":5}],

### AC200l traces, sources evaluation
POST /api/trpc/analytics.lwql.query sources=["evaluation"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":3}],

### AC200l traces, sources coding_agent
POST /api/trpc/analytics.lwql.query sources=["coding_agent"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":1}],

### AC200l traces, sources gateway
POST /api/trpc/analytics.lwql.query sources=["gateway"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":1}],

### AC200l traces, sources workflow
POST /api/trpc/analytics.lwql.query sources=["workflow"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":1}],

### AC200l traces, sources playground
POST /api/trpc/analytics.lwql.query sources=["playground"] sql=SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}
-> 200 {"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":1}],
```

### tRPC LangWatchQL door, evaluations (after the evaluation seed: 2 unstamped traces + 3 langy traces, one langwatch.evaluation.custom each)

```
200 origin=<missing> trace=f97702e692f97ce9908ea0b49f546446 with one langwatch.evaluation.custom event
200 origin=<missing> trace=eb7d437a7a798ed56c801ed8c5a393c2 with one langwatch.evaluation.custom event
200 origin=langy trace=a4a1ef3aa6b0b957a0d8960df7bb4fa1 with one langwatch.evaluation.custom event
200 origin=langy trace=d3ed4b3f9c96b38941a584dbee6d9aaa with one langwatch.evaluation.custom event
200 origin=langy trace=cf7cc295670116ac5356cd6b3d96932b with one langwatch.evaluation.custom event
captured url: /api/trpc/analytics.lwql.query
captured body: {"sql":"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}","parameters":{},"granularitySeconds":86400,"sources":["application"],"timeWindow":{"start":"2026-09-29T04:45:00.000Z","end":"2026-10-29T04:45:00.000Z"},"projectId":"project_0008MjBX62ihhQD8K7fxm1wOVWbhL"}

### AC190 evaluations, sources application
POST /api/trpc/analytics.lwql.query sources=["application"] sql=SELECT count() AS evals, uniqExact(TraceId) AS traces FROM evaluations
-> 200 {"result":{"data":{"columns":[{"name":"evals","type":"UInt64"},{"name":"traces","type":"UInt64"}],"rows":[{"evals":2,"traces":2}],

### AC190 evaluations, every source
POST /api/trpc/analytics.lwql.query sources=["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"] sql=SELECT count() AS evals, uniqExact(TraceId) AS traces FROM evaluations
-> 200 {"result":{"data":{"columns":[{"name":"evals","type":"UInt64"},{"name":"traces","type":"UInt64"}],"rows":[{"evals":5,"traces":5}],

### AC190 evaluations, sources langy
POST /api/trpc/analytics.lwql.query sources=["langy"] sql=SELECT count() AS evals FROM evaluations
-> 200 {"result":{"data":{"columns":[{"name":"evals","type":"UInt64"}],"rows":[{"evals":3}],
```

### MCP (built @langwatch/mcp-server at a6a2e809 over stdio, MCP SDK client, LANGWATCH_API_KEY=<redacted riley personal key>)

```
tool: add_dashboard_widget sources schema: {"description":"The trace origins every query of the widget counts: any of application, simulation, evaluation, sample, coding_agent, ai_tool, gateway, workflow, playground, langy, other (other = any origin not listed). A new widget counts [\"application\"]; add \"langy\" to count your own conversat
tool: update_dashboard_widget sources schema: {"description":"The trace origins every query of the widget counts: any of application, simulation, evaluation, sample, coding_agent, ai_tool, gateway, workflow, playground, langy, other (other = any origin not listed). A new widget counts [\"application\"]; add \"langy\" to count your own conversat
tool: list_dashboard_widgets sources schema: null
tool: delete_dashboard_widget sources schema: null

### MCP add_dashboard_widget {"dashboardId":"dashboard_000740XtZVhsNY6XXC2u1KZYfryVc","name":"MCP widget","code":"export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ 
{"content":[{"type":"text","text":"Widget \"MCP widget\" created and added to dashboard \"dashboard_000740XtZVhsNY6XXC2u1KZYfryVc\".\n**Widget ID**: widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo\n**Queries**: main"}]}

### MCP add_dashboard_widget {"dashboardId":"dashboard_000740XtZVhsNY6XXC2u1KZYfryVc","name":"MCP bad","code":"export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ col
{"content":[{"type":"text","text":"MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\" at sources[0]"}],"isError":true}

### MCP update_dashboard_widget {"dashboardId":"dashboard_000740XtZVhsNY6XXC2u1KZYfryVc","widgetId":"widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo","sources":["langy"]}
{"content":[{"type":"text","text":"Widget \"MCP widget\" updated on dashboard \"dashboard_000740XtZVhsNY6XXC2u1KZYfryVc\".\n**Widget ID**: widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo\n**Queries**: main\n\n```json\n{\n  \"id\": \"widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo\",\n  \"name\": \"MCP widget\",\n  \"definition\": {\n    \"version\": 1,\n    \"code\": \"export default function Widget() {\\n  const { data } = LW.useChartQuery(\\\"main\\\", {});\\n  const fg = LW.theme === \\\"dark\\\" ? \\\"#f4f4f5\\\" : \\\"#18181b\\\";\\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \\\"\\\")}<span style={{ fontSize: 14 }}> traces</span></div>;\\n}\",\n    \"queries\": [\n      {\n        \"name\": \"main\",\n        \"sql\": \"SELECT count() AS n FROM traces WHERE OccurredAt >= {dashboard_context_period_start:DateTime} AND OccurredAt < {dashboard_context_period_end:DateTime}\",\n        \"sources\": [\n          \"langy\"\n        ]\n      }\n    ],\n    \"source\": {\n      \"kind\": \"api\"\n    }\n  },\n  \"createdAt\": \"2026-10-29T04:47:58.158Z\",\n  \"updatedAt\": \"2026-10-29T04:48:08.398Z\",\n  \"platformUrl\": 

### MCP update_dashboard_widget {"dashboardId":"dashboard_000740XtZVhsNY6XXC2u1KZYfryVc","widgetId":"widget_0007BcjLhO0IHr0zp5p3t3yH3QXRo","sources":["Langy"]}
{"content":[{"type":"text","text":"MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\" at sources[0]"}],"isError":true}
```

### OTLP seed (POST /api/otel/v1/traces, riley personal key)

```
200 origin=<missing> name=proof-app-unstamped trace=8496024cedc372104f432e33e5721575
200 origin=<missing> name=proof-app-unstamped trace=955ba52f26cf83a24d595f391637f990
200 origin=<missing> name=proof-app-unstamped trace=855af28e70638727b4873ecc902789b5
200 origin=<missing> name=proof-app-unstamped trace=161399d112c07ebab8439815f1889f64
200 origin="" name=proof-app-empty trace=d664c0c4d4e749482c737cf118d931c4
200 origin="application" name=proof-app-stamped trace=97994c673994037a9a04c86683e37102
200 origin="application" name=proof-app-stamped trace=6773f89943bdcb9e05dfbd26c8258200
200 origin="langy" name=langy.turn trace=619628aff50d7c8578a5d9178251efc7
200 origin="langy" name=langy.turn trace=e27c14a06adda969477ae36343a8c152
200 origin="langy" name=langy.turn trace=5c7a90f6b69c92f6d0b72b66ebb9998d
200 origin="evaluation" name=proof-evaluation trace=e1baf260355c79b13bdaa5a35695ecc2
200 origin="evaluation" name=proof-evaluation trace=4c78ffc6c660029943a5d4f95749cd8b
200 origin="simulation" name=proof-simulation trace=5dc1ab26e7a7a690b86c1c01280ea7fa
200 origin="simulation" name=proof-simulation trace=f7942bb7afadfbee4ba86c76136b336e
200 origin="simulation" name=proof-simulation trace=a7a874f48fca645212114f4cd6b28368
200 origin="simulation" name=proof-simulation trace=4c8d016bee982dcc181f242452671ee9
200 origin="simulation" name=proof-simulation trace=8a99acdfda3f0b7b7a0e9067191282bb
200 origin="sample" name=proof-sample trace=f1d671b1eb561a6a6cb7622ff657fdd7
200 origin="ai_tool" name=proof-ai_tool trace=806e5f8b882364acbb274b6c67252739
200 origin="coding_agent" name=proof-coding_agent trace=83e130b6daf2a5b79b7a02122f1ed215
200 origin="gateway" name=proof-gateway trace=a4aae143f128c4cd48f3b7535f568636
200 origin="workflow" name=proof-workflow trace=aee4b38d4b3ecacf9a50ce4fd1f2043e
200 origin="playground" name=proof-playground trace=6a978251ce17246d52cb8ddfc9a71eae
200 origin="brand_new_origin" name=proof-unlisted trace=c5a1ea4f53073956e2915e7e7ccd6bb0
200 origin="brand_new_origin" name=proof-unlisted trace=096de71771c9bbe5fd15404633c7159e
```

### OTLP seed, Team Proof project (riley Team Proof key)

```
200 origin=<missing> name=team-app trace=e803006c961ac1a7c587449b29c0d8e4
200 origin=<missing> name=team-app trace=3710df849d401da767c3ea9dbd40be6f
200 origin=<missing> name=team-app trace=2a491fc4e082bdf07a69c9f4811d37be
200 origin="langy" name=langy.turn trace=fe8542a17c6d36923c7cd70aa40a3bac
200 origin="langy" name=langy.turn trace=905772d6ec5e995713f055f6c1860385
200 origin="simulation" name=team-sim trace=efeb722db64cd41e7677233ad07a24fa
```
