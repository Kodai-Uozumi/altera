set pvcs_revision(eda_pt_message) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: eda_pt_message.tcl
#
# Used by eda_pt_script.tcl
#
# Description:
#		This file defines eda_pt_msg namespace that contains all the error, 
#		critical warning, warning and info messages.
#
# Note:	All the message definitions need to be moved to file *.msg.
#		Need to write a message parser to read in these messages.
#
# **************************************************************************


# **************************************************************************
#
#	Namespace eda_pt_msg
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval eda_pt_msg {
#
# Description:	Define the namespace and interal variables.
#
# Note:			Commonly used APIs:
#				- Get a message in string format.
#					get_msg msg_name arg_list
#				- Post a message to the shell.
#					post_msg msg_name arg_list
#				- Post a debug message to the shell.
#					post_debug_msg msg_name arg_list
#				- Output a message to the specified ostream.
#					output_msg ostream msg_name arg_list
#				- Post a list of messages to the shell.
#					post_msg_list msg_list_ref
#				- Post a list of debug messages to the shell.
#					post_debug_msg_list msg_list_ref
#				- Output a list of messages to the specified ostream.
#					output_msg_list ostream msg_list_ref
#
# Warning:		All defined variables are not allowed to be accessed outside
#				this namespace!!! To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
	# It hold a mapping from msg_name to {msg_code msg_format} lists.
	array set msg_db {}
	
	# This array is for checking unique message IDs.
	# Message ID is a combination of message type and message code.
	array set msg_ids {}

	# Map a msg_type to a list of string types.
	#	The first string type is the post_message option string type, and
	#	the second string type is the message string type to the output Tcl
	array set msg_str_types { \
		E	{ "error"				"Error" } \
		CW	{ "critical_warning"	"Critical Warning" } \
		W	{ "warning"				"Warning" } \
		I	{ "info"				"Info" } \
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::get_msg_type_str { msg_name {is_for_output_file 1}} {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if {![info exists eda_pt_msg::msg_db($msg_name)]} {
		eda_pt_msg::post_msg "" E_UNDEF_MSG_NAME $msg_name
		qexit -error
	}

	set dash_pos	[string first "_" $msg_name]
	set type		[string range $msg_name 0 [expr $dash_pos - 1]]

	set index 0
	if {$is_for_output_file == 1} {
		set index 1
	}

	return [lindex $eda_pt_msg::msg_str_types($type) $index]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::get_msg_code { msg_name } {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if {![info exists eda_pt_msg::msg_db($msg_name)]} {
		eda_pt_msg::post_msg "" E_UNDEF_MSG_NAME $msg_name
		qexit -error
	}

	return [lindex $eda_pt_msg::msg_db($msg_name) 0]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::get_msg { msg_name {arguments ""} } {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable msg_db

	if {![info exists msg_db($msg_name)]} {
		eda_pt_msg::post_msg "" E_UNDEF_MSG_NAME $msg_name
		qexit -error
	}

	set msg_tmplt	[lindex $msg_db($msg_name) 1]
	set ret_msg		""
	set i			0
	set left		0
	while {1} {
		set right [string first "%s" $msg_tmplt $left]
		if {$right == -1} {
			append ret_msg [string range $msg_tmplt $left [string length $msg_tmplt]]
			break
		}
		append ret_msg [string range $msg_tmplt $left [expr $right - 1]] [lindex $arguments $i]
		set left [expr $right + 2]
		incr i
	}

	return $ret_msg
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::output_msg { ostream msg_name {arg_list ""} } {
	# Output a message (referenced by msg_name with optional arguments) to
	# the specified stream.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set msg [eda_pt_msg::get_msg $msg_name $arg_list]
	set msg_type_str [eda_pt_msg::get_msg_type_str $msg_name 1]
	set msg_code [eda_pt_msg::get_msg_code $msg_name]
	puts $ostream "# $msg_type_str (code = $msg_code): $msg"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::post_msg { msg_type_str msg_name {arg_list ""} } {
	# Post a message (referenced by msg_name with optional arguments).
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if {$msg_type_str == ""} {
		set msg_type_str [eda_pt_msg::get_msg_type_str $msg_name 0]
	}
	set msg [eda_pt_msg::get_msg $msg_name $arg_list]
	post_message -type $msg_type_str $msg
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::post_debug_msg { msg_name {arg_list ""} } {
	# Post a debug message (referenced by msg_name with optional arguments).
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	msg_vdebug [eda_pt_msg::get_msg $msg_name $arg_list]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::output_msg_list { ostream msg_list_ref } {
	# Output a list of messages to the specified stream.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $msg_list_ref msg_list
	foreach msg $msg_list {
		eda_pt_msg::output_msg $ostream [lindex $msg 0] [lindex $msg 1]
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::post_msg_list { msg_list_ref } {
	# Post a list of messages.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# TODO: unused
	upvar $msg_list_ref msg_list
	foreach msg $msg_list {
		eda_pt_msg::post_msg "" [lindex $msg 0] [lindex $msg 1]
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::post_debug_msg_list { msg_list_ref } {
	# Post a list of debug messages.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	# TODO: unused
	upvar $msg_list_ref msg_list
	foreach msg $msg_list {
		eda_pt_msg::post_debug_msg [lindex $msg 0] [lindex $msg 1]
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc eda_pt_msg::load_db { } {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable msg_db

	########################################
	#
	#		Error Messages
	#
	########################################
	set msg_db(E_UNDEF_MSG_NAME)	{ 101 "Message name %s is undefined." }
	# CAUSE  =	The message name does not exist in the msg_db.
	# ACTION =	Use an existing message name defined in the msg_db.
	# STATUS =	C

	set msg_db(E_PROJECT_IS_NOT_OPEN)	{ 103 "No open project was found." }
	# CAUSE	 =	No project is open.
	# ACTION =	Run Tcl command: project_open <rev>.
	# STATUS =	C

	set msg_db(E_NO_REPORT_DB)	{ 104 "Report database was not loaded." }
	# CAUSE  =	Report database is not loaded.
	# ACTION =	Run Tcl command load_report.
	# STATUS =	C

	set msg_db(E_ZERO_SIZE_COLLECTION)	{ 106 "The size of passed PrimeTime names is 0. Cannot create a collection on it." }
	# CAUSE  =	Passed PrimeTime names is an empty list. PrimeTime doesn't
	#			allow to create collections on empty lists.
	# ACTION =	Make sure the passed PrimeTime name list is not empty.
	# STATUS =	C

	set msg_db(E_CANNOT_OPEN_OUTPUT_FILE)	{ 108 "Cannot write to file %s." }
	# CAUSE  =	Specified file cannot be written.
	# ACTION =	Make sure specified file can be written.
	# STATUS =	C

	set msg_db(E_CANNOT_OPEN_FILE)	{ 108 "Cannot open file %s." }
	# CAUSE  =	Specified file doesn't exist.
	# ACTION =	Make sure specified file exists.
	# STATUS =	C

	set msg_db(E_WRONG_TIME_UNIT)	{ 109 "Unexpected time unit specified in %s." }
	# CAUSE  =	Wrong time unit.
	# ACTION =	Correct time units are: ps, ns, us, MHz.
	#			We don't support ms, s, GHz, Hz for now.
	# STATUS =	C

	set msg_db(E_UNSUPPORTED_COLLECTION_OPTION)	{ 110 "Found an unsupported collection option: %s." }
	# CAUSE  =	Specified collection option is not supported. Current supported collection optios are:
	#			n and h.
	# ACTION =	N/A
	# STATUS =	C

	set msg_db(E_CANNOT_FIND_DIRECTORY)	{ 113 "Cannot find specified directory %s." }
	# CAUSE  =	Specified working directory doesn't exist.
	# ACTION =	Please makesure the specified directory exist.
	# STATUS =	C

	set msg_db(E_CANNOT_FIND_TQ_FILES)	{ 114 "Cannot find TimeQuest generated files: %s. Please run \"quartus_sta <project> --tq2pt\" before running EDA Netlist Writer or select \"PrimeTime\" as the EDA timing analysis tool before running TimeQuest Timing Analyzer." }
	# CAUSE  =	Specified files doesn't exist.
	# ACTION =	Please run \"quartus_sta <project> --tq2pt\" before running EDA Netlist Writer or select \"PrimeTime\" as the EDA timing analysis tool before running TimeQuest Timing Analyzer.
	# STATUS =	C

	########################################
	#
	#		Critical Warning Messages
	#
	########################################
	set msg_db(CW_CANNOT_OPEN_COL_FILE)	{ 210 "The %s file does not exist. Collection conversion is not successful" }
	# CAUSE  =	Specified file doesn't exist.
	# ACTION =	Run TimeQuest to generate the missing files.
	# STATUS =	C

	set msg_db(CW_P_COL_IS_EMPTY)	{ 211 "Cannot generate collection %s as collection is empty." }
	# CAUSE  =	The converted PrimeTime constraint has an empty collection.
	# ACTION =	Refre to other warnings to fix this problem.
	# STATUS =	C

	########################################
	#
	#		Warning Messages
	#
	########################################
	set msg_db(W_REPORT_PANEL_NOT_FOUND)	{ 306 "'%s' panel cannot be found in %s." }
	# CAUSE  =	Specified panel cannot be found in specified report.
	# ACTION =	Make sure that specified panel can be found in specified report.
	# STATUS =	C

	set msg_db(W_NAME_ID_NOT_FOUND)	{ 307 "Cannot find corresponding PrimeTime name of specified name ID %s." }
	# CAUSE  =	Cannot find corresponding PrimeTime name of specified name ID.
	#			In general not all Quartus names can be mapped to PrimeTime names.
	#			Some buried register in complex box, eg. PLL, LVDS, RAM, may be lost
	#			during assembling process.
	# ACTION =	Cannot fix this. What can do is to ask user not to use this
	#			assignment.
	# STATUS =	C

	set msg_db(W_NAME_NOT_FOUND)	{ 308 "Cannot find corresponding PrimeTime name of specified node name %s." }
	# CAUSE  =	Cannot find corresponding PrimeTime name of specified node name.
	#			In general not all Quartus names can be mapped to PrimeTime names.
	#			Some buried register in complex box, eg. PLL, LVDS, RAM, may be lost
	#			during assembling process.
	# ACTION =	Cannot fix this. What can do is to ask user not to use this
	#			assignment.
	# STATUS =	C

	set msg_db(W_NAME_NOT_FOUND_MSG)   { 309 "The generated PrimeTime script have %s missing name(s)." }
	# CAUSE  =	Cannot convert one or more specified ID to PrimeTime names. 
	#			In general not all Quartus names can be mapped to PrimeTime names.
	#			Some buried register in complex box, eg. PLL, LVDS, RAM, may be lost
	#			during assembling process.
	# ACTION =	Cannot fix this. What can do is to ask user not to use this
	#			assignment.
	# STATUS =	C

	########################################
	#
	#		Info Messages
	#
	########################################
	set msg_db(I_NO_CLK_IN_INPUT_DELAY)	{ 411 "The Quartus assignment destination may consist of clock(s). Input delay is not allowed to set on clock port(s) {%s}" }
	# CAUSE  =	This is caused by the fact that INPUT_MAXIMUM/MINIMUM_DELAY assignment is set on clock node or wildcard/pure wildcard which may consist of clock nodes.
	# ACTION =	The clock nodes will not translate into PrimeTime collection and constraint. 
	# STATUS =	C
}