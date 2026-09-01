---
name: dns-audit
description: DNS security audit — SPF, DKIM, DMARC, CAA, MTA-STS, TLS-RPT, DNSSEC. Checks live DNS records and produces a prioritised remediation plan with verification commands. Creates a GitHub issue with findings.
tags: [security, dns, email, audit]
---

# DNS Security Audit

Audit a domain's DNS security posture against live records. Produces a status table, remediation steps in recommended order, and creates a GitHub issue.

## Clarifications required before starting

Ask if not already provided:

1. **Domain** — which domain to audit (e.g. `example.ie`)
2. **Repo** — which GitHub repo to file the issue against (owner/repo format)
3. **Hosting** — which control panel manages DNS and email? (DirectAdmin, cPanel, Cloudflare, AWS Route53, other?) Default: DirectAdmin if not specified. Affects DKIM setup instructions.
4. **Email provider** — cPanel mail only, Google Workspace, Microsoft 365, other? (determines DKIM sources)

---

## Step 1: Reconnaissance

```bash
DOMAIN=example.ie  # replace with target

# Core DNS records
dig $DOMAIN TXT +short       # SPF + other TXT
dig $DOMAIN MX +short        # mail servers
dig $DOMAIN A +short         # hosting IP
dig $DOMAIN NS +short        # nameservers

# Security records
dig _dmarc.$DOMAIN TXT +short

# DKIM — try common selectors
for sel in default mail cpanel google k1 s1 s2 selector1 selector2 dkim; do
  result=$(dig ${sel}._domainkey.$DOMAIN TXT +short 2>/dev/null)
  [ -n "$result" ] && echo "${sel}: ${result}" || echo "${sel}: (empty)"
done

# CAA
dig $DOMAIN CAA +short

# MTA-STS + TLS-RPT
dig _mta-sts.$DOMAIN TXT +short
dig _smtp._tls.$DOMAIN TXT +short

# DNSSEC
dig $DOMAIN DS +short

# TLS cert issuer (needed for CAA)
openssl s_client -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -issuer 2>/dev/null
```

---

## Step 2: Assess each record

Build a status table:

| Record | Status | Value |
|--------|--------|-------|
| SPF | ✅/⚠️/❌ | current value or — |
| DMARC | ✅/❌ | current value or — |
| DKIM | ✅/❌ | selector(s) found or none |
| CAA | ✅/❌ | current value or — |
| MTA-STS | ✅/❌ | current value or — |
| TLS-RPT | ✅/❌ | current value or — |
| DNSSEC | ✅/❌ | DS record present or not |

### SPF assessment rules
- ✅ `~all` is weak (softfail) — mail tagged but not rejected. Note as ⚠️ Weak, recommend `-all`.
- ✅ `-all` is correct hardfail.
- ❌ missing or `+all` is a critical gap (`+all` allows every IP on the internet to send as the domain).
- If `include:_spf.google.com` present → Google Workspace in use, DKIM needed from Google Admin too.
- If `include:` for Microsoft/SendGrid/Mailchimp etc present → note each as a DKIM source.

### DKIM assessment rules
- Check whether domain has multiple mail sources (cPanel server mail, Google Workspace, M365, etc.)
- Each source requires its own DKIM key — note all required.
- DKIM is prerequisite for DMARC alignment on forwarded mail (SPF breaks on forward; DKIM survives).

### DNSSEC assessment rules
- If no DS record: defer unless registrar supports one-click automation. Single misconfiguration breaks entire zone.
- High risk on shared cPanel hosting — note as "defer".

---

## Step 3: Generate remediation plan

Produce concrete remediation steps for each missing/weak record. Tailor to detected hosting/email provider.

### SPF hardening (if `~all`)
```
# Update existing TXT record on @
v=spf1 [existing includes] -all
```
Do this after DKIM is confirmed working.

### DKIM setup

**DirectAdmin hosting (server-generated mail):**
Email → DKIM Keys → enable for domain. DirectAdmin generates the key pair. Note selector name then verify:
```bash
dig <selector>._domainkey.DOMAIN TXT +short
```
⚠️ If DNS is managed externally (nameservers not at the same host), DirectAdmin enables signing but cannot auto-publish the TXT record. Go to Email → DKIM Keys → View public key, copy the full TXT value, then add it manually in your external DNS control panel as `<selector>._domainkey.DOMAIN`.

**cPanel hosting (server-generated mail):**
Mail → Email Deliverability → Enable DKIM. cPanel auto-generates key and publishes TXT. Note selector name then verify:
```bash
dig <selector>._domainkey.DOMAIN TXT +short
```
⚠️ Same external DNS caveat applies as DirectAdmin above.

**Google Workspace:**
Google Admin → Apps → Google Workspace → Gmail → Authenticate email → Generate new record. Publish TXT in DNS.

**Microsoft 365:**
Microsoft 365 Admin → Settings → Domains → DKIM. Enable and publish the two CNAME records shown.

### DMARC (publish after DKIM confirmed)
```
_dmarc.DOMAIN  TXT  "v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:admin@DOMAIN; fo=1"
```
Monitor RUA reports 2–4 weeks, then promote to `p=reject; sp=reject`.

### CAA
```bash
# Verify cert issuer first
openssl s_client -connect DOMAIN:443 2>/dev/null | openssl x509 -noout -issuer
```
Then publish (adjust CA name to match issuer):
```
DOMAIN  CAA  0 issue "letsencrypt.org"
DOMAIN  CAA  0 issuewild ";"
```

### MTA-STS + TLS-RPT
Requires `mta-sts.DOMAIN` subdomain with HTTPS + policy file.

DNS records:
```
_mta-sts.DOMAIN   TXT  "v=STSv1; id=YYYYMMDD"
_smtp._tls.DOMAIN TXT  "v=TLSRPTv1; rua=mailto:admin@DOMAIN"
```

Policy file at `https://mta-sts.DOMAIN/.well-known/mta-sts.txt`:
```
version: STSv1
mode: testing
mx: mail.DOMAIN
max_age: 86400
```
Start `mode: testing`, promote to `enforce` after validation.

---

## Step 4: Recommended order

Always recommend in this order (dependencies flow top to bottom):

1. Enable DKIM for each mail source
2. Harden SPF `~all` → `-all`
3. Publish DMARC `p=quarantine`, monitor 2–4 weeks
4. Add CAA records
5. Add MTA-STS `mode: testing`, promote to `enforce`
6. Promote DMARC to `p=reject`
7. Evaluate DNSSEC only if registrar automates it

---

## Step 5: Verification commands

Always include at the end of the report:

```bash
dig DOMAIN TXT +short
dig _dmarc.DOMAIN TXT +short
dig <selector>._domainkey.DOMAIN TXT +short
dig DOMAIN CAA +short
dig _mta-sts.DOMAIN TXT +short
dig _smtp._tls.DOMAIN TXT +short
```

---

## Step 6: Create GitHub issue

Create the issue using `gh issue create` with:
- Title: `chore(dns): add missing DMARC, DKIM, CAA, MTA-STS records`
- Label: `security`
- Body: full audit report (current state table + all remediation steps + recommended order + verification commands)

```bash
gh issue create \
  --repo owner/repo \
  --title "chore(dns): add missing DMARC, DKIM, CAA, MTA-STS records" \
  --label "security" \
  --body "..."
```

---

## Constraints

- Read-only — do not modify any DNS records, files, or configuration.
- Flag only records confirmed missing or misconfigured — do not flag records that are correctly set.
- Tailor DKIM instructions to the actual mail providers detected from SPF `include:` entries.
- Do not recommend DNSSEC unless registrar automation is confirmed available.
