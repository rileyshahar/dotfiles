local nvim_lsp = require("lspconfig")
local telescope = require("telescope.builtin")

-- default error in case of no rename
map("<leader>rn", function()
	vim.notify("no rename provider attached", "error")
end)

-- default error in case of no action
map("<leader>a", function()
	vim.notify("no code action provider attached", "error")
end, {"n", "v"})

-- default error in case of no lens
map("<leader>c", function()
	vim.notify("no code lens provider attached", "error")
end)

-- modified from https://github.com/neovim/nvim-lspconfig
local on_attach = function(client, bufnr)
	-- require("lsp_signature").on_attach({
	-- 	-- from lsp_signature config
	-- 	bind = true,
	-- 	handler_opts = {
	-- 		border = "none",
	-- 	},
	-- }, bufnr)

	-- map wrapper which ensures buffer-locality
	local function lsp_map(lhs, rhs, mode)
		map(lhs, rhs, mode, { buffer = bufnr })
	end

	-- gotos
	lsp_map(leaders.goto .. "D", vim.lsp.buf.declaration)
	lsp_map(leaders.goto .. "d", telescope.lsp_definitions)
	lsp_map(leaders.goto .. "i", telescope.lsp_implementations)
	lsp_map(leaders.goto .. "t", telescope.lsp_type_definitions)

	-- finders
	lsp_map(leaders.finder .. "S", telescope.lsp_workspace_symbols)
	lsp_map(leaders.finder .. "s", telescope.lsp_document_symbols)
	lsp_map(leaders.finder .. "r", telescope.lsp_references)
	lsp_map(leaders.finder .. "d", telescope.diagnostics)

	-- code actions
	if client.server_capabilities.codeActionProvider then
		lsp_map("<leader>a", vim.lsp.buf.code_action)
		lsp_map("<leader>a", vim.lsp.buf.code_action, "v")
	end

	if client.server_capabilities.renameProvider then
		lsp_map("<leader>rn", vim.lsp.buf.rename) -- not under capability gate so we get an error if we try to use
	end

	-- code lens
	lsp_map("<leader>c", vim.lsp.codelens.run)

	if client.server_capabilities.codeLensProvider then
		vim.api.nvim_create_augroup("CodeLens", { clear = true })
		vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "InsertLeave", "TextChanged"}, {
			group = "CodeLens",
			callback = vim.lsp.codelens.refresh,
		})
	end

	-- documentation
	lsp_map("K", vim.lsp.buf.hover)
	lsp_map("<leader>k", vim.lsp.buf.signature_help)

	-- diagnostics
	lsp_map("<leader>d", vim.diagnostic.open_float)
	lsp_map("[d", function()
		vim.diagnostic.goto_prev({ wrap = true })
	end)
	lsp_map("]d", function()
		vim.diagnostic.goto_next({ wrap = true })
	end)
	lsp_map("[e", function()
		vim.diagnostic.goto_prev({ wrap = true, severity = vim.diagnostic.severity.ERROR })
	end)
	lsp_map("]e", function()
		vim.diagnostic.goto_next({ wrap = true, severity = vim.diagnostic.severity.ERROR })
	end)

	-- autoformat if we have the capability
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_augroup("Format", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = "Format",
			callback = function() vim.lsp.buf.format { async = true } end,
		})
	end
end

-- local capabilities = require("cmp_nvim_lsp").default_capabilities()

nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, {
	on_attach = on_attach,
	-- capabilities = capabilities,
})

vim.diagnostic.config({
	underline = false,
	-- virtual_text = false,
})

vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", numhl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "", numhl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("LspDiagnosticsSignError", { text = "", numhl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("LspDiagnosticsSignHint", { text = "", numhl = "LspDiagnosticsDefaultHint" })

-- specific language servers
nvim_lsp.clangd.setup({})
nvim_lsp.texlab.setup({
	-- filetypes = { "tex", "plaintex", "bib", "markdown" },
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
  cmd = {"rustup", "run", "stable", "rust-analyzer"},
	settings = {
		["rust-analyzer"] = {
			check = {
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
	-- js
	-- null_ls.builtins.formatting.prettier,

	-- shell
	null_ls.builtins.formatting.fish_indent,
	null_ls.builtins.formatting.shellharden,

	-- lua
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.diagnostics.selene.with({
		cwd = function(_)
			-- always run from the current directory
			-- TODO: traverse up to selene.toml
			return vim.loop.cwd()
		end,
	}),

	-- c
	null_ls.builtins.diagnostics.cppcheck,

	-- python
  -- using pylint by itself instead of through lsp because the lsp was bugging
  -- and not running lints at all under poetry virtualenvs
	null_ls.builtins.diagnostics.pylint,
	-- null_ls.builtins.code_actions.gitsigns,

	-- generic formatters create annoying format conflicts
	-- null_ls.builtins.formatting.trim_whitespace,
	-- null_ls.builtins.formatting.trim_newlines,
}

null_ls.setup({
	sources = sources,
	on_attach = on_attach,
})

-- require("coq-lsp").setup({lsp = {
-- 	on_attach = on_attach
-- }})
--
