package com.example.pfas.water;

import java.util.List;

public record PublicWaterSystem(
	String pwsid,
	String pwsName,
	String stateCode,
	String systemType,
	String populationServed,
	String sourceWaterType,
	String utilityWebsiteUrl,
	String ccrUrl,
	String pfasNoticeUrl,
	String serviceAreaNotes,
	String lastVerifiedDate,
	List<String> sourceIds
) {
}
