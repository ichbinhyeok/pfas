# PFAS Decision Table v1
## Sharp v1용 의사결정 규칙 초안

기준 날짜:
2026-03-19

이 문서는 prose 문장을 코드로 내리기 전, 결정 규칙을 표로 잠그기 위한 문서다.

핵심 원칙:

- `water_source_type`를 가장 먼저 본다.
- `direct official data`가 `indirect data`보다 우선한다.
- `shopping intent`는 증거보다 위에 오지 못한다.
- `whole-house`는 기본값이 아니라 escalation이다.

---

# 1. 입력 신호

- `water_source_type`: `public_water | private_well`
- `direct_data_status`: `none | utility_document | private_well_test | official_notice`
- `indirect_data_status`: `none | ucmr_only | pfas_analytic_tool_only | zip_hint_only`
- `benchmark_relation`: `unknown | below_reference | above_reference | mixed | not_comparable`
- `shopping_intent`: `none | filter_now | compare_options`
- `current_filter_status`: `none | certified | uncertified | unknown`
- `whole_house_intent`: `none | considering`

---

# 2. 우선순위

1. `water_source_type`
2. `direct_data_status`
3. `official_notice`
4. `benchmark_relation`
5. `shopping_intent`
6. `current_filter_status`
7. `whole_house_intent`
8. `indirect_data_status`

---

# 3. 규칙표

## Rule 01

조건:

- public_water
- direct_data_status = none
- indirect_data_status in `none | zip_hint_only | pfas_analytic_tool_only`

출력:

- `next_action_code = CHECK_UTILITY_REPORT_FIRST`
- `escalation_level = none`
- `allowed_option_class = none`

## Rule 02

조건:

- public_water
- direct_data_status = none
- indirect_data_status = ucmr_only

출력:

- `next_action_code = VERIFY_WITH_UTILITY_AND_CCR`
- `escalation_level = none`
- note: UCMR-only는 compliance 판단에 쓰지 않음

## Rule 03

조건:

- public_water
- direct_data_status = utility_document
- benchmark_relation = unknown

출력:

- `next_action_code = INTERPRET_UTILITY_DOCUMENT`
- `escalation_level = none`

## Rule 04

조건:

- public_water
- direct_data_status in `utility_document | official_notice`
- benchmark_relation = above_reference

출력:

- `next_action_code = EVALUATE_CERTIFIED_POINT_OF_USE_FILTER`
- `escalation_level = medium`
- `allowed_option_class = certified_pou`

## Rule 05

조건:

- public_water
- direct_data_status = utility_document
- benchmark_relation = below_reference
- shopping_intent = none

출력:

- `next_action_code = REVIEW_REPORT_DATE_AND_MONITOR`
- `escalation_level = none`
- note: safe/unsafe 표현 금지

## Rule 06

조건:

- public_water
- direct_data_status = utility_document
- benchmark_relation = below_reference
- shopping_intent in `filter_now | compare_options`

출력:

- `next_action_code = OPTIONAL_CERTIFIED_POU_COMPARISON`
- `escalation_level = none`
- `allowed_option_class = certified_pou_optional`

## Rule 07

조건:

- private_well
- direct_data_status = none

출력:

- `next_action_code = TEST_PRIVATE_WELL_FIRST`
- `escalation_level = none`
- `allowed_option_class = none`

## Rule 08

조건:

- private_well
- direct_data_status = private_well_test
- benchmark_relation = unknown

출력:

- `next_action_code = GET_STATE_GUIDANCE_AND_LAB_CONTEXT`
- `escalation_level = none`

## Rule 09

조건:

- private_well
- direct_data_status = private_well_test
- benchmark_relation = above_reference

출력:

- `next_action_code = EVALUATE_CERTIFIED_POU_FILTER_AND_STATE_NEXT_STEPS`
- `escalation_level = medium`
- `allowed_option_class = certified_pou`

## Rule 10

조건:

- private_well
- direct_data_status = private_well_test
- benchmark_relation = below_reference

출력:

- `next_action_code = CONTINUE_PERIODIC_TESTING`
- `escalation_level = none`

## Rule 11

조건:

- any water source
- shopping_intent in `filter_now | compare_options`
- direct_data_status = none

출력:

- public water면 `CHECK_UTILITY_REPORT_FIRST`
- private well이면 `TEST_PRIVATE_WELL_FIRST`

## Rule 12

조건:

- any water source
- current_filter_status = uncertified

출력:

- `next_action_code = VERIFY_OR_REPLACE_WITH_CERTIFIED_OPTION`
- `escalation_level = low`

## Rule 13

조건:

- any water source
- whole_house_intent = considering
- benchmark_relation in `unknown | below_reference`

출력:

- `next_action_code = DO_NOT_DEFAULT_TO_WHOLE_HOUSE`
- `escalation_level = low`

## Rule 14

조건:

- any water source
- whole_house_intent = considering
- benchmark_relation = above_reference

출력:

- `next_action_code = REVIEW_WHOLE_HOUSE_AS_JUSTIFIED_ESCALATION`
- `escalation_level = high`
- note: 기본 추천이 아니라 목적/비용/maintenance 검토 후

---

# 4. benchmark relation 해석 규칙

## public water

- utility notice나 direct utility reporting이 최우선
- UCMR-only는 `screening context`
- UCMR-only로 compliance/noncompliance 판정 금지

## private well

- private well에는 연방 사적 우물 규제 체계가 직접 적용되지 않음
- 따라서 `above_reference`는 `reference-based action signal`이지 `regulatory noncompliance`가 아님
- state guidance가 있으면 state framework를 우선 참고

---

# 5. whole-house 정당화 조건

whole-house는 아래 중 복수 조건이 맞아야 검토한다.

- 사용 목적이 ingestion-only를 넘어섬
- point-of-use만으로는 목적 충족이 어려움
- maintenance burden을 감당 가능
- 초기 비용과 연간비용 투명성 제시 가능
- certified point-of-use 대안과 비교됨

없으면 기본 출력은 항상 `point-of-use first`다.

