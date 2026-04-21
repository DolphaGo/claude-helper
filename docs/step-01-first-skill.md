---
layout: default
title: "Step 1: 첫 번째 Skill"
nav_order: 3
---

# Step 1: 첫 번째 Skill 만들기
{: .no_toc }

⏱️ 15분
{: .label .label-green }

가장 간단한 개인 skill을 직접 만들어봅니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

이 Step을 완료하면:
- ✅ 개인 Skill을 직접 만들 수 있습니다
- ✅ SKILL.md 파일을 작성할 수 있습니다
- ✅ Claude Code에서 바로 실행할 수 있습니다
- ✅ 올바른 디렉토리 구조를 이해합니다

---

## 📂 1단계: Skill 디렉토리 만들기

터미널을 열고 다음 명령어를 실행하세요:

```bash
mkdir -p ~/.claude/skills/hello
```

이렇게 생성됩니다:

```
~/.claude/skills/
└── hello/
```

Claude Code는 `~/.claude/skills/` 디렉토리를 자동으로 스캔해서 skill을 찾습니다.

{: .note }
> **개념 이해:** 디렉토리 이름(`hello`)이 skill 이름이 됩니다. `/hello`로 바로 호출할 수 있습니다.

---

## ✍️ 2단계: SKILL.md 파일 생성

**대문자 SKILL.md** 파일을 생성합니다:

```bash
cat > ~/.claude/skills/hello/SKILL.md << 'SKILLEOF'
---
description: 가장 간단한 인사 skill
---

안녕하세요! 첫 번째 skill입니다.
SKILLEOF
```

최종 구조:

```
~/.claude/skills/
└── hello/
    └── SKILL.md
```

**핵심 포인트:**
1. 디렉토리 이름 = Skill 이름 (`hello`)
2. 파일명은 반드시 대문자 `SKILL.md`
3. Frontmatter의 `description` 필드는 선택사항이지만 권장
4. `---` 아래의 내용이 Claude에게 전달되는 지침입니다

{: .note }
> **Frontmatter 이해:** 모든 frontmatter 필드는 선택사항입니다. `name`을 생략하면 디렉토리 이름을 사용합니다. 자세한 내용은 [핵심 개념 - Frontmatter 필드](concepts#frontmatter-필드)를 참고하세요.

---

## 🚀 3단계: 실행

### 재시작 불필요

개인 skill은 재시작 없이 자동으로 인식됩니다. Claude Code를 이미 실행 중이라면 그대로 사용하세요.

### Skill 호출

간단하게 바로 호출할 수 있습니다:

```
/hello
```

**결과:**

```
안녕하세요! 첫 번째 skill입니다.
```

---

## 🔧 4단계: 기존 Skill 수정하기

한번 만든 Skill을 수정해봅시다.

### 메시지 변경

```bash
cat > ~/.claude/skills/hello/SKILL.md << 'SKILLEOF'
---
description: 친근한 인사를 합니다
---

안녕하세요! Claude Code 튜토리얼에 오신 것을 환영합니다.

첫 번째 Skill을 성공적으로 만들었습니다!
SKILLEOF
```

### 변경사항 적용

```
/reload-plugins
```

이 명령어는 skills, agents, hooks를 다시 로드합니다. 재시작할 필요가 없습니다.

### 실행

```
/hello
```

**결과:**

```
안녕하세요! Claude Code 튜토리얼에 오신 것을 환영합니다.

첫 번째 Skill을 성공적으로 만들었습니다!
```

**포인트:** Skill을 수정한 후에는 `/reload-plugins` 명령어로 다시 로드해야 합니다.

---

## 📚 핵심 정리

### 필수 구조

```
~/.claude/skills/
└── hello/              ← Skill 이름 (디렉토리)
    └── SKILL.md        ← 대문자 필수
```

### SKILL.md 형식

```markdown
---
description: Skill 설명
---

Skill 지침...
```

### 호출 방법

```
/hello
```

간단하게 슬래시(`/`) + skill 이름으로 호출합니다.

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

### ❌ 잘못된 위치

```
~/.claude/plugins/hello/SKILL.md    ← 플러그인 위치
~/.claude/skills/hello/SKILL.md     ← 개인 skill 위치 (맞음)
```

---

## 🎓 개인 Skill의 장점

### 간편한 호출

```
/hello
```

네임스페이스 없이 바로 호출할 수 있습니다.

### 빠른 프로토타이핑

- 파일 하나만 만들면 됩니다
- 복잡한 설정이 필요 없습니다
- 재시작 없이 자동 인식됩니다

### 개인 맞춤형

- 자주 사용하는 명령어를 skill로 저장
- 개인 작업 환경에 최적화
- 빠른 수정과 실험 가능

---

## 🔄 개인 Skill vs 플러그인

### 개인 Skill (지금 배운 것)

- **위치:** `~/.claude/skills/hello/SKILL.md`
- **호출:** `/hello`
- **장점:** 간단, 빠른 개발, 짧은 명령어
- **단점:** 개인용, 공유 어려움

### 플러그인 Skill (다음 단계)

- **위치:** `~/.claude/plugins/my-plugin/skills/hello/SKILL.md`
- **호출:** `/my-plugin:hello`
- **장점:** 팀 공유, 버전 관리, 배포 가능
- **단점:** 명령어가 김, 설정 필요

{: .note }
> **다음 단계:** 팀과 공유하거나 버전 관리가 필요하면 플러그인으로 만들 수 있습니다. 하지만 개인용으로는 지금 배운 방식이 가장 편리합니다.

---

## ✅ 완료

첫 번째 개인 Skill을 만들고 실행했습니다!

**이번 Step에서 배운 것:**
- ✅ `~/.claude/skills/<name>/SKILL.md` 구조 (디렉토리 + 대문자 파일)
- ✅ Frontmatter의 `description` 필드
- ✅ `/skill이름`으로 간단하게 호출
- ✅ `/reload-plugins`로 변경사항 적용
- ✅ Skill 수정 방법

**핵심 개념:**
- Skill은 Claude에게 주는 **지침**
- 디렉토리 이름이 Skill 이름
- 재시작 없이 자동 인식
- 간단하고 빠른 개발

**다음에는:**
Step 2에서는 단순 메시지가 아닌 **명령어를 실행**하는 Skill을 만들어봅니다.

### 다음 단계

[Step 2: Git Skill 만들기 →](step-02-git-skill)
{: .btn .btn-primary }
