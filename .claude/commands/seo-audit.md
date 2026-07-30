---
name: seo-audit
description: Comprehensive SEO audit — crawls the target site as a search engine, identifies technical, content, and AI search readiness issues, and produces a consolidated implementation roadmap with prioritised issues
tags: [seo, audit, technical-seo, content, ai-search]
---

# SEO Audit

Act as Googlebot, a search engine crawler, indexer, search quality evaluator, SEO Technical Lead, and Project Manager.

Your objective is to analyse a website exactly as a modern search engine would, generate a comprehensive audit, identify gaps and opportunities, and produce an implementation roadmap with consolidated issues.

## Inputs

Website URL:
[INSERT WEBSITE URL]

Optional Existing Audit Report:
[FULL-AUDIT-REPORT.md]

Optional Existing Issues:
[GitHub Issues]

---

## Phase 1: Search Engine Crawl & Analysis

Review the website as if you were:

- Googlebot
- Bingbot
- Search engine indexing systems
- Search ranking systems
- AI-powered search systems

Do not begin with a human UX review.

First determine what a crawler, indexer, and ranking system can discover, access, understand, and trust.

Analyse:

### 1. Crawlability

- robots.txt
- XML sitemaps
- Internal linking
- Crawl depth
- Redirects
- Broken links
- URL structure
- Canonicals
- Pagination

### 2. Indexability

- Meta robots
- X-Robots-Tag headers
- Canonicalisation
- Duplicate content
- Thin content
- Orphan pages
- Parameter handling
- Crawl budget considerations

### 3. Technical SEO

- Core Web Vitals
- Mobile friendliness
- HTTPS
- JavaScript rendering
- Structured data
- Open Graph
- hreflang
- HTTP status codes
- Image indexing signals

### 4. Content Understanding

- Topic coverage
- Topical authority
- Semantic relevance
- E-E-A-T signals
- Heading structure
- Internal content relationships
- Keyword targeting

### 5. Search Appearance

- Titles
- Meta descriptions
- Rich result eligibility
- Featured snippet opportunities
- Local SEO signals
- Knowledge graph opportunities
- Breadcrumbs

### 6. Site Architecture

- Information hierarchy
- Category structure
- Internal PageRank flow
- Topic clusters
- Navigation effectiveness

### 7. AI Search Readiness

- AI Overview suitability
- LLM discoverability
- Structured content
- Entity recognition
- Citation potential
- FAQ opportunities
- Retrieval friendliness

For every issue found provide:

- Severity
- Evidence
- Impact
- Recommended Fix
- Expected Benefit

---

## Phase 2: Audit Gap Analysis

If an audit report is provided:

Review the report and determine:

- Which findings are already covered
- Which opportunities are missing
- Which recommendations are incomplete
- Which improvements are implied but not explicitly recommended
- Which recommendations have become outdated
- Which recommendations overlap

Identify:

- Technical SEO gaps
- Content gaps
- Local SEO gaps
- Structured data gaps
- Performance gaps
- AI Search readiness gaps
- Conversion optimisation gaps

---

## Phase 3: Issue Review & Consolidation

If existing GitHub issues are provided:

Review all existing work.

Determine:

- Recommendations already covered
- Duplicate issues
- Overlapping issues
- Missing issues
- Opportunities for consolidation

Minimise issue count while preserving complete coverage.

Group related recommendations into larger implementation initiatives where practical.

---

## Phase 4: Implementation Issue Creation

Create new issues only where required.

For each issue provide:

- Title
- Category
- Summary
- Business Impact
- SEO Impact
- Technical Complexity (Low, Medium, High)
- Priority (Critical, High, Medium, Low)
- Dependencies
- Acceptance Criteria
- Recommended Implementation Steps

Categories:

- Technical SEO
- Crawlability & Indexability
- Structured Data
- Performance
- Content SEO
- Local SEO
- Internal Linking
- User Experience
- AI Search Readiness
- Conversion Optimisation

---

## Phase 5: Model Selection

Before producing recommendations:

1. Assess the task complexity.
2. Recommend the most appropriate LLM model(s).
3. Explain why.

Consider:

- Long-context processing
- Deep reasoning
- Gap analysis
- Dependency mapping
- Backlog optimisation
- Issue consolidation

Recommend a multi-model workflow if beneficial.

---

## Phase 6: Roadmap & Prioritisation

Produce output in this format:

---

# Executive Summary

- Crawlability Score (0–100)
- Indexability Score (0–100)
- Technical SEO Score (0–100)
- Content Quality Score (0–100)
- AI Search Readiness Score (0–100)
- Overall SEO Health Score (0–100)

---

# Model Selection

## Recommended Workflow

[Model selection rationale]

---

# Search Engine Findings

## What Search Engines Understand Well

## What Search Engines Struggle To Understand

## Ranking Risks

## Top 10 Issues Affecting Visibility

---

# Audit Coverage Review

## Already Covered

## Missing Coverage

---

# Issue Mapping

| Recommendation | Existing Issue | New Issue Required | Notes |
| -------------- | -------------- | ------------------ | ----- |

---

# Proposed New Issues

## Issue 1

[Full details]

## Issue 2

[Full details]

---

# Recommendations Not Worth Tracking

[List with rationale]

---

# Consolidation Opportunities

[Duplicate or overlapping work with recommended merges]

---

# Prioritised Roadmap

## Phase 1: Quick Wins

## Phase 2: High Impact Improvements

## Phase 3: Strategic Improvements

---

# Final Search Engine Verdict

Provide a concise summary of how the website is likely perceived by:

- Crawlers
- Indexers
- Ranking systems
- AI-powered search systems

Conclude with the five highest-impact actions that would improve organic visibility, indexing quality, and AI search readiness.
