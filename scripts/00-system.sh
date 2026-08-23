#!/usr/bin/env bash
source "$DOTFILES_DIR/scripts/utils.sh"

echo "→ [00] Updating system..."

run sudo pacman -Syu --noconfirm
run sudo pacman -S --needed --noconfirm base-devel git curl wget

echo "✓ System updated"
