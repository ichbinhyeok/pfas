package com.example.pfas.export;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/derived")
public class StaticExportController {

	private final StaticExportService service;

	public StaticExportController(StaticExportService service) {
		this.service = service;
	}

	@GetMapping("/static-export-manifest")
	public StaticExportManifestFile staticExportManifest() {
		return service.buildManifest();
	}
}
