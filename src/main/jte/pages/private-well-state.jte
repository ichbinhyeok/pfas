@import java.util.List
@import com.example.pfas.state.StateGuidance
@import com.example.pfas.stateprofile.StateBenchmarkProfile
@import com.example.pfas.source.SourceDocument
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param StateGuidance guidance
@param StateBenchmarkProfile profile
@param List<SourceDocument> sources

@template.layout.base(
    pageTitle = guidance.stateCode() + " private-well PFAS guide",
    pageDescription = "State-backed private-well PFAS routing page for " + guidance.stateCode() + ".",
    pageCanonicalUrl = siteBaseUrl + "/private-well/" + guidance.stateCode(),
    pageIndexable = true,
    content = @`
<section class="result-shell">
    <div class="shell">
        <div class="result-header">
            <div>
                <span class="eyebrow">${guidance.stateCode()} private well</span>
                <h1 class="result-header__title">${guidance.agencyName()}</h1>
                <p class="hero__lede">
                    Private-well route for ${guidance.stateCode()}. This page stays reference-based and points users to official
                    lab lookup, sampling guidance, and repeat-testing context.
                </p>
            </div>
            <div class="button-row">
                <a class="button button--primary" href="${guidance.privateWellGuidanceUrl()}">Open official guidance</a>
                <a class="button button--secondary" href="${guidance.certifiedLabLookupUrl()}">Open certified lab lookup</a>
            </div>
        </div>

        @template.fragments.publicationStrip(
            lastVerified = guidance.lastVerifiedDate(),
            scopeLabel = "Private-well state guide",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )

        <div class="result-grid">
            <div class="stack">
                <section class="card card--hero">
                    <div class="next-action">
                        <span class="next-action__code">Private-well next action</span>
                        <h2 class="next-action__title">Test first, then interpret against state guidance.</h2>
                        <p class="next-action__summary">
                            State-specific lab and sampling guidance should appear before any filter shopping or whole-house
                            escalation.
                        </p>
                    </div>
                </section>

                <section class="card">
                    <p class="card__label">Sampling and testing</p>
                    <h2 class="section__title">What to do first</h2>
                    <ul class="list">
                        <li>Use the state-certified lab route rather than a generic home test suggestion.</li>
                        <li>Follow the state sampling instructions before collecting a PFAS well sample.</li>
                        <li>Keep interpretation reference-based and avoid calling a private well compliant or non-compliant.</li>
                    </ul>
                </section>

                <section class="card">
                    <p class="card__label">Notes</p>
                    <h2 class="section__title">Interpretation context</h2>
                    <ul class="list">
                        <li>${guidance.repeatTestingGuidance()}</li>
                        <li>${guidance.benchmarkNotes()}</li>
                    </ul>
                </section>

                @if (profile != null)
                    <section class="card">
                        <p class="card__label">State reference context</p>
                        <h2 class="section__title">${profile.primaryReferenceLabel()}</h2>
                        <p class="checker-block__hint">${profile.summary()}</p>
                        <ul class="list">
                            @for (var line : profile.benchmarks())
                                <li>${line.label()}: ${line.benchmarkDisplay()} (${line.note()})</li>
                            @endfor
                        </ul>
                    </section>
                @endif

                <section class="card">
                    <p class="card__label">Quick benchmark check</p>
                    <h2 class="section__title">Run a seeded state comparison</h2>
                    <form class="select-cluster" method="get" action="/private-well-result/${guidance.stateCode()}">
                        <label class="select-field">
                            <span class="select-field__label">Analyte code</span>
                            <input type="text" name="analyteCode" value="PFOA">
                        </label>
                        <label class="select-field">
                            <span class="select-field__label">Measured value</span>
                            <input type="number" step="0.01" min="0" name="value" value="12">
                        </label>
                        <label class="select-field">
                            <span class="select-field__label">Unit</span>
                            <select name="unit">
                                <option value="ppt" selected="selected">ppt</option>
                                <option value="ppb">ppb</option>
                                <option value="ng/L">ng/L</option>
                                <option value="ug/L">ug/L</option>
                            </select>
                        </label>
                        <label class="select-field">
                            <span class="select-field__label">Current filter</span>
                            <select name="currentFilterStatus">
                                <option value="NONE" selected="selected">No current filter</option>
                                <option value="CERTIFIED_POU">Certified point-of-use</option>
                                <option value="UNCERTIFIED">Uncertified or unclear</option>
                            </select>
                        </label>
                        <div class="button-row">
                            <button class="button button--primary" type="submit">Run state comparison</button>
                        </div>
                    </form>
                </section>

                <section class="card">
                    <p class="card__label">Batch benchmark check</p>
                    <h2 class="section__title">Compare multiple PFAS lines at once</h2>
                    <form class="stack" method="get" action="/private-well-result/${guidance.stateCode()}">
                        <label class="select-field">
                            <span class="select-field__label">Batch input</span>
                            <textarea name="batchInput" rows="4">PFOA=12ppt;PFOS=3ppt</textarea>
                        </label>
                        <label class="select-field">
                            <span class="select-field__label">Current filter</span>
                            <select name="currentFilterStatus">
                                <option value="NONE" selected="selected">No current filter</option>
                                <option value="CERTIFIED_POU">Certified point-of-use</option>
                                <option value="UNCERTIFIED">Uncertified or unclear</option>
                            </select>
                        </label>
                        <div class="button-row">
                            <button class="button button--secondary" type="submit">Run batch comparison</button>
                        </div>
                    </form>
                </section>
            </div>

            <aside class="stack">
                <section class="rail-card">
                    <h3 class="rail-card__title">Official links</h3>
                    <div class="button-row">
                        <a class="button button--secondary" href="${guidance.pfasGuidanceUrl()}">PFAS guidance</a>
                        <a class="button button--secondary" href="${guidance.samplingGuidanceUrl()}">Sampling guidance</a>
                    </div>
                </section>

                <section class="rail-card">
                    <h3 class="rail-card__title">Sources</h3>
                    <div class="source-list">
                        @for(var source : sources)
                            <article class="source-item">
                                <div class="source-item__meta">${source.organization()}</div>
                                <div class="source-item__title">${source.title()}</div>
                                <div class="source-item__url">${source.url()}</div>
                            </article>
                        @endfor
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
