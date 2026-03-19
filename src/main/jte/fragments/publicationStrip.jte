@param String lastVerified
@param String scopeLabel
@param String editorialOwner
@param String methodologyOwner

<div class="dossier-strip dossier-strip--compact publication-strip">
    <article class="dossier-cell">
        <span class="dossier-cell__label">Editorial owner</span>
        <span class="dossier-cell__value">${editorialOwner}</span>
        <span class="dossier-cell__copy">No external reviewer claim is made on this build.</span>
    </article>
    <article class="dossier-cell">
        <span class="dossier-cell__label">Methodology owner</span>
        <span class="dossier-cell__value">${methodologyOwner}</span>
        <span class="dossier-cell__copy"><a href="/methodology">Open methodology</a> for source handling, pipeline, and decision logic.</span>
    </article>
    <article class="dossier-cell">
        <span class="dossier-cell__label">Last verified</span>
        <span class="dossier-cell__value">${lastVerified}</span>
        <span class="dossier-cell__copy">Page-level review timestamp.</span>
    </article>
    <article class="dossier-cell">
        <span class="dossier-cell__label">Scope</span>
        <span class="dossier-cell__value">${scopeLabel}</span>
        <span class="dossier-cell__copy">Action-first, not safe/unsafe or health diagnosis.</span>
    </article>
</div>
