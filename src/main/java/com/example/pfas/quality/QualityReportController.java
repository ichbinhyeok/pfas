package com.example.pfas.quality;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/quality")
public class QualityReportController {

	private final QualityReportService service;

	public QualityReportController(QualityReportService service) {
		this.service = service;
	}

	@GetMapping("/freshness-report")
	public FreshnessQualityReport freshnessReport() {
		return service.buildFreshnessReport();
	}
}
