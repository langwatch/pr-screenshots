# Run 3 — Migrate an existing Auth0 customer onto LangWatch's own SSO, self-serve

Stack: `app.identity-sso.langwatch.localhost:1355`, IdP simulator tenant 2 (`acme2.test`).
Browser: Playwright Chromium 1.61.1, headless, 1440x900 @2x, light mode, `ignoreHTTPSErrors`.
Date on the machine: 2026-09-16. Deployment posture: **self-hosted** (`IS_SAAS` unset).

Starting point: run 1's live self-serve OIDC connection `Acme Identity` on
**Local Dev Organization**, and run 2's SCIM state. Neither was touched.

**A second organization was built for this run, because there was no other way.**
See "What I had to write by hand" below — that is itself finding #1.

## Screenshots, in the order a person sees them

| File | What it shows |
|---|---|
| `01-local-password-door.png` | `/auth/signin?local=1` — the break-glass door used to sign in as the administrator. |
| `02-live-org-authentication-overview.png` | Local Dev Organization's Authentication overview. A live OIDC connection, `acme1.test` proved. |
| `03-live-org-identity-provider-no-migration-anywhere.png` | Its Identity provider page — the six-step self-serve journey. **No Auth0, no migration, no replacement anywhere on it.** The migration UI only exists for `source === "legacy-grandfathered"`. |
| `04-ops-migrations-page-redirects-customer-admin-away.png` | `/ops/migrations` as the organization's own Admin: **silently redirected** to the project home. The page that enrolls and runs the grandfather migration is staff-only, and says nothing about why. |
| `05-auth0-customer-told-to-connect-a-provider.png` | **The headline.** `Northwind Analytics` carries `ssoDomain=northwind.test`, `ssoProvider=auth0` — its people sign in through Auth0 right now. LangWatch shows it **"Connect your identity provider — Do this next"**, with an **Auth0 tile** among the vendor choices. `getSetup` answers `connection: null, migration: null`. The product does not know they have SSO. |
| `06-legacy-migration-start-after-hand-made-grandfather.png` | `LegacyMigrationStart`, reached only after I wrote the grandfathered connection into Postgres by hand. "Auth0 single sign-on · Active", "Migrate from Auth0", "Who can join through Auth0". |
| `07-set-up-the-replacement-vendor-picker.png` | "Set up the replacement" — the same vendor picker, including an Auth0 tile you could pick as the replacement for Auth0. |
| `08-replacement-form-shows-predecessors-callback-url.png` | **Bug.** The replacement's OIDC form shows Redirect address `…/api/auth/sso/callback/ssoc_gf_org-auth0-legacy` — **the predecessor's connection id**, under copy telling the reader to paste it into their identity provider. |
| `09-replacement-form-filled.png` | Name, issuer (`…/t/2`), client id and secret filled in. |
| `10-register-refused-requires-enterprise-plan.png` | **A good refusal.** "Registering that connection didn't work / Single sign-on requires an Enterprise plan / Copy error ID". The organization had no licence row. |
| `11-migration-start-again-with-a-licence.png` | Same screen after the organization was given the deployment's Enterprise licence. |
| `12-register-pressed-nothing-happens.png` | **Register pressed. The replacement WAS created** (`ssoc_replacement_bffa013cee…`, VERIFIED, `migrationPhase=SETUP`). The screen does not move: same form, same button, no success, no error, no navigation. |
| `13-identity-provider-page-never-loads-again.png` | **Reload. The Identity provider page is a skeleton, forever.** `ssoSetup.getSetup` now answers **500 "An unknown error occurred"** for this organization, permanently, because the state is durable. |
| `14-overview-now-says-single-sign-on-not-set-up.png` | **The lying status.** Authentication → Overview for the same organization: **"Single sign-on — Not set up"**, "First step: Telling us about your identity provider", **[Set it up →]**. It has a live SSO connection and a registered replacement mid-migration. The card degrades to the empty state on the 500 instead of showing an error. |
| `15-front-door-northwind-address-typed.png` | The front door with `someone@northwind.test`. |
| `16-front-door-single-sign-on-not-finished.png` | "**Single sign-on is not finished being set up** — sign in with your email and password, or ask whoever runs LangWatch to finish setting it up", and a password box. **Caveat: this one is my fixture's fault** — see "Honest caveats". |

## What actually happened

A customer cannot start this flow at all, and if they somehow could, one click
past the start breaks the page the flow lives on.

**Nobody can mint the grandfathered connection on this installation.** The
migration is registered (`system-migrations/runtime.ts:139`) but declares
`runsAutomaticallyOnSelfHosted = false` and `enrolledAutomatically = false`
(`connection-grandfather.migration.ts:41,47`). `migrationRunsOnThisInstallation`
(`cohort.ts:98-105`) therefore answers **false** on a self-hosted installation
for every organization, and the ops page's targeted run is refused by name at
`system-migrations.service.ts:667` with `MigrationNotAvailableOnInstallationError`.
There is no ops SSO surface of any kind (`grep -rn "grandfather" platform/app/src/pages/ops` → nothing).
On Cloud the same migration reaches only organizations an operator enrolled by
hand. So: **no customer path, and on this deployment no operator path either.**

**Until that happens, the Auth0 customer is shown the new-customer journey.**
`getSetup` reads the `SsoConnection` projection and nothing else; the legacy
`Organization.ssoDomain`/`ssoProvider` columns are invisible to it. So the
screen says "Connect your identity provider — Do this next" and offers an Auth0
tile (screenshot 05). A customer who follows it registers an **ordinary
self-serve connection** — `replacesConnectionId: null`, no inherited domain
proof, no route selection, no rollback lever, no quiet period — on the very
domain their Auth0 setup already routes. Nothing on the screen says the two
would compete.

**With the grandfathered connection in place, the flow renders and then dies.**
"Migrate from Auth0" → vendor picker → OIDC form → Register. The registration
succeeds in the database and the screen does not acknowledge it (screenshot 12).
Reload, and `ssoSetup.getSetup` answers 500 for good (screenshot 13).

The cause is one invalid Prisma query:

```
prisma:error Invalid `this.prisma.organizationUser.count()` invocation in
  .../identity/repositories/sso-migration-progress.prisma.repository.ts:499:36
Unknown argument `identifiers`. Available options are marked with ?.
```

`memberWhereClauses` (`sso-migration-progress.prisma.repository.ts:147-155`)
builds `user: { identifiers: { some|none: { connectionId, state } } }`, but the
Prisma `User` model **has no `identifiers` relation** — `Identifier` carries a
bare `userId` column and no back-reference (`schema.prisma`, `model User` has
`accounts`, `passkeys`, `sessions`… and no `identifiers`). Both `.count()` at
:499 and `.findMany()` at :500 throw. `getSetup` includes the migration view, so
the whole SSO settings screen goes with it, and `finalizeLegacyMigration` 500s
through the same read.

**There is no way back from inside the product.** `discardConnection` on the
replacement restores the page — I proved it, `getSetup` returned 200 again — but
the only UI that reaches it, `RemoveConnectionSection`, lives inside
`ConnectedJourney`, which never renders for a grandfathered connection;
`LegacyMigrationStart` has no removal section at all. The customer's only
recovery is a support ticket.

## Where exactly it stops, step by step

| Step | What happens | File |
|---|---|---|
| See that you have Auth0 | Nothing acknowledges it. "Connect your identity provider." | `sso-self-serve.service.ts` (reads the projection only) |
| Get a grandfathered connection | **Impossible.** Not self-serve, not on this installation at all | `connection-grandfather.migration.ts:41,47`; `cohort.ts:98`; `system-migrations.service.ts:667` |
| See "Migrate from Auth0" | Renders, once the connection exists | `SingleSignOnSetup.tsx:263-272` |
| Get the addresses for your IdP | **Wrong id** — the predecessor's | `sso-engine-provider.ts:251`, `sso-self-serve.service.ts:597` |
| Register the replacement | Succeeds; screen does not move | `ssoSetup.ts:339`, `sso-self-serve.service.ts:1081` |
| Read the migration checklist | **500 for good.** Takes the whole screen with it | `sso-migration-progress.prisma.repository.ts:147-155, 499-500` |
| Test sign-in through the replacement | Not reachable — the page is dead | — |
| Switch to new SSO | Never offered. Directly: 409, replacement is VERIFIED not ACTIVE | `sso-connection-guards.ts:135, 408` |
| Roll back to Auth0 | Never offered. Same 409 | same |
| Finalize | **500**, same broken read | `sso-migration-finalization.service.ts` → the repo above |

## The five predictions

**1 — "The grandfathered connection is minted only by an operator-enrolled system
migration; there may be no customer-facing way to get one at all."**
**VERIFIED, and worse than predicted.** There is no customer path, and on a
self-hosted installation there is no operator path either:
`migrationRunsOnThisInstallation({isSaaS:false, runsAutomaticallyOnSelfHosted:false})`
is `false` (`cohort.ts:98-105`), and the ops targeted run refuses by name
(`system-migrations.service.ts:667`). Live evidence: `/ops/migrations` silently
redirected the organization's Admin away (screenshot 04, `ADMIN_EMAILS` is
`admin@mail.langwatch.localhost`, the signed-in admin is `admin@haven.localhost`),
and there is no ops SSO surface at all. Separately, the composition's own
docblock at `identity/runtime.ts:1299` still says the migration is "composed but
deliberately NOT registered … until then it runs for nobody", which
`system-migrations/runtime.ts:139` contradicts — it is registered.

**2 — "`self_serve_sso` is a per-org feature flag, default off."**
**VERIFIED as written, NOT REACHED as a gate here.** `featureFlag/registry.ts:388-390`:
`key: "self_serve_sso"`, `defaultValue: false`, and the `FeatureFlag` table holds
no row for it. But `SsoSelfServeContextAdapter.resolve`
(`sso-self-serve-adapters.ts:130-145`) consults it **only when `deployment === "hosted"`**;
self-hosted uses the licence instead. On this stack the gate that actually bit
was the licence: `startLegacyMigration` returned 403 **"Single sign-on requires
an Enterprise plan"** (screenshot 10) until I gave the organization a licence row.

**3 — "Activation needs a live break-glass binding AND a mounted local password
door; on Cloud that is a deadlock. This stack has local passwords, so it may not
bite."**
**VERIFIED as a requirement, and it does NOT bite here.** `activateConnection`
(`sso-connection-guards.ts:1095-1135`) requires a qualified domain proof, a
recorded test login, and `breakGlass.reserveActivationRecovery` returning true —
otherwise `no live break-glass binding for organization …`. Run 1 satisfied all
three on this stack via the local password door, so the Cloud deadlock is not
reproducible here. I could not reach activation of a *replacement* in this run,
because the screen dies two steps earlier.

**4 — "`Identifier.connectionId` is hardcoded `null` at its only emitter, so
`linkedCount` may be permanently 0 and `canFinalize` permanently false."**
**VERIFIED on the running system, and superseded by something worse.**
`packages/identity-server/src/guards.ts:279` emits `connectionId: null` in the
only `IDENTIFIER_ATTACHED` builder; the fold copies it straight through
(`identifier-aggregate.ts:186`) and the projection writes it
(`identifier-row.ts:74`). Live proof:

```
SELECT "connectionId", count(*) FROM "Identifier" GROUP BY 1;
 connectionId | count
--------------+-------
              |     9
```

All nine rows are NULL — including the identifiers created by run 1's real SSO
sign-ins through a live connection. So the link the checklist counts is never
written. But `linkedCount` is never even computed: the query that would count it
is invalid Prisma and throws first (finding above). The root cause is the same
half-finished wiring seen from two ends.

**5 — "`selectMigrationRoute` has no ACTIVE precondition; the UI disables the
button but the procedure does not, so flipping to `direct` with a merely VERIFIED
replacement may silently fall back to Auth0 while the card claims the new
provider."**
**REFUTED, live.** I registered a replacement that inherited the predecessor's
domain proof and therefore sat in **VERIFIED** with `migrationPhase = SETUP` —
exactly the predicted scenario — and called the procedure directly with the
admin's session:

```
selectMigrationRoute route=direct  → 409 sso_connection_invalid_transition
selectMigrationRoute route=legacy  → 409 sso_connection_invalid_transition
```

The body at `sso-connection-guards.ts:405-428` carries no explicit check, but
line 408's `this.require(data, SELECT_MIGRATION_ROUTE_COMMAND_TYPE)` enforces
`ALLOWED_FROM[SELECT_MIGRATION_ROUTE_COMMAND_TYPE] = ["ACTIVE"]` (line 135)
against the **replacement's** own state. A non-ACTIVE replacement cannot be
routed to. The dangerous lying-status scenario is not reachable this way.
(The UI gate is also not the one predicted: the button is
`disabled={!migration.testSignIn.done}`, `SingleSignOnSetup.tsx:385`.)

## Problems, worst first

1. **The migration checklist query is invalid and 500s every time, taking the
   whole SSO settings screen with it.** `sso-migration-progress.prisma.repository.ts:147-155`
   builds `user: { identifiers: { some|none: … } }`; `model User` in
   `platform/app/prisma/schema.prisma` has no `identifiers` relation. Lines
   :499 and :500 throw `Unknown argument 'identifiers'`. `getSetup` embeds the
   migration view, so **any organization with a registered replacement loses its
   Identity provider page permanently**, and `finalizeLegacyMigration` 500s too.
   Reproduced end to end (screenshots 12, 13). This is unconditional — it is not
   data-dependent and it is not a race.
2. **The Authentication overview answers "Single sign-on — Not set up" for an
   organization that has live SSO and a migration in flight** (screenshot 14).
   `getSetup` 500s and the card degrades to the empty state with a "Set it up →"
   call to action. A customer reading it would conclude their SSO is gone.
3. **There is no self-serve route into the flow at all, and on self-hosted no
   operator route either.** See prediction 1. Every Auth0 customer is shown the
   new-customer journey instead (screenshot 05), whose only outcome is a
   competing connection on a domain their legacy configuration already routes.
4. **No way out from inside the product.** `discardConnection` fixes it
   (proved), but `RemoveConnectionSection` is only mounted inside
   `ConnectedJourney` (`SingleSignOnSetup.tsx:225-233`) and `LegacyMigrationStart`
   (`:248-292`) has no removal at all — and the page it would live on is the one
   that 500s.
5. **Pressing Register gives no feedback at all when it succeeds.** The
   connection is created and the form sits unchanged (screenshot 12). The
   failure path is excellent (screenshot 10) and the success path is silent.
6. **The replacement's setup form hands out the predecessor's callback URL.**
   `serviceProviderDetailsFor` (`sso-engine-provider.ts:239-263`) is called with
   `state?.connectionId ?? null` (`sso-self-serve.service.ts:597`), which during a
   replacement registration is the grandfathered connection. Screenshot 08:
   `…/callback/ssoc_gf_org-auth0-legacy`, under copy that says "give it this
   address … come back for the finished address". A customer who follows it
   configures their new IdP app with an id that will never be called.
7. **Every word on the migration screens hardcodes "Auth0".**
   `SingleSignOnSetup.tsx:263` `title="Auth0 single sign-on"`, `:267` "Your
   existing Auth0 sign-in", `:272` "Migrate from Auth0", `:276` "Who can join
   through Auth0", `:337` "Auth0 migration", `:342` "Auth0 (legacy)", `:365`
   "Still using Auth0", `:415` "Roll back to Auth0". A grandfathered connection's
   provider name comes from `Organization.ssoProvider` and can be anything; an
   Okta or Ping customer is told, eight times, that they are on Auth0.
8. **The whole migration checklist is unspecified and untested.** Nothing in
   `specs/` mentions "Members linked", stragglers, the quiet period, "Switch to
   new SSO", "Finalize migration" or "Roll back to Auth0"; the only scenarios
   near it are `sso-connection-lifecycle.feature:269-283` (grandfathering itself)
   and `sso-idp-termination.feature:409`. No test touches
   `sso-migration-progress.prisma.repository.ts` — the one test naming
   `linkedCount` (`break-glass-local-door.unit.test.ts:198`) hands it a literal.
   That is how an invalid Prisma query reached a customer-facing page.
9. **Every migration refusal reaches the client as a bare code.** All three verbs
   answer `sso_connection_invalid_transition` with `meta: {}` — the server knows
   whether it was "not a migration replacement" or "not allowed from VERIFIED",
   and says neither. There is no `presentation.ts` copy difference between them.
10. **`finalizeLegacyMigration` answers 500 rather than a refusal** even when the
    correct answer is a clean "you are not in the direct route yet".
11. **The Authentication rail's "Overview" link loses the organization.** From
    `/settings/authentication/provider` in Northwind, clicking Overview rendered
    **Local Dev Organization's** authentication settings, header and all. The
    href is a bare `/settings/authentication` (`AuthenticationLayout.tsx:50-53`)
    and the organization is resolved from `localStorage`
    (`useOrganizationTeamProject.ts:319-340`). Reproduced twice; not
    deterministic, which is worse.
12. **Minor.** The composition docblock at `identity/runtime.ts:1299` says the
    grandfather migration is "deliberately NOT registered … it runs for nobody",
    contradicted by `system-migrations/runtime.ts:139`. The deployment's signed
    licence is not bound to an organization id — the same string pasted onto a
    second organization made it Enterprise immediately.

## Honest caveats

- **Screenshot 16 is my fixture, not a product bug.** `isMethodConfigured` for a
  `legacy-grandfathered` connection asks whether the deployment *mounts* a
  provider by that name (`sso-method-configured.ts:44-52`:
  `(await ports.mountedMethodId()) === methodId`). This stack mounts no `auth0`
  provider, so my hand-made connection reads "not configured" and the door falls
  back to a password form with "Single sign-on is not finished being set up". A
  real Auth0 customer's deployment would have it mounted. What the screenshot
  *does* honestly show is the copy and the fallback for an unconfigured
  connection.
- The grandfathered connection was written directly into Postgres, so its
  **event log does not exist** — only its projection. Every command in this run
  read it and none appended to it, so no result above depends on the missing log.
  The replacement, by contrast, went through the real command path end to end.

## What I had to write by hand — the self-serve failures, named

| Needed | Why | How I got it |
|---|---|---|
| A second organization with the legacy columns | There is no "create organization" UI on this deployment, and the live org already holds a self-serve connection | `INSERT` into `Organization` (`ssoDomain='northwind.test'`, `ssoProvider='auth0'`), `OrganizationUser`, `Team`, `TeamUser`, `Project` |
| A role binding | `OrganizationUser.role = ADMIN` alone gives `permission_denied / no-binding` on `sso:view` | `INSERT` into `RoleBinding` (ORGANIZATION + TEAM, ADMIN) |
| An Enterprise plan | `startLegacyMigration` is an `enterpriseSsoProcedure`; an unlicensed self-hosted org resolves to `UNLIMITED_PLAN`, which is not ENTERPRISE | Copied `Organization.license` from the seeded local dev org |
| **The grandfathered connection** | **No customer path, and no operator path on self-hosted** | `INSERT` into `SsoConnection` (`source='legacy-grandfathered'`, ACTIVE, `northwind.test` verified with `method='legacy-configuration'`), plus `SsoConnectionRegistrationSlot` (`kind='legacy'`), `SsoVerifiedDomain`, `SsoVerifiedDomainHolder` |
| Reaching the second organization's settings | The settings rail carries no org in its links | `localStorage.selectedOrganizationId` / `selectedProjectSlug` set from the driver |

Everything below the line in that table is a screen a customer can never reach
without LangWatch staff, direct database access, or both.

## State left behind

**Nothing from runs 1 and 2 was changed.** Local Dev Organization's connection,
proved domain, break-glass grant, SCIM token, users, group and `ScimSyncState`
are exactly as run 2 left them. `ssoSetup.getSetup` and `getMigrationProgress`
for that organization both answer **200** (verified at the end of this run). The
IdP simulator's SCIM connection to LangWatch was **not touched** — I never
pressed "Sync the difference", so run 2's `cannot_disable_last_admin` fix is
**still unverified**. Run 2's recovery `curl` remains valid if it is ever needed.

**New, all of it mine, all of it removable:**

- Organization `org-auth0-legacy` "Northwind Analytics" (`northwind-analytics`),
  `ssoDomain=northwind.test`, `ssoProvider=auth0`, carrying a copy of the
  deployment's Enterprise licence.
- `Team` `team-northwind`, `Project` `northwind-project`, `TeamUser` and
  `OrganizationUser` and two `RoleBinding` rows for `local-dev-admin-user`.
- `SsoConnection` rows in that organization:
  - `ssoc_gf_org-auth0-legacy` — ACTIVE, `legacy-grandfathered`, **hand-written**
  - `ssoc_replacement_35da80d670fffaefa2f7de8e` — DISCARDED (first attempt)
  - `ssoc_replacement_bffa013cee6b58f62daa5abf` — VERIFIED, `migrationPhase=SETUP`,
    **registered through the real UI/API**
- `SsoConnectionRegistrationSlot` rows (`legacy` + `direct`),
  `SsoVerifiedDomain`/`Holder` for `northwind.test`.

**`org-auth0-legacy` is deliberately left in the bricked state** — it is the
repro for finding #1 and #2. Its Identity provider page 500s and its overview
says "Not set up".

To un-brick it without deleting anything, discard the live replacement:

```
ssoSetup.discardConnection { organizationId: "org-auth0-legacy",
                             connectionId: "ssoc_replacement_bffa013cee6b58f62daa5abf" }
```

To remove the whole fixture:

```sql
DELETE FROM "SsoVerifiedDomainHolder" WHERE "organizationId" = 'org-auth0-legacy';
DELETE FROM "SsoVerifiedDomain"       WHERE "organizationId" = 'org-auth0-legacy';
DELETE FROM "SsoConnectionRegistrationSlot" WHERE "organizationId" = 'org-auth0-legacy';
DELETE FROM "SsoConnection"     WHERE "organizationId" = 'org-auth0-legacy';
DELETE FROM "RoleBinding"       WHERE "organizationId" = 'org-auth0-legacy';
DELETE FROM "Project"           WHERE "teamId" = 'team-northwind';
DELETE FROM "TeamUser"          WHERE "teamId" = 'team-northwind';
DELETE FROM "Team"              WHERE id = 'team-northwind';
DELETE FROM "OrganizationUser"  WHERE "organizationId" = 'org-auth0-legacy';
DELETE FROM "Organization"      WHERE id = 'org-auth0-legacy';
```

Nothing was reset, stopped or wiped; no application source was edited. Throwaway
driver scripts live in `/tmp/sso-run3/`.
