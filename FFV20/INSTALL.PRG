#include "control.h"
*----------------------------------------------------
* Master Install Program
* A.J.D. Business Software 
* (C)Copyright 1994
*----------------------------------------------------
*----------------------------------------------------
* MAIN MENU 
*----------------------------------------------------
LOCAL cScreen := SaveScreen(0,0,24,79)
LOCAL cColor  := SetColor()
SET WRAP ON
SET SCOREBOARD OFF
SET STATUS OFF
SET CURSOR OFF

BaseScreen()            /* Paints the background */

mAbout()

DrvInfo := GetDriveInfo()       // Get directory information

IF mSuccess := CheckSpace(Left(TRIM(DrvInfo[2]),1))   // Check space on destination
        IF mSuccess := SetAndMakeDir(DrvInfo[2]) // Create the directory
                IF mSuccess := mPutReg("0001") // Get registration information        
                        IF mSuccess := copyprog(DrvInfo[2],DrvInfo[1]) // Copy the program        
                                MakeBatch(DrvInfo[2]) // Make the batch file
                        ENDIF
                ENDIF
        ENDIF
ENDIF

xdrawbox(12,20,18,60) 
if mSuccess 
    CT(13,"Successfull completition")
    CT(14,"Type FFINDER to run")
else
    CT(13,"Install not completed")
endif

Button(16,34,"Exit to DOS",.t.)

RestScreen(0,0,24,79,cScreen)
setcolor(cColor)
@24,0
*-------------------------------------------
PROCEDURE mAbout
*-------------------------------------------
LOCAL OrigScreen := SaveScreen(10,19,20,60)
SETCOLOR(WIN_COLOR)

XDrawBox(10,20,18,59)
CT(10," About ")
CT(11,"VCR and TV Fault Finder")
CT(12,"Installation Program")
CT(13,"Version 2.0 For DOS")
CT(15,"(C) A.J.D. Business Software 1994")
Button(17,35,"Continue",.t.)
RestScreen(10,19,20,60,OrigScreen)
RETURN

*----------------------
FUNCTION GetDriveInfo()
*----------------------
// Gets the drive information from the user

InstDir = "C:\VIDEO                   " 
drive := "A:"
FirstScreen := savescreen(0,0,24,79)
drawbox(14,25,20,55)           
CT(14,"Install Details")           
CT(15,"Directory to install to :")           
@ 16,27 get InstDir
CT(18,"Installing from drive")
@ 19,27 get drive

SET CURSOR ON
READ                    
SET CURSOR OFF
restscreen(0,0,24,79,Firstscreen)

RETURN({drive,InstDir})

*--------------------------------
FUNCTION CheckSpace(Drive2Check)            
*--------------------------------
IF DiskFree(Drive2Check) < 3500000
        ThisScreen := SAVESCREEN(4,8,12,72)
        DrawBox(4,10,11,70)
        CT(5,"Insufficient Disk space on drive " + Drive2Check + ":")
        CT(7,"This Program requires 3.5M of disk space")
        CT(8,"Clear some space and try to install again")
        Button(10,34,"Exit to DOS",.t.)        
        RESTSCREEN(4,8,12,72,ThisScreen)
        RETURN .f.
ENDIF
RETURN .t.

*----------------------------------
FUNCTION copyprog(dest,source)
*----------------------------------
LOCAL counter1 := 1
LOCAL CurrFile := {"FFV20.EXE"}
LOCAL cSaveScr := SAVESCREEN(0,0,24,79)

xdrawbox(11,20,15,60)
CT(12,"Installation in progress")
CT(13,"Please Wait")

do while counter1 <= len(CurrFile)
        CT(14,"     Copying - "+ CurrFile[counter1]+"    ")
        IF FILE(source + CurrFile[counter1])
                cCommand := "copy "+ source + CurrFile[counter1] + " >null"
                RUN (cCommand)         
                CT(14,"Decompressing - " + CurrFile[counter1])
                cCommand := CurrFile[counter1] + " -o >null"
                RUN (cCommand)         
                cCommand := "del "+ CurrFile[counter1] + " >null"
                RUN (cCommand)         
        ELSE
                RETURN .F.
        ENDIF
        counter1++
enddo

cCommand := "del null. "
run (cCommand) 
run cd\
RESTSCREEN(0,0,24,79,cSaveScr)

RETURN .T.
*--------------------------------
Procedure MakeBatch(FullFileSpec)
// This procedure creates a simple batch program which invokes the 
// installed program 
*--------------------------------
#include "Fileio.ch"

drive := left(FullFileSpec,2)
FileDirect := SubStr(FullFileSpec,3,(len(FullFileSpec)-2))

IF (nHandle := FCREATE(drive + "\ffinder.bat",FC_NORMAL) ) ==-1 
  ? "File cannot be created:" ,FERROR ()
    BREAK
ELSE
    Fputs(nHandle, "@ECHO OFF"+ FileDirect )
    Fputs(nHandle, "CD "+ FileDirect )
    Fputs(nHandle, "START" )
    Fputs(nHandle, "FFINDER" )
    Fputs(nHandle, "CD\" )
    FCLOSE(nHandle)
ENDIF

