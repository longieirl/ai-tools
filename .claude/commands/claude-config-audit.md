# Claude Code Global Configuration Audit

I want to audit my Claude Code usage and, based on evidence from that audit, redesign my global configuration and skills.

This is an evidence-gathering and analysis exercise first.

Do not modify my configuration, create skills, delete files, or change my Claude Code environment during this audit.

The final objective is to maximise useful development work per token while maintaining or improving output quality.

I use Claude Code daily as a senior developer and my company has introduced a daily token consumption limit.

## Known locations

The canonical global configuration is:

`dotfiles/claude/global-claude.md`

There is also:

`dotfiles/.agent/global-claude.md`

These may have diverged. Determine their relationship and which configuration Claude Code actually uses.

My Claude Code historical data is located under:

`$HOME/.claude`

Do not assume the directory structure. Discover the available data and determine what can actually be analysed.

Do not spend tool calls rediscovering the known configuration locations above.

## Phase 1: Establish the evidence base

First determine:

* Available historical datasets
* Date range
* Number of sessions or conversations where determinable
* Available metadata
* Relevant configuration files
* Data quality
* Missing or inaccessible data
* Whether the available data provides sufficient evidence for reliable conclusions

Do not analyse the data deeply yet.

Produce a concise Phase 1 findings report covering the above.

Then STOP.

Wait for my explicit approval before proceeding to Phase 2.

## Phase 2: Discover behavioural patterns

Analyse the historical interactions for recurring patterns.

Do not use a predefined failure taxonomy as evidence.

Derive the actual recurring patterns from the data.

Look for:

* Repeated corrections
* Repeated misunderstandings
* Repeated failed approaches
* Unnecessary work
* Inefficient tool usage
* Excessive context consumption
* Repeated explanations
* Incorrect assumptions
* Incomplete implementations
* Validation failures
* Workflow inefficiencies
* Configuration-related problems
* Tool limitations
* Environment-related problems
* Any other recurring behaviour supported by the evidence

For each significant pattern determine:

* What happened
* How frequently it occurred
* Evidence supporting it
* Whether it is systemic or isolated
* Likely root cause
* Potential prevention mechanism

Critically distinguish between:

* Claude behaviour
* Ambiguous user instructions
* Missing context
* Excessive context
* Tool limitations
* Repository state
* Environment configuration
* Workflow design
* Global configuration
* Project configuration
* Inherently difficult or non-deterministic tasks

Do not assume that a recurring problem should be solved through `CLAUDE.md`.

Do not convert a small number of examples into a systemic finding.

Do not fabricate precision.

Where exact frequency cannot be established, explicitly state that.

For significant findings, report evidence count and confidence level.

Produce a Phase 2 findings report.

Then STOP.

Wait for my explicit approval before proceeding to Phase 3.

## Phase 3: Identify optimisation opportunities

Using the validated findings from Phase 2, identify:

### Repeated workflows

Determine which activities I repeatedly perform with Claude Code.

For each meaningful recurring workflow assess:

* Frequency
* Repeatability
* Typical inputs
* Typical outputs
* Recurring failure modes
* Potential standardisation
* Whether a skill would provide measurable value
* Whether the skill's context cost would justify its benefit

Do not create a skill simply because a workflow occurs repeatedly.

Identify workflows that should not become skills.

### Token efficiency

Identify behaviours that unnecessarily consume tokens.

Consider:

* Excessive context loading
* Reading complete files unnecessarily
* Repeated file inspection
* Large command outputs
* Unnecessary repository exploration
* Excessive research
* Repeated explanations
* Repeated tool calls
* Poorly scoped searches
* Low-value persistent instructions
* Oversized skills
* Context that should be retrieved only when needed

For each meaningful optimisation identify:

* Current behaviour
* Cause
* Recommended change
* Expected token impact
* Expected quality impact
* Appropriate implementation location

### Configuration architecture

Determine what information should live in:

* Global `CLAUDE.md`
* Project-level instructions
* Skills
* Per-task prompts
* Workflow conventions
* Nowhere

Use this principle:

Persistent context should only exist when its repeated behavioural value exceeds its ongoing context cost.

Produce a Phase 3 findings report.

Then STOP.

Wait for my explicit approval before proceeding to Phase 4.

## Phase 4: Research and recommendations

Only now perform targeted research into current Claude Code practices where it can materially improve the recommendations.

Research areas may include:

* `CLAUDE.md`
* Skills
* Context management
* Token efficiency
* Tool usage
* Agent workflows
* Configuration architecture
* Persistent instructions
* Context minimisation

Prioritise current authoritative documentation.

Clearly distinguish:

* Findings from my historical usage
* Claude Code documented behaviour
* External research
* Your recommendations

Do not perform research that cannot materially affect the recommendations.

Before proposing any persistent instruction, apply this test:

1. What evidence justifies it?
2. What behaviour does it change?
3. How frequently will that behaviour occur?
4. What is its ongoing token cost?
5. Could the same result be achieved more efficiently elsewhere?

## Audit efficiency

The audit itself must be token-efficient.

Before processing large amounts of historical data, determine whether sampling, aggregation, metadata analysis, targeted retrieval, or staged analysis can produce equivalent conclusions at lower token cost.

Do not read every historical conversation in full if statistically meaningful conclusions can be reached through a more efficient approach.

Prioritise evidence capable of changing the final recommendation.

Do not spend tokens analysing information that cannot influence a decision.

## Final deliverable

After Phase 4, produce a detailed HTML report containing:

1. Executive summary
2. Data analysed and coverage
3. Methodology
4. Limitations
5. Current configuration analysis
6. Evidence-backed behavioural patterns
7. Frequency and confidence analysis
8. Root-cause analysis
9. Repeated workflow analysis
10. Token-efficiency analysis
11. Configuration architecture
12. Recommended global `CLAUDE.md` design
13. Recommended skills
14. Skills that should not be created
15. Global versus project-level recommendations
16. Token-efficient operating model
17. Risks and trade-offs
18. Prioritised recommendations
19. Open decisions
20. Supporting evidence

Use tables and charts only where they add analytical value.

Do not generate charts merely for presentation.

## Final decision gate

The HTML report is the only deliverable from this audit.

Do not implement any recommendation.

Do not modify:

* `global-claude.md`
* `.agent` configuration
* Skills
* Historical data
* Claude Code environment

The report should finish with:

* Recommended changes
* Evidence supporting each recommendation
* Expected benefit
* Token implications
* Changes explicitly rejected and why
* Decisions requiring my approval

Then stop and wait for further instructions.

## Core objective

The desired end state is not the largest configuration.

It is the smallest high-signal configuration and smallest set of high-value skills that produce a measurable improvement in my daily Claude Code workflow.

Optimise for behaviour improvement per token injected.
