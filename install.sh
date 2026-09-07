#!/usr/bin/env bash

set -Eeuo pipefail

NVIM_MIN_VERSION="0.12.0"
TREE_SITTER_MIN_VERSION="0.26.1"

log() {
  printf '\n==> %s\n' "$*"
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

version_ge() {
  awk -v current="$1" -v required="$2" 'BEGIN {
    split(current, a, "."); split(required, b, ".")
    for (i = 1; i <= 3; i++) {
      a[i] += 0; b[i] += 0
      if (a[i] > b[i]) exit 0
      if (a[i] < b[i]) exit 1
    }
    exit 0
  }'
}

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    die "sudo is required to install system packages"
  fi
}

install_system_dependencies() {
  log "Installing Neovim build/runtime dependencies"

  if command -v brew >/dev/null 2>&1; then
    brew install neovim tree-sitter-cli git curl go node ripgrep fd
  elif command -v apt-get >/dev/null 2>&1; then
    as_root apt-get update
    as_root apt-get install -y neovim git curl tar gzip unzip build-essential cargo golang-go nodejs npm ripgrep fd-find
  elif command -v dnf >/dev/null 2>&1; then
    as_root dnf install -y neovim git curl tar gzip unzip gcc gcc-c++ make cargo golang nodejs npm ripgrep fd-find
  elif command -v pacman >/dev/null 2>&1; then
    as_root pacman -S --needed neovim git curl tar gzip unzip base-devel rust go nodejs npm ripgrep fd
  elif command -v apk >/dev/null 2>&1; then
    as_root apk add neovim git curl tar gzip unzip build-base cargo go nodejs npm ripgrep fd
  else
    die "unsupported package manager; install Neovim >= $NVIM_MIN_VERSION, git, curl, tar, a C compiler, Cargo and tree-sitter-cli >= $TREE_SITTER_MIN_VERSION"
  fi
}

ensure_tree_sitter_cli() {
  local version=""
  if command -v tree-sitter >/dev/null 2>&1; then
    version="$(tree-sitter --version | awk '{ print $2 }')"
  fi

  if [ -n "$version" ] && version_ge "$version" "$TREE_SITTER_MIN_VERSION"; then
    return
  fi

  command -v cargo >/dev/null 2>&1 || die "tree-sitter-cli >= $TREE_SITTER_MIN_VERSION is missing and Cargo is unavailable"
  log "Installing current tree-sitter-cli with Cargo"
  cargo install tree-sitter-cli --locked
  export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:$PATH"
}

install_system_dependencies
ensure_tree_sitter_cli

command -v nvim >/dev/null 2>&1 || die "Neovim was not installed"
nvim_version="$(nvim --version | awk 'NR == 1 { sub(/^v/, "", $2); print $2 }')"
version_ge "$nvim_version" "$NVIM_MIN_VERSION" || die "Neovim $nvim_version is too old; this config requires >= $NVIM_MIN_VERSION (use an AppImage/tarball or a newer repository on Linux)"

log "Synchronizing Neovim plugins"
nvim --headless "+Lazy! sync" +qa

log "Installing Tree-sitter parsers"
nvim --headless "+lua local ok = require('nvim-treesitter').install(require('config.treesitter').parsers):wait(600000); if not ok then vim.cmd('cquit 1') end" +qa

log "Installing configured LSP servers"
nvim --headless "+Lazy load mason-lspconfig.nvim" \
  "+MasonInstall rust-analyzer vtsls gopls lua-language-server yaml-language-server helm-ls" \
  +qa

log "Checking configuration"
nvim --headless "+checkhealth vim.treesitter" +qa

printf '\nNeovim is ready.\n'
