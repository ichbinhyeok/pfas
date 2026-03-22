package com.example.pfas.routeclick;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
public class RouteClickController {

	private final RouteClickService routeClickService;

	public RouteClickController(RouteClickService routeClickService) {
		this.routeClickService = routeClickService;
	}

	@PostMapping(
		value = {"/route-clicks", "/internal/route-clicks"},
		consumes = MediaType.APPLICATION_JSON_VALUE,
		produces = MediaType.APPLICATION_JSON_VALUE
	)
	public ResponseEntity<RouteClickAccepted> record(
		@RequestBody RouteClickPayload payload,
		@RequestHeader(value = "User-Agent", required = false) String userAgent
	) {
		try {
			return ResponseEntity.status(HttpStatus.ACCEPTED).body(routeClickService.recordClick(payload, userAgent));
		}
		catch (InvalidRouteClickPayloadException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, exception.getMessage(), exception);
		}
	}

	@GetMapping(value = "/internal/route-clicks/report", produces = MediaType.APPLICATION_JSON_VALUE)
	public RouteClickReport report() {
		return routeClickService.getReport();
	}
}
