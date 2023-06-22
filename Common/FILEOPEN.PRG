*-------------------------------------------
FUNCTION mOpenFile(cCurrentFB)
*-------------------------------------------
/* Save the screen */
LOCAL OrigScreen := SaveScreen(8,4,19,75)

/* Get initial directory information */
STATIC NUMFIELDS:=4 
LOCAL GetField:=1                       && Field counter
LOCAL aGetValue:={1,1,1,1}              && Stores results of fields
LOCAL aCurrentField[2]                  && Gets the return value
LOCAL sFaultBook := cCurrentFB 

/* Common interface variables */
PRIVATE aDrives:=AvailDrive()
PRIVATE nStartDrv:=MatchAStr(DiskName(),aDrives)
PRIVATE nStartFile:=1
PRIVATE aDirs:=GetDirs()
PRIVATE aFiles:=GetValidData(GetFiles())

XdrawBox(8,5,18,75)
CT(8," Open Faultbook ")
@ 9,10 say "Faultbook:  "

DO mFileOpSays
@ 9,22 say aDrives[nStartDrv]+":"+iif(len(dirname())=1,"\",DirName()+"\")

/* Main loop where reads take place. Uses field counter
to count which field it is up to */

DO WHILE .T.
        
        DO CASE
                CASE GetField=1
                        aCurrentField   :=ComboBox(10,10,aDrives,nStartDrv,"Drive",.T.,.t.,5)
                        DiskChange(aDrives[(aCurrentField[CHOICE])]) && Change to new drive
                        aDirs           :=GetDirs()                     // Update Directory info              
                        aFiles          :=GetValidData(GetFiles())      // Update File info
                        nStartDrv       :=MatchAStr(DiskName(),aDrives)
                        DO mFileOpSays                                  // Display new info to screen                                            
                
                CASE GetField=2
                        aCurrentField :=ComboBox(10,20,aDirs,1,"Directories",.T.,.t.,12)
                        IF aCurrentField[ACTION] = CHANGE_NEXT .or. aCurrentField[ACTION] = CHANGE
                                DirChange(".\"+aDirs[(aCurrentField[CHOICE])])                                
                                aDirs:=GetDirs()                 && Update Directory info              
                                aFiles:=GetValidData(GetFiles()) && Update File info
                                DO mFileOpSays            && Display new info to screen
                                IF aCurrentField[ACTION] = CHANGE_NEXT 
                                        aCurrentField[ACTION] = NEXTFIELD
                                ENDIF
                        ENDIF                
                
                CASE GetField=3
                        aCurrentField :=ComboBox(10,40,aFiles,nStartFile,"Files",.T.,.t.,12)
                        nStartFile := aCurrentField[CHOICE]
                CASE GetField=4        
                        aCurrentField := Button(16,58,"Select File",.t.)
                        IF aFiles[aGetValue[3]]="None" .and. aCurrentField[ACTION] = SAVEREAD
                                @24,23 SAY "You must select a faultbook to open") COLOR STAT_COLOR 
                                inkey(3)
                                aCurrentField[ACTION]=PREVFIELD
                        ELSE
                                EXIT
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
                        @24,33 SAY "Open Cancelled" COLOR STAT_COLOR
                        EXIT
                
                CASE aCurrentField[ACTION] = SAVEREAD 
                        EXIT
        ENDCASE
        
        @ 9,22 say space(50) COLOR STAT_COLOR
        @ 9,22 say cFile2Open := aDrives[nStartDrv]+":" + ;
        iif(len(dirname())=1,"\",DirName()+"\")+iif(aFiles[aGetValue[3]]="None","*",aFiles[aGetValue[3]])

ENDDO

@24,0 SAY SPACE(80) COLOR STAT_COLOR

CT(24,aDrives[nStartDrv]+":"+iif(len(dirname())=1,"\",DirName()+"\")+aFiles[aGetValue[3]])

IF .not. aCurrentField[ACTION] = ENDREAD ;
.and. mGenYesNo("Will I open the faultbook",cFile2Open) 
        cOldColor := SETCOLOR(STAT_COLOR)
        CT(24,"Faultbook open")        
        sFaultBook = cFile2Open
ELSE
        cOldColor := SETCOLOR(STAT_COLOR)
        CT(24,"Open Cancelled")
ENDIF

SETCOLOR(cOldColor)
RestScreen(8,4,19,75,OrigScreen)
RETURN (sFaultBook) 
