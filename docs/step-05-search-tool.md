---
layout: default
title: "Step 5: 검색 도구"
nav_order: 7
---

# Step 5: 코드 검색 도구
{: .no_toc }

⏱️ 15분
{: .label .label-purple }

실전 예제: 프로젝트에서 코드 패턴을 찾고 한글을 처리합니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

**만들 것:** 프로젝트 코드에서 패턴을 검색하는 skill

**기능:**
- 키워드 검색
- 정규식 지원
- 한글 처리
- 파일 타입 필터

---

## 📝 기본 검색 Skill

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/search.md << 'EOF'
---
name: search
description: 코드에서 패턴 검색
aliases: [find, grep]
---

# Code Search

프로젝트에서 코드 패턴을 검색합니다.

## 사용법

```
/search [검색어]
```

## 실행

```bash
# ripgrep 사용 (빠름)
if command -v rg > /dev/null; then
  rg "[검색어]" --type js --type ts
else
  # grep 폴백
  grep -r "[검색어]" . \
    --include="*.js" \
    --include="*.ts" \
    --exclude-dir=node_modules \
    --exclude-dir=.git
fi
```

## 출력 형식

```
🔍 "[검색어]" 검색 결과

📁 src/utils.js:23
  22: export function helper() {
  23:   const [검색어] = useState();  ← 발견!
  24:   return ...

📁 src/app.js:45
  44: // [검색어] 관련 로직
  45: function process[검색어]() {  ← 발견!
  46:   ...

💡 총 2개 파일에서 5건 발견
```
EOF
````

---

## 🇰🇷 한글 검색 지원

### 문제점

```bash
# 한글 검색이 안 되는 경우
grep "한글" file.js
# → 깨지거나 안 나옴
```

### 해결: 인코딩 처리

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/search.md << 'EOF'
---
name: search
description: 한글 지원 코드 검색
---

# Code Search (한글 지원)

## 인코딩 확인

```bash
# 파일 인코딩 감지
file --mime-encoding *.js | head -5

# EUC-KR 파일이 있는지 확인
if file *.js | grep -q "ISO-8859\|EUC-KR"; then
  echo "⚠️  인코딩 변환이 필요할 수 있습니다"
fi
```

## UTF-8로 검색

```bash
# LC_ALL 설정으로 UTF-8 강제
LC_ALL=ko_KR.UTF-8 rg "[검색어]" \
  --type js \
  --type ts \
  --type md
```

## 한글 패턴 검색

```bash
# 한글 변수명 찾기
rg "const [가-힣]+ =" --type js

# 한글 주석 찾기
rg "//.*[가-힣]+" --type js

# 한글 문자열 찾기
rg '"[^"]*[가-힣]+[^"]*"' --type js
```

## 결과 출력

한글이 포함된 결과를 이쁘게:

```
🔍 한글 검색: "[검색어]"

📁 src/auth.js:12
  11: // 사용자 로그인 처리
  12: const 로그인상태 = false;  ← 한글 변수명
  13: 

📁 README.md:45
  44: ## 로그인 기능
  45: 사용자 인증을 처리합니다.  ← 한글 문서
  46: 

✅ 한글이 올바르게 표시됨
💡 2개 파일에서 2건 발견
```
EOF
````

---

## 🎯 고급 검색 기능

### 파일 타입별 검색

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/search.md << 'EOF'
---
name: search
description: 고급 코드 검색
---

# Advanced Code Search

## 옵션

사용자에게 질문:

1. **검색어가 무엇인가요?**
2. **파일 타입을 지정하시겠습니까?**
   - JavaScript/TypeScript
   - Python
   - 전체

3. **검색 옵션**
   - 대소문자 구분
   - 정규식 사용
   - 숨김 파일 포함

## 검색 실행

### JavaScript/TypeScript

```bash
rg "$query" \
  --type js \
  --type jsx \
  --type ts \
  --type tsx \
  --glob '!node_modules' \
  --glob '!dist'
```

### Python

```bash
rg "$query" \
  --type py \
  --glob '!__pycache__' \
  --glob '!*.pyc'
```

### 정규식 모드

```bash
# 이메일 패턴
rg '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'

# 전화번호 패턴
rg '\d{3}-\d{4}-\d{4}'

# 한글 + 영문 조합
rg '[가-힣]+[a-zA-Z]+'
```

## 결과 필터링

### 파일명만

```bash
rg "$query" --files-with-matches
```

### 카운트만

```bash
rg "$query" --count
```

### 컨텍스트 포함

```bash
# 앞뒤 3줄씩
rg "$query" -C 3

# 앞 5줄
rg "$query" -B 5

# 뒤 2줄
rg "$query" -A 2
```

## 출력

사용자가 선택한 옵션에 따라 다르게 출력:

```
🔍 검색: "$query"
📋 옵션: [선택된 옵션들]

[결과...]

📊 통계:
  - 파일: X개
  - 매칭: Y건
  - 소요 시간: Zms
```
EOF
````

---

## 🔥 실전 검색 패턴

### TODO 찾기

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/find-todos.md << 'EOF'
---
name: find-todos
description: TODO/FIXME 주석 찾기
aliases: [todos, todo-list]
---

# Find TODOs

프로젝트의 모든 TODO를 찾습니다.

## 검색

```bash
rg "TODO|FIXME|HACK|XXX|NOTE" \
  --type js --type ts --type py \
  --no-heading \
  --with-filename \
  --line-number
```

## 분류

```bash
# TODO 개수
todo_count=$(rg "TODO" --count | awk '{s+=$1}END{print s}')

# FIXME 개수
fixme_count=$(rg "FIXME" --count | awk '{s+=$1}END{print s}')

# 파일별 카운트
rg "TODO|FIXME" --count --sort path
```

## 출력

```
📝 TODO 리스트

## 🔴 FIXME (긴급) - 3건

📁 src/auth.js:45
  // FIXME: 보안 취약점 수정 필요

📁 src/api.js:123
  // FIXME: 에러 처리 추가


## 🟡 TODO (일반) - 12건

📁 src/utils.js:34
  // TODO: 성능 최적화

📁 README.md:100
  <!-- TODO: API 문서 작성 -->

...

📊 요약:
  - FIXME: 3건 (우선 처리 필요)
  - TODO: 12건
  - HACK: 1건
  - 총 16건
```
EOF
````

### 함수/클래스 찾기

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/find-functions.md << 'EOF'
---
name: find-functions
description: 함수/클래스 정의 찾기
---

# Find Functions & Classes

## JavaScript/TypeScript

```bash
# 함수 선언
rg "function\s+\w+" --type js

# Arrow 함수
rg "const\s+\w+\s*=\s*\(" --type js

# 클래스
rg "class\s+\w+" --type js

# Export된 함수
rg "export\s+(function|const|class)" --type js
```

## Python

```bash
# 함수
rg "def\s+\w+" --type py

# 클래스
rg "class\s+\w+" --type py

# 데코레이터
rg "@\w+" --type py
```

## 출력

```
🔍 함수 및 클래스 정의

## 📦 Classes (5개)

src/User.js:
  class User
  
src/Auth.js:
  class AuthService

## 🔧 Functions (23개)

src/utils.js:
  function formatDate
  function validateEmail
  const parseJSON = () => ...

📊 총 28개 정의 발견
```
EOF
```

---

## 🛠️ 검색 도구 비교

| 도구 | 속도 | 기능 | 설치 |
|:-----|:-----|:-----|:-----|
| **ripgrep (rg)** | ⚡⚡⚡ 매우 빠름 | ⭐⭐⭐ 풍부 | brew install ripgrep |
| **grep** | ⚡⚡ 보통 | ⭐⭐ 기본 | 기본 설치 |
| **ag** | ⚡⚡ 빠름 | ⭐⭐⭐ 좋음 | brew install ag |
| **ack** | ⚡ 느림 | ⭐⭐ 기본 | brew install ack |

**추천:** ripgrep (rg)

---

## 📚 핵심 정리

### 검색 패턴

```bash
# 1. 기본 검색
rg "keyword"

# 2. 파일 타입 지정
rg "keyword" --type js

# 3. 디렉토리 제외
rg "keyword" --glob '!node_modules'

# 4. 정규식
rg "pattern.*regex"

# 5. 대소문자 무시
rg "keyword" -i

# 6. 단어 단위
rg "keyword" -w
```

### 한글 처리

```bash
# UTF-8 강제
LC_ALL=ko_KR.UTF-8 rg "한글"

# 한글 패턴
rg "[가-힣]+"

# 인코딩 확인
file --mime-encoding *.js
```

---

## ✅ 연습 문제

### 과제: 민감 정보 찾기

**요구사항:**
- API 키, 비밀번호, 토큰 검색
- 파일 경로와 라인 번호
- 보안 경고

**패턴:**
```regex
API_KEY
password\s*=
token\s*=
secret
```

<details>
<summary>정답 보기</summary>

````bash
cat > ~/.claude/plugins/my-first-plugin/skills/find-secrets.md << 'EOF'
---
name: find-secrets
description: 민감 정보 검색 (보안)
---

# Find Secrets

## 검색 패턴

```bash
rg "API_KEY|SECRET|PASSWORD|TOKEN" \
  --ignore-case \
  --type js --type ts --type py \
  --glob '!*.md' \
  --glob '!test/*'
```

## 출력

```
🔐 민감 정보 검색 결과

⚠️  경고: 다음 파일에 민감 정보가 포함되어 있을 수 있습니다

📁 src/config.js:12
  const API_KEY = "abc123..."  ← 하드코딩된 키!

💡 권장사항:
  - .gitignore에 추가
  - 환경 변수로 이동
  - Secrets Manager 사용
```
EOF
````

</details>

---

## 🎉 완료!

강력한 코드 검색 도구를 만들었습니다!

**배운 것:**
- ✅ ripgrep 활용
- ✅ 한글 처리
- ✅ 정규식 패턴
- ✅ 실전 검색 예제

[Step 6: 플러그인 배포 →](step-06-publish)
{: .btn .btn-primary }
