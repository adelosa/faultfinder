*---------------------------
FUNCTION SetAndMakeDir (Direct2Do)

/* SetAndMakeDir procedure accepts a Full directory name, and procedes
to change to the directory. If any of the directory is found not to
exist, the program prompts to create the directory. */

aList := DirExtract(Direct2Do) 
lFinished := .t.
LastColor := SetColor("b/w,w+/b")

RUN (Left(aList[1],2))     /* In aList, the first element is the drive 
                                letter of the directory list */
RUN CD\
count := 2

/* This section loops through each subdirectory name ,checks to see if 
it exists. If it does, it changes its default to the specified subdirectory.
Otherwise, it asks if you wish to create the directory. True is returned
if the command successfully creates all directorys, and false if the
specified directory is not created or set to. */

DO WHILE count <= LEN(aList)

   IF DirExists(left(aList[1],2),TRIM(aList[count]))
        mComm := "CD "+ (alist[count])
        RUN (mComm) 
   ELSE
        IF mGenYesNo("Create Directory",;
        "Will I create the directory ["+TRIM(UPPER(alist[count]))+"]")
           mComm := "MD "+ aList[count] 
           RUN (mComm) 
           mComm := "CD "+ aList[count] 
           RUN (mComm)
        ELSE 
           lFinished = .f.          
           exit
        ENDIF
        
   ENDIF

count++

ENDDO
SetColor(LastColor)


RETURN lFinished

*--------------------------------
Function DirExists(Drive,DirName)
/* This function takes the DirName and Drive and tests if it is valid 
for the current directory, or use Drive to specify the full path.

Examples -  DirExist ("c:","SYSTEM") where default directory on C: drive
is C:\WINDOWS, if the directory C:\WINDOWS\SYSTEM exists, the function 
will return true
            
            DirExist ("C:\WINDOWS","SYSTEM") with any default directory,
as the directory is explicit in the Drive variable, the function will 
return true if the directory C:\WINDOWS\SYSTEM exists. If this method 
is used, it is true that the directory specified in Drive must exist. */

#include"Directry.ch"
//

Local DirFound, count

count :=1
DirFound := .f.


aDirectory := Directory(drive+"*.","D") 

/* The following searches each directory name in the array, and if it matches 
the name passed as a directory DirName, RETURN = .T., else the directory
name does not exist and .f. is returned. */

DO WHILE count <= LEN(aDirectory)
     IF Upper(aDirectory[count++][F_NAME]) = Upper(DirName)
        DirFound = .t.
     ENDIF
ENDDO

RETURN DirFound

*--------------------------------
Function DirExtract(FullFileSpec) 

/* This function accepts the character sting containing FullFileSpec,
and places each subdirectory into an array element. This array is then 
returned to the calling program.. 
eg..

FullFileSpec = "C:\dos\sub1\sub2"

Return array  = {"c:","dos","sub1","sub2"}

Modifications:- 
4-11-93 Truncate file names to 8 characters. (AD)

*/

CharCount := 1
TargetArray := {}

DO WHILE CharCount <= LEN(FullFileSpec)
   
   StringValue = ""
   InterValue = ""
   
/* The following section scans each character of FullFileSpec and
when it finds a "\" it places chararacters contained in StringValue 
to a element in the array. InterValue stores each individual character */

   DO WHILE InterValue <> "\" .AND. CharCount <= LEN(FullFileSpec)+1
         StringValue = StringValue + Intervalue
         InterValue = SubStr(FullFileSpec,CharCount++,1)
   ENDDO

/* Truncates the directory name to 8 characters */   
   If Len(StringValue) > 8
        StringValue = Left(StringValue,8)
   endif
   
   Aadd(TargetArray,StringValue)

ENDDO

RETURN TargetArray


FUNCTION FPuts(Handle,String)
        FWRITE(Handle,String+chr(13)+CHR(10))
RETURN .T.

