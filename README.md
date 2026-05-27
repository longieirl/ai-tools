# AI Tools

Personal collection of AI tools, prompts, configs, and workflows.

## Structure

```
prompts/        System prompts, reusable prompt templates
tools/          Scripts, wrappers, CLI tools
configs/        Config files and templates for AI tools (Claude, Cursor, etc.)
workflows/      Multi-step AI workflow definitions
notes/          Research notes, evaluations, comparisons
```

## Configs

| File | Description |
|------|-------------|
| [claude-example.md](configs/claude-example.md) | Base CLAUDE.md template — copy into any project and extend the Project-Specific section |

## Prompts

| File | Description |
|------|-------------|
| [setup-dead-weight-audit.md](prompts/setup-dead-weight-audit.md) | Audit Claude setup files for dead-weight instructions that produce no observable difference on typical tasks |
| [github-repo-lockdown.md](prompts/github-repo-lockdown.md) | Lock down a public personal GitHub repo — rulesets, CODEOWNERS, local hooks, auto-delete branches |

## Notes

### Skills

| File | Description |
|------|-------------|
| [impeccable](notes/skills/impeccable.md) | Production-grade frontend interface design — craft, audit, animate, polish |
| [taste-skill](notes/skills/taste-skill.md) | Metric-based UI/UX engineering — React/Next.js, Tailwind, Framer Motion, no AI-slop |
| [emil-design-eng](notes/skills/emil-design-eng.md) | Design engineering review — Before/After/Why format, animation framework, CSS mastery |
| [ui-ux-pro-max](notes/skills/ui-ux-pro-max.md) | Design intelligence database — 67 styles, 96 palettes, 57 font pairings, 25 chart types |
| [update-config](notes/skills/update-config.md) | Configure Claude Code settings.json — permissions, hooks, env vars, MCP servers |
| [github:secure-repo](notes/skills/github-secure-repo.md) | Guided GitHub repo security hardening — rulesets, CODEOWNERS, access controls |
| [gsd:progress](notes/skills/gsd-progress.md) | GSD Redux — auto-detect and run next step in the plan→execute→verify→ship loop |
| [static-analysis:semgrep](notes/skills/semgrep.md) | Semgrep static analysis — security vulnerabilities, OWASP, custom rules |

### MCP Servers

| File | Description |
|------|-------------|
| [shadcn](notes/mcp/shadcn.md) | shadcn/ui MCP — install components, browse registry, query docs |
| [github](notes/mcp/github.md) | GitHub API MCP — PRs, issues, file read/write, repo search |
| [context7](notes/mcp/context7.md) | Live library documentation — current API docs and code examples for any package |
| [ide-diagnostics](notes/mcp/ide-diagnostics.md) | IDE diagnostics MCP — TypeScript errors, lint warnings via language server |

### Tools

| File | Description |
|------|-------------|
| [rtk-token-saving.md](notes/rtk-token-saving.md) | RTK (Rust Token Killer) — CLI proxy that cuts shell-command tokens 60–90% before they hit LLM context |
| [gsd](notes/tools/gsd.md) | Get Shit Done Redux — spec-driven dev system that solves context rot with parallel subagent execution |
| [playwright](notes/tools/playwright.md) | Browser automation — E2E tests, accessibility, cross-browser, responsive, screenshots |
| [lighthouse](notes/tools/lighthouse.md) | Automated auditing — performance, accessibility, SEO, best practices |
| [gitleaks](notes/tools/gitleaks.md) | Secret scanning — detects hardcoded credentials in git history and working tree |

## Contributing

After cloning, activate the shared git hooks:

```bash
git config core.hooksPath .github/hooks
```

This enforces local protection on `main` (no direct commits or pushes).
