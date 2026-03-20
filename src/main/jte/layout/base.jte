@param String pageTitle
@param String pageDescription
@param String pageCanonicalUrl
@param boolean pageIndexable
@param gg.jte.Content content

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle}</title>
    <meta name="description" content="${pageDescription}">
    <link rel="canonical" href="${pageCanonicalUrl}">
    @if (pageIndexable)
        <meta name="robots" content="index, follow">
    @else
        <meta name="robots" content="noindex, nofollow">
    @endif
    <meta name="theme-color" content="#152235">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <script defer src="https://cdn.jsdelivr.net/npm/htmx.org@2.0.8/dist/htmx.min.js"></script>
    <script defer src="/js/merchant-tracking.js"></script>
    <link rel="stylesheet" href="/css/app.css">
</head>
<body>
    <header class="topbar">
        <div class="shell topbar__inner">
            <a class="brand" href="/">
                <span class="brand__mark">PF</span>
                <span>
                    <span>PFAS Decision Engine</span>
                    <span class="brand__meta">Official data, benchmark-aware interpretation, certified options</span>
                </span>
            </a>
            <nav class="nav" aria-label="Primary">
                <a class="nav__link" href="/">Home</a>
                <a class="nav__link" href="/checker">Action Checker</a>
                <a class="nav__link" href="/guides/public-water-vs-private-well">Guides</a>
                <a class="nav__link" href="/methodology">Methodology</a>
                <a class="nav__link" href="/source-policy">Source Policy</a>
            </nav>
        </div>
    </header>
    <main>
        ${content}
    </main>
    <footer class="footer">
        <div class="shell footer__inner">
            <span>This interface renders normalized PFAS decision outputs. It does not label any household safe or unsafe.</span>
            <div class="footer__links">
                <a href="/methodology">Methodology</a>
                <a href="/source-policy">Source policy</a>
                <a href="/checker">Action Checker</a>
            </div>
        </div>
    </footer>
</body>
</html>
