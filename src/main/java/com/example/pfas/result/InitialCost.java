package com.example.pfas.result;

import java.math.BigDecimal;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record InitialCost(
	@JsonProperty("range_low_usd") BigDecimal rangeLowUsd,
	@JsonProperty("range_high_usd") BigDecimal rangeHighUsd,
	@JsonProperty("confidence") String confidence,
	@JsonProperty("notes") List<String> notes
) {
}
