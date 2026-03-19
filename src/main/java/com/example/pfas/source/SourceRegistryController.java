package com.example.pfas.source;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/source-registry")
public class SourceRegistryController {

	private final SourceRegistryService sourceRegistryService;

	public SourceRegistryController(SourceRegistryService sourceRegistryService) {
		this.sourceRegistryService = sourceRegistryService;
	}

	@GetMapping
	public List<SourceDocument> listDocuments() {
		return sourceRegistryService.getAllDocuments();
	}

	@GetMapping("/{sourceId}")
	public SourceDocument getDocument(@PathVariable String sourceId) {
		return sourceRegistryService.getDocument(sourceId)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown source_id: " + sourceId));
	}
}
