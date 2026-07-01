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

## GIFs

GIFs are welcome for animated evidence (e.g. `prove-them-wrong --gif`) — same layout, naming, and URL shape as screenshots; GitHub renders a `.gif` inline via `![](url)` exactly like a `.png`. One gif per claim, with the whole transition in the name:

```
pr-<number>/<your-path>/01-<claim-transition>.gif
```

Keep them light so the repo and PR pages stay fast:

- ≤ 5 MB per gif
- ≤ 1280px wide
- ~1–2 fps for state-transition flows (`-loop 0`)

Build from a sequence of stills with ffmpeg (palette 2-pass keeps UI text crisp):

```bash
ffmpeg -framerate 1.5 -pattern_type glob -i '*.png' -vf "scale=1280:-1:flags=lanczos,palettegen" -y /tmp/pal.png
ffmpeg -framerate 1.5 -pattern_type glob -i '*.png' -i /tmp/pal.png -lavfi "scale=1280:-1:flags=lanczos[x];[x][1:v]paletteuse" -loop 0 01-flow.gif
```
