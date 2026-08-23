#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR
export DRY_RUN=false

for arg in "$@"; do
    case $arg in
        --dry-run) export DRY_RUN=true ;;
        *) echo "Unknown flag: $arg"; exit 1 ;;
    esac
done

[[ "$DRY_RUN" == true ]] && echo "⚠  DRY RUN — no changes will be made"

source "$DOTFILES_DIR/scripts/utils.sh"
source "$DOTFILES_DIR/scripts/00-system.sh"
source "$DOTFILES_DIR/scripts/01-essentials.sh"
source "$DOTFILES_DIR/scripts/02-packages.sh"
source "$DOTFILES_DIR/scripts/03-shell.sh"
source "$DOTFILES_DIR/scripts/04-backup.sh"
source "$DOTFILES_DIR/scripts/05-stow.sh"

echo ""
echo "✓ All done. Restart your shell."
