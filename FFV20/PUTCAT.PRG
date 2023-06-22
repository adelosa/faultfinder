#include "inkey.ch"
#include "d:\work\clipper\common\control.h"

parameters cDatabase

IF EMPTY(cDatabase)
        ? "Usage PUTCAT <database name>"
        quit
endif

? "<" + cDatabase + ">"
SET SCOREBOARD OFF
SET STATUS OFF

use (cDatabase) index (cDatabase)
basescreen()
drawbox(1,5,12,74)
setcolor(WIN_COLOR)

counter:=1

DO WHILE !EOF()
        @ 2,50 say "Record "+str(counter)
        @ 2,10 say "Make     : "+mac_code
        @ 3,10 say "Model    :" get model
        @ 4,10 say "Category :" get category
        @ 5,10 say "Fault"
        @ 6,10 get fault1
        @ 7,10 get fault2
        @ 8,10 say "Remedy"
        @ 9,10 get remedy1
        @ 10,10 get remedy2
        @ 11,10 get remedy3
        read
        do case
        case (LASTKEY() = K_PGDN) 
                dbskip()
                counter++
        case (LASTKEY() = K_PGUP) 
                dbskip(-1)        
                counter--
        case (LASTKEY() = K_ESC) 
                exit    
        endcase
enddo
clear screen
close all


