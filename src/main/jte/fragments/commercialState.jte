@import com.example.pfas.commercial.CommercialSurfaceState
@param String eyebrow
@param CommercialSurfaceState state

<section class="surface-panel-strong overflow-hidden">
    <div class="decision-shelf">
        <div class="grid gap-px bg-base-300/70 lg:grid-cols-[minmax(0,1.08fr)_minmax(0,0.92fr)]">
            <div class="bg-base-100 px-6 py-6 md:px-7 md:py-7">
                <div class="flex flex-wrap items-center gap-3">
                    <span class="badge badge-outline border-base-300 bg-base-100 px-3 py-3 text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/58">${eyebrow}</span>
                    <span class="decision-chip ${state.shoppingUnlocked() ? "decision-chip--open" : "decision-chip--closed"}">${state.statusLabel()}</span>
                </div>
                <p class="mt-4 text-[0.72rem] font-semibold uppercase tracking-[0.18em] text-base-content/44">${state.code()}</p>
                <h2 class="mt-3 max-w-3xl text-2xl font-semibold tracking-[-0.04em] text-base-content md:text-[2rem]">${state.title()}</h2>
                <p class="mt-4 max-w-3xl text-sm leading-7 text-base-content/70">${state.summary()}</p>
            </div>
            <div class="bg-base-200/52 px-6 py-6 md:px-7 md:py-7">
                <div class="grid gap-5">
                    <article>
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/46">Primary move</span>
                        <p class="mt-3 text-sm leading-7 text-base-content/84">${state.shoppingUnlocked() ? "Compare certified point-of-use now, but keep the claim scope and maintenance burden attached." : "Stay in interpretation. Do not turn this route into a buying step yet."}</p>
                    </article>
                    <article>
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/46">Why this opened</span>
                        <p class="mt-3 text-sm leading-7 text-base-content/74">${state.primaryReason()}</p>
                    </article>
                    <article>
                        <span class="text-[0.68rem] font-semibold uppercase tracking-[0.16em] text-base-content/46">What stays guarded</span>
                        <p class="mt-3 text-sm leading-7 text-base-content/74">${state.guardrail()}</p>
                    </article>
                </div>
            </div>
        </div>
    </div>
</section>
