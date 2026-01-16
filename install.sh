#!/bin/bash
# Professional CCR Setup for OpenRouter (Linux/macOS/WSL)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

header() { echo -e "\n${MAGENTA}=== $1 ===${NC}"; }
step() { echo -e "${CYAN}[*] $1${NC}"; }
success() { echo -e "${GREEN}[✓] $1${NC}"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }
fail() { echo -e "${RED}[✗] $1${NC}"; }

clear
header "Claude Code Router (CCR) + OpenRouter Auto-Setup"
echo -e "Welcome student! Let's get your AI environment ready. 🚀"

# Step 1: Check Node.js
step "Checking for Node.js..."
if ! command -v node &> /dev/null; then
    fail "Node.js not found!"
    echo -e "${YELLOW}Please install Node.js from https://nodejs.org/ or via your package manager.${NC}"
    exit 1
fi
success "Node.js is ready: $(node -v)"

# Step 2: Install/Update CCR
step "Ensuring Claude Code Router is installed..."
sudo npm install -g @anthropics/claude-code-router --silent 2>/dev/null || npm install -g @anthropics/claude-code-router --silent
success "CCR is installed and ready."

# Step 3: Setup Directory
CCR_DIR="$HOME/.claude-code-router"
mkdir -p "$CCR_DIR"
success "Config directory set: $CCR_DIR"

# Step 4: API Key
header "API KEY CONFIGURATION"
echo -e "${YELLOW}Get your key from: https://openrouter.ai/keys${NC}"
read -p "Paste your OpenRouter API Key (starts with sk-or-v1-): " API_KEY

if [[ ! $API_KEY =~ ^sk-or-v1- ]]; then
    warn "Wait! That doesn't look like a valid OpenRouter key."
    read -p "Are you sure you want to use it? (y/N): " confirm
    if [[ $confirm != "y" ]]; then exit 1; fi
fi

# Save .env
echo "OPENROUTER_API_KEY=$API_KEY" > "$CCR_DIR/.env"
chmod 600 "$CCR_DIR/.env"
success "API Key saved securely in .env"

# Step 5: config.json
cat > "$CCR_DIR/config.json" << EOF
{
  "Provider": {
    "openrouter": {
      "type": "OpenAIAzure",
      "model": "xiaomi/mimo-v2-flash:free",
      "config": {
        "apiVersion": "2024-10-21",
        "baseUrl": "https://openrouter.ai/api/v1"
      }
    }
  },
  "Router": {
    "default": "openrouter,xiaomi/mimo-v2-flash:free",
    "background": "",
    "think": "",
    "longContext": "",
    "titleGen": "",
    "searchTool": ""
  }
}
EOF
success "Configuration file created successfully."

header "SETUP COMPLETE!"
echo -e "${GREEN}You are now ready to use Claude Code Router! 🎉${NC}"
echo -e "${CYAN}Try running: ccr --help${NC}"
echo ""
