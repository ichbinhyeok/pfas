@param String pageTitle
@param String pageDescription
@param gg.jte.Content content

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${pageTitle}</title>
    <meta name="description" content="${pageDescription}">
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
                <a class="nav__link" href="/public-water/PA1510001">Seeded Result</a>
                <a class="nav__link" href="/internal/results/public-water/PA1510001">Result JSON</a>
            </nav>
        </div>
    </header>
    <main>
        ${content}
    </main>
    <footer class="footer">
        <div class="shell">
            This interface renders normalized PFAS decision outputs. It does not label any household safe or unsafe.
        </div>
    </footer>
</body>
</html>
