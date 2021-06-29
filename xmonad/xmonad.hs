import XMonad
import XMonad.Config.Desktop
import XMonad.Layout.Spacing
import XMonad.Util.SpawnOnce
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

------------------------------------------------------------------------
-- Style
-- colors (managed by cac)
-- __cac:start
-- __cac:end

-- window border
myBorderWidth        = 1
myNormalBorderColor  = dim_white
myFocusedBorderColor = bright_blue


------------------------------------------------------------------------
-- Workspaces
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]


------------------------------------------------------------------------
-- Shell commands
myTerminal      = "kitty" 					                    -- start terminal
launchMenu      = spawn "rofi -modi drun,run -show drun"	                    -- start rofi
restartXmonad   = spawn "xmonad --recompile; xmonad --restart"                      -- restart xmonad
setWallpaper    = spawnOnce "feh --no-fehbg --bg-scale $DOTFILES_DIR/wallpaper.jpg" -- set wallpaper
startCompositor = spawnOnce "picom &"                                               -- start picom


------------------------------------------------------------------------
-- Key bindings
myModMask       = mod1Mask -- left option; mod4Mask for super key

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    ---------------------
    -- Launchers
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)                         -- terminal
    , ((modm, xK_space), launchMenu)                                            -- menu

    ---------------------
    -- Troubleshooting
    , ((modm, xK_r), refresh)                                                   -- refresh renderer
    , ((modm .|. shiftMask, xK_r), restartXmonad)                               -- restart xmonad
    , ((modm .|. shiftMask, xK_q), kill)                                        -- close focused window

    ---------------------
    -- Layout
    , ((modm, xK_semicolon), sendMessage NextLayout)                            -- rotate to next layout
    , ((modm .|. shiftMask, xK_semicolon), setLayout $ XMonad.layoutHook conf)  -- reset to default layout
    , ((modm, xK_t), withFocused $ windows . W.sink)                            -- force window to tile

    ---------------------
    -- Window Navigation
    , ((modm, xK_j), windows W.focusDown)                                       -- move focus to next window
    , ((modm, xK_k), windows W.focusUp)                                         -- move focus to prev window
    , ((modm, xK_h), windows W.focusMaster)                                     -- move focus to master window

    ]


------------------------------------------------------------------------
-- Layouts
myLayout = gaps $ tiled ||| Mirror tiled ||| Full
  where
     gaps    = spacingRaw True border True border True
     border  = Border gapSize gapSize gapSize gapSize
     gapSize = 4                         -- size of the gaps
     tiled   = Tall nmaster delta ratio
     nmaster = 1                         -- number of windows in master pane
     ratio   = 1/2                       -- proportion of screen occupied by master pane
     delta   = 3/100                     -- percent of screen to increment when resizing master pane


------------------------------------------------------------------------
-- Startup hook
myStartupHook = do
    setWallpaper
    startCompositor


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

main = xmonad defaults

defaults = desktopConfig {
        -- simple stuff
        terminal           = myTerminal,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

        -- key bindings
        keys               = myKeys,

        -- hooks, layouts
        layoutHook         = myLayout,
        startupHook        = myStartupHook
    }
