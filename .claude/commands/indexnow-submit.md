Submit URLs to search engines via IndexNow protocol.

## What you need

- **key**: your IndexNow API key (e.g. `f630052f1cd74d2c98bf335ee0fa895d`)
- **host**: your domain (e.g. `www.example.com`)
- **keyLocation**: full URL to your hosted key file (e.g. `https://www.example.com/f630052f1cd74d2c98bf335ee0fa895d.txt`)
- **urlList**: one or more URLs on that host to submit

## Step 1 — Verify key file is live

Before submitting, confirm the key file exists and returns the correct key:

```bash
curl -fsSL https://www.example.com/f630052f1cd74d2c98bf335ee0fa895d.txt
```

Expected output: the key value exactly, e.g. `f630052f1cd74d2c98bf335ee0fa895d`

If the file is missing or returns wrong content, do not proceed — fix the key file first.

## Step 2 — Submit URLs

```bash
curl -s -o /dev/null -w "%{http_code}" -X POST "https://api.indexnow.org/IndexNow" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d '{
    "host": "www.example.com",
    "key": "f630052f1cd74d2c98bf335ee0fa895d",
    "keyLocation": "https://www.example.com/f630052f1cd74d2c98bf335ee0fa895d.txt",
    "urlList": [
      "https://www.example.com/",
      "https://www.example.com/page-1",
      "https://www.example.com/page-2"
    ]
  }'
```

## Step 3 — Interpret response

| Code | Meaning |
|------|---------|
| 200  | Accepted |
| 400  | Bad request — check JSON format |
| 403  | Key invalid or key file not accessible |
| 422  | URLs don't match declared host |
| 429  | Rate limited — retry later |

## Step 4 — Confirm submission accepted

Re-run with full response output to verify no silent errors:

```bash
curl -s -w "\nHTTP %{http_code}\n" -X POST "https://api.indexnow.org/IndexNow" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d '{
    "host": "www.example.com",
    "key": "f630052f1cd74d2c98bf335ee0fa895d",
    "keyLocation": "https://www.example.com/f630052f1cd74d2c98bf335ee0fa895d.txt",
    "urlList": [
      "https://www.example.com/"
    ]
  }'
```

Expected: `HTTP 200` (body is empty on success — that is normal).

## Step 5 — Verify indexing in Bing

Check Bing has received and processed the URL:

1. Go to `https://www.bing.com/webmaster/` → URL Inspection tool
2. Paste submitted URL and run inspection
3. Status should show "URL is on Bing" or "Submitted for crawling" within 24–48 hours

Alternatively, search Bing directly:

```
site:www.example.com/page-1
```

If the page appears in results, indexing succeeded.

## Step 6 — Check Bing Webmaster Tools (optional but recommended)

1. Log in at `https://www.bing.com/webmaster/`
2. Select your site → **URL submission** → **IndexNow**
3. Confirm submitted URLs appear in the submission history

If URLs are absent after 24 hours, re-submit and check for `403`/`422` errors.

## Notes

- Submit up to 10,000 URLs per request
- Key file must be UTF-8 encoded
- `keyLocation` is optional if the file is at `https://{host}/{key}.txt` (the default path)
- IndexNow propagates to Bing, Yandex, and other participating engines automatically
- `200` response means the API accepted the request, not that the page is indexed — use Step 5 to confirm indexing
