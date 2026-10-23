# langwatch/langwatch#8450: gateway voice, end-to-end proof

Recorded 2026-10-06 on branch gateway-voice-broker (commit 3fbacf41f0) against real OpenAI and ElevenLabs.
Local stack: gateway :5573 built from the branch, api and worker :6570, UI :5570. Every call used one
virtual key (`voice-user-1`) with a 5 USD monthly budget, lowered to 0.01 USD for the budget proof.
The demo page was served from http://localhost:5590, a different origin than the gateway, with
`LW_GATEWAY_CORS_ALLOWED_ORIGINS=http://localhost:5590`.

## Audio (mp4 plays in the GitHub blob view; raw files beside each)

| File | Route | Model |
| --- | --- | --- |
| 0-question-input.mp4 | spoken question used as the microphone | - |
| 1a-openai-speech-stream.mp4 | POST /v1/audio/speech, stream_format audio | gpt-4o-mini-tts |
| 1b-elevenlabs-stream-eleven_v4_turbo.mp4 | POST /v1/text-to-speech/{voice}/stream | eleven_v4_turbo |
| 1b-elevenlabs-stream-eleven_flash_v2_5.mp4 | POST /v1/text-to-speech/{voice}/stream | eleven_flash_v2_5 |
| 1c-elevenlabs-stream-input-ws-relay.mp4 | WS /v1/text-to-speech/{voice}/stream-input through the gateway relay | eleven_flash_v2_5 |
| 1d-live-webrtc-reply.mp4 | POST /v1/live/sessions, WebRTC, reply recorded from the remote track | gpt-live-1 |
| 1d-realtime-call-reply.mp4 | POST /v1/realtime/calls, WebRTC, reply recorded from the remote track | gpt-realtime-2.1-mini |
| 1e-live-websocket-relay.mp4 | WS /v1/live/sessions through the gateway relay | gpt-live-1 |

## Transcription

- 2a-transcription-diarized_json.*: 200, 13 segments with speaker, start, end.
- 2b-transcription-text.request-and-response.txt: 200, `Content-Type: text/plain; charset=utf-8`.

## Browser screenshots

- S1-live-call.png: Live call from the demo page, 201, session.started, usage update, reply transcript, recorded reply.
- S1b-realtime-call.png: Realtime call from the demo page, response.done with usage, reply transcript.
- S2-budget-exceeded.png: budget at 0.01 USD, the gateway ends the running call, the next Start call answers 402 budget_exceeded with budget_scope virtual_key.
- S3-cors-refused.png: the same page served from http://localhost:5591, refused by the browser (no Access-Control-Allow-Origin).
- S4 to S10: LangWatch UI: budgets over the limit, virtual key spend, usage by model, traces of a Live call, a Realtime call and an ElevenLabs relayed socket with cost.

## Logs and API reads

- 4-relay-vendor-live-tests.log: `LW_GATEWAY_RELAY_LIVE=1` relay tests against the vendors.
- 5-latency.txt: time to first byte direct to OpenAI vs through the gateway.
- 6-budgets-and-spend.txt, 6-spend-rows.txt: budget read (spent vs limit) and the key's spend records, one per usage report keyed `<session>.<report key>`.
- trace-*.json: the trace API read for the voice sessions.
