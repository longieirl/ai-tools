---
name: Playwright
description: Browser automation and testing framework — E2E tests, accessibility checks, cross-browser testing, responsive layout validation, screenshot capture
tags: [tool, testing, browser, accessibility, e2e]
---

# Playwright

Browser automation and end-to-end testing. Supports Chromium, Firefox, and WebKit. Used for E2E tests, accessibility audits, responsive layout checks, and screenshot capture.

- **Repo**: https://github.com/microsoft/playwright
- **Install**: `npm install -D playwright` or `pip install playwright`
- **License**: Apache 2.0

## Key Capabilities

| Use case | How |
|---|---|
| E2E tests | `test('…', async ({ page }) => { … })` |
| Accessibility | `@axe-core/playwright` integration |
| Cross-browser | Chromium, Firefox, WebKit in one run |
| Responsive | Set viewport per test |
| Screenshots | `page.screenshot()` |
| PDF export | `page.pdf()` |
| Network mocking | `page.route()` |

## Common Scripts (Python)

Used alongside Claude Code for automated QA:

```bash
python3 scripts/a11y-test.py        # accessibility audit
python3 scripts/cross-browser-test.py  # multi-browser run
python3 scripts/responsive-test.py  # viewport breakpoint checks
```

## Setup

```bash
npm install -D playwright
npx playwright install              # download browsers
npx playwright test                 # run tests
npx playwright show-report          # open HTML report
```

Add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": [
      "Bash(npx playwright *)",
      "Bash(playwright install *)",
      "Bash(python3 scripts/a11y-test.py)",
      "Bash(python3 scripts/cross-browser-test.py)",
      "Bash(python3 scripts/responsive-test.py)"
    ]
  }
}
```
