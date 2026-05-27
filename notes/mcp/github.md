---
name: GitHub MCP plugin
description: MCP server for GitHub API — create PRs, manage issues, read/write files, search repos directly from Claude Code without gh CLI
tags: [mcp, github, devops]
---

# GitHub MCP Plugin

GitHub API access via MCP. Enables Claude Code to create PRs, manage issues, read and write files, and search repositories using authenticated API calls.

- **Type**: Claude Code MCP plugin
- **Plugin ID**: `github` (via Claude Code plugin marketplace)
- **Auth**: GitHub token (set in Claude Code settings or env)

## Available Tools

| Tool | What it does |
|---|---|
| `create_pull_request` | Open a PR with title, body, base, head |
| `update_pull_request` | Edit PR title, body, labels, assignees |
| `search_pull_requests` | Find PRs by repo, state, author |
| `pull_request_read` | Read PR details and diff |
| `add_issue_comment` | Comment on an issue or PR |
| `list_commits` | List commits on a branch |
| `get_file_contents` | Read a file from any branch |
| `create_or_update_file` | Write/update a file via API |
| `create_repository` | Create a new repo |
| `search_repositories` | Search GitHub repos |
| `get_me` | Get authenticated user info |

## When to Use

- When `gh` CLI is unavailable or slower for a specific operation
- Cross-repo operations (reading files from another repo)
- Programmatic PR/issue management at scale

## vs. `gh` CLI

| | GitHub MCP | `gh` CLI |
|---|---|---|
| Auth | Plugin-managed token | `gh auth login` |
| Speed | Faster for API calls | Better for interactive workflows |
| Scripting | Structured tool calls | Shell commands |

## Setup

Enable in `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": [
      "mcp__plugin_github_github__create_pull_request",
      "mcp__plugin_github_github__get_file_contents"
    ]
  }
}
```
