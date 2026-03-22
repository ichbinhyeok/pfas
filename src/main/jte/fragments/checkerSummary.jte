@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.checker.ActionCheckerRecommendation
@import static com.example.pfas.web.PresentationText.benchmarkRelationLabel
@import static com.example.pfas.web.PresentationText.currentFilterStatusLabel
@import static com.example.pfas.web.PresentationText.directDataLabel
@import static com.example.pfas.web.PresentationText.indirectDataLabel
@import static com.example.pfas.web.PresentationText.waterSourceLabel
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

<aside class="order-1 space-y-4 xl:order-2 xl:sticky xl:top-28" id="checker-summary">
    <section class="terminal-panel">
        <div class="space-y-5 p-6">
            <div class="space-y-3 border-b border-white/10 pb-5">
                <span class="badge border-0 bg-white/10 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/80">${recommendation.tag()}</span>
                <p class="text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-white/55">${recommendation.routeCode()}</p>
                <h2 class="text-[2rem] font-semibold tracking-[-0.045em] text-white">${recommendation.title()}</h2>
                <p class="text-base leading-7 text-white/72">${recommendation.summary()}</p>
            </div>

            <div class="terminal-pane px-5 py-5">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/58">Next action now</span>
                <p class="mt-3 text-lg font-semibold tracking-[-0.02em] text-white">${recommendation.primaryLabel()}</p>
                <p class="mt-2 text-sm leading-6 text-white/68">The engine opens this path first. It is the least aggressive action supported by the current state.</p>
            </div>

            <div class="join join-vertical gap-3">
                <a class="btn join-item h-11 rounded-full border-0 bg-white text-neutral px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-white/92" href="${recommendation.primaryHref()}">${recommendation.primaryLabel()}</a>
                <a class="btn btn-outline join-item h-11 rounded-full border-white/14 bg-transparent px-5 text-sm font-semibold text-white shadow-none hover:-translate-y-px hover:bg-white/8" href="${recommendation.secondaryHref()}">${recommendation.secondaryLabel()}</a>
            </div>
        </div>
    </section>

    <div class="space-y-3">
        <details class="collapse collapse-arrow border border-base-300/70 bg-base-100/94 shadow-[var(--shadow-soft)]">
            <summary class="collapse-title pr-12">
                <div class="text-sm font-semibold tracking-[-0.02em] text-base-content">State in view</div>
                <div class="mt-1 text-[0.72rem] font-medium tracking-[-0.01em] text-base-content/48">${waterSourceLabel(selection.waterSource())} / ${directDataLabel(selection.directData())}</div>
            </summary>
            <div class="collapse-content">
                <dl class="space-y-3 text-sm">
                    <div class="flex items-start justify-between gap-4 border-b border-base-300/70 pb-3">
                        <dt class="text-base-content/58">Source</dt>
                        <dd class="text-right font-semibold tracking-[-0.02em] text-base-content">${waterSourceLabel(selection.waterSource())}</dd>
                    </div>
                    <div class="flex items-start justify-between gap-4 border-b border-base-300/70 pb-3">
                        <dt class="text-base-content/58">Direct evidence</dt>
                        <dd class="text-right font-semibold tracking-[-0.02em] text-base-content">${directDataLabel(selection.directData())}</dd>
                    </div>
                    <div class="flex items-start justify-between gap-4 border-b border-base-300/70 pb-3">
                        <dt class="text-base-content/58">Indirect context</dt>
                        <dd class="text-right font-semibold tracking-[-0.02em] text-base-content">${indirectDataLabel(selection.indirectData())}</dd>
                    </div>
                    <div class="flex items-start justify-between gap-4 border-b border-base-300/70 pb-3">
                        <dt class="text-base-content/58">Benchmark relation</dt>
                        <dd class="text-right font-semibold tracking-[-0.02em] text-base-content">${benchmarkRelationLabel(selection.benchmarkRelation())}</dd>
                    </div>
                    <div class="flex items-start justify-between gap-4 border-b border-base-300/70 pb-3">
                        <dt class="text-base-content/58">Current hardware</dt>
                        <dd class="text-right font-semibold tracking-[-0.02em] text-base-content">${currentFilterStatusLabel(selection.currentFilterStatus())}</dd>
                    </div>
                    <div class="flex items-start justify-between gap-4">
                        <dt class="text-base-content/58">Escalation posture</dt>
                        <dd class="text-right font-semibold tracking-[-0.02em] text-base-content">${selection.wholeHouseConsidered() ? "Whole-house under guarded review" : "Point-of-use remains first"}</dd>
                    </div>
                </dl>
            </div>
        </details>

        <details class="collapse collapse-arrow border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
            <summary class="collapse-title pr-12">
                <div class="text-sm font-semibold tracking-[-0.02em] text-base-content">Why this route opened</div>
                <div class="mt-1 text-[0.72rem] font-medium tracking-[-0.01em] text-base-content/48">${recommendation.principles().size()} routing principles are active</div>
            </summary>
            <div class="collapse-content">
                <ul class="space-y-3 text-sm leading-6 text-base-content/72">
                    @for(var principle : recommendation.principles())
                        <li>${principle}</li>
                    @endfor
                </ul>
            </div>
        </details>

        <article class="surface-muted px-5 py-5 shadow-[var(--shadow-soft)]">
            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">What this does not confirm</span>
            <p class="mt-3 text-sm leading-7 text-base-content/68">This route does not declare the household safe or unsafe. It does not replace utility interpretation, state guidance, or accredited lab review.</p>
        </article>

        @if(recommendation.wholeHouseGuardrail())
            <article class="rounded-[1rem] border border-accent/18 bg-[rgba(120,104,90,0.08)] px-5 py-5 shadow-[var(--shadow-soft)]">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-accent">Whole-house guardrail</span>
                <p class="mt-3 text-sm leading-7 text-base-content/72">${recommendation.wholeHouseMessage()}</p>
            </article>
        @endif
    </div>
</aside>
