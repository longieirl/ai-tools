---
name: mattpocock-skills
description: Claude Code plugin — Matt Pocock's engineering and productivity skills for real development work
tags: [skill, plugin, engineering, tdd, code-review, grilling, domain-modeling]
---

# mattpocock-skills

24 engineering and productivity skills built for daily engineering work. Designed to be small, composable, and model-agnostic. Fixes common failure modes: misaligned requirements, missing tests, poor review coverage.

- **Type**: Marketplace plugin (Claude Code official marketplace)
- **Source**: https://github.com/mattpocock/skills
- **Docs**: https://aihero.dev/skills-*

## Install

```bash
claude plugins install mattpocock-skills
```

Or from inside a session:

```
/plugin install mattpocock-skills
```

In the official marketplace — nothing to add first, updates arrive automatically.

After install, run `/setup-matt-pocock-skills` once per repo. Configures issue tracker (GitHub, Linear, or local files), triage labels, and docs output location.

## Skills

### Engineering (user-invoked)

| Skill | What it does |
|---|---|
| `/ask-matt` | Router — maps all user-reachable skills and when to reach for each |
| `/code-review` | Two-axis review (Standards + Spec) via parallel sub-agents against a fixed point |
| `/tdd` | Test-driven development loop — write failing test, implement, repeat |
| `/diagnosing-bugs` | Systematic bug diagnosis — reproduce, isolate, root-cause |
| `/domain-modeling` | Model the business domain before coding |
| `/codebase-design` | Design the structure of a new or evolving codebase |
| `/prototype` | Build a throwaway prototype to validate an idea |
| `/research` | Research a topic and produce a structured findings report |
| `/resolving-merge-conflicts` | Guided merge conflict resolution |
| `/implement` | Implement a spec or ticket |
| `/to-spec` | Convert a rough idea into a formal spec |
| `/to-tickets` | Break a spec into discrete tickets |
| `/triage` | Triage incoming issues and apply labels |
| `/improve-codebase-architecture` | Identify and plan architectural improvements |
| `/wayfinder` | Navigate an unfamiliar codebase |
| `/wizard` | Step-by-step guided setup for complex integrations |
| `/setup-matt-pocock-skills` | One-time repo setup for issue tracker, labels, docs location |

### Engineering (model-invoked)

| Skill | What it does |
|---|---|
| `grill-with-docs` | Grilling session anchored to actual docs — surfaces gaps between intent and documented API |

### Productivity

| Skill | What it does |
|---|---|
| `/grill-me` | Grilling session for non-code work — surfaces assumptions, gaps, edge cases |
| `/grilling` | General-purpose grilling session |
| `/handoff` | Structured handoff note for context transfer between sessions |
| `/teach` | Teach a concept or skill |
| `/to-questionnaire` | Convert requirements into a structured questionnaire |
| `/wait-what` | Pause and clarify what the agent just did or decided |
| `/writing-for-agents` | Write clear, unambiguous instructions for AI agents |

## Key Concepts

**Grilling**: agent asks the user detailed questions to surface misalignment before implementation. Core to several skills.

**Two-route install**: plugin (managed, read-only, auto-update) vs `npx skills@latest add mattpocock/skills` (editable files you own). Pick one — installing both duplicates every skill.

**`/setup-matt-pocock-skills`**: required once per repo. Without it, skills that reference the issue tracker or docs location will prompt you to run it first.

## Learn More

- Source: https://github.com/mattpocock/skills
- Newsletter: https://www.aihero.dev/s/skills-newsletter
