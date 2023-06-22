//List of all models for vcr akai
/*
public MainHandle
MainHandle := OpenDBFile("VCR")
mylist := GetItems(getdataforsearch("VCR","MAKE","Blaupunkt ","MODEL"))
PrintItems(mylist)

FUNCTION PrintItems(thearray)
LOCAL Count := 1
DO WHILE count <= LEN(Thearray)
    ? TheArray[count] 
    count++
ENDDO
? LEN(TheArray)
RETURN 
*/

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ VCR and TV Fault Finder                                          บ
บ Version 3.0 For DOS                                              บ
บ                                                                  บ
บ (C) 1995 A.J.D. Business Software                                บ
บ                                                                  บ
บ DB Load Module - dbload.prg                                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Compiler includes                                                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

#include "oclip.ch"
#include "..\OBCON\control.ch"
#include "..\OBCON\obcon.ch"
#include "data.ch"

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Main Back end processing                                         บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

FUNCTION GetDataForSearch(sDbfFile,Field2Search,Text2Find,Field2Get,uIDXkey)

LOCAL nLastArea := SELECT()
LOCAL SearchStat:= StatusNew(24,2)
LOCAL cIDXKey := TRIM(LEFT(Field2Get,5))
LOCAL List := {}
LOCAL EntriesFound := 0

if !EMPTY(uIDXKey)
        cIDXKey:=uIDXKey
endif

DrawStatusBar("Opening Indexes...")    

DBSELECTAREA( MainHandle )        // select main database
DBCLEARIND()                      // Clears any old indexes
DBSETINDEX( LEFT(sDbfFile,3) + cIDXKey + MAIN_INDEX )          // set index

DrawStatusBar("Seeking info...")    
IF !EMPTY(Text2Find)
        SEEK Text2Find
ENDIF

IF FOUND() .OR. EMPTY(Text2Find)
        DrawStatusBar("Adding Entries...")    
        AADD(List,{&Field2Get,1})
        LastEntry := trim(&Field2Get)
        EntriesFound++
        DBSKIP()
        
        DO WHILE !EOF() 
                IF !EMPTY(Text2Find)
                        IF Text2Find != &Field2Search 
                                exit                
                        endif
                endif
                
                if lastentry != trim(&Field2Get)
                        aadd(List,{&Field2Get,1})
                        LastEntry := Trim(&Field2Get)
                        StatusUpdate(SearchStat)
                        EntriesFound++
                else
                        (List[EntriesFound][2])++
                endif
                
                DBSKIP()
        ENDDO
ENDIF

DBSELECTAR(nLastArea)                   // Restore previous work area

DrawStatusBar("")
@24,0 say SPACE(5) color STAT_COLOR

RETURN ASORT(List,,,{ |x , y| x[1] < y[1] })

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Uniquie dbhandle number generator                                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION UniNum()

STATIC number := 1

IF number = 2000
        number = 1
ENDIF

RETURN "A"+ALLTRIM(STR(number++))

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Database open routine                                            บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION OpenDBFile(dbName)

LOCAL MainHandle
DrawStatusBar("Opening Faultbook...")    
DBUSEAREA( .T., "DBFNTX", dbName + MAIN , Handle := UniNum(), .T. )
DBSELECTAREA( Handle )        // select the database
DrawStatusBar("")    
RETURN Handle

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Database close routine                                           บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CloseDBFile(Handle)

DrawStatusBar("Closing Faultbook...")
DBSELECTAREA( Handle )              // select the database
DBCLOSEAREA()                           // Close database
DrawStatusBar("")    
RETURN .T.

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Places the first element from multidimentional array into single บ
บ dim array                                                        บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION GetItems(thearray)
LOCAL Count := 1
LOCAL ReturnArray := {}
DO WHILE count <= LEN(Thearray)
    AADD(ReturnArray,TheArray[count][1]) 
    count++
ENDDO
RETURN ReturnArray
