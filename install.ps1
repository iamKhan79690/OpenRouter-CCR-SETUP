<#
.SYNOPSIS
    Professional CCR Setup for OpenRouter (Windows)
#>

function Write-Step { param($msg) Write-Host "[*] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[✓] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[!] $msg" -ForegroundColor Yellow }
function Write-Fail { param($msg) Write-Host "[✗] $msg" -ForegroundColor Red }
function Write-Header { param($msg) Write-Host "`n=== $msg ===" -ForegroundColor Magenta -BackgroundColor Black }

function Get-InputWithTimeout {
    param(
        [string]$Prompt,
        [int]$TimeoutSeconds
    )
    
    Write-Host "$Prompt" -NoNewline
    $startTime = Get-Date
    $inputBuffer = ""
    
    while ($true) {
        $elapsed = (Get-Date) - $startTime
        $remaining = $TimeoutSeconds - [int]$elapsed.TotalSeconds
        
        if ($remaining -le 0) {
            Write-Host "`n"
            return $null
        }
        
        # Display countdown on the same line if possible, or just wait
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq "Enter") {
                Write-Host ""
                return $inputBuffer
            }
            if ($key.Key -eq "Backspace") {
                if ($inputBuffer.Length -gt 0) {
                    $inputBuffer = $inputBuffer.Substring(0, $inputBuffer.Length - 1)
                    Write-Host "`b `b" -NoNewline
                }
            } else {
                $inputBuffer += $key.KeyChar
                Write-Host "*" -NoNewline # Masking API Key
            }
        }
        
        $m = [Math]::Floor($remaining / 60)
        $s = $remaining % 60
        $timerStr = " [$($m):$($s.ToString('00')) remaining] "
        
        # This is a bit flickery in some terminals but works for countdown
        $currentPos = [Console]::CursorLeft
        Write-Host "$timerStr" -NoNewline -ForegroundColor Gray
        Start-Sleep -Milliseconds 100
        [Console]::SetCursorPosition($currentPos, [Console]::CursorTop)
        # Clear the timer string area
        Write-Host (" " * $timerStr.Length) -NoNewline
        [Console]::SetCursorPosition($currentPos, [Console]::CursorTop)
    }
}

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

# Step 4: API Key with 15-minute countdown
Write-Header "API KEY CONFIGURATION"
Write-Host "Get your key from: https://openrouter.ai/keys" -ForegroundColor Yellow
Write-Host "Note: You have 15 minutes to paste your key before this script times out." -ForegroundColor Gray

$apiKey = ""
$validKey = $false

while (!$validKey) {
    $apiKey = Get-InputWithTimeout -Prompt "Paste your OpenRouter API Key (starts with sk-or-v1-): " -TimeoutSeconds 900
    
    if ($null -eq $apiKey) {
        Write-Fail "Timeout reached! Script cancelled."
        exit 1
    }

    if ($apiKey -notmatch "^sk-or-v1-") {
        Write-Warn "Wait! That doesn't look like a valid OpenRouter key (it should start with sk-or-v1-)."
        $confirm = Read-Host "Are you sure you want to use it anyway? (y/N)"
        if ($confirm -eq 'y') { 
            $validKey = $true 
        } else {
            Write-Host "Please try again..." -ForegroundColor Cyan
        }
    } else {
        $validKey = $true
    }
}

# Step 5: config.json
$configPath = "$CCR_DIR\config.json"
$config = @{
    Provider = @{
        openrouter = @{
            type = "OpenAIAzure"
            model = "xiaomi/mimo-v2-flash:free"
            config = @{
                apiVersion = "2024-10-21"
                baseUrl = "https://openrouter.ai/api/v1"
                apiKey = $apiKey
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

$config | Set-Content -Path $configPath -Encoding utf8
Write-Success "Configuration file created successfully at $configPath"

Write-Header "SETUP COMPLETE!"
Write-Host "You are now ready to use Claude Code Router! 🎉" -ForegroundColor Green
Write-Host "Try running: ccr --help" -ForegroundColor Cyan
Write-Host ""
