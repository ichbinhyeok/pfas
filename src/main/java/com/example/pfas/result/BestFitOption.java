package com.example.pfas.result;

import com.fasterxml.jackson.annotation.JsonProperty;

public record BestFitOption(
	@JsonProperty("option_code") String optionCode,
	@JsonProperty("label") String label,
	@JsonProperty("fit_reason") String fitReason,
	@JsonProperty("not_for_everyone") String notForEveryone,
	@JsonProperty("cost_profile") String costProfile,
	@JsonProperty("maintenance_burden") String maintenanceBurden
) {
}
