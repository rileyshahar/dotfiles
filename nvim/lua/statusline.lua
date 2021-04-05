paq 'nvim-lua/lsp-status.nvim'
local lsp_status = require('lsp-status')
lsp_status.register_progress()

lsp_status.config {
  kind_labels = {
    Function = 'func',
    Method = 'mthd',
    Class = 'cls',
  }
}

function gen_section(hl_string, items)
  out = ""
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

function highlight(group, fg, bg)
  cmd('highlight ' .. group .. ' guifg=' .. fg .. ' guibg=' .. bg)
end

local dark_text = "#24283b"

highlight("StatusNormal", dark_text, "#7aa2f7")
highlight("StatusNop", dark_text, "#ff9e64")
highlight("StatusInsert", dark_text, "#b9f27c")
highlight("StatusVisual", dark_text, "#ad8ee6")
highlight("StatusSelect", dark_text, "#ff9e64")
highlight("StatusReplace", dark_text, "#ff9e64")
highlight("StatusCommand", dark_text, "#f6bdff")
highlight("StatusPrompt", dark_text, "#ff9e64")
highlight("StatusShell", dark_text, "#e0af68")
highlight("StatusNone", dark_text, "#444b6a")
highlight("StatusLineDark", "#9098bd", "#232433")

local emph_highlight = "%#StatusLine#"
local dark_highlight = "%#StatusLineDark#"

-- sensibly group the vim modes
function get_mode_group(m) 
  local mode_groups = {
    n = "Normal",
    no = "Nop",
    nov = "Nop",
    noV = "Nop",
    ['noCTRL-V'] = "Nop",
    niI = "Normal",
    niR = "Normal",
    niV = "Normal",
    v = "Visual",
    V = "Visual",
    ['CTRL-V'] = "Visual",
    s = "Select",
    S = "Select",
    ['CTRL-S'] = "Select",
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
    ['r?'] = "Prompt",
    ['!'] = "Shell",
    t = "Term",
    ['null'] = "None"
  }
  return mode_groups[m]
end

-- get the highlight group for a mode group
function get_mode_group_color(mg)
  return "%#Status"..mg.."#"
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
  out = prefix..n
  if n > 0 then
    return hl..out..dark_highlight
  end
  return out
end

function status_line()
  lsp_status.update_current_function()
  local diagnostics = lsp_status.diagnostics()

  local mode = fn.mode()
  local mg = get_mode_group(mode)
  local accent_color = get_mode_group_color(mg)

  local status = ""
  status = status .. gen_section(accent_color, {get_mode_group_display_name(mg)})
  status = status .. gen_section(emph_highlight, {is_readonly(), "%t", is_modified()})
  status = status .. gen_section(dark_highlight, {
    process_diagnostics("E:", diagnostics.errors, "%#LspDiagnosticsDefaultError#"),
    process_diagnostics("W:", diagnostics.warnings, "%#LspDiagnosticsDefaultWarning#"),
    process_diagnostics("I:", diagnostics.info, "%#LspDiagnosticsDefaultInformation#"),
  })
  status = status .. "%=" -- switch to the right side
  status = status .. gen_section(dark_highlight, {
    vim.b.lsp_current_function,
    vim.b.gitsigns_status,
    vim.bo.filetype
  })
  status = status .. gen_section(emph_highlight, {"%p%%"})
  status = status .. gen_section(accent_color, {"%l:%c"})

  return status
end

vim.o.statusline = "%!luaeval('status_line()')"
