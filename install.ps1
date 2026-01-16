<#
.SYNOPSIS
    Professional CCR Setup for OpenRouter (Windows)
#>

function Write-Step { param($msg) Write-Host "[*] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[✓] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[!] $msg" -ForegroundColor Yellow }
function Write-Fail { param($msg) Write-Host "[✗] $msg" -ForegroundColor Red }
function Write-Header { param($msg) Write-Host "`n=== $msg ===" -ForegroundColor Magenta -BackgroundColor Black }

Clear-Host
Write-Header "Claude Code Router (CCR) + OpenRouter Auto-Setup"
Write-Host "Welcome student! Let's get your AI environment ready. 🚀" -ForegroundColor Cyan

# Step 1: Check Node.js
Write-Step "Checking for Node.js..."
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Fail "Node.js not found!"
    Write-Host "Students: Please download and install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}
Write-Success "Node.js is ready: $(node -v)"

# Step 2: Install/Update CCR
Write-Step "Ensuring Claude Code Router is installed..."
npm install -g @anthropics/claude-code-router --silent
Write-Success "CCR is installed and ready."

# Step 3: Setup Directory
$CCR_DIR = "$env:USERPROFILE\.claude-code-router"
if (!(Test-Path $CCR_DIR)) {
    New-Item -ItemType Directory -Path $CCR_DIR -Force | Out-Null
}
Write-Success "Config directory set: $CCR_DIR"

# Step 4: API Key
Write-Header "API KEY CONFIGURATION"
Write-Host "Get your key from: https://openrouter.ai/keys" -ForegroundColor Yellow
$apiKey = Read-Host "Paste your OpenRouter API Key (starts with sk-or-v1-)"

if ($apiKey -notmatch "^sk-or-v1-") {
    Write-Warn "Wait! That doesn't look like a valid OpenRouter key."
    $confirm = Read-Host "Are you sure you want to use it? (y/N)"
    if ($confirm -ne 'y') { exit 1 }
}

# Save .env
"OPENROUTER_API_KEY=$apiKey" | Set-Content -Path "$CCR_DIR\.env" -Encoding utf8
Write-Success "API Key saved securely in .env"

# Step 5: config.json
$config = @{
    Provider = @{
        openrouter = @{
            type = "OpenAIAzure"
            model = "xiaomi/mimo-v2-flash:free"
            config = @{
                apiVersion = "2024-10-21"
                baseUrl = "https://openrouter.ai/api/v1"
            }
        }
    }
    Router = @{
        default = "openrouter,xiaomi/mimo-v2-flash:free"
        background = ""
        think = ""
        longContext = ""
        titleGen = ""
        searchTool = ""
    }
} | ConvertTo-Json -Depth 10

$config | Set-Content -Path "$CCR_DIR\config.json" -Encoding utf8
Write-Success "Configuration file created successfully."

Write-Header "SETUP COMPLETE!"
Write-Host "You are now ready to use Claude Code Router! 🎉" -ForegroundColor Green
Write-Host "Try running: ccr --help" -ForegroundColor Cyan
Write-Host ""
