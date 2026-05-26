---
name: setup-dead-weight-audit
description: Audit Claude setup files for dead-weight instructions — anything that wouldn't change output on a typical task
tags: [meta, setup, maintenance]
---

# Setup Dead-Weight Audit

Goal: find every instruction in my Claude setup that produces no observable difference on a typical task, flag it, explain why it's dead weight, and show a cleaned-up version.

## Files to Audit

Check all of these:

- `~/.claude/CLAUDE.md` and any files it `@`-includes
- `~/.claude/settings.json` — every env var, hook, and permission entry
- `~/.claude/skills/*.md` and any subdirectories
- Any `context/` directory under `~/.claude/`
- Project-level `.claude/settings.local.json` in the current working directory
- Any `CLAUDE.md` in the current project root

## Evaluation Method

For each discrete instruction, rule, or config entry, ask:

> "If I deleted this, would a senior developer reading my response on a typical software task notice anything different?"

**Typical task** = code review, bug fix, new feature, refactor, git workflow, explaining code.

**Flag as dead weight if any of these are true:**

- It restates Claude's default behavior (e.g., "write clean code", "be concise")
- It's covered by a more specific instruction elsewhere in the same file
- It only applies to a use case that never or rarely occurs in this setup
- It's a comment or label with no actionable content
- It's an env var or config that duplicates a default or has no effect

**Do NOT flag:**

- Instructions that prevent specific bad behaviors (even rare ones)
- Anything security or privacy related
- Hook configurations (they have mechanical effects, not just behavioral)
- Instructions that only seem redundant but handle a specific edge case the user would notice

## Output Format

### Section 1: Dead Weight Found

For each flagged item:

```
FILE: path/to/file
LINE/SECTION: [line number or section heading]
CONTENT: "[exact text or paraphrase]"
REASON: [one sentence — why this changes nothing]
```

### Section 2: Cleaned-Up Versions

For every file that had something flagged: show the full cleaned-up version with dead weight removed. No partial diffs — show the whole file so it's ready to paste in.

### Section 3: Summary

- Total instructions audited
- Total flagged
- Estimated reduction (lines or %)
- Any patterns noticed (e.g., "3 of 5 flagged items are restatements of defaults")
