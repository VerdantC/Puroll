ScriptVersion := "0.7.0"

#SingleInstance force
#Persistent

SetWorkingDir %A_ScriptDir% ; ensure a consistent starting directory


Menu, Tray, Tip, Puroll

ScriptName := "Puroll"


global ConfigDir
ConfigDir := A_WorkingDir . "\" . "config"
ConfigFile := ConfigDir . "\" . ScriptName . ".ini"














Menu, Tray, NoStandard


Menu, Tray, Add, Exit, ExitProgram


TEXT_MenuAutostart = Start with Windows
Menu, Tray, Add, %TEXT_MenuAutostart%, AutostartProgram


; #1
; 菜单
Menu, MySubmenu, Add, Turquoise 
Menu, MySubmenu, Add, Lake
Menu, MySubmenu, Add, Berry
Menu, Tray, Add, Theme, :MySubmenu


; Wahoo
;     Item1

first_set()

SetIcon()
; #1
run_exes()




first_set(){
	Menu, Tray, Click, 1
	Menu, Tray, Add, &Switch, turn_off
	Menu, Tray, Default, &Switch
	return
}
run_exes() {
	Run, %ConfigDir%\AltSnap1.62src\AltSnap.exe -hide
	; "C:\Users\chy\Desktop\test\AltSnap.exe"
	; "C:\Users\chy\Desktop\test\cclose-1.4.1.0\CClose.exe"
	; "C:\Users\chy\Desktop\test\Revised_MouseWheelTabScroll4Chrome\Revised_MouseWheelTabScroll4Chrome.exe"
	Run, %ConfigDir%\cclose-1.4.1.0\CClose.exe
	Run, %ConfigDir%\Revised_MouseWheelTabScroll4Chrome\Revised_MouseWheelTabScroll4Chrome.exe
	return
}


CloseExes() {
    Process, Close, AltSnap.exe
    Process, Close, CClose.exe
    Process, Close, Revised_MouseWheelTabScroll4Chrome.exe
	return
}



OnExit("CloseExes")
; retrieve the autostart setting
IniRead, IsAutostart, %ConfigFile%, Autostart, EnableAutostart, 1

; apply the autostart setting if possible
if A_IsAdmin ; if run the script as administrator, apply the autostart setting
{
	if IsAutostart
	{
		; Menu, SettingMenu, Check, %TEXT_MenuAutostart% ; check the autostart menu item
		Menu, Tray, Check, %TEXT_MenuAutostart% ; check the autostart menu item
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %ScriptName%, %A_ScriptFullPath% ; enable autostart
	}
	else
	{
		RegDelete, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %ScriptName% ; disable autostart
	}
}
else ; else update the autostart setting
{
	RegRead, RegValue, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %ScriptName% ; retrieve autostart status
	if (RegValue == A_ScriptFullPath) ; if autostart is enabled
	{
		; Menu, SettingMenu, Check, %TEXT_MenuAutostart% ; check the autostart menu item
		Menu, Tray, Check, %TEXT_MenuAutostart% 
		IsAutostart := 1
	}
	else
	{
		IsAutostart := 0
	}
	Gosub, EnsureConfigDirExists
	IniWrite, %IsAutostart%, %ConfigFile%, Autostart, EnableAutostart ; update the autostart setting
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Return ; end of the auto-execute section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ensure ConfigDir exists
EnsureConfigDirExists:
if !InStr(FileExist(ConfigDir), "D")
{
	FileCreateDir, %ConfigDir%
}
Return







AutostartProgram:
IsAutostart := !IsAutostart
Gosub, EnsureConfigDirExists
IniWrite, %IsAutostart%, %ConfigFile%, Autostart, EnableAutostart
if A_IsAdmin ; if run the script as administrator, apply the autostart setting
{
	; Menu, SettingMenu, ToggleCheck, %TEXT_MenuAutostart%
	Menu, Tray, ToggleCheck, %TEXT_MenuAutostart%
	if IsAutostart
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %ScriptName%, %A_ScriptFullPath% ; enable autostart
	}
	else
	{
		RegDelete, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %ScriptName% ; disable autostart
	}
}

; try restart and run the script as administrator
; https://autohotkey.com/docs/commands/Run.htm#RunAs
full_command_line := DllCall("GetCommandLine", "str")
if !(A_IsAdmin || RegExMatch(full_command_line, " /restart(?!\S)"))
{
	try
	{
		if A_IsCompiled
		{
			Run *RunAs "%A_ScriptFullPath%" /restart
		}
		else
		{
			Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		}
		ExitApp
	}
}

; if run as administrator failed, rollback the autostart setting
if !A_IsAdmin
{
	IsAutostart := !IsAutostart
	Gosub, EnsureConfigDirExists
	IniWrite, %IsAutostart%, %ConfigFile%, Autostart, EnableAutostart
}
Return


	






return



; #2
SetIcon()
{
path := ConfigDir . "\theme.txt"
FileRead, path2, %path%
;       xxx.ico

path3 := ConfigDir . "\" . path2
; xxx\config\xxx.ico

Menu, Tray, Icon, %path3% 




return
}

turn_off() {
	Menu, Tray, Delete, &Switch

	Menu, Tray, Click, 1
	Menu, Tray, Add, &Switch, turn_on
	Menu, Tray, Default, &Switch


	set_blank_icon()
	CloseExes()
	return
}

turn_on() {
	Menu, Tray, Delete, &Switch

	Menu, Tray, Click, 1
	Menu, Tray, Add, &Switch, turn_off
	Menu, Tray, Default, &Switch


	SetIcon()
	run_exes()
	return
}


set_blank_icon(){

path3 := ConfigDir . "\" . "Blank.ico"

Menu, Tray, Icon, %path3%


return
}




Turquoise:

; 改altdrag文件，
; color_file.txt
; 152, 218, 226
; 237, 113, 97
; 18, 150, 219
; Turquoise 
; Sky
; Berry

path = %ConfigDir%\color_file.txt 
FileDelete, %path%

newContent := "152, 218, 226"
FileAppend, %newContent%, %path%
Process, Close, AltSnap.exe
Run, %ConfigDir%\AltSnap1.62src\AltSnap.exe -hide
; 改theme.txt文件

path := ConfigDir . "\theme.txt"
FileDelete, %path%

newContent := "Turquoise.ico"
FileAppend, %newContent%, %path%


; 设置图标
turn_on()
SetIcon()

return


Lake:

; 改altdrag文件，
; color_file.txt
; 152, 218, 226
; 18, 150, 219
; 237, 113, 97
; Turquoise 
; Sky
; Berry

path = %ConfigDir%\color_file.txt 
FileDelete, %path%

newContent := "18, 150, 219"
newContent := "127, 180, 249"
FileAppend, %newContent%, %path%
Process, Close, AltSnap.exe
Run, %ConfigDir%\AltSnap1.62src\AltSnap.exe -hide
; 改theme.txt文件

path := ConfigDir . "\theme.txt"
FileDelete, %path%
newContent := "Lake.ico"
FileAppend, %newContent%, %path%


; 设置图标
turn_on()
SetIcon()

return


return


Berry:

; 改altdrag文件，
; color_file.txt
; 152, 218, 226
; 237, 113, 97
; 18, 150, 219
; Turquoise 
; Sky
; Berry

path = %ConfigDir%\color_file.txt 
FileDelete, %path%

newContent := "237, 113, 97"
FileAppend, %newContent%, %path%
Process, Close, AltSnap.exe
Run, %ConfigDir%\AltSnap1.62src\AltSnap.exe -hide
; 改theme.txt文件

path := ConfigDir . "\theme.txt"
FileDelete, %path%
newContent := "Berry.ico"
FileAppend, %newContent%, %path%


; 设置图标
turn_on()
SetIcon()

return





ExitProgram:
ExitApp

; #2









