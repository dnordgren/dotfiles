#!/usr/bin/env bash
# Claude Code for Web — remote environment setup script
#
# Paste the contents of this file into the "Setup script" field in your
# cloud environment settings at code.claude.com.
#
# Required environment variables (set in the cloud environment UI):
#   GH_TOKEN  — GitHub personal access token (for gh CLI auth)
#
# Optional (to keep using AWS Bedrock instead of direct Anthropic API):
#   CLAUDE_CODE_USE_BEDROCK=1
#   AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY / AWS_REGION
#
# Tools already pre-installed in the cloud image (no need to add here):
#   git, jq, yq, ripgrep, tmux, vim, curl, docker
#   Python (pip/uv/poetry/ruff/mypy), Node 20-22 (nvm), Ruby, Go, Rust, Java

set -euo pipefail

apt-get update -qq

# ── GitHub CLI ─────────────────────────────────────────────────────────────
# Primary reason for this script; GH_TOKEN env var handles authentication.
if ! command -v gh &>/dev/null; then
  apt-get install -y gh
fi

# ── fzf ────────────────────────────────────────────────────────────────────
# Not pre-installed; used heavily in shell config for file/history search.
if ! command -v fzf &>/dev/null; then
  apt-get install -y fzf
fi

# ── fd ─────────────────────────────────────────────────────────────────────
# Used as fzf's default file finder (faster than find, respects .gitignore).
# Debian/Ubuntu ships it as 'fdfind'; symlink to 'fd' to match local config.
if ! command -v fd &>/dev/null; then
  apt-get install -y fd-find
  if command -v fdfind &>/dev/null; then
    ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  fi
fi

# ── hstr ───────────────────────────────────────────────────────────────────
# Ctrl-R history search enhancement used in both bash and zsh configs.
if ! command -v hstr &>/dev/null; then
  apt-get install -y hstr
fi

# ── delta ──────────────────────────────────────────────────────────────────
# Syntax-highlighted git diffs — popular in Claude Code sessions where you
# review a lot of diffs. Pairs well with `git diff | delta`.
if ! command -v delta &>/dev/null; then
  DELTA_VERSION="0.17.0"
  curl -fsSL \
    "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb" \
    -o /tmp/delta.deb
  dpkg -i /tmp/delta.deb
  rm /tmp/delta.deb
fi

# ── bat ────────────────────────────────────────────────────────────────────
# Syntax-highlighted file viewer. Claude Code sessions do a lot of file
# reading; bat makes manual spot-checks easier. Debian ships as 'batcat'.
if ! command -v bat &>/dev/null; then
  apt-get install -y bat
  if command -v batcat &>/dev/null; then
    ln -sf "$(command -v batcat)" /usr/local/bin/bat
  fi
fi

# ── git config ─────────────────────────────────────────────────────────────
# Mirror your local git setup, minus GPG signing and BBEdit (not available
# in the cloud). Commit signing is skipped; the web env isn't your keyring.
git config --global user.name  "Derek Nordgren"
git config --global user.email "derek.nordgren@hudl.com"
git config --global core.editor "vim"
git config --global push.default current
git config --global init.defaultBranch main
git config --global merge.conflictstyle diff3

# Aliases from ~/.gitconfig — keeps muscle memory intact in cloud sessions
git config --global alias.a    "add -A"
git config --global alias.c    "commit"
git config --global alias.co   "checkout"
git config --global alias.d    "diff"
git config --global alias.ds   "diff --staged"
git config --global alias.lol  "log --graph --oneline --abbrev-commit"
git config --global alias.p    "push"
git config --global alias.s    "status"
git config --global alias.br   "branch"
git config --global alias.bra  "branch -a"
git config --global alias.last "log -1 HEAD"
git config --global alias.save "!git add -A && git commit -m 'SAVEPOINT'"
git config --global alias.rollback "reset --mixed HEAD~1"

# Wire delta in as the git pager for nicer diffs
if command -v delta &>/dev/null; then
  git config --global core.pager "delta"
  git config --global interactive.diffFilter "delta --color-only"
  git config --global delta.navigate true
  git config --global delta.side-by-side true
fi

echo "Remote environment setup complete."
