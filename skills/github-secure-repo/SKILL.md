---
name: github:secure-repo
description: Audit and harden GitHub repository security using rulesets, branch protection, CODEOWNERS, secret scanning, access controls, and GitHub Actions security.
tags:
  - github
  - security
  - devops
  - repository-hardening
---

# GitHub: Secure Repo

## Purpose

Audit and harden a GitHub repository using GitHub CLI (`gh`), GitHub REST API, repository configuration files, and documented GitHub security capabilities.

Support two operating modes:

- **Audit:** Inspect configuration, identify gaps, and produce recommendations without changing settings.
- **Harden:** Apply an agreed security baseline, verify every change, and report unresolved gaps.

Default to audit mode. Never modify repository settings, permissions, rulesets, workflows, or files until the user authorizes the intended changes.

## Security Principles

1. Preserve existing configuration unless a change is explicitly approved.
2. Prefer least privilege, enforceable controls, and auditable changes.
3. Prefer repository or organization rulesets for new branch protection configurations where supported. Retain compatible existing branch protection rules unless migration is explicitly approved.
4. Never assume a feature is available based on repository visibility alone. Check ownership, plan, permissions, and feature availability.
5. Do not expose, print, commit, or transmit secret values.
6. Verify the effective configuration after every mutation.
7. Report unsupported, unverified, and partially applied controls explicitly.

## Phase 1: Establish Repository Context

Identify the target repository and confirm the current GitHub identity.

```bash
gh auth status
gh repo view --json nameWithOwner,url,visibility,defaultBranchRef,isPrivate
gh api repos/OWNER/REPO
```

Replace `OWNER/REPO` with the verified repository identifier.

Inspect:

- Repository owner type: personal account or organization.
- Public, private, or internal visibility.
- Default branch and existing branch protection.
- Existing repository and organization rulesets.
- Collaborators, teams, outside collaborators, and access levels.
- GitHub Actions settings and workflow permissions.
- Existing security alerts and available security features.
- Repository permissions and API errors.

Use read-only requests during discovery. Check organization-level policies where permissions allow.

If the target repository is ambiguous, ask the user to select it. Do not infer the target from the current working directory without verification.

## Phase 2: Audit the Security Baseline

### 2.1 Branch and Tag Protection

Inspect branch protection and applicable rulesets.

```bash
gh api repos/OWNER/REPO/branches/BRANCH/protection
gh api repos/OWNER/REPO/rulesets
```

Evaluate the default branch for:

- Pull requests required before merging.
- At least one approving review, with two for high-risk repositories where practical.
- Code owner approval for owned files.
- Dismissal of stale approvals when appropriate.
- Approval of the most recent reviewable push by someone other than its author.
- Required continuous integration (CI) status checks.
- Branch deletion and force-push restrictions.
- Administrator enforcement or documented bypass exceptions.
- Linear history, signed commits, and deployment requirements where appropriate.

Determine whether required status checks exist and represent the intended CI workflows. Do not invent check names or configure checks that cannot be verified.

Avoid requiring two reviewers when the repository has insufficient reviewers to make merging possible. Document any accepted exception.

### 2.2 Rulesets

Evaluate repository rulesets and, where accessible, inherited organization-level rulesets.

For a new ruleset, consider:

- Targeting the default branch and relevant release branches.
- Pull request requirements and required status checks.
- Required approvals and code owner review.
- Restrictions on force pushes and deletion.
- Appropriate bypass actors and bypass modes.
- Enforcement status and the effect on existing workflows.

Use `active` enforcement only after the user approves the configuration and its operational impact.

Use `evaluate` mode where supported and appropriate to assess impact before enforcement.

Do not create overlapping rulesets without understanding their combined effect. Do not remove existing branch protection as part of a ruleset migration without explicit approval.

### 2.3 CODEOWNERS

Check for CODEOWNERS in these supported locations:

- `.github/CODEOWNERS`
- `CODEOWNERS`
- `docs/CODEOWNERS`

Recommend `.github/CODEOWNERS` as the default location.

Validate that:

- Owners are real GitHub usernames or visible organization teams.
- Team owners have the required repository access.
- Patterns match the intended files.
- Sensitive paths, workflows, deployment configuration, and security policies have appropriate owners.
- The CODEOWNERS file itself has an explicit owner.

Do not invent team names or user accounts. Ask for missing ownership assignments.

Require code owner approval through branch protection or a suitable ruleset. A CODEOWNERS file alone does not enforce approval.

### 2.4 Secrets and Dependency Security

Inspect availability and configuration for:

- Secret scanning and push protection.
- Dependabot alerts and security updates.
- Dependency review for pull requests where available.
- Code scanning, including CodeQL where applicable.
- Security policy and vulnerability reporting.
- Existing unresolved security alerts.

Distinguish enabled, disabled, unavailable, and not verified states.

Public repositories receive secret scanning coverage under GitHub's applicable public-repository policy. Private repository features can require additional licensing or organization configuration.

Never claim that secret scanning or push protection is enabled without checking its effective state.

If a secret is discovered, do not print its value. Report the affected file, location, and secret type where safe. Recommend immediate revocation or rotation and removal from repository history where necessary. Deleting the file alone does not invalidate a leaked credential.

### 2.5 Access Controls

Review collaborators, teams, outside collaborators, and application access where permitted.

Recommend:

- Removing unnecessary write and administrative access.
- Using teams for organization-owned repositories.
- Restricting third-party application permissions.
- Reviewing deploy keys, personal access tokens, and GitHub App access.
- Enforcing organization-managed authentication policies where available.
- Retaining at least two trusted administrators for business-critical repositories where feasible.

Do not remove users, revoke credentials, or change organization membership without explicit approval.

### 2.6 GitHub Actions

Inspect repository workflow permissions and `.github/workflows/`.

Recommend:

- Setting the default `GITHUB_TOKEN` permission to read-only where practical.
- Granting explicit, minimal permissions to individual workflows and jobs.
- Pinning third-party actions to verified full-length commit SHAs.
- Avoiding untrusted pull request code execution with privileged tokens or secrets.
- Reviewing `pull_request_target`, deployment environments, and environment protection rules.
- Using protected environments for production deployments where appropriate.
- Avoiding secrets in logs, artifacts, command-line output, and generated files.

Do not rewrite workflows automatically. Identify risks and propose minimal changes for approval.

## Phase 3: Produce a Remediation Plan

Classify findings:

- **Critical:** Exposed credentials, unauthorized privileged access, or an immediately exploitable security weakness.
- **High:** Missing enforceable protection for critical branches or equivalent high-impact control failures.
- **Medium:** Missing defense-in-depth controls, incomplete review requirements, or excessive permissions without an identified immediate exploit.
- **Low:** Documentation gaps and lower-impact improvements.

For every finding, include:

- Observed configuration and evidence.
- Risk and practical impact.
- Recommended change.
- Dependencies and GitHub plan requirements.
- Expected operational impact.
- Verification procedure.

Separate confirmed findings from assumptions and inaccessible settings.

## Phase 4: Apply Approved Changes

Before modifying anything:

1. Present the proposed changes and identify their impact.
2. Obtain explicit approval for the requested mutation scope.
3. Record the current configuration so changes can be compared and, where possible, rolled back.
4. Confirm the authenticated identity has the necessary permissions.
5. Check for conflicting branch protection rules, inherited policies, and existing rulesets.

Apply changes incrementally using supported GitHub CLI commands or documented REST API endpoints.

For API operations, use the appropriate API version and payload schema documented by GitHub. Do not guess endpoint payloads or silently retry failed mutations with broader permissions.

Never:

- Disable existing security controls to make another change succeed.
- Grant broad administrator access as a workaround.
- Enable force pushes or branch deletion on protected branches as a default.
- Add unverified required status checks.
- Delete rulesets or remove collaborators without authorization.
- Claim success based only on an HTTP success response.

If an operation fails, preserve the existing configuration, explain the failure, and continue only with safe, independent audit tasks.

## Phase 5: Verify and Report

After each approved mutation:

1. Read the affected configuration again.
2. Compare the actual state against the intended state.
3. Check relevant branch protection and ruleset interactions.
4. Confirm that the configured rules target the intended branches.
5. Report any permission errors, plan restrictions, or unverified outcomes.
6. Confirm that no unrelated configuration was changed.

Produce a final report containing:

- Repository identifier and audit timestamp.
- Repository ownership and visibility.
- Security controls inspected.
- Findings grouped by severity.
- Changes applied and verification results.
- Features unavailable or not verified.
- Accepted exceptions and residual risks.
- Recommended follow-up actions.

Use explicit status labels: `PASS`, `FAIL`, `PARTIAL`, `UNAVAILABLE`, and `NOT VERIFIED`.

## GitHub Documentation

Use current official documentation as the source of truth:

- Rulesets: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets
- Available rules: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets
- Protected branches: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
- CODEOWNERS: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners
- Secret scanning: https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning
- GitHub Actions security: https://docs.github.com/en/actions/reference/security/secure-use

## Completion Criteria

The skill is complete when:

- The repository has been audited or the audit limitations are documented.
- Approved changes have been applied and verified.
- Existing configuration has been preserved outside the approved scope.
- All unresolved findings and accepted exceptions are reported.
- The final report accurately distinguishes verified controls from assumptions.
