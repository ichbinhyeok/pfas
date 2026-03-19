package com.example.pfas.water;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class PublicWaterSystemService {

	private static final Comparator<PublicWaterSystem> SYSTEM_ORDER =
		Comparator.comparing(PublicWaterSystem::stateCode)
			.thenComparing(PublicWaterSystem::pwsName);

	private final PublicWaterSystemRepository publicWaterSystemRepository;

	public PublicWaterSystemService(PublicWaterSystemRepository publicWaterSystemRepository) {
		this.publicWaterSystemRepository = publicWaterSystemRepository;
	}

	public List<PublicWaterSystem> getAll() {
		return publicWaterSystemRepository.findAll().stream()
			.sorted(SYSTEM_ORDER)
			.toList();
	}

	public Optional<PublicWaterSystem> getByPwsid(String pwsid) {
		return publicWaterSystemRepository.findByPwsid(pwsid);
	}
}
