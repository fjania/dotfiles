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

Two things the bootstrap does *not* install (because they live outside Homebrew):

- **Claude Code** — `curl -fsSL https://claude.ai/install.sh | bash` (lands at `~/.local/bin/claude`, which `zsh/.zshrc` puts on `$PATH`)
- **Per-machine MCP servers** — see [Claude Code](#claude-code) below

After install, set Ghostty's font to a Nerd Font (config below already does this) so
the starship prompt glyphs render.

## Layout

```
git/        -> ~/.gitconfig
zsh/        -> ~/.zshrc
psql/       -> ~/.psqlrc
nvim/       -> ~/.config/nvim/    (LazyVim starter + lazy-lock.json)
ghostty/    -> ~/.config/ghostty/ (terminal emulator config)
claude/     -> ~/.claude/         (settings.json + statusline.sh only — runtime state ignored)
```

Each package mirrors the structure it should land in under `$HOME`. Add a new tool by
creating `<tool>/<relative-path>/...` and adding `<tool>` to `PACKAGES` in `bootstrap.sh`.

---

## Tools

### Shell — zsh + starship

`zsh/.zshrc` is hand-rolled (no oh-my-zsh). Plugins:

- `zsh-autosuggestions` — gray inline suggestion from history; press `→` to accept.
- `zsh-syntax-highlighting` — colors valid commands green, invalid red as you type.
- `starship` — prompt; reads `~/.config/starship.toml` if present, otherwise sensible defaults (cwd, git branch, status indicators).

```sh
# Suggestion accept while typing:
$ git che▒ckout main      # gray "ckout main" appears, → accepts it
```

### History — atuin

Replaces Ctrl-R with a searchable, filterable history UI. Stored in SQLite.

```sh
$ # Press Ctrl-R, then type — fuzzy match across all your history
$ atuin import auto       # one-time: pull in existing zsh history
$ atuin search docker     # search from CLI
```

### Search — fzf, ripgrep, fd

- `fzf` — interactive fuzzy finder (Ctrl-T files, Ctrl-R history, Alt-C cd).
- `rg` — modern grep; respects `.gitignore` by default, fast.
- `fd` — modern find; same conventions.

```sh
$ rg "TODO" -t py            # all Python TODOs
$ fd -e md docs              # all .md files under ./docs
$ vim $(fzf)                 # open whatever you pick
```

### Navigation — zoxide

Frecency-based `cd`. Learns the dirs you visit; `z <fragment>` jumps.

```sh
$ z dot                      # → ~/dotfiles (after visiting it once)
$ zi                         # interactive picker over your zoxide DB
```

### Repo management — ghq + fzf

All repos live under `~/src/<host>/<owner>/<repo>` (set via `ghq.root` in `.gitconfig`).
`cdr` is a zsh function that fuzzy-picks any cloned repo and `cd`s into it.

```sh
$ ghq get github.com/anthropics/claude-code
# → clones to ~/src/github.com/anthropics/claude-code

$ ghq list                                    # all clones
$ cdr                                         # fzf picker → cd
$ cdr claude                                  # narrow to matches; auto-selects if unique
```

### Listing — eza

Replaces `ls`. Aliases in `.zshrc`:

```sh
$ ls           # eza, colored, with icons
$ ll           # eza -lah --git --group-directories-first
$ lt           # eza --tree --level=2 --git-ignore
```

### Cat — bat

Replaces `cat` with syntax-highlighted, paginated output.

```sh
$ cat README.md          # syntax-highlighted, no pager
$ bat src/main.py        # full bat with line numbers + git markers
```

### Editor — neovim + LazyVim

LazyVim starter in `nvim/.config/nvim/`. `vi` and `vim` are aliased to `nvim`.

```sh
$ vi some_file.py        # opens nvim
:Lazy sync               # update plugins, refresh lazy-lock.json
:LazyExtras              # toggle LazyVim language/feature extras
```

`lazy-lock.json` (plugin versions) and `lazyvim.json` (active extras) are tracked, so
plugin state travels across machines.

### Diff — git-delta

Wired into git via `core.pager`. Side-by-side off, line numbers on, navigation enabled.

```sh
$ git diff               # rendered through delta
$ git log -p             # ditto
# Inside delta's pager: n / N to jump between files
```

### Per-directory env — direnv

`.envrc` files in a directory get auto-loaded when you `cd` in (after `direnv allow`).

```sh
$ cd ~/src/github.com/me/proj
$ echo 'export FOO=bar' > .envrc
$ direnv allow
$ echo $FOO              # bar
$ cd ..                  # FOO unset
```

### Python — pyenv, uv

- `pyenv` — manage Python versions; `pyenv install 3.13.0 && pyenv global 3.13.0`.
- `uv` — fast pip/venv replacement; `uv venv && uv pip install …`.

`pyenv` shims are initialized in `.zshrc`. `uv` self-installs to `~/.local/bin` (already on `$PATH`).

### Terminal — ghostty

Config at `~/.config/ghostty/config`, currently sets only:

```
font-family = JetBrainsMono Nerd Font
```

That's enough; everything else uses Ghostty's defaults.

### Claude Code

Tracked under `claude/.claude/`:

- `settings.json` — theme, status line config, default-mode toggle.
- `statusline.sh` — renders the status line (model, cwd, git branch, ctx %, vim mode).

**Status line example:**

```
opus-4.7 | ~/dotfiles | git:master | ctx:43% | [NORMAL]
```

Fields hide themselves when their data isn't available (no rate limits for API users,
no `[NORMAL]` outside vim mode, etc.).

**MCP servers** are *not* tracked (their config lives in `~/.claude.json`, which holds
a lot of session state). Register them per-machine after setup:

```sh
# Chrome DevTools (needs node, which is in Brewfile)
claude mcp add --scope user chrome-devtools -- npx -y chrome-devtools-mcp@latest

# Verify
claude mcp list
```

Restart any running Claude Code session for newly-added MCPs to load.

### Git config

`git/.gitconfig` enables what most modern setups expect: `pull.rebase`, `rebase.autoStash`,
`fetch.prune`, `rerere`, `zdiff3` conflict style, histogram diff. Aliases:

```sh
$ git lg                 # graph log with colors and ago-times
$ git lpa                # one-line log with author
$ git co main            # checkout
$ git conflicts          # list unmerged paths during a conflict
$ git rso                # remote show origin
```

---

## Day-to-day commands

| Command              | What it does                                         |
| -------------------- | ---------------------------------------------------- |
| `stow <pkg>`         | Re-link a single package (run from this repo)        |
| `stow -D <pkg>`      | Unlink (delete the symlinks for) a package           |
| `stow -R <pkg>`      | Restow — useful after adding files                   |
| `brew bundle`        | Install/update everything in `Brewfile`              |
| `brew bundle cleanup`| Show installed packages NOT in Brewfile              |
| `nvim` (first time)  | LazyVim auto-installs plugins                        |
| `:Lazy sync`         | Update Neovim plugins, refresh `lazy-lock.json`      |
| `atuin import auto`  | Pull in existing zsh history                         |
| `ghq get <url>`      | Clone into `~/src/<host>/<owner>/<repo>`             |
| `cdr [query]`        | Fuzzy-jump to any local clone                        |
| `claude mcp list`    | Show which MCP servers Claude Code is configured for |
