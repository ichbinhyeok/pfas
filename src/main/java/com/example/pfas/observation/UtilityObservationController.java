package com.example.pfas.observation;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/utility-observations")
public class UtilityObservationController {

	private final UtilityObservationService utilityObservationService;

	public UtilityObservationController(UtilityObservationService utilityObservationService) {
		this.utilityObservationService = utilityObservationService;
	}

	@GetMapping
	public List<UtilityObservation> list(@RequestParam(required = false) String pwsid) {
		if (pwsid == null || pwsid.isBlank()) {
			return utilityObservationService.getAll();
		}

		return utilityObservationService.getByPwsid(pwsid);
	}

	@GetMapping("/{observationId}")
	public UtilityObservation getOne(@PathVariable String observationId) {
		return utilityObservationService.getByObservationId(observationId)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown observationId: " + observationId));
	}
}
