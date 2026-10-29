**Human verification**

A person drove PR head **90a75da9794** (https://github.com/langwatch/langwatch/commit/90a75da979474f3ae30ef1bc72d978d083e227da) on a local stack: app on http://localhost:5650, its own ClickHouse 25.10.2.65 (8 GiB cap) and Postgres database. Captures ran on three stack starts. **90a75da** (final head) reran every REST, CLI, MCP and tRPC batch, the AC208 and AC210c member runs, the AC204 editor, the AC205b preview and the skill check. Older captures are kept, labelled by sha, for browser-only steps whose code did not change after them. **624aa81** (https://github.com/langwatch/langwatch/commit/624aa8162633796c9817a7e9c789400f1196c947) covers REST, CLI, MCP, tRPC and the editor/board shots 01 to 09. **2ef801f** covers the stock boards, the privacy gate, AC207d, QP14, QP22 and the text checks. Between 624aa81 and 90a75da the browser code changed only by one unused default. The server, MCP and SDK changes are covered by the 90a75da reruns.

Setup, all in the product UI or over OTLP. Organization "Olga Org" with these projects:
- **Olga Org (P)**: application 6 (3 with no origin, 1 empty, 2 stamped), langy 3, simulation 2, evaluation 1, gateway 1, "mystery" 2, for 15 in total.
- **Beta**: application 2, langy 1.
- **Secret**: application 4, in "Hidden Team".
- **Gamma**: archived (set in Postgres).

Users:
- **Olga**: the owner (Admin).
- **Vic**: a Member of team Olga Org only. He cannot read Secret.
- **Zed**: has his own organization.

Keys, made in Settings > API keys and kept in 1Password:
- **P-key**: a personal key scoped to "This project", Olga Org.
- **Olga's organization key**.

Screenshots: https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/

- **Reserved name in the editor preview (AC205b, 90a75da):** Run refuses with lwql_reserved_parameter_supplied, and the widget is unchanged: https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-90a75da/14-preview-reserved-name-dark.png
- **The SQL does not read the parameter, at 90a75da:** https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-90a75da/02-sources-ignored-editor-dark.png and https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-90a75da/02-sources-ignored-editor-light.png
- **Owner board.** Every card has a Sources line and a Project/Projects line. The card whose SQL ignores sources shows the (i) line: https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/01-board-owner-dark.png and https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/01-board-owner-light.png
- **The SQL does not read the parameter.** "Add source" is disabled with the reason "The SQL does not read {dashboard_context_sources}": https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/02-sources-ignored-editor-dark.png and https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/02-sources-ignored-editor-light.png
- **Vic opens the board.** The card that names Secret shows "You can't read a project this widget uses". The other cards draw. No statement for it reached ClickHouse: https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/05-member-no-access-card-dark.png and https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/05-member-no-access-card-light.png
- **Vic's editor.** The row is "Olga Org" plus "1 project you can't read". The menu offers Beta and his Personal Workspace, not Secret and not the archived Gamma: https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/06-member-editor-hidden-menu-dark.png and https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/06-member-editor-hidden-row-light.png
- **Remove** drops the hidden entry, and the preview runs again over Olga Org (6): https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/07-member-removed-hidden-dark.png
- **Owner walk.** Add langy (preview 6 to 9). Add Beta, then Olga Org (preview 12). Save: the card reads "Projects: Beta, Olga Org". Undo: back to ["application"] with no projects key: https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/08-walk-a-open-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/08-walk-b-edited-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/08-walk-c-saved-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/08-walk-d-undone-dark.png
- **A crafted save** that names Secret, or a missing id, gets the same 404 "Project not found": https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/09-member-save-names-secret-dark.png and https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/09-member-save-names-missing-dark.png
- **Stock boards for Vic** while Input and Output are restricted to admins (the P0). Every card draws, with 13 and 8 card runs, all 200. The scenario cards say "Sources don't apply: this widget reads a view that keeps no origin": https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/11-stock-release-check-member-gated-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/11-stock-release-check-member-gated-light.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/12-stock-trust-member-gated-dark.png, https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/12-stock-trust-member-gated-light.png
- **Read access later (AC207d).** Before: the card is locked. After Vic is added to Hidden Team and reloads: Secret's 4 rows show, with no new save: https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/13-ac207d-a-before-grant-dark.png and https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-2ef801f/13-ac207d-b-after-grant-dark.png

**How I can prove I was successful**

Each row says what was run, where, and the result. Tests are not counted. "Seeded" means the counts above.

| AC | What was run | Surface | Evidence | Result |
|---|---|---|---|---|
| AC202 | Stock boards opened; card runs counted | browser | 21 card runs, all 200; stock cards show their Sources line. No REST call of a stock statement checking for no SOURCES_IGNORED | UNPROVEN |
| AC202b | Stock cards read | browser | Cards show "Sources: application". Adding a stock widget from the picker was not driven | UNPROVEN |
| AC202c | not driven | - | Only unit tests exist | UNPROVEN |
| AC202d | not driven | - | Needs a before and after build over the same data | UNPROVEN |
| AC202e | POST /api/v1/query, Source IN param, [application] / [other] / [langy] | REST | 6 (missing + empty + stamped) / 2 (mystery) / 3 | MET |
| AC202f | Release check board as Vic | browser | Four scenario cards read "Sources don't apply: this widget reads a view that keeps no origin" (shot 11) | MET |
| AC203 | Cards app / app+langy; REST with the same SQL | browser, REST | Cards 6 and 9; params ["application","langy"]; no sources gives ["application"]; [] gives 0 | MET |
| AC204 | Card and editor for SQL with no parameter | browser, REST (90a75da) | Counts 15 (every origin); card "Sources: all sources" with (i); SOURCES_IGNORED; the editor says "The SQL does not read {dashboard_context_sources}", as the spec now reads | MET |
| AC204b | Editor of "Ignores sources" | browser | Add source disabled; title and caption carry the reason (shot 02) | MET |
| AC204c | Placeholder only in a comment / a string literal | REST, browser (90a75da) | Both give SOURCES_IGNORED with params {}; a read in a CTE gives none; the editor text matches the spec | MET |
| AC205 | {dashboard_context_sources:String} | REST | 400 lwql_reserved_parameter_type, "a type other than Array(String)" | MET |
| AC205b | SET param_ / WITH alias / CTE named; editor preview | REST, tRPC, MCP, CLI, browser (90a75da) | 400 lwql_reserved_parameter_supplied at all four doors and in the preview (shot 14); the typed placeholder is accepted | MET |
| AC206 | Card with no stored projects; tRPC run | browser, tRPC | "Project: Olga Org"; params.dashboard_context_projects [P] | MET |
| AC206b | not driven | - | No group project set up | UNPROVEN |
| AC206c | not driven | - | No organization board set up | UNPROVEN |
| AC207 | Vic opens Add project | browser | Offers Beta and Personal Workspace; not Secret, not the archived Gamma; a picked project is not offered again (shot 06) | MET |
| AC207b | Pick Beta then Olga Org, save, GET | browser, REST | Stored [Beta, Olga Org]; card "Projects: Beta, Olga Org"; the other widgets are unchanged | MET |
| AC207c | Widget write with 101 ids; tRPC run with 101 | REST, tRPC (90a75da) | REST 422 validation_error naming queries.0.projects, "projects holds at most 100 ids"; tRPC gives the same message; 100 ids pass the cap | MET |
| AC207d | Grant Hidden Team to Vic, reload | browser | Locked, then Secret's rows (shot 13) | MET |
| AC208 | Vic opens the board; tRPC answer; query log | browser, tRPC, ClickHouse | Lock card; tRPC 404 project_not_found with meta {}; 0 query_log rows name Secret | MET |
| AC208b | Vic's editor; Remove | browser | "1 project you can't read"; Remove drops it (shots 06, 07) | MET |
| AC208c | not driven | - | Alerts do not run widget queries | UNPROVEN |
| AC208d | Hand-made tRPC: another org's project vs a missing id | tRPC curl | Both 404; bodies equal once trace ids are replaced; no id in the body | MET |
| AC209 | Change sources and projects, preview, Save, Undo | browser, REST | Preview reran 3 times; nothing stored before Save; Undo restored ["application"] with no projects key | MET |
| AC210 | Widgets with no projects; Save then Undo | browser, REST | They read the board's project; read-back has no projects key. Seeded by REST, not a real pre-change widget | MET |
| AC210b | Add with projects; update without projects; null | REST (organization key + X-Project-Id), CLI, MCP (90a75da) | Read back [Beta, Olga Org] (REST, CLI) and [P] (MCP); kept; null clears it | MET |
| AC210c | P-key (scoped to Olga Org) writes naming Secret / another org / a missing id; Vic's session save rewritten the same way | REST, tRPC session (90a75da) | All 404 project_not_found; the write bodies are equal to each other and to the query-door 404 once trace ids are removed; no id; nothing stored | MET |
| AC210d | Release notes | docs | docs/features/dashboards.mdx line 219: "Rolling back to a release before this one shows multi-project widgets for the board's project only" | MET |
| AC211 | not driven | - | The insight gate needs a model | UNPROVEN |
| AC212 | Compiled skill text | text (90a75da) | Names both reserved names, Array(String), the board's project default, --projects A,B, "projects" in the queries file, SOURCES_IGNORED, GRANULARITY_COARSENED and SHARE_WINDOW_LIMITED; its text "The SQL does not read {dashboard_context_sources}" matches the editor | MET |
| AC213 | Board cards | browser | The (i) line is on the SOURCES_IGNORED card only; unlimited cards have none; no project named. GRANULARITY_COARSENED was shown over tRPC, not on a card | MET |
| QP01 | Run with no sources | REST, CLI, MCP, tRPC (90a75da) | params ["application"] and 6 at all four doors | MET |
| QP02 | tRPC card run with no projects | tRPC, browser | params.dashboard_context_projects [P]; card "Project: Olga Org" | MET |
| QP03 | Key reading exactly one project (P-key), no projects | REST, CLI, MCP (90a75da) | 200; params.dashboard_context_projects [P] at all three | MET |
| QP03b | Organization key (reads several) without and with projects | REST (90a75da) | 422 projects_required with the exact message and no id; [P] reads P | MET |
| QP03c | not driven | - | No group project | UNPROVEN |
| QP03d | P-key names Secret | REST | 404 project_not_found | MET |
| QP03e | Organization key, no --projects; run_query with no projects | CLI, MCP (90a75da) | "Name the projects to query: pass --projects <id,id>" (exit 1); MCP "Name the projects to query: pass `projects`, a list of project ids"; no ids | MET |
| QP04 | Source IN param, [application, langy] | REST | 9; params as sent; no SOURCES_IGNORED | MET |
| QP05 | SQL with no parameter, [application] | REST | 15, params {}, the exact SOURCES_IGNORED message; no sources named gives no note | MET |
| QP05b | Comment / literal / CTE | REST | Note, note, none | MET |
| QP06 | Query log for the control run | ClickHouse | The statement as written, with no Origin predicate | MET |
| QP07 | sources [] | REST | 0, params [] | MET |
| QP07b | [application] / [other] / [langy]; [langy, application, langy] | REST | 6 / 2 / 3; params ["langy","application"] | MET |
| QP08 | Unknown source | REST, CLI, tRPC, MCP (90a75da) | validation_error at all four; each lists the eleven sources (MCP: "Code: validation_error" and "expected one of: application, ... other") | MET |
| QP09 | P-key, [P, Secret]; query log | REST, ClickHouse | 404; 0 query_log rows for the marker statement; the control run logged | MET |
| QP09b | [P, Secret] vs [P, missing] vs [P, other org] | REST | Bodies and headers equal (trace ids, Date and request ids removed); no id in the body | MET |
| QP09c | The same refusal at three doors | REST, tRPC, MCP (90a75da) | REST: code project_not_found and message "Project not found". MCP: "Project not found" and "Code: project_not_found". **tRPC carries the code, but its message is "project_not_found", not "Project not found"** | UNPROVEN (tRPC message) |
| QP10 | Another org's project | tRPC, REST, CLI, MCP (90a75da) | 404 project_not_found at all four | MET |
| QP10b | not driven | - | A deleted or archived stored project was not run | UNPROVEN |
| QP11 | not driven | - | Revoke after save over 4 runners | UNPROVEN |
| QP11b | not driven | - | Group project | UNPROVEN |
| QP12 | Organization key, [B, P, B] | REST, CLI | params [B, P]; rows per tenant | MET |
| QP12b | 10,001 ids (180,052 bytes) | REST | 422 "projects holds at most 10000 ids" | MET |
| QP12c | projects [] | REST | 422 "projects must hold at least one id" | MET |
| QP12d | projectId and projects | REST | 422 "send projectId or projects, not both" | MET |
| QP13 | not driven | - | Share windows and redaction over a group | UNPROVEN |
| QP14 | [P] with TenantId = Secret | REST | 0 rows (Secret has 4) | MET |
| QP15 | Reserved name in parameters | REST | String value: 400 naming the `sources` / `projects` field. **Array value: generic 422 validation_error.** The other doors were not run | UNPROVEN |
| QP15b | The three shapes | REST (all 3), tRPC, MCP, CLI (WITH alias) | lwql_reserved_parameter_supplied everywhere; the typed placeholder is accepted | MET |
| QP16 | {dashboard_context_projects:String} | REST | 400 lwql_reserved_parameter_type | MET |
| QP17 | Success answers | REST, tRPC | Flat params by SQL name, plus period on a time run; no short keys | MET |
| QP17b | Saved chart, coarsen, 30 days at 1 s | tRPC | GRANULARITY_COARSENED meta {requestedSeconds 1, granularitySeconds 3600}; params.dashboard_context_granularity_seconds 3600; the control run has none | MET |
| QP18 | The same statement, sources and projects | tRPC, REST, MCP | All three give params {"dashboard_context_sources":["application","langy"]} | MET |
| QP19 | --sources --projects in table / -o json / --format json / csv / blank | CLI | Table plus "Ran with {...}"; json is {rows, params, diagnostics}; csv rows with params on stderr; blank flags refused | MET |
| QP20 | run_query with sources and projects | MCP | "Ran with these placeholders" with params | MET |
| QP21 | not driven | - | Insight gate | UNPROVEN |
| QP22 | SDK 2.0.0 body (query, parameters, projectId) | REST | A body with `query` gives 422 (sql required); with `sql` it is 200. Not compared with the release before | UNPROVEN |

sql [-hnr] [--table-size] [--db-size] [-p pass-through] [-s string] dburl [command] it is 200. Not compared with the release before | UNPROVEN |
| QP22b | not driven | - | Published CLI 2.0.0 and MCP 2.2.0 not run | UNPROVEN |
| QP23 | Release notes | docs | As AC210d | MET |
| QP24 | OpenAPI document | docs/api-reference/openapiLangWatch.json | Request requires only sql (sources and projects optional); 200 lists params | MET |
| QP25 | SELECT Comment FROM annotations with output restricted | REST | 400 lwql_not_permitted, GATED_COLUMN "The field \"Comment\" is not available to you"; no project named | MET |
| QP26 | not driven | - | No dated share | UNPROVEN |
| QP27 | Runs with no dated member | REST, browser | No SHARE_WINDOW_LIMITED; cards with no (i) line (shot 01) | MET |
| QP28 | not driven | - | Needs QP26 | UNPROVEN |
| QP29 | SOURCES_IGNORED at each door | REST, MCP, CLI, card | Shown under the rows at all four. No share-window limited run | UNPROVEN (no limited run) |
| QP30 | An unreadable project named | REST | 404 with no diagnostics list | MET |

**Verdict: NOT READY.** 56 MET, 22 UNPROVEN, out of 78 rows. Every target of the last builder batch now holds in use: AC210c, QP03, QP03b, QP08, AC207c, AC204, AC204c and AC212. What is left:
1. QP09c: the tRPC 404 message is the code ("project_not_found"), not "Project not found".
2. Scenarios with no setup on this stack: group projects and share windows, organization boards, alerts, the insight gate, and the published CLI 2.0.0 and MCP 2.2.0. Also three stock-widget build checks (AC202 to AC202d).

**Rough UX edges**
- Diagnostics name the internal database, for example "qp9171b.trace_metrics was read with no condition...".
- The `projects_required` tip says "params.projects", but the key is params.dashboard_context_projects.
- In agent mode (CLAUDECODE set), a CLI table run prints no diagnostics, so agents miss SOURCES_IGNORED unless they use -o json.
- The CLI prints "Ran with {}" when no placeholder is declared.
- The (i) line on a card is cut off at the card width.
- On a no-access card, the footer still says "Project: Olga Org" (singular).
- The editor preview says "Reload to see the projects you can open", which a reload does not fix.
- For a reserved name in a WITH alias, the preview message gives two pieces of advice ("change the page's settings" and "Send the `projects` field"), and neither fits SQL that only aliases the name.
- Vic's organization key (Member) reads no project at all: 404 for every project, including those he reads in the UI (seen at 2ef801f).
- The `lwql_unknown_identifier` error does not name the column.
- The MCP widget add does not echo sources or projects.
- `widget add --help` lists the queries file as { name, sql, parameters?, sources? } and leaves out projects.

**Raw captures at 90a75da** (final head; redacted; keys shown as <name>)


**QP04/AC203 sources [application,langy]** (2026-10-29T10:17:39Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":9}],"statistics":{"elapsedMs":12,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application","langy"]}}


```

**QP01 no sources named** (2026-10-29T10:17:40Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":6}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application"]}}


```

**QP05/AC204 SQL without parameter, sources [application]** (2026-10-29T10:17:41Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05 SQL without parameter, no sources named (no note expected)** (2026-10-29T10:17:41Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05b/AC204c placeholder only in a comment** (2026-10-29T10:17:42Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics -- WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05b/AC204c placeholder only in a string literal** (2026-10-29T10:17:43Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n, '{dashboard_context_sources:Array(String)}' AS t FROM trace_metrics","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"},{"name":"t","type":"String"}],"rows":[{"n":15,"t":"{dashboard_context_sources:Array(String)}"}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05b placeholder read inside a CTE** (2026-10-29T10:17:44Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"WITH s AS (SELECT TraceId FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}) SELECT count() AS n FROM s","sources":["langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":3}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":2834,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["langy"]}}


```

**QP07 sources []** (2026-10-29T10:17:45Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":[],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":0}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":[]}}


```

**QP07b/AC202e [application]** (2026-10-29T10:17:45Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":6}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application"]}}


```

**QP07b/AC202e [other]** (2026-10-29T10:17:46Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["other"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":2}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["other"]}}


```

**QP07b/AC202e [langy]** (2026-10-29T10:17:47Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":3}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["langy"]}}


```

**QP07b order kept, repeat dropped** (2026-10-29T10:17:48Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["langy","application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":9}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["langy","application"]}}


```

**QP08 unknown source** (2026-10-29T10:17:48Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["bogus"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["sources.0"],"reasons":[{"code":"schema_failure","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","retryable":false,"meta":{"field":"sources.0","type":"invalid_value","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","expected":["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"],"received":"bogus"}}]},"trace_id":"cac88faaea61859d2819761160f25745","span_id":"f18f92beee5c318b","trace":{"traceId":"cac88faaea61859d2819761160f25745","spanId":"f18f92beee5c318b"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP12c projects []** (2026-10-29T10:17:49Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":[]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["projects"],"reasons":[{"code":"schema_failure","message":"projects must hold at least one id","retryable":false,"meta":{"field":"projects","type":"too_small","message":"projects must hold at least one id"}}]},"trace_id":"6bcb3ea3b75bcf48d428b611685d2e16","span_id":"4288681478a514b5","trace":{"traceId":"6bcb3ea3b75bcf48d428b611685d2e16","spanId":"4288681478a514b5"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP12d projectId and projects** (2026-10-29T10:17:50Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"send projectId or projects, not both","retryable":false,"trace_id":"77d6a91c981ab21be0072a1f9e4ea3cc","span_id":"1bb7254fe26c7923","trace":{"traceId":"77d6a91c981ab21be0072a1f9e4ea3cc","spanId":"1bb7254fe26c7923"},"fault":"customer"}


```

**QP15 parameters names dashboard_context_sources** (2026-10-29T10:17:51Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{"dashboard_context_sources":"langy"},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_sources, which the surface sets itself. Send the `sources` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"551ff72cfc3e95b9451019d87d402588","span_id":"b698979175e512ba","trace":{"traceId":"551ff72cfc3e95b9451019d87d402588","spanId":"b698979175e512ba"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15 parameters names dashboard_context_projects** (2026-10-29T10:17:51Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{"dashboard_context_projects":"x"},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"063ffec6ccf9c88bf93474673b8e8a1c","span_id":"ea0367a48f7b3a30","trace":{"traceId":"063ffec6ccf9c88bf93474673b8e8a1c","spanId":"ea0367a48f7b3a30"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15 parameters names dashboard_context_sources with an array value** (2026-10-29T10:17:52Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{"dashboard_context_sources":["langy"]},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["parameters.dashboard_context_sources"],"reasons":[{"code":"schema_failure","message":"Invalid input","retryable":false,"meta":{"field":"parameters.dashboard_context_sources","type":"invalid_union","message":"Invalid input"}}]},"trace_id":"564694129e5fbba1826a26948251c53c","span_id":"47918f0a18d234c9","trace":{"traceId":"564694129e5fbba1826a26948251c53c","spanId":"47918f0a18d234c9"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP15b/AC205b SET param_** (2026-10-29T10:17:53Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SET param_dashboard_context_projects = 'C'; SELECT 1","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"05d2668f3820dda0fef9c586f6e12860","span_id":"affac55fedbe1980","trace":{"traceId":"05d2668f3820dda0fef9c586f6e12860","spanId":"affac55fedbe1980"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b/AC205b WITH alias** (2026-10-29T10:17:54Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"WITH 'C' AS dashboard_context_projects SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"bd40eb6e3ea63b7935a2996c2c7f424e","span_id":"35100a7a3f2309f9","trace":{"traceId":"bd40eb6e3ea63b7935a2996c2c7f424e","spanId":"35100a7a3f2309f9"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b/AC205b CTE named** (2026-10-29T10:17:54Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"WITH dashboard_context_sources AS (SELECT 1) SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_sources, which the surface sets itself. Send the `sources` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"36c72f3decd2e588d1d5c8171255a85e","span_id":"866f633f1e35192d","trace":{"traceId":"36c72f3decd2e588d1d5c8171255a85e","spanId":"866f633f1e35192d"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b typed projects placeholder accepted** (2026-10-29T10:17:55Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1575,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}


```

**QP16 projects as String** (2026-10-29T10:17:56Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId = {dashboard_context_projects:String}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_type","message":"The query declares dashboard_context_projects with a type other than Array(String).","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"b1bb4ee9979fdbce3d35023609af5346","span_id":"044ffa76c160fe4a","trace":{"traceId":"b1bb4ee9979fdbce3d35023609af5346","spanId":"044ffa76c160fe4a"},"tips":["Read `meta.parameters`; it lists the reserved names declared with the wrong type","Declare each time-window name as `DateTime` or `DateTime64`, for example `{dashboard_context_period_start:DateTime}`; the interval they describe is half-open, `>= {dashboard_context_period_start:DateTime} AND < {dashboard_context_period_end:DateTime}`","Declare `dashboard_context_sources` and `dashboard_context_projects` as `Array(String)`, for example `{dashboard_context_sources:Array(String)}`"],"fault":"customer"}


```

**AC205 sources as String** (2026-10-29T10:17:57Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source = {dashboard_context_sources:String}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_type","message":"The query declares dashboard_context_sources with a type other than Array(String).","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"daaded667ee8bcbed608c0e425089d1b","span_id":"92d0354cfb1568c0","trace":{"traceId":"daaded667ee8bcbed608c0e425089d1b","spanId":"92d0354cfb1568c0"},"tips":["Read `meta.parameters`; it lists the reserved names declared with the wrong type","Declare each time-window name as `DateTime` or `DateTime64`, for example `{dashboard_context_period_start:DateTime}`; the interval they describe is half-open, `>= {dashboard_context_period_start:DateTime} AND < {dashboard_context_period_end:DateTime}`","Declare `dashboard_context_sources` and `dashboard_context_projects` as `Array(String)`, for example `{dashboard_context_sources:Array(String)}`"],"fault":"customer"}


```

**QP03 personal key scoped to one project, no projects named** (2026-10-29T10:17:57Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}"}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":6}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application"]}}


```

**QP03b org key, no projects** (2026-10-29T10:17:58Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"Name the projects to query: send `projects`, a list of project ids","retryable":false,"trace_id":"1d8c9ed4f803ab5b6df8d7103f498155","span_id":"3fcf02ec48160977","trace":{"traceId":"1d8c9ed4f803ab5b6df8d7103f498155","spanId":"3fcf02ec48160977"},"tips":["Send `projects`, a list of the project ids to read; the answer's `params.projects` lists what was read","A project API key needs none: it reads its own project"],"fault":"customer"}


```

**QP03b org key, projects [P]** (2026-10-29T10:17:59Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":6}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application"]}}


```

**QP12/AC207b org key, projects [B,P,B]** (2026-10-29T10:18:00Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"],"sources":["application","langy"]}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":9},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":12,"rowsRead":27,"bytesRead":1954,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application","langy"]}}


```

**QP03 key reading exactly one project (P-key), no projects, SQL reads the projects parameter** (2026-10-29T10:18:07Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)}"}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1575,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}


```

**QP12b org key, 10,001 project ids, body 180052 bytes** (key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' --data-binary @qp12b.json   # {"sql":"SELECT 1","projects":[10001 ids]}
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["projects"],"reasons":[{"code":"schema_failure","message":"projects holds at most 10000 ids","retryable":false,"meta":{"field":"projects","type":"too_big","message":"projects holds at most 10000 ids"}}]},"trace_id":"4dd96d19d0ba0331e66ceef6ff275193","span_id":"c4b962c005efdbda","trace":{"traceId":"4dd96d19d0ba0331e66ceef6ff275193","spanId":"c4b962c005efdbda"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP09/QP09b/QP10/AC208d REST 404 comparison and QP06 query log** (key: P-key, a personal key scoped to project Olga Org; projects [P, X], X = Secret (same org, the key cannot read it), the Zed Org project (another org), an id that does not exist; each statement carries the marker 'qp09-marker'; then a control run with projects [P] that does not read the sources parameter, sent with sources [application])
```
--- secret: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"b048b86e9e10600bd0a839fdb1abe9fe","span_id":"accd8f6b2b8394f0","trace":{"traceId":"b048b86e9e10600bd0a839fdb1abe9fe","spanId":"accd8f6b2b8394f0"},"fault":"customer"}
--- otherorg: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"f195b8fad42f4a650d4f7c517915c340","span_id":"9bac57f5171a0a7a","trace":{"traceId":"f195b8fad42f4a650d4f7c517915c340","spanId":"9bac57f5171a0a7a"},"fault":"customer"}
--- missing: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"b66477d30994b7c331226949834b9d77","span_id":"617e302a3eb8044d","trace":{"traceId":"b66477d30994b7c331226949834b9d77","spanId":"617e302a3eb8044d"},"fault":"customer"}
body secret vs missing (trace_id, span_id, trace removed): IDENTICAL
headers secret vs missing (Date, request ids removed): IDENTICAL
body otherorg vs missing (trace_id, span_id, trace removed): IDENTICAL
headers otherorg vs missing (Date, request ids removed): IDENTICAL
ids found in the three bodies: 0
control run: HTTP 200 rows [{'n': 15}]
$ SELECT event_time, user, query FROM system.query_log WHERE event_time >= '2026-10-29 10:18:08' AND query ILIKE '%qp09-marker%' AND user != 'default' AND type='QueryStart'
2026-10-29 10:18:09	langwatch_lwql_main	SELECT count() AS n FROM trace_metrics WHERE TenantId != \'qp09-marker\' LIMIT 10000 FORMAT JSON
(one row: the control run, as written, with no Origin predicate; no row for the three 404 runs)
```

**QP19 CLI table format, --sources application,langy --projects B,P** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --sources application\,langy --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ AND\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]

TenantId                               n
─────────────────────────────────────  ─
project_0008PfpfHW74BqNiMUxEzhXwQyuC0  9
project_0008QMtqMaztCPlOawJxdPx9kR3uy  3

MULTI_PROJECT_RESULT: This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.

UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with {"dashboard_context_projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application","langy"]}
[stderr]
Using API key from LANGWATCH_API_KEY. Switch: langwatch login --project | --device
- Running statement...
✔ 2 rows in 5ms
(exit 0)
```

**QP19 CLI -o json** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run -o json --sources application\,langy --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ AND\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
{
  "rows": [
    {
      "TenantId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "n": 9
    },
    {
      "TenantId": "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "n": 3
    }
  ],
  "params": {
    "dashboard_context_projects": [
      "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"
    ],
    "dashboard_context_sources": [
      "application",
      "langy"
    ]
  },
  "diagnostics": [
    {
      "code": "MULTI_PROJECT_RESULT",
      "message": "This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.",
      "meta": {
        "projectCount": 2
      }
    },
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "qp9171b.trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]

(exit 0)
```

**QP19 CLI --format json** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --format json --sources application\,langy --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ AND\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
{
  "rows": [
    {
      "TenantId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "n": 9
    },
    {
      "TenantId": "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "n": 3
    }
  ],
  "params": {
    "dashboard_context_projects": [
      "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"
    ],
    "dashboard_context_sources": [
      "application",
      "langy"
    ]
  },
  "diagnostics": [
    {
      "code": "MULTI_PROJECT_RESULT",
      "message": "This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.",
      "meta": {
        "projectCount": 2
      }
    },
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "qp9171b.trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]

(exit 0)
```

**QP19 CLI --format csv (params on stderr)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --format csv --sources application\,langy --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ AND\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
TenantId,n
project_0008PfpfHW74BqNiMUxEzhXwQyuC0,9
project_0008QMtqMaztCPlOawJxdPx9kR3uy,3
[stderr]
- Running statement...
✔ 2 rows in 6ms
{"params":{"dashboard_context_projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application","langy"]}}
(exit 0)
```

**QP01 CLI no --sources, -o json** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run -o json --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]
{
  "rows": [
    {
      "n": 6
    }
  ],
  "params": {
    "dashboard_context_sources": [
      "application"
    ]
  },
  "diagnostics": [
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "qp9171b.trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]

(exit 0)
```

**QP05/QP29 CLI table, SQL without parameter, --sources application** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --sources application --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics
[stdout]

n 
──
15

UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

SOURCES_IGNORED: This query doesn't read {dashboard_context_sources}, so it counts every origin.

Ran with {}
[stderr]
- Running statement...
✔ 1 row in 4ms
(exit 0)
```

**QP03e CLI org key, no --projects** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
- Running statement...
Error: Name the projects to query: pass --projects <id,id>
(exit 1)
```

**QP19 CLI blank --projects** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects '' SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
Error: --projects: pass a comma list
(exit 1)
```

**QP19 CLI blank --sources** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --sources '' --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
Error: --sources: pass a comma list
(exit 1)
```

**QP08 CLI unknown source** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --sources application\,bogus --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: The request body didn't match the expected shape.
Details:
  code      validation_error
  status    422
  trace id  7b275af4f6e71125ffa26ce4908a5333
  target    json
  fields    sources.1
  reasons   [{"code":"schema_failure","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","retryable":false,"meta":{"field":"sources.1","type":"invalid_value","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","expected":["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"],"received":"bogus"}}]
Suggestions:
  - Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected
  - Fix those fields and send the request again; retrying it unchanged will fail identically
(exit 1)
```

**QP15b/AC205b CLI WITH alias of a reserved name** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 WITH\ \'C\'\ AS\ dashboard_context_projects\ SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.
Details:
  code        lwql_reserved_parameter_supplied
  status      400
  trace id    1fe277b987d934b3a80596601aaab86a
  parameters  dashboard_context_projects
Suggestions:
  - Read `meta.parameters`; it lists the reserved names the request set for itself
  - `dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`
  - `dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead
  - `dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead
(exit 1)
```

**QP10 CLI another org's project** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects project_0008VSNhu43L0A3UgdAqjkTTaYcZg SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: Project not found
Details:
  code      project_not_found
  status    404
  trace id  2cbcddac4ffafecb053e8ccc63edec52
  trace_id  2cbcddac4ffafecb053e8ccc63edec52
  span_id   fc4e229d069d9bc0
Suggestions:
  - Check which project your API key belongs to
  - Create or select a project in the LangWatch dashboard
(exit 1)
```

**MCP run_query, add_dashboard_widget, update_dashboard_widget** (stdio client against mcp/typescript/dist/index.js built at 90a75da; server at 90a75da; key: P-key; tool results only)
```
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result: | n |
| --- |
| 9 |

Returned 1 row in 4ms.
UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with these placeholders:
(json)
{
  "dashboard_context_sources": [
    "application",
    "langy"
  ]
}
(end json)
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}"}
result: | n |
| --- |
| 6 |

Returned 1 row in 6ms.
UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with these placeholders:
(json)
{
  "dashboard_context_sources": [
    "application"
  ]
}
(end json)
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result: | n |
| --- |
| 15 |

Returned 1 row in 6ms.
UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.
SOURCES_IGNORED: This query doesn't read {dashboard_context_sources}, so it counts every origin.

Ran with these placeholders:
(json)
{}
(end json)
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH"]}
result isError=true: LangWatch API error 404: Project not found
Code: project_not_found
**MCP run_query** {"sql":"WITH 'C' AS dashboard_context_projects SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result isError=true: LangWatch API error 400: The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.
Code: lwql_reserved_parameter_supplied
Details: {"parameters":["dashboard_context_projects"]}
Tips:
- Read `meta.parameters`; it lists the reserved names the request set for itself
- `dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`
- `dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead
- `dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["bogus"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result isError=true: LangWatch API error 422: The request body didn't match the expected shape.
Code: validation_error
Rejected fields:
- sources.0 — received "bogus" — expected one of: application, simulation, evaluation, sample, coding_agent, ai_tool, gateway, workflow, playground, langy, other
Tips:
- Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected
- Fix those fields and send the request again; retrying it unchanged will fail identically
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result: | n |
| --- |
| 6 |

Returned 1 row in 4ms.
UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with these placeholders:
(json)
{
  "dashboard_context_sources": [
    "application"
  ]
}
(end json)
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":["project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}
result isError=true: LangWatch API error 404: Project not found
Code: project_not_found
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)}"}
result: | n |
| --- |
| 15 |

Returned 1 row in 4ms.
UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with these placeholders:
(json)
{
  "dashboard_context_projects": [
    "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"
  ]
}
(end json)
**MCP add_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","name":"MCP 90a7 app+langy, project Olga Org","code":"export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}
result: Widget "MCP 90a7 app+langy, project Olga Org" created and added to dashboard "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K".
**Widget ID**: widget_00011AEfhQeKG4D3wI5HhLUHsQXGi
**Queries**: main
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_00011AEfhQeKG4D3wI5HhLUHsQXGi","name":"MCP 90a7 renamed"}
result: Widget "MCP 90a7 renamed" updated on dashboard "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K".
**Widget ID**: widget_00011AEfhQeKG4D3wI5HhLUHsQXGi
**Queries**: main

widget read back: [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_00011AEfhQeKG4D3wI5HhLUHsQXGi","projects":null}
result: Widget "MCP 90a7 renamed" updated on dashboard "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K".
**Widget ID**: widget_00011AEfhQeKG4D3wI5HhLUHsQXGi
**Queries**: main

widget read back: [{"name": "main", "sources": ["application", "langy"]}]
```

**QP03e MCP run_query with olga-org-key (reads several projects), no projects** (90a75da)
```
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}"}
result isError=True: Name the projects to query: pass `projects`, a list of project ids
```

**QP03 CLI key reading exactly one project (P-key), no --projects** (key: P-key)
```
$ LANGWATCH_API_KEY=<P-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run -o json SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}
[stdout]
{
  "rows": [
    {
      "n": 15
    }
  ],
  "params": {
    "dashboard_context_projects": [
      "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"
    ]
  },
  "diagnostics": [
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "qp9171b.trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]
Using API key for project "Olga Org". Switch: langwatch login --project | --device
(exit 0)
```

**AC210b/AC207b REST add widget, projects [Beta, Olga Org]** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "REST 90a7 Beta then Olga Org", "queries": [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
HTTP 404
{"type": "not_found", "code": "project_not_found", "message": "Project not found", "retryable": false, "trace_id": "617db6ada3f8e2b486deac88aea29917", "fault": "customer"}
```

**AC210b REST PATCH naming no projects keeps the list** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X PATCH http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/ -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "REST 90a7 renamed", "queries": [{"name": "main"}]}
HTTP 404
{"error": "Not Found"}
```

**AC210b REST PATCH projects null clears it** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X PATCH http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/ -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"queries": [{"name": "main", "projects": null}]}
HTTP 404
{"error": "Not Found"}
```

**AC210c REST add widget naming secret project** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "AC210c secret", "queries": [{"name": "main", "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH"]}]}
HTTP 404
{"type": "not_found", "code": "project_not_found", "message": "Project not found", "retryable": false, "trace_id": "0113cb635e27ef780fc790a1e7952d6c", "fault": "customer"}
```

**AC210c REST add widget naming otherorg project** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "AC210c otherorg", "queries": [{"name": "main", "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}]}
HTTP 404
{"type": "not_found", "code": "project_not_found", "message": "Project not found", "retryable": false, "trace_id": "52cff40a52dd3ace98222f3042b04310", "fault": "customer"}
```

**AC210c REST add widget naming missing project** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "AC210c missing", "queries": [{"name": "main", "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0000doesnotexist00000000000"]}]}
HTTP 404
{"type": "not_found", "code": "project_not_found", "message": "Project not found", "retryable": false, "trace_id": "8a7d97f589cbb39222a81c42c7a746d9", "fault": "customer"}
```

**AC207c REST add widget naming 101 project ids** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @w101.json
body: {"name": "AC207c 101", "queries": [{"name": "main", "projects": ["project_x000", "project_x001", "project_x002", "project_x003", "project_x004", "project_x005", "project_x006", "project_x007", "project_x008", "project_x009", "project_x010", "project_x011", "project_x012", "project_x013", "project_x0 ... (1683 chars)
HTTP 422
{"type": "unprocessable_entity", "code": "validation_error", "message": "The request body didn't match the expected shape.", "retryable": false, "meta": {"target": "json", "fields": ["queries.0.projects"], "reasons": [{"code": "schema_failure", "message": "projects holds at most 100 ids", "retryable": false, "meta": {"field": "queries.0.projects", "type": "too_big", "message": "projects holds at most 100 ids"}}]}, "trace_id": "1b177a61b9205364b6397028a5da5155", "tips": ["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected", "Fix those fields and send the request again; retrying it unchanged will fail identically"], "fault": "customer"}
```

**AC207c control: REST add widget naming 100 ids that do not exist** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "AC207c 100", "queries": [{"name": "main", "projects": ["project_x000", "project_x001", "project_x002", "project_x003", "project_x004", "project_x005", "project_x006", "project_x007", "project_x008", "project_x009", "project_x010", "project_x011", "project_x012", "project_x013", "project_x0 ... (1667 chars)
HTTP 404
{"type": "not_found", "code": "project_not_found", "message": "Project not found", "retryable": false, "trace_id": "11638a0ac4c4d9d53da61fd084f884fb", "fault": "customer"}
```

**AC210b/AC207b REST add widget, projects [Beta, Olga Org]** (key: olga-org-key with X-Project-Id: Olga Org; 90a75da)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <olga-org-key>' -H 'X-Project-Id: project_0008PfpfHW74BqNiMUxEzhXwQyuC0'
HTTP 201
{"id": "widget_00011SuozJnuZjhVDl8Pr6O2jgU1A", "name": "REST 90a7 Beta then Olga Org", "queries": [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
```

**AC210b REST PATCH naming no projects keeps the list** (key: olga-org-key with X-Project-Id: Olga Org; 90a75da)
```
$ curl -X PATCH http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/widget_00011SuozJnuZjhVDl8Pr6O2jgU1A -H 'Authorization: Bearer <olga-org-key>' -H 'X-Project-Id: project_0008PfpfHW74BqNiMUxEzhXwQyuC0'
HTTP 200
{"id": "widget_00011SuozJnuZjhVDl8Pr6O2jgU1A", "name": "REST 90a7 renamed", "queries": [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
```

**AC210b REST PATCH projects null clears it** (key: olga-org-key with X-Project-Id: Olga Org; 90a75da)
```
$ curl -X PATCH http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/widget_00011SuozJnuZjhVDl8Pr6O2jgU1A -H 'Authorization: Bearer <olga-org-key>' -H 'X-Project-Id: project_0008PfpfHW74BqNiMUxEzhXwQyuC0'
HTTP 200
{"id": "widget_00011SuozJnuZjhVDl8Pr6O2jgU1A", "name": "REST 90a7 renamed", "queries": [{"name": "main", "sources": ["application", "langy"]}]}
```

**AC210c widget write naming a project: Secret (the key cannot read it), Zed's project (another org), an id that does not exist; and the query door for Secret** (key: P-key, scoped to project Olga Org; 90a75da)
```
--- write secret: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"0a785a3af462ac0e288db5ad552eb313","span_id":"ee523600f96436fb","trace":{"traceId":"0a785a3af462ac0e288db5ad552eb313","spanId":"ee523600f96436fb"},"fault":"customer"}
--- write otherorg: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"15b87abc12575476a42223473313f30a","span_id":"771d4fbb3cca27db","trace":{"traceId":"15b87abc12575476a42223473313f30a","spanId":"771d4fbb3cca27db"},"fault":"customer"}
--- write missing: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"a944878fcf4ae4f1f22597281bb6604d","span_id":"700281191eb894b3","trace":{"traceId":"a944878fcf4ae4f1f22597281bb6604d","spanId":"700281191eb894b3"},"fault":"customer"}
--- query door [P, Secret]:
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"ff5e8c08c62335dba022473243fe6c4b","span_id":"2fc04e6cd4d81b7a","trace":{"traceId":"ff5e8c08c62335dba022473243fe6c4b","spanId":"2fc04e6cd4d81b7a"},"fault":"customer"}
write secret vs write missing: body IDENTICAL, headers IDENTICAL
write otherorg vs write missing: body IDENTICAL, headers IDENTICAL
write secret vs query door secret: body IDENTICAL
ids in the bodies: 0
```



**QP18/QP02 tRPC owner, projects [P], sources [application,langy]** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":9}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application","langy"]}}}}

```

**QP02 tRPC owner, card run storing no projects (no projects key)** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)}","parameters":{},"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1575,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}}}

```

**AC208d/QP10 tRPC owner names another org's project** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["application","langy"],"projects":["project_0008VSNhu43L0A3UgdAqjkTTaYcZg"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"89966297f92fbca7748182087a4d4fef","spanId":"e13c0fb12378718f","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"89966297f92fbca7748182087a4d4fef"}}}

```

**AC208d tRPC owner names an id that does not exist** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["application","langy"],"projects":["project_0000doesnotexist00000000000"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"3471d1a59f3b107e58018fe61e200bb2","spanId":"72f09ce2944b08d3","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"3471d1a59f3b107e58018fe61e200bb2"}}}

```

**QP09c tRPC member names a project of the org he cannot read (Secret)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["application","langy"],"projects":["project_0008RvvmwglxZMZ0yVpjAsI6sPVoH"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"0a6124a56e48c324ef13031637f5b16d","spanId":"aef73c2df67ff788","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"0a6124a56e48c324ef13031637f5b16d"}}}

```

**AC208d/QP10/QP09c tRPC 404 bodies compared** (traceId and spanId replaced by <id>)
```
other org vs missing id: IDENTICAL
unreadable same-org project (member session) vs missing id: IDENTICAL
ids found in the three bodies: 0
```

**QP08 tRPC unknown source** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["bogus"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 400 Bad Request
{"error":{"message":"validation_error","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,"path":"analytics.lwql.query","cause":null,"error":{"code":"validation_error","kind":"validation_error","meta":{"fieldErrors":{"sources":["Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\""]},"formErrors":[]},"httpStatus":422,"fault":"customer","retryable":false,"reasons":[]},"authored":false}}}

```

**QP15b/AC205b tRPC WITH alias of a reserved name** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"WITH 'C' AS dashboard_context_projects SELECT count() AS n FROM trace_metrics","parameters":{},"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 400 Bad Request
{"error":{"message":"lwql_reserved_parameter_supplied","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,"path":"analytics.lwql.query","cause":null,"error":{"code":"lwql_reserved_parameter_supplied","kind":"lwql_reserved_parameter_supplied","meta":{"parameters":["dashboard_context_projects"]},"traceId":"8066e70327746badb7c5c821f962aad3","spanId":"491eb1d271b9e53f","httpStatus":400,"fault":"customer","retryable":false,"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"reasons":[]},"authored":false,"traceId":"8066e70327746badb7c5c821f962aad3"}}}

```

**AC207c tRPC card run naming 101 project ids** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"projects":["project_x000", "project_x001", "project_x002", "project_x003", "project_x004", "project_x005", "project_x006", "project_x007", "project_x008", "project_x009", "project_x010", "project_x011", "project_x012", "project_x013", "project_x014", "project_x015", "project_x016", "project_x017", "project_x018", "project_x019", "project_x020", "project_x021", "project_x022", "project_x023", "project_x024", "project_x025", "project_x026", "project_x027", "project_x028", "project_x029", "project_x030", "project_x031", "project_x032", "project_x033", "project_x034", "project_x035", "project_x036", "project_x037", "project_x038", "project_x039", "project_x040", "project_x041", "project_x042", "project_x043", "project_x044", "project_x045", "project_x046", "project_x047", "project_x048", "project_x049", "project_x050", "project_x051", "project_x052", "project_x053", "project_x054", "project_x055", "project_x056", "project_x057", "project_x058", "project_x059", "project_x060", "project_x061", "project_x062", "project_x063", "project_x064", "project_x065", "project_x066", "project_x067", "project_x068", "project_x069", "project_x070", "project_x071", "project_x072", "project_x073", "project_x074", "project_x075", "project_x076", "project_x077", "project_x078", "project_x079", "project_x080", "project_x081", "project_x082", "project_x083", "project_x084", "project_x085", "project_x086", "project_x087", "project_x088", "project_x089", "project_x090", "project_x091", "project_x092", "project_x093", "project_x094", "project_x095", "project_x096", "project_x097", "project_x098", "project_x099", "project_x100"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 400 Bad Request
{"error":{"message":"validation_error","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,"path":"analytics.lwql.query","cause":null,"error":{"code":"validation_error","kind":"validation_error","meta":{"fieldErrors":{"projects":["projects holds at most 100 ids"]},"formErrors":[]},"httpStatus":422,"fault":"customer","retryable":false,"reasons":[]},"authored":false}}}

```

**QP17b saved-chart card run, onBudgetOverflow coarsen, 30-day period at a 1-second grain** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.savedWorkbenchCharts.run -H 'Cookie: <session>' -d '{"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","id":"chart_0008gFk4k6lA3JQaTxvnQXBAvkhc3","granularitySeconds":1,"onBudgetOverflow":"coarsen","timeWindow":{"start":"2026-09-29T00:00:00.000Z","end":"2026-10-29T00:00:00.000Z"}}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"t","type":"DateTime"},{"name":"n","type":"UInt64"}],"rows":[],"statistics":{"elapsedMs":4,"rowsRead":5,"bytesRead":585,"rowsReturned":0},"diagnostics":[{"code":"GRANULARITY_COARSENED","message":"The period is too long for 1-second steps, so the query ran at 3600-second steps.","meta":{"requestedSeconds":1,"granularitySeconds":3600}}],"followsTimeWindow":true,"followsGranularity":true,"granularitySeconds":3600,"coarsenedFromSeconds":1,"completeness":{"state":"no_traffic","unit":"traces","total":0,"fields":[],"buckets":[{"start":"2026-09-29T00:00:00Z","n":0},{"start":"2026-09-29T01:00:00Z","n":0},{"start":"2026-09-29T02:00:00Z","n":0},{"start":"2026-09-29T03:00:00Z","n":0},{"start":"2026-09-29T04:00:00Z","n":0},{"start":"2026-09-29T05:00:00Z","n":0},{"start":"2026-09-29T06:00:00Z","n":0},{"start":"2026-09-29T07:00:00Z","n":0},{"start":"2026-09-29T08:00:00Z","n":0},{"start":"2026-09-29T09:00:00Z","n":0},{"start":"2026-09-29T10:00:00Z","n":0},{"start":"2026-09-29T11:00:00Z","n":0},{"start":"2026-09-29T12:00:00Z","n":0},{"start":"2026-09-29T13:00:00Z","n":0},{"start":"2026-09-29T14:00:00Z","n":0},{"start":"2026-09-29T15:00:00Z","n":0},{"start":"2026-09-29T16:00:00Z","n":0},{"start":"2026-09-29T17:00:00Z","n":0},{"start":"2026-09-29T18:00:00Z","n":0},{"start":"2026-09-29T19:00:00Z","n":0},{"start":"2026-09-29T20:00:00Z","n":0},{"start":"2026-09-29T21:00:00Z","n":0},{"start":"2026-09-29T22:00:00Z","n":0},{"start":"2026-09-29T23:00:00Z","n":0},{"start":"2026-09-30T00:00:00Z","n":0},{"start":"2026-09-30T01:00:00Z","n":0},{"start":"2026-09-30T02:00:00Z","n":0},{"start":"2026-09-30T03:00:00Z","n":0},{"start":"2026-09-30T04:00:00Z","n":0},{"start":"2026-09-30T05:00:00Z","n":0},{"start":"2026-09-30T06:00:00Z","n":0},{"start":"2026-09-30T07:00:00Z","n":0},{"start":"2026-09-30T08:00:00Z","n":0},{"start":"2026-09-30T09:00:00Z","n":0},{"start":"2026-09-30T10:00:00Z","n":0},{"start":"2026-09-30T11:00:00Z","n":0},{"start":"2026-09-30T12:00:00Z","n":0},{"start":"2026-09-30T13:00:00Z","n":0},{"start":"2026-09-30T14:00:00Z","n":0},{"start":"2026-09-30T15:00:00Z","n":0},{"start":"2026-09-30T16:00:00Z","n":0},{"start":"2026-09-30T17:00:00Z","n":0},{"start":"2026-09-30T18:00:00Z","n":0},{"start":"2026-09-30T19:00:00Z","n":0},{"start":"2026-09-30T20:00:00Z","n":0},{"start":"2026-09-30T21:00:00Z","n":0},{"start":"2026-09-30T22:00:00Z","n":0},{"start":"2026-09-30T23:00:00Z","n":0},{"start":"2026-10-01T00:00:00Z","n":0},{"start":"2026-10-01T01:00
```

**QP17b the same coarsened run, params and diagnostics read from the full answer**
```
params: {"period": {"start": "2026-09-29T00:00:00.000Z", "end": "2026-10-29T00:00:00.000Z"}, "dashboard_context_sources": ["application"], "dashboard_context_granularity_seconds": 3600}
diagnostics: [{"code": "GRANULARITY_COARSENED", "message": "The period is too long for 1-second steps, so the query ran at 3600-second steps.", "meta": {"requestedSeconds": 1, "granularitySeconds": 3600}}]
granularitySeconds: 3600 coarsenedFromSeconds: 1
```

**QP17b control: same chart, coarsen mode, 1-day period at a 3600-second grain** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.savedWorkbenchCharts.run -H 'Cookie: <session>' -d '{"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","id":"chart_0008gFk4k6lA3JQaTxvnQXBAvkhc3","granularitySeconds":3600,"onBudgetOverflow":"coarsen","timeWindow":{"start":"2026-10-28T08:00:00.000Z","end":"2026-10-29T08:00:00.000Z"}}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"t","type":"DateTime"},{"name":"n","type":"UInt64"}],"rows":[{"t":"2026-10-29 05:00:00","n":4},{"t":"2026-10-29 06:00:00","n":2}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":2130,"rowsReturned":2},"diagnostics":[],"followsTimeWindow":true,"followsGranularity":true,"granularitySeconds":3600,"completeness":{"state":"complete","unit":"traces","total":15,"fields":[],"buckets":[{"start":"2026-10-28T08:00:00Z","n":0},{"start":"2026-10-28T09:00:00Z","n":0},{"start":"2026-10-28T10:00:00Z","n":0},{"start":"2026-10-28T11:00:00Z","n":0},{"start":"2026-10-28T12:00:00Z","n":0},{"start":"2026-10-28T13:00:00Z","n":0},{"start":"2026-10-28T14:00:00Z","n":0},{"start":"2026-10-28T15:00:00Z","n":0},{"start":"2026-10-28T16:00:00Z","n":0},{"start":"2026-10-28T17:00:00Z","n":0},{"start":"2026-10-28T18:00:00Z","n":0},{"start":"2026-10-28T19:00:00Z","n":0},{"start":"2026-10-28T20:00:00Z","n":0},{"start":"2026-10-28T21:00:00Z","n":0},{"start":"2026-10-28T22:00:00Z","n":0},{"start":"2026-10-28T23:00:00Z","n":0},{"start":"2026-10-29T00:00:00Z","n":0},{"start":"2026-10-29T01:00:00Z","n":0},{"start":"2026-10-29T02:00:00Z","n":0},{"start":"2026-10-29T03:00:00Z","n":0},{"start":"2026-10-29T04:00:00Z","n":0},{"start":"2026-10-29T05:00:00Z","n":4},{"start":"2026-10-29T06:00:00Z","n":11},{"start":"2026-10-29T07:00:00Z","n":0}]},"params":{"period":{"start":"2026-10-28T08:00:00.000Z","end":"2026-10-29T08:00:00.000Z"},"dashboard_context_sources":["application"],"dashboard_context_granularity_seconds":3600}}}}

```

**AC208 member (Vic, not in Hidden Team) opens the board: the tRPC card run for widget 'Uses Secret'** (captured from the browser's network; 90a75da)
```
tRPC calls naming Secret: 1
{"status":404,"req":"{\"sql\":\"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId\",\"parameters\":{},\"granularitySeconds\":86400,\"sources\":[\"application\"],\"projects\":[\"project_0008PfpfHW74BqNiMUxEzhXwQyuC0\",\"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH\"],\"timeWindow\":{\"start\":\"2026-09-29T10:23:00.000Z\",\"end\":\"2026-10-29T10:23:00.000Z\"},\"projectId\":\"project_0008PfpfHW74BqNiMUxEzhXwQyuC0\"}","body":"{\"error\":{\"message\":\"project_not_found\",\"code\":-32004,\"data\":{\"code\":\"NOT_FOUND\",\"httpStatus\":404,\"path\":\"analytics.lwql.query\",\"cause\":null,\"error\":{\"code\":\"project_not_found\",\"kind\":\"project_not_found\",\"meta\":{},\"traceId\":\"<id>\",\"spanId\":\"<id>\",\"httpStatus\":404,\"fault\":\"customer\",\"retryable\":false,\"reasons\":[]},\"authored\":false,\"traceId\":\"<id>\"}}}"}
ClickHouse system.query_log rows naming the Secret project id over both loads since 2026-10-29 10:22:05: 0
rows from the lwql users over the same loads (the other cards): 30
```

**AC210c session door: Vic's editor Save of 'Application and Langy' (picked Beta), the outgoing dashboardWidgets.update rewritten in the browser to add Secret, then an id that does not exist** (traceId and spanId replaced by <id>; 90a75da)
```
== secret
[
 {
  "url": "/api/trpc/dashboardWidgets.update",
  "status": 404,
  "text": "{\"error\":{\"message\":\"project_not_found\",\"code\":-32004,\"data\":{\"code\":\"NOT_FOUND\",\"httpStatus\":404,\"path\":\"dashboardWidgets.update\",\"cause\":null,\"error\":{\"code\":\"project_not_found\",\"kind\":\"project_not_found\",\"meta\":{},\"traceId\":\"<id>\",\"spanId\":\"<id>\",\"httpStatus\":404,\"fault\":\"customer\",\"retryable\":false,\"reasons\":[]},\"authored\":false,\"traceId\":\"<id>\"}}}"
 }
]
visible error text: ["Looking for the old Analytics? It is still here.\nOpen Analytics","Project not found\nIt may have been deleted, or it isn't shared with you. Reload to see the projects you can open.\nCopy error ID","Project not found","It may have been deleted, or it isn't shared with you. Reload to see the projects you can open."]
== missing
[
 {
  "url": "/api/trpc/dashboardWidgets.update",
  "status": 404,
  "text": "{\"error\":{\"message\":\"project_not_found\",\"code\":-32004,\"data\":{\"code\":\"NOT_FOUND\",\"httpStatus\":404,\"path\":\"dashboardWidgets.update\",\"cause\":null,\"error\":{\"code\":\"project_not_found\",\"kind\":\"project_not_found\",\"meta\":{},\"traceId\":\"<id>\",\"spanId\":\"<id>\",\"httpStatus\":404,\"fault\":\"customer\",\"retryable\":false,\"reasons\":[]},\"authored\":false,\"traceId\":\"<id>\"}}}"
 }
]
visible error text: ["Looking for the old Analytics? It is still here.\nOpen Analytics","Project not found\nIt may have been deleted, or it isn't shared with you. Reload to see the projects you can open.\nCopy error ID","Project not found","It may have been deleted, or it isn't shared with you. Reload to see the projects you can open."]
secret vs missing tRPC body: IDENTICAL
```

**AC210c read back after the two rewritten saves (90a75da)** (GET /api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets, widget widget_0008Wg8eEwxR49Xwf8sY9XSGPDBbs, sql left out; key: P-key)
```
{"name": "Application and Langy", "queries": [{"name": "main", "sources": ["application", "langy"]}]}
```

**AC210b CLI widget add --projects B,P --sources application,langy (90a75da)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch dashboard widget add dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K --project olga-org-wQyuC0 --name CLI\ 90a7\ Beta\ then\ Olga\ Org --code-file ../proof/w.tsx --queries-file q-cli.json --sources application\,langy --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 --format json
[stdout]
{
  "id": "widget_00013oCeZ7tZvpWG4xWly6325ExqS",
  "name": "CLI 90a7 Beta then Olga Org",
  "definition": {
    "version": 1,
    "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n",
    "queries": [
      {
        "name": "main",
        "sql": "SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId",
        "sources": [
          "application",
          "langy"
        ],
        "projects": [
          "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
          "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"
        ]
      }
    ],
    "source": {
      "kind": "api"
    }
  },
  "createdAt": "2026-10-29T10:23:51.178Z",
  "updatedAt": "2026-10-29T10:23:51.178Z",
  "platformUrl": "http://localhost:5650/olga-org-wQyuC0/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K",
  "dashboardId": "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K",
  "gridColumn": 0,
  "gridRow": 39,
  "colSpan": 4,
  "rowSpan": 3
}
[stderr]

(exit 0)
```

**QP01 tRPC run naming no sources (90a75da)** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":6}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application"]}}}}

```

**AC205b read back after Cancel: widget unchanged (90a75da)** (GET /api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets, widget widget_0008Wgeopc6JSoJI5Sd8Xv9961ZdA, sql left out; key: P-key)
```
{"name": "Ignores sources", "queries": [{"name": "main", "sources": ["application"]}]}
```

**AC205b read back after Cancel: widget unchanged (90a75da)** (GET /api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets, widget widget_0008Wgeopc6JSoJI5Sd8Xv9961ZdA, sql left out; key: P-key)
```
{"name": "Ignores sources", "queries": [{"name": "main", "sources": ["application"]}]}
```

**AC205b editor preview: SQL changed to WITH 'C' AS dashboard_context_projects ..., then Run** (lwql preview requests captured from the browser; Cancel afterwards; 90a75da)
```
preview runs after Run: [{"status":400,"body":"{\"error\":{\"message\":\"lwql_reserved_parameter_supplied\",\"code\":-32600,\"data\":{\"code\":\"BAD_REQUEST\",\"httpStatus\":400,\"path\":\"analytics.lwql.query\",\"cause\":null,\"error\":{\"code\":\"lwql_reserved_parameter_supplied\",\"kind\":\"lwql_reserved_parameter_supplied\",\"meta\":{\""},{"status":400,"body":"{\"error\":{\"message\":\"lwql_reserved_parameter_supplied\",\"code\":-32600,\"data\":{\"code\":\"BAD_REQUEST\",\"httpStatus\":400,\"path\":\"analytics.lwql.query\",\"cause\":null,\"error\":{\"code\":\"lwql_reserved_parameter_supplied\",\"kind\":\"lwql_reserved_parameter_supplied\",\"meta\":{\""}]
editor error text: [
  "[lwql_reserved_parameter_supplied]: dashboard_context_projects comes from the page showing this chart. Remove it from your parameters and change the page's settings instead. Send the `projects` field of the request instead."
]
```

**AC204/AC204c/AC204b editor for widget 'Ignores sources' at 90a75da** (the spec now reads "The SQL does not read {dashboard_context_sources}")
```
dark sources row: sources = application Add source The SQL does not read {dashboard_context_sources} built-in | Add source disabled: true title: The SQL does not read {dashboard_context_sources}
dialog mentions 'ignores sources': true | mentions SOURCES_IGNORED message: false
light sources row: sources = application Add source The SQL does not read {dashboard_context_sources} built-in | Add source disabled: true title: The SQL does not read {dashboard_context_sources}
dialog mentions 'ignores sources': true | mentions SOURCES_IGNORED message: false
```

**AC212 compiled skill at 90a75da** (skills/_compiled/native/dashboard-widgets/SKILL.md; grep -cF per string)
```
The SQL does not read {dashboard_context_sources}    1
This query ignores sources                           0
SHARE_WINDOW_LIMITED                                 1
SOURCES_IGNORED                                      1
GRANULARITY_COARSENED                                1
--projects A,B                                       2
projects?                                            1
board's project                                      1
Array(String)                                        4
`--queries-file` is a JSON array of named queries: `{ name, sql, parameters?, sources?, projects? }`. A widget's code calls a query by `name` — the two files are one unit.
- `projects` lists the project ids the query reads, bound to `{dashboard_context_projects:Array(String)}`. A query that names none reads its board's project. Name only projects the user can read; a project the writer cannot read, one that does not exist and one of another organization are all refused with `project_not_found` (404) and no id.
- `{dashboard_context_sources:Array(String)}` and `{dashboard_context_projects:Array(String)}` are reserved like the period names: type `Array(String)`, never in `parameters`, never passed by you, and never assigned or aliased in the SQL (`SET param_…`, `WITH … AS dashboard_context_projects`) — all are refused with `lwql_reserved_parameter_supplied`.
```

**Raw captures at 624aa81 and 2ef801f** (kept for the browser steps; everything up to the block 'AC209/AC207b/AC207 owner editor walk' and the AC204b editor block ran on 624aa81; the blocks from 'P0 / AC202f' onward ran on 2ef801f; REST, CLI, MCP and tRPC results here are replaced by the 90a75da captures above)


**QP04/AC203 sources [application,langy]** (2026-10-29T08:00:17Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":9}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application","langy"]}}


```

**QP01 no sources named** (2026-10-29T08:00:18Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":6}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application"]}}


```

**QP05/AC204 SQL without parameter, sources [application]** (2026-10-29T08:00:19Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05 SQL without parameter, no sources named (no note expected)** (2026-10-29T08:00:19Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05b/AC204c placeholder only in a comment** (2026-10-29T08:00:20Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics -- WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05b/AC204c placeholder only in a string literal** (2026-10-29T08:00:21Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n, '{dashboard_context_sources:Array(String)}' AS t FROM trace_metrics","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"},{"name":"t","type":"String"}],"rows":[{"n":15,"t":"{dashboard_context_sources:Array(String)}"}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05b placeholder read inside a CTE** (2026-10-29T08:00:22Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"WITH s AS (SELECT TraceId FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}) SELECT count() AS n FROM s","sources":["langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":3}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":2834,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["langy"]}}


```

**QP07 sources []** (2026-10-29T08:00:22Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":[],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":0}],"statistics":{"elapsedMs":13,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":[]}}


```

**QP07b/AC202e [application]** (2026-10-29T08:00:23Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":6}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application"]}}


```

**QP07b/AC202e [other]** (2026-10-29T08:00:24Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["other"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":2}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["other"]}}


```

**QP07b/AC202e [langy]** (2026-10-29T08:00:25Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":3}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["langy"]}}


```

**QP07b order kept, repeat dropped** (2026-10-29T08:00:26Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["langy","application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":9}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["langy","application"]}}


```

**QP08 unknown source** (2026-10-29T08:00:26Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["bogus"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["sources.0"],"reasons":[{"code":"schema_failure","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","retryable":false,"meta":{"field":"sources.0","type":"invalid_value","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","expected":["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"],"received":"bogus"}}]},"trace_id":"2fead144800842751a5c356b13173112","span_id":"18e058379533fec5","trace":{"traceId":"2fead144800842751a5c356b13173112","spanId":"18e058379533fec5"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP12c projects []** (2026-10-29T08:00:27Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":[]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["projects"],"reasons":[{"code":"schema_failure","message":"projects must hold at least one id","retryable":false,"meta":{"field":"projects","type":"too_small","message":"projects must hold at least one id"}}]},"trace_id":"a2562ffb3e78e1eb454ddfb25829d846","span_id":"3679ea7e69aa6099","trace":{"traceId":"a2562ffb3e78e1eb454ddfb25829d846","spanId":"3679ea7e69aa6099"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP12d projectId and projects** (2026-10-29T08:00:28Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"send projectId or projects, not both","retryable":false,"trace_id":"16f1de9c0244cee8dc3733915230cb18","span_id":"385aa24a6091e001","trace":{"traceId":"16f1de9c0244cee8dc3733915230cb18","spanId":"385aa24a6091e001"},"fault":"customer"}


```

**QP15 parameters names dashboard_context_sources** (2026-10-29T08:00:29Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{"dashboard_context_sources":"langy"},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_sources, which the surface sets itself. Send the `sources` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"a3a604081b74a2bba44d7a390d05d364","span_id":"42d17199e521b3eb","trace":{"traceId":"a3a604081b74a2bba44d7a390d05d364","spanId":"42d17199e521b3eb"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15 parameters names dashboard_context_projects** (2026-10-29T08:00:29Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{"dashboard_context_projects":"x"},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"d799268cd39359c7262e2c44ab4dcebd","span_id":"7665edbee7b82739","trace":{"traceId":"d799268cd39359c7262e2c44ab4dcebd","spanId":"7665edbee7b82739"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15 parameters names dashboard_context_sources with an array value** (2026-10-29T08:00:30Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{"dashboard_context_sources":["langy"]},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["parameters.dashboard_context_sources"],"reasons":[{"code":"schema_failure","message":"Invalid input","retryable":false,"meta":{"field":"parameters.dashboard_context_sources","type":"invalid_union","message":"Invalid input"}}]},"trace_id":"2a11748c70f206bf2aa33ae026c024f9","span_id":"693a95c8055c0d8e","trace":{"traceId":"2a11748c70f206bf2aa33ae026c024f9","spanId":"693a95c8055c0d8e"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP15b/AC205b SET param_** (2026-10-29T08:00:31Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SET param_dashboard_context_projects = 'C'; SELECT 1","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"c2d2bc12a7d529a6d939b778232688bb","span_id":"7dd604e3b65bc7da","trace":{"traceId":"c2d2bc12a7d529a6d939b778232688bb","spanId":"7dd604e3b65bc7da"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b/AC205b WITH alias** (2026-10-29T08:00:32Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"WITH 'C' AS dashboard_context_projects SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"22e3f58bafab2490b210d16eb68688e2","span_id":"22791bb0c53beb88","trace":{"traceId":"22e3f58bafab2490b210d16eb68688e2","spanId":"22791bb0c53beb88"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b/AC205b CTE named** (2026-10-29T08:00:33Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"WITH dashboard_context_sources AS (SELECT 1) SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_sources, which the surface sets itself. Send the `sources` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"5ff85cedb757ad6069d0d702ae81a8e0","span_id":"71e160ea58ee493f","trace":{"traceId":"5ff85cedb757ad6069d0d702ae81a8e0","spanId":"71e160ea58ee493f"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b typed projects placeholder accepted** (2026-10-29T08:00:33Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":1575,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}


```

**QP16 projects as String** (2026-10-29T08:00:34Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId = {dashboard_context_projects:String}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_type","message":"The query declares dashboard_context_projects with a type other than Array(String).","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"9136854f949247880761ce059b073211","span_id":"f74abe5bc1c97257","trace":{"traceId":"9136854f949247880761ce059b073211","spanId":"f74abe5bc1c97257"},"tips":["Read `meta.parameters`; it lists the reserved names declared with the wrong type","Declare each time-window name as `DateTime` or `DateTime64`, for example `{dashboard_context_period_start:DateTime}`; the interval they describe is half-open, `>= {dashboard_context_period_start:DateTime} AND < {dashboard_context_period_end:DateTime}`","Declare `dashboard_context_sources` and `dashboard_context_projects` as `Array(String)`, for example `{dashboard_context_sources:Array(String)}`"],"fault":"customer"}


```

**AC205 sources as String** (2026-10-29T08:00:35Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source = {dashboard_context_sources:String}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_type","message":"The query declares dashboard_context_sources with a type other than Array(String).","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"aed28d2bec96dba66279f84098267e2d","span_id":"aa1ce86c914e4140","trace":{"traceId":"aed28d2bec96dba66279f84098267e2d","spanId":"aa1ce86c914e4140"},"tips":["Read `meta.parameters`; it lists the reserved names declared with the wrong type","Declare each time-window name as `DateTime` or `DateTime64`, for example `{dashboard_context_period_start:DateTime}`; the interval they describe is half-open, `>= {dashboard_context_period_start:DateTime} AND < {dashboard_context_period_end:DateTime}`","Declare `dashboard_context_sources` and `dashboard_context_projects` as `Array(String)`, for example `{dashboard_context_sources:Array(String)}`"],"fault":"customer"}


```

**QP03 personal key scoped to one project, no projects named** (2026-10-29T08:00:36Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"Name the projects to query: send `projects`, a list of project ids","retryable":false,"trace_id":"c5a240ff354471b72acb69b4c113ffbd","span_id":"9178b8d62b7e1044","trace":{"traceId":"c5a240ff354471b72acb69b4c113ffbd","spanId":"9178b8d62b7e1044"},"tips":["Send `projects`, a list of the project ids to read; the answer's `params.projects` lists what was read","A project API key needs none: it reads its own project"],"fault":"customer"}


```

**QP03b org key, no projects** (2026-10-29T08:00:36Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"Name the projects to query: send `projects`, a list of project ids","retryable":false,"trace_id":"0f502badfa93b9ced0620a4ba6dfb718","span_id":"cb36e13212ae5ca4","trace":{"traceId":"0f502badfa93b9ced0620a4ba6dfb718","spanId":"cb36e13212ae5ca4"},"tips":["Send `projects`, a list of the project ids to read; the answer's `params.projects` lists what was read","A project API key needs none: it reads its own project"],"fault":"customer"}


```

**QP03b org key, projects [P]** (2026-10-29T08:00:37Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":6}],"statistics":{"elapsedMs":6,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application"]}}


```

**QP12/AC207b org key, projects [B,P,B]** (2026-10-29T08:00:38Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"],"sources":["application","langy"]}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":9},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":1954,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application","langy"]}}


```

**QP12b org key, 10,001 project ids, body 180052 bytes** (key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' --data-binary @qp12b.json   # {"sql":"SELECT 1","projects":[10001 ids]}
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["projects"],"reasons":[{"code":"schema_failure","message":"projects holds at most 10000 ids","retryable":false,"meta":{"field":"projects","type":"too_big","message":"projects holds at most 10000 ids"}}]},"trace_id":"6436e97828a5cd14a0e961d838ab9361","span_id":"1efde1cac6a2b1e6","trace":{"traceId":"6436e97828a5cd14a0e961d838ab9361","spanId":"1efde1cac6a2b1e6"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP09/QP09b/QP10/AC208d REST 404 comparison and QP06 query log** (key: P-key, a personal key scoped to project Olga Org; projects [P, X], X = Secret (same org, the key cannot read it), the Zed Org project (another org), an id that does not exist; each statement carries the marker 'qp09-marker'; then a control run with projects [P] that does not read the sources parameter, sent with sources [application])
```
--- secret: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"a5d7e8afa36129e438ec607cb452fc5f","span_id":"06f7f13df4e5ab95","trace":{"traceId":"a5d7e8afa36129e438ec607cb452fc5f","spanId":"06f7f13df4e5ab95"},"fault":"customer"}
--- otherorg: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"6a2e07ecfa5bb4cc4dc3fbbbb6fe3c02","span_id":"6a02cbcdf65b4050","trace":{"traceId":"6a2e07ecfa5bb4cc4dc3fbbbb6fe3c02","spanId":"6a02cbcdf65b4050"},"fault":"customer"}
--- missing: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"ac84f8700ee73894d38644e378485d4a","span_id":"7cb2570fe86c0c44","trace":{"traceId":"ac84f8700ee73894d38644e378485d4a","spanId":"7cb2570fe86c0c44"},"fault":"customer"}
body secret vs missing (trace_id, span_id, trace removed): IDENTICAL
headers secret vs missing (Date, request ids removed): IDENTICAL
body otherorg vs missing (trace_id, span_id, trace removed): IDENTICAL
headers otherorg vs missing (Date, request ids removed): IDENTICAL
ids found in the three bodies: 0
control run: HTTP 200 rows [{'n': 15}]
$ SELECT event_time, user, query FROM system.query_log WHERE event_time >= '2026-10-29 08:00:59' AND query ILIKE '%qp09-marker%' AND user != 'default' AND type='QueryStart'
2026-10-29 08:01:00	langwatch_lwql_main	SELECT count() AS n FROM trace_metrics WHERE TenantId != \'qp09-marker\' LIMIT 10000 FORMAT JSON
(one row: the control run, as written, with no Origin predicate; no row for the three 404 runs)
```

**QP19 CLI table format, --sources application,langy --projects B,P** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --sources application\,langy --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ AND\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]

TenantId                               n
─────────────────────────────────────  ─
project_0008PfpfHW74BqNiMUxEzhXwQyuC0  9
project_0008QMtqMaztCPlOawJxdPx9kR3uy  3

MULTI_PROJECT_RESULT: This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.

UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with {"dashboard_context_projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application","langy"]}
[stderr]
- Running statement...
✔ 2 rows in 4ms
(exit 0)
```

**QP19 CLI -o json** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run -o json --sources application\,langy --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ AND\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
{
  "rows": [
    {
      "TenantId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "n": 9
    },
    {
      "TenantId": "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "n": 3
    }
  ],
  "params": {
    "dashboard_context_projects": [
      "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"
    ],
    "dashboard_context_sources": [
      "application",
      "langy"
    ]
  },
  "diagnostics": [
    {
      "code": "MULTI_PROJECT_RESULT",
      "message": "This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.",
      "meta": {
        "projectCount": 2
      }
    },
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "qp9171b.trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]

(exit 0)
```

**QP19 CLI --format json** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --format json --sources application\,langy --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ AND\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
{
  "rows": [
    {
      "TenantId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "n": 9
    },
    {
      "TenantId": "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "n": 3
    }
  ],
  "params": {
    "dashboard_context_projects": [
      "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"
    ],
    "dashboard_context_sources": [
      "application",
      "langy"
    ]
  },
  "diagnostics": [
    {
      "code": "MULTI_PROJECT_RESULT",
      "message": "This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.",
      "meta": {
        "projectCount": 2
      }
    },
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "qp9171b.trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]

(exit 0)
```

**QP19 CLI --format csv (params on stderr)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --format csv --sources application\,langy --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ AND\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
TenantId,n
project_0008PfpfHW74BqNiMUxEzhXwQyuC0,9
project_0008QMtqMaztCPlOawJxdPx9kR3uy,3
[stderr]
- Running statement...
✔ 2 rows in 8ms
{"params":{"dashboard_context_projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application","langy"]}}
(exit 0)
```

**QP01 CLI no --sources, -o json** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run -o json --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]
{
  "rows": [
    {
      "n": 6
    }
  ],
  "params": {
    "dashboard_context_sources": [
      "application"
    ]
  },
  "diagnostics": [
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "qp9171b.trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]

(exit 0)
```

**QP05/QP29 CLI table, SQL without parameter, --sources application** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --sources application --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics
[stdout]

n 
──
15

UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

SOURCES_IGNORED: This query doesn't read {dashboard_context_sources}, so it counts every origin.

Ran with {}
[stderr]
- Running statement...
✔ 1 row in 5ms
(exit 0)
```

**QP03e CLI org key, no --projects** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
- Running statement...
Error: Name the projects to query: pass --projects <id,id>
(exit 1)
```

**QP19 CLI blank --projects** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects '' SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
Error: --projects: pass a comma list
(exit 1)
```

**QP19 CLI blank --sources** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --sources '' --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
Error: --sources: pass a comma list
(exit 1)
```

**QP08 CLI unknown source** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --sources application\,bogus --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: The request body didn't match the expected shape.
Details:
  code      validation_error
  status    422
  trace id  9cad332d99d36339b7966965a526b916
  target    json
  fields    sources.1
  reasons   [{"code":"schema_failure","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","retryable":false,"meta":{"field":"sources.1","type":"invalid_value","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","expected":["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"],"received":"bogus"}}]
Suggestions:
  - Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected
  - Fix those fields and send the request again; retrying it unchanged will fail identically
(exit 1)
```

**QP15b/AC205b CLI WITH alias of a reserved name** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 WITH\ \'C\'\ AS\ dashboard_context_projects\ SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.
Details:
  code        lwql_reserved_parameter_supplied
  status      400
  trace id    85fbc25ac5ed9eb76d925e5b7da2b9ab
  parameters  dashboard_context_projects
Suggestions:
  - Read `meta.parameters`; it lists the reserved names the request set for itself
  - `dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`
  - `dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead
  - `dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead
(exit 1)
```

**QP10 CLI another org's project** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects project_0008VSNhu43L0A3UgdAqjkTTaYcZg SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: Project not found
Details:
  code      project_not_found
  status    404
  trace id  3c0d95a1319d9924b20edd7fe09c56c6
  trace_id  3c0d95a1319d9924b20edd7fe09c56c6
  span_id   7300cac69feaad22
Suggestions:
  - Check which project your API key belongs to
  - Create or select a project in the LangWatch dashboard
(exit 1)
```

**MCP run_query, add_dashboard_widget, update_dashboard_widget** (stdio client against mcp/typescript/dist/index.js built at 4dcb84db; mcp/ is unchanged at 624aa81; server at 624aa81; key: P-key; tool results only)
```
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result: | n |
| --- |
| 9 |

Returned 1 row in 4ms.
UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with these placeholders:
(json)
{
  "dashboard_context_sources": [
    "application",
    "langy"
  ]
}
(end json)
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}"}
result isError=true: Name the projects to query: pass `projects`, a list of project ids
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result: | n |
| --- |
| 15 |

Returned 1 row in 3ms.
UNBOUNDED_TIME_RANGE: qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.
SOURCES_IGNORED: This query doesn't read {dashboard_context_sources}, so it counts every origin.

Ran with these placeholders:
(json)
{}
(end json)
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH"]}
result isError=true: LangWatch API error 404: Project not found
**MCP run_query** {"sql":"WITH 'C' AS dashboard_context_projects SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result isError=true: LangWatch API error 400: The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.
Tips:
- Read `meta.parameters`; it lists the reserved names the request set for itself
- `dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`
- `dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead
- `dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["bogus"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result isError=true: LangWatch API error 422: The request body didn't match the expected shape.
Tips:
- Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected
- Fix those fields and send the request again; retrying it unchanged will fail identically
**MCP add_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","name":"MCP 4dcb app+langy, project Olga Org","code":"export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}
result: Widget "MCP 4dcb app+langy, project Olga Org" created and added to dashboard "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K".
**Widget ID**: widget_0008klQ9Tmw4Pi1vD96uwyt0Ahh1E
**Queries**: main
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_0008klQ9Tmw4Pi1vD96uwyt0Ahh1E","name":"MCP 4dcb renamed"}
result: Widget "MCP 4dcb renamed" updated on dashboard "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K".
**Widget ID**: widget_0008klQ9Tmw4Pi1vD96uwyt0Ahh1E
**Queries**: main

widget read back: [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_0008klQ9Tmw4Pi1vD96uwyt0Ahh1E","projects":null}
result: Widget "MCP 4dcb renamed" updated on dashboard "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K".
**Widget ID**: widget_0008klQ9Tmw4Pi1vD96uwyt0Ahh1E
**Queries**: main

widget read back: [{"name": "main", "sources": ["application", "langy"]}]
```

**AC210b/AC207b REST add widget, projects [Beta, Olga Org]** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "REST 624a Beta then Olga Org", "queries": [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
HTTP 201
{"id": "widget_0008kq5gnlDxzcu220sCUQ6wO1BCr", "name": "REST 624a Beta then Olga Org", "queries": [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
```

**AC210b REST PATCH naming no projects keeps the list** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X PATCH http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/widget_0008kq5gnlDxzcu220sCUQ6wO1BCr -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "REST 624a renamed", "queries": [{"name": "main"}]}
HTTP 200
{"id": "widget_0008kq5gnlDxzcu220sCUQ6wO1BCr", "name": "REST 624a renamed", "queries": [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
```

**AC210b REST PATCH projects null clears it** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X PATCH http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/widget_0008kq5gnlDxzcu220sCUQ6wO1BCr -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"queries": [{"name": "main", "projects": null}]}
HTTP 200
{"id": "widget_0008kq5gnlDxzcu220sCUQ6wO1BCr", "name": "REST 624a renamed", "queries": [{"name": "main", "sources": ["application", "langy"]}]}
```

**AC210c REST add widget naming secret project** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "AC210c secret", "queries": [{"name": "main", "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH"]}]}
HTTP 201
{"id": "widget_0008kqbrOQMqOHfNSKcmsnnp4pZE8", "name": "AC210c secret", "queries": [{"name": "main", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH"]}]}
```

**AC210c REST add widget naming otherorg project** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "AC210c otherorg", "queries": [{"name": "main", "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}]}
HTTP 404
{"type": "not_found", "code": "project_not_found", "message": "Project not found", "retryable": false, "trace_id": "652ccebef9b355cc7b2d25cfd6471ca9", "fault": "customer"}
```

**AC210c REST add widget naming missing project** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "AC210c missing", "queries": [{"name": "main", "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0000doesnotexist00000000000"]}]}
HTTP 404
{"type": "not_found", "code": "project_not_found", "message": "Project not found", "retryable": false, "trace_id": "8dd78b417cdb014b9952ded0849094c2", "fault": "customer"}
```

**AC207c REST add widget naming 101 project ids** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @w101.json
body: {"name": "AC207c 101", "queries": [{"name": "main", "projects": ["project_x000", "project_x001", "project_x002", "project_x003", "project_x004", "project_x005", "project_x006", "project_x007", "project_x008", "project_x009", "project_x010", "project_x011", "project_x012", "project_x013", "project_x0 ... (1683 chars)
HTTP 422
{"type": "unprocessable_entity", "code": "validation_error", "message": "The request body didn't match the expected shape.", "retryable": false, "meta": {"target": "json", "fields": ["queries.0.projects"], "reasons": [{"code": "schema_failure", "message": "projects holds at most 100 ids", "retryable": false, "meta": {"field": "queries.0.projects", "type": "too_big", "message": "projects holds at most 100 ids"}}]}, "trace_id": "68671a892e3b9b8bc6600f0089ef42c3", "tips": ["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected", "Fix those fields and send the request again; retrying it unchanged will fail identically"], "fault": "customer"}
```

**AC207c control: REST add widget naming 100 ids that do not exist** (key: P-key, a personal key scoped to project Olga Org)
```
$ curl -X POST http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets -H 'Authorization: Bearer <P-key>' --data-binary @wb.json
body: {"name": "AC207c 100", "queries": [{"name": "main", "projects": ["project_x000", "project_x001", "project_x002", "project_x003", "project_x004", "project_x005", "project_x006", "project_x007", "project_x008", "project_x009", "project_x010", "project_x011", "project_x012", "project_x013", "project_x0 ... (1667 chars)
HTTP 404
{"type": "not_found", "code": "project_not_found", "message": "Project not found", "retryable": false, "trace_id": "17a4194d0c32c9706c3e36ef2dfb4c9b", "fault": "customer"}
```

**cleanup: delete the AC210c secret widget** (2026-10-29T08:01:36Z, key: P-key)
```
$ curl -X DELETE http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/widget_0008kqbrOQMqOHfNSKcmsnnp4pZE8 -H 'Authorization: Bearer <P-key>'
HTTP 204



```

**AC210c/QP09 with Vic's organization key** (Vic is a Member of team Olga Org and cannot read Secret; X-Project-Id names Olga Org for the widget write)
```
--- w-secret: HTTP/1.1 403 Forbidden {"type":"permission_denied","code":"api_key_permission_denied","message":"API Key does not grant required permission: analytics:create","retryable":false,"meta":{"permission":"analytics:create"},"trace_id":"4c626239f51728a6305ecf124bfa4f1d","span_id":"ba8429d8ea2bd44e","trace":{"traceId":"4c626239f5
--- w-missing: HTTP/1.1 403 Forbidden {"type":"permission_denied","code":"api_key_permission_denied","message":"API Key does not grant required permission: analytics:create","retryable":false,"meta":{"permission":"analytics:create"},"trace_id":"d56c05601cd9610e43ac70f9c4bb3537","span_id":"b225f5a0d708de4e","trace":{"traceId":"d56c05601c
--- q-secret: HTTP/1.1 404 Not Found {"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"4eb2e3bb87085c81203dc3d34200b3ca","span_id":"1a4314c38976b3b1","trace":{"traceId":"4eb2e3bb87085c81203dc3d34200b3ca","spanId":"1a4314c38976b3b1"},"fault":"customer"}
--- q-missing: HTTP/1.1 404 Not Found {"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"010e4733834f50128074c404acc3cf5f","span_id":"13fea9298b2468b8","trace":{"traceId":"010e4733834f50128074c404acc3cf5f","spanId":"13fea9298b2468b8"},"fault":"customer"}
widget write, Secret vs missing body (trace ids removed): IDENTICAL
query, Secret vs missing body (trace ids removed): IDENTICAL
```

**AC210c read back after the two rewritten saves** (GET /api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets, widget widget_0008Wg8eEwxR49Xwf8sY9XSGPDBbs, sql left out; key: P-key)
```
{"name": "Application and Langy", "queries": [{"name": "main", "sources": ["application", "langy"]}]}
```

**AC210c session door: Vic's editor Save of 'Application and Langy' (picked Beta), the outgoing dashboardWidgets.update rewritten in the browser to add Secret, then an id that does not exist** (traceId and spanId replaced by <id>)
```
== secret
[
 {
  "url": "/api/trpc/dashboardWidgets.update",
  "status": 404,
  "text": "{\"error\":{\"message\":\"project_not_found\",\"code\":-32004,\"data\":{\"code\":\"NOT_FOUND\",\"httpStatus\":404,\"path\":\"dashboardWidgets.update\",\"cause\":null,\"error\":{\"code\":\"project_not_found\",\"kind\":\"project_not_found\",\"meta\":{},\"traceId\":\"<id>\",\"spanId\":\"<id>\",\"httpStatus\":404,\"fault\":\"customer\",\"retryable\":false,\"reasons\":[]},\"authored\":false,\"traceId\":\"<id>\"}}}"
 }
]
visible error text: ["Looking for the old Analytics? It is still here.\nOpen Analytics","Project not found\nIt may have been deleted, or it isn't shared with you. Reload to see the projects you can open.\nCopy error ID","Project not found","It may have been deleted, or it isn't shared with you. Reload to see the projects you can open."]
== missing
[
 {
  "url": "/api/trpc/dashboardWidgets.update",
  "status": 404,
  "text": "{\"error\":{\"message\":\"project_not_found\",\"code\":-32004,\"data\":{\"code\":\"NOT_FOUND\",\"httpStatus\":404,\"path\":\"dashboardWidgets.update\",\"cause\":null,\"error\":{\"code\":\"project_not_found\",\"kind\":\"project_not_found\",\"meta\":{},\"traceId\":\"<id>\",\"spanId\":\"<id>\",\"httpStatus\":404,\"fault\":\"customer\",\"retryable\":false,\"reasons\":[]},\"authored\":false,\"traceId\":\"<id>\"}}}"
 }
]
visible error text: ["Looking for the old Analytics? It is still here.\nOpen Analytics","Project not found\nIt may have been deleted, or it isn't shared with you. Reload to see the projects you can open.\nCopy error ID","Project not found","It may have been deleted, or it isn't shared with you. Reload to see the projects you can open."]
```
```
secret vs missing tRPC body (ids replaced): IDENTICAL
```

**QP18/QP02 tRPC owner, projects [P], sources [application,langy]** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":9}],"statistics":{"elapsedMs":13,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application","langy"]}}}}

```

**QP02 tRPC owner, card run storing no projects (no projects key)** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)}","parameters":{},"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":7,"rowsRead":27,"bytesRead":1575,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}}}

```

**AC208d/QP10 tRPC owner names another org's project** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["application","langy"],"projects":["project_0008VSNhu43L0A3UgdAqjkTTaYcZg"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"63e965d74bada61a9dbd856b2f3dff3e","spanId":"ad1bd85c2524f131","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"63e965d74bada61a9dbd856b2f3dff3e"}}}

```

**AC208d tRPC owner names an id that does not exist** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["application","langy"],"projects":["project_0000doesnotexist00000000000"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"acfc388ce7af21fd7493407f2aaf3773","spanId":"5f1438eeb5989e42","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"acfc388ce7af21fd7493407f2aaf3773"}}}

```

**QP09c tRPC member names a project of the org he cannot read (Secret)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["application","langy"],"projects":["project_0008RvvmwglxZMZ0yVpjAsI6sPVoH"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"2c2ce05dce312dd947b6534b6c4a13cb","spanId":"0c4e59c20eae80ce","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"2c2ce05dce312dd947b6534b6c4a13cb"}}}

```

**AC208d/QP10/QP09c tRPC 404 bodies compared** (traceId and spanId replaced by <id>)
```
other org vs missing id: IDENTICAL
unreadable same-org project (member session) vs missing id: IDENTICAL
ids found in the three bodies: 0
```

**QP08 tRPC unknown source** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"sources":["bogus"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 400 Bad Request
{"error":{"message":"validation_error","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,"path":"analytics.lwql.query","cause":null,"error":{"code":"validation_error","kind":"validation_error","meta":{"fieldErrors":{"sources":["Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\""]},"formErrors":[]},"httpStatus":422,"fault":"customer","retryable":false,"reasons":[]},"authored":false}}}

```

**QP15b/AC205b tRPC WITH alias of a reserved name** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"WITH 'C' AS dashboard_context_projects SELECT count() AS n FROM trace_metrics","parameters":{},"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 400 Bad Request
{"error":{"message":"lwql_reserved_parameter_supplied","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,"path":"analytics.lwql.query","cause":null,"error":{"code":"lwql_reserved_parameter_supplied","kind":"lwql_reserved_parameter_supplied","meta":{"parameters":["dashboard_context_projects"]},"traceId":"407417d9e59923eaba296e3fcd87c124","spanId":"fc1d2e5350a672a0","httpStatus":400,"fault":"customer","retryable":false,"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"reasons":[]},"authored":false,"traceId":"407417d9e59923eaba296e3fcd87c124"}}}

```

**AC207c tRPC card run naming 101 project ids** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{},"projects":["project_x000", "project_x001", "project_x002", "project_x003", "project_x004", "project_x005", "project_x006", "project_x007", "project_x008", "project_x009", "project_x010", "project_x011", "project_x012", "project_x013", "project_x014", "project_x015", "project_x016", "project_x017", "project_x018", "project_x019", "project_x020", "project_x021", "project_x022", "project_x023", "project_x024", "project_x025", "project_x026", "project_x027", "project_x028", "project_x029", "project_x030", "project_x031", "project_x032", "project_x033", "project_x034", "project_x035", "project_x036", "project_x037", "project_x038", "project_x039", "project_x040", "project_x041", "project_x042", "project_x043", "project_x044", "project_x045", "project_x046", "project_x047", "project_x048", "project_x049", "project_x050", "project_x051", "project_x052", "project_x053", "project_x054", "project_x055", "project_x056", "project_x057", "project_x058", "project_x059", "project_x060", "project_x061", "project_x062", "project_x063", "project_x064", "project_x065", "project_x066", "project_x067", "project_x068", "project_x069", "project_x070", "project_x071", "project_x072", "project_x073", "project_x074", "project_x075", "project_x076", "project_x077", "project_x078", "project_x079", "project_x080", "project_x081", "project_x082", "project_x083", "project_x084", "project_x085", "project_x086", "project_x087", "project_x088", "project_x089", "project_x090", "project_x091", "project_x092", "project_x093", "project_x094", "project_x095", "project_x096", "project_x097", "project_x098", "project_x099", "project_x100"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 400 Bad Request
{"error":{"message":"validation_error","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,"path":"analytics.lwql.query","cause":null,"error":{"code":"validation_error","kind":"validation_error","meta":{"fieldErrors":{"projects":["projects holds at most 100 ids"]},"formErrors":[]},"httpStatus":422,"fault":"customer","retryable":false,"reasons":[]},"authored":false}}}

```

**QP17b saved-chart card run, onBudgetOverflow coarsen, 30-day period at a 1-second grain** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.savedWorkbenchCharts.run -H 'Cookie: <session>' -d '{"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","id":"chart_0008gFk4k6lA3JQaTxvnQXBAvkhc3","granularitySeconds":1,"onBudgetOverflow":"coarsen","timeWindow":{"start":"2026-09-29T00:00:00.000Z","end":"2026-10-29T00:00:00.000Z"}}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"t","type":"DateTime"},{"name":"n","type":"UInt64"}],"rows":[],"statistics":{"elapsedMs":6,"rowsRead":5,"bytesRead":585,"rowsReturned":0},"diagnostics":[{"code":"GRANULARITY_COARSENED","message":"The period is too long for 1-second steps, so the query ran at 3600-second steps.","meta":{"requestedSeconds":1,"granularitySeconds":3600}}],"followsTimeWindow":true,"followsGranularity":true,"granularitySeconds":3600,"coarsenedFromSeconds":1,"completeness":{"state":"no_traffic","unit":"traces","total":0,"fields":[],"buckets":[{"start":"2026-09-29T00:00:00Z","n":0},{"start":"2026-09-29T01:00:00Z","n":0},{"start":"2026-09-29T02:00:00Z","n":0},{"start":"2026-09-29T03:00:00Z","n":0},{"start":"2026-09-29T04:00:00Z","n":0},{"start":"2026-09-29T05:00:00Z","n":0},{"start":"2026-09-29T06:00:00Z","n":0},{"start":"2026-09-29T07:00:00Z","n":0},{"start":"2026-09-29T08:00:00Z","n":0},{"start":"2026-09-29T09:00:00Z","n":0},{"start":"2026-09-29T10:00:00Z","n":0},{"start":"2026-09-29T11:00:00Z","n":0},{"start":"2026-09-29T12:00:00Z","n":0},{"start":"2026-09-29T13:00:00Z","n":0},{"start":"2026-09-29T14:00:00Z","n":0},{"start":"2026-09-29T15:00:00Z","n":0},{"start":"2026-09-29T16:00:00Z","n":0},{"start":"2026-09-29T17:00:00Z","n":0},{"start":"2026-09-29T18:00:00Z","n":0},{"start":"2026-09-29T19:00:00Z","n":0},{"start":"2026-09-29T20:00:00Z","n":0},{"start":"2026-09-29T21:00:00Z","n":0},{"start":"2026-09-29T22:00:00Z","n":0},{"start":"2026-09-29T23:00:00Z","n":0},{"start":"2026-09-30T00:00:00Z","n":0},{"start":"2026-09-30T01:00:00Z","n":0},{"start":"2026-09-30T02:00:00Z","n":0},{"start":"2026-09-30T03:00:00Z","n":0},{"start":"2026-09-30T04:00:00Z","n":0},{"start":"2026-09-30T05:00:00Z","n":0},{"start":"2026-09-30T06:00:00Z","n":0},{"start":"2026-09-30T07:00:00Z","n":0},{"start":"2026-09-30T08:00:00Z","n":0},{"start":"2026-09-30T09:00:00Z","n":0},{"start":"2026-09-30T10:00:00Z","n":0},{"start":"2026-09-30T11:00:00Z","n":0},{"start":"2026-09-30T12:00:00Z","n":0},{"start":"2026-09-30T13:00:00Z","n":0},{"start":"2026-09-30T14:00:00Z","n":0},{"start":"2026-09-30T15:00:00Z","n":0},{"start":"2026-09-30T16:00:00Z","n":0},{"start":"2026-09-30T17:00:00Z","n":0},{"start":"2026-09-30T18:00:00Z","n":0},{"start":"2026-09-30T19:00:00Z","n":0},{"start":"2026-09-30T20:00:00Z","n":0},{"start":"2026-09-30T21:00:00Z","n":0},{"start":"2026-09-30T22:00:00Z","n":0},{"start":"2026-09-30T23:00:00Z","n":0},{"start":"2026-10-01T00:00:00Z","n":0},{"start":"2026-10-01T01:00
```

**QP17b the same coarsened run, params and diagnostics read from the full answer**
```
params: {"period": {"start": "2026-09-29T00:00:00.000Z", "end": "2026-10-29T00:00:00.000Z"}, "dashboard_context_sources": ["application"], "dashboard_context_granularity_seconds": 3600}
diagnostics: [{"code": "GRANULARITY_COARSENED", "message": "The period is too long for 1-second steps, so the query ran at 3600-second steps.", "meta": {"requestedSeconds": 1, "granularitySeconds": 3600}}]
granularitySeconds: 3600 coarsenedFromSeconds: 1
```

**QP17b control: same chart, coarsen mode, 1-day period at a 3600-second grain** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.savedWorkbenchCharts.run -H 'Cookie: <session>' -d '{"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","id":"chart_0008gFk4k6lA3JQaTxvnQXBAvkhc3","granularitySeconds":3600,"onBudgetOverflow":"coarsen","timeWindow":{"start":"2026-10-28T08:00:00.000Z","end":"2026-10-29T08:00:00.000Z"}}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"t","type":"DateTime"},{"name":"n","type":"UInt64"}],"rows":[{"t":"2026-10-29 05:00:00","n":4},{"t":"2026-10-29 06:00:00","n":2}],"statistics":{"elapsedMs":7,"rowsRead":27,"bytesRead":2130,"rowsReturned":2},"diagnostics":[],"followsTimeWindow":true,"followsGranularity":true,"granularitySeconds":3600,"completeness":{"state":"complete","unit":"traces","total":15,"fields":[],"buckets":[{"start":"2026-10-28T08:00:00Z","n":0},{"start":"2026-10-28T09:00:00Z","n":0},{"start":"2026-10-28T10:00:00Z","n":0},{"start":"2026-10-28T11:00:00Z","n":0},{"start":"2026-10-28T12:00:00Z","n":0},{"start":"2026-10-28T13:00:00Z","n":0},{"start":"2026-10-28T14:00:00Z","n":0},{"start":"2026-10-28T15:00:00Z","n":0},{"start":"2026-10-28T16:00:00Z","n":0},{"start":"2026-10-28T17:00:00Z","n":0},{"start":"2026-10-28T18:00:00Z","n":0},{"start":"2026-10-28T19:00:00Z","n":0},{"start":"2026-10-28T20:00:00Z","n":0},{"start":"2026-10-28T21:00:00Z","n":0},{"start":"2026-10-28T22:00:00Z","n":0},{"start":"2026-10-28T23:00:00Z","n":0},{"start":"2026-10-29T00:00:00Z","n":0},{"start":"2026-10-29T01:00:00Z","n":0},{"start":"2026-10-29T02:00:00Z","n":0},{"start":"2026-10-29T03:00:00Z","n":0},{"start":"2026-10-29T04:00:00Z","n":0},{"start":"2026-10-29T05:00:00Z","n":4},{"start":"2026-10-29T06:00:00Z","n":11},{"start":"2026-10-29T07:00:00Z","n":0}]},"params":{"period":{"start":"2026-10-28T08:00:00.000Z","end":"2026-10-29T08:00:00.000Z"},"dashboard_context_sources":["application"],"dashboard_context_granularity_seconds":3600}}}}

```
```
control diagnostics: [] rows 2
```

**AC208 member (Vic, Member of team Olga Org, not of Hidden Team) opens the board: the tRPC card run for widget 'Uses Secret'** (captured from the browser's network)
```
tRPC calls naming Secret: 1
{"status":404,"req":"{\"sql\":\"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId\",\"parameters\":{},\"granularitySeconds\":86400,\"sources\":[\"application\"],\"projects\":[\"project_0008PfpfHW74BqNiMUxEzhXwQyuC0\",\"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH\"],\"timeWindow\":{\"start\":\"2026-09-29T08:06:00.000Z\",\"end\":\"2026-10-29T08:06:00.000Z\"},\"projectId\":\"project_0008PfpfHW74BqNiMUxEzhXwQyuC0\"}","body":"{\"error\":{\"message\":\"project_not_found\",\"code\":-32004,\"data\":{\"code\":\"NOT_FOUND\",\"httpStatus\":404,\"path\":\"analytics.lwql.query\",\"cause\":null,\"error\":{\"code\":\"project_not_found\",\"kind\":\"project_not_found\",\"meta\":{},\"traceId\":\"<id>\",\"spanId\":\"<id>\",\"httpStatus\":404,\"fault\":\"customer\",\"retryable\":false,\"reasons\":[]},\"authored\":false,\"traceId\":\"<id>\"}}}"}
ClickHouse system.query_log rows naming the Secret project id over both loads (dark and light) since 2026-10-29 08:05:53: 0
rows from the lwql users over the same loads (the other cards): 20
```

**AC207/AC208b member editor (Vic) for widget 'Uses Secret'** (stack at 624aa81; Gamma is archived, Vic can read Olga Org, Beta and his Personal Workspace, not Secret)
```
projects row: projects = Olga Org 1 project you can't read Add project built-in
sources row: sources = application Add source built-in
Add project menu: [ 'Beta', 'Personal Workspace' ]
projects row: projects = Olga Org 1 project you can't read Add project built-in
sources row: sources = application Add source built-in
Add project menu: [ 'Beta', 'Personal Workspace' ]
--- Remove on the hidden entry:
projects row after Remove: projects = Olga Org Add project built-in
runs after Remove: [{"t":1793266121285,"status":200,"req":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
preview frame text: project_0008PfpfHW74BqNiMUxEzhXwQyuC0: 6
```

**AC209 read back before the edit** (GET /api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets, widget widget_0008WfcTeHoYfUmbEp7xl9lNiOnab, sql left out; key: P-key)
```
{"name": "Application only", "queries": [{"name": "main", "sources": ["application"]}]}
```

**AC209 read back after the edit, before Save** (GET /api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets, widget widget_0008WfcTeHoYfUmbEp7xl9lNiOnab, sql left out; key: P-key)
```
{"name": "Application only", "queries": [{"name": "main", "sources": ["application"]}]}
```

**AC209/AC207b read back after Save** (GET /api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets, widget widget_0008WfcTeHoYfUmbEp7xl9lNiOnab, sql left out; key: P-key)
```
{"name": "Application only", "queries": [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
```

**AC209 read back after Undo** (GET /api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets, widget widget_0008WfcTeHoYfUmbEp7xl9lNiOnab, sql left out; key: P-key)
```
{"name": "Application only", "queries": [{"name": "main", "sources": ["application"]}]}
```

**AC209/AC207b/AC207 owner editor walk on widget 'Application only'** (stack at 624aa81; lwql preview requests captured from the browser; read-backs over REST, recorded above)
```
before: {"name": "Application only", "queries": [{"name": "main", "sources": ["application"]}]}
rows: sources = application Add source built-in | projects = Olga Org (the board's project) Add project built-in | preview 6 traces
after +langy: runs [{"t":1793266156543,"sources":["application","langy"]}] preview 9 traces
project menu (board follows): [ 'Olga Org', 'Beta', 'Secret', 'Personal Workspace' ]
project menu after Beta: [ 'Olga Org', 'Secret', 'Personal Workspace' ]
after +Beta +Olga Org: row projects = Beta Olga Org Add project built-in runs [{"t":1793266161434,"sources":["application","langy"],"projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy"]},{"t":1793266165208,"sources":["application","langy"],"projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}] preview 12 traces
still stored before Save: {"name": "Application only", "queries": [{"name": "main", "sources": ["application"]}]}
card after save: Application only Sources: application, langy · Projects: Beta, Olga Org
stored after Save: {"name": "Application only", "queries": [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
undo buttons: 1
stored after Undo: {"name": "Application only", "queries": [{"name": "main", "sources": ["application"]}]}
```

**AC204b editor for widget 'Ignores sources' (SQL: SELECT count() AS n FROM trace_metrics)** (stack at 624aa81; 'ignores sources' matches only the widget title; the spec string 'This query ignores sources' is not on the page)
```
dark sources row: sources = application Add source The SQL does not read {dashboard_context_sources} built-in | Add source disabled: true title: The SQL does not read {dashboard_context_sources}
dialog mentions 'ignores sources': true | mentions SOURCES_IGNORED message: false
light sources row: sources = application Add source The SQL does not read {dashboard_context_sources} built-in | Add source disabled: true title: The SQL does not read {dashboard_context_sources}
dialog mentions 'ignores sources': true | mentions SOURCES_IGNORED message: false
```

**P0 setup check: SELECT * FROM traces LIMIT 1 with Input/Output restricted to admins** (2026-10-29T09:34:32Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT * FROM traces LIMIT 1","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"86c85fbb4bfdf65e366143f66ff0de24","span_id":"b93fc08be249b0cd","trace":{"traceId":"86c85fbb4bfdf65e366143f66ff0de24","spanId":"b93fc08be249b0cd"},"fault":"customer"}


```

**P0 setup check: SELECT count() AS n FROM traces with Input/Output restricted to admins** (2026-10-29T09:34:33Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT count() AS n FROM traces","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"bee40aea4cc2b984afa82ebbb66d60aa","span_id":"fbe6f34430567b48","trace":{"traceId":"bee40aea4cc2b984afa82ebbb66d60aa","spanId":"fbe6f34430567b48"},"fault":"customer"}


```

**P0 setup check: SELECT * FROM traces LIMIT 1 with Input/Output restricted to admins** (2026-10-29T09:34:34Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT * FROM traces LIMIT 1","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_not_permitted","message":"The submitted SQL is not permitted by the LangWatchQL analytics policy.","retryable":false,"meta":{"violations":[{"code":"WILDCARD_NOT_ALLOWED","clause":"projection","message":"List the fields you need by name — a wildcard cannot be used here, because some fields are not available to you.","hint":"List the fields you need by name instead of using a wildcard.","at":{"line":1,"column":8}}]},"trace_id":"67a1e255de1e8e45bf1ff20d74b45e2b","span_id":"d65abb9f9b2885f6","trace":{"traceId":"67a1e255de1e8e45bf1ff20d74b45e2b","spanId":"d65abb9f9b2885f6"},"tips":["Read `meta.violations`; each entry names the rule (`code`) and the clause (`clause`) that was refused","Submit one read-only SELECT; writes, DDL, SETTINGS, FORMAT, INTO OUTFILE and table functions are all refused","Read only the datasets the schema endpoint lists for this key, and select fields by name rather than with `*`"],"fault":"customer"}


```

**P0 setup check: SELECT count() AS n FROM traces with Input/Output restricted to admins** (2026-10-29T09:34:34Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT count() AS n FROM traces","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.traces was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.traces","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**P0 / AC202f: stock boards opened by Vic (Member) while project Olga Org restricts Input and Output to admins** (stack at 2ef801f with LWQL_POSTGRES_HOST=localhost; card runs counted from the browser's network; a SELECT * over traces is refused for these keys, see the next block)
```
== Release check dark
url: /olga-org-wQyuC0/dashboards/curated/release
cards: 5
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
not permitted on page: 0
lwql statuses: {"200":13}
lwql errors: 0 []
== Can I trust my numbers dark
url: /olga-org-wQyuC0/dashboards/curated/data
cards: 4
 - What do you want to know? Ask Is my data complete? Sources: application Are my cost figures complete? Sources: application Which of my traces are noise? Sources: application How much of my traffic is evaluated? Sources: 
 - What do you want to know? Ask Is my data complete? Sources: application Are my cost figures complete? Sources: application Which of my traces are noise? Sources: application How much of my traffic is evaluated? Sources: 
 - What do you want to know? Ask Is my data complete? Sources: application Are my cost figures complete? Sources: application Which of my traces are noise? Sources: application How much of my traffic is evaluated? Sources: 
 - What do you want to know? Ask Is my data complete? Sources: application Are my cost figures complete? Sources: application Which of my traces are noise? Sources: application How much of my traffic is evaluated? Sources: 
not permitted on page: 0
lwql statuses: {"200":8}
lwql errors: 0 []
== Release check light
url: /olga-org-wQyuC0/dashboards/curated/release
cards: 5
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
 - What do you want to know? Ask Can the new version of my agent ship? Sources don't apply: this widget reads a view that keeps no origin Do my test suites keep passing? Sources don't apply: this widget reads a view that ke
not permitted on page: 0
lwql statuses: {"200":13}
lwql errors: 0 []
== Can I trust my numbers light
url: /olga-org-wQyuC0/dashboards/curated/data
cards: 4
 - What do you want to know? Ask Is my data complete? Sources: application Are my cost figures complete? Sources: application Which of my traces are noise? Sources: application How much of my traffic is evaluated? Sources: 
 - What do you want to know? Ask Is my data complete? Sources: application Are my cost figures complete? Sources: application Which of my traces are noise? Sources: application How much of my traffic is evaluated? Sources: 
 - What do you want to know? Ask Is my data complete? Sources: application Are my cost figures complete? Sources: application Which of my traces are noise? Sources: application How much of my traffic is evaluated? Sources: 
 - What do you want to know? Ask Is my data complete? Sources: application Are my cost figures complete? Sources: application Which of my traces are noise? Sources: application How much of my traffic is evaluated? Sources: 
not permitted on page: 0
lwql statuses: {"200":8}
lwql errors: 0 []
```

**P0/QP25 gate check: SELECT * FROM traces LIMIT 1 (Input/Output restricted to admins)** (2026-10-29T09:41:51Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT * FROM traces LIMIT 1","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_not_permitted","message":"The submitted SQL is not permitted by the LangWatchQL analytics policy.","retryable":false,"meta":{"violations":[{"code":"WILDCARD_NOT_ALLOWED","clause":"projection","message":"List the fields you need by name — a wildcard cannot be used here, because some fields are not available to you.","hint":"List the fields you need by name instead of using a wildcard.","at":{"line":1,"column":8}}]},"trace_id":"71d6f786849c0482156681c04e9f65be","span_id":"06f497deb42c8f33","trace":{"traceId":"71d6f786849c0482156681c04e9f65be","spanId":"06f497deb42c8f33"},"tips":["Read `meta.violations`; each entry names the rule (`code`) and the clause (`clause`) that was refused","Submit one read-only SELECT; writes, DDL, SETTINGS, FORMAT, INTO OUTFILE and table functions are all refused","Read only the datasets the schema endpoint lists for this key, and select fields by name rather than with `*`"],"fault":"customer"}


```

**P0/QP25 gate check: SELECT Comment FROM annotations LIMIT 1 (Input/Output restricted to admins)** (2026-10-29T09:41:52Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT Comment FROM annotations LIMIT 1","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_not_permitted","message":"The submitted SQL is not permitted by the LangWatchQL analytics policy.","retryable":false,"meta":{"violations":[{"code":"GATED_COLUMN","clause":"projection","message":"The field \"Comment\" is not available to you. Remove it from the query.","hint":"Remove the field, or use one of the columns named in this violation's availableColumns.","at":{"line":1,"column":8},"view":"qp9171b.annotations","missingGates":["output"]}]},"trace_id":"ee92ccd67c90af8e544eff8c82c40354","span_id":"d0b221165514ed96","trace":{"traceId":"ee92ccd67c90af8e544eff8c82c40354","spanId":"d0b221165514ed96"},"tips":["Read `meta.violations`; each entry names the rule (`code`) and the clause (`clause`) that was refused","Submit one read-only SELECT; writes, DDL, SETTINGS, FORMAT, INTO OUTFILE and table functions are all refused","Read only the datasets the schema endpoint lists for this key, and select fields by name rather than with `*`"],"fault":"customer"}


```

**QP22 SDK 2.0.0 body shape: query, parameters, projectId** (2026-10-29T09:41:53Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"query":"SELECT count() AS n FROM trace_metrics WHERE OccurredAt > now() - INTERVAL {days:UInt32} DAY","parameters":{"days":7},"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["sql"],"reasons":[{"code":"schema_failure","message":"Invalid input: expected string, received undefined","retryable":false,"meta":{"field":"sql","type":"invalid_type","message":"Invalid input: expected string, received undefined","expected":"string"}}]},"trace_id":"770904d907a0651fc6f3f76cbf24f4fc","span_id":"e4b32a64ff4d0932","trace":{"traceId":"770904d907a0651fc6f3f76cbf24f4fc","spanId":"e4b32a64ff4d0932"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP22 the same with sql** (2026-10-29T09:41:53Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE OccurredAt > now() - INTERVAL {days:UInt32} DAY","parameters":{"days":7},"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":12,"rowsRead":27,"bytesRead":1751,"rowsReturned":1},"diagnostics":[],"followsTimeWindow":false,"followsGranularity":false,"params":{"days":7}}


```

**AC210d/QP23 release-notes line** (docs/features/dashboards.mdx at 2ef801f)
```

Rolling back to a release before this one shows multi-project widgets for the board's
project only. A rollback is not supported for this feature.

```

**AC212 compiled skill text** (skills/_compiled/native/dashboard-widgets/SKILL.md at 2ef801f, lines 38 and 43 to 45)
```
`--queries-file` is a JSON array of named queries: `{ name, sql, parameters?, sources?, projects? }`. A widget's code calls a query by `name` — the two files are one unit.
- A query is kept to its `sources` **only where its SQL reads `{dashboard_context_sources:Array(String)}`**, for example `WHERE Source IN {dashboard_context_sources:Array(String)}` (the `Source` column of `trace_metrics` and `evaluation_metrics` is the origin: `application` for a missing one, `other` for an unlisted one; reach the other views through `(TenantId, TraceId) IN (SELECT TenantId, TraceId FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)})`). A query that does not read it counts every origin, and the editor warns "This query ignores sources". Every run answers with `params`, a flat map of each placeholder the SQL declares by its SQL name (`dashboard_context_sources`, `dashboard_context_projects`, your own) plus the `period`. Read `diagnostics` too: `SOURCES_IGNORED` means the query counts every origin whatever `sources` holds, and `GRANULARITY_COARSENED` means the step ran coarser than asked.
- `projects` lists the project ids the query reads, bound to `{dashboard_context_projects:Array(String)}`. A query that names none reads its board's project. Name only projects the user can read; a project the writer cannot read, one that does not exist and one of another organization are all refused with `project_not_found` (404) and no id.
- `{dashboard_context_sources:Array(String)}` and `{dashboard_context_projects:Array(String)}` are reserved like the period names: type `Array(String)`, never in `parameters`, never passed by you, and never assigned or aliased in the SQL (`SET param_…`, `WITH … AS dashboard_context_projects`) — all are refused with `lwql_reserved_parameter_supplied`.
--- grep counts in that file: SHARE_WINDOW_LIMITED 0, SOURCES_IGNORED 1, GRANULARITY_COARSENED 1, '--projects A,B' 2
```

**AC207d widget 'Uses Secret' stores [Olga Org, Secret]; Vic opens the board, is added to Hidden Team (Settings > Directory > Teams & projects > Hidden Team > Edit > Add Another, role Member, as the owner), then reloads** (stack at 2ef801f; no widget save between)
```
before: Uses Secret -> You can't read a project this widget uses
after:  Uses Secret -> project_0008PfpfHW74BqNiMUxEzhXwQyuC0: 6 / project_0008RvvmwglxZMZ0yVpjAsI6sPVoH: 4 (Sources: application · Projects: Olga Org, Secret)
```

**QP14 P-key, projects [P], SQL compares TenantId with the Secret project id** (2026-10-29T09:47:08Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId = 'project_0008RvvmwglxZMZ0yVpjAsI6sPVoH'","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":0}],"statistics":{"elapsedMs":12,"rowsRead":5,"bytesRead":585,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"qp9171b.trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```
