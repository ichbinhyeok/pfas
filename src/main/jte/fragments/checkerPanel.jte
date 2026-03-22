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
@param List<StateGuidance> featuredStates
@param List<PublicWaterSystem> systems
@param List<PublicWaterSystem> featuredSystems
@param List<PublicWaterSystem> featuredPennsylvaniaSystems
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

<div class="shell grid gap-8 xl:grid-cols-[minmax(0,1.08fr)_24rem]" id="checker-panel">
    <form class="order-2 surface-panel-strong overflow-hidden xl:order-1" method="get" action="/checker" hx-get="/checker/panel" hx-trigger="change from:input, change from:select" hx-target="#checker-panel" hx-swap="outerHTML">
        <section class="terminal-panel rounded-none border-0 shadow-none">
            <div class="grid gap-6 p-6 md:p-8 lg:grid-cols-[minmax(0,1fr)_21rem] lg:items-start">
                <div class="space-y-4">
                    <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Case intake</span>
                    <h2 class="text-3xl font-semibold tracking-[-0.04em] text-white md:text-[2.85rem] md:leading-[1.02]">Anchor the household first. <span class="font-serif font-medium text-white/76">Then let the engine open the next responsible move.</span></h2>
                    <p class="max-w-3xl text-base leading-8 text-white/68">Set the strongest evidence you actually have. The checker keeps uncertainty visible and suppresses premature shopping.</p>
                </div>

                <div class="space-y-3">
                    <div class="terminal-pane px-5 py-5">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/56">Current route</span>
                        <span class="mt-3 block text-base font-semibold tracking-[-0.02em] text-white">${recommendation.routeCode()}</span>
                        <span class="mt-1 block text-sm leading-6 text-white/62">${recommendation.tag()}</span>
                    </div>
                    <div class="rounded-[1rem] border border-primary/28 bg-primary/16 px-5 py-5 shadow-[0_1px_2px_rgba(15,24,32,0.06),0_16px_30px_rgba(15,24,32,0.12)]">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/74">Next action now</span>
                        <span class="mt-3 block text-base font-semibold tracking-[-0.02em] text-white">${recommendation.primaryLabel()}</span>
                        <span class="mt-1 block text-sm leading-6 text-white/68">This is the first path opened from the current state.</span>
                    </div>
                </div>
            </div>

            <div class="terminal-grid border-x-0 border-b-0 rounded-none md:grid-cols-4">
                <div class="px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Source</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${waterSourceLabel(selection.waterSource())}</div>
                </div>
                <div class="px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Direct evidence</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${directDataLabel(selection.directData())}</div>
                </div>
                <div class="px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Benchmark</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${benchmarkRelationLabel(selection.benchmarkRelation())}</div>
                </div>
                <div class="px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Hardware</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${currentFilterStatusLabel(selection.currentFilterStatus())}</div>
                </div>
            </div>
        </section>

        <div class="divide-y divide-base-300/70">
            <section class="grid gap-5 bg-base-100 px-6 py-8 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">1. Household source</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Choose the evidence system.</h3>
                    <p class="text-sm leading-7 text-base-content/62">Public-water and private-well cases should not share assumptions.</p>
                </div>
                <div class="grid gap-4 md:grid-cols-2">
                    <label class="group cursor-pointer">
                        <input class="peer sr-only" type="radio" name="waterSource" value="PUBLIC_WATER" checked="${selection.waterSource() == ActionWaterSource.PUBLIC_WATER}">
                        <div class="rounded-[1rem] border border-base-300/70 bg-base-200/42 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-base-content">Public water</span>
                            <p class="mt-2 text-sm leading-6 text-base-content/64">Use utility records, CCRs, and direct notices first.</p>
                        </div>
                    </label>
                    <label class="group cursor-pointer">
                        <input class="peer sr-only" type="radio" name="waterSource" value="PRIVATE_WELL" checked="${selection.waterSource() == ActionWaterSource.PRIVATE_WELL}">
                        <div class="rounded-[1rem] border border-base-300/70 bg-base-200/42 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                            <span class="text-lg font-semibold tracking-[-0.02em] text-base-content">Private well</span>
                            <p class="mt-2 text-sm leading-6 text-base-content/64">Use state-guided testing and lab interpretation first.</p>
                        </div>
                    </label>
                </div>
            </section>

            <section class="grid gap-5 bg-base-200/46 px-6 py-8 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
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
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">No direct record yet</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">No CCR, system document, or notice is in hand.</p>
                                </div>
                            </label>
                            <label class="group cursor-pointer">
                                <input class="peer sr-only" type="radio" name="directData" value="UTILITY_DOCUMENT" checked="${selection.directData() == ActionDirectDataStatus.UTILITY_DOCUMENT}">
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Utility document</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">A CCR or system report exists and should drive interpretation.</p>
                                </div>
                            </label>
                            <label class="group cursor-pointer">
                                <input class="peer sr-only" type="radio" name="directData" value="OFFICIAL_NOTICE" checked="${selection.directData() == ActionDirectDataStatus.OFFICIAL_NOTICE}">
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Official notice</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">A regulator or utility has already issued direct PFAS context.</p>
                                </div>
                            </label>
                        </div>
                    @else
                        <div class="grid gap-4 md:grid-cols-2">
                            <label class="group cursor-pointer">
                                <input class="peer sr-only" type="radio" name="directData" value="NONE" checked="${selection.directData() == ActionDirectDataStatus.NONE}">
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">No well test yet</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">The route stays in sampling and lab setup mode.</p>
                                </div>
                            </label>
                            <label class="group cursor-pointer">
                                <input class="peer sr-only" type="radio" name="directData" value="PRIVATE_WELL_TEST" checked="${selection.directData() == ActionDirectDataStatus.PRIVATE_WELL_TEST}">
                                <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                    <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Private-well test</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">A lab result exists and can be interpreted against the state context.</p>
                                </div>
                            </label>
                        </div>
                    @endif
                    <div class="surface-muted px-5 py-4 text-sm leading-7 text-base-content/72">
                        <strong class="font-semibold text-base-content">Routing effect</strong> Missing direct evidence collapses benchmark certainty and blocks premature shopping.
                    </div>
                </div>
            </section>

            <section class="grid gap-5 bg-base-100 px-6 py-8 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
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
                    <div class="surface-muted px-5 py-4 text-sm leading-7 text-base-content/68">
                        <strong class="font-semibold text-base-content">Model limit</strong> Without direct evidence, benchmark relation stays unresolved even if concern or shopping intent is high.
                    </div>
                </div>
            </section>

            <section class="grid gap-5 bg-base-200/46 px-6 py-8 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">4. Decision context</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Show the engine where this case lives.</h3>
                    <p class="text-sm leading-7 text-base-content/62">Context narrows the route without overriding the evidence hierarchy.</p>
                </div>
                <div class="space-y-4">
                    <div class="grid gap-4 md:grid-cols-3">
                        <label class="group cursor-pointer">
                            <input class="peer sr-only" type="radio" name="shoppingIntent" value="NONE" checked="${selection.shoppingIntent() == ActionShoppingIntent.NONE}">
                            <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Hold</span>
                                <p class="mt-2 text-sm leading-6 text-base-content/64">Stay in evidence and interpretation mode.</p>
                            </div>
                        </label>
                        <label class="group cursor-pointer">
                            <input class="peer sr-only" type="radio" name="shoppingIntent" value="FILTER_NOW" checked="${selection.shoppingIntent() == ActionShoppingIntent.FILTER_NOW}">
                            <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Filter now</span>
                                <p class="mt-2 text-sm leading-6 text-base-content/64">Open hardware only when the route allows it.</p>
                            </div>
                        </label>
                        <label class="group cursor-pointer">
                            <input class="peer sr-only" type="radio" name="shoppingIntent" value="COMPARE_OPTIONS" checked="${selection.shoppingIntent() == ActionShoppingIntent.COMPARE_OPTIONS}">
                            <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
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
                                @if(!featuredStates.isEmpty())
                                    <div class="mt-4 space-y-2">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-primary/76">Expanded state coverage</span>
                                        <div class="flex flex-wrap gap-2">
                                            @for(var state : featuredStates)
                                                <a class="badge badge-outline border-primary/22 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content transition duration-150 ease-out hover:-translate-y-px hover:border-primary hover:text-primary" href="/checker?waterSource=PRIVATE_WELL&directData=NONE&benchmarkRelation=UNKNOWN&currentFilterStatus=NONE&shoppingIntent=NONE&wholeHouseConsidered=false&stateCode=${state.stateCode()}">${state.stateCode()} route</a>
                                            @endfor
                                        </div>
                                    </div>
                                    <div class="mt-4 rounded-[0.95rem] border border-primary/14 bg-base-100 px-4 py-4">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-primary/76">State-led private-well lanes</span>
                                        <p class="mt-2 text-sm leading-6 text-base-content/64">Open the exact state route first, then use the private-well compare lane only after a result is interpretable inside that state posture.</p>
                                        <div class="mt-3 grid gap-3 md:grid-cols-2">
                                            @for(var state : featuredStates)
                                                <a class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 transition duration-150 ease-out hover:-translate-y-px hover:border-primary" href="/private-well/${state.stateCode()}" data-route-click-track="true" data-route-click-id="checker:state-lane:${state.stateCode()}" data-route-click-source-page="/checker" data-route-click-target-path="/private-well/${state.stateCode()}" data-route-click-cta-slot="checker_state_lane" data-route-click-family="checker_private_well_lane" data-route-click-lane="${state.stateCode()}_private_well" data-route-click-region="${state.stateCode()}">
                                                    <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">${state.stateCode()} guide</span>
                                                    <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-base-content">${state.agencyName()}</span>
                                                </a>
                                            @endfor
                                        </div>
                                        <div class="mt-3 flex flex-wrap gap-2">
                                            <a class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content transition duration-150 ease-out hover:-translate-y-px hover:border-primary hover:text-primary" href="/guides/private-well-pfas-result-next-steps" data-route-click-track="true" data-route-click-id="checker:private-well:guide" data-route-click-source-page="/checker" data-route-click-target-path="/guides/private-well-pfas-result-next-steps" data-route-click-cta-slot="checker_private_well_guide" data-route-click-family="checker_private_well_lane" data-route-click-lane="state_led_private_well" data-route-click-region="multi">Private-well guide</a>
                                            <a class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content transition duration-150 ease-out hover:-translate-y-px hover:border-primary hover:text-primary" href="/compare/private-well-certified-pou-after-test" data-route-click-track="true" data-route-click-id="checker:private-well:compare" data-route-click-source-page="/checker" data-route-click-target-path="/compare/private-well-certified-pou-after-test" data-route-click-cta-slot="checker_private_well_compare" data-route-click-family="checker_private_well_lane" data-route-click-lane="state_led_private_well" data-route-click-region="multi">Private-well compare</a>
                                        </div>
                                    </div>
                                @endif
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
                                @if(!featuredSystems.isEmpty())
                                    <div class="mt-4 space-y-2">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-primary/76">Curated dossier routes</span>
                                        <div class="flex flex-wrap gap-2">
                                            @for(var system : featuredSystems)
                                                <a class="badge badge-outline border-primary/22 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content transition duration-150 ease-out hover:-translate-y-px hover:border-primary hover:text-primary" href="/checker?waterSource=PUBLIC_WATER&directData=UTILITY_DOCUMENT&indirectData=NONE&benchmarkRelation=UNKNOWN&currentFilterStatus=NONE&shoppingIntent=NONE&wholeHouseConsidered=false&pwsid=${system.pwsid()}">${system.pwsName()} (${system.stateCode()})</a>
                                            @endfor
                                        </div>
                                    </div>
                                @endif
                                @if(!featuredPennsylvaniaSystems.isEmpty())
                                    <div class="mt-4 rounded-[0.95rem] border border-primary/14 bg-base-100 px-4 py-4">
                                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-primary/76">Pennsylvania dossier cluster</span>
                                        <p class="mt-2 text-sm leading-6 text-base-content/64">Use the Pennsylvania record set to compare a notice-driven metro system, a regional authority, and two smaller utility dossiers without leaving the evidence-first lane.</p>
                                        <div class="mt-3 flex flex-wrap gap-2">
                                            @for(var system : featuredPennsylvaniaSystems)
                                                <a class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.14em] text-base-content transition duration-150 ease-out hover:-translate-y-px hover:border-primary hover:text-primary" href="/checker?waterSource=PUBLIC_WATER&directData=UTILITY_DOCUMENT&indirectData=NONE&benchmarkRelation=UNKNOWN&currentFilterStatus=NONE&shoppingIntent=NONE&wholeHouseConsidered=false&pwsid=${system.pwsid()}">${system.pwsName()}</a>
                                            @endfor
                                        </div>
                                    </div>
                                @endif
                                <div class="mt-4 rounded-[0.95rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                    <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-primary/76">Regional dossier lanes</span>
                                    <p class="mt-2 text-sm leading-6 text-base-content/64">Use regional guides and compares only as downstream navigation. The exact utility dossier still decides whether the route stays interpretive or opens point-of-use.</p>
                                    <div class="mt-3 grid gap-3 md:grid-cols-2">
                                        <a class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 transition duration-150 ease-out hover:-translate-y-px hover:border-primary" href="/guides/pennsylvania-pfas-utility-records" data-route-click-track="true" data-route-click-id="checker:pa-corridor:guide" data-route-click-source-page="/checker" data-route-click-target-path="/guides/pennsylvania-pfas-utility-records" data-route-click-cta-slot="checker_regional_guide" data-route-click-family="checker_regional_corridor" data-route-click-lane="pennsylvania_corridor" data-route-click-region="PA">
                                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Pennsylvania guide</span>
                                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-base-content">Read the Pennsylvania dossier cluster</span>
                                        </a>
                                        <a class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 transition duration-150 ease-out hover:-translate-y-px hover:border-primary" href="/compare/pennsylvania-certified-pou-after-utility-context" data-route-click-track="true" data-route-click-id="checker:pa-corridor:compare" data-route-click-source-page="/checker" data-route-click-target-path="/compare/pennsylvania-certified-pou-after-utility-context" data-route-click-cta-slot="checker_regional_compare" data-route-click-family="checker_regional_corridor" data-route-click-lane="pennsylvania_corridor" data-route-click-region="PA">
                                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Pennsylvania compare</span>
                                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-base-content">Open the Pennsylvania post-utility lane</span>
                                        </a>
                                        <a class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 transition duration-150 ease-out hover:-translate-y-px hover:border-primary" href="/guides/new-jersey-pfas-utility-records" data-route-click-track="true" data-route-click-id="checker:nj-corridor:guide" data-route-click-source-page="/checker" data-route-click-target-path="/guides/new-jersey-pfas-utility-records" data-route-click-cta-slot="checker_regional_guide" data-route-click-family="checker_regional_corridor" data-route-click-lane="new_jersey_corridor" data-route-click-region="NJ">
                                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">New Jersey guide</span>
                                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-base-content">Read the New Jersey utility pair</span>
                                        </a>
                                        <a class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 transition duration-150 ease-out hover:-translate-y-px hover:border-primary" href="/compare/new-jersey-certified-pou-after-utility-context" data-route-click-track="true" data-route-click-id="checker:nj-corridor:compare" data-route-click-source-page="/checker" data-route-click-target-path="/compare/new-jersey-certified-pou-after-utility-context" data-route-click-cta-slot="checker_regional_compare" data-route-click-family="checker_regional_corridor" data-route-click-lane="new_jersey_corridor" data-route-click-region="NJ">
                                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">New Jersey compare</span>
                                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-base-content">Open the New Jersey post-utility lane</span>
                                        </a>
                                        <a class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 transition duration-150 ease-out hover:-translate-y-px hover:border-primary" href="/guides/california-pfas-utility-records" data-route-click-track="true" data-route-click-id="checker:ca-corridor:guide" data-route-click-source-page="/checker" data-route-click-target-path="/guides/california-pfas-utility-records" data-route-click-cta-slot="checker_regional_guide" data-route-click-family="checker_regional_corridor" data-route-click-lane="california_corridor" data-route-click-region="CA">
                                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">California guide</span>
                                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-base-content">Read the California utility pair</span>
                                        </a>
                                        <a class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 transition duration-150 ease-out hover:-translate-y-px hover:border-primary" href="/compare/california-certified-pou-after-utility-context" data-route-click-track="true" data-route-click-id="checker:ca-corridor:compare" data-route-click-source-page="/checker" data-route-click-target-path="/compare/california-certified-pou-after-utility-context" data-route-click-cta-slot="checker_regional_compare" data-route-click-family="checker_regional_corridor" data-route-click-lane="california_corridor" data-route-click-region="CA">
                                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">California compare</span>
                                            <span class="mt-2 block text-sm font-semibold tracking-[-0.02em] text-base-content">Open the California post-utility lane</span>
                                        </a>
                                    </div>
                                </div>
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

            <section class="grid gap-5 bg-base-100 px-6 py-8 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">5. Guardrails</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Keep escalation explicit.</h3>
                    <p class="text-sm leading-7 text-base-content/62">Whole-house interest can be recorded, but it never becomes the default route.</p>
                </div>
                <div class="space-y-4">
                    <label class="flex cursor-pointer items-start gap-4 rounded-[1rem] border border-accent/20 bg-[rgba(120,104,90,0.08)] px-5 py-5">
                        <input class="checkbox checkbox-primary mt-1 border-base-300 bg-base-100" type="checkbox" name="wholeHouseConsidered" value="true" checked="${selection.wholeHouseConsidered()}">
                        <span class="space-y-2">
                            <span class="block text-sm font-semibold tracking-[-0.02em] text-base-content">Whole-house is being considered</span>
                            <span class="block text-sm leading-7 text-base-content/68">The engine treats this as a guarded escalation and compares it against narrower point-of-use routes first.</span>
                        </span>
                    </label>

                    <div class="flex flex-wrap items-center justify-between gap-4 rounded-[1rem] border border-base-300/70 bg-base-200/52 px-5 py-5">
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
