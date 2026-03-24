@import com.example.pfas.derived.DerivedArtifactSyncReport
@import com.example.pfas.derived.PageGenerationManifestFile
@import com.example.pfas.derived.RouteManifestFile
@import com.example.pfas.derived.SearchIndexSeedFile
@import com.example.pfas.internalapi.AdminConsoleController.AdminSourceRow
@import com.example.pfas.merchant.MerchantClickCountEntry
@import com.example.pfas.merchant.MerchantClickReport
@import com.example.pfas.quality.FreshnessQualityReport
@import com.example.pfas.quality.FreshnessRouteFinding
@import com.example.pfas.quality.FreshnessSourceFinding
@import com.example.pfas.readiness.ExpansionReadinessItem
@import com.example.pfas.readiness.ExpansionReadinessReport
@import com.example.pfas.routeclick.RouteClickCountEntry
@import com.example.pfas.routeclick.RouteClickReport
@param String adminCanonicalUrl
@param RouteManifestFile routeManifest
@param SearchIndexSeedFile searchIndex
@param PageGenerationManifestFile pageGenerationManifest
@param FreshnessQualityReport qualityReport
@param java.util.List<FreshnessRouteFinding> topRouteFindings
@param java.util.List<FreshnessSourceFinding> topStaleSources
@param ExpansionReadinessReport readinessReport
@param java.util.List<ExpansionReadinessItem> readyItems
@param java.util.List<ExpansionReadinessItem> blockedItems
@param MerchantClickReport merchantClickReport
@param java.util.List<MerchantClickCountEntry> topMerchantCounts
@param java.util.List<MerchantClickCountEntry> topMerchantSourcePages
@param RouteClickReport routeClickReport
@param java.util.List<RouteClickCountEntry> topRouteTargets
@param java.util.List<RouteClickCountEntry> topRouteCtas
@param int sourceDocumentCount
@param java.util.List<AdminSourceRow> recentSources
@param DerivedArtifactSyncReport syncReport

@template.layout.base(
    pageTitle = "Admin Console | PFAS Decision Engine",
    pageDescription = "Internal operating console for derived artifacts, readiness, quality, tracking, and sources.",
    pageCanonicalUrl = adminCanonicalUrl,
    pageIndexable = false,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell space-y-8">
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.15fr)_22rem]">
                <div class="space-y-6 bg-white/[0.03] p-7 md:p-9">
                    <div class="space-y-4">
                        <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">Internal console</span>
                        <h1 class="max-w-4xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl">Admin console</h1>
                        <p class="max-w-3xl text-lg leading-8 text-white/72">Login-protected operating surface for sync, quality, readiness, tracking, and source review. This page is noindex.</p>
                    </div>
                    <div class="flex flex-wrap gap-3">
                        <a class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold" href="#overview">Overview</a>
                        <a class="btn btn-outline h-11 rounded-full border-white/14 bg-white/6 px-5 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="#derived">Derived</a>
                        <a class="btn btn-outline h-11 rounded-full border-white/14 bg-white/6 px-5 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="#quality">Quality</a>
                        <a class="btn btn-outline h-11 rounded-full border-white/14 bg-white/6 px-5 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="#tracking">Tracking</a>
                        <a class="btn btn-outline h-11 rounded-full border-white/14 bg-white/6 px-5 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="#sources">Sources</a>
                    </div>
                </div>
                <aside class="space-y-3 bg-white/[0.02] p-7 md:p-8">
                    <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Raw endpoints</span>
                    <div class="terminal-pane overflow-hidden">
                        <div class="terminal-stack">
                            <a class="px-4 py-4 text-sm font-semibold text-white/78 transition duration-150 ease-out hover:bg-white/6 hover:text-white" href="/internal/quality/freshness-report">Quality JSON</a>
                            <a class="px-4 py-4 text-sm font-semibold text-white/78 transition duration-150 ease-out hover:bg-white/6 hover:text-white" href="/internal/readiness/report">Readiness JSON</a>
                            <a class="px-4 py-4 text-sm font-semibold text-white/78 transition duration-150 ease-out hover:bg-white/6 hover:text-white" href="/internal/source-registry">Source registry JSON</a>
                            <a class="px-4 py-4 text-sm font-semibold text-white/78 transition duration-150 ease-out hover:bg-white/6 hover:text-white" href="/internal/merchant-clicks/report">Merchant clicks JSON</a>
                            <a class="px-4 py-4 text-sm font-semibold text-white/78 transition duration-150 ease-out hover:bg-white/6 hover:text-white" href="/internal/route-clicks/report">Route clicks JSON</a>
                        </div>
                    </div>
                </aside>
            </div>
        </div>

        @if (syncReport != null)
            <div class="surface-panel border border-success/20 bg-success/8 px-5 py-5">
                <div class="text-sm font-semibold text-base-content">Derived artifacts synced at ${syncReport.generatedAt()}</div>
            </div>
        @endif
    </div>
</section>

<section class="pt-10 md:pt-12" id="overview">
    <div class="shell">
        <div class="ledger-grid">
            <article class="surface-panel px-5 py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Routes</div>
                <div class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">${routeManifest.routeCount()}</div>
                <p class="mt-2 text-sm leading-7 text-base-content/64">${routeManifest.indexableRouteCount()} indexable</p>
            </article>
            <article class="surface-panel px-5 py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Search docs</div>
                <div class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">${searchIndex.documentCount()}</div>
                <p class="mt-2 text-sm leading-7 text-base-content/64">${pageGenerationManifest.modelCount()} page models</p>
            </article>
            <article class="surface-panel px-5 py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Sources</div>
                <div class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">${sourceDocumentCount}</div>
                <p class="mt-2 text-sm leading-7 text-base-content/64">${qualityReport.staleSourceCount()} stale</p>
            </article>
            <article class="surface-panel px-5 py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Merchant clicks</div>
                <div class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">${merchantClickReport.totalCount()}</div>
                <p class="mt-2 text-sm leading-7 text-base-content/64">${merchantClickReport.uniqueSourcePageCount()} source pages</p>
            </article>
            <article class="surface-panel px-5 py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Route clicks</div>
                <div class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">${routeClickReport.totalCount()}</div>
                <p class="mt-2 text-sm leading-7 text-base-content/64">${routeClickReport.uniqueTargetPathCount()} targets</p>
            </article>
            <article class="surface-panel px-5 py-5">
                <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Blocked routes</div>
                <div class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">${qualityReport.routeFindings().size()}</div>
                <p class="mt-2 text-sm leading-7 text-base-content/64">${readinessReport.blockedStateRoutes() + readinessReport.blockedPublicWaterRoutes()} readiness blocks</p>
            </article>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-18" id="derived">
    <div class="shell">
        <div class="grid gap-5 xl:grid-cols-[minmax(0,1fr)_20rem]">
            <article class="surface-panel p-6">
                <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
                    <div>
                        <span class="section-label">Derived</span>
                        <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-base-content">Artifacts and readiness</h2>
                    </div>
                    <form method="post" action="/admin/derived/sync">
                        <button class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold" type="submit">Sync derived artifacts</button>
                    </form>
                </div>
                <div class="mt-6 grid gap-4 md:grid-cols-3">
                    <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                        <div class="text-sm font-semibold text-base-content">Route manifest</div>
                        <div class="mt-2 text-2xl font-semibold tracking-[-0.03em] text-base-content">${routeManifest.routeCount()}</div>
                        <a class="mt-4 inline-flex text-sm font-semibold text-primary" href="/internal/derived/route-manifest">Open JSON</a>
                    </div>
                    <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                        <div class="text-sm font-semibold text-base-content">Search index</div>
                        <div class="mt-2 text-2xl font-semibold tracking-[-0.03em] text-base-content">${searchIndex.documentCount()}</div>
                        <a class="mt-4 inline-flex text-sm font-semibold text-primary" href="/internal/derived/search-index">Open JSON</a>
                    </div>
                    <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5">
                        <div class="text-sm font-semibold text-base-content">Page generation</div>
                        <div class="mt-2 text-2xl font-semibold tracking-[-0.03em] text-base-content">${pageGenerationManifest.modelCount()}</div>
                        <a class="mt-4 inline-flex text-sm font-semibold text-primary" href="/internal/derived/page-generation-manifest">Open JSON</a>
                    </div>
                </div>
            </article>
            <article class="surface-panel overflow-hidden">
                <div class="border-b border-base-300/70 px-6 py-5">
                    <span class="section-label">Readiness</span>
                    <h3 class="mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">Top ready and blocked routes</h3>
                </div>
                <div class="divide-y divide-base-300/70">
                    @for (var item : readyItems)
                        <article class="px-6 py-4">
                            <div class="text-sm font-semibold text-base-content">${item.displayLabel()}</div>
                            <div class="mt-1 text-sm text-base-content/64">READY · ${item.sourceCount()} sources</div>
                        </article>
                    @endfor
                    @for (var item : blockedItems)
                        <article class="px-6 py-4">
                            <div class="text-sm font-semibold text-base-content">${item.displayLabel()}</div>
                            <div class="mt-1 text-sm text-base-content/64">${String.join(", ", item.missingSignals())}</div>
                        </article>
                    @endfor
                </div>
            </article>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-18" id="quality">
    <div class="shell">
        <div class="grid gap-5 xl:grid-cols-2">
            <article class="surface-panel overflow-hidden">
                <div class="border-b border-base-300/70 px-6 py-5">
                    <div class="flex items-center justify-between gap-3">
                        <div>
                            <span class="section-label">Quality</span>
                            <h2 class="mt-3 text-2xl font-semibold tracking-[-0.03em] text-base-content">Route findings</h2>
                        </div>
                        <a class="text-sm font-semibold text-primary" href="/internal/quality/freshness-report">Open JSON</a>
                    </div>
                </div>
                <div class="divide-y divide-base-300/70">
                    @if (topRouteFindings.isEmpty())
                        <div class="px-6 py-5 text-sm leading-7 text-base-content/64">No blocked routes.</div>
                    @else
                        @for (var finding : topRouteFindings)
                            <article class="px-6 py-5">
                                <div class="text-sm font-semibold text-base-content">${finding.primaryPath()}</div>
                                <div class="mt-1 text-sm text-base-content/64">${String.join(", ", finding.reasons())}</div>
                            </article>
                        @endfor
                    @endif
                </div>
            </article>
            <article class="surface-panel overflow-hidden">
                <div class="border-b border-base-300/70 px-6 py-5">
                    <span class="section-label">Stale sources</span>
                    <h2 class="mt-3 text-2xl font-semibold tracking-[-0.03em] text-base-content">Recent source issues</h2>
                </div>
                <div class="divide-y divide-base-300/70">
                    @if (topStaleSources.isEmpty())
                        <div class="px-6 py-5 text-sm leading-7 text-base-content/64">No stale sources.</div>
                    @else
                        @for (var finding : topStaleSources)
                            <article class="px-6 py-5">
                                <div class="text-sm font-semibold text-base-content">${finding.sourceId()}</div>
                                <div class="mt-1 text-sm text-base-content/64">${finding.referenceDate() == null ? "No reference date" : finding.referenceDate()} · ${finding.staleReason()}</div>
                            </article>
                        @endfor
                    @endif
                </div>
            </article>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-18" id="tracking">
    <div class="shell">
        <div class="grid gap-5 xl:grid-cols-2">
            <article class="surface-panel overflow-hidden">
                <div class="border-b border-base-300/70 px-6 py-5">
                    <div class="flex items-center justify-between gap-3">
                        <div>
                            <span class="section-label">Merchant clicks</span>
                            <h2 class="mt-3 text-2xl font-semibold tracking-[-0.03em] text-base-content">${merchantClickReport.totalCount()} total</h2>
                        </div>
                        <a class="text-sm font-semibold text-primary" href="/internal/merchant-clicks/report">Open JSON</a>
                    </div>
                </div>
                <div class="grid gap-px bg-base-300/70 md:grid-cols-2">
                    <div class="bg-base-100 px-6 py-5">
                        <div class="text-sm font-semibold text-base-content">Top merchants</div>
                        <div class="mt-4 space-y-3">
                            @for (var count : topMerchantCounts)
                                <div class="flex items-center justify-between gap-3 text-sm">
                                    <span class="text-base-content/72">${count.key()}</span>
                                    <span class="font-semibold text-base-content">${count.count()}</span>
                                </div>
                            @endfor
                        </div>
                    </div>
                    <div class="bg-base-100 px-6 py-5">
                        <div class="text-sm font-semibold text-base-content">Top source pages</div>
                        <div class="mt-4 space-y-3">
                            @for (var count : topMerchantSourcePages)
                                <div class="flex items-center justify-between gap-3 text-sm">
                                    <span class="truncate text-base-content/72">${count.key()}</span>
                                    <span class="font-semibold text-base-content">${count.count()}</span>
                                </div>
                            @endfor
                        </div>
                    </div>
                </div>
            </article>
            <article class="surface-panel overflow-hidden">
                <div class="border-b border-base-300/70 px-6 py-5">
                    <div class="flex items-center justify-between gap-3">
                        <div>
                            <span class="section-label">Route clicks</span>
                            <h2 class="mt-3 text-2xl font-semibold tracking-[-0.03em] text-base-content">${routeClickReport.totalCount()} total</h2>
                        </div>
                        <a class="text-sm font-semibold text-primary" href="/internal/route-clicks/report">Open JSON</a>
                    </div>
                </div>
                <div class="grid gap-px bg-base-300/70 md:grid-cols-2">
                    <div class="bg-base-100 px-6 py-5">
                        <div class="text-sm font-semibold text-base-content">Top targets</div>
                        <div class="mt-4 space-y-3">
                            @for (var count : topRouteTargets)
                                <div class="flex items-center justify-between gap-3 text-sm">
                                    <span class="truncate text-base-content/72">${count.key()}</span>
                                    <span class="font-semibold text-base-content">${count.count()}</span>
                                </div>
                            @endfor
                        </div>
                    </div>
                    <div class="bg-base-100 px-6 py-5">
                        <div class="text-sm font-semibold text-base-content">Top CTA slots</div>
                        <div class="mt-4 space-y-3">
                            @for (var count : topRouteCtas)
                                <div class="flex items-center justify-between gap-3 text-sm">
                                    <span class="truncate text-base-content/72">${count.key()}</span>
                                    <span class="font-semibold text-base-content">${count.count()}</span>
                                </div>
                            @endfor
                        </div>
                    </div>
                </div>
            </article>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-18" id="sources">
    <div class="shell">
        <article class="surface-panel overflow-hidden">
            <div class="border-b border-base-300/70 px-6 py-5">
                <div class="flex items-center justify-between gap-3">
                    <div>
                        <span class="section-label">Sources</span>
                        <h2 class="mt-3 text-2xl font-semibold tracking-[-0.03em] text-base-content">${sourceDocumentCount} source documents</h2>
                    </div>
                    <a class="text-sm font-semibold text-primary" href="/internal/source-registry">Open JSON</a>
                </div>
            </div>
            <div class="divide-y divide-base-300/70">
                @for (var source : recentSources)
                    <article class="grid gap-4 px-6 py-5 lg:grid-cols-[minmax(0,1.2fr)_12rem_20rem] lg:items-start">
                        <div class="space-y-2">
                            <div class="text-sm font-semibold text-base-content">${source.title()}</div>
                            <div class="text-sm text-base-content/64">${source.organization()} · ${source.sourceId()}</div>
                        </div>
                        <div class="text-sm text-base-content/64">${source.referenceDate() == null ? "No reference date" : source.referenceDate()}</div>
                        <div class="flex flex-wrap gap-3 lg:justify-end">
                            <a class="btn btn-outline h-10 rounded-full border-base-300 bg-base-100 px-4 text-sm font-semibold text-base-content shadow-none hover:bg-base-200" href="/internal/source-registry/${source.sourceId()}">Registry record</a>
                            <a class="btn btn-primary h-10 rounded-full border-0 px-4 text-sm font-semibold" href="${source.url()}" target="_blank" rel="noopener noreferrer">Open source URL</a>
                        </div>
                    </article>
                @endfor
            </div>
        </article>
    </div>
</section>
`)
