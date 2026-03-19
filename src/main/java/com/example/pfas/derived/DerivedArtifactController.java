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

	@GetMapping("/page-generation-manifest")
	public PageGenerationManifestFile pageGenerationManifest() {
		return service.buildPageGenerationManifest();
	}

	@GetMapping("/page-models/{routeType}/{routeKey}")
	public GeneratedPageModelFile pageModel(
		@org.springframework.web.bind.annotation.PathVariable String routeType,
		@org.springframework.web.bind.annotation.PathVariable String routeKey
	) {
		return service.buildPageModel(routeType, routeKey);
	}

	@PostMapping("/sync")
	public DerivedArtifactSyncReport sync() {
		return service.sync();
	}
}
