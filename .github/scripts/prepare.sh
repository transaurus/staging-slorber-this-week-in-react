#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/slorber/this-week-in-react"
BRANCH="main"
REPO_DIR="source-repo"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Clone (skip if already exists) ---
if [ ! -d "$REPO_DIR" ]; then
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR"

# --- Node version ---
# Docusaurus 3.7.0 requires Node >= 20
NODE_MAJOR=$(node -v | sed 's/v//' | cut -d'.' -f1)
echo "[INFO] Node: $(node -v) (major: $NODE_MAJOR)"
if [ "$NODE_MAJOR" -lt 20 ]; then
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    if [ -f "$NVM_DIR/nvm.sh" ]; then
        . "$NVM_DIR/nvm.sh"
        nvm install 20
        nvm use 20
        echo "[INFO] Node after nvm: $(node -v)"
    else
        echo "ERROR: Node.js >= 20 required, got $(node -v)"
        exit 1
    fi
fi

# --- Package manager: Yarn 1 classic ---
if ! command -v yarn &>/dev/null; then
    echo "[INFO] Installing yarn 1 classic..."
    npm install -g yarn@1.22.22
fi
echo "[INFO] Yarn: $(yarn --version)"

# --- Install all workspace dependencies from root (yarn.lock is at root) ---
echo "[INFO] Installing dependencies..."
yarn install --frozen-lockfile

# --- Apply fixes.json if present ---
FIXES_JSON="$SCRIPT_DIR/fixes.json"
if [ -f "$FIXES_JSON" ]; then
    echo "[INFO] Applying content fixes..."
    node -e "
    const fs = require('fs');
    const path = require('path');
    const fixes = JSON.parse(fs.readFileSync('$FIXES_JSON', 'utf8'));
    for (const [file, ops] of Object.entries(fixes.fixes || {})) {
        if (!fs.existsSync(file)) { console.log('  skip (not found):', file); continue; }
        let content = fs.readFileSync(file, 'utf8');
        for (const op of ops) {
            if (op.type === 'replace' && content.includes(op.find)) {
                content = content.split(op.find).join(op.replace || '');
                console.log('  fixed:', file, '-', op.comment || '');
            }
        }
        fs.writeFileSync(file, content);
    }
    for (const [file, cfg] of Object.entries(fixes.newFiles || {})) {
        const c = typeof cfg === 'string' ? cfg : cfg.content;
        fs.mkdirSync(path.dirname(file), {recursive: true});
        fs.writeFileSync(file, c);
        console.log('  created:', file);
    }
    "
fi

echo "[DONE] Repository is ready for docusaurus commands."
