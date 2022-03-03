#!/bin/bash -eu

# Install zinit
sh -c "$(curl -fsSL https://git.io/zinit-install)"

# Setup shell
ln -s ~/workspace/mac-provisioning/assets/shell/.zshrc ~/.zshrc
touch ~/.zprofile

# Setup homebrew
if [ ! -e $(which brew) ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "brew already installed"
fi

# kokode ikkai tomerubeki

brew update


#
# CLI Apps
# ---------------------------------------------------------

#
# tmux
if [ ! -e $(which tmux) ]; then
    brew install tmux
    ln -s ~/workspace/mac-provisioning/assets/tmux/.tmux.conf ~/.tmux.conf
else
    echo "tmux already installed"
fi

#
# mas
if [ ! -e $(which mas) ]; then
    brew install mas
else
    echo "mas already installed"
fi

#
# pyenv
if [ ! -e $(which pyenv) ]; then
    brew install pyenv
    {
        echo ''
        echo '# pyenv'
        echo 'export PYENV_ROOT="$HOME/.pyenv"'
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
        echo 'eval "$(pyenv init --path)"'
        echo 'eval "$(pyenv virtualenv-init -)"'
    } >> ~/.zprofile
    source ~/.zprofile
    pyenv install 3.8.12
    pyenv global 3.8.12
else
    echo "pyenv already installed"
fi

#
# pipenv
if [ ! -e $(which pipenv) ]; then
    brew install pipenv
    {
        echo ''
        echo '# Pipenv'
        echo 'export PIPENV_VENV_IN_PROJECT=1'
    } >> ~/.zprofile
    source ~/.zprofile
else
    echo "pipenv already installed"
fi

#
# direnv
if [ ! -e $(which direnv) ]; then
    {
        echo ''
        echo '# direnv'
        echo 'eval "$(direnv hook zsh)"'
    } >> ~/.zprofile
else
    echo "direnv already installed"
fi

#
# volta
if [ ! -e $(which volta) ]; then
    curl https://get.volta.sh | bash
    {
        echo ''
        echo '# NodeJS'
        echo 'export VOLTA_HOME="$HOME/.volta"'
        echo 'export PATH="$VOLTA_HOME/bin:$PATH"'
    } >> ~/.zprofile
else
    echo "volta already installed"
fi

#
# AWS CLI
if [ ! -e $(which aws) ]; then
    brew install awscli
else
    echo "aws already installed"
fi

#
# GUI Apps
# ---------------------------------------------------------

#
# Amazon Music
if [ ! -e "/Applications/Amazon Music.app" ]; then
    brew install --cask amazon-music
else
    echo "Amazon Music already installed"
fi

#
## Authy
if [ ! -e "/Applications/Authy.app" ]; then
    brew install --cask authy
else
    echo "authy already installed"
fi

#
# Bitwarden
if [ ! -e "/Applications/Bitwarden.app" ]; then
    brew install --cask bitwarden
    brew install bitwarden-cli
    bw login
else
    echo "bitwarden already installed"
fi

#
# Docker
if [ ! -e "/Applications/Docker.app" ]; then
    brew install --cask docker
else
    echo "docker already installed"
fi

#
# Google Chrome
if [ ! -e "/Applications/Google Chrome.app" ]; then
    brew install --cask google-chrome
else
    echo "Google Chrome already installed"
fi

#
# Google 日本語入力
if [ ! -e "/Applications/GoogleJapaneseInput.localized" ]; then
    brew install --cask google-japanese-ime
else
    echo "Google日本語入力 already installed"
fi

#
## Hyper
if [ ! -e "/Applications/Hyper.app" ]; then
    brew install --cask hyper
    ln -s ~/workspace/mac-provisioning/assets/hyper/.hyper.js ~/.hyper.js
else
    echo "Hyper already installed"
fi

#
# Karabiner-elements
if [ ! -e "/Applications/Karabiner-Elements.app" ]; then
    brew install --cask karabiner-elements
    ln -s ~/workspace/mac-provisioning/assets/karabiner-elements ~/.config/karabiner
else
    echo "karabiner-elements already installed"
fi

#
# Keka
if [ ! -e "/Applications/Keka.app" ]; then
    brew install --cask keka
else
    echo "keka already installed"
fi

#
# Lunar
if [ ! -e "/Applications/Lunar.app" ]; then
    brew install --cask lunar
else
    echo "lunar already installed"
fi

#
# Magnet
if [ ! -e "/Applications/Magnet.app" ]; then
    mas install 441258766
else
    echo "magnet already installed"
fi

#
# Netron
if [ ! -e "/Applications/Netron.app" ]; then
    brew install --cask netron
else
    echo "Netron already installed"
fi

#
# Obsidian
if [ ! -e "/Applications/Obsidian.app" ]; then
    brew install --cask obsidian
else
    echo "Obsidian already installed"
fi

#
## Raycast
if [ ! -e "/Applications/Raycast.app" ]; then
    brew install --cask raycast
    open "raycast://extensions/pomdtr/bitwarden?source=webstore"
    open "raycast://extensions/guga4ka/authy?source=webstore"
else
    echo "Raycast already installed"
fi

#
## Slack
if [ ! -e "/Applications/Slack.app" ]; then
    brew install --cask slack
else
    echo "Slack already installed"
fi

#
# VSCode
if [ ! -e "/Applications/Visual Studio Code.app" ]; then
    brew install --cask visual-studio-code
else
    echo "Visual Studio Code already installed"
fi

#
# Zoom
if [ ! -e "/Applications/zoom.us.app" ]; then
    brew install --cask zoom
else
    echo "Zoom already installed"
fi

#
## The Unarchiver
if [ ! -e "/Applications/The Unarchiver.app" ]; then
    brew install --cask the-unarchiver
else
    echo "The Unarchiver already installed"
fi

#
## TablePlus
if [ ! -e "/Applications/TablePlus.app" ]; then
    brew install --cask tableplus
else
    echo "TablePlus already installed"
fi

#
## Paw
if [ ! -e "/Applications/Paw.app" ]; then
    brew install --cask paw
else
    echo "Paw already installed"
fi

#
## Typora
if [ ! -e "/Applications/Typora.app" ]; then
    brew install --cask typora
else
    echo "Typora already installed"
fi
