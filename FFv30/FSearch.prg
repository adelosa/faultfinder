/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ VCR and TV Fault Finder                                          บ
บ Version 3.0 For DOS                                              บ
บ                                                                  บ
บ (C) 1995 A.J.D. Business Software                                บ
บ                                                                  บ
บ Main Module - FSearch.prg                                        บ
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
บ Search Screen                                                    บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE SearchFault(cFaultBookName)  

LOCAL oOldScreen 
LOCAL lUseCategories := .f.
LOCAL cSearchText := space(15)
LOCAL cInifile :=  cFaultBookName + INIFILE
LOCAL aMakeList := {}
LOCAL aModelList := {}                  // Required by subs
PRIVATE oSearch := ControlList():New()  // Do not declare LOCAL as 
                                        // required by event procedures
PRIVATE aMakeStats := {}
PRIVATE aModelStats := {}
PRIVATE aCatStats := {}
PRIVATE nNumberCats   := 1
PRIVATE cFBook := cFaultBookName

RESTORE FROM (cinifile) ADDITIVE      // Get Categories
PRIVATE aCategory := {vCat1,vCat2,vCat3,vCat4,vCat5,vCat6,vCat7,vCat8,vCat9,vCat0}
PRIVATE ThisOne

cWarnScreen := DrawGenNotice("      Please Wait      ",   ;
                             "   Loading fault info  ",   ;
                             "See Status bar for more")

MainHandle := OpenDBFile(cFaultBookName)

aMakeStats := getdataforsearch(cFaultBookName,"","","MAKE")
aMakeList := GetItems(aMakeStats)  // Initial Search
oSearch:add (ListB():New (4,9, aMakeList,"Makes" ,"","SrchPostMakes",22,9)) 
ThisOne := aMakeStats[1][1]

aModelStats := getdataforsearch(cFaultBookName,"MAKE",oSearch:GetSelectString(1),"MODEL")
nNumberCats   := aModelStats[1][2]

aModelList := GetItems(aModelStats)
aadd(aModelList,"**    All    **")

oSearch:add (ListB():New (4,44,aModelList,"Models","","SrchPostModels",22,3) )

oSearch:add (Combo():New (10,44,CatGetArrayList(),"Categories","","SrchpCat",22,3) )

//oSearch:add (TextBox():New (10,44,"Search text",cSearchText) )

oSearch:add (Buttn():New (18,5,"   New   ","","") )
oSearch:add (Buttn():New (18,19,"  Find   ","SrchPreFind","SrchPostFind") )
oSearch:add (Buttn():New (18,61," Cancel ","SrchPreCancel","SrchPostCancel") )

cWarnScreen:ReDisplay()

oWinSearch := WinBox():New(2,3,19,74,"Searching Faultbook "+cFaultBookName)
oWinSearch:SetLine()
oOldScreen := oWinSearch:DrawWin()
oSearch:DisplayAll()

DisplayStats()
oSearch:read()
oOldScreen:ReDisplay()

CloseDBFile(MainHandle)

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ SrchPreCancel  -  If Cancel Button gets focus                    บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE SrchPreCancel
DrawStatusBar("Select another Faultbook")
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ SrchPostCancel  -  If Cancel Button looses focus                 บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE SrchPostCancel
IF oSearch:Action == CHANGE_NEXT        
        oSearch:Action = ENDREAD
ENDIF

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ SrchPostMakes  -  If Makes box is left                           บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE SrchPostMakes

        IF oSearch:GetSelectString(1) != ThisOne 
                aModelStats := getdataforsearch(cFBook,"MAKE",oSearch:GetSelectString(1),"MODEL")
                
                (oSearch:ListOfControls[2]):List := GetItems(aModelStats)
                aadd((oSearch:ListOfControls[2]):List,"**    All    **")
                (oSearch:ListOfControls[2]):Default   := 1
                (oSearch:ListOfControls[2]):Selection := 1
                (oSearch:ListOfControls[2]):TopOfBox  := 1
                
                ThisOne := oSearch:GetSelectString(1)
                (oSearch:ListOfControls[3]):List := CatGetArrayList()
                (oSearch:ListOfControls[3]):Default   := 1
                (oSearch:ListOfControls[3]):Selection := 1
                (oSearch:ListOfControls[3]):TopOfBox  := 1
                oSearch:DisplayAll()
                DisplayStats()
        ENDIF
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ SrchPostModels -  If Models list is left                         บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE SrchPostModels

(oSearch:ListOfControls[3]):List := CatGetArrayList()
(oSearch:ListOfControls[3]):Default   := 1
(oSearch:ListOfControls[3]):Selection := 1
(oSearch:ListOfControls[3]):TopOfBox  := 1

oSearch:DisplayAll()
DisplayStats()

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ DisplayStats -  Displays stats                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE DisplayStats()

GetNoOfCats()
@ 12,43 SAY " Faults found"             COLOR "R/RG"
@ 13,44 TO 13,67                        COLOR "R/RG"
@ 14,43 SAY " Make                    "     COLOR NOTI_COLOR
@ 14,62 SAY LTRIM(STR(aMakeStats[oSearch:GetSelect(1)][2]))   COLOR NOTI_COLOR
@ 15,43 SAY " Model                   "     COLOR NOTI_COLOR
IF oSearch:GetSelect(2)+1 > LEN((oSearch:ListOfControls[2]):List)
@ 15,62 SAY LTRIM(STR(aMakeStats[oSearch:GetSelect(1)][2]))   COLOR NOTI_COLOR
ELSE
@ 15,62 SAY LTRIM(STR(aModelStats[oSearch:GetSelect(2)][2]))  COLOR NOTI_COLOR
ENDIF
@ 16,43 SAY " Category                "     COLOR NOTI_COLOR
@ 16,62 SAY LTRIM(STR(nNumberCats)) COLOR NOTI_COLOR

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ SrchPreFind  -    If Search Button gets focus                    บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE SrchPreFind
DrawStatusBar("Do Search with selected information")
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ SrchPostFind - If Search Button looses focus                     บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE SrchPostFind
IF oSearch:Action == CHANGE_NEXT
        oWinSearch:DisplayOff()
        SearchResults   (cFBook,;
                        oSearch:GetSelectString(1),;
                        oSearch:GetSelectString(2),;
                        CatGetCatNum(oSearch:GetSelectString(3)),;
                        oSearch:GetSelect(4))
        oSearch:Action := CHANGE      
        oWinSearch:DisplayOn()
ENDIF

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ srchPCat - If categories Button looses focus                     บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE srchPCat
        DisplayStats()
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ CatGetArrayList() - If Category list looses focus                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CatGetArrayList()
LOCAL aNewList := {}
LOCAL nCounter2 := 1

IF oSearch:GetSelectString(2) = "**    All    **"
        aCatStats := getdataforsearch(cFBook,"MAKE",oSearch:GetSelectString(1),"STR(Category,2)","nomod")
ELSE
        aCatStats := getdataforsearch(cFBook,"MAKE+model",oSearch:GetSelectString(1)+oSearch:GetSelectString(2),"STR(Category,2)","CAT")
ENDIF

IF EMPTY(aCatStats) 
     AADD( aNewList,"** All **" )  
ELSE
     AADD( aNewList,"** All **" )  
     nCounter2 = 1
     DO WHILE nCounter2 <= LEN(aCatStats)
             Val2Enter :=  aCatStats[nCounter2][1]
             IF Val2Enter ==" 0"
                Val2Enter = "10"
             ENDIF
             AADD( aNewList,( aCategory[VAL(Val2Enter)] ) )
             nCounter2++
     ENDDO
ENDIF

RETURN aNewList

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ CatGetCatNum(cDesc) - If Find Button looses focus                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

FUNCTION CatGetCatNum(cDesc)
LOCAL nCounter := 1
DO WHILE nCounter <= LEN(aCategory)
        IF (cDesc == aCategory[nCounter])
                if (ncounter==10)
                        RETURN " 0"
                else
                        RETURN STR(nCounter,2)
                endif
        ENDIF
        nCounter++
ENDDO
RETURN "  "


FUNCTION GetNoOfCats()
if oSearch:GetSelect(3) == 1
   if oSearch:GetSelect(2) > LEN(aModelStats)
      nNumberCats   := aMakeStats[oSearch:GetSelect(1)][2]
   else
      nNumberCats   := aModelStats[oSearch:GetSelect(2)][2]
   endif
else
      nNumberCats   := aCatStats[oSearch:GetSelect(3)-1][2]
endif
