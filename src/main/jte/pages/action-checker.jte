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
@param List<StateGuidance> featuredStates
@param List<PublicWaterSystem> systems
@param List<PublicWaterSystem> featuredSystems
@param List<PublicWaterSystem> featuredPennsylvaniaSystems
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

@template.layout.base(
    pageTitle = "PFAS Next-Step Checker",
    pageDescription = "Server-backed PFAS action checker that routes households through direct evidence before any product decision.",
    pageCanonicalUrl = siteBaseUrl + "/checker",
    pageIndexable = false,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="terminal-panel overflow-hidden">
            <div class="grid gap-px bg-white/8 xl:grid-cols-[minmax(0,1.15fr)_24rem] xl:items-start">
                <div class="space-y-6 bg-white/[0.03] p-7 md:p-9">
                    <span class="inline-flex rounded-full bg-white/10 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-white/78">Next-step checker</span>
                    <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-white sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                        Figure out the
                        <span class="font-serif font-medium text-white/72">next PFAS page to open before you shop.</span>
                    </h1>
                    <p class="max-w-3xl text-lg leading-8 text-white/72">
                        Start with the water source and the record you actually have. The checker keeps uncertainty visible and sends you to the narrowest next page the evidence can support.
                    </p>
                    <div class="join join-vertical gap-3 sm:join-horizontal">
                        <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold hover:bg-primary/92" href="#checker-panel">Start intake</a>
                        <a class="btn btn-outline join-item h-12 rounded-full border-white/14 bg-white/6 px-6 text-sm font-semibold text-white shadow-none hover:bg-white/10" href="/methodology">Review methodology</a>
                    </div>
                </div>

                <aside class="bg-white/[0.02] p-7 md:p-8">
                    <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">How this checker behaves</span>
                    <div class="terminal-pane mt-4 overflow-hidden">
                        <div class="terminal-stack">
                            <article class="px-4 py-4 text-sm leading-6 text-white/78">
                                <strong class="font-semibold text-white">Starts with records</strong><br>Utility records, official notices, and private-well tests open before product pages do.
                            </article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78">
                                <strong class="font-semibold text-white">Keeps guardrails visible</strong><br>Whole-house installs and unsupported certification claims stay separate from the default route.
                            </article>
                            <article class="px-4 py-4 text-sm leading-6 text-white/78">
                                <strong class="font-semibold text-white">Does not do</strong><br>It does not label water safe or unsafe, make medical claims, or turn fear into a sales shortcut.
                            </article>
                        </div>
                    </div>
                </aside>
            </div>
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
        featuredStates = featuredStates,
        systems = systems,
        featuredSystems = featuredSystems,
        featuredPennsylvaniaSystems = featuredPennsylvaniaSystems,
        selection = selection,
        recommendation = recommendation
    )
</section>
`
)
