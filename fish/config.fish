### ENVIRONMENT VARIABLES
set -x VISUAL nvim
set -x EDITOR $VISUAL
set -x LANG "en_US.UTF-8"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"

set -x CXX "/usr/local/opt/llvm/bin//clang"
set -x CPLUS_INCLUDE_PATH "/usr/local/include"
set -x CMAKE_EXPORT_COMPILE_COMMANDS "true"

set -x FZF_DEFAULT_COMMAND "rg --files --hidden"

set -x BAT_THEME "TwoDark"

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

# fish colors
set pure_color_mute 82ac7c
set pure_color_virtualenv 808080
set pure_color_primary blue
set pure_color_success magenta

set fish_color_normal normal
set fish_color_command magenta
set fish_color_quote yellow
set fish_color_redirection ff9e64
set fish_color_end cyan
set fish_color_error red
set fish_color_param blue
set fish_color_comment brmagenta
set fish_color_match normal
set fish_color_selection --background=brblack # todo: find a better color
set fish_color_search_match normal
set fish_color_history_current normal
set fish_color_operator ff9e64
set fish_color_escape ff9e64
set fish_color_valid_path --underline
set fish_color_autosuggestion 8599ad
set fish_color_cancel -r

# configure path
set paths_to_add /usr/local/opt/python@3.8 /bin/usr/local/opt/ruby/bin $CARGO_HOME/bin /usr/local/opt/llvm/bin/

for path in $paths_to_add
    contains $path $fish_user_paths; or set -Ua fish_user_paths $path
end


### FUNCTIONS
## Utility functions
function upto_git -d "Move up the directory tree to find a git repo"
    # from https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish
    while test $PWD != "/"
        if test -d .git
            break
        end
        cd ..
    end
end

function git_untracked -d "Get git untracked files"
    git ls-files --other --exclude-standard
end

function mkdir-cd -d "Get git untracked files"
    mkdir $argv && cd $argv
end

function move-last-download -d "Moves up the directory tree to find a git repo"
    mv ~/Downloads/(ls -t -A ~/Downloads/ | head -1) .
end

function fancy-help -d "Wrapper for help utilities"
    tldr $argv
    or man $argv
end

function system-notification -a body title subtitle -d "Send a system notification"
    set -q subtitle[0]; or set subtitle ""
    osascript -l JavaScript "$HOME/bin/send-notification.js" $body $title $subtitle
end


## Event Hooks
function _ring_bell_after_cmd --on-event fish_postexec -d "Ring the bell after every command execution"
    printf "\a"
end

function _handle_cmd_completion_in_inactive_window --on-event fish_postexec -a last_command -d "Blink the tmux coloring and send a system alert after a command completes in another window"

    # store the previous status so we can return it at the end
    set prev_status $status

    # only do so if we're in a non-active, tmux window
    if status is-interactive; and not test -z $TMUX; and test (tmux display-message -pt $TMUX_PANE '#{window_active}') -ne 1

        # variables we need for the message
        set window_number (tmux display-message -pt $TMUX_PANE '#{window_index}')

        # handle output based on the previous status
        if test $prev_status = 0
            set message "Command `$last_command` exited successfully in window $window_number."
            blink_tmux_color green 1 $message
            system-notification $message (string split " " $last_command | head -1)
        else
            set message "Command `$last_command` exited unsuccessfully in window $window_number."
            blink_tmux_color red 1 $message
            system-notification $message (string split " " $last_command | head -1)
        end
    end
    return $prev_status
end

## Tmux utilities
function blink_tmux_color -a color duration message -d "Change the color of the tmux pane borders temporarily"

    # manipulate tmux
    # this is all in one tmux process so it's backgroundable, but it all executes simultaneously
    # fish only allows backgrounding commands, not functions
    # note we display the message for 3x as long, to allow it to be read, but its coloring goes away
    tmux \
        set-window-option pane-active-border-style fg=$color,bg=$bg\; \
        set-window-option pane-border-style fg=$color,bg=$bg\; \
        set message-style bg=$color,fg=black\; \
        set display-time (math $duration \* 3000)\; \
        display-message $message\; \
        run-shell "sleep $duration"\; \
        set -u pane-active-border-style\; \
        set -u pane-border-style\; \
        set -u message-style\; \
        set -u display-time \
        & # backgrounds the tmux command
end

function execute_for_all_panes -d "Run a command in all panes"

    # we need to be in tmux
    if test -z $TMUX
        echo "no tmux session found"
        return 1
    end

    set to_run (echo $argv | string join " ")

    for pane in (tmux list-panes -F "#P")
        if test (tmux display-message -pt $pane "#{pane_current_command}") = "fish"
            tmux send-keys -t $pane $to_run C-m
        end

        # the current pane is running this function, not fish, so we need to handle it separately
        eval $to_run
    end
end

function battery -d "Get the current battery level"
    # primarily for the tmux status bar
    # from https://github.com/nicknisi/dotfiles/blob/master/bin/battery
    pmset -g batt | grep -E "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';'
end

function current-song -d "Get the current song playing"
    # primarily for the tmux status bar
    # from https://github.com/nicknisi/dotfiles/blob/master/applescripts/tunes.js
    osascript -l JavaScript "$HOME/bin/current-song.js"
end

function cpu-usage -d "Get the current cpu usage"
    # primarily for the tmux status bar
    # from https://stackoverflow.com/questions/30855440/how-to-get-cpu-utilization-in-in-terminal-mac

    # the printf ensures we have only two places after the decimal
    set ping (printf '%.2f%%' (top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1 | sed s/\%/\/))

    # left-pad with a 0 if needed
    if test 5 -eq ( string length $ping )
        echo ( string join "" "0" $ping )
    else
        echo $ping
    end

end

function ping-to-google -d "Get the ping to google"
    ping -c 1 google.com | tail -1 | awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1
end

### ABBREVIATIONS
abbr -a e nvim
abbr -a p python
abbr -a p3 python3
abbr -a pt python -m pytest
abbr -a c cargo
abbr -a g git
abbr -a gc git checkout
abbr -a gu git_untracked
abbr -a mc mkdir-cd
abbr -a mld move-last-download
abbr -a b brew
abbr -a o open
abbr -a h fancy-help
abbr -a m man
abbr -a te execute_for_all_panes
abbr -a tz execute_for_all_panes z
abbr -a d upto_git


# ls replacement
if type -q exa
    set ls_function "exa"
else
    set ls_function "ls"
end

abbr -a l $ls_function
abbr -a ls $ls_function
abbr -a ll $ls_function -l
abbr -a la $ls_function -a
abbr -a lll $ls_function -al

# cat replacement
if type -q bat
    set cat_function "bat"
else
    set cat_function "cat"
end

abbr -a bat $cat_function
abbr -a cat $cat_function

# ps replacement
if type -q procs
    set ps_function "procs --watch --tree"
else
    set ps_function "ps"
end

abbr -a ps $ps_function

# top replacement
if type -q btm
    set top_function "btm"
else if type -q ytop
    set top_function "ytop"
else
    set top_function "top"
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

### MISC
navi widget fish | source
zoxide init fish | source
