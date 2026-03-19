package com.example.pfas.checker;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
		@RequestParam(required = false) String shoppingIntent,
		@RequestParam(required = false) Boolean wholeHouseConsidered,
		@RequestParam(required = false) String stateCode,
		@RequestParam(required = false) String pwsid
	) {
		var selection = actionCheckerService.normalize(
			waterSource,
			directData,
			shoppingIntent,
			wholeHouseConsidered,
			stateCode,
			pwsid
		);

		return new ActionCheckerResponse(selection, actionCheckerService.evaluate(selection));
	}
}
