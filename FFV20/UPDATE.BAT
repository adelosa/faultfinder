@ECHO OFF
REM UPDATE.BAT
REM This batch file looks at the current directory for the file
REM .dbf, and transfers the data to the new data structure.

IF EXIST CUSTOM.DAT GOTO COPYINFO
GOTO ERROR

:COPYINFO
DOUPD.EXE
IF ERRORLEVEL 1 GOTO ERROR
GOTO OK

:ERROR
REM cls
echo ** No previous version of Fault Finder Detected **
GOTO END 

:OK
REM cls
echo ** Converted sucessfully **

:END

