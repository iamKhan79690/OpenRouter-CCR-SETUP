# Simplified setup
$CCR_DIR = "$env:USERPROFILE\.claude-code-router"
if (!(Test-Path $CCR_DIR)) { New-Item -ItemType Directory -Path $CCR_DIR -Force }

Write-Host "=== API KEY CONFIGURATION ===" -ForegroundColor Magenta
$apiKey = Read-Host "Paste your OpenRouter API Key (starts with sk-or-v1-)"

if ($apiKey -eq "") { Write-Error "API Key cannot be empty."; exit 1 }

$configBody = @'
{
  "LOG": true,
  "LOG_LEVEL": "debug",
  "Providers": [
    {
      "name": "openrouter",
      "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
      "api_key": "REPLACE_KEY",
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
'@

$configBody = $configBody.Replace("REPLACE_KEY", $apiKey)
$configBody | Set-Content -Path "$CCR_DIR\config.json" -Encoding Utf8

Write-Host "Setup Complete! Try running: ccr --help" -ForegroundColor Green
