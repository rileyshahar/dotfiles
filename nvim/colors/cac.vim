" setup
set background=dark
set termguicolors
hi! clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "inherit"

let s:color_map = {
    \'Black'       : 0,
    \'DarkRed'     : 1,
    \'DarkGreen'   : 2,
    \'DarkYellow'  : 3,
    \'DarkBlue'    : 4,
    \'DarkMagenta' : 5,
    \'DarkCyan'    : 6,
    \'LightGray'   : 7,
    \'DarkGray'    : 8,
    \'Red'         : 9,
    \'Green'       : 10,
    \'Yellow'      : 11,
    \'Blue'        : 12,
    \'Magenta'     : 13,
    \'Cyan'        : 14,
    \'White'       : 15,
    \'NONE'        : 'NONE',
\}

" setup stuff from https://github.com/jsit/disco.vim/blob/master/colors/disco.vim
fun! s:set_colors(group, fg, bg, attr)
    if !empty(a:fg)
        exec "hi " . a:group . " guifg=" . a:fg . " ctermfg=" . get(s:color_map, a:fg)
    endif

    if !empty(a:bg)
        exec "hi " . a:group . " guibg=" .  a:bg . " ctermbg=" . get(s:color_map, a:bg)
    endif

    if !empty(a:attr)
        exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr . " term=" . a:attr
    endif
endfun

let s:none         = 'NONE'

" __cac:start
let s:foreground='#a9b1d6'
let s:dim_black='#06080a'
let s:dim_red='#e06c75'
let s:dim_green='#98c379'
let s:dim_yellow='#d19a66'
let s:dim_blue='#7aa2f7'
let s:dim_magenta='#ad8ee6'
let s:dim_cyan='#56bdb8'
let s:dim_white='#545a75'
let s:bright_black='#24283b'
let s:bright_red='#f7768e'
let s:bright_green='#9ece6a'
let s:bright_yellow='#e0af68'
let s:bright_blue='#61afef'
let s:bright_magenta='#f6bdff'
let s:bright_cyan='#50c3bd'
let s:bright_white='#a9b1d6'
" __cac:end

let s:background='NONE'

"vim ui
call s:set_colors("ColorColumn", s:foreground, s:bright_black, "")
call s:set_colors("Conceal", s:dim_white, s:none, "")
call s:set_colors("Cursor", s:dim_white, s:none, "reverse")
call s:set_colors("CursorLine", s:none, s:bright_black, "")
call s:set_colors("CursorLineNr", s:foreground, s:bright_black, "")
call s:set_colors("Directory", s:dim_green, s:none, "underline")
call s:set_colors("ErrorMsg", s:bright_red, s:none, "underline")
call s:set_colors("FloatBorder", s:background, s:background, "")
call s:set_colors("FoldColumn", s:dim_white, s:background, "")
call s:set_colors("Folded", s:dim_white, s:background, "")
call s:set_colors("IncSearch", s:dim_black, s:bright_red, "") " TODO
call s:set_colors("LineNr", s:dim_white, s:background, "")
call s:set_colors("MatchParen", s:foreground, s:dim_blue, "") " TODO
call s:set_colors("ModeMsg", s:foreground, s:background, "bold")
call s:set_colors("MoreMsg", s:bright_blue, s:background, "bold")
call s:set_colors("NonText", s:dim_white, s:none, "")
call s:set_colors("Normal", s:foreground, s:background, "")
call s:set_colors("Pmenu", s:foreground, s:bright_black, "")
call s:set_colors("PmenuSbar", s:foreground, s:bright_black, "")
call s:set_colors("PmenuSel", s:dim_black, s:bright_blue, "") " TODO
call s:set_colors("PmenuThumb", s:foreground, s:dim_white, "")
call s:set_colors("Question", s:bright_yellow, s:background, "")
call s:set_colors("QuickFixLine", s:foreground, s:background, "") " TODO
call s:set_colors("Search", s:background, s:bright_green, "") " TODO
call s:set_colors("SignColumn", s:foreground, s:background, "")
" call s:set_colors("SignColumn", s:dim_white, s:bright_black, "") " TODO
call s:set_colors("SpecialKey", s:dim_white, s:background, "")
call s:set_colors("SpellBad", s:bright_red, s:background, "underline")
call s:set_colors("SpellCap", s:bright_yellow, s:background, "underline")
call s:set_colors("SpellLocal", s:bright_blue, s:background, "underline")
call s:set_colors("SpellRare", s:dim_magenta, s:background, "underline")
call s:set_colors("Substitute", s:background, s:bright_red, "") " TODO
call s:set_colors("TabLine", s:dim_white, s:foreground, "")
call s:set_colors("TabLineFill", s:bright_black, s:foreground, "")
call s:set_colors("TabLineSel", s:dim_black, s:bright_red, "NONE") " TODO
call s:set_colors("Title", s:bright_red, s:background, "bold")
call s:set_colors("VertSplit", s:background, s:background, "")
call s:set_colors("VertSplit", s:dim_black, s:none, "")
call s:set_colors("Visual", s:background, s:bright_black, "")
call s:set_colors("VisualNOS", s:background, s:bright_black, "underline")
call s:set_colors("WarningMsg", s:bright_yellow, s:background, "")
call s:set_colors("Whitespace", s:dim_white, s:background, "")
call s:set_colors("WildMenu", s:dim_black, s:bright_blue, "") " TODO
call s:set_colors("WinSeparator", s:background, s:background, "")

" statusline
" TODO: there were better colors here, check old commits
call s:set_colors("StatusLine", s:foreground, s:bright_black, "NONE")
call s:set_colors("StatusNormal", s:bright_black, s:dim_blue, "")
call s:set_colors("StatusNop", s:bright_black, s:dim_yellow, "")
call s:set_colors("StatusInsert", s:bright_black, s:bright_green, "")
call s:set_colors("StatusVisual", s:bright_black, s:dim_magenta, "")
call s:set_colors("StatusSelect", s:bright_black, s:dim_yellow, "")
call s:set_colors("StatusReplace", s:bright_black, s:dim_yellow, "")
call s:set_colors("StatusCommand", s:bright_black, s:bright_magenta, "")
call s:set_colors("StatusPrompt", s:bright_black, s:dim_yellow, "")
call s:set_colors("StatusShell", s:bright_black, s:bright_yellow, "")
call s:set_colors("StatusNone", s:bright_black, s:dim_white, "")
call s:set_colors("StatusLineDark", s:foreground, s:background, "")

call s:set_colors("LspDiagnosticsDefaultError", s:bright_red, s:none, "underline")
call s:set_colors("LspDiagnosticsDefaultWarning", s:bright_yellow, s:none, "")
call s:set_colors("LspDiagnosticsDefaultInformation", s:bright_blue, s:none, "")

" syntax
call s:set_colors("Comment", s:dim_magenta, s:background, "italic")
call s:set_colors("SpecialComment", s:dim_magenta, s:background, "italic")
call s:set_colors("RustComment", s:dim_magenta, s:background, "italic")
call s:set_colors("Constant", s:dim_yellow, s:background, "")
call s:set_colors("String", s:bright_green, s:background, "")
call s:set_colors("Character", s:bright_green, s:background, "")
call s:set_colors("Identifier", s:bright_yellow, s:background, "NONE")
call s:set_colors("Function", s:bright_magenta, s:background, "")
call s:set_colors("Statement", s:bright_red, s:background, "")
call s:set_colors("PreProc", s:bright_red, s:background, "")
call s:set_colors("Type", s:bright_blue, s:background, "")
call s:set_colors("Special", s:bright_cyan, s:background, "")
call s:set_colors("Delimiter", s:dim_white, s:background, "")
call s:set_colors("Underlined", s:dim_blue, s:background, "underline")
call s:set_colors("Ignore", s:bright_black, s:background, "")
call s:set_colors("TODO", s:dim_black, s:bright_yellow, "")
hi! link Error     ErrorMsg

" diff
call s:set_colors("DiffAdd", s:bright_green, s:background, "")
call s:set_colors("DiffChange", s:bright_blue, s:background, "")
call s:set_colors("DiffDelete", s:bright_red, s:background, "")

" plugins
hi! link @neorg.markup.inline_comment Comment
hi! link @neorg.markup.inline_comment.delimiter Comment

hi! link SubstituteExchange Visual

" cmp
" TODO: probably more stuff
" hi! link CmpItemAbbrDeprecated Conceal
" hi! link CmpItemKindVariable Identifier
" hi! link CmpItemKindInterface Identifier
" hi! link CmpItemKindText String
" hi! link CmpItemKindFunction Function
" hi! link CmpItemKindMethod Method
" hi! link CmpItemKindKeyword Keyword
" hi! link CmpItemKindSnippet Special
" hi! link CmpItemKindClass Type
" hi! link CmpItemKindTypeParameter Type
" hi! link CmpItemKindProperty 
" hi! link CmpItemKindUnit guibg=NONE guifg=#D4D4D4

" highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
" highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6

" vim: fdm=marker:sw=2:sts=2:et
