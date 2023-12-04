global env ;
vlib work

if [regexp {ModelSim ALTERA} [vsim -version]] {
    # Using Altera OEM Version need to add one more library mapping
    set altgxb_path $env(MODEL_TECH)\/../altera/verilog/altgxb ;
    set alt2gxb_path $env(MODEL_TECH)\/../altera/verilog/stratixiigx_hssi ;
    vmap altgxb_ver $altgxb_path ;
    vmap stratixiigx_hssi_ver $alt2gxb_path ;
} else {
    vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/220model.v 
    vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/sgate.v 
    vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/stratixgx_atoms.v 
    vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/stratixiigx_hssi_atoms.v 
    vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/stratixiigx_atoms.v 
    vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/stratixgx_mf.v 
    vlog $env(QUARTUS_ROOTDIR)/libraries/megafunctions/alt2gxb.v 
    vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_mf.v 
    vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/nopli.v +define+NO_PLI
}

vlog ../testbench/pattern_gen/*.v
vlog ../testbench/sdi_mc_build/hd_duplex.vo
vlog ../testbench/sdi_mc_build/hd_3g_duplex.vo
vlog ../testbench/tb_sdi_megacore_top.v
if [regexp {ModelSim ALTERA} [vsim -version]] {
    vsim -t ps -L altera_mf_ver -L lpm_ver -L -L sgate_ver -L altgxb_ver -L stratixiigx_hssi_ver -L work tb_sdi_megacore_top
} else {
    vsim -voptargs="+acc" work.tb_sdi_megacore_top -L work -do }

do wave.do
run -all
pause
