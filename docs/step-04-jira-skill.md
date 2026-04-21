---
layout: default
title: "Step 4: Jira Skill"
nav_order: 6
---

# Step 4: Jira 티켓 생성 Skill
{: .no_toc }

⏱️ 20분
{: .label .label-blue }

실전 예제: 외부 API를 호출하여 Jira 티켓을 생성합니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

**만들 것:** Jira에 버그 티켓을 자동으로 생성하는 skill

**배울 것:**
- API 호출 (curl)
- 인증 처리 (환경 변수)
- JSON 데이터 구성
- 에러 처리

---

## 📋 사전 준비

### Jira API 토큰 발급

1. Jira → Settings → Personal Access Tokens
2. Create token
3. 복사해두기

### 환경 변수 설정

```bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export JIRA_URL="https://your-company.atlassian.net"
export JIRA_EMAIL="your-email@company.com"
export JIRA_TOKEN="your-api-token-here"
export JIRA_PROJECT="PROJ"  # 프로젝트 키
```

**적용:**
```bash
source ~/.bashrc  # 또는 ~/.zshrc
```

**확인:**
```bash
echo $JIRA_URL
echo $JIRA_EMAIL
```

---

## 📝 기본 버전 만들기

### 파일 생성

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/jira-bug.md << 'EOF'
---
name: jira-bug
description: Jira에 버그 티켓 생성
aliases: [bug, create-bug]
---

# Jira Bug 티켓 생성

## 사용법

```
/jira-bug

사용자가 버그 내용을 설명하면:
1. 제목 추출
2. 설명 정리
3. Jira API로 티켓 생성
4. 링크 반환
```

## 사전 확인

환경 변수가 설정되어 있는지 확인:

```bash
if [ -z "$JIRA_URL" ] || [ -z "$JIRA_EMAIL" ] || [ -z "$JIRA_TOKEN" ]; then
  echo "❌ Jira 환경 변수가 설정되지 않았습니다"
  echo ""
  echo "다음 변수를 설정하세요:"
  echo "  JIRA_URL"
  echo "  JIRA_EMAIL"
  echo "  JIRA_TOKEN"
  echo "  JIRA_PROJECT"
  exit 1
fi

echo "✅ Jira 설정 확인 완료"
echo "   URL: $JIRA_URL"
echo "   Project: $JIRA_PROJECT"
```

## 티켓 생성

사용자로부터 다음 정보를 받습니다:
1. **제목**: 버그를 한 줄로 요약
2. **설명**: 버그 재현 방법, 예상 동작, 실제 동작
3. **우선순위**: High / Medium / Low

정보를 받으면 Jira API를 호출합니다:

```bash
curl -X POST "$JIRA_URL/rest/api/3/issue" \
  -H "Content-Type: application/json" \
  -u "$JIRA_EMAIL:$JIRA_TOKEN" \
  -d '{
    "fields": {
      "project": {
        "key": "'"$JIRA_PROJECT"'"
      },
      "summary": "[제목]",
      "description": {
        "type": "doc",
        "version": 1,
        "content": [
          {
            "type": "paragraph",
            "content": [
              {
                "type": "text",
                "text": "[설명]"
              }
            ]
          }
        ]
      },
      "issuetype": {
        "name": "Bug"
      },
      "priority": {
        "name": "[우선순위]"
      }
    }
  }'
```

## 결과 출력

성공하면:
```
✅ Jira 티켓 생성 완료!

🎫 티켓: PROJ-123
🔗 링크: https://your-company.atlassian.net/browse/PROJ-123
📝 제목: [제목]
⚠️  우선순위: High
```

실패하면:
```
❌ 티켓 생성 실패

원인: [에러 메시지]
```
EOF
```

---

## 🔧 대화형으로 개선

사용자와 대화하며 정보를 수집하는 버전:

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/jira-bug.md << 'EOF'
---
name: jira-bug
description: 대화형 Jira 버그 티켓 생성
aliases: [bug]
---

# Jira Bug 티켓 생성 (대화형)

사용자와 대화하며 버그 티켓을 생성합니다.

## Step 1: 환경 확인

```bash
if [ -z "$JIRA_URL" ]; then
  echo "❌ JIRA_URL이 설정되지 않았습니다"
  exit 1
fi
echo "✅ Jira: $JIRA_URL"
```

## Step 2: 정보 수집

사용자에게 질문:

### 1. 버그 제목이 무엇인가요?
> 예: "로그인 시 세션 만료 에러"

### 2. 버그를 재현하는 방법은?
> 예:
> 1. 로그인
> 2. 10분 대기
> 3. 페이지 새로고침
> 4. "세션 만료" 에러 발생

### 3. 예상 동작은?
> 예: 자동으로 재로그인되어야 함

### 4. 실제 동작은?
> 예: 에러 페이지로 이동

### 5. 우선순위는? (High/Medium/Low)
> 예: High

## Step 3: 티켓 생성

위에서 수집한 정보로 JSON 구성:

```json
{
  "제목": "[1번 답변]",
  "설명": "
## 재현 방법
[2번 답변]

## 예상 동작
[3번 답변]

## 실제 동작
[4번 답변]
  ",
  "우선순위": "[5번 답변]"
}
```

그리고 curl로 API 호출 (위와 동일)

## Step 4: 확인

생성된 티켓을 사용자에게 보여주고:

```
티켓을 확인하시겠습니까?
→ 브라우저에서 열기
→ 추가 정보 입력
→ 완료
```
EOF
```

---

## 🎨 템플릿 기능 추가

자주 쓰는 버그 타입을 템플릿으로:

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/jira-bug.md << 'EOF'
---
name: jira-bug
description: Jira 버그 티켓 (템플릿 지원)
---

# Jira Bug with Templates

## 템플릿 선택

어떤 타입의 버그인가요?

1. **프론트엔드 버그**
   - UI/UX 이슈
   - 렌더링 문제
   
2. **백엔드 버그**
   - API 에러
   - 데이터베이스 이슈
   
3. **성능 문제**
   - 느린 로딩
   - 메모리 누수
   
4. **보안 이슈**
   - 취약점
   - 인증/인가 문제

## 템플릿 내용

### 1. 프론트엔드 버그

```
제목: [FE] [페이지명] [증상]

## 환경
- 브라우저: Chrome / Safari / Firefox
- OS: macOS / Windows
- 버전: 

## 재현 방법
1. 
2. 
3. 

## 스크린샷
[첨부 필요]

## 예상: 
## 실제: 
```

### 2. 백엔드 버그

```
제목: [BE] [API명] [증상]

## 환경
- 서버: Production / Staging
- 시간: 

## API 정보
- Endpoint: 
- Method: 
- Payload: 

## 에러 로그
```
[로그 내용]
```

## 예상: 
## 실제: 
```

### 3. 성능 문제

```
제목: [PERF] [기능명] [증상]

## 측정값
- 로딩 시간: Xs
- 메모리 사용: XMB
- CPU: X%

## 임계값
- 예상: 
- 실제: 

## 프로파일링
[분석 결과]
```

### 4. 보안 이슈

```
제목: [SEC] [취약점 타입] 발견

⚠️  보안 이슈는 비공개로 생성됩니다

## 취약점
- 타입: 
- 위치: 
- 심각도: Critical / High / Medium

## 영향 범위
- 

## 임시 조치
- 

## 제안 해결책
- 
```

## 티켓 생성

선택한 템플릿에 내용을 채워서 Jira API로 전송합니다.
EOF
```

---

## 🔐 보안 주의사항

### 1. 토큰 보호

```bash
# ❌ 나쁜 예: 코드에 직접
JIRA_TOKEN="abc123..."

# ✅ 좋은 예: 환경 변수
JIRA_TOKEN="$JIRA_TOKEN"
```

### 2. Git에 올리지 않기

```.gitignore
# 환경 변수 파일
.env
.env.local

# 토큰 파일
*token*
*secret*
```

### 3. 팀 공유 시

```bash
# 토큰 없이 공유
# README에 설정 방법만 안내

## Jira 연동 설정

1. 토큰 발급: https://...
2. 환경 변수 설정:
   ```
   export JIRA_TOKEN="your-token"
   ```
```

---

## 🧪 테스트

### Dry-run 모드

실제로 생성하지 않고 확인만:

```bash
# --dry-run 플래그 추가
if [ "$1" = "--dry-run" ]; then
  echo "🔍 Dry-run 모드"
  echo "다음 내용으로 티켓이 생성됩니다:"
  echo "$json_payload" | jq
  exit 0
fi
```

### 로컬 테스트

```bash
# 테스트 서버에 생성
export JIRA_URL="https://test.atlassian.net"
export JIRA_PROJECT="TEST"
```

---

## 📚 핵심 정리

### API 호출 패턴

```bash
# 1. 환경 변수 확인
[ -z "$TOKEN" ] && echo "에러" && exit 1

# 2. JSON 구성
json=$(cat <<EOF
{
  "field": "value"
}
EOF
)

# 3. curl 호출
response=$(curl -X POST $URL \
  -H "Content-Type: application/json" \
  -u "$EMAIL:$TOKEN" \
  -d "$json")

# 4. 결과 파싱
issue_key=$(echo "$response" | jq -r '.key')
```

### 에러 처리

```bash
# HTTP 상태 코드 확인
status=$(curl -w "%{http_code}" -o /dev/null -s $URL)

if [ "$status" -eq 200 ]; then
  echo "✅ 성공"
elif [ "$status" -eq 401 ]; then
  echo "❌ 인증 실패: 토큰 확인"
elif [ "$status" -eq 404 ]; then
  echo "❌ 엔드포인트 없음"
else
  echo "❌ 에러: $status"
fi
```

---

## ✅ 연습 문제

### 과제: GitHub Issue 생성

**요구사항:**
- Jira 대신 GitHub
- GitHub Personal Access Token 사용
- Label 추가 (bug, enhancement 등)

**API:**
```bash
POST /repos/:owner/:repo/issues
```

<details>
<summary>힌트</summary>

```bash
curl -X POST \
  https://api.github.com/repos/owner/repo/issues \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d '{
    "title": "...",
    "body": "...",
    "labels": ["bug"]
  }'
```

</details>

---

## 🎉 완료!

외부 API를 호출하는 실전 skill을 만들었습니다!

**배운 것:**
- ✅ API 호출 (curl)
- ✅ 인증 처리
- ✅ JSON 구성
- ✅ 대화형 인터페이스
- ✅ 보안 주의사항

[Step 5: 코드 검색 도구 →](step-05-search-tool)
{: .btn .btn-primary }
