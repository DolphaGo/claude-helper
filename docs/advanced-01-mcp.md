---
layout: default
title: "고급 1: MCP 서버"
nav_order: 10
parent: 고급 개념
---

# MCP 서버 연결하기
{: .no_toc }

⏱️ 20분
{: .label .label-red }

외부 시스템과 Claude Code를 연결하는 MCP(Model Context Protocol)를 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 MCP란?

**Model Context Protocol**은 Claude Code가 외부 시스템과 통신하는 표준 방식입니다.

### 왜 필요한가?

Claude Code는 로컬 파일만 다룰 수 있습니다. 하지만 실제 작업은:
- 데이터베이스 조회
- GitHub 이슈 확인
- Slack 메시지 전송
- Google Drive 파일 접근

이런 작업이 필요합니다. MCP 서버가 이를 가능하게 합니다.

### 작동 원리

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│              │         │              │         │              │
│ Claude Code  │ ←────→  │  MCP 서버    │ ←────→  │ 외부 시스템   │
│              │         │  (중개자)    │         │              │
│              │         │              │         │              │
└──────────────┘         └──────────────┘         └──────────────┘
     │                         │                         │
     │ 1. 요청                 │ 2. 변환                 │ 3. 실행
     │   "DB 조회"             │   SQL 쿼리              │   SELECT ...
     │                         │                         │
     │ 6. 응답 받음            │ 5. 포맷 변환            │ 4. 결과 반환
     └─────────────────────────┴─────────────────────────┘
                                                           
응답 흐름: 외부 시스템(4) → MCP 서버(5) → Claude Code(6)
```

**MCP 서버의 역할:**
- Claude Code의 요청을 외부 시스템이 이해하는 형식으로 변환
- 외부 시스템의 응답을 Claude Code가 이해하는 형식으로 변환
- 인증, 에러 처리, 연결 관리

**예시:**
```
Claude: "users 테이블에서 최근 10명 가져와줘"
  ↓
MCP 서버: SELECT * FROM users ORDER BY created_at DESC LIMIT 10
  ↓
데이터베이스: [결과 데이터]
  ↓
MCP 서버: JSON 형식으로 변환
  ↓
Claude: 결과를 분석하고 요약
```

---

## 📦 MCP 서버 설치

### 1단계: MCP 서버 찾기

공식 MCP 서버 목록:
- [GitHub](https://github.com/modelcontextprotocol/servers)
- Filesystem: 로컬 파일 시스템 접근
- Postgres: PostgreSQL 데이터베이스
- Slack: Slack 메시지
- Google Drive: 구글 드라이브 파일

### 2단계: 설정 파일 작성

MCP 서버는 `~/.claude/mcp/mcp.json`에서 설정합니다.

**예: Filesystem MCP 서버**

```bash
cat > ~/.claude/mcp/mcp.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/username/documents"
      ]
    }
  }
}
EOF
```

**설명:**
- `filesystem`: MCP 서버 이름 (직접 지정)
- `command`: 실행 명령어
- `args`: 명령어 인자

### 3단계: Claude Code 재시작

```bash
# Ctrl+D로 종료 후
claude
```

### 4단계: 확인

```bash
# Claude Code에서
/mcp list
```

연결된 MCP 서버 목록이 표시됩니다.

---

## 💡 실용적인 예제

### 예제 1: Postgres 데이터베이스 연결

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://user:password@localhost/mydb"
      ]
    }
  }
}
```

**사용:**

```
나에게 사용자 테이블의 최근 10개 레코드를 보여줘
```

Claude가 자동으로 MCP 서버를 통해 데이터베이스를 조회합니다.

### 예제 2: GitHub 이슈 관리

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github",
        "--token",
        "${GITHUB_TOKEN}"
      ]
    }
  }
}
```

**환경 변수 설정:**

```bash
# ~/.bashrc 또는 ~/.zshrc
export GITHUB_TOKEN="your-github-token"
```

**사용:**

```
오픈된 이슈 중에서 버그 관련 이슈를 찾아줘
```

---

## 🔧 MCP 서버와 Skill 연동

MCP 서버를 Skill에서 활용할 수 있습니다.

### 예: 데이터베이스 조회 Skill

```bash
mkdir -p ~/.claude/skills/db-query
cat > ~/.claude/skills/db-query/SKILL.md << 'SKILLEOF'
---
description: 데이터베이스를 조회합니다
argument-hint: [query]
---

# Database Query

사용자가 요청한 정보를 데이터베이스에서 조회하세요.

## 1. MCP 서버 확인
Postgres MCP 서버가 연결되어 있는지 확인하세요.

## 2. 쿼리 실행
사용자의 요청을 SQL로 변환하여 실행하세요.

## 3. 결과 정리
결과를 표 형식으로 보기 좋게 보여주세요.
SKILLEOF
```

---

## 📚 핵심 정리

### MCP의 3가지 구성 요소

1. **Resources**: 외부 데이터에 접근 (파일, DB 레코드)
2. **Tools**: 작업 수행 (파일 생성, API 호출)
3. **Prompts**: 재사용 가능한 프롬프트 템플릿

### 설정 파일 위치

```
~/.claude/mcp/mcp.json
```

### 기본 구조

```json
{
  "mcpServers": {
    "서버이름": {
      "command": "실행명령",
      "args": ["인자1", "인자2"]
    }
  }
}
```

### 환경 변수 사용

토큰이나 비밀번호는 환경 변수로 관리:

```json
{
  "args": ["--token", "${TOKEN_NAME}"]
}
```

---

## 🎓 언제 사용하나?

### MCP가 적합한 경우

- ✅ 외부 시스템 데이터가 필요할 때
- ✅ API 호출을 자주 해야 할 때
- ✅ 데이터베이스 조회가 필요할 때
- ✅ 팀 전체가 같은 통합을 사용할 때

### Skill만으로 충분한 경우

- ✅ 간단한 bash 명령어로 해결 가능
- ✅ 일회성 작업
- ✅ 복잡한 설정이 필요 없는 경우

---

## 🔗 공식 MCP 서버

### 데이터 접근
- **filesystem**: 로컬 파일 시스템
- **postgres**: PostgreSQL
- **sqlite**: SQLite

### 외부 서비스
- **github**: GitHub 저장소/이슈
- **slack**: Slack 메시지
- **google-drive**: 구글 드라이브

### 개발 도구
- **git**: Git 저장소 관리
- **brave-search**: 웹 검색
- **puppeteer**: 브라우저 자동화

전체 목록: [MCP Servers](https://github.com/modelcontextprotocol/servers)

---

## 🛡️ 보안 주의사항

### 토큰 관리

**절대 하지 말 것:**
```json
{
  "args": ["--token", "abc123xyz"]
}
```

**올바른 방법:**
```json
{
  "args": ["--token", "${MY_TOKEN}"]
}
```

```bash
# ~/.bashrc
export MY_TOKEN="abc123xyz"
```

### 접근 권한

MCP 서버에 최소 권한만 부여:
- Filesystem: 특정 디렉토리만 접근
- Database: 읽기 전용 계정 사용
- API: 필요한 scope만 허용

---

## ✅ 완료

MCP 서버를 연결하는 방법을 배웠습니다!

**배운 것:**
- ✅ MCP가 무엇인지
- ✅ MCP 서버 설치 방법
- ✅ 설정 파일 작성
- ✅ 환경 변수로 토큰 관리
- ✅ Skill과 MCP 연동

**핵심 개념:**
- MCP는 Claude Code와 외부 시스템을 연결하는 표준 프로토콜
- 설정 파일 `~/.claude/mcp/mcp.json`에서 관리
- 토큰은 반드시 환경 변수로 관리
- Skill에서 MCP 도구를 활용 가능

**다음에는:**
Hooks를 사용해서 워크플로우를 자동화하는 방법을 배웁니다.

### 다음 단계

[고급 2: Hooks →](advanced-02-hooks)
{: .btn .btn-primary }
