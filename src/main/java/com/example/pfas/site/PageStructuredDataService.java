package com.example.pfas.site;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;

import com.example.pfas.filter.FilterCatalogItem;
import com.example.pfas.web.ComparePage;
import com.example.pfas.web.GuidePage;
import com.example.pfas.web.PresentationText;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class PageStructuredDataService {

	private static final String SITE_NAME = "PFAS Decision Engine";
	private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

	private final SiteMetadataService siteMetadataService;

	public PageStructuredDataService(SiteMetadataService siteMetadataService) {
		this.siteMetadataService = siteMetadataService;
	}

	public String comparePageJsonLd(ComparePage page, List<FilterCatalogItem> products) {
		var pageUrl = siteMetadataService.absoluteUrl("/compare/" + page.slug());
		var graph = new ArrayList<Map<String, Object>>();
		graph.add(webPageNode(pageUrl, page.title(), page.lede()));
		graph.add(articleNode(
			pageUrl,
			page.title(),
			page.lede(),
			page.lastVerifiedDate(),
			page.targetQueries(),
			List.of("PFAS", "drinking water filtration", "product comparison")
		));
		graph.add(breadcrumbNode(pageUrl, List.of(
			breadcrumbItem(1, "Home", siteMetadataService.absoluteUrl("/")),
			breadcrumbItem(2, "Compare", siteMetadataService.absoluteUrl("/compare/" + page.slug())),
			breadcrumbItem(3, page.title(), pageUrl)
		)));
		if (products != null && !products.isEmpty()) {
			graph.add(itemListNode(pageUrl, page.title(), products));
		}
		return toJsonLd(graph);
	}

	public String guidePageJsonLd(GuidePage page, List<FilterCatalogItem> products) {
		var pageUrl = siteMetadataService.absoluteUrl("/guides/" + page.slug());
		var graph = new ArrayList<Map<String, Object>>();
		graph.add(webPageNode(pageUrl, page.title(), page.lede()));
		graph.add(articleNode(
			pageUrl,
			page.title(),
			page.lede(),
			page.lastVerifiedDate(),
			page.targetQueries(),
			List.of("PFAS", "drinking water decision guide", "certified filter guidance")
		));
		graph.add(breadcrumbNode(pageUrl, List.of(
			breadcrumbItem(1, "Home", siteMetadataService.absoluteUrl("/")),
			breadcrumbItem(2, "Guides", siteMetadataService.absoluteUrl("/guides/" + page.slug())),
			breadcrumbItem(3, page.title(), pageUrl)
		)));
		if (products != null && !products.isEmpty()) {
			graph.add(itemListNode(pageUrl, page.title() + " linked products", products));
		}
		return toJsonLd(graph);
	}

	private Map<String, Object> webPageNode(String pageUrl, String title, String description) {
		return linkedMap(
			"@type", "WebPage",
			"@id", pageUrl + "#webpage",
			"url", pageUrl,
			"name", title,
			"description", description,
			"isPartOf", linkedMap(
				"@type", "WebSite",
				"name", SITE_NAME,
				"url", siteMetadataService.siteBaseUrl()
			)
		);
	}

	private Map<String, Object> articleNode(
		String pageUrl,
		String title,
		String description,
		String lastVerifiedDate,
		List<String> targetQueries,
		List<String> aboutTerms
	) {
		var article = new LinkedHashMap<String, Object>();
		article.put("@type", "Article");
		article.put("@id", pageUrl + "#article");
		article.put("headline", title);
		article.put("description", description);
		article.put("mainEntityOfPage", linkedMap("@id", pageUrl + "#webpage"));
		article.put("publisher", linkedMap(
			"@type", "Organization",
			"name", SITE_NAME,
			"url", siteMetadataService.siteBaseUrl()
		));
		var author = authorNode();
		if (author != null) {
			article.put("author", author);
		}
		if (lastVerifiedDate != null && !lastVerifiedDate.isBlank()) {
			article.put("dateModified", lastVerifiedDate);
		}
		if (targetQueries != null && !targetQueries.isEmpty()) {
			article.put("keywords", String.join(", ", targetQueries));
		}
		if (aboutTerms != null && !aboutTerms.isEmpty()) {
			article.put("about", aboutTerms);
		}
		return article;
	}

	private Map<String, Object> breadcrumbNode(String pageUrl, List<Map<String, Object>> items) {
		return linkedMap(
			"@type", "BreadcrumbList",
			"@id", pageUrl + "#breadcrumbs",
			"itemListElement", items
		);
	}

	private Map<String, Object> breadcrumbItem(int position, String name, String url) {
		return linkedMap(
			"@type", "ListItem",
			"position", position,
			"name", name,
			"item", url
		);
	}

	private Map<String, Object> itemListNode(String pageUrl, String title, List<FilterCatalogItem> products) {
		var itemList = new ArrayList<Map<String, Object>>();
		var position = 1;
		for (var product : products) {
			itemList.add(linkedMap(
				"@type", "ListItem",
				"position", position++,
				"item", productNode(product)
			));
		}
		return linkedMap(
			"@type", "ItemList",
			"@id", pageUrl + "#itemlist",
			"name", title,
			"itemListElement", itemList
		);
	}

	private Map<String, Object> productNode(FilterCatalogItem product) {
		var node = new LinkedHashMap<String, Object>();
		node.put("@type", "Product");
		node.put("name", product.brand() + " " + product.model());
		node.put("brand", linkedMap("@type", "Brand", "name", product.brand()));
		node.put("category", PresentationText.filterTypeLabel(product.filterType()) + " / " + PresentationText.installationTypeLabel(product.installationType()));
		node.put("description", PresentationText.bestForLabel(product) + " " + PresentationText.sellerChoiceNote(product));
		if (product.listingUrl() != null && !product.listingUrl().isBlank()) {
			node.put("url", product.listingUrl());
		}
		if (product.listingRecordId() != null && !product.listingRecordId().isBlank()) {
			node.put("sku", product.listingRecordId());
		}
		var offers = offerNode(product);
		if (offers != null) {
			node.put("offers", offers);
		}
		var positiveNotes = listItemNotes(PresentationText.productPros(product));
		if (!positiveNotes.isEmpty()) {
			node.put("positiveNotes", positiveNotes);
		}
		var negativeNotes = listItemNotes(PresentationText.productConstraints(product));
		if (!negativeNotes.isEmpty()) {
			node.put("negativeNotes", negativeNotes);
		}
		return node;
	}

	private Map<String, Object> offerNode(FilterCatalogItem product) {
		if (product.upfrontCostUsd() == null || product.listingUrl() == null || product.listingUrl().isBlank()) {
			return null;
		}
		return linkedMap(
			"@type", "Offer",
			"price", product.upfrontCostUsd().stripTrailingZeros().toPlainString(),
			"priceCurrency", "USD",
			"url", product.listingUrl()
		);
	}

	private List<Map<String, Object>> listItemNotes(List<String> values) {
		if (values == null || values.isEmpty()) {
			return List.of();
		}
		var notes = new ArrayList<Map<String, Object>>();
		for (var value : values.stream().filter(Objects::nonNull).filter(text -> !text.isBlank()).limit(3).toList()) {
			notes.add(linkedMap("@type", "ListItem", "name", value));
		}
		return notes;
	}

	private Map<String, Object> authorNode() {
		var owner = siteMetadataService.editorialOwner();
		if (owner == null || owner.isBlank() || owner.toLowerCase().contains("not publicly named")) {
			return null;
		}
		return linkedMap("@type", "Organization", "name", owner);
	}

	private String toJsonLd(List<Map<String, Object>> graph) {
		try {
			return JSON_MAPPER.writeValueAsString(linkedMap(
				"@context", "https://schema.org",
				"@graph", graph
			)).replace("</", "<\\/");
		}
		catch (JsonProcessingException exception) {
			throw new IllegalStateException("Failed to render structured data", exception);
		}
	}

	private Map<String, Object> linkedMap(Object... values) {
		var map = new LinkedHashMap<String, Object>();
		for (var index = 0; index < values.length; index += 2) {
			var key = (String) values[index];
			var value = values[index + 1];
			if (value != null) {
				map.put(key, value);
			}
		}
		return map;
	}
}
