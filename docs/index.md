---
layout: home
title: 홈
nav_order: 1
---

# Claude Code 플러그인 만들기
{: .fs-9 }

**"이 파일은 왜 만드는 거지?"**  
**"이 코드는 어떻게 동작하는 거지?"**
{: .fs-6 .fw-300 }

이런 의문이 들지 않도록, 파일 하나하나 만들면서 내부 동작까지 이해합니다.
{: .fs-5 .fw-300 }

[지금 바로 시작하기 →](step-00-before-start){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 }

---

## 🎯 이 가이드의 특징

### 1. 실습 중심
이론 설명 ❌  
직접 따라하기 ✅

```bash
# 이렇게 명령어 하나하나 실행하면서
mkdir -p ~/.claude/plugins/my-first

# 파일 하나하나 만들면서
cat > skills/hello.md

# 실제로 동작 확인
/hello
```

### 2. 내부 원리 설명
- 왜 이 파일명이어야 하는가?
- 왜 이 위치에 만들어야 하는가?
- Claude Code가 내부적으로 어떻게 읽는가?
- 각 줄이 무슨 역할을 하는가?

### 3. 실용적인 예제
- Git 상태 확인
- Jira 티켓 생성
- 코드 패턴 검색
- 자주 쓰는 작업 자동화

---

## 📚 학습 단계

### Step 0: 시작하기 전에 (5분)
Claude Code와 플러그인 시스템을 이해합니다.
{: .text-grey-dk-000}

[Step 0 시작 →](step-00-before-start)
{: .btn .btn-outline }

---

### Step 1: 첫 번째 Skill 만들기 (10분)
3줄로 동작하는 가장 간단한 skill을 만듭니다.
{: .text-green-200}

**배울 것:**
- 파일 위치와 이름
- 최소 구조
- 등록과 실행
- 내부 동작

[Step 1 시작 →](step-01-first-skill)
{: .btn .btn-green }

---

### Step 2: 실용적인 Git Skill (15분)
실제로 쓸 수 있는 Git 상태 확인 skill을 만듭니다.
{: .text-green-200}

**배울 것:**
- Bash 명령 실행
- 결과 포맷팅
- 에러 처리

[Step 2 시작 →](step-02-git-skill)
{: .btn .btn-green }

---

### Step 3: Command 이해하기 (10분)
Skill과 Command의 차이를 배우고 command를 만듭니다.
{: .text-blue-200}

**배울 것:**
- Skill vs Command
- 언제 뭘 쓰는가
- Command 만들기

[Step 3 시작 →](step-03-command)
{: .btn .btn-blue }

---

### Step 4: Jira 티켓 생성 (20분)
실전 예제: API를 호출하는 복잡한 skill
{: .text-blue-200}

**배울 것:**
- 외부 API 호출
- 인증 처리
- 복잡한 로직

[Step 4 시작 →](step-04-jira-skill)
{: .btn .btn-blue }

---

### Step 5: 코드 검색 도구 (15분)
실전 예제: 프로젝트에서 패턴 찾기
{: .text-purple-200}

**배울 것:**
- Grep 활용
- 결과 파싱
- 한글 처리

[Step 5 시작 →](step-05-search-tool)
{: .btn .btn-purple }

---

### Step 6: 플러그인 배포 (10분)
만든 플러그인을 공유하고 설치하는 방법
{: .text-purple-200}

**배울 것:**
- Git 저장소 구성
- npm 배포
- 팀 공유

[Step 6 시작 →](step-06-publish)
{: .btn .btn-purple }

---

## 🚀 바로 시작하기

### 사전 준비

✅ **Claude Code 설치**
```bash
# CLI, Desktop, 또는 Web 중 하나
```

✅ **터미널 실행**
```bash
# macOS: Terminal 또는 iTerm
# Windows: PowerShell
```

✅ **텍스트 에디터**
```bash
# VSCode, Vim, 뭐든 좋습니다
```

### 첫 단계로

준비됐다면 바로 시작하세요!

[Step 0: 시작하기 전에 →](step-00-before-start)
{: .btn .btn-primary .fs-5 }

---

## 💡 이런 분들께 추천

- ✅ Claude Code를 쓰고는 있지만 잘 모르겠는 분
- ✅ Skill/Command를 만들고 싶은데 어떻게 시작해야 할지 모르는 분
- ✅ 예제를 보면 이해는 가는데 내가 만들려니 막막한 분
- ✅ 내부 동작 원리를 제대로 이해하고 싶은 분
- ✅ 실전에서 바로 쓸 수 있는 것을 만들고 싶은 분

---

## 📖 학습 시간

**전체:** 약 1시간 30분  
**Step별:** 5분 ~ 20분

각 Step은 독립적이므로:
- 처음부터 순서대로 ✅
- 필요한 것만 골라서 ✅
- 언제든 돌아와서 복습 ✅

---

시작할 준비가 되셨나요?

[Step 0 시작하기 →](step-00-before-start)
{: .btn .btn-primary .btn-lg }
