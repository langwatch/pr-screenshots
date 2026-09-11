# pr-8071 — voice worker per-worker cloudflared tunnel

Real dev app screenshots for scenario run `scenariorun_0006lLQuwntHPvNBhdHy42UBgY6Lu`
(trace `dcdacc07b2183564d0666b7db25d1fa0`), captured live from the LangWatch
Trace Explorer at `https://app.voice-triage-survey.langwatch.localhost`,
project `Browser Test Org`.

- `01-scenario-run-conversation.png` — trace drawer, Conversation tab: real
  phone-call turn with audio players (user simulator + agent), scenario run
  badge `local-tunnel-phone-billing-0...`, 130.4s duration, 31 spans, SDK
  Scenario · Nodejs 2.10.0.
- `02-scenario-run-summary.png` — same trace, Summary tab: input/output text
  matching the PR's judge transcript ("duplicate charge $49.99 please refund").
