@import java.util.List
@import com.example.pfas.filter.FilterCatalogItem
@import com.example.pfas.web.PresentationText
@param String sectionId
@param String eyebrow
@param String title
@param String summary
@param String sourcePage
@param String routeType
@param String ctaSlot
@param List<FilterCatalogItem> products

@if(products != null && !products.isEmpty())
    <section class="card" id="${sectionId}">
        <div class="section__header">
            <div>
                <p class="card__label">${eyebrow}</p>
                <h2 class="card__title">${title}</h2>
            </div>
            <p class="card__copy lane-summary">${summary}</p>
        </div>
        <div class="merchant-grid">
            @for(var product : products)
                <article class="merchant-card">
                    <div class="merchant-card__top">
                        <div>
                            <p class="merchant-card__eyebrow">${product.brand()} / ${PresentationText.installationTypeLabel(product.installationType())}</p>
                            <h3 class="merchant-card__title">${product.model()}</h3>
                        </div>
                        <span class="badge badge--info">${PresentationText.filterTypeLabel(product.filterType())}</span>
                    </div>
                    <div class="merchant-card__metrics">
                        <div>
                            <span class="merchant-card__metric-label">Upfront</span>
                            <span class="merchant-card__metric-value">${PresentationText.currencyLabel(product.upfrontCostUsd())}</span>
                        </div>
                        <div>
                            <span class="merchant-card__metric-label">Annualized</span>
                            <span class="merchant-card__metric-value">${PresentationText.annualizedMaintenanceLabel(product)}</span>
                        </div>
                    </div>
                    <p class="merchant-card__copy">${product.certBody()} ${product.standardCode()} / ${product.claimNames().size()} mapped claims</p>
                    <p class="merchant-card__copy">PFAS coverage preview: ${PresentationText.previewList(product.coveredPfas(), 4)}</p>
                    <p class="merchant-card__copy">${PresentationText.cadenceLabel(product.replacementCadenceMonths())} / Cost confidence ${PresentationText.confidenceLabel(product.costConfidence())}</p>
                    <div class="merchant-card__advice">
                        <div class="merchant-card__stack">
                            <span class="merchant-card__subhead">Best for</span>
                            <p class="merchant-card__copy">${PresentationText.bestForLabel(product)}</p>
                        </div>
                        <div class="merchant-card__stack">
                            <span class="merchant-card__subhead">Not for</span>
                            <p class="merchant-card__copy">${PresentationText.notForLabel(product)}</p>
                        </div>
                        <div class="merchant-card__stack">
                            <span class="merchant-card__subhead">Seller choice</span>
                            <p class="merchant-card__copy">${PresentationText.sellerChoiceNote(product)}</p>
                        </div>
                        <div class="merchant-card__stack">
                            <span class="merchant-card__subhead">Pros</span>
                            <ul class="merchant-card__list">
                                @for(var item : PresentationText.productPros(product))
                                    <li>${item}</li>
                                @endfor
                            </ul>
                        </div>
                        <div class="merchant-card__stack">
                            <span class="merchant-card__subhead">Constraints</span>
                            <ul class="merchant-card__list">
                                @for(var item : PresentationText.productConstraints(product))
                                    <li>${item}</li>
                                @endfor
                            </ul>
                        </div>
                    </div>
                    <div class="button-row button-row--tight">
                        <a
                            class="button button--primary"
                            href="${product.listingUrl()}"
                            data-merchant-track="true"
                            data-product-id="${product.productId()}"
                            data-merchant="${PresentationText.merchantLabel(product)}"
                            data-cta-slot="${ctaSlot}"
                            data-source-page="${sourcePage}"
                            data-route-type="${routeType}"
                            data-target-url="${product.listingUrl()}"
                        >Open ${PresentationText.merchantLabel(product)} record</a>
                    </div>
                </article>
            @endfor
        </div>
    </section>
@endif
