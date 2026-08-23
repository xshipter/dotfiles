#!/usr/bin/env bash
source "$DOTFILES_DIR/scripts/utils.sh"

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

echo "→ [04] Backing up existing dotfiles..."

# Files/dirs that stow will overwrite
# Only backs up real files — skips existing symlinks (idempotent re-runs)
TARGETS=(
    "$HOME/.zshrc"
    "$HOME/.zsh_plugins.txt"
    "$HOME/.gitconfig"
    "$HOME/.config/starship.toml"
    "$HOME/.config/atuin"
    # "$HOME/.config/lazygit"
    "$HOME/.config/nvim"
)

backed_up=0

for target in "${TARGETS[@]}"; do
    if [[ -e "$target" && ! -L "$target" ]]; then
        run mkdir -p "$BACKUP_DIR"
        run mv "$target" "$BACKUP_DIR/"   # mv not cp — removes original so stow won't conflict
        echo "[backup] $target → $BACKUP_DIR/"
        backed_up=$((backed_up + 1))      # arithmetic assignment — avoids set -e false exit bug
    fi
done

if [[ $backed_up -eq 0 ]]; then
    echo "[skip] nothing to backup"
else
    echo "✓ Backed up $backed_up item(s) to $BACKUP_DIR"
fi
