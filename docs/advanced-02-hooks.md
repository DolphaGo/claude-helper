---
layout: default
title: "고급 2: Hooks"
nav_order: 14
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

## 📋 Hook 이벤트

Claude Code는 다양한 Hook 이벤트를 제공합니다:

### 세션 수명 주기

| Hook 이름 | 실행 시점 |
|----------|---------|
| `SessionStart` | 세션 시작 또는 재개 시 |
| `SessionEnd` | 세션 종료 시 |
| `InstructionsLoaded` | CLAUDE.md 또는 규칙 파일 로드 시 |

### 사용자 상호작용

| Hook 이름 | 실행 시점 |
|----------|---------|
| `UserPromptSubmit` | 사용자가 프롬프트를 제출할 때 |
| `Stop` | Claude가 응답을 완료할 때 |
| `StopFailure` | API 오류로 턴이 종료될 때 |

### 도구 실행

| Hook 이름 | 실행 시점 |
|----------|---------|
| `PreToolUse` | 도구 실행 전 (차단 가능) |
| `PostToolUse` | 도구 실행 후 (성공) |
| `PostToolUseFailure` | 도구 실행 실패 후 |

### 권한 관리

| Hook 이름 | 실행 시점 |
|----------|---------|
| `PermissionRequest` | 권한 대화상자가 나타날 때 |
| `PermissionDenied` | 도구 호출이 거부될 때 |

### Sub-agent 및 작업

| Hook 이름 | 실행 시점 |
|----------|---------|
| `SubagentStart` | Subagent가 생성될 때 |
| `SubagentStop` | Subagent가 종료될 때 |
| `TaskCreated` | 작업이 생성될 때 |
| `TaskCompleted` | 작업이 완료될 때 |
| `TeammateIdle` | 팀원 agent가 유휴 상태가 될 때 |

### 환경 변경

| Hook 이름 | 실행 시점 |
|----------|---------|
| `ConfigChange` | 설정 파일이 변경될 때 |
| `CwdChanged` | 작업 디렉토리가 변경될 때 |
| `FileChanged` | 감시 중인 파일이 변경될 때 |
| `WorktreeCreate` | Worktree가 생성될 때 |
| `WorktreeRemove` | Worktree가 제거될 때 |

### 컨텍스트 관리

| Hook 이름 | 실행 시점 |
|----------|---------|
| `PreCompact` | 컨텍스트 압축 전 |
| `PostCompact` | 컨텍스트 압축 후 |

### 알림 및 입력

| Hook 이름 | 실행 시점 |
|----------|---------|
| `Notification` | Claude Code가 알림을 보낼 때 |
| `Elicitation` | MCP 서버가 사용자 입력을 요청할 때 |
| `ElicitationResult` | 사용자가 응답한 후 |

---

## ⚙️ Hook 설정하기

### Hook 핸들러 타입

Claude Code는 세 가지 타입의 Hook 핸들러를 지원합니다:

**1. 명령 Hook (Command Hook)**
```json
{
  "hooks": {
    "SessionStart": {
      "command": "echo '프로젝트 시작!'"
    }
  }
}
```

**2. HTTP Hook**
```json
{
  "hooks": {
    "PostToolUse": {
      "url": "https://api.example.com/webhook",
      "method": "POST"
    }
  }
}
```

**3. 프롬프트/에이전트 Hook**
```json
{
  "hooks": {
    "Stop": {
      "prompt": "작업이 완료되었습니다. 다음 단계를 제안해주세요."
    }
  }
}
```

### 설정 파일 위치

**전역 설정 (모든 프로젝트):**
```
~/.claude/settings.json
```

**프로젝트별 설정:**
```
.claude/settings.json
```

**로컬 설정 (gitignored):**
```
.claude/settings.local.json
```

### 기본 구조 (단순 형식)

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
    "SessionStart": {
      "command": "git status --short"
    }
  }
}
```

**효과:**
Claude Code를 시작할 때마다 변경된 파일 목록이 자동으로 표시됩니다.

### 예제 2: 파일 수정 후 자동 테스트

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "command": "npm test"
          }
        ]
      }
    ]
  }
}
```

**설명:**
- `matcher: "Write|Edit"`: Write 또는 Edit 도구 실행 후에만 동작
- 파일을 수정할 때마다 자동으로 테스트가 실행됩니다

### 예제 3: 환경 변수 확인

```json
{
  "hooks": {
    "SessionStart": {
      "command": "bash -c 'if [ -z \"$API_TOKEN\" ]; then echo \"⚠️ API_TOKEN이 설정되지 않았습니다\"; fi'"
    }
  }
}
```

**효과:**
필수 환경 변수가 없으면 경고 메시지를 표시합니다.

### 예제 4: 위험한 명령 차단

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "if": "Bash(rm -rf)",
            "command": "echo '{\"hookSpecificOutput\": {\"hookEventName\": \"PreToolUse\", \"permissionDecisionReason\": \"위험한 rm -rf 명령 차단\"}}'",
            "hookSpecificOutput": {
              "hookEventName": "PreToolUse",
              "permissionDecisionReason": "파괴적인 명령 차단"
            }
          }
        ]
      }
    ]
  }
}
```

**효과:**
`rm -rf`를 포함한 명령은 실행 전에 차단됩니다.

---

## 🎨 Matcher 패턴으로 필터링

특정 조건에만 Hook을 적용할 수 있습니다.

### Matcher 필드

`matcher` 필드는 Hook이 실행될 조건을 필터링합니다:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "command": "echo 'Bash 실행 전'" }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "command": "echo '파일 수정 전'" }
        ]
      }
    ]
  }
}
```

### if 필드로 세밀한 제어

`if` 필드로 추가 조건을 지정할 수 있습니다:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "if": "Bash(rm *)",
            "command": "echo '⚠️ 위험한 명령 차단'",
            "hookSpecificOutput": {
              "hookEventName": "PreToolUse",
              "permissionDecisionReason": "파괴적인 명령 차단"
            }
          }
        ]
      }
    ]
  }
}
```

**if 조건 예제:**
- `Bash(rm *)`: rm으로 시작하는 Bash 명령
- `Bash(git push --force)`: 강제 푸시 명령
- 패턴 매칭으로 세밀한 제어

### 도구별 Matcher 값

**도구 실행 이벤트:**
- `PreToolUse`, `PostToolUse`: 도구 이름 (Bash, Edit, Write, Read, Grep, etc.)
- `PermissionRequest`: 도구 이름
- `PermissionDenied`: 도구 이름

**MCP 도구:**
- `mcp__.*`: MCP 서버의 모든 도구
- `mcp__server_name__tool_name`: 특정 MCP 도구

**세션 이벤트:**
- `SessionStart`: startup, resume, clear, compact
- `SessionEnd`: clear, resume, logout, prompt_input_exit, other

**알림:**
- `Notification`: permission_prompt, idle_prompt, auth_success, elicitation_dialog

**Sub-agent:**
- `SubagentStart`/`SubagentStop`: Explore, Plan, general-purpose 또는 사용자 정의 이름

---

## 🔍 Hook 입출력

Hook은 JSON 형식으로 입력을 받고 출력을 반환합니다.

### 입력 구조

Hook 핸들러는 stdin을 통해 JSON 입력을 받습니다:

```json
{
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm test"
  },
  "session_id": "abc123",
  "cwd": "/path/to/project"
}
```

**공통 입력 필드:**
- `session_id`: 현재 세션 ID
- `cwd`: 현재 작업 디렉토리
- 이벤트별 추가 필드 (tool_name, tool_input, etc.)

### 출력 구조

Hook은 JSON 형식으로 결정을 반환할 수 있습니다:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecisionReason": "보안 정책 위반"
  }
}
```

### 환경 변수에서 JSON으로 전환

**이전 방식 (환경 변수):**
```bash
$FILE_PATH        # 더 이상 사용 안 함
$TOOL_NAME        # 더 이상 사용 안 함
```

**현재 방식 (JSON 입력):**
```bash
#!/bin/bash
# stdin에서 JSON 읽기
input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

echo "도구: $tool_name"
echo "파일: $file_path"
```

### 컨텍스트 주입

```json
{
  "hooks": {
    "SessionStart": {
      "command": "cat PROJECT_STATUS.md"
    }
  }
}
```

**효과:**
프로젝트 상태 문서를 자동으로 Claude에게 제공합니다.

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
    "SessionStart": {
      "command": "bash .claude/dashboard.sh"
    }
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
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "command": "bash -c 'input=$(cat); file=$(echo \"$input\" | jq -r \".tool_input.file_path\"); if [[ \"$file\" == *\".env\"* ]]; then echo \"⚠️ .env 파일 수정 주의\"; fi'"
          }
        ]
      }
    ]
  }
}
```

### 패턴 3: 자동 포맷팅

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "command": "bash -c 'input=$(cat); file=$(echo \"$input\" | jq -r \".tool_input.file_path // empty\"); if [ -n \"$file\" ] && [[ \"$file\" == *.js || \"$file\" == *.ts ]]; then prettier --write \"$file\"; fi'"
          }
        ]
      }
    ]
  }
}
```

### 패턴 4: 파일 변경 감시

```json
{
  "hooks": {
    "FileChanged": [
      {
        "matcher": ".env",
        "hooks": [
          {
            "command": "echo '⚠️ .env 파일이 변경되었습니다. 서비스를 재시작해야 할 수 있습니다.'"
          }
        ]
      }
    ]
  }
}
```

### 패턴 5: 비동기 테스트 실행

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "command": "npm test",
            "async": true
          }
        ]
      }
    ]
  }
}
```

비동기 Hook은 백그라운드에서 실행되며 결과를 기다리지 않습니다.

---

## 🛠️ 고급 기능

### HTTP Hook

외부 서비스에 이벤트를 전송할 수 있습니다:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "url": "https://api.example.com/code-changed",
            "method": "POST",
            "headers": {
              "Authorization": "Bearer ${WEBHOOK_TOKEN}"
            }
          }
        ]
      }
    ]
  }
}
```

**HTTP Hook 필드:**
- `url`: 엔드포인트 URL
- `method`: HTTP 메서드 (POST, GET, etc.)
- `headers`: 요청 헤더 (선택적)
- `body`: 요청 본문 (선택적, 기본값은 이벤트 JSON)

### 프롬프트 기반 Hook

LLM에게 결정을 위임할 수 있습니다:

```json
{
  "hooks": {
    "Stop": {
      "prompt": "작업이 완료되었습니다. 코드 품질을 평가하고 개선점이 있다면 제안해주세요.",
      "schema": {
        "type": "object",
        "properties": {
          "quality_score": { "type": "number" },
          "suggestions": { "type": "array" }
        }
      }
    }
  }
}
```

### 에이전트 기반 Hook

전용 에이전트에게 작업을 위임:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "agent": "code-reviewer",
            "instructions": "변경된 파일을 검토하고 문제가 있으면 보고하세요."
          }
        ]
      }
    ]
  }
}
```

### 조건부 Hook

JSON 입력을 파싱하여 조건부 실행:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "command": "bash -c 'input=$(cat); file=$(echo \"$input\" | jq -r \".tool_input.file_path\"); if [[ \"$file\" == *.ts ]]; then tsc --noEmit \"$file\"; fi'"
          }
        ]
      }
    ]
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
- ✅ 27가지 Hook 이벤트
- ✅ 3가지 Hook 타입 (명령, HTTP, 프롬프트/에이전트)
- ✅ Matcher 패턴과 if 필드로 필터링
- ✅ JSON 입출력 구조
- ✅ 실전 패턴

**핵심 개념:**
- Hooks는 이벤트 기반 자동화
- 명령, HTTP, 프롬프트 기반 핸들러 지원
- Matcher와 if로 세밀한 제어
- JSON 입력/출력으로 결정 제어
- 프로젝트별 또는 전역 설정 가능

**다음에는:**
Channels를 사용해서 외부 이벤트를 받는 방법을 배웁니다.

### 다음 단계

[고급 3: Channels →](advanced-03-channels)
{: .btn .btn-primary }
