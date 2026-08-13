# age秘密鍵のBitwardenバックアップ運用

## 方針

age秘密鍵は用途ごとに分け、1ファイル・1秘密鍵・1Bitwarden Secure Noteとして管理します。秘密鍵の本文はGit、ドキュメント、会話、シェル履歴へ残しません。

公開リポジトリには`age-key-inventory.json`だけを置きます。この台帳に含めるのは、復元先path、公開recipient、Bitwardenアイテム名、用途、最後にBitwarden保存内容との一致を確認した日だけです。秘密鍵本文は含めません。

Bitwardenアイテム名は次の形式に統一します。

```text
SOPS / age復号鍵 / <用途を表すslug>
```

## 新しい鍵を追加するとき

1. `~/.config/age/`または`~/.config/sops/age/`の下へ、既存用途と共有しない新しいファイルとして生成します。ファイル権限は`600`にします。
2. `age-keygen -y`で公開recipientを取得し、`age-key-inventory.json`へ新しい項目を追加します。秘密鍵本文は貼り付けません。
3. Codexへ「age-key-inventory.jsonの新しい鍵をBitwardenへ登録し、一致を検証して」と依頼します。
4. Bitwarden公式MCPのネイティブ解除画面へ、本人がマスターパスワードを入力します。`BW_SESSION`や秘密鍵を会話へ貼り付けません。
5. Codexはexact-name検索で重複がないことを確認し、Secure Noteを作成または更新します。保存内容とローカルファイルを値非表示で完全一致検証し、同期後にVaultを再ロックします。
6. 一致を確認した日を`verifiedAt`へ記録し、`./scripts/audit.sh`を実行します。

`scripts/audit-age-keys.sh`は、標準保存場所を自動探索します。台帳にない秘密鍵、消えた鍵、recipientの不一致、複数鍵を含むファイル、不適切な権限、Bitwardenアイテム名の重複を検出します。したがって、将来7本目以降が増えても、ローカルだけに置いたまま監査を通過することはできません。

ローカル監査はBitwardenへログインせず実行するため、Vaultの現在値を毎回読み取るものではありません。`verifiedAt`は、ユーザー立ち会いのもと公式MCPで保存内容を照合した記録です。Bitwarden側の削除や改変まで確認したい場合は、Codexへ「age秘密鍵のBitwardenバックアップを再検証して」と依頼し、ネイティブ解除画面を承認してください。

## 新しいMacへ復元するとき

1. BitwardenとBitwarden CLIへログインします。
2. `age-key-inventory.json`の各`bitwardenItem`をexact-nameで取得します。
3. Secure Note本文を対応する`path`へ保存し、親ディレクトリを`700`、鍵ファイルを`600`にします。
4. 公開recipientを再計算し、台帳と一致することを確認します。
5. 必要な暗号化ファイルを値非表示で復号検査します。
6. Bitwarden Vaultをロックし、`./scripts/audit.sh`を実行します。

鍵をローテーションまたは廃止するときは、先に対象暗号化ファイルのrecipientを更新し、新旧両方で復号可否を確認してから旧鍵を削除します。Bitwarden上の旧アイテムも、復号対象が残っていないことを確認するまでは削除しません。
