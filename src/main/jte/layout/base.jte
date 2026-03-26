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
    <meta property="og:title" content="${pageTitle}">
    <meta property="og:description" content="${pageDescription}">
    <meta property="og:url" content="${pageCanonicalUrl}">
    <meta property="og:site_name" content="PFAS Decision Engine">
    <meta property="og:type" content="website">
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="${pageTitle}">
    <meta name="twitter:description" content="${pageDescription}">
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
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-NJ5BCKCCEY"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-NJ5BCKCCEY');
    </script>
    <script defer src="https://cdn.jsdelivr.net/npm/htmx.org@2.0.8/dist/htmx.min.js"></script>
    <script defer src="/js/checker-form.js"></script>
    <script defer src="/js/merchant-tracking.js"></script>
    <script defer src="/js/route-click-tracking.js"></script>
    <script defer src="/js/route-actions.js"></script>
    <link rel="stylesheet" href="/css/tailwind.css">
    <link rel="stylesheet" href="/css/app.css">
</head>
<body class="font-sans text-base-content antialiased">
    <div class="relative min-h-screen overflow-x-hidden">
    <header class="sticky top-0 z-50 border-b border-base-300/90 bg-[rgba(244,248,251,0.88)] backdrop-blur-xl">
        <div class="shell navbar min-h-0 items-center gap-3 py-3 md:gap-4 md:py-4">
            <div class="navbar-start min-w-0 flex-1">
                <a class="group flex min-w-0 items-center gap-3 no-underline md:gap-4" href="/">
                    <span class="flex h-10 w-10 shrink-0 items-center justify-center rounded-[1rem] border border-white/8 bg-neutral text-neutral-content shadow-[var(--shadow-soft)] transition duration-150 ease-out group-hover:-translate-y-px md:h-12 md:w-12">
                        <span class="font-serif text-lg font-semibold tracking-[-0.05em]">PF</span>
                    </span>
                    <span class="flex min-w-0 flex-col">
                        <span class="truncate text-[0.95rem] font-semibold tracking-[-0.02em] text-base-content md:text-sm">PFAS Decision Engine</span>
                        <span class="hidden text-xs font-semibold text-base-content/52 sm:block">Decision infrastructure for utility, well, and filter routes</span>
                    </span>
                </a>
            </div>
            <div class="navbar-end md:hidden">
                <details class="dropdown dropdown-end">
                    <summary class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100/92 px-4 text-sm font-semibold text-base-content shadow-none hover:bg-base-200 list-none">
                        Menu
                        <svg aria-hidden="true" class="h-4 w-4" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" viewBox="0 0 24 24">
                            <path d="M4 7h16"></path>
                            <path d="M4 12h16"></path>
                            <path d="M4 17h16"></path>
                        </svg>
                    </summary>
                    <ul class="menu dropdown-content z-[60] mt-3 w-64 rounded-[1.1rem] border border-base-300/80 bg-base-100 p-2 text-sm font-semibold text-base-content shadow-[var(--shadow-panel)]">
                        <li><a href="/">Home</a></li>
                        <li><a href="/checker">Next-Step Checker</a></li>
                        <li><a href="/guides/public-water-vs-private-well">Guides</a></li>
                        <li><a href="/methodology">Methodology</a></li>
                        <li><a href="/source-policy">Source Policy</a></li>
                    </ul>
                </details>
            </div>
            <div class="navbar-end hidden w-auto flex-none md:flex">
                <nav aria-label="Primary" class="rounded-full border border-base-300/80 bg-white/82 px-1.5 py-1 shadow-[var(--shadow-soft)]">
                    <ul class="menu menu-horizontal gap-1 p-0 text-[0.78rem] font-medium text-base-content/72">
                        <li><a class="px-4 py-2 transition duration-150 ease-out hover:bg-base-200 hover:text-base-content" href="/">Home</a></li>
                        <li><a class="px-4 py-2 transition duration-150 ease-out hover:bg-base-200 hover:text-base-content" href="/checker">Next-Step Checker</a></li>
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
                <div class="terminal-pane p-6">
                    <div class="space-y-3">
                        <span class="badge border-0 bg-white/10 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/72">Operating boundary</span>
                        <p class="max-w-2xl text-sm leading-7 text-white/78">This interface renders normalized PFAS decision outputs from official records, state guidance, and captured listing data.</p>
                        <p class="max-w-2xl text-sm leading-7 text-white/60">It does not label any household safe or unsafe, and it does not make medical or exposure diagnoses.</p>
                    </div>
                </div>
                <div class="terminal-pane p-6">
                    <div class="space-y-3">
                        <span class="badge border-0 bg-white/10 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/72">Reference deck</span>
                        <div class="flex flex-col gap-1 text-sm font-medium text-white/66 sm:flex-row sm:flex-wrap sm:gap-x-5 sm:gap-y-2">
                            <a class="inline-flex min-h-11 items-center transition duration-150 ease-out hover:-translate-y-px hover:text-white" href="/methodology">Methodology</a>
                            <a class="inline-flex min-h-11 items-center transition duration-150 ease-out hover:-translate-y-px hover:text-white" href="/source-policy">Source policy</a>
                            <a class="inline-flex min-h-11 items-center transition duration-150 ease-out hover:-translate-y-px hover:text-white" href="/checker">Next-Step Checker</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    </div>
</body>
</html>
