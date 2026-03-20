@import java.util.List
@import com.example.pfas.filter.FilterCatalogItem
@import com.example.pfas.source.SourceDocument
@import com.example.pfas.web.ComparePage
@import com.example.pfas.web.GuidePage
@import com.example.pfas.web.GuideSystemExample
@import com.example.pfas.web.PresentationText
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param GuidePage page
@param List<GuidePage> allGuides
@param List<SourceDocument> guideSources
@param List<GuideSystemExample> relatedSystemExamples
@param List<FilterCatalogItem> relatedProducts
@param List<ComparePage> relatedComparePages
@param boolean pageIndexable
@param String pageStructuredDataJson

@template.layout.base(
    pageTitle = page.title(),
    pageDescription = page.lede(),
    pageCanonicalUrl = siteBaseUrl + "/guides/" + page.slug(),
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
                    <span class="font-serif font-medium text-mineral-blue">with the caveats still in view.</span>
                </h1>
                <p class="max-w-3xl text-lg leading-8 text-slate-body">${page.lede()}</p>
                <div class="flex flex-wrap gap-3">
                    <a class="inline-flex items-center justify-center rounded-full bg-teal-deep px-6 py-3 text-sm font-semibold text-white transition duration-150 ease-out hover:-translate-y-px hover:bg-slate-deep" href="${page.primaryHref()}">${page.primaryLabel()}</a>
                    <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-6 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="${page.secondaryHref()}">${page.secondaryLabel()}</a>
                    @if(!relatedProducts.isEmpty())
                        <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-6 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="#guide-product-lane">Open comparison lane</a>
                    @endif
                </div>
            </div>

            <aside class="rounded-[22px] border border-shell-border bg-ivory-panel px-6 py-6 shadow-quiet">
                <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Guide posture</span>
                <div class="mt-4 space-y-4">
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Search intent</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">${page.queryIntent()}</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Evidence basis</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">${guideSources.size()} linked records</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Verification</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">${page.lastVerifiedDate()}</p>
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
            scopeLabel = "Decision-intent guide",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-5">
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Guide type</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">Manual decision guide</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Curated for high-intent PFAS routing questions.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Search intent</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${page.queryIntent()}</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Guide copy is tuned for decision-intent queries, not generic PFAS explainers.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Evidence basis</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${guideSources.size()} linked records</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Official guidance, utility documents, listings, or product records.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Guide posture</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">Action-first</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">No safe/unsafe claim. No reviewer fiction. No generic roundup logic.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Verification</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${page.lastVerifiedDate()}</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Guide copy is tied to the linked source set below.</p>
            </article>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.12fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                    <span class="inline-flex rounded-full border border-teal-deep/14 bg-teal-tint/70 px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-teal-deep">Guide next action</span>
                    <div class="mt-5 space-y-3">
                        <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Next action</p>
                        <h2 class="max-w-3xl text-3xl font-semibold tracking-[-0.04em] text-slate-deep md:text-[2.3rem]">${page.nextActionTitle()}</h2>
                        <p class="max-w-3xl text-base leading-8 text-slate-body">${page.nextActionSummary()}</p>
                    </div>
                </section>

                @if(!relatedProducts.isEmpty())
                    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                        <div class="grid gap-4 md:grid-cols-3">
                            <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Linked certified options</span>
                                <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${relatedProducts.size()}</h3>
                                <p class="mt-2 text-sm leading-6 text-slate-muted">Curated products tied to this guide's decision intent.</p>
                            </article>
                            <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Live utility examples</span>
                                <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${relatedSystemExamples.size()}</h3>
                                <p class="mt-2 text-sm leading-6 text-slate-muted">Direct dossiers tied to the same question cluster.</p>
                            </article>
                            <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Commercial posture</span>
                                <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">Evidence first</h3>
                                <p class="mt-2 text-sm leading-6 text-slate-muted">The product layer opens only after the guide frames the route.</p>
                            </article>
                        </div>
                    </section>
                @endif

                @for(var section : page.sections())
                    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                        <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Guide analysis</p>
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
                                        <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                                        <span>${bullet}</span>
                                    </li>
                                @endfor
                            </ul>
                        @endif
                    </section>
                @endfor

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

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">How this guide was built</p>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        <li class="flex gap-3">
                            <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                            <span>Manual editorial synthesis over linked official and listing records.</span>
                        </li>
                        <li class="flex gap-3">
                            <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                            <span>Routing logic stays aligned with the engine's decision table and source policy.</span>
                        </li>
                        <li class="flex gap-3">
                            <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                            <span>Commercial records are used only for product, cost, or maintenance context, not household risk truth.</span>
                        </li>
                        <li class="flex gap-3">
                            <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                            <span>No external reviewer is claimed on this build.</span>
                        </li>
                    </ul>
                </section>

                @if(page.targetQueries() != null && !page.targetQueries().isEmpty())
                    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                        <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Query cluster</p>
                        <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                            @for(var query : page.targetQueries())
                                <li class="flex gap-3">
                                    <span class="mt-2 h-1.5 w-1.5 rounded-full bg-[rgba(15,118,110,0.6)]"></span>
                                    <span>${query}</span>
                                </li>
                            @endfor
                        </ul>
                    </section>
                @endif

                @template.fragments.productLane(
                    sectionId = "guide-product-lane",
                    eyebrow = "Comparison lane",
                    title = "Official product records linked to this guide",
                    summary = "This lane is intentionally narrow. It routes from interpretation to concrete certified options without pretending every household should buy the same class.",
                    sourcePage = "/guides/" + page.slug(),
                    routeType = "guide",
                    ctaSlot = "guide_product_lane",
                    products = relatedProducts.subList(0, Math.min(relatedProducts.size(), 8))
                )
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Checklist</h2>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for(var item : page.checklist())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                                <span>${item}</span>
                            </li>
                        @endfor
                    </ul>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Evidence basis</h2>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for(var item : page.evidenceHighlights())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-[rgba(15,118,110,0.6)]"></span>
                                <span>${item}</span>
                            </li>
                        @endfor
                    </ul>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Primary source ledger</h2>
                    <div class="mt-5 space-y-3">
                        @for(var source : guideSources)
                            <a class="block rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong" href="${source.url()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${source.title()}</div>
                                <div class="mt-2 break-all text-sm leading-6 text-slate-muted">${source.url()}</div>
                            </a>
                        @endfor
                    </div>
                </section>

                @if(!relatedSystemExamples.isEmpty())
                    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Live utility examples</h2>
                        <div class="mt-5 space-y-3">
                            @for(var example : relatedSystemExamples)
                                <a class="block rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong" href="/public-water/${example.system().pwsid()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">${example.system().stateCode()} / ${example.system().pwsid()} / ${PresentationText.sourceWaterTypeLabel(example.system().sourceWaterType())}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${example.system().pwsName()}</div>
                                    <div class="mt-2 text-sm leading-6 text-slate-muted">${PresentationText.benchmarkRelationLabel(example.result().meta().benchmarkRelation())} / ${example.result().nextAction().title()}</div>
                                    <div class="mt-2 text-sm leading-6 text-slate-body">${example.result().whyThis().isEmpty() ? "Utility-backed decision example." : example.result().whyThis().get(0)}</div>
                                </a>
                            @endfor
                        </div>
                    </section>
                @endif

                @if(!relatedProducts.isEmpty())
                    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Linked certified option lanes</h2>
                        <p class="mt-4 text-sm leading-7 text-slate-body">Use the comparison lane in the main column when you want a direct merchant path with upkeep and claim context side by side.</p>
                    </section>
                @endif

                @if(!relatedComparePages.isEmpty())
                    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Dedicated compare pages</h2>
                        <div class="mt-5 space-y-3">
                            @for(var comparePage : relatedComparePages)
                                <a class="block rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong" href="/compare/${comparePage.slug()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">${comparePage.eyebrow()} / ${comparePage.queryIntent()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${comparePage.title()}</div>
                                    <div class="mt-2 text-sm leading-6 text-slate-muted">${comparePage.nextActionSummary()}</div>
                                </a>
                            @endfor
                        </div>
                    </section>
                @endif

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Related guides</h2>
                    <div class="mt-5 space-y-3">
                        @for(var guide : allGuides)
                            @if(!guide.slug().equals(page.slug()))
                                <a class="block rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong" href="/guides/${guide.slug()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">${guide.eyebrow()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${guide.title()}</div>
                                </a>
                            @endif
                        @endfor
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
