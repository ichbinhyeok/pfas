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
@import static com.example.pfas.web.PresentationText.directDataLabel
@import static com.example.pfas.web.PresentationText.indirectDataLabel
@import static com.example.pfas.web.PresentationText.waterSourceLabel
@param List<StateGuidance> states
@param List<PublicWaterSystem> systems
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

<div class="shell grid gap-8 xl:grid-cols-[minmax(0,1.08fr)_24rem]" id="checker-panel">
    <form class="order-2 overflow-hidden rounded-[1.5rem] border border-base-300/70 bg-base-100/96 shadow-[var(--shadow-panel)] xl:order-1" method="get" action="/checker" hx-get="/checker/panel" hx-trigger="change from:input, change from:select" hx-target="#checker-panel" hx-swap="outerHTML">
        <section class="bg-neutral text-neutral-content">
            <div class="grid gap-6 p-6 md:p-8 lg:grid-cols-[minmax(0,1fr)_21rem] lg:items-start">
                <div class="space-y-4">
                    <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Case intake</span>
                    <h2 class="text-3xl font-semibold tracking-[-0.04em] text-white md:text-[2.85rem] md:leading-[1.02]">Anchor the household first. <span class="font-serif font-medium text-white/76">Then let the engine open the next responsible move.</span></h2>
                    <p class="max-w-3xl text-base leading-8 text-white/68">Set the strongest evidence you actually have. The checker keeps uncertainty visible and suppresses premature shopping.</p>
                </div>

                <div class="space-y-3">
                    <div class="rounded-[1rem] border border-white/10 bg-white/6 px-5 py-5">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/56">Current route</span>
                        <span class="mt-3 block text-base font-semibold tracking-[-0.02em] text-white">${recommendation.routeCode()}</span>
                        <span class="mt-1 block text-sm leading-6 text-white/62">${recommendation.tag()}</span>
                    </div>
                    <div class="rounded-[1rem] border border-primary/20 bg-primary/14 px-5 py-5">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/74">Next action now</span>
                        <span class="mt-3 block text-base font-semibold tracking-[-0.02em] text-white">${recommendation.primaryLabel()}</span>
                        <span class="mt-1 block text-sm leading-6 text-white/68">This is the first path opened from the current state.</span>
                    </div>
                </div>
            </div>

            <div class="grid gap-px border-t border-white/8 bg-white/8 md:grid-cols-4">
                <div class="bg-white/3 px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Source</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${waterSourceLabel(selection.waterSource())}</div>
                </div>
                <div class="bg-white/3 px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Direct evidence</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${directDataLabel(selection.directData())}</div>
                </div>
                <div class="bg-white/3 px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Benchmark</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${benchmarkRelationLabel(selection.benchmarkRelation())}</div>
                </div>
                <div class="bg-white/3 px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Hardware</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${currentFilterStatusLabel(selection.currentFilterStatus())}</div>
                </div>
            </div>
        </section>

        <div class="divide-y divide-base-300/70">
            <section class="grid gap-5 bg-base-100 px-6 py-7 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">1. Household source</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Choose the evidence system.</h3>
                    <p class="text-sm leading-7 text-base-content/62">Public-water and private-well cases should not share assumptions.</p>
                </div>
                <div class="grid gap-4 md:grid-cols-2">
                    <label class="group cursor-pointer">
                        <input class="peer sr-only" type="radio" name="waterSource" value="PUBLIC_WATER" checked="${selection.waterSource() == ActionWaterSource.PUBLIC_WATER}">
                        <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-base-content">Public water</span>
                            <p class="mt-2 text-sm leading-6 text-base-content/64">Use utility records, CCRs, and direct notices first.</p>
                        </div>
                    </label>
                    <label class="group cursor-pointer">
                        <input class="peer sr-only" type="radio" name="waterSource" value="PRIVATE_WELL" checked="${selection.waterSource() == ActionWaterSource.PRIVATE_WELL}">
                        <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-base-content">Private well</span>
                            <p class="mt-2 text-sm leading-6 text-base-content/64">Use state-guided testing and lab interpretation first.</p>
                        </div>
                    </label>
                </div>
            </section>

            <section class="grid gap-5 bg-base-200/34 px-6 py-7 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">2. Direct evidence</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Choose the strongest direct record.</h3>
                    <p class="text-sm leading-7 text-base-content/62">This step determines whether the engine interprets or keeps collecting evidence.</p>
                </div>
                <div class="space-y-4">
                    @if(selection.waterSource() == ActionWaterSource.PUBLIC_WATER)
                        <div class="grid gap-4 md:grid-cols-3">
                            <label class="group cursor-pointer">
                                <input class="peer sr-only" type="radio" name="directData" value="NONE" checked="${selection.directData() == ActionDirectDataStatus.NONE}">
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">No direct record yet</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">No CCR, system document, or notice is in hand.</p>
                                </div>
                            </label>
                            <label class="group cursor-pointer">
                                <input class="peer sr-only" type="radio" name="directData" value="UTILITY_DOCUMENT" checked="${selection.directData() == ActionDirectDataStatus.UTILITY_DOCUMENT}">
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Utility document</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">A CCR or system report exists and should drive interpretation.</p>
                                </div>
                            </label>
                            <label class="group cursor-pointer">
                                <input class="peer sr-only" type="radio" name="directData" value="OFFICIAL_NOTICE" checked="${selection.directData() == ActionDirectDataStatus.OFFICIAL_NOTICE}">
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Official notice</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">A regulator or utility has already issued direct PFAS context.</p>
                                </div>
                            </label>
                        </div>
                    @else
                        <div class="grid gap-4 md:grid-cols-2">
                            <label class="group cursor-pointer">
                                <input class="peer sr-only" type="radio" name="directData" value="NONE" checked="${selection.directData() == ActionDirectDataStatus.NONE}">
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">No well test yet</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">The route stays in sampling and lab setup mode.</p>
                                </div>
                            </label>
                            <label class="group cursor-pointer">
                                <input class="peer sr-only" type="radio" name="directData" value="PRIVATE_WELL_TEST" checked="${selection.directData() == ActionDirectDataStatus.PRIVATE_WELL_TEST}">
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Private-well test</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">A lab result exists and can be interpreted against the state context.</p>
                                </div>
                            </label>
                        </div>
                    @endif
                    <div class="rounded-[1rem] border border-primary/10 bg-primary/5 px-5 py-4 text-sm leading-7 text-base-content/72">
                        <strong class="font-semibold text-base-content">Routing effect</strong> Missing direct evidence collapses benchmark certainty and blocks premature shopping.
                    </div>
                </div>
            </section>

            <section class="grid gap-5 bg-base-100 px-6 py-7 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">3. Interpretation posture</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Describe the current case, not your fear level.</h3>
                    <p class="text-sm leading-7 text-base-content/62">These fields keep the route honest once a case is already moving.</p>
                </div>
                <div class="space-y-4">
                    <div class="grid gap-4 md:grid-cols-3">
                        @if(selection.waterSource() == ActionWaterSource.PUBLIC_WATER)
                            <label class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Indirect context</span>
                                <select class="form-select select mt-3 w-full rounded-[0.95rem] border-base-300 bg-base-100 text-sm font-medium text-base-content" name="indirectData">
                                    @for(var value : ActionIndirectDataStatus.values())
                                        <option value="${value.name()}" selected="${value == selection.indirectData()}">${indirectDataLabel(value)}</option>
                                    @endfor
                                </select>
                            </label>
                        @else
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-200/44 px-4 py-4">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Indirect context</span>
                                <div class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">Closed for private wells</div>
                                <p class="mt-2 text-sm leading-6 text-base-content/62">Private-well routes do not inherit utility-style screening context.</p>
                            </article>
                        @endif

                        <label class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Benchmark relation</span>
                            <select class="form-select select mt-3 w-full rounded-[0.95rem] border-base-300 bg-base-100 text-sm font-medium text-base-content" name="benchmarkRelation">
                                @for(var value : ActionBenchmarkRelation.values())
                                    <option value="${value.name()}" selected="${value == selection.benchmarkRelation()}">${benchmarkRelationLabel(value)}</option>
                                @endfor
                            </select>
                        </label>

                        <label class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Current filter</span>
                            <select class="form-select select mt-3 w-full rounded-[0.95rem] border-base-300 bg-base-100 text-sm font-medium text-base-content" name="currentFilterStatus">
                                @for(var value : ActionCurrentFilterStatus.values())
                                    <option value="${value.name()}" selected="${value == selection.currentFilterStatus()}">${currentFilterStatusLabel(value)}</option>
                                @endfor
                            </select>
                        </label>
                    </div>
                    <div class="rounded-[1rem] border border-base-300/70 bg-base-200/44 px-5 py-4 text-sm leading-7 text-base-content/68">
                        <strong class="font-semibold text-base-content">Model limit</strong> Without direct evidence, benchmark relation stays unresolved even if concern or shopping intent is high.
                    </div>
                </div>
            </section>

            <section class="grid gap-5 bg-base-200/34 px-6 py-7 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">4. Decision context</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Show the engine where this case lives.</h3>
                    <p class="text-sm leading-7 text-base-content/62">Context narrows the route without overriding the evidence hierarchy.</p>
                </div>
                <div class="space-y-4">
                    <div class="grid gap-4 md:grid-cols-3">
                        <label class="group cursor-pointer">
                            <input class="peer sr-only" type="radio" name="shoppingIntent" value="NONE" checked="${selection.shoppingIntent() == ActionShoppingIntent.NONE}">
                            <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                                <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Hold</span>
                                <p class="mt-2 text-sm leading-6 text-base-content/64">Stay in evidence and interpretation mode.</p>
                            </div>
                        </label>
                        <label class="group cursor-pointer">
                            <input class="peer sr-only" type="radio" name="shoppingIntent" value="FILTER_NOW" checked="${selection.shoppingIntent() == ActionShoppingIntent.FILTER_NOW}">
                            <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                                <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Filter now</span>
                                <p class="mt-2 text-sm leading-6 text-base-content/64">Open hardware only when the route allows it.</p>
                            </div>
                        </label>
                        <label class="group cursor-pointer">
                            <input class="peer sr-only" type="radio" name="shoppingIntent" value="COMPARE_OPTIONS" checked="${selection.shoppingIntent() == ActionShoppingIntent.COMPARE_OPTIONS}">
                            <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-primary/6">
                                <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Compare</span>
                                <p class="mt-2 text-sm leading-6 text-base-content/64">Open constrained point-of-use comparison after interpretation.</p>
                            </div>
                        </label>
                    </div>

                    <div class="grid gap-4 md:grid-cols-[minmax(0,1fr)_18rem]">
                        @if(selection.waterSource() == ActionWaterSource.PRIVATE_WELL)
                            <label class="block rounded-[1rem] border border-primary/12 bg-primary/5 px-4 py-4">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-primary">Private-well state</span>
                                <select class="form-select select mt-3 w-full rounded-[0.95rem] border-base-300 bg-base-100 text-sm font-medium text-base-content" name="stateCode">
                                    @for(var state : states)
                                        <option value="${state.stateCode()}" selected="${state.stateCode().equals(selection.stateCode())}">${state.stateCode()} - ${state.agencyName()}</option>
                                    @endfor
                                </select>
                            </label>
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-200/44 px-4 py-4">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Utility dossiers</span>
                                <div class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">Inactive in this case</div>
                                <p class="mt-2 text-sm leading-6 text-base-content/62">System records matter only on public water.</p>
                            </article>
                        @else
                            <label class="block rounded-[1rem] border border-primary/12 bg-primary/5 px-4 py-4">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-primary">Public-water system</span>
                                <select class="form-select select mt-3 w-full rounded-[0.95rem] border-base-300 bg-base-100 text-sm font-medium text-base-content" name="pwsid">
                                    @for(var system : systems)
                                        <option value="${system.pwsid()}" selected="${system.pwsid().equals(selection.pwsid())}">${system.pwsName()} (${system.stateCode()})</option>
                                    @endfor
                                </select>
                            </label>
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-200/44 px-4 py-4">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">State lab guide</span>
                                <div class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">Inactive in this case</div>
                                <p class="mt-2 text-sm leading-6 text-base-content/62">State selection becomes primary only for private wells.</p>
                            </article>
                        @endif
                    </div>
                </div>
            </section>

            <section class="grid gap-5 bg-base-100 px-6 py-7 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">5. Guardrails</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Keep escalation explicit.</h3>
                    <p class="text-sm leading-7 text-base-content/62">Whole-house interest can be recorded, but it never becomes the default route.</p>
                </div>
                <div class="space-y-4">
                    <label class="flex cursor-pointer items-start gap-4 rounded-[1rem] border border-accent/18 bg-accent/7 px-5 py-5">
                        <input class="checkbox checkbox-sm checkbox-primary mt-1 border-base-300 bg-base-100" type="checkbox" name="wholeHouseConsidered" value="true" checked="${selection.wholeHouseConsidered()}">
                        <span class="space-y-2">
                            <span class="block text-sm font-semibold tracking-[-0.02em] text-base-content">Whole-house is being considered</span>
                            <span class="block text-sm leading-7 text-base-content/68">The engine treats this as a guarded escalation and compares it against narrower point-of-use routes first.</span>
                        </span>
                    </label>

                    <div class="flex flex-wrap items-center justify-between gap-4 rounded-[1rem] border border-base-300/70 bg-base-200/44 px-5 py-5">
                        <div class="space-y-1">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Submission posture</span>
                            <p class="text-sm leading-7 text-base-content/66">Run the full route when the case description feels honest. Reset if you want to clear the posture.</p>
                        </div>
                        <div class="join join-vertical gap-3 sm:join-horizontal">
                            <button class="btn btn-primary join-item h-11 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" type="submit">Run full route</button>
                            <a class="btn btn-outline join-item h-11 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/checker">Reset</a>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </form>

    @template.fragments.checkerSummary(selection = selection, recommendation = recommendation)
</div>
