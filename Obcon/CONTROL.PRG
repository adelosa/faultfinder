/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ OBject CONtrols for CA-Clipper                          13-02-95 บ
บ (c)Copyright A.J.D Business Software 1995            CONTROL.PRG บ
บ                                                                  บ
บ Control Procedure functions                                      บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ RELEASE INFORMATION                                              บ
บ Pre 15-12-94    Release 1.0     Production Release               บ
บ     15-12-94    Release 1.01    Changes made in LogButton so thatบ
บ                                 enter does not change state      บ
บ     03-01-95                    Emulate MSAV interface           บ
บ     10-01-95                    Mouse support for all controls   บ
บ                                 except textbox                   บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Global Include statements                                        บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

#include "Inkey.ch"
#include "control.ch"

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ ResetColors()                                           01-12-94 บ
บ Screen                                                           บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Reset the standard VGA pallette                                  บ
บ This procedure redefines the VGA pallette as to produce better   บ
บ color scheme.                                                    บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE ResetColors()

VGAPALETTE("W",63,63,63)        // Define bright white as default
VGAPALETTE("RG",49,49,49)      // RG to be Light grey
VGAPALETTE("RB",0,42,63)      // RB to be light blue
VGAPALETTE("G",25,25,25)      // G to be Dark grey

RETURN
/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ BaseScreen()                                                     บ
บ Screen                                                           บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Set up the background for standard applications                  บ
บ cAppTitle    Name of the application                             บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

PROCEDURE BaseScreen(cAppTitle)

ResetColors()
SET SCOREBOARD OFF
SET STATUS OFF
SETCOLOR(BASE_COLOR)
CLEAR SCREEN
SETCOLOR(STAT_COLOR)

@ 0,0 SAY SPACE(80) COLOR STAT_COLOR 
@ 0,0 SAY " ฤ " COLOR "N/W"
CT(0,(cAppTitle))
@24,0 SAY SPACE(80) COLOR STAT_COLOR 

RETURN

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ LogButton()                                                      บ
บ Control                                                          บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Places a Logic button on the screen                              บ
บ Passed Label (string) and default (.t. or .f.)                   บ
บ Place on screen (y,x)                                            บ
บ 7/1/95 Added mouse support                                       บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION LogButton(y,x,sLabel,lDefault,lDisp,lDynamic)

// Keystrokes
LOCAL KeyPress := 0

// Mouse movements
LOCAL MousePress := 0
LOCAL LastMousePress := 0
LOCAL MouseDown := .f.
LOCAL MXcoord := MYcoord := 0  

// Function return variable
LOCAL aReturn[4]

// General variables
LOCAL cColor
LOCAL LenLabel := LEN(sLabel)
LOCAL PickItem := lDefault

// If displaying the field, show in different 
// color to when input is made

IF lDisp
        cColor := LOG_ON
ELSE
        cColor := NOTI_COLOR
ENDIF

DO WHILE .T.
        KeyPress = 0
        @ y,x-1 SAY "["+IIF(PickItem,"๛"," ")+"]" COLOR cColor 
        @ y,x+3 SAY sLabel COLOR cColor 
        
        IF lDisp
                mShow()
                DO WHILE KeyPress == 0 .AND. .not. MouseDown
                        
                        KeyPress = INKEY()
                        MousePress = mBout()
                        
                        IF (LastMousePress == 2) .and. (MousePress == 4)
                            MouseDown = .T.
                        ENDIF
                        
                        IF LastMousePress <> MousePress
                                LastMousePress = MousePress
                        ENDIF
                                
                        MXcoord := mX()
                        Mycoord := mY()
                        
                ENDDO
                mHide()
        ENDIF

        DO CASE
                CASE (KeyPress == 32) .OR. ; 
                (MYcoord == y+1 .and. ;
                 MXcoord >= x+1 .and. ;
                 MXcoord <= x+4+len(sLabel) .AND. ;
                 MouseDown )     // space or clicked on
                                
                        IF PickItem=.f.
                                PickItem=.t.
                        ELSE
                                PickItem=.f.
                        ENDIF
                        
                        IF lDynamic
                                aReturn[ACTION] = CHANGE
                                EXIT
                        ENDIF
                        MouseDown = .F.        
                
                CASE MouseDown   // Not in field area      
                        aReturn[MOUSEY] = MYcoord                
                        aReturn[MOUSEX] = MXcoord                
                        aReturn[ACTION] = MOUSE_FIELD                
                        EXIT

                CASE KeyPress == 13                      // enter
                        lDisp = .f.
                        KeyPress = 0
                        aReturn[ACTION] = CHANGE_NEXT
                        
                CASE KeyPress == 5 .or. KeyPress = 271   // Up arrow or
                        aReturn[ACTION] = PREVFIELD      // Shift tab
                        EXIT

                CASE KeyPress == 24 .or. KeyPress == 9   // Down arrow
                       
                        aReturn[ACTION] = NEXTFIELD      
                        EXIT                
                
                CASE KeyPress = 28                       // F1 pressed
                        aReturn[ACTION] = HELP          
                        EXIT
                
                CASE KeyPress = 27     // Escape pressed
                        aReturn[ACTION] = ENDREAD      // or tab
                        EXIT
                
                CASE .not. lDisp
                        EXIT
                        
        ENDCASE
        MouseDown = .F.        
ENDDO

@ y,x+3 SAY sLabel COLOR NOTI_COLOR
@ y,x-1 SAY "["+IIF(PickItem,"๛"," ")+"]" COLOR NOTI_COLOR

DrawStatusBar("")
aReturn[CHOICE] = PickItem

RETURN aReturn

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ RadioButton()                                                    บ
บ Screen                                                           บ
บฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Places a Radio Button on the screen                              บ 
บ Passed Label (array of strings)                                  บ
บ Place on screen (y,x)                                            บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

FUNCTION RadioButton(y,x,aLabel,nStart,cTitle,lDisp,lDynamic)

// Keystrokes
LOCAL KeyPress := 0 

// General variables
LOCAL cSaveColor
LOCAL nCount := 1
LOCAL nCurrent:= nStart
LOCAL nSpacer
LOCAL LenLabels := Len(aLabel)          // Number of items in array
LOCAL PickItem := nStart

// Mouse movements
LOCAL MousePress := 0
LOCAL LastMousePress := 0
LOCAL MouseDown := .f.
LOCAL MXcoord := MYcoord := 0  

// Return variables
LOCAL aReturn[4]

nSpacer = MaxStr(aLabel)        

SaveColor := SETCOLOR(CONTROL_COLOR)
@ y,x-1 CLEAR TO y+LenLabels,x+nSpacer+5 
SETCOLOR(SaveColor)

// @ y,x-1 TO y+LenLabels+1,x+nSpacer+5 COLOR CONTROL_COLOR

@ y,x-1 say replicate(" ",nSpacer+7) COLOR TITLE_ON
@ y,x say cTitle COLOR TITLE_ON

DO WHILE .T.
        
        KeyPress = 0        
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
                mShow()
                DO WHILE KeyPress == 0 .AND. .not. MouseDown
                        
                        KeyPress = INKEY()
                        MousePress = mBout()
                        
                        IF (LastMousePress == 2) .and. (MousePress == 4)
                            MouseDown = .T.
                        ENDIF
                        
                        IF LastMousePress <> MousePress
                                LastMousePress = MousePress
                        ENDIF
                                
                        MXcoord := mX()
                        Mycoord := mY()
                        
                ENDDO
                mHide()
        ENDIF        
        
        DO CASE
                CASE (MYcoord >= y+1 .and. ;
                 MYcoord <= y+LenLabels+1 .and. ;
                 MXcoord >= x .and. ;
                 MXcoord <= x+nSpacer+6 .AND. ;
                 MouseDown )     // space or clicked on
                
                nSelection := MYcoord - y-1  
                
                IF nSelection <> 0                
                        nCurrent = nSelection 
                        PickItem = nCurrent   
                ELSE
                        nCurrent = 1
                ENDIF

                KeyPress=0
                MouseDown = .F.        
                LOOP
                
                CASE MouseDown   // Not in field area      
                        aReturn[MOUSEY] = MYcoord                
                        aReturn[MOUSEX] = MXcoord                
                        aReturn[ACTION] = MOUSE_FIELD                
                        EXIT                

                CASE KeyPress = 32     // Space pressed
                
                        PickItem = nCurrent   
                        IF lDynamic
                                aReturn[ACTION] = CHANGE
                                EXIT
                        ENDIF

                CASE KeyPress = 271    // Shift tab 
                        aReturn[ACTION] = PREVFIELD
                        EXIT
                
                CASE KeyPress = 9                                 
                        aReturn[ACTION] = NEXTFIELD
                        EXIT
                        
                CASE   KeyPress = 13    // enter
                        aReturn[ACTION] = NEXTFIELD
                        PickItem = nCurrent   
                        lDisp=.f.
                        KeyPress=0
                        MouseDown = .F.                        
                        LOOP
                
                CASE KeyPress = 28     // F1 Pressed
                        aReturn[ACTION] = HELP
                        EXIT
                
                CASE KeyPress = 27     // Escape pressed
                        aReturn[ACTION] = ENDREAD
                        EXIT
                
                CASE KeyPress = 5       // Up arrow
                        IF nCurrent != 1
                                nCurrent--
                        ENDIF
                
                CASE KeyPress = 24      // Down arrow
                        IF nCurrent != LenLabels
                                nCurrent++
                        ENDIF
                
                CASE .not. lDisp
                        EXIT
        
        ENDCASE
        MouseDown = .F.        
ENDDO

@ y,x-1 say replicate(" ",nSpacer+7) COLOR TITLE_OFF
@ y,x say cTitle COLOR TITLE_OFF
@ (y+nCurrent),x SAY aLabel[nCurrent] COLOR SELECT_COLOR

aReturn[CHOICE] = PickItem                        
DrawStatusBar("")

RETURN aReturn

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Button()                                                         บ
บ Control                                                          บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Display a push button on the screen                              บ
บ lDisp toggles if the control is activated                        บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION Button(y,x,cTitle,lDisp)

LOCAL aReturn[4]
LOCAL Keypress := 0

// Mouse movements
LOCAL MousePress := 0
LOCAL LastMousePress := 0
LOCAL MouseDown := .f.
LOCAL MXcoord := MYcoord := 0  


IF .not. lDisp
        @ y,x say " "+cTitle+" " COLOR BUTTON_OFF
        @ y+1,x+1 say replicate(chr(223),len(cTitle)+2) COLOR "n/rg"
        @ y,x+len(cTitle)+2 say chr(220) COLOR "n/rg"
ELSE
        
        @ y,x say " "+cTitle+" " COLOR BUTTON_ON         
        @ y+1,x+1 say replicate(chr(223),len(cTitle)+2) COLOR "n/rg"
        @ y,x+len(cTitle)+2 say chr(220) COLOR "n/rg"
        
        DO WHILE .T.
                Keypress = 0
                mShow()
                DO WHILE KeyPress == 0 .AND. .not. MouseDown
                        
                        KeyPress = INKEY()
                        MousePress = mBout()
                        
                        IF (LastMousePress == 2) .and. (MousePress == 4)
                            MousePress = 0
                            MouseDown = .T.
                        ENDIF
                        
                        IF LastMousePress <> MousePress .and. MousePress <> 4
                                LastMousePress = MousePress
                        ENDIF
                                
                        MXcoord := mX()
                        Mycoord := mY()
                        
                ENDDO
                mHide()
                
                @ y,x say " "+cTitle+" " COLOR BUTTON_OFF                 
                DO CASE
                
                CASE KeyPress == 271 .OR. KeyPress == 5 ;
                .or. keypress == 19   // Shift tab
                        aReturn[CHOICE] = 0               // or up         
                        aReturn[ACTION] = PREVFIELD
                        EXIT
                
                CASE  KeyPress = 9 .OR. KeyPress = 24  ; // Tab or Down
                .or. keypress == 4
                        aReturn[CHOICE] = 0
                        aReturn[ACTION] = NEXTFIELD
                        EXIT                
                
                CASE KeyPress = 28     // F1 Pressed
                        aReturn[ACTION] = HELP          
                        EXIT
                
                CASE KeyPress = 27     // Escape pressed
                        aReturn[CHOICE] = 0                        
                        aReturn[ACTION] = ENDREAD
                        EXIT
               
                CASE (KeyPress = 13) .or. (MYcoord == y+1) .and. ;
                 (MXcoord >= x+1) .and. ;
                 (MXcoord <= x+len(cTitle)+2) .AND. ;
                 MouseDown      // space or clicked on
                        
                        aReturn[CHOICE] = 0                        
                        aReturn[ACTION] = CHANGE_NEXT
                        MouseDown = .f.
                        EXIT
                
                CASE MouseDown   // Not in field area      
                        aReturn[MOUSEY] = MYcoord                
                        aReturn[MOUSEX] = MXcoord                
                        aReturn[ACTION] = MOUSE_FIELD                
                        EXIT                
                
                
                OTHERWISE
                        @ y,x say " "+cTitle+" " COLOR BUTTON_ON       
                        @ y+1,x+1 say replicate(chr(223),len(cTitle)+2) COLOR "n/rg"
                        @ y,x+len(cTitle)+2 say chr(220) COLOR "n/rg"
        
                ENDCASE
        MouseDown = .F.                
        ENDDO
ENDIF

RETURN aReturn
/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ CT(nLineNum,cText)                                               บ
บ Screen                                                           บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Like a say that centers cText in the middle of screen on         บ
บ the line nLineNum.                                               บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CT(nLineNum,cText)

@ nLineNum,(40-(Len(cText)/2)) SAY cText 
RETURN

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ MaxStr(aArray)                                                   บ
บ Array                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Gets the length of the largest string in a string array          บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION MaxStr(aArray)

LOCAL nCount:=1,nMaxLen:=0

DO WHILE nCount <= LEN(aArray)
        IF len(aArray[nCount]) > nMaxLen
                nMaxLen = len(aArray[nCount])
        ENDIF
        nCount++
ENDDO
RETURN nMaxLen

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ MatchAStr(sString,aString)                                       บ
บ Array                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Returns the index number for the first string in aString         บ
บ that matches sString                                             บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION MatchAStr(sString,aString)

LOCAL nCounter := 1
LOCAL Found:=0
DO WHILE nCounter <= len(aString)
        IF UPPER(LEFT(aString[nCounter],LEN(sString)))==sString
                Found=nCounter
                EXIT
        ENDIF
        nCounter++
ENDDO

RETURN Found

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ mGenYesNo(cMessage1,cMessage2)                                   บ
บ Common dialog                                                    บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Displays a generic YES/NO "Are you sure?" message                บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION mGenYesNo(cMessage1,cMessage2)

LOCAL OrigScreen := SaveScreen(10,15,17,65)
LOCAL lAction:=.f.
LOCAL nChoice:=1

oBox := WinBox():New(10,15,16,64,"")
oBox:Display()

CT(10," Are you sure ")
CT(16,"< "+chr(27)+chr(26)+" Choose "+chr(27)+chr(217)+" Select >")
CT(11,cMessage1)
CT(12,cMessage2)

@ 14,28 prompt "< Yes  >"
@ 14,45 prompt "<  No  >"
menu to nChoice

RestScreen(10,15,17,65,OrigScreen)

IF nChoice = 1
        RETURN .T.
ELSE
        RETURN .F.
ENDIF

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ ContBar(nUpTo,nTotal,ny,nx,cColor,BarLength)                     บ
บ Screen                                                           บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ This function displays a indicator bar on the bottom             บ
บ of the screen                                                    บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ContBar(nUpTo,nTotal,ny,nx,cColor,BarLength)

LOCAL nPos := 1
LOCAL nCount := ny

// Blank out the old area

DO WHILE nCount < BarLength+ny
        @ nCount++,nx say space(1) COLOR cColor
ENDDO

nPos = (ny)+(int( ( (nUpTo-1) / (nTotal) ) * (BarLength) ))
@ nPos,nx SAY CHR(254) COLOR cColor

RETURN

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ StatBar(nUpTo,nTotal)                                            บ
บ Screen                                                           บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Displays a status bar at the bottom of the screen                บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION StatBar(nUpTo,nTotal)

STATIC BarLength:=10

@ 24,2 say "Status" COLOR STAT_COLOR
@ 24,10 say space(BarLength) COLOR "b/g"
@ 24,10 say replicate(chr(177),int(((nUpTo-1)/(nTotal-1))*BarLength)) COLOR "rg/g"
@ 24,21 say " "+ltrim(str(int(((nUpTo-1)/(nTotal-1))*100)))+"%"+"  " COLOR STAT_COLOR

RETURN

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ ComboBox()                                                       บ
บ Control                                                          บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Places a ComboBox on the screen                                  บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ComboBox(y,x,aList,nStart,cTitle,lDisp,lDynamic,nWidth,nTopOfBox)

// Control variables
LOCAL NoOfItems:=3
LOCAL nCurrent,TopofBox,BottomOfBox
LOCAL aReturn[5]
LOCAL PickItem, lEmptyFlag:=.F. 
LOCAL KeyPress:=0
LOCAL MaxLen 
LOCAL ExtraBox

// Mouse movements
LOCAL MousePress := 0
LOCAL LastMousePress := 0
LOCAL MouseDown := .f.
LOCAL MouseScroll := .F.     
LOCAL MXcoord := MYcoord := 0  
LOCAL Timer := 0

/* Check if empty array has been passed */

IF EMPTY(aList)
        lEmptyFlag:=.T. 
        aadd(aList,"None")
ENDIF

/* Set up so that the box displays the correct option in the
scrollable area */

LenArray := Len(aList)

IF nStart > (LenArray - NoOfItems + 1)
        TopOfBox = LenArray - NoOfItems + 1
ELSE
        TopOfBox = nStart
ENDIF
IF !EMPTY(nTopOfBox)
        TopOfBox = nTopOfBox
ENDIF

PickItem := nStart
nCurrent := nStart

IF nWidth=0
        MaxLen := MaxStr(aList)
ELSE
        MaxLen := nWidth
ENDIF

NoOfBox = NoOfItems
IF NoOfItems > LenArray
        NoOfBox = LenArray
ENDIF

savecol := SETCOLOR(CONTROL_COLOR)
@ y,x-1 CLEAR TO y+1,x+MaxLen+3
@ y+1,x say space(nWidth) COLOR CONTROL_COLOR
@ y+1,x say aList[PickItem] COLOR SELECT_COLOR

IF lDisp
        ExtraBox = SAVESCREEN(y+2,x-1,y+NoOfItems+2,x+MaxLen+4)
        @ y+2,x-1 CLEAR TO y+NoOfItems+1,x+MaxLen+3 
        Drawshadow(y+2,x-1,y+NoOfItems+1,x+MaxLen+3) 
ENDIF

SETCOLOR(savecol)

IF lDisp
        @ y,x-1 say replicate(" ",(x+MaxLen+3)-(x-2)) COLOR TITLE_ON 
        @ y,x say cTitle COLOR TITLE_ON 
        @ y+1,x+MaxLen+1 say " " + chr(31) + " " COLOR BROW_COLOR
        ContBar(nCurrent,LenArray,y+2,x+MaxLen+3,"rg/g",NoOfItems)
        @ y+2,x+Maxlen+2 say chr(30) color "rg/g"
        @ y+NoOfItems+1,x+Maxlen+2 say chr(31) color "rg/g"
ELSE
        @ y,x-1 say replicate(" ",(x+MaxLen+3)-(x-2)) COLOR TITLE_OFF
        @ y,x say cTitle COLOR TITLE_OFF
        @ y+1,x+MaxLen+1 say " " + chr(31) + " " COLOR "w/n"
ENDIF


IF lDisp 
        DO WHILE .T.
                BottomOfBox = TopOfBox+NoOfBox-1
                nCount = 0
                KeyPress = 0                         

                DO WHILE nCount < NoofBox 
                        @ y+nCount+2,x say space(MaxLen) COLOR CONTROL_COLOR
                        @ y+nCount+2,x say aList[nCount+TopOfBox] COLOR CONTROL_COLOR
                        IF nCount+TopOfBox = nCurrent .and. lDisp
                                @ y+nCount+2,x say aList[nCount+TopOfBox] COLOR BROW_COLOR
                        endif
                        nCount++        
                ENDDO
        
                @ y+1,x say space(nWidth) COLOR CONTROL_COLOR
                @ y+1,x say aList[PickItem] COLOR SELECT_COLOR
        
                IF lDisp
                        mShow()
                        MouseDown = .f.                        
                        MouseScroll = .f.
                        
                        DO WHILE KeyPress == 0 .AND. .not. (MouseDown .or. MouseScroll)
                        
                                KeyPress = INKEY()
                                MousePress = mBout()
                        
                                IF (LastMousePress == 2) .and. (MousePress == 4)
                                        MouseDown = .T.
                                ENDIF
                        
                                IF LastMousePress <> MousePress .and. !(MouseDown)
                                        MouseDown = .F.
                                ENDIF
                                
                                IF (LastMousePress == 2) .and. (MousePress == 2)
                                        Timer++     
                                ENDIF
                        
                                IF Timer == 500
                                        MouseScroll = .T.     
                                        Timer = 0
                                ENDIF
                        
                                MXcoord := mX()
                                Mycoord := mY()
                                
                                LastMousePress = MousePress
                        
                        ENDDO
                        mHide()
                ENDIF                
                
                DO CASE
                
                CASE KeyPress >= 33 .and. KeyPress <= 126
                // Do a search on the table
                     Text2Search := UPPER(CHR(Keypress))
                     DO WHILE .T.   
                        
                        NewPickitem := MatchaStr(Text2Search,aList)
                        IF NewPickItem <> 0
                                PickItem := NewPickItem
                        ENDIF

                        nCurrent := PickItem
                        TopOfBox := PickItem                
                        TestList := PickItem - (LEN(aList) - NoOfItems + 1)
                        
                        IF TestList > 0        
                                TopOfBox := PickItem - TestList
                        ENDIF        
                        
                        NextKey := 0
                        SearchCount := 0
                        
                        DO WHILE SearchCount++ < 5000 .and. NextKey == 0                        
                                NextKey := Inkey()
                        ENDDO
                        
                        IF NextKey <> 0
                                Text2Search := Text2Search + UPPER(CHR(NextKey))            
                        ELSE
                                EXIT
                        ENDIF
                     
                     ENDDO
                     exit              
                CASE KeyPress = 271     // Shift tab 
                        aReturn[ACTION] = PREVFIELD
                        EXIT
                
                CASE KeyPress = 9       //  tab 
                        aReturn[ACTION] = NEXTFIELD
                        EXIT
                
                CASE KeyPress = 13      // enter
                        PickItem := nCurrent
                        aReturn[ACTION] = CHANGE_NEXT
                        @ y,x say cTitle COLOR TITLE_OFF
                        lDisp=.f.
                        KeyPress=0
                        LOOP                
                
                CASE KeyPress = 28     // F1 Pressed
                        aReturn[ACTION] = HELP          
                        EXIT
                
                CASE KeyPress = -1     // F2 Pressed
                        aReturn[ACTION] = ADD_NEW          
                        EXIT
                
                CASE KeyPress = 27     // Escape pressed
                        aReturn[ACTION] = ENDREAD
                        EXIT
                
                CASE (KeyPress == 5) .or. ;      // Up arrow
                (MYcoord == y+3) .and. ;
                 (MXcoord == x+MaxLen+3) .and. ;
                 (MouseScroll)    // space or clicked on
                        
                        IF nCurrent != 1
                                IF nCurrent=TopOfBox        
                                        TopOfBox--
                                        nCurrent--
                                ELSE
                                        nCurrent--
                                ENDIF
                        ENDIF
                        PickItem = nCurrent                        
                        MouseScroll = .F.                     
                        exit              

                CASE (KeyPress == 24) .or. ;    // Down arrow
                (MYcoord == y+2+noofitems) .and. ;
                (MXcoord == x+MaxLen+3) .and. ;
                (MouseScroll)     // space or clicked on
                        
                        IF nCurrent != LenArray
                                IF nCurrent = BottomofBox
                                        TopOfBox++
                                        nCurrent++
                                ELSE
                                        nCurrent++
                                ENDIF
                        ENDIF
                        PickItem = nCurrent                        
                        MouseScroll = .F.                     
                        exit

                CASE KeyPress = K_PGUP       // Page Up 
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
                        PickItem = nCurrent                        
                        exit

                CASE KeyPress = K_PGDN      // Page Down 
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
                        PickItem = nCurrent                        
                        exit

                CASE KeyPress = 32   // space pressed
                        IF lDynamic
                                PickItem := nCurrent
                                aReturn[ACTION] = CHANGE
                                EXIT
                        ENDIF
                
                CASE (MYcoord >= y+3 .and. ;
                        MYcoord <= y+NoOfItems+2 .and. ;
                        MXcoord >= x .and. ;
                        MXcoord <= x+MaxLen+2 .AND. ;
                        MouseDown )     // space or clicked on
                        
                        nCurrent := (MYcoord - (y+3)) + TopOfBox  
                        PickItem := nCurrent
                        
                        IF lDynamic
                                aReturn[ACTION] = CHANGE
                                EXIT
                        ENDIF
                
                CASE MouseDown   // Not in field area      
                        aReturn[MOUSEY] = MYcoord                
                        aReturn[MOUSEX] = MXcoord                
                        aReturn[ACTION] = MOUSE_FIELD                
                        EXIT                
                
                CASE .not. lDisp
                        EXIT

                ENDCASE
                MouseDown = .F.        
                MouseScroll = .F.     
                ContBar(nCurrent,LenArray,y+2,x+MaxLen+3,"rg/g",NoOfItems)
        ENDDO

        @ y+3,x SAY aList[TopOfBox] COLOR CONTROL_COLOR 

        aReturn[CHOICE] = PickItem                        

        IF lEmptyFlag 
                aReturn[CHOICE] = 0     // Empty array passed                        
        ENDIF

        @ y,x-1 say replicate(" ",(x+MaxLen+3)-(x-2)) COLOR TITLE_OFF
        @ y,x SAY cTitle COLOR TITLE_OFF                                
        @ y+1,x+MaxLen+1 say " " + chr(31) + " " COLOR "w/n"
        RESTSCREEN(y+2,x-1,y+NoOfItems+2,x+MaxLen+4,ExtraBox)
ENDIF

aReturn[LASTPO] := TopOfBox
DrawStatusBar("")

RETURN aReturn


/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ StatusNew( nRow, nCol, cColor )                                  บ
บ Screen                                                           บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Initialises a status indicator                                   บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION StatusNew( nRow, nCol, cColor )

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

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ StatusUpdate( aStat )                                            บ
บ Screen                                                           บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Rotates the status indicator one position                        บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION StatusUpdate( aStat )

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

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ mGetDialog(cFieldName,nSizeoffld)                                บ
บ Common dialog                                                    บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Gets a value from the user of character type                     บ
บ of length nSizeofld                                              บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION mGetDialog(cFieldName,nSizeoffld)

LOCAL OrigScreen := SaveScreen(10,15,17,65)
LOCAL cfield := SPACE(nSizeoffld)

oBox := WinBox():New(10,15,16,64,"")
oBox:Display()

CT(10," Enter new value ")
CT(16," <ESC - Exit>")
CT(12,cFieldName)
@ 13, (40 - (nSizeoffld/2)) GET cfield PICTURE "@!"
CT(15,"Enter the value or press ESC to abort")

SET CURSOR ON
READ
SET CURSOR OFF

RestScreen(10,15,17,65,OrigScreen)

IF (LASTKEY() != K_ESC) .AND. UPDATED()
   RETURN cField
ENDIF

RETURN SPACE(nSizeoffld)

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ DrawStatusBar(cMessage)                                          บ
บ Common Dialog                                                    บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ This function is to be used in the update of the                 บ
บ status bar, as to keep consistency                               บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE DrawStatusBar(cMessage) 

LOCAL oldcolor := SETCOLOR(STAT_COLOR)
@24,70 SAY "F1" COLOR "RG/B" 
@24,72 SAY "Help"
IF TRIM(cMessage)==""
        CT(24,SPACE(56))
ELSE
        CT(24,SPACE(56))
        CT(24,cMessage)
ENDIF
SETCOLOR(oldcolor)

RETURN

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ mMsgBox(cMessage1,cMessage2)                                     บ
บ Common Dialog                                                    บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Draws a message box, with a continue button                      บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION mMsgBox(cMessage1,cMessage2)

LOCAL OrigScreen := SaveScreen(10,15,17,65)

oBox := WinBox():New(10,15,16,64,"")
oBox:Display()

CT(10," Information Message ")
CT(12,cMessage1)
CT(13,cMessage2)
Button(15,36,"Continue",.t.)
RestScreen(10,15,17,65,OrigScreen)

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ DrawShadow(A,B,C,D)                                              บ
บ Screen                                                           บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Draws a shadow around an object at A,B to C,D                    บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
*-------------------------------------------
PROCEDURE DrawShadow(A,B,C,D)
*-------------------------------------------
n := B+1
l := C+1

DO WHILE n < D+2
    Screenbit := SAVESCREEN(l,n,l,n+1)
    Screenbit := ASC(screenbit)
    @l,n SAY CHR(Screenbit) COLOR SHADOW
    n=n+1
ENDDO

n := D+1
l := A+1

DO WHILE L < C+2
    Screenbit := SAVESCREEN(l,n,l,n+1)
    Screenbit := ASC(screenbit)
    @l,n SAY CHR(Screenbit) COLOR SHADOW
    L=L+1
ENDDO
RETURN


/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                  บ
บ                                                                  บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ                                                                  บ
บ                                                                  บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION TextField(y,x,cTitle,cSelection,lDisp)

LOCAL aReturn[4]
SETCOLOR(NOTI_COLOR)


IF .not. lDisp
        @y,x say cTitle COLOR NOTI_COLOR
        @y,x+LEN(cTitle)+1 say cSelection COLOR TITLE_ON
ELSE
        @y,x say cTitle COLOR LOG_ON        
        @y,x+LEN(cTitle)+1 get cSelection 
        SET CURSOR ON
        READ
        SET CURSOR Off
        aReturn[CHOICE] = cSelection
                        
        DO CASE
                CASE LASTKEY() = K_TAB 
                aReturn[ACTION] = NEXTFIELD

                CASE LASTKEY() = K_SH_TAB 
                aReturn[ACTION] = PREVFIELD

                CASE LASTKEY() = K_ENTER                         
                aReturn[ACTION] = CHANGE_NEXT

                CASE LASTKEY() = K_ESC                         
                aReturn[ACTION] = ENDREAD

        ENDCASE
        @y,x say cTitle COLOR NOTI_COLOR
        @y,x+LEN(cTitle)+1 say cSelection COLOR TITLE_ON
ENDIF
RETURN aReturn

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ ListBox()                                                        บ
บ Control                                                          บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Places a Listbox on the screen                                   บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ListBox(y,x,aList,nStart,cTitle,lDisp,lDynamic,nWidth,pItems,nTopOfBox)

// Control variables
LOCAL NoOfItems := pItems
LOCAL nCurrent,TopofBox,BottomOfBox
LOCAL aReturn[5]
LOCAL PickItem, lEmptyFlag:=.F. 
LOCAL KeyPress:=0
LOCAL MaxLen 
LOCAL ExtraBox
LOCAL TestList
LOCAL LenArray := 0
ListBoxKey := UserInput():New()   // The main keypress

/* Check if empty array has been passed */

IF EMPTY(aList)
        lEmptyFlag:=.T. 
        aadd(aList,"None")
ENDIF

/* Set up so that the box displays the correct option in the
scrollable area */

LenArray := Len(aList)

IF nStart > (LenArray - NoOfItems + 1) 
        TopOfBox = LenArray - NoOfItems + 1
ELSE
        TopOfBox = nStart
ENDIF

IF !EMPTY(nTopOfBox)
        TopOfBox = nTopOfBox
ENDIF

IF LenArray == 1 .or. LenArray == 2
   TopOfBox := 1
ENDIF

PickItem := nStart
nCurrent := nStart

IF nWidth=0
        MaxLen := MaxStr(aList)
ELSE
        MaxLen := nWidth
ENDIF

NoOfBox := NoOfItems

IF NoOfItems > LenArray
        NoOfBox := LenArray
ENDIF

savecol := SETCOLOR(CONTROL_COLOR)

ExtraBox = SAVESCREEN(y,x-1,y+NoOfItems,x+MaxLen+4)
@ y+1,x-1 CLEAR TO y+NoOfItems,x+MaxLen+3 
Drawshadow(y+1,x-1,y+NoOfItems,x+MaxLen+3) 

SETCOLOR(savecol)

@ y,x say cTitle COLOR TITLE_ON 
ContBar(nCurrent,LenArray,y+1,x+MaxLen+3,"rg/g",NoOfItems)
@ y+1,x+Maxlen+2 say chr(30) color "rg/g"
@ y+NoOfItems,x+Maxlen+2 say chr(31) color "rg/g"
  
ListBoxKey:MouseDown := .f.                        
                
DO WHILE .T.
        BottomOfBox = TopOfBox+NoOfBox-1
        nCount = 0

        ListBoxKey:KeyPress = 0

        DO WHILE nCount < NoofBox
                @ y+nCount+1,x say space(MaxLen) COLOR CONTROL_COLOR
                @ y+nCount+1,x say aList[nCount+TopOfBox] COLOR CONTROL_COLOR
                IF nCount+TopOfBox = nCurrent
                        @ y+nCount+1,x say aList[nCount+TopOfBox] COLOR BROW_COLOR
                endif
                nCount++        
        ENDDO
        
        ListBoxKey:GetInput()
                
        DO CASE
                
                CASE ListBoxKey:KeyPress >= 33 .and. ListBoxKey:KeyPress <= 126
                // Do a search on the table
                     Text2Search := UPPER(CHR(ListBoxKey:Keypress))
                     DO WHILE .T.   
                        
                        NewPickitem := MatchaStr(Text2Search,aList)
                        IF NewPickItem <> 0
                                PickItem := NewPickItem
                        ENDIF

                        nCurrent := PickItem
                        TopOfBox := PickItem                
                        TestList := PickItem - (LEN(aList) - NoOfItems + 1)
                        
                        IF TestList > 0        
                                TopOfBox := PickItem - TestList
                        ENDIF        
                        
                        NextKey := 0
                        SearchCount := 0
                        
                        DO WHILE SearchCount++ < 5000 .and. NextKey == 0                        
                                NextKey := Inkey()
                        ENDDO
                        
                        IF NextKey <> 0
                                Text2Search := Text2Search + UPPER(CHR(NextKey))            
                        ELSE
                                EXIT
                        ENDIF
                     
                     ENDDO
                     exit              

                CASE ListBoxKey:KeyPress = 271     // Shift tab
                        aReturn[ACTION] = PREVFIELD
                        EXIT
                
                CASE ListBoxKey:KeyPress = 9       //  tab 
                        aReturn[ACTION] = NEXTFIELD
                        EXIT
                
                CASE ListBoxKey:KeyPress = 13      // enter
                        PickItem := nCurrent
                        aReturn[ACTION] = CHANGE_NEXT
                        @ y,x say cTitle COLOR TITLE_OFF
                        ListBoxKey:KeyPress := 0

//                      LOOP
                        exit

                CASE ListBoxKey:KeyPress = 28     // F1 Pressed
                        aReturn[ACTION] = HELP          
                        EXIT
                
                CASE ListBoxKey:KeyPress = -1     // F2 Pressed
                        aReturn[ACTION] = ADD_NEW          
                        EXIT
                
                CASE ListBoxKey:KeyPress = 27     // Escape pressed
                        aReturn[ACTION] = ENDREAD
                        EXIT
                
                CASE (ListBoxKey:MYcoord == y+2) .and. ;
                (ListBoxKey:MXcoord == x+MaxLen+3) .and. ;
                (ListBoxKey:MouseScroll) .or. ;    // space or clicked on
                (ListBoxKey:KeyPress == 5)        
                        
                        IF nCurrent != 1
                                IF nCurrent=TopOfBox        
                                        TopOfBox--
                                        nCurrent--
                                ELSE
                                        nCurrent--
                                ENDIF
                        ENDIF

                        PickItem = nCurrent
                        ListBoxKey:MouseScroll = .F.                     

                        IF ListBoxKey:Keypress == 5
                                EXIT
                        ENDIF

                CASE (ListBoxKey:KeyPress == 24) .or. ;    // Down arrow
                (ListBoxKey:MYcoord == y+1+noofbox) .and. ;
                (ListBoxKey:MXcoord == x+MaxLen+3) .and. ;
                (ListBoxKey:MouseScroll)     // space or clicked on
                        
                        IF nCurrent != LenArray
                                IF nCurrent = BottomofBox
                                        TopOfBox++
                                        nCurrent++
                                ELSE
                                        nCurrent++
                                ENDIF
                        ENDIF

                        Pickitem = nCurrent
                        ListBoxKey:MouseScroll = .F.                     

                        IF ListBoxKey:Keypress == 24
                                EXIT
                        ENDIF
                
                CASE ListBoxKey:KeyPress = K_PGUP       // Page Up 
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
                        Pickitem = nCurrent
                      exit

                CASE ListBoxKey:KeyPress = K_PGDN      // Page Down
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
                        Pickitem = nCurrent
                      exit

                CASE ListBoxKey:KeyPress = 32   // space pressed
                        PickItem := nCurrent
                        aReturn[ACTION] = CHANGE
                        EXIT
                
                CASE (ListBoxKey:MYcoord >= y+2 .and. ;
                        ListBoxKey:MYcoord <= y+NoOfBox+1 .and. ;
                        ListBoxKey:MXcoord >= x .and. ;
                        ListBoxKey:MXcoord <= x+MaxLen+2 .AND. ;
                        ListBoxKey:MouseDown )      
                        
                        nCurrent := (ListBoxKey:MYcoord - (y+2)) + TopOfBox  
                        PickItem := nCurrent
                        
                        aReturn[ACTION] = CHANGE
                        EXIT
 
                                      
                CASE ListBoxKey:MouseDown   // Not in field area      
                        aReturn[MOUSEY] = ListBoxKey:MYcoord                
                        aReturn[MOUSEX] = ListBoxKey:MXcoord                
                        aReturn[ACTION] = MOUSE_FIELD                
                        EXIT
                
                otherwise
                        EXIT

        ENDCASE
        ContBar(nCurrent,LenArray,y+1,x+MaxLen+3,"rg/g",NoOfItems)
ENDDO

aReturn[CHOICE] = PickItem                        

IF lEmptyFlag 
       aReturn[CHOICE] = 0     // Empty array passed                        
ENDIF

@ y,x-1 say replicate(" ",(x+MaxLen+3)-(x-2)) COLOR TITLE_OFF
@ y,x SAY cTitle COLOR TITLE_OFF                                

aReturn[LASTPO] := TopOfBox
DrawStatusBar("")

RETURN aReturn



