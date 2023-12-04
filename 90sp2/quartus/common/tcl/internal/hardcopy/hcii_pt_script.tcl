set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: hcii_pt_script.tcl
#
# Usage:
#		quartus_cdb --write_timing_constraint [options]
#		where [options] are described in hcii_const::available_options.
#			
# Description: 
#		Iterate though all Quartus timing assignments and create corresponding
#		Primetime timing constraints using the HardCopy II Design Center rules.
#
#		Two approaches, TAN based and QSF based conversions, are used to
#		achieve the translation. Both approaches start with building a
#		Quartus-to-PrimeTime (Q2P) name map.
#
#		TAN based conversion converts TAN dumped processed P2P timing
#		assignments to PrimeTime timing constraints directly by looking
#		through the Q2P name map.
#
#		QSF based conversion expands wildcards in user specified assignments
#		and then uses the Q2P name map to translate them into PrimeTime timing
#		constraints.
#
#		The script only knows how to convert a subset of all Quartus timing
#		assignments. The script, however, looks for all other unsupported
#		assignments and reports them as warnings.
#
# **************************************************************************

# Setup source directory and include source files.
set builtin_dir [file dirname [info script]]

set util_tcl_file [file join $builtin_dir hcii_utility.tcl]
source $util_tcl_file

set msg_tcl_file [file join $builtin_dir hardcopy_msgs.tcl]
source $msg_tcl_file

set visitor_tcl_file [file join $builtin_dir hcii_visitors.tcl]
source $visitor_tcl_file

set qsf_based_conversion_tcl_file [file join $builtin_dir hcii_qsf_based_conversion.tcl]
source $qsf_based_conversion_tcl_file

set tan_based_conversion_tcl_file [file join $builtin_dir hcii_tan_based_conversion.tcl]
source $tan_based_conversion_tcl_file

set sta_based_conversion_tcl_file [file join $builtin_dir hcii_sta_based_conversion.tcl]
source $sta_based_conversion_tcl_file

set l2p_translator_tcl_file [file join $builtin_dir hcii_l2p_translator.tcl]
source $l2p_translator_tcl_file

# --------------------------------------------------------------------------
#
#	Global variables
#
# --------------------------------------------------------------------------

# hc_output directory
set hc_output "hc_output"
# Revision name
set rev_name $::quartus(settings)
# Detect STA flow or non-STA flow
set is_sta_flow 0

# ==========================================================================
#
# ioc_reg_name_db is a Tcl array mapping Quartus registers that is moved to
# IO cell to the correspodning pin in the IO Cell.
# It is initialized through calling visitors.
#
array set ::ioc_reg_name_db {}
#
# ==========================================================================

# ==========================================================================
#
# pin_name_db is a Tcl array mapping Quartus registers (in complex blocks)
# to PrimeTime pins.  It is used to determine the bug of translation for
# registers in complex blocks.
# It is initialized through calling visitors.
#
array set ::pin_name_db {}
#
# ==========================================================================


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc initialize_ioc_to_pad_map { } {
	# Use the device database to store a global map with all the
	# IOC_X?_Y?_N? to PAD ID mapping.
	#
	# Generate global ioc2pad_db array where key = IOC name and value = pad id
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
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
				set ioc_name "X${x}_Y${y}_N${n}"
				set ::ioc2pad_db($ioc_name) $pad
				incr count
			}
		}
	}

	msg_vdebug "Processed $count pads from device database"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc auto_generate_clocks_based_on_tan_rpt { outfile } {
	# Open TAN Report database and use "Clock Settings Summary" panel to
	# auto-generate clocks but use "Timing Analysis Summary" to get Fmax.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# Get Report panel
	set panel_name "*Clock Settings Summary"
	set panel_id [get_report_panel_id $panel_name]

	if {$panel_id != -1} {
		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		for {set i 1} {$i < $row_cnt} {incr i} {
			set clock(clk_node_name) [get_report_panel_data -row $i -col_name "Clock Node Name" -id $panel_id]
			set clock(clk_setting_name) $clock(clk_node_name)
			# We don't know the duty cycle, assume 50 percent for now
			set clock(duty) 50
			# We don't know about inverted base, assume not inverted for now
			set clock(inv) "NONE"
			if ![catch {set actual_performance  [get_timing_analysis_summary_results -clock_setup $clk_node_name -actual]}] {
			
				# actual_performance should have syntax = "<fmax> MHz ( period = <period> ns )"
				# Need to parse out <period>
				set clock(period) [lindex $actual_performance 5]

				post_message -type info "Generating clock $clock(clk_node_name) (Period = $clock(period) ns)"
				hcii_qsf_based_conversion::create_base_clock $clock $outfile
			} else {				
				post_message -type info "Found Clock with no reg2reg path $clock(clk_node_name). Default to 10ns period"
				set clock(period) 10
				hcii_qsf_based_conversion::create_base_clock clock $outfile
			}
		}	
	} else {
		# Otherwise print an error message
		post_message -type info "No clocks were found in Timing Analysis Report"
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc auto_generate_io_constraints_based_on_tan_rpt { outfile } {
	# Open TAN report database and use "tpd" panel to auto-generate I/O
	# constraints. 
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# Get Report panel
	set panel_name "*tpd"
	set panel_id [get_report_panel_id $panel_name]
	set count 0

	post_message -type info "Processing Tpd: Converting to \"set_max_delay -from -to\""
	if {$panel_id != -1} {
		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		puts $outfile "# Tpd paths"
		for {set i 1} {$i < $row_cnt} {incr i} {
			# TAN may limit the rows to a given number. If so, the From/To columns 
			# may be empty and the get_report_panel_data will fail
			if ![catch {set src_name [get_report_panel_data -row $i -col_name "From" -id $panel_id]}] {
				set dst_name [get_report_panel_data -row $i -col_name "To" -id $panel_id]

				# Make sure we don't generate duplicates
				if ![info exists tpd(${src_name}-${dst_name})] {
					set tpd(${src_name}-${dst_name}) 1
					puts $outfile "set_max_delay -from [hcii_collection::get_p_name_or_collection $outfile IPIN $src_name 1] -to [hcii_collection::get_p_name_or_collection $outfile OPIN $dst_name 1] 10"
					incr count
				}
			} else {
				post_message -type warning "tpd: [get_report_panel_data -row $i -col 0 -id $panel_id]"
				post_message -type warning "     Not all tpd paths will be transformed into constraints"
				post_message -type warning "     Only $count unique max_delay constraints were generated"
			}
		}		
		puts $outfile ""
	} else {
		post_message -type info "No TPD paths found"
	}

	# Get Report panel
	set panel_name "*tsu"
	set panel_id [get_report_panel_id $panel_name]
	set count 0

	post_message -type info "Processing Tsu: Converting to \"set_input_delay -clock\""
	if {$panel_id != -1} {
		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		puts $outfile "# Tsu paths"
		for {set i 1} {$i < $row_cnt} {incr i} {
			# TAN may limit the rows to a given number. If so, the From/To columns 
			# may be empty and the get_report_panel_data will fail
			if ![catch {set clk_name [get_report_panel_data -row $i -col_name "To Clock" -id $panel_id]}] {
				set pin_name [get_report_panel_data -row $i -col_name "From" -id $panel_id]

				# Make sure we don't generate duplicates
				if ![info exists tsu(${clk_name}-${pin_name})] {
					set tsu(${clk_name}-${pin_name}) 1
					hcii_util::write_line $outfile \
						"set_input_delay -add_delay 2 -clock " \
						[hcii_collection::get_p_name_or_collection $outfile CLK $clk_name 1] \
						" " \
						[hcii_collection::get_p_name_or_collection $outfile IPIN $pin_name 1]
					incr count
				}
			} else {
				post_message -type warning "tsu: [get_report_panel_data -row $i -col 0 -id $panel_id]"
				post_message -type warning "     Not all tsu paths will be transformed into constraints"
				post_message -type warning "     Only $count unique input_delay constraints were generated"
			}
		}		
		puts $outfile ""
	} else {
		post_message -type info "No TSU paths found"
	}

	# Get Report panel
	set panel_name "*tco"
	set panel_id [get_report_panel_id $panel_name]
	set count 0

	post_message -type info "Processing Tco: Converting to \"set_output_delay -clock\""
	if {$panel_id != -1} {
		# Get the number of rows
		set row_cnt [get_number_of_rows -id $panel_id]

		puts $outfile "# Tco paths"
		for {set i 1} {$i < $row_cnt} {incr i} {
			# TAN may limit the rows to a given number. If so, the From/To columns 
			# may be empty and the get_report_panel_data will fail
			if ![catch {set clk_name [get_report_panel_data -row $i -col_name "From Clock" -id $panel_id]}] {
				set pin_name [get_report_panel_data -row $i -col_name "To" -id $panel_id]

				# Make sure we don't generate duplicates
				if ![info exists tsu(${clk_name}-${pin_name})] {
					set tsu(${clk_name}-${pin_name}) 1
					puts $outfile "set_output_delay -add_delay 2 -clock [hcii_collection::get_p_name_or_collection $outfile CLK $clk_name 1] [hcii_collection::get_p_name_or_collection $outfile OPIN $pin_name 1]"
					incr count
				}
			} else {
				post_message -type warning "tco: [get_report_panel_data -row $i -col 0 -id $panel_id]"
				post_message -type warning "     Not all tco paths will be transformed into constraints"
				post_message -type warning "     Only $count unique output_delay constraints were generated"
			}
		}		
		puts $outfile ""
	} else {
		post_message -type info "No TCO paths found"
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc auto_generated_pt_script { } {
	# Output a <rev_name>-hcii.tcl with dummy constraints to achive a fully
	# constrained design.
	# This function is FOR INTERNAL USE ONLY and to be OBSOLETE.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global quartus
	global pvcs_revision
	global outfile

	# Open file to output generated PrimeTime scripts.
	set output_file_name "$::hc_output/${::rev_name}.tcl"
	set outfile [open $output_file_name w]

	hcii_util::formatted_write $outfile "
		############################################################################
		#
		# Generated by [info script] $pvcs_revision(main)
		#   hcii_visitors.tcl : $pvcs_revision(visitors)
		#   Quartus           : $quartus(version)
		#
		# --------------------------------------------------------------------------
		# NOTE: This is an auto-generated script, not based on user constraints.
		#    Generated with
		#        \"quartus_cdb --write_timing_constraints <prj>\"
		#          (quartus.ini: hcii_pt_auto_generate=on)
		#
		#    THIS IS FOR INTERNAL USE ONLY
		#
		# --------------------------------------------------------------------------
		#
		# Project:  $quartus(project)
		# Revision: $quartus(settings)
		#
		# Date:     [clock format [clock seconds]]
		#
		############################################################################


	"

	# Initialize ::name_db with all keeper names and their HC equivalent name
	# This function is the only one that looks at the Atom Netlist and tries
	# to extract all keeper names
	hcii_name_db::initialize_db

	post_message -type warning "--------------------------------------------------------"
	post_message -type warning "NOTE: This is an auto-generated script"
	post_message -type warning "      and it is not based on user constraints"
	post_message -type warning "--------------------------------------------------------"
	post_message -type warning "      **** THIS IS FOR INTERNAL USE ONLY ***"
	post_message -type warning "--------------------------------------------------------"

	# Output HCDC required Primetime settings
	#hcii_tan_based_conversion::output_hcdc_required_settings $outfile

	# Load report
	load_report
	if ![is_report_loaded] {
        	hardcopy_msgs::post E_NO_REPORT_DB
	#	hcii_msg::post_msg "" E_NO_REPORT_DB
		qexit -error
	}

	# Process and/or check Global Settings
	post_message -type info "** Auto-generate Clocks"
	auto_generate_clocks_based_on_tan_rpt $outfile

	# Process I/O paths
	post_message -type info "** Auto-generate I/O Constraints"
	auto_generate_io_constraints_based_on_tan_rpt $outfile

	unload_report
	close $outfile

	post_message -type info "--------------------------------------------------"
	post_message -type info "Generated $output_file_name"
	post_message -type info "--------------------------------------------------"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc process_cmd_line_args { } {
	# Process command line arguments.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global quartus

	# Need to define argv for the cmdline package to work
	set argv0 "quartus_cdb --write_timing_constraint"
	set usage "\[<options>\]:"
	set argument_list $quartus(args)

	# Use cmdline package to parse options
	if [catch {array set ::options [cmdline::getoptions argument_list $hcii_const::available_options]} result] {
		if {[llength $argument_list] > 0 } {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Illegal Options"
			post_message -type error  [::cmdline::usage $hcii_const::available_options $usage]
			post_message -type error  "For more details, use \"quartus_cdb --help=write_timing_constraints\""
			qexit -error
		} else {
			post_message -type info  "Usage:"
			post_message -type info  [::cmdline::usage $hcii_const::available_options $usage]
			post_message -type info  "For more details, use \"quartus_cdb --help=write_timing_constraints\""
			qexit -success
		}
	}

	# cmdline::getoptions is going to modify the argument_list.
	# Note however that the function will ignore any positional arguments
	# We are expecting no positional arguments
	# so give an error if the list has more than one element
	if {[llength $argument_list] >= 1} {
		post_message -type error "Found unexpected positional argument: $argument_list"
		post_message -type info [::cmdline::usage $hcii_const::available_options $usage]
		post_message -type info "For more details, use \"quartus_cdb --help=hcii_pt_script\""
		qexit -error
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc process_inis { } {
	# Process Quartus INIs.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# Process "verbose" option.
	set ::options(verbose) 0
	set ini [get_ini_var -name hcii_pt_verbose]
	if { [string equal -nocase $ini ON] } {
		set ::options(verbose) 1
	}

	# Process "auto_generate" option.
	set ::options(auto_generate) 0
	set ini [get_ini_var -name hcii_pt_auto_generate]
	if { [string equal -nocase $ini ON] } {
		set ::options(auto_generate) 1
	}

	# Process "qsf_based_conversion" option.
	set ::options(qsf_based_conversion) 0
	set ini [get_ini_var -name q2p_use_qsf_based_conversion]
	if { [string equal -nocase $ini ON] } {
		set ::options(qsf_based_conversion) 1
	} else {
		# This is the legacy INI of qsf_based_conversion.
		set ini [get_ini_var -name pt_use_old_q2p_implementation]
		if { [string equal -nocase $ini ON] } {
			set ::options(qsf_based_conversion) 1
		}
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc main {} {
	# - Preprocess:
	#	-- Load packages
	#	-- Post important messages
	#	-- Process command-line arguments and Quartus INIs
	#	-- Check project is open and output directory exists
	#	-- Read atom netlist
	# - Do the assignments translation
	#	-- Use either TAN based conversion or QSF based conversion
	#   -- Check global settings
	#	-- Read clock settings and grouped timing assignments if uing TAN
	#	   based conversion
	#	-- Read assignment from HDB if using QSF based conversion
	#	-- Generate error, warning or info messages if encounter problems
	#	   during the script translation, or write out translated PrimeTime
	#	   scripts to the specified file
	# - Postprocess:
	#	-- Unload atom netlist
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global quartus

	# -------------------------------------
	# Load Required Quartus Packages
	# -------------------------------------
	load_package atoms
	load_package report
	load_package advanced_device
	package require cmdline

	# -------------------------------------
	# Print some useful header infomation
	# -------------------------------------
	post_message -type info "------------------------------------------------------------"
	post_message -type info "------------------------------------------------------------"
	post_message -type info "[file tail [info script]] version: $::pvcs_revision(main)"
	post_message -type info "hcii_visitors.tcl version: $::pvcs_revision(visitors)"
	post_message -type info "------------------------------------------------------------"
	post_message -type info "------------------------------------------------------------"

	# Load hcii_msg::msg_db database.
	#hcii_msg::load_db

	# Process command line arguments.
	process_cmd_line_args

	# Process Quartus INIs.
	process_inis

	# Make sure the project is open.
	if {![is_project_open]} {
	        hardcopy_msgs::post E_PROJECT_IS_NOT_OPEN                
		#hcii_msg::post_msg "" E_PROJECT_IS_NOT_OPEN
		post_message -type info [::cmdline::usage $hcii_const::available_options $usage]
		post_message -type info "For more details, use \"quartus_cdb --help=hcii_pt_script\""
		qexit -error
	}

	msg_vdebug  "Project = $quartus(project)"
	msg_vdebug  "Revision = $quartus(settings)"
	
        # Get the directory to use when outputing files
	if [catch {set ::hc_output [get_global_assignment -name HC_OUTPUT_DIR]}] {
		post_message -type warning "No HC_OUTPUT_DIR variable defined. Defaulting to $::hc_output"
	} else {
		post_message -type info "Using HC_OUTPUT_DIR = \"$::hc_output\""
	}

	if ![file exists $::hc_output] {
		post_message -type info "Creating $::hc_output directory"
		file mkdir $::hc_output
	}

	# Open Physical Netlist. Assume fitter and assembler have been run.
	if [catch {read_atom_netlist -type asm}] {
		post_message -type error "Run Assembler (quartus_asm) before running the current option"
		qexit -error
	}

	# Get the part from CDB_CHIP
	# This is needed to avoid getting an error if QSF DEVICE=AUTO
	set ::current_part [get_chip_info -key ENUM_PART]
	msg_vdebug "Got CDB_CHIP PART = $::current_part"

	# Do the assignment translation.
	if {$::options(auto_generate)} {
		# Call main function to auto generate "dummy" constraints
		# This assumes an unconstraint design
		auto_generated_pt_script
	} else {
		# Convert all Quartus timing assigments to PrimeTime scripts.
		# If the user is using TimeQuest then call hcii_sta_based_conversion::generate_scripts
		set asgn_value [get_global_assignment -name "USE_TIMEQUEST_TIMING_ANALYZER"]
		if {[string equal $asgn_value "ON"]} {
		        set ::is_sta_flow 1
		        hcii_sta_based_conversion::generate_scripts
		} else {
        		if {$::options(qsf_based_conversion)} {
        			hcii_qsf_based_conversion::generate_scripts
        		} else {
        			hcii_tan_based_conversion::generate_scripts
        		}
        	}
	}

	# Dump hcii_name_db database.
	if { $::options(dump_names) } {
		set output_file_name "${::rev_name}-1.names"
		hcii_name_db::dump_db $output_file_name
	}

	# Cleanup
	unload_atom_netlist
}


#########################
#						#
#	Call main function	#
#						#
#########################
main
