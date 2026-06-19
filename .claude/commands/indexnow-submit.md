Submit URLs to search engines via IndexNow protocol.

**Default behaviour: fetch all URLs from the site's sitemap and submit them all.** This is the right choice for first-time submissions or full re-indexes. If the user says this is an update or only some pages changed, ask which URLs to submit instead.

## What you need

- **key**: your IndexNow API key (e.g. `abc123`)
- **host**: your domain (e.g. `www.example.com`)
- **keyLocation**: full URL to your hosted key file (e.g. `https://www.example.com/abc123.txt`)
- **sitemapUrl**: URL of the sitemap (e.g. `https://www.example.com/sitemap.xml`) — used to discover all URLs automatically

## Step 1 — Verify key file is live

Check HTTP status, content, and absence of redirects or HTML wrapping:

```bash
curl -i https://www.example.com/abc123.txt
```

Validate all of the following before proceeding:

- Response is `HTTP 200`
- Body contains the key value exactly (e.g. `abc123`) — no HTML, no whitespace padding
- No redirect chain (CDN or proxy misconfiguration can cause 403 even when URL appears reachable)

If any check fails, fix the key file before proceeding.

## Step 2 — Fetch URLs from sitemap

Fetch the sitemap and extract all `<loc>` URLs:

```bash
curl -fsSL https://www.example.com/sitemap.xml \
  | grep -oP '(?<=<loc>)[^<]+'
```

If the sitemap is an index (contains `<sitemap>` entries pointing to child sitemaps), fetch each child and repeat:

```bash
# fetch child sitemap URLs from index
curl -fsSL https://www.example.com/sitemap_index.xml \
  | grep -oP '(?<=<loc>)[^<]+'

# then for each child URL, e.g.:
curl -fsSL https://www.example.com/post-sitemap.xml \
  | grep -oP '(?<=<loc>)[^<]+'
```

Collect the full URL list before proceeding.

## Step 3 — Validate URLs before submission

Spot-check a sample of URLs to confirm they are indexable:

```bash
curl -I https://www.example.com/page-1
```

Check:

- `HTTP 200` (not 3xx, 4xx, 5xx)
- Not blocked by `robots.txt`
- Canonical URL matches the submitted URL
- Page is not marked `noindex`

Submitting non-indexable URLs wastes quota and creates confusing diagnostics.

## Step 4 — Single URL (GET, simpler)

For one URL, use the GET endpoint:

```bash
curl "https://api.indexnow.org/indexnow?url=https://www.example.com/page-1&key=abc123"
```

## Step 5 — Bulk submission (POST, preferred)

For multiple URLs, use the JSON POST endpoint. Build the `urlList` from the URLs collected in Step 2:

```bash
curl -s -w "\nHTTP %{http_code}\n" -X POST "https://api.indexnow.org/IndexNow" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d '{
    "host": "www.example.com",
    "key": "abc123",
    "keyLocation": "https://www.example.com/abc123.txt",
    "urlList": [
      "https://www.example.com/",
      "https://www.example.com/page-1",
      "https://www.example.com/page-2"
    ]
  }'
```

If there are more than 10,000 URLs, split into batches of 10,000 and submit each separately.

Expected: `HTTP 200` (empty body is normal — see Step 6).

## Step 6 — Interpret response

| Code | Meaning |
|------|---------|
| 200  | Accepted for processing. Crawling and indexing are not guaranteed. |
| 400  | Invalid request payload — check JSON format |
| 403  | Key validation failed — verify key file content and accessibility |
| 422  | Host, key location, or URL mismatch — all URLs must belong to declared host |
| 429  | Rate limit exceeded — back off and retry |
| 5xx  | Temporary IndexNow service issue — retry after several minutes |

## Step 7 — Retry strategy

| Code | Action |
|------|--------|
| 429  | Exponential backoff |
| 5xx  | Retry after several minutes |
| 403  | Verify key file is reachable and content matches key exactly |
| 422  | Verify host field and all URLs share the same origin |

## Step 8 — Verify in Bing

1. Go to `https://www.bing.com/webmaster/` → URL Inspection tool
2. Paste submitted URL and run inspection

Bing may show the URL as discovered, submitted, crawled, or indexed. Timing varies based on site authority, crawl budget, and page quality — do not expect a specific status within any fixed window.

Alternatively, search Bing directly:

```
site:www.example.com/page-1
```

## Step 9 — Check Bing Webmaster Tools submission history

1. Log in at `https://www.bing.com/webmaster/`
2. Navigate to **URL Submission** or **IndexNow** reporting (UI layout changes occasionally — look for either label)
3. Confirm submitted URLs appear in submission history

If URLs are absent after 24 hours, re-submit and check for `403`/`422` responses.

## Notes

- Submit up to 10,000 URLs per request; batch if sitemap exceeds that
- All URLs in a request must belong to the same verified host declared in `host`
- Key file must be UTF-8 encoded
- `keyLocation` is optional if the file is at `https://{host}/{key}.txt` (the default path)
- IndexNow propagates to Bing, Yandex, and other participating engines automatically
- `200` means the API accepted the request — crawling and indexing are not guaranteed
