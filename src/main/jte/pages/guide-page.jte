@import java.util.List
@import com.example.pfas.web.GuidePage
@param GuidePage page
@param List<GuidePage> allGuides

@template.layout.base(
    pageTitle = page.title(),
    pageDescription = page.lede(),
    content = @`
<section class="result-shell">
    <div class="shell">
        <div class="result-header">
            <div>
                <span class="eyebrow">${page.eyebrow()}</span>
                <h1 class="result-header__title">${page.title()}</h1>
                <p class="hero__lede">${page.lede()}</p>
            </div>
            <div class="button-row">
                <a class="button button--primary" href="${page.primaryHref()}">${page.primaryLabel()}</a>
                <a class="button button--secondary" href="${page.secondaryHref()}">${page.secondaryLabel()}</a>
            </div>
        </div>

        @template.fragments.publicationStrip(lastVerified = page.lastVerifiedDate(), scopeLabel = "Decision-intent guide")

        <div class="result-grid">
            <div class="stack">
                <section class="card card--hero next-action">
                    <span class="next-action__code">Guide next action</span>
                    <div>
                        <p class="card__label">Next action</p>
                        <h2 class="next-action__title">${page.nextActionTitle()}</h2>
                    </div>
                    <p class="next-action__summary">${page.nextActionSummary()}</p>
                </section>

                <section class="card">
                    <p class="card__label">Why this</p>
                    <ul class="list">
                        @for(var item : page.whyThis())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>

                <section class="card">
                    <p class="card__label">What this does not tell you</p>
                    <ul class="list">
                        @for(var item : page.whatThisDoesNotTellYou())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>
            </div>

            <aside class="stack">
                <section class="rail-card">
                    <h2 class="rail-card__title">Checklist</h2>
                    <ul class="list">
                        @for(var item : page.checklist())
                            <li>${item}</li>
                        @endfor
                    </ul>
                </section>

                <section class="rail-card">
                    <h2 class="rail-card__title">Related guides</h2>
                    <div class="source-list">
                        @for(var guide : allGuides)
                            @if(!guide.slug().equals(page.slug()))
                                <a class="source-item" href="/guides/${guide.slug()}">
                                    <div class="source-item__meta">${guide.eyebrow()}</div>
                                    <div class="source-item__title">${guide.title()}</div>
                                </a>
                            @endif
                        @endfor
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
`
)
