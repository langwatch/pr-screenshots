# Run 2 — Turn on directory provisioning (SCIM), end to end

Stack: `app.identity-sso.langwatch.localhost:1355`, IdP simulator tenant 1 (`acme1.test`).
Browser: Playwright Chromium 1.61.1, headless, 1440x900 @2x, light mode, `ignoreHTTPSErrors`.
Starting point: run 1's live OIDC connection `Acme Identity`, `ScimToken` empty.
Date on the machine: 2026-09-16.

## Screenshots, in the order a person sees them

| File | What it shows |
|---|---|
| `01-front-door-local-password.png` | The password form at `/auth/signin?local=1` — the only door left now SSO is live. |
| `02-authentication-overview-before-token.png` | **The known lie, confirmed.** Directory card: "Waiting for the first push / **The token is issued** and your provider pushes on its own schedule". `ScimToken` held **zero rows**. |
| `03-connectors-before-token.png` | Connectors, honest: "Not set up yet — No directory token has been issued for this connection." Directly contradicts the card on the previous screen. |
| `04-provisioning-tokens-empty.png` | The provisioning address and the empty token table. |
| `05-issue-token-dialog.png` | Issue dialog. One connection exists, so it is preselected (deliberate — `ConnectorsSection.tsx:185-201`). |
| `06-issue-token-dialog-filled.png` | Description "Acme Okta production" typed. |
| `07-token-issued-shown-once.png` | **The token, in the clear, once.** "Copy this token now. It is shown once and never again." Honest: a `readonly type=text` input with a copy button, no footer, no second chance. |
| `08-token-in-table-value-gone.png` | Reloaded: the value is gone for good — and the banner already says **"Sync has ended / The token for this connection was revoked"** about the token issued 30 seconds earlier. |
| `09-connectors-after-push.png` | After three `POST /Users`: "People this directory manages 3", three "was given access" rows — beside "Last push from the directory: **No push yet**" and the same false revoked banner. |
| `10-request-log-expanded.png` | "Show what your identity provider sent" — every request with a verdict, including the 409 rendered as "Refused / That would collide with something already here". The best surface on the page. |
| `11-directory-after-push.png` | Directory: Sources card, "People it manages 3", "Groups it sent 1", the three new people badged `Directory`. |
| `12-directory-groups-tab.png` | The pushed group: "Engineering (EMEA) · **SCIM** · 3 people · No role assigned". |
| `13-authentication-overview-after-token.png` | **The same card after a real token and three real pushes**: still "Waiting for the first push / The token is issued", now escalated to "Needs attention". Wrong before, wrong after. |
| `14-idp-provision-panel-before-connect.png` | The IdP simulator's "Provision into LangWatch" harness. |
| `15-idp-provision-panel-filled.png` | LangWatch's provisioning address and the issued token pasted in. |
| `16-idp-connected-to-langwatch.png` | Connected: "With the token 4d1886…8156". |
| `17-idp-connected-ready-to-sync.png` | "Sync the difference" — creates for arrivals, deactivations for departures. |
| `18-idp-first-sync-result.png` | **"Last change: 1 created and 4 deactivated."** One of the four was `admin@haven.localhost`, the organization's only administrator. |
| `19-admin-session-after-directory-deactivated-them.png` | The administrator's live session, one navigation later: 401 and thrown out to the provider's account picker. |
| `20-break-glass-signin-attempt.png` | The break-glass door, correct address and correct password. |
| `21-break-glass-refused-after-directory-deactivation.png` | **"Failed to create session."** The organization is now locked out of itself, and the sentence names no cause and offers no remedy. |
| `22-connectors-after-deprovision.png` | After the deactivations: Dana and Eli carry a **Deactivated** badge and stay listed — but "Recent changes" holds **only "was given access" rows**. Four removals, none recorded. |
| `23-directory-after-deprovision.png` | Directory still counts them: "Everybody 6 / Members 6 / Team Members 6 of 100". |
| `24-connectors-after-delete-lost-access.png` | After a `DELETE /Users/:id` instead: **"Removed — Cass Contractor lost access"** appears and the row leaves. The list works; `active:false` never reaches it. |
| `25-member-signed-in-before-deprovision.png` | `member@acme1.test` signing in through the provider, inside the organization — the access baseline. |
| `26-idp-churn-deactivate-one.png` | The provider's own churn controls, Deactivate set to 1. |
| `27-idp-after-deactivate-sync.png` | The provider changed nothing ("directory.churn — nothing changed") and the sync still reported "1 deactivated": **it locked the administrator out a second time.** |
| `28-legacy-scim-address-forwards.png` | `/settings/scim` forwards to `/settings/directory` — not to the screen that holds the tokens. |
| `29-what-revoking-a-token-stops.png` | The disclosure: "Each token … **can only touch the people that connection provisioned**". Not true. |
| `30-authentication-overview-final.png` | End state: ~25 SCIM requests, 4 people provisioned, 1 group, 5 removals later — "Waiting for the first push". |

## What actually happened

The flow completes. A token is issued and shown once, an identity provider is
pointed at `/api/scim/v2` with nothing but that token and the address, and it
creates people, creates a group, updates membership and removes people — all
from the provider side, nobody signing in. The Connectors request log is
excellent and the people list is accurate.

Three things went wrong around it.

**The provisioning token can write to anybody in the organization.** The first
sync from the provider deactivated `admin@haven.localhost` — the administrator
who registered the connection, holds the break-glass grant and was provisioned
by nobody. It killed the live session and refused the password login. The only
way back in was a hand-written SCIM call; there is no screen for it. A second
sync did it again. The screen that hands out the token promises the opposite in
as many words.

**A deprovision is half a deprovision.** `active:false` — which the simulator's
own copy calls "what most identity providers actually send for somebody who has
left" — stamps `User.deactivatedAt` and stops there. Sign-in is refused, which
is real. But the `OrganizationUser` row survives with its role, the `member`
grant survives un-revoked, the seat is still counted, and the product's change
log never records that anyone left. `DELETE /Users/:id` does the whole job.

**Rotating a token permanently breaks the status.** Revoke-then-issue — the exact
remedy the page recommends for a leaked token — leaves the sync projection stuck
in REVOKED for good, so the connection reports "Sync has ended" and "No push yet"
forever while provisioning works fine underneath.

## Problems, worst first

1. **A SCIM token can deactivate anyone in the organization, including the only
   administrator.** `platform/app/ee/scim/scim-directory-identity.service.ts:118`
   — `if (claims.length === 0) return;`. The guard only stops one directory
   writing to another directory's people; anybody with no directory identity at
   all is writable by any token. Reproduced twice. Recovery needed a hand-written
   `PATCH active:true`. `GET /Users` has the same reach — it returns the whole
   organization.
2. **`active:false` leaves access behind.** `platform/app/ee/scim/scim.service.ts:780-796`
   — the whole removal is inside `if (scimGrantsWritePathEnabled())`, and
   `SCIM_V2_GRANTS` defaults to `off` (`platform/app/src/env-create.mjs:420`,
   `ee/scim/scim-grants-flag.ts:26`). On the default configuration a leaver keeps
   membership and an un-revoked `member` grant. **Feature-flag dependency — not
   self-serve.**
3. **No removal is ever recorded on the default configuration.** The change list
   reads revoked grants (`scim-reconciliation.prisma.repository.ts:217`), and with
   the flag off no grant is revoked by `active:false`, so the audit surface is
   add-only. `DELETE` produces the row (screenshot 24); the verb every provider
   actually sends does not.
4. **Revoking a token bricks the connection's status permanently.**
   `packages/identity/src/scim-sync.ts:345` — `if (state.state === "REVOKED") return touched;`
   sits before the switch, so `scim_token_issued` cannot clear it. Then
   `packages/identity-server/src/scim-sync-guards.ts:97` and `:118` drop every
   push and group mapping while REVOKED, so `lastPushedAt` can never be written
   again. The only writer that could move it is `redriveScimApply`, described in
   `pipelines/scim-sync/pipeline.ts:58-64` as a **platform operator** action.
   **Staff-operator dependency — not self-serve.**
5. **`PATCH` with a scalar value is accepted and discarded.**
   `platform/app/ee/scim/scim.service.ts:942` — `if (operation.value == null || typeof operation.value !== "object") continue;`.
   `{"op":"replace","path":"name.familyName","value":"Smith"}` — the shape Okta
   and Entra send for a profile change — returns 200 with the old record, and the
   request log files it as "Accepted". An unknown path is 200 too, where RFC 7644
   wants `invalidPath`. `PUT` works. Group PATCH works.
6. **A malformed PATCH corrupts the name instead of refusing it.**
   `{"op":"replace","value":{"name.familyName":"X"}}` set givenName to `X` and
   familyName to empty (200). Names round-trip through one `User.name` string.
7. **The Authentication Overview's Directory card is decorative.** `DirectoryCard.tsx:232-244`
   says "The token is issued" with no token, and "Waiting for the first push"
   after 25 pushes. Its input is the same broken projection. Screenshots 02 and 13
   are the identical sentence in opposite worlds.
8. **The Connectors banner contradicts the table beneath it.** "Sync has ended /
   The token for this connection was revoked" sat directly above a live token and
   a working directory for the whole run (screenshots 08, 09, 22, 24).
9. **`/api/scim/v2` accepts people on unverified domains.** `contractor@other.example`
   was created 201 into an organization whose arrival policy is "they join, on a
   domain you verified". Defensible — the provider asserted it — but nothing in
   the product says the directory ignores that policy.
10. **The lockout message is unhelpful.** "Failed to create session." names no
    cause. An account deactivated by the directory is exactly the knowable failure
    that should carry its own code and remediation.
11. **Removal is not reflected in seats.** Directory counts "Members 6 / Team
    Members 6 of 100" with three of them deactivated by the provider.
12. **Groups are invisible on Connectors.** The pushed group appears on Directory
    ("Groups it sent 1", the Groups tab) and nowhere on the screen the provider is
    pointed at.
13. **`SCIM` leaks into customer copy.** The group badge reads `SCIM` where the
    rest of the surface says "your identity provider" (Directory → Groups).
14. **React hydration error on every dialog open.** `ConnectorsSection.tsx:445-447`
    and `:629-631` put a `<Heading>` (`h2`) inside `<Dialog.Title>` (`h2`):
    "`<h2>` cannot contain a nested `<h2>`. This will cause a hydration error."
15. **Minor.** `/settings/scim` forwards to `/settings/directory`, not to the
    Connectors page that holds the tokens. The issued-token dialog leaks `value=`
    and `label=` onto a wrapper `<div>`, so the raw token also renders as a DOM
    attribute. `joinRequests.offer` answered 429 during ordinary navigation.

## Does a deprovision end access?

**Partly, and it depends on the verb.**

- `DELETE /Users/:id` — yes. Membership row deleted, `member` grant revoked,
  `deactivatedAt` stamped, row leaves the directory list, "lost access" recorded.
- `PATCH active:false` / `PUT active:false` — **no, not fully.** Sign-in is
  refused and the live session dies immediately (proved end to end: screenshots
  19 and 21). But the `OrganizationUser` row and the `member` grant both survive
  un-revoked, the seat is still counted, and no removal is recorded anywhere.
  It is more than hiding a row and less than ending access.

Nothing is hidden: a deactivated person stays visible with a **Deactivated**
badge on both Connectors and Directory. That part is right.

## State left behind

**⚠ First, the trap.** The IdP simulator at `https://idp.identity-sso.langwatch.localhost:1355/t/1`
is **still connected** to LangWatch's SCIM endpoint. **Any press of "Sync the
difference" or "Push everything" there will deactivate `admin@haven.localhost`
and lock you out of the administrator account.** Either press **Forget** in the
simulator's "Provision into LangWatch" panel first, or keep this recovery to hand:

```bash
curl -sk -X PATCH \
  https://app.identity-sso.langwatch.localhost:1355/api/scim/v2/Users/local-dev-admin-user \
  -H "Authorization: Bearer 4d1886adc6a46a0e34b638b0a99efd92a3eb1906054378bb658ddf92280e8156" \
  -H 'Content-Type: application/scim+json' \
  -d '{"schemas":["urn:ietf:params:scim:api:messages:2.0:PatchOp"],"Operations":[{"op":"replace","path":"active","value":true}]}'
```

- **Provisioning token** (the only copy — the UI will not show it again):
  `4d1886adc6a46a0e34b638b0a99efd92a3eb1906054378bb658ddf92280e8156`,
  described "Acme Okta production", scoped to `ssoc_selfserve_0787f02a11a49958cc2b4672`.
  One `ScimToken` row.
- **`ScimSyncState` is stuck REVOKED** and will not recover. Every Directory /
  Connectors surface will keep saying "Sync has ended" and "No push yet".
- **Users (6).** `admin@haven.localhost` (Admin, **active**, reactivated by hand
  twice) · `member@acme1.test` Mel Member (Member, active) · `admin@acme1.test`
  Ada Admin (Member — the sync **adopted** run 1's orphan into the organization) ·
  `dana.director@acme1.test` (Member, **deactivated**) · `eli.engineer@acme1.test`
  (Member, **deactivated**) · `contractor@other.example` (**no membership** —
  removed by `DELETE`, `User` row remains deactivated).
- **Group** `Engineering (EMEA)`, external id `okta-grp-eng`, source `scim`,
  3 memberships, no role assigned.
- **Grants** with `source = scim`: 4 rows, one revoked (Cass), three live.
- The SSO connection, proved domain, arrival policy and break-glass grant from
  run 1 are untouched. The connection is still **Active**.
- The IdP simulator lost run 1's registered application and published TXT record
  to a restart; neither matters (it accepts any client id, the domain is already
  proved in LangWatch).
- Nothing was reset, stopped or wiped. No application source was edited.
  Throwaway driver scripts live in `/tmp/scim-run2/`.
