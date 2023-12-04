#############################################################################
##  generate_pin_swap_file.tcl 
##
##   This script writes out the FPGA Xchange file based on the
##   Properties of the "assigned" and "reserved" I/Os in design
##
##   This script should be called as follows
##   quartus_cdb -t qeda_write_fx.tcl <project_name> <revision_name>
##
##  ALTERA LEGAL NOTICE
##  
##  This script is  pursuant to the following license agreement
##  (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
##  FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
##  California, USA.  Permission is hereby granted, free of
##  charge, to any person obtaining a copy of this software and
##  associated documentation files (the "Software"), to deal in
##  the Software without restriction, including without limitation
##  the rights to use, copy, modify, merge, publish, distribute,
##  sublicense, and/or sell copies of the Software, and to permit
##  persons to whom the Software is furnished to do so, subject to
##  the following conditions:
##  
##  The above copyright notice and this permission notice shall be
##  included in all copies or substantial portions of the Software.
##  
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
##  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
##  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
##  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
##  OTHER DEALINGS IN THE SOFTWARE.
##  
##  This agreement shall be governed in all respects by the laws of
##  the State of California and by the laws of the United States of
##  America.
##
##
##  CONTACTING ALTERA
##  
##  You can contact Altera through one of the following ways:
##  
##  Mail:
##     Altera Corporation
##     Applications Department
##     101 Innovation Drive
##     San Jose, CA 95134
##  
##  Altera Website:
##     www.altera.com
##  
##  Online Support:
##     www.altera.com/mysupport
##  
##  Troubshooters Website:
##     www.altera.com/support/kdb/troubleshooter
##  
##  Technical Support Hotline:
##     (800) 800-EPLD or (800) 800-3753
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##     (408) 544-7000
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##  
##     From other locations, call (408) 544-7000 or your local
##     Altera distributor.
##  
##  The mySupport web site allows you to submit technical service
##  requests and to monitor the status of all of your requests
##  online, regardless of whether they were submitted via the
##  mySupport web site or the Technical Support Hotline. In order to
##  use the mySupport web site, you must first register for an
##  Altera.com account on the mySupport web site.
##  
##  The Troubleshooters web site provides interactive tools to
##  troubleshoot and solve common technical problems.
##
#############################################################################

#Packages used by this TCl script
package require ::quartus::atoms
package require ::quartus::device
package require ::quartus::advanced_device 2.0
package require ::quartus::flow

package require ::quartus::io 2.0

#This script uses the infrastructure provided by the qnativelinkflow.tcl script.
#To convert tool names

source "$quartus(nativelink_tclpath)/qnativelinkflow.tcl"
namespace import ::quartus::nativelinkflow::open_nl_log
namespace import ::quartus::nativelinkflow::close_nl_log
namespace import ::quartus::nativelinkflow::nl_postmsg
namespace import ::quartus::nativelinkflow::nl_logmsg
namespace import ::quartus::nativelinkflow::create_work_dir


################################################################################
#
proc print_header {file_handle} {
##
##  Arguments:
##      <file_handle> - The file handle.
##
##  Description:
##	This function writes the Copyright notice in the pin swap file
##
##  Returns:
##	Nothing.
################################################################################
	#Call the load device from ::quartus::advanced_device package
 	puts $file_handle "###############################################################################"
 	puts $file_handle "# Copyright (C) 1991-2007 Altera Corporation"
 	puts $file_handle "# Any  megafunction  design,  and related netlist (encrypted  or  decrypted),"
 	puts $file_handle "# support information,  device programming or simulation file,  and any other"
 	puts $file_handle "# associated  documentation or information  provided by  Altera  or a partner"
 	puts $file_handle "# under  Altera's   Megafunction   Partnership   Program  may  be  used  only"
 	puts $file_handle "# to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any"
 	puts $file_handle "# other  use  of such  megafunction  design,  netlist,  support  information,"
 	puts $file_handle "# device programming or simulation file,  or any other  related documentation"
 	puts $file_handle "# or information  is prohibited  for  any  other purpose,  including, but not"
 	puts $file_handle "# limited to  modification,  reverse engineering,  de-compiling, or use  with"
 	puts $file_handle "# any other  silicon devices,  unless such use is  explicitly  licensed under"
 	puts $file_handle "# a separate agreement with  Altera  or a megafunction partner.  Title to the"
 	puts $file_handle "# intellectual property,  including patents,  copyrights,  trademarks,  trade"
 	puts $file_handle "# secrets,  or maskworks,  embodied in any such megafunction design, netlist,"
 	puts $file_handle "# support  information,  device programming or simulation file,  or any other"
 	puts $file_handle "# related documentation or information provided by  Altera  or a megafunction"
 	puts $file_handle "# partner, remains with Altera, the megafunction partner, or their respective"
 	puts $file_handle "# licensors. No other licenses, including any licenses needed under any third"
 	puts $file_handle "# party's intellectual property, are provided herein."
 	puts $file_handle "#"
 	puts $file_handle "###############################################################################"

	puts $file_handle ""
	puts $file_handle ""
}

#######################################################################
##
proc pin_swap_flow_supported {tool_name} {
##
##  Arguments:
##	<tool_name> - Name of the Board Level EDA tool in the EDA tool settings.
##
##  Description:
##	This function checks if the board level EDA tool is supported.
##
##  Returns:
##	0 - If the tool is not supported
##	1 - If the tool is supported
##
#################################################################################
    set result 0
    switch -regexp -- $tool_name {
	(?i)^boardlink$
	{
	    set result 1
	}
	{(?i)^boardlink pro$}
	{
	    set result 1
	}
    }
    return $result
}

########################################################################
##
proc find_swap_group {node_type pin_id pin_loc_name} {
##
##  Arguments:
##      <pin_id> - Pin Id of the pin in atom netlist.
##      <pin_loc_name> - The Pin name based on the location of the pin on
##       the package. e.g A11
##
##  Description:
##	This function is computes the swap group for a given pin.
##
##  Returns:
##	swap_group -  returns the swap group of a given pin
#########################################################################
    #Call the load device from ::quartus::advanced_device package
    global swap_group_index
    global swap_groups , swap_group_members
    global swap_group_properties
    global swap_group_of_pin
    global family

    if {$node_type == "PIN"} {        
        set io_mode [get_atom_node_info -key ENUM_IO_MODE -node $pin_id]
        regsub {_PIN$} $io_mode {} direction
    } else {
        if {[get_atom_node_info -key BOOL_IS_INPUT -node $pin_id]} {
            set direction "INPUT"
        } elseif {[get_atom_node_info -key BOOL_IS_OUTPUT -node $pin_id]} {
            set direction "OUTPUT"
        } elseif {[get_atom_node_info -key BOOL_IS_BIDIR -node $pin_id]} {
            set direction "BIDIR"
        } else {
        set direction ""
        }        
    }
    set io_standard [get_atom_node_info -key ENUM_IO_STANDARD -node $pin_id]
    set drive [get_atom_node_info -key ENUM_CURRENT_STRENGTH_ENUM -node $pin_id]
    #Can the drive Strength be MIN_MA and MAX_MA?

    #assuming that CURRENT_STRENGTH is always in MA, otherwise we 
    #will have to convert the drive to MA first.
    regsub -nocase {MA$} $drive {} drive

    set diff_mode NONE

    global family
    set oct_type OFF
    if {$family != "MAX II"} {
        if [get_atom_node_info -key BOOL_HSSI_POS -node $pin_id] {
	        set diff_mode P
        }

        if [get_atom_node_info -key BOOL_HSSI_NEG -node $pin_id] {
	        set diff_mode N
        }
        if {$node_type == "PIN"} {
		    set oct_type [get_atom_node_info -key ENUM_OCT_TYPE -node $pin_id] 
        } else {
            if {($direction == "OUTPUT") || ($direction == "BIDIR") } {
                # first look up the output buffer
                set outbuff_id [get_atom_port_info -node $pin_id -type iport -port_id 0 -key fanin]
                regsub { .+$} $outbuff_id {} outbuff_id
                set oct_type [get_atom_node_info -key ENUM_OCT_TYPE -node $outbuff_id]
            }
        }
    }

    set clk_func [get_clock_func_of_pin $pin_loc_name] 
    
    set pull_up  "normal"
    if [get_atom_node_info -key BOOL_WEAK_PULL_UP -node $pin_id] {
	set pull_up  "week"
    }

    set slew ""
    if {$diff_mode == "NONE"} {
        if {($direction == "OUTPUT") || ($direction == "BIDIR") } {
            if {$node_type == "PIN"} {
                set slew FAST
                if [get_atom_node_info -key BOOL_SLOW_SLEW_RATE -node $pin_id] {
                    set slew SLOW
                }
            } else {
                set slew [get_atom_node_info -key INT_SLEW_RATE -node $outbuff_id]
                if {$family == "Cyclone III"} {
                    switch $slew  {
                        {0} {set slew "SLOW"}
                        {1} {set slew "MED"}
                        {2} {set slew "FAST"}
                        default {}
                    }
                } elseif {($family == "Stratix III") || ($family == "Stratix IV")} {
                    switch $slew  {
                        {0} {set slew "SLOW"}
                        {1} {set slew "MED"}
                        {2} {set slew "MEDFAST"}
                        {3} {set slew "FAST"}                    
                        default {}
                    }            
                }
            }
        }
    }

    set bus_hold "no"
    if {$node_type == "PIN"} {
        if [get_atom_node_info -key BOOL_BUS_HOLD -node $pin_id] {
	        set bus_hold "yes"
        }
    } else {
        if {($direction == "OUTPUT") || ($direction == "BIDIR") } {    
            if [get_atom_node_info -key BOOL_BUS_HOLD -node $outbuff_id] {
	            set bus_hold "yes"
            }
        }   
    }

    if [info exists swap_groups($direction,$io_standard,$drive,$slew,$bus_hold,$diff_mode,$pull_up,$clk_func,$oct_type)] {
	set group $swap_groups($direction,$io_standard,$drive,$slew,$bus_hold,$diff_mode,$pull_up,$clk_func,$oct_type)
	# We may want to have extra arrays for reverse lookup
	set temp $swap_group_members($group)
	set swap_group_members($group) "$temp,$pin_id"
	set swap_group_of_pin($pin_id) $group
    } else {
	set group "swap_$swap_group_index"
	set swap_group_properties($group) "$direction,$io_standard,$drive,$slew,$bus_hold,$diff_mode,$pull_up,$clk_func,$oct_type"
	set swap_groups($direction,$io_standard,$drive,$slew,$bus_hold,$diff_mode,$pull_up,$clk_func,$oct_type) "$group"
	incr swap_group_index
	set swap_group_members($group) $pin_id
	set swap_group_of_pin($pin_id) $group
    }
    return $group
}

#######################################################################
##
proc get_clock_func_of_pin {pin_loc_name} {
##
##  Arguments:
##	<pin_loc_name> - The name of the pin based on the location on the package.
##
##  Description:
##	This function returns the clock function of the pin
##
##  Returns:
##	NONE          - if the pin is not a dedicated clock
##	clk           - if the pin is a dedicated clock
##	clkout        - if the pin is a dedicated clock out pin
##	clk_feedback  - if the pin is a dedicated clock feedback pin
##
#######################################################################
    set func "none"
    
    if [::quartus::io::is_clock_input_pin $pin_loc_name] {
	    set func "clk"
    } elseif [::quartus::io::is_clock_output_pin $pin_loc_name] {
	    set func "clk"
    } elseif [::quartus::io::is_pll_enable_pin $pin_loc_name ] {
	    set func "pll_related"
    } elseif [::quartus::io::is_pll_clock_output_pin $pin_loc_name ] {
	    set func "pll_related"
    } elseif [::quartus::io::is_pll_feedback_pin $pin_loc_name ] {
	    set func "pll_related"
    }
    return $func
}

################################################################################
##
proc get_padio_port {atom} {
##
## Description:
## The main function, just like in C.  This is the entry point to the script.
##
## Arguments: <project_name> 
##
## Returns: 
##	Nothing - Generates the pin swap file in directory
##	          board_level\<tool_name>\<project>.tcl
#
################################################################################
    set padio_id -1
    set oterms [ get_atom_oports -node $atom]
    foreach i $oterms {
	set port_type [get_atom_port_info -node $atom -type oport -port_id $i -key type]
	if {[regexp -nocase PADIO $port_type]} {
	    set padio_id $i
	    break;
	}
    }
    return $padio_id
}

################################################################################
##
proc main {} {
##
## Description:
## The main function, just like in C.  This is the entry point to the script.
##
## Arguments: <project_name> 
##
## Returns: 
##	Nothing - Generates the pin swap file in directory
##	          board_level\<tool_name>\<project>.tcl
#
################################################################################

    global quartus
    variable project_name
    variable pin_swap_file
    set q_args $quartus(args)

    if { ([llength $q_args] < 1) || ([llength $q_args] > 2) } {
	nl_postmsg  error "Error: Incorrect number of Arguments"
	nl_postmsg  error "Usage: quartus_cdb -t generate_pin_swap_files.tcl project_name revision_name"
	set return_status 1
    } else {
	set project_name [lindex $q_args 0]
	if { [llength $q_args] == 2 } {
	    set action_pt [lindex $q_args 1]
	    if [ catch {project_open $project_name -cmp $action_pt} temp ] {
		nl_postmsg  error "Error: $temp"
		set return_status 1
	    }
	} else {
	    if [ catch {project_open $project_name -current_revision} temp ] {
		nl_postmsg  error "Error: $temp"
		set return_status 1
	    }
	}
    }

    #somehow check if the fitter has already completed.
    if [catch {read_atom_netlist} result] {
	nl_postmsg  error "Error: $result"
	# no atcom netlist found?
    }

    # we will not do the checking for tool name in this script.
    set tool_name "fpgaxchange"
    set default_work_dir "board/$tool_name"
    set work_dir [get_global_assignment -name EDA_NETLIST_WRITER_OUTPUT_DIR -section_id eda_board_design_symbol]
    if {$work_dir == ""} {
	set work_dir $default_work_dir
    }
    set work_dir [file normalize $work_dir]
    if [catch {create_work_dir $work_dir} result] {
	nl_postmsg  error "Error: $result"
	error "" ""
    }

    set pin_swap_file "$work_dir/${project_name}.fx"
    if [ catch { open $pin_swap_file w} swap_file ]  {
	nl_postmsg  error "Error : Can't open file -- $pin_swap_file"
	set return_code 1
    } else {
	nl_postmsg info "Info: Generating FPGA Xchange file $pin_swap_file"
    }
    
    global swap_group_index
    set swap_group_index 0
    global family
    set family [get_dstr_string -family [get_global_assignment -name FAMILY]]
    set part [get_global_assignment -name DEVICE]
    set device [get_part_info -device $part]
    set speed [get_part_info -speed_grade $part]
    set package [get_part_info -package $part]
    set pin_count [get_part_info -pin_count $part]

    if {[regexp -nocase AUTO $part]} {
	nl_postmsg  error "Error: FPGA Xchange file generation is not supported for AUTO device selection"
	nl_postmsg  error "Error: Please choose specific device and rerun Quartus II compile"
	qexit -error
    }
    if [test_part_trait_of -trait NO_PIN_OUT $part] {
	nl_postmsg  error "Error: FPGA Xchange file generation is not supported for device $part"
	qexit -error

    }
    switch -regexp -- $family  {
	{(?i)^Arria GX$} { }
	{(?i)^Arria II GX$} { }
	{(?i)^Cyclone$} { }
	{(?i)^Cyclone II$} { }
	{(?i)^Cyclone III$} { }
	{(?i)^HardCopy II$} { }
	{(?i)^MAX II$} { }
	{(?i)^Stratix$} {}
	{(?i)^Stratix GX$} { }
	{(?i)^Stratix II$} { }
	{(?i)^Stratix II GX$} { }
	{(?i)^Stratix III$} { }
	{(?i)^Stratix IV$} { }
	default
	{
	    nl_postmsg  error "Error: Xchange file generation is not supported for device family $family"
	    error "Family NOT supported" "Family NOT Supported" 
	}
    }
    
    if [catch {::quartus::io::load_device_database $part} status] {
	nl_postmsg  error "Error: Unable to load device $part"
	nl_postmsg  error "Error Status: $status"
	nl_logmsg "Error Info: $errorInfo"
	nl_logmsg "Error Code: $errorCode"
	qexit -error
    }
    print_header $swap_file
    puts $swap_file "#FPGA Xchange file generated using $quartus(version)"
    puts $swap_file "DESIGN=$project_name"
    puts $swap_file "DEVICE=$device"
    if {[regexp -nocase "$device\(\[a-z0-9\]+\)\(-?$speed\)" $part dummy package speed] } {
	puts $swap_file "PACKAGE=$package"
	puts $swap_file "SPEEDGRADE=$speed"
    }

    puts $swap_file ""
    puts $swap_file ""
    puts $swap_file ""

    #Pin Name is complicated to calculate, also the tool should already have this name.

    puts $swap_file "Pin Number, IO Bank, Signal Name, Direction, IO Standard, Drive (mA), Termination, Slew Rate, IOB Delay, Swap Group, Diff Type"

    puts $swap_file ""

    set node_type "PIN"
    if {($family == "Cyclone III") || ($family == "Stratix III") || ($family == "Stratix IV") || ($family == "Arria II GX")} {
        set node_type "IO_PAD"
    }

    ## The port_id of port padio on WYSIWYG I/Os is 3.
    ## We need this in order to find out the name of the signal connected to padio
    #figure out oterm port
    #The id of padio port for stratix ii is 6.
    
    foreach_in_collection pin_id [get_atom_nodes -type $node_type] {
	    set location [get_atom_node_info -key LOCATION -node $pin_id]
	    regsub {^PIN_} $location {} pin_loc_name
        
	    #by default a pin is not a differential pin, hence it may not have differential type set.
	    set encrypted_node [get_atom_node_info -key BOOL_ENCRYPTED -node $pin_id]

	    if {$encrypted_node} {
    	    continue
	    }
	    set reserved_as [get_atom_node_info -key ENUM_IO_RESERVED_TYPE -node $pin_id]
	    set swap_group [find_swap_group $node_type $pin_id $pin_loc_name]

	    ##Dedicated Programming pins cannot be swapped, so we will not write them.
	    ## Or should we write them without a swap group?
	    if {$reserved_as == "PROGRAMMING"} {
    	    continue;
	    } elseif {$reserved_as == "JTAG"} {
	        #Dedicated JTAG pins cannot be swapped, so we will not write them.
    	    ## Or should we write them without a swap group?
	        continue;
	    } elseif {$reserved_as == "PROGRAMMING"} {
	        #some pins are reserved for device migration, these cannot be swapped, hence should not be written out
	        continue;
	    } elseif {$reserved_as != "NONE"} {
    	    #Any reserved pin should not be swapped
	        continue;
	    }
       
	    ##Get the name of the WYSIWYG I/O Atom.
	    set iopad_name [get_atom_node_info -key NAME -node $pin_id]

	    ##Get the name of the Mode of Operation of WYSIWYG I/O Atom.
        if {$node_type == "PIN"} {        
	        set io_mode [get_atom_node_info -key ENUM_IO_MODE -node $pin_id]
	        regsub {_PIN$} $io_mode {} direction
        } else {
            if {[get_atom_node_info -key BOOL_IS_INPUT -node $pin_id]} {
                set direction "INPUT"
            } elseif {[get_atom_node_info -key BOOL_IS_OUTPUT -node $pin_id]} {
                set direction "OUTPUT"
            } elseif {[get_atom_node_info -key BOOL_IS_BIDIR -node $pin_id]} {
                set direction "BIDIR"
            } else {
            set direction ""
            }        
        }
    
	    set io_standard [get_atom_node_info -key ENUM_IO_STANDARD -node $pin_id]
	    set drive [get_atom_node_info -key ENUM_CURRENT_STRENGTH_ENUM -node $pin_id]
	    #assuming that CURRENT_STRENGTH is always in MA, otherwise we 
    	#will have to convert the drive to MA first as FPGA Xchange file expects drive in MA

		regsub -nocase {MA$} $drive {} drive

        if {$node_type == "PIN"} {
    	    ## The name of the design pin is different than the name of the WYSIWYG I/O 
	        ## Atom. The pin of the design is connected to the padio port of the WYSIWYG.
	        ## The port_id of the padio port is 3.
    	    set padio_id [get_padio_port $pin_id]
	        if {$padio_id == -1 } {
    	        nl_postmsg error "Error: could not find the PADIO port of pin $pin_loc_name"
    	        qexit -error
	        }
    	    set signal [get_atom_port_info -key NAME -port_id $padio_id -node $pin_id -type oport]
        } else {
            set signal [get_atom_node_info -key NAME -node $pin_id]
        }
        
    	set diff_mode ""
    	set termination ""
   	    if {$family != "MAX II"} {
	        if [get_atom_node_info -key BOOL_HSSI_POS -node $pin_id] {
	            set diff_mode P
	        }
	        if [get_atom_node_info -key BOOL_HSSI_NEG -node $pin_id] {
    	        set diff_mode N
	        }
            if {$node_type == "PIN"} {
		        set termination [get_atom_node_info -key ENUM_OCT_TYPE -node $pin_id] 
            } else {
                if {($direction == "OUTPUT") || ($direction == "BIDIR") } {
                    # first look up the output buffer
                    set outbuff_id [get_atom_port_info -node $pin_id -type iport -port_id 0 -key fanin]
                    regsub { .+$} $outbuff_id {} outbuff_id
                    set termination [get_atom_node_info -key ENUM_OCT_TYPE -node $outbuff_id]
                }
            }
	    }

        set slew ""
        if {$diff_mode == "NONE"} {
            if {($direction == "OUTPUT") || ($direction == "BIDIR") } {
                if {$node_type == "PIN"} {
	                set slew FAST
	                if [get_atom_node_info -key BOOL_SLOW_SLEW_RATE -node $pin_id] {
        	            set slew SLOW
        	        }
                } else {
                    set slew [get_atom_node_info -key INT_SLEW_RATE -node $outbuff_id]
                    if {$family == "Cyclone III"} {
                        switch $slew  {
                            {0} {set slew "SLOW"}
                            {1} {set slew "MED"}
                            {2} {set slew "FAST"}
                        	default {}
                        }
                    } elseif {($family == "Stratix III") || ($family == "Stratix IV")} {
                        switch $slew  {
                            {0} {set slew "SLOW"}
                            {1} {set slew "MED"}
                            {2} {set slew "MEDFAST"}
                            {3} {set slew "FAST"}                    
                        	default {}
                        }            
                    }
                }
            }
        }

	    set io_bank [::quartus::io::get_io_bank $pin_loc_name]
	    set iob_delay "NONE"

	    set iostd_user_name [get_user_name -io_standard $io_standard]
	    puts $swap_file "$pin_loc_name,$io_bank,$signal,$direction,$iostd_user_name,$drive,$termination,$slew,$iob_delay,$swap_group,$diff_mode"
    }
    
    nl_postmsg info "Info: FPGA Xchange file $pin_swap_file generated successfully"
    puts "---------------------------------------------------------------"
}

open_nl_log {quartus_nativelink_fpga_xchange.log}

# TCL does not automatically call main as the top level function. Hence we
# a wrapper to call main when this script is called.
variable project_name
variable pin_swap_file
load_package report

if [catch {main} result] {
    nl_postmsg error "Error: EDA Netlist Writer failed to generate FPGA Xchange file"
    nl_logmsg "ERROR: $result $errorCode $errorInfo"
    load_report
    add_row_to_table -name {EDA Netlist Writer||EDA Netlist Writer Summary} {{Board Symbol Files Creation} Failed}
    save_report_database
    unload_report
    puts "refresh_report"
    close_nl_log
    qexit -error
} else {
    load_report
    add_row_to_table -name {EDA Netlist Writer||EDA Netlist Writer Summary} {{Board Symbol Files Creation} Successful}

    set folder  {EDA Netlist Writer||Board-Level}
    set folder_id [get_report_panel_id $folder]

    # Check if specified folder exists. If not, create it.
    if {$folder_id == -1} {
	set folder_id [create_report_panel -folder $folder]
    }

    set table {EDA Netlist Writer||Board-Level||Board-Level Settings}
    set table_id [get_report_panel_id $table]
    if {$table_id == -1} {
	set table_id [create_report_panel -table $table]
	add_row_to_table -name $table {Option Setting}
    }
    add_row_to_table -name $table {{Board Symbol Format} {FPGA Xchange}}

    set table {EDA Netlist Writer||Board-Level||Board-Level Generated Files}
    set table_id [get_report_panel_id $table]
    if {$table_id == -1} {
	set table_id [create_report_panel -table $table]
	add_row_to_table -name $table {{Generated Files}}
    }
    add_row_to_table -name $table "\"Board Symbol\""
    add_row_to_table -name $table "\"$pin_swap_file\""
    save_report_database
    unload_report
    puts "refresh_report"
    close_nl_log
    qexit -success
}

