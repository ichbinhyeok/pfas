package com.example.pfas.web;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class GuidePageService {

	private final Map<String, GuidePage> pages;

	public GuidePageService() {
		this.pages = Map.of(
			"public-water-vs-private-well",
			new GuidePage(
				"public-water-vs-private-well",
				"High-intent guide",
				"Public water vs private well is the first split, not a small detail",
				"These are different evidence systems. Public water begins with utility records. Private wells begin with owner-driven testing and state guidance.",
				"Split the household path before comparing filters",
				"Do not answer a private-well question with a CCR workflow, and do not answer a public-water question with generic well-testing advice.",
				List.of(
					"Public water has utility and regulator records that can act as direct evidence.",
					"Private wells are owner-managed and need a test-first route.",
					"The same PFAS question becomes a different next action depending on source type."
				),
				List.of(
					"This split does not tell you whether the water is safe or unsafe.",
					"It does not replace a direct utility document or a direct well test.",
					"It does not justify whole-house by itself."
				),
				List.of(
					"Identify the water source first.",
					"If public water, open the utility path.",
					"If private well, open the state-guided testing path."
				),
				List.of(
					"EPA CCR guidance establishes public-water reporting as a direct-evidence path.",
					"EPA private-well guidance keeps testing owner-driven and state-guided.",
					"The first split is evidence system, not product category."
				),
				List.of(
					"epa-ccr-consumer-info",
					"epa-private-wells",
					"epa-pfas-private-wells"
				),
				"/checker",
				"Open Action Checker",
				"/guides/test-first-vs-filter-first",
				"Read test-first logic",
				"2026-03-19"
			),
			"test-first-vs-filter-first",
			new GuidePage(
				"test-first-vs-filter-first",
				"High-intent guide",
				"Test first vs filter first is mostly a question about evidence quality",
				"Buying first feels faster, but the project should usually force direct evidence ahead of shopping unless an official utility context already exists.",
				"Open the direct-evidence path before the shopping path",
				"Shopping intent should not outrank missing direct data. Public water means utility first. Private well means test first.",
				List.of(
					"Direct evidence changes what kind of product is even appropriate.",
					"Testing and interpretation help avoid overbuying.",
					"Certification is meaningful only after the household path is defined."
				),
				List.of(
					"This does not mean nobody should ever buy a filter before testing.",
					"It does mean the project should not normalize product-first advice as the baseline.",
					"It does not prove a future benchmark relation without direct data."
				),
				List.of(
					"Public water without direct records: start with the utility.",
					"Private well without a test: start with state-guided testing.",
					"Only then compare certified point-of-use."
				),
				List.of(
					"EPA private-well guidance keeps direct testing ahead of shopping.",
					"EPA filter guidance supports certification-first product review, not product-first routing.",
					"CCR context is the public-water equivalent of a test-first branch."
				),
				List.of(
					"epa-ccr-consumer-info",
					"epa-pfas-private-wells",
					"epa-certified-pfas-filter-guidance"
				),
				"/checker",
				"Open Action Checker",
				"/guides/pfas-filter-annual-cost",
				"Review cost tradeoffs",
				"2026-03-19"
			),
			"read-your-ccr",
			new GuidePage(
				"read-your-ccr",
				"High-intent guide",
				"How to read your CCR or utility report without turning it into a false household verdict",
				"A CCR is a routing tool, not a magic answer. The engine should use it to establish source, system, timing, and whether a newer PFAS notice or direct utility page exists.",
				"Use the CCR to find the next direct utility layer",
				"Read PWSID, report year, system source, and any PFAS or treatment notes before opening product comparison.",
				List.of(
					"The CCR tells you what system you are actually on.",
					"It can point you to more current utility PFAS pages or notices.",
					"It prevents ZIP-based guessing from outranking direct system evidence."
				),
				List.of(
					"A CCR alone is not a household tap test.",
					"It may not reflect the newest PFAS notice or running annual average.",
					"It should not be converted into safe or unsafe language."
				),
				List.of(
					"Find the system name and PWSID.",
					"Check the report date.",
					"Open any newer PFAS notice or utility PFAS page."
				),
				List.of(
					"EPA says community water systems deliver annual CCRs by July 1, but newer PFAS notices can still outrank an older report.",
					"Philadelphia and Lancaster show how a CCR and a newer PFAS page or notice need to be read together.",
					"The CCR is a routing layer into the direct utility record, not a household verdict."
				),
				List.of(
					"epa-ccr-consumer-info",
					"phila-2024-water-quality-report",
					"phila-pfas-management",
					"lancaster-2024-water-quality-report",
					"lancaster-pfoa-notice-2025"
				),
				"/public-water-system/PA1510001",
				"Open seeded utility context",
				"/checker",
				"Open Action Checker",
				"2026-03-19"
			),
			"nsf-53-vs-58-pfas",
			new GuidePage(
				"nsf-53-vs-58-pfas",
				"High-intent guide",
				"NSF 53 vs 58 is not enough by itself for PFAS decisions",
				"The standard code matters, but the project should still check the exact claim, model, replacement cadence, and cost before treating a product as a fit.",
				"Read the claim before reading the badge",
				"A product should only open if the exact model has direct PFAS claim support and the maintenance burden still makes sense for the household.",
				List.of(
					"Standard numbers without claim scope can be misleading.",
					"Claim-level support matters more than broad category language.",
					"Replacement burden can matter as much as the upfront badge."
				),
				List.of(
					"This guide does not make one standard universally better for everyone.",
					"It does not replace model-specific listing verification.",
					"It does not mean certification equals every current regulatory benchmark."
				),
				List.of(
					"Check the exact model.",
					"Check the PFAS claim language.",
					"Check replacement cadence and annual ownership cost."
				),
				List.of(
					"EPA filter guidance says current certification should not be treated as automatic proof of every current EPA benchmark.",
					"NSF listing directories and PFAS guidance pages support claim-level verification over badge-only reading.",
					"Model-specific listing records matter more than broad standard shorthand."
				),
				List.of(
					"epa-certified-pfas-filter-guidance",
					"nsf-pfas-drinking-water-article",
					"nsf-dwtu-listings",
					"nsf-espring-listing-053"
				),
				"/source-policy",
				"Open source policy",
				"/checker",
				"Open Action Checker",
				"2026-03-19"
			),
			"under-sink-vs-whole-house",
			new GuidePage(
				"under-sink-vs-whole-house",
				"High-intent guide",
				"Under-sink vs whole-house should start with purpose, not fear",
				"Whole-house is an escalation path, not a default upgrade. For PFAS, the engine should keep ingestion-focused point-of-use visible until a broader whole-home objective is actually justified.",
				"Keep point-of-use first unless the household goal clearly exceeds drinking and cooking water",
				"Whole-house should open only after purpose, maintenance, and cost have been compared against certified point-of-use options.",
				List.of(
					"Whole-house systems have higher ownership and maintenance consequences.",
					"Many households are really solving for ingestion-focused use.",
					"The project should not turn uncertainty into a whole-home upsell."
				),
				List.of(
					"This guide does not say whole-house is never appropriate.",
					"It says whole-house needs a stronger justification than product-first fear.",
					"It does not replace current utility or state guidance."
				),
				List.of(
					"Define the household objective.",
					"Compare against certified point-of-use first.",
					"Only then review whole-house as an escalation."
				),
				List.of(
					"EPA filter guidance centers certified point-of-use for ingestion-focused PFAS reduction.",
					"EPA fact-sheet framing and model data sheets keep maintenance and install burden visible.",
					"Whole-house becomes a justified escalation only after a broader household objective is explicit."
				),
				List.of(
					"epa-certified-pfas-filter-guidance",
					"epa-water-filter-fact-sheet-2024-04",
					"aq-claryum-direct-connect-install-pdf",
					"amway-espring-122941-product"
				),
				"/checker",
				"Open Action Checker",
				"/guides/pfas-filter-annual-cost",
				"Review annual cost",
				"2026-03-19"
			),
			"pfas-filter-annual-cost",
			new GuidePage(
				"pfas-filter-annual-cost",
				"High-intent guide",
				"PFAS filter annual cost matters because maintenance changes the real decision",
				"Upfront price is the wrong shortcut. Cartridge cadence, replacement cost, and whether the path is even justified determine whether a product is reasonable.",
				"Read annual ownership before treating a product as a fit",
				"Annual cost and maintenance burden should sit beside the interpretation result, not far downstream in a shopping flow.",
				List.of(
					"A low upfront price can still create a high maintenance burden.",
					"Annual cost changes whether a product is realistic for the household.",
					"Cost transparency helps block unnecessary escalation."
				),
				List.of(
					"This guide does not replace direct evidence about whether treatment is warranted.",
					"It does not assume one household usage pattern for everyone.",
					"It does not make price more important than certification or fit."
				),
				List.of(
					"Check replacement cadence.",
					"Check annual cartridge cost.",
					"Compare burden before upgrading the treatment class."
				),
				List.of(
					"EPA filter guidance supports comparing upkeep and replacement burden, not just upfront price.",
					"Aquasana and Amway product records provide model-specific cadence and replacement pricing inputs.",
					"Annual ownership belongs beside the interpretation result because maintenance changes product fit."
				),
				List.of(
					"epa-certified-pfas-filter-guidance",
					"aq-claryum-direct-connect-product",
					"aq-claryum-direct-connect-replacement",
					"amway-espring-100186-cartridge"
				),
				"/checker",
				"Open Action Checker",
				"/public-water/PA1510001",
				"Open seeded result",
				"2026-03-19"
			)
		);
	}

	public List<GuidePage> getAll() {
		return pages.values().stream()
			.sorted(java.util.Comparator.comparing(GuidePage::slug))
			.toList();
	}

	public Optional<GuidePage> getBySlug(String slug) {
		return Optional.ofNullable(pages.get(slug));
	}
}
