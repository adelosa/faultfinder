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
#include "Inkey.ch"
#include "..\obcon\control.ch"
#include "..\obcon\obcon.ch"
/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Master Help program                                              บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE HelpOn

LOCAL SaveOld := SS():New(4, 0, 24, 79)
LOCAL OldColor
LOCAL LastArea := SELECT()
LOCAL Helpfile := "Help"

HelpBox := Winbox():New(5, 2, 21, 77,"Help Information")
HelpBox:SetLine()
ErrorBox := Winbox():New(10, 9, 16, 70,"Error")
SET KEY K_F1 TO 
DBUSEAREA( .T., "DBFNTX", helpfile, HelpHandle := UniNum() , .T. )
LOCATE FOR TRIM(HelpTopic) = TRIM(UPPER(cTopic))

OldColor := SETCOLOR(NOTI_COLOR)

IF FOUND()
        HelpBox:DrawWin()
        CT(21," <ESC> to Exit "+chr(24) + chr(25)+ " to view ")  
        MEMOEDIT(HelpInfo, 6, 15, 20, 64, .F.)
ELSE
        ErrorBox:DrawWin()
        CT(12,"No help was found for "+cTopic)
        CT(14,"Press any key to continue")
        ThisKey := INKEY(0)
ENDIF

DBSELECTAREA( HelpHandle )     
DBCLOSEAREA()
DBSELECTAREA( LastArea )

SaveOld:ReDisplay()
SETCOLOR(OldColor)

SET KEY K_F1 TO HelpOn(cTopic)
/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Procedure : HelpIndex                                            บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
// This is the help index which displays a list of help topics.
// The user can select a topic and view the help for the topic.

PROCEDURE HelpIndex

LOCAL aHelpIndex := {}
LOCAL OrigScreen := SaveScreen(7,19,17,60)
LOCAL OldTopic := cTopic
LOCAL Helpfile := "Help"
LOCAL aCombo[2] 
cTopic = "HELPINDEX"
aCombo[ACTION] = HELP

DBUSEAREA( .T., "DBFNTX", helpfile, HelpHandle := UniNum() , .T. )
DBSELECTAREA( HelpHandle )
DBGOTOP()

DO WHILE !EOF()
        AADD( aHelpIndex, HELPTOPIC )
        DBSKIP()
ENDDO

DBCLOSEAREA()

DrawBox(7,20,16,60)
CT(7,"Help Index")
CT(16,"< "+chr(24)+chr(25)+" Choose "+chr(27)+chr(217)+" Select >")

DO WHILE aCombo[ACTION] == HELP 

        aCombo := ComboBox(8,29,aHelpIndex,2,"Help Topics",.t.,.f.,0)

        IF aCombo[ACTION] != ENDREAD .AND. aCombo[ACTION] != HELP
                cTopic = aHelpIndex[aCombo[CHOICE]]
                HelpOn()
                cTopic = OldTopic
        ENDIF
        
        IF aCombo[ACTION] == HELP
                HelpOn()
        ENDIF

ENDDO

cTopic = OldTopic

RestScreen(7,19,17,60,OrigScreen)

RETURN
*/
