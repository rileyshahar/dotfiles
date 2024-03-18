vim.bo.makeprg = "cargo run"
vim.g.rust_clip_command = "pbcopy"

map("<localleader>t", make_async_run("trunk serve --open"), "compile with trunk", "n", { buffer = true })
