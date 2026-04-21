---
layout: default
title: "고급 5: 프로그래밍 방식 실행"
nav_order: 14
parent: 고급 개념
---

# 프로그래밍 방식으로 Claude Code 실행하기
{: .no_toc }

⏱️ 20분
{: .label .label-red }

대화형 인터페이스 없이 스크립트, CI/CD, 자동화 파이프라인에서 Claude Code를 실행하는 방법을 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 프로그래밍 방식 실행이란?

**프로그래밍 방식 실행**은 대화형 인터페이스 없이 명령줄에서 직접 Claude Code를 실행하는 방식입니다. `-p` 또는 `--print` 플래그를 사용하면 Claude가 작업을 완료하고 결과를 출력한 후 즉시 종료됩니다.

### 일반 모드 vs 프로그래밍 방식 실행

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

**프로그래밍 방식 실행 (일회성):**
```
┌─────────────────────────────────────┐
│  스크립트/자동화                     │
└─────────────────────────────────────┘
         ↓ claude -p "..."
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

| 기능 | 일반 모드 | 프로그래밍 방식 |
|------|----------|----------------|
| 실행 | `claude` | `claude -p "..."` |
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

`-p` 또는 `--print` 플래그를 사용하면 대화형 모드 없이 결과를 출력하고 종료합니다:

```bash
claude -p "현재 Git 브랜치를 알려줘"
```

**출력:**
```
현재 브랜치는 main입니다.
```

### 결과를 파일로 저장

표준 리다이렉션을 사용하여 결과를 파일로 저장할 수 있습니다:

```bash
claude -p "지난 주 커밋을 요약해줘" > weekly-report.md
```

### stdin에서 입력 받기

파이프를 통해 데이터를 전달할 수 있습니다:

```bash
cat logs.txt | claude -p "이 로그에서 에러를 찾아줘"

# 또는 Git 출력 분석
git diff | claude -p "이 변경사항을 요약해줘"
```

---

## 💡 실용적인 예제

### 예제 1: Git Hook 통합

**pre-commit hook:**

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "코드 검사 중..."

result=$(claude -p "staged 파일들을 검사하고, 문제가 있으면 'ERROR:'로 시작하는 메시지를 출력해줘")

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
      
      - name: Setup Claude Code
        run: curl -fsSL https://claude.ai/install.sh | bash
      
      - name: Review Code
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude -p "
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

**참고:** CI/CD에서는 `ANTHROPIC_API_KEY` 환경 변수를 설정해야 합니다.

### 예제 3: 정기 리포트 생성

```bash
#!/bin/bash
# weekly-report.sh

DATE=$(date +%Y-%m-%d)

claude -p "
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

**또는 Claude Code의 예약 작업 사용:**

```bash
# 클라우드에서 실행되는 예약 작업 생성
claude
> /schedule weekly "Generate weekly development report"
```

### 예제 4: 배포 전 검증

```bash
#!/bin/bash
# pre-deploy.sh

echo "배포 전 검증 중..."

# 테스트 실행 확인
claude -p "테스트를 실행하고, 모두 통과하면 'SUCCESS', 실패하면 'FAILED'를 출력해줘" > test-result.txt

if grep -q "FAILED" test-result.txt; then
  echo "❌ 테스트 실패! 배포를 중단합니다."
  cat test-result.txt
  exit 1
fi

# 보안 검사
claude -p "코드에서 하드코딩된 비밀번호나 토큰을 찾고, 발견되면 'SECURITY ISSUE'를 출력해줘" > security-check.txt

if grep -q "SECURITY ISSUE" security-check.txt; then
  echo "❌ 보안 문제 발견! 배포를 중단합니다."
  cat security-check.txt
  exit 1
fi

echo "✅ 검증 완료! 배포를 진행할 수 있습니다."
```

---

## 🎨 고급 기법

### 세션 연속성 유지

`-c` 또는 `--continue` 플래그로 이전 세션의 컨텍스트를 유지할 수 있습니다:

```bash
#!/bin/bash

# 1단계: 분석 (세션 생성)
claude -p "코드 변경사항을 분석해줘" > analysis.md

# 2단계: 같은 세션에서 계속 (컨텍스트 유지)
claude -c -p "이제 추가해야 할 테스트를 제안해줘" > test-plan.md

# 3단계: 여전히 같은 세션
claude -c -p "분석과 테스트 계획을 종합해서 최종 리포트를 작성해줘" > final-report.md
```

### 출력 형식 지정

`--output-format` 플래그로 구조화된 출력을 받을 수 있습니다:

```bash
# JSON 형식으로 출력
claude -p "현재 프로젝트 통계를 분석해줘" --output-format json > stats.json

# JSON 스트리밍 (실시간 이벤트)
claude -p "테스트 실행" --output-format stream-json
```

### 구조화된 JSON 출력

`--json-schema` 플래그로 특정 스키마를 따르는 JSON을 받을 수 있습니다:

```bash
claude -p --json-schema '{
  "type": "object",
  "properties": {
    "files": {"type": "number"},
    "lines": {"type": "number"},
    "tests": {"type": "number"}
  },
  "required": ["files", "lines", "tests"]
}' "프로젝트 통계를 JSON으로 출력해줘" > stats.json

# jq로 파싱
FILE_COUNT=$(jq -r '.files' stats.json)
echo "프로젝트에는 총 $FILE_COUNT 개의 파일이 있습니다."
```

### 허용 도구 제한

`--allowedTools` 플래그로 사용 가능한 도구를 제한할 수 있습니다:

```bash
# 읽기 전용 작업 (수정 불가)
claude -p --allowedTools "Read,Glob,Grep" "코드 리뷰해줘"

# Git 관련 작업만 허용
claude -p --allowedTools "Bash(git *)" "최근 커밋 분석해줘"
```

---

## 🔧 고급 옵션

### Bare 모드로 빠른 시작

`--bare` 플래그를 사용하면 hooks, skills, plugins 없이 빠르게 시작할 수 있습니다:

```bash
# 최소 구성으로 빠른 실행
claude --bare -p "간단한 질문"
```

### 최대 비용 제한

`--max-budget-usd` 플래그로 API 호출 비용을 제한할 수 있습니다:

```bash
# 최대 $5까지만 사용
claude -p --max-budget-usd 5.00 "복잡한 분석 작업"
```

### 턴 수 제한

`--max-turns` 플래그로 에이전트 턴 수를 제한할 수 있습니다:

```bash
# 최대 3턴까지만 실행
claude -p --max-turns 3 "작업 수행"
```

### 모델 폴백

`--fallback-model` 플래그로 기본 모델이 과부하일 때 다른 모델로 자동 전환할 수 있습니다:

```bash
claude -p --fallback-model sonnet "중요한 작업"
```

### Skill과 연동

프로그래밍 방식 실행에서도 Skill을 사용할 수 있습니다:

```bash
#!/bin/bash
# daily-check.sh

echo "=== 일일 점검 시작 ==="

# Git 상태
echo "## Git 상태"
claude -p "/my-first-plugin:gs"

# 테스트 실행
echo "## 테스트 결과"
claude -p "/auto-test"

# 코드 품질
echo "## 코드 품질"
claude -p "TODO 주석을 찾아서 목록으로 정리해줘"

echo "=== 점검 완료 ==="
```

---

## 📚 핵심 정리

### 기본 명령어

```bash
# 단순 실행
claude -p "프롬프트"

# stdin에서 입력
cat file.txt | claude -p "분석해줘"

# 결과 저장
claude -p "프롬프트" > output.txt

# 에러도 함께 저장
claude -p "프롬프트" &> output.txt

# 세션 연속성
claude -p "첫 번째 질문"
claude -c -p "두 번째 질문"  # 컨텍스트 유지
```

### 주요 플래그

| 플래그 | 설명 | 예시 |
|--------|------|------|
| `-p, --print` | 프로그래밍 방식 실행 | `claude -p "query"` |
| `--output-format` | 출력 형식 지정 (text/json/stream-json) | `claude -p --output-format json` |
| `--json-schema` | 구조화된 JSON 출력 | `claude -p --json-schema '{...}'` |
| `--allowedTools` | 허용 도구 제한 | `--allowedTools "Read,Edit"` |
| `--bare` | 최소 모드 (빠른 시작) | `claude --bare -p "query"` |
| `--max-turns` | 최대 턴 수 제한 | `--max-turns 5` |
| `--max-budget-usd` | 최대 비용 제한 | `--max-budget-usd 10.00` |
| `-c, --continue` | 세션 계속 | `claude -c -p "query"` |

### 종료 코드

프로그래밍 방식 실행은 종료 코드를 반환합니다:

```bash
claude -p "..."
echo $?  # 0: 성공, 1: 실패
```

스크립트에서 활용:

```bash
if claude -p "테스트 실행"; then
  echo "성공"
else
  echo "실패"
  exit 1
fi
```

### 환경 변수

```bash
# API 키 설정 (CI/CD 환경에서 필수)
export ANTHROPIC_API_KEY="your-api-key"

# 또는 다른 제공자 사용
export CLAUDE_CODE_USE_BEDROCK=1  # AWS Bedrock
export CLAUDE_CODE_USE_VERTEX=1   # Google Vertex AI
export CLAUDE_CODE_USE_FOUNDRY=1  # Microsoft Azure

claude -p "프롬프트"
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

claude -p "
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
  
  claude -p "
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
claude -p "코드 스타일 가이드를 위반한 파일이 있는지 확인하고, 있으면 파일 목록을 출력해줘"

echo "2. 테스트 커버리지 확인"
claude -p "테스트 커버리지를 확인하고, 80% 미만이면 'LOW COVERAGE'를 출력해줘" | tee coverage.txt

if grep -q "LOW COVERAGE" coverage.txt; then
  echo "❌ 테스트 커버리지 부족"
  exit 1
fi

echo "3. 보안 검사"
claude -p "보안 취약점이 있는지 검사하고, 발견되면 'VULNERABILITY FOUND'를 출력해줘" | tee security.txt

if grep -q "VULNERABILITY FOUND" security.txt; then
  echo "❌ 보안 취약점 발견"
  exit 1
fi

echo "✅ 모든 검사 통과"
```

---

## 🔗 Agent SDK로 더 강력하게

프로그래밍 방식 실행을 넘어 완전한 커스텀 에이전트를 구축하려면 **Agent SDK**를 사용하세요.

### Python 예제

```python
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions

async def main():
    async for message in query(
        prompt="Find and fix the bug in auth.py",
        options=ClaudeAgentOptions(allowed_tools=["Read", "Edit", "Bash"]),
    ):
        if hasattr(message, "result"):
            print(message.result)

asyncio.run(main())
```

### TypeScript 예제

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Find and fix the bug in auth.ts",
  options: { allowedTools: ["Read", "Edit", "Bash"] }
})) {
  if ("result" in message) console.log(message.result);
}
```

**Agent SDK로 할 수 있는 것:**
- 도구 실행 완전 제어
- 커스텀 hooks로 동작 가로채기
- Subagent 팀 구성
- MCP 서버 연결
- 세션 관리 및 재개
- 구조화된 출력

자세한 내용은 [Agent SDK 문서](https://code.claude.com/docs/ko/agent-sdk/overview)를 참조하세요.

---

## ⚠️ 주의사항

### 대화형 프롬프트 피하기

**나쁜 예:**
```bash
claude -p "파일을 수정할까요?"
```

프로그래밍 방식 실행은 자동으로 실행되므로 질문을 해서는 안 됩니다.

**좋은 예:**
```bash
claude -p "다음 조건에 맞으면 파일을 수정해줘: [조건]"
```

또는 사용자 입력이 필요하면 권한 모드를 조정하세요:

```bash
claude -p --permission-mode plan "작업 수행"
```

### 실행 시간 제한

너무 오래 걸리는 작업은 타임아웃을 설정하세요:

```bash
timeout 5m claude -p "오래 걸리는 작업"
```

또는 `--max-turns`로 턴 수를 제한:

```bash
claude -p --max-turns 10 "작업 수행"
```

### 에러 처리

항상 에러를 처리하세요:

```bash
if ! claude -p "프롬프트"; then
  echo "에러 발생!"
  # 복구 로직 또는 알림
  exit 1
fi
```

### 출력 형식

구조화된 출력이 필요하면 `--json-schema`를 사용하세요:

```bash
claude -p --json-schema '{
  "type": "object",
  "properties": {
    "status": {"type": "string", "enum": ["SUCCESS", "FAILED"]},
    "message": {"type": "string"}
  },
  "required": ["status", "message"]
}' "작업 수행"
```

---

## 🔍 디버깅

### 상세 로그 보기

```bash
claude -p --verbose "프롬프트"
```

### 디버그 모드

```bash
claude -p --debug "api,mcp" "프롬프트"
```

### 로그 파일 저장

```bash
claude -p --debug-file /tmp/claude-debug.log "프롬프트"
```

### 에러 메시지 캡처

```bash
claude -p "프롬프트" 2> error.log
```

---

## ✅ 완료

프로그래밍 방식으로 Claude Code를 실행하는 방법을 배웠습니다!

**배운 것:**
- ✅ `-p` 플래그로 프로그래밍 방식 실행
- ✅ `--output-format`으로 구조화된 출력
- ✅ `--json-schema`로 검증된 JSON 생성
- ✅ `--allowedTools`로 도구 제한
- ✅ CI/CD 통합
- ✅ Git hooks 연동
- ✅ 자동화 스크립트 작성
- ✅ Agent SDK로 커스텀 에이전트 구축

**핵심 명령어:**
```bash
# 기본 실행
claude -p "프롬프트"

# 세션 연속성
claude -c -p "프롬프트"

# 구조화된 출력
claude -p --output-format json "프롬프트"

# JSON 스키마 검증
claude -p --json-schema '{...}' "프롬프트"

# 도구 제한
claude -p --allowedTools "Read,Edit" "프롬프트"

# stdin에서 입력
cat file.txt | claude -p "분석해줘"
```

**참고 자료:**
- [CLI 참조 문서](https://code.claude.com/docs/ko/cli-reference)
- [Agent SDK 문서](https://code.claude.com/docs/ko/agent-sdk/overview)
- [GitHub Actions 통합](https://code.claude.com/docs/ko/github-actions)
- [GitLab CI/CD 통합](https://code.claude.com/docs/ko/gitlab-ci-cd)

**다음에는:**
Sub-agents를 만들어서 사용자 정의 하위 에이전트를 활용하는 방법을 배웁니다.

### 다음 단계

[고급 6: Sub-agents →](advanced-06-subagents)
{: .btn .btn-primary }
