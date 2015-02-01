#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#InstallMouseHook
#InstallKeybdHook
#HotkeyModifierTimeout -1
#MaxThreadsPerHotkey 6
#MaxHotkeysPerInterval 10000 ;Stops warning when mouse spins really fast
#SingleInstance Force
#Include %A_ScriptDir%\HoverScroll.ahk

; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen
SetMouseDelay, -1
SetKeyDelay, -1
SetBatchLines, -1 ;Run as fast as possible

; General Settings
szIgnoreProcesses:="KSP.exe|mstsc.exe" ; RegEx Match to ignore windows with these process names
szAllowProcesses:="explorer.exe|firefox.exe"

; Settings for Mouse Gestures (todo...)

; Incode Vars (dont' change)
mWheelUsed:=0
bBlockActivation:=0
SetTimer, CheckActiveWindow, 1000
return

CheckActiveWindow:
	WinGet, active_id, ID, A
	if (!IsWindowValid(active_id)){
		Suspend, On
	}
	else {
		Suspend, Off
	}
return

#Home::
	MoveWinToQuadrant("top")
return

#Ins::
	MoveWinToQuadrant("topleft")
return

#PgUp::
	MoveWinToQuadrant("topright")
return

#End::
	MoveWinToQuadrant("bottom")
return

#Del::
	MoveWinToQuadrant("bottomleft")
return

#PgDn::
	MoveWinToQuadrant("bottomright")
return

MoveWinToQuadrant(quadrant="top") {
	global bBlockActivation
	if (bBlockActivation=1){
		return
	}
	WinGet, active_id, ID, A
	bBlockActivation:=1
	WinGetPos, x, y,,, ahk_id %active_id%,,,
	monitor:=GetMonitorByPos(x+10, y+10)

	result:=GetMonitorQuadrant(monitor, quadrant, x, y, width, height)
	if (result=1) {
		return
	}

	;MsgBox, Going to...`nx%x%x %y%y`nwidth: %width% height:%height%
	Send, #{Down}
	WinRestore, ahk_id %active_id%
	Send, #{Right}
	WinMove, ahk_id %active_id%,, x, y, width, height
	bBlockActivation:=0
}

GetMonitorByPos(x, y) {
	SysGet, MonitorCount, MonitorCount
	Loop, %MonitorCount%
	{
	    SysGet, Monitor, Monitor, %A_Index%
	    if (MonitorLeft < x AND x < MonitorRight AND MonitorTop < y AND y < MonitorBottom)
	    {
	    	; MsgBox, index: %A_Index% `nLeft: %MonitorLeft% `nTop: %MonitorTop% `nRight: %MonitorRight% `nBottom: %MonitorBottom% `n`nMouseX: %x% `nMouseY: %y%
	    	return, %A_Index%
	    }
	}
}

GetMonitorQuadrant(monitorNumber, quadrantName="top", ByRef x=0, ByRef y=0, ByRef width=0, ByRef height=0) {

	SysGet, MonitorWorkArea, MonitorWorkArea, %monitorNumber%

	if (quadrantName="top") {
		width:=MonitorWorkAreaRight-MonitorWorkAreaLeft
		height:=MonitorWorkAreaBottom-MonitorWorkAreaTop

		height:=Round(height/2)

		x:=MonitorWorkAreaLeft
		y:=MonitorWorkAreaTop
	}
	else if (quadrantName="topleft") {
		width:=MonitorWorkAreaRight-MonitorWorkAreaLeft
		height:=MonitorWorkAreaBottom-MonitorWorkAreaTop

		width:=Round(width/2)
		height:=Round(height/2)

		x:=MonitorWorkAreaLeft
		y:=MonitorWorkAreaTop
	}
	else if (quadrantName="topright") {
		width:=MonitorWorkAreaRight-MonitorWorkAreaLeft
		height:=MonitorWorkAreaBottom-MonitorWorkAreaTop

		width:=Round(width/2)
		height:=Round(height/2)

		x:=MonitorWorkAreaRight-width
		y:=MonitorWorkAreaTop
	}
	else if (quadrantName="bottom") {
		width:=MonitorWorkAreaRight-MonitorWorkAreaLeft
		height:=MonitorWorkAreaBottom-MonitorWorkAreaTop

		height:=Round(height/2)

		x:=MonitorWorkAreaLeft
		y:=MonitorWorkAreaBottom-height
	}
	else if (quadrantName="bottomleft") {
		width:=MonitorWorkAreaRight-MonitorWorkAreaLeft
		height:=MonitorWorkAreaBottom-MonitorWorkAreaTop

		width:=Round(width/2)
		height:=Round(height/2)

		x:=MonitorWorkAreaLeft
		y:=MonitorWorkAreaBottom-height
	}
	else if (quadrantName="bottomright") {
		width:=MonitorWorkAreaRight-MonitorWorkAreaLeft
		height:=MonitorWorkAreaBottom-MonitorWorkAreaTop

		width:=Round(width/2)
		height:=Round(height/2)

		x:=MonitorWorkAreaRight-width
		y:=MonitorWorkAreaBottom-height
	}
	else {
		ToolTipTime("error unknowen quadrant: %quadrantName%")
		return, 1
	}
}

; Pixel precise scrolling??
; https://msdn.microsoft.com/en-us/library/windows/desktop/bb787593%28v=vs.85%29.aspx

WheelUp::
WheelDown::

	; Settings for Fast Scrolling
	WheelDelta := 120 << 16 ;As defined by Microsoft
	NormalScrollSpeed := 1 * WheelDelta
	FastScrollSpeed := 6 * WheelDelta

	MouseGetPos,,, hWin,, 2

	WinGetTitle, hWinTitle, ahk_id %hWin%

	if (hWinTitle == "") {
		if (GetKeyState("Ctrl", P)) {
			ToolTipTime("Window name is empty!")
		}
		Send, {%A_ThisHotkey%}
		return
	}

	IfWinNotActive, ahk_id %hwin%
	{
		WinActivate, ahk_id %hWin%
	}

	if (GetKeyState("RButton","P")) {

		; Disable Gestures
		mWheelUsed:=A_ThisHotkey

		if (A_ThisHotkey="WheelUp") {
			;FocuslessScroll(FastScrollSpeed)
			HoverScroll(6)
		}
		else if (A_ThisHotKey="WheelDown") {
			;FocuslessScroll(-FastScrollSpeed)
			HoverScroll(-6)
		}
	}
	else {
		if (A_ThisHotkey="WheelUp") {
			;FocuslessScroll(NormalScrollSpeed)
			HoverScroll(1)
		}
		else if (A_ThisHotKey="WheelDown") {
			;FocuslessScroll(-NormalScrollSpeed)
			HoverScroll(-1)
		}
	}
return


$*MButton::
;Hotkey, $*MButton Up, MButtonup, off
KeyWait, MButton, T0.2
If ErrorLevel = 1
{
	Hotkey, $*MButton Up, MButtonup, on
	MouseGetPos, ox, oy
 	SetTimer, WatchTheMouse, 50
	;SystemCursor("Toggle")
}
Else
	Send {MButton}
return

MButtonup:
Hotkey, $*MButton Up, MButtonup, off
SetTimer, WatchTheMouse, off
;SystemCursor("Toggle")
return

; Initial start after MBUTTON has been pressed long enough: Scroll as soon the mouse has moved 4px into one direction
; When scrolling has stopped (ie: mouse is not moving anymore after 150ms), start at the initial point again.
; During mouse movement (unchanged direction), continue to scroll.
; When the delta of the mouse distance is over 5 increase by one more scroll event. (over 10 = two more scroll events)
WatchTheMouse:
    MouseGetPos, nx, ny
    dy := ny-oy
    dx := nx-ox

    ; When moving the mouse up and down  
    If (dy**2 > 3 and dy**2>dx**2)
    {
    	; When the delta of the mouse distance is over 5 increase by one more scroll event. (over 10 = two more scroll events)
        multiplyer := Floor(Abs(dy) / 5)
        
		If (dy > 0)
        {
			;Click Wheelup
            doTheScrollDirection := 1 + multiplyer
        }
		Else
        {
			;Click WheelDown
            doTheScrollDirection := -1 - multiplyer
        }
    }

    if (doTheScrollDirection != 0)
    {
        MouseGetPos,,, hWin,, 2
        IfWinNotActive, ahk_id %hwin%
		{
			WinActivate, ahk_id %hWin%
		}
        LineScroll(hWin, 0, doTheScrollDirection)
        doTheScrollDirection := 0
    }

    ;tooltip, times: %times%`ndy: %dy% dx: %dx%`nmulti: %multiplyer%
    MouseMove ox, oy
return

LineScroll(hWnd, dx, dy)
{
	;DllCall("ScrollWindowEx" , UInt, hWnd, Int, dx, Int, dy, Int, NULL, Int, NULL, Int, 0, Int, 0, Uint, NULL)
	if (dy > 0)
	{
		direction := 1
	}
	else if dy < 0
	{
		direction := 0
	}
	repeat := Abs(dy)
	loop %repeat%
	{
		;tooltip, direction: %direction%`ndy: %dy%
		DllCall("PostMessage","PTR",hWnd,"UInt",0x115,"PTR",direction,"PTR",1)
	}
}

FocuslessScroll(ScrollStep)
{
	
	MouseGetPos, m_x, m_y,, Target1, 2
	MouseGetPos, m_x, m_y,, Target2, 3
	
	MouseGetPos,,,MouseWin
	ControlGet, List, List, Selected, Target1
	Loop, Parse, List, `n  ; Rows are delimited by linefeeds (`n).
	{
	    RowNumber := A_Index
	    Loop, Parse, A_LoopField, %A_Tab%  ; Fields (columns) in each row are delimited by tabs (A_Tab).
	        MsgBox Row #%RowNumber% Col #%A_Index% is %A_LoopField%.
	}
	
	;If Target1 != Target1, only one will work, but it is not known which, so using both won't hurt
	If(Target1 != Target2)
	{
		SendMessage, 0x20A, ScrollStep, (m_y << 16) | m_x,, ahk_id %Target1%
		SendMessage, 0x20A, ScrollStep, (m_y << 16) | m_x,, ahk_id %Target2%
	}
	;For all other 'normal' controls either Target1  or Target2 will do the trick. Here we choose Target1 (though Target2 would work just as well), the important thing is to use only one otherwise we'll get double scroll speed.
	Else
	{
		SendMessage, 0x20A, ScrollStep, (m_y << 16) | m_x,, ahk_id %Target1%
	}
}


rbutton::
	mWheelUsed:=0
	MouseGetPos, iStartPos_X, iStartPos_Y, widStartPos_Window
	gst:=Mouse_Gesture()
	MouseGetPos, iEndPos_X, iEndPos_Y, hEndPos_Window

	WinGet szStartPos_WindowProcessName, ProcessName, ahk_id %widStartPos_Window%
	; tooltip, szStartPos_WindowProcessName: %szStartPos_WindowProcessName%
	WinGetPos, iStartPos_WindowPosX, iStartPos_WindowPosY, iStarPos_WindowWidth, iStarPos_WindowHeight, ahk_id %widStartPos_Window%

	if (gst="dr")
	{
		if (szStartPos_WindowProcessName="firefox.exe") 
		{
			adressBarPosX:=iStartPos_WindowPosX+(iStarPos_WindowWidth/2)
			adressBarPosY:=iStartPos_WindowPosY+53

			MouseClick,, adressBarPosX, adressBarPosY
			Send, ^w
			MouseMove, iEndPos_X, iEndPos_Y
		}
		else if (szStartPos_WindowProcessName="sublime_text.exe") {
			Send, ^w
		}
		else {
			WinClose, ahk_id %widStartPos_Window%
		}
	}
	else if (gst="dl")
	{
		if (szStartPos_WindowProcessName="firefox.exe") 
		{
			adressBarPosX:=iStartPos_WindowPosX+(iStarPos_WindowWidth/2)
			adressBarPosY:=iStartPos_WindowPosY+53

			MouseClick,, adressBarPosX, adressBarPosY
			Send, {F6}
			Send, ^+t
			MouseMove, iEndPos_X, iEndPos_Y
		}
		else if (szStartPos_WindowProcessName="sublime_text.exe") {
			Send, ^+t
		}
	}
	else if (gst="ur")
	{
		if (szStartPos_WindowProcessName="firefox.exe") 
		{
			adressBarPosX:=iStartPos_WindowPosX+(iStarPos_WindowWidth/2)
			adressBarPosY:=iStartPos_WindowPosY+53

			MouseClick,, adressBarPosX, adressBarPosY
			Send, {F6}
			Send, ^{TAB}
			MouseMove, iEndPos_X, iEndPos_Y
		}
		else if (szStartPos_WindowProcessName="sublime_text.exe") {
			Send, ^{TAB}
		}
	}
	else if (gst="ul")
	{
		if (szStartPos_WindowProcessName="firefox.exe") 
		{
			adressBarPosX:=iStartPos_WindowPosX+(iStarPos_WindowWidth/2)
			adressBarPosY:=iStartPos_WindowPosY+53

			MouseClick,, adressBarPosX, adressBarPosY
			Send, {F6}
			Send, ^+{TAB}
			MouseMove, iEndPos_X, iEndPos_Y
		}
		else if (szStartPos_WindowProcessName="sublime_text.exe") {
			Send, ^+{TAB}
		}
	}
	else if (gst="ru")
	{
		if (szStartPos_WindowProcessName="firefox.exe") 
		{
			adressBarPosX:=iStartPos_WindowPosX+(iStarPos_WindowWidth/2)
			adressBarPosY:=iStartPos_WindowPosY+53

			MouseClick,, adressBarPosX, adressBarPosY
			Send, !{ENTER}
			MouseMove, iEndPos_X, iEndPos_Y
		}
	}
	else if (gst="du")
	{
		if (szStartPos_WindowProcessName="firefox.exe") 
		{
			adressBarPosX:=iStartPos_WindowPosX+(iStarPos_WindowWidth/2)
			adressBarPosY:=iStartPos_WindowPosY+53

			MouseClick,, adressBarPosX, adressBarPosY
			Send, ^r
			Send, {F6}
			MouseMove, iEndPos_X, iEndPos_Y
		}
	}
	else if (gst)
	{
		traytip,Mouse_Gesture returns:,% gst
	}
return

Mouse_Gesture(Button="",dt=50,dv=0.140,ds=5,TabTime=100,SendButton=1,MinAvgSpeed=23,MinDistance=20)
{
	global mWheelUsed
	static u:=[0,0], tf:={"u":[-1,2,1],"d":[1,2,1],"l":[-1,1,2],"r":[1,1,2]}
	mousegetpos,x0,y0
	; tooltip, mousE: %x0%x %y0%y
	cnt:=0
	gesture:=""
	dx0:=x0
	dy0:=y0
	distance:=0
	MinDistance:=MinDistance*MinDistance
	speed:=0
	MinAvgSpeed:=MinAvgSpeed*MinAvgSpeed
	sl:=ceil(ds/(dv*dt))
	x00:=x0
	y00:=y0
	Button:=Button="" ? regexreplace(a_thishotkey,"\W") : Button
	
	while (GetKeyState(Button,"P"))
	{
		sleep,% dt
		if (mWheelUsed!=0) {
			return, 0
		}
		cnt++
		mousegetpos,x1,y1
		distance:=distance+abs(((x1-x0)**2)-((y1-y0)**2))
		speed:=speed+abs((x1-x0)**2-(y1-y0)**2)
		; tooltip, speed: %speed%
		u.1:=x1-x0, u.2:=y1-y0, x0:=x1, y0:=y1
		if (u.1**2+u.2**2>(dv*dt)**2)
		{
			for sct, p in tf
			{
				if (mWheelUsed!=0) {
					return, 0
				}
				if (p.1*u[p.2]>abs(u[p.3]))
				{
					gesture.=sct
					break
				}
			}
		}
	}

	if (mWheelUsed!=0) {
		return, 0
	}

	if (SendButton && cnt && distance<=MinDistance)
	{
		; tooltip, aborted distance: %distance% MinDistance: %MinDistance%
		;ToolTipTime("Mouse_Gesture: MinDistance not reached,MinDistance")
		send,% "{" Button "}"
		return, 0
	}

	avgSpeed:=speed/cnt
	; ToolTip, avgSpeed: %avgSpeed%
	if (SendButton && cnt && avgSpeed<=MinAvgSpeed)
	{
		; tooltip, aborted speed: %speed% MinAvgSpeed: %MinAvgSpeed%
		; traytip,Mouse_Gesture: MinAvgSpeed not reached,avgSpeed/min: %avgSpeed%/%MinAvgSpeed%
		send,% "{" Button "}"
		return, 0
	}

	
	if (SendButton && cnt && cnt*dt<=TabTime)
	{
		send,% "{" Button "}"
		return, 0
	}
		
	; mousemove,x00,y00,1
	return regexreplace(regexreplace(regexreplace(regexreplace(gesture, "(u{" sl ",}|d{" sl ",}|l{" sl ",}|r{" sl ",})","$T1"),"u|d|l|r"),"i)(u+|d+|l+|r+)","$T1"),"u|d|l|r")
}

IsWindowValid(winID) {
	global szIgnoreProcesses
	global szAllowProcesses

	WinGet, processName, ProcessName, ahk_id %winID%

	; white list
	whiteNeedle:=% "(" szAllowProcesses ")"
	if (RegExMatch(processName, whiteNeedle)>0){
		return true
	}

	; fullscreen check
	if (IsWindowFullScreen(winID)) {
		; ToolTipTime("not valid window (%processName%) (fullscreen)")
		return false
	}

	; black list
	blackNeedle:=% "(" szIgnoreProcesses ")"
	;msgbox, blackNeedle: %blackNeedle%
	if (RegExMatch(processName, blackNeedle)>0){
		; ToolTipTime("not valid window (%processName%) (blacklist)")
		return false
	}
	return true
}

IsWindowFullScreen(winID) {
	;checks if the specified window is full screen

	WinGet style, Style, ahk_id %WinID%
	WinGetPos,,,winW,winH, ahk_id %WinID%
	; 0x800000 is WS_BORDER.
	; 0x20000000 is WS_MINIMIZE.
	; no border and not minimized
	Return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}

ToolTipTime(Text, Time=2500) {
	MouseGetPos, x, y
	ToolTip, %Text%, x, y-20
	SetTimer, RemoveToolTip, %Time%
}

RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
return