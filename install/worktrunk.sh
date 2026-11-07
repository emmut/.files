#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# worktrunk (the `wt` git-worktree CLI). Not in every distro's default repos,
# so try the system package manager first, then fall back per platform.
# Shell integration is handled by the stowed fish function/completions, so we
# skip `wt config shell install` here. Docs: https://worktrunk.dev
if ! have_command wt; then
    if command -v pacman >/dev/null 2>&1; then
        ensure_command wt worktrunk || echo "Could not install worktrunk via pacman."
    elif command -v brew >/dev/null 2>&1; then
        brew install worktrunk || echo "Could not install worktrunk via brew."
    elif command -v cargo >/dev/null 2>&1; then
        cargo install worktrunk || echo "Could not install worktrunk via cargo."
    else
        echo "worktrunk not installed; see https://worktrunk.dev for install options."
    fi
else
    echo "worktrunk already installed."
fi

# sesh (smart tmux session manager). Not in most default repos either.
if ! have_command sesh; then
    if command -v brew >/dev/null 2>&1; then
        brew install sesh || echo "Could not install sesh via brew."
    elif command -v paru >/dev/null 2>&1; then
        paru -S --noconfirm sesh-bin || echo "Could not install sesh via paru."
    elif command -v go >/dev/null 2>&1; then
        go install github.com/joshmedeski/sesh/v2@latest || echo "Could not install sesh via go."
    else
        echo "sesh not installed; see https://github.com/joshmedeski/sesh."
    fi
else
    echo "sesh already installed."
fi
