function upto_git -d "Move up the directory tree to find a git repo"
    # from https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish
    while test $PWD != /
        if test -d .git
            break
        end
        cd ..
    end
end
