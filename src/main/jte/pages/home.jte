@import com.example.pfas.checker.ActionCheckerRecommendation
@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.water.PublicWaterSystem
@import com.example.pfas.web.GuidePage
@import static com.example.pfas.web.PresentationText.benchmarkRelationLabel
@import static com.example.pfas.web.PresentationText.currentFilterStatusLabel
@import static com.example.pfas.web.PresentationText.directDataLabel
@import static com.example.pfas.web.PresentationText.waterSourceLabel
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param String siteLastVerifiedDate
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
<section class="pt-12 md:pt-16">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_24rem] xl:items-start">
            <div class="space-y-8">
                <div class="space-y-5">
                    <span class="inline-flex rounded-full border border-shell-border bg-ivory-panel px-4 py-2 text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Quiet infrastructure for water decisions</span>
                    <h1 class="max-w-4xl text-4xl font-semibold tracking-[-0.05em] text-slate-deep sm:text-5xl lg:text-[3.85rem] lg:leading-[1.02]">
                        Read the record.
                        <span class="font-serif font-medium text-mineral-blue">Then decide what to do next.</span>
                    </h1>
                    <p class="max-w-3xl text-lg leading-8 text-slate-body">
                        This is not a panic funnel and not a decorative SaaS shell. It is an action engine for households
                        deciding whether to check a utility record, order a private-well test, or compare certified
                        point-of-use options without overspending.
                    </p>
                </div>

                <div class="flex flex-wrap gap-3">
                    <a class="inline-flex items-center justify-center rounded-full bg-teal-deep px-6 py-3 text-sm font-semibold text-white transition duration-150 ease-out hover:-translate-y-px hover:bg-slate-deep" href="/checker">Open action checker</a>
                    <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-6 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="/methodology">Read methodology</a>
                </div>

                <div class="grid gap-4 md:grid-cols-3">
                    <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Current status</span>
                        <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">Interpretation first</h2>
                        <p class="mt-2 text-sm leading-6 text-slate-muted">Direct utility records and well tests open before any shopping path.</p>
                    </article>
                    <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Trust layer</span>
                        <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">Caveats in view</h2>
                        <p class="mt-2 text-sm leading-6 text-slate-muted">Limits are kept in the reading path instead of buried under the fold.</p>
                    </article>
                    <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Commercial posture</span>
                        <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">Constrained</h2>
                        <p class="mt-2 text-sm leading-6 text-slate-muted">Certified point-of-use appears before whole-house escalation and only with claim-level evidence.</p>
                    </article>
                </div>
            </div>

            <aside class="rounded-[22px] border border-shell-border bg-ivory-panel px-6 py-6 shadow-quiet">
                <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Why this feels different</span>
                <div class="mt-4 space-y-4">
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Evidence stack</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">EPA, state guidance, utility documents, and captured listing records.</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Reading style</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">Calm, benchmark-aware, and explicit about what the data does not settle.</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Decision bias</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">Test or verify first. Compare only after the household context is anchored.</p>
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
    <div class="shell">
        <div class="mb-8 flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
            <div class="space-y-3">
                <span class="inline-flex text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Action checker preview</span>
                <h2 class="max-w-3xl text-3xl font-semibold tracking-[-0.04em] text-slate-deep md:text-4xl">A quiet intake surface that turns uncertainty into a next action.</h2>
                <p class="max-w-3xl text-base leading-7 text-slate-muted">The homepage should not pretend to finish the case. It should show the intake rhythm, the evidence posture, and the next action shape.</p>
            </div>
            <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-5 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="/checker">Open full checker</a>
        </div>

        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_24rem] xl:items-start">
            <div class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                <div class="flex flex-col gap-3 border-b border-shell-border pb-6 md:flex-row md:items-end md:justify-between">
                    <div class="space-y-2">
                        <span class="text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Default routing stance</span>
                        <h3 class="text-2xl font-semibold tracking-[-0.03em] text-slate-deep">Evidence comes before purchase pressure.</h3>
                        <p class="max-w-2xl text-sm leading-6 text-slate-muted">This preview uses the engine's default public-water posture and shows the exact route it opens before any commercial surface appears.</p>
                    </div>
                    <div class="rounded-[16px] border border-teal-deep/14 bg-teal-tint/70 px-4 py-3 text-sm leading-6 text-slate-body">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-teal-deep">Current route</span>
                        <span class="block pt-1 font-semibold tracking-[-0.02em] text-slate-deep">${checkerRecommendation.routeCode()}</span>
                    </div>
                </div>

                <div class="mt-6 grid gap-4 md:grid-cols-3">
                    <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Water source</span>
                        <h4 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${waterSourceLabel(checkerSelection.waterSource())}</h4>
                        <p class="mt-2 text-sm leading-6 text-slate-muted">The engine assumes public-water users should start with a utility record, not geography or fear.</p>
                    </article>
                    <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Direct data</span>
                        <h4 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${directDataLabel(checkerSelection.directData())}</h4>
                        <p class="mt-2 text-sm leading-6 text-slate-muted">Missing direct evidence closes shopping logic and opens record collection instead.</p>
                    </article>
                    <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Current filter</span>
                        <h4 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${currentFilterStatusLabel(checkerSelection.currentFilterStatus())}</h4>
                        <p class="mt-2 text-sm leading-6 text-slate-muted">Hardware status never outranks the need for a direct document or well test.</p>
                    </article>
                </div>

                <div class="mt-6 rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                    <div class="flex flex-col gap-3 md:flex-row md:items-start md:justify-between">
                        <div class="space-y-2">
                            <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Benchmark stance</span>
                            <p class="text-lg font-semibold tracking-[-0.02em] text-slate-deep">${benchmarkRelationLabel(checkerSelection.benchmarkRelation())}</p>
                            <p class="max-w-2xl text-sm leading-6 text-slate-muted">Without direct evidence, the benchmark relation stays intentionally unresolved. The checker refuses to invent confidence.</p>
                        </div>
                        <div class="flex flex-wrap gap-3">
                            <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-4 py-2.5 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="/checker?waterSource=PUBLIC_WATER&directData=UTILITY_DOCUMENT&pwsid=${checkerSelection.pwsid()}">Use a utility document</a>
                            <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-4 py-2.5 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="/checker?waterSource=PRIVATE_WELL&stateCode=MI">Switch to private well</a>
                        </div>
                    </div>
                </div>
            </div>

            @template.fragments.checkerSummary(
                selection = checkerSelection,
                recommendation = checkerRecommendation
            )
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="mb-8 space-y-3">
            <span class="inline-flex text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Entry pages</span>
            <h2 class="text-3xl font-semibold tracking-[-0.04em] text-slate-deep md:text-4xl">Search-intent pages built to answer the next decision, not just define PFAS.</h2>
            <p class="max-w-3xl text-base leading-7 text-slate-muted">These are the entry points meant to absorb real search intent and move the reader into a clearer action or comparison path.</p>
        </div>
        <div class="grid gap-4 lg:grid-cols-2 xl:grid-cols-3">
            @for (var guide : guides.subList(0, Math.min(6, guides.size())))
                <article class="rounded-[20px] border border-shell-border bg-ivory-panel p-6 shadow-quiet transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong">
                    <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">${guide.eyebrow()}</span>
                    <h3 class="mt-4 text-2xl font-semibold tracking-[-0.03em] text-slate-deep">${guide.title()}</h3>
                    <p class="mt-3 text-sm leading-7 text-slate-muted">${guide.lede()}</p>
                    <div class="mt-5 flex flex-wrap gap-2">
                        <span class="rounded-full border border-shell-border bg-ivory px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-slate-soft">Last verified ${guide.lastVerifiedDate()}</span>
                        <span class="rounded-full border border-shell-border bg-ivory px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-slate-soft">Decision intent</span>
                    </div>
                    <div class="mt-6 flex flex-wrap gap-3">
                        <a class="inline-flex items-center justify-center rounded-full bg-teal-deep px-4 py-2.5 text-sm font-semibold text-white transition duration-150 ease-out hover:-translate-y-px hover:bg-slate-deep" href="/guides/${guide.slug()}">Open guide</a>
                        <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory px-4 py-2.5 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="${guide.primaryHref()}">${guide.primaryLabel()}</a>
                    </div>
                </article>
            @endfor
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="mb-8 space-y-3">
            <span class="inline-flex text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Current dossiers</span>
            <h2 class="text-3xl font-semibold tracking-[-0.04em] text-slate-deep md:text-4xl">Seeded public-water routes are treated like records, not location spam.</h2>
            <p class="max-w-3xl text-base leading-7 text-slate-muted">Each route keeps the direct system context, benchmark-aware interpretation, and certified option layer together.</p>
        </div>
        <div class="grid gap-4 lg:grid-cols-2">
            @for (var system : systems.subList(0, Math.min(4, systems.size())))
                <article class="rounded-[20px] border border-shell-border bg-ivory-panel p-6 shadow-quiet transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong">
                    <div class="flex flex-wrap items-center justify-between gap-3">
                        <span class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">${system.stateCode()} public water dossier</span>
                        <span class="rounded-full border border-shell-border bg-ivory px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-slate-soft">PWSID ${system.pwsid()}</span>
                    </div>
                    <h3 class="mt-4 text-2xl font-semibold tracking-[-0.03em] text-slate-deep">${system.pwsName()}</h3>
                    <p class="mt-3 text-sm leading-7 text-slate-muted">Open the system record first, interpret benchmark context second, then move into certified point-of-use only if the route justifies it.</p>
                    <div class="mt-6 flex flex-wrap gap-3">
                        <a class="inline-flex items-center justify-center rounded-full bg-teal-deep px-4 py-2.5 text-sm font-semibold text-white transition duration-150 ease-out hover:-translate-y-px hover:bg-slate-deep" href="/public-water/${system.pwsid()}">Open result page</a>
                        <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory px-4 py-2.5 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="/public-water-system/${system.pwsid()}">Open source context</a>
                    </div>
                </article>
            @endfor
        </div>
    </div>
</section>
`
)
