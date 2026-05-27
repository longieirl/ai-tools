# AI Tools

Personal collection of AI tools, prompts, configs, and workflows.

## Structure

```
prompts/        System prompts, reusable prompt templates
tools/          Scripts, wrappers, CLI tools
configs/        Config files for AI tools (Claude, Cursor, etc.)
workflows/      Multi-step AI workflow definitions
notes/          Research notes, evaluations, comparisons
```

## Prompts

| File | Description |
|------|-------------|
| [setup-dead-weight-audit.md](prompts/setup-dead-weight-audit.md) | Audit Claude setup files for dead-weight instructions that produce no observable difference on typical tasks |
| [github-repo-lockdown.md](prompts/github-repo-lockdown.md) | Lock down a public personal GitHub repo — rulesets, CODEOWNERS, local hooks, auto-delete branches |

## Notes

| File | Description |
|------|-------------|
| [rtk-token-saving.md](notes/rtk-token-saving.md) | RTK (Rust Token Killer) — CLI proxy that cuts shell-command tokens 60–90% before they hit LLM context |

## Contributing

After cloning, activate the shared git hooks:

```bash
git config core.hooksPath .github/hooks
```

This enforces local protection on `main` (no direct commits or pushes).
