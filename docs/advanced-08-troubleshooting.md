---
layout: default
title: "고급 8: Troubleshooting"
nav_order: 20
parent: 고급 개념
---

# 문제 해결하기
{: .no_toc }

⏱️ 15분
{: .label .label-red }

Claude Code 사용 중 발생하는 일반적인 문제와 해결 방법을 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 문제 해결 접근법

문제가 발생하면 다음 순서로 접근하세요:

1. **증상 확인**: 무엇이 작동하지 않는가?
2. **로그 확인**: 에러 메시지는 무엇인가?
3. **격리**: 문제를 최소한으로 재현
4. **해결**: 알려진 해결책 적용
5. **검증**: 문제가 해결되었는지 확인

---

## 🔍 Skill 관련 문제

### Skill이 나타나지 않음

**증상:**
```bash
/my-skill
# 명령어를 찾을 수 없음
```

**원인 1: 잘못된 파일 구조**

```bash
# 올바른 구조
~/.claude/skills/my-skill/SKILL.md
```

**해결:**

```bash
# 디렉토리 생성
mkdir -p ~/.claude/skills/my-skill

# 파일 생성
touch ~/.claude/skills/my-skill/SKILL.md

# 재시작
/reload-plugins
```

**원인 2: 파일명이 소문자**

```bash
# 틀림
~/.claude/skills/my-skill/skill.md

# 맞음
~/.claude/skills/my-skill/SKILL.md
```

**원인 3: 플러그인 네임스페이스 누락**

```bash
# 플러그인 skill은 네임스페이스 필요
/my-plugin:skill-name

# 개인 skill은 직접 호출
/skill-name
```

### Skill이 실행되지 않음

**증상:**
Skill을 호출했는데 아무 일도 일어나지 않음

**원인: disable-model-invocation 설정**

```yaml
---
description: 설명
disable-model-invocation: true
---
```

이 설정이 있으면 사용자가 직접 호출해야만 실행됩니다.

**해결:**

자동 실행이 필요하면:

```yaml
---
description: 설명
# disable-model-invocation 제거
---
```

### Skill 내용이 업데이트되지 않음

**증상:**
SKILL.md를 수정했는데 변경사항이 반영 안 됨

**해결:**

```bash
/reload-plugins
```

또는 Claude Code 재시작:

```bash
# Ctrl+D 후
claude
```

---

## 🔌 플러그인 관련 문제

### 플러그인이 로드되지 않음

**증상:**
```bash
/plugin-name:skill
# 플러그인을 찾을 수 없음
```

**원인 1: plugin.json 위치**

```bash
# 틀림
~/.claude/plugins/my-plugin/plugin.json

# 맞음
~/.claude/plugins/my-plugin/.claude-plugin/plugin.json
```

**해결:**

```bash
mkdir -p ~/.claude/plugins/my-plugin/.claude-plugin
mv ~/.claude/plugins/my-plugin/plugin.json \
   ~/.claude/plugins/my-plugin/.claude-plugin/plugin.json
```

**원인 2: plugin.json 형식 오류**

```bash
# 파일 검증
cat ~/.claude/plugins/my-plugin/.claude-plugin/plugin.json
```

필수 필드 확인:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "플러그인 설명"
}
```

**원인 3: 잘못된 디렉토리 위치**

```bash
# 맞는 위치
~/.claude/plugins/my-plugin/

# 틀린 위치
~/my-plugin/
~/Documents/my-plugin/
```

### 플러그인 목록 확인

```bash
claude plugin list
```

또는 Claude Code 내에서:

```bash
# 사용 가능한 skills 확인
/help skills
```

---

## 🔐 환경 변수 문제

### 환경 변수가 인식되지 않음

**증상:**
```bash
echo $MY_TOKEN
# 아무것도 출력되지 않음
```

**원인 1: 설정 파일에 추가 안 됨**

**해결:**

```bash
# bash 사용자
echo 'export MY_TOKEN="value"' >> ~/.bashrc
source ~/.bashrc

# zsh 사용자
echo 'export MY_TOKEN="value"' >> ~/.zshrc
source ~/.zshrc
```

**원인 2: 새 터미널에서만 적용**

환경 변수를 추가한 후:
- 기존 터미널: `source ~/.bashrc` 실행 필요
- 새 터미널: 자동 적용

**원인 3: 따옴표 누락**

```bash
# 틀림
export MY_TOKEN=value with spaces

# 맞음
export MY_TOKEN="value with spaces"
```

### Claude Code에서 환경 변수 사용

**확인:**

```bash
# Claude Code 내에서
Bash 도구로 $MY_TOKEN 값을 확인해줘
```

**문제가 있으면:**

1. 터미널에서 확인:

```bash
echo $MY_TOKEN
```

2. Claude Code 재시작:

```bash
# Ctrl+D 후
claude
```

---

## 🛠️ MCP 서버 문제

### MCP 서버가 연결되지 않음

**증상:**
```bash
/mcp
# 서버가 목록에 없음
```

또는:

```bash
claude mcp list
# 서버가 목록에 없음
```

**원인 1: 설정 파일 위치**

```bash
# 맞는 위치 (전역)
~/.claude.json

# 또는 프로젝트별
.mcp.json
```

**해결:**

```bash
cat > ~/.claude.json << 'EOF'
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"]
    }
  }
}
EOF
```

**원인 2: JSON 형식 오류**

**검증:**

```bash
# JSON 검증
cat ~/.claude.json | jq .
```

오류가 있으면 수정하세요.

**원인 3: 서버가 설치되지 않음**

```bash
# 서버 수동 설치 테스트
npx -y @modelcontextprotocol/server-filesystem
```

### MCP 서버가 작동하지 않음

**디버깅:**

```bash
# 상세 로그 활성화
claude --debug
```

로그에서 MCP 관련 에러 확인

**일반적인 해결:**

```bash
# NPM 캐시 정리
npm cache clean --force

# Node.js 버전 확인 (16.0 이상 필요)
node --version
```

---

## 🚀 성능 문제

### Claude Code가 느림

**원인 1: 너무 큰 파일 읽기**

**해결:**
- 필요한 부분만 읽기
- 파일을 작게 분할

**원인 2: 너무 많은 파일 검색**

**개선:**

```bash
# 나쁜 예
모든 파일에서 "TODO"를 찾아줘

# 좋은 예
src/ 디렉토리의 .ts 파일에서만 "TODO"를 찾아줘
```

**원인 3: 긴 컨텍스트**

대화가 길어지면 느려집니다.

**해결:**
- 새 대화 시작
- `/clear` 명령어로 컨텍스트 정리

### 메모리 사용량 증가

**원인: 여러 Sub-agents 또는 Teams 실행**

**해결:**
- 필요한 만큼만 사용
- 완료된 agents 정리

---

## 🔍 디버깅 도구

### 로그 확인

**위치:**

```bash
# macOS/Linux
~/.local/share/claude/logs/

# Windows
%APPDATA%\Claude\logs\
```

**실시간 확인:**

```bash
tail -f ~/.local/share/claude/logs/claude-*.log
```

### 상세 로그 활성화

```bash
claude --debug
```

### 문제 재현

최소한의 예제로 문제를 재현하세요:

```bash
# 복잡한 프로젝트 대신
# 새 디렉토리에서 테스트
mkdir /tmp/test-claude
cd /tmp/test-claude
claude
```

---

## 📋 체크리스트

문제 발생 시 이 체크리스트를 따르세요:

### Skill 문제

- [ ] 디렉토리 구조 확인: `skills/<name>/SKILL.md`
- [ ] 파일명 확인: 대문자 `SKILL.md`
- [ ] 네임스페이스 확인: 플러그인이면 `/plugin:skill`
- [ ] `/reload-plugins` 실행
- [ ] Claude Code 재시작

### 환경 변수 문제

- [ ] 설정 파일에 추가: `~/.bashrc` 또는 `~/.zshrc`
- [ ] `source` 명령어 실행
- [ ] 터미널에서 확인: `echo $VAR_NAME`
- [ ] Claude Code 재시작

### MCP 문제

- [ ] 설정 파일 위치: `~/.claude.json` 또는 `.mcp.json`
- [ ] JSON 형식 검증
- [ ] 서버 설치 확인
- [ ] Claude Code 재시작

### 성능 문제

- [ ] 파일 크기 확인
- [ ] 검색 범위 좁히기
- [ ] 컨텍스트 정리: `/clear`
- [ ] 새 대화 시작

---

## 🆘 추가 도움

### 공식 문서

- [Claude Code 문서](https://code.claude.com/docs)
- [Skills 가이드](https://code.claude.com/docs/ko/skills)
- [Plugins 가이드](https://code.claude.com/docs/ko/plugins)

### 커뮤니티

- [GitHub Issues](https://github.com/anthropics/claude-code/issues)
- [Discord](https://discord.gg/anthropic)

### 버그 리포트

문제를 발견하면:

1. 로그 수집:

```bash
tail -100 ~/.local/share/claude/logs/claude-*.log > error-log.txt
```

2. 최소 재현 예제 작성

3. GitHub Issues에 리포트

---

## ✅ 완료

Claude Code 사용 중 발생하는 문제들을 해결하는 방법을 배웠습니다!

**배운 것:**
- ✅ Skill 관련 문제 해결
- ✅ 플러그인 문제 해결
- ✅ 환경 변수 문제 해결
- ✅ MCP 서버 문제 해결
- ✅ 성능 문제 해결
- ✅ 디버깅 도구 사용

**핵심 개념:**
- 체계적인 문제 해결 접근법
- 로그 확인의 중요성
- 최소 재현으로 문제 격리
- 공식 문서와 커뮤니티 활용

**고급 개념 학습 완료!**
이제 Claude Code의 고급 기능들을 활용할 수 있습니다.

### 처음으로 돌아가기

[홈으로 →](../)
{: .btn .btn-primary }
