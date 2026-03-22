@import java.util.List
@import com.example.pfas.filter.FilterCatalogItem
@import com.example.pfas.commercial.CommercialSurfaceState
@import com.example.pfas.source.SourceDocument
@import com.example.pfas.web.ComparePage
@import com.example.pfas.web.ComparePageMetrics
@import com.example.pfas.web.GuidePage
@import com.example.pfas.web.GuideSystemExample
@import com.example.pfas.web.PresentationText
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param ComparePage page
@param ComparePageMetrics metrics
@param List<SourceDocument> compareSources
@param List<GuideSystemExample> relatedSystems
@param List<FilterCatalogItem> relatedProducts
@param List<GuidePage> relatedGuides
@param List<GuidePage> allGuides
@param CommercialSurfaceState commercialState
@param boolean pageIndexable
@param String pageStructuredDataJson

@template.layout.base(
    pageTitle = page.title(),
    pageDescription = page.lede(),
    pageCanonicalUrl = siteBaseUrl + "/compare/" + page.slug(),
    pageIndexable = pageIndexable,
    content = @`
<script type="application/ld+json">$unsafe{pageStructuredDataJson}</script>
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
                <div class="space-y-6 bg-white/[0.03] p-7 md:p-9">
                    <div class="space-y-4">
                        <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">${page.eyebrow()}</span>
                        <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                            ${page.title()}
                            <span class="font-serif font-medium text-white/72">without flattening the tradeoffs.</span>
                        </h1>
                        <p class="max-w-3xl text-lg leading-8 text-white/72">${page.lede()}</p>
                    </div>

                    <div class="join join-vertical gap-3 sm:join-horizontal sm:flex-wrap">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold hover:bg-primary/92" href="${page.primaryHref()}" data-route-click-track="true" data-route-click-id="compare:${page.slug()}:primary" data-route-click-source-page="/compare/${page.slug()}" data-route-click-target-path="${page.primaryHref()}" data-route-click-cta-slot="compare_primary" data-route-click-family="compare_handoff" data-route-click-lane="${page.slug()}" data-route-click-region="">${page.primaryLabel()}</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="${page.secondaryHref()}" data-route-click-track="true" data-route-click-id="compare:${page.slug()}:secondary" data-route-click-source-page="/compare/${page.slug()}" data-route-click-target-path="${page.secondaryHref()}" data-route-click-cta-slot="compare_secondary" data-route-click-family="compare_handoff" data-route-click-lane="${page.slug()}" data-route-click-region="">${page.secondaryLabel()}</a>
                    @if(!relatedProducts.isEmpty())
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="#compare-product-lane">Open compare lane</a>
                    @endif
                </div>
                </div>

                <aside class="bg-white/[0.02] p-7 md:p-8">
                    <div class="space-y-2">
                        <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Comparison posture</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-white">Comparison works only when maintenance, certification, and fit stay visible together.</h2>
                    </div>
                    <div class="terminal-pane mt-4 overflow-hidden">
                        <div class="terminal-stack">
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Query intent</strong><br>${page.queryIntent()}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Upfront band</strong><br>${metrics.upfrontBand()}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Annualized band</strong><br>${metrics.annualizedBand()}</article>
                        </div>
                    </div>
                </aside>
            </div>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        @template.fragments.publicationStrip(
            lastVerified = page.lastVerifiedDate(),
            scopeLabel = "Dedicated compare page",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="ledger-grid md:grid-cols-2 xl:grid-cols-5">
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Query intent</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${page.queryIntent()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Built to resolve a high-intent comparison query with actual records.</div>
            </div>
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Linked products</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${metrics.productCount()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Filtered to models already normalized in the engine.</div>
            </div>
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Utility examples</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${metrics.utilityExampleCount()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Live dossiers keep the page tied to actual evidence routes.</div>
            </div>
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Installation mix</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${metrics.installationMix()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">The page compares ownership classes, not just brand names.</div>
            </div>
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Source set</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${compareSources.size()} records</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Official guidance, listings, performance PDFs, and product records.</div>
            </div>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                @template.fragments.commercialState(
                    eyebrow = "Commercial state",
                    state = commercialState
                )

                @template.fragments.routeActions(
                    routeId = "compare:" + page.slug(),
                    routeTitle = page.title(),
                    routeSummary = commercialState.summary(),
                    routeUrl = "/compare/" + page.slug()
                )

                <section class="decision-shelf">
                    <div class="grid gap-px bg-base-300/70 lg:grid-cols-[minmax(0,1.04fr)_minmax(0,0.96fr)]">
                        <div class="bg-base-100 px-6 py-6">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Compare next action</span>
                            <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">${page.nextActionTitle()}</h2>
                            <p class="mt-3 max-w-2xl text-sm leading-7 text-base-content/68">${page.nextActionSummary()}</p>
                        </div>
                        <div class="bg-base-200/56 px-6 py-6">
                            <div class="space-y-5">
                                <article>
                                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/46">Use this page when</span>
                                    <p class="mt-3 text-sm leading-7 text-base-content/78">${page.whyThis().isEmpty() ? page.nextActionSummary() : page.whyThis().get(0)}</p>
                                </article>
                                <article>
                                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/46">Skip this page when</span>
                                    <p class="mt-3 text-sm leading-7 text-base-content/72">${page.whatThisDoesNotTellYou().isEmpty() ? "Skip if you still need interpretation rather than product tradeoffs." : page.whatThisDoesNotTellYou().get(0)}</p>
                                </article>
                            </div>
                        </div>
                    </div>
                    <div class="decision-rule-grid">
                        <article class="px-6 py-5">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Comparison axes</span>
                            <ul class="mt-3 space-y-2 text-sm leading-7 text-base-content/72">
                                @for(var axis : page.comparisonAxes())
                                    <li>${axis}</li>
                                @endfor
                            </ul>
                        </article>
                        <article class="px-6 py-5">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Starting spend</span>
                            <p class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content">${metrics.upfrontBand()}</p>
                            <p class="mt-2 text-sm leading-6 text-base-content/62">Use the upfront band with installation class, not in isolation.</p>
                        </article>
                        <article class="px-6 py-5">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Annual carry</span>
                            <p class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content">${metrics.annualizedBand()}</p>
                            <p class="mt-2 text-sm leading-6 text-base-content/62">The annualized band is often what breaks the fit after purchase.</p>
                        </article>
                    </div>
                </section>

                <section class="buy-screen-grid">
                    <article class="px-5 py-5">
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Buy if</span>
                        <p class="mt-3 text-sm leading-7 text-base-content/72">${page.whyThis().isEmpty() ? page.nextActionSummary() : page.whyThis().get(0)}</p>
                    </article>
                    <article class="px-5 py-5">
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Do not buy if</span>
                        <p class="mt-3 text-sm leading-7 text-base-content/72">${page.whatThisDoesNotTellYou().isEmpty() ? "Skip if you still need evidence interpretation first." : page.whatThisDoesNotTellYou().get(Math.min(1, page.whatThisDoesNotTellYou().size() - 1))}</p>
                    </article>
                    <article class="px-5 py-5">
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Best entry class</span>
                        <p class="mt-3 text-sm leading-7 text-base-content/72">${metrics.installationMix()}</p>
                        <p class="mt-2 text-sm leading-6 text-base-content/62">Use installation mix to eliminate the wrong ownership class early.</p>
                    </article>
                    <article class="buy-screen-accent px-5 py-5">
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Merchant-routing lane</span>
                        <p class="mt-3 text-sm leading-7 text-base-content/72">Open the compare lane only after the buy/skip conditions above match the household route.</p>
                    </article>
                </section>

                @for(var section : page.sections())
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-5">
                            <div class="space-y-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Compare analysis</span>
                                <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">${section.title()}</h2>
                            </div>
                            <div class="prose prose-dossier max-w-none">
                                @if(section.summary() != null && !section.summary().isBlank())
                                    <p>${section.summary()}</p>
                                @endif
                                @for(var paragraph : section.paragraphs())
                                    <p>${paragraph}</p>
                                @endfor
                                @if(section.bullets() != null && !section.bullets().isEmpty())
                                    <ul>
                                        @for(var bullet : section.bullets())
                                            <li>${bullet}</li>
                                        @endfor
                                    </ul>
                                @endif
                            </div>
                        </div>
                    </section>
                @endfor

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <div class="space-y-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Structured comparison</span>
                            <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Structured comparison</h2>
                        </div>
                        <p class="text-sm leading-7 text-base-content/62">The page compares upkeep, installation class, certification scope, seller choice, and fit instead of flattening everything into a single badge.</p>
                        <div class="grid gap-5 xl:grid-cols-2">
                            @for(var product : relatedProducts)
                                <article class="card border border-base-300/70 bg-base-100 shadow-[var(--shadow-soft)]">
                                    <div class="card-body gap-5">
                                        <div class="flex flex-wrap items-start justify-between gap-3">
                                            <div class="space-y-2">
                                                <p class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">${product.brand()} / ${PresentationText.installationTypeLabel(product.installationType())}</p>
                                                <h3 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">${product.model()}</h3>
                                            </div>
                                            <span class="badge bg-primary/12 text-primary">${PresentationText.filterTypeLabel(product.filterType())}</span>
                                        </div>
                                        <div class="grid gap-3 md:grid-cols-2">
                                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Standards</span>
                                                <p class="mt-3 text-sm leading-6 text-base-content/72">${product.certBody()} ${product.standardCode()}</p>
                                            </article>
                                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Merchant</span>
                                                <p class="mt-3 text-sm leading-6 text-base-content/72">${PresentationText.merchantLabel(product)}</p>
                                            </article>
                                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Upfront</span>
                                                <p class="mt-3 text-sm leading-6 text-base-content/72">${PresentationText.currencyLabel(product.upfrontCostUsd())}</p>
                                            </article>
                                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Annualized</span>
                                                <p class="mt-3 text-sm leading-6 text-base-content/72">${PresentationText.annualizedMaintenanceLabel(product)}</p>
                                            </article>
                                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Best for</span>
                                                <p class="mt-3 text-sm leading-6 text-base-content/72">${PresentationText.bestForLabel(product)}</p>
                                            </article>
                                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Seller choice</span>
                                                <p class="mt-3 text-sm leading-6 text-base-content/72">${PresentationText.sellerChoiceNote(product)}</p>
                                            </article>
                                        </div>
                                        <p class="text-sm leading-7 text-base-content/72">PFAS coverage ${PresentationText.previewList(product.coveredPfas(), 4)} / Maintenance ${PresentationText.maintenanceBurdenLabel(product)} / Next step ${PresentationText.nextStepLabel(product)}</p>
                                    </div>
                                </article>
                            @endfor
                        </div>
                    </div>
                </section>

                @template.fragments.productLane(
                    sectionId = "compare-product-lane",
                    eyebrow = "Merchant-routing lane",
                    title = "Official product records tied to this comparison",
                    summary = "This lane keeps the commercial click path tied to the compare thesis, the live dossier examples, and the exact normalized product records.",
                    sourcePage = "/compare/" + page.slug(),
                    routeType = "compare",
                    ctaSlot = "compare_product_lane",
                    routeCode = commercialState.code(),
                    benchmarkRelation = "",
                    unlockState = commercialState.code(),
                    nextActionCode = page.nextActionTitle(),
                    products = relatedProducts
                )

                <div class="grid gap-5 lg:grid-cols-2">
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-4">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Why this</span>
                            <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                                @for(var item : page.whyThis())
                                    <li>${item}</li>
                                @endfor
                            </ul>
                        </div>
                    </section>

                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-4">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">What this does not tell you</span>
                            <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                                @for(var item : page.whatThisDoesNotTellYou())
                                    <li>${item}</li>
                                @endfor
                            </ul>
                        </div>
                    </section>
                </div>
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="surface-panel overflow-hidden">
                    <div class="px-6 py-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Operating file</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/64">The compare page should keep only a few routing signals visible by default. Evidence and examples can open on demand.</p>
                    </div>
                    <div class="border-t border-base-300/70 px-6 py-5">
                        <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">Evidence basis</h3>
                        <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                            @for(var item : page.evidenceHighlights())
                                <li>${item}</li>
                            @endfor
                        </ul>
                    </div>
                    <div class="border-t border-base-300/70 px-6 py-5">
                        <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">Target queries</h3>
                        <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                            @for(var query : page.targetQueries())
                                <li>${query}</li>
                            @endfor
                        </ul>
                    </div>
                    @if(!relatedSystems.isEmpty())
                        <div class="collapse collapse-arrow rounded-none border-0 border-t border-base-300/70 bg-base-100">
                            <input type="checkbox">
                            <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">Live utility examples (${relatedSystems.size()})</div>
                            <div class="collapse-content">
                                <div class="space-y-3 pt-2">
                                    @for(var example : relatedSystems.subList(0, Math.min(relatedSystems.size(), 3)))
                                        <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/public-water/${example.system().pwsid()}" data-route-click-track="true" data-route-click-id="compare:${page.slug()}:system:${example.system().pwsid()}" data-route-click-source-page="/compare/${page.slug()}" data-route-click-target-path="/public-water/${example.system().pwsid()}" data-route-click-cta-slot="compare_live_system" data-route-click-family="compare_to_dossier" data-route-click-lane="${page.slug()}" data-route-click-region="${example.system().stateCode()}">
                                            <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${example.system().stateCode()} / ${example.system().pwsid()}</div>
                                            <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${example.system().pwsName()}</div>
                                            <div class="mt-2 text-sm leading-6 text-base-content/60">${PresentationText.benchmarkRelationLabel(example.result().meta().benchmarkRelation())} / ${example.result().nextAction().title()}</div>
                                        </a>
                                    @endfor
                                </div>
                            </div>
                        </div>
                    @endif
                    <div class="collapse collapse-arrow rounded-none border-0 border-t border-base-300/70 bg-base-100">
                        <input type="checkbox">
                        <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">Primary source ledger (${compareSources.size()})</div>
                        <div class="collapse-content">
                            <div class="space-y-3 pt-2">
                                @for(var source : compareSources.subList(0, Math.min(compareSources.size(), 4)))
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()} / ${source.organization()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                        <div class="mt-2 break-all text-sm leading-6 text-base-content/60">${source.url()}</div>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    </div>
                </section>

                <section class="surface-panel overflow-hidden">
                    <div class="px-6 py-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Related routes</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/64">Keep secondary pages available without letting them compete with the current compare thesis.</p>
                    </div>
                    @if(!relatedGuides.isEmpty())
                        <div class="border-t border-base-300/70 px-6 py-5">
                            <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">Related guides</h3>
                            <div class="mt-4 space-y-3">
                                @for(var guide : relatedGuides.subList(0, Math.min(relatedGuides.size(), 3)))
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/guides/${guide.slug()}" data-route-click-track="true" data-route-click-id="compare:${page.slug()}:guide:${guide.slug()}" data-route-click-source-page="/compare/${page.slug()}" data-route-click-target-path="/guides/${guide.slug()}" data-route-click-cta-slot="compare_related_guide" data-route-click-family="compare_to_guide" data-route-click-lane="${page.slug()}" data-route-click-region="">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${guide.eyebrow()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${guide.title()}</div>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    @endif
                    <div class="collapse collapse-arrow rounded-none border-0 border-t border-base-300/70 bg-base-100">
                        <input type="checkbox">
                        <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">All guides</div>
                        <div class="collapse-content">
                            <div class="space-y-3 pt-2">
                                @for(var guide : allGuides)
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/guides/${guide.slug()}">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${guide.eyebrow()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${guide.title()}</div>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
