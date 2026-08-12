# Manual steps

Some macOS state cannot be safely or reliably applied from a public Git repository.

## Before the first apply

1. Install the Xcode Command Line Tools if Git is not available.
2. Install Homebrew and chezmoi using the commands in `README.md`.
3. Sign in to the Mac App Store before Homebrew Bundle installs `mas` entries.

## Security and accounts

- Restore SSH private keys from a password manager or another encrypted backup. Never commit them here and do not synchronize the entire `~/.ssh` directory through iCloud Drive.
- Create AWS profiles locally. Machine-specific shell values can be placed in `~/.config/zsh/local.zprofile`.
- Restore the SOPS/age private key locally. Only public recipients may be committed.
- Sign in to Bitwarden, browsers, developer tools, and communication applications manually.

## macOS approvals

Approve permissions only when the corresponding application requests them:

- Karabiner-Elements: driver and Input Monitoring
- OmniWM: Accessibility
- Raycast: Accessibility and other explicitly used integrations
- CleanShot X: Screen Recording
- Docker Desktop: privileged helper and networking
- Google Japanese Input: input source approval

Apple ID, FileVault, Touch ID, TCC permissions, application licenses, and browser sessions remain manual by design.

## Applications currently installed outside Brewfile

These applications are intentionally documented rather than silently adopted or reinstalled. On a new Mac, install only the ones still required; most have Homebrew casks and can be promoted to `dot_Brewfile` after review.

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
