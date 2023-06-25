local c = {
  norm = {
    fg = "#a9b1d6",
    bg = "#1a1b26",
  },
  highc = {
    fg = "#c5c8d6",
    bg = "#101017",
  },
  lowc = {
    fg = "#545a75",
    bg = "#303246",
  },
  accent = {
    fg = "#ad8ee6",
    bg = "#283457",
  },

  diff = {
    add = {
      fg = "#9ece61",
      bg = "#012800",
    },

    change = {
      fg = "#7aa2f7",
      bg = "#283457",
    },

    delete = {
      fg = "#f7768e",
      bg = "#340001",
    },
  },

  syntax = {
    delimiter = "#545a75",
    comment = "#ad8ee6",
    ident = "#e0af68",
    link = "#7aa2f7",
    literal = "#e0af68",
    string = "#9ece6a",
    escape = "#50c3bd",
    special = "#50c3bd",
    func = "#f6bdff",
    keyword = "#f7768e",
    operator = "#f7768e",
    type = "#7aa2f7",
  },

  diag = {
    error = {
      fg = "#f7768e",
      bg = "#340001",
    },

    ok = {
      fg = "#9ece61",
      bg = "#012800",
    },

    warn = {
      fg = "#e0af68",
      bg = "#7d5938",
    },

    info = {
      fg = "#7aa2f7",
      bg = "#283457",
    },

    hint = {
      fg = "#7aa2f7",
      bg = "#283457",
    },
  },

  none = "NONE",
}

-- https://github.com/folke/tokyonight.nvim/blob/main/extras/lua/tokyonight_night.lua
local theme = {
  ColorColumn = { bg = c.accent.bg },
  Comment = { fg = c.syntax.comment, italic = true },
  Conceal = { fg = c.lowc.fg },
  CurSearch = { bg = c.diag.info.fg, fg = c.norm.bg },
  Cursor = { fg = c.norm.bg, bg = c.norm.fg },
  CursorColumn = { bg = c.none },
  CursorLine = { bg = c.none },
  CursorLineNr = { fg = c.norm.fg },
  DiffAdd = { bg = c.diff.add.bg },
  DiffChange = { bg = c.diff.change.bg },
  DiffDelete = { bg = c.diff.delete.bg },
  DiffText = { bg = c.diff.add.fg },
  Directory = { fg = c.syntax.link },
  EndOfBuffer = { fg = c.norm.bg, bg = c.none },
  ErrorMsg = { fg = c.diag.error.fg, underline = true },
  FloatBorder = { fg = c.highc.bg, bg = c.highc.bg },
  FloatTitle = { fg = c.norm.fg, bg = c.none },
  FoldColumn = { bg = c.none, fg = c.accent.bg },
  Folded = { bg = c.accent.bg },
  IncSearch = { bg = c.diag.info.bg, fg = c.norm.fg },
  LineNr = { fg = c.lowc.fg },
  MatchParen = { bg = c.diag.info.fg },
  ModeMsg = { fg = c.norm.fg, bg = c.none },
  MoreMsg = { fg = c.diag.hint.fg },
  NonText = { fg = c.norm.bg },
  Normal = { fg = c.norm.fg, bg = c.norm.bg },
  NormalFloat = { fg = c.norm.fg, bg = c.highc.bg },
  NormalNC = { fg = c.norm.fg, bg = c.norm.bg },
  Pmenu = { bg = c.none, fg = c.norm.fg },
  PmenuSbar = { bg = c.none },
  PmenuSel = { bg = c.accent.bg },
  PmenuThumb = { bg = c.none },
  Question = { fg = c.diag.hint.fg },
  QuickFixLine = { bg = c.accent.bg },
  Search = { bg = c.diag.info.bg, fg = c.norm.fg },
  SignColumn = { bg = c.none, fg = c.norm.fg },
  SpecialKey = { fg = c.diag.error.fg },
  SpellBad = { fg = c.diag.error.fg, undercurl = true },
  SpellCap = { sp = c.diag.warn.fg, undercurl = true },
  Substitute = { bg = c.accent.bg, fg = c.norm.fg },
  TabLine = { bg = c.lowc.bg, fg = c.norm.fg },
  TabLineFill = { bg = c.none, fg = c.norm.fg },
  TabLineSel = { bg = c.diag.error.fg, fg = c.norm.bg },
  Title = { fg = c.syntax.operator, bold = true },
  VertSplit = { fg = c.norm.bg },
  Visual = { bg = c.accent.bg },
  VisualNOS = { bg = c.accent.bg },
  WarningMsg = { fg = c.diag.warn.fg },
  Whitespace = { fg = c.lowc.fg, bg = c.none },
  WildMenu = { bg = c.accent.bg },
  WinSeparator = { bg = c.none, fg = c.norm.bg },

  -- my statuslinads
  StatusLine = { fg = c.norm.fg, bg = c.lowc.bg },
  StatusLineDark = { fg = c.norm.fg, bg = c.none },
  StatusNormal = { fg = c.norm.bg, bg = c.syntax.link },
  StatusNop = { fg = c.norm.bg, bg = c.diag.warn.fg },
  StatusInsert = { fg = c.norm.bg, bg = c.syntax.string },
  StatusVisual = { fg = c.norm.bg, bg = c.syntax.comment },
  StatusSelect = { fg = c.norm.bg, bg = c.syntax.operator },
  StatusReplace = { fg = c.norm.bg, bg = c.syntax.operator },
  StatusCommand = { fg = c.norm.bg, bg = c.syntax.func },
  StatusPrompt = { fg = c.norm.bg, bg = c.syntax.operator },
  StatusShell = { fg = c.norm.bg, bg = c.syntax.func },
  StatusNone = { fg = c.norm.bg, bg = c.lowc.fg },

  -- These groups are not listed as default vim groups,
  -- but they are defacto standard group names for syntax highlighting.
  -- commented out groups should chain up to their "preferred" group by
  -- default, Uncomment and edit if you want more specific syntax highlighting.

  Constant = { fg = c.syntax.literal },
  String = { fg = c.syntax.string },
  Character = { fg = c.syntax.literal },
  -- Number        = { },
  -- Boolean       = { },
  -- Float         = { },

  Identifier = { fg = c.syntax.ident },
  Function = { fg = c.syntax.func },
  Statement = { fg = c.norm.fg },
  -- Conditional   = { },
  -- Repeat        = { },
  Label = { fg = c.syntax.link },
  Operator = { fg = c.syntax.operator },
  Keyword = { fg = c.syntax.keyword, bold = true },
  -- Exception     = { },

  -- PreProc = { fg = c.cyan },
  Include = { link = "Keyword" },
  -- Define        = { },
  Macro = { link = "Function" },
  -- PreCondit     = { },

  Type = { fg = c.syntax.type, bold = true },
  -- StorageClass  = { },
  Structure = { fg = c.syntax.type },
  -- Typedef       = { },

  Special = { fg = c.syntax.special },
  -- SpecialChar   = { },
  -- Tag           = { },
  Delimiter = { fg = c.syntax.delimiter },
  -- SpecialComment= { },
  Debug = { fg = c.diag.warn.fg },

  Underlined = { underline = true },
  Bold = { bold = true },
  Italic = { italic = true },

  -- Ignore = { }

  Error = { fg = c.diag.error.fg, underline = true },
  -- Error = { fg = c.norm.bg, underline = true, bg = c.diag.error.fg },
  Todo = { bg = c.diag.warn.fg, fg = c.norm.bg },

  -- Lua
  coqProofKwd = { link = "Identifier" },
  coqTactic = { link = "Operator" },
  coqThm = { fg = c.syntax.func, bold = false },

  LspCodeLens = { fg = c.syntax.link, underline = true },
  LspSignatureActiveParameter = { fg = c.highc.fg, underline = true, bold = true },
  LspInfoBorder = { fg = c.norm.fg, bg = c.none },

  DiagnosticError = { fg = c.diag.error.fg, underline = true },
  DiagnosticWarn = { fg = c.diag.warn.fg, underline = true },
  DiagnosticHint = { fg = c.diag.hint.fg, underline = true },
  DiagnosticInfo = { fg = c.diag.info.fg, underline = true },
  DiagnosticOk = { fg = c.diag.ok.fg, underline = true },
  DiagnosticUnnecessary = { fg = c.diag.warn.fg },

  DiagnosticSignError = { link = "DiagnosticError" },
  DiagnosticSignWarn = { link = "DiagnosticWarn" },
  DiagnosticSignHint = { link = "DiagnosticHint" },
  DiagnosticSignOk = { link = "DiagnosticOk" },
  DiagnosticSignUnnecessary = { link = "DiagnosticUnnecessary" },

  DiagnosticVirtualTextError = { bg = c.none, fg = c.diag.error.fg },
  DiagnosticVirtualTextWarn = { bg = c.none, fg = c.diag.warn.fg },
  DiagnosticVirtualTextHint = { bg = c.none, fg = c.diag.hint.fg },
  DiagnosticVirtualTextInfo = { bg = c.none, fg = c.diag.info.fg },
  DiagnosticVirtualTextOk = { bg = c.none, fg = c.diag.ok.fg },

  DiagnosticUnderlineError = { undercurl = true },
  DiagnosticUnderlineWarn = { undercurl = true },
  DiagnosticUnderlineInfo = { undercurl = true },
  DiagnosticUnderlineOk = { undercurl = true },
  DiagnosticUnderlineHint = { undercurl = true },

  -- Treesitter
  ["@comment.documentation"] = {},
  ["@text"] = { link = "Normal" },
  ["@text.literal"] = { fg = c.syntax.literal },
  ["@text.reference"] = { link = "Identifier" },
  ["@text.title"] = { link = "Title" },
  ["@text.uri"] = { link = "Underlined" },
  ["@text.underline"] = { link = "Underlined" },
  ["@text.todo"] = { link = "Todo" },

  ["@comment"] = { link = "Comment" },
  ["@punctuation"] = { link = "Delimiter" },

  ["@constant"] = { link = "Constant" },
  ["@constant.builtin"] = { link = "Special" },
  ["@constant.macro"] = { link = "Define" },
  ["@define"] = { link = "Define" },
  ["@macro"] = { link = "Macro" },
  ["@string"] = { link = "String" },
  ["@string.escape"] = { link = "SpecialChar" },
  ["@string.special"] = { link = "SpecialChar" },
  ["@character"] = { link = "Character" },
  ["@character.special"] = { link = "SpecialChar" },
  -- ["@number"] = { link = "Number" },
  -- ["@boolean"] = { link = "Boolean" },
  -- ["@float"] = { link = "Float" },

  ["@function"] = { link = "Function" },
  ["@function.builtin"] = { link = "Special" },
  ["@function.macro"] = { link = "Macro" },
  ["@function.call"] = { link = "Function" },
  ["@parameter"] = { link = "Identifier" },
  ["@method"] = { link = "Function" },
  ["@field"] = { link = "Identifier" },
  ["@property"] = { link = "Identifier" },
  ["@constructor"] = { link = "Special" },

  ["@conditional"] = { link = "Keyword" },
  ["@repeat"] = { link = "Keyword" },
  ["@label"] = { link = "Label" },
  ["@operator"] = { link = "Operator" },
  ["@keyword"] = { link = "Keyword" },
  ["@keyword.function"] = { link = "Keyword" },
  ["@exception"] = { link = "Exception" },

  ["@variable"] = { link = "Identifier" },
  ["@type"] = { link = "Type" },
  ["@type.definition"] = { link = "Typedef" },
  ["@storageclass"] = { link = "StorageClass" },
  ["@structure"] = { link = "Structure" },
  ["@namespace"] = { link = "Identifier" },
  ["@include"] = { link = "Include" },
  ["@preproc"] = { link = "PreProc" },
  ["@debug"] = { link = "Debug" },
  ["@tag"] = { link = "Tag" },

  ["@punctuation.special"] = { fg = c.syntax.special5 },

  ["@string.documentation"] = { fg = c.syntax.string },
  ["@string.regex"] = { fg = c.syntax.special },

  ["@variable.builtin"] = { fg = c.syntax.special },

  ["@text.diff.add"] = { link = "DiffAdd" },
  ["@text.diff.delete"] = { link = "DiffDelete" },

  -- LSP Semantic Token Groups
  ["@lsp.type.boolean"] = { link = "@boolean" },
  ["@lsp.type.builtinType"] = { link = "@type.builtin" },
  ["@lsp.type.class"] = { link = "Structure" },
  ["@lsp.type.comment"] = { link = "@comment" },
  ["@lsp.type.decorator"] = { link = "@type" },
  ["@lsp.type.enum"] = { link = "@type" },
  ["@lsp.type.enumMember"] = { link = "@constant" },
  ["@lsp.type.escapeSequence"] = { link = "@string.escape" },
  ["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" },
  ["@lsp.type.function"] = { link = "@function" },
  ["@lsp.type.generic"] = {},
  ["@lsp.type.interface"] = { link = "Operator" },
  ["@lsp.type.keyword"] = { link = "@keyword" },
  ["@lsp.type.macro"] = { link = "Macro" },
  ["@lsp.type.method"] = { link = "@function" },
  ["@lsp.type.namespace"] = { link = "@namespace" },
  ["@lsp.type.number"] = { link = "@number" },
  ["@lsp.type.operator"] = { link = "@operator" },
  ["@lsp.type.parameter"] = { link = "@parameter" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
  ["@lsp.type.string.rust"] = { link = "@string" },
  ["@lsp.type.struct"] = { link = "Structure" },
  ["@lsp.type.type"] = { link = "@type" },
  ["@lsp.type.typeAlias"] = { link = "@type.definition" },
  ["@lsp.type.typeParameter"] = { link = "@type" },
  ["@lsp.type.unresolvedReference"] = { fg = c.diag.error.fg },
  ["@lsp.type.variable"] = { link = "@variable" }, -- use treesitter styles for regular variables

  -- Neorg
  ["@neorg.headings.1.title"] = { fg = c.syntax.operator },
  ["@neorg.headings.2.title"] = { fg = c.syntax.ident },
  ["@neorg.headings.3.title"] = { fg = c.syntax.func },
  ["@neorg.headings.4.title"] = { fg = c.syntax.string },
  ["@neorg.headings.5.title"] = { fg = c.syntax.type },
  ["@neorg.headings.6.title"] = { fg = c.syntax.comment },

  ["@neorg.headings.1.prefix"] = { link = "@neorg.headings.1.title" },
  ["@neorg.headings.2.prefix"] = { link = "@neorg.headings.2.title" },
  ["@neorg.headings.3.prefix"] = { link = "@neorg.headings.3.title" },
  ["@neorg.headings.4.prefix"] = { link = "@neorg.headings.4.title" },
  ["@neorg.headings.5.prefix"] = { link = "@neorg.headings.5.title" },
  ["@neorg.headings.6.prefix"] = { link = "@neorg.headings.6.title" },

  ["@neorg.markup.variable"] = { link = "Identifier" },
  ["@neorg.markup.verbatim"] = { link = "String" },

  ["@neorg.links.location.generic"] = { fg = c.syntax.link, underline = true },
  ["@neorg.anchors"] = { fg = c.syntax.link, underline = true },
  ["@neorg.anchors.declaration"] = { fg = c.syntax.link, underline = true },

  ["@neorg.markup.variable.delimiter"] = { link = "Delimiter" },
  ["@neorg.anchors.definition.delimiter"] = { link = "Delimiter" },
  ["@neorg.links.location.delimiter"] = { link = "Delimiter" },

  ["@neorg.tags.ranged_verbatim.code_block"] = { bg = c.highc.bg },
  ["@neorg.tags.ranged_verbatim.parameters"] = { link = "Conceal", bg = c.highc.bg },
  ["@neorg.tags.ranged_verbatim.begin"] = { link = "Conceal", bg = c.highc.bg },
  ["@neorg.tags.ranged_verbatim.end"] = { link = "Conceal" },
  ["@neorg.tags.ranged_verbatim.name"] = { link = "Conceal" },
  ["@neorg.tags.ranged_verbatim.name.word"] = { link = "Conceal" },

  -- GitSigns
  GitSignsAdd = { fg = c.diff.add.fg },
  GitSignsChange = { fg = c.diff.change.fg },
  GitSignsDelete = { fg = c.diff.delete.fg },

  -- Telescope
  TelescopeBorder = { fg = c.highc.bg, bg = c.highc.bg },
  TelescopeNormal = { fg = c.norm.fg, bg = c.highc.bg },
  TelescopeTitle = { fg = c.highc.bg, bg = c.accent.fg },
  TelescopePromptNormal = { bg = c.lowc.bg },
  TelescopePromptBorder = { fg = c.lowc.bg, bg = c.lowc.bg },
  TelescopePromptCounter = { fg = c.norm.fg },

  -- NeoVim
  healthError = { fg = c.diag.error.fg },
  healthSuccess = { fg = c.diag.ok.fg },
  healthWarning = { fg = c.diag.warn.fg },

  -- Cmp
  CmpDocumentation = { fg = c.norm.fg, bg = c.highc.bg },
  CmpDocumentationBorder = { fg = c.norm.fg, bg = c.accent.bg },
  CmpGhostText = { fg = c.lowc.fg },

  -- Lazy
  LazyProgressDone = { bold = true, fg = c.diag.ok.fg },
  LazyProgressTodo = { bold = true, fg = c.diag.warn.fg },

  -- Notify
  NotifyBackground = { bg = c.none },
  --- Border
  NotifyERRORBorder = { fg = c.diag.error.fg },
  NotifyWARNBorder = { fg = c.diag.warn.fg },
  NotifyINFOBorder = { fg = c.diag.info.fg },
  NotifyDEBUGBorder = { fg = c.syntax.comment },
  NotifyTRACEBorder = { fg = c.syntax.special },
  --- Icons
  NotifyERRORIcon = { fg = c.diag.error.fg },
  NotifyWARNIcon = { fg = c.diag.warn.fg },
  NotifyINFOIcon = { fg = c.diag.info.fg },
  NotifyDEBUGIcon = { fg = c.syntax.comment },
  NotifyTRACEIcon = { fg = c.syntax.special },
  --- Title
  NotifyERRORTitle = { fg = c.diag.error.fg },
  NotifyWARNTitle = { fg = c.diag.warn.fg },
  NotifyINFOTitle = { fg = c.diag.info.fg },
  NotifyDEBUGTitle = { fg = c.syntax.comment },
  NotifyTRACETitle = { fg = c.syntax.special },

  -- BQF
  BqfPreviewBorder = { fg = c.norm.fg, bg = c.norm.bg },
  BqfPreviewTitle = { link = "Normal" },

  -- Cmp
  CmpItemAbbr = { fg = c.norm.fg },
  CmpItemAbbrDeprecated = { fg = c.lowc.fg, strikethrough = true },
  CmpItemAbbrMatch = { fg = c.diag.info.fg, bg = c.none },
  CmpItemAbbrMatchFuzzy = { fg = c.accent.fg, bg = c.none },
  CmpItemMenu = { fg = c.comment, bg = c.none },

  CmpItemKindClass = { link = "Structure" },
  CmpItemKindColor = { link = "Constant" },
  CmpItemKindConstant = { link = "Constant" },
  CmpItemKindConstructor = { link = "Constructor" },
  CmpItemKind = { link = "Normal" },
  CmpItemKindEnum = { link = "@lsp.type.enum" },
  CmpItemKindEnumMember = { link = "@lsp.type.enumMember" },
  CmpItemKindEvent = { link = "Normal" }, -- TODO
  CmpItemKindField = { link = "Field" },
  CmpItemKindFile = { link = "Directory" },
  CmpItemKindFolder = { link = "Directory" },
  CmpItemKindFunction = { link = "Function" },
  CmpItemKindInterface = { link = "@lsp.type.interface" },
  CmpItemKindKeyword = { link = "Keyword" },
  CmpItemKindMethod = { link = "@method" },
  CmpItemKindModule = { link = "@interface" },
  CmpItemKindOperator = { link = "Operator" },
  CmpItemKindProperty = { link = "@property" },
  CmpItemKindReference = { link = "@text.reference" },
  CmpItemKindSnippet = { link = "Macro" },
  CmpItemKindStruct = { link = "Structure" },
  CmpItemKindText = { fg = c.norm.fg },
  CmpItemKindTypeParameter = { link = "@lsp.type.typeParameter" },
  CmpItemKindUnit = { link = "Literal" },
  CmpItemKindValue = { link = "Literal" },
  CmpItemKindVariable = { link = "Variable" },

  -- Noice
  --- cmdline
  NoiceCmdlinePopupTitle = { fg = c.accent.fg },

  NoiceCmdlineIcon = { fg = c.accent.fg },
  NoiceCmdlinePopupBorder = { fg = c.accent.fg },

  NoiceCmdlinePopupBorderSearch = { link = "NoiceCmdlinePopupBorder" },
  NoiceCmdlineIconSearch = { link = "NoiceCmdlineIcon" },

  -- NoiceCmdline
  -- NoiceCmdlineIconCalculator
  -- NoiceCmdlineIconCmdline
  -- NoiceCmdlineIconFilter
  -- NoiceCmdlineIconHelp
  -- NoiceCmdlineIconIncRename
  -- NoiceCmdlineIconInput
  -- NoiceCmdlineIconLua
  -- NoiceCmdlineIconSearch
  -- NoiceCmdlinePopup
  -- NoiceCmdlinePopupBorderCalculator
  -- NoiceCmdlinePopupBorderCmdline
  -- NoiceCmdlinePopupBorderFilter
  -- NoiceCmdlinePopupBorderHelp
  -- NoiceCmdlinePopupBorderIncRename
  -- NoiceCmdlinePopupBorderInput
  -- NoiceCmdlinePopupBorderLua
  -- NoiceCmdlinePrompt = { fg = c.accent.fg },

  --- completion
  NoiceCompletionItemKindClass = { link = "CmpItemKindClass" },
  NoiceCompletionItemKindColor = { link = "CmpItemKindColor" },
  NoiceCompletionItemKindConstant = { link = "CmpItemKindConstant" },
  NoiceCompletionItemKindConstructor = { link = "CmpItemKindConstructor" },
  NoiceCompletionItemKindDefault = { link = "CmpItemKindDefault" },
  NoiceCompletionItemKindEnum = { link = "CmpItemKindEnum" },
  NoiceCompletionItemKindEnumMember = { link = "CmpItemKindEnumMember" },
  NoiceCompletionItemKindField = { link = "CmpItemKindField" },
  NoiceCompletionItemKindFile = { link = "CmpItemKindFile" },
  NoiceCompletionItemKindFolder = { link = "CmpItemKindFolder" },
  NoiceCompletionItemKindFunction = { link = "CmpItemKindFunction" },
  NoiceCompletionItemKindInterface = { link = "CmpItemKindInterface" },
  NoiceCompletionItemKindKeyword = { link = "CmpItemKindKeyword" },
  NoiceCompletionItemKindMethod = { link = "CmpItemKindMethod" },
  NoiceCompletionItemKindModule = { link = "CmpItemKindModule" },
  NoiceCompletionItemKindProperty = { link = "CmpItemKindProperty" },
  NoiceCompletionItemKindSnippet = { link = "CmpItemKindSnippet" },
  NoiceCompletionItemKindStruct = { link = "CmpItemKindStruct" },
  NoiceCompletionItemKindText = { link = "CmpItemKindText" },
  NoiceCompletionItemKindUnit = { link = "CmpItemKindUnit" },
  NoiceCompletionItemKindValue = { link = "CmpItemKindValue" },
  NoiceCompletionItemKindVariable = { link = "CmpItemKindVariable" },
  NoiceCompletionItemMenu = { link = "CmpItemMenu" },
  NoiceCompletionItemWord = { link = "CmpItemMenu" },

  -- NoiceLspProgressClient
  -- NoiceLspProgressSpinner
  NoiceLspProgressTitle = { link = "Normal" },

  -- NoiceConfirm
  -- NoiceConfirmBorder
  -- NoiceCursor
  -- NoiceFormatConfirm
  -- NoiceFormatConfirmDefault
  -- NoiceFormatDate
  -- NoiceFormatEvent
  -- NoiceFormatKind
  -- NoiceFormatLevelDebug
  -- NoiceFormatLevelError
  -- NoiceFormatLevelInfo
  -- NoiceFormatLevelOff
  -- NoiceFormatLevelTrace
  -- NoiceFormatLevelWarn
  -- NoiceFormatProgressDone
  -- NoiceFormatProgressTodo
  -- NoiceFormatTitle
  -- NoiceMini
  -- NoicePopup
  -- NoicePopupBorder
  -- NoicePopupmenu
  -- NoicePopupmenuBorder
  -- NoicePopupmenuMatch
  -- NoicePopupmenuSelected
  -- NoiceScrollbar
  -- NoiceScrollbarThumb
  -- NoiceSplit
  -- NoiceSplitBorder
  -- NoiceVirtualText
}

for grp, opts in pairs(theme) do
  vim.api.nvim_set_hl(0, grp, opts)
end

for _, group in ipairs(vim.fn.getcompletion("@lsp.typemod", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end
