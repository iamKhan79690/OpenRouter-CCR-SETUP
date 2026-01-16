# CCR + OpenRouter Professional Setup Script for Windows
# https://github.com/musistudio/claude-code-router

function Write-Step { param($msg) Write-Host "[*] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[!] $msg" -ForegroundColor Yellow }
function Write-Fail { param($msg) Write-Host "[X] $msg" -ForegroundColor Red }
function Write-Header { param($msg) Write-Host "`n=== $msg ===" -ForegroundColor Magenta }

Clear-Host
Write-Header "CCR + OpenRouter Setup for Windows"
Write-Host "This script will set up Claude Code Router with OpenRouter." -ForegroundColor Gray

# ============================================
# STEP 1: Check Prerequisites (Node.js)
# ============================================
Write-Header "STEP 1: Checking Prerequisites"

Write-Step "Checking for Node.js..."
$nodeInstalled = Get-Command node -ErrorAction SilentlyContinue

if (-not $nodeInstalled) {
    Write-Fail "Node.js is NOT installed!"
    Write-Host ""
    Write-Host "Please install Node.js first:" -ForegroundColor Yellow
    Write-Host "  1. Go to: https://nodejs.org/" -ForegroundColor White
    Write-Host "  2. Download and install the LTS version" -ForegroundColor White
    Write-Host "  3. Restart your terminal and run this script again" -ForegroundColor White
    Write-Host ""
    
    $installChoice = Read-Host "Would you like to try installing via winget? (y/N)"
    if ($installChoice -eq 'y') {
        Write-Step "Attempting to install Node.js via winget..."
        winget install OpenJS.NodeJS.LTS
        Write-Warn "Please restart your terminal after installation and run this script again."
    }
    exit 1
}
Write-Success "Node.js is installed: $(node -v)"

# ============================================
# STEP 2: Install Claude Code and CCR
# ============================================
Write-Header "STEP 2: Installing Claude Code and CCR"

Write-Step "Installing Claude Code (@anthropic-ai/claude-code)..."
npm install -g @anthropic-ai/claude-code 2>$null
Write-Success "Claude Code installed."

Write-Step "Installing Claude Code Router (@musistudio/claude-code-router)..."
npm install -g @musistudio/claude-code-router 2>$null
Write-Success "Claude Code Router installed."

# ============================================
# STEP 3: Setup Config Directory
# ============================================
Write-Header "STEP 3: Setting Up Configuration"

$CCR_DIR = "$env:USERPROFILE\.claude-code-router"
$CONFIG_PATH = "$CCR_DIR\config.json"

if (-not (Test-Path $CCR_DIR)) {
    New-Item -ItemType Directory -Path $CCR_DIR -Force | Out-Null
    Write-Success "Created config directory: $CCR_DIR"
} else {
    Write-Success "Config directory exists: $CCR_DIR"
}

# ============================================
# STEP 4: Prompt for OpenRouter API Key
# ============================================
Write-Header "STEP 4: OpenRouter API Key"
Write-Host ""
Write-Host "Get your API key from: https://openrouter.ai/keys" -ForegroundColor Yellow
Write-Host "Your key should start with: sk-or-v1-" -ForegroundColor Gray
Write-Host ""

$apiKey = ""
$validKey = $false

while (-not $validKey) {
    $apiKey = Read-Host "Paste your OpenRouter API Key"
    
    if ([string]::IsNullOrWhiteSpace($apiKey)) {
        Write-Warn "API Key cannot be empty. Please try again."
        continue
    }
    
    if ($apiKey -notmatch "^sk-or-v1-") {
        Write-Warn "This key doesn't start with 'sk-or-v1-'."
        $confirm = Read-Host "Use it anyway? (y/N)"
        if ($confirm -eq 'y') {
            $validKey = $true
        }
    } else {
        $validKey = $true
        Write-Success "API Key accepted."
    }
}

# ============================================
# STEP 5: Create/Update config.json
# ============================================
Write-Header "STEP 5: Creating Configuration File"

$configContent = @"
{
  "LOG": true,
  "LOG_LEVEL": "debug",
  "Providers": [
    {
      "name": "openrouter",
      "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
      "api_key": "$apiKey",
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
    "default": "openrouter,qwen/qwen3-coder:free",
    "background": "",
    "think": "",
    "longContext": "",
    "longContextThreshold": 60000,
    "webSearch": "",
    "image": ""
  }
}
"@

$configContent | Set-Content -Path $CONFIG_PATH -Encoding UTF8
Write-Success "Configuration saved to: $CONFIG_PATH"

# ============================================
# STEP 6: Set Environment Variables
# ============================================
Write-Header "STEP 6: Setting Environment Variables"

Write-Step "Setting ANTHROPIC_BASE_URL..."
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "http://127.0.0.1:3456", "User")

Write-Step "Setting ANTHROPIC_AUTH_TOKEN..."
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $apiKey, "User")

Write-Step "Clearing ANTHROPIC_API_KEY (must be empty)..."
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "", "User")

Write-Success "Environment variables set for current user."
Write-Warn "Note: You may need to restart your terminal for changes to take effect."

# ============================================
# STEP 7: Display Usage Instructions
# ============================================
Write-Header "SETUP COMPLETE!"
Write-Host ""
Write-Host "To use Claude Code with OpenRouter:" -ForegroundColor Green
Write-Host ""
Write-Host "  TERMINAL 1:" -ForegroundColor Cyan
Write-Host "    ccr start" -ForegroundColor White
Write-Host ""
Write-Host "  TERMINAL 2:" -ForegroundColor Cyan
Write-Host "    ccr code" -ForegroundColor White
Write-Host ""
Write-Host "Or run 'ccr ui' to manage configuration via web interface." -ForegroundColor Gray
Write-Host ""
Write-Host "Happy coding! :)" -ForegroundColor Green
