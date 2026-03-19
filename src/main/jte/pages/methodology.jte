@param int sourceCount
@param int stateCount
@param int publicWaterCount
@param int filterCount
@param int guideCount
@param int readyStateCount
@param int blockedStateCount
@param int readyPublicWaterCount
@param int blockedPublicWaterCount
@param String siteBaseUrl

@template.layout.base(
    pageTitle = "PFAS methodology",
    pageDescription = "Methodology for source handling, normalization, decision rules, and result generation.",
    pageCanonicalUrl = siteBaseUrl + "/methodology",
    pageIndexable = true,
    content = @`
<section class="result-shell">
    <div class="shell">
        <div class="result-header">
            <div>
                <span class="eyebrow">Methodology</span>
                <h1 class="result-header__title">How the engine turns evidence into next actions</h1>
                <p class="hero__lede">
                    The project is built as a file-backed decision product. Raw sources are captured, normalized, converted into
                    decision signals, and rendered into action-first result surfaces.
                </p>
            </div>
            <div class="button-row">
                <a class="button button--primary" href="/checker">Open Action Checker</a>
                <a class="button button--secondary" href="/source-policy">Open source policy</a>
            </div>
        </div>

        @template.fragments.publicationStrip(lastVerified = "2026-03-19", scopeLabel = "Methodology and trust layer")

        <div class="meta-grid">
            <article class="meta-tile">
                <span class="meta-tile__label">Sources</span>
                <span class="meta-tile__value">${sourceCount}</span>
                <span class="meta-tile__copy">Tracked source documents in the registry.</span>
            </article>
            <article class="meta-tile">
                <span class="meta-tile__label">State routes</span>
                <span class="meta-tile__value">${stateCount}</span>
                <span class="meta-tile__copy">State guidance seeds currently in the engine.</span>
            </article>
            <article class="meta-tile">
                <span class="meta-tile__label">Public-water dossiers</span>
                <span class="meta-tile__value">${publicWaterCount}</span>
                <span class="meta-tile__copy">Seeded public-water systems with direct context.</span>
            </article>
            <article class="meta-tile">
                <span class="meta-tile__label">Readiness</span>
                <span class="meta-tile__value">${readyStateCount + readyPublicWaterCount}</span>
                <span class="meta-tile__copy">Routes currently marked ready for controlled expansion.</span>
            </article>
        </div>

        <div class="result-grid">
            <div class="stack">
                <section class="card">
                    <p class="card__label">Pipeline</p>
                    <div class="ledger-list ledger-list--compact">
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">01</span>
                            <div>
                                <h3 class="ledger-item__title">Raw capture</h3>
                                <p class="ledger-item__copy">Official pages, PDFs, notices, and listing records are captured with URLs and retrieval dates.</p>
                            </div>
                        </article>
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">02</span>
                            <div>
                                <h3 class="ledger-item__title">Normalization</h3>
                                <p class="ledger-item__copy">Facts are normalized into CSV or JSON with source ids, dates, and units.</p>
                            </div>
                        </article>
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">03</span>
                            <div>
                                <h3 class="ledger-item__title">Decision layer</h3>
                                <p class="ledger-item__copy">Deterministic rules map source type, benchmark relation, and filter state into next actions.</p>
                            </div>
                        </article>
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">04</span>
                            <div>
                                <h3 class="ledger-item__title">Result rendering</h3>
                                <p class="ledger-item__copy">SSR pages and JSON share the same typed result schema.</p>
                            </div>
                        </article>
                    </div>
                </section>

                <section class="card">
                    <p class="card__label">What the engine does</p>
                    <ul class="list">
                        <li>Routes public water and private well households differently.</li>
                        <li>Prefers direct official evidence over indirect hints.</li>
                        <li>Keeps certification, cost, and maintenance visible before a product feels like a fit.</li>
                        <li>Uses programmatic readiness checks before state or utility coverage is treated as expansion-ready.</li>
                    </ul>
                </section>

                <section class="card">
                    <p class="card__label">What the engine does not do</p>
                    <ul class="list">
                        <li>It does not label a household safe or unsafe.</li>
                        <li>It does not turn ZIP hints into exposure claims.</li>
                        <li>It does not treat certification as proof of every current regulatory benchmark.</li>
                    </ul>
                </section>
            </div>

            <aside class="stack">
                <section class="rail-card">
                    <h2 class="rail-card__title">Current operating surface</h2>
                    <ul class="list">
                        <li>${stateCount} state guidance routes</li>
                        <li>${publicWaterCount} public-water dossiers</li>
                        <li>${filterCount} filter models in the catalog</li>
                        <li>${guideCount} high-intent entry guides</li>
                    </ul>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">Readiness ledger</h2>
                    <ul class="list">
                        <li>${readyStateCount} state routes ready / ${blockedStateCount} state routes still blocked</li>
                        <li>${readyPublicWaterCount} public-water routes ready / ${blockedPublicWaterCount} public-water routes still blocked</li>
                        <li>Readiness requires source resolution, verification dates, and the correct state or utility evidence layer.</li>
                    </ul>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
