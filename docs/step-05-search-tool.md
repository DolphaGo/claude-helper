---
layout: default
title: "Step 5: 검색 Skill"
nav_order: 7
---

# Step 5: Grep 도구 사용하기
{: .no_toc }

⏱️ 10분
{: .label .label-purple }

Claude Code의 내장 Grep 도구를 사용해서 코드를 검색하는 skill을 만듭니다.
{: .fs-6 .fw-300 }

## 목차
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## 🎯 목표

**핵심 개념:** Claude Code의 도구를 Skill에서 활용

**만들 것:** 키워드 검색 skill

**배울 것:**
- Grep 도구란 무엇인가
- Skill에서 도구 사용 지침 작성

---

## 🔍 Claude Code의 도구 이해하기

Claude Code는 내장 도구들을 제공합니다:
- **Read**: 파일 읽기
- **Write**: 파일 쓰기
- **Edit**: 파일 수정
- **Grep**: 코드 검색
- **Bash**: 명령어 실행

Skill에서 이 도구들을 사용하도록 지침을 작성할 수 있습니다.

---

## 📝 1단계: 기본 검색 Skill

### Grep 도구란?

Grep은 프로젝트 전체에서 키워드를 찾는 도구입니다.

예시:
- "TODO"를 포함한 모든 줄 찾기
- "function" 키워드 검색
- 특정 변수명 찾기

### Skill 생성

```bash
mkdir -p ~/.claude/plugins/my-first-plugin/skills/search
cat > ~/.claude/plugins/my-first-plugin/skills/search/SKILL.md << 'SKILLEOF'
---
description: 프로젝트에서 키워드를 검색합니다
disable-model-invocation: true
argument-hint: [keyword]
---

# Code Search

프로젝트에서 키워드를 검색하세요.

## 1. 키워드 확인
사용자가 제공한 키워드를 확인하세요.

## 2. 검색 실행
Grep 도구를 사용해서 검색하세요.

## 3. 결과 정리
파일 경로와 일치하는 줄을 보기 좋게 보여주세요.
SKILLEOF
```

### 테스트

```bash
/reload-plugins
/my-first-plugin:search "TODO"
```

Claude가 자동으로 Grep 도구를 사용해서 TODO를 검색합니다.

---

## 🎨 2단계: 결과 포맷팅

검색 결과를 더 보기 좋게 정리합니다.

```bash
cat > ~/.claude/plugins/my-first-plugin/skills/search/SKILL.md << 'SKILLEOF'
---
description: 프로젝트에서 키워드를 검색하고 정리해서 보여줍니다
disable-model-invocation: true
argument-hint: [keyword]
---

# Code Search

프로젝트에서 키워드를 검색하세요.

## 1. 검색 실행
Grep 도구로 키워드를 검색하세요.

## 2. 결과 분석
- 총 몇 개 파일에서 발견되었는지
- 각 파일에서 몇 번 등장하는지

## 3. 결과 표시

다음 형식으로 보여주세요:

검색 키워드: [keyword]
발견된 파일: X개

파일별 결과:
[파일1] (N개)
  - 줄번호: 내용
  - 줄번호: 내용

[파일2] (M개)
  - 줄번호: 내용
SKILLEOF
```

### 테스트

```bash
/reload-plugins
/my-first-plugin:search "function"
```

---

## 📚 핵심 정리

### Claude Code의 도구 시스템

Claude Code는 여러 내장 도구를 제공합니다:
- **Read**: 파일 읽기
- **Grep**: 코드 검색
- **Bash**: 명령어 실행
- **Edit**: 파일 수정
- **Write**: 파일 쓰기

### Skill에서 도구 사용하기

Skill은 Claude에게 "어떤 도구를 사용할지" 알려줍니다.

```markdown
Grep 도구를 사용해서 검색하세요.
```

이렇게 작성하면 Claude가 자동으로 Grep 도구를 사용합니다.

### 도구 사용의 장점

- ✅ 직접 구현할 필요 없음
- ✅ Claude Code가 최적화된 방법 제공
- ✅ 일관된 결과

---

## 🎉 완료!

Claude Code의 도구를 사용하는 Skill을 만들었습니다!

**배운 것:**
- ✅ Claude Code의 도구 시스템 이해
- ✅ Grep 도구 사용
- ✅ 도구 사용 지침 작성
- ✅ 결과 포맷팅

**핵심 개념:**
- Skill은 Claude가 "어떻게 할지" 알려주는 지침
- Claude Code는 강력한 도구들을 내장
- Skill에서 이 도구들을 활용할 수 있음

### 다음 단계

[Step 6: 배포하기 →](step-06-publish)
{: .btn .btn-primary }
