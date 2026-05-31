return {
  {
    "willothy/flatten.nvim",
    opts = {
      window = {
        -- Flatten opens forwarded buffers with bufadd + set_current_buf, which
        -- breaks oil's directory hijack. Handle directories explicitly with
        -- oil so they open cleanly in the host; fall back to "current" for files.
        open = function(opts)
          for _, file in ipairs(opts.files) do
            -- The guest's oil may hijack the directory before forwarding, so the
            -- path can arrive as an oil:// URL (mangled with the guest cwd).
            -- Recover the real directory path from either form.
            local dir = file.fname:match("oil://(.*)$") or file.fname
            if vim.fn.isdirectory(dir) == 1 then
              pcall(vim.api.nvim_buf_delete, file.bufnr, { force = true })
              require("oil").open(dir)
              return vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
            end
          end
          local focus = opts.files[1]
          vim.api.nvim_set_current_buf(focus.bufnr)
          return focus.bufnr, vim.api.nvim_get_current_win()
        end,
      },
      callback = {
        post_open = function(bufnr, winnr, ft, is_blocking)
          -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
          if ft == "gitcommit" or ft == "gitrebase" then
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              once = true,
              callback = vim.schedule_wrap(function()
                vim.api.nvim_buf_delete(bufnr, {})
              end),
            })
          end
        end,
      },
    },
  },
}
