#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "== chezmoi source validation =="
chezmoi --source "$repo_dir" execute-template < /dev/null >/dev/null
chezmoi --source "$repo_dir" verify

echo "== secret scan =="
gitleaks dir --redact --no-banner --verbose "$repo_dir"
gitleaks git --redact --no-banner --verbose --log-opts="--all" "$repo_dir"

echo "== local secret permissions =="
permission_error=0
assert_owner_only() {
  local path="$1"
  local mode
  mode="$(stat -f '%Lp' "$path")"
  if (( (8#$mode & 077) != 0 )); then
    echo "Sensitive path is accessible by group or other users: $mode $path" >&2
    return 1
  fi
}

for path in \
  "$HOME/.config/zsh/local.zprofile" \
  "$HOME/.aws/credentials" \
  "$HOME/.config/sops/age/keys.txt"; do
  [[ ! -e "$path" ]] || assert_owner_only "$path" || permission_error=1
done

for root in "$HOME/.ssh" "$HOME/.aws" "$HOME/.config/sops"; do
  [[ ! -d "$root" ]] || while IFS= read -r -d '' path; do
    assert_owner_only "$path" || permission_error=1
  done < <(find "$root" -type d -print0)
done

if [[ -d "$HOME/.ssh" ]]; then
  while IFS= read -r -d '' path; do
    if LC_ALL=C grep -IqE '^-----BEGIN ([A-Z0-9]+ )?PRIVATE KEY-----$' "$path"; then
      assert_owner_only "$path" || permission_error=1
    fi
  done < <(find "$HOME/.ssh" -type f -print0)
fi

if [[ -d "$HOME/.aws/cli/cache" ]]; then
  while IFS= read -r -d '' path; do
    assert_owner_only "$path" || permission_error=1
  done < <(find "$HOME/.aws/cli/cache" -type f -print0)
fi

if (( permission_error != 0 )); then
  exit 1
fi

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

echo "== Codex Bitwarden MCP =="
bitwarden_mcp="$(codex mcp get bitwarden)"
grep -Fq 'command: npx' <<<"$bitwarden_mcp"
grep -Fq 'args: -y @bitwarden/mcp-server@2026.7.0' <<<"$bitwarden_mcp"
grep -Fq 'BW_CLI_PATH = "/opt/homebrew/bin/bw"' "$HOME/.codex/config.toml"
if grep -Eq '^[[:space:]]*BW_SESSION[[:space:]]*=' "$HOME/.codex/config.toml"; then
  echo "BW_SESSION must not be persisted in the Codex configuration." >&2
  exit 1
fi
if grep -q 'managed by hermes-agent' "$HOME/.codex/config.toml"; then
  echo "Obsolete Hermes Agent ownership markers remain in the Codex configuration." >&2
  exit 1
fi

echo "== package integrity =="
brew missing

echo "== syntax =="
zsh -n "$HOME/.zprofile" "$HOME/.zshrc"
jq empty "$HOME/.config/karabiner/karabiner.json"

echo "All managed checks passed."
