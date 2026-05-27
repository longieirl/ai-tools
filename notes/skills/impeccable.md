---
name: impeccable
description: Production-grade frontend interface design skill for Claude Code — craft, audit, and iterate UI with committed design choices
tags: [skill, ui, design, frontend]
---

# Impeccable

Design and iterate production-grade frontend interfaces with committed, opinionated design choices.

- **Type**: Claude Code skill
- **Invocation**: `Skill(impeccable)` or `npx impeccable <subcommand>`
- **Source**: Installed via `npx impeccable` or cloned into `.claude/skills/impeccable/`

## What It Does

Loads design context files (`PRODUCT.md`, `DESIGN.md`) before any work, identifies the design register (brand vs. product), and applies shared design laws around color, theme, typography, layout, motion, and copy. Produces real, working code — not mockups. Avoids AI-default slop patterns (generic shadows, neon glows, center-bias layouts).

## Subcommands

| Command | What it does |
|---|---|
| `craft` | Build a new component or page from scratch |
| `shape` | Reshape an existing component |
| `audit` | Review current implementation against design laws |
| `polish` | Final pass — tighten spacing, motion, copy |
| `animate` | Add or improve motion |
| `colorize` | Apply or refine color system |
| `bolder` | Push the design further — more presence |
| `quieter` | Pull back — reduce visual noise |

## When to Use

- Building new UI components that need production quality
- Auditing existing interfaces for design consistency
- Iterating on visual design without starting from scratch

## Setup

```bash
npx impeccable install    # install into current project
git config core.hooksPath .github/hooks  # if using shared hooks
```

Add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": ["Bash(npx impeccable *)", "Skill(impeccable)"]
  }
}
```
