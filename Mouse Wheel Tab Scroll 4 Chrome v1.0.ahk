#NoEnv
#NoTrayIcon
#SingleInstance force
#UseHook Off
#InstallMouseHook
#MaxHotkeysPerInterval 1000
SendMode Input
Menu, Tray, Tip, Mousewheel++
WheelUp::
WheelDown::
    MouseGetPos,, ypos, id
    WinGetClass, class, ahk_id %id%
    If (ypos < 45 and InStr(class,"Chrome_WidgetWin"))
    {
        IfWinNotActive ahk_id %id%
            WinActivate ahk_id %id%
        If A_ThisHotkey = WheelUp
            Send ^{PgUp}
        Else
            Send ^{PgDn}
    }
    Else
    {
        If A_ThisHotkey = WheelUp
            Send {WheelUp}
        Else
            Send {WheelDown}
    }
Return
If WinActive("ahk_exe ONENOTE.EXE")
    +WheelDown::WheelRight
+WheelUp::WheelLeft
#IfWinActive
ProcessExist(Name){
    Process,Exist,%Name%
    return Errorlevel
}
