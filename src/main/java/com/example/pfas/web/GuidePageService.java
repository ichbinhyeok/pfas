package com.example.pfas.web;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class GuidePageService {

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
}
