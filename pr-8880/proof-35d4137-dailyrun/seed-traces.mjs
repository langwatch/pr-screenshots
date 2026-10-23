import fs from "node:fs";
import crypto from "node:crypto";
import pg from "/home/ubuntu/worktrees/langwatch-pr8880/node_modules/.pnpm/pg@8.22.0/node_modules/pg/lib/index.js";
const env = fs.readFileSync("/home/ubuntu/worktrees/langwatch-pr8880/.env", "utf8");
const u = new URL(env.match(/^DATABASE_URL=(.*)$/m)[1].replace(/^"|"$/g, ""));
const schema = u.searchParams.get("schema") ?? "public"; u.search = "";
const c = new pg.Client({ connectionString: u.toString(), options: `-c search_path=${schema}` });
await c.connect();
const key = fs.readFileSync("/tmp/pr8880-dr.xPAZrs/pat.key","utf8").trim();
await c.end();
const hex = (n) => crypto.randomBytes(n).toString("hex");
const attr = (k, v) => ({ key: k, value: { stringValue: String(v) } });
const day = (d, ms) => Date.UTC(2026, 9, d) + ms;
function trace({ start, errored, searchMs, refundMs }) {
  const tid = hex(16), root = hex(8);
  const ns = (ms) => String(BigInt(Math.round(ms)) * 1000000n);
  const span = (name, s, dur, parent, err) => ({ traceId: tid, spanId: parent ? hex(8) : root, ...(parent ? { parentSpanId: root } : {}), name, kind: 1, startTimeUnixNano: ns(s), endTimeUnixNano: ns(s + dur), attributes: [attr("service.name", "checkout")], status: err ? { code: 2, message: "upstream error" } : { code: 1 } });
  return [
    span("checkout-agent", start, searchMs + refundMs + 50, false, errored),
    span("tool.search", start + 10, searchMs, true, false),
    span("tool.refund", start + 20 + searchMs, refundMs, true, errored),
  ];
}
const jit = (m) => m * (0.85 + Math.random() * 0.3);
const spans = [];
for (let i = 0; i < 200; i++) { // day before: 20 errors, search 4.2s, refund 1.1s
  spans.push(...trace({ start: day(20, Math.random() * 86400000 * 0.99), errored: i < 20, searchMs: jit(4200), refundMs: jit(1100) }));
}
for (let i = 0; i < 200; i++) { // yesterday: 90 errors, 63 inside 14:00-15:00 UTC; search 2.9s, refund 1.9s
  const inHour = i < 63;
  const t = inHour ? 14 * 3600000 + Math.random() * 3500000 : Math.random() * 86400000 * 0.99;
  spans.push(...trace({ start: day(21, t), errored: i < 90, searchMs: jit(2900), refundMs: jit(1900) }));
}
for (let i = 0; i < spans.length; i += 150) {
  const body = { resourceSpans: [{ resource: { attributes: [attr("service.name", "checkout")] }, scopeSpans: [{ scope: { name: "pr8880-proof" }, spans: spans.slice(i, i + 150) }] }] };
  const r = await fetch("http://localhost:5800/api/otel/v1/traces", { method: "POST", headers: { "content-type": "application/json", authorization: `Bearer ${key}` }, body: JSON.stringify(body) });
  console.log(i, r.status, (await r.text()).slice(0, 120));
}
