#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "== chezmoi source validation =="
chezmoi --source "$repo_dir" execute-template < /dev/null >/dev/null
chezmoi --source "$repo_dir" verify

echo "== Homebrew desired state =="
brew bundle check --global --verbose --no-upgrade

echo "== mise desired state =="
mise install --dry-run-code || {
  status=$?
  if [[ $status -eq 1 ]]; then
    echo "mise-managed tools are missing from the pinned configuration." >&2
  fi
  exit "$status"
}
mise doctor

echo "== package integrity =="
brew missing

echo "== syntax =="
zsh -n "$HOME/.zprofile" "$HOME/.zshrc"
jq empty "$HOME/.config/karabiner/karabiner.json"

echo "All managed checks passed."
