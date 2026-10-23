PR 8832 live proof — head 552ae038359fa5ebfaf563ebc4c69d76b9661151 (worktree langy-turn-retry)
Stack: haven up +langy (slug langy-turn-retry, api http://127.0.0.1:34483), Langy model = project's configured model.
Auth: seeded user-owned PAT (sk-lw-LocalDevPrivate1_... fixed local dev value) + X-Project-Id: local-dev-project.
  (The project ingestion key sk-lw-local-development-key gets 403 langy_api_key_unowned: Langy needs a user-owned key.)
Command per request (burst.sh, N in parallel, new conversation id each, same user):
  curl -X POST $B/api/langy/conversations/<id>/messages -H 'Prefer: wait=120' \
    -d '{"messages":[{"role":"user","content":"say hi"}],"idempotencyKey":"<id>","adoptConversationId":true}'
Per run: runN/summary.txt (status + trimmed body per request + counts), runN/resp-*.json, runN/api-logs-raw.txt, runN/api-logs-relevant.txt.

Results:
run1: HTTP codes: {'503': 7, '200': 9}; conflict log lines: 28; requests with >=1 conflict: 14; conflicted then admitted (200): 7; exhausted retries (non-200): 7
run2: HTTP codes: {'200': 6, '503': 6}; conflict log lines: 15; requests with >=1 conflict: 10; conflicted then admitted (200): 4; exhausted retries (non-200): 6
run3: HTTP codes: {'200': 13, '503': 7}; conflict log lines: 30; requests with >=1 conflict: 16; conflicted then admitted (200): 9; exhausted retries (non-200): 7

Reading:
- Write conflicts happened in every run: Prisma logs "Transaction failed due to a write conflict or a deadlock" at
  tx.langyActiveTurn.findUnique (repo :167) and tx.langyActiveTurn.create (repo :181).
- The retry engages: the same spanId logs 1-3 conflicts, and 20 requests across the 3 runs hit >=1 conflict and still
  settled HTTP 200 "completed" with a reply (they would have been HTTP 500 on the old code).
- No 500 in any run. BUT 20 of 48 requests ended HTTP 503 after 4 attempts:
  server log: LangyAgentUnavailableError "Too many turns are starting at once. Please retry shortly." code=langy_agent_unavailable
  wire body: {"type":"internal_error","code":"internal_error","message":"An unknown error occurred","retryable":false}
  (fault: platform redacts the message/code; retryable:false although the message says retry).
  The claim() loop retries immediately (no backoff/jitter, unlike withSerializationRetry in packages/prisma-client),
  so 12-20 simultaneous turns from one user exhaust all 4 attempts.
- Old code (not run): isRetryableTransactionError only matched P2002/P2034 codes; the driver-adapter
  TransactionWriteConflict was rethrown raw on the FIRST conflict -> HTTP 500 internal_error.
