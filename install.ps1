<#
.SYNOPSIS
    Claude Code Router (CCR) Setup Script for OpenRouter
.DESCRIPTION
    This script automatically installs and configures Claude Code Router
    with OpenRouter integration for free AI model access.
.NOTES
    Run this script in PowerShell with: irm <URL> | iex
#>

# Colors for output
function Write-Step { param($msg) Write-Host "[*] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[✓] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[!] $msg" -ForegroundColor Yellow }
function Write-Fail { param($msg) Write-Host "[✗] $msg" -ForegroundColor Red }

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║   Claude Code Router (CCR) + OpenRouter Setup Script      ║" -ForegroundColor Magenta
Write-Host "║   Automated installation for Windows                      ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# Configuration
$CCR_DIR = "$env:USERPROFILE\.claude-code-router"
$ENV_FILE = "$CCR_DIR\.env"
$CONFIG_FILE = "$CCR_DIR\config.json"
$DEFAULT_MODEL = "xiaomi/mimo-v2-flash:free"

# Step 1: Check Node.js
Write-Step "Checking Node.js installation..."
try {
    $nodeVersion = node --version 2>$null
    if ($nodeVersion) {
        Write-Success "Node.js is installed: $nodeVersion"
    } else {
        throw "Node.js not found"
    }
} catch {
    Write-Fail "Node.js is not installed!"
    Write-Host ""
    Write-Host "Please install Node.js from: https://nodejs.org/" -ForegroundColor Yellow
    Write-Host "After installation, run this script again." -ForegroundColor Yellow
    exit 1
}

# Step 2: Install Claude Code Router
Write-Step "Installing Claude Code Router globally..."
try {
    npm install -g @anthropics/claude-code-router 2>&1 | Out-Null
    Write-Success "Claude Code Router installed successfully"
} catch {
    Write-Warn "CCR may already be installed or there was an issue. Continuing..."
}

# Step 3: Create configuration directory
Write-Step "Creating configuration directory..."
if (!(Test-Path $CCR_DIR)) {
    New-Item -ItemType Directory -Path $CCR_DIR -Force | Out-Null
    Write-Success "Created directory: $CCR_DIR"
} else {
    Write-Warn "Directory already exists: $CCR_DIR"
}

# Step 4: Get OpenRouter API Key
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  OpenRouter API Key Setup" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Get your FREE API key from: https://openrouter.ai/keys" -ForegroundColor Yellow
Write-Host ""

# Check for existing API key
$existingKey = ""
if (Test-Path $ENV_FILE) {
    $existingContent = Get-Content $ENV_FILE -Raw
    if ($existingContent -match "OPENROUTER_API_KEY=(.+)") {
        $existingKey = $matches[1].Trim()
        Write-Host "Existing API key found: $($existingKey.Substring(0,20))..." -ForegroundColor Gray
        $useExisting = Read-Host "Use existing key? (Y/n)"
        if ($useExisting -eq "" -or $useExisting.ToLower() -eq "y") {
            $apiKey = $existingKey
        }
    }
}

if (!$apiKey) {
    $apiKey = Read-Host "Enter your OpenRouter API key (starts with sk-or-v1-)"
}

# Validate API key format
if ($apiKey -notmatch "^sk-or-v1-") {
    Write-Warn "API key doesn't start with 'sk-or-v1-'. Make sure it's a valid OpenRouter key."
}

# Step 5: Create .env file
Write-Step "Creating environment file..."
$envContent = @"
# OpenRouter API Configuration
# Get your key from: https://openrouter.ai/keys
OPENROUTER_API_KEY=$apiKey
"@
Set-Content -Path $ENV_FILE -Value $envContent -Force
Write-Success "Created: $ENV_FILE"

# Step 6: Create config.json
Write-Step "Creating configuration file..."
$configContent = @"
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
"@
Set-Content -Path $CONFIG_FILE -Value $configContent -Force
Write-Success "Created: $CONFIG_FILE"

# Step 7: Verify installation
Write-Host ""
Write-Step "Verifying installation..."
try {
    $ccrVersion = ccr --version 2>$null
    if ($ccrVersion) {
        Write-Success "CCR Version: $ccrVersion"
    }
} catch {
    Write-Warn "Could not verify CCR version. You may need to restart your terminal."
}

# Summary
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✅ Setup Complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Configuration files created:" -ForegroundColor White
Write-Host "  • $ENV_FILE" -ForegroundColor Gray
Write-Host "  • $CONFIG_FILE" -ForegroundColor Gray
Write-Host ""
Write-Host "Default model: $DEFAULT_MODEL" -ForegroundColor White
Write-Host ""
Write-Host "To change models, edit: $CONFIG_FILE" -ForegroundColor Yellow
Write-Host ""
Write-Host "Available free models:" -ForegroundColor Cyan
Write-Host "  • xiaomi/mimo-v2-flash:free" -ForegroundColor Gray
Write-Host "  • meta-llama/llama-3.3-70b-instruct:free" -ForegroundColor Gray
Write-Host "  • google/gemma-2-9b-it:free" -ForegroundColor Gray
Write-Host "  • qwen/qwen-2.5-72b-instruct:free" -ForegroundColor Gray
Write-Host "  • deepseek/deepseek-r1-distill-llama-70b:free" -ForegroundColor Gray
Write-Host ""
Write-Host "You may need to restart your terminal for changes to take effect." -ForegroundColor Yellow
Write-Host ""
