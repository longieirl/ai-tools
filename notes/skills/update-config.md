---
name: update-config
description: Claude Code skill for configuring settings.json — permissions, hooks, env vars, MCP servers. Use when automating behaviours or managing allowed tool calls.
tags: [skill, config, claude-code, settings]
---

# Update Config

Configure Claude Code's `settings.json` and `settings.local.json` files. Handles permissions, hooks, env vars, MCP servers, and tool allowlists.

- **Type**: Claude Code built-in skill (Superpowers)
- **Invocation**: `Skill(update-config)`
- **Source**: Global Claude Code skill — no install required

## What It Does

Reads the current settings files and applies changes:

- **Permissions** — add/remove/move `allow` and `deny` entries for Bash, Read, WebFetch, MCP tools, and Skills
- **Hooks** — configure `PreToolUse`, `PostToolUse`, `Stop`, and `Notification` hooks
- **Env vars** — set environment variables available to Claude during a session
- **MCP servers** — enable/disable MCP servers, update connection config
- **Tool settings** — configure tool-specific behaviour

## When to Use

- After Claude asks for a tool permission you want to persist
- Setting up automated behaviours ("always run X before Y")
- Moving permissions from project `settings.local.json` to global `settings.json`
- Enabling an MCP server for a project

## Example Invocations

```
"Allow npm commands without prompting" → Skill(update-config)
"Add a hook that runs tests after every edit" → Skill(update-config)
"Move the gh permission to global settings" → Skill(update-config)
"Enable the shadcn MCP server" → Skill(update-config)
```

## Settings File Locations

| File | Scope |
|---|---|
| `~/.claude/settings.json` | Global — all projects |
| `.claude/settings.local.json` | Project-local — gitignored by default |
