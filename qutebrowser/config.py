# you have to do this or it complains
config.load_autoconfig(False)

### SETTINGS
## set darkmode
config.set("colors.webpage.preferred_color_scheme", "dark")

## set smooth scroll
config.set("scrolling.smooth", True)

## keybinds
# fonts
config.set("fonts.default_size", "12pt")

# misc
config.bind("~", "spawn --userscript password_fill")  # fill password from gnu pass
config.bind("<Ctrl-i>", "devtools")  # this is unbound because we bound w to popout

# history
config.bind("H", "back")
config.bind("L", "forward")

# tab navigation
config.bind("h", "tab-prev")  # previous
config.bind("l", "tab-next")  # next
config.bind("t", "set-cmd-text -s :open -t")  # open in new tab
config.bind("W", "hint links window")  # open in new tab
config.bind("w", "tab-give")  # open tab in new window

# scroll
config.bind("K", "scroll-page 0 -0.5")
config.bind("J", "scroll-page 0 0.5")

# ui
config.bind("xb", "config-cycle statusbar.show always never")
config.bind("xt", "config-cycle tabs.show always never")
config.bind(
    "xx",
    "config-cycle statusbar.show always never;; config-cycle tabs.show always never",
)

config.set("url.start_pages", "file:///home/riley/dotfiles/startpage/index.html")
config.set("url.default_page", "file:///home/riley/dotfiles/startpage/index.html")

# downloads
config.set("downloads.location.directory", "$HOME/downloads")

# autosave session on quit
config.set("auto_save.session", True)

# search engines
config.set(
    "url.searchengines",
    {
        "DEFAULT": "https://www.google.com/search?hl=en&q={}",
        "ar": "https://wiki.archlinux.org/?search={}",
        "zlib": "https://b-ok.org/s/{}",
        "r": "https://reddit.com/r/{}",
        "yt": "https://www.youtube.com/results?search_query={}",
    },
)


### COLORS
cac = {
    # __cac:start
    "background": "#1a1b26",
    "foreground": "#a9b1d6",
    "dim_black": "#06080a",
    "dim_red": "#e06c75",
    "dim_green": "#98c379",
    "dim_yellow": "#d19a66",
    "dim_blue": "#7aa2f7",
    "dim_magenta": "#ad8ee6",
    "dim_cyan": "#56bdb8",
    "dim_white": "#abb2bf",
    "bright_black": "#24283b",
    "bright_red": "#f7768e",
    "bright_green": "#9ece6a",
    "bright_yellow": "#e0af68",
    "bright_blue": "#61afef",
    "bright_magenta": "#f6bdff",
    "bright_cyan": "#50c3bd",
    "bright_white": "#ffffff",
    # __cac:end
}

## Background color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.bg = cac["background"]

## Bottom border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.border.bottom = cac["background"]

## Top border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.border.top = cac["background"]

## Foreground color of completion widget category headers.
## Type: QtColor
c.colors.completion.category.fg = cac["dim_white"]

## Background color of the completion widget for even rows.
## Type: QssColor
c.colors.completion.even.bg = cac["bright_black"]

## Background color of the completion widget for odd rows.
## Type: QssColor
c.colors.completion.odd.bg = cac["bright_black"]

## Text color of the completion widget.
## Type: QtColor
c.colors.completion.fg = cac["foreground"]

## Background color of the selected completion item.
## Type: QssColor
c.colors.completion.item.selected.bg = cac["dim_white"]

## Bottom border color of the selected completion item.
## Type: QssColor
c.colors.completion.item.selected.border.bottom = cac["dim_white"]

## Top border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.item.selected.border.top = cac["dim_white"]

## Foreground color of the selected completion item.
## Type: QtColor
c.colors.completion.item.selected.fg = cac["foreground"]

## Foreground color of the matched text in the completion.
## Type: QssColor
c.colors.completion.match.fg = cac["dim_yellow"]

## Color of the scrollbar in completion view
## Type: QssColor
c.colors.completion.scrollbar.bg = cac["bright_black"]

## Color of the scrollbar handle in completion view.
## Type: QssColor
c.colors.completion.scrollbar.fg = cac["dim_white"]

## Background color for the download bar.
## Type: QssColor
c.colors.downloads.bar.bg = cac["background"]

## Background color for downloads with errors.
## Type: QtColor
c.colors.downloads.error.bg = cac["bright_red"]

## Foreground color for downloads with errors.
## Type: QtColor
c.colors.downloads.error.fg = cac["background"]

## Color gradient stop for download backgrounds.
## Type: QtColor
c.colors.downloads.stop.bg = cac["dim_magenta"]

## Color gradient interpolation system for download backgrounds.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
c.colors.downloads.system.bg = "none"

## Background color for hints. Note that you can use a `rgba(...)` value
## for transparency.
## Type: QssColor
c.colors.hints.bg = cac["dim_yellow"]

## Font color for hints.
## Type: QssColor
c.colors.hints.fg = cac["background"]

## Font color for the matched part of hints.
## Type: QssColor
c.colors.hints.match.fg = cac["bright_blue"]

## Background color of the keyhint widget.
## Type: QssColor
c.colors.keyhint.bg = cac["bright_black"]

## Text color for the keyhint widget.
## Type: QssColor
c.colors.keyhint.fg = cac["dim_white"]

## Highlight color for keys to complete the current keychain.
## Type: QssColor
c.colors.keyhint.suffix.fg = cac["dim_yellow"]

## Background color of an error message.
## Type: QssColor
c.colors.messages.error.bg = cac["bright_red"]

## Border color of an error message.
## Type: QssColor
c.colors.messages.error.border = cac["bright_red"]

## Foreground color of an error message.
## Type: QssColor
c.colors.messages.error.fg = cac["background"]

## Background color of an info message.
## Type: QssColor
c.colors.messages.info.bg = cac["bright_blue"]

## Border color of an info message.
## Type: QssColor
c.colors.messages.info.border = cac["bright_blue"]

## Foreground color an info message.
## Type: QssColor
c.colors.messages.info.fg = cac["background"]

## Background color of a warning message.
## Type: QssColor
c.colors.messages.warning.bg = cac["bright_yellow"]

## Border color of a warning message.
## Type: QssColor
c.colors.messages.warning.border = cac["bright_yellow"]

## Foreground color a warning message.
## Type: QssColor
c.colors.messages.warning.fg = cac["dim_white"]

## Background color for prompts.
## Type: QssColor
c.colors.prompts.bg = cac["bright_black"]

# ## Border used around UI elements in prompts.
# ## Type: String
c.colors.prompts.border = "1px solid " + cac["background"]

## Foreground color for prompts.
## Type: QssColor
c.colors.prompts.fg = cac["dim_white"]

## Background color for the selected item in filename prompts.
## Type: QssColor
c.colors.prompts.selected.bg = cac["dim_white"]

## Background color of the statusbar in caret mode.
## Type: QssColor
c.colors.statusbar.caret.bg = cac["dim_magenta"]

## Foreground color of the statusbar in caret mode.
## Type: QssColor
c.colors.statusbar.caret.fg = cac["dim_white"]

## Background color of the statusbar in caret mode with a selection.
## Type: QssColor
c.colors.statusbar.caret.selection.bg = cac["dim_magenta"]

## Foreground color of the statusbar in caret mode with a selection.
## Type: QssColor
c.colors.statusbar.caret.selection.fg = cac["dim_white"]

## Background color of the statusbar in command mode.
## Type: QssColor
c.colors.statusbar.command.bg = cac["bright_black"]

## Foreground color of the statusbar in command mode.
## Type: QssColor
c.colors.statusbar.command.fg = cac["dim_white"]

## Background color of the statusbar in private browsing + command mode.
## Type: QssColor
c.colors.statusbar.command.private.bg = cac["bright_black"]

## Foreground color of the statusbar in private browsing + command mode.
## Type: QssColor
c.colors.statusbar.command.private.fg = cac["dim_white"]

## Background color of the statusbar in insert mode.
## Type: QssColor
c.colors.statusbar.insert.bg = cac["bright_green"]

## Foreground color of the statusbar in insert mode.
## Type: QssColor
c.colors.statusbar.insert.fg = cac["bright_black"]

## Background color of the statusbar.
## Type: QssColor
c.colors.statusbar.normal.bg = cac["background"]

## Foreground color of the statusbar.
## Type: QssColor
c.colors.statusbar.normal.fg = cac["dim_white"]

## Background color of the statusbar in passthrough mode.
## Type: QssColor
c.colors.statusbar.passthrough.bg = cac["bright_blue"]

## Foreground color of the statusbar in passthrough mode.
## Type: QssColor
c.colors.statusbar.passthrough.fg = cac["dim_white"]

## Background color of the statusbar in private browsing mode.
## Type: QssColor
c.colors.statusbar.private.bg = cac["dim_white"]

## Foreground color of the statusbar in private browsing mode.
## Type: QssColor
c.colors.statusbar.private.fg = cac["dim_white"]

## Background color of the progress bar.
## Type: QssColor
c.colors.statusbar.progress.bg = cac["dim_white"]

## Foreground color of the URL in the statusbar on error.
## Type: QssColor
c.colors.statusbar.url.error.fg = cac["bright_red"]

## Default foreground color of the URL in the statusbar.
## Type: QssColor
c.colors.statusbar.url.fg = cac["dim_white"]

## Foreground color of the URL in the statusbar for hovered links.
## Type: QssColor
c.colors.statusbar.url.hover.fg = cac["bright_blue"]

## Foreground color of the URL in the statusbar on successful load
## (http).
## Type: QssColor
c.colors.statusbar.url.success.http.fg = cac["dim_white"]

## Foreground color of the URL in the statusbar on successful load
## (https).
## Type: QssColor
c.colors.statusbar.url.success.https.fg = cac["bright_green"]

## Foreground color of the URL in the statusbar when there's a warning.
## Type: QssColor
c.colors.statusbar.url.warn.fg = cac["bright_yellow"]

## Background color of the tab bar.
## Type: QtColor
c.colors.tabs.bar.bg = cac["bright_black"]

## Background color of unselected even tabs.
## Type: QtColor
c.colors.tabs.even.bg = cac["bright_black"]

## Foreground color of unselected even tabs.
## Type: QtColor
c.colors.tabs.even.fg = cac["foreground"]

## Background color of unselected odd tabs.
## Type: QtColor
c.colors.tabs.odd.bg = cac["bright_black"]

## Foreground color of unselected odd tabs.
## Type: QtColor
c.colors.tabs.odd.fg = cac["foreground"]

## Color for the tab indicator on errors.
## Type: QtColor
c.colors.tabs.indicator.error = cac["bright_red"]

## Color gradient start for the tab indicator.
## Type: QtColor
# c.colors.tabs.indicator.start = cac['violet']

## Color gradient end for the tab indicator.
## Type: QtColor
# c.colors.tabs.indicator.stop = cac['orange']

## Color gradient interpolation system for the tab indicator.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
c.colors.tabs.indicator.system = "none"

# ## Background color of selected even tabs.
# ## Type: QtColor
c.colors.tabs.selected.even.bg = cac["bright_red"]

# ## Foreground color of selected even tabs.
# ## Type: QtColor
c.colors.tabs.selected.even.fg = cac["bright_black"]

# ## Background color of selected odd tabs.
# ## Type: QtColor
c.colors.tabs.selected.odd.bg = cac["bright_red"]

# ## Foreground color of selected odd tabs.
# ## Type: QtColor
c.colors.tabs.selected.odd.fg = cac["bright_black"]

# ## Background color of builtin webpages.
# c.colors.webpage.bg = cac["background"]
