select 1
use vcr.dbf index vcrmake vcrmodel vcrcat vcrnocat

do while !eof()
        if category == " 0"
                vcr->category = "10"
        endif
        select 1
        skip
enddo
close all

