@import com.example.pfas.checker.ActionCheckerRecommendation
@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.state.StateGuidance
@import com.example.pfas.water.PublicWaterSystem
@import com.example.pfas.web.GuidePage
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param String siteLastVerifiedDate
@param java.util.List<StateGuidance> states
@param java.util.List<PublicWaterSystem> systems
@param java.util.List<GuidePage> guides
@param ActionCheckerSelection checkerSelection
@param ActionCheckerRecommendation checkerRecommendation

@template.layout.base(
    pageTitle = "PFAS Decision Engine",
    pageDescription = "Official-data-first PFAS action engine for public water and private well decisions.",
    pageCanonicalUrl = siteBaseUrl + "/",
    pageIndexable = true,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_24rem] xl:items-start">
            <div class="space-y-8">
                <div class="space-y-5">
                    <span class="badge badge-outline border-base-300 bg-base-100 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-base-content/58">Quiet infrastructure for water decisions</span>
                    <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-base-content sm:text-5xl lg:text-[4.2rem] lg:leading-[0.98]">
                        Read the record.
                        <span class="font-serif font-medium text-secondary">Then decide what to do next.</span>
                    </h1>
                    <p class="max-w-3xl text-lg leading-8 text-base-content/74">
                        This is not a panic funnel and not a decorative SaaS shell. It is a decision engine for households
                        deciding whether to inspect a utility dossier, order a private-well test, or compare certified
                        point-of-use options without overspending.
                    </p>
                </div>

                <div class="join join-vertical gap-3 sm:join-horizontal">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/checker">Open action checker</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/methodology">Read methodology</a>
                </div>

                <div class="grid gap-px overflow-hidden rounded-[1.25rem] border border-base-300/70 bg-base-300/70 shadow-[var(--shadow-soft)] lg:grid-cols-3">
                    <article class="bg-base-100/96 px-6 py-5">
                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Interpretation bias</div>
                        <div class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Direct evidence first</div>
                        <div class="mt-3 text-sm leading-6 text-base-content/58">Utility records and well tests open before any shopping path.</div>
                    </article>
                    <article class="bg-base-100/96 px-6 py-5">
                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Trust layer</div>
                        <div class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Caveats stay visible</div>
                        <div class="mt-3 text-sm leading-6 text-base-content/58">Limits remain in the main reading path instead of disappearing below the fold.</div>
                    </article>
                    <article class="bg-base-100/96 px-6 py-5">
                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Commercial posture</div>
                        <div class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Point-of-use before escalation</div>
                        <div class="mt-3 text-sm leading-6 text-base-content/58">Certified point-of-use opens before whole-house and only with claim-level support.</div>
                    </article>
                </div>
            </div>

            <aside class="card border border-neutral/12 bg-neutral text-neutral-content shadow-[var(--shadow-panel)]">
                <div class="card-body gap-5">
                    <div class="space-y-2">
                        <span class="badge border-0 bg-white/10 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Operating stance</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-white">Built like an editorial control room, not a promo page.</h2>
                    </div>
                    <div class="overflow-hidden rounded-[1rem] border border-white/10 bg-white/4">
                        <article class="px-4 py-4 text-sm leading-6 text-white/78">
                            <strong class="font-semibold text-white">Evidence stack</strong><br>EPA, state guidance, utility documents, and captured listing records.
                        </article>
                        <article class="border-t border-white/10 px-4 py-4 text-sm leading-6 text-white/78">
                            <strong class="font-semibold text-white">Reading rhythm</strong><br>Calm, benchmark-aware, and explicit about what the data does not settle.
                        </article>
                        <article class="border-t border-white/10 px-4 py-4 text-sm leading-6 text-white/78">
                            <strong class="font-semibold text-white">Decision posture</strong><br>Verify first. Compare only after the household context is anchored.
                        </article>
                    </div>
                </div>
            </aside>
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
                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Action intake</span>
                <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-base-content md:text-[3rem] md:leading-[1.02]">
                    Start with the case details.
                    <span class="font-serif font-medium text-secondary">Let the engine expose the next responsible move.</span>
                </h2>
                <p class="max-w-3xl text-base leading-8 text-base-content/68">This is the same server-backed intake surface used by the full checker. It keeps evidence hierarchy, caveats, and next action visible in one read.</p>
            </div>
            <div class="rounded-[1rem] border border-neutral/12 bg-neutral px-5 py-4 text-neutral-content shadow-[var(--shadow-soft)]">
                <span class="text-sm leading-7 text-white/76"><strong class="font-semibold text-white">Homepage discipline</strong> No fear copy, no affiliate-first detour, and no fake certainty.</span>
            </div>
        </div>
    </div>

    @template.fragments.checkerPanel(
        states = states,
        systems = systems,
        selection = checkerSelection,
        recommendation = checkerRecommendation
    )
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="mb-8 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div class="space-y-3">
                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Entry pages</span>
                <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-base-content md:text-[3rem] md:leading-[1.04]">Search-intent pages built to answer the next decision, not just define PFAS.</h2>
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
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/${guides.get(0).slug()}">Open guide</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guides.get(0).primaryHref()}">${guides.get(0).primaryLabel()}</a>
                        </div>
                    </div>
                    <aside class="bg-base-200/36 p-6 md:p-7">
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
            <div class="mt-5 overflow-hidden rounded-[1.2rem] border border-base-300/70 bg-base-100/94 shadow-[var(--shadow-soft)]">
                @for (var guide : guides.subList(1, Math.min(3, guides.size())))
                    <article class="grid gap-5 px-6 py-6 transition duration-150 ease-out hover:bg-base-200/18 lg:grid-cols-[minmax(0,1.35fr)_12rem_16rem] lg:items-start ${guide != guides.get(1) ? "border-t border-base-300/70" : ""}">
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
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/${guide.slug()}">Open guide</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guide.primaryHref()}">${guide.primaryLabel()}</a>
                        </div>
                    </article>
                @endfor
            </div>
            @if (guides.size() > 3)
                <div class="mt-4 collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <input type="checkbox">
                    <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More decision-intent pages (${guides.size() - 3})</div>
                    <div class="collapse-content">
                        <div class="overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100 pt-2">
                            @for (var guide : guides.subList(3, Math.min(6, guides.size())))
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
                                        <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/guides/${guide.slug()}">Open guide</a>
                                        <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guide.primaryHref()}">${guide.primaryLabel()}</a>
                                    </div>
                                </article>
                            @endfor
                        </div>
                    </div>
                </div>
            @endif
        @endif
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

        @if (!systems.isEmpty())
            <article class="overflow-hidden rounded-[1.35rem] border border-base-300/70 bg-base-100/96 shadow-[var(--shadow-panel)]">
                <div class="grid gap-px bg-base-300/70 lg:grid-cols-[minmax(0,1fr)_18rem]">
                    <div class="bg-base-100/96 p-7 md:p-8">
                        <div class="flex flex-wrap items-center gap-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${systems.get(0).stateCode()} public water dossier</span>
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">PWSID ${systems.get(0).pwsid()}</span>
                        </div>
                        <h3 class="mt-5 max-w-3xl text-[2rem] font-semibold tracking-[-0.04em] text-base-content md:text-[2.3rem] md:leading-[1.02]">${systems.get(0).pwsName()}</h3>
                        <p class="mt-4 max-w-3xl text-base leading-8 text-base-content/68">Open the system record first, interpret benchmark context second, then move into certified point-of-use only if the route justifies it.</p>
                        <div class="mt-6 flex flex-wrap gap-3">
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/public-water/${systems.get(0).pwsid()}">Open result page</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/public-water-system/${systems.get(0).pwsid()}">Open source context</a>
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

        @if (systems.size() > 1)
            <div class="mt-5 overflow-hidden rounded-[1.2rem] border border-base-300/70 bg-base-100/94 shadow-[var(--shadow-soft)]">
                @for (var system : systems.subList(1, Math.min(3, systems.size())))
                    <article class="grid gap-5 px-6 py-6 transition duration-150 ease-out hover:bg-base-200/18 lg:grid-cols-[minmax(0,1.35fr)_12rem_16rem] lg:items-start ${system != systems.get(1) ? "border-t border-base-300/70" : ""}">
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
                            <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/public-water/${system.pwsid()}">Open result page</a>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/public-water-system/${system.pwsid()}">Open source context</a>
                        </div>
                    </article>
                @endfor
            </div>
            @if (systems.size() > 3)
                <div class="mt-4 collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <input type="checkbox">
                    <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More seeded dossiers (${systems.size() - 3})</div>
                    <div class="collapse-content">
                        <div class="overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100 pt-2">
                            @for (var system : systems.subList(3, Math.min(4, systems.size())))
                                <article class="grid gap-4 px-5 py-5 ${system != systems.get(3) ? "border-t border-base-300/70" : ""} lg:grid-cols-[minmax(0,1fr)_14rem] lg:items-start">
                                    <div class="space-y-3">
                                        <div class="flex flex-wrap items-center gap-2">
                                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">${system.stateCode()} public water dossier</span>
                                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/56">PWSID ${system.pwsid()}</span>
                                        </div>
                                        <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">${system.pwsName()}</h3>
                                        <p class="text-sm leading-7 text-base-content/68">Open the system record first, interpret benchmark context second, then move into certified point-of-use only if the route justifies it.</p>
                                    </div>
                                    <div class="flex flex-wrap gap-3 lg:justify-end">
                                        <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/public-water/${system.pwsid()}">Open result page</a>
                                        <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/public-water-system/${system.pwsid()}">Open source context</a>
                                    </div>
                                </article>
                            @endfor
                        </div>
                    </div>
                </div>
            @endif
        @endif
    </div>
</section>
`
)
