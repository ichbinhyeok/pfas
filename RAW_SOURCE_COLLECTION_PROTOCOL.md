# PFAS Raw Source Collection Protocol
## 원천 데이터 수집 프로토콜 v0.1

기준 날짜:
2026-03-19

이 문서는 “인터넷에서 방대하게 수집한다”를 실제 작업 규칙으로 바꾼다.

핵심은 양이 아니라 추적 가능성이다.

1. raw는 반드시 URL과 수집 시각이 있어야 한다.
2. 공식 source를 truth layer로 우선 수집한다.
3. certification은 claim-level로 수집한다.
4. vendor 데이터는 가격/교체주기/설치 정보로만 수집한다.
5. raw를 normalize하기 전에 원문과 메타데이터를 보존한다.

---

# 1. raw capture 필수 메타데이터

모든 raw capture는 아래를 가진다.

- `raw_source_id`
- `retrieved_at`
- `url`
- `organization`
- `title`
- `content_type`
- `jurisdiction`
- `source_family`
- `checksum_or_snapshot_id`
- `notes`

`url`이 없으면 raw source로 인정하지 않는다.

---

# 2. source family

## federal_official

용도:

- benchmark context
- UCMR occurrence
- CCR 제도 해석
- private well 기본 가이드
- PFAS filter certification interpretation

## state_official

용도:

- private well next action
- state-certified lab lookup
- state guidance / advisories

## utility_official

용도:

- CCR PDF
- PFAS notice
- water quality update

## certification_listing

용도:

- claim-level certification verification
- standard code + reduction claim + listing record

## manufacturer_or_vendor

용도:

- upfront price
- replacement price
- replacement cadence
- capacity
- installation notes

---

# 3. 수집 우선순위

## Tier A. 먼저 확보할 것

1. EPA UCMR 5 and occurrence data
2. EPA PFAS NPDWR implementation pages
3. EPA CCR consumer guidance
4. EPA private well and PFAS private well guidance
5. EPA filter certification guidance
6. ATSDR PFAS blood testing / clinician pages
7. certification listing directories

## Tier B. 그 다음 확보할 것

1. state private well PFAS guidance
2. state-certified lab lookup
3. selected utility CCRs and PFAS notices
4. manufacturer product pages and pricing

---

# 4. 초기 federal source registry seed

아래는 Sharp v1 시작 시 반드시 source registry에 들어가야 하는 기본 URL이다.

## EPA

- PFAS NPDWR Implementation
  - https://www.epa.gov/dwreginfo/pfas-rule-implementation
  - 용도: 현재 규제 상태, implementation 자료, date-sensitive benchmark context
- EPA news release on PFOA/PFOS and reconsideration
  - https://www.epa.gov/newsreleases/epa-announces-it-will-keep-maximum-contaminant-levels-pfoa-pfos
  - 용도: 2025-05-14 이후 규제 상태 주석
- UCMR 5 main page
  - https://www.epa.gov/dwucmr/fifth-unregulated-contaminant-monitoring-rule
  - 용도: UCMR 5 해석 규칙, compliance caution
- UCMR occurrence data
  - https://www.epa.gov/dwucmr/occurrence-data-unregulated-contaminant-monitoring-rule
  - 용도: 전국 발생 데이터, screening context
- CCR information for consumers
  - https://www.epa.gov/ccr/ccr-information-consumers
  - 용도: CCR meaning, annual timing, expected contents
- Private drinking water wells
  - https://www.epa.gov/privatewells
  - 용도: private well ownership/responsibility, state program links
- PFAS in private wells
  - https://www.epa.gov/cleanups/pfas-private-wells
  - 용도: test first, state-certified lab, alternate water, certified filter
- Identifying drinking water filters certified to reduce PFAS
  - https://www.epa.gov/water-research/identifying-drinking-water-filters-certified-reduce-pfas
  - 용도: POU filter types, cost ranges, certification interpretation
- Water filter fact sheet PDF
  - https://www.epa.gov/system/files/documents/2024-04/water-filter-fact-sheet.pdf
  - 용도: consumer-facing filter guidance backup

## ATSDR / CDC

- Testing for PFAS
  - https://www.atsdr.cdc.gov/pfas/blood-testing/index.html
  - 용도: blood testing limitations, out-of-scope guardrail
- PFAS Information for Clinicians – 2024
  - https://www.atsdr.cdc.gov/pfas/hcp/clinical-overview/index.html
  - 용도: clinician-facing limits on blood testing interpretation

---

# 5. certification source registry seed

PFAS certification은 표준 코드만이 아니라 claim-level 추출이 필요하다.

초기 대상:

- NSF listings
  - https://info.nsf.org/Certified/DWTU/
- WQA Gold Seal
  - https://find.wqa.org/find-products
- UL Product iQ
  - https://productiq.ulprospector.com/
- IAPMO product listings
  - https://pld.iapmo.org/
- CSA Group product listing
  - https://www.csagroup.org/testing-certification/product-listing/

주의:

- EPA는 자사 PFAS filter guidance에서 NSF, CSA Group, IAPMO, UL, WQA listing을 함께 제시한다.
- 따라서 source policy상 cert body는 NSF 하나로 고정하지 않는다.
- 그러나 claim extraction의 난이도와 coverage를 고려해 Sharp v1 초기 구현은 NSF를 우선하고, 다른 bodies는 schema-compatible하게 수집한다.

---

# 6. state collection protocol

각 state는 최소 아래 3개를 찾는다.

1. PFAS private well guidance page
2. state-certified lab lookup
3. drinking water/PFAS advisory or response page

required capture:

- state agency name
- state code
- page title
- URL
- last updated if shown
- sampling/testing recommendation
- lab lookup URL
- PFAS-specific note

state source가 없으면 state page를 발행하지 않는다.

---

# 7. utility collection protocol

utility page는 최소 아래 3종을 찾는다.

1. official utility website
2. CCR PDF or official annual water quality report
3. PFAS notice/update if present

required capture:

- `pwsid`
- utility name
- service area note
- official utility URL
- CCR URL
- PFAS notice URL
- report year
- retrieved_at

금지:

- third-party summaries를 utility truth로 채택
- ZIP만으로 utility mapping 확정

---

# 8. certification extraction protocol

각 listing record에서 최소 아래를 뽑는다.

- `cert_body`
- `listing_record_id` or canonical listing URL
- `brand`
- `model`
- `standard_code`
- `reduction_claim`
- `claim_scope_note`
- `last_verified_date`

중요:

- `NSF 53` 또는 `NSF 58`만으로 PFAS suitability를 단정하지 않는다.
- listing에 `PFOA Reduction`, `PFOS Reduction`, `Total PFAS Reduction` 같은 claim이 실제로 있어야 한다.

---

# 9. commercial data protocol

manufacturer/vendor data는 아래에만 쓴다.

- price
- replacement cadence
- capacity
- installation constraints

required capture:

- product URL
- observed price
- observed date
- replacement part URL if separate
- cadence basis: `months | gallons | mixed`

금지:

- vendor claim만으로 efficacy truth 구성
- commercial copy를 next action 근거로 사용

---

# 10. update cadence

## high-volatility

- price
- product availability
- listing status

권장:

- 30~90일

## medium-volatility

- utility notices
- state guidance

권장:

- 90~180일

## low-volatility but must verify

- EPA framework pages
- ATSDR guidance

권장:

- 분기별 확인

---

# 11. manual review triggers

- source page has materially changed
- regulation status changed
- certification listing disappeared
- product claim and listing conflict
- utility doc year mismatch
- state page missing lab lookup

---

# 12. 관련 문서

- `DATA_MODEL_ANCHOR.md`
- `FILE_PIPELINE_SPEC.md`
- `CALCULATION_POLICY_V1.md`
- `SOURCE_EVIDENCE_POLICY.md`
- `TRUST_CLAIMS_POLICY.md`
