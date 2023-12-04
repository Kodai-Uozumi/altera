@echo off
@ set SOPC_BUILDER_PATH=%SOPC_KIT_NIOS2%+%SOPC_BUILDER_PATH%
@quartus_pgm -m jtag -c USB-Blaster[USB-0] -o "p;pi_2c35revc_utmirev5.sof"
pause
@ %QUARTUS_ROOTDIR%\bin\cygwin\bin\bash.exe --rcfile Run_Nios_bashrc
pause
@echo on