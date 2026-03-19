# PFAS Result Schema v1
## 결과 카드와 API 뷰모델 계약

기준 날짜:
2026-03-19

이 문서는 Action Checker, core pages, helper pages가 공유하는 결과 구조를 정의한다.

---

# 1. 최상위 구조

```json
{
  "result_id": "string",
  "schema_version": "v1",
  "generated_at": "datetime",
  "next_action": {},
  "why_this": [],
  "what_this_does_not_tell_you": [],
  "initial_cost": {},
  "annual_cost_maintenance": {},
  "certification_checklist": [],
  "best_fit_options": [],
  "when_to_escalate": [],
  "sources": [],
  "meta": {}
}
```

---

# 2. 필드 정의

## next_action

필수.

```json
{
  "code": "CHECK_UTILITY_REPORT_FIRST",
  "title": "Check your utility report first",
  "summary": "한 문장 next action",
  "confidence": "high|medium|low",
  "scope_note": "optional"
}
```

## why_this

필수.

입력 신호를 사람이 이해할 수 있게 바꾼 리스트.

예:

- public water라서 utility document가 first-party evidence
- 현재는 direct utility document가 없음
- UCMR-only data는 compliance 판단 근거가 아님

## what_this_does_not_tell_you

필수.

이 프로젝트의 신뢰 핵심이다.

예:

- ZIP만으로 서비스 구역을 확정하지 않음
- UCMR-only 결과는 규정 준수 여부를 뜻하지 않음
- private well reference exceedance는 법적 위반 판정이 아님

## initial_cost

필수.

```json
{
  "range_low_usd": 0,
  "range_high_usd": 250,
  "confidence": "high|medium|low|usage_dependent",
  "notes": []
}
```

## annual_cost_maintenance

필수.

```json
{
  "range_low_usd": 0,
  "range_high_usd": 200,
  "maintenance_burden": "low|medium|high|unknown",
  "cadence_notes": [],
  "notes": []
}
```

## certification_checklist

필수.

각 항목:

```json
{
  "label": "NSF/ANSI 53 or 58",
  "required": true,
  "detail": "PFAS reduction claim 범위를 확인",
  "source_id": "optional"
}
```

## best_fit_options

선택이지만 결과 카드 기준에선 권장.

각 항목:

```json
{
  "option_code": "CERTIFIED_POU_GAC",
  "label": "Certified point-of-use carbon filter",
  "fit_reason": "ingestion-focused risk reduction",
  "not_for_everyone": "replacement burden or limited scope",
  "cost_profile": "low|medium|high",
  "maintenance_burden": "low|medium|high"
}
```

## when_to_escalate

필수.

예:

- official notice received
- direct test above applicable reference
- uncertified filter only
- point-of-use not fit for household objective

## sources

필수.

각 항목:

```json
{
  "source_id": "epa-ucmr5-2026-01",
  "organization": "EPA",
  "title": "Occurrence Data from the UCMR",
  "url": "https://...",
  "trust_tier": 1
}
```

## meta

필수.

```json
{
  "water_source_type": "public_water",
  "benchmark_relation": "unknown",
  "decision_rule_id": "Rule 02",
  "manual_review_required": false
}
```

---

# 3. UI 규칙

- `next_action`은 가장 크게 보인다.
- `why_this`와 `what_this_does_not_tell_you`는 같은 시각 그룹 안에 있어야 한다.
- 비용은 초기/연간/maintenance를 분리한다.
- source link는 실제로 클릭 가능해야 한다.

---

# 4. 금지

- safe/unsafe badge
- vague confidence without explanation
- source-less recommendation
- cost without confidence note

