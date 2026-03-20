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
    <section class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8" id="${sectionId}">
        <div class="flex flex-col gap-4 border-b border-shell-border pb-6 lg:flex-row lg:items-start lg:justify-between">
            <div class="space-y-2">
                <p class="text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">${eyebrow}</p>
                <h2 class="max-w-3xl text-3xl font-semibold tracking-[-0.04em] text-slate-deep md:text-[2.2rem]">${title}</h2>
            </div>
            <p class="max-w-2xl text-sm leading-7 text-slate-muted">${summary}</p>
        </div>

        <div class="mt-6 rounded-[18px] border border-teal-deep/12 bg-teal-tint/70 px-5 py-5">
            <div class="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
                <div class="space-y-2">
                    <p class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-teal-deep">Commercial path note</p>
                    <p class="max-w-3xl text-sm leading-7 text-slate-body">Links in this lane go to official product or listing records used in the normalized catalog. Ranking stays tied to certification scope, cadence, cost, and evidence handling rather than merchant preference.</p>
                </div>
                <p class="max-w-xl text-sm leading-7 text-slate-muted">Affiliate relationships may support the project. They do not change the ordering logic, which stays bound to the visible decision path and claim-level record set.</p>
            </div>
        </div>

        <div class="mt-8 grid gap-5 xl:grid-cols-2">
            @for(var product : products)
                <article class="rounded-[20px] border border-shell-border bg-ivory px-5 py-5 shadow-quiet transition duration-150 ease-out hover:-translate-y-px hover:border-shell-border-strong">
                    <div class="flex flex-col gap-4 border-b border-shell-border pb-5">
                        <div class="flex items-start justify-between gap-3">
                            <div class="space-y-2">
                                <p class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">${product.brand()} / ${PresentationText.installationTypeLabel(product.installationType())}</p>
                                <h3 class="text-2xl font-semibold tracking-[-0.03em] text-slate-deep">${product.model()}</h3>
                            </div>
                            <span class="inline-flex rounded-full border border-teal-deep/12 bg-teal-tint/70 px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-teal-deep">${PresentationText.filterTypeLabel(product.filterType())}</span>
                        </div>
                        <p class="text-sm leading-7 text-slate-muted">${product.certBody()} ${product.standardCode()} / ${product.claimNames().size()} mapped claims / PFAS coverage ${PresentationText.previewList(product.coveredPfas(), 4)}</p>
                    </div>

                    <div class="mt-5 grid gap-3 md:grid-cols-2">
                        <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Upfront</span>
                            <span class="mt-2 block text-base font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.currencyLabel(product.upfrontCostUsd())}</span>
                        </article>
                        <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Annualized</span>
                            <span class="mt-2 block text-base font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.annualizedMaintenanceLabel(product)}</span>
                        </article>
                        <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Best for</span>
                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.bestForLabel(product)}</span>
                        </article>
                        <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Not for</span>
                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.notForLabel(product)}</span>
                        </article>
                        <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Maintenance burden</span>
                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.maintenanceBurdenLabel(product)}</span>
                        </article>
                        <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Seller choice</span>
                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${PresentationText.sellerChoiceNote(product)}</span>
                        </article>
                    </div>

                    <div class="mt-5 grid gap-4 md:grid-cols-2">
                        <div class="rounded-[18px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Next step</span>
                            <p class="mt-2 text-sm leading-7 text-slate-body">${PresentationText.nextStepLabel(product)}</p>
                        </div>
                        <div class="rounded-[18px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Cadence and confidence</span>
                            <p class="mt-2 text-sm leading-7 text-slate-body">${PresentationText.cadenceLabel(product.replacementCadenceMonths())} / Cost confidence ${PresentationText.confidenceLabel(product.costConfidence())}</p>
                        </div>
                    </div>

                    <div class="mt-5 grid gap-4 md:grid-cols-2">
                        <div class="rounded-[18px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Pros</span>
                            <ul class="mt-3 space-y-2 text-sm leading-6 text-slate-body">
                                @for(var item : PresentationText.productPros(product))
                                    <li class="flex gap-3">
                                        <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                                        <span>${item}</span>
                                    </li>
                                @endfor
                            </ul>
                        </div>
                        <div class="rounded-[18px] border border-shell-border bg-ivory-panel px-4 py-4">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Constraints</span>
                            <ul class="mt-3 space-y-2 text-sm leading-6 text-slate-body">
                                @for(var item : PresentationText.productConstraints(product))
                                    <li class="flex gap-3">
                                        <span class="mt-2 h-1.5 w-1.5 rounded-full bg-[rgba(15,118,110,0.6)]"></span>
                                        <span>${item}</span>
                                    </li>
                                @endfor
                            </ul>
                        </div>
                    </div>

                    <div class="mt-6 flex flex-wrap gap-3">
                        <a
                            class="inline-flex items-center justify-center rounded-full bg-teal-deep px-5 py-3 text-sm font-semibold text-white transition duration-150 ease-out hover:-translate-y-px hover:bg-slate-deep"
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
