#############################################################################
##  qboard_script.tcl
##
##  QBoard Graphical User Interface
##  This script allows a user to easily create a Quartus project
##  template based on an Altera Dev Kit (e.g. DE2)
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

#############################################################################
##  Additional Packages Required
package require BWidget
package require cmdline

#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::qboard::gui {
    
    namespace export main
    namespace export print_msg
    
    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

    variable app_name "Altera QBoard"
    variable app_path ""
    variable app_package_path ""
    variable app_icon_path ""
    variable app_window_icon
    variable progress_variable 0
    variable progress_max 100
    variable progress_text ""
    
    variable working_dir ""

    variable debug 0

    variable gui_mode 0

	variable project_info

	set project_info(name)  "<Select>"
	set project_info(revision) "<Select>"
	set project_info(verilog) 1
	set project_info(sdc) 0
#	set project_info(template_type) "altera_board"
#	set project_info(altera_board) ""

	variable altera_board_info
	variable altera_board_list
	variable board_name2id

}

#############################################################################
##  Procedure:  add_tool_bar_to_frame
##
##  Arguments:
##      Frame the bar should be added to
##
##  Description:
##      Add a Tool Bar with buttons to the main frame
proc ::qboard::gui::add_tool_bar_to_frame { frame } {
    
    set debug_name "::qboard::gui::add_tool_bar()"

    global widgets

    variable app_icon_path

    #
    # CREATE A TOOLBAR FOR THE MAINFRAME
    #
    addWidget toolbar1 [$frame  addtoolbar]

            #
            # ADD A BUTTON BOX AND BUTTONS TO THE TOOLBAR
            #
            set buttonbox [ButtonBox $widgets(toolbar1).bbox -spacing 0 -padx 2 -pady 2]

            # Generate Button
            addWidget buttonGenerate [$buttonbox add -image [Bitmap::get [file join $app_icon_path "start"]] -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 -command {::qboard::gui::on_generate} -helptext "Generate Project" -helptype balloon -anchor w]
            pack $buttonbox -side left -anchor w
            # Separator
            set sep [Separator $widgets(toolbar1).sep1 -orient vertical]
            pack $sep -side left -fill y -padx 4 -anchor w

            # Start Button & View Report Button & Create New Revision Button
            set buttonbox [ButtonBox $widgets(toolbar1).bbox2 -spacing 0 -padx 2 -pady 2]

            # Quartus Button
            addWidget buttonQuartus [$buttonbox add -image [Bitmap::get [file join $app_icon_path "pjm"]] -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 -command {::qboard::gui::on_open_quartus_gui} -helptext "Open Quartus II" -helptype balloon -anchor w]
            pack $buttonbox -side right -anchor w

}


#############################################################################
##  Procedure:  main
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the GUI for you. You should call this function and
##      run a vwait on the exit_qboard_gui variable. This is touched
##      when the GUI destroys itself.
proc ::qboard::gui::main {} {
    
    set debug_name "::qboard::gui::main()"

    global widgets

    #
    # IMPORT GLOBALS FOR THIS NAMESPACE
    #
    variable app_name
    variable app_path
    variable app_package_path
    variable app_icon_path
    variable app_window_icon
    variable gui_mode
	variable project_info
	variable altera_board_list

    #
    # TURN ON GUI CODE
    #
    set gui_mode 1

    #
    # CONFIGURE SOME PATHS USED BY THE SCRIPT
    #
    set app_path [file join $::quartus(tclpath) "apps" "qboard"]
    set app_package_path [file join $::quartus(tclpath) "packages" "qboard"]
    set app_icon_path [file join $::quartus(tclpath) "packages" "qboard"]

	# Look for available Altera Boards
	::qboard::gui::initialize_board_information_from_available_packages

    #
    # CONFIGURE THE FONTS USED IN THE GUI
    #
    option add *TitleFrame.l.font {helvetica 9 bold italic}
    option add *LabelFrame.l.font {helvetica 9}
    font create Tabs -family helvetica -size 10 -weight bold
    if {$::tcl_platform(platform) == "unix"} {
        option add *Dialog.msg.font {helvetica 12}
        option add *Dialog.msg.wrapLength 6i
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
    # SET THE ICON TO USE FOR QBOARD WINDOWS
    #
 #   if {$::tcl_platform(platform) == "unix"} {
#	set app_window_icon "@[file join $app_icon_path dse.xbm]"
#    } else {
#	set app_window_icon "[file join $app_icon_path dse.ico]"
#    }
#    wm iconbitmap . $app_window_icon

    #
    # CREATE THE USER MENUS AND MENU GROUPS FOR THE MAIN WINDOW
    #
    set menu_desc {
        "&File" all file 0 {
			{command "&New Project..." {DISABLE_DURING_COMPILE} {} {Ctrl N} -command "eval qboard::gui::on_new_project_dlg" }
			{command "&Open Project..." {DISABLE_DURING_COMPILE} {} {Ctrl O} -command "eval qboard::gui::on_open_project_dlg" }
			{command "&Close Project" {DISABLE_DURING_COMPILE} {} {} -command "eval qboard::gui::on_close_project" }
            {separator}
            {command "E&xit" {DISABLE_DURING_COMPILE} {} {Alt F4} -command {global widgets; destroy $widgets(mainframe)}}
        }
    }

    #
    # CREATE THE MAINFRAME FOR THE APPLICATION
    #
    addWidget mainframe [MainFrame .mainframe \
        -menu $menu_desc \
        -progressmax $::qboard::gui::progress_max \
        -progresstype normal \
        -progressvar ::qboard::progress_variable \
        -textvariable ::qboard::gui::progress_text ]

    #
    # ADD A STATUS LABEL
    #
    addWidget VersionLabel [$widgets(mainframe) addindicator -text " Quartus II $::quartus(version) "]


#	add_tool_bar_to_frame $widgets(mainframe)

        #
        # CREATE A NOTEBOOK TO HOLD THE DIFFERENT PANES
        #
        set pane [$widgets(mainframe) getframe]
        addWidget notebook [NoteBook $pane.nb -font Tabs]
    
            #
            # CREATE THE NOTEBOOK PAGE TO HOLD SETTINGS
            #
            addWidget configtab [$widgets(notebook) insert end config -text "  Settings  "]

                #
                # CREATE A FRAME FOR THE QII PROJECT SETTINGS
                #
                set titleFrameProjectSettings [TitleFrame $widgets(configtab).title_frame -text "Project Settings" -ipad 5]
                addWidget frameProjectSettings $titleFrameProjectSettings
                pack $titleFrameProjectSettings -fill both -expand no
                set fill_frame [$titleFrameProjectSettings getframe]
                pack $fill_frame

                    #
                    # LabelEntry TO HOLD PROJECT_NAME
                    #
                    addWidget labentProjectName [LabelEntry $fill_frame.pname -labelwidth 15 -label "Project:" -text "" -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(labentProjectName) configure -entrybg [$widgets(labentProjectName) cget -background]
	                $widgets(labentProjectName) configure -state disabled

#                    addWidget labentProjectName [LabelEntry $fill_frame.project -labelwidth 15 -label "Project:" -padx 2 -pady 2 -width 27 -textvariable {::qboard::gui::project_info(name)}]
                    pack $widgets(labentProjectName) -anchor nw -expand no -fill both -pady 2
    
                    #
                    # LabelEntry TO HOLD REVISION_NAME
                    #
                    set temp_frame [frame $fill_frame.tf1]
                    pack $temp_frame -fill both -expand yes -anchor nw -pady 2
                    addWidget labelRevisionName [Label $temp_frame.lrev -width 15 -text "Revision:" -justify left -state disabled -anchor w -padx 0]
                    pack $widgets(labelRevisionName) -anchor nw -expand no -side left
	                addWidget cboxRevisionName [ComboBox $temp_frame.cname -values [list] \
                                                -editable 0 -width 25  -modifycmd {print_msg -debug "Change Revision"}]
                    $widgets(cboxRevisionName) setvalue first
                    pack $widgets(cboxRevisionName) -anchor nw -expand no -fill none

#                    addWidget labentRevisionName [LabelEntry $fill_frame.revision -labelwidth 15 -label "Revision:" -padx 2 -pady 2 -width 27 -textvariable {::qboard::gui::project_info(revision)}]
#                    pack $widgets(labentRevisionName) -anchor nw -side top -expand no -fill both -pady 2
                    
                #
                # CREATE A FRAME FOR THE TEMPLATE SELECTION
                #
                set titleFrameTemplates [TitleFrame $widgets(configtab).template_frame -text "Select Template" -ipad 5]
                addWidget frameQuickTemplates $titleFrameTemplates
                pack $titleFrameTemplates -fill both -expand no
                set fill_frame [$titleFrameTemplates getframe]
                pack $fill_frame
    
                    #
                    # CREATE A SUB FRAME TO HOLD A radiobutton + Label + ComboBox FOR DevKit
                    #
                    set temp_frame [frame $fill_frame.tf2 -pady 2]
                    pack $temp_frame -fill both -expand yes
                    addWidget radioAltr [radiobutton $temp_frame.aboard -text "Project based on Altera DevKit" -variable ::qboard::gui::project_info(template_type) -value "altera_board"]
					$widgets(radioAltr) select
                    pack $widgets(radioAltr) -anchor nw -expand yes
                    addWidget labelAltrBoardName [Label $temp_frame.lblspeed -text "    Board Name:" -relief flat -padx 10]
                    pack $widgets(labelAltrBoardName) -anchor nw -side left
					addWidget cboxAltrBoardName [ComboBox $temp_frame.combobox -textvariable ::qboard::gui::project_info(altera_board) -values $::qboard::gui::altera_board_list -editable 0 -width 40]
                    $widgets(cboxAltrBoardName) setvalue first
                    pack $widgets(cboxAltrBoardName) -anchor nw -expand yes -fill both

                    #
                    # CREATE A SUB FRAME TO HOLD A radiobutton FOR CUSTOM
                    #
                    set temp_frame [frame $fill_frame.tf1 -pady 2] 
                    pack $temp_frame -fill both -expand yes
                    addWidget radioCustom [radiobutton $temp_frame.rbarea -text "Custom Project" -variable ::qboard::gui::project_info(template_type) -value "custom" -pady 10]
                    pack $widgets(radioCustom) -anchor w -side top -expand no
                    
                #
                # CREATE A FRAME FOR THE OPTIONS
                #
                set titleFrameOptions [TitleFrame $widgets(configtab).options_frame -text "Options" -ipad 5]
                addWidget frameOptions $titleFrameOptions
                pack $titleFrameOptions -fill both -expand no
                set fill_frame [$titleFrameOptions getframe]
                pack $fill_frame

                    #
                    # CREATE A SUB FRAME TO HOLD SOME checkbuttons
                    #
                    set temp_frame [frame $fill_frame.tf1b]
                    pack $temp_frame -fill both -expand yes -anchor nw -pady 10
                    addWidget verilog [checkbutton $temp_frame.check_v -text "Create Top Level Verilog Template" -pady 5 -padx 10 -variable {::qboard::gui::project_info(verilog)} -pady 2]
                    pack $widgets(verilog) -anchor nw -expand yes -side top
                    addWidget sdc [checkbutton $temp_frame.check_sdc -text "Use TimeQuest (create SDC template)" -pady 5 -padx 10 -variable {::qboard::gui::project_info(sdc)} -pady 2]
                    pack $widgets(sdc) -anchor nw -expand yes -side top
                    
            #
            # CREATE THE NOTEBOOK PAGE TO HOLD ADVANCED SETTINGS
            #
            addWidget messagestab [$widgets(notebook) insert end messages -text "  Messages  "]

                #
                # CREATE A FRAME FOR THE MESSAGES
                #
                addWidget frameMessages [TitleFrame $widgets(messagestab).tfMessages -text "Log" -ipad 2]
                pack $widgets(frameMessages) -anchor nw -expand yes -fill both


                    # 
                    # ADD THE MESSAGES TEXT AREA
                    #
                    set f [$widgets(frameMessages) getframe]
                    addWidget swMessages [ScrolledWindow $f.sw -auto none]
                    addWidget txtMessages [text $widgets(swMessages).txtmsgs -relief sunken -wrap none -width 70 -height 10]
					$widgets(txtMessages) tag configure infotag -foreground black -font  {Courier 10 bold}
                    $widgets(txtMessages) tag configure errortag -foreground red -font  {Courier 10 bold}
                    $widgets(txtMessages) tag configure warningtag -foreground blue -font  {Courier 10 bold}
                    $widgets(txtMessages) tag configure debugtag -foreground darkgreen -font  {Courier 10 bold}
                    $widgets(txtMessages) configure -state disabled
                    $widgets(swMessages) setwidget $widgets(txtMessages)
                    pack $widgets(swMessages) -expand yes -fill both

        #
        # PACK THE NOTEBOOK THAT HOLDS EVERYTHING
        #
        $widgets(notebook) compute_size
        pack $widgets(notebook) -fill both -expand yes
        $widgets(notebook) raise config

	#
    # CREATE GENERATE BUTTON
    #
    addWidget frameButtons [frame $widgets(mainframe).butfr]
	addWidget generate [Button $widgets(frameButtons).gen_button \
                               -image [Bitmap::get [file join $app_icon_path "start"]] \
                               -repeatdelay 300 \
                               -command  {::qboard::gui::on_generate} \
                               -helptext "Generate Project"]
    pack $widgets(generate) -anchor s -side top -expand no -pady 10
    pack $widgets(frameButtons) -fill both -expand yes

    #
    # PACK THE TOPLEVEL WINDOW FOR EVERYTHING
    #
    pack $widgets(mainframe) -fill both -expand yes
    				

    update idletasks

    # Make sure when the user destroys the application
    # the project settings are stored in qflow project file
    bind $widgets(mainframe) <Destroy> {::qboard::gui::close_gui}

    #
    # SHOW THE TOP-LEVEL WINDOW, CENTERED IN THE USER'S DISPLAY
    #
    BWidget::place . 0 0 center
    wm deiconify .
    raise .
    focus -force .
    
    return 1
}


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
proc ::qboard::gui::addWidget {_wname _truename} {

    # Import global namespace variables
    global widgets
    variable debug

    # Error if widget name already exists
    if {[info exists widgets($_wname)]} {
        return -code error "Widget with name $_wname already exists!"
    }

    # Add it
    set widgets($_wname) $_truename
    if {$debug} {
        puts "::quartus::dse::gui::addWidget(): $_wname -> $_truename"
    }

    return 1
}

#############################################################################
##  Procedure:  print_msg
##
##  Arguments:
##      str
##          String to print in the message area.
##
##  Description:
##      Updates the progress message.
proc ::qboard::gui::print_msg {args} {

    # Import global namespace variables
    global widgets
    variable gui_mode

    if {!$gui_mode} {
        return 1
    }

    # Command line options to this function we require
    lappend function_opts [list "info" 1 ""]
    lappend function_opts [list "debug" 0 ""]
    lappend function_opts [list "error" 0 ""]
    lappend function_opts [list "warning" 0 ""]

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "Missing required option: -$opt"
        }
    }

    if {$optshash(info)} {
		set prefix "Info: "
        set tagname "infotag"
    } elseif {$optshash(debug)} {
		set prefix "Debug: "
        set tagname "debugtag"
    } elseif {$optshash(error)} {
		set prefix "Error: "
        set tagname "errortag"
    } elseif {$optshash(warning)} {
		set prefix "Warning: "
        set tagname "warningtag"
    }

    catch {$widgets(txtMessages) configure -state normal}
    catch {$widgets(txtMessages) insert end "$prefix [lindex $args 0]" $tagname}
    catch {$widgets(txtMessages) insert end "\n"}
    catch {$widgets(txtMessages) see end}
    catch {$widgets(txtMessages) configure -state disabled}

	# Give focus to the "Messages" tab
    $widgets(notebook) raise messages

    return 1
}

#############################################################################
##  Procedure:  close_gui
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Clean up. Close it down.
proc ::qboard::gui::close_gui {args} {
    global exit_qboard_gui

    set exit_qboard_gui 1
    return $exit_qboard_gui
}

# ----------------------------------------------------------------
#
proc qboard::gui::on_new_project_dlg {} {
#
# Description:	Dialog Box to create project
#
# ----------------------------------------------------------------

	variable app_name

	set typelist {
		{"Project Files" {".qpf"}}
		{"All Files" {"*.*"}}
	}

	if { [is_project_open] } {
		set dlg_result [tk_messageBox -type yesno -message "Project is already open. OK to close first?" -title "$qboard::gui::app_name" -icon question]
		if { [string match $dlg_result "yes"] } {
			qboard::gui::on_close_project
		} else {
			# Exit without showing open DLG
			return
		}
	}

	set project_file_name [tk_getSaveFile -filetypes $typelist -title "New Project" -defaultextension ".qpf"]
	if { $project_file_name == "" } {
		qboard::gui::print_msg -debug "No project was created"
		qboard::gui::on_close_project
	} else {
		set qboard::gui::project_info(dir) [file dirname $project_file_name]
		cd $qboard::gui::project_info(dir)
		set qboard::gui::project_info(name) [file rootname [file tail $project_file_name]]
		# Display files in tree structure in left window pane in files tab
	
		# Open/Create Project
		if { [project_exists $qboard::gui::project_info(name)] } {	
			# Need to delete all project files first
			file delete -force db
			file delete -force ${qboard::gui::project_info(name)}.qsf
			file delete -force ${qboard::gui::project_info(name)}.qpf
		}

		qboard::gui::create_project
	}
}

# ----------------------------------------------------------------
#
proc qboard::gui::on_open_project_dlg {} {
#
# Description:	Dialog Box to open project
#
# ----------------------------------------------------------------

	variable project_info
	variable app_name

	set typelist {
		{"Project Files" {".qpf"}}
	}

	if { [is_project_open] } {
		set dlg_result [tk_messageBox -type yesno -message "Project is already open. OK to close first?" -title "$qboard::gui::app_name" -icon question]
		if { [string match $dlg_result "yes"] } {
			qboard::gui::on_close_project
		} else {
			# Exit without showing open DLG
			return
		}
	}

	set project_file_name [tk_getOpenFile -filetypes $typelist -title "Open a Project"]
	if { $project_file_name == "" } {
		qboard::gui::print_msg -debug "No project was open"
		qboard::gui::on_close_project
	} else {
		set qboard::gui::project_info(dir) [file dirname $project_file_name]
		cd $qboard::gui::project_info(dir)
		set qboard::gui::project_info(name) [file rootname [file tail $project_file_name]]
		# Display files in tree structure in left window pane in files tab
	
		# Open/Create Project
		if { ![project_exists $qboard::gui::project_info(name)] } {
			set dlg_result [tk_messageBox -type yesno -message "$qboard::gui::app_name Project does not exist. OK to create?" -title "$qboard::gui::app_name" -icon question]
			if { [string match $dlg_result "yes"] } {
				qboard::gui::create_project
			}
				
			# Exit without showing open DLG
			return
		}

		qboard::gui::open_project
	}
}

# ----------------------------------------------------------------
#
proc qboard::gui::on_close_project {} {
#
# Description:	Close Project
#
# ----------------------------------------------------------------

	if { [is_project_open] } {
		export_assignment_files
		project_close
		qboard::gui::print_msg -debug "Closed project: $qboard::gui::project_info(name)"
	} else {
		qboard::gui::print_msg -error "No project is open"
	}
	
	# Make sure everything is disabled
	wm title . "$qboard::gui::app_name"
		
}

# ----------------------------------------------------------------
#
proc qboard::gui::update_after_project_opend { project } {
#
# Description:	Update all variables after a project is open
#               or created
#
# ----------------------------------------------------------------

	global widgets
	variable app_name

	# Only set the project if there were no errors
	set qboard::gui::project_info(name) $project
	set qboard::gui::project_info(revision) [get_current_revision $project]

	# Rename the title
	wm title . "$qboard::gui::app_name - $project"

	# Update Project and Revision fields
	$widgets(labentProjectName) configure -text $qboard::gui::project_info(name)
	$widgets(cboxRevisionName) configure -values [get_project_revisions $qboard::gui::project_info(name)]
	$widgets(cboxRevisionName) setvalue first
	$widgets(labentProjectName) configure -state normal
	$widgets(labelRevisionName) configure -state normal
	$widgets(cboxRevisionName) configure -state normal

	set ::qboard::gui::progress_text ""

}

# ----------------------------------------------------------------
#
proc qboard::gui::open_project { } {
#
# Description:	Open Project
#
# ----------------------------------------------------------------

	set project $qboard::gui::project_info(name)
	set cmd "::project_open $project -current_revision"
	set msg [eval $cmd]
	if {[string length $msg] > 0} {
		regsub {^WARNING: } $msg "" msg
		qboard::gui::print_msg -warning $msg
	}

	qboard::gui::update_after_project_opend $project
}

# ----------------------------------------------------------------
#
proc qboard::gui::create_project { } {
#
# Description:	Create Project
#
# ----------------------------------------------------------------

	set project $qboard::gui::project_info(name)
	set cmd "::project_new $project"
	set msg [eval $cmd]

	if {[string length $msg] > 0} {
		regsub {^WARNING: } $msg "" msg
		qboard::gui::print_msg -warning $msg
	}

	qboard::gui::update_after_project_opend $project
}


# ----------------------------------------------------------------
#
proc qboard::gui::on_open_quartus_gui {} {
#
# Description:	Open Quartus II Official GUI
#
# ----------------------------------------------------------------

	if { ![is_project_open] } {
		qboard::gui::::print_error "No project is open"
		return
	}

	set exe_name [file join $::quartus(binpath) quartus]
	eval exec $exe_name ${qboard::gui::project_info(name)} &
}	

# ----------------------------------------------------------------
#
proc qboard::gui::show_board_statistics { board_name } {
#
# Description:	Show some key statistics about
#               the board based on assignments
#
# ----------------------------------------------------------------

	set family [get_global_assignment -name FAMILY]
	set device [get_global_assignment -name DEVICE]

	::qboard::gui::print_msg -info "Family = $family"
	::qboard::gui::print_msg -info "Device = $device"
}

# ----------------------------------------------------------------
#
proc ::qboard::gui::create_top_level_template { board_name } {
#
# Description: Generate top level Verilog template
#
# ----------------------------------------------------------------

	set board_id $::qboard::gui::board_name2id($board_name)

	# Copy file
	set template_file "[file join $::qboard::gui::app_package_path ${board_id}_template.v]"
	set source_dir "[file join [pwd] source]"
	# Make "source" directory if needed
	catch { file mkdir $source_dir }
	set new_file "[file join $source_dir top.v]"
	set qsf_name "[file join source top.v]"
	if [file exists $template_file] {
		qboard::gui::print_msg -info "Creating $qsf_name"
		file copy -force $template_file $new_file

		# Add required QSF settings for template
		set_global_assignment -name TOP_LEVEL_ENTITY top 
		set_global_assignment -name SOURCE_FILE "$qsf_name" -tag qboard

	} else {
		qboard::gui::print_msg -debug "Top level template not found ($template_file)"
		qboard::gui::print_msg -info "No Verilog template available for this board"
	}
}

# ----------------------------------------------------------------
#
proc ::qboard::gui::create_sdc_template { board_name } {
#
# Description: Generate SDC Template
#
# ----------------------------------------------------------------

	set board_id $::qboard::gui::board_name2id($board_name)

	# Copy file
	set template_file "[file join $::qboard::gui::app_package_path ${board_id}_template.sdc]"
	set new_file "[file join [pwd] ${board_id}.sdc]"
	set qsf_name "${board_id}.sdc"
	if [file exists $template_file] {
		qboard::gui::print_msg -info "Creating $qsf_name"
		file copy -force $template_file $new_file

		# Add required QSF settings for template
		set_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER ON 
		set_global_assignment -name SDC_FILE "$qsf_name" -tag qboard

	} else {
		qboard::gui::print_msg -debug "SDC template not found ($template_file)"
		qboard::gui::print_msg -info "No SDC template available for this board"
	}
}

# ----------------------------------------------------------------
#
proc ::qboard::gui::force_best_practices_assignments { } {
#
# Description: Set up design in best possible mode
#
# ----------------------------------------------------------------

	# Useful global settings
	set_global_assignment -name PROJECT_SHOW_ENTITY_NAME OFF -tag qboard
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output -tag qboard
}

# ----------------------------------------------------------------
#
proc qboard::gui::on_generate {} {
#
# Description:	Make default assignments
#
# ----------------------------------------------------------------

	global widgets

	if { ![is_project_open] } {
		qboard::gui::::print_msg -error "No project is open"
		return
	}

	set ::qboard::gui::progress_text "Generating..."
	$widgets(mainframe) showstatusbar progression
	set ::qboard::gui::progress_variable 10

	print_msg -debug "---> Template   = $::qboard::gui::project_info(template_type)"
	switch -- $::qboard::gui::project_info(template_type) {
		"altera_board" {
			set board_name $::qboard::gui::project_info(altera_board)
			print_msg -debug "---> Board Name = $board_name"
			set board_id $::qboard::gui::board_name2id($board_name)
			print_msg -debug "---> Board ID   = $board_id"
			
			qboard::gui::print_msg -info "========================================="
			qboard::gui::print_msg -info "Using $board_name Package Ver. [::qboard::${board_id}::get_revision]"
			qboard::gui::print_msg -info "========================================="
			set ::qboard::gui::progress_variable 20
			eval ::qboard::${board_id}::set_default_assignments
			set ::qboard::gui::progress_variable 60
		}
		"custom" {
			set board_name custom
			set_global_assignment -name FAMILY "Cyclone II" -tag qboard
		}
		default { print_msg -error "No template type" }
	}

	if $::qboard::gui::project_info(verilog) {
		::qboard::gui::create_top_level_template $board_name
	}

	if $::qboard::gui::project_info(sdc) {
		::qboard::gui::create_sdc_template $board_name
	}

	# Add some useful assignments
	::qboard::gui::force_best_practices_assignments

	export_assignment_files

	::qboard::gui::show_board_statistics $board_name

	::qboard::gui::print_msg -info "========================================="
	::qboard::gui::print_msg -info ""

	set ::qboard::gui::progress_variable 100
	set ::qboard::gui::progress_text "Done"

	set dlg_result [tk_messageBox -type yesno -message "Project Generated Successfully. Do you want to exit and start Quartus?" -title "QBoard Status" -icon question]
	if { [string match $dlg_result "yes"] } {

		# Launch Quartus
		::qboard::gui::on_open_quartus_gui

		# Now Exit
		set ::exit_qboard_gui 1
	}
}	

#############################################################################
##  Procedure:  initialize_board_information_from_available_packages
##
##  Arguments:
##      None
##
##  Description:
##      Look for all files of the form qboard-<id>-pkg.tcl under
##      the QBoard packages directory, and for each one, package require
##      it and get its name.
##      Build the altera_board_info and altera_board_list with it
proc ::qboard::gui::initialize_board_information_from_available_packages {} {

    variable app_package_path
	variable altera_board_info
	variable altera_board_list
	variable board_name2id

	foreach pkg [glob [file join $app_package_path qboard-*-pkg.tcl]] {

		# Parse assuming "qboard-<board_id>-pkg.tcl"
		set name_elements [split $pkg "-"]
		set board_id [lindex $name_elements 1]

		# Load Package
		package require ::qboard::${board_id}

		set board_name [::qboard::${board_id}::get_name]
		set altera_board_info($board_id) $board_name
		lappend altera_board_list $board_name

		set board_name2id($board_name) $board_id
	}
}

set exit_qboard_gui 0
::qboard::gui::main
# And wait to exit
vwait exit_qboard_gui

