function fish_title \
    --description "Set title to current folder and shell name" \
    --argument-names last_command

    set --local current_folder (_pure_parse_directory)
    set --local current_command (status current-command 2>/dev/null; or echo $_)

    set --local prompt "$current_command [$current_folder]"

    echo $prompt
end
