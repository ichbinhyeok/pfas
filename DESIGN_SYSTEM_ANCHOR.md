# PFAS Design System Anchor
## 프리미엄 신뢰형 UI/UX 기준 v0.1

이 문서는 [PROJECT_ANCHOR.md](/c:/Development/Owner/pfas/PROJECT_ANCHOR.md), [pfas_agent_bible_v1.md](/c:/Development/Owner/pfas/pfas_agent_bible_v1.md), [pfas_master_prompt_short.md](/c:/Development/Owner/pfas/pfas_master_prompt_short.md)를 실제 UI/UX 언어로 번역한 문서다.

이 프로젝트에서 디자인은 장식이 아니다.

디자인은 곧 아래 세 가지를 동시에 전달해야 한다.

1. 이 서비스는 과장하지 않는다.
2. 이 서비스는 똑똑하게 정리해준다.
3. 이 서비스는 비싼 제품을 밀어붙이지 않는다.

---

# 1. 디자인 포지셔닝

원하는 톤은 단순한 “스타트업 느낌”이 아니다.

우리가 노리는 건 다음 조합이다.

- `Mercury`의 차분한 프리미엄
- `Ramp`의 정보 구조 선명함
- `Linear`의 표면 정리와 인터랙션 절제
- `Stripe`의 설명형 랜딩 품질

하지만 그대로 베끼면 안 된다.

우리는 금융 SaaS가 아니라 `신뢰 기반 의사결정 제품`이므로, 최종 톤은 아래처럼 고정한다.

> calm, premium, technical, honest, editorial, not salesy

즉 “번쩍이는 AI 랜딩”이 아니라 “조용히 비싸 보이고, 매우 잘 정리된 제품”이어야 한다.

---

# 2. 시각 원칙

## 2.1 핵심 미학

- light-first
- warm-neutral background
- high legibility
- restrained color
- big type with quiet confidence
- dense information, but never noisy

## 2.2 절대 피할 것

- 검정 배경 위 네온 그라디언트
- 보라색 위주의 전형적인 SaaS 팔레트
- 과도한 glassmorphism
- 의미 없는 floating blobs
- 과도한 아이콘 남발
- 지나치게 둥근 카드와 장난감 같은 UI
- “AI가 다 알아서 해준다”류의 가벼운 톤

---

# 3. 브랜드 무드

## 3.1 한 줄 무드

`water utility intelligence meets premium startup software`

## 3.2 UI가 줘야 하는 감정

- 안심
- 정돈감
- 전문성
- 판단 가능성
- 절제된 자신감

사용자가 페이지를 보고 바로 느껴야 할 건 공포가 아니라 아래다.

> “여긴 나를 겁주지 않고, 내가 뭘 해야 하는지 차분하게 정리해주는 곳이다.”

---

# 4. 추천 디자인 방향

## 방향명

`Editorial Infrastructure`

이 방향은 두 가지 세계를 섞는다.

- 인프라/공공 데이터의 신뢰감
- 현대 SaaS 제품의 마감과 속도감

즉 결과물은 “정부 사이트”처럼 보이면 실패고, “광고 랜딩”처럼 보여도 실패다.

---

# 5. 색상 시스템

## 5.1 기본 원칙

색은 브랜드를 설명하기보다 신뢰를 조율하는 용도로 쓴다.

강한 원색보다 `톤 차이`, `표면 레이어`, `정보 우선순위`가 중요하다.

## 5.2 추천 팔레트

### Base

- Background: soft ivory
- Surface: white
- Surface muted: warm gray
- Border: cool gray with low contrast
- Text primary: deep slate
- Text secondary: muted slate

### Accent

- Primary accent: deep teal
- Secondary accent: mineral blue
- Success/support accent: muted green
- Warning accent: ochre/amber, not bright yellow

### 이유

- teal/blue는 물과 기술, 신뢰를 동시에 암시한다.
- ivory background는 완전한 흰색보다 프리미엄하고 눈 피로가 적다.
- amber warning은 공포형 red보다 덜 공격적이다.

## 5.3 색 사용 규칙

- 색은 면적보다 포인트에 쓴다.
- 주요 CTA는 1개만 강하게 쓴다.
- “warning”은 위기감이 아니라 `추가 확인 필요` 뉘앙스로 쓴다.
- 카드 구분은 배경색보다 border와 spacing으로 해결한다.

---

# 6. 타이포그래피

## 6.1 방향

전형적인 `Inter-only` SaaS 느낌은 피한다.

우리는 아래 조합을 추천한다.

- UI Sans: `Manrope` 또는 `Instrument Sans`
- Editorial Serif accent: `Newsreader` 또는 `Source Serif 4`

## 6.2 권장 조합

### 1안

- UI / body / labels: Manrope
- hero accent / editorial pull-quote / key emphasis: Newsreader

### 2안

- UI / body / labels: Instrument Sans
- editorial accent: Source Serif 4

### 한글 혼용 권장

- Korean UI fallback: Pretendard Variable 또는 SUIT
- 영문 주도 인터페이스여도 한글이 섞이면 line-height를 더 넉넉히 잡는다.

## 6.3 사용 규칙

- body는 sans로 간다.
- serif는 전체 본문용이 아니라 “의미 있는 강조”에만 쓴다.
- 숫자, 비용, 인증 체크리스트는 sans + tabular figures 우선.
- 제목은 크기보다 weight와 line-break 제어가 중요하다.
- caveat나 methodology는 낮은 톤으로 처리해도 되지만, 너무 작게 숨기지 않는다.

## 6.4 타이포 인상

우리가 원하는 건 “젊고 시끄러운 스타트업”이 아니라 아래다.

> precise sans + restrained serif contrast

이 조합이 있으면 제품이 더 비싸 보이고, 텍스트가 많은 서비스도 덜 지루해진다.

---

# 7. 레이아웃 시스템

## 7.1 전체 구조

- 넓은 여백
- 큰 헤드라인
- 짧은 설명
- 바로 아래에서 판단 UI 진입
- 정보 카드들은 세로로 안정적으로 정리

## 7.2 그리드

- 12-column desktop grid
- content width는 너무 넓지 않게 제한
- reading width는 강하게 제어
- 결과 화면은 `main content + contextual aside` 구조 허용

## 7.3 spacing

- tight가 아니라 generous
- 섹션 간 간격이 카드 안 간격보다 확실히 커야 함
- 모바일에서는 위계가 collapse되지 않게 section title과 body spacing 차이를 유지

---

# 8. 컴포넌트 원칙

## 8.1 핵심 컴포넌트

- Hero
- Segmented choice / radio card
- Result card
- Certification checklist
- Cost summary
- Escalation callout
- Trust strip
- Methodology block
- Utility helper panel

## 8.2 카드 스타일

카드는 “예쁜 카드”가 아니라 “생각을 정리하는 도구”처럼 보여야 한다.

권장:

- subtle border
- low shadow or no shadow
- generous padding
- slightly rounded corners
- quiet hover

비권장:

- 과한 blur
- 깊은 그림자
- 떠 있는 느낌의 글래스 패널

## 8.3 버튼 스타일

버튼은 공격적으로 보이면 안 된다.

- Primary CTA: 진한 teal/blue 단색
- Secondary CTA: ghost or soft outline
- destructive red는 거의 쓰지 않음
- 버튼 radius는 너무 pill 형태로 가지 않음

## 8.4 표와 비교 UI

이 프로젝트는 비교가 중요하므로 테이블과 비교 카드의 품질이 핵심이다.

- 숫자 정렬
- 행 간 리듬
- 보조 라벨
- certification과 maintenance 강조
- price만 크게 보이는 구성 금지

## 8.5 Caveat visibility

이 프로젝트에서 `WHAT THIS DOES NOT TELL YOU`는 면책문구가 아니다.

따라서 다음처럼 처리한다.

- secondary tone은 허용
- 작은 caption 수준으로 축소하는 것은 금지
- result card 바로 아래 또는 같은 시각 그룹 안에 둔다
- hover/accordion 안으로 숨기지 않는다

## 8.6 CSS 절대 법칙

프리미엄 느낌을 만드는 기본 규칙은 아래처럼 고정한다.

- border: `1px solid rgba(15, 23, 42, 0.06)` 수준의 섬세한 선
- shadow: 매우 약한 다층 그림자만 사용
- radius: `12px ~ 16px`
- background: pure white보다 살짝 따뜻한 오프화이트 우선
- accent: deep teal / slate blue 계열 한정
- bright red / bright green 사용 금지

예시 기준:

```css
--bg-app: #f7f7f4;
--bg-card: #ffffff;
--text-primary: #172033;
--text-secondary: #5f6b7a;
--border-soft: rgba(15, 23, 42, 0.06);
--accent-primary: #0f766e;
--accent-secondary: #315b7c;
--shadow-soft: 0 8px 24px rgba(15, 23, 42, 0.06);
```

---

# 9. 인터랙션과 모션

## 9.1 원칙

모션은 “오 멋있다”보다 “이건 살아있는 제품이다”를 느끼게 해야 한다.

## 9.2 추천 모션

- section reveal: 짧고 조용하게
- card hover: 1~2px lift 또는 border tint
- htmx partial swap: fade + slight translate
- progress / step change: subtle bar movement

## 9.3 금지

- 과한 parallax
- 큰 scale hover
- bounce
- 과장된 gradient animation

---

# 10. 접근성 기준

프리미엄 느낌은 시각 마감만으로 생기지 않는다.

이 프로젝트에서 접근성은 선택이 아니라 신뢰의 일부다.

## 필수 기준

- keyboard-only 이동 가능
- visible focus ring 유지
- 결과 카드와 partial update는 screen reader에 의미 있게 노출
- color alone로 상태를 구분하지 않음
- mobile touch target은 충분히 크게 유지
- body text contrast는 읽기 중심으로 확보

## HTMX 화면에서 추가 주의

- 결과가 교체되면 `aria-live` 또는 동등한 전달 방식 고려
- 로딩 상태를 시각적으로만 보여주지 않음
- 질문 step 변경 시 heading과 focus 이동을 함께 설계

---

# 11. 프론트엔드 구현 스택

## 최종 추천

- Templates: jte
- Interactivity: HTMX
- Minimal JS: Alpine.js
- Styling: Tailwind CSS v4
- Icons: Lucide 우선, 필요 시 Tabler 보조

## 왜 Tailwind CSS v4인가

이 프로젝트는 디자인 품질이 매우 중요하고, greenfield다.

따라서 `직접 CSS를 전부 짜는 것`보다 `토큰이 분명한 유틸리티 시스템`이 더 빠르고 덜 무너진다.

Tailwind는 공식적으로 최신 버전을 중심으로 UI blocks와 components 생태계가 잘 붙어 있다.

## 왜 shadcn/ui를 직접 쓰지 않는가

shadcn/ui는 훌륭하지만 React 중심이다.

현재 저장소는 jte + Spring MVC라서 shadcn 코드를 직접 쓰는 건 맞지 않다.

대신 아래처럼 쓴다.

- shadcn: 컴포넌트 미학과 spacing 규율 참고
- Radix: 접근성 원칙 참고
- 실제 구현: jte partial + HTMX + Alpine.js

즉 `코드 복사`가 아니라 `디자인 언어 차용`이다.

---

# 12. 추천 라이브러리와 툴

## 반드시 추천

- Tailwind CSS v4
- HTMX
- Alpine.js
- Lucide

## 조건부 추천

- Tabler Icons: 아이콘 범위가 더 많이 필요할 때
- Tailwind Plus: 예산이 있으면 구조적 스타터로 좋음
- Untitled UI Figma: 빠르게 고급스러운 Figma 시스템이 필요할 때

## 추천하지 않음

- Bootstrap
- DaisyUI 기본 테마 그대로
- Material UI 같은 강한 시스템 느낌
- React 전제 UI kit를 억지로 SSR 템플릿에 이식하기

---

# 13. 디자인 클론 전략

우리는 “그 사이트처럼 보이게” 만드는 게 아니라, `좋은 패턴만 분해해서 재조합`해야 한다.

## Clone Source A. Mercury

가져올 것:

- 프리미엄 라이트 테마
- 차분한 히어로
- 금융/신뢰 서비스 특유의 고급 여백

가져오지 말 것:

- 지나치게 generic한 은행 SaaS 문법

## Clone Source B. Ramp

가져올 것:

- 정보 밀도 정리
- 섹션 간 리듬
- 기능 요약 카드 구조

가져오지 말 것:

- 지나치게 판매 중심인 세일즈 압박

## Clone Source C. Linear

가져올 것:

- border discipline
- surface hierarchy
- 조용한 motion
- 정교한 spacing

가져오지 말 것:

- 너무 dark/black 중심의 분위기

## Clone Source D. Stripe

가져올 것:

- 설명형 페이지의 문장 리듬
- technical trust 느낌
- 시스템 소개 방식

가져오지 말 것:

- 과한 gradient brand language

---

# 14. 페이지별 디자인 방향

## 14.1 Homepage

역할:

- 문제를 설명하는 페이지가 아니라 방향을 정해주는 페이지

구성:

- quiet premium hero
- primary decision entry
- 4 user states
- trust / methodology strip
- certification and cost thesis
- core page entry cards

## 14.2 Action Checker

역할:

- 가장 중요한 제품 표면

느낌:

- 끝까지 긴 wizard라기보다 “decision console”

구성:

- 첫 1~2단계는 큰 질문형 stepper
- 이후는 radio card + side summary 기반 console
- side explanation
- progressive disclosure
- 결과 카드 고정 포맷

## 14.3 Content Pages

역할:

- 검색 유입 처리
- decision engine으로 자연스럽게 연결

느낌:

- editorial + product hybrid

구성:

- strong intro answer
- limits block
- decision branches
- certification / cost modules
- action checker CTA

---

# 15. 실제로 비싸 보이게 만드는 디테일

프리미엄 느낌은 화려함이 아니라 디테일에서 나온다.

## 반드시 챙길 것

- line-height 튜닝
- section spacing 리듬
- border 대비값 절제
- hover intensity 최소화
- 아이콘 stroke 일관성
- 버튼 높이와 타이포 밸런스
- 숫자 정렬
- CTA 개수 절제
- microcopy의 단정함

## 특히 중요한 것

이 제품은 텍스트 비중이 높다.

따라서 폰트와 spacing이 디자인의 절반이다.

---

# 16. 실행 결론

이 프로젝트의 디자인은 아래 방향으로 고정한다.

- Tone: premium trust startup
- Theme: light-first, warm-neutral, teal-accented
- Typography: modern sans + restrained serif contrast
- UX: decision-first, explanation-rich
- Surface style: minimal border, low shadow, high spacing discipline
- Stack: jte + HTMX + Alpine.js + Tailwind CSS v4
- Reference mode: Mercury + Ramp + Linear + Stripe를 분해해서 재구성

한 문장으로 요약하면 이렇다.

> 우리는 “멋진 랜딩페이지”를 만드는 게 아니라, 사용자가 비싼 결정을 내리기 전에 신뢰하고 읽을 수 있는 프리미엄 의사결정 UI를 만든다.
