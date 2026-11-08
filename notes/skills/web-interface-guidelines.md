---
name: web-interface-guidelines
description: Vercel's Web Interface Guidelines — a rule set for interaction, accessibility, typography, and layout that an agent audits UI against before shipping
tags: [skill, ui, design, accessibility, guidelines, vercel]
---

# Web Interface Guidelines (Vercel)

A concise, opinionated rule set for building high-quality web interfaces. Used as a reference an agent can audit code against — flags interaction, accessibility, typography, and layout issues before you ship.

- **Type**: Guidelines / agent reference (usable as a skill or AGENTS rule)
- **Repo**: https://github.com/vercel-labs/web-interface-guidelines
- **Published**: https://vercel.com/design/guidelines
- **License**: see repo

## What It Covers

- Interactivity — hit targets, focus states, keyboard support, hover/active feedback
- Accessibility — semantic HTML, ARIA, contrast, reduced motion
- Typography — scale, line length, rhythm
- Layout — spacing, alignment, responsive behaviour
- Forms, state, and feedback patterns

## When to Use

- Auditing a UI diff against a documented, external rule set
- Catching accessibility and interaction gaps default AI output misses
- Giving an agent a shared definition of "good enough to ship"

## Setup

Point an agent at the guidelines as a reference. Clone or copy the ruleset into your project (e.g. `.claude/skills/`), or reference the published URL directly. No install required to read the guidelines.
