# Follow-up PR 1 (engagement events) proof at 2b1930ae615: STOPPED on a defect

Branch: `tasks1003/dashboard-engagement-events` in langwatch/langwatch, head 2b1930ae615. No PR yet.

**How I tested:** the UI was built from the PR worktree, and apps/api ran from it on :5690, on the `pd9190` Postgres and ClickHouse databases. PostHog was a Playwright route at `https://proof-stub.posthog.com` that decoded every capture, so nothing left the machine. Each step ran in a fresh browser, signed in, with real clicks, wheel scrolls and key presses.

**Verdict: NOT READY.** AC2 fails. The walk stopped there, so AC5 is not tested.

| AC | Verdict | What I ran | Evidence |
|---|---|---|---|
| AC1 board key on `dashboards.viewed.dashboard` | PROVEN | I opened "Release check (copy)" twice, in fresh browsers, and opened "My dashboard" once. | The copy sent `dashboardKey: "dd4395e8e44420a1"` both times. My dashboard sent `"b4972ca96e2c5cb3"`. Each key equals `sha256(board id)[0:16]`, recomputed with `sha256sum`, and neither board id appears in the attributes. `events/out-ac1-copy-open1.json`, `events/out-ac1-ac2-copy-open2.json` |
| AC2 `dashboards.viewed.widget` once per card when it shows | **FAILED** | On load, then wheel down, up and down again. | **Defect:** a card with 13% of its height on screen counts as seen. At a 1440x870 viewport the visible share per card was `[1, 1, 1, 0.13, 0]`, and **4** events were sent. At 1440x830 it was `[1, 1, 1, 0, 0]`, and 3 were sent. `use-widget-viewed.ts` says "Half a card in view counts as seen" and uses `threshold: 0.5`. But the callback checks `entry.isIntersecting`, which is true for any overlap on the observer's first callback. Fix: check `entry.intersectionRatio >= SEEN_SHARE`. The integration test fakes only `isIntersecting`, so it cannot catch this. These parts work: the 5th card was sent when scrolled into view and not before, and scrolling away and back sent nothing more. |
| AC3 `dashboards.changed.period` | PROVEN | Picked 7d, then 7d again, then grain 1d, then 30d. | Picks sent `{range:"7d",grain:"auto"}`, `{range:"7d",grain:"1d"}` and `{range:"30d",grain:"1d"}`. Re-picking 7d sent nothing. `events/out-ac3-period.json` |
| AC4 `dashboards.exported.widget` | PROVEN | Saved a one-row widget, then Export CSV from its menu. | It sent `{format:"csv"}` after the download of `my-dashboard_new-widget_query-results.csv` (`events/export.csv`). Unhappy path: when the widget had no data, Export CSV was disabled ("No data in this period"), the click did nothing, and no event was sent. `events/out-ac4-export.json` |
| AC5 `dashboards.edited.dashboard` (rename and layout) | NOT TESTED | The walk stopped at the AC2 defect. | |
| AC6 `lwql.opened.editor` and `lwql.ran.query` | PROVEN | "Edit code" on an existing widget, Run pressed twice, Cancel. Then "Add a widget" and "I'll build it myself". | It sent `{widgetIs:"existing"}` once per open and `lwql.ran.query` once per Run press, with no attributes. The live chart's own runs sent none. The new widget sent `{widgetIs:"new"}`. Saving sent `dashboards.added.widget {addedFrom:"editor"}`; saving an edit sent `dashboards.edited.widget`. `events/out-ac6-existing.json`, `events/out-ac6-new.json` |
| AC7 no raw ids, SQL or text | PROVEN for PR 1's attributes | I scanned every captured PostHog event for `local_(dashboard\|widget\|project)_*`, `SELECT` and `FROM traces`. | 0 hits in the attributes PR 1 sets. The browser host adds its own `context.href` to every event (66 of them), and that is the page URL with the board id, plus `projectId` from 9190's `register`. Both come from before PR 1. |

![Board on load: four cards were sent as seen](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-2b1930a/shots/ac2-a-top-before-scroll.png)
![At an 870px viewport the 4th card is 13% visible and still sent](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-2b1930a/shots/ac2-sliver-h870.png)
![Period menu](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-2b1930a/shots/ac3-a-period-menu.png)
![Export CSV enabled on a one-row widget](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-2b1930a/shots/ac4-e-widget-menu-export.png)
![Run pressed in the widget editor](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-2b1930a/shots/ac6-a-run-pressed.png)

Raw capture (console debug events, AC2 at the default 900px viewport):
```
dashboards viewed dashboard {"dashboardKind":"stored","widgetCount":5,"dashboardKey":"dd4395e8e44420a1"}
dashboards viewed widget {"widgetSource":"catalogue"}   x4 on load
MARK SCROLL-DOWN
dashboards viewed widget {"widgetSource":"catalogue"}   (5th card)
MARK SCROLL-UP
MARK SCROLL-DOWN-AGAIN                                   (nothing more)
```
