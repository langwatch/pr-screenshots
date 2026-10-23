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

## Final recording pass, 2026-09-20 (branch head `fc2b948782`)

Three takes were re-recorded because the behaviour changed after the earlier
ones, and the two edge cases the earlier rounds never reached in a browser were
run. Same stack (`PORT=5580`), same project `ACME Support Agent`, API lane
restarted on the branch head.

### 02-instant-eval-progress-stop

"annoyed users" on the last 7 days, 1,320 traces in the window. The estimate is
under 0.50 USD so the run starts on its own; Stop is pressed at 38 percent.

Run `instanteval_0008ZDsYSRsPxMUbErxNqtxXngGj6`.

| Surface | Reads |
|---|---|
| Chip | `eval:"Does the user express frustration or annoyance at any point in the conversation?" (partial: 661 of 1,320 judged)` |
| Selection header | Select all 86 matching |
| Pagination line | 86 traces · showing 1–50 |
| Sidebar total | 86 traces |
| `langwatch instant-eval status`, same take | cancelled · 661 of 1,320 judged · 86 matched |

The four page surfaces were sampled every two seconds for sixteen seconds after
the stop settled. All eight samples read 86 on the header, the pagination line
and the sidebar, and the chip's partial mark never moved off `661 of 1,320`.
The CLI read is shown on screen in the same take.

The quotes around the question survive the partial mark: the chip reads
`eval:"…?" (partial: …)`, not a bare question.

One note on the mid-run frames: the counters land in pages of 500, and on a
loaded machine the list read that follows a page lags the counters by a second
or two, so the table is briefly blank between "0 judged" and the first 500. The
empty state during that window is the deliberate one ("No matches yet — the
Instant Eval is still judging"), not a failure.

### 03b-no-model-primer

`INSTANT_EVAL_CLASSIFIER=null` and the project's OpenAI provider disabled, so
the router has neither a classifier nor a model.

| Step | Observed |
|---|---|
| A twelve-word sentence, Enter | searched as one phrase, `"I was charged for the Trail Club renewal yesterday and I want"` |
| Counts | 99 on the pagination line, 99 on the sidebar |
| "This filter isn't valid" | never shown |
| Primer | opens: "Connect a model for smarter search — Your words were searched as a phrase. With a model connected, a sentence typed here becomes a filter, a judgement over each trace, or a question for the assistant." with "Add a provider" |
| Dismiss | a click outside closes it |
| A second sentence, same session | searched as a phrase, primer stays closed |

This is the take the old one could not produce: before `f90240d045` a FAST model
whose provider was disabled threw `model_provider_disabled`, the router logged it
as a generic failure, and the primer never opened.

### 06-langy-secondary

Asked from the "Refund questions" dataset page: "add five examples of refund
questions from our traces to the Refund questions dataset". Traces are a means
to the task, so Langy stays on the dataset page and answers with cards; the
dataset goes from 15 to 20 records.

| Surface | Reads |
|---|---|
| The card clicked | 10 traces · showing 3 |
| Explorer query | `"refund" AND origin:application` |
| Window and lens | Last 24 hours, All |
| Pagination line | 10 traces · showing 1–10 |
| Sidebar total | 10 traces |
| Selection on arrival | no selection bar, 0 row checkboxes ticked, 0 header checkboxes ticked |

The old take opened this link with all 50 rows selected and a "50 selected" bar
across the top. Read immediately on arrival and again after the sidebar opened,
nothing is selected.

## The two edge cases

### Two eval chips in one query

Last 24 hours, 115 traces. The first question runs and finishes; the second is
typed after the first chip and run, so both chips are active at once.

| State | Chips | Runs | Pagination | Sidebar | Header |
|---|---|---|---|---|---|
| First chip alone | `eval:"Does the user express frustration or annoyance at any point in the conversation?"` | `74cdaab4 → instanteval_0008hrMqjHdsNsZDJdP9hFjsQO6Cd` | 14 traces | 14 traces | 14 selected |
| Both chips | the first, `AND eval:"Does the user ask about a refund?"` | the first run, plus `f99bbfbf → instanteval_0008i2GR9DeIjgbTEKBTxHGOvSEdy` | 1 trace | 1 trace | 1 selected |

Pass. Two distinct runs, each chip keeps its own, the first chip's run is not
replaced by the second, and the three counts agree at both stages.

This is where "1 traces" was found on the pagination line and the sidebar. Fixed
in `fc2b948782`: the copy builders moved into `explorerCountSummary.ts` and
gained the singular, and the pagination line now renders the same summary string
the sidebar does rather than assembling its own from the raw noun.

### An eval chip on the Conversations lens

Started on the Conversations lens, last 24 hours, 41 conversations in the window.

| Surface | Reads |
|---|---|
| Run `instanteval_0008nJA3hHr3HthAf1ZHi107xSJkk` | finished · 41 of 41 judged · 6 matched |
| Run SQL | `eval_criteria(conversation(m.ConversationId), …)` over `m.ConversationId`, so the rows judged are threads |
| Pagination line | 6 conversations · showing 1–6 |
| Sidebar total | 6 conversations |

Pass on both halves. The run judged threads, not traces, and the two counts the
lens shows agree at 6. (The Conversations lens has per-row checkboxes but no
select-all in the header, so it has no selection-header count to compare; the
row checkbox gives "1 selected" as expected.)

Switching to the All lens does not reuse those verdicts for traces. Each lens
carries its own filter, so the chip is not on the All lens at all: the bar is
empty and the page reads 115 traces, the plain count for that window. Nothing
judged over threads is ever shown as a count over traces.

### Finding: a lens round trip drops the run behind a chip that comes back

Switching away from the Conversations lens and back restores the chip from the
lens draft but not its run, so the page reads "These results are not judged yet
— The Instant Eval in this search covered a different window, lens or filter"
and offers "Judge these results". The window, the lens and the filter are in
fact identical to the ones the run covered, and the run is still finished on the
server, so accepting that offer pays to judge the same 41 threads again.

Cause: a run rides with the URL fragment (`useURLSync`, "a fragment naming a
query names its runs too, and one naming none has none"), while the query text
can also come from the per-lens draft (`selectLens` installs `draft.filter`).
The All lens fragment carries no `q`, so `setEvalRuns(NO_RUNS)` wipes the map,
and the draft that restores the chip has nothing to restore the run from. The
fix is for the per-lens draft to carry its eval runs beside its filter, which
means a field on `DraftLensState`, its persistence, `selectLens`, and the
`applied.evalRuns` branch in `useURLSync`. Left for a follow-up rather than
landed in this pass: it changes the lens, draft and URL interaction, which has
its own history test suite, and the behaviour it replaces is safe (nothing
wrong is shown, only re-judged).

The empty-state sentence is also inaccurate in this case, since the window, lens
and filter did not differ.
