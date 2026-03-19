package com.example.pfas.site;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class SiteMetadataAdvice {

	private final SiteMetadataService siteMetadataService;

	public SiteMetadataAdvice(SiteMetadataService siteMetadataService) {
		this.siteMetadataService = siteMetadataService;
	}

	@ModelAttribute("siteBaseUrl")
	public String siteBaseUrl() {
		return siteMetadataService.siteBaseUrl();
	}

	@ModelAttribute("siteEditorialOwner")
	public String siteEditorialOwner() {
		return siteMetadataService.editorialOwner();
	}

	@ModelAttribute("siteMethodologyOwner")
	public String siteMethodologyOwner() {
		return siteMetadataService.methodologyOwner();
	}

	@ModelAttribute("siteLastVerifiedDate")
	public String siteLastVerifiedDate() {
		return siteMetadataService.siteLastVerifiedDate();
	}
}
