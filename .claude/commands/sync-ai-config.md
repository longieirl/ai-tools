Sync this project's AI config files from https://github.com/longieirl/ai-tools.

## Steps

**1. Fetch latest behavioral guidelines**

Run:
```bash
curl -fsSL https://raw.githubusercontent.com/longieirl/ai-tools/main/.agent/global-claude.md \
  -o /tmp/ai-tools-global-claude.md
```

**2. Write to `.agent/global-claude.md`**

Create `.agent/` if it doesn't exist, then write the fetched content to `.agent/global-claude.md`.

**3. Update `CLAUDE.md`**

Check the current state:
- No `CLAUDE.md` → create with `@.agent/global-claude.md` as the first line
- Has `@.agent/global-claude.md` already → no change needed
- Has `@~/.claude/global-claude.md` → replace that line with `@.agent/global-claude.md`
- Has `CLAUDE.md` but neither import → prepend `@.agent/global-claude.md` followed by a blank line and `---` before the existing content

Never remove or modify any other content in `CLAUDE.md`.

**4. Update `AGENTS.md`**

Fetch the canonical template:
```bash
curl -fsSL https://raw.githubusercontent.com/longieirl/ai-tools/main/AGENTS.md \
  -o /tmp/ai-tools-agents.md
```

- No `AGENTS.md` → write the fetched content as-is
- `AGENTS.md` exists → leave it unchanged (it may have project-specific customisation)

**5. Commit**

Stage only files that actually changed:
```bash
git add .agent/global-claude.md
git add CLAUDE.md 2>/dev/null || true
git add AGENTS.md 2>/dev/null || true
git diff --cached --quiet || git commit -m "chore: sync AI config from longieirl/ai-tools"
```

If nothing changed, report "Already up to date."

**6. Report**

List each file and whether it was created, updated, or unchanged.
