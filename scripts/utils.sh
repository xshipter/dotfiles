#!/usr/bin/env bash

# Guard against double-sourcing
[[ -n "${_UTILS_LOADED:-}" ]] && return
_UTILS_LOADED=1

# Run a command or print it in dry-run mode
run() {
    if [[ "$DRY_RUN" == true ]]; then
        echo "[dry-run] $*"
    else
        "$@"
    fi
}

# Detect AUR helper — call this at the start of any script that installs packages
# so it always reflects the current state (paru may be installed mid-run)
detect_aur() {
    if command -v paru &>/dev/null; then
        AUR="paru"
    elif command -v yay &>/dev/null; then
        AUR="yay"
    else
        echo "✗ No AUR helper found (paru or yay required)" >&2
        exit 1
    fi
    export AUR
}

# Install a package — skips if already installed
install_pkg() {
    local pkg="$1"
    if pacman -Qi "$pkg" &>/dev/null; then
        echo "[skip] $pkg already installed"
        return
    fi
    run "$AUR" -S --noconfirm --needed "$pkg"
}
