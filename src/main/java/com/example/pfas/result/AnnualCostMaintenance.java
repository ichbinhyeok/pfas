package com.example.pfas.result;

import java.math.BigDecimal;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record AnnualCostMaintenance(
	@JsonProperty("range_low_usd") BigDecimal rangeLowUsd,
	@JsonProperty("range_high_usd") BigDecimal rangeHighUsd,
	@JsonProperty("maintenance_burden") String maintenanceBurden,
	@JsonProperty("cadence_notes") List<String> cadenceNotes,
	@JsonProperty("notes") List<String> notes
) {
}
