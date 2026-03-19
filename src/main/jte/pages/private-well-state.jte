@import java.util.List
@import com.example.pfas.state.StateGuidance
@import com.example.pfas.source.SourceDocument
@param StateGuidance guidance
@param List<SourceDocument> sources

@template.layout.base(
    pageTitle = guidance.stateCode() + " private-well PFAS guide",
    pageDescription = "State-backed private-well PFAS routing page for " + guidance.stateCode() + ".",
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

        @template.fragments.publicationStrip(lastVerified = guidance.lastVerifiedDate(), scopeLabel = "Private-well state guide")

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
