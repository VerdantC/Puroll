#NoEnv

#NoTrayIcon

#SingleInstance force


#UseHook Off
#InstallMouseHook

#MaxHotkeysPerInterval 1000

SendMode Input

Menu, Tray, Tip, Revised_MouseWheelTabScroll4Chrome

WheelUp::
WheelDown::
    SetStoreCapsLockMode, Off

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

    SetStoreCapsLockMode, On
Return





; Deprecated


If WinActive("ahk_exe ONENOTE.EXE")
    +WheelDown::WheelRight
+WheelUp::WheelLeft
#IfWinActive
ProcessExist(Name){
    Process,Exist,%Name%
    return Errorlevel
}
; If WinActive("ahk_exe WINWORD.EXE")
;     +WheelDown::WheelRight
; +WheelUp::WheelLeft
; #IfWinActive
; ProcessExist(Name){
;     Process,Exist,%Name%
;     return Errorlevel
; }



; 获取并永久保持当前的 CapsLock 状态
GetAndPersistCapsLockState() {
    ; 获取当前 CapsLock 状态
    state := GetKeyState("CapsLock", "T")

    ; 设置永久的 CapsLock 状态
    SetCapsLockState, % (state ? "AlwaysOn" : "AlwaysOff")
    return state
}

; 调用函数




; 取消永久的 CapsLock 状态并恢复到原始状态
CancelPersistCapsLockState() {
    ; 获取当前 CapsLock 状态
    originalState := GetKeyState("CapsLock", "T")

    ; 设置 CapsLock 状态为原始状态
    SetCapsLockState, % (originalState ? "On" : "Off")
}

; 调用函数

