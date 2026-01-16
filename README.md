# Claude Code Router (CCR) Setup with OpenRouter

A complete guide and automated scripts to set up Claude Code Router with OpenRouter for **free AI model access** on Windows, Linux, and WSL Ubuntu.

---

## 🚀 Quick Install (One Command)

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/iamKhan79690/ccr-openrouter-setup/main/install.ps1 | iex
```

### Linux / Ubuntu / WSL
```bash
curl -fsSL https://raw.githubusercontent.com/iamKhan79690/ccr-openrouter-setup/main/install.sh | bash
```

### macOS
```bash
curl -fsSL https://raw.githubusercontent.com/iamKhan79690/ccr-openrouter-setup/main/install.sh | bash
```

> **Tip**: These commands work immediately after you clone this repo!

---

## 📋 What These Scripts Do

1. ✅ Check for Node.js installation
2. ✅ Install Claude Code Router globally via npm
3. ✅ Create the configuration directory (`~/.claude-code-router`)
4. ✅ Set up the environment file with your OpenRouter API key
5. ✅ Create a complete `config.json` with OpenRouter integration
6. ✅ Configure a free model (Xiaomi MiMo V2 Flash)

---

# 📖 Manual Setup Guide

Choose your platform below:

---

## 🪟 Windows Manual Setup

### Prerequisites
- **Node.js** (v18+) - [Download here](https://nodejs.org/)
- **OpenRouter API Key** - [Get one FREE here](https://openrouter.ai/keys)

### Step 1: Install Node.js

1. Download the LTS version from [nodejs.org](https://nodejs.org/)
2. Run the installer
3. Verify installation:
```powershell
node --version
npm --version
```

### Step 2: Install Claude Code Router

Open PowerShell and run:
```powershell
npm install -g @anthropics/claude-code-router
```

### Step 3: Create Configuration Directory

```powershell
mkdir "$env:USERPROFILE\.claude-code-router" -Force
```

### Step 4: Get Your OpenRouter API Key

1. Go to [openrouter.ai/keys](https://openrouter.ai/keys)
2. Sign up or log in
3. Create a new API key
4. Copy the key (starts with `sk-or-v1-`)

### Step 5: Create Environment File

Create `C:\Users\YOUR_USERNAME\.claude-code-router\.env`:
```powershell
notepad "$env:USERPROFILE\.claude-code-router\.env"
```

Add this content (replace with your actual key):
```env
OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE
```

### Step 6: Create Configuration File

Create `C:\Users\YOUR_USERNAME\.claude-code-router\config.json`:
```powershell
notepad "$env:USERPROFILE\.claude-code-router\config.json"
```

Add this content:
```json
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
```

### Step 7: Verify Installation

```powershell
ccr --version
```

---

## 🐧 Ubuntu / WSL Manual Setup

### Prerequisites
- **Ubuntu 20.04+** or **WSL2 with Ubuntu**
- **OpenRouter API Key** - [Get one FREE here](https://openrouter.ai/keys)

### Step 1: Update System Packages

```bash
sudo apt update && sudo apt upgrade -y
```

### Step 2: Install Node.js

**Option A: Using NodeSource (Recommended)**
```bash
# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

**Option B: Using nvm (Node Version Manager)**
```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Reload shell
source ~/.bashrc

# Install Node.js
nvm install 20
nvm use 20
```

Verify installation:
```bash
node --version
npm --version
```

### Step 3: Install Claude Code Router

```bash
sudo npm install -g @anthropics/claude-code-router
```

Or without sudo (if using nvm):
```bash
npm install -g @anthropics/claude-code-router
```

### Step 4: Create Configuration Directory

```bash
mkdir -p ~/.claude-code-router
```

### Step 5: Get Your OpenRouter API Key

1. Go to [openrouter.ai/keys](https://openrouter.ai/keys)
2. Sign up or log in
3. Create a new API key
4. Copy the key (starts with `sk-or-v1-`)

### Step 6: Create Environment File

```bash
nano ~/.claude-code-router/.env
```

Add this content (replace with your actual key):
```env
OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE
```

Save: `Ctrl+O`, then `Enter`, then `Ctrl+X`

Secure the file:
```bash
chmod 600 ~/.claude-code-router/.env
```

### Step 7: Create Configuration File

```bash
nano ~/.claude-code-router/config.json
```

Add this content:
```json
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
```

Save: `Ctrl+O`, then `Enter`, then `Ctrl+X`

### Step 8: Verify Installation

```bash
ccr --version
```

---

## 🍎 macOS Manual Setup

### Prerequisites
- **Homebrew** (recommended) - [Install here](https://brew.sh/)
- **OpenRouter API Key** - [Get one FREE here](https://openrouter.ai/keys)

### Step 1: Install Node.js

```bash
brew install node
```

Or download from [nodejs.org](https://nodejs.org/)

### Step 2: Install Claude Code Router

```bash
npm install -g @anthropics/claude-code-router
```

### Step 3: Create Configuration Directory

```bash
mkdir -p ~/.claude-code-router
```

### Step 4-7: Same as Ubuntu

Follow Steps 5-8 from the Ubuntu section above.

---

## 🎯 Available Free Models

You can swap the model in your config with any of these free options:

| Model | Config Value |
|-------|--------------|
| **Xiaomi MiMo V2 Flash** | `xiaomi/mimo-v2-flash:free` |
| Meta Llama 3.3 70B | `meta-llama/llama-3.3-70b-instruct:free` |
| Google Gemma 2 9B | `google/gemma-2-9b-it:free` |
| Qwen 2.5 72B | `qwen/qwen-2.5-72b-instruct:free` |
| DeepSeek R1 Distill | `deepseek/deepseek-r1-distill-llama-70b:free` |

To change models, update **both** of these in `config.json`:
1. `Provider.openrouter.model`
2. `Router.default`

---

## 🔧 Configuration Options

| Router Option | Description |
|---------------|-------------|
| `default` | Main model for general queries |
| `background` | Model for background tasks |
| `think` | Model for reasoning/thinking |
| `longContext` | Model for long context handling |
| `titleGen` | Model for title generation |
| `searchTool` | Model for search operations |

Leave options empty (`""`) to use the default model.

---

## 🐛 Troubleshooting

### "Expected comma" Error in config.json
- Ensure all keys and string values use double quotes `"`
- Check for trailing commas (not allowed in JSON)
- Verify brackets `{}` are properly matched

### "API Key not found" Error
- Verify `.env` file exists in `~/.claude-code-router/`
- Ensure the key starts with `sk-or-v1-`
- Check there are no extra spaces around the key

### "Model not found" Error
- Verify the model name is correct
- Some models may be temporarily unavailable
- Try a different free model from the list above

### Permission Denied (Linux/macOS)
```bash
sudo chown -R $USER ~/.claude-code-router
chmod 600 ~/.claude-code-router/.env
```

### Command Not Found: ccr
- Restart your terminal
- Verify npm global bin is in PATH:
```bash
echo $PATH | grep npm
```

---

## 📁 Project Structure

```
ccr-openrouter-setup/
├── README.md           # This guide
├── install.ps1         # Windows PowerShell installer
├── install.sh          # Linux/macOS/WSL Bash installer
├── config.json         # Sample configuration file
├── .env.example        # Sample environment file
├── .gitignore          # Git ignore rules
└── LICENSE             # MIT License
```

---

## 📜 License

MIT License - Feel free to use and modify!

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request
