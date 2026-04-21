---
layout: default
title: "고급 2: Hooks"
nav_order: 11
parent: 고급 개념
---

# Hooks로 워크플로우 자동화하기
{: .no_toc }

⏱️ 15분
{: .label .label-red }

특정 이벤트가 발생할 때 자동으로 명령어를 실행하는 Hooks를 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 Hooks란?

**Hooks**는 특정 이벤트가 발생할 때 자동으로 실행되는 shell 명령어입니다.

### 실생활 비유

Git hooks를 사용해본 적이 있나요?
- `pre-commit`: 커밋 전에 자동으로 린트 실행
- `post-merge`: 머지 후 자동으로 의존성 설치

Claude Code의 Hooks도 같은 개념입니다.

### 언제 사용하나?

**자동화가 필요한 경우:**
- 대화 시작할 때마다 프로젝트 상태 확인
- 명령어 실행 전에 환경 검증
- 파일 수정 후 자동으로 테스트 실행

---

## 📋 Hook 종류

Claude Code는 5가지 Hook을 제공합니다:

| Hook 이름 | 실행 시점 |
|----------|---------|
| `SessionStart` | 대화 시작 시 |
| `UserPromptSubmit` | 사용자가 메시지 보낼 때 |
| `PreToolUse` | 도구 실행 전 |
| `PostToolUse` | 도구 실행 후 |
| `CronEvent` | 정해진 시간마다 |

---

## ⚙️ Hook 설정하기

### 설정 파일 위치

**전역 설정 (모든 프로젝트):**
```
~/.claude/settings.json
```

**프로젝트별 설정:**
```
.claude/settings.json
```

### 기본 구조

```json
{
  "hooks": {
    "SessionStart": "echo '프로젝트 시작!'",
    "UserPromptSubmit": "date"
  }
}
```

---

## 💡 실용적인 예제

### 예제 1: 대화 시작 시 Git 상태 확인

```json
{
  "hooks": {
    "SessionStart": "git status --short"
  }
}
```

**효과:**
Claude Code를 시작할 때마다 변경된 파일 목록이 자동으로 표시됩니다.

### 예제 2: 파일 수정 후 자동 테스트

```json
{
  "hooks": {
    "PostToolUse:Write": "npm test"
  }
}
```

**설명:**
- `PostToolUse:Write`: Write 도구 실행 후에만 동작
- 파일을 수정할 때마다 자동으로 테스트가 실행됩니다

### 예제 3: 환경 변수 확인

```json
{
  "hooks": {
    "SessionStart": "bash -c 'if [ -z \"$API_TOKEN\" ]; then echo \"⚠️ API_TOKEN이 설정되지 않았습니다\"; fi'"
  }
}
```

**효과:**
필수 환경 변수가 없으면 경고 메시지를 표시합니다.

---

## 🎨 도구별 Hook

특정 도구에만 Hook을 적용할 수 있습니다.

### 구문

```json
{
  "hooks": {
    "PreToolUse:ToolName": "명령어",
    "PostToolUse:ToolName": "명령어"
  }
}
```

### 예제: Edit 도구에만 적용

```json
{
  "hooks": {
    "PreToolUse:Edit": "echo '파일을 수정합니다...'",
    "PostToolUse:Edit": "npm run lint"
  }
}
```

**도구 이름:**
- `Read`: 파일 읽기
- `Write`: 파일 쓰기
- `Edit`: 파일 수정
- `Bash`: 명령어 실행
- `Grep`: 코드 검색

---

## 🔍 Hook 출력 활용하기

Hook의 출력을 Claude가 읽을 수 있습니다.

### 컨텍스트 주입

```json
{
  "hooks": {
    "SessionStart": "cat PROJECT_STATUS.md"
  }
}
```

**효과:**
프로젝트 상태 문서를 자동으로 Claude에게 제공합니다.

### 조건부 실행

```bash
# .claude/settings.json
{
  "hooks": {
    "SessionStart": "bash .claude/check-env.sh"
  }
}
```

```bash
# .claude/check-env.sh
#!/bin/bash

if [ ! -f .env ]; then
  echo "⚠️ .env 파일이 없습니다"
  echo "다음 명령어를 실행하세요: cp .env.example .env"
fi

if ! command -v docker &> /dev/null; then
  echo "⚠️ Docker가 설치되지 않았습니다"
fi
```

---

## 📚 핵심 정리

### Hook 실행 순서

```
Claude Code 시작
       ↓
┌──────────────────────────────────────┐
│  SessionStart                        │  ← 1. 세션 시작 (한 번만)
│  - Git 상태 확인                      │
│  - 환경 변수 검증                     │
└──────────────────────────────────────┘
       ↓
사용자가 메시지 입력
       ↓
┌──────────────────────────────────────┐
│  UserPromptSubmit                    │  ← 2. 메시지 전송 즉시 (매번)
│  - 날짜/시간 기록                     │
└──────────────────────────────────────┘
       ↓
┌──────────────────────────────────────┐
│  PreToolUse:Write                    │  ← 3. 도구 실행 전
│  - 파일 백업                          │
│  - 권한 확인                          │
└──────────────────────────────────────┘
       ↓
┌──────────────────────────────────────┐
│  [도구 실행]                          │  ← 4. 실제 도구 사용
│   Write 파일 수정                     │
└──────────────────────────────────────┘
       ↓
┌──────────────────────────────────────┐
│  PostToolUse:Write                   │  ← 5. 도구 실행 후
│  - 자동 포맷팅                        │
│  - 테스트 실행                        │
└──────────────────────────────────────┘

[반복: 사용자 메시지 → 2 → 3 → 4 → 5]
```

**실전 예시:**
```
사용자: "src/app.js 파일 수정해줘"
   ↓
UserPromptSubmit Hook 즉시 실행: 시간 기록
   ↓
Claude가 요청 분석 및 Write 도구 사용 결정
   ↓
PreToolUse:Write Hook: 파일 백업 생성
   ↓
Write 도구 실행: 파일 수정
   ↓
PostToolUse:Write Hook: prettier 자동 실행
```

### 설정 우선순위

프로젝트별 설정이 전역 설정보다 우선합니다:

```
.claude/settings.json  >  ~/.claude/settings.json
```

### Hook 작성 팁

**좋은 Hook:**
- 빠르게 실행 (1초 이내)
- 명확한 출력
- 실패해도 작업을 막지 않음

**나쁜 Hook:**
- 느린 작업 (빌드, 배포)
- 너무 많은 출력
- 실패 시 작업 중단

---

## 🎓 실전 패턴

### 패턴 1: 프로젝트 상태 대시보드

```json
{
  "hooks": {
    "SessionStart": "bash .claude/dashboard.sh"
  }
}
```

```bash
# .claude/dashboard.sh
#!/bin/bash
echo "📊 프로젝트 상태"
echo "---"
echo "브랜치: $(git branch --show-current)"
echo "변경된 파일: $(git status --short | wc -l)"
echo "최근 커밋: $(git log -1 --oneline)"
echo "---"
```

### 패턴 2: 안전장치

```json
{
  "hooks": {
    "PreToolUse:Write": "bash -c 'if [[ \"$FILE_PATH\" == *\".env\"* ]]; then echo \"⚠️ .env 파일 수정 주의\"; fi'"
  }
}
```

### 패턴 3: 자동 포맷팅

```json
{
  "hooks": {
    "PostToolUse:Edit": "prettier --write $FILE_PATH"
  }
}
```

---

## 🛠️ 고급 기능

### 환경 변수 사용

Hook에서 사용 가능한 변수들:

```bash
$FILE_PATH        # 대상 파일 경로 (Read, Write, Edit)
$TOOL_NAME        # 도구 이름
$SESSION_ID       # 세션 ID
```

### 조건부 Hook

```json
{
  "hooks": {
    "PostToolUse:Write": "bash -c 'if [[ \"$FILE_PATH\" == *.ts ]]; then tsc --noEmit; fi'"
  }
}
```

TypeScript 파일만 타입 체크를 실행합니다.

---

## ⚠️ 주의사항

### 성능

Hook은 동기적으로 실행됩니다.
- 느린 명령어는 피하세요
- 필요하면 백그라운드 실행: `command &`

### 에러 처리

Hook 실패가 작업을 막지 않도록:

```bash
command || true  # 항상 성공으로 처리
```

### 보안

Hook은 shell 명령어를 실행합니다.
- 신뢰할 수 있는 저장소만 사용
- `.claude/settings.json` 파일을 검토하세요

---

## ✅ 완료

Hooks를 사용해서 워크플로우를 자동화하는 방법을 배웠습니다!

**배운 것:**
- ✅ 5가지 Hook 종류
- ✅ 설정 파일 작성
- ✅ 도구별 Hook 적용
- ✅ Hook 출력 활용
- ✅ 실전 패턴

**핵심 개념:**
- Hooks는 이벤트 기반 자동화
- 프로젝트별 또는 전역 설정 가능
- 특정 도구에만 적용 가능
- 빠르고 간단한 작업에 적합

**다음에는:**
Channels를 사용해서 외부 이벤트를 받는 방법을 배웁니다.

### 다음 단계

[고급 3: Channels →](advanced-03-channels)
{: .btn .btn-primary }
