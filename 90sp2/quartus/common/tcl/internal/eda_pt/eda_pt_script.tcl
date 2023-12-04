set pvcs_revision(eda_pt_script) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: eda_pt_script.tcl
#
# Usage:
#		eda_pt_script.tcl [options]
#		where [options] are described in available_options.
#
# Description:
#		Create corresponding PrimeTime timing constraints using TimeQuest
#		exported SDC constraints and collection objects.
#
# **************************************************************************

# -------------------------------------------------
# Available User Options for:
#	eda_pt_script.tcl [<options>]
# -------------------------------------------------
set available_options {
	{ output_directory.arg "#_ignore_#" "Option to specify the output directory" }
	{ hdl_type.arg "#_ignore_#" "Option to specify the HDL type" }
}

# Setup source directory and include source files.
set builtin_dir [file dirname [info script]]

set util_tcl_file [file join $builtin_dir eda_pt_utility.tcl]
source $util_tcl_file

set msg_tcl_file [file join $builtin_dir eda_pt_message.tcl]
source $msg_tcl_file

set eda_pt_conversion_tcl_file [file join $builtin_dir eda_pt_conversion.tcl]
source $eda_pt_conversion_tcl_file

set eda_pt_generate_tcl_file [file join $builtin_dir eda_pt_generate.tcl]
source $eda_pt_generate_tcl_file

# --------------------------------------------------------------------------
#
#	Global variables
#
# --------------------------------------------------------------------------

# Revision name
set rev_name $::quartus(settings)
# Options default values
array set options [ list								\
	output_directory	[file join timing primetime]	\
	hdl_type			"verilog"						\
]

# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc process_cmd_line_args { } {
	# Process command line arguments.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global quartus

	# Need to define argv for the cmdline package to work
	set argv0 "eda_pt_script.tcl"
	set usage "\[<options>\]:"
	set argument_list $quartus(args)

	# Use cmdline package to parse options
	if [catch { array set ::options [cmdline::getoptions argument_list $::available_options] } result] {
		if {[llength $argument_list] > 0 } {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Illegal Options"
			post_message -type error [::cmdline::usage $::available_options $usage]
			post_message -type error "For more details, use \"quartus_eda --help=timing_analysis\""
			qexit -error
		} else {
			post_message -type info "Usage:"
			post_message -type info [::cmdline::usage $::available_options $usage]
			post_message -type info "For more details, use \"quartus_eda --help=timing_analysis\""
			qexit -success
		}
	}

	# cmdline::getoptions is going to modify the argument_list.
	# Note however that the function will ignore any positional arguments
	# We are expecting no positional arguments
	# so give an error if the list has more than one element
	if {[llength $argument_list] >= 1} {
		post_message -type error "Found unexpected positional argument: $argument_list"
		post_message -type info [::cmdline::usage $::available_options $usage]
		post_message -type info "For more details, use \"quartus_eda --help=timing_analysis\""
		qexit -error
	}

	if { ${::options(output_directory)} == "" } {
		set ::options(output_directory) [file join timing primetime]
	}

	if { ![file exists ${::options(output_directory)}] } {
		post_message -type info "Creating ${::options(output_directory)} directory"
		file mkdir ${::options(output_directory)}
	}

	if { ${::options(hdl_type)} != "verilog" && ${::options(hdl_type)} != "vhdl" } {
		post_message -type error "You need to select PrimeTime in the EDA Tools Settings"
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
	set ini [get_ini_var -name eda_pt_verbose]
	if { [string equal -nocase $ini ON] } {
		set ::options(verbose) 1
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc verify_input_files { input_tq_collection input_tq_constraint } {
	# Check TimeQuest dumped files (those are input files):
	# 1. <revision>.sta_col
	# 2. <revision>.constraints.sdc
	# and copy to output directory.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# Check TimeQuest dumped files
	if { ![file exists $input_tq_collection] || ![file exists $input_tq_constraint] } {
		set tq_dumped_files "[file tail $input_tq_collection] and [file tail $input_tq_constraint]"
		eda_pt_msg::post_msg "" E_CANNOT_FIND_TQ_FILES [list $tq_dumped_files]		;# avoid using white space as list delimiter
		qexit -error
	} else {
		# Copy TimeQuest dumped files to output directory, -force to overwrite
		if [catch { file copy -force $input_tq_constraint ${::options(output_directory)} } result] {
			msg_vdebug $result
			post_message -type error "Failed to copy TimeQuest output files to ${::options(output_directory)}."
			qexit -error
		}

		if { [string compare -nocase [get_ini_var -name eda_pt_regtest_mode] on] == 0 } {
			if [catch { file copy -force $input_tq_collection ${::options(output_directory)} } result] {
				msg_vdebug $result
			}
		}
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc remove_input_files { input_tq_collection input_tq_constraint } {
	# Generate TimeQuest dumped files (those are input files):
	# 1. <revision>.sta_col
	# 2. <revision>.constraints.sdc
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

	if [catch { file delete $input_tq_collection $input_tq_constraint } result] {
		msg_vdebug $result
		msg_vdebug "Failed to delete TimeQuest output files: $input_tq_collection, $input_tq_constraint"
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
	# - Do the assignments translation
	#	-- Check global settings
	#	-- Verify TimeQuest dumped files
	#	-- Perform node name conversion
	#	-- Generate PrimeTime Tcl script for fast/slow timing model
	#	   annotated netlist
	#	-- Generate error, warning or info messages if encounter problems
	#	   during the script translation, or write out translated PrimeTime
	#	   scripts to the specified file
	# - Postprocess:
	#	-- NA
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	global quartus

	# -------------------------------------
	# Load Required Quartus Packages
	# -------------------------------------
	load_package atoms
	load_package device
	load_package eda_pt
	load_package flow
	load_package report
	package require cmdline

	# -------------------------------------
	# Print some useful header infomation
	# -------------------------------------
	post_message -type info "------------------------------------------------------------"
	post_message -type info "[file tail [info script]] version: $::pvcs_revision(eda_pt_script)"
	post_message -type info "eda_pt_generate.tcl version: $::pvcs_revision(eda_pt_generate)"
	post_message -type info "eda_pt_conversion.tcl version: $::pvcs_revision(eda_pt_conversion)"
	post_message -type info "------------------------------------------------------------"

	# Load eda_pt_msg::msg_db database.
	eda_pt_msg::load_db

	# Process command line arguments.
	process_cmd_line_args

	# Process Quartus INIs.
	process_inis

	msg_vdebug "Project = $quartus(project)"
	msg_vdebug "Revision = $quartus(settings)"
	msg_vdebug "Output Directory = ${::options(output_directory)}"
	msg_vdebug "HDL Type = ${::options(hdl_type)}"

	# Open project if necessary
	if { [string compare $quartus(project) ""] != 0 } {
		if {[info exist quartus(project)] && [project_exists $quartus(project)]} {
			project_open -revision $quartus(settings) $quartus(project)
		}
	}

	# Make sure the project is open.
	if {![is_project_open]} {
		eda_pt_msg::post_msg "" E_PROJECT_IS_NOT_OPEN
		qexit -error
	}

	# Initialize ::quartus::eda_pt
	if [catch { initialize_pt } result] {
		post_message -type error $result
		msg_vdebug "Fatal error: Initialize process failed."
		qexit -error
	}

	read_atom_netlist

	# Define the input and output filenames here
	set input_tq_collection "[get_project_directory]db/${::rev_name}.sta_col"
	set input_tq_constraint "[get_project_directory]db/${::rev_name}.constraints.sdc"
	set output_tq_constraint "${::options(output_directory)}${::rev_name}.constraints.sdc"
	set output_pt_collection "${::options(output_directory)}${::rev_name}.collections.sdc"
	set output_pt_script "${::options(output_directory)}${::rev_name}.pt.tcl"
	#set output_pt_script "${::options(output_directory)}${::rev_name}_pt"	; # SPR 214571

	# Generate TimeQuest dumped input files
	verify_input_files $input_tq_collection $input_tq_constraint

	# Perform node name conversion
	eda_pt_conversion::generate_col_script $input_tq_collection $output_pt_collection

	# Generate PrimeTime Tcl script for fast/slow timing model annotated netlist
	eda_pt_generate::generate_script $input_tq_constraint $output_pt_collection $output_pt_script ${::options(hdl_type)} 0
	#eda_pt_generate::generate_script $input_tq_constraint $output_pt_collection $output_pt_script ${::options(hdl_type)} 1	; # SPR 214571

	# Uninitialize ::quartus::eda_pt
	if [catch { uninitialize_pt } result] {
		post_message -type error "Fatal error: Uninitialize process failed."
		qexit -error
	}

	# Remove TimeQuest dumped input files
	remove_input_files $input_tq_collection $input_tq_constraint
}


#########################
#						#
#	Call main function	#
#						#
#########################
main
