#!/usr/bin/env bash
source "$DOTFILES_DIR/scripts/utils.sh"

echo "→ [01] Installing essentials..."

# Install paru — single place, not duplicated elsewhere
if ! command -v paru &>/dev/null; then
    echo "→ Installing paru..."
    # Clean up any leftover failed attempt
    run rm -rf /tmp/paru
    run git clone https://aur.archlinux.org/paru.git /tmp/paru
    run bash -c "cd /tmp/paru && makepkg -si --noconfirm"
    run rm -rf /tmp/paru
else
    echo "[skip] paru already installed"
fi

# Now that paru may have just been installed, detect the right AUR helper
detect_aur
echo "→ Using AUR helper: $AUR"

for pkg in zsh stow unzip zip; do
    install_pkg "$pkg"
done

echo "✓ Essentials ready"
