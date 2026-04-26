# Brewfile — tools required by this dotfiles repo.
# Install with:  brew bundle --file=Brewfile
# (also called automatically by ./bootstrap.sh)

# Symlink manager
brew "stow"

# Shell prompt + plugins
brew "starship"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# Modern CLI replacements
brew "eza"          # ls
brew "bat"          # cat
brew "fd"           # find
brew "ripgrep"      # grep

# Navigation, search, history
brew "fzf"          # fuzzy finder (Ctrl-R / Ctrl-T)
brew "zoxide"       # smarter cd (z, zi)
brew "atuin"        # searchable shell history

# Git
brew "git-delta"    # diff pager (referenced by .gitconfig)
brew "jq"           # JSON parsing (used by ~/.claude/statusline.sh)

# Per-directory env
brew "direnv"

# Editor
brew "neovim"

# Node — runtime for npx-based MCP servers (chrome-devtools-mcp etc.)
brew "node"

# Terminal
cask "ghostty"

# Nerd fonts (terminal must be set to use one of these)
cask "font-jetbrains-mono-nerd-font"
cask "font-fira-code-nerd-font"

# Claude Code is installed via the official script (not brew):
#   curl -fsSL https://claude.ai/install.sh | bash
# It lands at ~/.local/bin/claude, which is added to PATH in zsh/.zshrc.
