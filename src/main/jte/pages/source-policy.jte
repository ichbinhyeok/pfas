@import java.util.List
@import com.example.pfas.source.SourceDocument
@param String siteBaseUrl
@param int sourceCount
@param int stateCount
@param int publicWaterCount
@param int filterCount
@param int guideCount
@param List<SourceDocument> tier1Sources
@param List<SourceDocument> tier2Sources
@param List<SourceDocument> tier3Sources
@param List<SourceDocument> tier4Sources
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param String siteLastVerifiedDate

@template.layout.base(
    pageTitle = "PFAS source policy",
    pageDescription = "Source tiers and trust policy for the PFAS decision engine.",
    pageCanonicalUrl = siteBaseUrl + "/source-policy",
    pageIndexable = true,
    content = @`
<section class="result-shell">
    <div class="shell">
        <div class="result-header">
            <div>
                <span class="eyebrow">Source policy</span>
                <h1 class="result-header__title">The project ranks sources before it ranks products</h1>
                <p class="hero__lede">
                    Direct official evidence sits at the top. Certification directories and vendor documents only open after
                    the household path and benchmark context are already anchored.
                </p>
            </div>
            <div class="button-row">
                <a class="button button--primary" href="/methodology">Open methodology</a>
                <a class="button button--secondary" href="/checker">Open Action Checker</a>
            </div>
        </div>

        @template.fragments.publicationStrip(
            lastVerified = siteLastVerifiedDate,
            scopeLabel = "Source discipline",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )

        <div class="meta-grid">
            <article class="meta-tile">
                <span class="meta-tile__label">Tracked sources</span>
                <span class="meta-tile__value">${sourceCount}</span>
                <span class="meta-tile__copy">Registry-backed source documents.</span>
            </article>
            <article class="meta-tile">
                <span class="meta-tile__label">State routes</span>
                <span class="meta-tile__value">${stateCount}</span>
                <span class="meta-tile__copy">State guidance seeds using official agency routes.</span>
            </article>
            <article class="meta-tile">
                <span class="meta-tile__label">Seeded dossiers</span>
                <span class="meta-tile__value">${publicWaterCount + filterCount}</span>
                <span class="meta-tile__copy">Public-water and product records currently rendered.</span>
            </article>
        </div>

        <div class="result-grid">
            <div class="stack">
                <section class="card">
                    <p class="card__label">Trust tiers</p>
                    <div class="ledger-list ledger-list--compact">
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">01</span>
                            <div>
                                <h3 class="ledger-item__title">Tier 1</h3>
                                <p class="ledger-item__copy">Federal agencies for rule status, program context, and high-level filter guidance.</p>
                            </div>
                        </article>
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">02</span>
                            <div>
                                <h3 class="ledger-item__title">Tier 2</h3>
                                <p class="ledger-item__copy">State agencies and utility records for direct route-specific evidence.</p>
                            </div>
                        </article>
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">03</span>
                            <div>
                                <h3 class="ledger-item__title">Tier 3</h3>
                                <p class="ledger-item__copy">Certification directories and listing systems.</p>
                            </div>
                        </article>
                        <article class="ledger-item ledger-item--compact">
                            <span class="ledger-item__index">04</span>
                            <div>
                                <h3 class="ledger-item__title">Tier 4</h3>
                                <p class="ledger-item__copy">Vendor pages for price, replacement cadence, and official model detail.</p>
                            </div>
                        </article>
                    </div>
                </section>

                <section class="card">
                    <p class="card__label">Tier 1 examples</p>
                    <div class="source-list">
                        @for(var source : tier1Sources)
                            <a class="source-item" href="${source.url()}">
                                <div class="source-item__meta">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="source-item__title">${source.title()}</div>
                            </a>
                        @endfor
                    </div>
                </section>

                <section class="card">
                    <p class="card__label">Tier 2 examples</p>
                    <div class="source-list">
                        @for(var source : tier2Sources)
                            <a class="source-item" href="${source.url()}">
                                <div class="source-item__meta">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="source-item__title">${source.title()}</div>
                            </a>
                        @endfor
                    </div>
                </section>
            </div>

            <aside class="stack">
                <section class="rail-card">
                    <h2 class="rail-card__title">Tier 3 examples</h2>
                    <div class="source-list">
                        @for(var source : tier3Sources)
                            <a class="source-item" href="${source.url()}">
                                <div class="source-item__meta">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="source-item__title">${source.title()}</div>
                            </a>
                        @endfor
                    </div>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">Tier 4 examples</h2>
                    <div class="source-list">
                        @for(var source : tier4Sources)
                            <a class="source-item" href="${source.url()}">
                                <div class="source-item__meta">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="source-item__title">${source.title()}</div>
                            </a>
                        @endfor
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
