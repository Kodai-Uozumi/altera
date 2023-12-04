set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: hcii_extra.tcl
#
# Usage: quartus_cdb -t hc_extra.tcl [options]
#
#		where [options] are described below. Search for available_options
#			
#
# Description: 
#       Generate additional information needed by HCDC
#       to do simulation of formal verification
#
#       The script will also create the following:
#
# *************************************************************

# ---------------------------------------------------------------
# Available User Options
# ---------------------------------------------------------------

set available_options {
	{ verbose "Give additional debug information" }
}

# --------------------------------------
# Other Global variables
# --------------------------------------
set hc_output "hc_output"

set supported_family {"stratixiii" "hardcopyiii" "stratixiv" "hardcopyiv"}

set io_bank_list {}
# ------------------------------
# Load Required Quartus Packages
# ------------------------------
load_package atoms
load_package report
load_package advanced_device
load_package device
load_package flow
package require cmdline

# -------------------------------------------------
# -------------------------------------------------

proc hcii_visitor_visit_pin { outfile atom_id } {
	# Visit PIN Atom and extract all keeper names
	# For Pins, find the Physical Pad oterm and get name from it
# -------------------------------------------------
# -------------------------------------------------
       global io_bank_list
       
       #[cpchew]: The info is not ready, refer to SPR 290728
       if {![is_io_pad $atom_id]} {
               set_atom_node_info "IO" -key ENUM_LOCATION_ELEMENT -node $atom_id
               set io_mode [get_atom_node_info -key ENUM_IO_MODE -node $atom_id]
       	}
	set pin_location [get_atom_node_info -key LOCATION -node $atom_id]
	regsub -nocase "pin_" $pin_location "" pin_location
       	set io_standard [get_atom_node_info -key ENUM_IO_STANDARD -node $atom_id]
      	if {[string compare -nocase "none" $io_standard] == 0} { set io_standard DEDICATED_PIN }
       	set vccn [get_atom_node_info -key ENUM_VOLTAGE -node $atom_id]
       	set current_strength [get_atom_node_info -key ENUM_CURRENT_STRENGTH_ENUM -node $atom_id]

	if {[get_atom_node_info -key BOOL_IS_BIDIR -node $atom_id] == 1} {
		set io_type "BIDIR"
	} elseif {[get_atom_node_info -key BOOL_IS_INPUT -node $atom_id] == 1} {
		set io_type "INPUT"
	} elseif {[get_atom_node_info -key BOOL_IS_OUTPUT -node $atom_id] == 1} {
		set io_type "OUTPUT"
	} else {
		set io_type "NONE"
	}

        if {![is_io_pad $atom_id]} {
        	set oterm_id [get_atom_oport_by_type -node $atom_id -type PADIO]
        	set node_name [get_atom_port_info -node $atom_id -type oport -port_id $oterm_id -key name]
        	set hc_name [get_converted_port_name $oterm_id -node_id $atom_id -full_name]

          } else {
                 if {$io_type == "INPUT"} {
                        set oterm_id [get_atom_oport_by_type -node $atom_id -type "PADOUT"]

                 } else {
                        set oterm_id [get_atom_iport_by_type -node $atom_id -type "PADIN"]
                 }
                 set node_name [get_atom_node_info -node $atom_id -key name]
                 set hc_name [get_converted_port_name $oterm_id -node_id $atom_id -full_name]
          }


	#puts $outfile "Atom             = $atom_id"
	puts $outfile "Quartus Name     = $node_name"
	puts $outfile "HCDC Name        = $hc_name"
	puts $outfile "IO Mode          = $io_type"
	puts $outfile "IO Standard      = $io_standard"
	if [catch {set pad_ids [get_pkg_data LIST_PAD_IDS -pin_name $pin_location]}] {
	puts $outfile "IO Bank          = NOT_BONDED"
	} else {
	       foreach pad_id $pad_ids {
	               set io_bank [get_pad_data INT_IO_BANK_ID -pad $pad_id]
	               puts $outfile "IO Bank          = [lindex $io_bank_list $io_bank]"
	       }
	}
	puts $outfile "Voltage          = $vccn"
	puts $outfile "Current Strength = $current_strength"
	puts $outfile "Location         = $pin_location"
	##puts $outfile "IOC Location     = $ioc_location"
	puts $outfile ""

         if {![is_io_pad $atom_id]} {
        	# Mark this name both as a keeper and as a pin
        	set ::name_db(kpr-$node_name) $hc_name
        	# Use ipin for input pins and opin for output pins
        	switch -exact -- $io_mode {
        		"INPUT_PIN" { set ::name_db(ipin-$node_name) $hc_name }
        		"OUTPUT_PIN" { set ::name_db(opin-$node_name) $hc_name }
        		default {
        			# This is a bidir
        			set ::name_db(ipin-$node_name) $hc_name
        			set ::name_db(opin-$node_name) $hc_name
        		}
        	}
         }
}

# -------------------------------------------------
# -------------------------------------------------

proc generate_io_names { outfile } {
	# To speed up the conversion, the script creates
	# its own cache of keeper names
	# A keeper is either a pin or register
	# A global variable named "name_db" holds the database
	#
	# This is the function that knows how to
	# translate Quartus names into Primetime names
# -------------------------------------------------
# -------------------------------------------------

	msg_vdebug "** Initializing names database"

	global io_bank_list

		# Current revision is assumed to be the HCII revision
	set current_revision [get_current_revision]
	foreach revision $::all_revisions {

			# Make sure the revision is the current one
		if {[string compare $current_revision $revision] != 0} { set_current_revision $revision }

		set unload_me 0
		if {[string compare $::fpga_rev $revision] == 0} {
			if [catch {read_atom_netlist -type cmp}] {
				post_message -type error "Run Fitter (quartus_fit) for revision \"$revision\" before running the current option"
				qexit -error
            } else {
                if { [get_chip_info -key BOOL_HAS_RE_LIST] &&
                    [get_chip_info -key BOOL_NETLIST_GOOD] &&
                    [get_chip_info -key BOOL_FIT_SUCCESSFUL] } {

                        set success 1
                        set post_fit_netlist 1
                } else {
                    hardcopy_msgs::post E_RUN_SUCCESSFUL_FIT_BEFORE_HC_READY $info_map(revision)
                }
            }
			set unload_me 1
		} elseif [catch {read_atom_netlist -type asm}] {
			post_message -type error "Run Assembler (quartus_asm) before running the current option"
			qexit -error			
		}

		set part_enum [get_chip_info -key ENUM_PART]

		puts $outfile "\# -----------------------"
		puts $outfile "\# [lindex [get_part_info $part_enum -family] 0] information"
		puts $outfile "\# -----------------------"
		puts $outfile ""
		puts $outfile "Part        = $part_enum"
		puts $outfile "Device      = [lindex [get_part_info $part_enum -device] 0]"
		puts $outfile "Package     = [lindex [get_part_info $part_enum -package] 0]"
		puts $outfile "Pin Count   = [lindex [get_part_info $part_enum -pin_count] 0]"
		puts $outfile "Speed Grade = [lindex [get_part_info $part_enum -speed_grade] 0]"
		puts $outfile ""

		if {$unload_me == 1} { unload_atom_netlist }

			# Reset the current revision to the original one
		if {[string compare $current_revision $revision] != 0} { set_current_revision $current_revision }
	}

		# Get the part from CDB_CHIP
		# This is needed to avoid getting an error if QSF DEVICE=AUTO
	set ::current_part [get_chip_info -key ENUM_PART]
	msg_vdebug "Got CDB_CHIP PART = $::current_part"
	load_device -part $::current_part
	set io_bank_list [get_pad_data VEC_STRING_IOBANK_NAMES]
	load_die_info

	puts $outfile "\# --------------------"
	puts $outfile "\# I/O Bank information"
	puts $outfile "\# --------------------"
	puts $outfile ""
	set io_bank 0
	foreach voltage [get_chip_info -key ENUM_VEC_IOBANK_DEV_VOLTAGE] {
		puts $outfile "I/O Bank = [lindex $io_bank_list $io_bank]"
		puts $outfile "Voltage  = $voltage"
		puts $outfile ""
		incr io_bank
	}
	
	puts $outfile "\# ---------------"
	puts $outfile "\# Pin information"
	puts $outfile "\# ---------------"
	puts $outfile ""
	foreach_in_collection atom_id [get_atom_nodes] {

		set atom_type [get_atom_node_info -key TYPE -node $atom_id]

		switch -exact -- $atom_type {
			"PIN" -
                        "IO_PAD" {
				# This function is currently also writing out the 
				# set_annotated_delay statement for DQS pins
				hcii_visitor_visit_pin $outfile $atom_id 
			}
			default { 
				# Do nothing 
			}
		}
	}

	# clean up
	unload_die_info
	unload_device
	unload_atom_netlist
}

# -------------------------------------------------
# -------------------------------------------------
proc is_io_pad {atom} {
    # get all pins
# -------------------------------------------------
# -------------------------------------------------
    global info_map
    set success 0

    set type [get_atom_node_info -node $atom -key TYPE]

    if { [string equal -nocase $type IO_PAD] } {
        set success 1
    }

    return $success
}

# -------------------------------------------------
# -------------------------------------------------

proc initialize_ioc_to_pad_map { } {
	#
	# This function uses the device database
	# to store a global map with all the
	# IOC_X?_Y?_N? to PAD ID mapping
	#
	# Generate global ioc2pad_db array
	# where key = IOC name and value = pad id
# -------------------------------------------------
# -------------------------------------------------

	set count 0
	set total_pads [get_pad_data INT_PAD_COUNT]
	for { set pad 0 } { $pad < $total_pads } { incr pad } {

		# We only care about pads that have real user names
		if ![catch {set pin_name [get_pad_data STRING_USER_PIN_NAME -pad $pad]}] {

			set mcf_name 0
			if [catch {set mcf_name [get_pad_data STRING_MCF_NAME -pad $pad]}] {
				post_message -error "INTERNAL_ERROR: Pad has no MCF name"
				qexit -error
			}

			if {[scan $mcf_name "X%dY%dSUB_LOC%d" x y n] == 3} {

				set loc_pair1 "X=$x"
				set loc_pair2 "Y=$y"
				set loc_pair3 "N=$n"

				set ioc_name "X${x}_Y${y}_N${n}"

				set ::ioc2pad_db($ioc_name) $pad

				incr count
			}
		}
	}

	msg_vdebug "Processed $count pads from device database"
}

# -------------------------------------------------
# -------------------------------------------------

proc get_hcdc_name { qname } {
	# Function to translate a Quartus node name
	# to a back end name
	#
	# Function uses a previously initialized ::name_db
	# that contains the list of all Quartus keeper names
	# and their PT equivalent. This array is formed with
	# "<node_type>-<quartus_signal_name>" where <node_type>
	# is one of clk,kpr,ipin,opin, and should be set 
	# based on the node_type argument to this function
	#
# -------------------------------------------------
# -------------------------------------------------

	set result ""

	# Create the correct key for the name_db array
	# Remember that the key is formed by the node
	# type and the actual node name
	#
	# We could use a tolower instead of a switch:
	#    "[string tolower $node-type]-$qname"
	# but the switch is easier to maintain
	set key "?pin-$qname"

	# check if this represents a wildcard
	set wildcard_char_count [regsub -all {[*?]} $qname {} ignore] 

	# String Match will treat "[]" as a set, so we need to escape it
	set count1 [regsub -all {[]]} $qname "\\\]" qname] 
	set count2 [regsub -all {[[]} $qname "\\\[" qname] 

	# First check if qname can be found in the name_db
	# This will only happen if qname is valid and it is NOT
	# a wildcard/timegroup
	if [info exists ::name_db($key)] {
		# Doing this is purely for efficiency
		# We could remove this if and let the else block
		# handle all casese.
		set result "$::name_db($key)"

	} else {

		set result NOT_FOUND

	}

	return $result
}

# -------------------------------------------------
# -------------------------------------------------

proc get_io_vccn_from_dev_db { pin_location io_standard } {
	# Using the ATOM's location (in the report), get the 
	# device PIN. From the PIN, get the PAD
	# Using the ATOM's io-std-enum (in the report), 
	# and the device PAD get the io-std-descriptor
	# A pad will be either HIO (left or right) or VIO (top or bottom).
	# If the pad is HIO then use INT_VOLTAGE_TYPE
	# If the pad is VIO then use INT_VIO_VOLTAGE_TYPE if it exists 
	# else use DEV_IO_STANDARD_DESC_INT_VOLTAGE_TYPE.
	#
	# Assumption: The device has been loaded
# -------------------------------------------------
# -------------------------------------------------


	# First, get the list of pads for the give pin_location
	# Note that even when a pin could be bonded to multiple pads
	# this won't be the case for user I/Os, so the list really 
	# corresponds to the one pad that we care
	if [catch {set pad_list [get_pkg_data LIST_PAD_IDS -pin_name $pin_location]}] {
		# It is possible that we are looking at an advanced device and we got
		# a IOC_X?_Y?_N? type name
		# In that case, we need to go the hard way and build our own map
		if ![info exists ::ioc2pad_db] {
			# For every PAD in the device, use the MCF_NAME to get the XYN location
			# and use it to build a map
			# This function will create a "::ioc2pad_db" map
			initialize_ioc_to_pad_map
		}
		set pad $::ioc2pad_db($pin_location)
	} else {
		# Just assume we have one element in list
		set pad [lindex $pad_list 0]
	}

	# Check if PAD is a VIO or HIO
	set is_vio [expr [get_pad_data BOOL_IS_TOP -pad $pad] || [get_pad_data BOOL_IS_BOTTOM -pad $pad]]

	set io_standard_list [get_pad_data LIST_IO_STANDARDS -pad $pad]

	# Get the IO_STANDARD_DESC for the given pad.
	# Note that a given I/O standard (e.g. 1_8) may have different characteristics
	# depending on its location (VIO Vs. HIO), so the actual IO_STANDARD_DESC string
	# may be either 1_8 or 1_8_SIDE. The following function will return the actual string
	set io_standard_desc [get_pad_data STRING_IO_STD_DESC_NAME -pad $pad -io_standard $io_standard]
	msg_vdebug "IO_STD_DESC( $pad , $io_standard ) = $io_standard_desc"

	if { $is_vio } {
		# If VIO, get INT_VIO_VOLTAGE_TYPE (if it exists)
		if [catch {set voltage_enum [get_pad_data INT_VIO_VOLTAGE_TYPE -io_standard $io_standard_desc]}] {
			# Else, get regular VOLTAGE_TYPE
			set voltage_enum [get_pad_data INT_VOLTAGE_TYPE -io_standard $io_standard_desc]
		}
	} else {
		set voltage_enum [get_pad_data INT_VOLTAGE_TYPE -io_standard $io_standard_desc]
	}

	# All voltages are of the form: <num1>_<num2>_V
	# to represent <num1>.<num2>, so we need to parse the value
	# and build the number
	set vnum_list [split $voltage_enum "_"]
	set voltage 0.0
	if {[llength $vnum_list] == 3} {
		set voltage [expr double([lindex $vnum_list 0].[lindex $vnum_list 1])]
	}

#	msg_vdebug "VCCN( $pin_location $io_standard ) = $voltage"
	return $voltage
} 


# -------------------------------------------------
# -------------------------------------------------

proc get_io_standard_and_voltage { outfile } {
	# Function uses Fitter "Input Pins", "Ouptu Pins" 
    # and "Bidir Pins" panels to access list of pins.
	# It uses pin names to dump a table showing
	# io standard, voltage information
	#
	# Use ::current_part which was the part in CDB_CHIP
# -------------------------------------------------
# -------------------------------------------------


	if ![is_report_loaded] {
		post_message -type error "Internal Error: Report Database is loaded"
		qexit -error
	}

	msg_vdebug "Loading Device for $::current_part"
	load_device -part $::current_part

	# Get Report panel
	set panel_names {"*Input Pins" "*Output Pins" "*Bidir Pins"}
	foreach panel_name $panel_names {
		set panel_id [get_report_panel_id $panel_name]

		if {$panel_id != -1} {
		
			puts $outfile ""
			puts $outfile "\# $panel_name Info"
			puts $outfile ""

			# Get the number of rows
			set row_cnt [get_number_of_rows -id $panel_id]

			msg_vdebug [get_report_panel_row -row 0 -id $panel_id]
			for {set i 1} {$i < $row_cnt} {incr i} {
#				msg_vdebug [get_report_panel_row -row $i -id $panel_id]
				set quartus_name [get_report_panel_data -row $i -col_name "Name" -id $panel_id]
				set hcdc_name [get_hcdc_name $quartus_name]
				set pin_location [get_report_panel_data -row $i -col_name "Pin \#" -id $panel_id]
				set io_standard [get_report_panel_data -row $i -col_name "I/O Standard" -id $panel_id]
				set vccn [get_io_vccn_from_dev_db $pin_location $io_standard]
				# Need to ask PT to propagate ALL clocks
				puts $outfile "Quartus Name = $quartus_name"
				puts $outfile "HCDC Name    = $quartus_name"
				puts $outfile "IO Standard  = $io_standard"
				puts $outfile "VCCN         = ${vccn}V"
				puts $outfile "Location     = $pin_location"
				puts $outfile ""
			}

		} else {
			# Otherwise print an error message
			post_message -type info "No $panel_name panel was found in Fitter Report"
		}
	}

	unload_device
}	

# -------------------------------------------------
# -------------------------------------------------

proc generate_config_file { hcii_rev } {
	# Generates the *<hcii_rev>.extra.config* file
	# containing configuration information.
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global pvcs_revision

		# Open to write
		set output_file_name "$::hc_output/${hcii_rev}.extra.config"
		set outfile [open $output_file_name w]

	puts $outfile "#####################################################################################"
	puts $outfile "#"
	puts $outfile "# Generated by: [info script] $pvcs_revision(main)"
	puts $outfile "# Quartus:      $quartus(version)"
	puts $outfile "#"
	puts $outfile "# Project:      $quartus(project)"
	puts $outfile "# Revision:     $quartus(settings)"
	puts $outfile "#"
	puts $outfile "# Date:         [clock format [clock seconds]]"
	puts $outfile "#"
	puts $outfile "#####################################################################################"
	puts $outfile ""
	puts $outfile ""
	puts $outfile "USER_JTAG_CODE       = [get_global_assignment -name USER_JTAG_CODE_YEAGER]"
	puts $outfile "POWER_ON_EXTRA_DELAY = [get_global_assignment -name HARDCOPYII_POWER_ON_EXTRA_DELAY]"
	puts $outfile ""
	puts $outfile ""

		close $outfile

	post_message -type info "--------------------------------------------------------"
	post_message -type info "Generated $output_file_name"
	post_message -type info "--------------------------------------------------------"
}

# -------------------------------------------------
# -------------------------------------------------

proc generate_iomap_file { hcii_rev } {
	# Function will output a <hcii_rev>.extra.*
	# with different info needed by HCDC verification
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global pvcs_revision

		# Open to write
		set output_file_name "$::hc_output/${hcii_rev}.extra.iomap"
		set outfile [open $output_file_name w]

		puts $outfile "#####################################################################################"
		puts $outfile "#"
		puts $outfile "# Generated by [info script] $pvcs_revision(main)"
		puts $outfile "#   Quartus            : $quartus(version)"
		puts $outfile "#"
		puts $outfile "# Project:  $quartus(project)"
		puts $outfile "# Revision: $quartus(settings)"
		puts $outfile "#"
		puts $outfile "# Date: [clock format [clock seconds]]"
		puts $outfile "#"
		puts $outfile "#####################################################################################"
		puts $outfile ""
		puts $outfile ""

		# Initialize ::name_db with all keeper names and their HC equivalent name
		# This function is the only one that looks at the Atom Netlist and tries
		# to extract all keeper names
		generate_io_names $outfile
		puts $outfile ""
		puts $outfile ""

		close $outfile

		post_message -type info "--------------------------------------------------------"
		post_message -type info "Generated $output_file_name"
		post_message -type info "--------------------------------------------------------"
}

# -------------------------------------------------
# -------------------------------------------------

proc generate_clkmap_file { hcii_rev } {
	# Function will output a <hcii_rev>.extra.*
	# with different info needed by HCDC verification
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global pvcs_revision

	# Open to write
	set output_file_name "$::hc_output/${hcii_rev}.extra.clkmap"
	set outfile [open $output_file_name w]

	puts $outfile "#####################################################################################"
	puts $outfile "#"
	puts $outfile "# Generated by [info script] $pvcs_revision(main)"
	puts $outfile "#   Quartus            : $quartus(version)"
	puts $outfile "#"
	puts $outfile "# Project:  $quartus(project)"
	puts $outfile "# Revision: $quartus(settings)"
	puts $outfile "#"
	puts $outfile "# Date: [clock format [clock seconds]]"
	puts $outfile "#"
	puts $outfile "#####################################################################################"
	puts $outfile ""
	puts $outfile ""

		set report_none "--"
		array set qnames {}
		array set clkmap {}
		foreach revision $::all_revisions {

				# Make sure the current revision is the Stratix II revision
			set current_revision [get_current_revision]
			if {[string compare $current_revision $revision] != 0} { set_current_revision $revision }

				# Load report
			if [catch {load_report $revision} result] {

				# Otherwise print an warning message
				post_message -type warning "No report was found for \"$revision\" revision"
			} else {

				set panel_names [list "*Global & Other Fast Signals"]
				foreach panel_name $panel_names {
					set panel_id [get_report_panel_id $panel_name]

					if {$panel_id != -1} {

						# Get the number of rows
						set row_cnt [get_number_of_rows -id $panel_id]

						msg_vdebug [get_report_panel_row -row 0 -id $panel_id]
						for {set i 1} {$i < $row_cnt} {incr i} {
							#msg_vdebug [get_report_panel_row -row $i -id $panel_id]
							set quartus_name [get_report_panel_data -row $i -col_name "Name" -id $panel_id]
							set gclk [get_report_panel_data -row $i -col_name "Global Line Name" -id $panel_id]

							if {[string compare $gclk $report_none] != 0} {
								lappend clkmap([list $quartus_name $revision]) $gclk
								set qnames($quartus_name) 1
							}
						}

					} else {

						# Otherwise print an warning message
						post_message -type warning "No $panel_name panel was found in Fitter Report for \"$revision\" revision"
					}
				}

					# Unload report
				unload_report $revision
			}

				# Reset the current revision to the original one
			if {[string compare $current_revision $revision] != 0} { set_current_revision $current_revision }
		}

		foreach quartus_name [lsort -dictionary [array names qnames]] {
		
			puts $outfile "Quartus Name = $quartus_name"
			foreach revision $::all_revisions {
			
				if {[string compare $revision $::fpga_rev] == 0} {
					set label "SII Clock   "
				} else {
					set label "HCII Clock  "
				}
				if {[string length [array names clkmap [list $quartus_name $revision]]] > 0} {
					set cnt 0
					foreach gclk $clkmap([list $quartus_name $revision]) {
					
						if {$cnt == 0} {
							puts -nonewline $outfile "$label = $gclk"
						} else {
							puts -nonewline $outfile ", $gclk"
						}
						incr cnt
					}
					puts $outfile ""
				} else {
					puts $outfile "$label = NOT_FOUND"
				}
			}
			puts $outfile ""
		}

	puts $outfile ""
	puts $outfile ""

	close $outfile

	post_message -type info "--------------------------------------------------------"
	post_message -type info "Generated $output_file_name"
	post_message -type info "--------------------------------------------------------"

}

# -------------------------------------------------
# -------------------------------------------------

proc generate_mcfd_file { fpga_rev } {
	# Function will output a <fpga_rev>.mcfd.asmre
	# by calling "quartus_asm --dump_mcfd_asmre_file"
# -------------------------------------------------
# -------------------------------------------------

	set success 1

        # Make sure the current revision is the Stratix II revision
	set current_revision [get_current_revision]
	if {[string compare $current_revision $fpga_rev] != 0} { set_current_revision $fpga_rev }

	# Open to write
	set asmre_file "${fpga_rev}.mcfd.asmre"
	set hc_asmre_file "$::hc_output/$asmre_file"
		# We only care about the sof and rpt files
		# We don't need to preserve the pof file.
	set asm_files [list ${fpga_rev}.sof ${fpga_rev}.asm.rpt]
		# Here, we temporarily move asm files into db/ directory
	foreach i $asm_files {
		catch {file rename -force $i db/$i} result
	}

		# create the mcfd file
	post_message "Running Quartus II Assembler"
	if [catch {execute_module -tool asm -args "--ini=asm_bypass_opencore_log=on --dump_mcfd_asmre_file --disable_all_banners"} result] {
		set success 0
	} elseif [file exists $asmre_file] {
		catch {file rename -force $asmre_file $hc_asmre_file} result
	}

	if [file exists $hc_asmre_file] {
		post_message -type info "--------------------------------------------------------"
		post_message -type info "Generated $hc_asmre_file"
		foreach i $asm_files {
			catch {file copy -force $i $::hc_output/$i} result
			if [file exists $::hc_output/$i] {
				post_message -type info "Generated $::hc_output/$i"
			}
		}
		post_message -type info "--------------------------------------------------------"
	} else {
		set success 0
	}

	if {!$success} {
		post_message -type error "Can't generate $hc_asmre_file"
	}

		# Revert back to the original file path
	foreach i $asm_files {
		catch {file rename -force db/$i $i} result
	}

		# Reset the current revision to the original one
	if {[string compare $current_revision $fpga_rev] != 0} { set_current_revision $current_revision }
}

# -------------------------------------------------
# -------------------------------------------------

proc generate_astro_routing_file { hcii_rev } {
	# Generates <hcii_rev>.qref.(tcl|nets) files.
# -------------------------------------------------
# -------------------------------------------------

		# output file name
	set output_files [list $::hc_output/${hcii_rev}.qref.tcl $::hc_output/${hcii_rev}.qref.nets]

		# create output file
	post_message "Running [lindex [get_all_builtin_flows -debug_name hc_astro_routing -pretty] 0]"
	if [catch {execute_module -tool cdb -args "--hc_astro_routing --disable_all_banners"} result] {
		post_message -type error $result
	} else {
		foreach i $output_files {
			if {![file exists $i]} {
				post_message -type error "Can't generate $i"
			}
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc check_device_is_legal { hcii_rev } {
# Check if device is legal
# -------------------------------------------------
# -------------------------------------------------

    global supported_family

    set revision hcii_rev
    array set supported_family_name { }

    set success 1
    foreach current_family $supported_family {
        set supported_family_name([get_dstr_string -family $current_family]) $current_family
    }

    set family [get_global_assignment -name FAMILY]

    if { [catch {set family [get_dstr_string -family $family]}] } {
        hardcopy_msgs::post E_ILLEGAL_FAMILY_NAME $family
	set success 0

    } elseif { [info exists supported_family_name($family)] }  {
    	set part [get_global_assignment -name DEVICE]

        if { ![string equal -nocase $part AUTO] } {
            if { [catch {set part_family [lindex [get_part_info $part -family] 0]} result] || ![string equal -nocase $part_family $family] } {
    		    post_message -type info "Part name $part is illegal -- specify a target device part belonging to the $family device family for the revision $hcii_rev"
                    set success 0
            }
        }
         } else {

                post_message -type info "$family is not require the clock info file generation"
                set success 0
    }
    return $success
}

# -------------------------------------------------
# -------------------------------------------------

proc generate_clkinfo_file { hcii_rev } {
# Generates <hcii_rev>.clkinfo.txt files.
# Descriptions
#             1. Load the Control Signals Table and get the following info
#                a. Clock Name
#                b. Global Line Name
#                c. Usage
#             2. Load the Clock Table and get the following info
#                a. Clock Name
#                b. Clock Frequency
#  Then store all Control Signal which is using the Global Line into clkinfo file
# -------------------------------------------------
# -------------------------------------------------
	global quartus
	global pvcs_revision
	#array set qnames {}
	#array set clkinfo {}
	#array set fmax {}
	
        # Open to write
	set output_file_name "$::hc_output/${hcii_rev}.extra.clkinfo"
	set outfile [open $output_file_name w]

	puts $outfile "#####################################################################################"
	puts $outfile "#"
	puts $outfile "# Generated by: [info script] $pvcs_revision(main)"
	puts $outfile "# Quartus:      $quartus(version)"
	puts $outfile "#"
	puts $outfile "# Project:      $quartus(project)"
	puts $outfile "# Revision:     $quartus(settings)"
	puts $outfile "#"
	puts $outfile "# Date:         [clock format [clock seconds]]"
	puts $outfile "#"
	puts $outfile "#####################################################################################"
	puts $outfile ""
	puts $outfile ""
        # Start retrieving infomation from Control Signal Table
        # Make sure the report file is exist
        set report_none "--"

        set no_clkinfo ""
        # Load report
        if [catch {load_report} result] {
      		# Otherwise print an warning message
		post_message -type warning "No report was found for \"$hcii_rev\" revision"
		set no_clkinfo 1
        } else {
                #Look through Global $ Other Fast Signals table
                set panel_name1 "Fitter||Resource Section||Global & Other Fast Signals"
                set panel_id1 [get_report_panel_id $panel_name1]

                if { $panel_id1 != -1 } {
                    set row_cnt [get_number_of_rows -id $panel_id1]
                    for {set i 1} {$i < $row_cnt} {incr i} {
                        set quartus_name [get_report_panel_data -row $i -col_name "Name" -id $panel_id1]
                        set global_line_name [get_report_panel_data -row $i -col_name "Global Line Name" -id $panel_id1]
                        lappend global_name($quartus_name) [list "$global_line_name"]
                    }

                #Look through Control Signals table
                set panel_name2 "Fitter||Resource Section||Control Signals"
                set panel_id2 [get_report_panel_id $panel_name2]

                if { $panel_id2 != -1 } {
                    set row_cnt [get_number_of_rows -id $panel_id2]
                    foreach name [array names global_name] {
                        set match 0
                        for {set i 1} {$i < $row_cnt} {incr i} {
                            set quartus_name [get_report_panel_data -row $i -col_name "Name" -id $panel_id2]

                            if [string equal -nocase $name $quartus_name] {
                                set match 1
                                set usage [get_report_panel_data -row $i -col_name "Usage" -id $panel_id2]
                                lappend control_signal($name) [list "$usage"]
                            }
                        }
                        if { $match == 0 } {
                            lappend control_signal($name) "N/A"
                        }
                    }
                } else {
                    post_message -type warning "No $panel_name2 panel was found in Fitter Report"
                    foreach name [array names global_name] {
                        lappend control_signal($name) "N/A"
                    }
                }
                
                #Look through TQ Clocks table
                set panel_name3 "TimeQuest Timing Analyzer||Clocks"
                set panel_id3 [get_report_panel_id $panel_name3]

                if { [catch {set row_cnt [get_number_of_rows -id $panel_id3]}] } {
                    post_message -type warning "No $panel_name3 panel was found in Fitter Report"
                    foreach name [array names global_name] {
                        lappend sta($name) "N/A"
                    }
                } else {
                    foreach name [array names global_name] {
                        set match 0
                        for {set i 1} {$i < $row_cnt} {incr i} {
                            set quartus_name [get_report_panel_data -row $i -col_name "Targets" -id $panel_id3]
                            regsub -all -nocase "{" $quartus_name "" quartus_name
                            regsub -all -nocase "}" $quartus_name "" quartus_name
                            regsub -all -nocase " " $quartus_name "" quartus_name

                            if [string equal -nocase $name $quartus_name] {
                                set match 1
                                set frequency [get_report_panel_data -row $i -col_name "Frequency" -id $panel_id3]
                                lappend sta($name) [list "$frequency"]
                            }
                        }

                        if { $match == 0 } {
                            lappend sta($name) "N/A"
                        }
                    }
                }

                #Print the data to *.extra.clkinfo
                foreach quartus_name [lsort -dictionary [array names global_name]] {
                    puts -nonewline $outfile "Quartus Name = $quartus_name"
                    puts -nonewline $outfile "\t Global Line Name = $global_name($quartus_name)"
                    puts -nonewline $outfile "\t Data Type = $control_signal($quartus_name)"
                    set frequency $sta($quartus_name)
                    regsub -all -nocase "{" $frequency "" frequency
                    regsub -all -nocase "}" $frequency "" frequency
                    puts -nonewline $outfile "\t Clock Frequency = $frequency"
                    puts $outfile ""
                }
            } else {
                post_message -type warning "No $panel_name1 panel was found in Fitter Report"
            }
        }

	puts $outfile ""
	puts $outfile ""
	close $outfile

        if { $no_clkinfo != 1} {
	   post_message -type info "--------------------------------------------------------"
	   post_message -type info "Generated $output_file_name"
   	   post_message -type info "--------------------------------------------------------"
       } else {
           post_message -type warning "$output_file_name is NOT generated due to missing Report Table"
       }

}
# -------------------------------------------------
# -------------------------------------------------

proc main {} {
	# Script starts here
	# 1.- Process command-line arguments
	# 2.- Open project
	# 3.- Read Atom Netlist
	# 4.- Call functions to map assignments
	# 5.- Close Atom Netlist and Project
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global options

	# ---------------------------------
	# Print some useful infomation
	# ---------------------------------
	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "[file tail [info script]] version: $::pvcs_revision(main)"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"

	# Check arguments
	# Need to define argv for the cmdline package to work
	set argv0 "quartus_cdb -t [file tail [info script]]"
	set usage "\[<options>\]:"

	set argument_list $quartus(args)

	# Use cmdline package to parse options
	if [catch {array set options [cmdline::getoptions argument_list $::available_options]} result] {
		if {[llength $argument_list] > 0 } {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Illegal Options"
			post_message -type error  [::cmdline::usage $::available_options $usage]
			qexit -error
		} else {
			post_message -type info  "Usage:"
			post_message -type info  [::cmdline::usage $::available_options $usage]
			qexit -success
		}
	}

	# cmdline::getoptions is going to modify the argument_list.
	# Note however that the function will ignore any positional arguments
	# We are expecting no positional arguments
	# so give an error if the list has more than one element
	if {[llength $argument_list] >= 1} {

		# The first argument MUST be the project name
		set options(project_name) [lindex $argument_list 0]

		if [string compare [file extension $options(project_name)] ""] {
			set project_name [file rootname $options(project_name)]
		}

		set project_name [file normalize $options(project_name)]

		msg_vdebug  "Project = $project_name"

		project_open $project_name

#		post_message -type error "Found unexpected positional argument: $argument_list"
#		post_message -type info [::cmdline::usage $::available_options $usage]
#		post_message -type info "For more details, use \"quartus_cdb --help=hc_extra\""
#		qexit -error
	}

	# Script may be called from Quartus or another script where the project
	# is already open
	if {![is_project_open]} {

		post_message -type error "No open project was found"
		post_message -type info [::cmdline::usage $::available_options $usage]
		qexit -error
	}

	set verbose [get_ini_var -name hcii_pt_verbose]
	if { [string equal -nocase $verbose ON] } {
		set ::options(verbose) 1
	} else {
		set ::options(verbose) 0
	}

	if {[is_project_open]} {

		set project_name $quartus(project)
		set hcii_rev $quartus(settings)
		msg_vdebug  "Project  = $project_name"
		msg_vdebug  "Revision = $hcii_rev"

		# Get the directory to use when outputing files
		if [catch {set ::hc_output [get_global_assignment -name HC_OUTPUT_DIR]}] {
			post_message -type warning "No HC_OUTPUT_DIR QSF variable defined. Defaulting to $::hc_output"
		} else {
			post_message -type info "Using HC_OUTPUT_DIR = \"$::hc_output\""
		}

		# Get the directory to use when outputing files
		set ::fpga_rev ""
		if {[catch {set ::fpga_rev [get_global_assignment -name COMPANION_REVISION_NAME]}] || [string compare $::fpga_rev ""] == 0} {
			post_message -type warning "No COMPANION_REVISION_NAME QSF variable defined. FPGA specific files will not be generated"
		} else {
			post_message -type info "Using COMPANION_REVISION_NAME = \"$::fpga_rev\""
			lappend ::all_revisions $::fpga_rev
		}
		lappend ::all_revisions $hcii_rev

		if ![file exists $::hc_output] {
			post_message -type info "Creating $::hc_output directory"
			file mkdir $::hc_output
		}

		# Generate I/O mapping
		generate_iomap_file $hcii_rev

		# Generate Configuration information
		generate_config_file $hcii_rev

		# Generate astro routing
		generate_astro_routing_file $hcii_rev

                # Generate clk info file (maining for HCX)
                if [check_device_is_legal $hcii_rev] {
                	generate_clkinfo_file $hcii_rev
               	}

                # Generate FPGA related information
		if {[string compare $::fpga_rev ""] != 0} {

			# Generate Clock mapping only if fpga exists
			generate_clkmap_file $hcii_rev

			# Generate MCFD file using quartus_asm
			generate_mcfd_file $::fpga_rev
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
main
# -------------------------------------------------
# -------------------------------------------------
