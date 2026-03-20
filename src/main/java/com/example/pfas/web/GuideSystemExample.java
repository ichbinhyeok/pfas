package com.example.pfas.web;

import com.example.pfas.result.WaterDecisionResult;
import com.example.pfas.water.PublicWaterSystem;

public record GuideSystemExample(
	PublicWaterSystem system,
	WaterDecisionResult result
) {
}
