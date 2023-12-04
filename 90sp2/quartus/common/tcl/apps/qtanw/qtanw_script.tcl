set pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

###################################################################################
#                                                                                 #
# File Name:    qtanw_script.tcl                                             	  #
#                                                                                 #
# Summary:      This TK script as a simple Graphical User Interface to timing     #
#               analyze a design                                                  #
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
#                                                                                 #
# Description:  This TK script can be used as a wrapper to the Timing Analyzer    #
#               The script allows you to set up the basic command-line arguments  #
#               and run each executable independently or as part of pre-defined   #
#               scripts.                                                          # 
#                                                                                 #
#               You can run this script from a command line by typing:            #
#                                                                                 #
#                     quartus_tan -g [<project_name>]                             #
#    or               quartus_tan --gui [<project_name>]                          #
#                                                                                 #
#                                                                                 #
###################################################################################


# Only qtanw exes can interpret this script
if [info exist quartus] {
	if { ![string equal $quartus(nameofexecutable) quartus_tan] } {
		set msg "QTANW should be invoked from the command line.\nUsage: quartus_tan -g \[<project_name>\]"
		puts $msg
		catch { tk_messageBox -type ok -message $msg -icon error }
		return
	}
} else {
	set msg "QTANW should be invoked using the Quartus II Shell.\nUsage: quartus_tan -g \[<project_name>\]"
	puts $msg
	catch { tk_messageBox -type ok -message $msg -icon error }
	exit -1
}

set argv0 [info script]
set argv1 [lindex $quartus(args) 0]

load_package project
load_package device
load_package advanced_timing


# Initialize TK library
init_tk

#############################################################################
## Libraries


# Set global variables and constants
# ----------------------------------

# List of supported Tools
set tool_list { tan }

# Tool EXE names
set exe_name(tan) quartus_tan
set exe_name(quartus) quartus

# Tool user names
set user_name(tan) "Timing Analyzer"
set user_name(quartus) "Quartus II"

# Tool buttons
set buttons(report_timing) ""
set buttons(quartus) ""
set buttons(create_netlist) ""
set buttons(stop) ""

set clock_filter "*"
set from "*"
set to "*"
set npaths "3"

set settings(verbose) 1
set settings(skip_dat) 1
set settings(post_map) 0
set settings(show_io_results) 0
set settings(min_delays) 0

set plugins [list]
set builtins [list]



######################################## Global Options Section #################################################

# ----------------------------------------------------------------
#
namespace eval qtanw {
#
# Description: Initialize all internal variables
#
# ----------------------------------------------------------------

	global quartus

	variable app_name   "QTAN Window"
	variable version    $quartus(version)
	variable copyright  $quartus(copyright)
	variable qtanw_path $quartus(tclpath)/apps/qtanw/

	variable mainframe
	variable summary_tree					# Top Left side panel's tree with summary
	variable toolbar_status 1
	variable flow_menu_exists 0
	variable progmsg
	variable progval 0
	
	# Font specification
	variable text_font {Courier 10}

	# Set the BWidget directory path.

	variable project_dir						# holds the path to project directory
	variable project_name						# holds the name of the project

	variable acf

	# Log qtanw commands

	# Maintain list of recent projects opened

	# Variables for holding settings

	variable flow_name						# stores the name of the flow

	variable default_editor "<none>"
	variable use_default_editor 0

	variable error_count 0
	variable clk_list

	# link the other qtanw scripts 

	# if Qtanw project settings file exists, then read the dlg settings from the file otherwise assign defaults

	set qtanw::flow_name "create_netlist"
	set qtanw::project_dir ""
	set qtanw::project_name "<none>"

	if [info exists env(EDITOR)] {
		set default_editor $env(EDITOR)
		set use_default_editor 1
	}
	
	# variables for storing the state of QTANW
	# to allow UI integration with cmdline
	variable compiler_status "disabled";			# current state of QTANW
	variable update_compiler_status 0 ;			# tells QTANW whether the compiler state needs to be updated after the execution of a cmdline command
}

namespace eval qtanw::log_window {
	variable index
}

# namespace in which to evaluate user cmds
namespace eval qtanw::user_namespace {
}

source [file join [file dirname [info script]] qtanw_api.tcl]
source [file join [file dirname [info script]] qtanw_node_finder.tcl]
source [file join [file dirname [info script]] qtanw_hist.tcl]


# ----------------------------------------------------------------
#
proc qtanw::main {} {
#
# Description: Entry point
#
# ----------------------------------------------------------------
	
	global quartus
	variable app_name

	option add *TitleFrame.l.font {helvetica 11 bold italic}
	option add *LabelFrame.l.font {helvetica 10}

	wm withdraw .
	wm title . "$app_name"

	qtanw_load_builtins
	qtanw_load_plugins

	qtanw::create_gui
	BWidget::place . 0 0 center
	wm deiconify .
	raise .
	focus -force .

	#Set the display size and position of PMA window
	set width 1015
	if { $quartus(ipc_mode) } {
		# Called from Quartus or not
		# No log window, so we don't want a tall window
		set height 300
	} else {
		set height 675
	}
	set x 0
	set y 0

	wm geom . ${width}x${height}+${x}+${y}

}

# ----------------------------------------------------------------
#
proc qtanw::create_gui { } {
#
# Description: Creates all the GUI elements
#
# ----------------------------------------------------------------

	# Create MainFrame and add Menus
	qtanw::init_mainframe_and_menus

	# Add tool bar buttons to the main frame
	qtanw::init_toolbar

	# Populate window panes
	qtanw::populate_tool_panes

	update idletasks

}

# ----------------------------------------------------------------
#
proc qtanw::close_qtanw { } {
#
# Description: Writes the project settings back to qtanw project file (qtanw_settings.txt)
#
# ----------------------------------------------------------------

	if { [is_project_open] } {
		export_assignment_files
		_project_close
	}
}	

###########################################################################
proc qtanw::modList { idx tree node } {
#
# modList toggles the folder image when the tree is opened or closed
#
###########################################################################

	$tree itemconfigure $node \
	    -image [Bitmap::get [lindex {folder openfold} $idx]]
}

###########################################################################
#
proc qtanw::toggleFolders { tree node } {
#
# toggleFolders opens and closes folders in the tree view in response
# to double-clicks
#
###########################################################################


    set parent [$tree parent $node]
    if {![string equal -nocase $parent root]} {
		return
    }

    set isopen [$tree itemcget $node -open]
    $tree itemconfigure $node -open [lindex { 1 0 } $isopen ]
    $tree itemconfigure $node -image [ Bitmap::get [lindex { openfold folder } $isopen ] ]
}

#############################################################################
##
proc qtanw::on_get_details { tree node } {
##
## Arguments: None
##		
## Description: Opens dialog with buttons to other settings
##
#############################################################################

	global from to npaths
	variable qtanw_path

    $tree selection set $node
    update
	set selection [$tree itemcget $node -text]
	set parent [$tree parent $node]

	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
		return
	}

	qtanw::print_msg "Selection: $parent $selection"
	if { [string match "clock*" $parent] } {
		set type $parent
		set clock_filter $selection
		qtanw::eval_cmd "report_timing_clocks::do_report_timing $type * $clock_filter $from $to $npaths"
	} elseif { [string match "io*" $parent] } {
		set type $selection
		set clock_filter "*"
		qtanw::eval_cmd "report_timing_clocks::do_report_timing $type * $clock_filter $from $to $npaths"
	} else {
		# Do nothing
		qtanw::print_msg "Do nothing"
	}
}

# ----------------------------------------------------------------
#
proc qtanw_load_plugins { } {
#
# Description: Searches for plugins in the current, user, and
#              script home directories
#
#              Must be in the global namespace for the source to
#              work properly
#
# ----------------------------------------------------------------

	global env

	set plugin_path [list [pwd]]
	if [file exists "~"] { lappend plugin_path "~" }
	catch { lappend plugin_path [file join $env(HOMEDRIVE) $env(HOMEPATH)] }
	catch { lappend plugin_path $env(QTANW_PLUGIN_PATH) }
	lappend plugin_path [file dirname [info script]]

	foreach plugin_dir $plugin_path {
		puts "Looking for plugins in $plugin_dir"
		if {! [catch {set plugin_files [glob [file join $plugin_dir qtanw_plugin_*.tcl]]}]} {
			foreach plugin_file $plugin_files {
				puts "    Adding plugin $plugin_file"
				source $plugin_file
			}
		}
	}
}


# ----------------------------------------------------------------
#
proc qtanw_load_builtins { } {
#
# Description: Searches for builtin "plugins" in the
#              script home directories
#
#              Must be in the global namespace for the source to
#              work properly
#
# ----------------------------------------------------------------

	set builtin_dir [file dirname [info script]]

	if {! [catch {set builtin_files [glob [file join $builtin_dir qtanw_builtin_*.tcl]] }] } {
		foreach builtin_file $builtin_files {
			source $builtin_file
		}
	}
}

# ----------------------------------------------------------------
#
proc qtanw::install_builtin { name builtin } {
#
# Description: Register a builtin "plugin", which will create a menu
#              item to run the command, available after the netlist
#              is created.
#
# ----------------------------------------------------------------
	global builtins
	set command qtanw::eval_cmd
	append command " $builtin"
	lappend builtins [list command "$name ..." [list create_netlist_menu ] $name {} -command $command ]
}


# ----------------------------------------------------------------
#
proc qtanw::init_mainframe_and_menus { } {
#
# Description: Initialize all the menus
#
# ----------------------------------------------------------------

	global settings

	variable mainframe
	variable version

	set file_menu {
		"&File" all file 0 {
			{command "Open P&roject..." {} "Opens a Project" {Ctrl O} -command "qtanw::eval_cmd qtanw::on_open_project_dlg" }
			{command "&Close Project" {project_open_menu} "Closes a Project" {} -command "qtanw::eval_cmd qtanw::on_close_project" }
			{separator}
			{command "&Open Text File..." {} "Open Text File" {} -command "qtanw::eval_cmd qtanw::on_open_file" }
			{separator}
			{command "Opt&ions..." {} "Sets user options" {} -command qtanw::on_open_prefer_dlg }
			{separator}
			{command "E&xit" {} "Exit qtanw" {Alt F4} -command exit }
		}
	}

	set settings_menu {
		"&Settings" all options 0 {
			{command "&Global Timing Constraints..." {project_open_menu} "Edit global timing settings" {} -command qtanw::open_tan_opt_dlg}
			{separator}
			{checkbutton "&Skip Delay Annotation" {} "Skip delay annotation when creating netlist" {} -variable settings(skip_dat) -command  {.mainframe showtoolbar toolbar $settings(skip_dat)}}
			{checkbutton "&Post Analysis and Synthesis" {} "Use post-map Netlist and estimated delays" {} -variable settings(post_map) -command  {.mainframe showtoolbar toolbar $settings(post_map)}}
			{checkbutton "Use &Fast Timing Models" {} "Use fast corner timing models when creating netlist" {} -variable settings(min_delays) -command  {.mainframe showtoolbar toolbar $settings(min_delays)}}
			{separator}
			{checkbutton "&Verbose reporting" {} "Show full path in report timing output" {} -variable settings(verbose) -command  {.mainframe showtoolbar toolbar $settings(verbose)}}
		}
	}
	
	set processing_menu [list \
		"&Processing" all file 0 [concat \
		{
			{command "&Create Netlist" {project_open_menu} "Create Timing Netlist" {Ctrl N} -command "qtanw::eval_cmd qtanw::on_create_netlist"}
			{separator}
		} \
		$::builtins \
		{
			{separator}
			{command "Open &Timing Analysis Report" {project_open_menu} "Open Timing Analysis Report" {Ctrl 3} -command "qtanw::eval_cmd \"qtanw::open_rpt tan\"" }
			{separator}
			{command "Open &Quartus II" {project_open_menu} "Opens Quartus II graphical user interface" {} -command "qtanw::on_open_quartus" }
		}
	]
	]

	set plugins_menu [list "&Plugins" all file 0 $::plugins]

	set help_menu {
		"&Help" all options 0 {
			{command "&Readme" {} "Show QTAN Window Readme" {} -command qtanw::on_help}
			{separator}
			{command "&About QTAN Window" {} "About QTAN Window" {} -command qtanw::about_dlg}
		}
	}

	set menu_desc [concat \
			$file_menu \
			$settings_menu \
			$processing_menu \
			$plugins_menu \
			$help_menu \
			]

	set status "Done"
	set mainframe [ MainFrame .mainframe \
			-height  600\
			-menu	$menu_desc \
			-textvariable status \
			-width 1000]

    $mainframe addindicator -text "$qtanw::version"

    pack $mainframe -fill both -expand yes

	if { !$qtanw::use_default_editor } {
		$mainframe setmenustate default_editor_menu disabled
	}

	#Make sure when the user destroys the application, the project settings are stored in qtanw project file
	bind $mainframe <Destroy> { qtanw::close_qtanw }
}

# ----------------------------------------------------------------
#
proc qtanw::init_toolbar { } {
#
# Description: Initializes the toolbar
#
# ----------------------------------------------------------------

	variable mainframe
	variable project_dir
	variable qtanw_path
	variable flow_name
	variable use_default_editor

	global buttons
	global tool_list
	global exe_name
	global user_name
	

	## Adding general toolbar

	set toolbar [$mainframe addtoolbar]
	set bbox [ButtonBox $toolbar.bbox -spacing 0 -padx 2 -pady 2]

	$bbox add -image [Bitmap::get ${qtanw::qtanw_path}/icons/open] \
        	-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
			-command "qtanw::eval_cmd qtanw::on_open_file" \
			-helptext "Open a Text File"

	pack $bbox -side left -anchor w

	set sep [Separator $toolbar.sep -orient vertical]
	pack $sep -side left -fill y -padx 4 -anchor w

	set bbox [ButtonBox $toolbar.bbox3 -spacing 0 -padx 2 -pady 2]
	set buttons(setting) [$bbox add -image [Bitmap::get ${qtanw::qtanw_path}/icons/ase] \
        			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
					-command qtanw::on_settings_dlg \
			        -helptext "Edit Settings"]
	pack $bbox -side left -anchor w

	set sep [Separator $toolbar.sep5 -orient vertical]
	pack $sep -side left -fill y -padx 4 -anchor w

	set bbox [ButtonBox $toolbar.bbox4 -spacing 0 -padx 2 -pady 2]

	set buttons(create_netlist) [$bbox add -image [Bitmap::get ${qtanw::qtanw_path}/icons/tan_start] \
        			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
					-command "qtanw::eval_cmd qtanw::on_create_netlist" \
					-helptext "Create Timing Netlist"]
	pack $bbox -side left -anchor w

	set buttons(quartus) [$bbox add -image [Bitmap::get ${qtanw::qtanw_path}/icons/pjm] \
			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 1 -pady 1 \
			-command "qtanw::on_open_quartus" \
			-helptext "Open $user_name(quartus)"]
	pack $bbox -side left -anchor w

	set sep [Separator $toolbar.sep3 -orient vertical]
	pack $sep -side left -fill y -padx 4 -anchor w

	set bbox [ButtonBox $toolbar.bbox2 -spacing 0 -padx 2 -pady 2]
	foreach tool $tool_list {
		set icon_file ${qtanw::qtanw_path}/icons/${tool}
		set buttons(${tool}_rpt) [$bbox add -image [Bitmap::get $icon_file] \
        			-highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 \
					-command "qtanw::eval_cmd \"qtanw::open_rpt $tool\"" \
					-helptext "Open $user_name($tool) Report"]
		pack $bbox -side left -anchor w
	}

	set sep [Separator $toolbar.sep2 -orient vertical]
	pack $sep -side left -fill y -padx 4 -anchor w

	#Disable the buttons if no project is opened
	if { $qtanw::project_dir == "" } { 
		qtanw::set_compiler_status disabled
	}
}

# ----------------------------------------------------------------
#
proc qtanw::populate_tool_panes { } {
#
# Description: Populate the tool pane with the buttons and Message Window
#
# ----------------------------------------------------------------

	variable mainframe
	variable text_font
	variable summary_tree

	# Create a Paned window
	set pane_window_frame [$mainframe getframe]
	set mainpane [PanedWindow $pane_window_frame.mp -side left]

	# Adds and splits the top pane
	set tp [PanedWindow [$mainpane add -weight 2].mp -side top]
	
	#Create Log Window for displaying messages
	# Adds the left (info) pane
	set ip [$tp add -weight 1]
	set i_title [TitleFrame $ip.dt -text "Clock Analysis"]
	set sw [ScrolledWindow [$i_title getframe].sw -auto both]
	set qtanw::summary_tree [Tree $sw.tree -relief sunken -showlines true \
		-redraw 1 -background white \
		-opencmd "qtanw::modList 1 $sw.tree" \
		-closecmd "qtanw::modList 0 $sw.tree" \
	       ]
	$sw setwidget $qtanw::summary_tree
	pack $ip $i_title $sw $qtanw::summary_tree -fill both -expand yes

	# Adds the right (detail) pane
#	set dp [$tp add -weight 2]
#	set d_title [TitleFrame $dp.dt -text "Timing Results"]
#	set sw [ScrolledWindow [$d_title getframe].sw -auto both]
#	set d_list [ListBox $sw.ht -selectmode single -multicolumn 0 \
#		-padx 2 -background white\
#		-font $text_font]
#	$sw setwidget $d_list
#	pack $sw $dp $d_title $d_list -fill both -expand yes

	#Create Log Window for displaying messages
	qtanw::init_log_window $mainpane

	#Pack Paned Window
	pack $tp -fill both -expand yes
	pack $mainpane -fill both -expand yes
}	

# ----------------------------------------------------------------
#
proc qtanw::init_summary_tree_control { } {
#
# Description:	Initialize application's tree control
#
# ----------------------------------------------------------------

	global settings
	variable text_font
	variable summary_tree

	catch {set clk_setup_folder [$qtanw::summary_tree insert end root "clock_setup" -text "Clock Setup" \
		-image [Bitmap::get folder] -open 0 -drawcross auto -font $text_font]}

	catch {set clk_hold_folder [$qtanw::summary_tree insert end root "clock_hold" -text "Clock Hold" \
		-image [Bitmap::get folder] -open 0 -drawcross auto -font $text_font]}

	set clock_list [get_timing_nodes -type clk]
	foreach_in_collection clk_id $clock_list {
		set clk_name [get_timing_node_info -info name $clk_id]
		catch {$qtanw::summary_tree insert end $clk_setup_folder clk_setup:$clk_id -text $clk_name -image [Bitmap::get file] \
			-drawcross never -font $text_font}
		catch {$qtanw::summary_tree insert end $clk_hold_folder clk_hold:$clk_id -text $clk_name -image [Bitmap::get file] \
			-drawcross never -font $text_font}
	}

	if { $settings(show_io_results) } {
		catch {set io_folder [$qtanw::summary_tree insert end root io_results -text "I/O Timing Results" \
			-image [Bitmap::get folder] -open 0 -drawcross auto -font $text_font]}

		set count 0
		foreach c {tsu tco tpd} {
			catch {$qtanw::summary_tree insert end $io_folder t:$count -text $c -image [Bitmap::get file] \
				-drawcross never -font $text_font}
			incr count
		}

		foreach c {th min_tco min_tpd} {
			catch {$qtanw::summary_tree insert end $io_folder t:$count -text $c -image [Bitmap::get file] \
				-drawcross never -font $text_font}
			incr count
		}
	}

	$qtanw::summary_tree bindText <Button-1> "qtanw::on_get_details $qtanw::summary_tree"
	$qtanw::summary_tree bindText <Double-1> "qtanw::toggleFolders $qtanw::summary_tree"

}

# ----------------------------------------------------------------
#
proc qtanw::post_user_message {  tag str } {
#
# Description:	Initialize application LOG Window
#
# ----------------------------------------------------------------

	global quartus
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
proc qtanw::init_log_window { log_pane } {
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
	variable default_editor

	# Font specification
	variable text_font

	# Add and populate the dp Pane
	if { !$quartus(ipc_mode) } {
		# Only create a log window if not called within Quartus (i.e. through flow)
		
		set dp [$log_pane add -weight 1]
		set dp_title   [TitleFrame $dp.ht -text "Console Window"]
		set sw [ScrolledWindow [$dp_title getframe].sw -auto both]
		set log_window [text $sw.log_window -setgrid false -fg black -font $text_font  \
						   -width 80 -yscrollcommand "$sw.y_scroll set"]
		$sw setwidget $log_window
		pack $sw $dp $dp_title $log_window -fill both -expand yes

		# Creating tags to control display of message like color, font, size etc.
		$log_window tag configure boldtag -font {Courier 10 bold}
		$log_window tag configure errortag -foreground red -font {Courier 10 bold}
		$log_window tag configure warningtag -foreground blue -font  {Courier 10 bold}
		$log_window tag configure infotag -foreground darkgreen -font  {Courier 10 bold}
		$log_window tag configure msgtag -font {Courier 10}
		$log_window tag configure prompttag -foreground blue -font {Courier 10}
		$log_window tag configure usertag -font {Courier 10 bold}

	}

	qtanw::rename_cmds
	qtanw::print_msg "---------------------------------------------------------------------------------------"
	qtanw::print_msg ""
	if { [string match $qtanw::default_editor "<none>"] } {
		qtanw::print_warning "Default text editor has not been specified."
		qtanw::print_warning "Text files will be displayed (read-only) in the Message Log Window."
		qtanw::print_warning "To open and edit text files, set the EDITOR environment variable to a text editor executable"
	} else {
		qtanw::print_msg "Found environment variable EDITOR=$qtanw::default_editor"
		qtanw::print_msg "Text files will be opened using $qtanw::default_editor <file_name>"
	}
	qtanw::print_msg ""
	qtanw::print_msg ""
	qtanw::print_msg "---------------------------------------------------------------------------------------"
	qtanw::print_msg ""

	# If we got an argument, assume it is the project_name
	set argc [llength $quartus(args)]
	if { $argc == 0 } {
		set qtanw::project_name "<none>"
	} else {
		if { $argc == 1 } {
			set qtanw::project_name [lindex $quartus(args) 0] 
			if { [project_exists $qtanw::project_name] } {
				qtanw::open_project
			} else {
				qtanw::print_error "Project $qtanw::project_name does not exist"
			}
		}
	}
	
	if { !$quartus(ipc_mode) } {
		qtanw::log_window::print_prompt
		qtanw::log_window::enable_cmdline
	}
}

##################### LOG WINDOW FUNCTIONS ########################
proc qtanw::log_window::print_prompt { } {
	global quartus
	if { $quartus(ipc_mode) } {
		return 1
	}
	
	$qtanw::log_window insert end "tcl> " prompttag
	set qtanw::log_window::index [$qtanw::log_window index "end -1 lines lineend"]
	$qtanw::log_window see end
}



###########################################################
# proc qtanw::log_window::enable_cmdline {}
#
# Description:	enables user input into the log_window for
#				commands
#
# Returns:		1 if in ipc_mode and does nothing
#
###########################################################
proc qtanw::log_window::enable_cmdline {} {
	
	global quartus
	if { $quartus(ipc_mode) } {
		return 1
	}
	
	bind $qtanw::log_window <KeyPress> {
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
        		set index [expr [$qtanw::log_window index end]-1]
	        	regexp "(?:tcl> )*(.*)" [$qtanw::log_window get $index end] match command
	        	$qtanw::log_window insert end "\n"

	        	qtanw::eval_cmd $command				
				break
       		}

       		"BackSpace" {
        		qtanw::log_window::move_cursor
        		if  [$qtanw::log_window compare [$qtanw::log_window index insert] <= $qtanw::log_window::index] {
	        		break
        		}
			}
			
			"c" -
        	"C" {
            	if {(%s & 0x04) == 0} {
                	qtanw::log_window::move_cursor
    				$qtanw::log_window tag add usertag [$qtanw::log_window index "insert -1 chars"] end
            	}
        	}

       		default {
				qtanw::log_window::move_cursor
    			$qtanw::log_window tag add usertag [$qtanw::log_window index "insert -1 chars"] end
			}
   		}
}
}


###########################################################
# proc qtanw::log_window::disable_cmdline {}
#
# Description:	disables user input into the log_window for
#				commands
#
###########################################################
proc qtanw::log_window::disable_cmdline {} {
	global quartus
	if { $quartus(ipc_mode) } {
		return 1
	}
	
	bind $qtanw::log_window <KeyPress> {
		break
	}
}


###########################################################
# proc qtanw::log_window::move_cursor{}
# 
# Description:  If the cursor is not on the editable portion
#				of the log window (i.e. the last line), then
#				moves the cursor to the end of the line
#				in the log window for inserting new text
#
#
###########################################################
proc qtanw::log_window::move_cursor {} {
	if  [$qtanw::log_window compare [$qtanw::log_window index insert] < $qtanw::log_window::index] {
		event generate $qtanw::log_window <Control-Key-End>
	}
}


###########################################################
# proc qtanw::eval_cmd { command }
# 
# Description:  evaluates a command in the namespace reserved
#				for the user tcl shell and posts the appropriate
#				return messages to the log window
#
# Returns:		1 if an error occurred
#				0 otherwise
#
###########################################################
proc qtanw::eval_cmd { command } {
	
	global quartus
	if { $quartus(ipc_mode) } {
		return [eval $command]
	}
	
	variable compiler_status
	variable update_compiler_status
	
	# store the current state of QTANW into a temp variable
	set prev_state $compiler_status
	
	# now disable cmdline and user interface
	qtanw::log_window::disable_cmdline
	qtanw::set_compiler_status disabled
	set update_compiler_status 1

	if [catch {namespace inscope user_namespace eval $command} result] {
		$qtanw::log_window insert end "$result\n" errortag
	} else {
		$qtanw::log_window insert end "$result\n" infotag
	}

	# enable the cmdline	
	qtanw::log_window::print_prompt
	qtanw::log_window::enable_cmdline
	
	# if QTANW state has not been updated, update it
	if {$update_compiler_status} {
		qtanw::set_compiler_status $prev_state
	}
	return $result
}


##########################################################
# proc qtanw::on_qtanw_cmd { command }
#
# Description:  the interface to run all UI commands as
#				well as QTANW cmdline commands; synchronizes
#				the two together to update the UI when
#				commandline executes and vice versa
#
# Returns:		-1 if not a qtanw command
#				
##########################################################

proc qtanw::on_qtanw_cmd { command } {
	
	## Determine first if the command is a QTANW command
	 # if not, return -1
	switch -- [lindex $command 0] {
		"project_open" {
			set qtanw::project_name [lindex $command 1]
			set command qtanw::open_project
		}
		"project_close" {set command qtanw::on_close_project }
		"create_timing_netlist" {set command "qtanw::on_create_netlist [lrange $command 1 end]"}
		"delete_timing_netlist" {set command _delete_timing_netlist}
		
		default { return -1 }
	}
	$qtanw::log_window insert end "\n"
	
	# Run the appropriate set of commands
	if [catch {eval $command} result] {
		return -code error $result
	} else {
		if {[string match $command "_delete_timing_netlist"]} {
			set clk_list ""
			qtanw::set_compiler_status no_netlist
		}
	}
}


###########################################################
# proc qtanw::rename_cmds {}
#
# Description:	renames certain tcl and QTANW commands to
#				allow us to handle them better through
#				other functions that act as wrappers that
#				call the originals
#
# Returns:		1 if an error occurred
#				0 otherwise
#
###########################################################
proc qtanw::rename_cmds {} {
	global quartus
	
	if {!$quartus(ipc_mode)} {
		rename ::puts ::puts.orig
		rename ::_qtanw_puts ::puts
		rename ::unknown ::unknown.orig
		rename ::_qtanw_unknown ::unknown
	}
	
	rename project_open _project_open
	rename project_close _project_close
	rename create_timing_netlist _create_timing_netlist
	rename delete_timing_netlist _delete_timing_netlist
}


############### Custom TCL functions ############################

###############################################
# proc _qtanw_puts { args }
#
# Description:	Custom puts function
#
###############################################
proc _qtanw_puts { args } {
	if {[llength $args] == 1} {
		$qtanw::log_window insert end "[lindex $args 0]\n" infotag
	} else {
		if {[llength $args] == 2 && [string equal [lindex $args 0] "stdout"]} {
			$qtanw::log_window insert end [lindex $args 1] infotag
		} else {
			eval puts.orig $args
		}
	}
}

################################################
# proc _qtanw_unknown args {
#
# Description:	Custom unknown function
#
################################################
proc _qtanw_unknown args {
	global auto_noexec
	global errorCode errorInfo

	## call the original unknown function
	 # use eval to allow passing of arbitrary # of args
	set cmd_not_found [catch {eval unknown.orig $args} result]
	if {!$cmd_not_found} {
		return $result
	}

	## Examine if the command is a QTANW command
	 # and execute as necessary
	set return_value [qtanw::on_qtanw_cmd $args]
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
proc qtanw::open_project { } {
#
# Description:	Open Project
#
# ----------------------------------------------------------------

	variable app_name

	set revision [get_current_revision $qtanw::project_name]
	qtanw::print_cmd "project_open $qtanw::project_name -revision $revision"
	_project_open $qtanw::project_name -revision $revision
	wm title . "$qtanw::app_name - $qtanw::project_name"

	qtanw::print_msg "-> DONE"

	# Enable all tool buttons and flow button after a Project is Selected
	qtanw::set_compiler_status no_netlist
}

# ----------------------------------------------------------------
#
proc qtanw::on_open_project_dlg {} {
#
# Description:	Dialog Box to open project
#
# ----------------------------------------------------------------

	variable project_dir
	variable project_name
	variable app_name

	set typelist {
		{"Project Files" {".qpf" ".qsf"}}
		{"Design Files" {".v" ".vhd" ".vhdl"}}
		{"All Files" {"*.*"}}
	}

	if { [is_project_open] } {
		set dlg_result [tk_messageBox -type yesno -message "Project is already open. OK to close first?" -title "$qtanw::app_name" -icon question]
		if { [string match $dlg_result "yes"] } {
			qtanw::on_close_project
		} else {
			# Exit without showing open DLG
			return
		}
	}

	set project_file_name [tk_getOpenFile -filetypes $typelist -title "Open a Project"]
	if { $project_file_name == "" } {
		qtanw::print_msg "No project was open"
		qtanw::on_close_project
	} else {
		set qtanw::project_dir [file dirname $project_file_name]
		cd $qtanw::project_dir
		set qtanw::project_name [file rootname [file tail $project_file_name]]
		# Display files in tree structure in left window pane in files tab
	
		# Open/Create Project
		if { ![project_exists $qtanw::project_name] } {
			qtanw::print_error "Project $qtanw::app_name does not exist"
				
			# Exit without showing open DLG
			return
		}

		qtanw::open_project
	}
}

# ----------------------------------------------------------------
#
proc qtanw::on_open_file {} {
#
# Description:	Dialog Box to open a text file
#
# ----------------------------------------------------------------


	set typelist {
		{"Ascii Files" {".txt" ".rpt" ".tao"}}
		{"Design Files" {".v" ".vhd" ".vhdl"}}
		{"Project Files" {".qpf" ".qsf"}}
		{"All Files" {"*.*"}}
	}

	set file_name [tk_getOpenFile -filetypes $typelist -title "Open"]
	if { $file_name == "" } {
	} else {
		qtanw::open_ascii_file $file_name
	}
}

# ----------------------------------------------------------------
#
proc qtanw::on_close_project {} {
#
# Description:	Close Project
#
# ----------------------------------------------------------------

	variable project_name
	variable summary_tree

	if { [is_project_open] } {
		if {![catch {_delete_timing_netlist} result]} {
			qtanw::print_cmd "delete_timing_netlist"
		}
		$qtanw::summary_tree delete [$qtanw::summary_tree nodes root]
		qtanw::print_cmd "project_close"
		export_assignment_files
		_project_close

	} else {
		qtanw::print_error "No project is open"
	}
	
	# Make sure everything is disabled
	wm title . "$qtanw::app_name"
	qtanw::set_compiler_status disabled
		
}

# ----------------------------------------------------------------
#
proc qtanw::on_open_prefer_dlg {} {
#
# Description:	Dialog Box to open user preferences
#
# ----------------------------------------------------------------

	variable default_editor
	variable use_default_editor
	global buttons
	global settings
	variable mainframe

	set editor $qtanw::default_editor

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
                  -variable qtanw::use_default_editor \
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

	set io_result_chk [checkbutton $default_frame.io_result_chk -text "Show I/O results" -font {helvetica 10} -width 20 -anchor w \
                  -variable settings(show_io_results) \
				  -width 55 \
                  -onvalue  1 -offvalue 0]

 	grid $editor_chk -padx 7 -pady 1 -sticky w
 	grid $editor_box -padx 7 -pady 1 -sticky w
 	grid $io_result_chk -padx 7 -pady 1 -sticky w
	pack $default_frame -padx 9 -pady 6 -side top

	pack $frame
	set res [$dlg draw]

	destroy $dlg

	if { !$qtanw::use_default_editor } {
		$mainframe setmenustate default_editor_menu disabled
	} else {
		$mainframe setmenustate default_editor_menu normal
	}
}


# ----------------------------------------------------------------
#
proc qtanw::log_reader { pipe } {
#
# Description:	On fileevent (executable log), we add the log
#				message to the LOG window
#
# ----------------------------------------------------------------

	global done_reading
	variable error_count

	if { [eof $pipe] } {
		catch { close $pipe }
		set done_reading 1
		return
	}


	if { [gets $pipe line] < 0 } {
		return
	} else {
		set not_done 1
#		while { $not_done } {
			if [string match "Error:*" $line] {
				qtanw::post_user_message errortag "$line"
				incr qtanw::error_count
			} elseif [string match "Internal Error:*" $line] {
				qtanw::post_user_message errortag "$line"
				incr qtanw::error_count
			} elseif [string match "Warning:*" $line] {
				qtanw::post_user_message warningtag "$line"
			} elseif [string match "Info:*" $line] {
				qtanw::post_user_message infotag "$line"
			} else {
				# Default to Info
				qtanw::post_user_message msgtag "$line"
			}
#			set not_done [expr [gets $pipe line] > 0]
#		}		
	}
#	update
}


##########Functions for Toolbar items########################################################################################


# ----------------------------------------------------------------
#
proc qtanw::open_rpt { tool } {
#
# Description:	Open RPT file for the given tool
#
# ----------------------------------------------------------------

	variable project_name
	variable default_editor
	variable use_default_editor
		
	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
		return
	}

	set rpt_file_name $project_name.${tool}.rpt

	qtanw::open_ascii_file $rpt_file_name
}


############Predefined flows#############################################

# ----------------------------------------------------------------
#
proc qtanw::on_start_quartus { tool } {
#
# Description:	Starts quartus tool
#
# ----------------------------------------------------------------

	global user_name
	variable error_count
	variable project_name

	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
		return
	}

	qtanw::print_msg "Start quartus"
	set qtanw::error_count 0

	qtanw::launch_tool $tool

	qtanw::on_process_finished $user_name($tool)
}

# ----------------------------------------------------------------
#
proc qtanw::on_create_netlist { args } {
#
# Description:	Build TDB
#
# ----------------------------------------------------------------

	global settings
	variable clk_list

	set command "_create_timing_netlist"
	if {$args == ""} {
		#If no arguments specified, will take settings
		# specified in the menu
		if { $settings(skip_dat) } {
			append command " -skip_dat"
		}

		if { $settings(post_map) } {
			append command " -post_map"
		}

		if { $settings(min_delays) } {
			append command " -min"
		}
		
		if {![catch {_delete_timing_netlist} result]} {
			qtanw::print_cmd "delete_timing_netlist"
		}

		qtanw::print_cmd [string range $command 1 end]
	} else {
		#If called from cmdline with arguments
		lappend command $args
		if {![catch {_delete_timing_netlist} result]} {
			qtanw::print_cmd "delete_timing_netlist"
		}
	}
		
	qtanw::set_compiler_status disabled

	qtanw::print_msg "This command can take several minutes"

	set netlist_ok 1
	update

	if {[catch {eval $command} result]} {
		#qtanw::print_error "Create Netlist failed. Compiler Netlist not found or incomplete"
		#qtanw::print_error "--> Try without the \"Skip Delay Annotation\" option (\"Settings\" Menu)"
		qtanw::print_error $result
		set netlist_ok 0
	}

	if { $netlist_ok } {
		set clk_list [qtanw::create_clk_list]
		qtanw::init_summary_tree_control
		qtanw::set_compiler_status waiting
	} else {
		set clk_list ""
		qtanw::set_compiler_status no_netlist
	}

	qtanw::print_msg "-> DONE"
	update
}

# ----------------------------------------------------------------
#
proc qtanw::on_process_finished { name } {
#
# Description:	Give DLG box indicating success/unsuccess
#
# ----------------------------------------------------------------

	global error_count

	variable app_name

	if {$qtanw::error_count == -1} {
		tk_messageBox -type ok -message "$name was stopped" -title "$qtanw::app_name" -icon info
	} elseif {$qtanw::error_count == 0} {
		tk_messageBox -type ok -message "$name was successful" -title "$qtanw::app_name" -icon info
	} else {
		tk_messageBox -type ok -message "$name unsuccessful" -title "$qtanw::app_name" -icon error
	}
}	

# ----------------------------------------------------------------
#
proc qtanw::on_open_quartus { } {
#
# Description:	Starts predefined flow i.e. full compilation
#
# ----------------------------------------------------------------

	global exe_name
	variable project_name

	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
		return
	}

	eval exec $exe_name(quartus) ${qtanw::project_name}.qpf &
}	

#############################################################################
## Procedure: open_tan_opt_dlg
##
## Arguments: None
##		
## Description: Opens the option dialog box for 'Fitter'
##
#############################################################################
proc qtanw::open_tan_opt_dlg { } {

	variable acf

	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
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

	set asgn_list { \
			{"Default fmax Requirement:" FMAX_REQUIREMENT "Specifies the minimum acceptable clock frequency."}\
	}

	foreach asgn_pair $asgn_list {
		set asgn_name [lindex $asgn_pair 1]
		set qtanw::acf($asgn_name) [get_global_assignment -name $asgn_name]
	}

	set sub_frame_1 [frame $dlg.sub_frame_1 -borderwidth 1 -relief groove]

	set i 0
	foreach asgn $asgn_list {

		set asgn_user_name [lindex $asgn 0]
		set asgn_name [lindex $asgn 1]
		set asgn_desc [lindex $asgn 2]

		set label_frame [LabelFrame $sub_frame_1.label_frame_$i -text $asgn_user_name -width 23 -font {helvetica 10} ]
		set entry [Entry $label_frame.entry_$i -text $qtanw::acf($asgn_name) \
					    -textvariable qtanw::acf($asgn_name) \
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
			if { ![string equal $qtanw::acf($asgn_name) ""] } {
				set_global_assignment -name $asgn_name $qtanw::acf($asgn_name)
			}
		}

		export_assignment_files

		qtanw::print_info "Changes (if any) will be reflected after next create_timing_netlist command"		
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
proc qtanw::on_settings_dlg { } {

	variable qtanw_path

	if { ![is_project_open] } {
		qtanw::print_error "No project is open"
		return
	}

	qtanw::open_tan_opt_dlg
}


# ----------------------------------------------------------------
#
proc qtanw::on_help {} {
#
# Description:	Display the readme
#				
#
# ----------------------------------------------------------------

	variable version
	variable app_name
	variable qtanw_path

	set exit_help 0

	if [catch {open ${qtanw_path}qtan_readme.txt r} ascii_file] {
		qtanw::print_error "Error: Cannot open ${qtanw_path}qtan_readme.txt"
	} else {

		toplevel .help
		wm title .help "$qtanw::app_name Readme" 

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

			$fhelp.text  insert end "$ascii_line\n" msgtag
		}	
		close $ascii_file

		vwait exit_help

		destroy .help
	}
}


# ----------------------------------------------------------------
#
proc qtanw::about_dlg { } {
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
                -title   "About QTAN Window" \
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

#--------------------------------------------------------------------------------------------
#
proc log_report_timing_message_recursive { current_list recursion_level } {
#
# Description:	Dump the messagese.
#				 
#               This function accepts a message represented as a TCL string.
#               "Info"  "ITDB_FULL_SLACK_RESULT" params "actual text" { list of submessages } 
#
#               The third list element is the actual message.
#               The fourth list element is a list of submessages.
#
# -------------------------------------------------------------------------------------------

	global settings

    # get the message
	set actual_message [lindex $current_list 3]

    # create left margin for the message
	set str ""
	for { set i 0 } { $i < $recursion_level } { incr i 1 } {
		set str "    $str"
	}

	# dump the message
	
	qtanw::post_user_message infotag "$str $actual_message"
	
	if { !$settings(verbose) } {
		# If short version, just return after giving main message
		return
	}

#	if { $recursion_level == 0 } {
#		qtanw::print_msg  "********************************************************"
#	}
	
	# call the function for the submessages
	set new_rec_l [expr $recursion_level + 1]
	
	foreach sub_msg [lindex $current_list 4] {
		log_report_timing_message_recursive $sub_msg $new_rec_l
	}		

	update
}

set qtan_path_count 1

#--------------------------------------------------------------------------------------------
#
proc print_report_timing_message { msg { stream_name "" } } {
#
# Description:	Entry point for printing message to the screen/file.
#				 
#               This function accepts a message represented as a TCL string:
#               "Info"  "ITDB_FULL_SLACK_RESULT" params "actual text" { list of submessages } 
#
#               If stream_name is specified assume this is the file name 
#               user whants to add paths to.
# -------------------------------------------------------------------------------------------

	global quartus
	global qtan_path_count

	# convert the string into the list
	set list $msg

	if { $quartus(ipc_mode) } {
		# When called from Quartus, just use Quartus message window
		catch {eval msg_tcl_post_message 0 {$list}}
		incr qtan_path_count
	} else {
		# In stand alone mode, add results to LOG_WINDOW
		qtanw::post_user_message infotag  "********************************************************"
		qtanw::post_user_message infotag  "Path Number: $qtan_path_count"
		incr qtan_path_count
		# recursivly dump the message
		log_report_timing_message_recursive $list 0
		qtanw::post_user_message infotag  "********************************************************"
	}

	update
}


###############################################################
#Procedure qtanw::create_clk_list {}
#
#Description: creates a list of all the clocks in the design
#
#Arguments: None
###############################################################
proc qtanw::create_clk_list {} {
	set node_collection [get_timing_nodes -type all]
	foreach_in_collection cur_node $node_collection {
		if {[string match "clk" [get_timing_node_info -info type $cur_node]]} {
			lappend clk_list [get_timing_node_info -info name $cur_node]
		}
	}
	if {[info exists clk_list]} {
		return $clk_list
	} else {
		return ""
	}
}

# Append BWidget directory in auto_path
package require BWidget


# Invoke main proc to start the application
qtanw::main

tkwait window .

