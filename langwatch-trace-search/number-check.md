# Number check, Trace Explorer smart search (langwatch#8234)

Stack: worktree `trace-explorer-smart-search` on port 5580, native ClickHouse, project `acme-support-agent` (6,400 seeded traces, 5,678 visible over 30 days). Every row compares what the page prints with what the CLI and Langy report for the same filter and window.

Columns: header is the selection bar ("Select all N matching"), pagination is the footer line, sidebar is the total above the facets, CLI is `langwatch trace search --filter ... --start-date ... --end-date ...` (`pagination.totalHits`), or `langwatch instant-eval status <run>` for the eval chip.

## The five filters

| # | Filter | Window | Header | Pagination | Sidebar | CLI | Langy | Verdict |
|---|---|---|---|---|---|---|---|---|
| 1 | none, then facet click `service:checkout` | 30 days | 5,678 | 5,678 | 5,678 | 5,678 | n/a | agree |
| 1a | after the click (facet said 801) | 30 days | 801 | 801 | 801 | 801 | n/a | agree, facet 801 = table 801 |
| 2 | generated: `status:error AND service:checkout AND duration:>2000` | 30 days | 80 | 80 | 80 | 80 | n/a | agree |
| 2a | then facet `model:gpt-5-mini` (facet said 45) | 30 days | 45 | 45 | 45 | 45 | n/a | agree, facet 45 = table 45 |
| 3 | phrase: `"refund"` | 30 days | 435 | 435 | 435 | 435 | card 435 (flow 6) | agree |
| 3a | then facet `service:billing-api` (facet said 435) | 30 days | 435 | 435 | 435 | 435 | n/a | agree |
| 4 | eval chip, finished run `instanteval_0005RZPlFPkfXyfltSF4CcRPtrm7y` | 7 days | 180 | 180 | 180 | 180 matched of 1,389 | n/a | agree |
| 4a | same run opened from its URL in a fresh browser, then reloaded | 7 days | 179 | 179 | 179 | run unchanged | n/a | agree (see note 1) |
| 5 | Langy-set: `event:thumbs_up_down AND event.attribute.event.metrics.vote:-1` | 7 to 13 Sep | 75 | 75 | 75 | 75 | answer "Found 75 traces" | agree |
| 5a | same ask from the home page, Conversations lens | 7 to 13 Sep | n/a | 60 conversations | n/a | n/a | answer "Found 60 conversations" | agree |

Other counts checked along the way:

| Where | Left | Right | Verdict |
|---|---|---|---|
| Confirm dialog "Rows to judge" vs table, 30 days | 5,678 | 5,678 | agree |
| Progress bar vs sidebar vs footer while judging | 500 / 1,389, 70 matched | 70 matched so far, 500 of 1,389 judged | agree at every sample |
| Partial chip after Stop | (partial: 500 of 1,389 judged) | 70 traces in sidebar and footer | agree |
| Long German sentence routed as a phrase | sidebar 25 | footer 25 | agree |
| Budget popover (SaaS mode) vs ledger | 1.05 USD of 1.00 USD | ledger 1.0516 USD | agree |
| Langy result card vs the Explorer its link opens | 435 traces | 435 / 435 / Select all 435 | agree, after fix `ef667d2c1d` |

## Disagreements found

1. **Langy card: "13 traces · showing 0 · No traces matched".** The card header and the Explorer both said 13; the card body claimed nothing matched. Cause: the tool result reducer kept object keys alphabetically and dropped `trace_id`. Fixed in `ef667d2c1d` (reducer keeps identity keys, cards treat unnamed rows as unreadable). Re-checked: 435 on the card, 435 in the Explorer.
2. **Langy answered "no conversations" while the page showed 321.** Cause in my environment: the local worker ran the globally installed CLI 1.15.0, which lacks `trace facets`, `trace fields`, `query reference` and `trace search --filter`. With the branch's CLI on PATH the answer and the page agree (75 and 75). See the report for the late-claim behaviour that made this worse.
3. **Event name facet "thumbs down 81" next to a table of 75.** Cause: 485 seeded traces lost their summary row when ClickHouse wedged during seeding. Their spans exist, so a span-table facet with no other filter counts them; the trace table cannot. ClickHouse confirms it: 75 events on traces with a summary, 6 on traces without. Not an Explorer predicate defect; reported as a pipeline durability finding.

## Notes

1. 180 became 179 between the run and the later open because the chip's window is the live "last 7 days": one matched trace aged out of the window. All three places moved together.
2. Rows 1 to 3 were repeated five times in fresh browser sessions; see below.

## Five passes of filters 1 to 3

Each pass opens a fresh browser, applies the filter, reads header, pagination and sidebar, asks the CLI for the same filter and window, then clicks the facet and reads all of it again.

| Pass | Filter | Header | Pagination | Sidebar | CLI | Facet said | After click: table / sidebar / CLI | Verdict |
|---|---|---|---|---|---|---|---|---|
| 1 | facet click | 5678 | 5678 | 5678 | 5678 | checkout 801 | 801 / 801 / 801 | agree |
| 1 | generated filter | 80 | 80 | 80 | 80 | gpt-5-mini 45 | 45 / 45 / 45 | agree |
| 1 | phrase | 435 | 435 | 435 | 435 | billing-api 435 | 435 / 435 / 435 | agree |
| 2 | facet click | 5678 | 5678 | 5678 | 5678 | checkout 801 | 801 / 801 / 801 | agree |
| 2 | generated filter | 80 | 80 | 80 | 80 | gpt-5-mini 45 | 45 / 45 / 45 | agree |
| 2 | phrase | 435 | 435 | 435 | 435 | billing-api 435 | 435 / 435 / 435 | agree |
| 3 | facet click | 5678 | 5678 | 5678 | 5678 | checkout 801 | 801 / 801 / 801 | agree |
| 3 | generated filter | 80 | 80 | 80 | 80 | gpt-5-mini 45 | 45 / 45 / 45 | agree |
| 3 | phrase | 435 | 435 | 435 | 435 | billing-api 435 | 435 / 435 / 435 | agree |
| 4 | facet click | 5678 | 5678 | 5678 | 5678 | checkout 801 | 801 / 801 / 801 | agree |
| 4 | generated filter | 80 | 80 | 80 | 80 | gpt-5-mini 45 | 45 / 45 / 45 | agree |
| 4 | phrase | 435 | 435 | 435 | 435 | billing-api 435 | 435 / 435 / 435 | agree |
| 5 | facet click | 5678 | 5678 | 5678 | 5678 | checkout 801 | 801 / 801 / 801 | agree |
| 5 | generated filter | 80 | 80 | 80 | 80 | gpt-5-mini 45 | 45 / 45 / 45 | agree |
| 5 | phrase | 435 | 435 | 435 | 435 | billing-api 435 | 435 / 435 / 435 | agree |

## Eval chip and Langy, repeated reads

| Read | Header | Pagination | Sidebar | CLI or Langy | Verdict |
|---|---|---|---|---|---|
| Run A finished (`...RZPlFPkfXyfltSF4CcRPtrm7y`) | 180 | 180 | 180 | CLI matched 180 of 1,389 | agree |
| Run A, URL opened in a fresh browser | 179 | 179 | 179 | window slid by one trace | agree |
| Run A, reloaded | n/a | 179 | 179 | no estimate or start request | agree |
| Run B finished (`...elaeVrFwtPxaxob9dYGDeEC62`) | 168 | 168 | 168 | CLI matched 168 of 1,353 | agree |
| Run B, reloaded in place | n/a | 168 | 168 | no estimate or start request | agree |
| Run B, URL opened in a fresh browser | 168 | 168 | 168 | no estimate or start request | agree |
| Run B, that browser reloaded | n/a | 168 | 168 | no estimate or start request | agree |
| Stopped run, first take | n/a | 70 | 70 | chip: partial, 500 of 1,389 judged | agree |
| Stopped run, second take | n/a | 72 | 72 | chip: partial, 540 of 1,354 judged | agree |
| Langy from the Explorer | 75 | 75 | 75 | Langy "Found 75 traces", CLI 75 | agree |
| Langy from the home page | n/a | 60 conversations | n/a | Langy "Found 60 conversations" | agree |
| Langy card on the datasets page | 435 | 435 | 435 | card "435 traces", CLI 435 | agree |

One transient difference was sampled once: for under a second at the start of a run the progress bar read "Judging 0 / ..." while the sidebar and footer already read "66 matched so far, 500 of 1,354 judged". The next sample agreed.

## Edge cases (no video, `edges.json`)

| Case | Observed | Verdict |
|---|---|---|
| Enter on an empty bar | no router call, 5,678 stays | pass |
| Pure `field:value` query | no router call, 112 and 112 | pass |
| Type over an applied query, then Escape | query unchanged, no list request | pass |
| Edit the query, then Enter | `status:error AND service:billing-api`, 90 and 90 | pass |
| Clear | back to 5,678 and 5,678 | pass |
| "/" | focuses the bar | pass |
| Shared URL in a fresh browser, 7 days | 22 and 22, same query | pass |
| 900 px wide window | no horizontal overflow, footer summary ends at 551 px, navigator starts at 563 px | pass, after fix `8e01195c52` |
| Dark mode | renders, 112 traces | pass |
| Browser Back after two queries | leaves the Explorer; Forward restores 90 and 90 | finding: query changes replace the URL, they do not push |
| Cmd+I on the Explorer | opens the Langy panel with the view attached, not the floating ask surface the spec describes | finding |

Not exercised: typing during a run, changing the time range during a run, two eval chips at once. The laptop lid was closed for much of the session and the machine slept in 16 minute blocks, so run-based edge cases were dropped in favour of complete takes.

## Second fix round, 2026-09-20 (commits `7b864c8706` to `0b8a0f1774`)

Same stack and project, API lane restarted on the branch head, OpenAI provider re-enabled on both dogfood projects.

### Number check repeated, three filters

Each row opens a fresh browser, applies the filter, reads the selection-bar total, the pagination line and the sidebar total, asks the CLI for the same filter and window, then clicks a facet value and reads all of it again.

| Filter | Window | Header | Pagination | Sidebar | CLI | Facet said | After the click: table / sidebar / CLI | Verdict |
|---|---|---|---|---|---|---|---|---|
| none, then facet `service:checkout` | 30 days | 5,678 | 5,678 | 5,678 | 5,678 | checkout 801 | 801 / 801 / 801 | agree |
| `status:error AND service:checkout AND duration:>2000` | 30 days | 80 | 80 | 80 | 80 | gpt-5-mini 45 | 45 / 45 / 45 | agree |
| phrase `"refund"` | 30 days | 435 | 435 | 435 | 435 | billing-api 435 | 435 / 435 / 435 | agree |

### Edge cases that the first round left unexercised

| Case | Observed | Verdict |
|---|---|---|
| Typing in the bar during a run | The bar takes the keystrokes, no `routeSearch`, `instantEval.start` or `instantEval.cancel` fires, the run finishes on its own and the counts land at 161 traces in both the footer and the sidebar | pass, Enter is the only commit |
| Escape during a run | The progress bar and the chip are untouched | pass |
| Changing the time range during a run (7 days to 24 hours) | The chip stays and reads `(pending)`, the run keeps its id in the URL fragment, the table empties, and the empty state reads "These results are not judged yet" with "Judge these results" as the first action. Screenshot `edge2-range-after.png` | pass, the behaviour the fix added |
| Langy panel at 1100, 900 and 700 px | Panel on screen at every width, 392 px wide, zero horizontal overflow on the page. Screenshot `edge2-langy-700.png` | pass |
| Two eval chips in one query | Not reached in the browser: the laptop was at load average 20 from two background runs and the page took over 150 s to list. Covered by `useInstantEvalRoute.integration.test.ts` ("A second question judges the same rows as the first"), which pins the estimate and the start to the query without either chip | covered by test, browser pending |
| Eval chip on the Conversations lens | Same, not reached in the browser. The target resolution and the conversation-shaped subquery are pinned by `instantEvalChips` and `instantEvalField.unit.test.ts` | covered by test, browser pending |

One earlier note corrected: the first attempt at these cases showed text landing inside an eval chip's quotes and a query carrying over between cases. Both were the driver script's doing, not the product: `page.goto` to the same path with a new fragment does not reload, and a click on a filled search bar lands the caret mid-chip.
