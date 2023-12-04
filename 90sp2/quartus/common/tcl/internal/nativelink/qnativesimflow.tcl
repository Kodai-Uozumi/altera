# ***************************************************************
# ***************************************************************
#
# File:         qnativesimflow.tcl
# Description:  Quartus NativeLink Simulation flow
#               This script is used by Quartus to launch eda
#               simulation tools.
#
# Version:      1.0
#
# Authors:      Altera Corporation
#
#               Copyright (c)  Altera Corporation 2003 - .
#               All rights reserved.
#
# ***************************************************************
# *************************************************************** 

# All quartus related variables have prefix "q_"
# All EDA simulation tool related variables have prefix "s_"
# All globals in CAPS

package require ::quartus::sim_lib_info

# Global variables


# Global procedures

# Root namespace

namespace eval ::quartus::nativelinkflow::sim {


# Error codes

    variable ERROR_UNKNOWN_NETLIST_TYPE    5

# Error code messages

    variable ERROR_UNKNOWN_NETLIST_TYPE_STRING    "Error: Unknown EDA simulation netlist type"

# Other error/info messages

    variable ERROR_INIT_SIM_SETTINGS     "Error: Initialization of EDA simulation settings was NOT successful"
    variable ERROR_SOURCE_NL_SCRIPT      "Error: Sourcing NativeLink script"
    variable ERROR_ABSENT_NL_SCRIPT      "Error: Can't find NativeLink simulation tool script "
    variable ERROR_ABSENT_SIM_DIR        "Error: Can't find simulation directory "
    variable ERROR_OUTPUT_NETLISTER_NOT_RUN        "Error: Simulation output netlist writer for EDA simulation tool not run"
    variable ERROR_NL_FOR_SIMTOOL_NOT_SUPPORTED  "Error: NativeLink simulation flow not supported for current EDA simulation tool"

# Info  messages

    variable INFO_INIT_SIM_SETTINGS_SUCCESS     "Info: Initialization of EDA simulation settings was successful "
    variable INFO_END_SIM_TOOL_LAUNCH           "Info: Ending launching of EDA simulation tool"

    namespace export run_eda_simulation_tool ERROR* INFO*

    variable q_sim_tool        ""
    variable q_sim_lang        ""
    variable q_sim_output_file ""
    variable q_sim_sdf_file    ""
    variable q_sim_dir         ""
    variable q_vhd_version

    # if this variable is set, it means the script is called by qeda
    variable q_called_from_qeda 0

    # qsf values passed in via command-line when called from qeda. These should override the qsf entries read from qsf file
    variable q_qsf_sim_tool ""
    variable q_qsf_is_functional ""
    variable q_qsf_user_compiled_directory ""
    variable q_qsf_netlist_output_directory ""

    proc set_q_sim_environ       {} {}
    proc run_simulator           {} {}

    proc run_sim {} {}
    proc get_sim_tool_name {} {}
    proc get_sim_models {} {}
    namespace export is_top_level_entity_writing_disabled
    namespace export get_sim_models_for_design
    namespace export get_sim_models_for_tb
    proc get_sim_models_for_tb_old {} {}
    namespace export get_design_files
    namespace export get_testbench_info
    namespace export get_testbench_mode	
    namespace export get_testbench_file
    namespace export get_testbench_name
    namespace export get_testbench_run_for
    namespace export get_design_instance_name
    namespace export get_command_script	
    namespace export is_vcd_generation_enabled
    namespace export is_glitch_filter_enabled
    namespace export goto_sim_dir	
    namespace export get_sim_dir	
    namespace export get_eda_writer_netlist_ext	
    namespace export launch_modelsim
    namespace export launch_modelsim_verilog
    namespace export launch_modelsim_vhdl
    namespace export launch_ncsim
    namespace export launch_vcs
    namespace export launch_vcsmx
    namespace export get_ip_info
    namespace export get_unencrypted_hdl_files
    namespace export qmap_successfully_completed
    namespace export backup_file
    namespace export get_file_type
    namespace export is_timing_simulation_on
    namespace export get_global_hdl_version
}

############################################################################
##
proc ::quartus::nativelinkflow::sim::get_global_hdl_version {lang rtl_sim} {
##
############################################################################
    set global_setting_variable ""
    set global_setting ""
    if {$lang == "verilog"} {
	set global_setting_variable "VERILOG_INPUT_VERSION"
	set global_setting_default "Verilog_2001"
    } else {
	set global_setting_variable "VHDL_INPUT_VERSION"
	set global_setting_default "VHDL93"
    }
    set global_setting [get_global_assignment -name $global_setting_variable]
    if {($global_setting == "") || ($rtl_sim == 0)} {
	set global_setting $global_setting_default
    }
    return $global_setting
}

############################################################################
##
proc ::quartus::nativelinkflow::sim::is_top_level_entity_writing_disabled {} {
##
############################################################################
    set enabled 0
    set value [get_global_assignment -name EDA_WRITER_DONT_WRITE_TOP_ENTITY -section_id eda_simulation]
    if {[string compare -nocase $value "OFF"] != 0} {
	set enabled 1
    }
    return $enabled
}

############################################################################
##
proc ::quartus::nativelinkflow::sim::get_file_type {filename} {
##
############################################################################
    set verilog_ext ".v .vh .vlg .vo .vt .sv"
    set vhdl_ext ".vhd .vhdl .vht .vho"
    set type "unknown"

    set ext [string tolower [file extension $filename]]
    if {[lsearch -exact $verilog_ext $ext] != -1} {
	set type "verilog"
    } elseif {[lsearch -exact $vhdl_ext $ext] != -1} {
	set type "vhdl"
    }
    return $type
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_sim_models_for_tb_old {library} {
##
#######################################################################
    set lib_files ""
    set lib_path [get_sim_models_root_path]
    set verilog_version [get_global_hdl_version "verilog" 1]
    set vhdl_version [get_global_hdl_version "vhdl" 1]

    array set lib_map { 
	altera_ver {{altera_primitives.v $verilog_version}}
	altera {{altera_primitives_components.vhd $vhdl_version} {altera_primitives.vhd $vhdl_version}}
	altera_mf_ver {{altera_mf.v $verilog_version}}
	altera_mf {{altera_mf_components.vhd  $vhdl_version} {altera_mf.vhd $vhdl_version}}
	altgxb_ver {{stratixgx_mf.v $verilog_version}}
	altgxb {{stratixgx_mf.vhd $vhdl_version} {stratixgx_mf_components.vhd $vhdl_version}}
	lpm_ver {{220model.v $verilog_version}}
	lpm {{220pack.vhd $vhdl_version} {220model.vhd $vhdl_version}}
	sgate_ver {{sgate.v $verilog_version}}
	sgate {{sgate_pack.vhd $vhdl_version} {sgate.vhd $vhdl_version}}
	stratixgx_gxb_ver {{stratixgx_hssi_atoms.v $verilog_version}}
	stratixgx_gxb {{stratixgx_hssi_atoms.vhd $vhdl_version} {stratixgx_hssi_components.vhd $vhdl_version}}
	stratixiigx_hssi_ver {{stratixiigx_hssi_atoms.v $verilog_version}}
	stratixiigx_hssi {{stratixiigx_hssi_components.vhd $vhdl_version} {stratixiigx_hssi_atoms.vhd $vhdl_version}}
	stratixiv_hssi_ver {{stratixiv_hssi_atoms.v $verilog_version}}
	stratixiv_pcie_hip_ver {{stratixiv_pcie_hip_atoms.v $verilog_version}}
	stratixiv_hssi {{stratixiv_hssi_components.vhd $vhdl_version} {stratixiv_hssi_atoms.vhd $vhdl_version}}
	stratixiv_pcie_hip {{stratixiv_pcie_hip_components.vhd $vhdl_version} {stratixiv_pcie_hip_atoms.vhd $vhdl_version}}
    }
    array set prerequisite_lib_map {
	    altgxb_ver {lpm_ver sgate_ver}
	    altgxb {lpm sgate}
	    sgate_ver {lpm_ver}
	    sgate {lpm}
	    stratixgx_gxb_ver {lpm_ver sgate_ver}
	    stratixgx_gxb {lpm sgate}
	    stratixiigx_hssi_ver {lpm_ver sgate_ver}
	    stratixiigx_hssi {lpm sgate}
	    stratixiv_hssi_ver {lpm_ver sgate_ver}
	    stratixiv_pcie_hip_ver {lpm_ver sgate_ver altera_mf_ver}
	    stratixiv_hssi {lpm sgate}
	    stratixiv_pcie_hip {lpm sgate altera_mf}
    }
    #Library can be either special library - such as sgate, lpm etc 
    #or library corresponding to device family. 
    #The special libraries are listed in array lib_map
    if {[array names lib_map $library] == ""} {
	#The library corresponds to device family. 
	#Verilog libraries have suffix _ver
	if [regexp {([a-z]+)_ver$} $library match family] {	
	    lappend lib_files "\{$library\} \{\{$lib_path/$family\_atoms.v\ $verilog_version\}\}"
	} else {
	    lappend lib_files "\{$library\} \{\{$lib_path/$library\_atoms.vhd $vhdl_version\} \{$lib_path/$library\_components.vhd $vhdl_version\}\}"
	}
    } else {
	foreach required_lib $prerequisite_lib_map($library) {
		set lib_model_files ""
		foreach model_file $lib_map($required_lib) {
		    lappend lib_model_files "$lib_path/$model_file"
		}
		lappend lib_files "\{$required_lib\} \{$lib_model_files\}"
	}
	set lib_model_files ""
	foreach model_file $lib_map($library) {
	    lappend lib_model_files "$lib_path/$model_file"
	}
	lappend lib_files "\{$library\} \{$lib_model_files\}"
    }
    return $lib_files
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_sim_models_for_design {language rtl_sim} {
##
#######################################################################
	set family [ get_sim_nativelink_family ]
	
	set sim_models [get_sim_models $family $language $rtl_sim]

	if {$rtl_sim} {
		set extra_lib_list ""
		set extra_lib_asgn [get_all_assignments -name EDA_DESIGN_EXTRA_ALTERA_SIM_LIB -section_id eda_simulation -type global]
		foreach_in_collection asgn_id $extra_lib_asgn {
			set extra_lib [string tolower [get_assignment_info $asgn_id -value]]
			set extra_libs [get_sim_models_for_tb $extra_lib]
	
			foreach lib_info $extra_libs {
				lappend sim_models $lib_info
		    }
		}
	}
	return $sim_models
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_sim_models_for_tb {library} {
##
#######################################################################
	if { [regexp -nocase {^(max|flex)} $library ] } {

		set lib_files [get_sim_models_for_tb_old $library]
	} else {
# temp fix for spr 280341
    if { [regexp {_ver$} $library] } {
			set hdl_version [get_global_hdl_version "verilog" 1]
	 } else {
			set hdl_version [get_global_hdl_version "vhdl" 1]
	 }
	 set lib_files [::quartus::sim_lib_info::get_sim_models_for_library $library $hdl_version]
	}

    return $lib_files
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_sim_models {family language rtl_sim} {
##
#######################################################################
    set files_list ""
    set lib_path [get_sim_models_root_path]
    set hdl_version [get_global_hdl_version $language $rtl_sim]
	 set files_list [::quartus::sim_lib_info::get_sim_models_for_family $family $language $rtl_sim $hdl_version]

    return $files_list
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_design_files {language rtl_sim netlist_file} {
##
##
#######################################################################
    variable ::quartus
    set design_files_list ""
    set europa_included 0
    if {$rtl_sim =="1"} {
        #Since RTL may contain both VHDL and Verilog design files, 
	#we would ignore the language.
	set file_list [get_unencrypted_hdl_files "mixed"]
	set ignored_files ""
	set non_ip_files ""
	foreach file $file_list {
	    if {[lsearch -exact $ignored_files $file] == -1} {
		set full_file_name [get_file_info -info full_path -filename $file]
		array set list [get_ip_info $full_file_name]
		if {([array names list related_files] != "" ) && ($list(related_files) != "")} {
		    # All related_files to ignored_files list
		    set ignored_files "$ignored_files [split $list(related_files) ,]"
		}
		if {([array names list ipfs_file] != "" ) && ($list(ipfs_file) != "")} {
		    set ipfs_files_list $list(ipfs_file)
		    set path [file dirname $full_file_name]
		    set asgn_col [get_all_assignments -name EDA_IPFS_FILE -section_id eda_simulation -type global]
		    foreach_in_collection asgn_id $asgn_col {
			set asgn_ipfs_file [get_assignment_info $asgn_id -value] 
			set idx [lsearch $asgn_ipfs_file $ipfs_files_list] 
			if {$idx != -1 } {
			    set library [get_assignment_info $asgn_id -library]
			    if {$library == ""}  {
				set library "work"
			    }
			    set hdl_version [get_assignment_info $asgn_id -hdl_version]
			    if {$hdl_version == ""} {
				set hdl_version [get_global_hdl_version [get_file_type $asgn_ipfs_file] $rtl_sim]
			    }
			    lappend design_files_list "\{$library\} \{\{\"${path}/$asgn_ipfs_file\" $hdl_version\}\}"
			    set ipfs_files_list [lreplace $ipfs_files_list $idx $idx]
			}
		    }
		    if {([get_file_type $file] == "vhdl") && ($europa_included == 0)} {
			    lappend design_files_list "\{altera\} \{\{\"$quartus(binpath)\../libraries/vhdl/altera/altera_europa_support_lib.vhd\" \{VHDL93\}\}\}"
			    set europa_included 1
		    }
		    foreach ipfs_file $ipfs_files_list {
			set library "work"
			lappend design_files_list "\{$library\} \{\{\"${path}/$ipfs_file\" \{\}\}\}"
		    }
		    if {[lsearch -exact $ignored_files $file] == -1} {
			    set library [get_file_info -filename $full_file_name -info library]
			    if {$library == ""}  {
				set library "work"
			    }
			    set hdl_version [get_file_info -filename $full_file_name -info hdl_version]
			    if {$hdl_version == ""} {
				set hdl_version [get_global_hdl_version [get_file_type $file] $rtl_sim]
			    }
			    lappend design_files_list "\{$library\} \{\{\"$full_file_name\" $hdl_version\}\}"
		    }
		} else {
		    lappend non_ip_files $file
		}
		array unset list
	    }
	}
	foreach non_ip_file $non_ip_files {
	    set full_file_name [get_file_info -filename $non_ip_file -info full_path]
	    if {[lsearch -exact $ignored_files $non_ip_file] == -1} {
		set library [get_file_info -filename $full_file_name -info library]
		if {$library == ""}  {
		    set library "work"
		}
		set hdl_version [get_file_info -filename $full_file_name -info hdl_version]
	        if {$hdl_version == ""} {
					if { [regexp {\.sv$} $full_file_name] } {
						set hdl_version "SystemVerilog_2005"
 					} else {
		    	set hdl_version [get_global_hdl_version [get_file_type $non_ip_file] $rtl_sim]
				}
		}
		lappend design_files_list "\{$library\} \{\{\"$full_file_name\" $hdl_version\}\}"
	    }
	}
	unset non_ip_files
    } else {
	set hdl_version "Verilog_2001"
	switch -regexp -- $language {
	    (?i)^verilog$ 
	    {
		set ext "vo";
		set hdl_version "Verilog_2001"
	    }
	    (?i)^vhdl$ 
	    {
		set ext "vho";
		set hdl_version "VHDL93"
	    }
	}
	set cap [get_project_settings -cmp]
	if { $netlist_file == "" } {
	  lappend design_files_list "\{work\} \{\{${cap}.${ext} \{$hdl_version\}\}\}"
   } else {
	  lappend design_files_list "\{work\} \{ \{$netlist_file \{$hdl_version\}\}\}"
   }
   }
    return $design_files_list
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_testbench_info {{ignore_libs false}} {
##
#######################################################################
    set testbench_info ""
    set library ""
    set tb_lib_list ""
    #The sim_mode is not used - the significance of assignments has changed.
    set testbench [get_global_assignment -name EDA_NATIVELINK_SIMULATION_TEST_BENCH -section_id eda_simulation]
    if {$testbench == ""} {
	return $testbench_info
    }
    #lappend testbench_info [get_global_assignment -name EDA_TEST_BENCH_MODULE_NAME -section_id $testbench]
    lappend testbench_info [get_global_assignment -name EDA_DESIGN_INSTANCE_NAME -section_id $testbench]
    lappend testbench_info [get_global_assignment -name EDA_TEST_BENCH_RUN_SIM_FOR -section_id $testbench]
    lappend testbench_info [get_global_assignment -name EDA_TEST_BENCH_GATE_LEVEL_NETLIST_LIBRARY -section_id $testbench]

    #Get Altera Sim libraries required by test bench
    lappend tb_lib_col [get_all_assignments -name EDA_TEST_BENCH_EXTRA_ALTERA_SIM_LIB -section_id $testbench -type global]
    foreach_in_collection asgn_id $tb_lib_col {
	lappend tb_lib_list [string tolower [get_assignment_info $asgn_id -value]]
    }

    lappend testbench_info $tb_lib_list

    set tb_files ""
    set tb_file ""
    set tb_files_col [get_all_assignments -name EDA_TEST_BENCH_FILE -section_id $testbench -type global]
    foreach_in_collection asgn_id $tb_files_col {
	set library [get_assignment_info $asgn_id -library]
        #default library is work
	if {$library == ""}  {
	    set library "work"
	}
	set hdl_version [get_assignment_info $asgn_id -hdl_version]
	
	#if the testbench file has no path then use the project path.
	set tb_file [ convert_filepath_to_tclstyle [get_assignment_info $asgn_id -value]]

	if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
	    if ![regexp -nocase {^[a-z]\:/} $tb_file] {
		set tb_file "[get_project_directory]$tb_file"
	    }
	} else {
	    if {![regexp {^/} $tb_file]} {
		set tb_file "[get_project_directory]$tb_file"
	    }
	}
	lappend tb_files "\{$library\} \{\{\"$tb_file\" $hdl_version\}\}"
    }
    lappend testbench_info $tb_files

    set tb_script [get_global_assignment -name EDA_NATIVELINK_SIMULATION_SETUP_SCRIPT -section_id eda_simulation]
    if {$tb_script != "" } {
	if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
	    if ![regexp -nocase {^[a-z]\:/} $tb_script] {
		set tb_script "[get_project_directory]$tb_script"
	    }
	} else {
	    if {![regexp {^/} $tb_script]} {
		set tb_script "[get_project_directory]$tb_script"
	    }
	}
    }
    lappend testbench_info $tb_script

    set tb_top [get_global_assignment -name EDA_TEST_BENCH_MODULE_NAME -section_id $testbench]
    if {$ignore_libs == "false"} {
	    if {$library != "work"} {
		   set tb_info [split $tb_top .]
		   if {[llength $tb_info] == 2} {
			   set tb_library [lindex $tb_info 0]
			   if {$tb_library != $library} {
			       nl_postmsg warning "Test bench entity name $tb_top does not match library $library specified for top level test bench file $tb_file"
			   }
		   }  else {
			   set tb_top "${library}.${tb_top}" 
		   }
	   }
    }
    set testbench_info [linsert $testbench_info 0 $tb_top]
    return $testbench_info
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::backup_file {filename} {
##
#######################################################################
	#if current filename is <name>.bak<num> then backup file is called
	# <name>.bak<num++>, otherwise backbup file is called <name>.bak
    if [file exists $filename] {
	set bkp_file_name "$filename.bak"
	if ![file exists $bkp_file_name] {
	    set bkp_file_name ${filename}.bak
	} else {
	    for {set bkp_idx 1 } {$bkp_idx <= 10 } {incr bkp_idx} {
		if ![file exists ${bkp_file_name}$bkp_idx] {
		    break
		}
	    }  
	    set bkp_file_name ${bkp_file_name}$bkp_idx
	}
	file copy -force $filename $bkp_file_name
	nl_postmsg warning "Warning: File $filename already exists - backing up current file as $bkp_file_name"
    }
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::qmap_successfully_completed {} {
##
#######################################################################
    package require ::quartus::report
    set return_val 1
    set cmp_status ""

    if [catch {load_report}] {
	set return_val 0
    } else {
	set panel_id [get_report_panel_id {Analysis & Synthesis||Analysis & Synthesis Summary}]
	if {$panel_id != -1} {
	    set cmp_status [get_report_panel_data -row 0 -col 1 -id $panel_id]
	} else {
	    set panel_id [get_report_panel_id {Analysis & Elaboration||Analysis & Elaboration Summary}]
	    if {$panel_id != -1} {
		set cmp_status [get_report_panel_data -row 0 -col 1 -id $panel_id]
	    } else {
		#Failed
		set return_val 0
	    }
	}
	unload_report
    }
    if {$return_val != 0} {
	#check if cmp_status is "Failed - ..." if so set return_val to 0
	if ![regexp "^Successful - (.)*" $cmp_status] {
	    set return_val 0
	}
    }
    return $return_val
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_unencrypted_hdl_files {language} {
##
#######################################################################
	set file_list ""
	set unencrypted_compiled_file_list ""
	variable ::quartus
	#HDL files in <qinstall>/libraries/megafunctions should be ignored
	set quartus_mega_lib_path "[file dirname $quartus(binpath)]"
	set quartus_mega_lib_path "[file join $quartus_mega_lib_path libraries]"
	set quartus_mega_lib_path "[file join $quartus_mega_lib_path megafunctions]"
	switch -regexp -- $language {
		(?i)^verilog$
		{
		    set file_list [get_files -type verilog]
		    set sv_file_list [get_files -type systemverilog]

			 if { [llength $sv_file_list] > 0 } {
		   	set file_list [concat $file_list $sv_file_list]
		 	}

		}
		(?i)^vhdl$
		{
			set file_list [get_files -type vhdl]
		}
		(?i)^mixed$
		{
			set file_list [get_files -type verilog]
		   set sv_file_list [get_files -type systemverilog]
			if { [llength $sv_file_list] > 0 } {
		   	set file_list [concat $file_list $sv_file_list]
			}
			set vhdl_file_list [get_files -type vhdl]

			if {$vhdl_file_list != ""} {
				if {$file_list != ""} {
					set file_list [concat $file_list "$vhdl_file_list"]
				} else {
					set file_list "$vhdl_file_list"
				}
			}
			set mif_file_list [get_files -filter "*.mif"]
			if {$mif_file_list != ""} {
				if {$file_list != ""} {
					set file_list [concat $file_list "$mif_file_list"]
				} else {
					set file_list "$mif_file_list"
				}
			}
			set hex_file_list [get_files -filter "*.hex"]
			if {$hex_file_list != ""} {
				if {$file_list != ""} {
					set file_list [concat $file_list "$hex_file_list"]
				} else {
					set file_list "$hex_file_list"
				}
			}
		}
	}

	
	foreach file $file_list {
		set full_file_name [get_file_info -filename $file -info full_path]
		set file_path [file dirname $full_file_name]
		if {$file_path != $quartus_mega_lib_path} {
			if [get_file_info -filename $full_file_name -info compiled_status] {
				if {!([get_file_info -info is_encrypted -filename $full_file_name] \
					|| [get_file_info -info encrypted_submodule_file -filename $file]) } {
					lappend unencrypted_compiled_file_list $file
				}
			}
		}
	}
	return $unencrypted_compiled_file_list
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_ip_info {filename} {
##
#######################################################################
    set ip_file 0
    set mega_wiz_file 0
    set related_files ""
    set ipfs_files ""
    set return_val ""
    set related_files ""
    set ipfs_files ""

    if {[get_file_type $filename] eq "vhdl"} {
	set comment "--"
    } else {
	set comment "//"
    }
    if [ catch { open $filename r} file_id ] {
	nl_postmsg error "Error : Can't open file -- $filename"
    }
    while  {![eof $file_id ]} {
	#Check to see if this is IP file.
	#IP files will have first 2 lines as follows
	# //megafunciton  wizard: ...
	# //GENERATION: XML
	#Skip empty lines
	set line [gets $file_id]
	if [regexp "^( 	)*$" $line] {
	    continue
	}
	#If the first non-empty line is a megafunction line, this is either 
	#an IP file or megafunction file. The IP files will
        #have GENERATION: XML as following line
	if [regexp -nocase "^${comment} megafunction wizard\: \%(.*)\%" $line] {
	    set line [gets $file_id]
	    if [regexp "^${comment} GENERATION\: XML" $line] {
		set ip_file 1
		break
	    } elseif [regexp -nocase "^${comment} GENERATION ?\: ?STANDARD" $line] {
		set mega_wiz_file 1
	    break
	    } 
	} elseif [regexp -nocase "^${comment}( )?Generated by (.+)Altera, IP Toolbench (.+)" $line ] {
	    set ip_file 1
	    break
	}
    }

    if {($mega_wiz_file == "1") || ($ip_file == "1")} {
	#if this was an IP file then look for related files.
	# and ipfs files information
	while  {![eof $file_id ]} {
	    set line [gets $file_id]
	    if [regexp -nocase "^${comment} ?RELATED_FILES ?\: ?(\[^;\]*)(;)?" $line junk file_list] {
		regsub -all " " $file_list {} file_list
		lappend related_files $file_list
	    } elseif [regexp -nocase "^${comment} ?IPFS_FILES ?\: ?(\[^;\]*)(;)?" $line junk file_list] {
		regsub -all " " $file_list {} file_list
                set file_list [split $file_list ,]
		foreach file $file_list {
			lappend ipfs_files $file
		}
	    } else {
		continue
	    }
	}
	lappend return_val "related_files"
	lappend return_val $related_files
	lappend return_val "ipfs_file"
	lappend return_val $ipfs_files
    }

    if {($ip_file == "1") && ($related_files == "") && ($ipfs_files == "")} {

	post_message -type error "Error: Can't perform simulation of IP file $filename because no simulation model files were detected" -file $filename
	nl_postmsg error "Error: You did not generate the simulation model files or you generated the IP file using an older version of MegaCore which is not supported by RTL NativeLink Simulation" 
	nl_postmsg error "Error: Regenerate the IP and simulation model files using the latest version of MegaCore for RTL NativeLink Simulation flow to function correctly"
	error "" "Regenerate the IP and simulation model files using the latest version of MegaCore for RTL NativeLink Simulation flow to function correctly" 
    }

    if [ catch {close $file_id} err ] {
	set savedCode $errorCode
	set savedInfo $errorInfo
	error "" $savedInfo $savedCode
    }
    
    return $return_val
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_testbench_mode {sim_mode} {
##
#######################################################################
    set mode "none"
    set sim_mode "gate"
    if {[string compare -nocase $sim_mode "gate"] == 0} {
	set qsf_asgn_name EDA_TEST_BENCH_ENABLE_STATUS
    } else {
	set qsf_asgn_name EDA_RTL_SIM_MODE
    }
    set mode [lindex [ get_global_assignment -name $qsf_asgn_name -section_id eda_simulation ] 0]

    if {[string compare -nocase $mode "NOT_USED"] == 0} {
	set mode "none"
    } elseif {[string compare -nocase $mode "TEST_BENCH_MODE"] == 0} {
	set mode "testbench"
    } elseif {[string compare -nocase $mode "COMMAND_MACRO_MODE"] == 0}  {
    	set mode "script"
    }
    return $mode
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_testbench_file {sim_mode} {
##
#######################################################################
    namespace import ::quartus::nativelinkflow::convert_filepath_to_tclstyle
    if {[string compare -nocase $sim_mode "gate"] == 0} {
	set qsf_asgn_name EDA_TEST_BENCH_FILE_NAME
    } else {
	set qsf_asgn_name EDA_RTL_TEST_BENCH_FILE_NAME
    }
    set tb_file_name [ lindex [ get_global_assignment -name $qsf_asgn_name -section_id eda_simulation ] 0]
    
    #if the testbench file has no path then use the project path.
    set tb_file_name [ convert_filepath_to_tclstyle $tb_file_name ]

    if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
	if ![regexp -nocase {^[a-z]\:/} $tb_file_name] {
	    set tb_file_name "../../$tb_file_name"
	}
    } else {
	if {![regexp {^/} $tb_file_name]} {
	    set tb_file_name "../../$tb_file_name"
	}
    }

    return $tb_file_name
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_testbench_name {sim_mode} {
##
#######################################################################
    if {[string compare -nocase $sim_mode "gate"] == 0} {
	set qsf_asgn_name EDA_TEST_BENCH_ENTITY_MODULE_NAME
    } else {
	set qsf_asgn_name EDA_RTL_TEST_BENCH_NAME
    }
    set tb_name [ lindex [ get_global_assignment -name $qsf_asgn_name -section_id eda_simulation ] 0]
    return $tb_name
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_testbench_run_for {sim_mode} {
##
#######################################################################
    set run_for "-all"

    if {[string compare -nocase $sim_mode "gate"] == 0} {
	set qsf_asgn_name EDA_TEST_BENCH_RUN_FOR
    } else {
	set qsf_asgn_name EDA_RTL_TEST_BENCH_RUN_FOR
    }

    set run_for [get_global_assignment -name $qsf_asgn_name -section_id eda_simulation]
    if {[string compare $run_for  ""] == 0} {
	set run_for "-all"
    } else {
	regsub -all " " $run_for {} run_for 
    }
     return [string tolower $run_for]
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_design_instance_name {sim_mode} {
    #Sim mode will always be gate level?
##
#######################################################################
     set dsgn_inst_name [ lindex [ get_global_assignment -name {EDA_TEST_BENCH_DESIGN_INSTANCE_NAME} -section_id eda_simulation ] 0]
     return $dsgn_inst_name
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_command_script {sim_mode} {
##
#######################################################################
    if {[string compare -nocase $sim_mode "gate"] == 0} {
	set qsf_asgn_name EDA_SIMULATION_RUN_SCRIPT
    } else {
	set qsf_asgn_name EDA_RTL_SIMULATION_RUN_SCRIPT
    }

    set script_file_name [ lindex [ get_global_assignment -name $qsf_asgn_name -section_id eda_simulation ] 0]	

    set script_file_name [ convert_filepath_to_tclstyle $script_file_name ]

    if { [string compare -nocase $::tcl_platform(platform) "windows"] == 0} {
	if ![regexp -nocase {^[a-z]\:/} $script_file_name] {
	    set script_file_name "[get_project_directory]$script_file_name"
	}
    } else {
	if {![regexp {^/} $script_file_name]} {
	    set script_file_name "[get_project_directory]$script_file_name"
	}
    }
    return $script_file_name
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::is_vcd_generation_enabled {} {
##
#######################################################################
    return [is_setting_enabled vcd_gen]
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::is_glitch_filter_enabled {} {
##
#######################################################################
    return [is_setting_enabled glitch_filter]
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::is_setting_enabled {setting} {
##
#######################################################################
    set enabled 0
    variable	setting_name_to_qsf {
		    {{glitch_filter} {EDA_ENABLE_GLITCH_FILTERING}}
		    {{vcd_gen} {EDA_WRITE_NODES_FOR_POWER_ESTIMATION}}
		}

    foreach item $setting_name_to_qsf {
	set old_name [lindex $item 0]
	if {[string compare -nocase $old_name $setting ] == 0} {
	    set value [ get_global_assignment -name [lindex $item 1] -section_id eda_simulation ]
	    if {[string compare -nocase $value "OFF"] != 0} {
		set enabled 1
	    }
	    break
	}
    }
    return $enabled
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_sim_dir {tool_name} { 
##
#######################################################################
variable q_qsf_netlist_output_directory
    	array set tool_dir_map   {
			modelsim	        modelsim 
			modelsim-altera 	modelsim 
			vcs		vcs
			ncsim		ncsim
			vcs_mx		scsim 
 			active-hdl       activehdl
			riviera-pro       rivierapro
	}
	set default_output_dir "[get_project_directory]simulation/$tool_dir_map($tool_name)"
	if { $q_qsf_netlist_output_directory == "" } {
		set eda_sim_writer_output_dir [get_global_assignment -name EDA_NETLIST_WRITER_OUTPUT_DIR -section_id eda_simulation]
	} else {
		set eda_sim_writer_output_dir $q_qsf_netlist_output_directory
	}

	if {$eda_sim_writer_output_dir == ""} {
		set eda_sim_writer_output_dir "$default_output_dir"
	}

	return $eda_sim_writer_output_dir
}

#######################################################################
##
##
proc ::quartus::nativelinkflow::sim::goto_sim_dir {tool_name} {
##
##
#######################################################################
    set return_val 0
    set path_dirs "simulation"

    array set tool_dir_map   {
       modelsim	        modelsim 
       modelsim-altera 	modelsim 
       vcs		vcs
       ncsim		ncsim
       scsim		scsim 
    }

    set sim_dir [get_sim_dir $tool_name]
    if [file exists $sim_dir] {
	if [catch {cd $sim_dir} err] {
	    nl_postmsg error "Error: $err"
	    set return_val 1
	    break
	}
    } else {
	if [catch {file mkdir $sim_dir } err ] {
	    nl_postmsg error "Error: Can't create directory [pwd]/$sim_dir"
	    set return_val 1
	} else {
	    if [catch {cd $sim_dir} err] {
		nl_postmsg error "Error: $err"
		set return_val 1
		break
	    }
	}
    }
    return $return_val
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_eda_writer_netlist_ext {language} {
##
#######################################################################
    set ext "vo"
    if {$language == "vhdl" } {
	set ext "vho"
    } 
    return $ext
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_eda_writer_sdf_ext {language} {
##
#######################################################################
    set ext "_verilog.sdo"
    if {$language == "vhdl" } {
	set ext "_vhdl.sdo"
    } 
    return $ext
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_sim_tool_name {} {
##
#######################################################################
variable q_qsf_sim_tool

    array set tool_map   {
       modelsim		modelsim 
       modelsim-altera	modelsim-altera 
       vcs		vcs
       nc-verilog	ncsim
       nc-vhdl		ncsim
       {vcs mx}		vcs_mx 
       active-hdl	active-hdl
       riviera-pro	riviera-pro
    }
    
    if { $q_qsf_sim_tool == "" } {
    	set qsf_tool_name [ get_global_assignment -name {EDA_SIMULATION_TOOL} ] 
    } else {
    	set qsf_tool_name $q_qsf_sim_tool
    }

    #QSF allows short versions of Tool names. 
    #First convert these to standard lowercase names
    set standard_tool_name [convert_to_standard_name $qsf_tool_name]
    set standard_tool_name [string tolower $standard_tool_name]

    #remove everything in braces (), i.e tool names 
    # ModelSim(Verilog) will become modelsim
    if ![regexp -nocase {([^(]+) \(([a-z ]+)\)} $standard_tool_name full_match tool_name language] {
	set tool_name $standard_tool_name
    }

    if {[array names tool_map $tool_name] == "" }  {
	set sim_tool ""
    } else {
	set sim_tool $tool_map($tool_name)
    }
    return $sim_tool
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::set_q_sim_environ {} {
##
#######################################################################

    variable q_qsf_sim_tool

    set verilog_lang_str "verilog"
    set vhdl_lang_str "vhdl"

    variable q_sim_lang
    variable q_sim_tool
    variable q_sim_output_file
    variable q_sim_sdf_file
    variable q_vhd_version
    variable q_sim_dir

    set rev_name [get_project_settings -cmp]
    set q_sim_tool [get_sim_tool_name]

    array set tool_dir_map   {
       modelsim	        modelsim 
       modelsim-altera 	modelsim 
       vcs		vcs
       ncsim		ncsim
       vcs_mx		scsim 
       active-hdl	activehdl 
       riviera-pro	rivierapro 
    }


    if { [string compare -nocase $::tcl_platform(platform) "windows"] != 0} {
	set q_sim_dir "simulation/$tool_dir_map($q_sim_tool)"
    } else {	
	set q_sim_dir "simulation\\$tool_dir_map($q_sim_tool)"
    }

    set q_vhd_version "OFF"
    
    if {[string compare $q_sim_tool "<None>"]} { 
     if {[string compare $q_qsf_sim_tool  ""]} {
       # get the language (verilog or vhdl) from the full tool name passed in.

       # first translate the full tool name to standard name
       set standard_tool_name [convert_to_standard_name $q_qsf_sim_tool]
       
       # all full tool names except for vcs include language string in their name
       if { [regexp -nocase verilog $standard_tool_name] } {
         set q_sim_lang $verilog_lang_str
       } elseif { [regexp -nocase vhdl $standard_tool_name] } {
         set q_sim_lang $vhdl_lang_str
       } else {
         # vcs is a verilog-only simulator, so its full tool name doesn't include language str like other tool names
         if { [regexp -nocase vcs $standard_tool_name] } {
           set q_sim_lang $verilog_lang_str
         }
       }
     } else {
	    set q_sim_lang [ string tolower [lindex [ get_global_assignment -name {EDA_OUTPUT_DATA_FORMAT} -section_id eda_simulation ] 0 ] ]
     }
	set q_sim_output_file "${rev_name}\.[get_eda_writer_netlist_ext $q_sim_lang]" 
	set q_sim_sdf_file    "$rev_name\_[get_eda_writer_sdf_ext $q_sim_lang]"
	#return -code $ERROR_UNKNOWN_NETLIST_TYPE
    }
    return;
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::get_sim_nativelink_family { } {
##
#######################################################################

	set quartus_family_qsf [get_dstr_string -family [get_global_assignment -name FAMILY]]

	## remove space from family name
	regsub -all {[ ]+} $quartus_family_qsf {} quartus_family_no_spaces

   set family_name [string tolower $quartus_family_no_spaces ]

	if { [regexp -nocase {^(max|flex)} $family_name ] } {
# temp fix until SPR 280341: max*/flex* not listed in sim_lib_info

	} elseif { ! [::quartus::sim_lib_info::is_family_supported $family_name ] } {
		nl_postmsg error "Error: Device Family \"$quartus_family_qsf\" not supported for NativeLink Simulation"
		error "Family not supported"
	}

	return $family_name
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::run_eda_simulation_tool {
	eda_hash_opts
} {
##
#######################################################################

    upvar $eda_hash_opts  hash_opts

    variable q_called_from_qeda
    variable q_qsf_sim_tool 
    variable q_qsf_is_functional
    variable q_qsf_user_compiled_directory
    variable q_qsf_netlist_output_directory

    set rtl_sim $hash_opts(rtl_sim)
    set no_gui $hash_opts(no_gui)
    set gen_script $hash_opts(gen_script)
    set block_on_gui $hash_opts(block_on_gui)
    set netlist_file $hash_opts(netlist_file)
    set timing_file $hash_opts(timing_file)

    # store qsf options passed-in from command line in package variables. These are read by other individual procs that get qsf values
    set q_qsf_sim_tool $hash_opts(qsf_sim_tool)
    set q_qsf_is_functional $hash_opts(qsf_is_functional)
    set q_qsf_user_compiled_directory $hash_opts(qsf_user_compiled_directory)
    set q_qsf_netlist_output_directory $hash_opts(qsf_netlist_output_directory)

    set q_called_from_qeda $hash_opts(called_from_qeda)


	 set library_dir ""

    set status 0
    variable INFO_INIT_SIM_SETTINGS_SUCCESS 

    variable ERROR_INIT_SIM_SETTINGS 
    variable ERROR_UNKNOWN_NETLIST_TYPE_STRING
    variable ERROR_ABSENT_SIM_DIR
    variable ERROR_OUTPUT_NETLISTER_NOT_RUN
    variable ERROR_NL_FOR_SIMTOOL_NOT_SUPPORTED

    variable q_sim_tool        
    variable q_sim_lang        
    variable q_sim_output_file 
    variable q_sim_sdf_file    
    variable q_sim_dir         
    variable q_vhd_version




    set family_name [get_sim_nativelink_family]

    if [catch { set_q_sim_environ } result] {
	nl_postmsg error "$ERROR_INIT_SIM_SETTINGS : $result"
	return 1
    }

    if {$q_sim_tool == ""} {
	nl_postmsg error "$ERROR_NL_FOR_SIMTOOL_NOT_SUPPORTED $q_sim_tool"
	set ::errorCode 1
	set ::errorInfo "$ERROR_NL_FOR_SIMTOOL_NOT_SUPPORTED $q_sim_tool"
	return 1
    }

	# Read QSF variables for no_gui and gen_script options. cmd line options take precedence over QSF options

	if { $no_gui != 1 } {
    set no_gui_qsf_option [ get_global_assignment -name {EDA_LAUNCH_CMD_LINE_TOOL} -section_id eda_simulation ]
    if {$no_gui_qsf_option eq "ON"} {
		set no_gui 1 
    }
	}
	    
	if { $gen_script != 1 } {
    set gen_script_qsf_option [ get_global_assignment -name {EDA_NATIVELINK_GENERATE_SCRIPT_ONLY} -section_id eda_simulation ]
    if {$gen_script_qsf_option eq "ON"} {
		set gen_script 1 
    }
	}


	# read qsf for user compiled library directory. check that the directory exists
	set library_dir ""

	if { $q_qsf_user_compiled_directory	 == "" } {
   	set library_dir_qsf_option [ get_global_assignment -name {EDA_USER_COMPILED_SIMULATION_LIBRARY_DIRECTORY} -section_id eda_simulation ]
	} else {
   	set library_dir_qsf_option $q_qsf_user_compiled_directory
	}

   if { $library_dir_qsf_option ne "<None>" && $library_dir_qsf_option ne "" } {
		set tmp_dir "$library_dir_qsf_option"
		regsub -all {\\} $tmp_dir {/} library_dir
		if { ![file isdirectory "$library_dir"] } {
			post_message -type error "Error: The specified user compiled library directory $library_dir_qsf_option does not exist"
			error "" "Invalid user compiled directory $library_dir_qsf_option "
		} else {
			if { [file pathtype $library_dir] eq "relative" } {
				set library_dir [file join [pwd] $library_dir]
				post_message -type info "Converted user compiled library directory to absolute path"
			}
			post_message -type info "Using the specified user compiled library directory $library_dir"
		}
	} 

	if { $block_on_gui != 1 } {
   	set block_on_gui_qsf_option [ get_global_assignment -name {EDA_WAIT_FOR_GUI_TOOL_COMPLETION} -section_id eda_simulation ]
   	if {$block_on_gui_qsf_option eq "ON"} {
			set block_on_gui 1 
   	}
	}
	

    if {$rtl_sim == 1} {

        # if NativeLink EDA Synthesis is enabled, then disable NativeLink RTL simulation.
        set nl_syn [get_global_assignment -name EDA_RUN_TOOL_AUTOMATICALLY -section_id eda_design_synthesis]

	if {[string compare -nocase $nl_syn "ON"] == 0} {
		nl_postmsg error "Error: RTL Simulation using NativeLink is not supported when EDA Synthesis using NativeLink is enabled"
		error "" "EDA RTL Simulation using NativeLink is not supported wwhen EDA Synthesis using NativeLink is enabled"
	}

	set sim_mode  "RTL"
	#if design uses mixed language, error out
	set design_file_list [get_unencrypted_hdl_files "mixed"]

	#Remove files ignored due to IPFS flow from the list of language files
	set ignored_files ""
	set ipfs_files_list ""
	foreach file $design_file_list {
	    set full_file_name [get_file_info -info full_path -filename $file]
	    array set list [get_ip_info $full_file_name]
	    if {([array names list related_files] != "" ) && ($list(related_files) != "")} {
		# All related_files to ignored_files list
		set ignored_files "$ignored_files [split $list(related_files) ,]"
	    }
	    if {([array names list ipfs_file] != "" ) && ($list(ipfs_file) != "")} {
		set ipfs_files_list "$ipfs_files_list [split $list(ipfs_file) ,]"
	    }
	    array unset list
	}
	foreach ignored_file $ignored_files {
	    set ix [lsearch -exact $design_file_list $ignored_file] 
	    if {$ix >= 0} {
		set design_file_list [lreplace $design_file_list $ix $ix]
	    }
	}

	foreach file $ipfs_files_list {
	    lappend design_file_list $file
	}
	set verilog_files ""
	set vhdl_files ""
	foreach file $design_file_list {
		if {[get_file_type $file] == "verilog"} {
			lappend verilog_files $file
		} elseif {[get_file_type $file] == "vhdl"} {
			lappend vhdl_files $file
		}
	}

       #if one of verilog_files and vhdl_files is null, we will switch formats here.
       #This would ensure that we do not use mixex mode simulation

	set this_module "NativeLink"

	if { $q_called_from_qeda } {
		set this_module "Quartus II"
	}
	if ![qmap_successfully_completed] {
	    nl_postmsg error "Error: Run Analysis and Elaboration successfully before starting RTL NativeLink Simulation"
	    error "Analysis and Synthesis should be completed successfully before starting RTL NativeLink Simulation"
	} elseif {($vhdl_files == "") && ($verilog_files == "")} {
	    nl_postmsg error "Error: $this_module did not detect any HDL files in the project"
	    error "" "$this_module did not detect any HDL files in the project"
	} elseif {$verilog_files == ""} {
	    nl_postmsg info "Info: $this_module has detected VHDL design -- VHDL simulation models will be used"
	    set q_sim_lang "vhdl"
	} elseif {$vhdl_files == ""} {
	    nl_postmsg info "Info: $this_module has detected Verilog design -- Verilog simulation models will be used"
	    set q_sim_lang "verilog"
	} else {
	    nl_postmsg info "Info: $this_module has detected a mixed Verilog and VHDL design -- $q_sim_lang simulation models will be used"
	}

    } else {
	set sim_mode  "Gate"
	if {$q_sim_lang == "vhdl"} {
	    if [is_top_level_entity_writing_disabled] {
		    set submsg {"You can write the top-level entity to a the design file by turning off the 'Don’t write top-level entity' option in the More EDA Tools Simulation Settings dialog box."}
		    post_message -type error "Error: You cannot perform gate-level NativeLink simulation without writing the top-level entity to the design file." -submsgs $submsg
		    error "" "Writing of top level entity is disabled"
	    }
	}
    }
    nl_logmsg "\n========= EDA Simulation Settings =====================\n"
    nl_logmsg "Sim Mode              :  $sim_mode"
    nl_logmsg "Family                :  $family_name"
    nl_logmsg "Quartus root          :  $::quartus(binpath)"
    nl_logmsg "Quartus sim root      :  $::quartus(eda_libpath)sim_lib"
    nl_logmsg "Simulation Tool       :  $q_sim_tool"
    nl_logmsg "Simulation Language   :  $q_sim_lang"
    if [regexp -nocase VHDL $q_sim_lang] {
	if [regexp -nocase OFF $q_vhd_version] {
	    nl_logmsg "Version               :  93"
	} else {
	    nl_logmsg "Version               :  87"
	}
    }
    if {$no_gui == 1} {
	    nl_logmsg "Simulation Mode       :  Command Line"
    } elseif {$gen_script == 1} {
	    nl_logmsg "Simulation Mode       :  Script Only"
    } else {
	    nl_logmsg "Simulation Mode       :  GUI"
    }
	 if {$netlist_file == "" } {
    nl_logmsg "Sim Output File       :  $q_sim_output_file"
    } else {
    nl_logmsg "Sim Output File       :  $netlist_file"
    }
    if {$timing_file == "" } {
      nl_logmsg "Sim SDF file          :  $q_sim_sdf_file"
    } else {
      nl_logmsg "Sim SDF File       :  $timing_file"
    }
    nl_logmsg "Sim dir               :  $q_sim_dir"
    nl_logmsg "\n=======================================================\n"

    #save original directory
    set orig_dir [pwd]
    if {[catch {goto_sim_dir $q_sim_tool} result]} {
	set status 1
	return 1
    }

    set run_sim_args_hash(rtl_sim) $rtl_sim
    set run_sim_args_hash(language) $q_sim_lang
    set run_sim_args_hash(no_gui) $no_gui
    set run_sim_args_hash(gen_script) $gen_script
    set run_sim_args_hash(block_on_gui) $block_on_gui
    set run_sim_args_hash(netlist_file) $netlist_file
    set run_sim_args_hash(timing_file) $timing_file
    set run_sim_args_hash(library_dir) $library_dir

    set run_sim_args_hash(qsf_sim_tool) $q_qsf_sim_tool

    set run_sim_args_hash(no_prompt) $hash_opts(no_prompt)

    if {[catch { 
	    set status [run_sim run_sim_args_hash]
    } result ] } {
		cd $orig_dir
		set status 1

		# errorCode is not always defined even if catch block evaluates to non-zero value
		if [ info exists ::errorCode ] {
			set savedCode $::errorCode
			set savedInfo $::errorInfo
			error "$result" $savedInfo $savedCode
		} else {
			error "$result" 1 1
		}
   } else {
		set status $result
		cd $orig_dir
	}

	return $status
}


############################################################################
##
##
proc ::quartus::nativelinkflow::sim::is_timing_simulation_on {} {
##
############################################################################
variable q_qsf_is_functional
	set result 0
	if { $q_qsf_is_functional == "" } {
		set functional_sim [ get_global_assignment -name {EDA_GENERATE_FUNCTIONAL_NETLIST} -section_id eda_simulation ]
		if {[regexp -nocase $functional_sim "ON"] == 1 } {
			set result 0
		} else {
			set result 1
		}
	} elseif { [regexp -nocase $q_qsf_is_functional "ON"] == 1} {
		set result 0
	} else {
		set result 1
	}
	 
	return $result
}

#######################################################################
##
proc ::quartus::nativelinkflow::sim::run_sim {
	sim_args_hash
} {

##
#######################################################################
	upvar $sim_args_hash hash_opts
	
	# copy hash_opts to launch_args_hash
	array set launch_args_hash [array get hash_opts]

	
	
	if { $hash_opts(rtl_sim) } {
		set sim_mode "RTL"
	} else {
		set sim_mode "GATE"
	}
	set netlist_file $hash_opts(netlist_file)
	set language $hash_opts(language)
	set compile_libs ""
	

	variable q_called_from_qeda

	variable q_sim_tool
	variable ERROR_ABSENT_NL_SCRIPT
	variable ERROR_SOURCE_NL_SCRIPT 
	array set tool_map   {
		modelsim	        {"ModelSim" "1" "modelsim.tcl" }
		modelsim-altera 	{"ModelSim-Altera" "0" "modelsim.tcl" }
		vcs		{"VCS" "1" "vcs.tcl" }
		ncsim		{"NcSim" "1" "ncsim.tcl" }
		vcs_mx		{"VCS MX"  "1" "vcs_mx.tcl" }
		active-hdl	{"Active-HDL" "1" "active-hdl.tcl" }
		riviera-pro	{"Riviera-PRO" "1" "riviera-pro.tcl" }
	}
	
	set tool_name  [lindex $tool_map($q_sim_tool) 0]
	set compile_libs  [lindex $tool_map($q_sim_tool) 1]
	set tool_script  [lindex $tool_map($q_sim_tool) 2]

	if { $q_called_from_qeda  == 0 } {
		nl_postmsg info "Info: Starting NativeLink simulation with $tool_name software"
	}
	
	set status 0
	variable ::quartus
	
	set nativelink_tool_script "$quartus(nativelink_tclpath)$tool_script"
	
	if { [ file exists $nativelink_tool_script ] == 0} {
		nl_postmsg error "$ERROR_ABSENT_NL_SCRIPT $nativelink_tool_script !"
	} else {
		if { [ catch { source $nativelink_tool_script } result ]  } {
			nl_postmsg error "$ERROR_SOURCE_NL_SCRIPT $result"
		} else {
			nl_logmsg "Sourced NativeLink script $nativelink_tool_script"
		}
	}
	
	#namespace import ${pnsp}::*
	
	if {[string compare -nocase $sim_mode "rtl"] == 0} {
		set launch_args_hash(rtl_sim) "1"
	} else {
		if { $netlist_file == "" } {
			# Check if [get_ exists otherwise error out
			set cap [get_project_settings -cmp]
			set ext [get_eda_writer_netlist_ext $language]
			if ![file exists ${cap}.${ext} ] {
				nl_postmsg error "Error: Gate Level Simulation Netlist not found -- run EDA NetList Writer to generate Gate Level simulation netlist"
				set status 1
			}
		}
		set launch_args_hash(rtl_sim) "0" 
	}
	
	
	set launch_args_hash(compile_libs) "$compile_libs"
	set launch_args_hash(language) "$language"
	set launch_args_hash(netlist_file) $netlist_file
	
	# all other entries in launch_args_hash are same as opts_hash (since launch_args_hash was initialized as a dup of opts_hash )
	
	if {$status == 0} {
		if [catch {eval launch_sim launch_args_hash} result ] {
			set status 1
			if [ info exists ::errorCode ] {
				set savedCode $::errorCode
				set savedInfo $::errorInfo
				error $result $savedInfo $savedCode
			} else {
				error $result 1 1 
			}
		} else {
			# if there is no exception then 'result' holds the return value of launch_sim()
			set status $result
		} 
	} 

	return $status
}
