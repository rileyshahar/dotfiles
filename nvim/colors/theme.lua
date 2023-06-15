local c = {
	norm = {
		fg = "#a9b1d6",
		bg = "#1a1b26", -- TODO: none?
	},
	highc = {
		fg = "#c5c8d6",
		bg = "#06080a",
	},
	lowc = {
		fg = "#545a75",
		bg = "#24283b",
	},
	accent = {
		fg = "#ad8ee6",
		bg = "#283457",
	},

	diff = {
		add = {
			fg = "#9ece61",
			bg = "#3f6622",
		},

		change = {
			fg = "#7aa2f7",
			bg = "#283457",
		},

		delete = {
			fg = "#f7768e",
			bg = "#7f232a",
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
			bg = "#7f232a",
		},

		ok = {
			fg = "#9ece61",
			bg = "#3f6622",
		},

		warning = {
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
}

-- https://github.com/folke/tokyonight.nvim/blob/main/extras/lua/tokyonight_night.lua
local theme = {
	ColorColumn = { bg = c.accent.bg },
	Comment = { fg = c.syntax.comment, italic = true },
	Conceal = { fg = c.lowc.fg },
	CurSearch = { bg = c.diag.ok.bg, fg = c.norm.fg },
	Cursor = { fg = c.bg, bg = c.fg },
	CursorColumn = { bg = c.bg_highlight },
	CursorLine = { bg = c.bg_highlight },
	CursorLineNr = { fg = c.norm.fg },
	DiffAdd = { bg = c.diff.add.bg },
	DiffChange = { bg = c.diff.change.bg },
	DiffDelete = { bg = c.diff.delete.bg },
	DiffText = { fg = c.diff.add.bg },
	Directory = { fg = c.syntax.link },
	EndOfBuffer = { fg = c.bg },
	ErrorMsg = { fg = c.diag.error.fg },
	FloatBorder = { fg = c.lowc.bg, bg = c.lowc.bg },
	FloatTitle = { fg = c.norm.fg, bg = c.norm.bg },
	FoldColumn = { bg = c.norm.bg, fg = c.accent.bg },
	Folded = { fg = c.lowc.fg, bg = c.accent.bg },
	IncSearch = { bg = c.diag.info.bg, fg = c.norm.fg },
	LineNr = { fg = c.lowc.fg },
	MatchParen = { bg = c.accent.bg },
	ModeMsg = { fg = c.norm.fg, bg = c.norm.bg },
	MoreMsg = { fg = c.diag.hint.fg },
	NonText = { fg = c.norm.bg },
	Normal = { fg = c.norm.fg, bg = c.norm.bg },
	NormalFloat = { fg = c.lowc.fg, bg = c.lowc.bg },
	NormalNC = { fg = c.norm.fg, bg = c.norm.bg },
	NormalSB = { fg = c.fg_sidebar, bg = c.bg_sidebar },
	Pmenu = { bg = c.norm.bg, fg = c.norm.fg },
	PmenuSbar = { bg = c.lowc.bg },
	PmenuSel = { bg = c.accent.bg },
	PmenuThumb = { bg = c.highc.bg },
	Question = { fg = c.diag.hint.fg },
	QuickFixLine = { bg = c.accent.bg },
	Search = { bg = c.diag.info.bg, fg = c.norm.fg },
	SignColumn = { bg = c.norm.bg, fg = c.norm.fg },
	SignColumnSB = { bg = c.bg_sidebar, fg = c.fg_gutter },
	SpecialKey = { fg = c.diag.error.fg },
	SpellBad = { fg = c.diag.error.fg, undercurl = true },
	SpellCap = { sp = c.diag.warning.fg, undercurl = true },
	Substitute = { bg = c.accent.bg, fg = c.norm.fg },
	TabLine = { bg = c.lowc.bg, fg = c.norm.fg },
	TabLineFill = { bg = c.norm.bg, fg = c.norm.fg },
	TabLineSel = { bg = c.diag.error.fg, fg = c.norm.bg },
	Title = { fg = c.syntax.func, bold = true },
	VertSplit = { fg = c.norm.bg },
	Visual = { bg = c.accent.bg },
	VisualNOS = { bg = c.accent.bg },
	WarningMsg = { fg = c.diag.warning.fg },
	Whitespace = { fg = c.lowc.fg, bg = c.norm.bg },
	WildMenu = { bg = c.accent.bg },
	WinSeparator = { bg = c.norm.bg, fg = c.norm.bg },

	-- my statuslinads
	StatusLine = { fg = c.norm.fg, bg = c.lowc.bg },
	StatusLineDark = { fg = c.norm.fg, bg = c.norm.bg },
	StatusNormal = { fg = c.norm.bg, bg = c.syntax.link },
	StatusNop = { fg = c.norm.bg, bg = c.diag.warning.fg },
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
	-- Label         = { },
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
	-- Structure     = { },
	-- Typedef       = { },

	Special = { fg = c.syntax.special },
	-- SpecialChar   = { },
	-- Tag           = { },
	Delimiter = { fg = c.syntax.delimiter },
	-- SpecialComment= { },
	Debug = { fg = c.diag.warning.fg },

	Underlined = { underline = true },
	Bold = { bold = true },
	Italic = { italic = true },

	-- Ignore = { }

	Error = { fg = c.diag.error.fg },
	Todo = { bg = c.diag.warning.fg, fg = c.norm.bg },

	LspReferenceText = { bg = c.fg_gutter },
	LspReferenceRead = { bg = c.fg_gutter },
	LspReferenceWrite = { bg = c.fg_gutter },

	DiagnosticError = { fg = c.diag.error.fg, underline = true },
	DiagnosticWarn = { fg = c.diag.warning.fg, underline = true },
	DiagnosticHint = { fg = c.diag.hint.fg, underline = true },
	DiagnosticUnnecessary = { fg = c.diag.warning.fg },

	DiagnosticVirtualTextError = { bg = c.norm.bg, fg = c.diag.error.fg },
	DiagnosticVirtualTextWarn = { bg = c.norm.bg, fg = c.diag.warning.fg },
	DiagnosticVirtualTextInfo = { bg = c.norm.bg, fg = c.diag.info.fg },
	DiagnosticVirtualTextHint = { bg = c.norm.bg, fg = c.diag.hint.fg },

	DiagnosticUnderlineError = { undercurl = true },
	DiagnosticUnderlineWarn = { undercurl = true },
	DiagnosticUnderlineInfo = { undercurl = true },
	DiagnosticUnderlineHint = { undercurl = true },

	LspSignatureActiveParameter = { bold = true },
	LspCodeLens = { fg = c.syntax.comment },
	LspInfoBorder = { fg = c.norm.fg, bg = c.lowc.bg },

	-- Treesitter
	["@comment.documentation"] = {},
	["@text.literal"] = { link = "Comment" },
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
	["@label"] = { link = "Keyword" },
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

	["@operator"] = { fg = c.syntax.operator },
	["@punctuation.special"] = { fg = c.syntax.special5 },

	["@string.documentation"] = { fg = c.syntax.string },
	["@string.regex"] = { fg = c.syntax.special },
	["@string.escape"] = { fg = c.syntax.escape },

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
	["@lsp.type.interface"] = { link = "@interface" },
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

	-- GitSigns
	GitSignsAdd = { fg = c.diff.add.fg },
	GitSignsChange = { fg = c.diff.change.fg },
	GitSignsDelete = { fg = c.diff.delete.fg },

	-- Telescope
	TelescopeBorder = { fg = c.norm.fg, bg = c.norm.bg },
	TelescopeNormal = { fg = c.norm.fg, bg = c.highc.bg },

	-- NeoVim
	healthError = { fg = c.diag.error.fg },
	healthSuccess = { fg = c.diag.ok.fg },
	healthWarning = { fg = c.diag.warning.fg },

	-- Cmp
	CmpDocumentation = { fg = c.norm.fg, bg = c.highc.bg },
	CmpDocumentationBorder = { fg = c.norm.fg, bg = c.accent.bg },
	CmpGhostText = { fg = c.lowc.fg },

	-- CmpItemAbbr = { fg = c.norm.fg },
	-- CmpItemAbbrDeprecated = { fg = c.lowc.fg, strikethrough = true },
	-- CmpItemAbbrMatch = { fg = c.blue1, bg = c.none },
	-- CmpItemAbbrMatchFuzzy = { fg = c.blue1, bg = c.none },

	-- CmpItemMenu = { fg = c.comment, bg = c.none },

	-- CmpItemKindDefault = { fg = c.fg_dark, bg = c.none },

	-- CmpItemKindKeyword = { fg = c.cyan, bg = c.none },

	-- CmpItemKindVariable = { fg = c.magenta, bg = c.none },
	-- CmpItemKindConstant = { fg = c.magenta, bg = c.none },
	-- CmpItemKindReference = { fg = c.magenta, bg = c.none },
	-- CmpItemKindValue = { fg = c.magenta, bg = c.none },
	-- CmpItemKindCopilot = { fg = c.teal, bg = c.none },

	-- CmpItemKindFunction = { fg = c.blue, bg = c.none },
	-- CmpItemKindMethod = { fg = c.blue, bg = c.none },
	-- CmpItemKindConstructor = { fg = c.blue, bg = c.none },

	-- CmpItemKindClass = { fg = c.orange, bg = c.none },
	-- CmpItemKindInterface = { fg = c.orange, bg = c.none },
	-- CmpItemKindStruct = { fg = c.orange, bg = c.none },
	-- CmpItemKindEvent = { fg = c.orange, bg = c.none },
	-- CmpItemKindEnum = { fg = c.orange, bg = c.none },
	-- CmpItemKindUnit = { fg = c.orange, bg = c.none },

	-- CmpItemKindModule = { fg = c.yellow, bg = c.none },

	-- CmpItemKindProperty = { fg = c.green1, bg = c.none },
	-- CmpItemKindField = { fg = c.green1, bg = c.none },
	-- CmpItemKindTypeParameter = { fg = c.green1, bg = c.none },
	-- CmpItemKindEnumMember = { fg = c.green1, bg = c.none },
	-- CmpItemKindOperator = { fg = c.green1, bg = c.none },
	-- CmpItemKindSnippet = { fg = c.dark5, bg = c.none },

	-- Lazy
	LazyProgressDone = { bold = true, fg = c.diag.ok.fg },
	LazyProgressTodo = { bold = true, fg = c.diag.warning.fg },

	-- Notify
	--- Border
	NotifyERRORBorder = { fg = c.diag.error.fg },
	NotifyWARNBorder = { fg = c.diag.error.fg },
	NotifyINFOBorder = { fg = c.diag.info.fg },
	NotifyDEBUGBorder = { fg = c.syntax.comment },
	NotifyTRACEBorder = { fg = c.syntax.special },
	--- Icons
	NotifyERRORIcon = { fg = c.diag.error.fg },
	NotifyWARNIcon = { fg = c.diag.error.fg },
	NotifyINFOIcon = { fg = c.diag.info.fg },
	NotifyDEBUGIcon = { fg = c.syntax.comment },
	NotifyTRACEIcon = { fg = c.syntax.special },
	--- Title
	NotifyERRORTitle = { fg = c.diag.error.fg },
	NotifyWARNTitle = { fg = c.diag.warning.fg },
	NotifyINFOTitle = { fg = c.diag.info.fg },
	NotifyDEBUGTitle = { fg = c.syntax.comment },
	NotifyTRACETitle = { fg = c.syntax.special },
	--- Body
	NotifyERRORBody = { fg = c.norm.fg, bg = c.norm.bg },
	NotifyWARNBody = { fg = c.norm.fg, bg = c.norm.bg },
	NotifyINFOBody = { fg = c.norm.fg, bg = c.norm.bg },
	NotifyDEBUGBody = { fg = c.norm.fg, bg = c.norm.bg },
	NotifyTRACEBody = { fg = c.norm.fg, bg = c.norm.bg },

	-- Fidget
	FidgetTask = { bg = c.norm.bg },
}

for grp, opts in pairs(theme) do
	vim.api.nvim_set_hl(0, grp, opts)
end

for _, group in ipairs(vim.fn.getcompletion("@lsp.typemod", "highlight")) do
	vim.api.nvim_set_hl(0, group, {})
end
