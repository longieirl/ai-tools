---
name: ui-ux-pro-max
description: Comprehensive design intelligence database — 67 styles, 96 colour palettes, 57 font pairings, 25 chart types, 13 tech stacks. Generates complete design systems via CLI or Claude plugin.
tags: [skill, design, ui, ux, design-system, plugin]
---

# UI/UX Pro Max

Comprehensive design intelligence database. Generates complete design systems with reasoning. Searchable by style, stack, colour, typography, chart type, and UX pattern.

- **Type**: Claude Code plugin (`ui-ux-pro-max@ui-ux-pro-max-skill`) or CLI (`npx uipro-cli`)
- **Invocation**: Via `Skill(ui-ux-pro-max)` or `python3 search.py <query> --design-system`
- **Source**: Plugin installed via Claude Code marketplace or `npx uipro-cli install`

## Coverage

| Category | Count |
|---|---|
| Design styles | 67 |
| Colour palettes | 96 |
| Font pairings | 57 |
| Chart types | 25 |
| Tech stacks | 13 |

## Search Domains

| Domain flag | What it returns |
|---|---|
| `--design-system` | Full system with reasoning |
| `--style` | Visual style recommendations |
| `--color` | Palette + accessibility checks |
| `--typography` | Font pairing + scale |
| `--landing` | Landing page patterns |
| `--chart` | Chart type selection |
| `--ux` | UX pattern library |
| `--react` | React-specific component guidance |
| `--product` | Product UI patterns |

## Priority Axes

Recommendations are ranked by: accessibility → touch targets → performance → layout → typography → animation → style → charts.

## Output

Optionally persists to `design-system/MASTER.md` and per-page overrides. Returns structured recommendations with rationale for each decision.

## When to Use

- Bootstrapping a design system for a new project
- Choosing between visual directions with objective criteria
- Auditing an existing system against best practices

## Setup

**As plugin** — add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": ["Read(/Users/<you>/.claude/plugins/cache/ui-ux-pro-max-skill/**)", "Skill(ui-ux-pro-max)"]
  },
  "enabledPlugins": {
    "ui-ux-pro-max@ui-ux-pro-max-skill": true
  }
}
```

**As CLI**:
```bash
npx uipro-cli install
python3 search.py "dark minimal SaaS" --design-system
```
