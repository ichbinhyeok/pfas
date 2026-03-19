# PFAS Calculation Policy v1
## 수치 비교와 비용 계산 규칙

기준 날짜:
2026-03-19

이 문서는 PFAS 수치 해석, benchmark 비교, 비용 계산을 prose가 아니라 재현 가능한 규칙으로 고정한다.

핵심 원칙은 아래다.

1. 측정값은 원문을 보존하되 비교는 정규화된 단위로 한다.
2. `compliance`, `reference exceedance`, `screening signal`을 섞지 않는다.
3. 비교 불가 상황은 억지로 계산하지 않고 `not_comparable` 또는 `unknown`으로 남긴다.
4. 비용은 “싸 보이게” 만들지 않고 초기비용, 연간비용, 유지관리 부담을 분리한다.

---

# 1. 농도 정규화

## 저장 단위

- 비교용 기본 단위: `ng/L`
- 원문 단위 필드: `source_unit`
- 변환 후 필드: `normalized_value_ng_l`

## 변환 규칙

- `1 µg/L = 1000 ng/L`
- 원문이 `ppt`로 제공되면, 물 기준 문맥에서 source note를 보존한 뒤 `ng/L`와 동일 축으로 취급할 수 있는지 별도 검토
- 검출한계 미만 표기는 숫자 0으로 바꾸지 않는다

## 검출 관련 표기

아래 필드를 둔다.

- `result_flag`: `detected | not_detected | estimated | censored | unknown`
- `reporting_limit_value`
- `reporting_limit_unit`

`not_detected`는 `0`이 아니다.

---

# 2. benchmark 해석 규칙

## 핵심 분리

다음은 서로 다른 개념이다.

- `compliance_status`
- `benchmark_relation`
- `screening_relation`

하나의 필드로 섞지 않는다.

## benchmark source 필수 메타데이터

모든 비교에는 아래가 필요하다.

- `benchmark_source_id`
- `benchmark_kind`
- `benchmark_value`
- `benchmark_unit`
- `jurisdiction_scope`
- `effective_from`
- `verified_at`

## benchmark_kind

- `federal_mcl`
- `state_mcl`
- `health_advisory`
- `health_reference_level`
- `screening_threshold`
- `state_guidance_level`

---

# 3. public water 비교 규칙

## 3.1 direct utility / compliance data가 있을 때

우선순위:

1. 공식 utility notice
2. compliance monitoring 문서
3. CCR 또는 utility PFAS update
4. UCMR-derived comparison

## 3.2 UCMR-only일 때

UCMR-only 값은 `screening_relation` 또는 `benchmark_relation` 보조값으로만 쓴다.

금지:

- `UCMR above MCL = out of compliance`
- `UCMR below MCL = safe`

EPA는 UCMR 5 결과가 NPDWR PFAS에 대한 compliance/noncompliance를 뜻하지 않는다고 명시한다.

## 3.3 running annual average

`running_annual_average` 또는 유사 필드는 아래가 모두 있을 때만 계산 또는 채택한다.

1. 비교 대상이 compliance monitoring 문맥이다.
2. 같은 sample point 기준 데이터다.
3. 필요한 전체 분기 결과가 있다.
4. source가 해당 집계의 사용 가능성을 뒷받침한다.

위 조건이 없으면 `not_comparable` 또는 `incomplete_for_compliance`로 둔다.

---

# 4. private well 비교 규칙

private well에는 기본적으로 `compliance_status`를 쓰지 않는다.

대신:

- `benchmark_relation`
- `reference_basis`
- `state_context_available`

를 쓴다.

표현 규칙:

- `above_reference`는 `reference-based action signal`
- 법적 위반 판정으로 쓰지 않음

state guidance가 있으면 federal reference보다 state framework를 먼저 보여준다.

---

# 5. benchmark_relation 결정 규칙

## `above_reference`

아래 모두 만족:

1. direct comparable result가 있다.
2. 단위 변환이 가능하다.
3. sample basis가 비교 가능하다.
4. 활성 benchmark보다 높다.

## `below_reference`

아래 모두 만족:

1. direct comparable result가 있다.
2. 비교 가능한 모든 relevant result가 benchmark 이하이다.
3. incomplete_for_compliance 상황이 아니다.

## `mixed`

아래 중 하나:

- 복수 sample point나 복수 기간에서 일부는 초과, 일부는 비초과
- contaminant별 결과가 달라 단일 결론이 불가능

## `unknown`

아래 중 하나:

- direct data 없음
- 필요한 benchmark metadata 없음
- current source로는 비교 불가능 여부조차 확정 안 됨

## `not_comparable`

아래 중 하나:

- unit or sample basis mismatch
- aggregate rule mismatch
- source가 screening용인데 compliance처럼 읽히는 상황

---

# 6. certification claim 계산 규칙

표준 코드만으로 성능을 추정하지 않는다.

필수:

- `cert_body`
- `standard_code`
- `reduction_claim`
- `listing_record_id` 또는 listing URL

예:

- `NSF 53`만 저장하고 PFAS claim을 추정하지 않음
- `NSF 53 + PFOA Reduction + PFOS Reduction`
- `NSF 53 + Total PFAS Reduction`
- `NSF 58 + PFOA Reduction + PFOS Reduction`

claim granularity가 없으면 `certified_for_pfas = unknown`으로 둔다.

---

# 7. 비용 계산 규칙

## 7.1 초기비용

초기비용은 최소 아래 세 축으로 나눈다.

- `device_cost_usd`
- `installation_cost_usd`
- `accessory_startup_cost_usd`

표시값:

- `initial_cost_low_usd`
- `initial_cost_high_usd`

source가 설치비를 제공하지 않으면 설치비는 `unknown` 또는 `optional_not_included`로 둔다.

## 7.2 연간비용

기본 계산식:

`annual_cost = replacement_cost_total + membrane_cost_total + annual_service_cost`

세부 계산:

- `replacement_cost_total = sum(component_cost * annual_replacement_frequency)`
- `annual_replacement_frequency = 12 / replacement_cadence_months`

## 7.3 gallons 기준만 있을 때

제조사가 `months`가 아니라 `gallons`만 제공하면 임의 사용량을 넣어 계산하지 않는다.

이 경우:

- `annual_cost_confidence = usage_dependent`
- `annual_cost_low_usd`, `annual_cost_high_usd`는 비워둘 수 있다
- 필요하면 usage scenario를 별도 문서에서 명시적으로 계산

## 7.4 가격 범위 산정

가격은 아래 규칙으로 range를 만든다.

1. 같은 시점대 verified source가 2개 이상이면 min/max를 사용
2. source가 1개뿐이면 exact-looking number 대신 single-source note를 붙인다
3. marketplace price only면 `low confidence`
4. stale price는 신선한 가격보다 우선하지 않는다

## 7.5 freshness buckets

- `fresh`: 90일 이내 확인
- `aging`: 91~180일
- `stale`: 181일 초과

stale only면 cost comparison 카드에 경고를 붙인다.

---

# 8. maintenance burden 규칙

## `low`

- 6개월 이상 교체 주기
- 부품 수 적음
- 별도 배수/전문 서비스 없음

## `medium`

- 3~6개월 교체 또는 복수 카트리지
- 설치 난이도 보통
- occasional maintenance 필요

## `high`

- 잦은 교체
- membrane + pre/post filters 등 다중 부품
- 배수, 압력, 누수, 서비스 이슈 고려 필요

---

# 9. 수동 검토 강제 조건

아래 중 하나면 자동 결론을 내리지 않고 `manual_review_required = true`로 둔다.

- PFHxS / PFNA / HFPO-DA / PFBS mixture 관련 benchmark 해석
- direct data와 notice 간 충돌
- claim granularity 없는 certification record
- unit conversion ambiguity
- partial quarterly set
- whole-house cost/fit를 point-of-use와 정직하게 비교할 수 없는 경우

---

# 10. 관련 문서

- `DATA_MODEL_ANCHOR.md`
- `FILE_PIPELINE_SPEC.md`
- `RAW_SOURCE_COLLECTION_PROTOCOL.md`
- `DECISION_TABLE_V1.md`
- `SOURCE_EVIDENCE_POLICY.md`
