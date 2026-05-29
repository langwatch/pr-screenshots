# PR #4282 — `feat(api-keys): scope filter + Shiki-backed command snippets`

Branch: `feat/api-keys-scope-filter-and-token-snippets`
PR: https://github.com/langwatch/langwatch/pull/4282

Captured via Playwright headless (1440×900 viewport) on the local dev server at `localhost:5560`, signed in as the test account.

## 1. Scope filter on `/settings/api-keys`

| File | What |
|------|------|
| `api-keys-scope-filter-default.png` | Default page state. Filter button reads "All you can see" and sits to the LEFT of the "+ Create new secret key" button. Both keys visible (legacy Project API Key + a personal "TEST TEST" key). |
| `api-keys-scope-filter-dropdown-open.png` | Dropdown menu open showing the four root options: All you can see / This Team / This Project / More Scopes. |
| `api-keys-scope-filter-more-scopes.png` | "More Scopes" submenu expanded showing the organization, two teams, and two projects. |
| `api-keys-scope-filter-narrowed.png` | Filter narrowed to a specific project. URL becomes `?scope=PROJECT:<id>`. Both keys still match (they're bound to that project). |
| `api-keys-scope-filter-empty.png` | Filter narrowed to a sibling team where no keys are bound. Table shows the plain "No keys match the current scope. Change the filter above to see other keys." empty state. No "Show all" reset link — matches the `/settings/model-providers` precedent. |
| `api-keys-scope-filter-stale-url.png` | Navigated directly to `?scope=TEAM:non-existent-id-12345` (stale URL pointing to a deleted team). Filter falls back to "All you can see" instead of rendering "Team: undefined". |

URL persistence verified: switching the dropdown writes `?scope=TYPE:id`; refreshing the page re-hydrates the same filter from the URL.

## 2. Token Created modal

Modal opens after creating a key with name "QA Test", keeping defaults (Personal, This project, All permissions). All snippets render through the new `ShikiCommandBox` (lazy-loaded via `dynamic()` from `~/components/code/ShikiCommandBox`).

| File | What |
|------|------|
| `token-created-env-tab.png` | "Use in Code" → `.env` tab. Three lines: `LANGWATCH_API_KEY="sk-l*****…"`, `LANGWATCH_PROJECT_ID=...`, `LANGWATCH_ENDPOINT=...`. Keys and string values visually distinct (`ini` highlighting). |
| `token-created-bearer-tab.png` | Bearer tab — shellscript highlighting. |
| `token-created-basic-tab.png` | Basic Auth tab — same shellscript highlighting. |
| `token-created-claude-code-tab.png` | "Use with Code Assistants" → Claude Code tab. Shows the `>_` prompt glyph at the left of the `claude mcp add langwatch …` install command, plus the JSON config block below. |
| `token-created-codex-tab.png` | Codex tab — same layout, `codex` install command. |
| `token-created-claude-code-rainbow-frame1.png` / `-frame2.png` / `-frame3.png` | Three frames of the rainbow gradient animation on the Claude Code terminal command, captured ~1s apart. 5-stop gradient `#0143cb → #2b6ff4 → #d23401 → #ff651f → #fba000 → #0143cb` applied via `background-clip: text` with a 3s `background-position-x` scroll. |
| `token-created-codex-rainbow-frame.png` | Same rainbow on the Codex tab. |
| `token-created-json-config.png` | "Or paste into your config file" JSON block, rendered by the existing `JsonHighlight` component. |
| `token-created-amber-warning.png` | The amber alert ("Copy this token now. You won't be able to see it again.") between Use in Code and Use with Code Assistants. |

## 3. Clipboard verification

Programmatically clicked the "Copy claude code command" button while intercepting `navigator.clipboard.writeText`. Sample clipboard payload (token / project id / endpoint redacted):

```
claude mcp add langwatch --env LANGWATCH_PROJECT_ID=<project-id> -- npx -y @langwatch/mcp-server --api-key <real-token> --endpoint <endpoint>
```

- ✅ Starts with `claude` (no leading `>_` glyph).
- ✅ Contains the unmasked API key (not the masked `sk-lw-••••<tail>` form).
- ✅ `String.includes('>_')` returns `false`.

The `>_` prompt glyph is rendered as a sibling `<Box aria-hidden="true">` next to the highlighted code, never enters `codeToHtml`'s source string, never enters the clipboard.

## 4. Regression check on `/settings/model-providers`

| File | What |
|------|------|
| `model-providers-scope-filter.png` | `/settings/model-providers` page. The renamed shared `ScopeFilter` primitive (`<button data-testid="scope-filter">`) still renders here, defaulting to "All you can see". Rename + extraction of `useAvailableScopes` and `useUrlScopeFilter` hooks didn't break the page that was already shipped. |

## 5. Known WIP

- **Horizontal scroll on very long terminal commands is broken** (commit `694ba4402` is tagged `wip:` for this reason). When the install command is wider than the rainbow box (typical case once you have a real long API key + custom endpoint), the wrapper's `overflow-x: auto` doesn't engage — the `<pre>` keeps `width: 820px` and the text wraps invisibly underneath. The rainbow itself animates correctly. Diagnosis in the commit message. In the 1440px viewport headless screenshots here the command happens to fit on one line (`pre.scrollWidth === pre.clientWidth === 820`) so the regression isn't visible — it reproduces at narrower widths and with real-Chrome font metrics.
