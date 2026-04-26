# ~/.zshrc — managed by ~/dotfiles (zsh package)

# ========= PATH =========
# Homebrew is set up via ~/.zprofile (eval brew shellenv)
# uv installer
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# pyenv
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"
fi

# ========= History =========
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_VERIFY EXTENDED_HISTORY

# ========= Editor =========
export EDITOR=nvim
export VISUAL=nvim

# ========= Completion =========
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ========= Aliases =========
if command -v eza >/dev/null 2>&1; then
    alias ls="eza"
    alias ll="eza -lah --git --group-directories-first"
    alias lt="eza --tree --level=2 --git-ignore"
    alias dir="eza -lah --git --group-directories-first"
else
    alias dir="ls -lsah"
    alias ll="ls -lsah"
fi

command -v bat   >/dev/null 2>&1 && alias cat="bat --paging=never"
command -v nvim  >/dev/null 2>&1 && { alias vi="nvim"; alias vim="nvim"; }
alias g="git"

# ========= Plugins =========
# Order matters: compinit must be done above; syntax-highlighting must be last.

[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf (Ctrl-T files, Ctrl-R history, Alt-C cd)
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# zoxide — adds `z <fragment>` and `zi` (interactive)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# direnv — per-directory env via .envrc
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# atuin — searchable, optionally synced shell history (Ctrl-R)
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

# Starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Syntax highlighting — must be sourced last
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
