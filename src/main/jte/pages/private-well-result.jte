@import com.example.pfas.checker.ActionBenchmarkRelation
@import com.example.pfas.checker.ActionCurrentFilterStatus
@import com.example.pfas.commercial.CommercialSurfaceState
@import com.example.pfas.result.WaterDecisionResult
@import com.example.pfas.state.StateGuidance
@import static com.example.pfas.web.PresentationText.benchmarkRelationLabel
@import static com.example.pfas.web.PresentationText.currentFilterStatusLabel
@import static com.example.pfas.web.PresentationText.confidenceLabel
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param StateGuidance guidance
@param WaterDecisionResult result
@param ActionBenchmarkRelation benchmarkRelation
@param ActionCurrentFilterStatus currentFilterStatus
@param CommercialSurfaceState commercialState
@param boolean wholeHouseConsidered
@param String batchInput
@param String analyteCode
@param java.math.BigDecimal value
@param String unit
@param String routeId
@param String routeUrl
@param String canonicalUrl

@template.layout.base(
    pageTitle = guidance.stateCode() + " private-well PFAS result",
    pageDescription = "State-guided private-well PFAS interpretation result for " + guidance.stateCode() + ".",
    pageCanonicalUrl = batchInput != null && !batchInput.isBlank()
        ? siteBaseUrl + "/private-well-result/" + guidance.stateCode()
            + "?batchInput=" + java.net.URLEncoder.encode(batchInput, java.nio.charset.StandardCharsets.UTF_8)
            + "&currentFilterStatus=" + currentFilterStatus.name()
            + "&wholeHouseConsidered=" + wholeHouseConsidered
        : analyteCode != null && value != null
        ? siteBaseUrl + "/private-well-result/" + guidance.stateCode()
            + "?analyteCode=" + java.net.URLEncoder.encode(analyteCode, java.nio.charset.StandardCharsets.UTF_8)
            + "&value=" + java.net.URLEncoder.encode(value.toPlainString(), java.nio.charset.StandardCharsets.UTF_8)
            + "&unit=" + java.net.URLEncoder.encode(unit == null || unit.isBlank() ? "ppt" : unit, java.nio.charset.StandardCharsets.UTF_8)
            + "&currentFilterStatus=" + currentFilterStatus.name()
            + "&wholeHouseConsidered=" + wholeHouseConsidered
        : siteBaseUrl + "/private-well-result/" + guidance.stateCode()
            + "?benchmarkRelation=" + benchmarkRelation.name()
            + "&currentFilterStatus=" + currentFilterStatus.name()
            + "&wholeHouseConsidered=" + wholeHouseConsidered,
    pageIndexable = false,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
                <div class="space-y-6 bg-white/[0.03] p-7 md:p-9">
                    <div class="space-y-4">
                        <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">${guidance.stateCode()} private-well dossier</span>
                        <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                            ${guidance.agencyName()}
                            <span class="font-serif font-medium text-white/72">with the state route kept in view.</span>
                        </h1>
                        <p class="max-w-3xl text-lg leading-8 text-white/72">
                            This result keeps private-well interpretation reference-based. State guidance, certified-lab context,
                            and optional certified point-of-use treatment are rendered together without pretending a private well is a
                            public-water compliance case.
                        </p>
                    </div>

                    <div class="join join-vertical gap-3 sm:join-horizontal sm:flex-wrap">
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="${guidance.privateWellGuidanceUrl()}">Read official guidance</a>
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="${guidance.certifiedLabLookupUrl()}">Review certified lab lookup</a>
                        <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold hover:bg-primary/92" href="/guides/nsf-53-vs-58-pfas">Read certification basics</a>
                    </div>
                </div>

                <aside class="bg-white/[0.02] p-7 md:p-8">
                    <div class="space-y-2">
                        <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Current docket</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-white">The state reference stays attached to the route and the caveats.</h2>
                    </div>
                    <div class="terminal-pane mt-4 overflow-hidden">
                        <div class="terminal-stack">
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Benchmark relation</strong><br>${benchmarkRelationLabel(benchmarkRelation)}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Current filter</strong><br>${currentFilterStatusLabel(currentFilterStatus)}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Whole-house considered</strong><br>${wholeHouseConsidered ? "yes" : "no"}</article>
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
            lastVerified = guidance.lastVerifiedDate(),
            scopeLabel = "Private-well interpretation",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="ledger-grid shadow-[var(--shadow-soft)] md:grid-cols-2 xl:grid-cols-4">
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">State route</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${guidance.stateCode()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">State-specific guide and lab pathway.</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Benchmark relation</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${benchmarkRelationLabel(benchmarkRelation)}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">${result.meta().decisionRuleId()}</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Current filter</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${currentFilterStatusLabel(currentFilterStatus)}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Whole-house considered: ${wholeHouseConsidered ? "yes" : "no"}</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Last verified</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${guidance.lastVerifiedDate()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">State guidance and source layer.</div>
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
            routeId = routeId,
            routeTitle = guidance.stateCode() + " private-well route",
            routeSummary = commercialState.summary(),
            routeUrl = routeUrl
        )
        <section class="surface-panel overflow-hidden" data-route-actions>
            <div class="border-b border-base-300/70 px-6 py-5">
                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Service lanes</span>
                <h2 class="mt-3 text-2xl font-semibold tracking-[-0.03em] text-base-content">Make the private-well route handoff-ready before a partner layer exists.</h2>
                <p class="mt-3 max-w-3xl text-sm leading-7 text-base-content/66">These lanes now produce a usable intake brief, consult packet, and state handoff note. A future lab or advisory partner should inherit this structure instead of asking the household to restate the same context.</p>
            </div>
            <div class="service-lane-grid">
                <article class="px-6 py-5">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Certified lab lane</span>
                    <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Prepare the lab intake first.</h3>
                    <p class="mt-3 text-sm leading-7 text-base-content/68">Sampling context, benchmark relation, and current filter posture stay attached so the lab handoff is already structured before any referral exists.</p>
                    <div class="mt-4 flex flex-wrap items-center gap-3">
                        <a class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guidance.certifiedLabLookupUrl()}">Review certified lab lookup</a>
                        <button
                            type="button"
                            class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200"
                            data-route-save="true"
                            data-route-id="${routeId}:lab"
                            data-route-title="${guidance.stateCode()} private-well lab brief"
                            data-route-summary="${commercialState.summary()}"
                            data-route-url="${routeUrl}"
                            data-route-detail="${guidance.stateCode()} private-well lab brief&#10;Commercial state: ${commercialState.statusLabel()}&#10;Route code: ${commercialState.code()}&#10;Benchmark relation: ${benchmarkRelationLabel(benchmarkRelation)}&#10;Current filter: ${currentFilterStatusLabel(currentFilterStatus)}&#10;Whole-house considered: ${wholeHouseConsidered ? "Yes" : "No"}&#10;Next action: ${result.nextAction().title()}&#10;Official guidance: ${guidance.privateWellGuidanceUrl()}&#10;Certified lab lookup: ${guidance.certifiedLabLookupUrl()}"
                            data-service-lane="Certified lab"
                            data-state-code="${guidance.stateCode()}"
                            data-benchmark-relation="${benchmarkRelationLabel(benchmarkRelation)}"
                            data-current-filter-status="${currentFilterStatusLabel(currentFilterStatus)}"
                            data-whole-house-considered="${wholeHouseConsidered ? "Yes" : "No"}"
                            data-next-action="${result.nextAction().title()}"
                            data-official-guidance-url="${guidance.privateWellGuidanceUrl()}"
                            data-lab-lookup-url="${guidance.certifiedLabLookupUrl()}"
                        >Save lab brief</button>
                        <button
                            type="button"
                            class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200"
                            data-route-copy="true"
                            data-route-id="${routeId}:lab-copy"
                            data-route-title="${guidance.stateCode()} private-well lab brief"
                            data-route-summary="${commercialState.summary()}"
                            data-route-url="${routeUrl}"
                            data-route-detail="${guidance.stateCode()} private-well lab brief&#10;Commercial state: ${commercialState.statusLabel()}&#10;Route code: ${commercialState.code()}&#10;Benchmark relation: ${benchmarkRelationLabel(benchmarkRelation)}&#10;Current filter: ${currentFilterStatusLabel(currentFilterStatus)}&#10;Whole-house considered: ${wholeHouseConsidered ? "Yes" : "No"}&#10;Next action: ${result.nextAction().title()}&#10;Official guidance: ${guidance.privateWellGuidanceUrl()}&#10;Certified lab lookup: ${guidance.certifiedLabLookupUrl()}"
                            data-service-lane="Certified lab"
                            data-state-code="${guidance.stateCode()}"
                            data-benchmark-relation="${benchmarkRelationLabel(benchmarkRelation)}"
                            data-current-filter-status="${currentFilterStatusLabel(currentFilterStatus)}"
                            data-whole-house-considered="${wholeHouseConsidered ? "Yes" : "No"}"
                            data-next-action="${result.nextAction().title()}"
                            data-official-guidance-url="${guidance.privateWellGuidanceUrl()}"
                            data-lab-lookup-url="${guidance.certifiedLabLookupUrl()}"
                        >Copy lab intake</button>
                    </div>
                </article>
                <article class="px-6 py-5">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">State guidance lane</span>
                    <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Keep the agency route visible before hardware.</h3>
                    <p class="mt-3 text-sm leading-7 text-base-content/68">Retest cadence, reference posture, and official next steps stay visible here even when treatment is under evaluation.</p>
                    <div class="mt-4 flex flex-wrap items-center gap-3">
                        <a class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guidance.privateWellGuidanceUrl()}">Read official guidance</a>
                        <a class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/private-well/${guidance.stateCode()}">Read state guide</a>
                        <button
                            type="button"
                            class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200"
                            data-route-download="true"
                            data-route-id="${routeId}:state-note"
                            data-route-title="${guidance.stateCode()} private-well state handoff note"
                            data-route-summary="${commercialState.summary()}"
                            data-route-url="${routeUrl}"
                            data-route-detail="${guidance.stateCode()} private-well state handoff note&#10;Commercial state: ${commercialState.statusLabel()}&#10;Route code: ${commercialState.code()}&#10;Benchmark relation: ${benchmarkRelationLabel(benchmarkRelation)}&#10;Current filter: ${currentFilterStatusLabel(currentFilterStatus)}&#10;Whole-house considered: ${wholeHouseConsidered ? "Yes" : "No"}&#10;Next action: ${result.nextAction().title()}&#10;Official guidance: ${guidance.privateWellGuidanceUrl()}&#10;Certified lab lookup: ${guidance.certifiedLabLookupUrl()}"
                            data-service-lane="State guidance"
                            data-state-code="${guidance.stateCode()}"
                            data-benchmark-relation="${benchmarkRelationLabel(benchmarkRelation)}"
                            data-current-filter-status="${currentFilterStatusLabel(currentFilterStatus)}"
                            data-whole-house-considered="${wholeHouseConsidered ? "Yes" : "No"}"
                            data-next-action="${result.nextAction().title()}"
                            data-official-guidance-url="${guidance.privateWellGuidanceUrl()}"
                            data-lab-lookup-url="${guidance.certifiedLabLookupUrl()}"
                        >Download state note</button>
                    </div>
                </article>
                <article class="service-lane-accent px-6 py-5">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Consult-ready handoff</span>
                    <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Package the route for consult intake.</h3>
                    <p class="mt-3 text-sm leading-7 text-base-content/68">The consult lane now ships as a reusable packet so a future advisor or referral can start from the current route instead of restarting intake.</p>
                    <div class="mt-4 flex flex-wrap items-center gap-3">
                        <button
                            type="button"
                            class="btn btn-primary h-10 rounded-full border-0 px-4 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92"
                            data-route-email="true"
                            data-route-id="${routeId}:consult"
                            data-route-title="${guidance.stateCode()} private-well consult summary"
                            data-route-summary="${commercialState.summary()}"
                            data-route-url="${routeUrl}"
                            data-route-detail="${guidance.stateCode()} private-well consult packet&#10;Commercial state: ${commercialState.statusLabel()}&#10;Route code: ${commercialState.code()}&#10;Benchmark relation: ${benchmarkRelationLabel(benchmarkRelation)}&#10;Current filter: ${currentFilterStatusLabel(currentFilterStatus)}&#10;Whole-house considered: ${wholeHouseConsidered ? "Yes" : "No"}&#10;Next action: ${result.nextAction().title()}&#10;Official guidance: ${guidance.privateWellGuidanceUrl()}&#10;Certified lab lookup: ${guidance.certifiedLabLookupUrl()}"
                            data-service-lane="Consult"
                            data-state-code="${guidance.stateCode()}"
                            data-benchmark-relation="${benchmarkRelationLabel(benchmarkRelation)}"
                            data-current-filter-status="${currentFilterStatusLabel(currentFilterStatus)}"
                            data-whole-house-considered="${wholeHouseConsidered ? "Yes" : "No"}"
                            data-next-action="${result.nextAction().title()}"
                            data-official-guidance-url="${guidance.privateWellGuidanceUrl()}"
                            data-lab-lookup-url="${guidance.certifiedLabLookupUrl()}"
                        >Send consult-ready summary</button>
                        <button
                            type="button"
                            class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200"
                            data-route-download="true"
                            data-route-id="${routeId}:consult-packet"
                            data-route-title="${guidance.stateCode()} private-well consult packet"
                            data-route-summary="${commercialState.summary()}"
                            data-route-url="${routeUrl}"
                            data-route-detail="${guidance.stateCode()} private-well consult packet&#10;Commercial state: ${commercialState.statusLabel()}&#10;Route code: ${commercialState.code()}&#10;Benchmark relation: ${benchmarkRelationLabel(benchmarkRelation)}&#10;Current filter: ${currentFilterStatusLabel(currentFilterStatus)}&#10;Whole-house considered: ${wholeHouseConsidered ? "Yes" : "No"}&#10;Next action: ${result.nextAction().title()}&#10;Official guidance: ${guidance.privateWellGuidanceUrl()}&#10;Certified lab lookup: ${guidance.certifiedLabLookupUrl()}"
                            data-service-lane="Consult"
                            data-state-code="${guidance.stateCode()}"
                            data-benchmark-relation="${benchmarkRelationLabel(benchmarkRelation)}"
                            data-current-filter-status="${currentFilterStatusLabel(currentFilterStatus)}"
                            data-whole-house-considered="${wholeHouseConsidered ? "Yes" : "No"}"
                            data-next-action="${result.nextAction().title()}"
                            data-official-guidance-url="${guidance.privateWellGuidanceUrl()}"
                            data-lab-lookup-url="${guidance.certifiedLabLookupUrl()}"
                        >Download consult packet</button>
                    </div>
                </article>
            </div>
            <div class="border-t border-base-300/70 px-6 py-4 text-sm leading-6 text-base-content/58" data-route-status role="status" aria-live="polite" aria-atomic="true">Lab and consult packets can now be saved, copied, mailed, or downloaded before any partner integration exists.</div>
        </section>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="terminal-panel overflow-hidden">
                    <div class="grid gap-5 p-6 text-neutral-content md:p-7">
                        <div class="flex flex-wrap items-center gap-2">
                            <span class="badge border-0 bg-white text-neutral">${result.nextAction().code()}</span>
                            <span class="badge border-0 bg-white/10 text-white/80">Confidence ${confidenceLabel(result.nextAction().confidence())}</span>
                            <span class="badge border-0 bg-white/10 text-white/80">Rule ${result.meta().decisionRuleId()}</span>
                        </div>
                        <h2 class="max-w-4xl text-3xl font-semibold tracking-[-0.04em] text-white">${result.nextAction().title()}</h2>
                        <p class="max-w-3xl text-sm leading-7 text-white/70">${result.nextAction().summary()}</p>
                        <div class="terminal-grid md:grid-cols-2">
                            <article class="px-5 py-5">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/54">Decision posture</div>
                                <p class="mt-3 text-sm leading-7 text-white/72">Private-well logic stays reference-based. A state line and lab-ready context open before any shopping lane becomes active.</p>
                            </article>
                            <article class="px-5 py-5">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/54">What remains guarded</div>
                                <p class="mt-3 text-sm leading-7 text-white/72">Whole-house treatment still requires a separate ingestion-versus-whole-home justification, not just generalized concern.</p>
                            </article>
                        </div>
                    </div>
                </section>

                <div class="ledger-grid lg:grid-cols-2">
                    <section class="px-6 py-5">
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Initial cost</span>
                        <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">$${result.initialCost().rangeLowUsd()} - $${result.initialCost().rangeHighUsd()}</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/68">${confidenceLabel(result.initialCost().confidence())} confidence / normalized vendor pricing</p>
                    </section>
                    <section class="px-6 py-5">
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Annual maintenance</span>
                        <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">$${result.annualCostMaintenance().rangeLowUsd()} - $${result.annualCostMaintenance().rangeHighUsd()}</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/68">${confidenceLabel(result.annualCostMaintenance().maintenanceBurden())} maintenance burden</p>
                    </section>
                </div>

                <section class="surface-panel overflow-hidden">
                    <div class="grid gap-px bg-base-300/70 xl:grid-cols-[minmax(0,0.95fr)_minmax(0,1.05fr)]">
                            <div class="bg-base-100 px-6 py-6">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">What this means now</span>
                                <div class="mt-4 overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100">
                                    <div class="data-stack">
                                    <article class="px-5 py-4">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">State route</div>
                                        <p class="mt-2 text-sm leading-7 text-base-content/68">Private well results are interpreted against ${guidance.stateCode()} state guidance, not as public-water compliance findings.</p>
                                    </article>
                                    <article class="px-5 py-4">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Reference posture</div>
                                        <p class="mt-2 text-sm leading-7 text-base-content/68">Benchmark relation is ${benchmarkRelationLabel(benchmarkRelation).toLowerCase()} and remains attached to the state reference context.</p>
                                    </article>
                                    <article class="px-5 py-4">
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Treatment posture</div>
                                        <p class="mt-2 text-sm leading-7 text-base-content/68">Any treatment path stays certification-first and state-guided before whole-house escalation is considered.</p>
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

                @if(!result.bestFitOptions().isEmpty())
                    <section class="surface-panel overflow-hidden">
                        <div class="gap-0 p-0">
                            <div class="border-b border-base-300/70 px-6 py-5">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Best-fit options</span>
                                <h2 class="mt-4 text-2xl font-semibold tracking-[-0.03em] text-base-content">Best-fit options</h2>
                                <p class="mt-3 max-w-2xl text-sm leading-7 text-base-content/66">These options reflect the state route and the current benchmark relation. They are not a generic product roundup.</p>
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
                                            <div class="mt-2 text-sm leading-6 text-base-content/58">Apply only after the state route and maintenance fit are clear.</div>
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
                @endif

                @if (result.benchmarkEvaluation() != null)
                    <section class="surface-panel px-6 py-5">
                        <div class="space-y-5">
                            <div class="space-y-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Benchmark check used for this route</span>
                                <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Benchmark check used for this route</h2>
                            </div>
                            <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                                <li>Analyte: ${result.benchmarkEvaluation().analyteCode()}</li>
                                <li>Measured value: ${result.benchmarkEvaluation().inputValue()} ${result.benchmarkEvaluation().inputUnit()}</li>
                                <li>Normalized value: ${result.benchmarkEvaluation().normalizedValuePpt()} ppt</li>
                                <li>Matched line: ${result.benchmarkEvaluation().matchedReferenceLabel()} (${result.benchmarkEvaluation().matchedReferenceDisplay()})</li>
                                <li>Note: ${result.benchmarkEvaluation().note()}</li>
                            </ul>
                        </div>
                    </section>
                @endif

                @if (result.benchmarkBatchEvaluation() != null)
                    <section class="surface-panel px-6 py-5">
                        <div class="space-y-5">
                            <div class="space-y-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Batch benchmark check used for this route</span>
                                <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Batch benchmark check used for this route</h2>
                            </div>
                            <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                                <li>Aggregate relation: ${result.benchmarkBatchEvaluation().aggregateRelation()}</li>
                                <li>${result.benchmarkBatchEvaluation().aggregateSummary()}</li>
                                <li>Comparable lines: ${result.benchmarkBatchEvaluation().comparableLineCount()}</li>
                                <li>Not comparable lines: ${result.benchmarkBatchEvaluation().notComparableLineCount()}</li>
                            </ul>
                            <div class="grid gap-4 lg:grid-cols-2">
                                @for (var line : result.benchmarkBatchEvaluation().lineEvaluations())
                                    <article class="surface-muted px-5 py-5">
                                        <div class="flex items-start justify-between gap-3">
                                            <div class="space-y-2">
                                                <h3 class="text-lg font-semibold tracking-[-0.02em] text-base-content">${line.analyteCode()}</h3>
                                                <p class="text-sm leading-6 text-base-content/66">${line.inputValue()} ${line.inputUnit()} vs ${line.matchedReferenceLabel()} (${line.matchedReferenceDisplay()})</p>
                                            </div>
                                            <span class="badge badge-outline border-base-300 bg-base-100 text-base-content/58">${line.benchmarkRelation()}</span>
                                        </div>
                                        <p class="mt-4 text-sm leading-7 text-base-content/72">${line.note()}</p>
                                    </article>
                                @endfor
                            </div>
                        </div>
                    </section>
                @endif

                <section class="surface-panel overflow-hidden">
                    <div class="gap-0 p-0">
                        <div class="border-b border-base-300/70 px-6 py-5">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Primary source ledger</span>
                            <h2 class="mt-4 text-2xl font-semibold tracking-[-0.03em] text-base-content">Primary source ledger</h2>
                            <p class="mt-3 max-w-2xl text-sm leading-7 text-base-content/66">The state route should be inspectable as a ledger. Each row opens the exact source supporting the interpretation.</p>
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
                            <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">State operating notes</h2>
                            <p class="mt-3 text-sm leading-7 text-base-content/64">Keep the state logic, reference notes, and escalation posture in one operating panel instead of scattering them across separate cards.</p>
                        </div>
                        <section class="px-6 py-5">
                            <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">State context</h3>
                            <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                                <li>${guidance.repeatTestingGuidance()}</li>
                                <li>${guidance.benchmarkNotes()}</li>
                            </ul>
                        </section>

                        @if (result.referenceContext() != null)
                            <section class="border-t border-base-300/70 px-6 py-5">
                                <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">${result.referenceContext().primaryReferenceLabel()}</h3>
                                <p class="mt-4 text-sm leading-7 text-base-content/68">${result.referenceContext().summary()}</p>
                                <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                                    @for (var line : result.referenceContext().benchmarkLines())
                                        <li>${line.label()}: ${line.benchmarkDisplay()} (${line.note()})</li>
                                    @endfor
                                </ul>
                            </section>
                        @endif

                        <section class="border-t border-base-300/70 px-6 py-5">
                            <h3 class="text-sm font-semibold uppercase tracking-[0.16em] text-base-content/52">Operating boundary</h3>
                            <p class="mt-4 text-sm leading-7 text-base-content/72">
                                This output is a private-well interpretation layer. It is not a public-water compliance label, not a
                                medical statement, and not a whole-house-first recommendation.
                            </p>
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
