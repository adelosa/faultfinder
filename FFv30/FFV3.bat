@ECHO OFF
clipper @%1.CC /b /o.\obj\%1.OBJ 
IF ERRORLEVEL 1 GOTO ERROR
rtlink @%1.LL
GOTO END
:ERROR
ECHO Error found....
PAUSE
:END
EXIT