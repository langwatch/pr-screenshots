# Follow-up PR 1 (engagement events) proof at e3c155a4bed

Branch: `tasks1003/dashboard-engagement-events` in langwatch/langwatch, head e3c155a4bed. No PR yet. This replaces the stopped proof at 2b1930a (`../proof-2b1930a/`), which found the AC2 defect fixed in this commit.

**How I tested:** the UI was rebuilt from the PR worktree at e3c155a, and apps/api ran from it on :5690, on the `pd9190` Postgres and ClickHouse databases. PostHog was a Playwright route at `https://proof-stub.posthog.com` that decoded every capture, so nothing left the machine. Each step ran in a fresh browser, signed in, with real clicks, wheel scrolls, mouse drags and key presses.

**Verdict:** every AC is PROVEN. There is one note on AC2, about layout shift while a board loads.

| AC | Verdict | What I ran | Evidence |
|---|---|---|---|
| AC1 board key on `dashboards.viewed.dashboard` | PROVEN | I opened "Release check (copy)" in several fresh browsers, and "My dashboard". | Every open of the copy sent `dashboardKey: "dd4395e8e44420a1"`, and My dashboard sent `"b4972ca96e2c5cb3"`. Each key is `sha256(board id)[0:16]`, and neither board id appears in the attributes. `events/out-ac2-h860.json`, `events/out-quick.json` |
| AC2 `dashboards.viewed.widget` once per card, at half on screen | PROVEN | At a 1440x860 viewport: load, then wheel down 40px at a time, then to the top, then back down. | On load the visible share per card was `[1, 1, 1, 0.09, 0]` and **3** events were sent. The 4th card went 0.27, then 0.45 with nothing sent, then **0.63**, and then it was sent, **once**. 0.80, 0.98 and 1 sent nothing more. Scrolling to the top and back sent nothing more for it; only the 5th card, first on screen then, was sent. `events/out-ac2-h860.json` |
| AC2 note: the 870px case | Not a defect | At 1440x870 the 4th card ends up 13% on screen, and it is still sent on load. | I sampled every frame (`events/out-ac2-load-samples-h870.json`). While the board loads, before the "4 widgets on this dashboard have no data yet" banner shows, the card's top is at 758px, so it is **exactly 50%** on screen (112 of 224px) for about 1.7s. It is sent then. The banner then pushes it down to 840px (13%). At 860px it reaches only 46% during load (`events/out-ac2-load-samples-h860.json`) and is not sent. So the 0.5 rule holds. A card that is half on screen only while the layout settles still counts as seen. |
| AC3 `dashboards.changed.period` | PROVEN | Picked 24h, then 24h again, then 30d. | It sent `{range:"24h",grain:"auto"}` and `{range:"30d",grain:"auto"}`. Re-picking 24h sent nothing. `events/out-quick.json` |
| AC4 `dashboards.exported.widget` | PROVEN | Export CSV on the widget "New widget". | It sent `{format:"csv"}` after the download of `my-dashboard_new-widget_query-results.csv` (`events/export.csv`). `events/out-quick.json` |
| AC5 `dashboards.edited.dashboard` | PROVEN | 1) Grabbed the grip of card 2, moved it 3px and dropped it: no change. 2) Dragged card 2 by its grip below card 4. 3) Board menu, Rename, typed "Release check (proof)", pressed Enter. | 1) The no-change drop sent **nothing**. 2) One drop that moved the card sent `{change:"layout"}` **once**, and the "Layout saved" toast showed. 3) Rename sent `{change:"rename"}` once. A reload kept the new order and name. `events/out-ac5-drag.json`, `events/out-ac5-edit.json`, `events/out-ac5-reload.json` |
| AC6 `lwql.opened.editor` and `lwql.ran.query` | PROVEN | "Edit code" on "New widget", then Run once, then Cancel. | It sent `{widgetIs:"existing"}` once and `lwql.ran.query` once, with no attributes. `events/out-quick.json` |
| AC7 no raw ids, SQL or text | PROVEN for PR 1's attributes | I scanned all 34 captured PostHog events for `local_(dashboard\|widget\|project)_*`, `SELECT` and `FROM traces`. | 0 hits in the attributes PR 1 sets. The browser host still adds `context.href`, the page URL with the board id, to every event, and `projectId` comes from 9190's `register`. Both come from before PR 1. |

Under AC1: The board URL also carries the id, but the key stays the same for a board whatever its URL holds (period and other query params), and still counts repeat opens if ids are later removed from URLs.

![AC2: on load at 860px the 4th card is 9% on screen, and 3 cards were sent](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-e3c155a/shots/ac2-a-load-h860.png)
![AC2: the 4th card under half, not sent](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-e3c155a/shots/ac2-b-fourth-under-half.png)
![AC2: the 4th card over half, sent once](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-e3c155a/shots/ac2-c-fourth-over-half.png)
![AC5: after one drag, Layout saved](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-e3c155a/shots/ac5-b-after-drag.png)
![AC5: rename](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-e3c155a/shots/ac5-d-renamed.png)
![AC4: after Export CSV](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-e3c155a/shots/q-b-after-export.png)
![AC6: Run in the widget editor](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/branch-dashboard-engagement-events/proof-e3c155a/shots/q-c-editor-run.png)

Raw capture (console debug events):
```
AC2, 1440x860, 4th card's visible share -> viewed.widget sent so far
load [1,1,1,0.09,0] sent 3
+40  [1,1,1,0.27,0] sent 3
+40  [1,1,1,0.45,0] sent 3
+40  [1,1,1,0.63,0] sent 4
+40  [1,1,1,0.8,0]  sent 4
top  [1,1,1,0.09,0] sent 4
down [0,0.79,0.79,1,1] sent 5   (5th card)

AC5
MARK DROP-NO-CHANGE (grip moved 3px, released)
MARK END-NO-CHANGE
MARK DRAG card 2 down below card 4
dashboards edited dashboard {"change":"layout"}
MARK RENAME
dashboards edited dashboard {"change":"rename"}
```
