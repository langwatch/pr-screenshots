# PR #355 — voice agents demo audio

Verified-passing demos from langwatch/scenario PR #355 (issue #350).
Captured 2026-05-12 from end-to-end runs against real provider APIs.

| File | Demo | Verdict | What it shows |
|---|---|---|---|
| `elevenlabs_hosted.mp3` | EL hosted ConvAI | PASS (4/4) | Two-turn happy path. Greeting on connect → user question → agent answer → user follow-up referencing prior turn → context-aware reply. |
| `elevenlabs_branded.mp3` | EL composable + branded agent | PASS (4/4) | Branded `ElevenLabsVoiceAgent` (STT/LLM/TTS providers). Same two-turn shape; STT + LLM + TTS seams all fire. |
| `elevenlabs_interruption.mp3` | EL interruption (server VAD barge-in) | FAIL by judge (intended) | User barges in mid-utterance asking about business hours. Agent's reply is truncated but does NOT pivot to the new topic — load-bearing judge catches that the agent ignored the barge-in. The demo's job is to FAIL when EL doesn't acknowledge interruption. |
| `twilio_inbound.mp3` | Twilio inbound (real PSTN) | PASS (3/3) | Second Twilio number dials in; agent adapter answers via Media Streams. Real audio exchange over PSTN. |
| `twilio_outbound.mp3` | Twilio outbound (real PSTN) | PASS (3/3) | Adapter places outbound REST call from one Twilio number to another; B-leg's `voice_url` attaches Media Streams; bidirectional audio bridges the legs. |

## How to inline in the PR description

Use raw URLs. GitHub renders `.mp3` as an inline audio player in PR bodies.

```
https://github.com/langwatch/pr-screenshots/raw/main/pr-355-voice-agents/elevenlabs_hosted.mp3
```
