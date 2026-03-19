# PFAS Project Anchor
## 실행 기준 문서 v0.1

이 문서는 [pfas_agent_bible_v1.md](/c:/Development/Owner/pfas/pfas_agent_bible_v1.md)와 [pfas_master_prompt_short.md](/c:/Development/Owner/pfas/pfas_master_prompt_short.md)를 바탕으로, 앞으로 이 저장소에서 실제 작업을 밀어붙일 때 흔들리지 않게 만드는 `실행 앵커`다.

목적은 두 가지다.

1. 사람이든 에이전트든 같은 문제 정의 위에서 움직이게 한다.
2. 지금 코드베이스에서 어떤 기술과 산출물을 우선해야 하는지 고정한다.

이 문서가 기존 바이블과 다른 점은 `요약`이 아니라 `결정`을 담는다는 것이다.

---

# 1. 한 줄 정의

이 프로젝트는 PFAS 정보 사이트가 아니다.

이 프로젝트는 `공식 데이터 + 인증 기준 + 비용 현실성`을 바탕으로 사용자가 자기 집 물 상황에서 `지금 무엇을 해야 하는지`를 정하게 돕는 `물 의사결정 엔진`이다.

성공 기준은 지식량이 아니라 아래 4개다.

1. 다음 행동이 선명한가
2. 데이터의 한계를 정직하게 드러내는가
3. 과잉지출을 막는가
4. 신뢰를 해치지 않고 전환까지 연결되는가

---

# 2. 천재 페르소나 토론

이 섹션은 앞으로 의사결정이 흔들릴 때 되돌아볼 기준점이다.

## Persona A. 전략가

주장:

- PFAS 시장의 대부분은 공포, 정보 비대칭, 고가 필터 푸시에 기대고 있다.
- 따라서 승부처는 “더 많은 PFAS 정보”가 아니라 “더 나은 결정 구조”다.
- 이 프로젝트는 콘텐츠보다 `decision engine`이 먼저여야 한다.

## Persona B. 회의론자

반론:

- 사용자는 결국 “안전한지 위험한지”를 알고 싶어 한다.
- 그런데 그걸 확정하지 못하면 너무 애매한 사이트로 보일 수 있다.
- 너무 보수적으로 쓰면 도움이 안 되는 척만 하는 사이트가 된다.

## Persona C. 제품 설계자

해결:

- `확정 판정`이 아니라 `행동 가능한 결론`을 줘야 한다.
- 즉 “safe/unsafe”는 금지하지만, “지금은 utility report부터 확인”, “private well이면 test first”, “certified point-of-use면 likely fit”, “whole-house는 아직 과함”은 선명하게 말해야 한다.
- 모호함은 숨길 게 아니라 제품 로직으로 승격한다.

## Persona D. 수익화 담당

유혹:

- whole-house, 고가 RO, 대량 ZIP 페이지, best filter 리스트가 돈 벌기 쉬워 보인다.

반박:

- 그 방식은 단기 수익은 만들 수 있어도 이 프로젝트의 핵심 차별점을 파괴한다.
- 이 프로젝트의 브랜드는 “덜 사게 만들어도 신뢰되는 사이트”여야 한다.
- 수익화는 `판단 이후`에만 붙는다.

## 토론 결론

이 프로젝트의 본질은 다음 문장으로 고정한다.

> 우리는 PFAS 위험 판정기가 아니라, 불확실한 물 정보를 다음 행동으로 바꾸는 엔진을 만든다.

---

# 3. 절대 고정 원칙

## 3.1 절대 하지 말 것

- 개인 가정의 물을 단정적으로 `안전` 또는 `위험`으로 판정하지 않는다.
- ZIP 코드 하나로 서비스 구역, 노출 수준, 건강 위험을 확정하지 않는다.
- 건강 증상이나 질환을 PFAS와 직접 연결하지 않는다.
- 데이터가 부족한데도 definitive answer를 만들지 않는다.
- uncertified 제품을 추천하지 않는다.
- whole-house를 기본값처럼 밀지 않는다.

## 3.2 반드시 해야 할 것

- public water와 private well을 초기에 분기한다.
- 결과는 항상 `다음 행동` 중심으로 말한다.
- unknown / insufficient data를 정식 결과 상태로 취급한다.
- 추천보다 먼저 인증, 유지관리, 연간비용을 보여준다.
- 사용자가 “이유”를 이해하도록 reasoning을 남긴다.

---

# 4. 이 프로젝트의 진짜 문제 정의

사용자는 PFAS를 공부하고 싶은 게 아니다.

사용자는 아래 중 하나에 답을 원한다.

1. 우리 집은 공공수도인데 어디서 확인해야 하지?
2. private well인데 테스트부터 해야 하나?
3. 숫자가 있는데 이걸 어떻게 행동으로 바꾸지?
4. 필터를 산다면 어디까지가 적정지출이지?

즉 핵심 산출물은 정보가 아니라 아래 구조다.

`입력 -> 상황 분류 -> 다음 행동 -> 이유 -> 아직 모르는 것 -> 비용 -> 인증 -> 선택지 -> escalation`

---

# 5. 사용자 상태 모델

이 프로젝트는 사용자를 아래 4개 주요 상태로 본다.

## State A. 공공수도 + 데이터 모름

핵심 질문:
`우리 utility 보고서부터 봐야 하나?`

기본 결론:
`Check utility report first`

필요 요소:

- CCR / utility report 찾는 법
- PFAS notice 확인 경로
- 데이터가 없을 때 다음 분기

## State B. private well

핵심 질문:
`나는 규제 밖인데 테스트부터 해야 하나?`

기본 결론:
`Test first`

필요 요소:

- state guidance
- state-certified lab 연결
- 결과 후 다음 단계

## State C. 수치가 이미 있음

핵심 질문:
`이 숫자면 지금 뭘 해야 하지?`

기본 결론:

- interpretation to action
- data limits
- certification-first treatment fit

## State D. 필터를 사고 싶음

핵심 질문:
`어디까지 가야 하고, 얼마가 들고, 얼마나 귀찮지?`

기본 결론:

- filter type fit
- initial cost
- annual cost
- replacement burden
- justified escalation 여부

---

# 6. 모든 결과의 기본 출력 형식

모든 페이지, 계산기, 결과 카드, 리서치 요약은 가능한 한 아래 형식을 유지한다.

1. `NEXT ACTION`
2. `WHY THIS`
3. `WHAT THIS DOES NOT TELL YOU`
4. `INITIAL COST`
5. `ANNUAL COST / MAINTENANCE`
6. `CERTIFICATION CHECKLIST`
7. `BEST-FIT OPTIONS`
8. `WHEN TO ESCALATE`

이 형식은 단순 카피 규칙이 아니라 제품의 정체성이다.

---

# 7. MVP에서 먼저 만들 것

현재 저장소는 거의 빈 Spring MVC 앱이다. 따라서 초기에 필요한 것은 “많은 페이지”가 아니라 “판단 엔진의 뼈대”다.

## Phase 1. Decision Core

- 물 공급 방식 분기: public water vs private well
- 데이터 상태 분기: no data vs utility data vs test result vs shopping intent
- next action 문구 시스템
- unknown / insufficient state 처리

## Phase 2. Trust Layer

- methodology
- disclaimer and scope
- certification checklist
- cost and maintenance framework

## Phase 3. Entry Pages

- public water vs private well
- test first vs filter first
- how to read your CCR
- NSF 53 vs 58 for PFAS
- under-sink vs whole-house
- PFAS filter annual cost

## Phase 4. Coverage Expansion

- utility helper pages
- state private well guidance pages

초기엔 coverage보다 core logic가 먼저다.

---

# 8. 기술 앵커

## 현재 코드베이스 해석

현재 저장소는 다음 상태다.

- Spring Boot MVC 앱
- Java 17
- 서버 렌더링 스택 미정
- 프론트엔드 프레임워크 없음
- 제품 로직도 아직 없음

즉 지금 필요한 것은 React 같은 큰 프론트엔드가 아니라, `서버 렌더링 + 빠른 반복 + 명확한 뷰 계층`이다.

## 추천 결론

`Spring Boot MVC + jte + HTMX + 최소한의 Alpine.js(필요할 때만)`를 기본안으로 추천한다.

## 왜 Thymeleaf보다 jte인가

이 프로젝트는 마케팅 랜딩페이지가 아니라 `결정 흐름이 있는 SSR 앱`에 가깝다. 그런 관점에서 jte가 더 맞다.

### jte를 추천하는 이유

- greenfield다. 기존 Thymeleaf 자산이 없다.
- 템플릿이 컴파일되어 뷰 오류를 더 빨리 잡기 쉽다.
- 문법이 비교적 단순하고, 거대한 dialect 학습 없이 컴포넌트화하기 좋다.
- 결과 카드, 체크리스트, 분기 UI 같은 재사용 조각을 만들기 편하다.
- 공식 문서 기준으로 Spring Boot 4용 starter가 있다.

### Thymeleaf가 더 나은 경우

- 팀이 이미 Thymeleaf에 매우 익숙하다.
- Spring form binding, validation error 출력, message source 통합을 템플릿에서 강하게 활용할 계획이다.
- 디자이너가 HTML 프로토타입 기반으로 직접 만질 가능성이 크다.

### 이 프로젝트에선 Thymeleaf가 덜 맞는 이유

- 현재는 복잡한 백오피스 form 앱이 아니다.
- 지금 필요한 건 Spring form 태그 풍부함보다 `단단한 화면 조립`이다.
- Thymeleaf는 강력하지만, greenfield에서 오히려 템플릿 규칙과 속성 문법이 무거워질 수 있다.

## 왜 React/Next가 아닌가

- 먼저 풀어야 할 문제는 클라이언트 상태 관리가 아니라 decision logic이다.
- 지금 단계에서 SPA를 넣으면 복잡도만 앞선다.
- 검색 유입과 신뢰 확보를 생각하면 초기엔 SSR이 더 자연스럽다.

## 왜 HTMX를 같이 두는가

- Action Checker를 작은 단계별 폼으로 만들기 좋다.
- 전체 SPA 없이도 부분 렌더링이 된다.
- 결과 카드, 비교표, 다음 분기 추천을 progressive enhancement 방식으로 붙일 수 있다.

## 기술 스택 최종 제안

- Backend: Spring Boot Web MVC
- Template Engine: jte
- Interactivity: HTMX
- Optional micro-interaction: Alpine.js
- Styling: Tailwind CSS v4 + custom design tokens + a thin global CSS layer

---

# 9. 템플릿 엔진 선택 결론

현 시점 기본 선택은 `jte`다.

다만 아래 조건이면 Thymeleaf로 바꿔도 된다.

1. 팀의 주 개발자가 Thymeleaf에 훨씬 익숙하다.
2. 화면보다 form-heavy 업무 흐름이 핵심이 된다.
3. jte보다 Spring form integration이 실제로 더 중요한 요구사항으로 확인된다.

그 전까지는 jte를 기본값으로 고정한다.

실무 판단 문장:

> 이 저장소의 1차 목표는 복잡한 폼 엔진이 아니라, 신뢰 가능한 분기 화면을 빠르게 쌓는 것이다. 그래서 Thymeleaf보다 jte가 더 맞다.

---

# 10. 정보 구조 앵커

초기 정보 구조는 아래처럼 고정한다.

## Engine Layer

- PFAS Action Checker
- Filter Cost Calculator

## Decision Layer

- Public water vs private well
- Test first vs filter first
- How to read a utility report / CCR
- When a certified point-of-use filter is enough
- When under-sink RO becomes reasonable
- When whole-house is justified

## System Layer

- NSF 53 vs 58
- What PFAS reduction claims actually mean
- Initial cost vs annual cost
- Filter replacement and maintenance burden
- Methodology / disclaimer / source policy

## Coverage Layer

- utility helper pages
- state-specific private well guidance pages

Coverage layer는 진실 엔진이 아니라 discovery layer다.

---

# 11. 이 저장소에서 앞으로 내가 작업할 때의 기준

앞으로 이 저장소에서 어떤 작업을 하든 아래 순서를 따른다.

1. 이 작업이 `다음 행동 결정`을 더 선명하게 하는지 본다.
2. 이 작업이 `과잉지출 방지`에 기여하는지 본다.
3. 이 작업이 `불확실성을 정직하게 보여주는지` 본다.
4. 이 작업이 `인증 / 유지관리 / 비용`을 빠뜨리지 않는지 본다.
5. 이 작업이 `광고 냄새`를 키우는지 줄이는지 본다.

작업 우선순위도 아래로 고정한다.

1. decision-state taxonomy
2. disclaimer and truth system
3. result card schema
4. certification and cost model
5. core pages
6. calculators
7. coverage pages
8. monetization

---

# 12. 문서 vs 프롬프트 vs 코드

이 프로젝트는 `문서만 있으면 충분한 영역`과 `문서만으로는 부족한 영역`이 분명하다.

## 12.1 문서만으로 충분한 영역

- 포지셔닝
- 금지선
- 톤 앤 매너
- 정보 구조
- 디자인 시스템 방향
- 우선순위

위 항목은 문서 앵커만으로도 충분히 고정 가능하다.

## 12.2 문서만으로 부족한 영역

- decision-state logic
- next action 분기
- escalation rule
- certification requirement mapping
- output schema
- source evidence handling

이 영역은 문서만으로 유지하면 나중에 해석이 흔들릴 수 있다.
즉 초기에는 prose 문서로 시작할 수 있지만, 구현에 들어가면 반드시 아래로 내려와야 한다.

1. decision table
2. typed domain model
3. deterministic service logic
4. tests

## 12.3 앵커 계층

이 저장소의 기준 계층은 아래처럼 고정한다.

1. `pfas_agent_bible_v1.md`
   - 철학과 범위를 정의하는 장문 원전
2. `PROJECT_ANCHOR.md`
   - 실제 구현 결정을 고정하는 실행 기준
3. `DESIGN_SYSTEM_ANCHOR.md`
   - 시각 언어와 UX 기준
4. `SEARCH_EXECUTION_ANCHOR.md`
   - 검색/성장/리스크 균형 기준
5. structured execution specs
   - `DATA_MODEL_ANCHOR.md`
   - `FILE_PIPELINE_SPEC.md`
   - `CALCULATION_POLICY_V1.md`
   - `RAW_SOURCE_COLLECTION_PROTOCOL.md`
   - `DECISION_TABLE_V1.md`
   - `RESULT_SCHEMA_V1.md`
   - `SOURCE_EVIDENCE_POLICY.md`
   - `TRUST_CLAIMS_POLICY.md`
6. `pfas_master_prompt_short.md`
   - 에이전트에게 주입할 짧은 운영 프롬프트
7. code + tests
   - 최종적으로 drift를 막는 진실 계층

즉 장기적으로는 `문서 -> 프롬프트 -> 코드`가 아니라, `문서 -> 구조화된 규칙 -> 코드 -> 테스트`로 가야 한다.

## 12.4 프롬프트는 필요한가

필요하다. 다만 장문의 바이블 전체를 매번 읽게 하는 방식은 비효율적이다.

권장 방식은 아래다.

- 에이전트 기본 주입: `pfas_master_prompt_short.md`
- 구현/기획 판단 시 추가 참조: `PROJECT_ANCHOR.md`
- 디자인 작업 시 추가 참조: `DESIGN_SYSTEM_ANCHOR.md`
- 검색/확장 판단 시 추가 참조: `SEARCH_EXECUTION_ANCHOR.md`
- 데이터 수집 시 최우선 참조: `RAW_SOURCE_COLLECTION_PROTOCOL.md` + `SOURCE_EVIDENCE_POLICY.md`
- 계산/비교 시 최우선 참조: `CALCULATION_POLICY_V1.md`
- 로직 구현 시 최우선 참조: structured execution specs + tests

즉 프롬프트는 `행동 방향 고정`에 필요하고, 로직 안정성은 결국 `구조화된 명세와 테스트`가 책임진다.

---

# 13. 지금 바로 작업 들어가도 되는가

결론부터 말하면 `구조적으로는 예`다.

다만 바로 필요한 첫 구현물은 화면이 아니라 `source registry seed + raw capture + normalization`이다.

## 13.1 지금 바로 들어가도 되는 작업

- data model anchor
- file pipeline spec
- calculation policy v1
- raw source collection protocol
- decision table v1
- result schema v1
- source and evidence policy v1
- trust and claims policy v1
- file-based backend skeleton
- 이후 jte 기반 UI shell

즉 지금 바로 구현 가능한 것은 `데이터/로직 기반을 잠그는 작업`이며, 그 다음이 제품 표면이다.

## 13.2 바로 들어가면 위험한 작업

- source registry 없이 utility/state/helper page를 대량 발행
- claim granularity 없이 certification suitability를 단정
- usage-dependent cost를 억지 숫자로 환산
- 2025-05-14 이후 규제 변화를 무시한 benchmark 고정
- raw source 없이 normalized fact를 직접 생성

즉 위험한 것은 로직 그 자체보다 `source discipline 없이 scale하거나 단정하는 것`이다.

## 13.3 구현 전 최소 필요 산출물

아래 문서군이 생기면 로직 구현에 들어가도 된다.

1. `DATA_MODEL_ANCHOR.md`
   - 파일 기반 데이터 구조와 엔터티 정의
2. `FILE_PIPELINE_SPEC.md`
   - raw -> normalized -> derived 흐름 정의
3. `CALCULATION_POLICY_V1.md`
   - 농도/비교/비용 계산 규칙 정의
4. `RAW_SOURCE_COLLECTION_PROTOCOL.md`
   - 어떤 원천 데이터를 어떻게 수집할지 정의
5. `DECISION_TABLE_V1.md`
   - 입력 상태별 next action과 escalation 정의
6. `RESULT_SCHEMA_V1.md`
   - NEXT ACTION 이하 결과 카드 필드 구조 정의
7. `SOURCE_EVIDENCE_POLICY.md`
   - 공식 데이터, utility 문서, state guidance, 상업 데이터를 어떻게 쓸지 명시
8. `TRUST_CLAIMS_POLICY.md`
   - YMYL 표현 기준과 발행 체크리스트 정의

따라서 현재 상태는 다음처럼 판단한다.

- 데이터/백엔드 구현: Go
- UI 구현: Go, 단 data contract 위에 올릴 것
- 로직 구현: Go
- selective scale: Not yet

---

# 14. 바로 다음 구현 순서

이 문서를 기준으로 바로 착수한다면 순서는 아래가 맞다.

## Step 1. 데이터 계약 확정

- data model anchor
- file pipeline spec
- calculation policy
- raw source collection protocol
- source registry
- normalized entity schema

## Step 2. 결정 규칙 확정

- decision table v1
- result schema v1
- trust and claims policy
- source and evidence policy

## Step 3. 파일 기반 백엔드 뼈대

- JSON / CSV loader
- validation
- normalization
- benchmark resolver
- cost calculator
- decision service
- generated view model

## Step 4. 뷰 스택 확정

- jte 의존성 추가
- 기본 layout
- result card partial
- typography / spacing / token system

## Step 5. Action Checker v1

입력:

- public water / private well
- utility data available?
- test result available?
- shopping intent?

출력:

- next action
- why this
- what this does not tell you
- likely fit options
- when to escalate

## Step 6. Core content pages

- `/public-water-vs-private-well`
- `/test-first-vs-filter-first`
- `/how-to-read-a-ccr`
- `/nsf-53-vs-58`
- `/under-sink-vs-whole-house`
- `/pfas-filter-annual-cost`

## Step 7. Methodology pages

- source policy
- scope and non-scope
- certification methodology
- affiliate policy

---

# 15. 최종 결론

이 프로젝트는 “PFAS를 설명하는 사이트”로 만들면 약해진다.

이 프로젝트는 “내 상황에서 지금 무엇을 해야 하는지 정하게 해주는 엔진”으로 만들어야 강해진다.

그 관점에서 현재 저장소의 실행 방향은 아래로 고정한다.

- 제품 포지셔닝: action engine
- UX 포지셔닝: clarity before product
- 수익화 포지셔닝: trust before affiliate
- 기술 포지셔닝: Spring MVC SSR
- 템플릿 선택: jte 우선
- 인터랙션 전략: HTMX 보조

이 문서가 앞으로의 `작업 기준 원본`이다.
