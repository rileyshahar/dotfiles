" setup
set background=dark
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

" check if we can do colors 8-15
if has('gui_running') || (&t_Co > 8 && (!exists('g:disco_nobright') || g:disco_nobright != 1))
    let s:gt_eight = 1
else
    let s:gt_eight = 0
endif

" check if we can do italic
if (&t_ZH != '' && &t_ZH != '[7m')
    let s:italic = 1
else
    let s:italic = 0
endif

" we always want to inherit the terminal bg
let s:bg               = 'NONE'
let s:none             = 'NONE'

" set greyscale colors
if &background == "dark" && s:gt_eight
    let s:dim          = 'DarkGray'
    let s:dimtwo       = 'LightGray'
    let s:fg           = 'White'
else
    let s:fg           = 'Black'
  if s:gt_eight
    let s:dim          = 'LightGray'
    let s:dimtwo       = 'DarkGray'
  else
    let s:dim          = 'LightGray'
    let s:dimtwo       = 'LightGray'
  endif
endif

if &background == "dark" && s:gt_eight
    let s:red          = 'Red'
    let s:green        = 'Green'
    let s:yellow       = 'Yellow'
    let s:blue         = 'Blue'
    let s:magenta      = 'Magenta'
    let s:cyan         = 'Cyan'

    let s:dimred       = 'DarkRed'
    let s:dimgreen     = 'DarkGreen'
    let s:dimyellow    = 'DarkYellow'
    let s:dimblue      = 'DarkBlue'
    let s:dimmagenta   = 'DarkMagenta'
    let s:dimcyan      = 'DarkCyan'

    let s:brightyellow = 'Yellow'

else
    let s:red          = 'DarkRed'
    let s:green        = 'DarkGreen'
    let s:yellow       = 'DarkYellow'
    let s:blue         = 'DarkBlue'
    let s:magenta      = 'DarkMagenta'
    let s:cyan         = 'DarkCyan'

    if s:gt_eight
         let s:dimred       = 'Red'
         let s:dimgreen     = 'Green'
         let s:dimyellow    = 'Yellow'
         let s:dimblue      = 'Blue'
         let s:dimmagenta   = 'Magenta'
         let s:dimcyan      = 'Cyan'

         let s:brightyellow = 'DarkYellow'

    else
        let s:dimred       = s:red
        let s:dimgreen     = s:green
        let s:dimyellow    = s:yellow
        let s:dimblue      = s:blue
        let s:dimmagenta   = s:magenta
        let s:dimcyan      = s:cyan

        let s:brightyellow = s:yellow

    endif
endif

"vim ui
call s:set_colors("ColorColumn", s:fg, s:dim, "")
call s:set_colors("Conceal", s:dim, s:none, "")
call s:set_colors("Cursor", s:dimtwo, s:none, "reverse")
call s:set_colors("CursorLine", s:none, s:dim, "")
call s:set_colors("Directory", s:dimgreen, s:none, "underline")
call s:set_colors("ErrorMsg", s:red, s:none, "underline")
call s:set_colors("VertSplit", s:black, s:none, "")
call s:set_colors("Folded", s:dimtwo, s:bg, "")
call s:set_colors("FoldColumn", s:dimtwo, s:bg, "")
call s:set_colors("SighColumn", s:fg, s:bg, "")
call s:set_colors("IncSearch", s:bg, s:red, "") " todo
call s:set_colors("Substitute", s:bg, s:red, "") " todo
call s:set_colors("LineNr", s:dim, s:bg, "")
call s:set_colors("CursorLineNr", s:fg, s:dim, "")
call s:set_colors("MatchParen", s:fg, s:dimblue, "") " todo
call s:set_colors("ModeMsg", s:fg, s:bg, "bold")
call s:set_colors("MoreMsg", s:blue, s:bg, "bold")
call s:set_colors("NonText", s:dim, s:none, "")
call s:set_colors("Normal", s:fg, s:bg, "")
call s:set_colors("NormalNC", s:fg, s:black, "")
call s:set_colors("NormalNC", s:fg, s:dim, "")
call s:set_colors("Pmenu", s:fg, s:dim, "")
call s:set_colors("PmenuSel", s:dimblue, "") " todo
call s:set_colors("PmenuSbar", s:fg, s:dim, "")
call s:set_colors("PmenuThumb", s:fg, s:dimtwo, "")
call s:set_colors("Question", s:yellow, s:bg, "")
call s:set_colors("QuickFixLine", s:bg, s:blue, "") " todo
call s:set_colors("Search", s:bg, s:green, "") " todo
call s:set_colors("SpecialKey", s:dimtwo, s:bg, "")
call s:set_colors("SpellBad", s:red, s:bg, "underline")
call s:set_colors("SpellCap", s:yellow, s:bg, "underline")
call s:set_colors("SpellLocal", s:blue, s:bg, "underline")
call s:set_colors("SpellRare", s:dimmagenta, s:bg, "underline")
call s:set_colors("StatusLine", s:fg, s:dimtwo)
call s:set_colors("TabLine", s:fg, s:dimtwo)
call s:set_colors("TabLine", s:fg, s:dim)
call s:set_colors("TabLineSel", s:bg, s:dimred, "") " todo
call s:set_colors("Title", s:red, s:bg, "bold")
call s:set_colors("Visual", s:bg, s:dimtwo)
call s:set_colors("VisualNOS", s:bg, s:dimtwo, "underline")
call s:set_colors("WarningMsg", s:yellow, s:bg, "")
call s:set_colors("Whitespace", s:dimtwo, s:bg, "")
call s:set_colors("WildMenu", s:bg, s:blue, "") " todo


" diff

"}}}
" Generic syntax {{{
hi Delimiter       ctermfg=7
hi Comment         ctermfg=8
hi Underlined      ctermfg=4   cterm=underline
hi Type            ctermfg=4
hi String          ctermfg=11
hi Keyword         ctermfg=2
hi Todo            ctermfg=15  ctermbg=NONE     cterm=bold,underline
hi Function        ctermfg=4
hi Identifier      ctermfg=7   cterm=NONE
hi Statement       ctermfg=2   cterm=bold
hi Constant        ctermfg=13
hi Number          ctermfg=12
hi Boolean         ctermfg=4
hi Special         ctermfg=13
hi Ignore          ctermfg=0
hi PreProc         ctermfg=8   cterm=bold
hi! link Operator  Delimiter
hi! link Error     ErrorMsg

"}}}
" Markdown {{{
hi! link markdownHeadingRule        NonText
hi! link markdownHeadingDelimiter   markdownHeadingRule
hi! link markdownLinkDelimiter      Delimiter
hi! link markdownURLDelimiter       Delimiter
hi! link markdownCodeDelimiter      NonText
hi! link markdownLinkTextDelimiter  markdownLinkDelimiter
hi! link markdownUrl                markdownLinkText
hi! link markdownAutomaticLink      markdownLinkText
hi! link markdownCodeBlock          String
hi markdownCode                     cterm=bold
hi markdownBold                     cterm=bold
hi markdownItalic                   cterm=underline

"}}}
" Git {{{
hi gitCommitBranch               ctermfg=3
hi gitCommitSelectedType         ctermfg=10
hi gitCommitSelectedFile         ctermfg=2
hi gitCommitUnmergedType         ctermfg=9
hi gitCommitUnmergedFile         ctermfg=1
hi! link gitCommitFile           Directory
hi! link gitCommitUntrackedFile  gitCommitUnmergedFile
hi! link gitCommitDiscardedType  gitCommitUnmergedType
hi! link gitCommitDiscardedFile  gitCommitUnmergedFile

"}}}
" Vim {{{
hi! link vimSetSep    Delimiter
hi! link vimContinue  Delimiter
hi! link vimHiAttrib  Constant

"}}}
" LESS {{{
hi lessVariable             ctermfg=11
hi! link lessVariableValue  Normal

"}}}
" Help {{{
hi! link helpExample         String
hi! link helpHeadline        Title
hi! link helpSectionDelim    Comment
hi! link helpHyperTextEntry  Statement
hi! link helpHyperTextJump   Underlined
hi! link helpURL             Underlined

"}}}
" Diff {{{
hi diffAdded  ctermfg=2
hi diffRemoved  ctermfg=1
hi! link diffFile  PreProc
hi! link diffLine  Title

" vim: fdm=marker:sw=2:sts=2:et
