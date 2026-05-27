---
name: gitleaks
description: Secret scanning tool — detects hardcoded credentials, API keys, and tokens in git history and working tree before they reach a remote
tags: [tool, security, secrets, git]
---

# Gitleaks

Detects hardcoded secrets — API keys, tokens, passwords — in git repositories. Scans working tree, staged files, and full git history.

- **Repo**: https://github.com/gitleaks/gitleaks
- **Install**: `brew install gitleaks`
- **License**: MIT

## What It Finds

- API keys (AWS, GitHub, Stripe, Slack, etc.)
- Private keys and certificates
- Database connection strings with credentials
- Generic high-entropy strings matching secret patterns

## Key Commands

```bash
gitleaks detect                    # scan working tree + staged files
gitleaks detect --source .         # scan entire repo including history
gitleaks detect --no-git           # scan files without git context
gitleaks protect --staged          # pre-commit hook mode (staged only)
gitleaks report                    # print last scan report
```

## Pre-commit Hook Integration

Run on every commit to catch secrets before they're pushed:

```bash
# .git/hooks/pre-commit or .github/hooks/pre-commit
gitleaks protect --staged --redact
```

Or add to `.claude/settings.local.json` to let Claude run it:
```json
{
  "permissions": {
    "allow": ["Bash(gitleaks detect *)", "Bash(gitleaks protect *)"]
  }
}
```

## When to Use

- Before pushing a new repo public
- Auditing a codebase inherited from another team
- As part of a CI security gate
- Pre-commit check on repos that handle API keys or credentials
