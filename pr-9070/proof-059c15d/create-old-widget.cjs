const { chromium } = require(process.env.PW);
const PID = "project_000400pkxn6gn9z6pfZxbj9rISDpL";
const CODE = [
  "export default function Widget() {",
  '  const n = LW.useChartQuery("main", {}).data?.[0]?.n ?? 0;',
  '  return <span>{"$" + Number(n).toFixed(0)}</span>;',
  "}",
].join("\n");
const SQL = "SELECT count() + 1234.567 AS n FROM traces";
(async () => {
  const browser = await chromium.launch();
  const ctx = await browser.newContext({ baseURL: "http://localhost:5680", storageState: process.env.TMPDIR + "/ac11/state.json" });
  const page = await ctx.newPage();
  const call = async (p, data) => { const r = await page.request.post("/api/trpc/" + p, { data }); return [r.status(), await r.text()]; };
  const q = await call("analytics.lwql.query", { projectId: PID, sql: SQL });
  console.log("lwql", q[0], q[1].slice(0, 400));
  const b = await call("boards.create", { projectId: PID, name: "Board saved before v2 (runtime API)" });
  console.log("board", b[0], b[1].slice(0, 300));
  const boardId = JSON.parse(b[1]).result.data.id;
  const w = await call("dashboardWidgets.create", { projectId: PID, dashboardId: boardId, name: "Requests (old label)", code: CODE, queries: [{ name: "main", sql: SQL }] });
  console.log("widget", w[0], w[1].slice(0, 800));
  await browser.close();
})().catch((e) => { console.error(e); process.exit(1); });
