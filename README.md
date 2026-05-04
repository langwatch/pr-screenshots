# langwatch/pr-screenshots

Permanent storage for PR screenshots and dogfood evidence referenced inline from `langwatch/langwatch` PR descriptions.

## Why this exists

PR descriptions in `langwatch/langwatch` reference screenshots inline via `![](url)` markdown. Hosting these in the main repo bloats blob storage (image bytes are a tiny portion of useful product code); third-party CDNs like `img402.dev` have 7-day retention that link-rots within weeks. This org-controlled repo gives PR descriptions permanent `raw.githubusercontent.com` URLs that survive the lifetime of the PR and the merged history.

## Layout convention

```
pr-screenshots/
├── pr-<number>/
│   ├── <path-mirror-from-source-repo>/
│   │   └── <screen>.png
│   └── ...
└── README.md
```

Mirror the source-repo path under each PR's own folder so URLs in the source PR description map cleanly:

```markdown
![Persona-4 admin governance overview](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-3524/persona-x-flow/admin/governance/01-overview-toplevel.png)
```

## Adding screenshots for a new PR

```bash
gh repo clone langwatch/pr-screenshots
cd pr-screenshots
mkdir -p pr-<number>/<your-path>
cp /path/to/screenshot.png pr-<number>/<your-path>/
git add pr-<number>
git commit -m "pr-<number>: <short description>"
git push origin main
```

Then in your source-repo PR description:

```markdown
![caption](https://raw.githubusercontent.com/langwatch/pr-screenshots/main/pr-<number>/<your-path>/screenshot.png)
```

GitHub renders this inline in the PR body.
