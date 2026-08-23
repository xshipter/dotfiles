#!/usr/bin/env bash
source "$DOTFILES_DIR/scripts/utils.sh"

echo "→ [03] Setting up shell..."

ZSH_PATH="$(command -v zsh)"

# Ensure zsh is listed in /etc/shells (required for chsh)
if ! grep -qx "$ZSH_PATH" /etc/shells; then
    echo "→ Adding zsh to /etc/shells..."
    run sudo bash -c "echo '$ZSH_PATH' >> /etc/shells"
fi

if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    run chsh -s "$ZSH_PATH" "$USER"
    echo "✓ Default shell changed to zsh (restart session to apply)"
else
    echo "[skip] zsh is already the default shell"
fi

echo "✓ Shell setup done"
