set pvcs_revision(tan_based_conversion) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: hcii_tan_based_conversion.tcl
#
# Used by hcii_pt_script.tcl
#
# Description:
#		This file defines hcii_tan_based_conversion namespace that contains
#		all the codes to do Q2P translation, with the aid of TAN process:
#		- TAN first processes user specified assignments by expanding all the
#		wildcards, buses or time groups, checking the validity of sources and
#		destinations, grouping similar assignments for better performance.
#		- TAN dumps processed clock information to file
#		<revision>.hcii_clk.txt and processed SP or P2P simple timing assignments
#		to file <revision>.hcii_ta.txt.
#		- It then reads timing assignments from the above two TAN dump files
#		and translates them into PrimeTime timing constraints with the aid of
#		the Q2P name map.
#
#		The TAN dumped files store most processed point-to-point (P2P) and
#		single-point (SP) simple timing assignments (simple means no wildcards,
#		buses and time group) reprented by with node name IDs (HDB_IDs)
#		instead of the node names in order to save space.
#
#		The format of file <revision>.hcii_clk.txt is:
#			CLOCK [(<clock_index>)]
#				clk: <clock_name_id> (HDB_ID)
#				name: <clock_name>
#				setting: <clock_setting_name>
#				type: <clk_type> (= "User Pin"|"PLL Output"|"Register")
#				period: <period> (in unit of ns)
#				fmax: <fmax>
#				duty: <duty cycle>
#				invert: <is_the_clock_inverted> (based on base clock setting)
#				early_latency: <early_clock_latency> (in unit of ns)
#				late_latency: <late_clock_latency> (in unit of ns)
#				multiply_by: <multiply_base_clock_setting_period_by>
#				multiply_by: <divide_base_clock_setting_period_by>
#				base_clk: <base_clock_name_id_list> (HDB_IDs)
#				base_clk_name: <base_clock_name_list>
#				fanin_clk: <fanin_clock_name_id_list> (HDB_IDs)
#				fanin_clk_name: <fanin_clock_name_list>
#			END
#
#		The format of file <revision>.hcii_clk.txt is:
#			<asgn_type> [(<asgn_index>)] (CUT, INPUT_MAX_DELAY, MULTICYCLE_GROUP, etc.)
#				value: <asgn_value_list> *
#				from: <source_name_id_list> (HDB_ID)
#				to: <destination_name_id_list> (HDB_ID)
#			END
#
#		* Value of CUT is a bool (0|1);
#		  Value of INPUT_MAX_DELAY is a real, in unit of ns;
#		  Value of MULTICYCLE_GROUP is a list of types and integers.
#
#		Examples:
#			CLOCK (16)
#				clk: 699
#				name: misc_pll_test|fast_pll
#				setting: 
#				type: PLL Output
#				period: 6.666
#				fmax: 150.02 MHz
#				duty: 50
#				invert: 0
#				early_latency: -2.725
#				late_latency: -2.725
#				base_setting: pll_f_clk
#				multiply_by: 3
#				divide_by: 4
#				base_clk: 1000
#				base_clk_name: pll_f_clk
#				fanin_clk: 1000
#				fanin_clk_name: pll_f_clk
#			END
#
#			INPUT_MIN_DELAY (90)
#				value: 1.5
#				from: 1007
#				to: 964 962 961 960 959 958 957 956 955 954 969 968 967 966
#			END
#
#			MULTICYCLE_GROUP (104)
#				value: MULTICYCLE 3 SRC_MULTICYCLE 1 HOLD_MULTICYCLE 3 SRC_HOLD_MULTICYCLE 0
#				from: 864 863 862 861
#				to: 1061
#			END
#
# **************************************************************************


# --------------------------------------------------------------------------
#
namespace eval hcii_tan_based_conversion {
#
# Description:	Define the namespace and interal variables.
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!!  To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
	# Map Quartus commands to corresponding PrimeTime commands.
	array set cmd_translator { \
		clock_setup_uncertainty	"set_clock_uncertainty -setup"	\
		clock_hold_uncertainty	"set_clock_uncertainty -hold"	\
		early_clock_latency		"set_clock_latency -source -early"	\
		late_clock_latency		"set_clock_latency -source -late"	\
		cut						"set_false_path"	\
		multicycle				"set_multicycle_path -setup -end"	\
		src_multicycle			"set_multicycle_path -setup -start"	\
		hold_multicycle			"set_multicycle_path -hold -end"	\
		src_hold_multicycle		"set_multicycle_path -hold -start"	\
		input_max_delay			"set_input_delay -max -add_delay"	\
		input_min_delay			"set_input_delay -min -add_delay"	\
		output_max_delay		"set_output_delay -max -add_delay"	\
		output_min_delay		"set_output_delay -min -add_delay"	\
		tpd						"set_max_delay"	\
		min_tpd					"set_min_delay"	\
		setup_relationship		"set_max_delay"	\
		hold_relationship		"set_min_delay"	\
	}

	# Supported Quartus commands.
	set supported_q_asgn_types [array names cmd_translator]

	# Unsupported Quartus commands.
	set unsupported_q_asgn_types { \
		tsu \
		th \
		tco \
		min_tco \
		max_delay \
		min_delay \
		clock_enable_multicycle \
		clock_enable_multicycle_hold \
		clock_enable_source multicycle \
		clock_enable_source multicycle_hold \
		inverted_clock \
		max_clock_arrival_skew \
		max_data_arrival_skew \
		virtual_clock_reference \
	}

	# The file handle that PrimeTime scripts are output to.
	# Not used now. For replacing using the global variable ::outfile.
	set outfile {}

        # These arrays are used to store Port ID => Clock ID for INPUT/OUTPUT_MIN/MAX_DELAY QII assignment
        # The purpose is used to set default value for OUTPUT/INPUT_MIN_DELAY <=> OUTPUT/INPUT_MAX_DELAY
        # when users only specified 1 type of extrnal delay
        array set min_input_array { }
        array set max_input_array { }
        array set min_output_array { }
        array set max_output_array { }
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::output_hcdc_required_settings { outfile } {
	# HCDC requests to dump the following hard-coded initialization settings.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# Output any global Primetime settings (currently hard-coded).
	hcii_util::formatted_write $outfile "


		###################
		# Global Settings #
		###################
		set_max_transition 1.0 \[get_designs *\]
		set_max_fanout 20 \[get_designs *\]
		set_max_capacitance 0.5 \[get_designs *\]
	"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_global_settings { } {
	# Check the validity of global settings.
	# Output required global settings.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	post_message -type info "** Processing Global Settings"

	# Since we ignore all global timing assignments, give warnings if they
	# exist.
	foreach asgn_name $hcii_const::unsupported_global_assignments {
		set asgn_value [get_global_assignment -name $asgn_name]
		if {$asgn_value != ""} {
			hardcopy_msgs::post W_UNSUPPORTED_GLOBAL_ASGN $asgn_name $asgn_value
		}
	}

	# Check that all required assignments have the required value.
	# Give warnings if not.
	foreach asgn $hcii_const::required_global_assignments {
		# Each asgn is a pair of asgn_name and required_value.
		set asgn_name [lindex $asgn 0]
		set required_value [lindex $asgn 1]
		set asgn_value [get_global_assignment -name $asgn_name]
		if {$asgn_value != $required_value} {
                                hardcopy_msgs::post  W_WRONG_ASGN_EXPECTED_VALUE $asgn_name $required_value $asgn_value
#			hcii_msg::post_msg	"" \
#								W_WRONG_ASGN_EXPECTED_VALUE \
#								"$asgn_name $required_value $asgn_value"
		}
	}

	# Output HCDC required Primetime settings
	#hcii_tan_based_conversion::output_hcdc_required_settings $outfile
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_clocks { } {
	# Convert Quartus clocks to PrimeTime clocks.
	# It parses TAN dumped clock info file, <rev>.hcii_clk.txt, to generate
	# PrimeTime creating clock scripts.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	array set clk_info { }

	post_message -type info "** Processing Clock Settings"

	hcii_util::formatted_write $outfile "


		##########
		# Clocks #
		##########
	"

        # The algorithm is
        # TAN in STA_MODE = OFF
        #     - If *clk.txt file does not exist, give critical warning.
        #     - Else proceed processing
        # TAN in STA_MODE = ON
        #     - Do nothing in QII V6.0
	if { [string tolower [get_global_assignment -name STA_MODE]] != "on" } {
              	# Open read in file that contains Quartus clock info.
	        set input_file_name "$::hc_output/${::rev_name}.hcii_clk.txt"

	        # Issue critical warning message if the clock helper file does not exist.
                if [catch {set infile [open $input_file_name r]}] {
                          hardcopy_msgs::post CW_CANNOT_OPEN_CLK_FILE $input_file_name
#		          hcii_msg::post_msg "" CW_CANNOT_OPEN_CLK_FILE $input_file_name
	        } else {
                	# Read all Quartus clocks.
                	while {![eof $infile]} {
                		# Read one Quartus clock.
                		set successful [hcii_tan_based_conversion::read_clock $infile clk_info]

                		# If read is successful, update the clk_info database.
                		if {$successful} {
                			hcii_clock_info::set_clock_info $clk_info(clk) clk_info
                		}
                	}
                	close $infile

                	# Filter off invalid Quartus clocks.
                	hcii_tan_based_conversion::check_clock_validity $outfile

                	set all_clocks [hcii_clock_info::get_all_clock_ids]

                	# Give a critical warning if no clocks defined.
                	if {[llength $all_clocks] == 0} {
                		hardcopy_msgs::post CW_NO_CLOCKS_DEFINED
                		hardcopy_msgs::output_msg $outfile CW_NO_CLOCKS_DEFINED
                		puts $outfile ""
                		return
                	}

                	# Generate PrimeTime creating clock scripts.
                	foreach clk_id $all_clocks {
                		# Get the clock info data structure.
                		hcii_clock_info::get_clock_info $clk_id clk_info

                		post_message -type info "Converting Quartus clock $clk_info(name) ($clk_info(index))"

                		# Show its info to the script file.
                		hcii_clock_info::show_clock_info $outfile clk_info

                		# Output any warning or info message generated during the
                		# check_clock_validity process.
                		set msgs [hcii_clock_info::get_clock_info_by_type $clk_id msgs]
                 	        if {$msgs != ""} {
                 	                hardcopy_msgs::post_list msgs
                                        hardcopy_msgs::output_msg_list $outfile msgs
                                }
                
                		# If the Quartus clock is valid, generate the PrimeTime clock creation
                		# script.
                		if {[hcii_clock_info::get_clock_info_by_type $clk_id is_valid] == 1} {
                			if {$clk_info(base_clk) == -1} {
                				hcii_tan_based_conversion::create_base_clock clk_info $outfile
                			} else {
                				hcii_tan_based_conversion::create_derived_clock clk_info $outfile
                			}
                		}
                
                		# Add a new line between 2 clock creation scripts.
                		puts $outfile ""
                	}
                
                	# Need to ask PrimeTime to propagate all clocks.
                	puts $outfile "set_propagated_clock \[all_clocks\]"
                }
          }
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::generate_clock_groups { } {
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
	set asgn_value [get_global_assignment -name "CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS"]
	if {[string equal $asgn_value "OFF"]} {
		hardcopy_msgs::post I_CUT_PATH_BETWEEN_CLK_DOMAIN_OFF
		hardcopy_msgs::output_msg $outfile I_CUT_PATH_BETWEEN_CLK_DOMAIN_OFF
		puts $outfile ""
		return
	}


	array set q_clk_info { }
	array set q_base_clk_info { }

	# Clock groups array. The key is a base clock setting and the value is
	# a list of Quartus clock IDs.
	array set clk_groups { }

	# Iterate all valid clocks build up clk_groups array
	# (keyed by base clock settings).
	set all_clocks [hcii_clock_info::get_valid_clock_ids]
        set sorted_all_clocks [lsort $all_clocks]

	foreach clk_id $sorted_all_clocks {
		hcii_clock_info::get_clock_info $clk_id q_clk_info
		set base_setting "--"

		# Find out the base clock setting.
		if {$q_clk_info(base_clk) == -1} {
			# Base clock case.
			if {$q_clk_info(base_setting) == "--"} {
				# If no base setting, use clock setting.
				set base_setting $q_clk_info(setting)
				# If no clock setting, use clock name
				if {$base_setting == ""} {
				        set base_setting $q_clk_info(name)
				}
			} else {
				set base_setting $q_clk_info(base_setting)
			}
		} else {
			# None base clock case
			hcii_clock_info::get_clock_info [lindex $q_clk_info(base_clk) 0] q_base_clk_info

			if {$q_base_clk_info(base_setting) == "--"} {
				set base_setting $q_base_clk_info(setting)
				if {$base_setting == ""} {
				        set base_setting $q_base_clk_info(name)
                                }
			} else {
				set base_setting $q_base_clk_info(base_setting)
			}
		}

		# Append clock to the existing clock group or create a new clock group.
		if {[info exists clk_groups($base_setting)]} {
			lappend clk_groups($base_setting) $clk_id
		} else {
			set clk_groups($base_setting) $clk_id
		}
	}

	# Iterate the clk_groups array to generate set_clock_groups command.
	set clk_group_index 0
	foreach clk_group_key [array names clk_groups] {
		if {$::options(verbose)} {
			msg_vdebug "Creating PrimeTime clock group (base clk setting: $clk_group_key)"
		}

		# Need to sort clocks in a clock group for output.
		set sorted_clk_list [lsort $clk_groups($clk_group_key)]
		set p_clk_names { }
		foreach clk_id $sorted_clk_list {
			# This should never happen since all clocks referenced here
			# are valid.
			if [catch {set q_clk_name [hcii_name_db::get_q_name_by_hdb_id $clk_id]}] {
				if {$::options(verbose)} {
					hardcopy_msgs::post_debug_msg W_CLKS_Q_NAME_NOT_FOUND $clk_id
				}
				hardcopy_msgs::output_msg $outfile W_CLKS_Q_NAME_NOT_FOUND $clk_id
				continue
			}

			set key [hcii_name_db::get_q2p_name_db_key CLK $q_clk_name]
			if {[info exists ::name_db($key)]} {
				lappend p_clk_names $::name_db($key)
			} else {
				if {$::options(verbose)} {
					hardcopy_msgs::post_debug_msg W_CLKS_P_NAME_NOT_FOUND $q_clk_name
				}
				hardcopy_msgs::output_msg $outfile W_CLKS_P_NAME_NOT_FOUND $q_clk_name
				continue
			}
		}
      
		if {[llength $p_clk_names] > 0} {
			set clk_group_name "clkgrp_$clk_group_index"
			incr clk_group_index
			set sorted_p_clk_names [lsort $p_clk_names]
			puts $outfile "set_clock_groups -asynchronous -name $clk_group_name -group \{ [join $sorted_p_clk_names " "] \}"
		} else {
			if {$::options(verbose)} {
				hardcopy_msgs::post_debug_msg W_EMPTY_CLK_GROUP $clk_group_key
			}
			hardcopy_msgs::output_msg $outfile W_EMPTY_CLK_GROUP $clk_group_key
		}

		puts $outfile ""
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_clock_latencies { } {
	# Convert Quartus Clock Latency assignments.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	post_message -type info "** Processing Clock Latency assignments"

	hcii_util::formatted_write $outfile "
		
		
		###################
		# Clock Latencies #
		###################
	"

	# Convert LATE_CLOCK_LATENCY.
	hcii_qsf_based_conversion::convert_assignment \
		$outfile \
		LATE_CLOCK_LATENCY \
		1CLK \
		"set_clock_latency -source -late" \
		"" \
		"" \
		$hcii_qsf_based_conversion::asgn_value_type(time)
		
	# Convert EARLY_CLOCK_LATENCY.
	hcii_qsf_based_conversion::convert_assignment \
		$outfile \
		EARLY_CLOCK_LATENCY \
		1CLK \
		"set_clock_latency -source -early" \
		"" \
		"" \
		$hcii_qsf_based_conversion::asgn_value_type(time)
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::generate_output_pin_loadings { } {
	# Call hcii_qsf_based_conversion::generate_output_pin_loadings.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	hcii_qsf_based_conversion::generate_output_pin_loadings
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::generate_input_pin_transitions { } {
	# Call hcii_qsf_based_conversion::generate_input_pin_transitions.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	hcii_qsf_based_conversion::generate_input_pin_transitions
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::search_and_store_ext_delay_asgn { } {
	# Iterate though all Quartus assignments in the <rev>.hcii_ta.txt file
	# of Quartus to search & store INPUT/OUTPUT_MAX/MIN_DELAY assignments
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
        global min_input_array
        global max_input_array
        global min_output_array
        global max_output_array

        array set q_asgn { }

        # Open read in file that contains Quartus timing assignment info.
	set input_file_name "$::hc_output/${::rev_name}.hcii_ta.txt"
	set infile [open $input_file_name r]
        while {![eof $infile]} {
                set successful [hcii_tan_based_conversion::read_asgn $infile q_asgn]
                if {!$successful} {
                        continue
                }
                foreach port_id $q_asgn(to) {

                       foreach clk_id $q_asgn(from) {
                               if {[string equal $q_asgn(type) "input_min_delay"]} {
                                        if {[info exists min_input_array($port_id)]} {
                                               lappend min_input_array($port_id) $clk_id
                                        } else {
                                               set min_input_array($port_id) $clk_id
                                        }

                               } elseif {[string equal $q_asgn(type) "input_max_delay"]} {
                                        if {[info exists max_input_array($port_id)]} {
                                                  lappend max_input_array($port_id) $clk_id
                                        } else {
                                                  set max_input_array($port_id) $clk_id
                                        }

                                } elseif {[string equal $q_asgn(type) "output_min_delay"]} {
                                        if {[info exists min_output_array($port_id)]} {
                                                  lappend min_output_array($port_id) $clk_id
                                        } else {
                                                  set min_output_array($port_id) $clk_id
                                        }

                                } elseif {[string equal $q_asgn(type) "output_max_delay"]} {
                                        if {[info exists max_output_array($port_id)]} {
                                                  lappend max_output_array($port_id) $clk_id
                                        } else {
                                                  set max_output_array($port_id) $clk_id
                                        }
                                }
                       }
                }
        }
        close $infile
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_assignments { } {
	# Iterate though all Quartus assignments in the <rev>.hcii_ta.txt file
	# of Quartus and generate the corresponding Primetime commands.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global outfile

	# A Tcl array to store a read-in Quartus timing assignment.
	# Refer to hcii_tan_based_conversion::init_q_asgn for its data structure.
	array set q_asgn { }

	hcii_util::formatted_write $outfile "
		
		
		######################
		# Timing constraints #
		######################
	"

        # The algorithm is
        # TAN in STA_MODE = OFF
        #     - If *ta.txt file does not exist, give critical warning.
        #     - Else proceed processing
        # TAN in STA_MODE = ON
        #     - Do nothing in QII V6.0
	if { [string tolower [get_global_assignment -name STA_MODE]] != "on" } {
        	# Open read in file that contains Quartus timing assignment info.
        	set input_file_name "$::hc_output/${::rev_name}.hcii_ta.txt"
        
                # Issue critical warning message if the TA helper file does not exist.
        	if [catch {set infile [open $input_file_name r]}] {
        		hardcopy_msgs::post CW_CANNOT_OPEN_TA_FILE $input_file_name
        	} else {
        	       	# Find & Store all Quartus INPUT/OUTPUT_MAX/MIN_DELAY timing assignment info.
                         hcii_tan_based_conversion::search_and_store_ext_delay_asgn    

                	# Process timing assignments.
                	while {![eof $infile]} {
                		# Read in a timing assignment.
                		set successful [hcii_tan_based_conversion::read_asgn $infile q_asgn]
                		if {!$successful} {
                			continue
                		}
                
                		# Convert it to corresponding PrimeTime constraint.
                		if {$::options(verbose)} {
                			hardcopy_msgs::post_debug_msg I_CONVERT_Q_ASGN $q_asgn(type) $q_asgn(index)
                		}
                		puts $outfile "# ---------- q_asgn_index: $q_asgn(index) ----------"
                		switch -glob $q_asgn(type) {
                			cut {
                				hcii_tan_based_conversion::convert_cut_asgn q_asgn
                			}
                			multicycle {
                				hcii_tan_based_conversion::convert_multicycle_asgn q_asgn
                			}
                			input_min_delay	 -
                			input_max_delay	 -
                			output_min_delay -
                			output_max_delay {
                				hcii_tan_based_conversion::convert_input_output_min_max_delay_asgn q_asgn
                			}
                			clock_setup_uncertainty -
                			clock_hold_uncertainty {
                			        hcii_tan_based_conversion::convert_uncertainty_asgn q_asgn
                			}
                			default {
                				# read_asgn guarantees all read-in assignment types are
                				# translatable. So we can use default.
                				hcii_tan_based_conversion::convert_other_asgn q_asgn
                			}
                		}
                		puts $outfile "\n"
                	}	
                	close $infile
                }
        }
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::report_ignored_instance_assignments { } {
	# Function will iterate though all quartus assignments that the script
	# does not support and report them as warnings.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	post_message -type info "** Checking for unsupported assignments"

	foreach asgn_type $hcii_const::unsupported_instance_assignments {
		set asgn_list [get_all_instance_assignments -name $asgn_type]
		foreach_in_collection asgn $asgn_list {
			# set sect_id	[lindex $asgn 0]
			set from	[lindex $asgn 1]
			set to		[lindex $asgn 2]
			# set name	[lindex $asgn 3]
			set value	[lindex $asgn 4]

			if {$from != ""} {
				# P2P assignment
				post_message -type warning "Ignoring -name $asgn_type $value -from $from -to $to"
			} else {
				# SP assginment
				post_message -type warning "Ignoring -name $asgn_type $value -to $to"
			}
		}
	}	
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_asgn_src_dst { \
		q_asgn_ref \
		p_asgn_ref \
		force_to_use_coll \
		dst_cannot_be_empty \
	} {
	# Convert Quartus asgn src and dst (HDB_IDs) to PrimeTime asgn src and
	# dst (names or collections). The result is return to p_asgn by reference.
	#
	# After conversion, if dst set is empty, is_conversion_successful is set
	# to false (unless dst_cannot_be_empty = 0).
	# If passed src set is not empty but after conversion it is empty,
	# is_conversion_successful is set to false.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $q_asgn_ref q_asgn
	upvar $p_asgn_ref p_asgn

	global outfile

	variable cmd_translator

	# Return conversion process status.
	set is_conversion_successful 1

	# Quartus dst set is empty. Conversion fails.
	if {$dst_cannot_be_empty && [llength $q_asgn(to)] == 0} {
		if {$::options(verbose)} {
			hardcopy_msgs::post_debug_msg I_FAIL_TO_CONVERT_Q_ASGN $q_asgn(type) $q_asgn(index)
		}
		hardcopy_msgs::output_msg $outfile CW_Q_ASGN_DST_IS_EMPTY
		hardcopy_msgs::output_msg $outfile CW_CANNOT_CONVERT_ASGN
		return 0
	}

        if {$q_asgn(cmd) != "input_max_delay" && $q_asgn(cmd) != "input_min_delay"} {
		set q_asgn(to_type) AUTO
	}

	# If dst_can_be_emtpy and dst_is_empty skip converting dst set.
	set heterogeneous_dst 0
	if {$dst_cannot_be_empty || $q_asgn(to) != -1} {
		set p_asgn(to) [hcii_collection::convert_q_hdb_ids_to_p_collection \
							$outfile \
							$q_asgn(to_type) \
							$q_asgn(to) \
							$force_to_use_coll \
                                                        heterogeneous_dst]
                set p_asgn(hete_dst) $heterogeneous_dst

		# PrimeTime dst set is empty. Conversion fails.
		if {[llength $p_asgn(to)] == 0} {
			if {$::options(verbose)} {
				hardcopy_msgs::post_debug_msg I_FAIL_TO_CONVERT_Q_ASGN $q_asgn(type) $q_asgn(index)
			}
			
			hardcopy_msgs::output_msg $outfile CW_P_ASGN_DST_IS_EMPTY
			hardcopy_msgs::output_msg $outfile CW_CANNOT_CONVERT_ASGN
			return 0
		}
		# This is for input_max/min_delay assignment
		if {$p_asgn(to) == -1} {
		        return 0
		}
	}

	set p_asgn(cmd) $cmd_translator($q_asgn(cmd))
	set p_asgn(value) $q_asgn(value)

	# Quartus SP asgn.
	set src_size [llength $q_asgn(from)]
	if {$src_size == 0} {
		return 1
	}
	if {$q_asgn(from) == -1} {
		return 1
	}
        if {$q_asgn(cmd) == "input_max_delay" || \
            $q_asgn(cmd) == "input_min_delay" || \
            $q_asgn(cmd) == "output_max_delay" || \
            $q_asgn(cmd) == "output_min_delay"} {

                return 1
        }

	if {![info exists q_asgn(from_type)]} {
		set q_asgn(from_type) AUTO
	}

        set heterogeneous_src 0
	set p_asgn(from) [hcii_collection::convert_q_hdb_ids_to_p_collection \
						$outfile \
						$q_asgn(from_type) \
						$q_asgn(from) \
						$force_to_use_coll \
                                                heterogeneous_src]
        set p_asgn(hete_src) $heterogeneous_src

	# This should be a source SP asgn. Conversion fails.
	if {[llength $p_asgn(from)] == 0} {
		if {$::options(verbose)} {
			hardcopy_msgs::post_debug_msg I_FAIL_TO_CONVERT_Q_ASGN $q_asgn(type) $q_asgn(index)
		}
		hardcopy_msgs::output_msg $outfile CW_P_ASGN_SRC_IS_EMPTY
		hardcopy_msgs::output_msg $outfile CW_CANNOT_CONVERT_ASGN
		return 0
	}

	return $is_conversion_successful
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::adjust_clock_edges { edge0 edge1 period duty_ratio inv } {
	# Adjust Quartus clock edges.
	# Due to offset of phase, edge0 (rising) and edge1(falling) may go out of
	# the default period. Adjust them accordingly.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $edge0 edge_0
	upvar $edge1 edge_1

	if { $inv == 1 } {
		# Add enough offset to account for the inverted base clock
		set edge_0 [expr $edge_0 + $period * $duty_ratio]
		set edge_1 [expr $edge_1 + $period * (1.0 - $duty_ratio)]
	}

	# JTONG: No need to adjust edge_0 and edge_1 based on period.
	# Conceptually, it is incorrect to adjust them. And my test shows
	# it doesn't affect timing analysis in PrimeTime.
#	if { $edge_1 > $period } {
#		set edge_0 [expr $edge_0 - $period]
#		set edge_1 [expr $edge_1 - $period]
#	}
#	if { $edge_0 < 0.0 } {
#		set edge_0 [expr $edge_0 + $period]
#		set edge_1 [expr $edge_1 + $period]
#	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::create_derived_clock { clk_info_ref outfile } {
	# Create a PrimeTime derived clock for a Quartus derived clock.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $clk_info_ref clk_info
	
	# Cannot find base clock.
	if {$clk_info(base_clk) == -1} {
		hardcopy_msgs::post W_CANNOT_FIND_BASE_CLK
		hardcopy_msgs::output_msg $outfile W_CANNOT_FIND_BASE_CLK
		hardcopy_msgs::output_msg $outfile CW_CANNOT_CONVERT_CLK
		return
	}

	set p_clk_name $clk_info(p_name)
	msg_vdebug "Clock: Q = $clk_info(name) >>> PT = $p_clk_name"

	array set base_clk_info {}
	hcii_clock_info::get_clock_info [lindex $clk_info(base_clk) 0] base_clk_info
	set p_base_clk_name $base_clk_info(p_name)

	# Need to add clk_name as a clock in name_db
	set ::name_db(clk-$clk_info(name)) $p_clk_name

	# Remove name from ipin list to ensure that no INPUT Max/Min delay
	# is translated to this pin. Once it is a clock, it is no longer an
	# input pin.
	if [info exists ::name_db(ipin-$clk_info(name))] {
		msg_vdebug "Unseting ::name_db(ipin-${clk_info(name)})"
		unset ::name_db(ipin-${clk_info(name)})
	}

	# If phase != 0 or offset == 0, use create_generated_clock
	# Otherwise, use create_clock.
	if {$clk_info(phase) != 0 || $clk_info(offset) == 0} {

		# Calculate period:
		# If $clk_info(period) is a round number, set period to "$clk_info(period)"
		# If $clk_info(fmax) is a round number, set period to "1000 / $clk_info(fmax)"
		# If neither $clk_info(period) nor $clk_info(fmax) is a round number, set period to "$clk_info(period)"
		#
		# Assumptions:
		#   1. $clk_info(fmax)        always in     MHz
		#   2. $clk_info(period)      always in     ps

		if [expr $base_clk_info(period) == int($base_clk_info(period))] {
			set base_period [expr double($base_clk_info(period))]
		} elseif [expr $base_clk_info(fmax) == int($base_clk_info(fmax))] {
			set base_period [expr 1000 / double($base_clk_info(fmax))]
		} else {
			set base_period [expr double($base_clk_info(period))]
		}

		# Calculate period from Base Clock for better accuracy
		set period [expr $base_period * $clk_info(divide) / $clk_info(multiply)]

		set duty_ratio [expr double($clk_info(duty)) / 100.0]
		set shift [expr $period * double($clk_info(phase) / 360.0) + $clk_info(offset)] 
		set edge_0 $shift
		set edge_1 [expr $shift + $period * $duty_ratio]

		hcii_tan_based_conversion::adjust_clock_edges edge_0 edge_1 $period $duty_ratio $clk_info(inv)

		set offset1 $edge_0
		set clk_fall_edge [expr $period * $duty_ratio]
		set base_clk_fall_edge [expr $base_period * double($base_clk_info(duty)) / 100.0]
		set offset2 [expr $offset1 + $clk_fall_edge - $base_clk_fall_edge]
		set offset3 [expr $offset1 + $period - $base_period]

		# Only peform rounding after calculation is done
		set base_period [hcii_util::round $base_period 5]
		set divisor [hcii_util::round $clk_info(divide) 5]
		set multiplier [hcii_util::round $clk_info(multiply) 5]
		set period [hcii_util::round $period 5]
		set clk_fall_edge [hcii_util::round $clk_fall_edge 5]
		set offset1 [hcii_util::round $offset1 5]
		set offset2 [hcii_util::round $offset2 5]
		set offset3 [hcii_util::round $offset3 5]

		puts $outfile "# Period = Base Clock Period * Divisor / Multiplier = $base_period * $divisor / $multiplier = $period."
		puts $outfile "# Clock falling edge = $clk_fall_edge. Base clock falling edge = $base_clk_fall_edge."
		puts $outfile "create_generated_clock -edges \{1 2 3\} -edge_shift \{$offset1 $offset2 $offset3\} -source $p_base_clk_name -name $p_clk_name $p_clk_name"
	} else {	;# Phase == 0 && offset != 0

		# Calculate period:
		# If $clk_info(period) is a round number, set period to "$clk_info(period)"
		# If $clk_info(fmax) is a round number, set period to "1000 / $clk_info(fmax)"
		# If neither $clk_info(period) nor $clk_info(fmax) is a round number, set period to "$clk_info(period)"
		#
		# Assumptions:
		#   1. $clk_info(fmax)        always in     MHz
		#   2. $clk_info(period)      always in     ps

		if [expr $base_clk_info(period) == int($base_clk_info(period))] {
			set base_period [expr double($base_clk_info(period))]
		} elseif [expr $base_clk_info(fmax) == int($base_clk_info(fmax))] {
			set base_period [expr 1000 / double($base_clk_info(fmax))]
		} else {
			set base_period [expr double($base_clk_info(period))]
		}

		# Calculate period from Base Clock for better accuracy
		set period [expr $base_period * $clk_info(divide) / $clk_info(multiply)]

		set waveform ""

		if [expr $clk_info(duty) != 50] {
			set duty_ratio [expr double($clk_info(duty)) / 100.0]
			set shift [expr double($clk_info(offset))] 
			set edge_0 $shift
			set edge_1 [expr $shift + $period * $duty_ratio]

			hcii_tan_based_conversion::adjust_clock_edges edge_0 edge_1 $period $duty_ratio $clk_info(inv)

			# Only peform rounding after calculation is done
			set edge_0 [hcii_util::round $edge_0 5]
			set edge_1 [hcii_util::round $edge_1 5]

			set waveform "-waveform \{ $edge_0 $edge_1 \} "
		}

		# Only peform rounding after calculation is done
		set base_period [hcii_util::round $base_period 5]
		set divisor [hcii_util::round $clk_info(divide) 5]
		set multiplier [hcii_util::round $clk_info(multiply) 5]
		set period [hcii_util::round $period 5]

		puts $outfile "# Period = Base Clock Period * Divisor / Multiplier = $base_period * $divisor / $multiplier = $period."
		puts $outfile "create_clock -period $period $waveform$p_clk_name -name $p_clk_name"
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::create_base_clock { clk_info_ref outfile } {
	# Function to dump a PrimeTime create_clock statement for a Quartus
	# base clock.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $clk_info_ref clk_info

	msg_vdebug "Clock: Q = $clk_info(name) >>> PT = $clk_info(p_name)"

	# Need to add clk_name as a clock in name_db
	set ::name_db(clk-$clk_info(name)) $clk_info(p_name)

	# Remove name from ipin list to ensure that no INPUT Max/Min delay
	# is translated to this pin. Once it is a clock, it is no longer an
	# input pin.
	if [info exists ::name_db(ipin-$clk_info(name))] {
		msg_vdebug "Unseting ::name_db(ipin-${clk_info(name)})"
		unset ::name_db(ipin-${clk_info(name)})
	}

	# Calculate period:
	# If $clk_info(period) is a round number, set period to "$clk_info(period)"
	# If $clk_info(fmax) is a round number, set period to "1000 / $clk_info(fmax)"
	# If neither $clk_info(period) nor $clk_info(fmax) is a round number, set period to "$clk_info(period)"
	#
	# Assumptions:
	#   1. $clk_info(fmax)        always in     MHz
	#   2. $clk_info(period)      always in     ps

	if [expr $clk_info(period) == int($clk_info(period))] {
		set period [expr double($clk_info(period))]
	} elseif [expr $clk_info(fmax) == int($clk_info(fmax))] {
		set period [expr 1000 / double($clk_info(fmax))]
	} else {
		set period [expr double($clk_info(period))]
	}

        #SPR 231106: Take phase shift, offset and invert option into consideration while calculating the waveform
	set waveform ""

	set duty_ratio [expr double($clk_info(duty)) / 100.0]
	set shift [expr $period * double($clk_info(phase) / 360.0) + $clk_info(offset)]
	set edge_0 $shift
	set edge_1 [expr $shift + $period * $duty_ratio]

        if {$clk_info(inv) == 1} {
       		set edge_0 [expr $edge_0 + $period * (1- $duty_ratio)]
                set edge_1 [expr $shift + $period]
        }

        # Only peform rounding after calculation is done
        set edge_0 [hcii_util::round $edge_0 5]
        set edge_1 [hcii_util::round $edge_1 5]
        set waveform "-waveform \{ $edge_0 $edge_1 \} "

	# Only peform rounding after calculation is done
	set period [hcii_util::round $period 5]

	puts $outfile "create_clock -period $period $waveform$clk_info(p_name) -name $clk_info(p_name)"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::read_clock { infile clk_info_ref } {
	# Read a Quartus clock.
	# The content is stored in array q_clk_info.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $clk_info_ref clk_info

	# The tag_key_map references to hcii_clock_info::clk_info_tag_key_map,
	# which defines the mapping between clock info tags in the TAN
	# dumped clock file to the list of value types (string or list) and keys
	# of internal clock data structures (Tcl arrays).
	array set tag_key_map [hcii_clock_info::get_clock_info_tag_key_map]

	# Initialize clk_info to have default values.
	hcii_clock_info::initialize_clock_info "clk_info"

	set all_tags [array names tag_key_map]
	set read_is_successful 0
	while {[gets $infile line] > 0} {
		# Skip comments.
		if {[regexp {^( |\t)*#} $line]} {
			continue
		}

		if {[regexp {^( |\t)*CLOCK} $line]} {
			# Find keyword CLOCK.
			if {[regexp {\((.*)\)$} $line match index]} {
				# Set clk_info index.
				set clk_info(index) $index
			}
		} else {
			# Ignore unrecognized Quartus clock cmd.
			post_message -type warning "Ignoring unrecognized Quartus clock syntax: $line."
			continue
		}

		while {[gets $infile line] > 0} {
			# The END keyword indicates the end of a clock info block.
			if {$line == "END"} {
				set read_is_successful 1
				break
			}

			# Parse clock info line by line.
			set tag [lindex $line 0]
			if {[lsearch -exact $all_tags $tag] != -1} {
				set value_type [lindex $tag_key_map($tag) 0]
				set key [lindex $tag_key_map($tag) 1]
				if {$value_type == "l"} {
					set clk_info($key) [lreplace $line 0 0]
				} else {
					set clk_info($key) [lindex $line 1]
				}
			}
		}

		if {$read_is_successful} {
			break
		}
	}

	return $read_is_successful
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::check_clock_validity { outfile } {
	# Check read in Quartus clocks' validity. Append warning or error messages
	# to the clock if it was found invalid.
	#
	# A invalid clock is:
	# -	Its period, duty cycle, offset, phase, etc. are valid.
	# -	Its ID matches its name.
	# - Can find corresponding PrimeTime name.
	# - Specified base clock is valid.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	array set clk_info { }

	foreach clk_id [hcii_clock_info::get_all_clock_ids] {
		hcii_clock_info::get_clock_info $clk_id clk_info
		set is_invalid_clk 0
		set msgs ""

		# ******************************************************************
		#
		#	Check specified period, duty cycle, offset, phase, etc. are valid.
		#
		if ![string is double -strict $clk_info(period)] {
			lappend msgs [list	W_VALUE_IS_NOT_A_NUMBER \
								[hcii_util::to_list "period" $clk_info(period)]]
			set is_invalid_clk 1
		} elseif {$clk_info(period) <= 0.0} {
			lappend msgs [list	W_NO_CLOCK_CONSTRAINT \
								[hcii_util::to_list $clk_info(name)]]
			set is_invalid_clk 1
		} elseif ![string is double -strict $clk_info(duty)] {
			lappend msgs [list	W_VALUE_IS_NOT_A_NUMBER \
								[hcii_util::to_list	"duty cycle" $clk_info(duty)]]
			set is_invalid_clk 1
		} elseif {$clk_info(duty) <= 0.0} {
			lappend msgs [list	W_VALUE_SMALLER_THAN_0 \
								[hcii_util::to_list "duty cycle" $clk_info(duty)]]
			set is_invalid_clk 1
		} elseif ![string is double -strict $clk_info(offset)] {
			lappend msgs [list	W_VALUE_IS_NOT_A_NUMBER \
								[hcii_util::to_list "offset" $clk_info(offset)]]
			set is_invalid_clk 1
		} elseif ![string is double -strict $clk_info(phase)] {
			lappend msgs [list	W_VALUE_IS_NOT_A_NUMBER \
								[hcii_util::to_list "phase" $clk_info(phase)]]
			set is_invalid_clk 1
		}

		if {$is_invalid_clk} {
			lappend msgs CW_CANNOT_CONVERT_CLK
			# Add the messages to the clock_info.
			hcii_clock_info::update_clock_info_by_type $clk_id msgs $msgs
			# Mark this clock invalid.
			hcii_clock_info::unset_clock_info $clk_id
			continue
		}
		#
		# ******************************************************************

		# ******************************************************************
		#
		#	Check clock ID matches clock name, and base clock ID, if exists,
		#	matched base clock name.
		#
		if [catch {set q_clk_name [hcii_name_db::get_q_name_by_hdb_id $clk_info(clk)]}] {
			lappend msgs [list	W_CLKS_Q_NAME_NO_FOUND \
								[hcii_util::to_list "clock" $clk_info(clk)]]
			set is_invalid_clk 1
		} elseif {$q_clk_name != $clk_info(name)} {
			lappend msgs [list	W_CLK_ID_NAME_MISMATCH \
								[hcii_util::to_list "clock" \
													$clk_info(clk) \
													$clk_info(name) \
													$q_clk_name]]
			set is_invalid_clk 1
		}

		if {$is_invalid_clk} {
			lappend msgs CW_CANNOT_CONVERT_CLK
			# Add this message to the clock_info.
			hcii_clock_info::update_clock_info_by_type $clk_id msgs $msgs
			# Mark this clock invalid.
			hcii_clock_info::unset_clock_info $clk_id
			continue
		}

		set base_clk_cnt [llength $clk_info(base_clk)]
		if {$base_clk_cnt != [llength $clk_info(base_clk_name)]} {
			lappend msgs W_BASE_CLK_ID_NAME_CNT_NOT_EQUAL
			set is_invalid_clk 1
		}

		if {$is_invalid_clk} {
			lappend msgs CW_CANNOT_CONVERT_CLK
			# Add this message to the clock_info.
			hcii_clock_info::update_clock_info_by_type $clk_id msgs $msgs
			# Mark this clock invalid.
			hcii_clock_info::unset_clock_info $clk_id
			continue
		}

		if {$base_clk_cnt > 1} {
			lappend msgs W_MULTI_BASE_CLK
			# Add this message to the clock_info.
			hcii_clock_info::update_clock_info_by_type $clk_id msgs $msgs
		}

		if {$clk_info(base_clk) != -1} {
			if [catch {set q_base_clk_name [hcii_name_db::get_q_name_by_hdb_id [lindex $clk_info(base_clk) 0]]}] {
				lappend msgs [list	W_CLKS_Q_NAME_NO_FOUND \
									[hcii_util::to_list "base clock"  $clk_info(clk)]]
				set is_invalid_clk 1
			} elseif {$q_base_clk_name != [lindex $clk_info(base_clk_name) 0]} {
				lappend msgs [list	W_CLK_ID_NAME_MISMATCH \
									[hcii_util::to_list "base clock" $clk_info(clk) $clk_info(name) $q_clk_name]]
				set is_invalid_clk 1
			}
		} elseif {$clk_info(base_clk_name) != "--"} {
			lappend msgs [list	W_SHOULD_BE_NO_BASE_CLK \
								[hcii_util::to_list $clk_info(base_clk_name)]]
			set is_invalid_clk 1
		}

		if {$is_invalid_clk} {
			lappend msgs CW_CANNOT_CONVERT_CLK
			# Add this message to the clock_info.
			hcii_clock_info::update_clock_info_by_type $clk_id msgs $msgs
			# Mark this clock invalid.
			hcii_clock_info::unset_clock_info $clk_id
			continue
		}
		#
		# ******************************************************************

		# ******************************************************************
		#
		#	Check PrimeTime name for Quartus clock can be found.
		#
		set p_clk_name [hcii_collection::get_p_name_or_collection $outfile KPR $clk_info(name) 1]
		if {$p_clk_name == ""} {
			msg_vdebug "$clk_info(name) not found in KPR cache (need extra time to find)."
			set p_clk_name [hcii_collection::get_non_kpr_p_collection $clk_info(name)]

			if {$p_clk_name == "NOT_FOUND"} {
				lappend msgs [list	W_CLKS_P_NAME_NOT_FOUND \
									[hcii_util::to_list $clk_info(name)]]
				set is_invalid_clk 1
			}
		}

		if {$is_invalid_clk} {
			lappend msgs CW_CANNOT_CONVERT_CLK
			# Add this message to the clock_info.
			hcii_clock_info::update_clock_info_by_type $clk_id msgs $msgs
			# Mark this clock invalid.
			hcii_clock_info::unset_clock_info $clk_id
			continue
		}
		#
		# ******************************************************************
	}

	foreach clk_id [hcii_clock_info::get_valid_clock_ids] {
		hcii_clock_info::get_clock_info $clk_id clk_info
		set is_invalid_clk 0

		# ******************************************************************
		#
		#	Check specified base clocks are valid clocks.
		#
		if {$clk_info(base_clk) != -1} {
			set is_base_clk_valid [hcii_clock_info::get_clock_info_by_type \
									[lindex $clk_info(base_clk) 0] \
									"is_valid"]
			if {$is_base_clk_valid == "" || $is_base_clk_valid != 1} {
				lappend msgs [list	W_INVALID_BASE_CLOCK \
									[hcii_util::to_list [lindex $clk_info(base_clk_name) 0]]]
				set is_invalid_clk 1
			}
		}

		if {$is_invalid_clk} {
			lappend msgs CW_CANNOT_CONVERT_CLK
			# Add this message to the clock_info.
			hcii_clock_info::update_clock_info_by_type $clk_id msgs $msgs
			# Mark this clock invalid.
			hcii_clock_info::unset_clock_info $clk_id
			continue
		}
		#
		# ******************************************************************

		# ******************************************************************
		#
		#	Get corresponding PrimeTime name.
		#
		# The Quartus name is an embedded register port.
		set q_clk_name $clk_info(name)
		if [info exists ::pin_name_db($q_clk_name)] {
			set p_clk_name $::pin_name_db($q_clk_name)
		# The Quartus name is a PLL clock port.
		} elseif [info exists ::name_db(clk-$q_clk_name)] {
			set p_clk_name $::name_db(clk-$q_clk_name)
		# The Quartus name is an input pin.
		} elseif [info exists ::name_db(ipin-$q_clk_name)] {
			set p_clk_name $::name_db(ipin-$q_clk_name)
		# The Quartus name is a register.
		} elseif [info exists ::name_db(kpr-$q_clk_name)] {
			# We need to hard code the /Q for 5.1.
			set p_clk_name "$::name_db(kpr-$q_clk_name)/Q"
		# The Quartus name is not a keeper.
		} else {
			set p_clk_name ""
		}

		if {$p_clk_name == ""} {
			set p_clk_name [hcii_collection::get_non_kpr_p_collection $q_clk_name]
			if {$p_clk_name == "NOT_FOUND"} {
				lappend msgs [list	W_CLKS_P_NAME_NOT_FOUND \
									[hcii_util::to_list $q_clk_name]]
				set is_invalid_clk 1
			}
		}

		if {$is_invalid_clk} {
			lappend msgs CW_CANNOT_CONVERT_CLK
			# Add this message to the clock_info.
			hcii_clock_info::update_clock_info_by_type $clk_id msgs $msgs
			# Mark this clock invalid.
			hcii_clock_info::unset_clock_info $clk_id
			continue
		}

		hcii_clock_info::update_clock_info_by_type $clk_id "p_name" $p_clk_name
		#
		# ******************************************************************
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::init_q_asgn { q_asgn_ref } {
	# Initiate the Tcl array that holds a Quartus timing assignment.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $q_asgn_ref q_asgn
	# A Tcl array to store a read-in Quartus timing assignment.
	# A q_asgn has the following keys:
	#	index - assignment index defined in *.hcii_ta.txt file, for debugging.
	#	type  - assignment type, eg. cut, input_max_delay.
	#	cmd   - assignment command, content is the same as that in type.
	#			(To make it compatible to p_asgn cmd.)
	#	value - assignment value. No units. For time assignment, the unit is 
	#			default to ns.
	#	from  - source list.
	#	to    - destination list.
	array set q_asgn { \
		index	"" \
		type	"" \
		cmd		"" \
		value	"" \
		from	"" \
		to		"" \
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::init_p_asgn { p_asgn_ref } {
	# Initiate the Tcl array that holds a translated PrimeTime timing
	# asssignment (constraint).
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $p_asgn_ref p_asgn

	# A Tcl array to store a translated PrimeTime timing asssignment.
	# A q_asgn has the following keys:
	#	cmd   - assignment command.
	#	value - assignment value. No units. For time assignment, the unit is 
	#			default to ns.
	#	from  - source list.
	#	to    - destination list.
	#       hete_src - To indicate the Heterogeneous Source
	#       hete_dst - To indicate the Heterogeneous Destination
	array set p_asgn { \
		cmd		"" \
		value	"" \
		from	"" \
		to		"" \
		hete_src   0 \
		hete_dst   0 \
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_multicycle_asgn { q_asgn_ref } {
	# Convert a group of Quartus multicycle assignments.
        # Assumptions
        # 1. User do not apply both MC and SRC_MC to the same source and destination
        #       a)If Yes, then both commands will be generated together with warning message.
        # 2. User do not apply both HOLD_MC and SRC_HOLD_MC to the same source and destination
        #       a)If Yes, then both commands will be generated together with warning message.
        # 3. No translation when as it is the default value in PrimeTime
        #       a) MC == 1
        #       b) SRC_MC == 1
        #       c) HOLD_MC == 0
        #       d) SRC_HOLD_MC == 0
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $q_asgn_ref q_asgn
	variable cmd_translator
	global outfile

	# Initialize p_asgn array.
	hcii_tan_based_conversion::init_p_asgn p_asgn

        # Loop through the individual assignment.
        # 1. If MC > 1 and SRC_MC > 1 then save information into all_mc_cmd
        # 2. If HOLD_MC > 0 and SRC_HOLD MC > 0 then save information into all_hold_mc_cmd
        set all_mc_hold_cmd [set all_mc_cmd {}]
        foreach {asgn_type asgn_value} $q_asgn(value) {
             set asgn_type [string tolower $asgn_type]
             if {[string match "*hold*" $asgn_type]} {
                if {$asgn_value > 0} {
                   lappend all_mc_hold_cmd "$cmd_translator($asgn_type) $asgn_value"
                }
             } else {
                if {$asgn_value > 1} {
                   lappend all_mc_cmd "$cmd_translator($asgn_type) $asgn_value"
                }
             }
        }

        # If we have more that 1 multicycle (MC, SRC_MC, HOLD_MC and SRC_HOLD_MC)
	# asgn on the same src and dst, it is better to use collections.
	# So set force_to_use_coll to 1.
        set total_cmd [expr {[llength $all_mc_hold_cmd] + [llength $all_mc_cmd]}]
        if {$total_cmd > 1} {
		set force_to_use_coll 1
        } else {
                set force_to_use_coll 0
	}

        # Only declare the src and dst when there is an assgnment.
        if {$total_cmd > 0} {
	        if {![hcii_tan_based_conversion::convert_asgn_src_dst q_asgn p_asgn $force_to_use_coll 1]} {
		        return
	        }
    	}

        set from_param {}

        if { $p_asgn(hete_src)== 0 && $p_asgn(hete_dst) == 0 } {
        if {[llength $p_asgn(from)] != 0} {
                set from_param "-from $p_asgn(from)"
        }
        set to_param "-to $p_asgn(to)"

        # Issue Warning when both MC and SRC_MC are set as Quartus & PrimeTime handle this differently
        if {[llength $all_mc_cmd] == 2} {
                hardcopy_msgs::output_msg $outfile W_MULTI_MC_ASGN
        }
        foreach {pt_cmd} $all_mc_cmd {
                puts $outfile "$pt_cmd $from_param $to_param"
        }

        # Issue Warning when both HOLD_MC and SRC_HOLD_MC are set as Quartus & PrimeTime handle this differently
        if {[llength $all_mc_hold_cmd] == 2} {
                hardcopy_msgs::output_msg $outfile W_MULTI_HOLD_MC_ASGN
		}
        foreach {pt_cmd} $all_mc_hold_cmd {
                puts $outfile "$pt_cmd $from_param $to_param"
	}
        } else {
               # Three possible cases
               # 1. Source is Heterogeneous & Destination is NOT
               # 2. Source is NOT Heterogeneous & Destination is Heterogeneous
               # 3. Source is Heterogeneous & Destination is Heterogeneous
               if { $p_asgn(hete_src) == 1 && $p_asgn(hete_dst) == 0} {
                    set to_param {}
                    if {[llength $p_asgn(to)] != 0} {
                       set to_param "-to $p_asgn(to)"
                    }
                    puts $outfile "foreach src \[list $p_asgn(from)\] {"
                    if {[llength $all_mc_cmd] == 2} {
                        hardcopy_msgs::output_msg $outfile W_MULTI_MC_ASGN
                      }
                      foreach {pt_cmd} $all_mc_cmd {
                              puts $outfile "      $pt_cmd -from \[set \$src\] $to_param"
                      }

                      if {[llength $all_mc_hold_cmd] == 2} {
                        hardcopy_msgs::output_msg $outfile W_MULTI_HOLD_MC_ASGN
        		}
                      foreach {pt_cmd} $all_mc_hold_cmd {
                              puts $outfile "      $pt_cmd -from \[set \$src\] $to_param"
        	        }
                    puts $outfile "}"
               } elseif { $p_asgn(hete_src) == 0 && $p_asgn(hete_dst) == 1} {
                    set from_param {}
                    if {[llength $p_asgn(from)] != 0} {
                       set from_param "-from $p_asgn(from)"
                    }
                    puts $outfile "foreach dst \[list $p_asgn(to)\] {"
                    if {[llength $all_mc_cmd] == 2} {
                        hardcopy_msgs::output_msg $outfile W_MULTI_MC_ASGN
                      }
                      foreach {pt_cmd} $all_mc_cmd {
                              puts $outfile "      $pt_cmd $from_param -to \[set \$dst\]"
                      }

                      if {[llength $all_mc_hold_cmd] == 2} {
                        hardcopy_msgs::output_msg $outfile W_MULTI_HOLD_MC_ASGN
        		}
                      foreach {pt_cmd} $all_mc_hold_cmd {
                              puts $outfile "      $pt_cmd $from_param -to \[set \$dst\]"
        	        }
                    puts $outfile "}"
               } else {

                    puts $outfile "foreach src \[list $p_asgn(from)\] {"
                    puts $outfile "      foreach dst \[list $p_asgn(to)\] {"
                    if {[llength $all_mc_cmd] == 2} {
                        hardcopy_msgs::output_msg $outfile W_MULTI_MC_ASGN
                      }
                      foreach {pt_cmd} $all_mc_cmd {
                              puts $outfile "            $pt_cmd -from \[set \$src\] -to \[set \$dst\]"
                      }

                      if {[llength $all_mc_hold_cmd] == 2} {
                        hardcopy_msgs::output_msg $outfile W_MULTI_HOLD_MC_ASGN
        		}
                      foreach {pt_cmd} $all_mc_hold_cmd {
                              puts $outfile "            $pt_cmd -from \[set \$src\] -to \[set \$dst\]"
        	        }
                    puts $outfile "      }"
                    puts $outfile "}"
               }

        }
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_cut_asgn { q_asgn_ref } {
	# Convert a Quartus cut assignment.
        # Implementation
        # 1. Only CUT = ON will be translated
        # 2. When CUT = OFF Information Message will be issued.
        #    No translation for CUT = OFF as it is equavalent to not specify set_false_path command.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $q_asgn_ref q_asgn

	global outfile

	# Initialize p_asgn array.
	hcii_tan_based_conversion::init_p_asgn p_asgn

	# Convert src and dst to PrimeTime names or collections.
	if {![hcii_tan_based_conversion::convert_asgn_src_dst q_asgn p_asgn 0 0]} {
		# NOTE:	SP cut can be assigned to a combo node. We currently don't
		#		implement this. So need the following checking.
		if {$q_asgn(from) == -1 || $q_asgn(to) == -1} {	;# SP CUT case.
			hardcopy_msgs::output_msg $outfile CW_LIMITED_SUPPORT_OF_CUT
		}
		return
	}

	if {$p_asgn(value)} {
	        set cmd $p_asgn(cmd)
	}
	set src_size [llength $p_asgn(from)]
	set dst_size [llength $p_asgn(to)]

        # Always check the CUT value and give information message if CUT = OFF.
        if { $p_asgn(hete_src) == 0 && $p_asgn(hete_dst) == 0 } {
	if {$src_size == 0} {
		# SP destination cut case.
		if {!$p_asgn(value)} {
		        hardcopy_msgs::output_msg $outfile I_CUT_OFF_TO [ list $p_asgn(to) ]
		} else {
		        puts $outfile "$cmd -to $p_asgn(to)"
		}
	} elseif {$dst_size == 0} {
		# SP source cut case.
		if {!$p_asgn(value)} {
       		        hardcopy_msgs::output_msg $outfile I_CUT_OFF_FROM [ list $p_asgn(from) ]
		} else {
		        puts $outfile "$cmd -from $p_asgn(from)"
		}
	} else {
		# P2P cut case.
       		if {!$p_asgn(value)} {
    		        hardcopy_msgs::output_msg $outfile I_CUT_OFF_FROM_TO [ list $p_asgn(from) $p_asgn(to) ]
       		} else {
		        puts $outfile "$cmd -from $p_asgn(from) -to $p_asgn(to)"
	        }
	}
        } else {
              	# P2P cut case.
        	if {!$p_asgn(value)} {
        	        if {$src_size == 0} {
       	                        hardcopy_msgs::output_msg $outfile I_CUT_OFF_TO [ list $p_asgn(to) ]
        	        } elseif {$dst_size == 0} {
                                hardcopy_msgs::output_msg $outfile I_CUT_OFF_FROM [ list $p_asgn(from) ]
        	        } else {
        	                hardcopy_msgs::output_msg $outfile I_CUT_OFF_FROM_TO [ list $p_asgn(from) $p_asgn(to) ]
        	        }
             	} else {

        	        if { $p_asgn(hete_src) == 0 && $p_asgn(hete_dst) == 1} {
        	                set from_param {}
                                if {[llength $p_asgn(from)] != 0} {
                                   set from_param "-from $p_asgn(from)"
                                }
            		        puts $outfile "foreach dst \[list $p_asgn(to)\] {"
            		        puts $outfile "      $cmd $from_param -to \[set \$dst\]"
              		        puts $outfile "}"
        	        } elseif { $p_asgn(hete_src) == 1 && $p_asgn(hete_dst) == 0} {
                    	        set to_param {}
                                if {[llength $p_asgn(to)] != 0} {
                                   set to_param "-to $p_asgn(to)"
                                }
        	                puts $outfile "foreach src \[list $p_asgn(from)\] {"
            		        puts $outfile "      $cmd -from \[set \$src\] $to_param"
              		        puts $outfile "}"
        	        } else {
                    	        puts $outfile "foreach src \[list $p_asgn(from)\] {"
            		        puts $outfile "      foreach dst \[list $p_asgn(to)\] {"
            		        puts $outfile "            $cmd -from \[set \$src\] -to \[set \$dst\]"
            		        puts $outfile "      }"
              		        puts $outfile "}"
        	        }
  	        }
        }
}                                                                              

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_default_input_output_min_max_delay_asgn { q_asgn_ref p_asgn_ref } {
	# SPR 196138:
        # Convert a default Quartus [input/output]_[min/max]_delay assignment.
	# Default INPUT_MAX_DELAY (not specified by users) to INPUT_MIN_DELAY (specified by users)
	# This happen vice-versa. Also, this apply to OUTPUT_[MIN/MAX]_Delay assignment.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
        upvar $q_asgn_ref q_asgn
        upvar $p_asgn_ref p_asgn

        array set duplicate_q_asgn { }
        array set duplicate_p_asgn { }
        array set io_delay_array { }
        set duplicate_asgn_type ""
        variable cmd_translator

        global outfile
        global min_input_array
        global max_input_array
        global min_output_array
        global max_output_array
        
        # Initialize duplicate_q_asgn array.
        hcii_tan_based_conversion::init_q_asgn duplicate_q_asgn
        
        if {[string equal $q_asgn(type) "input_max_delay"]} {
                array set io_delay_array [array get min_input_array]
                set duplicate_asgn_type "input_min_delay"

        } elseif {[string equal $q_asgn(type) "input_min_delay"]} {
                array set io_delay_array [array get max_input_array]
                set duplicate_asgn_type "input_max_delay"

        } elseif {[string equal $q_asgn(type) "output_max_delay"]} {
                array set io_delay_array [array get min_output_array]
                set duplicate_asgn_type "output_min_delay"

        } elseif {[string equal $q_asgn(type) "output_min_delay"]} {
                array set io_delay_array [array get max_output_array]
                set duplicate_asgn_type "output_max_delay"
        }

        # Search for corresponding opposite type assignment, e.g. input_max_delay <=> input_min_delay
        if {[array size io_delay_array] > 0} {
                set port_index 0
                set clk_index 0

                # Case 1: from many clock to 1 port
                if {[llength $q_asgn(to)] == 1} {
                        if {[info exists io_delay_array($q_asgn(to))]} {
                                foreach orig_clk_id $q_asgn(from) {
                                        if {[lsearch $io_delay_array($q_asgn(to)) $orig_clk_id] == -1} {
                                                if {$clk_index == 0} {
                                                        set duplicate_q_asgn(from) $orig_clk_id
                                                        set duplicate_q_asgn(to) $q_asgn(to)
                                                        incr clk_index
                                                } else {
                                                        lappend duplicate_q_asgn(from) $orig_clk_id
                                                }
                                        }
                                }
                        } else {
                               set duplicate_q_asgn(to) $q_asgn(to)
                               set duplicate_q_asgn(from) $q_asgn(from)
                        }

                # Case 2: from 1 clock to many port
                } elseif {[llength $q_asgn(from)] == 1} {
                        foreach orig_port_id $q_asgn(to) {
                                if {[info exists io_delay_array($orig_port_id)]} {
                                          if {[lsearch $io_delay_array($orig_port_id) $q_asgn(from)] == -1} {
                                                if {$port_index == 0} {
                                                        set duplicate_q_asgn(to) $orig_port_id
                                                        set duplicate_q_asgn(from) $q_asgn(from)
                                                        incr port_index
                                                } else {
                                                        lappend duplicate_q_asgn(to) $orig_port_id
                                                }
                                           }
                                } else {
                                          if {$port_index == 0} {
                                                set duplicate_q_asgn(to) $orig_port_id
                                                set duplicate_q_asgn(from) $q_asgn(from)
                                                incr port_index
                                          } else {
                                                lappend duplicate_q_asgn(to) $orig_port_id
                                          }
                                }
                        }
                }
        } else {
                set duplicate_q_asgn(from) $q_asgn(from)
                set duplicate_q_asgn(to) $q_asgn(to)
        }
        
        if {[llength $duplicate_q_asgn(from)] > 0 && [llength $duplicate_q_asgn(to)] > 0 && [string length $duplicate_asgn_type] > 0} {
                set duplicate_q_asgn(index) $q_asgn(index)
                set duplicate_q_asgn(type) $duplicate_asgn_type
                set duplicate_q_asgn(cmd) $duplicate_q_asgn(type)
                set duplicate_q_asgn(value) $q_asgn(value)
                # The to_type parameter is used to eliminate clock ports for Input_Max/Min_delay assignment in *.ta.txt
                set duplicate_q_asgn(to_type) DEFAULT_INPUT_DELAY_PORTS

        } else {
                unset duplicate_q_asgn
        }

        if {[array size duplicate_q_asgn] > 0} {
                # Initialize p_asgn array.
                hcii_tan_based_conversion::init_p_asgn duplicate_p_asgn

                if {[llength $duplicate_q_asgn(to)] == [llength $q_asgn(to)]} {
                       set duplicate_p_asgn(to) $p_asgn(to)
                       set duplicate_p_asgn(cmd) $cmd_translator($duplicate_q_asgn(cmd))
                       set duplicate_p_asgn(value) $duplicate_q_asgn(value)

                } else {
                       # Convert src and dst to PrimeTime names or collections.
                       puts $outfile " "
                       # Sort the elements in the list so that output into PT script in a proper order
                       if {$duplicate_q_asgn(to) != ""} {
                           set sorted_to_list [lsort $duplicate_q_asgn(to)]
                           set duplicate_q_asgn(to) $sorted_to_list
                        }
                       if {![hcii_tan_based_conversion::convert_asgn_src_dst duplicate_q_asgn duplicate_p_asgn 1 1]} {
		          return
	               }
	        }

	        #set src_size [llength $duplicate_q_asgn(from)]
	        set dst_size [llength $duplicate_p_asgn(to)]

	        if {$dst_size > 0} {
	               set msg_index 0
	               puts $outfile " "

                       if {$duplicate_q_asgn(from) != ""} {
                          set q_clk_list [lsort $duplicate_q_asgn(from)]
                       }

	               foreach q_clk_id $q_clk_list {

	                       if [catch {set q_clk_name [hcii_name_db::get_q_name_by_hdb_id $q_clk_id]}] {
	                                hardcopy_msgs::output_msg W_CLKS_Q_NAME_NOT_FOUND $q_clk_id
	                                continue
	                       }
	                       set p_key [hcii_name_db::get_q2p_name_db_key CLK $q_clk_name]
	                       if {[info exists ::name_db($p_key)]} {
	                                set p_clk_name $::name_db($p_key)
                               } else {
                                        hardcopy_msgs::output_msg $outfile W_CLKS_P_NAME_NOT_FOUND $q_clk_name
                                        continue
                               }

                               if {$msg_index == 0} {
                                        hardcopy_msgs::output_msg $outfile I_CONVERT_DEFAULT_Q_ASGN $duplicate_q_asgn(type) $q_asgn(type)
                                        incr msg_index
                               }
                               puts $outfile "$duplicate_p_asgn(cmd) $duplicate_p_asgn(value) -clock \[get_clocks {$p_clk_name}] $duplicate_p_asgn(to)"
                       }
                }
        }
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_input_output_min_max_delay_asgn { q_asgn_ref } {
	# Convert a Quartus [input/output]_[min/max]_delay assignment.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $q_asgn_ref q_asgn

	global outfile

	# Initialize p_asgn array.
	hcii_tan_based_conversion::init_p_asgn p_asgn

        # Sort the elements in the list so that output into PT script in a proper order
        if {$q_asgn(to) != ""} {
            set sorted_to_list [lsort $q_asgn(to)]
            set q_asgn(to) $sorted_to_list
        }

        # The to_type parameter is used to eliminate clock ports for Input_Max/Min_delay assignment in *.ta.txt
        set q_asgn(to_type) INPUT_DELAY_PORTS

	# Convert src and dst to PrimeTime names or collections.
	if {![hcii_tan_based_conversion::convert_asgn_src_dst q_asgn p_asgn 1 1]} {
		return
	}

        set src_size [llength $q_asgn(from)]
        if {$src_size == 0 || $q_asgn(from) == -1} {
		post_message -type warning "Ignoring Quartus SP $q_asgn(type) assignment."
		puts $outfile "# Don't support to convert Quartus SP $q_asgn(type) asgn."

        } else {
               set q_clk_list [lsort $q_asgn(from)]
               foreach q_clk_id $q_clk_list {

                       if [catch {set q_clk_name [hcii_name_db::get_q_name_by_hdb_id $q_clk_id]}] {
                                hardcopy_msgs::output_msg W_CLKS_Q_NAME_NOT_FOUND $q_clk_id
                                continue
                       }

                       set p_key [hcii_name_db::get_q2p_name_db_key CLK $q_clk_name]
                       if {[info exists ::name_db($p_key)]} {
                                 set p_clk_name $::name_db($p_key)
	} else {
                                 hardcopy_msgs::output_msg $outfile W_CLKS_P_NAME_NOT_FOUND $q_clk_name
                                 continue
                       }
                       puts $outfile "$p_asgn(cmd) $p_asgn(value) -clock \[get_clocks {$p_clk_name}] $p_asgn(to)"
               }
               #puts $outfile " "
	       convert_default_input_output_min_max_delay_asgn q_asgn p_asgn
	}
}

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_uncertainty_asgn { q_asgn_ref } {
	# Convert Uncertainty Quartus timing assignment.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $q_asgn_ref q_asgn

	global outfile

	# Initialize p_asgn array.
	hcii_tan_based_conversion::init_p_asgn p_asgn
	if {![hcii_tan_based_conversion::convert_asgn_src_dst q_asgn p_asgn 0 1]} {
		return
	}

	set src_size [llength $p_asgn(from)]
	if { $src_size ==0 } {
		puts $outfile "$p_asgn(cmd) $p_asgn(value) $p_asgn(to)"
	} else {
	        puts $outfile "$p_asgn(cmd) $p_asgn(value) -from $p_asgn(from) -to $p_asgn(to)"
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::convert_other_asgn { q_asgn_ref } {
	# Convert other Quartus timing assignment.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $q_asgn_ref q_asgn

	global outfile

	# Initialize p_asgn array.
	hcii_tan_based_conversion::init_p_asgn p_asgn
	if {![hcii_tan_based_conversion::convert_asgn_src_dst q_asgn p_asgn 0 1]} {
		return
	}

	set src_size [llength $p_asgn(from)]
	if {$p_asgn(hete_src) == 0 && $p_asgn(hete_dst) == 0} {
	if {$src_size == 0} {
		puts $outfile "$p_asgn(cmd) $p_asgn(value) -to $p_asgn(to)"
	} else {
		puts $outfile "$p_asgn(cmd) $p_asgn(value) -from $p_asgn(from) -to $p_asgn(to)"
	}
	} else {
    	        if {$p_asgn(hete_src) == 0 && $p_asgn(hete_dst) == 1} {
    	                set from_param {}
    	                if {[llength $p_asgn(from)] != 0} {
    	                        set from_param "-from $p_asgn(from)"
    	                }
    	                puts $outfile "foreach dst \[list $p_asgn(to) \] {"
    	                puts $outfile "        $p_asgn(cmd) $p_asgn(value) $from_param -to \[set \$dst\]"
    	                puts $outfile "}"

    	        } elseif {$p_asgn(hete_src) == 1 && $p_asgn(hete_dst) == 0} {
    	                set to_param {}
    	                if {[llength $p_asgn(to)] != 0} {
    	                        set to_param "-to $p_asgn(to)"
    	                }
    	                puts $outfile "foreach src \[list $p_asgn(from) \] {"
    	                puts $outfile "        $p_asgn(cmd) $p_asgn(value) -from \[set \$src\] $to_param"
    	                puts $outfile "}"

    	        } else {
       	                puts $outfile "foreach src \[list $p_asgn(from) \] {"
       	                puts $outfile "      foreach dst \[list $p_asgn(to) \] {"
    	                puts $outfile "            $p_asgn(cmd) $p_asgn(value) -from \[set \$src\] -to \[set \$dst\]"
    	                puts $outfile "      }"
     	                puts $outfile "}"
    	        }
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::read_asgn { infile q_asgn_ref } {
	# Read a Quartus asgn.
	# The content is stored in array q_asgn.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $q_asgn_ref q_asgn

	variable supported_q_asgn_types
	variable unsupported_q_asgn_types

	hcii_tan_based_conversion::init_q_asgn "q_asgn"

	set read_is_successful 0

	# Read each line until finish reading an assignment, indicated by the
	# keyword "END".
	while {[gets $infile line] > 0} {
		# Skip comments.
		if {[regexp {^( |\t)*#} $line]} {
			continue
		}

		set index ""

		# Read assignment type and index.
		if {[llength $line] == 1} {	;# No index
			set type $line
		} else {					;# With index
			set type [lindex $line 0]
			if {[regexp {\((.*)\)} [lindex $line 1] match tmp]} {
				set index $tmp
			}
		}

		# Need to filter off _group postfix of Quartus asgn type.
		set type [string tolower $type]
		set valid_end_idx [string first "_group" $type]
		if {$valid_end_idx != -1} {
			incr valid_end_idx -1
			set type [string range $type 0 $valid_end_idx]
		}

		# If read unrecognized Quartus asgn type, ignore it.
		if {[lsearch -glob $supported_q_asgn_types $type] == -1} {
			if {[lsearch -glob $unsupported_q_asgn_types $type] != -1} {
				if {$::options(verbose)} {
					msg_vdebug "Ignoring unrecognized Quartus assignment $line."
				}
			}
			continue
		}

		set q_asgn(index)	$index
		set q_asgn(type)	$type
		set q_asgn(cmd)		$type

		# Read assignment value, src, and dst.
		while {[gets $infile line] > 0} {
			# End of this assignment.
			if {$line == "END"} {
				set read_is_successful 1
				break
			}

			switch -exact [lindex $line 0] {
				"value:" {
					set q_asgn(value)	[lreplace $line 0 0]
				}
				"from:" {
					set q_asgn(from)	[lreplace $line 0 0]
				}
				"to:" {
					set q_asgn(to)		[lreplace $line 0 0]
				}
			}	
		}

		if {$read_is_successful} {
			break
		}
	}

	return $read_is_successful
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_tan_based_conversion::generate_scripts { } {
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

	# Output header.
	hcii_util::formatted_write $outfile "
		####################################################################################
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
		####################################################################################
	"

	# Process and/or check Global Settings
	hcii_tan_based_conversion::convert_global_settings

	# Initialize hcii_name_db databases, which contains all the infomation
	# helping to translate Quartus names to PrimeTime names.
	# It also does set_annotated_delay on PLL ports.
	hcii_name_db::initialize_db

	# Since hcii_tan_based_conversion functions may call
	# hcii_qsf_based_conversion functions, we need to load_report.
	load_report
	if ![is_report_loaded] {
		hardcopy_msgs::post E_NO_REPORT_DB
		qexit -error
	}

	# Convert Quartus Clocks.
	hcii_tan_based_conversion::convert_clocks

	# Make clock groups.
	hcii_tan_based_conversion::generate_clock_groups

	# Convert Quartus Clock Latency assignments.
	hcii_tan_based_conversion::convert_clock_latencies

	# Get output pin loading and input pin transition times.
	hcii_tan_based_conversion::generate_output_pin_loadings
	hcii_tan_based_conversion::generate_input_pin_transitions

	# Report unsupported assignments.
	hcii_tan_based_conversion::report_ignored_instance_assignments

	# Convert Quartus timing assignments.
	hcii_tan_based_conversion::convert_assignments

	close $outfile
	unload_report

	hcii_util::post_msgs "info" \
		"--------------------------------------------------------" \
		"Generated $output_file_name" \
		"--------------------------------------------------------"
}
