#!/usr/bin/env bash
source "$DOTFILES_DIR/scripts/utils.sh"

echo "→ [05] Stowing dotfiles..."

PACKAGES=(
    zsh
    git
    starship
    atuin
    #lazygit
    nvim
)

for pkg in "${PACKAGES[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
        run stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$pkg"
        echo "[stow] $pkg"
    else
        echo "[skip] $pkg — directory not found"
    fi
done

echo "✓ Dotfiles linked"
