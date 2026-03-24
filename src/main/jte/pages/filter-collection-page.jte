@import java.util.List
@import com.example.pfas.catalog.FilterCollectionSurface
@import com.example.pfas.commercial.CommercialSurfaceState
@import com.example.pfas.source.SourceDocument
@param String siteBaseUrl
@param FilterCollectionSurface surface
@param List<SourceDocument> sources
@param CommercialSurfaceState commercialState
@param boolean pageIndexable

@template.layout.base(
    pageTitle = surface.title(),
    pageDescription = surface.lede(),
    pageCanonicalUrl = siteBaseUrl + surface.canonicalPath(),
    pageIndexable = pageIndexable,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
                <div class="space-y-6 bg-white/[0.03] p-7 md:p-9">
                    <div class="space-y-4">
                        <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">${surface.eyebrow()}</span>
                        <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                            ${surface.title()}
                            <span class="font-serif font-medium text-white/72">with the tradeoffs kept visible.</span>
                        </h1>
                        <p class="max-w-3xl text-lg leading-8 text-white/72">${surface.lede()}</p>
                    </div>

                    <div class="join join-vertical gap-3 sm:join-horizontal sm:flex-wrap">
                        <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold hover:bg-primary/92" href="#collection-product-lane">Review collection lane</a>
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="/compare/under-sink-certified-pfas-options">Compare under-sink options</a>
                    </div>
                </div>

                <aside class="bg-white/[0.02] p-7 md:p-8">
                    <div class="space-y-2">
                        <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Collection docket</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-white">Use this lane to narrow the catalog, not to skip the exact product record.</h2>
                    </div>
                    <div class="terminal-pane mt-4 overflow-hidden">
                        <div class="terminal-stack">
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">${surface.groupLabel()}</strong><br>${surface.groupValue()}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Upfront band</strong><br>${surface.upfrontBand()}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Annualized band</strong><br>${surface.annualizedBand()}</article>
                        </div>
                    </div>
                </aside>
            </div>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        <div class="ledger-grid shadow-[var(--shadow-soft)] md:grid-cols-2 xl:grid-cols-4">
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Group</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${surface.groupValue()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">${surface.groupLabel()}</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Records</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${surface.products().size()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">${surface.sourceCount()} supporting source ids in the normalized set.</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Upfront band</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${surface.upfrontBand()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Use cost only with installation and upkeep fit.</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Maintenance</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${surface.maintenanceSummary()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Annualized band ${surface.annualizedBand()}.</div>
            </article>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell space-y-5">
        @template.fragments.commercialState(
            eyebrow = "Commercial state",
            state = commercialState
        )
        @template.fragments.routeActions(
            routeId = surface.routeType() + ":" + surface.routeKey(),
            routeTitle = surface.title(),
            routeSummary = commercialState.summary(),
            routeUrl = surface.canonicalPath()
        )
        <section class="decision-shelf">
            <div class="grid gap-px bg-base-300/70 lg:grid-cols-[minmax(0,1.02fr)_minmax(0,0.98fr)]">
                <div class="bg-base-100 px-6 py-6">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Collection gate</span>
                    <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">Narrow the lane here, then inspect the exact record before clicking out.</h2>
                    <p class="mt-3 max-w-2xl text-sm leading-7 text-base-content/68">${surface.lede()}</p>
                </div>
                <div class="bg-base-200/56 px-6 py-6">
                    <div class="space-y-5">
                        <article>
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/46">Use this lane for</span>
                            <p class="mt-3 text-sm leading-7 text-base-content/78">${surface.groupLabel()} selection where the grouping factor should remove the wrong options early.</p>
                        </article>
                        <article>
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/46">Do not use this lane for</span>
                            <p class="mt-3 text-sm leading-7 text-base-content/72">Do not treat the grouping factor as a final buying verdict. Maintenance, certification scope, and exclusions still decide the fit.</p>
                        </article>
                    </div>
                </div>
            </div>
            <div class="decision-rule-grid">
                <article class="px-6 py-5">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Records in lane</span>
                    <p class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content">${surface.products().size()}</p>
                    <p class="mt-2 text-sm leading-6 text-base-content/62">${surface.sourceCount()} supporting source ids in the normalized set.</p>
                </article>
                <article class="px-6 py-5">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Price screen</span>
                    <p class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content">${surface.upfrontBand()}</p>
                    <p class="mt-2 text-sm leading-6 text-base-content/62">${surface.annualizedBand()} annualized / ${surface.maintenanceSummary()}</p>
                </article>
                <article class="px-6 py-5">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Next move</span>
                    <p class="mt-3 text-sm leading-7 text-base-content/72">Open the exact product record from this lane once the group factor still makes sense after cost and upkeep.</p>
                </article>
            </div>
        </section>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="surface-panel overflow-hidden">
                    <div class="grid gap-px bg-base-300/70 lg:grid-cols-2">
                        <article class="bg-base-100 px-6 py-5">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Decision highlights</span>
                            <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                                @for(var item : surface.highlights())
                                    <li>${item}</li>
                                @endfor
                            </ul>
                        </article>
                        <article class="bg-base-200/52 px-6 py-5">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">What this collection is for</span>
                            <p class="mt-4 text-sm leading-7 text-base-content/72">Use this page to narrow the merchant lane by one clear factor, then open the exact product record before leaving the site.</p>
                            <div class="mt-4 border-t border-base-300/70 pt-4 text-sm leading-7 text-base-content/68">This collection should feel like a filter on the catalog, not like a generic roundup post.</div>
                        </article>
                    </div>
                </section>

                @template.fragments.productLane(
                    sectionId = "collection-product-lane",
                    eyebrow = "Collection lane",
                    title = "Official product records in this collection",
                    summary = "This lane stays grouped by a single factor so the user can scan actual merchant records without losing certification scope, maintenance burden, or the reason the grouping exists.",
                    sourcePage = surface.canonicalPath(),
                    routeType = surface.routeType(),
                    ctaSlot = "filter_collection_lane",
                    routeCode = commercialState.code(),
                    benchmarkRelation = "",
                    unlockState = commercialState.code(),
                    nextActionCode = "OPEN_FILTER_COLLECTION",
                    products = surface.products()
                )

                <section class="surface-panel overflow-hidden">
                    <div class="gap-0 p-0">
                        <div class="border-b border-base-300/70 px-6 py-5">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Primary source ledger</span>
                            <h2 class="mt-4 text-2xl font-semibold tracking-[-0.03em] text-base-content">Primary source ledger</h2>
                        </div>
                        <div class="divide-y divide-base-300/70">
                            @for(var source : sources)
                                <a class="row-link grid gap-4 px-6 py-5 sm:grid-cols-[12rem_minmax(0,1fr)] sm:items-start" href="${source.url()}">
                                    <div>
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/60">${source.organization()}</div>
                                    </div>
                                    <div>
                                        <div class="text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                        <div class="mt-2 break-all text-sm leading-6 text-base-content/56">${source.url()}</div>
                                    </div>
                                </a>
                            @endfor
                        </div>
                    </div>
                </section>
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="surface-panel overflow-hidden">
                    <div class="px-6 py-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Collection notes</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/64">The grouping factor is visible, but it should never erase maintenance, claim scope, or installation constraints.</p>
                    </div>
                    <div class="border-t border-base-300/70 px-6 py-5">
                        <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">Keywords</h3>
                        <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                            @for(var keyword : surface.keywords().subList(0, Math.min(surface.keywords().size(), 6)))
                                <li>${keyword}</li>
                            @endfor
                        </ul>
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
