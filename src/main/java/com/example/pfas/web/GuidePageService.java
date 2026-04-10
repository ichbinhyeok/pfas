package com.example.pfas.web;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class GuidePageService {

	private static final List<String> SEARCH_PRIORITY_GUIDE_SLUGS = List.of(
		"test-first-vs-filter-first",
		"nsf-53-vs-58-pfas",
		"pfas-filter-annual-cost",
		"under-sink-vs-whole-house"
	);
	private static final List<String> PUBLIC_WATER_BRAND_GUIDE_SLUGS = List.of(
		"read-your-ccr",
		"how-to-read-a-pfas-utility-notice",
		"test-first-vs-filter-first",
		"nsf-53-vs-58-pfas",
		"pfas-filter-annual-cost",
		"under-sink-vs-whole-house"
	);

	private static final Comparator<GuidePage> PAGE_ORDER = Comparator
		.comparing(GuidePage::editorialRank, Comparator.nullsLast(Comparator.naturalOrder()))
		.thenComparing(GuidePage::slug);

	private final GuidePageRepository guidePageRepository;
	private volatile List<GuidePage> cachedPages;

	public GuidePageService(GuidePageRepository guidePageRepository) {
		this.guidePageRepository = guidePageRepository;
	}

	public List<GuidePage> getAll() {
		var local = cachedPages;
		if (local != null) {
			return local;
		}

		synchronized (this) {
			if (cachedPages == null) {
				cachedPages = guidePageRepository.findAll().stream()
					.sorted(PAGE_ORDER)
					.toList();
			}
			return cachedPages;
		}
	}

	public Optional<GuidePage> getBySlug(String slug) {
		return getAll().stream()
			.filter(page -> page.slug().equals(slug))
			.findFirst();
	}

	public List<GuidePage> getSearchPriorityGuides() {
		return getBySlugsInOrder(SEARCH_PRIORITY_GUIDE_SLUGS);
	}

	public List<GuidePage> getPublicWaterBrandGuides() {
		return getBySlugsInOrder(PUBLIC_WATER_BRAND_GUIDE_SLUGS);
	}

	public boolean isSearchPriorityGuide(String slug) {
		return SEARCH_PRIORITY_GUIDE_SLUGS.contains(slug);
	}

	public List<GuidePage> getBySlugsInOrder(List<String> slugs) {
		return slugs.stream()
			.map(this::getBySlug)
			.flatMap(Optional::stream)
			.toList();
	}
}
