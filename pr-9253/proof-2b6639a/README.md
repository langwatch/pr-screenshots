# Use-proof: run start and the route's database name (PR 9253)

Head proven: `2b6639af1cd26efb37609efc34fdbd290055e213` (worktree clean, no source changed). Everything ran locally: own containers, nothing shared touched.
All names (organizations, labels, databases) are invented for this run. Keys and passwords are random per run and appear nowhere here.

## Stack
Same as the earlier proof (scripts copied and extended): Postgres, Redis, two ClickHouse servers, "shared" (`proof_shared`, port 18123) and "private" (`proof_private`, port 18124); api + worker in one process on port 15560. One app run served every case below (it was restarted once, before cases A and B, to turn the flag on; the read cases 1 to 9 ran on the first start, A and B on the second, same head and same data).
New for this run:
- Route `orgdash` (label `dashlabel`): `http://<credentials>@127.0.0.1:18124/acme-db`. The server is the private one; the path names a database with a hyphen that does not exist there. Seeded with its own project and key.
- Instant Evals on: `RELEASE_INSTANT_EVALS=1` (the flag `release_instant_evals`; the derived variable accepts "1" or "0" only, "true" is ignored) and `INSTANT_EVAL_CLASSIFIER=memory`. `memory` is the repo's own deterministic stand-in judge, allowed outside production. Self-hosted `isEnabled` needs a judge that is not `null`, then the flag. Run start validates before any judge is called, so the stand-in does not change the path under proof.
- Run start: `POST /api/v1/instant-evals`, body `{"sql": ...}`, legacy project key. Script `scripts/13-run-start.sh`. Evidence per case: request, raw body, HTTP status, then every statement the LangWatchQL identity ran on each server since the request.

## Results

| # | Case | Result |
|---|------|--------|
| 1a, 1b | Private org, unqualified `traces` and `trace_metrics` | PASS: 200, one statement, private server only (`current_database: proof_private`) |
| 2 | Private org, `proof_private.traces` | PASS: 200, private only |
| 3a, 3b | Naming the other database (private org names `proof_shared`; shared org names `proof_private`) | PASS (refused): 400 `lwql_not_permitted`, no statement on either server |
| 4a, 4b | Shared org, unqualified and `proof_shared.traces` | PASS: 200, shared server only |
| 5a | Private org, route variable missing | PASS: 503 `private_dataplane_unavailable`, no statement |
| 9 | Windowed statement, private org | PASS: 200 with `completeness`, two statements, private only, none on shared |
| A1 | Run start, private org, `FROM proof_shared.traces` | PASS (refused): 422 `instant_eval_query_invalid`, violation `TABLE_NOT_ALLOWED`, no statement on either server |
| A2 | Run start, private org, `FROM proof_private.traces` | PASS: 202 queued run; statements on the private server only |
| A3 | Run start, private org, `FROM traces` (unqualified) | PASS: 202, private only |
| B1, B2 | Run start, org routed to `.../acme-db` (`FROM traces`; `FROM acme-db.traces`) | PASS (refused): HTTP 503; app log `lwql_unavailable`; no statement anywhere (see wire note) |
| B3 | Same org, `POST /api/v1/query` | Same refusal as B1: 503, log `lwql_unavailable`, no statement |
| C | ClickHouse on a hyphenated database name | See below |

Wire note for B: the body on the wire is `{"code":"internal_error","message":"An unknown error occurred"}` with status 503, not `lwql_unavailable`. The app log carries `error.code: lwql_unavailable`, `LangWatchQLUnavailableError`, message `LangWatchQL is not available for this organization's ClickHouse.` This is the same masking the earlier proof found for the ftp route.

### A. Run start on a private route
A1 (refused): `SELECT TraceId, 'pm-A1-' AS marker, eval(CapturedOutput, 'The answer is polite') AS polite FROM proof_shared.traces` -> `HTTP 422`, `"code":"instant_eval_query_invalid"`, violation `TABLE_NOT_ALLOWED`: `The view "proof_shared.traces" is not available to you`, and `availableViews` lists `proof_private.*` names. `rows on SHARED: 0`, `rows on PRIVATE: 0`.
A2 (accepted): same statement over `proof_private.traces` -> `HTTP 202`, a run `status: queued`, `questions: [polite]`. The first private statement (15:37:19) is a probe:
```
user: langwatch_lwql_proof   current_database: proof_private   databases: ['proof_private']
query_text: SELECT * FROM ( SELECT TraceId, 'pm-A2-' AS marker, eval(CapturedOutput, ...) AS polite FROM proof_private.traces ) AS q LIMIT 0 FORMAT JSON
```
The log shows 7 statements in all for A2 (and A3): two `LIMIT 0` probes, a row count, two page reads and two row reads. I did not separate which belong to the submit and which to the queued run that the in-process worker started right after. So "one LIMIT 0 probe" is not what the log shows: there are two, one second apart. `rows on SHARED: 0` for A2 and A3.
A3 (unqualified): `HTTP 202`, same shape, all on `proof_private`.

### B. Route path `/acme-db`
B1 and B2: `HTTP 503`, `rows on SHARED: 0`, `rows on PRIVATE: 0`. `evidence/case-B-anyuser-count.txt`: no statement from any user on either server mentions `pm-B` or `acme-db` (0 and 0). The refusal comes before any connection to the server. `acme-db` and the route URL appear nowhere in the log of the second start, which served A and B (0 matches). Correction made when this folder was published: the log of the first start has `acme-db` on 81 lines, all from outside the query path (40 event store `storeEvents` failures, 40 queue retries of them, 1 gateway spend settlement sweep), message `Database acme-db does not exist`. The route URL with its host and port is on 0 lines of that log. See `proof-0c85e7d`, section D and E, for the same finding at the later head.
Side note: the app log carries a warn line `legacy project key outside its scopes` for B1 and B3 (organization `orgdash`). I did not look into it.

### C. What ClickHouse does with a hyphenated name (`evidence/case-C.txt`, throwaway database on the private proof server, dropped)
- Quoted in SQL (`` `pm-c-db`.t ``): works, returns 1.
- Bare in SQL (`FROM pm-c-db.t`): `Code: 62 ... Syntax error: failed at position 23 (-)`. The statement is read as a subtraction.
- Dialled as the connection's database (`?database=pm-c-db`): works, returns 1; for a missing one (`?database=acme-db`) `UNKNOWN_DATABASE`.
So a hyphen is fine as a dialled name and breaks the bare name the generated SQL writes, which is why the route's name is checked for a plain shape.

## Not run
- Organization-scoped or personal keys, and the member (browser) path.
- Cases 3 to 8 of the earlier proof other than 5a (malformed, ftp, unreachable, two-organization sets); not re-run.
- Insight filter and editor markers (out of scope of the change).
- What the queued run does after it is accepted (judging, results): not read.
- Trailing-slash and percent-encoded names against a live stack: unit tests only.

## Teardown
`scripts/99-down.sh`.
