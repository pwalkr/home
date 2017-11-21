import XMonad
import XMonad.Layout
import XMonad.Layout.Grid
import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Prompt.Shell(shellPrompt)
import XMonad.Util.EZConfig(additionalKeysP)

main = xmonad $ defaultConfig
	{ borderWidth = 2
	, focusedBorderColor = "#dddddd"
	, focusFollowsMouse = True
	, layoutHook = Tall 1 (3/100) (1/2) ||| Grid ||| Full
	, manageHook = composeAll
		[ className =? "KeePass2"--> doFloat
		, className =? "processing-app-Base"--> doFloat -- Java-based Arduino
		, className =? "VirtualBox"--> doFloat
		]
	, modMask = mod4Mask
	, normalBorderColor = "#000000"
	, terminal = "urxvt"
	}
	`additionalKeysP`
	[ ("M-S-b", spawn "chromium")
	, ("M-r", shellPrompt defaultXPConfig)
	, ("M-S-l", spawn "xscreensaver-command --lock")
	, ("M-S-r", spawn "xmonad --recompile && xmonad --restart")
	, ("M-<Space>", sendMessage NextLayout)
	, ("<Print>", spawn "scrot")
	, ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 3%+")
	, ("<XF86AudioLowerVolume>", spawn "amixer sset Master 3%-")
	, ("<XF86AudioMute>",        spawn "amixer sset Master toggle")
	, ("<XF86MonBrightnessUp>",   spawn "sudo backlight +")
	, ("<XF86MonBrightnessDown>", spawn "sudo backlight -")
	]
