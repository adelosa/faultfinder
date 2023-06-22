/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ VCR and TV Fault Finder                                          บ
บ Version 3.0 For DOS                                              บ
บ                                                                  บ
บ (C) 1995 A.J.D. Business Software                                บ
บ                                                                  บ
บ General Notice module - gennote.prg                              บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Compiler includes                                                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

#include "oclip.ch"
#include "..\OBCON\control.ch"
#include "..\OBCON\obcon.ch"

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ General Status Screen -                                          บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE DrawGenStatus(cLine1,cLine2,cLine3)

LOCAL cGenScreen

// PRIVATE GenNote := ControlList():New()  // Do not declare LOCAL as 
                                       // required by event procedures
// GenNote:add (Buttn():New (17,45,"   OK   ","GenPreCancel","GenPostCancel") )

GenWin := WinBox():New(10,25,18,56,"Status")
GenWin:SetExpand()
GenWin:SetLine()
cGenScreen := GenWin:DrawWin()
// GenNote:DisplayAll()

DrawNoticeText()
@ 13,33 say cLine1  COLOR NOTI_COLOR
@ 14,33 say cLine2  COLOR NOTI_COLOR
@ 16,33 say cLine3  COLOR NOTI_COLOR

// GenNote:read()

RETURN cGenScreen


/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ GenPreCancel  -  If Cancel Button gets focus                     บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE GenPreCancel
DrawStatusBar("Return to program")
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ GenPostCancel  -  If Cancel Button looses focus                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE GenPostCancel
IF GenNote:Action == CHANGE_NEXT        
        GenNote:Action = ENDREAD
ENDIF

RETURN


/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ DrawNoticeText  -  Text to display on screen                     บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE DrawNoticeText
@ 12,27 say REPLICATE("Û",5) COLOR "rb/RG"
@ 13,27 say REPLICATE("Û",5) COLOR "rb/RG"
@ 14,27 say REPLICATE("Û",5) COLOR "rb/RG"
@ 15,27 say REPLICATE("Û",5) COLOR "rb/RG"
@ 16,27 say REPLICATE("Û",5) COLOR "rb/RG"
@ 17,27 say REPLICATE("Û",5) COLOR "rb/RG"
//gr+
@ 13,29 say "Û" COLOR NOTI_COLOR
@ 14,29 say "Û" COLOR NOTI_COLOR
@ 16,29 say "Û" COLOR NOTI_COLOR
RETURN
