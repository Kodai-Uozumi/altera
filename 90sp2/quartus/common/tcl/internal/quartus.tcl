set ::quartus(exclude_old_timing_commands) 1
source [file join $quartus(tclpath) internal sys_pjc.tcl]
unset ::quartus(exclude_old_timing_commands)

source [file join $quartus(binpath) tcl_server.tcl]
source [file join $quartus(tclpath) internal prj_asd_import.tcl]

# Initialized the API for FX and EXP file import
source [file join $quartus(tclpath) internal prj_eda_board_import.tcl]

source [file join $quartus(tclpath) internal prj_conw.tcl]

# Initialize new packages (new API)
source [file join $quartus(tclpath) internal qtan_msg.tcl]
