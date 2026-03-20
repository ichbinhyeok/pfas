@import java.util.List
@import com.example.pfas.state.StateGuidance
@import com.example.pfas.stateprofile.StateBenchmarkProfile
@import com.example.pfas.source.SourceDocument
@param String siteBaseUrl
@param String siteEditorialOwner
@param String siteMethodologyOwner
@param StateGuidance guidance
@param StateBenchmarkProfile profile
@param List<SourceDocument> sources
@param boolean pageIndexable

@template.layout.base(
    pageTitle = guidance.stateCode() + " private-well PFAS guide",
    pageDescription = "State-backed private-well PFAS routing page for " + guidance.stateCode() + ".",
    pageCanonicalUrl = siteBaseUrl + "/private-well/" + guidance.stateCode(),
    pageIndexable = pageIndexable,
    content = @`
<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <div class="space-y-4">
                    <span class="badge badge-outline border-base-300 bg-base-100 px-4 py-3 text-[0.7rem] font-semibold uppercase tracking-[0.2em] text-base-content/58">${guidance.stateCode()} private well</span>
                    <h1 class="max-w-5xl text-4xl font-semibold tracking-[-0.055em] text-base-content sm:text-5xl lg:text-[4rem] lg:leading-[0.98]">
                        ${guidance.agencyName()}
                        <span class="font-serif font-medium text-secondary">as the route anchor before any shopping path.</span>
                    </h1>
                    <p class="max-w-3xl text-lg leading-8 text-base-content/72">
                        Private-well route for ${guidance.stateCode()}. This page stays reference-based and points users to official
                        lab lookup, sampling guidance, and repeat-testing context.
                    </p>
                </div>

                <div class="join join-vertical gap-3 sm:join-horizontal">
                    <a class="btn btn-primary join-item h-12 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" href="${guidance.privateWellGuidanceUrl()}">Open official guidance</a>
                    <a class="btn btn-outline join-item h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guidance.certifiedLabLookupUrl()}">Open certified lab lookup</a>
                </div>
            </div>

            <aside class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                <div class="card-body gap-5">
                    <div class="space-y-2">
                        <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">State route frame</span>
                        <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Sampling and interpretation stay state-specific.</h2>
                    </div>
                    <ul class="menu gap-2 rounded-[1rem] bg-base-200/55 p-3">
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Guidance source</strong><br>${guidance.agencyName()}</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Testing route</strong><br>State-certified lab lookup before any filter comparison.</span></li>
                        <li><span class="rounded-[0.9rem] border border-base-300/70 bg-base-100 px-4 py-4 text-sm leading-6 text-base-content/72"><strong class="font-semibold text-base-content">Verification</strong><br>${guidance.lastVerifiedDate()}</span></li>
                    </ul>
                </div>
            </aside>
        </div>
    </div>
</section>

<section class="pt-10 md:pt-12">
    <div class="shell">
        @template.fragments.publicationStrip(
            lastVerified = guidance.lastVerifiedDate(),
            scopeLabel = "Private-well state guide",
            editorialOwner = siteEditorialOwner,
            methodologyOwner = siteMethodologyOwner
        )
    </div>
</section>

<section class="pt-14 md:pt-18">
    <div class="shell">
        <div class="stats stats-vertical gap-3 bg-transparent p-0 shadow-none lg:stats-horizontal">
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">State route</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${guidance.stateCode()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">State-specific guide and lab pathway.</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Repeat testing</div>
                <div class="stat-value mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content">Guidance in view</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">${guidance.repeatTestingGuidance()}</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Benchmark notes</div>
                <div class="stat-value mt-3 text-lg font-semibold tracking-[-0.03em] text-base-content">Reference-based</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">${guidance.benchmarkNotes()}</div>
            </div>
            <div class="stat rounded-[1rem] border border-base-300/70 bg-base-100/92 px-6 py-5 shadow-[var(--shadow-soft)]">
                <div class="stat-title text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Last verified</div>
                <div class="stat-value mt-3 text-xl font-semibold tracking-[-0.03em] text-base-content">${guidance.lastVerifiedDate()}</div>
                <div class="stat-desc mt-3 text-sm leading-6 text-base-content/58">State guidance and lab route review date.</div>
            </div>
        </div>
    </div>
</section>

<section class="pt-14 md:pt-20">
    <div class="shell">
        <div class="grid gap-8 xl:grid-cols-[minmax(0,1.15fr)_23rem] xl:items-start">
            <div class="space-y-6">
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-panel)]">
                    <div class="card-body gap-5">
                        <div class="alert border border-base-300/70 bg-base-100 px-5 py-4 shadow-none">
                            <div class="space-y-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Private-well next action</span>
                                <h2 class="text-3xl font-semibold tracking-[-0.04em] text-base-content">Test first, then interpret against state guidance.</h2>
                                <p class="text-sm leading-7 text-base-content/68">State-specific lab and sampling guidance should appear before any filter shopping or whole-house escalation.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <div class="grid gap-5 lg:grid-cols-2">
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-4">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Sampling and testing</span>
                            <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">What to do first</h2>
                            <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                                <li>Use the state-certified lab route rather than a generic home test suggestion.</li>
                                <li>Follow the state sampling instructions before collecting a PFAS well sample.</li>
                                <li>Keep interpretation reference-based and avoid calling a private well compliant or non-compliant.</li>
                            </ul>
                        </div>
                    </section>

                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-4">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Notes</span>
                            <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Interpretation context</h2>
                            <ul class="space-y-3 text-sm leading-7 text-base-content/72">
                                <li>${guidance.repeatTestingGuidance()}</li>
                                <li>${guidance.benchmarkNotes()}</li>
                            </ul>
                        </div>
                    </section>
                </div>

                @if (profile != null)
                    <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                        <div class="card-body gap-5">
                            <div class="space-y-2">
                                <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">State reference context</span>
                                <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">${profile.primaryReferenceLabel()}</h2>
                            </div>
                            <p class="text-sm leading-7 text-base-content/68">${profile.summary()}</p>
                            <div class="space-y-3">
                                @for (var line : profile.benchmarks())
                                    <div class="rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-4">
                                        <div class="text-sm font-semibold text-base-content">${line.label()}</div>
                                        <div class="mt-2 text-sm leading-6 text-base-content/66">${line.benchmarkDisplay()} (${line.note()})</div>
                                    </div>
                                @endfor
                            </div>
                        </div>
                    </section>
                @endif

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <div class="space-y-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Quick benchmark check</span>
                            <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Run a seeded state comparison</h2>
                        </div>
                        <form class="grid gap-4 md:grid-cols-2" method="get" action="/private-well-result/${guidance.stateCode()}">
                            <label class="form-control w-full">
                                <div class="label px-0 pb-2 pt-0">
                                    <span class="label-text text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Analyte code</span>
                                </div>
                                <input class="input input-bordered h-12 w-full border-base-300 bg-base-100 shadow-none" type="text" name="analyteCode" value="PFOA">
                            </label>
                            <label class="form-control w-full">
                                <div class="label px-0 pb-2 pt-0">
                                    <span class="label-text text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Measured value</span>
                                </div>
                                <input class="input input-bordered h-12 w-full border-base-300 bg-base-100 shadow-none" type="number" step="0.01" min="0" name="value" value="12">
                            </label>
                            <label class="form-control w-full">
                                <div class="label px-0 pb-2 pt-0">
                                    <span class="label-text text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Unit</span>
                                </div>
                                <select class="select select-bordered h-12 w-full border-base-300 bg-base-100 shadow-none" name="unit">
                                    <option value="ppt" selected="selected">ppt</option>
                                    <option value="ppb">ppb</option>
                                    <option value="ng/L">ng/L</option>
                                    <option value="ug/L">ug/L</option>
                                </select>
                            </label>
                            <label class="form-control w-full">
                                <div class="label px-0 pb-2 pt-0">
                                    <span class="label-text text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Current filter</span>
                                </div>
                                <select class="select select-bordered h-12 w-full border-base-300 bg-base-100 shadow-none" name="currentFilterStatus">
                                    <option value="NONE" selected="selected">No current filter</option>
                                    <option value="CERTIFIED_POU">Certified point-of-use</option>
                                    <option value="UNCERTIFIED">Uncertified or unclear</option>
                                </select>
                            </label>
                            <label class="label col-span-full justify-start gap-3 rounded-[1rem] border border-base-300/70 bg-base-100 px-4 py-4">
                                <input class="checkbox checkbox-sm border-base-300 bg-base-100 text-primary" type="checkbox" name="wholeHouseConsidered" value="true">
                                <span class="label-text text-sm leading-6 text-base-content/68">Whole-house has already been considered and rejected as the default move.</span>
                            </label>
                            <div class="col-span-full pt-1">
                                <button class="btn btn-primary h-12 rounded-full border-0 px-6 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92" type="submit">Run state comparison</button>
                            </div>
                        </form>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <div class="space-y-2">
                            <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">Batch benchmark check</span>
                            <h2 class="text-2xl font-semibold tracking-[-0.03em] text-base-content">Compare multiple PFAS lines at once</h2>
                        </div>
                        <form class="space-y-4" method="get" action="/private-well-result/${guidance.stateCode()}">
                            <label class="form-control w-full">
                                <div class="label px-0 pb-2 pt-0">
                                    <span class="label-text text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Batch input</span>
                                </div>
                                <textarea class="textarea textarea-bordered min-h-32 w-full border-base-300 bg-base-100 shadow-none" name="batchInput" rows="4">PFOA=12ppt;PFOS=3ppt</textarea>
                            </label>
                            <div class="grid gap-4 md:grid-cols-[minmax(0,1fr)_auto] md:items-end">
                                <label class="form-control w-full">
                                    <div class="label px-0 pb-2 pt-0">
                                        <span class="label-text text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Current filter</span>
                                    </div>
                                    <select class="select select-bordered h-12 w-full border-base-300 bg-base-100 shadow-none" name="currentFilterStatus">
                                        <option value="NONE" selected="selected">No current filter</option>
                                        <option value="CERTIFIED_POU">Certified point-of-use</option>
                                        <option value="UNCERTIFIED">Uncertified or unclear</option>
                                    </select>
                                </label>
                                <button class="btn btn-outline h-12 rounded-full border-base-300 bg-base-100 px-6 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" type="submit">Run batch comparison</button>
                            </div>
                        </form>
                    </div>
                </section>
            </div>

            <aside class="space-y-5 xl:sticky xl:top-28">
                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-4">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Official links</h2>
                        <div class="join join-vertical gap-3">
                            <a class="btn btn-outline join-item h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guidance.pfasGuidanceUrl()}">PFAS guidance</a>
                            <a class="btn btn-outline join-item h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200" href="${guidance.samplingGuidanceUrl()}">Sampling guidance</a>
                        </div>
                    </div>
                </section>

                <section class="card border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
                    <div class="card-body gap-5">
                        <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Primary source ledger</h2>
                        <div class="space-y-3">
                            @for(var source : sources)
                                <a class="block rounded-[1rem] border border-base-300/70 bg-base-100 px-5 py-5 transition duration-150 ease-out hover:-translate-y-px hover:border-base-300" href="${source.url()}">
                                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/52">${source.organization()}</div>
                                    <div class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">${source.title()}</div>
                                    <div class="mt-2 break-all text-sm leading-6 text-base-content/60">${source.url()}</div>
                                </a>
                            @endfor
                        </div>
                    </div>
                </section>

                <div class="alert border border-base-300/70 bg-base-100/92 px-5 py-4 shadow-[var(--shadow-soft)]">
                    <span class="text-sm leading-7 text-base-content/74">This page is a state-backed intake and interpretation surface. It does not label a private well compliant or safe, and it does not default to whole-house equipment.</span>
                </div>
            </aside>
        </div>
    </div>
</section>
`
)
