# PFAS Data Model Anchor
## 파일 기반 데이터 모델 기준 v0.1

이 문서는 DB 없이 `JSON + CSV`만으로 Sharp v1를 운영하기 위한 데이터 모델 기준이다.

기준 날짜:
2026-03-19

핵심 원칙은 아래다.

1. raw data는 절대 손으로 “정리된 사실”처럼 덮어쓰지 않는다.
2. 모든 정규화 데이터는 원천 source id를 추적할 수 있어야 한다.
3. decision logic은 raw data가 아니라 normalized signal만 읽는다.
4. 페이지는 data-backed여야 하며, source-backed가 아니면 발행하지 않는다.

---

# 1. 디렉터리 구조

```text
data/
  raw/
    epa/
    nsf/
    states/
    utilities/
    vendors/
  normalized/
    source_registry/
    public_water_systems/
    utility_observations/
    state_guidance/
    certification_claims/
    filter_products/
    cost_models/
  derived/
    decision_inputs/
    page_models/
    search_indexes/
```

## raw

원문 보관 계층이다.

- PDF
- HTML snapshot metadata
- CSV / TXT / XLSX
- parsed extract notes

## normalized

앱이 읽는 신뢰 가능한 구조화 계층이다.

- snake_case field name 사용
- 단위 명시
- source_id 배열 포함
- schema_version 필수

## derived

계산과 렌더링을 위한 파생 계층이다.

- benchmark resolution
- annualized cost
- next action input package
- page rendering models

---

# 2. 핵심 엔터티

## 2.1 source_document

모든 데이터의 출발점이다.

권장 형식:
`normalized/source_registry/source_documents.json`

필수 필드:

- `source_id`
- `organization`
- `title`
- `url`
- `source_kind`
- `trust_tier`
- `jurisdiction`
- `published_date`
- `last_updated_date`
- `retrieved_at`
- `effective_date`
- `allowed_uses`
- `disallowed_uses`
- `notes`

## 2.2 public_water_system

권장 형식:
`normalized/public_water_systems/public_water_systems.csv`

필수 필드:

- `pwsid`
- `pws_name`
- `state_code`
- `system_type`
- `population_served`
- `source_water_type`
- `utility_website_url`
- `ccr_url`
- `pfas_notice_url`
- `service_area_notes`
- `last_verified_date`
- `source_ids`

## 2.3 utility_observation

공공수도 결과나 notice의 정규화 계층이다.

권장 형식:
`normalized/utility_observations/utility_observations.csv`

필수 필드:

- `observation_id`
- `pwsid`
- `contaminant_code`
- `contaminant_label`
- `sample_context`
- `period_start`
- `period_end`
- `sample_date`
- `value`
- `unit`
- `result_flag`
- `minimum_reporting_level`
- `benchmark_type`
- `benchmark_value`
- `benchmark_unit`
- `benchmark_source_id`
- `source_ids`

## 2.4 state_guidance

private well 경로의 핵심이다.

권장 형식:
`normalized/state_guidance/{state_code}.json`

필수 필드:

- `state_code`
- `agency_name`
- `agency_url`
- `private_well_guidance_url`
- `pfas_guidance_url`
- `certified_lab_lookup_url`
- `sampling_guidance_url`
- `repeat_testing_guidance`
- `benchmark_notes`
- `last_verified_date`
- `source_ids`

## 2.5 certification_claim

권장 형식:
`normalized/certification_claims/certification_claims.csv`

필수 필드:

- `cert_body`
- `standard_code`
- `listing_record_id`
- `reduction_claim`
- `claim_name`
- `claim_scope`
- `claim_basis_note`
- `covered_pfas`
- `claim_limit_ppt`
- `listing_directory_url`
- `effective_date`
- `last_verified_date`
- `source_ids`

## 2.6 filter_product

권장 형식:
`normalized/filter_products/filter_products.csv`

필수 필드:

- `product_id`
- `brand`
- `model`
- `filter_type`
- `installation_type`
- `cert_body`
- `standard_code`
- `listing_record_id`
- `claim_scope`
- `covered_pfas`
- `listing_url`
- `replacement_cadence_months`
- `replacement_capacity_gallons`
- `last_verified_date`
- `source_ids`

## 2.7 cost_model

권장 형식:
`normalized/cost_models/filter_costs.csv`

필수 필드:

- `product_id`
- `upfront_cost_usd`
- `replacement_cost_usd`
- `membrane_cost_usd`
- `service_cost_usd`
- `replacement_cadence_months`
- `price_observed_at`
- `price_source_url`
- `cost_confidence`
- `source_ids`

---

# 3. 데이터 단위 규칙

## 농도

- 저장 단위 기본값: `ng/L`
- raw source가 `µg/L`면 ingest 단계에서 `ng/L`로 변환
- 원문 단위는 별도 필드에 보존

## 비용

- 저장 단위: `USD`
- 세금/설치비 포함 여부 별도 필드로 표시

## 날짜

- ISO 8601
- 범위 데이터는 `period_start`, `period_end`

## 불확실성

값이 없거나 불완전하면 빈칸을 0으로 두지 않는다.

- `unknown`
- `not_applicable`
- `not_disclosed`
- `not_comparable`

를 명시적으로 사용한다.

---

# 4. 도메인 신호 계층

raw fact를 그대로 decision engine에 넣지 않는다.

중간 신호를 만든다.

예:

- `water_source_type`
- `official_data_status`
- `has_direct_utility_document`
- `has_private_well_test`
- `benchmark_relation`
- `shopping_intent`
- `current_filter_status`
- `escalation_candidate`

이 신호들은 `derived/decision_inputs/`에 생성한다.

---

# 5. Sharp v1 계산 원칙

세부 계산 규칙은 `CALCULATION_POLICY_V1.md`를 따른다.

## annualized filter cost

기본 계산식:

`annual_cost = sum(replacement_component_cost * annual_replacement_frequency) + annual_service_cost`

여기서:

- `annual_replacement_frequency = 12 / replacement_cadence_months`
- cadence가 gallons 기준만 있으면 별도 추정 로직을 쓰지 않고 `usage-dependent`로 표기

## cost confidence

- `high`: 공식 listing 또는 최근 manufacturer docs + 최근 가격 확인
- `medium`: manufacturer docs는 있으나 가격이 1개 소스
- `low`: reseller나 marketplace only

## maintenance burden

정량보다 단계형으로 간다.

- `low`
- `medium`
- `high`

판정 기준:

- 교체 빈도
- 부품 수
- 설치 난이도
- 누수/배수/서비스 필요 여부

---

# 6. 절대 규칙

- source_id 없는 normalized record는 금지
- `ZIP`은 보조 인덱스일 뿐 진실 키로 쓰지 않음
- UCMR-only data로 compliance 판정 금지
- vendor price만으로 truth layer 구성 금지
- private well은 state context 없이 결과 해석 금지

---

# 7. 바로 다음 파일

이 문서와 짝을 이루는 것은 아래다.

1. `FILE_PIPELINE_SPEC.md`
2. `CALCULATION_POLICY_V1.md`
3. `RAW_SOURCE_COLLECTION_PROTOCOL.md`
4. `DECISION_TABLE_V1.md`
5. `RESULT_SCHEMA_V1.md`
6. `SOURCE_EVIDENCE_POLICY.md`
