---
name: emil-design-eng
description: Design engineering review skill — Before/After/Why code review format, animation decision framework, component principles grounded in real-world physics
tags: [skill, design, review, animation, css]
---

# Emil Design Eng

Design engineering philosophy for code review and implementation guidance. Responds with structured `Before / After / Why` markdown tables. Grounded in real-world physics and user psychology — not aesthetic trends.

- **Type**: Claude Code skill
- **Invocation**: `Skill(emil-design-eng)` — ask a question or paste code to review
- **Source**: Cloned into `.claude/skills/emil-design-eng/`

## What It Does

Provides opinionated design engineering guidance across:

**Animation framework**
- Frequency: when motion adds vs. distracts
- Purpose: entrance, feedback, transition, ambient
- Easing: physics-based curves, not linear
- Duration: context-appropriate timing

**Component principles**
- Responsive buttons with touch targets
- Origin-aware popovers and tooltips
- Tooltip instant-open (no delay on hover)
- Drag interactions and gesture affordance

**CSS mastery**
- `clip-path`, 3D transforms, perspective
- Drag interactions
- Stacking context management

**Performance rules**
- `transform` and `opacity` only for animations
- Hardware acceleration via `will-change` (sparingly)
- Web Animations API (WAAPI) for imperative control

## Output Format

Reviews are returned as markdown tables:

```
| Before | After | Why |
|--------|-------|-----|
| ...    | ...   | ... |
```

## When to Use

- Reviewing UI code for animation quality and component architecture
- Getting a second opinion on CSS/motion decisions
- Understanding the reasoning behind a design choice, not just the fix

## Setup

Add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": ["Skill(emil-design-eng)"]
  }
}
```
