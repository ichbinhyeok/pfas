@param String pageTitle
@param String pageDescription
@param String pageCanonicalUrl
@param boolean pageIndexable
@param gg.jte.Content content

<!doctype html>
<html lang="en" data-theme="pfas">
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
<body class="font-sans text-base-content antialiased">
    <div class="relative min-h-screen overflow-x-hidden">
    <header class="sticky top-0 z-50 border-b border-base-300/80 bg-[rgba(251,252,253,0.78)] backdrop-blur-xl">
        <div class="shell navbar min-h-0 gap-4 py-4">
            <div class="navbar-start w-auto flex-1">
                <a class="group flex items-center gap-4 no-underline" href="/">
                    <span class="flex h-12 w-12 items-center justify-center rounded-[1rem] border border-base-300/80 bg-neutral text-neutral-content shadow-[var(--shadow-soft)] transition duration-150 ease-out group-hover:-translate-y-px">
                        <span class="font-serif text-lg font-semibold tracking-[-0.05em]">PF</span>
                    </span>
                    <span class="flex min-w-0 flex-col">
                        <span class="text-sm font-semibold tracking-[-0.02em] text-base-content">PFAS Decision Engine</span>
                        <span class="text-xs font-medium text-base-content/58">Decision infrastructure for utility, well, and filter routes</span>
                    </span>
                </a>
            </div>
            <div class="navbar-end w-auto flex-none">
                <nav aria-label="Primary" class="rounded-full border border-base-300/80 bg-white/70 px-1.5 py-1 shadow-[var(--shadow-soft)]">
                    <ul class="menu menu-horizontal gap-1 p-0 text-[0.78rem] font-medium text-base-content/72">
                        <li><a class="px-4 py-2 transition duration-150 ease-out hover:bg-base-200 hover:text-base-content" href="/">Home</a></li>
                        <li><a class="px-4 py-2 transition duration-150 ease-out hover:bg-base-200 hover:text-base-content" href="/checker">Action Checker</a></li>
                        <li><a class="px-4 py-2 transition duration-150 ease-out hover:bg-base-200 hover:text-base-content" href="/guides/public-water-vs-private-well">Guides</a></li>
                        <li><a class="px-4 py-2 transition duration-150 ease-out hover:bg-base-200 hover:text-base-content" href="/methodology">Methodology</a></li>
                        <li><a class="px-4 py-2 transition duration-150 ease-out hover:bg-base-200 hover:text-base-content" href="/source-policy">Source Policy</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>
    <main class="pb-28">
        ${content}
    </main>
    <footer class="border-t border-white/8 bg-neutral text-neutral-content">
        <div class="shell py-10">
            <div class="grid gap-5 xl:grid-cols-[minmax(0,1.2fr)_minmax(0,0.8fr)]">
                <div class="card border border-white/10 bg-white/5 shadow-none">
                    <div class="card-body gap-3">
                        <span class="badge border-0 bg-white/10 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/72">Operating boundary</span>
                        <p class="max-w-2xl text-sm leading-7 text-white/78">This interface renders normalized PFAS decision outputs from official records, state guidance, and captured listing data.</p>
                        <p class="max-w-2xl text-sm leading-7 text-white/60">It does not label any household safe or unsafe, and it does not make medical or exposure diagnoses.</p>
                    </div>
                </div>
                <div class="card border border-white/10 bg-white/5 shadow-none">
                    <div class="card-body gap-3">
                        <span class="badge border-0 bg-white/10 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/72">Reference deck</span>
                        <div class="flex flex-wrap gap-x-5 gap-y-2 text-sm font-medium text-white/66">
                            <a class="transition duration-150 ease-out hover:-translate-y-px hover:text-white" href="/methodology">Methodology</a>
                            <a class="transition duration-150 ease-out hover:-translate-y-px hover:text-white" href="/source-policy">Source policy</a>
                            <a class="transition duration-150 ease-out hover:-translate-y-px hover:text-white" href="/checker">Action Checker</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    </div>
</body>
</html>
