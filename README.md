# mac-provisioning

macOS の設定を、管理対象を明確に分けて再現するためのリポジトリです。

- chezmoi: dotfiles と安定したアプリ設定
- Homebrew Bundle: パッケージとアプリケーション
- mise: JavaScript ランタイムとグローバル JavaScript CLI
- uv: Python の開発環境とツール
- rustup: Rust ツールチェーン
- 手動設定: セキュリティ権限、秘密情報、アカウントへのログイン

詳しい管理境界は `docs/ownership.md` を参照してください。

## 新しい Mac のセットアップ

必要に応じて Xcode Command Line Tools をインストールします。

```sh
xcode-select --install
```

公式インストーラーで Homebrew を導入し、chezmoi をインストールします。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install chezmoi
```

Mac App Store にサインインした後、このリポジトリを初期化して適用します。

```sh
chezmoi init --apply suttang/mac-provisioning
```

最後に `docs/manual-steps.md` の手動作業を完了してください。

## 日常的な使い方

適用前に変更内容を確認します。

```sh
chezmoi diff
chezmoi apply --dry-run --verbose
```

chezmoi 経由で管理ファイルを編集し、適用します。

```sh
chezmoi edit ~/.zshrc
chezmoi diff
chezmoi apply
```

リポジトリの変更を取得して、適用内容を確認します。

```sh
chezmoi git pull -- --autostash --rebase
chezmoi diff
```

ソースリポジトリから全体監査を実行します。

```sh
./scripts/audit.sh
```

## パッケージ管理方針

`~/.Brewfile` には、直接利用するパッケージだけを記載します。Homebrew が自動的に導入する依存パッケージは記載しません。リポジトリを適用すると不足項目だけがインストールされ、全パッケージの一括更新や未記載ソフトウェアの自動削除は行いません。

構成との差分候補は次のコマンドで確認できます。

```sh
brew bundle check --global --verbose
brew bundle cleanup --global
```

`brew bundle cleanup` は確認専用です。削除候補を一つずつ確認するまで `--force` を付けないでください。

## 秘密情報

このリポジトリは公開されています。SSH 秘密鍵、AWS 認証情報、SOPS/age 秘密鍵、トークン、アプリケーションのデータベース、ブラウザープロファイル、ログインセッションのエクスポートは絶対に追加しないでください。
