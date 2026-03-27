#!/usr/bin/env bash
set -euo pipefail

# Rebuild script for slorber/this-week-in-react
# Runs from website/ in the existing source tree (no clone).
# Installs deps, runs pre-build steps, builds the Docusaurus site.

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

CURRENT_DIR="$(pwd)"

# --- Install workspace dependencies from root ---
# slorber/this-week-in-react is a yarn workspaces monorepo.
# The docusaurus binary is hoisted to root node_modules/.bin/.
# website/ is a workspace; yarn.lock is at root.
if [ -f "../package.json" ] && node -e "const p=require('../package.json'); process.exit(p.workspaces ? 0 : 1)" 2>/dev/null; then
    echo "[INFO] Monorepo root found at .., installing from root..."
    cd ..
    yarn install --frozen-lockfile
    cd "$CURRENT_DIR"
else
    echo "[INFO] No monorepo root found, cloning source for root-level deps..."
    TEMP_DIR="/tmp/this-week-in-react-root-$$"
    git clone --depth 1 --branch main https://github.com/slorber/this-week-in-react "$TEMP_DIR"
    cd "$TEMP_DIR"
    yarn install --frozen-lockfile
    # Copy node_modules to parent of current dir so docusaurus binary is available
    cp -r node_modules "$CURRENT_DIR/../"
    rm -rf "$TEMP_DIR"
    cd "$CURRENT_DIR"
fi

# --- Build Docusaurus site ---
../node_modules/.bin/docusaurus build

echo "[DONE] Build complete."
