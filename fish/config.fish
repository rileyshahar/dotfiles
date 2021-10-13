### ENVIRONMENT VARIABLES
set -x VISUAL nvim
set -x EDITOR "$VISUAL"
set -x BROWSER "qutebrowser"
set -x LANG "en_US.UTF-8"
set -x MANPAGER "nvim +Man!"

set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"

set -x CPLUS_INCLUDE_PATH /usr/local/include
set -x CMAKE_EXPORT_COMPILE_COMMANDS true

set -x FZF_DEFAULT_COMMAND "rg --files --hidden"

set -x BAT_THEME TwoDark

set -x GPG_TTY (tty)

set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

set -x DOTFILES_DIR $HOME/dotfiles

# please respect xdg specs
set -x ATOMHOME "$XDG_DATA_HOME/atom"
set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
set -x GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -x LESSHISTFILE "$XDG_DATA_HOME/less/history"
set -x LESSKEY "$XDG_CONFIG_HOME/less/lesskey"
set -x NODE_REPL_HISTORY "$XDG_DATA_HOME/node/repl_history"
set -x PYLINTHOME "$XDG_DATA_HOME"/pylint
set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -x TERMINFO "$XDG_DATA_HOME/terminfo"
set -x TMUX_PLUGIN_MANAGER_PATH "$XDG_DATA_HOME/tmux/plugins"

# fish colors (comments are base16 numbers)
set pure_color_git_branch brgreen
set pure_color_git_stash brgreen
set pure_color_git_dirty brgreen

set fish_color_normal normal
set fish_color_command magenta
set fish_color_quote green
set fish_color_redirection cyan
set fish_color_end cyan
set fish_color_error red
set fish_color_param blue
set fish_color_comment brblack
set fish_color_match normal
set fish_color_selection --background=brblack  # todo
set fish_color_search_match normal
set fish_color_history_current normal
set fish_color_operator cyan  # todo
set fish_color_escape bryellow  # todo
set fish_color_valid_path --underline
set fish_color_autosuggestion brblack
set fish_color_cancel -r

# configure path
set paths_to_add /usr/local/opt/python@3.8 /bin/usr/local/opt/ruby/bin $CARGO_HOME/bin /usr/local/opt/llvm/bin/ $XDG_DATA_HOME/bin $DOTFILES_DIR/bin $HOME/.local/bin

for path in $paths_to_add
    contains $path $fish_user_paths; or set -Ua fish_user_paths $path
end


### FUNCTIONS
## Utility functions
function upto_git -d "Move up the directory tree to find a git repo"
    # from https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish
    while test $PWD != /
        if test -d .git
            break
        end
        cd ..
    end
end

function git_untracked -d "Get git untracked files"
    git ls-files --other --exclude-standard
end

function git_short_log -d "Get a short-form git log"
    # from https://github.com/jan-warchol/sensible-dotfiles/blob/master/.gitconfig
    git log --color=always --decorate --graph --date=relative \
	--format=tformat:'%C(auto)%h%C(reset) -%C(auto)%d%C(reset) %s %C(dim)- %an, %ad%C(reset)'
end

function mkdir-cd -d "Get git untracked files"
    mkdir $argv && cd $argv
end

function move-last-download -d "Moves up the directory tree to find a git repo"
    mv ~/downloads/(ls -t -A ~/downloads/ | head -1) .
end

function fancy-help -d "Wrapper for help utilities"
    tldr $argv
    or man $argv
end

function system-notification -a body title subtitle -d "Send a system notification"
    set -q subtitle[0]; or set subtitle ""
    send-notification.js $body $title $subtitle
end


# make !! and !$ work
function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end


# Event Hooks
function _handle_cmd_completion_in_inactive_window --on-event fish_postexec -a last_command -d "send a system notification when a command terminates"

    # store the previous status so we can return it at the end
    set prev_status $status

    if status is-interactive; and test -n "$DISPLAY"; and test $TERM = "xterm-kitty"

        set window_number (kitty @ ls | jq .[0].platform_window_id)
        if test $window_number -ne (xdotool getactivewindow)

            if test $prev_status = 0
                set message "Command `$last_command` exited successfully."
                set urgency 0
            else
                set message "Command `$last_command` exited unsuccessfully."
                set urgency 2
            end

            set action (dunstify -u $urgency (string split " " $last_command | head -1) $message --action="default,Switch to Window")

            if test $action = "default"
                xdotool windowactivate $window_number
            end
        end
    end
    return $prev_status
end

### ABBREVIATIONS
abbr -a e $EDITOR

# python
abbr -a p python
abbr -a p3 python3
abbr -a pt python -m pytest

# cargo
abbr -a c cargo
abbr -a cc cargo clippy --tests -- -W clippy::nursery -W clippy::pedantic --verbose
abbr -a cdc cargo doc --no-deps --quiet
abbr -a ct cargo test
abbr -a cti cargo test -- --ignored

# git
abbr -a g git
abbr -a gbr git branch
abbr -a gc git commit
abbr -a gco git checkout
abbr -a ga git add
abbr -a gp git push
abbr -a gpp git push --force-with-lease # "push please"
abbr -a gpl git pull --ff-only # don't pull if conflict
abbr -a gpf git fetch\; and git reset --hard origin/\(git branch --show-current\) # "pull --force"
abbr -a gls git_short_log
abbr -a gll git log --stat-count=30
abbr -a gu git_untracked
abbr -a gd upto_git

# tmux
abbr -a te execute_for_all_panes
abbr -a tz execute_for_all_panes z
abbr -a rl tmux respawn-pane -k -c \'\#{pane_current_path}\'

# misc
abbr -a mc mkdir-cd
abbr -a mld move-last-download
abbr -a b brew
abbr -a o open
abbr -a h fancy-help
abbr -a m man


# ls replacement
if type -q exa
    set ls_function exa
else
    set ls_function ls
end

abbr -a l $ls_function
abbr -a ls $ls_function
abbr -a ll $ls_function -l
abbr -a la $ls_function -a
abbr -a lll $ls_function -al

# cat replacement
if type -q bat
    set cat_function bat
else
    set cat_function cat
end

abbr -a bat $cat_function
abbr -a cat $cat_function

# ps replacement
if type -q procs
    set ps_function "procs --watch --tree"
else
    set ps_function ps
end

abbr -a ps $ps_function

# top replacement
if type -q btm
    set top_function btm
else if type -q ytop
    set top_function ytop
else
    set top_function top
end

abbr -a top $top_function
abbr -a btm $top_function

### KEYBINDINGS
fish_vi_key_bindings
bind -M insert -m default jk backward-char force-repaint
bind -M insert \cf forward-char # this doesn't work by default for some reason
bind -M insert \cs history-token-search-backward
bind -M insert \cd history-token-search-forward
bind -M insert \cp up-or-search
bind -M insert \cn down-or-search
bind -M insert \t complete
bind -M insert ! bind_bang
bind -M insert '$' bind_dollar

### Start x
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx "$XDG_CONFIG_HOME/X11/xinitrc" -- -keeptty
    end
end
