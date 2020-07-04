set PATH /usr/local/opt/python@3.8/bin $PATH
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/code/dotfiles/bin $PATH

set -x VISUAL nvim
set -x EDITOR $VISUAL

set -x FZF_DEFAULT_COMMAND "rg --files --hidden"

fish_vi_key_bindings
bind -M insert -m default jk backward-char force-repaint

if status is-interactive
and test -z $TMUX
        tm
end
