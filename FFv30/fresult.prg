/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ VCR and TV Fault Finder                                          บ
บ Version 3.0 For DOS                                              บ
บ                                                                  บ
บ (C) 1995 A.J.D. Business Software                                บ
บ                                                                  บ
บ Results Module - FResult.prg                                     บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Compiler includes                                                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

#include "oclip.ch"
#include "..\OBCON\control.ch"
#include "..\OBCON\obcon.ch"
#include "data.ch"

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Result Screen                                                    บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE SearchResults(cFaultBookName,cMake,cModel,cCategory,cText2Find)  

LOCAL oOldScreen 
PRIVATE oResult := ControlList():New()  // Do not declare LOCAL as 
                                        // required by event procedures
PRIVATE nRecPos := 1
PRIVATE aResults := GetItems(getdataforsearch(cFaultBookName,"MAKE+model+STR(Category,2)",cMake+cModel+ccategory,"fault1+fault2+Remedy1+Remedy2+Remedy3","cat"))

// Get for all categories
IF cCategory = "  "
        aResults := GetItems(getdataforsearch(cFaultBookName,"MAKE+MODEL",cMake+cModel,"fault1+fault2+Remedy1+Remedy2+Remedy3","cat"))
ENDIF

// Get for all makes
IF ALLTRIM(cModel) = "**    All    **"
      aResults := GetItems(getdataforsearch(cFaultBookName,"MAKE",cMake,"fault1+fault2+Remedy1+Remedy2+Remedy3","cat"))
ENDIF

oResult:add (Buttn():New (16,5,"  Print  ","","") )
oResult:add (Buttn():New (18,5,"Print all","","") )
oResult:add (Buttn():New (20,5,"   New   ","","") )

oResult:add (Buttn():New (20,19," Previous","","resPostPrev") )
oResult:add (Buttn():New (20,33,"   Next  ","","resPostNext") )

oResult:add (Buttn():New (20,61,"    OK   ","resPreOK","resPostOK") )

oWinResult := WinBox():New(4,3,21,74,TRIM(cFaultBookName) + " Search Results - "+TRIM(cMake)+" "+TRIM(cModel))
oWinResult:SetLine()

oOldScreen := oWinResult:DrawWin()
oResult:DisplayAll()
ResDisplayFR(aResults[nRecPos])
oResult:read()
oOldScreen:ReDisplay()

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ ResPreCancel  -  If Cancel Button gets focus                     บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE ResPreOK
DrawStatusBar("Return to previous menu")
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ ResPostCancel  -  If Cancel Button looses focus                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE ResPostOK
IF oResult:Action == CHANGE_NEXT        
        oResult:Action = ENDREAD
ENDIF

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ ResDisplayFR  -  Displays fault and remedies                     บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE ResDisplayFR(cFields)
@6,9 say "Symptom" COLOR NOTI_COLOR
@7,9 say LEFT(cFields,60) COLOR BUTTON_OFF
@8,9 say SUBSTR(cFields,61,60) COLOR BUTTON_OFF

@10,9 say "Remedy" COLOR NOTI_COLOR
@11,9 say SUBSTR(cFields,121,60) COLOR BUTTON_OFF
@12,9 say SUBSTR(cFields,181,60) COLOR BUTTON_OFF
@13,9 say SUBSTR(cFields,241,60) COLOR BUTTON_OFF

resDispStat()
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ resPostPrev  -  Go to previous record                            บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE resPostPrev
IF oResult:Action == CHANGE_NEXT        
        IF nRecPos != 1 
                ResDisplayFR(aResults[--nRecPos])
        ENDIF
        oResult:Action = CHANGE
ENDIF

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ resPostNext  -  Go to next record                                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE resPostNext
IF oResult:Action == CHANGE_NEXT        
        IF nRecPos != LEN(aResults) 
                ResDisplayFR(aResults[++nRecPos])
        ENDIF
        oResult:Action = CHANGE
ENDIF
RETURN


/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ resDispStat  -  Display record details                           บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE resDispStat
@ 16,25 say "Fault record " + LTRIM(STR(nRecPos)) + " of " + LTRIM(STR(LEN(aResults))) COLOR NOTI_COLOR
RETURN


