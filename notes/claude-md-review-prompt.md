# CLAUDE.md & Skills Diagnostic Review

## What This Does

Before changing anything, study how we have worked together, identify where things repeatedly go wrong, identify what is repeatedly asked, identify where tokens are wasted, and produce an evidence-based report to redesign global CLAUDE.md and skills.

## Governing Principle

**Do not add a rule unless there is evidence it solves a recurring problem.**

This applies to every phase. The goal is a smaller configuration that produces fewer correction cycles — not a comprehensive list of every preference and edge case encountered. A shorter CLAUDE.md with fewer correction turns saves considerably more tokens than telling Claude to "be concise".

## Process Flow

```text
Current CLAUDE.md
        │
        ▼
Phase 1: Diagnostic analysis
        │
        ▼
Phase 2: Design architecture (four buckets)
        │
        ▼
Phase 3: Design new CLAUDE.md
        │
        ▼
Phase 4: Design skills
        │
        ▼
Phase 5: Regression test against historical interactions
        │
        ▼
Phase 6: Finalise and adopt
        │
        ▼
You decide what to implement
```

---

> **Phase:** Execute Phase 1 only in this invocation. Treat Phases 2–6 as the planned subsequent workflow — do not execute them unless explicitly instructed. No new CLAUDE.md or skills to be created yet.
>
> **Driver:** Company daily token limit introduced. Goal: improve response quality and consistency while reducing unnecessary token consumption. All existing global skills deleted — redesign from evidence.

## Objectives

This is an optimisation of the overall Claude operating model, not just a CLAUDE.md rewrite.

```text
                Claude workflow
                     │
      ┌──────────────┼──────────────┐
      ▼              ▼              ▼
 Instructions      Skills       Model choice
      │              │              │
      └──────────────┼──────────────┘
                     ▼
              Task execution
                     │
                     ▼
           Quality / tokens / time
```

The final report should answer four questions:

1. What instructions should Claude always follow?
2. What workflows deserve skills?
3. Which model should handle each type of work?
4. How should the workflow minimise total token consumption while maintaining quality?

Specific outputs:

1. Minimal, well-structured, evidence-based global CLAUDE.md
2. Small, high-value set of Claude skills for recurring workflows
3. Task-to-model routing recommendations
4. Token-reduction recommendations without quality loss
5. Clear understanding of failure modes that repeatedly caused corrections

---

## 1. Establish the Baseline

Use current global CLAUDE.md as starting reference. Do not assume it is correct or should be preserved. Analyse objectively:

- What is useful and should probably be retained
- What is redundant
- What is too vague to be reliably followed
- What is overly prescriptive
- What potentially increases token consumption without sufficient benefit — including instructions that trigger unnecessary analysis steps or produce verbose output
- What important behavioural requirements are missing
- Any conflicting or ambiguous instructions

Also assess approximate token cost of the CLAUDE.md itself. Instructions loaded on every turn have a per-turn cost; vague or redundant instructions that cause additional processing have an output cost multiplier.

Treat existing CLAUDE.md as baseline, not desired end state.

---

## 2. Analyse Claude Interaction History

Locate and analyse available Claude conversation history on machine, including relevant data under `/Users/UserId`.

First determine what conversation/history data is actually available and what format it uses.

Do not assume every file under this location represents a conversation. Identify relevant data sources before analysing them.

Analysis should be based primarily on actual interaction history, not generic advice about prompt engineering or Claude configuration.

### Staged Analysis Strategy

Do not attempt to load the entire conversation history into context at once. Exhaustive ingestion defeats the purpose of a token-efficiency exercise.

Use this staged approach:

1. **Inventory first.** Identify available history, estimate total volume and time span. Report what exists before analysing any of it.
2. **Categorise by metadata.** Identify recurring task categories from titles, timestamps, or directory structure — without deep-reading individual conversations.
3. **Sample broadly.** Select a representative sample across categories and time periods. Breadth first.
4. **Deep-analyse selectively.** Focus depth on conversations most likely to reveal recurring failures or repeated workflows. Expand sample only where needed to establish confidence.
5. **Stop when signal flattens.** If additional conversations add no new patterns, stop.

Goal: extract maximum useful signal using minimum necessary analysis.

Where history is too large to analyse fully, explicitly state what was sampled, what was excluded, and how that affects confidence in conclusions.

---

## 3. Identify Recurring Failure Modes

Most important part of analysis.

Identify recurring mistakes, misunderstandings, or undesirable behaviours in Claude's responses.

Group into meaningful failure-mode categories. For each category, report:

- Failure mode
- Description
- Approximate frequency
- Percentage of analysed interactions where possible
- Severity or impact
- Typical trigger/context
- Examples from interaction history
- What was subsequently corrected, clarified, or repeated
- Likely root cause
- Whether addressable through CLAUDE.md
- Whether better addressed through a skill
- Whether better addressed through how requests are formulated

Distinguish between:

- Systematic problems that occur repeatedly
- Occasional problems
- One-off mistakes that should not influence global configuration

Do not inflate importance of a problem because it occurred once.

Where exact frequency cannot be established, explicitly say so and explain how estimate was derived.

---

## 4. Identify Repeated Workflows and Opportunities for Skills

Look for things repeatedly asked of Claude.

Identify patterns such as:

- Repeated transformations or rewrites
- Repeated analysis workflows
- Repeated coding/development tasks
- Repeated research tasks
- Repeated validation or review processes
- Repeated formatting/output requirements
- Repeated sequences of instructions
- Tasks where same context is repeatedly explained
- Tasks where dedicated skill would produce better result

For each candidate skill, provide:

- Proposed skill name
- Problem it solves
- Evidence of repeated usage
- Estimated frequency
- What skill should do
- What should remain under CLAUDE.md instead
- Expected benefit
- Potential token-saving benefit
- Whether it is worth creating

Do not recommend a skill merely because something happened once.

### Skills Maintenance

Skills have their own token overhead — each invocation loads the skill content. Assess whether candidate skills are genuinely worth that overhead vs. a concise CLAUDE.md rule.

Also note: skills should be reviewed at each new model release. Newer models require less explicit instruction; skills written for older models may be over-specifying behaviour that is now default. The diagnostic should flag any existing skills that are likely candidates for simplification or removal at next model upgrade.

---

## 5. Analyse Token Efficiency

Token efficiency is a first-class requirement.

### Token Cost Structure

Before identifying inefficiencies, verify current pricing, caching, context-loading, MCP, effort, and model-selection behaviour against current Anthropic documentation. Do not treat the following as established facts — use them only as a starting framework to be confirmed or corrected during analysis:

- **Output tokens are significantly more expensive than input tokens.** Investing extra input tokens in a rich spec, detailed prompt, or explicit instruction often reduces total spend by avoiding expensive wrong output. Trimming input prompts is a low-leverage optimisation.
- **Cache reads are substantially cheaper than full input token reads.** Instructions that remain stable across turns benefit from caching. Anything that busts the cache restarts the cost clock.
- **Cache-busting actions are expensive.** The following may invalidate the prompt cache and rerun the full context at full cost: switching models mid-session, changing effort level mid-session, running `/compact`, and restarting Claude. Look for these patterns in the interaction history.
- **MCP servers are always-loaded context.** Each connected MCP server has a per-turn cost, whether used or not. `ENABLE_TOOL_SEARCH=true` (the default) enables dynamic loading — turning it off forces all servers to load immediately. Audit connected MCP servers as a first-order token cost.
- **Model selection has a significant cost spread** across model tiers. Identify whether tasks in the history are matched to appropriate model tiers.

### Patterns to Identify

Identify patterns causing unnecessary token consumption:

- Repeated context — same background re-explained across sessions
- Excessive explanations and verbose output
- Instructions that cause unnecessary analysis steps
- Workflows where Claude performs unnecessary steps
- **Repeated conversational corrections** — correcting Claude through follow-up messages rather than using `/rewind`. Each correction round-trip is expensive output tokens that could be avoided by rewinding and resending a clearer prompt.
- Poorly structured or underspecified prompts that lead to wrong implementations (the most expensive outcome — wrong output + rework)
- Tasks that could use a smaller, more targeted instruction or lower model tier
- Tasks where a skill could replace repeated prompt instructions
- **Undersized `max_tokens`** — truncates output mid-response and forces correction or retry turns, consuming more tokens total than a generously-sized initial request. Flag any evidence of `max_tokens` errors or truncated responses.
- **Effort level mismatch** — using `xhigh` or `max` effort on routine tasks (simple lookups, formatting, classification) consumes significantly more thinking tokens than the task warrants. `low` or `medium` effort on these tasks often delivers equivalent results at a fraction of the cost. Conversely, using `low` effort on complex reasoning tasks causes underspecified output and correction cycles.
- **MCP servers connected but rarely or never used** — constant context cost with no benefit
- **Sessions run to degradation** rather than using `/clear` + handoff file. `/compact` is lossy and itself burns tokens to produce a summary that may still be large and unfocused. Prefer deliberate session endings with a handoff document.
- **Model or effort level switched mid-session** — invalidates cache, reruns full context at full cost

For each significant issue, explain:

- Why it consumes additional tokens
- Whether cost is on input, output, or both
- Whether additional tokens provide useful value
- How it could be reduced
- Any quality trade-off

### Native Tooling to Consider

Before recommending skills to control verbosity, identify whether native output-style settings (`output_config` / response style preferences) could achieve the same result at zero maintenance cost. Skills add their own token overhead — native settings may be preferable.

Where token usage cannot be accurately measured from available history, do not invent numbers. Clearly distinguish measured data from qualitative assessment.

Also identify situations where reducing tokens too aggressively could reduce quality. Goal is optimisation, not minimum output.

---

## 6. Identify What Belongs Where

Clear classification of behavioural requirements:

**A. Global CLAUDE.md** — rules that should apply broadly across almost every interaction

**B. Skills** — reusable workflows that should only activate for specific tasks

**C. Individual prompts** — context or instructions that should remain task-specific

**D. Nothing** — instructions or behaviours providing insufficient value to justify maintaining them

CLAUDE.md must not become large collection of instructions that should actually live in skills or individual prompts.

---

## 7. Evidence and Confidence

Base conclusions on interaction history wherever possible.

For important findings, provide evidence and confidence levels:

- **High confidence:** repeatedly demonstrated in history
- **Medium confidence:** meaningful pattern but limited evidence
- **Low confidence:** plausible interpretation requiring validation

Do not manufacture precision.

If available Claude history is incomplete, state exactly what could and could not be analysed and how that affects conclusions.

---

## 9. Review Model Selection and Task-to-Model Routing

Analyse models used across historical interactions and determine whether model selection is appropriate for different task types.

Do not assume the most capable model is the best choice. Optimise for overall outcome: quality, reliability, latency, token consumption, and correction frequency.

### Inventory

First identify:

- Which models have been used
- How frequently each model was used
- What task types were performed with each model
- Whether model usage appears to have changed over time

If the history does not contain reliable model information, explicitly state this limitation rather than estimating unsupported figures.

### Task Classification

Classify interactions into meaningful categories:

- Simple questions and factual lookups
- Rewriting and editing
- Technical troubleshooting
- Software development
- Code generation
- Code review
- Complex reasoning
- Research
- Long-context analysis
- File/document analysis
- Planning and architecture
- Tasks involving external tools or agents
- Other recurring categories identified from history

### Per-Category Analysis

For each category, analyse where evidence permits:

- Models used
- Relative success rate
- Frequency of corrections or retries
- Frequency of model switching
- Approximate token consumption
- Whether initial response was accepted or required iteration
- Whether a more capable model provided meaningful additional value
- Whether a less capable model would probably have been sufficient

### Findings to Identify

- Cases where a less capable model would likely have been sufficient
- Cases where a stronger model appears justified
- Cases where model choice appears to have caused unnecessary cost or iteration
- Cases where model selection cannot be reliably determined from evidence

### Task-to-Model Recommendation Matrix

Produce a matrix:

| Task category | Recommended model tier | Recommended effort | Why | Confidence | Token/cost consideration | When to escalate |
| --- | --- | --- | --- | --- | --- | --- |

Recommendation should favour the least capable model at the lowest effective effort level that reliably completes the task to the required quality standard.

Use the following routing heuristic as a starting framework only. Do not treat these model recommendations as the expected answer — the purpose of the analysis is to discover the appropriate routing strategy from evidence. Validate, override, or replace based on observed history:

| Task characteristic | Suggested tier | Suggested effort |
| --- | --- | --- |
| Ambiguous requirements, architecture decisions, novel problems | Top tier | `high` or `xhigh` |
| Standard implementation, known patterns, test writing | Mid tier | `medium` or `high` |
| Code review of a diff | Mid tier | `high` (requires reasoning) |
| Search, extraction, reformatting, classification, simple Q&A | Low tier | `low` |
| Summarising output or generating a handoff document | Low tier | `low` |
| Planning / spec writing (input to next phase) | Top tier | `high` |
| Mechanical edits, renames, boilerplate generation | Mid or low tier | `low` |

Note: effort levels apply within a session and cannot be changed mid-session without busting the prompt cache. Set effort at session start to match the dominant task type for that session.

### Model Routing Mechanisms

Identify which routing mechanism is most appropriate for each workflow pattern found in the history:

**1. Per-session model + effort selection** — start each session with the right model and effort level for the phase (e.g. plan in Opus at `high`, implement in Sonnet at `medium`). No cache busting; both are fixed at session start. Best for deliberate phase handoffs.

**2. Skills with model metadata** — skills can declare a preferred model in frontmatter. Low-complexity skills (summarise, reformat, lookup) automatically use a cheaper model without manual decision. Effort level should also be considered when designing skills — a summarisation skill at `xhigh` wastes tokens.

**3. Subagent routing in workflows** — workflow scripts support per-agent model and effort override, allowing different stages of the same task to use different models and effort levels automatically. Most powerful option; appropriate for multi-step pipelines.

**4. Explicit session handoff** — finish planning, write a spec file, start a fresh session at a lower model tier and effort level seeded with the spec. Manual but requires no tooling.

For each candidate workflow identified in the history, recommend which mechanism is most appropriate, what model tier and effort level each stage should use, and estimate the likely cost saving.

Include model selection as a separate section of the final HTML report and in the final recommendations.

---

**Prioritisation note:** Do not spend analysis tokens validating every instruction in this prompt. Prioritise the actual historical evidence. The prompt provides structure, not a checklist to audit.

---

Output: detailed HTML report.

Structure:

1. Executive summary
2. Scope and methodology
3. Data sources analysed
4. Current CLAUDE.md assessment
5. Failure-mode analysis
6. Failure-mode frequency and severity
7. Recurring workflows
8. Candidate skills
9. Token-efficiency analysis
10. Model selection and task-to-model routing
11. CLAUDE.md vs skill vs prompt vs model recommendations
12. Highest-priority improvements
13. Lower-priority or speculative improvements
14. Evidence limitations
15. Recommended next phase

Include tables and visualisations where they materially improve understanding.

Report should make it easy to answer:

- What are Claude's biggest recurring problems?
- How often do they happen?
- Why are they happening?
- Which problems can CLAUDE.md solve?
- Which problems require skills?
- Which problems are better solved through better individual prompts?
- Which problems are better solved through different model selection?
- What should stop being in global instructions?
- Where are tokens being wasted?
- What changes give greatest improvement for least complexity?
- Which session habits (model switching, skipping `/clear`, conversational corrections) are causing the most unnecessary spend?
- Are MCP servers and always-loaded context proportionate to their actual usage?
- Which task types are using a more capable model than necessary?
- Where would a routing strategy (different models for different stages) reduce cost without reducing quality?

**Do not create replacement CLAUDE.md or skills yet.** End with prioritised recommendations for next phase.

Optimise for evidence, simplicity, maintainability, and token efficiency — not maximising number of rules or skills.

---

## Phase 2: Turn Findings into a Design

Take the diagnostic report and produce a proposed architecture across four buckets:

| Bucket | Description |
| --- | --- |
| **Global CLAUDE.md** | Rules genuinely useful across almost all interactions |
| **Skills** | Repeatable workflows where explicit structure or tooling adds value |
| **Per-request instructions** | Task-specific context that should not pollute global config |
| **Remove** | Rules with little demonstrated value or unnecessary token/context overhead |

Key question: **"What is the minimum configuration that fixes the most important recurring problems?"**

Do not add a rule to any bucket unless there is evidence from Phase 1 that it addresses a recurring problem.

---

## Phase 3: Design the New CLAUDE.md

Produce a candidate CLAUDE.md. For each proposed rule, show:

| Field | Content |
| --- | --- |
| Current rule | The existing instruction (or "new") |
| Evidence | What in the history supports including it |
| Proposed replacement | The new formulation |
| Reason for inclusion | Why it belongs in global config, not a skill or prompt |
| Expected benefit | What failure mode it prevents |
| Token/context cost | Approximate overhead of loading this rule every turn |
| Priority | High / Medium / Low |

This structure prevents the new file becoming a large accumulation of instructions without demonstrated value.

---

## Phase 4: Design the Skills

Apply the same discipline to skills.

A skill should encapsulate a **workflow** — not become another place to put general behavioural instructions. If the analysis finds repeated tasks (e.g. reviewing communications, researching technical topics, producing structured documentation, code review), decide for each:

- Does it have a distinct enough workflow to justify a skill?
- Or is a single CLAUDE.md rule sufficient?
- What is the token overhead of the skill itself vs. the saving it produces?

Skills have their own invocation cost. A skill that saves 200 tokens but costs 150 tokens to load is marginal. A skill that prevents a 2000-token rework cycle is high value.

---

## Phase 5: Regression Test Before Adopting

Take 20–50 representative historical interactions where Claude previously made mistakes or required correction.

Run the candidate configuration against them and compare:

- Did the original failure occur?
- Did the new configuration prevent it?
- Did it introduce a new problem?
- Did response length change?
- Did it require fewer correction turns?
- Did it require less repeated context?

This provides a crude but useful regression test. Do not adopt the new configuration without this step.

---

## Phase 6: Finalise

Only after Phase 5 passes:

1. Replace the global CLAUDE.md
2. Create selected skills
3. Remove redundant instructions
4. Establish a lightweight process for adding new rules — **only when a recurring failure justifies them**

Target end state:

```text
Global CLAUDE.md       → small set of universal behaviours
Skills                 → specific repeatable workflows only
Individual prompts     → task-specific context
Historical tests       → regression protection
```
