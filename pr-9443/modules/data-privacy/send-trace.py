"""Send one OTLP/JSON trace to the local stack.

usage: send-trace.py <app_port> <label> [--long]
Input carries an email, a person name Presidio finds (John Smith) and the
marker ZORBLAX that only the model stand-in reports. --long pads the input
past the model's 8,000-character batch cap. Prints trace id.
"""
import json, os, sys, time, urllib.request

port, label = sys.argv[1], sys.argv[2]
long_mode = "--long" in sys.argv
trace_id = os.urandom(16).hex()
span_id = os.urandom(8).hex()
text = f"[{label}] Hi, I am John Smith, mail john.smith@acme.com, codename ZORBLAX."
if long_mode:
    text += " filler" * 1400  # ~9,800 characters
now = time.time_ns()
body = {
    "resourceSpans": [{
        "resource": {"attributes": [{"key": "service.name", "value": {"stringValue": "pii-routing-check"}}]},
        "scopeSpans": [{"scope": {"name": "pii-check"}, "spans": [{
            "traceId": trace_id, "spanId": span_id, "name": f"pii-check {label}", "kind": 1,
            "startTimeUnixNano": str(now - 1_000_000), "endTimeUnixNano": str(now),
            "attributes": [
                {"key": "langwatch.span.type", "value": {"stringValue": "llm"}},
                {"key": "langwatch.input", "value": {"stringValue": json.dumps({"type": "text", "value": text})}},
                {"key": "langwatch.output", "value": {"stringValue": json.dumps({"type": "text", "value": f"ok {label}"})}},
            ],
        }]}],
    }]
}
req = urllib.request.Request(
    f"http://127.0.0.1:{port}/api/otel/v1/traces", data=json.dumps(body).encode(),
    headers={"content-type": "application/json", "Authorization": "Bearer " + os.environ["LANGWATCH_API_KEY"]},
)
with urllib.request.urlopen(req, timeout=30) as r:
    print(json.dumps({"label": label, "trace_id": trace_id, "status": r.status, "chars": len(text)}))
