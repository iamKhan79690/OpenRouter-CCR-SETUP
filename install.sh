#!/bin/bash
#
# Claude Code Router (CCR) Setup Script for OpenRouter
# This script automatically installs and configures Claude Code Router
# with OpenRouter integration for free AI model access.
#
# Usage: curl -fsSL <URL> | bash
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Functions
step() { echo -e "${CYAN}[*] $1${NC}"; }
success() { echo -e "${GREEN}[✓] $1${NC}"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }
fail() { echo -e "${RED}[✗] $1${NC}"; }

# Configuration
CCR_DIR="$HOME/.claude-code-router"
ENV_FILE="$CCR_DIR/.env"
CONFIG_FILE="$CCR_DIR/config.json"
DEFAULT_MODEL="xiaomi/mimo-v2-flash:free"

echo ""
echo -e "${MAGENTA}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║   Claude Code Router (CCR) + OpenRouter Setup Script      ║${NC}"
echo -e "${MAGENTA}║   Automated installation for Linux/macOS                  ║${NC}"
echo -e "${MAGENTA}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Check Node.js
step "Checking Node.js installation..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    success "Node.js is installed: $NODE_VERSION"
else
    fail "Node.js is not installed!"
    echo ""
    echo -e "${YELLOW}Please install Node.js from: https://nodejs.org/${NC}"
    echo -e "${YELLOW}Or use your package manager:${NC}"
    echo "  • Ubuntu/Debian: sudo apt install nodejs npm"
    echo "  • macOS: brew install node"
    echo "  • Arch: sudo pacman -S nodejs npm"
    echo ""
    echo -e "${YELLOW}After installation, run this script again.${NC}"
    exit 1
fi

# Step 2: Install Claude Code Router
step "Installing Claude Code Router globally..."
if npm install -g @anthropics/claude-code-router 2>/dev/null; then
    success "Claude Code Router installed successfully"
else
    warn "CCR may already be installed or there was an issue. Continuing..."
fi

# Step 3: Create configuration directory
step "Creating configuration directory..."
if [ ! -d "$CCR_DIR" ]; then
    mkdir -p "$CCR_DIR"
    success "Created directory: $CCR_DIR"
else
    warn "Directory already exists: $CCR_DIR"
fi

# Step 4: Get OpenRouter API Key
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  OpenRouter API Key Setup${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Get your FREE API key from: https://openrouter.ai/keys${NC}"
echo ""

# Check for existing API key
API_KEY=""
if [ -f "$ENV_FILE" ]; then
    EXISTING_KEY=$(grep "OPENROUTER_API_KEY=" "$ENV_FILE" 2>/dev/null | cut -d'=' -f2)
    if [ -n "$EXISTING_KEY" ]; then
        echo -e "Existing API key found: ${EXISTING_KEY:0:20}..."
        read -p "Use existing key? (Y/n): " USE_EXISTING
        if [ -z "$USE_EXISTING" ] || [ "${USE_EXISTING,,}" = "y" ]; then
            API_KEY="$EXISTING_KEY"
        fi
    fi
fi

if [ -z "$API_KEY" ]; then
    read -p "Enter your OpenRouter API key (starts with sk-or-v1-): " API_KEY
fi

# Validate API key format
if [[ ! "$API_KEY" =~ ^sk-or-v1- ]]; then
    warn "API key doesn't start with 'sk-or-v1-'. Make sure it's a valid OpenRouter key."
fi

# Step 5: Create .env file
step "Creating environment file..."
cat > "$ENV_FILE" << EOF
# OpenRouter API Configuration
# Get your key from: https://openrouter.ai/keys
OPENROUTER_API_KEY=$API_KEY
EOF
chmod 600 "$ENV_FILE"  # Secure the file
success "Created: $ENV_FILE"

# Step 6: Create config.json
step "Creating configuration file..."
cat > "$CONFIG_FILE" << EOF
{
  "Provider": {
    "openrouter": {
      "type": "OpenAIAzure",
      "model": "$DEFAULT_MODEL",
      "config": {
        "apiVersion": "2024-10-21",
        "baseUrl": "https://openrouter.ai/api/v1"
      }
    }
  },
  "Router": {
    "default": "openrouter,$DEFAULT_MODEL",
    "background": "",
    "think": "",
    "longContext": "",
    "titleGen": "",
    "searchTool": ""
  }
}
EOF
success "Created: $CONFIG_FILE"

# Step 7: Verify installation
echo ""
step "Verifying installation..."
if command -v ccr &> /dev/null; then
    CCR_VERSION=$(ccr --version 2>/dev/null || echo "unknown")
    success "CCR Version: $CCR_VERSION"
else
    warn "Could not verify CCR version. You may need to restart your terminal."
fi

# Summary
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ Setup Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "Configuration files created:"
echo "  • $ENV_FILE"
echo "  • $CONFIG_FILE"
echo ""
echo "Default model: $DEFAULT_MODEL"
echo ""
echo -e "${YELLOW}To change models, edit: $CONFIG_FILE${NC}"
echo ""
echo -e "${CYAN}Available free models:${NC}"
echo "  • xiaomi/mimo-v2-flash:free"
echo "  • meta-llama/llama-3.3-70b-instruct:free"
echo "  • google/gemma-2-9b-it:free"
echo "  • qwen/qwen-2.5-72b-instruct:free"
echo "  • deepseek/deepseek-r1-distill-llama-70b:free"
echo ""
echo -e "${YELLOW}You may need to restart your terminal for changes to take effect.${NC}"
echo ""
