package com.example.pfas.readiness;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/expansion")
public class ExpansionCandidateController {

	private final ExpansionCandidateService service;

	public ExpansionCandidateController(ExpansionCandidateService service) {
		this.service = service;
	}

	@GetMapping("/candidates")
	public List<ExpansionCandidate> candidates() {
		return service.getReadyCandidates();
	}
}
