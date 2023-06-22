*-------------------------
* Instalation main Program
*-------------------------
clear screen
SET TALK OFF
SET SCOREBOARD OFF
SET STATUS OFF

basescreen()

savecolor := setcolor("b/w,w/b")
drawbox(5,23,9,57)

CT( 6,"Fault Finder install program")
CT( 7,"Version 2.0 For DOS")
CT( 8,"(c)Copyright A.J.D. Business Software 1994")

FirstScreen := savescreen(0,0,24,79)

drawbox(13,10,16,70)
CT(14,"If you have any problems installing this product")
CT(15,"Run README located on the Install disk") 
CT(16," Press any key to continue ")
Crap := Inkey(0) 

restscreen(0,0,24,79,Firstscreen)

if valid        
	FirstScreen := savescreen(0,0,24,79)
	drawbox(13,20,16,60)  
	@ 14,29 say "Do you wish to continue?"
	@ 15,24 PROMPT " Continue Instalation "
	@ 15,46 PROMPT " Exit to DOS "
	
	MENU TO nChoice
	
	restscreen(0,0,24,79,Firstscreen)
	
	IF nChoice = 1
	     
	     FirstScreen := savescreen(0,0,24,79)
	     drawbox(14,25,20,55)           
	     @ 14,33 say "Install Details"           
	     @ 15,27 say "Directory to install to :"           
	     InstDir = "C:\VIDEO                   " 
	     @ 16,27 get InstDir
	     @ 18,27 say "Installing from drive"
	     drive := "A:"
	     @ 19,27 get drive
	     READ                    
	     restscreen(0,0,24,79,Firstscreen)
	     
	     InstDir = TRIM(InstDir)
	     Drive2Check := Left(InstDir,1)
	     
	     If DiskFree(Drive2Check) < 3500000
		DrawBox(4,10,11,70)
		@ 5,12 say "Insufficient Disk space on drive " + Drive2Check + ":"
		@ 7,12 say "This Program requires 3.5M of disk space "
		@ 8,12 say "Clear some space and try to install again "
		@ 10,12 say "Press any key to continue"
		newwait()
		clear screen
		quit
	     Endif
	     
	     FirstScreen := savescreen(0,0,24,79)
	     drawbox(14,25,18,55)           
	     @ 14,33 say "Video Configuration"           
	     @ 15,27 say "Type of Video Card :"           
	     @ 16,37 Prompt "  VGA  "
	     @ 17,37 Prompt " Other "
	     menu to cRegColor
	     If cRegColor = 1
		cRegColor = .t.
	     else
		cRegColor = .f.
	     endif
	     restscreen(0,0,24,79,Firstscreen)
	     
		If mSuccess := SetAndMakeDir(InstDir)
		   FirstScreen := savescreen(0,0,24,79)                
		   drawbox(14,20,16,60) 
		   @ 15,25 say "Please wait while copying files.."
		   DataFile = InstDir+"\ffinder.dat"
		   save to (DataFile) all like cReg*
		   copyprog(InstDir,drive)        
		   MakeBatch(InstDir)
		   restscreen(0,0,24,79,Firstscreen)             
	     endif
	ENDIF
   endif


FirstScreen := savescreen(0,0,24,79)                
drawbox(12,20,15,60) 

if mSuccess 
    @ 13,29 say "Successfull completition"
    @ 14,31 say   "Type FFINDER to run"
else
    @ 13,30 say   "Install not completed"
endif

@ 15,30  say  "Press any key to exit"

wait""

setcolor(savecolor)
clear screen

*----------------------------------
procedure copyprog(dest,source)
private counter1,cfile,CurrFile[3]
*----------------------------------

counter1 := 1
CurrFile := {"File01.exe","file02.exe","File03.exe"}

do while counter1 <= len(CurrFile)
	* Add here the password
	cCommand := "copy "+ source + CurrFile[counter1] + " >null"
	run (cCommand)         
	cCommand := CurrFile[counter1] + " -o >null"
	run (cCommand)         
	cCommand := "del "+ CurrFile[counter1] + " >null"
	run (cCommand)         
	counter1++
enddo

 cCommand := "del null. "
 run (cCommand) 
 run cd\

Procedure MakeBatch(FullFileSpec)
/* This procedure creates a simple batch program which invokes the 
installed program */

#include "Fileio.ch"

drive := left(FullFileSpec,2)
FileDirect := SubStr(FullFileSpec,3,(len(FullFileSpec)-2))

IF (nHandle := FCREATE(drive + "\ffinder.bat",FC_NORMAL) ) ==-1 
  ? "File cannot be created:" ,FERROR ()
    BREAK
ELSE
    Fputs(nHandle, "cd "+ FileDirect )
    Fputs(nHandle, "FFINDER" )
    Fputs(nHandle, "cd\" )
    FCLOSE(nHandle)
ENDIF


procedure newwait()

crap := inkey(0)

return
