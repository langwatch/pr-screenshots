# Run 1 — Activate single sign-on, self-serve, end to end

Stack: `app.identity-sso.langwatch.localhost:1355`, IdP simulator tenant 1 (`acme1.test`).
Browser: Playwright Chromium 1.61.1, headless, 1440x900 @2x, light mode, `ignoreHTTPSErrors`.
Date on the machine: 2026-09-16.

## Screenshots, in the order a person sees them

| File | What it shows |
|---|---|
| `01-front-door-signin.png` | The front door before any connection exists — identifier-first, email + passkey. |
| `02-front-door-email-typed.png` | `admin@haven.localhost` typed. |
| `03-front-door-password-step.png` | Password step. Note the unasked-for banner "That passkey isn't one we recognize". |
| `04-signed-in-home.png` | Signed in; a passkey nudge modal sits over the home screen. |
| `05-settings-authentication.png` | Settings → Authentication → Overview. Single sign-on "Not set up", "Set it up". |
| `06-sso-setup-start.png` | Step 1 — vendor tiles and the protocol row. |
| `07-oidc-form-empty.png` | OpenID Connect chosen; the redirect address with the `{connection}` placeholder, and the four fields. |
| `08-idp-tenant-before-register.png` | IdP simulator tenant 1, before registering an application. |
| `09-idp-register-form-filled.png` | Name + redirect address (with `{connection}` verbatim) filled at the IdP. |
| `10-idp-app-registered.png` | The IdP hands back client id `idpsim-t1-25a2bde6` and a secret. |
| `11-oidc-form-filled-bad-issuer.png` | Deliberate wrong issuer (`/t/9`) before pressing Register. |
| `12-oidc-issuer-unreachable-error.png` | **Non-happy path.** "That address did not answer as an identity provider", with remediation and a Copy error ID. Good. |
| `13-oidc-form-filled-good.png` | Corrected issuer `/t/1`. |
| `14-connection-registered.png` | Connection registered — the six-step journey appears, "Being set up". |
| `15-claim-domain-empty-refused.png` | **Non-happy path.** Claim pressed with an empty domain field: a card-level "Check your input / Some of the values aren't valid", nothing marked on the field. |
| `16-domain-claimed-record-to-publish.png` | `acme1.test` claimed, "Not proved yet", "Prove this domain". |
| `17-prove-domain-record-shown.png` | The TXT record: `_langwatch-verification.acme1.test` and a value shown once. |
| `18-check-record-not-found.png` | **Non-happy path.** Checked before publishing: "We couldn't find that record yet". |
| `19-idp-publish-record-filled.png` | The record pasted into the IdP simulator's DNS panel. |
| `20-idp-record-published.png` | Published and answering on the simulator's resolver. |
| `21-domain-proved.png` | "acme1.test proved / Done". |
| `22-step3-account-not-on-domain-warning.png` | Step 3's warning: "Your account is not on this connection's domain" + "three ways forward". |
| `23-idp-account-picker.png` | The IdP account picker reached from Test sign-in. |
| `24-test-signin-wrong-address-refused.png` | **Non-happy path.** Refused as `sso_setup_address_mismatch` — but rendered as the generic "Something went wrong signing you in". |
| `25-security-linked-accounts.png` | Settings → Security, the addresses this account is known by. |
| `26-add-email-address-dialog.png` | The "add the address your provider uses" route step 3 suggests — needs a confirmation email, so it is closed on this stack. |
| `27-break-glass-form-filled.png` | Step 4, administrator chosen and the end date set to 30/10/2026. |
| `28-break-glass-granted.png` | Step 4 after granting. |
| `29-break-glass-grant-table.png` | The grants table: **October 30, 2026**, 45 days left, Extend / End now. Date matches the one picked. |
| `30-arrival-policy-chosen.png` | Step 5, "They join, on a domain you verified" selected, Save/Cancel revealed. |
| `31-policy-saved-step6.png` | Policy saved and written to the event log. |
| `32-step3-before-second-attempt.png` | Step 3 still showing the same warning after steps 4 and 5 — which is when the sign-in actually works. |
| `33-test-signin-lands-on-onboarding.png` | **The test sign-in worked and dumped the administrator into "Let's kick off by creating your organization", signed in as `admin@acme1.test`.** |
| `34-back-at-front-door-as-admin.png` | Signing back in as the administrator. |
| `35-setup-after-test-signin.png` | Step 3 now "Worked on 9/16/2026, 9:43:45 PM"; step 6 offers "Go live". |
| `36-step6-go-live-ready.png` | Step 6 with all three preconditions Done. |
| `37-connection-live-top.png` | **Active.** All six steps ticked. |
| `38-connection-live-danger-zone.png` | Danger zone on a live connection — removal with its grace period, no phantom "turn it off". |
| `39-authentication-overview-live.png` | Overview with the connection Active, "Sign-in: Everybody", "Verified domains: acme1.test · Proved". |
| `40-front-door-handed-to-provider.png` | **The front door now hands every visitor straight to the provider, with nothing typed.** |
| `41-routed-signin-landing.png` | **`member@acme1.test` comes back signed in, inside Local Dev Organization.** The acceptance test. |
| `42-break-glass-door-local1.png` | The password form, reachable only at `/auth/signin?local=1`. |
| `43-break-glass-signed-in.png` | The break-glass holder signed in with a password while SSO is live. |
| `44-directory-after-signins.png` | Directory: 2 members — Haven Local Admin, Mel Member. |

## What actually happened

The setup journey completed and the connection went live. A person on the proved
domain who had never existed in LangWatch typed nothing at all, was handed to the
provider, and came back signed in as a member of the organization.

Two things about the middle of it:

**Step 3 could not be finished the way the screen described, and finished anyway.**
The IdP for `acme1.test` can only assert `admin@acme1.test` or `member@acme1.test`;
the registering account is `admin@haven.localhost`. Step 3's notice offers three ways
forward and all three are wrong or closed: signing in as `admin@haven.localhost` is
impossible at that provider, adding the other address needs a confirmation email, and
"verify the domain" was already done. What actually unlocks it is
`SsoAssertionService.setupIsComplete` — a proved domain *plus* a decided arrival policy
*plus* a live break-glass grant. Doing steps 4 and 5 first made the identical press
succeed. No screen says so.

**The successful test sign-in replaced the administrator's session.** It signed the
browser in as Ada Admin and landed on the organization-bootstrap wizard. The codebase
has a screen built precisely to prevent that (`/auth/sso-test-complete`), and it was
never reached, because the query that routes to it 500s.

## State left behind

- **Organization `Local Dev Organization`** now has a **live** OIDC connection
  `Acme Identity`, id `ssoc_selfserve_0787f02a11a49958cc2b4672`,
  issuer `https://idp.identity-sso.langwatch.localhost:1355/t/1`,
  client id `idpsim-t1-25a2bde6`.
- Proved domain **`acme1.test`** (DNS TXT).
- Break-glass grant: **Haven Local Admin, until October 30, 2026**.
- Arrival policy: **"They join, on a domain you verified"**.
- Users: `admin@haven.localhost` (Admin) · `member@acme1.test` "Mel Member"
  (Member, arrived through SSO) · **`admin@acme1.test` "Ada Admin", 0 organizations**
  — an orphan created by the setup's own test sign-in.
- IdP simulator tenant 1 now holds a registered application
  "LangWatch — Local Dev Organization" and a published TXT record
  `_langwatch-verification.acme1.test`.
- **For the next runs:** `https://app.identity-sso.langwatch.localhost:1355/auth/signin`
  now bounces every visitor to the IdP. To reach the password form, use
  **`/auth/signin?local=1`**.
- Nothing was reset, stopped, or deleted. No application source was edited.
  Throwaway driver scripts live in `/tmp/sso-run1/`.
