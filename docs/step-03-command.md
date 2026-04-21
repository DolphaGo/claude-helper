---
layout: default
title: "Step 3: 수동 Skill"
nav_order: 5
---

# Step 3: 수동으로 실행하는 Skill 만들기
{: .no_toc }

⏱️ 10분
{: .label .label-blue }

Claude가 자동으로 호출하지 않고, 사용자만 실행할 수 있는 skill을 만듭니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🤔 자동 vs 수동 Skill

### 자동 Skill

```yaml
---
description: Git 상태를 확인합니다
---
```

Claude가 "Git 상태 확인해줘"라고 하면 **자동으로** 이 skill을 실행합니다.

### 수동 Skill

```yaml
---
description: 배포를 실행합니다
disable-model-invocation: true
---
```

**사용자만** `/deploy` 명령어로 실행할 수 있습니다.
Claude는 이 skill을 자동으로 호출할 수 없습니다.

---

## 🎯 왜 수동 Skill이 필요한가?

### 위험한 작업

```
/deploy      - 프로덕션 배포
/delete-db   - 데이터베이스 삭제
/send-email  - 이메일 발송
```

Claude가 마음대로 실행하면 안 되는 작업들입니다.

### 타이밍이 중요한 작업

```
/commit      - Git commit (사용자가 원할 때)
/push        - Git push (확인 후)
/release     - 릴리스 생성 (준비됐을 때)
```

사용자가 타이밍을 제어해야 하는 작업들입니다.

---

## 📝 1단계: 수동 Commit Skill 만들기

### 디렉토리 생성

```bash
mkdir -p ~/.claude/plugins/my-first-plugin/skills/commit
```

### SKILL.md 생성

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/commit/SKILL.md << 'SKILLEOF'
---
description: Git commit을 생성합니다
disable-model-invocation: true
---

# Commit Skill

다음 단계를 실행하세요:

## 1. Staged 파일 확인
git diff --cached --name-only로 커밋할 파일들을 확인하세요.

## 2. 변경 내용 분석
각 파일의 변경 내용을 분석하세요.

## 3. 커밋 메시지 생성
Conventional Commits 형식으로 메시지를 생성하세요:
- feat: 새 기능
- fix: 버그 수정
- docs: 문서 수정
- chore: 기타 작업

## 4. 커밋 실행
git commit -m "메시지"를 실행하세요.

## 5. 결과 확인
커밋이 생성되었는지 확인하세요.
SKILLEOF
```

**핵심:** `disable-model-invocation: true`

---

## 🚀 2단계: 테스트

### 파일 수정 및 Stage

```bash
echo "test" > test.txt
git add test.txt
```

### Skill 실행

```bash
/reload-plugins
/my-first-plugin:commit
```

Claude가:
1. Staged 파일 확인
2. 변경 내용 분석
3. 커밋 메시지 생성
4. 커밋 실행

---

## ⚡ 3단계: 빠른 Commit Skill

더 빠른 버전을 만들어봅시다.

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/qc/SKILL.md << 'SKILLEOF'
---
description: 빠른 Git commit
disable-model-invocation: true
---

# Quick Commit

모든 변경사항을 자동으로 commit하세요.

## 1. 모든 변경사항 Stage
git add -A를 실행하세요.

## 2. 간단한 메시지 생성
변경된 파일을 보고 짧은 커밋 메시지를 만드세요.

## 3. Commit
git commit -m "메시지"를 실행하세요.

## 4. 결과
커밋 해시와 메시지를 보여주세요.
SKILLEOF
```

**디렉토리를 먼저 만들어야 합니다:**

```bash
mkdir -p ~/.claude/plugins/my-first-plugin/skills/qc
```

---

## 🎨 4단계: 인수 받는 Skill

사용자가 커밋 메시지를 직접 지정할 수 있게 합니다.

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/qc/SKILL.md << 'SKILLEOF'
---
description: 빠른 Git commit (메시지 지정 가능)
disable-model-invocation: true
argument-hint: [commit message]
---

# Quick Commit

사용자가 메시지를 제공했는지 확인하세요.

## 메시지 제공됨
사용자가 제공한 메시지를 사용하세요.

1. git add -A
2. git commit -m "사용자 메시지"
3. 결과 표시

## 메시지 없음
자동으로 생성하세요.

1. 변경된 파일 확인
2. 적절한 메시지 생성
3. git add -A
4. git commit -m "생성된 메시지"
5. 결과 표시
SKILLEOF
```

**사용법:**

```
/my-first-plugin:qc              ← 자동 메시지
/my-first-plugin:qc fix: 버그 수정  ← 지정 메시지
```

---

## 📚 핵심 정리

### disable-model-invocation: true

```yaml
---
description: ...
disable-model-invocation: true
---
```

**효과:**
- Claude가 자동으로 호출 불가
- 사용자만 `/skill-name`으로 실행 가능
- 위험한 작업에 필수

### argument-hint

```yaml
---
description: ...
argument-hint: [message]
---
```

**효과:**
- 자동완성에 힌트 표시
- 사용자가 무엇을 입력할지 알 수 있음

---

## 🎓 개인 Skill로 만들기

플러그인 대신 개인 skill로 만들면 더 짧게 사용할 수 있습니다.

```bash
mkdir -p ~/.claude/skills/qc
cat > ~/.claude/skills/qc/SKILL.md << 'SKILLEOF'
---
description: 빠른 커밋
disable-model-invocation: true
---

모든 변경사항을 add하고 커밋하세요.
간단한 메시지를 자동 생성하세요.
SKILLEOF
```

**사용:**

```
/qc
```

짧고 빠름!

---

## 🛡️ 안전한 Skill 만들기

### 확인 단계 추가

```yaml
---
description: 프로덕션 배포
disable-model-invocation: true
---

# Deploy to Production

## 1. 현재 브랜치 확인
main 브랜치가 아니면 경고하고 중단하세요.

## 2. 테스트 실행
모든 테스트가 통과하는지 확인하세요.

## 3. 사용자 확인 요청
"프로덕션에 배포하시겠습니까?"라고 물어보세요.

## 4. 배포 실행
확인 후 배포 스크립트를 실행하세요.

## 5. 결과 확인
배포가 성공했는지 확인하세요.
```

---

## ✅ 연습 문제

### 과제: "push" Skill

**요구사항:**
- 수동 실행만 가능
- 현재 브랜치를 upstream에 push
- Push 전 커밋 개수 확인
- 결과 표시

**힌트:**
```bash
# Upstream과 비교
git rev-list @{u}..HEAD --count

# Push
git push
```

<details>
<summary>정답 보기</summary>

```bash
mkdir -p ~/.claude/skills/push
cat > ~/.claude/skills/push/SKILL.md << 'SKILLEOF'
---
description: 현재 브랜치를 push합니다
disable-model-invocation: true
---

# Push Skill

## 1. 브랜치 확인
현재 브랜치를 확인하세요.

## 2. Upstream과 비교
로컬에만 있는 커밋 개수를 확인하세요.

## 3. Push 실행
git push를 실행하세요.

## 4. 결과
Push된 커밋 개수와 브랜치를 표시하세요.
SKILLEOF
```

</details>

---

## 🎉 완료!

수동으로 실행하는 Skill을 만들었습니다!

**배운 것:**
- ✅ `disable-model-invocation: true` 사용
- ✅ `argument-hint` 사용
- ✅ 안전한 Skill 설계
- ✅ 개인 Skill 만들기

### 다음 단계

[Step 4: Jira Skill 만들기 →](step-04-jira-skill)
{: .btn .btn-primary }
