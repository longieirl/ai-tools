# Contributing

## How to contribute

1. Fork this repository.
2. Create a branch from `main`: `git checkout -b your-feature-name`.
3. Make your changes. Keep each PR to one logical change.
4. Run validation locally before pushing (see below).
5. Open a pull request against `main`.

## Local validation

```bash
# Validate YAML
pip install yamllint
yamllint -c .yamllint.yml .

# Validate GitHub Actions workflows
actionlint .github/workflows/*.yml
```

## Rules

- No secrets, credentials, API keys, tokens, passwords, private IP addresses, or
  personal environment paths in any committed file.
- Match existing code style and naming conventions.
- External contributors cannot merge — all PRs require owner review.

## Git hooks

After cloning, activate the shared git hooks:

    git config core.hooksPath .github/hooks
