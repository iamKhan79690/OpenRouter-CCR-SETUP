#!/bin/bash
# CCR + OpenRouter Professional Setup Script for Linux/macOS/WSL
# https://github.com/musistudio/claude-code-router

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
NC='\033[0m'

header() { echo -e "\n${MAGENTA}=== $1 ===${NC}"; }
step() { echo -e "${CYAN}[*] $1${NC}"; }
success() { echo -e "${GREEN}[OK] $1${NC}"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }
fail() { echo -e "${RED}[X] $1${NC}"; }

clear
header "CCR + OpenRouter Setup for Linux/macOS"
echo -e "${GRAY}This script will set up Claude Code Router with OpenRouter.${NC}"

# ============================================
# STEP 1: Check Prerequisites (Node.js)
# ============================================
header "STEP 1: Checking Prerequisites"

step "Checking for Node.js..."

if ! command -v node &> /dev/null; then
    fail "Node.js is NOT installed!"
    echo ""
    echo -e "${YELLOW}Please install Node.js first:${NC}"
    echo -e "  Ubuntu/Debian: sudo apt install nodejs npm"
    echo -e "  macOS: brew install node"
    echo -e "  Or visit: https://nodejs.org/"
    echo ""
    
    echo -n "Would you like to try installing via package manager? (y/N): "
    read -r install_choice < /dev/tty
    install_choice=$(echo "$install_choice" | tr -d '\r' | xargs)
    if [[ $install_choice == "y" ]]; then
        if command -v apt &> /dev/null; then
            step "Installing Node.js via apt..."
            sudo apt update && sudo apt install -y nodejs npm
        elif command -v brew &> /dev/null; then
            step "Installing Node.js via Homebrew..."
            brew install node
        else
            fail "Could not detect package manager. Please install Node.js manually."
            exit 1
        fi
    else
        exit 1
    fi
fi
success "Node.js is installed: $(node -v)"

# ============================================
# STEP 2: Install Claude Code and CCR
# ============================================
header "STEP 2: Installing Claude Code and CCR"

step "Installing Claude Code (@anthropic-ai/claude-code)..."
sudo npm install -g @anthropic-ai/claude-code 2>/dev/null || npm install -g @anthropic-ai/claude-code
success "Claude Code installed."

step "Installing Claude Code Router (@musistudio/claude-code-router)..."
sudo npm install -g @musistudio/claude-code-router 2>/dev/null || npm install -g @musistudio/claude-code-router
success "Claude Code Router installed."

# ============================================
# STEP 3: Setup Config Directory
# ============================================
header "STEP 3: Setting Up Configuration"

CCR_DIR="$HOME/.claude-code-router"
CONFIG_PATH="$CCR_DIR/config.json"

if [ ! -d "$CCR_DIR" ]; then
    mkdir -p "$CCR_DIR"
    success "Created config directory: $CCR_DIR"
else
    success "Config directory exists: $CCR_DIR"
fi

# ============================================
# STEP 4: Prompt for OpenRouter API Key
# ============================================
header "STEP 4: OpenRouter API Key"
echo ""
echo -e "${YELLOW}Get your API key from: https://openrouter.ai/keys${NC}"
echo -e "${GRAY}Your key should start with: sk-or-v1-${NC}"
echo ""

VALID_KEY=false
while [ "$VALID_KEY" = false ]; do
    # Read specifically from /dev/tty to handle curl | bash pipes
    # tr -d '\r' is used to clean up Windows-style line endings from pastes
    echo -n "Paste your OpenRouter API Key: "
    read -r API_KEY < /dev/tty
    API_KEY=$(echo "$API_KEY" | tr -d '\r' | xargs)
    
    if [ -z "$API_KEY" ]; then
        warn "API Key cannot be empty. Please try again."
        continue
    fi
    
    if [[ ! $API_KEY =~ ^sk-or-v1- ]]; then
        warn "This key doesn't start with 'sk-or-v1-'."
        echo -n "Use it anyway? (y/N): "
        read -r confirm < /dev/tty
        confirm=$(echo "$confirm" | tr -d '\r' | xargs)
        if [[ $confirm == "y" ]]; then
            VALID_KEY=true
        fi
    else
        VALID_KEY=true
        success "API Key accepted."
    fi
done

# ============================================
# STEP 5: Create/Update config.json
# ============================================
header "STEP 5: Creating Configuration File"

cat > "$CONFIG_PATH" << EOF
{
  "LOG": true,
  "LOG_LEVEL": "debug",
  "Providers": [
    {
      "name": "openrouter",
      "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
      "api_key": "$API_KEY",
      "models": [
        "qwen/qwen3-coder:free",
        "qwen/qwen3-14b:free",
        "google/gemini-2.0-flash-exp:free",
        "meta-llama/llama-3.3-70b-instruct:free",
        "xiaomi/mimo-v2-flash:free"
      ],
      "transformer": {
        "use": ["openrouter"]
      }
    }
  ],
  "Router": {
    "default": "openrouter,xiaomi/mimo-v2-flash:free",
    "background": "",
    "think": "",
    "longContext": "",
    "longContextThreshold": 60000,
    "webSearch": "",
    "image": ""
  }
}
EOF

chmod 600 "$CONFIG_PATH"
success "Configuration saved to: $CONFIG_PATH"

# ============================================
# STEP 6: Set Environment Variables
# ============================================
header "STEP 6: Setting Environment Variables"

# Detect shell config file
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    SHELL_CONFIG="$HOME/.profile"
fi

step "Adding environment variables to $SHELL_CONFIG..."

# Remove old entries if they exist
sed -i.bak '/# CCR OpenRouter Setup/d' "$SHELL_CONFIG" 2>/dev/null || true
sed -i.bak '/ANTHROPIC_BASE_URL/d' "$SHELL_CONFIG" 2>/dev/null || true
sed -i.bak '/ANTHROPIC_AUTH_TOKEN/d' "$SHELL_CONFIG" 2>/dev/null || true
sed -i.bak '/ANTHROPIC_API_KEY/d' "$SHELL_CONFIG" 2>/dev/null || true

# Add new entries
cat >> "$SHELL_CONFIG" << EOF

# CCR OpenRouter Setup
export ANTHROPIC_BASE_URL="http://127.0.0.1:3456"
export ANTHROPIC_AUTH_TOKEN="$API_KEY"
export ANTHROPIC_API_KEY=""
EOF

success "Environment variables added to $SHELL_CONFIG"
warn "Run 'source $SHELL_CONFIG' or restart your terminal to apply changes."

# Also set for current session
export ANTHROPIC_BASE_URL="http://127.0.0.1:3456"
export ANTHROPIC_AUTH_TOKEN="$API_KEY"
export ANTHROPIC_API_KEY=""

# ============================================
# STEP 7: Display Usage Instructions
# ============================================
header "SETUP COMPLETE!"
echo ""
echo -e "${GREEN}To use Claude Code with OpenRouter:${NC}"
echo ""
echo -e "${CYAN}  TERMINAL 1:${NC}"
echo -e "    ccr start"
echo ""
echo -e "${CYAN}  TERMINAL 2:${NC}"
echo -e "    ccr code"
echo ""
echo -e "${GRAY}Or run 'ccr ui' to manage configuration via web interface.${NC}"
echo ""
echo -e "${GREEN}Happy coding! :)${NC}"
