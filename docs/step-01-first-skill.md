---
layout: default
title: "Step 1: 첫 번째 Skill"
nav_order: 3
---

# Step 1: 첫 번째 Skill 만들기
{: .no_toc }

⏱️ 10분
{: .label .label-green }

3줄로 동작하는 가장 간단한 skill을 직접 만들어봅니다.
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
- ✅ 왜 동작하는지 이해합니다

---

## 📂 1단계: 디렉토리 만들기

### 실행하기

터미널을 열고 이 명령어를 **그대로** 입력하세요:

```bash
mkdir -p ~/.claude/plugins/my-first-plugin/skills
```

### 무슨 일이 일어났나?

```
~/.claude/plugins/              ← Claude Code가 플러그인을 찾는 위치
└── my-first-plugin/            ← 우리가 만드는 플러그인 이름
    └── skills/                 ← skill 파일들이 들어갈 폴더
```

### 왜 이 위치인가?

Claude Code는 **항상** `~/.claude/plugins/` 디렉토리를 스캔합니다.
- 다른 위치에 만들면? → 인식 안 됨
- 이름을 바꿔도 되나? → 네! `my-first-plugin` 부분은 자유

### 확인하기

```bash
ls -la ~/.claude/plugins/my-first-plugin/
```

**예상 결과:**
```
drwxr-xr-x  skills
```

---

## 📝 2단계: Skill 파일 만들기

### 실행하기

이 명령어를 **그대로** 복사해서 실행하세요:

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/hello.md << 'EOF'
---
name: hello
description: 가장 간단한 인사 skill
---

# Hello Skill

안녕하세요! 첫 번째 skill입니다.

프로젝트 디렉토리:
```bash
pwd
```
EOF
````

### 무슨 일이 일어났나?

`hello.md` 파일이 생성되었습니다:

```
~/.claude/plugins/my-first-plugin/
└── skills/
    └── hello.md       ← 방금 만든 파일
```

### 파일 내용 뜯어보기

파일을 열어보세요:
```bash
cat ~/.claude/plugins/my-first-plugin/skills/hello.md
```

```markdown
---
name: hello                              ← ⭐ 이게 슬래시 명령어 이름!
description: 가장 간단한 인사 skill     ← 설명 (선택)
---
                                         ← ⭐ 3개 대시로 구분!
# Hello Skill                            ← 여기부터 실제 내용

안녕하세요! 첫 번째 skill입니다.       ← Claude가 읽고 실행할 내용

프로젝트 디렉토리:                       ← 설명
```bash                                   ← 코드 블록 시작
pwd                                      ← ⭐ Claude가 실행할 명령어
```                                       ← 코드 블록 끝
```

### 왜 이렇게 작성하나?

#### Frontmatter (`---` 사이)
```yaml
---
name: hello        ← /hello 로 호출됨
description: ...   ← 목록에 표시됨
---
```

**규칙:**
- 반드시 파일 맨 위에
- 반드시 `---` 3개 대시로 시작/끝
- `name`은 필수, 나머지는 선택

#### 본문
```markdown
# Hello Skill

안녕하세요!
```

Claude가 이 내용을 읽고:
1. "아, 인사를 하라는구나"
2. "그리고 pwd 명령어를 실행하라는구나"
3. 실제로 실행하고 결과를 보여줌

---

## 📋 3단계: plugin.json 만들기

### 실행하기

```bash
cat > ~/.claude/plugins/my-first-plugin/plugin.json << 'EOF'
{
  "name": "my-first-plugin",
  "version": "1.0.0",
  "description": "내 첫 번째 플러그인",
  "skills": {
    "path": "skills/**/*.md"
  }
}
EOF
```

### 무슨 일이 일어났나?

디렉토리 구조가 이렇게 되었습니다:

```
~/.claude/plugins/my-first-plugin/
├── plugin.json     ← 방금 만든 파일
└── skills/
    └── hello.md
```

### plugin.json 뜯어보기

```bash
cat ~/.claude/plugins/my-first-plugin/plugin.json
```

```json
{
  "name": "my-first-plugin",           ← 플러그인 이름 (자유)
  "version": "1.0.0",                   ← 버전 (자유)
  "description": "내 첫 번째 플러그인", ← 설명 (자유)
  "skills": {                           ← ⭐ 중요!
    "path": "skills/**/*.md"            ← skill 파일 찾을 위치
  }
}
```

### 왜 필요한가?

Claude Code가 시작할 때:
1. `~/.claude/plugins/` 스캔
2. 각 폴더에서 `plugin.json` 찾기
3. 있으면 → 플러그인으로 인식
4. 없으면 → 무시

**없으면?**
```
❌ 인식 안 됨
❌ skill 실행 안 됨
```

### path 패턴

```json
"path": "skills/**/*.md"
```

의미:
- `skills/` 폴더 안의
- `**` 모든 하위 폴더의 (재귀적)
- `*.md` 모든 .md 파일

예시:
```
✅ skills/hello.md
✅ skills/git/status.md
✅ skills/jira/create.md
❌ hello.md               (skills/ 밖)
❌ skills/test.txt        (.md 아님)
```

---

## 🚀 4단계: 실행해보기

### Claude Code 재시작

**중요!** 파일을 만들었으면 반드시 재시작해야 합니다.

```bash
# CLI인 경우
# Ctrl+D 로 종료 후
claude code

# Desktop인 경우
# 앱 재시작
```

### Skill 실행

```
/hello
```

**예상 결과:**

```
안녕하세요! 첫 번째 skill입니다.

프로젝트 디렉토리:
/Users/yourname/Desktop/project
```

### 작동 원리

```
1. /hello 입력
   ↓
2. Claude Code가 "hello"라는 name 찾기
   ↓
3. ~/.claude/plugins/my-first-plugin/skills/hello.md 발견
   ↓
4. 파일 내용 전체를 Claude에게 전달
   ↓
5. Claude가 내용 읽고 이해
   - "안녕하세요 출력하라"
   - "pwd 명령어 실행하라"
   ↓
6. Bash 도구로 pwd 실행
   ↓
7. 결과를 사용자에게 보여줌
```

---

## 🔧 5단계: 수정해보기

### 내용 수정

파일을 수정해봅시다:

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/hello.md << 'EOF'
---
name: hello
description: 개선된 인사 skill
---

# Hello Skill

안녕하세요! 수정된 버전입니다. 😊

## 현재 정보

**디렉토리:**
```bash
pwd
```

**Git 브랜치:**
```bash
git branch --show-current 2>/dev/null || echo "Git 저장소 아님"
```
EOF
````

### 재시작 & 확인

```bash
# Claude Code 재시작
# 그리고

/hello
```

**예상 결과:**

```
안녕하세요! 수정된 버전입니다. 😊

## 현재 정보

**디렉토리:**
/Users/yourname/project

**Git 브랜치:**
main
```

### 무엇이 바뀌었나?

1. 이모지 추가됨
2. 섹션 제목 추가 (`## 현재 정보`)
3. Git 브랜치 확인 추가
4. 에러 처리 추가 (`2>/dev/null || echo ...`)

---

## 📚 핵심 정리

### 파일 구조

```
~/.claude/plugins/my-first-plugin/
├── plugin.json          ← 필수: 플러그인 정보
└── skills/
    └── hello.md         ← Skill 파일
```

### Skill 파일 형식

```markdown
---
name: skill-name         ← 슬래시 명령어 이름
description: ...         ← 설명 (선택)
---

내용...                  ← Claude가 읽을 내용
```

### 실행 흐름

```
파일 작성 → 재시작 → /skill-name 입력 → 실행
```

### 중요한 점

1. **위치:** 반드시 `~/.claude/plugins/` 안
2. **plugin.json:** 반드시 있어야 함
3. **Frontmatter:** 반드시 파일 맨 위, `---`로 감싸기
4. **재시작:** 파일 수정 후 반드시 재시작

---

## 💡 자주 하는 실수

### ❌ 실수 1: plugin.json 없음

```
~/.claude/plugins/my-first-plugin/
└── skills/
    └── hello.md
```

**결과:** 인식 안 됨

**해결:** plugin.json 만들기

---

### ❌ 실수 2: Frontmatter 누락

```markdown
# Hello Skill

안녕하세요!
```

**결과:** name을 못 찾아서 실행 안 됨

**해결:** 맨 위에 추가
```markdown
---
name: hello
---

# Hello Skill
```

---

### ❌ 실수 3: 재시작 안 함

파일 수정했는데 `/hello` 가 예전 버전 실행

**결과:** 수정 사항 반영 안 됨

**해결:** Claude Code 재시작

---

### ❌ 실수 4: path 패턴 틀림

```json
"skills": {
  "path": "skill/*.md"    ← 오타! (skills가 아님)
}
```

**결과:** 파일을 못 찾음

**해결:** 정확한 경로 입력

---

## ✅ 연습 문제

### 과제: "bye" Skill 만들기

**요구사항:**
- 이름: `bye`
- 설명: "작별 인사"
- 출력: "안녕히 가세요!" + 현재 시간

**힌트:**
```bash
# 현재 시간
date "+%Y-%m-%d %H:%M:%S"
```

<details>
<summary>정답 보기</summary>

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/bye.md << 'EOF'
---
name: bye
description: 작별 인사
---

안녕히 가세요!

현재 시간:
```bash
date "+%Y-%m-%d %H:%M:%S"
```
EOF
````

**재시작 후 실행:**
```
/bye
```

</details>

---

## 🎉 완료!

첫 번째 Skill을 만들고 실행했습니다!

**배운 것:**
- ✅ 파일 위치와 구조
- ✅ plugin.json 작성
- ✅ Frontmatter 사용
- ✅ 실행 흐름
- ✅ 수정과 재시작

### 다음 단계

실용적인 것을 만들어봅시다!

[Step 2: Git Skill 만들기 →](step-02-git-skill)
{: .btn .btn-primary }
