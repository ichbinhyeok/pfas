@import com.example.pfas.result.WaterDecisionResult
@import com.example.pfas.water.PublicWaterSystem
@import com.example.pfas.decision.PublicWaterDecisionContext
@import com.example.pfas.decision.BenchmarkComparisonStatus
@import static com.example.pfas.web.PresentationText.benchmarkRelationLabel
@import static com.example.pfas.web.PresentationText.comparisonStatusLabel
@import static com.example.pfas.web.PresentationText.confidenceLabel
@import static com.example.pfas.web.PresentationText.sourceWaterTypeLabel
@import static com.example.pfas.web.PresentationText.systemTypeLabel
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param PublicWaterSystem system
@param PublicWaterDecisionContext decision
@param WaterDecisionResult result
@param boolean pageIndexable

@template.layout.base(
    pageTitle = system.pwsName() + " PFAS Result",
    pageDescription = "Rendered PFAS decision result for " + system.pwsName() + " using normalized utility and benchmark data.",
    pageCanonicalUrl = siteBaseUrl + "/public-water/" + system.pwsid(),
    pageIndexable = pageIndexable,
    content = @`
<section class="pt-12 md:pt-16">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.12fr)_23rem] xl:items-start">
            <div class="space-y-5">
                <span class="inline-flex rounded-full border border-shell-border bg-ivory-panel px-4 py-2 text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">${system.stateCode()} public-water dossier</span>
                <h1 class="max-w-4xl text-4xl font-semibold tracking-[-0.05em] text-slate-deep sm:text-5xl lg:text-[3.45rem] lg:leading-[1.04]">
                    ${system.pwsName()}
                    <span class="font-serif font-medium text-mineral-blue">kept in direct view.</span>
                </h1>
                <p class="max-w-3xl text-lg leading-8 text-slate-body">
                    Utility observations, registry-backed benchmarks, and certified option records are rendered together as one calm interpretation surface.
                    The route stays explicit, the caveats stay visible, and the product layer stays downstream from the evidence.
                </p>
                <div class="flex flex-wrap gap-3">
                    <a class="inline-flex items-center justify-center rounded-full bg-teal-deep px-6 py-3 text-sm font-semibold text-white transition duration-150 ease-out hover:-translate-y-px hover:bg-slate-deep" href="${system.ccrUrl()}">Open utility report</a>
                    <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-6 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="#public-water-product-lane">Review comparison lane</a>
                    <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory-panel px-6 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="/internal/results/public-water/${system.pwsid()}">Open result JSON</a>
                </div>
            </div>

            <aside class="rounded-[22px] border border-shell-border bg-ivory-panel px-6 py-6 shadow-quiet">
                <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Current docket</span>
                <div class="mt-4 space-y-4">
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">System record</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">${system.pwsid()} / ${systemTypeLabel(system.systemType())}</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Benchmark posture</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">${benchmarkRelationLabel(result.meta().benchmarkRelation())}</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Decision confidence</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">${confidenceLabel(result.nextAction().confidence())}</p>
                    </div>
                </div>
            </aside>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        @template.fragments.publicationStrip(
            lastVerified = system.lastVerifiedDate(),
            scopeLabel = "Public-water interpretation",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Utility record</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${sourceWaterTypeLabel(system.sourceWaterType())}</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">${systemTypeLabel(system.systemType())} / PWSID ${system.pwsid()}</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Rule anchor</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${result.meta().decisionRuleId()}</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Narrative copy stays subordinate to the decision rule and benchmark relation.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Source set</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">${result.sources().size()} records</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Utility, regulatory, and claim-level listing sources render together.</p>
            </article>
            <article class="rounded-[18px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
                <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Escalation class</span>
                <h2 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-slate-deep">Point-of-use first</h2>
                <p class="mt-2 text-sm leading-6 text-slate-muted">Whole-house remains a separate justification, not the default answer.</p>
            </article>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.12fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                    <span class="inline-flex rounded-full border border-teal-deep/14 bg-teal-tint/70 px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-teal-deep">${result.nextAction().code()}</span>
                    <div class="mt-5 space-y-3">
                        <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Next action</p>
                        <h2 class="max-w-3xl text-3xl font-semibold tracking-[-0.04em] text-slate-deep md:text-[2.3rem]">${result.nextAction().title()}</h2>
                        <p class="max-w-3xl text-base leading-8 text-slate-body">${result.nextAction().summary()}</p>
                    </div>
                    <div class="mt-6 flex flex-wrap gap-2">
                        <span class="rounded-full border border-shell-border bg-ivory px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-slate-soft">Confidence ${confidenceLabel(result.nextAction().confidence())}</span>
                        <span class="rounded-full border border-shell-border bg-ivory px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-slate-soft">Benchmark ${benchmarkRelationLabel(result.meta().benchmarkRelation())}</span>
                        <span class="rounded-full border border-shell-border bg-ivory px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-slate-soft">Rule ${result.meta().decisionRuleId()}</span>
                    </div>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                    <div class="flex flex-col gap-3 border-b border-shell-border pb-6 md:flex-row md:items-end md:justify-between">
                        <div class="space-y-2">
                            <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Decision-to-product lane</p>
                            <h2 class="text-3xl font-semibold tracking-[-0.04em] text-slate-deep">The route stays calm even when the numbers do not.</h2>
                        </div>
                    </div>
                    <div class="mt-6 grid gap-4 md:grid-cols-3">
                        <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">First move</span>
                            <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${result.nextAction().title()}</h3>
                            <p class="mt-2 text-sm leading-6 text-slate-muted">${result.nextAction().summary()}</p>
                        </article>
                        <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Commercial path</span>
                            <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">Certified point-of-use first</h3>
                            <p class="mt-2 text-sm leading-6 text-slate-muted">Open official product records only after the utility context, benchmark relation, and maintenance burden are visible.</p>
                        </article>
                        <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">What stays guarded</span>
                            <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">Whole-house escalation</h3>
                            <p class="mt-2 text-sm leading-6 text-slate-muted">This path does not let whole-house become the default answer to a direct dossier.</p>
                        </article>
                    </div>
                </section>

                <section class="grid gap-4 md:grid-cols-2">
                    <article class="rounded-[20px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                        <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Initial cost</p>
                        <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-slate-deep">$${result.initialCost().rangeLowUsd()} - $${result.initialCost().rangeHighUsd()}</h2>
                        <p class="mt-2 text-sm leading-6 text-slate-muted">${confidenceLabel(result.initialCost().confidence())} confidence / normalized vendor pricing</p>
                    </article>
                    <article class="rounded-[20px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                        <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Annual maintenance</p>
                        <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-slate-deep">$${result.annualCostMaintenance().rangeLowUsd()} - $${result.annualCostMaintenance().rangeHighUsd()}</h2>
                        <p class="mt-2 text-sm leading-6 text-slate-muted">${confidenceLabel(result.annualCostMaintenance().maintenanceBurden())} maintenance burden</p>
                    </article>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                    <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Interpretation brief</p>
                    <div class="mt-5 grid gap-4 md:grid-cols-3">
                        <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">01</span>
                            <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">Read the direct record first</h3>
                            <p class="mt-2 text-sm leading-6 text-slate-muted">${system.pwsName()} is handled as a direct utility dossier, not a geography-based guess.</p>
                        </article>
                        <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">02</span>
                            <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">Normalize the benchmark relation</h3>
                            <p class="mt-2 text-sm leading-6 text-slate-muted">The route code and benchmark relation stay explicit so narrative copy cannot drift away from the decision rule.</p>
                        </article>
                        <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">03</span>
                            <h3 class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">Constrain the product layer</h3>
                            <p class="mt-2 text-sm leading-6 text-slate-muted">Certified point-of-use remains the default product class until a separate escalation case is justified.</p>
                        </article>
                    </div>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Why this</p>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for (var item : result.whyThis())
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
                        @for (var item : result.whatThisDoesNotTellYou())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-[rgba(15,118,110,0.6)]"></span>
                                <span>${item}</span>
                            </li>
                        @endfor
                    </ul>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8">
                    <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Best-fit options</p>
                    <div class="mt-5 grid gap-4 md:grid-cols-2">
                        @for (var option : result.bestFitOptions())
                            <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                                <div class="flex items-start justify-between gap-3">
                                    <div class="space-y-2">
                                        <h3 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">${option.label()}</h3>
                                        <p class="text-sm leading-6 text-slate-muted">${option.fitReason()}</p>
                                    </div>
                                    <span class="rounded-full border border-shell-border bg-ivory-panel px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-slate-soft">${option.costProfile()} cost</span>
                                </div>
                                <p class="mt-4 text-sm leading-6 text-slate-body">${option.notForEveryone()}</p>
                            </article>
                        @endfor
                    </div>
                </section>

                @template.fragments.productLane(
                    sectionId = "public-water-product-lane",
                    eyebrow = "Certified comparison lane",
                    title = "Official product records for this utility route",
                    summary = "These are not generic best-seller cards. They are the current certified point-of-use examples the engine can defend for this utility interpretation path.",
                    sourcePage = "/public-water/" + system.pwsid(),
                    routeType = "public_water",
                    ctaSlot = "public_water_product_lane",
                    products = decision.certifiedPouOptions().subList(0, Math.min(decision.certifiedPouOptions().size(), 8))
                )

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Primary source ledger</p>
                    <div class="mt-5 space-y-3">
                        @for (var source : result.sources())
                            <a class="block rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong" href="${source.url()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-slate-deep">${source.title()}</div>
                                <div class="mt-2 break-all text-sm leading-6 text-slate-muted">${source.url()}</div>
                            </a>
                        @endfor
                    </div>
                </section>
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Assessment ledger</h2>
                    <div class="mt-5 space-y-4">
                        @for (var assessment : decision.assessments())
                            <article class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                                <div class="flex flex-wrap items-start justify-between gap-3">
                                    <div>
                                        <div class="text-lg font-semibold tracking-[-0.02em] text-slate-deep">${assessment.contaminantLabel()}</div>
                                        <div class="mt-2 text-sm leading-6 text-slate-muted">${assessment.sampleContext()} / benchmark ${assessment.benchmarkValue()} ${assessment.benchmarkUnit()}</div>
                                    </div>
                                    @if (assessment.comparisonStatus() == BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK)
                                        <span class="rounded-full border border-[rgba(180,83,9,0.16)] bg-[rgba(180,83,9,0.08)] px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-[rgb(146,64,14)]">Above selected benchmark</span>
                                    @endif
                                    @if (assessment.comparisonStatus() == BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK)
                                        <span class="rounded-full border border-teal-deep/12 bg-teal-tint/70 px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-teal-deep">Present below benchmark</span>
                                    @endif
                                    @if (assessment.comparisonStatus() != BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK && assessment.comparisonStatus() != BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK)
                                        <span class="rounded-full border border-shell-border bg-ivory-panel px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-slate-soft">${comparisonStatusLabel(assessment.comparisonStatus())}</span>
                                    @endif
                                </div>
                                <div class="mt-4 text-2xl font-semibold tracking-[-0.03em] text-slate-deep">${assessment.value()} ${assessment.unit()}</div>
                                <div class="mt-2 text-sm leading-6 text-slate-body">${assessment.benchmarkLabel()} / ${assessment.benchmarkReferenceStatus()}</div>
                            </article>
                        @endfor
                    </div>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Certification checklist</h2>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for (var item : result.certificationChecklist())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                                <span>${item.label()} / ${item.detail()}</span>
                            </li>
                        @endfor
                    </ul>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">Operating boundary</h2>
                    <p class="mt-4 text-sm leading-7 text-slate-body">This output is an interpretation layer over direct utility evidence. It is not a household safety grade, not a medical statement, and not a whole-house-first sales recommendation.</p>
                </section>

                <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
                    <h2 class="text-xl font-semibold tracking-[-0.03em] text-slate-deep">When to escalate</h2>
                    <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-body">
                        @for (var item : result.whenToEscalate())
                            <li class="flex gap-3">
                                <span class="mt-2 h-1.5 w-1.5 rounded-full bg-[rgba(15,118,110,0.6)]"></span>
                                <span>${item}</span>
                            </li>
                        @endfor
                    </ul>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
