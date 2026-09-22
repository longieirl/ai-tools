---
name: dns-email-security
description: DNS email security records — DKIM, DMARC, CAA, MTA-STS, TLS-RPT — why each matters and how to implement them
tags: [dns, security, email, hosting]
---

# DNS Email Security

Every domain that sends or receives email needs these records. Without them: anyone can spoof your email address, your outgoing mail lands in spam, inbound mail can be intercepted, and rogue CAs can issue SSL certs for your domain.

## Why This Matters

- **No DMARC** = anyone on the internet can send email that appears to come from your domain. No receiving server will reject it by default.
- **No DKIM** = forwarded mail fails SPF and gets rejected. SPF breaks on forward; DKIM survives.
- **No CAA** = any certificate authority can issue an SSL cert for your domain. One compromised CA = HTTPS impersonation possible.
- **No MTA-STS** = inbound SMTP can be downgraded from TLS to plaintext by a network attacker.
- **No TLS-RPT** = you have no visibility when inbound mail TLS fails.

## Implementation Order

Always do DKIM first — DMARC alignment depends on it.

### 1. DKIM

Cryptographically signs outgoing mail. Receiving servers verify the signature to confirm the mail wasn't tampered with in transit.

**DirectAdmin:** E-mail Accounts → "DISABLE DKIM" button visible = already enabled. Toggle to enable if not.

**Verify (selector varies by panel — DirectAdmin default is `x`):**
```bash
dig x._domainkey.yourdomain.com TXT +short
```

### 2. DMARC

Tells receiving servers what to do when mail fails both SPF and DKIM checks.

**Start with quarantine, promote to reject after 2–4 weeks of monitoring RUA reports:**

```
_dmarc.yourdomain.com  TXT  "v=DMARC1; p=quarantine; sp=quarantine; rua=mailto:admin@yourdomain.com; fo=1"
```

**Phase 2 (after monitoring):**
```
v=DMARC1; p=reject; sp=reject; rua=mailto:admin@yourdomain.com; fo=1
```

### 3. CAA

Restricts which certificate authorities can issue SSL certs for the domain.

**Check current cert CA first:**
```bash
openssl s_client -connect yourdomain.com:443 2>/dev/null | openssl x509 -noout -issuer
```

**Add records (adjust CA name if not Let's Encrypt):**
```
yourdomain.com  CAA  0 issue "letsencrypt.org"
yourdomain.com  CAA  0 issuewild ";"
```

`issuewild ";"` blocks all CAs from issuing wildcard certs.

### 4. MTA-STS + TLS-RPT

Forces mail servers sending to you to use TLS. TLS-RPT collects reports when TLS fails.

**Requires a subdomain** `mta-sts.yourdomain.com` pointing to a directory where you can serve a static file.

**Policy file** at `https://mta-sts.yourdomain.com/.well-known/mta-sts.txt`:
```
version: STSv1
mode: testing
mx: mail.yourdomain.com
max_age: 86400
```

Start with `mode: testing`. Promote to `enforce` (and increase `max_age: 604800`) in Phase 2.

**DNS records:**
```
_mta-sts.yourdomain.com   TXT  "v=STSv1; id=YYYYMMDD"
_smtp._tls.yourdomain.com TXT  "v=TLSRPTv1; rua=mailto:admin@yourdomain.com"
```

Update the `id=` timestamp whenever the policy file changes.

### 5. DNSSEC — defer on shared hosting

Full zone signing requires automation. A single error breaks the entire zone. Only enable if the registrar supports one-click DNSSEC.

## Two-Phase Approach

**Phase 1 (immediate):** Enable DKIM, publish DMARC `p=quarantine`, add CAA, add MTA-STS `mode: testing`, add TLS-RPT.

**Phase 2 (after 2–4 weeks):** Check RUA reports for legitimate mail being quarantined. If clean, promote DMARC to `p=reject` and MTA-STS to `enforce`.

## Verification

```bash
dig _dmarc.yourdomain.com TXT +short
dig x._domainkey.yourdomain.com TXT +short
dig yourdomain.com CAA +short
dig _mta-sts.yourdomain.com TXT +short
dig _smtp._tls.yourdomain.com TXT +short
curl -s https://mta-sts.yourdomain.com/.well-known/mta-sts.txt
```

## Hosting Panel Notes

| Panel | DKIM location |
|-------|--------------|
| DirectAdmin | E-mail Accounts → Enable/Disable DKIM button (top right). Default selector: `x` |
| cPanel | Mail → Email Deliverability → enable per domain |
