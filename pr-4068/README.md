# PR #4068 evidence — prompt sync fidelity

The customer authored a `.prompt.yaml` with `model: openai/gpt-5.4-mini`, a structured-output JSON schema, and **no** `temperature`. Pulling after a platform edit erased the schema and injected `temperature: 0`. This PR restores lossless `response_format` round-trip and keeps sync a pure pass-through (no fabricated defaults).

## Round-trip on the customer's exact picnic-classifier shape

[`dogfood-round-trip.txt`](dogfood-round-trip.txt) runs the user's YAML through push, the platform API shape, then pull and asserts:

```
response_format identical after push->pull: true
temperature still absent: true
```

## Test suites

- `typescript-sdk`: 461 unit + CLI integration tests green (incl. converter round-trip, push omits absent temperature, full create-push-pull cycle).
- `langwatch`: prompt-config unit suite green; `DEFAULT_MODEL` drift guard fails CI if the constant ever falls behind the registry flagship or points at a legacy generation.
- Feature parity: 1089/1089 enforced scenarios bound.

## Spec

`specs/prompts/prompt-sync-fidelity.feature` (9 scenarios, all bound).
