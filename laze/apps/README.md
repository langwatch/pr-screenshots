# Laze apps platform, live proof (2026-10-14)

App "Support tracker" (public) at https://support-tracker--acme-support-9e9856.rchaves.app,
served by the laze-apps host on rchaves-platform, opened in headless Chromium.

1. `1-v1-published.png`: version 1ebe61e published after approval; tickets come from the
   records API, the theme from `/_laze/theme.css`; the CSP blocked a fetch to api.github.com.
2. `2-ticket-created-in-browser.png`: a ticket created through the form (POST to the records API).
3. `3-v2-broken-published.png`: a broken version dcf2376 published.
4. `4-reverted-published.png`: revert to 1ebe61e made version a4119cf, published; data kept.
5. `headers.txt`: CSP and isolation headers, the draft sign-in redirect to Laze, a cross-site
   API call refused.
