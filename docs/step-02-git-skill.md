---
layout: default
title: "Step 2: Git Skill"
nav_order: 4
---

# Step 2: 실용적인 Git Skill 만들기
{: .no_toc }

⏱️ 15분
{: .label .label-green }

실제로 쓸 수 있는 Git 상태 확인 skill을 만듭니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

**만들 것:** Git 저장소의 상태를 한눈에 보여주는 skill

**기능:**
- 현재 브랜치
- 변경된 파일 수
- Staged/Unstaged 구분
- 커밋 필요 여부

---

## 📝 1단계: 기본 파일 만들기

### 실행하기

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/gs.md << 'EOF'
---
name: gs
description: Git 상태 확인 (git status)
aliases: [gitstatus, gstat]
---

# Git Status Skill

Git 저장소의 현재 상태를 보여드립니다.

## 브랜치 확인
```bash
git branch --show-current
```

## 변경사항 확인
```bash
git status --short
```
EOF
````

### 새로운 점

#### aliases 필드

```yaml
---
name: gs
aliases: [gitstatus, gstat]
---
```

**의미:**
- `/gs` 로 실행 가능
- `/gitstatus` 로도 실행 가능
- `/gstat` 로도 실행 가능

**왜 유용한가?**
- 짧은 이름 + 긴 이름 둘 다 지원
- 사용자가 편한 걸로 선택

### 테스트

```bash
# Claude Code 재시작 후

/gs
```

**예상 결과:**

```
## 브랜치 확인
main

## 변경사항 확인
 M src/app.js
?? new-file.txt
```

---

## 🎨 2단계: 결과 포맷팅

단순한 명령어 실행은 누구나 할 수 있습니다.  
**차별점:** 결과를 보기 좋게 만들기!

### 개선된 버전

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/gs.md << 'EOF'
---
name: gs
description: Git 상태 확인 (git status)
aliases: [gitstatus]
---

# Git Status

현재 Git 저장소의 상태를 확인합니다.

## 실행 단계

### 1. 브랜치 확인
```bash
git branch --show-current
```

### 2. 변경사항 요약
```bash
git status --short
```

### 3. Staged 파일
```bash
git diff --cached --name-only
```

### 4. Unstaged 파일
```bash
git diff --name-only
```

## 출력 형식

다음 형식으로 정리해주세요:

```
🌿 브랜치: [브랜치명]

📝 변경사항:
  - Staged: X개
  - Unstaged: Y개
  - Untracked: Z개

📁 파일 목록:
  [파일들]

💡 다음 행동: [추천]
```
EOF
````

### 무엇이 바뀌었나?

1. **단계별 명령어**
   ```markdown
   ### 1. 브랜치 확인
   ### 2. 변경사항 요약
   ```
   Claude가 순서대로 실행

2. **출력 형식 지정**
   ```markdown
   ## 출력 형식
   
   다음 형식으로 정리해주세요:
   ```
   Claude가 이 형식을 따라서 출력

3. **이모지 활용**
   ```
   🌿 🌿 💡
   ```
   시각적으로 구분 쉬움

### 테스트

```
/gs
```

**예상 결과:**

```
🌿 브랜치: main

📝 변경사항:
  - Staged: 2개
  - Unstaged: 1개
  - Untracked: 1개

📁 파일 목록:
  Staged:
    - src/app.js
    - src/utils.js
  Unstaged:
    - README.md
  Untracked:
    - temp.txt

💡 다음 행동: 2개 파일이 staged 상태입니다. git commit으로 커밋하세요.
```

---

## 🛡️ 3단계: 에러 처리

Git 저장소가 아닌 곳에서 실행하면?

```
fatal: not a git repository
```

사용자 경험이 안 좋습니다. 개선해봅시다!

### 개선된 버전

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/gs.md << 'EOF'
---
name: gs
description: Git 상태 확인
aliases: [gitstatus]
---

# Git Status

## 사전 확인

먼저 Git 저장소인지 확인:
```bash
if [ -d ".git" ]; then
  echo "✅ Git 저장소입니다"
else
  echo "❌ Git 저장소가 아닙니다"
  exit 1
fi
```

## Git 저장소인 경우

### 브랜치
```bash
git branch --show-current
```

### 상태
```bash
git status --short
```

### Staged 파일 수
```bash
git diff --cached --name-only | wc -l
```

### Unstaged 파일 수
```bash
git diff --name-only | wc -l
```

### Untracked 파일 수
```bash
git ls-files --others --exclude-standard | wc -l
```

## 출력

위 결과를 바탕으로:

```
🌿 브랜치: [브랜치]

📊 요약:
  Staged: X개
  Unstaged: Y개
  Untracked: Z개

💡 상태:
  [커밋 필요/깔끔함/충돌 있음 등]
```
EOF
````

### 새로운 점

#### 1. 사전 확인

```bash
if [ -d ".git" ]; then
  echo "✅ Git 저장소입니다"
else
  echo "❌ Git 저장소가 아닙니다"
  exit 1
fi
```

**동작:**
- `.git` 폴더 있으면 → 계속 진행
- 없으면 → 에러 메시지 + 종료

#### 2. 개수 세기

```bash
git diff --cached --name-only | wc -l
```

- `git diff --cached --name-only`: 파일 목록
- `| wc -l`: 줄 수 세기 (= 파일 수)

#### 3. Untracked 파일

```bash
git ls-files --others --exclude-standard
```

- `--others`: 추적 안 되는 파일
- `--exclude-standard`: .gitignore 적용

### 테스트

**Git 저장소에서:**
```
/gs

→ 정상 출력
```

**Git 저장소가 아닌 곳에서:**
```
/gs

→ ❌ Git 저장소가 아닙니다
```

---

## ⚡ 4단계: 성능 개선

여러 명령어를 실행하면 느립니다.  
한 번에 모든 정보를 가져와봅시다!

### 최적화 버전

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/gs.md << 'EOF'
---
name: gs
description: Git 상태 빠른 확인
aliases: [gitstatus]
---

# Git Status (Fast)

## Git 저장소 확인
```bash
git rev-parse --git-dir > /dev/null 2>&1 && echo "yes" || echo "no"
```

## 한 번에 모든 정보 가져오기

```bash
# 브랜치
branch=$(git branch --show-current)

# 상태 (한 번만 호출)
status=$(git status --short)

# 개수 세기
staged=$(echo "$status" | grep '^[MADRC]' | wc -l | tr -d ' ')
unstaged=$(echo "$status" | grep '^ [MD]' | wc -l | tr -d ' ')
untracked=$(echo "$status" | grep '^??' | wc -l | tr -d ' ')

# 출력
echo "Branch: $branch"
echo "Staged: $staged"
echo "Unstaged: $unstaged"
echo "Untracked: $untracked"
echo ""
echo "$status"
```

## 결과 포맷팅

위 정보를 보기 좋게 정리:

```
🌿 브랜치: [branch]

📊 변경사항: [총 개수]개
  • Staged: [staged]개 (커밋 대기)
  • Unstaged: [unstaged]개 (수정됨)
  • Untracked: [untracked]개 (새 파일)

📁 파일 목록:
[status 출력]

💡 권장 행동:
[staged > 0 → git commit 추천]
[unstaged > 0 → git add 추천]
[모두 0 → 깔끔한 상태]
```
EOF
````

### 최적화 포인트

#### 1. 한 번의 git status

```bash
# 이전 (3번 호출)
git diff --cached --name-only | wc -l
git diff --name-only | wc -l
git ls-files --others | wc -l

# 최적화 (1번 호출)
status=$(git status --short)
echo "$status" | grep '^[MADRC]' | wc -l  # Staged
echo "$status" | grep '^ [MD]' | wc -l    # Unstaged
echo "$status" | grep '^??' | wc -l       # Untracked
```

#### 2. git status --short 패턴

```
M  file1.js    ← Staged (첫 글자가 대문자)
 M file2.js    ← Unstaged (첫 글자가 공백)
?? file3.js    ← Untracked
A  file4.js    ← Added (Staged)
```

패턴:
- `^[MADRC]`: Staged (Modified, Added, Deleted, Renamed, Copied)
- `^ [MD]`: Unstaged (Modified, Deleted)
- `^??`: Untracked

---

## 🎨 5단계: 추가 기능

### Upstream 비교

```bash
# 현재 브랜치가 upstream과 얼마나 차이나는지
ahead=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
behind=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d ' ')
```

- `ahead`: 로컬에만 있는 커밋 수
- `behind`: 원격에만 있는 커밋 수

### 최종 버전

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/gs.md << 'EOF'
---
name: gs
description: Git 상태 종합 확인
aliases: [gitstatus, gst]
---

# Git Status (Complete)

## 모든 정보 한 번에

```bash
#!/bin/bash

# Git 저장소 확인
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "❌ Git 저장소가 아닙니다"
  exit 1
fi

# 정보 수집
branch=$(git branch --show-current)
status=$(git status --short)
staged=$(echo "$status" | grep '^[MADRC]' | wc -l | tr -d ' ')
unstaged=$(echo "$status" | grep '^ [MD]' | wc -l | tr -d ' ')
untracked=$(echo "$status" | grep '^??' | wc -l | tr -d ' ')

# Upstream 비교
ahead=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
behind=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d ' ')

# 출력
echo "Branch: $branch"
echo "Staged: $staged"
echo "Unstaged: $unstaged"
echo "Untracked: $untracked"
echo "Ahead: $ahead"
echo "Behind: $behind"
echo ""
echo "=== Files ==="
echo "$status"
```

## 결과를 보기 좋게

위 정보를 이 형식으로:

```
🌿 브랜치: [branch]

📊 로컬 변경사항:
  • Staged: [staged]개
  • Unstaged: [unstaged]개
  • Untracked: [untracked]개

🔄 원격 비교:
  • Ahead: [ahead]개 커밋 (push 필요)
  • Behind: [behind]개 커밋 (pull 필요)

📁 파일:
[파일 목록]

💡 권장 행동:
[상태에 따른 추천]
```
EOF
````

---

## 📚 핵심 정리

### Skill 작성 패턴

```markdown
1. 사전 확인 (Git 저장소인지)
2. 정보 수집 (명령어 실행)
3. 결과 포맷팅 (보기 좋게)
4. 권장 행동 (다음 할 일)
```

### 좋은 Skill의 조건

1. **빠름**: 불필요한 명령어 중복 제거
2. **안전함**: 에러 처리
3. **명확함**: 결과가 이해하기 쉬움
4. **유용함**: 다음 행동 제시

---

## ✅ 연습 문제

### 과제: "gc" (Git Commit) Skill

**요구사항:**
- 이름: `gc`
- Staged 파일들을 보여주고
- 커밋 메시지 제안
- Conventional Commits 형식

**힌트:**
```bash
# Staged 파일
git diff --cached --name-only

# 파일 타입 분석
# .js → feat:
# .md → docs:
# test.js → test:
```

<details>
<summary>정답 예시 보기</summary>

```markdown
---
name: gc
description: Git commit 도우미
---

# Git Commit Helper

## Staged 파일 확인
```bash
git diff --cached --name-only
```

## 파일 분석 및 메시지 제안

위 파일들을 보고:
1. 주요 변경 파일 타입 파악
2. Conventional Commits 형식으로 메시지 제안
   - .js, .ts → feat: 또는 fix:
   - .md → docs:
   - test.* → test:
   - package.json → chore:

형식:
```
type: 간단한 설명

- 상세 내용 1
- 상세 내용 2
```
```

</details>

---

## 🎉 완료!

실용적인 Git Skill을 만들었습니다!

**배운 것:**
- ✅ 에러 처리
- ✅ 결과 포맷팅
- ✅ 성능 최적화
- ✅ 실용적인 기능

[Step 3: Command 이해하기 →](step-03-command)
{: .btn .btn-primary }
