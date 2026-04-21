---
layout: default
title: "Step 3: Command 이해"
nav_order: 5
---

# Step 3: Command 이해하기
{: .no_toc }

⏱️ 10분
{: .label .label-blue }

Skill과 Command의 차이를 이해하고 command를 만들어봅니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🤔 Skill vs Command

### 실제 사용 예시로 이해하기

#### Skill (복잡한 작업)

```
You: /code-review

Claude:
1. git diff로 변경사항 확인 중...
2. 각 파일 분석 중...
3. 보안 취약점 체크 중...
4. 성능 이슈 확인 중...
5. 리포트 작성 중...

[10초 후]

📋 코드 리뷰 결과
- 파일: 5개 수정
- 이슈: 3건 발견
  🔴 Critical: SQL 인젝션 취약점
  🟡 Warning: 메모리 누수 가능성
  ...
```

#### Command (빠른 작업)

```
You: /gs

[1초 후]

🌿 브랜치: main
📊 Staged: 2개, Unstaged: 1개
```

### 차이점 표

| 구분 | Skill | Command |
|:-----|:------|:--------|
| **속도** | 느림 (수초~수분) | 빠름 (1-2초) |
| **복잡도** | 높음 | 낮음 |
| **단계** | 여러 단계 | 단일 작업 |
| **출력** | 상세한 리포트 | 간단한 결과 |
| **예시** | 코드 리뷰, 분석 | Git 상태, 빠른 커밋 |

### 언제 뭘 쓰나?

**Command를 쓸 때:**
- ✅ 자주 쓰는 명령어 축약
- ✅ 빠른 확인 필요
- ✅ 단순한 정보 조회

**Skill을 쓸 때:**
- ✅ 복잡한 분석 필요
- ✅ 여러 도구 조합
- ✅ 의사결정 로직 필요

---

## 📂 Command 만들기

### 디렉토리 만들기

```bash
mkdir -p ~/.claude/plugins/my-first-plugin/commands
```

**구조:**
```
~/.claude/plugins/my-first-plugin/
├── plugin.json
├── skills/
│   ├── hello.md
│   └── gs.md
└── commands/          ← 새로 만든 폴더
```

### plugin.json 업데이트

Command를 인식하도록 설정 추가:

```bash
cat > ~/.claude/plugins/my-first-plugin/plugin.json << 'EOF'
{
  "name": "my-first-plugin",
  "version": "1.0.0",
  "description": "내 첫 번째 플러그인",
  "skills": {
    "path": "skills/**/*.md"
  },
  "commands": {
    "path": "commands/**/*.md"
  }
}
EOF
```

**추가된 부분:**
```json
"commands": {
  "path": "commands/**/*.md"
}
```

---

## 📝 간단한 Command 만들기

### 예제: 빠른 푸시 (qp)

**목적:** `git push origin main`을 `/qp`로 축약

```bash
cat > ~/.claude/plugins/my-first-plugin/commands/qp.md << 'EOF'
---
name: qp
description: Quick Push (git push origin main)
aliases: [quickpush, push]
---

# Quick Push Command

현재 브랜치를 origin으로 푸시합니다.

## 실행

```bash
# 현재 브랜치 확인
branch=$(git branch --show-current)

# 푸시
git push origin "$branch"
```

## 결과

성공하면:
```
✅ Pushed to origin/[브랜치]
```

실패하면 에러 메시지 표시
EOF
```

### 테스트

```bash
# Claude Code 재시작 후

/qp
# 또는
/quickpush
# 또는
/push
```

---

## 🎯 실용적인 Command들

### 1. 빠른 커밋 (qc)

```bash
cat > ~/.claude/plugins/my-first-plugin/commands/qc.md << 'EOF'
---
name: qc
description: Quick Commit (add + commit)
aliases: [quickcommit]
---

# Quick Commit

변경사항을 자동으로 add하고 commit합니다.

## 1. 변경사항 확인

```bash
git status --short
```

## 2. 자동 메시지 생성

파일 종류에 따라:
- .md 파일 → "docs: 문서 업데이트"
- .js/.ts 파일 → "feat: 기능 구현"
- package.json → "chore: 의존성 업데이트"

## 3. 실행

```bash
# 모든 파일 스테이징
git add -A

# 커밋 (메시지는 위에서 생성한 것 사용)
git commit -m "[생성된 메시지]"
```

## 출력

```
✅ 커밋 완료: abc1234
   3 files changed
   메시지: [커밋 메시지]
```
EOF
```

### 2. 브랜치 목록 (br)

```bash
cat > ~/.claude/plugins/my-first-plugin/commands/br.md << 'EOF'
---
name: br
description: Branch 목록 보기
aliases: [branches, branch-list]
---

# Branch List

로컬 브랜치 목록을 보기 좋게 표시합니다.

## 실행

```bash
# 브랜치 목록 (최근 커밋 날짜 포함)
git for-each-ref --sort=-committerdate refs/heads/ \
  --format='%(refname:short)|%(committerdate:relative)|%(subject)' \
  | head -10
```

## 출력 형식

```
📋 최근 브랜치 (10개)

🌿 main
   3 days ago - feat: 새 기능 추가
   
🌿 feature/login
   1 week ago - wip: 로그인 구현 중
   
🌿 hotfix/bug-123
   2 weeks ago - fix: 버그 수정
```
EOF
```

### 3. 파일 검색 (ff)

```bash
cat > ~/.claude/plugins/my-first-plugin/commands/ff.md << 'EOF'
---
name: ff
description: Find File (파일 빠른 검색)
aliases: [findfile, search-file]
---

# Find File

파일명으로 빠르게 검색합니다.

## 사용법

```
/ff [검색어]
```

## 실행

```bash
# 현재 디렉토리에서 검색
find . -name "*[검색어]*" -type f \
  | grep -v node_modules \
  | grep -v .git \
  | head -20
```

## 출력

```
🔍 "[검색어]" 검색 결과:

📁 src/utils/helper.js
📁 src/components/Helper.tsx
📁 test/helper.test.js

총 3개 파일 발견
```

## 주의사항

- node_modules, .git은 제외
- 최대 20개까지 표시
- 더 보려면 검색어를 구체적으로
EOF
```

---

## 🔧 Command 작성 팁

### 1. 짧은 이름 + 별칭

```yaml
---
name: qc              ← 짧고 외우기 쉬움
aliases: [quickcommit] ← 명확한 이름도 제공
---
```

### 2. 한 가지만 하기

```markdown
# ✅ 좋은 예: Quick Commit
- git add
- git commit

# ❌ 나쁜 예: 만능 git 도구
- git add
- git commit
- git push
- git pull
- ... (너무 많음)
```

### 3. 빠르게

```bash
# ✅ 빠름
git status --short

# ❌ 느림
for file in $(find . -name "*.js"); do
  git log "$file" | ...
done
```

---

## 📚 Skill vs Command 언제 쓰나?

### 시나리오로 판단

| 상황 | 선택 | 이유 |
|:-----|:-----|:-----|
| Git 상태 확인 | Command | 빠른 조회 |
| PR 리뷰 요청 | Skill | 복잡한 분석 |
| 파일 검색 | Command | 단순 검색 |
| 코드 품질 분석 | Skill | 여러 도구 조합 |
| 빠른 커밋 | Command | 단일 작업 |
| 보안 취약점 스캔 | Skill | 깊은 분석 |

---

## ✅ 연습 문제

### 과제 1: "up" Command

**요구사항:**
- upstream 변경사항 확인
- pull 필요 여부 판단
- `git fetch` + `git status`

<details>
<summary>정답 보기</summary>

```bash
cat > ~/.claude/plugins/my-first-plugin/commands/up.md << 'EOF'
---
name: up
description: Upstream 확인 (fetch + status)
---

# Upstream Check

원격 저장소 변경사항을 확인합니다.

## 실행

```bash
# Fetch
git fetch origin

# 비교
git rev-list HEAD..@{u} --count 2>/dev/null || echo "0"
```

## 출력

```
🔄 Upstream 확인

Behind: X개 커밋

[X > 0]
💡 git pull로 업데이트하세요

[X = 0]
✅ 최신 상태입니다
```
EOF
```

</details>

### 과제 2: "clean" Command

**요구사항:**
- Untracked 파일 삭제
- 확인 프롬프트

---

## 🎉 완료!

Skill과 Command의 차이를 이해하고 command를 만들었습니다!

**배운 것:**
- ✅ Skill vs Command 차이
- ✅ Command 작성법
- ✅ 실용적인 예제들

[Step 4: Jira Skill →](step-04-jira-skill)
{: .btn .btn-primary }
