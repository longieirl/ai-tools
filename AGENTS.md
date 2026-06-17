# AITools

Personal collection of AI tools, prompts, configs, and workflows. No framework, no build step, no tests — pure markdown and config files.

## Structure

```
prompts/        System prompts, reusable prompt templates
tools/          Scripts, wrappers, CLI tools
configs/        Config files and templates (Claude, Cursor, etc.)
workflows/      Multi-step AI workflow definitions
notes/          Research notes, evaluations, comparisons
```

## Git Conventions

Commit format: `type: description`

Types: `feat` | `fix` | `chore` | `docs` | `refactor`

Branch naming: `type/short-description`
If working from a GitHub issue: `type/123-short-description`

Never push directly to `main`. Always branch.

PRs require 1 approving review.

## Setup

After cloning, run one-time machine setup:

```bash
bash tools/setup-claude.sh
git config core.hooksPath .github/hooks
```

`setup-claude.sh` symlinks `configs/global-claude.md` into `~/.claude/` so any project using `@~/.claude/global-claude.md` picks up behavioral guidelines from this repo.

`core.hooksPath` enforces no direct commits or pushes to `main`.

## AI Agent Behavior

See [configs/global-claude.md](configs/global-claude.md) for full behavioral guidelines (Think Before Coding, Surgical Changes, Goal-Driven Execution). Read that file before starting any task.

## Adding Content

- New prompt → `prompts/`
- New tool/script → `tools/`
- Config template → `configs/`
- Research note → `notes/`
- Update `README.md` table when adding files others should discover
