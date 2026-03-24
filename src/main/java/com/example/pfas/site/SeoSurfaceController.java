package com.example.pfas.site;

import java.util.Comparator;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.pfas.export.StaticExportService;

@RestController
public class SeoSurfaceController {

	private final StaticExportService staticExportService;
	private final SiteMetadataService siteMetadataService;

	public SeoSurfaceController(
		StaticExportService staticExportService,
		SiteMetadataService siteMetadataService
	) {
		this.staticExportService = staticExportService;
		this.siteMetadataService = siteMetadataService;
	}

	@GetMapping(value = "/robots.txt", produces = MediaType.TEXT_PLAIN_VALUE)
	public String robotsTxt() {
		return String.join("\n",
			"User-agent: *",
			"Allow: /",
			"Disallow: /internal/",
			"Disallow: /admin",
			"Disallow: /checker",
			"Disallow: /private-well-result/",
			"Sitemap: " + siteMetadataService.absoluteUrl("/sitemap.xml")
		);
	}

	@GetMapping(value = "/sitemap.xml", produces = MediaType.APPLICATION_XML_VALUE)
	public String sitemapXml() {
		var urls = staticExportService.buildManifest().items().stream()
			.filter(item -> "html".equals(item.contentKind()))
			.filter(item -> item.indexable())
			.sorted(Comparator.comparing(item -> item.path()))
			.toList();

		var builder = new StringBuilder();
		builder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		builder.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");
		for (var item : urls) {
			builder.append("<url>");
			builder.append("<loc>").append(escapeXml(siteMetadataService.absoluteUrl(item.path()))).append("</loc>");
			if (item.lastVerifiedDate() != null && !item.lastVerifiedDate().isBlank()) {
				builder.append("<lastmod>").append(escapeXml(item.lastVerifiedDate())).append("</lastmod>");
			}
			builder.append("</url>");
		}
		builder.append("</urlset>");
		return builder.toString();
	}

	private String escapeXml(String value) {
		return value
			.replace("&", "&amp;")
			.replace("<", "&lt;")
			.replace(">", "&gt;")
			.replace("\"", "&quot;")
			.replace("'", "&apos;");
	}
}
