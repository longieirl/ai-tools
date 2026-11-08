---
name: Magic MCP (21st.dev)
description: MCP server from 21st.dev — search and insert 10,000+ React/Tailwind UI components and templates into a project from Claude Code
tags: [mcp, ui, components, react, tailwind, 21st]
---

# Magic MCP (21st.dev)

MCP server that gives an agent access to 21st.dev's library of React/Tailwind UI components and templates. Search for a component and insert it into the project in one step. (Formerly "Magic MCP"; now also called the 21st MCP.)

- **Type**: MCP server (`.mcp.json` config)
- **Package**: `@21st-dev/magic`
- **Repo**: https://github.com/21st-dev/magic-mcp
- **Setup page**: https://21st.dev/mcp

## What It Does

- Searches 10,000+ React/Tailwind components and templates
- Inserts a chosen component straight into your project
- Pulls from a designer-built library rather than generating from scratch

## When to Use

- Building React/Tailwind UI and want vetted components instead of ad-hoc output
- Scaffolding sections (heroes, pricing, nav) from a real component library

## Setup

Add to `.mcp.json` in your project root (requires a 21st.dev API key):
```json
{
  "mcpServers": {
    "magic": {
      "command": "npx",
      "args": ["-y", "@21st-dev/magic@latest"],
      "env": { "API_KEY": "<your-21st-dev-key>" }
    }
  }
}
```

Enable in `.claude/settings.local.json`:
```json
{
  "enableAllProjectMcpServers": true,
  "enabledMcpjsonServers": ["magic"]
}
```

See https://21st.dev/mcp for the current one-command install and exact config.
