function gen_section(hl_string, items)
	local out = ""
	for _, item in pairs(items) do
		if item ~= "" then
			if out == "" then
				out = " " .. item
			else
				out = out .. " | " .. item
			end
		end
	end
	return hl_string .. out .. " "
end

local emph_highlight = "%#StatusLine#"
local dark_highlight = "%#StatusLineDark#"

-- sensibly group the vim modes
function get_mode_group(m)
	local mode_groups = {
		n = "Normal",
		no = "Nop",
		nov = "Nop",
		noV = "Nop",
		["noCTRL-V"] = "Nop",
		niI = "Normal",
		niR = "Normal",
		niV = "Normal",
		v = "Visual",
		V = "Visual",
		["CTRL-V"] = "Visual",
		s = "Select",
		S = "Select",
		["CTRL-S"] = "Select",
		i = "Insert",
		ic = "Insert",
		ix = "Insert",
		R = "Replace",
		Rc = "Replace",
		Rv = "Replace",
		Rx = "Replace",
		c = "Command",
		cv = "Command",
		ce = "Command",
		r = "Prompt",
		rm = "Prompt",
		["r?"] = "Prompt",
		["!"] = "Shell",
		t = "Term",
		["null"] = "None",
	}
	return mode_groups[m] or "None"
end

-- get the highlight group for a mode group
function get_mode_group_color(mg)
	return "%#Status" .. mg .. "#"
end

-- get the display name for the group
function get_mode_group_display_name(mg)
	return mg:upper()
end

-- whether the file has been modified
function is_modified()
	if vim.bo.modified then
		if vim.bo.readonly then
			return "-"
		end
		return "+"
	end
	return ""
end

-- whether the file is read-only
function is_readonly()
	if vim.bo.readonly then
		return "RO"
	end
	return ""
end

function process_diagnostics(prefix, n, hl)
	local out = prefix .. n
	if n > 0 then
		return hl .. out .. dark_highlight
	end
	return out
end

-- from https://github.com/nvim-lua/lsp-status.nvim/blob/master/lua/lsp-status/diagnostics.lua
local function get_lsp_diagnostics()
	local result = {}
	local levels = {
		errors = vim.diagnostic.severity.ERROR,
		warnings = vim.diagnostic.severity.WARN,
		info = vim.diagnostic.severity.INFO,
		hints = vim.diagnostic.severity.HINT,
	}

	for k, level in pairs(levels) do
		result[k] = #vim.diagnostic.get(0, { severity = level })
	end

	return result
end

--[[
local type_patterns = {"class", "function", "method", "struct", "enum", "interface", "module", "namespace"}
local function treesitter()
    local sl = require("nvim-treesitter").statusline {type_patterns = type_patterns}
    if sl == nil then
        return ""
    end
    return sl:match("(.*)%(")
    -- return sl:sub(1, sl:match("%("))
end ]]

-- selene: allow(unused_variable)
function status_line()
	local diagnostics = get_lsp_diagnostics()
	local mode = vim.fn.mode()
	local mg = get_mode_group(mode)
	local accent_color = get_mode_group_color(mg)

	return table.concat({
		gen_section(accent_color, { get_mode_group_display_name(mg) }),
		gen_section(emph_highlight, { is_readonly(), "%t", is_modified() }),
		gen_section(dark_highlight, {
			process_diagnostics("E:", diagnostics.errors, "%#DiagnosticError#"),
			process_diagnostics("W:", diagnostics.warnings, "%#DiagnosticWarn#"),
			process_diagnostics("I:", diagnostics.info, "%#DiagnosticInfo#"),
		}),
		"%=",
		gen_section(dark_highlight, {
			vim.b.gitsigns_status,
			vim.bo.filetype,
		}),
		gen_section(emph_highlight, { "%p%%" }),
		gen_section(accent_color, { "%l:%c" }),
	})
end

vim.o.statusline = "%!luaeval('status_line()')"
vim.o.laststatus = 3
