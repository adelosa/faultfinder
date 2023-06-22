/* 
Release Information
----------------------
Version 2.0 for DOS
Pre 15-12-94    Release 1.0             Production Version
    15-12-94    Release 1.01            Fix up Logical button so
                                        that enter button does not
                                        change value

*/

#include "CONTROL.H"
#include "Inkey.ch"
#include "DATAEXT.H"

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

STATIC NOOFOPTS:=5
LOCAL nChoice, nSubChoice, cWhich, nTop, nLeft, nBottom, nRight
LOCAL cScreen := SaveScreen(0,0,24,79)
LOCAL cSubScr
LOCAL sCurrFaultBook := SPACE(1)

PUBLIC cTopic := "MAINMENU"
PUBLIC gPageInPrint := .f.
PUBLIC UserFaults := 0
PUBLIC VerNum := "1.01"     // Temp to store beta version number

PRIVATE aMenu1 := {"Open Database","Prepare Disk"}
PRIVATE aMenu2 := {"Remedy"}
PRIVATE aMenu3 := {"New Fault"}
PRIVATE aMenu4 := {"Index","About.."}

PRIVATE cDataName := ""

SET CURSOR OFF
SET WRAP ON
SET STATUS OFF
SET SCOREBOARD OFF
SET KEY K_F1 TO HelpOn(cTopic)

BaseScreen()            /* Paints the background */

OrigColor := SetColor(WIN_COLOR)

mAbout()                /* Display About Box */

// Get fault restriction of fault number

IF FILE("User.ini")
        RESTORE FROM ("USER.INI") ADDITIVE
        UserFaults  := VAL(RetrieveCode(NameFaults, NameDistn))
ENDIF

aFiles:=GetValidData(GetFiles())
IF LEN(aFiles) = 0
        SetColor(OrigColor)
        Clear screen
        ? "No Faultbooks available"
        QUIT
ENDIF
sCurrFaultBook := aFiles[1]

DrawStatusBar("")

DrawBox(1,14,3,66)       /* Draws menu box */
SetColor(WIN_COLOR)
DO WHILE .T.
        @ 24, 0 say "            Faultbook: "+ sCurrFaultBook COLOR STAT_COLOR
        
        @ 2,15 PROMPT "   File    "
        @ 2,25 PROMPT "  Search   "
        @ 2,35 PROMPT "    Add    "
        @ 2,45 PROMPT "   Help    "
        @ 2,55 PROMPT "   Quit    "
        MENU TO nChoice
        
        cWhich := "aMenu" + Str(nChoice,1,0)

        DO CASE
                CASE nChoice = 0
                        LOOP
                CASE nChoice = 1
                        nTop    = 4
                        nLeft   = 15
                        nBottom = nTop + len(aMenu1) 
                        nRight  = nLeft + MaxStr(aMenu1)
                
                CASE nChoice = 2
                        nTop    = 4
                        nLeft   = 25
                        nBottom = nTop + len(aMenu2) 
                        nRight  = nLeft + MaxStr(aMenu2)
                CASE nChoice = 3
                        nTop    = 4
                        nLeft   = 35
                        nBottom = nTop + len(aMenu3) 
                        nRight  = nLeft + MaxStr(aMenu3)
                CASE nChoice = 4
                        nTop    = 4
                        nLeft   = 45
                        nBottom = nTop + len(aMenu4) 
                        nRight  = nLeft + MaxStr(aMenu4)
                CASE nChoice = 5
                        IF mGenYesNo("Leave VCR and TV Fault Finder","and EXIT to DOS") 
                                RestScreen(0,0,24,79,cScreen)
                            DO WHILE .T.    
                                IF ISPRINTER() .AND. gPageInPrint
                                        EJECT
                                        QUIT
                                ELSE
                                        IF gPageInPrint .AND. .NOT. pError()                        
                                                LOOP
                                        ENDIF
                                        QUIT
                                ENDIF
                            ENDDO    
                        ELSE
                            LOOP
                        ENDIF
        ENDCASE
        
        cSubScr := SaveScreen(nTop,(nLeft-2),(nBottom+2),(nRight+1))
         
        DrawBox(nTop,(nLeft-1),(nBottom+1),(nRight+1)) 

        nSubChoice := Achoice((nTop+1),nLeft,nBottom,nRight,&cWhich)

        
        DrawStatusBar("")
        
        IF LastKey() = 4 .AND. nChoice <> NOOFOPTS-1
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+1),cSubScr)
                KEYBOARD Chr(4) + Chr(13)        
        ELSEIF LastKey() = 4 .AND. nChoice = NOOFOPTS-1
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+1),cSubScr)
                KEYBOARD Chr(4)
        ELSEIF LastKey() = 19 .and. nChoice <> 1
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+1),cSubScr)
                KEYBOARD Chr(19) + Chr(13)        
        ELSEIF LastKey() = 19 .AND. nChoice = 1
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+1),cSubScr)
                KEYBOARD Chr(19)
        ENDIF

        IF nSubChoice = 0
                RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+1),cSubScr)
                LOOP
        ENDIF

        RestScreen(nTop,(nLeft-2),(nBottom+2),(nRight+1),cSubScr)
        
        DO CASE
                CASE Str(nSubChoice,1,0)+cWhich = "1aMenu1"
                        sCurrFaultBook := mOpenFile(sCurrFaultBook)
                CASE Str(nSubChoice,1,0)+cWhich = "1aMenu2"
                        mFindFault(sCurrFaultBook)
                CASE Str(nSubChoice,1,0)+cWhich = "2aMenu1"
                        mSave2Disk(sCurrFaultBook)
                CASE Str(nSubChoice,1,0)+cWhich = "1aMenu3"
                        mNewFault(sCurrFaultBook)
                CASE Str(nSubChoice,1,0)+cWhich = "2aMenu3"
                        mGimmiabreak()
                CASE Str(nSubChoice,1,0)+cWhich = "1aMenu4"
                        HelpIndex()
                CASE Str(nSubChoice,1,0)+cWhich = "2aMenu4"
                        mAbout()
        ENDCASE
        
        KEYBOARD Chr(13)

ENDDO
SET CURSOR ON

//------------------------------------------
// Display Dialogs  
//------------------------------------------ 
// The following are the implementations
// for the screens in this program using the
// screen controls (CONTROL.PRG, CONTROL.H) and
// the file functions (FINDFAUL.PRG)

*-------------------------------------------
PROCEDURE mAbout
*-------------------------------------------
LOCAL OrigScreen := SaveScreen(5,5,18,75)
LOCAL nCount := 0
LOCAL RetValue := {1,CHANGE}
LOCAL OldTopic := cTopic
LOCAL CompText := "VCR and TV Fault Finder Version 2 for DOS )*()*()*"

cTopic = "ABOUT"

IF FILE("User.ini")
        mExitCode := .F.
        RESTORE FROM ("USER.INI") ADDITIVE
        UserName        := RetrieveCode(NameCode,CompText)
ELSE
        // Insert unregistered info here
        mExitCode := .t.
        UserName        := "UNLICENCED VERSION"
        NameDistn       := "REGISTER TODAY"
ENDIF

XDrawBox(7,10,17,69)
CT(7," About ")
CT(8,"VCR and TV Fault Finder")
CT(9,"Version 2.0 For DOS")
CT(10,"Release "+vernum)
CT(11,"(C) A.J.D. Business Software 1994")

CT(12,"Registered to "+ TRIM(UserName))
CT(13,"Distributor   "+ TRIM(NameDistn))

DO WHILE RetValue[ACTION] != CHANGE_NEXT
        DrawStatusBar("Press F1 for more information")
        RetValue := Button(15,35,"Continue",.t.)

        IF RetValue[ACTION] = HELP
                DrawStatusBar("")
                HelpOn()
        ENDIF
ENDDO

RestScreen(5,5,18,75,OrigScreen)

IF mExitCode
        Clear Screen
        Close all
        Quit
ENDIF

DrawStatusBar("") 
cTopic = OldTopic

RETURN

*-------------------------------------------
PROCEDURE mFindFault(sRemData)
*-------------------------------------------
/* Save the screen */

LOCAL NUMFIELDS:=7 
LOCAL OrigScreen := SaveScreen(0,4,23,75)

/* Get initial fault information */
LOCAL GetField:=1                     && Field counter
LOCAL aCurrentField[2]                && Gets the return value

LOCAL cInifile :=  sRemData + INIFILE
LOCAL OldTopic := cTopic
cTopic = "FINDFAULT"

/* Common interface variables */
RESTORE FROM (cInifile) ADDITIVE      // Get Categories
PRIVATE aGetValue:={1,1,.t.,1,1,1,1}        // Stores results of fields
PRIVATE aTest := {vCat1,vCat2,vCat3,vCat4,vCat5,vCat6,vCat7,vCat8,vCat9,vCat0}
PRIVATE aMakes := GetMake(sRemData)

IF LEN(aMakes) = 0
        mMsgBox("No faults on record","Add using ADD function")
        RESTSCREEN(0,4,23,75,OrigScreen)
        RETURN
ENDIF

PRIVATE aModels := GetModel(aMakes[aGetValue[1]][2],sRemData)
PRIVATE aFaults := GetFault(LTRIM(str(aGetValue[4])),aModels[aGetValue[2]],aMakes[aGetValue[1]][2],aGetValue[3],sRemData)
IF EMPTY(aFaults) 
        AADD(aFaults,{"No Faults Found","","","","",0})  
ENDIF

XdrawBox(1,5,22,75)
CT(1," Find Fault " + sRemData + " ") // display the window heading
CT(22,"< ESC Exit >")
mfindfsays()

/* Main loop where reads take place. Uses field counter
to count which field it is up to */

DO WHILE .T.
        DO CASE
                CASE GetField=1
                        DrawStatusBar("Found "+ltrim(str(len(aMakes))))
                        aGetValue[2] = 1  // Reset the model number 
                        aCurrentField := ComboBox(2,10,mList(aMakes,1),aGetValue[1],"Makes",.t.,.t.,10)
                        aGetValue[GetField] =  aCurrentField[CHOICE]
                        
                        IF aCurrentField[ACTION] != ENDREAD .and. ;
                        aCurrentField[ACTION] != HELP
                                aModels := GetModel(aMakes[aGetValue[1]][2],sRemData)
                                aFaults := GetFault(LTRIM(str(aGetValue[4])),aModels[aGetValue[2]],aMakes[aGetValue[1]][2],aGetValue[3],sRemData)
                                IF EMPTY(aFaults) 
                                        AADD(aFaults,{"No Faults Found","","","","",0})  
                                ENDIF
                                mfindfsays()            && Display new info to screen                 
                        ENDIF                

                CASE GetField=2
                        DrawStatusBar("")
                        @24,0 say "     " COLOR STAT_COLOR
                        DrawStatusBar("Found "+ltrim(str(len(aModels))))
                        aCurrentField :=ComboBox(2,25,aModels,aGetValue[2],"Models",.t.,.t.,25)
                        aGetValue[GetField] =  aCurrentField[CHOICE]
                        
                        IF aCurrentField[ACTION]!=ENDREAD .and. ; 
                        aCurrentField[ACTION] != HELP
                                aFaults := GetFault(LTRIM(str(aGetValue[4])),aModels[aGetValue[2]],aMakes[aGetValue[1]][2],aGetValue[3],sRemData)
                                IF EMPTY(aFaults) 
                                        AADD(aFaults,{"No Faults Found","","","","",0})  
                                ENDIF
                                mfindfsays()            // Display new info to screen
                        ENDIF
                        IF aCurrentField[ACTION] = CHANGE_NEXT 
                                aCurrentField[ACTION] = NEXTFIELD
                        ENDIF

                CASE GetField=3                        
                        IF aGetValue[3] 
                                DrawStatusBar("Press <space> to disable Categories")
                        ELSE
                                DrawStatusBar("Press <space> to use Categories")
                        ENDIF
                        aCurrentField := LogButton(2,55,"Use Categories:",aGetValue[3],.t.,.t.)
                        aGetValue[3] = aCurrentField[CHOICE] 
                        
                        IF aCurrentField[ACTION] == CHANGE_NEXT
                                aCurrentField[ACTION] = NEXTFIELD
                        ENDIF
                        IF aCurrentField[ACTION] == CHANGE
                                LOOP
                        ENDIF
                        
                        aGetValue[7] = 1        // Reset starting point for Fault and remedy SAYBOX
                        aFaults := GetFault(LTRIM(str(aGetValue[4])),aModels[aGetValue[2]],aMakes[aGetValue[1]][2],aGetValue[3],sRemData)                
                        DrawStatusBar("")
                
                CASE GetField=4                        
                        IF aGetValue[3]
                                aCurrentField := ComboBox(4,55,aTest,aGetValue[4],"Category",.t.,.t.,15)
                                aFaults := GetFault(LTRIM(str(aCurrentField[CHOICE])),aModels[aGetValue[2]],aMakes[aGetValue[1]][2],aGetValue[3],sRemData)             
                                
                                IF EMPTY(aFaults) .AND. aCurrentField[ACTION] != ENDREAD ;
                                .AND. aCurrentField[ACTION] != HELP;
                                .AND. aCurrentField[ACTION] != PREVFIELD
                                        aCurrentField[ACTION] = CHANGE
                                        AADD(aFaults,{"No Faults Found","","","","",0})  
                                ENDIF
                        
                                IF aCurrentField[ACTION] != ENDREAD ; 
                                .AND. aCurrentField[ACTION] != HELP ;                      
                                .AND. aCurrentField[ACTION] != PREVFIELD
                                        aGetValue[GetField] =  aCurrentField[CHOICE]
                                        mfindfsays()            // Display new info to screen
                                ENDIF                        
                                // if no faults are found, do not let the user proceed                
                        ELSE
                                IF aCurrentField[ACTION] = NEXTFIELD                        
                                        GetField = 5
                                ELSE        
                                        GetField = 3
                                ENDIF
                                aCurrentField[CHOICE] = aGetValue[3] 
                                aCurrentField[ACTION] = CHANGE                        
                        ENDIF
                
                CASE GetField=5                        
                        DrawStatusBar("")
                        @24,0 say "     " COLOR STAT_COLOR
                        aCurrentField := Button(10,9,"  Print All  ",.t.)
                        
                        IF aCurrentField[ACTION] = CHANGE_NEXT 
                                PrintAll(sRemData,;                    // do report
                                aMakes[aGetValue[1]][1],;
                                aModels[aGetValue[2]],;
                                aFaults)
                                
                                aCurrentField[ACTION] = CHANGE
                                
                        ENDIF
                
                CASE GetField=6
                        DrawStatusBar("")
                        @24,0 say "     " COLOR STAT_COLOR
                        aCurrentField := Button(10,25,"Print Current",.t.)                
                        
                        IF aCurrentField[ACTION] = CHANGE_NEXT 
                                PrintSingle({aMakes[aGetValue[1]][1],;
                                aModels[aGetValue[2]],;
                                aFaults[aGetValue[7]][1],;
                                aFaults[aGetValue[7]][2],;
                                aFaults[aGetValue[7]][3],;
                                aFaults[aGetValue[7]][4],;
                                aFaults[aGetValue[7]][5]})        
                                aCurrentField[ACTION] = CHANGE                         
                        ENDIF

                CASE GetField=7
                        DrawStatusBar("")
                        aCurrentField := SayBox(13,10,aFaults,aGetValue[7],.t.)

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
                        
                        DrawStatusBar("Find Cancelled")
                        EXIT
                
                CASE aCurrentField[ACTION] = SAVEREAD 
                        EXIT
                
                CASE aCurrentField[ACTION] = HELP 
                        HelpOn()

ENDCASE
        
ENDDO

cTopic = OldTopic       // Reset Help topic to original

DrawStatusBar("") 
RestScreen(0,4,23,75,OrigScreen)

RETURN

*---------------------------                       
PROCEDURE mFindFSays
*---------------------------
/* This procedure just updates the screen with the new 
information for the mFileOpen module */

ComboBox(2,10,mList(aMakes,1),aGetValue[1],"Makes",.f.,.f.,10)
ComboBox(2,25,aModels,aGetValue[2],"Models",.f.,.f.,25)
Button(10,9,"  Print All  ",.f.)
Button(10,25,"Print Current",.f.)                
SayBox(13,10,aFaults,aGetValue[7],.f.)
ComboBox(4,55,aTest,aGetValue[4],"Category",.F.,.t.,15)
LogButton(2,55,"Use Categories:",aGetValue[3],.f.,.f.)

RETURN

*-------------------------------------------
FUNCTION mOpenFile(cCurrentFB)
*-------------------------------------------
/* Save the screen */
LOCAL OrigScreen := SaveScreen(8,4,19,75)

/* Get initial directory information */
STATIC NUMFIELDS:=2 
LOCAL GetField:=1                    && Field counter
LOCAL aGetValue:={1,1}               && Stores results of fields
LOCAL aCurrentField[2]               && Gets the return value
LOCAL sFaultBook := cCurrentFB 
LOCAL OldTopic := cTopic
cTopic = "OPENFILE"

/* Common interface variables */
PRIVATE nStartFile:=1
PRIVATE aFiles:=GetValidData(GetFiles())

XdrawBox(8,14,18,65)
CT(8," Open Faultbook ")
CT(18," < ESC Exit > ")
@ 9,20 say "Faultbook:  "

DO mFileOpSays

/* Main loop where reads take place. Uses field counter
to count which field it is up to */

DO WHILE .T.
        
        DO CASE
                CASE GetField=1
                        aCurrentField :=ComboBox(10,30,aFiles,nStartFile,"Faultbooks",.T.,.t.,12)
                        nStartFile := aCurrentField[CHOICE]
                CASE GetField=2        
                        aCurrentField := Button(16,50,"Select Book",.t.)
                        IF aFiles[aGetValue[1]]="None" .and. aCurrentField[ACTION] = SAVEREAD
                                
                                @24,23 SAY "You must select a faultbook to open" COLOR STAT_COLOR 
                                inkey(3)
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
                        
                        DrawStatusBar("Open cancelled")
                        EXIT
                
                CASE aCurrentField[ACTION] = HELP 
                        HelpOn()
                
                CASE aCurrentField[ACTION] = CHANGE_NEXT ; 
                .AND. GetField=2 ;
                .AND. .NOT. aFiles[aGetValue[1]] = "None"
                        EXIT
        ENDCASE
        
        @ 9,32 SAY SPACE(33) COLOR WIN_COLOR
        @ 9,32 SAY cFile2Open := IIF(aFiles[aGetValue[1]]="None","*",aFiles[aGetValue[1]]) COLOR WIN_COLOR

ENDDO


DrawStatusBar("") 

IF .not. aCurrentField[ACTION] = ENDREAD ;
.and. mGenYesNo("Will I open the faultbook",cFile2Open) 
        cOldColor := SETCOLOR(STAT_COLOR)
        DrawStatusBar("Faultbook open")
        sFaultBook = cFile2Open
ELSE
        cOldColor := SETCOLOR(STAT_COLOR)
        DrawStatusBar("Open Cancelled")
ENDIF

SETCOLOR(cOldColor)
RestScreen(8,4,19,75,OrigScreen)
cTopic = OldTopic       // Reset Help topic to original
RETURN (sFaultBook) 

*---------------------------
PROCEDURE mFileOpSays
*---------------------------
/* This procedure just updates the screen with the new 
information for the mFileOpen module */

ComboBox(10,30,aFiles,nStartFile,"Files",.f.,.f.,12)
Button(16,50,"Select File",.f.)
RETURN

*---------------------------------
FUNCTION GetValidData(aListOfFile)
*---------------------------------
// This function is designed to go through a 
// list of files and pick out those which
// have all types of files required

LOCAL nPointer:=1
LOCAL nNumOfItems := LEN(aListOfFile)
LOCAL aValidFiles:={}

DO WHILE nPointer <= nNumOfItems 
        
        IF UPPER(RIGHT( TRIM(aListOfFile[nPointer]),4 )) == ".DBF"  
                
                IF SearchForMatch(aListOfFile,aListOfFile[nPointer])
                        aadd(aValidFiles,GetFileName(aListOfFile[nPointer]))
                ENDIF
        ENDIF  
        nPointer++
ENDDO
RETURN aValidFiles

//----------------------------
FUNCTION GetFileName(cString)
//----------------------------

cString:=TRIM(cString)
cLen := LEN(cString)
cString := LEFT(cString,(cLen-4))

RETURN cString

//-----------------------------------
FUNCTION SearchForMatch(aList,cMatch)
//-----------------------------------
// This function makes sure that all the necessary files
// for a fault database exist. 
//

LOCAL nCount := 1
LOCAL nLen := LEN(aList)
LOCAL lInfoFile := lMainIndex := lUser := lUserIndex:= lMakeFile := .f.
LOCAL DbfName := GetFileName(cMatch)

DO WHILE nLen >= nCount
        IF UPPER(ALLTRIM(aList[nCount])) == DbfName + MAIN_INDEX   
                lMainIndex := .t.
        ENDIF
        IF UPPER(ALLTRIM(aList[nCount])) == DbfName + USER   
                lUser := .t.
        ENDIF
        IF UPPER(ALLTRIM(aList[nCount])) == DbfName + USER_INDEX   
                lUserIndex := .t.
        ENDIF
        IF UPPER(ALLTRIM(aList[nCount])) == DbfName + MAKEFILE   // Index file main
                lMakeFile := .t.
        ENDIF
        IF UPPER(ALLTRIM(aList[nCount])) == DbfName + INIFILE   // Info file 
                lInfoFile := .t.
        ENDIF
        
        IF lMainIndex .and. lUser .and. lUserIndex .and. lMakeFile .and. lInfoFile
                RETURN .t.
        ENDIF
        nCount++
ENDDO

RETURN .f.


*-------------------------------------------
PROCEDURE mNewFault(sRemData)
*-------------------------------------------
/* Save the screen */

LOCAL NUMFIELDS:=5 
LOCAL OrigScreen := SaveScreen(1,4,23,75)

/* Get initial fault information */
LOCAL GetField:=1                     // Field counter
LOCAL aCurrentField[2]                // Gets the return value
LOCAL cInifile :=  sRemData + INIFILE // Get ini file name
LOCAL OldTopic := cTopic
cTopic = "NEWFAULT"

RESTORE FROM (cinifile) ADDITIVE      // Get Categories

/* Common interface variables */
PRIVATE aGetValue:={1,1,1,1,1}        && Stores results of fields
PRIVATE aMakes := GetAllMake(sRemData)
PRIVATE aModels := GetModel(aMakes[aGetValue[1]][2],sRemData)
PRIVATE aFaults := {}
PRIVATE aTest := {vCat1,vCat2,vCat3,vCat4,vCat5,vCat6,vCat7,vCat8,vCat9,vCat0}

AADD(aFaults,{SPACE(60),SPACE(60),SPACE(60),SPACE(60),SPACE(60)})

XdrawBox(1,5,22,75)
CT(1," New Fault " + sRemData + " ") // display the window heading
CT(22,"< ESC Exit >")

mNewfsays()

/* Main loop where reads take place. Uses field counter
to count which field it is up to */

DO WHILE .T.
        DO CASE
                CASE GetField=1
                        DrawStatusBar("Found "+ltrim(str(len(aMakes)))) 
                        aGetValue[2] = 1  // Reset the model number 
                        aCurrentField := ComboBox(2,10,mList(aMakes,1),aGetValue[1],"Makes",.t.,.t.,10)
                        aGetValue[GetField] =  aCurrentField[CHOICE]
                        IF .NOT. aCurrentField[ACTION]=ENDREAD
                                aModels := GetModel(aMakes[aGetValue[1]][2],sRemData)
                                mNewfsays()            && Display new info to screen                 
                        ENDIF                
                        
                CASE GetField=2
                        DrawStatusBar( space(20)+"Found "+ltrim(str(len(aModels)))+;
                        "         < F2 Add >")
                        aCurrentField :=ComboBox(2,25,aModels,aGetValue[2],"Models",.t.,.t.,25)
                        aGetValue[GetField] =  aCurrentField[CHOICE]
                        IF .NOT. aCurrentField[ACTION]=ENDREAD
                                mNewfsays()            // Display new info to screen
                        ENDIF
                        
                        IF TRIM(aModels[aGetValue[GetField]]) == "None" .AND. ;
                        (aCurrentField[ACTION]==NEXTFIELD .OR.; 
                         aCurrentField[ACTION]==CHANGE_NEXT )
                                aCurrentField[ACTION] = ADD_NEW
                        ENDIF                        
                        
                        IF aCurrentField[ACTION] = ADD_NEW 
                                NewValue := mGetDialog("New Model",15)                                
                                IF NewValue != SPACE(15)
                                        IF TRIM(aModels[1])="None"
                                                aModels[1]=NewValue
                                        ELSE
                                                AADD(aModels,NewValue)
                                        ENDIF                                        
                                        ASORT(aModels)
                                ENDIF
                        ENDIF
                        
                        field1 := space(60)
                        field2 := space(60)
                        field3 := space(60)
                        field4 := space(60)
                        field5 := space(60)
                        
                CASE GetField=3                        
                
                        aCurrentField := ComboBox(2,55,aTest,aGetValue[3],"Category",.t.,.t.,15)
                        IF aCurrentField[ACTION] != ENDREAD .AND. aCurrentField[ACTION] != HELP
                                aGetValue[GetField] =  aCurrentField[CHOICE]
                                mNewfsays()            // Display new info to screen
                        ENDIF                        
                        
                CASE GetField=4
                        @11,11 GET field1 PICTURE "@!"               
                        @12,11 GET field2 PICTURE "@!"                              
                        @15,11 GET field3 PICTURE "@!"                              
                        @16,11 GET field4 PICTURE "@!"                              
                        @17,11 GET field5 PICTURE "@!"                              
                        SET CURSOR ON
                        READ
                        SET CURSOR OFF
                        IF LASTKEY() != K_ESC
                                aCurrentField[ACTION] = NEXTFIELD
                        ELSE                
                                aCurrentField[ACTION] = PREVFIELD
                        ENDIF
                
                CASE GetField=5                        
                        aCurrentField := Button(20,35,"Save Fault",.t.)                
                        
                        IF aCurrentField[ACTION] = CHANGE_NEXT 
                                IF mGenYesNo("Will I save this fault","for ";
                                        +TRIM(aMakes[aGetValue[1]][1]);
                                        +" ";
                                        +TRIM(aModels[aGetValue[2]])) 
                                        aNewRecord := {aMakes[aGetValue[1]][2],;
                                        aModels[aGetValue[2]],aGetValue[3],;
                                        field1,field2,field3,field4,field5}
                                        
                                        AddNewFault(sRemData,aNewRecord)
                                        
                                        aCurrentField[ACTION] = SAVEREAD     
                                ELSE
                                        aCurrentField[ACTION] = ENDREAD
                                ENDIF
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
                        DrawStatusBar("Add Cancelled")
                        EXIT
                
                CASE aCurrentField[ACTION] = SAVEREAD 
                        DrawStatusBar("Fault Saved")
                        EXIT
                
                CASE aCurrentField[ACTION] = HELP 
                        HelpOn(cTopic)

ENDCASE
       
ENDDO

RestScreen(1,4,23,75,OrigScreen)
cTopic = OldTopic       // Reset Help topic to original

RETURN

*---------------------------
PROCEDURE mNewFSays
*---------------------------
/* This procedure just updates the screen with the new 
information for the mNewFault module */

ComboBox(2,10,mList(aMakes,1),aGetValue[1],"Makes",.f.,.f.,10)
ComboBox(2,25,aModels,aGetValue[2],"Models",.f.,.f.,25)
Button(20,35,"Save Fault",.f.)                
SayBox(10,10,aFaults,1,.f.)
ComboBox(2,55,aTest,aGetValue[3],"Category",.f.,.f.,15)

RETURN

*------------------------------------
PROCEDURE mGimmiabreak()
// Just a test stub to fill in spaces
*------------------------------------
LOCAL OrigScreen := SaveScreen(10,19,17,60)
LOCAL nCount := 0
LOCAL OldTopic := cTopic

XDrawBox(10,20,16,59)
CT(10," Give me a break !! ")
CT(11,"I haven't finished this yet")
CT(12,"so I cant show you anything")
CT(13,"A.D.")
RetValue := Button(15,35,"Continue",.t.)
RestScreen(10,19,17,60,OrigScreen)
DrawStatusBar("") 

RETURN

*---------------------------
FUNCTION RetrieveCode(Encoded, Distn)
// This function retrieves the number encoded by the  
// Fault Entry Code. 
*---------------------------

LOCAL count := 0
LOCAL count2 := 1
LOCAL Restored := ""
LOCAL TotalChar:=0
LOCAL DistnChar:=0

DO WHILE count++ < LEN(Encoded)
TotalChar = (ASC(SUBSTR(Encoded,count)) - 32) * 2   // Combined char
DistnChar = ASC(SUBSTR(Distn,count2++)) - 32

IF ASC(SUBSTR(Encoded,count+1)) == 45
        TotalChar++
        count++
ENDIF

Restored := Restored + CHR((TotalChar - DistnChar) + 32)

ENDDO

RETURN Restored
