@param String lastVerified
@param String scopeLabel
@param String editorialOwner
@param String methodologyOwner

<div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
        <span class="mb-2 block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Editorial owner</span>
        <span class="block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${editorialOwner}</span>
        <span class="mt-2 block text-sm leading-6 text-slate-muted">No external reviewer claim is made on this build.</span>
    </article>
    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
        <span class="mb-2 block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Methodology owner</span>
        <span class="block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${methodologyOwner}</span>
        <span class="mt-2 block text-sm leading-6 text-slate-muted"><a class="text-teal-deep underline-offset-4 transition duration-150 ease-out hover:text-slate-deep hover:underline" href="/methodology">Open methodology</a> for source handling, pipeline, and decision logic.</span>
    </article>
    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
        <span class="mb-2 block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Last verified</span>
        <span class="block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${lastVerified}</span>
        <span class="mt-2 block text-sm leading-6 text-slate-muted">Page-level review timestamp.</span>
    </article>
    <article class="rounded-[16px] border border-shell-border bg-ivory-panel px-5 py-5 shadow-quiet">
        <span class="mb-2 block text-[0.7rem] font-semibold uppercase tracking-[0.18em] text-slate-soft">Scope</span>
        <span class="block text-sm font-semibold tracking-[-0.02em] text-slate-deep">${scopeLabel}</span>
        <span class="mt-2 block text-sm leading-6 text-slate-muted">Action-first, not safe/unsafe or health diagnosis.</span>
    </article>
</div>
