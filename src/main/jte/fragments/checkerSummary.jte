@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.checker.ActionCheckerRecommendation
@import static com.example.pfas.web.PresentationText.benchmarkRelationLabel
@import static com.example.pfas.web.PresentationText.currentFilterStatusLabel
@import static com.example.pfas.web.PresentationText.directDataLabel
@import static com.example.pfas.web.PresentationText.indirectDataLabel
@import static com.example.pfas.web.PresentationText.waterSourceLabel
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

<aside class="xl:sticky xl:top-28" id="checker-summary">
    <div class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet">
        <div class="border-b border-shell-border pb-6">
            <span class="inline-flex rounded-full border border-teal-deep/14 bg-teal-tint/70 px-3 py-1.5 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-teal-deep">${recommendation.tag()}</span>
            <p class="mt-4 text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">${recommendation.routeCode()}</p>
            <h2 class="mt-3 text-3xl font-semibold tracking-[-0.04em] text-slate-deep">${recommendation.title()}</h2>
            <p class="mt-3 text-base leading-7 text-slate-muted">${recommendation.summary()}</p>
        </div>

        <div class="mt-6 grid gap-3 sm:grid-cols-2 xl:grid-cols-1">
            <article class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Source</span>
                <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${waterSourceLabel(selection.waterSource())}</span>
            </article>
            <article class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Direct data</span>
                <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${directDataLabel(selection.directData())}</span>
            </article>
            <article class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Indirect data</span>
                <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${indirectDataLabel(selection.indirectData())}</span>
            </article>
            <article class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Benchmark relation</span>
                <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${benchmarkRelationLabel(selection.benchmarkRelation())}</span>
            </article>
            <article class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Current filter</span>
                <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${currentFilterStatusLabel(selection.currentFilterStatus())}</span>
            </article>
            <article class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Whole-house posture</span>
                <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${selection.wholeHouseConsidered() ? "Guarded review only" : "Point-of-use first"}</span>
            </article>
        </div>

        <div class="mt-6 rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Why this route</span>
            <ul class="mt-3 space-y-3 text-sm leading-6 text-slate-body">
                @for(var principle : recommendation.principles())
                    <li class="flex gap-3">
                        <span class="mt-2 h-1.5 w-1.5 rounded-full bg-teal-deep"></span>
                        <span>${principle}</span>
                    </li>
                @endfor
            </ul>
        </div>

        <div class="mt-6 rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">What this does not decide</span>
            <p class="mt-3 text-sm leading-6 text-slate-muted">This is a routing posture inside the engine. It does not label the household safe or unsafe, and it does not replace direct utility, state, or lab interpretation.</p>
        </div>

        @if(recommendation.wholeHouseGuardrail())
            <div class="mt-6 rounded-[18px] border border-brass/25 bg-[rgba(139,114,71,0.08)] px-5 py-5">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-brass">Whole-house guardrail</span>
                <p class="mt-3 text-sm leading-6 text-slate-body">${recommendation.wholeHouseMessage()}</p>
            </div>
        @endif

        <div class="mt-6 space-y-3">
            <a class="inline-flex w-full items-center justify-center rounded-full bg-teal-deep px-5 py-3 text-sm font-semibold text-white transition duration-150 ease-out hover:-translate-y-px hover:bg-slate-deep" href="${recommendation.primaryHref()}">${recommendation.primaryLabel()}</a>
            <a class="inline-flex w-full items-center justify-center rounded-full border border-shell-border-strong bg-ivory px-5 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="${recommendation.secondaryHref()}">${recommendation.secondaryLabel()}</a>
        </div>
    </div>
</aside>
