Proof for PR 8830 at e371dceda695fd3c68e7a9afa8f2b34609dafb06. Stack: pnpm dev from the worktree, api+worker+ui+aigateway+langyagent, own projects in a throwaway org.
Disclosed manipulations: (1) gap 2 backdates my own archived card by 4 days (3-day validity cannot elapse); (2) my own ordinary trace deleted from ClickHouse for gap 4 negative; (3) SpanCount=0 late-origin rows in my own projects deleted before runs.
Metrics insight_board_health_check_total NOT captured (pushed over OTLP only).
