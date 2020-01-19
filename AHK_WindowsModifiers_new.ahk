;header1 (Check & Run in Admin Mode
{
	
{full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
}	
}
}
;header2 Environment stuff
{
#SingleInstance, Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir% 
Menu, Tray, Icon, shell32.dll, 101 ;
}


;-----------------------Functions-----------------------

;Accel-Scroll V1.3				MWheel
{
#MaxHotkeysPerInterval 120
Process, Priority, , H
SendMode Input

; Show scroll velocity as a tooltip while scrolling. 1 or 0.
tooltips := 0

; The length of a scrolling session.
; Keep scrolling within this time to accumulate boost.
; Default: 500. Recommended between 400 and 1000.
timeout := 600

; If you scroll a long distance in one session, apply additional boost factor.
; The higher the value, the longer it takes to activate, and the slower it accumulates.
; Set to zero to disable completely. Default: 30.
boost := 60

; Spamming applications with hundreds of individual scroll events can slow them down.
; This sets the maximum number of scrolls sent per click, i.e. max velocity. Default: 60.
limit := 60

; Runtime variables. Do not modify.
distance := 0
vmax := 1

; Key bindings
WheelUp::    Goto Scroll
WheelDown::  Goto Scroll
#WheelUp::   Suspend
#WheelDown:: Goto Quit

Scroll:
	t := A_TimeSincePriorHotkey
	if (A_PriorHotkey = A_ThisHotkey && t < timeout)
	{
		; Remember how many times we've scrolled in the current direction
		distance++

		; Calculate acceleration factor using a 1/x curve
		v := (t < 80 && t > 1) ? (250.0 / t) - 1 : 1

		; Apply boost
		if (boost > 1 && distance > boost)
		{
			; Hold onto the highest speed we've achieved during this boost
			if (v > vmax)
				vmax := v
			else
				v := vmax

			v *= distance / boost
		}

		; Validate
		v := (v > 1) ? ((v > limit) ? limit : Floor(v)) : 1

		if (v > 1 && tooltips)
			QuickToolTip("×"v, timeout)
		
		

		MouseClick, %A_ThisHotkey%, , , v
	}
	else
	{
		; Combo broken, so reset session variables
		distance := 0
		vmax := 1

		MouseClick %A_ThisHotkey%
	}
	return

Quit:
	QuickToolTip("Exiting Accelerated Scrolling...", 1000)
	Sleep 1000
	ExitApp

QuickToolTip(text, delay)
{
	ToolTip, %text%
	SetTimer ToolTipOff, %delay%
	return

	ToolTipOff:
	SetTimer ToolTipOff, Off
	ToolTip
	return
}

}


; Clip() - Send and Retrieve Text Using the Clipboard
{
Clip(Text="", Reselect="")
{
	Static BackUpClip, Stored, LastClip
	If (A_ThisLabel = A_ThisFunc) {
		If (Clipboard == LastClip)
			Clipboard := BackUpClip
		BackUpClip := LastClip := Stored := ""
	} Else {
		If !Stored {
			Stored := True
			BackUpClip := ClipboardAll ; ClipboardAll must be on its own line
		} Else
			SetTimer, %A_ThisFunc%, Off
		LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
		If (Text = "") {
			SendInput, ^c
			ClipWait, LongCopy ? 0.6 : 0.2, True
		} Else {
			Clipboard := LastClip := Text
			ClipWait, 10
			SendInput, ^v
		}
		SetTimer, %A_ThisFunc%, -700
		Sleep 20 ; Short sleep in case Clip() is followed by more keystrokes such as {Enter}
		If (Text = "")
			Return LastClip := Clipboard
		Else If ReSelect and ((ReSelect = True) or (StrLen(Text) < 3000))
			SendInput, % "{Shift Down}{Left " StrLen(StrReplace(Text, "`r")) "}{Shift Up}"
	}
	Return
	Clip:
	Return Clip()
}
}
*/

;-----------------------Misc-----------------------

;Always-on-Top					Win+Space
{
#SPACE::  Winset, Alwaysontop, , A
}

;#Notepad						Win+N
{
#n::
IfWinNotExist, ahk_class Notepad
Run, notepad.exe
WinActivate ahk_class Notepad
Return
}

;MoveWin to Mouse				^+F22
{
^+F22::
Coordmode Mouse, screen
MouseGetPos xPos, yPos
WinMove,A, , %xPos%, %yPos%, DEFAULT, DEFAULT
return
}

;Task Manager					RWin
{
RWin:: ^+Esc
return
}

;Lua Script Path for CE			#F3
{
#F4::
SendRaw, F:\New Folder\Inchoate_CV\Main\Scripts\Lua
return
}



;-----------------------forStreamDeck-----------------------
;Launch Premiere Pro			^+F13
{
^+F13::
switchToPremiere(){
IfWinNotExist, ahk_class Premiere Pro
	{
	Run, Adobe Premiere Pro.exe
	}
if WinActive("ahk_class Premiere Pro")
	{
	IfWinNotExist, ahk_exe Premiere Pro.exe
		{
		Run, Premiere Pro.exe
		sleep 200
		}
	WinActivate ahk_exe Premiere Pro.exe
	sleep 10
	WinActivate ahk_class Premiere Pro
	}
else
	WinActivate ahk_class Premiere Pro
sleep 2
send, {Rctrl up}
send, {Lctrl up}

}
}

;Launch LGS						^+F15
{
^+F15::
switchToLGS()
{
IfWinNotExist, ahk_exe LCore.exe
Run, C:\Program Files\Logitech Gaming Software\LCore.exe
WinWait, Logitech Gaming Software, 
if WinActive("ahk_exe LCore.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe LCore.exe

sleep 2
send, {Rctrl up}
send, {Lctrl up}
WinWaitActive, Logitech Gaming Software, 
	MouseClick, left,  223,  694
	sleep 20
	MouseClick, left,  223,  694
	sleep 20
	MouseClick, left,  355,  694
	sleep 400
	MouseClick, left,  535,  700
	sleep 250
	MouseClick, left,  535,  700
	return

}
}

;Launch Chrome					^+F16
{
^+F16::
switchToChrome()
{
IfWinNotExist, ahk_exe chrome.exe
	Run, chrome.exe

if WinActive("ahk_exe chrome.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe chrome.exe

sleep 2
send, {Rctrl up}
send, {Lctrl up}
}
}

;Launch Stream Deck				^+F17
{
^+F17::
switchToStreamDeck()
{
IfWinNotExist, ahk_exe StreamDeck.exe
	{
	Run, C:\Program Files\Elgato\StreamDeck\StreamDeck.exe
	}
else
	{
	WinActivate ahk_exe StreamDeck.exe
	}
	return
}
}

;Launch Notepad++				^+F18
{
^+F18::
switchToNotepad++()
{
IfWinNotExist, ahk_exe notepad++.exe
	{
	Run, C:\Program Files (x86)\Notepad++\notepad++.exe
	}
else
	{
	WinActivate ahk_exe notepad++.exe
	}
	return
}
}

;Launch WinWord					^+F19
{
^+F19::
switchToWord()
{
;tooltip, why
Process, Exist, WINWORD.EXE
	If errorLevel = 0
		Run, WINWORD.EXE
	else
		WinActivate ahk_class OpusApp
	}
sleep 2
send, {Rctrl up}
send, {Lctrl up}
}

;Launch Excel					^+F20
{
^+F20::
switchToExcel()
{
Process, Exist, EXCEL.EXE
;msgbox errorLevel `n%errorLevel%
	If errorLevel = 0
		Run, EXCEL.EXE
	else
		WinActivate ahk_class XLMAIN
	
;maybe need to unstick modifiers
sleep 2
send, {Rctrl up}
send, {Lctrl up}
;IDK if that even works...
}
}

;Launch PCSX2rr					^+F21
{
^+F21::
switchToPCSX2()
{

		WinActivate ahk_class GSWndDX
		WinWait	ahk_exe pcsx2.exe
		WinActivate ahk_exe pcsx2.exe
		WinActivate ahk_class ConsoleWindowClass
}
}

;Clip() StreamDeckkIconPath		#F2
{
#IfWinActive ahk_exe StreamDeck.exe
#F2::
#IfWinActive ahk_exe StreamDeck.exe
Clip("S:\I\Progs-S\`PC(2016.Win10)\`P1 Software\Stream Deck\Icons")
return
}



;-----------------------forPCSX2RR-----------------------

;ReCalc Add						#F1
{
#IfWinActive ahk_exe cheatengine-x86_64.exe
#F1::
Send {RButton}
sleep 100 
SendInput r
WinWait Recalculate addres
sleep 200
MouseClick, left,  160,  40
Send, ^a
sleep 10
Send, ^v 
sleep 30
Send {Enter}
sleep 100
WinWait Lua Engine
sleep 200
MouseMove, 0, 0 
return
}

;Clip() IncLua					#F2
{
#IfWinActive ahk_exe cheatengine-x86_64.exe
#F2::
#IfWinActive ahk_exe cheatengine-x86_64.exe
Clip("F:\New Folder\Inchoate_CV\Main\Scripts\Lua")
return
}


;-----------------------Photoshop-----------------------

;Automate Stuff 				#+F2

{	
#IfWinActive ahk_exe Photoshop.exe

^F13::
	Send +F2
	WinWait Save As, , 2
	SendInput {Enter}
	sleep, 1000
	SendInput {Enter}
	sleep 100
	return
}
;-----------------------Refresh-----------------------

;Refresh Script					#F5
{
#IfWinActive ahk_exe SciTE.exe	
#F5::
#IfWinActive ahk_exe SciTE.exe
Send ^{S}
sleep, 300
Send {F5}
return
}


