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
<section class="pt-12 md:pt-16">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-5">
                <span class="inline-flex rounded-full border border-shell-border bg-ivory-panel px-4 py-2 text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Action checker</span>
                <h1 class="max-w-4xl text-4xl font-semibold tracking-[-0.05em] text-slate-deep sm:text-5xl lg:text-[3.55rem] lg:leading-[1.04]">
                    Route the household with
                    <span class="font-serif font-medium text-mineral-blue">direct evidence before purchase logic.</span>
                </h1>
                <p class="max-w-3xl text-lg leading-8 text-slate-body">
                    The checker is meant to feel like a premium intake console, not a playful wizard. It should make the current
                    state obvious, keep caveats visible, and open shopping only when the evidence layer justifies it.
                </p>
            </div>
            <aside class="rounded-[22px] border border-shell-border bg-ivory-panel px-6 py-6 shadow-quiet">
                <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Current discipline</span>
                <div class="mt-4 space-y-4">
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">What opens first</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">Utility records, notices, and private-well tests.</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">What stays guarded</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">Whole-house installs and unsupported certification claims.</p>
                    </div>
                    <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                        <span class="block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">What this is not</span>
                        <p class="mt-2 text-base font-semibold tracking-[-0.02em] text-slate-deep">A safe-or-unsafe label, health diagnosis, or panic sales funnel.</p>
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
