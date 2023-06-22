#include "d:\work\clipper\common\control.h"
// This is a scratchie which creates the .mem file
// containing the categories
SET SCOREBOARD OFF
SET STATUS OFF

vCat1 := space(15)
vCat2 := space(15)
vCat3 := space(15)
vCat4 := space(15)
vCat5 := space(15)
vCat6 := space(15)
vCat7 := space(15)
vCat8 := space(15)
vCat9 := space(15)
vCat0 := space(15)
cfilename := space(8) 

basescreen()
drawbox(4,10,18,70)
setcolor(WIN_COLOR)

CT(4,"Update categories")

@ 6,15 say "Cat 1 " get vCat1
@ 7,15 say "Cat 2 " get vCat2
@ 8,15 say "Cat 3 " get vCat3
@ 9,15 say "Cat 4 " get vCat4
@ 10,15 say "Cat 5 " get vCat5
@ 6,45 say "Cat 6 " get vCat6
@ 7,45 say "Cat 7 " get vCat7
@ 8,45 say "Cat 8 " get vCat8
@ 9,45 say "Cat 9 " get vCat9
@ 10,45 say "Cat 10" get vCat0
@ 12,15 SAY "Faultbook name " get cfilename

read

IF cfilename!=SPACE(8)
        SAVE ALL TO (trim(cfilename)+".INI")
ENDIF

clear screen
