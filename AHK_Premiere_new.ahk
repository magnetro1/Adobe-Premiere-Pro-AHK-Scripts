;-----------------------Header-----------------------
{#SingleInstance Force
#IfWinActive ahk_exe Adobe Premiere Pro.exe
Menu, Tray, Icon, shell32.dll, 16
}
;-----------------------Misc-----------------------
{
;Auto-Remove-Keyframe-Message
{
DetectHiddenText, On
yesRemoveKeyframes:
WinWait, Warning ahk_exe Adobe Premiere Pro.exe
sleep 30
sendinput, {enter}
sleep 900
goto yesRemoveKeyframes
}

;MButton for Hand Tool
{
MButton::
#IfWinExist ahk_exe Adobe Premiere Pro.exe
Send, {h}{LButton Down} 
KeyWait, MButton, 
SendInput, {LButton Up}{v}
Return
}

;Change Drag Speed
{
#IfWinExist ahk_exe Adobe Premiere Pro.exe

~LButton::
If WinActive("ahk_exe Adobe Premiere Pro.exe") DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 11, UInt, 0) 
Return

~LButton Up::
DllCall("SystemParametersInfo", UInt, 0x70, UInt, 0, UInt, MOUSE_NOW, UInt, 0)
If MOUSE_NOW != 10 ; Check if the speed is not default, adjust this as needed. DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, UInt, 10, UInt, 0) ; Default Windows 6 Ticks [10], adjust this as needed.
Return
}


;Fake FX Console
{
#IfWinActive ahk_exe Adobe Premiere Pro.exe
+Tab::
#IfWinActive ahk_exe Adobe Premiere Pro.exe
Send +7
sleep 10
Send +f
Sleep 10
Send +{backspace}
BlockInput, on
BlockInput, MouseMove
ControlGetPos, X, Y, Width, Height, Edit1, ahk_class Premiere Pro
MouseMove, X-13, Y+2, 0 
BlockInput, Off
BlockInput, MouseMoveOff
return
}
}


;-----------------------Functions-----------------------
{
;Apply Preset

preset(name)
{
SetKeyDelay, 0
MouseGetPos, xpos, ypos 
BlockInput, on
BlockInput, MouseMove
ControlGetPos, X, Y, Width, Height, Edit1, ahk_class Premiere Pro
MouseMove, X-13, Y+2, 0
sleep 10
MouseClick, left, , , 1
sleep 10
Send +{backspace}
sleep 10
Send %name%
sleep 10
MouseMove, 40, 75, 0, R
MouseClickDrag, Left, , , %xpos%, %ypos%, 0
sleep 10
BlockInput, off
BlockInput, MouseMoveOff
}


;Apply Video Transition
{
Vtransition(name)
{
SetKeyDelay, 0
MouseGetPos, xpos, ypos 
BlockInput, on
BlockInput, MouseMove
ControlGetPos, X, Y, Width, Height, Edit1, ahk_class Premiere Pro
MouseMove, X-13, Y+2, 0 
MouseClick, left, , , 1
sleep 10
Send +{backspace}
sleep 10
Send %name%
sleep 10
MouseMove, 40, 175, 0, R
MouseClick, right
Send {down} 
Send {enter}
Send ^d
sleep 10
MouseMove, %xpos%, %ypos%, 0
BlockInput, off
BlockInput, MouseMoveOff
}
}

;Apply Audio Transition
{
Atransition(name)
{
SetKeyDelay, 0
MouseGetPos, xpos, ypos 
BlockInput, on
BlockInput, MouseMove
ControlGetPos, X, Y, Width, Height, Edit1, ahk_class Premiere Pro
MouseMove, X-13, Y+2, 0
MouseClick, left, , , 1
sleep 10
Send +{backspace} 
sleep 10
Send %name%
sleep 10
MouseMove, 35, 135, 0, R 
MouseClick, right
Send {down}
Send {enter}
Send ^+d 
sleep 10
MouseMove, %xpos%, %ypos%, 0
BlockInput, off
BlockInput, MouseMoveOff 
}
}

;Sequence Search
{
sequence(name){
SendInput +1
SendInput +f
sleep 10
SendInput ^a
SendInput +{backspace}
sleep 200
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, Adobe_Premiere_Pro_NSClRGsftQ.png
if (ErrorLevel = 2)
    MsgBox Could not conduct the search.
else if (ErrorLevel = 1)
    MsgBox Icon could not be found on the screen.
else
   BlockInput, on
   BlockInput, MouseMove
   MouseMove, %FoundX%,%FoundY% 0
   MouseMove, +55, +255, 0, R
   send %name%
   BlockInput, off
   BlockInput, MouseMoveOff
sleep 550
ImageSearch, FoundXX, FoundYY, 0, 0, A_ScreenWidth, A_ScreenHeight, Adobe_Premiere_Pro_QM9h2IHn0L.png
if (ErrorLevel = 2)
    MsgBox Could not conduct the search.
else if (ErrorLevel = 1)
    MsgBox Icon could not be found on the screen.
else
      MouseMove, %FoundXX%,%FoundYY%, 0
      MouseMove, +7, +5, 0, R
      sleep, 200
MouseClick Left
sleep 100
MouseClick Left
sleep 220
sendInput +1
SendInput +f
SendInput ^a
SendInput +{backspace}
sleep 100

   }}
}


;-----------------------Call Functions-------------------

{
+F1::
sequence("Dhalsim Revisited Process Video Arrange")
return

+F2::
sequence("01: PCSX2-Combo Creation")
return

F13::
Atransition("exponential fade")
Return

F14::
Atransition("constant power")
Return

F15::
Vtransition("cross dissolve") 
Return

F16::
preset("Crop_Preset_Test") 
Return

F17::
preset("scale-50%")
Return

F18::
Vtransition("cross zoom")
Return

F19::
Vtransition("exposureblur")
Return

F20::
Vtransition("swish pan")
Return

F21::
preset("Zoom_abs_.6")
Return

F22::
preset("AC_Remove")
return

+F13::
preset("uni.Blur_15")
Return

+F14::
preset("B&C_SS")
return

+F15::
preset("Transform Default")
return

+F16::
preset("unmult_26")
return
}
