package com.example.pfas.derived;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/derived")
public class DerivedArtifactController {

	private final DerivedArtifactService service;

	public DerivedArtifactController(DerivedArtifactService service) {
		this.service = service;
	}

	@GetMapping("/route-manifest")
	public RouteManifestFile routeManifest() {
		return service.buildRouteManifest();
	}

	@GetMapping("/search-index")
	public SearchIndexSeedFile searchIndex() {
		return service.buildSearchIndexSeed();
	}

	@GetMapping("/decision-inputs")
	public DecisionInputSeedFile decisionInputs() {
		return service.buildDecisionInputSeed();
	}

	@PostMapping("/sync")
	public DerivedArtifactSyncReport sync() {
		return service.sync();
	}
}
