# mac-provisioning

Reproducible macOS configuration with a small, explicit ownership model:

- chezmoi manages dotfiles and stable application settings.
- Homebrew Bundle manages packages and applications.
- mise manages JavaScript runtimes and global JavaScript CLIs.
- uv manages Python development environments and tools.
- rustup manages Rust toolchains.
- Security approvals, secrets, and account logins remain manual.

See `docs/ownership.md` for the complete boundary.

## Bootstrap a new Mac

Install the Xcode Command Line Tools if necessary:

```sh
xcode-select --install
```

Install Homebrew using its official installer, then install chezmoi:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install chezmoi
```

Sign in to the Mac App Store, then initialize and apply this repository:

```sh
chezmoi init --apply suttang/mac-provisioning
```

Complete the remaining items in `docs/manual-steps.md`.

## Daily use

Preview changes before applying them:

```sh
chezmoi diff
chezmoi apply --dry-run --verbose
```

Edit a managed file through chezmoi and apply it:

```sh
chezmoi edit ~/.zshrc
chezmoi diff
chezmoi apply
```

Pull repository changes and preview the result:

```sh
chezmoi git pull -- --autostash --rebase
chezmoi diff
```

Run the full local audit from the source repository:

```sh
./scripts/audit.sh
```

## Package policy

`~/.Brewfile` contains direct intent only. Transitive Homebrew dependencies are not copied into it. Applying the repository installs missing entries without upgrading everything and never removes unlisted software automatically.

To review possible drift:

```sh
brew bundle check --global --verbose
brew bundle cleanup --global
```

The cleanup command above is a review step. Do not add `--force` until every proposed removal has been checked.

## Secrets

This repository is public. Never add private SSH keys, AWS credentials, SOPS/age private keys, tokens, application databases, browser profiles, or exported login sessions.
