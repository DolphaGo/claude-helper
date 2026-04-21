---
layout: default
title: "Step 8: 마켓플레이스"
nav_order: 11
---

# Step 8: 마켓플레이스 등록과 배포
{: .no_toc }

⏱️ 20분
{: .label .label-purple }

플러그인을 마켓플레이스에 등록해서 영구적으로 관리하고 팀과 쉽게 공유하는 방법을 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

**핵심 개념:** 마켓플레이스를 통한 영구 플러그인 관리

**배울 것:**
- 로컬 플러그인 vs 마켓플레이스 플러그인
- 마켓플레이스 구조 이해
- 플러그인 등록 및 버전 관리
- 설치 자동화

---

## 📦 로컬 vs 마켓플레이스

### 로컬 플러그인 (Step 6에서 배운 것)

```bash
# 개발 디렉토리에 clone
mkdir -p ~/my-plugins
cd ~/my-plugins
git clone https://github.com/username/my-first-plugin.git

# 사용
claude --plugin-dir ~/my-plugins/my-first-plugin
```

**특징:**
- ✅ 간단한 공유
- ❌ 매번 --plugin-dir 지정 필요
- ❌ 업데이트 관리 어려움
- ❌ 삭제하면 완전히 사라짐

### 마켓플레이스 플러그인

```bash
claude plugin add https://github.com/username/my-marketplace.git
claude plugin install my-first-plugin
```

**특징:**
- ✅ 한 번 설치하면 영구 보관
- ✅ 자동 업데이트 가능
- ✅ 버전 관리 자동화
- ✅ 팀 전체 공유 용이
- ✅ `~/.claude/plugins/cache/`에 자동 저장

---

## 🤔 왜 마켓플레이스가 필요한가?

### 문제 상황

로컬 플러그인의 문제점:

```bash
# 실수로 삭제
rm -rf ~/my-plugins/my-first-plugin

# 다시 설치해야 함
git clone https://github.com/...

# 팀원마다 수동 설치
# 팀원1: git clone ...
# 팀원2: git clone ...
# 팀원3: git clone ...
```

### 마켓플레이스 솔루션

```bash
# 한 번만 마켓플레이스 등록
claude plugin add https://github.com/team/marketplace.git

# 모든 팀원이 간단하게 설치
claude plugin install my-first-plugin

# 삭제해도 다시 설치 가능
claude plugin uninstall my-first-plugin
claude plugin install my-first-plugin  # 즉시 복구
```

**핵심:**
- 중앙 저장소 역할
- 영구 보관
- 쉬운 배포
- 버전 관리

---

## 🏗️ 마켓플레이스 만들기

### 1. 저장소 구조

마켓플레이스는 Git 저장소입니다.

```bash
mkdir my-marketplace
cd my-marketplace
```

필수 구조:

```
my-marketplace/
├── marketplace.json       ← 마켓플레이스 메타데이터
└── plugins/
    └── my-first-plugin/   ← 플러그인들
        ├── .claude-plugin/
        │   └── plugin.json
        └── skills/
            └── hello/
                └── SKILL.md
```

### 2. marketplace.json 작성

마켓플레이스의 핵심 파일입니다.

```bash
cat > marketplace.json << 'EOF'
{
  "name": "my-marketplace",
  "description": "우리 팀의 Claude 플러그인 모음",
  "version": "1.0.0",
  "author": {
    "name": "Your Team Name",
    "email": "team@example.com"
  },
  "plugins": []
}
EOF
```

**필드 설명:**
- `name`: 마켓플레이스 이름 (고유해야 함)
- `description`: 간단한 설명
- `version`: 마켓플레이스 버전
- `plugins`: 등록된 플러그인 목록 (자동 관리됨)

### 3. Git 저장소 초기화

```bash
git init
git add .
git commit -m "feat: initialize marketplace"
```

### 4. GitHub에 푸시

```bash
# GitHub에서 저장소 생성 후
git remote add origin https://github.com/username/my-marketplace.git
git branch -M main
git push -u origin main
```

---

## 📝 플러그인 등록하기

### 1. 플러그인 디렉토리 생성

마켓플레이스에 플러그인을 추가합니다.

```bash
cd my-marketplace
mkdir -p plugins/my-first-plugin
```

### 2. 플러그인 파일 복사

기존 플러그인을 복사하거나 새로 만듭니다.

```bash
# 기존 플러그인 복사
cp -r ~/my-plugins/my-first-plugin/* plugins/my-first-plugin/

# 또는 새로 만들기
mkdir -p plugins/my-first-plugin/.claude-plugin
mkdir -p plugins/my-first-plugin/skills/hello
```

### 3. plugin.json 확인

```bash
cat > plugins/my-first-plugin/.claude-plugin/plugin.json << 'EOF'
{
  "name": "my-first-plugin",
  "version": "1.0.0",
  "description": "내 첫 번째 플러그인",
  "author": {
    "name": "Your Name"
  }
}
EOF
```

### 4. 커밋 및 푸시

```bash
git add .
git commit -m "feat: add my-first-plugin v1.0.0"
git push
```

{: .important }
> **수동 관리:** 마켓플레이스에 플러그인을 추가한 후에는 `marketplace.json`의 `plugins` 배열을 수동으로 업데이트해야 합니다. 플러그인이 자동으로 등록되지 않으므로, 각 플러그인의 정보를 직접 추가하세요.

---

## 🚀 설치 및 사용

### 1. 마켓플레이스 추가

팀원들이 처음 한 번만 실행합니다.

```bash
claude plugin add https://github.com/username/my-marketplace.git
```

**결과:**

```
✓ Marketplace added: my-marketplace
✓ Found 1 plugin(s)
```

### 2. 사용 가능한 플러그인 확인

```bash
claude plugin list
```

**출력:**

```
Marketplace: my-marketplace
  - my-first-plugin (v1.0.0)
```

### 3. 플러그인 설치

```bash
claude plugin install my-first-plugin
```

**동작:**
1. 마켓플레이스에서 플러그인 다운로드
2. `~/.claude/plugins/cache/my-first-plugin/`에 저장
3. Claude 재시작 시 자동 로드

**확인:**

```bash
ls ~/.claude/plugins/cache/
```

```
my-first-plugin/
```

### 4. 사용

```bash
claude
/my-first-plugin:hello
```

---

## 🔄 버전 관리

### 버전 업데이트

플러그인을 수정한 후 버전을 올립니다.

```bash
cd my-marketplace/plugins/my-first-plugin

# plugin.json 수정
cat > .claude-plugin/plugin.json << 'EOF'
{
  "name": "my-first-plugin",
  "version": "1.1.0",
  "description": "내 첫 번째 플러그인 (개선됨)",
  "author": {
    "name": "Your Name"
  }
}
EOF

# 커밋
git add .
git commit -m "feat: update my-first-plugin to v1.1.0"
git push
```

### 사용자 업데이트

팀원들이 업데이트를 받습니다.

```bash
# 마켓플레이스 새로고침
claude plugin update

# 특정 플러그인 업데이트
claude plugin update my-first-plugin
```

**자동 확인:**
- 현재 설치된 버전과 비교
- 새 버전이 있으면 다운로드
- 자동으로 `~/.claude/plugins/cache/` 업데이트

---

## 📚 버전 관리 전략

### Semantic Versioning

```
MAJOR.MINOR.PATCH
  1  .  1  .  0
```

**규칙:**
- `PATCH` (1.0.0 → 1.0.1): 버그 수정
- `MINOR` (1.0.0 → 1.1.0): 기능 추가 (하위 호환)
- `MAJOR` (1.0.0 → 2.0.0): 큰 변경 (하위 호환 안 됨)

### 예시

```bash
# 버그 수정
1.0.0 → 1.0.1
git commit -m "fix: correct error message"

# 기능 추가
1.0.1 → 1.1.0
git commit -m "feat: add new skill"

# 큰 변경
1.1.0 → 2.0.0
git commit -m "feat!: change skill API (breaking change)"
```

---

## 🏢 공식 vs 개인 마켓플레이스

### 공식 마켓플레이스

Claude Code가 제공하는 공식 마켓플레이스:

```bash
# 기본으로 포함됨
claude plugin list
```

**특징:**
- 검증된 플러그인
- 높은 품질
- 공식 지원

### 개인/팀 마켓플레이스

직접 만든 마켓플레이스:

```bash
claude plugin add https://github.com/team/marketplace.git
```

**특징:**
- 팀 내부용
- 커스텀 플러그인
- 완전한 제어

### 동시 사용

```bash
# 공식 마켓플레이스
claude plugin install official-plugin

# 팀 마켓플레이스
claude plugin install team-plugin
```

모두 `~/.claude/plugins/cache/`에 저장됩니다.

---

## 🔧 고급 설정

### marketplace.json 전체 예시

```json
{
  "name": "my-marketplace",
  "description": "우리 팀의 Claude 플러그인",
  "version": "1.0.0",
  "author": {
    "name": "Team Name",
    "email": "team@example.com",
    "url": "https://example.com"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/username/my-marketplace.git"
  },
  "plugins": []
}
```

### 여러 플러그인 관리

```
my-marketplace/
├── marketplace.json
└── plugins/
    ├── dev-tools/
    │   ├── .claude-plugin/
    │   └── skills/
    ├── git-helpers/
    │   ├── .claude-plugin/
    │   └── skills/
    └── jira-integration/
        ├── .claude-plugin/
        └── skills/
```

```bash
# 개별 설치
claude plugin install dev-tools
claude plugin install git-helpers
claude plugin install jira-integration
```

---

## 📋 자동 관리되는 파일

### ~/.claude/plugins/cache/

마켓플레이스에서 설치한 플러그인은 여기 저장됩니다.

```
~/.claude/plugins/cache/
├── my-first-plugin/
│   ├── .claude-plugin/
│   └── skills/
└── other-plugin/
    ├── .claude-plugin/
    └── skills/
```

**특징:**
- 자동 생성
- 자동 관리
- 수동으로 수정하지 마세요

### 설치 위치 비교

```
# 로컬 개발 플러그인 (수동 관리)
~/my-plugins/my-local-plugin/

# 마켓플레이스 플러그인 (자동 관리)
~/.claude/plugins/cache/my-marketplace-plugin/
```

**중요:** `~/.claude/plugins/`는 캐시 디렉토리입니다. 직접 생성하거나 수정하지 마세요.

---

## 🛠️ 실전 워크플로우

### 개발 단계

```bash
# 1. 로컬에서 개발
mkdir -p ~/my-plugins/new-plugin
# ... 개발 ...

# 2. 테스트
claude --plugin-dir ~/my-plugins/new-plugin
/new-plugin:test
```

### 마켓플레이스 등록

```bash
# 3. 마켓플레이스에 추가
cd my-marketplace
cp -r ~/my-plugins/new-plugin plugins/
git add .
git commit -m "feat: add new-plugin v1.0.0"
git push
```

### 팀 배포

```bash
# 4. 팀원들에게 알림
# "new-plugin v1.0.0이 출시되었습니다!"

# 5. 팀원들이 설치
claude plugin update  # 마켓플레이스 새로고침
claude plugin install new-plugin
```

---

## 🐛 문제 해결

### 플러그인이 목록에 안 나와요

```bash
# 마켓플레이스 새로고침
claude plugin update

# 마켓플레이스 다시 추가
claude plugin remove my-marketplace
claude plugin add https://github.com/username/my-marketplace.git
```

### 버전이 업데이트 안 돼요

```bash
# 강제 업데이트
claude plugin uninstall my-first-plugin
claude plugin install my-first-plugin
```

### cache 디렉토리가 너무 커요

```bash
# 안 쓰는 플러그인 제거
claude plugin uninstall unused-plugin

# cache 정리
claude plugin clean
```

---

## 📚 핵심 정리

### 마켓플레이스 구조

```
my-marketplace/
├── marketplace.json       ← 메타데이터
└── plugins/
    └── plugin-name/       ← 플러그인들
```

### 핵심 명령어

```bash
# 마켓플레이스 추가
claude plugin add <github-url>

# 플러그인 설치
claude plugin install <plugin-name>

# 업데이트
claude plugin update

# 제거
claude plugin uninstall <plugin-name>
```

### 자동 관리

- `~/.claude/plugins/cache/`: 자동 저장
- `marketplace.json`: 자동 업데이트
- 버전 확인: 자동

---

## ✅ 완료!

마켓플레이스를 만들고 플러그인을 등록하는 방법을 배웠습니다!

**배운 것:**
- ✅ 로컬 vs 마켓플레이스 차이
- ✅ 마켓플레이스 구조
- ✅ marketplace.json 작성
- ✅ 플러그인 등록 및 버전 관리
- ✅ 설치 자동화
- ✅ 팀 배포 워크플로우

**핵심 개념:**
- 마켓플레이스는 플러그인 중앙 저장소
- 한 번 설치하면 영구 보관
- Git 저장소로 버전 관리
- `~/.claude/plugins/cache/`에 자동 저장

### 다음 단계

마켓플레이스까지 배웠으니, 이제 고급 기능을 배울 준비가 되었습니다!

[고급 가이드 →](advanced)
{: .btn .btn-primary }

[처음으로 돌아가기 →](../)
{: .btn .btn-outline }
