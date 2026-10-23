# PR #7443 `langwatch chart` CLI — live QA transcript (2026-08-23)

Worktree: `/home/ubuntu/langwatch-langwatch-fp/.worktrees/issue6712-chart-cli`, branch `issue6712/lwql-langy-skill` (b5b19a3171; coordinator squashed a lint-only reformat mid-run → 09289d5170, content-identical).
Setup: dev server `PORT=5570 LANGWATCH_SKIP_AIGATEWAY=1 LANGWATCH_SKIP_NLP=1 pnpm dev` (5560 was held by another session); SDK built from `sdks/typescript` (`pnpm build`, postbuild self-check OK, v1.8.0); CLI driven as the real compiled binary `node dist/cli/index.js`.
Env for every command (values redacted): `LANGWATCH_API_KEY=<local-dev-project apiKey from Postgres>`, `LANGWATCH_ENDPOINT=http://localhost:5570`, `LANGWATCH_PROJECT_ID=local-dev-project`, `LANGWATCH_NO_DAEMON=1`.
LWQL: 5 `LWQL_*` vars copied from sibling worktree .env (points at harness container `dreamy_ishizaka` :33617, db `lwql_browser_qa`); `release_lwql_workbench` appended to `FEATURE_FLAG_FORCE_ENABLE`.
Tenant wiring: the harness key map (`lwql_browser_qa.api_key_tenants`) only knew `tenant-a`/`tenant-b`, so local-dev-project saw 0 rows. I inserted one row mapping sha256(local-dev-project's `Project.lwqlKey`) → `tenant-a` (left in place for future QA; the container is otherwise untouched).

## Per-verb results

### 1. `chart schema` — PASS
`langwatch chart schema` (agent mode auto-detected → compact JSON) returned `lwql_browser_qa` with the full dataset catalog (traces, spans, evaluations, …), per-column type/description/unit/availability, grain and time column. Artifact: `01-schema.txt`. Note: with no project in scope it refuses with a clear "No project is in scope. Pass --project or set LANGWATCH_PROJECT_ID." message.

### 2. `chart create` → `get` / `list` — PASS
```
langwatch chart create --name "QA Traces per bucket" --sql-file query.sql --spec-file spec.json -o json
```
(query.sql uses the reserved `{period_start}`/`{period_end}`/`{period_granularity_seconds}` parameters against `lwql_browser_qa.traces`.) Created id `9-mbFDTQh3m8iLxzTfJK5`. `chart get` round-tripped **identically** (create response == get response, key-by-key diff NONE; `definition.sql` byte-equal to the file; `definition.vegaLiteSpec` deep-equal to spec.json). `chart list -o json` showed exactly it. Artifacts: `02-create.json`, `03-get.json`, `04-list.json`.

### 3. `chart run` — PASS (with one doc bug + one error-surface bug, see Bugs)
- `chart run <id> --start 2026-01-01T00:00:00Z --end 2026-02-01T00:00:00Z --granularity 3600 -o json` → 4 rows, hour-aligned buckets, `granularitySeconds: 3600` echoed back, stats present (`05-run.json`).
- `--start` without `--end` → refused **locally** before any request: `Error: --start and --end must be given together`, exit 1.
- `--granularity 0` / non-integer → refused locally.
- `--granularity 86400` → server 400 (allowed steps are only 1/60/3600) — see Bug 2/3.
- Run without flags on a chart that declares the period params → server refuses "The query declares bound parameters the request did not supply values for" (exit 1). Reasonable, but see Bug 4 (the skill/docstring imply the flags are optional).

### 4. `chart update` rename — PASS
`chart update <id> --name "QA Traces per bucket (renamed)"` → get confirms new name (`06-update.json`).

### 5. `chart place` — PASS (money shot)
Seeded a dashboard via `langwatch dashboard create "QA CLI Dashboard"` (id `yJjooX-1szNhMGzvIDoGU`). `chart place <id> --dashboard-id <did>` answered `{dashboardId, gridColumn:0, gridRow:0, colSpan:1, rowSpan:1}`. Postgres row verified (`mydb."CustomGraph"`): dashboardId + all four grid fields persisted (`10-pg-placement.txt`). Browser (Playwright, logged in as the seeded haven admin) at `/local-dev-project/analytics/reports?dashboard=<did>`: the CLI-created chart renders as a live bar-chart widget with real data, including the granularity-coarsening notice. **Screenshot: `11-dashboard-placed.png`.**

### 6. `chart unplace` — PASS
`chart unplace <id>` → `dashboardId: null`; Postgres confirms NULL; dashboard reload shows the empty "Add your custom graphs here" state. **Screenshot: `13-dashboard-unplaced.png`** (`12-unplace.json`).

### 7. `chart delete` — FAIL (Bug 1)
The server deletes the chart (204; `chart list` → 0 afterwards) but the CLI then **crashes**: `Failed to delete chart: Cannot read properties of undefined (reading 'name')`, exit 1, wrapped in a `network_error` envelope. Every delete looks like a failure while having succeeded. `chart get <deleted-id>` → "Saved chart not found.", exit 1, JSON on stdout parses (named properly at message level; code mislabeled, see Bug 5). Artifacts: `14-delete.json`, `16-get-notfound.json`.

### 8. Failure paths / machine output
- SQL naming a **forbidden table** (the key map `lwql_browser_qa.api_key_tenants`) → named refusal at save time: "The submitted SQL is not permitted by the LangWatchQL analytics policy." Exit 1. (`18-forbidden-table.json`)
- SQL naming a **nonexistent column** (`SELECT SecretSauce FROM lwql_browser_qa.traces`) → **create succeeds** (Bug 6); running it then fails as "An unknown error occurred" (server log: ClickHouse UNKNOWN_IDENTIFIER). (`17-forbidden-col.json`, `19-run-forbidden.json`)
- **Policy-refused spec** (Vega-Lite with an external `data.url`) → named refusal: "The chart specification was refused by the visualization policy." Exit 1. (`20-bad-spec.json`)
- `-o json` parses with jq for schema/list/get/run/create/place/unplace; on failures stdout stays valid JSON (`{"ok":false,...}`) and the human line goes to stderr; exit codes 1 on failure, 0 on success (delete excepted, Bug 1).

## Bugs (repro; not fixed)

1. **`chart delete` crashes client-side after a successful delete.** Server route answers `204` with no body (`app.charts.v1.ts:381-405`), but `ChartsApiService.delete` types the response `{id,name}` and `delete.ts:25` reads `deleted.name` → TypeError, exit 1, misleading network_error envelope. Repro: create any chart, `langwatch chart delete <id>`. Files: `sdks/typescript/src/cli/commands/charts/delete.ts:22-27`, `sdks/typescript/src/client-sdk/services/charts/charts-api.service.ts:138-146`.

2. **`chart run --granularity` accepts values the API always refuses.** CLI validates only "positive integer"; server accepts only `LWQL_GRANULARITY_STEPS = [1, 60, 3600]`. `--granularity 86400` → 400. Either widen the server (day steps) or have the CLI name the allowed steps.

3. **The shipped `lwql-charts` skill teaches the refused value and the wrong flags.** `services/langyagent/internal/assets/skills/lwql-charts/SKILL.md` (and `skills/_compiled/native/lwql-charts/SKILL.md`) uses `--granularity 86400` in its canonical example (always 400s per Bug 2), and uses `--format json` throughout — the CLI has no `--format` flag (it is `-o/--output`); commander rejects it. An agent following the skill verbatim fails on both.

4. **Doc vs behavior on the reserved period params.** Skill Step 2 tells authors to declare `{period_start}`/`{period_end}` "instead of hardcoding dates", but `chart run <id>` without `--start/--end` then refuses ("declares bound parameters the request did not supply"). The skill never says the run flags become mandatory; either default the window server-side (the dashboard surface does) or say so.

5. **Every server error surfaces as `code: "network_error"`, `httpStatus: 0`, `isHandled: false`, with "Check your network connection" suggestions** — including handled refusals (`saved_workbench_chart_not_found`, policy refusals, validation 400s). The server's handled code/fieldErrors (e.g. `granularitySeconds` in `meta.fields`) are dropped, so `-o json` consumers can't branch on the real code and humans get wrong remediation. Seen on get-not-found, run validation errors, create refusals. (Likely a shared CLI error-mapping issue surfacing across the chart family.)

6. **Save-time validation does not refuse an unknown column.** `chart create` with `SELECT SecretSauce FROM lwql_browser_qa.traces` saves successfully; the failure only appears at run time as "An unknown error occurred" (ClickHouse UNKNOWN_IDENTIFIER degrades to unknown — a knowable failure surfaced generically, against the error-handling ADR-045 bar). The skill explicitly promises "a column your permissions withhold is refused by the validator at save time".

## Artifacts
All under `/tmp/pr5-cli-qa/`: `01-schema.txt`, `02-create.json`, `03-get.json`, `04-list.json`, `05-run.json`, `05b-run-noflags.json`, `05c-start-only.json`, `06-update.json`, `07-dashboards.json`, `08-dash-create.json`, `09-place.json`, `10-pg-placement.txt`, `11-dashboard-placed.png` (money shot), `12-unplace.json`, `13-dashboard-unplaced.png`, `14-delete.json`, `16-get-notfound.json`, `17-forbidden-col.json`, `18-forbidden-table.json`, `19-run-forbidden.json`, `20-bad-spec.json`, `query.sql`, `spec.json`.

Cleanup: all QA charts deleted (list=0), QA dashboard deleted, dev server killed. Container `dreamy_ishizaka` left running; one key-map row added mapping local-dev-project → tenant-a (intentional, reusable). `.env` changes in the worktree: appended 5 `LWQL_*` lines + `release_lwql_workbench` flag (untracked file).
