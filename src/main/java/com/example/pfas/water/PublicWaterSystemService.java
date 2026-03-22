package com.example.pfas.water;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

@Service
public class PublicWaterSystemService {

	private static final Comparator<PublicWaterSystem> SYSTEM_ORDER =
		Comparator.comparing(PublicWaterSystem::stateCode)
			.thenComparing(PublicWaterSystem::pwsName);

	private final PublicWaterSystemRepository publicWaterSystemRepository;
	private volatile List<PublicWaterSystem> cachedSystems;
	private volatile Map<String, PublicWaterSystem> systemIndex;

	public PublicWaterSystemService(PublicWaterSystemRepository publicWaterSystemRepository) {
		this.publicWaterSystemRepository = publicWaterSystemRepository;
	}

	public List<PublicWaterSystem> getAll() {
		return snapshot();
	}

	public Optional<PublicWaterSystem> getByPwsid(String pwsid) {
		if (pwsid == null || pwsid.isBlank()) {
			return Optional.empty();
		}
		return Optional.ofNullable(index().get(pwsid.trim().toUpperCase(java.util.Locale.ROOT)));
	}

	public boolean isKnownPwsid(String pwsid) {
		return getByPwsid(pwsid).isPresent();
	}

	private List<PublicWaterSystem> snapshot() {
		var local = cachedSystems;
		if (local != null) {
			return local;
		}

		synchronized (this) {
			if (cachedSystems == null) {
				cachedSystems = publicWaterSystemRepository.findAll().stream()
					.sorted(SYSTEM_ORDER)
					.toList();
				systemIndex = cachedSystems.stream()
					.collect(Collectors.toUnmodifiableMap(
						system -> system.pwsid().toUpperCase(java.util.Locale.ROOT),
						Function.identity(),
						(left, right) -> left
					));
			}
			return cachedSystems;
		}
	}

	private Map<String, PublicWaterSystem> index() {
		snapshot();
		return systemIndex;
	}
}
