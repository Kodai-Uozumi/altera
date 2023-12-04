set pvcs_revision(message) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: hcii_message.tcl
#
# Used by hcii_pt_script.tcl
#
# Description:
#		This file defines hcii_msg namespace that contains all the error,
#		critical warning, warning and info messages.
#
# Note:	All the message definitions need to be moved to file *.msg.
#		Need to write a message parser to read in these messages.
#
# **************************************************************************


# **************************************************************************
#
#	Namespace hcii_msg
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval hcii_msg {
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
#				this namespace!!!  To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
	# It hold a mapping from msg_name to {msg_code msg_format} lists.
	array set msg_db {}
	
	# This array is for checking unique message IDs.
	# Message ID is a combination of message type and message code.
	array set msg_ids {}

	# Map a msg_type to a list of string types.
	#	The first string type is the post_message option string type, and
	#	the second string type is the message string type to the output file
	#	(refers to hcii_output\<rev>.tcl file).
	array set msg_str_types { \
		E	{ "error"				"Error" } \
		CW	{ "critical_warning"	"Critical Warning" } \
		W	{ "warning"				"Warning" } \
		I	{ "info"				"Info" } \
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_msg::get_msg_type_str { msg_name {is_for_output_file 1}} {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if {![info exists hcii_msg::msg_db($msg_name)]} {
		hcii_msg::post_msg "" E_UNDEF_MSG_NAME $msg_name
		qexit -error
	}

	set dash_pos	[string first "_" $msg_name]
	set type		[string range $msg_name 0 [expr $dash_pos - 1]]

	set index 0
	if {$is_for_output_file == 1} {
		set index 1
	}

	return [lindex $hcii_msg::msg_str_types($type) $index]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_msg::get_msg_code { msg_name } {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if {![info exists hcii_msg::msg_db($msg_name)]} {
		hcii_msg::post_msg "" E_UNDEF_MSG_NAME $msg_name
		qexit -error
	}

	return [lindex $hcii_msg::msg_db($msg_name) 0]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_msg::get_msg { msg_name {arguments ""} } {
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	variable msg_db

	if {![info exists msg_db($msg_name)]} {
		hcii_msg::post_msg "" E_UNDEF_MSG_NAME $msg_name
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
proc hcii_msg::output_msg { ostream msg_name {arg_list ""} } {
	# Output a message (referenced by msg_name with optional arguments) to
	# the specified stream.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	set msg [hcii_msg::get_msg $msg_name $arg_list]
	set msg_type_str [hcii_msg::get_msg_type_str $msg_name 1]
	set msg_code [hcii_msg::get_msg_code $msg_name]
	puts $ostream "# $msg_type_str (code = $msg_code): $msg"
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_msg::post_msg { msg_type_str msg_name {arg_list ""} } {
	# Post a message (referenced by msg_name with optional arguments).
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	if {$msg_type_str == ""} {
		set msg_type_str [hcii_msg::get_msg_type_str $msg_name 0]
	}
	set msg [hcii_msg::get_msg $msg_name $arg_list]
	post_message -type $msg_type_str $msg
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_msg::post_debug_msg { msg_name {arg_list ""} } {
	# Post a debug message (referenced by msg_name with optional arguments).
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	msg_vdebug [hcii_msg::get_msg $msg_name $arg_list]
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_msg::output_msg_list { ostream msg_list_ref } {
	# Output a list of messages to the specified stream.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $msg_list_ref msg_list
	foreach msg $msg_list {
		hcii_msg::output_msg $ostream [lindex $msg 0] [lindex $msg 1]
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_msg::post_msg_list { msg_list_ref } {
	# Post a list of messages.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $msg_list_ref msg_list
	foreach msg $msg_list {
		hcii_msg::post_msg "" [lindex $msg 0] [lindex $msg 1]
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_msg::post_debug_msg_list { msg_list_ref } {
	# Post a list of debug messages.
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
	upvar $msg_list_ref msg_list
	foreach msg $msg_list {
		hcii_msg::post_debug_msg [lindex $msg 0] [lindex $msg 1]
	}
}


# --------------------------------------------------------------------------
# --------------------------------------------------------------------------
proc hcii_msg::load_db { } {
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

	set msg_db(E_PAD_HAS_NO_MCF_NAME)	{ 102 "Pad has no MCF name." }
	# CAUSE  =	
	# ACTION =	
	# STATUS =	C

	set msg_db(E_PROJECT_IS_NOT_OPEN)	{ 103 "No open project was found." }
	# CAUSE	 =	No project is open.
	# ACTION =	Run Tcl command: project_open <rev>.
	# STATUS =	C

	set msg_db(E_NO_REPORT_DB)	{ 104 "Report database was not loaded." }
	# CAUSE  =	Report database is not loaded.
	# ACTION =	Run Tcl command load_report.
	# STATUS =	C
	
	set msg_db(E_UNKNOWN_ATOM_TYPE)	{ 105 "Unknown atom type %s." }
	# CAUSE  =	Unknown atom type. Seems like ASM is introducing new atom types.
	# ACTION =	Write proper visitor function for this new atom type.
	#			Add a handle to hcii_name_db::intialize_db function.
	# STATUS =	C

	set msg_db(E_ZERO_SIZE_COLLECTION)	{ 106 "The size of passed PrimeTime names is 0. Cannot create a collection on it." }
	# CAUSE  =	Passed PrimeTime names is an empty list. PrimeTime doesn't
	#			allow to create collections on empty lists.
	# ACTION =	Make sure the passed PrimeTime name list is not empty.
	# STATUS =	C

	set msg_db(E_ILLEGAL_NODE_TYPE)	{ 107 "%s is not a legal node type." }
	# CAUSE  =	Specified node type is illegal. Current legal node types are:
	#			CLK, IPIN, OPIN, and KPR.
	# ACTION =	Specify a legal node type.
	#			To be obsolete. Refer to q2p_name_db database for the new
	#			Quartus node types.
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
	#
	# STATUS =	C

	set msg_db(E_WRONG_STRING_OBJECT_TYPE)	{ 111 "Object: %s, is a string" }
	# CAUSE  =	Wrong string object.
	# ACTION =	N/A
        #
	# STATUS =	C

	set msg_db(E_WRONG_STRING_LIST_OBJECT_TYPE)	{ 112 "Object is a string list." }
	# CAUSE  =	Wrong string list object.
	# ACTION =	N/A
        #
	# STATUS =	C

	set msg_db(E_CANNOT_FIND_DIRECTORY)	{ 113 "Cannot find specified directory %s." }
	# CAUSE  =	Specified working directory doesn't exist.
	# ACTION =	Makesure the specified deirectory is exist.
        #
	# STATUS =	C

	set msg_db(E_RUN_TIMEQUEST)	{ 114 "Run TimeQuest before running the current option." }
	# CAUSE  =	Specified file doesn't exist.
	# ACTION =	Make sure TimeQuest is run to generate the specific file.
	# STATUS =	C



	########################################
	#
	#		Critical Warning Messages
	#
	########################################
	set msg_db(CW_NO_CLOCKS_DEFINED)	{ 201 "No clocks defined." }
	# CAUSE  =	There is no clocks defined in the design.
	# ACTION =	Add proper clock settings to the design.
	# STATUS =	C

	set msg_db(CW_Q_ASGN_DST_IS_EMPTY)	{ 202 "The Quartus assignment destination is empty." }
	# CAUSE  =	The specified Quartus assignment has an empty destination.
	# ACTION =	Make sure the Quartus assignment destination set is not empty and all elements in it are legal.
	# STATUS =	C

	set msg_db(CW_P_ASGN_DST_IS_EMPTY)	{ 203 "The converted PrimeTime constraint destination is empty." }
	# CAUSE  =	The converted PrimeTime constraint has an empty destination.
	# ACTION =	Make sure all the elements in the Quartus assignment
	#			destination set can be translated to PrimeTime names.
	# STATUS =	C

	set msg_db(CW_P_ASGN_SRC_IS_EMPTY)	{ 204 "The converted PrimeTime constraint source is empty." }
	# CAUSE  =	The converted PrimeTime constraint has an empty source.
	# ACTION =	Make sure all the elements in the Quartus assignment source
	#			set can be translated to PrimeTime names.
	# STATUS =	C

	set msg_db(CW_LIMITED_SUPPORT_OF_CUT) { 205 "Converting Quartus single-point cut on non-keeper node to PrimeTime set_false_path is not supported." }
	# CAUSE  =	Converting Quartus single-point cut on a non-keeper node to
	#			PrimeTime set_false_path is not supported.
	# ACTION =	Find out the corresponding PrimeTime name of this non-keeper
	#			node and manually replace this cut assignment by
	#			set_false_path -through.
	#			The new q2p_name_db database will resolve this issue.
	# STATUS =	C

	set msg_db(CW_CANNOT_CONVERT_ASGN)	{ 206 "Cannot convert the Quartus assignment." }
	# CAUSE  =	Cannot convert specified Quartus assignment to an equivalent PrimeTime constraint.
	# ACTION =	Refer to other warnings to fix this problem.
	# STATUS =	C

	set msg_db(CW_CANNOT_CONVERT_CLK) { 207 "Cannot convert the Quartus clock." }
	# CAUSE  =	Cannot convert specified Quartus clock to an equivalent PrimeTime clock.
	# ACTION =	Refer to other warnings to fix this problem.
	# STATUS =	C

	set msg_db(CW_CANNOT_OPEN_CLK_FILE)	{ 208 "The %s file does not exist. No clock conversion will be implemented" }
	# CAUSE  =	Specified file doesn't exist.
	# ACTION =	Make sure specified file exists else there will be no clock conversion.
	# STATUS =	C

	set msg_db(CW_CANNOT_OPEN_TA_FILE)	{ 209 "The %s file does not exist. No TAN Assignments conversion will be implemented" }
	# CAUSE  =	Specified file doesn't exist.
	# ACTION =	Make sure specified file exists else there will be no TAN Assignments conversion.
	# STATUS =	C

	set msg_db(CW_CANNOT_OPEN_COL_FILE)	{ 210 "The %s file does not exist. No collection conversion will be implemented" }
	# CAUSE  =	Specified file doesn't exist.
	# ACTION =	Make sure specified file exists else there will be no collection conversion.
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
	set msg_db(W_Q_NAME_NOT_FOUND)	{ 301 "Cannot find corresponding Quartus name of specified name ID %s."}
	# CAUSE  =	Cannot find corresponding Quartus name of specified name ID.
	# ACTION =	Check the specified name ID is legal.
	#			Quartus assigned every unique node name internally with a
	#			unique integer, HDB_ID, which is used as name ID.
	#			Useing name ID instead of node name saves memory.
	# STATUS =	C

	set msg_db(W_P_NAME_NOT_FOUND)	{ 302 "Cannot find corresponding PrimeTime name of Quartus name %s (%s)." }
	# CAUSE  =	Cannot find corresponding PrimeTime name of specified Quartus name.
	#			In general not all Quartus names can be mapped to PrimeTime names.
	#			Some buried register in complex box, eg. PLL, LVDS, RAM, may be lost
	#			during assembling process.
	# ACTION =	Cannot fix this. What can do is to ask user not to use this
	#			assignment.
	# STATUS =	C

	set msg_db(W_EMBEDDED_REG_SHOULD_MAP_TO_PIN)	{ 303 "Quartus register %s should be mapped to PrimeTime pin %s." }
	# CAUSE  =	The assignment on a register-in-block should be translated to
	#			constraint on the corresponding pin of the host block.
	#			However, it is currently mapped to the host block.
	#			This may make all the input or output pins of the host block
	#			have the timing constraint.
	# ACTION =	Manually analyse the physical netlist and use the proper pin
	#			instead if possible.
	#			The new q2p_name_db will solve this problem.
	# STATUS =	C

	set msg_db(W_UNSUPPORTED_GLOBAL_ASGN)	{ 304 "Ignoring unsupported global %s = %s" }
	# CAUSE  =	Quartus global assignments listed in list
	#			hcii_const::unsupported_global_assignments are not
	#			translatable to PrimeTime constraints.
	# ACTION =	N/A
	# STATUS =	C

        set msg_db(W_WRONG_ASGN_EXPECTED_VALUE)	{ 305 "Expected %s to be set to %s but is set to %s."}
	# CAUSE  =	The assignment value is set to a wrong value.
	# ACTION =	Correct the assignment value.
	# STATUS =	C
	
	set msg_db(W_REPORT_PANEL_NOT_FOUND)	{ 306 "'%s' panel cannot be found in %s." }
	# CAUSE  =	Specified panel cannot be found in specified report.
	# ACTION =	Make sure that specified panel can be found in specified report.
	# STATUS =	C

	set msg_db(W_CLKS_Q_NAME_NO_FOUND)	{ 307 "Cannot find corresponding Quartus name of specified %s ID %s."}
	# CAUSE  =	Cannot find corresponding Quartus name of specified clock ID.
	# ACTION =	Refer to W_Q_NAME_NOT_FOUND section.
	# STATUS =	C

	set msg_db(W_CLK_ID_NAME_MISMATCH)	{ 308 "The name of %s ID %s should be %s, not %s." }
	# CAUSE  =	Specified Quartus clock name doesn't match the node name
	#			translated from specified clock ID.
	# ACTION =	Make sure the name and ID match each other.
	#			Rerun quartus_tan normally can resolve this problem.
	# STATUS =	C

	set msg_db(W_CLKS_P_NAME_NOT_FOUND)	{ 309 "Cannot find corresponding PrimeTime name of Quartus clock %s." }
	# CAUSE  =	Cannot find corresponding PrimeTime name of specified Quartus clock.
	# ACTION =	Refer to W_P_NAME_NOT_FOUND section.
	# STATUS =	C

	set msg_db(W_EMPTY_CLK_GROUP)	{ 310 "Cannot find any corresponding PrimeTime clock for the clock group of Quartus base clock setting %s." }
	# CAUSE  =	Specified clock group (by a Quartus base clock setting) is empty.
	# ACTION =	N/A.
	#			This should never happen.
	# STATUS =	C

	set msg_db(W_P_NAME_OR_COLL_NOT_FOUND) { 311 "%s does not map to any node in the physical netlist." }
	# CAUSE  =	Cannot find corresponding PrimeTime names of specified Quartus name.
	#			In general not all Quartus names can be mapped to PrimeTime names.
	#			Some buried register in block, eg. PLL, LVDS, RAM, may be lost
	#			during assembly process.
	# ACTION =	Refer to W_P_NAME_NOT_FOUND section.
	# STATUS =	C

	set msg_db(W_VALUE_IS_NOT_A_NUMBER) { 312 "Specified %s, %s, is not not a number." }
	# CAUSE  =	Specified value is not a number.
	# ACTION =	Make sure value is a number.
	# STATUS =	C
	
	set msg_db(W_VALUE_SMALLER_THAN_0) { 313 "Specified %s, %s, is not greater than 0." }
	# CAUSE  =	Specified value is not greater than 0.
	# ACTION =	Make sure value is greater than 0.
	# STATUS =	C

	set msg_db(W_BASE_CLK_ID_NAME_CNT_NOT_EQUAL)	{ 314 "The number of base clock names is not equal to that of base clock IDs." }
	# CAUSE  =	The number of specified base clock names is not equal to
	#			that of base clock IDs.
	# ACTION =	Make sure the number of specified base clock names is equal
	#			to that of base clock IDs.
	# STATUS =	C
	
	set msg_db(W_MULTI_BASE_CLK)	{ 315 "Multiple base clocks are specified. Ignore all but the first base clocks." }
	# CAUSE  =	Specified clock has multiple base clocks.
	# ACTION =	Specify only 1 base clock.
	#			The current version of Q2P translator doesn't support multiple
	#			base clocks and ignores all but the first base clock.
	# STATUS =	C

	set msg_db(W_SHOULD_BE_NO_BASE_CLK)	{ 316 "Specified clock should have no base clock, but base clock name %s appears." }
	# CAUSE  =	Specified clock should not have any base clock.
	#			Because its base clock ID (base_clk) = -1.
	# ACTION =	Make sure there is no base clock names specified.
	# STATUS =	C
	
	set msg_db(W_INVALID_BASE_CLOCK)	{ 317 "Specified base clock, $s, is not a valid clock." }
	# CAUSE  =	Specified base clock is an invalid clock.
	# ACTION =	Make sure specified base clock is a valid clock.
	# STATUS =	C
	
	set msg_db(W_CANNOT_FIND_BASE_CLK)	{ 318 "Cannot find a base clock for specified derived clock." }
	# CAUSE  =	Cannot find the base clock of the specified derivied clock.
	# ACTION =	Make sure a derived clock must have a base clock.
	# STATUS =	C
	
	set msg_db(W_UNK_OBSERVABLE_PORT_TYPE)	{ 319 "Found unsupported %s port type: %s." }
	# CAUSE  =	Found unsupported observerable port type.
	# ACTION =	N/A.
	#			This should never happen.
	# STATUS =	C

	set msg_db(W_MULTI_MC_ASGN)	{ 320 "Both Multicycle and Source Multicycle are set" }
	# CAUSE  =	Quartus TAN and PrimeTime result might not be match.
	# ACTION =	Make sure either Multicycle or Source Multicycle is specified but not both.	
	# STATUS =	C

	set msg_db(W_MULTI_HOLD_MC_ASGN)  { 321 "Both Hold Multicycle and Source Hold Multicycle are set" }
	# CAUSE  =	Quartus TAN and PrimeTime result might not be match.
	# ACTION =	Make sure either Hold Multicycle or Source Hold Multicycle is specified but not both.	
	# STATUS =	C

	set msg_db(W_NO_CLOCK_CONSTRAINT)  { 322 "Clock %s is not constraint." }
	# CAUSE  =	Clock is not constraint.
	# ACTION =	Make sure clock is constraint or defined.	
	# STATUS =	C

        set msg_db(W_PROJECT_SHOW_ENTITY_NAME_OFF)  { 323 "Expected PROJECT_SHOW_ENTITY_NAME to be set to 'ON', but it is set to 'OFF'. Entity specific assignments will not be successfully translated" }
	# CAUSE  =	Entity specific assignment will not be translated.
	# ACTION =	Make sure that PROJECT_SHOW_ENTITY_NAME is set to ON.
	# STATUS =	C

	set msg_db(W_EMPTY_OBJECT)	{ 324 "Found an empty object." }
	# CAUSE  =	The object is empty.
	# ACTION =	N/A.
	#			This should never happen.
	# STATUS =	C

	########################################
	#
	#		Info Messages
	#
	########################################
	set msg_db(I_NO_CLK_IN_TAN_RPT)	{ 401 "No clocks were found in Timing Analysis report." }
	# CAUSE  =	No clocks were found in Timing Analysis report.
	# ACTION =	Make clock assignment for the design.
	# STATUS =	C
	
	set msg_db(I_CONVERT_Q_ASGN)	{ 402 "Converting Quartus assignment %s (%s)" }
	# CAUSE  =	Converting a Quartus assignment.
	# ACTION =	N/A.
	# STATUS =	C

	set msg_db(I_FAIL_TO_CONVERT_Q_ASGN)	{ 403 "Failed to convert Quartus assignment %s (%s)." }
	# CAUSE  =	Failed to convert a Quartus assignment.
	# ACTION =	Refer to other warnings to fix this problem.
	# STATUS =	C

	set msg_db(I_IOC_REG)	{ 404 "Quartus register %s is moved to I/O cell %s." }
	# CAUSE  =	Quartus register is moved to I/O cell by FITTER.
	# ACTION =	Nothing to do.
	# STATUS =	C

	set msg_db(I_ALL_CLOCKS_RELATED)	{ 405 "All clocks are related. No false path constraints are generated between clock domains." }
	# CAUSE  =	All clocks are related.
	# ACTION =	Nothing to do.
	# STATUS =	C
        
        set msg_db(I_CUT_PATH_BETWEEN_CLK_DOMAIN_OFF) { 406 "Quartus assignment: CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS is set to OFF. No clock groups are generated." }
        # CAUSE =       This may be caused by the fact that CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS is set to OFF.
        # ACTION =	Set CUT_OFF_PATHS_BETWEEN_CLOCK_DOMAINS to ON.
	# STATUS =	C

	set msg_db(I_CONVERT_DEFAULT_Q_ASGN) { 407 "Corresponding Quartus assignment: %s is not set. The value from %s assignment is used." }
        # CAUSE =        This is caused by the fact that INPUT/OUTPUT_MINIMUM_DELAY assignment is set to specific nodes, without assigning a corresponding INPUT/OUTPUT_MAXIMUM_DELAY assignment. This happens vice-versa.
        # ACTION =       HCII PT TCL script will assume the value for input_max_delay constraint is the same as the input_min_delay constraint.
        # STATUS =       C

        set msg_db(I_CUT_OFF_FROM_TO)  { 408 "The CUT = OFF -from %s -to %s will not be translated as it has already been accounted for in Quartus II" }
	# CAUSE  =	No translation when CUT is OFF.
	# ACTION =	Nothing to do.
	# STATUS =	C

	set msg_db(I_CUT_OFF_TO)  { 409 "The CUT = OFF -to %s will not be translated as it has already been accounted for in Quartus II" }
	# CAUSE  =	No translation when CUT is OFF.
	# ACTION =	Nothing to do.
	# STATUS =	C

        set msg_db(I_CUT_OFF_FROM)  { 410 "The CUT = OFF -from %s will not be translated as it has already been accounted for in Quartus II" }
	# CAUSE  =	No translation when CUT is OFF.	
	# ACTION =	Nothing to do.
	# STATUS =	C

	set msg_db(I_NO_CLK_IN_INPUT_DELAY)  { 411 "The Quartus assignment destination may consist of clock(s). Input delay is not allowed to set on clock port(s) {%s}" }
	# CAUSE  =      This is caused by the fact that INPUT_MAXIMUM/MINIMUM_DELAY assignment is set on clock node or wildcard/pure wildcard which may consist of clock nodes.
	# ACTION =      The clock nodes will not translate into PrimeTime collection and constraint. 
	# STATUS =	C
	
	 set msg_db(I_OPEN_FILE)  { 412 "Opening %s for output." }
	# CAUSE  =	Openning the file for output.
	# ACTION =	Nothing to do.
	# STATUS =	C

	set msg_db(I_RUN_EXE_TO_GENERATE_FILE)  { 413 "Run %s to generate the file." }
	# CAUSE  =	Required file doesn't exist.
	# ACTION =	Run the speicied executable to generate.
	# STATUS =	C
}
