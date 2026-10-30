# PR 9190 short re-proof at 8c0aa6b2cac

PR: https://github.com/langwatch/langwatch/pull/9190. The head is 8c0aa6b2cac, which is fix batch 2 from the CodeRabbit review.

How I tested: my own stack from the PR worktree. The api ran alone on :5680 and Prometheus on :9471. The dev runtime on :5670 ran only as the worker. The data was in the Postgres and ClickHouse databases `pd9190`. A Playwright route stood in for PostHog at `https://proof-stub.posthog.com` and decoded every capture, so nothing left the machine. Each board load used a fresh browser.

| # | Check | Verdict | Evidence |
|---|---|---|---|
| 1a | First `dashboards.viewed.dashboard` carries the current projectId, on a full load with **no PostHog storage** (signed-in cookies only, empty localStorage) | PASS | `first-view-clean-storage.json`: stored board and From LangWatch board. Order of events: `$set`, `signed_in`, `$groupidentify`, `dashboards.viewed.dashboard`, each with `projectId`. Screenshot: `shots/stored1-cleanstorage.png` |
| 1b | Same check, with the PostHog storage a returning user has | PASS | `events-stored1.json`, `events-stored2.json`, `events-curated_release.json`, `events-stored-copy.json` |
| 2a | Stored board: each widget query runs once per load, and none run again on re-renders (3 viewport resizes, every widget's action menu opened and closed, star toggled twice) | PASS | `runs-per-widget.json` `stored_copy`: 13 runs on load (5 widgets, runs = distinct query hashes for each widget), **0** during re-renders. All `caller=dashboard_widget`, `dashboardId` = the board id, every line has a `widgetId` |
| 2b | From LangWatch board ("Release check"): same check | PASS | `runs-per-widget.json` `curated_release`: 13 runs on load, distinct hashes, **0** on re-render. `caller=dashboard_widget`, `dashboardId=curated/release`, widget keys `ship-*` |
| 3a | Workbench caller | PASS | `trpc-calls.json` and the log: a run with no telemetry logs `caller=workbench outcome=ok` |
| 3b | A failed run logs its error code | PASS | `projects:["al"]` gives 404 `project_not_found`, and the log has `LangWatchQL failed caller=workbench outcome=project_not_found` |
| 3c | The browser can't name the caller | PASS | `telemetry.caller` gives 400 `Unrecognized key: "caller"` |
| 3d | `/metrics` | PASS | `metrics-lwql.txt`: 401 without the token. With the token, the lwql series carry only the labels `caller`, `outcome` and `le` |
| 4 | Grafana JSON (static check) | PASS | `grafana-queries.txt`: the file parses (6 panels). Error and empty numerators are `(... outcome filter ...) or (sum by (caller)(rate(total)) * 0)`, so a caller with only ok runs shows 0. The error filter leaves out `ok`, `empty` and `aborted`. The CloudWatch slow-hash table groups `by queryHash, caller, dashboardId, widgetId` |
| 5 | No SQL text in log lines | PASS | `lwql-log-lines.jsonl`: 0 lines with SQL |

Note: two stored boards ("Untitled dashboard 6" and "10") ran nothing, because their widgets show "Connect traces" on this project, which has no traces. That is why 2a uses the "Release check (copy)" stored board, whose widgets run.

Raw capture:
```
$ curl -s -o /dev/null -w "%{http_code}" localhost:9471/metrics
401
$ curl -s -H "Authorization: Bearer $METRICS_API_KEY" localhost:9471/metrics | grep "^lwql_queries_total"
lwql_queries_total{caller="dashboard_widget",outcome="empty"} 50
lwql_queries_total{caller="dashboard_widget",outcome="ok"} 8
lwql_queries_total{caller="workbench",outcome="ok"} 1
lwql_queries_total{caller="workbench",outcome="project_not_found"} 1
```

![Stored board after re-renders](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9190/proof-8c0aa6b/shots/stored-copy-after-rerender.png)
![From LangWatch board](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9190/proof-8c0aa6b/shots/curated_release-loaded.png)
