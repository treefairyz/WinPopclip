#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
#InstallMouseHook
AutoTrim, Off
CoordMode, Mouse, Screen
DetectHiddenWindows, On
ListLines Off
SendMode, Input ; Recommended for new scripts due to its superior speed and reliability.
SetBatchLines -1
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

winTitle:="WinClipTitle"
dpiRatio:=A_ScreenDPI/96
controlHight:=75
winHeightPx:=controlHight*dpiRatio
bGColor:="white"
fontColor:="ffffff"
ver:="0.9"
fontSize:=12
fontFamily:="微软雅黑"
userLanguage:="zh-CN"
SyncPath:="E:\Dropbox"
SysGet, VirtualWidth, 78  ;虚拟屏幕的宽度和高度
SysGet, VirtualHeight, 79

Loop, read, %A_ScriptDir%/White List.txt
{
    GroupAdd, whiteList, ahk_exe %A_LoopReadLine%
}

ToolWindow:
    Gui, +ToolWindow -Caption +AlwaysOnTop ; -DPIScale
    Gui, Color, %bGColor%
    Gui, font, s%fontSize% c%fontColor%, %fontFamily%
    Gui, Add, Text, x0 y0 w0 h%controlHight%, ; 初始定位
    ;Gui, Add, Text, xcurPosX/2 ycurPosY-115 w0 h%controlHight%, ; 初始定位
    ;Gui, Add, Text, x%curPos%  y%curPosY%-115 w0 h%controlHight%, ; 初始定位
;MsgBox, %ClipBoard%
    If ClipBoard in ,%A_Space%,%A_Tab%,`r`n,`r,`n
    {
        If (winClipToggle=1)
        {
            Gui, Add, Button, x+0 yp hp gSelectAll w25, all
            Gui, Add, Button, x+0 yp hp gPaste, paste
            Gui, Add, Button, x+0 yp hp wp gToLogseq, Logseq
        }
    }
    Else
    {
        Gui, Add, Button, x+0 w25 h25, 1
        Gui, Add, Button, x+0 wp hp, 2
        Gui, Add, Button, x+0 wp hp, 3
        Gui, Add, Button, x+0 wp hp, 4
        Gui, Add, Button, x+0 wp hp, 5
        Gui, Add, Button, x+0 wp hp, 6
        Gui, Add, Button, x+0 wp hp, 7
        Gui, Add, Button, x+0 wp hp, 8
        Gui, Add, Button, x+0 wp hp, 9
        Gui, Add, Button, x+0 wp hp, 10
        Gui, Add, Button, x+0 wp hp, 11
        Gui, Add, Button, x+0 wp hp, 12
        Gui, Add, Button, x+0 wp hp gGoogleSearch, G
        Gui, Add, Button, x+0 yp hp vgTranslate gGoogleTranslate, G翻
        Gui, Add, Button, x+0 yp hp vdTranslate gDeepLTranslate, D翻
        Gui, Add, Button, xm-16 yp+25 h25 gSelectAll wp, all
        ; If (winClipToggle=1)
        ; {
            Gui, Add, Button, x+0 yp hp gCut, cut
            Gui, Add, Button, x+0 yp hp gCopy, copy
            Gui, Add, Button, x+0 yp hp gPaste, paste
            Gui, Add, Button, x+0 yp hp gToLogseq, Logseq
 
            Gui, Add, Button, x+0 yp hp gPLink,[[]]
            Gui, Add, Button, x+0 yp hp gLCode,```` 
            Gui, Add, Button, x+0 yp hp gHighlight,hlight
        ; }
        ; Else
            ; Gui, Add, Button, x+0 yp hp gCopy, copy
        
        Gui, Add, Button, xm-16 yp+25 w40 h25 g缺点, 缺点
        Gui, Add, Button, x+0 yp wp hp g优点, 优点
        Gui, Add, Button, x+0 yp wp hp g概念, 概念
        Gui, Add, Button, x+0 yp wp hp g注意, 注意
        Gui, Add, Button, x+0 yp wp hp g次重, 次重
        Gui, Add, Button, x+0 yp wp hp g重点, 重点
        Gui, Add, Button, x+0 yp wp hp g结论, 结论
        Gui, Add, Button, x+0 yp wp hp gtips, tips
        Gui, Add, Button, x+0 yp wp hp g有用, 有用
    }
Return

#IfWinNotActive, ahk_group whiteList
~LButton::
    ;Gui,Destroy
    Gui,Hide
Return
#IfWinNotActive

#IfWinActive, ahk_group whiteList
    ; 如果不在脚本界面状态下
$LButton::
    ; ToolTip, %win% %A_TickCount%, 0,0
    ; 获得鼠标当前坐标
    MouseGetPos, perPosX, perPosY
    ; 获得当前时间
    preTime:=A_TickCount
    If (A_Cursor="IBeam")
        winClipToggle:=1

    Send, {LButton Down}
    KeyWait, LButton
    Send, {LButton Up}

    If (A_Cursor="IBeam")
        winClipToggle:=1

    If !WinActive(winTitle)
    {
        win:= WinExist("A")
        ShowMainGui(perPosX,perPosY,preTime) 
    }
Return
#IfWinActive

ShowMainGui(perPosX,perPosY,preTime)
{
    global
    ; 获得当前时间
    ;curTime:=A_TickCount
    ; 当前时间减去之前时间
    ;lButtonDownDelay:=curTime-preTime

    ; 获得鼠标当前坐标
    MouseGetPos, curPosX, curPosY

    guiShowX:=curPosX
    guiShowY:=curPosY-winHeightPx*2 ;*dpiRatio

    ;If (A_TimeSincePriorHotkey < 410) && (A_Cursor="IBeam")
    ;{
        ;GetSelectText(0)
        ;ShowWinclip()
    ;}
    ;Else if (lButtonDownDelay > 250 && winClipToggle=1) || (lButtonDownDelay > 350)
    ;{
        ; 从左向右拖选拖动一段距离才触发浮动工具栏，Y大于10, 在当前坐标弹出界面
        If (curPosX-perPosX>10)       ; || (curPosY-perPosY>10)
        {
            GetSelectText()
            ShowWinclip()
        }
        else if (perPosX-curPosX>10)    ;从右向左拖选拖动一段距离才触发直接复制
            GetSelectText()
        ;if WinActive("ahk_exe chrome.exe") && (perPosY-curPosY>10)   ;在chrome中从下往上拖动，是复制链接和标题为markdown的形式
        ;{
            ;ToolTip,%Clipboard%
            ;FormatTime,today,,YYYY-MM-DD
            ;ToolTip,%Clipboard%-%today%
            ;SetTimer,CleanTip,1000
            ;FileAppend,%Clipboard%,E:\GitHub\Logseq\journals\%today%.md,UTF-8
        ;}
    ;}
    Else
        Gui,Hide
        ;Gui, Destroy
    winClipToggle:=0
}

GetSelectText()
{
    global
    ;if !(noClipSaved="1")   ;如果是保存到其他剪贴板，就要保存之前剪贴板，否则直接复制，不保存之前的剪贴板
        ;ClipSaved:=ClipBoardAll
    ClipBoard:=""
    ; PostMessage, 0x301, , , , ahk_id %win% 
    ; PostMessage WM_COPY not work for some windows (even steam or notepad and more), why?
    Send, {CtrlDown}c
    ClipWait 0.1
    Send, {CtrlUp}
    If ErrorLevel    ;如果粘贴板里面没有内容，则判断是否有窗口定义
    {
        Send, ^c
        ClipWait,0.1
        If ErrorLevel
        {
            ToolTip, 尝试复制到剪贴板失败。
            SetTimer, CleanTip, 1000
        }
    }
    else {
        Clipboard_StrLen:=StrLen(Clipboard)  ;如果剪贴板内容太长，就要截取头尾来显示，免得太长挡住视野。
        IfGreater,Clipboard_StrLen,200
        {
            StringLeft,Clipboard_left,Clipboard,50
            StringRight,Clipboard_Right,Clipboard,50
            ToolTip, 复制成功：`n%Clipboard_left%`n…`n%Clipboard_Right%,
        }
        else
            ToolTip, 复制成功：%Clipboard%
        SetTimer, CleanTip, 1000
        }

    ;selectText:=ClipBoard
    ;if !(noClipSaved=1){   ;如果是保存到其他剪贴板，就要保存之前剪贴板，否则直接复制，不保存之前的剪贴板
        ;ClipBoard:=""
        ;ClipBoard:=ClipSaved
        ;ClipSaved:=""
        ;}
}

ShowWinclip()
{
    global
    local x,y,w,h,winMoveX,winMoveY
    ; Gui, Destroy
    
    ;Gui, font
    Gui, Show, NA AutoSize x%guiShowX% y%guiShowY%, %winTitle%
    ;WinSet, TransColor, white 250, %winTitle%
    WinGetPos , x, y, w, h, %winTitle%  ;w h 用来保存浮动工具栏的宽度和高度的变量名.


    winMoveX:=x-w/2,0
    ;If (winMoveX > VirtualWidth-w+15*dpiRatio)   ;VirtualWidth=虚拟屏幕的宽度
        ;winMoveX:=VirtualWidth-w+15*dpiRatio
    If (winMoveX<0)
        winMoveX=0
    
    ;winMoveY:=Max(y,0)
    winMoveY:=curPosY-115
    ;MsgBox % winMoveY
    WinMove, %winTitle%, , winMoveX, winMoveY, w-15*dpiRatio, %winHeightPx%
    ;WinMove, %winTitle%, , curPosX, curPosY, w-15*dpiRatio, %winHeightPx%
    ;SetTimer,GuiClose,10000
}

GoogleSearch:
{    Gui, Destroy
    urlEncodedText:=UriEncode(ClipBoard)
    Run, https://www.google.com/search?ie=utf-8&oe=utf-8&q=%urlEncodedText%
Return
}
SelectAll:
{    Gui, Destroy
    WinActivate, ahk_id %win%
    WinWaitActive, ahk_id %win%
    Send, {CtrlDown}a
    Sleep, 100
    Send, {CtrlUp}
    GetSelectText()
    ShowWinclip()
Return
}
Copy:
{    Gui, Destroy
    WinActivate, ahk_id %win%
    WinWaitActive, ahk_id %win%
    ;ClipBoard:=""
    ;ClipBoard:=ClipBoard
    ;If (FileExist(SyncPath))
    ;{
        ;FileSetAttrib, -R, %SyncPath%\WinPopclip
        ;FileDelete, %SyncPath%\WinPopclip
        ;FileAppend,
        ;(
        ;%ClipBoard%
        ;), %SyncPath%\WinPopclip
    ;}
Return
}
Cut:
    Gosub, Copy
    Send, {Del}
Return

Paste:
{    Gui, Destroy
Gosub, Copy
    WinActivate, ahk_id %win%
    WinWaitActive, ahk_id %win%
    Send, {CtrlDown}v
    Sleep, 100
    Send, {CtrlUp}
Return
}

GoogleTranslate:
{    Gui, Destroy
    ClipBoard:=UriEncode(ClipBoard)
    Run, https://translate.google.com/#view=home&op=translate&sl=auto&tl=%userLanguage%&text=%ClipBoard%
Return
}
DeepLTranslate:
{    Gui, Destroy
    ClipBoard:=UriEncode(ClipBoard)
    Run, https://www.deepl.com/translator#auto/%userLanguage%/%ClipBoard%
Return
}
; from http://the-automator.com/parse-url-parameters/
UriEncode(Uri, RE="[0-9A-Za-z]"){
    VarSetCapacity(Var,StrPut(Uri,"UTF-8"),0),StrPut(Uri,&Var,"UTF-8")
    While Code:=NumGet(Var,A_Index-1,"UChar")
        Res.=(Chr:=Chr(Code))~=RE?Chr:Format("%{:02X}",Code)

    Res:=StrReplace(Res, "&", "%26")
    Res:=StrReplace(Res, "`n", "%0A")
Return,Res
}

TransBox(text,originalLang,tragetLang) {
    pwb := ComObjCreate("InternetExplorer.Application")
    pwb.Visible := False
    pwb.Navigate("https://translate.google.com/#view=home&op=translate&sl=" . originalLang . "&tl=" . tragetLang . "&text=" text)

    Loop {
        IfWinExist, ahk_exe iexplorer.exe
            Process, Close, iexplorer.exe
        else
            break
    } While pwb.readyState != 4 || pwb.document.readyState != "complete" || pwb.busy

    Sleep, 1
    result := pwb.document.all.result_box.InnerText
    pwb.Quit

return, result
} 

PLink:
{    
Gosub, Copy
    ;ClipBoard:=""
    ClipBoard:="[[" ClipBoard "]]"
    Send, {CtrlDown}v
    Sleep, 100
    Send, {CtrlUp}
Return
}
LCode:
{
Gosub, Copy
    ;ClipBoard:=""
    ClipBoard:="``" ClipBoard "``"
    Send, {CtrlDown}v
    Sleep, 100
    Send, {CtrlUp}
Return
}
Highlight:
    Gosub, Copy
    Send, ^+h
Return

PageLink(){
; WinActivate()
; CopyToClipboard()
ClipBoard:="[[" ClipBoard "]]"
Send, ^v
}
Code(){
; WinActivate()
; CopyToClipboard()
ClipBoard:="``" ClipBoard "``"
Send, ^v
}

重点:
SelectedAddStyle4Logseq("重点")
Send, ^v
return
次重:
SelectedAddStyle4Logseq("次重")
Send, ^v
return
注意:
SelectedAddStyle4Logseq("注意")
return
概念:
SelectedAddStyle4Logseq("概念")
return
结论:
SelectedAddStyle4Logseq("结论")
return
优点:
SelectedAddStyle4Logseq("优点")
return
问题:
SelectedAddStyle4Logseq("问题")
return
缺点:
SelectedAddStyle4Logseq("缺点")
return
tips:
SelectedAddStyle4Logseq("tips")
return
有用:
SelectedAddStyle4Logseq("有用")
return
警惕:
SelectedAddStyle4Logseq("警惕")
return
笔记:
SelectedAddStyle4Logseq("笔记")
return
分析:
SelectedAddStyle4Logseq("分析")
return
方法:
SelectedAddStyle4Logseq("方法")
return
一般定义:
SelectedAddStyle4Logseq("一般定义")
return
描述:
SelectedAddStyle4Logseq("描述")
return
注释:
SelectedAddStyle4Logseq("注释")
Send, ^v
Send,{Left}
return

SelectedAddStyle4Logseq(Style){
    global win
    Gosub, Copy
    ; WinActivate,%win%
    ; WinActivate() ;激活当前窗口
    ; CopyToClipboard()
    ; ToolTip, %Clipboard%,330,330,3
    ; MsgBox,%ActiveWinID%-%Clipboard%
    ; Selected=%Clipboard%
    ; ToolTip, %Selected%,330,330,3
    If Clipboard contains ](重点),](次重),](注意),](概念),](结论),](优点),](问题),](缺点),](tips),](有用),](警惕),](笔记),](分析),](方法),](一般定义),](描述),](注:
    {
        if (Style="注释")
            replace=[$1](注:)
        else
            replace=[$1](%Style%)
        ; Clipboard:=RegExReplace(Clipboard, "\[([\s\S]+?)\]\(\S+\)$", replace)  ;只匹配最后一个括号，免得把其他链接也去除了。
        Clipboard:=RegExReplace(Clipboard, "\[([\s\S]+?)\]\(\S+\)", replace)
    }
    else{
        if (Style="注释")
            ClipBoard:="[" ClipBoard "](注:)"
        else
            ClipBoard:="[" ClipBoard "](" Style ")"
    }
    ; MsgBox,%win%-%Clipboard%
    ; Send, ^v
    ; if (Style="注释")
        ; Send,{Left}
}
SelectedRemoveStyle4Logseq(){   ;只能一次去除一个样式，同时去除多个会把第一个 [] 之后的 [] 中的字去掉
    If Clipboard contains ](重点),](次重),](注意),](概念),](结论),](优点),](问题),](缺点),](tips),](有用),](警惕),](笔记),](分析),](方法),](一般定义),](描述),](注:
        ; Clipboard:=RegExReplace(Clipboard, "\[([\s\S]+?)\]\(\S+\)$", "$1")  ；
        Clipboard:=RegExReplace(Clipboard, "\[([\s\S]+?)\]\(\S+\)", "$1")
    Send, ^v
}

Highlight(){
IfWinActive, ahk_exe Logseq.exe
    Send,^+h
else{
    ClipBoard:="^^" ClipBoard "^^"
    Send, ^v
    }
}
粗体(){
    IfWinActive, ahk_exe Logseq.exe
        Send,^b
    else{
        ClipBoard:="**" ClipBoard "**"
        Send, ^v
    }
}
斜体(){
IfWinActive, ahk_exe Logseq.exe
    Send,^i
else{
    ClipBoard:="_" ClipBoard "_"
    Send, ^v
    }
}



ToLogseq:
Gosub, Copy
FormatTime,today,,yyyy_MM_dd
;FormatTime,currentTime,,HH:mm:ss
;Clipboard=%currentTime% %Clipboard%
ToolTip,%Clipboard%-%today%
SetTimer,CleanTip,1000
FileAppend,`r`n-%A_Space%%Clipboard%,E:\GitHub\Logseq\journals\%today%.md,UTF-8
Return

GuiEscape:
GuiClose:
SetTimer,GuiClose,Off
Gui, Destroy
Return


CleanTip:  ;~ 顾名思义，移除提示信息。
{SetTimer, CleanTip, Off
ToolTip
TrayTip
ToolTip=
Return
}
;___以下调试脚本方便用，完成后可删___
#IfWinActive,ahk_exe AutoAHK.exe
AppsKey & RCtrl::Reload
#IfWinActive,ahk_class SciTEWindow
AppsKey & RCtrl::Reload