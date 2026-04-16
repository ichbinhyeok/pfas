package com.example.pfas.export;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.pfas.data.PfasDataProperties;
import com.example.pfas.derived.DerivedArtifactService;
import com.example.pfas.site.SiteMetadataService;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class StaticExportService {

	private static final String SCHEMA_VERSION = "v1";
	private static final ObjectMapper JSON_MAPPER = new ObjectMapper();

	private final DerivedArtifactService derivedArtifactService;
	private final PfasDataProperties dataProperties;
	private final SiteMetadataService siteMetadataService;

	public StaticExportService(
		DerivedArtifactService derivedArtifactService,
		PfasDataProperties dataProperties,
		SiteMetadataService siteMetadataService
	) {
		this.derivedArtifactService = derivedArtifactService;
		this.dataProperties = dataProperties;
		this.siteMetadataService = siteMetadataService;
	}

	public StaticExportManifestFile buildManifest() {
		var generatedAt = OffsetDateTime.now().toString();
		var siteLastVerifiedDate = siteMetadataService.siteLastVerifiedDate();
		var items = new LinkedHashMap<String, StaticExportManifestItem>();

		addFixedItem(items, "/", true, "fixed_page", siteLastVerifiedDate);
		addFixedItem(items, "/checker", false, "fixed_page", siteLastVerifiedDate);
		addFixedItem(items, "/methodology", true, "fixed_page", siteLastVerifiedDate);
		addFixedItem(items, "/source-policy", true, "fixed_page", siteLastVerifiedDate);
		addFixedItem(items, "/robots.txt", true, "seo_surface", siteLastVerifiedDate);
		addFixedItem(items, "/sitemap.xml", true, "seo_surface", siteLastVerifiedDate);
		addFixedItem(items, "/css/app.css", false, "asset", siteLastVerifiedDate);
		addFixedItem(items, "/css/tailwind.css", false, "asset", siteLastVerifiedDate);
		addFixedItem(items, "/js/merchant-tracking.js", false, "asset", siteLastVerifiedDate);
		addFixedItem(items, "/js/route-click-tracking.js", false, "asset", siteLastVerifiedDate);
		addFixedItem(items, "/js/route-actions.js", false, "asset", siteLastVerifiedDate);
		addFixedItem(items, "/favicon.svg", false, "asset", siteLastVerifiedDate);
		addFixedItem(items, "/favicon.png", false, "asset", siteLastVerifiedDate);

		var pageGenerationManifest = derivedArtifactService.buildPageGenerationManifest();
		pageGenerationManifest.models().stream()
			.forEach(model ->
			items.putIfAbsent(
				model.renderPath(),
				new StaticExportManifestItem(
					model.renderPath(),
					toOutputPath(model.renderPath()),
					"html",
					model.indexable(),
					"generated_page_model",
					model.lastVerifiedDate()
				)
			))
		;

		pageGenerationManifest.models().stream()
			.filter(model -> "public_water".equals(model.routeType()))
			.forEach(model -> items.putIfAbsent(
				"/public-water-system/" + model.routeKey(),
				new StaticExportManifestItem(
					"/public-water-system/" + model.routeKey(),
					toOutputPath("/public-water-system/" + model.routeKey()),
					"html",
					true,
					"public_water_support_page",
					model.lastVerifiedDate()
				)
			));

		var orderedItems = new ArrayList<>(items.values());
		return new StaticExportManifestFile(SCHEMA_VERSION, generatedAt, orderedItems.size(), List.copyOf(orderedItems));
	}

	public StaticExportReport export(String baseUrl) {
		derivedArtifactService.sync();
		var manifest = buildManifest();
		var root = dataProperties.rootPath().getParent().resolve("build/static-export").normalize();

		writeManifest(manifest);

		var client = HttpClient.newHttpClient();
		manifest.items().forEach(item -> fetchAndWrite(client, baseUrl, root, item));
		writeNoJekyll(root);

		return new StaticExportReport(
			SCHEMA_VERSION,
			OffsetDateTime.now().toString(),
			root.toString().replace('\\', '/'),
			manifest.itemCount()
		);
	}

	private void fetchAndWrite(HttpClient client, String baseUrl, Path outputRoot, StaticExportManifestItem item) {
		var request = HttpRequest.newBuilder(URI.create(baseUrl + item.path())).GET().build();
		try {
			var response = client.send(request, HttpResponse.BodyHandlers.ofByteArray());
			if (response.statusCode() != 200) {
				throw new IllegalStateException("Static export request failed for " + item.path() + " with status " + response.statusCode());
			}

			var outputPath = outputRoot.resolve(item.outputPath());
			Files.createDirectories(outputPath.getParent());
			Files.write(outputPath, response.body());
		}
		catch (InterruptedException exception) {
			Thread.currentThread().interrupt();
			throw new IllegalStateException("Failed to export " + item.path(), exception);
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to export " + item.path(), exception);
		}
	}

	private void writeManifest(StaticExportManifestFile manifest) {
		var manifestPath = dataProperties.rootPath().resolve("derived/page_models/static_export_manifest.json");
		try {
			Files.createDirectories(manifestPath.getParent());
			JSON_MAPPER.writerWithDefaultPrettyPrinter().writeValue(manifestPath.toFile(), manifest);
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to write static export manifest", exception);
		}
	}

	private void addFixedItem(
		LinkedHashMap<String, StaticExportManifestItem> items,
		String path,
		boolean indexable,
		String sourceKind,
		String lastVerifiedDate
	) {
		items.putIfAbsent(
			path,
			new StaticExportManifestItem(
				path,
				toOutputPath(path),
				path.contains(".") ? "asset" : "html",
				indexable,
				sourceKind,
				lastVerifiedDate
			)
		);
	}

	private void writeNoJekyll(Path outputRoot) {
		try {
			Files.createDirectories(outputRoot);
			Files.writeString(outputRoot.resolve(".nojekyll"), "");
		}
		catch (IOException exception) {
			throw new IllegalStateException("Failed to write .nojekyll", exception);
		}
	}

	private String toOutputPath(String path) {
		if ("/".equals(path)) {
			return "index.html";
		}
		if (path.contains(".")) {
			return path.substring(1);
		}
		return path.substring(1) + "/index.html";
	}
}
