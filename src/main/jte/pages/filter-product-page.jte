@import java.util.List
@import com.example.pfas.catalog.FilterProductSurface
@import com.example.pfas.commercial.CommercialSurfaceState
@import com.example.pfas.source.SourceDocument
@import com.example.pfas.web.PresentationText
@param String siteBaseUrl
@param FilterProductSurface surface
@param List<SourceDocument> sources
@param CommercialSurfaceState commercialState
@param boolean pageIndexable

@template.layout.base(
    pageTitle = surface.title(),
    pageDescription = surface.lede(),
    pageCanonicalUrl = siteBaseUrl + surface.canonicalPath(),
    pageIndexable = pageIndexable,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
                <div class="space-y-6 bg-white/[0.03] p-7 md:p-9">
                    <div class="space-y-4">
                        <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">${surface.eyebrow()}</span>
                        <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                            ${surface.product().brand()} ${surface.product().model()}
                            <span class="font-serif font-medium text-white/72">with the claim scope still explicit.</span>
                        </h1>
                        <p class="max-w-3xl text-lg leading-8 text-white/72">${surface.lede()}</p>
                    </div>

                    <div class="join join-vertical gap-3 sm:join-horizontal sm:flex-wrap">
                        <a
                            class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold hover:bg-primary/92"
                            href="${surface.product().listingUrl()}"
                            data-merchant-track="true"
                            data-product-id="${surface.product().productId()}"
                            data-merchant="${surface.merchantLabel()}"
                            data-cta-slot="filter_product_primary"
                            data-source-page="${surface.canonicalPath()}"
                            data-route-type="${surface.routeType()}"
                            data-route-code="${commercialState.code()}"
                            data-benchmark-relation=""
                            data-unlock-state="${commercialState.code()}"
                            data-next-action-code="OPEN_FILTER_PRODUCT"
                            data-target-url="${surface.product().listingUrl()}"
                        >Open ${surface.merchantLabel()} record</a>
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="${surface.brandPath()}">Open brand lane</a>
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="${surface.merchantPath()}">Open merchant lane</a>
                    </div>
                </div>

                <aside class="bg-white/[0.02] p-7 md:p-8">
                    <div class="space-y-2">
                        <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Product docket</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-white">Use this record only when the fit and ownership load already make sense.</h2>
                    </div>
                    <div class="terminal-pane mt-4 overflow-hidden">
                        <div class="terminal-stack">
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Standard line</strong><br>${surface.product().certBody()} ${surface.product().standardCode()}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Installation</strong><br>${PresentationText.installationTypeLabel(surface.product().installationType())}</article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78"><strong class="font-semibold text-white">Merchant path</strong><br>${surface.merchantLabel()}</article>
                        </div>
                    </div>
                </aside>
            </div>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        <div class="ledger-grid shadow-[var(--shadow-soft)] md:grid-cols-2 xl:grid-cols-4">
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Upfront</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${PresentationText.currencyLabel(surface.product().upfrontCostUsd())}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Normalized product pricing.</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Annualized</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${PresentationText.annualizedMaintenanceLabel(surface.product())}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">${PresentationText.maintenanceBurdenLabel(surface.product())} maintenance burden.</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Best for</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${PresentationText.bestForLabel(surface.product())}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">${PresentationText.nextStepLabel(surface.product())}</div>
            </article>
            <article class="px-4 py-4 md:px-6 md:py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Price observed</div>
                <div class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content md:text-xl">${surface.lastVerifiedDate()}</div>
                <div class="mt-3 text-sm leading-6 text-base-content/58">Confidence ${surface.product().costConfidence() == null ? "unknown" : surface.product().costConfidence()}</div>
            </article>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell space-y-5">
        @template.fragments.commercialState(
            eyebrow = "Commercial state",
            state = commercialState
        )
        @template.fragments.routeActions(
            routeId = "filter-product:" + surface.routeKey(),
            routeTitle = surface.title(),
            routeSummary = commercialState.summary(),
            routeUrl = surface.canonicalPath()
        )
        <section class="decision-shelf">
            <div class="grid gap-px bg-base-300/70 lg:grid-cols-[minmax(0,1.02fr)_minmax(0,0.98fr)]">
                <div class="bg-base-100 px-6 py-6">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Buy gate</span>
                    <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">Open the seller record only after this model still fits the route.</h2>
                    <p class="mt-3 max-w-2xl text-sm leading-7 text-base-content/68">${surface.lede()}</p>
                </div>
                <div class="bg-base-200/56 px-6 py-6">
                    <div class="space-y-5">
                        <article>
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/46">Buy if</span>
                            <p class="mt-3 text-sm leading-7 text-base-content/78">${PresentationText.bestForLabel(surface.product())}</p>
                        </article>
                        <article>
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/46">Do not buy if</span>
                            <p class="mt-3 text-sm leading-7 text-base-content/72">${PresentationText.notForLabel(surface.product())}</p>
                        </article>
                    </div>
                </div>
            </div>
            <div class="decision-rule-grid">
                <article class="px-6 py-5">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Ownership load</span>
                    <p class="mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content">${PresentationText.currencyLabel(surface.product().upfrontCostUsd())} upfront</p>
                    <p class="mt-2 text-sm leading-6 text-base-content/62">${PresentationText.annualizedMaintenanceLabel(surface.product())} / ${PresentationText.maintenanceBurdenLabel(surface.product())} burden</p>
                </article>
                <article class="px-6 py-5">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Claim line</span>
                    <p class="mt-3 text-sm leading-7 text-base-content/72">${surface.product().certBody()} ${surface.product().standardCode()} / PFAS coverage ${PresentationText.previewList(surface.product().coveredPfas(), 4)}</p>
                </article>
                <article class="px-6 py-5">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Seller choice</span>
                    <p class="mt-3 text-sm leading-7 text-base-content/72">${PresentationText.sellerChoiceNote(surface.product())}</p>
                </article>
            </div>
        </section>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="surface-panel overflow-hidden">
                    <div class="grid gap-px bg-base-300/70 lg:grid-cols-2">
                        <article class="bg-base-100 px-6 py-5">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Decision readout</span>
                            <ul class="mt-4 space-y-3 text-sm leading-7 text-base-content/72">
                                @for(var item : surface.highlights())
                                    <li>${item}</li>
                                @endfor
                            </ul>
                        </article>
                        <article class="bg-base-200/52 px-6 py-5">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Who should skip</span>
                            <p class="mt-4 text-sm leading-7 text-base-content/72">${PresentationText.notForLabel(surface.product())}</p>
                            <div class="mt-4 border-t border-base-300/70 pt-4 text-sm leading-7 text-base-content/68">
                                <strong class="font-semibold text-base-content">Seller choice</strong> ${PresentationText.sellerChoiceNote(surface.product())}
                            </div>
                        </article>
                    </div>
                </section>

                @template.fragments.productLane(
                    sectionId = "related-product-lane",
                    eyebrow = "Related product lane",
                    title = "Nearby records in the same normalized catalog",
                    summary = "These records stay adjacent to the current product so the user can inspect neighboring options without falling into a generic roundup.",
                    sourcePage = surface.canonicalPath(),
                    routeType = surface.routeType(),
                    ctaSlot = "filter_product_related_lane",
                    routeCode = commercialState.code(),
                    benchmarkRelation = "",
                    unlockState = commercialState.code(),
                    nextActionCode = "OPEN_FILTER_PRODUCT",
                    products = surface.relatedProducts()
                )

                <section class="surface-panel overflow-hidden">
                    <div class="gap-0 p-0">
                        <div class="border-b border-base-300/70 px-6 py-5">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Primary source ledger</span>
                            <h2 class="mt-4 text-2xl font-semibold tracking-[-0.03em] text-base-content">Primary source ledger</h2>
                        </div>
                        <div class="divide-y divide-base-300/70">
                            @for(var source : sources)
                                <a class="row-link grid gap-4 px-6 py-5 sm:grid-cols-[12rem_minmax(0,1fr)] sm:items-start" href="${source.url()}">
                                    <div>
                                        <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/60">${source.organization()}</div>
                                    </div>
                                    <div>
                                        <div class="text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                        <div class="mt-2 break-all text-sm leading-6 text-base-content/56">${source.url()}</div>
                                    </div>
                                </a>
                            @endfor
                        </div>
                    </div>
                </section>
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="surface-panel overflow-hidden">
                    <div class="px-6 py-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Related lanes</h2>
                        <p class="mt-3 text-sm leading-7 text-base-content/64">Move laterally through the catalog without losing the current product context.</p>
                    </div>
                    <div class="border-t border-base-300/70 px-6 py-5">
                        <div class="space-y-3">
                            <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${surface.brandPath()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Brand lane</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${surface.product().brand()}</div>
                            </a>
                            <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${surface.installationPath()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Installation lane</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${PresentationText.installationTypeLabel(surface.product().installationType())}</div>
                            </a>
                            <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${surface.filterTypePath()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Filter-type lane</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${PresentationText.filterTypeLabel(surface.product().filterType())}</div>
                            </a>
                            <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${surface.merchantPath()}">
                                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Merchant lane</div>
                                <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${surface.merchantLabel()}</div>
                            </a>
                        </div>
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
