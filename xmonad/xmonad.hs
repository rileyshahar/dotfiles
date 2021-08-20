import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import Graphics.X11.ExtraTypes.XF86
import Data.Monoid
import Data.Maybe
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

------------------------------------------------------------------------
-- Style
-- colors (managed by cac)
-- __cac:start
background = "#1a1b26"
foreground = "#a9b1d6"
dim_black = "#06080a"
dim_red = "#e06c75"
dim_green = "#98c379"
dim_yellow = "#d19a66"
dim_blue = "#7aa2f7"
dim_magenta = "#ad8ee6"
dim_cyan = "#56bdb8"
dim_white = "#abb2bf"
bright_black = "#24283b"
bright_red = "#f7768e"
bright_green = "#9ece6a"
bright_yellow = "#e0af68"
bright_blue = "#61afef"
bright_magenta = "#f6bdff"
bright_cyan = "#50c3bd"
bright_white = "#ffffff"
-- __cac:end

-- window border
myBorderWidth        = 0
myNormalBorderColor  = dim_white
myFocusedBorderColor = dim_magenta


------------------------------------------------------------------------
-- Workspaces
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]


------------------------------------------------------------------------
-- Shell commands
myTerminal      = "kitty -1 --listen-on unix:@mykitty"                    -- start terminal
myBrowser       = "$BROWSER"                                              -- start browser
menu            = "launcher"                                              -- start rofi
passwordCtrl    = "rofi-pass"                                             -- start rofi-pass
calc            = "calc"                                                  -- run calculator
restartXmonad   = "xmonad --recompile; xmonad --restart"                  -- restart xmonad
setWallpaper    = "feh --no-fehbg --bg-scale $DOTFILES_DIR/wallpaper.jpg" -- set wallpaper
startCompositor = "picom &"                                               -- start picom
topCommand      = "btm --battery"                                         -- system monitor
monitorSetup    = "xrandr --output eDP1 --auto --output DP3 --auto --left-of eDP1"
statusBar       = "launch-polybar"                                        -- script in $DOTFILES_DIR/bin
fluxCommand     = "redshift -l 37:-122 -t 6500:1300 &"                    -- remove blue light at night
customKeybord   = "xmodmap $XDG_CONFIG_HOME/X11/xmodmap"                  -- modify the keyboard setup
gestureControl  = "fusuma &"                                              -- start the gesture control daemon
notifications   = "dunst &"                                               -- start the notification daemon

-- workspace control
-- using these instead of native behavior to allow more fine-grained control via the ewmh maange hook and the script
workspaceNext   = "wmh ws n"                                              -- next workspace
workspacePrev   = "wmh ws p"                                              -- previous workspace


------------------------------------------------------------------------
-- Scratchpads
scratchpads = [
    NS "term" "kitty --title scratchpad" (title =? "scratchpad") floatingRect,
    NS "top" ("kitty --class " ++ "top" ++ " " ++ topCommand) (className =? "top") floatingRect
    ] where
      floatingRect = customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)


------------------------------------------------------------------------
-- Key bindings
myModMask       = mod1Mask -- left option; mod4Mask for super key

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    ---------------------
    -- Launchers
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)                         -- terminal
    , ((modm, xK_apostrophe), spawn myBrowser)                                  -- browser
    , ((modm .|. shiftMask, xK_Return),
                            namedScratchpadAction scratchpads "term")           -- scratchpad terminal
    , ((modm, xK_m), namedScratchpadAction scratchpads "top")                   -- system monitor
    , ((modm, xK_space), spawn menu)                                            -- menu
    , ((modm .|. shiftMask, xK_space), spawn passwordCtrl)                      -- menu
    , ((modm, xK_c), spawn calc)                                                -- calc

    ---------------------
    -- Troubleshooting
    , ((modm, xK_r), refresh)                                                   -- refresh renderer
    , ((modm .|. shiftMask, xK_r), spawn restartXmonad)                               -- restart xmonad
    , ((modm .|. shiftMask, xK_q), kill)                                        -- close focused window

    ---------------------
    -- Layout
    , ((modm, xK_semicolon), sendMessage NextLayout)                            -- rotate to next layout
    , ((modm .|. shiftMask, xK_semicolon), setLayout $ XMonad.layoutHook conf)  -- reset to default layout
    , ((modm .|. shiftMask, xK_Left), sendMessage Shrink)
    , ((modm .|. shiftMask, xK_Right), sendMessage Expand)
    , ((modm, xK_t), sequence_
              [withFocused $ windows . W.sink, killAllOtherCopies])             -- force window to tile
                                                                                -- kill other copies for pip

    --------------------
    -- Window Navigation
    , ((modm, xK_j), windows W.focusDown)                                       -- move focus to next window
    , ((modm, xK_k), windows W.focusUp)                                         -- move focus to prev window
    , ((modm, xK_p), windows mkpip )                                            -- move focused window to PiP
    , ((modm, xK_h), windows W.swapMaster)                                      -- promote focused window to master

    ---------------------
    -- Workspace Navigation
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    ] ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++ [

    ((modm, xK_Right), spawn workspaceNext)                                     -- move to next workspace
    , ((modm, xK_Left), spawn workspacePrev)                                    -- move to prev workspace
    , ((modm .|. shiftMask, xK_l), spawn workspaceNext)                         -- move to next workspace
    , ((modm .|. shiftMask, xK_h), spawn workspacePrev)                         -- move to prev workspace

    ---------------------
    -- System Control

    , ((0, xF86XK_AudioRaiseVolume),  spawn "pulseaudio-ctl up")                -- raise volume
    , ((0, xF86XK_AudioLowerVolume),  spawn "pulseaudio-ctl down")              -- lower volume
    , ((0, xF86XK_AudioMute),         spawn "pulseaudio-ctl mute")              -- mute
    , ((0, xF86XK_AudioPlay),         spawn "playerctl play-pause")             -- toggle audio
    , ((0, xF86XK_AudioNext),         spawn "playerctl next")                   -- next song
    , ((0, xF86XK_AudioPrev),         spawn "playerctl previous")               -- next song
    , ((0, xF86XK_MonBrightnessUp),   spawn "brightnessctl set +5%")            -- raise brightness
    , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 5%-")            -- lower brightness

    ---------------------
    -- Notificatoins
    , ((modm, xK_period), spawn "dunstctl close")                               -- close notifications
    , ((modm .|. shiftMask, xK_period), spawn "dunstctl close-all")             -- close all notifications
    , ((modm, xK_comma), spawn "dunstctl action 0; dunstctl close")                             -- perform action from top notification
    , ((modm .|. shiftMask, xK_comma), spawn "dunstctl context")                -- open context menu for all notifications

    ---------------------
    -- Screenshots
    , ((0, xK_Print), spawn "screenshot")                                       -- copy whole desktop to clipboard
    , ((0 .|. shiftMask, xK_Print), spawn "screenshot -o s")                    -- save whole desktop to file
    , ((modm, xK_Print), spawn "screenshot -s w")                               -- copy selection to clipboard
    , ((modm .|. shiftMask, xK_Print), spawn "screenshot -s w -o s")            -- save selection to file

    ---------------------
    -- Misc
    , ((modm, xK_b), spawn statusBar)                                           -- respawn status bar

    ]


------------------------------------------------------------------------
-- Picture in Picture
mkpip ws = copyToAll (maybe ws (\w -> W.float w rect ws) (W.peek ws))
  where
     rect = W.RationalRect x y w h
     w    = 1 / 4
     h    = 1 / 4
     x    = 1 - w - 1 / 100
     y    = 1 - h - 5 / 100


------------------------------------------------------------------------
-- Layouts
myLayout = avoidStruts $ desktopLayoutModifiers $ tiled ||| Full
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1                                   -- number of windows in master pane
     ratio   = toRational (2/(1 + sqrt 5::Double)) -- proportion of screen occupied by master pane
     delta   = 3/100                               -- percent of screen to increment when resizing master pane
     gapSize = 10                                  -- size of the gaps


------------------------------------------------------------------------
-- Startup hook
myStartupHook = do
    spawnOnce monitorSetup
    spawnOnce setWallpaper
    spawnOnce startCompositor
    spawnOnce statusBar
    spawnOnce fluxCommand
    spawnOnce customKeybord
    spawnOnce gestureControl
    spawnOnce notifications


------------------------------------------------------------------------
-- Manage hook
myManageHook = composeAll
  [ className =? "polybar" --> doFloat ]


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

main = xmonad $ docks $ ewmh defaults

defaults = desktopConfig {
        -- simple stuff
        terminal            = myTerminal,
        borderWidth         = myBorderWidth,
        modMask             = myModMask,
        workspaces          = myWorkspaces,
        normalBorderColor   = myNormalBorderColor,
        focusedBorderColor  = myFocusedBorderColor,

        -- key bindings
        keys                = myKeys,

        -- hooks, layouts
        layoutHook          = myLayout,
        startupHook         = myStartupHook,
        manageHook          = myManageHook
                              <+> manageHook desktopConfig
                              <+> namedScratchpadManageHook scratchpads,
        logHook             = ewmhDesktopsLogHookCustom namedScratchpadFilterOutWorkspace
    }

-- vim:expandtab:sw=6:ts=6
