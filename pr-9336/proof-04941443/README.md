# Use-proof: built-in versus user-written LangWatchQL failures, head 04941443d79

Head: `04941443d792e0ca69e8bd0376b0d1c2d6deac7e`. Each evidence file names this head on its first line.

## Stack
- Local throwaway Postgres and Redis containers, plus a local ClickHouse in its own database (dropped after, see Teardown).
- api and worker in one process, bound to loopback only (every listener checked at start).
- Members made through the app's own sign-up and invite flow: an organisation ADMIN, and a lite member (organisation `EXTERNAL`, team `VIEWER`) via `invite.createInvites`, sign-up and `invite.acceptInvite` (`evidence/identity.txt`).

## Results
Counter values are read per case. Start values differ from 550c452 because the run order differed; compare the steps, not the absolute numbers.

| Case | Request | HTTP | New-logger line | Counter before -> after | Same as 550c452 |
|---|---|---|---|---|---|
| E | S, good view | 200 | none | none -> none | Yes |
| P1 | lite member, `spend/main` reading `TotalCost` | 400 `lwql_not_permitted` | none | none -> none (`lwql_queries_total` failure +1) | Yes |
| A | S, broken view | 400 `lwql_unknown_identifier` | ONE `error`: built_in, errorCode, projectId, statementHash | built_in none -> 1 | Yes |
| B | S + trailing space | 400 `lwql_unknown_identifier` | none | user_written none -> 1 | Yes |
| C | typo `TraceIdd` | 400 `lwql_unknown_identifier` | none | user_written 1 -> 2 | Yes |
| F5a | S, no `timeWindow` | 400 `lwql_parameter_missing` | none | built_in 1 -> 1 | Yes |
| F5b | window start after end | 400 `lwql_unknown_identifier` | ONE `error`, statementHash of S | built_in 1 -> 2 | Yes |
| G1 | `dashboards.sourcePresence`, `traces` probe broken | 200, `traces: "failed"` | ONE `error`: built_in, `lwql_unavailable`, `"source": "traces"`, no statementHash | built_in 2 -> 3 | Yes |

Every case matches 550c452. F5a's failure is still counted by main's run counter (`lwql_queries_total`).

## Notes
(a) The E and P1 first tries used a time window copied from the scrubbed 550c452 evidence (`00-00-00`). Both answered 400 `validation_error`, touched no counter and wrote no line (`case-E-try1-bad-window.txt`, `case-P1-try1-bad-window.txt`). Each case was run once more with the colons restored; the results above are from those re-runs.
(b) Not run at this head: D, F1-F4, F5c, PV, G0, P2-P5 (see 550c452).
(c) No browser walk.

## Teardown
- App stopped by its recorded pid; the log shows graceful shutdown.
- View restored (`Source` column count 1) and table renamed back to `trace_analytics` (`evidence/view-state.txt`).
- The run's ClickHouse database, user, named collection, settings profile and row policies dropped, each read back as 0.
- Shared ClickHouse users, roles, named collections, databases, settings profiles, row policies, quotas and SQL functions (name and definition), and shared Postgres roles and databases: compared before and after the run, no difference.
- Both throwaway containers removed (0 left).
