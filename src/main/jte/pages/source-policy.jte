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
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.16fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <div class="space-y-4">
                    <span class="badge badge-outline border-base-300 bg-base-100 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-base-content/58">Source policy</span>
                    <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-base-content sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                        The project ranks sources before it ranks products
                        <span class="font-serif font-medium text-secondary">and keeps that order visible.</span>
                    </h1>
                    <p class="max-w-3xl text-lg leading-8 text-base-content/72">
                        Direct official evidence sits at the top. Certification directories and vendor records only open after
                        the household path, benchmark context, and source ownership are already anchored.
                    </p>
                </div>

                <div class="join join-vertical gap-3 sm:join-horizontal">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="/methodology">Open methodology</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/checker">Open Action Checker</a>
                </div>
            </div>

            <aside class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                <div class="card-body gap-5">
                    <div class="space-y-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Trust discipline</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Evidence quality controls what can be said and what can be sold.</h2>
                    </div>
                    <ul class="menu gap-2 rounded-[1rem] bg-base-200/55 p-3">
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Tier 1 and 2</strong><br>Rule status, agency guidance, and route-specific utility evidence.</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Tier 3</strong><br>Certification directories and listing systems used for claim scope.</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Tier 4</strong><br>Vendor records used only for model detail, price, and cadence.</span></li>
                    </ul>
                </div>
            </aside>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        @template.fragments.publicationStrip(
            lastVerified = siteLastVerifiedDate,
            scopeLabel = "Source discipline",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="stats stats-vertical gap-3 bg-transparent p-0 shadow-none lg:stats-horizontal">
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Tracked sources</div>
                <div class="stat-value mt-3 text-2xl font-semibold tracking-[-0.04em] text-base-content">${sourceCount}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Registry-backed source documents.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">State routes</div>
                <div class="stat-value mt-3 text-2xl font-semibold tracking-[-0.04em] text-base-content">${stateCount}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">State guidance seeds using official agency routes.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Seeded dossiers</div>
                <div class="stat-value mt-3 text-2xl font-semibold tracking-[-0.04em] text-base-content">${publicWaterCount + filterCount}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Public-water and product records currently rendered.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Guides</div>
                <div class="stat-value mt-3 text-2xl font-semibold tracking-[-0.04em] text-base-content">${guideCount}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">Search-intent pages tied back to the same source ladder.</div>
            </div>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                    <div class="card-body gap-6">
                        <div class="space-y-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Trust tiers</span>
                            <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">Trust tiers</h2>
                            <p class="max-w-3xl text-sm leading-7 text-base-content/64">Higher tiers constrain the decision posture. Lower tiers can add commercial or operational context, but they cannot override route evidence.</p>
                        </div>
                        <div class="grid gap-4 md:grid-cols-2">
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Tier 1</span>
                                <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Federal rule and program sources</h3>
                                <p class="mt-3 text-sm leading-7 text-base-content/68">Federal agencies for rule status, program context, and high-level filter guidance.</p>
                            </article>
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Tier 2</span>
                                <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">State and utility evidence</h3>
                                <p class="mt-3 text-sm leading-7 text-base-content/68">State agencies and utility records for direct route-specific evidence.</p>
                            </article>
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Tier 3</span>
                                <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Certification directories</h3>
                                <p class="mt-3 text-sm leading-7 text-base-content/68">Certification directories and listing systems.</p>
                            </article>
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Tier 4</span>
                                <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Vendor records</h3>
                                <p class="mt-3 text-sm leading-7 text-base-content/68">Vendor pages for price, replacement cadence, and official model detail.</p>
                            </article>
                        </div>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <div class="space-y-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Tier 1 examples</span>
                            <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Federal source examples</h2>
                        </div>
                        <div class="space-y-3">
                            @for(var source : tier1Sources)
                                <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()} / ${source.organization()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                </a>
                            @endfor
                        </div>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <div class="space-y-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Tier 2 examples</span>
                            <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">State and utility source examples</h2>
                        </div>
                        <div class="space-y-3">
                            @for(var source : tier2Sources)
                                <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()} / ${source.organization()}</div>
                                    <div class="mt-3 text-lg font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                </a>
                            @endfor
                        </div>
                    </div>
                </section>
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Tier 3 examples</h2>
                        <div class="space-y-3">
                            @for(var source : tier3Sources)
                                <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()} / ${source.organization()}</div>
                                    <div class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                </a>
                            @endfor
                        </div>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Tier 4 examples</h2>
                        <div class="space-y-3">
                            @for(var source : tier4Sources)
                                <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Tier ${source.trustTier()} / ${source.organization()}</div>
                                    <div class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                </a>
                            @endfor
                        </div>
                    </div>
                </section>

                <div class="alert border border-base-300/70 bg-base-100/92 px-5 py-4 shadow-[var(--shadow-soft)]">
                    <span class="text-sm leading-7 text-base-content/74">Lower-tier commercial records can add price or maintenance context. They do not change the route when higher-tier evidence says otherwise.</span>
                </div>
            </aside>
        </div>
    </div>
</section>
`
)
