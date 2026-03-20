@import java.util.List
@import com.example.pfas.checker.ActionBenchmarkRelation
@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.checker.ActionCheckerRecommendation
@import com.example.pfas.checker.ActionCurrentFilterStatus
@import com.example.pfas.checker.ActionWaterSource
@import com.example.pfas.checker.ActionDirectDataStatus
@import com.example.pfas.checker.ActionIndirectDataStatus
@import com.example.pfas.checker.ActionShoppingIntent
@import com.example.pfas.state.StateGuidance
@import com.example.pfas.water.PublicWaterSystem
@import static com.example.pfas.web.PresentationText.benchmarkRelationLabel
@import static com.example.pfas.web.PresentationText.currentFilterStatusLabel
@import static com.example.pfas.web.PresentationText.indirectDataLabel
@import static com.example.pfas.web.PresentationText.waterSourceLabel
@param List<StateGuidance> states
@param List<PublicWaterSystem> systems
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

<div class="shell grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_24rem]" id="checker-panel">
    <form
        class="rounded-[22px] border border-shell-border bg-ivory-panel p-6 shadow-quiet md:p-8"
        method="get"
        action="/checker"
        hx-get="/checker/panel"
        hx-trigger="change from:input, change from:select"
        hx-target="#checker-panel"
        hx-swap="outerHTML"
    >
        <div class="flex flex-col gap-4 border-b border-shell-border pb-6 md:flex-row md:items-end md:justify-between">
            <div class="space-y-2">
                <span class="inline-flex text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">Input state</span>
                <h2 class="text-3xl font-semibold tracking-[-0.04em] text-slate-deep">Action checker</h2>
                <p class="max-w-2xl text-sm leading-7 text-slate-muted">Large controls, explicit state choices, and a summary rail that explains what the engine is doing instead of trying to sell ahead of the evidence.</p>
            </div>
            <div class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4 text-sm leading-6 text-slate-body">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Current interpretation</span>
                <span class="mt-1 block font-semibold tracking-[-0.02em] text-slate-deep">${recommendation.title()}</span>
            </div>
        </div>

        <div class="mt-6 grid gap-3 md:grid-cols-3">
            <article class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Water source</span>
                <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${waterSourceLabel(selection.waterSource())}</span>
            </article>
            <article class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Benchmark relation</span>
                <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${benchmarkRelationLabel(selection.benchmarkRelation())}</span>
            </article>
            <article class="rounded-[16px] border border-shell-border bg-ivory px-4 py-4">
                <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-slate-soft">Current filter</span>
                <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${currentFilterStatusLabel(selection.currentFilterStatus())}</span>
            </article>
        </div>

        <div class="mt-8 space-y-8">
            <section class="space-y-4">
                <div class="space-y-2">
                    <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">1. Water source</span>
                    <p class="text-sm leading-7 text-slate-muted">Choose the evidence system first. Public-water and private-well cases should not share the same assumptions.</p>
                </div>
                <div class="grid gap-4 md:grid-cols-2">
                    <label class="group block cursor-pointer">
                        <input class="peer sr-only" type="radio" name="waterSource" value="PUBLIC_WATER" checked="${selection.waterSource() == ActionWaterSource.PUBLIC_WATER}">
                        <span class="flex h-full flex-col rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px group-hover:border-shell-border-strong peer-checked:border-teal-deep peer-checked:bg-teal-tint/60 peer-checked:shadow-float peer-focus-visible:ring-2 peer-focus-visible:ring-teal-deep/15">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-slate-deep">Public water</span>
                            <span class="mt-2 text-sm leading-6 text-slate-muted">Start with the utility report, CCR, direct system notice, or seeded system context.</span>
                        </span>
                    </label>
                    <label class="group block cursor-pointer">
                        <input class="peer sr-only" type="radio" name="waterSource" value="PRIVATE_WELL" checked="${selection.waterSource() == ActionWaterSource.PRIVATE_WELL}">
                        <span class="flex h-full flex-col rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px group-hover:border-shell-border-strong peer-checked:border-teal-deep peer-checked:bg-teal-tint/60 peer-checked:shadow-float peer-focus-visible:ring-2 peer-focus-visible:ring-teal-deep/15">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-slate-deep">Private well</span>
                            <span class="mt-2 text-sm leading-6 text-slate-muted">Start with state-accredited testing, well results, and state-specific guidance before shopping.</span>
                        </span>
                    </label>
                </div>
            </section>

            <section class="space-y-4">
                <div class="space-y-2">
                    <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">2. Direct evidence</span>
                    <p class="text-sm leading-7 text-slate-muted">If a direct document or lab result already exists, the engine should interpret that before it opens a product lane.</p>
                </div>
                <div class="grid gap-4 md:grid-cols-2">
                    <label class="group block cursor-pointer">
                        <input class="peer sr-only" type="radio" name="directData" value="NONE" checked="${selection.directData() == ActionDirectDataStatus.NONE}">
                        <span class="flex h-full flex-col rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px group-hover:border-shell-border-strong peer-checked:border-teal-deep peer-checked:bg-teal-tint/60 peer-checked:shadow-float">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-slate-deep">No direct data yet</span>
                            <span class="mt-2 text-sm leading-6 text-slate-muted">No utility report, no official notice, and no private-well test exists yet.</span>
                        </span>
                    </label>
                    <label class="group block cursor-pointer">
                        <input class="peer sr-only" type="radio" name="directData" value="UTILITY_DOCUMENT" checked="${selection.directData() == ActionDirectDataStatus.UTILITY_DOCUMENT}">
                        <span class="flex h-full flex-col rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px group-hover:border-shell-border-strong peer-checked:border-teal-deep peer-checked:bg-teal-tint/60 peer-checked:shadow-float">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-slate-deep">Utility document</span>
                            <span class="mt-2 text-sm leading-6 text-slate-muted">A utility or system record exists and should drive interpretation before any comparison flow.</span>
                        </span>
                    </label>
                    <label class="group block cursor-pointer">
                        <input class="peer sr-only" type="radio" name="directData" value="OFFICIAL_NOTICE" checked="${selection.directData() == ActionDirectDataStatus.OFFICIAL_NOTICE}">
                        <span class="flex h-full flex-col rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px group-hover:border-shell-border-strong peer-checked:border-teal-deep peer-checked:bg-teal-tint/60 peer-checked:shadow-float">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-slate-deep">Official notice</span>
                            <span class="mt-2 text-sm leading-6 text-slate-muted">A utility or regulator has already published a direct PFAS notice for this household context.</span>
                        </span>
                    </label>
                    <label class="group block cursor-pointer">
                        <input class="peer sr-only" type="radio" name="directData" value="PRIVATE_WELL_TEST" checked="${selection.directData() == ActionDirectDataStatus.PRIVATE_WELL_TEST}">
                        <span class="flex h-full flex-col rounded-[18px] border border-shell-border bg-ivory px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px group-hover:border-shell-border-strong peer-checked:border-teal-deep peer-checked:bg-teal-tint/60 peer-checked:shadow-float">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-slate-deep">Private-well test</span>
                            <span class="mt-2 text-sm leading-6 text-slate-muted">A lab result exists and should be interpreted against state-specific reference context before shopping.</span>
                        </span>
                    </label>
                </div>
            </section>

            <section class="space-y-4">
                <div class="space-y-2">
                    <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">3. State model and current posture</span>
                    <p class="text-sm leading-7 text-slate-muted">These fields keep the routing state honest when the household is already mid-decision.</p>
                </div>
                <div class="grid gap-4 md:grid-cols-3">
                    <label class="space-y-2">
                        <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Indirect data</span>
                        <select class="block w-full rounded-[16px] border border-shell-border bg-ivory px-4 py-3 text-sm font-medium text-slate-deep outline-none transition duration-150 ease-out focus:border-teal-deep focus:ring-2 focus:ring-teal-deep/15" name="indirectData">
                            @for(var value : ActionIndirectDataStatus.values())
                                <option value="${value.name()}" selected="${value == selection.indirectData()}">${indirectDataLabel(value)}</option>
                            @endfor
                        </select>
                    </label>
                    <label class="space-y-2">
                        <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Benchmark relation</span>
                        <select class="block w-full rounded-[16px] border border-shell-border bg-ivory px-4 py-3 text-sm font-medium text-slate-deep outline-none transition duration-150 ease-out focus:border-teal-deep focus:ring-2 focus:ring-teal-deep/15" name="benchmarkRelation">
                            @for(var value : ActionBenchmarkRelation.values())
                                <option value="${value.name()}" selected="${value == selection.benchmarkRelation()}">${benchmarkRelationLabel(value)}</option>
                            @endfor
                        </select>
                    </label>
                    <label class="space-y-2">
                        <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Current filter</span>
                        <select class="block w-full rounded-[16px] border border-shell-border bg-ivory px-4 py-3 text-sm font-medium text-slate-deep outline-none transition duration-150 ease-out focus:border-teal-deep focus:ring-2 focus:ring-teal-deep/15" name="currentFilterStatus">
                            @for(var value : ActionCurrentFilterStatus.values())
                                <option value="${value.name()}" selected="${value == selection.currentFilterStatus()}">${currentFilterStatusLabel(value)}</option>
                            @endfor
                        </select>
                    </label>
                </div>
                <p class="text-sm leading-6 text-slate-muted">Benchmark relation is intentionally forced back to unknown when no direct data exists. The checker should not invent certainty.</p>
            </section>

            <section class="space-y-4">
                <div class="space-y-2">
                    <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">4. Shopping posture</span>
                    <p class="text-sm leading-7 text-slate-muted">Shopping intent is allowed into the model, but it cannot outrank missing evidence.</p>
                </div>
                <div class="grid gap-4 md:grid-cols-3">
                    <label class="group block cursor-pointer">
                        <input class="peer sr-only" type="radio" name="shoppingIntent" value="NONE" checked="${selection.shoppingIntent() == ActionShoppingIntent.NONE}">
                        <span class="flex h-full flex-col rounded-[18px] border border-shell-border bg-ivory px-5 py-4 transition duration-150 ease-out group-hover:-translate-y-px group-hover:border-shell-border-strong peer-checked:border-teal-deep peer-checked:bg-teal-tint/60">
                            <span class="text-base font-semibold tracking-[-0.02em] text-slate-deep">None</span>
                            <span class="mt-2 text-sm leading-6 text-slate-muted">Hold the interface in evidence collection mode.</span>
                        </span>
                    </label>
                    <label class="group block cursor-pointer">
                        <input class="peer sr-only" type="radio" name="shoppingIntent" value="FILTER_NOW" checked="${selection.shoppingIntent() == ActionShoppingIntent.FILTER_NOW}">
                        <span class="flex h-full flex-col rounded-[18px] border border-shell-border bg-ivory px-5 py-4 transition duration-150 ease-out group-hover:-translate-y-px group-hover:border-shell-border-strong peer-checked:border-teal-deep peer-checked:bg-teal-tint/60">
                            <span class="text-base font-semibold tracking-[-0.02em] text-slate-deep">Filter now</span>
                            <span class="mt-2 text-sm leading-6 text-slate-muted">The household wants immediate hardware guidance after interpretation opens.</span>
                        </span>
                    </label>
                    <label class="group block cursor-pointer">
                        <input class="peer sr-only" type="radio" name="shoppingIntent" value="COMPARE_OPTIONS" checked="${selection.shoppingIntent() == ActionShoppingIntent.COMPARE_OPTIONS}">
                        <span class="flex h-full flex-col rounded-[18px] border border-shell-border bg-ivory px-5 py-4 transition duration-150 ease-out group-hover:-translate-y-px group-hover:border-shell-border-strong peer-checked:border-teal-deep peer-checked:bg-teal-tint/60">
                            <span class="text-base font-semibold tracking-[-0.02em] text-slate-deep">Compare options</span>
                            <span class="mt-2 text-sm leading-6 text-slate-muted">Open the constrained point-of-use comparison layer after the route is understood.</span>
                        </span>
                    </label>
                </div>
            </section>

            <section class="space-y-4">
                <div class="space-y-2">
                    <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.22em] text-slate-soft">5. Seeded context</span>
                    <p class="text-sm leading-7 text-slate-muted">The router already knows how to branch into seeded state guidance and public-water dossiers. Use the relevant context for the selected source type.</p>
                </div>
                <div class="grid gap-4 md:grid-cols-2">
                    <label class="space-y-2">
                        <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Private-well state</span>
                        <select class="block w-full rounded-[16px] border border-shell-border bg-ivory px-4 py-3 text-sm font-medium text-slate-deep outline-none transition duration-150 ease-out focus:border-teal-deep focus:ring-2 focus:ring-teal-deep/15" name="stateCode">
                            @for(var state : states)
                                <option value="${state.stateCode()}" selected="${state.stateCode().equals(selection.stateCode())}">${state.stateCode()} - ${state.agencyName()}</option>
                            @endfor
                        </select>
                    </label>
                    <label class="space-y-2">
                        <span class="block text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Public-water system</span>
                        <select class="block w-full rounded-[16px] border border-shell-border bg-ivory px-4 py-3 text-sm font-medium text-slate-deep outline-none transition duration-150 ease-out focus:border-teal-deep focus:ring-2 focus:ring-teal-deep/15" name="pwsid">
                            @for(var system : systems)
                                <option value="${system.pwsid()}" selected="${system.pwsid().equals(selection.pwsid())}">${system.pwsName()} (${system.stateCode()})</option>
                            @endfor
                        </select>
                    </label>
                </div>
            </section>

            <section class="space-y-4">
                <div class="rounded-[18px] border border-shell-border bg-ivory px-5 py-5">
                    <label class="flex cursor-pointer items-start gap-3">
                        <input class="mt-1 h-4 w-4 rounded border-shell-border text-teal-deep focus:ring-teal-deep/20" type="checkbox" name="wholeHouseConsidered" value="true" checked="${selection.wholeHouseConsidered()}">
                        <span>
                            <span class="block text-sm font-semibold tracking-[-0.02em] text-slate-deep">Whole-house intent is being considered</span>
                            <span class="mt-1 block text-sm leading-6 text-slate-muted">This remains a guarded escalation path. It should not become the default outcome for ingestion-focused cases.</span>
                        </span>
                    </label>
                </div>
            </section>
        </div>

        <div class="mt-8 flex flex-wrap gap-3">
            <button class="inline-flex items-center justify-center rounded-full bg-teal-deep px-6 py-3 text-sm font-semibold text-white transition duration-150 ease-out hover:-translate-y-px hover:bg-slate-deep" type="submit">Run full route</button>
            <a class="inline-flex items-center justify-center rounded-full border border-shell-border-strong bg-ivory px-6 py-3 text-sm font-semibold text-slate-deep transition duration-150 ease-out hover:-translate-y-px hover:border-slate-muted/30" href="/checker">Reset</a>
        </div>
    </form>

    @template.fragments.checkerSummary(selection = selection, recommendation = recommendation)
</div>
