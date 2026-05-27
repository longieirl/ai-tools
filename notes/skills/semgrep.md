---
name: static-analysis:semgrep
description: Claude Code skill for running Semgrep static analysis — finds security vulnerabilities, code quality issues, and custom rule violations
tags: [skill, security, static-analysis, semgrep]
---

# Static Analysis: Semgrep

Run Semgrep static analysis from within a Claude Code session. Finds security vulnerabilities, bug patterns, and code quality issues using Semgrep's rule library or custom rules.

- **Type**: Claude Code skill (namespaced: `static-analysis` plugin)
- **Invocation**: `Skill(static-analysis:semgrep)`
- **Source**: `trailofbits/skills` marketplace (add via `extraKnownMarketplaces`)

## What It Does

- Runs Semgrep against the current codebase or specified files
- Surfaces findings with file, line, rule ID, and severity
- Maps findings to OWASP categories where applicable
- Supports Semgrep OSS (free) and Semgrep Pro rule sets

## Common Rule Sets

| Rule set | Coverage |
|---|---|
| `p/security-audit` | General security vulnerabilities |
| `p/owasp-top-ten` | OWASP Top 10 |
| `p/javascript` | JS/TS anti-patterns |
| `p/python` | Python security and quality |
| `p/secrets` | Hardcoded credentials and tokens |

## When to Use

- Before merging a PR with security-sensitive changes
- Auditing a new codebase for known vulnerability patterns
- Enforcing custom code patterns across a team

## Setup

Enable `trailofbits` marketplace in `~/.claude/settings.json`:
```json
{
  "extraKnownMarketplaces": [
    {
      "name": "trailofbits",
      "url": "https://raw.githubusercontent.com/trailofbits/skills/main/registry.json"
    }
  ]
}
```

Add permission:
```json
{
  "permissions": {
    "allow": ["Skill(static-analysis:semgrep)"]
  }
}
```

Semgrep must be installed:
```bash
brew install semgrep
# or
pip install semgrep
```
