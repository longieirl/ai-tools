---
name: Context7 MCP
description: MCP server for live library documentation — resolves library IDs and returns up-to-date API docs, code examples, and version-specific guidance
tags: [mcp, docs, libraries, context7]
---

# Context7 MCP

Live documentation for any programming library or framework. Fetches current API docs and code examples directly into Claude's context — avoids stale training-data responses for fast-moving libraries.

- **Type**: MCP server (Claude Code plugin)
- **Plugin**: `context7`
- **Source**: https://context7.com

## Available Tools

| Tool | What it does |
|---|---|
| `resolve-library-id` | Maps a package name to a Context7 library ID |
| `query-docs` | Fetches docs for a specific library + query |

## When to Use

- Any question about a specific library's API, config, or migration path
- When Claude might give outdated answers (Next.js, React, Tailwind, Prisma, etc.)
- Version-specific questions (`/vercel/next.js/v14.3.0`)

## Workflow

```
1. resolve-library-id("Next.js", query)  →  "/vercel/next.js"
2. query-docs("/vercel/next.js", "app router middleware")  →  current docs
```

Always call `resolve-library-id` first unless you already have the library ID in `/org/project` format.

## Setup

Enable in `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": [
      "mcp__context7__resolve-library-id",
      "mcp__context7__query-docs"
    ]
  }
}
```

Context7 is available as a Claude Code plugin — no separate install needed if the plugin is configured in global settings.
