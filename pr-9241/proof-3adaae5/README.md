# PR 9241 proof at 3adaae58a9d: the old-Analytics notice is gone

Local stack from the worktree on branch `dashboards/drop-old-analytics-notice` at `3adaae58a9d`. `pnpm dev` ran on port 5700 against its own Postgres and ClickHouse database (`pr9241_proof`), with `FEATURE_FLAG_FORCE_ENABLE=release_dashboards`. I signed up as a fresh user (`proof9241@example.com`), who owns the project and so holds analytics:view, and drove headless Chromium with Playwright.

On main, before this change, every one of these pages rendered an info banner at the top: "Looking for the old Analytics? It is still here." with an "Open Analytics" link.

| # | Page | What I read in the page | Evidence | Verdict |
|---|---|---|---|---|
| 1 | A board, `/[project]/dashboards` → My dashboard | `{"h1":["My dashboard"],"oldNotice":false,"openAnalyticsLink":false}` | [board.png](board.png) | PROVEN |
| 2 | A template board, `/[project]/dashboards/curated/release` | `{"h1":["Release check"],"oldNotice":false,"openAnalyticsLink":false}` | [curated.png](curated.png) | PROVEN |
| 3 | The templates library, `/[project]/dashboards/templates` | `{"h1":["Dashboard templates",...],"oldNotice":false,"openAnalyticsLink":false}` | [templates.png](templates.png) | PROVEN |

`oldNotice` is `document.body.innerText.includes("Looking for the old Analytics")`. `openAnalyticsLink` is true if any `<a>` reads "Open Analytics".

The widget errors on pages 1 and 2 are expected on this stack, because the LangWatchQL workbench flag was not forced on. They are not related to this change.
