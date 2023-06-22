#include "Directry.ch"

*--------------------
FUNCTION GetDirs()
*--------------------
/* This function gets the names of the directories 
in the current directory */
LOCAL nCount := 1
LOCAL aReturn:={}
LOCAL aDirectory

aDirectory := DIRECTORY("*.*", "D")
DO WHILE nCount <= LEN(aDirectory)
        IF aDirectory[nCount][5] = "D"
                aadd(aReturn,aDirectory[nCount][1])
        ENDIF
        nCount++
ENDDO

RETURN aReturn

*--------------------
FUNCTION AvailDrive()
*--------------------
LOCAL aDrives:={}

if Numdiskf()==2
        aadd(aDrives,"A")
        aadd(aDrives,"B")
ELSEIF Numdiskf() == 1
        aadd(aDrives,"A")
ENDIF

Counter := 3
do while Counter != Numdiskl()+1
        IF diskchange(Chr(counter+64))
                aadd(aDrives,chr(counter+64))
        ENDIF
        counter++
enddo

RETURN aDrives

*--------------------
FUNCTION GetFiles()
*--------------------
/* This function gets the names of the files 
in the current directory */
LOCAL nCount := 1
LOCAL aReturn:={}
LOCAL aDirectory

aDirectory := DIRECTORY("*.*")
DO WHILE nCount <= LEN(aDirectory)
        aadd(aReturn,aDirectory[nCount][F_NAME])
        nCount++
ENDDO

RETURN aReturn
