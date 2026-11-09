"""Local stand-in for the PII redaction model's Presidio-compatible route.

Forwards each batch to the local Presidio (langevals) and adds one marker:
the word ZORBLAX is reported as PERSON. Presidio alone never flags it, so a
stored trace shows which path redacted it.

Modes (POST /mode with body ok|slow|error): ok answers; slow sleeps 70 s
(over the app's 50 s cap); error answers 500. Every call is logged to stdout
with the mode and text sizes only, never the text.
"""
import json, os, re, sys, time, urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PRESIDIO = os.environ["PRESIDIO_ENDPOINT"].rstrip("/")
ROUTE = "/presidio/pii_detection/evaluate"
STATE = {"mode": "ok"}


def log(**kw):
    print(json.dumps({"t": time.strftime("%H:%M:%S"), **kw}), flush=True)


class H(BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def _send(self, code, body):
        data = json.dumps(body).encode()
        self.send_response(code)
        self.send_header("content-type", "application/json")
        self.send_header("content-length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        self._send(200, {"mode": STATE["mode"]})

    def do_POST(self):
        raw = self.rfile.read(int(self.headers.get("content-length", 0)))
        if self.path == "/mode":
            STATE["mode"] = raw.decode().strip()
            log(event="mode", mode=STATE["mode"])
            return self._send(200, STATE)
        if self.path != ROUTE:
            return self._send(404, {"error": "no route"})
        body = json.loads(raw)
        texts = [d.get("input", "") for d in body.get("data", [])]
        mode = STATE["mode"]
        log(event="call", mode=mode, texts=len(texts), chars=sum(len(t) for t in texts))
        if mode == "slow":
            time.sleep(70)
        if mode == "error":
            return self._send(500, {"error": "stand-in error mode"})
        req = urllib.request.Request(PRESIDIO + ROUTE, data=raw, headers={"content-type": "application/json"})
        with urllib.request.urlopen(req, timeout=60) as r:
            answer = json.loads(r.read())
        for i, text in enumerate(texts):
            res = answer[i]
            if res.get("status") != "processed":
                continue
            if "ZORBLAX" not in text:
                continue
            raw_resp = res.get("raw_response") or {}
            res["raw_response"] = raw_resp
            ents = raw_resp.setdefault("results", [])
            for m in re.finditer(r"ZORBLAX", text):
                ents.append({"entity_type": "PERSON", "start": m.start(), "end": m.end(), "score": 0.99})
            raw_resp["anonymized"] = (raw_resp.get("anonymized") or text).replace("ZORBLAX", "<PERSON>")
            res["status"] = "processed"
        try:
            self._send(200, answer)
        except BrokenPipeError:
            log(event="client_gone", mode=mode)


if __name__ == "__main__":
    port = int(sys.argv[1])
    log(event="start", port=port, presidio=PRESIDIO)
    ThreadingHTTPServer(("127.0.0.1", port), H).serve_forever()
