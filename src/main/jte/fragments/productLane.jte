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
@param String routeCode
@param String benchmarkRelation
@param String unlockState
@param String nextActionCode
@param List<FilterCatalogItem> products

@if(products != null && !products.isEmpty())
    <section class="surface-panel-strong" id="${sectionId}">
        <div class="grid gap-6 p-6 md:p-8">
            <div class="grid gap-5 xl:grid-cols-[minmax(0,0.62fr)_minmax(0,1.38fr)] xl:items-end">
                <div class="space-y-3">
                    <span class="inline-flex rounded-full bg-neutral px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-neutral-content">${eyebrow}</span>
                    <h2 class="max-w-3xl text-3xl font-semibold tracking-[-0.04em] text-base-content">${title}</h2>
                </div>
                <div class="space-y-3 xl:pl-8 xl:border-l xl:border-base-300/70">
                    <p class="max-w-2xl text-sm leading-7 text-base-content/62">${summary}</p>
                    <div class="space-y-2">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-primary">Commercial path note</span>
                        <p class="text-sm leading-7 text-base-content/72">Links in this lane go to official product or listing records used in the normalized catalog. Ranking stays tied to certification scope, cadence, cost, and evidence handling rather than merchant preference.</p>
                        <p class="text-sm leading-7 text-base-content/58">Affiliate relationships may support the project. They do not change the ordering logic, which stays bound to the visible decision path and claim-level record set.</p>
                    </div>
                </div>
            </div>

            <div class="overflow-hidden rounded-[1.2rem] border border-base-300/70 bg-base-100">
                @for(var product : products.subList(0, Math.min(products.size(), 2)))
                    <article class="row-link px-5 py-5 ${product != products.get(0) ? "border-t border-base-300/70" : ""}">
                        <div class="grid gap-5 xl:grid-cols-[minmax(0,1.05fr)_12rem_16rem] xl:items-start">
                            <div class="space-y-3">
                                <div class="flex flex-wrap items-center gap-3">
                                    <p class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">${product.brand()} / ${PresentationText.installationTypeLabel(product.installationType())}</p>
                                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-primary">${PresentationText.filterTypeLabel(product.filterType())}</span>
                                </div>
                                <h3 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">${product.model()}</h3>
                                <p class="text-sm leading-7 text-base-content/62">${product.certBody()} ${product.standardCode()} / PFAS coverage ${PresentationText.previewList(product.coveredPfas(), 4)}</p>
                                <p class="text-sm leading-7 text-base-content/72"><strong class="font-semibold text-base-content">Best for</strong> ${PresentationText.bestForLabel(product)}</p>
                                <p class="text-sm leading-6 text-base-content/58"><strong class="font-semibold text-base-content">Seller choice</strong> ${PresentationText.sellerChoiceNote(product)}</p>
                            </div>

                            <div class="ledger-grid rounded-[0.95rem]">
                                <div class="px-4 py-4">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Upfront</div>
                                    <div class="mt-2 text-sm font-semibold text-base-content">${PresentationText.currencyLabel(product.upfrontCostUsd())}</div>
                                </div>
                                <div class="px-4 py-4">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Annualized</div>
                                    <div class="mt-2 text-sm font-semibold text-base-content">${PresentationText.annualizedMaintenanceLabel(product)}</div>
                                </div>
                                <div class="px-4 py-4">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Burden</div>
                                    <div class="mt-2 text-sm font-semibold text-base-content">${PresentationText.maintenanceBurdenLabel(product)}</div>
                                </div>
                            </div>

                            <div class="space-y-4">
                                <div class="text-sm leading-7 text-base-content/72">
                                    <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Next step</span>
                                    <p class="mt-3">${PresentationText.nextStepLabel(product)}</p>
                                </div>
                                <a
                                    class="btn btn-primary h-11 w-full rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92"
                                    href="${product.listingUrl()}"
                                    data-merchant-track="true"
                                    data-product-id="${product.productId()}"
                                    data-merchant="${PresentationText.merchantLabel(product)}"
                                    data-cta-slot="${ctaSlot}"
                                    data-source-page="${sourcePage}"
                                    data-route-type="${routeType}"
                                    data-route-code="${routeCode}"
                                    data-benchmark-relation="${benchmarkRelation}"
                                    data-unlock-state="${unlockState}"
                                    data-next-action-code="${nextActionCode}"
                                    data-target-url="${product.listingUrl()}"
                                >Open ${PresentationText.merchantLabel(product)} record</a>

                                <div class="collapse collapse-arrow rounded-[1rem] border border-base-300/70 bg-base-200/34">
                                    <input type="checkbox">
                                    <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">Decision details</div>
                                    <div class="collapse-content">
                                        <div class="grid gap-4 sm:grid-cols-2">
                                            <div>
                                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Pros</div>
                                                <ul class="mt-3 space-y-2 text-sm leading-6 text-base-content/72">
                                                    @for(var item : PresentationText.productPros(product))
                                                        <li>${item}</li>
                                                    @endfor
                                                </ul>
                                            </div>
                                            <div>
                                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Constraints</div>
                                                <ul class="mt-3 space-y-2 text-sm leading-6 text-base-content/72">
                                                    @for(var item : PresentationText.productConstraints(product))
                                                        <li>${item}</li>
                                                    @endfor
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="surface-muted mt-4 px-4 py-4 text-sm leading-7 text-base-content/68">
                                            <strong class="font-semibold text-base-content">Not for</strong> ${PresentationText.notForLabel(product)}<br>
                                            <strong class="font-semibold text-base-content">Cadence and confidence</strong> ${PresentationText.cadenceLabel(product.replacementCadenceMonths())} / Cost confidence ${PresentationText.confidenceLabel(product.costConfidence())}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </article>
                @endfor
            </div>

            @if(products.size() > 2)
                <div class="collapse collapse-arrow rounded-[1.25rem] border border-base-300/70 bg-base-200/36">
                    <input type="checkbox">
                    <div class="collapse-title pr-12 text-base font-semibold tracking-[-0.02em] text-base-content">More certified options (${products.size() - 2})</div>
                    <div class="collapse-content">
                        <div class="overflow-hidden rounded-[1rem] border border-base-300/70 bg-base-100 pt-2">
                            @for(var product : products.subList(2, products.size()))
                                <article class="grid gap-4 px-5 py-5 xl:grid-cols-[minmax(0,1fr)_12rem_14rem] xl:items-start ${product != products.get(2) ? "border-t border-base-300/70" : ""}">
                                    <div class="space-y-3">
                                        <div class="flex flex-wrap items-center gap-3">
                                            <p class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">${product.brand()} / ${PresentationText.installationTypeLabel(product.installationType())}</p>
                                            <span class="badge badge-outline border-base-300 bg-base-100 text-base-content/58">${PresentationText.filterTypeLabel(product.filterType())}</span>
                                        </div>
                                        <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">${product.model()}</h3>
                                        <p class="text-sm leading-7 text-base-content/62">${PresentationText.bestForLabel(product)}</p>
                                    </div>
                                    <div class="rounded-[0.95rem] border border-base-300/70 bg-base-200/30 px-4 py-4 text-sm leading-6 text-base-content/72">
                                        ${PresentationText.currencyLabel(product.upfrontCostUsd())} upfront<br>
                                        ${PresentationText.annualizedMaintenanceLabel(product)}
                                    </div>
                                    <div class="flex xl:justify-end">
                                        <a
                                            class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200"
                                            href="${product.listingUrl()}"
                                            data-merchant-track="true"
                                            data-product-id="${product.productId()}"
                                            data-merchant="${PresentationText.merchantLabel(product)}"
                                            data-cta-slot="${ctaSlot}"
                                            data-source-page="${sourcePage}"
                                            data-route-type="${routeType}"
                                            data-route-code="${routeCode}"
                                            data-benchmark-relation="${benchmarkRelation}"
                                            data-unlock-state="${unlockState}"
                                            data-next-action-code="${nextActionCode}"
                                            data-target-url="${product.listingUrl()}"
                                        >Open ${PresentationText.merchantLabel(product)} record</a>
                                    </div>
                                </article>
                            @endfor
                        </div>
                    </div>
                </div>
            @endif
        </div>
    </section>
@endif
