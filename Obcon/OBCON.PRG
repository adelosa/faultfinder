/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ OBject CONtrols for CA-Clipper                          13-02-95 บ
บ (c)Copyright A.J.D Business Software 1995              OBCON.PRG บ
บ                                                                  บ
บ Defines the classes for controls                                 บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ RELEASE INFORMATION                                              บ
บ     13-02-95                    Initial Release                  บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Global Include statements                                        บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

#include "oclip.ch"
#include "control.ch"
#include "obcon.ch"

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Contrl                                                           บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Generic class for all control types                              บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
CLASS Contrl
  VAR Ycoord
  VAR Xcoord
  VAR List
  VAR Default
  VAR Title
  VAR Selection
  VAR PreRead
  VAR PostRead

  METHOD Display                = ControlDisplay,;
         Read                   = ControlRead,;
         New                    = ControlNew,;
         AssignPreRead          = ControlPreRead,;
         AssignPostRead         = ControlPostRead,;
         MouseHit               = ControlMouseHit
          
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ControlNew(nYcoord,nXcoord,aList,nDefault,cTitle,cPreRead,cPostRead)
  
  ::Ycoord      := nYcoord
  ::Xcoord      := nXcoord
  ::List        := aList
  ::Default     := nDefault
  ::Title       := cTitle
  ::PreRead     := cPreRead
  ::PostRead    := cPostRead
  ::Selection   := nDefault
  ::UInput      := UserInput():New()

RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Display                                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ControlDisplay()
        @ ::YCoord, ::XCoord SAY "Control is a generic"        
        @ ::YCoord+1, ::XCoord SAY "Class and needs to"
        @ ::YCoord+2, ::XCoord SAY "be overriden"
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Read                                                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ControlRead()
        @ ::YCoord, ::XCoord SAY "Control is a generic"        
        @ ::YCoord+1, ::XCoord SAY "Class and needs to"
        @ ::YCoord+2, ::XCoord SAY "be overriden"
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD AssignPreRead                                             บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ControlPreRead(cPreReadCommand)
        ::PreRead := cPreReadCommand
RETURN Self 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD AssignPostRead                                            บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ControlPostRead(cPostReadCommand)
        ::PostRead := cPostReadCommand
RETURN Self 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD MouseHit                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ControlMouseHit()
        @ ::YCoord, ::XCoord SAY "Control is a generic"        
        @ ::YCoord+1, ::XCoord SAY "Class and needs to"
        @ ::YCoord+2, ::XCoord SAY "be overriden"
RETURN 

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ ControlList                                                      บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ List for storing objects                                         บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
CLASS ControlList
  VAR ListOfControls
  VAR RecordPointer
  VAR Action  

  METHOD DisplayAll             = CListDispAll,;
         DisplayCurrent         = CListShowCurrent,;
         New                    = CListNew,;
         Add                    = CListAdd,;
         Read                   = CListRead,;
         IsEndOfList            = CListEOL,;
         IsStartOfList          = CListSOL,;
         NextRecord             = CListNextRecord,;
         PreviousRecord         = CListPrevRecord,;
         GiveCurrentRecord      = CListGiveCurrent,;
         MouseHitField          = CListMouseHitField,;
         GetSelect              = CListGetSelect,;
         GetSelectString        = CListGetSString
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListNew()
  ::ListOfControls := {}
  ::RecordPointer := 1
RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD DisplayAll                                                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListDispAll()
LOCAL nCounter := 1
DO WHILE nCounter <= LEN(::ListofControls)
        (::ListofControls[nCounter]):Display()
        nCounter ++
ENDDO
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Add                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListAdd(oControl)
  AADD(::ListOfControls,oControl)
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD ShowCurrent                                               บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListShowCurrent()
  IF !EMPTY(::ListOfControls)
        ::ListOfControls[::RecordPointer]:Display()
  ENDIF
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD NextRecord                                                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListNextRecord()
  IF ::RecordPointer-1 <> LEN(::ListOfControls)
        ::RecordPointer++
  ENDIF
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD PreviousRecord                                            บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListPrevRecord()
  IF ::RecordPointer+1 <> 1
        ::RecordPointer--
  ENDIF
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD IsEndOfList                                               บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListEOL()
  IF ::RecordPointer-1 = LEN(::ListOfControls) .OR. EMPTY(::ListOfControls) 
        RETURN .T.
  ELSE
        RETURN .F.
  ENDIF
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD IsStartOfList                                             บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListSOL()
  IF ::RecordPointer+1 = 1 .OR. EMPTY(::ListOfControls) 
        RETURN .T.
  ELSE
        RETURN .F.
  ENDIF
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD GiveCurrentRecord                                         บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListGiveCurrent()
  IF !EMPTY(::ListOfControls)
        RETURN (::ListOfControls[::RecordPointer])
  ENDIF
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Read                                                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListRead()
LOCAL TheAction[2] 
LOCAL cTempText
PRIVATE cSelection

TheAction[ACTION] = CHANGE

DO WHILE .T.
        
        oCurrContl  := ::GiveCurrentRecord()
        
        IF !(EMPTY(oCurrContl:PreRead))
                cTempText := oCurrContl:PreRead
                do &cTempText
        ENDIF
        IF (::Action == MOUSE_FIELD)
                ::Action = CHANGE
        ENDIF
        TheAction        := oCurrContl:Read()        
        oCurrContl:Selection = TheAction[CHOICE]
        oCurrContl:Default   = TheAction[CHOICE]
        
        IF LEN(TheAction) == LASTPO
                oCurrContl:TopOfBox  = TheAction[LASTPO]
        ENDIF
        
        cSelection           = TheAction[CHOICE]
        
        ::Action    = TheAction[ACTION]       
               
        
        IF !(EMPTY(oCurrContl:PostRead))
                cTempText := oCurrContl:PostRead
                do &cTempText
        ENDIF
        
        DO CASE
                CASE (::Action == NEXTFIELD ; 
                .OR.  ::Action == CHANGE_NEXT) ;
                .AND. ::RecordPointer != LEN(::ListOfControls)
                        ::NextRecord()
                
                CASE ::Action == PREVFIELD  ;
                .AND. ::RecordPointer != 1
                        ::PreviousRecord()
                
                CASE ::Action == ENDREAD 
                        EXIT
                
                CASE ::Action == MOUSE_FIELD                 
//                      ::Action = CHANGE
                        ::MouseHitField(TheAction[MOUSEY],TheAction[MOUSEX])
                
                CASE (::Action == HELP)  
                        HelpOn(cTopic)
        ENDCASE
ENDDO
RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD MouseHit                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION CListMouseHitField(mouseY,mouseX)
LOCAL nCounter := 1
LOCAL oControl

DO WHILE nCounter <= LEN(::ListOfControls)
        oControl := (::ListOfControls[nCounter])
        IF oControl:MouseHit(MouseY,mouseX)
                ::RecordPointer = nCounter                
                EXIT
        ENDIF
        nCounter++
ENDDO

RETURN .T.

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD GetSelect                                                 บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
 Returns the selection value of the Control 
*/
FUNCTION CListGetSelect(nObjectNumber)
RETURN (::ListOfControls[nObjectNumber]):Selection

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD GetSelectString                                           บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
 Returns the string selected of the Control 
*/
FUNCTION CListGetSString(nObjectNumber)
LOCAL ControlObject := ::ListOfControls[nObjectNumber] 
RETURN ControlObject:List[ControlObject:Selection]

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Radio                                                            บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Define the Radiobutton class                                     บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
CLASS Radio FROM Contrl
METHOD   Display                = RadioDisplay,;
         Read                   = RadioRead,;
         MouseHit               = RadioMouseHit
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Display                                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION RadioDisplay()
        RETURN    RadioButton(::Ycoord,;
                        ::Xcoord,;
                        ::List,;
                        ::Default,;
                        ::Title,;
                        .F.,.T.)
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Read                                                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION RadioRead()
        RETURN    RadioButton(::Ycoord,;
                        ::Xcoord,;
                        ::List,;
                        ::Default,;
                        ::Title,;
                        .t.,.t.)
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD MouseHit                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION RadioMouseHit(mouseY,mouseX)
        IF ( mouseY >= (::YCoord + 1) )               .AND. ;
           ( mouseY <= (::YCoord + 1 + LEN(::List)) ) .AND. ;
           ( mouseX >= (::XCoord ) )                  .AND. ;
           ( mouseX <= ::XCoord + 6 + MaxStr(::List) )
                RETURN .T.
        ENDIF
RETURN .F.

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Logical                                                          บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Define the logic button class                                    บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
CLASS Logical FROM Contrl
METHOD   Display                = LogicalDisplay,;
         Read                   = LogicalRead,;
         New                    = LogicalNew,;
         MouseHit               = LogicalMousehit
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Read                                                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION LogicalRead()

RETURN LogButton(::Ycoord,;
                   ::Xcoord,;
                   ::Title,;
                   ::Default,;
                   .t.,.t.)
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Display                                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION LogicalDisplay()

RETURN LogButton(::Ycoord,;
                   ::Xcoord,;
                   ::Title,;
                   ::Default,;
                   .f.,.t.)
RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION LogicalNew(nYcoord,nXcoord,nDefault,cTitle,cPreRead,cPostRead)
  
  ::Ycoord      := nYcoord
  ::Xcoord      := nXcoord
  ::List        := {}
  ::Default     := nDefault
  ::Title       := cTitle
  ::PreRead     := cPreRead
  ::PostRead    := cPostRead
  ::Selection   := nDefault

RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD MouseHit                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION LogicalMouseHit(mouseY,mouseX)
        IF ((::YCoord+1) == mouseY) .AND. ;
            (mouseX >= (::XCoord+1)).AND. ;
            (mouseX <= ::XCoord + 4 + LEN(::Title))
                RETURN .T.
        ENDIF
RETURN .F.        

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Combo                                                            บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Define the combobox class                                        บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
CLASS Combo FROM Contrl
VAR      Width
VAR      TopOfBox
METHOD   Display                = ComboDisplay,;
         Read                   = ComboRead,;
         New                    = ComboNew,;
         MouseHit               = ComboMouseHit
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ComboNew(nYcoord,nXcoord,aList,cTitle,cPreRead,cPostRead,nWidth)
  
  ::Ycoord      := nYcoord
  ::Xcoord      := nXcoord
  ::List        := aList
  ::Default     := 1
  ::Title       := cTitle
  ::PreRead     := cPreRead
  ::PostRead    := cPostRead
  ::Selection   := 1
  ::Width       := nWidth
  ::TopOfBox    := 1
RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Display                                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ComboDisplay()
        RETURN    ComboBox(::Ycoord,;
                        ::Xcoord,;
                        ::List,;
                        ::Default,;
                        ::Title,;
                        .F.,.T.,;
                        ::Width,;
                        ::TopOfBox)
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Read                                                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ComboRead()
        ::Default := ::Selection
        RETURN    ComboBox(::Ycoord,;
                        ::Xcoord,;
                        ::List,;
                        ::Default,;
                        ::Title,;
                        .t.,.t.,;
                        ::Width,;
                        ::TopOfBox)
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD MouseHit                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ComboMouseHit(mouseY,mouseX)
        IF ( mouseY >= (::YCoord + 1) )               .AND. ;
           ( mouseY <= (::YCoord + 2) )               .AND. ;
           ( mouseX >= (::XCoord ) )                  .AND. ;
           ( mouseX <= (::XCoord + 4 + ::Width) )
                RETURN .T.
        ENDIF
RETURN .F.
/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Buttn                                                            บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Define the buttn class                                           บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
CLASS Buttn FROM Contrl
METHOD   Display                = ButtonDisplay,;
         Read                   = ButtonRead,;
         New                    = ButtonNew,;
         MouseHit               = ButtonMouseHit
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Read                                                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ButtonRead()
RETURN      Button(::Ycoord,;
                   ::Xcoord,;
                   ::Title,;
                   .t.)

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Display                                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ButtonDisplay()
RETURN      Button(::Ycoord,;
                   ::Xcoord,;
                   ::Title,;
                   .f.)

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ButtonNew(nYcoord,nXcoord,cTitle,cPreRead,cPostRead)
  
  ::Ycoord      := nYcoord
  ::Xcoord      := nXcoord
  ::List        := {}
  ::Default     := ""
  ::Title       := cTitle
  ::PreRead     := cPreRead
  ::PostRead    := cPostRead
  ::Selection   := ""

RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD MouseHit                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ButtonMouseHit(mouseY,mouseX)
        IF ((::YCoord+1) == mouseY) .AND. ;
            (mouseX >= (::XCoord+1)).AND. ;
            (mouseX <= ::XCoord + 2 + LEN(::Title))
                RETURN .T.
        ENDIF
RETURN .F.

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ TextField                                                        บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Define the Radiobutton class                                     บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
CLASS TextBox FROM Contrl
METHOD   Display                = TextDisplay,;
         Read                   = TextRead,;
         MouseHit               = TextMouseHit,;
         New                    = TextNew
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Display                                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION TextDisplay()
        RETURN    TextField(::Ycoord,;
                        ::Xcoord,;
                        ::Title,;
                        ::Selection,;
                        .F.)
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Read                                                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION TextRead()
        RETURN    TextField(::Ycoord,;
                        ::Xcoord,;
                        ::Title,;
                        ::Selection,;
                        .t.)
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD MouseHit                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION TextMouseHit(mouseY,mouseX)
        IF ( mouseY == ::YCoord+1 )                .AND. ;
           ( mouseX >= (::XCoord+1 ) )                  .AND. ;
           ( mouseX <= ::XCoord + LEN(::Title) + LEN(::Selection) + 1 )
                RETURN .T.
        ENDIF
RETURN .F.

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION TextNew(nYcoord,nXcoord,cTitle,cSelection,cPreRead,cPostRead)
  
  ::Ycoord      := nYcoord
  ::Xcoord      := nXcoord
  ::Title       := cTitle
  ::PreRead     := cPreRead
  ::PostRead    := cPostRead
  ::Selection   := cSelection

RETURN Self

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ ListB                                                            บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Define the listbox class                                         บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
CLASS ListB FROM Contrl
VAR      Options
VAR      Width
VAR      TopOfBox
METHOD   Display                = ListDisplay,;
         Read                   = ListRead,;
         MouseHit               = ListMouseHit,;
         New                    = ListNew
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Display                                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ListDisplay()

LOCAL nCount := 0
LOCAL MaxLen
LOCAL savecol := SETCOLOR(CONTROL_COLOR)

IF ::Options > LEN(::List)
        cOptions := LEN(::List)
else
        cOptions := ::Options
ENDIF

IF ::Width=0
        MaxLen := MaxStr(::List)
ELSE
        MaxLen := ::Width
ENDIF

//ExtraBox = SAVESCREEN(::Ycoord,::Xcoord-1,::Ycoord+cOptions,::Xcoord+MaxLen+4)
@ ::Ycoord+1,::Xcoord-1 CLEAR TO ::Ycoord+::Options,::Xcoord+MaxLen+3
Drawshadow(::Ycoord+1,::Xcoord-1,::Ycoord+::Options,::Xcoord+MaxLen+3)

SETCOLOR(savecol)

@ ::Ycoord,::Xcoord-1 say replicate(" ",(::Xcoord+MaxLen+3)-(::Xcoord-2)) COLOR TITLE_OFF
@ ::Ycoord,::Xcoord say ::Title COLOR TITLE_OFF

DO WHILE nCount < cOptions
      @ ::Ycoord+nCount+1,::Xcoord say space(MaxLen) COLOR CONTROL_COLOR
      @ ::Ycoord+nCount+1,::Xcoord say ::List[nCount+::TopOfBox] COLOR CONTROL_COLOR
      IF nCount+::TopOfBox = ::Selection 
           @ ::Ycoord+nCount+1,::Xcoord say ::List[nCount+::TopOfBox] COLOR BROW_COLOR
      ENDIF
      nCount++        
ENDDO
DrawStatusBar("")

RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD Read                                                      บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ListRead()
        ::Default := ::Selection
        RETURN    ListBox(::Ycoord,;
                        ::Xcoord,;
                        ::List,;
                        ::Selection,;
                        ::Title,;
                        .t.,.t.,;
                        ::Width,;
                        ::Options,;
                        ::TopOfBox)
        
RETURN 

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD MouseHit                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ListMouseHit(mouseY,mouseX)
        IF ( mouseY >= (::YCoord + 1) )               .AND. ;
           ( mouseY <= (::YCoord + 1 + ::Options) ) .AND. ;
           ( mouseX >= (::XCoord ) )                  .AND. ;
           ( mouseX <= (::XCoord + 5 + ::Width) )
                RETURN .T.
        ENDIF
RETURN .F.

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION ListNew(nYcoord,nXcoord,aList,cTitle,cPreRead,cPostRead,nWidth,nOptions)
  
  ::Ycoord      := nYcoord
  ::Xcoord      := nXcoord
  ::List        := aList
  ::Default     := 1
  ::Title       := cTitle
  ::PreRead     := cPreRead
  ::PostRead    := cPostRead
  ::Selection   := 1
  ::Options     := nOptions
  ::Width       := nWidth
  ::TopOfBox    := 1

RETURN Self

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ SS                                                               บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Save the screen in an object for easy replace                    บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
CLASS SS
  VAR sSavedScreen
  VAR Y1
  VAR X1
  VAR Y2
  VAR X2
  METHOD        New                    = SSNew,;
                ReDisplay              = SSDisplay
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION SSNew(nY1,nX1,nY2,nX2)
        ::Y1 := nY1
        ::X1 := nX1
        ::Y2 := nY2
        ::X2 := nX2
        ::sSavedScreen  := SAVESCREEN(nY1,nX1,nY2,nX2)
RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD ReDisplay                                                 บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION SSDisplay()
        RestScreen(::Y1,::X1,::Y2,::X2,::sSavedScreen)
RETURN 

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ WinBox                                                           บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Class for displaying boxes on the screen                         บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

CLASS WinBox
  VAR Y1
  VAR X1
  VAR Y2
  VAR X2
  VAR Expanding
  VAR BackColor
  VAR CloseBox
  VAR Title
  VAR BarColor
  VAR IsLine
  METHOD DisplayOn              = WinOnDisplay,;
         DisplayOff             = WinOffDisplay,;
         SetExpand              = WinExpand,;
         SetBackColor           = WinBackColor,;
         SetCloseBox            = WinCloseBox,;
         New                    = WinNew,;
         DrawBarOnly            = WinBarOnly,;          
         DrawWin                = WinDraw,;
         SetLine                = WinLine
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

FUNCTION WinNew(A,B,C,D,cTitle)
::Y1 := a
::X1 := b
::Y2 := c
::X2 := d
::Title := cTitle
::BarColor := "W+/B"
::Expanding := .f.
::BackColor := NOTI_COLOR
::CloseBox  := .f.
::IsLine    := .f.
RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD DisplayOff                                                บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION WinOffDisplay
::BarColor := "n+/b"
::DrawBarOnly()
RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD DisplayOn                                                 บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION WinOnDisplay
::BarColor := "W+/B"
::DrawBarOnly()
RETURN Self

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD DrawWin                                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE WinDraw

STATIC nTIMEVAL :=.01
LOCAL ThisScreen := SS():New(::Y1,::X1,::Y2+1,::X2+1)
LOCAL nAcount:=::Y1+Int((::Y2-::Y1)/2), ;
      nCcount:=::Y1+Int((::Y2-::Y1)/2)

LOCAL OldColor := SETCOLOR(::BackColor)

IF ::Expanding
        DO WHILE nAcount != ::Y1 .and. nCcount != ::Y2
                @ nAcount+1,::X1 CLEAR TO nCcount,::X2 
                nAcount--
                inkey(nTIMEVAL)
        
                @ nAcount,::X1 CLEAR TO nCcount,::X2 
                @ nAcount,::X1 SAY REPLICATE(" ",(::X2-::X1+1)) COLOR ::BarColor
                
                IF ::CloseBox
                        @ nAcount,::X1 SAY " ฤ " COLOR "N/W+"
                ENDIF
                
                @ nAcount,(::X1+((::X2-::X1)/2))-(LEN(::Title)/2) SAY ::Title COLOR ::BarColor
                nCcount++
                inkey(nTIMEVAL)
        ENDDO
ENDIF

@ ::Y1,::X1 CLEAR TO ::Y2,::X2 
IF ::IsLine
        @ ::Y1+1,::X1 TO ::Y2,::X2
ENDIF

::DrawBarOnly()
DrawShadow(::Y1,::X1,::Y2,::X2)
SETCOLOR(OldColor)

RETURN ThisScreen

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD DrawBarOnly                                               บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
PROCEDURE WinBarOnly
@ ::Y1,::X1 SAY REPLICATE(" ",(::X2-::X1+1)) COLOR ::BarColor
@ ::Y1,(::X1+((::X2-::X1)/2))-(LEN(::Title)/2) SAY ::Title COLOR ::BarColor
IF ::CloseBox
        @ ::Y1,::X1 SAY " ฤ " COLOR "N/W+"
ENDIF

RETURN

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD SetExpand                                                 บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION WinExpand
IF ::Expanding
        ::Expanding := .F.
ELSE
        ::Expanding := .T.
ENDIF         
RETURN SELF

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD SetLine                                                   บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION WinLine
IF ::IsLine
        ::IsLine := .F.
ELSE
        ::IsLine := .T.
ENDIF         
RETURN SELF

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD SetCloseBox                                               บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION WinCloseBox
IF ::CloseBox
        ::CloseBox := .F.
ELSE
        ::CloseBox := .T.
ENDIF         
RETURN SELF

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD SetBackColor                                              บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION WinBackColor(NewColor)
        ::BackColor := NewColor 
RETURN SELF

/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ UserInput                                                        บ
บ Class                                                            บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ Description:                                                     บ
บ Class for getting user input from mouse and keyboard             บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

CLASS UserInput
  
  VAR MouseDown
  VAR MouseScroll
  VAR KeyPress
  VAR MXcoord 
  VAR Mycoord 
  
  METHOD New                    = uiNew,;
         GetInput               = uiGetInput
ENDCLASS

/*
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ METHOD New                                                       บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
FUNCTION uiNew()

::KeyPress           := 0
::MouseDown          := .f.
::MouseScroll        := .f.
::MXcoord            := 1
::MYcoord            := 1

RETURN SELF

FUNCTION uiGetInput() 

LOCAL Timer          := 0
LOCAL LastMousePress := 0
LOCAL MousePress     := 0

mShow()         // Show the mouse

DO WHILE ::KeyPress == 0 .AND. .NOT. (::MouseDown .or. ::MouseScroll)
                       
        ::KeyPress = INKEY()
        MousePress = mBout()
                        
        IF (LastMousePress == 2) .and. (MousePress == 4)
                ::MouseDown = .T.
        ENDIF
                       
        IF LastMousePress <> MousePress .and. !(::MouseDown)
                ::MouseDown = .F.
        ENDIF
                               
        IF (LastMousePress == 2) .and. (MousePress == 2)
                Timer++     
        ENDIF
                        
        IF Timer == 500
                ::MouseScroll = .T.     
                Timer = 0
        ENDIF
                        
        ::MXcoord := mX()
        ::Mycoord := mY()
                                
        LastMousePress = MousePress
                        
ENDDO
mHide()

RETURN SELF


