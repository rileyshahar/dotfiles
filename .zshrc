# export bash python path
export PATH="/usr/local/opt/python@3.8/bin:$PATH"

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

# aliases
alias code="cd ~/code"
alias pycode="cd ~/code/python"
