# Claude Helper

Claude Code를 위한 커스텀 skills & commands 모음입니다.

## 📦 설치

### 자동 설치 (권장)
```bash
./install.sh
```

대화형 설치 스크립트가 다음을 안내합니다:
- 로컬/Git 원격/npm 설치 방식 선택
- Claude Code 플러그인 디렉토리 자동 감지
- 설치 완료 후 검증

### 수동 설치
```bash
# 1. 플러그인 디렉토리로 이동
cd ~/.claude/plugins

# 2. 클론 또는 복사
git clone https://github.com/your-username/claude-helper.git
# 또는
cp -r /path/to/claude-helper .

# 3. 검증
./claude-helper/validate.sh
```

## 🚀 사용법

### Skills 사용
```bash
# Claude Code에서 직접 사용
/hello-world
/api-tester https://api.example.com/users
/code-review-kr
```

### Commands 사용
```bash
# 빠른 커밋
/quickcommit fix: 버그 수정

# 프로젝트 정리
/cleanup --cache

# 한글 검색
/search-kr 로그인 --type js
```

## 📁 디렉토리 구조

```
claude-helper/
├── plugin.json           # 플러그인 설정
├── package.json          # npm 패키지 정보
├── install.sh            # 설치 스크립트
├── uninstall.sh          # 제거 스크립트
├── validate.sh           # 검증 스크립트
│
├── skills/               # Skills 모음
│   └── examples/         # 예제 skills
│       ├── hello-world.md
│       ├── api-tester.md
│       └── code-review-kr.md
│
├── commands/             # Commands 모음
│   └── examples/         # 예제 commands
│       ├── quickcommit.md
│       ├── cleanup.md
│       └── search-kr.md
│
├── templates/            # 새 skill/command 생성용 템플릿
│   ├── skill-template.md
│   └── command-template.md
│
└── docs/                 # 추가 문서
```

## 📚 포함된 Skills

### 🌍 hello-world
기본 skill 구조 데모 - 인사와 프로젝트 상태 확인

**사용 예시:**
```
/hello-world
```

### 🧪 api-tester
REST API 엔드포인트 자동 테스트 및 검증

**사용 예시:**
```
/api-tester https://api.example.com/users
/api-tester POST https://api.example.com/users --auth
```

### 📝 code-review-kr
한국어로 진행하는 체계적인 코드 리뷰

**사용 예시:**
```
/code-review-kr
사용자: PR #123 코드 리뷰 해줘
```

## 📚 포함된 Commands

### ⚡ quickcommit
스테이징부터 커밋까지 한 번에 처리

**사용 예시:**
```
/quickcommit                    # 자동 메시지 생성
/qc fix: 로그인 버그 수정       # 메시지 직접 지정
```

### 🧹 cleanup
프로젝트 정리 자동화 - 임시파일, node_modules, 캐시 제거

**사용 예시:**
```
/cleanup                  # 캐시만 정리
/cleanup --all           # 전체 정리 (의존성 재설치)
/cleanup --dry-run       # 미리보기
```

### 🔍 search-kr
한국어 코드베이스 검색 최적화

**사용 예시:**
```
/search-kr 로그인
/search-kr 에러 --type js
/검색 TODO -C 5
```

## ✨ 커스터마이징

### 새 Skill 만들기

1. **템플릿 복사**
```bash
cp templates/skill-template.md skills/personal/my-skill.md
```

2. **내용 작성**
```markdown
---
name: my-skill
description: 내 커스텀 skill 설명
trigger: 키워드1, 키워드2
---

# My Skill

## 목적
...
```

3. **plugin.json에 등록 (선택)**
```json
{
  "skills": {
    "personal": ["skills/personal/**/*.md"]
  }
}
```

### 새 Command 만들기

1. **템플릿 복사**
```bash
cp templates/command-template.md commands/personal/my-command.md
```

2. **내용 작성**
```markdown
---
name: my-command
description: 내 커스텀 command 설명
aliases: [mc, myc]
---

# My Command
...
```

## 🔧 관리 명령어

### 플러그인 검증
```bash
./validate.sh
```

다음 항목을 검사합니다:
- ✅ 필수 파일 존재 여부
- ✅ plugin.json 구조 유효성
- ✅ Skills/Commands 문법 검증
- ✅ 경로 정확성

### 플러그인 제거
```bash
./uninstall.sh
```

안전하게 플러그인을 제거합니다:
- 🔍 설치 위치 자동 감지
- ⚠️  삭제 전 확인 프롬프트
- 🗑️  완전 제거 또는 백업 옵션

## 📖 문서

각 skill/command는 상세한 문서를 포함합니다:
- 목적 및 사용 시점
- 실행 단계
- 사용 예제
- 옵션 설명
- 주의사항

상세 내용은 각 파일을 참고하세요:
- Skills: `skills/examples/*.md`
- Commands: `commands/examples/*.md`

## 🎯 사용 팁

### Skill vs Command
- **Skill**: 복잡한 워크플로우, 다단계 작업
- **Command**: 간단한 유틸리티, 빠른 실행

### 자주 사용하는 조합
```bash
# 작업 전: 프로젝트 상태 확인
/hello-world

# 개발 중: 빠른 검색
/search-kr 함수명

# 작업 후: 빠른 커밋
/quickcommit

# 코드 리뷰 전: 프로젝트 정리
/cleanup --cache
```

### 효율적인 워크플로우
1. `/hello-world` - 현재 상태 파악
2. 코드 작성...
3. `/search-kr` - 기존 코드 참고
4. `/quickcommit` - 빠른 커밋
5. `/code-review-kr` - PR 전 자체 리뷰

## 🤝 기여하기

새로운 skill이나 command를 추가하고 싶으시다면:

1. Fork this repository
2. 새 브랜치 생성 (`git checkout -b feature/my-skill`)
3. 템플릿 기반으로 작성
4. 테스트 및 검증
5. Pull Request 생성

### 기여 가이드라인
- 템플릿 구조 준수
- 명확한 문서 작성
- 예제 코드 포함
- 한글 지원 고려

## 🐛 문제 해결

### 설치 후 인식 안 됨
```bash
# Claude Code 재시작
# 또는
# 플러그인 디렉토리 확인
ls -la ~/.claude/plugins/claude-helper
```

### Skill 실행 안 됨
```bash
# plugin.json 검증
./validate.sh

# 권한 확인
chmod +x *.sh
```

### 커스텀 skill 작동 안 됨
- `plugin.json`에 경로가 올바르게 등록되었는지 확인
- Frontmatter (---) 형식이 올바른지 확인
- Claude Code 재시작

## 📄 라이선스

MIT License

## 👤 작성자

**Your Name**

## 🙏 감사

- Claude Code team
- 오픈소스 커뮤니티

## 🔗 관련 링크

- [Claude Code 공식 문서](https://docs.anthropic.com/claude/docs)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
- [Skill 작성 가이드](./docs/)

---

**Made with ❤️ for Claude Code users**
