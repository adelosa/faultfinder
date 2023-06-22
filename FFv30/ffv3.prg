/*
������������������������������������������������������������������ͻ
� VCR and TV Fault Finder                                          �
� Version 3.0 For DOS                                              �
�                                                                  �
� (C) 1995 A.J.D. Business Software                                �
�                                                                  �
� Main Module - ffv3.prg                                           �
������������������������������������������������������������������ͼ
������������������������������������������������������������������ͻ
� Compiler includes                                                �
������������������������������������������������������������������ͼ
*/
#include "inkey.ch"
#include "oclip.ch"
#include "..\OBCON\control.ch"
#include "..\OBCON\obcon.ch"

/*
������������������������������������������������������������������ͻ
� Main Menu                                                        �
������������������������������������������������������������������ͼ
*/
LOCAL oStartScreen := SS():New(0,0,24,79)       // SaveScreen object
PUBLIC cTopic := "MAINMENU"

CLEAR SCREEN
@ 24,0 SAY "VCR and TV Fault Finder"            // Start message

SET CURSOR OFF                                  // Turn the cursor off
mInit()                                         // Turn the mouse on

SET KEY K_F1 TO HelpOn(cTopic)

oMenu := ControlList():New()
oMenu:add (Buttn():New (6,8, "     Search    ","MenuPreSearch","MenuPostSearch") )
oMenu:add (Buttn():New (9,8,"   Utilities   ","MenuPreUtil") )
oMenu:add (Buttn():New (12,8,"      Exit     ","MenuPreExit","MenuPostExit") )

BaseScreen("VCR and TV Fault Finder for DOS")
oMainBox := WinBox():New(2,3,19,74,"")
oMainBox:SetBackColor("n/w")
oMenuBox := WinBox():New(4,6,14,27,"Main Menu")
oMenuBox:SetLine()

oMainBox:DrawWin()                              // Draw the window
oMenuBox:DrawWin()                              // Draw the window
ShowCopyright()                                 // Show copyright info
oMenu:DisplayAll()

oMenu:read()

mEnd()          // Turn the mouse off

@ 24 , 0
oStartScreen:ReDisplay()

RETURN

/*
������������������������������������������������������������������ͻ
� MenuPostExit  -  If Exit Button looses focus                     �
������������������������������������������������������������������ͼ
*/
PROCEDURE MenuPostExit
IF oMenu:Action == CHANGE_NEXT         // Enter key (usually) pressed
        oExitBox := WinBox():New(11,30,13,50,"Goodbye")
        oExitBox:DrawWin()
        @ 12,34 SAY "Shutting Down" COLOR NOTI_COLOR
        oMenu:Action = ENDREAD         // End the read
ENDIF
RETURN

/*
������������������������������������������������������������������ͻ
� MenuPreExit  -  If Exit Button gets focus                        �
������������������������������������������������������������������ͼ
*/
PROCEDURE MenuPreExit
LOCAL Description  :={"This option will allow you to", ;
                      "", ;
                      " * Leave VCR and TV Fault Finder ", ;
                      "   and Return to DOS",;
                      "",;
                      " Choose this option to finish"}
                      
MenuDescript(Description)
DrawStatusBar("Exit to DOS")
RETURN
/*
������������������������������������������������������������������ͻ
� MenuPostSearch - If Faultbook Button looses focus                �
������������������������������������������������������������������ͼ
*/
PROCEDURE MenuPostSearch
IF oMenu:Action == CHANGE_NEXT          // Enter pressed
        oMenuBox:DisplayOff()           // Deactivate window
        FbookMaintain()                 // Activates Faultbook screen
        oMenuBox:DisplayOn()            // Activates window
        oMenu:Action = CHANGE           // Stops the menu from 
                                        // progressing to next button
ENDIF

RETURN

/*
������������������������������������������������������������������ͻ
� MenuPreSearch  - If Search Button gets focus                     �
������������������������������������������������������������������ͼ
*/
PROCEDURE MenuPreSearch
LOCAL Description  :={"This option will allow you to", ;
                      "",;
                      " *  Create Faultbooks", ;
                      " *  Delete Faultbooks", ;
                      " *  Search Faultbooks", ;
                      "", ;
                      "Enter this option to search for Faults"}
MenuDescript(Description)
DrawStatusBar("Search for Fault Information")
RETURN

/*
������������������������������������������������������������������ͻ
� MenuPreUtil   - If Utility Button gets focus                     �
������������������������������������������������������������������ͼ
*/
PROCEDURE MenuPreUtil
LOCAL Description  :={"This option will allow you to", ;
                      "",;
                      " *  Reindex Faultbooks", ;
                      " *  Create Disk for Sending", ;
                      " *  Purge your user area"}
MenuDescript(Description)
DrawStatusBar("Utilities for maintaining the system")

RETURN

/*
������������������������������������������������������������������ͻ
� MenuDescript   - Shows descriptions on screen                    �
������������������������������������������������������������������ͼ
*/
FUNCTION MenuDescript(aDescList)
NoOfLines := LEN(aDescList)
Counter   := 1

SETCOLOR(WIN_COLOR)
@ 4,32 to 4,70
@ 14,32 to 14,70
@ 6,34 CLEAR TO 13,73 

DO WHILE Counter <= NoOfLines 
        @ 5 + Counter,34 say aDescList[Counter]
        Counter++
ENDDO

RETURN .T.

/*
������������������������������������������������������������������ͻ
� ShowCopyright   - Shows copyright info                           �
������������������������������������������������������������������ͼ
*/

FUNCTION ShowCopyright()
SETCOLOR("R/W")
@ 17,8 SAY "(C)Copyright A.J.D. Business Software 1995" 
@ 18,8 SAY "All Rights Reserved"
RETURN .T.

