#!/usr/bin/env bash
# ~/.claude/statusline.sh — Claude Code status line
# Receives JSON on stdin; outputs a single status line.

input=$(cat)

# --- Model (short name) ---
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')
# Shorten common names: "Claude 3.5 Sonnet" → "sonnet-3.5", etc.
model_short=$(echo "$model" | sed \
  -e 's/Claude //' \
  -e 's/ /-/g' \
  | tr '[:upper:]' '[:lower:]')

# --- CWD (~-shortened) ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
# Note: escape ~ in the replacement — bash 5.2+ tilde-expands it back to $HOME otherwise.
cwd_short="${cwd/#$HOME/\~}"

# --- Git branch (fast, no index lock issues) ---
branch=""
if [ -n "$cwd" ] && command -v git >/dev/null 2>&1; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
           || GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# --- Context window ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# --- Rate limits (Claude.ai subscribers only) ---
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

# --- Vim mode ---
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# --- Assemble ---
parts=()
parts+=("${model_short}")
parts+=("${cwd_short}")
[ -n "$branch" ]   && parts+=("git:${branch}")
[ -n "$used_pct" ] && parts+=("ctx:$(printf '%.0f' "$used_pct")%")
[ -n "$five_h" ]   && parts+=("5h:$(printf '%.0f' "$five_h")%")
[ -n "$vim_mode" ] && parts+=("[${vim_mode}]")

# Join with " | " (IFS multichar trick only uses the first char, so do it manually).
out=""
for p in "${parts[@]}"; do
  out="${out:+$out | }$p"
done
printf '%s' "$out"
