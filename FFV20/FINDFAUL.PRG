#include "CONTROL.H"
#include "DATAEXT.H"

*------------------------------
FUNCTION mCode(aMakes,aMakeRet)
*------------------------------
// Return the code for a model
return aMakes[(aMakeRet[CHOICE])][2]

*------------------------------
FUNCTION mList(aMakes,nArrayMember)
*------------------------------
// Gets the list for the control functions
// from a table array
LOCAL aMakeMenu:= {}
LOCAL nCount:=1

DO WHILE nCount <= LEN(aMakes)
	aadd(aMakeMenu,aMakes[nCount++][nArrayMember])
ENDDO
RETURN aMakeMenu

*------------------
FUNCTION GetMake(sFaultBook)
*------------------
// This function searches the MAKE database and
// gets the makes into an array. This array is then
// passed back. 
// AD. Function revamped

LOCAL MakeArray[0][2]
LOCAL nLastArea:=SELECT()       // Save the current work area
LOCAL NoOfRec
LOCAL MainHandle[2], MakeHandle

DBUSEAREA( .T., "DBFNTX", sFaultBook + MAKEFILE, MakeHandle := UniNum() , .T. )

DBUSEAREA( .T., "DBFNTX", sFaultBook + MAIN , MainHandle[1] := UniNum(), .T. )
DBSETINDEX( sFaultBook + MAIN_INDEX )

DBUSEAREA( .T., "DBFNTX", sFaultBook + USER , MainHandle[2] := UniNum(), .T. )
DBSETINDEX( sFaultBook + USER_INDEX )

noofDB := 0

DO WHILE noofDB++ < 2

DBSELECTAREA( MakeHandle )          // select work area
DBGOTOP()

DO WHILE .NOT. EOF()
    
    /* Gets the field from MAKE database, MAKE and adds
    it to the array MakeArray */
    
    DBSELECTAREA( MainHandle[noofDB] )
    SEEK (MakeHandle)->code
    IF FOUND() .AND. ASCAN(MakeArray, {|aVal| aVal[2] == (MakeHandle)->code}) == 0        
    DBSELECTAREA( MakeHandle )     
	AADD(MakeArray,{MAKE,CODE})  
    ENDIF

    DBSELECTAREA( MakeHandle )     
    DBSKIP()

ENDDO

ENDDO

DBSELECTAREA( MakeHandle )     
DBCLOSEAREA()           // When finished, close databases 
DBSELECTAREA( MainHandle[1] )
DBCLOSEAREA()     
DBSELECTAREA( MainHandle[2] )
DBCLOSEAREA()     

DBSELECTAR(nLastArea)   // Restore previous work area

RETURN ASORT(MakeArray,,,{ |x , y| x[1] < y[1] })


*------------------------------------
FUNCTION GetModel(Code2Find,sDbfFile)
*------------------------------------
/* This function searches the Default database for occurances of Code2Find
 from field and returns an array of the found models */
LOCAL MakeArray[0] 
LOCAL nLastArea:=SELECT()
LOCAL SearchStat := StatusNew(24,2)
LOCAL MainHandle , UserHandle
LOCAL dbcount := 0

DBUSEAREA( .T., "DBFNTX", sDbfFile + MAIN , MainHandle := UniNum(), .T. )
DBSELECTAREA( MainHandle )        // select the database
DBSETINDEX( sDbfFile + MAIN_INDEX )          // set index

DBUSEAREA( .T., "DBFNTX", sDbfFile + USER , UserHandle := UniNum(), .T. )
DBSELECTAREA( UserHandle )              // select the database
DBSETINDEX( sDbfFile + USER_INDEX )     // set index

SaveColor := setcolor(STAT_COLOR)
DrawStatusBar("Searching...")    
SetColor(SaveColor)

// First, use the main database and look for makes
// then look for user faults

DO WHILE dbCount++ < 2

DO CASE
	CASE dbCount = 1
		DBSELECTAREA( MainHandle )        // select main database
	CASE dbCount = 2
		DBSELECTAREA( UserHandle )        // select user database
ENDCASE

SEEK Code2Find

IF FOUND()
	
	IF (ASCAN(MakeArray,MODEL) == 0)
		AADD(MakeArray,MODEL)  
	ENDIF
	
	LastModel := MODEL
	DBSKIP()

	//LimitCounter = 2    // Limits number of models to value specified
			      // Used for demos
	nRecCounter:=0

	DO WHILE .NOT. EOF() .AND. Code2Find = Mac_Code 
	&& .and. LimitCounter-- <> 0
		IF .NOT. LastModel = MODEL 
			IF (ASCAN(MakeArray,MODEL) == 0)
				AADD(MakeArray,MODEL)  
			ENDIF
			LastModel := MODEL
			statusUpdate(SearchStat)
		ENDIF
		DBSKIP()
	ENDDO
ENDIF

ENDDO

DrawStatusBar("")

DBSELECTAREA( MainHandle )              // select the database
DBCLOSEAREA()                           // Close database
DBSELECTAREA( UserHandle )              // select the database
DBCLOSEAREA()                           // Close database
DBSELECTAR(nLastArea)           // Restore previous work area

/* When finished, close make database and pass back code found */

RETURN ASORT(MakeArray)

*-----------------------------------------------
FUNCTION GetFault(Cat2Find,Model2Find,Code2Find,UseCat,sDbfFile)
*-----------------------------------------------
/* This function searches the Default database for occurances of Code2Find
 from field and returns an array of the found models */

LOCAL MakeArray[0][6] 
LOCAL nLastArea:=SELECT()
LOCAL SearchStat := StatusNew(24,2)
LOCAL MainHandle , UserHandle
LOCAL dbcount := 0

DBUSEAREA( .T., "DBFNTX", sDbfFile + MAIN , MainHandle := UniNum(), .T. )
DBSELECTAREA( MainHandle )        // select the database
DBSETINDEX( sDbfFile + MAIN_INDEX )          // set index

DBUSEAREA( .T., "DBFNTX", sDbfFile + USER , UserHandle := UniNum(), .T. )
DBSELECTAREA( UserHandle )              // select the database
DBSETINDEX( sDbfFile + USER_INDEX )     // set index

SaveColor := SETCOLOR(STAT_COLOR)

DrawStatusBar("Searching...")

SETCOLOR(SaveColor)

DO WHILE dbCount++ < 2

DO CASE
	CASE dbCount = 1
		DBSELECTAREA( MainHandle )        // select main database
	CASE dbCount = 2
		DBSELECTAREA( UserHandle )        // select user database
ENDCASE
IF Cat2Find = "10"
	Cat2Find = "0"
ENDIF

IF UseCat
	SEEK Code2Find+Model2Find+Cat2Find 
ELSE
	SEEK Code2Find+Model2Find
ENDIF

IF FOUND()
	AADD(MakeArray,{FAULT1,FAULT2,REMEDY1,REMEDY2,REMEDY3,RecNo()})  
	DBSKIP()
	nCounter:=1
	IF UseCat
		DO WHILE .not. EOF() .and. Code2Find+Model2find+Cat2Find == MAC_CODE+MODEL+STR(CATEGORY,1)
			AADD(MakeArray,{FAULT1,FAULT2,REMEDY1,REMEDY2,REMEDY3,RecNo()})  
			statusUpdate(SearchStat)
			DBSKIP()
		ENDDO
	ELSE
		DO WHILE .not. EOF() .and. Code2Find+Model2find == MAC_CODE+MODEL
			AADD(MakeArray,{FAULT1,FAULT2,REMEDY1,REMEDY2,REMEDY3,RecNo()})  
			statusUpdate(SearchStat)
			DBSKIP()
		ENDDO
	
	ENDIF
ENDIF
ENDDO

DrawStatusBar("")

DBSELECTAREA( MainHandle )              // select the database
DBCLOSEAREA()                           // Close database
DBSELECTAREA( UserHandle )              // select the database
DBCLOSEAREA()                           // Close database

RETURN MakeArray

*-------------------------------------------
FUNCTION SayBox(y,x,aList,nStart,lDisp)
*-------------------------------------------
/* Places a box on the screen, with multiple 
lines as specified and returns an action and choice.   */

LOCAL nWidth:=60
LOCAL nCurrent:=nStart
LOCAL aReturn[2]
LOCAL KeyPress:=0

// aList is the array with fault and remedy

@ y,x-1 clear to y+3,x+nWidth+1    // clear area
@ y,x-1 to y+3,x+nWidth+1 COLOR CONTROL_COLOR    // Draw box

@ y+4,x-1 clear to y+8,x+nWidth+1    // clear area
@ y+4,x-1 to y+8,x+nWidth+1 COLOR CONTROL_COLOR      // Draw box

// Display title
// Highlight if current

LenArray := LEN(aList)

IF lDisp
	@ y,x SAY "Fault" COLOR TITLE_ON
	@ y+4,x SAY "Remedy" COLOR TITLE_ON
ELSE
	@ y,x SAY "Fault" COLOR TITLE_OFF
	@ y+4,x SAY "Remedy" COLOR TITLE_OFF
ENDIF

DrawStatusBar("Found "+ltrim(str(LenArray)))

DO WHILE .T.
	StatBar(nCurrent,LenArray)        
	
	OldColor := SETCOLOR(CONTROL_COLOR)
	@ y+1,x clear to y+2,x+nWidth    // Display on screen
	SetColor(OldColor)
	
	@ y+1,x SAY aList[nCurrent][1] COLOR CONTROL_COLOR
	@ y+2,x SAY aList[nCurrent][2] COLOR CONTROL_COLOR
	
	OldColor := SETCOLOR(CONTROL_COLOR)
	@ y+5,x clear to y+7,x+nWidth        // Display on screen
	SetColor(OldColor)
	
	@ y+5,x SAY aList[nCurrent][3] COLOR CONTROL_COLOR
	@ y+6,x SAY aList[nCurrent][4] COLOR CONTROL_COLOR
	@ y+7,x SAY aList[nCurrent][5] COLOR CONTROL_COLOR
	
	IF lDisp
		KeyPress = Inkey(0)     // Get keypress if current
	ENDIF
	
	DO CASE
		CASE KeyPress = 271     && Shift tab 
			aReturn[ACTION] = PREVFIELD
			EXIT
		
		CASE KeyPress = 9       &&  tab 
			aReturn[ACTION] = NEXTFIELD
			EXIT
		
		CASE KeyPress = 13      && enter
			aReturn[ACTION] = CHANGE_NEXT
			lDisp=.f.
			KeyPress=0
			LOOP                
		
		CASE KeyPress = 28     && F1 Pressed
			HelpOn()                        

		CASE KeyPress = 27     && Escape pressed
			aReturn[ACTION] = ENDREAD
			EXIT
		
		CASE KeyPress = 5       && Up arrow
			IF nCurrent != 1
				nCurrent--
			ENDIF
		
		CASE KeyPress = 24      && Down arrow
			IF nCurrent != LenArray
				nCurrent++
			ENDIF
			
		CASE .not. lDisp
			EXIT

	ENDCASE
ENDDO

aReturn[CHOICE] = nCurrent                        

IF lDisp 
	@ y,x SAY "Fault" COLOR TITLE_OFF
	@ y+4,x SAY "Remedy" COLOR TITLE_OFF
ENDIF

DrawStatusBar("")  // General clear
@24,0 SAY SPACE(20) COLOR STAT_COLOR // Clear Status bar

RETURN (aReturn)


*----------------------------------------------
FUNCTION UniNum()
// Returns a unique name to identify area alais 
*----------------------------------------------
STATIC number := 1

IF number = 2000
	number = 1
ENDIF

RETURN "A"+ALLTRIM(STR(number++))

*---------------------------------------------
PROCEDURE AddNewFault(cDatabase,aFault2Add)
// Add new fault to database
*---------------------------------------------

DBUSEAREA( .T., "DBFNTX", cDatabase + USER , UserHandle := UniNum(), .T. )
DBSELECTAREA( UserHandle )              // select the database
DBSETINDEX( cDatabase + USER_INDEX )     // set index

IF LASTREC() < UserFaults 
	DBAPPEND()

	(UserHandle)->MAC_CODE  := aFault2Add[1]
	(UserHandle)->MODEL     := aFault2Add[2]
	(UserHandle)->CATEGORY  := aFault2Add[3]
	(UserHandle)->FAULT1    := aFault2Add[4]
	(UserHandle)->FAULT2    := aFault2Add[5]
	(UserHandle)->REMEDY1   := aFault2Add[6]
	(UserHandle)->REMEDY2   := aFault2Add[7]
	(UserHandle)->REMEDY3   := aFault2Add[8]
	DBSELECTAREA( UserHandle )              // select the database
	DBCLOSEAREA()                           // Close database

ELSE
	DBSELECTAREA( UserHandle )              // select the database
	DBCLOSEAREA()                           // Close database
	mMsgBox("You have exceeded the number of","faults that you may enter")
	mSave2Disk(cDatabase)
ENDIF

RETURN


*------------------
FUNCTION GetAllMake(sFaultBook)
*------------------
// This function searches the MAKE database and
// gets the makes into an array. This array is then
// passed back. 
// AD. Function revamped

LOCAL MakeArray[0][2]
LOCAL nLastArea:=SELECT()       // Save the current work area
LOCAL NoOfRec
LOCAL MainHandle, MakeHandle

DBUSEAREA( .T., "DBFNTX", sFaultBook + MAKEFILE, MakeHandle := UniNum() , .T. )
DBSELECTAREA( MakeHandle )          // select work area

DO WHILE .NOT. EOF()
    AADD(MakeArray,{MAKE,CODE})  
    DBSKIP()
ENDDO

DBSELECTAREA( MakeHandle )     
DBCLOSEAREA()           // When finished, close databases 

DBSELECTAR(nLastArea)   // Restore previous work area

RETURN ASORT(MakeArray,,,{ |x , y| x[1] < y[1] })


