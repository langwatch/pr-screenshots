# PR 9241 proof, redo: no error cards (head 3adaae58a9d)

Head: `3adaae58a9d87f1d7183001eb34798fa978aebf8` (no source changes).

## Flags forced on
`FEATURE_FLAG_FORCE_ENABLE=release_dashboards,release_lwql_workbench`
The workbench flag is `LWQL_FLAG = "release_lwql_workbench"` (modules/analytics/process/src/rules/lwql-access.rules.ts). LangWatchQL self-provisioned on the local stack from the local configuration.

## Steps
1. Create fresh databases `pr9241_proof_b` in local Postgres and ClickHouse .
2. `./env.sh pnpm dev` on port 5700 (own databases on pr9241_proof_b, own Redis index, aigateway and nlp skipped, SMTP to a local sink, flags above).
3. Sign up as proof9241d@example.com through the emailed link, create org "Proof 9241", pick "Monitor & evaluate my LLM app". Project slug: proof-9241-KibIqG.
4. One local fix outside the repo: the shared Postgres role `lwql_ro` has cluster-wide `search_path=mydb, public`, so ClickHouse could not find the `lwql_*` views in my schema (error: relation "lwql_prompt_versions" does not exist). I ran `ALTER ROLE lwql_ro IN DATABASE pr9241_proof_b SET search_path = pr9241_proof_b, public` (scoped to my database only).
5. In the UI, on "My dashboard", Add a widget > "How much work did my agent handle?".
6. `node proof.mjs proof-9241-KibIqG dashboard_00081NVkqBODhq62zDuE7IGYobhVR <dir>` (script waits for loading skeletons to clear, then asserts and screenshots at 1280x2400).

## Seeded data
None. No traces were seeded: widgets show honest empty states ("Connect traces to continue", "Run a scenario", "No prompt versions in this period", "Sources don't apply..."). Queries ran through LangWatchQL against ClickHouse with no errors.

## Assertions (raw, assertions.txt)
```
board {"h1":["My dashboard"],"oldNotice":false,"openAnalyticsLink":false,"errorCard":false,"retryButton":false,"badApiResponses":[],"url":"http://localhost:5700/proof-9241-KibIqG/dashboards/dashboard_00081NVkqBODhq62zDuE7IGYobhVR"}
curated {"h1":["Release check"],"oldNotice":false,"openAnalyticsLink":false,"errorCard":false,"retryButton":false,"badApiResponses":[],"url":"http://localhost:5700/proof-9241-KibIqG/dashboards/curated/release"}
templates {"h1":["Dashboard templates","Grow","Protect"],"oldNotice":false,"openAnalyticsLink":false,"errorCard":false,"retryButton":false,"badApiResponses":[],"url":"http://localhost:5700/proof-9241-KibIqG/dashboards/templates"}
ALL ASSERTIONS PASSED
```
Per page: no "Looking for the old Analytics" text, no "Open Analytics" link, no error text (Couldn't load, Something went wrong, failed to load, Unexpected error, We've been notified), no role=alert, no Retry button, no /api response with status >= 400.
I read each PNG: board.png (one widget, empty state), curated.png (five widgets: four honest empty states, one "No prompt versions in this period"), templates.png (library, no banner). No error card visible.

## Files
board.png, curated.png, templates.png, proof.mjs, assertions.txt. Setup scripts and the stack log are not published. proof.mjs needs a signed-in cookie file, which is not published either.
