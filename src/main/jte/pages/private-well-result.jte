@import com.example.pfas.checker.ActionBenchmarkRelation
@import com.example.pfas.checker.ActionCurrentFilterStatus
@import com.example.pfas.result.WaterDecisionResult
@import com.example.pfas.state.StateGuidance
@import static com.example.pfas.web.PresentationText.benchmarkRelationLabel
@import static com.example.pfas.web.PresentationText.currentFilterStatusLabel
@import static com.example.pfas.web.PresentationText.confidenceLabel
@param String siteBaseUrl
@param StateGuidance guidance
@param WaterDecisionResult result
@param ActionBenchmarkRelation benchmarkRelation
@param ActionCurrentFilterStatus currentFilterStatus
@param boolean wholeHouseConsidered
@param String batchInput
@param String encodedBatchInput
@param String analyteCode
@param java.math.BigDecimal value
@param String unit

@template.layout.base(
    pageTitle = guidance.stateCode() + " private-well PFAS result",
    pageDescription = "State-guided private-well PFAS interpretation result for " + guidance.stateCode() + ".",
    pageCanonicalUrl = siteBaseUrl + "/private-well/" + guidance.stateCode(),
    pageIndexable = false,
    content = @`
<section class="result-shell">
    <div class="shell">
        <div class="result-header">
            <div>
                <span class="eyebrow">${guidance.stateCode()} private-well dossier</span>
                <h1 class="result-header__title">${guidance.agencyName()}</h1>
                <p class="hero__lede">
                    This result keeps private-well interpretation reference-based. State guidance, certified-lab context,
                    and optional certified point-of-use treatment are rendered together without pretending a private well is a
                    public-water compliance case.
                </p>
            </div>
            <div class="button-row">
                <a class="button button--secondary" href="${guidance.privateWellGuidanceUrl()}">Open official guidance</a>
                <a class="button button--secondary" href="${guidance.certifiedLabLookupUrl()}">Open certified lab lookup</a>
                @if (result.benchmarkBatchEvaluation() != null && encodedBatchInput != null)
                    <a class="button button--primary" href="/internal/results/private-well/${guidance.stateCode()}?batchInput=${encodedBatchInput}&currentFilterStatus=${currentFilterStatus.name()}&wholeHouseConsidered=${wholeHouseConsidered}">Open result JSON</a>
                @else
                    @if (result.benchmarkEvaluation() != null)
                        <a class="button button--primary" href="/internal/results/private-well/${guidance.stateCode()}?analyteCode=${result.benchmarkEvaluation().analyteCode()}&value=${result.benchmarkEvaluation().inputValue()}&unit=${result.benchmarkEvaluation().inputUnit()}&currentFilterStatus=${currentFilterStatus.name()}&wholeHouseConsidered=${wholeHouseConsidered}">Open result JSON</a>
                    @else
                        <a class="button button--primary" href="/internal/results/private-well/${guidance.stateCode()}?benchmarkRelation=${benchmarkRelation.name()}&currentFilterStatus=${currentFilterStatus.name()}&wholeHouseConsidered=${wholeHouseConsidered}">Open result JSON</a>
                    @endif
                @endif
            </div>
        </div>

        @template.fragments.publicationStrip(lastVerified = guidance.lastVerifiedDate(), scopeLabel = "Private-well interpretation")

        <div class="dossier-strip">
            <article class="dossier-cell">
                <span class="dossier-cell__label">State route</span>
                <span class="dossier-cell__value">${guidance.stateCode()}</span>
                <span class="dossier-cell__copy">State-specific guide and lab pathway.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Benchmark relation</span>
                <span class="dossier-cell__value">${benchmarkRelationLabel(benchmarkRelation)}</span>
                <span class="dossier-cell__copy">${result.meta().decisionRuleId()}</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Current filter</span>
                <span class="dossier-cell__value">${currentFilterStatusLabel(currentFilterStatus)}</span>
                <span class="dossier-cell__copy">Whole-house considered: ${wholeHouseConsidered ? "yes" : "no"}</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Last verified</span>
                <span class="dossier-cell__value">${guidance.lastVerifiedDate()}</span>
                <span class="dossier-cell__copy">State guidance and source layer.</span>
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
                        <span class="chip">State ${guidance.stateCode()}</span>
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

                @if(!result.bestFitOptions().isEmpty())
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
                @endif

                @if (result.benchmarkEvaluation() != null)
                    <section class="card">
                        <p class="card__label">Benchmark check used for this route</p>
                        <ul class="list">
                            <li>Analyte: ${result.benchmarkEvaluation().analyteCode()}</li>
                            <li>Measured value: ${result.benchmarkEvaluation().inputValue()} ${result.benchmarkEvaluation().inputUnit()}</li>
                            <li>Normalized value: ${result.benchmarkEvaluation().normalizedValuePpt()} ppt</li>
                            <li>Matched line: ${result.benchmarkEvaluation().matchedReferenceLabel()} (${result.benchmarkEvaluation().matchedReferenceDisplay()})</li>
                            <li>Note: ${result.benchmarkEvaluation().note()}</li>
                        </ul>
                    </section>
                @endif

                @if (result.benchmarkBatchEvaluation() != null)
                    <section class="card">
                        <p class="card__label">Batch benchmark check used for this route</p>
                        <ul class="list">
                            <li>Aggregate relation: ${result.benchmarkBatchEvaluation().aggregateRelation()}</li>
                            <li>${result.benchmarkBatchEvaluation().aggregateSummary()}</li>
                            <li>Comparable lines: ${result.benchmarkBatchEvaluation().comparableLineCount()}</li>
                            <li>Not comparable lines: ${result.benchmarkBatchEvaluation().notComparableLineCount()}</li>
                        </ul>
                        <div class="assessment-grid">
                            @for (var line : result.benchmarkBatchEvaluation().lineEvaluations())
                                <article class="assessment">
                                    <div class="assessment__top">
                                        <div class="assessment__name">${line.analyteCode()}</div>
                                        <span class="badge badge--info">${line.benchmarkRelation()}</span>
                                    </div>
                                    <div class="assessment__meta">${line.inputValue()} ${line.inputUnit()} vs ${line.matchedReferenceLabel()} (${line.matchedReferenceDisplay()})</div>
                                    <div class="assessment__meta">${line.note()}</div>
                                </article>
                            @endfor
                        </div>
                    </section>
                @endif

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
                    <h2 class="rail-card__title">State context</h2>
                    <ul class="list">
                        <li>${guidance.repeatTestingGuidance()}</li>
                        <li>${guidance.benchmarkNotes()}</li>
                    </ul>
                </section>

                @if (result.referenceContext() != null)
                    <section class="rail-card">
                        <h2 class="rail-card__title">${result.referenceContext().primaryReferenceLabel()}</h2>
                        <p class="checker-block__hint">${result.referenceContext().summary()}</p>
                        <ul class="list">
                            @for (var line : result.referenceContext().benchmarkLines())
                                <li>${line.label()}: ${line.benchmarkDisplay()} (${line.note()})</li>
                            @endfor
                        </ul>
                    </section>
                @endif

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
                        This output is a private-well interpretation layer. It is not a public-water compliance label, not a
                        medical statement, and not a whole-house-first recommendation.
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
