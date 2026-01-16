# 🚀 CCR + OpenRouter Setup - One-Click Install

[![GitHub stars](https://img.shields.io/github/stars/iamKhan79690/OpenRouter-CCR-SETUP?style=flat-square)](https://github.com/iamKhan79690/OpenRouter-CCR-SETUP/stargazers)
[![License](https://img.shields.io/github/license/iamKhan79690/OpenRouter-CCR-SETUP?style=flat-square)](https://github.com/iamKhan79690/OpenRouter-CCR-SETUP/blob/main/LICENSE)

Use **Claude Code** with **free AI models** via **OpenRouter** - no Anthropic API key needed!

---

## ⚡ One-Click Setup

### 🪟 Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/iamKhan79690/OpenRouter-CCR-SETUP/main/install.ps1 | iex
```

### 🐧 Linux / macOS / WSL
```bash
curl -fsSL https://raw.githubusercontent.com/iamKhan79690/OpenRouter-CCR-SETUP/main/install.sh | bash
```

---

## 📋 What the Script Does

1. **Checks Prerequisites** - Verifies Node.js is installed
2. **Installs Claude Code** - `npm install -g @anthropic-ai/claude-code`
3. **Installs CCR** - `npm install -g @musistudio/claude-code-router`
4. **Creates Config** - Sets up `~/.claude-code-router/config.json`
5. **Prompts for API Key** - Waits for your OpenRouter key
6. **Sets Environment Variables**:
   - `ANTHROPIC_BASE_URL` = `http://127.0.0.1:3456`
   - `ANTHROPIC_AUTH_TOKEN` = Your OpenRouter API key
7. **Displays Instructions** - Shows how to start using CCR

---

## 🎯 Usage After Setup

**Terminal 1:**
```bash
ccr start
```

**Terminal 2:**
```bash
ccr code
```

Or use `ccr ui` for a web-based configuration interface.

---

## 🔑 Getting Your API Key

1. Go to [openrouter.ai/keys](https://openrouter.ai/keys)
2. Create an account (free)
3. Generate an API key (starts with `sk-or-v1-`)
4. Paste it when the script asks

---

## 🎨 Free Models Included

| Model | Best For |
|-------|----------|
| `qwen/qwen3-coder:free` | **Default** - Code generation |
| `qwen/qwen3-14b:free` | General purpose |
| `google/gemini-2.0-flash-exp:free` | Fast responses |
| `meta-llama/llama-3.3-70b-instruct:free` | High intelligence |
| `xiaomi/mimo-v2-flash:free` | Efficient coding |

---

## 📖 Manual Setup

If you prefer manual installation:

### 1. Install Node.js
- **Windows**: [nodejs.org](https://nodejs.org/)
- **Ubuntu/Debian**: `sudo apt install nodejs npm`
- **macOS**: `brew install node`

### 2. Install Packages
```bash
npm install -g @anthropic-ai/claude-code
npm install -g @musistudio/claude-code-router
```

### 3. Create Config
Create `~/.claude-code-router/config.json`:
```json
{
  "LOG": true,
  "LOG_LEVEL": "debug",
  "Providers": [
    {
      "name": "openrouter",
      "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
      "api_key": "YOUR_API_KEY_HERE",
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
    "default": "openrouter,qwen/qwen3-coder:free"
  }
}
```

### 4. Set Environment Variables

**Windows (PowerShell):**
```powershell
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "http://127.0.0.1:3456", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "your-api-key", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "", "User")
```

**Linux/macOS (add to ~/.bashrc or ~/.zshrc):**
```bash
export ANTHROPIC_BASE_URL="http://127.0.0.1:3456"
export ANTHROPIC_AUTH_TOKEN="your-api-key"
export ANTHROPIC_API_KEY=""
```

---

## 🛠️ Troubleshooting

> **"Command not found: ccr"**  
> Restart your terminal after installation.

> **"API Key Format Warning"**  
> OpenRouter keys should start with `sk-or-v1-`.

---

## 📜 License

MIT License - See [LICENSE](LICENSE)

---

Made with ❤️ by [iamKhan79690](https://github.com/iamKhan79690)
