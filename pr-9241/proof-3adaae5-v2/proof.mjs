// PR 9241 proof: three Dashboards pages, asserted in the page. Needs state.json (signed-in cookie) beside it.
// usage: node proof.mjs <project-slug> <board-id> <out-dir>
import { chromium } from "playwright";
const [slug, boardId, out] = process.argv.slice(2);
const base = `http://localhost:5700/${slug}/dashboards`;
const pages = [
  ["board", `${base}/${boardId}`],
  ["curated", `${base}/curated/release`],
  ["templates", `${base}/templates`],
];
const ERROR_TEXT = /Couldn.t load|Something went wrong|failed to load|Unexpected error|We.ve been notified/i;
const b = await chromium.launch({ channel: "chromium" });
const ctx = await b.newContext({
  viewport: { width: 1280, height: 2400 },
  storageState: new URL("./state.json", import.meta.url).pathname,
});
let failed = false;
for (const [name, url] of pages) {
  const p = await ctx.newPage();
  const badResponses = [];
  p.on("response", (r) => { if (r.url().includes("/api/") && r.status() >= 400) badResponses.push(`${r.status()} ${r.url().slice(0, 120)}`); });
  await p.goto(url, { waitUntil: "domcontentloaded" });
  await p.waitForTimeout(5000);
  await p.waitForFunction(() => !document.querySelector("[class*=skeleton i],[data-part=skeleton],[aria-busy=true]"), null, { timeout: 90000 }).catch(() => console.log(name, "WARN: skeleton still present after 90s"));
  await p.waitForTimeout(3000);
  const r = await p.evaluate((errSrc) => {
    const text = document.body.innerText;
    return {
      h1: [...document.querySelectorAll("h1,h2")].map((e) => e.innerText.trim()).filter(Boolean).slice(0, 3),
      oldNotice: text.includes("Looking for the old Analytics"),
      openAnalyticsLink: [...document.querySelectorAll("a")].some((a) => a.innerText.trim() === "Open Analytics"),
      errorCard: new RegExp(errSrc, "i").test(text) || !!document.querySelector("[role=alert]"),
      retryButton: [...document.querySelectorAll("button")].some((x) => x.innerText.trim() === "Retry"),
    };
  }, ERROR_TEXT.source);
  r.badApiResponses = badResponses;
  r.url = p.url();
  console.log(name, JSON.stringify(r));
  if (r.oldNotice || r.openAnalyticsLink || r.errorCard || r.retryButton || badResponses.length) failed = true;
  await p.screenshot({ path: `${out}/${name}.png`, fullPage: true });
  await p.close();
}
await b.close();
console.log(failed ? "ASSERTIONS FAILED" : "ALL ASSERTIONS PASSED");
process.exit(failed ? 1 : 0);
