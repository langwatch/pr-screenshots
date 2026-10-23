PR 8838 live proof v2 - head 131599c2b3776f18a2f022603e9586738d7d5340 (worktree langy-card-reply, no repo edits)
PR: https://github.com/langwatch/langwatch/pull/8838
Change under test: langy-turns.rest.ts replyText() - a COMPLETED turn with blank text gets
  langyEmptyTurnLineFromParts(parts) in the REST reply; main returns settlement.text as is.
Stack: haven up +langy (slug langy-card-reply, api http://127.0.0.1:40495), Postgres db mydb schema mydb
  (container langwatch-postgres-1, no host psql: sql.sh runs psql inside it).
Auth: seeded user PAT (masked in the logged curl line) + X-Project-Id: local-dev-project.
Replay = same conversation id + idempotencyKey + text as the stored turn (replay.sh); the reply is
  computed from the stored projection row at read time (A2 control shows it moves with the row).
Rows used: turns from /tmp/proof-8838 runs 1-3. Originals saved in original-langyturn_*.tsv before any edit.

Case | setup readback (file)                                   | HTTP | reply.text                                    | old vs new?
A    | answerParts = ["tool-code_access"], 0 text parts        | 200  | "I'm waiting for you to say how I should      | YES: main returns "" here
     | (A-setup-readback.txt)                                  |      |  reach your code, on the card above."         | (settlement.text = text parts only)
A2   | answerParts = [] (A2-control-empty-setup-readback.txt) | 200  | generic LANGY_EMPTY_TURN_FALLBACK line        | YES: main returns ""; also proves read-time
C    | text part = "PROBE-8838", card kept                     | 200  | "PROBE-8838"                                  | NO (same on main); proves own text is not
     | (C-setup-readback.txt)                                  |      |                                               | overwritten even with a code_access card
D    | status = stopped, parts tool-ls, tool-local_ls,         | 200  | "" (status "stopped")                         | NO (same on main); proves the outcome guard:
     | tool-code_access, 0 text parts (D-setup-readback.txt)   |      |                                               | a stopped blank turn gets no line
B    | SKIPPED: no clean way to run main's REST code on this stack without editing the worktree or a second
     | checkout + stack. Main's line (git diff): reply text = settlement.text = extractLangyTextFromParts(parts).
E    | UNIT-TEST ONLY. No live way: the canary (platform-health LangyCanaryService) sends a greeting with a
     | fresh key each run, so it cannot be pointed at a card-only turn. It reads awaitTurnSettlement, whose
     | settlement.text is unchanged by this PR (diff touches only the REST transport, empty-turn rules and
     | tests); covered by langy-canary.rules.unit.test.ts "names a completed turn that ended on a card with
     | no text empty_reply".

Restores: A-restore-readback.txt, C-restore-readback.txt, D-restore-readback.txt; final-restore-check.txt
  shows all three rows back to their original status and answerParts md5.
Extra: A0-baseline-before-edit.txt (row as stored), A-after-restore-replay.txt (after restore).
