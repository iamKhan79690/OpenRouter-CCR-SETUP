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

# Function for countdown input
get_input_timeout() {
    local prompt="$1"
    local timeout=$2
    local start_time=$(date +%s)
    local input=""

    echo -ne "$prompt"
    
    while true; do
        local now=$(date +%s)
        local elapsed=$((now - start_time))
        local remaining=$((timeout - elapsed))

        if [ $remaining -le 0 ]; then
            echo -e "\n"
            return 1
        fi

        # Format time
        local m=$((remaining / 60))
        local s=$((remaining % 60))
        local timer=$(printf " [%d:%02d remaining] " $m $s)

        # Show timer and wait for 1 char of input
        echo -ne "\033[s$timer\033[u"
        if read -s -n 1 -t 1 char; then
            if [[ $char == $'\0' || $char == "" ]]; then
                # Enter pressed
                echo -e ""
                echo "$input"
                return 0
            elif [[ $char == $'\177' ]]; then
                # Backspace
                if [ ${#input} -gt 0 ]; then
                    input="${input%?}"
                    echo -ne "\b \b"
                fi
            else
                input+="$char"
                echo -ne "*"
            fi
        fi
        # Clear timer string area before next loop
        local spaces=$(printf "%${#timer}s")
        echo -ne "\033[s$spaces\033[u"
    done
}

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

# Step 4: API Key with 15-minute countdown
header "API KEY CONFIGURATION"
echo -e "${YELLOW}Get your key from: https://openrouter.ai/keys${NC}"
echo -e "Note: You have 15 minutes to paste your key before this script times out."

VALID_KEY=false
while [ "$VALID_KEY" = false ]; do
    API_KEY=$(get_input_timeout "Paste your OpenRouter API Key (starts with sk-or-v1-): " 900)
    
    if [ $? -ne 0 ]; then
        fail "Timeout reached! Script cancelled."
        exit 1
    fi

    if [[ ! $API_KEY =~ ^sk-or-v1- ]]; then
        warn "Wait! That doesn't look like a valid OpenRouter key (it should start with sk-or-v1-)."
        read -p "Are you sure you want to use it anyway? (y/N): " confirm
        if [[ $confirm == "y" ]]; then 
            VALID_KEY=true
        else
            echo -e "${CYAN}Please try again...${NC}"
        fi
    else
        VALID_KEY=true
    fi
done

# Step 5: config.json
cat > "$CCR_DIR/config.json" << EOF
{
  "Provider": {
    "openrouter": {
      "type": "OpenAIAzure",
      "model": "xiaomi/mimo-v2-flash:free",
      "config": {
        "apiVersion": "2024-10-21",
        "baseUrl": "https://openrouter.ai/api/v1",
        "apiKey": "$API_KEY"
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
chmod 600 "$CCR_DIR/config.json"
success "Configuration file created successfully at $CCR_DIR/config.json"

header "SETUP COMPLETE!"
echo -e "${GREEN}You are now ready to use Claude Code Router! 🎉${NC}"
echo -e "${CYAN}Try running: ccr --help${NC}"
echo ""
