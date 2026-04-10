@import com.example.pfas.result.WaterDecisionResult
@import com.example.pfas.water.PublicWaterSystem
@import com.example.pfas.decision.PublicWaterDecisionContext
@import com.example.pfas.decision.BenchmarkComparisonStatus
@import com.example.pfas.commercial.CommercialSurfaceState
@import com.example.pfas.web.GuidePage
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
@param java.util.List<GuidePage> brandGuides
@param CommercialSurfaceState commercialState
@param boolean pageIndexable

@template.layout.base(
    pageTitle = system.pwsName() + " PFAS Result",
    pageDescription = "Rendered PFAS decision result for " + system.pwsName() + " using normalized utility and benchmark data.",
    pageCanonicalUrl = siteBaseUrl + "/public-water/" + system.pwsid(),
    pageIndexable = pageIndexable,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
                <div class="space-y-6 bg-white/[0.03] p-7 md:p-9">
                    <div class="space-y-4">
                        <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">${system.stateCode()} public-water dossier</span>
                        <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                            ${system.pwsName()}
                            <span class="font-serif font-medium text-white/72">with the benchmark posture still in view.</span>
                        </h1>
                        <p class="max-w-3xl text-lg leading-8 text-white/72">
                            Utility observations, registry-backed benchmarks, and certified option records are rendered together as one
                            calm interpretation surface. The route stays explicit, the caveats stay visible, and the product layer
                            stays downstream from the evidence.
                        </p>
                    </div>

                    <div class="join join-vertical gap-3 sm:join-horizontal sm:flex-wrap">
                        <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold hover:bg-primary/92" href="${system.ccrUrl()}">Read utility report</a>
                        @if(commercialState.shoppingUnlocked())
                            <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="#public-water-product-lane">Review comparison lane</a>
                        @else
                            <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="/guides/choose-certified-pfas-filter-after-evidence">Read compare guardrails</a>
                        @endif
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="/public-water-system/${system.pwsid()}">Review source context</a>
                    </div>
                </div>

                <aside class="bg-white/[0.02] p-7 md:p-8">
                    <div class="space-y-2">
                        <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Current docket</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-white">The route is utility-first and still bounded by the benchmark relation.</h2>
                    </div>
                    <div class="terminal-pane mt-4 overflow-hidden">
                        <div class="terminal-stack">
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">System record</strong><br>${system.pwsid()} / ${systemTypeLabel(system.systemType())}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Benchmark posture</strong><br>${benchmarkRelationLabel(result.meta().benchmarkRelation())}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Decision confidence</strong><br>${confidenceLabel(result.nextAction().confidence())}</article>
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
            lastVerified = system.lastVerifiedDate(),
            scopeLabel = "Public-water interpretation",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="ledger-grid shadow-[var(--shadow-soft)] md:grid-cols-2 xl:grid-cols-4">
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Utility record</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${sourceWaterTypeLabel(system.sourceWaterType())}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">${systemTypeLabel(system.systemType())} / PWSID ${system.pwsid()}</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Rule anchor</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${result.meta().decisionRuleId()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Narrative copy stays subordinate to the decision rule and benchmark relation.</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Source set</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${result.sources().size()} records</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Utility, regulatory, and claim-level listing sources render together.</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Escalation class</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">Point-of-use first</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Whole-house remains a separate justification, not the default answer.</div>
            </article>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell space-y-5">
        @template.fragments.commercialState(
            eyebrow = "Commercial state",
            state = commercialState
        )
        @template.fragments.routeActions(
            routeId = "public-water:" + system.pwsid(),
            routeTitle = system.pwsName() + " PFAS route",
            routeSummary = commercialState.summary(),
            routeUrl = "/public-water/" + system.pwsid()
        )

        @if(!brandGuides.isEmpty())
            <section class="surface-panel px-6 py-5">
                <div class="space-y-2">
                    <span class="section-label">Guide-defined route</span>
                    <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">This dossier can win search demand, but the guide layer should define the brand.</h2>
                    <p class="text-sm leading-7 text-base-content/68">Use these guides to interpret what this result means, what kind of follow-up is justified, and when the product layer should stay narrow. The dossier is downstream from the guide layer, not the other way around.</p>
                </div>
                <div class="mt-5 grid gap-4 lg:grid-cols-2 xl:grid-cols-3">
                    @for(var guide : brandGuides)
                        <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="/guides/${guide.slug()}">
                            <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${guide.eyebrow()}</div>
                            <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${guide.title()}</div>
                            <div class="mt-2 text-sm leading-6 text-base-content/68">${guide.nextActionSummary()}</div>
                        </a>
                    @endfor
                </div>
            </section>
        @endif
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="terminal-panel overflow-hidden">
                    <div class="grid gap-5 p-6 text-neutral-content md:p-7">
                        <div class="flex flex-col items-start gap-2 sm:flex-row sm:flex-wrap sm:items-center">
                            <span class="badge max-w-full border-0 bg-white px-3 py-2 text-left leading-5 text-neutral whitespace-normal break-all">${result.nextAction().code()}</span>
                            <span class="badge max-w-full border-0 bg-white/10 px-3 py-2 text-left leading-5 text-white/80 whitespace-normal break-words">Confidence ${confidenceLabel(result.nextAction().confidence())}</span>
                            <span class="badge max-w-full border-0 bg-white/10 px-3 py-2 text-left leading-5 text-white/80 whitespace-normal break-words">Benchmark ${benchmarkRelationLabel(result.meta().benchmarkRelation())}</span>
                            <span class="badge max-w-full border-0 bg-white/10 px-3 py-2 text-left leading-5 text-white/80 whitespace-normal break-all">Rule ${result.meta().decisionRuleId()}</span>
                        </div>
                        <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-white">${result.nextAction().title()}</h2>
                        <p class="max-w-3xl text-sm leading-7 text-white/70">${result.nextAction().summary()}</p>
                        <div class="terminal-grid md:grid-cols-2">
                            <article class="px-5 py-5">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/54">Decision posture</div>
                                <p class="mt-3 text-sm leading-7 text-white/72">The route stays utility-first. Product comparison remains downstream from the benchmark relation and maintenance burden.</p>
                            </article>
                            <article class="px-5 py-5">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/54">What remains guarded</div>
                                <p class="mt-3 text-sm leading-7 text-white/72">Whole-house treatment is still a separate justification track, not the automatic answer to a public-water dossier.</p>
                            </article>
                        </div>
                    </div>
                </section>

                <div class="ledger-grid md:grid-cols-2">
                    <section class="px-4 py-4 md:px-6 md:py-5">
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Initial cost</span>
                        <h2 class="mt-3 text-[1.75rem] font-semibold tracking-[-0.04em] text-base-content md:text-3xl">$${result.initialCost().rangeLowUsd()} - $${result.initialCost().rangeHighUsd()}</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/68">${confidenceLabel(result.initialCost().confidence())} confidence / normalized vendor pricing</p>
                    </section>
                    <section class="px-4 py-4 md:px-6 md:py-5">
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Annual maintenance</span>
                        <h2 class="mt-3 text-[1.75rem] font-semibold tracking-[-0.04em] text-base-content md:text-3xl">$${result.annualCostMaintenance().rangeLowUsd()} - $${result.annualCostMaintenance().rangeHighUsd()}</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/68">${confidenceLabel(result.annualCostMaintenance().maintenanceBurden())} maintenance burden</p>
                    </section>
                </div>

                <section class="surface-panel overflow-hidden">
                    <div class="grid gap-px bg-base-300/70 xl:grid-cols-[minmax(0,1.25fr)_minmax(0,0.75fr)]">
                            <div class="bg-base-100 px-6 py-6">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">What this means now</span>
                                <div class="mt-4 overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100">
                                    <div class="data-stack">
                                        <article class="px-5 py-4">
                                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">01</span>
                                            <h3 class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">Read the direct record first</h3>
                                            <p class="mt-2 text-sm leading-7 text-base-content/66">${system.pwsName()} is handled as a direct utility dossier, not a geography-based guess.</p>
                                        </article>
                                        <article class="px-5 py-4">
                                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">02</span>
                                            <h3 class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">Normalize the benchmark relation</h3>
                                            <p class="mt-2 text-sm leading-7 text-base-content/66">The route code and benchmark relation stay explicit so narrative copy cannot drift away from the decision rule.</p>
                                        </article>
                                        <article class="px-5 py-4">
                                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">03</span>
                                            <h3 class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">Constrain the product layer</h3>
                                            <p class="mt-2 text-sm leading-7 text-base-content/66">Certified point-of-use remains the default product class until a separate escalation case is justified.</p>
                                        </article>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-base-200/58 px-6 py-6">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">What this does not tell you</span>
                                <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                                    @for (var item : result.whatThisDoesNotTellYou())
                                        <li>${item}</li>
                                    @endfor
                                </ul>
                            </div>
                        </div>
                        <div class="collapse collapse-arrow rounded-none border-0 bg-base-100">
                            <input type="checkbox" aria-label="Toggle why this route opened">
                            <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">Why this route opened (${result.whyThis().size()})</div>
                            <div class="collapse-content">
                                <ul class="space-y-3 pt-2 text-sm leading-7 text-base-content/72">
                                    @for (var item : result.whyThis())
                                        <li>${item}</li>
                                    @endfor
                                </ul>
                            </div>
                        </div>
                </section>

                <section class="surface-panel overflow-hidden">
                    <div class="gap-0 p-0">
                        <div class="border-b border-base-300/70 px-6 py-5">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Best-fit options</span>
                            <h2 class="mt-4 text-2xl font-semibold tracking-[-0.03em] text-base-content">Best-fit options</h2>
                            <p class="mt-3 max-w-2xl text-sm leading-7 text-base-content/66">These are route-fit patterns, not a popularity ranking. The list stays subordinate to the current utility posture.</p>
                        </div>
                        <div class="divide-y divide-base-300/70">
                            @for (var option : result.bestFitOptions().subList(0, Math.min(result.bestFitOptions().size(), 2)))
                                <article class="grid gap-4 px-6 py-5 lg:grid-cols-[3rem_minmax(0,1fr)_12rem] lg:items-start">
                                    <div class="text-[1.6rem] font-semibold tracking-[-0.04em] text-base-content/42">${result.bestFitOptions().indexOf(option) + 1}</div>
                                    <div class="space-y-3">
                                        <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">${option.label()}</h3>
                                        <p class="text-sm leading-7 text-base-content/68">${option.fitReason()}</p>
                                        <p class="text-sm leading-7 text-base-content/58">${option.notForEveryone()}</p>
                                    </div>
                                    <div class="surface-muted px-4 py-4">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Cost posture</div>
                                        <div class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">${option.costProfile()} cost</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/58">Use this only when the route still fits the maintenance burden.</div>
                                    </div>
                                </article>
                            @endfor
                        </div>
                        @if(result.bestFitOptions().size() > 2)
                            <div class="collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-200/34">
                                <input type="checkbox" aria-label="Toggle more route-fit patterns">
                                <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More route-fit patterns (${result.bestFitOptions().size() - 2})</div>
                                <div class="collapse-content">
                                    <div class="overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100 pt-2">
                                        @for (var option : result.bestFitOptions().subList(2, result.bestFitOptions().size()))
                                            <article class="grid gap-4 px-5 py-5 ${option != result.bestFitOptions().get(2) ? "border-t border-base-300/70" : ""} lg:grid-cols-[3rem_minmax(0,1fr)_12rem] lg:items-start">
                                                <div class="text-[1.4rem] font-semibold tracking-[-0.04em] text-base-content/42">${result.bestFitOptions().indexOf(option) + 1}</div>
                                                <div class="space-y-3">
                                                    <h3 class="text-lg font-semibold tracking-[-0.03em] text-base-content">${option.label()}</h3>
                                                    <p class="text-sm leading-7 text-base-content/68">${option.fitReason()}</p>
                                                    <p class="text-sm leading-7 text-base-content/58">${option.notForEveryone()}</p>
                                                </div>
                                                <div class="rounded-[1rem] border border-base-300/70 bg-base-200/32 px-4 py-4">
                                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Cost posture</div>
                                                    <div class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">${option.costProfile()} cost</div>
                                                </div>
                                            </article>
                                        @endfor
                                    </div>
                                </div>
                            </div>
                        @endif
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
                    routeCode = commercialState.code(),
                    benchmarkRelation = result.meta().benchmarkRelation(),
                    unlockState = commercialState.code(),
                    nextActionCode = result.nextAction().code(),
                    products = decision.certifiedPouOptions().subList(0, Math.min(decision.certifiedPouOptions().size(), 8))
                )

                <section class="surface-panel overflow-hidden">
                    <div class="gap-0 p-0">
                        <div class="border-b border-base-300/70 px-6 py-5">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Primary source ledger</span>
                            <h2 class="mt-4 text-2xl font-semibold tracking-[-0.03em] text-base-content">Primary source ledger</h2>
                            <p class="mt-3 max-w-2xl text-sm leading-7 text-base-content/66">The evidence layer is shown as a ledger, not as article cards. Open the exact record that anchors this route.</p>
                        </div>
                        <div class="divide-y divide-base-300/70">
                            @for (var source : result.sources().subList(0, Math.min(result.sources().size(), 2)))
                                <a class="row-link grid gap-4 px-6 py-5 sm:grid-cols-[12rem_minmax(0,1fr)] sm:items-start" href="${source.url()}">
                                    <div>
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/60">${source.organization()}</div>
                                    </div>
                                    <div>
                                        <div class="text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                        <div class="mt-2 break-all text-sm leading-6 text-base-content/56">${source.url()}</div>
                                    </div>
                                </a>
                            @endfor
                        </div>
                        @if(result.sources().size() > 2)
                            <div class="collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-200/34">
                                <input type="checkbox" aria-label="Toggle more sources">
                                <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More sources (${result.sources().size() - 2})</div>
                                <div class="collapse-content">
                                    <div class="overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100 pt-2">
                                        @for (var source : result.sources().subList(2, result.sources().size()))
                                            <a class="row-link grid gap-4 px-5 py-5 sm:grid-cols-[12rem_minmax(0,1fr)] sm:items-start ${source != result.sources().get(2) ? "border-t border-base-300/70" : ""}" href="${source.url()}">
                                                <div>
                                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()}</div>
                                                    <div class="mt-2 text-sm leading-6 text-base-content/60">${source.organization()}</div>
                                                </div>
                                                <div>
                                                    <div class="text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                                    <div class="mt-2 break-all text-sm leading-6 text-base-content/56">${source.url()}</div>
                                                </div>
                                            </a>
                                        @endfor
                                    </div>
                                </div>
                            </div>
                        @endif
                    </div>
                </section>
            </div>

            <aside class="xl:sticky xl:top-28">
                <section class="surface-panel overflow-hidden">
                    <div class="gap-0 p-0">
                        <div class="border-b border-base-300/70 px-6 py-5">
                            <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Assessment ledger</h2>
                            <p class="mt-3 text-sm leading-7 text-base-content/64">Keep a few utility observations in view, then open the rest only when you need to inspect the record in detail.</p>
                        </div>
                        <div class="divide-y divide-base-300/70">
                            @for (var i = 0; i < Math.min(decision.assessments().size(), 3); i++)
                                <article class="px-6 py-5">
                                    <div class="flex flex-wrap items-start justify-between gap-3">
                                        <div class="space-y-2">
                                            <div class="text-base font-semibold tracking-[-0.02em] text-base-content">${decision.assessments().get(i).contaminantLabel()}</div>
                                            <div class="text-sm leading-6 text-base-content/62">${decision.assessments().get(i).sampleContext()} / benchmark ${decision.assessments().get(i).benchmarkValue()} ${decision.assessments().get(i).benchmarkUnit()}</div>
                                        </div>
                                        <div class="space-y-2 text-right">
                                            <div class="text-xl font-semibold tracking-[-0.03em] text-base-content">${decision.assessments().get(i).value()} ${decision.assessments().get(i).unit()}</div>
                                            @if (decision.assessments().get(i).comparisonStatus() == BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK)
                                                <span class="inline-flex rounded-full bg-warning/16 px-3 py-1 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-[rgb(122,82,25)]">Above selected benchmark</span>
                                            @endif
                                            @if (decision.assessments().get(i).comparisonStatus() == BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK)
                                                <span class="inline-flex rounded-full bg-primary/14 px-3 py-1 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-primary">Present below benchmark</span>
                                            @endif
                                            @if (decision.assessments().get(i).comparisonStatus() != BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK && decision.assessments().get(i).comparisonStatus() != BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK)
                                                <span class="inline-flex rounded-full border border-base-300/70 bg-base-100 px-3 py-1 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content/58">${comparisonStatusLabel(decision.assessments().get(i).comparisonStatus())}</span>
                                            @endif
                                        </div>
                                    </div>
                                    <div class="mt-3 text-sm leading-6 text-base-content/70">${decision.assessments().get(i).benchmarkLabel()} / ${decision.assessments().get(i).benchmarkReferenceStatus()}</div>
                                </article>
                            @endfor
                        </div>
                        @if (decision.assessments().size() > 3)
                            <div class="collapse collapse-arrow rounded-none border-0 border-t border-base-300/70 bg-base-100">
                                <input type="checkbox" aria-label="Toggle more utility readings">
                                <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">More utility readings (${decision.assessments().size() - 3})</div>
                                <div class="collapse-content">
                                    <div class="overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100 pt-2">
                                        @for (var i = 3; i < decision.assessments().size(); i++)
                                            <article class="px-5 py-5 ${i > 3 ? "border-t border-base-300/70" : ""}">
                                                <div class="flex flex-wrap items-start justify-between gap-3">
                                                    <div class="space-y-2">
                                                        <div class="text-base font-semibold tracking-[-0.02em] text-base-content">${decision.assessments().get(i).contaminantLabel()}</div>
                                                        <div class="text-sm leading-6 text-base-content/62">${decision.assessments().get(i).sampleContext()} / benchmark ${decision.assessments().get(i).benchmarkValue()} ${decision.assessments().get(i).benchmarkUnit()}</div>
                                                    </div>
                                                    <div class="space-y-2 text-right">
                                                        <div class="text-lg font-semibold tracking-[-0.03em] text-base-content">${decision.assessments().get(i).value()} ${decision.assessments().get(i).unit()}</div>
                                                        <div class="text-[0.72rem] font-medium tracking-[-0.01em] text-base-content/58">${comparisonStatusLabel(decision.assessments().get(i).comparisonStatus())}</div>
                                                    </div>
                                                </div>
                                                <div class="mt-3 text-sm leading-6 text-base-content/70">${decision.assessments().get(i).benchmarkLabel()} / ${decision.assessments().get(i).benchmarkReferenceStatus()}</div>
                                            </article>
                                        @endfor
                                    </div>
                                </div>
                            </div>
                        @endif
                        <section class="border-t border-base-300/70 px-6 py-5">
                            <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">Operating boundary</h3>
                            <p class="mt-4 text-sm leading-7 text-base-content/72">This output is an interpretation layer over direct utility evidence. It is not a household safety grade, not a medical statement, and not a whole-house-first sales recommendation.</p>
                        </section>
                        <div class="collapse collapse-arrow rounded-none border-0 border-t border-base-300/70 bg-base-100">
                            <input type="checkbox" aria-label="Toggle certification checklist">
                            <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">Certification checklist</div>
                            <div class="collapse-content">
                                <ul class="space-y-3 pt-2 text-sm leading-7 text-base-content/72">
                                    @for (var item : result.certificationChecklist())
                                        <li>${item.label()} / ${item.detail()}</li>
                                    @endfor
                                </ul>
                            </div>
                        </div>
                        <div class="collapse collapse-arrow rounded-none border-0 border-t border-base-300/70 bg-base-100">
                            <input type="checkbox" aria-label="Toggle when to escalate">
                            <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">When to escalate</div>
                            <div class="collapse-content">
                                <ul class="space-y-3 pt-2 text-sm leading-7 text-base-content/72">
                                    @for (var item : result.whenToEscalate())
                                        <li>${item}</li>
                                    @endfor
                                </ul>
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
