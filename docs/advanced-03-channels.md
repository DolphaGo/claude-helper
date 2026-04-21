---
layout: default
title: "고급 3: 메시징 채널"
nav_order: 12
parent: 고급 개념
---

# 메시징 채널로 Claude와 대화하기
{: .no_toc }

⏱️ 20분
{: .label .label-red }

Telegram, Discord, iMessage, fakechat을 통해 Claude Code와 메시지를 주고받는 방법을 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 메시징 채널이란?

**메시징 채널(Messaging Channels)**은 다양한 메시징 플랫폼을 통해 Claude Code와 대화할 수 있게 해주는 기능입니다.

### 왜 필요한가?

일반적으로 Claude Code는 터미널에서만 사용합니다. 하지만 메시징 채널을 사용하면:

````
기본 방식 (터미널만)
┌──────────────┐
│  터미널      │
│  $ claude    │ ← 여기서만 대화 가능
│              │
└──────────────┘


메시징 채널 (다중 플랫폼)
┌──────────────┐         ┌──────────────┐
│  Telegram    │         │              │
│  💬 메시지   │ ───────→│              │
└──────────────┘         │              │
                         │ Claude Code  │
┌──────────────┐         │              │
│  Discord     │         │              │
│  💬 메시지   │ ───────→│              │
└──────────────┘         │              │
                         └──────────────┘
┌──────────────┐         
│  iMessage    │         
│  💬 메시지   │ ───────→  모든 곳에서
└──────────────┘           대화 가능!
````

### 지원하는 플랫폼

Claude Code는 다음 4가지 메시징 채널을 지원합니다:

| 채널 | 설명 | 적합한 상황 |
|------|------|------------|
| **Telegram** | 텔레그램 봇 | 개인 사용, 모바일 접근 |
| **Discord** | 디스코드 봇 | 팀 협업, 서버 통합 |
| **iMessage** | 애플 메시지 | macOS/iOS 사용자 |
| **fakechat** | 테스트용 채널 | 개발 및 테스트 |

---

## 📦 메시징 채널 설정하기

메시징 채널은 **MCP 플러그인**을 통해 설치합니다.

### 기본 흐름

````
1. 플랫폼에서 봇 생성 (Telegram/Discord)
   ↓
2. 토큰 발급받기
   ↓
3. MCP 플러그인 설치
   ↓
4. Claude Code 재시작
   ↓
5. 메시징 앱에서 대화 시작!
````

---

## 💬 Telegram 채널 설정

### 1단계: Telegram 봇 생성

1. Telegram에서 [@BotFather](https://t.me/botfather) 찾기
2. `/newbot` 명령어 입력
3. 봇 이름 입력 (예: `My Claude Bot`)
4. 봇 사용자명 입력 (예: `my_claude_bot`)
5. **토큰 복사** (예: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

### 2단계: 환경 변수 설정

````bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export TELEGRAM_BOT_TOKEN="your-token-here"

# 적용
source ~/.bashrc  # 또는 source ~/.zshrc
````

### 3단계: MCP 플러그인 설치

````bash
# Claude Code에서 실행
/plugin install telegram
````

또는 수동 설정:

````bash
cat > ~/.claude/mcp/mcp.json << 'EOF'
{
  "mcpServers": {
    "telegram": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-telegram",
        "${TELEGRAM_BOT_TOKEN}"
      ]
    }
  }
}
EOF
````

### 4단계: Claude Code 재시작

````bash
# Ctrl+D로 종료 후
claude
````

### 5단계: 텔레그램에서 대화 시작

1. Telegram에서 생성한 봇 찾기
2. `/start` 명령어 전송
3. 일반 메시지처럼 Claude에게 질문하기!

````
너: /start
봇: 안녕하세요! Claude Code입니다.

너: 현재 프로젝트의 파일 목록을 보여줘
봇: [파일 목록 표시]

너: README.md 파일을 읽어줘
봇: [파일 내용 표시]
````

---

## 🎮 Discord 채널 설정

### 1단계: Discord 봇 생성

1. [Discord Developer Portal](https://discord.com/developers/applications) 접속
2. "New Application" 클릭
3. 봇 이름 입력 (예: `Claude Bot`)
4. "Bot" 메뉴 선택
5. "Add Bot" 클릭
6. **토큰 복사** ("Reset Token" 버튼으로 토큰 확인)

### 2단계: 봇 권한 설정

1. "OAuth2" → "URL Generator" 선택
2. Scopes에서 `bot` 체크
3. Bot Permissions에서:
   - ✅ Read Messages/View Channels
   - ✅ Send Messages
   - ✅ Read Message History
4. 생성된 URL로 서버에 봇 초대

### 3단계: 환경 변수 설정

````bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export DISCORD_BOT_TOKEN="your-token-here"

# 적용
source ~/.bashrc
````

### 4단계: MCP 플러그인 설치

````bash
# Claude Code에서 실행
/plugin install discord
````

또는 수동 설정:

````bash
cat >> ~/.claude/mcp/mcp.json << 'EOF'
{
  "mcpServers": {
    "discord": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-discord",
        "${DISCORD_BOT_TOKEN}"
      ]
    }
  }
}
EOF
````

### 5단계: Discord에서 대화 시작

1. 봇을 초대한 서버로 이동
2. 채널에서 봇 멘션: `@Claude Bot 안녕`
3. 또는 DM으로 직접 메시지 전송

````
너: @Claude Bot 이 프로젝트의 구조를 설명해줘
봇: 프로젝트는 다음과 같은 구조입니다...

너: @Claude Bot package.json 파일을 읽어줘
봇: [파일 내용 표시]
````

---

## 📱 iMessage 채널 설정

iMessage 채널은 macOS에서만 사용 가능합니다.

### 1단계: MCP 플러그인 설치

````bash
# Claude Code에서 실행
/plugin install imessage
````

또는 수동 설정:

````bash
cat >> ~/.claude/mcp/mcp.json << 'EOF'
{
  "mcpServers": {
    "imessage": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-imessage"
      ]
    }
  }
}
EOF
````

### 2단계: 권한 허용

macOS에서 iMessage 접근 권한을 요청하면 허용해야 합니다.

### 3단계: 사용

자신에게 메시지를 보내면 Claude가 응답합니다.

````
너: Claude, 현재 디렉토리의 파일 목록
Claude: [파일 목록 표시]
````

**참고:** iMessage는 주로 테스트 용도로 사용됩니다.

---

## 🧪 Fakechat 채널 (테스트용)

개발 및 테스트 목적으로 가짜 채팅 인터페이스를 사용할 수 있습니다.

### 설정

````bash
cat >> ~/.claude/mcp/mcp.json << 'EOF'
{
  "mcpServers": {
    "fakechat": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-fakechat"
      ]
    }
  }
}
EOF
````

### 사용

````bash
# 터미널에서
echo "현재 디렉토리의 파일 목록을 보여줘" | fakechat
````

**용도:**
- CI/CD 파이프라인에서 테스트
- 스크립트 자동화
- 플러그인 개발

---

## 🎨 메시징 채널과 Skill 연동

메시징 채널에서도 Skill을 사용할 수 있습니다.

### 예제: Telegram에서 Git Skill 사용

**Skill 생성:**

````bash
mkdir -p ~/.claude/skills/git-status
cat > ~/.claude/skills/git-status/SKILL.md << 'SKILLEOF'
---
description: Git 상태를 확인합니다
---

# Git Status

현재 Git 저장소의 상태를 확인합니다.

## 단계

1. `git status` 실행
2. 변경된 파일 목록 표시
3. 현재 브랜치 정보 표시
4. 커밋되지 않은 변경사항 요약
SKILLEOF
````

**Telegram에서 사용:**

````
너: /git-status
봇: 현재 브랜치: main
     변경된 파일: 3개
     - modified: src/app.js
     - modified: README.md
     - new file: test.js
````

---

## 📚 핵심 정리

### 채널별 특징

| 채널 | 장점 | 단점 | 추천 상황 |
|------|------|------|----------|
| **Telegram** | 빠름, 모바일 친화적 | 봇 설정 필요 | 개인 사용 |
| **Discord** | 팀 협업, 채널 관리 | 서버 설정 필요 | 팀 프로젝트 |
| **iMessage** | macOS 통합 | macOS만 | Mac 사용자 |
| **fakechat** | 스크립트 친화적 | UI 없음 | 자동화/테스트 |

### 설정 순서

````
1. 플랫폼에서 봇 생성 → 토큰 발급
2. 환경 변수 설정 → export TOKEN="..."
3. MCP 플러그인 설치 → /plugin install <platform>
4. Claude Code 재시작 → claude
5. 메시징 앱에서 사용 → @bot 메시지
````

### MCP 설정 파일

모든 메시징 채널은 `~/.claude/mcp/mcp.json`에서 관리됩니다:

````json
{
  "mcpServers": {
    "telegram": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-telegram", "${TELEGRAM_BOT_TOKEN}"]
    },
    "discord": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-discord", "${DISCORD_BOT_TOKEN}"]
    }
  }
}
````

---

## 🎓 실전 패턴

### 패턴 1: 팀 협업 (Discord)

````
상황: 팀원들이 프로젝트 상태를 실시간으로 확인

설정:
1. Discord 서버에 Claude 봇 추가
2. #dev-status 채널 생성
3. 봇에게 프로젝트 상태 질문

사용:
팀원A: @Claude Bot 최근 커밋 5개 보여줘
봇: [커밋 목록]

팀원B: @Claude Bot 테스트 결과는?
봇: [테스트 결과]
````

### 패턴 2: 모바일 개발 (Telegram)

````
상황: 외부에서 모바일로 서버 상태 확인

설정:
1. Telegram 봇 생성
2. 서버 모니터링 Skill 추가

사용:
출퇴근 중: "서버 상태 확인"
봇: 서버 정상 작동 중, CPU 30%, 메모리 45%
````

### 패턴 3: CI/CD 통합 (fakechat)

````bash
# .github/workflows/test.yml
- name: Test Report
  run: |
    echo "테스트 결과 요약해줘: $(cat test-results.json)" | fakechat
````

자동화된 테스트 리포트를 Claude가 분석하고 요약합니다.

---

## 🛠️ 고급 기능

### 1. 여러 채널 동시 사용

````json
{
  "mcpServers": {
    "telegram": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-telegram", "${TELEGRAM_BOT_TOKEN}"]
    },
    "discord": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-discord", "${DISCORD_BOT_TOKEN}"]
    }
  }
}
````

Telegram과 Discord를 동시에 사용할 수 있습니다.

### 2. 채널별 권한 설정

````bash
# .claude/settings.json
{
  "permissions": {
    "telegram": ["read", "list"],
    "discord": ["read", "write", "execute"]
  }
}
````

채널마다 다른 권한을 부여할 수 있습니다.

### 3. 자동 응답 설정

Skill을 사용해서 특정 메시지에 자동으로 응답:

````bash
mkdir -p ~/.claude/skills/auto-reply
cat > ~/.claude/skills/auto-reply/SKILL.md << 'SKILLEOF'
---
description: 상태 확인 메시지에 자동 응답
trigger: "상태", "status"
---

# Auto Reply

"상태" 또는 "status" 메시지를 받으면 자동으로 시스템 상태를 확인하고 응답합니다.
SKILLEOF
````

---

## ⚠️ 주의사항

### 보안

**토큰은 절대 코드에 직접 넣지 마세요:**

❌ **틀린 방법:**
````json
{
  "args": ["-y", "@modelcontextprotocol/server-telegram", "123456:ABC"]
}
````

✅ **올바른 방법:**
````json
{
  "args": ["-y", "@modelcontextprotocol/server-telegram", "${TELEGRAM_BOT_TOKEN}"]
}
````

````bash
# 환경 변수로 관리
export TELEGRAM_BOT_TOKEN="123456:ABC"
````

### 성능

**메시지 응답 시간:**
- 간단한 질문: 1-3초
- 파일 분석: 5-10초
- 복잡한 작업: 10-30초

긴 작업은 "작업 중입니다..." 메시지를 먼저 보내는 것이 좋습니다.

### 디버깅

채널이 작동하지 않으면:

````bash
# 1. MCP 서버 상태 확인
claude
/mcp list

# 2. 로그 확인
tail -f ~/.claude/logs/claude.log

# 3. 환경 변수 확인
echo $TELEGRAM_BOT_TOKEN

# 4. 플러그인 재설치
/plugin uninstall telegram
/plugin install telegram
````

---

## 🔍 트러블슈팅

### 문제 1: 봇이 응답하지 않음

**원인:**
- 토큰이 올바르지 않음
- 봇 권한이 부족함
- Claude Code가 실행 중이 아님

**해결:**
````bash
# 토큰 확인
echo $TELEGRAM_BOT_TOKEN

# Claude Code 재시작
pkill claude
claude

# 봇 권한 확인 (Discord의 경우)
# Developer Portal에서 권한 재설정
````

### 문제 2: "Permission denied" 에러

**원인:**
채널에 필요한 권한이 없음

**해결:**
````bash
# .claude/settings.json 확인
cat ~/.claude/settings.json

# 권한 추가
{
  "permissions": {
    "allowedCommands": ["telegram", "discord"]
  }
}
````

### 문제 3: 메시지가 느림

**원인:**
- 네트워크 지연
- 복잡한 작업
- 서버 부하

**해결:**
- 질문을 더 구체적으로 만들기
- 긴 작업은 터미널에서 실행
- 파일 크기 제한 확인

---

## ✅ 완료

메시징 채널을 통해 Claude Code를 사용하는 방법을 배웠습니다!

**배운 것:**
- ✅ 4가지 메시징 채널 (Telegram, Discord, iMessage, fakechat)
- ✅ MCP 플러그인 설치 방법
- ✅ 봇 생성 및 토큰 관리
- ✅ 환경 변수로 보안 유지
- ✅ Skill과 채널 연동

**핵심 개념:**
- 메시징 채널은 MCP 플러그인으로 설치
- 토큰은 환경 변수로 관리
- `/plugin install <platform>` 명령어 사용
- 모든 Skill을 메시징 앱에서도 사용 가능

**실전 팁:**
- 팀 협업은 Discord 추천
- 개인 사용은 Telegram 추천
- 자동화는 fakechat 추천
- macOS 사용자는 iMessage 가능

**다음에는:**
Scheduled Tasks로 정기적인 작업을 자동화하는 방법을 배웁니다.

### 다음 단계

[고급 4: Scheduled Tasks →](advanced-04-scheduled-tasks)
{: .btn .btn-primary }
