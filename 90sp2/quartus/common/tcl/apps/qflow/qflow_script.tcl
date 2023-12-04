set pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

###################################################################################
#                                                                                 #
# File Name:    qflow_script.tcl                                             	  #
#                                                                                 #
# Summary:      This TK script as a simple Graphical User Interface to compile    #
#               any design using the new Quartus II modular compiler              #
#                                                                                 #
# Licensing:    This script is  pursuant to the following license agreement       #
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE               #
#               FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,      #
#               California, USA.  Permission is hereby granted, free of           #
#               charge, to any person obtaining a copy of this software and       #
#               associated documentation files (the "Software"), to deal in       #
#               the Software without restriction, including without limitation    #
#               the rights to use, copy, modify, merge, publish, distribute,      #
#               sublicense, and/or sell copies of the Software, and to permit     #
#               persons to whom the Software is furnished to do so, subject to    #
#               the following conditions:                                         #
#                                                                                 #
#               The above copyright notice and this permission notice shall be    #
#               included in all copies or substantial portions of the Software.   #
#                                                                                 #
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,   #
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES   #
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND          #
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT       #
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,      #
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR     #
#               OTHER DEALINGS IN THE SOFTWARE.                                   #
#                                                                                 #
#               This agreement shall be governed in all respects by the laws of   #
#               the State of California and by the laws of the United States of   #
#               America.                                                          #
# Usage:                                                                          #
#                                                                                 #
#               You can run this script from a command line by typing:            #
#                                                                                 #
#                     quartus_sh -g [<project_name>]                              #
#    or               quartus_sh --gui [<project_name>]                           #
#                                                                                 #
#                                                                                 #
###################################################################################

puts "[info script] version $pvcs_revision"

# Only qflow exes can interpret this script
if [info exist quartus] {
	if { ![string equal $quartus(nameofexecutable) quartus_sh] } {
        set msg "QFlow should be invoked from the command line.\nusage: quartus_sh -g \[<project_name>\]"
		puts $msg
		catch { tk_messageBox -type ok -message $msg -icon error -title "QFlow Error"}
		return
	}
} else {
    set msg "QFlow should be invoked using the Quartus II Shell.\nusage: quartus_sh -g \[<project_name>\]"
	puts $msg
	catch { tk_messageBox -type ok -message $msg -icon error }
	exit -1
}

######################################### Pakcages ####################################

package require cmdline


######################################## back_end_process #################################################

# ----------------------------------------------------------------
#
namespace eval back_end_process {
#
# Description: namespace groups information and common code
#			on back end processes
#
# ----------------------------------------------------------------


	# Following array contains information about back end processed
	# Format is:
	#	<key> <Executable User Name> <Executable> <arguments>
	variable info
	array set info {

	map	    {"Analysis and Synthesis"    "quartus_map"  ""}
	fit	    {"Fitter"                    "quartus_fit"  ""}
	tan	    {"Classic Timing Analyzer"   "quartus_tan"  ""}
	sta	    {"TimeQuest Timing Analyzer" "quartus_sta"  ""}
	neto    {"EDA Netlist Writer"        "quartus_eda"  ""}
	asm	    {"Assembler"                 "quartus_asm"  ""}
	quartus {"Quartus II"                "quartus"      ""}
	pgmw    {"Programmer"                "quartus_pgmw" ""}
	staw    {"TimeQuest GUI"             "quartus_staw" ""}
	sh      {"Quartus II Shell"          "quartus_sh"   ""}
	import  {"Import Compiler Database"  "quartus_cdb"  "--import_database="}
	export  {"Export Compiler Database"  "quartus_cdb"  "--export_database="}
	archive {"Archiver"                  "quartus_sh"   "--archive"}
	restore {"Un-Archiver"               "quartus_sh"   "--restore"}
	compile {"Full Compile"              "quartus_sh"   "--flow compile"}

	}

	namespace export get_user_name get_exe_name get_exe_args get_exe_post_args

	proc get_user_name { key } { 
		variable info
		return [lindex $info($key) 0] 
	}
	proc get_exe_name { key } { 
		variable info
		global quartus
		return [file join $quartus(binpath) [lindex $info($key) 1]]
	}
	proc get_exe_args { key } { 
		variable info
		set result [lindex $info($key) 2]
		switch -- $key {
			import { append result [get_global_assignment -name VER_COMPATIBLE_DB_DIR] }
			export { append result [get_global_assignment -name VER_COMPATIBLE_DB_DIR] }			
			default { }
		}
		return $result
	}
	proc get_exe_post_args { key } { 
		set exe_post_args ""
		switch -- $key {
			archive { }
			restore { }
			default { append exe_post_args " -c [get_current_revision]" }
		}
		return $exe_post_args
	}

}

# Set global variables and constants
# ----------------------------------

set exit_script 0

set old_line ""

######################################## qflow #################################################

# ----------------------------------------------------------------
#
namespace eval qflow {
#
# Description: Initialize all internal variables
#
# ----------------------------------------------------------------

	global quartus

	variable app_name   "QFlow"
	variable version    $quartus(version)
	variable copyright  $quartus(copyright)
	variable qflow_path $quartus(tclpath)/apps/qflow/

	variable mainframe
	variable tool_pane						# holds the right hand side of paned window (for tool buttons)
	#variable log_window						# displays messages from execution of tools 
	
	# Set the BWidget directory path.

	variable project_dir						# holds the path to project directory
	variable project_name						# holds the name of the project
	variable project_args none					# holds the args to open the project

	variable acf

	variable use_timequest 0

	# Variables for holding settings

	variable default_editor "<none>"
	# Use external default editor or not
	variable use_default_editor 0
	# Show pop-up dialog box at the end of each process (i.e. compile)
	variable show_dlg_at_end_of_process 1

	# Show locations on applicable messages
	variable show_locations 0

	variable error_count 0

	set qflow::project_dir ""
	set qflow::project_name "<none>"

	if [info exists env(EDITOR)] {
		set default_editor $env(EDITOR)
		set use_default_editor 1
	}

	# Variables used to report status
    variable _status "Idle"
    variable _prgindic 0

	# List of supported Tools
	variable basic_tool_list { map fit tan asm neto }

	# Tool buttons
	variable buttons
	foreach tool $basic_tool_list {
		set buttons($tool) ""
	}
	set buttons(quartus) ""
	set buttons(pgmw) ""
	set buttons(full_compile) ""
	set buttons(stop) ""
	set buttons(new) ""

	# variables for storing the state of QFLOW
	# to allow UI integration with cmdline
	variable compiler_status "disabled";			# current state of QFLOW
	variable update_compiler_status 0 ;			# tells QFLOW whether the compiler state needs to be updated after the execution of a cmdline command
}

namespace eval qflow::log_window {
	variable index
}

# namespace in which to evaluate user cmds
namespace eval qflow::user_namespace {
}

# ----------------------------------------------------------------
#
proc qflow::main {} {
#
# Description: Entry point
#
# ----------------------------------------------------------------
	
	global quartus
	variable app_name
	variable project_name

	option add *TitleFrame.l.font {helvetica 11 bold italic}
	option add *LabelFrame.l.font {helvetica 10}

	wm withdraw .
	wm title . "$app_name"

	qflow::create
	BWidget::place . 0 0 center
	wm deiconify .
	raise .
	focus -force .

}

# ----------------------------------------------------------------
#
proc qflow::create { } {
#
# Description: Creates all the GUI elements
#
# ----------------------------------------------------------------

	variable mainframe
	variable tool_pane

	# Menu creation
	qflow::init_menus

	# Toolbar creation
	qflow::init_toolbar

	# Create a Paned window
	set pane_window_frame [$mainframe getframe]
	set paned_window [PanedWindow $pane_window_frame.pw -side top]

	#Create file pane (left side) and create second pane for buttons and message window (Right Side)
	set tool_pane [$paned_window add -weight 2]

	# Populate File Pane and Tool Pane
	qflow::populate_tool_pane

	#Pack Paned Window
	pack $paned_window -fill both -expand yes -padx 4 -pady 4


	# Pack the mainframe
	update idletasks

	#Make sure when the user destroys the application, the project settings are stored in qflow project file
	bind $mainframe <Destroy> { qflow::close_qflow }
}

# ----------------------------------------------------------------
#
proc qflow::close_qflow { } {
#
# Description: Writes the project settings back to qflow project file (qflow_settings.txt)
#
# ----------------------------------------------------------------

	global exit_script 

	if { [is_project_open] } {
		export_assignment_files
		_project_close
	}
	
	set exit_script 1
}	

# ----------------------------------------------------------------
#
proc qflow::init_menus { } {
#
# Description: Initialize all the menus
#
# ----------------------------------------------------------------

	variable mainframe
	variable project_name
	variable version
	variable _status

	set menu_desc {
		"&File" all file 0 {
			{command "New &Project..." {} "Creates a Project" {Ctrl N} -command "qflow::eval_cmd qflow::on_new_project_dlg" }
			{command "Open P&roject..." {} "Opens a Project" {Ctrl O} -command "qflow::eval_cmd qflow::on_open_project_dlg" }
			{command "&Close Project" {project_open_menu} "Closes a Project" {} -command "qflow::eval_cmd qflow::on_close_project" }
			{separator}
			{command "&New Text File" {default_editor_menu} "New Text file" {} -command "qflow::eval_cmd qflow::on_new_file" }
			{command "&Open Text File..." {} "Open Text File" {} -command "qflow::eval_cmd qflow::on_open_file" }
			{separator}
			{command "&Import Compiler Database" {project_open_menu} "Import Compiler Database" {} -command "qflow::eval_cmd \"qflow::on_start_quartus_process import\"" }
			{command "&Export Compiler Database" {project_open_menu} "Export Compiler Database" {} -command "qflow::eval_cmd \"qflow::on_start_quartus_process export\"" }
			{separator}
			{command "&Archive Project" {project_open_menu} "Archive" {} -command "qflow::eval_cmd \"qflow::on_start_quartus_process archive\"" }
			{command "&Restore Project" {project_open_menu} "Restore" {} -command "qflow::eval_cmd \"qflow::on_start_quartus_process restore\"" }
			{separator}
			{command "Op&tions..." {} "Sets user options" {} -command qflow::on_open_prefer_dlg }
			{separator}
			{command "E&xit" {} "Exit qflow" {Alt F4} -command exit }
		}
		"&Assign" all options 0 {
			{separator}
			{command "&Add/Remove HDL File(s)..." {project_open_menu} "Add and/or remove HDL files to the project " {} -command "qflow::eval_cmd qflow::on_add_remove_file_dlg" }
			{command "Family and &Synthesis Settings..." {project_open_menu} "Edit device family and  synthesis settings" {} -command qflow::open_map_opt_dlg}
			{command "Device and &Fitter Settings..." {project_open_menu} "Edit device and fitter settings" {} -command qflow::open_fit_opt_dlg}
			{command "&Timing Settings..." {project_open_menu} "Edit timing settings" {} -command qflow::open_tan_opt_dlg}
			{command "&Compiler Settings..." {project_open_menu} "Edit compiler settings" {} -command qflow::open_cmp_opt_dlg}
		}
		"&Processing" all file 0 {
			{command "Start &Full Compilation" {project_open_menu} "Start predefined flow 'Full Compilation'" {Ctrl L} -command "qflow::eval_cmd \"qflow::on_start_quartus_process compile\""}
			{separator}
			{command "Start Analysis and &Synthesis" {project_open_menu} "Perform logic synthesis and technology mapping on design" {Ctrl K} -command "qflow::eval_cmd \"qflow::on_start_quartus_process map\"" }
			{command "Start &Fitter" {project_open_menu} "Perform place and route on design" {Ctrl F} -command "qflow::eval_cmd \"qflow::on_start_quartus_process fit\"" }
			{command "Start Default &Timing Analyzer" {project_open_menu} "Perform Delay Annotation and Classic or TimeQuest Timing Analysis on design" {Ctrl T} -command "qflow::eval_cmd \"qflow::on_start_quartus_process tan \"" }
			{command "Start &Assembler" {project_open_menu} "Generate programming files" {} -command "qflow::eval_cmd \"qflow::on_start_quartus_process asm\"" }
			{command "Start &EDA Netlist Writer" {project_open_menu} "Generate input files for EDA Verification tools" {} -command "qflow::eval_cmd \"qflow::on_start_quartus_process neto\"" }
			{command "&Stop Process" {compiling_menu} "Stop current process" {} -command qflow::stop_compile }
			{separator}
			{command "Open Analysis and Synthesis Report" {map_rpt_menu} "Open Analysis and Synthesis Synthesis Report" {Ctrl 1} -command "qflow::eval_cmd \"qflow::open_rpt map\"" }
			{command "Open Fitter Report" {fit_rpt_menu} "Open Fitter Report" {Ctrl 2} -command "qflow::eval_cmd \"qflow::open_rpt fit\"" }
			{command "Open Default Timing Analysis Report" {tan_rpt_menu} "Open Classic or TimeQuest Timing Analysis Report" {Ctrl 3} -command "qflow::eval_cmd \"qflow::open_rpt tan\"" }
			{command "Open Assembler Report" {asm_rpt_menu} "Open Assembler Report" {Ctrl 4} -command "qflow::eval_cmd \"qflow::open_rpt asm\"" }
			{command "Open EDA Netlist Writer Report" {neto_rpt_menu} "Open EDA Netlist Writer Report" {Ctrl 5} -command "qflow::eval_cmd \"qflow::open_rpt neto\"" }
			{separator}
			{command "Open Classic Timing Analysis Tk &Window" {project_open_menu} "Open Classic Timing Analysis Tk-based Window" {} -command "qflow::eval_cmd \"qflow::on_start_tk_script tanw\"" }
			{command "Open TimeQuest Timing Analysis &Window" {project_open_menu} "Open TimeQuest Timing Analysis Window" {} -command "qflow::eval_cmd \"qflow::on_open_quartus_gui staw\"" }
			{command "Open &Design Space Explorer" {project_open_menu} "Open Design Space Explorer" {} -command "qflow::eval_cmd \"qflow::on_start_tk_script dse\"" }
			{command "Open &Programmer" {programmer_menu} "Opens Quartus II programmer" {} -command "qflow::eval_cmd \"qflow::on_open_quartus_gui pgmw\"" }
			{command "Open &Quartus II" {project_open_menu} "Opens Quartus II graphical user interface" {} -command "qflow::eval_cmd \"qflow::on_open_quartus_gui quartus\"" }
		}
		"&Help" all options 0 {
			{command "&Readme" {} "Show QFlow Readme" {} -command "qflow::eval_cmd qflow::on_help"}
			{command "&QHelp" {} "Open QHelp" {} -command "qflow::eval_cmd \"qflow::on_start_tk_script qhelp\"" }
			{separator}
			{command "&About QFlow" {} "About QFlow" {} -command qflow::about_dlg}
		}
	}

	set _status "Idle"
	set mainframe [ MainFrame .mainframe \
			-height  600\
			-menu	$menu_desc \
			-textvariable qflow::_status \
            -progressvar  qflow::_prgindic \
			-width 1000]

    $mainframe addindicator -text "$qflow::version"
    $mainframe showstatusbar qflow::_status

    pack $mainframe -fill both -expand yes

	if { !$qflow::use_default_editor } {
		$mainframe setmenustate default_editor_menu disabled
	}

}

# ----------------------------------------------------------------
#
proc qflow::init_toolbar { } {
#
# Description: Initializes the toolbar
#
# ----------------------------------------------------------------

	variable mainframe
	variable project_dir
	variable project_name
	variable qflow_path
	variable use_default_editor

	variable buttons
	variable basic_tool_list
	

	## Adding general toolbar

	set toolbar [$mainframe addtoolbar]
	set bbox [ButtonBox $toolbar.bbox -spacing 0 -padx 2 -pady 2]
	set buttons(new) [$bbox add -image [Bitmap::get ${qflow::qflow_path}/icons/new] \
        	-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
			-command "qflow::eval_cmd qflow::on_new_file" \
			-helptext "New Text File"]
	if { !$qflow::use_default_editor } {
		$buttons(new) configure -state disabled
	}

	$bbox add -image [Bitmap::get ${qflow::qflow_path}/icons/open] \
        	-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
			-command "qflow::eval_cmd qflow::on_open_file" \
			-helptext "Open a Text File"

	pack $bbox -side left -anchor w

	set sep [Separator $toolbar.sep -orient vertical]
	pack $sep -side left -fill y -padx 4 -anchor w

	set bbox [ButtonBox $toolbar.bbox3 -spacing 0 -padx 2 -pady 2]
	set buttons(setting) [$bbox add -image [Bitmap::get ${qflow::qflow_path}/icons/ase] \
        			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
					-command qflow::on_settings_dlg \
			        -helptext "Edit Settings"]
	pack $bbox -side left -anchor w

	set sep [Separator $toolbar.sep5 -orient vertical]
	pack $sep -side left -fill y -padx 4 -anchor w

	set bbox [ButtonBox $toolbar.bbox4 -spacing 0 -padx 2 -pady 2]

	set buttons(full_compile) [$bbox add -image [Bitmap::get ${qflow::qflow_path}/icons/cmp_start] \
        			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
					-command "qflow::eval_cmd \"qflow::on_start_quartus_process compile\"" \
					-helptext "Start [::back_end_process::get_user_name compile]"]
	pack $bbox -side left -anchor w

	foreach tool $basic_tool_list {
		set icon_file ${qflow::qflow_path}/icons/${tool}_start
		set buttons($tool) [$bbox add -image [Bitmap::get $icon_file] \
        			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
					-command "qflow::eval_cmd \"qflow::on_start_quartus_process $tool\"" \
					-helptext "Start [::back_end_process::get_user_name $tool]"]
		pack $bbox -side left -anchor w
	}

	set buttons(stop) [$bbox add -image [Bitmap::get ${qflow::qflow_path}/icons/stop] \
        			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
					-command qflow::stop_compile \
					-helptext "Stop current process"]
	pack $bbox -side left -anchor w

	set buttons(pgmw) [$bbox add -image [Bitmap::get ${qflow::qflow_path}/icons/pgmw] \
			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 1 -pady 1 \
			-command "qflow::eval_cmd \"qflow::on_open_quartus_gui pgmw\"" \
			-helptext "Open [::back_end_process::get_user_name pgmw]"]
	pack $bbox -side left -anchor w

	set buttons(quartus) [$bbox add -image [Bitmap::get ${qflow::qflow_path}/icons/pjm] \
			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 1 -pady 1 \
			-command "qflow::eval_cmd \"qflow::on_open_quartus_gui quartus\"" \
			-helptext "Open [::back_end_process::get_user_name quartus]"]
	pack $bbox -side left -anchor w

	set sep [Separator $toolbar.sep3 -orient vertical]
	pack $sep -side left -fill y -padx 4 -anchor w

	set bbox [ButtonBox $toolbar.bbox2 -spacing 0 -padx 2 -pady 2]
	foreach tool $basic_tool_list {
		set icon_file ${qflow::qflow_path}/icons/${tool}
		set buttons(${tool}_rpt) [$bbox add -image [Bitmap::get $icon_file] \
        			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
					-command "qflow::eval_cmd \"qflow::open_rpt $tool\"" \
					-helptext "Open [::back_end_process::get_user_name $tool] Report"]
		pack $bbox -side left -anchor w
	}

	set sep [Separator $toolbar.sep2 -orient vertical]
	pack $sep -side left -fill y -padx 4 -anchor w

	#Disable the buttons if no project is opened
	if { $qflow::project_dir == "" } { 
		qflow::set_compiler_status disabled
	}
}

# ----------------------------------------------------------------
#
proc qflow::populate_tool_pane { } {
#
# Description: Populate the tool pane with the buttons and Message Window
#
# ----------------------------------------------------------------

	variable tool_pane
	
	#Create Log Window for displaying messages
	qflow::init_log_window
}	

# ----------------------------------------------------------------
#
proc qflow::init_log_window { } {
#
# Description:	Initialize application LOG Window
#
# ----------------------------------------------------------------

	global quartus
	
	# Variables related to Application
	variable app_name
	variable version
	variable project_name

	# Variables related to Widgets
	variable mainframe
	variable log_window
	variable tool_pane
	variable default_editor

	set label_frame	[LabelFrame $tool_pane.label_frame -text "Console Window" -font {helvetica 10 bold italic} \
							   -side top \
							   -anchor nw \
							   -relief sunken \
							   -borderwidth 1]

	set sub_frame [$label_frame getframe]
	set log_window [text $sub_frame.log_window -setgrid false -fg black -font {Courier}  \
						   -yscrollcommand "$sub_frame.y_scroll set"]
	scrollbar $sub_frame.y_scroll -orient vertical -command "$sub_frame.log_window yview"

	pack $sub_frame.y_scroll -side right -fill y 
	pack $sub_frame.log_window -side left -expand yes -fill both
	pack $sub_frame -side top -fill both -expand yes 

	pack $label_frame -side  top -fill both -expand yes

	# Creating tags to control display of message like color, font, size etc.
	$log_window tag configure boldtag -font {Courier 10 bold}
	$log_window tag configure errortag -foreground red -font {Courier 10 bold}
	$log_window tag configure warningtag -foreground blue -font  {Courier 10}
	$log_window tag configure infotag -foreground darkgreen -font  {Courier 10 bold}
	$log_window tag configure msgtag -font {Courier 10}
	$log_window tag configure prompttag -foreground blue -font {Courier 10}
	$log_window tag configure usertag -font {Courier 10 bold}
	$log_window tag configure criticalwarningtag -foreground blue -font  {Courier 10 bold}

	qflow::rename_cmds
	qflow::print_msg "---------------------------------------------------------------------------------------"
	qflow::print_msg ""
	if { [string match $qflow::default_editor "<none>"] } {
		qflow::print_warning "Default text editor has not been specified."
		qflow::print_warning "Text files will be displayed (read-only) in the Console Window."
		qflow::print_warning "To open and edit text files, set the EDITOR environment variable to a text editor executable"
	} else {
		qflow::print_msg "Found environment variable EDITOR=$qflow::default_editor"
		qflow::print_msg "Text files will be opened using $qflow::default_editor <file_name>"
	}
	qflow::print_msg ""
	qflow::print_msg ""
	qflow::print_msg "---------------------------------------------------------------------------------------"
	qflow::print_msg ""

	# *****************************************************************
	# Process Parameters

	# List of available options. 
	# This array is used by the cmdline package
	set available_options {
		{ no_popups "Do not display dialog box at end of processing" }
		{ show_locations "Display location information for applicable messages" }
	}

	# Need to define argv for the cmdline package to work
	set ::argv0 "quartus_sh --qflow"
	set usage "\[<options>\] <project_name>:"

	set argument_list $quartus(args)

	# Use cmdline package to parse options
	if [catch {array set optshash [cmdline::getoptions argument_list $available_options]} result] {
		puts ""
		if {[llength $argument_list] > 0 } {
			# This is not a simple -? or -help but an actual error condition
			puts "Error: Illegal Options"
		}
		puts [::cmdline::usage $available_options $usage]
		puts "For more details, use \"quartus_sh --help=qflow\""
		exit 2
	}

	if { $optshash(no_popups) } { 
		set qflow::show_dlg_at_end_of_process 0 
	}
	if { $optshash(show_locations) } { 
		set qflow::show_locations 1 
	}


	# cmdline::getoptions is going to modify the argument_list.
	# Note however that the function will ignore any positional arguments
	# We are only expecting one and only one positional argument (the project)
	# so give an error if the list has more than one element
	if {[llength $argument_list] == 1 } {

		# The first argument MUST be the project name
		set qflow::project_name [lindex $argument_list 0]

		if [string compare [file extension $qflow::project_name] ""] {

			set qflow::project_name [file rootname $qflow::project_name]
		}

		set qflow::project_name [file normalize $qflow::project_name]
	
		msg_vdebug  "Project = $qflow::project_name"

		# Create and/or open project
		if { [project_exists $qflow::project_name] } {
			qflow::open_project
		} else {
			qflow::create_project
		}

	} else {
		set qflow::project_name "<none>"
	}
	
	qflow::log_window::print_prompt
	qflow::log_window::enable_cmdline
}

##################### LOG WINDOW FUNCTIONS ########################
proc qflow::log_window::print_prompt { } {
	
	$qflow::log_window insert end "tcl> " prompttag
	set qflow::log_window::index [$qflow::log_window index "end -1 lines lineend"]
	$qflow::log_window see end
}



###########################################################
# proc qflow::log_window::enable_cmdline {}
#
# Description:	enables user input into the log_window for
#				commands
#
# Returns:		
#
###########################################################
proc qflow::log_window::enable_cmdline {} {

	bind $qflow::log_window <KeyPress> {
   		switch -- %K {
       		"Up" -
       		"Left" -
       		"Right" -
       		"Down" -
       		"Next" -
       		"Prior" -
       		"Home" -
       		"Control_L" -
       		"Control_R" -
       		"End" { }

       		"Return" {
        		set index [expr [$qflow::log_window index end]-1]
	        	regexp "(?:tcl> )*(.*)" [$qflow::log_window get $index end] match command
	        	$qflow::log_window insert end "\n"

	        	qflow::eval_cmd $command				
				break
       		}

       		"BackSpace" {
        		qflow::log_window::move_cursor
        		if  [$qflow::log_window compare [$qflow::log_window index insert] <= $qflow::log_window::index] {
	        		break
        		}
			}
			
			"c" -
        	"C" {
            	if {(%s & 0x04) == 0} {
                	qflow::log_window::move_cursor
    				$qflow::log_window tag add usertag [$qflow::log_window index "insert -1 chars"] end
            	}
        	}

       		default {
				qflow::log_window::move_cursor
    			$qflow::log_window tag add usertag [$qflow::log_window index "insert -1 chars"] end
			}
   		}
}
}


###########################################################
# proc qflow::log_window::disable_cmdline {}
#
# Description:	disables user input into the log_window for
#				commands
#
###########################################################
proc qflow::log_window::disable_cmdline {} {

	bind $qflow::log_window <KeyPress> {
		break
	}
}


###########################################################
# proc qflow::log_window::move_cursor{}
# 
# Description:  If the cursor is not on the editable portion
#				of the log window (i.e. the last line), then
#				moves the cursor to the end of the line
#				in the log window for inserting new text
#
#
###########################################################
proc qflow::log_window::move_cursor {} {
	if  [$qflow::log_window compare [$qflow::log_window index insert] < $qflow::log_window::index] {
		event generate $qflow::log_window <Control-Key-End>
	}
}


###########################################################
# proc qflow::eval_cmd { command }
# 
# Description:  evaluates a command in the namespace reserved
#				for the user tcl shell and posts the appropriate
#				return messages to the log window
#
# Returns:		1 if an error occurred
#				0 otherwise
#
###########################################################
proc qflow::eval_cmd { command } {
	
	variable compiler_status
	variable update_compiler_status
	
	# store the current state of qflow into a temp variable
	set prev_state $compiler_status
	
	# now disable cmdline and user interface
	qflow::log_window::disable_cmdline
	qflow::set_compiler_status disabled
	set update_compiler_status 1

	if [catch {namespace inscope user_namespace eval $command} result] {
		$qflow::log_window insert end "$result\n" errortag
	} else {
		$qflow::log_window insert end "$result\n" infotag
	}

	# enable the cmdline
	qflow::log_window::print_prompt
	qflow::log_window::enable_cmdline
	
	# if qflow state has not been updated, update it
	if {$update_compiler_status} {
		qflow::set_compiler_status $prev_state
	}

	return $result
}


##########################################################
# proc qflow::on_qflow_cmd { command }
#
# Description:  the interface to run all UI commands as
#				well as qflow cmdline commands; synchronizes
#				the two together to update the UI when
#				commandline executes and vice versa
#
# Returns:		-1 if not a qflow command
#				
##########################################################

proc qflow::on_qflow_cmd { command } {
	
	## Determine first if the command is a qflow command
	 # if not, return -1
	switch -- [lindex $command 0] {
		"project_open" {
			set qflow::project_args $command
			set command qflow::open_project
		}
		"project_new" {
			set qflow::project_args $command
			set command qflow::create_project
		}
		"project_close" {set command qflow::on_close_project }
		
		default { return -1 }
	}
	$qflow::log_window insert end "\n"
	
	# Run the appropriate set of commands
	if [catch {eval $command} result] {
		return -code error $result
	}
}


###########################################################
# proc qflow::rename_cmds {}
#
# Description:	renames certain tcl and qflow commands to
#				allow us to handle them better through
#				other functions that act as wrappers that
#				call the originals
#
# Returns:		1 if an error occurred
#				0 otherwise
#
###########################################################
proc qflow::rename_cmds {} {

	rename ::puts ::_puts
	rename ::_qflow_puts ::puts
	rename ::unknown ::_unknown
	rename ::_qflow_unknown ::unknown

	rename project_open _project_open
	rename project_new _project_new
	rename project_close _project_close
}

############### Custom TCL functions ############################

###############################################
# proc _qflow_puts { args }
#
# Description:	Custom puts function
#
###############################################
proc _qflow_puts { args } {
	if {[llength $args] == 1} {
		$qflow::log_window insert end "[lindex $args 0]\n" infotag
	} else {
		if {[llength $args] == 2 && [string equal [lindex $args 0] "stdout"]} {
			$qflow::log_window insert end [lindex $args 1] infotag
		} else {
			eval _puts $args
		}
	}
}

################################################
# proc _qflow_unknown args {
#
# Description:	Custom unknown function
#
################################################
proc _qflow_unknown args {
	global auto_noexec
	global errorCode errorInfo

	## call the original unknown function
	 # use eval to allow passing of arbitrary # of args
	set cmd_not_found [catch {eval _unknown $args} result]
	if {!$cmd_not_found} {
		return $result
	}

	## Examine if the command is a qflow command
	 # and execute as necessary
	set return_value [qflow::on_qflow_cmd $args]
	if {$return_value != -1} {
		return $return_value
	}

	# If the command word has the form "namespace inscope ns cmd"
	# then concatenate its arguments onto the end and evaluate it.

	set cmd [lindex $args 0]
	if {[regexp "^namespace\[ \t\n\]+inscope" $cmd] && [llength $cmd] == 4} {
		set arglist [lrange $args 1 end]
		set ret [catch {uplevel $cmd $arglist} result]
		if {$ret == 0} {
			return $result
		} else {
			return -code $ret -errorcode $errorCode $result
		}
	}

	# Save the values of errorCode and errorInfo variables, since they
	# may get modified if caught errors occur below.  The variables will
	# be restored just before re-executing the missing command.

	set savedErrorCode $errorCode
	set savedErrorInfo $errorInfo

	# The caller may have put all arguments between "", so we need to assume
	# that we still have a second list at this point. Split it and and then
	# try to get the first argument
	set name [lindex [split [lindex $args 0] " "] 0]
	set arglist [lrange [split [lindex $args 0] " "] 1 end]
	foreach i [lrange $args 1 end] { append arglist " \"$i\"" }
	for { set i 0 } { $i < [llength $arglist] } { incr i } {
		set argv($i) [lindex $arglist $i]
	}
	
	if {![info exists auto_noexec]} {
	    set new [auto_execok $name]
	    if {[string compare {} $new]} {
			set errorCode $savedErrorCode
			set errorInfo $savedErrorInfo
			set redir ""
			if {[string equal [info commands console] ""]} {
				set redir ">&@stdout <@stdin"
			}
			# Must use eval here to expand the arglist, allowing us to
			# pass an arbitrary number of arguments.
			return [eval exec $new $arglist]
	    }
	}
	set errorCode $savedErrorCode
	set errorInfo $savedErrorInfo
	
	return -code error "invalid command name \"$name\""
}

########### Functions for Menu items########################################################################################

# ----------------------------------------------------------------
#
proc qflow::set_compiler_status { state } {
#
# Description:	Depending on the state, enable or disable all
#				releant buttons
#
# ----------------------------------------------------------------

	variable buttons
	variable basic_tool_list
	variable compiler_status
	variable update_compiler_status
	variable project_name

	variable mainframe

	switch $state {
		running { 
			# Process is running. 
			# Disable tool buttons
			set project_open_state disabled
			# Enable stop button
			set compiling_state normal
		}
		waiting { 
			# Process is not  running. 
			# Enable tool buttons
			set project_open_state normal
			# Disable stop button
			set compiling_state disabled
		}
		disabled { 
			# Project is not open
			# Disable tool buttons
			set project_open_state disabled
			# Disable stop button
			set compiling_state disabled
		}
		default {
			# Ilegal condition
			puts stderr "Internal Error: Illegal condition"
			exit -1
		}
	}
	
		## store the status of QFLOW and mark QFLOW as having already been updated
	set compiler_status $state
	set update_compiler_status 0

		# Disable Programmer if it doesn't exist
	set pgmw_exe_name [::back_end_process::get_exe_name pgmw]
	if {![file executable $pgmw_exe_name]} { append pgmw_exe_name ".exe" }
	set programmer_state [expr {[file executable $pgmw_exe_name] ? $project_open_state : "disabled"}]

	# Enable all tool buttons and flow button after a Project is Selected

	foreach tool $basic_tool_list {

			# Handle modules
		$buttons($tool) configure -state $project_open_state

			# Handle .rpt files
		set rpt_file_state $project_open_state
		if {[string compare $project_open_state disabled] != 0} {
			set rpt_file_name $project_name.
			if [string equal $tool "neto"] {
				# neto was renamed to eda in V3.0
				append rpt_file_name eda
			} else {
				append rpt_file_name ${tool}
			}
			append rpt_file_name .rpt
			if {[file isfile $rpt_file_name] != 1} {
				set rpt_file_state disabled
			}
		}
			# 145687: Disable if .rpt file is missing
		$buttons(${tool}_rpt) configure -state $rpt_file_state
		$mainframe setmenustate ${tool}_rpt_menu $rpt_file_state
	}

	$buttons(full_compile) configure -state $project_open_state
	$buttons(quartus) configure -state $project_open_state
	$buttons(pgmw) configure -state $programmer_state

	$buttons(setting) configure -state $project_open_state
	$buttons(stop) configure -state $compiling_state

	# Enable or disable Menus
	$mainframe setmenustate project_open_menu $project_open_state
	$mainframe setmenustate compiling_menu $compiling_state
	$mainframe setmenustate programmer_menu $programmer_state
}

# ----------------------------------------------------------------
#
proc qflow::open_project { } {
#
# Description:	Open Project
#
# ----------------------------------------------------------------

	variable app_name

	set project $qflow::project_name
	set cmd "_project_open $project -current_revision"
	if {[string compare $qflow::project_args none] != 0} {
		set project [lindex $qflow::project_args 1]
		set cmd "_$qflow::project_args"
		set qflow::project_args none
	}
	set msg [eval $cmd]
	if {[string length $msg] > 0} {
		regsub {^WARNING: } $msg "" msg
		qflow::print_warning $msg
	} else {
		qflow::print_msg "Opened project: $project (Revision: [get_current_revision])"
	}
	# Only set the project if there were no errors
	set qflow::project_name $project
	# Rename the title
	wm title . "$qflow::app_name - $project"

	# Enable all tool buttons and flow button after a Project is Selected
	qflow::set_compiler_status waiting

	set qflow::acf(USE_TIMEQUEST_TIMING_ANALYZER) [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER]
	if [string equal -nocase $qflow::acf(USE_TIMEQUEST_TIMING_ANALYZER) ON] {
		set qflow::use_timequest 1
	} else {
		set qflow::use_timequest 0
	}
}

# ----------------------------------------------------------------
#
proc qflow::create_project { } {
#
# Description:	Create Project
#
# ----------------------------------------------------------------

	variable app_name

	set project $qflow::project_name
	set cmd "_project_new $project"
	if {[string compare $qflow::project_args none] != 0} {
		set project [lindex $qflow::project_args 1]
		set cmd "_$qflow::project_args"
		set qflow::project_args none
	}
	set msg [eval $cmd]
	if {[string length $msg] > 0} {
		regsub {^WARNING: } $msg "" msg
		qflow::print_warning $msg
	} else {
		qflow::print_msg "Created project: $project (Revision: [get_current_revision])"
	}
		# Only set the project if there were no errors
	set qflow::project_name $project
		# Rename the title
	wm title . "$qflow::app_name - $qflow::project_name"

	# Enable all tool buttons and flow button after a Project is Selected
	qflow::set_compiler_status waiting
}

# ----------------------------------------------------------------
#
proc qflow::on_new_project_dlg {} {
#
# Description:	Dialog Box to create project
#
# ----------------------------------------------------------------

	variable project_dir
	variable project_name
	variable app_name

	set typelist {
		{"Project Files" {".qpf"}}
		{"All Files" {"*.*"}}
	}

	if { [is_project_open] } {
		set dlg_result [tk_messageBox -type yesno -message "Project is already open. OK to close first?" -title "$qflow::app_name" -icon question]
		if { [string match $dlg_result "yes"] } {
			qflow::on_close_project
		} else {
			# Exit without showing open DLG
			return
		}
	}

	set project_file_name [tk_getSaveFile -filetypes $typelist -title "New Project" -defaultextension ".qpf"]
	if { $project_file_name == "" } {
		qflow::print_msg "No project was created"
		qflow::on_close_project
	} else {
		set qflow::project_dir [file dirname $project_file_name]
		cd $qflow::project_dir
		set qflow::project_name [file rootname [file tail $project_file_name]]
		# Display files in tree structure in left window pane in files tab
	
		# Open/Create Project
		if { [project_exists $qflow::project_name] } {	
			# Need to delete all project files first
			file delete -force db
			file delete -force $qflow::project_name.psf
			file delete -force $qflow::project_name.csf
			file delete -force $qflow::project_name.esf
			file delete -force $qflow::project_name.quartus
			file delete -force $qflow::project_name.qsf
			file delete -force $qflow::project_name.qpf
		}

		qflow::create_project
	}
}

# ----------------------------------------------------------------
#
proc qflow::on_open_project_dlg {} {
#
# Description:	Dialog Box to open project
#
# ----------------------------------------------------------------

	variable project_dir
	variable project_name
	variable app_name

	set typelist {
		{"Project Files" {".qpf" ".qsf" ".quartus"}}
	}

	if { [is_project_open] } {
		set dlg_result [tk_messageBox -type yesno -message "Project is already open. OK to close first?" -title "$qflow::app_name" -icon question]
		if { [string match $dlg_result "yes"] } {
			qflow::on_close_project
		} else {
			# Exit without showing open DLG
			return
		}
	}

	set project_file_name [tk_getOpenFile -filetypes $typelist -title "Open a Project"]
	if { $project_file_name == "" } {
		qflow::print_msg "No project was open"
		qflow::on_close_project
	} else {
		set qflow::project_dir [file dirname $project_file_name]
		cd $qflow::project_dir
		set qflow::project_name [file rootname [file tail $project_file_name]]
		# Display files in tree structure in left window pane in files tab
	
		# Open/Create Project
		if { ![project_exists $qflow::project_name] } {
			set dlg_result [tk_messageBox -type yesno -message "$qflow::app_name Project does not exist. OK to create?" -title "$qflow::app_name" -icon question]
			if { [string match $dlg_result "yes"] } {
				qflow::create_project
			}
				
			# Exit without showing open DLG
			return
		}

		qflow::open_project
	}
}

# ----------------------------------------------------------------
#
proc qflow::on_new_file {} {
#
# Description:	Dialog Box to open a text file
#
# ----------------------------------------------------------------

	variable use_default_editor
	variable default_editor

	if { $qflow::use_default_editor } {
		# Launch external editor
		qflow::print_msg "Calling: $qflow::default_editor"
		if [catch { exec $qflow::default_editor & } result] {
			qflow::print_error "Error: $result"
		}
	} else {
		qflow::print_msg "Ignored command: No default editor is defined"
	}
}

# ----------------------------------------------------------------
#
proc qflow::on_open_file {} {
#
# Description:	Dialog Box to open a text file
#
# ----------------------------------------------------------------


	set typelist {
		{"Design Files" {".v" ".vhd" ".vhdl" ".tdf"}}
		{"Project Files" {".qpf" ".qsf" ".quartus" }}
		{"All Files" {"*.*"}}
	}

	set file_name [tk_getOpenFile -filetypes $typelist -title "Open"]
	if { $file_name == "" } {
	} else {
		qflow::open_ascii_file $file_name
	}
}

# ----------------------------------------------------------------
#
proc qflow::on_add_button { lb } {
#
# Description: Use GetFile to get HDL file
#
# ----------------------------------------------------------------

	global tcl_platform

	set typelist {
		{"Design Files" {".v" ".vhd" ".vhdl"}}
	}

	set new_file_name [tk_getOpenFile -filetypes $typelist -title "Add file to project"]
	if { $new_file_name == "" } {
#		qflow::print_msg "No file was added"
	} else {

		set num_entries [$lb size]
	
		# Check if file is already there
		for { set i 0 } { $i < $num_entries } { incr i } {
			set file [$lb get $i]
			if { [string equal -nocase $tcl_platform(platform) "unix"] } {
				if { [string equal "[file split $file]" "[file split $new_file_name]"] } {
					qflow::print_msg "File $file is already in the project"
					return
				}
			} else {
				if { [string equal -nocase "[file split $file]" "[file split $new_file_name]"] } {
					qflow::print_msg "File $file is already in the project"
					return
				}
			}
		}

		$lb insert end $new_file_name
	} 
}

# ----------------------------------------------------------------
#
proc qflow::update_file_list { lb } {
#
# Description:	Update file list based on a new addition/deletion
#
# ----------------------------------------------------------------

	set file_asgn_col [get_all_global_assignments -name SOURCE_FILE]

	# Add each file to the list
	foreach_in_collection file_asgn $file_asgn_col {
		# Get all assignments returns an array of subarrays
		# The subarrays format in this case is:
		# {} {SOURCE_FILE} {<file_name>}
		set file [lindex $file_asgn 2]
		$lb insert end $file
	}
}

# ----------------------------------------------------------------
#
proc qflow::on_updown_button { lb updown } {
#
# Description:	Dialog Box to remove files to project
#
# ----------------------------------------------------------------

	set num_entries [$lb size]
	
	if { [llength [$lb curselection]] != 1 } {
		qflow::print_error "Only one selection can be moved at one time"
		$lb selection clear 0 end
		return
	}

	for { set i 0 } { $i < $num_entries } { incr i } {
		set file [$lb get $i]
		set new($i) $file
	}

	for { set i 0 } { $i < $num_entries } { incr i } {
		set file [$lb get $i]
		if [$lb selection includes $i] {
			
			if { $updown == "up" } {
				if { $i > 0 } {
					set temp $new([expr $i - 1])
					set new([expr $i - 1]) $file
					set new($i) $temp
					set new_sel [expr $i - 1]
					break
				} else {
					# Do nothing
					set new_sel 0
				}
			} else {
				if { $i < [expr $num_entries - 1] } {
					set temp $new([expr $i + 1])
					set new([expr $i + 1]) $file
					set new($i) $temp
					set new_sel [expr $i + 1]
					break
				} else {
					# Do nothing
					set new_sel [expr $num_entries - 1]
				}
			}
		}
	}

	# Reset list box by deleting all entires
	$lb delete 0 end

	# Add all files in the new order
	if [info exists new] {
		for { set i 0 } { $i < $num_entries } { incr i } {
			set file $new($i)
			$lb insert end $file
		}
	}

	# Update the selection
	if [info exists new_sel] {
		$lb selection set $new_sel
	}
}

# ----------------------------------------------------------------
#
proc qflow::on_delete_button { lb } {
#
# Description:	Dialog Box to remove files to project
#
# ----------------------------------------------------------------

	foreach file_index [lsort -integer -decreasing [$lb curselection]] {
		$lb delete $file_index
	}
}

# ----------------------------------------------------------------
#
proc qflow::on_add_remove_file_dlg {} {
#
# Description:	Dialog Box to and and/or remove files to project
#
# ----------------------------------------------------------------

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return 
	}

	set new_file ""

	set dlg [Dialog .add_remove_dlg -parent .\
				-modal  local \
				-separator 1 \
				-title "Add/Remove HDL files to project" \
				-side bottom \
				-anchor c \
				-default 0 \
				-cancel 1 ]

	$dlg add -name ok
	$dlg add -name cancel

	set sub_frame_1 [frame $dlg.sub_frame_1 -borderwidth 1 -relief groove]
	set sw    [ScrolledWindow $sub_frame_1.sw]
	set lb    [listbox $sw.lb -height 8 -width 50 -highlightthickness 0 -selectmode extended]

	$sw setwidget $lb

	qflow::update_file_list $lb

	set file_new_frame_1 [LabelFrame $sub_frame_1.family_frame \
			-text "Current list of files:" -width 15 -font {helvetica 10}]
	pack $file_new_frame_1 -padx 7 -pady 7 -fill x

	pack $sw -fill both -expand yes
	pack $sub_frame_1 -padx 7 -pady 7

	set sub_frame_2 [frame $dlg.sub_frame_2 -borderwidth 1 -relief groove]
	set delete_button [Button $sub_frame_2.delete -text "Delete" \
			-command "qflow::on_delete_button $lb"]
	set add_button [Button $sub_frame_2.add -text "Add..." \
			-command "qflow::on_add_button $lb"]
	set down_button [Button $sub_frame_2.down -text "Down" \
			-command "qflow::on_updown_button $lb down"]
	set up_button [Button $sub_frame_2.up -text "Up" \
			-command "qflow::on_updown_button $lb up"]
	pack $add_button -side left
	pack $delete_button -side left
	pack $up_button -side left
	pack $down_button -side left
	pack $sub_frame_2 -padx 7 -pady 7

	set cancel	[ $dlg draw ]

	puts $new_file
	if { !$cancel } {
		# First delete all existing files
		set file_asgn_col [get_all_global_assignments -name SOURCE_FILE]
		foreach_in_collection file_asgn $file_asgn_col {
			# Get all assignments returns an array of subarrays
			# The subarrays format in this case is:
			# {} {SOURCE_FILE} {<file_name>}
			# Don't complain if we cannot remove it.
			set file [lindex $file_asgn 2]
			catch {set_global_assignment -name SOURCE_FILE $file -remove}
		}
		qflow::print_msg "List of Source Files:"
		set i 1
		foreach file_index [$lb get 0 end] {
			if { [catch {set_global_assignment -name SOURCE_FILE $file_index}] } {
				qflow::print_error "Unable to add $file_index"
			} else {
				qflow::print_msg "   $i : $file_index"
				incr i
			}
		}
		if { $i == 1 } {
			# No files exist
				qflow::print_msg "   <none>"
		}
		qflow::print_msg ""
		export_assignment_files
	}

	destroy $dlg

}

# ----------------------------------------------------------------
#
proc qflow::on_close_project {} {
#
# Description:	Close Project
#
# ----------------------------------------------------------------

	variable project_name

	if { [is_project_open] } {
		export_assignment_files
		_project_close
		qflow::print_msg "Closed project: $qflow::project_name"
	} else {
		qflow::print_error "No project is open"
	}
	
	# Make sure everything is disabled
	wm title . "$qflow::app_name"
	qflow::set_compiler_status disabled
		
}

# ----------------------------------------------------------------
#
proc qflow::on_open_prefer_dlg {} {
#
# Description:	Dialog Box to open user preferences
#
# ----------------------------------------------------------------

	variable default_editor
	variable use_default_editor
	variable buttons
	variable mainframe

	set editor $qflow::default_editor

	set dlg [Dialog .prefer_dlg -parent .\
				-modal  local \
				-separator 1 \
				-title "Options" \
				-side bottom \
				-anchor c \
				-default 0 \
				-cancel 1 ]

	$dlg add -name ok

	set frame [$dlg getframe]

	set default_frame [frame $dlg.defaut_frame -borderwidth 1 -relief groove -width 55]
	set editor_chk [checkbutton $default_frame.editor_chk -text "Use EDITOR environment variable:" -font {helvetica 10} -width 20 -anchor w \
                  -variable qflow::use_default_editor \
				  -width 55 \
                  -onvalue  1 -offvalue 0]
	set editor_box [Label $default_frame.editor_entry -text "Value: $editor" -width 60]
	if { [string match $editor "<none>"] } {
		$editor_chk configure -state disabled
		$editor_box configure -state disabled
	} else {
		$editor_chk configure -state normal
		$editor_box configure -state normal
	}


 	grid $editor_chk -padx 7 -pady 1 -sticky w
 	grid $editor_box -padx 7 -pady 1 -sticky w
	pack $default_frame -padx 9 -pady 6 -side top

	set no_dlg_chk [checkbutton $frame.no_dlg_chk \
				  -text "Notify with pop-up dialog box when compiler finishes" \
				  -font {helvetica 10} -width 20 -anchor w \
                  -variable qflow::show_dlg_at_end_of_process \
				  -width 55 \
                  -onvalue  1 -offvalue 0]

	pack $no_dlg_chk

	set location_chk [checkbutton $frame.location_chk \
				  -text "Show locations when displaying applicable messages" \
				  -font {helvetica 10} -width 20 -anchor w \
                  -variable qflow::show_locations \
				  -width 55 \
                  -onvalue  1 -offvalue 0]

	pack $location_chk

	pack $frame
	set res [$dlg draw]

	destroy $dlg

	if { !$qflow::use_default_editor } {
		$mainframe setmenustate default_editor_menu disabled
		$buttons(new) configure -state disabled
	} else {
		$mainframe setmenustate default_editor_menu normal
		$buttons(new) configure -state normal
	}
}

# ----------------------------------------------------------------
#
proc qflow::print_error { msg } {
#
# Description:	Display error in Log window
#				
#
# ----------------------------------------------------------------

	variable log_window

	$log_window insert end ">> Error: $msg\n" errortag

	$log_window yview moveto 10
}

# ----------------------------------------------------------------
#
proc qflow::print_warning { msg } {
#
# Description:	Display warning in Log window
#				
#
# ----------------------------------------------------------------

	variable log_window

	$log_window insert end ">> Warning: $msg\n" warningtag

	$log_window yview moveto 10
}

# ----------------------------------------------------------------
#
proc qflow::print_cmd { command } {
#
# Description:	Display command in log window and store in
#				log db
#				
#
# ----------------------------------------------------------------

	variable log_window

	$log_window insert end ">> $command\n" boldtag

	$log_window yview moveto 10
}

# ----------------------------------------------------------------
#
proc qflow::log_reader { pipe } {
#
# Description:	On fileevent (executable log), we add the log
#				message to the LOG window by evaluating the log
#				which represents a set of Tcl commands
#
# ----------------------------------------------------------------

	variable log_window
	global done_reading
	global old_line

	if { [eof $pipe] } {
		catch { close $pipe }
		set done_reading 1
		return
	}


	if { [gets $pipe line] < 0 } {
		return
	} else {
		
		# Because we are calling the EXE with --ipc_mode
		# we know the log represents a set of Tcl commands
		# so just evaluate them, so that the correct functions
		# (which are re-defined in this script) can be called
		if [catch {eval $line} result] {

			if [string compare $old_line ""] {
				append old_line " $line"
				if [catch {eval $old_line} result] {
					# Do nothing
				}
			} else {
				set old_line $line
			}
		} else {
			set old_line ""
		}
	}
}


##########Functions for Toolbar items########################################################################################

# ----------------------------------------------------------------
#
proc qflow::post_user_message {  tag str } {
#
# Description:	Initialize application LOG Window
#
# ----------------------------------------------------------------

	variable log_window

	if { [info exist log_window] } {
		# If the log window exist, use it
		$log_window insert end "$str\n" $tag
		$log_window yview moveto 10
	} else {

		switch $tag {
			errortag { post_message -type error "$str" }
			warningtag { post_message -type warning "$str" }
			boldtag { post_message -type info "$str" }
			infotag { post_message -type info "$str" }
			default { post_message -type info "$str" }
		}
	}
}

# ----------------------------------------------------------------
#
proc qflow::open_ascii_file { file_name } {
#
# Description:	Open an ASCII file with the user editor or
#		the message log if no editor is available
#
# ----------------------------------------------------------------

	variable project_name
	variable default_editor
	variable use_default_editor

	qflow::print_msg "Opening text file: $file_name"
	qflow::print_msg ""
	if [file exists $file_name] {
		if { $qflow::use_default_editor } {
			# Launch external editor
			qflow::print_msg "Calling: $qflow::default_editor $file_name"
			if [catch { exec $qflow::default_editor $file_name & } result] {
				qflow::print_error "Error: $result"
			}
			qflow::print_msg ""
		} else {
			if [catch {open $file_name r} ascii_file] {
				qflow::print_error "Error: Cannot open $file_name"
			} else {
				qflow::print_msg "File Name: $file_name"
				qflow::print_msg "------------------------------------------"
				qflow::print_msg ""

				# If no editor is specified, read and display in Log window
				while {([gets $ascii_file ascii_line] >= 0)} {

					qflow::post_user_message msgtag "$ascii_line"
				}	
				qflow::print_msg "------------------------------------------"
				qflow::print_msg ""
				close $ascii_file
			} 
		}
	} else {
		qflow::print_error "Error: Cannot find $file_name"
	}
}

# ----------------------------------------------------------------
#
proc qflow::open_rpt { tool } {
#
# Description:	Open RPT file for the given tool
#
# ----------------------------------------------------------------

	variable log_window
	variable project_name
	variable default_editor
	variable use_default_editor
		
	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	if [string equal $tool "neto"] {
		# neto was renamed to eda in V3.0
		set tool eda
	}

	if [string equal $tool "tan"] {
		if { $qflow::use_timequest } {
			set tool sta
		}
	}

	set rpt_file_name $project_name.${tool}.rpt

	qflow::open_ascii_file $rpt_file_name
}

# ----------------------------------------------------------------
#
proc qflow::print_msg { msg } {
#
# Description:	Display message in either log box (for GUI)
#				or using "puts" (for cmd)
#				
#				If cerr, also use puts to send to stderr
#
# ----------------------------------------------------------------

	variable log_window

	$log_window insert end ">> $msg\n" infotag

	$log_window yview moveto 10
}

###Progress Bar Dialog#############################
# ----------------------------------------------------------------
#
proc qflow::stop_compile { } {
#
# Description:	On fileevent (executable log), we add the log
#				message to the LOG window
#
# ----------------------------------------------------------------

	variable pids
	variable error_count
	global tcl_platform
	global quartus

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

#	qflow::print_msg "Killing PID = $qflow::pids"
	set qflow::error_count -1

	if { [string equal -nocase $tcl_platform(platform) "unix"] } {
		catch { exec kill $pids }
	} else {
		# Use Altera's own Kill EXE
		catch { exec [file join $quartus(binpath) killqw] $pids }
	}
	
	qflow::print_msg ""
	qflow::print_msg "Processed Stopped"
	qflow::print_msg ""

	# Enable all buttons after execution
	qflow::set_compiler_status waiting

}

############Functions for handling tool buttons###########################################################################

# ----------------------------------------------------------------
#
proc qflow::launch_tool { tool } {
#
# Description:	Figure out required arguments and call 
#				require stand-alone executable
#
# ----------------------------------------------------------------
	
	variable log_window
	global done_reading
	variable project_name
	variable pids
	variable error_count
	variable qflow_path

	set user_name [::back_end_process::get_user_name $tool]
	set exe_name [::back_end_process::get_exe_name $tool]
	set exe_args [back_end_process::get_exe_args $tool]
	set exe_post_args [back_end_process::get_exe_post_args $tool]

	#Reset error count before running EXE	
	set qflow::error_count 0

	#Disable all tools
	qflow::set_compiler_status running

	set done_reading 0

	set tool_command ""
	
	set tool_command "[file tail $exe_name] $exe_args $project_name$exe_post_args" 

    set qflow::_status   "$tool_command"
    set qflow::_prgindic 0
    $qflow::mainframe showstatusbar progression

	qflow::print_cmd $tool_command
	qflow::print_cmd ""

	qflow::toggle_rename_ipc_cmds

	update

	# We want to use --ipc_mode but we don't want to display this
	# so add it after the print_cmd
	set tool_command "$exe_name --ipc_mode $exe_args $project_name$exe_post_args" 

	set pipe [open "|$tool_command" r]
	set qflow::pids [pid $pipe]
#	qflow::print_msg "PID = $pids"
	fconfigure $pipe -blocking 0
	fileevent $pipe readable [list qflow::log_reader $pipe]

	vwait done_reading

	qflow::toggle_rename_ipc_cmds

	# Enable all buttons after execution
	qflow::set_compiler_status waiting

    set qflow::_status   "Done"
    set qflow::_prgindic 0
    $qflow::mainframe showstatusbar progression

	return $qflow::error_count
}

############Predefined flows#############################################

# ----------------------------------------------------------------
#
proc qflow::on_start_quartus_process { tool } {
#
# Description:	Starts quartus tool
#
# ----------------------------------------------------------------

	variable error_count
	variable project_name

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	if [string equal $tool tan] {
		if {$qflow::use_timequest} {
			set tool sta
		}
	}

	qflow::print_msg "Start quartus"
	set qflow::error_count 0

	qflow::launch_tool $tool

	qflow::on_process_finished [::back_end_process::get_user_name $tool]
}

# ----------------------------------------------------------------
#
proc qflow::on_process_finished { name } {
#
# Description:	Give DLG box indicating success/unsuccess
#
# ----------------------------------------------------------------

	variable show_dlg_at_end_of_process
	global error_count

	variable app_name

	if {$qflow::show_dlg_at_end_of_process} {

		if {$qflow::error_count == -1} {
			tk_messageBox -type ok -message "$name was stopped" -title "$qflow::app_name" -icon info
		} elseif {$qflow::error_count == 0} {
			tk_messageBox -type ok -message "$name was successful" -title "$qflow::app_name" -icon info
		} else {
			tk_messageBox -type ok -message "$name unsuccessful" -title "$qflow::app_name" -icon error
		}
	} else {
		qflow::print_msg ""
		if {$qflow::error_count == -1} {
			qflow::print_msg "$name was stopped"
		} elseif {$qflow::error_count == 0} {
			qflow::print_msg "$name was successful"
		} else {
			qflow::print_msg "$name unsuccessful"
		}
		qflow::print_msg "-------------------------------------------------------------------------"
	}
}	

# ----------------------------------------------------------------
#
proc qflow::on_open_quartus_gui { tool } {
#
# Description:	Open Quartus II Official GUI
#
# ----------------------------------------------------------------

	variable project_name

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	set exe_name [::back_end_process::get_exe_name $tool]
	eval exec $exe_name ${qflow::project_name} &
}	

# ----------------------------------------------------------------
#
proc qflow::on_start_tk_script { script } {
#
# Description:	Start a predefined tk script
#
# ----------------------------------------------------------------

	variable project_name

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	switch $script {
		dse {
			set exe_name [::back_end_process::get_exe_name sh]
			eval exec $exe_name --dse -project ${qflow::project_name} &
		}
		tanw {
			set exe_name [::back_end_process::get_exe_name tan]
			eval exec $exe_name -g ${qflow::project_name} &
		}
		qhelp {
			set exe_name [::back_end_process::get_exe_name sh]
			eval exec $exe_name --qhelp &
		}
	}
}	

#############################################################################
## Procedure: on_advance_map_opt_dlg
##
## Arguments: None
##		
## Description: Opens the option dialog box for advance Settings
##
#############################################################################
proc qflow::on_advance_map_opt_dlg { } {

	variable acf

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	# create options dialog box

	set dlg [Dialog .adv_synthesis_dlg 	-parent . \
					-modal local \
			        -separator 1 \
			        -title "Advanced Synthesis Settings" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]

	$dlg add -name ok
	$dlg add -name cancel

	set asgn_list {\
			{"Perform WYSIWYG primitive resynthesis" ADV_NETLIST_OPT_SYNTH_WYSIWYG_REMAP} \
			{"Perform gate-level register retiming" ADV_NETLIST_OPT_SYNTH_GATE_RETIME} \
			{"Auto RAM Replacement" AUTO_RAM_RECOGNITION} \
			{"Auto DSP Replacement" AUTO_DSP_RECOGNITION} \
			{"Auto Parallel Expanders" AUTO_PEXP} \
			{"Auto Shift Register Replacement" AUTO_SHIFT_REGISTER_RECOGNITION} \
			{"Remove Duplicate Registers" DUP_REG_EXTRACTION} \
			{"Remove Redundant Logic Cells" REMOVE_REDUNDANT_USER_CELLS} \
			{"Ignore LCELL Buffers" IGNORE_LCELL} \
			{"Power-Up Don't Care" ALLOW_POWER_UP_DONT_CARE} \
			{"NOT Gate Push-Back" NOT_GATE_PUSH_BACK} \
	}

	foreach asgn_pair $asgn_list {
		set asgn_name [lindex $asgn_pair 1]
		set qflow::acf($asgn_name) [get_global_assignment -name $asgn_name]
		if [string equal $qflow::acf($asgn_name) ""] {
			# If the value is not set, default to OFF
			set qflow::acf($asgn_name) OFF
		}
	}

	set sub_frame_2 [frame $dlg.sub_frame_2 -borderwidth 1 -relief groove -width 15]

	set i 0
	foreach asgn_pair $asgn_list {
		set asgn_user_name [lindex $asgn_pair 0]
		set asgn_name [lindex $asgn_pair 1]
		set chk [checkbutton $sub_frame_2.chk$i -text $asgn_user_name \
				-font {helvetica 10} -width 40 -anchor w \
                -variable qflow::acf($asgn_name) \
                -onvalue  ON -offvalue OFF]

		grid $chk -padx 7 -pady 4 -sticky w
		incr i
	}

	pack $sub_frame_2 -padx 9 -pady 16 -side top
		
	set cancel [ $dlg draw ]		

	if { !$cancel } {
		
		foreach asgn_pair $asgn_list {
			set asgn_name [lindex $asgn_pair 1]
			set_global_assignment -name $asgn_name $qflow::acf($asgn_name)
		}

		export_assignment_files
	}

	destroy $dlg
}

#############################################################################
## Procedure: open_map_opt_dlg
##
## Arguments: None
##		
## Description: Opens the option dialog box for 'Technology Mapper'
##
#############################################################################
proc qflow::open_map_opt_dlg { } {

	variable acf

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	# create options dialog box

	set dlg [Dialog .synthesis_dlg 	-parent . \
					-modal local \
			        -separator 1 \
			        -title "Family and Synthesis Settings" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]

	$dlg add -name ok
	$dlg add -name cancel
	$dlg add -name advance -text "Advanced..." -command "qflow::on_advance_map_opt_dlg"

	set qflow::acf(FAMILY) [get_global_assignment -name FAMILY]
	set qflow::acf(ROOT) [get_global_assignment -name ROOT]
	if { [string match $qflow::acf(ROOT) ""] } {
		# Default to Project Name
		set qflow::acf(ROOT) "|$qflow::project_name"
	}

	set sub_frame_1 [frame $dlg.sub_frame_1 -borderwidth 1 -relief groove]

	set label_frame_c0 [LabelFrame $sub_frame_1.family_frame -text "Device Family:" -width 23 -font {helvetica 10}]
	set combo_0 [ComboBox $label_frame_c0.combo_1 -text  $qflow::acf(FAMILY) \
					    -textvariable qflow::acf(FAMILY) \
						-values [get_family_list] \
						-helptext "Specifies the device family to use for compilation." \
						-width 20 \
						-height 12 \
						-font {helvetica 10} ]
	pack $combo_0 -padx 7 -pady 4

	set label_frame_e1 [LabelFrame $sub_frame_1.root_frame -text "Root Entity Name:" -width 23 -font {helvetica 10}]
	set entry_1 [Entry $label_frame_e1.entry_1 -text  $qflow::acf(ROOT) \
					    -textvariable qflow::acf(ROOT) \
						-helptext "Specifies the full hierarchichal path of the root entity." \
						-width 22 \
						-font {helvetica 10} ]
	pack $entry_1 -padx 7 -pady 4

	pack $label_frame_e1 -padx 7 -pady 4
	pack $label_frame_c0 -padx 7 -pady 4

	set asgn_list { \
			{"Optimization Technique:" OPTIMIZATION_TECHNIQUE_APEX20K "SPEED AREA" "Specifies whether to attempt to achieve maximum speed performance or minimum area usage during compilation."}\
			{"Verilog Version:" VERILOG_INPUT_VERSION "VERILOG_1995 VERILOG_2001" "Processes Verilog Design File(s) according to the Verilog 2001 or 1995 standard (IEEE Std 1364-2001 or 1364-1995)."} \
			{"VHDL Version:" VHDL_INPUT_VERSION "VHDL87 VHDL93" "Processes VHDL Design File(s) according to the VHDL 1987 or 1993 standard (IEEE Std 1076-1987 or 1076-1993)."}\
	}
	set family_group(OPTIMIZATION_TECHNIQUE_APEX20K) "OPTIMIZATION_TECHNIQUE_CYCLONE OPTIMIZATION_TECHNIQUE_YEAGER OPTIMIZATION_TECHNIQUE_MAX7000 OPTIMIZATION_TECHNIQUE_DALI OPTIMIZATION_TECHNIQUE_FLEX6K OPTIMIZATION_TECHNIQUE_FLEX10K"

	foreach asgn_pair $asgn_list {
		set asgn_name [lindex $asgn_pair 1]
		set qflow::acf($asgn_name) [get_global_assignment -name $asgn_name]
	}

	set i 0
	foreach asgn $asgn_list {

		set asgn_user_name [lindex $asgn 0]
		set asgn_name [lindex $asgn 1]
		set asgn_enums [lindex $asgn 2]
		set asgn_desc [lindex $asgn 3]

		set label_frame [LabelFrame $sub_frame_1.label_frame_$i -text $asgn_user_name -width 23 -font {helvetica 10} ]
		set combo [ComboBox $label_frame.combo_$i -text  $qflow::acf($asgn_name) \
					    -textvariable qflow::acf($asgn_name) \
						-height [llength $asgn_enums] \
						-values $asgn_enums \
						-helptext $asgn_desc \
						-width 20 \
						-font {helvetica 10} ]

		pack $combo -padx 7 -pady 4
		pack $label_frame -padx 7 -pady 4
		
		incr i
	}

	pack $sub_frame_1 -padx 9 -pady 2 
	
	set cancel [ $dlg draw ]		

	if { !$cancel } {
		
		# Need to remove blank spaces
		regsub -all {\s+} $qflow::acf(FAMILY) "" qflow::acf(FAMILY)

		set_global_assignment -name FAMILY $qflow::acf(FAMILY)

		if { [string match $qflow::acf(ROOT) ""] } {
			# Default to Project Name
			set qflow::acf(ROOT) "|$qflow::project_name"
		}
		set_global_assignment -name ROOT $qflow::acf(ROOT)

		foreach asgn_pair $asgn_list {
			set asgn_name [lindex $asgn_pair 1]
			if { ![string equal $qflow::acf($asgn_name) ""] } {
				set_global_assignment -name $asgn_name $qflow::acf($asgn_name)

				if [info exists family_group($asgn_name)] {
					foreach asgn_element $family_group($asgn_name) {
						catch {set_global_assignment -name $asgn_element $qflow::acf($asgn_name)}
					}
				}
			}
		}

		export_assignment_files
	}

	destroy $dlg
}

#############################################################################
## Procedure: on_advance_fit_opt_dlg
##
## Arguments: None
##		
## Description: Opens the option dialog box for advance fitting
##
#############################################################################
proc qflow::on_advance_fit_opt_dlg { } {

	variable acf

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	# create options dialog box

	set dlg [Dialog .adv_fitter_dlg 	-parent . \
					-modal local \
			        -separator 1 \
			        -title "Advanced Fitter Settings" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]

	$dlg add -name ok
	$dlg add -name cancel

	set asgn_list {\
			{"Fast Fit" FAST_FIT_COMPILATION} \
			{"One attempt Only" FIT_ONLY_ONE_ATTEMPT} \
	}

	foreach asgn_pair $asgn_list {
		set asgn_name [lindex $asgn_pair 1]
		set qflow::acf($asgn_name) [get_global_assignment -name $asgn_name]
		if [string equal $qflow::acf($asgn_name) ""] {
			# If the value is not set, default to OFF
			set qflow::acf($asgn_name) OFF
		}
	}

	set sub_frame_2 [frame $dlg.sub_frame_2 -borderwidth 1 -relief groove -width 15]

	set i 0
	foreach asgn_pair $asgn_list {
		set asgn_user_name [lindex $asgn_pair 0]
		set asgn_name [lindex $asgn_pair 1]
		set chk [checkbutton $sub_frame_2.chk$i -text $asgn_user_name \
				-font {helvetica 10} -width 50 -anchor w \
                -variable qflow::acf($asgn_name) \
                -onvalue  ON -offvalue OFF]

		grid $chk -padx 7 -pady 4 -sticky w
		incr i
	}

	pack $sub_frame_2 -padx 9 -pady 16 -side top
		
	set cancel [ $dlg draw ]		

	if { !$cancel } {
		
		foreach asgn_pair $asgn_list {
			set asgn_name [lindex $asgn_pair 1]
			set_global_assignment -name $asgn_name $qflow::acf($asgn_name)
		}

		export_assignment_files
	}

	destroy $dlg
}

#############################################################################
## Procedure: open_fit_opt_dlg
##
## Arguments: None
##		
## Description: Opens the option dialog box for 'Fitter'
##
#############################################################################
proc qflow::open_fit_opt_dlg { } {

	variable acf

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	# create options dialog box

	set dlg [Dialog .fitter_dlg 	-parent . \
					-modal local \
			        -separator 1 \
			        -title "Device and Fitter Settings" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]

	$dlg add -name ok
	$dlg add -name cancel
	$dlg add -name advance -text "Advanced..." -command "qflow::on_advance_fit_opt_dlg"

	set qflow::acf(DEVICE) [get_global_assignment -name DEVICE]
	set qflow::acf(FAMILY) [get_global_assignment -name FAMILY]

	set sub_frame_1 [frame $dlg.sub_frame_1 -borderwidth 1 -relief groove]

	set label_frame_c0 [LabelFrame $sub_frame_1.family_frame -text "Part Name:" -width 30 -font {helvetica 10}]
	set combo_0 [ComboBox $label_frame_c0.combo_1 -text  $qflow::acf(DEVICE) \
					    -textvariable qflow::acf(DEVICE) \
						-values "[get_part_list -family $qflow::acf(FAMILY)] AUTO" \
						-helptext "Specifies the part to use for compilation." \
						-width 28 \
						-height 12 \
						-font {helvetica 10} ]
	pack $combo_0 -padx 7 -pady 4

	pack $label_frame_c0 -padx 7 -pady 4

	set asgn_list { \
			{"Auto Packed Registers -- Stratix:" REGISTER_PACKING_NEW "OFF NORMAL MINIMIZE_AREA MINIMIZE_AREA_WITH_CHAINS" "Allows the Compiler to automatically implement pairs of logic functions in the same logic cell."}\
	}

	foreach asgn_pair $asgn_list {
		set asgn_name [lindex $asgn_pair 1]
		set qflow::acf($asgn_name) [get_global_assignment -name $asgn_name]
	}

	set i 0
	foreach asgn $asgn_list {

		set asgn_user_name [lindex $asgn 0]
		set asgn_name [lindex $asgn 1]
		set asgn_enums [lindex $asgn 2]
		set asgn_desc [lindex $asgn 3]

		set label_frame [LabelFrame $sub_frame_1.label_frame_$i -text $asgn_user_name -width 30 -font {helvetica 10} ]
		set combo [ComboBox $label_frame.combo_$i -text  $qflow::acf($asgn_name) \
					    -textvariable qflow::acf($asgn_name) \
						-height [expr [llength $asgn_enums] + 1] \
						-values $asgn_enums \
						-helptext $asgn_desc \
						-width 28 \
						-font {helvetica 10} ]

		pack $combo -padx 7 -pady 4
		pack $label_frame -padx 7 -pady 4
		
		incr i
	}

	pack $sub_frame_1 -padx 9 -pady 2 
	
	set cancel [ $dlg draw ]		

	if { !$cancel } {
		
		set_global_assignment -name DEVICE $qflow::acf(DEVICE)

		foreach asgn_pair $asgn_list {
			set asgn_name [lindex $asgn_pair 1]
			if { ![string equal $qflow::acf($asgn_name) ""] } {
				set_global_assignment -name $asgn_name $qflow::acf($asgn_name)
			}
		}

		export_assignment_files
	}

	destroy $dlg
}

#############################################################################
## Procedure: on_advance_tan_opt_dlg
##
## Arguments: None
##		
## Description: Opens the option dialog box for advance tan
##
#############################################################################
proc qflow::on_advance_tan_opt_dlg { } {

	variable acf

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	# create options dialog box

	set dlg [Dialog .adv_tan_dlg 	-parent . \
					-modal local \
			        -separator 1 \
			        -title "Advanced Timing Settings" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]

	$dlg add -name ok
	$dlg add -name cancel

	set asgn_list {\
			{"Use Fast Corner Delays" DO_MIN_TIMING} \
			{"Run Min Analysis" DO_MIN_ANALYSIS} \
	}

	foreach asgn_pair $asgn_list {
		set asgn_name [lindex $asgn_pair 1]
		set qflow::acf($asgn_name) [get_global_assignment -name $asgn_name]
		if [string equal $qflow::acf($asgn_name) ""] {
			# If the value is not set, default to OFF
			set qflow::acf($asgn_name) OFF
		}
	}

	set sub_frame_2 [frame $dlg.sub_frame_2 -borderwidth 1 -relief groove -width 15]

	set i 0
	foreach asgn_pair $asgn_list {
		set asgn_user_name [lindex $asgn_pair 0]
		set asgn_name [lindex $asgn_pair 1]
		set chk [checkbutton $sub_frame_2.chk$i -text $asgn_user_name \
				-font {helvetica 10} -width 30 -anchor w \
                -variable qflow::acf($asgn_name) \
                -onvalue  ON -offvalue OFF]

		grid $chk -padx 7 -pady 4 -sticky w
		incr i
	}

	pack $sub_frame_2 -padx 9 -pady 16 -side top
		
	set cancel [ $dlg draw ]		

	if { !$cancel } {
		
		foreach asgn_pair $asgn_list {
			set asgn_name [lindex $asgn_pair 1]
			set_global_assignment -name $asgn_name $qflow::acf($asgn_name)
		}

		export_assignment_files
	}

	destroy $dlg
}

#############################################################################
## Procedure: open_tan_opt_dlg
##
## Arguments: None
##		
## Description: Opens the option dialog box for 'Timing'
##
#############################################################################
proc qflow::open_tan_opt_dlg { } {

	variable acf

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	# create options dialog box

	set dlg [Dialog .tan_dlg 	-parent . \
					-modal local \
			        -separator 1 \
			        -title "Timing Settings" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]

	$dlg add -name ok
	$dlg add -name cancel
	$dlg add -name advance -text "Advanced..." -command "qflow::on_advance_tan_opt_dlg"

	set asgn_list { \
			{"fmax Requirement:" FMAX_REQUIREMENT "Specifies the minimum acceptable clock frequency."}\
			{"tsu Requirement:" TSU_REQUIREMENT "Specifies the maximum acceptable clock setup time for the input (data) pin."}\
			{"tco Requirement:" TCO_REQUIREMENT "Specifies the maximum acceptable clock to output delay to the output pin."}\
			{"tpd Requirement:" TPD_REQUIREMENT "Specifies the maximum acceptable input to non-registered output delay."}\
			{"th Requirement:" TH_REQUIREMENT "Specifies the maximum acceptable clock hold time for the input (data) pin."}\
			{"min tco Requirement:" MIN_TCO_REQUIREMENT "Specifies the minimum acceptable clock to output delay to the output pin."}\
			{"min tpd Requirement:" MIN_TPD_REQUIREMENT "Specifies the minimum acceptable input to non-registered output delay."}\
	}

	foreach asgn_pair $asgn_list {
		set asgn_name [lindex $asgn_pair 1]
		set qflow::acf($asgn_name) [get_global_assignment -name $asgn_name]
	}

	set sub_frame_1 [frame $dlg.sub_frame_1 -borderwidth 1 -relief groove]

	set i 0
	foreach asgn $asgn_list {

		set asgn_user_name [lindex $asgn 0]
		set asgn_name [lindex $asgn 1]
		set asgn_desc [lindex $asgn 2]

		set label_frame [LabelFrame $sub_frame_1.label_frame_$i -text $asgn_user_name -width 23 -font {helvetica 10} ]
		set entry [Entry $label_frame.entry_$i -text $qflow::acf($asgn_name) \
					    -textvariable qflow::acf($asgn_name) \
						-helptext $asgn_desc \
						-width 22 \
						-font {helvetica 10} ]

		pack $entry -padx 7 -pady 4
		pack $label_frame -padx 7 -pady 4
		
		incr i
	}

	pack $sub_frame_1 -padx 9 -pady 2 
	
	set cancel [ $dlg draw ]		

	if { !$cancel } {
		
		foreach asgn_pair $asgn_list {
			set asgn_name [lindex $asgn_pair 1]
			if { ![string equal $qflow::acf($asgn_name) ""] } {
				set_global_assignment -name $asgn_name $qflow::acf($asgn_name)
			}
		}

		export_assignment_files
	}

	destroy $dlg
}


#############################################################################
## Procedure: is_new_hc_flow_enable
##
## Arguments: None
##
## Description: Check whether the current design family support new hc flow
##
#############################################################################
proc qflow::is_new_hc_flow_enable { } {

    set is_enable 0

    set enable_new_hardcopy_flow [get_ini_var -name flow_enable_new_hardcopy_flow]

    if { [string equal -nocase $enable_new_hardcopy_flow on] ||
         [string equal -nocase $enable_new_hardcopy_flow true] ||
         [string equal -nocase $enable_new_hardcopy_flow 1] ||
         [string equal -nocase $enable_new_hardcopy_flow ""] } {

        if { [is_project_open]  } {
            set family [get_global_assignment -name FAMILY]
            set is_enable [test_family_trait_of -family $family -trait HAS_NEW_HC_FLOW_SUPPORT]
        }
    }

    return $is_enable
}



#############################################################################
## Procedure: open_cmp_opt_dlg
##
## Arguments: None
##
## Description: Opens the option dialog box for 'Full Compile'
##
#############################################################################
proc qflow::open_cmp_opt_dlg { } {

	variable acf

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	# create options dialog box

	set dlg [Dialog .cmp_dlg 	-parent . \
					-modal local \
			        -separator 1 \
			        -title "Compiler Settings" \
			        -side  bottom \
			        -anchor c  \
			        -default 0 \
					-cancel 1]

	$dlg add -name ok
	$dlg add -name cancel

    if { [qflow::is_new_hc_flow_enable] } {
    	set asgn_list { \
    			{"Use TimeQuest Timing Analyzer" USE_TIMEQUEST_TIMING_ANALYZER} \
    			{"Display entity name for node name" PROJECT_SHOW_ENTITY_NAME} \
    			{"Export version-compatible database" AUTO_EXPORT_VER_COMPATIBLE_DB} \
    	}
    } else {
    	set asgn_list { \
    			{"Disable assembler" FLOW_DISABLE_ASSEMBLER} \
    			{"Use TimeQuest Timing Analyzer" USE_TIMEQUEST_TIMING_ANALYZER} \
    			{"Display entity name for node name" PROJECT_SHOW_ENTITY_NAME} \
    			{"Export version-compatible database" AUTO_EXPORT_VER_COMPATIBLE_DB} \
    	}
    }

	foreach asgn_pair $asgn_list {
		set asgn_name [lindex $asgn_pair 1]
		set qflow::acf($asgn_name) [get_global_assignment -name $asgn_name]
		if [string equal $qflow::acf($asgn_name) ""] {
			# If the value is not set, default to OFF
			set qflow::acf($asgn_name) OFF
		}
	}

	set sub_frame_2 [frame $dlg.sub_frame_2 -borderwidth 1 -relief groove -width 15]

	set i 0
	foreach asgn_pair $asgn_list {
		set asgn_user_name [lindex $asgn_pair 0]
		set asgn_name [lindex $asgn_pair 1]
		set chk [checkbutton $sub_frame_2.chk$i -text $asgn_user_name \
				-font {helvetica 10} -width 50 -anchor w \
                -variable qflow::acf($asgn_name) \
                -onvalue  ON -offvalue OFF]

		grid $chk -padx 7 -pady 4 -sticky w
		incr i
	}

	pack $sub_frame_2 -padx 9 -pady 16 -side top
		
	set cancel [ $dlg draw ]		

	if { !$cancel } {
		
		foreach asgn_pair $asgn_list {
			set asgn_name [lindex $asgn_pair 1]
			set_global_assignment -name $asgn_name $qflow::acf($asgn_name)
		}

		export_assignment_files

		if [string equal -nocase $qflow::acf(USE_TIMEQUEST_TIMING_ANALYZER) ON] {
			set qflow::use_timequest 1
		} else {
			set qflow::use_timequest 0
		}
	}

	destroy $dlg
}

#############################################################################
## Procedure: on_settings_dlg
##
## Arguments: None
##		
## Description: Opens dialog with buttons to other settings
##
#############################################################################
proc qflow::on_settings_dlg { } {

	variable qflow_path

	if { ![is_project_open] } {
		qflow::print_error "No project is open"
		return
	}

	qflow::open_map_opt_dlg
}

# ----------------------------------------------------------------
#
proc qflow::on_help {} {
#
# Description:	Display the readme
#				
#
# ----------------------------------------------------------------

	variable version
	variable app_name
	variable qflow_path

	set exit_help 0

	if [catch {open ${qflow_path}readme.txt r} ascii_file] {
		qflow::print_msg "No readme is available for this release"
	} else {

		toplevel .help
		wm title .help "$qflow::app_name Readme" 

		set fhelp [frame .help.message -borderwidth 5]
		text $fhelp.text -relief raised -yscrollcommand "$fhelp.scroll set" -height 40 -width 100 -font {Courier 10}
		scrollbar $fhelp.scroll -command "$fhelp.text yview"
		button $fhelp.exit -relief raised -text Exit -default active -command {set exit_help 1}
		pack $fhelp.exit -side bottom -fill x
		pack $fhelp.scroll -side right -fill y
		pack $fhelp.text -side left
		pack $fhelp -side top

		# If no editor is specified, read and display in Log window
		while {([gets $ascii_file ascii_line] >= 0)} {

			$fhelp.text  insert end "$ascii_line\n" infotag
		}	
		close $ascii_file

		vwait exit_help

		destroy .help
	}
}


# ----------------------------------------------------------------
#
proc qflow::about_dlg { } {
#
# Description:	"About" Dialog Box
#
# ----------------------------------------------------------------

	variable version
	variable app_name
	variable copyright

	set dlg [Dialog .about 	-parent . \
				-modal local \
		        -separator 1 \
                -title   "About QFlow" \
		        -side bottom    \
		        -anchor c \
		        -default 0]
	$dlg add -name ok

	set lab1  [Label $dlg.lab1 -text "$app_name $version"]
	set lab2  [Label $dlg.lab2 -text "$copyright"]
	pack $lab1 -pady 7 -padx 7 -anchor w
	pack $lab2 -pady 7 -padx 7 -anchor w

	$dlg draw
	destroy $dlg
}

# ----------------------------------------------------------------
#
proc _qflow_msg_tcl_internal_error { level msg_struct } {
#
# Description: Global function to process back end Tcl commands
#			generated by the --ipc_mode argument and evaluated
#			by the log reader
#
# ----------------------------------------------------------------
	
	append msg_line $msg_struct
			
	$qflow::log_window insert end "$msg_line\n" errortag
	incr qflow::error_count

	$qflow::log_window yview moveto 10000

}

# ----------------------------------------------------------------
#
proc _qflow_msg_tcl_post_message { level msg_struct } {
#
# Description: Global function to process back end Tcl commands
#			generated by the --ipc_mode argument and evaluated
#			by the log reader
#
# ----------------------------------------------------------------
	
	# The msg_struct's format is:
	# { <msg type string> <help id string> <arguments> <full message> \
	#		{ <submsg1> <submsg2> … } { <location1> <location2> } \
	#		<severity level> <message id> <raw message text> <suppress> \
	#		<suppress type> }
	# Each <submsg1> has a format just the same as above.

	# We only care about the msg type (Info, Warning, Error, etc.) ,
	# the message itself, and any submessages
	set msg_priority [lindex $msg_struct 0]

	set msg_line ""
	for {set i 0} { $i < $level} { incr i } {
		append msg_line "  "
	}
	append msg_line [lindex $msg_struct 3]

	set sub_messages [lindex $msg_struct 4]

	if { $qflow::show_locations } {
		# Extract File/Line information (i.e. Message Location)
		set locations [lindex $msg_struct 5]
		foreach location_struct $locations {
			set location_file [lindex $location_struct 0]
			set location_info [lindex $location_struct 2]
			# Only look for "Text" based locations (TDF, V, VHD, etc.)
			# Filter out all other locations
			set location_type [lindex $location_info 0]
			if [string equal $location_type "Text"] {
				set location_line [lindex $location_info 2]				
				# Append location information to the end
				append msg_line " (File: $location_file Line: $location_line)"
			}
		}
	}
			
	if [string equal "Error" $msg_priority] {
		$qflow::log_window insert end "$msg_line\n" errortag
		incr qflow::error_count
	} elseif [string equal "Warning" $msg_priority] {
		$qflow::log_window insert end "$msg_line\n" warningtag
	} elseif [string equal "Critical Warning" $msg_priority] {
		$qflow::log_window insert end "$msg_line\n" criticalwarningtag
	} elseif [string equal "Info:*" $msg_priority] {
		$qflow::log_window insert end "$msg_line\n" infotag
	} else {
		# Default to Info
		$qflow::log_window insert end "$msg_line\n" infotag
	}

	set next_level [expr $level + 1]
	foreach sub_msg $sub_messages {
		msg_tcl_post_message $next_level $sub_msg
	}

	$qflow::log_window yview moveto 10000

}

# ----------------------------------------------------------------
#
proc _qflow_report_status { percent } {
#
# Description: 
#
# ----------------------------------------------------------------
	
    if { $qflow::_prgindic < 100 } {
       set qflow::_prgindic $percent
       $qflow::mainframe showstatusbar progression
	}
}

# ----------------------------------------------------------------
#
proc _qflow_refresh_report { } {
#
# Description: 
#
# ----------------------------------------------------------------
	
#	qflow::print_msg "Refreshing ..."
	update
}


###########################################################
# proc qflow::toggle_rename_ipc_cmds {}
#
# Description:	Renames certain tcl commands in order to
#				support --ipc_mode and toggles between
#				original commands and qflow commands.
#				Toggling is required because ::quartus::flow
#				package requires the original commands.
#
# Returns:		1 if an error occurred
#				0 otherwise
#
###########################################################
proc qflow::toggle_rename_ipc_cmds {} {

	if {[string compare "" [info commands ::_qflow_msg_tcl_internal_error]] == 0} {
			# Use original command
		catch {rename ::msg_tcl_internal_error ::_qflow_msg_tcl_internal_error}
		catch {rename ::_msg_tcl_internal_error ::msg_tcl_internal_error}
	} else {
			# Use qflow command
		catch {rename ::msg_tcl_internal_error ::_msg_tcl_internal_error}
		catch {rename ::_qflow_msg_tcl_internal_error ::msg_tcl_internal_error}
	}

	if {[string compare "" [info commands ::_qflow_msg_tcl_post_message]] == 0} {
			# Use original command
		catch {rename ::msg_tcl_post_message ::_qflow_msg_tcl_post_message}
		catch {rename ::_msg_tcl_post_message ::msg_tcl_post_message}
	} else {
			# Use qflow command
		catch {rename ::msg_tcl_post_message ::_msg_tcl_post_message}
		catch {rename ::_qflow_msg_tcl_post_message ::msg_tcl_post_message}
	}

	if {[string compare "" [info commands ::_qflow_report_status]] == 0} {
			# Use original command
		catch {rename ::report_status ::_qflow_report_status}
		catch {rename ::_report_status ::report_status}
	} else {
			# Use qflow command
		catch {rename ::report_status ::_report_status}
		catch {rename ::_qflow_report_status ::report_status}
	}

	if {[string compare "" [info commands ::_qflow_refresh_report]] == 0} {
			# Use original command
		catch {rename ::refresh_report ::_qflow_refresh_report}
		catch {rename ::_refresh_report ::refresh_report}
	} else {
			# Use qflow command
		catch {rename ::refresh_report ::_refresh_report}
		catch {rename ::_qflow_refresh_report ::refresh_report}
	}
}

load_package project
load_package device

# Initialize TK library
init_tk

# Append BWidget directory in auto_path
package require BWidget

# Invoke main proc to start the application
qflow::main

#Set the display size and position of PMA window
set width 1015
set height 675
set x 0
set y 0
wm geom . ${width}x${height}+${x}+${y}

vwait exit_script



