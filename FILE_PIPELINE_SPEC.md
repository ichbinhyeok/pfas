# PFAS File Pipeline Spec
## raw -> normalized -> derived 파이프라인 v0.1

기준 날짜:
2026-03-19

이 프로젝트는 DB가 아니라 파일 시스템이 데이터 파이프라인이다.

따라서 데이터 품질은 스키마와 절차로 보장해야 한다.

---

# 1. 단계

## Stage 1. raw capture

인터넷에서 수집한 원문을 저장한다.

예:

- EPA PDF
- EPA HTML page metadata
- NSF listing page metadata
- utility CCR PDF
- state guidance page metadata
- manufacturer performance data sheet PDF

raw capture에서 해야 할 것:

- 원문 저장 또는 접근 메타데이터 저장
- retrieved_at 기록
- checksum 또는 revision clue 기록

## Stage 2. normalization

사실을 구조화한다.

해야 할 것:

- contaminant 명칭 정규화
- 단위 통일
- 날짜 정리
- source id 연결
- missing/unknown 처리

## Stage 3. signal derivation

결정 엔진이 쓸 신호를 만든다.

예:

- public vs private
- direct data vs indirect data
- benchmark relation
- certification completeness
- annualized cost

## Stage 4. page model generation

페이지 렌더링용 모델을 만든다.

예:

- action checker result model
- utility helper page model
- state guide page model
- comparison card model

---

# 2. 검증

각 단계마다 검증이 필요하다.

## raw validation

- url 존재
- retrieval date 존재
- source kind 존재

## normalized validation

- required field 존재
- unit consistency
- source_id 연결
- schema_version 존재

## derived validation

- benchmark relation enum 유효
- annual cost 음수 금지
- next action code 미정의 금지

---

# 3. 실패 처리

데이터가 부족하면 억지 계산을 하지 않는다.

- no silent fallback
- no implicit zero
- no invented benchmark

실패 상태는 명시적으로 만든다.

- `insufficient_source_data`
- `needs_manual_review`
- `usage_dependent_cost`
- `benchmark_not_comparable`

---

# 4. 운영 규칙

- raw는 append-only에 가깝게 관리
- normalized는 schema change 시 version 상승
- derived는 언제든 재생성 가능해야 함
- hand-edited page copy는 derived truth를 덮어쓰지 못함

