# Follow-up PR 3 (Insights and Alerts) proof at cc738c7

Branch: `tasks1003/insights-alerts-events` in langwatch/langwatch, head cc738c71068 (PR #9206).

**Verdict:** P1 PASS, P2 PASS, P3 PASS. The "keep" step needed one test fixture, see P1. The graph alert link was made by hand, see P2.

## How I tested

My own stack ran from the PR worktree:
- **Port and data:** `dev-stack.sh` on :5720, with fresh `pr9206_proof` Postgres and ClickHouse databases.
- **Redis:** db 14, which was empty. On db 0, another stack's worker took this stack's jobs, and grants were never written.
- **Flags:** `FEATURE_FLAG_FORCE_ENABLE=release_insights`.

What took the place of each real service. Nothing left the machine:
- **PostHog:** one local HTTP sink (`POSTHOG_HOST`) took every capture from both the server and the browser.
- **Slack:** `SLACK_WEBHOOK_BASE` pointed at the same sink, so the real Slack client was used.
- **Webhooks:** they posted to the sink, allowed by `WEBHOOKS_UNSAFE_ALLOW_LOCAL_URLS=1`.
- **Mail:** `EMAIL_PROVIDER=smtp` sent to a local SMTP sink.

The user was a fresh sign-up, made through the UI (email verify link, password, onboarding).

Browser notes. Each one concerns only how the proof reached a local sink:
- **CSP:** the app's CSP admits only `*.posthog.com`, so the browser ran with CSP bypassed, which let it reach the 127.0.0.1 sink.
- **Bot filter:** posthog-js drops headless browsers as bots, so the browser used a normal Chrome user agent with `AutomationControlled` off.
- **SaaS mode:** browser events go to PostHog only when `IS_SAAS` is set (`createBrowserUiAnalytics`), so P2's PostHog run used `IS_SAAS=1`. With that set, the worker would not boot without a Stripe key, which is the red banner in the P2 shots. The landing hook runs in the browser and does not use the worker.

## Results

| P | Verdict | What I ran | Evidence |
|---|---|---|---|
| P1 filed | PASS | `insights.file` called twice from the signed-in page: the same tRPC call Langy's chat tool makes. A real chat filing needs a live model, which this stack does not have. | Exactly 2 `insights.filed.insight`: `{filedVia:"chat", tone:"bad"\|"good", fromBoard:false, projectId}`. `events/p1-posthog-insights.jsonl` |
| P1 seen | PASS | Insight records the owner as having seen their own filing (`insight.service.ts:65`), so one `seen` goes out per filing. | Exactly 2 `insights.seen.insight {projectId}`, one per filing. |
| P1 seen again: nothing more | PASS | Opened the Insights page (inbox, stale, archived), reloaded it, and called `insights.markSeen` on both ids. | 0 new insight events. The total stayed 2 seen. |
| P1 archived | PASS | Clicked "Mark done" on a card in the UI. | Exactly 1 `insights.archived.insight {projectId}`. `shots/p1-b-after-archive-A.png` |
| P1 kept | PASS, with a **fixture** | "Still relevant" is offered only on a stale insight. A stale insight is 7 days old, so I moved one insight's `filedAt` back 30 days in `InsightProjection`, then clicked "Still relevant" in the Stale folder. | Exactly 1 `insights.kept.insight {projectId}`. `shots/p1-c-stale-before-keep.png`, `shots/p1-d-after-keep-inbox.png` |
| P1 no text or ids | PASS | Searched every PostHog payload for the titles, the body, `insight_0005` and "p95 went". | 0 hits. The only keys on insight events are `filedVia, tone, fromBoard, projectId`, plus the SDK's `$lib, $lib_version, $is_server, $geoip_disable`. |
| P2 digest email is marked | PASS | Sent a real trace through `/api/collector`. The trace matched an email trigger (immediate cadence), which sent a real mail over SMTP. | The trace link is `.../traces/<id>?t=...&lw_from=alert`. The unsubscribe links have no marker. `events/p2p3-urls.txt` |
| P2 default Slack message is marked | PASS | The same trace, on a Slack trigger with no template. | `.../traces/<id>?t=...&lw_from=alert` |
| P2 landing on the trace link | PASS | Opened the marked link, signed in. | 1 `automations.opened.alert_link {landedOn:"trace"}` in PostHog. The marker is removed **before** the trace route redirects (see "The redirect"). The final address has no marker. `events/p2-trace-link-probe.txt`, `events/p2-posthog-alert-link.jsonl`, `shots/p2-a-trace-link-landed-after-reload.png` |
| P2 landing on a graph link | PASS, with a **hand-made link** | `.../analytics/custom/<id>?lw_from=alert`, the same shape the graph branch of `linkFor` makes. A graph alert needs a threshold sweep, which I did not run. | 1 `{landedOn:"graph"}`, and the marker was removed. `events/p2-graph-link-probe.txt`, `shots/p2-b-graph-link-landed-after-reload.png` |
| P2 reload | PASS | Reloaded after each landing. | Only a `$pageview`, no second `alert_link`. |
| P3 webhook, custom body | PASS | A `SEND_WEBHOOK` trigger with a Liquid body using `m.trace.url`, `project.url` and `trigger.editUrl`. | No `lw_from` in any URL. `events/p2p3-deliveries.json` |
| P3 webhook, default body | PASS | A `SEND_WEBHOOK` trigger with no body template. | No `lw_from`. |
| P3 Slack, custom template | PASS | A Slack trigger with a `string` template that uses `m.trace.url`. | No `lw_from`. |

### The redirect

The short trace link `/:project/traces/:trace` is a route-table redirect at `apps/ui/src/shell/ui-route-table.ts:711-720`. It goes to `/:project/traces`, pins `drawer.open` and `drawer.traceId`, and renames `t` to `drawer.t`. It runs **after** the chrome's `useAlertLinkOpened` effect (`apps/ui/src/shell/ui-app-chrome.tsx:62`).

The browser saw these addresses, in order:

```
nav: .../traces/trace_proof9206_1793371088?t=1793371094193&lw_from=alert
nav: .../traces/trace_proof9206_1793371088?t=1793371094193         <- the hook removed the marker
TRACKED: {"boundary":"automations","action":"opened","name":"alert_link","attributes":{"landedOn":"trace"}, ...}
nav: .../traces?drawer.t=1793371094193&drawer.open=traceV2Details&drawer.traceId=trace_proof9206_1793371088   <- the redirect
```

So the redirect does not lose the event.

My first attempt seemed to show it did. That run used a headless browser that posthog-js drops as a bot, so no capture arrived at all. Even the `$pageview`s were missing from the sink, apart from one.

## Raw capture

PostHog sink, the server and the browser, filtered to the PR's events:

```
$ node ev.mjs '^insights\.|^automations\.'
{"src":"server","event":"insights.filed.insight","props":{"filedVia":"chat","tone":"bad","fromBoard":false,"projectId":"project_0005rodVKTMvlnJCpLmhwQNl69Ime"}}
{"src":"server","event":"insights.seen.insight","props":{"projectId":"project_0005rodVKTMvlnJCpLmhwQNl69Ime"}}
{"src":"server","event":"insights.filed.insight","props":{"filedVia":"chat","tone":"good","fromBoard":false,"projectId":"project_0005rodVKTMvlnJCpLmhwQNl69Ime"}}
{"src":"server","event":"insights.seen.insight","props":{"projectId":"project_0005rodVKTMvlnJCpLmhwQNl69Ime"}}
{"src":"server","event":"insights.archived.insight","props":{"projectId":"project_0005rodVKTMvlnJCpLmhwQNl69Ime"}}
{"src":"server","event":"insights.kept.insight","props":{"projectId":"project_0005rodVKTMvlnJCpLmhwQNl69Ime"}}
{"src":"browser","event":"automations.opened.alert_link","props":{"projectId":"project_0005rodVKTMvlnJCpLmhwQNl69Ime","landedOn":"trace","boundary":"automations","context":{"href":"…/traces/trace_proof9206_1793371088?t=…&lw_from=alert",…}}}
{"src":"browser","event":"automations.opened.alert_link","props":{"projectId":"project_0005rodVKTMvlnJCpLmhwQNl69Ime","landedOn":"graph",…}}
```

The URLs in each delivery (the unsubscribe tokens are redacted):

```
== email (digest, default)    …/traces/trace_proof9206_1793371088?t=1793371094193&lw_from=alert
== slack (default message)    …/traces/trace_proof9206_1793371088?t=1793371094193&lw_from=alert
== slack (custom template)    …/traces/trace_proof9206_1793371088
== webhook (custom body)      …/traces/trace_proof9206_1793371088  …/proof-9206-org-l69Ime  …/automations?drawer.open=automation&drawer.automationId=…&drawer.source=email-link
== webhook (default body)     …/traces/trace_proof9206_1793371088
```

## Observed, out of scope

- The browser host adds `context.href` to every event. On `alert_link`, that is the landing address before the marker is removed: the project slug, the trace or graph id, and `lw_from=alert`. This is the open `context.href` question from 9190, which is Drew's call.

## Screenshots

![Insights inbox, two filed](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9206/proof-cc738c7/shots/p1-a-insights-inbox.png)
![After Mark done](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9206/proof-cc738c7/shots/p1-b-after-archive-A.png)
![Stale folder with Still relevant](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9206/proof-cc738c7/shots/p1-c-stale-before-keep.png)
![After keep, back in the inbox](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9206/proof-cc738c7/shots/p1-d-after-keep-inbox.png)
![Trace link landed and reloaded: the address has no marker](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9206/proof-cc738c7/shots/p2-a-trace-link-landed-after-reload.png)
![Graph link landed and reloaded: the address has no marker](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-9206/proof-cc738c7/shots/p2-b-graph-link-landed-after-reload.png)
