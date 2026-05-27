---
name: shadcn MCP
description: MCP server for shadcn/ui — install components, browse the registry, and query component docs directly from Claude Code
tags: [mcp, ui, components, shadcn]
---

# Shadcn MCP Server

MCP server for [shadcn/ui](https://ui.shadcn.com). Browse the component registry, install components, and query docs without leaving Claude Code.

- **Type**: MCP server (`.mcp.json` config)
- **Package**: `shadcn@latest`
- **Source**: https://ui.shadcn.com/docs/mcp

## What It Does

- Lists available shadcn components
- Installs components into your project via `npx shadcn@latest add <component>`
- Queries component API docs and usage examples
- Supports theming and variant queries

## When to Use

- Building UI with shadcn/ui and want Claude to install the right component
- Checking component API without leaving the editor
- Letting Claude scaffold forms, dialogs, tables with correct shadcn primitives

## Setup

Add to `.mcp.json` in your project root:
```json
{
  "mcpServers": {
    "shadcn": {
      "command": "npx",
      "args": ["-y", "shadcn@latest", "mcp"]
    }
  }
}
```

Enable in `.claude/settings.local.json`:
```json
{
  "enableAllProjectMcpServers": true,
  "enabledMcpjsonServers": ["shadcn"]
}
```
