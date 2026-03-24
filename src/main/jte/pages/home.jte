@import com.example.pfas.checker.ActionCheckerRecommendation
@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.state.StateGuidance
@import com.example.pfas.water.PublicWaterSystem
@import com.example.pfas.web.ComparePage
@import com.example.pfas.web.GuidePage
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param String siteLastVerifiedDate
@param java.util.List<StateGuidance> states
@param java.util.List<StateGuidance> featuredStates
@param java.util.List<PublicWaterSystem> systems
@param java.util.List<PublicWaterSystem> featuredSystems
@param java.util.List<PublicWaterSystem> featuredPennsylvaniaSystems
@param java.util.List<GuidePage> guides
@param java.util.List<ComparePage> compares
@param ActionCheckerSelection checkerSelection
@param ActionCheckerRecommendation checkerRecommendation

@template.layout.base(
    pageTitle = "PFAS in Drinking Water: What to Do First for Public Water or Private Wells",
    pageDescription = "Find out whether to read your CCR, check a utility PFAS record, test a private well, or compare certified PFAS filters before you buy.",
    pageCanonicalUrl = siteBaseUrl + "/",
    pageIndexable = true,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.18fr)_24rem]">
                <div class="space-y-8 bg-white/[0.03] p-7 md:p-9">
                    <div class="space-y-5">
                        <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">Quiet infrastructure for water decisions</span>
                        <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl lg:text-[4.2rem] lg:leading-[0.98]">
                            PFAS in water: what should you do first?
                            <span class="font-serif font-medium text-white/72">Start with the right record before you shop for a filter.</span>
                        </h1>
                        <p class="max-w-3xl text-lg leading-8 text-white/72">
                            Use utility records, private-well testing paths, and certified filter comparisons to figure out
                            whether the next move is reading a CCR, checking a PFAS notice, ordering a well test, or comparing
                            point-of-use options without overspending.
                        </p>
                    </div>

                    <div class="join join-vertical gap-3 sm:join-horizontal">
                        <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold hover:bg-primary/92" href="/checker">Check your PFAS next step</a>
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="/methodology">Read methodology</a>
                    </div>
                </div>

                <aside class="space-y-4 bg-white/[0.02] p-7 md:p-8">
                    <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Operating stance</span>
                    <h2 class="text-2xl font-semibold tracking-[-0.03em] text-white">Built like a control room, not a promo page.</h2>
                    <div class="terminal-pane overflow-hidden">
                        <div class="terminal-stack">
                            <article class="px-4 py-4 text-sm leading-6 text-white/78">
                                <strong class="font-semibold text-white">Evidence stack</strong><br>EPA, state guidance, utility documents, and captured listing records.
                            </article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78">
                                <strong class="font-semibold text-white">Reading rhythm</strong><br>Calm, benchmark-aware, and explicit about what the data does not settle.
                            </article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78">
                                <strong class="font-semibold text-white">Decision posture</strong><br>Verify first. Compare only after the household context is anchored.
                            </article>
                        </div>
                    </div>
                </aside>
            </div>

            <div class="terminal-grid border-x-0 border-b-0 rounded-none lg:grid-cols-3">
                <article class="px-6 py-5">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/48">Interpretation bias</div>
                    <div class="mt-3 text-xl font-semibold tracking-[-0.03em] text-white">Direct evidence first</div>
                    <div class="mt-3 text-sm leading-6 text-white/62">Utility records and well tests open before any shopping path.</div>
                </article>
                <article class="px-6 py-5">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/48">Trust layer</div>
                    <div class="mt-3 text-xl font-semibold tracking-[-0.03em] text-white">Caveats stay visible</div>
                    <div class="mt-3 text-sm leading-6 text-white/62">Limits remain in the main reading path instead of disappearing below the fold.</div>
                </article>
                <article class="px-6 py-5">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/48">Commercial posture</div>
                    <div class="mt-3 text-xl font-semibold tracking-[-0.03em] text-white">Point-of-use before escalation</div>
                    <div class="mt-3 text-sm leading-6 text-white/62">Certified point-of-use opens before whole-house and only with claim-level support.</div>
                </article>
            </div>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        @template.fragments.publicationStrip(
            lastVerified = siteLastVerifiedDate,
            scopeLabel = "Homepage and entry routing",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell space-y-8">
        <div class="grid gap-6 xl:grid-cols-[minmax(0,1.15fr)_22rem] xl:items-end">
            <div class="space-y-3">
                <span class="section-label">Action intake</span>
                <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-base-content md:text-[3rem] md:leading-[1.02]">
                    Check the next PFAS step for your household.
                    <span class="font-serif font-medium text-secondary">Use the same intake flow that powers the full checker.</span>
                </h2>
                <p class="max-w-3xl text-base leading-8 text-base-content/68">This server-backed intake keeps the evidence order visible so you can decide whether to read a utility record, test a well, or compare PFAS filters next.</p>
            </div>
            <div class="surface-muted px-5 py-4">
                <span class="text-sm font-medium leading-7 text-base-content/76"><strong class="font-semibold text-base-content">Homepage discipline</strong> No fear copy, no affiliate-first detour, and no fake certainty.</span>
            </div>
        </div>

        <div class="surface-panel md:hidden">
            <div class="grid gap-4 p-5">
                <div class="space-y-2">
                    <span class="section-label">Quick route</span>
                    <h3 class="text-2xl font-semibold tracking-[-0.04em] text-base-content">${checkerRecommendation.title()}</h3>
                    <p class="text-sm leading-7 text-base-content/68">${checkerRecommendation.summary()}</p>
                </div>
                <div class="ledger-grid">
                    <article class="px-4 py-4">
                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Current preview</div>
                        <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-base-content">${checkerRecommendation.title()}</div>
                    </article>
                    <article class="px-4 py-4">
                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Recommended next page</div>
                        <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-base-content">${checkerRecommendation.primaryLabel()}</div>
                    </article>
                </div>
                <div class="join join-vertical gap-3 sm:join-horizontal">
                    <a class="btn btn-primary join-item h-11 rounded-full border-0 px-5 text-sm font-semibold" href="/checker">Check your PFAS next step</a>
                    <a class="btn btn-outline join-item h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content" href="${checkerRecommendation.primaryHref()}">Review recommended page</a>
                </div>
            </div>
        </div>
    </div>

    <div class="hidden md:block">
        @template.fragments.checkerPanel(
            states = states,
            featuredStates = featuredStates,
            systems = systems,
            featuredSystems = featuredSystems,
            featuredPennsylvaniaSystems = featuredPennsylvaniaSystems,
            selection = checkerSelection,
            recommendation = checkerRecommendation
        )
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="mb-8 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div class="space-y-3">
                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Entry pages</span>
                <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-base-content md:text-[3rem] md:leading-[1.04]">PFAS guides built around the questions people actually search.</h2>
                <p class="max-w-3xl text-base leading-8 text-base-content/68">These pages absorb real search intent and move the reader into a clearer action or comparison path.</p>
            </div>
        </div>

        @if (!guides.isEmpty())
            <article class="overflow-hidden rounded-[1.35rem] border border-base-300/70 bg-base-100/96 shadow-[var(--shadow-panel)]">
                <div class="grid gap-px bg-base-300/70 lg:grid-cols-[minmax(0,1fr)_18rem]">
                    <div class="bg-base-100/96 p-7 md:p-8">
                        <div class="flex flex-wrap items-center gap-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${guides.get(0).eyebrow()}</span>
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Last verified ${guides.get(0).lastVerifiedDate()}</span>
                        </div>
                        <h3 class="mt-5 max-w-3xl text-[2rem] font-semibold tracking-[-0.04em] text-base-content md:text-[2.35rem] md:leading-[1.02]">${guides.get(0).title()}</h3>
                        <p class="mt-4 max-w-3xl text-base leading-8 text-base-content/68">${guides.get(0).lede()}</p>
                        <div class="mt-6 flex flex-wrap gap-3">
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/${guides.get(0).slug()}">Read guide</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guides.get(0).primaryHref()}">${guides.get(0).primaryLabel()}</a>
                        </div>
                    </div>
                    <aside class="bg-base-200/58 p-6 md:p-7">
                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Why this page exists</div>
                        <p class="mt-4 text-sm leading-7 text-base-content/72">This is a decision-intent page, not a glossary page. It should close the gap between search intent and the next accountable move.</p>
                        <div class="mt-6 border-t border-base-300/70 pt-6">
                            <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Next action in view</div>
                            <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">${guides.get(0).primaryLabel()}</p>
                        </div>
                    </aside>
                </div>
            </article>
        @endif

        @if (guides.size() > 1)
            <div class="surface-panel mt-5 overflow-hidden">
                @for (var guide : guides.subList(1, Math.min(3, guides.size())))
                    <article class="row-link grid gap-5 px-6 py-6 lg:grid-cols-[minmax(0,1.35fr)_12rem_16rem] lg:items-start ${guide != guides.get(1) ? "border-t border-base-300/70" : ""}">
                        <div class="space-y-3">
                            <div class="flex flex-wrap items-center gap-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${guide.eyebrow()}</span>
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${guide.lastVerifiedDate()}</span>
                            </div>
                            <h3 class="text-[1.45rem] font-semibold tracking-[-0.035em] text-base-content">${guide.title()}</h3>
                            <p class="text-sm leading-7 text-base-content/68">${guide.lede()}</p>
                        </div>
                        <div class="py-1">
                            <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Next move</div>
                            <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">${guide.primaryLabel()}</p>
                            <p class="mt-2 text-sm leading-6 text-base-content/62">This page exists to reduce drift between search intent and an accountable next action.</p>
                        </div>
                        <div class="flex flex-wrap gap-3 lg:justify-end">
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/${guide.slug()}">Read guide</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guide.primaryHref()}">${guide.primaryLabel()}</a>
                        </div>
                    </article>
                @endfor
            </div>
            @if (guides.size() > 3)
                <details class="mt-4 collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <summary class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More decision-intent pages (${guides.size() - 3})</summary>
                    <div class="collapse-content">
                        <div class="overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100 pt-2">
                            @for (var guide : guides.subList(3, guides.size()))
                                <article class="grid gap-4 px-5 py-5 ${guide != guides.get(3) ? "border-t border-base-300/70" : ""} lg:grid-cols-[minmax(0,1fr)_14rem] lg:items-start">
                                    <div class="space-y-3">
                                        <div class="flex flex-wrap items-center gap-2">
                                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${guide.eyebrow()}</span>
                                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${guide.lastVerifiedDate()}</span>
                                        </div>
                                        <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">${guide.title()}</h3>
                                        <p class="text-sm leading-7 text-base-content/68">${guide.lede()}</p>
                                    </div>
                                    <div class="flex flex-wrap gap-3 lg:justify-end">
                                        <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/${guide.slug()}">Read guide</a>
                                        <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guide.primaryHref()}">${guide.primaryLabel()}</a>
                                    </div>
                                </article>
                            @endfor
                        </div>
                    </div>
                </details>
            @endif
        @endif
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="mb-8 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div class="space-y-3">
                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Curated compare lanes</span>
                <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-base-content md:text-[3rem] md:leading-[1.04]">Comparison pages stay downstream from the evidence path.</h2>
                <p class="max-w-3xl text-base leading-8 text-base-content/68">These compare lanes only make sense after the record is read. The homepage now exposes that handoff directly instead of burying it behind generic product discovery.</p>
            </div>
        </div>

        <div class="surface-muted mb-5 px-5 py-5">
            <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Commercial logic lanes</span>
                    <p class="max-w-3xl text-sm leading-7 text-base-content/72">The next compare layer should reward state-led private-well routing, annual ownership burden, and claim-level certification logic instead of a generic best-filter voice.</p>
                </div>
                <div class="flex flex-wrap gap-2">
                    <a class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content transition duration-150 ease-out hover:-translate-y-px hover:border-primary hover:text-primary" href="/compare/private-well-certified-pou-after-test" data-route-click-track="true" data-route-click-id="home:commercial:private-well" data-route-click-source-page="/" data-route-click-target-path="/compare/private-well-certified-pou-after-test" data-route-click-cta-slot="commercial_logic_lane" data-route-click-family="commercial_logic" data-route-click-lane="private_well_compare" data-route-click-region="multi">Private-well compare</a>
                    <a class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content transition duration-150 ease-out hover:-translate-y-px hover:border-primary hover:text-primary" href="/compare/pfas-filter-annual-cost-compare" data-route-click-track="true" data-route-click-id="home:commercial:annual-cost" data-route-click-source-page="/" data-route-click-target-path="/compare/pfas-filter-annual-cost-compare" data-route-click-cta-slot="commercial_logic_lane" data-route-click-family="commercial_logic" data-route-click-lane="annual_cost_compare" data-route-click-region="multi">Annual cost compare</a>
                    <a class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content transition duration-150 ease-out hover:-translate-y-px hover:border-primary hover:text-primary" href="/compare/nsf-53-vs-58-claim-examples" data-route-click-track="true" data-route-click-id="home:commercial:nsf" data-route-click-source-page="/" data-route-click-target-path="/compare/nsf-53-vs-58-claim-examples" data-route-click-cta-slot="commercial_logic_lane" data-route-click-family="commercial_logic" data-route-click-lane="nsf_compare" data-route-click-region="multi">NSF claim examples</a>
                </div>
            </div>
        </div>

        @if (!compares.isEmpty())
            <article class="overflow-hidden rounded-[1.35rem] border border-base-300/70 bg-base-100/96 shadow-[var(--shadow-panel)]">
                <div class="grid gap-px bg-base-300/70 lg:grid-cols-[minmax(0,1fr)_18rem]">
                    <div class="bg-base-100/96 p-7 md:p-8">
                        <div class="flex flex-wrap items-center gap-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${compares.get(0).eyebrow()}</span>
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${compares.get(0).queryIntent()}</span>
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Last verified ${compares.get(0).lastVerifiedDate()}</span>
                        </div>
                        <h3 class="mt-5 max-w-3xl text-[2rem] font-semibold tracking-[-0.04em] text-base-content md:text-[2.35rem] md:leading-[1.02]">${compares.get(0).title()}</h3>
                        <p class="mt-4 max-w-3xl text-base leading-8 text-base-content/68">${compares.get(0).lede()}</p>
                        <div class="mt-6 flex flex-wrap gap-3">
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/compare/${compares.get(0).slug()}">Compare options</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${compares.get(0).primaryHref()}">${compares.get(0).primaryLabel()}</a>
                        </div>
                    </div>
                    <aside class="bg-base-200/36 p-6 md:p-7">
                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Why this compare exists</div>
                        <p class="mt-4 text-sm leading-7 text-base-content/72">This lane is not a generic roundup. It exists to keep households inside a narrower post-evidence compare path with claim-level support still in view.</p>
                        <div class="mt-6 border-t border-base-300/70 pt-6">
                            <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Next action in view</div>
                            <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">${compares.get(0).nextActionTitle()}</p>
                            <p class="mt-2 text-sm leading-6 text-base-content/62">${compares.get(0).nextActionSummary()}</p>
                        </div>
                    </aside>
                </div>
            </article>
        @endif

        @if (compares.size() > 1)
            <div class="surface-panel mt-5 overflow-hidden">
                @for (var compare : compares.subList(1, Math.min(3, compares.size())))
                    <article class="row-link grid gap-5 px-6 py-6 lg:grid-cols-[minmax(0,1.35fr)_12rem_16rem] lg:items-start ${compare != compares.get(1) ? "border-t border-base-300/70" : ""}">
                        <div class="space-y-3">
                            <div class="flex flex-wrap items-center gap-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${compare.eyebrow()}</span>
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${compare.queryIntent()}</span>
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${compare.lastVerifiedDate()}</span>
                            </div>
                            <h3 class="text-[1.45rem] font-semibold tracking-[-0.035em] text-base-content">${compare.title()}</h3>
                            <p class="text-sm leading-7 text-base-content/68">${compare.lede()}</p>
                        </div>
                        <div class="py-1">
                            <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Guardrail</div>
                            <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">${compare.nextActionTitle()}</p>
                            <p class="mt-2 text-sm leading-6 text-base-content/62">${compare.nextActionSummary()}</p>
                        </div>
                        <div class="flex flex-wrap gap-3 lg:justify-end">
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/compare/${compare.slug()}">Compare options</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${compare.primaryHref()}">${compare.primaryLabel()}</a>
                        </div>
                    </article>
                @endfor
            </div>
            @if (compares.size() > 3)
                <details class="mt-4 collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <summary class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More compare lanes (${compares.size() - 3})</summary>
                    <div class="collapse-content">
                        <div class="overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100 pt-2">
                            @for (var compare : compares.subList(3, compares.size()))
                                <article class="grid gap-4 px-5 py-5 ${compare != compares.get(3) ? "border-t border-base-300/70" : ""} lg:grid-cols-[minmax(0,1fr)_14rem] lg:items-start">
                                    <div class="space-y-3">
                                        <div class="flex flex-wrap items-center gap-2">
                                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${compare.eyebrow()}</span>
                                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${compare.queryIntent()}</span>
                                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${compare.lastVerifiedDate()}</span>
                                        </div>
                                        <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">${compare.title()}</h3>
                                        <p class="text-sm leading-7 text-base-content/68">${compare.lede()}</p>
                                    </div>
                                    <div class="flex flex-wrap gap-3 lg:justify-end">
                                        <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/compare/${compare.slug()}">Compare options</a>
                                        <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${compare.primaryHref()}">${compare.primaryLabel()}</a>
                                    </div>
                                </article>
                            @endfor
                        </div>
                    </div>
                </details>
            @endif
        @endif
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="mb-8 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div class="space-y-3">
                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Regional dossier corridors</span>
                <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-base-content md:text-[3rem] md:leading-[1.04]">Pennsylvania, New Jersey, and California now have regional lanes that stay downstream from utility records.</h2>
                <p class="max-w-3xl text-base leading-8 text-base-content/68">Use the state label only as navigation. The actual decision still belongs to the exact system dossier, then to a narrower certified point-of-use compare if the route supports it.</p>
            </div>
        </div>

        <div class="surface-panel overflow-hidden">
            <article class="row-link grid gap-5 px-6 py-6 lg:grid-cols-[minmax(0,1.25fr)_16rem_18rem] lg:items-start">
                <div class="space-y-3">
                    <div class="flex flex-wrap items-center gap-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Pennsylvania corridor</span>
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Guide + compare</span>
                    </div>
                    <h3 class="text-[1.45rem] font-semibold tracking-[-0.035em] text-base-content">Read the Pennsylvania dossier cluster, then open the regional post-utility compare lane.</h3>
                    <p class="text-sm leading-7 text-base-content/68">Philadelphia, Lancaster, Penn Estates, and Aqua Pennsylvania Main now form a state corridor that still behaves like four separate utility records.</p>
                </div>
                <div class="py-1">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Route logic</div>
                    <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">System dossier first</p>
                    <p class="mt-2 text-sm leading-6 text-base-content/62">Use the guide to stay system-led. Use the compare lane only after the utility route is interpretable.</p>
                </div>
                <div class="flex flex-wrap gap-3 lg:justify-end">
                    <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/pennsylvania-pfas-utility-records" data-route-click-track="true" data-route-click-id="home:pa-corridor:guide" data-route-click-source-page="/" data-route-click-target-path="/guides/pennsylvania-pfas-utility-records" data-route-click-cta-slot="regional_corridor_guide" data-route-click-family="regional_corridor" data-route-click-lane="pennsylvania_corridor" data-route-click-region="PA">Read Pennsylvania guide</a>
                    <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/compare/pennsylvania-certified-pou-after-utility-context" data-route-click-track="true" data-route-click-id="home:pa-corridor:compare" data-route-click-source-page="/" data-route-click-target-path="/compare/pennsylvania-certified-pou-after-utility-context" data-route-click-cta-slot="regional_corridor_compare" data-route-click-family="regional_corridor" data-route-click-lane="pennsylvania_corridor" data-route-click-region="PA">Compare Pennsylvania options</a>
                </div>
            </article>
            <article class="row-link grid gap-5 border-t border-base-300/70 px-6 py-6 lg:grid-cols-[minmax(0,1.25fr)_16rem_18rem] lg:items-start">
                <div class="space-y-3">
                    <div class="flex flex-wrap items-center gap-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">New Jersey corridor</span>
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Guide + compare</span>
                    </div>
                    <h3 class="text-[1.45rem] font-semibold tracking-[-0.035em] text-base-content">Read the New Jersey utility pair, then open the regional post-utility compare lane.</h3>
                    <p class="text-sm leading-7 text-base-content/68">Hamilton and Montague now give the engine both an action-heavy and a lighter dossier inside one regional corridor.</p>
                </div>
                <div class="py-1">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Route logic</div>
                    <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">Utility context first</p>
                    <p class="mt-2 text-sm leading-6 text-base-content/62">Use the guide to separate Hamilton from Montague. Use the compare lane only after that difference is clear.</p>
                </div>
                <div class="flex flex-wrap gap-3 lg:justify-end">
                    <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/new-jersey-pfas-utility-records" data-route-click-track="true" data-route-click-id="home:nj-corridor:guide" data-route-click-source-page="/" data-route-click-target-path="/guides/new-jersey-pfas-utility-records" data-route-click-cta-slot="regional_corridor_guide" data-route-click-family="regional_corridor" data-route-click-lane="new_jersey_corridor" data-route-click-region="NJ">Read New Jersey guide</a>
                    <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/compare/new-jersey-certified-pou-after-utility-context" data-route-click-track="true" data-route-click-id="home:nj-corridor:compare" data-route-click-source-page="/" data-route-click-target-path="/compare/new-jersey-certified-pou-after-utility-context" data-route-click-cta-slot="regional_corridor_compare" data-route-click-family="regional_corridor" data-route-click-lane="new_jersey_corridor" data-route-click-region="NJ">Compare New Jersey options</a>
                </div>
            </article>
            <article class="row-link grid gap-5 border-t border-base-300/70 px-6 py-6 lg:grid-cols-[minmax(0,1.25fr)_16rem_18rem] lg:items-start">
                <div class="space-y-3">
                    <div class="flex flex-wrap items-center gap-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">California corridor</span>
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Guide + compare</span>
                    </div>
                    <h3 class="text-[1.45rem] font-semibold tracking-[-0.035em] text-base-content">Read the California utility pair, then open the regional post-utility compare lane.</h3>
                    <p class="text-sm leading-7 text-base-content/68">Sacramento and East Los Angeles now give the engine both a direct detectable dossier and a treated-water non-detect dossier inside one regional corridor.</p>
                </div>
                <div class="py-1">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Route logic</div>
                    <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">Exact system first</p>
                    <p class="mt-2 text-sm leading-6 text-base-content/62">Use the guide to separate Sacramento from East Los Angeles. Use the compare lane only after that difference is clear.</p>
                </div>
                <div class="flex flex-wrap gap-3 lg:justify-end">
                    <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/california-pfas-utility-records" data-route-click-track="true" data-route-click-id="home:ca-corridor:guide" data-route-click-source-page="/" data-route-click-target-path="/guides/california-pfas-utility-records" data-route-click-cta-slot="regional_corridor_guide" data-route-click-family="regional_corridor" data-route-click-lane="california_corridor" data-route-click-region="CA">Read California guide</a>
                    <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/compare/california-certified-pou-after-utility-context" data-route-click-track="true" data-route-click-id="home:ca-corridor:compare" data-route-click-source-page="/" data-route-click-target-path="/compare/california-certified-pou-after-utility-context" data-route-click-cta-slot="regional_corridor_compare" data-route-click-family="regional_corridor" data-route-click-lane="california_corridor" data-route-click-region="CA">Compare California options</a>
                </div>
            </article>
            <article class="row-link grid gap-5 border-t border-base-300/70 px-6 py-6 lg:grid-cols-[minmax(0,1.25fr)_16rem_18rem] lg:items-start">
                <div class="space-y-3">
                    <div class="flex flex-wrap items-center gap-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Florida corridor</span>
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Guide + compare</span>
                    </div>
                    <h3 class="text-[1.45rem] font-semibold tracking-[-0.035em] text-base-content">Read the Florida utility cluster, then compare certified point-of-use only after the system posture is clear.</h3>
                    <p class="text-sm leading-7 text-base-content/68">Florida now spans notice-heavy Sunshine Water systems and quieter CCR-led dossiers, so the state page only works when the exact utility record still leads the decision.</p>
                </div>
                <div class="py-1">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Route logic</div>
                    <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">Notice posture before shortlist</p>
                    <p class="mt-2 text-sm leading-6 text-base-content/62">Use the guide to separate notice-heavy systems from regular CCR routes. Open the compare lane only after that difference is anchored.</p>
                </div>
                <div class="flex flex-wrap gap-3 lg:justify-end">
                    <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/florida-pfas-utility-records" data-route-click-track="true" data-route-click-id="home:fl-corridor:guide" data-route-click-source-page="/" data-route-click-target-path="/guides/florida-pfas-utility-records" data-route-click-cta-slot="regional_corridor_guide" data-route-click-family="regional_corridor" data-route-click-lane="florida_corridor" data-route-click-region="FL">Read Florida guide</a>
                    <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/compare/florida-certified-pou-after-utility-context" data-route-click-track="true" data-route-click-id="home:fl-corridor:compare" data-route-click-source-page="/" data-route-click-target-path="/compare/florida-certified-pou-after-utility-context" data-route-click-cta-slot="regional_corridor_compare" data-route-click-family="regional_corridor" data-route-click-lane="florida_corridor" data-route-click-region="FL">Compare Florida options</a>
                </div>
            </article>
            <article class="row-link grid gap-5 border-t border-base-300/70 px-6 py-6 lg:grid-cols-[minmax(0,1.25fr)_16rem_18rem] lg:items-start">
                <div class="space-y-3">
                    <div class="flex flex-wrap items-center gap-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Nevada corridor</span>
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Guide + compare</span>
                    </div>
                    <h3 class="text-[1.45rem] font-semibold tracking-[-0.035em] text-base-content">Read the Nevada utility cluster, then compare certified point-of-use with the exact system still in view.</h3>
                    <p class="text-sm leading-7 text-base-content/68">Nevada now mixes elevated Spring Creek records with quieter Great Basin Water CCR routes, so the state cluster should behave like exact dossiers rather than a statewide verdict.</p>
                </div>
                <div class="py-1">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Route logic</div>
                    <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">Exact system before product lane</p>
                    <p class="mt-2 text-sm leading-6 text-base-content/62">Use the guide to separate Spring Creek from Calvada and Cold Springs. Open the compare lane only after the route stays proportional and ingestion-focused.</p>
                </div>
                <div class="flex flex-wrap gap-3 lg:justify-end">
                    <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/nevada-pfas-utility-records" data-route-click-track="true" data-route-click-id="home:nv-corridor:guide" data-route-click-source-page="/" data-route-click-target-path="/guides/nevada-pfas-utility-records" data-route-click-cta-slot="regional_corridor_guide" data-route-click-family="regional_corridor" data-route-click-lane="nevada_corridor" data-route-click-region="NV">Read Nevada guide</a>
                    <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/compare/nevada-certified-pou-after-utility-context" data-route-click-track="true" data-route-click-id="home:nv-corridor:compare" data-route-click-source-page="/" data-route-click-target-path="/compare/nevada-certified-pou-after-utility-context" data-route-click-cta-slot="regional_corridor_compare" data-route-click-family="regional_corridor" data-route-click-lane="nevada_corridor" data-route-click-region="NV">Compare Nevada options</a>
                </div>
            </article>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="mb-8 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div class="space-y-3">
                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">State-led private-well lanes</span>
                <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-base-content md:text-[3rem] md:leading-[1.04]">Private-well routes are thick enough to stay state-led before any product lane opens.</h2>
                <p class="max-w-3xl text-base leading-8 text-base-content/68">These lanes keep the household inside state guidance, certified-lab routing, and result interpretation before any certified point-of-use shortlist appears.</p>
            </div>
        </div>

        <div class="surface-panel overflow-hidden">
            <article class="row-link grid gap-5 px-6 py-6 lg:grid-cols-[minmax(0,1.25fr)_15rem_18rem] lg:items-start">
                <div class="space-y-3">
                    <div class="flex flex-wrap items-center gap-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Private-well route</span>
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">Guide + compare</span>
                    </div>
                    <h3 class="text-[1.45rem] font-semibold tracking-[-0.035em] text-base-content">Move from the state route into a private-well compare only after the result is interpretable.</h3>
                    <p class="text-sm leading-7 text-base-content/68">The guide explains why state posture and lab comparability decide the next move. The compare lane stays narrower than a generic private-well filter roundup.</p>
                </div>
                <div class="py-1">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Guardrail</div>
                    <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">State context first</p>
                    <p class="mt-2 text-sm leading-6 text-base-content/62">The well result needs a state route, not a prestige purchase. Certified point-of-use only opens after the state path is clear.</p>
                </div>
                <div class="flex flex-wrap gap-3 lg:justify-end">
                    <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/private-well-pfas-result-next-steps" data-route-click-track="true" data-route-click-id="home:private-well:guide" data-route-click-source-page="/" data-route-click-target-path="/guides/private-well-pfas-result-next-steps" data-route-click-cta-slot="private_well_lane_guide" data-route-click-family="private_well_lane" data-route-click-lane="state_led_private_well" data-route-click-region="multi">Read private-well guide</a>
                    <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/compare/private-well-certified-pou-after-test" data-route-click-track="true" data-route-click-id="home:private-well:compare" data-route-click-source-page="/" data-route-click-target-path="/compare/private-well-certified-pou-after-test" data-route-click-cta-slot="private_well_lane_compare" data-route-click-family="private_well_lane" data-route-click-lane="state_led_private_well" data-route-click-region="multi">Compare private-well options</a>
                </div>
            </article>
            @if (!featuredStates.isEmpty())
                <div class="grid gap-px border-t border-base-300/70 bg-base-300/70 md:grid-cols-2 xl:grid-cols-5">
                    @for (var state : featuredStates)
                        <article class="bg-base-100/96 px-5 py-5">
                            <div class="flex items-center justify-between gap-3">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${state.stateCode()} lane</span>
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/42">Private well</span>
                            </div>
                            <h3 class="mt-4 text-lg font-semibold tracking-[-0.03em] text-base-content">${state.stateCode()} state route</h3>
                            <p class="mt-3 text-sm leading-7 text-base-content/66">${state.agencyName()}</p>
                            <div class="mt-5 flex flex-wrap gap-3">
                                <a class="btn btn-primary h-10 rounded-full border-0 px-4 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/private-well/${state.stateCode()}" data-route-click-track="true" data-route-click-id="home:state-lane:${state.stateCode()}" data-route-click-source-page="/" data-route-click-target-path="/private-well/${state.stateCode()}" data-route-click-cta-slot="state_lane_route" data-route-click-family="private_well_state_lane" data-route-click-lane="${state.stateCode()}_private_well" data-route-click-region="${state.stateCode()}">Read ${state.stateCode()} guide</a>
                                <a class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/checker?waterSource=PRIVATE_WELL&directData=NONE&benchmarkRelation=UNKNOWN&currentFilterStatus=NONE&shoppingIntent=NONE&wholeHouseConsidered=false&stateCode=${state.stateCode()}" data-route-click-track="true" data-route-click-id="home:state-lane-checker:${state.stateCode()}" data-route-click-source-page="/" data-route-click-target-path="/checker?waterSource=PRIVATE_WELL&directData=NONE&benchmarkRelation=UNKNOWN&currentFilterStatus=NONE&shoppingIntent=NONE&wholeHouseConsidered=false&stateCode=${state.stateCode()}" data-route-click-cta-slot="state_lane_checker" data-route-click-family="private_well_state_lane" data-route-click-lane="${state.stateCode()}_private_well" data-route-click-region="${state.stateCode()}">Check ${state.stateCode()} route</a>
                            </div>
                        </article>
                    @endfor
                </div>
            @endif
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="mb-8 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div class="space-y-3">
                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Current dossiers</span>
                <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-base-content md:text-[3rem] md:leading-[1.04]">Seeded public-water routes are treated like records, not location spam.</h2>
                <p class="max-w-3xl text-base leading-8 text-base-content/68">Each route keeps direct system context, benchmark-aware interpretation, and certified option logic together.</p>
            </div>
        </div>

        @if (!featuredPennsylvaniaSystems.isEmpty())
            <div class="surface-muted mb-5 px-5 py-5">
                <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                    <div class="space-y-2">
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Pennsylvania dossier cluster</span>
                        <p class="max-w-3xl text-sm leading-7 text-base-content/72">The Pennsylvania lane now spans a major metro utility, Lancaster's action-heavy record, and two additional utility dossiers so households can read comparable system evidence before any product path opens.</p>
                    </div>
                    <div class="flex flex-wrap gap-2">
                        @for (var system : featuredPennsylvaniaSystems)
                            <a class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content transition duration-150 ease-out hover:-translate-y-px hover:border-primary hover:text-primary" href="/public-water/${system.pwsid()}">${system.pwsName()}</a>
                        @endfor
                    </div>
                </div>
            </div>
        @endif

        @if (!featuredSystems.isEmpty())
            <article class="overflow-hidden rounded-[1.35rem] border border-base-300/70 bg-base-100/96 shadow-[var(--shadow-panel)]">
                <div class="grid gap-px bg-base-300/70 lg:grid-cols-[minmax(0,1fr)_18rem]">
                    <div class="bg-base-100/96 p-7 md:p-8">
                        <div class="flex flex-wrap items-center gap-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${featuredSystems.get(0).stateCode()} public water dossier</span>
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">PWSID ${featuredSystems.get(0).pwsid()}</span>
                        </div>
                        <h3 class="mt-5 max-w-3xl text-[2rem] font-semibold tracking-[-0.04em] text-base-content md:text-[2.3rem] md:leading-[1.02]">${featuredSystems.get(0).pwsName()}</h3>
                        <p class="mt-4 max-w-3xl text-base leading-8 text-base-content/68">Open the system record first, interpret benchmark context second, then move into certified point-of-use only if the route justifies it.</p>
                        <div class="mt-6 flex flex-wrap gap-3">
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/public-water/${featuredSystems.get(0).pwsid()}">Review result page</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/public-water-system/${featuredSystems.get(0).pwsid()}">Review source context</a>
                        </div>
                    </div>
                    <aside class="bg-base-200/36 p-6 md:p-7">
                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Route posture</div>
                        <p class="mt-4 text-sm leading-7 text-base-content/72">This dossier is treated as a record set, not a location list entry. The comparison lane only opens after the system context is anchored.</p>
                        <div class="mt-6 border-t border-base-300/70 pt-6">
                            <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Primary move</div>
                            <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">Open the system result, then inspect the source context.</p>
                        </div>
                    </aside>
                </div>
            </article>
        @endif

        @if (featuredSystems.size() > 1)
            <div class="surface-panel mt-5 overflow-hidden">
                @for (var system : featuredSystems.subList(1, Math.min(3, featuredSystems.size())))
                    <article class="row-link grid gap-5 px-6 py-6 lg:grid-cols-[minmax(0,1.35fr)_12rem_16rem] lg:items-start ${system != featuredSystems.get(1) ? "border-t border-base-300/70" : ""}">
                        <div class="space-y-3">
                            <div class="flex flex-wrap items-center gap-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${system.stateCode()} public water dossier</span>
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">PWSID ${system.pwsid()}</span>
                            </div>
                            <h3 class="text-[1.45rem] font-semibold tracking-[-0.035em] text-base-content">${system.pwsName()}</h3>
                            <p class="text-sm leading-7 text-base-content/68">Open the system record first, interpret benchmark context second, then move into certified point-of-use only if the route justifies it.</p>
                        </div>
                        <div class="py-1">
                            <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Route use</div>
                            <p class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">System result first</p>
                            <p class="mt-2 text-sm leading-6 text-base-content/62">This route behaves like an operating record, not a generic city page.</p>
                        </div>
                        <div class="flex flex-wrap gap-3 lg:justify-end">
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/public-water/${system.pwsid()}">Review result page</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/public-water-system/${system.pwsid()}">Review source context</a>
                        </div>
                    </article>
                @endfor
            </div>
            @if (featuredSystems.size() > 3)
                <details class="mt-4 collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <summary class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More seeded dossiers (${featuredSystems.size() - 3})</summary>
                    <div class="collapse-content">
                        <div class="overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100 pt-2">
                            @for (var system : featuredSystems.subList(3, featuredSystems.size()))
                                <article class="grid gap-4 px-5 py-5 ${system != featuredSystems.get(3) ? "border-t border-base-300/70" : ""} lg:grid-cols-[minmax(0,1fr)_14rem] lg:items-start">
                                    <div class="space-y-3">
                                        <div class="flex flex-wrap items-center gap-2">
                                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${system.stateCode()} public water dossier</span>
                                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">PWSID ${system.pwsid()}</span>
                                        </div>
                                        <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">${system.pwsName()}</h3>
                                        <p class="text-sm leading-7 text-base-content/68">Open the system record first, interpret benchmark context second, then move into certified point-of-use only if the route justifies it.</p>
                                    </div>
                                    <div class="flex flex-wrap gap-3 lg:justify-end">
                                        <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/public-water/${system.pwsid()}">Review result page</a>
                                        <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/public-water-system/${system.pwsid()}">Review source context</a>
                                    </div>
                                </article>
                            @endfor
                        </div>
                    </div>
                </details>
            @endif
        @endif
    </div>
</section>
`
)
