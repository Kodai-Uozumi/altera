REM Change this next line to point to your ModelSim SE installation directory
set MODELSIM_DIR=c:\Modeltech_eval_6.0c

REM Use this path if using ModelSim SE
set PATH=%MODELSIM_DIR%\win32

REM Use this path if using ModelSim Altera Edition
REM set PATH=%MODELSIM_DIR%\win32aloem

REM Change this next line to point to your Quartus installation directory
set QUARTUS_ROOTDIR=c:\altera\81\quartus


vlib work
vmap work work


vlog %QUARTUS_ROOTDIR%\eda\sim_lib\220model.v 
vlog %QUARTUS_ROOTDIR%\eda\sim_lib\sgate.v 
vlog %QUARTUS_ROOTDIR%\eda\sim_lib\stratixgx_atoms.v 
vlog %QUARTUS_ROOTDIR%\eda\sim_lib\stratixiigx_hssi_atoms.v 
vlog %QUARTUS_ROOTDIR%\eda\sim_lib\stratixiigx_atoms.v 
vlog %QUARTUS_ROOTDIR%\eda\sim_lib\stratixgx_mf.v 
vlog %QUARTUS_ROOTDIR%\libraries\megafunctions\alt2gxb.v 
vlog %QUARTUS_ROOTDIR%\eda\sim_lib\altera_mf.v 
vlog %QUARTUS_ROOTDIR%\eda\sim_lib\nopli.v +define+NO_PLI


vlog ../testbench/pattern_gen/*.v
vlog ../testbench/sdi_mc_build/hd_dual_duplex.vo
vlog ../testbench/tb_sdi_megacore_top.v

vsim -voptargs="+acc" work.tb_sdi_megacore_top -L work -do "do wave.do; run -all"

pause
