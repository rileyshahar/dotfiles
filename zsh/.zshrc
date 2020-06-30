# export bash python path
export PATH="/usr/local/opt/python@3.8/bin:$PATH"
export PATH="$HOME/code/dotfiles/bin:$PATH"

# zsh functions (for alacritty: https://github.com/alacritty/alacritty/blob/master/INSTALL.md#manual-page)
fpath+="$HOME/code/dotfiles/zsh/zsh-functions"

# fix to unnecessary error messages
export ZSH_DISABLE_COMPFIX=true

# Path to your oh-my-zsh installation.
export ZSH="/Users/rileyshahar/.oh-my-zsh"

# theme
ZSH_THEME="dst"

# list of plugins
plugins=(git colorize brew osx extract z python pipenv)

# source
source $ZSH/oh-my-zsh.sh

# set editor to vim
export VISUAL=nvim
export EDITOR="$VISUAL"

# fzf config
export FZF_DEFAULT_COMMAND="rg --files --hidden"

# enter tmux
tm
