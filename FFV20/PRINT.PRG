#include "control.h"

*----------------------------------
PROCEDURE PrintSingle(aFaultStruct)
*----------------------------------
// Main print engine

STATIC pgno :=1
STATIC print_pos :=1 
LOCAL line
LOCAL LastScreen := savescreen(0,0,24,79)

IF mGenYesNo("Will I print this fault","")

IF .NOT. gPageInPrint .AND. print_pos != 1
	print_pos = 1
ENDIF

DO WHILE .t.
    
     IF PRINTREADY(1)
	  
	  SET CONSOLE OFF
	  SET DEVICE TO PRINTER

	  line = (5 + ((print_pos-1)*10))
	    
	  IF print_pos = 1
	       
	       @ 0,0 SAY "---------------------------------------------------------------------------"
	       @ 1,0 SAY "   Single Fault Report                                            Page " + str(pgno,2)
	       @ 2,0 SAY "   A.J.D. Business Software                             (C)Copyright 1994  "       
	       @ 3,0 SAY "---------------------------------------------------------------------------"
	       @ 4,0 SAY ""
	  
	  ENDIF

	  @ line,0 say " Make : "+aFaultStruct[1]
	  @ line+1,0 say " Model: "+aFaultStruct[2]
	  @ line+3,0 say " Fault Description  :" + aFaultStruct[3]
	  @ line+4,0 SAY " " + aFaultStruct[4]
	  @ line+5,1 say "Possible remedy :"
	  @ line+6,1 say aFaultStruct[5]
	  @ line+7,1 say aFaultStruct[6]
	  @ line+8,1 say aFaultStruct[7]

	  print_pos++
	  
	  gPageInPrint = .T.    // Tell the system that a form is
				// in the printer
	  IF print_pos=6
	       print_pos=1
	       pgno++
	       EJECT
	       gPageInPrint = .f.  // Page ejected, so no form in printer
	  ENDIF
	  EXIT
     
     ELSE
	  
	  SET DEVICE TO SCREEN
	  SET CONSOLE ON
	  
	  IF pError(PrintErr())         // display print error
	       EXIT
	  ENDIF
	  
	  SET CONSOLE OFF
	  SET DEVICE TO PRINTER
	  
     ENDIF

ENDDO    

SET DEVICE TO SCREEN
SET CONSOLE ON

ENDIF

RESTSCREEN(0,0,24,79,LastScreen)

RETURN

*-------------------------------------------
FUNCTION pError(Msg)
*-------------------------------------------
LOCAL OrigScreen := SaveScreen(10,14,17,64)
LOCAL lAction:=.f.
LOCAL nChoice:=1

XDrawBox(10,15,16,64)
CT(10," Printer Error ")
CT(11,"A printer error has occured")
CT(12,Msg)

@ 14,28 prompt "<Retry>"
@ 14,45 prompt "<Cancel>"
menu to nChoice

RestScreen(10,14,17,64,OrigScreen)

IF nChoice = 1
	RETURN .f.
ELSE
	RETURN .t.
ENDIF

*-----------------------------
PROCEDURE PrintMess()
*-----------------------------
/* This function displays a indicator bar on the bottom
of the screen */

XDrawBox(10,15,16,64)
CT(10," Printing ")
CT(11,"Press any key to cancel")

RETURN

*-------------------------------
FUNCTION PrintBar(nUpTo,nTotal)
*-------------------------------
LOCAL BarLength:=10
SET TALK OFF

@ 13,35 say space(BarLength+1) COLOR WIN_COLOR
@ 13,35 say "["+replicate(chr(254),int(((nUpTo-1)/(nTotal-1))*BarLength)) COLOR WIN_COLOR
@ 13,(35 +BarLength+1) say "] "+ltrim(str(int(((nUpTo-1)/(nTotal-1))*100)))+"%"+"  " COLOR WIN_COLOR

RETURN INKEY()

*----------------------------------
PROCEDURE PrintAll(sDBF,sMake,sModel,aList)
*----------------------------------
// Main print engine

LOCAL print_pos :=1 
LOCAL pgno :=1
LOCAL line
LOCAL LastScreen := savescreen(0,0,24,79)
LOCAL counter := 1
LOCAL StopPrint := 0

SET TALK OFF

IF mGenYesNo("Will I print the remedies","for "+TRIM(sMake)+" "+TRIM(sModel))

IF gPageInPrint             // Page still in printer
	EJECT
	gPageInPrint = .f.  // Page ejected, so no form in printer      
ENDIF

PrintMess()                            // display print message
PrintBar(1,LEN(aList))

DO WHILE .t.
     IF PRINTREADY(1)
	  SET CONSOLE OFF
	  SET DEVICE TO PRINTER
	  line = (8 + ((print_pos-1)*7))
	    
	  IF print_pos = 1
	       @ 0,0 SAY "---------------------------------------------------------------------------"
	       @ 1,0 SAY "   Multiple Fault Report for "+sDBF+"                           Page " + str(pgno,2)
	       @ 2,0 SAY "   A.J.D. Business Software                             (C)Copyright 1994  "       
	       @ 3,0 SAY "---------------------------------------------------------------------------"
	       @ 4,0 SAY ""
	       @ 5,0 say " Make : "+sMake
	       @ 6,0 say " Model: "+sModel

	  ENDIF

	  @ line+0,0 say " Fault Description  :" + aList[counter][1]
	  @ line+1,0 SAY " " + aList[counter][2]
	  @ line+2,1 say "Possible remedy :"
	  @ line+3,1 say aList[counter][3]
	  @ line+4,1 say aList[counter][4]
	  @ line+5,1 say aList[counter][5]

	  print_pos++
	  gPageInPrint = .T.    // Tell the system that a form is

	  IF print_pos=8
	       print_pos=1
	       pgno++
	       EJECT
	       gPageInPrint = .f.  // Page ejected, so no form in printer      
	  ENDIF
	  
	  SET DEVICE TO SCREEN
	  SET CONSOLE ON
	  IF counter++ < LEN(aList)  
		StopPrint = PrintBar(counter,LEN(aList))
		IF StopPrint = 0
			LOOP
		ELSE
			EXIT
		ENDIF
	  ELSE
		EXIT
	  ENDIF
     
	  SET CONSOLE OFF
	  SET DEVICE TO PRINTER
     
     ELSE
	  SET DEVICE TO SCREEN
	  SET CONSOLE ON
	  IF pError(PrintErr())         // display print error
	       EXIT
	  ENDIF
	  
	  SET CONSOLE OFF
	  SET DEVICE TO PRINTER
     
     ENDIF

ENDDO    

SET DEVICE TO SCREEN
SET CONSOLE ON

IF PRINTREADY(1)
	EJECT
	gPageInPrint = .f.  // Page ejected, so no form in printer      
ENDIF

ENDIF

RESTSCREEN(0,0,24,79,LastScreen)

RETURN


*------------------
FUNCTION PrintErr()
*------------------
// Returns true if no paper is available

nStatus := PRINTSTAT(1)
IF ISBIT(nStatus,6) 
	RETURN "Paper Out"
ENDIF
RETURN "Printer not ready"
				
				

