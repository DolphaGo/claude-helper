---
layout: default
title: "Step 4: API Skill"
nav_order: 4
---

# Step 4: 환경 변수와 API 호출
{: .no_toc }

⏱️ 15분
{: .label .label-blue }

환경 변수를 사용해서 안전하게 외부 API를 호출하는 방법을 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

**핵심 개념:** 환경 변수로 토큰을 안전하게 관리

**만들 것:** 간단한 API 호출 skill

**배울 것:**
- 왜 환경 변수를 쓰는가
- 환경 변수 설정 방법
- Skill에서 환경 변수 사용

---

## 📋 개념: 환경 변수

### 왜 환경 변수를 쓰나?

**나쁜 예:**
```bash
curl -H "Authorization: Bearer abc123xyz" https://api.example.com
```

문제:
- 토큰이 코드에 노출
- Git에 커밋되면 보안 위험
- 팀원마다 다른 토큰 사용 불가

**좋은 예:**
```bash
curl -H "Authorization: Bearer $API_TOKEN" https://api.example.com
```

장점:
- 토큰이 코드 밖에 있음
- Git에 안전
- 각자 자기 토큰 사용

---

## 🔐 1단계: 환경 변수 설정

### 설정하기

```bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export API_TOKEN="your-token-here"
export API_URL="https://api.example.com"
```

### 적용하기

```bash
# 새 터미널 열기 또는
source ~/.bashrc  # bash 사용 시
source ~/.zshrc   # zsh 사용 시
```

### 확인하기

```bash
echo $API_TOKEN
echo $API_URL
```

---

## 📝 2단계: 간단한 API Skill 만들기

테스트용으로 간단한 공개 API를 사용합니다. (JSONPlaceholder - 무료 테스트 API)

```bash
mkdir -p ~/my-plugins/my-first-plugin/skills/api-test
cat > ~/my-plugins/my-first-plugin/skills/api-test/SKILL.md << 'SKILLEOF'
---
name: api-test
description: 간단한 API 테스트
disable-model-invocation: true
---

# API Test Skill

공개 API를 테스트해보세요.

## 1. API 호출
https://jsonplaceholder.typicode.com/users/1 을 호출하세요.
curl 명령어를 사용하세요.

## 2. 결과 표시
응답 JSON을 보기 좋게 보여주세요.
SKILLEOF
```

### 테스트

```bash
# Claude 실행 시 플러그인 디렉토리 지정
claude --plugin-dir ~/my-plugins/my-first-plugin

# Skill 호출
/my-first-plugin:api-test
```

Claude가 curl로 API를 호출하고 결과를 보여줍니다.

---

## 🔐 3단계: 환경 변수 사용

이제 환경 변수를 사용하는 skill을 만들어봅시다.

### 환경 변수 설정

```bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export MY_API_TOKEN="test-token-123"
```

적용:

```bash
source ~/.bashrc  # 또는 source ~/.zshrc
```

확인:

```bash
echo $MY_API_TOKEN
```

### Skill 생성

```bash
cat > ~/my-plugins/my-first-plugin/skills/api-test/SKILL.md << 'SKILLEOF'
---
name: api-test
description: 환경 변수를 사용한 API 테스트
disable-model-invocation: true
---

# API Test with Token

환경 변수를 사용해서 API를 호출하세요.

## 1. 환경 변수 확인
MY_API_TOKEN이 설정되어 있는지 확인하세요.
설정되지 않았으면 사용자에게 알려주고 종료하세요.

## 2. API 호출
공개 API를 호출하세요.
환경 변수 $MY_API_TOKEN을 헤더에 포함하세요.
예: curl -H "Authorization: Bearer $MY_API_TOKEN"

## 3. 결과 표시
응답을 보기 좋게 정리해서 보여주세요.
SKILLEOF
```

---

## 📚 핵심 정리

### 환경 변수 사용 이유

**나쁜 방법:**
```bash
curl -H "Authorization: Bearer abc123xyz" https://api.example.com
```
→ 토큰이 코드에 노출, Git에 커밋되면 위험

**좋은 방법:**
```bash
curl -H "Authorization: Bearer $MY_TOKEN" https://api.example.com
```
→ 토큰이 코드 밖에 있음, 안전

### 환경 변수 패턴

```bash
# 1. 설정 (~/.bashrc 또는 ~/.zshrc)
export VAR_NAME="value"

# 2. 적용
source ~/.bashrc

# 3. Skill에서 사용
$VAR_NAME
```

### API 호출 기본 패턴

```
1. 환경 변수 확인 (있는지 체크)
2. API 호출 (curl 사용)
3. 결과 표시 (보기 좋게)
```

### 보안 원칙

- ✅ 토큰은 절대 코드에 넣지 않기
- ✅ 환경 변수 사용
- ✅ Git에 토큰 파일 커밋하지 않기

---

## 🎉 완료!

환경 변수를 사용해서 안전하게 API를 호출하는 방법을 배웠습니다!

**배운 것:**
- ✅ 환경 변수가 필요한 이유
- ✅ 환경 변수 설정 방법
- ✅ Skill에서 환경 변수 사용
- ✅ 간단한 API 호출

**핵심 개념:**
- 민감한 정보(토큰, 비밀번호)는 환경 변수로 관리
- 코드에는 환경 변수 이름만 사용 ($MY_TOKEN)
- 실제 값은 각자의 로컬 환경에만 존재

### 다음 단계

[Step 5: 검색 Skill 만들기 →](step-05-search-tool)
{: .btn .btn-primary }
