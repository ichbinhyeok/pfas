@import java.util.List
@import com.example.pfas.checker.ActionCheckerSelection
@import com.example.pfas.checker.ActionCheckerRecommendation
@import com.example.pfas.checker.ActionWaterSource
@import com.example.pfas.checker.ActionDirectDataStatus
@import com.example.pfas.checker.ActionShoppingIntent
@import com.example.pfas.state.StateGuidance
@import com.example.pfas.water.PublicWaterSystem
@import static com.example.pfas.web.PresentationText.waterSourceLabel
@param List<StateGuidance> states
@param List<PublicWaterSystem> systems
@param ActionCheckerSelection selection
@param ActionCheckerRecommendation recommendation

<div class="shell checker-grid" id="checker-panel">
    <form
        class="checker-console"
        method="get"
        action="/checker"
        hx-get="/checker/panel"
        hx-trigger="change from:input, change from:select"
        hx-target="#checker-panel"
        hx-swap="outerHTML"
    >
        <div class="section__header">
            <div>
                <p class="section__label">Input state</p>
                <h2 class="section__title">Action Checker</h2>
                <p class="section__copy">Large controls, quiet spacing, and explicit server rules.</p>
            </div>
        </div>

        <div class="case-strip">
            <article class="case-chip">
                <span class="case-chip__label">Source type</span>
                <span class="case-chip__value">${waterSourceLabel(selection.waterSource())}</span>
            </article>
            <article class="case-chip">
                <span class="case-chip__label">State code</span>
                <span class="case-chip__value">${selection.stateCode()}</span>
            </article>
            <article class="case-chip">
                <span class="case-chip__label">Seeded record</span>
                <span class="case-chip__value">${selection.pwsid()}</span>
            </article>
        </div>

        <div class="checker-block">
            <p class="checker-block__label">Water source</p>
            <div class="option-grid option-grid--two">
                <label class="option-card">
                    <input class="option-card__input" type="radio" name="waterSource" value="PUBLIC_WATER" checked="${selection.waterSource() == ActionWaterSource.PUBLIC_WATER}">
                    <span class="option-card__title">Public water</span>
                    <span class="option-card__copy">Utility document, CCR, official notice, and system-level context.</span>
                </label>
                <label class="option-card">
                    <input class="option-card__input" type="radio" name="waterSource" value="PRIVATE_WELL" checked="${selection.waterSource() == ActionWaterSource.PRIVATE_WELL}">
                    <span class="option-card__title">Private well</span>
                    <span class="option-card__copy">Owner-responsibility testing, state labs, and reference-based interpretation.</span>
                </label>
            </div>
        </div>

        <div class="checker-block">
            <p class="checker-block__label">Direct data status</p>
            <div class="option-grid">
                <label class="option-card">
                    <input class="option-card__input" type="radio" name="directData" value="NONE" checked="${selection.directData() == ActionDirectDataStatus.NONE}">
                    <span class="option-card__title">No direct data yet</span>
                    <span class="option-card__copy">No utility document, notice, or private-well lab result exists yet.</span>
                </label>
                <label class="option-card">
                    <input class="option-card__input" type="radio" name="directData" value="UTILITY_DOCUMENT" checked="${selection.directData() == ActionDirectDataStatus.UTILITY_DOCUMENT}">
                    <span class="option-card__title">Utility document</span>
                    <span class="option-card__copy">A direct system document exists and should be interpreted before shopping.</span>
                </label>
                <label class="option-card">
                    <input class="option-card__input" type="radio" name="directData" value="PRIVATE_WELL_TEST" checked="${selection.directData() == ActionDirectDataStatus.PRIVATE_WELL_TEST}">
                    <span class="option-card__title">Private-well test</span>
                    <span class="option-card__copy">A well test exists and should be interpreted against state-specific guidance.</span>
                </label>
            </div>
        </div>

        <div class="checker-block">
            <p class="checker-block__label">Shopping intent</p>
            <div class="option-grid option-grid--three">
                <label class="option-card option-card--compact">
                    <input class="option-card__input" type="radio" name="shoppingIntent" value="NONE" checked="${selection.shoppingIntent() == ActionShoppingIntent.NONE}">
                    <span class="option-card__title">None</span>
                </label>
                <label class="option-card option-card--compact">
                    <input class="option-card__input" type="radio" name="shoppingIntent" value="FILTER_NOW" checked="${selection.shoppingIntent() == ActionShoppingIntent.FILTER_NOW}">
                    <span class="option-card__title">Filter now</span>
                </label>
                <label class="option-card option-card--compact">
                    <input class="option-card__input" type="radio" name="shoppingIntent" value="COMPARE_OPTIONS" checked="${selection.shoppingIntent() == ActionShoppingIntent.COMPARE_OPTIONS}">
                    <span class="option-card__title">Compare options</span>
                </label>
            </div>
        </div>

        <div class="checker-block">
            <p class="checker-block__label">Seeded context</p>
            <div class="select-cluster">
                <label class="select-field">
                    <span class="select-field__label">Private-well state</span>
                    <select name="stateCode">
                        @for(var state : states)
                            <option value="${state.stateCode()}" selected="${state.stateCode().equals(selection.stateCode())}">${state.stateCode()} - ${state.agencyName()}</option>
                        @endfor
                    </select>
                </label>
                <label class="select-field">
                    <span class="select-field__label">Public-water system</span>
                    <select name="pwsid">
                        @for(var system : systems)
                            <option value="${system.pwsid()}" selected="${system.pwsid().equals(selection.pwsid())}">${system.pwsName()} (${system.stateCode()})</option>
                        @endfor
                    </select>
                </label>
            </div>
            <p class="checker-block__hint">The router uses the relevant seeded context based on water source.</p>
        </div>

        <div class="checker-block">
            <label class="toggle">
                <input type="checkbox" name="wholeHouseConsidered" value="true" checked="${selection.wholeHouseConsidered()}">
                <span class="toggle__label">Whole-house intent is being considered</span>
            </label>
            <p class="checker-block__hint">This stays a guardrail, not the default recommendation.</p>
        </div>

        <div class="checker-console__actions">
            <button class="button button--primary" type="submit">Run full route</button>
            <a class="button button--secondary" href="/checker">Reset</a>
        </div>
    </form>

    @template.fragments.checkerSummary(selection = selection, recommendation = recommendation)
</div>
