---
name: github:secure-repo
description: Claude Code skill for securing a GitHub repository — branch protection, rulesets, CODEOWNERS, secrets scanning, and access controls
tags: [skill, github, security, devops]
---

# GitHub: Secure Repo

Applies security hardening to a GitHub repository. Combines branch protection, ruleset configuration, CODEOWNERS, and access control into a single guided workflow.

- **Type**: Claude Code skill (namespaced: `github` plugin)
- **Invocation**: `Skill(github:secure-repo)`
- **Source**: GitHub plugin marketplace

## What It Does

Walks through repository security setup:

- Branch protection rules or rulesets (depending on repo type — personal vs. org)
- CODEOWNERS file creation and validation
- Required PR reviews and code owner approval
- Force-push and deletion protection
- Auto-delete merged branches
- Secrets and token scanning configuration

## Relationship to the Lockdown Prompt

For manual, step-by-step control with full rationale for each decision, use `prompts/github-repo-lockdown.md` in this repo. The `github:secure-repo` skill is faster for standard setups where you want guided automation rather than explicit commands.

## When to Use

- Setting up a new public or private repo from scratch
- Auditing an existing repo's security posture
- When you want a guided checklist rather than manual `gh api` calls

## Setup

Add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": ["Skill(github:secure-repo)", "Bash(gh api *)", "Bash(gh repo *)"]
  }
}
```
