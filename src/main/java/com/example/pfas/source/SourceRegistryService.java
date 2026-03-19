package com.example.pfas.source;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class SourceRegistryService {

	private static final Comparator<SourceDocument> DOCUMENT_ORDER =
		Comparator.comparingInt(SourceDocument::trustTier)
			.thenComparing(SourceDocument::sourceId);

	private final SourceRegistryRepository sourceRegistryRepository;

	public SourceRegistryService(SourceRegistryRepository sourceRegistryRepository) {
		this.sourceRegistryRepository = sourceRegistryRepository;
	}

	public List<SourceDocument> getAllDocuments() {
		return sourceRegistryRepository.findAll().stream()
			.sorted(DOCUMENT_ORDER)
			.toList();
	}

	public Optional<SourceDocument> getDocument(String sourceId) {
		return sourceRegistryRepository.findBySourceId(sourceId);
	}
}
