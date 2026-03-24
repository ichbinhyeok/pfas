@param String siteBaseUrl
@param Integer status
@param String error
@param String message
@param String path

@template.layout.base(
    pageTitle = "Page unavailable",
    pageDescription = "This PFAS page is temporarily unavailable.",
    pageCanonicalUrl = (path == null || path.isBlank()) ? siteBaseUrl : siteBaseUrl + path,
    pageIndexable = false,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
                <div class="space-y-6 bg-white/[0.03] p-7 md:p-9">
                    <div class="space-y-4">
                        <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">Page unavailable</span>
                        <h1 class="max-w-4xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                            This page could not be opened right now.
                        </h1>
                        <p class="max-w-3xl text-lg leading-8 text-white/72">
                            The request reached the server but the page could not be rendered in a user-facing route.
                        </p>
                    </div>

                    <div class="join join-vertical gap-3 sm:join-horizontal sm:flex-wrap">
                        <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold hover:bg-primary/92" href="/">Go home</a>
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="/methodology">Read methodology</a>
                    </div>
                </div>

                <aside class="bg-white/[0.02] p-7 md:p-8">
                    <div class="space-y-2">
                        <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Error detail</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-white">${status == null ? 500 : status} ${error == null || error.isBlank() ? "Error" : error}</h2>
                    </div>
                    <div class="terminal-pane mt-4 overflow-hidden">
                        <div class="terminal-stack">
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Path</strong><br>${path == null || path.isBlank() ? "/" : path}</article>
                            @if(message != null && !message.isBlank())
                                <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Server detail</strong><br>${message}</article>
                            @endif
                        </div>
                    </div>
                </aside>
            </div>
        </div>
    </div>
</section>
`)
