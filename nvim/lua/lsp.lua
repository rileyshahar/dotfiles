require("fidget").setup({})

local nvim_lsp = require("lspconfig")

-- modified from https://github.com/neovim/nvim-rspconfig
local on_attach = function(client, bufnr)
	require("lsp_signature").on_attach()

	local opts = { noremap = true, silent = false }
	local function lsp_map(lhs, rhs, mode)
		mode = mode or "n"
		vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, "<cmd>lua " .. rhs .. "<cr>", opts)
	end

	lsp_map("ga", "vim.lsp.buf.code_action()")
	lsp_map("ga", "vim.lsp.buf.range_code_action()", "v")
	lsp_map("gD", "vim.lsp.buf.declaration()")
	lsp_map("gd", "vim.lsp.buf.definition()")
	lsp_map("K", "vim.lsp.buf.hover()")
	lsp_map("gi", "vim.lsp.buf.implementation()")
	lsp_map("<leader>k", "vim.lsp.buf.signature_help()")
	lsp_map("gt", "vim.lsp.buf.type_definition()")
	lsp_map("gw", "vim.lsp.buf.workspace_symbol()") -- this doesn't work with telescope for some reason

	lsp_map("<leader>d", "vim.lsp.diagnostic.show_line_diagnostics()")
	lsp_map("[d", "vim.diagnostic.goto_prev({ wrap = true })")
	lsp_map("]d", "vim.diagnostic.goto_next({ wrap = true })")
	lsp_map("[e", "vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.ERROR })")
	lsp_map("]e", "vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.ERROR })")
	lsp_map("<leader>q", "vim.lsp.diagnostic.set_loclist()")

	lsp_map("g0", 'require("telescope.builtin").lsp_document_symbols()')
	lsp_map("gr", 'require("telescope.builtin").lsp_references()')

	-- rust-anayzer
	-- todo: make this only a thing for rust
	lsp_map("<leader>t", 'require("lsp_extensions").inlay_hints()')

	-- rename if we have the capability
	-- todo: make sure this is the right name
	if client.resolved_capabilities.rename then
		lsp_map("<leader>rn", "vim.lsp.buf.rename()")
	end

	-- bind formatting if we have the capability
	if client.resolved_capabilities.document_formatting then
		vim.cmd([[augroup Format]])
		vim.cmd([[autocmd! * <buffer>]])
		vim.cmd([[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]])
		vim.cmd([[augroup END]])
	end
end

vim.diagnostic.config({
	virtual_text = false,
})

fn.sign_define("LspDiagnosticsSignInformation", { text = "", numhl = "LspDiagnosticsDefaultInformation" })
fn.sign_define("LspDiagnosticsSignWarning", { text = "", numhl = "LspDiagnosticsDefaultWarning" })
fn.sign_define("LspDiagnosticsSignError", { text = "", numhl = "LspDiagnosticsDefaultError" })
fn.sign_define("LspDiagnosticsSignHint", { text = "", numhl = "LspDiagnosticsDefaultHint" })

-- specific language servers
nvim_lsp.clangd.setup({})
nvim_lsp.texlab.setup({
	settings = {
		latex = {
			lint = {
				onSave = true,
			},
		},
	},
})

nvim_lsp.pylsp.setup({
	settings = {
		pylsp = {
			plugins = {
				pydocstyle = {
					enabled = true,
				},
				pylint = {
					enabled = true,
					executable = "pylint",
					-- args = {'--init-hook="import', "sys;", 'sys.path.append(\'.\')"'}
				},
			},
		},
	},
})

local html_capabilities = vim.lsp.protocol.make_client_capabilities()
html_capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.html.setup({
	capabilities = html_capabilities,
})

nvim_lsp.jsonls.setup({
	capabilities = html_capabilities,
	settings = {
		json = {
			schemas = {
				{
					description = "5e Homebrew",
					fileMatch = { "*.homebrew.json" },
					url = "https://raw.githubusercontent.com/TheGiddyLimit/homebrew/master/_schema-fast/homebrew.json",
				},
			},
		},
	},
})

nvim_lsp.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				overrideCommand = {
					"cargo",
					"clippy",
					"--all-targets",
					"--all-features",
					"--message-format=json",
					"--",
					"-W",
					"clippy::nursery",
					"-W",
					"clippy::pedantic",
					"--verbose",
				},
			},
		},
	},
})

local null_ls = require("null-ls")

-- register any number of sources simultaneously
local sources = {
	null_ls.builtins.formatting.prettier,
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.fish_indent,
	null_ls.builtins.formatting.shellharden,
	null_ls.builtins.diagnostics.luacheck,
	null_ls.builtins.diagnostics.write_good,
	-- null_ls.builtins.code_actions.gitsigns,

	-- generic formatters create annoying format conflicts
	-- null_ls.builtins.formatting.trim_whitespace,
	-- null_ls.builtins.formatting.trim_newlines,
}

null_ls.setup({
	sources = sources,
	on_attach = on_attach,
})
