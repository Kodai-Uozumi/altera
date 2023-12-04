# ----------------------------------------------------------------
#
namespace eval qtan {
#
# Description: Initialize all internal variables
#
# ----------------------------------------------------------------

	global quartus

	variable app_name	"quartus_tan"
	variable version	$quartus(version)
	variable copyright	$quartus(copyright)
	variable qtan_path	$quartus(tclpath)/apps/qtanw/

	variable mainframe
	variable summary_tree					# Top Left side panel's tree with summary
	variable toolbar_status 1
	variable flow_menu_exists 0
	variable progmsg
	variable progval 0

	variable project_dir						# holds the path to project directory
	variable project_name						# holds the name of the project

	# Log qtan commands

	# Maintain list of recent projects opened

	# Variables for holding settings

	variable flow_name							# stores the name of the flow

	variable error_count 0
	variable clk_list

	# link the other qtan scripts 

	# if qtan project settings file exists, then read the dlg settings from the file otherwise assign defaults

	set qtan::flow_name "create_netlist"
	set qtan::project_dir ""
	set qtan::project_name "<none>"

	if [info exists env(EDITOR)] {
		set default_editor $env(EDITOR)
		set use_default_editor 1
	}
	
	# variables for storing the state of qtan
	# to allow UI integration with cmdline
	variable compiler_status "disabled";		# current state of qtan
	variable update_compiler_status 0 ;			# tells qtan whether the compiler state needs to be updated after the execution of a cmdline command

	variable no_slack "2147483.647 ns";
}


# ----------------------------------------------------------------
#
proc qtan::post_user_msg { tag str } {
#
# Description:	Initialize application LOG Window
#
# ----------------------------------------------------------------

	switch $tag {
		errortag	{ post_message -type error	 "$str" }
		warningtag	{ post_message -type warning "$str" }
		boldtag		{ post_message -type info	 "$str" }
		infotag		{ post_message -type info	 "$str" }
		default		{ post_message -type info	 "$str" }
	}
}


# ----------------------------------------------------------------
#
proc qtan::print_info { msg } {
#
# Description:	Display info in Log window
#
# ----------------------------------------------------------------

	qtan::post_user_msg infotag "Info: $msg"
}


# ----------------------------------------------------------------
#
proc qtan::print_error { msg } {
#
# Description:	Display error in Log window
#
# ----------------------------------------------------------------

	qtan::post_user_msg errortag "Error: $msg"
}


# ----------------------------------------------------------------
#
proc qtan::print_warning { msg } {
#
# Description:	Display warning in Log window
#
# ----------------------------------------------------------------

	qtan::post_user_msg warningtag "Warning: $msg"
}


# ----------------------------------------------------------------
#
proc qtan::print_cmd { command } {
#
# Description:	Display command in log window and store in
#				log db
#				
# ----------------------------------------------------------------

	qtan::post_user_msg boldtag " $command"
}


# ----------------------------------------------------------------
#
proc qtan::print_msg { msg } {
#
# Description:	Display message in either log box (for GUI)
#				or using "puts" (for cmd)
#				
#				If cerr, also use puts to send to stderr
#
# ----------------------------------------------------------------

	qtan::post_user_msg msgtag " $msg"
}
