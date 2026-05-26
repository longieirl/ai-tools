# RTK — Rust Token Killer

> Filters and compresses command outputs before they reach LLM context.  
> Single Rust binary · 100+ commands · <10ms overhead · 60–90% token reduction

- **Repo**: https://github.com/rtk-ai/rtk
- **License**: Apache 2.0 · Free, no paid tier
- **Stars**: 54,000+

## Install

```bash
brew install rtk          # macOS (recommended)
rtk --version             # verify: "rtk 0.28.2"
rtk gain                  # verify: shows token savings stats
```

> Name collision: `cargo install rtk` installs Rust Type Kit (wrong). Use `brew install rtk` or `cargo install --git https://github.com/rtk-ai/rtk`.

## Wire up to Claude Code

```bash
rtk init -g    # writes hook into Claude Code settings
# restart Claude Code — done. git status auto-rewrites to rtk git status
```

Hook rewrites Bash tool calls only. Claude Code built-ins (`Read`, `Grep`, `Glob`) bypass it — use shell equivalents or call `rtk read` / `rtk grep` / `rtk find` directly.

## Token Savings (30-min session estimate)

| Command        | Standard  | RTK      | Savings |
|----------------|-----------|----------|---------|
| ls / tree      | 2,000     | 400      | -80%    |
| cat / read     | 40,000    | 12,000   | -70%    |
| grep / rg      | 16,000    | 3,200    | -80%    |
| git status     | 3,000     | 600      | -80%    |
| git diff       | 10,000    | 2,500    | -75%    |
| git log        | 2,500     | 500      | -80%    |
| git add/commit | 1,600     | 120      | -92%    |
| cargo/npm test | 25,000    | 2,500    | -90%    |
| pytest         | 8,000     | 800      | -90%    |
| **Total**      | **~118k** | **~24k** | **-80%**|

## Key Commands

```bash
rtk gain              # show token savings analytics
rtk gain --history    # command usage history with savings
rtk discover          # scan Claude Code history for missed RTK opportunities
rtk proxy <cmd>       # run command without filtering (debug)

rtk ls .              # optimized directory tree
rtk read file.rs      # smart file reading
rtk read file.rs -l aggressive  # signatures only (strips bodies)
rtk grep "pattern" .  # grouped search results
rtk find "*.rs" .     # compact find results
```

## How It Works

Four strategies per command type:
1. **Smart filtering** — removes noise (comments, whitespace, boilerplate)
2. **Grouping** — aggregates similar items (files by dir, errors by type)
3. **Truncation** — keeps relevant context, cuts redundancy
4. **Deduplication** — collapses repeated log lines with counts
