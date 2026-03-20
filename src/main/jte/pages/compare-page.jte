@import java.util.List
@import com.example.pfas.filter.FilterCatalogItem
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
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <div class="space-y-4">
                    <span class="badge badge-outline border-base-300 bg-base-100 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-base-content/58">${page.eyebrow()}</span>
                    <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-base-content sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                        ${page.title()}
                        <span class="font-serif font-medium text-secondary">without flattening the tradeoffs.</span>
                    </h1>
                    <p class="max-w-3xl text-lg leading-8 text-base-content/72">${page.lede()}</p>
                </div>

                <div class="join join-vertical gap-3 sm:join-horizontal sm:flex-wrap">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="${page.primaryHref()}">${page.primaryLabel()}</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${page.secondaryHref()}">${page.secondaryLabel()}</a>
                    @if(!relatedProducts.isEmpty())
                        <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="#compare-product-lane">Open compare lane</a>
                    @endif
                </div>
            </div>

            <aside class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                <div class="card-body gap-5">
                    <div class="space-y-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Comparison posture</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Comparison works only when maintenance, certification, and fit stay visible together.</h2>
                    </div>
                    <ul class="menu gap-2 rounded-[1rem] bg-base-200/55 p-3">
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Query intent</strong><br>${page.queryIntent()}</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Upfront band</strong><br>${metrics.upfrontBand()}</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Annualized band</strong><br>${metrics.annualizedBand()}</span></li>
                    </ul>
                </div>
            </aside>
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
        <div class="stats stats-vertical gap-3 bg-transparent p-0 shadow-none xl:stats-horizontal">
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Query intent</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${page.queryIntent()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Built to resolve a high-intent comparison query with actual records.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Linked products</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${metrics.productCount()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Filtered to models already normalized in the engine.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Utility examples</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${metrics.utilityExampleCount()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Live dossiers keep the page tied to actual evidence routes.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Installation mix</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${metrics.installationMix()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">The page compares ownership classes, not just brand names.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Source set</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${compareSources.size()} records</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Official guidance, listings, performance PDFs, and product records.</div>
            </div>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                    <div class="card-body gap-5">
                        <div class="alert border border-base-300/70 bg-base-100 px-5 py-4 shadow-none">
                            <div class="space-y-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Compare next action</span>
                                <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">${page.nextActionTitle()}</h2>
                                <p class="text-sm leading-7 text-base-content/68">${page.nextActionSummary()}</p>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Comparison axes</span>
                        <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                            @for(var axis : page.comparisonAxes())
                                <li>${axis}</li>
                            @endfor
                        </ul>
                    </div>
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
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Evidence basis</h2>
                        <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                            @for(var item : page.evidenceHighlights())
                                <li>${item}</li>
                            @endfor
                        </ul>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Target queries</h2>
                        <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                            @for(var query : page.targetQueries())
                                <li>${query}</li>
                            @endfor
                        </ul>
                    </div>
                </section>

                @if(!relatedSystems.isEmpty())
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-5">
                            <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Live utility examples</h2>
                            <div class="space-y-3">
                                @for(var example : relatedSystems)
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/public-water/${example.system().pwsid()}">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${example.system().stateCode()} / ${example.system().pwsid()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${example.system().pwsName()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/60">${PresentationText.benchmarkRelationLabel(example.result().meta().benchmarkRelation())} / ${example.result().nextAction().title()}</div>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    </section>
                @endif

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Primary source ledger</h2>
                        <div class="space-y-3">
                            @for(var source : compareSources.subList(0, Math.min(compareSources.size(), 4)))
                                <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()} / ${source.organization()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                    <div class="mt-2 break-all text-sm leading-6 text-base-content/60">${source.url()}</div>
                                </a>
                            @endfor
                        </div>
                        @if(compareSources.size() > 4)
                            <div class="collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-200/34">
                                <input type="checkbox">
                                <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More sources (${compareSources.size() - 4})</div>
                                <div class="collapse-content">
                                    <div class="space-y-3 pt-2">
                                        @for(var source : compareSources.subList(4, compareSources.size()))
                                            <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()} / ${source.organization()}</div>
                                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                                <div class="mt-2 break-all text-sm leading-6 text-base-content/60">${source.url()}</div>
                                            </a>
                                        @endfor
                                    </div>
                                </div>
                            </div>
                        @endif
                    </div>
                </section>

                @if(!relatedGuides.isEmpty())
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-5">
                            <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Related guides</h2>
                            <div class="space-y-3">
                                @for(var guide : relatedGuides)
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/guides/${guide.slug()}">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${guide.eyebrow()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${guide.title()}</div>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    </section>
                @endif

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">All guides</h2>
                        <div class="space-y-3">
                            @for(var guide : allGuides)
                                <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/guides/${guide.slug()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${guide.eyebrow()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${guide.title()}</div>
                                </a>
                            @endfor
                        </div>
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
