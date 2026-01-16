# 🚀 Professional CCR Setup for OpenRouter

[![GitHub stars](https://img.shields.io/github/stars/iamKhan79690/OpenRouter-CCR-SETUP?style=flat-square)](https://github.com/iamKhan79690/OpenRouter-CCR-SETUP/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/iamKhan79690/OpenRouter-CCR-SETUP?style=flat-square)](https://github.com/iamKhan79690/OpenRouter-CCR-SETUP/issues)
[![License](https://img.shields.io/github/license/iamKhan79690/OpenRouter-CCR-SETUP?style=flat-square)](https://github.com/iamKhan79690/OpenRouter-CCR-SETUP/blob/main/LICENSE)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=flat-square)](https://github.com/iamKhan79690/OpenRouter-CCR-SETUP/graphs/commit-activity)

**Claude Code Router (CCR)** is a powerful tool to manage AI models. This repository provides an **optimized, student-friendly** configuration to use high-quality AI models via **OpenRouter** for **ZERO COST**.

---

## 🌟 Why This Project?

Most students struggle with complex API configurations. This project simplifies everything into **one command**.
*   **Cost-Efficient**: Uses high-performance free models on OpenRouter.
*   **Simple**: Automated scripts for all Operating Systems.
*   **User-Friendly**: Includes a 15-minute countdown for easy API key entry.

---

## ⚡ Quick One-Click Setup

The fastest way to get started. Choose your OS:

### 🪟 Windows (Powershell)
1. Open PowerShell.
2. Copy and Paste:
```powershell
irm https://raw.githubusercontent.com/iamKhan79690/OpenRouter-CCR-SETUP/main/install.ps1 | iex
```

### 🐧 Linux / WSL / macOS (Bash)
1. Open Terminal.
2. Copy and Paste:
```bash
curl -fsSL https://raw.githubusercontent.com/iamKhan79690/OpenRouter-CCR-SETUP/main/install.sh | bash
```

---

## 📖 Step-by-Step Manual Installation

If you prefer to do it manually, follow these simple steps.

### Step 1: Install Node.js
Ensure you have Node.js installed on your system.
*   **Windows**: Download from [nodejs.org](https://nodejs.org/)
*   **Ubuntu/WSL**: `sudo apt install nodejs npm`

### Step 2: Install CCR Globally
Run the following command in your terminal:
```bash
npm install -g @anthropics/claude-code-router
```

### Step 3: Configure Your API Key
1. Create a folder named `.claude-code-router` in your user directory.
2. Inside that folder, create a file named `config.json`.
3. Add your configuration and OpenRouter key:

```json
{
  "Provider": {
    "openrouter": {
      "type": "OpenAIAzure",
      "model": "xiaomi/mimo-v2-flash:free",
      "config": {
        "apiVersion": "2024-10-21",
        "baseUrl": "https://openrouter.ai/api/v1",
        "apiKey": "your_sk_or_v1_key_here"
      }
    }
  },
  "Router": {
    "default": "openrouter,xiaomi/mimo-v2-flash:free"
  }
}
```

---

## 🎨 Recommended Free Models

| Provider | Model Name | Description |
| :--- | :--- | :--- |
| **Xiaomi** | `xiaomi/mimo-v2-flash:free` | Fast and efficient (Default) |
| **Meta** | `meta-llama/llama-3.3-70b-instruct:free` | High intelligence |
| **Google** | `google/gemma-2-9b-it:free` | Concise and clear |

---

## 🛠️ Troubleshooting

> [!TIP]
> **"Command not found: ccr"**
> Restart your terminal after installation! Windows users may need to close and reopen PowerShell.

> [!IMPORTANT]
> **API Key Format**
> Ensure your API key starts with `sk-or-v1-`. The scripts will warn you if it doesn't match this pattern but will allow you to continue if you are sure.

---

## 🤝 Contributing

We welcome contributions!
1. Fork the repo.
2. Create your branch.
3. Submit a Pull Request.

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

---

Developed with ❤️ for Students by [iamKhan79690](https://github.com/iamKhan79690)
