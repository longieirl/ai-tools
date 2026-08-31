---
name: update-all
description: Update everything — global commands, behavioral guidelines, marketplace plugins, and local-install skills
tags: [maintenance, update]
---

# Update All

Brings all AI tooling up to date in one pass.

## Steps

### 1. Global commands + behavioral guidelines

```bash
curl -fsSL https://raw.githubusercontent.com/longieirl/ai-tools/main/tools/setup-claude.sh | bash
```

Report: list every file updated and confirm `~/.claude/global-claude.md` was refreshed.

### 2. Marketplace plugins

Run the built-in plugin update:

```
/plugin update
```

If `/plugin update` is unavailable in this session, instruct the user to run it manually in a fresh Claude Code session.

### 3. Local-install skills

These must be updated manually. Print the following commands for the user to run:

```bash
# impeccable
npx impeccable@latest install

# GSD Redux
npx @opengsd/get-shit-done-redux@latest
```

For skills installed via git clone (taste-skill, emil-design-eng), print:

```
taste-skill and emil-design-eng were installed by cloning into .claude/skills/.
Re-clone from their upstream source to update. Check the source URL in each skill's frontmatter.
```

### 4. Project config (optional)

If run inside a project that has an `AGENTS.md` or `CLAUDE.md` wired to longieirl/ai-tools, also sync:

```bash
curl -fsSL https://raw.githubusercontent.com/longieirl/ai-tools/main/tools/sync-project.sh | bash
```

## Report format

When done, summarise:

```
✓ Global commands updated   (list files)
✓ global-claude.md updated  (show # headings)
✓ /plugin update run        (or: manual step required)
  Local skills              (list npx commands printed)
  Project sync              (done / skipped)
```
