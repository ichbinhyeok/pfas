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
<section class="pt-12 md:pt-16">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.12fr)_23rem] xl:items-start">
            <div class="space-y-5">
                <span class="inline-flex rounded-full border border-shell-border bg-ivory-panel px-4 py-2 text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">${page.eyebrow()}</span>
                <h1 class="max-w-4xl text-4xl font-semibold tracking-[-0.05em] text-slate-deep sm:text-5xl lg:text-[3.45rem] lg:leading-[1.04]">
                    ${page.title()}
                    <span class="font-serif font-medium text-mineral-blue">without decorative noise.</span>
                </h1>
                <p class="max-w-3xl text-lg leading-8 text-slate-body">${page.lede()}</p>
                <div class="flex flex-wrap gap-3">
                    <a class="inline-flex items-center justify-center rounded-full bg-teal-deep px-6 py-3 text-sm font-semibold text-white transition duration-150 ease-out hover:-translate-y-px hover:bg-slate-deep" href="${page.primaryHref()}">${page.primaryLabel()}</a>
                    <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-6 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="${page.secondaryHref()}">${page.secondaryLabel()}</a>
                    @if(!relatedProducts.isEmpty())
                        <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-6 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="#compare-product-lane">Open compare lane</a>
                    @endif
                </div>
            </div>

            <aside class="rounded-[22px] border border-shell-border bg-ivory-panel px-6 py-6 shadow-quiet">
                <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Comparison posture</span>
                <div class="mt-4 space-y-4">
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Query intent</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">${page.queryIntent()}</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Upfront band</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">${metrics.upfrontBand()}</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Annualized band</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">${metrics.annualizedBand()}</p>
                    </div>
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

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-5">
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Query intent</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${page.queryIntent()}</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Built to resolve a high-intent comparison query with actual records.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Linked products</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${metrics.productCount()}</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Filtered to models already normalized in the engine.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Utility examples</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${metrics.utilityExampleCount()}</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Live dossiers keep the page tied to actual evidence routes.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Installation mix</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${metrics.installationMix()}</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">The page compares ownership classes, not just brand names.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Source set</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${compareSources.size()} records</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Official guidance, listings, performance PDFs, and product records.</p>
            </article>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.12fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                    <span class="inline-flex rounded-full border border-teal-deep/14 bg-teal-tint/70 px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-teal-deep">Compare next action</span>
                    <div class="mt-5 space-y-3">
                        <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Comparison posture</p>
                        <h2 class="max-w-3xl text-3xl font-semibold tracking-[-0.04em] text-slate-deep md:text-[2.3rem]">${page.nextActionTitle()}</h2>
                        <p class="max-w-3xl text-base leading-8 text-slate-body">${page.nextActionSummary()}</p>
                    </div>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                    <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Decision-to-product lane</p>
                    <div class="grid gap-4 md:grid-cols-3">
                        <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">First move</span>
                            <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${page.nextActionTitle()}</h3>
                            <p class="mt-2 text-sm leading-6 text-slate-muted">${page.nextActionSummary()}</p>
                        </article>
                        <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Not this page for</span>
                            <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">Blind upgrading</h3>
                            <p class="mt-2 text-sm leading-6 text-slate-muted">${page.whatThisDoesNotTellYou().isEmpty() ? "This compare page is not a generic upgrade prompt." : page.whatThisDoesNotTellYou().get(0)}</p>
                        </article>
                        <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Commercial path</span>
                            <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">Official records first</h3>
                            <p class="mt-2 text-sm leading-6 text-slate-muted">Use the compare lane only after the compare thesis and maintenance burden are visible.</p>
                        </article>
                    </div>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Comparison axes</p>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for(var axis : page.comparisonAxes())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                                <span>${axis}</span>
                            </li>
                        @endfor
                    </ul>
                </section>

                @for(var section : page.sections())
                    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                        <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Compare analysis</p>
                        <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-slate-deep">${section.title()}</h2>
                        @if(section.summary() != null && !section.summary().isBlank())
                            <p class="mt-4 text-base leading-8 text-slate-body">${section.summary()}</p>
                        @endif
                        @for(var paragraph : section.paragraphs())
                            <p class="mt-4 text-base leading-8 text-slate-body">${paragraph}</p>
                        @endfor
                        @if(section.bullets() != null && !section.bullets().isEmpty())
                            <ul class="mt-5 space-y-3 text-sm leading-7 text-slate-body">
                                @for(var bullet : section.bullets())
                                    <li class="flex gap-3">
                                        <span class="mt-2 h-1.5 w-1.5 rounded-full bg-[rgba(15,118,110,0.6)]"></span>
                                        <span>${bullet}</span>
                                    </li>
                                @endfor
                            </ul>
                        @endif
                    </section>
                @endfor

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                    <div class="flex flex-col gap-3 border-b border-shell-border pb-6 md:flex-row md:items-end md:justify-between">
                        <div class="space-y-2">
                            <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Structured comparison</p>
                            <h2 class="text-3xl font-semibold tracking-[-0.04em] text-slate-deep">Structured comparison</h2>
                        </div>
                        <p class="max-w-2xl text-sm leading-7 text-slate-muted">The page compares upkeep, installation class, certification scope, seller choice, and fit instead of flattening everything into a single badge.</p>
                    </div>
                    <div class="mt-6 grid gap-5 xl:grid-cols-2">
                        @for(var product : relatedProducts)
                            <article class="rounded-[20px] border border-shell-border bg-ivory px-5 py-5 shadow-quiet transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong">
                                <div class="flex items-start justify-between gap-3">
                                    <div class="space-y-2">
                                        <p class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">${product.brand()} / ${PresentationText.installationTypeLabel(product.installationType())}</p>
                                        <h3 class="text-2xl font-semibold tracking-[-0.03em] text-slate-deep">${product.model()}</h3>
                                    </div>
                                    <span class="inline-flex rounded-full border border-teal-deep/12 bg-teal-tint/70 px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-teal-deep">${PresentationText.filterTypeLabel(product.filterType())}</span>
                                </div>
                                <div class="mt-5 grid gap-3 md:grid-cols-2">
                                    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Standards</span>
                                        <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${product.certBody()} ${product.standardCode()}</span>
                                    </article>
                                    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Merchant</span>
                                        <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.merchantLabel(product)}</span>
                                    </article>
                                    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Upfront</span>
                                        <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.currencyLabel(product.upfrontCostUsd())}</span>
                                    </article>
                                    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Annualized</span>
                                        <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.annualizedMaintenanceLabel(product)}</span>
                                    </article>
                                    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Best for</span>
                                        <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.bestForLabel(product)}</span>
                                    </article>
                                    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Seller choice</span>
                                        <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.sellerChoiceNote(product)}</span>
                                    </article>
                                </div>
                                <div class="mt-5 text-sm leading-7 text-slate-body">PFAS coverage ${PresentationText.previewList(product.coveredPfas(), 4)} / Maintenance ${PresentationText.maintenanceBurdenLabel(product)} / Next step ${PresentationText.nextStepLabel(product)}</div>
                            </article>
                        @endfor
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

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Why this</p>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for(var item : page.whyThis())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                                <span>${item}</span>
                            </li>
                        @endfor
                    </ul>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">What this does not tell you</p>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for(var item : page.whatThisDoesNotTellYou())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-[rgba(15,118,110,0.6)]"></span>
                                <span>${item}</span>
                            </li>
                        @endfor
                    </ul>
                </section>
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Evidence basis</h2>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for(var item : page.evidenceHighlights())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                                <span>${item}</span>
                            </li>
                        @endfor
                    </ul>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Target queries</h2>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for(var query : page.targetQueries())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-[rgba(15,118,110,0.6)]"></span>
                                <span>${query}</span>
                            </li>
                        @endfor
                    </ul>
                </section>

                @if(!relatedSystems.isEmpty())
                    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Live utility examples</h2>
                        <div class="mt-5 space-y-3">
                            @for(var example : relatedSystems)
                                <a class="block rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong" href="/public-water/${example.system().pwsid()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">${example.system().stateCode()} / ${example.system().pwsid()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${example.system().pwsName()}</div>
                                    <div class="mt-2 text-sm leading-6 text-slate-muted">${PresentationText.benchmarkRelationLabel(example.result().meta().benchmarkRelation())} / ${example.result().nextAction().title()}</div>
                                </a>
                            @endfor
                        </div>
                    </section>
                @endif

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Primary source ledger</h2>
                    <div class="mt-5 space-y-3">
                        @for(var source : compareSources)
                            <a class="block rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong" href="${source.url()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${source.title()}</div>
                                <div class="mt-2 break-all text-sm leading-6 text-slate-muted">${source.url()}</div>
                            </a>
                        @endfor
                    </div>
                </section>

                @if(!relatedGuides.isEmpty())
                    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Related guides</h2>
                        <div class="mt-5 space-y-3">
                            @for(var guide : relatedGuides)
                                <a class="block rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong" href="/guides/${guide.slug()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">${guide.eyebrow()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${guide.title()}</div>
                                </a>
                            @endfor
                        </div>
                    </section>
                @endif

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">All guides</h2>
                    <div class="mt-5 space-y-3">
                        @for(var guide : allGuides)
                            <a class="block rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong" href="/guides/${guide.slug()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">${guide.eyebrow()}</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${guide.title()}</div>
                            </a>
                        @endfor
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
