---
name: vercel-agent-skills
description: Vercel's official collection of agent skills, installable with the skills.sh CLI (`npx skills add`) — the same installer used by taste-skill, emil-design-eng, and mattpocock-skills
tags: [skill, collection, vercel, skills-sh]
---

# Vercel Agent Skills

Vercel's official collection of agent skills. Installed with the skills.sh CLI (`npx skills add`), which scans a repo's `skills/` folder — the same mechanism several other entries here use (`taste-skill`, `emil-design-eng`, `mattpocock-skills`).

- **Type**: Agent-skills collection
- **Repo**: https://github.com/vercel-labs/agent-skills
- **Browse**: https://skills.sh/vercel-labs/agent-skills

## Install

```bash
npx skills add vercel-labs/agent-skills
```

Install a single skill from the collection by its install name:
```bash
npx skills add vercel-labs/agent-skills --skill "<skill-name>"
```

Skills are available to the agent automatically once installed; it invokes them when a relevant task is detected.

## When to Use

- You want Vercel's maintained, first-party agent skills in a project
- You already use `npx skills add` for other skills and want a consistent install path

## Update

Re-run the install command to pull the latest versions in place.
