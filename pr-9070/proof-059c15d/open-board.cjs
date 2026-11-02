const { chromium } = require(process.env.PW);
const fs = require("fs");
const PID = "project_000400pkxn6gn9z6pfZxbj9rISDpL";
const BOARD = "dashboard_00046Ld4c8UrqTPWNW3tXMfwujGVc";
const OUT = process.env.OUT;
const SLUG = "ac11-proof-project-rISDpL";
(async () => {
  const browser = await chromium.launch();
  const ctx = await browser.newContext({ baseURL: "http://localhost:5680", storageState: process.env.TMPDIR + "/ac11/state.json", viewport: { width: 1440, height: 900 } });
  const list = async (label) => {
    const r = await ctx.request.get("/api/trpc/dashboardWidgets.list?input=" + encodeURIComponent(JSON.stringify({ projectId: PID, dashboardId: BOARD })));
    const body = await r.text();
    fs.writeFileSync(`${OUT}/list-${label}.json`, body);
    return JSON.parse(body).result.data;
  };
  const before = await list("before");
  const page = await ctx.newPage();
  const log = [];
  let phase = "open";
  page.on("request", (req) => {
    const u = new URL(req.url());
    if (u.pathname.startsWith("/api/")) log.push(`${phase}\t${req.method()}\t${u.pathname}`);
  });
  await page.goto(`/${SLUG}/dashboards/${BOARD}`);
  await page.waitForTimeout(12000);
  await page.screenshot({ path: `${OUT}/01-board-open.png` });
  const texts = async () => { const out = []; for (const f of page.frames()) { if (f === page.mainFrame()) continue; try { out.push((await f.locator("body").innerText()).trim()); } catch {} } return out; };
  console.log("frame texts (open):", JSON.stringify(await texts()));
  console.log("label visible (open):", await page.getByText("Requests (old label)").first().isVisible());
  phase = "reload";
  await page.reload();
  await page.waitForTimeout(12000);
  await page.screenshot({ path: `${OUT}/02-board-after-reload.png` });
  console.log("frame texts (reload):", JSON.stringify(await texts()));
  // card close-up
  const card = page.locator('[data-testid="widget-card-footer"]').first().locator("xpath=..");
  try { await page.getByText("Requests (old label)").first().locator("xpath=ancestor::*[.//iframe][1]").screenshot({ path: `${OUT}/03-widget-card.png` }); } catch (e) { console.log("card shot failed", e.message); }
  await page.close();
  const after = await list("after");
  fs.writeFileSync(`${OUT}/network.tsv`, log.join("\n") + "\n");
  const writes = log.filter((l) => /\/api\/trpc\/(boards|dashboardWidgets)\./.test(l) && !/(getAll|listStarred|list|getById|scopeImpact|scopeProjects)$/.test(l));
  console.log("api requests:", log.length, "board/widget writes:", JSON.stringify(writes));
  const pick = (d) => d.map((w) => ({ id: w.id, name: w.name, graph: w.graph, updatedAt: w.updatedAt }));
  console.log("before==after:", JSON.stringify(pick(before)) === JSON.stringify(pick(after)));
  console.log("after graph keys:", Object.keys(after[0].graph).join(","), "updatedAt", after[0].updatedAt);
  await browser.close();
})().catch((e) => { console.error(e); process.exit(1); });
