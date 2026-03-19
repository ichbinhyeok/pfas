package com.example.pfas.readiness;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/readiness")
public class ExpansionReadinessController {

	private final ExpansionReadinessService service;

	public ExpansionReadinessController(ExpansionReadinessService service) {
		this.service = service;
	}

	@GetMapping("/report")
	public ExpansionReadinessReport report() {
		return service.getReport();
	}
}
