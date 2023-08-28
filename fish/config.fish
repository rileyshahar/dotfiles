### ENVIRONMENT VARIABLES
set -x VISUAL nvim
set -x EDITOR nvim
set -x BROWSER firefox
set -x LANG "en_US.UTF-8"
set -x MANPAGER "nvim +Man!"

set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"

set -x CPLUS_INCLUDE_PATH /usr/local/include
set -x CMAKE_EXPORT_COMPILE_COMMANDS true

set -x KITTY_ENABLE_WAYLAND 1
set -x MOZ_ENABLE_WAYLAND 1

set -x FZF_DEFAULT_COMMAND "rg --files --hidden"

set -x BAT_THEME TwoDark

set -x GPG_TTY (tty)

set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

set -x DOTFILES_DIR $HOME/dotfiles

# keymaps
set -x XKB_DEFAULT_OPTIONS ctrl:nocaps,altwin:swap_alt_win

# please respect xdg specs
set -x ATOMHOME "$XDG_DATA_HOME/atom"
set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
set -x COOKIECUTTER_CONFIG "$XDG_CONFIG_HOME/cookiecutter/config.yml"
set -x GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -x GOPATH "$XDG_DATA_HOME/go"
set -x LESSHISTFILE "$XDG_DATA_HOME/less/history"
set -x LESSKEY "$XDG_CONFIG_HOME/less/lesskey"
set -x NODE_REPL_HISTORY "$XDG_DATA_HOME/node/repl_history"
set -x PYENV_ROOT "$XDG_DATA_HOME/pyenv"
set -x PYLINTHOME "$XDG_DATA_HOME"/pylint
set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -x STACK_ROOT "$XDG_DATA_HOME/stack"
set -x TERMINFO "$XDG_DATA_HOME/terminfo"
set -x TMUX_PLUGIN_MANAGER_PATH "$XDG_DATA_HOME/tmux/plugins"

# fish colors (comments are base16 numbers)
set pure_color_git_branch brgreen
set pure_color_git_stash brgreen
set pure_color_git_dirty brgreen
set pure_color_mute white
set pure_color_hostname cyan

set fish_color_normal normal
set fish_color_command magenta
set fish_color_quote green
set fish_color_redirection cyan
set fish_color_end cyan
set fish_color_error red
set fish_color_param blue
set fish_color_comment brblack
set fish_color_match normal
set fish_color_selection --background=brblack # todo
set fish_color_search_match normal
set fish_color_history_current normal
set fish_color_operator cyan # todo
set fish_color_escape bryellow # tod
set fish_color_valid_path --underline
set fish_color_autosuggestion white
set fish_color_cancel -r

# configure path
set fish_user_paths $DOTFILES_DIR/bin $PYENV_ROOT/shims /bin/usr/local/opt/ruby/bin $CARGO_HOME/bin /usr/local/opt/llvm/bin/ $XDG_DATA_HOME/gem/ruby/3.0.0/bin $XDG_DATA_HOME/bin $XDG_CONFIG_HOME/emacs/bin $HOME/.local/bin

# greeting
function fish_greeting
    if test -z $NVIM
        set -l date_fmt "%A, %m-%d"

        echo
        echo "  Hello." | figlet | lolcat -F 0.3
        echo "  It is $(date +"$date_fmt")."

        if task overdue 2>/dev/null
            set_color red
            echo "  You have overdue tasks."
            set_color normal
        end
        echo
        set -l task (task next -BLOCKED limit:1 2>/dev/null | tail -n +4 | head -n 1 | sed "s/^ //" | cut -d " " -f1)

        echo -n "  Your most urgent task is to "
        set_color --bold blue
        echo -n (task _get $task.description)
        set_color normal
        echo ", due $(date -d (task _get $task.due) +"$date_fmt") [$task]."

        set -l note (ls -tA ~/notes/forest/trees | head -n1 | path change-extension "")
        echo -n "  Your most recent note is "
        set_color --italics
        echo -n (forester complete ~/notes/forest/trees | rg $note | cut -d "," -f 2 | string trim)
        set_color normal
        echo " [$note]."
        echo
    end
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

# function __neovim_cwd_hook -v PWD
#     if test -n $NVIM
#         nvr --remote-send "<C-\><C-n>:tchdir $PWD<CR>i" >/dev/null 2>&1 &
#     end
# end

# function _handle_cmd_completion_in_inactive_window --on-event fish_postexec -a last_command -d "send a system notification when a command terminates"

#     # store the previous status so we can return it at the end
#     set prev_status $status

#     if status is-interactive; and test -n "$DISPLAY"; and test $TERM = xterm-kitty

#         set window_number (kitty @ ls | jq .[0].platform_window_id)
#         if test $window_number -ne (xdotool getactivewindow)

#             if test $prev_status = 0
#                 set message "Command `$last_command` exited successfully."
#                 set urgency 0
#             else
#                 set message "Command `$last_command` exited unsuccessfully."
#                 set urgency 2
#             end

#             set action (dunstify -u $urgency (string split " " $last_command | head -1) $message --action="default,Switch to Window")

#             if test $action = default
#                 xdotool windowactivate $window_number
#             end
#         end
#     end
#     return $prev_status
# end

### ABBREVIATIONS
abbr -a e $EDITOR
abbr -a emacs "emacsclient -c -a 'emacs'"

# python
abbr -a p python
abbr -a po poetry
abbr -a psh poetry shell
abbr -a pr poetry run
abbr -a p3 python3
abbr -a pt poetry run python -m pytest
abbr -a pn poetry run nox

# cargo
abbr -a c cargo
abbr -a cc cargo clippy --all-targets --all-features -- -W clippy::nursery -W clippy::pedantic --verbose
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
abbr -a gll git log --stat-count=30 # git log long
abbr -a gls git log --color=always --decorate --graph --date=relative \
    --format=tformat:'\'%C(auto)%h%C(reset) -%C(auto)%d%C(reset) %s %C(dim)- %an, %ad%C(reset)\'' # git log short (https://github.com/jan-warchol/sensible-dotfiles/blob/master/.gitconfig)
abbr -a gu git ls-files --other --exclude-standard # "git untracked"
abbr -a gd upto_git

# taskwarrior
abbr -a t task
abbr -a to taskopen --config=$XDG_CONFIG_HOME/task/taskopenrc
abbr -a taskopen taskopen --config=$XDG_CONFIG_HOME/task/taskopenrc

# misc
abbr -a mc mkdir-cd
abbr -a mld mv "~/downloads/(ls -t -A ~/downloads/ | head -1)" . # move last download
abbr -a mls mv "~/screenshots/(ls -t -A ~/screenshots/ | head -1)" . # move last screenshot
abbr -a o open
abbr -a h fancy-help
abbr -a m make
abbr -a j just
abbr -a i paru # install
abbr -a yay echo "type `i`" # for muscle memory
abbr -a ckc cookiecutter
abbr -a mail hydroxide serve \>$XDG_DATA_HOME/hydroxide/hydroxide.log \& \; aerc

# kittens :)
# if type -q kitty and test $TERM = xterm-kitty
#     abbr -a icat "kitty +kitten icat" # image viewer
#     abbr -a ssh "kitty +kitten ssh" # ssh compatibility (https://sw.kovidgoyal.net/kitty/faq/#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer)
# end


# ls replacement
if type -q exa
    set ls_function exa
    set ls_sort -lsold
else
    set ls_function ls
    set ls_sort -ltr
end

abbr -a l $ls_function
abbr -a ls $ls_function
abbr -a ll $ls_function -lh
abbr -a la $ls_function -a
abbr -a lll $ls_function -alh
abbr -a llt $ls_function $ls_sort

# cat replacement
if type -q bat
    set cat_function bat
else
    set cat_function cat
end

abbr -a bat $cat_function
abbr -a cat $cat_function


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
bind \cs history-token-search-backward
bind \cd history-token-search-forward
bind \t complete
bind ! bind_bang
bind '$' bind_dollar

## sourcing stuff to make useful things work
if type -q pyenv
    status is-login; and pyenv init --path | source
    status is-interactive; and pyenv init - | source
end

### Start x
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec qtile start -b wayland
        # exec sway --unsupported-gpu
        # exec startx "$XDG_CONFIG_HOME/X11/xinitrc" -- -keeptty
    end
end
