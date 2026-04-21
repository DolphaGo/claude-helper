---
name: your-command-name
description: 간단한 command 설명 (한 줄로)
aliases: [alias1, alias2]  # 단축 명령어 (선택)
---

# Command 이름

## 목적
이 command가 수행하는 작업을 간단히 설명합니다.

## 사용법
```
/your-command-name [옵션] [인자]
```

## 옵션
- `--option1`: 옵션 설명
- `-o, --option2 <값>`: 값을 받는 옵션
- `--flag`: boolean 플래그

## 인자
- `arg1`: 첫 번째 인자 설명
- `arg2` (선택): 두 번째 인자 설명

## 동작 방식

### 1. 입력 검증
- 필수 인자 확인
- 옵션 파싱

### 2. 실행
- 핵심 로직 수행
- 진행 상황 표시

### 3. 결과 출력
- 성공/실패 메시지
- 요약 정보

## 예제

### 기본 사용
```
/your-command-name input.txt
```
출력:
```
✓ 작업 완료
- 처리된 항목: 10개
```

### 옵션과 함께 사용
```
/your-command-name --option1 --option2 value input.txt
```

## 에러 처리
- **파일 없음**: `❌ 파일을 찾을 수 없습니다: {path}`
- **권한 없음**: `❌ 권한이 부족합니다`
- **잘못된 형식**: `❌ 올바른 형식이 아닙니다`

## 관련 Commands
- `/related-command`: 관련 기능
- `/another-command`: 유사한 기능

## 주의사항
- 중요한 제약사항
- 알려진 이슈
- 권장 사용 패턴
