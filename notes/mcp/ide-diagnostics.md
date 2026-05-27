---
name: IDE MCP (getDiagnostics)
description: MCP tool that exposes IDE diagnostics (TypeScript errors, lint warnings) to Claude Code — lets Claude read the Problems panel without running tsc manually
tags: [mcp, ide, typescript, diagnostics]
---

# IDE MCP — getDiagnostics

Exposes IDE diagnostics directly to Claude Code. Claude can read TypeScript errors, ESLint warnings, and other Problems panel entries without running `tsc` or `eslint` manually.

- **Type**: MCP tool (built into Claude Code IDE extension)
- **Tool ID**: `mcp__ide__getDiagnostics`
- **Availability**: Requires Claude Code IDE extension (VS Code or JetBrains)

## What It Does

Returns current diagnostics from the IDE's language server:

- TypeScript compiler errors
- ESLint / Biome lint warnings and errors
- Other language server diagnostics (Python, Go, etc.)

Claude can use this to check for errors after edits without a separate build step.

## When to Use

- After making changes to TypeScript files — check for type errors immediately
- During refactors where you want incremental error feedback
- Instead of running `npx tsc --noEmit` for every check

## Setup

Enable in `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": ["mcp__ide__getDiagnostics"]
  }
}
```

Requires the Claude Code extension to be active in VS Code or JetBrains with the IDE MCP server enabled.
