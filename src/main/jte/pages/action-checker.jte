@template.layout.base(
    pageTitle = "PFAS Action Checker",
    pageDescription = "Interactive PFAS action checker shell for routing users toward the correct next step.",
    content = @`
<section class="hero checker-hero">
    <div class="shell">
        <span class="eyebrow">Decision console</span>
        <div class="hero__grid">
            <div>
                <h1 class="hero__title">
                    Route the user
                    <span class="hero__title-accent">before you sell anything.</span>
                </h1>
                <p class="hero__lede">
                    This is the interaction shell for the Action Checker. It keeps the product honest by asking for direct data
                    and water-source context before any filter recommendation is allowed to dominate the screen.
                </p>
            </div>
            <aside class="hero__panel">
                <p class="hero__panel-label">Current principle</p>
                <div class="hero__panel-value">Decision first</div>
                <p class="hero__panel-copy">
                    The UI defaults to utility document or private well test first. Shopping intent is secondary, not the driver.
                </p>
            </aside>
        </div>
    </div>
</section>

<section
    class="section"
    x-data="{
        waterSource: 'public_water',
        directData: 'utility_document',
        shoppingIntent: 'none',
        wholeHouse: false,
        summary() {
            if (this.waterSource === 'private_well' && this.directData === 'none') {
                return {
                    tag: 'Test first',
                    title: 'Test the private well before comparing filters',
                    copy: 'No direct well test is available, so the next step is a state-guided lab route rather than product shopping.',
                    cta: '/internal/state-guidance'
                }
            }
            if (this.waterSource === 'public_water' && this.directData === 'none') {
                return {
                    tag: 'Utility first',
                    title: 'Pull the utility report or official notice first',
                    copy: 'Public-water users should start with direct utility data. ZIP hints and general PFAS maps are not enough.',
                    cta: '/internal/public-water-systems'
                }
            }
            if (this.waterSource === 'public_water' && this.directData === 'utility_document' && this.shoppingIntent !== 'none') {
                return {
                    tag: 'Optional point-of-use',
                    title: 'Compare certified point-of-use options only after reading the utility context',
                    copy: 'This keeps filtration as an optional margin choice instead of an automatic escalation.',
                    cta: '/public-water/PA1510001'
                }
            }
            return {
                tag: 'Interpret direct data',
                title: 'Interpret the direct source before escalating',
                copy: 'When direct official data exists, the engine should explain the result and only then allow cost and certification comparisons.',
                cta: '/internal/results/public-water/PA1510001'
            }
        }
    }"
>
    <div class="shell checker-grid">
        <div class="checker-console">
            <div class="section__header">
                <div>
                    <p class="section__label">Input state</p>
                    <h2 class="section__title">Action Checker shell</h2>
                    <p class="section__copy">Each selection is intentionally large, quiet, and hard to misread.</p>
                </div>
            </div>

            <div class="checker-block">
                <p class="checker-block__label">Water source</p>
                <div class="option-grid option-grid--two">
                    <button class="option-card" type="button" :class="{ 'option-card--active': waterSource === 'public_water' }" @click="waterSource = 'public_water'">
                        <span class="option-card__title">Public water</span>
                        <span class="option-card__copy">Utility document, CCR, official notice, system-level context.</span>
                    </button>
                    <button class="option-card" type="button" :class="{ 'option-card--active': waterSource === 'private_well' }" @click="waterSource = 'private_well'; directData = 'none'">
                        <span class="option-card__title">Private well</span>
                        <span class="option-card__copy">Owner-responsibility testing and state-guided lab routing.</span>
                    </button>
                </div>
            </div>

            <div class="checker-block">
                <p class="checker-block__label">Direct data status</p>
                <div class="option-grid">
                    <button class="option-card" type="button" :class="{ 'option-card--active': directData === 'none' }" @click="directData = 'none'">
                        <span class="option-card__title">No direct data yet</span>
                        <span class="option-card__copy">No utility report, notice, or private well lab result available.</span>
                    </button>
                    <button class="option-card" type="button" :class="{ 'option-card--active': directData === 'utility_document' }" @click="directData = 'utility_document'" :disabled="waterSource === 'private_well'">
                        <span class="option-card__title">Utility document</span>
                        <span class="option-card__copy">A direct system document exists and needs interpretation.</span>
                    </button>
                    <button class="option-card" type="button" :class="{ 'option-card--active': directData === 'private_well_test' }" @click="directData = 'private_well_test'" :disabled="waterSource === 'public_water'">
                        <span class="option-card__title">Private well test</span>
                        <span class="option-card__copy">A state-appropriate lab result exists and can be interpreted.</span>
                    </button>
                </div>
            </div>

            <div class="checker-block">
                <p class="checker-block__label">Shopping intent</p>
                <div class="option-grid option-grid--three">
                    <button class="option-card option-card--compact" type="button" :class="{ 'option-card--active': shoppingIntent === 'none' }" @click="shoppingIntent = 'none'">
                        <span class="option-card__title">None</span>
                    </button>
                    <button class="option-card option-card--compact" type="button" :class="{ 'option-card--active': shoppingIntent === 'filter_now' }" @click="shoppingIntent = 'filter_now'">
                        <span class="option-card__title">Filter now</span>
                    </button>
                    <button class="option-card option-card--compact" type="button" :class="{ 'option-card--active': shoppingIntent === 'compare_options' }" @click="shoppingIntent = 'compare_options'">
                        <span class="option-card__title">Compare options</span>
                    </button>
                </div>
            </div>

            <div class="checker-block">
                <label class="toggle">
                    <input type="checkbox" x-model="wholeHouse">
                    <span class="toggle__label">Whole-house intent is being considered</span>
                </label>
                <p class="checker-block__hint">The UI should never default to whole-house unless the user has a separate justification.</p>
            </div>
        </div>

        <aside class="checker-summary">
            <div class="checker-summary__top">
                <span class="eyebrow" x-text="summary().tag"></span>
                <h2 class="checker-summary__title" x-text="summary().title"></h2>
                <p class="checker-summary__copy" x-text="summary().copy"></p>
                <div class="summary-facts">
                    <div class="summary-fact">
                        <span class="summary-fact__label">Source</span>
                        <span class="summary-fact__value" x-text="waterSource === 'public_water' ? 'Public water' : 'Private well'"></span>
                    </div>
                    <div class="summary-fact">
                        <span class="summary-fact__label">Direct data</span>
                        <span
                            class="summary-fact__value"
                            x-text="
                                directData === 'none'
                                    ? 'Not yet available'
                                    : directData === 'utility_document'
                                        ? 'Utility document'
                                        : 'Private well test'
                            "
                        ></span>
                    </div>
                    <div class="summary-fact">
                        <span class="summary-fact__label">Escalation</span>
                        <span class="summary-fact__value" x-text="wholeHouse ? 'Whole-house requires extra proof' : 'Point-of-use first'"></span>
                    </div>
                </div>
            </div>

            <div class="checker-summary__stack">
                <div class="rail-card">
                    <h3 class="rail-card__title">Why this matters</h3>
                    <ul class="list">
                        <li>Direct data outranks generalized PFAS maps and broad location hints.</li>
                        <li>Optional point-of-use is the default product class before any whole-house escalation.</li>
                        <li>The summary is a routing step, not a household safe or unsafe label.</li>
                    </ul>
                </div>

                <div class="rail-card rail-card--warn" x-show="wholeHouse">
                    <h3 class="rail-card__title">Whole-house guardrail</h3>
                    <p class="checker-block__hint">
                        Whole-house should remain a justified escalation, not a default upsell. The engine should ask for a
                        separate rationale before moving there.
                    </p>
                </div>

                <div class="rail-card">
                    <h3 class="rail-card__title">Current launch path</h3>
                    <div class="button-row">
                        <a class="button button--primary" :href="summary().cta">Open matching view</a>
                        <a class="button button--secondary" href="/public-water/PA1510001">See premium result page</a>
                    </div>
                </div>
            </div>
        </aside>
    </div>
</section>
`
)
