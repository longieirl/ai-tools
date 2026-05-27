---
name: taste-skill
description: Metric-based UI/UX engineering skill — strict component architecture, no AI-slop patterns, production React/Next.js with Tailwind and Framer Motion
tags: [skill, ui, design, frontend, react]
---

# Taste Skill

Senior UI/UX engineering with metric-based rules and strict component architecture. Produces high-agency implementations with intentional design decisions.

- **Type**: Claude Code skill
- **Invocation**: `Skill(taste-skill)` — no subcommands, describe what you want built
- **Source**: Cloned into `.claude/skills/taste-skill/`

## What It Does

Operates at three configurable baseline levels:

| Axis | Range | Default |
|---|---|---|
| Design variance | 1–10 | Medium |
| Motion intensity | 1–10 | Medium |
| Visual density | 1–10 | Medium |

Generates production-ready React/Next.js with Tailwind v3/v4, hardware-accelerated animations via Framer Motion, and perpetual micro-interactions in isolated client components.

**Avoids:** neon glows, oversaturated gradients, center-bias layouts, generic card shadows, decorative spinners, icon overuse.

## Output Characteristics

- Isolated client components with clear server/client boundaries
- Hardware-accelerated CSS (`transform`, `opacity` only for animations)
- Framer Motion for complex gesture/transition work
- Tailwind utility classes — no custom CSS unless unavoidable
- Accessible markup (ARIA, keyboard nav) by default

## When to Use

- Building React/Next.js UI where default AI output looks generic
- When you need strong design opinions applied consistently across components
- Reviewing existing components for design quality issues

## Setup

Add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": ["Skill(taste-skill)"]
  }
}
```
