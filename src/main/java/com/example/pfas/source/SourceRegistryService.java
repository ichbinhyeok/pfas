package com.example.pfas.source;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

@Service
public class SourceRegistryService {

	private static final Comparator<SourceDocument> DOCUMENT_ORDER =
		Comparator.comparingInt(SourceDocument::trustTier)
			.thenComparing(SourceDocument::sourceId);

	private final SourceRegistryRepository sourceRegistryRepository;
	private volatile List<SourceDocument> cachedDocuments;
	private volatile Map<String, SourceDocument> documentIndex;
	private volatile String cachedGeneratedAt;

	public SourceRegistryService(SourceRegistryRepository sourceRegistryRepository) {
		this.sourceRegistryRepository = sourceRegistryRepository;
	}

	public List<SourceDocument> getAllDocuments() {
		return snapshot();
	}

	public Optional<SourceDocument> getDocument(String sourceId) {
		if (sourceId == null || sourceId.isBlank()) {
			return Optional.empty();
		}
		return Optional.ofNullable(index().get(sourceId.trim().toUpperCase(java.util.Locale.ROOT)));
	}

	public Optional<String> registryGeneratedAt() {
		snapshot();
		return Optional.ofNullable(cachedGeneratedAt);
	}

	private List<SourceDocument> snapshot() {
		var local = cachedDocuments;
		if (local != null) {
			return local;
		}

		synchronized (this) {
			if (cachedDocuments == null) {
				cachedDocuments = sourceRegistryRepository.findAll().stream()
					.sorted(DOCUMENT_ORDER)
					.toList();
				documentIndex = cachedDocuments.stream()
					.collect(Collectors.toUnmodifiableMap(
						document -> document.sourceId().toUpperCase(java.util.Locale.ROOT),
						Function.identity(),
						(left, right) -> left
					));
				cachedGeneratedAt = sourceRegistryRepository.findGeneratedAt().orElse(null);
			}
			return cachedDocuments;
		}
	}

	private Map<String, SourceDocument> index() {
		snapshot();
		return documentIndex;
	}
}
