---
name: gsd:progress
description: GSD Redux skill — auto-detects the current phase state and runs the next step in the plan → execute → verify → ship loop
tags: [skill, gsd, workflow, planning]
---

# GSD: Progress

Part of the **Get Shit Done Redux** system. Auto-detects where you are in the GSD loop and runs the next appropriate step — no manual phase tracking required.

- **Type**: GSD Redux skill (installed via `npx @opengsd/get-shit-done-redux@latest`)
- **Invocation**: `Skill(gsd:progress)` or `/gsd-progress --next`
- **Source**: `open-gsd/get-shit-done-redux`

## What It Does

Reads current phase state (planned, executing, verifying, shipping) and automatically runs the next command in the loop:

```
discuss → plan → execute → verify → ship
```

Equivalent to calling `/gsd-progress --next` which inspects phase files, git history, and task state to determine what needs to run next.

## GSD Loop (Full Context)

| Command | What it does |
|---|---|
| `/gsd-new-project` | Questions → research → requirements → roadmap |
| `/gsd-discuss-phase [N]` | Capture implementation decisions before planning |
| `/gsd-plan-phase [N]` | Research + plan + verify in a loop |
| `/gsd-execute-phase <N>` | Run plans in parallel subagent waves |
| `/gsd-verify-work [N]` | Acceptance testing — diagnose failures |
| `/gsd-ship [N]` | Create PR from verified work |
| `/gsd-progress --next` | Auto-detect and run next step |
| `/gsd-complete-milestone` | Archive milestone and tag release |

## Why GSD Exists

Solves **context rot** — quality degradation as the AI context window fills. Each execution phase runs in a fresh 200k-token subagent context. Main context stays at 30–40%.

## Install

```bash
npx @opengsd/get-shit-done-redux@latest
# Select runtime: Claude Code
# Select profile: core (6 skills) | standard | full
```

> Note: The original `gsd-build/rtk` repo has moved to `open-gsd/get-shit-done-redux`. Use `@opengsd/get-shit-done-redux` on npm — the legacy package is unmaintained.

## Repo

https://github.com/open-gsd/get-shit-done-redux
