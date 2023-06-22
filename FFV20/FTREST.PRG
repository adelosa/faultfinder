#include "control.H"
#include "dataext.h"
*------------------------------------------------------------*
PROCEDURE mSave2Disk(sFaultBook)
// This procedure saves the custom database to a disk drive. This 
// should then be sent to us to be compiled. */
*------------------------------------------------------------*
LOCAL Adrive := Floppytype("A")
LOCAL Bdrive := Floppytype("B")

LOCAL DriveSelected := "A:"
LOCAL cDrive2Use := 1

SETCOLOR(WIN_COLOR)

DBUSEAREA( .T., "DBFNTX", sFaultBook + USER , MainHandle := UniNum(), .T. )
DBSELECTAREA(MainHandle)

newvar:= savescreen(0,0,24,79)
xdrawbox(6,8,21,72)

CT(7,"Please insert a disk into a drive as seen below and send")
CT(8,"it to your distributor. You will then have a fault update")
CT(9,"disk sent to you which will allow you to enter more faults")

CT(11," THE FOLLOWING ACTION WILL ERASE ALL INFORMATION ON THE ")
CT(12,"TARGET DISK IF YOU CHOOSE TO FORMAT.")
CT(14,"The faultbook to be saved is "+sFaultBook)
CT(16,"Select Drive")

DO WHILE .T.

  cDrive2Use := RadioButton(17,35,{"A:","B:"},1,"Drives",.t.,.f.)

  IF cDrive2Use[ACTION] != ENDREAD
  
        IF cDrive2Use[CHOICE] = 1 .and. Adrive <> 0
                DriveSelected := "A"
                EXIT
        ENDIF

        IF cDrive2Use[CHOICE] = 2 .and. Bdrive <> 0
                DriveSelected := "B"
                EXIT
        ENDIF

  ELSE
        DriveSelected := "0"
        EXIT
  ENDIF

ENDDO

RESTSCREEN(0,0,24,79,newvar)

newvar2 := SAVESCREEN(0,0,24,79)

nErrCode := 0

IF DriveSelected <> "0" .and. ; 
mGenYesNo("Will I Format the disk?","THIS WILL DELETE ALL INFORMATION ON THE DISK") .AND. ; 
  diskaok(DriveSelected)
  
  newvar2 := SAVESCREEN(0,0,24,79)          
  
  DO CASE   
     CASE FloppyType(DriveSelected) = 1
       nSize:=360  
     CASE FloppyType(DriveSelected) = 2
       nSize:=1200
     CASE FloppyType(DriveSelected) = 3
       nSize:=720
     CASE FloppyType(DriveSelected) = 4
       nSize:=1440
  ENDCASE
  cBootText  := "User faults - Contains "+ sFaultBook
  
  drawbox(9,20,13,60) 
  CT(9,"Formatting")
  CT(12,"Press <ESC> to abort format")
  CT(10,"Track:    ")
  CT(11,"Head:    ")
  
  nErrCode := DISKFORMAT(DriveSelected,nSize,"CONTROLP",cBootText,1)
  
  RESTSCREEN(0,0,24,79,newvar2)

ENDIF

IF DriveSelected <> "0" .AND. diskaok(DriveSelected)  
  
  newvar3 := SAVESCREEN(0,0,24,79)

  IF nErrCode = 0  // everything OK
    cFile := DriveSelected + ":\" + sFaultbook + USER
    copy to (cFile)
    drawbox(5,10,8,70) 
    @ 6,27 say "The operation was sucessfull"
    @ 7,28 say  "Press any key to continue"
  ELSE
    drawbox(5,10,8,70) 
    @ 6,28 say "The operation was aborted"
    @ 7,28 say "Press any key to continue"
  ENDIF

  WAIT""
  RESTSCREEN(0,0,24,79,newvar3)
  
ENDIF

/*--------------------------------------------------------*/

FUNCTION CONTROLP(nTrack,nHead)

LOCAL nRetval
IF INKEY() =27
  nRetval := 2            // Abort
ELSE 
  nRetval := 0            // Continue format
   @ 10,40 SAY STR(nTrack)
   @ 11,40 SAY STR(nHead)
ENDIF

IF nTrack =-1
  drawbox(19,8,21,47)
  @ 20,10 SAY "Initializing FAT and Root Directory!"
ENDIF

RETURN(nRetval)
/*--------------------------------------------------------*/

FUNCTION DiskAOK(disk2check)

/* Checks to see if drive a is ready and not write protected */

lFinished := .f.

DO While .not. lFinished

newvar := SaveScreen(11,10,16,70)

IF DISKREADY(disk2check,.f.)
       IF DISKREADYW(disk2check,.f.)
          lFinished = .t.
       ELSE 
          DrawBox(12,15,15,65)
          @ 13,20 say "Disk is write protected in Drive " + disk2check
          @ 14,20 say "Press Q to quit or any other key to retry"       

          KeyPress := INKEY(0)

          IF Keypress = ASC("Q") .or. Keypress = ASC("q")
                RESTSCREEN(11,10,16,70,newvar)
                return .f.
          ENDIF
         
       ENDIF
ELSE 
       DrawBox(12,15,15,65)
       @ 13,20 say "Drive not ready in Drive " + disk2check
       @ 14,20 say "Press Q to quit or any other key to retry"       

       KeyPress := INKEY(0)
       IF Keypress = ASC("Q") .or. Keypress = ASC("q")
          RESTSCREEN(11,10,16,70,newvar)
          return .f.
       ENDIF
ENDIF

RESTSCREEN(11,10,16,70,newvar)

ENDDO

return .t.
