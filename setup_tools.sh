#!/usr/bin/env bash
# ==============================================================================
# Layer 0: Unified Tool Readiness & Dependency Installer
# Installs all CLI binaries and Python libraries required for Layers 1-6.
# ==============================================================================

set -e

echo "======================================================================"
echo "🛠️ Installing Layer 0 Prerequisites for Retrieval Funnel Toolkit..."
echo "======================================================================"

# 1. Check/Install System Dependencies & ripgrep
if ! command -v rg >/dev/null 2>&1; then
    echo "Installing ripgrep..."
    sudo apt update && sudo apt install -y ripgrep jq nodejs || true
fi

# 2. Check/Install uv
if ! command -v uv >/dev/null 2>&1; then
    echo "Installing Astral uv..."
    curl -fsSL https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# 3. Check/Install ast-grep
if ! command -v ast-grep >/dev/null 2>&1; then
    echo "Installing ast-grep..."
    npm install -g @ast-grep/cli 2>/dev/null || cargo install ast-grep --locked 2>/dev/null || true
fi

# 4. Check/Install Aider (PageRank symbol centrality)
if ! command -v aider >/dev/null 2>&1; then
    echo "Installing Aider CLI..."
    uv tool install aider-chat 2>/dev/null || pip install aider-chat || true
fi

# 5. Check/Install Qartez (Dependency hotspots)
if ! command -v qartez >/dev/null 2>&1; then
    echo "Installing Qartez CLI..."
    curl -sSfL https://qartez.dev/install | sh 2>/dev/null || true
fi

# 6. Install Python Dev & Dynamic Analysis Libraries
echo "Installing Python analysis libraries (viztracer, crosshair, pydantic, pytest)..."
pip install pydantic viztracer crosshair-tool pytest pytest-cov pytest-asyncio sqlglot 2>/dev/null || \
uv add --dev viztracer crosshair-tool pydantic pytest pytest-cov pytest-asyncio sqlglot 2>/dev/null || true

echo "======================================================================"
echo "✅ Layer 0 Prerequisites Setup Complete!"
echo "======================================================================"
