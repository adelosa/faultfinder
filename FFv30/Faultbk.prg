/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ VCR and TV Fault Finder                                          บ
บ Version 3.0 For DOS                                              บ
บ                                                                  บ
บ (C) 1995 A.J.D. Business Software                                บ
บ                                                                  บ
บ Faultbook module - faultbk.prg                                   บ
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
บ Search Screen - FaultBook Maintenance                            บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FbookMaintain()
LOCAL aList := GetValidData(GetFiles())
LOCAL cOldScreen

PRIVATE oFBook := ControlList():New()  // Do not declare LOCAL as 
                                       // required by event procedures
// Check that there were some files that match lookup specs.
// See ValCheck.prg for more information

IF LEN(aList)==0
        cOldScreen := ss():New(0,0,24,78)
        DrawGenNote("   No Valid faulbooks", ;
                    "   have been installed","")
        oFBook:add (Buttn():New (17,35,"   OK   ","FBPreCancel","FBPostCancel") )
        oFBook:read()
        cOldScreen:ReDisplay()
        RETURN
ENDIF

oFBook:add (ListB():New (9,24,aList,"Select FaultBook","FBPreList","",30,3) )
oFBook:add (Buttn():New (16,16,"  New   ","FBPreNew","FBPostNew") )
oFBook:add (Buttn():New (16,29," Delete ","FBPreDelete","FBPostDelete") )
oFBook:add (Buttn():New (16,42," Search ","FBPreSelect","FBPostSelect") )
oFBook:add (Buttn():New (16,55," Cancel ","FBPreCancel","FBPostCancel") )

oFBWin := WinBox():New(7,15,17,66,"FaultBooks")
oFBWin:SetExpand()
oFBWin:SetCloseBox()
oFBWin:SetLine()

oOldScreen := oFBWin:DrawWin()
oFBook:DisplayAll()
oFBook:read()

oOldScreen:ReDisplay()

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ FBPreList  -  If Listbox with faultbooks gets focus              บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FBPreList
DrawStatusBar("Select Faultbook to use from this list")
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ FBPreCancel  -  If Cancel Button gets focus                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FBPreCancel
DrawStatusBar("Return to Main Menu")
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ FBPostCancel  -  If Cancel Button looses focus                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FBPostCancel
IF oFBook:Action == CHANGE_NEXT        
        oFBook:Action = ENDREAD
ENDIF

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ FBPreDelete  -  If Delete Button gets focus                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FBPreDelete
DrawStatusBar("Delete the currently selected Faultbook")
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ FBPostDelete  -  If Delete Button looses focus                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FBPostDelete
IF oFBook:Action == CHANGE_NEXT        
        oFBook:Action = ENDREAD
ENDIF
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ FBPreNew  -  If Add Button gets focus                            บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FBPreNew
DrawStatusBar("Add a new blank Faultbook")
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ FBPostNew     -  If Add Button looses focus                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FBPostNew
IF oFBook:Action == CHANGE_NEXT        
        oFBook:Action = ENDREAD
ENDIF
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ FBPreSelect  -  If Select Button gets focus                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FBPreSelect
DrawStatusBar("Select the current Faultbook to search on")
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ FBPostSelect  -  If Select Button looses focus                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE FBPostSelect
PRIVATE MainHandle
IF oFBook:Action == CHANGE_NEXT        
        oFBWin:DisplayOff()
        SearchFault(oFBook:GetSelectString(1))  // Activates search screen
                                     // passing the value of the item selected
        oMenu:Action = CHANGE        // Stops the menu from 
                                     // progressing to next button
        oFBWin:DisplayOn()
ENDIF                                


RETURN

