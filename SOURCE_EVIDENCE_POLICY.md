# PFAS Source & Evidence Policy
## 원천 데이터와 증거 사용 기준 v0.1

기준 날짜:
2026-03-19

이 문서는 이 프로젝트가 어떤 원천 데이터를 어떤 용도로 쓸 수 있는지, 그리고 어디서부터는 말할 수 없는지 고정한다.

이 문서는 `데이터를 많이 모으는 것`보다 `증거를 올바른 계층에 두는 것`을 우선한다.

---

# 1. 핵심 원칙

1. 공식 연방/주/utility 문서가 truth layer의 중심이다.
2. certification body 자료는 treatment validation layer다.
3. manufacturer/vendor 자료는 purchase layer다.
4. 어떤 데이터도 그 용도를 넘어서 사용하지 않는다.

---

# 2. 신뢰 계층

## Tier 1. Federal official

용도:

- 규정
- 공공 모니터링 데이터
- CCR 제도
- private well 공식 안내
- filter certification 해석 한계

대표 소스:

- EPA PFAS NPDWR Implementation
  - https://www.epa.gov/dwreginfo/pfas-rule-implementation
- EPA UCMR 5
  - https://www.epa.gov/dwucmr/fifth-unregulated-contaminant-monitoring-rule
- EPA UCMR occurrence data
  - https://www.epa.gov/dwucmr/occurrence-data-unregulated-contaminant-monitoring-rule
- EPA CCR consumer info
  - https://www.epa.gov/ccr/ccr-information-consumers
- EPA private wells
  - https://www.epa.gov/privatewells
- EPA PFAS in private wells
  - https://www.epa.gov/cleanups/pfas-private-wells
- EPA certified home filters guidance
  - https://www.epa.gov/water-research/identifying-drinking-water-filters-certified-reduce-pfas

사용 가능:

- benchmark context
- result interpretation limits
- public vs private branch
- reporting cadence
- certification caveats

사용 금지:

- private well legal compliance 판정
- ZIP-only household exposure 판정

## Tier 2. Utility and state official

용도:

- local actionability
- utility-specific CCR
- PFAS customer notices
- state private well guidance
- state-certified lab lookup

사용 가능:

- direct utility next action
- state-specific well testing path
- local caveat

사용 금지:

- utility doc가 없는데 ZIP만으로 utility truth 추정

## Tier 3. Certification bodies

주요 소스:

- EPA PFAS filter guidance
  - https://www.epa.gov/water-research/identifying-drinking-water-filters-certified-reduce-pfas
- NSF PFAS in drinking water
  - https://www.nsf.org/consumer-resources/articles/pfas-drinking-water
- NSF certification listings
  - https://info.nsf.org/Certified/DWTU/
- WQA Gold Seal
  - https://find.wqa.org/find-products
- UL Product iQ
  - https://productiq.ulprospector.com/
- IAPMO R&T listings
  - https://pld.iapmo.org/
- CSA Group listing
  - https://www.csagroup.org/testing-certification/product-listing/
- EPA home filter fact sheet
  - https://www.epa.gov/system/files/documents/2024-04/water-filter-fact-sheet.pdf

사용 가능:

- standard code
- listing record
- reduction claim granularity
- PFAS reduction claim scope
- listing verification
- certification caveats

사용 금지:

- certification = universal sufficiency
- certification = automatic compliance with latest EPA rule

## Tier 4. Manufacturer / vendor

용도:

- price
- replacement cadence
- capacity
- installation detail

사용 가능:

- purchase comparison
- maintenance estimate
- cost range

사용 금지:

- exposure truth
- household risk truth
- best overall claim without independent backing

---

# 3. 중요한 현재 사실

## 3.1 UCMR 5 해석

EPA는 UCMR 5 결과가 NPDWR PFAS에 대해 `compliance/noncompliance`를 뜻하지 않는다고 명시한다.

사용 규칙:

- UCMR-only면 screening signal로만 사용
- direct utility document보다 우선하지 않음

## 3.2 private well 해석

EPA는 private wells를 직접 규제하지 않으며, state-certified lab과 state agency guidance를 안내한다.

사용 규칙:

- private well에는 `test first`
- state context 없이 과감한 filter recommendation 금지

## 3.3 filter certification 해석

EPA는 2024년 4월 기준 current certification standards가 아직 EPA의 새 drinking water standard 수준까지 제거를 보장하지 않는다고 설명한다.

사용 규칙:

- certification은 최소 기준
- certification = enough 라고 쓰지 않음
- standard code만으로 claim을 추정하지 않음
- listing에 실제 reduction claim이 있어야 PFAS suitability를 말할 수 있음

## 3.4 PFAS blood test 해석

ATSDR는 PFAS blood test가 현재/미래 건강 문제를 식별하거나 치료 정보를 제공하지 않는다고 설명한다.

사용 규칙:

- health diagnosis 흐름으로 확장 금지
- out-of-scope guardrail로만 사용

## 3.5 규제 상태의 시간 민감성

EPA implementation 페이지는 2025-05-14 발표를 기준으로 PFOA/PFOS는 유지 의도를, PFHxS/PFNA/HFPO-DA 및 HI mixture는 재검토 의도를 안내한다.

사용 규칙:

- benchmark source에는 `verified_at` 필수
- reconsideration 대상 PFAS 관련 페이지는 날짜를 분명히 표시

---

# 4. 원천 데이터 수집 우선순위

## 가장 먼저 수집

1. EPA UCMR occurrence data
2. EPA CCR lookup + selected CCR PDFs
3. EPA private well and filter guidance
4. state well guidance + lab lookups
5. certification listing directories

## 그 다음 수집

1. selected utility PFAS notices
2. manufacturer performance data sheets
3. price observations

---

# 5. domain-expert acceptable data handling 기준

아래를 만족해야 “전문가가 봐도 납득 가능한 수준”으로 본다.

- source url 추적 가능
- update date 명시
- benchmark 출처 명시
- indirect vs direct data 구분
- compliance vs reference exceedance 구분
- commercial vs official data 구분
- not enough direct data 상태를 숨기지 않음

---

# 6. 초기 원천 데이터 수집 대상

## Federal

- UCMR 5 occurrence text files / downloads
- UCMR 5 Data Finder selected extracts
- PFAS NPDWR implementation page
- PFAS 2025-05-14 news release
- CCR search and guide
- PFAS home filter guidance
- private well guidance
- ATSDR blood testing and clinician pages

## State

- private well PFAS guidance page
- state-certified lab lookup
- state PFAS drinking water advisories if applicable

## Utility

- CCR PDF
- PFAS notice / update
- water quality report page

## Certification

- NSF listing pages
- standard guidance pages

## Commercial

- manufacturer product listing
- performance data sheet
- replacement filter pricing
