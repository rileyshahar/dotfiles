function __neovim_cwd_hook -v PWD
    nvr --remote-send "<C-\><C-n>:tchdir $PWD<CR>i" >/dev/null 2>&1 &
end
