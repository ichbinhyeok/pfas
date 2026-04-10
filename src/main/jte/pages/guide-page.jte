@import java.util.List
@import com.example.pfas.commercial.CommercialSurfaceState
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
@param List<GuidePage> searchPriorityGuides
@param boolean priorityGuide
@param List<SourceDocument> guideSources
@param List<GuideSystemExample> relatedSystemExamples
@param List<FilterCatalogItem> relatedProducts
@param List<ComparePage> relatedComparePages
@param CommercialSurfaceState commercialState
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
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
                <div class="space-y-6 bg-white/[0.03] p-7 md:p-9">
                    <div class="space-y-4">
                        <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">${page.eyebrow()}</span>
                        <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                            ${page.title()}
                        </h1>
                        <p class="max-w-3xl text-lg leading-8 text-white/72">${page.lede()}</p>
                    </div>

                    <div class="join join-vertical gap-3 sm:join-horizontal sm:flex-wrap">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold hover:bg-primary/92" href="${page.primaryHref()}" data-route-click-track="true" data-route-click-id="guide:${page.slug()}:primary" data-route-click-source-page="/guides/${page.slug()}" data-route-click-target-path="${page.primaryHref()}" data-route-click-cta-slot="guide_primary" data-route-click-family="guide_handoff" data-route-click-lane="${page.slug()}" data-route-click-region="">${page.primaryLabel()}</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="${page.secondaryHref()}" data-route-click-track="true" data-route-click-id="guide:${page.slug()}:secondary" data-route-click-source-page="/guides/${page.slug()}" data-route-click-target-path="${page.secondaryHref()}" data-route-click-cta-slot="guide_secondary" data-route-click-family="guide_handoff" data-route-click-lane="${page.slug()}" data-route-click-region="">${page.secondaryLabel()}</a>
                    @if(!relatedProducts.isEmpty())
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="#guide-product-lane">Compare linked products</a>
                    @endif
                </div>
                </div>

                <aside class="bg-white/[0.02] p-7 md:p-8">
                    <div class="space-y-2">
                        <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Guide posture</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-white">This page exists to resolve a next move, not to pad out an explainer.</h2>
                    </div>
                    <div class="terminal-pane mt-4 overflow-hidden">
                        <div class="terminal-stack">
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Search intent</strong><br>${page.queryIntent()}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Evidence basis</strong><br>${guideSources.size()} linked records</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Verification</strong><br>${page.lastVerifiedDate()}</article>
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
            scopeLabel = "Decision-intent guide",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="ledger-grid md:grid-cols-2 xl:grid-cols-5">
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Guide type</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">Manual decision guide</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Curated for high-intent PFAS routing questions.</div>
            </div>
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Search intent</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${page.queryIntent()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Guide copy is tuned for decision-intent queries, not generic PFAS explainers.</div>
            </div>
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Evidence basis</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${guideSources.size()} linked records</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Official guidance, utility documents, listings, or product records.</div>
            </div>
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Guide posture</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">Action-first</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">No safe or unsafe claim. No reviewer fiction. No generic roundup logic.</div>
            </div>
            <div class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Verification</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${page.lastVerifiedDate()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Guide copy is tied to the linked source set below.</div>
            </div>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="surface-panel-strong px-6 py-6">
                    <div class="space-y-2">
                        <span class="section-label">Guide next action</span>
                        <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">${page.nextActionTitle()}</h2>
                        <p class="text-sm leading-7 text-base-content/68">${page.nextActionSummary()}</p>
                    </div>
                </section>

                @if(priorityGuide)
                    <section class="surface-panel px-6 py-5">
                        <div class="space-y-2">
                            <span class="section-label">Action routes</span>
                            <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">Use this page to choose a next move now.</h2>
                            <p class="text-sm leading-7 text-base-content/68">These four guides are meant to end in a concrete action. They should settle evidence order, claim logic, ownership burden, and treatment scope before the user drifts back into generic PFAS browsing.</p>
                        </div>
                        <div class="mt-5 grid gap-4 md:grid-cols-2">
                            <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${page.primaryHref()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Primary route</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${page.primaryLabel()}</div>
                                <div class="mt-2 text-sm leading-6 text-base-content/68">Take the narrowest defensible next action this guide can support right now.</div>
                            </a>
                            <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${page.secondaryHref()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Secondary route</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${page.secondaryLabel()}</div>
                                <div class="mt-2 text-sm leading-6 text-base-content/68">Use the follow-up route only if the primary move still leaves the household with an open product or evidence question.</div>
                            </a>
                        </div>
                    </section>
                @endif

                @template.fragments.commercialState(
                    eyebrow = "Guide handoff state",
                    state = commercialState
                )

                @template.fragments.routeActions(
                    routeId = "guide:" + page.slug(),
                    routeTitle = page.title(),
                    routeSummary = commercialState.summary(),
                    routeUrl = "/guides/" + page.slug()
                )

                @if(!searchPriorityGuides.isEmpty())
                    <section class="surface-panel px-6 py-5">
                        <div class="space-y-2">
                            <span class="section-label">Priority decision guides</span>
                            <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">Keep the next filter question narrow.</h2>
                            <p class="text-sm leading-7 text-base-content/68">These guides settle the follow-up questions that tend to create premature shopping: whether evidence should come first, which claim language matters, how annual cost changes fit, and whether whole-house is actually justified.</p>
                        </div>
                        <div class="mt-5 grid gap-4 lg:grid-cols-2">
                            @for(var guide : searchPriorityGuides)
                                @if(!guide.slug().equals(page.slug()))
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/guides/${guide.slug()}">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${guide.eyebrow()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${guide.title()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/68">${guide.nextActionSummary()}</div>
                                    </a>
                                @endif
                            @endfor
                        </div>
                    </section>
                @endif

                @if(!relatedProducts.isEmpty())
                    <section class="surface-panel px-6 py-5">
                        <div class="space-y-5">
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

                <section class="surface-panel px-6 py-5">
                    <div class="space-y-4">
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
                    routeCode = commercialState.code(),
                    benchmarkRelation = "",
                    unlockState = commercialState.code(),
                    nextActionCode = page.nextActionTitle(),
                    products = relatedProducts.subList(0, Math.min(relatedProducts.size(), 8))
                )
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="surface-panel overflow-hidden">
                    <div class="px-6 py-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Operating file</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/64">Keep the few signals that justify this guide in view. Open the rest only when you need the supporting file.</p>
                    </div>
                    <div class="border-t border-base-300/70 px-6 py-5">
                        <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">Checklist</h3>
                        <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                            @for(var item : page.checklist())
                                <li>${item}</li>
                            @endfor
                        </ul>
                    </div>
                    <div class="border-t border-base-300/70 px-6 py-5">
                        <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">Evidence basis</h3>
                        <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                            @for(var item : page.evidenceHighlights())
                                <li>${item}</li>
                            @endfor
                        </ul>
                    </div>
                    <div class="collapse collapse-arrow rounded-none border-0 border-t border-base-300/70 bg-base-100">
                        <input type="checkbox" aria-label="Toggle primary source ledger">
                        <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">Primary source ledger (${guideSources.size()})</div>
                        <div class="collapse-content">
                            <div class="space-y-3 pt-2">
                                @for(var source : guideSources.subList(0, Math.min(guideSources.size(), 4)))
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()} / ${source.organization()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                        <div class="mt-2 break-all text-sm leading-6 text-base-content/60">${source.url()}</div>
                                    </a>
                                @endfor
                            </div>
                            @if(guideSources.size() > 4)
                                <div class="mt-3 rounded-[1rem] border border-base-300/70 bg-base-200/34 px-4 py-4 text-sm leading-7 text-base-content/68">Open the source page or expand on desktop if you need the full linked set.</div>
                            @endif
                        </div>
                    </div>
                    @if(!relatedSystemExamples.isEmpty())
                        <div class="collapse collapse-arrow rounded-none border-0 border-t border-base-300/70 bg-base-100">
                            <input type="checkbox" aria-label="Toggle live utility examples">
                            <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">Live utility examples (${relatedSystemExamples.size()})</div>
                            <div class="collapse-content">
                                <div class="space-y-3 pt-2">
                                    @for(var example : relatedSystemExamples.subList(0, Math.min(relatedSystemExamples.size(), 3)))
                                        <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/public-water/${example.system().pwsid()}" data-route-click-track="true" data-route-click-id="guide:${page.slug()}:system:${example.system().pwsid()}" data-route-click-source-page="/guides/${page.slug()}" data-route-click-target-path="/public-water/${example.system().pwsid()}" data-route-click-cta-slot="guide_live_system" data-route-click-family="guide_to_dossier" data-route-click-lane="${page.slug()}" data-route-click-region="${example.system().stateCode()}">
                                            <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${example.system().stateCode()} / ${example.system().pwsid()} / ${PresentationText.sourceWaterTypeLabel(example.system().sourceWaterType())}</div>
                                            <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${example.system().pwsName()}</div>
                                            <div class="mt-2 text-sm leading-6 text-base-content/60">${PresentationText.benchmarkRelationLabel(example.result().meta().benchmarkRelation())} / ${example.result().nextAction().title()}</div>
                                            <div class="mt-2 text-sm leading-6 text-base-content/72">${example.result().whyThis().isEmpty() ? "Utility-backed decision example." : example.result().whyThis().get(0)}</div>
                                        </a>
                                    @endfor
                                </div>
                            </div>
                        </div>
                    @endif
                    @if(!relatedProducts.isEmpty())
                        <div class="border-t border-base-300/70 px-6 py-5">
                            <p class="text-sm leading-7 text-base-content/74"><strong class="font-semibold text-base-content">Linked certified option lanes</strong> stay downstream from the guide thesis, the caveats, and the utility examples.</p>
                        </div>
                    @endif
                </section>

                <section class="surface-panel overflow-hidden">
                    <div class="px-6 py-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Related routes</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/64">These are secondary paths. They should not compete with the guide’s main decision line.</p>
                    </div>
                    @if(!relatedComparePages.isEmpty())
                        <div class="border-t border-base-300/70 px-6 py-5">
                            <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">Dedicated compare pages</h3>
                            <div class="mt-4 space-y-3">
                                @for(var comparePage : relatedComparePages.subList(0, Math.min(relatedComparePages.size(), 2)))
                                    <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/compare/${comparePage.slug()}" data-route-click-track="true" data-route-click-id="guide:${page.slug()}:compare:${comparePage.slug()}" data-route-click-source-page="/guides/${page.slug()}" data-route-click-target-path="/compare/${comparePage.slug()}" data-route-click-cta-slot="guide_related_compare" data-route-click-family="guide_to_compare" data-route-click-lane="${page.slug()}" data-route-click-region="">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${comparePage.eyebrow()} / ${comparePage.queryIntent()}</div>
                                        <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${comparePage.title()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/60">${comparePage.nextActionSummary()}</div>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    @endif
                    <div class="collapse collapse-arrow rounded-none border-0 border-t border-base-300/70 bg-base-100">
                        <input type="checkbox" aria-label="Toggle related guides">
                        <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">Related guides</div>
                        <div class="collapse-content">
                            <div class="space-y-3 pt-2">
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
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
