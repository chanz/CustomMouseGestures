#NoEnv
#SingleInstance Force
#Include %A_ScriptDir%\HoverScroll.ahk

;Prevent hotkey limit reached warning (500 is just an arbitrarily high number)
#MaxHotkeysPerInterval 500

;Normal vertical scrolling
WheelUp::
	Lines := ScrollLines_1(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines)
Return

WheelDown::
	Lines := -ScrollLines_1(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines)
Return

;Horizontal scrolling
;Note: Scrolling direction (left/right) can be inverted by adding a minus sign to Lines.
!WheelUp::
	Lines := -ScrollLines_1(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines, 0) ;0 = horizontal, 1 (or omit) = vertical
	ToolTip % "<    "
	SetTimer KillToolTip, -300
Return

!WheelDown::
	Lines := ScrollLines_1(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines, 0) ;0 = horizontal, 1 (or omit) = vertical
	ToolTip % "    >"
	SetTimer KillToolTip, -300
Return

KillToolTip:
	Tooltip
Return

;Control and Shift scrolling
;Ctrl-Scroll usually zooms in and out.
;Note: Although the asterisk stands for any modifier, the !WheelUp and !WheelDown hotkeys take precedence because they appear first in the script.
;You could further split *WheelUp into +Wheelup and ^WheelUp for added control e.g. if you want to use different acceleration for ^WheelUp and +WheelUp, and so on.
*WheelUp::
	Lines := ScrollLines_1(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines)
Return

*WheelDown::
	Lines := -ScrollLines_1(HoverScrollMinLines, HoverScrollMaxLines, HoverScrollThreshold, HoverScrollCurve)
	HoverScroll(Lines)
Return