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
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <div class="space-y-4">
                    <span class="badge badge-outline border-base-300 bg-base-100 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-base-content/58">${page.eyebrow()}</span>
                    <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-base-content sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                        ${page.title()}
                        <span class="font-serif font-medium text-secondary">with the caveats still in view.</span>
                    </h1>
                    <p class="max-w-3xl text-lg leading-8 text-base-content/72">${page.lede()}</p>
                </div>

                <div class="join join-vertical gap-3 sm:join-horizontal sm:flex-wrap">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="${page.primaryHref()}">${page.primaryLabel()}</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${page.secondaryHref()}">${page.secondaryLabel()}</a>
                    @if(!relatedProducts.isEmpty())
                        <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="#guide-product-lane">Open comparison lane</a>
                    @endif
                </div>
            </div>

            <aside class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                <div class="card-body gap-5">
                    <div class="space-y-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Guide posture</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">This page exists to resolve a next move, not to pad out an explainer.</h2>
                    </div>
                    <ul class="menu gap-2 rounded-[1rem] bg-base-200/55 p-3">
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Search intent</strong><br>${page.queryIntent()}</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Evidence basis</strong><br>${guideSources.size()} linked records</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Verification</strong><br>${page.lastVerifiedDate()}</span></li>
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
            scopeLabel = "Decision-intent guide",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="stats stats-vertical gap-3 bg-transparent p-0 shadow-none xl:stats-horizontal">
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Guide type</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Manual decision guide</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Curated for high-intent PFAS routing questions.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Search intent</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${page.queryIntent()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Guide copy is tuned for decision-intent queries, not generic PFAS explainers.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Evidence basis</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${guideSources.size()} linked records</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Official guidance, utility documents, listings, or product records.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Guide posture</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Action-first</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">No safe or unsafe claim. No reviewer fiction. No generic roundup logic.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Verification</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${page.lastVerifiedDate()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Guide copy is tied to the linked source set below.</div>
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
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Guide next action</span>
                                <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">${page.nextActionTitle()}</h2>
                                <p class="text-sm leading-7 text-base-content/68">${page.nextActionSummary()}</p>
                            </div>
                        </div>
                    </div>
                </section>

                @if(!relatedProducts.isEmpty())
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-5">
                            <div class="grid gap-4 md:grid-cols-3">
                                <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Linked certified options</span>
                                    <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${relatedProducts.size()}</h3>
                                    <p class="mt-2 text-sm leading-6 text-base-content/66">Curated products tied to this guide's decision intent.</p>
                                </article>
                                <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Live utility examples</span>
                                    <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${relatedSystemExamples.size()}</h3>
                                    <p class="mt-2 text-sm leading-6 text-base-content/66">Direct dossiers tied to the same question cluster.</p>
                                </article>
                                <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Commercial posture</span>
                                    <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">Evidence first</h3>
                                    <p class="mt-2 text-sm leading-6 text-base-content/66">The product layer opens only after the guide frames the route.</p>
                                </article>
                            </div>
                        </div>
                    </section>
                @endif

                @for(var section : page.sections())
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-5">
                            <div class="space-y-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Guide analysis</span>
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

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">How this guide was built</span>
                        <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                            <li>Manual editorial synthesis over linked official and listing records.</li>
                            <li>Routing logic stays aligned with the engine's decision table and source policy.</li>
                            <li>Commercial records are used only for product, cost, or maintenance context, not household risk truth.</li>
                            <li>No external reviewer is claimed on this build.</li>
                        </ul>
                    </div>
                </section>

                @if(page.targetQueries() != null && !page.targetQueries().isEmpty())
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-4">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Query cluster</span>
                            <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                                @for(var query : page.targetQueries())
                                    <li>${query}</li>
                                @endfor
                            </ul>
                        </div>
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
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Checklist</h2>
                        <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                            @for(var item : page.checklist())
                                <li>${item}</li>
                            @endfor
                        </ul>
                    </div>
                </section>

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
                    <div class="card-body gap-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Primary source ledger</h2>
                        <div class="space-y-3">
                            @for(var source : guideSources.subList(0, Math.min(guideSources.size(), 4)))
                                <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()} / ${source.organization()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                    <div class="mt-2 break-all text-sm leading-6 text-base-content/60">${source.url()}</div>
                                </a>
                            @endfor
                        </div>
                        @if(guideSources.size() > 4)
                            <div class="collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-200/34">
                                <input type="checkbox">
                                <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More sources (${guideSources.size() - 4})</div>
                                <div class="collapse-content">
                                    <div class="space-y-3 pt-2">
                                        @for(var source : guideSources.subList(4, guideSources.size()))
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

                @if(!relatedSystemExamples.isEmpty())
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-5">
                            <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Live utility examples</h2>
                            <div class="space-y-3">
                                @for(var example : relatedSystemExamples)
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/public-water/${example.system().pwsid()}">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${example.system().stateCode()} / ${example.system().pwsid()} / ${PresentationText.sourceWaterTypeLabel(example.system().sourceWaterType())}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${example.system().pwsName()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/60">${PresentationText.benchmarkRelationLabel(example.result().meta().benchmarkRelation())} / ${example.result().nextAction().title()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/72">${example.result().whyThis().isEmpty() ? "Utility-backed decision example." : example.result().whyThis().get(0)}</div>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    </section>
                @endif

                @if(!relatedProducts.isEmpty())
                    <div class="alert border border-base-300/70 bg-base-100/92 px-5 py-4 shadow-[var(--shadow-soft)]">
                        <span class="text-sm leading-7 text-base-content/74"><strong class="font-semibold text-base-content">Linked certified option lanes</strong> stay downstream from the guide thesis, the caveats, and the utility examples.</span>
                    </div>
                @endif

                @if(!relatedComparePages.isEmpty())
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-5">
                            <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Dedicated compare pages</h2>
                            <div class="space-y-3">
                                @for(var comparePage : relatedComparePages)
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/compare/${comparePage.slug()}">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${comparePage.eyebrow()} / ${comparePage.queryIntent()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${comparePage.title()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/60">${comparePage.nextActionSummary()}</div>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    </section>
                @endif

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Related guides</h2>
                        <div class="space-y-3">
                            @for(var guide : allGuides)
                                @if(!guide.slug().equals(page.slug()))
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/guides/${guide.slug()}">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${guide.eyebrow()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${guide.title()}</div>
                                    </a>
                                @endif
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
