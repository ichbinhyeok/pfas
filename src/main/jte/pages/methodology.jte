@param int sourceCount
@param int stateCount
@param int publicWaterCount
@param int filterCount
@param int guideCount
@param int readyStateCount
@param int blockedStateCount
@param int readyPublicWaterCount
@param int blockedPublicWaterCount
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param String siteLastVerifiedDate

@template.layout.base(
    pageTitle = "PFAS methodology",
    pageDescription = "Methodology for source handling, normalization, decision rules, and result generation.",
    pageCanonicalUrl = siteBaseUrl + "/methodology",
    pageIndexable = true,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.16fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <div class="space-y-4">
                    <span class="badge badge-outline border-base-300 bg-base-100 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-base-content/58">Methodology</span>
                    <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-base-content sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                        How the engine turns evidence into next actions
                        <span class="font-serif font-medium text-secondary">without hiding the decision rules.</span>
                    </h1>
                    <p class="max-w-3xl text-lg leading-8 text-base-content/72">
                        The project behaves like a typed editorial system. Sources are captured, normalized, mapped into
                        deterministic routes, and rendered into the same action surfaces used by the public site and internal JSON.
                    </p>
                </div>

                <div class="join join-vertical gap-3 sm:join-horizontal">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/checker">Open Action Checker</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/source-policy">Open source policy</a>
                </div>
            </div>

            <aside class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                <div class="card-body gap-5">
                    <div class="space-y-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Methodology posture</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">The pipeline stays visible from capture to rendered route.</h2>
                    </div>
                    <ul class="menu gap-2 rounded-[1rem] bg-base-200/55 p-3">
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Decision model</strong><br>Deterministic route logic rather than probabilistic copy.</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Shared output</strong><br>SSR pages and JSON are generated from the same typed result objects.</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Commercial discipline</strong><br>Products remain downstream from source quality and route context.</span></li>
                    </ul>
                </div>
            </aside>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        @template.fragments.publicationStrip(
            lastVerified = siteLastVerifiedDate,
            scopeLabel = "Methodology and trust layer",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="stats stats-vertical gap-3 bg-transparent p-0 shadow-none xl:stats-horizontal">
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Sources</div>
                <div class="stat-value mt-3 text-2xl font-semibold tracking-[-0.04em] text-base-content">${sourceCount}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Tracked source documents in the registry.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">State routes</div>
                <div class="stat-value mt-3 text-2xl font-semibold tracking-[-0.04em] text-base-content">${stateCount}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">State guidance seeds currently in the engine.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Public-water dossiers</div>
                <div class="stat-value mt-3 text-2xl font-semibold tracking-[-0.04em] text-base-content">${publicWaterCount}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Seeded public-water systems with direct context.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Readiness</div>
                <div class="stat-value mt-3 text-2xl font-semibold tracking-[-0.04em] text-base-content">${readyStateCount + readyPublicWaterCount}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Routes currently marked ready for controlled expansion.</div>
            </div>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                    <div class="card-body gap-6">
                        <div class="flex flex-col gap-3 border-b border-base-300/70 pb-5 lg:flex-row lg:items-end lg:justify-between">
                            <div class="space-y-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Pipeline</span>
                                <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">Evidence becomes a route through a typed pipeline.</h2>
                            </div>
                            <p class="max-w-2xl text-sm leading-7 text-base-content/62">The public interface is the final render step, not the first place where the logic shows up.</p>
                        </div>

                        <div class="grid gap-4 md:grid-cols-2">
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">01</span>
                                <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Raw capture</h3>
                                <p class="mt-3 text-sm leading-7 text-base-content/68">Official pages, PDFs, notices, and listing records are captured with URLs and retrieval dates.</p>
                            </article>
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">02</span>
                                <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Normalization</h3>
                                <p class="mt-3 text-sm leading-7 text-base-content/68">Facts are normalized into CSV or JSON with source ids, dates, and units.</p>
                            </article>
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">03</span>
                                <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Decision layer</h3>
                                <p class="mt-3 text-sm leading-7 text-base-content/68">Deterministic rules map source type, benchmark relation, and filter state into next actions.</p>
                            </article>
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">04</span>
                                <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Result rendering</h3>
                                <p class="mt-3 text-sm leading-7 text-base-content/68">SSR pages and JSON share the same typed result schema.</p>
                            </article>
                        </div>
                    </div>
                </section>

                <div class="grid gap-5 lg:grid-cols-2">
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-4">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">What the engine does</span>
                            <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                                <li>Routes public water and private well households differently.</li>
                                <li>Prefers direct official evidence over indirect hints.</li>
                                <li>Keeps certification, cost, and maintenance visible before a product feels like a fit.</li>
                                <li>Uses programmatic readiness checks before state or utility coverage is treated as expansion-ready.</li>
                            </ul>
                        </div>
                    </section>

                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-4">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">What the engine does not do</span>
                            <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                                <li>It does not label a household safe or unsafe.</li>
                                <li>It does not turn ZIP hints into exposure claims.</li>
                                <li>It does not treat certification as proof of every current regulatory benchmark.</li>
                            </ul>
                        </div>
                    </section>
                </div>
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Current operating surface</h2>
                        <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                            <li>${stateCount} state guidance routes</li>
                            <li>${publicWaterCount} public-water dossiers</li>
                            <li>${filterCount} filter models in the catalog</li>
                            <li>${guideCount} high-intent entry guides</li>
                        </ul>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Readiness ledger</h2>
                        <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                            <li>${readyStateCount} state routes ready / ${blockedStateCount} state routes still blocked</li>
                            <li>${readyPublicWaterCount} public-water routes ready / ${blockedPublicWaterCount} public-water routes still blocked</li>
                            <li>Readiness requires source resolution, verification dates, and the correct state or utility evidence layer.</li>
                        </ul>
                    </div>
                </section>

                <div class="alert border border-base-300/70 bg-base-100/92 px-5 py-4 shadow-[var(--shadow-soft)]">
                    <span class="text-sm leading-7 text-base-content/74">This methodology explains how a route is formed. It is not a household risk grade or a medical interpretation.</span>
                </div>
            </aside>
        </div>
    </div>
</section>
`
)
