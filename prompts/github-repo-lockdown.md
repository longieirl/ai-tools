---
name: github-repo-lockdown
description: Lock down a public personal GitHub repo — branch protection, rulesets, CODEOWNERS, local hooks, and auto-delete branches
tags: [github, security, setup]
---

# GitHub Repo Lockdown

Lock down a public personal GitHub repo. Apply all steps in order.

Use `longieirl/ai-tools` as the reference implementation.

## Variables

Before starting, identify:

- `REPO` — GitHub repo in `owner/name` format (e.g. `longieirl/ai-tools`)
- `OWNER` — GitHub username of the repo owner (e.g. `longieirl`)
- `DEFAULT_BRANCH` — usually `main`

## Step 1: CODEOWNERS

Create `.github/CODEOWNERS` assigning the owner to all files:

```bash
mkdir -p .github
echo "* @OWNER" > .github/CODEOWNERS
```

Commit and push this file before applying branch protection (rulesets reference it).

## Step 2: Branch Ruleset

Use a **ruleset**, not legacy branch protection. Personal repos support bypass actors in rulesets but not in legacy branch protection.

`actor_id: 5` = Repository Admin role (built-in). This lets the owner push directly without a PR.

```bash
gh api repos/REPO/rulesets \
  --method POST \
  --header "Accept: application/vnd.github+json" \
  --input - <<'EOF'
{
  "name": "Protect main",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main"],
      "exclude": []
    }
  },
  "bypass_actors": [
    {
      "actor_id": 5,
      "actor_type": "RepositoryRole",
      "bypass_mode": "always"
    }
  ],
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 1,
        "require_code_owner_review": true,
        "dismiss_stale_reviews_on_push": true,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true
      }
    }
  ]
}
EOF
```

**Do not use legacy branch protection** (`/branches/main/protection`) for personal repos — it cannot grant per-user bypass, and `enforce_admins: true` blocks even the owner.

## Step 3: Auto-Delete Branches

Auto-delete merged branches to keep the repo clean:

```bash
gh api repos/REPO --method PATCH --field delete_branch_on_merge=true
```

## Step 4: Local Git Hooks

Create hooks in `.github/hooks/` so they are committed and shared with the repo.

**`.github/hooks/pre-commit`** — blocks committing directly on `main`:

```sh
#!/bin/sh
branch=$(git symbolic-ref --short HEAD 2>/dev/null)
if [ "$branch" = "main" ]; then
  echo "ERROR: Direct commits to main are not allowed. Create a branch."
  exit 1
fi
```

**`.github/hooks/pre-push`** — blocks pushing `main` to remote:

```sh
#!/bin/sh
while read local_ref local_sha remote_ref remote_sha; do
  if echo "$remote_ref" | grep -q "refs/heads/main"; then
    echo "ERROR: Direct push to main is not allowed. Open a PR."
    exit 1
  fi
done
```

Make hooks executable and point git to them:

```bash
chmod +x .github/hooks/pre-commit .github/hooks/pre-push
git config core.hooksPath .github/hooks
```

**Important:** `git config core.hooksPath` is local only. Every new clone needs this command. Document it in the repo README under a Contributing section:

```
After cloning, activate the shared git hooks:
git config core.hooksPath .github/hooks
```

## Step 5: Commit and Push Hooks

Hooks enforce rules on themselves — the first push of the hook files will be blocked by the pre-push hook. Use `--no-verify` once for this bootstrap commit only:

```bash
git add .github/
git commit --no-verify -m "add shared git hooks and CODEOWNERS"
git push --no-verify
```

This is the only valid use of `--no-verify` in this setup.

## Step 6: Verify

```bash
# Ruleset active
gh api repos/REPO/rulesets --jq '.[].name'

# Auto-delete enabled
gh api repos/REPO --jq '.delete_branch_on_merge'

# Hooks wired
git config core.hooksPath

# CODEOWNERS exists
cat .github/CODEOWNERS
```

Expected output:
- Ruleset name printed
- `true`
- `.github/hooks`
- `* @OWNER`

## Decisions and Rationale

| Decision | Reason |
|---|---|
| Ruleset over legacy branch protection | Personal repos cannot set bypass actors in legacy protection. Rulesets support `RepositoryRole` bypass — owner can push directly |
| `actor_id: 5` (Admin role) | Built-in repo role. Grants bypass to owner without naming specific users |
| Hooks in `.github/hooks/` not `.git/hooks/` | `.git/` is not committed. `.github/hooks/` is tracked and shared |
| `--no-verify` on bootstrap commit only | Hooks block themselves on first push — unavoidable one-time exception |
| `enforce_admins: true` not used | Replaced by ruleset. Legacy `enforce_admins: true` blocked even the owner with no bypass path |

## Security Note

`gh api` commands modify repo settings using the caller's auth token. Only users with **admin** access to the repo can apply these settings. Public visibility does not grant write or admin access — unauthenticated users get 403 on all PATCH/POST API calls.

## See Also

- [`notes/github-repo-standards.md`](../notes/github-repo-standards.md) — non-negotiable standards every repo must meet (PR auto-assign, branch auto-delete, lean workflow output)
