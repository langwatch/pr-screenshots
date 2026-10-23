PR 8832 live proof v2 - head 4d222d92758c811fd82d82caeeba8d15f3e9a7b9 (worktree langy-turn-retry, clean)
Change under test: claim() waits random() * 10ms * 2^attempt between its 4 attempts (max waits 10/20/40 ms).
Baseline: /tmp/proof-8832/ (head 552ae038359, no backoff).
Stack: haven up +langy (slug langy-turn-retry, api http://127.0.0.1:39565). Machine load avg 31-39 on 8 cores
  during these runs (busier than the baseline run; 503s took 2-10 s here vs 1-2 s before).
Seed failed at boot ("upgrade lease was lost", load); data kept from the earlier run, so the seeded PAT still works.
burst.sh is the baseline script; only B (port) and OUT dir changed. run.sh = burst + log capture + analyse.py.
Per run: runN/summary.txt, resp-*.json, status-*.txt, api-logs-raw.txt (haven logs api worker, burst window),
  api-logs-relevant.txt (conflict + error lines), api-logs-grep.txt ("write conflict"/"retry"/"Too many turns").
Note: "conflict log lines" undercount retries - some 503 spans log fewer than 4 conflict lines (one logs 0), so
  some failed attempts are not logged as "write conflict". "Too many turns" appears 2x per 503 (REST + handler).

Results (new head):
run1: HTTP codes: {'200': 11, '503': 5}; conflict log lines: 25; requests with >=1 conflict: 9; conflicted then admitted (200): 4; exhausted retries (non-200): 5
run2: HTTP codes: {'200': 6, '503': 6}; conflict log lines: 16; requests with >=1 conflict: 7; conflicted then admitted (200): 2; exhausted retries (non-200): 6
run3: HTTP codes: {'503': 10, '200': 10}; conflict log lines: 32; requests with >=1 conflict: 14; conflicted then admitted (200): 4; exhausted retries (non-200): 10
run4-n8: HTTP codes: {'200': 5, '503': 3}; conflict log lines: 13; requests with >=1 conflict: 6; conflicted then admitted (200): 3; exhausted retries (non-200): 3
run5-n4: HTTP codes: {'200': 4}; conflict log lines: 2; requests with >=1 conflict: 2; conflicted then admitted (200): 2; exhausted retries (non-200): 0
Total conflict lines in worker.log this boot: 88 (= 25+16+32+13+2).
