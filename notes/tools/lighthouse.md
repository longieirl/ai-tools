---
name: Lighthouse
description: Google's automated performance, accessibility, SEO, and best-practices auditing tool — runs via CLI or npx against any URL or local server
tags: [tool, performance, seo, accessibility, auditing]
---

# Lighthouse

Automated auditing for performance, accessibility, SEO, and best practices. Produces scored reports with actionable recommendations.

- **Source**: https://github.com/GoogleChrome/lighthouse
- **Install**: `npm install -g lighthouse` or use via `npx`
- **License**: Apache 2.0

## Audit Categories

| Category | What it checks |
|---|---|
| Performance | LCP, FID, CLS, TTFB, blocking resources |
| Accessibility | ARIA, contrast, keyboard nav, screen reader |
| Best Practices | HTTPS, console errors, deprecated APIs |
| SEO | Meta tags, canonical, robots, crawlability |
| PWA | Manifest, service worker, offline support |

## CLI Usage

```bash
npx lighthouse https://example.com --output html --view
npx lighthouse https://example.com --only-categories=performance,seo
npx lighthouse https://example.com --form-factor=mobile --throttling-method=devtools
```

## Output Formats

- `html` — visual report (open in browser)
- `json` — machine-readable, good for CI thresholds
- `csv` — for tracking scores over time

## When to Use

- Before/after performance optimisation work
- Pre-launch SEO and accessibility checklist
- CI gate to prevent score regressions

## Setup

Add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": ["Bash(npx lighthouse *)"]
  }
}
```
