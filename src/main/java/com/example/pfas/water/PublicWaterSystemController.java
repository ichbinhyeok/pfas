package com.example.pfas.water;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/internal/public-water-systems")
public class PublicWaterSystemController {

	private final PublicWaterSystemService publicWaterSystemService;

	public PublicWaterSystemController(PublicWaterSystemService publicWaterSystemService) {
		this.publicWaterSystemService = publicWaterSystemService;
	}

	@GetMapping
	public List<PublicWaterSystem> list() {
		return publicWaterSystemService.getAll();
	}

	@GetMapping("/{pwsid}")
	public PublicWaterSystem getOne(@PathVariable String pwsid) {
		return publicWaterSystemService.getByPwsid(pwsid)
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown pwsid: " + pwsid));
	}
}
