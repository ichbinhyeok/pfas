package com.example.pfas.web;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class GuidePageService {

	private final GuidePageRepository guidePageRepository;

	public GuidePageService(GuidePageRepository guidePageRepository) {
		this.guidePageRepository = guidePageRepository;
	}

	public List<GuidePage> getAll() {
		return guidePageRepository.findAll().stream()
			.sorted(Comparator.comparing(GuidePage::slug))
			.toList();
	}

	public Optional<GuidePage> getBySlug(String slug) {
		return guidePageRepository.findAll().stream()
			.filter(page -> page.slug().equals(slug))
			.findFirst();
	}
}
