@echo off
if "%1"=="LinkOnly" goto link
:compile

clipper MAINMENU /o.\obj\MAINMENU.obj 
IF ERRORLEVEL 1 GOTO end
clipper FINDFAUL /O.\OBJ\FINDFAUL.OBJ 
IF ERRORLEVEL 1 GOTO end
clipper PRINT /O.\OBJ\PRINT.OBJ
IF ERRORLEVEL 1 GOTO end
clipper HELPFUNC /O.\OBJ\HELPFUNC.OBJ
IF ERRORLEVEL 1 GOTO end
clipper FTREST /O.\OBJ\FTREST.OBJ
IF ERRORLEVEL 1 GOTO end
:link
rtlink @FFMAKE
:end
