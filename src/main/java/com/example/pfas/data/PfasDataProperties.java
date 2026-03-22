package com.example.pfas.data;

import java.nio.file.Files;
import java.nio.file.Path;

import org.springframework.boot.system.ApplicationHome;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "pfas.data")
public record PfasDataProperties(String root) {

	public Path rootPath() {
		var configuredRoot = root == null || root.isBlank() ? "data" : root;
		var path = Path.of(configuredRoot);
		if (path.isAbsolute()) {
			return path.normalize();
		}
		return resolveApplicationBaseDirectory().resolve(path).normalize();
	}

	private Path resolveApplicationBaseDirectory() {
		var applicationDirectory = new ApplicationHome(PfasDataProperties.class).getDir().toPath().toAbsolutePath().normalize();
		for (Path current = applicationDirectory; current != null; current = current.getParent()) {
			if (Files.exists(current.resolve("build.gradle"))
				|| Files.exists(current.resolve("settings.gradle"))
				|| Files.exists(current.resolve(".git"))) {
				return current;
			}
		}
		return applicationDirectory;
	}
}
