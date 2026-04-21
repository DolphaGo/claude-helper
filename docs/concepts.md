---
layout: default
title: "핵심 개념"
nav_order: 2
has_children: false
---

# Claude Code 핵심 개념
{: .no_toc }

Claude Code의 Skills와 Plugins 시스템을 이해하기 위한 필수 개념들입니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Skills란?

**Skills**는 Claude의 기능을 확장하는 지침 파일입니다. `SKILL.md` 파일에 지침을 작성하면 Claude가 자신의 도구로 추가합니다.

### Skills의 특징

**자동 실행 또는 수동 호출:**
- Claude가 자동으로 판단해서 실행
- `/skill-name` 명령어로 직접 호출

**프롬프트 기반:**
- 고정된 코드가 아닌 지침
- Claude가 상황에 맞게 해석하고 실행
- 도구를 조합해서 복잡한 작업 수행

**확장 가능:**
- 여러 파일 포함 가능
- 스크립트 번들 가능
- 다른 Skills 참조 가능

---

## Skills가 있는 위치

Skills를 저장하는 위치에 따라 누가 사용할 수 있는지가 결정됩니다.

### 위치별 범위

| 위치 | 경로 | 적용 대상 | 우선순위 | 네임스페이스 |
|------|------|----------|----------|------------|
| **Enterprise** | 관리 설정 참조 | 조직의 모든 사용자 | 1 (최고) | `/skill-name` |
| **Personal** | `~/.claude/skills/<skill-name>/SKILL.md` | 모든 프로젝트 | 2 | `/skill-name` |
| **Project** | `.claude/skills/<skill-name>/SKILL.md` | 이 프로젝트만 | 3 | `/skill-name` |
| **Plugin (자동)** | `~/.claude/plugins/cache/.../skills/<skill-name>/SKILL.md` | 설치된 플러그인 | 4 | `/plugin-name:skill-name` |
| **Plugin (세션)** | 아무 곳 + `--plugin-dir` | 명시적 로드 | - | `/plugin-name:skill-name` |

### 플러그인 위치 명확화

**설치된 플러그인 (자동):**
```
~/.claude/plugins/cache/<plugin-name>/skills/
```
- Claude Code가 자동으로 관리하는 캐시
- 사용자가 직접 생성하거나 수정하지 않음
- 플러그인 설치 시 자동으로 이 위치에 캐시됨

**로컬 개발 플러그인 (세션):**
```bash
# 개발 중인 플러그인을 임시로 로드
claude --plugin-dir /path/to/my-plugin-dev
```
- 개발 중에만 사용
- 세션이 끝나면 사라짐
- 로컬 테스트 용도

**주의:**
- `~/.claude/plugins/` 디렉토리를 직접 만들거나 수정하지 마세요
- 플러그인 개발 시에는 `--plugin-dir` 플래그를 사용하세요

### 우선순위 다이어그램

```
┌─────────────────────────────────────┐
│  Enterprise Skills                  │  우선순위 1 (최고)
│  (조직 전체)                         │
└─────────────────────────────────────┘
              ↓ 덮어씀
┌─────────────────────────────────────┐
│  Personal Skills                    │  우선순위 2
│  (~/.claude/skills/)                │
└─────────────────────────────────────┘
              ↓ 덮어씀
┌─────────────────────────────────────┐
│  Project Skills                     │  우선순위 3
│  (.claude/skills/)                  │
└─────────────────────────────────────┘
              ↓ 덮어씀
┌─────────────────────────────────────┐
│  Plugin Skills (자동)                │  우선순위 4
│  (~/.claude/plugins/cache/...)      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  Plugin Skills (세션)                │  명시적 로드
│  (--plugin-dir로 지정)               │  네임스페이스로 충돌 없음
└─────────────────────────────────────┘
```

### 네임스페이스 규칙

**개인/프로젝트 Skills:**
```bash
# 위치
~/.claude/skills/hello/SKILL.md
.claude/skills/hello/SKILL.md

# 호출
/hello
```

**플러그인 Skills:**
```bash
# 위치 (자동 설치)
~/.claude/plugins/cache/my-plugin/skills/hello/SKILL.md

# 위치 (세션 로드)
/path/to/my-plugin/skills/hello/SKILL.md

# 호출 (둘 다 동일)
/my-plugin:hello
```

**특징:**
- 개인/프로젝트: 짧은 명령어 `/skill-name`
- 플러그인: 네임스페이스 `/plugin-name:skill-name`으로 충돌 방지

### 예제로 이해하기

**시나리오 1: 같은 이름의 Skill이 여러 위치에 있을 때**

```
~/.claude/skills/hello/SKILL.md           (Personal)
.claude/skills/hello/SKILL.md             (Project)
~/.claude/plugins/cache/my-plugin/skills/hello/SKILL.md  (Plugin)
```

**호출 결과:**
- `/hello` → Personal Skill 실행 (우선순위 2 > 3)
- `/my-plugin:hello` → Plugin Skill 실행 (네임스페이스로 구분)

**시나리오 2: 플러그인 개발**

```bash
# 개발 디렉토리 구조
/Users/myname/dev/my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── test/
        └── SKILL.md

# 테스트
cd /any/project
claude --plugin-dir /Users/myname/dev/my-plugin

# 호출
/my-plugin:test
```

**사용 권장:**
- **Personal**: 개인 워크플로우, 반복 작업
- **Project**: 프로젝트별 규칙, 팀 컨벤션
- **Plugin**: 재사용 가능한 도구, 공개 배포

---

## 중첩된 디렉토리의 자동 검색

하위 디렉토리에서 작업할 때, Claude Code는 중첩된 `.claude/skills/` 디렉토리를 자동으로 검색합니다.

### Monorepo 예제

```
project-root/
├── .claude/skills/           (전체 프로젝트)
│   └── project-wide/
├── packages/
│   ├── frontend/
│   │   └── .claude/skills/  (프론트엔드 전용)
│   │       └── ui-test/
│   └── backend/
│       └── .claude/skills/  (백엔드 전용)
│           └── api-test/
```

**동작:**
- `packages/frontend/` 파일 작업 시: `ui-test` skill 사용 가능
- `packages/backend/` 파일 작업 시: `api-test` skill 사용 가능
- 어디서든: `project-wide` skill 사용 가능

---

## Skill 파일 구조

### 기본 구조

```
skill-name/
└── SKILL.md           (필수)
```

**SKILL.md** 파일은 두 부분으로 구성:

```
┌─────────────────────────────────┐
│ SKILL.md                        │
├─────────────────────────────────┤
│ ---                             │
│ name: skill-name (선택)         │  ← Frontmatter (YAML)
│ description: 설명 (권장)        │     설정 영역
│ ---                             │
├─────────────────────────────────┤
│                                 │
│ Claude에게 주는 지침...         │  ← Markdown 콘텐츠
│                                 │     실제 Skill 내용
│                                 │
└─────────────────────────────────┘
```

### 확장 구조

```
skill-name/                          실행 흐름
├── SKILL.md           (필수)    →  1. 메인 지침
├── template.md        (선택)    →  2. 필요 시 템플릿 로드
├── examples/                    →  3. 필요 시 예제 참조
│   └── sample.md
└── scripts/                     →  4. 필요 시 스크립트 실행
    └── validate.sh
```

**권장사항:**
- `SKILL.md`는 500줄 이하로 유지
- 상세한 참조 자료는 별도 파일로 분리
- 필요할 때만 로드되도록 명시적으로 참조

---

## Frontmatter 필드

YAML frontmatter는 `---` 마커 사이에 작성합니다.

### 필수 vs 선택

**모든 필드가 선택사항입니다.** 최소한의 SKILL.md:

```yaml
---
description: Skill이 무엇을 하는지
---

지침 내용...
```

### 주요 필드

| 필드 | 필수 | 설명 |
|------|------|------|
| `name` | 아니오 | Skill 이름. 생략 시 디렉토리 이름 사용 |
| `description` | 권장 | Claude가 언제 사용할지 판단. 생략 시 콘텐츠 첫 단락 사용 |
| `argument-hint` | 아니오 | 자동완성에 표시될 힌트 (예: `[issue-number]`) |
| `disable-model-invocation` | 아니오 | `true`: 사용자만 호출 가능 |
| `user-invocable` | 아니오 | `false`: `/` 메뉴에서 숨김 |
| `allowed-tools` | 아니오 | 허용할 도구 목록 |
| `context` | 아니오 | `fork`: Subagent에서 실행 |
| `agent` | 아니오 | Subagent 유형 지정 |

### name 필드 이해하기

**생략 가능:**

```yaml
# 디렉토리 이름: explain-code
---
description: 코드를 설명합니다
---
```

→ Skill 이름은 `explain-code`가 됩니다.

**명시적 지정:**

```yaml
---
name: explain-code
description: 코드를 설명합니다
---
```

→ 디렉토리 이름과 다르게 할 수 있습니다.

**언제 사용:**
- 일반적으로 생략 (디렉토리 이름으로 충분)
- 디렉토리 이름과 다른 명령어를 원할 때만 사용

---

## Plugins란?

**Plugin**은 Skills, 설정, 도구를 하나의 패키지로 묶어서 배포하는 방법입니다.

### Plugin vs Personal Skills

| 비교 | Personal Skills | Plugin |
|------|----------------|---------|
| 위치 | `~/.claude/skills/` | `~/.claude/plugins/<plugin>/` |
| 호출 | `/skill-name` | `/plugin-name:skill-name` |
| 공유 | 어려움 | Git 저장소로 쉽게 공유 |
| 버전 관리 | 없음 | plugin.json으로 관리 |
| 설정 | 없음 | 메타데이터 포함 |

### Plugin 구조

```
~/.claude/plugins/my-plugin/
├── .claude-plugin/
│   └── plugin.json        (필수 - 메타데이터)
└── skills/
    ├── skill-one/
    │   └── SKILL.md
    └── skill-two/
        └── SKILL.md
```

### plugin.json

**필수 필드:**

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "플러그인 설명"
}
```

**선택 필드:**

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "플러그인 설명",
  "author": {
    "name": "Your Name",
    "url": "https://github.com/username"
  },
  "repository": "https://github.com/username/my-plugin",
  "license": "MIT"
}
```

---

## 네임스페이스 이해하기

### Personal/Project Skills

```bash
# 위치
~/.claude/skills/hello/SKILL.md
.claude/skills/hello/SKILL.md

# 호출
/hello
```

**특징:**
- 짧은 명령어
- 로컬에서만 사용
- 공유 어려움

### Plugin Skills

```bash
# 위치
~/.claude/plugins/my-plugin/skills/hello/SKILL.md

# 호출
/my-plugin:hello
```

**특징:**
- 네임스페이스로 충돌 방지
- Git으로 쉽게 공유
- 버전 관리
- 팀 협업 용이

### 네임스페이스 규칙

**Plugin 이름:**
- 소문자, 숫자, 하이픈만 가능
- 최대 64자

**Skill 이름:**
- 소문자, 숫자, 하이픈만 가능
- 최대 64자

**전체 형식:**
```
/plugin-name:skill-name
```

---

## Plugin 배포 방법

### 1. Git 저장소

**가장 일반적인 방법:**

```bash
# 사용자가 설치
cd ~/.claude/plugins
git clone https://github.com/username/my-plugin.git

# Claude 재시작
claude
```

**장점:**
- 버전 관리
- 쉬운 업데이트 (`git pull`)
- 협업 가능

### 2. 직접 배포

**파일을 직접 공유:**

```bash
# 압축
tar -czf my-plugin.tar.gz my-plugin/

# 사용자가 압축 해제
cd ~/.claude/plugins
tar -xzf my-plugin.tar.gz
```

### 3. 조직 배포

Enterprise 설정을 통해 전체 조직에 배포 가능합니다.

---

## Plugin 검색

### Marketplace

공식 Plugin들을 찾을 수 있습니다:
- [Claude Code Plugins](https://code.claude.com/plugins)

### 설치 방법

**공식 Plugin:**
```bash
cd ~/.claude/plugins
git clone <plugin-repository-url>
```

**확인:**
```bash
claude plugins list
```

또는 Claude Code 내에서:
```
/help skills
```

---

## 설계 가이드

### Skill 설계 원칙

**1. 단일 책임**
- 한 가지 일을 잘하도록
- 너무 많은 기능을 하나에 넣지 않기

**2. 명확한 설명**
- 사용자가 자연스럽게 말할 키워드 포함
- 주요 사용 사례를 앞에 배치
- 250자 이하로 간결하게

**3. 적절한 범위**
- Personal: 개인 도구, 워크플로우
- Project: 프로젝트별 규칙, 패턴
- Plugin: 팀 공유, 재사용 가능한 도구

### Plugin 설계 원칙

**1. 응집성**
- 관련된 Skills를 함께 묶기
- 명확한 주제나 목적

**2. 독립성**
- 다른 Plugin에 의존하지 않기
- 필요한 모든 것을 포함

**3. 문서화**
- README.md 포함
- 각 Skill의 사용법 설명
- 예제 제공

---

## 명령어 vs Skills

### 기본 제공 명령어

**위치:** Claude Code 내장

**예시:** `/help`, `/compact`, `/clear`

**특징:**
- 고정된 로직
- 즉시 실행
- 수정 불가

### Skills

**위치:** 사용자가 정의

**예시:** 사용자가 만든 모든 Skills

**특징:**
- 프롬프트 기반
- Claude가 해석
- 커스터마이징 가능

### 통합

`.claude/commands/` 디렉토리의 파일도 계속 작동하며, Skills와 동일하게 `/` 명령어로 호출됩니다. 하지만 **Skills 권장:**

- 지원 파일 포함 가능
- Frontmatter로 더 많은 제어
- 향후 기능 지원

---

## 실전 팁

### Skill 이름 짓기

**좋은 이름:**
- `git-summary`: 명확하고 구체적
- `api-test`: 무엇을 하는지 알 수 있음
- `deploy-prod`: 대상이 명확

**나쁜 이름:**
- `gs`: 너무 짧고 모호
- `do-something`: 너무 일반적
- `my_skill_v2_final`: 언더스코어 사용 안 됨

### Description 작성

**좋은 설명:**
```yaml
description: Git 저장소의 현재 상태를 한눈에 보여줍니다. 브랜치, 변경사항, 다음 행동을 포함합니다.
```

**나쁜 설명:**
```yaml
description: Git 상태
```

**팁:**
- 사용자가 말할 법한 단어 사용
- 언제 사용할지 명시
- 구체적으로

### 테스트

**두 가지 방법으로 테스트:**

1. **자동 호출 테스트:**
```
설명과 일치하는 요청을 자연스럽게 말하기
```

2. **직접 호출 테스트:**
```
/skill-name
```

**반복:**
- 작동하지 않으면 설명 수정
- 너무 자주 호출되면 설명을 더 구체적으로
- 여러 상황에서 테스트

---

## 다음 단계

**개념을 이해했다면 실습으로 넘어가세요:**

### 기초 실습
- [Step 1: 첫 번째 Skill 만들기](step-01-first-skill)
- [Step 2: Git Skill 만들기](step-02-git-skill)
- [Step 3: 수동 Skill 만들기](step-03-command)

### 심화 실습
- [Step 4: API Skill 만들기](step-04-jira-skill)
- [Step 5: 검색 Skill 만들기](step-05-search-tool)
- [Step 6: 배포하기](step-06-publish)

### 고급 개념
- [고급 1: MCP 서버](advanced-01-mcp)
- [고급 2: Hooks](advanced-02-hooks)
- [더 많은 고급 개념...](advanced-01-mcp)
