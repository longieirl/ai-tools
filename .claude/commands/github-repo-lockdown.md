---
name: github-repo-lockdown
description: Lock down a public GitHub repo for safe community contributions — branch protection, CODEOWNERS, CI validation, security files, Dependabot, secret scanning, and local hooks
tags: [github, security, setup]
---

# GitHub Repo Lockdown

Lock down a public GitHub repository so it remains open for community contributions while ensuring all changes are reviewed, secure, validated, and introduced only through pull requests.

Use `longieirl/ai-tools` as the reference implementation.

Use a frontier-class model (Claude Opus or equivalent) for the security review pass over CODEOWNERS coverage, branch protection rules, and any GitHub Actions workflow that consumes PR-controlled inputs. Lighter models are acceptable for file scaffolding.

## Variables

Before starting, identify:

- `REPO` — GitHub repo in `owner/name` format (e.g. `longieirl/ai-tools`)
- `OWNER` — GitHub username of the repo owner (e.g. `longieirl`)
- `DEFAULT_BRANCH` — usually `main`

---

## Step 1: Pre-flight Audit

Inspect the current repo state before making changes.

```bash
# Branches
gh api repos/REPO/branches --jq '.[].name'

# Existing workflows
ls .github/workflows/ 2>/dev/null || echo "No workflows"

# Governance files present?
ls .github/CODEOWNERS .github/pull_request_template.md \
   CONTRIBUTING.md SECURITY.md LICENSE 2>/dev/null

# .gitignore audit
cat .gitignore 2>/dev/null || echo "No .gitignore"
```

Check `.gitignore` for:
- Sensitive files ignored: `.env`, `*.env`, `secrets`, `credentials`, `*.pem`, `*.key`
- No `!` negation accidentally un-ignoring real secret files
- Example files correctly tracked (e.g. `.env.example` should NOT be ignored)

Catalogue existing YAML file formatting (blank lines, comment spacing, line length, indentation) before adding lint rules — new rules must pass the current tree without touching pre-existing files.

---

## Step 2: CODEOWNERS

Create `.github/CODEOWNERS` assigning the owner to all files:

```bash
mkdir -p .github
cat > .github/CODEOWNERS <<'EOF'
# Default owner for everything
* @OWNER

# Source code
src/ @OWNER

# GitHub Actions workflows
.github/workflows/ @OWNER
.github/CODEOWNERS @OWNER

# Configuration
*.yml @OWNER
*.yaml @OWNER
*.json @OWNER
*.toml @OWNER

# Security and legal
SECURITY.md @OWNER
LICENSE @OWNER
EOF
```

Commit and push this file before applying branch protection — rulesets reference it.

---

## Step 3: Branch Ruleset

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

---

## Step 4: Auto-Delete Branches

Auto-delete merged branches to keep the repo clean:

```bash
gh api repos/REPO --method PATCH --field delete_branch_on_merge=true
```

---

## Step 5: Auto-Assign PR Creator

GitHub has no native setting for this — requires an Actions workflow. Create `.github/workflows/auto-assign.yml`:

```yaml
name: Auto-assign PR creator

on:
  pull_request:
    types: [opened]

permissions:
  pull-requests: write

jobs:
  assign:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/github-script@60a0d83039f74b4cbd4b2827b1f7c1a6043aa3c4  # v7
        with:
          script: |
            await github.rest.issues.addAssignees({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              assignees: [context.actor]
            })
```

---

## Step 6: Contribution Files

### CONTRIBUTING.md

```markdown
# Contributing

## How to contribute

1. Fork this repository.
2. Create a branch from `main`: `git checkout -b your-feature-name`.
3. Make your changes. Keep each PR to one logical change.
4. Run validation locally before pushing (see below).
5. Open a pull request against `main`.

## Local validation

<!-- Replace with project-specific commands -->
<!-- e.g. npm test, make validate, docker compose config -->

## Rules

- No secrets, credentials, API keys, tokens, passwords, private IP addresses, or
  personal environment paths in any committed file.
- Match existing code style and naming conventions.
- External contributors cannot merge — all PRs require owner review.

## Git hooks

After cloning, activate the shared git hooks:

    git config core.hooksPath .github/hooks
```

### PR template

Create `.github/pull_request_template.md`:

```markdown
## Summary

<!-- What does this PR change, and why? -->

## Area affected

<!-- Which component, file, or workflow does this touch? -->

## Security impact

<!-- Does this change affect auth, secrets handling, network access, or permissions? If not, write "None". -->

## Tested locally

<!-- How did you verify this change works? -->

## Checklist

- [ ] No secrets, credentials, or personal environment paths included
- [ ] Local validation passes
- [ ] One logical change per PR
```

---

## Step 7: Security and Legal Files

### SECURITY.md

```markdown
# Security Policy

## Scope

This policy covers the `REPO` repository.

## Reporting a vulnerability

Report vulnerabilities privately via [GitHub Security Advisories](https://github.com/REPO/security/advisories/new).

Include:
- Description of the vulnerability
- Steps to reproduce
- Affected versions or files
- Potential impact

Do not open a public issue for security vulnerabilities.

**Expected response:** acknowledgement within 7 days, resolution timeline within 30 days.

## Known accepted risks

<!-- Document accepted patterns here so reviewers do not re-flag them. -->
<!-- Example: Docker socket mount required for Watchtower; NET_ADMIN required for WireGuard -->
```

### LICENSE

Check if LICENSE exists:

```bash
ls LICENSE LICENSE.md LICENSE.txt 2>/dev/null || echo "Missing — add one"
```

If absent, add MIT for open tooling/config repos or Apache-2.0 when patent protection matters:

```bash
# MIT template — update year and name
cat > LICENSE <<'EOF'
MIT License

Copyright (c) YEAR OWNER

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
```

Add a license reference to README.md if not already present:

```bash
echo -e "\n## License\n\n[MIT](LICENSE)" >> README.md
```

---

## Step 8: Repository Security Settings

Enable via GitHub UI (`Settings → Security`) or CLI:

```bash
# Enable Dependabot alerts
gh api repos/REPO/vulnerability-alerts --method PUT

# Enable Dependabot security updates
gh api repos/REPO/automated-security-fixes --method PUT

# Enable secret scanning (requires GitHub Advanced Security on public repos — enabled by default)
# Enable push protection via: Settings → Security → Secret scanning → Push protection
```

**Via GitHub UI — check all three:**
1. Settings → Security → Dependabot alerts → Enable
2. Settings → Security → Dependabot security updates → Enable
3. Settings → Security → Secret scanning → Enable push protection

Code scanning: Settings → Security → Code scanning → Set up → default configuration.

---

## Step 9: CI Validation

Trigger: `pull_request` and `push` to `main`. Fail the PR if any check fails.

### yamllint configuration

**First: check if the repo has project YAML files outside `.github/`:**

```bash
find . -name "*.yml" -o -name "*.yaml" \
  | grep -v "^./.git/" | grep -v "^./.github/" | head -5
```

- If results found: add yamllint to CI and create `.yamllint.yml`
- If empty: skip yamllint — actionlint already covers `.github/workflows/` YAML

If adding yamllint: calibrate rules against the existing repo state first — run yamllint locally, then relax rules until it passes cleanly against all current files before committing. New strictness applies only going forward.

Create `.yamllint.yml`:

```yaml
extends: default
rules:
  document-start: disable
  empty-lines:
    max: 2
  line-length:
    max: 160
    level: warning
  comments:
    min-spaces-from-content: 1
  truthy:
    check-keys: false  # permits `on:` in GitHub Actions files
ignore: |
  .git
  node_modules
```

Validate locally before committing:

```bash
pip install yamllint
yamllint -c .yamllint.yml .
```

### actionlint

Validate locally before committing:

```bash
# macOS
brew install actionlint

# Run against all workflows
actionlint .github/workflows/*.yml
```

### CI workflow

Create `.github/workflows/ci.yml`. Only include the YAML lint step if project YAML files exist outside `.github/` (see check above).

**Base workflow (always):**

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683  # v4

      - name: Actions lint
        uses: raven-actions/actionlint@3a0b5a96f5f8e2af9e86e3bb0f8fb55698b91a4f  # v2

      - name: Secrets scan
        uses: gitleaks/gitleaks-action@ff98106e4c7b2bc287b24eaf42907196329070c7  # v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Add this step only if project YAML exists outside `.github/`:**

```yaml
      - name: YAML lint
        run: |
          pip install yamllint --quiet
          yamllint -c .yamllint.yml .
```

If adding the YAML lint step, also create `.yamllint.yml` (see configuration above).

### GitHub Actions security rules

These rules apply to every workflow in this repository:

1. **Never interpolate PR-controlled values into `run:` blocks.** Treat `${{ github.event.* }}`, branch names, commit messages, file names, and step outputs derived from PR content as adversarial input. Pass through `env:` and reference as a quoted shell variable:

   ```yaml
   # BAD — script injection risk
   - run: echo "${{ github.event.pull_request.title }}"

   # GOOD
   env:
     PR_TITLE: ${{ github.event.pull_request.title }}
   - run: echo "$PR_TITLE"
   ```

2. **No `$(find ...)` substitution in `run:` blocks** — triggers shellcheck SC2046 via actionlint. Use `find ... | xargs` or `find ... -exec {} +` instead.

3. **Use `pull_request` not `pull_request_target`** for PR-triggered jobs. Never combine `pull_request_target` with checkout of the PR head without fully understanding the security implications.

4. **Set `permissions:` to least-privilege** at workflow or job level. Default to `contents: read` and add only what each job requires.

5. **Pin all third-party actions by commit SHA.** Mutable tags (`v4`, `main`) can be silently overwritten.

---

## Step 10: [CONDITIONAL] Docker / Container Security

Skip this step if the repository contains no Dockerfiles or Docker Compose files.

Create `.github/workflows/docker-advisory.yml` — this reports findings but does **not** fail the PR:

```yaml
name: Docker security advisory

on:
  pull_request:
    paths:
      - '**/Dockerfile*'
      - '**/docker-compose*.yml'
      - '**/docker-compose*.yaml'

permissions:
  contents: read

jobs:
  advisory:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683  # v4

      - name: Scan for risky Docker patterns
        run: |
          echo "## Docker Security Advisory" >> "$GITHUB_STEP_SUMMARY"
          echo "" >> "$GITHUB_STEP_SUMMARY"

          patterns=(
            "privileged: true"
            "network_mode: host"
            "/var/run/docker.sock"
            "cap_add"
            "SYS_ADMIN"
            "user: root"
            "0\.0\.0\.0:"
          )

          found=0
          for pattern in "${patterns[@]}"; do
            matches=$(find . \( -name "Dockerfile*" -o -name "docker-compose*.yml" -o -name "docker-compose*.yaml" \) \
              -exec grep -nH "$pattern" {} + 2>/dev/null || true)
            if [ -n "$matches" ]; then
              echo "**Pattern:** \`$pattern\`" >> "$GITHUB_STEP_SUMMARY"
              echo '```' >> "$GITHUB_STEP_SUMMARY"
              echo "$matches" >> "$GITHUB_STEP_SUMMARY"
              echo '```' >> "$GITHUB_STEP_SUMMARY"
              found=$((found + 1))
            fi
          done

          if [ "$found" -eq 0 ]; then
            echo "No risky patterns found." >> "$GITHUB_STEP_SUMMARY"
          fi
```

Document known-accepted patterns in `SECURITY.md` so reviewers do not re-flag them.

---

## Step 11: Local Git Hooks

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

**Important:** `git config core.hooksPath` is local only. Every new clone needs this command. Document it in CONTRIBUTING.md (already included in the template above).

---

## Step 12: Bootstrap Commit

Hooks enforce rules on themselves — the first push of the hook files will be blocked by the pre-push hook. Use `--no-verify` once for this bootstrap commit only:

```bash
git add .github/ CONTRIBUTING.md SECURITY.md LICENSE .yamllint.yml
git commit --no-verify -m "chore: add repo governance, CI validation, and security hardening"
git push --no-verify
```

This is the only valid use of `--no-verify` in this setup.

---

## Step 13: Verify

```bash
# Ruleset active
gh api repos/REPO/rulesets --jq '.[].name'

# Auto-delete enabled
gh api repos/REPO --jq '.delete_branch_on_merge'

# Governance files exist
ls .github/CODEOWNERS \
   .github/pull_request_template.md \
   .github/workflows/auto-assign.yml \
   .github/workflows/ci.yml \
   CONTRIBUTING.md SECURITY.md LICENSE .yamllint.yml

# Hooks wired
git config core.hooksPath

# CODEOWNERS default rule
grep '^\* @' .github/CODEOWNERS

# yamllint passes current tree
yamllint -c .yamllint.yml .

# actionlint passes all workflows
actionlint .github/workflows/*.yml
```

### Final checklist

- [ ] All workflows validated locally (actionlint) before push
- [ ] yamllint step only added to CI if project YAML files exist outside `.github/`
- [ ] No `${{ }}` expressions interpolated directly into `run:` shell blocks
- [ ] yamllint passes against existing tree without modifying pre-existing files
- [ ] LICENSE present and referenced in README
- [ ] `.gitignore` has no erroneous `!` negations on sensitive file patterns
- [ ] Sensitive files (`.env`, credentials) confirmed ignored
- [ ] `main` branch rejects direct push
- [ ] All CI status checks required before merge (add check names to ruleset after first CI run)
- [ ] Dependabot alerts enabled
- [ ] Secret scanning with push protection enabled
- [ ] SECURITY.md documents known-accepted risks

---

## Decisions and Rationale

| Decision | Reason |
|---|---|
| Ruleset over legacy branch protection | Personal repos cannot set bypass actors in legacy protection. Rulesets support `RepositoryRole` bypass — owner can push directly |
| `actor_id: 5` (Admin role) | Built-in repo role. Grants bypass to owner without naming specific users |
| Hooks in `.github/hooks/` not `.git/hooks/` | `.git/` is not committed. `.github/hooks/` is tracked and shared |
| `--no-verify` on bootstrap commit only | Hooks block themselves on first push — unavoidable one-time exception |
| `enforce_admins: true` not used | Replaced by ruleset. Legacy `enforce_admins: true` blocked even the owner with no bypass path |
| Auto-assign PR creator via Actions | GitHub has no native setting — Actions workflow needed. Explicit `pull-requests: write` permission required |
| yamllint config in `.yamllint.yml` | Committed config lets contributors reproduce results locally; not inline flags |
| `truthy.check-keys: false` | Permits `on:` key in GitHub Actions files without false positives |
| Docker advisory exits 0 | Enforcement is via CODEOWNERS review, not automated failure. Known patterns documented in SECURITY.md |
| `pull_request` not `pull_request_target` | `pull_request_target` runs with repo secrets and write access — dangerous with untrusted PR head code |
| Pin actions by commit SHA | Mutable tags can be silently overwritten; SHA pins are immutable |

---

## Security Note

`gh api` commands modify repo settings using the caller's auth token. Only users with **admin** access to the repo can apply these settings. Public visibility does not grant write or admin access — unauthenticated users get 403 on all PATCH/POST API calls.

---

## See Also

- [`notes/github-repo-standards.md`](../notes/github-repo-standards.md) — non-negotiable standards every repo must meet (PR auto-assign, branch auto-delete, lean workflow output)
