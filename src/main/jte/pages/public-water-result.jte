@import com.example.pfas.result.WaterDecisionResult
@import com.example.pfas.water.PublicWaterSystem
@import com.example.pfas.decision.PublicWaterDecisionContext
@import com.example.pfas.decision.BenchmarkComparisonStatus
@import static com.example.pfas.web.PresentationText.benchmarkRelationLabel
@import static com.example.pfas.web.PresentationText.comparisonStatusLabel
@import static com.example.pfas.web.PresentationText.confidenceLabel
@import static com.example.pfas.web.PresentationText.sourceWaterTypeLabel
@import static com.example.pfas.web.PresentationText.systemTypeLabel
@param PublicWaterSystem system
@param PublicWaterDecisionContext decision
@param WaterDecisionResult result

@template.layout.base(
    pageTitle = system.pwsName() + " PFAS Result",
    pageDescription = "Rendered PFAS decision result for " + system.pwsName() + " using normalized utility and benchmark data.",
    content = @`
<section class="result-shell">
    <div class="shell">
        <div class="result-header">
            <div>
                <span class="eyebrow">${system.stateCode()} public-water dossier</span>
                <h1 class="result-header__title">${system.pwsName()}</h1>
                <p class="hero__lede">
                    Utility observations, registry-backed benchmarks, and certification records are rendered together as one
                    interpretation output.
                </p>
            </div>
            <div class="button-row">
                <a class="button button--secondary" href="${system.ccrUrl()}">Open utility report</a>
                <a class="button button--primary" href="/internal/results/public-water/${system.pwsid()}">Open result JSON</a>
            </div>
        </div>

        @template.fragments.publicationStrip(lastVerified = system.lastVerifiedDate(), scopeLabel = "Public-water interpretation")

        <div class="dossier-strip">
            <article class="dossier-cell">
                <span class="dossier-cell__label">Utility record</span>
                <span class="dossier-cell__value">${system.pwsid()}</span>
                <span class="dossier-cell__copy">${systemTypeLabel(system.systemType())} / ${sourceWaterTypeLabel(system.sourceWaterType())}</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Benchmark posture</span>
                <span class="dossier-cell__value">${benchmarkRelationLabel(result.meta().benchmarkRelation())}</span>
                <span class="dossier-cell__copy">${result.meta().decisionRuleId()}</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Decision confidence</span>
                <span class="dossier-cell__value">${confidenceLabel(result.nextAction().confidence())}</span>
                <span class="dossier-cell__copy">Point-of-use remains the first escalation class.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Evidence stack</span>
                <span class="dossier-cell__value">${result.sources().size()} source records</span>
                <span class="dossier-cell__copy">Utility, regulatory, and claim-level listing sources render together.</span>
            </article>
        </div>

        <div class="result-grid">
            <div class="stack">
                <section class="card card--hero next-action">
                    <span class="next-action__code">${result.nextAction().code()}</span>
                    <div>
                        <p class="card__label">Next action</p>
                        <h2 class="next-action__title">${result.nextAction().title()}</h2>
                    </div>
                    <p class="next-action__summary">${result.nextAction().summary()}</p>
                    <div class="card__meta-row">
                        <span class="chip">Confidence ${confidenceLabel(result.nextAction().confidence())}</span>
                        <span class="chip">Rule ${result.meta().decisionRuleId()}</span>
                        <span class="chip">Benchmark relation ${benchmarkRelationLabel(result.meta().benchmarkRelation())}</span>
                    </div>
                </section>

                <section class="metric-grid">
                    <article class="metric">
                        <p class="card__label">Initial cost</p>
                        <div class="metric__value">$${result.initialCost().rangeLowUsd()} - $${result.initialCost().rangeHighUsd()}</div>
                        <p class="metric__meta">${confidenceLabel(result.initialCost().confidence())} confidence / normalized vendor pricing</p>
                    </article>
                    <article class="metric">
                        <p class="card__label">Annual maintenance</p>
                        <div class="metric__value">$${result.annualCostMaintenance().rangeLowUsd()} - $${result.annualCostMaintenance().rangeHighUsd()}</div>
                        <p class="metric__meta">${confidenceLabel(result.annualCostMaintenance().maintenanceBurden())} maintenance burden</p>
                    </article>
                </section>

                <section class="card">
                    <p class="card__label">Interpretation brief</p>
                    <div class="ledger-list ledger-list--compact">
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">01</span>
                            <div>
                                <h3 class="ledger-item__title">Read the direct record first</h3>
                                <p class="ledger-item__copy">${system.pwsName()} is handled as a direct utility dossier, not a geography-based guess.</p>
                            </div>
                        </article>
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">02</span>
                            <div>
                                <h3 class="ledger-item__title">Normalize the benchmark relation</h3>
                                <p class="ledger-item__copy">The route code and benchmark relation stay explicit so narrative copy cannot drift away from the decision rule.</p>
                            </div>
                        </article>
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">03</span>
                            <div>
                                <h3 class="ledger-item__title">Constrain the product layer</h3>
                                <p class="ledger-item__copy">Certified point-of-use remains the default product class until a separate escalation case is justified.</p>
                            </div>
                        </article>
                    </div>
                </section>

                <section class="card">
                    <p class="card__label">Why this</p>
                    <ul class="list">
                        @for (var item : result.whyThis())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>

                <section class="card">
                    <p class="card__label">What this does not tell you</p>
                    <ul class="list">
                        @for (var item : result.whatThisDoesNotTellYou())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>

                <section class="card">
                    <p class="card__label">Best-fit options</p>
                    <div class="assessment-grid">
                        @for (var option : result.bestFitOptions())
                            <article class="assessment">
                                <div class="assessment__top">
                                    <div class="assessment__name">${option.label()}</div>
                                    <span class="badge badge--info">${option.costProfile()} cost</span>
                                </div>
                                <div class="assessment__meta">${option.fitReason()}</div>
                                <div class="assessment__meta">${option.notForEveryone()}</div>
                            </article>
                        @endfor
                    </div>
                </section>

                <section class="card">
                    <p class="card__label">Primary source ledger</p>
                    <div class="source-list">
                        @for (var source : result.sources())
                            <a class="source-item" href="${source.url()}">
                                <div class="source-item__meta">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="source-item__title">${source.title()}</div>
                                <div class="source-item__url">${source.url()}</div>
                            </a>
                        @endfor
                    </div>
                </section>
            </div>

            <aside class="stack">
                <section class="rail-card">
                    <h2 class="rail-card__title">Assessment ledger</h2>
                    <div class="evidence-ledger">
                        @for (var assessment : decision.assessments())
                            <article class="evidence-row">
                                <div class="evidence-row__header">
                                    <div class="evidence-row__name">${assessment.contaminantLabel()}</div>
                                    @if (assessment.comparisonStatus() == BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK)
                                        <span class="badge badge--warn">Above selected benchmark</span>
                                    @endif
                                    @if (assessment.comparisonStatus() == BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK)
                                        <span class="badge badge--info">Present below benchmark</span>
                                    @endif
                                    @if (assessment.comparisonStatus() != BenchmarkComparisonStatus.ABOVE_SELECTED_BENCHMARK && assessment.comparisonStatus() != BenchmarkComparisonStatus.PRESENT_BELOW_SELECTED_BENCHMARK)
                                        <span class="badge badge--ok">${comparisonStatusLabel(assessment.comparisonStatus())}</span>
                                    @endif
                                </div>
                                <div class="evidence-row__value">${assessment.value()} ${assessment.unit()}</div>
                                <div class="evidence-row__meta">
                                    ${assessment.sampleContext()} / benchmark ${assessment.benchmarkValue()} ${assessment.benchmarkUnit()}
                                </div>
                                <div class="evidence-row__meta">
                                    ${assessment.benchmarkLabel()} / ${assessment.benchmarkReferenceStatus()}
                                </div>
                            </article>
                        @endfor
                    </div>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">Certification checklist</h2>
                    <ul class="list">
                        @for (var item : result.certificationChecklist())
                            <li>${item.label()} / ${item.detail()}</li>
                        @endfor
                    </ul>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">Operating boundary</h2>
                    <p class="checker-block__hint">
                        This output is an interpretation layer over direct utility evidence. It is not a household safety grade,
                        not a medical statement, and not a whole-house-first sales recommendation.
                    </p>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">When to escalate</h2>
                    <ul class="list">
                        @for (var item : result.whenToEscalate())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
