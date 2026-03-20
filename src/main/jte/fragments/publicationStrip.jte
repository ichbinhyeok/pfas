@param String lastVerified
@param String scopeLabel
@param String editorialOwner
@param String methodologyOwner

<section class="overflow-hidden rounded-[1.25rem] border border-base-300/70 bg-base-100/92 shadow-[var(--shadow-soft)]">
    <div class="grid gap-px bg-base-300/70 xl:grid-cols-[minmax(0,0.8fr)_minmax(0,1.2fr)]">
        <article class="bg-neutral px-6 py-5 text-neutral-content md:px-7">
            <span class="inline-flex rounded-full bg-white/10 px-3 py-2 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-white/74">Verification ledger</span>
            <h2 class="mt-4 text-xl font-semibold tracking-[-0.03em] text-white md:text-2xl">Verification stays attached to the route.</h2>
            <p class="mt-3 text-sm leading-7 text-white/66">Last verified ${lastVerified} / ${scopeLabel}</p>
        </article>

        <article class="hidden bg-base-100 xl:block">
            <div class="grid gap-px bg-base-300/70 md:grid-cols-2">
                <div class="bg-base-100 px-6 py-5">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Editorial owner</div>
                    <div class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">${editorialOwner}</div>
                    <div class="mt-2 text-sm leading-6 text-base-content/58">No external reviewer claim is made on this build.</div>
                </div>
                <div class="bg-base-100 px-6 py-5">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Methodology owner</div>
                    <div class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">${methodologyOwner}</div>
                    <div class="mt-2 text-sm leading-6 text-base-content/58"><a class="font-medium text-primary transition duration-150 ease-out hover:text-primary/84" href="/methodology">Open methodology</a> for source handling and route logic.</div>
                </div>
                <div class="bg-base-100 px-6 py-5">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Last verified</div>
                    <div class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">${lastVerified}</div>
                    <div class="mt-2 text-sm leading-6 text-base-content/58">Page-level review timestamp.</div>
                </div>
                <div class="bg-base-100 px-6 py-5">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Scope</div>
                    <div class="mt-3 text-base font-semibold tracking-[-0.02em] text-base-content">${scopeLabel}</div>
                    <div class="mt-2 text-sm leading-6 text-base-content/58">Action-first, not safe or unsafe and not a health diagnosis.</div>
                </div>
            </div>
        </article>
    </div>

    <div class="collapse collapse-arrow rounded-none border-0 bg-base-100 xl:hidden">
        <input type="checkbox">
        <div class="collapse-title pr-12 text-sm font-semibold tracking-[-0.02em] text-base-content">Verification details</div>
        <div class="collapse-content">
            <div class="grid gap-3 pt-2">
                <div class="rounded-[0.95rem] border border-base-300/70 bg-base-100 px-4 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Editorial owner</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-base-content">${editorialOwner}</div>
                    <div class="mt-2 text-sm leading-6 text-base-content/58">No external reviewer claim is made on this build.</div>
                </div>
                <div class="rounded-[0.95rem] border border-base-300/70 bg-base-100 px-4 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Methodology owner</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-base-content">${methodologyOwner}</div>
                    <div class="mt-2 text-sm leading-6 text-base-content/58"><a class="font-medium text-primary transition duration-150 ease-out hover:text-primary/84" href="/methodology">Open methodology</a> for source handling and route logic.</div>
                </div>
                <div class="rounded-[0.95rem] border border-base-300/70 bg-base-100 px-4 py-4">
                    <div class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/48">Scope</div>
                    <div class="mt-2 text-sm font-semibold tracking-[-0.02em] text-base-content">${scopeLabel}</div>
                    <div class="mt-2 text-sm leading-6 text-base-content/58">Action-first, not safe or unsafe and not a health diagnosis.</div>
                </div>
            </div>
        </div>
    </div>
</section>
