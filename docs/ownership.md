# Ownership boundaries

Every tool or setting has one owner.

| State | Owner |
| --- | --- |
| Dotfiles and stable application configuration | chezmoi |
| Homebrew formulae, casks, taps, App Store apps, VS Code extensions | Homebrew Bundle |
| Portable developer runtimes and CLIs such as Node, Bun, Terraform, and process-compose | mise |
| Python runtimes, environments, and Python tools | uv |
| Rust toolchains and components | rustup |
| Secrets, private keys, login sessions, and licenses | Bitwarden, Keychain, or manual setup |
| TCC approvals, Apple ID, FileVault, and Touch ID | macOS manual setup |

Do not declare the same runtime in multiple owners. Homebrew may retain a runtime used internally by a formula, but it is not the interactive development runtime.

`brew bundle cleanup` is never run automatically. Review its output first, and use `--force` only as an explicit cleanup operation.
