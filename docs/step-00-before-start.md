---
layout: default
title: "Step 0: 시작하기 전에"
nav_order: 3
---

# Step 0: 시작하기 전에
{: .no_toc }

⏱️ 5분
{: .label .label-blue }

본격적으로 시작하기 전에 Claude와 플러그인 시스템을 이해합니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Claude Code가 뭔가요?

Claude Code는 **터미널에서 Claude AI와 대화하며 코딩하는 도구**입니다.

```bash
# 이런 식으로 사용
$ claude

You: 이 파일에서 TODO를 찾아줘
Claude: [파일을 읽고 TODO를 찾아서 보여줌]

You: Git 상태 확인해줘
Claude: [git status 실행하고 결과 보여줌]
```

---

## Skill과 Command가 뭔가요?

### Skill

**복잡한 작업을 자동화**하는 것입니다.

```
예시:
/code-review  → 코드를 분석하고 리뷰 리포트 작성
/analyze      → 프로젝트 구조 분석하고 요약
```

**특징:**
- 여러 단계로 구성
- 분석 + 리포트
- 실행 시간이 좀 걸림 (수초~수분)

### Command

**빠르고 간단한 작업**을 하는 것입니다.

```
예시:
/gs           → git status 보기
/commit       → 빠른 커밋
```

**특징:**
- 단일 목적
- 빠른 실행 (1-2초)
- 간단한 출력

---

## 플러그인이 뭔가요?

Skill과 Command를 **묶어서 배포하는 패키지**입니다.

```
플러그인 구조:
my-plugin/
├── .claude-plugin/
│   └── plugin.json      # 플러그인 정보
├── skills/              # Skill들
│   ├── review.md
│   └── analyze.md
└── commands/            # Command들
    ├── status.md
    └── commit.md
```

---

## 파일이 어떻게 읽히나요?

### 1. Claude Code 시작 시

```
1. ~/.claude/plugins/ 디렉토리 스캔
2. 각 플러그인의 .claude-plugin/plugin.json 읽기
3. skills/와 commands/ 디렉토리에서 .md 파일 찾기
4. 각 파일의 frontmatter 파싱
5. 메모리에 등록
```

### 2. 사용자가 /skill-name 입력 시

```
1. 등록된 skill 중에서 name 매칭
2. 해당 .md 파일 전체 내용 로드
3. Claude에게 전달
4. Claude가 내용에 따라 실행
```

---

## 파일 위치와 이름 규칙

### 위치

```bash
~/.claude/plugins/        # 여기에 플러그인들이 있음
└── my-plugin/            # 플러그인 이름 (자유)
    ├── .claude-plugin/
    │   └── plugin.json   # 필수: 플러그인 정보
    ├── skills/           # 선택: skill 파일들
    └── commands/         # 선택: command 파일들
```

### 이름 규칙

```bash
# Skill/Command 파일
✅ hello.md              # 소문자 (권장)
✅ git-status.md         # 하이픈 가능
✅ code_review.md        # 언더스코어 가능
✅ Hello.md              # 대문자도 가능 (단, 소문자 권장)
❌ git status.md         # 공백 안 됨
```

**권장 사항:**  
- 소문자 사용을 권장합니다 (타이핑 편리, 일반적인 관례)
- 중요한 것은 frontmatter의 `name` 필드입니다

---

## plugin.json이 뭔가요?

**플러그인의 메타데이터**를 담은 파일입니다.

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "내 첫 플러그인",
  "skills": {
    "path": "skills/**/*.md"
  },
  "commands": {
    "path": "commands/**/*.md"
  }
}
```

**필드 설명:**
- `name`: 플러그인 이름
- `version`: 버전
- `description`: 설명
- `skills.path`: skill 파일 경로 패턴
- `commands.path`: command 파일 경로 패턴

**왜 필요한가?**  
Claude Code가 이 파일을 보고:
1. 플러그인임을 인식
2. 어디서 skill/command를 찾을지 알게 됨

---

## Frontmatter가 뭔가요?

**Markdown 파일 맨 위의 메타데이터**입니다.

```markdown
---
name: hello
description: 인사 skill
---

여기부터 실제 내용
```

**왜 필요한가?**
- `name`: 슬래시 명령어 이름 (`/hello`)
- `description`: 설명 (선택)
- 기타 옵션들...

Claude Code가 이것을 파싱해서 skill을 등록합니다.

---

## 실행 흐름

```
[사용자]
  ↓ "/hello" 입력
[Claude]
  ↓ "hello"라는 name을 가진 skill 찾기
  ↓ ~/.claude/plugins/my-plugin/skills/hello.md 발견
  ↓ 파일 내용 전체 로드
  ↓ Claude에게 전달
[Claude AI]
  ↓ 파일 내용 읽고 이해
  ↓ 내용에 따라 행동 (도구 사용, 응답 등)
  ↓ 결과 출력
[사용자]
  ↓ 결과 확인
```

---

## 간단히 정리

| 항목 | 설명 |
|:-----|:-----|
| **Claude Code** | AI와 코딩하는 CLI 도구 |
| **Skill** | 복잡한 작업 자동화 |
| **Command** | 빠른 간단한 작업 |
| **플러그인** | Skill/Command 묶음 |
| **plugin.json** | 플러그인 정보 파일 (필수) |
| **Frontmatter** | .md 파일 상단의 메타데이터 |
| **~/.claude/plugins/** | 플러그인 설치 위치 |

---

## 예상 질문

### Q: 파일을 수정하면 바로 반영되나요?

**A: 아니요.** Claude를 재시작해야 합니다.

```bash
# CLI인 경우
Ctrl+D로 종료 후 다시 실행

# Desktop인 경우
앱 재시작
```

**왜?**  
시작할 때 한 번만 파일을 읽어서 메모리에 올려두기 때문입니다.

### Q: plugin.json이 없으면 어떻게 되나요?

**A: 플러그인으로 인식 안 됩니다.**

디렉토리만 있어도 안 되고, 반드시 `plugin.json`이 있어야 합니다.

### Q: Skill과 Command 파일 형식이 다른가요?

**A: 거의 같습니다.**

차이점:
- Command는 `aliases` 필드를 쓸 수 있음 (단축 이름)
- Skill은 `trigger` 필드를 쓸 수 있음 (자동 감지)

하지만 기본 구조는 동일합니다.

---

## 다음 단계

이제 기본 개념을 이해했습니다!

실제로 파일을 만들어봅시다.

[Step 1: 첫 번째 Skill 만들기 →](step-01-first-skill)
{: .btn .btn-primary }
