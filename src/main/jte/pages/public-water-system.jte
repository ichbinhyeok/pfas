@import java.util.List
@import com.example.pfas.source.SourceDocument
@import com.example.pfas.water.PublicWaterSystem
@param PublicWaterSystem system
@param List<SourceDocument> sources

@template.layout.base(
    pageTitle = system.pwsName() + " utility context",
    pageDescription = "Utility-context page for " + system.pwsName() + " before result interpretation.",
    content = @`
<section class="result-shell">
    <div class="shell">
        <div class="result-header">
            <div>
                <span class="eyebrow">${system.stateCode()} public water</span>
                <h1 class="result-header__title">${system.pwsName()}</h1>
                <p class="hero__lede">
                    Pull direct utility material before making a product decision. This page collects the seeded utility links
                    and context needed before interpretation.
                </p>
            </div>
            <div class="button-row">
                <a class="button button--primary" href="${system.ccrUrl()}">Open CCR or utility report</a>
                <a class="button button--secondary" href="/public-water/${system.pwsid()}">Open interpreted result</a>
            </div>
        </div>

        @template.fragments.publicationStrip(lastVerified = system.lastVerifiedDate(), scopeLabel = "Public-water utility context")

        <div class="result-grid">
            <div class="stack">
                <section class="card card--hero">
                    <div class="next-action">
                        <span class="next-action__code">Public-water next action</span>
                        <h2 class="next-action__title">Use direct utility data before comparing filters.</h2>
                        <p class="next-action__summary">
                            Utility documents, official notices, and normalized system observations should drive the next step.
                        </p>
                    </div>
                </section>

                <section class="card">
                    <p class="card__label">System profile</p>
                    <h2 class="section__title">Seeded utility context</h2>
                    <ul class="list">
                        <li>PWSID: ${system.pwsid()}</li>
                        <li>System type: ${system.systemType()}</li>
                        <li>Population served: ${system.populationServed()}</li>
                        <li>Source water type: ${system.sourceWaterType()}</li>
                        <li>Last verified: ${system.lastVerifiedDate()}</li>
                    </ul>
                </section>

                <section class="card">
                    <p class="card__label">Service area notes</p>
                    <h2 class="section__title">Why this utility page exists</h2>
                    <p class="card__copy">
                        ${system.serviceAreaNotes()}
                    </p>
                </section>
            </div>

            <aside class="stack">
                <section class="rail-card">
                    <h3 class="rail-card__title">Official links</h3>
                    <div class="button-row">
                        <a class="button button--secondary" href="${system.utilityWebsiteUrl()}">Utility website</a>
                        <a class="button button--secondary" href="${system.pfasNoticeUrl()}">PFAS notice</a>
                    </div>
                </section>

                <section class="rail-card">
                    <h3 class="rail-card__title">Sources</h3>
                    <div class="source-list">
                        @for(var source : sources)
                            <article class="source-item">
                                <div class="source-item__meta">${source.organization()}</div>
                                <div class="source-item__title">${source.title()}</div>
                                <div class="source-item__url">${source.url()}</div>
                            </article>
                        @endfor
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
