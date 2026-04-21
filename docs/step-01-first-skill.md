---
layout: default
title: "Step 1: 첫 번째 Skill"
nav_order: 3
---

# Step 1: 첫 번째 Skill 만들기
{: .no_toc }

⏱️ 10분
{: .label .label-green }

가장 간단한 skill을 직접 만들어봅니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

이 Step을 완료하면:
- ✅ Skill 파일을 직접 만들 수 있습니다
- ✅ plugin.json을 작성할 수 있습니다
- ✅ Claude Code에서 실행할 수 있습니다
- ✅ 올바른 디렉토리 구조를 이해합니다

---

## 📂 1단계: 플러그인 디렉토리 만들기

터미널을 열고 다음 명령어를 실행하세요:

```bash
mkdir -p ~/.claude/plugins/my-first-plugin/.claude-plugin
```

이렇게 생성됩니다:

```
~/.claude/plugins/
└── my-first-plugin/
    └── .claude-plugin/
```

Claude Code는 `~/.claude/plugins/` 디렉토리를 스캔해서 플러그인을 찾습니다.

{: .note }
> **개념 이해:** Skills가 있는 위치에 따라 범위가 달라집니다. 자세한 내용은 [핵심 개념 - Skills가 있는 위치](concepts#skills가-있는-위치)를 참고하세요.

---

## 📋 2단계: plugin.json 만들기

다음 명령어를 실행하세요:

```bash
cat > ~/.claude/plugins/my-first-plugin/.claude-plugin/plugin.json << 'EOF'
{
  "name": "my-first-plugin",
  "version": "1.0.0",
  "description": "내 첫 번째 플러그인"
}
EOF
```

최종 구조:

```
~/.claude/plugins/my-first-plugin/
└── .claude-plugin/
    └── plugin.json
```

**필수 필드:**
- `name`: 플러그인 이름 (필수)
- `version`: 버전 (필수)
- `description`: 설명 (필수)

**선택 필드:**
- `author`: 작성자 정보
- `repository`: Git 저장소 URL
- `license`: 라이선스

---

## 📝 3단계: Skill 디렉토리 생성

**중요:** Skill은 디렉토리 안에 SKILL.md 파일을 만들어야 합니다.

```bash
mkdir -p ~/.claude/plugins/my-first-plugin/skills/hello
```

디렉토리 이름(`hello`)이 skill 이름이 됩니다.

---

## ✍️ 4단계: SKILL.md 파일 생성

**대문자 SKILL.md** 파일을 생성합니다:

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/hello/SKILL.md << 'SKILLEOF'
---
description: 가장 간단한 인사 skill
---

안녕하세요! 첫 번째 skill입니다.
SKILLEOF
```

최종 구조:

```
~/.claude/plugins/my-first-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── hello/
        └── SKILL.md
```

**핵심 포인트:**
1. 디렉토리 이름 = Skill 이름 (`name` 필드를 생략할 경우)
2. 파일명은 반드시 대문자 `SKILL.md`
3. Frontmatter는 모두 선택사항이지만 `description` 권장

{: .note }
> **Frontmatter 이해:** 공식 문서에 따르면 모든 frontmatter 필드가 선택사항입니다. `name`을 생략하면 디렉토리 이름을 사용합니다. 자세한 내용은 [핵심 개념 - Frontmatter 필드](concepts#frontmatter-필드)를 참고하세요.

---

## 🚀 5단계: 실행

### 재시작

```bash
# Ctrl+D 로 종료 후
claude
```

### Skill 호출

플러그인 skill은 네임스페이스가 붙습니다:

```
/my-first-plugin:hello
```

**결과:**

```
안녕하세요! 첫 번째 skill입니다.
```

---

## 🔧 6단계: 기존 Skill 수정하기

한번 만든 Skill을 수정해봅시다.

### 메시지 변경

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/hello/SKILL.md << 'SKILLEOF'
---
description: 친근한 인사를 합니다
---

안녕하세요! Claude Code 플러그인 튜토리얼에 오신 것을 환영합니다.

첫 번째 Skill을 성공적으로 만들었습니다!
SKILLEOF
```

### 변경 사항 적용

```bash
/reload-plugins
```

또는 Claude Code를 재시작하세요.

### 실행

```
/my-first-plugin:hello
```

**포인트:** Skill을 수정한 후에는 `/reload-plugins` 명령어로 다시 로드해야 합니다.

---

## 📚 핵심 정리

### 필수 구조

```
~/.claude/plugins/my-first-plugin/
├── .claude-plugin/
│   └── plugin.json         ← 플러그인 메타데이터
└── skills/
    └── hello/              ← Skill 이름 (디렉토리)
        └── SKILL.md        ← 대문자 필수
```

### SKILL.md 형식

```
---
description: Skill 설명
---

Skill 지침...
```

### 네임스페이스

- 플러그인 skill: `/플러그인이름:skill이름`
- 개인 skill (`~/.claude/skills/`): `/skill이름`

---

## 💡 자주 하는 실수

### ❌ 파일명이 소문자

```
skills/hello/skill.md    ← 틀림
skills/hello/SKILL.md    ← 맞음
```

### ❌ 디렉토리 없이 파일만

```
skills/hello.md          ← 틀림
skills/hello/SKILL.md    ← 맞음
```

### ❌ plugin.json 위치

```
my-first-plugin/plugin.json              ← 틀림
my-first-plugin/.claude-plugin/plugin.json  ← 맞음
```

### ❌ 네임스페이스 누락

```
/hello                        ← 플러그인에서는 안 됨
/my-first-plugin:hello        ← 맞음
```

---

## 🎓 개인 vs 플러그인

### 개인 Skill

위치: `~/.claude/skills/hello/SKILL.md`
호출: `/hello`

**장점:** 짧은 명령어
**단점:** 공유 어려움

### 플러그인 Skill

위치: `~/.claude/plugins/my-plugin/skills/hello/SKILL.md`
호출: `/my-plugin:hello`

**장점:** 팀 공유, 버전 관리, 마켓플레이스 배포
**단점:** 명령어가 김

---

## ✅ 완료

첫 번째 Skill을 만들고 실행했습니다!

**이번 Step에서 배운 것:**
- ✅ `skills/<name>/SKILL.md` 구조 (디렉토리 + 대문자 파일)
- ✅ `.claude-plugin/plugin.json` 위치와 필수 필드
- ✅ 네임스페이스 이해 (`/플러그인:skill` vs `/skill`)
- ✅ `/reload-plugins` 사용법
- ✅ Skill 수정 방법

**핵심 개념:**
- Skill은 Claude에게 주는 **지침**
- 디렉토리 이름이 Skill 이름
- Frontmatter의 `description`이 중요

**다음에는:**
Step 2에서는 단순 메시지가 아닌 **명령어를 실행**하는 Skill을 만들어봅니다.

### 다음 단계

[Step 2: Git Skill 만들기 →](step-02-git-skill)
{: .btn .btn-primary }
