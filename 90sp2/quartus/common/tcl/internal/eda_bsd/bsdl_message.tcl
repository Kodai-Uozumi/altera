package provide bsdl_gen 1.0

# **************************************************************************
#
# File: bsdl_message.tcl
#
# Used by bsdl_main.tcl
#
# Description:
#		This file defines bsdl_msg namespace that contains all the error,
#		critical warning, warning and info messages.
#
# Note:	All the message definitions need to be moved to file *.msg.
#		Need to write a message parser to read in these messages.
#
# **************************************************************************


# **************************************************************************
#
#	Namespace bsdl_msg
#
# **************************************************************************

namespace eval bsdl_msg {
# --------------------------------------------------------------------------
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
proc bsdl_msg::get_msg_type_str { msg_name {is_for_output_file 1}} {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if {![info exists bsdl_msg::msg_db($msg_name)]} {
		bsdl_msg::post_msg "" E_UNDEF_MSG_NAME $msg_name
		qexit -error
	}

	set dash_pos	[string first "_" $msg_name]
	set type		[string range $msg_name 0 [expr $dash_pos - 1]]

	set index 0
	if {$is_for_output_file == 1} {
		set index 1
	}

	return [lindex $bsdl_msg::msg_str_types($type) $index]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc bsdl_msg::get_msg { msg_name {arguments ""} } {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable msg_db

	if {![info exists msg_db($msg_name)]} {
		bsdl_msg::post_msg "" E_UNDEF_MSG_NAME $msg_name
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
proc bsdl_msg::post_msg { msg_type_str msg_name {arg_list ""} } {
	# Post a message (referenced by msg_name with optional arguments).
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if {$msg_type_str == ""} {
		set msg_type_str [bsdl_msg::get_msg_type_str $msg_name 0]
	}
	set msg [bsdl_msg::get_msg $msg_name $arg_list]
	post_message -type $msg_type_str $msg
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc bsdl_msg::load_db { } {
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

	set msg_db(E_PROJECT_IS_NOT_OPEN)	{ 102 "No open project was found." }
	# CAUSE	 =	No project is open.
	# ACTION =	Run Tcl command: project_open <rev>.
	# STATUS =	C

	set msg_db(E_CANNOT_OPEN_OUTPUT_FILE)	{ 103 "Cannot write to file %s." }
	# CAUSE  =	Specified file cannot be written.
	# ACTION =	Make sure specified file can be written.
	# STATUS =	C

	set msg_db(E_CANNOT_OPEN_FILE)	{ 104 "Cannot open file %s." }
	# CAUSE  =	Specified file doesn't exist.
	# ACTION =	Make sure specified file exists.
	# STATUS =	C

	set msg_db(E_CANNOT_FIND_DIRECTORY)	{ 105 "Cannot find specified directory %s." }
	# CAUSE  =	Specified working directory doesn't exist.
	# ACTION =	Please makesure the specified directory exist.
	# STATUS =	C
	
	set msg_db(E_CANNOT_LOAD_DEVICE)	{ 106 "Cannot load device: %s." }
	# CAUSE  =	Unable to load specified device.
	# ACTION =	Please makesure the specified device is a valid device.
	# STATUS =	C
	
	set msg_db(E_NO_FULL_COMPILE)	{ 107 "Please run full compilation for device AUTO." }
	# CAUSE  =  Full compilation is not performed when specified device AUTO.
	# ACTION =	Please makesure the specified directory exist.
	# STATUS =	C
	
	set msg_db(E_NO_MAP_COMPILE)	{ 108 "Please run Synthesis and Analysis." }
	# CAUSE  =	Aynthesis and Analusis is not performed.
	# ACTION =	Please makesure the specified directory exist.
	# STATUS =	C
	
	set msg_db(E_AUTO_DEVICE_NOT_ALLOWED)	{ 109 "Device AUTO is not allowed for this command." }
	# CAUSE  =	Specified device AUTO.
	# ACTION =	Make sure specified device is not AUTO.
	# STATUS =	C
	
	set msg_db(E_CANNOT_FIND_DEVICE)	{ 110 "Device is not valid: %s." }
	# CAUSE  =	Specified an invalid device.
	# ACTION =	Make sure specified a valid device.
	# STATUS =	C
	
	set msg_db(E_DEVICE_NOT_SUPPORTED)	{ 111 "Specified device is not supported: %s(%s)." }
	# CAUSE  =	Specified device is not supported.
	# ACTION =	Specified a supported device.
	# STATUS =	C
	
	########################################
	#
	#		Warning Messages
	#
	########################################
	set msg_db(W_NO_PIN_OUT_FILE)	{ 201 "Pin out file is not avaialble. The BSDL post-configuration file is not generated." }
	# CAUSE  =	Pin out file has been disabled.
	# ACTION =	No action required.
	# STATUS = C
}