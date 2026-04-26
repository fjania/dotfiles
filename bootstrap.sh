#!/usr/bin/env bash
# Idempotent bootstrap for this dotfiles repo on a fresh Mac.
#
# Steps:
#   1. Install Homebrew if missing
#   2. brew bundle (installs everything in Brewfile)
#   3. Back up any non-symlink dotfiles in $HOME that would conflict with stow
#   4. stow each package (creates symlinks in $HOME)

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
PACKAGES=(git zsh psql nvim)

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Brewfile
if [ -f "$DOTFILES/Brewfile" ]; then
    echo "Running brew bundle..."
    brew bundle --file="$DOTFILES/Brewfile"
fi

# 3. Back up conflicting files (anything in $HOME that's NOT a symlink and would be overwritten)
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP"
        echo "Backing up $target -> $BACKUP/"
        mv "$target" "$BACKUP/"
    fi
}
for pkg in "${PACKAGES[@]}"; do
    while IFS= read -r relpath; do
        backup_if_exists "$HOME/$relpath"
    done < <(cd "$DOTFILES/$pkg" && find . -type f -mindepth 1 | sed 's|^\./||')
done

# 4. Stow
echo "Stowing packages: ${PACKAGES[*]}"
cd "$DOTFILES"
stow --restow --target="$HOME" "${PACKAGES[@]}"

echo "Done. Backed-up files (if any) are in: $BACKUP"
