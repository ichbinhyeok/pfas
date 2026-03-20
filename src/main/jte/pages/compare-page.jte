@import java.util.List
@import com.example.pfas.filter.FilterCatalogItem
@import com.example.pfas.source.SourceDocument
@import com.example.pfas.web.ComparePage
@import com.example.pfas.web.ComparePageMetrics
@import com.example.pfas.web.GuidePage
@import com.example.pfas.web.GuideSystemExample
@import com.example.pfas.web.PresentationText
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param ComparePage page
@param ComparePageMetrics metrics
@param List<SourceDocument> compareSources
@param List<GuideSystemExample> relatedSystems
@param List<FilterCatalogItem> relatedProducts
@param List<GuidePage> relatedGuides
@param List<GuidePage> allGuides
@param boolean pageIndexable

@template.layout.base(
    pageTitle = page.title(),
    pageDescription = page.lede(),
    pageCanonicalUrl = siteBaseUrl + "/compare/" + page.slug(),
    pageIndexable = pageIndexable,
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
                @if(!relatedProducts.isEmpty())
                    <a class="button button--secondary" href="#compare-product-lane">Open compare lane</a>
                @endif
            </div>
        </div>

        @template.fragments.publicationStrip(
            lastVerified = page.lastVerifiedDate(),
            scopeLabel = "Dedicated compare page",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )

        <div class="dossier-strip">
            <article class="dossier-cell">
                <span class="dossier-cell__label">Query intent</span>
                <span class="dossier-cell__value">${page.queryIntent()}</span>
                <span class="dossier-cell__copy">Built to resolve a high-intent comparison query with real records.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Linked products</span>
                <span class="dossier-cell__value">${metrics.productCount()}</span>
                <span class="dossier-cell__copy">Filtered to models already normalized in the engine.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Upfront band</span>
                <span class="dossier-cell__value">${metrics.upfrontBand()}</span>
                <span class="dossier-cell__copy">Headline cost is shown, but never alone.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Annualized band</span>
                <span class="dossier-cell__value">${metrics.annualizedBand()}</span>
                <span class="dossier-cell__copy">Recurring burden is normalized where the engine has usable inputs.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Source set</span>
                <span class="dossier-cell__value">${compareSources.size()} records</span>
                <span class="dossier-cell__copy">Official guidance, listings, performance PDFs, and product records.</span>
            </article>
        </div>

        <div class="result-grid">
            <div class="stack">
                <section class="card card--hero next-action">
                    <span class="next-action__code">Compare next action</span>
                    <div>
                        <p class="card__label">Comparison posture</p>
                        <h2 class="next-action__title">${page.nextActionTitle()}</h2>
                    </div>
                    <p class="next-action__summary">${page.nextActionSummary()}</p>
                </section>

                <section class="card card--hero lane-card">
                    <span class="next-action__code">Comparison metrics</span>
                    <div class="lane-card__grid">
                        <article class="lane-card__cell">
                            <p class="card__label">Product count</p>
                            <div class="lane-card__value">${metrics.productCount()}</div>
                            <p class="card__copy">Only normalized products tied to this compare thesis are shown.</p>
                        </article>
                        <article class="lane-card__cell">
                            <p class="card__label">Utility examples</p>
                            <div class="lane-card__value">${metrics.utilityExampleCount()}</div>
                            <p class="card__copy">Live dossiers keep the compare page tied to actual evidence routes.</p>
                        </article>
                        <article class="lane-card__cell">
                            <p class="card__label">Installation mix</p>
                            <div class="lane-card__value">${metrics.installationMix()}</div>
                            <p class="card__copy">The page compares ownership classes, not just brands.</p>
                        </article>
                    </div>
                </section>

                <section class="card">
                    <p class="card__label">Comparison axes</p>
                    <ul class="list">
                        @for(var axis : page.comparisonAxes())
                            <li>${axis}</li>
                        @endfor
                    </ul>
                </section>

                @for(var section : page.sections())
                    <section class="card">
                        <p class="card__label">Compare analysis</p>
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
                    <p class="card__label">Structured comparison</p>
                    <div class="compare-grid">
                        @for(var product : relatedProducts)
                            <article class="compare-card">
                                <div class="compare-card__top">
                                    <div>
                                        <p class="merchant-card__eyebrow">${product.brand()} / ${PresentationText.installationTypeLabel(product.installationType())}</p>
                                        <h3 class="merchant-card__title">${product.model()}</h3>
                                    </div>
                                    <span class="badge badge--info">${PresentationText.filterTypeLabel(product.filterType())}</span>
                                </div>
                                <div class="compare-card__row">
                                    <span class="compare-card__label">Standards</span>
                                    <span class="compare-card__value">${product.certBody()} ${product.standardCode()}</span>
                                </div>
                                <div class="compare-card__row">
                                    <span class="compare-card__label">Upfront</span>
                                    <span class="compare-card__value">${PresentationText.currencyLabel(product.upfrontCostUsd())}</span>
                                </div>
                                <div class="compare-card__row">
                                    <span class="compare-card__label">Annualized</span>
                                    <span class="compare-card__value">${PresentationText.annualizedMaintenanceLabel(product)}</span>
                                </div>
                                <div class="compare-card__row">
                                    <span class="compare-card__label">PFAS coverage</span>
                                    <span class="compare-card__value">${PresentationText.previewList(product.coveredPfas(), 4)}</span>
                                </div>
                                <div class="compare-card__row">
                                    <span class="compare-card__label">Merchant</span>
                                    <span class="compare-card__value">${PresentationText.merchantLabel(product)}</span>
                                </div>
                            </article>
                        @endfor
                    </div>
                </section>

                @template.fragments.productLane(
                    sectionId = "compare-product-lane",
                    eyebrow = "Merchant-routing lane",
                    title = "Official product records tied to this comparison",
                    summary = "This lane keeps the commercial click path tied to the compare thesis, the live dossier examples, and the exact normalized product records.",
                    sourcePage = "/compare/" + page.slug(),
                    routeType = "compare",
                    ctaSlot = "compare_product_lane",
                    products = relatedProducts
                )

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
            </div>

            <aside class="stack">
                <section class="rail-card">
                    <h2 class="rail-card__title">Evidence basis</h2>
                    <ul class="list">
                        @for(var item : page.evidenceHighlights())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">Target queries</h2>
                    <ul class="list">
                        @for(var query : page.targetQueries())
                            <li>${query}</li>
                        @endfor
                    </ul>
                </section>

                @if(!relatedSystems.isEmpty())
                    <section class="rail-card">
                        <h2 class="rail-card__title">Live utility examples</h2>
                        <div class="source-list">
                            @for(var example : relatedSystems)
                                <a class="source-item" href="/public-water/${example.system().pwsid()}">
                                    <div class="source-item__meta">${example.system().stateCode()} / ${example.system().pwsid()}</div>
                                    <div class="source-item__title">${example.system().pwsName()}</div>
                                    <div class="source-item__url">${PresentationText.benchmarkRelationLabel(example.result().meta().benchmarkRelation())} / ${example.result().nextAction().title()}</div>
                                </a>
                            @endfor
                        </div>
                    </section>
                @endif

                <section class="rail-card">
                    <h2 class="rail-card__title">Primary source ledger</h2>
                    <div class="source-list">
                        @for(var source : compareSources)
                            <a class="source-item" href="${source.url()}">
                                <div class="source-item__meta">Tier ${source.trustTier()} / ${source.organization()}</div>
                                <div class="source-item__title">${source.title()}</div>
                                <div class="source-item__url">${source.url()}</div>
                            </a>
                        @endfor
                    </div>
                </section>

                @if(!relatedGuides.isEmpty())
                    <section class="rail-card">
                        <h2 class="rail-card__title">Related guides</h2>
                        <div class="source-list">
                            @for(var guide : relatedGuides)
                                <a class="source-item" href="/guides/${guide.slug()}">
                                    <div class="source-item__meta">${guide.eyebrow()}</div>
                                    <div class="source-item__title">${guide.title()}</div>
                                </a>
                            @endfor
                        </div>
                    </section>
                @endif

                <section class="rail-card">
                    <h2 class="rail-card__title">All guides</h2>
                    <div class="source-list">
                        @for(var guide : allGuides)
                            <a class="source-item" href="/guides/${guide.slug()}">
                                <div class="source-item__meta">${guide.eyebrow()}</div>
                                <div class="source-item__title">${guide.title()}</div>
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
