@import java.util.List
@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.checker.ActionCheckerRecommendation
@import com.example.pfas.checker.ActionWaterSource
@import com.example.pfas.checker.ActionDirectDataStatus
@import com.example.pfas.checker.ActionShoppingIntent
@import com.example.pfas.state.StateGuidance
@import com.example.pfas.water.PublicWaterSystem
@param String siteBaseUrl
@param List<StateGuidance> states
@param List<PublicWaterSystem> systems
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

@template.layout.base(
    pageTitle = "PFAS Action Checker",
    pageDescription = "Server-backed PFAS action checker that routes users by direct data status before any product comparison.",
    pageCanonicalUrl = siteBaseUrl + "/checker",
    pageIndexable = false,
    content = @`
<section class="hero checker-hero">
    <div class="shell">
        <span class="eyebrow">Decision console</span>
        <div class="hero__grid">
            <div>
                <h1 class="hero__title">
                    Route the household
                    <span class="hero__title-accent">like a controlled evidence workflow.</span>
                </h1>
                <p class="hero__lede">
                    This screen is meant to feel more like a routing dossier than a cheerful wizard. The right rail should read
                    like the current interpretation stance, not a floating marketing card.
                </p>
            </div>
            <aside class="hero__panel">
                <p class="hero__panel-label">Current principle</p>
                <div class="hero__panel-value">Server-backed routing</div>
                <p class="hero__panel-copy">
                    Public-water and private-well users are pushed toward direct official data first, then interpretation,
                    then optional certified point-of-use.
                </p>
                <ul class="hero__panel-list">
                    <li>Input panel on the left.</li>
                    <li>Routing position on the right.</li>
                    <li>No product-first state.</li>
                </ul>
            </aside>
        </div>
    </div>
</section>

<section class="section">
    <div class="shell">
        @template.fragments.publicationStrip(lastVerified = "2026-03-19", scopeLabel = "Routing interface")
        <div class="dossier-strip dossier-strip--compact">
            <article class="dossier-cell">
                <span class="dossier-cell__label">Step 01</span>
                <span class="dossier-cell__value">Collect input</span>
                <span class="dossier-cell__copy">Source, direct data, and shopping posture.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Step 02</span>
                <span class="dossier-cell__value">Normalize state</span>
                <span class="dossier-cell__copy">Server rules remove invalid combinations.</span>
            </article>
            <article class="dossier-cell">
                <span class="dossier-cell__label">Step 03</span>
                <span class="dossier-cell__value">Route next action</span>
                <span class="dossier-cell__copy">Interpretation opens before product comparison.</span>
            </article>
        </div>
    </div>
</section>

<section class="section">
    @template.fragments.checkerPanel(
        states = states,
        systems = systems,
        selection = selection,
        recommendation = recommendation
    )
</section>
`
)
