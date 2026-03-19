@import java.util.List
@import com.example.pfas.source.SourceDocument
@import com.example.pfas.web.GuidePage
@import com.example.pfas.web.GuideSection
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param GuidePage page
@param List<GuidePage> allGuides
@param List<SourceDocument> guideSources

@template.layout.base(
    pageTitle = page.title(),
    pageDescription = page.lede(),
    pageCanonicalUrl = siteBaseUrl + "/guides/" + page.slug(),
    pageIndexable = true,
    content = @`
<section class="result-shell">
    <div class="shell">
        <div class="result-header">
            <div>
                <span class="eyebrow">${page.eyebrow()}</span>
                <h1 class="result-header__title">${page.title()}</h1>
                <p class="hero__lede">${page.lede()}</p>
            </div>
            <div class="button-row">
                <a class="button button--primary" href="${page.primaryHref()}">${page.primaryLabel()}</a>
                <a class="button button--secondary" href="${page.secondaryHref()}">${page.secondaryLabel()}</a>
            </div>
        </div>

        @template.fragments.publicationStrip(
            lastVerified = page.lastVerifiedDate(),
            scopeLabel = "Decision-intent guide",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )

        <div class="dossier-strip">
            <article class="dossier-cell">
                <span class="dossier-cell__label">Guide type</span>
                <span class="dossier-cell__value">Manual decision guide</span>
                <span class="dossier-cell__copy">Curated for high-intent PFAS routing questions.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Evidence basis</span>
                <span class="dossier-cell__value">${guideSources.size()} linked source records</span>
                <span class="dossier-cell__copy">Official guidance, utility documents, listings, or product records.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Guide posture</span>
                <span class="dossier-cell__value">Action-first</span>
                <span class="dossier-cell__copy">No safe/unsafe claim. No reviewer fiction. No generic roundup logic.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Verification</span>
                <span class="dossier-cell__value">${page.lastVerifiedDate()}</span>
                <span class="dossier-cell__copy">Guide copy is tied to the linked source set below.</span>
            </article>
        </div>

        <div class="result-grid">
            <div class="stack">
                <section class="card card--hero next-action">
                    <span class="next-action__code">Guide next action</span>
                    <div>
                        <p class="card__label">Next action</p>
                        <h2 class="next-action__title">${page.nextActionTitle()}</h2>
                    </div>
                    <p class="next-action__summary">${page.nextActionSummary()}</p>
                </section>

                @for(var section : page.sections())
                    <section class="card">
                        <p class="card__label">Guide analysis</p>
                        <h2 class="card__title">${section.title()}</h2>
                        @if(section.summary() != null && !section.summary().isBlank())
                            <p class="card__copy">${section.summary()}</p>
                        @endif
                        @for(var paragraph : section.paragraphs())
                            <p class="card__copy">${paragraph}</p>
                        @endfor
                        @if(section.bullets() != null && !section.bullets().isEmpty())
                            <ul class="list">
                                @for(var bullet : section.bullets())
                                    <li>${bullet}</li>
                                @endfor
                            </ul>
                        @endif
                    </section>
                @endfor

                <section class="card">
                    <p class="card__label">Why this</p>
                    <ul class="list">
                        @for(var item : page.whyThis())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>

                <section class="card">
                    <p class="card__label">What this does not tell you</p>
                    <ul class="list">
                        @for(var item : page.whatThisDoesNotTellYou())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>

                <section class="card">
                    <p class="card__label">How this guide was built</p>
                    <ul class="list">
                        <li>Manual editorial synthesis over linked official and listing records.</li>
                        <li>Routing logic stays aligned with the engine's decision table and source policy.</li>
                        <li>Commercial records are used only for product, cost, or maintenance context, not household risk truth.</li>
                        <li>No external reviewer is claimed on this build.</li>
                    </ul>
                </section>
            </div>

            <aside class="stack">
                <section class="rail-card">
                    <h2 class="rail-card__title">Checklist</h2>
                    <ul class="list">
                        @for(var item : page.checklist())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">Evidence basis</h2>
                    <ul class="list">
                        @for(var item : page.evidenceHighlights())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">Primary source ledger</h2>
                    <div class="source-list">
                        @for(var source : guideSources)
                            <a class="source-item" href="${source.url()}">
                                <div class="source-item__meta">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="source-item__title">${source.title()}</div>
                                <div class="source-item__url">${source.url()}</div>
                            </a>
                        @endfor
                    </div>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">Related guides</h2>
                    <div class="source-list">
                        @for(var guide : allGuides)
                            @if(!guide.slug().equals(page.slug()))
                                <a class="source-item" href="/guides/${guide.slug()}">
                                    <div class="source-item__meta">${guide.eyebrow()}</div>
                                    <div class="source-item__title">${guide.title()}</div>
                                </a>
                            @endif
                        @endfor
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
