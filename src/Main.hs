{-# OPTIONS -Wall #-}

-- | Chris Done's XMonad program.

module Main where

import           Control.Concurrent
import           Control.Monad
import qualified Data.Map                  as M
import           XMonad
import           XMonad.Actions.DeManage   (demanage)
import           XMonad.Config.Gnome       (gnomeConfig)
import           XMonad.Hooks.EwmhDesktops (ewmh)
import           XMonad.Hooks.FadeInactive (fadeInactiveLogHook)
import           XMonad.Suave
import           XMonad.Util.Run           (spawnPipe)

-- | Main entry point.
main :: IO ()
main = do
  suave <- suaveStart
  void (spawnPipe "xcompmgr -t-5 -l-5 -r4.2 -o.55 -F")
  void (forkIO (xmonad (ewmh gnomeConfig
                             { terminal          = "gnome-terminal"
                             , modMask           = mod4Mask
                             , focusFollowsMouse = False
                             , borderWidth       = 0
                             , logHook           = fadeInactiveLogHook 0xbbbbbbbb
                             , keys              = newKeys
                             , manageHook        = suaveManageHook
                             , layoutHook        = suaveLayout
                             , startupHook       = suaveStartupHook suave
                             })))
  suaveMain
  where newKeys x = M.union (keys defaultConfig x) (M.fromList (myKeys x))
        myKeys (XConfig{modMask=modm}) =
          [((modm,xK_d),withFocused demanage)]
