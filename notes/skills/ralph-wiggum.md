---
name: ralph-wiggum
description: Claude Code plugin for iterative AI development loops — feeds the same prompt repeatedly so Claude builds on its own previous work
tags: [skill, plugin, iteration, loops]
---

# Ralph Wiggum

Iterative development methodology: feed the same prompt to Claude on a loop. Each iteration Claude sees its previous work in files and git history, building incrementally toward completion.

- **Type**: Marketplace plugin (`claude-code-plugins` marketplace — ships with Claude Code)
- **Source**: `anthropics/claude-code` repo, `plugins/ralph-wiggum`
- **Skills**: `ralph-wiggum:ralph-loop`, `ralph-wiggum:cancel-ralph`, `ralph-wiggum:help`

## How It Works

Each iteration:
1. Claude receives the same prompt
2. Works on the task, modifying files
3. Stop hook intercepts exit, feeds same prompt again
4. Claude sees previous work in files
5. Repeats until completion promise detected or max iterations hit

## Commands

| Command | Description |
|---|---|
| `/ralph-loop "<PROMPT>"` | Start a loop in current session |
| `/cancel-ralph` | Cancel active loop (removes state file) |
| `/ralph-wiggum:help` | Show full usage docs |

### Options for `/ralph-loop`

- `--max-iterations <n>` — stop after N iterations
- `--completion-promise <text>` — stop when Claude outputs `<promise>TEXT</promise>`

### Signalling Completion

Claude must emit a `<promise>` tag to end the loop:

```
<promise>TASK COMPLETE</promise>
```

## When to Use

**Good for**: well-defined tasks with clear success criteria, iterative refinement, self-correcting work, greenfield projects.

**Not for**: tasks requiring human judgment, one-shot operations, debugging production issues.

## Setup

Plugin is enabled via `~/.claude/settings.json`. Requires the `claude-code-plugins` marketplace:

```json
{
  "enabledPlugins": {
    "ralph-wiggum@claude-code-plugins": true
  },
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "git",
        "url": "https://github.com/anthropics/claude-code.git"
      }
    }
  }
}
```

## Example

```
/ralph-loop "Fix the token refresh logic in auth.ts. Output <promise>FIXED</promise> when all tests pass." --completion-promise "FIXED" --max-iterations 10
```

## Learn More

- Original technique: https://ghuntley.com/ralph/
- Plugin source: https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum
