##############################################
##This function reads the transcript file provided and dumps messages on stdout
##############################################
proc display_msgs {transcript_file} {
	variable tscr_fpos
	if {[info procs post_sim_messages] != ""} {
		post_sim_messages $transcript_file
	} else {
		if [catch { open $transcript_file r } tr_file] {
			puts "Error: Can't find trancsript file $transcript_file."
			error "" "Can't open transcript file $transcript_file"
		} else {
			seek $tr_file $tscr_fpos
			while {1} {
				gets $tr_file line
				if { [eof $tr_file] == 0 } {
					puts "$line"
				} else {
					break
				}
			}
		}
		set tscr_fpos [tell $tr_file]
		close $tr_file
	}
}

proc parse_tool_messages {messages trns_fid} {
	foreach msg_line [split $messages \n] {
	    if {$msg_line != ""} {
		puts $trns_fid "Error: NcSim: $msg_line"
	    }
	}
}

proc compile_sdf {sdo_file tb_design_inst_name } {
    puts "Info: Compiling SDO file $sdo_file"
    if [catch {exec ncsdfc $sdo_file } result] {
	puts "Error: Compilation of design file $src was NOT successful"
	foreach msg_line [split $result \n] {
	    if {$msg_line != ""} {
		puts "NcSim: $msg_line"
	    }
	}
	set status 1
    } 
    #generate_sdf_command_file
    set sdo_cmd_file "sdf_cmd_file"
    set sdo_cmd_file_id [open $sdo_cmd_file w]
    puts $sdo_cmd_file_id "COMPILED_SDF_FILE = \"${sdo_file}.X\","
    puts $sdo_cmd_file_id "SCOPE = \"${tb_design_inst_name}\","
    puts $sdo_cmd_file_id "MTM_CONTROL = \"TYPICAL\","
    puts $sdo_cmd_file_id "SCALE_FACTORS = \"1.0:1.0:1.0\","
    puts $sdo_cmd_file_id "SCALE_TYPE = \"FROM_MTM\";"
    close $sdo_cmd_file_id
}

proc create_access_file {file_name} {
    set access_file_id [open $file_name w]
    puts $access_file_id "PATH ... +rwc"
    close $access_file_id
}

####################################################################
## Setup NcSim Environment
####################################################################
set transcript_file "ncsim_transcript"
variable ::env
variable tscr_fpos
set tscr_fpos 0
if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
	set env(CDS_INST_DIR) "$ncsim_path\\..\\.."
	set env(PATH) "$ncsim_path;\$env(PATH)"
} else {
	set env(CDS_INST_DIR) "$ncsim_path/../.."
	set env(PATH) "$ncsim_path:$env(PATH)"
}

# create cds.lib config file
if [file exists cds.lib] {
    file delete -force cds.lib
}

if [file exists hdl.var] {
    file delete -force hdl.var
}

if [file exists $transcript_file] {
    file delete -force $transcript_file
}


if {![file exists cds.lib] } {
    set cdslib [open "cds.lib" w+]
    puts $cdslib "SOFTINCLUDE \$\{CDS_INST_DIR\}/tools/inca/files/cdsvhdl.lib"
    close $cdslib
    puts "Info: Created cds.lib"
} else {
    puts "Info: cds.lib already exists"
}

# create hdl.var config file
if {![file exists hdl.var]} {
    set hdlvar_fid [open "hdl.var" w+]
    puts $hdlvar_fid "SOFTINCLUDE \$\{CDS_INST_DIR\}/tools/inca/files/hdlvlog.var"
    puts $hdlvar_fid "DEFINE LIB_MAP ( + => work )"
    puts $hdlvar_fid   "DEFINE NCSIMRC         ( \$\{CDS_INST_DIR\}/tools/inca/files/ncsimrc, \~/.ncsimrc )"
    puts $hdlvar_fid "DEFINE VERILOG_SUFFIX (.v, .vt, .vlg, .vo)"
    puts $hdlvar_fid "DEFINE VHDL_SUFFIX (.vhd, .vht, .vhdl, .vho)"
    close $hdlvar_fid
    puts "Info: Created hdl.var"
} else {
    puts "Info: hdl.var already exists"
}

####################################################################
##Compile Altera Simulation Models
####################################################################
set status [compile_altera_sim_models $transcript_file]

####################################################################
##Compile design files 
####################################################################
if {$status == 0} {
    display_msgs $transcript_file
    set status [compile_design_files $transcript_file]
}

####################################################################
##Compile testbench files
####################################################################
if {$status == 0} {
    display_msgs $transcript_file
    set status [compile_and_elaborate_testbench $transcript_file]
}

####################################################################
##Launch Simulation
####################################################################
if {$status == 0} {
    display_msgs $transcript_file
    set status [launch_simulation $transcript_file]
    display_msgs $transcript_file
}
