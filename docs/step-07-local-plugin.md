---
layout: default
title: "Step 7: 로컬 플러그인 개발"
nav_order: 7
---

# Step 7: 로컬 플러그인 개발
{: .no_toc }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 개요

이 튜토리얼에서는 **로컬 플러그인 개발**에 집중합니다. 마켓플레이스 배포가 아닌, 개인적으로 사용할 플러그인을 만들고 테스트하는 방법을 다룹니다.

**예상 소요 시간:** 20분

---

## 개인 Skills vs 플러그인

### 개인 Skills (Step 3에서 배운 것)

```
~/.claude/skills/
└── my-skill/
    └── SKILL.md
```

- **단일 스킬 단위**
- 네임스페이스 없음 (`/my-skill`)
- 간단한 자동화에 적합

### 플러그인

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── skill-a/
    │   └── SKILL.md
    └── skill-b/
        └── SKILL.md
```

- **여러 스킬을 묶음**
- 네임스페이스 제공 (`/plugin-name:skill-a`)
- 관련 기능을 그룹화

---

## 왜 플러그인이 필요한가?

### 1. 네임스페이스

여러 플러그인이 같은 이름의 스킬을 가질 수 있습니다:

```bash
/git:commit      # git 플러그인의 commit
/work:commit     # work 플러그인의 commit
```

### 2. 관련 기능 묶기

Git 관련 스킬들을 하나의 플러그인으로:

```
git-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── commit/
    │   └── SKILL.md
    ├── branch/
    │   └── SKILL.md
    ├── rebase/
    │   └── SKILL.md
    └── conflict/
        └── SKILL.md
```

### 3. 재사용성

플러그인 디렉토리를 통째로 복사하면 다른 환경에서도 바로 사용 가능합니다.

---

## 플러그인 구조

### 필수 구조

```
my-plugin/
├── .claude-plugin/          # 조건부 선택적: 기본 위치 사용 시 생략 가능
│   └── plugin.json          # 플러그인 메타데이터
└── skills/                  # 스킬 디렉토리 (루트에 직접)
    └── example/
        └── SKILL.md         # 스킬 파일 (대문자)
```

### plugin.json 기본 구조

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My first plugin",
  "skills": [
    {
      "name": "example",
      "file": "skills/example/SKILL.md",
      "description": "Example skill"
    }
  ]
}
```

---

## 로컬 개발 워크플로우

### 중요: ~/.claude/plugins/는 캐시 디렉토리

**주의사항:**
- `~/.claude/plugins/`는 마켓플레이스에서 설치된 플러그인의 **캐시**입니다
- 여기에 직접 파일을 만들거나 수정하면 **삭제되거나 덮어쓰기될 수 있습니다**
- 로컬 개발은 `~/.claude/plugins/` 외부의 **원하는 디렉토리**에서 하세요

### 1. 플러그인 생성 위치

어디서든 플러그인을 만들 수 있습니다:

```bash
# 예시 1: 프로젝트 디렉토리
~/projects/my-plugin/

# 예시 2: 개발 전용 디렉토리
~/dev/claude-plugins/my-plugin/

# 예시 3: 데스크탑
~/Desktop/test-plugin/
```

### 2. 플러그인 로드 방법

`--plugin-dir` 플래그를 사용하여 세션마다 로드합니다:

```bash
claude --plugin-dir ~/projects/my-plugin
```

**여러 플러그인 동시 로드:**

```bash
claude \
  --plugin-dir ~/projects/plugin-a \
  --plugin-dir ~/projects/plugin-b \
  --plugin-dir ~/Desktop/test-plugin
```

### 3. 세션 전용

- `--plugin-dir`로 로드한 플러그인은 **현재 세션**에만 적용됩니다
- Claude를 종료하면 다시 로드해야 합니다
- 영구적으로 사용하려면 나중에 마켓플레이스를 통해 설치합니다

### 4. 개발 중 리로드

플러그인 파일을 수정한 후:

```bash
/reload-plugins
```

Claude가 변경사항을 즉시 반영합니다.

---

## 첫 번째 플러그인 만들기

### Step 1: 디렉토리 생성

```bash
mkdir -p ~/dev/my-first-plugin/.claude-plugin
mkdir -p ~/dev/my-first-plugin/skills/hello
cd ~/dev/my-first-plugin
```

### Step 2: plugin.json 작성

`.claude-plugin/plugin.json`:

```json
{
  "name": "my-first",
  "version": "1.0.0",
  "description": "My first local plugin",
  "author": "Your Name",
  "skills": [
    {
      "name": "hello",
      "file": "skills/hello/SKILL.md",
      "description": "Say hello"
    }
  ]
}
```

### Step 3: 스킬 파일 작성

`skills/hello/SKILL.md`:

```markdown
---
name: hello
description: Say hello to the user
trigger_patterns:
  - "say hello"
  - "greet me"
---

# Hello Skill

Greet the user in a friendly way.

## Instructions

1. Greet the user warmly
2. Ask how you can help today
3. Show enthusiasm
```

### Step 4: 플러그인 테스트

```bash
# Claude 실행 (플러그인 로드)
claude --plugin-dir ~/dev/my-first-plugin

# 세션 내에서 테스트
/my-first:hello
```

---

## 네임스페이스 사용

### 기본 호출 방식

```bash
/plugin-name:skill-name
```

### 예시

```bash
# hello 스킬 실행
/my-first:hello

# 인자 전달
/my-first:hello "John"
```

### 자동 트리거

trigger_patterns가 설정되어 있으면 자동으로 실행됩니다:

```
User: say hello
Claude: (my-first:hello 스킬 자동 실행)
```

---

## 여러 스킬 포함하기

### 실전 예제: Git 플러그인

Git 관련 작업을 자동화하는 플러그인을 만들어봅시다.

#### 구조

```
git-helper/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── smart-commit/
    │   └── SKILL.md
    ├── cleanup-branches/
    │   └── SKILL.md
    └── sync/
        └── SKILL.md
```

#### plugin.json

```json
{
  "name": "git-helper",
  "version": "1.0.0",
  "description": "Git workflow automation",
  "author": "Your Name",
  "skills": [
    {
      "name": "smart-commit",
      "file": "skills/smart-commit/SKILL.md",
      "description": "Create smart commit messages"
    },
    {
      "name": "cleanup-branches",
      "file": "skills/cleanup-branches/SKILL.md",
      "description": "Clean up merged branches"
    },
    {
      "name": "sync",
      "file": "skills/sync/SKILL.md",
      "description": "Sync with remote"
    }
  ]
}
```

#### smart-commit.md

```markdown
---
name: smart-commit
description: Analyze changes and create meaningful commit message
trigger_patterns:
  - "smart commit"
  - "commit with analysis"
---

# Smart Commit

Analyze git changes and create a conventional commit message.

## Instructions

1. Run `git status` to see changed files
2. Run `git diff` to analyze changes
3. Identify the type of changes:
   - feat: New features
   - fix: Bug fixes
   - docs: Documentation only
   - refactor: Code restructuring
   - test: Adding tests
   - chore: Maintenance
4. Create a commit message following conventional commits
5. Ask user for confirmation
6. Commit with the message

## Example Output

```
Type: feat
Scope: authentication
Message: add OAuth2 login support

Do you want to commit with this message? (yes/no)
```
```

#### cleanup-branches.md

```markdown
---
name: cleanup-branches
description: Clean up merged branches safely
trigger_patterns:
  - "clean branches"
  - "cleanup branches"
---

# Cleanup Branches

Safely remove merged branches.

## Instructions

1. Run `git branch --merged` to list merged branches
2. Exclude main/master/develop branches
3. Show the list to user
4. Ask for confirmation
5. Delete confirmed branches
6. Run `git remote prune origin` to clean remote references

## Safety Rules

- Never delete: main, master, develop, staging
- Never delete current branch
- Always show list before deleting
- Always ask for confirmation
```

#### sync.md

```markdown
---
name: sync
description: Sync with remote safely
trigger_patterns:
  - "sync with remote"
  - "pull and push"
---

# Sync with Remote

Safely sync local and remote branches.

## Instructions

1. Check if there are uncommitted changes
   - If yes, ask user to commit or stash
2. Get current branch name
3. Run `git fetch origin`
4. Check if remote branch exists
5. If exists:
   - Run `git pull --rebase origin [branch]`
   - If conflicts, guide user to resolve
   - After resolution, continue rebase
6. Run `git push origin [branch]`
7. Report sync status

## Error Handling

- Uncommitted changes: Ask to commit/stash
- Merge conflicts: Guide through resolution
- Remote doesn't exist: Ask to create
```

### 사용 방법

```bash
# 플러그인 로드
claude --plugin-dir ~/dev/git-helper

# 스킬 사용
/git-helper:smart-commit
/git-helper:cleanup-branches
/git-helper:sync

# 또는 자동 트리거
"Please do a smart commit"
"Clean up my branches"
"Sync with remote"
```

---

## 개발 팁

### 1. 빠른 반복 개발

```bash
# 터미널 1: Claude 실행
claude --plugin-dir ~/dev/my-plugin

# 터미널 2: 파일 편집
vim ~/dev/my-plugin/skills/my-skill/SKILL.md

# 터미널 1 (Claude 세션 내에서)
/reload-plugins
/my-plugin:my-skill  # 테스트
```

### 2. 디버깅

스킬에 디버그 출력을 추가하세요:

```markdown
## Instructions

1. Log: "Starting task..."
2. Show current working directory
3. List relevant files
4. Log: "Processing..."
```

### 3. 버전 관리

플러그인을 Git으로 관리하세요:

```bash
cd ~/dev/my-plugin
git init
git add .
git commit -m "Initial plugin version"
```

### 4. 여러 버전 테스트

```bash
# 다른 디렉토리에 복사
cp -r ~/dev/my-plugin ~/dev/my-plugin-v2

# 수정 후 다른 버전 테스트
claude --plugin-dir ~/dev/my-plugin-v2
```

---

## 플러그인 구성 모범 사례

### 1. 명확한 네이밍

```json
{
  "name": "git-helper",           // 짧고 명확
  "skills": [
    {
      "name": "smart-commit",     // 동사-명사 패턴
      "description": "Create smart commit messages"  // 명확한 설명
    }
  ]
}
```

### 2. 관련 스킬 그룹화

**좋은 예:**

```
git-helper/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── commit/
    │   └── SKILL.md
    ├── branch/
    │   └── SKILL.md
    └── merge/
        └── SKILL.md
```

**나쁜 예:**

```
my-tools/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── commit/
    │   └── SKILL.md
    ├── database/        # Git과 관련 없음
    │   └── SKILL.md
    └── send-email/      # Git과 관련 없음
        └── SKILL.md
```

### 3. 일관된 trigger_patterns

```markdown
# Git 플러그인의 모든 스킬
trigger_patterns:
  - "git [action]"     # git commit, git branch, etc.
```

### 4. 에러 처리 포함

```markdown
## Instructions

1. Check if git repository exists
   - If not, show error: "Not a git repository"
2. Check if there are changes
   - If not, show: "No changes to commit"
3. Proceed with commit
```

---

## 다음 단계

로컬 플러그인 개발을 마스터했다면:

1. **Step 5**: 고급 플러그인 패턴 (조건부 실행, 상태 관리)
2. **Step 6**: 플러그인 테스트 및 디버깅
3. **Step 7**: 플러그인 배포 (마켓플레이스)

---

## 요약

### 핵심 개념

- **플러그인**: 여러 스킬을 네임스페이스로 묶음
- **로컬 개발**: 어디서든 개발, `--plugin-dir`로 로드
- **세션 전용**: 영구적이지 않음, 매 세션마다 로드 필요
- **네임스페이스**: `/plugin-name:skill-name`

### 개발 워크플로우

```bash
# 1. 플러그인 생성
mkdir -p ~/dev/my-plugin/.claude-plugin
mkdir -p ~/dev/my-plugin/skills/skill-name

# 2. plugin.json 작성
# 3. 스킬 파일 작성

# 4. 테스트
claude --plugin-dir ~/dev/my-plugin

# 5. 수정 후 리로드
/reload-plugins
```

### 주의사항

- `~/.claude/plugins/`에 직접 파일 만들지 말 것
- 세션마다 `--plugin-dir` 필요
- 영구 사용은 마켓플레이스 설치로

---

## 연습 문제

### 문제 1: Todo 플러그인

다음 기능을 가진 todo 플러그인을 만드세요:

- `/todo:add "task"` - 할 일 추가
- `/todo:list` - 할 일 목록 표시
- `/todo:done N` - N번 할 일 완료

### 문제 2: 프로젝트 초기화 플러그인

새 프로젝트를 시작할 때 필요한 작업을 자동화하는 플러그인:

- `/project:init-node` - Node.js 프로젝트 초기화
- `/project:init-python` - Python 프로젝트 초기화
- `/project:add-ci` - CI/CD 설정 추가

### 문제 3: Git 플러그인 확장

위에서 만든 git-helper에 기능 추가:

- `/git-helper:pr` - Pull Request 생성
- `/git-helper:release` - 릴리스 태그 생성
- `/git-helper:hotfix` - 핫픽스 브랜치 생성

---

**다음**: [Step 5: 고급 플러그인 패턴](./step-05-advanced-plugin.html) →
