# 管理対象の境界

それぞれのツールや設定は、一つの仕組みだけが管理します。

| 管理する状態 | 管理元 |
| --- | --- |
| dotfiles と安定したアプリ設定 | chezmoi |
| Homebrew formula、cask、tap、Mac App Store アプリ | Homebrew Bundle |
| Node、Bun、Terraform、process-compose などの持ち運べる開発ランタイムと CLI | mise |
| Python ランタイム、環境、Python ツール | uv |
| Rust ツールチェーンとコンポーネント | rustup |
| 秘密情報、秘密鍵、ログインセッション、ライセンス | Bitwarden、キーチェーン、または手動設定 |
| TCC 権限、Apple ID、FileVault、Touch ID | macOS の手動設定 |

同じランタイムを複数の仕組みで重複管理しません。Homebrew の formula が内部利用するランタイムは Homebrew に残る場合がありますが、対話的な開発で使うランタイムとは分けて扱います。

`brew bundle cleanup` は自動実行しません。最初に出力を確認し、明示的に整理するときだけ `--force` を使用します。
