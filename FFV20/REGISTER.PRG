#include "\work\clipper\common\control.h"
#define DISTRIBUTOR "RMIT "

// Registration Methods
// (C) Copyright A.J.D. Business Software 1994
// All rights Reserved

// The following code will be used to encode regristration
// information for a user.

// Structure of registration

/* 

The distributor will be provided with Licence numbers, which 
will constitute a sale, along with the corresponding number of
software products.  
When the distributor sells a product, they will give the customer
the Licence number.
When installing the product, the customer will type in their name,
as well as their Licence Number and will also be prompted for a 
registration key. This will be given over the phone by either 
A.J.D. Business Software or the distributor. 
Upon typing in the registration key, the product will unlock.

*/

*------------------------------------------
FUNCTION CrtCode(cDistn,cToEncode)
// Create a Fault Entry Code for a product.
*------------------------------------------

LOCAL count := 0
LOCAL char1,char2
LOCAL Encoded := ""

DO WHILE count++ < LEN(cDistn)
        char1 := ASC(SUBSTR(cDistn,count)) - 32
        char2 := ASC(SUBSTR(cToEncode,count)) - 32
        Encoded := Encoded + CHR(((char1 + char2) / 2) + 32)
        IF ((char1 + char2)%2) != 0
                Encoded := Encoded + "-"
        ENDIF
ENDDO

RETURN Encoded

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

*-------------------------------
FUNCTION CreateCkSum(FECode,Distn,ProdNum,SerialNum)
// Creates the cheksum for the product
RETURN (CHECKSUM(SerialNum+ProdNum+Distn+FECode))


*-------------------------------
FUNCTION ValidateReg(UserName,FECode,Distn,PNumber,PSerial,ProdSec,PUnloc)
// This function will validate the regristration

LOCAL CompText := "VCR and TV Fault Finder Version 2 for DOS )*()*()*"
SecurityCheck := CreateCkSum(FECode,Distn,PNumber,PSerial)

IF SecurityCheck != ProdSec
        RETURN .f.
ENDIF

NameCode        := CrtCode(UserName,CompText)
NameFaults      := FECode
NameDistn       := Distn

UnlockCode      := CHECKSUM(CrtCode(UserName,CompText)+STR(ProdSec))

IF UnlockCode != PUnloc
        RETURN .f.
ENDIF

SAVE ALL LIKE Name* to USER.INI

RETURN .t.

*-------------------------------------------
PROCEDURE mGetReg
*-------------------------------------------
// Used by A.J.D. Business Software to produce invoices

LOCAL OrigScreen := SaveScreen(10,4,18,76)
LOCAL nCount := 0
LOCAL RetValue := {1,1}
LOCAL cName := SPACE(50)
LOCAL Code  := 0
LOCAL cPNum := SPACE(4)
LOCAL cDistn := SPACE(5)
LOCAL CompText := "VCR and TV Fault Finder Version 2 for DOS )*()*()*"
LOCAL nLoopNumber := 1
LOCAL linenum := 0

OldColor := SETCOLOR(WIN_COLOR)
SET SCOREBOARD OFF
SET STATUS OFF

XDrawBox(10,5,16,75)

CT(10," Invoices Items ")
@ 11,6 SAY "Distributor    :" GET cDistn PICTURE "@!"
@ 12,6 SAY "Product Code   :" GET cPNum PICTURE "@!"
@ 13,6 SAY "Quantity       :" GET nLoopNumber PICTURE "@9"
@ 14,6 SAY "Variable Entry :" GET Code

SET CURSOR ON
READ
SET CURSOR OFF

@ 11,6 CLEAR TO 14,74

Counter := 1

DO WHILE Counter <= nLoopNumber
        cSerial := UniqIDNum(cPNum)
        FECode  := ALLTRIM(CrtCode(cDistn,STR(Code,5)))
        CkSum := ALLTRIM(STR(CreateCkSum(FECode,cDistn,cPNum,cSerial)))
        
        USE REGOPAK INDEX REGOPAK
        
        DBAPPEND()
        REGOPAK->PRODCODE := cPNum
        REGOPAK->SERIAL   := cSerial
        REGOPAK->DISTN    := cDistn
        REGOPAK->FAULTS   := Code
        DBCLOSEAREA()

        CT(11,"Producing Registrations")
        CT(12,"Serial Number - "+cSerial)
        
        SET CONSOLE OFF
        SET DEVICE TO PRINTER

        @linenum,0 SAY CHR(27)+"I"+CHR(10)
        @linenum,0 SAY CHR(27)+"w"+CHR(1)
        @linenum,2 say "Product Registration Info"
        @linenum+2,2 say "A.J.D. Business Software"
        @linenum+4,0 SAY CHR(27)+"w"+CHR(0)
        @linenum+4,2 SAY "Product Code  : "+cPNum
        @linenum+5,2 SAY "Serial Number : "+cSerial
        @linenum+6,2 SAY "Distributor   : "+cDistn
        @linenum+7,2 SAY "FE Code       : "+FECode
        @linenum+8,2 SAY "Security Code : "+CkSum
        
        linenum = linenum + 15
        IF linenum > 80
                EJECT
                linenum := 0
        endif
        SET DEVICE TO SCREEN
        SET CONSOLE ON
        counter++

ENDDO

@ 11,6 CLEAR TO 14,74

CT(11,"Completed")
Button(15,35,"Continue",.t.)
@ 11,6 clear to 13,74

setcolor(OldColor)
@ 24,0
RestScreen(10,4,18,76,OrigScreen)
RETURN



*-------------------------------------------
PROCEDURE mPutReg(ProdCode)
*-------------------------------------------
// This module is used in the install program 
// in the product

LOCAL OrigScreen := SaveScreen(10,3,21,76)
LOCAL nCount := 0
LOCAL cName := SPACE(50)
LOCAL Code  := SPACE(10)
LOCAL cPNum := ProdCode    &&
LOCAL cPSer := SPACE(5)
LOCAL cPSec := SPACE(10)
LOCAL cPUnlock := SPACE(10)
LOCAL Distn := SPACE(5)
LOCAL CompText := "VCR and TV Fault Finder Version 2 for DOS )*()*()*"
LOCAL AllOK := .f.

SETCOLOR(WIN_COLOR)
SET SCOREBOARD OFF
SET STATUS OFF

XDrawBox(10,5,19,75)
CT(10," Register ")
@ 11,6 SAY "Name          :" GET cName PICTURE "@!"
@ 12,6 SAY "FE Code       :" GET Code
@ 13,6 SAY "Distributor   :" GET Distn PICTURE "@!"
@ 14,6 SAY "Serial        :" GET cPSer PICTURE "@!"
@ 15,6 SAY "Security      :" GET cPSec PICTURE "@9"
@ 16,6 SAY "Unlock code   :" GET cPUnlock PICTURE "@9"

SET CURSOR ON
READ
SET CURSOR OFF

@ 11,6 clear to 17,74

Code := ALLTRIM(Code)
cPUnlock := VAL(ALLTRIM(cPUnlock))
cPSec := VAL(ALLTRIM(cPSec))

IF .NOT. ValidateReg(cName,Code,Distn,cPNum,cPSer,cPSec,cPUnlock)
        CT(13,"Invalid Code")                
ELSE
        CT(13,"Valid Code")                
        AllOK := .t.
ENDIF

Button(15,35,"Continue",.t.)

RestScreen(10,3,21,76,OrigScreen)

RETURN (AllOK)

*--------------------------------------------
FUNCTION UniqIDNum(cPNum)
// Checks the Regopak database for a unique number for the 
// product number. Returns the unique number.
*--------------------------------------------
cDatabase := "regopak"
cField := "PRODCODE"
USE REGOPAK INDEX REGOPAK

SEEK cPNum

IF FOUND()
        DO WHILE regopak->prodcode == cPNum .AND. !EOF()
                DBSKIP()
        ENDDO
        DBSKIP(-1)      
        RetVal1 := LTRIM(STR((VAL(SERIAL)+1)))
        RetVal2 := replicate("0",(5-LEN(RetVal1)))+RetVal1
ELSE
        RetVal2 := "00001"
ENDIF

DBCLOSEAREA()

RETURN (RetVal2)

*-------------------------------------------
PROCEDURE mGetUnlock()
*-------------------------------------------
// This program is used by the distributor to 
// get unlock codes for the product

LOCAL OrigScreen := SaveScreen(10,4,18,76)
LOCAL nCount := 0
LOCAL RetValue := {1,1}
LOCAL cName := SPACE(50)
LOCAL FECode  := SPACE(10)
LOCAL cPNum := SPACE(4)
LOCAL cSerial := SPACE(5)
LOCAL cDistn := DISTRIBUTOR
LOCAL CompText := "VCR and TV Fault Finder Version 2 for DOS )*()*()*"
LOCAL cSecurity := SPACE(10)

cDistn := SPACE(5)      // Clear value of distributor
OldColor := SETCOLOR(WIN_COLOR)
SET SCOREBOARD OFF
SET STATUS OFF

XDrawBox(10,5,17,75)
CT(10," Unlock Product ")
@ 11,6 SAY "Name         :" GET cName PICTURE "@!"
@ 12,6 SAY "FE Code      :" GET FECode PICTURE "@!"
@ 13,6 SAY "Product Code :" GET cPNum PICTURE "@!"
@ 14,6 SAY "Serial Number:" GET cSerial PICTURE "@9"
@ 15,6 SAY "Security     :" GET cSecurity PICTURE "@9"
@ 16,6 say "Distributor  :" GET cDistn

SET CURSOR ON
READ
SET CURSOR OFF

@ 11,6 clear to 15,74

CkSum := ALLTRIM(STR(CreateCkSum(TRIM(FECode),cDistn,cPNum,cSerial)))

IF TRIM(cSecurity) == CkSum
        
        UnlockCode := ALLTRIM(STR(CHECKSUM(CrtCode(cName,CompText)+CkSum)))
        USE REGOPAKD INDEX REGOPAKD
        SEEK cPNum+cSerial

        IF !FOUND()
                DBAPPEND()
                REGOPAKD->PRODCODE := cPNum
                REGOPAKD->SERIAL   := cSerial
                REGOPAKD->DISTN    := cDistn
                REGOPAKD->USERNAME := cName
        
                @ 12,7 say "Unlock code      :" + UnlockCode 

                SET CONSOLE OFF
                SET DEVICE TO PRINTER

                @0,0 SAY CHR(27)+"I"+CHR(10)
                @0,0 SAY CHR(27)+"w"+CHR(1)
                @0,2 say "Registration Information"
                @2,2 say "A.J.D. Business Software"
                @4,0 SAY CHR(27)+"w"+CHR(0)
                @5,2 SAY "User Name     : "+cName
                @6,2 SAY "Product Code  : "+cPNum
                @7,2 SAY "Serial Number : "+cSerial
                @8,2 SAY "Distributor   : "+cDistn
                @9,2 SAY "FE Code       : "+FECode
               @10,2 SAY "Security Code : "+CkSum
               @11,2 SAY "Unlock Code   : "+UnlockCode
                EJECT
                set device to screen
                SET CONSOLE ON
        ELSE
                CT(11,"This Product is Registered to")
                CT(12,TRIM(username))
        ENDIF

        Button(15,35,"Continue",.t.)
ELSE
        CT(11,"Product Failed Security Check")
        CT(12,"Please try again")
        Button(15,35,"Continue",.t.)
ENDIF

RestScreen(10,4,18,76,OrigScreen)
setcolor(OldColor)
@ 24,0
DBCLOSEAREA()
RETURN

*--------------------------------------------
FUNCTION UniqINVNum(cDistn)
// Checks the Regopak database for a unique number for the 
// product number. Returns the unique number.
*--------------------------------------------
USE mastinv INDEX mastinv
SEEK Distn
IF FOUND()
        DO WHILE mastinv->distn == Distn .AND. !EOF()
                DBSKIP()
        ENDDO
        DBSKIP(-1)
        
        RetVal1 := LTRIM(STR((VAL(SERIAL)+1)))
        RetVal2 := replicate("0",(5-LEN(RetVal1)))+RetVal1
ELSE
        RetVal2 := "00001"
ENDIF

DBCLOSEAREA()

RETURN (RetVal2)



