---
name: security-audit
description: On-demand application security audit — OWASP Top 10, hardcoded secrets, CVEs, auth patterns, configuration weaknesses
tags: [security, audit]
---

# Security Audit

Comprehensive security analysis of application code. Covers common vulnerability patterns, dependency risks, and configuration weaknesses.

## Clarifications required before starting

Ask if not already provided:

1. **Scope** — full repo or specific directory/files?
2. **Tech stack** — language, framework, dependency manager (needed to check CVEs and framework-specific patterns)
3. **Entry points** — web API, CLI, background worker, or library? Determines which attack surfaces to prioritise.
4. **Known exceptions** — any findings already accepted/documented that should not be re-flagged?

---

## Step 1: Reconnaissance

```bash
# Identify languages and frameworks
find . -name "package.json" -o -name "requirements.txt" -o -name "go.mod" \
  -o -name "Gemfile" -o -name "pom.xml" -o -name "Cargo.toml" \
  | grep -v node_modules | grep -v ".git"

# Count lines by file type (scope assessment)
find . -type f | grep -v ".git" | grep -v node_modules \
  | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -20

# Entry points
find . -name "main.*" -o -name "app.*" -o -name "server.*" -o -name "index.*" \
  | grep -v ".git" | grep -v node_modules | head -20
```

---

## Step 2: Hardcoded Secrets

```bash
# Patterns that indicate hardcoded credentials
grep -rn \
  -e 'password\s*=\s*["\x27][^"\x27]\+["\x27]' \
  -e 'secret\s*=\s*["\x27][^"\x27]\+["\x27]' \
  -e 'api_key\s*=\s*["\x27][^"\x27]\+["\x27]' \
  -e 'token\s*=\s*["\x27][^"\x27]\+["\x27]' \
  -e 'BEGIN.*PRIVATE KEY' \
  -e 'AKIA[0-9A-Z]\{16\}' \
  --include="*.py" --include="*.js" --include="*.ts" --include="*.go" \
  --include="*.rb" --include="*.java" --include="*.env" --include="*.yml" \
  --include="*.yaml" --include="*.json" --include="*.toml" \
  . 2>/dev/null | grep -v ".git"
```

Check `.gitignore` covers: `.env`, `*.env`, `*.pem`, `*.key`, `secrets/`, `credentials*`

---

## Step 3: Injection Risks (OWASP A03)

### SQL injection
Look for string concatenation in database queries:
```bash
grep -rn \
  -e '"SELECT.*+\|"INSERT.*+\|"UPDATE.*+\|"DELETE.*+' \
  -e 'query(.*%s\|query(.*format(\|query(.*+' \
  -e 'execute(.*%s\|execute(.*format(' \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules
```

### Command injection
```bash
grep -rn \
  -e 'exec(\|system(\|popen(\|subprocess\|os\.system\|child_process\|shell=True' \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules
```

### Path traversal
```bash
grep -rn \
  -e 'open(.*request\|open(.*param\|open(.*input\|readFile.*req\.' \
  -e '\.\./\|path\.join.*req\.' \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules
```

### XSS
```bash
grep -rn \
  -e 'innerHTML\s*=\|dangerouslySetInnerHTML\|v-html\|\.html(\|\.write(' \
  -e '|safe\|mark_safe\|raw(' \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules
```

---

## Step 4: Authentication & Authorization (OWASP A01, A07)

Review for:
- Missing authentication checks on sensitive routes
- Hardcoded admin credentials or bypass conditions (`if user == "admin"`, `if debug`)
- Insecure password storage (MD5, SHA1, plain text — look for hash function calls)
- Missing CSRF protection on state-changing endpoints
- JWT `alg: none` or symmetric secrets in source

```bash
grep -rn \
  -e 'md5\|sha1\|sha256.*password\|hashlib\.md5\|hashlib\.sha1' \
  -e 'alg.*none\|algorithm.*none\|verify.*False\|verify_signature.*false' \
  -e 'admin.*==.*true\|isAdmin.*=.*true\|role.*=.*admin' \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules
```

---

## Step 5: Configuration Weaknesses (OWASP A05)

```bash
# Debug mode in production configs
grep -rn \
  -e 'DEBUG\s*=\s*True\|debug:\s*true\|NODE_ENV.*development\|flask\.run.*debug=True' \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules

# Overly permissive CORS
grep -rn \
  -e "origin.*\*\|Access-Control-Allow-Origin.*\*\|cors.*origin.*'\*'" \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules

# Missing security headers (check web framework config)
grep -rn \
  -e 'helmet\|CSP\|Content-Security-Policy\|X-Frame-Options\|HSTS\|Strict-Transport' \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules
```

---

## Step 6: Dependency CVEs (OWASP A06)

Run the appropriate tool for the detected stack:

```bash
# Node.js
npm audit --audit-level=moderate 2>/dev/null

# Python
pip-audit 2>/dev/null || safety check 2>/dev/null

# Go
govulncheck ./... 2>/dev/null

# Ruby
bundle audit 2>/dev/null

# Java (Maven)
mvn org.owasp:dependency-check-maven:check 2>/dev/null

# Rust
cargo audit 2>/dev/null
```

If no tool is available locally, note which packages need manual CVE lookup at https://osv.dev

---

## Step 7: Sensitive Data Exposure (OWASP A02)

```bash
# Logging sensitive data
grep -rn \
  -e 'log.*password\|log.*token\|log.*secret\|print.*password\|console\.log.*token' \
  -e 'logger\.\(info\|debug\|warn\).*password' \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules

# Sensitive data in error responses
grep -rn \
  -e 'traceback\|stack_trace\|e\.message\|err\.Error()\|exception.*response' \
  . 2>/dev/null | grep -v ".git" | grep -v node_modules
```

---

## Output

Report findings grouped by severity. For each finding:

```
[SEVERITY] Category — file:line
Description: what the vulnerability is
Evidence: the specific code or pattern found
Remediation: concrete fix with example if applicable
```

**Severity definitions:**
- **Critical** — direct exploit path, exposed credentials, unauthenticated RCE/SQLi
- **High** — likely exploitable with moderate effort (XSS, IDOR, auth bypass)
- **Medium** — exploitable under specific conditions or requires chaining
- **Low** — defence-in-depth gap, missing header, weak but not broken pattern
- **Info** — noteworthy but not a vulnerability (outdated but unpatched, unclear intent)

End with a **scorecard**:

```
Critical: N
High:     N
Medium:   N
Low:      N
Info:     N

Top priority: [top 3 findings to fix first]
```

---

## Constraints

- Do not modify any files during the audit — read only.
- Flag only confirmed or highly probable findings — avoid noise.
- Note false positive risk where grep matches may be benign.
- If a finding is already documented in SECURITY.md as a known-accepted risk, skip it.
