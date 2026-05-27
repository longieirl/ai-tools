---
name: github-repo-standards
description: Non-negotiable standards for every GitHub repo — PR assignee, branch auto-delete, and lean workflow output
tags: [github, standards, workflow]
---

# GitHub Repo Standards

Apply these to every new repo. Each item has a one-time setup and a verification check.

## 1. PR Creator Auto-Assigned as Assignee

Every PR must be assigned to its creator automatically.

**Why:** Keeps ownership visible without manual steps. PRs without an assignee fall through the cracks.

**How:** GitHub Actions workflow — no native setting exists.

Create `.github/workflows/auto-assign.yml`:

```yaml
name: Auto-assign PR creator

on:
  pull_request:
    types: [opened]

permissions:
  issues: write

jobs:
  assign:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/github-script@v7
        with:
          script: |
            await github.rest.issues.addAssignees({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              assignees: [context.actor]
            })
```

**Verify:** Open a test PR — assignee field should populate immediately.

---

## 2. Branch Auto-Delete After Merge

Merged branches must be deleted automatically.

**Why:** Stale branches accumulate fast. Manual cleanup is never done consistently.

**How:**

```bash
gh api repos/OWNER/REPO --method PATCH --field delete_branch_on_merge=true
```

**Verify:**

```bash
gh api repos/OWNER/REPO --jq '.delete_branch_on_merge'
# Expected: true
```

---

## 3. Workflow Changesets Must Not Be Verbose

GitHub Actions workflows must declare explicit minimum permissions. Do not rely on the default broad `GITHUB_TOKEN` scope.

**Why:** Broad token scope produces verbose permission grants in the Actions log. Explicit permissions silence this and enforce least-privilege.

**Rules:**

- Always declare `permissions:` at workflow or job level
- Grant only what the job needs — nothing more
- No `echo`, `--verbose`, or debug flags in production workflows
- No unnecessary steps (checkout, install) unless the job requires them

**Common permission scopes:**

| Need | Permission |
|---|---|
| Assign PR/issue | `issues: write` |
| Comment on PR | `pull-requests: write` |
| Push to repo | `contents: write` |
| Read repo | `contents: read` |
| Create release | `contents: write` |

**Example — correct:**

```yaml
permissions:
  issues: write
```

**Example — incorrect (too broad, verbose):**

```yaml
permissions:
  contents: write
  pull-requests: write
  issues: write
  packages: write
```

---

## Checklist — New Repo Setup

- [ ] `auto-assign.yml` workflow added and tested
- [ ] `delete_branch_on_merge: true` confirmed via `gh api`
- [ ] All workflows declare explicit `permissions:` block
- [ ] No `--verbose`, debug flags, or unnecessary echo in workflows
