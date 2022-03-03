export LANG=ja_JP.UTF-8
export PATH="$HOME/bin:$PATH"

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs
# 重複を記録しない
setopt hist_ignore_dups
# 重複するコマンドは古い法を削除する
setopt hist_ignore_all_dups
# Command correct edition before each completion attempt
setopt correct
# Aliased ls needs if file/dir completions work
setopt complete_aliases
# 語の途中でもカーソル位置で補完
setopt complete_in_word
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# No remove postfix slash of command line
setopt noautoremoveslash
# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst
# タブ・ウィンドウ間で履歴を共有する
setopt share_history
# 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt list_types
# 日本語ファイル名等8ビットを通す
setopt print_eight_bit

# Alias settings
alias ll="ls -lG"
# alias where="command -v"
# alias su="su -l"

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=10000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

export PATH="/Users/suttang/.local/bin:$PATH"

# For complement
autoload -U compinit
compinit
## ssh config complement
function _ssh { compadd `fgrep 'Host ' ~/.ssh/config | awk '{print $2}' | sort`; }

## git
source ~/.zsh/git-prompt.sh
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
