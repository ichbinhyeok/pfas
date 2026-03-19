package com.example.pfas.web;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import com.example.pfas.decision.PublicWaterDecisionService;
import com.example.pfas.result.PublicWaterResultService;
import com.example.pfas.water.PublicWaterSystemService;

@Controller
public class PublicPagesController {

	private final PublicWaterSystemService publicWaterSystemService;
	private final PublicWaterDecisionService publicWaterDecisionService;
	private final PublicWaterResultService publicWaterResultService;

	public PublicPagesController(
		PublicWaterSystemService publicWaterSystemService,
		PublicWaterDecisionService publicWaterDecisionService,
		PublicWaterResultService publicWaterResultService
	) {
		this.publicWaterSystemService = publicWaterSystemService;
		this.publicWaterDecisionService = publicWaterDecisionService;
		this.publicWaterResultService = publicWaterResultService;
	}

	@GetMapping("/")
	public String home(Model model) {
		model.addAttribute("systems", publicWaterSystemService.getAll());
		return "pages/home";
	}

	@GetMapping("/public-water/{pwsid}")
	public String publicWaterResult(@PathVariable String pwsid, Model model) {
		var system = publicWaterSystemService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown pwsid: " + pwsid));
		var decision = publicWaterDecisionService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No decision available for pwsid: " + pwsid));
		var result = publicWaterResultService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No result available for pwsid: " + pwsid));

		model.addAttribute("system", system);
		model.addAttribute("decision", decision);
		model.addAttribute("result", result);
		return "pages/public-water-result";
	}
}
