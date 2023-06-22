/* 
Version Information
Controls for Clipper 1.0
------------------------
Pre 15-12-94    Release 1.0     Production Release
    15-12-94    Release 1.01    Changes made in LogButton so that 
                                enter does not change state
*/
*------------------------------------------------
* CONTROL.PRG
*------------------------------------------------
#include "Inkey.ch"
#include "control.h"

PROCEDURE BaseScreen()
*------------------------------------------------
* This procedure produces a background screen for
* menus. There are no parameters.
* There is no Output.
*------------------------------------------------
SETCOLOR(BASE_COLOR)
CLEAR SCREEN

l = 0
DO WHILE l < 24
        @l,0 SAY REPLICATE(CHR(178),80)
        l=l+1
ENDDO
@24,0 SAY SPACE(80) COLOR STAT_COLOR 

RETURN

PROCEDURE DrawBox(A,B,C,D)
*------------------------------------------------
* This procedure produces a box in the 
* middle of the screen
* Parameters:
* A,B  Top Left
* C,D  Bottom Right
* No Output
*------------------------------------------------
LOCAL cDubl := Chr(201)+Chr(205)+Chr(187)+chr(186)+chr(188)+;
chr(205)+chr(200)+chr(186)+SPACE(1)

@ A,B,C,D BOX cDubl COLOR WIN_COLOR

n := B
L := C+1

DO WHILE n < D
    Screenbit := SAVESCREEN(l,n,l,n+1)
    Screenbit := ASC(screenbit)
    @l,n SAY CHR(Screenbit) COLOR SHADOW
    n=n+1
ENDDO

n := B-1
L := A+1

DO WHILE L < C+2
    Screenbit := SAVESCREEN(l,n,l,n+1)
    Screenbit := ASC(screenbit)
    @l,n SAY CHR(Screenbit) COLOR SHADOW
    L=L+1
ENDDO

RETURN


FUNCTION LogButton(y,x,sLabel,lDefault,lDisp,lDynamic)
*------------------------------------------------
* Places a Logic button on the screen.  
* Passed Label (string) and default (.t. or .f.)
* Place on screen (y,x)
*------------------------------------------------
LOCAL LenLabel := LEN(sLabel)
LOCAL PickItem := lDefault
LOCAL KeyPress := 0
LOCAL aReturn[2]
LOCAL cColor

IF lDisp
        cColor := LOG_ON
ELSE
        cColor := WIN_COLOR
ENDIF

DO WHILE .T.
                
        @ y,x SAY sLabel COLOR cColor 

        @ y,(x+LenLabel+1) SAY "["+IIF(PickItem,"X"," ")+"]" COLOR WIN_COLOR
        
        IF lDisp
                KeyPress = INKEY(0)
        ENDIF

        DO CASE
                CASE KeyPress == 32                      && space
                        IF PickItem=.f.
                                PickItem=.t.
                        ELSE
                                PickItem=.f.
                        ENDIF
                        
                        IF lDynamic
                                aReturn[ACTION] = CHANGE
                                EXIT
                        ENDIF

                CASE KeyPress == 13                      && enter
                        lDisp = .f.
                        KeyPress = 0
                        aReturn[ACTION] = CHANGE_NEXT
                        
                CASE KeyPress == 5 .or. KeyPress = 271    && Up arrow or
                        aReturn[ACTION] = PREVFIELD      && Shift tab
                        EXIT

                CASE KeyPress == 24 .or. KeyPress == 9 && Down arrow
                        
                        aReturn[ACTION] = NEXTFIELD      
                        EXIT                
                
                CASE KeyPress = 28                      && F1 pressed
                        aReturn[ACTION] = HELP          
                        EXIT
                
                CASE KeyPress = 27     && Escape pressed
                        aReturn[ACTION] = ENDREAD      && or tab
                        EXIT
                
                CASE .not. lDisp
                        EXIT
                        
        ENDCASE
ENDDO

@ y,x SAY sLabel COLOR WIN_COLOR

DrawStatusBar("")
aReturn[CHOICE] = PickItem

RETURN aReturn


FUNCTION RadioButton(y,x,aLabel,nStart,cTitle,lDisp,lDynamic)
*------------------------------------------------
* Places a Radio Button on the screen.  
* Passed Label (array of strings) 
* Place on screen (y,x)
*------------------------------------------------

LOCAL LenLabels := Len(aLabel)          && Number of items in array
LOCAL PickItem := nStart
LOCAL KeyPress := 0 , cSaveColor
LOCAL nCount:= 1,nCurrent:= nStart,nSpacer
LOCAL aReturn[2]


nSpacer = MaxStr(aLabel)        
SaveColor := SETCOLOR(CONTROL_COLOR)

@ y,x-1 CLEAR TO y+LenLabels+1,x+nSpacer+5 
SETCOLOR(SaveColor)

@ y,x-1 TO y+LenLabels+1,x+nSpacer+5 COLOR CONTROL_COLOR

@ y,x say cTitle COLOR TITLE_ON

DO WHILE .T.
        
        nCount := 1
        DO WHILE nCount <= LenLabels
                @ (y+nCount),x SAY aLabel[nCount] COLOR CONTROL_COLOR
                @ (y+nCount),(x+nSpacer+1) SAY "("+IIF(PickItem=nCount,chr(7)," ")+")" COLOR CONTROL_COLOR
                nCount++
        ENDDO
        
        IF lDisp
           @ (y+nCurrent),x SAY aLabel[nCurrent]  COLOR BROW_COLOR
        ELSE
           @ (y+nCurrent),x SAY aLabel[nCurrent]  COLOR WIN_COLOR
        ENDIF

        IF lDisp
                KeyPress = Inkey(0)
        ENDIF        
        
        DO CASE
                CASE KeyPress = 32     && space
                        PickItem = nCurrent   
                        IF lDynamic
                                aReturn[ACTION] = CHANGE
                                EXIT
                        ENDIF

                CASE KeyPress = 271    && Shift tab 
                        aReturn[ACTION] = PREVFIELD
                        EXIT
                
                CASE KeyPress = 9                                 
                        aReturn[ACTION] = NEXTFIELD
                        EXIT
                        
                CASE   KeyPress = 13    && enter
                        PickItem = nCurrent   
                        aReturn[ACTION] = NEXTFIELD
                        lDisp=.f.
                        KeyPress=0
                        LOOP
                
                CASE KeyPress = 28     && F1 Pressed
                        aReturn[ACTION] = HELP
                        EXIT
                CASE KeyPress = 27     && Escape pressed
                        aReturn[ACTION] = ENDREAD
                        EXIT
                
                CASE KeyPress = 5       && Up arrow
                        IF nCurrent != 1
                                nCurrent--
                        ENDIF
                
                CASE KeyPress = 24      && Down arrow
                        IF nCurrent != LenLabels
                                nCurrent++
                        ENDIF
                
                CASE .not. lDisp
                        EXIT
        
        ENDCASE
ENDDO

@ y,x say cTitle COLOR TITLE_OFF
@ (y+nCurrent),x SAY aLabel[nCurrent] COLOR SELECT_COLOR

aReturn[CHOICE] = PickItem                        
DrawStatusBar("")

RETURN aReturn

*-------------------------------------------
FUNCTION Button(y,x,cTitle,lDisp)
*-------------------------------------------
/* Display a push button on the screen */

LOCAL aReturn[2],Keypress

IF .not. lDisp
        @ y,x say "<"+cTitle+">" COLOR BUTTON_OFF
ELSE
        @ y,x say "<"+cTitle+">" COLOR BUTTON_ON         
        
        DO WHILE .T.
                KeyPress = Inkey(0)
                @ y,x say "<"+cTitle+">" COLOR BUTTON_OFF                 
                DO CASE
                        CASE KeyPress = 271 .OR. KeyPress = 5    && Shift tab 
                        aReturn[CHOICE] = 0               && or up         
                        aReturn[ACTION] = PREVFIELD
                        EXIT
                CASE  KeyPress = 9 .OR. KeyPress = 24  && Tab or Down
                        aReturn[CHOICE] = 0                        
                        aReturn[ACTION] = NEXTFIELD
                        EXIT                
                CASE KeyPress = 28     && F1 Pressed
                        aReturn[ACTION] = HELP          
                        EXIT
                CASE KeyPress = 27     && Escape pressed
                        aReturn[CHOICE] = 0                        
                        aReturn[ACTION] = ENDREAD
                        EXIT
               
                CASE KeyPress = -1 .or. KeyPress = 13   && F2 pressed or enter
                        aReturn[CHOICE] = 0                        
                        aReturn[ACTION] = CHANGE_NEXT
                        EXIT
                OTHERWISE
                        @ y,x say "<"+cTitle+">" COLOR BUTTON_ON       
                ENDCASE

        ENDDO
ENDIF

RETURN aReturn

*------------------------------------------
FUNCTION CT(nLineNum,sText)
*------------------------------------------
/* Centers the text in sText on line nLineNum */

@ nLineNum,(40-(Len(sText)/2)) SAY sText 
RETURN

*-----------------------------------
FUNCTION MaxStr(aArray)
*-----------------------------------
/* Gets the length of the largest string
in a string array */

LOCAL nCount:=1,nMaxLen:=0

DO WHILE nCount <= LEN(aArray)
        IF len(aArray[nCount]) > nMaxLen
                nMaxLen = len(aArray[nCount])
        ENDIF
        nCount++
ENDDO
RETURN nMaxLen

PROCEDURE XDrawBox(A,B,C,D)
*------------------------------------------------
* This procedure produces a box in the 
* middle of the screen
* Parameters:
* A,B  Top Left
* C,D  Bottom Right
* No Output
*------------------------------------------------
STATIC nTIMEVAL :=.01
LOCAL cDubl := Chr(201)+Chr(205)+Chr(187)+chr(186)+chr(188)+;
chr(205)+chr(200)+chr(186)+SPACE(1)
LOCAL nAcount:=A+Int((C-A)/2),nCcount:= A+Int((C-A)/2)

DO WHILE nAcount != A .and. nCcount != C
        @ nAcount,B,nCcount,D BOX cDubl COLOR WIN_COLOR
        nAcount--
        inkey(nTIMEVAL)
        @ nAcount,B,nCcount,D BOX cDubl COLOR WIN_COLOR
        nCcount++
        inkey(nTIMEVAL)
ENDDO

@ A,B,C,D BOX cDubl COLOR WIN_COLOR

n := B
L := C+1

DO WHILE n < D
    Screenbit := SAVESCREEN(l,n,l,n+1)
    Screenbit := ASC(screenbit)
    @l,n SAY CHR(Screenbit) COLOR SHADOW 
    n=n+1
ENDDO

n := B-1
L := A+1


DO WHILE L < C+2
    Screenbit := SAVESCREEN(l,n,l,n+1)
    Screenbit := ASC(screenbit)
    @l,n SAY CHR(Screenbit) COLOR SHADOW
    L=L+1
ENDDO

RETURN

*----------------------------------
FUNCTION MatchAStr(sString,aString)
*----------------------------------
/* Returns the index number for the 
first string in aString that matches
sString */

LOCAL nCounter := 1
LOCAL Found:=0
DO WHILE nCounter <= len(aString)
        IF aString[nCounter]==sString
                Found=nCounter
                EXIT
        ENDIF
        nCounter++
ENDDO

RETURN Found

*-------------------------------------------
FUNCTION mGenYesNo(cMessage1,cMessage2)
*-------------------------------------------
LOCAL OrigScreen := SaveScreen(10,14,17,64)
LOCAL lAction:=.f.
LOCAL nChoice:=1

XDrawBox(10,15,16,64)
CT(10," Are you sure ")
CT(16,"< "+chr(27)+chr(26)+" Choose "+chr(27)+chr(217)+" Select >")
CT(11,cMessage1)
CT(12,cMessage2)

@ 14,28 prompt "< Yes  >"
@ 14,45 prompt "<  No  >"
menu to nChoice

RestScreen(10,14,17,64,OrigScreen)

IF nChoice = 1
        RETURN .T.
ELSE
        RETURN .F.
ENDIF


*-----------------------------
FUNCTION ContBar(nUpTo,nTotal,ny,nx)
*-----------------------------
/* This function displays a indicator bar on the bottom
of the screen */
LOCAL BarLength:=3
LOCAL nPos := 1
LOCAL nCount := ny

// Blank out the old area

DO WHILE nCount < BarLength+ny
        @ nCount++,nx say space(1) COLOR CONTROL_COLOR 
ENDDO

nPos = (ny)+(int( ( (nUpTo-1) / (nTotal) ) * (BarLength) ))
@ nPos,nx SAY CHR(254) COLOR CONTROL_COLOR 

RETURN

*-----------------------------
FUNCTION StatBar(nUpTo,nTotal)
*-----------------------------
/* This function displays a indicator bar on the bottom
of the screen */
STATIC BarLength:=10


@ 24,2 say "Status" COLOR STAT_COLOR
@ 24,10 say space(BarLength+1) COLOR STAT_COLOR
@ 24,10 say "["+replicate(chr(254),int(((nUpTo-1)/(nTotal-1))*BarLength)) COLOR STAT_COLOR
@ 24,21 say "] "+ltrim(str(int(((nUpTo-1)/(nTotal-1))*100)))+"%"+"  " COLOR STAT_COLOR

RETURN


*-------------------------------------------
FUNCTION ComboBox(y,x,aList,nStart,cTitle,lDisp,lDynamic,nWidth)
*-------------------------------------------
/* Places a ComboBox on the screen.  
 Passed Label (array of strings) 
 Place on screen (y,x) */
/* If lDisp = .f., just display boxes on screen */
/* If lDynamic = .t., notifys calling function of change in value */

LOCAL NoOfItems:=3
LOCAL nCurrent:=1,TopofBox:=1,BottomOfBox
LOCAL aReturn[2]
LOCAL PickItem, lEmptyFlag:=.F. 
LOCAL KeyPress:=0
LOCAL MaxLen 

/* Check if empty array has been passed */

IF EMPTY(aList)
        lEmptyFlag:=.T. 
        aadd(aList,"None")
ENDIF

IF nWidth=0
        MaxLen := MaxStr(aList)
ELSE
        MaxLen := nWidth
ENDIF

LenArray := Len(aList)
PickItem := nStart

NoOfBox = NoOfItems
IF NoOfItems > LenArray
        NoOfBox = LenArray
ENDIF

savecol := SETCOLOR(CONTROL_COLOR)
@ y,x-1 CLEAR TO y+NoOfItems+3,x+MaxLen+1 
SETCOLOR(savecol)

@ y+2,x-1 TO y+NoOfItems+3,x+MaxLen+1 COLOR CONTROL_COLOR
@ y,x-1 TO y+2,x+MaxLen+1 COLOR CONTROL_COLOR
@ y,x-1 TO y+NoOfItems+3,x+MaxLen+1 COLOR CONTROL_COLOR

@ y,x to y,x+MaxLen COLOR CONTROL_COLOR
@ y,x-1 say chr(218) COLOR CONTROL_COLOR
@ y+1,x-1 to y+NoOfItems+2,x-1 COLOR CONTROL_COLOR
@ y+NoOfItems+3,x-1 say chr(192) COLOR CONTROL_COLOR

IF lDisp
        @ y,x say cTitle COLOR TITLE_ON 
ELSE
        @ y,x say cTitle COLOR TITLE_OFF
ENDIF

ContBar(nCurrent,LenArray,y+3,x+MaxLen)

DO WHILE .T.
        BottomOfBox = TopOfBox+NoOfBox-1
        nCount = 0
        
        DO WHILE nCount < NoofBox 
                @ y+nCount+3,x say space(MaxLen) COLOR CONTROL_COLOR
                @ y+nCount+3,x say aList[nCount+TopOfBox] COLOR CONTROL_COLOR
                IF nCount+TopOfBox = nCurrent .and. lDisp
                        @ y+nCount+3,x say aList[nCount+TopOfBox] COLOR BROW_COLOR
                endif
                nCount++
        ENDDO
        
        @ y+1,x say space(nWidth) COLOR CONTROL_COLOR
        @ y+1,x say aList[PickItem] COLOR SELECT_COLOR
        
        IF lDisp
                KeyPress = INKEY(0)
        ENDIF
        
        DO CASE
                CASE KeyPress = 271     && Shift tab 
                        aReturn[ACTION] = PREVFIELD
                        EXIT
                
                CASE KeyPress = 9       &&  tab 
                        aReturn[ACTION] = NEXTFIELD
                        EXIT
                
                CASE KeyPress = 13      && enter
                        PickItem := nCurrent
                        aReturn[ACTION] = CHANGE_NEXT
                        @ y,x say cTitle COLOR TITLE_OFF
                        lDisp=.f.
                        KeyPress=0
                        LOOP                
                
                CASE KeyPress = 28     && F1 Pressed
                        aReturn[ACTION] = HELP          
                        EXIT
                
                CASE KeyPress = -1     && F2 Pressed
                        aReturn[ACTION] = ADD_NEW          
                        EXIT
                
                
                CASE KeyPress = 27     && Escape pressed
                        aReturn[ACTION] = ENDREAD
                        EXIT
                
                CASE KeyPress = 5       && Up arrow
                        IF nCurrent != 1
                                IF nCurrent=TopOfBox        
                                        TopOfBox--
                                        nCurrent--
                                ELSE
                                        nCurrent--
                                ENDIF
                        ENDIF
                
                CASE KeyPress = 24      && Down arrow
                        IF nCurrent != LenArray
                                IF nCurrent = BottomofBox
                                        TopOfBox++
                                        nCurrent++
                                ELSE
                                        nCurrent++
                                ENDIF
                        ENDIF
                
                CASE KeyPress = K_PGUP       && Page Up 
                        IF nCurrent > NoOfItems
                                IF nCurrent=TopOfBox        
                                        TopOfBox=TopOfBox-NoOfItems
                                        nCurrent=nCurrent-NoOfItems
                                ELSE
                                        nCurrent=TopOfBox
                                ENDIF
                        ELSE
                                TopOfBox = 1                        
                                nCurrent = 1
                        ENDIF
                
                CASE KeyPress = K_PGDN      && Page Down 
                        IF LenArray >= NoOfItems
                        IF nCurrent < LenArray - NoOfItems + 1  

                                IF nCurrent = BottomofBox
                                        TopOfBox=TopOfBox+NoOfItems
                                        nCurrent=nCurrent+NoOfItems
                                ELSE
                                        nCurrent=BottomOfBox
                                ENDIF
                        ELSE
                                TopOfBox = LenArray - NoOfItems + 1
                                nCurrent = LenArray
                        ENDIF
                        ENDIF                        
                CASE KeyPress = 32   && space pressed
                        PickItem := nCurrent
                        IF lDynamic
                                aReturn[ACTION] = CHANGE
                                EXIT
                        ENDIF

                CASE .not. lDisp
                        EXIT

        ENDCASE
        ContBar(nCurrent,LenArray,y+3,x+MaxLen)
ENDDO

@ y+3,x SAY aList[TopOfBox] COLOR CONTROL_COLOR 

aReturn[CHOICE] = PickItem                        

IF lEmptyFlag 
        aReturn[CHOICE] = 0     && Empty array passed                        
ENDIF

IF lDisp 
        @ y,x SAY cTitle COLOR TITLE_OFF                                
ENDIF


DrawStatusBar("")

RETURN aReturn

*---------------------------------------
FUNCTION StatusNew( nRow, nCol, cColor )
*---------------------------------------   
   LOCAL aStat[ ST_LEN ]

   aStat[ ST_ROW     ] := 0
   aStat[ ST_COL     ] := 0
   aStat[ ST_COLOR   ] := STAT_COLOR
   aStat[ ST_CURRENT ] := 1

   IF nRow != NIL
      aStat[ ST_ROW ] := nRow
   ENDIF

   IF nCol != NIL
      aStat[ ST_COL ] := nCol
   ENDIF

   IF cColor != NIL
      aStat[ ST_COLOR ] := cColor
   ENDIF

   RETURN ( aStat )

*-----------------------------
FUNCTION StatusUpdate( aStat )
*-----------------------------   
   LOCAL cOldColor
   STATIC aDisplay := { "|", "/", "-", "\" } // Status item display characters
   
   cOldColor := SETCOLOR( aStat[ ST_COLOR ] )

   aStat[ ST_CURRENT ]++
   IF aStat[ ST_CURRENT ] > 4
      aStat[ ST_CURRENT ] := 1
   ENDIF

   @ aStat[ ST_ROW ], aStat[ ST_COL ]-1 SAY "[" 
   @ aStat[ ST_ROW ], aStat[ ST_COL ]+1 SAY "]"
   @ aStat[ ST_ROW ], aStat[ ST_COL ] SAY aDisplay[aStat[ ST_CURRENT ]] 

   SETCOLOR( cOldColor )
   
   RETURN ( NIL )

*-------------------------------------------
FUNCTION mGetDialog(cFieldName,nSizeoffld)
*-------------------------------------------
// Gets a value from the user of character type
// of length nSizeofld

LOCAL OrigScreen := SaveScreen(10,14,17,64)
LOCAL cfield := SPACE(nSizeoffld)

XDrawBox(10,15,16,64)

CT(10," Enter new value ")
CT(16," <ESC - Exit>")
CT(12,cFieldName)
@ 13, (40 - (nSizeoffld/2)) GET cfield PICTURE "@!"
CT(15,"Enter the value or press ESC to abort")

SET CURSOR ON
READ
SET CURSOR OFF

RestScreen(10,14,17,64,OrigScreen)

IF (LASTKEY() != K_ESC) .AND. UPDATED()
   RETURN cField
ENDIF

RETURN SPACE(nSizeoffld)

*--------------------------------------------------
PROCEDURE DrawStatusBar(cMessage) 
// This function is to be used in the update of the 
// status bar, as to keep consistency
*--------------------------------------------------

LOCAL oldcolor := SETCOLOR(STAT_COLOR)
@24,68 SAY "< F1 Help >"
IF TRIM(cMessage)==""
        CT(24,SPACE(56))
ELSE
        CT(24,SPACE(56))
        CT(24,cMessage)
ENDIF
SETCOLOR(oldcolor)

RETURN


*-------------------------------------------
FUNCTION mMsgBox(cMessage1,cMessage2)
*-------------------------------------------
LOCAL OrigScreen := SaveScreen(10,14,17,64)
XDrawBox(10,15,16,64)
CT(10," Information Message ")
CT(12,cMessage1)
CT(13,cMessage2)
Button(15,36,"Continue",.t.)
RestScreen(10,14,17,64,OrigScreen)


