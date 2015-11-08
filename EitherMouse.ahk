;——————————————————————————————————————————————————————————————————————————————————————
  Name    = EitherMouse
  Version =    0.5989
;——— Multiple mice, individual settings...
;—————— made by joel - aug'09 -> recently
;——————————————————————————————————————————————————————————————————————————————————————
Beta = 0
#NoEnv
#NoTrayIcon
;#ErrorStdout
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
Compile()
If A_ScriptName = %Name%_Update.exe
 GoSub, UpdateReplace
Instance("","-")
OnExit, OnExit

 GoSub, CreateMenus
 GoSub, Settings
 GoSub, CreateCursors
 GoSub, Hotkeys
 SetTimer, UpdateCheckQuiet, -8000
 GoSub, RegisterMice

Return

;F1::ReCompile()

;——————————————————————————————————————————————————————————————————————————————————————
Settings:
 RegRead, Button,		HKCU, Software\%Name%\Defaults, 	Button
 RegRead, Cursor,		HKCU, Software\%Name%\Defaults, 	Cursor
 RegRead, Speed,		HKCU, Software\%Name%\Defaults, 	Speed
 RegRead, Double,		HKCU, Software\%Name%\Defaults, 	Double
 RegRead, Wheel,		HKCU, Software\%Name%\Defaults, 	Wheel
 RegRead, Icon,	 		HKCU, Software\%Name%\Defaults, 	Icon
 RegRead, Epp,	 		HKCU, Software\%Name%\Defaults, 	Epp
 RegRead, MultiCursor, 		HKCU, Software\%Name%\MultiCursor, 	MultiCursor
 RegRead, MultiCursorTime, 	HKCU, Software\%Name%\MultiCursor, 	MultiCursorTime
 RegRead, MultiCursorTT, 	HKCU, Software\%Name%\MultiCursor, 	MultiCursorTT
 RegRead, Mouse0,		HKCU, Software\%Name%, 	MouseCount
 If (Button = "")
  RegRead, Button,     HKCU, Control Panel\Mouse, SwapMouseButtons
 Cursor 		:= (Cursor = "") 		? "7" : Cursor
 Speed 			:= (Speed = "") 		? GetMouseSpeed() : Speed
 Double 		:= (Double = "") 		? GetDouble() : Double
 Wheel 			:= (Wheel = "") 		? GetWheel() : Wheel
 Icon  			:= (Icon = "")  		? 1 : Icon
 Epp  			:= (Epp = "")  			? GetEpp() : Epp
 Nav  			:= (Nav = "")  			? 0 : Nav
 MultiCursor  		:= (MultiCursor = "")  		? 0 : MultiCursor
 MultiCursorTime  	:= (MultiCursorTime = "")  	? 60 : MultiCursorTime
 MultiCursorTT  	:= (MultiCursorTT = "")  	? 0 : MultiCursorTT
 Menu, Cursors, Check, % Cursor
 Loop, % Mouse0
 {
  RegRead, Mouse%A_Index%,        HKCU, Software\%Name%\Mouse%A_Index%, Name
  RegRead, Mouse%A_Index%Handle,  HKCU, Software\%Name%\Mouse%A_Index%, Handle
  RegRead, Mouse%A_Index%Nick,    HKCU, Software\%Name%\Mouse%A_Index%, Nick
  RegRead, Mouse%A_Index%Button,  HKCU, Software\%Name%\Mouse%A_Index%, Button
  RegRead, Mouse%A_Index%Cursor,  HKCU, Software\%Name%\Mouse%A_Index%, Cursor
  RegRead, Mouse%A_Index%Speed,   HKCU, Software\%Name%\Mouse%A_Index%, Speed
  RegRead, Mouse%A_Index%Nav,     HKCU, Software\%Name%\Mouse%A_Index%, Nav
  RegRead, Mouse%A_Index%Epp,     HKCU, Software\%Name%\Mouse%A_Index%, Epp
  RegRead, Mouse%A_Index%Double,  HKCU, Software\%Name%\Mouse%A_Index%, Double
  RegRead, Mouse%A_Index%Wheel,   HKCU, Software\%Name%\Mouse%A_Index%, Wheel
  RegRead, Mouse%A_Index%Icon,    HKCU, Software\%Name%\Mouse%A_Index%, Icon
  Mouse%A_Index%Speed  := (Mouse%A_Index%Speed = "")  ? Speed  : Mouse%A_Index%Speed
  Mouse%A_Index%Double := ((Mouse%A_Index%Double = 0) OR (Mouse%A_Index%Double = "")) ? Double : Mouse%A_Index%Double
  Mouse%A_Index%Wheel  := ((Mouse%A_Index%Wheel = 0) OR (Mouse%A_Index%Wheel = ""))  ? Wheel  : Mouse%A_Index%Wheel
  Mouse%A_Index%Epp    := (Mouse%A_Index%Epp = "")  ? Epp  : Mouse%A_Index%Epp
 }
 If MultiCursor
  Gdip_Startup()
 If Inverted
  hHookMouse := SetWindowsHookEx(14, RegisterCallback("WH_MOUSE_LL", "Fast"))
; If EnablePointerPrecision
; { 
;  getMouseParams(Threshold1,Threshold2,PointerPrecision)
;  setMouseParams(Threshold1,Threshold2,1)
; }
 Menu, Tray, Icon, % A_ScriptName, % Mouse1Icon
 Menu, Tray, Icon
 If Mouse0
  Return
 A_1 = %1%
 If (A_1 = "-silent") OR (A_1 = "/silent")
  Return
 WelcomeGui = 1
 Gui, 13:-ToolWindow -caption +border
 Gui  13:+LastFound
 Gui, 13:Add, Button,  x75 y190   w105  h30 Center vGuiCloseButton      AltSubmit gGuiClose ,  OK
 Gui, 13:Add, Picture, x246 y3   w11  h11  vGuiClose      AltSubmit gGuiClose Icon19,  %A_ScriptName%
 Gui, 13:Add, Text,    x-1 y-1 w270 h242 Center BackgroundTrans GuiMove
 Gui, 13:Add, Picture, x6 y8 w48 h48 Icon1 GuiMove, % A_ScriptName
 Gui, 13:Font, s16 w600 cBlack
 Gui, 13:Add, Text,    x15    y20 w238 h30 Center BackgroundTrans GuiMove vName, %Name%
 Gui, 13:Font, s10 w0
 Gui, 13:Add, Text,    x0   y63  w268 Center BackgroundTrans GuiMove vGuiDesc, % "Multiple mice, individual settings."
 Gui, 13:Font, s10 w600
 Gui, 13:Add, Text,    x0   y98  w268 Center BackgroundTrans GuiMove vGuiText, % "Move the " (Button?"left":"right") " mouse first..."
 Gui, 13:Font, s10 w0
 Gui, 13:Add, Text,    x0   y135 w268 Center BackgroundTrans GuiMove, % "Each mouse can be configured`nfrom the system tray once detected..."
 Gui, 13:Show, w260 h240, %Name% %Version%
 SetTimer, IconFlash, 500
Return
IconFlash:
 IconFlash := !IconFlash
 Menu, Tray, Icon, % A_ScriptName, % IconFlash + 1
Return
;——————————————————————————————————————————————————————————————————————————————————————
;=== Saving/Exiting... ================================================================
;——————————————————————————————————————————————————————————————————————————————————————
Save:
 GoSub, GuiClose
QuietSave:
 RegWrite, REG_SZ, HKCU, Software\%Name%\Defaults, Button, 		% Button
 RegWrite, REG_SZ, HKCU, Software\%Name%\Defaults, Cursor, 		% Cursor
 RegWrite, REG_SZ, HKCU, Software\%Name%\Defaults, Speed, 		% Speed
 RegWrite, REG_SZ, HKCU, Software\%Name%\Defaults, Double, 		% Double
 RegWrite, REG_SZ, HKCU, Software\%Name%\Defaults, Wheel, 		% Wheel
 RegWrite, REG_SZ, HKCU, Software\%Name%\Defaults, Icon, 		% Icon
 RegWrite, REG_SZ, HKCU, Software\%Name%\Defaults, Epp, 		% Epp
 RegWrite, REG_SZ, HKCU, Software\%Name%\MultiCursor, MultiCursor,	% MultiCursor
 RegWrite, REG_SZ, HKCU, Software\%Name%\MultiCursor, MultiCursorTime,	% MultiCursorTime
 RegWrite, REG_SZ, HKCU, Software\%Name%\MultiCursor, MultiCursorTT,	% MultiCursorTT
 RegWrite, REG_SZ, HKCU, Software\%Name%, MouseCount, 			% Mouse0
 Loop, % Mouse0
 {
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Name,   % Mouse%A_Index%
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Handle, % Mouse%A_Index%Handle
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Nick,   % Mouse%A_Index%Nick
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Button, % Mouse%A_Index%Button
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Cursor, % Mouse%A_Index%Cursor
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Speed,  % Mouse%A_Index%Speed
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Nav,    % Mouse%A_Index%Nav
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Epp,    % Mouse%A_Index%Epp
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Double, % Mouse%A_Index%Double
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Wheel,  % Mouse%A_Index%Wheel
  RegWrite, REG_SZ, HKCU, Software\%Name%\Mouse%A_Index%, Icon,   % Mouse%A_Index%Icon
 }
Return
OnExit:
 SwapMouseButtons(Button)
 SwapMouseCursors(0)
 SetMouseSpeed(Speed)
 SetEpp(Epp)
 SetDouble(Double)
 SetWheel(Wheel)
 Gdip_Shutdown(pToken)
 If Inverted
  UnhookWindowsHookEx(hHookMouse)
Exit:
ExitApp:
-ExitApp:
ExitApp
ClearReload:
 RegDelete, HKCU, Software\%Name%, MouseCount
 RegDelete, HKCU, Software\%Name%\Defaults
 RegDelete, HKCU, Software\%Name%\Mouse1
 RegDelete, HKCU, Software\%Name%\Mouse2
 RegDelete, HKCU, Software\%Name%\Mouse3
 RegDelete, HKCU, Software\%Name%\MultiCursor
Reload:
 Reload
DoNothing:
Return
;——————————————————————————————————————————————————————————————————————————————————————
;=== Device/Raw Input Sections ========================================================
;——————————————————————————————————————————————————————————————————————————————————————
RegisterMice:
 VarSetCapacity(dev, 12, 0)
 NumPut(1,      dev, 0, "UShort")
 NumPut(2,      dev, 2, "UShort")
 NumPut(0x100,  dev, 4)
 NumPut(A_ScriptHWnd, dev, 8)
 If (!DllCall("RegisterRawInputDevices",uint,&dev,uint,1,uint,12) or ErrorLevel)
 {
  Notify(Name " " Version,"Registering mouse`ndevices failed...",-60,"GC=ccccff IN=1 Image=" A_ScriptName)
  Return
 }
 ActiveMouse := LastActiveMouse := 1
 OnMessage(0xFF, "WM_INPUT")
 OnMessage(WM_EitherMouse:=DllCall("RegisterWindowMessage",Str,"EitherMouse"),"WM_EitherMouse")
Return
WM_INPUT(w,l)
{
 global
 Critical
 VarSetCapacity(raw, 40, 0)
  If (!DllCall("GetRawInputData",uint,l,uint,0x10000003,uint,&raw,"uint*",40,uint, 16) or ErrorLevel or !ThisMouse := NumGet(raw, 8))
   Return 0
 If (LastMouse <> ThisMouse)
  GoSub, MouseChange
 If MultiCursor && MultiCursorTT
  Loop, % Mouse0
   If (MouseName(ThisMouse) = Mouse%A_Index%)
    ToolTip, % Mouse%A_Index%Nick, , , %A_Index%
 Return 0
}
MouseChange:
 CoordMode, Mouse, Screen
 If MultiCursor
 {
  MouseGetPos, X, Y
  Mouse%ActiveMouse%X := X
  Mouse%ActiveMouse%Y := Y
 }
 LastMouse := ThisMouse
 Loop, % Mouse0
  If (MouseName(ThisMouse) = Mouse%A_Index%)
  {
   LastActiveMouse := ActiveMouse
   ActiveMouse := A_Index
   SwapMouseButtons(Mouse%A_Index%Button)
   SwapMouseCursors(Mouse%A_Index%Cursor)
   SetMouseSpeed(   Mouse%A_Index%Speed)
   SwapMouseNav(    Mouse%A_Index%Nav)
   SwapEpp(         Mouse%A_Index%Epp)
   SetDouble(       Mouse%A_Index%Double)
   SetWheel(        Mouse%A_Index%Wheel)
   SwapMouseIcon(   Mouse%A_Index%Icon)
   PostMessage, %WM_EitherMouse%,0,%ActiveMouse%,,ahk_id 0xFFFF
   If GuiShown
   {
    GuiControl,10:, MouseSpeed, % Mouse%A_Index%Speed
    GuiControl,10:, MouseSpeedT,     % "Mouse Speed: " Mouse%ActiveMouse%Speed
    GuiControl,10:, Wheel, % Mouse%A_Index%Wheel
    GuiControl,10:, WheelT, % "Scroll Wheel Speed: " Mouse%ActiveMouse%Wheel
    GuiControl,10:, Double, % Mouse%A_Index%Double
    GuiControl,10:, DoubleT,  % "Double Click Speed: " Mouse%ActiveMouse%Double
    GuiControl,10:, Nick, % Mouse%ActiveMouse%Nick
   }
   If (LastActiveMouse <> ActiveMouse) AND (MultiCursor)
   {
    If MultiCursorTT
    {
     ToolTip, , , , %ActiveMouse%
     ToolTip, % Mouse%LastActiveMouse%Nick, , , %LastActiveMouse%
    }
    MouseMove, Mouse%ActiveMouse%X, Mouse%ActiveMouse%Y, 0
   }
   If (LastActiveMouse <> ActiveMouse) AND (MultiCursor)
   {
    xx := Mouse%LastActiveMouse%X<>""?Mouse%LastActiveMouse%X:X
    yy := Mouse%LastActiveMouse%Y<>""?Mouse%LastActiveMouse%Y:Y
    If (Mouse%LastActiveMouse%Cursor)
    {
     hArrow_ := hArrow
     xx := xx - hArrowX ;32 + 1
     yy := yy - hArrowY ;32 + 1
     ii := 12
    }
    Else
    {
     hArrow_ := hArrowR
     xx := xx - hArrowRX ;32 + 1
     yy := yy - hArrowRY ;32 + 1
     ii := 13
    }
    Gui, %ActiveMouse%:Hide
    Gui, %LastActiveMouse%: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop +E0x20
    Gui, %LastActiveMouse%: Show, NA
    hwnd1 := WinExist()
    hbm := CreateDIBSection(32, 32)
    hdc := CreateCompatibleDC()
    obm := SelectObject(hdc, hbm)
    DllCall("DrawIcon", "Uint", hdc, "int", 0, "Int", 0, "Uint", hArrow_)
    UpdateLayeredWindow(hwnd1, hdc, 0, 0, 32, 32)
    Gui, %LastActiveMouse%:Show, NA x%xx% y%yy% w32 h32
    DeleteObject(hbm) ; Now the bitmap may be deleted
    DeleteDC(hdc)
    Gdip_DeleteGraphics(G)
    SetTimer, MultiCursorClose, % MultiCursorTime * (-1000)
   }
   Return
  }
 If !Mouse0
 {
  Mouse0++
  Mouse%Mouse0%           := MouseName(ThisMouse)
  Mouse%Mouse0%Handle     := ThisMouse
  Mouse%Mouse0%Nick       := "Mouse" Mouse0
  Mouse%Mouse0%Button     := Button?1:0
  Mouse%Mouse0%Cursor     := Button?1:0
  Mouse%Mouse0%Speed      := Speed
  Mouse%Mouse0%Nav        := 0
  Mouse%Mouse0%Epp        := Epp
  Mouse%Mouse0%Double     := Double
  Mouse%Mouse0%Wheel      := Wheel
  Mouse%Mouse0%Icon       := Button?1:7
  GuiControl, 13:, GuiText, % (Button?"Left":"Right") " mouse detected..."
 }
 Else If Mouse0 = 1
 {
  Mouse0++
  Mouse%Mouse0%           := MouseName(ThisMouse)
  Mouse%Mouse0%Handle     := ThisMouse
  Mouse%Mouse0%Nick       := "Mouse" Mouse0
  Mouse%Mouse0%Button     := Button?0:1
  Mouse%Mouse0%Cursor     := Button?0:1
  Mouse%Mouse0%Speed      := Speed
  Mouse%Mouse0%Nav        := 0
  Mouse%Mouse0%Epp        := Epp
  Mouse%Mouse0%Double     := Double
  Mouse%Mouse0%Wheel      := Wheel
  Mouse%Mouse0%Icon       := Button?7:1
  If WelcomeGui
   GuiControl, 13:, GuiText, % (Mouse%Mouse0%Button?"Left":"Right") " mouse detected..."
  Else
   Notify("New mouse detected!","Configured " (Mouse%Mouse0%Button?"left":"right") "-handed...", 10,"MS=10 GC=95CDFF IN=1 Image=" A_ScriptName)
 }
 Else
 {
  Mouse0++
  Mouse%Mouse0%           := MouseName(ThisMouse)
  Mouse%Mouse0%Handle     := ThisMouse
  Mouse%Mouse0%Nick       := "Mouse" Mouse0
  Mouse%Mouse0%Button     := Mouse%ActiveMouse%Button
  Mouse%Mouse0%Cursor     := Mouse%ActiveMouse%Cursor
  Mouse%Mouse0%Speed      := Speed
  Mouse%Mouse0%Nav        := 0
  Mouse%Mouse0%Epp        := Epp
  Mouse%Mouse0%Double     := Double
  Mouse%Mouse0%Wheel      := Wheel
  Mouse%Mouse0%Icon       := Mouse%ActiveMouse%Icon
  If WelcomeGui
   GuiControl, 13:, GuiText, % "New mouse configured " (Mouse%Mouse0%Button?"left":"right") "-handed..."
  Else
   Notify("New mouse detected!","Configured " (Mouse%Mouse0%Button?"left":"right") "-handed...", 10,"MS=10 GC=95CDFF IN=1 Image=" A_ScriptName)
 }
 GoSub, QuietSave
 SetTimer, MouseChange, -10
 SetTimer, GuiClose, -1200000
Return

WM_EitherMouse(W,L,M) {
 global ActiveMouse
 If (W = M)
  Return %ActiveMouse%
}

;——————————————————————————————————————————————————————————————————————————————————————
;=== Install/Settings Sections ========================================================
;——————————————————————————————————————————————————————————————————————————————————————
Install:
-Install:
 if not A_IsAdmin
 {
  Run *RunAs "%A_ScriptFullPath%" -Install
  ExitApp
 }
 FileCreateDir, %ProgramFiles%\%Name%
 FileCopy, %A_ScriptFullPath%, %ProgramFiles%\%Name%\%Name%.exe, 1
 If ErrorLevel = 0
 {
  FileCreateDir, %A_ProgramsCommon%\%Name%
  FileCreateShortcut, %ProgramFiles%\%Name%\%Name%.exe, %A_ProgramsCommon%\%Name%\%Name%.lnk
  IfExist, %A_Startup%\%Name%.lnk
  {
   FileDelete, %A_Startup%\%Name%.lnk
   FileCreateShortcut, %ProgramFiles%\%Name%\%Name%, %A_Startup%\%Name%.lnk
  }
  Run, %ProgramFiles%\%Name%\%A_ScriptName%
  Run, %ProgramFiles%\%Name%\
  ExitApp
 }
Return

-UnInstall:
 MsgBox, 68, %Name%, Do you really want to uninstall %Name% from:`n%A_ScriptDir%
 IfMsgBox, No
  ExitApp
-UnInstallsilent:
 RegRead, InstallPath,		HKLM, Software\Microsoft\Windows\CurrentVersion\Uninstall\%Name%, 	InstallLocation
 StringReplace, InstallPath, InstallPath, `",, All
 If (InstallPath <> A_ScriptDir)
 {
  MsgBox, Installed path doesn't match current path... canceling
  ExitApp
 }
 if not A_IsAdmin
 {
  Run *RunAs "%A_ScriptFullPath%" -UninstallSilent
  ExitApp
 }
 DetectHiddenWindows, On
 myPID:=DllCall("GetCurrentProcessId")
 WinGet, List, List, ahk_exe %A_ScriptFullPath%
 Loop %List% 
  { 
    WinGet, PID, PID, % "ahk_id " List%A_Index% 
    If (PID <> myPID)
     PostMessage,0x111,65405,0,, % "ahk_id " List%A_Index% 
  }
 FileDelete, %A_ScriptDir%\*.ahk
 FileDelete, %A_ScriptDir%\%Name% Setup.exe
 FileDelete, %A_ScriptDir%\%Name%.exe
 FileRemoveDir, %A_ScriptDir%\Resources\, 1
 FileRemoveDir, %A_ProgramsCommon%\%Name%\, 1
 FileDelete, %A_Startup%\%Name%.lnk
 RegDelete, HKLM, Software\Microsoft\Windows\CurrentVersion\Uninstall\%Name%
 RegDelete, HKCU, Software\%Name%
 Run %ComSpec% /c "
 (Join`s&`s
 ping localhost -n 2 > nul
 del "%A_ScriptFullPath%"
 cd "%A_Temp%"
 ping localhost -n 2 > nul
 rmdir "%A_ScriptDir%"
 )",, Hide
ExitApp





ToggleStartup:
 IfExist, %A_Startup%\%Name%.lnk
 {
  FileDelete, %A_Startup%\%Name%.lnk
  Menu, Configure, Uncheck, Start with Windows...
;  GuiControl,10:, AutoStart, 0
 }
 Else
 {
  FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%Name%.lnk, %A_ScriptDir%
  Menu, Configure, Check, Start with Windows...
;  GuiControl,10:, AutoStart, 1
 }
Return
;——————————————————————————————————————————————————————————————————————————————————————
;——————————————————————————————————————————————————————————————————————————————————————
Hotkeys:
 Hotkey, XButton1, XButton2, Off
 Hotkey, XButton2, XButton1, Off
Return
;——————————————————————————————————————————————————————————————————————————————————————
ToggleMultiCursor:
 MultiCursor := !MultiCursor
 If MultiCursor
 {
  GuiControl,10:, MultiCursor, 1
  GuiControl,10:Enable,MultiCursorTT
  GuiControl,10:Enable,MultiCursorTime
  GuiControl,10:Enable,MultiCursorTimeT
  Gdip_Startup()  
 }
 Else
 {
  GuiControl,10:, MultiCursor, 0
  GoSub, MultiCursorClose
  GuiControl,10:Disable,MultiCursorTT
  GuiControl,10:Disable,MultiCursorTime
  GuiControl,10:Disable,MultiCursorTimeT
  Gdip_Shutdown(pToken)
 }
 GoSub, QuietSave
Return

ToggleMultiCursorTT:
 MultiCursorTT := !MultiCursorTT
 If MultiCursorTT
  GuiControl,10:, MultiCursorTT, 1
 Else
 {
  GuiControl,10:, MultiCursorTT, 0
  GoSub, MultiCursorClose
 }
 GoSub, QuietSave
Return

MultiCursorClose:
 Loop, %Mouse0%
 {
  Gui, %A_Index%:Hide
  ToolTip, , , , %A_Index%
 }
Return
;——————————————————————————————————————————————————————————————————————————————————————
MouseSettings:
 GoSub, MenuClose
 SwapMouseButtons(Button)
 SwapMouseCursors(0)
 SetMouseSpeed(Speed)
 SetDouble(Double)
 SetEpp(Epp)
 SetWheel(Wheel)
 Gdip_Shutdown(pToken)
 If Inverted
  UnhookWindowsHookEx(hHookMouse)
 Notify(Name " " Version, Name " will restart when`nMouse Properties is closed...", 6000,"GC=bbbbff IN=1 Image=" A_ScriptName)
 Run, control mouse
 WinWait, Mouse Properties
 WinWaitClose
 GoSub, ClearReload
Return
;——————————————————————————————————————————————————————————————————————————————————————
;ExtractSource:
; Instance("-Source")
;Return
;-Source:
; FileInstall, EitherMouse.ahk, EitherMouse.ahk, 1
; FileInstall, EitherMouse Setup.ahk, EitherMouse Setup.ahk, 1
; Run, %A_ScriptDir%
; If A_AhkPath =
; {
;  MsgBox, 52, EitherMouse, Install AutoHotkey?
;  IfMsgBox, Yes
;  {
;   UrlDownloadToFile, http://ahkscript.org/download/ahk-install.exe, ahk-install.exe
;   RunWait, ahk-install.exe /S
;  }
; }
; Notify(Name " " Version, "Source extracted...", -5,"GC=bbbbff IN=1 Image=" A_ScriptName)
;Return
;——————————————————————————————————————————————————————————————————————————————————————
;=== Cursors ==========================================================================
;——————————————————————————————————————————————————————————————————————————————————————
Cursors7:
 Cursor=7
 Menu, Cursors, Check, 7
 Menu, Cursors, Uncheck, XP
 Menu, Cursors, Uncheck, ExtraLarge
 Menu, Cursors, Uncheck, Large
 GoSub, CreateCursors
 GoSub, MouseChange
 GoSub, QuietSave
Return
CursorsXP:
 Cursor=XP
 Menu, Cursors, Check, XP
 Menu, Cursors, Uncheck, 7
 Menu, Cursors, Uncheck, ExtraLarge
 Menu, Cursors, Uncheck, Large
 GoSub, CreateCursors
 GoSub, MouseChange
 GoSub, QuietSave
Return
CursorsLarge:
 Cursor=Large
 Menu, Cursors, Check, Large
 Menu, Cursors, Uncheck, 7
 Menu, Cursors, Uncheck, XP
 Menu, Cursors, Uncheck, ExtraLarge
 GoSub, CreateCursors
 GoSub, MouseChange
 GoSub, QuietSave
Return
CursorsExtraLarge:
 Cursor=ExtraLarge
 Menu, Cursors, Check, ExtraLarge
 Menu, Cursors, Uncheck, 7
 Menu, Cursors, Uncheck, Large
 Menu, Cursors, Uncheck, XP
 GoSub, CreateCursors
 GoSub, MouseChange
 GoSub, QuietSave
Return
CreateCursors:
 hModule := DllCall("GetModuleHandle", Str, A_ScriptFullPath)
 VarSetCapacity(IconInfoStruct, 17, 0)
 If Cursor = XP
 {
  str=ARROWXP
  hArrow  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hArrow, "Uint", &IconInfoStruct)
  hArrowX := NumGet(IconInfoStruct, 4)
  hArrowY := NumGet(IconInfoStruct, 8)
  str=ARROWRXP
  hArrowR  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hArrowR, "Uint", &IconInfoStruct)
  hArrowRX := NumGet(IconInfoStruct, 4)
  hArrowRY := NumGet(IconInfoStruct, 8)
  str=STARTXP
  hStart  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hStart, "Uint", &IconInfoStruct)
  hStartX := NumGet(IconInfoStruct, 4)
  hStartY := NumGet(IconInfoStruct, 8)
  str=HANDXP
  hHand  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hHand, "Uint", &IconInfoStruct)
  hHandX := NumGet(IconInfoStruct, 4)
  hHandY := NumGet(IconInfoStruct, 8)
  str=HELPXP
  hHelp  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hHelp, "Uint", &IconInfoStruct)
  hHelpX := NumGet(IconInfoStruct, 4)
  hHelpY := NumGet(IconInfoStruct, 8)
 }
 Else If Cursor = Large
 {
  str=ARROWL
  hArrow  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hArrow, "Uint", &IconInfoStruct)
  hArrowX := NumGet(IconInfoStruct, 4)
  hArrowY := NumGet(IconInfoStruct, 8)
  str=ARROWR7
  hArrowR  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hArrowR, "Uint", &IconInfoStruct)
  hArrowRX := NumGet(IconInfoStruct, 4)
  hArrowRY := NumGet(IconInfoStruct, 8)
  str=STARTL
  hStart  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hStart, "Uint", &IconInfoStruct)
  hStartX := NumGet(IconInfoStruct, 4)
  hStartY := NumGet(IconInfoStruct, 8)
  str=HANDL
  hHand  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hHand, "Uint", &IconInfoStruct)
  hHandX := NumGet(IconInfoStruct, 4)
  hHandY := NumGet(IconInfoStruct, 8)
  str=HELPL
  hHelp  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hHelp, "Uint", &IconInfoStruct)
  hHelpX := NumGet(IconInfoStruct, 4)
  hHelpY := NumGet(IconInfoStruct, 8)
 }
 Else If Cursor = ExtraLarge
 {
  str=ARROWXL
  hArrow  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hArrow, "Uint", &IconInfoStruct)
  hArrowX := NumGet(IconInfoStruct, 4)
  hArrowY := NumGet(IconInfoStruct, 8)
  str=ARROWR7
  hArrowR  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hArrowR, "Uint", &IconInfoStruct)
  hArrowRX := NumGet(IconInfoStruct, 4)
  hArrowRY := NumGet(IconInfoStruct, 8)
  str=STARTXL
  hStart  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hStart, "Uint", &IconInfoStruct)
  hStartX := NumGet(IconInfoStruct, 4)
  hStartY := NumGet(IconInfoStruct, 8)
  str=HANDXL
  hHand  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hHand, "Uint", &IconInfoStruct)
  hHandX := NumGet(IconInfoStruct, 4)
  hHandY := NumGet(IconInfoStruct, 8)
  str=HELPXL
  hHelp  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hHelp, "Uint", &IconInfoStruct)
  hHelpX := NumGet(IconInfoStruct, 4)
  hHelpY := NumGet(IconInfoStruct, 8)
 }
 Else
 {
  str=ARROW7
  hArrow  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hArrow, "Uint", &IconInfoStruct)
  hArrowX := NumGet(IconInfoStruct, 4)
  hArrowY := NumGet(IconInfoStruct, 8)
  str=ARROWR7
  hArrowR  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hArrowR, "Uint", &IconInfoStruct)
  hArrowRX := NumGet(IconInfoStruct, 4)
  hArrowRY := NumGet(IconInfoStruct, 8)
  str=START7
  hStart  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hStart, "Uint", &IconInfoStruct)
  hStartX := NumGet(IconInfoStruct, 4)
  hStartY := NumGet(IconInfoStruct, 8)
  str=HAND7
  hHand  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hHand, "Uint", &IconInfoStruct)
  hHandX := NumGet(IconInfoStruct, 4)
  hHandY := NumGet(IconInfoStruct, 8)
  str=HELP7
  hHelp  := DllCall( "LoadCursor", Uint,hModule, Int, &str )
  DllCall("GetIconInfo", "Uint", hHelp, "Uint", &IconInfoStruct)
  hHelpX := NumGet(IconInfoStruct, 4)
  hHelpY := NumGet(IconInfoStruct, 8)
 }
Return
;——————————————————————————————————————————————————————————————————————————————————————
;=== Tray/Menu Sections ===============================================================
;——————————————————————————————————————————————————————————————————————————————————————

SelectIcon:
 If A_ThisMenuItem = Logo
  SelectIcon0 := 7, SelectIcon1 := 1
 Else If A_ThisMenuItem = Mouse
  SelectIcon0 := 9, SelectIcon1 := 8
 Else If A_ThisMenuItem = Blue Arrow
  SelectIcon0 := 3, SelectIcon1 := 2
 Else If A_ThisMenuItem = Red Arrow
  SelectIcon0 := 5, SelectIcon1 := 4
; Else If A_ThisMenuItem = Cursor
;  SelectIcon0 := 11, SelectIcon1 := 10

 Loop, %Mouse0%
 {
  If A_ThisMenuItem = Cursor
   If Mouse%A_Index%Cursor = 0
    Mouse%A_Index%Icon := 11
   Else
    Mouse%A_Index%Icon := 10
  Else
   If Mouse%A_Index%Button = 0
    Mouse%A_Index%Icon := SelectIcon0
   Else
    Mouse%A_Index%Icon := SelectIcon1
 }

 SwapMouseIcon(Mouse%ActiveMouse%Icon)
 GoSub, QuietSave  
Return

CreateMenus:
 Menu, Tray, NoStandard
; Menu, Tray, Icon, % A_ScriptName, 1
; Menu, Tray, Icon
 Menu, Cursors, Add, 7, Cursors7
 Menu, Cursors, Add, XP, CursorsXP
 Menu, Cursors, Add, Large, CursorsLarge
 Menu, Cursors, Add, ExtraLarge, CursorsExtraLarge
 If Beta
 {
  Menu, Cursors, Add
  Menu, Cursors, Add, Load..., DoNothing
 }
 Menu, Icons, Add, Logo, SelectIcon
 Menu, Icons, Default, Logo
 Menu, Icons, Add, Mouse, SelectIcon
 Menu, Icons, Add, Cursor, SelectIcon
 Menu, Icons, Add, Blue Arrow, SelectIcon
 Menu, Icons, Add, Red Arrow, SelectIcon
 If Beta
 {
  Menu, Icons, Add
  Menu, Icons, Add, Load..., DoNothing
  Menu, Icons, Add, None..., DoNothing
 }
 Menu, Icons, Icon, Logo, %A_ScriptName%,1,16
 Menu, Icons, Icon, Mouse, %A_ScriptName%,8,16
 Menu, Icons, Icon, Cursor, %A_ScriptName%,10,16
 Menu, Icons, Icon, Blue Arrow, %A_ScriptName%,2,16
 Menu, Icons, Icon, Red Arrow, %A_ScriptName%,4,16
 Menu, Configure, Add, Start with Windows..., ToggleStartup
 Menu, Configure, Add, Cursors:, :Cursors
 Menu, Configure, Add, Tray Icon:, :Icons
 Menu, Configure, Add
 If Beta
  Menu, Configure, Add, Hotkeys..., HotkeyGuiShow

 Menu, Updates, Add, Automatically update..., DoNothing
 Menu, Updates, Add, Check for updates..., DoNothing
 Menu, Updates, Check, Check for updates...
 Menu, Updates, Add, Never check for updates..., DoNothing
 Menu, Updates, Add
 Menu, Updates, Add, Check for an update now..., UpdateCheck
 Menu, Updates, Add, Force an update now..., UpdateNow
 Menu, Updates, Add, Download latest Installer..., UpdateInstaller

If Beta
 Menu, Configure, Add, Updates:, :Updates

; If (A_ScriptDir <> A_ProgramFiles "\" Name)
;  Menu, Configure, Add, Install to Program Files..., Install
 Menu, Configure, Add, Mouse Control Panel..., MouseSettings
 Menu, Configure, Add, Clear all settings..., ClearReload
 Menu, Configure, Add
 Menu, Configure, Add, About..., About
; Menu, Configure, Add
; Menu, Configure, Add, Restart..., Reload
 Menu, Configure, Add, Exit, ExitApp
 If (Beta)
  Menu, Tray, Tip, % " " Name " " Version " Beta "
 Else
  Menu, Tray, Tip, % " " Name " " Version " "
 OnMessage(0x404, "TrayClick")
Return
;——————————————————————————————————————————————————————————————————————————————————————
SpeedHandler:
 GuiControlGet, _, 10:, MouseSpeed
 If (_ = Mouse%ActiveMouse%Speed)
  Return
 Mouse%ActiveMouse%Speed := _
 SetMouseSpeed(_)
 GuiControl,10:, MouseSpeedT,     % "Mouse Speed: " Mouse%ActiveMouse%Speed
 GoSub, QuietSave
Return
QuickButton:
 SwapMouseButtons(Mouse%ActiveMouse%Button := !Mouse%ActiveMouse%Button)
 If (Mouse%ActiveMouse%Icon = 1) OR (Mouse%ActiveMouse%Icon = 7)
  Mouse%ActiveMouse%Icon := Mouse%ActiveMouse%Button?1:7
 SwapMouseIcon(Mouse%ActiveMouse%Icon)
 GuiControl, 10:, ButtonCB, % Mouse%ActiveMouse%Button
 GoSub, QuietSave
Return
QuickCursor:
 SwapMouseCursors(Mouse%ActiveMouse%Cursor := !Mouse%ActiveMouse%Cursor)
 GuiControl, 10:, CursorCB, % Mouse%ActiveMouse%Cursor
 GoSub, QuietSave
Return
QuickNav:
 SwapMouseNav(Mouse%ActiveMouse%Nav := !Mouse%ActiveMouse%Nav)
 GuiControl, 10:, NavCB, % Mouse%ActiveMouse%Nav
 GoSub, QuietSave
Return
QuickEpp:
 SwapEpp(Mouse%ActiveMouse%Epp := !Mouse%ActiveMouse%Epp)
 GuiControl, 10:, EppCB, % Mouse%ActiveMouse%Epp
 GoSub, QuietSave
Return
;——————————————————————————————————————————————————————————————————————————————————————
ShowMenu_:
 Menu, Configure, Show 
Return
ShowMenu:
 CoordMode, Mouse, Screen
 MouseGetPos, X_, Y_
 If WelcomeGui
  GoSub, GUiClose
 GuiShown=1
 GuiCreated=1
 Gui, 10:+ToolWindow -Caption +Border +LabelMain
 Gui, 10:+LastFound
 Winset, AlwaysOnTop
 Gui, 10:Color, White
 Gui, 10:Add, CheckBox, 		x20  y71  w160 h20 vMultiCursor gMainContextMenu, Multi-Cursor
 If MultiCursor
  Disabled =
 Else
  Disabled = Disabled
 SliderThick := "Thick" 15*checkDPIsize()
 Gui, 10:Add, CheckBox,	x30  y94  w60  h20 %Disabled% vMultiCursorTT gMainContextMenu, ToolTip
 Gui, 10:Add, Text, 	x132 y96  w50  h20 %Disabled% vMultiCursorTimeT , Timeout
 Gui, 10:Add, Edit, 	x90  y95  w40  h20 %Disabled% +Center vMultiCursorTime gMultiCursorTimeHandler, % MultiCursorTime
 Gui, 10:Add, UpDown, 	        	  w20 h20 Range0-300, % MultiCursorTime

 Gui, 10:Add, Edit,     x75  y140 w90  h17  vNick   gNickHandler , % Mouse%ActiveMouse%Nick
 Gui, 10:Add, CheckBox, x35  y165 w145 h20  vButtonCB  gMainContextMenu, Swap Mouse Buttons
 Gui, 10:Add, Picture, 	x13  y166 w16  h16  vButtonPic Icon9 gMainContextMenu, %A_ScriptName%
 Gui, 10:Add, CheckBox, x35  y192 w145 h20  vCursorCB  gMainContextMenu, Mirror Cursors
 Gui, 10:Add, Picture, 	x13  y193 w16  h16  vCursorPic Icon11 gMainContextMenu, %A_ScriptName%
 Gui, 10:Add, CheckBox, x35  y219 w145 h20  vNavCB  gMainContextMenu, Swap Navigation Buttons
 Gui, 10:Add, Picture, 	x13  y220 w16  h16  vNavPic Icon13 gMainContextMenu, %A_ScriptName%

 Gui, 10:Add, Picture, 	x13  y253 w16  h16  vMouseSpeedPic Icon16  gDoNothing, %A_ScriptName%
 Gui, 10:Add, Text, 	x51  y248 w130 R1  vMouseSpeedT   BackgroundTrans  gDoNothing    , % "Mouse Speed: " Mouse%ActiveMouse%Speed
 Gui, 10:Add, Slider, 	x28  y261 w155 h18   vMouseSpeed    %SliderThick% BackgroundTrans +Center Range1-20 Page3 NoTicks AltSubmit gSpeedHandler 0x400, % Mouse%ActiveMouse%Speed
 Gui, 10:Font, s8, Arial Narrow
 Gui, 10:Add, CheckBox, x35  y279 w145 R1   vEppCB  gMainContextMenu BackgroundTrans, Enhance Pointer Precision
 Gui, 10:Font

 Gui, 10:Add, Picture, 	x13  y315 w16  h16  vDoublePic Icon17   gDoNothing, %A_ScriptName%
 Gui, 10:Add, Text, 	x51  y310 w130 R1   vDoubleT BackgroundTrans  gDoNothing	   ,  % "Double Click Speed: " Mouse%ActiveMouse%Double
 Gui, 10:Add, Slider, 	x28  y323 w155 h18  vDouble  %SliderThick% BackgroundTrans +Center Range50-900 Page50 NoTicks AltSubmit gDoubleHandler 0x400, % Mouse%ActiveMouse%Double

 Gui, 10:Add, Picture, 	x13  y352 w16  h16  vWheelPic Icon18  gDoNothing  , %A_ScriptName%
 Gui, 10:Add, Text, 	x51  y347 w130 R1   vWheelT BackgroundTrans  gDoNothing   ,    % "Scroll Wheel Speed: " Mouse%ActiveMouse%Wheel
 Gui, 10:Add, Slider, 	x28  y360 w155 h18  vWheel  %SliderThick% BackgroundTrans +Center Range0-20 Page3 NoTicks AltSubmit gWheelHandler 0x400, % Mouse%ActiveMouse%Wheel

 If Beta
 {
  Gui, 10:Add, Picture, x168 y52  w11  h11  vGuiMoreConfig AltSubmit gGuiMore Icon25,  %A_ScriptName%
  Gui, 10:Add, Picture, x168 y142 w11  h11  vGuiMore       AltSubmit gGuiMore Icon25,  %A_ScriptName%
 }
 Gui, 10:Add, GroupBox, x6   y51  w179 h75  vGroupConfig  +0x4000000, Configure:
 Gui, 10:Add, GroupBox, x6   y141 w179 h245 vGroupSettings +0x4000000, % "Settings of:                                 " ;" Mouse%ActiveMouse%Nick "   "

 Gui, 10:Add, Picture,  x4   y2   w48  h48  vName___ Icon1  gShowMenu_ , %A_ScriptName%
 Gui, 10:Font, s12 w800
 Gui, 10:Add, Text,     x60  y17  w110 h20  vName__ +Center BackgroundTrans guiMove, %Name%
 Gui, 10:Add, Picture,  x148 y3   w11  h11  vGuiGear gShowMenu_ Icon21,  %A_ScriptName%
 Gui, 10:Add, Picture,  x162 y3   w11  h11  vGuiHelp gGuiHelp Icon20,  %A_ScriptName%
 Gui, 10:Add, Picture,  x176 y3   w11  h11  vGuiClose      AltSubmit gMenuClose Icon19,  %A_ScriptName%
 XXX := 190*checkDPIsize()
 YYY := 395*checkDPIsize()
 If (X_ >= XXX)
  X_ -= XXX
 If (Y_ >= YYY)
  Y_ -= YYY
 GoSub, MouseChange
 If MultiCursor
  GuiControl,10:, MultiCursor, 1
 If MultiCursorTT
  GuiControl,10:, MultiCursorTT, 1
 IfExist, %A_Startup%\%Name%.lnk
  Menu, Configure, Check, Start with windows...
 OnMessage(0x200, "ContextHelp")
 Gui, 10:Show, x%X_% y%Y_% w190 h395, %Name%
; DllCall("AnimateWindow","UInt",WinExist(),"Int",250,"UInt","0x000a0000")
; Gui, 10:Show

 WinWaitNotActive ;————————————————————————————————————————————————————————————————————
;——————————————————————————————————————————————————————————————————————————————————————
MenuClose:
 If GuiHelp
  GoSub, GuiHelp
 OnMessage(0x200, "")
; DllCall("AnimateWindow","UInt",WinExist(),"Int",250,"UInt","0x00090000")
 Gui, 10:Destroy
 GuiShown=0
Return
;——————————————————————————————————————————————————————————————————————————————————————
GuiMore:
 GuiMore := !GuiMore
 If GuiMore
 {
  X_t := X_ - 100
  If (X_t <= 0)
   X_t := X_
  GuiControl, Move, GroupConfig, x6   y51  w279 ;h75
  GuiControl, Move, GroupSettings, x6   y141 w279 ;h224
  GuiControl, Move, GuiMoreConfig, x268 y52 ;w11 h11
  GuiControl, Move, GuiMore, x268 y142 ;w11 h11
  GuiControl, Move, GuiGear, x248 y3 ;w11 h11
  GuiControl, Move, GuiHelp,  x262 y3 ;w11 h11
  GuiControl, Move, GuiClose, x276 y3 ;w11 h11
  Gui, 10:Show, x%X_t% y%Y_% w290, %Name%
 }
 Else
 {
  GuiControl, Move, GroupConfig, x6   y51  w179 ;h75
  GuiControl, Move, GroupSettings, x6   y141 w179 ;h224
  GuiControl, Move, GuiMoreConfig, x168 y52 ;w11 h11
  GuiControl, Move, GuiMore, x168 y142 ;w11 h11
  GuiControl, Move, GuiGear, x148 y3 ;w11 h11
  GuiControl, Move, GuiHelp,  x162 y3 ;w11 h11
  GuiControl, Move, GuiClose, x176 y3 ;w11 h11
  Gui, 10:Show, x%X_% y%Y_% w190, %Name%
 }
Return
;——————————————————————————————————————————————————————————————————————————————————————
GuiHelp:
; CoordMode, ToolTip, Screen
 GuiHelp := !GuiHelp
 If GuiHelp
 {
  ToolTip, % Help, 195,,20
  Gui, 15:-Caption -Border +AlwaysOnTop +ToolWindow +E0x20
  Gui, 15:Color, Red
  Gui 15:+LastFound
  Gui 15:Default
  Winset, Transparent, 128
  Gui, 15:Show, HIDE, %Name% Help...
 }
 Else
 {
  ToolTip, % "", 195,,20
  Gui, 15:Destroy
 }
Return
;——————————————————————————————————————————————————————————————————————————————————————
ContextHelp(wParam, lParam, Msg) {
 global
 static last
 If InStr(A_GuiControl,"Close")
 {
  Help = Close this window.
  If !GuiCloseRed
   GuiControl, 10:, GuiClose, *Icon22 %A_ScriptName%
  GuiCloseRed=1
  If (GuiHelpRed) AND !GuiHelp
   GuiControl, 10:, GuiHelp, *Icon20 %A_ScriptName%
  GuiHelpRed=0
  If GuiGearRed
   GuiControl, 10:, GuiGear, *Icon21 %A_ScriptName%
  GuiGearRed=0
 }
 Else If InStr(A_GuiControl,"Help")
 {
  Help = Hover over an`nitem for help.
  If !GuiHelpRed
   GuiControl, 10:, GuiHelp, *Icon23 %A_ScriptName%
   GuiHelpRed=1
  If GuiCloseRed
   GuiControl, 10:, GuiClose, *Icon19 %A_ScriptName%
  GuiCloseRed=0
  If GuiGearRed
   GuiControl, 10:, GuiGear, *Icon21 %A_ScriptName%
  GuiGearRed=0
 }
 Else If InStr(A_GuiControl,"Gear")
 {
  Help = Configuration...
  If !GuiGearRed
   GuiControl, 10:, GuiGear, *Icon24 %A_ScriptName%
   GuiGearRed=1
  If GuiCloseRed
   GuiControl, 10:, GuiClose, *Icon19 %A_ScriptName%
  GuiCloseRed=0
  If (GuiHelpRed) AND !GuiHelp
   GuiControl, 10:, GuiHelp, *Icon20 %A_ScriptName%
  GuiHelpRed=0
 }
 Else If InStr(A_GuiControl,"MoreConfig")
 {
  Help = More settings...
  If !GuiMoreConfigRed
   GuiControl, 10:, GuiMoreConfig, *Icon26 %A_ScriptName%
  GuiMoreConfigRed=1
 }
 Else If InStr(A_GuiControl,"More")
 {
  Help = More settings...
  If !GuiMoreRed
   GuiControl, 10:, GuiMore, *Icon26 %A_ScriptName%
  GuiMoreRed=1
 }
 If A_GuiControl =
 {
  If GuiCloseRed
   GuiControl, 10:, GuiClose, *Icon19 %A_ScriptName%
  GuiCloseRed=0
  If (GuiHelpRed) AND !GuiHelp
   GuiControl, 10:, GuiHelp, *Icon20 %A_ScriptName%
  GuiHelpRed=0
  If GuiGearRed
   GuiControl, 10:, GuiGear, *Icon21 %A_ScriptName%
  GuiGearRed=0
  If GuiMoreRed ;AND !GuiMore
   GuiControl, 10:, GuiMore, *Icon25 %A_ScriptName%
  GuiMoreRed=0
  If GuiMoreConfigRed ;AND !GuiMore
   GuiControl, 10:, GuiMoreConfig, *Icon25 %A_ScriptName%
  GuiMoreConfigRed=0
 }
 If !GuiHelp
  Return

 If InStr(A_GuiControl,"Button")
  Help = Swap primary and`nsecondary mouse`nbuttons.
 Else If InStr(A_GuiControl,"Name")
  Help = %Name%`nmade by joel
 Else If InStr(A_GuiControl,"Multi")
  Help = MultiCursor mode`nkeeps the mouse`nposition and cursor`nseperate for each`nmouse.
 Else If InStr(A_GuiControl,"Cursor")
  Help = Makes the cursors`nmirrored.`n`nHelps to identify`nsettings...
 Else If InStr(A_GuiControl,"Speed")
  Help = Sets the speed of`nthe mouse.`n`nDefault is 5.`n1 is slowest, 20 is fastest.
 Else If InStr(A_GuiControl,"Wheel")
  Help = Controls the number`nof lines per scroll`nwheel click.`n`nDefault is 3 lines.
 Else If InStr(A_GuiControl,"Double")
  Help = Sets the time between`nclicks to be considered`na "double-click".`n`nDefault is 500 milliseconds.
 Else If InStr(A_GuiControl,"Nick")
  Help = Allows you to`nname each device`nfor easier differentiation.
 Else If InStr(A_GuiControl,"Nav")
  Help = Swap the Back/Forward`nnavigation buttons.`n`nUseful when they are`none on each side of a mouse.
  MouseGetPos, , MouseY
 ToolTip, % Help, 195,% MouseY-20,20
 If (last <> A_GuiControl) AND (A_GuiControl <> "")
 {
  _:=A_GuiControl
  GuiControlGet, %_%, Pos
  %_%X := X_
  %_%Y += Y_ - 5
  %_%H += 10
  W_ := 192
  Gui, 15:Show, % "NA x" %_%X " y" %_%Y " w" W_ " h" %_%H
 }
 last := A_GuiControl
}
;——————————————————————————————————————————————————————————————————————————————————————
checkDPIsize()
{
RegRead, DPI_value, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
if errorlevel=1 ; the reg key was not found - it means default settings
   return 1
if DPI_value=96 ; 96 is the default font size setting
   return 1
if DPI_value>96 ; A higher value should mean LARGE font size setting
   return Round(DPI_value/96,2)
}
;——————————————————————————————————————————————————————————————————————————————————————
MainContextMenu:
 If (A_GuiControl = "ButtonPic") OR (A_GuiControl = "ButtonCB")
  GoSub, QuickButton
 Else If (A_GuiControl = "CursorPic") OR (A_GuiControl = "CursorCB")
  GoSub, QuickCursor
 Else If (A_GuiControl = "EppPic") OR (A_GuiControl = "EppCB")
  GoSub, QuickEpp
 Else If (A_GuiControl = "Cursor7")
  GoSub, Cursors7
 Else If (A_GuiControl = "CursorXP")
  GoSub, CursorsXP
 Else If (A_GuiControl = "AutoStart")
  GoSub, ToggleStartup
 Else If (A_GuiControl = "MultiCursor")
  GoSub, ToggleMultiCursor
 Else If (A_GuiControl = "MultiCursorTT")
  GoSub, ToggleMultiCursorTT
 Else If (A_GuiControl = "NavPic") OR  (A_GuiControl = "NavCB")
  GoSub, QuickNav
 Else If (A_GuiControl = "Name___") OR (A_GuiControl = "GuiGear")
  GoSub, ShowMenu_
 Else If (A_GuiControl = "GuiHelp")
  GoSub, GuiHelp
 Else If (A_GuiControl = "GuiClose")
  GoSub, MenuClose
Return
MultiCursorTimeHandler:
 GuiControlGet, _, 10:, MultiCursorTime
 If (_ = MultiCursorTime)
  Return
 MultiCursorTime := _
 GoSub, QuietSave
Return
NickHandler:
 GuiControlGet, _, 10:, Nick
 If _ = (Mouse%ActiveMouse%Nick)
  Return
 Mouse%ActiveMouse%Nick := _
 GoSub, QuietSave
Return
DoubleHandler:
 GuiControlGet, _, 10:, Double
 If _ = (Mouse%ActiveMouse%Double)
  Return
 If (A_GuiEvent = 5) OR (A_GuiEvent = 4) OR ((A_GuiEvent = "Normal") AND (A_GuiEventLast = 4))
  _ := 10*Round(_/10)
 A_GuiEventLast := A_GuiEvent
 Mouse%ActiveMouse%Double := _
 SetDouble(_)
 GuiControl,10:, Double,  % Mouse%ActiveMouse%Double
 GuiControl,10:, DoubleT,  % "Double Click Speed: " Mouse%ActiveMouse%Double
 GoSub, QuietSave
Return
WheelHandler:
 GuiControlGet, _, 10:, Wheel
 If _ = (Mouse%ActiveMouse%Wheel)
  Return
 Mouse%ActiveMouse%Wheel := _
 SetWheel(_)
  GuiControl,10:, WheelT, % "Scroll Wheel Speed: " Mouse%ActiveMouse%Wheel
 GoSub, QuietSave
Return
;——————————————————————————————————————————————————————————————————————————————————————
SwapMouseIcon(i) {
 Menu, Tray, Icon, % A_ScriptName, % i
}
;——————————————————————————————————————————————————————————————————————————————————————
GetEpp() {
 getMouseParams(Threshold1,Threshold2,Epp)
Return Epp
}
GetWheel() {
DllCall("SystemParametersInfo",UInt,0x68,UInt,0,UIntP,Wheel,UInt,0)
Return Wheel
}
GetDouble() {
Return DllCall("GetDoubleClickTime")
}
GetMouseSpeed() {
DllCall("SystemParametersInfo",UInt,0x70,UInt,0,UIntP,Speed,UInt,0)
Return Speed
}
;——————————————————————————————————————————————————————————————————————————————————————
SetEpp(Epp) {
 getMouseParams(Threshold1,Threshold2,Epp_)
 setMouseParams(Threshold1,Threshold2,Epp)
Return
}
SetWheel(Wheel) {
Return DllCall("SystemParametersInfo", UInt, 0x69, UInt, Wheel, UInt, 0, UInt, 0)
}
SetDouble(Double) {
Return DllCall("SetDoubleClickTime", uint, Double)
}
SetMouseSpeed(Speed) {
Return DllCall("SystemParametersInfo",UInt,0x71,UInt,0,UInt,Speed,UInt,0)
}
;——————————————————————————————————————————————————————————————————————————————————————
SwapMouseNav(swap=0) {
 GuiControl,10:, NavCB, %swap%
 GuiControl,10:, NavPic, % "*icon" (swap=0?15:14) " " A_ScriptName
 If swap
 {
  Hotkey, XButton1, On
  Hotkey, XButton2, On
 }
 Else
 {
  Hotkey, XButton1, Off
  Hotkey, XButton2, Off
 } 
Return ;DllCall("SwapMouseButton", Int, swap)
}
XButton1:
 Send {XButton1}
Return
XButton2:
 Send {XButton2}
Return
;——————————————————————————————————————————————————————————————————————————————————————
SwapMouseButtons(swap=0) {
 GuiControl,10:, ButtonCB, %swap%
 GuiControl,10:, ButtonPic, % "*icon" (swap=0?9:8) " " A_ScriptName
 Return DllCall("SwapMouseButton", Int, swap)
}
SwapEpp(swap=0) {
 GuiControl,10:, EppCB, %swap%
; GuiControl,10:, EppPic, % "*icon" (swap=0?9:8) " " A_ScriptName
 Return SetEpp(swap)
}
SwapMouseCursors(p) {
 global Cursor
 If (p) AND (Cursor <> "None")
 {
  SystemCursor("Arrow")
  SystemCursor("Hand")
  SystemCursor("Start")
  SystemCursor("Help")
  GuiControl,10:, CursorPic, % "*icon10 " A_ScriptName
  GuiControl,10:, CursorCB, 1
 }
 Else
 {
  RestoreCursors()
  GuiControl,10:, CursorPic, % "*icon11 " A_ScriptName
  GuiControl,10:, CursorCB, 0
 }
Return
}
SystemCursor(Which,With="") {
 global
 If Which = Arrow
  WhichID = 32512
 Else If Which = Hand
  WhichID = 32649
 Else If Which = Start
  WhichID = 32650
 Else If Which = Help
  WhichID = 32651
 Else
  Return
 hCursor := DllCall("CopyImage",uint, h%Which%, uint,2,int,0,int,0,uint,0)
 DllCall("SetSystemCursor",Uint,hCursor,Int,WhichID)
Return
}
RestoreCursors() {
  Return DllCall("SystemParametersInfo",UInt,0x57,UInt,0,UInt,0,UInt,0)
}
MouseName(h) {
 DllCall("GetRawInputDeviceInfo",Int,h,UInt,0x20000007,Int,0,"UInt*",l)
 VarSetCapacity(Name,l*2+2)
 DllCall("GetRawInputDeviceInfo",Int,h,UInt,0x20000007,Str,Name,"UInt*",l)
Return Name
}



getMouseParams(ByRef accelThreshold1, ByRef accelThreshold2, ByRef accelEnabled) {
  local lpParams, result
  VarSetCapacity(lpParams, 3 * 4, 0) ; set capacity to 12 bytes (three 32-bit integers)
  if ( result := DllCall("SystemParametersInfo", UInt,0x03, UInt,0, UInt,&lpParams, UInt,0) ) {
    accelThreshold1 := NumGet(lpParams, 0, "UInt")
    accelThreshold2 := NumGet(lpParams, 4, "UInt")
    accelEnabled    := NumGet(lpParams, 8, "UInt") ; accelEnabled is the "Enhance pointer precision" setting
  } else {
    MsgBox, DllCall SPI_GETMOUSE Failed - Result: "%Result%"`nErrorLevel: "%ErrorLevel%"`nA_LastError: "%A_LastError%"
  }
}

setMouseParams(accelThreshold1, accelThreshold2, accelEnabled) {
  local lpParams, result
  VarSetCapacity(lpParams, 3 * 4, 0)
  NumPut(accelThreshold1,      lpParams, 0, "UInt")
  NumPut(accelThreshold2,      lpParams, 4, "UInt")
  NumPut(accelEnabled ? 1 : 0, lpParams, 8, "UInt")
  if ( result := DllCall("SystemParametersInfo", UInt,0x04, UInt,0, UInt,&lpParams, UInt,1) ) {
  } else {
    MsgBox, DllCall SPI_SETMOUSE Failed - Result: "%Result%"`nErrorLevel: "%ErrorLevel%"`nA_LastError: "%A_LastError%"
  }
}

WH_MOUSE_LL(nCode, wParam, lParam)
{
;Mouse Inverse using Mouse Hook By Raccoon Dec-2010
  Static lx:=999999, ly
  Critical
  
  if !nCode && (wParam = 0x200) { ; WM_MOUSEMOVE 

    mx := NumGet(lParam+0, 0, "Int") ; x-coord
    my := NumGet(lParam+0, 4, "Int") ; y-coord
    ;OutputDebug % "MouseMove : mx = " mx ", lx = " lx ", my = " my ", ly = " ly
    
    if (lx != 999999) { ; skip if last-xy coordinates haven't been initilized (first move).

      ; normal movement example.
      mx := lx + (mx - lx)
      ;my := ly + (my - ly)
      
      ; modify (invert) movement.
      ;mx := lx - (mx - lx)
      my := ly - (my - ly)
      
      ; modify (half-speed) movement.
      ;mx := lx + (mx - lx) / 2
      ;my := ly + (my - ly) / 2
    }

    ; This is where the magic happens, in combination with Return 1.
    DllCall("SetCursorPos", "Int", mx, "Int", my)
    VarSetCapacity(lpPoint,8)
    DllCall("GetCursorPos", "Uint", &lpPoint) ; SetCursorPos controls desktop edges; less math for us.
    lx := NumGet(lpPoint, 0, "Int")
    ly := NumGet(lpPoint, 4, "Int")
    
    ; Send the modified mouse coords to other hooking processes along the chain.
    NumPut(mx, lParam+0, 0, "Int")
    NumPut(my, lParam+0, 4, "Int")
    ret:=DllCall("CallNextHookEx", "Uint", 0, "int", nCode, "Uint", wParam, "Uint", lParam)
    Return 1 ; Halt default mouse processing. (same method used by 'BlockInput, MouseMove')
  }
  else {
    Return DllCall("CallNextHookEx", "Uint", 0, "int", nCode, "Uint", wParam, "Uint", lParam) 
  }
} ; End WH_MOUSE_LL

SetWindowsHookEx(idHook, pfn) {
  Return DllCall("SetWindowsHookEx", "int", idHook, "Uint", pfn, "Uint", DllCall("GetModuleHandle", "Uint", 0), "Uint", 0)
}
UnhookWindowsHookEx(hHook) {
  Return DllCall("UnhookWindowsHookEx", "Uint", hHook)
}



;——————————————————————————————————————————————————————————————————————————————————————
;——— Updates ——————————————————————————————————————————————————————————————————————————
;——————————————————————————————————————————————————————————————————————————————————————
UpdateCheckQuiet:
 Instance("-UpdateCheckQuiet")
Return
UpdateCheck:
 Instance("-UpdateCheck")
Return
UpdateNow:
 Instance("-UpdateNow")
Return
UpdateInstaller:
 Instance("-UpdateInstaller")
Return
-UpdateCheck:
-UpdateCheckQuiet:
 If Beta
  v := UrlDownloadToVar("http://www.eithermouse.com/Beta/v?" version "-beta")
 Else
  v := UrlDownloadToVar("http://www.eithermouse.com/v?" version)
 LatestVersion := (SubStr(v,1,InStr(v,"`n")-2))
 UpdateInfo := (SubStr(v,InStr(v,"`n")+1))
 If LatestVersion is number
  If (LatestVersion > Version)
  {
   Notify(Name " update available...`n	Current version:	" Version "`n	Latest version:	" LatestVersion "`nClick here to update now...",UpdateInfo,60,"GC=bbbbff IN=1 AC=-UpdateNow AX=1 Image=" A_ScriptName)
   sleep, 60000
  } 
  Else If (A_ThisLabel <> "-UpdateCheckQuiet")
  {
   Notify(Name " " Version,"No updates found...",60,"GC=bbbbff IN=1 AC=ExitApp Image=" A_ScriptName)
   sleep, 60000
  } 
ExitApp

-UpdateInstaller:
 if not A_IsAdmin
 {
  Run *RunAs "%A_ScriptFullPath%" -UpdateInstaller
  ExitApp
 }
 FileDelete, "%Name% Setup.exe"
 Nid:=Notify(Name,"Downloading...",6000,"GC=bbbbff IN=1 Image=" A_ScriptName)
 If Beta
  UrlDownloadToFile, http://www.eithermouse.com/Beta/%Name% Setup.exe, %Name% Setup.exe
 Else
  UrlDownloadToFile, http://www.eithermouse.com/%Name% Setup.exe, %Name% Setup.exe
 Run, "%Name% Setup.exe"
ExitApp


-UpdateNow:
 if not A_IsAdmin
 {
  Run *RunAs "%A_ScriptFullPath%" -UpdateNow
  ExitApp
 }
 FileDelete, %Name%_Update.exe
 Nid:=Notify(Name,"Downloading...",6000,"GC=bbbbff IN=1 Image=" A_ScriptName)
 If Beta
  UrlDownloadToFile, http://www.eithermouse.com/Beta/%Name%.exe, %Name%_Update.exe
 Else
  UrlDownloadToFile, http://www.eithermouse.com/%Name%.exe, %Name%_Update.exe
 Run, "%Name%_Update.exe"
ExitApp
UpdateReplace:
 Notify(Name,"Updating...",6000,"GC=bbbbff IN=1 Image=" A_ScriptName)
 IfExist, %A_ScriptDir%\%Name%.exe
 {
  pDHW := A_DetectHiddenWindows
  DetectHiddenWindows On		; loop to close all running processes before compiling
  WinGet, List, List, ahk_exe %A_ScriptDir%\%Name%.exe
  Loop %List% 
   SendMessage,0x111,65405,0,, % "ahk_id " List%A_Index% 
  DetectHiddenWindows %pDHW%
 }
 sleep, 100
 FileDelete, %Name%.exe
 sleep, 100
 FileCopy, %A_ScriptName%, %Name%.exe, 1
 sleep, 100
 Run, "%Name%.exe"
 Run, %ComSpec% /c del "%Name%_Update.exe", , Hide
ExitApp
;——————————————————————————————————————————————————————————————————————————————————————
UrlDownloadToVar(URL) {
 ComObjError(false)
 WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
 WebRequest.Open("GET", URL)
 WebRequest.Send()
 Return WebRequest.ResponseText
}
;——————————————————————————————————————————————————————————————————————————————————————
TrayClick(w,l) { 
 If (l = 0x206 OR l = 0x203) 		; WM_RBUTTONDBLCLK or L
  SetTimer, ShowMenu, Off
 Else If (l = 0x202 or l = 0x205 )     	; WM_LBUTTONUP or R
  SetTimer, ShowMenu, -5
}
uiMove: ;move gui by dragging a control with glabel "GuiMove"
 PostMessage, 0xA1, 2,,, A
Return
;——————————————————————————————————————————————————————————————————————————————————————
HotkeyGuiShow:
 If HotkeyGui
  Return
 HotkeyGui = 1
 Gui  45:+LastFound
 Gui, 45:+LabelHotkeyGui
 Gui, 45:Default
 Gui, 45:Add, Picture, x6 y3 w48 h48 Icon1, % A_ScriptName
 Gui, 45:Font, s12 w500 cBlack
 Gui, 45:Add, Text,    x15    y15 w238 h30 Center BackgroundTrans vName, %Name%
 Gui, 45:Font, s8 w0
 Gui, 45:Add, Text,    x5    y48 w258 h15 Center BackgroundTrans vVersion, Assign and edit hotkeys and tray icon actions...
 Gui, 45:Add, Hotkey,    x130    y97 w65 ,
 Gui, 45:Add, DropDownList,    x5    y66 w190  Center, Swap mouse buttons||Mirror cursors|Both
 Gui, 45:Add, Checkbox, x10  y103 w30 , +
 Gui, 45:Add, Checkbox, x40  y103 w30 , +
 Gui, 45:Add, Checkbox, x70  y103 w30 , +
 Gui, 45:Add, Checkbox, x100 y103 w30 , +
 Gui, 45:Add, Text,     x5   y90  w25 Center, Win
 Gui, 45:Add, Text,     x35  y90  w25 Center, Ctrl
 Gui, 45:Add, Text,     x65  y90  w25 Center, Alt
 Gui, 45:Add, Text,     x95  y90  w25 Center, Shft
 Gui, 45:Add, ListView,    x5    y125 w190 h173 , Action|Hotkey
 Gui, 45:Add, Button,    x200    y78  w60 h30 Center gHotkeyGuiClose, Add
 Gui, 45:Add, Button,    x200    y130 w60 h30 Center gHotkeyGuiClose, Remove
 Gui, 45:Add, Button,    x200    y231 w60 h30 Center gHotkeyGuiClose, Cancel
 Gui, 45:Add, Button,    x200    y266 w60 h30 Center gHotkeyGuiClose, Save
 LV_Add("Icon" . A_Index, "Swap mouse buttons", "F6")
 LV_Add("Icon" . A_Index, "Mirror cursors", "Ctrl + R")
 LV_Add("Icon" . A_Index, "Both", "Win + B")
 LV_ModifyCol() 
 Gui, 45:Show, w265 h304, %Name% Hotkeys
Return
HotkeyGuiClose:
 Gui, 45:Destroy
 Gui, 45:Destroy
 HotkeyGui = 0
Return
;——————————————————————————————————————————————————————————————————————————————————————
About:
 GoSub, GuiClose
 Gui  13:+LastFound
 Gui, 13:Add, Picture, x6 y3 w48 h48 Icon1, % A_ScriptName
 Gui, 13:Font, s12 w600 cBlack
 Gui, 13:Add, Text,    x15    y15 w238 h30 Center BackgroundTrans vName, %Name%
 Gui, 13:Font, s8 w0
 Gui, 13:Add, Text,    x5    y48 w258 h15 Center BackgroundTrans vVersion, v%Version% - made by joel - aug 09
 Gui, 13:Add, Text,    x5    y70 w258 h130 Center, Sharing a computer with a left-handed user?`n`n%Name% seemlessly swaps mouse buttons for you as the mouse being used changes!`n`nYou can now leave 2 mice connected and use either at any time, immediately
 Gui, 13:Add, Button,    x200    y166 w60 h30 Center gGuiClose, OK
 Gui, 13:Font, s8 w0 cBlue
 Gui, 13:Add, Text,    x5    y165 w140 R2 Center gRunSite, www.eithermouse.com`ngwarble@gmail.com
 Gui, 13:Show, w268 h204, About %Name%...
Return
GuiClose:
 If WelcomeGui
 {
  SetTimer, IconFlash, Off
  SwapMouseIcon(   Mouse%ActiveMouse%Icon)
  WelcomeGui = 0
 }
 Gui, 13:Destroy
 ToolTip, % "", 195,,20
Return
RunSite:
 Run, http://www.eithermouse.com
Return
;——————————————————————————————————————————————————————————————————————————————————————


BlankCursor(c="") {
 If c =
  c = 650,512,515,649,651,513,648,646,643,645,642,644,516,514
 Loop, parse, c, `,
 {
  VarSetCapacity(a,128,0xFF),VarSetCapacity(x,128,0)
  h := DllCall("CreateCursor",Uint,0,Int,0,Int,0,Int,32,Int,32,Uint,&a,Uint,&x)
  DllCall("SetSystemCursor",Uint,h,Int,"32" . A_LoopField)
 }
 Return
}




ReCompile() {
 FileCopy, %A_ScriptFullPath%, EitherMouse_Update.exe, 1
 ExeFile := A_ScriptDir "\EitherMouse_Update.exe"
 ScriptBody := "MsgBox"
; FileRead, ScriptBody, EitherMouse.ahk

 hMod := DllCall( "GetModuleHandle", UInt,0 )
 hRes := DllCall( "FindResource", UInt,hMod, "Str","EITHERMOUSE SETUP.AHK", "Str","#10" )
 hData := DllCall( "LoadResource", UInt,hMod, UInt,hRes )
 pData := DllCall( "LockResource", UInt,hData )
 nSize := DllCall( "SizeofResource", UInt,hMod, UInt,hRes )
 ScriptBody := StrGet(pData, nSize, "UTF-8")
FileAppend, % ScriptBody, test.txt

;LibScript:=(res:=DllCall("FindResource","ptr",lib:=DllCall("GetModuleHandle","ptr",0,"ptr"),"str",">AUTOHOTKEY SCRIPT<","ptr",10,"ptr")
;
;StrGet(DllCall("LockResource","ptr",DllCall("LoadResource","ptr",lib,"ptr",res,"ptr"),"ptr"),DllCall("SizeofResource","ptr",lib,"ptr",res,"uint"),"UTF-8"):"")
;Notify(LibScript)




 VarSetCapacity(BinScriptBody, BinScriptBody_Len := StrPut(ScriptBody, "UTF-8") - 1)
 StrPut(ScriptBody, &BinScriptBody, "UTF-8")
 module := DllCall("BeginUpdateResource", "str", ExeFile, "uint", 0, "ptr")
 If !module
  MsgBox, % "Error: Error opening the destination file."
; DllCall("UpdateResource", "ptr", module, "ptr", 10, "str", ">AUTOHOTKEY SCRIPT<", "ushort", 0x409, "ptr", 0, "uint", 0, "uint")
 If !DllCall("UpdateResource", "ptr", module, "ptr", 10, "str", ">AUTOHOTKEY SCRIPT<", "ushort", 0x409, "ptr", &BinScriptBody, "uint", BinScriptBody_Len, "uint")
 {
  DllCall("EndUpdateResource", "ptr", module, "uint", 0)
  MsgBox, Failed...
  FileDelete, EitherMouse_Update.exe
 }
 Else
 {
  DllCall("EndUpdateResource", "ptr", module, "uint", 0)
  MsgBox, Success...
;  Run, % ExeFile
 }
 Return
}

;;
;  Compile() - 0.46 - by gwarble - customized for EitherMouse
;    compile script on demand with local ...AHK.bin or compiled .exe
;
; Compile(Action,Name,Options)
;
;    Action   Wait          -waits for the compiler to finish before returning
;             Run [Default] -to run the compiled script and close the running script
;             NoWait        -starts compiling and continues running your script
;             Recompile     -closes the running .exe and launches the .ahk (if compiled)
;             Exit          -compiles then exits the .ahk
;
;    Name     "" [Default]  -uses filename of script for exe/ico/bin filenames
;             Other         -specify a different name for the input ico/bin and output exe
;
;    Options  nompress      - doesn't use mpress compression
;             console       - convert to console application (NYI)
;
;    Returns  1 on success, 0 on failure/compiler not found/already compiled
;
;    Notes    save modified AutoHotkeySC.bin as ScriptName.AHK.bin
;

Compile(Action="Run",Name="",Options="") {
 If A_IsCompiled	
  If Action <> Recompile
   Return 0
  Else
  {
   SplitPath, A_ScriptFullPath,,,,ScriptName
   Run, %ScriptName%.ahk
   Return 1 					; should have auto-execute Compile("Run") for Recompile
  }

 SplitPath, A_ScriptFullPath,, ScriptDir,, ScriptName
 If Name <>
  ScriptName := Name
 Icon := ExeFile := ScriptDir "\" ScriptName ".exe"

 Loop, %ScriptName%.AHK.bin, 0, 0 		; find local AHK.bin file
 {
  CompilerBin = /bin "%A_LoopFileFullPath%"
  Break
 }
 If (CompilerBin = "") AND FileExist(ExeFile)			; otherwise use existing exe by copying to .AHK.bin
 {
  FileCopy, %ExeFile%, % CompilerBin_ := ScriptDir "\" ScriptName ".AHK.bin", 1
  CompilerBin = /bin "%CompilerBin_%"
 }
 If CompilerBin =				; otherwise fail
 {
  MsgBox, 48, EitherMouse, EitherMouse compilation failed.`n`nEitherMouse.exe file is missing...
  ExitApp
 }
 SplitPath, A_AhkPath,, Compiler,,,
 Compiler := Compiler "\Compiler\Ahk2Exe.exe" 	; assumes compiler is in AHKPath default Compiler dir
 IfNotExist %Compiler%
  Loop, %A_ScriptDir%\Ahk2Exe.exe, 0, 1		; otherwise checks the local dir for the compiler
  {
   Compiler = %A_LoopFileFullPath%
   Break
  }
 IfNotExist %Compiler%				; and if no compiler is found, returns 0
  Return 0

 pDHW := A_DetectHiddenWindows
 DetectHiddenWindows On		; loop to close all running processes before compiling
 WinGet, List, List, ahk_exe %ExeFile%
 Loop %List% 
  SendMessage,0x111,65405,0,, % "ahk_id " List%A_Index% 
 DetectHiddenWindows %pDHW%

 If (Options = "nompress")
  mpress := "/mpress 0"

 RunLine = %Compiler% /in "%A_ScriptFullPath%" /out "%ExeFile%" %CompilerBin% %ScriptIcon% %mpress%
 If Action = NoWait
  Run,     % RunLine, % A_ScriptDir, Hide
 Else
  RunWait, % RunLine, % A_ScriptDir, Hide

 If CompilerBin_
  FileDelete, % CompilerBin_

 If Action = Run			; and run the compiled script if "Run" option is used (typical)
 {
  Run, "%ExeFile%"
  ExitApp
 }
 Else If Action = Exit
  ExitApp

Return 1
}



; Instance() - 0.43 - gwarble
;  creates another instance to perform a task
;    help: http://www.autohotkey.com/forum/viewtopic.php?p=310694
;
; Instance(Label,Params,AltWM)
;
;  Label   "" to initialize, should be in autoexecute section as: [ If Instance("","-") ]
;          "Label" to start a new instance, whose execution       [   Return            ]
;            will be redirected to the "Label" subroutine
;
;  Params  parameters to pass to new instance (retrieved normally, ie: %2%)
;          when initializing (ie: label="") Params is a label prefix for all calls
;          last param received by script is calling-instance's ProcessID
;
;  AltWM   Alternate WindowsMessage number if 0x1357 (arbitrary anyway) will conflict
;
;  Return  ProcessID of new instance
;
Instance(Label="", Params="", WM="0x1357") {
 global 1		; uses first command line parameter to redirect auto-execute section
 If Label =             ; called from autoexec section with Label="" to redirect new instances
 {
  Label = %1%
  If InStr(Label, Params)
  {
   If IsLabel(Label)
   {
    GoSub, %Label%
    Exit                ; don't run the rest of autoexecute section
   }
  }
;  Else                  ; otherwise this will make it act as [ SingleInstance, force ]
;  {                     ; unless second param is "Single"
   pDHW := A_DetectHiddenWindows
   DetectHiddenWindows, On
   WinGet, Instance_ID, List, %A_ScriptFullPath%
   If (Params <> "Single")
    Loop %Instance_ID%
     SendMessage, WM, WM, 0, , % "ahk_id " Instance_ID%A_Index%
   DetectHiddenWindows, %pDHW%
   OnMessage(WM, "Instance_")
;  }
  Return
 }
 Else
 {
  If IsLabel(Label)
  {
   ProcessID := DllCall("GetCurrentProcessId")
   If A_IsCompiled
    Run, "%A_ScriptFullPath%" /f "%Label%" %Params% %ProcessID%,,,Instance_PID
   Else
    Run, "%A_AhkPath%" /f "%A_ScriptFullPath%" "%Label%" %Params% %ProcessID%,,,Instance_PID
   Return %Instance_PID%
  }
  Return
 }
 #SingleInstance, Off 	; your script needs this anyway for Instance() to be useful, so its here
}

Instance_(wParam, lParam) {	; OnMessage Handler for singleInstance behavior or to
 Critical			; send messages back to calling instance via subroutine to run
 If lParam = 0			; (ie status updates, "i'm finished", etc)
  ExitApp			; if message lparam sent back besides 0, calling
 Else If IsLabel(Label := "Instance_" lParam) ; ; instance looks for and runs label Instance_%lParam%
  GoSub, %Label%		; so the script would have a label like:
 Return				; Instance_1: and Instance_2: or Instance_%Integer%:
}				; and the new instance can SendMsg,WM,WM,Integer to the calling instance


Notify(Title="Notify()",Message="",Duration="",Options="")
{
static GNList, ACList, ATList, AXList, Exit, _Wallpaper_, _Title_, _Message_, _Progress_, _Image_, Saved
static GF := 50
static GL := 74
static GC,GR,GT,BC,BK,BW,BR,BT,BF
static TS,TW,TC,TF,MS,MW,MC,MF
static SI,SC,ST,IW,IH,IN,XC,XS,XW,PC,PB
If (Options)
{
If (A_AutoTrim = "Off")
{
AutoTrim, On
_AutoTrim = 1
}
Options = %Options%
Options.=" "
Loop,Parse,Options,=
{
If A_Index = 1
Option := A_LoopField
Else
{
%Option% := SubStr(A_LoopField, 1, (pos := InStr(A_LoopField, A_Space, false, 0))-1)
%Option% = % %Option%
Option   := SubStr(A_LoopField, pos+1)
}
}
If _AutoTrim
AutoTrim, Off
If Wait <>
{
If Wait Is Number
{
Gui %Wait%:+LastFound
If NotifyGuiID := WinExist()
{
WinWaitClose, , , % Abs(Duration)
If (ErrorLevel && Duration < 1)
{
Gui, % Wait + GL - GF + 1 ":Destroy"
If ST
DllCall("AnimateWindow","UInt",NotifyGuiID,"Int",ST,"UInt","0x00050001")
Gui, %Wait%:Destroy
}
}
}
Else
{
Loop, % GL-GF
{
Wait := A_Index + GF - 1
Gui %Wait%:+LastFound
If NotifyGuiID := WinExist()
{
WinWaitClose, , , % Abs(Duration)
If (ErrorLevel && Duration < 1)
{
Gui, % Wait + GL - GF + 1 ":Destroy"
If ST
DllCall("AnimateWindow","UInt",NotifyGuiID,"Int",ST,"UInt","0x00050001")
Gui, %Wait%:Destroy
}
}
}
GNList := ACList := ATList := AXList := ""
}
Return
}
If Update <>
{
If Title <>
GuiControl, %Update%:,_Title_,%Title%
If Message <>
GuiControl, %Update%:,_Message_,%Message%
If Duration <>
GuiControl, %Update%:,_Progress_,%Duration%
If Image <>
GuiControl, %Update%:,_Image_,%Image%
If Wallpaper <>
GuiControl, %Update%:,_Wallpaper_,%Image%
Return
}
If Style = Save
{
Saved := Options " GC=" GC " GR=" GR " GT=" GT " BC=" BC " BK=" BK " BW=" BW " BR=" BR " BT=" BT " BF=" BF
Saved .= " TS=" TS " TW=" TW " TC=" TC " TF=" TF " MS=" MS " MW=" MW " MC=" MC " MF=" MF
Saved .= " IW=" IW " IH=" IH " IN=" IN " PW=" PW " PH=" PH " PC=" PC " PB=" PB " XC=" XC " XS=" MS " XW=" XW
Saved .= " SI=" SI " SC=" SC " ST=" ST " WF=" Image " IF=" IF
}
If Return <>
Return, % (%Return%)
If Style <>
{
If Style = Default
Return % Notify(Title,Message,Duration,
(
"GC= GR= GT= BC= BK= BW= BR= BT= BF= TS= TW= TC= TF= 
 MS= MW= MC= MF= SI= ST= SC= IW=
 IH= IN= XC= XS= XW= PC= PB= " Options "Style=")
)
Else If Style = ToolTip
Return % Notify(Title,Message,Duration,"SI=50 GC=FFFFAA BC=00000 GR=0 BR=0 BW=1 BT=255 TS=8 MS=8 " Options "Style=")
Else If Style = BalloonTip
Return % Notify(Title,Message,Duration,"SI=350 GC=FFFFAA BC=00000 GR=13 BR=15 BW=1 BT=255 TS=10 MS=8 AX=1 XC=999922 IN=8 Image=" A_WinDir "\explorer.exe " Options "Style=")
Else If Style = Error
Return % Notify(Title,Message,Duration,"SI=250 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=666666 IN=10 IW=32 IH=32 Image=" A_WinDir "\explorer.exe " Options "Style=")
Else If Style = Warning
Return % Notify(Title,Message,Duration,"SI=250 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=666666 IN=9 IW=32 IH=32 Image=" A_WinDir "\explorer.exe " Options "Style=")
Else If Style = Info
Return % Notify(Title,Message,Duration,"SI=250 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=666666 IN=8 IW=32 IH=32 Image=" A_WinDir "\explorer.exe " Options "Style=")
Else If Style = Question
Return % Notify(Title,Message,Duration,"SI=250 GC=Default BC=00000 GR=0 BR=0 BW=1 BT=255 TS=12 MS=12 AX=1 XC=666666 Image=24 IW=32 IH=32 " Options "Style=")
Else If Style = Progress
Return % Notify(Title,Message,Duration,"SI=100 GC=Default BC=00000 GR=9 BR=13 BW=2 BT=105 TS=10 MS=10 PG=100 PH=10 GW=300 " Options "Style=")
Else If Style = Huge
Return % Notify(Title,Message,Duration,"SI=100 ST=200 SC=200 GC=FFFFAA BC=00000 GR=27 BR=39 BW=6 BT=105 TS=24 MS=22 " Options "Style=")
Else If Style = Load
Return % Notify(Title,Message,Duration,Saved)
}
}
GC_ := GC_<>"" ? GC_ : GC := GC<>"" ? GC : "FFFFAA"
GR_ := GR_<>"" ? GR_ : GR := GR<>"" ? GR : 9
GT_ := GT_<>"" ? GT_ : GT := GT<>"" ? GT : "Off"
BC_ := BC_<>"" ? BC_ : BC := BC<>"" ? BC : "000000"
BK_ := BK_<>"" ? BK_ : BK := BK<>"" ? BK : "Silver"
BW_ := BW_<>"" ? BW_ : BW := BW<>"" ? BW : 2
BR_ := BR_<>"" ? BR_ : BR := BR<>"" ? BR : 13
BT_ := BT_<>"" ? BT_ : BT := BT<>"" ? BT : 105
BF_ := BF_<>"" ? BF_ : BF := BF<>"" ? BF : 350
TS_ := TS_<>"" ? TS_ : TS := TS<>"" ? TS : 10
TW_ := TW_<>"" ? TW_ : TW := TW<>"" ? TW : 625
TC_ := TC_<>"" ? TC_ : TC := TC<>"" ? TC : "Default"
TF_ := TF_<>"" ? TF_ : TF := TF<>"" ? TF : "Default"
MS_ := MS_<>"" ? MS_ : MS := MS<>"" ? MS : 10
MW_ := MW_<>"" ? MW_ : MW := MW<>"" ? MW : "Default"
MC_ := MC_<>"" ? MC_ : MC := MC<>"" ? MC : "Default"
MF_ := MF_<>"" ? MF_ : MF := MF<>"" ? MF : "Default"
SI_ := SI_<>"" ? SI_ : SI := SI<>"" ? SI : 0
SC_ := SC_<>"" ? SC_ : SC := SC<>"" ? SC : 0
ST_ := ST_<>"" ? ST_ : ST := ST<>"" ? ST : 0
IW_ := IW_<>"" ? IW_ : IW := IW<>"" ? IW : 32
IH_ := IH_<>"" ? IH_ : IH := IH<>"" ? IH : 32
IN_ := IN_<>"" ? IN_ : IN := IN<>"" ? IN : 0
XF_ := XF_<>"" ? XF_ : XF := XF<>"" ? XF : "Arial Black"
XC_ := XC_<>"" ? XC_ : XC := XC<>"" ? XC : "Default"
XS_ := XS_<>"" ? XS_ : XS := XS<>"" ? XS : 12
XW_ := XW_<>"" ? XW_ : XW := XW<>"" ? XW : 800
PC_ := PC_<>"" ? PC_ : PC := PC<>"" ? PC : "Default"
PB_ := PB_<>"" ? PB_ : PB := PB<>"" ? PB : "Default"
wPW := ((PW<>"") ? ("w" PW) : (""))
hPH := ((PH<>"") ? ("h" PH) : (""))
If GW <>
{
wGW = w%GW%
wPW := "w" GW - 20
}
hGH := ((GH<>"") ? ("h" GH) : (""))
wGW_ := ((GW<>"") ? ("w" GW - 20) : (""))
hGH_ := ((GH<>"") ? ("h" GH - 20) : (""))
If Duration =
Duration = 30
GN := GF
Loop
IfNotInString, GNList, % "|" GN
Break
Else
If (++GN > GL)
Return 0
GNList .= "|" GN
GN2 := GN + GL - GF + 1
If AC <>
ACList .= "|" GN "=" AC
If AT <>
ATList .= "|" GN "=" AT
If AX <>
AXList .= "|" GN "=" AX
P_DHW := A_DetectHiddenWindows
P_TMM := A_TitleMatchMode
DetectHiddenWindows On
SetTitleMatchMode 1
If (WinExist("_Notify()_GUI_"))
WinGetPos, OtherX, OtherY
DetectHiddenWindows %P_DHW%
SetTitleMatchMode %P_TMM%
Gui, %GN%:-Caption +ToolWindow +AlwaysOnTop -Border
Gui, %GN%:Color, %GC_%
If FileExist(WP)
{
Gui, %GN%:Add, Picture, x0 y0 w0 h0 v_Wallpaper_, % WP
ImageOptions = x+8 y+4
}
If Image <>
{
If FileExist(Image)
Gui, %GN%:Add, Picture, w%IW_% h%IH_% Icon%IN_% v_Image_ %ImageOptions%, % Image
Else
Gui, %GN%:Add, Picture, w%IW_% h%IH_% Icon%Image% v_Image_ %ImageOptions%, %A_WinDir%\system32\shell32.dll
ImageOptions = x+10
}
If Title <>
{
Gui, %GN%:Font, w%TW_% s%TS_% c%TC_%, %TF_%
Gui, %GN%:Add, Text, %ImageOptions% BackgroundTrans v_Title_, % Title
}
If PG
Gui, %GN%:Add, Progress, Range0-%PG% %wPW% %hPH% c%PC_% Background%PB_% v_Progress_
Else
If ((Title) && (Message))
Gui, %GN%:Margin, , -5
If Message <>
{
Gui, %GN%:Font, w%MW_% s%MS_% c%MC_%, %MF_%
Gui, %GN%:Add, Text, BackgroundTrans v_Message_, % Message
}
If ((Title) && (Message))
Gui, %GN%:Margin, , 8
Gui, %GN%:Show, Hide %wGW% %hGH%, _Notify()_GUI_
Gui  %GN%:+LastFound
WinGetPos, GX, GY, GW, GH
GuiControl, %GN%:, _Wallpaper_, % "*w" GW " *h" GH " " WP
GuiControl, %GN%:MoveDraw, _Title_,    % "w" GW-20 " h" GH-10
GuiControl, %GN%:MoveDraw, _Message_,  % "w" GW-20 " h" GH-10
If AX <>
{
GW += 10
Gui, %GN%:Font, w%XW_% s%XS_% c%XC_%, Arial Black
Gui, %GN%:Add, Text, % "x" GW-15 " y-2 Center w12 h20 g_Notify_Kill_" GN - GF + 1, % chr(0x00D7)
}
Gui, %GN%:Add, Text, x0 y0 w%GW% h%GH% BackgroundTrans g_Notify_Action_Clicked_
If (GR_)
WinSet, Region, % "0-0 w" GW " h" GH " R" GR_ "-" GR_
If (GT_)
WinSet, Transparent, % GT_
SysGet, Workspace, MonitorWorkArea
NewX := WorkSpaceRight-GW-5
If (OtherY)
NewY := OtherY-GH-2-BW_*2
Else
NewY := WorkspaceBottom-GH-5
If NewY < % WorkspaceTop
NewY := WorkspaceBottom-GH-5
Gui, %GN2%:-Caption +ToolWindow +AlwaysOnTop -Border +E0x20
Gui, %GN2%:Color, %BC_%
Gui  %GN2%:+LastFound
If (BR_)
WinSet, Region, % "0-0 w" GW+(BW_*2) " h" GH+(BW_*2) " R" BR_ "-" BR_
If (BT_)
WinSet, Transparent, % BT_
Gui, %GN2%:Show, % "Hide x" NewX-BW_ " y" NewY-BW_ " w" GW+(BW_*2) " h" GH+(BW_*2), _Notify()_BGGUI_
Gui, %GN%:Show,  % "Hide x" NewX " y" NewY " w" GW, _Notify()_GUI_
Gui  %GN%:+LastFound
If SI_
DllCall("AnimateWindow","UInt",WinExist(),"Int",SI_,"UInt","0x00040008")
Else
Gui, %GN%:Show, NA, _Notify()_GUI_
Gui, %GN2%:Show, NA, _Notify()_BGGUI_
WinSet, AlwaysOnTop, On
If ((Duration < 0) OR (Duration = "-0"))
Exit := GN
If (Duration)
SetTimer, % "_Notify_Kill_" GN - GF + 1, % - Abs(Duration) * 1000
Else
SetTimer, % "_Notify_Flash_" GN - GF + 1, % BF_
Return %GN%
_Notify_Action_Clicked_:
SetTimer, % "_Notify_Kill_" A_Gui - GF + 1, Off
Gui, % A_Gui + GL - GF + 1 ":Destroy"
If SC
{
Gui, %A_Gui%:+LastFound
DllCall("AnimateWindow","UInt",WinExist(),"Int",SC,"UInt", "0x00050001")
}
Gui, %A_Gui%:Destroy
If (ACList)
Loop,Parse,ACList,|
If ((Action := SubStr(A_LoopField,1,2)) = A_Gui)
{
Temp_Notify_Action:= SubStr(A_LoopField,4)
StringReplace, ACList, ACList, % "|" A_Gui "=" Temp_Notify_Action, , All
If IsLabel(_Notify_Action := Temp_Notify_Action)
Gosub, %_Notify_Action%
_Notify_Action =
Break
}
StringReplace, GNList, GNList, % "|" A_Gui, , All
SetTimer, % "_Notify_Flash_" A_Gui - GF + 1, Off
If (Exit = A_Gui)
ExitApp
Return
_Notify_Kill_1:
_Notify_Kill_2:
_Notify_Kill_3:
_Notify_Kill_4:
_Notify_Kill_5:
_Notify_Kill_6:
_Notify_Kill_7:
_Notify_Kill_8:
_Notify_Kill_9:
_Notify_Kill_10:
_Notify_Kill_11:
_Notify_Kill_12:
_Notify_Kill_13:
_Notify_Kill_14:
_Notify_Kill_15:
_Notify_Kill_16:
_Notify_Kill_17:
_Notify_Kill_18:
_Notify_Kill_19:
_Notify_Kill_20:
_Notify_Kill_21:
_Notify_Kill_22:
_Notify_Kill_23:
_Notify_Kill_24:
_Notify_Kill_25:
Critical
StringReplace, GK, A_ThisLabel, _Notify_Kill_
SetTimer, _Notify_Flash_%GK%, Off
GK := GK + GF - 1
Gui, % GK + GL - GF + 1 ":Destroy"
If ST
{
Gui, %GK%:+LastFound
DllCall("AnimateWindow","UInt",WinExist(),"Int",ST,"UInt", "0x00050001")
}
Gui, %GK%:Destroy
StringReplace, GNList, GNList, % "|" GK, , All
If (Exit = GK)
ExitApp
Return 1
_Notify_Flash_1:
_Notify_Flash_2:
_Notify_Flash_3:
_Notify_Flash_4:
_Notify_Flash_5:
_Notify_Flash_6:
_Notify_Flash_7:
_Notify_Flash_8:
_Notify_Flash_9:
_Notify_Flash_10:
_Notify_Flash_11:
_Notify_Flash_12:
_Notify_Flash_13:
_Notify_Flash_14:
_Notify_Flash_15:
_Notify_Flash_16:
_Notify_Flash_17:
_Notify_Flash_18:
_Notify_Flash_19:
_Notify_Flash_20:
_Notify_Flash_21:
_Notify_Flash_22:
_Notify_Flash_23:
_Notify_Flash_24:
_Notify_Flash_25:
StringReplace, FlashGN, A_ThisLabel, _Notify_Flash_
FlashGN += GF - 1
FlashGN2 := FlashGN + GL - GF + 1
If Flashed%FlashGN2% := !Flashed%FlashGN2%
Gui, %FlashGN2%:Color, %BK%
Else
Gui, %FlashGN2%:Color, %BC%
Return
}

CreateCompatibleDC(hdc=0) {
return DllCall("CreateCompatibleDC", "uint", hdc)
}
CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0) {
hdc2 := hdc ? hdc : GetDC()
VarSetCapacity(bi, 40, 0)
NumPut(w, bi, 4), NumPut(h, bi, 8), NumPut(40, bi, 0), NumPut(1, bi, 12, "ushort"), NumPut(0, bi, 16), NumPut(bpp, bi, 14, "ushort")
hbm := DllCall("CreateDIBSection", "uint" , hdc2, "uint" , &bi, "uint" , 0, "uint*", ppvBits, "uint" , 0, "uint" , 0)
if !hdc
ReleaseDC(hdc2)
return hbm
}
DeleteDC(hdc) {
return DllCall("DeleteDC", "uint", hdc)
}
DeleteObject(hObject) {
return DllCall("DeleteObject", "uint", hObject)
}
Gdip_DeleteGraphics(pGraphics) {
return DllCall("gdiplus\GdipDeleteGraphics", "uint", pGraphics)
}
Gdip_Shutdown(pToken) {
DllCall("gdiplus\GdiplusShutdown", "uint", pToken)
if hModule := DllCall("GetModuleHandle", "str", "gdiplus")
DllCall("FreeLibrary", "uint", hModule)
return 0
}
Gdip_Startup() {
if !DllCall("GetModuleHandle", "str", "gdiplus")
DllCall("LoadLibrary", "str", "gdiplus")
VarSetCapacity(si, 16, 0), si := Chr(1)
DllCall("gdiplus\GdiplusStartup", "uint*", pToken, "uint", &si, "uint", 0)
return pToken
}
GetDC(hwnd=0)
{
return DllCall("GetDC", "uint", hwnd)
}
ReleaseDC(hdc, hwnd=0)
{
return DllCall("ReleaseDC", "uint", hwnd, "uint", hdc)
}
SelectObject(hdc, hgdiobj)
{
return DllCall("SelectObject", "uint", hdc, "uint", hgdiobj)
}
UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
{
if ((x != "") && (y != ""))
VarSetCapacity(pt, 8), NumPut(x, pt, 0), NumPut(y, pt, 4)
if (w = "") ||(h = "")
WinGetPos,,, w, h, ahk_id %hwnd%
return DllCall("UpdateLayeredWindow", "uint", hwnd, "uint", 0, "uint", ((x = "") && (y = "")) ? 0 : &pt
, "int64*", w|h<<32, "uint", hdc, "int64*", 0, "uint", 0, "uint*", Alpha<<16|1<<24, "uint", 2)
}
