@param String routeId
@param String routeTitle
@param String routeSummary
@param String routeUrl

<section class="surface-panel overflow-hidden" data-route-actions>
    <div class="grid gap-5 px-6 py-5 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-center">
        <div class="space-y-2">
            <span class="text-[0.68rem] font-semibold uppercase tracking-[0.18em] text-base-content/52">Route actions</span>
            <h2 class="text-xl font-semibold tracking-[-0.03em] text-base-content">Save this route or send the decision summary.</h2>
            <p class="text-sm leading-7 text-base-content/66">This keeps the current route available without forcing a user into an account flow before deployment.</p>
        </div>
        <div class="flex flex-wrap items-center gap-3">
            <button
                type="button"
                class="btn btn-outline h-11 rounded-full border-base-300 bg-base-100 px-5 text-sm font-semibold text-base-content shadow-none hover:-translate-y-px hover:bg-base-200"
                data-route-save="true"
                data-route-id="${routeId}"
                data-route-title="${routeTitle}"
                data-route-summary="${routeSummary}"
                data-route-url="${routeUrl}"
            >Save this route</button>
            <button
                type="button"
                class="btn btn-primary h-11 rounded-full border-0 px-5 text-sm font-semibold shadow-none hover:-translate-y-px hover:bg-primary/92"
                data-route-email="true"
                data-route-id="${routeId}"
                data-route-title="${routeTitle}"
                data-route-summary="${routeSummary}"
                data-route-url="${routeUrl}"
            >Send summary</button>
        </div>
    </div>
    <div class="border-t border-base-300/70 px-6 py-4 text-sm leading-6 text-base-content/58" data-route-status role="status" aria-live="polite" aria-atomic="true">Saved routes stay on this device until a full account layer exists.</div>
</section>
