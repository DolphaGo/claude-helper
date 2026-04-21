---
layout: default
title: "고급 5: Headless 모드"
nav_order: 14
parent: 고급 개념
---

# Headless 모드로 자동화하기
{: .no_toc }

⏱️ 20분
{: .label .label-red }

대화형 인터페이스 없이 프로그래밍 방식으로 Claude Code를 실행하는 방법을 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 Headless 모드란?

**Headless 모드**는 대화형 인터페이스 없이 명령줄에서 직접 Claude Code를 실행하는 방식입니다.

### 일반 모드 vs Headless 모드

**일반 모드 (대화형):**
```
┌─────────────────────────────────────┐
│  사용자                              │
└─────────────────────────────────────┘
         ↓ "Git 커밋 요약해줘"
┌─────────────────────────────────────┐
│  Claude Code (대화형 세션)           │
│  - 대화 유지                         │
│  - 컨텍스트 누적                     │
│  - 추가 질문 가능                    │
└─────────────────────────────────────┘
         ↓ 응답 표시
┌─────────────────────────────────────┐
│  결과: "최근 3개 커밋..."            │
└─────────────────────────────────────┘
         ↓ 다음 명령 대기
```

**Headless 모드 (일회성):**
```
┌─────────────────────────────────────┐
│  스크립트/자동화                     │
└─────────────────────────────────────┘
         ↓ claude headless "..."
┌─────────────────────────────────────┐
│  Claude Code (일회성 실행)           │
│  - 즉시 실행                         │
│  - 결과만 반환                       │
│  - 종료                              │
└─────────────────────────────────────┘
         ↓ stdout으로 출력
┌─────────────────────────────────────┐
│  결과: "최근 3개 커밋..."            │
│  → 파일 저장 / 파이프 가능           │
└─────────────────────────────────────┘
```

**비교:**

| 기능 | 일반 모드 | Headless 모드 |
|------|----------|--------------|
| 실행 | `claude` | `claude headless "..."` |
| 대화 | 가능 | 불가 |
| 컨텍스트 | 누적 | 일회성 |
| 출력 | 터미널 | stdout (파이프 가능) |
| 용도 | 개발 작업 | 자동화/CI/CD |

### 언제 사용하나?

**자동화 스크립트:**
- CI/CD 파이프라인
- Git hooks
- 배포 스크립트
- 정기 작업

**프로그래밍 통합:**
- 다른 도구와 연동
- 결과를 파일로 저장
- 조건부 실행

---

## 📋 기본 사용법

### 단일 프롬프트 실행

```bash
claude headless "현재 Git 브랜치를 알려줘"
```

**출력:**
```
현재 브랜치는 main입니다.
```

### 결과를 파일로 저장

```bash
claude headless "지난 주 커밋을 요약해줘" > weekly-report.md
```

### 프로젝트 지정

```bash
claude headless --cwd /path/to/project "테스트를 실행해줘"
```

---

## 💡 실용적인 예제

### 예제 1: Git Hook 통합

**pre-commit hook:**

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "코드 검사 중..."

result=$(claude headless "staged 파일들을 검사하고, 문제가 있으면 'ERROR:'로 시작하는 메시지를 출력해줘")

if echo "$result" | grep -q "ERROR:"; then
  echo "$result"
  exit 1
fi

echo "검사 완료!"
```

**효과:**
커밋 전에 자동으로 코드를 검사하고, 문제가 있으면 커밋을 중단합니다.

### 예제 2: CI/CD 통합

**GitHub Actions:**

```yaml
name: Code Review

on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Install Claude Code
        run: npm install -g @anthropic/claude-code
      
      - name: Review Code
        run: |
          claude headless "
            PR의 변경사항을 리뷰하고 다음 형식으로 출력해줘:
            ## 주요 변경사항
            [요약]
            
            ## 개선 제안
            [제안 사항]
          " > review.md
      
      - name: Post Comment
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: review
            });
```

**효과:**
PR이 생성되면 자동으로 코드를 리뷰하고 코멘트를 남깁니다.

### 예제 3: 정기 리포트 생성

```bash
#!/bin/bash
# weekly-report.sh

DATE=$(date +%Y-%m-%d)

claude headless "
지난 주 ($(date -d '7 days ago' +%Y-%m-%d) ~ $DATE) 의 개발 활동을 분석해줘:

1. 완료된 기능 (커밋 메시지 기반)
2. 수정된 버그
3. 추가된 테스트
4. 코드 변경 통계

마크다운 형식으로 작성해줘.
" > "reports/weekly-$DATE.md"

echo "리포트가 생성되었습니다: reports/weekly-$DATE.md"
```

**Cron 설정:**

```bash
# 매주 월요일 오전 9시 실행
0 9 * * 1 /path/to/weekly-report.sh
```

### 예제 4: 배포 전 검증

```bash
#!/bin/bash
# pre-deploy.sh

echo "배포 전 검증 중..."

# 테스트 실행 확인
claude headless "테스트를 실행하고, 모두 통과하면 'SUCCESS', 실패하면 'FAILED'를 출력해줘" > test-result.txt

if grep -q "FAILED" test-result.txt; then
  echo "❌ 테스트 실패! 배포를 중단합니다."
  cat test-result.txt
  exit 1
fi

# 보안 검사
claude headless "코드에서 하드코딩된 비밀번호나 토큰을 찾고, 발견되면 'SECURITY ISSUE'를 출력해줘" > security-check.txt

if grep -q "SECURITY ISSUE" security-check.txt; then
  echo "❌ 보안 문제 발견! 배포를 중단합니다."
  cat security-check.txt
  exit 1
fi

echo "✅ 검증 완료! 배포를 진행할 수 있습니다."
```

---

## 🎨 고급 기법

### 여러 프롬프트 순차 실행

```bash
#!/bin/bash

# 1단계: 분석
claude headless "코드 변경사항을 분석해줘" > analysis.md

# 2단계: 분석 결과를 바탕으로 테스트 제안
claude headless "analysis.md의 내용을 바탕으로 추가해야 할 테스트를 제안해줘" > test-plan.md

# 3단계: 리포트 생성
claude headless "analysis.md와 test-plan.md를 종합해서 최종 리포트를 작성해줘" > final-report.md
```

### 조건부 실행

```bash
#!/bin/bash

# Git 상태 확인
status=$(claude headless "변경된 파일이 있으면 'YES', 없으면 'NO'를 출력해줘")

if [ "$status" = "YES" ]; then
  echo "변경 사항 발견. 커밋을 생성합니다."
  claude headless "변경사항을 분석하고 적절한 커밋 메시지를 작성한 후 커밋해줘"
else
  echo "변경 사항 없음."
fi
```

### 결과 파싱

```bash
#!/bin/bash

# JSON 형식으로 결과 받기
claude headless "
현재 프로젝트의 통계를 JSON 형식으로 출력해줘:
{
  \"files\": 파일 개수,
  \"lines\": 총 라인 수,
  \"tests\": 테스트 파일 개수
}
" > stats.json

# jq로 파싱
FILE_COUNT=$(cat stats.json | jq -r '.files')
echo "프로젝트에는 총 $FILE_COUNT 개의 파일이 있습니다."
```

---

## 🔧 Skill과 연동

Headless 모드에서도 Skill을 사용할 수 있습니다.

### 예제: Skill 직접 호출

```bash
claude headless "/my-first-plugin:gs"
```

### 예제: 자동화 스크립트

```bash
#!/bin/bash
# daily-check.sh

echo "=== 일일 점검 시작 ==="

# Git 상태
echo "## Git 상태"
claude headless "/my-first-plugin:gs"

# 테스트 실행
echo "## 테스트 결과"
claude headless "/auto-test"

# 코드 품질
echo "## 코드 품질"
claude headless "TODO 주석을 찾아서 목록으로 정리해줘"

echo "=== 점검 완료 ==="
```

---

## 📚 핵심 정리

### 기본 명령어

```bash
# 단순 실행
claude headless "프롬프트"

# 프로젝트 지정
claude headless --cwd /path/to/project "프롬프트"

# 결과 저장
claude headless "프롬프트" > output.txt

# 에러도 함께 저장
claude headless "프롬프트" &> output.txt
```

### 종료 코드

Headless 모드는 종료 코드를 반환합니다:

```bash
claude headless "..."
echo $?  # 0: 성공, 1: 실패
```

스크립트에서 활용:

```bash
if claude headless "테스트 실행"; then
  echo "성공"
else
  echo "실패"
  exit 1
fi
```

### 환경 변수

```bash
# API 키 설정 (필요한 경우)
export ANTHROPIC_API_KEY="your-api-key"

# 프로젝트 디렉토리
export CLAUDE_PROJECT_DIR="/path/to/project"

claude headless "프롬프트"
```

---

## 🎓 실전 패턴

### 패턴 1: 자동 코드 리뷰

```bash
#!/bin/bash
# auto-review.sh

if [ -z "$1" ]; then
  echo "사용법: ./auto-review.sh <브랜치명>"
  exit 1
fi

BRANCH=$1

git checkout $BRANCH

claude headless "
이 브랜치의 변경사항을 리뷰해줘:
1. 코드 품질
2. 잠재적 버그
3. 개선 제안

각 항목은 ## 제목 형식으로 구분해줘.
" > "reviews/review-$BRANCH.md"

echo "리뷰 완료: reviews/review-$BRANCH.md"
```

### 패턴 2: 자동 문서화

```bash
#!/bin/bash
# update-docs.sh

# 각 주요 파일에 대한 문서 생성
for file in src/**/*.ts; do
  output="docs/$(basename $file .ts).md"
  
  claude headless "
    $file 파일을 분석하고 다음 형식으로 문서를 작성해줘:
    
    # $(basename $file)
    
    ## 목적
    [파일의 역할]
    
    ## 주요 함수
    [함수 목록과 설명]
    
    ## 사용 예제
    [코드 예제]
  " > "$output"
  
  echo "문서 생성: $output"
done
```

### 패턴 3: CI 통합

```bash
#!/bin/bash
# ci-check.sh

set -e  # 에러 시 중단

echo "1. 코드 스타일 검사"
claude headless "코드 스타일 가이드를 위반한 파일이 있는지 확인하고, 있으면 파일 목록을 출력해줘"

echo "2. 테스트 커버리지 확인"
claude headless "테스트 커버리지를 확인하고, 80% 미만이면 'LOW COVERAGE'를 출력해줘" | tee coverage.txt

if grep -q "LOW COVERAGE" coverage.txt; then
  echo "❌ 테스트 커버리지 부족"
  exit 1
fi

echo "3. 보안 검사"
claude headless "보안 취약점이 있는지 검사하고, 발견되면 'VULNERABILITY FOUND'를 출력해줘" | tee security.txt

if grep -q "VULNERABILITY FOUND" security.txt; then
  echo "❌ 보안 취약점 발견"
  exit 1
fi

echo "✅ 모든 검사 통과"
```

---

## ⚠️ 주의사항

### 대화형 프롬프트 피하기

**나쁜 예:**
```bash
claude headless "파일을 수정할까요?"
```

Headless 모드는 자동으로 실행되므로 질문을 해서는 안 됩니다.

**좋은 예:**
```bash
claude headless "다음 조건에 맞으면 파일을 수정해줘: [조건]"
```

### 실행 시간

너무 오래 걸리는 작업은 타임아웃을 설정하세요:

```bash
timeout 5m claude headless "오래 걸리는 작업"
```

### 에러 처리

항상 에러를 처리하세요:

```bash
if ! claude headless "프롬프트"; then
  echo "에러 발생!"
  # 복구 로직 또는 알림
  exit 1
fi
```

### 출력 형식

일관된 형식으로 출력을 요청하세요:

```bash
claude headless "
결과를 다음 형식으로 출력해줘:
STATUS: [SUCCESS 또는 FAILED]
MESSAGE: [메시지]
"
```

---

## 🔍 디버깅

### 상세 로그 보기

```bash
claude headless --verbose "프롬프트"
```

### 드라이런 (실제 실행 없이 확인)

```bash
claude headless --dry-run "프롬프트"
```

### 로그 파일 저장

```bash
claude headless "프롬프트" 2> error.log
```

---

## ✅ 완료

Headless 모드로 Claude Code를 프로그래밍 방식으로 실행하는 방법을 배웠습니다!

**배운 것:**
- ✅ Headless 모드 개념
- ✅ 기본 사용법
- ✅ CI/CD 통합
- ✅ Git hooks 연동
- ✅ 자동화 스크립트 작성
- ✅ 에러 처리

**핵심 개념:**
- 대화형 인터페이스 없이 실행
- 스크립트와 자동화에 적합
- 결과를 파일로 저장하거나 파싱 가능
- CI/CD, Git hooks 등과 통합 가능

**다음에는:**
Sub-agents를 만들어서 사용자 정의 하위 에이전트를 활용하는 방법을 배웁니다.

### 다음 단계

[고급 6: Sub-agents →](advanced-06-subagents)
{: .btn .btn-primary }
