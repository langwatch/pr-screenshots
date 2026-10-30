# Follow-up PR 2 (Langy attribution) proof at 54ecc8e8c27

Branch: `tasks1003/langy-attribution-events` in langwatch/langwatch, head 54ecc8e8c27.

**Verdict:** P1 PASS, P2 PASS, P3 PASS. There are two caveats: the Langy session key is a fixture (see P2), and `/feedback` showed no rating card on an empty chat.

## How I tested

I ran my own stack from the PR worktree:
- **UI:** built from the worktree in dev mode.
- **apps/api:** on :5700, with Prometheus on :9491.
- **Dev runtime:** on :5710, as the worker. Without a worker, `apiKey.create` fails with 503 `AuthzGrantNotConfirmedError`.
- **Data:** the `pd9190` Postgres and ClickHouse databases.

How the clients were driven:
- **Browser:** each step ran in a fresh browser, signed in, with real clicks and keys. PostHog was a Playwright route at `https://proof-stub.posthog.com` that decoded every capture, so nothing left the machine.
- **Model:** Langy needs one before it shows its empty chat. I added a "Custom, OpenAI-compatible" provider pointing at `http://127.0.0.1:9/v1`, which answers nothing, and made its model the default. So questions are sent and counted, and no reply comes back.
- **API keys:** created in the UI and kept only in the driver's memory. curl read the key from stdin, the CLI and MCP got it in their environment, and no key is in this folder.

## Results

| AC | Verdict | What I ran | Evidence |
|---|---|---|---|
| P1 composer, typed | PASS | Opened the panel, New chat, typed a question with a marker, pressed Enter. | Exactly 1 `langy.asked.question {surface:"composer"}`. `events/out-p1-composer.json` |
| P1 composer, suggestion chip on the empty panel | PASS | New chat, then clicked "Show me around" under SUGGESTED. | Exactly 1 `{surface:"composer"}`. `events/out-p1-chip.json` |
| P1 ask_bar | PASS | Made a new blank board, so it is empty and editable, then clicked the suggested question "Where does my money go?" under the board's ask bar. | Exactly 1 `{surface:"ask_bar"}`. The panel took the question ("Preparing Langy's workspace...") and **no** composer event followed. `events/out-p1-askbarchip.json` |
| P1 add_widget | PASS | "Add a widget", typed a question in "What do you want to know?", clicked Ask. | Exactly 1 `{surface:"add_widget"}`. The panel took the question and no composer event followed. `events/out-p1-addwidget.json` |
| P1 nothing sent | PASS | In an empty composer: Enter, then Send, then spaces only and Enter, then `/feedback` and Enter. | 0 `langy.asked.question`. `events/out-p1-nothing.json`. Note: on an empty chat, `/feedback` showed no rating card; the composer cleared and nothing was sent (`shots/p1-e-feedback-card.png`). |
| P1 no question text | PASS | Searched every captured PostHog payload for the marker texts, the chip texts, "Help me build a dashboard" and "feedback". | 0 hits. The only attributes are `surface`, `boundary`, and `projectId`, which comes from 9190. |
| P2 curl, plain key, no client header | PASS | `curl` POST `/api/v1/query` | log `caller=rest_api outcome=ok` |
| P2 spoofed client headers | PASS | `x-langwatch-sdk-name: evil`, `x-langwatch-surface: evil`, `user-agent: evil/1.0` | log `caller=rest_api outcome=ok` |
| P2 real CLI | PASS | `node sdks/typescript/dist/cli/index.js query run "SELECT count() AS traces FROM traces" -o json`, with `LANGWATCH_ENDPOINT=http://localhost:5700`. Exit 0. | log `caller=cli outcome=ok` |
| P2 real MCP server | PASS | `node mcp/typescript/dist/index.js` over stdio: `initialize`, then `tools/call run_query`. | log `caller=mcp outcome=ok` |
| P2 Langy session key | PASS, with a **fixture** key | See "The Langy session key" below. | log `caller=langy outcome=ok`, twice. The second run carried the CLI's identity headers and is still `langy`: the key wins over the client. |
| P3 refused run from MCP | PASS | The real MCP server: `run_query` with `DROP TABLE traces`. | MCP replied "LangWatch API error 400 ... Code: lwql_not_permitted". The log has `LangWatchQL failed caller=mcp outcome=lwql_not_permitted`. |

## The Langy session key

The server knows a Langy session key by its name, "Langy session". The UI won't let a customer create a key with that name, because it is reserved. A real one is minted only during a Langy turn, which needs a model and the Langy agent, and neither runs here.

So I created a normal project key in the UI. Then, in the proof database `pd9190`, I set it to what `LangySessionKeyService.create` writes: `name='Langy session'` and `"isSystemManaged"=true`. Nothing else changed. Its permissions are wider than a real session key's, but caller attribution does not use them.

## Raw capture

Log lines (`events/p2-loglines.txt`). There is no SQL text in any of the 8 LangWatchQL lines from this run:
```
{"msg": "LangWatchQL executed", "caller": "rest_api", "outcome": "ok", "queryHash": "d15e2476d077e338"}   curl, plain key
{"msg": "LangWatchQL executed", "caller": "rest_api", "outcome": "ok", "queryHash": "d15e2476d077e338"}   spoofed headers (evil)
{"msg": "LangWatchQL executed", "caller": "cli", "outcome": "ok", "queryHash": "d15e2476d077e338"}        real CLI
{"msg": "LangWatchQL failed", "caller": "mcp", "outcome": "lwql_not_permitted", "queryHash": "b71ce603a37151a1"}   MCP, DROP TABLE
{"msg": "LangWatchQL executed", "caller": "mcp", "outcome": "ok", "queryHash": "d15e2476d077e338"}        MCP, run_query
{"msg": "LangWatchQL executed", "caller": "langy", "outcome": "ok", "queryHash": "d15e2476d077e338"}      Langy session key
{"msg": "LangWatchQL executed", "caller": "langy", "outcome": "ok", "queryHash": "d15e2476d077e338"}      Langy session key + CLI headers
```

Metrics (`events/metrics-lwql.txt`). `/metrics` gives 401 without the token. These are counted since the api started, across 3 P2 attempts:
```
lwql_queries_total{caller="dashboard_widget",outcome="ok"} 20
lwql_queries_total{caller="dashboard_widget",outcome="empty"} 6
lwql_queries_total{caller="rest_api",outcome="ok"} 5
lwql_queries_total{caller="cli",outcome="ok"} 3
lwql_queries_total{caller="mcp",outcome="lwql_not_permitted"} 2
lwql_queries_total{caller="mcp",outcome="ok"} 2
lwql_queries_total{caller="langy",outcome="ok"} 2
```

How the counts add up:
- **Attempt 1:** no key was found, so the driver stopped before any query ran.
- **Attempt 2:** no `psql` on the box, so the fixture did not apply. Both "Langy" runs went out with a plain key: the one with no header counted as `rest_api`, the one with the CLI header as `cli`. This attempt counted rest_api 3, cli 2, mcp 1 ok + 1 refused.
- **Attempt 3** (the log above): rest_api 2, cli 1, mcp 1 ok + 1 refused, langy 2.

## Screenshots

![Empty Langy panel with its suggestion chips](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-langy-attribution-events/proof-54ecc8e/shots/p1-b0-empty-panel-chips.png)
![Ask bar suggestion on a blank board, handed over to the panel](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-langy-attribution-events/proof-54ecc8e/shots/p1-c-askbar-chip-handover.png)
![Add a widget: question typed](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-langy-attribution-events/proof-54ecc8e/shots/p1-d0-add-widget-typed.png)
![Add a widget: asked, handed over to the panel](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-langy-attribution-events/proof-54ecc8e/shots/p1-d-add-widget-asked.png)
![Composer question sent](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-langy-attribution-events/proof-54ecc8e/shots/p1-a-composer-typed.png)
