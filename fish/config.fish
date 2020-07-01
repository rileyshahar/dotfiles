set PATH /usr/local/opt/python@3.8/bin $PATH
set PATH $HOME/code/dotfiles/bin $PATH

set -x VISUAL nvim
set -x EDITOR $VISUAL

set -x FZF_DEFAULT_COMMAND "rg --files --hidden"

if status is-interactive
and test -z $TMUX
        tm
end
