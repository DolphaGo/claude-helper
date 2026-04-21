# Claude Code 학습 문서 검증 및 개선 프로젝트 계획

## 프로젝트 개요

**목표:** 공식 문서 기반으로 기존 튜토리얼을 검증하고 수정하여 초보자 친화적인 정확한 학습 자료 완성

**기간:** 약 2-3주 (팀 규모에 따라)

**팀 구성:** 최소 4명 (검증자 2명 × 2 라운드)

---

## 🚨 발견된 주요 문제점

### Critical (즉시 수정 필요)

1. **step-07-local-plugin.md - 플러그인 구조 오류**
   - 제목 불일치: "Step 7" vs "Step 4"
   - **치명적:** 잘못된 플러그인 디렉토리 구조 교육
     - 현재: `skills/` 루트 레벨
     - 정확: `skills/`는 `.claude-plugin/` 내부에 위치해야 함
   - 구식 `plugin.json` 구조 (skills 배열)
   - 더 이상 사용하지 않는 commands/ 디렉토리 언급

2. **Step 번호 혼란**
   - index.md에 step-07이 marketplace로 표시됨
   - 실제로는 step-08-marketplace.md가 존재
   - step-07-local-plugin.md는 index에 언급 안 됨

### High (검증 필수)

3. **Marketplace 시스템 검증 필요** (step-08-marketplace.md)
   - `claude plugin add/install/update` 명령어 실제 존재 여부
   - `~/.claude/plugins/cache/` 경로 검증
   - marketplace.json 자동 등록 주장 검증

4. **Commands vs Skills 구분** (step-00, step-03)
   - Commands가 별도 개념인지, 단순히 Skills의 일종인지
   - `.claude/commands/` 디렉토리 지원 여부
   - aliases 필드 실제 작동 여부

5. **Sub-agents 용어 및 구조** (advanced-06)
   - "Sub-agents" vs 공식 용어 확인
   - Explore/Plan/general-purpose 내장 에이전트 검증
   - `~/.claude/agents/` 디렉토리 및 사용자 정의 에이전트 생성 방법

### Medium (개선 필요)

6. **Frontmatter 필드 정확성**
   - 지원되는 필드 전체 목록
   - 올바른 철자 및 형식
   - trigger_patterns vs triggers 등

7. **CLI 명령어 전체 검증**
   - 문서 전반에 걸친 CLI 명령어 실제 작동 확인

---

## 📋 작업 단계 및 우선순위

### Phase 1: 검증 (1주차)

**우선순위 1 - 치명적 오류 검증**
- Task #1: step-07 플러그인 구조 오류 문서화
- Task #5: step 번호 혼란 확인

**우선순위 2 - 핵심 개념 검증**
- Task #8: Skills 파일 구조 및 위치 규칙 (concepts.md)
- Task #4: Frontmatter 필드 검증
- Task #10: Marketplace 개념 검증

**우선순위 3 - 용어 및 시스템 검증**
- Task #6: Commands vs Skills 구분
- Task #9: Sub-agents 용어 및 구조
- Task #7: CLI 명령어 전체 검증

**검증 방법:**
1. 공식 문서 (https://code.claude.com/docs/ko/*) 정독
2. 각 주장에 대해 공식 문서 인용 찾기
3. 발견 사항을 증거와 함께 기록

**완료 조건:**
- Task #3: 검증 보고서 작성 (모든 발견 사항 + 공식 문서 인용)

---

### Phase 2: 수정 (2주차)

**우선순위 1 - 치명적 오류 수정**
- Task #2: step-07-local-plugin.md 전면 수정
- Task #11: Step 번호 및 내비게이션 흐름 수정

**우선순위 2 - 핵심 문서 업데이트**
- Task #12: concepts.md 업데이트
- Task #13: step-08-marketplace.md 업데이트
- Task #14: step-00 및 step-03 Commands 정확성 업데이트

**우선순위 3 - 고급 문서 업데이트**
- Task #15: advanced-06-subagents.md 용어 수정
- Task #16: 모든 코드 예제 일관성 검토

**우선순위 4 - 콘텐츠 보강**
- Task #20: 누락된 콘텐츠 추가
- Task #19: 폐기된 기능에 대한 마이그레이션 가이드

---

### Phase 3: 검토 및 완료 (3주차)

**Peer Review**
- Task #17: 2차 검증자에 의한 전체 검토
  - 1차 검증자와 다른 사람이 수행
  - 모든 수정 사항 재검증
  - 새로운 오류 도입 여부 확인

**최종 문서화**
- Task #18: 최종 정확성 보고서 및 완료 요약
  - 발견된 모든 오류 및 수정 내역
  - Before/After 비교
  - 정확도 신뢰 수준
  - 지속적인 유지보수 권장사항

---

## 👥 팀 구성 및 역할 분담

### 최소 팀 구성 (4명)

**검증 팀 A (2명)**
- 검증자 A1: Tasks #1, #4, #8, #10 담당
- 검증자 A2: Tasks #5, #6, #7, #9 담당
- 협업: Task #3 (검증 보고서 작성)

**검증 팀 B (2명) - 2차 검증**
- 검증자 B1: Phase 2 수정 사항 검토 (step-00~step-08)
- 검증자 B2: Phase 2 수정 사항 검토 (concepts, advanced)
- 협업: Task #17 (Peer Review)

### 수정 팀 (검증 팀과 겹칠 수 있음)

**수정자 1: 기초 문서**
- Tasks #2, #11, #14 (step-00, step-03, step-07)

**수정자 2: 핵심 개념 문서**
- Tasks #12, #13 (concepts, step-08)

**수정자 3: 고급 문서**
- Tasks #15, #16, #19, #20

**프로젝트 리드**
- 전체 조율
- Tasks #3, #18 (보고서 통합)
- 최종 승인

---

## 🔍 검증 프로세스 상세

### 1차 검증 (검증자 독립 작업)

각 문서에 대해:

1. **공식 문서 읽기**
   - 관련 공식 문서 섹션 정독
   - 주요 개념 및 구조 파악

2. **튜토리얼 대조**
   - 튜토리얼의 각 주장 확인
   - 코드 예제 검증
   - CLI 명령어 확인

3. **발견 사항 기록**
   ```markdown
   ## [문서명] 검증 결과
   
   ### 오류
   - **위치:** [줄 번호 또는 섹션]
   - **문제:** [무엇이 잘못되었는지]
   - **증거:** [공식 문서 링크 및 인용]
   - **심각도:** Critical/High/Medium/Low
   - **제안:** [어떻게 수정해야 하는지]
   
   ### 정확한 내용
   - [올바르게 설명된 부분들]
   
   ### 누락된 내용
   - [추가되어야 할 내용]
   ```

### 2차 검증 (합의 프로세스)

1. **검증자 미팅**
   - 각자 발견 사항 공유
   - 불일치 항목 토론
   - 합의된 수정안 도출

2. **수정 우선순위 결정**
   - Critical: 즉시 수정
   - High: Phase 2 우선
   - Medium: Phase 2 포함
   - Low: 시간 허용 시

3. **검증 보고서 작성** (Task #3)
   - 합의된 모든 발견 사항
   - 공식 문서 인용 포함
   - 수정 권장사항

---

## 📝 수정 가이드라인

### 수정 원칙

1. **정확성 최우선**
   - 추측 금지
   - 불확실하면 공식 문서 재확인
   - 검증 불가능한 내용은 제거

2. **초보자 친화성 유지**
   - 복잡한 개념도 쉽게 설명
   - 단계별 예제 제공
   - "왜"에 대한 설명 포함

3. **일관성**
   - 용어 통일
   - 코드 스타일 일관성
   - 디렉토리 경로 표기 일관성

4. **실행 가능성**
   - 모든 코드 예제는 실제로 작동해야 함
   - 명령어는 실제로 존재하는 것만

### 수정 체크리스트

각 수정 작업 시:

- [ ] 검증 보고서의 권장사항 적용
- [ ] 공식 문서 링크 확인
- [ ] 코드 예제 테스트 (가능한 경우)
- [ ] 관련 문서의 교차 참조 업데이트
- [ ] Frontmatter의 nav_order 확인
- [ ] 파일명과 내용의 일치성 확인

---

## 🎯 성공 기준

### 각 문서별 기준

**정확성:**
- [ ] 모든 주장이 공식 문서로 뒷받침됨
- [ ] 코드 예제가 실제로 작동함
- [ ] CLI 명령어가 실제로 존재함
- [ ] 디렉토리 구조가 정확함

**완전성:**
- [ ] 초보자가 따라할 수 있는 충분한 설명
- [ ] 중요한 개념이 누락되지 않음
- [ ] 에러 처리 및 문제 해결 포함

**일관성:**
- [ ] 용어가 문서 전체에서 일관됨
- [ ] 코딩 스타일이 일관됨
- [ ] 참조가 정확하게 연결됨

### 프로젝트 전체 기준

- [ ] Phase 1의 모든 검증 작업 완료
- [ ] 검증 보고서 작성 및 승인
- [ ] Phase 2의 모든 수정 작업 완료
- [ ] 2차 검증자에 의한 승인
- [ ] 최종 보고서 작성
- [ ] 치명적 오류 0개
- [ ] High 오류 0개
- [ ] Medium 오류 최소화

---

## 📚 참고 자료

### 공식 문서

1. **개요 및 기본 개념**
   - https://code.claude.com/docs/ko/overview

2. **Sub-agents**
   - https://code.claude.com/docs/ko/sub-agents

3. **Third-party Integrations**
   - https://code.claude.com/docs/ko/third-party-integrations

4. **Setup**
   - https://code.claude.com/docs/ko/setup

5. **Settings**
   - https://code.claude.com/docs/ko/settings

6. **CLI Reference**
   - https://code.claude.com/docs/ko/cli-reference

7. **Agent SDK**
   - https://code.claude.com/docs/ko/agent-sdk/overview

### 현재 문서 구조

```
docs/
├── index.md                      # 메인 페이지
├── concepts.md                   # 핵심 개념
├── step-00-before-start.md       # 시작하기 전에
├── step-01-first-skill.md        # 첫 번째 Skill
├── step-02-git-skill.md          # Git Skill
├── step-03-command.md            # Command 이해
├── step-04-jira-skill.md         # Jira 티켓 생성
├── step-05-search-tool.md        # 코드 검색
├── step-06-publish.md            # 플러그인 배포
├── step-07-local-plugin.md       # 로컬 플러그인 (🚨 Critical 오류)
├── step-08-marketplace.md        # 마켓플레이스
├── advanced.md                   # 고급 개념 인덱스
├── advanced-01-mcp.md            # MCP 서버
├── advanced-02-hooks.md          # Hooks
├── advanced-03-channels.md       # Channels
├── advanced-04-scheduled-tasks.md # 예약 작업
├── advanced-05-headless.md       # Headless 모드
├── advanced-06-subagents.md      # Sub-agents (검증 필요)
├── advanced-07-agent-teams.md    # Agent Teams
└── advanced-08-troubleshooting.md # 문제 해결
```

---

## 🔄 진행 상황 추적

### Week 1: 검증 단계
- [ ] Day 1-2: Tasks #1, #5, #8 (Critical + Skills 구조)
- [ ] Day 3-4: Tasks #4, #6, #7 (Frontmatter + Commands + CLI)
- [ ] Day 5: Tasks #9, #10 (Sub-agents + Marketplace)
- [ ] Day 6-7: Task #3 (검증 보고서 작성 및 검토)

### Week 2: 수정 단계
- [ ] Day 1-2: Tasks #2, #11 (Critical 수정)
- [ ] Day 3-4: Tasks #12, #13, #14 (기본 문서 업데이트)
- [ ] Day 5-7: Tasks #15, #16, #19, #20 (고급 문서 + 보강)

### Week 3: 검토 및 완료
- [ ] Day 1-3: Task #17 (Peer Review)
- [ ] Day 4-5: 수정사항 반영
- [ ] Day 6-7: Task #18 (최종 보고서 작성)

---

## 💡 권장사항

### 효율적인 작업을 위한 팁

1. **병렬 작업**
   - 검증 팀 A가 Phase 1 작업 중
   - 독립적인 문서는 동시에 검증 가능

2. **조기 피드백**
   - 첫 1-2개 문서 검증 후 프로세스 점검
   - 필요시 프로세스 조정

3. **문서화**
   - 모든 결정사항 기록
   - 애매한 부분은 명시적으로 표시
   - "확인 필요" 항목 별도 관리

4. **커뮤니케이션**
   - 일일 스탠드업 미팅 (15분)
   - 주요 발견 사항 즉시 공유
   - 블로커 신속 해결

---

## 📞 에스컬레이션

### 불확실한 사항 처리

**Level 1: 팀 내 논의**
- 검증자들 간 토론
- 다양한 해석 고려

**Level 2: 공식 문서 재확인**
- 관련 섹션 전체 재독
- 예제 코드 실제 테스트

**Level 3: 커뮤니티/지원팀 문의**
- Claude Code 공식 커뮤니티
- GitHub Issues
- 지원팀 문의

**Level 4: 명시적 표시**
- 확인 불가능한 내용은 문서에 명시
- "공식 문서에서 확인 필요" 주석 추가
- 별도 이슈 목록 관리

---

## ✅ 체크리스트: 프로젝트 완료 조건

- [ ] 모든 20개 Task 완료
- [ ] 검증 보고서 작성 및 승인 (Task #3)
- [ ] step-07-local-plugin.md Critical 오류 수정 (Task #2)
- [ ] Step 번호 혼란 해결 (Tasks #5, #11)
- [ ] 2차 검증자 Peer Review 완료 (Task #17)
- [ ] 최종 보고서 작성 (Task #18)
- [ ] 모든 코드 예제 검증
- [ ] 모든 교차 참조 확인
- [ ] 프로젝트 리드 최종 승인

---

**프로젝트 시작일:** [날짜 입력]  
**예상 완료일:** [날짜 입력]  
**프로젝트 리드:** [이름 입력]  
**상태:** 계획 단계
