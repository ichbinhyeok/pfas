@import com.example.pfas.water.PublicWaterSystem
@param java.util.List<PublicWaterSystem> systems

@template.layout.base(
    pageTitle = "PFAS Decision Engine",
    pageDescription = "Official-data-first PFAS decision interface for public water and private well workflows.",
    content = @`
<section class="hero">
    <div class="shell">
        <span class="eyebrow">Premium trust startup interface</span>
        <div class="hero__grid">
            <div>
                <h1 class="hero__title">
                    Official data in,
                    <span class="hero__title-accent">clear next action out.</span>
                </h1>
                <p class="hero__lede">
                    This project is not a PFAS content farm. It is a benchmark-aware decision product that turns utility data,
                    state guidance, and claim-level filter listings into a user-facing next step.
                </p>
                <div class="hero__actions">
                    <a class="button button--primary" href="/checker">Open Action Checker</a>
                    <a class="button button--secondary" href="/public-water/PA1510001">Open seeded public-water result</a>
                </div>
            </div>
            <aside class="hero__panel">
                <p class="hero__panel-label">Current build state</p>
                <div class="hero__panel-value">Sharp v1 backend</div>
                <p class="hero__panel-copy">
                    Source registry, benchmark registry, utility observations, certification claims, cost models, and typed
                    public-water result outputs are wired together.
                </p>
                <div class="chip-row">
                    <span class="chip">File-based data pipeline</span>
                    <span class="chip">Typed result schema</span>
                    <span class="chip">SSR premium UI</span>
                </div>
            </aside>
        </div>
    </div>
</section>

<section class="section">
    <div class="shell">
        <div class="section__header">
            <div>
                <p class="section__label">Seeded systems</p>
                <h2 class="section__title">Current public-water view models</h2>
                <p class="section__copy">These are the seeded systems currently available through the file-backed backend.</p>
            </div>
        </div>
        <div class="systems-grid">
            @for (var system : systems)
                <article class="card">
                    <p class="card__label">${system.stateCode()} public water</p>
                    <h3 class="card__title">${system.pwsName()}</h3>
                    <p class="card__copy">
                        PWSID ${system.pwsid()} / ${system.systemType()} / ${system.sourceWaterType()}
                    </p>
                    <div class="chip-row">
                        <span class="chip">Official utility source</span>
                        <span class="chip">Benchmark-aware result</span>
                        <span class="chip">Typed JSON available</span>
                    </div>
                    <div class="button-row">
                        <a class="button button--primary" href="/public-water/${system.pwsid()}">Open result page</a>
                        <a class="button button--secondary" href="/internal/public-water-decision/${system.pwsid()}">Decision context</a>
                    </div>
                </article>
            @endfor
        </div>
    </div>
</section>

<section class="section">
    <div class="shell">
        <div class="section__header">
            <div>
                <p class="section__label">Trust model</p>
                <h2 class="section__title">What makes this different from PFAS content spam</h2>
            </div>
        </div>
        <div class="trust-grid">
            <div class="trust-item">
                <h3 class="trust-item__title">Registry-backed benchmarks</h3>
                <p class="trust-item__copy">Observations point to benchmark ids instead of hard-coded prose thresholds.</p>
            </div>
            <div class="trust-item">
                <h3 class="trust-item__title">Claim-level certification</h3>
                <p class="trust-item__copy">Filter options only show up when a concrete listing record and PFAS claim are captured.</p>
            </div>
            <div class="trust-item">
                <h3 class="trust-item__title">Typed result outputs</h3>
                <p class="trust-item__copy">The frontend consumes the same explicit result schema the backend emits.</p>
            </div>
        </div>
    </div>
</section>
`
)
