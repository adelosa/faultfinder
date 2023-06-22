#include "data.ch"

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
LOCAL lInfoFile := lNoModIndex := lCatIndex := lMakeIndex:= lModelIndex := .f.
LOCAL DbfName := GetFileName(cMatch)

DO WHILE nLen >= nCount
        IF UPPER(ALLTRIM(aList[nCount]))             ;
         == LEFT(ALLTRIM(DbfName),3) + "CAT.NTX"
                lCatIndex := .t.
        ENDIF
        IF UPPER(ALLTRIM(aList[nCount]))             ;
         == LEFT(ALLTRIM(DbfName),3) + "NOMOD.NTX" 
                lNoModIndex := .t.
        ENDIF
        IF UPPER(ALLTRIM(aList[nCount]))             ;
         == LEFT(ALLTRIM(DbfName),3) + "MAKE.NTX"
                lMakeIndex := .t.
        ENDIF
        IF UPPER(ALLTRIM(aList[nCount]))             ;
         == LEFT(ALLTRIM(DbfName),3) + "MODEL.NTX" 
                lModelIndex := .t.
        ENDIF
        IF UPPER(ALLTRIM(aList[nCount]))             ;
         == ALLTRIM(DbfName) + ".INI" 
                lInfoFile := .t.
        ENDIF
        
        IF lCatIndex .and. lInfoFile .and. lNoModIndex .and. lMakeIndex  ;
        .and. lModelIndex
                RETURN .t.
        ENDIF
        nCount++
ENDDO

RETURN .f.

