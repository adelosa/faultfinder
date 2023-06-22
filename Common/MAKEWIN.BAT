clipper winmenu /o.\obj\winmenu.obj
clipper direct /o.\obj\direct.obj
clipper control /o.\obj\control.obj
clipper getsys /m /n /w /o.\obj\getsys.obj
rtlink file .\obj\winmenu,.\obj\control,.\obj\direct,.\obj\getsys output .\exe\winmenu.exe lib ct lib clipmous
