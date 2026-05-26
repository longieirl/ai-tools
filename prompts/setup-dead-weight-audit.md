---
name: setup-dead-weight-audit
description: Audit Claude setup files for dead-weight instructions and config entries that would not change output or behavior on a typical software task
tags: [meta, setup, maintenance]
---

# Setup Dead-Weight Audit

## Goal

Audit my Claude setup and identify instructions or configuration entries that produce no observable difference on a typical task.

For each flagged item:

- Show where it appears
- Explain why it is dead weight
- Classify the type of issue
- Assign a confidence level
- Recommend an action
- Provide cleaned-up versions of affected files

Prefer safe cleanup over aggressive minimization. Do not remove anything unless the reason is concrete.

## Files to Audit

Check all of these:

- `~/.claude/CLAUDE.md` and any files it `@`-includes
- `~/.claude/settings.json`
  - env vars
  - hooks
  - permissions
  - tool settings
  - other config entries
- `~/.claude/skills/*.md` and any subdirectories
- Any `context/` directory under `~/.claude/`
- Project-level `.claude/settings.local.json` in the current working directory
- Any `CLAUDE.md` in the current project root

Follow all file references and includes that are part of the Claude setup.

## Typical Task Definition

Use this definition when deciding whether an instruction changes observable output.

A typical software task includes:

- Code review
- Bug fix
- New feature implementation
- Refactor
- Git workflow
- Explaining code
- Writing or updating tests
- Reviewing configuration
- Debugging a local development issue

Do not evaluate against rare or unrelated tasks unless the setup clearly indicates they are important.

## Unit of Evaluation

Treat a discrete instruction as the smallest standalone rule, config entry, permission, hook, env var, or behavioral constraint that could be removed independently without breaking the surrounding text.

Do not over-fragment normal prose. If a paragraph contains one rule, audit it as one rule. If a paragraph contains multiple independent rules, audit each rule separately.

## Evaluation Method

For each discrete instruction, rule, or config entry, ask:

> "If I deleted this, would a senior developer reading my response on a typical software task notice anything different?"

Flag an item as dead weight if one or more of these are true:

- It restates Claude's default behavior without adding a specific constraint
- It is fully covered by a more specific instruction elsewhere in the same setup
- It only applies to a use case that is unrelated to the defined typical task set
- It is a comment, heading, or label with no actionable content
- It is an env var or config entry that duplicates a default
- It is an env var or config entry that has no observable mechanical effect
- It is duplicated elsewhere with no meaningful difference
- It is unreachable, invalid, unused, or points to a missing file
- It describes intent but does not change model behavior or tool behavior

Flag rarity-based dead weight only when there is evidence in the setup that the use case is not used, or when the item is clearly unrelated to the typical task definition.

## Do Not Flag

Do not flag:

- Instructions that prevent specific bad behaviors, even rare ones
- Anything security or privacy related, unless it is clearly duplicated, invalid, or mechanically ineffective
- Hook configurations solely because they are mechanical rather than behavioral
- Instructions that only seem redundant but handle a specific edge case the user would notice
- Comments that explain non-obvious security, privacy, permission, or hook behavior
- Low-confidence removals

For low-confidence cases, mark the item as `Verify manually` instead of removing it from the cleaned-up version.

## Hook, Env Var, Permission, and Config Rules

Audit hooks, env vars, permissions, and config entries as mechanical setup items.

Only flag them if there is concrete evidence that they are:

- Duplicated
- Invalid
- Unreachable
- Unused
- Equivalent to a default
- Pointing to missing files
- Mechanically ineffective
- Contradicted by another config entry

Do not flag a hook simply because it does not affect Claude's writing style. Hooks can have valid mechanical effects.

## Confidence Levels

For every flagged item, assign one of these confidence levels:

- `High`: Clear duplicate, inactive config, invalid entry, non-actionable comment, or obvious default restatement
- `Medium`: Likely dead weight, but there is some chance it affects a specific workflow
- `Low`: Possibly dead weight, but removal could change behavior in an edge case

Only remove `High` and `Medium` confidence items from cleaned-up versions.

Do not remove `Low` confidence items. Mark them as `Verify manually`.

## Output Format

### Section 1: Dead Weight Found

For each flagged item:

```text
FILE: path/to/file
LINE/SECTION: [line number or nearest section heading]
TYPE: [behavioral instruction | duplicate | inactive config | comment | env var | permission | hook | other config]
CONTENT: "[exact text if possible, otherwise precise paraphrase]"
REASON: [one sentence explaining why this changes nothing]
CONFIDENCE: [High | Medium | Low]
ACTION: [Remove | Consolidate | Keep but move | Verify manually]
```

For each item reviewed and explicitly kept:

```text
FILE: path/to/file
LINE/SECTION: [line number or nearest section heading]
CONTENT: "[exact text if possible, otherwise precise paraphrase]"
KEEP REASON: [one sentence explaining the specific behavior, edge case, security need, or mechanical effect this preserves]
```

### Section 2: Cleaned-Up Versions

For every file that had something flagged: show the full cleaned-up version with dead weight removed. No partial diffs — show the whole file so it is ready to paste in.

Mark any `Low` confidence items with a `<!-- Verify manually: [reason] -->` comment rather than removing them.

### Section 3: Summary

- Total instructions audited
- Total flagged
- Estimated reduction (lines or %)
- Any patterns noticed (e.g., "3 of 5 flagged items are restatements of defaults")

Tell the user: Run this audit against your global `~/.claude/` setup first. Review all `Verify manually` items before deleting any setup content.
