@echo off
@REM cygreg - setup cygwin registry entries
@REM (run before using cygwin shell)

@if "%*" == ""  goto :no_args
@if NOT EXIST "%*\bin\bash.exe" goto :nobash

@REM remove existing mount-points and set up new ones
set CYGROOT=%*
"%CYGROOT%\bin\umount.exe" --remove-all-mounts
"%CYGROOT%\bin\mount.exe" -t -s "%CYGROOT%" /
"%CYGROOT%\bin\mount.exe" -t -s "%CYGROOT%\bin" /usr/bin
"%CYGROOT%\bin\mount.exe" -t -s "%CYGROOT%\lib" /usr/lib
goto :eof

:nobash
@echo Error: Cannot locate "%*\bash.exe"
exit /b 1

:no_args
@echo Error: This command should only be run by the installer!
exit /b 2
