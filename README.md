# dotfiles

Personal macOS terminal setup. Managed with [stow](https://www.gnu.org/software/stow/);
toolchain pinned in `Brewfile`.

## Install on a fresh machine

```sh
git clone git@github.com:fjania/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` will:
1. Install Homebrew (if missing)
2. `brew bundle` against `Brewfile`
3. Back up any conflicting non-symlink files in `$HOME` to `~/.dotfiles-backup-<timestamp>/`
4. Stow each package — `git`, `zsh`, `psql`, `nvim`, `ghostty`, `claude`

Claude Code itself is installed separately (not in `Brewfile`) via:

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

It lands at `~/.local/bin/claude`; `zsh/.zshrc` puts `~/.local/bin` on `$PATH`.

After install, set your terminal font to a Nerd Font (JetBrainsMono Nerd Font is installed)
so the starship prompt glyphs render.

## Layout

```
git/        -> ~/.gitconfig
zsh/        -> ~/.zshrc
psql/       -> ~/.psqlrc
nvim/       -> ~/.config/nvim/    (LazyVim starter + lazy-lock.json)
ghostty/    -> ~/.config/ghostty/ (terminal emulator config)
claude/     -> ~/.claude/         (Claude Code settings.json only)
```

Each package mirrors the structure it should land in under `$HOME`. Add a new tool by
creating `<tool>/<relative-path>/...` and adding `<tool>` to `PACKAGES` in `bootstrap.sh`.

## What's configured

| Area    | Tool                       | Notes                                  |
| ------- | -------------------------- | -------------------------------------- |
| Prompt  | starship                   | reads `~/.config/starship.toml` (none = defaults) |
| Shell   | zsh + autosuggestions + syntax-highlighting | no oh-my-zsh             |
| History | atuin                      | replaces Ctrl-R                        |
| Search  | fzf, ripgrep, fd           | Ctrl-T files, Alt-C cd                 |
| Nav     | zoxide                     | `z <fragment>`, `zi`                   |
| Listing | eza                        | aliased as `ls`/`ll`/`lt`/`dir`        |
| Cat     | bat                        | aliased as `cat`                       |
| Env     | direnv                     | per-directory `.envrc`                 |
| Editor  | neovim + LazyVim           | `vi`/`vim` aliased to `nvim`           |
| Diff    | git-delta                  | wired into git via `core.pager`        |
| Versions | pyenv, uv                 | pyenv initialised in `.zshrc`          |
| Terminal | ghostty                    | font set to JetBrainsMono Nerd Font    |
| Agent   | claude code                | `settings.json` tracked; runtime state in `~/.claude/` is ignored |

## Day-to-day commands

| Command              | What it does                                         |
| -------------------- | ---------------------------------------------------- |
| `stow <pkg>`         | Re-link a single package (run from this repo)        |
| `stow -D <pkg>`      | Unlink (delete the symlinks for) a package           |
| `stow -R <pkg>`      | Restow — useful after adding files                   |
| `brew bundle`        | Install/update everything in `Brewfile`              |
| `nvim` (first time)  | LazyVim auto-installs plugins                        |
| `:Lazy sync`         | Update Neovim plugins, refresh `lazy-lock.json`      |
| `atuin import auto`  | Pull in existing zsh history                         |
