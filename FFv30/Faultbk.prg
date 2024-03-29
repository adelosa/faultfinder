/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί VCR and TV Fault Finder                                          Ί
Ί Version 3.0 For DOS                                              Ί
Ί                                                                  Ί
Ί (C) 1995 A.J.D. Business Software                                Ί
Ί                                                                  Ί
Ί Faultbook module - faultbk.prg                                   Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί Compiler includes                                                Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
*/

#include "oclip.ch"
#include "..\OBCON\control.ch"
#include "..\OBCON\obcon.ch"

/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί Search Screen - FaultBook Maintenance                            Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
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
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί FBPreList  -  If Listbox with faultbooks gets focus              Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
*/
PROCEDURE FBPreList
DrawStatusBar("Select Faultbook to use from this list")
RETURN

/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί FBPreCancel  -  If Cancel Button gets focus                      Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
*/
PROCEDURE FBPreCancel
DrawStatusBar("Return to Main Menu")
RETURN

/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί FBPostCancel  -  If Cancel Button looses focus                   Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
*/
PROCEDURE FBPostCancel
IF oFBook:Action == CHANGE_NEXT        
        oFBook:Action = ENDREAD
ENDIF

RETURN

/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί FBPreDelete  -  If Delete Button gets focus                      Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
*/
PROCEDURE FBPreDelete
DrawStatusBar("Delete the currently selected Faultbook")
RETURN

/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί FBPostDelete  -  If Delete Button looses focus                   Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
*/
PROCEDURE FBPostDelete
IF oFBook:Action == CHANGE_NEXT        
        oFBook:Action = ENDREAD
ENDIF
RETURN

/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί FBPreNew  -  If Add Button gets focus                            Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
*/
PROCEDURE FBPreNew
DrawStatusBar("Add a new blank Faultbook")
RETURN

/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί FBPostNew     -  If Add Button looses focus                      Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
*/
PROCEDURE FBPostNew
IF oFBook:Action == CHANGE_NEXT        
        oFBook:Action = ENDREAD
ENDIF
RETURN

/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί FBPreSelect  -  If Select Button gets focus                      Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
*/
PROCEDURE FBPreSelect
DrawStatusBar("Select the current Faultbook to search on")
RETURN

/*
ΙΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝ»
Ί FBPostSelect  -  If Select Button looses focus                   Ί
ΘΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΌ
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

