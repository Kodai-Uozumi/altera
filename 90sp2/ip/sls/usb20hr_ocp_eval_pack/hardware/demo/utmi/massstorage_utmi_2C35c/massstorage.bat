
@echo off
@ set SOPC_BUILDER_PATH=%SOPC_KIT_NIOS2%+%SOPC_BUILDER_PATH%
@  quartus_pgm -m jtag -c USB-Blaster[USB-0] -o "p;ms_2c35revc_utmi.sof"

pause..
@ %QUARTUS_ROOTDIR%\bin\cygwin\bin\bash.exe --rcfile run_nios_bashrc
@echo on

