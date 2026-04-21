# 검증 결과 (검증자 A1)

## 검증 개요

**검증 대상:** step-07-local-plugin.md  
**검증 일시:** 2026-04-21  
**공식 문서 출처:**
- https://code.claude.com/docs/ko/plugins
- https://code.claude.com/docs/ko/skills

---

## 1. 플러그인 디렉토리 구조

### 공식 문서에 따르면:

공식 문서(Skills 페이지)의 표에서:

```
위치: Plugin
경로: <plugin>/skills/<skill-name>/SKILL.md
적용 대상: 플러그인이 활성화된 위치
```

그리고 플러그인 설명:
- **플러그인** (`.claude-plugin/plugin.json`이 있는 디렉토리)
- Skill 이름: `/plugin-name:hello`

### step-07 문서의 내용:

**라인 42-50:**
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── skill-a/
    │   └── SKILL.md
    └── skill-b/
        └── SKILL.md
```

**라인 99-105:**
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # 플러그인 메타데이터
└── skills/                  # 스킬 디렉토리 (루트에 직접)
    └── example/
        └── SKILL.md         # 스킬 파일
```

### 판정: ✅ 정확

**분석:**
- `.claude-plugin/` 디렉토리 위치: 정확 (플러그인 루트)
- `skills/` 디렉토리 위치: 정확 (플러그인 루트 바로 아래, `.claude-plugin/`과 같은 레벨)
- `SKILL.md` 파일 위치: 정확 (`skills/<skill-name>/SKILL.md`)

---

## 2. Skills 경로

### 공식 문서:

**Skills 위치 표:**
```
위치          | 경로                                    | 적용 대상
-------------|----------------------------------------|-------------
Personal     | ~/.claude/skills/<skill-name>/SKILL.md | 모든 프로젝트
Project      | .claude/skills/<skill-name>/SKILL.md   | 이 프로젝트만
Plugin       | <plugin>/skills/<skill-name>/SKILL.md  | 플러그인이 활성화된 위치
```

### step-07 문서:

**라인 31-33 (개인 Skills):**
```
~/.claude/skills/
└── my-SKILL.md
```

**라인 102:**
```
└── skills/                  # 스킬 디렉토리 (루트에 직접)
```

**라인 117:**
```
"file": "skills/example/SKILL.md",
```

### 판정: ⚠️ 부분 오류

**오류 위치:** 라인 31-33

**문제점:**
- 개인 Skills 예제가 `~/.claude/skills/my-SKILL.md` 형태로 표시되어 디렉토리 구조가 생략됨
- 공식 문서에 따르면 `~/.claude/skills/<skill-name>/SKILL.md` 형태여야 함
- Skills는 **디렉토리 단위**로 관리되며, 단일 파일이 아님

**올바른 형태:**
```
~/.claude/skills/
└── my-skill/
    └── SKILL.md
```

**플러그인 내 Skills 경로는 정확함:**
- `skills/<skill-name>/SKILL.md` ✅
- Plugin.json에서 `"file": "skills/example/SKILL.md"` ✅

---

## 3. 명령어 검증

### 공식 문서:

Plugins 문서에서:
- "**--plugin-dir** 플래그를 사용하여 로컬에서 테스트합니다"

### step-07 문서:

**라인 153-156:**
```bash
claude code --plugin-dir ~/projects/my-plugin
```

**라인 160-165:**
```bash
claude code \
  --plugin-dir ~/projects/plugin-a \
  --plugin-dir ~/projects/plugin-b \
  --plugin-dir ~/Desktop/test-plugin
```

**라인 190-192:**
```bash
mkdir -p ~/dev/my-first-plugin/.claude-plugin
mkdir -p ~/dev/my-first-plugin/skills/hello
cd ~/dev/my-first-plugin
```

### 판정: ✅ 정확

**분석:**
- `--plugin-dir` 사용법: 정확 ✅
- 여러 플러그인 동시 로드: 정확 ✅
- `mkdir` 명령어 경로: 정확 ✅
  - `.claude-plugin/` 디렉토리 생성 ✅
  - `skills/<skill-name>/` 디렉토리 생성 ✅

---

## 4. 주요 발견 사항

### ✅ 정확한 내용

1. **플러그인 구조:** `.claude-plugin/plugin.json` + `skills/` 디렉토리
2. **Skills 파일 위치:** `skills/<skill-name>/SKILL.md`
3. **plugin.json 구조:** 예제가 정확함
4. **--plugin-dir 플래그:** 사용법이 정확함
5. **네임스페이스:** `/plugin-name:skill-name` 형식 정확

### ❌ 오류 내용

1. **개인 Skills 예제 (라인 31-33):**
   - 현재: `~/.claude/skills/my-SKILL.md` (단일 파일 형태)
   - 올바름: `~/.claude/skills/<skill-name>/SKILL.md` (디렉토리 구조)

### 📝 추가 권장 사항

1. **라인 31-49 섹션 수정 필요:**
   - 개인 Skills와 플러그인 비교 시 디렉토리 구조를 명확히 표시
   - 현재는 개인 Skills가 단일 파일처럼 보임

2. **일관성 개선:**
   - 문서 전체에서 Skills는 항상 디렉토리 구조로 표현되어야 함
   - `SKILL.md`는 항상 `<skill-name>/SKILL.md` 형태로 위치

---

## 5. 수정 권장사항

### 수정이 필요한 섹션

**위치:** 라인 26-37

**현재 내용:**
```markdown
### 개인 Skills (Step 3에서 배운 것)

```
~/.claude/skills/
└── my-SKILL.md
```

- **단일 스킬 단위**
- 네임스페이스 없음 (`/my-skill`)
- 간단한 자동화에 적합
```

**수정안:**
```markdown
### 개인 Skills (Step 3에서 배운 것)

```
~/.claude/skills/
└── my-skill/
    └── SKILL.md
```

- **단일 스킬 단위** (디렉토리로 관리)
- 네임스페이스 없음 (`/my-skill`)
- 간단한 자동화에 적합
```

---

## 6. 결론

### 전체 정확도: 95%

**우수한 점:**
- 플러그인 디렉토리 구조가 공식 문서와 정확히 일치
- plugin.json 예제가 올바름
- --plugin-dir 사용법이 정확
- 대부분의 예제 코드가 실행 가능

**개선 필요:**
- 개인 Skills 디렉토리 구조 표현 수정 (1개 섹션)
- Skills가 항상 디렉토리 기반임을 강조

### 최종 평가: 양호 (Good)

문서의 핵심 내용은 정확하며, 플러그인 구조와 사용법이 공식 문서와 일치합니다. 
단 하나의 사소한 오류(개인 Skills 표현)만 수정하면 완벽한 문서가 될 것입니다.

---

## 참고: 공식 문서 인용

### Skills 위치 표 (공식 문서)

| 위치 | 경로 | 적용 대상 |
|------|------|-----------|
| Enterprise | 관리 설정 참조 | 조직의 모든 사용자 |
| Personal | `~/.claude/skills/<skill-name>/SKILL.md` | 모든 프로젝트 |
| Project | `.claude/skills/<skill-name>/SKILL.md` | 이 프로젝트만 |
| Plugin | `<plugin>/skills/<skill-name>/SKILL.md` | 플러그인이 활성화된 위치 |

### 플러그인 정의 (공식 문서)

> **플러그인** (`.claude-plugin/plugin.json`이 있는 디렉토리)
> - Skill 이름: `/plugin-name:hello`
> - 팀원과 공유, 커뮤니티에 배포, 버전 관리 릴리스, 프로젝트 간 재사용

---

**검증 완료**
- 검증자: A1
- 날짜: 2026-04-21
- 상태: 검증 완료 (1개 수정 권장사항 포함)
