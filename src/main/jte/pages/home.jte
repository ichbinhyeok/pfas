@import com.example.pfas.water.PublicWaterSystem
@import com.example.pfas.web.GuidePage
@import static com.example.pfas.web.PresentationText.sourceWaterTypeLabel
@import static com.example.pfas.web.PresentationText.systemTypeLabel
@param String siteBaseUrl
@param java.util.List<PublicWaterSystem> systems
@param java.util.List<GuidePage> guides

@template.layout.base(
    pageTitle = "PFAS Decision Engine",
    pageDescription = "Official-data-first PFAS decision interface for public water and private well workflows.",
    pageCanonicalUrl = siteBaseUrl + "/",
    pageIndexable = true,
    content = @`
<section class="hero">
    <div class="shell">
        <span class="eyebrow">Utility-grade decision product</span>
        <div class="hero__grid">
            <div>
                <h1 class="hero__title">
                    Official records,
                    <span class="hero__title-accent">interpreted like a civic dossier.</span>
                </h1>
                <p class="hero__lede">
                    This should feel less like a glossy filter site and more like a premium interpretation engine built on
                    public evidence, benchmark logic, and claim-level certification records.
                </p>
                <div class="hero__actions">
                    <a class="button button--primary" href="/checker">Open Action Checker</a>
                    <a class="button button--secondary" href="/methodology">Open methodology</a>
                </div>
                <div class="meta-grid">
                    <article class="meta-tile">
                        <span class="meta-tile__label">Evidence stack</span>
                        <span class="meta-tile__value">Official sources only</span>
                        <span class="meta-tile__copy">EPA, state guidance, utility documents, and listing records.</span>
                    </article>
                    <article class="meta-tile">
                        <span class="meta-tile__label">Decision posture</span>
                        <span class="meta-tile__value">Interpret first</span>
                        <span class="meta-tile__copy">Direct data is reviewed before any comparison flow opens.</span>
                    </article>
                    <article class="meta-tile">
                        <span class="meta-tile__label">Product bias</span>
                        <span class="meta-tile__value">Constrained</span>
                        <span class="meta-tile__copy">Point-of-use comes before whole-house escalation.</span>
                    </article>
                </div>
                <div class="dossier-strip">
                    <article class="dossier-cell">
                        <span class="dossier-cell__label">Federal</span>
                        <span class="dossier-cell__value">Rule context</span>
                        <span class="dossier-cell__copy">Regulatory status is interpreted, not dramatized.</span>
                    </article>
                    <article class="dossier-cell">
                        <span class="dossier-cell__label">State</span>
                        <span class="dossier-cell__value">Guidance layer</span>
                        <span class="dossier-cell__copy">Private-well routing stays state-specific.</span>
                    </article>
                    <article class="dossier-cell">
                        <span class="dossier-cell__label">Utility</span>
                        <span class="dossier-cell__value">Direct record</span>
                        <span class="dossier-cell__copy">Public-water flows begin with official system evidence.</span>
                    </article>
                    <article class="dossier-cell">
                        <span class="dossier-cell__label">Listing</span>
                        <span class="dossier-cell__value">Claim check</span>
                        <span class="dossier-cell__copy">Products only appear when claim-level proof exists.</span>
                    </article>
                </div>
            </div>
            <aside class="hero__panel">
                <p class="hero__panel-label">Interface mode</p>
                <div class="hero__panel-value">Civic dossier</div>
                <p class="hero__panel-copy">
                    The visual direction is no longer generic premium SaaS. It is meant to read like a specialized public
                    evidence console with editorial restraint.
                </p>
                <ul class="hero__panel-list">
                    <li>Less decorative softness, more structured authority.</li>
                    <li>Stronger metadata, calmer surfaces, sharper type contrast.</li>
                    <li>Consistency stays, but sameness is reduced.</li>
                </ul>
            </aside>
        </div>
    </div>
</section>

<section class="section">
    <div class="shell">
        @template.fragments.publicationStrip(lastVerified = "2026-03-19", scopeLabel = "Decision engine homepage")
    </div>
</section>

<section class="section">
    <div class="shell">
        <div class="section__header">
            <div>
                <p class="section__label">Interpretation method</p>
                <h2 class="section__title">How the engine reads a case</h2>
                <p class="section__copy">The product should feel like a specialized reading room for public evidence.</p>
            </div>
        </div>
        <div class="ledger-list">
            <article class="ledger-item">
                <span class="ledger-item__index">01</span>
                <div>
                    <h3 class="ledger-item__title">Collect the direct record</h3>
                    <p class="ledger-item__copy">Utility documents, state guidance, or lab results outrank broad PFAS maps and vague geography.</p>
                </div>
            </article>
            <article class="ledger-item">
                <span class="ledger-item__index">02</span>
                <div>
                    <h3 class="ledger-item__title">Normalize against explicit benchmarks</h3>
                    <p class="ledger-item__copy">Threshold language is registry-backed so the same rule can serve JSON, pages, and future comparisons.</p>
                </div>
            </article>
            <article class="ledger-item">
                <span class="ledger-item__index">03</span>
                <div>
                    <h3 class="ledger-item__title">Open a constrained product layer</h3>
                    <p class="ledger-item__copy">Point-of-use stays first. Whole-house remains a separate, justified escalation.</p>
                </div>
            </article>
        </div>
    </div>
</section>

<section class="section">
    <div class="shell">
        <div class="section__header">
            <div>
                <p class="section__label">Entry pages</p>
                <h2 class="section__title">High-intent guides before scaled expansion</h2>
                <p class="section__copy">These pages are meant to solve real routing questions before any broad coverage play opens.</p>
            </div>
        </div>
        <div class="systems-grid">
            @for (var guide : guides)
                <article class="card">
                    <p class="card__label">${guide.eyebrow()}</p>
                    <h3 class="card__title">${guide.title()}</h3>
                    <p class="card__copy">${guide.lede()}</p>
                    <div class="chip-row">
                        <span class="chip">Last verified ${guide.lastVerifiedDate()}</span>
                        <span class="chip">Decision-intent</span>
                    </div>
                    <div class="button-row">
                        <a class="button button--primary" href="/guides/${guide.slug()}">Open guide</a>
                        <a class="button button--secondary" href="${guide.primaryHref()}">${guide.primaryLabel()}</a>
                    </div>
                </article>
            @endfor
        </div>
    </div>
</section>

<section class="section">
    <div class="shell">
        <div class="section__header">
            <div>
                <p class="section__label">Seeded systems</p>
                <h2 class="section__title">Current public-water dossiers</h2>
                <p class="section__copy">Seeded systems are rendered as evidence-backed routes, not generic location pages.</p>
            </div>
        </div>
        <div class="systems-grid">
            @for (var system : systems)
                <article class="card">
                    <p class="card__label">${system.stateCode()} public water</p>
                    <h3 class="card__title">${system.pwsName()}</h3>
                    <div class="card__meta-row">
                        <span class="chip">PWSID ${system.pwsid()}</span>
                        <span class="chip">${systemTypeLabel(system.systemType())}</span>
                    </div>
                    <p class="card__copy">
                        PWSID ${system.pwsid()} / ${systemTypeLabel(system.systemType())} / ${sourceWaterTypeLabel(system.sourceWaterType())}
                    </p>
                    <div class="chip-row">
                        <span class="chip">Official utility source</span>
                        <span class="chip">Benchmark-aware result</span>
                        <span class="chip">Typed JSON available</span>
                    </div>
                    <div class="button-row">
                        <a class="button button--primary" href="/public-water/${system.pwsid()}">Open result page</a>
                        <a class="button button--secondary" href="/internal/public-water-decision/${system.pwsid()}">Decision context</a>
                    </div>
                </article>
            @endfor
        </div>
    </div>
</section>

<section class="section">
    <div class="shell">
        <div class="section__header">
            <div>
                <p class="section__label">Trust model</p>
                <h2 class="section__title">What makes this different from PFAS content spam</h2>
            </div>
        </div>
        <div class="trust-grid">
            <div class="trust-item">
                <h3 class="trust-item__title">Registry-backed benchmarks</h3>
                <p class="trust-item__copy">Observations point to benchmark ids instead of hard-coded prose thresholds.</p>
            </div>
            <div class="trust-item">
                <h3 class="trust-item__title">Claim-level certification</h3>
                <p class="trust-item__copy">Filter options only show up when a concrete listing record and PFAS claim are captured.</p>
            </div>
            <div class="trust-item">
                <h3 class="trust-item__title">Typed result outputs</h3>
                <p class="trust-item__copy">The frontend consumes the same explicit result schema the backend emits.</p>
            </div>
        </div>
    </div>
</section>
`
)
