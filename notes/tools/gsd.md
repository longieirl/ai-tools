---
name: GSD Redux
description: Spec-driven development system for Claude Code — solves context rot with a 6-command loop of discuss, plan, execute, verify, and ship
tags: [tool, workflow, planning, context-engineering]
---

# GSD Redux — Get Shit Done

Lightweight spec-driven development system. Solves **context rot** — the quality degradation that happens as the AI context window fills up during long sessions.

- **Repo**: https://github.com/open-gsd/get-shit-done-redux
- **Package**: `@opengsd/get-shit-done-redux`
- **License**: MIT

## The Core Problem It Solves

Long Claude Code sessions accumulate context. By the time you're building phase 3, phase 1 decisions are buried or forgotten. GSD runs each execution phase in a fresh 200k-token subagent context — your main window stays at 30–40%.

## The Loop

```
new-project → discuss → plan → execute → verify → ship → repeat
```

| Command | What it does |
|---|---|
| `/gsd-new-project` | Questions → research → requirements → roadmap |
| `/gsd-map-codebase` | Index existing codebase before starting |
| `/gsd-discuss-phase [N]` | Capture decisions before planning (layouts, API shapes, edge cases) |
| `/gsd-plan-phase [N]` | Research → plan → verify loop until plans pass |
| `/gsd-execute-phase <N>` | Parallel wave execution in fresh subagent contexts |
| `/gsd-verify-work [N]` | Acceptance testing — failed items get diagnosed fix plans |
| `/gsd-ship [N]` | Create PR from verified work |
| `/gsd-progress --next` | Auto-detect and run next step |
| `/gsd-complete-milestone` | Archive, tag, start fresh |

## Install

```bash
npx @opengsd/get-shit-done-redux@latest
# Select: Claude Code
# Profile: core (6 skills), standard, or full
```

Then run with:
```bash
claude --dangerously-skip-permissions
```

## Profiles

| Profile | Skills included |
|---|---|
| `core` | 6 core loop skills |
| `standard` | Core + phase management |
| `full` | Everything (default) |

Compose profiles: `--profile=core,audit`

## Note on Legacy Package

The original `gsd-build/rtk` repo has moved. Use only `@opengsd/get-shit-done-redux` — the legacy upstream is unmaintained and outside open-gsd control.
