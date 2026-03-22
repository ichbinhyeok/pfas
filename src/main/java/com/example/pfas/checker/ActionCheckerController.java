package com.example.pfas.checker;

import java.util.Locale;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/action-checker")
public class ActionCheckerController {

	private final ActionCheckerService actionCheckerService;

	public ActionCheckerController(ActionCheckerService actionCheckerService) {
		this.actionCheckerService = actionCheckerService;
	}

	@GetMapping("/recommendation")
	public ActionCheckerResponse recommendation(
		@RequestParam(required = false) String waterSource,
		@RequestParam(required = false) String directData,
		@RequestParam(required = false) String indirectData,
		@RequestParam(required = false) String benchmarkRelation,
		@RequestParam(required = false) String currentFilterStatus,
		@RequestParam(required = false) String shoppingIntent,
		@RequestParam(required = false) Boolean wholeHouseConsidered,
		@RequestParam(required = false) String stateCode,
		@RequestParam(required = false) String pwsid
	) {
		validateRouteInputs(waterSource, stateCode, pwsid);

		var selection = actionCheckerService.normalize(
			waterSource,
			directData,
			indirectData,
			benchmarkRelation,
			currentFilterStatus,
			shoppingIntent,
			wholeHouseConsidered,
			stateCode,
			pwsid
		);

		return new ActionCheckerResponse(selection, actionCheckerService.evaluate(selection));
	}

	private void validateRouteInputs(String waterSource, String stateCode, String pwsid) {
		var normalizedWaterSource = waterSource == null ? "" : waterSource.trim().toUpperCase(Locale.ROOT);

		if ("PRIVATE_WELL".equals(normalizedWaterSource)
			&& stateCode != null
			&& !stateCode.isBlank()
			&& !actionCheckerService.isKnownStateCode(stateCode)) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unknown stateCode: " + stateCode);
		}

		if ((normalizedWaterSource.isBlank() || "PUBLIC_WATER".equals(normalizedWaterSource))
			&& pwsid != null
			&& !pwsid.isBlank()
			&& !actionCheckerService.isKnownPwsid(pwsid)) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unknown pwsid: " + pwsid);
		}
	}
}
