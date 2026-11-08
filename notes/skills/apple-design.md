---
name: apple-design
description: Apple-style interface design skill — fluid physical motion, interruptible spring animations, direct manipulation, translucent materials, typography, and accessibility for the web
tags: [skill, design, animation, motion, apple, accessibility]
---

# Apple Design

Apple's approach to interface design and fluid, physical motion, translated for the web. Covers gesture-driven UI, interruptible spring animations, direct manipulation, momentum, translucent materials and depth, typography, and reduced-motion support.

- **Type**: Claude Code skill
- **Invocation**: `Skill(apple-design)` — describe the UI to build or paste code/site to audit
- **Author**: [emilkowalski](https://github.com/emilkowalski)
- **Source**: https://github.com/emilkowalski/skills (`skills/apple-design/`)
- **Install**: `npx skills add emilkowalski/skills` (same repo as [emil-design-eng](emil-design-eng.md))
- **Releases**: none published — track `main`

## What It Does

Opinionated guidance for Apple-grade motion and interface craft:

**Response & feedback**
- Eliminate latency; highlight on pointer-down, not release
- Continuous feedback during interaction, not just at completion

**Direct manipulation**
- Pointer Events + `setPointerCapture`, track 1:1 with input, respect grab offset

**Interruptibility** — the single most important principle
- Animations reversible mid-flight; animate from current (presentation) values, never targets
- Avoid CSS transitions for gesture-driven work; use springs that carry velocity through re-targeting

**Springs over fixed animations**
- Think damping ratio (1.0 = no bounce, <1.0 = bounce) and response (seconds to target)
- Defaults: damping 1.0, response 0.3–0.4 for most UI; damping ~0.8 for momentum

**Velocity handoff & momentum projection**
- Pass release velocity into spring to remove the drag→animate seam
- Project resting position from velocity before snapping to nearest boundary (throw feel)

**Spatial consistency**
- Enter/exit along identical paths; anchor to source; mirror easing on reversible transitions

**Boundaries**
- Rubber-banding (progressive resistance), not hard stops

**Materials & depth**
- `backdrop-filter: blur()` for translucent layers; encode hierarchy through material weight; keep vibrancy and legibility over blur

**Typography**
- Size-specific tracking: tighten large text (`-0.02em`), body near `0`; leading tracks inversely with size; hierarchy from weight + size + leading as a set

**Accessibility**
- `prefers-reduced-motion: reduce` → cross-fades or static transitions
- Respect `prefers-reduced-transparency: reduce` and `prefers-contrast: more`

**Eight design principles**: Purpose, Agency, Responsibility, Familiarity, Flexibility, Simplicity, Craft, Delight.

## Example: audit a site

```
Use apple-design to audit the new portal site. Review input feedback, interruption,
release velocity, boundaries, spatial consistency, materials, typography and accessibility.
Rank issues by user impact and show the evidence. Propose the smallest useful changes,
then explain how to test them. Keep existing behavior that already works.
```

## When to Use

- Building gesture/drag/sheet/swipe interactions that must feel native
- Auditing a UI for motion quality — interruption, velocity, spatial consistency
- Getting translucent materials, depth, and typography to Apple-grade polish

## Setup

Add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": ["Skill(apple-design)"]
  }
}
```
