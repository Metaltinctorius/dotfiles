-- My own xmonad configuration customized to mimic the doom emacs window navigation


-- #############################################################################################################################
-- IMPORTS
-- #############################################################################################################################
    -- Base
import XMonad -- Core functionality
import qualified XMonad.StackSet as W -- Keeps track of the window stacks and window focuses
import System.Exit
   -- Data
import qualified Data.Map as M
import Data.Monoid

--import Data.Monoid

    -- Utilities
import XMonad.Util.EZConfig  -- Simpler way to add keybindings
import XMonad.Util.Loggers   -- Logger functions for PP (pretty-printer) status bars
import XMonad.Util.SpawnOnce -- Start applications
import XMonad.Util.Ungrab
import XMonad.Util.Run



    -- Hooks
import XMonad.Hooks.ManageDocks   -- Automatically manage dock type programs, e.g xmobar
import XMonad.Hooks.EwmhDesktops  -- Ewmh hints, tell panel applications about its workspaces and windows
import XMonad.Hooks.DynamicLog    -- Compatibility wrapper for StatusBar/Statusbar.PP
import XMonad.Hooks.StatusBar     -- Interface for starting status bars
import XMonad.Hooks.StatusBar.PP  -- Pretty-printing abstraction for customizing what is logged to the status bar

    -- Actions
import XMonad.Actions.Submap


    -- Layout modifiers
import XMonad.Layout.Spacing      -- Adding spacing around windows
import XMonad.Layout.Renamed      -- Combinator to change name on layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.Maximize
--------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
--------------------------------------------------------------------------------------------------------------------------------
       -- Keybindings

-- IMPORTANT DEFAULT KEYBINDINGS
--------------------------------------------------------------------
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]

   -- Custom or overwritten keybindings
myKeys :: [(String, X ())]
myKeys =
  [ ("<XF86AudioLowerVolume>", spawn "amixer -q sset Master 5%-")
  , ("<XF86AudioRaiseVolume>", spawn "amixer -q sset Master 5%+")
  , ("<XF86AudioMute>", spawn "amixer set Master toggle")
  , ("M-o", spawn "okular")
  , ("M-s" , spawn "slack")
  , ("M-d", spawn "discord")
  , ("M-p", spawn "rofi -show drun")
  , ("M-i", spawn "/home/nicke/Development/idea-IU-223.8836.41/bin/idea.sh")
  , ("M-c", spawn "code") --vscode
  , ("M-S-b", spawn "brave-browser")
  , ("M-b", spawn "thunar")
  , ("M-x", spawn "emacsclient -c -a 'emacs'")
  , ("M-<Return>", spawn "kitty")
  , ("M-S-h", spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))  -- Run the above help command to visualize default default keybindings
     -- Evil keybindings for window navigation overwriting defaults
  ]





----------------------------------------------------------------------------------------------
-- VARIABLE DECLARATIONS
myTerminal :: String
myTerminal = "kitty"

myEditor :: String
myEditor = "emacsclient -c -a 'emacs'"

myModMask :: KeyMask
myModMask = mod4Mask

myBorderWidth :: Dimension
myBorderWidth  = 2

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool

myClickJustFocuses = False

myWorkspaces :: [String]
myWorkspaces = ["web","dev","local","4","5"]
--myWorkspaceIndices = M.fromList $ zipWith () myWorkspaces [1..] -- Usable if using clickable workspaces

toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
toggleStrutsKey XConfig{ modMask = m } = (m, xK_w)

--------------------------------------------------------------------------------------
--- Startup Hook autostarting applications
--------------------------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
  spawnOnce "nitrogen --restore &"
  spawnOnce "picom &"
  spawnOnce "volumeicon &"
  spawnOnce "nm-tray &"
  spawnOnce "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --iconspacing 2 --widthtype request --transparent true --tint 0x484253 --height 20 &"
  spawnOnce "xscreensaver -no-splash &"
  spawnOnce "conky -c ~/.conkyrc2"
  spawnOnce "conky -c ~/.conkyrc"

-- spawnOnce "/usr/bin/emacs --daemon &"

---------------------------------------------------------------------------------------
--- LAYOUT --- Remember to M-S-SPC for layout to take effect
---        --- Spacing adds a certain amount of blank space around every window
---------------------------------------------------------------------------------------
myLayoutHook = renamed [CutWordsLeft 1] $ spacing 4 $ smartBorders $ avoidStruts myDefaultLayout
  where
    myDefaultLayout = renamed [Replace "tiled"] tiled |||renamed [Replace " mtiled"] (Mirror tiled) ||| renamed [Replace "full"] Full ||| monocle

tiled = Tall nmaster delta ratio
  where
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 1/2    -- Default proportion of screen occupied by master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes


monocle = renamed [Replace "monocle"] Full
--------------------------------------------------------------------------------------
--- WINDOW RULES (manageHook)
--------------------------------------------------------------------------------------
myManageHook = composeAll
  [ className =? "Brave-browser"          --> doShift (head myWorkspaces)
  , className =? "Emacs"                  --> doShift (myWorkspaces !! 1)
  , className =? "jetbrains-idea"         --> doShift (myWorkspaces !! 1)
  , className =? "Code"                   --> doShift (myWorkspaces !! 1)
  , className =? "Thunar"                 --> doShift (myWorkspaces !! 2)
  , className =? "discord"                --> doShift (myWorkspaces !! 3)
  , className =? "okular"                 --> doShift (myWorkspaces !! 2)
  ]


--------------------------------------------------------------------------------------
--- EVENT HANDLING (EventHook)
--------------------------------------------------------------------------------------








--- --------------------------------------------------------------------------------
--- XMOBAR (Status bars and logging) (LogHook)
--- --------------------------------------------------------------------------------
myXmobarPP :: PP
myXmobarPP = def
  { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = magenta . wrap " " "". xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = blue . wrap " " ""
    --, ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    , ppLayout          = turqoise
    }
  where
    formatFocused   = wrap (turqoise    "[") (turqoise    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not exceed a sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow, turqoise :: String -> String
    turqoise = xmobarColor "#8be9fd" ""
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""



---------------------------------------------------------------------------------------------
--- MAIN
---------------------------------------------------------------------------------------------
main :: IO ()
main = xmonad . ewmh . withEasySB (statusBarProp "xmobar ~/.xmobar/xmobarrc" (pure myXmobarPP)) toggleStrutsKey $ myConfig -- M-b to toggle bar

myConfig= def
  -- basics
  { modMask           = mod4Mask
  , terminal          = myTerminal
  , borderWidth       = myBorderWidth
  , focusFollowsMouse = myFocusFollowsMouse
  , clickJustFocuses  = myClickJustFocuses
  , workspaces        = myWorkspaces
  -- hooks
  , layoutHook        = myLayoutHook
  , startupHook = do
        return () >> checkKeymap myConfig myKeys
        myStartupHook
  , manageHook        = myManageHook
  }
  `additionalKeysP` myKeys
