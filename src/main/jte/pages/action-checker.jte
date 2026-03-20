@import java.util.List
@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.checker.ActionCheckerRecommendation
@import com.example.pfas.state.StateGuidance
@import com.example.pfas.water.PublicWaterSystem
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param String siteLastVerifiedDate
@param List<StateGuidance> states
@param List<PublicWaterSystem> systems
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

@template.layout.base(
    pageTitle = "PFAS Action Checker",
    pageDescription = "Server-backed PFAS action checker that routes households through direct evidence before any product decision.",
    pageCanonicalUrl = siteBaseUrl + "/checker",
    pageIndexable = false,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_24rem] xl:items-start">
            <div class="space-y-6">
                <span class="badge badge-outline border-base-300 bg-base-100 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-base-content/58">Action checker</span>
                <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-base-content sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                    Route the household with
                    <span class="font-serif font-medium text-secondary">direct evidence before purchase logic.</span>
                </h1>
                <p class="max-w-3xl text-lg leading-8 text-base-content/74">
                    The checker is designed as a premium intake console, not a playful wizard. It makes the current state
                    obvious, keeps caveats visible, and opens shopping only when the evidence layer justifies it.
                </p>
                <div class="join join-vertical gap-3 sm:join-horizontal">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="#checker-panel">Start intake</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/methodology">Review methodology</a>
                </div>
            </div>

            <aside class="card border border-neutral/12 bg-neutral text-neutral-content shadow-[var(--shadow-panel)]">
                <div class="card-body gap-5">
                    <span class="badge border-0 bg-white/10 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Current discipline</span>
                    <div class="overflow-hidden rounded-[1rem] border border-white/10 bg-white/4">
                        <article class="px-4 py-4 text-sm leading-6 text-white/78">
                            <strong class="font-semibold text-white">What opens first</strong><br>Utility records, official notices, and private-well tests.
                        </article>
                        <article class="border-t border-white/10 px-4 py-4 text-sm leading-6 text-white/78">
                            <strong class="font-semibold text-white">What stays guarded</strong><br>Whole-house installs and unsupported certification claims.
                        </article>
                        <article class="border-t border-white/10 px-4 py-4 text-sm leading-6 text-white/78">
                            <strong class="font-semibold text-white">What this is not</strong><br>A safe-or-unsafe label, health diagnosis, or panic sales funnel.
                        </article>
                    </div>
                </div>
            </aside>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        @template.fragments.publicationStrip(
            lastVerified = siteLastVerifiedDate,
            scopeLabel = "Server-backed routing interface",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-20">
    @template.fragments.checkerPanel(
        states = states,
        systems = systems,
        selection = selection,
        recommendation = recommendation
    )
</section>
`
)
