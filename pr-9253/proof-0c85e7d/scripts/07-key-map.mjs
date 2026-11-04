// Writes each seeded project's LangWatchQL key-map row to the server that project's organization is routed to,
// using the repo's own capability function. The app does this on a "project created" event; the seed inserted
// projects with SQL, so no event fired.
import { pathToFileURL } from "node:url";
const repo = process.env.REPO;
const { LangWatchQLCapabilityService } = await import(
  pathToFileURL(`${repo}/modules/analytics/process/src/services/langwatch-ql-capability.service.ts`).href
);
const capability = LangWatchQLCapabilityService.create();
import { execFileSync } from "node:child_process";
const out = execFileSync("sudo", ["docker", "exec", "proof9253c-pg", "psql", "-U", "prisma", "-d", "proof9253", "-At", "-F", "|", "-c",
  `select id, "lwqlKey" from "Project" where id in ('projshared','projprivate','projnoroute')`], { encoding: "utf8" });
const rows = out.trim().split("\n").map((line) => { const [id, lwqlKey] = line.split("|"); return { id, lwqlKey }; });
const servers = {
  projshared: ["48123", "proof_shared"],
  projprivate: ["48124", "proof_private"],
  projnoroute: ["48124", "proof_private"], // route absent: its row is irrelevant, the query must never reach any server
};
for (const { id, lwqlKey } of rows) {
  const [port, database] = servers[id];
  const body = JSON.stringify({ KeyHash: capability.tenantCapability({ secret: lwqlKey }), TenantId: id });
  const auth = Buffer.from(`default:${process.env.CH_PASSWORD}`).toString("base64");
  const res = await fetch(`http://127.0.0.1:${port}/?query=${encodeURIComponent(`INSERT INTO ${database}.lwql_api_key_tenant_map FORMAT JSONEachRow`)}`, {
    method: "POST", headers: { Authorization: `Basic ${auth}` }, body,
  });
  console.log(id, "->", port, res.status);
}
