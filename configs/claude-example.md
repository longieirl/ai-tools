# CLAUDE.md — Base Template

Base CLAUDE.md for any project. Copy it, rename to `CLAUDE.md`, extend the Project-Specific section at the bottom.

Behavioral guidelines (sections 1–4) adapted from [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md). Project standards (sections 5–10) distilled from common patterns across projects.

---

## 1. Think Before Coding

Before implementing:
- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

---

## 2. Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "configurability" that wasn't requested
- No error handling for impossible scenarios
- If you write 200 lines and it could be 50, rewrite it

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

---

## 3. Surgical Changes

Touch only what you must. Clean up only your own mess.

When editing existing code:
- Don't improve adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it — don't delete it

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked

Every changed line should trace directly to the user's request.

---

## 4. Goal-Driven Execution

Define success criteria. Loop until verified.

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
```

---

## 5. Git Conventions

Commit format: `type: description`

Types: `feat` | `fix` | `perf` | `chore` | `docs` | `refactor` | `test`

Branch naming: `type/short-description` (e.g. `fix/mobile-nav`, `feat/contact-form`)

If working on a GitHub issue, include the issue ID: `type/123-short-description` (e.g. `fix/42-mobile-nav`, `feat/17-contact-form`)

PRs require:
- 1 approving review
- Security scan pass (no secrets, no flagged vulnerabilities)
- All tests passing locally before push

Never push directly to `main`. Always work on a branch.

---

## 6. Safety Rules

- Flag security issues before any other recommendation
- Never suggest inventing reviews, testimonials, or social proof
- Never use or recommend black-hat techniques (SEO, UX, or otherwise)
- Before making any change, verify it will work — check current docs if uncertain
- Always test on mobile viewport before desktop
- Never modify production data or config without explicit instruction

---

## 7. Accessibility

Target: WCAG 2.1 AA — zero violations acceptable.

- Minimum 44×44px tap targets on all interactive elements
- Descriptive alt text on all images (`alt=""` only for decorative images)
- Colour contrast: 4.5:1 for normal text, 3:1 for large text
- Heading hierarchy must be logical (no skipping levels)
- Skip links, visible focus styles, and keyboard navigation required

---

## 8. Testing

Run before every push:

- Cross-browser: Chromium, Firefox, WebKit
- Responsive viewports: 390px (mobile), 768px (tablet), 1280px+ (desktop)
- Lighthouse thresholds (fail if below):
  - Performance ≥ 85
  - Accessibility ≥ 90
  - Best Practices ≥ 90
  - SEO ≥ 90

---

## 9. Mobile-First Design

- Design and test mobile viewport first — desktop is the extension
- Prefer simple layouts, fast pages, clear messaging
- Avoid unnecessary animations, heavy JS, render-blocking resources
- Images: WebP preferred, always descriptive alt text
- Core content must work without JavaScript

---

## 10. Output Format for Recommendations

1. **Summary** — one sentence on the overall finding
2. **Priority issues** — security, integrity, blockers first
3. **Quick wins** — low effort, high impact
4. **Recommended changes** — ordered by priority
5. **Expected impact** — what each change achieves
6. **Risks / assumptions** — what could go wrong or what was assumed

Priority: security/integrity → blockers → mobile UX → core content → SEO fundamentals → trust signals → polish

---

## 11. Web Projects — Schema & SEO

Include this section for web/CMS projects. Remove for backend, CLI, or library projects.

- Use JSON-LD for all structured data — never RDFa or Microdata
- Validate schema via Google Rich Results Tester after every deploy that touches structured data
- When address, contact info, or hours change — revalidate live structured data immediately
- Use only schema.org types — no invented or deprecated types
- Target keywords naturally — no keyword stuffing
- Never break checkout, booking, or payment flows without explicit sign-off

---

## Project-Specific

Extend below with project-specific context:

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
