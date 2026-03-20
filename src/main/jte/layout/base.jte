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
    <meta name="theme-color" content="#0f766e">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Newsreader:opsz,wght@6..72,500;6..72,600;6..72,700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    <script defer src="https://cdn.jsdelivr.net/npm/htmx.org@2.0.8/dist/htmx.min.js"></script>
    <script defer src="/js/merchant-tracking.js"></script>
    <link rel="stylesheet" href="/css/tailwind.css">
    <link rel="stylesheet" href="/css/app.css">
</head>
<body class="bg-ivory font-sans text-slate-deep antialiased [background-image:none]">
    <div class="min-h-screen">
    <header class="sticky top-0 z-40 border-b border-shell-border bg-ivory/92 backdrop-blur-xl">
        <div class="shell flex flex-col gap-4 py-4 md:flex-row md:items-center md:justify-between">
            <a class="flex items-center gap-4 no-underline transition duration-150 ease-out hover:-translate-y-px" href="/">
                <span class="flex h-11 w-11 items-center justify-center rounded-2xl border border-slate-deep/8 bg-slate-deep text-ivory">
                    <span class="font-serif text-lg font-semibold tracking-[-0.03em]">PF</span>
                </span>
                <span class="flex min-w-0 flex-col">
                    <span class="text-sm font-semibold tracking-[-0.02em] text-slate-deep">PFAS Decision Engine</span>
                    <span class="text-xs font-medium text-slate-muted">Official records, benchmark logic, certified option routing</span>
                </span>
            </a>
            <nav aria-label="Primary" class="flex flex-wrap items-center gap-2 md:justify-end">
                <a class="rounded-full px-4 py-2 text-[0.75rem] font-semibold uppercase tracking-[0.18em] text-slate-muted transition duration-150 ease-out hover:-translate-y-px hover:text-slate-deep" href="/">Home</a>
                <a class="rounded-full px-4 py-2 text-[0.75rem] font-semibold uppercase tracking-[0.18em] text-slate-muted transition duration-150 ease-out hover:-translate-y-px hover:text-slate-deep" href="/checker">Action Checker</a>
                <a class="rounded-full px-4 py-2 text-[0.75rem] font-semibold uppercase tracking-[0.18em] text-slate-muted transition duration-150 ease-out hover:-translate-y-px hover:text-slate-deep" href="/guides/public-water-vs-private-well">Guides</a>
                <a class="rounded-full px-4 py-2 text-[0.75rem] font-semibold uppercase tracking-[0.18em] text-slate-muted transition duration-150 ease-out hover:-translate-y-px hover:text-slate-deep" href="/methodology">Methodology</a>
                <a class="rounded-full px-4 py-2 text-[0.75rem] font-semibold uppercase tracking-[0.18em] text-slate-muted transition duration-150 ease-out hover:-translate-y-px hover:text-slate-deep" href="/source-policy">Source Policy</a>
            </nav>
        </div>
    </header>
    <main class="pb-24">
        ${content}
    </main>
    <footer class="border-t border-shell-border bg-ivory-panel/92">
        <div class="shell flex flex-col gap-5 py-10 md:flex-row md:items-end md:justify-between">
            <div class="max-w-2xl space-y-2">
                <p class="text-sm font-medium text-slate-body">This interface renders normalized PFAS decision outputs from official records, state guidance, and captured listing data.</p>
                <p class="text-sm text-slate-muted">It does not label any household safe or unsafe and it does not make medical or exposure diagnoses.</p>
            </div>
            <div class="flex flex-wrap items-center gap-x-5 gap-y-2 text-sm font-medium text-slate-muted">
                <a class="transition duration-150 ease-out hover:-translate-y-px hover:text-slate-deep" href="/methodology">Methodology</a>
                <a class="transition duration-150 ease-out hover:-translate-y-px hover:text-slate-deep" href="/source-policy">Source policy</a>
                <a class="transition duration-150 ease-out hover:-translate-y-px hover:text-slate-deep" href="/checker">Action Checker</a>
            </div>
        </div>
    </footer>
    </div>
</body>
</html>
