@import java.util.List
@import com.example.pfas.source.SourceDocument
@import com.example.pfas.water.PublicWaterSystem
@import static com.example.pfas.web.PresentationText.sourceWaterTypeLabel
@import static com.example.pfas.web.PresentationText.systemTypeLabel
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param PublicWaterSystem system
@param List<SourceDocument> sources
@param boolean pageIndexable

!{ var hasPopulationServed = system.populationServed() != null && !system.populationServed().isBlank(); }

@template.layout.base(
    pageTitle = system.pwsName() + " utility context",
    pageDescription = "Utility-context page for " + system.pwsName() + " before result interpretation.",
    pageCanonicalUrl = siteBaseUrl + "/public-water-system/" + system.pwsid(),
    pageIndexable = pageIndexable,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <div class="space-y-4">
                    <span class="badge badge-outline border-base-300 bg-base-100 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-base-content/58">${system.stateCode()} public water</span>
                    <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-base-content sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                        ${system.pwsName()}
                        <span class="font-serif font-medium text-secondary">as the source context before the sales layer.</span>
                    </h1>
                    <p class="max-w-3xl text-lg leading-8 text-base-content/72">
                        Pull direct utility material before making a product decision. This page collects the seeded utility links
                        and context needed before interpretation.
                    </p>
                </div>

                <div class="join join-vertical gap-3 sm:join-horizontal">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="${system.ccrUrl()}">Open CCR or utility report</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/public-water/${system.pwsid()}">Open interpreted result</a>
                </div>
            </div>

            <aside class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                <div class="card-body gap-5">
                    <div class="space-y-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">System frame</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Direct utility evidence stays ahead of generalized product advice.</h2>
                    </div>
                    <ul class="menu gap-2 rounded-[1rem] bg-base-200/55 p-3">
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">PWSID</strong><br>${system.pwsid()}</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">System type</strong><br>${systemTypeLabel(system.systemType())}</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Source water</strong><br>${sourceWaterTypeLabel(system.sourceWaterType())}</span></li>
                    </ul>
                </div>
            </aside>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        @template.fragments.publicationStrip(
            lastVerified = system.lastVerifiedDate(),
            scopeLabel = "Public-water utility context",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="stats stats-vertical gap-3 bg-transparent p-0 shadow-none lg:stats-horizontal">
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">PWSID</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${system.pwsid()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Seeded system identifier used by the route.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">System type</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${systemTypeLabel(system.systemType())}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Operational context before any filter comparison.</div>
            </div>
            @if(hasPopulationServed)
                <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                    <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Population served</div>
                    <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${system.populationServed()}</div>
                    <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Utility scale can affect response timing and context.</div>
                </div>
            @endif
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Last verified</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${system.lastVerifiedDate()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Page-level review timestamp.</div>
            </div>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                    <div class="card-body gap-5">
                        <div class="alert border border-base-300/70 bg-base-100 px-5 py-4 shadow-none">
                            <div class="space-y-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Public-water next action</span>
                                <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">Use direct utility data before comparing filters.</h2>
                                <p class="text-sm leading-7 text-base-content/68">Utility documents, official notices, and normalized system observations should drive the next step.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <div class="space-y-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Service area notes</span>
                            <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Why this utility page exists</h2>
                        </div>
                        <div class="prose prose-dossier max-w-none text-base-content/72">
                            <p>${system.serviceAreaNotes()}</p>
                        </div>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <div class="space-y-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Primary source ledger</span>
                            <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Direct links captured for this utility route</h2>
                        </div>
                        <div class="space-y-3">
                            @for(var source : sources)
                                <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${source.organization()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                    <div class="mt-2 break-all text-sm leading-6 text-base-content/60">${source.url()}</div>
                                </a>
                            @endfor
                        </div>
                    </div>
                </section>
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Official links</h2>
                        <div class="join join-vertical gap-3">
                            <a class="btn btn-outline join-item h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${system.utilityWebsiteUrl()}">Utility website</a>
                            <a class="btn btn-outline join-item h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${system.pfasNoticeUrl()}">PFAS notice</a>
                        </div>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">System profile</h2>
                        <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                            <li>PWSID: ${system.pwsid()}</li>
                            <li>System type: ${systemTypeLabel(system.systemType())}</li>
                            @if(hasPopulationServed)
                                <li>Population served: ${system.populationServed()}</li>
                            @endif
                            <li>Source water type: ${sourceWaterTypeLabel(system.sourceWaterType())}</li>
                            <li>Last verified: ${system.lastVerifiedDate()}</li>
                        </ul>
                    </div>
                </section>

                <div class="alert border border-base-300/70 bg-base-100/92 px-5 py-4 shadow-[var(--shadow-soft)]">
                    <span class="text-sm leading-7 text-base-content/74">This page collects utility context before interpretation. It does not substitute for the route-level result and it does not recommend a product by itself.</span>
                </div>
            </aside>
        </div>
    </div>
</section>
`
)
