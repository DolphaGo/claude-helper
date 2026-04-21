#!/bin/bash

set -e

echo "🔍 Validating skills and commands..."

ERROR_COUNT=0
WARNING_COUNT=0
NAMES_FILE=$(mktemp)
trap "rm -f $NAMES_FILE" EXIT

# 색상 정의
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Markdown 파일 검증 함수
validate_file() {
    local file=$1
    local has_error=false

    # 빈 파일 체크
    if [ ! -s "$file" ]; then
        echo -e "${RED}✗ ERROR${NC}: $file is empty"
        ((ERROR_COUNT++))
        return 1
    fi

    # frontmatter 존재 확인
    local first_line=$(head -n 1 "$file")
    if [ "$first_line" != "---" ]; then
        echo -e "${RED}✗ ERROR${NC}: $file missing frontmatter (must start with ---)"
        ((ERROR_COUNT++))
        has_error=true
    fi

    # frontmatter 끝 확인
    local second_marker=$(sed -n '2,/^---$/p' "$file" | tail -n 1)
    if [ "$second_marker" != "---" ]; then
        echo -e "${RED}✗ ERROR${NC}: $file frontmatter not properly closed"
        ((ERROR_COUNT++))
        has_error=true
    fi

    # name 필드 확인
    local name=$(sed -n '/^---$/,/^---$/p' "$file" | grep "^name:" | cut -d: -f2- | xargs)
    if [ -z "$name" ]; then
        echo -e "${RED}✗ ERROR${NC}: $file missing 'name' field in frontmatter"
        ((ERROR_COUNT++))
        has_error=true
    else
        # name 형식 검증 (영문, 숫자, 하이픈만)
        if ! [[ "$name" =~ ^[a-zA-Z0-9-]+$ ]]; then
            echo -e "${RED}✗ ERROR${NC}: $file name '$name' contains invalid characters (use only a-z, 0-9, -)"
            ((ERROR_COUNT++))
            has_error=true
        fi

        # 중복 name 체크
        local duplicate=$(grep "^$name:" "$NAMES_FILE" 2>/dev/null | cut -d: -f2-)
        if [ -n "$duplicate" ]; then
            echo -e "${RED}✗ ERROR${NC}: Duplicate name '$name' found in:"
            echo -e "  - $duplicate"
            echo -e "  - $file"
            ((ERROR_COUNT++))
            has_error=true
        else
            echo "$name:$file" >> "$NAMES_FILE"
        fi

        # 파일명과 name 일치 권장
        local filename=$(basename "$file" .md)
        if [ "$filename" != "$name" ]; then
            echo -e "${YELLOW}⚠ WARNING${NC}: $file filename '$filename' differs from name '$name' (recommended to match)"
            ((WARNING_COUNT++))
        fi
    fi

    # description 필드 확인
    local description=$(sed -n '/^---$/,/^---$/p' "$file" | grep "^description:" | cut -d: -f2- | xargs)
    if [ -z "$description" ]; then
        echo -e "${RED}✗ ERROR${NC}: $file missing 'description' field in frontmatter"
        ((ERROR_COUNT++))
        has_error=true
    fi

    # frontmatter 후 본문 확인
    local end_line=$(awk '/^---$/{n++; if(n==2){print NR; exit}}' "$file")
    if [ -n "$end_line" ]; then
        local body_lines=$(tail -n +"$((end_line + 1))" "$file" | grep -v '^[[:space:]]*$' | wc -l)
    else
        local body_lines=0
    fi
    if [ "$body_lines" -eq 0 ]; then
        echo -e "${RED}✗ ERROR${NC}: $file has no content after frontmatter"
        ((ERROR_COUNT++))
        has_error=true
    fi

    if [ "$has_error" = false ]; then
        echo -e "${GREEN}✓${NC} $file"
    fi
}

# skills 폴더 검증
if [ -d "skills" ]; then
    echo ""
    echo "📋 Validating skills..."
    while IFS= read -r -d '' file; do
        validate_file "$file"
    done < <(find skills -name "*.md" -type f -print0)
fi

# commands 폴더 검증
if [ -d "commands" ]; then
    echo ""
    echo "📋 Validating commands..."
    while IFS= read -r -d '' file; do
        validate_file "$file"
    done < <(find commands -name "*.md" -type f -print0)
fi

# 결과 출력
echo ""
echo "════════════════════════════════════════"
if [ $ERROR_COUNT -eq 0 ] && [ $WARNING_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ All validations passed!${NC}"
    exit 0
elif [ $ERROR_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ Validation passed with $WARNING_COUNT warning(s)${NC}"
    exit 0
else
    echo -e "${RED}✗ Validation failed with $ERROR_COUNT error(s) and $WARNING_COUNT warning(s)${NC}"
    exit 1
fi
