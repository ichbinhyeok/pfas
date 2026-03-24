package com.example.pfas.internalapi;

import java.util.Comparator;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.pfas.derived.DerivedArtifactService;
import com.example.pfas.derived.DerivedArtifactSyncReport;
import com.example.pfas.merchant.MerchantClickCountEntry;
import com.example.pfas.merchant.MerchantClickReport;
import com.example.pfas.merchant.MerchantClickService;
import com.example.pfas.quality.FreshnessRouteFinding;
import com.example.pfas.quality.FreshnessSourceFinding;
import com.example.pfas.quality.QualityReportService;
import com.example.pfas.readiness.ExpansionReadinessItem;
import com.example.pfas.readiness.ExpansionReadinessService;
import com.example.pfas.readiness.ExpansionReadinessStatus;
import com.example.pfas.routeclick.RouteClickCountEntry;
import com.example.pfas.routeclick.RouteClickReport;
import com.example.pfas.routeclick.RouteClickService;
import com.example.pfas.source.SourceDocument;
import com.example.pfas.source.SourceRegistryService;
import com.example.pfas.site.SiteMetadataService;

@Controller
public class AdminConsoleController {

	private static final int DEFAULT_LIST_LIMIT = 12;

	private final DerivedArtifactService derivedArtifactService;
	private final QualityReportService qualityReportService;
	private final ExpansionReadinessService expansionReadinessService;
	private final SourceRegistryService sourceRegistryService;
	private final MerchantClickService merchantClickService;
	private final RouteClickService routeClickService;
	private final SiteMetadataService siteMetadataService;

	public AdminConsoleController(
		DerivedArtifactService derivedArtifactService,
		QualityReportService qualityReportService,
		ExpansionReadinessService expansionReadinessService,
		SourceRegistryService sourceRegistryService,
		MerchantClickService merchantClickService,
		RouteClickService routeClickService,
		SiteMetadataService siteMetadataService
	) {
		this.derivedArtifactService = derivedArtifactService;
		this.qualityReportService = qualityReportService;
		this.expansionReadinessService = expansionReadinessService;
		this.sourceRegistryService = sourceRegistryService;
		this.merchantClickService = merchantClickService;
		this.routeClickService = routeClickService;
		this.siteMetadataService = siteMetadataService;
	}

	@GetMapping("/admin")
	public String adminConsole(Model model) {
		var routeManifest = derivedArtifactService.buildRouteManifest();
		var searchIndex = derivedArtifactService.buildSearchIndexSeed();
		var pageGenerationManifest = derivedArtifactService.buildPageGenerationManifest();
		var qualityReport = qualityReportService.buildFreshnessReport();
		var readinessReport = expansionReadinessService.getReport();
		var merchantClickReport = merchantClickService.getReport();
		var routeClickReport = routeClickService.getReport();
		var sourceDocuments = sourceRegistryService.getAllDocuments();
		var readyItems = readinessReport.items().stream()
			.filter(item -> item.status() == ExpansionReadinessStatus.READY)
			.sorted(Comparator.comparing(item -> item.routeType() + ":" + item.routeKey()))
			.toList();
		var blockedItems = readinessReport.items().stream()
			.filter(item -> item.status() != ExpansionReadinessStatus.READY)
			.sorted(Comparator.comparing(item -> item.routeType() + ":" + item.routeKey()))
			.toList();

		model.addAttribute("routeManifest", routeManifest);
		model.addAttribute("searchIndex", searchIndex);
		model.addAttribute("pageGenerationManifest", pageGenerationManifest);
		model.addAttribute("qualityReport", qualityReport);
		model.addAttribute("topRouteFindings", limit(qualityReport.routeFindings(), DEFAULT_LIST_LIMIT));
		model.addAttribute("topStaleSources", limit(qualityReport.staleSources(), DEFAULT_LIST_LIMIT));
		model.addAttribute("readinessReport", readinessReport);
		model.addAttribute("readyItems", limit(readyItems, DEFAULT_LIST_LIMIT));
		model.addAttribute("blockedItems", limit(blockedItems, DEFAULT_LIST_LIMIT));
		model.addAttribute("merchantClickReport", merchantClickReport);
		model.addAttribute("topMerchantCounts", limit(merchantClickReport.merchantCounts(), 8));
		model.addAttribute("topMerchantSourcePages", limit(merchantClickReport.sourcePageCounts(), 8));
		model.addAttribute("routeClickReport", routeClickReport);
		model.addAttribute("topRouteTargets", limit(routeClickReport.byTargetPath(), 8));
		model.addAttribute("topRouteCtas", limit(routeClickReport.byCtaSlot(), 8));
		model.addAttribute("sourceDocumentCount", sourceDocuments.size());
		model.addAttribute("recentSources", recentSources(sourceDocuments, DEFAULT_LIST_LIMIT));
		model.addAttribute("adminCanonicalUrl", siteMetadataService.absoluteUrl("/admin"));
		return "pages/admin-console";
	}

	@PostMapping("/admin/derived/sync")
	public String syncDerivedArtifacts(RedirectAttributes redirectAttributes) {
		DerivedArtifactSyncReport report = derivedArtifactService.sync();
		redirectAttributes.addFlashAttribute("syncReport", report);
		return "redirect:/admin";
	}

	private List<AdminSourceRow> recentSources(List<SourceDocument> documents, int maxItems) {
		return documents.stream()
			.map(document -> new AdminSourceRow(
				document.sourceId(),
				document.organization(),
				document.title(),
				document.url(),
				mostRelevantDate(document)
			))
			.sorted(Comparator.comparing(AdminSourceRow::referenceDate, Comparator.nullsLast(Comparator.reverseOrder()))
				.thenComparing(AdminSourceRow::sourceId))
			.limit(maxItems)
			.toList();
	}

	private String mostRelevantDate(SourceDocument document) {
		return firstNonBlank(
			document.retrievedAt(),
			document.lastUpdatedDate(),
			document.effectiveDate(),
			document.publishedDate()
		);
	}

	private String firstNonBlank(String... values) {
		for (String value : values) {
			if (value != null && !value.isBlank()) {
				return value;
			}
		}
		return null;
	}

	private <T> List<T> limit(List<T> items, int maxItems) {
		return items.subList(0, Math.min(items.size(), maxItems));
	}

	public record AdminSourceRow(
		String sourceId,
		String organization,
		String title,
		String url,
		String referenceDate
	) {
	}
}
