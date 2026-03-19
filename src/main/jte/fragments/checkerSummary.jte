@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.checker.ActionCheckerRecommendation
@import com.example.pfas.checker.ActionWaterSource
@import static com.example.pfas.web.PresentationText.directDataLabel
@import static com.example.pfas.web.PresentationText.waterSourceLabel
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

<aside class="checker-summary" id="checker-summary">
    <div class="checker-summary__top">
        <span class="eyebrow">${recommendation.tag()}</span>
        <div class="route-code">${recommendation.routeCode()}</div>
        <h2 class="checker-summary__title">${recommendation.title()}</h2>
        <p class="checker-summary__copy">${recommendation.summary()}</p>

        <div class="summary-facts">
            <div class="summary-fact">
                <span class="summary-fact__label">Source</span>
                <span class="summary-fact__value">${waterSourceLabel(selection.waterSource())}</span>
            </div>
            <div class="summary-fact">
                <span class="summary-fact__label">Direct data</span>
                <span class="summary-fact__value">${directDataLabel(selection.directData())}</span>
            </div>
            <div class="summary-fact">
                <span class="summary-fact__label">Escalation</span>
                <span class="summary-fact__value">
                    @if(selection.wholeHouseConsidered())
                        Whole-house guarded
                    @else
                        Point-of-use first
                    @endif
                </span>
            </div>
        </div>
    </div>

    <div class="checker-summary__stack">
        <div class="rail-card">
            <h3 class="rail-card__title">Why this route</h3>
            <ul class="list">
                @for(var principle : recommendation.principles())
                    <li>${principle}</li>
                @endfor
            </ul>
        </div>

        <div class="rail-card">
            <h3 class="rail-card__title">Operating stance</h3>
            <p class="checker-block__hint">
                This summary is a routing position inside the engine. It is not a household grade, a compliance label, or a
                product-first recommendation.
            </p>
        </div>

        @if(recommendation.wholeHouseGuardrail())
            <div class="rail-card rail-card--warn">
                <h3 class="rail-card__title">Whole-house guardrail</h3>
                <p class="checker-block__hint">${recommendation.wholeHouseMessage()}</p>
            </div>
        @endif

        <div class="rail-card">
            <h3 class="rail-card__title">Current launch path</h3>
            <div class="button-row">
                <a class="button button--primary" href="${recommendation.primaryHref()}">${recommendation.primaryLabel()}</a>
                <a class="button button--secondary" href="${recommendation.secondaryHref()}">${recommendation.secondaryLabel()}</a>
            </div>
        </div>
    </div>
</aside>
