# Langy quality bar > when a time-bounded question finds nothing but older data exists > says the project never received traces with a label it never saw

**Verdict:** PASS
**Generated:** 2026-10-15T13:32:48.462Z

## Judge reasoning

The agent correctly stated that there were no traces with the specified label in the last hour. It also confirmed that the project never received traces with this label by performing broad searches and checking available facets, which did not contain the label. The agent did not invent any trace times and did not imply any data access issues, instead offering a plausible reason for the absence of traces.

## Criteria
- [x] Langy says there were no matching traces in the last hour.
- [x] Langy says the project has never received traces with that label, or that it found none in any window.
- [x] Langy does not invent a time for a newest matching trace.
- [x] Langy never says or implies that it cannot see or access the data.

## Browser QA

**Verdict:** FAIL
**Notes:** Browser QA threw: locator.fill: Timeout 30000ms exceeded.
Call log:
[2m  - waiting for locator('input[type="password"]')[22m

**Screenshot:** /home/ubuntu/worktrees/langwatch-issue8735/.claude/tmp/ac-pIFt9R/langy-patched/scenario-logs/screenshots/Langy-quality-bar-when-a-time-bounded-question-finds-nothing-but-older-data-exists-says-the-project-never-received-trace-error.png

## Conversation

### user

how many traces labelled e2e-never-12a67223 did I get in the last hour?

### assistant

```json
{
  "type": "tool-call",
  "toolCallId": "call_608453",
  "toolName": "bash",
  "input": {
    "command": "langwatch trace --help"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_563709",
  "toolName": "bash",
  "input": {
    "command": "langwatch trace search --help"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_479713",
  "toolName": "langwatch.trace.fields",
  "input": {
    "command": "langwatch trace fields --format json"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_503445",
  "toolName": "bash",
  "input": {
    "command": "date --iso-8601=seconds"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_651909",
  "toolName": "bash",
  "input": {
    "command": "date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_695137",
  "toolName": "langwatch.trace.search",
  "input": {
    "command": "langwatch trace search --filter \"label:e2e-never-12a67223\" --start-date \"2026-10-15T12:31:28Z\" --format json"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_756533",
  "toolName": "langwatch.trace.search",
  "input": {
    "command": "langwatch trace search --filter \"label:e2e-never-12a67223\" --start-date \"1970-01-01T00:00:00Z\" --format json"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_537137",
  "toolName": "langwatch.trace.search",
  "input": {
    "command": "langwatch trace search --filter \"label:e2e-never-12a67223\" --start-date 0 --format json"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_472314",
  "toolName": "langwatch.trace.search",
  "input": {
    "command": "langwatch trace search --filter \"label:e2e-never-12a67223\" --start-date \"2020-01-01T00:00:00Z\" --format json"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_485892",
  "toolName": "langwatch.trace.facets",
  "input": {
    "command": "langwatch trace facets label --format json"
  }
}
```
```json
{
  "type": "tool-call",
  "toolCallId": "call_577084",
  "toolName": "langwatch.trace.search",
  "input": {
    "command": "langwatch trace search -q \"e2e-never-12a67223\" --start-date \"2020-01-01T00:00:00Z\" --format json"
  }
}
```

### tool

```json
{
  "type": "tool-result",
  "toolCallId": "call_608453",
  "toolName": "bash",
  "output": {
    "type": "text",
    "value": "Usage: langwatch trace [options] [command]\n\nSearch and inspect traces\n\nOptions:\n  -h, --help                      display help for command\n\nGlobal Options:\n  -v, --version                   Display the current version\n  -o, --output <format>           Output format: table (default), json, agents\n                                  (compact single-line JSON), or yaml (choices:\n                                  \"table\", \"json\", \"agents\", \"yaml\")\n  --json <fields>                 Emit JSON with only the given comma-separated\n                                  fields\n  --jq <expr>                     Filter output with a path expression (e.g.\n                                  .traces[].traceId, .traces[0], length)\n  --agent                         Agent mode: compact JSON output, no colour, no\n                                  spinners (auto-detected from agent env vars)\n\nCommands:\n  search [options]                Search traces with optional text query and\n                                  date range\n  export [options]                Export traces as CSV, JSONL, or JSON\n  get [options] <traceId>         Get full trace details by ID\n  transcript [options] <traceId>  Print the coding-agent transcript of a trace\n                                  (what the agent did, in order)\n  facets [options] [field]        Discover what the filter fields actually hold\n                                  in this project. With no field, every facet\n                                  and its top values; with a field, that field's\n                                  values and counts\n  fields [options]                List every field a trace filter can name, with\n                                  its value type and group\n  help [command]                  display help for command\n"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_563709",
  "toolName": "bash",
  "output": {
    "type": "text",
    "value": "Usage: langwatch trace search [options]\n\nSearch traces with optional text query and date range\n\nOptions:\n  -q, --query <query>    Text search query. Plain text only: AND, OR and NOT are\n                         matched as words, not as operators\n  --filter <filter>      Trace filter, the language the Trace Explorer search\n                         bar speaks: \"status:error AND model:gpt-*\",\n                         \"trace.attribute.langwatch.user_id:alice\",\n                         \"evaluatorVerdict:fail\". Combined with -q and the other\n                         flags. `langwatch trace fields` lists every field\n  --start-date <date>    Start date (ISO string or epoch ms, default: 24h ago)\n  --end-date <date>      End date (ISO string or epoch ms, default: now)\n  --limit <n>            Max results to return (default: 25)\n  --origin <origins>     Filter by trace origin, comma-separated (e.g.\n                         application,evaluation,simulation,playground,langy);\n                         'application' includes traces with no recorded origin\n  --errors-only          Only traces that contain an error. The error is on the\n                         span, not in the searchable text, so this is the way to\n                         find failures\n  --project <idOrSlug>   Project to run against, by id or slug (default: your\n                         personal project). Needs a login that reaches it;\n                         `langwatch projects list` shows which ones do\n  -f, --format <format>  Output format: table (default) or json (default:\n                         \"table\")\n  -h, --help             display help for command\n\nGlobal Options:\n  -v, --version          Display the current version\n  -o, --output <format>  Output format: table (default), json, agents (compact\n                         single-line JSON), or yaml (choices: \"table\", \"json\",\n                         \"agents\", \"yaml\")\n  --json <fields>        Emit JSON with only the given comma-separated fields\n  --jq <expr>            Filter output with a path expression (e.g.\n                         .traces[].traceId, .traces[0], length)\n  --agent                Agent mode: compact JSON output, no colour, no spinners\n                         (auto-detected from agent env vars)\n"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_479713",
  "toolName": "langwatch.trace.fields",
  "output": {
    "type": "text",
    "value": "{\"kind\":\"json\",\"payload\":{\"dynamicPrefixes\":[{\"aliases\":[\"attribute.\"],\"description\":\"Filter by a key on the trace's `Attributes` map\",\"label\":\"Trace attribute\",\"prefix\":\"trace.attribute.\"},{\"aliases\":[],\"description\":\"Filter by a key on any span's `SpanAttributes` map\",\"label\":\"Span attribute\",\"prefix\":\"span.attribute.\"},{\"aliases\":[\"event.\"],\"description\":\"Filter by a key on any span event's `Attributes` map\",\"label\":\"Event attribute\",\"prefix\":\"event.attribute.\"}],\"fields\":[{\"facetable\":true,\"group\":\"trace\",\"knownValues\":[\"application\",\"simulation\",\"evaluation\",\"sample\",\"gateway\",\"playground\",\"workflow\",\"coding_agent\",\"ai_tool\",\"langy\"],\"label\":\"Origin\",\"name\":\"origin\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"trace\",\"knownValues\":[\"error\",\"warning\",\"ok\"],\"label\":\"Status\",\"name\":\"status\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"span\",\"knownValues\":[],\"label\":\"Model\",\"name\":\"model\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"span\",\"knownValues\":[],\"label\":\"Service\",\"name\":\"service\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Cost\",\"name\":\"cost\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Duration\",\"name\":\"duration\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Tokens\",\"name\":\"tokens\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Time to first token\",\"name\":\"ttft\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Time to last token\",\"name\":\"ttlt\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Prompt tokens\",\"name\":\"promptTokens\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Completion tokens\",\"name\":\"completionTokens\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Tokens / second\",\"name\":\"tokensPerSecond\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"span\",\"knownValues\":[],\"label\":\"Span count\",\"name\":\"spans\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Storage size\",\"name\":\"size\",\"valueType\":\"range\"},{\"facetable\":true,\"group\":\"span\",\"knownValues\":[],\"label\":\"Root span type\",\"name\":\"rootSpanType\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"span\",\"knownValues\":[],\"label\":\"Span type\",\"name\":\"spanType\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"trace\",\"knownValues\":[],\"label\":\"Trace name\",\"name\":\"traceName\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"trace\",\"knownValues\":[],\"label\":\"Guardrail\",\"name\":\"guardrail\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"eval\",\"knownValues\":[],\"label\":\"Annotation\",\"name\":\"annotation\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"trace\",\"knownValues\":[],\"label\":\"Contains AI\",\"name\":\"containsAi\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"trace\",\"knownValues\":[],\"label\":\"Error message\",\"name\":\"errorMessage\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"metrics\",\"knownValues\":[],\"label\":\"Tokens estimated\",\"name\":\"tokensEstimated\",\"valueType\":\"categorical\"},{\"facetable\":false,\"group\":\"trace\",\"knownValues\":[],\"label\":\"Prompt ID\",\"name\":\"prompt\",\"valueType\":\"text\"},{\"facetable\":true,\"group\":\"trace\",\"knownValues\":[],\"label\":\"Selected prompt\",\"name\":\"selectedPrompt\",\"valueType\":\"categorical\"},{\"facetable\":true,\"group\":\"trace\",\"knownValues\":[],\"label\":\"Last used prompt\",\"name\":\"lastUsedPrompt\",\"valueType\":\"categorical\"},\"… 29 more items truncated, 54 total\"]}}\n\n[Display note: this tool output was reduced for display. The agent read the full payload, so data beyond what is shown here existed. A reply citing an item or a count that is not visible here is citing the reduced part, not fabricating.]"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_503445",
  "toolName": "bash",
  "output": {
    "type": "text",
    "value": "2026-10-15T13:31:26+00:00\n"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_651909",
  "toolName": "bash",
  "output": {
    "type": "text",
    "value": "2026-10-15T12:31:28Z\n"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_695137",
  "toolName": "langwatch.trace.search",
  "output": {
    "type": "text",
    "value": "{\"kind\":\"card\",\"card\":\"traces\",\"payload\":{\"traces\":[],\"pagination\":{\"totalHits\":0,\"total\":0}}}"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_756533",
  "toolName": "langwatch.trace.search",
  "output": {
    "type": "error-text",
    "value": "Invalid --start-date: pass an ISO-8601 instant or epoch milliseconds.\n\n\nCommand exited with code 1"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_537137",
  "toolName": "langwatch.trace.search",
  "output": {
    "type": "error-text",
    "value": "Invalid --start-date: pass an ISO-8601 instant or epoch milliseconds.\n\n\nCommand exited with code 1"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_472314",
  "toolName": "langwatch.trace.search",
  "output": {
    "type": "text",
    "value": "{\"kind\":\"card\",\"card\":\"traces\",\"payload\":{\"traces\":[],\"pagination\":{\"totalHits\":0,\"total\":0}}}"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_485892",
  "toolName": "langwatch.trace.facets",
  "output": {
    "type": "text",
    "value": "{\"kind\":\"json\",\"payload\":{\"values\":[{\"value\":\"e2e-seed\",\"count\":32},{\"value\":\"e2e-stale-b738ccdc\",\"count\":6},{\"value\":\"proof2-stale-modupsqz\",\"count\":3},{\"value\":\"e2e-stale-820a29a2\",\"count\":3},{\"value\":\"proof-stale-aef495e3\",\"count\":3},{\"value\":\"e2e-stale-0d6b110c\",\"count\":3},{\"value\":\"proof3-stale-4lhk12yv\",\"count\":3},{\"value\":\"e2e-stale-b8e74c7c\",\"count\":3},{\"value\":\"proof2-live-modupsqz\",\"count\":1},{\"value\":\"proof3-live-4lhk12yv\",\"count\":1}],\"total\":10,\"hasMore\":false}}"
  }
}
```
```json
{
  "type": "tool-result",
  "toolCallId": "call_577084",
  "toolName": "langwatch.trace.search",
  "output": {
    "type": "text",
    "value": "{\"kind\":\"card\",\"card\":\"traces\",\"payload\":{\"traces\":[],\"pagination\":{\"totalHits\":0,\"total\":0}}}"
  }
}
```

### assistant

No traces labelled e2e-never-12a67223 in the last hour; the project never received traces with this label. Likely cause: the application is not instrumented to attach this label.
