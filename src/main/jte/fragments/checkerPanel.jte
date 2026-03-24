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
    <form class="order-2 surface-panel-strong overflow-hidden xl:order-1" method="get" action="/checker" hx-get="/checker/panel" hx-trigger="change from:input[name='waterSource'], change from:input[name='directData']" hx-target="#checker-panel" hx-swap="outerHTML">
        <section class="terminal-panel rounded-none border-0 shadow-none">
            <div class="grid gap-6 p-6 md:p-8 lg:grid-cols-[minmax(0,1fr)_21rem] lg:items-start">
                <div class="space-y-4">
                    <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Quick intake</span>
                    <h2 class="text-3xl font-semibold tracking-[-0.04em] text-white md:text-[2.85rem] md:leading-[1.02]">Tell us what you already know. <span class="font-serif font-medium text-white/76">We'll narrow the next step from there.</span></h2>
                    <p class="max-w-3xl text-base leading-8 text-white/68">Start simple: where your drinking water comes from, whether you already have a record, and whether you are only trying to understand or already ready to compare.</p>
                </div>

                <div class="space-y-3">
                    <div class="terminal-pane px-5 py-5">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/56">Current recommendation</span>
                        <span class="mt-3 block text-base font-semibold tracking-[-0.02em] text-white">${recommendation.title()}</span>
                        <span class="mt-1 block text-sm leading-6 text-white/62">${recommendation.summary()}</span>
                    </div>
                    <div class="rounded-[1rem] border border-primary/28 bg-primary/16 px-5 py-5 shadow-[0_1px_2px_rgba(15,24,32,0.06),0_16px_30px_rgba(15,24,32,0.12)]">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/74">Best next page</span>
                        <span class="mt-3 block text-base font-semibold tracking-[-0.02em] text-white">${recommendation.primaryLabel()}</span>
                        <span class="mt-1 block text-sm leading-6 text-white/68">Use this when you are ready to leave the checker and open the next step.</span>
                    </div>
                </div>
            </div>

            <div class="terminal-grid border-x-0 border-b-0 rounded-none md:grid-cols-4">
                <div class="px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Water source</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${waterSourceLabel(selection.waterSource())}</div>
                </div>
                <div class="px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Record in hand</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${directDataLabel(selection.directData())}</div>
                </div>
                <div class="px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Result status</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${benchmarkRelationLabel(selection.benchmarkRelation())}</div>
                </div>
                <div class="px-6 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-white/48">Current filter</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-white">${currentFilterStatusLabel(selection.currentFilterStatus())}</div>
                </div>
            </div>
        </section>

        <div class="divide-y divide-base-300/70">
            <section class="grid gap-5 bg-base-100 px-6 py-8 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">1. Household source</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Where does your drinking water come from?</h3>
                    <p class="text-sm leading-7 text-base-content/62">This is the first split. Public-water and private-well routes use different records and different next steps.</p>
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
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Do you already have a report or test result?</h3>
                    <p class="text-sm leading-7 text-base-content/62">If not, the checker will keep you in evidence-gathering mode instead of pushing you into product pages.</p>
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
                        <strong class="font-semibold text-base-content">Why this matters</strong> If you do not have a direct record yet, the site will slow down and point you to the right reading or testing page first.
                    </div>
                </div>
            </section>

            <section class="grid gap-5 bg-base-100 px-6 py-8 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">3. What the record shows</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">What does the record say right now?</h3>
                    <p class="text-sm leading-7 text-base-content/62">Use these fields to describe the actual result on hand, not the worst-case outcome you are worried about.</p>
                </div>
                <div class="space-y-4">
                    <div class="grid gap-4 md:grid-cols-3">
                        @if(selection.waterSource() == ActionWaterSource.PUBLIC_WATER)
                            <label class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Other context</span>
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
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">How the result compares</span>
                            <select class="form-select select mt-3 w-full rounded-[0.95rem] border-base-300 bg-base-100 text-sm font-medium text-base-content" name="benchmarkRelation">
                                @for(var value : ActionBenchmarkRelation.values())
                                    <option value="${value.name()}" selected="${value == selection.benchmarkRelation()}">${benchmarkRelationLabel(value)}</option>
                                @endfor
                            </select>
                        </label>

                        <label class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Filter you already use</span>
                            <select class="form-select select mt-3 w-full rounded-[0.95rem] border-base-300 bg-base-100 text-sm font-medium text-base-content" name="currentFilterStatus">
                                @for(var value : ActionCurrentFilterStatus.values())
                                    <option value="${value.name()}" selected="${value == selection.currentFilterStatus()}">${currentFilterStatusLabel(value)}</option>
                                @endfor
                            </select>
                        </label>
                    </div>
                    <div class="surface-muted px-5 py-4 text-sm leading-7 text-base-content/68">
                        <strong class="font-semibold text-base-content">Important</strong> Without a direct record, the checker keeps this unresolved even if concern or shopping intent is high.
                    </div>
                </div>
            </section>

            <section class="grid gap-5 bg-base-200/46 px-6 py-8 md:px-8 lg:grid-cols-[13rem_minmax(0,1fr)]">
                <div class="space-y-2">
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">4. Decision context</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">What are you trying to do right now?</h3>
                    <p class="text-sm leading-7 text-base-content/62">These answers help narrow the route, but they do not override the record itself.</p>
                </div>
                <div class="space-y-4">
                    <div class="grid gap-4 md:grid-cols-3">
                        <label class="group cursor-pointer">
                            <input class="peer sr-only" type="radio" name="shoppingIntent" value="NONE" checked="${selection.shoppingIntent() == ActionShoppingIntent.NONE}">
                            <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Interpret only</span>
                                <p class="mt-2 text-sm leading-6 text-base-content/64">Stay with the record and the explanation.</p>
                            </div>
                        </label>
                        <label class="group cursor-pointer">
                            <input class="peer sr-only" type="radio" name="shoppingIntent" value="FILTER_NOW" checked="${selection.shoppingIntent() == ActionShoppingIntent.FILTER_NOW}">
                            <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Shop filters</span>
                                <p class="mt-2 text-sm leading-6 text-base-content/64">Open product pages only if the route supports that step.</p>
                            </div>
                        </label>
                        <label class="group cursor-pointer">
                            <input class="peer sr-only" type="radio" name="shoppingIntent" value="COMPARE_OPTIONS" checked="${selection.shoppingIntent() == ActionShoppingIntent.COMPARE_OPTIONS}">
                            <div class="rounded-[1rem] border border-base-300/70 bg-base-200/38 px-5 py-5 transition duration-150 ease-out group-hover:-translate-y-px peer-checked:border-primary peer-checked:bg-base-100 peer-checked:shadow-[var(--shadow-soft)]">
                                <span class="text-base font-semibold tracking-[-0.02em] text-base-content">Compare options</span>
                                <p class="mt-2 text-sm leading-6 text-base-content/64">Open a compare lane after the record has been interpreted.</p>
                            </div>
                        </label>
                    </div>

                    <div class="grid gap-4 md:grid-cols-[minmax(0,1fr)_18rem]">
                        @if(selection.waterSource() == ActionWaterSource.PRIVATE_WELL)
                            <div class="block rounded-[1rem] border border-primary/12 bg-primary/5 px-4 py-4">
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
                            </div>
                            <article class="rounded-[1rem] border border-base-300/70 bg-base-200/44 px-4 py-4">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Utility dossiers</span>
                                <div class="mt-3 text-sm font-semibold tracking-[-0.02em] text-base-content">Inactive in this case</div>
                                <p class="mt-2 text-sm leading-6 text-base-content/62">System records matter only on public water.</p>
                            </article>
                        @else
                            <div class="block rounded-[1rem] border border-primary/12 bg-primary/5 px-4 py-4" data-system-search-panel="true">
                                <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-primary">Public-water system</span>
                                <label class="mt-4 block rounded-[0.95rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Search utilities</span>
                                    <input class="input input-bordered mt-3 h-12 w-full border-base-300 bg-base-100 shadow-none" type="search" placeholder="Type a utility name, city, state, or PWSID" autocomplete="off" data-system-search="true">
                                    <span class="mt-2 block text-xs leading-6 text-base-content/56" data-system-search-status>Utility options available</span>
                                </label>
                                <select class="form-select select mt-3 w-full rounded-[0.95rem] border-base-300 bg-base-100 text-sm font-medium text-base-content" name="pwsid">
                                    <option value="" selected="${selection.pwsid() == null}" data-system-placeholder="true">Select a utility if you already know it</option>
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
                            </div>
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
                    <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">5. Review</span>
                    <h3 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Review the recommendation, then open the next page.</h3>
                    <p class="text-sm leading-7 text-base-content/62">You can change any answer and refresh the preview. Whole-house interest can be recorded, but it never becomes the default recommendation.</p>
                </div>
                <div class="space-y-4">
                    <label class="flex cursor-pointer items-start gap-4 rounded-[1rem] border border-accent/20 bg-[rgba(120,104,90,0.08)] px-5 py-5">
                        <input class="checkbox checkbox-primary mt-1 border-base-300 bg-base-100" type="checkbox" name="wholeHouseConsidered" value="true" checked="${selection.wholeHouseConsidered()}">
                        <span class="space-y-2">
                            <span class="block text-sm font-semibold tracking-[-0.02em] text-base-content">I may want a whole-house system later</span>
                            <span class="block text-sm leading-7 text-base-content/68">The checker records this as a guarded escalation and still compares narrower point-of-use routes first.</span>
                        </span>
                    </label>

                    <div class="surface-muted px-5 py-5 shadow-[var(--shadow-soft)]">
                        <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">Current recommendation</span>
                        <p class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">${recommendation.title()}</p>
                        <p class="mt-2 text-sm leading-7 text-base-content/68">${recommendation.summary()}</p>
                        <p class="mt-3 text-xs leading-6 text-base-content/56">Update preview refreshes this page. Take me to the next step uses the current answers and opens the recommended page.</p>
                    </div>

                    <div class="flex flex-wrap items-center justify-between gap-4 rounded-[1rem] border border-base-300/70 bg-base-200/52 px-5 py-5">
                        <div class="space-y-1">
                            <span class="block text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/48">Next step</span>
                            <p class="text-sm leading-7 text-base-content/66">Stay here and update the preview, or open the best next page when you are ready.</p>
                        </div>
                        <div class="flex flex-wrap gap-3">
                            <button class="btn btn-primary h-11 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" type="submit" formaction="/checker/route">Take me to the next step</button>
                            <button class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" type="submit" formaction="/checker">Update preview</button>
                            <a class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="/checker">Start over</a>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </form>

    @template.fragments.checkerSummary(selection = selection, recommendation = recommendation)
</div>
