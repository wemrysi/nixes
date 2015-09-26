-- xmonad config used by Vic Fryzel
-- Author: Vic Fryzel, Emrys Ingersoll
-- http://github.com/vicfryzel/xmonad-config

import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, mkKeymap)
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "/run/current-system/sw/bin/urxvt"


------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["1:term","2:web","3:code","4:codeaux","5:media"] ++ map show [6..9]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Chromium"       --> doShift "2:web"
    , className =? "Firefox"        --> doShift "2:web"
    , resource  =? "desktop_window" --> doIgnore
    , className =? "Pidgin"         --> doShift "1:term"
    , className =? "stalonetray"    --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    spiral (6/7)) |||
    noBorders (fullscreenFull Full)


------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
myNormalBorderColor  = "#7c7c7c"
myFocusedBorderColor = "#ffb6b0"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

-- Width of the window border in pixels.
myBorderWidth = 1


------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod1Mask

-- Command to run dmenu, unsure why dmenu-with-yeganesh doesn't work
dmenuCmd = "dmenu_run -i -fn 'xft:Source Code Pro:size=10:antialias=true'"

myKeys conf = mkKeymap conf $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ("M-S-<Return>",
     spawn $ XMonad.terminal conf)

  -- Lock the screen using xscreensaver.
  , ("M-C-l",
     spawn "xscreensaver-command -lock")

  -- Launch dmenu, use this to launch programs without a key binding.
  , ("M-p",
     spawn dmenuCmd)

  -- Take a screenshot in select mode.
  -- After pressing this key binding, click a window, or draw a rectangle with
  -- the mouse.
  , ("M-S-p",
     spawn "select-screenshot")

  -- Take full screenshot in multi-head mode.
  -- That is, take a screenshot of everything you see.
  , ("M-C-S-p",
     spawn "screenshot")

  -- Mute volume.
  , ("<XF86AudioMute>",
     spawn "amixer -q set Master toggle")

  -- Decrease volume.
  , ("<XF86AudioLowerVolume>",
     spawn "amixer -q set Master 5%-")

  -- Increase volume.
  , ("<XF86AudioRaiseVolume>",
     spawn "amixer -q set Master 5%+")

  -- Decrease brightness.
  , ("<XF86MonBrightnessDown>",
     spawn "light -b -U 5")

  -- Increase brightness.
  , ("<XF86MonBrightnessUp>",
     spawn "light -b -A 5")

  -- Focus latest urgent window
  , ("M-u",
     focusUrgent)

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ("M-S-c",
     kill)

  -- Cycle through the available layout algorithms.
  , ("M-<Space>",
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ("M-S-<Space>",
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ("M-n",
     refresh)

  -- Move focus to the next window.
  , ("M-<Tab>",
     windows W.focusDown)

  -- Move focus to the next window.
  , ("M-j",
     windows W.focusDown)

  -- Move focus to the previous window.
  , ("M-k",
     windows W.focusUp)

  -- Move focus to the master window.
  , ("M-m",
     windows W.focusMaster)

  -- Swap the focused window and the master window.
  , ("M-<Enter>",
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ("M-S-j",
     windows W.swapDown)

  -- Swap the focused window with the previous window.
  , ("M-S-k",
     windows W.swapUp)

  -- Shrink the master area.
  , ("M-h",
     sendMessage Shrink)

  -- Expand the master area.
  , ("M-l",
     sendMessage Expand)

  -- Push window back into tiling.
  , ("M-t",
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ("M-,",
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ("M-.",
     sendMessage (IncMasterN (-1)))

  -- Quit xmonad.
  , ("M-S-q",
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ("M-q",
     restart "xmonad" True)
  ]

workspaceKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ withUrgencyHook NoUrgencyHook defaults {
      logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
          , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
      }
      , manageHook = manageDocks <+> myManageHook
      , startupHook = setWMName "LG3D"
  }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = \c -> M.union (myKeys c) (workspaceKeys c),
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = smartBorders $ myLayout,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}