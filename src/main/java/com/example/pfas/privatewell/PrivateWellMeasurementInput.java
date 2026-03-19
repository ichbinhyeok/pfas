package com.example.pfas.privatewell;

import java.math.BigDecimal;

public record PrivateWellMeasurementInput(
	String analyteCode,
	BigDecimal inputValue,
	String inputUnit
) {
}
