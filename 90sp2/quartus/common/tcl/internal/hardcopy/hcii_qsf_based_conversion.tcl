set pvcs_revision(qsf_based_conversion) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: hcii_qsf_based_conversion.tcl
#
# Used by hcii_pt_script.tcl
#
# Description:
#		This file defines hcii_qsf_based_conversion namespace that contains
#		all the codes to do q2p translation from *.qsf file (and TAN report).
#
# Note:	Obsolete. Replaced by hcii_tan_based_conversion.tcl.
#
# **************************************************************************


# --------------------------------------------------------------------------
#
namespace eval hcii_qsf_based_conversion {
#
# Description:	Define the namespace and interal variables.
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!!  To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
	# Timing assignment value types
	# Constants, allowed to be directly accessed. 
	array set asgn_value_type { \
		none	0 \
		bool	1 \
		int		2 \
		time	3 \
	}
	
	array set min_input_array { }
        array set max_input_array { }
        array set min_output_array { }
        array set max_output_array { }
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::get_node_type_from_key { key } {
	# Return the <node_type> from the passed key in the form of
	# <node_type>-<qname>.
	#
	# Obsolete.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set dash [string first "-" $key]
	if { $dash < 0 } {
		post_message -type error "Invalid key: $key"
		qexit -error
	}
	set start 0
	set end [expr $dash - 1]
	set result [string range $key $start $end]
	return $result
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::get_qname_from_key { key } {
	# Return the <qname> from the passed key in the form of
	# <node_type>-<qname>.
	#
	# Obsolete.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set dash [string first "-" $key]
	if { $dash < 0 } {
		post_message -type error "Invalid key: $key"
		qexit -error
	}
	set start [expr $dash + 1]
	set end [string length $key]
	set result [string range $key $start $end]
	return $result
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::make_p_coll_cmd { coll_id node_type coll_str } {
	# Make a PrimeTime collection command for the specified
	# node type and name string.
	#
	# Obsolete.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set cmd ""
	set coll_name [get_name_for_collection $coll_id]
	set coll_str [string trim $coll_str]
	set node_type_upper [string toupper $node_type]
        switch -exact -- $node_type_upper {
			"CLK" {
				set cmd "set $coll_name \[ get_clocks \{ $coll_str \} \]"
			}
			"KPR" {
				set cmd "set $coll_name \[ get_cells \{ $coll_str \} \]"
			}
			"IPIN" -
			"OPIN" {
				set cmd "set $coll_name \[ get_ports \{ $coll_str \} \]"
			}
			default { 
				post_message -type error "Invalid node type: $node_type"
				qexit -error
			}
        }

        return $cmd
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::convert_global_settings { } {
	# Call hcii_tan_based_conversion::convert_global_settings.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	hcii_tan_based_conversion::convert_global_settings
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::convert_clocks { } {
	# Function uses "Clock Settings Summary" panel of TAN report to find all
	# clock settings and generate Primetime clocks.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	post_message -type info "** Processing Clock Settings"

	hcii_util::formatted_write $outfile "
		
		
		##########
		# Clocks #
		##########
	"

	# Get Report panel
	set panel_name "*Clock Settings Summary"
	set panel_id [get_report_panel_id $panel_name]
	set clock_settings_exist 0

	if {$panel_id != -1} {
		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		# First initialize clock setting to clock signal to clock base maps
		for {set i 1} {$i < $row_cnt} {incr i} {
			set clk_node_name    [get_report_panel_data -row $i -col_name "Clock Node Name" -id $panel_id]
			set base_clk_setting [get_report_panel_data -row $i -col_name "Based on" -id $panel_id]
			set based_on $base_clk_setting
			set base_clk_setting_key $base_clk_setting

			set clk_setting_name "--"
			catch {set clk_setting_name [get_report_panel_data -row $i -col_name "Clock Setting Name" -id $panel_id]}

			# For a clock doesn't have both clock setting and base clock
			# setting, we need to name a created (artifitial) clock setting
			# as the clock node name. This can happen for PLL input clock
			# signals. We need a clock setting in order to generate PT
			# source of create_generated_clock.
			if [string equal $base_clk_setting "--"] {
				if {$clk_setting_name == "--"} {
					post_message -type info "Clock node $clk_node_name does not have a clock setting. Default it to $clk_node_name."
					set clk_setting_name $clk_node_name
				}
			}

			if [string equal $base_clk_setting_key "--"] {
			        set base_clk_setting_key $clk_setting_name
			}

                        set ::clk_node_2_base_clk_setting($clk_node_name) $base_clk_setting_key
			set ::array_of_base_clock_settings($base_clk_setting_key) 1
			set ::clk_signal2base_clk_setting($clk_node_name) $base_clk_setting

			if {$based_on == "--"} {
				if {[info exists ::clk_base_clk_setting2signal($clk_setting_name)]} {
					post_message -type warning "Base clk setting, $clk_setting_name, is already associated with clock signal, $::clk_base_clk_setting2signal($clk_setting_name)."
					post_message -type info "Please make each clock signal an individual clock setting in Quartus."
				} else {
					set ::clk_base_clk_setting2signal($clk_setting_name) $clk_node_name
				}
			}
		}
		# N/A base_clk_setting mapping to N/A clock signal.
		set ::clk_base_clk_setting2signal(--) "--"

		msg_vdebug "Base clock settings: [array name ::array_of_base_clock_settings]"
		msg_vdebug "Clock node - base clock setting: [array get ::clk_signal2base_clk_setting]"
		msg_vdebug "Base clock setting - clock node: [array get ::clk_base_clk_setting2signal]"

		msg_vdebug [get_report_panel_row -row 0 -id $panel_id]
		for {set i 1} {$i < $row_cnt} {incr i} {
			msg_vdebug [get_report_panel_row -row $i -id $panel_id]
			set clock(clk_node_name) [get_report_panel_data -row $i -col_name "Clock Node Name" -id $panel_id]
			set clock(clk_setting_name) $clock(clk_node_name)
			catch {set clock(clk_setting_name) [get_report_panel_data -row $i -col_name "Clock Setting Name" -id $panel_id]}
			set clock(clk_type) [get_report_panel_data -row $i -col_name "Type" -id $panel_id]
			set clock(clk_fmax) [get_report_panel_data -row $i -col_name "Fmax Requirement" -id $panel_id]
			if {[string equal $clock(clk_fmax) "None"]} {
				set clock(clk_fmax) "0 ns"
			}
			set base_clk_setting $::clk_signal2base_clk_setting($clock(clk_node_name))
			set clock(base) $::clk_base_clk_setting2signal($base_clk_setting)
			set clock(multiply_by) [get_report_panel_data -row $i -col_name "Multiply Base Fmax by" -id $panel_id]
			set clock(divide_by) [get_report_panel_data -row $i -col_name "Divide Base Fmax by" -id $panel_id]
			set clock(offset) [get_report_panel_data -row $i -col_name "Offset" -id $panel_id]
			if {$clock(offset) == "--" || $clock(offset) == "N/A" || $clock(offset) == "AUTO"} {
				set clock(offset) 0
			} else {
				set clock(offset) [hcii_util::get_time_value $clock(offset)]
			}

			set clock(phase) 0
			catch {set clock(phase) [get_report_panel_data -row $i -col_name "Phase offset" -id $panel_id]}
			set clock(early_latency) [get_report_panel_data -row $i -col_name "Early Latency" -id $panel_id]
			set clock(late_latency) [get_report_panel_data -row $i -col_name "Late Latency" -id $panel_id]

			# We don't know the duty cycle, assume 50 percent for now
			set clock(duty) 50
			# We don't know about inverted base, assume not inverted for now
			set clock(inv) "NONE"

			if [string equal $clock(clk_fmax) "NONE"] {
				post_message -type critical_warning "Clock \'$clock(clk_node_name)\' has no performance requirement"
			} else {
				set clock(period) [hcii_util::get_time_value $clock(clk_fmax)]
				if { $::options(verbose) } { 
					post_message -type extra_info "----------------------------------------"
					post_message -type extra_info "Processing Clock : $clock(clk_node_name)"

					foreach index [array names clock] {
						post_message -type extra_info "--> $index : $clock($index)"
					}
				}
				puts $outfile "# ----------------------------------------"
				foreach index [array names clock] {
					puts $outfile "# --> $index : $clock($index)"
				}

				switch  -exact -- $clock(clk_type) {
					"User Pin" {
						if [string equal $clock(base) "--"] {
							hcii_qsf_based_conversion::create_base_clock clock $outfile
						} else {
							hcii_qsf_based_conversion::create_derived_clock clock $outfile
						}
						set clock_settings_exist 1
					}
					"Internal Node" {
						if { $clock(base) == "NONE" } {
							hcii_qsf_based_conversion::create_base_clock clock $outfile
						} else {
							hcii_qsf_based_conversion::create_derived_clock clock $outfile
						}
						set clock_settings_exist 1
					}
					"PLL output" {
						# Since we're using latency, PLL offset is zero by definition
						set $clock(offset) 0
						hcii_qsf_based_conversion::create_generated_clock_for_pll clock $outfile
						puts $outfile ""

						set clock_settings_exist 1
					}
					default { post_message -type error "Ignoring unsupported clock type (Notify David Karchmer)" }
				}
			}
		}
		
		# Need to ask PT to propagate ALL clocks
		hcii_util::write_command "set_propagated_clock \[all_clocks\]"
	} else {
		# Otherwise print an error message
		post_message -type info "No clocks were found in Timing Analysis Report"
	}

	if {!$clock_settings_exist} {
		post_message -type critical_warning "No Clock Settings defined"
	}
}	


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::generate_output_pin_loadings { } {
	# Use Fitter "Output Pins" and "Bidir Pins" panels to get output pin
	# loadings to generate PrimeTime "set_load" commands.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	# Get Report panels.
	set rpt_name "Fitter report"
	set panel_names {"*Output Pins" "*Bidir Pins"}
	foreach panel_name $panel_names {
		set panel_id [get_report_panel_id $panel_name]
		if {$panel_id != -1} {
			set header_line_1 "#############################################"
			set header_line_2 "# [string range $panel_name 1 end] Loadings #"
			set header_line_len [string length $header_line_2]

			hcii_util::formatted_write $outfile "


				[string range $header_line_1 1 $header_line_len]
				$header_line_2
				[string range $header_line_1 1 $header_line_len]
			"

			# Get the number of rows
			set row_cnt [get_number_of_rows -id $panel_id]

			msg_vdebug [get_report_panel_row -row 0 -id $panel_id]
			for {set i 1} {$i < $row_cnt} {incr i} {
				set pin_name [get_report_panel_data -row $i -col_name "Name" -id $panel_id]
				if {$::is_sta_flow} {
				       # STA Flow will use timequest2p_name_db database to obtain the pt name
				       set p_signal_name  [hcii_name_db::get_pt_name_from_timequest_db $pin_name]
				} else {
				       set p_signal_name [hcii_collection::get_p_name_or_collection $outfile OPIN $pin_name 1]
				}
				set pin_location [get_report_panel_data -row $i -col_name "Pin \#" -id $panel_id]

				# Get the Load value and remove the unit.
				set load [lindex [get_report_panel_data -row $i -col_name "Load" -id $panel_id] 0]

				# Generate the output pin load PrimeTime script.
				puts $outfile "# Pin $pin_name ( Location = $pin_location )"
				hcii_util::write_command "set_load -pin_load $load $p_signal_name"
			}
		}
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::get_custom_input_transition_time { p_signal_name } {
	# Function will iterate though all quartus assignments
	# of type INPUT_TRANSITION_TIME and return the value specified for p_signal_name
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	set input_transition_time -1
	set assignment_list [get_all_instance_assignments -name INPUT_TRANSITION_TIME]
	foreach_in_collection assignment $assignment_list {
		set to		[lindex $assignment 2]
		set value [hcii_util::get_time_value [lindex $assignment 4]]

		if { $to != "" } {
                        if {$::is_sta_flow} {
			        set pin_list [hcii_name_db::get_pt_name_from_timequest_db $to]
                        } else {
			       set pin_list [hcii_collection::get_p_name_or_collection $outfile IPIN $to 0]
			        # It is possible for a pin to not be found in the IPIN list
			        # if the pin name represents a clock, so try again in the CLK list
			        if { $pin_list == "" } {
				     set pin_list [hcii_collection::get_p_name_or_collection $outfile CLK $to 0]
			        }
                         }
			foreach pin_list_member $pin_list {
				if { $pin_list_member == $p_signal_name } {
					set input_transition_time $value
				}
			}
		}
	}

	return $input_transition_time
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::generate_input_pin_transitions { } {
	# Use Fitter "Input Pins" and "Bidir Pins" panels to access list of input
	# pins. It uses pin names to generate PrimeTime set_input_transition
	# commands.
	# To compute the transition time, use this formula
	#	(VCCN * 1ns/1V * 80%)
	# where VCCN is I/O standard dependent.
	#
	# Use ::current_part which was the part in CDB_CHIP.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	msg_vdebug "Loading Device for $::current_part"
	load_device -part $::current_part

	# Get Report panels.
	set rpt_name "Fitter report"
	set panel_names {"*Input Pins" "*Bidir Pins"}
	foreach panel_name $panel_names {
		set panel_id [get_report_panel_id $panel_name]
		if {$panel_id != -1} {
			set header_line_1 "################################################"
			set header_line_2 "# [string range $panel_name 1 end] Transitions #"
			set header_line_len [string length $header_line_2]
			hcii_util::formatted_write $outfile "
				
				
				[string range $header_line_1 1 $header_line_len]
				$header_line_2
				[string range $header_line_1 1 $header_line_len]
			"

			# Get the number of rows
			set row_cnt [get_number_of_rows -id $panel_id]

			for {set i 1} {$i < $row_cnt} {incr i} {
				set pin_name [get_report_panel_data -row $i -col_name "Name" -id $panel_id]
			
                        	if {$::is_sta_flow} {
				     set p_signal_name [hcii_name_db::get_pt_name_from_timequest_db $pin_name]
                                } else {
				set p_signal_name [hcii_collection::get_p_name_or_collection $outfile IPIN $pin_name 1]
				# It is possible for a pin to not be found in the IPIN list
				# if the pin name represents a clock, so try again in the CLK list
				if {$p_signal_name == ""} {
					set p_signal_name [hcii_collection::get_p_name_or_collection $outfile CLK $pin_name 1]
				}
				}
                                
				set pin_location [get_report_panel_data -row $i -col_name "Pin \#" -id $panel_id]

				# Use INPUT_TRANSITION_TIME acf value if exist, othewise use default
				set custom_value [get_custom_input_transition_time $p_signal_name]
				if { $custom_value >= 0 } {
					# Use INPUT_TRANSITION_TIME acf value
					set transition $custom_value
					puts $outfile "# Pin $pin_name ( Custom ( value=$transition ) - Location: $pin_location )"
					hcii_util::write_command "set_input_transition $transition $p_signal_name"
				} else {
					set io_standard [get_report_panel_data -row $i -col_name "I/O Standard" -id $panel_id]
					set vccn [hcii_qsf_based_conversion::get_io_vccn_from_dev_db $pin_location $io_standard]

					set vid ""
					switch -exact -- $io_standard {
						"LVDS" {
							set vid 0.35
							}
						"HyperTransport" {
							set vid 0.6
							}
						"Differential LVPECL" {
							set vid 0.6
							}
						}

					# Calculation for differential (use VID) or single-ended (use VCCN) I/O standard
					if { [llength $vid] > 0 } {
						# Use "VID * 80%" to compute transition time
						set transition [expr double($vid) * 0.80]
						puts $outfile "# Pin $pin_name ( $io_standard ( VID=${vid}ns ) - Location: $pin_location )"
						hcii_util::write_command "set_input_transition $transition $p_signal_name"
					} else {
						# Use "VCCN * 1ns/1V * 80%" to compute transition time
						set transition [expr double($vccn) * 0.80]
						# Need to ask PT to propagate ALL clocks
						puts $outfile "# Pin $pin_name ( $io_standard ( VCCN=${vccn}V ) - Location: $pin_location )"
						hcii_util::write_command "set_input_transition $transition $p_signal_name"
					}
				}
			}
		}
	}

	unload_device
}	


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::get_io_vccn_from_dev_db { pin_location io_standard } {
	# Using the ATOM's location (in the report), get the device PIN.
	# From the PIN, get the PAD. Using the ATOM's io-std-enum (in the report), 
	# and the device PAD get the io-std-descriptor.
	# A pad will be either HIO (left or right) or VIO (top or bottom).
	# If the pad is HIO then use INT_VOLTAGE_TYPE
	# If the pad is VIO then use INT_VIO_VOLTAGE_TYPE if it exists 
	# else use DEV_IO_STANDARD_DESC_INT_VOLTAGE_TYPE.
	#
	# Assumption: The device has been loaded
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
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
		# If VIO, get INT_VIO_VOLTAGE_TYPE (if it exist)
		if [catch {set voltage_enum [get_pad_data INT_VIO_VOLTAGE_TYPE -io_standard $io_standard_desc]}] {
			# Else, get regular VOLTAGE_TYPE
			set voltage_enum [get_pad_data INT_VOLTAGE_TYPE -io_standard $io_standard_desc]
		}
	} else {
		set voltage_enum [get_pad_data INT_VOLTAGE_TYPE -io_standard $io_standard_desc]
	}

	# All voltages are of the form: <num1>_<num2>_V to represent <num1>.<num2>,
	# so we need to parse the value and build the number.
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

proc hcii_qsf_based_conversion::get_pll_edges { divide_by } {
	# Function to generate required edges based on the
	# divide_by factor
	# divide = 1: edges = 1 2 3
	# divide = 2: edges = 1 3 5
	# divide = 3: edges = 1 5 9
	# Basically:
	#    1 1+2^divide-1 1+2^divide
# -------------------------------------------------
# -------------------------------------------------
	if { $divide_by == 1 } {
		return "1 2 3"
	}
	set edges "1"
	set adder 1
	for { set i 1} {$i < $divide_by} {incr i } {
		set adder [expr $adder * 2]
	}
	append edges " [expr $adder + 1]"
	set adder [expr $adder * 2]
	append edges " [expr $adder + 1]"

	return $edges
}

# -------------------------------------------------
# -------------------------------------------------
proc hcii_qsf_based_conversion::create_generated_clock_for_pll { clock_setting outfile } {
	# Function to dump a create_generated_clock statement for a Quartus
	# PLL
	# A generated clock is needed for PrimeTime to consider the compensation
	# delay as part of the clock network. 
	# This equivalent to what Quartus achieves by auto-computing Clock
	# Latency. In other words, create_generated_clock is equivalent
	# to using a create_clock plus a Clock Latency set to thde 
	# compensation delay.
# -------------------------------------------------
# -------------------------------------------------
	upvar $clock_setting clock

	set p_signal_name [hcii_collection::get_p_name_or_collection $outfile CLK $clock(clk_node_name) 1]

	if {$p_signal_name == ""} {
		# Something is really bad. All PLL clocks should be marked as clocks by now
		post_message -type error "IE: $clock(clk_node_name) not found in CLK cache"
		qexit -error
	}
	msg_vdebug "Q = $clock(clk_node_name) >>> PT = $p_signal_name"
	set ::name_db(clk-$clock(clk_node_name)) $p_signal_name

	set base_pt_clock [hcii_collection::get_p_name_or_collection $outfile KPR $clock(base) 1]
	if [string equal $base_pt_clock ""] {
		msg_vdebug "PT name not found for base clock $clock(base)"
		# The base clock name is different from the base signal name
		# so the names database did not find a match
		# In this case, assume we can just use the base clock setting name
		# Note that it is possible the name is not PT compatible, but we are
		# making an educated guess that it is not likely the case. And if it is,
		# well, HCDC will have to fix it.
		set base_pt_clock $clock(base)
	}
	
	# Since we're using latency, there is by definition no PLL offset

	
	# The following weird code will check if the PLL uses only one of the following:
	#   multiply factor, divide factor, phase
	# If so, then we call it the complexity level will be 1 and we can use the 
	# simple_level_options, which will be one of "-multiple ?", "-divide ?" or
	# "-edges ... -edge_shift".
	# Note that life is this hard because PT only supports one of these options
	# at a time.
	# If complexity level is > 1, then we will use -edge_shift to shift in or out
	# both the half and full period edges, and with it, form the resulting waveform
	set complex_level 0
	set simple_level_options ""
	set offset1 0.0
	if { [expr $clock(phase) != 0.0] } { 
		incr complex_level
		puts $outfile "\# PLL Phase = $clock(phase) --> Offset = $offset1 ns"

		set offset1 [expr double($clock(period)) * double($clock(phase)) / 360.0] 
		set simple_level_options "-edges \{[hcii_qsf_based_conversion::get_pll_edges 1]\} -edge_shift \{$offset1 $offset1 $offset1\}"
	}
	if { [expr $clock(multiply_by) > 1] } { 
		incr complex_level 
		set simple_level_options "-multiply $clock(multiply_by)"
	}
	if { [expr $clock(divide_by) > 1] } { 
		incr complex_level 
		set simple_level_options "-divide $clock(divide_by)"
	}
	if { $complex_level > 1 } {

		# This is a complex PLL and we will manually compute the 
		# half and full period edges and use -edge_shift to build
		# the resulting waveform

		set period [ expr double($clock(period))]
		set base_period [expr $period * double($clock(multiply_by)) / double($clock(divide_by))]
		set offset3 [expr $offset1 + $period - $base_period]
		set base_clock_high [expr $base_period / 2]
		set clock_high [expr $period * $clock(duty) / 100.0 ]
		set offset2 [expr $offset1 + $clock_high - $base_clock_high]
		hcii_util::formatted_write $outfile "
			# Base Period = $base_period PLL Out Period = $period
			# Base Clock High = $base_clock_high PLL Out Clock High = $clock_high
			# Edge Shift: $offset1 $offset2 $offset3
		"

		hcii_util::write_command "create_generated_clock -edges \{[hcii_qsf_based_conversion::get_pll_edges 1]\} -edge_shift \{$offset1 $offset2 $offset3\} -source $base_pt_clock -name $p_signal_name $p_signal_name"
	} else {
		# This is a simple case
		if { $complex_level == 0 } {

			# This is the case where multiply = 1, divide = 1 and offset = 0
			# Just use multiply = 1
			set simple_level_options "-multiply 1"
		}

		# We will use one (and only one) of the following options:
		# -multiply value
		# -divide value
		# -edge { 1 2 3 } -edge_shift { offset offset offset }
		# simple_level_options hold one of this options
		hcii_util::write_command "create_generated_clock $simple_level_options -source $base_pt_clock -name $p_signal_name $p_signal_name"
	}

	puts $outfile ""
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::create_derived_clock { clock_ref outfile} {
	# Create a PrimeTime derived clock for a Quartus derived clock.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $clock_ref clock

	set p_signal_name [hcii_collection::get_p_name_or_collection $outfile KPR $clock(clk_node_name) 1]

	if {$p_signal_name == ""} {
		msg_vdebug "$clock(clk_node_name) not found in KPR cache (Need extra time to find)"
		set p_signal_name [hcii_collection::get_non_kpr_p_collection $clock(clk_node_name)]
	}
	msg_vdebug "Q = $clock(clk_node_name) >>> PT = $p_signal_name"

	# Need to add clk_signal_name as a clock in name_db
	set ::name_db(clk-$clock(clk_node_name)) $p_signal_name

	# Remove name from ipin list to ensure that no INPUT Max/Min delay
	# is translated to this pin. Once it is a clock, it is no longer an
	# input pin
	if [info exists ::name_db(ipin-$clock(clk_node_name))] {
		msg_vdebug "Unseting ::name_db(ipin-${clock(clk_node_name)})"
		unset ::name_db(ipin-${clock(clk_node_name)})
	}

	set shift [expr double($clock(period)) * ( double($clock(phase)) / 360 ) + $clock(offset)] 
	set edge_0 $shift
	set edge_1 [expr $shift + double($clock(period)) * double($clock(duty)) / 100]
	if { $clock(inv) == 1 } {
		# Add enough offset to account for the inverted base clock
		set edge_0 [expr $edge_0 + double($clock(period)) * double($clock(duty)) / 100]
		set edge_1 [expr $edge_1 + double($clock(period)) * (1.0 - double($clock(duty))/100)]
	}
	if { $edge_1 > $clock(period) } {
		set edge_0 [expr $edge_0 - $clock(period)]
		set edge_1 [expr $edge_1 - $clock(period)]
	}
	if { $edge_0 < 0.0 } {
		set edge_0 [expr $edge_0 + $clock(period)]
		set edge_1 [expr $edge_1 + $clock(period)]
	}

	# Use signal name as clock name
	hcii_util::write_command "create_clock -period $clock(period) -waveform { $edge_0 $edge_1 } $p_signal_name -name $p_signal_name"

	puts $outfile ""
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::create_base_clock { clock_ref outfile } {
	# Create a PrimeTime base clock for a Quartus base clock.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $clock_ref clock

	set p_signal_name [hcii_collection::get_p_name_or_collection $outfile KPR $clock(clk_node_name) 1]

	if [string equal $p_signal_name ""] {
		msg_vdebug "$clock(clk_node_name) not found in KPR cache (Need extra time to find)"
		set p_signal_name [hcii_collection::get_non_kpr_p_collection $clock(clk_node_name)]
	}
	msg_vdebug "Q = $clock(clk_node_name) >>> PT = $p_signal_name"

	# Now try to convert the clock setting name
	if [string equal $clock(clk_setting_name) $clock(clk_node_name)] {
		set pt_clock_name $p_signal_name
	} else {
		# If the clock setting name != signal name, it means this
		# is a user named clock setting.
		# Use it as the PT clock name
		# Note that it is possible that the name is not PT compatible
		# but we will assume it is. HCDC will have to fix the script
		# otherwise
		set pt_clock_name $clock(clk_setting_name)
	}

	# Need to add clk_signal_name as a clock in name_db
	set ::name_db(clk-$clock(clk_node_name)) $p_signal_name

	# Remove name from ipin list to ensure that no INPUT Max/Min delay
	# is translated to this pin. Once it is a clock, it is no longer an
	# input pin
	if [info exists ::name_db(ipin-$clock(clk_node_name))] {
		msg_vdebug "Unseting ::name_db(ipin-${clock(clk_node_name)})"
		unset ::name_db(ipin-${clock(clk_node_name)})
	}

	set edge_0 0
	set edge_1 [expr $clock(period) * $clock(duty) / 100.0]

	# Use signal name as clock name
	puts $outfile "# Original Clock Name: $pt_clock_name"
	hcii_util::write_command "create_clock -period $clock(period) -waveform { $edge_0 $edge_1 } $p_signal_name -name $p_signal_name"
	puts $outfile ""
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::generate_clock_groups { } {
	# Create the PrimeTime clock groups, unless 
	# CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS is set to OFF.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	post_message -type info "** Generating clock groups"

	hcii_util::formatted_write $outfile "
		
		
		################
		# Clock groups #
		################
	"

	# Check if all clocks are related.
	set assgn_value [get_global_assignment -name "CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS"]
	if {[string equal $assgn_value "OFF"]} {
		hardcopy_msgs::post I_CUT_PATH_BETWEEN_CLK_DOMAIN_OFF
		hardcopy_msgs::output_msg $outfile I_CUT_PATH_BETWEEN_CLK_DOMAIN_OFF
		puts $outfile ""
		return
	}

	# Get Report panel
	set panel_name "*Clock Settings Summary"
	set panel_id [get_report_panel_id $panel_name]

	if {$panel_id != -1} {
		set group_count 0
		set all_base_clk_setting_name [array names ::array_of_base_clock_settings]
                set sorted_all_base_clk_setting_name [lsort $all_base_clk_setting_name]

		foreach base_clk_setting_name $sorted_all_base_clk_setting_name {
			msg_vdebug "Processing BASE: $base_clk_setting_name (Group $group_count)"
			set clk_list ""
			foreach clk_node_name [array names ::clk_node_2_base_clk_setting] {
				if { [string equal $::clk_node_2_base_clk_setting($clk_node_name) $base_clk_setting_name] } {
					set p_signal_name [hcii_collection::get_p_name_or_collection $outfile CLK $clk_node_name 1]
					if {$p_signal_name == ""} {
						hardcopy_msgs::post W_CLKS_P_NAME_NOT_FOUND $clk_node_name
						continue
					}
					lappend clk_list $p_signal_name
				}
			}
                
			set group_name "clkgrp_$group_count"
			incr group_count
			set sorted_clk_list [lsort $clk_list]
			puts $outfile "set_clock_groups -asynchronous -name $group_name -group \{ [join $sorted_clk_list " "] \} "
			puts $outfile ""
		}
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::convert_clock_latencies { } {
	# Call hcii_tan_based_conversion::convert_clock_latencies.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	hcii_tan_based_conversion::convert_clock_latencies
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::search_and_store_ext_delay_asgn { q_variable to_type } {
	# Iterate though all Quartus assignments in the <rev>.hcii_ta.txt file
	# of Quartus to search & store INPUT/OUTPUT_MAX/MIN_DELAY assignments
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
        global min_input_array
        global max_input_array
        global min_output_array
        global max_output_array

        global outfile

        set assignment_list [get_all_instance_assignments -name $q_variable]
        foreach_in_collection assignment $assignment_list {
                set from [lindex $assignment 1]
                set to [lindex $assignment 2]
                
                if {$to != ""} {
                        set dst_p_list [hcii_collection::get_p_name_or_collection $outfile $to_type $to 0]
                }

                if {$from != ""} {
                        set src_p_list [hcii_collection::get_p_name_or_collection $outfile CLK $from 0]
                }

                foreach dst_p_name $dst_p_list {
                        if {$dst_p_name == "*" } {
                                continue
                        }
                        foreach src_p_name $src_p_list {

                               if {$src_p_name == "*" } {
                                        continue
                               }

                               if {[string equal $q_variable "INPUT_MIN_DELAY"]} {
                                        if {[info exists min_input_array($dst_p_name)]} {
                                               lappend min_input_array($dst_p_name) $src_p_name
                                        } else {
                                               set min_input_array($dst_p_name) $src_p_name
                                        }

                               } elseif {[string equal $q_variable "INPUT_MAX_DELAY"]} {
                                        if {[info exists max_input_array($dst_p_name)]} {
                                                  lappend max_input_array($dst_p_name) $src_p_name
                                        } else {
                                                  set max_input_array($dst_p_name) $src_p_name
                                        }

                                } elseif {[string equal $q_variable "OUTPUT_MIN_DELAY"]} {
                                        if {[info exists min_output_array($dst_p_name)]} {
                                                  lappend min_output_array($dst_p_name) $src_p_name
                                        } else {
                                                  set min_output_array($dst_p_name) $src_p_name
                                        }

                                } elseif {[string equal $q_variable "OUTPUT_MAX_DELAY"]} {
                                        if {[info exists max_output_array($dst_p_name)]} {
                                                  lappend max_output_array($dst_p_name) $src_p_name
                                        } else {
                                                  set max_output_array($dst_p_name) $src_p_name
                                        }
                                }
                       }
                }
        }
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::convert_default_input_output_min_max_delay_asgn { outfile assignment } {
	# SPR 196138:
        # Convert a default Quartus [input/output]_[min/max]_delay assignment.
	# Default INPUT_MAX_DELAY (not specified by users) to INPUT_MIN_DELAY (specified by users)
	# This happen vice-versa. Also, this apply to OUTPUT_[MIN/MAX]_Delay assignment.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
        array set io_delay_array { }
        array set duplicate_asgn { }
        set duplicate_asgn_type ""

        global min_input_array
        global max_input_array
        global min_output_array
        global max_output_array
        
        set orig_from [lindex $assignment 1]
        set orig_to [lindex $assignment 2]
        set orig_type [lindex $assignment 3]
        set orig_val [lindex $assignment 4]
        set pt_cmd ""
        set use_orig_asgn 0
        set pt_value [hcii_util::get_time_value $orig_val]

        # Initialize duplicate_q_asgn array.
        #hcii_tan_based_conversion::init_q_asgn duplicate_q_asgn

        if {[string equal $orig_type "INPUT_MAX_DELAY"]} {
                array set io_delay_array [array get min_input_array]
                set duplicate_asgn_type "INPUT_MIN_DELAY"
                set to_type IPIN
                set pt_cmd "set_input_delay -min -add_delay"

        } elseif {[string equal $orig_type "INPUT_MIN_DELAY"]} {
                array set io_delay_array [array get max_input_array]
                set duplicate_asgn_type "INPUT_MAX_DELAY"
                set to_type IPIN
                set pt_cmd "set_input_delay -max -add_delay"

        } elseif {[string equal $orig_type "OUTPUT_MAX_DELAY"]} {
                array set io_delay_array [array get min_output_array]
                set duplicate_asgn_type "OUTPUT_MIN_DELAY"
                set to_type OPIN
                set pt_cmd "set_output_delay -min -add_delay"

        } elseif {[string equal $orig_type "OUTPUT_MIN_DELAY"]} {
                array set io_delay_array [array get max_output_array]
                set duplicate_asgn_type "OUTPUT_MAX_DELAY"
                set to_type OPIN
                set pt_cmd "set_output_delay -max -add_delay"
        }

        if {$orig_from != ""} {
                set src_p_list [hcii_collection::get_p_name_or_collection $outfile CLK $orig_from 0]
        }

        if {$orig_to == "*" || $orig_from == "*"} {
                return
        }

        # Search for corresponding opposite type assignment, e.g. input_max_delay <=> input_min_delay
        if {[array size io_delay_array] > 0} {

                if {$orig_to != ""} {
                        set dst_p_list [hcii_collection::get_p_name_or_collection $outfile $to_type $orig_to 0]
                }

                foreach dst_p_name $dst_p_list {
                        if {[info exists io_delay_array($dst_p_name)]} {
                                foreach clk_p_name $src_p_list {
                                        if {[lsearch $io_delay_array($dst_p_name) $clk_p_name] == -1} {
                                                if {[info exists duplicate_asgn($clk_p_name)]} {
                                                       lappend duplicate_asgn($clk_p_name) $dst_p_name
                                                } else {
                                                       set duplicate_asgn($clk_p_name) $dst_p_name
                                                }
                                        }
                                }
                        } else {
                                foreach clk_p_name $src_p_list {
                                        if {[info exists duplicate_asgn($clk_p_name)]} {
                                               lappend duplicate_asgn($clk_p_name) $dst_p_name
                                        } else {
                                               set duplicate_asgn($clk_p_name) $dst_p_name
                                        }
                                }
                        }
                }

        } else {
               set use_orig_asgn 1
               if {$orig_to != ""} {
                        set dst_p_list [hcii_collection::get_p_name_or_collection $outfile $to_type $orig_to 1]
                }
        }
        set msg_index 0
        if {[array size duplicate_asgn] > 0 && $pt_cmd != ""} {

                set clk_index_list [array names duplicate_asgn]
                set clk_list [lsort $clk_index_list]

                foreach pt_clk_name $clk_list {
                        if {$pt_clk_name != "" && $duplicate_asgn($pt_clk_name) != "" } {
                                set cmd "$pt_cmd"
                                append cmd " $pt_value -clock $pt_clk_name { $duplicate_asgn($pt_clk_name) }"

                                if {$msg_index == 0} {
                                        puts $outfile ""
                                        hardcopy_msgs::output_msg $outfile I_CONVERT_DEFAULT_Q_ASGN $duplicate_asgn_type $orig_type
                                        incr msg_index
                                }
                                puts $outfile "$cmd"

                        }
                }
          } elseif {$use_orig_asgn && $pt_cmd != ""} {
                if {$dst_p_list != "" && $src_p_list != ""} {

                        set clk_list [lsort $src_p_list]

                        foreach pt_clk_name $clk_list {
                                set cmd "$pt_cmd"
                                append cmd " $pt_value -clock $pt_clk_name $dst_p_list " 
                                if {$msg_index == 0} {
                                        puts $outfile ""
                                        hardcopy_msgs::output_msg $outfile I_CONVERT_DEFAULT_Q_ASGN $duplicate_asgn_type $orig_type
                                        incr msg_index
                                }
                                puts $outfile "$cmd"
                        }
                }
          }
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::convert_default_input_output_min_max_delay_asgns { outfile row_id panel_id } {
	# SPR 196138:
        # Convert a default Quartus [input/output]_[min/max]_delay assignment.
	# Default INPUT_MAX_DELAY (not specified by users) to INPUT_MIN_DELAY (specified by users)
	# This happen vice-versa. Also, this apply to OUTPUT_[MIN/MAX]_Delay assignment.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
        array set io_delay_array { }
        array set duplicate_asgn { }
        set duplicate_asgn_type ""

        global min_input_array
        global max_input_array
        global min_output_array
        global max_output_array
        
        
        set orig_from ""
        set orig_to ""
        catch {set from [get_report_panel_data -row $row_id -col_name "From" -id $panel_id]}
        catch {set to [get_report_panel_data -row $row_id -col_name "To" -id $panel_id]}
        set orig_type [get_report_panel_data -row $row_id -col_name "Option" -id $panel_id]
        set orig_val [string toupper [get_report_panel_data -row $row_id -col_name "Setting" -id $panel_id]]
        set pt_cmd ""
        set use_orig_asgn 0
        set pt_value [hcii_util::get_time_value $orig_val]

        # Initialize duplicate_q_asgn array.
        #hcii_tan_based_conversion::init_q_asgn duplicate_q_asgn

        if {[string equal $orig_type "INPUT_MAX_DELAY"]} {
                array set io_delay_array [array get min_input_array]
                set duplicate_asgn_type "INPUT_MIN_DELAY"
                set to_type IPIN
                set pt_cmd "set_input_delay -min -add_delay"

        } elseif {[string equal $orig_type "INPUT_MIN_DELAY"]} {
                array set io_delay_array [array get max_input_array]
                set duplicate_asgn_type "INPUT_MAX_DELAY"
                set to_type IPIN
                set pt_cmd "set_input_delay -max -add_delay"

        } elseif {[string equal $orig_type "OUTPUT_MAX_DELAY"]} {
                array set io_delay_array [array get min_output_array]
                set duplicate_asgn_type "OUTPUT_MIN_DELAY"
                set to_type OPIN
                set pt_cmd "set_output_delay -min -add_delay"

        } elseif {[string equal $orig_type "OUTPUT_MIN_DELAY"]} {
                array set io_delay_array [array get max_output_array]
                set duplicate_asgn_type "OUTPUT_MAX_DELAY"
                set to_type OPIN
                set pt_cmd "set_output_delay -max -add_delay"
        }

        if {$orig_from != ""} {
                set src_p_list [hcii_collection::get_p_name_or_collection $outfile CLK $orig_from 0]
        }

        if {$orig_to == "*" || $orig_from == "*"} {
                return
        }

        # Search for corresponding opposite type assignment, e.g. input_max_delay <=> input_min_delay
        if {[array size io_delay_array] > 0} {

                if {$orig_to != ""} {
                        set dst_p_list [hcii_collection::get_p_name_or_collection $outfile $to_type $orig_to 0]
                }

                foreach dst_p_name $dst_p_list {
                        if {[info exists io_delay_array($dst_p_name)]} {
                                foreach clk_p_name $src_p_list {
                                        if {[lsearch $io_delay_array($dst_p_name) $clk_p_name] == -1} {
                                                if {[info exists duplicate_asgn($clk_p_name)]} {
                                                       lappend duplicate_asgn($clk_p_name) $dst_p_name
                                                } else {
                                                       set duplicate_asgn($clk_p_name) $dst_p_name
                                                }
                                        }
                                }
                        } else {
                                foreach clk_p_name $src_p_list {
                                        if {[info exists duplicate_asgn($clk_p_name)]} {
                                               lappend duplicate_asgn($clk_p_name) $dst_p_name
                                        } else {
                                               set duplicate_asgn($clk_p_name) $dst_p_name
                                        }
                                }
                        }
                }

        } else {
               set use_orig_asgn 1
               if {$orig_to != ""} {
                        set dst_p_list [hcii_collection::get_p_name_or_collection $outfile $to_type $orig_to 1]
                }
        }
        set msg_index 0
        if {[array size duplicate_asgn] > 0 && $pt_cmd != ""} {

                set clk_index_list [array names duplicate_asgn]
                set clk_list [lsort $clk_index_list]

                foreach pt_clk_name $clk_list {
                        if {$pt_clk_name != "" && $duplicate_asgn($pt_clk_name) != "" } {
                                set cmd "$pt_cmd"
                                append cmd " $pt_value -clock $pt_clk_name { $duplicate_asgn($pt_clk_name) }"

                                if {$msg_index == 0} {
                                        puts $outfile ""
                                        hardcopy_msgs::output_msg $outfile I_CONVERT_DEFAULT_Q_ASGN $duplicate_asgn_type $orig_type
                                        incr msg_index
                                }
                                puts $outfile "$cmd"

                        }
                }
          } elseif {$use_orig_asgn && $pt_cmd != ""} {
                if {$dst_p_list != "" && $src_p_list != ""} {

                        set clk_list [lsort $src_p_list]

                        foreach pt_clk_name $clk_list {
                                set cmd "$pt_cmd"
                                append cmd " $pt_value -clock $pt_clk_name $dst_p_list " 
                                if {$msg_index == 0} {
                                        puts $outfile ""
                                        hardcopy_msgs::output_msg $outfile I_CONVERT_DEFAULT_Q_ASGN $duplicate_asgn_type $orig_type
                                        incr msg_index
                                }
                                puts $outfile "$cmd"
                        }
                }
          }
}
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::convert_assignment { outfile q_variable asgn_type pt_command from_label to_label add_value } {
	# Function will iterate though all quartus assignments
	# of type q_variable and generate a Primetime command
	# using "<pt_command> <add_value?value:""> -<from_label> <from> -<to_label> <to>"
	#
	# Primetime is not that good at doing a smart wildcard expansion. e.g.
	# While Quartus will expand "*" for INPUT_MAX_DELAY to only input pins
	# Primetime will expand it to ALL pins, creating many warnings.
	# So we need to do the correct expansion here. asgn_type is used for that
	# asgn_type can be one of:
	#	- CLK2CLK  : Assignment goes from clk to clk
	#	- 1CLK     : Assignment goes to single clk
	#	- KPR2KPR  : Assignment goes from clk/pin/reg to clk/pin/reg
	#	- CLK2IPIN : Assignment goes from clk to input pin
	#	- CLK2OPIN : Assignment goes from clk to output pin
	#   - IPIN2OPIN: Assignment goes from input pin to output pin
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable asgn_value_type

	switch -exact -- $asgn_type {
		"CLK2CLK" { set from_type CLK; set to_type CLK }
		"1CLK" { set from_type ILLEGAL; set to_type CLK }
		"KPR2KPR" { set from_type KPR; set to_type KPR }
		"IPIN2OPIN" { set from_type IPIN; set to_type OPIN }
		"CLK2IPIN" { set from_type CLK; set to_type IPIN }
		"CLK2OPIN" { set from_type CLK; set to_type OPIN }
	}

        if { $q_variable == "INPUT_MAX_DELAY" || \
             $q_variable == "INPUT_MIN_DELAY" || \
             $q_variable == "OUTPUT_MAX_DELAY" ||
             $q_variable == "OUTPUT_MIN_DELAY" } {
                set is_grouping_asgn 0
        } else {
                set is_grouping_asgn 1
        }

	set assignment_list [get_all_instance_assignments -name $q_variable]
	foreach_in_collection assignment $assignment_list {
		set sect_id	[lindex $assignment 0]
		set from	[lindex $assignment 1]
		set to		[lindex $assignment 2]
		set name	[lindex $assignment 3]
		set value	[lindex $assignment 4]
		set cmd_ok	1
		set error_msg	""
		
		set cmd		"$pt_command"
		if { $add_value == $asgn_value_type(time) } {
			set ptvalue [hcii_util::get_time_value $value]
			append cmd " $ptvalue"
		} elseif { $add_value == $asgn_value_type(int) } {
			append cmd " $value"
		}
		if {$from != ""} {
		        if {$is_grouping_asgn} {
			        set from_collection [hcii_collection::get_p_name_or_collection $outfile $from_type $from 1]
		        } else {
		                set from_collection [hcii_collection::get_p_name_or_collection $outfile $from_type $from 0]
		        }
			if {[llength $from_collection] > 0 } {
			        if {$is_grouping_asgn} {
				append cmd " $from_label $from_collection "
				}
			} else {
				set cmd_ok 0
				hardcopy_msgs::output_msg $outfile W_P_NAME_OR_COLL_NOT_FOUND $from
			}

		}
		if {$to != ""} {
			set to_collection [hcii_collection::get_p_name_or_collection $outfile $to_type $to 1]
			if {[llength $to_collection] > 0 } {
			        if {$is_grouping_asgn} {
				append cmd " $to_label $to_collection "
				}
			} else {
				set cmd_ok 0
				hardcopy_msgs::output_msg $outfile W_P_NAME_OR_COLL_NOT_FOUND $to
			}
		}

		# Rebuild specified Quartus assignment command.
		set q_asgn_cmd "$q_variable $value"
		if {$from != ""} {
			append q_asgn_cmd " -from $from"
		}
		if {$to != ""} {
			append q_asgn_cmd " -to $to"
		}

		if {$::options(verbose)} {
			msg_vdebug "Converting Quartus assignment $q_asgn_cmd"
		}
		puts $outfile "# $q_asgn_cmd"

		if { $cmd_ok } {

			if { $is_grouping_asgn} {
                             hcii_util::write_command "$cmd"
                        } else {
                             foreach p_clk_name $from_collection {
                                     set cmd "$pt_command $ptvalue $from_label $p_clk_name $to_label $to_collection"
			hcii_util::write_command "$cmd"
                             }
			     convert_default_input_output_min_max_delay_asgn $outfile $assignment
			}

		} else {
			hardcopy_msgs::post CW_CANNOT_CONVERT_ASGN
			hardcopy_msgs::output_msg $outfile CW_CANNOT_CONVERT_ASGN
		}

		puts $outfile ""
		puts $outfile ""
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::report_ignored_instance_assignments { } {
	# Call hcii_tan_based_conversion::report_ignored_instance_assignments
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	hcii_tan_based_conversion::report_ignored_instance_assignments
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::convert_assignments { } {
	# Iterate though all Quartus assignments in the ACF to generate the
	# corresponding Primetime commands.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable asgn_value_type

	global outfile
	
	hcii_util::formatted_write $outfile "
		
		###############################
		# QSF Base Timing constraints #
		###############################
	"

	# Get Clock Uncertainty
	post_message -type info "** Processing Clock Uncertainty assignments"
	hcii_qsf_based_conversion::convert_assignment \
		$outfile \
		CLOCK_SETUP_UNCERTAINTY \
		CLK2CLK \
		"set_clock_uncertainty -setup" \
		"-from" \
		"-to" \
		$asgn_value_type(time)
	hcii_qsf_based_conversion::convert_assignment \
		$outfile \
		CLOCK_HOLD_UNCERTAINTY \
		CLK2CLK \
		"set_clock_uncertainty -hold" \
		"-from" \
		"-to" \
		$asgn_value_type(time)

	# Get all MULTICYCLE assignments
	post_message -type info "** Processing MultiCycle assignments"
	hcii_qsf_based_conversion::convert_assignment $outfile MULTICYCLE KPR2KPR "set_multicycle_path -setup" "-from" "-to" $asgn_value_type(int)
	hcii_qsf_based_conversion::convert_assignment $outfile SRC_MULTICYCLE KPR2KPR "set_multicycle_path -setup -start" "-from" "-to" $asgn_value_type(int)
	hcii_qsf_based_conversion::convert_assignment $outfile HOLD_MULTICYCLE KPR2KPR "set_multicycle_path -hold" "-from" "-to" $asgn_value_type(int)
	hcii_qsf_based_conversion::convert_assignment $outfile SRC_HOLD_MULTICYCLE KPR2KPR "set_multicycle_path -hold -start" "-from" "-to" $asgn_value_type(int)

	# Get all CUT assignments
	post_message -type info "** Processing Cut assignments"
	hcii_qsf_based_conversion::convert_assignment $outfile CUT KPR2KPR "set_false_path" "-from" "-to" $asgn_value_type(bool)

	# Get all I/O constraints
	post_message -type info "** Processing Input/Output Delay assignments"
	hcii_qsf_based_conversion::search_and_store_ext_delay_asgn INPUT_MAX_DELAY IPIN
        hcii_qsf_based_conversion::search_and_store_ext_delay_asgn INPUT_MIN_DELAY IPIN
        hcii_qsf_based_conversion::search_and_store_ext_delay_asgn OUTPUT_MAX_DELAY OPIN
        hcii_qsf_based_conversion::search_and_store_ext_delay_asgn OUTPUT_MIN_DELAY OPIN
	hcii_qsf_based_conversion::convert_assignment $outfile INPUT_MAX_DELAY CLK2IPIN "set_input_delay -max -add_delay" "-clock" "" $asgn_value_type(time)
	hcii_qsf_based_conversion::convert_assignment $outfile INPUT_MIN_DELAY CLK2IPIN "set_input_delay -min -add_delay" "-clock" "" $asgn_value_type(time)
	hcii_qsf_based_conversion::convert_assignment $outfile OUTPUT_MAX_DELAY CLK2OPIN "set_output_delay -max -add_delay" "-clock" "" $asgn_value_type(time)
	hcii_qsf_based_conversion::convert_assignment $outfile OUTPUT_MIN_DELAY CLK2OPIN "set_output_delay -min -add_delay" "-clock" "" $asgn_value_type(time)

	# TPD paths
	hcii_qsf_based_conversion::convert_assignment $outfile TPD_REQUIREMENT IPIN2OPIN "set_max_delay" "-from" "-to" $asgn_value_type(time)
	hcii_qsf_based_conversion::convert_assignment $outfile MIN_TPD_REQUIREMENT IPIN2OPIN "set_min_delay" "-from" "-to" $asgn_value_type(time)
	
	# MAX/MIN Delay and SETUP/HOLD relationship
	hcii_qsf_based_conversion::convert_assignment $outfile SETUP_RELATIONSHIP KPR2KPR "set_max_delay" "-from" "-to" $asgn_value_type(time)
	hcii_qsf_based_conversion::convert_assignment $outfile HOLD_RELATIONSHIP KPR2KPR "set_min_delay" "-from" "-to" $asgn_value_type(time)
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::convert_all_assignments_directly_from_tan_rpt { } {
	# Function uses "Timing Analysis Settings"
	# TAN report panel to find all the
	# assignments, which include both QSF and HDL assignments
	# of Quartus and generate the corresponding Primetime commands.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

        global outfile

       	hcii_util::formatted_write $outfile "

		######################
		# Timing constraints #
		######################
	"

       	variable asgn_value_type

        post_message -type info "** Processing assignments directly from tan rpt"

        set project_show_entity_name ""
        set project_show_entity_name [get_global_assignment -name PROJECT_SHOW_ENTITY_NAME]
        if {![string equal -nocase $project_show_entity_name "on" ] } {
               hardcopy_msgs::post W_PROJECT_SHOW_ENTITY_NAME_OFF
        }

        # Get Report panel
	set panel_name "*Timing Analyzer Settings"
	set panel_id [get_report_panel_id $panel_name]

	if {$panel_id != -1} {
	        set row_cnt [get_number_of_rows -id $panel_id]
	        msg_vdebug "*************************  Found $panel_name (Row = $row_cnt) ***********************"

               	hcii_qsf_based_conversion::search_and_store_ext_delay_asgn INPUT_MAX_DELAY IPIN
                hcii_qsf_based_conversion::search_and_store_ext_delay_asgn INPUT_MIN_DELAY IPIN
                hcii_qsf_based_conversion::search_and_store_ext_delay_asgn OUTPUT_MAX_DELAY OPIN
                hcii_qsf_based_conversion::search_and_store_ext_delay_asgn OUTPUT_MIN_DELAY OPIN


	        # Start with 1 as 0 is table header
	        for {set i 1} {$i < $row_cnt} {incr i} {
	                set variable [get_report_panel_data -row $i -col_name "Option" -id $panel_id]

                        switch -exact -- $variable {
                               "Cut Timing Path" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile CUT KPR2KPR "set_false_path" "-from" "-to" $asgn_value_type(bool) $i $panel_id }
                                "Multicycle" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile MULTICYCLE KPR2KPR "set_multicycle_path -setup" "-from" "-to" $asgn_value_type(int) $i $panel_id }
                                "Multicycle Hold" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile HOLD_MULTICYCLE KPR2KPR "set_multicycle_path -hold" "-from" "-to" $asgn_value_type(int) $i $panel_id }
                                "Source Multicycle" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile SRC_MULTICYCLE KPR2KPR "set_multicycle_path -setup -start" "-from" "-to" $asgn_value_type(int) $i $panel_id }
                                "Source Multicycle Hold" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile SRC_HOLD_MULTICYCLE KPR2KPR "set_multicycle_path -hold -start" "-from" "-to" $asgn_value_type(int) $i $panel_id }
                                "Input Maximum Delay" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile INPUT_MAX_DELAY CLK2IPIN "set_input_delay -max -add_delay" "-clock" "" $asgn_value_type(time) $i $panel_id }
                                "Input Minimum Delay" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile INPUT_MIN_DELAY CLK2IPIN "set_input_delay -min -add_delay" "-clock" "" $asgn_value_type(time) $i $panel_id }
                                "Output Maximum Delay" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile OUTPUT_MAX_DELAY CLK2OPIN "set_output_delay -max -add_delay" "-clock" "" $asgn_value_type(time) $i $panel_id }
                                "Output Minimum Delay" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile OUTPUT_MIN_DELAY CLK2OPIN "set_output_delay -min -add_delay" "-clock" "" $asgn_value_type(time) $i $panel_id }
                                "tpd Requirement" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile TPD_REQUIREMENT KPR2KPR "set_max_delay" "-from" "-to" $asgn_value_type(time) $i $panel_id }
                                "Minimum tpd Requirement" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile MIN_TPD_REQUIREMENT KPR2KPR "set_min_delay" "-from" "-to" $asgn_value_type(time) $i $panel_id }
                                "Setup Relationship" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile SETUP_RELATIONSHIP KPR2KPR "set_max_delay" "-from" "-to" $asgn_value_type(time) $i $panel_id }
                                "Hold Relationship" { hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt $outfile HOLD_RELATIONSHIP KPR2KPR "set_min_delay" "-from" "-to" $asgn_value_type(time) $i $panel_id}
			}
                }
        }
}



# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::convert_each_assignment_directly_from_tan_rpt { outfile q_variable asgn_type pt_command from_label to_label add_value row_id panel_id} {
	# Function will iterate though all quartus assignments
	# of type q_variable and generate a Primetime command
	# using "<pt_command> <add_value?value:""> -<from_label> <from> -<to_label> <to>"
	#
	# Primetime is not that good at doing a smart wildcard expansion. e.g.
	# While Quartus will expand "*" for INPUT_MAX_DELAY to only input pins
	# Primetime will expand it to ALL pins, creating many warnings.
	# So we need to do the correct expansion here. asgn_type is used for that
	# asgn_type can be one of:
	#	- CLK2CLK  : Assignment goes from clk to clk
	#	- 1CLK     : Assignment goes to single clk
	#	- KPR2KPR  : Assignment goes from clk/pin/reg to clk/pin/reg
	#	- CLK2IPIN : Assignment goes from clk to input pin
	#	- CLK2OPIN : Assignment goes from clk to output pin
	#   - IPIN2OPIN: Assignment goes from input pin to output pin
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable asgn_value_type

	switch -exact -- $asgn_type {
		"CLK2CLK" { set from_type CLK; set to_type CLK }
		"1CLK" { set from_type ILLEGAL; set to_type CLK }
		"KPR2KPR" { set from_type KPR; set to_type KPR }
		"IPIN2OPIN" { set from_type IPIN; set to_type OPIN }
		"CLK2IPIN" { set from_type CLK; set to_type IPIN }
		"CLK2OPIN" { set from_type CLK; set to_type OPIN }
	}

        if { $q_variable == "INPUT_MAX_DELAY" || \
             $q_variable == "INPUT_MIN_DELAY" || \
             $q_variable == "OUTPUT_MAX_DELAY" ||
             $q_variable == "OUTPUT_MIN_DELAY" } {
                set is_grouping_asgn 0
        } else {
               set is_grouping_asgn 1
       }

        set entity ""
        set project_show_entity_name ""
        set project_show_entity_name [get_global_assignment -name PROJECT_SHOW_ENTITY_NAME]

        set from ""
        set to ""
        catch {set from [get_report_panel_data -row $row_id -col_name "From" -id $panel_id]}
        catch {set to [get_report_panel_data -row $row_id -col_name "To" -id $panel_id]}
        set name [get_report_panel_data -row $row_id -col_name "Option" -id $panel_id]
        set value [string toupper [get_report_panel_data -row $row_id -col_name "Setting" -id $panel_id]]
	set cmd_ok	1
	set error_msg	""


	if {![catch {set entity [get_report_panel_data -row $row_id -col_name "Entity Name" -id $panel_id]}] } {
	   if {[string equal -nocase $project_show_entity_name "on" ] } {
                msg_vdebug "Before get_full_hpath Variable: $name     Value: $value     From: $from         To: $to"
			if [string compare $entity ""] {
                 		if {![catch {set from [get_report_panel_data -row $row_id -col_name "From" -id $panel_id]}]} {
        		                    set from [hcii_util::get_full_hpath $from]
        		                    set from "*|${entity}*${from}"
        	                }
                                set to [hcii_util::get_full_hpath $to]
        	                set to "*|${entity}*${to}"
			}
                msg_vdebug "******        After get_full_hpath Variable: $name     Value: $value     From: $from         To: $to ******"
	  }
        }

        set cmd	"$pt_command"
        set generate_cmd 1
	if { $add_value == $asgn_value_type(time) } {
		set ptvalue [hcii_util::get_time_value $value]
		append cmd " $ptvalue"
	} elseif { $add_value == $asgn_value_type(int) } {
		append cmd " $value"
	} elseif { $add_value == $asgn_value_type(bool) } {
	         if { $value == "OFF"} {
	              set generate_cmd 0
	         }
	}

        # Rebuild specified Quartus assignment command.
      	set q_asgn_cmd "$q_variable $value"
      	if {$from != ""} {
      		append q_asgn_cmd " -from $from"
      	}
      	if {$to != ""} {
      		append q_asgn_cmd " -to $to"
      	}

	if { $generate_cmd} {

        	if {$from != ""} {
                        set from [hcii_util::fix_if_bus_name $from]
        	        if {$is_grouping_asgn} {
        		        set from_collection [hcii_collection::get_p_name_or_collection $outfile $from_type $from 1]
        	        } else {
        	                set from_collection [hcii_collection::get_p_name_or_collection $outfile $from_type $from 0]
        	        }
        		if {[llength $from_collection] > 0 } {
        		        if {$is_grouping_asgn} {
        				append cmd " $from_label $from_collection "
        			}
        		} else {
        			set cmd_ok 0
        			hardcopy_msgs::output_msg $outfile W_P_NAME_OR_COLL_NOT_FOUND $from
        		}
        	}
        	if {$to != ""} {
                        set to [hcii_util::fix_if_bus_name $to]
        		set to_collection [hcii_collection::get_p_name_or_collection $outfile $to_type $to 1]
        		if {[llength $to_collection] > 0 } {
        		        if {$is_grouping_asgn} {
        			append cmd " $to_label $to_collection "
        			}
        		} else {
        			set cmd_ok 0
        			hardcopy_msgs::output_msg $outfile W_P_NAME_OR_COLL_NOT_FOUND $to
        		}
        	}

        	if {$::options(verbose)} {
        		msg_vdebug "Converting Quartus assignment $q_asgn_cmd"
        	}

       		puts $outfile "# $q_asgn_cmd"
        	if { $cmd_ok } {
                	if { $is_grouping_asgn} {
                                hcii_util::write_command "$cmd"
                        } else {
                                foreach p_clk_name $from_collection {
                                set cmd "$pt_command $ptvalue $from_label $p_clk_name $to_label $to_collection"
                                hcii_util::write_command "$cmd"
                                }
        			#convert_default_input_output_min_max_delay_asgn $outfile $assignment
        			convert_default_input_output_min_max_delay_asgns $outfile $row_id $panel_id
        		}
        	} else {
        		hardcopy_msgs::post_msg CW_CANNOT_CONVERT_ASGN
        		hardcopy_msgs::output_msg $outfile CW_CANNOT_CONVERT_ASGN
        	}
        } else {
                puts $outfile "# No translation is required: $q_asgn_cmd"
        }
       	puts $outfile ""
       	puts $outfile ""
}
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_qsf_based_conversion::generate_scripts { } {
	# Generate PrimeTime scripts converted from Quartus requirements into
	# file <rev_name>.tcl.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global quartus
	global pvcs_revision
	global outfile

	# Open file to output generated PrimeTime scripts.
	set output_file_name "$::hc_output/${::rev_name}.tcl"
	set outfile [open $output_file_name w]

	hcii_util::formatted_write $outfile "
		#####################################################################################
		#
		# Generated by [info script] $pvcs_revision(main)
		#   hcii_visitors.tcl : $pvcs_revision(visitors)
		#   Quartus           : $quartus(version)
		#
		# Project:  $quartus(project)
		# Revision: $quartus(settings)
		#
		# Date: [clock format [clock seconds]]
		#
		#####################################################################################
	"

	# Process and/or check Global Settings
	hcii_qsf_based_conversion::convert_global_settings


	# Initialize hcii_name_db databases, which contains all the infomation
	# helping to translate Quartus names to PrimeTime names.
	# It also does set_annotated_delay on PLL pins.
	hcii_name_db::initialize_db

	# Load report
	load_report
	if ![is_report_loaded] {
		hardcopy_msgs::post E_NO_REPORT_DB
		qexit -error
	}

	# Process clock settings
	hcii_qsf_based_conversion::convert_clocks

	# Make clock groups
	hcii_qsf_based_conversion::generate_clock_groups

	# Convert Quartus Clock Latency assignments.
	hcii_qsf_based_conversion::convert_clock_latencies

	# Get output pin loading and input pin transition times.
	hcii_qsf_based_conversion::generate_output_pin_loadings
	hcii_qsf_based_conversion::generate_input_pin_transitions

	# Report unsupported assignments.
	hcii_qsf_based_conversion::report_ignored_instance_assignments

        #Convert Quartus timing assignments from TAN Report
        hcii_qsf_based_conversion::convert_all_assignments_directly_from_tan_rpt

	# Convert Quartus timing assignments.
	# hcii_qsf_based_conversion::convert_assignments

	close $outfile
	unload_report

	post_message -type info "--------------------------------------------------------"
	post_message -type info "Generated $output_file_name"
	post_message -type info "--------------------------------------------------------"
}