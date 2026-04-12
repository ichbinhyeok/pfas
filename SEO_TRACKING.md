# SEO Tracking

This file is the operating log for Search Console-based SEO decisions on `waternextstep.com`.

It exists to answer one question on any given day:

`Are we still observing, or do we need to change something now?`

## Source Of Truth

- Primary property: `sc-domain:waternextstep.com`
- Primary source: Google Search Console MCP
- Secondary source: live page inspection with the Search Console URL Inspection API
- Site: `https://waternextstep.com`
- Sitemap: `https://waternextstep.com/sitemap.xml`

## How To Read The Data

- Search Console performance data lags. Always record the exact date range shown by GSC.
- When `Sitemaps` and `URL Inspection` disagree, trust `URL Inspection` first for page-level truth.
- Do not overreact to one-day rank swings on tiny impression counts.
- Treat `0 clicks` with fewer than `100` impressions as a distribution problem first, not a CTR problem first.

## Page Groups

### Group A. Core Manual High-Intent Guides

These are the pages that should prove the search wedge.

- `/guides/public-water-vs-private-well`
- `/guides/read-your-ccr`
- `/guides/test-first-vs-filter-first`
- `/guides/nsf-53-vs-58-pfas`
- `/guides/pfas-filter-annual-cost`
- `/guides/how-to-read-a-pfas-utility-notice`

### Group B. Result Pages

These can win long-tail demand, but they are not the primary wedge.

- `/public-water/*`
- `/private-well/*`

### Group C. Support Or Context Pages

These help trust and routing, but should not dominate early search learning.

- `/public-water-system/*`
- `/methodology`
- `/source-policy`
- `/compare/*`

### Group D. Non-Index Targets

- `/checker`

## Decision States

### 1. Observation

Stay in observation when all of these are true:

- GSC impressions are flat or rising over the last 7 to 14 days.
- At least one new page in Group A or Group B is getting indexed or tested.
- No core guide has been stuck in `Discovered - currently not indexed` for more than 7 days after being linked and submitted.
- The site still has fewer than `100` impressions over the last 28 days.

### 2. Surgical Fix

Move into surgical fix mode when any of these are true:

- Core manual guides in Group A are not being indexed while lower-value templates are being indexed.
- 7 to 14 day impressions flatten or fall while the indexed set is still tiny.
- Average position worsens because Google is testing weaker page groups instead of the intended wedge pages.
- A page that should be non-indexed starts getting treated like an index candidate.

What surgical fix means:

- Improve a small number of pages.
- Improve internal linking.
- Tighten indexation policy.
- Do not expand page count.

### 3. Structural Change

Move into structural change mode when any of these are true:

- Group A pages remain mostly unindexed after two full review cycles.
- More than half of impressions come from the wrong page group for two weeks in a row.
- Indexed pages are live, crawlable, internally linked, and still not chosen by Google.

What structural change means:

- Reconsider page purpose.
- Reconsider which templates should be indexable.
- Reconsider routing between guide, result, compare, and context pages.

## Daily Check

- Pull 28-day performance summary.
- Pull 7 to 10 day comparison against the previous period.
- Check top pages by impressions.
- Inspect 5 to 10 representative URLs across Group A, Group B, Group C, and Group D.
- Write one decision: `Observation`, `Surgical Fix`, or `Structural Change`.

## Weekly Questions

- Are the core guides becoming the search front door, or are result/context pages doing that job instead?
- Is Google learning the intended wedge, or sampling the wrong page family?
- Are we getting more indexed pages of the right kind, not just more indexed pages?
- Is the next change about page quality, internal links, or index policy?

## Log Template

Copy this block for each review.

```md
## YYYY-MM-DD

- GSC data through:
- 28d clicks:
- 28d impressions:
- 28d CTR:
- 28d average position:
- 7-10 day delta:
- Top pages by impressions:
- Core guides indexed:
- Core guides not indexed:
- Result pages indexed:
- Support/context pages indexed:
- Sitemap status:
- Decision:
- Reason:
- Today action:
- Next review date:
```

## Baseline

## 2026-04-12

- GSC data through: `2026-04-09`
- 28d clicks: `0`
- 28d impressions: `77`
- 28d CTR: `0`
- 28d average position: `11.35`
- Comparison window:
  - Current: `2026-04-01` to `2026-04-09`
  - Previous: `2026-03-23` to `2026-03-31`
- 7-10 day delta:
  - Impressions: `35 -> 42` (`+20.0%`)
  - Clicks: `0 -> 0`
  - Average position: `6.23 -> 15.62`

### Top Pages By Impressions

- `https://waternextstep.com/public-water/PA1510001` - `49` impressions, avg position `5.43`
- `https://waternextstep.com/public-water/NV0005027` - `12` impressions, avg position `7.33`
- `https://waternextstep.com/public-water-system/7360058` - `5` impressions, avg position `64.2`
- `https://waternextstep.com/private-well/MI` - `4` impressions, avg position `7.00`
- `https://waternextstep.com/guides/public-water-vs-private-well` - `3` impressions, avg position `35.33`
- `https://waternextstep.com/guides/read-your-ccr` - `2` impressions, avg position `27.00`
- `https://waternextstep.com/compare/private-well-certified-pou-after-test` - `1` impression, avg position `7.00`

### Core Guides Indexed

- `/guides/public-water-vs-private-well`
- `/guides/read-your-ccr`
- `/guides/how-to-read-a-pfas-utility-notice`

### Core Guides Not Indexed

- `/guides/test-first-vs-filter-first` - `URL is unknown to Google`
- `/guides/nsf-53-vs-58-pfas` - `URL is unknown to Google`
- `/guides/pfas-filter-annual-cost` - `URL is unknown to Google`
- `/guides/under-sink-vs-whole-house` - `URL is unknown to Google`

### Result Pages Indexed

- `/public-water/PA1510001`
- `/public-water/NV0005027`
- `/public-water/FL3590762`
- `/private-well/MI`

### Support Or Context Status

- `/public-water-system/7360058` - indexed
- `/compare/private-well-certified-pou-after-test` - indexed
- `/compare/nsf-53-vs-58-claim-examples` - `URL is unknown to Google`
- `/compare/pfas-filter-annual-cost-compare` - `URL is unknown to Google`
- `/compare/under-sink-certified-pfas-options` - `URL is unknown to Google`
- `/methodology` - `URL is unknown to Google`
- `/source-policy` - `URL is unknown to Google`
- `/checker` - blocked in `robots.txt` and intentionally non-index

### Sitemap Status

- Submitted sitemap: `https://waternextstep.com/sitemap.xml`
- Last submitted: `2026-04-11`
- Last downloaded by Google: `2026-04-11`
- GSC sitemap report still says `168 submitted / 0 indexed`
- Live sitemap includes the unknown core guide and compare URLs with `lastmod` values from `2026-03-20`
- Page-level inspection still contradicts the sitemap aggregate report, so page-level inspection remains the better signal

### Decision

`Surgical Fix`

### Reason

The site is getting tested, but Google is still learning the wrong front door.

- Impressions are rising, but almost all visibility still sits on result and support pages.
- The core search wedge is still under-indexed while lower-value route pages already have visibility.
- The main problem today is discovery, not CTR. The unknown guide and compare URLs return `200 OK`, exist in the live sitemap, and still are not in Google's candidate set.
- `/checker` is correctly non-index, but one indexed guide hub still pointed its strongest CTA at `/checker`, which weakens the guide-first signal.

### Today Action

- Remove the checker-first CTA from `/guides/public-water-vs-private-well` and point the primary handoff into the core guide stack.
- Add a dedicated core-guide handoff block to indexable `/private-well/*` pages so private-well state pages feed the high-intent guide and compare stack directly.
- Do not expand page count today.
- Do not spend time on title/meta CTR tuning today.

### Execution Log

- Switched `/guides/public-water-vs-private-well` from a checker-first primary CTA to a guide-first primary CTA.
- Added a `Guide-defined next lanes` section to `private-well` state pages that links directly into `test-first-vs-filter-first`, `nsf-53-vs-58-pfas`, `pfas-filter-annual-cost`, and `private-well-certified-pou-after-test`.

### Next Review Date

`2026-04-16`

## 2026-04-10

- GSC data through: `2026-04-07`
- 28d clicks: `0`
- 28d impressions: `66`
- 28d CTR: `0`
- 28d average position: `11.33`
- Comparison window:
  - Current: `2026-04-01` to `2026-04-09`
  - Previous: `2026-03-23` to `2026-03-31`
- 7-10 day delta:
  - Impressions: `35 -> 31` (`-11.4%`)
  - Clicks: `0 -> 0`
  - Average position: `6.23 -> 17.10`

### Top Pages By Impressions

- `https://waternextstep.com/public-water/PA1510001` - `43` impressions, avg position `5.33`
- `https://waternextstep.com/public-water/NV0005027` - `8` impressions, avg position `7.25`
- `https://waternextstep.com/private-well/MI` - `4` impressions, avg position `7.00`
- `https://waternextstep.com/public-water-system/7360058` - `4` impressions, avg position `65.5`
- `https://waternextstep.com/guides/public-water-vs-private-well` - `3` impressions, avg position `35.33`
- `https://waternextstep.com/guides/read-your-ccr` - `2` impressions, avg position `27.00`

### Core Guides Indexed

- `/guides/public-water-vs-private-well`
- `/guides/read-your-ccr`
- `/guides/how-to-read-a-pfas-utility-notice`

### Core Guides Not Indexed

- `/guides/test-first-vs-filter-first` - `Discovered - currently not indexed`
- `/guides/nsf-53-vs-58-pfas` - `Discovered - currently not indexed`
- `/guides/pfas-filter-annual-cost` - `Discovered - currently not indexed`

### Result Pages Indexed

- `/public-water/PA1510001`
- `/public-water/NV0005027`
- `/public-water/FL3590762`

### Support Or Context Status

- `/public-water-system/7360058` - indexed
- `/compare/private-well-certified-pou-after-test` - indexed
- `/methodology` - `Discovered - currently not indexed`
- `/checker` - `URL is unknown to Google`

### Sitemap Status

- Submitted sitemap: `https://waternextstep.com/sitemap.xml`
- Last submitted: `2026-04-01`
- Last downloaded by Google: `2026-04-02`
- GSC sitemap report still says `168 submitted / 0 indexed`
- Page-level inspection contradicts that report, so page-level inspection is the better signal right now

### Decision

`Surgical Fix`

### Reason

Google is indexing and testing the site, but the wrong page family is still doing most of the work.

- The strongest wedge pages are not the dominant pages yet.
- Several core manual guides are still discovered but not indexed.
- Result pages and one context page are collecting more visibility than the intended guide wedge.
- The indexed set is still too small to justify passive observation.

### Today Action

- Improve the four unindexed core guides first.
- Add stronger internal links from `/guides/read-your-ccr`, `/guides/public-water-vs-private-well`, and `/` into those core guides.
- Do not expand page count today.
- Do not do a broad template rewrite today.

### Execution Log

- Added a dedicated `search priority guides` cluster to the homepage so the four target guides are visible without opening the collapsed guide list.
- Added a `Priority decision guides` section to guide pages so indexed guides now link directly into the four target guides from the main body, not only from the right-rail collapse.
- Rewired guide CTAs to reduce reliance on `/checker` from indexed hub guides and to create a tighter internal-link cluster across:
  - `/guides/test-first-vs-filter-first`
  - `/guides/nsf-53-vs-58-pfas`
  - `/guides/pfas-filter-annual-cost`
  - `/guides/under-sink-vs-whole-house`
- Tightened the ledes and next-action copy on the three product-decision guides so each page presents a more distinct first-screen thesis.
- Reordered global navigation and home hero CTAs so `Guides` define the product first and `/checker` stays available as a human routing tool instead of the primary brand signal.
- Added guide-defined route modules to `/public-water/*` and `/public-water-system/*` so search traffic landing on result or support pages gets pushed back into the guide layer that explains evidence order and product scope.
- Rewired the four core guides toward direct guide or compare destinations so they behave more like action pages and less like abstract explainer pages.
- Removed `/checker` as the primary CTA across the key compare pages so high-intent commercial traffic can act inside the compare page itself and use `/checker` only as a fallback when the route is still unclear.

### Next Review Date

`2026-04-13`
