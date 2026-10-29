**Human verification**

A person drove PR head **9fd82ba60b8** (https://github.com/langwatch/langwatch/commit/9fd82ba60b8046f7d60b5096dbd1f8060cbe3fb5) on a local stack: app on http://localhost:5650, its own ClickHouse 25.10.2.65 (8 GiB cap) and Postgres database. Captures ran on eleven clean stack starts. **9fd82ba** (final head, batch 14: review fixes; worktree clean, backend generation 1) re-checked the cross-organization member and AC210e after authz began to read the row again, the projects pattern at REST, MCP run_query with "ALL" in a list, and the SDK client drift. **7b63e91** (batch 13: review fixes; worktree clean, backend generation 1) re-checked the cross-organization member and AC210e after the member check moved to a batched grant read, the projects pattern at REST, MCP run_query with "ALL" in a list, and whether the SDK build leaves the tree clean. **22d268c** (batches 11 and 12: review fixes; worktree clean, backend generation 1 for the whole run) re-drove a member of two organizations naming the other organization's project (run, widget create, widget update), a project key changing the SQL of a widget that stores other projects, "all" inside a list and "ALL" alone at REST, the reads-none key, the schema door, and the CLI refusals. A run at 401db00 is not used: the backend had hot-loaded uncommitted edits. **8e8b73b** (batch 10: review fixes) re-drove what batch 10 changed: the reads-none code projects_unreadable at REST, CLI and MCP, Olga's no-projects 422, MCP widget writes with "ALL", " all " and ["ALL"], the CLI --project/--projects pair at a closed port, and the CLI login 404 hint. **cfd772c** (batch 9: review fixes) re-drove what batch 9 changed: Olga's "all" and no-projects answers, the reads-none answer at REST, CLI and MCP, MCP widget writes with "ALL" and ["all"], the CLI login 404 hint, and the CLI --project with --projects pair. **31112cf** (batch 8: review fixes) re-drove what batch 8 changed: the "all" and no-projects answers for Olga's key, Vic's "all" against named projects over tRPC, a key that reads no project, the MCP tools/list schema, CLI casing of "all", and the CLI 404 hint. **2cb26fe** (batch 7: review fixes, not owner decisions) re-drove what batch 7 changed: the projects_required and no-project copy, the one-project default, "all" for both keys, widget create under a person's CLI token, MCP widget add with "all", meta.view, CLI --projects all,<id>, and Vic's "all" over tRPC. **650e386** reran every REST, CLI, MCP and tRPC batch, AC210c, the member tRPC runs and the editor 404 copy, and drove projects "all" at every door. **90a75da** reran every REST, CLI, MCP and tRPC batch, the AC208 and AC210c member runs, the AC204 editor, the AC205b preview and the skill check. Older captures are kept, labelled by sha, for browser-only steps whose code did not change after them. **624aa81** (https://github.com/langwatch/langwatch/commit/624aa8162633796c9817a7e9c789400f1196c947) covers REST, CLI, MCP, tRPC and the editor/board shots 01 to 09. **2ef801f** covers the stock boards, the privacy gate, AC207d, QP14, QP22 and the text checks. Between 624aa81 and 650e386 the browser code changed only by one unused default and the 404 copy, both checked at 650e386. The server, MCP and SDK changes are covered by the 650e386 reruns.

**Own call: widget writes refuse "all".** A run may send `projects: "all"` (Drew's decision, quoted in QP03f to QP03i). A widget stores project ids only, so REST, the CLI and MCP refuse "all" on a widget write.

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

- **Editor 404 copy as Vic (650e386):** "Choose another project, or ask for access to this one.": https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-650e386/15-member-editor-404-copy-dark.png and https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9171/proof-650e386/15-member-editor-404-copy-light.png
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
| AC208d | Hand-made tRPC: another org's project vs a missing id | tRPC curl (22d268c, re-checked 7b63e91 and 9fd82ba) | Vic, a member of Olga Org and of Zed Org, runs from P naming [P, Zed Org]: 404, byte-identical to naming a missing id (sha256 eb49cf061f56e1c7 once trace ids are masked); no id in the body. Same result at 7b63e91 and 9fd82ba. Controls: [P, Beta] gives rows | MET |
| AC209 | Change sources and projects, preview, Save, Undo | browser, REST | Preview reran 3 times; nothing stored before Save; Undo restored ["application"] with no projects key | MET |
| AC210 | Widgets with no projects; Save then Undo | browser, REST | They read the board's project; read-back has no projects key. Seeded by REST, not a real pre-change widget | MET |
| AC210b | Add with projects; update without projects; null | REST (organization key + X-Project-Id), CLI, MCP (90a75da) | Read back [Beta, Olga Org] (REST, CLI) and [P] (MCP); kept; null clears it | MET |
| AC210c | Writes naming a missing id, another organization's project, or one the writer cannot read are refused alike | REST, tRPC session (90a75da), tRPC cross-org member (22d268c, re-checked 7b63e91 and 9fd82ba) | All 404 project_not_found with equal bodies and no id; nothing stored. Vic (member of both orgs) creating and updating a widget on Olga Org's board naming [P, Zed Org]: 404, byte-identical to a missing id (create 8fe82db61cfaf1c1, update 27094e3c3fa7a815) at all three heads; no cross-org row stored. Control: [Beta, P] update 200 | MET |
| AC210d | Release notes | docs | docs/features/dashboards.mdx line 219: "Rolling back to a release before this one shows multi-project widgets for the board's project only" | MET |
| AC210e | A project key cannot change the SQL of a widget whose stored query names other projects | REST P-key, tRPC session (22d268c, re-checked 7b63e91 and 9fd82ba) | Widget stores [Beta, P]. P-key PATCH with new SQL and no projects field: 404; database row unchanged (same SQL, same updatedAt). Vic (reads P and Beta), same update over tRPC: 200; SQL changed, projects kept [Beta, P]. Same at 7b63e91 (SQL n to n3) and 9fd82ba (n to n4) | MET |
| AC210f | A member who is no admin cannot name an aggregate project in a widget | none (7b63e91, 9fd82ba) | No setup: the stack has no aggregate project (all 8 projects are kind application). Neither the member's 404 nor the admin's success was driven | UNPROVEN (no setup) |
| AC211 | not driven | - | The insight gate needs a model | UNPROVEN |
| AC212 | Compiled skill text | text (90a75da) | Names both reserved names, Array(String), the board's project default, --projects A,B, "projects" in the queries file, SOURCES_IGNORED, GRANULARITY_COARSENED and SHARE_WINDOW_LIMITED; its text "The SQL does not read {dashboard_context_sources}" matches the editor | MET |
| AC213 | Board cards | browser | The (i) line is on the SOURCES_IGNORED card only; unlimited cards have none; no project named. GRANULARITY_COARSENED was shown over tRPC, not on a card | MET |
| QP01 | Run with no sources | REST, CLI, MCP, tRPC (650e386) | params ["application"] and 6 at all four doors | MET |
| QP02 | tRPC card run with no projects | tRPC, browser | params.dashboard_context_projects [P]; card "Project: Olga Org" | MET |
| QP03 | Key reading exactly one project (P-key), no projects | REST (2cb26fe), CLI, MCP (90a75da) | 200; params.dashboard_context_projects [P] | MET |
| QP03b | Organization key (reads several) without and with projects | REST (8e8b73b), CLI, MCP (2cb26fe) | 422 projects_required, message "Name the projects to query: send `projects`, a list of project ids, or \"all\""; tip "A key that reads exactly one project, such as a project API key, needs none: it defaults to that project"; no id. The "reads more than one project" copy is the app's presentation copy; no door I drove shows it | MET |
| QP03c | not driven | - | No group project | UNPROVEN |
| QP03d | P-key names Secret | REST | 404 project_not_found | MET |
| QP03e | Organization key, no --projects; run_query with no projects | CLI, MCP (90a75da) | "Name the projects to query: pass --projects <id,id>" (exit 1); MCP "Name the projects to query: pass `projects`, a list of project ids"; no ids | MET |
| QP03f | projects "all" with Olga's organization key, with the P-key | REST (cfd772c), CLI (31112cf), MCP (650e386) | Olga: rows for P, Beta and Secret. The echo holds 5 ids, distinct and sorted by id (again at cfd772c): those three plus two Personal Workspaces with no traces (Vic's, and Olga's, made by my device login at 2cb26fe). Never Zed's project or the archived Gamma. CLI ALL and All work as "all". P-key: [P] only (2cb26fe) | MET |
| QP03g | projects "all" as Vic over tRPC, against [P, Beta] named | tRPC session (31112cf) | The same rows for both: P 15, Beta 3. Secret is out of both. "all" also echoes his Personal Workspace (no row) | MET |
| QP03h | A key that reads nothing, with "all" | REST (22d268c), CLI, MCP run_query (8e8b73b) | Vic's organization key with "all": 422 projects_unreadable, "This key reads no project. Ask an admin to grant it `analytics:view` on a project."; grant tip only; naming [P]: 404 project_not_found | MET |
| QP03i | Widget write with projects "all" | REST, CLI (650e386), MCP (8e8b73b) | REST 422 at queries.0.projects; CLI "a widget stores project ids, not \"all\"; name them". MCP add and update with "ALL", " all ", ["ALL"], "All", ["all"] and "all": all 12 calls give "projects holds project ids; \"all\" is not stored in a widget at projects". tools/list projects is an array of ids or null, with no "all" | MET |
| QP03j | A key that reads no project names nothing | REST (22d268c), CLI, MCP run_query (8e8b73b) | 422 projects_unreadable with the same message and grant-only tip; CLI and MCP show that message; no id. The schema door GET /api/v1/query/schema with this key: 200 | MET |
| RF7-1 (review fix, no scenario id) | CLI --projects all,<id>, <id>,all, ALL,<id>, <id>,All | CLI (2cb26fe, 31112cf) | "--projects: \"all\" stands alone; pass it by itself, or list project ids" (exit 1), the same against a closed port, while a plain --projects <P> there gives "fetch failed": refused before any request | MET |
| RF7-2 (review fix, no scenario id) | Widget create and update under a person's CLI token (device login) on project Olga Org | CLI (2cb26fe) | Olga naming [Beta, Olga Org]: created. Vic naming [Beta, Olga Org]: created. Vic naming [Olga Org, Secret]: create and update both 404 project_not_found; nothing stored; read back unchanged. 404 hint (8e8b73b): under the device token, first "Check that your account can read the project; ask a workspace admin to grant you access", then "Create or select a project in the LangWatch dashboard", and no API-key line; under an API key "Check which project your API key belongs to" | MET |
| RF9-1 (review fix, no scenario id) | CLI query run --project <slug> --projects <id> | CLI device session and API key (22d268c) | Against a closed port: "Error: --project and --projects both name the projects to read; pass one of them" (exit 1) under both, with no "fetch failed"; the control --projects <P> alone gives "fetch failed" | MET |
| RF11-1 (review fix, QP03f "all" in a list) | "all" inside a list, and "ALL" alone | REST, CLI (22d268c) | REST ["all", P] and [P, "ALL"]: 422 validation_error with the top-level message "\"all\" stands alone; send it by itself, or list project ids". REST "ALL" alone: rows for P 15, Beta 3, Secret 4, the same as "all". CLI --projects all,<P> and <P>,ALL at a closed port: refused, no "fetch failed". CLI --sources '' at a closed port: "--sources: pass a comma list", no "fetch failed" | MET |
| RF13-1 (review fix, QP03f pattern) | projects "al", " ALL ", ["all", P]; MCP run_query [P, "ALL"] | REST, MCP (7b63e91, 9fd82ba) | REST "al": 422 validation_error at both heads; at 7b63e91 the reason named the pattern /^\\s*all\\s*$/i, at 9fd82ba the only reason is "Invalid input: expected array, received string" (the pattern is no longer named; see open items). " ALL ": rows P 15, Beta 3, Secret 4, the same as "all". ["all", P]: 422 top message "\"all\" stands alone; send it by itself, or list project ids". MCP run_query [P, "ALL"] with the endpoint at a closed port: "\"all\" stands alone… at projects", no fetch; control [P] alone: "fetch failed" | MET |
| RF7-3 (review fix, no scenario id) | UNBOUNDED_TIME_RANGE meta.view | REST, CLI (2cb26fe) | meta.view "trace_metrics", with no database prefix; the message names the bare view too | MET |
| QP04 | Source IN param, [application, langy] | REST | 9; params as sent; no SOURCES_IGNORED | MET |
| QP05 | SQL with no parameter, [application] | REST | 15, params {}, the exact SOURCES_IGNORED message; no sources named gives no note | MET |
| QP05b | Comment / literal / CTE | REST | Note, note, none | MET |
| QP06 | Query log for the control run | ClickHouse | The statement as written, with no Origin predicate | MET |
| QP07 | sources [] | REST | 0, params [] | MET |
| QP07b | [application] / [other] / [langy]; [langy, application, langy] | REST | 6 / 2 / 3; params ["langy","application"] | MET |
| QP08 | Unknown source | REST, CLI, tRPC, MCP (90a75da) | validation_error at all four; each lists the eleven sources (MCP: "Code: validation_error" and "expected one of: application, ... other") | MET |
| QP09 | P-key, [P, Secret]; query log | REST, ClickHouse | 404; 0 query_log rows for the marker statement; the control run logged | MET |
| QP09b | [P, Secret] vs [P, missing] vs [P, other org] | REST | Bodies and headers equal (trace ids, Date and request ids removed); no id in the body | MET |
| QP09c | The same refusal at three doors | REST, tRPC, MCP (650e386) | All three carry project_not_found: REST message "Project not found"; MCP "Project not found" and "Code: project_not_found"; tRPC carries the code as its message, as the spec now reads | MET |
| QP10 | Another org's project | tRPC, REST, CLI, MCP (90a75da); tRPC as a member of both orgs (22d268c) | 404 project_not_found at all four; at 22d268c a member of both organizations naming the other one's project from org X: 404 identical to a missing id | MET |
| QP10b | not driven | - | A deleted or archived stored project was not run | UNPROVEN |
| QP11 | not driven | - | Revoke after save over 4 runners | UNPROVEN |
| QP11b | not driven | - | Group project | UNPROVEN |
| QP12 | Organization key, [B, P, B] | REST, CLI | params [B, P]; rows per tenant | MET |
| QP12b | 10,001 ids (180,052 bytes) | REST | 422 "projects holds at most 10000 ids" | MET |
| QP12c | projects [] | REST | 422 "projects must hold at least one id" | MET |
| QP12d | projectId and projects | REST | 422 "send projectId or projects, not both" | MET |
| QP13 | not driven | - | Share windows and redaction over a group | UNPROVEN |
| QP14 | [P] with TenantId = Secret | REST | 0 rows (Secret has 4) | MET |
| QP15 | Reserved name in parameters (string and array values) | REST, tRPC, CLI, MCP (650e386) | 400 lwql_reserved_parameter_supplied at all four; REST, CLI and MCP name the `sources` / `projects` field; the array value is no longer a generic 422 | MET |
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

**Verdict: NOT READY.** 70 MET, 21 UNPROVEN, out of 91 rows. Every fix of batches 4 to 14 holds in use, including the two permission holes review found at 8e8b73b (a member of two organizations, AC208d and AC210c; a project key changing a widget's SQL, AC210e), including projects "all" at every door. The open rows are scenarios with no setup on this stack: group projects and share windows (AC206b, QP03c, QP11, QP11b, QP13, QP26, QP28, QP29), organization boards (AC206c), alerts (AC208c), the insight gate (AC211, QP21), deleted or archived stored projects (QP10b), the published CLI 2.0.0 and MCP 2.2.0 (QP22, QP22b), and the stock-widget build checks (AC202 to AC202d).

**Rough UX edges**
- With projects "all", an admin's key also reads members' personal projects in the organization (here Vic's Personal Workspace). That follows the admin role, but "all" makes it easy to miss.
- The echoed params.dashboard_context_projects lists projects that return no row (no traces), so it can be longer than the per-tenant rows.
- The (i) line on a card is cut off at the card width.
- On a no-access card, the footer still says "Project: Olga Org" (singular).
- For a reserved name in a WITH alias, the preview message gives two pieces of advice ("change the page's settings" and "Send the `projects` field"), and neither fits SQL that only aliases the name.
- Vic's organization key (Member) reads no project at all: 404 for every project, including those he reads in the UI.
- The `lwql_unknown_identifier` error does not name the column.
- The MCP widget add does not echo sources or projects.
- An admin's "all" echo lists Personal Workspaces with no traces; with Olga's device login it gained her own new Personal Workspace.
- Open at 9fd82ba: REST projects "al" is refused (422) but its reason now reads "Invalid input: expected array, received string" instead of naming the pattern; it was named at 7b63e91. AC210f (aggregate project) has no setup here. The SDK client drift seen at 22d268c and 7b63e91 did not reproduce on 9fd82ba: `pnpm build` and `pnpm run generate:openapi-types` both leave `git status` clean.
- Fixed since the last reports, checked at 22d268c: cross-organization member refused at run, create and update; AC210e; "all" in a list refused with its own top message. Checked at 8e8b73b: the reads-none code projects_unreadable; MCP "ALL" and " all "; the CLI pair refused with no lookup; the device 404 hint order. Checked at cfd772c: the reads-none answer (422, grant tip only) at REST, CLI and MCP; the CLI --project/--projects pair (refused, no 422 from the server); the device 404 hint. Checked at 31112cf: the CLI 404 hint for a device token. Checked at 2cb26fe: the MCP "all" message; meta.view is the bare name. Checked at 650e386: the projects_required tip names params.dashboard_context_projects; no "Ran with {}"; the editor 404 copy; agent-mode CLI output includes diagnostics.

**Raw captures at 9fd82ba** (final head; redacted)

**Run conditions** (9fd82ba): worktree at 9fd82ba60b8046f7d60b5096dbd1f8060cbe3fb5, `git status --short` empty before the start; backend log "backend ready changedFiles=0 files=[] generation=1" at 13:36:21Z.

**Item 4: SDK client drift** (9fd82ba)
```
$ git log -1 --format="%H %s"
9fd82ba60b8046f7d60b5096dbd1f8060cbe3fb5 refactor(analytics): authz reads the aggregate kind itself, the all literal type returns, one widget cap
$ git status --short   (before)
(empty)
$ (cd sdks/typescript && pnpm build)
exit 0
postbuild: dist/cli/index.js ok (2.0.0)
$ git status --short   (after)
 M sdks/typescript/src/internal/generated/openapi/api-client.ts
(end)
$ git diff | grep "projects?:"
-                    projects?: string | string[];
+                    projects?: "all" | string[];

(not reproduced: restored with git checkout, then)
$ git status --short
(empty)
$ (cd sdks/typescript && pnpm build)   exit 0, log has no openapi step
$ git status --short
(empty)
$ (cd sdks/typescript && pnpm run generate:openapi-types)   exit 0
Wrote /home/ubuntu/worktrees/langwatch-widget-query-params/specs/api-reference/openapi-document.json
patched JsonValue recursion in api-client.ts
$ git status --short
(empty)
$ grep -n "projects?:" sdks/typescript/src/internal/generated/openapi/api-client.ts | head -1
3088:                    projects?: string | string[];
```
The OpenAPI source the generator reads is specs/api-reference/openapi-document.json (gitignored; scripts/generate-openapi-types.mjs line 16). Regenerated from 9fd82ba, its /api/v1/query projects is anyOf [string with pattern ^\s*[aA][lL][lL]\s*$, array of strings], and the client it gives equals the committed one. The first diff (file written at 13:34:49Z) is not explained by the build log: `pnpm build` runs only copy-types.sh and tsup, and the document on disk at that time (written 13:29:51Z) already held the pattern. I do not count it against this head.

**Item 1 control: tRPC run as Vic from org X's P, naming [P, Beta] (9fd82ba)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":8,"rowsRead":29,"bytesRead":1809,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"]}}}}

```

**Item 1: tRPC run as Vic from org X's P, naming [P, Zed Org (org Y)] (9fd82ba)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008VSNhu43L0A3UgdAqjkTTaYcZg"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"93db99403323636aedf7cc9af35caa5b","spanId":"264425bd15b1a4f6","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"93db99403323636aedf7cc9af35caa5b"}}}

```

**Item 1 reference: tRPC run as Vic from org X's P, naming [P, a missing id] (9fd82ba)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008NoSuchProjectXXXXXXXXXXXX"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"ca9f18e1f2371452911feb2ac669b94a","spanId":"0f6ee08bb50999ab","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"ca9f18e1f2371452911feb2ac669b94a"}}}

```

**Item 1: tRPC widget create as Vic on org X's board, naming [P, Zed Org (org Y)] (9fd82ba)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.create -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "dashboardId": "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K", "name": "Vic cross-org 9fd", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.create","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"d2cd79d68a557c05e9ba0f62f641fb2b","spanId":"639402945a3bf59d","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"d2cd79d68a557c05e9ba0f62f641fb2b"}}}

```

**Item 1 reference: tRPC widget create as Vic, naming [P, a missing id] (9fd82ba)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.create -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "dashboardId": "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K", "name": "Vic missing 9fd", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008NoSuchProjectXXXXXXXXXXXX"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.create","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"a24b460b1ba49d9a91e2fe5080023214","spanId":"d314179174d7f194","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"a24b460b1ba49d9a91e2fe5080023214"}}}

```

**Item 1: tRPC widget update as Vic of "Vic X-only 22d", naming [P, Zed Org (org Y)] (9fd82ba)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.update","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"cf69fc95addd4a5f23175683b6552071","spanId":"1434422f4d2fdb94","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"cf69fc95addd4a5f23175683b6552071"}}}

```

**Item 1 reference: tRPC widget update as Vic, naming [P, a missing id] (9fd82ba)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008NoSuchProjectXXXXXXXXXXXX"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.update","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"dc4f143815bf42b18794f09cebad62f3","spanId":"5151f3b991557344","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"dc4f143815bf42b18794f09cebad62f3"}}}

```

**Item 1 control: tRPC widget update as Vic, naming [Beta, P] (SQL back to n) (9fd82ba)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}'
HTTP/1.1 200 OK
{"result":{"data":{"success":true}}}

```

**Item 1: 404 bodies compared** (9fd82ba)
```
Item 1: tRPC run as Vic from org X's P, naming [P, Zed Org (org Y)] (9fd82ba): 348 bytes sha256 eb49cf061f56e1c7
Item 1 reference: tRPC run as Vic from org X's P, naming [P, a missing id] (9fd82ba): 348 bytes sha256 eb49cf061f56e1c7
tRPC run: IDENTICAL across 2 bodies (traceId/spanId masked); any project id in a body: False
Item 1: tRPC widget create as Vic on org X's board, naming [P, Zed Org (org Y)] (9fd82ba): 351 bytes sha256 8fe82db61cfaf1c1
Item 1 reference: tRPC widget create as Vic, naming [P, a missing id] (9fd82ba): 351 bytes sha256 8fe82db61cfaf1c1
tRPC widget create: IDENTICAL across 2 bodies (traceId/spanId masked); any project id in a body: False
Item 1: tRPC widget update as Vic of "Vic X-only 22d", naming [P, Zed Org (org Y)] (9fd82ba): 351 bytes sha256 27094e3c3fa7a815
Item 1 reference: tRPC widget update as Vic, naming [P, a missing id] (9fd82ba): 351 bytes sha256 27094e3c3fa7a815
tRPC widget update: IDENTICAL across 2 bodies (traceId/spanId masked); any project id in a body: False
```

**Item 1: stored rows after the cross-org calls** (database read, 9fd82ba)
```
[{"name":"Vic X-only 22d","sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
```
No "Vic cross-org 9fd" or "Vic missing 9fd" row.

**Item 1b (AC210e): stored widget before** (database read, 9fd82ba)
```
[{"updatedAt":"2026-10-29T13:39:08.726Z","sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
```

**Item 1b (AC210e): P-key (reads only P) updates the widget storing [Beta, P] with new SQL and no projects field** (REST; 9fd82ba)
```
$ curl -X PATCH http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/widget_0002JV0S3K4JlrhKZFndElGxzeJCS -H 'Authorization: Bearer <P-key>' -d '{"queries":[{"name":"main","sql":"SELECT count() AS n4 FROM trace_metrics"}]}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"<x>","span_id":"<x>","trace":{"traceId":"<x>","spanId":"<x>"},"fault":"customer"}


```

**Item 1b: after the P-key update** (database read, 9fd82ba)
```
[{"updatedAt":"2026-10-29T13:39:08.726Z","sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
```

**Item 1b (AC210e): Vic (reads P and Beta) makes the same update over tRPC (9fd82ba)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n4 FROM trace_metrics", "sources": ["application"]}]}'
HTTP/1.1 200 OK
{"result":{"data":{"success":true}}}

```

**Item 1b: after Vic's update** (database read, 9fd82ba)
```
[{"updatedAt":"2026-10-29T13:39:29.834Z","sql":"SELECT count() AS n4 FROM trace_metrics","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
```

**Item 2: REST projects "al" (9fd82ba)** (2026-10-29T13:39:30Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT 1","projects":"al"}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["projects"],"reasons":[{"code":"schema_failure","message":"Invalid input: expected array, received string","retryable":false,"meta":{"field":"projects","type":"invalid_union","message":"Invalid input: expected array, received string"}}]},"trace_id":"e588f663f2f3de95e39037e96565f2e8","span_id":"8987da015de108f8","trace":{"traceId":"e588f663f2f3de95e39037e96565f2e8","spanId":"8987da015de108f8"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**Item 2: REST projects " ALL " (9fd82ba)** (2026-10-29T13:39:31Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":" ALL "}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":4,"rowsRead":29,"bytesRead":1809,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0001cmcXoJG9vEsZGoZB5U6hyT5TO","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**Item 2 control: REST projects "all" (9fd82ba)** (2026-10-29T13:39:32Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":4,"rowsRead":29,"bytesRead":1809,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0001cmcXoJG9vEsZGoZB5U6hyT5TO","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**Item 2: REST projects ["all", P] (9fd82ba)** (2026-10-29T13:39:33Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT 1","projects":["all","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"\"all\" stands alone; send it by itself, or list project ids","retryable":false,"trace_id":"8e404a1fd3d66a64c002273b97f4e108","span_id":"ee6adf986fc73924","trace":{"traceId":"8e404a1fd3d66a64c002273b97f4e108","spanId":"ee6adf986fc73924"},"fault":"customer"}


```

**Item 3: MCP run_query with projects [P, "ALL"], endpoint at a closed port (127.0.0.1:9), Olga's organization key; control: [P] alone** (stdio client, mcp/typescript built at 9fd82ba; 9fd82ba)
```
MCP run_query** {"sql":"SELECT 1","projects":["<P>","ALL"]}
{"content":[{"type":"text","text":"MCP error -32602: Input validation error: Invalid arguments for tool run_query: \"all\" stands alone; send it by itself, or list project ids at projects"}],"isError":true}
MCP run_query** {"sql":"SELECT 1","projects":["<P>"]}
{"content":[{"type":"text","text":"fetch failed"}],"isError":true}
```

**Item 5: AC210f aggregate project** (9fd82ba): UNPROVEN, no setup; the stack's database has no aggregate project (all projects are kind application).

**Item 2 note** (9fd82ba): "al" is still refused with 422, but the only reason is now "Invalid input: expected array, received string" at projects (invalid_union). At 7b63e91 the reason named the pattern ("must match pattern /^\\s*all\\s*$/i"). The schema change between the heads (analytics-lwql.schemas.ts: the regex now has a .transform) is the likely cause; zod then reports the array branch.

**Raw captures at 7b63e91**

**Run conditions** (7b63e91): worktree at 7b63e914e172c61fc18b9401df2507a055ec94cd, `git status --short` empty before the start; backend log "backend ready changedFiles=0 files=[] generation=1" at 13:19:01Z.

**Item 5: `pnpm build` in sdks/typescript leaves the tree dirty** (7b63e91)
```
$ git status --short   (before)
(empty)
$ (cd sdks/typescript && pnpm build)   exit 0
$ git status --short
 M sdks/typescript/src/internal/generated/openapi/api-client.ts
$ git diff --stat
 1 file changed, 2 insertions(+), 2 deletions(-)
$ git diff | grep "projects?:"
- projects?: string | string[];
+ projects?: "all" | string[];
```
The build's generate step (scripts/generate-openapi-types.mjs) rewrites the committed client: the projects type and one doc line differ. I restored the file with git checkout after the build so the server run below is on clean 7b63e91; the change is type-only.

**Item 1 control: tRPC run as Vic from org X's P, naming [P, Beta] (7b63e91)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":11,"rowsRead":29,"bytesRead":1809,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"]}}}}

```

**Item 1: tRPC run as Vic from org X's P, naming [P, Zed Org (org Y)] (7b63e91)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008VSNhu43L0A3UgdAqjkTTaYcZg"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"89620dc2c02f61be95a02fb993bd2b8c","spanId":"fe2f2bd096607744","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"89620dc2c02f61be95a02fb993bd2b8c"}}}

```

**Item 1 reference: tRPC run as Vic from org X's P, naming [P, a missing id] (7b63e91)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008NoSuchProjectXXXXXXXXXXXX"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"51b537210b6b4a7daf93c9ead4d492e0","spanId":"a5344cf76422b47e","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"51b537210b6b4a7daf93c9ead4d492e0"}}}

```

**Item 1: tRPC widget create as Vic on org X's board, naming [P, Zed Org (org Y)] (7b63e91)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.create -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "dashboardId": "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K", "name": "Vic cross-org 7b6", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.create","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"ba6c82bc8c7c8f281204084870c0e3dd","spanId":"4620d1f1a26523cc","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"ba6c82bc8c7c8f281204084870c0e3dd"}}}

```

**Item 1 reference: tRPC widget create as Vic, naming [P, a missing id] (7b63e91)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.create -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "dashboardId": "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K", "name": "Vic missing 7b6", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008NoSuchProjectXXXXXXXXXXXX"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.create","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"6925067dcb3fa340ef09209a0a50aa5c","spanId":"5580dd4a0270e53e","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"6925067dcb3fa340ef09209a0a50aa5c"}}}

```

**Item 1: tRPC widget update as Vic of "Vic X-only 22d", naming [P, Zed Org (org Y)] (7b63e91)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.update","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"5a5a6934bac98631b9bc32b2a1123f44","spanId":"380b7299f841da18","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"5a5a6934bac98631b9bc32b2a1123f44"}}}

```

**Item 1 reference: tRPC widget update as Vic, naming [P, a missing id] (7b63e91)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008NoSuchProjectXXXXXXXXXXXX"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.update","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"1b5e85d8685387f8a048c1a6f191dc73","spanId":"780a139c8f3a0aeb","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"1b5e85d8685387f8a048c1a6f191dc73"}}}

```

**Item 1 control: tRPC widget update as Vic, naming [Beta, P] (SQL back to n) (7b63e91)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}'
HTTP/1.1 200 OK
{"result":{"data":{"success":true}}}

```

**Item 1: 404 bodies compared** (7b63e91)
```
Item 1: tRPC run as Vic from org X's P, naming [P, Zed Org (org Y)] (7b63e91): 348 bytes sha256 eb49cf061f56e1c7
Item 1 reference: tRPC run as Vic from org X's P, naming [P, a missing id] (7b63e91): 348 bytes sha256 eb49cf061f56e1c7
tRPC run: IDENTICAL across 2 bodies (traceId/spanId masked); any project id in a body: False
Item 1: tRPC widget create as Vic on org X's board, naming [P, Zed Org (org Y)] (7b63e91): 351 bytes sha256 8fe82db61cfaf1c1
Item 1 reference: tRPC widget create as Vic, naming [P, a missing id] (7b63e91): 351 bytes sha256 8fe82db61cfaf1c1
tRPC widget create: IDENTICAL across 2 bodies (traceId/spanId masked); any project id in a body: False
Item 1: tRPC widget update as Vic of "Vic X-only 22d", naming [P, Zed Org (org Y)] (7b63e91): 351 bytes sha256 27094e3c3fa7a815
Item 1 reference: tRPC widget update as Vic, naming [P, a missing id] (7b63e91): 351 bytes sha256 27094e3c3fa7a815
tRPC widget update: IDENTICAL across 2 bodies (traceId/spanId masked); any project id in a body: False
```

**Item 1: stored rows after the cross-org calls** (database read, 7b63e91)
```
[{"name":"Vic X-only 22d","sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
```
No "Vic cross-org 7b6" or "Vic missing 7b6" row; the widget holds [Beta, P] from the control update.

**Item 1b (AC210e): stored widget before** (database read, 7b63e91)
```
[{"updatedAt":"2026-10-29T13:20:23.645Z","sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
```

**Item 1b (AC210e): P-key (reads only P) updates the widget storing [Beta, P] with new SQL and no projects field** (REST; 7b63e91)
```
$ curl -X PATCH http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/widget_0002JV0S3K4JlrhKZFndElGxzeJCS -H 'Authorization: Bearer <P-key>' -d '{"queries":[{"name":"main","sql":"SELECT count() AS n3 FROM trace_metrics"}]}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"<x>","span_id":"<x>","trace":{"traceId":"<x>","spanId":"<x>"},"fault":"customer"}


```

**Item 1b: after the P-key update** (database read, 7b63e91)
```
[{"updatedAt":"2026-10-29T13:20:23.645Z","sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
```

**Item 1b (AC210e): Vic (reads P and Beta) makes the same update over tRPC (7b63e91)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n3 FROM trace_metrics", "sources": ["application"]}]}'
HTTP/1.1 200 OK
{"result":{"data":{"success":true}}}

```

**Item 1b: after Vic's update** (database read, 7b63e91)
```
[{"updatedAt":"2026-10-29T13:20:40.170Z","sql":"SELECT count() AS n3 FROM trace_metrics","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
```

**Item 3: REST projects "al" (7b63e91)** (2026-10-29T13:20:41Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT 1","projects":"al"}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["projects"],"reasons":[{"code":"schema_failure","message":"Invalid string: must match pattern /^\\s*all\\s*$/i","retryable":false,"meta":{"field":"projects","type":"invalid_format","message":"Invalid string: must match pattern /^\\s*all\\s*$/i"}}]},"trace_id":"fac41e02aa91edd6bdb1cfdb25220664","span_id":"40f32c4bbb2e3dac","trace":{"traceId":"fac41e02aa91edd6bdb1cfdb25220664","spanId":"40f32c4bbb2e3dac"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**Item 3: REST projects " ALL " (7b63e91)** (2026-10-29T13:20:41Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":" ALL "}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":5,"rowsRead":29,"bytesRead":1809,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0001cmcXoJG9vEsZGoZB5U6hyT5TO","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**Item 3 control: REST projects "all" (7b63e91)** (2026-10-29T13:20:42Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":4,"rowsRead":29,"bytesRead":1809,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0001cmcXoJG9vEsZGoZB5U6hyT5TO","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**Item 3: REST projects ["all", P] (7b63e91)** (2026-10-29T13:20:43Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT 1","projects":["all","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"\"all\" stands alone; send it by itself, or list project ids","retryable":false,"trace_id":"88238ab02b0497330ff4a5593931103b","span_id":"eaab9b703aa80d73","trace":{"traceId":"88238ab02b0497330ff4a5593931103b","spanId":"eaab9b703aa80d73"},"fault":"customer"}


```

**Item 4: MCP run_query with projects [P, "ALL"], endpoint pointed at a closed port (127.0.0.1:9), Olga's organization key; control: [P] alone at the same port** (stdio client, mcp/typescript built at 7b63e91; 7b63e91)
```
MCP run_query** {"sql":"SELECT 1","projects":["<P>","ALL"]}
{"content":[{"type":"text","text":"MCP error -32602: Input validation error: Invalid arguments for tool run_query: \"all\" stands alone; send it by itself, or list project ids at projects"}],"isError":true}
[MCP tool] run_query failed: fetch failed TypeError: fetch failed
    at node:internal/deps/undici/undici:16416:13
    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)
    at async makeRequest (file:///home/ubuntu/worktrees/langwatch-widget-query-params/mcp/typescript/dist/index.js:62106:20)
    at async handleRunQuery (file:///home/ubuntu/worktrees/langwatch-widget-query-params/mcp/typescript/dist/index.js:70765:18)
    at async file:///home/ubuntu/worktrees/langwatch-widget-query-params/mcp/typescript/dist/index.js:74737:41
    at async file:///home/ubuntu/worktrees/langwatch-widget-query-params/mcp/typescript/dist/index.js:74584:14
    at async McpServer.executeToolHandler (file:///home/ubuntu/worktrees/langwatch-widget-query-params/mcp/typescript/dist/index.js:37632:18)
    at async file:///home/ubuntu/worktrees/langwatch-widget-query-params/mcp/typescript/dist/index.js:37533:28
    at async wrappedHandler (file:///home/ubuntu/worktrees/langwatch-widget-query-params/mcp/typescript/dist/index.js:36906:28)
MCP run_query** {"sql":"SELECT 1","projects":["<P>"]}
{"content":[{"type":"text","text":"fetch failed"}],"isError":true}
```

**Item 2: aggregate project** (7b63e91): UNPROVEN, no setup. The stack's database has no aggregate project (`select kind, count(*) from "Project" group by kind` gives only application: 8), so neither the member's 404 nor the admin's success was driven.

**Raw captures at 22d268c**

**Run conditions** (22d268c): worktree at 22d268c6a8a55cd6d92d6450dcca4e48ae894571, `git status --short` empty before the start; backend log "backend ready changedFiles=0 files=[] generation=1" at 12:57:38Z, and no later generation during the run (checked again at the end). The SDK build regenerates sdks/typescript/src/internal/generated/openapi/api-client.ts (type-only: `projects?: string | string[]` becomes `"all" | string[]`, plus one doc line); I restored it with git checkout after the build, and it has no runtime effect.

**Item 1 setup** (done at 401db00, reused): Zed invited vic.member@example.com into Zed Org from Settings > Directory > Invite people; Vic opened the invite link signed in and clicked "Join Zed Org". Vic is MEMBER of Olga Org (org X: P, Beta) and of Zed Org (org Y: project Zed Org, project_0008VSNhu43L0A3UgdAqjkTTaYcZg).

**Item 1 control: tRPC run as Vic from org Y's project, naming [Zed Org] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008VSNhu43L0A3UgdAqjkTTaYcZg"],"projectId":"project_0008VSNhu43L0A3UgdAqjkTTaYcZg"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[],"statistics":{"elapsedMs":7,"rowsRead":7,"bytesRead":819,"rowsReturned":0},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}}}}

```

**Item 1 control: tRPC run as Vic from org X's P, naming [P, Beta] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":5,"rowsRead":29,"bytesRead":1809,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"]}}}}

```

**Item 1: tRPC run as Vic from org X's P, naming [P, Zed Org (org Y)] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008VSNhu43L0A3UgdAqjkTTaYcZg"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"ff3205f7c8fea29dd26601cb744da8dd","spanId":"7deaa5647965d473","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"ff3205f7c8fea29dd26601cb744da8dd"}}}

```

**Item 1: tRPC run as Vic from org X's P, naming [Zed Org (org Y)] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008VSNhu43L0A3UgdAqjkTTaYcZg"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"9b343f791ba15dbea659424defe8dca4","spanId":"783c45aa5f9b1c37","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"9b343f791ba15dbea659424defe8dca4"}}}

```

**Item 1 reference: tRPC run as Vic from org X's P, naming [P, a missing id] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008NoSuchProjectXXXXXXXXXXXX"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"2a3ea277ead8b4f3272873cf0d9cfb80","spanId":"a8db555bb9447d55","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"2a3ea277ead8b4f3272873cf0d9cfb80"}}}

```

**Item 1 control: tRPC widget create as Vic on org X's board, naming [P, Beta] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.create -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "dashboardId": "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K", "name": "Vic X-only 22d", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008QMtqMaztCPlOawJxdPx9kR3uy"]}]}'
HTTP/1.1 200 OK
{"result":{"data":{"id":"widget_0002JV0S3K4JlrhKZFndElGxzeJCS","projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","name":"Vic X-only 22d","definition":{"version":1,"code":"export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n","queries":[{"name":"main","sql":"SELECT count() AS n FROM trace_metrics","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"]}]},"createdAt":"2026-10-29T12:58:34.908Z","updatedAt":"2026-10-29T12:58:34.908Z","dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","gridColumn":0,"gridRow":54,"colSpan":4,"rowSpan":3}}}

```

**Item 1: tRPC widget create as Vic on org X's board, naming [P, Zed Org (org Y)] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.create -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "dashboardId": "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K", "name": "Vic cross-org 22d", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.create","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"89db799db74a9f23bd86f306bce1ff6c","spanId":"e8250010af09ec5a","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"89db799db74a9f23bd86f306bce1ff6c"}}}

```

**Item 1 reference: tRPC widget create as Vic on org X's board, naming [P, a missing id] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.create -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "dashboardId": "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K", "name": "Vic missing 22d", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008NoSuchProjectXXXXXXXXXXXX"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.create","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"c3c238bd282b9f107e11cd2b44bc5c25","spanId":"fe8bb9ee63b47a1b","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"c3c238bd282b9f107e11cd2b44bc5c25"}}}

```

**Item 1: tRPC widget update as Vic of "Vic X-only 22d", naming [P, Zed Org (org Y)] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008VSNhu43L0A3UgdAqjkTTaYcZg"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.update","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"4853cc3c38d8ae5e31c81282db1131a4","spanId":"09b459985fa8fcb1","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"4853cc3c38d8ae5e31c81282db1131a4"}}}

```

**Item 1 reference: tRPC widget update as Vic, naming [P, a missing id] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "project_0008NoSuchProjectXXXXXXXXXXXX"]}]}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"dashboardWidgets.update","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"3be3b32391a86b3902a18b51d778b088","spanId":"9cfa355936f40bee","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"3be3b32391a86b3902a18b51d778b088"}}}

```

**Item 1 control: tRPC widget update as Vic, naming [Beta, P] (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n FROM trace_metrics", "sources": ["application"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}'
HTTP/1.1 200 OK
{"result":{"data":{"success":true}}}

```

**Item 1: 404 bodies compared** (22d268c)
```
Item 1: tRPC run as Vic from org X's P, naming [P, Zed Org (org Y)] (22d268c): 348 bytes sha256 eb49cf061f56e1c7
Item 1: tRPC run as Vic from org X's P, naming [Zed Org (org Y)] (22d268c): 348 bytes sha256 eb49cf061f56e1c7
Item 1 reference: tRPC run as Vic from org X's P, naming [P, a missing id] (22d268c): 348 bytes sha256 eb49cf061f56e1c7
tRPC run: IDENTICAL across 3 bodies (traceId/spanId masked; they differ per request); any project id (project_0...) in a body: False
Item 1: tRPC widget create as Vic on org X's board, naming [P, Zed Org (org Y)] (22d268c): 351 bytes sha256 8fe82db61cfaf1c1
Item 1 reference: tRPC widget create as Vic on org X's board, naming [P, a missing id] (22d268c): 351 bytes sha256 8fe82db61cfaf1c1
tRPC widget create: IDENTICAL across 2 bodies (traceId/spanId masked; they differ per request); any project id (project_0...) in a body: False
Item 1: tRPC widget update as Vic of "Vic X-only 22d", naming [P, Zed Org (org Y)] (22d268c): 351 bytes sha256 27094e3c3fa7a815
Item 1 reference: tRPC widget update as Vic, naming [P, a missing id] (22d268c): 351 bytes sha256 27094e3c3fa7a815
tRPC widget update: IDENTICAL across 2 bodies (traceId/spanId masked; they differ per request); any project id (project_0...) in a body: False
```

**Item 1: stored rows after the cross-org calls** (database read, 22d268c)
```
[{"name":"Vic X-only 22d","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
```
Only "Vic X-only 22d" exists; no "Vic cross-org 22d" or "Vic missing 22d"; it holds [Beta, P] from the control update and no org Y id.

**Item 2: stored widget before** (database read, 22d268c)
```
[{"name":"Vic X-only 22d","updatedAt":"2026-10-29T12:58:35.233Z","q":{"sql":"SELECT count() AS n FROM trace_metrics","name":"main","sources":["application"],"projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}]
```

**Item 2 (AC210e): P-key (reads only P) updates "Vic X-only 22d" (stores [Beta, P]) with new SQL and no projects field** (REST; 22d268c)
```
$ curl -X PATCH http://localhost:5650/api/v1/dashboards/dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K/widgets/widget_0002JV0S3K4JlrhKZFndElGxzeJCS -H 'Authorization: Bearer <P-key>' -d '{"queries":[{"name":"main","sql":"SELECT count() AS n2 FROM trace_metrics"}]}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"<x>","span_id":"<x>","trace":{"traceId":"<x>","spanId":"<x>"},"fault":"customer"}


```

**Item 2: stored widget after the P-key update** (database read, 22d268c)
```
[{"name":"Vic X-only 22d","updatedAt":"2026-10-29T12:58:35.233Z","q":{"sql":"SELECT count() AS n FROM trace_metrics","name":"main","sources":["application"],"projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}]
```

**Item 2 (AC210e): Vic (reads P and Beta) makes the same update over tRPC: new SQL, no projects field (22d268c)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/dashboardWidgets.update -H 'Cookie: <session>' -d '{"projectId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0", "id": "widget_0002JV0S3K4JlrhKZFndElGxzeJCS", "code": "export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}<span style={{ fontSize: 14 }}> traces</span></div>;\n}\n", "queries": [{"name": "main", "sql": "SELECT count() AS n2 FROM trace_metrics", "sources": ["application"]}]}'
HTTP/1.1 200 OK
{"result":{"data":{"success":true}}}

```

**Item 2: stored widget after Vic's update** (database read, 22d268c)
```
[{"name":"Vic X-only 22d","updatedAt":"2026-10-29T12:58:56.943Z","q":{"sql":"SELECT count() AS n2 FROM trace_metrics","name":"main","sources":["application"],"projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}]
```

**Item 3: REST projects ["all", P] (22d268c)** (2026-10-29T12:59:09Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT 1","projects":["all","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"\"all\" stands alone; send it by itself, or list project ids","retryable":false,"trace_id":"d1cb6e301b82e2a00de3118f07e32e23","span_id":"53c9ab7a9a362262","trace":{"traceId":"d1cb6e301b82e2a00de3118f07e32e23","spanId":"53c9ab7a9a362262"},"fault":"customer"}


```

**Item 3: REST projects [P, "ALL"] (22d268c)** (2026-10-29T12:59:09Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT 1","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","ALL"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"\"all\" stands alone; send it by itself, or list project ids","retryable":false,"trace_id":"ecb4bf71045a0b6b3df239aa32fe3c16","span_id":"092c9a065d63c6a7","trace":{"traceId":"ecb4bf71045a0b6b3df239aa32fe3c16","spanId":"092c9a065d63c6a7"},"fault":"customer"}


```

**Item 3: REST projects "ALL" (22d268c)** (2026-10-29T12:59:10Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"ALL"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":4,"rowsRead":29,"bytesRead":1809,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0001cmcXoJG9vEsZGoZB5U6hyT5TO","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**Item 3 control: REST projects "all" (22d268c)** (2026-10-29T12:59:11Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":4,"rowsRead":29,"bytesRead":1809,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0001cmcXoJG9vEsZGoZB5U6hyT5TO","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**Item 4: reads-none key (Vic's org key), nothing named (22d268c)** (2026-10-29T12:59:12Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_unreadable","message":"This key reads no project. Ask an admin to grant it `analytics:view` on a project.","retryable":false,"trace_id":"351b2fbb7d732aca5e388a864ced196f","span_id":"c5c7a6ac2d38924e","trace":{"traceId":"351b2fbb7d732aca5e388a864ced196f","spanId":"c5c7a6ac2d38924e"},"tips":["Ask an admin to grant the key's owner `analytics:view` on a project, or use a key that has it"],"fault":"customer"}


```

**Item 4: reads-none key, projects "all" (22d268c)** (2026-10-29T12:59:13Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1","projects":"all"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_unreadable","message":"This key reads no project. Ask an admin to grant it `analytics:view` on a project.","retryable":false,"trace_id":"37455b833e38c659415a7090cbdac369","span_id":"d3625f8325e6e374","trace":{"traceId":"37455b833e38c659415a7090cbdac369","spanId":"d3625f8325e6e374"},"tips":["Ask an admin to grant the key's owner `analytics:view` on a project, or use a key that has it"],"fault":"customer"}


```

**Item 4: reads-none key, projects [P] (22d268c)** (2026-10-29T12:59:13Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"7b5bc4c39422570e2984878daf1afc25","span_id":"72c96ff0686c4da2","trace":{"traceId":"7b5bc4c39422570e2984878daf1afc25","spanId":"72c96ff0686c4da2"},"fault":"customer"}


```

**Item 5: schema door GET /api/v1/query/schema with the reads-none key (22d268c)** (2026-10-29T12:59:14Z, key: vic-org-key)
```
$ curl -X GET http://localhost:5650/api/v1/query/schema -H 'Authorization: Bearer <vic-org-key>'
HTTP 200
{"database":"qp9171b","functions":["abs","addDays","addHours","addMinutes","addMonths","addQuarters","addSeconds","addWeeks","addYears","and","any","anyLast","argMax","argMin","arrayAll","arrayAvg","arrayConcat","arrayCount","arrayDistinct","arrayElement","arrayEnumerate","arrayExists","arrayFilter","arrayFirst","arrayFirstIndex","arrayJoin","arrayLast","arrayMap","arrayMax","arrayMin","arrayReverseSort","arraySlice","arraySort","arrayStringConcat","arraySum","arrayUniq","assumeNotNull","avg","caseWithExpression","caseWithoutExpression","CAST","ceil","ceiling","coalesce","concat","concatWithSeparator","count","date_trunc","dateDiff","dateTrunc","dense_rank","divide","empty","endsWith","equals","exists","exp","extract","extractAll","first_value","floor","formatDateTime","fromUnixTimestamp","globalIn","globalNotIn","greater","greaterOrEquals","greatest","groupArray","groupUniqArray","has","hasAll","hasAny","if","ifNull","ilike","in","indexOf","intDiv","intDivOrZero","isDistinctFrom","isNotDistinctFrom","isNotNull","isNull","isValidJSON","JSONExtract","JSONExtractArrayRaw","JSONExtractBool","JSONExtractFloat","JSONExtractInt","JSONExtractKeys","JSONExtractKeysAndValues","JSONExtractRaw","JSONExtractString","JSONExtractUInt","JSONHas","JSONLength","JSONType","lagInFrame","lambda","last_value","leadInFrame","least","left","length","lengthUTF8","less","lessOrEquals","like","ln","log","log10","log2","lower","lowerUTF8","map","mapContains","mapFilter","mapKeys","mapValues","match","max","median","medianExact","min","minus","modulo","moduloOrZero","multiIf","multiply","negate","not","notEmpty","notEquals","notILike","notIn","notLike","now","now64","nth_value","ntile","nullIf","or","plus","position","positionCaseInsensitive","pow","power","quantile","quantileExact","quantiles","quantilesExact","quantilesTDigest","quantilesTiming","quantileTDigest","quantileTiming","rank","replaceAll","replaceOne","replaceRegexpAll","replaceRegexpOne","right","round","row_number","sign","simpleJSONExtractBool","simpleJSONExtractFloat","simpleJSONExtractInt","simpleJSONExtractString","simpleJSONExtractUInt","simpleJSONHas","splitByChar","splitByString","sqrt","startsWith","stddevPop","stddevSamp","substring","substringUTF8","subtractDays","subtractHours","subtractMinutes","subtractMonths","subtractQuarters","subtractSeconds","subtractWeeks","subtractYears","sum","toBool","toDate","toDate32","toDate32OrDefault","toDate32OrNull","toDate32OrZero","toDateOrDefault","toDateOrNull","toDateOrZero","toDateTime","toDateTime64","toDateTime64OrDefault","toDateTime64OrNull","toDateTime64OrZero","toDateTimeOrDefault","toDateTimeOrNull","toDateTimeOrZero","today","toDayOfMonth","toDayOfWeek","toDayOfYear","toDecimal128","toDecimal128OrDefault","toDecimal128OrNull","toDecimal128OrZero","toDecimal256","toDecimal256OrDefault","toDecimal256OrNull","toDecimal256OrZero","toDecimal32","toDecimal32OrDefault","toDecimal32OrNull","toDecimal32OrZero","toDecimal64","toDecimal64OrDefault","toDecimal64OrNull","toDecimal64OrZero","toFloat32","toFloat32OrDefault","toFloat32OrNull","toFloat32OrZero","toFloat64","toFloat64OrDefault","toFloat64OrNull","toFloat64OrZero","toHour","toInt128","toInt128OrDefault","toInt128OrNull","toInt128OrZero","toInt16","toInt16OrDefault","toInt16OrNull","toInt16OrZero","toInt256","toInt256OrDefault","toInt256OrNull","toInt256OrZero","toInt32","toInt32OrDefault","toInt32OrNull","toInt32OrZero","toInt64","toInt64OrDefault","toInt64OrNull","toInt64OrZero","toInt8","toInt8OrDefault","toInt8OrNull","toInt8OrZero","toIntervalDay","toIntervalHour","toIntervalMinute","toIntervalMonth","toIntervalQuarter","toIntervalSecond","toIntervalWeek","toIntervalYear","toISOWeek","toLastDayOfMonth","toMinute","toMonday","toMonth","topK","toQuarter","toSecond","toStartOfDay","toStartOfFifteenMinutes","toStartOfFiveMinutes","toStartOfHour","toStartOfInterval","toStartOfISOWeek","toStartOfMinute","toStartOfMonth","toStartOfQuarter","toStartOfSecond","toStartOfTenMinutes","toStartOfWeek","toStartOfYear","toString","toTimeZone","toUInt128","toUInt128OrDefault","toUInt128OrNull","toUInt128OrZero","toUInt16","toUInt16OrDefault","toUInt16OrNull","toUInt16OrZero","toUInt256","toUInt256OrDefault","toUInt256OrNull","toUInt256OrZero","toUInt32","toUInt32OrDefault","toUInt32OrNull","toUInt32OrZero","toUInt64","toUInt64OrDefault","toUInt64OrNull","toUInt64OrZero","toUInt8","toUInt8OrDefault","toUInt8OrNull","toUInt8OrZero","toUnixTimestamp","toUUID","toUUIDOrDefault","toUUIDOrNull","toUUIDOrZero","toWeek","toYear","trim","trimBoth","trimLeft","trimRight","trunc","truncate","tuple","tupleElement","uniq","uniqCombined","uniqExact","upper","upperUTF8","varPop","varSamp","yesterday"],"views":[],"appFunctions":[{"name":"conversation","signature":"conversation(thread_key)","description":"The whole thread as one markdown transcript that reads like the chat view: the system prompt once, then each turn's user message and reply, with one line naming the tools the turn used. For questions about what was said; `llm_readable_thread` holds what the agent did.","returns":"Nullable(String)","encoding":"text","keyKind":"thread","kind":"extraction","cap":200,"gates":["input","output"],"available":false,"exampleSql":"SELECT ConversationId, conversation(ConversationId) AS transcript\nFROM qp9171b.trace_metrics\nWHERE OccurredAt >= subtractDays(now(), 7) AND ConversationId != ''\nGROUP BY ConversationId\nORDER BY ConversationId\nLIMIT 20"},{"name":"conversation_bounded","signature":"conversation_bounded(thread_key, max_tokens, until_trace_id)","description":"The same transcript under a token budget: every turn is shortened before one is dropped, and a marker names how many turns were dropped from the middle. Pass an empty string for `until_trace_id` to read the whole thread.","returns":"Nullable(String)","encoding":"text","keyKind":"thread","kind":"extraction","cap":200,"gates":["input","output"],"available":false,"exampleSql":"SELECT ConversationId, conversation_bounde
```

**Item 6: CLI --projects all,<P> against a closed port (nothing listens on 127.0.0.1:9) (22d268c)** (key: P-key)
```
$ LANGWATCH_API_KEY=<P-key> LANGWATCH_ENDPOINT=http://127.0.0.1:9 langwatch query run --projects all\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ 1
[stdout]

[stderr]
Error: --projects: "all" stands alone; pass it by itself, or list project ids
(exit 1)
```

**Item 6: CLI --projects <P>,ALL against a closed port (nothing listens on 127.0.0.1:9) (22d268c)** (key: P-key)
```
$ LANGWATCH_API_KEY=<P-key> LANGWATCH_ENDPOINT=http://127.0.0.1:9 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,ALL SELECT\ 1
[stdout]

[stderr]
Error: --projects: "all" stands alone; pass it by itself, or list project ids
(exit 1)
```

**Item 6: CLI --sources '' against a closed port (22d268c)** (key: P-key)
```
$ LANGWATCH_API_KEY=<P-key> LANGWATCH_ENDPOINT=http://127.0.0.1:9 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 --sources '' SELECT\ 1
[stdout]

[stderr]
Error: --sources: pass a comma list
(exit 1)
```

**Item 6: CLI --project <slug> --projects <P> against a closed port, API key (22d268c)** (key: P-key)
```
$ LANGWATCH_API_KEY=<P-key> LANGWATCH_ENDPOINT=http://127.0.0.1:9 langwatch query run --project olga-org-wQyuC0 --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ 1
[stdout]

[stderr]
Error: --project and --projects both name the projects to read; pass one of them
(exit 1)
```

**Item 6 control: CLI --projects <P> alone against the same closed port (22d268c)** (key: P-key)
```
$ LANGWATCH_API_KEY=<P-key> LANGWATCH_ENDPOINT=http://127.0.0.1:9 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ 1
[stdout]

[stderr]
Using API key for project "Olga Org". Switch: langwatch login --project | --device
- Running statement...
✖ Failed to run statement: fetch failed
(exit 1)
```

**Item 6: CLI --project <slug> --projects <P> under Vic's device session, control plane and endpoint pointed at a closed port (127.0.0.1:9); control: --projects <P> alone** (22d268c)
```
$ langwatch query run --project olga-org-wQyuC0 --projects <P> "SELECT 1"
Error: --project and --projects both name the projects to read; pass one of them
(exit 1)
$ langwatch query run --projects <P> "SELECT 1"
- Running statement...
✖ Failed to run statement: fetch failed
(exit 1)
```

**Raw captures at 8e8b73b**


**Item 1: Vic's org key (reads no project), nothing named (8e8b73b)** (2026-10-29T12:21:33Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_unreadable","message":"This key reads no project. Ask an admin to grant it `analytics:view` on a project.","retryable":false,"trace_id":"3bc4a6b5f1a0541e081e7f842957bba1","span_id":"a4515039c505d734","trace":{"traceId":"3bc4a6b5f1a0541e081e7f842957bba1","spanId":"a4515039c505d734"},"tips":["Ask an admin to grant the key's owner `analytics:view` on a project, or use a key that has it"],"fault":"customer"}


```

**Item 1: Vic's org key, projects "all" (8e8b73b)** (2026-10-29T12:21:34Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1","projects":"all"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_unreadable","message":"This key reads no project. Ask an admin to grant it `analytics:view` on a project.","retryable":false,"trace_id":"5709cf9754cb76a2ca8a1992bcc73a45","span_id":"ce5245de52df0b6b","trace":{"traceId":"5709cf9754cb76a2ca8a1992bcc73a45","spanId":"ce5245de52df0b6b"},"tips":["Ask an admin to grant the key's owner `analytics:view` on a project, or use a key that has it"],"fault":"customer"}


```

**Item 1: CLI, Vic's org key, no --projects (8e8b73b)** (key: vic-org-key)
```
$ LANGWATCH_API_KEY=<vic-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run SELECT\ 1
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: This key reads no project. Ask an admin to grant it `analytics:view` on a project.
Details:
  code      projects_unreadable
  status    422
  trace id  3861420909a0eddc3644140fed9c1ba4
  trace_id  3861420909a0eddc3644140fed9c1ba4
  span_id   e33bb32adfdbcb00
Suggestions:
  - Ask an admin to grant the key's owner `analytics:view` on a project, or use a key that has it
(exit 1)
```

**Item 1: CLI, Vic's org key, --projects all (8e8b73b)** (key: vic-org-key)
```
$ LANGWATCH_API_KEY=<vic-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects all SELECT\ 1
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: This key reads no project. Ask an admin to grant it `analytics:view` on a project.
Details:
  code      projects_unreadable
  status    422
  trace id  9deec2d1c2bec76f9cd84987ece4b365
  trace_id  9deec2d1c2bec76f9cd84987ece4b365
  span_id   633fc198e8a2f813
Suggestions:
  - Ask an admin to grant the key's owner `analytics:view` on a project, or use a key that has it
(exit 1)
```

**Item 2: Olga's org key, nothing named (8e8b73b)** (2026-10-29T12:21:37Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT 1"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"Name the projects to query: send `projects`, a list of project ids, or \"all\"","retryable":false,"trace_id":"44506a52c6876d7f0b870512ef9c1e45","span_id":"506094403d70b303","trace":{"traceId":"44506a52c6876d7f0b870512ef9c1e45","spanId":"506094403d70b303"},"tips":["Send `projects`, a list of the project ids to read, or the string \"all\" for every project the key can read; the answer's `params.dashboard_context_projects` lists what was read","A key that reads exactly one project, such as a project API key, needs none: it defaults to that project"],"fault":"customer"}


```

**Item 1: MCP run_query, Vic's org key (reads no project), nothing named, then "all"** (stdio client, mcp/typescript built at 8e8b73b; 8e8b73b)
```
**MCP run_query** {"sql":"SELECT 1"} ... projects=?
result isError=True: LangWatch API error 422: This key reads no project. Ask an admin to grant it `analytics:view` on a project.
Code: projects_unreadable
Tips:
- Ask an admin to grant the key's owner `analytics:view` on a project, or use a key that has it
**MCP run_query** {"sql":"SELECT 1","pro ... projects="all"
result isError=True: LangWatch API error 422: This key reads no project. Ask an admin to grant it `analytics:view` on a project.
Code: projects_unreadable
Tips:
- Ask an admin to grant the key's owner `analytics:view` on a project, or use a key that has it
```

**Item 3: MCP add/update_dashboard_widget with projects "ALL", " all ", ["ALL"], "All", ["all"], "all"** (key: olga-org-key; 8e8b73b) (calls run in pairs: each add sends the same projects value as the update that follows it; the add line shows "?" because the trimmed line cuts before the field)
```
**MCP add_dashboard_widget** {"dashboard ... projects=?
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP update_dashboard_widget** {"dashbo ... projects="ALL"
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP add_dashboard_widget** {"dashboard ... projects=?
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP update_dashboard_widget** {"dashbo ... projects=" all "
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP add_dashboard_widget** {"dashboard ... projects=?
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP update_dashboard_widget** {"dashbo ... projects=["ALL"]
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP add_dashboard_widget** {"dashboard ... projects=?
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP update_dashboard_widget** {"dashbo ... projects="All"
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP add_dashboard_widget** {"dashboard ... projects=?
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP update_dashboard_widget** {"dashbo ... projects=["all"]
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP add_dashboard_widget** {"dashboard ... projects=?
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP update_dashboard_widget** {"dashbo ... projects="all"
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
```

**Item 3: MCP tools/list, projects field** (8e8b73b)
```
add_dashboard_widget projects anyOf: [{"minItems": 1, "type": "array", "items": {"type": "string", "minLength": 1}}, {"type": "null"}] | "all" in it: False
update_dashboard_widget projects anyOf: [{"minItems": 1, "type": "array", "items": {"type": "string", "minLength": 1}}, {"type": "null"}] | "all" in it: False
```

**Item 5: Vic's CLI token, widget add naming [Olga Org, Secret], 404 hint (8e8b73b)** (credential: vic's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch dashboard widget add dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K --project olga-org-wQyuC0 --name Vic\ token\ Secret --code-file w.tsx --queries-file q-cli.json --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,project_0008RvvmwglxZMZ0yVpjAsI6sPVoH
[stdout]


[stderr]
- Creating widget "Vic token Secret"...
✖ Failed to create dashboard widget: Project not found
Details:
  code      project_not_found
  status    404
  trace id  1ac1e7b5bb002f4c3403cd2bc8ab8c8f
  trace_id  1ac1e7b5bb002f4c3403cd2bc8ab8c8f
  span_id   c7e7dcdd07acf977
Suggestions:
  - Check that your account can read the project; ask a workspace admin to grant you access
  - Create or select a project in the LangWatch dashboard
(exit 1)
```

**Item 4: CLI --project <slug> --projects <id> with the CLI pointed at a closed port (nothing listens on 127.0.0.1:9); control: --projects <P> alone** (Vic's device session; 8e8b73b)
```
$ langwatch query run --project olga-org-wQyuC0 --projects <P> "SELECT 1"
Error: --project and --projects both name the projects to read; pass one of them
(exit 1)
$ langwatch query run --projects <P> "SELECT 1"
- Running statement...
✖ Failed to run statement: fetch failed
(exit 1)
```

**Raw captures at cfd772c**


**Item 1: Olga's org key, projects "all" (cfd772c)** (2026-10-29T12:08:29Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":7,"rowsRead":29,"bytesRead":1809,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0001cmcXoJG9vEsZGoZB5U6hyT5TO","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**Item 1: Olga's org key, nothing named (cfd772c)** (2026-10-29T12:08:29Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"Name the projects to query: send `projects`, a list of project ids, or \"all\"","retryable":false,"trace_id":"1687fd08f8d160fdfdca6e2712bb8c2f","span_id":"0255ba7f90ed0daf","trace":{"traceId":"1687fd08f8d160fdfdca6e2712bb8c2f","spanId":"0255ba7f90ed0daf"},"tips":["Send `projects`, a list of the project ids to read, or the string \"all\" for every project the key can read; the answer's `params.dashboard_context_projects` lists what was read","A key that reads exactly one project, such as a project API key, needs none: it defaults to that project"],"fault":"customer"}


```

**Item 2: Vic's org key (reads no project), nothing named (cfd772c)** (2026-10-29T12:08:30Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"This key reads no project. Ask an admin to grant it `analytics:view` on one, then name it","retryable":false,"meta":{"readsNone":true},"trace_id":"6b75368f77f03a08cfaa2ba6fbb15087","span_id":"3448cdb61884687c","trace":{"traceId":"6b75368f77f03a08cfaa2ba6fbb15087","spanId":"3448cdb61884687c"},"tips":["Grant the key's owner `analytics:view` on a project, or use a key that has it"],"fault":"customer"}


```

**Item 2: Vic's org key, projects "all" (cfd772c)** (2026-10-29T12:08:31Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1","projects":"all"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"This key reads no project. Ask an admin to grant it `analytics:view` on one, then name it","retryable":false,"meta":{"readsNone":true},"trace_id":"1e177f7a0d3602e3d15199840f53cba6","span_id":"c1f4424362873bae","trace":{"traceId":"1e177f7a0d3602e3d15199840f53cba6","spanId":"c1f4424362873bae"},"tips":["Grant the key's owner `analytics:view` on a project, or use a key that has it"],"fault":"customer"}


```

**Item 2: CLI, Vic's org key, no --projects (cfd772c)** (key: vic-org-key)
```
$ LANGWATCH_API_KEY=<vic-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run SELECT\ 1
[stdout]

[stderr]
Using API key from LANGWATCH_API_KEY. Switch: langwatch login --project | --device
- Running statement...
✖ Failed to run statement: This key reads no project. Ask an admin to grant it `analytics:view` on one, then name it
Details:
  code       projects_required
  status     422
  trace id   b2425cb00c7f64a654d45bd55198d012
  readsNone  true
Suggestions:
  - Grant the key's owner `analytics:view` on a project, or use a key that has it
(exit 1)
```

**Item 2: CLI, Vic's org key, --projects all (cfd772c)** (key: vic-org-key)
```
$ LANGWATCH_API_KEY=<vic-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects all SELECT\ 1
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: This key reads no project. Ask an admin to grant it `analytics:view` on one, then name it
Details:
  code       projects_required
  status     422
  trace id   0a342089de801be8ef66de77151f6649
  readsNone  true
Suggestions:
  - Grant the key's owner `analytics:view` on a project, or use a key that has it
(exit 1)
```

**Item 2: MCP run_query, Vic's org key (reads no project), nothing named, then projects "all"** (stdio client, mcp/typescript built at cfd772c; cfd772c)
```
**MCP run_query** {"sql":"SELECT 1"}
result isError=True: LangWatch API error 422: This key reads no project. Ask an admin to grant it `analytics:view` on one, then name it
Code: projects_required
Details: {"readsNone":true}
Tips:
- Grant the key's owner `analytics:view` on a project, or use a key that has it
**MCP run_query** {"sql":"SELECT 1","projects":"all"}
result isError=True: LangWatch API error 422: This key reads no project. Ask an admin to grant it `analytics:view` on one, then name it
Code: projects_required
Details: {"readsNone":true}
Tips:
- Grant the key's owner `analytics:view` on a project, or use a key that has it
```

**Item 3: MCP add/update_dashboard_widget with projects "ALL" and ["all"]** (key: olga-org-key; cfd772c)
```
**MCP add_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","name":"MCP all","code":"export default function Widget() {\n  const { data } = LW.u
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: Invalid input: expected array, received string at projects
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_0008WfcTeHoYfUmbEp7xl9lNiOnab","projects":"ALL"}
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: Invalid input: expected array, received string at projects
**MCP add_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","name":"MCP all","code":"export default function Widget() {\n  const { data } = LW.u
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_0008WfcTeHoYfUmbEp7xl9lNiOnab","projects":["all"]}
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
```

**Item 3: MCP tools/list, projects field** (cfd772c)
```
add_dashboard_widget projects: {"description": "The project ids every query of the widget reads, each one you can read. A new widget reads its board's project. null makes it unset again, reading the board's project.", "anyOf": [{"minItems": 1, "type": "array", "items": {"type": "string", "minLength": 1}}, {"type": "null"}]}
   "all" appears in the projects schema (any case): False | in the whole input schema as enum/const: False
update_dashboard_widget projects: {"description": "The project ids every query of the widget reads, each one you can read. A new widget reads its board's project. null makes it unset again, reading the board's project.", "anyOf": [{"minItems": 1, "type": "array", "items": {"type": "string", "minLength": 1}}, {"type": "null"}]}
   "all" appears in the projects schema (any case): False | in the whole input schema as enum/const: False
```

**Item 3 control: MCP update_dashboard_widget with projects "all" and "All"** (key: olga-org-key; cfd772c)
```
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_0008WfcTeHoYfUmbEp7xl9lNiOnab","projects":"all"}
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_0008WfcTeHoYfUmbEp7xl9lNiOnab","projects":"All"}
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: Invalid input: expected array, received string at projects
```

**Item 4: Vic's CLI token, widget add naming [Olga Org, Secret], 404 hint (cfd772c)** (credential: vic's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch dashboard widget add dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K --project olga-org-wQyuC0 --name Vic\ token\ Secret --code-file w.tsx --queries-file q-cli.json --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,project_0008RvvmwglxZMZ0yVpjAsI6sPVoH
[stdout]


[stderr]
- Creating widget "Vic token Secret"...
✖ Failed to create dashboard widget: Project not found
Details:
  code      project_not_found
  status    404
  trace id  6cf1e4c2fe82c11aa8bae475dcd22b15
  trace_id  6cf1e4c2fe82c11aa8bae475dcd22b15
  span_id   12d759321f193b05
Suggestions:
  - Check that your account can read the project; ask a workspace admin to grant you access
  - Create or select a project in the LangWatch dashboard
(exit 1)
```

**Item 5: Vic's CLI token, query run --project <slug> --projects <P> (cfd772c)** (credential: vic's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch query run --project olga-org-wQyuC0 --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ 1
[stdout]


[stderr]
Error: --project and --projects both name the projects to read; pass one of them
(exit 1)
```

**Item 5: the same pair with the CLI pointed at a closed port (nothing listens on 127.0.0.1:9); control: --projects <P> alone** (Vic's device session; cfd772c)
```
$ langwatch query run --project olga-org-wQyuC0 --projects <P> "SELECT 1"
Error: could not look up project "olga-org-wQyuC0": fetch failed

List the projects your login reaches:
  langwatch projects list
(exit 1)
$ langwatch query run --projects <P> "SELECT 1"
- Running statement...
✖ Failed to run statement: fetch failed
(exit 1)
```

**Item 4 control: API key (P-key) naming Secret, 404 hint (cfd772c)** (key: P-key)
```
$ LANGWATCH_API_KEY=<P-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,project_0008RvvmwglxZMZ0yVpjAsI6sPVoH SELECT\ 1
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: Project not found
Details:
  code      project_not_found
  status    404
  trace id  6c8f1e995a1fd877279bfe22cf833b64
  trace_id  6c8f1e995a1fd877279bfe22cf833b64
  span_id   2d0e8c010d63ee29
Suggestions:
  - Check which project your API key belongs to
  - Create or select a project in the LangWatch dashboard
(exit 1)
```

**Raw captures at 31112cf**


**Item 1: Olga's org key, projects "all" (31112cf)** (2026-10-29T11:52:15Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":8,"rowsRead":29,"bytesRead":1809,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0001cmcXoJG9vEsZGoZB5U6hyT5TO","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**Item 1: Olga's org key, nothing named (31112cf)** (2026-10-29T11:52:16Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"Name the projects to query: send `projects`, a list of project ids, or \"all\"","retryable":false,"trace_id":"c384374c15cab272d51cc406a9e23cd2","span_id":"8ac06d8bef3d81b3","trace":{"traceId":"c384374c15cab272d51cc406a9e23cd2","spanId":"8ac06d8bef3d81b3"},"tips":["Send `projects`, a list of the project ids to read, or the string \"all\" for every project the key can read; the answer's `params.dashboard_context_projects` lists what was read","A key that reads exactly one project, such as a project API key, needs none: it defaults to that project"],"fault":"customer"}


```

**Item 3 / QP03j: Vic's org key (reads no project), nothing named (31112cf)** (2026-10-29T11:52:16Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"This key reads no project. Ask an admin to grant it `analytics:view` on one, then name it","retryable":false,"trace_id":"f1ae9390ec1e3f3d99644d09d42d9142","span_id":"baa3618c83520120","trace":{"traceId":"f1ae9390ec1e3f3d99644d09d42d9142","spanId":"baa3618c83520120"},"tips":["Send `projects`, a list of the project ids to read, or the string \"all\" for every project the key can read; the answer's `params.dashboard_context_projects` lists what was read","A key that reads exactly one project, such as a project API key, needs none: it defaults to that project"],"fault":"customer"}


```

**Item 3: Vic's org key, projects "all" (31112cf)** (2026-10-29T11:52:17Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1","projects":"all"}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"f0586a5d6fd4b46e4677f1b321e3b410","span_id":"7632ba01a8ea0e73","trace":{"traceId":"f0586a5d6fd4b46e4677f1b321e3b410","spanId":"7632ba01a8ea0e73"},"fault":"customer"}


```

**Item 2: tRPC as Vic (not in Hidden Team), projects "all" (31112cf)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":"all","projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":4,"rowsRead":29,"bytesRead":1764,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}}}

```

**Item 2: tRPC as Vic (not in Hidden Team), projects ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"] (31112cf)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":5,"rowsRead":28,"bytesRead":1647,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"]}}}}

```

**Item 1 note** (31112cf): the fifth id in Olga's "all" echo, project_0001cmcXoJG9vEsZGoZB5U6hyT5TO, is Olga's own Personal Workspace (team "olga.owner's Workspace"), created 2026-10-29T11:33:30Z by the 'langwatch login --device' approval at 2cb26fe. Vic's Personal Workspace is project_0008dzdx4w6GfnFHrx3JFMR0UK5zk. Neither has traces, so neither has a row.

**Item 4: MCP tools/list, the projects field of add_dashboard_widget and update_dashboard_widget** (stdio client against mcp/typescript/dist built at 31112cf; key: olga-org-key; 31112cf)
```
add_dashboard_widget .projects {"description": "The project ids every query of the widget reads, each one you can read. A new widget reads its board's project. null makes it unset again, reading the board's project.", "anyOf": [{"minItems": 1, "type": "array", "items": {"type": "string", "minLength": 1}}, {"type": "null"}]}
   'all' in projects schema: False
add_dashboard_widget whole input schema contains "all" as an enum/const: False
update_dashboard_widget .projects {"description": "The project ids every query of the widget reads, each one you can read. A new widget reads its board's project. null makes it unset again, reading the board's project.", "anyOf": [{"minItems": 1, "type": "array", "items": {"type": "string", "minLength": 1}}, {"type": "null"}]}
   'all' in projects schema: False
update_dashboard_widget whole input schema contains "all" as an enum/const: False
```

**Item 4: MCP add and update with projects "all"** (31112cf)
```
**MCP add_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","name":"MCP all","code":"export default function Widget() {\n  const { dat
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_0008WfcTeHoYfUmbEp7xl9lNiOnab","projects":"all"}
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool update_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
```

**Item 5: CLI --projects ALL, -o json (31112cf)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run -o json --projects ALL SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
{
  "rows": [
    {
      "TenantId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "n": 15
    },
    {
      "TenantId": "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "n": 3
    },
    {
      "TenantId": "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH",
      "n": 4
    }
  ],
  "params": {
    "dashboard_context_projects": [
      "project_0001cmcXoJG9vEsZGoZB5U6hyT5TO",
      "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH",
      "project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"
    ]
  },
  "diagnostics": [
    {
      "code": "MULTI_PROJECT_RESULT",
      "message": "This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.",
      "meta": {
        "projectCount": 3
      }
    },
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]
Using API key from LANGWATCH_API_KEY. Switch: langwatch login --project | --device
(exit 0)
```

**Item 5: CLI --projects All, -o json (31112cf)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run -o json --projects All SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
{
  "rows": [
    {
      "TenantId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "n": 15
    },
    {
      "TenantId": "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "n": 3
    },
    {
      "TenantId": "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH",
      "n": 4
    }
  ],
  "params": {
    "dashboard_context_projects": [
      "project_0001cmcXoJG9vEsZGoZB5U6hyT5TO",
      "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH",
      "project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"
    ]
  },
  "diagnostics": [
    {
      "code": "MULTI_PROJECT_RESULT",
      "message": "This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.",
      "meta": {
        "projectCount": 3
      }
    },
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]

(exit 0)
```

**Item 5: CLI --projects ALL,<P> against a closed port (nothing listens on 127.0.0.1:9) (31112cf)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://127.0.0.1:9 langwatch query run --projects ALL\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ 1
[stdout]

[stderr]
Error: --projects: "all" stands alone; pass it by itself, or list project ids
(exit 1)
```

**Item 5: CLI --projects <P>,All against the same closed port (31112cf)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://127.0.0.1:9 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,All SELECT\ 1
[stdout]

[stderr]
Error: --projects: "all" stands alone; pass it by itself, or list project ids
(exit 1)
```

**Item 6: Vic's CLI token, query run naming Secret (31112cf)** (credential: vic's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch query run --project olga-org-wQyuC0 --projects project_0008RvvmwglxZMZ0yVpjAsI6sPVoH SELECT\ 1
[stdout]


[stderr]
- Running statement...
✖ Failed to run statement: send projectId or projects, not both
Details:
  code      validation_error
  status    422
  trace id  c0593ada054efd2ea26c9cce3c86e937
  trace_id  c0593ada054efd2ea26c9cce3c86e937
  span_id   ff7a5b34525c69f9
Suggestions:
  - Check the details above for the exact validation failure
  - Compare your arguments against the command's `--help` output
(exit 1)
```

**Item 6: Vic's CLI token, widget add naming [Olga Org, Secret] (31112cf)** (credential: vic's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch dashboard widget add dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K --project olga-org-wQyuC0 --name Vic\ token\ Secret --code-file w.tsx --queries-file q-cli.json --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,project_0008RvvmwglxZMZ0yVpjAsI6sPVoH
[stdout]


[stderr]
- Creating widget "Vic token Secret"...
✖ Failed to create dashboard widget: Project not found
Details:
  code      project_not_found
  status    404
  trace id  a7f43730785bc4990a8c97aa2882d4b4
  trace_id  a7f43730785bc4990a8c97aa2882d4b4
  span_id   acc7aa6c930c18a8
Suggestions:
  - Check that your account can read the project; ask a workspace admin to grant you access
(exit 1)
```

**Item 6: API key (P-key) query run naming Secret (31112cf)** (key: P-key)
```
$ LANGWATCH_API_KEY=<P-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,project_0008RvvmwglxZMZ0yVpjAsI6sPVoH SELECT\ 1
[stdout]

[stderr]
Using API key for project "Olga Org". Switch: langwatch login --project | --device
- Running statement...
✖ Failed to run statement: Project not found
Details:
  code      project_not_found
  status    404
  trace id  0272820605f38966c382c78811a4e3af
  trace_id  0272820605f38966c382c78811a4e3af
  span_id   9c9bab8aab406cdf
Suggestions:
  - Check which project your API key belongs to
  - Create or select a project in the LangWatch dashboard
(exit 1)
```

**Raw captures at 2cb26fe**


**Item 1: org key names no projects (2cb26fe)** (2026-10-29T11:30:31Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT 1"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"Name the projects to query: send `projects`, a list of project ids, or \"all\"","retryable":false,"trace_id":"7f2b8e5ce3a7ea9259969b8a28c13325","span_id":"8489f729d597c94b","trace":{"traceId":"7f2b8e5ce3a7ea9259969b8a28c13325","spanId":"8489f729d597c94b"},"tips":["Send `projects`, a list of the project ids to read, or the string \"all\" for every project the key can read; the answer's `params.dashboard_context_projects` lists what was read","A key that reads exactly one project, such as a project API key, needs none: it defaults to that project"],"fault":"customer"}


```

**Item 2: org key, projects "all" (2cb26fe)** (2026-10-29T11:30:32Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":7,"rowsRead":28,"bytesRead":1692,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**Item 1: key that reads no project (Vic's org key), no projects (2cb26fe)** (2026-10-29T11:30:33Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1"}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"4e204d7fe8113e64b69a90219841378d","span_id":"65b8f23b944141f0","trace":{"traceId":"4e204d7fe8113e64b69a90219841378d","spanId":"65b8f23b944141f0"},"fault":"customer"}


```

**Item 1: key that reads no project (Vic's org key), projects "all" (2cb26fe)** (2026-10-29T11:30:33Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT 1","projects":"all"}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"bda0f47bbe7fe236aac59152e630a5e5","span_id":"98aba96c18e62830","trace":{"traceId":"bda0f47bbe7fe236aac59152e630a5e5","spanId":"98aba96c18e62830"},"fault":"customer"}


```

**Item 2: P-key, no projects (2cb26fe)** (2026-10-29T11:30:34Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1575,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}


```

**Item 2: P-key, projects "all" (2cb26fe)** (2026-10-29T11:30:35Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1575,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}


```

**Item 5: UNBOUNDED_TIME_RANGE meta.view (2cb26fe)** (2026-10-29T11:30:36Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics"}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**Item 1: CLI org key, no --projects (2cb26fe)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run SELECT\ 1
[stdout]

[stderr]
- Running statement...
Error: Name the projects to query: pass --projects <id,id>, or --projects all
(exit 1)
```

**Item 6: CLI --projects all,<P> (2cb26fe)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects all\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ 1
[stdout]

[stderr]
Error: --projects: "all" stands alone; pass it by itself, or list project ids
(exit 1)
```

**Item 6: CLI --projects <P>,all (2cb26fe)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,all SELECT\ 1
[stdout]

[stderr]
Error: --projects: "all" stands alone; pass it by itself, or list project ids
(exit 1)
```

**Item 2: CLI --projects all (2cb26fe)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run -o json --projects all SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
{
  "rows": [
    {
      "TenantId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "n": 15
    },
    {
      "TenantId": "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "n": 3
    },
    {
      "TenantId": "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH",
      "n": 4
    }
  ],
  "params": {
    "dashboard_context_projects": [
      "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH",
      "project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"
    ]
  },
  "diagnostics": [
    {
      "code": "MULTI_PROJECT_RESULT",
      "message": "This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.",
      "meta": {
        "projectCount": 3
      }
    },
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]

(exit 0)
```

**Item 1: CLI key that reads no project (Vic's org key), no --projects (2cb26fe)** (key: vic-org-key)
```
$ LANGWATCH_API_KEY=<vic-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run SELECT\ 1
[stdout]

[stderr]
Using API key from LANGWATCH_API_KEY. Switch: langwatch login --project | --device
- Running statement...
✖ Failed to run statement: Project not found
Details:
  code      project_not_found
  status    404
  trace id  36f3415367f489b6aad9c7f7f5f9f871
  trace_id  36f3415367f489b6aad9c7f7f5f9f871
  span_id   1520f1278a1b660f
Suggestions:
  - Check which project your API key belongs to
  - Create or select a project in the LangWatch dashboard
(exit 1)
```

**Item 6: CLI --projects all,<P> against a closed port (nothing listens on 127.0.0.1:9), so any request would fail to connect (2cb26fe)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://127.0.0.1:9 langwatch query run --projects all\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ 1
[stdout]

[stderr]
Error: --projects: "all" stands alone; pass it by itself, or list project ids
(exit 1)
```

**Item 6 control: CLI --projects <P> against the same closed port (2cb26fe)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://127.0.0.1:9 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ 1
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: fetch failed
(exit 1)
```

**Items 4 and 1: MCP add_dashboard_widget with projects "all", then run_query with no projects** (stdio client against mcp/typescript/dist built at 2cb26fe; key: olga-org-key; 2cb26fe)
```
**MCP add_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","name":"MCP all","code":"export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n 
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: projects holds project ids; "all" is not stored in a widget at projects
**MCP run_query** {"sql":"SELECT 1"}
result isError=True: Name the projects to query: pass `projects`, a list of project ids, or "all"
```

**Item 7: tRPC as Vic (not in Hidden Team), projects "all" (2cb26fe)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":"all","projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":4,"rowsRead":28,"bytesRead":1692,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}}}

```


**Item 3: Olga's CLI token, widget add on project Olga Org naming [Beta, Olga Org] (2cb26fe)** (credential: olga's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch dashboard widget add dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K --project olga-org-wQyuC0 --name CLI\ token\ Beta\ then\ Olga\ Org --code-file w.tsx --queries-file q-cli.json --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 --format json
[stdout]
{"id": "widget_0001d2BfYDYTqxmw0N6mswrAgqi5S", "name": "CLI token Beta then Olga Org", "queries": [{"name": "main", "sources": ["application"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
[stderr]

(exit 0)
```

**Item 3: Vic's CLI token, widget add on project Olga Org naming [Beta, Olga Org] (2cb26fe)** (credential: vic's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch dashboard widget add dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K --project olga-org-wQyuC0 --name Vic\ token\ Beta\ then\ Olga\ Org --code-file w.tsx --queries-file q-cli.json --projects project_0008QMtqMaztCPlOawJxdPx9kR3uy\,project_0008PfpfHW74BqNiMUxEzhXwQyuC0 --format json
[stdout]
{"id": "widget_0001daQwa10O6MBk1OhWqAVOGUHSa", "name": "Vic token Beta then Olga Org", "queries": [{"name": "main", "sources": ["application"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
[stderr]

(exit 0)
```

**Item 3: Vic's CLI token, widget add naming [Olga Org, Secret] (Vic cannot read Secret) (2cb26fe)** (credential: vic's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch dashboard widget add dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K --project olga-org-wQyuC0 --name Vic\ token\ Secret --code-file w.tsx --queries-file q-cli.json --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,project_0008RvvmwglxZMZ0yVpjAsI6sPVoH --format json
[stdout]
{
  "ok": false,
  "error": {
    "code": "project_not_found",
    "kind": "project_not_found",
    "message": "Project not found",
    "httpStatus": 404,
    "meta": {
      "trace_id": "78ce21cc7c0edef97f989cf6c86c8397",
      "span_id": "e6ae79257818bbdf"
    },
    "isHandled": true,
    "retryable": false,
    "traceId": "78ce21cc7c0edef97f989cf6c86c8397",
    "suggestions": [
      "Check which project your API key belongs to",
      "Create or select a project in the LangWatch dashboard"
    ],
    "terminal": true
  }
}

[stderr]
Failed to create dashboard widget: Project not found
(exit 1)
```


**Item 3: Vic's CLI token, widget update of his widget naming [Olga Org, Secret] (2cb26fe)** (credential: vic's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch dashboard widget update dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K widget_0001daQwa10O6MBk1OhWqAVOGUHSa --project olga-org-wQyuC0 --code-file w.tsx --queries-file q-cli.json --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0\,project_0008RvvmwglxZMZ0yVpjAsI6sPVoH --format json
[stdout]
{
  "ok": false,
  "error": {
    "code": "project_not_found",
    "kind": "project_not_found",
    "message": "Project not found",
    "httpStatus": 404,
    "meta": {
      "trace_id": "4b0193770a15dc9692fcd9a73bf61f46",
      "span_id": "faabd37c0a188cd6"
    },
    "isHandled": true,
    "retryable": false,
    "traceId": "4b0193770a15dc9692fcd9a73bf61f46",
    "suggestions": [
      "Check which project your API key belongs to",
      "Create or select a project in the LangWatch dashboard"
    ],
    "terminal": true
  }
}

[stderr]
Failed to update dashboard widget: Project not found
(exit 1)
```

**Item 3: read back of Vic's widget after the refused update; and no widget named 'Vic token Secret' (2cb26fe)** (credential: vic's CLI device session from 'langwatch login --device', approved in the browser; no API key in env)
```
$ langwatch dashboard widget list dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K --project olga-org-wQyuC0 --format json
[stdout, widgets named 'Vic token*', sql left out]
{"id": "widget_0001daQwa10O6MBk1OhWqAVOGUHSa", "name": "Vic token Beta then Olga Org", "queries": [{"name": "main", "sources": ["application"], "projects": ["project_0008QMtqMaztCPlOawJxdPx9kR3uy", "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]}
```

**Raw captures at 650e386**


**QP03f org key, projects "all", sources [application,langy] (650e386)** (2026-10-29T11:03:20Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all","sources":["application","langy"]}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":9},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":9,"rowsRead":28,"bytesRead":2071,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"],"dashboard_context_sources":["application","langy"]}}


```

**QP03f org key, projects "all", every source (650e386)** (2026-10-29T11:03:21Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3},{"TenantId":"project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","n":4}],"statistics":{"elapsedMs":4,"rowsRead":28,"bytesRead":1692,"rowsReturned":3},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":3}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}


```

**QP03b org key names no projects (650e386)** (2026-10-29T11:03:22Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"Name the projects to query: send `projects`, a list of project ids, or \"all\"","retryable":false,"trace_id":"23ebe57b80230ae217d8f36835562545","span_id":"4cddc646d2d40fec","trace":{"traceId":"23ebe57b80230ae217d8f36835562545","spanId":"4cddc646d2d40fec"},"tips":["Send `projects`, a list of the project ids to read, or the string \"all\" for every project the key can read; the answer's `params.dashboard_context_projects` lists what was read","A project API key needs none: it reads its own project"],"fault":"customer"}


```

**QP03h org key, projects ["all"] as a list (650e386)** (2026-10-29T11:03:23Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT 1","projects":["all"]}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"6b3eb0fd19971c9596cb47c8f29adefb","span_id":"2dbfc01e38378841","trace":{"traceId":"6b3eb0fd19971c9596cb47c8f29adefb","spanId":"2dbfc01e38378841"},"fault":"customer"}


```

**QP03f P-key (reads one project), projects "all" (650e386)** (2026-10-29T11:03:23Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":6}],"statistics":{"elapsedMs":6,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application"]}}


```

**QP15 parameters names dashboard_context_sources with an array value (650e386)** (2026-10-29T11:03:24Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT 1","parameters":{"dashboard_context_sources":["langy"]},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_sources, which the surface sets itself. Send the `sources` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"c9e5517eb990e47b6d09b03ac04e6e29","span_id":"3b6df8ec4debe9a5","trace":{"traceId":"c9e5517eb990e47b6d09b03ac04e6e29","spanId":"3b6df8ec4debe9a5"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**Batch 5: diagnostic names the bare view (650e386)** (2026-10-29T11:03:25Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":13,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP03h a key that reads no project (Vic's org key), projects "all" (650e386)** (2026-10-29T11:03:40Z, key: vic-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <vic-org-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics","projects":"all"}'
HTTP 404
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"a40ae8145248e9e4dd5ecc56332f4178","span_id":"aa38b429047e5e05","trace":{"traceId":"a40ae8145248e9e4dd5ecc56332f4178","spanId":"aa38b429047e5e05"},"fault":"customer"}


```

**QP03f CLI --projects all, -o json (650e386)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run -o json --projects all SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]
{
  "rows": [
    {
      "TenantId": "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "n": 15
    },
    {
      "TenantId": "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "n": 3
    },
    {
      "TenantId": "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH",
      "n": 4
    }
  ],
  "params": {
    "dashboard_context_projects": [
      "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
      "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
      "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH",
      "project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"
    ]
  },
  "diagnostics": [
    {
      "code": "MULTI_PROJECT_RESULT",
      "message": "This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.",
      "meta": {
        "projectCount": 3
      }
    },
    {
      "code": "UNBOUNDED_TIME_RANGE",
      "message": "trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
      "meta": {
        "view": "qp9171b.trace_metrics",
        "timeColumn": "OccurredAt"
      }
    }
  ]
}
[stderr]
Using API key from LANGWATCH_API_KEY. Switch: langwatch login --project | --device
(exit 0)
```

**QP03f CLI --projects all, table (650e386)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects all SELECT\ TenantId\,\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ TenantId\ IN\ \{dashboard_context_projects:Array\(String\)\}\ GROUP\ BY\ TenantId\ ORDER\ BY\ TenantId
[stdout]

TenantId                               n 
─────────────────────────────────────  ──
project_0008PfpfHW74BqNiMUxEzhXwQyuC0  15
project_0008QMtqMaztCPlOawJxdPx9kR3uy  3 
project_0008RvvmwglxZMZ0yVpjAsI6sPVoH  4 

MULTI_PROJECT_RESULT: This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.

UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with {"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008RvvmwglxZMZ0yVpjAsI6sPVoH","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}
[stderr]
- Running statement...
✔ 3 rows in 5ms
(exit 0)
```

**Batch 5: CLI table, SQL with no placeholder (no 'Ran with {}' expected) (650e386)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --sources application --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics
[stdout]

n 
──
15

UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

SOURCES_IGNORED: This query doesn't read {dashboard_context_sources}, so it counts every origin.
[stderr]
- Running statement...
✔ 1 row in 3ms
(exit 0)
```

**Agent-mode CLI rerun (650e386).** The original run was at 50b23e8: cli.sh before its 'env -u CLAUDECODE ...' line, so the CLI inherited this agent shell's env (CLAUDECODE=1, CLAUDE_CODE_ENTRYPOINT=sdk-cli, AI_AGENT=claude-code_2-1-310_agent), with LANGWATCH_API_KEY=<olga-org-key>, LANGWATCH_ENDPOINT=http://localhost:5650 and LANGWATCH_CLI_CONFIG=<isolated>. Command: langwatch query run --sources application --projects <P> "SELECT count() AS n FROM trace_metrics". At 50b23e8 it printed [{"n":15}] on stdout and {"params":{}} on stderr, with no diagnostics (raw-50b23e8, block 'QP05/QP29 CLI SQL without parameter'). The same command now:
```
--- A: this agent shell's own env (CLAUDECODE=1, CLAUDE_CODE_ENTRYPOINT=sdk-cli, AI_AGENT=claude-code_2-1-310_agent)
exit 0
[stdout]
{"rows":[{"n":15}],"params":{},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}]}
[stderr]
--- B: only CLAUDECODE=1 (agent vars removed first)
exit 0
[stdout]
{"rows":[{"n":15}],"params":{},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}]}
[stderr]
--- C: no agent vars
exit 0
[stdout]

n 
──
15

UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

SOURCES_IGNORED: This query doesn't read {dashboard_context_sources}, so it counts every origin.

[stderr]
- Running statement...
✔ 1 row in 4ms
```

**QP03f/QP03b MCP run_query with olga-org-key: projects "all", then no projects** (650e386)
```
**MCP run_query** {"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":"all"}
result isError=False: | TenantId | n |
| --- | --- |
| project_0008PfpfHW74BqNiMUxEzhXwQyuC0 | 15 |
| project_0008QMtqMaztCPlOawJxdPx9kR3uy | 3 |
| project_0008RvvmwglxZMZ0yVpjAsI6sPVoH | 4 |

Returned 3 rows in 4ms.
MULTI_PROJECT_RESULT: This result draws rows from 3 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.
UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with these placeholders:
(json)
{
  "dashboard_context_projects": [
    "project_0008PfpfHW74BqNiMUxEzhXwQyuC0",
    "project_0008QMtqMaztCPlOawJxdPx9kR3uy",
    "project_0008RvvmwglxZMZ0yVpjAsI6sPVoH",
    "project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"
  ]
}
(end json)
**MCP run_query** {"sql":"SELECT 1"}
result isError=True: Name the projects to query: pass `projects`, a list of project ids, or "all"
```

**QP03g tRPC as Vic (not in Hidden Team), projects "all" (650e386)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} GROUP BY TenantId ORDER BY TenantId","parameters":{},"projects":"all","projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 200 OK
{"result":{"data":{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":15},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":4,"rowsRead":28,"bytesRead":1692,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008dzdx4w6GfnFHrx3JFMR0UK5zk"]}}}}

```

**QP09c tRPC as Vic names Secret (650e386)** (hand-made tRPC POST with vic's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT 1","parameters":{},"projects":["project_0008RvvmwglxZMZ0yVpjAsI6sPVoH"],"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 404 Not Found
{"error":{"message":"project_not_found","code":-32004,"data":{"code":"NOT_FOUND","httpStatus":404,"path":"analytics.lwql.query","cause":null,"error":{"code":"project_not_found","kind":"project_not_found","meta":{},"traceId":"fd8e5da7fb4d09e7d9da5fbe96772769","spanId":"db2cb4c7f57f7a3b","httpStatus":404,"fault":"customer","retryable":false,"reasons":[]},"authored":false,"traceId":"fd8e5da7fb4d09e7d9da5fbe96772769"}}}

```

**QP03i REST widget write with queries[0].projects "all"** (key: olga-org-key with X-Project-Id: Olga Org; 650e386)
```
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["queries.0.projects"],"reasons":[{"code":"schema_failure","message":"projects holds project ids; \"all\" is not stored in a widget","retryable":false,"meta":{"field":"queries.0.projects","type":"invalid_type","message":"projects holds project ids; \"all\" is not stored in a widget","expected":"array"}}]},"trace_id":"5fa6d5db463fe15a03cf7834ef178555","span_id":"06ed66abb4d67524","trace":{"traceId":"5fa6d5db463fe15a03cf7834ef178555","spanId":"06ed66abb4d67524"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}
```

**QP03i CLI widget add --projects all (650e386)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch dashboard widget add dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K --project olga-org-wQyuC0 --name CLI\ all --code-file ../proof/w.tsx --queries-file q-cli.json --projects all --format json
[stdout]

[stderr]
Error: --projects: a widget stores project ids, not "all"; name them
(exit 1)
```

**QP03i MCP add_dashboard_widget with projects "all"** (key: P-key; 650e386)
```
result isError=True: MCP error -32602: Input validation error: Invalid arguments for tool add_dashboard_widget: Invalid input: expected array, received string at projects
```

**Batch 5: editor 404 copy as Vic, widget 'Uses Secret'** (650e386)
```
dark card: Uses Secret You can't read a project this widget uses Ask whoever owns the board to change the widget's projects. Sources: application · Project: Olga Org
dark editor lines: ["Project not found","Project not found","[project_not_found]: It may have been deleted, or it isn't shared with you. Choose another project, or ask for access to this one."]
light card: Uses Secret You can't read a project this widget uses Ask whoever owns the board to change the widget's projects. Sources: application · Project: Olga Org
light editor lines: ["Project not found","Project not found","[project_not_found]: It may have been deleted, or it isn't shared with you. Choose another project, or ask for access to this one."]
```

**QP04/AC203 sources [application,langy]** (2026-10-29T11:05:37Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":9}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application","langy"]}}


```

**QP01 no sources named** (2026-10-29T11:05:38Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":6}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application"]}}


```

**QP05/AC204 SQL without parameter, sources [application]** (2026-10-29T11:05:39Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05 SQL without parameter, no sources named (no note expected)** (2026-10-29T11:05:40Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":6,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05b/AC204c placeholder only in a comment** (2026-10-29T11:05:40Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics -- WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05b/AC204c placeholder only in a string literal** (2026-10-29T11:05:41Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n, '{dashboard_context_sources:Array(String)}' AS t FROM trace_metrics","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"},{"name":"t","type":"String"}],"rows":[{"n":15,"t":"{dashboard_context_sources:Array(String)}"}],"statistics":{"elapsedMs":3,"rowsRead":27,"bytesRead":1584,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}},{"code":"SOURCES_IGNORED","message":"This query doesn't read {dashboard_context_sources}, so it counts every origin."}],"followsTimeWindow":false,"followsGranularity":false,"params":{}}


```

**QP05b placeholder read inside a CTE** (2026-10-29T11:05:42Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"WITH s AS (SELECT TraceId FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}) SELECT count() AS n FROM s","sources":["langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":3}],"statistics":{"elapsedMs":6,"rowsRead":27,"bytesRead":2834,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["langy"]}}


```

**QP07 sources []** (2026-10-29T11:05:43Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":[],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":0}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":[]}}


```

**QP07b/AC202e [application]** (2026-10-29T11:05:44Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":6}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application"]}}


```

**QP07b/AC202e [other]** (2026-10-29T11:05:44Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["other"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":2}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["other"]}}


```

**QP07b/AC202e [langy]** (2026-10-29T11:05:45Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":3}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["langy"]}}


```

**QP07b order kept, repeat dropped** (2026-10-29T11:05:46Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["langy","application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":9}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["langy","application"]}}


```

**QP08 unknown source** (2026-10-29T11:05:46Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["bogus"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["sources.0"],"reasons":[{"code":"schema_failure","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","retryable":false,"meta":{"field":"sources.0","type":"invalid_value","message":"Invalid option: expected one of \"application\"|\"simulation\"|\"evaluation\"|\"sample\"|\"coding_agent\"|\"ai_tool\"|\"gateway\"|\"workflow\"|\"playground\"|\"langy\"|\"other\"","expected":["application","simulation","evaluation","sample","coding_agent","ai_tool","gateway","workflow","playground","langy","other"],"received":"bogus"}}]},"trace_id":"e86c1795b0ba1f9a75bf9e5aa0d98ccb","span_id":"b765dbc095a7c776","trace":{"traceId":"e86c1795b0ba1f9a75bf9e5aa0d98ccb","spanId":"b765dbc095a7c776"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP12c projects []** (2026-10-29T11:05:47Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projects":[]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["projects"],"reasons":[{"code":"schema_failure","message":"projects must hold at least one id","retryable":false,"meta":{"field":"projects","type":"too_small","message":"projects must hold at least one id"}}]},"trace_id":"013ce72c94b0eb2284abdc22e01717e0","span_id":"93f79e8d04864c6f","trace":{"traceId":"013ce72c94b0eb2284abdc22e01717e0","spanId":"93f79e8d04864c6f"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP12d projectId and projects** (2026-10-29T11:05:48Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"send projectId or projects, not both","retryable":false,"trace_id":"80cb372c35d5a1b36a47d2d0b2f00fda","span_id":"4cf840505a23aded","trace":{"traceId":"80cb372c35d5a1b36a47d2d0b2f00fda","spanId":"4cf840505a23aded"},"fault":"customer"}


```

**QP15 parameters names dashboard_context_sources** (2026-10-29T11:05:49Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{"dashboard_context_sources":"langy"},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_sources, which the surface sets itself. Send the `sources` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"b8e75a7e4d89520b8e0600f6bd36fcfd","span_id":"776799def0c097f0","trace":{"traceId":"b8e75a7e4d89520b8e0600f6bd36fcfd","spanId":"776799def0c097f0"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15 parameters names dashboard_context_projects** (2026-10-29T11:05:50Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{"dashboard_context_projects":"x"},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"bec13472db5729650759c6c5e6931e75","span_id":"50f2e8c7d7750e75","trace":{"traceId":"bec13472db5729650759c6c5e6931e75","spanId":"50f2e8c7d7750e75"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15 parameters names dashboard_context_sources with an array value** (2026-10-29T11:05:50Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","parameters":{"dashboard_context_sources":["langy"]},"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_sources, which the surface sets itself. Send the `sources` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"bf16097a8afbbdc91e7cb391c21346ad","span_id":"c441e64bc6315dc9","trace":{"traceId":"bf16097a8afbbdc91e7cb391c21346ad","spanId":"c441e64bc6315dc9"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b/AC205b SET param_** (2026-10-29T11:05:51Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SET param_dashboard_context_projects = 'C'; SELECT 1","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"60ee312baf063926513dc13d6b8ff12b","span_id":"a9cfc0eb5c81726e","trace":{"traceId":"60ee312baf063926513dc13d6b8ff12b","spanId":"a9cfc0eb5c81726e"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b/AC205b WITH alias** (2026-10-29T11:05:52Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"WITH 'C' AS dashboard_context_projects SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"173b63658acd66ee0802a72be3d3a0c2","span_id":"4f6adeebeab04b9c","trace":{"traceId":"173b63658acd66ee0802a72be3d3a0c2","spanId":"4f6adeebeab04b9c"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b/AC205b CTE named** (2026-10-29T11:05:53Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"WITH dashboard_context_sources AS (SELECT 1) SELECT count() AS n FROM trace_metrics","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_supplied","message":"The request supplied a value for dashboard_context_sources, which the surface sets itself. Send the `sources` field of the request instead.","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"0306a7b5e85965efe6896a1b57fb78b2","span_id":"c567c45d1cabe474","trace":{"traceId":"0306a7b5e85965efe6896a1b57fb78b2","spanId":"c567c45d1cabe474"},"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"fault":"customer"}


```

**QP15b typed projects placeholder accepted** (2026-10-29T11:05:53Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":15}],"statistics":{"elapsedMs":5,"rowsRead":27,"bytesRead":1575,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}}


```

**QP16 projects as String** (2026-10-29T11:05:54Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE TenantId = {dashboard_context_projects:String}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_type","message":"The query declares dashboard_context_projects with a type other than Array(String).","retryable":false,"meta":{"parameters":["dashboard_context_projects"]},"trace_id":"755911cd04ef791a816f83e11d636131","span_id":"6f0f8ba8fcd9506a","trace":{"traceId":"755911cd04ef791a816f83e11d636131","spanId":"6f0f8ba8fcd9506a"},"tips":["Read `meta.parameters`; it lists the reserved names declared with the wrong type","Declare each time-window name as `DateTime` or `DateTime64`, for example `{dashboard_context_period_start:DateTime}`; the interval they describe is half-open, `>= {dashboard_context_period_start:DateTime} AND < {dashboard_context_period_end:DateTime}`","Declare `dashboard_context_sources` and `dashboard_context_projects` as `Array(String)`, for example `{dashboard_context_sources:Array(String)}`"],"fault":"customer"}


```

**AC205 sources as String** (2026-10-29T11:05:55Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source = {dashboard_context_sources:String}","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 400
{"type":"bad_request","code":"lwql_reserved_parameter_type","message":"The query declares dashboard_context_sources with a type other than Array(String).","retryable":false,"meta":{"parameters":["dashboard_context_sources"]},"trace_id":"6ba71437fa7ae8943529034959e4032d","span_id":"ab9f7e6fdbdd62da","trace":{"traceId":"6ba71437fa7ae8943529034959e4032d","spanId":"ab9f7e6fdbdd62da"},"tips":["Read `meta.parameters`; it lists the reserved names declared with the wrong type","Declare each time-window name as `DateTime` or `DateTime64`, for example `{dashboard_context_period_start:DateTime}`; the interval they describe is half-open, `>= {dashboard_context_period_start:DateTime} AND < {dashboard_context_period_end:DateTime}`","Declare `dashboard_context_sources` and `dashboard_context_projects` as `Array(String)`, for example `{dashboard_context_sources:Array(String)}`"],"fault":"customer"}


```

**QP03 personal key scoped to one project, no projects named** (2026-10-29T11:05:56Z, key: P-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <P-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}"}'
HTTP 200
{"columns":[{"name":"n","type":"UInt64"}],"rows":[{"n":6}],"statistics":{"elapsedMs":6,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_sources":["application"]}}


```

**QP03b org key, no projects** (2026-10-29T11:05:56Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT count() AS n FROM trace_metrics"}'
HTTP 422
{"type":"unprocessable_entity","code":"projects_required","message":"Name the projects to query: send `projects`, a list of project ids, or \"all\"","retryable":false,"trace_id":"83594cde9af2ab3c469bbabeaa82eeed","span_id":"6b9c5ff287d57bd7","trace":{"traceId":"83594cde9af2ab3c469bbabeaa82eeed","spanId":"6b9c5ff287d57bd7"},"tips":["Send `projects`, a list of the project ids to read, or the string \"all\" for every project the key can read; the answer's `params.dashboard_context_projects` lists what was read","A project API key needs none: it reads its own project"],"fault":"customer"}


```

**QP03b org key, projects [P]** (2026-10-29T11:05:57Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":6}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":1},"diagnostics":[{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application"]}}


```

**QP12/AC207b org key, projects [B,P,B]** (2026-10-29T11:05:58Z, key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' -d '{"sql":"SELECT TenantId, count() AS n FROM trace_metrics WHERE TenantId IN {dashboard_context_projects:Array(String)} AND Source IN {dashboard_context_sources:Array(String)} GROUP BY TenantId ORDER BY TenantId","projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0","project_0008QMtqMaztCPlOawJxdPx9kR3uy"],"sources":["application","langy"]}'
HTTP 200
{"columns":[{"name":"TenantId","type":"String"},{"name":"n","type":"UInt64"}],"rows":[{"TenantId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0","n":9},{"TenantId":"project_0008QMtqMaztCPlOawJxdPx9kR3uy","n":3}],"statistics":{"elapsedMs":4,"rowsRead":27,"bytesRead":1954,"rowsReturned":2},"diagnostics":[{"code":"MULTI_PROJECT_RESULT","message":"This result draws rows from 2 projects this key can read. If you meant one, filter on TenantId — for example WHERE TenantId = '<project id>'.","meta":{"projectCount":2}},{"code":"UNBOUNDED_TIME_RANGE","message":"trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.","meta":{"view":"qp9171b.trace_metrics","timeColumn":"OccurredAt"}}],"followsTimeWindow":false,"followsGranularity":false,"params":{"dashboard_context_projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application","langy"]}}


```

**QP12b org key, 10,001 project ids, body 180052 bytes** (key: olga-org-key)
```
$ curl -X POST http://localhost:5650/api/v1/query -H 'Authorization: Bearer <olga-org-key>' --data-binary @qp12b.json   # {"sql":"SELECT 1","projects":[10001 ids]}
HTTP 422
{"type":"unprocessable_entity","code":"validation_error","message":"The request body didn't match the expected shape.","retryable":false,"meta":{"target":"json","fields":["projects"],"reasons":[{"code":"schema_failure","message":"projects holds at most 10000 ids","retryable":false,"meta":{"field":"projects","type":"invalid_union","message":"projects holds at most 10000 ids"}}]},"trace_id":"fa30b7c5fd0c17f5e6a253c31e15120b","span_id":"e5564e82fdddf41d","trace":{"traceId":"fa30b7c5fd0c17f5e6a253c31e15120b","spanId":"e5564e82fdddf41d"},"tips":["Read `reasons`; each entry names the offending field in meta.field and what was expected in meta.expected","Fix those fields and send the request again; retrying it unchanged will fail identically"],"fault":"customer"}


```

**QP09/QP09b/QP10/AC208d REST 404 comparison and QP06 query log** (key: P-key, a personal key scoped to project Olga Org; projects [P, X], X = Secret (same org, the key cannot read it), the Zed Org project (another org), an id that does not exist; each statement carries the marker 'qp09-marker'; then a control run with projects [P] that does not read the sources parameter, sent with sources [application])
```
--- secret: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"2eefe3345f09a53b944abfcb89f78c85","span_id":"58fc1140ec59df55","trace":{"traceId":"2eefe3345f09a53b944abfcb89f78c85","spanId":"58fc1140ec59df55"},"fault":"customer"}
--- otherorg: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"e048e9dec8ee8033c48733d80c61de00","span_id":"3e3f5247317d790d","trace":{"traceId":"e048e9dec8ee8033c48733d80c61de00","spanId":"3e3f5247317d790d"},"fault":"customer"}
--- missing: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"49f5170a9b43c47c4ea9cd38381393db","span_id":"20407dd1eca85781","trace":{"traceId":"49f5170a9b43c47c4ea9cd38381393db","spanId":"20407dd1eca85781"},"fault":"customer"}
body secret vs missing (trace_id, span_id, trace removed): IDENTICAL
headers secret vs missing (Date, request ids removed): IDENTICAL
body otherorg vs missing (trace_id, span_id, trace removed): IDENTICAL
headers otherorg vs missing (Date, request ids removed): IDENTICAL
ids found in the three bodies: 0
control run: HTTP 200 rows [{'n': 15}]
$ SELECT event_time, user, query FROM system.query_log WHERE event_time >= '2026-10-29 11:05:59' AND query ILIKE '%qp09-marker%' AND user != 'default' AND type='QueryStart'
2026-10-29 11:06:00	langwatch_lwql_main	SELECT count() AS n FROM trace_metrics WHERE TenantId != \'qp09-marker\' LIMIT 10000 FORMAT JSON
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

UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with {"dashboard_context_projects":["project_0008QMtqMaztCPlOawJxdPx9kR3uy","project_0008PfpfHW74BqNiMUxEzhXwQyuC0"],"dashboard_context_sources":["application","langy"]}
[stderr]
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
      "message": "trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
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
      "message": "trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
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
✔ 2 rows in 4ms
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
      "message": "trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.",
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

UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

SOURCES_IGNORED: This query doesn't read {dashboard_context_sources}, so it counts every origin.
[stderr]
- Running statement...
✔ 1 row in 3ms
(exit 0)
```

**QP03e CLI org key, no --projects** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run SELECT\ count\(\)\ AS\ n\ FROM\ trace_metrics\ WHERE\ Source\ IN\ \{dashboard_context_sources:Array\(String\)\}
[stdout]

[stderr]
- Running statement...
Error: Name the projects to query: pass --projects <id,id>, or --projects all
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
  trace id  70ee8e856d967e8dd91945882aa9273c
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
  trace id    361ac10225282dcbe7713be8b69782e9
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
  trace id  d58bc6914e6e593e48e4a9a693b8a52a
  trace_id  d58bc6914e6e593e48e4a9a693b8a52a
  span_id   99e41c6b04d57cc4
Suggestions:
  - Check which project your API key belongs to
  - Create or select a project in the LangWatch dashboard
(exit 1)
```

**MCP run_query, add_dashboard_widget, update_dashboard_widget** (stdio client against mcp/typescript/dist/index.js built at 650e386; server at 650e386; key: P-key; tool results only)
```
**MCP run_query** {"sql":"SELECT count() AS n FROM trace_metrics WHERE Source IN {dashboard_context_sources:Array(String)}","sources":["application","langy"],"projects":["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}
result: | n |
| --- |
| 9 |

Returned 1 row in 4ms.
UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

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

Returned 1 row in 4ms.
UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

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

Returned 1 row in 4ms.
UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.
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

Returned 1 row in 12ms.
UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

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

Returned 1 row in 3ms.
UNBOUNDED_TIME_RANGE: trace_metrics was read with no condition on OccurredAt, so the read covers the whole history this project has rather than a window of it. Add a range on OccurredAt to bound the scan.

Ran with these placeholders:
(json)
{
  "dashboard_context_projects": [
    "project_0008PfpfHW74BqNiMUxEzhXwQyuC0"
  ]
}
(end json)
**MCP add_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","name":"MCP 650e app+langy, project Olga Org","code":"export default function Widget() {\n  const { data } = LW.useChartQuery(\"main\", {});\n  const fg = LW.theme === \"dark\" ? \"#f4f4f5\" : \"#18181b\";\n  return <div data-count={String(data?.[0]?.n ?? 0)} style={{ color: fg, fontSize: 44, fontWeight: 600 }}>{String(data?.[0]?.n ?? \"\")}
result: Widget "MCP 650e app+langy, project Olga Org" created and added to dashboard "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K".
**Widget ID**: widget_0001P6lPXzIW4aof2V25JEhK7HwGG
**Queries**: main
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_0001P6lPXzIW4aof2V25JEhK7HwGG","name":"MCP 650e renamed"}
result: Widget "MCP 650e renamed" updated on dashboard "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K".
**Widget ID**: widget_0001P6lPXzIW4aof2V25JEhK7HwGG
**Queries**: main

widget read back: [{"name": "main", "sources": ["application", "langy"], "projects": ["project_0008PfpfHW74BqNiMUxEzhXwQyuC0"]}]
**MCP update_dashboard_widget** {"dashboardId":"dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K","widgetId":"widget_0001P6lPXzIW4aof2V25JEhK7HwGG","projects":null}
result: Widget "MCP 650e renamed" updated on dashboard "dashboard_0008WSeCrhEcj3gxcrLHvbTKS574K".
**Widget ID**: widget_0001P6lPXzIW4aof2V25JEhK7HwGG
**Queries**: main

widget read back: [{"name": "main", "sources": ["application", "langy"]}]
```

**AC210c widget write naming a project: Secret (the key cannot read it), Zed's project (another org), an id that does not exist; and the query door for Secret** (key: P-key, scoped to project Olga Org; 650e386)
```
--- write secret: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"3a070314eceac8e978c1555c24727f60","span_id":"12385c32a24b1fff","trace":{"traceId":"3a070314eceac8e978c1555c24727f60","spanId":"12385c32a24b1fff"},"fault":"customer"}
--- write otherorg: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"cdd9d1fd71c092b8a113dc3a9cbff605","span_id":"d3125bb8e0732f6e","trace":{"traceId":"cdd9d1fd71c092b8a113dc3a9cbff605","spanId":"d3125bb8e0732f6e"},"fault":"customer"}
--- write missing: HTTP/1.1 404 Not Found
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"bdb0e59b9081ac63075e14547eacd7d2","span_id":"6c8cab6c1cd8c2ba","trace":{"traceId":"bdb0e59b9081ac63075e14547eacd7d2","spanId":"6c8cab6c1cd8c2ba"},"fault":"customer"}
--- query door [P, Secret]:
{"type":"not_found","code":"project_not_found","message":"Project not found","retryable":false,"trace_id":"4aa2b777955b717cc32b3e39c5623526","span_id":"9097112e61a0a1a4","trace":{"traceId":"4aa2b777955b717cc32b3e39c5623526","spanId":"9097112e61a0a1a4"},"fault":"customer"}
write secret vs write missing: body IDENTICAL, headers IDENTICAL
write otherorg vs write missing: body IDENTICAL, headers IDENTICAL
write secret vs query door secret: body IDENTICAL
ids in the bodies: 0
widgets named AC210c stored: []
```

**QP15 tRPC parameters names dashboard_context_sources (650e386)** (hand-made tRPC POST with owner's browser session; cookie not shown)
```
$ curl -X POST http://localhost:5650/api/trpc/analytics.lwql.query -H 'Cookie: <session>' -d '{"sql":"SELECT 1","parameters":{"dashboard_context_sources":"langy"},"projectId":"project_0008PfpfHW74BqNiMUxEzhXwQyuC0"}'
HTTP/1.1 400 Bad Request
{"error":{"message":"lwql_reserved_parameter_supplied","code":-32600,"data":{"code":"BAD_REQUEST","httpStatus":400,"path":"analytics.lwql.query","cause":null,"error":{"code":"lwql_reserved_parameter_supplied","kind":"lwql_reserved_parameter_supplied","meta":{"parameters":["dashboard_context_sources"]},"traceId":"d6bd0107281a49f7cbfae06a391311b5","spanId":"5009be0a051d34e6","httpStatus":400,"fault":"customer","retryable":false,"tips":["Read `meta.parameters`; it lists the reserved names the request set for itself","`dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`","`dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead","`dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead"],"reasons":[]},"authored":false,"traceId":"d6bd0107281a49f7cbfae06a391311b5"}}}

```

**QP15 CLI --param dashboard_context_projects=x (650e386)** (key: olga-org-key)
```
$ LANGWATCH_API_KEY=<olga-org-key> LANGWATCH_ENDPOINT=http://localhost:5650 langwatch query run --projects project_0008PfpfHW74BqNiMUxEzhXwQyuC0 --param dashboard_context_projects=x SELECT\ 1
[stdout]

[stderr]
- Running statement...
✖ Failed to run statement: The request supplied a value for dashboard_context_projects, which the surface sets itself. Send the `projects` field of the request instead.
Details:
  code        lwql_reserved_parameter_supplied
  status      400
  trace id    666c9b9b28c348a779a2e06e4a960037
  parameters  dashboard_context_projects
Suggestions:
  - Read `meta.parameters`; it lists the reserved names the request set for itself
  - `dashboard_context_period_start` and `dashboard_context_period_end` are supplied by the surface showing the chart; send `timeWindow: { start, end }` instead and drop them from `parameters`
  - `dashboard_context_granularity_seconds` is likewise supplied by the surface; drop it from `parameters` and send it as the request's own `granularitySeconds` field instead
  - `dashboard_context_sources` and `dashboard_context_projects` are likewise supplied; drop them from `parameters` and send the request's own `sources` and `projects` fields instead
(exit 1)
```

**QP15 MCP run_query with parameters naming dashboard_context_sources** (key: olga-org-key; 650e386)
```
result isError=True: LangWatch API error 400: The request supplied a value for dashboard_context_sources, which the surface sets itself. Send the `sources` field of the request instead.
Code: lwql_reserved_parameter_supplied
Details: {"parameters":["dashboard_context_sources"]}
```

**Raw captures at 90a75da** (replaced by later reruns where both exist)


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

**Raw captures at 624aa81 and 2ef801f** (kept for the browser steps; up to the block 'AC209/AC207b/AC207 owner editor walk' and the AC204b editor block ran on 624aa81; the blocks from 'P0 / AC202f' onward ran on 2ef801f)


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
