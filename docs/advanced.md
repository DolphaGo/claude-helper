---
layout: default
title: "고급 개념"
nav_order: 12
has_children: true
---

# 고급 개념
{: .no_toc }

Claude Code의 강력한 통합과 자동화 기능을 배웁니다.
{: .fs-6 .fw-300 }

---

## 🎯 고급 개념 개요

기초 실습(Step 1-6)을 완료했다면, 이제 Claude Code의 고급 기능들을 배울 준비가 되었습니다.

### 학습 순서

고급 개념들은 독립적으로 학습할 수 있지만, 다음 순서를 권장합니다:

**통합 (Integration)**
1. [MCP 서버](advanced-01-mcp) - 외부 시스템과 연결
2. [Hooks](advanced-02-hooks) - 이벤트 기반 자동화
3. [Channels](advanced-03-channels) - 외부 이벤트 수신

**자동화 (Automation)**
4. [Scheduled Tasks](advanced-04-scheduled-tasks) - 정기 작업 예약
5. [Headless 모드](advanced-05-headless) - 프로그래밍 방식 실행

**확장 (Scaling)**
6. [Sub-agents](advanced-06-subagents) - 작업 위임
7. [Agent Teams](advanced-07-agent-teams) - 대규모 병렬 처리

**운영 (Operations)**
8. [Troubleshooting](advanced-08-troubleshooting) - 문제 해결

---

## 📋 각 개념의 핵심

### MCP 서버
외부 시스템(데이터베이스, API, 파일 시스템)과 Claude Code를 연결하는 표준 프로토콜입니다.

**언제 필요한가:**
- 데이터베이스 조회
- 외부 API 호출
- 클라우드 서비스 통합

### Hooks
특정 이벤트(파일 수정, 명령어 실행 등)가 발생할 때 자동으로 실행되는 스크립트입니다.

**언제 필요한가:**
- 파일 저장 시 자동 테스트
- 세션 시작 시 환경 확인
- 코드 수정 후 자동 포맷팅

### Channels
외부 시스템에서 Claude Code로 메시지를 푸시하는 통신 채널입니다.

**언제 필요한가:**
- CI/CD 빌드 결과 알림
- 모니터링 경고 수신
- 실시간 이벤트 처리

### Scheduled Tasks
정해진 시간에 자동으로 프롬프트를 실행합니다.

**언제 필요한가:**
- 일일 상태 리포트
- 주간 코드 분석
- 정기 백업 확인

### Headless 모드
대화형 인터페이스 없이 명령줄에서 직접 Claude Code를 실행합니다.

**언제 필요한가:**
- CI/CD 파이프라인 통합
- 배치 처리
- 자동화 스크립트

### Sub-agents
특정 작업에 전문화된 하위 에이전트에게 작업을 위임합니다.

**언제 필요한가:**
- 복잡한 작업 분할
- 컨텍스트 격리
- 전문성 필요

### Agent Teams
여러 독립적인 Claude 세션을 생성하고 조율합니다.

**언제 필요한가:**
- 대규모 프로젝트
- 병렬 처리
- 팀 작업 시뮬레이션

### Troubleshooting
일반적인 문제들과 해결 방법을 다룹니다.

**언제 필요한가:**
- Skill이 작동하지 않을 때
- 성능 문제
- 설정 오류

---

## 🎓 학습 전 확인사항

고급 개념을 학습하기 전에 다음을 확인하세요:

### 필수 선행 학습
- ✅ Step 1-6 완료
- ✅ 기본 Skill 작성 가능
- ✅ Plugin 구조 이해
- ✅ 환경 변수 설정 가능

### 권장 지식
- Git 기본 사용법
- Shell 스크립트 기초
- JSON/YAML 형식 이해
- HTTP/API 기본 개념

### 개발 환경
- Claude Code 최신 버전
- 터미널 접근 권한
- Node.js (MCP 서버용)
- Python (일부 예제용)

---

## 💡 학습 팁

### 단계별 접근
1. 개념 문서를 먼저 읽기
2. 간단한 예제로 시작
3. 실제 프로젝트에 적용
4. 문제 발생 시 Troubleshooting 참고

### 실습 환경
- 테스트 프로젝트 생성 권장
- 실제 프로젝트에 바로 적용하지 말 것
- Git으로 버전 관리

### 문제 해결
- 로그를 항상 확인
- 최소 재현 예제 작성
- 공식 문서 참조
- 커뮤니티 활용

---

## 🔗 관련 리소스

### 공식 문서
- [Claude Code 문서](https://code.claude.com/docs)
- [Skills 가이드](https://code.claude.com/docs/ko/skills)
- [Plugins 가이드](https://code.claude.com/docs/ko/plugins)

### 커뮤니티
- [GitHub Issues](https://github.com/anthropics/claude-code/issues)
- [Discord](https://discord.gg/anthropic)

### 예제 저장소
- [공식 Examples](https://github.com/anthropics/claude-code-examples)
- [Community Plugins](https://code.claude.com/plugins)

---

## 다음 단계

준비가 되었다면 첫 번째 고급 개념부터 시작하세요:

[고급 1: MCP 서버 →](advanced-01-mcp)
{: .btn .btn-primary }

또는 목차에서 관심 있는 주제를 선택하세요.
