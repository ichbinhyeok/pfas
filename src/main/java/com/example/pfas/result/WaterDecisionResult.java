package com.example.pfas.result;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

public record WaterDecisionResult(
	@JsonProperty("result_id") String resultId,
	@JsonProperty("schema_version") String schemaVersion,
	@JsonProperty("generated_at") String generatedAt,
	@JsonProperty("next_action") NextAction nextAction,
	@JsonProperty("why_this") List<String> whyThis,
	@JsonProperty("what_this_does_not_tell_you") List<String> whatThisDoesNotTellYou,
	@JsonProperty("initial_cost") InitialCost initialCost,
	@JsonProperty("annual_cost_maintenance") AnnualCostMaintenance annualCostMaintenance,
	@JsonProperty("certification_checklist") List<CertificationChecklistItem> certificationChecklist,
	@JsonProperty("best_fit_options") List<BestFitOption> bestFitOptions,
	@JsonProperty("when_to_escalate") List<String> whenToEscalate,
	@JsonProperty("sources") List<ResultSource> sources,
	@JsonProperty("meta") ResultMeta meta
) {
}
