#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
inventory="$repo_dir/age-key-inventory.json"
inventory_pairs="$(mktemp)"
discovered_pairs="$(mktemp)"
trap 'rm -f "$inventory_pairs" "$discovered_pairs"' EXIT

error=0

fail() {
  echo "$*" >&2
  error=1
}

assert_owner_only() {
  local path="$1"
  local mode
  mode="$(stat -f '%Lp' "$path")"
  if (( (8#$mode & 077) != 0 )); then
    fail "age秘密鍵を所有者以外が読めます: $mode $path"
  fi
}

jq -e '
  .schemaVersion == 1 and
  (.keys | type == "array" and length > 0) and
  all(.keys[];
    (.path | test("^~/\\.config/(age/|sops/age/)[^/]+$")) and
    (.recipient | test("^age1[0-9a-z]+$")) and
    (.bitwardenItem | test("^SOPS / age復号鍵 / [a-z0-9][a-z0-9._-]*$")) and
    (.scope | type == "string" and length > 0) and
    (.verifiedAt | test("^[0-9]{4}-[0-9]{2}-[0-9]{2}$"))
  )
' "$inventory" >/dev/null

jq -r '.keys[] | [.path, .recipient] | @tsv' "$inventory" | sort > "$inventory_pairs"

if [[ "$(wc -l < "$inventory_pairs" | tr -d ' ')" != "$(sort -u "$inventory_pairs" | wc -l | tr -d ' ')" ]]; then
  fail "age-key-inventory.jsonにpathとrecipientの重複があります。"
fi

if [[ "$(jq -r '.keys[].bitwardenItem' "$inventory" | wc -l | tr -d ' ')" != "$(jq -r '.keys[].bitwardenItem' "$inventory" | sort -u | wc -l | tr -d ' ')" ]]; then
  fail "age-key-inventory.jsonにBitwardenアイテム名の重複があります。"
fi

while IFS=$'\t' read -r display_path expected_recipient; do
  local_path="$HOME${display_path#\~}"
  if [[ ! -f "$local_path" ]]; then
    fail "台帳にあるage秘密鍵がローカルにありません: $display_path"
    continue
  fi

  key_count="$(LC_ALL=C grep -c '^AGE-SECRET-KEY-' "$local_path" || true)"
  if [[ "$key_count" != "1" ]]; then
    fail "age秘密鍵ファイルは1ファイル1鍵にしてください: $display_path (検出数: $key_count)"
    continue
  fi

  actual_recipient="$(LC_ALL=C grep '^AGE-SECRET-KEY-' "$local_path" | age-keygen -y)"
  if [[ "$actual_recipient" != "$expected_recipient" ]]; then
    fail "台帳のrecipientがローカル鍵と一致しません: $display_path"
  fi
  assert_owner_only "$local_path"
done < "$inventory_pairs"

for root in "$HOME/.config/age" "$HOME/.config/sops/age"; do
  [[ ! -d "$root" ]] || while IFS= read -r -d '' local_path; do
    if LC_ALL=C grep -Iq '^AGE-SECRET-KEY-' "$local_path"; then
      display_path="~${local_path#"$HOME"}"
      while IFS= read -r identity; do
        recipient="$(printf '%s\n' "$identity" | age-keygen -y)"
        printf '%s\t%s\n' "$display_path" "$recipient" >> "$discovered_pairs"
      done < <(LC_ALL=C grep '^AGE-SECRET-KEY-' "$local_path")
    fi
  done < <(find "$root" -type f -print0)
done

sort -u -o "$discovered_pairs" "$discovered_pairs"

while IFS=$'\t' read -r display_path recipient; do
  if ! grep -Fqx "$display_path"$'\t'"$recipient" "$inventory_pairs"; then
    fail "Bitwardenバックアップ台帳に未登録のage秘密鍵があります: $display_path ($recipient)"
  fi
done < "$discovered_pairs"

if (( error != 0 )); then
  echo "docs/age-key-backup.mdの追加手順に従って、Bitwarden登録と台帳更新を行ってください。" >&2
  exit 1
fi

echo "age秘密鍵: ローカルとBitwardenバックアップ台帳が一致しています。"
