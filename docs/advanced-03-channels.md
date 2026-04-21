---
layout: default
title: "고급 3: Channels"
nav_order: 12
parent: 고급 개념
---

# Channels로 이벤트 받기
{: .no_toc }

⏱️ 15분
{: .label .label-red }

외부 시스템에서 Claude Code로 이벤트를 푸시하는 Channels를 배웁니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 Channels란?

**Channels**는 외부 시스템이 Claude Code로 메시지를 보낼 수 있는 통신 채널입니다.

### Hooks vs Channels

```
Hooks (내부 → 외부)
┌──────────────┐           ┌──────────────┐
│ Claude Code  │  실행 →   │  외부 명령    │
│   이벤트     │           │  스크립트    │
└──────────────┘           └──────────────┘
   파일 수정 →               테스트 실행


Channels (외부 → 내부)
┌──────────────┐           ┌──────────────┐
│  외부 시스템  │  푸시 →   │ Claude Code  │
│   (CI/CD)    │           │   알림 수신  │
└──────────────┘           └──────────────┘
  빌드 실패 →               메시지 표시
```

| 비교 | Hooks | Channels |
|------|-------|----------|
| 방향 | Claude Code → 외부 | 외부 → Claude Code |
| 트리거 | 내부 이벤트 | 외부 이벤트 |
| 예시 | 파일 수정 후 테스트 | CI 실패 알림 |

### 언제 사용하나?

**외부 알림이 필요한 경우:**
- CI/CD 빌드 결과 알림
- 모니터링 경고 수신
- 팀원의 코드 리뷰 요청
- 배포 완료 알림

---

## 📋 Channel 종류

### 1. HTTP Channel

HTTP POST 요청으로 메시지를 받습니다.

**사용 사례:**
- Webhook 수신
- CI/CD 통합
- 외부 서비스 알림

### 2. File Channel

파일 시스템 변경을 감지합니다.

**사용 사례:**
- 로그 파일 모니터링
- 설정 파일 변경 감지
- 빌드 결과 파일 확인

### 3. Cron Channel

정해진 시간에 메시지를 생성합니다.

**사용 사례:**
- 주기적인 상태 확인
- 정기 리포트
- 예약된 작업

---

## ⚙️ Channel 설정하기

### 설정 파일 위치

```
.claude/settings.json
```

### 기본 구조

```json
{
  "channels": {
    "channel-name": {
      "type": "http",
      "config": {
        // 채널 설정
      }
    }
  }
}
```

---

## 💡 HTTP Channel 예제

### 예제 1: CI 빌드 알림

```json
{
  "channels": {
    "ci-notifications": {
      "type": "http",
      "config": {
        "port": 3000,
        "path": "/ci-webhook"
      }
    }
  }
}
```

**사용 방법:**

CI 서비스(GitHub Actions, Jenkins 등)에서 webhook 설정:

```
http://localhost:3000/ci-webhook
```

**Webhook 페이로드 예시:**

```bash
curl -X POST http://localhost:3000/ci-webhook \
  -H "Content-Type: application/json" \
  -d '{
    "status": "failed",
    "message": "Build failed on main branch",
    "build_url": "https://ci.example.com/builds/123"
  }'
```

**Claude Code가 받는 메시지:**

```
🚨 CI 빌드 실패
브랜치: main
상세: https://ci.example.com/builds/123
```

### 예제 2: 배포 완료 알림

```json
{
  "channels": {
    "deploy-notifications": {
      "type": "http",
      "config": {
        "port": 3001,
        "path": "/deploy"
      }
    }
  }
}
```

**배포 스크립트에서:**

```bash
# deploy.sh
#!/bin/bash

# 배포 로직...

# 완료 후 알림
curl -X POST http://localhost:3001/deploy \
  -H "Content-Type: application/json" \
  -d "{
    \"environment\": \"production\",
    \"version\": \"$VERSION\",
    \"deployed_at\": \"$(date -Iseconds)\"
  }"
```

---

## 📁 File Channel 예제

### 예제 1: 로그 파일 모니터링

```json
{
  "channels": {
    "error-logs": {
      "type": "file",
      "config": {
        "path": "/var/log/app/error.log",
        "pattern": "ERROR|CRITICAL"
      }
    }
  }
}
```

**효과:**
`error.log` 파일에 ERROR 또는 CRITICAL이 추가되면 Claude Code에 알림이 표시됩니다.

### 예제 2: 테스트 결과 감시

```json
{
  "channels": {
    "test-results": {
      "type": "file",
      "config": {
        "path": "./test-results.json",
        "trigger": "modified"
      }
    }
  }
}
```

**효과:**
테스트가 완료되어 `test-results.json`이 업데이트되면 자동으로 결과를 확인합니다.

---

## ⏰ Cron Channel 예제

### 예제 1: 매일 프로젝트 상태 확인

```json
{
  "channels": {
    "daily-status": {
      "type": "cron",
      "config": {
        "schedule": "0 9 * * *",
        "message": "일일 프로젝트 상태를 확인해주세요"
      }
    }
  }
}
```

**Cron 표현식:**
- `0 9 * * *`: 매일 오전 9시
- `*/30 * * * *`: 30분마다
- `0 */2 * * *`: 2시간마다

### 예제 2: 주간 리포트

```json
{
  "channels": {
    "weekly-report": {
      "type": "cron",
      "config": {
        "schedule": "0 10 * * 1",
        "message": "지난 주의 커밋과 변경사항을 요약해주세요"
      }
    }
  }
}
```

**효과:**
매주 월요일 오전 10시에 자동으로 주간 리포트를 생성합니다.

---

## 🎨 Channel과 Skill 연동

Channel 이벤트를 받았을 때 특정 Skill을 자동으로 실행할 수 있습니다.

### 예제: CI 실패 시 자동 분석

**Channel 설정:**

```json
{
  "channels": {
    "ci-failures": {
      "type": "http",
      "config": {
        "port": 3000,
        "path": "/ci-failed"
      },
      "onMessage": "/analyze-failure"
    }
  }
}
```

**Skill 생성:**

```bash
mkdir -p ~/.claude/skills/analyze-failure
cat > ~/.claude/skills/analyze-failure/SKILL.md << 'SKILLEOF'
---
description: CI 실패를 분석합니다
---

# CI Failure Analysis

CI 빌드가 실패했습니다. 다음을 확인하세요:

## 1. 최근 커밋 확인
가장 최근 커밋의 변경사항을 확인하세요.

## 2. 에러 로그 분석
전달된 빌드 URL에서 에러 로그를 확인하세요.

## 3. 원인 파악
어떤 파일의 어떤 변경이 문제를 일으켰는지 파악하세요.

## 4. 수정 방안 제안
문제를 해결할 수 있는 방법을 제안하세요.
SKILLEOF
```

**효과:**
CI가 실패하면 자동으로 원인을 분석하고 수정 방안을 제안합니다.

---

## 📚 핵심 정리

### Channel 타입별 용도

**HTTP Channel:**
- Webhook 수신
- 외부 서비스 통합
- 실시간 알림

**File Channel:**
- 로그 모니터링
- 파일 변경 감지
- 로컬 이벤트

**Cron Channel:**
- 정기 작업
- 예약된 알림
- 주기적인 확인

### 설정 구조

```json
{
  "channels": {
    "이름": {
      "type": "http|file|cron",
      "config": {
        // 타입별 설정
      },
      "onMessage": "/skill-name"  // 선택사항
    }
  }
}
```

### HTTP Channel 포트

여러 HTTP Channel을 사용할 때는 다른 포트를 사용하세요:

```json
{
  "channels": {
    "ci": {"config": {"port": 3000}},
    "deploy": {"config": {"port": 3001}},
    "monitoring": {"config": {"port": 3002}}
  }
}
```

---

## 🎓 실전 패턴

### 패턴 1: 통합 알림 센터

```json
{
  "channels": {
    "ci-notifications": {
      "type": "http",
      "config": {"port": 3000, "path": "/ci"}
    },
    "deploy-notifications": {
      "type": "http",
      "config": {"port": 3000, "path": "/deploy"}
    },
    "monitoring-alerts": {
      "type": "http",
      "config": {"port": 3000, "path": "/alerts"}
    }
  }
}
```

같은 포트에 다른 path를 사용해서 여러 알림을 받습니다.

### 패턴 2: 자동화 파이프라인

```json
{
  "channels": {
    "build-complete": {
      "type": "file",
      "config": {
        "path": "./build/status.json"
      },
      "onMessage": "/run-tests"
    }
  }
}
```

빌드가 완료되면 자동으로 테스트를 실행합니다.

### 패턴 3: 모니터링 대시보드

```json
{
  "channels": {
    "hourly-check": {
      "type": "cron",
      "config": {
        "schedule": "0 * * * *",
        "message": "시스템 상태를 확인해주세요"
      },
      "onMessage": "/system-health"
    }
  }
}
```

매 시간 자동으로 시스템 상태를 확인합니다.

---

## 🛠️ 고급 기능

### 메시지 필터링

```json
{
  "channels": {
    "filtered-logs": {
      "type": "file",
      "config": {
        "path": "/var/log/app.log",
        "pattern": "ERROR.*database"
      }
    }
  }
}
```

데이터베이스 관련 에러만 필터링합니다.

### 메시지 변환

```json
{
  "channels": {
    "ci-webhook": {
      "type": "http",
      "config": {
        "port": 3000,
        "path": "/ci",
        "transform": "jq '.build | {status, url}'"
      }
    }
  }
}
```

받은 JSON을 변환해서 필요한 정보만 추출합니다.

---

## ⚠️ 주의사항

### 보안

**HTTP Channel은 localhost에서만 접근 가능합니다.**
- 외부에서 접근하려면 터널링 (ngrok 등) 필요
- 민감한 정보는 HTTPS 사용 권장

### 성능

**너무 많은 이벤트는 피하세요:**
- File Channel: 변경이 빈번한 파일은 피하기
- Cron Channel: 너무 짧은 간격 피하기
- HTTP Channel: 요청 제한 고려하기

### 디버깅

Channel이 작동하지 않으면:

```bash
# Claude Code 로그 확인
tail -f ~/.claude/logs/claude.log

# Channel 테스트
curl -X POST http://localhost:3000/test \
  -H "Content-Type: application/json" \
  -d '{"test": "message"}'
```

---

## ✅ 완료

Channels를 사용해서 외부 이벤트를 받는 방법을 배웠습니다!

**배운 것:**
- ✅ 3가지 Channel 타입 (HTTP, File, Cron)
- ✅ Channel 설정 방법
- ✅ Webhook 수신
- ✅ 파일 모니터링
- ✅ 예약된 작업
- ✅ Channel과 Skill 연동

**핵심 개념:**
- Channels는 외부 → Claude Code 방향
- HTTP Channel로 webhook 수신
- File Channel로 파일 변경 감지
- Cron Channel로 예약 작업
- onMessage로 Skill 자동 실행

**다음에는:**
Scheduled Tasks로 정기적인 프롬프트를 실행하는 방법을 배웁니다.

### 다음 단계

[고급 4: Scheduled Tasks →](advanced-04-scheduled-tasks)
{: .btn .btn-primary }
