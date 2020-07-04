set paths_to_add /usr/local/opt/python@3.8 /bin/usr/local/opt/ruby/bin $HOME/.cargo/bin $HOME/code/dotfiles/bin

for path in $paths_to_add
        contains $path $fish_user_paths; or set -Ua fish_user_paths $path
end


set -x VISUAL nvim
set -x EDITOR $VISUAL

set -x FZF_DEFAULT_COMMAND "rg --files --hidden"

fish_vi_key_bindings
bind -M insert -m default jk backward-char force-repaint

if status is-interactive
and test -z $TMUX
        tm
end
