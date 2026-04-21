---
layout: default
title: "Step 6: 배포하기"
nav_order: 8
---

# Step 6: 플러그인 배포하기
{: .no_toc }

⏱️ 10분
{: .label .label-purple }

만든 플러그인을 팀과 공유하는 방법을 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

**배포 방법:**
1. Git 저장소로 공유 (가장 간단)
2. 팀원 설치 가이드

---

## 📦 Git 저장소 만들기

### 1. Git 초기화

```bash
cd ~/.claude/plugins/my-first-plugin

git init
```

### 2. .gitignore 추가

```bash
cat > .gitignore << 'EOF'
.DS_Store
*.log
.omc/
EOF
```

### 3. README 작성

```bash
cat > README.md << 'EOF'
# My First Plugin

Claude Code 플러그인입니다.

## 설치

```bash
cd ~/.claude/plugins
git clone https://github.com/username/my-first-plugin.git
```

Claude 재시작 후 사용 가능합니다.

## 포함된 Skills

- `/my-first-plugin:hello` - 인사
- `/my-first-plugin:gs` - Git 상태 확인
EOF
```

### 4. 커밋

```bash
git add .
git commit -m "feat: initial plugin"
```

### 5. GitHub에 푸시

```bash
# GitHub에서 저장소 생성 후
git remote add origin https://github.com/username/my-first-plugin.git
git push -u origin main
```

---

## 👥 팀원 설치 가이드

### 설치 방법

팀원들에게 다음 명령어를 공유하세요:

```bash
cd ~/.claude/plugins
git clone https://github.com/username/my-first-plugin.git
```

그리고 Claude 재시작:

```bash
# Ctrl+D 후
claude
```

### 사용 방법

```bash
/my-first-plugin:hello
/my-first-plugin:gs
```

---

## 🔄 업데이트

### 플러그인 업데이트

```bash
cd ~/.claude/plugins/my-first-plugin
git pull
```

Claude 재시작 후 적용됩니다.

---

## 📚 핵심 정리

### 필수 파일 구조

```
my-first-plugin/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── hello/
│   │   └── SKILL.md
│   └── gs/
│       └── SKILL.md
├── .gitignore
└── README.md
```

### plugin.json 확인

```json
{
  "name": "my-first-plugin",
  "version": "1.0.0",
  "description": "내 첫 번째 플러그인",
  "author": {
    "name": "Your Name"
  }
}
```

---

## 🎓 개인 Skills 공유

플러그인 대신 개인 skills를 공유할 수도 있습니다.

### 저장소 구조

```
my-claude-skills/
├── README.md
└── skills/
    ├── hello/
    │   └── SKILL.md
    └── gs/
        └── SKILL.md
```

### 설치 방법

```bash
cd ~/.claude
git clone https://github.com/username/my-claude-skills.git temp
cp -r temp/skills/* skills/
rm -rf temp
```

---

## ✅ 완료!

플러그인을 배포하는 방법을 배웠습니다!

**배운 것:**
- ✅ Git 저장소 만들기
- ✅ README 작성
- ✅ 팀원 설치 가이드
- ✅ 업데이트 방법

### 다음 단계

팀 전체가 쉽게 설치하고 관리할 수 있는 마켓플레이스를 배워보세요!

[Step 7: 마켓플레이스 →](step-07-marketplace)
{: .btn .btn-primary }

[처음으로 돌아가기 →](../)
{: .btn .btn-outline }
