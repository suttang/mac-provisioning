# 手動で行う設定

macOS の状態には、公開 Git リポジトリから安全かつ確実に適用できないものがあります。

## 初回適用前

1. Git が利用できない場合は Xcode Command Line Tools をインストールします。
2. `README.md` の手順に従って Homebrew と chezmoi をインストールします。
3. Homebrew Bundle が `mas` の項目をインストールできるように、Mac App Store にサインインします。

## セキュリティとアカウント

- SSH 秘密鍵は、パスワードマネージャーまたは暗号化したバックアップから復元します。このリポジトリには絶対にコミットせず、`~/.ssh` 全体を iCloud Drive で同期しないでください。`~/.ssh`は`700`、秘密鍵は`600`または`400`にします。
- AWS プロファイルはローカルで作成します。`~/.aws`は`700`、credentialsは`600`にします。Mac固有のシェル設定は`~/.config/zsh/local.zprofile`に記載し、このファイルも`600`にします。
- SOPS/age の秘密鍵はローカルに復元します。`~/.config/sops`以下のディレクトリは`700`、秘密鍵は`600`にします。コミットできるのは公開 recipient だけです。
- Bitwarden、ブラウザー、開発ツール、コミュニケーションアプリへのサインインは手動で行います。

復元後に`./scripts/audit.sh`を実行し、Gitleaksを含む全監査が成功することを確認します。Gitleaksが秘密情報を検出した場合は、履歴から隠すだけでなく、先にその秘密情報を失効・再発行してください。

## macOS の権限承認

アプリから要求されたときだけ、対応する権限を承認します。

- Karabiner-Elements: ドライバーと入力監視
- OmniWM: アクセシビリティ
- Raycast: アクセシビリティと、実際に利用する連携機能
- CleanShot X: 画面収録
- Docker Desktop: 特権ヘルパーとネットワーク
- Google 日本語入力: 入力ソースの承認

Apple ID、FileVault、Touch ID、TCC 権限、アプリのライセンス、ブラウザーセッションは、設計上すべて手動管理です。

## Brewfile の管理外で現在インストールされているアプリ

次のアプリは、無断で管理対象に取り込んだり再インストールしたりせず、現状の記録だけを残しています。新しい Mac では、その時点で必要なものだけをインストールしてください。多くは Homebrew cask が提供されているため、内容を確認したうえで `dot_Brewfile` の管理対象に移せます。

- Affinity
- Android Studio
- AppCleaner
- Brave Browser
- ChatGPT
- CleanShot X
- Discord
- Dropbox
- Duolingo English Test
- Ghostty
- HandBrake
- HTTPie Desktop
- LocalStack Desktop
- Mac Mouse Fix
- Microsoft Teams
- OnyX
- OpenEmu
- Postman
- Steam
- Transmission
- Transmit
- UGREEN NAS
- WiFiman Desktop
- Wispr Flow
