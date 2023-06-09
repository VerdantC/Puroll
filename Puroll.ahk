; alter
#SingleInstance force
#Persistent

SetWorkingDir %A_ScriptDir% ; ensure a consistent starting directory


Menu, Tray, Tip, Puroll

; ScriptName := "CClose"
ScriptName := "Puroll"



ConfigDir := A_WorkingDir . "\" . "config"
ConfigFile := ConfigDir . "\" . ScriptName . ".ini"

; LangFile := "lang.ini"

; ; set the script language
; if (A_Language == "0804") ; https://autohotkey.com/docs/misc/Languages.htm
;     {
;         Language := "Chinese"
;     }
;     else ; use English by default
;     {
;         Language := "English"
;     }

 

; IniRead, TEXT_MenuAutostart, %LangFile%, %Language%, TEXT_MenuAutostart, Run %ScriptName% on system startup

TEXT_MenuAutostart = Start with Windows









; Menu, Tray, NoStandard ; remove the standard menu items
; Menu, Tray, Add
; Menu, SettingMenu, Add, %TEXT_MenuAutostart%, AutostartProgram

Menu, Tray, NoStandard

Menu, Tray, Add, %TEXT_MenuAutostart%, AutostartProgram

Menu, Tray, Add, Exit, ExitProgram


Run, %A_WorkingDir%\opt\AltSnap.exe -hide

Run, %A_WorkingDir%\opt\CClose.exe
Run, %A_WorkingDir%\opt\MouseWheel.exe
CloseExes() {
    Process, Close, AltSnap.exe
    Process, Close, CClose.exe
    Process, Close, MouseWheel.exe
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


	

ExitProgram:
ExitApp



