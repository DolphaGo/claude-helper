---
layout: default
title: "Step 6: 배포하기"
nav_order: 8
---

# Step 6: 플러그인 배포하기
{: .no_toc }

⏱️ 10분
{: .label .label-purple }

만든 플러그인을 팀과 공유하고 배포하는 방법을 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

**배포 방법 3가지:**
1. Git 저장소 (가장 간단)
2. npm 패키지 (공식)
3. 로컬 공유 (팀 내부)

---

## 📦 방법 1: Git 저장소

### 가장 간단한 방법

#### 1. 저장소 만들기

```bash
cd ~/.claude/plugins/my-first-plugin

# Git 초기화
git init

# .gitignore 추가
cat > .gitignore << 'EOF'
.DS_Store
*.log
node_modules/
EOF

# 커밋
git add .
git commit -m "feat: 첫 플러그인 완성"
```

#### 2. GitHub/GitLab에 푸시

```bash
# Remote 추가
git remote add origin https://github.com/username/my-claude-plugin.git

# 푸시
git push -u origin main
```

#### 3. 다른 사람이 설치

```bash
# 방법 1: Clone
cd ~/.claude/plugins
git clone https://github.com/username/my-claude-plugin.git

# 방법 2: Submodule (추천)
cd ~/.claude/plugins
git submodule add https://github.com/username/my-claude-plugin.git
```

### README 작성

```markdown
# My First Plugin

Claude Code 플러그인입니다.

## 📦 설치

\`\`\`bash
cd ~/.claude/plugins
git clone https://github.com/username/my-claude-plugin.git

# Claude Code 재시작
\`\`\`

## 📚 포함된 기능

### Skills
- `/gs` - Git 상태 확인
- `/jira-bug` - Jira 버그 티켓 생성
- `/search` - 코드 검색

### Commands
- `/qc` - 빠른 커밋
- `/qp` - 빠른 푸시
- `/br` - 브랜치 목록

## ⚙️ 설정

환경 변수 설정이 필요합니다:

\`\`\`bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export JIRA_URL="https://your-company.atlassian.net"
export JIRA_EMAIL="your@email.com"
export JIRA_TOKEN="your-token"
\`\`\`

## 📖 사용법

자세한 사용법은 [Wiki](https://github.com/username/my-claude-plugin/wiki)를 참고하세요.

## 🤝 기여

Pull Request 환영합니다!

## 📄 라이선스

MIT
```

---

## 📦 방법 2: npm 패키지

### Claude Code 공식 방법

#### 1. package.json 완성

```bash
cd ~/.claude/plugins/my-first-plugin

cat > package.json << 'EOF'
{
  "name": "@yourname/claude-plugin",
  "version": "1.0.0",
  "description": "My Claude Code plugin",
  "main": "plugin.json",
  "keywords": ["claude", "claude-code", "plugin"],
  "author": "Your Name <your@email.com>",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/username/my-claude-plugin.git"
  },
  "files": [
    "plugin.json",
    "skills/**/*.md",
    "commands/**/*.md"
  ]
}
EOF
```

#### 2. npm 배포

```bash
# npm 로그인
npm login

# 배포
npm publish --access public
```

#### 3. 다른 사람이 설치

```bash
# Claude Code CLI에서
claude install @yourname/claude-plugin

# 또는 수동
cd ~/.claude/plugins
npm install @yourname/claude-plugin
```

---

## 📦 방법 3: 로컬 공유 (팀 내부)

### 프라이빗 Git 저장소 사용

#### 1. 공유 저장소에 커밋

```bash
# GitHub/GitLab 프라이빗 저장소
git remote add origin https://github.com/org/claude-plugins.git
git push origin main
```

#### 2. 설치 스크립트

```bash
cat > install.sh << 'EOF'
#!/bin/bash

PLUGIN_DIR="$HOME/.claude/plugins/team-plugin"

echo "📦 Claude 플러그인 설치 중..."

# 기존 제거
if [ -d "$PLUGIN_DIR" ]; then
  echo "기존 플러그인 제거..."
  rm -rf "$PLUGIN_DIR"
fi

# Clone
git clone https://github.com/org/claude-plugins.git "$PLUGIN_DIR"

# 환경 변수 체크
if [ -z "$JIRA_URL" ]; then
  echo ""
  echo "⚠️  Jira 환경 변수를 설정하세요:"
  echo "export JIRA_URL=\"...\""
  echo "export JIRA_TOKEN=\"...\""
fi

echo "✅ 설치 완료!"
echo "Claude Code를 재시작하세요."
EOF

chmod +x install.sh
```

#### 3. 팀원들에게 공유

```bash
# 설치 방법
curl -sSL https://github.com/org/claude-plugins/raw/main/install.sh | bash
```

---

## 🔄 업데이트

### Git 저장소

```bash
cd ~/.claude/plugins/my-first-plugin

# 최신 버전 받기
git pull origin main

# Claude Code 재시작
```

### npm 패키지

```bash
# 최신 버전 업데이트
claude update @yourname/claude-plugin

# 또는
cd ~/.claude/plugins/@yourname/claude-plugin
npm update
```

---

## 📋 버전 관리

### Semantic Versioning

```
1.0.0
│ │ │
│ │ └─ Patch: 버그 수정
│ └─── Minor: 새 기능 (하위 호환)
└───── Major: Breaking Changes
```

### 버전 올리기

```bash
# Patch (1.0.0 → 1.0.1)
npm version patch

# Minor (1.0.0 → 1.1.0)
npm version minor

# Major (1.0.0 → 2.0.0)
npm version major

# Git 태그 자동 생성됨
git push --tags
```

---

## 📖 문서화

### Wiki 구성

```
📖 Wiki
├── Home
│   └── 플러그인 소개
├── Installation
│   └── 설치 방법
├── Skills
│   ├── gs - Git 상태
│   ├── jira-bug - Jira 티켓
│   └── search - 코드 검색
├── Commands
│   ├── qc - 빠른 커밋
│   └── qp - 빠른 푸시
└── Configuration
    └── 환경 변수 설정
```

### 각 Skill 문서

````markdown
# Git Status Skill

## 사용법

\`\`\`
/gs
\`\`\`

## 기능

- 현재 브랜치
- 변경된 파일
- Staged/Unstaged 구분
- Upstream 비교

## 예시

\`\`\`
You: /gs

🌿 브랜치: main
📊 Staged: 2개
...
\`\`\`

## 옵션

- `/gs --verbose` - 상세 정보
````

---

## 🎨 배지 추가

README에 멋진 배지 추가:

```markdown
# My Claude Plugin

![npm version](https://img.shields.io/npm/v/@yourname/claude-plugin)
![license](https://img.shields.io/npm/l/@yourname/claude-plugin)
![downloads](https://img.shields.io/npm/dt/@yourname/claude-plugin)
```

---

## 🤝 팀 협업

### 이슈 템플릿

```.github/ISSUE_TEMPLATE/bug_report.md
---
name: Bug Report
about: 버그 리포트
---

## 버그 설명

## 재현 방법
1. 
2. 
3. 

## 예상 동작

## 실제 동작

## 환경
- OS: 
- Claude Code 버전: 
```

### PR 템플릿

```.github/pull_request_template.md
## 변경 사항

## 체크리스트
- [ ] 테스트 완료
- [ ] 문서 업데이트
- [ ] CHANGELOG 업데이트
```

---

## 📊 사용 통계

### 다운로드 수 확인

```bash
# npm
npm info @yourname/claude-plugin

# GitHub
# Repository → Insights → Traffic
```

---

## 🎉 완료!

플러그인을 배포하고 공유하는 방법을 배웠습니다!

**배운 것:**
- ✅ Git 저장소 배포
- ✅ npm 패키지 배포
- ✅ 로컬 공유
- ✅ 버전 관리
- ✅ 문서화

---

## 🚀 다음 단계

축하합니다! 전체 과정을 완료했습니다.

**이제 할 수 있는 것:**
- ✅ Skill과 Command 만들기
- ✅ 플러그인 구조 이해
- ✅ 실전 예제 구현
- ✅ 팀과 공유

### 더 배우기

- [Claude Code 공식 문서](https://docs.anthropic.com/claude/docs)
- [예제 플러그인](https://github.com/anthropics/claude-code-examples)
- [커뮤니티](https://discord.gg/claude)

### 피드백

이 가이드가 도움이 되었나요?  
[Issues](https://github.com/username/claude-helper/issues)에 피드백을 남겨주세요!

---

**Happy Coding! 🎉**
