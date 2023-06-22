#include "control.h"
#include "inkey.ch"
*----------------------------------------------------
* Creates a Mac style menu structure
* Adapted by A.J.D. Business Software 
* (C)Copyright 1994
*----------------------------------------------------
*----------------------------------------------------
* MAIN MENU 
*----------------------------------------------------
/* The following creates a standard mac style popup
menu system. The menu prompts that run across the 
top of the screen are defined by the "@n,m prompt"
commands. 

cWhich selects the relevant array to use for the sub
menus. (Like a table).

The case structure calls the modules
        CASE Str(nSubChoice,1,0)+cWhich = "3aMenu1"
             ___________________ ______
             ^ The sub choice    ^ The main choice
*/

STATIC NOOFOPTS:=6
LOCAL nChoice, nSubChoice, cWhich, nTop, nLeft, nBottom, nRight
LOCAL cScreen := SaveScreen(0,0,24,79)
LOCAL cSubScr

PRIVATE aMenu1 := {"Open Database"}
PRIVATE aMenu2 := {"Remedy","Browse","String"}
PRIVATE aMenu3 := {"New Fault","Modify"}
PRIVATE aMenu4 := {"Make","Model","Symptom"}
PRIVATE aMenu5 := {"Index","About.."}

SET WRAP ON
SET CURSOR OFF
SET SCOREBOARD OFF
BaseScreen()                            // Paints the background 

DrawBox(2,4,5,66,"Main Menu")           // Draws a box 
Minit()                                 // Initialise mouse

DO WHILE .T.
        SetColor("n/rg,w/rb")
        @ 4, 5 PROMPT "  File   "
        @ 4,15 PROMPT " Search  "
        @ 4,25 PROMPT "  Add    "
        @ 4,35 PROMPT " Reports "
        @ 4,45 PROMPT "  Help   "
        @ 4,55 PROMPT "  Quit   "
        
        MENU TO nChoice

        cWhich := "aMenu" + Str(nChoice,1,0)

        DO CASE
                CASE nChoice = 0
                        LOOP
                CASE nChoice = 1
                        nTop    = 6
                        nLeft   = 5
                        nBottom = nTop + len(aMenu1) 
                        nRight  = nLeft + MaxStr(aMenu1)
                
                CASE nChoice = 2
                        nTop    = 6
                        nLeft   = 15
                        nBottom = nTop + len(aMenu2) 
                        nRight  = nLeft + MaxStr(aMenu2)
                CASE nChoice = 3
                        nTop    = 6
                        nLeft   = 25
                        nBottom = nTop + len(aMenu3) 
                        nRight  = nLeft + MaxStr(aMenu3)
                CASE nChoice = 4
                        nTop    = 6
                        nLeft   = 35
                        nBottom = nTop + len(aMenu4) 
                        nRight  = nLeft + MaxStr(aMenu4)
                CASE nChoice = 5
                        nTop    = 6
                        nLeft   = 45
                        nBottom = nTop + len(aMenu5) 
                        nRight  = nLeft + MaxStr(aMenu5)
                CASE nChoice = 6
                        RestScreen(0,0,24,79,cScreen)
                        EXIT
        ENDCASE
        
        cSubScr := SaveScreen(nTop,(nLeft-2),(nBottom+2),(nRight+2))
         
        DrawNotice(nTop,(nLeft-1),(nBottom+1),(nRight+1),"") 

        nSubChoice := Achoice((nTop+1),nLeft,nBottom,nRight,&cWhich)

        IF LastKey() = 4 .AND. nChoice <> NOOFOPTS-1
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+2),cSubScr)
                KEYBOARD Chr(4) + Chr(13)        
        ELSEIF LastKey() = 4 .AND. nChoice = NOOFOPTS-1
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+2),cSubScr)
                KEYBOARD Chr(4)
        ELSEIF LastKey() = 19 .and. nChoice <> 1
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+2),cSubScr)
                KEYBOARD Chr(19) + Chr(13)        
        ELSEIF LastKey() = 19 .AND. nChoice = 1
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+2),cSubScr)
                KEYBOARD Chr(19)
        ENDIF

        IF nSubChoice = 0
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+2),cSubScr)
                LOOP
        ENDIF

        DO CASE
                CASE Str(nSubChoice,1,0)+cWhich = "1aMenu1"
                        DO mOpenFile
                CASE Str(nSubChoice,1,0)+cWhich = "1aMenu2"
                        DO TestStub
                CASE Str(nSubChoice,1,0)+cWhich = "2aMenu2"
                        DO TestStub2
                CASE Str(nSubChoice,1,0)+cWhich = "3aMenu2"
                        DO TestStub3
                CASE Str(nSubChoice,1,0)+cWhich = "1aMenu5"
                        DO MultiTemp
                CASE Str(nSubChoice,1,0)+cWhich = "2aMenu5"
                        DO mAbout
        ENDCASE
        
        RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+2),cSubScr)
        KEYBOARD Chr(13)

ENDDO
SET CURSOR ON
mEnd()
*-----------------------------------
* The following are just test stubs for
* the interface designs above.

*------------------------------------
PROCEDURE TestStub2
*------------------------------------
LOCAL aTest := {"One","Two","Three","Four","Five"}
LOCAL OrigScreen := SaveScreen(8,20,17,61)

DrawNotice(8,20,16,60,"Test Stub #2")
aRadNum := RadioButton(9,25,aTest,2,"Test Radio",.t.,.f.)
CT(24,str(aRadNum[CHOICE])+ str(aRadNum[ACTION]))
RestScreen(8,20,17,61,OrigScreen)
return

*-------------------------------------------
PROCEDURE TestStub
*-------------------------------------------
LOCAL OrigScreen := SaveScreen(15,20,19,61)

DrawNotice(15,20,18,60,"Test Stub #1")
aLogBut := LogButton(16,22,"Select ON or OFF :",.t.,.t.,.f.)
CT(24,iif(aLogBut[CHOICE]=.t.,"TRUE","FALSE")+ str(aLogBut[ACTION]))
RestScreen(15,20,19,61,OrigScreen)
RETURN

*-------------------------------------------
PROCEDURE TestStub3
*-------------------------------------------
LOCAL aTest := {"One","Two","Three"}
LOCAL OrigScreen := SaveScreen(7,20,16,61)

DrawNotice(7,20,15,40,"Test Stub #3")
aCombo := ComboBox(8,22,aTest,2,"Test",.t.,.f.,0)
CT(24,str(aCombo[CHOICE])+ str(aCombo[ACTION]))
RestScreen(7,20,16,61,OrigScreen)
RETURN

*------------------------------------
PROCEDURE MultiTemp
*------------------------------------
STATIC NUMFIELDS:=5

/* Save the screen */
LOCAL OrigScreen := SaveScreen(6,15,17,66)

/* Common interface variables */
LOCAL GetField:=1            // Field counter
LOCAL aGetValue[NUMFIELDS]   // Stores results of fields
LOCAL aCurrentField[4]       // Gets the return value
LOCAL cText := space(17)

/* Define items in displays */
aTest := {"HD","D","CR","P","P2","F"}
aTest2 := {"BUS1000","BUS1100","BUS2000","BUS2150","ACC1021"}

aGetValue:={1,2,.t.,SPACE(17),0}         // Store initial values

DrawNotice(6,15,16,65,"Multi Control Test Stub")

/* The following are the equivalant of @..SAY
They just display the new items in the screen 
The Last parameter passed as .f. shows this */

RadioButton(7,20,aTest,aGetValue[1],"Grade",.f.,.f.)
ComboBox(7,30,aTest2,aGetValue[2],"Subject",.f.,.f.,0)
LogButton(9,42,"Good Student",aGetValue[3],.f.,.f.)
TextField(11,42,"Test",aGetValue[4],.f.)
Button(14,55,"Save",.f.)


/* Main loop where reads take place. Uses field counter
to count which field it is up to */

DO WHILE .T.
        DO CASE
                CASE GetField=1
                        aCurrentField := RadioButton(7,20,aTest,aGetValue[GetField],"Grade",.t.,.f.)
                CASE GetField=2
                        aCurrentField := ComboBox(7,30,aTest2,aGetValue[GetField],"Subject",.t.,.f.,0)
                CASE GetField=3
                        aCurrentField := LogButton(9,42,"Good Student :",aGetValue[GetField],.t.,.f.)
                CASE GetField=4
                        aCurrentField := TextField(11,42,"Test",aGetValue[4],.t.)                        
                CASE GetField=5
                        aCurrentField := Button(14,55,"Save",.t.)
        ENDCASE
        
        aGetValue[GetField] =  aCurrentField[CHOICE]

        DO CASE
                CASE (aCurrentField[ACTION] == NEXTFIELD .or. aCurrentField[ACTION] = CHANGE_NEXT) ;
                .AND. GetField != NUMFIELDS
                        GetField++
                CASE aCurrentField[ACTION] == PREVFIELD  ;
                .AND. GetField != 1
                        GetField--
                CASE aCurrentField[ACTION] == ENDREAD 
                        CT(24,"Aborted edit")
                        EXIT
                CASE aCurrentField[ACTION] == SAVEREAD 
                        CT(24,"Information Saved")
                        EXIT
                CASE aCurrentField[ACTION] == CHANGE_NEXT .and. ;
                        (Getfield == 5)
                        CT(24,"Information Saved")
                        EXIT
                CASE aCurrentField[ACTION] == MOUSE_FIELD                 
                        GetField = MultiTempFields(aCurrentField[MOUSEY],aCurrentField[MOUSEX],GetField)

        ENDCASE
 
ENDDO

RestScreen(6,15,17,66,OrigScreen)
RETURN

//-------------------------
FUNCTION MultiTempFields(y,x,old)
//-------------------------
// This function will return the field values that the mouse cursor has hit

y=y-1
x=x-1

DO CASE
        CASE y >= 7 .and. y <= 12 .and. ;
        x >= 20 .and. x <= 26
                RETURN 1
        
        CASE y >= 7 .and. y <= 8 .and. ;
        x >= 30 .and. x <= 39
                RETURN 2
        
        CASE y == 9 .and. ;
        x >= 42 .and. x <= 57
                RETURN 3

        CASE y == 11 .and. ;
        x >= 42 .and. x <= 59
                RETURN 4
        
        CASE y == 14 .and. ;
        x >= 54 .and. x <= 59
                RETURN 5
ENDCASE
RETURN Old
*-------------------------------------------
PROCEDURE mAbout
*-------------------------------------------
LOCAL OrigScreen := SaveScreen(10,20,17,61)
LOCAL nCount := 0

DO WHILE nCount<=1000
        StatBar(ncount++,1000)
ENDDO

XDrawBox(10,20,16,59,"About")
CT(11,"VCR and TV Fault Finder")
CT(12,"Version 2.0 For DOS")
CT(13,"(C) A.J.D. Business Software 1994")
Button(15,35,"Continue",.t.)
RestScreen(10,20,17,61,OrigScreen)
RETURN

*-------------------------------------------
PROCEDURE mOpenFile
*-------------------------------------------
/* Save the screen */
LOCAL OrigScreen := SaveScreen(8,5,19,76)

/* Get initial directory information */
STATIC NUMFIELDS:=4 
LOCAL GetField:=1                       && Field counter
LOCAL aGetValue:={1,1,1,1}              && Stores results of fields
LOCAL aCurrentField[2]                  && Gets the return value

/* Common interface variables */
PRIVATE aDrives:=AvailDrive()
PRIVATE nStartDrv:=MatchAStr(DiskName(),aDrives)
PRIVATE nStartFile:=1
PRIVATE aDirs:=GetDirs()
PRIVATE aFiles:=GetFiles()

XdrawBox(8,5,18,75,"Open Database")
@ 9,10 say "Filename:"

DO mFileOpSays
@ 9,19 say aDrives[nStartDrv]+":"+iif(len(dirname())=1,"\",DirName()+"\")

/* Main loop where reads take place. Uses field counter
to count which field it is up to */

DO WHILE .T.
        
        DO CASE
                CASE GetField=1
                        aCurrentField :=ComboBox(10,10,aDrives,nStartDrv,"Drive",.T.,.t.,5)
                        DiskChange(aDrives[(aCurrentField[CHOICE])]) && Change to new drive
                        aDirs:=GetDirs()          && Update Directory info              
                        aFiles:=GetFiles()        && Update File info
                        nStartDrv:=MatchAStr(DiskName(),aDrives)
                        DO mFileOpSays            && Display new info to screen                                            
                
                CASE GetField=2
                        aCurrentField :=ComboBox(10,20,aDirs,1,"Directories",.T.,.t.,12)
                        IF aCurrentField[ACTION] = CHANGE_NEXT .or. aCurrentField[ACTION] = CHANGE
                                DirChange(".\"+aDirs[(aCurrentField[CHOICE])])                                
                                aDirs:=GetDirs()          && Update Directory info              
                                aFiles:=GetFiles()        && Update File info
                                DO mFileOpSays            && Display new info to screen
                                IF aCurrentField[ACTION] = CHANGE_NEXT 
                                        aCurrentField[ACTION] = NEXTFIELD
                                ENDIF
                        ENDIF                
                
                CASE GetField=3
                        aCurrentField :=ComboBox(10,40,aFiles,nStartFile,"Files",.T.,.t.,12)
                        nStartFile:=aCurrentField[CHOICE]
                CASE GetField=4        
                        aCurrentField := Button(16,58,"Select File",.t.)
                        IF aFiles[aGetValue[3]]="None" .and. aCurrentField[ACTION] = SAVEREAD
                                SaveCol := setcolor("r/w")
                                CT(24,"You must select a file to open")
                                setColor(SaveCol)
                                inkey(0)
                                aCurrentField[ACTION]=PREVFIELD
                        ENDIF
        ENDCASE
        
        aGetValue[GetField] =  aCurrentField[CHOICE]
        
        DO CASE
                CASE (aCurrentField[ACTION] = NEXTFIELD ;
                .OR. aCurrentField[ACTION] = CHANGE_NEXT) ;
                .AND. GetField != NUMFIELDS
                        GetField++
                
                CASE aCurrentField[ACTION] = PREVFIELD ;
                .AND. GetField != 1
                        GetField--
                
                CASE aCurrentField[ACTION] = ENDREAD 
                        CT(24,"Open Cancelled")
                        EXIT
                
                CASE aCurrentField[ACTION] = SAVEREAD 
                        CT(24,aDrives[nStartDrv]+":"+iif(len(dirname())=1,"\",DirName()+"\")+aFiles[aGetValue[3]])
                        EXIT
        ENDCASE
        
        @ 9,19 say space(54)
        @ 9,19 say cFile2Open := aDrives[nStartDrv]+":" + ;
        iif(len(dirname())=1,"\",DirName()+"\")+iif(aFiles[aGetValue[3]]="None","*",aFiles[aGetValue[3]])

ENDDO
CT(24,SPACE(50))

IF .not. aCurrentField[ACTION] = ENDREAD ;
.and. mGenYesNo("Will I open the database",cFile2Open) 
        /* Add your own commands to open database here */        
        CT(24,"Database open")
ELSE
        CT(24,"Open Cancelled")
ENDIF

RestScreen(8,5,19,76,OrigScreen)
RETURN

*---------------------------
PROCEDURE mFileOpSays
*---------------------------
/* This procedure just updates the screen with the new 
information for the mFileOpen module */

ComboBox(10,10,aDrives,nStartDrv,"Drive",.f.,.f.,5)
ComboBox(10,20,aDirs,1,"Directories",.f.,.f.,12)
ComboBox(10,40,aFiles,nStartFile,"Files",.f.,.f.,12)
Button(16,58,"Select File",.f.)
RETURN

//----------------------------------------
FUNCTION TextField(y,x,cTitle,cText,lDisp)
//----------------------------------------
LOCAL aReturn[2]

IF .not. lDisp
        @y,x say cTitle COLOR NOTI_COLOR
        @y,x+LEN(cTitle)+1 say cText COLOR TITLE_ON
ELSE
        @y,x say cTitle COLOR LOG_ON        
        @y,x+LEN(cTitle)+1 get cText 
        READ
        aReturn[CHOICE] = cText
                        
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
        @y,x+LEN(cTitle)+1 say cText COLOR TITLE_ON
ENDIF
RETURN aReturn
