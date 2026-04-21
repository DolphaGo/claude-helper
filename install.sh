#!/bin/bash

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CLAUDE_DIR="$HOME/.claude"
PLUGIN_DIR="$CLAUDE_DIR/plugins/claude-helper"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}   Claude Helper Plugin Installer${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

# 1. validate.sh 실행
echo -e "${BLUE}🔍 Step 1/4: Validating files...${NC}"
if [ -f "$REPO_DIR/validate.sh" ]; then
    cd "$REPO_DIR"
    if ! ./validate.sh; then
        echo -e "${RED}✗ Validation failed. Please fix the errors and try again.${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ validate.sh not found${NC}"
    exit 1
fi
echo ""

# 2. Claude Code 설치 확인
echo -e "${BLUE}🔍 Step 2/4: Checking Claude Code installation...${NC}"
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${RED}✗ Claude Code not found${NC}"
    echo -e "${YELLOW}Please install Claude Code first:${NC}"
    echo -e "  https://claude.ai/code"
    exit 1
fi
echo -e "${GREEN}✓ Claude Code found${NC}"
echo ""

# 3. 기존 설치 확인
echo -e "${BLUE}🔍 Step 3/4: Checking existing installation...${NC}"
if [ -L "$PLUGIN_DIR" ] || [ -d "$PLUGIN_DIR" ]; then
    echo -e "${YELLOW}⚠ Existing installation found at: $PLUGIN_DIR${NC}"
    read -p "Do you want to update? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled${NC}"
        exit 0
    fi
    echo -e "${YELLOW}Removing old installation...${NC}"
    rm -rf "$PLUGIN_DIR"
fi
echo ""

# 4. 심볼릭 링크 생성
echo -e "${BLUE}🔗 Step 4/4: Creating symbolic link...${NC}"

# plugins 디렉토리 생성
mkdir -p "$CLAUDE_DIR/plugins"

# 심볼릭 링크 생성
if ln -s "$REPO_DIR" "$PLUGIN_DIR"; then
    echo -e "${GREEN}✓ Symbolic link created: $PLUGIN_DIR → $REPO_DIR${NC}"
else
    echo -e "${RED}✗ Failed to create symbolic link${NC}"
    echo -e "${YELLOW}Try running with appropriate permissions${NC}"
    exit 1
fi
echo ""

# 5. 설치 완료 메시지
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📚 Available skills and commands:${NC}"
echo ""

# 사용 가능한 skills/commands 출력
if [ -d "$REPO_DIR/skills/examples" ]; then
    echo -e "${YELLOW}Example Skills:${NC}"
    find "$REPO_DIR/skills/examples" -name "*.md" -type f -exec basename {} .md \; | sed 's/^/  \//' || true
    echo ""
fi
if [ -d "$REPO_DIR/commands/examples" ]; then
    echo -e "${YELLOW}Example Commands:${NC}"
    find "$REPO_DIR/commands/examples" -name "*.md" -type f -exec basename {} .md \; | sed 's/^/  \//' || true
    echo ""
fi

echo -e "${BLUE}📖 Next steps:${NC}"
echo "  1. Restart Claude Code (if running)"
echo "  2. Try: /hello-world"
echo "  3. Explore your installed skills and commands"
echo ""
