#include "Inkey.ch"
#include "control.h"
*-------------------------------------
// Master Help program
// Developed by A.Delosa for
// 
// (C) 1994 A.J.D. Business Software
// All rights Reserved
//
*-------------------------------------
PROCEDURE HelpOn

LOCAL HelpScreen := SAVESCREEN(4, 0, 24, 79)
LOCAL OldColor
LOCAL LastArea := SELECT()
LOCAL Helpfile := "Help"

SET KEY K_F1 TO 
DBUSEAREA( .T., "DBFNTX", helpfile, HelpHandle := UniNum() , .T. )
LOCATE FOR TRIM(HelpTopic) = TRIM(UPPER(cTopic))

OldColor := SETCOLOR(WIN_COLOR)

IF FOUND()
        XDrawBox(5, 2, 21, 77)
        CT(5," Help Information ")
        CT(21," <ESC> to Exit "+chr(24) + chr(25)+ " to view ")  
        MEMOEDIT(HelpInfo, 6, 15, 20, 64, .F.)
ELSE
        XDrawBox(10, 9, 16, 70)
        CT(12,"No help was found for "+cTopic)
        CT(14,"Press any key to continue")
        ThisKey := INKEY(0)
ENDIF

DBSELECTAREA( HelpHandle )     
DBCLOSEAREA()
DBSELECTAREA( LastArea )

RESTSCREEN( 4, 0, 24, 79, HelpScreen)
SETCOLOR(OldColor)

SET KEY K_F1 TO HelpOn(cTopic)

*-----------------------------------
PROCEDURE HelpIndex
*-----------------------------------
// This is the help index which displays a list of help topics.
// The user can select a topic and view the help for the topic.

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
