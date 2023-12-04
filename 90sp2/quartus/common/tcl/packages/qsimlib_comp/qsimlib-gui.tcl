#############################################################################
##  qsimlib-gui.tcl
##
##  EDA Simulation Compiler Library graphical user interface.
##
##  ALTERA LEGAL NOTICE
##  
##  This script is  pursuant to the following license agreement
##  (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
##  FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
##  California, USA.  Permission is hereby granted, free of
##  charge, to any person obtaining a copy of this software and
##  associated documentation files (the "Software"), to deal in
##  the Software without restriction, including without limitation
##  the rights to use, copy, modify, merge, publish, distribute,
##  sublicense, and/or sell copies of the Software, and to permit
##  persons to whom the Software is furnished to do so, subject to
##  the following conditions:
##  
##  The above copyright notice and this permission notice shall be
##  included in all copies or substantial portions of the Software.
##  
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
##  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
##  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
##  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
##  OTHER DEALINGS IN THE SOFTWARE.
##  
##  This agreement shall be governed in all respects by the laws of
##  the State of California and by the laws of the United States of
##  America.
##
##
##  CONTACTING ALTERA
##  
##  You can contact Altera through one of the following ways:
##  
##  Mail:
##     Altera Corporation
##     Applications Department
##     101 Innovation Drive
##     San Jose, CA 95134
##  
##  Altera Website:
##     www.altera.com
##  
##  Online Support:
##     www.altera.com/mysupport
##  
##  Troubshooters Website:
##     www.altera.com/support/kdb/troubleshooter
##  
##  Technical Support Hotline:
##     (800) 800-EPLD or (800) 800-3753
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##     (408) 544-7000
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##  
##     From other locations, call (408) 544-7000 or your local
##     Altera distributor.
##  
##  The mySupport web site allows you to submit technical service
##  requests and to monitor the status of all of your requests
##  online, regardless of whether they were submitted via the
##  mySupport web site or the Technical Support Hotline. In order to
##  use the mySupport web site, you must first register for an
##  Altera.com account on the mySupport web site.
##  
##  The Troubleshooters web site provides interactive tools to
##  troubleshoot and solve common technical problems.
##

package provide ::quartus::qsimlib_comp::gui 1.0

#############################################################################
##  Additional Packages Required
package require BWidget
package require ::quartus::misc
package require ::quartus::project
package require ::quartus::qsimlib_comp::database

#############################################################################

##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::qsimlib_comp::gui {

    namespace export main

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable app_name 			"EDA Simulation Library Compiler"
	variable product_name		[get_quartus_legal_string -product]
	variable quartus_version	""
	variable modelsim_ae_msg 	"The ModelSim-Altera software comes packaged with precompiled\
								simulation libraries. \nDo not compile simulation libraries if\
								you are using the ModelSim-Altera software."
	variable modelsim_ae_note	"Note: ModelSim-Altera software comes packaged with precompiled\
								simulation libraries."
}

#############################################################################
##  Procedure:  main
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the GUI. You should call this function and run a vwait on \
##		the exit_qsimlib_comp variable. This is touched
##      when the GUI destroys itself.
proc ::quartus::qsimlib_comp::gui::main {} {
	
	global global_options
	global widgets
	global ui_options
	
	#
    # IMPORT GLOBALS FOR THIS NAMESPACE
    #
    variable app_name
	variable quartus_version
	variable product_name
	
	set quartus_version $::quartus(version)
	#
	# INIT THE UI OPTIONS USE
	#
	init
	
	#
	# CONFIGURE THE FONTS USED IN THE GUI
	#
	switch -glob $::tcl_platform(platform) {
		"unix" {
			font create default_font -family avantgarde -size 10
			font create medium_font -family avantgarde -size 8
			font create small_font -family avantgarde -size 6
			font create msg_font -family Courier -size -12
			option add *TitleFrame.l.font default_font
		}
		"windows" {
			font create default_font -family helvetica -size 10
			font create medium_font -family helvetica -size 8
			font create small_font -family helvetica -size 6
			font create msg_font  -family Courier -size 10
			option add *TitleFrame.l.font default_font
		}
	}
	
	#
    # WITHDRAW ANY BASIC WINDOW THAT tk MAY HAVE DRAWN
	#
    wm withdraw .

    #
    # SET THE TITLE OF THE APPLICATION MAIN WINDOW
    #
    wm title . "$app_name"
	
	#
    # CREATE THE MAINFRAME FOR THE APPLICATION
    #
    addWidget mainframe [MainFrame .mainframe \
        -progressmax $ui_options(progress_max) \
        -progresstype normal \
        -progressvar ui_options(progress_variable) \
        -textvariable ui_options(progress_text) ]
	
	#
    # ADD A STATUS LABEL
    #
    addWidget elapsedTime [$widgets(mainframe) addindicator \
								-text " $product_name $quartus_version "]
		
		set pane [$widgets(mainframe) getframe]
		
		#
		# CREATE THE NOTEBOOK
		#
		create_notebook

		#
		# CREATE THE BUTTONS
		#
		addWidget close_button [Button $pane.close_button -text "Close" \
									-font default_font -height 1 -cursor arrow \
									-command ::quartus::qsimlib_comp::gui::on_close_gui]
			
		addWidget compile_button [Button $pane.compile_button -text "Start Compilation" \
									-font default_font -height 1 -cursor arrow \
									-command ::quartus::qsimlib_comp::gui::on_click_compile]
		
		addWidget stop_button [Button $pane.stop_button -text "Stop" \
									-font default_font -height 1 -cursor arrow \
									-command ::quartus::qsimlib_comp::gui::on_click_stop]
	
	#
    # PACK THE TOPLEVEL WINDOW FOR EVERYTHING
    #
	pack $widgets(close_button) -side right -padx 5 -pady 5
	pack $widgets(compile_button) -side right -padx 5 -pady 5
	pack $widgets(mainframe) -fill both -expand yes

	#
	# MAKE SURE WHEN THE USER DESTROYS THE APPLICATION
    #
    bind $widgets(mainframe) <Destroy> {::quartus::qsimlib_comp::gui::on_close_gui}
	
	update idletasks
	
    #
    # SHOW THE TOP-LEVEL WINDOW, CENTERED IN THE USER'S DISPLAY
    #
    BWidget::place . 0 0 center
    wm deiconify .
    raise .
    focus -force .

	::quartus::qsimlib_comp::gui::update_init_data
	
    return 1
}

##### GUI related functions

#############################################################################
##  Procedure:  addWidget
##
##  Arguments:
##      _wname
##          Friendy widget name
##
##      _truename
##          Full, ugly, true widget path name
##
##  Description:
##      Helper function that adds a friendly name for a widget to the global
##      "widgets" array. You should not add names to this array by hand!
##      Always use this addWidget function because it'll keep you from
##      clobbering a widget already named with the same friendly name.
proc ::quartus::qsimlib_comp::gui::addWidget {_wname _truename} {

	#
	# IMPORT GLOBAL NAMESPACE VARIABLES
	#
    global widgets
	
	#
	# ERROR IF WIDGET NAME ALREADY EXISTS
	#
    if {[info exists widgets($_wname)]} {
        return -code error "Widget with name $_wname already exists!"
    }

	#
    # ADD IT
	#
    set widgets($_wname) $_truename

    return 1
}

#############################################################################
##  Procedure:  create_notebook
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the notebook with 2 tabs. Settings tab and Messagse Tab.
proc ::quartus::qsimlib_comp::gui::create_notebook {} {

	global widgets
	
	set pane [$widgets(mainframe) getframe]
	
	addWidget notebook [NoteBook $pane.notebook -font default_font]
    
		#
		# CREATE THE TABS
		#
		create_setting_tab
		create_messages_tab

	#
	# PACK THE NOTEBOOK THAT HOLDS EVERYTHING
	#
	$widgets(notebook) compute_size
	pack $widgets(notebook) -fill both -expand yes
	$widgets(notebook) raise settingTab
}


#############################################################################
##  Procedure:  create_setting_tab
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the setting tab.
proc ::quartus::qsimlib_comp::gui::create_setting_tab {} {
	global global_options
	global widgets
	global ui_options
	
	addWidget settingtab [$widgets(notebook) insert end settingTab -text "  Settings  "]

		#
		# CREATE THE RELATED FRAME
		#
		create_simulator_frame
		create_options_frame
		create_output_frame
	
	addWidget export_checkbox [checkbutton $widgets(settingtab).export_checkbox \
									-text "Apply settings to current project" \
									-variable global_options(apply_settings) \
									-state disabled]

	if { $global_options(is_project) } {
		$widgets(export_checkbox) configure -state normal
	}
	
	pack $widgets(export_checkbox) -side top -fill y -padx 5 -pady 5 -anchor w
}

#############################################################################
##  Procedure:  create_simulator_frame
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the simulator frame.
proc ::quartus::qsimlib_comp::gui::create_simulator_frame {} {
	
	global widgets
	global global_options
	global ui_options
	
	#
    # CREATE SIMULATOR FRAME
    #
	addWidget simulator_frame [TitleFrame $widgets(settingtab).simulator_frame \
									-text "EDA simulation tool"]
	
	set simulator_frame [$widgets(simulator_frame) getframe]
		
		addWidget sf_first_pane [PanedWindow $simulator_frame.sf_first_pane]
		
		addWidget tool_label [Label $widgets(sf_first_pane).tool_label \
									-text "Tool name:" -justify left -anchor w]
		
		addWidget tool_options [ComboBox $widgets(sf_first_pane).tool_options \
									-editable no \
									-values [::quartus::qsimlib_comp::gui::get_tool_name] \
									-modifycmd ::quartus::qsimlib_comp::gui::on_select_tool]
		
		pack $widgets(tool_label) -side left -pady 5 -padx 5
		pack $widgets(tool_options) -side left -fill both -expand yes -pady 5
		pack $widgets(sf_first_pane) -side top -fill x -expand yes
		
		########################
		
		addWidget sf_second_pane [PanedWindow $simulator_frame.sf_second_pane]
		
		addWidget exe_label [Label $widgets(sf_second_pane).exe_label \
								-text "   Executable location:"]
		
		addWidget tool_dir_entry [Entry $widgets(sf_second_pane).tool_dir_entry \
										-text "" -editable no -state disabled -bg grey \
										-textvariable global_options(sim_tool_dir) \
										-justify left]
										
		addWidget tool_dir_button [Button $widgets(sf_second_pane).tool_dir_button \
										-text "..." -state disabled \
										-command ::quartus::qsimlib_comp::gui::on_choose_tool_directory]

		pack $widgets(exe_label) -side left -fill x -padx 5
		pack $widgets(tool_dir_entry) -side left -fill x -expand yes -padx 5
		pack $widgets(tool_dir_button) -side left -pady 5
		
		pack $widgets(sf_second_pane) -side top -fill x -expand yes
		
		########################

		addWidget version_frame [LabelFrame $simulator_frame.version_frame \
									-text "Current EDA simulation tool:" \
									-side top -justify left]
		
		addWidget tool_version [Label [$widgets(version_frame) getframe].tool_version \
										-font medium_font -justify left -text "" -anchor w]
		
		addWidget tool_note [Label [$widgets(version_frame) getframe].tool_note \
								-font medium_font -justify left -text "" -anchor w]
		
		pack $widgets(tool_note) -side bottom -fill x -padx 20 -anchor w
		pack $widgets(tool_version) -side bottom -fill x -padx 20 -anchor w
		pack $widgets(version_frame) -side top -fill x -expand yes -pady 5 -padx 7
	
	pack $widgets(simulator_frame) -side top -fill both -padx 5 -pady 5
}


#############################################################################
##  Procedure:  create_options_frame
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the options frame.
proc ::quartus::qsimlib_comp::gui::create_options_frame {} {
	
	global widgets
	global global_options
	
	#
    # CREATE THE OPTION FRAME
    #
    addWidget options_frame [TitleFrame $widgets(settingtab).options_page \
								-text "Compilation options"]
	
	set options_page [$widgets(options_frame) getframe]
	
		########################
		
		#
		# CREATE THE FAMILIES SELECTION LIST
		#
		create_family_selection_frame
		
		########################
		
		addWidget hdl_frame [TitleFrame $options_page.hdl_frame \
								-text "Library language"]
			
		addWidget vhdl_button [checkbutton [$widgets(hdl_frame) getframe].vhdl_button \
									-text "VHDL" -variable global_options(use_vhdl)]
										
		addWidget verilog_button [checkbutton [$widgets(hdl_frame) getframe].verilog_button \
									-text "Verilog" -variable global_options(use_verilog)]
		
		pack $widgets(vhdl_button) $widgets(verilog_button) -side left -fill both -padx 5 -pady 5
		pack $widgets(hdl_frame) -fill both -side top -expand yes -padx 5 -pady 5
		
	pack $widgets(options_frame) -fill both -side top -padx 5 -pady 5
}


#############################################################################
##  Procedure:  create_family_selection_frame
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the family selection frame.
proc ::quartus::qsimlib_comp::gui::create_family_selection_frame {} {
	global widgets
	global global_options
	global ui_options
	
	set options_page [$widgets(options_frame) getframe]
	
	addWidget family_frame [TitleFrame $options_page.family_frame \
								-text "Library families"]

	########################
	
	set family_frame [$widgets(family_frame) getframe]
	
	addWidget available_frame [PanedWindow $family_frame.available_frame]
	
		addWidget available_label [Label $widgets(available_frame).available_label \
									-text "Available families:" -justify left]
									
		addWidget available_list [listbox $widgets(available_frame).available_list \
									-selectmode multiple -height 5 \
									-listvariable ui_options(family_available)]
	
		foreach values [::quartus::qsimlib_comp::database::get_full_family_list] {
			set family_value [::quartus::qsimlib_comp::database::get_family_ui_name $values]
			lappend ui_options(family_available) $family_value
		}
		
		set ui_options(family_available) [lsort $ui_options(family_available)]
	
		addWidget available_scroll [scrollbar $widgets(available_list).available_scroll \
										-command "$widgets(available_list) yview"]
	
		$widgets(available_list) configure -yscrollcommand "$widgets(available_scroll) set"

	########################
	
	addWidget selected_frame [PanedWindow $family_frame.selected_frame]
		
		addWidget selected_label [Label $widgets(selected_frame).selected_label \
									-text "Selected families:" -justify left]
		
		addWidget selected_list [listbox $widgets(selected_frame).selected_list \
									-selectmode multiple -height 5 \
									-listvariable global_options(family_selected)]

		addWidget selected_scroll [scrollbar $widgets(selected_list).selected_scroll \
										-command "$widgets(selected_list) yview"]
		
		$widgets(selected_list) configure -yscrollcommand "$widgets(selected_scroll) set"
	
	########################
	
	addWidget button_pane [PanedWindow $family_frame.button_pane]
	
		set button_pane $widgets(button_pane)
		
		addWidget empty_button [Button $button_pane.empty_button -text " " \
								-font small_font -state disabled\
								-relief flat]
								
		addWidget add_button [Button $button_pane.add_button -text ">" \
								-font default_font -height 1 \
								-command "::quartus::qsimlib_comp::gui::on_add_selected_family"]
								
		addWidget addall_button [Button $button_pane.addall_button -text ">>" \
								-font default_font -height 1 \
								-command "::quartus::qsimlib_comp::gui::on_add_all_family"]
								
		addWidget remove_button [Button $button_pane.remove_button -text "<" \
								-font default_font -height 1 \
								-command "::quartus::qsimlib_comp::gui::on_remove_selected_family"]
								
		addWidget removeall_button [Button $button_pane.removeall_button -text "<<" \
								-font default_font -height 1 \
								-command "::quartus::qsimlib_comp::gui::on_remove_all_family"]
								
		pack $widgets(empty_button) -side top -pady 2
		pack $widgets(add_button) -side top -fill x -expand yes -pady 2
		pack $widgets(addall_button) -side top -fill x -expand yes -pady 2
		pack $widgets(remove_button) -side top -fill x -expand yes -pady 2
		pack $widgets(removeall_button) -side top -fill x -expand yes -pady 2

	########################
	
	pack $widgets(available_label) -side top -anchor w
	pack $widgets(available_list) -side top -fill both -expand yes
	pack $widgets(available_scroll) -side top -fill y -expand yes -anchor e
	
	pack $widgets(selected_label) -side top -anchor w
	pack $widgets(selected_list) -side top -fill both -expand yes
	pack $widgets(selected_scroll) -side top -fill y -expand yes -anchor e
	
	pack $widgets(available_frame) -side left -fill both -expand yes -pady 5 -padx 5
	pack $widgets(button_pane) -side left -padx 5 -pady 5
	pack $widgets(selected_frame) -side left -fill both -expand yes -pady 5 -padx 5
	
	
	pack $widgets(family_frame) -fill both -expand yes -padx 5 -pady 5
}

#############################################################################
##  Procedure:  create_output_frame
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the output frame.
proc ::quartus::qsimlib_comp::gui::create_output_frame {} {

	global widgets
	global global_options
	
	addWidget output_frame [TitleFrame $widgets(settingtab).output_frame \
								-text "Output"]
	
	set output_frame [$widgets(output_frame) getframe]
	
		addWidget output_dir_pane [PanedWindow $output_frame.output_dir_pane]
		
		addWidget out_label [Label $widgets(output_dir_pane).out_label \
								-text "Output directory:"]
		
		addWidget out_dir_entry [Entry $widgets(output_dir_pane).out_dir_entry \
									-text "" -editable no\
									-textvariable global_options(output_dir)]
			
		addWidget out_dir_button [Button $widgets(output_dir_pane).out_dir_button \
									-text "..." \
									-command ::quartus::qsimlib_comp::gui::on_choose_output_directory]
			
		addWidget log_button [checkbutton $output_frame.log_button \
									-text "Create log file" \
									-variable global_options(create_log)]
										
		addWidget suppress_button [checkbutton $output_frame.suppress_button \
									-text "Show all messages" \
									-variable global_options(show_all_message)]
	
		
		pack $widgets(out_label) -side left -padx 5 -pady 5 -anchor n
		pack $widgets(out_dir_entry) -side left -fill x -expand yes -padx 5 -pady 5 -anchor n
		pack $widgets(out_dir_button) -side left -pady 5 -anchor n
		
		pack $widgets(output_dir_pane) -side top -fill x -expand yes -anchor n
		pack $widgets(suppress_button) $widgets(log_button) -side left -fill x -padx 5 -pady 5 -anchor n
		 
		pack $widgets(output_frame) -side top -fill both -padx 5 -pady 5
}


#############################################################################
##  Procedure:  create_messages_tab
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the messages tab.
proc ::quartus::qsimlib_comp::gui::create_messages_tab {} {
	
	global widgets
	
	#
    # CREATE THE NOTEBOOK PAGE TO HOLD MESSAGES
    #
    addWidget messagestab [$widgets(notebook) insert end messagesTab -text "  Messages  "]

	set messages_frame $widgets(messagestab)
	
		# 
		# ADD THE MESSAGES TEXT FRAME
		#
		addWidget text_frame [TitleFrame $messages_frame.text_frame -text "Log"]
		
			#
			# ADD THE MESSAGES TEXT AREA
			#
			addWidget scroll_window [ScrolledWindow [$widgets(text_frame) getframe].scroll_window \
										-auto none]
										
			addWidget text_msg [text $widgets(scroll_window).text_msg -relief sunken \
										-wrap none -width 80]
			
				#
				# TAG MESSAGES COLOUR
				#
				$widgets(text_msg) tag configure infotag -foreground darkgreen -font msg_font
				$widgets(text_msg) tag configure errortag -foreground red -font msg_font
				$widgets(text_msg) tag configure warningtag -foreground blue -font msg_font
				$widgets(text_msg) tag configure debugtag -foreground black -font msg_font
				$widgets(text_msg) configure -state disabled
				
			$widgets(scroll_window) setwidget $widgets(text_msg)
			
		pack $widgets(text_frame) -anchor nw -expand yes -fill both
		pack $widgets(scroll_window) -expand yes -fill both
}

##### GUI Related Command

#############################################################################
##  Procedure:  on_close_gui
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Clean up. Close it down.
proc ::quartus::qsimlib_comp::gui::on_close_gui {} {
    global exit_qsimlib_comp
	global ui_options
	
	::quartus::qsimlib_comp::gui::stop_proccessing
	
	set ui_options(break_process) 1
    set exit_qsimlib_comp 1
    return $exit_qsimlib_comp
}

#############################################################################
##  Procedure:  on_add_selected_family
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Add the selected family to the selected list
proc ::quartus::qsimlib_comp::gui::on_add_selected_family {} {
	global global_options
	global widgets
	global ui_options
	
	if { [$widgets(available_list) curselection] == "" } {
		# listbox has no selected items
	} else {
		# listbox has one or more selected items
		foreach index [$widgets(available_list) curselection] { 
			
			set element [$widgets(available_list) get $index]

			if { $element != "" } {
				lappend selected_element $element
			}
		}
		
		foreach selected $selected_element {
			upvar 1 global_options(family_selected) list
			if {[lsearch $list $selected]<0} {lappend list $selected}
			set list
			
			upvar 1 ui_options(family_available) list
			set pos [lsearch $list $selected]
			set list [lreplace $list $pos $pos]
		}
		
		$widgets(available_list) selection clear 0 end

		set global_options(family_selected) [lsort $global_options(family_selected)]
	}
}

#############################################################################
##  Procedure:  on_remove_selected_family
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Remove the selected family from the selected list
proc ::quartus::qsimlib_comp::gui::on_remove_selected_family {} {
	global global_options
	global widgets
	global ui_options
	
	if { [$widgets(selected_list) curselection] == "" } {
		# listbox has no selected items
	} else {
		# listbox has one or more selected items
		foreach index [$widgets(selected_list) curselection] { 
			
			set element [$widgets(selected_list) get $index]

			if { $element != "" } {
				lappend selected_element $element
			}
		}
		
		foreach selected $selected_element {
			upvar 1 global_options(family_selected) list
			    set pos [lsearch $list $selected]
			    set list [lreplace $list $pos $pos]

				upvar 1 ui_options(family_available) list
			    if {[lsearch $list $selected]<0} {lappend list $selected}
			    set list
		}
		
		$widgets(selected_list) selection clear 0 end

		set ui_options(family_available) [lsort $ui_options(family_available)]
	}
}

#############################################################################
##  Procedure:  on_add_all_family
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Add all the family to the selected list
proc ::quartus::qsimlib_comp::gui::on_add_all_family {} {
	global global_options
	global ui_options
	
	upvar 1 global_options(family_selected) list
	foreach element $ui_options(family_available) {
		lappend list $element
	}
	set list
	
	set ui_options(family_available) ""
	
	set global_options(family_selected) [lsort $global_options(family_selected)]
}

#############################################################################
##  Procedure:  on_remove_all_family
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Remove all the family from the selected list
proc ::quartus::qsimlib_comp::gui::on_remove_all_family {} {
	global global_options
	global ui_options
	
	upvar 1 ui_options(family_available) list
	foreach element $global_options(family_selected) {
		lappend list $element
	}
	set list
	
	set global_options(family_selected) ""
	
	set ui_options(family_available) [lsort $ui_options(family_available)]
}

#############################################################################
##  Procedure:  on_select_tool
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Update the global tool options. Also check whether the simulator
##		support both language and disabled the language radio button if
##		necessary.
proc ::quartus::qsimlib_comp::gui::on_select_tool {} {

	global widgets
	global global_options
	global ui_options
	variable modelsim_ae_note
	
	set i 0
	
	set selected_values "[$widgets(tool_options) getvalue]"

	foreach values $ui_options(supported_tools) {
		if { $selected_values == $i } {
			set global_options(sim_tool) $values
			break
		}
		incr i
	}
	
	if { $global_options(sim_tool) eq "modelsim" } {
		$widgets(tool_note) configure -text $modelsim_ae_note
	} else {
		$widgets(tool_note) configure -text ""
	}
	
	::quartus::qsimlib_comp::gui::check_tool_supported_language
	::quartus::qsimlib_comp::gui::check_tool_default_location
}

#############################################################################
##  Procedure:  on_choose_tool_directory
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Allow user to choose the tool executable directory then update the
##		the tool version as needed.
proc ::quartus::qsimlib_comp::gui::on_choose_tool_directory {} {
	global widgets
	global global_options
	global ui_options
	
	set current $global_options(sim_tool_dir)
	
	set choosed_dir [tk_chooseDirectory -initialdir $current -mustexist true]
	
	if { $choosed_dir != "" && [file isdirectory $choosed_dir] } {
		set global_options(sim_tool_dir) $choosed_dir
	}
	
	::quartus::qsimlib_comp::gui::check_tool_version
}

#############################################################################
##  Procedure:  on_choose_output_directory
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Allow user to choose the output directory the compiled simulation
##		libraries will be place
proc ::quartus::qsimlib_comp::gui::on_choose_output_directory {} {
	global widgets
	global global_options
	global ui_options
	
	set current $global_options(output_dir)
	
	set choosed_dir [tk_chooseDirectory -initialdir $current -mustexist true]
	
	if { $choosed_dir != "" && [file isdirectory $choosed_dir] } {
		set global_options(output_dir) $choosed_dir
	}
}

#############################################################################
##  Procedure:  on_click_compile
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Pre-proccesing the required options and execute command
proc ::quartus::qsimlib_comp::gui::on_click_compile {} {
	
	set status [::quartus::qsimlib_comp::gui::check_information_completed]
	
	if { $status == 1 } {
		::quartus::qsimlib_comp::gui::process_command
		::quartus::qsimlib_comp::gui::execute_command
	}
}

#############################################################################
##  Procedure:  on_click_stop
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Stop the proccessing
proc ::quartus::qsimlib_comp::gui::on_click_stop {} {
	global ui_options
	global widgets
	
	::quartus::qsimlib_comp::gui::stop_proccessing
	
	set ui_options(break_process) 1
}

##### Backend proccesing

#############################################################################
##  Procedure:  init
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Init all the variable use in this UI and also the global
proc ::quartus::qsimlib_comp::gui::init {} {
	global ui_options
	
	set ui_options(specify_msg) "Specify simulation tool executable location"
	set ui_options(supported_tools) "[::quartus::qsimlib_comp::database::get_supported_tool]"
	set ui_options(family_available) ""
	set ui_options(current_run) ""
	set ui_options(run_command) [list]
	set ui_options(exe_found) 0
	set ui_options(proccess_is_finish) 0
	set ui_options(progress_limit_per_run) 0
	set ui_options(current_limit) 0
	set ui_options(progress_variable) 0
    set ui_options(progress_max) 1000
    set ui_options(progress_text) ""
	set ui_options(compile_start_time) 0
    set ui_options(compile_timer) 0
	set ui_options(break_process) 0
	set ui_options(error_count) 0
	set ui_options(warning_count) 0
}

#############################################################################
##  Procedure:  update_init_data
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Update the GUI so that all the data show correctly
proc ::quartus::qsimlib_comp::gui::update_init_data {} {
	global global_options
	global widgets
	global ui_options
	
	set correct_list [list]
	set found 0
	
	foreach family $global_options(family_selected) {
		foreach value $ui_options(family_available) {
			if [string match -nocase $family $value] {
				set family $value
				set found 1
				break;
			}
		}
		
		if {$found == 1} {
			upvar 1 ui_options(family_available) list
			set pos [lsearch $list $family]
			set list [lreplace $list $pos $pos]
		
			lappend correct_list $family
			set found 0
		}
	}
	
	set global_options(family_selected) $correct_list
	
	set ui_options(family_available) [lsort $ui_options(family_available)]
	
	set i 0
	set found 0
	if { $global_options(sim_tool) != "" } {
		foreach tool $ui_options(supported_tools) {
			if { $tool == $global_options(sim_tool) } {
				$widgets(tool_options) setvalue @$i
				set found 1
				break;
			}
			incr i
		}
		
		if {$found == 1} {
			::quartus::qsimlib_comp::gui::on_select_tool
		}
	}
	
	if { $global_options(is_project) == 0 } {
		set global_options(apply_settings) 0
	}
}

#############################################################################
##  Procedure:  get_tool_name
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Return all the available tool name
proc ::quartus::qsimlib_comp::gui::get_tool_name {} {

	global ui_options
	
	set tool_name ""
	
	foreach values $ui_options(supported_tools) {
		lappend tool_name [::quartus::qsimlib_comp::database::get_tool_ui_name $values]
	}
	
	return $tool_name
}

#############################################################################
##  Procedure:  check_tool_default_location
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Get the tool default location
proc ::quartus::qsimlib_comp::gui::check_tool_default_location {} {
	global widgets
	global global_options
	global ui_options
	
	
	$widgets(tool_dir_entry) configure -state normal -bg white
	$widgets(tool_dir_button) configure -state normal
	
	set tool $global_options(sim_tool)
	set tool_acf_key [::quartus::qsimlib_comp::database::get_tool_acf_key $tool]
	set global_options(sim_tool_dir) [get_user_option -name $tool_acf_key]
	
	::quartus::qsimlib_comp::gui::check_tool_version
}

#############################################################################
##  Procedure:  check_tool_supported_language
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Check whether the tool supported all language
proc ::quartus::qsimlib_comp::gui::check_tool_supported_language {} {
	global widgets
	global global_options
	
	set tool $global_options(sim_tool)
	set language [::quartus::qsimlib_comp::database::get_supported_hdl $tool]
	
	if { $language == "verilog" } {
		$widgets(verilog_button) select
		$widgets(vhdl_button) deselect
		$widgets(verilog_button) configure -state normal
		$widgets(vhdl_button) configure -state disabled
	} elseif { $language == "vhdl" } {
		$widgets(vhdl_button) select
		$widgets(verilog_button) deselect
		$widgets(verilog_button) configure -state disabled
		$widgets(vhdl_button) configure -state normal
	} else {
		$widgets(verilog_button) configure -state normal
		$widgets(vhdl_button) configure -state normal
	}
}

#############################################################################
##  Procedure:  check_tool_version
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Get the tool current version
proc ::quartus::qsimlib_comp::gui::check_tool_version {} {
	global global_options
	
	switch -glob $global_options(sim_tool) {
		"vcs"			-
		"vcsmx"			{ ::quartus::qsimlib_comp::gui::query_vcs_tool_version }
		"rivierapro"	{ ::quartus::qsimlib_comp::gui::query_riviera_tool_version }
		default			{ ::quartus::qsimlib_comp::gui::query_default_tool_verson }
	}
}

#############################################################################
##  Procedure:  query_default_tool_verson
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Get the default tool current version
proc ::quartus::qsimlib_comp::gui::query_default_tool_verson {} {
	global global_options
	global ui_options
	global widgets
	
	set tool_location $global_options(sim_tool_dir)
	
	if { $tool_location != "" } {
		set tool_query [::quartus::qsimlib_comp::database::get_tool_version_query \
							$global_options(sim_tool)]
		
		if {[string equal -nocase $::tcl_platform(platform) "windows"]} {
			set tool_query "$tool_query.exe"
		}
		
		set full_path [file join $tool_location $tool_query]
		set version ""
		
		if [catch {exec $full_path -version} result] {
			$widgets(tool_version) configure -text $ui_options(specify_msg)
			set global_options(exe_found) 0
		} else {
			if [regexp -nocase [::quartus::qsimlib_comp::database::get_tool_ui_name $global_options(sim_tool)] $result] {
				$widgets(tool_version) configure -text $result
				set global_options(exe_found) 1
			} else {
				$widgets(tool_version) configure -text $ui_options(specify_msg)
				set global_options(exe_found) 0
			}
		}
	} else {
		$widgets(tool_version) configure -text $ui_options(specify_msg)
		set global_options(exe_found) 0
	}
}

#############################################################################
##  Procedure:  query_riviera_tool_version
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Get the riviera current version
proc ::quartus::qsimlib_comp::gui::query_riviera_tool_version {} {
	global global_options
	global ui_options
	global widgets
	
	set tool_location $global_options(sim_tool_dir)
	
	if { $tool_location != "" } {
		set version ""
		set tool_query [::quartus::qsimlib_comp::database::get_tool_version_query \
							$global_options(sim_tool)]
		
		if {[string equal -nocase $::tcl_platform(platform) "windows"]} {
			set tool_query "$tool_query.exe"
		} else {
			# Required to use runvsimsa in Linux
			set tool_query "runvsimsa"
		}
		
		set full_path [file join $tool_location $tool_query]
		
		if [catch {exec $full_path -version} result] {
			# no version found
		} else {
			if [regexp -nocase [::quartus::qsimlib_comp::database::get_tool_ui_name $global_options(sim_tool)] $result] {
				set version $result
			}
		}
		
		if { $version != "" } {
			$widgets(tool_version) configure -text $version
			set global_options(exe_found) 1
		} elseif [file exists $full_path] {
			$widgets(tool_version) configure -text ""
			set global_options(exe_found) 1
		} else {
			$widgets(tool_version) configure -text $ui_options(specify_msg)
			set global_options(exe_found) 0
		}
	} else {
		$widgets(tool_version) configure -text $ui_options(specify_msg)
		set global_options(exe_found) 0
	}
}



#############################################################################
##  Procedure:  query_vcs_tool_version
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Get the vcs current version
proc ::quartus::qsimlib_comp::gui::query_vcs_tool_version {} {
	global global_options
	global ui_options
	global widgets
	
	set tool_location $global_options(sim_tool_dir)
	
	if { $tool_location != "" } {
		set tool_query [::quartus::qsimlib_comp::database::get_tool_version_query \
							$global_options(sim_tool)]
		
		set full_path [file join $tool_location $tool_query]
		set version ""
		
		if [catch {exec $full_path -help} result] {
			if [regexp -nocase "vcs" $result] {
				foreach line [split $result "\n"] {
					if [regexp -nocase "compiler version" $line] {
						set version $line
						break;
					}
				}
			}
		} else {
			if [regexp -nocase "vcs" $result] {
				foreach line [split $result "\n"] {
					if [regexp -nocase "compiler version" $line] {
						set version $line
						break;
					}
				}
			}
		}
		
		if { $version != "" } {
			$widgets(tool_version) configure -text $version
			set global_options(exe_found) 1
		} elseif [file exists $full_path] {
			$widgets(tool_version) configure -text ""
			set global_options(exe_found) 1
		} else {
			$widgets(tool_version) configure -text $ui_options(specify_msg)
			set global_options(exe_found) 0
		}
	} else {
		$widgets(tool_version) configure -text $ui_options(specify_msg)
		set global_options(exe_found) 0
	}
}

#############################################################################
##  Procedure:  update_gui
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Update the gui based on current state
proc ::quartus::qsimlib_comp::gui::update_gui { state } {
	global widgets
	global ui_options
	global global_options
	variable quartus_version
	variable product_name
	
	if { $state == "compilation_started" } {
		
		# Simulator frame
		$widgets(tool_options) configure -state disabled
		$widgets(tool_dir_entry) configure -state disabled
		$widgets(tool_dir_button) configure -state disabled
		
		# Compilation frame
		$widgets(available_list) configure -state disabled
		$widgets(selected_list) configure -state disabled
		
		$widgets(add_button) configure -state disabled
		$widgets(addall_button) configure -state disabled
		$widgets(remove_button) configure -state disabled
		$widgets(removeall_button) configure -state disabled
		
		$widgets(vhdl_button) configure -state disabled
		$widgets(verilog_button) configure -state disabled
		
		# Output frame
		$widgets(out_dir_entry) configure -state disabled
		$widgets(out_dir_button) configure -state disabled
		$widgets(suppress_button) configure -state disabled
		$widgets(log_button) configure -state disabled
		
		# Export frame
		$widgets(export_checkbox) configure -state disabled
		
		# Clear the message box
		$widgets(text_msg) configure -state normal
		$widgets(text_msg) delete 1.0 end
		$widgets(text_msg) configure -state disabled
		$widgets(notebook) raise messagesTab
	
		# Display the status and the progress bar
        $widgets(mainframe) showstatusbar progression
		$widgets(elapsedTime) configure -text "0%     00:00:00"
		
		# Enable the appropriate tabs
        $widgets(notebook) raise messagesTab

        . configure -cursor watch
		
		# Change the button
		pack forget $widgets(compile_button)
		pack $widgets(stop_button) -padx 5 -pady 5 -side right
		$widgets(stop_button) configure -state disabled
	}
	
	if { $state == "compilation_finished" } {
		# Simulator frame
		$widgets(tool_options) configure -state normal
		$widgets(tool_dir_entry) configure -state normal
		$widgets(tool_dir_button) configure -state normal
		
		# Compilation frame
		$widgets(available_list) configure -state normal
		$widgets(selected_list) configure -state normal
		
		$widgets(add_button) configure -state normal
		$widgets(addall_button) configure -state normal
		$widgets(remove_button) configure -state normal
		$widgets(removeall_button) configure -state normal
		
		$widgets(vhdl_button) configure -state normal
		$widgets(verilog_button) configure -state normal
		
		# Output frame
		$widgets(out_dir_entry) configure -state normal
		$widgets(out_dir_button) configure -state normal
		$widgets(suppress_button) configure -state normal
		$widgets(log_button) configure -state normal
		
		if { $global_options(is_project) == 1 } {
			# Export frame
			$widgets(export_checkbox) configure -state normal
		}
	
		set ui_options(progress_variable) 0
        set ui_options(progress_text) ""

        # Remove the progress bar
        $widgets(mainframe) showstatusbar status

        # Reset the text in the status bar
        $widgets(elapsedTime) configure -text " $product_name $quartus_version "
		
        . configure -cursor arrow
		
		# Change the button
		pack forget $widgets(stop_button)
		pack $widgets(compile_button) -padx 5 -pady 5 -side right
	}
}

#############################################################################
##  Procedure:  update_elapsed_timer
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Proccess all the options and preparing the command to be run.
proc ::quartus::qsimlib_comp::gui::update_elapsed_timer {} {
	global widgets
	global ui_options
	
	set msecs [expr {[clock clicks -milliseconds] - $ui_options(compile_start_time)}]
    set hours [expr {(($msecs/1000)%86400)/3600}]
    set minutes [expr {(($msecs/1000)%3600)/60}]
    set seconds [expr {($msecs/1000)%60}]

    set text [format "%02u:%02u:%02u" $hours $minutes $seconds]
	
	if { [expr $seconds % (round(rand()*10) % 15 + 1)] == 0 } {
		set amount [expr (round(rand()*10) % 7 + 1)*10]
		if { [expr $ui_options(progress_variable) + $amount] < $ui_options(current_limit) } {
			set ui_options(progress_variable) [expr $ui_options(progress_variable) + $amount]
		}
	} 
	
    # Round percentage to the nearest integer
    set percent [expr {round(100 * $ui_options(progress_variable) / $ui_options(progress_max))}]

    # Set the text so the user can see the progress and elapsed time
    catch {$widgets(elapsedTime) configure -text "$percent%     $text"}

    set ui_options(compile_timer) [after 1000 ::quartus::qsimlib_comp::gui::update_elapsed_timer]
}

#############################################################################
##  Procedure:  proccess_command
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Proccess all the options and preparing the command to be run.
proc ::quartus::qsimlib_comp::gui::process_command {} {
	global global_options
	global ui_options
	
	set log_name "log-"
	set suppress ""
	set create_log ""
	set language ""
	set command ""
	set i 0
	
	# Clear the list
	set ui_options(run_command) [list]
	set ui_options(break_process) 0
	
	if { $global_options(show_all_message) == 0 } {
		set suppress "-suppress_messages"
	}

	set global_options(sim_tool_dir) [escape_brackets $global_options(sim_tool_dir)]
	
	if { $global_options(use_vhdl) == 1 } {
		if { $global_options(create_log) == 1 } {
				set create_log "-log $log_name$global_options(sim_tool)\-vhdl\-rtl_only"
		}
		
		set command "quartus_sh --simlib_comp -tool $global_options(sim_tool)\
						-tool_path \"$global_options(sim_tool_dir)\"\
						-language vhdl -directory \"$global_options(output_dir)\"\
						 -rtl_only $create_log $suppress"

		lappend ui_options(run_command) $command
		
		foreach family $global_options(family_selected) {
			set family [::quartus::qsimlib_comp::database::get_family_name $family]

			if { $global_options(create_log) == 1 } {
				set create_log "-log $log_name$global_options(sim_tool)\-$family\-vhdl\-$i"
			}
			set command "quartus_sh --simlib_comp\
							-tool $global_options(sim_tool)\
							-tool_path \"$global_options(sim_tool_dir)\"\
							-language vhdl -family $family\
							-directory \"$global_options(output_dir)\"\
							-no_rtl $create_log $suppress"
			incr i
			
			lappend ui_options(run_command) $command
		}
	}
	
	if { $global_options(use_verilog) == 1 } {
		if { $global_options(create_log) == 1 } {
				set create_log "-log $log_name$global_options(sim_tool)\-verilog\-rtl_only"
		}
		
		set command "quartus_sh --simlib_comp -tool $global_options(sim_tool)\
						-tool_path \"$global_options(sim_tool_dir)\"\
						-language verilog -directory \"$global_options(output_dir)\"\
						-rtl_only $create_log $suppress"
		
		lappend ui_options(run_command) $command
		
		foreach family $global_options(family_selected) {
			set family [::quartus::qsimlib_comp::database::get_family_name $family]
			
			if { $global_options(create_log) == 1 } {
				set create_log "-log $log_name$global_options(sim_tool)\-$family\-verilog\-$i"
			}
			set command "quartus_sh --simlib_comp\
							-tool $global_options(sim_tool)\
							-tool_path \"$global_options(sim_tool_dir)\"\
							-language verilog -family $family\
							-directory \"$global_options(output_dir)\"\
							-no_rtl $create_log $suppress"
			incr i
			
			lappend ui_options(run_command) $command
		}
	}
}

#############################################################################
##  Procedure:  check_information_completed
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Check to ensure all the required information is filled. Prompt a 
##		dialog messages if one of them missing.
proc ::quartus::qsimlib_comp::gui::check_information_completed {} {
	global ui_options
	global global_options
	global widgets
	variable modelsim_ae_msg
	
	set status 0 
	
	if { $global_options(sim_tool) == "" } {
		set msg "Select a simulation tool."
	} elseif { $global_options(sim_tool_dir) == "" || \
				$global_options(exe_found) == 0 } {
		set msg "Specify the simulation tool executable location."
	} elseif { $global_options(sim_tool) == "modelsim" && \
				[regexp -nocase "ALTERA" [$widgets(tool_version) cget -text]] } {
		set msg $modelsim_ae_msg
	} elseif { $global_options(family_selected) == "" } {
		set msg "Select at least one device family."
	} elseif { $global_options(use_vhdl) == 0 && \
				$global_options(use_verilog) == 0} {
		set msg "Select at least one library package."
	} elseif { $global_options(output_dir) == "" || ![file isdirectory $global_options(output_dir)] } {
		set msg "Specify the output directory for compiled library."
	} else {
		set status 1
	}

	if { $status == 0 } {
		MessageDlg .about -message $msg -type ok -icon error -title "Error"
	}
	
	return $status
}

#############################################################################
##  Procedure:  execute_command
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##     Execute the command
proc ::quartus::qsimlib_comp::gui::execute_command {} {
	global global_options
	global ui_options
	global widgets
	variable app_name
	
	::quartus::qsimlib_comp::gui::update_gui "compilation_started"
	
	set ui_options(progress_variable) 50
	
	set ui_options(compile_start_time) [clock clicks -milliseconds]
    set ui_options(compile_timer) [after 1000 ::quartus::qsimlib_comp::gui::update_elapsed_timer]
	set count 1
	set total [llength $ui_options(run_command)]
	
	set ui_options(progress_limit_per_run) [expr [expr $ui_options(progress_max) - $ui_options(progress_variable)] / $total]
	
	::quartus::qsimlib_comp::gui::post_info_msg "Info: Start compiling process"
	
	set ui_options(break_process) 0
	set ui_options(error_count) 0
	set ui_options(warning_count) 0
	
	foreach command $ui_options(run_command) {
		set ui_options(proccess_is_finish) 0
		
		set ui_options(current_limit) [expr $ui_options(progress_variable) + $ui_options(progress_limit_per_run)]
		$widgets(stop_button) configure -state disabled
		
		::quartus::qsimlib_comp::gui::post_info_msg "Info: Compiling process $count of $total"
		::quartus::qsimlib_comp::gui::post_info_msg "Info: Command: $command"
		
		set cmd_exec [open "|$command" r]
		
		#Mark PID of qtool running
		set ui_options(current_run) [pid $cmd_exec]
		
		$widgets(stop_button) configure -state normal
		
		fconfigure $cmd_exec -blocking 0
		
		fileevent $cmd_exec readable [list ::quartus::qsimlib_comp::gui::post_command_proccesing_msg $cmd_exec]
		
		vwait ui_options(proccess_is_finish)
		
		if { [catch {close $cmd_exec}] } {
			#Close the pipe
		}

		if { $ui_options(break_process) == 1 || $ui_options(error_count) > 0} {
			set ui_options(break_process) 1
			break;
		}
		
		set ui_options(progress_variable) $ui_options(current_limit)
		
		# Clear PID of qtool running
		set ui_options(current_run) ""
		
		incr count
	}
	
	if { $count == [incr total] } {
		# Make sure we should 100% at the progress bar
		set ui_options(progress_variable) $ui_options(progress_max)
	}
	
	# Cancel the timer and note the elapsed time
    after cancel $ui_options(compile_timer)
	
	set msecs [expr {[clock clicks -milliseconds] - $ui_options(compile_start_time)}]
    set hours [expr {(($msecs/1000)%86400)/3600}]
    set minutes [expr {(($msecs/1000)%3600)/60}]
    set seconds [expr {($msecs/1000)%60}]
	
    set text [format "%02u:%02u:%02u" $hours $minutes $seconds]
	
    set percent [expr {round(100 * $ui_options(progress_variable) / $ui_options(progress_max))}]
    # Set the text so the user can see the progress and elapsed time
    catch {$widgets(elapsedTime) configure -text "$percent%     $text"}
	
	if { $ui_options(error_count) == 1 } {
		set errors "($ui_options(error_count) error,"
	} else {
		set errors "($ui_options(error_count) errors,"
	}
	
	if { $ui_options(warning_count) == 1 } {
		set warnings "$ui_options(warning_count) warning)"
	} else {
		set warnings "$ui_options(warning_count) warnings)"
	}
	
	if { $ui_options(break_process) == 1 } {
		set msg "Compilation has stopped.\n$errors $warnings"
		::quartus::qsimlib_comp::gui::post_info_msg "Info: Compilation stopped:\
														[clock format [clock scan now]]"
		::quartus::qsimlib_comp::gui::post_info_msg "Info: Elapsed time: $text"
	} else {
		set msg "Compilation has finished.\n$errors $warnings"
		::quartus::qsimlib_comp::gui::post_info_msg "Info: Compilation ended:\
														[clock format [clock scan now]]"
		::quartus::qsimlib_comp::gui::post_info_msg "Info: Elapsed time: $text"
	}
	
	catch {tk_messageBox -message $msg -type ok -icon info -title $app_name -parent .}
	
	::quartus::qsimlib_comp::gui::update_gui "compilation_finished"
}

#############################################################################
##  Procedure:  stop_proccessing
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##     Stop current proccesing
proc ::quartus::qsimlib_comp::gui::stop_proccessing {} {
	global global_options
	global ui_options
	
    if {[info exists ui_options(current_run)] && $ui_options(current_run) != ""} {
        if {[string equal -nocase $::tcl_platform(platform) "unix"]} {
            catch { exec -- kill $ui_options(current_run) } result
        } else {
            catch { exec -- [file join $::quartus(binpath) killqw] \
						-t $ui_options(current_run) } result
        }
    }
	
	if { [catch {close $cmd_exec}] } {
			# Close the pipe
	}
		
	# Clear PID of current command running
	set ui_options(current_run) ""
	
	set ui_options(proccess_is_finish) 1
}

#############################################################################
##  Procedure:  post_command_proccesing_msg
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Post all the messages that command runs.
proc ::quartus::qsimlib_comp::gui::post_command_proccesing_msg { cmd_exec } {
	global ui_options
	
	if {[eof $cmd_exec]} {
		set ui_options(proccess_is_finish) 1
		return
    }

    if { [gets $cmd_exec line] < 0 } {
		return
    } else {
		if { [regexp {Error:} $line ] || [regexp {Fatal:} $line] } {
			::quartus::qsimlib_comp::gui::post_err_msg $line
			incr ui_options(error_count)
		} elseif { [regexp {Warning:} $line ] } {
			::quartus::qsimlib_comp::gui::post_warning_msg $line 
			incr ui_options(warning_count)
		} elseif { [regexp {Debug:} $line ] } {
			::quartus::qsimlib_comp::gui::post_debug_msg $line
		} else {
			::quartus::qsimlib_comp::gui::post_info_msg $line
		}
    }
	
	return
}

#############################################################################
##  Procedure:  post_err_msg
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Post error messages.
proc ::quartus::qsimlib_comp::gui::post_err_msg { args } {
	global widgets

	set messages [join $args]

	$widgets(text_msg) configure -state normal
	
	foreach line [split $messages "\n"] {
		$widgets(text_msg) insert end $line errortag
		$widgets(text_msg) insert end "\n"
		$widgets(text_msg) see end
	}
	
	$widgets(text_msg) configure -state disabled
}

#############################################################################
##  Procedure:  post_warning_msg
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Post warning messages.
proc ::quartus::qsimlib_comp::gui::post_warning_msg { args } {
	global widgets
	
	set messages [join $args]

	$widgets(text_msg) configure -state normal
	
	foreach line [split $messages "\n"] {
		$widgets(text_msg) insert end $line warningtag
		$widgets(text_msg) insert end "\n"
		$widgets(text_msg) see end
	}
	
	$widgets(text_msg) configure -state disabled
}

#############################################################################
##  Procedure:  post_info_msg
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Post info messages.
proc ::quartus::qsimlib_comp::gui::post_info_msg { args } {
	global widgets
	
	set messages [join $args]

	$widgets(text_msg) configure -state normal
	
	foreach line [split $messages "\n"] {
		$widgets(text_msg) insert end $line infotag
		$widgets(text_msg) insert end "\n"
		$widgets(text_msg) see end
	}
	
	$widgets(text_msg) configure -state disabled
}

#############################################################################
##  Procedure:  post_debug_msg
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Post debug messages.
proc ::quartus::qsimlib_comp::gui::post_debug_msg { args } {
	global widgets
	global global_options
	
	set messages [join $args]
	
	$widgets(text_msg) configure -state normal
	
	foreach line [split $messages "\n"] {
		$widgets(text_msg) insert end $line debugtag
		$widgets(text_msg) insert end "\n"
		$widgets(text_msg) see end
	}

	$widgets(text_msg) configure -state disabled
}
