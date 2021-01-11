# configure path
set paths_to_add /usr/local/opt/python@3.8 /bin/usr/local/opt/ruby/bin $HOME/.cargo/bin /usr/local/opt/llvm/bin/

for path in $paths_to_add
        contains $path $fish_user_paths; or set -Ua fish_user_paths $path
end



### FUNCTIONS
## Utility functions
# Moves up the directory tree to find a git repo
# from https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish
function d
	while test $PWD != "/"
		if test -d .git
			break
		end
		cd ..
	end
end

# Get git untracked files
function git_untracked
        git ls-files --other --exclude-standard
end

# Make a directory and cd to it
function mkdir-cd
        mkdir $argv && cd $argv
end

# Move the previously downloaded file to the cwd
function move-last-download
        mv ~/Downloads/(ls -t -A ~/Downloads/ | head -1) .
end

# Wrapper for help utilities
function fancy-help
        tldr $argv
        or man $argv
end

function system-notification -a body title subtitle
        set -q subtitle[0]; or set subtitle ""
        osascript -l JavaScript "$HOME/code/dotfiles/lib/send-notification.js" $body $title $subtitle
end


## Event Hooks
# Ring the bell after every command execution
function _ring_bell_after_cmd --on-event fish_postexec
        printf "\a"
end

# Blink the tmux coloring and send a system alert after a command completes in another window
function _handle_cmd_completion_in_inactive_window --on-event fish_postexec -a last_command

        # store the previous status so we can return it at the end
        set prev_status $status

        # only do so if we're in a non-active window
        if test (tmux display-message -pt $TMUX_PANE '#{window_active}') -ne 1

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
# Open a new tmux session with a nice pane arrangement
function tm
        if not set -q TMUX
                tmux \
                        has-session -t _default || tmux new-session -s _default -c (fd -td | fzf)\; \
                        split-window -h\; \
                        resize-pane -R 20\; \
                        split-window -v\; \
                        resize-pane -D 20\; \
                        select-pane -L
                tmux a -t _default
        else
                echo "Unable to enter tmux -- we're already there!" >/dev/stderr
        end
end

# Change the color of the tmux pane borders temporarily
# Used for alerts
function blink_tmux_color -a color duration message

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

# Get the current battery level
# primarily for the tmux status bar
# from https://github.com/nicknisi/dotfiles/blob/master/bin/battery
function battery
        pmset -g batt | grep -E "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';'
end

# Get the current song playing
# primarily for the tmux status bar
# from https://github.com/nicknisi/dotfiles/blob/master/applescripts/tunes.js
function current-song
        osascript -l JavaScript "$HOME/code/dotfiles/lib/current-song.js"
end

# Get the current cpu usage
# primarily for the tmux status bar
# from https://stackoverflow.com/questions/30855440/how-to-get-cpu-utilization-in-in-terminal-mac
function cpu-usage

        # the printf ensures we have only two places after the decimal
        set ping (printf '%.2f%%' (top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1 | sed s/\%/\/))

        # left-pad with a 0 if needed
        if test 5 -eq ( string length $ping )
                echo ( string join "" "0" $ping )
        else
                echo $ping
        end

end

# Get the ping to google
function ping-to-google
        ping -c 1 google.com | tail -1 | awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1
end

### ENVIRONMENT VARIABLES
set -x VISUAL nvim
set -x EDITOR $VISUAL
set -x LANG "en_US.UTF-8"

set -x CXX "/usr/local/opt/llvm/bin//clang"
set -x CPLUS_INCLUDE_PATH "/usr/local/include"
set -x CMAKE_EXPORT_COMPILE_COMMANDS "true"

set -x FZF_DEFAULT_COMMAND "rg --files --hidden"

set -x BAT_THEME "TwoDark"

set -x CMAKE_EXPORT_COMPILE_COMMANDS true

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
bind -M insert \cf forward-char  # this doesn't work by default for some reason
bind -M insert \cs history-token-search-backward
bind -M insert \cd history-token-search-forward
bind -M insert \cp up-or-search
bind -M insert \cn down-or-search
bind -M insert \t complete

### MISC
navi widget fish | source
zoxide init fish | source

#if status is-interactive
#and test -z $TMUX
        #tm
#end
