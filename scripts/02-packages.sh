#!/usr/bin/env bash
source "$DOTFILES_DIR/scripts/utils.sh"

# Re-detect in case paru was just installed by 01-essentials.sh
detect_aur

echo "→ [02] Installing packages..."

PKGS=(
    # Shell
    starship
    atuin
    zoxide
    fzf
    zsh-antidote

    # CLI replacements
    eza
    bat
    ripgrep
    fd
    dust
    btop

    # Git
    git-delta
    lazygit

    # Docs
    tealdeer

    # Editor
    neovim

    tree-sitter-cli
)
if ! command -v uv &>/dev/null; then
    # Python via UV
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

for pkg in "${PKGS[@]}"; do
    install_pkg "$pkg"
done

# Update tldr cache after install
if command -v tldr &>/dev/null; then
    run tldr --update
fi

echo "✓ Packages installed"
