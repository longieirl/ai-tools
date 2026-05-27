# CLAUDE.md — Base Template

This is the base CLAUDE.md for any project. Copy it, rename it `CLAUDE.md`, and extend the Project-Specific section at the bottom.

Use `@`-includes to pull this in from a shared location, or copy it directly into the project root.

---

## Git Conventions

Commit format: `type: description`

Types: `feat` | `fix` | `perf` | `chore` | `docs` | `refactor` | `test`

Examples:
- `feat: add booking confirmation email`
- `fix: correct mobile nav z-index`
- `chore: update dependencies`

Branch naming: `type/short-description` (e.g. `fix/mobile-nav`, `feat/contact-form`)

PRs require:
- 1 approving review
- Security scan pass (no secrets, no flagged vulnerabilities)
- All tests passing locally before push

Never push directly to `main`. Always work on a branch.

---

## Safety Rules

- Flag security issues before any other recommendation
- Never suggest inventing reviews, testimonials, or social proof
- Never use or recommend black-hat techniques (SEO, UX, or otherwise)
- Before making any change, verify it will work — check current documentation if uncertain
- Always test on mobile viewport before desktop
- Never modify production data or config without explicit instruction

---

## Accessibility

Target: WCAG 2.1 AA — zero violations acceptable.

- Minimum 44×44px tap targets on all interactive elements
- Descriptive alt text on all images (empty `alt=""` only for decorative images)
- Colour contrast: 4.5:1 for normal text, 3:1 for large text
- Heading hierarchy must be logical (no skipping levels)
- Skip links, visible focus styles, and keyboard navigation required
- Screen reader compatibility — test with VoiceOver or NVDA where possible

---

## Testing

Run before every push:

- Cross-browser: Chromium, Firefox, WebKit
- Responsive viewports: 390px (mobile), 768px (tablet), 1280px+ (desktop)
- Lighthouse thresholds (fail if below):
  - Performance ≥ 85
  - Accessibility ≥ 90
  - Best Practices ≥ 90
  - SEO ≥ 90

All tests must pass locally before opening a PR.

---

## Mobile-First Design

- Design and test mobile viewport first — desktop is the extension
- Prefer simple layouts, fast pages, and clear messaging over feature richness
- Avoid unnecessary animations, heavy JS, and render-blocking resources
- Images: WebP format preferred, always include descriptive alt text
- Core content must be accessible without JavaScript

---

## Output Format for Recommendations

When providing recommendations, structure output as:

1. **Summary** — one sentence on the overall finding
2. **Priority issues** — security, integrity, blockers first
3. **Quick wins** — low effort, high impact
4. **Recommended changes** — ordered by priority
5. **Expected impact** — what each change achieves
6. **Risks / assumptions** — what could go wrong or what was assumed

Priority sequence: security/integrity → blockers → mobile UX → core content → SEO fundamentals → trust signals → polish

---

## Web Projects — Schema & SEO (include if applicable)

- Use JSON-LD for all structured data — never RDFa or Microdata
- Validate schema via Google Rich Results Tester after every deploy that touches structured data
- When address, contact info, or hours change — revalidate live structured data immediately
- Use only schema.org types — no invented or deprecated types
- Target keywords must be used naturally — no keyword stuffing
- Do not recommend changes that could break checkout, booking, or payment flows without explicit sign-off

---

## Project-Specific (extend here)

Replace or append below with project-specific context:

```
## Project

[Project name and one-line description]

## Stack

[Framework, CMS, hosting, key dependencies]

## Key URLs

[Staging, production, admin panel if applicable]

## Domain Rules

[Any project-specific rules, constraints, or conventions]
```
