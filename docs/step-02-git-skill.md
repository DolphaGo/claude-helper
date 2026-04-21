---
layout: default
title: "Step 2: Git Skill"
nav_order: 2
---

# Step 2: 실용적인 Git Skill 만들기
{: .no_toc }

⏱️ 10분
{: .label .label-green }

실제로 쓸 수 있는 Git 상태 확인 skill을 만듭니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

**만들 것:** Git 저장소 상태를 한눈에 보여주는 skill

**기능:**
- 현재 브랜치
- 변경된 파일 수
- Staged/Unstaged 구분
- 다음 행동 추천

---

## 📝 1단계: 기본 Skill 만들기

### 디렉토리 생성

```bash
# 개발 디렉토리에 플러그인 생성
mkdir -p ~/my-plugins/my-first-plugin/skills/gs
```

### SKILL.md 생성

```bash
cat > ~/my-plugins/my-first-plugin/skills/gs/SKILL.md << 'SKILLEOF'
---
description: Git 상태를 확인합니다
---

Git 저장소의 현재 상태를 보여주세요.

브랜치를 확인하세요.
변경된 파일을 확인하세요.
SKILLEOF
```

### 테스트

```bash
# Claude 실행 시 플러그인 디렉토리 지정
claude --plugin-dir ~/my-plugins/my-first-plugin

# Skill 호출
/my-first-plugin:gs
```

Claude가 자동으로 `git branch --show-current`와 `git status` 명령어를 실행합니다.

---

## 🎨 2단계: 출력 형식 지정

Claude가 출력 형식을 알 수 있도록 지침을 추가합니다.

```bash
cat > ~/my-plugins/my-first-plugin/skills/gs/SKILL.md << 'SKILLEOF'
---
description: Git 상태를 한눈에 보여줍니다
---

Git 저장소의 현재 상태를 확인하고 다음 형식으로 보여주세요:

## 브랜치
현재 브랜치를 보여주세요.

## 변경사항
- Staged 파일 수
- Unstaged 파일 수
- Untracked 파일 수

## 파일 목록
변경된 파일들을 카테고리별로 보여주세요.

## 다음 행동
상태에 따라 권장 행동을 제안하세요.
SKILLEOF
```

### 테스트

```bash
# 변경사항 적용
claude --plugin-dir ~/my-plugins/my-first-plugin

# Skill 호출
/my-first-plugin:gs
```

**예상 결과:**

```
## 브랜치
main

## 변경사항
- Staged: 2개
- Unstaged: 1개
- Untracked: 1개

## 파일 목록
Staged:
- src/app.js
- src/utils.js

Unstaged:
- README.md

Untracked:
- temp.txt

## 다음 행동
2개 파일이 staged 상태입니다. git commit으로 커밋하세요.
```

---

## 🛡️ 3단계: 에러 처리

Git 저장소가 아닌 곳에서 실행하면 에러가 발생합니다. 사전 확인을 추가합니다.

```bash
cat > ~/my-plugins/my-first-plugin/skills/gs/SKILL.md << 'SKILLEOF'
---
description: Git 상태를 확인합니다. Git 저장소에서만 사용하세요.
---

# Git Status Skill

## 1단계: Git 저장소 확인

먼저 현재 디렉토리가 Git 저장소인지 확인하세요.
Git 저장소가 아니면 "Git 저장소가 아닙니다"라고 알려주고 종료하세요.

## 2단계: 브랜치 확인

현재 브랜치를 확인하세요.

## 3단계: 상태 확인

다음 정보를 확인하세요:
- Staged 파일 (커밋 대기 중)
- Unstaged 파일 (수정되었지만 staged 안 됨)
- Untracked 파일 (Git이 추적하지 않는 새 파일)

## 4단계: 결과 정리

다음 형식으로 보여주세요:

브랜치: [브랜치명]

변경사항:
- Staged: X개
- Unstaged: Y개
- Untracked: Z개

파일 목록:
[카테고리별로 파일들]

다음 행동:
[상태에 따른 권장 행동]
SKILLEOF
```

---

## 📚 핵심 정리

### Skill 작성 패턴

1. **사전 확인**: 에러 상황 체크 (Git 저장소인지 확인)
2. **정보 수집**: 필요한 데이터 확인 (브랜치, 변경사항)
3. **결과 정리**: 보기 좋게 포맷팅 (카테고리별 정리)
4. **권장 행동**: 다음 할 일 제시 (commit/add 권장)

### Description 작성 팁

```yaml
---
description: 무엇을 하는지 명확하게. Claude가 언제 사용할지 판단.
---
```

좋은 예:
- "Git 상태를 확인합니다"
- "Git 상태를 한눈에 보여줍니다"

나쁜 예:
- "git" (너무 모호)
- "상태 확인" (무슨 상태?)

### Skill 작성 팁

**좋은 Skill의 특징:**
1. 명확한 단계별 지침
2. 예상 결과/형식 명시
3. 에러 케이스 사전 확인
4. 사용자에게 도움이 되는 정보 제공

---

## 🎉 완료!

실용적인 Git Skill을 만들었습니다!

**이번 Step에서 배운 것:**
- ✅ Claude에게 명령어 실행 지침 작성하는 방법
- ✅ 출력 형식을 명시해서 일관된 결과 얻기
- ✅ 에러 처리를 위한 사전 확인 추가
- ✅ 단계별로 구조화된 지침 작성

**Step 1과의 차이:**
- Step 1: 단순 메시지 출력 ("안녕하세요")
- Step 2: 명령어 실행 + 결과 정리 (Git 상태 확인)

**다음에는:**
Step 3에서는 Claude가 자동으로 실행하지 않고, 사용자만 실행할 수 있는 수동 Skill을 배웁니다.

### 다음 단계

[Step 3: 수동 Skill 만들기 →](step-03-command)
{: .btn .btn-primary }
