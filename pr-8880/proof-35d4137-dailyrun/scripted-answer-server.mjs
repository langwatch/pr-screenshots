import http from "node:http";
import fs from "node:fs";
const PORT = 5815;
const FENCE = "`".repeat(3);
const card = { kind: "insights", blockId: "daily-insights", findings: [
  { title: "Checkout errors more than quadrupled", tone: "bad", key: "checkout-errors", validDays: 3,
    body: "Traces with an error rose from 20 to 90 yesterday against the day before; 63 of the 90 fell between 14:00 and 15:00 UTC. Next step: open the failing traces from 14:00 to 15:00 UTC and find what changed in the refund step then." },
  { title: "Refund step got slower", tone: "watch", key: "refund-latency", validDays: 3,
    body: "The tool.refund step went from about 1.1 s to about 1.9 s per call. Check whether the 14:00 UTC change that raised errors also added the wait." },
  { title: "Search step got faster", tone: "good", key: "search-latency-better",
    body: "The tool.search step went from about 4.2 s to about 2.9 s per call." },
] };
const answer = ["I read the error, failing-step and latency widgets for yesterday against the day before.", "", FENCE + "langy-card", JSON.stringify(card), FENCE].join("\n");
http.createServer((req, res) => {
  let body = ""; req.on("data", (d) => body += d); req.on("end", () => {
    let j = {}; try { j = JSON.parse(body); } catch {}
    const msgs = j.messages ?? []; const last = JSON.stringify(msgs).includes("Daily insights run for one LangWatch dashboard");
    fs.appendFileSync("/tmp/pr8880-dr.xPAZrs/mock-calls.log", `${new Date().toISOString()} ${req.method} ${req.url} stream=${!!j.stream} msgs=${msgs.length} tools=${(j.tools??[]).length} daily=${last}\n`);
    const text = last ? answer : "ok";
    if (req.url.includes("/chat/completions")) {
      const id = "chatcmpl-scripted", created = Math.floor(Date.now()/1000), model = j.model ?? "scripted-daily";
      if (j.stream) {
        res.writeHead(200, { "content-type": "text/event-stream" });
        const ch = (delta, fr) => `data: ${JSON.stringify({ id, object: "chat.completion.chunk", created, model, choices: [{ index: 0, delta, finish_reason: fr }] })}\n\n`;
        res.write(ch({ role: "assistant", content: "" }, null)); res.write(ch({ content: text }, null)); res.write(ch({}, "stop"));
        res.write(`data: ${JSON.stringify({ id, object: "chat.completion.chunk", created, model, choices: [], usage: { prompt_tokens: 100, completion_tokens: 200, total_tokens: 300 } })}\n\n`);
        res.end("data: [DONE]\n\n");
      } else {
        res.writeHead(200, { "content-type": "application/json" });
        res.end(JSON.stringify({ id, object: "chat.completion", created, model, choices: [{ index: 0, message: { role: "assistant", content: text }, finish_reason: "stop" }], usage: { prompt_tokens: 100, completion_tokens: 200, total_tokens: 300 } }));
      }
    } else if (req.url.includes("/models")) { res.writeHead(200, { "content-type": "application/json" }); res.end(JSON.stringify({ object: "list", data: [{ id: "scripted-daily", object: "model" }] })); }
    else { res.writeHead(404); res.end("{}"); }
  });
}).listen(PORT, "127.0.0.1");
