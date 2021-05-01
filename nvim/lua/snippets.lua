g.vsnip_snippet_dir = os.getenv("XDG_CONFIG_HOME") .. "/nvim/snippets"

-- set mappings
cmd [[
imap <expr> <tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<tab>'
smap <expr> <tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<tab>'

imap <expr> <s-tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<s-tab>'
smap <expr> <s-tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<s-tab>'
]]
