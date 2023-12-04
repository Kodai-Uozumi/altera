#############################################################################
##  gui-lib.tcl
##
##  Design Space Explorer graphical user interface.
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

package provide ::quartus::dse::gui 1.0


#############################################################################
##  Additional Packages Required
package require BWidget
package require cmdline
package require ::quartus::dse::ccl
package require ::quartus::dse::flows
package require ::quartus::dse::designspace
package require ::quartus::dse::seed
package require ::quartus::dse::logiclock
package require ::quartus::misc
package require ::quartus::hh
package require ::quartus::project


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse::gui {

    namespace export main
    namespace export update_progress
    namespace export update_base_result
    namespace export update_best_result
    namespace export print_msg

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable app_name "Altera Design Space Explorer"
    variable app_path ""
    variable app_package_path ""
    variable app_icon_path ""
    variable app_window_icon

    variable working_dir ""

    variable selected_quick_optimization "area"
    variable available_speed_effort_levels [list "Low (Seed Sweep)" "Medium (Extra Effort Space)"]

    variable selected_optimization_goal "Optimize for Speed"
    variable available_optimization_goals [list "Optimize for Speed" "Optimize for Area" "Optimize for Power" "Optimize for Negative Slack and Failing Paths" "Optimize for Average Period" "Optimize for Quality of Fit"]
    variable selected_decision_function

    variable available_search_methods [list "Accelerated Search of Exploration Space" "Exhaustive Search of Exploration Space"]
    variable selected_flow_function

    variable available_exploration_spaces [list]
    variable selected_exploration_space

    variable procGetDescriptionForSpace
    variable procGetValidSpaces
    variable procIsValidSpace
    variable procSetDesignSpace
    variable procHasRecipe
    variable procGetRecipe

	variable advanced_use 0

    variable progress_variable
    variable progress_max
    variable progress_text

    variable estimated_time_text

    # The context-sensitive help module
    variable hh

}


#############################################################################
##  Procedure:  main
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the GUI for you. You should call this function and
##      run a vwait on the exit_dse_gui variable. This is touched
##      when the GUI destroys itself.
proc ::quartus::dse::gui::main {args} {

    set debug_name "::quartus::dse::gui::main()"

    global widgets
	global global_dse_options

    #
    # IMPORT GLOBALS FOR THIS NAMESPACE
    #
    variable app_name
    variable app_path
    variable app_package_path
    variable app_icon_path
    variable app_window_icon
    variable available_exploration_spaces
    variable progress_variable
    variable progress_max
    variable progress_text
	variable advanced_use

    #
    # PARSE COMMAND LINE OPTIONS TO THIS FUNCTION
    #
    lappend function_opts [list "project.arg" "#_optional_#" "Optional project open right away"]
    lappend function_opts [list "revision.arg" "#_optional_#" "Optional revision name to use when opening -project"]
    lappend function_opts [list "archive" 0 "Archive all compilations not just base and best"]
    lappend function_opts [list "ignore-failed-base" 0 "Ignore a failing base compile and continue with exploration"]
    lappend function_opts [list "run-power" 0 "True if you want to run quartus_pow at the end of the flow"]

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    #
    # MAKE SURE ALL COMMAND LINE OPTIONS WERE RECIEVED
    #
    set cont 1
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "Missing required option: -${opt}"
        }
    }

	#
	# CHECK FOR ADVANCED USE MODE, TURN ON IF NECESSARY
	#
	::quartus::dse::ccl::dputs "$debug_name: Checking value of ini variable dse_advaced_mode = [get_ini_var -name dse_advanced_mode]"
	if {[regexp -nocase -- {on} [get_ini_var -name dse_advanced_mode]]} {
		variable advanced_use 1
	}

    #
    # READ IN A CONFIGURATION FILE
    #
    # Set up the default GUI section options
    set global_dse_options(gui-seeds) "3 5 7 11"
    set global_dse_options(gui-stop-after-time-default) "dd:hh:mm"
    set global_dse_options(gui-stop-after-time) $global_dse_options(gui-stop-after-time-default)
    set global_dse_options(gui-archive) "0"
    set global_dse_options(gui-ignore-failed-base) "0"
    set global_dse_options(gui-skip-base) "0"
    set global_dse_options(gui-run-power) "0"
    set global_dse_options(gui-dump-space-to-file) "0"
    set global_dse_options(gui-custom-space-file-default) ""
    set global_dse_options(gui-custom-space-file) $global_dse_options(gui-custom-space-file-default)
    set global_dse_options(gui-slack-column) "#_default_#"
    set global_dse_options(gui-slack-column-list) [list "Worst-case Slack" "Clock Setup: '<clock name>': Slack" "Clock Setup: '*': Slack" "Worst-case tco: Slack" "Worst-case Minimum tco: Slack" "Worst-case th: Slack" "Worst-case tsu: Slack" "<any column name>"]
    set global_dse_options(gui-slack-column-index) "first"
    set global_dse_options(gui-project-uses-qiiis) 0
    set global_dse_options(gui-project-try-llr-restructuring) "0"
    set global_dse_options(gui-concurrent-compiles) 1
    set global_dse_options(gui-distribute-compiles) 0
	set global_dse_options(gui-distribute-using) "qslave"
    set global_dse_options(gui-lsf-queue) "<default>"
    set global_dse_options(gui-lsf-queue-list) [list "<default>"]
    set global_dse_options(gui-lsf-queue-index) "first"
	set global_dse_options(gui-abc-system) "Toronto Technology Center"
	set global_dse_options(gui-abc-system-list) [list "Toronto Technology Center" "San Jose Software Department" "Boston Sales Office" "Ottawa Sales Office"]
	set global_dse_options(gui-abc-system-index) "first"
	set global_dse_options(gui-abc-group) "software"
	set global_dse_options(gui-abc-group-list) [list "software"]
	set global_dse_options(gui-abc-group-index) "first"
    set global_dse_options(gui-slave-machine-list) [list]
    set global_dse_options(gui-report-all-resource-usage) 0
	set global_dse_options(gui-revision-merge-mode) "new"
	set global_dse_options(gui-revisions-only) 0
	set global_dse_options(gui-show-full-project-path-in-title-bar) 0
	if {$global_dse_options(dse-debug)} {
		::quartus::dse::ccl::read_state_from_disk
	} else {
		catch {::quartus::dse::ccl::read_state_from_disk}
	}
    #
    # Some options should never be saved. We'll over write these here
    # with the defaults that we like to see.
    #
    set global_dse_options(gui-slack-column) "#_default_#"
    set global_dse_options(gui-slack-column-index) "first"
    set global_dse_options(gui-slack-column-list) [list "Worst-case Slack" "Clock Setup: '<clock name>': Slack" "Clock Setup: '*': Slack" "Worst-case tco: Slack" "Worst-case Minimum tco: Slack" "Worst-case th: Slack" "Worst-case tsu: Slack" "<any column name>"]
    set global_dse_options(gui-custom-space-file) $global_dse_options(gui-custom-space-file-default)
    set global_dse_options(gui-recent-project-selection) "#_optional_#"

    #
    # CONFIGURE SOME PATHS USED BY THE SCRIPT
    #
    set app_path [file join $::quartus(tclpath) "apps" "dse"]
    set app_package_path [file join $::quartus(tclpath) "packages" "dse"]
    set app_icon_path [file join $::quartus(tclpath) "packages" "dse"]

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
    # SET THE ICON TO USE FOR DSE WINDOWS
    #
    if {$::tcl_platform(platform) == "unix"} {
	set app_window_icon "@[file join $app_icon_path dse.xbm]"
    } else {
	set app_window_icon "[file join $app_icon_path dse.ico]"
    }
    wm iconbitmap . $app_window_icon

    #
    # CREATE THE USER MENUS AND MENU GROUPS FOR THE MAIN WINDOW
    # There are two versions of the menu: the standard version and the version
	# we show when the user has added dse_advanced_mode = on to their quartus.ini
	# file.
    ::quartus::dse::ccl::dputs "$debug_name: Generating list of recent projects for menu"
    set recent_projects [list]
	foreach rp [get_user_option -name RECENT_PROJECTS] {
		if {[project_exists $rp]} {
            ::quartus::dse::ccl::dputs "$debug_name:    Found: $rp"
			lappend recent_projects [list radiobutton "$rp" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-recent-project-selection)} -value "$rp" -command {::quartus::dse::gui::on_open_recent_project}]
		} else {
            ::quartus::dse::ccl::dputs "$debug_name:    Missing: $rp"
        }
	}
    set file_menu [list \
        "&File" all file 0 [list \
			[list command "&Open Project..." {DISABLE_DURING_COMPILE} {} {Ctrl O} -command {::quartus::dse::gui::on_open_project}] \
            [list command "&Close Project" {DISABLE_DURING_COMPILE} {} {Ctrl F4} -command {::quartus::dse::gui::on_close_project}] \
			[list separator] \
            [list cascad "&Recent Projects" {DISABLE_DURING_COMPILE} recentprojects 0 $recent_projects] \
            [list separator] \
            [list command "E&xit" {DISABLE_DURING_COMPILE} {} {Alt F4} -command {global widgets; destroy $widgets(mainframe)}] \
        ] \
    ]
    set processing_menu [list \
        "&Processing" all file 0 [list \
            [list command "Explore &Space" {PROJECT_OPEN} {} {Ctrl S} -command {::quartus::dse::gui::on_start_exploration}] \
            [list separator] \
            [list command "&View Last DSE Report for Project..." {PROJECT_OPEN} {} {Ctrl R} -command {::quartus::dse::gui::on_view_report}] \
            [list command "&Create a Revision From a DSE Point..." {PROJECT_OPEN} {} {} -command {::quartus::dse::gui::on_create_or_merge_revision}] \
            [list command "Open Project in &TimeQuest Timing Analyzer..." {PROJECT_OPEN_STA} {} {Ctrl T} -command {::quartus::dse::gui::on_open_project_in_timequest}] \
            [list command "Open Project in &Quartus II..." {PROJECT_OPEN} {} {Ctrl Q} -command {::quartus::dse::gui::on_open_project_in_quartus}] \
        ] \
    ]
    set parallel_menu [list \
        "P&arallel DSE" all distributedopts 0 [list \
			[list checkbutton "Distribute Compilations to Other Machines" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-distribute-compiles)}] \
            [list command "Configure Resources..." {DISABLE_DURING_COMPILE} {} {} -command {::quartus::dse::gui::on_configure_resources}] \
            [list cascad "Concurrent Local Compilations" {DISABLE_DURING_COMPILE} parallelopts 0 [list \
				[list radiobutton "0" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-concurrent-compiles)} -value 0 -command {::quartus::dse::gui::on_select_concurrent_compiles}] \
				[list radiobutton "1" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-concurrent-compiles)} -value 1 -command {::quartus::dse::gui::on_select_concurrent_compiles}] \
				[list radiobutton "2" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-concurrent-compiles)} -value 2 -command {::quartus::dse::gui::on_select_concurrent_compiles}] \
				[list radiobutton "3" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-concurrent-compiles)} -value 3 -command {::quartus::dse::gui::on_select_concurrent_compiles}] \
				[list radiobutton "4" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-concurrent-compiles)} -value 4 -command {::quartus::dse::gui::on_select_concurrent_compiles}] \
				[list radiobutton "5" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-concurrent-compiles)} -value 5 -command {::quartus::dse::gui::on_select_concurrent_compiles}] \
				[list radiobutton "6" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-concurrent-compiles)} -value 6 -command {::quartus::dse::gui::on_select_concurrent_compiles}] \
			] ]\
        ] \
    ]
    set options_menu [list \
        "&Options" all options 0 [list \
            [list checkbutton "&Continue Exploration Even if Base Compilation Fails" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-ignore-failed-base)}] \
            [list checkbutton "&Skip Base Analysis & Compilation if Possible" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-skip-base)}] \
            [list checkbutton "Stop Flow When &Zero Failing Paths Are Achieved" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-stop-after-zero-failing-paths)}] \
            [list command "Stop Flow After &Time..." {DISABLE_DURING_COMPILE} {} {} -command {::quartus::dse::gui::on_stop_after_time}] \
            [list separator] \
            [list checkbutton "Report all Resource &Usage Information" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-report-all-resource-usage)}] \
            [list checkbutton "&Archive all Compilations" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-archive)}] \
            [list checkbutton "Create Revisions Without Compiling" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-revisions-only)}] \
            [list separator] \
            [list checkbutton "&Run Quartus II PowerPlay Power Analyzer During Exploration" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-run-power)}] \
            [list separator] \
            [list checkbutton "Show Full Path to Project in Title Bar" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-show-full-project-path-in-title-bar)}] \
        ] \
    ]
    set help_menu [list \
        "&Help" all help 0 [list \
			[list command "&Contents" {ALWAYS_AVAILABLE} {} {F1} -command {::quartus::dse::gui::on_help -page /dse/dse_about_dse.htm}] \
            [list separator] \
            [list command "&About DSE" {ALWAYS_AVAILABLE} {} {} -command {::quartus::dse::gui::on_about_dse}] \
		] \
    ]

	if {!$advanced_use} {
		# We we're in standard mode there are some flow options that are forced to their default values
		set global_dse_options(gui-dump-space-to-file) 0
		set global_dse_options(gui-lower-priority) 0
		set global_dse_options(gui-revisions-only) 0
	} else {
		# The advanced user menu
        set options_menu [list \
            "&Options" all options 0 [list \
                [list checkbutton "&Continue Exploration Even if Base Compilation Fails" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-ignore-failed-base)}] \
                [list checkbutton "&Skip Base Analysis & Compilation if Possible" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-skip-base)}] \
                [list checkbutton "Stop Flow When &Zero Failing Paths Are Achieved" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-stop-after-zero-failing-paths)}] \
                [list command "Stop Flow After &Time..." {DISABLE_DURING_COMPILE} {} {} -command {::quartus::dse::gui::on_stop_after_time}] \
                [list separator] \
                [list checkbutton "Report all Resource &Usage Information" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-report-all-resource-usage)}] \
                [list checkbutton "&Archive all Compilations" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-archive)}] \
                [list checkbutton "Create Revisions Without Compiling" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-revisions-only)}] \
                [list separator] \
                [list checkbutton "&Run Quartus II PowerPlay Power Analyzer During Exploration" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-run-power)}] \
                [list separator] \
                [list checkbutton "Show Full Path to Project in Title Bar" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-show-full-project-path-in-title-bar)}] \
                [list cascad "Advanced" {} advancedopts 0 [list \
                    [list checkbutton "&Save Exploration Space to File" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-dump-space-to-file)}] \
                    [list command "Change &Decision Column..." {DISABLE_DURING_COMPILE} {} {} -command {::quartus::dse::gui::on_change_decision_column}] \
                    [list command "Custom Space &File..." {DISABLE_DURING_COMPILE} {} {} -command {::quartus::dse::gui::on_choose_custom_space_file}] \
                    [list checkbutton "Lower Priority of Compilation Threads" {DISABLE_DURING_COMPILE} {} {} -variable {global_dse_options(gui-lower-priority)}] \
                ] ]\
            ] \
        ]
	}
    # Generate the entire menu bar menu now...
    set menu_desc [concat $file_menu $processing_menu $parallel_menu $options_menu $help_menu ]

    #
    # CREATE THE MAINFRAME FOR THE APPLICATION
    #
    set progress_variable 0
    set progress_max 100
    set progress_text ""
    addWidget mainframe [MainFrame .mainframe \
        -menu $menu_desc \
        -progressmax $::quartus::dse::gui::progress_max \
        -progresstype normal \
        -progressvar ::quartus::dse::gui::progress_variable \
        -textvariable ::quartus::dse::gui::progress_text ]

    #
    # ADD A STATUS LABEL
    #
    addWidget elapsedTimeStatusExploration [$widgets(mainframe) addindicator -text " [get_quartus_legal_string -product] $::quartus(version) "]

        #
        # CREATE A TOOLBAR FOR THE MAINFRAME
        #
        addWidget toolbar1 [$widgets(mainframe) addtoolbar]

            #
            # ADD A BUTTON BOX AND BUTTONS TO THE TOOLBAR
            #
            set buttonbox [ButtonBox $widgets(toolbar1).bbox -spacing 0 -padx 2 -pady 2]
            # Open Button
            addWidget buttonOpen [$buttonbox add -image [Bitmap::get [file join $app_icon_path "open"]] -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 -command {::quartus::dse::gui::on_open_project} -helptext "Open a Quartus II Project (Ctrl+O)" -helptype balloon -anchor w]
            pack $buttonbox -side left -anchor w
            # Separator
            set sep [Separator $widgets(toolbar1).sep1 -orient vertical]
            pack $sep -side left -fill y -padx 4 -anchor w
            # Start Button & View Report Button & Create New Revision Button
            set buttonbox [ButtonBox $widgets(toolbar1).bbox2 -spacing 0 -padx 2 -pady 2]
            addWidget buttonStart [$buttonbox add -image [Bitmap::get [file join $app_icon_path "start"]] -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 -command {::quartus::dse::gui::on_start_exploration} -helptext "Explore Space (Ctrl+S)" -helptype balloon -anchor w]
            addWidget buttonViewReport [$buttonbox add -image [Bitmap::get [file join $app_icon_path "rpt"]] -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 -command {::quartus::dse::gui::on_view_report} -helptext "View Last DSE Report for Project... (Ctrl+R)" -helptype balloon -anchor w]
            $buttonbox configure -spacing 5
            addWidget buttonNewRevision [$buttonbox add -image [Bitmap::get [file join $app_icon_path "revision"]] -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 -command {::quartus::dse::gui::on_create_or_merge_revision} -helptext "Create a Revision From a DSE Point..." -helptype balloon -anchor w]
            addWidget buttonOpenInTimeQuest [$buttonbox add -image [Bitmap::get [file join $app_icon_path "taw"]] -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 -command {::quartus::dse::gui::on_open_project_in_timequest} -helptext "Open Project in TimeQuest Timing Analyzer..." -helptype balloon -anchor w]
            addWidget buttonOpenInQuartus [$buttonbox add -image [Bitmap::get [file join $app_icon_path "pjm"]] -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 -command {::quartus::dse::gui::on_open_project_in_quartus} -helptext "Open Project in Quartus II... (Ctrl+Q)" -helptype balloon -anchor w]
            pack $buttonbox -side left -anchor w
            set buttonbox [ButtonBox $widgets(toolbar1).bbox3 -spacing 0 -padx 2 -pady 2]
            addWidget buttonStop  [$buttonbox add -image [Bitmap::get [file join $app_icon_path "stop"]]  -highlightthickness 0 -takefocus 0 -relief link -borderwidth 1 -padx 2 -pady 2 -command {::quartus::dse::flows::stop_flow} -helptext "Stop Exploration" -helptype balloon -anchor w]
            pack $buttonbox -side right -anchor e

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
                # CREATE A FRAME FOR THE QII PROJECT SETTINGS + SEEDS
                #
                set titleFrameProjectSettings [TitleFrame $widgets(configtab).title_frame -text "Project Settings" -ipad 5]
                addWidget frameProjectSettings $titleFrameProjectSettings
                pack $titleFrameProjectSettings -fill both -expand no
                set fill_frame [$titleFrameProjectSettings getframe]
                pack $fill_frame

                    #
                    # LabelEntry TO HOLD PROJECT NAME
                    #
                    addWidget labentProjectName [LabelEntry $fill_frame.pname -labelwidth 15 -label "Project:" -text "" -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(labentProjectName) configure -entrybg [$widgets(labentProjectName) cget -background]
                    pack $widgets(labentProjectName) -anchor nw -side top -expand yes -fill both -pady 2

                    #
                    # LabelEntry TO HOLD PROJECT FAMILY
                    #
                    addWidget labentProjectFamily [LabelEntry $fill_frame.pfamily -labelwidth 15 -label "Family:" -text "" -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(labentProjectFamily) configure -entrybg [$widgets(labentProjectFamily) cget -background]
                    pack $widgets(labentProjectFamily) -anchor nw -side top -expand yes -fill both -pady 2

                    #
                    # CREATE A SUB FRAME TO HOLD A Label + ComboBox FOR REVISION
                    #
                    set temp_frame [frame $fill_frame.tf1]
                    pack $temp_frame -fill both -expand yes -anchor nw -pady 2
                    addWidget labelRevisionName [Label $temp_frame.lrev -width 15 -text "Revision:" -justify left -state disabled -anchor w -padx 0]
                    pack $widgets(labelRevisionName) -anchor nw -expand no -side left
                    addWidget cboxRevisionName [ComboBox $temp_frame.cname -values [list] -editable 0 -width 25  -modifycmd {::quartus::dse::gui::on_change_revision}]
                    $widgets(cboxRevisionName) setvalue first
                    pack $widgets(cboxRevisionName) -anchor nw -expand no -fill none


                    #
                    # LabelEntry TO HOLD SEEDS TO SWEEP
                    #
                    addWidget labentSeeds [LabelEntry $fill_frame.seeds -labelwidth 15 -label "Seeds:" -padx 2 -pady 2 -width 27 -textvariable {global_dse_options(gui-seeds)} -validate key -vcmd {::quartus::dse::gui::update_approximate_compile_time}]
                    pack $widgets(labentSeeds) -anchor nw -expand no -fill none -pady 2

                    #
                    # CREATE A SUB FRAME TO HOLD SOME checkbuttons
                    #
                    set temp_frame [frame $fill_frame.tf1b]
                    pack $temp_frame -fill both -expand yes -anchor nw -pady 10
                    addWidget checkQiiis [checkbutton $temp_frame.check_qiiis -text "Project Uses Quartus II Integrated Synthesis" -pady 5 -padx 10 -variable {global_dse_options(gui-project-uses-qiiis)} -command {::quartus::dse::gui::on_select_quick_optimization} -pady 2]
                    pack $widgets(checkQiiis) -anchor nw -expand yes -side top
                    addWidget checkLogiclock [checkbutton $temp_frame.check_llr -text "Allow LogicLock Region Restructuring" -pady 5 -padx 10 -variable {global_dse_options(gui-project-try-llr-restructuring)} -command {::quartus::dse::gui::on_select_quick_optimization} -pady 2]
                    pack $widgets(checkLogiclock) -anchor nw -expand yes -side top


                #
                # CREATE A FRAME FOR THE QUICK RECIPES
                #
                set titleFrameOptimization [TitleFrame $widgets(configtab).optimization_frame -text "Exploration Settings" -ipad 5]
                addWidget frameQuickRecipes $titleFrameOptimization
                pack $titleFrameOptimization -fill both -expand no
                set fill_frame [$titleFrameOptimization getframe]
                pack $fill_frame

                    #
                    # CREATE A SUB FRAME TO HOLD A radiobutton FOR AREA RECIPE
                    #
                    set temp_frame [frame $fill_frame.tf1 -pady 2]
                    pack $temp_frame -fill both -expand yes
                    addWidget radioArea [radiobutton $temp_frame.rbarea -text "Search for Best Area" -variable {::quartus::dse::gui::selected_quick_optimization} -value "area" -pady 10 -command {::quartus::dse::gui::on_select_quick_optimization}]
                    pack $widgets(radioArea) -anchor w -side top -expand no

                    #
                    # CREATE A SUB FRAME TO HOLD A radiobutton + Label + ComboBox FOR SPEED RECIPES
                    #
                    set temp_frame [frame $fill_frame.tf2 -pady 2]
                    pack $temp_frame -fill both -expand yes
                    addWidget radioSpeed [radiobutton $temp_frame.rbspeed -text "Search for Best Performance" -variable {::quartus::dse::gui::selected_quick_optimization} -value "speed" -command {::quartus::dse::gui::on_select_quick_optimization}]
                    pack $widgets(radioSpeed) -anchor nw -expand yes
                    addWidget labelEffort [Label $temp_frame.lblspeed -text "    Effort Level:" -relief flat -padx 10]
                    pack $widgets(labelEffort) -anchor nw -side left
                    addWidget cboxEffort [ComboBox $temp_frame.combobox -values $::quartus::dse::gui::available_speed_effort_levels -editable 0 -width 40 -modifycmd {::quartus::dse::gui::on_select_quick_optimization}]
                    $widgets(cboxEffort) setvalue first
                    pack $widgets(cboxEffort) -anchor nw -expand yes -fill both

                    #
                    # CREATE A SUB FRAME TO HOLD A radiobutton FOR POWER RECIPE
                    #
                    set temp_frame [frame $fill_frame.tf3 -pady 2]
                    pack $temp_frame -fill both -expand yes
                    addWidget radioPower [radiobutton $temp_frame.rbpower -text "Search for Lowest Power" -variable {::quartus::dse::gui::selected_quick_optimization} -value "power" -pady 10 -command {::quartus::dse::gui::on_select_quick_optimization}]
                    pack $widgets(radioPower) -anchor w -side top -expand no

                    #
                    # CREATE A SUB FRAME TO HOLD A radiobutton FOR CUSTOM RECIPE
                    # Only do this if the user is in advanced mode
					if {$advanced_use} {
						set temp_frame [frame $fill_frame.tf4 -pady 2]
						pack $temp_frame -fill both -expand yes
						addWidget radioCustom [radiobutton $temp_frame.rbcustom -text "Advanced Search   " -variable {::quartus::dse::gui::selected_quick_optimization} -value "custom" -pady 10  -command {::quartus::dse::gui::on_select_quick_optimization}]
						pack $widgets(radioCustom) -anchor w -side left -expand no
					}

                    #
                    # CREATE A LABLE AT THE BOTTOM OF THIS PANE FOR WARNINGS
                    #
                    set titleFrameWarningLabel [message $widgets(configtab).warning_label -justify left -text "\n\n\n" -foreground [$widgets(labentProjectFamily) cget -background] -background [$widgets(labentProjectFamily) cget -background] -width 425]
                    addWidget titleFrameWarningLabel $titleFrameWarningLabel
                    pack $titleFrameWarningLabel -fill both -expand no -side top


            #
            # CREATE THE NOTEBOOK PAGE TO HOLD ADVANCED SETTINGS
            # Only do this if the user is in advanced mode
			if {$advanced_use} {
				addWidget advancedtab [$widgets(notebook) insert end advanced -text "  Advanced  " -state disabled]

					#
					# CREATE A FRAME FOR EXPLORATION SETTING
					#
					set titleFrameExploration [TitleFrame $widgets(advancedtab).exploration_frame -text "Exploration Space" -ipad 5]
					addWidget frameAdvancedExplorationOptions $titleFrameExploration
					pack $titleFrameExploration -fill both -expand yes -anchor nw
					set fill_frame [$titleFrameExploration getframe]
					pack $fill_frame -anchor nw -side top -expand no

						#
						# COMBO BOX TO HOLD EXPLORATION SPACES
						#
						addWidget dlgCustom.cboxExplorationSpaces [ComboBox $fill_frame.combobox -values $::quartus::dse::gui::available_exploration_spaces -editable 0 -width 70 -modifycmd {::quartus::dse::gui::on_select_exploration_space} ]
						$widgets(dlgCustom.cboxExplorationSpaces) configure -values $::quartus::dse::gui::available_exploration_spaces
						$widgets(dlgCustom.cboxExplorationSpaces) setvalue first
						pack $widgets(dlgCustom.cboxExplorationSpaces) -anchor nw -side top -expand yes -fill both

						#
						# LABEL TO HOLD DESCRIPTION OF EXPLORATION SPACE
						#
						addWidget dlgCustom.labelExplorationSpaceDescription [Label $fill_frame.flabel -width 70 -justify left -anchor nw -wraplength 350 -height 5]
						::quartus::dse::gui::on_select_exploration_space
						pack $widgets(dlgCustom.labelExplorationSpaceDescription) -anchor nw -side top -expand no


					#
					# CREATE A FRAME TO HOLD OPTIMIZATION GOAL
					#
					set titleFrameOptGoal [TitleFrame $widgets(advancedtab).optgoal_frame -text "Optimization Goal" -ipad 5]
					addWidget frameAdvancedOptimizationGoal $titleFrameOptGoal
					pack $titleFrameOptGoal -fill both -expand yes -anchor nw
					set fill_frame [$titleFrameOptGoal getframe]
					pack $fill_frame -anchor nw -side top -expand no

						#
						# CBOX TO CHOOSE THE OPTIMIZATION GOAL
						#
						addWidget dlgCustom.cboxOptGoal [ComboBox $fill_frame.combobox -values $::quartus::dse::gui::available_optimization_goals -editable 0 -width 70 -modifycmd {::quartus::dse::gui::on_select_optimization_goal} ]
						$widgets(dlgCustom.cboxOptGoal) setvalue first
						pack $widgets(dlgCustom.cboxOptGoal) -anchor nw -side top -expand yes -fill both

						#
						# LABEL TO HOLD DESCRIPTION OF OPTIMIZATION GOAL
						#
						addWidget dlgCustom.labelOptGoalDescription [Label $fill_frame.optgoallabel -width 70 -justify left -anchor nw -wraplength 350 -height 5]
						::quartus::dse::gui::on_select_optimization_goal
						pack $widgets(dlgCustom.labelOptGoalDescription) -anchor nw -side top -expand no


					#
					# CREATE A FRAME TO HOLD SEARCH METHOD
					#
					set titleFrameSearchMethod [TitleFrame $widgets(advancedtab).smethod_frame -text "Search Method" -ipad 5]
					addWidget frameAdvancedSearchMethod $titleFrameSearchMethod
					pack $titleFrameSearchMethod -fill both -expand yes -anchor nw
					set fill_frame [$titleFrameSearchMethod getframe]
					pack $fill_frame -anchor nw -side top -expand no

						#
						# COMBO BOX TO HOLD SEARCH METHODS
						#
						addWidget dlgCustom.cboxSearchMethod [ComboBox $fill_frame.combobox -values $::quartus::dse::gui::available_search_methods -editable 0 -width 70 -modifycmd {::quartus::dse::gui::on_select_search_method} ]
						$widgets(dlgCustom.cboxSearchMethod) setvalue first
						pack $widgets(dlgCustom.cboxSearchMethod) -anchor nw -side top -expand yes -fill both

						#
						# LABEL TO HOLD DESCRIPTION OF FLOW
						#
						addWidget dlgCustom.labelSearchMethodDescription [Label $fill_frame.flabel -width 70 -justify left -anchor nw -wraplength 350 -height 5]
						::quartus::dse::gui::on_select_search_method
						pack $widgets(dlgCustom.labelSearchMethodDescription) -anchor nw -side top -expand no
			}
            #
            # CREATE THE NOTEBOOK PAGE TO HOLD EXPLORATION OUTPUT
            #
            addWidget explorationtab [$widgets(notebook) insert end explore -text "  Explore  " -state disabled]

                #
                # ADD A STATUS LABEL
                #
                #addWidget elapsedTimeStatusExploration [$widgets(mainframe) addindicator -text "0%     00:00:00"]

                #
                # CREATE A FRAME FOR THE BEST RESULTS
                #
                addWidget frameBestResultsExploration [TitleFrame $widgets(explorationtab).tfBestResults -text "Best Results" -ipad 2]
                pack $widgets(frameBestResultsExploration) -anchor nw -fill both -expand no

                    #
                    # ADD THE LABELS FOR THE BEST RESULTS
                    #
                    set f [$widgets(frameBestResultsExploration) getframe]
                    addWidget leBestPointExploration [LabelEntry $f.point -labelwidth 30 -label "Point:" -textvariable {::quartus::dse::gui::best_results(point)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBestPointExploration) configure -entrybg [$widgets(leBestPointExploration) cget -background]
                    addWidget leBestSlackExploration [LabelEntry $f.slack -labelwidth 30 -label "Slack:" -textvariable {::quartus::dse::gui::best_results(slack)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBestSlackExploration) configure -entrybg [$widgets(leBestSlackExploration) cget -background]
                    addWidget leBestPeriodExploration [LabelEntry $f.period -labelwidth 30 -label "Period:" -textvariable {::quartus::dse::gui::best_results(period)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBestPeriodExploration) configure -entrybg [$widgets(leBestPeriodExploration) cget -background]
                    addWidget leBestFpathsExploration [LabelEntry $f.fpaths -labelwidth 30 -label "Failing Paths:" -textvariable {::quartus::dse::gui::best_results(failingpaths)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBestFpathsExploration) configure -entrybg [$widgets(leBestFpathsExploration) cget -background]
                    addWidget leBestLcellsExploration [LabelEntry $f.lcells -labelwidth 30 -label "Total logic elements:" -textvariable {::quartus::dse::gui::best_results(logiccells)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBestLcellsExploration) configure -entrybg [$widgets(leBestLcellsExploration) cget -background]
                    addWidget leBestPowerExploration [LabelEntry $f.power -labelwidth 30 -label "Total Thermal Power Dissipation:" -textvariable {::quartus::dse::gui::best_results(power)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBestPowerExploration) configure -entrybg [$widgets(leBestPowerExploration) cget -background]
                    pack $widgets(leBestPointExploration) $widgets(leBestSlackExploration) $widgets(leBestPeriodExploration) $widgets(leBestFpathsExploration) $widgets(leBestLcellsExploration) $widgets(leBestPowerExploration) -anchor nw -side top -expand yes -fill x

                #
                # CREATE A FRAME FOR THE BASE RESULTS
                #
                addWidget frameBaseResultsExploration [TitleFrame $widgets(explorationtab).tfBaseResults -text "Base Results" -ipad 2]
                pack $widgets(frameBaseResultsExploration) -anchor nw -fill both -expand no

                    #
                    # ADD THE LABELS FOR THE BASE RESULTS
                    #
                    set f [$widgets(frameBaseResultsExploration) getframe]
                    addWidget leBaseSlackExploration [LabelEntry $f.slack -labelwidth 30 -label "Slack:" -textvariable {::quartus::dse::gui::base_results(slack)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBaseSlackExploration) configure -entrybg [$widgets(leBaseSlackExploration) cget -background]
                    addWidget leBasePeriodExploration [LabelEntry $f.period -labelwidth 30 -label "Period:" -textvariable {::quartus::dse::gui::base_results(period)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBasePeriodExploration) configure -entrybg [$widgets(leBasePeriodExploration) cget -background]
                    addWidget leBaseFpathsExploration [LabelEntry $f.fpaths -labelwidth 30 -label "Failing Paths:" -textvariable {::quartus::dse::gui::base_results(failingpaths)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBaseFpathsExploration) configure -entrybg [$widgets(leBaseFpathsExploration) cget -background]
                    addWidget leBaseLcellsExploration [LabelEntry $f.lcells -labelwidth 30 -label "Total logic elements:" -textvariable {::quartus::dse::gui::base_results(logiccells)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBaseLcellsExploration) configure -entrybg [$widgets(leBaseLcellsExploration) cget -background]
                    addWidget leBasePowerExploration [LabelEntry $f.power -labelwidth 30 -label "Total Thermal Power Dissipation:" -textvariable {::quartus::dse::gui::base_results(power)} -padx 2 -pady 2 -editable 0 -relief flat]
                    $widgets(leBasePowerExploration) configure -entrybg [$widgets(leBasePowerExploration) cget -background]
                    pack $widgets(leBaseSlackExploration) $widgets(leBasePeriodExploration) $widgets(leBaseFpathsExploration) $widgets(leBaseLcellsExploration) $widgets(leBasePowerExploration) -anchor nw -side top -expand yes -fill x


                #
                # CREATE A FRAME FOR THE MESSAGES
                #
                addWidget frameMessagesExploration [TitleFrame $widgets(explorationtab).tfMessages -text "Messages" -ipad 2]
                pack $widgets(frameMessagesExploration) -anchor nw -expand yes -fill both


                    #
                    # ADD THE MESSAGES TEXT AREA
                    #
                    set f [$widgets(frameMessagesExploration) getframe]
                    addWidget swMessagesExploration [ScrolledWindow $f.sw -auto none]
                    addWidget txtMessagesExploration [text $widgets(swMessagesExploration).txtmsgs -relief sunken -wrap none -width 70 -height 10]
                    $widgets(txtMessagesExploration) tag configure infotag -foreground black
                    $widgets(txtMessagesExploration) tag configure errortag -foreground red
                    $widgets(txtMessagesExploration) tag configure warningtag -foreground blue
                    $widgets(txtMessagesExploration) tag configure debugtag -foreground green
                    $widgets(txtMessagesExploration) configure -state disabled
                    $widgets(swMessagesExploration) setwidget $widgets(txtMessagesExploration)
                    pack $widgets(swMessagesExploration) -expand yes -fill both

        #
        # PACK THE NOTEBOOK THAT HOLDS EVERYTHING
        #
        $widgets(notebook) compute_size
        pack $widgets(notebook) -fill both -expand yes
        $widgets(notebook) raise config


    #
    # ADD THE ESTIMATED COMPILATION TIME
    #
    addWidget estimatedTime [Entry $widgets(mainframe).estimatedTime -textvariable ::quartus::dse::gui::estimated_time_text -editable 0 -relief flat -bg [$widgets(labentProjectName) cget -background] -width 70]
    pack $widgets(estimatedTime) -expand no -fill y -pady 2 -anchor w

    #
    # PACK THE TOPLEVEL WINDOW FOR EVERYTHING
    #
    pack $widgets(mainframe) -fill both -expand yes

    update idletasks

    # Make sure when the user destroys the application
    # the project settings are stored in qflow project file
    bind $widgets(mainframe) <Destroy> {::quartus::dse::gui::close_gui}

    # Create a help module for other GUI components to use
	variable hh ""
    catch {variable hh [::quartus::hh #auto "[file join $::quartus(binpath) .. common help optimize.chm]"]}

    # The user should be able to get window-specific help by hitting the F1 key.
    bind . <F1> {::quartus::dse::gui::on_help -page /dse/dse_about_dse.htm}

    #
    # UPDATE THE GUI SO EVERYTHING HAS THE PROPER -state
    #
    update_gui -gui-created

    #
    # SHOW THE TOP-LEVEL WINDOW, CENTERED IN THE USER'S DISPLAY
    #
    BWidget::place . 0 0 center
    wm deiconify .
    raise .
    focus -force .

    #
    # IF THE USER CALLED THE GUI WITH -project WE NEED
    # TO TRY AND OPEN THE PROJECT FOR THEM
    #
    if {$optshash(project) != "#_optional_#"} {
        catch {unset topts}
        lappend topts "-project"
        lappend topts $optshash(project)
        if {$optshash(revision) != "#_optional_#"} {
            lappend topts "-revision"
            lappend topts $optshash(revision)
        }
        on_open_project $topts
    }

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
proc ::quartus::dse::gui::addWidget {_wname _truename} {

    # Import global namespace variables
    global widgets
    global global_dse_options

    # Error if widget name already exists
    if {[info exists widgets($_wname)]} {
        return -code error "Widget with name $_wname already exists!"
    }

    # Add it
    set widgets($_wname) $_truename
    if {$global_dse_options(dse-debug)} {
        ::quartus::dse::ccl::dputs "::quartus::dse::gui::addWidget(): $_wname -> $_truename"
    }

    return 1
}


#############################################################################
##  Procedure:  update_gui
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Helper function that updates the toolbar and buttons
proc ::quartus::dse::gui::update_gui {args} {

    set debug_name "::quartus::dse::gui::update_gui()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable app_name
	variable advanced_use
    variable procGetDescriptionForSpace
    variable procGetValidSpaces
    variable procIsValidSpace
    variable procSetDesignSpace
    variable procHasRecipe
    variable procGetRecipe
    variable available_speed_effort_levels
    variable available_exploration_spaces
    variable selected_quick_optimization
    variable progress_variable
    variable progress_max
    variable progress_text
	variable working_dir

    if {!$global_dse_options(dse-gui)} {
        return 1
    }


    # Command line options to this function we require
    lappend function_opts [list "project-loaded" 0 ""]
    lappend function_opts [list "compilation-started" 0 ""]
    lappend function_opts [list "compilation-ended" 0 ""]
    lappend function_opts [list "gui-created" 0 ""]
    lappend function_opts [list "project.arg" "#_optional_#" ""]
    lappend function_opts [list "family.arg" "#_optional_#" ""]
    lappend function_opts [list "revisions.arg" "#_optional_#" ""]
    lappend function_opts [list "revision-index.arg" "#_optional_#" ""]

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "Missing required option: -$opt"
        }
    }

    # Based on the flag passed update the interface so things
    # are enabled or disabled accordingly.

    if {$optshash(gui-created)} {
        # The UI has just been created. Set everything to the
        # initial state.

        set available_exploration_spaces [list]
        set available_speed_effort_levels [list]

        $widgets(labentProjectName) configure -text ""
        $widgets(labentProjectFamily) configure -text ""
        $widgets(cboxRevisionName) configure -values [list]
        $widgets(cboxRevisionName) setvalue first

        $widgets(mainframe) setmenustate PROJECT_OPEN disabled
        $widgets(mainframe) setmenustate PROJECT_OPEN_STA disabled
        $widgets(buttonOpen) configure -state normal
        $widgets(buttonStart) configure -state disabled
        $widgets(buttonStop) configure -state disabled
        $widgets(buttonViewReport) configure -state disabled
        $widgets(buttonNewRevision) configure -state disabled
        $widgets(buttonOpenInTimeQuest) configure -state disabled
        $widgets(buttonOpenInQuartus) configure -state disabled
        $widgets(radioArea) select
        $widgets(radioArea) configure -state disabled
        $widgets(radioSpeed) configure -state disabled
        $widgets(radioPower) configure -state disabled
        $widgets(labelEffort) configure -state disabled
        $widgets(cboxEffort) configure -values $available_speed_effort_levels
        $widgets(cboxEffort) setvalue last
        $widgets(cboxEffort) configure -state disabled
        $widgets(checkQiiis) configure -state disabled
        $widgets(checkLogiclock) configure -state disabled
        $widgets(radioPower) configure -state disabled
        catch {$widgets(radioCustom) configure -state disabled}
        $widgets(labentProjectName) configure -state disabled
        $widgets(labentProjectFamily) configure -state disabled
        $widgets(labelRevisionName) configure -state disabled
        $widgets(cboxRevisionName) configure -state disabled
        $widgets(labentSeeds) configure -state disabled

        # Enable the appropriate tabs
        $widgets(notebook) itemconfigure config -state normal
		catch {$widgets(notebook) itemconfigure advanced -state disabled}
        $widgets(notebook) itemconfigure explore -state disabled
        $widgets(notebook) raise config

        catch {bind $widgets(mainframe) <Destroy> {::quartus::dse::gui::close_gui}}

        . configure -cursor arrow

		# Set the title to just the name of the application
		wm title . "$app_name"
    }

    if {$optshash(project-loaded)} {
        # User just loaded a project.

        # We require so additional arguments if the user said -project-loaded
        foreach opt [list "project" "family" "revisions" "revision-index"] {
            if {![info exists optshash($opt)] || $optshash($opt) == "#_optional_#"} {
                return -code error "Missing required option: -$opt"
            }
        }

        $widgets(labentProjectName) configure -text $optshash(project)
		if { $global_dse_options(gui-show-full-project-path-in-title-bar) } {
			wm title . "$app_name - [file join $working_dir $optshash(project)]"
		} else {
			wm title . "$app_name - $optshash(project)"
		}
        $widgets(labentProjectFamily) configure -text $optshash(family)
        $widgets(cboxRevisionName) configure -values $optshash(revisions)
        $widgets(cboxRevisionName) setvalue "@${optshash(revision-index)}"

        # Enable the appropriate tabs
        $widgets(notebook) itemconfigure config -state normal
		catch {$widgets(notebook) itemconfigure advanced -state disabled}
        $widgets(notebook) itemconfigure explore -state normal
        $widgets(notebook) raise config

        if {[$widgets(labentProjectFamily) cget -text] != ""} {
            # Fill in the available exploration types
            # for this family.
            ::quartus::dse::ccl::dputs "${debug_name}: Family for this project is: [string tolower [$widgets(labentProjectFamily) cget -text]]"

            # Find the space library for this family
            regsub -all -nocase -- {\s+} [string tolower [$widgets(labentProjectFamily) cget -text]] {} family_modified
            switch -exact -- $family_modified {
                stratix -
                stratixgx {
                    package require ::quartus::dse::stratix
                    set procGetDescriptionForSpace    ::quartus::dse::stratix::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::stratix::get_valid_types
                    set procIsValidSpace              ::quartus::dse::stratix::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::stratix::set_design_space
                    set procHasRecipe                 ::quartus::dse::stratix::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::stratix::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Total Logic Elements:"
                    $widgets(leBaseLcellsExploration) configure -label "Total Logic Elements:"
                }
                cyclone {
                    package require ::quartus::dse::cyclone
                    set procGetDescriptionForSpace    ::quartus::dse::cyclone::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::cyclone::get_valid_types
                    set procIsValidSpace              ::quartus::dse::cyclone::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::cyclone::set_design_space
                    set procHasRecipe                 ::quartus::dse::cyclone::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::cyclone::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Total Logic Elements:"
                    $widgets(leBaseLcellsExploration) configure -label "Total Logic Elements:"
                }
                maxii {
                    package require ::quartus::dse::maxii
                    set procGetDescriptionForSpace    ::quartus::dse::maxii::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::maxii::get_valid_types
                    set procIsValidSpace              ::quartus::dse::maxii::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::maxii::set_design_space
                    set procHasRecipe                 ::quartus::dse::maxii::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::maxii::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Total Logic Elements:"
                    $widgets(leBaseLcellsExploration) configure -label "Total Logic Elements:"
                }
                stratixii -
                stratixiigx {
                    package require ::quartus::dse::stratixii
                    set procGetDescriptionForSpace    ::quartus::dse::stratixii::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::stratixii::get_valid_types
                    set procIsValidSpace              ::quartus::dse::stratixii::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::stratixii::set_design_space
                    set procHasRecipe                 ::quartus::dse::stratixii::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::stratixii::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Logic Utilization:"
                    $widgets(leBaseLcellsExploration) configure -label "Logic Utilization:"
                }
				arriagx -
				arria {
                    package require ::quartus::dse::arria
                    set procGetDescriptionForSpace    ::quartus::dse::arria::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::arria::get_valid_types
                    set procIsValidSpace              ::quartus::dse::arria::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::arria::set_design_space
                    set procHasRecipe                 ::quartus::dse::arria::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::arria::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Logic Utilization:"
                    $widgets(leBaseLcellsExploration) configure -label "Logic Utilization:"
				}
                stratixiii {
                    package require ::quartus::dse::stratixiii
                    set procGetDescriptionForSpace    ::quartus::dse::stratixiii::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::stratixiii::get_valid_types
                    set procIsValidSpace              ::quartus::dse::stratixiii::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::stratixiii::set_design_space
                    set procHasRecipe                 ::quartus::dse::stratixiii::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::stratixiii::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Logic Utilization:"
                    $widgets(leBaseLcellsExploration) configure -label "Logic Utilization:"
                }
				stratixiv -
				arriaii -
				arriaiigx {
                    package require ::quartus::dse::stratixiv
                    set procGetDescriptionForSpace    ::quartus::dse::stratixiv::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::stratixiv::get_valid_types
                    set procIsValidSpace              ::quartus::dse::stratixiv::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::stratixiv::set_design_space
                    set procHasRecipe                 ::quartus::dse::stratixiv::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::stratixiv::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Logic Utilization:"
                    $widgets(leBaseLcellsExploration) configure -label "Logic Utilization:"
                }
                cycloneiii {
                    package require ::quartus::dse::cycloneiii
                    set procGetDescriptionForSpace    ::quartus::dse::cycloneiii::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::cycloneiii::get_valid_types
                    set procIsValidSpace              ::quartus::dse::cycloneiii::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::cycloneiii::set_design_space
                    set procHasRecipe                 ::quartus::dse::cycloneiii::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::cycloneiii::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Total Logic Elements:"
                    $widgets(leBaseLcellsExploration) configure -label "Total Logic Elements:"
                }
                cycloneii {
                    package require ::quartus::dse::cycloneii
                    set procGetDescriptionForSpace    ::quartus::dse::cycloneii::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::cycloneii::get_valid_types
                    set procIsValidSpace              ::quartus::dse::cycloneii::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::cycloneii::set_design_space
                    set procHasRecipe                 ::quartus::dse::cycloneii::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::cycloneii::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Total Logic Elements:"
                    $widgets(leBaseLcellsExploration) configure -label "Total Logic Elements:"
                }
                flex6000 {
                    package require ::quartus::dse::flex6000
                    set procGetDescriptionForSpace    ::quartus::dse::flex6000::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::flex6000::get_valid_types
                    set procIsValidSpace              ::quartus::dse::flex6000::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::flex6000::set_design_space
                    set procHasRecipe                 ::quartus::dse::flex6000::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::flex6000::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Total Logic Elements:"
                    $widgets(leBaseLcellsExploration) configure -label "Total Logic Elements:"
                }
                max3000a -
                max7000ae -
                max7000b -
                max7000s {
                    package require ::quartus::dse::max7000
                    set procGetDescriptionForSpace    ::quartus::dse::max7000::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::max7000::get_valid_types
                    set procIsValidSpace              ::quartus::dse::max7000::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::max7000::set_design_space
                    set procHasRecipe                 ::quartus::dse::max7000::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::max7000::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Total Logic Elements:"
                    $widgets(leBaseLcellsExploration) configure -label "Total Logic Elements:"
                }
                hardcopyii {
                    package require ::quartus::dse::hardcopyii
                    set procGetDescriptionForSpace    ::quartus::dse::hardcopyii::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::hardcopyii::get_valid_types
                    set procIsValidSpace              ::quartus::dse::hardcopyii::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::hardcopyii::set_design_space
                    set procHasRecipe                 ::quartus::dse::hardcopyii::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::hardcopyii::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Total HCells:"
                    $widgets(leBaseLcellsExploration) configure -label "Total HCells:"
                }
                default {
                    # Every other family can probably use this
                    package require ::quartus::dse::genericfamily
                    set procGetDescriptionForSpace    ::quartus::dse::genericfamily::get_description_for_type
                    set procGetValidSpaces            ::quartus::dse::genericfamily::get_valid_types
                    set procIsValidSpace              ::quartus::dse::genericfamily::is_valid_type
                    set procSetDesignSpace            ::quartus::dse::genericfamily::set_design_space
                    set procHasRecipe                 ::quartus::dse::genericfamily::has_quick_recipe_for
                    set procGetRecipe                 ::quartus::dse::genericfamily::get_quick_recipe_for
                    $widgets(leBestLcellsExploration) configure -label "Total Logic Elements:"
                    $widgets(leBaseLcellsExploration) configure -label "Total Logic Elements:"
                }
            }

            # Fill in the available speed effort levels
            set available_speed_effort_levels [list]
            if {[$procHasRecipe "speed:low"]} {
                lappend available_speed_effort_levels "Low (Seed Sweep)"
            }
            if {[$procHasRecipe "speed:medium"]} {
                lappend available_speed_effort_levels "Medium (Extra Effort Space)"
            }

            if {[$procHasRecipe "speed:high"]} {
                lappend available_speed_effort_levels "High (Physical Synthesis Space)"
            }
            if {[$procHasRecipe "speed:highest"]} {
                lappend available_speed_effort_levels "Highest (Physical Synthesis with Retiming Space)"
            }
            if {[$procHasRecipe "speed:selective"]} {
                lappend available_speed_effort_levels "Selective (Selected Performance Optimizations)"
            }

            # If the list is empty fill it in with a dummy value
            if {[llength $available_speed_effort_levels] == 0} {
                lappend available_speed_effort_levels " "
            }

            # Update the GUI widgets
            $widgets(cboxEffort) configure -values $available_speed_effort_levels
            $widgets(cboxEffort) setvalue last

            # Fill in available exploration types
            set available_exploration_spaces [$procGetValidSpaces]
            ::quartus::dse::ccl::dputs "${debug_name}: Got list of valid spaces: $available_exploration_spaces"

            catch {
				$widgets(dlgCustom.cboxExplorationSpaces) configure -values $available_exploration_spaces
				$widgets(dlgCustom.cboxExplorationSpaces) setvalue first
				::quartus::dse::gui::on_select_exploration_space
			}

            # Custom can always be enabled
            catch {$widgets(radioCustom) configure -state normal}
            catch {$widgets(radioCustom) invoke}

            # Enable power if power is available
            if {[$procHasRecipe "power"]} {
                $widgets(radioPower) configure -state normal
                $widgets(radioPower) invoke
            } else {
                $widgets(radioPower) configure -state disable
			}

            # Enable area if area is available
            if {[$procHasRecipe "area"]} {
                $widgets(radioArea) configure -state normal
                $widgets(radioArea) invoke
            } else {
				$widgets(radioArea) configure -state disable
			}

            # Enable speed if speed is available
            if {[$procHasRecipe "speed:low"] || [$procHasRecipe "speed:medium"] || [$procHasRecipe "speed:high"] || [$procHasRecipe "speed:highest"] || [$procHasRecipe "speed:selective"]} {
                $widgets(cboxEffort) configure -state disabled
                $widgets(radioSpeed) configure -state normal
                $widgets(labelEffort) configure -state disabled
                $widgets(radioSpeed) invoke
            } else {
				$widgets(cboxEffort) configure -state disabled
				$widgets(radioSpeed) configure -state disabled
				$widgets(labelEffort) configure -state disabled
			}

            # The rest of our boxes should be enabled
            $widgets(labentProjectName) configure -state normal
            $widgets(labentProjectFamily) configure -state normal
            $widgets(labelRevisionName) configure -state normal
            $widgets(cboxRevisionName) configure -state normal
            $widgets(labentSeeds) configure -state normal
            catch {$widgets(dlgCustom.cboxExplorationSpaces) configure -state normal}
            catch {$widgets(dlgCustom.cboxOptGoal) configure -state normal}
            catch {$widgets(dlgCustom.cboxSearchMethod) configure -state normal}

            $widgets(titleFrameWarningLabel) configure -text "\n\n"
            $widgets(titleFrameWarningLabel) configure -foreground [$widgets(labentProjectFamily) cget -background] -background [$widgets(labentProjectFamily) cget -background]

        } else {
            # Empty the exploration types and put
            # a message to load a project to see
            # the available types.
            set available_exploration_spaces [list]
        }

        $widgets(mainframe) setmenustate PROJECT_OPEN normal
        $widgets(buttonOpen) configure -state normal
        $widgets(buttonStop) configure -state disabled
        $widgets(buttonStart) configure -state normal
        $widgets(checkQiiis) configure -state normal
        $widgets(checkLogiclock) configure -state normal

        # Enable the view report button if there's a report available
        if {[file exists [lindex [$widgets(cboxRevisionName) cget -values] [$widgets(cboxRevisionName) getvalue]].dse.rpt]} {
            $widgets(buttonViewReport) configure -state normal
        }
        # Enable the revision button if there are DSE result files
        if {[llength [glob -nocomplain -dir [file join dse] -- {*-result.xml}]] > 0} {
            $widgets(buttonNewRevision) configure -state normal
        }
        # Let the use open this project in the QII GUI
        $widgets(buttonOpenInQuartus) configure -state normal

        #
        # STA_MODE START
        # NB: Allow user to switch to TimeQuest if STA mode is on
        if { $global_dse_options(gui-sta-mode) } {
            $widgets(mainframe) setmenustate PROJECT_OPEN_STA normal
            $widgets(buttonOpenInTimeQuest) configure -state normal
        } else {
            $widgets(mainframe) setmenustate PROJECT_OPEN_STA disabled
            $widgets(buttonOpenInTimeQuest) configure -state disable
        }
        # STA_MODE END
        #

        catch {bind $widgets(mainframe) <Destroy> {::quartus::dse::gui::close_gui}}

        . configure -cursor arrow
    }

    if {$optshash(compilation-started)} {
        # A DSE flow is now being run

        $widgets(mainframe) setmenustate DISABLE_DURING_COMPILE disabled
        $widgets(mainframe) setmenustate PROJECT_OPEN disabled
        $widgets(mainframe) setmenustate PROJECT_OPEN_STA disabled
        $widgets(buttonOpen) configure -state disabled
        $widgets(buttonStart) configure -state disabled
        $widgets(buttonStop) configure -state normal
        $widgets(buttonViewReport) configure -state disabled
        $widgets(buttonNewRevision) configure -state disabled
        $widgets(buttonOpenInTimeQuest) configure -state disabled
        $widgets(buttonOpenInQuartus) configure -state disabled
        $widgets(labentProjectName) configure -state disabled
        $widgets(labentProjectFamily) configure -state disabled
        $widgets(labelRevisionName) configure -state disabled
        $widgets(cboxRevisionName) configure -state disabled
        $widgets(labentSeeds) configure -state disabled
        $widgets(radioArea) configure -state disabled
        $widgets(radioSpeed) configure -state disabled
        $widgets(radioPower) configure -state disabled
        $widgets(cboxEffort) configure -state disabled
        $widgets(labelEffort) configure -state disabled
        catch {$widgets(radioCustom) configure -state disabled}
        $widgets(checkQiiis) configure -state disabled
        $widgets(checkLogiclock) configure -state disabled
        catch {$widgets(dlgCustom.cboxExplorationSpaces) configure -state disabled}
        catch {$widgets(dlgCustom.cboxOptGoal) configure -state disabled}
        catch {$widgets(dlgCustom.cboxSearchMethod) configure -state disabled}

        #
        # STA_MODE START
        # NB: When sta-mode is on there is no clock period to report
        #     so we'll show the user End Point TNS instead. We don't
        #     want to change these labels until the user hits the play
        #     button in DSE though!
        #if { !$global_dse_options(gui-sta-mode) } {
            $widgets(leBasePeriodExploration) configure -label "Period:"
            $widgets(leBestPeriodExploration) configure -label "Period:"
            $widgets(leBaseFpathsExploration) configure -state normal
            $widgets(leBestFpathsExploration) configure -state normal
        #} else {
        #    $widgets(leBasePeriodExploration) configure -label "End Point TNS:"
        #    $widgets(leBestPeriodExploration) configure -label "End Point TNS:"
        #    #$widgets(leBaseFpathsExploration) configure -state disabled
        #    $widgets(leBaseFpathsExploration) configure -state normal
        #    #$widgets(leBestFpathsExploration) configure -state disabled
        #    $widgets(leBestFpathsExploration) configure -state normal
        #}
        # STA_MODE END
        #

        set progress_variable 0
        set progress_max 100
        set progress_text "Exploring..."

        # Change the text in the status bar
        $widgets(elapsedTimeStatusExploration) configure -text "0%     00:00:00"

        # Clear the message box
        catch {$widgets(txtMessagesExploration) configure -state normal}
        $widgets(txtMessagesExploration) delete 1.0 end
        catch {$widgets(txtMessagesExploration) configure -state disabled}

        # Display the status and the progress bar
        $widgets(mainframe) showstatusbar progression

        # If this window gets destroyed we need to stop the flow
        bind $widgets(mainframe) <Destroy> {::quartus::dse::flows::stop_flow; ::quartus::dse::gui::close_gui}

        # Enable the appropriate tabs
        $widgets(notebook) itemconfigure config -state normal
		catch {
			if {$selected_quick_optimization == "custom"} {
				$widgets(notebook) itemconfigure advanced -state normal
			} else {
				catch {$widgets(notebook) itemconfigure advanced -state disabled}
			}
		}
        $widgets(notebook) itemconfigure explore -state normal
        $widgets(notebook) raise explore

        . configure -cursor watch
    }

    if {$optshash(compilation-ended)} {
        # A DSE flow has ended

        $widgets(mainframe) setmenustate DISABLE_DURING_COMPILE normal
        $widgets(mainframe) setmenustate PROJECT_OPEN normal
        $widgets(buttonOpen) configure -state normal
        $widgets(buttonStart) configure -state normal
        $widgets(buttonStop) configure -state disable
        $widgets(labentProjectName) configure -state normal
        $widgets(labentProjectFamily) configure -state normal
        $widgets(labelRevisionName) configure -state normal
        $widgets(cboxRevisionName) configure -state normal
        $widgets(labentSeeds) configure -state normal

        # Enable area if area is available
        if {[$procHasRecipe "area"]} {
            $widgets(radioArea) configure -state normal
        }


        # Enable speed if speed is available
        if {[$procHasRecipe "speed:low"] || [$procHasRecipe "speed:medium"] || [$procHasRecipe "speed:high"] || [$procHasRecipe "speed:highest"] || [$procHasRecipe "speed:selective"]} {
            $widgets(radioSpeed) configure -state normal
        }
        if {$selected_quick_optimization == "speed"} {
            $widgets(labelEffort) configure -state normal
            $widgets(cboxEffort) configure -state normal
        } else {
            $widgets(labelEffort) configure -state disabled
            $widgets(cboxEffort) configure -state disabled
        }

        # Enable power if power is available
        if {[$procHasRecipe "power"]} {
            $widgets(radioPower) configure -state normal
        }

        $widgets(checkQiiis) configure -state normal
        $widgets(checkLogiclock) configure -state normal
        catch {$widgets(dlgCustom.cboxExplorationSpaces) configure -state normal}
        catch {$widgets(dlgCustom.cboxOptGoal) configure -state normal}
        catch {$widgets(dlgCustom.cboxSearchMethod) configure -state normal}

        # Enable the appropriate tabs
        $widgets(notebook) itemconfigure config -state normal
		catch {$widgets(notebook) itemconfigure advanced -state disabled}
        $widgets(notebook) itemconfigure explore -state normal

        # Enable custom space options
		catch {
			$widgets(radioCustom) configure -state normal
			if {$selected_quick_optimization == "custom"} {
				$widgets(notebook) itemconfigure advanced -state normal
				$widgets(checkQiiis) configure -state disabled
				$widgets(checkLogiclock) configure -state normal
			}
		}

        #
        # STA_MODE START
        # NB: Open in STA option is only available if project uses STA
        if { !$global_dse_options(gui-sta-mode) } {
            $widgets(mainframe) setmenustate PROJECT_OPEN_STA disabled
        } else {
            $widgets(mainframe) setmenustate PROJECT_OPEN_STA normal
        }
        # STA_MODE END
        #

        # Enable the view report button if there's a report available
        if {[file exists [lindex [$widgets(cboxRevisionName) cget -values] [$widgets(cboxRevisionName) getvalue]].dse.rpt]} {
            $widgets(buttonViewReport) configure -state normal
        }
        # Enable the revision button if there are DSE result files
        if {[llength [glob -nocomplain -dir [file join dse] -- {*-result.xml}]] > 0} {
            $widgets(buttonNewRevision) configure -state normal
        }
        # Let the use open this project in the QII GUI
        $widgets(buttonOpenInQuartus) configure -state normal

        #
        # STA_MODE START
        # NB: Allow user to switch to TimeQuest if STA mode is on
        if { $global_dse_options(gui-sta-mode) } {
            $widgets(buttonOpenInTimeQuest) configure -state normal
        } else {
            $widgets(buttonOpenInTimeQuest) configure -state disable
        }
        # STA_MODE END
        #

        set progress_variable 0
        set progress_max 100
        set progress_text ""

        # Remove the progress bar
        catch {$widgets(mainframe) showstatusbar status}

        # Reset the text in the status bar
        $widgets(elapsedTimeStatusExploration) configure -text " [get_quartus_legal_string -product] $::quartus(version) "

        catch {bind $widgets(mainframe) <Destroy> {::quartus::dse::gui::close_gui}}

        $widgets(notebook) raise explore

        . configure -cursor arrow
    }

    ::quartus::dse::gui::update_approximate_compile_time

    return 1
}


#############################################################################
##  Procedure:  on_open_recent_project
##
##  Arguments:
##      None
##
##  Description:
##      Call back for the recent projects list in the menu. Just calls
##      on_open_project with the appropriate project name.
proc ::quartus::dse::gui::on_open_recent_project {args} {

    set debug_name "::quartus::dse::gui::on_open_recent_project()"

    # Import global namespace variables
    global widgets
	global global_dse_options

    # We only do this if the project name is not #_optional_# and the
    # project still exists.
    set project $global_dse_options(gui-recent-project-selection)

    if { ![string equal $project "#_optional_#"] } {
        if {[project_exists $project]} {
            set global_dse_options(gui-recent-project-selection) "#_optional_#"
            return [on_open_project -project "$project"]
        } else {
            # Tell the user the recent project they selected doesn't exist
            set global_dse_options(gui-recent-project-selection) "#_optional_#"
            set msg "Project $project could not be found.\n"
            ::quartus::dse::ccl::eputs "$msg"
            catch { tk_messageBox -type ok -message $msg -icon error -title "Error Opening Project"}
        }
    }

    return 0
}


#############################################################################
##  Procedure:  close_gui
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Clean up. Close it down.
proc ::quartus::dse::gui::close_gui {args} {
    global exit_dse_gui
    variable hh

    # Write GUI State
    ::quartus::dse::ccl::save_state_to_disk

    # For context-sensitive help
    catch {$hh closeHelp}

    set exit_dse_gui 1
    return $exit_dse_gui
}


#############################################################################
##  Procedure:  on_open_project
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##          -project
##              Optional. Bypasses the "File Open..." dialog and
##              proceeds to directly opening the project.
##
##          -revision
##              Optional. Specify a revision name for the -project
##              being opened. Only has an effect if you use the
##              -project option. Without this the default revision
##              for the project is opened.
##
##  Description:
##      Provides dialog box to open a Quartus II project. Or opens
##      the project directly if you use the options above.
proc ::quartus::dse::gui::on_open_project {args} {

    set debug_name "::quartus::dse::gui::on_open_project()"

    set args [join $args]

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable working_dir

    # Command line options to this function we require
    lappend function_opts [list "project.arg" "#_optional_#" "optional project to open right away"]
    lappend function_opts [list "revision.arg" "#_optional_#" "Optional revision name to use when opening -project"]

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    set cont 1
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "Missing required option: -$opt"
        }
    }

    set typelist {
        {"Quartus II Project File" {".qpf"}}
        {"Quartus II Settings File" {".qsf"}}
        {"All Files" {"*.*"}}
    }

    if {$optshash(project) == "#_optional_#"} {
        set file_name [tk_getOpenFile -filetypes $typelist -parent $widgets(mainframe) -title "Open Project"]
        set opthash(project) "#_optional_#"
        set optshash(revision) "#_optional_#"
    } else {
        set file_name $optshash(project)
    }

    if {$file_name != ""} {

        # Figure out the working directory of the project, project name
        # and file extension...
        set file_name [file normalize $file_name]
        set working_dir [file dirname $file_name]
        regsub -nocase -- {\.\w+$} [file tail $file_name] {} project_name
		if {![regexp -nocase -- {\.(\w+?)$} [file tail $file_name] => file_ext]} {
			set file_ext "qpf"
			set file_name "${file_name}.qpf"
		}

		# The project file has to be user writeable otherwise DSE doesn't work.
		if { ![file writable $file_name] } {
			set msg "Project file $file_name is not writeable.\nPlease make $file_name writeable and try opening it in DSE again."
            catch { tk_messageBox -type ok -message $msg -icon error -title "Error Opening Project"}
            return 0
		}

		# The project directory has to be user writeable otherwise DSE doesn't
		# work the way it should.
		if { ![file writable $working_dir] } {
			set msg "Project diretory $working_dir is not writeable.\nPlease make $working_dir writeable and try opening the project in DSE again."
			catch { tk_messageBox -type ok -message $msg -icon error -title "Error Opening Project"}
			return 0
		}

        cd $working_dir

        if {[$widgets(labentProjectName) cget -text] != ""} {
			# There is currently a project open, close it!
			on_close_project
		}

        # Project had better exist!
        if {![project_exists $project_name]} {
            set msg "Project $project_name could not be found.\nAre you sure $file_name is a valid Quartus II project?"
            ::quartus::dse::ccl::eputs "$msg"
            catch { tk_messageBox -type ok -message $msg -icon error -title "Error Opening Project"}
            return 0
        }

        # Get the revision name first if the user didn't give us one
        set project_revisions [get_project_revisions $project_name]
        if {$optshash(revision) == "#_optional_#"} {
            if { [llength $project_revisions] > 0 } {
                # Note we should be asking what the default revision
                # is if none is given by the user, not assuming it's the
                # top revision on the list!
                set optshash(revision) [get_current_revision $project_name]
                set project_revision_index 0
            } else {
                set msg "DSE cannot open project.\nProject $project_name has no revisions.\nAre you sure $project_name is a valid Quartus II project?"
                ::quartus::dse::ccl::eputs "$msg"
                catch { tk_messageBox -type ok -message $msg -icon error -title "Error Opening Project"}
                return 0
            }
        }

        # Search the revisions and find the index that
        # matches the revision the user wants to use -- default to
        # zero if the revision cannot be found
        set project_revision_index 0
        for {set i 0} {$i < [llength $project_revisions]} {incr i} {
            set rev [lindex $project_revisions $i]
            if {[string equal $rev $optshash(revision)]} {
                set project_revision_index $i
                break
            }
        }
        # Just make sure this is a valid revision name
        set optshash(revision) [lindex $project_revisions $project_revision_index]

        # Open the project
        project_open -force -revision $optshash(revision) $project_name

        # Figure out the family for this project
        set project_family [get_global_assignment -name family]

        # Check for DO_COMBINED_ANALYSIS in the design. We need to note
        # if combined analysis is off or on in order to parse the results
        # of this design in an appropriate fashion.
        set temp [get_global_assignment -name DO_COMBINED_ANALYSIS]
        if {$temp == ""} {
            set temp "OFF"
        }
        ::quartus::dse::ccl::dputs "${debug_name}: Found DO_COMBINED_ANALYSIS = $temp for this project"
        if {[string equal -nocase $temp "on"]} {
            set global_dse_options(gui-do-combined-analysis) 1
        } else {
            set global_dse_options(gui-do-combined-analysis) 0
        }

        # Check for STA_MODE in this design. If the user is doing timing
        # analysis with the TimeQuest Static Timing Analyzer we will
        # collect data slightly differently. Also, if TimeQuest is in use
        # we don't need to worry about fast/slow timing models from the
        # DO_COMBINED_ANALYSIS setting.
        set global_dse_options(gui-sta-mode) 0
        if {[get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] == ""} {
                if {[test_family_trait_of -family [get_global_assignment -name FAMILY] -trait USE_STA_BY_DEFAULT]} {
                    set global_dse_options(gui-sta-mode) 1
                }
        } else {
                if {[string equal -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] "on"]} {
                    set global_dse_options(gui-sta-mode) 1
                }
        }
        # If TimeQuest is in use check to see if the multicorner analysis is in use.
        if { $global_dse_options(gui-sta-mode) } {
            set temp [get_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS]
            if {$temp == ""} {
                set temp "OFF"
            }
            ::quartus::dse::ccl::dputs "${debug_name}: Found TIMEQUEST_MULTICORNER_ANALYSIS = $temp for this project"
            if {[string equal -nocase $temp "on"]} {
                set global_dse_options(gui-do-combined-analysis) 1
            } else {
                set global_dse_options(gui-do-combined-analysis) 0
            }
        }

        # If TimeQuest is being used we need to make sure the user has specified
        # some constraints. Otherwise running DSE doesn't make any sense.
        if { $global_dse_options(gui-sta-mode) } {
            # Check to see if an SDC_FILE setting exists. If it doesn't check
            # to see if a <revision>.sdc file exists. If both these checks
            # fail don't allow the user to run DSE on this project because it
            # has no timing constraints and is using TimeQuest.
            set sdc_file_list [list]
            foreach_in_collection instance [get_all_global_assignments -name SDC_FILE] {
               lappend sdc_file_list [lindex $instance 2]
            }
            if { [llength $sdc_file_list] == 0 || [file exists [get_current_revision].sdc] } {
                lappend sdc_file_list [get_current_revision].sdc
            }
            foreach {sdc_file} $sdc_file_list {
                if { ![file exists $sdc_file] } {
                    set msg "Unable to find SDC file:\n\t$sdc_file\nYou cannot use Design Space Explorer and TimeQuest without\na valid set of timing constraints for your design."
                    ::quartus::dse::ccl::eputs "$msg"
                    catch { tk_messageBox -type ok -message $msg -icon error -title "Error Opening Project"}
                    project_close
                    on_close_project
                    return 0
                } else {
                    ::quartus::dse::ccl::dputs "${debug_name}: Found SDC file $sdc_file"
                }
            }
        }

        # Save the project name and revision in the global_dse_options so we can
        # revert back to the last known good project/revision combination in
        # the event of an error.
        set global_dse_options(gui-project) $project_name
        set global_dse_options(gui-revision) $optshash(revision)

		::quartus::dse::designspace::get_base_point_options

        # Close the project and start the flow
        project_close

        update_gui -project-loaded -project $project_name -family $project_family -revisions $project_revisions -revision-index $project_revision_index
    }

    return 1
}


#############################################################################
##  Procedure:  on_close_project
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Closes a project correctly in the GUI.
proc ::quartus::dse::gui::on_close_project {} {

    set debug_name "::quartus::dse::gui::on_open_project()"

    # Import global namespace variables
    global widgets
    update_gui -gui-created
    return 1
}



#############################################################################
##  Procedure:  on_change_revision
##
##  Arguments:
##		<none>
##
##  Description:
##		Test to see if a revision change is changing the family for the
##		design. If it is, it redraws the GUI so the DSE options reflect
##		the family change. Otherwise it doesn't do anything at all.
proc ::quartus::dse::gui::on_change_revision {} {

    set debug_name "::quartus::dse::gui::on_change_revision()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable working_dir

    set project 		[$widgets(labentProjectName) cget -text]
    set current_family  	[$widgets(labentProjectFamily) cget -text]
    set current_sta_mode        $global_dse_options(gui-sta-mode)
    set revisions 		[$widgets(cboxRevisionName) cget -values]
    set new_revision_index 	[$widgets(cboxRevisionName) getvalue]
    set new_revision 		[lindex $revisions $new_revision_index]

    # When the user changes the revision it's quite like opening an entirely
    # new project. So we call the on_open_project action and if it fails we
    # revert back to what was previously open (which should be a known good
    # project/revision combination since it was already open).
    if {[catch {on_open_project -project $project -revision $new_revision} msg]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error changing revision: $msg"
        ::quartus::dse::ccl::dputs "${debug_name}: Reverting back to last know good project/revision combination"
        return [on_open_project -project $project -revision $global_dse_options(gui-revision)]
    }
    update_approximate_compile_time
    return 1
}


#############################################################################
##  Procedure:  on_select_search_method
##
##  Arguments:
##
##  Description:
proc ::quartus::dse::gui::on_select_search_method {} {

    set debug_name "::quartus::dse::gui::on_select_search_method()"

    # Import global namespace variables
    global widgets
    variable available_search_methods
    variable selected_flow_function

    set selected_search_method [lindex $available_search_methods [$widgets(dlgCustom.cboxSearchMethod) getvalue]]

    # Print description for search method
    switch -- $selected_search_method {
        {Exhaustive Search of Exploration Space} {
            $widgets(dlgCustom.labelSearchMethodDescription) configure -text "An exhaustive search of your exploration space."
            set selected_flow_function {::quartus::dse::flows::exhaustive_flow}
        }
        {Accelerated Search of Exploration Space} {
            $widgets(dlgCustom.labelSearchMethodDescription) configure -text "Finds the best fitter and mapper settings for your design before sweeping your seeds."
            set selected_flow_function {::quartus::dse::flows::accelerated_flow}
        }
        default {
            $widgets(dlgCustom.labelSearchMethodDescription) configure -text "No description for selected search method available."
            set selected_flow_function {unknown}
        }
    }

	update_approximate_compile_time

    return 1
}


#############################################################################
##  Procedure:  on_select_concurrent_compiles
##
##  Arguments:
##
##  Description:
##      Displays a warning to the user if they opt to run more than
##      one compile concurrently on this machine.
proc ::quartus::dse::gui::on_select_concurrent_compiles {} {

    set debug_name "::quartus::dse::gui::on_select_concurrent_compiles()"

    # Import global namespace variables
    global widgets
	global global_dse_options

    # Print description for search method
    switch -- $global_dse_options(gui-concurrent-compiles) {
        0 -
        1 {
            # Do nothing. One compile is safe.
        }
        default {
            # Warn the user about memory, disk, processor and license usage
            set msg "Warning!\nYou are specifying that this computer perform more than one compilation simultaneously. Performing more than one compilation requires significant computing power, memory resources, and additional Quartus II licenses. If you experience problems exploring $global_dse_options(gui-concurrent-compiles) points simultaneously, reduce the number of concurrent compilations to free resources and improve performance."
            catch {tk_messageBox \
                -message $msg \
                -type ok \
                -icon warning \
                -title "Warning" \
                -parent .}
            catch {unset msg}
        }
    }

    return 1
}


#############################################################################
##  Procedure:  on_select_optimization_goal
##
##  Arguments:
##
##  Description:
proc ::quartus::dse::gui::on_select_optimization_goal {} {

    set debug_name "::quartus::dse::gui::on_select_optimization_goal()"

    # Import global namespace variables
    global widgets
    variable available_optimization_goals
    variable selected_optimization_goal
    variable selected_decision_function

    set selected_optimization_goal [lindex $available_optimization_goals [$widgets(dlgCustom.cboxOptGoal) getvalue]]

    # Print description for search method
    switch -- $selected_optimization_goal {
        {Optimize for Speed} {
            $widgets(dlgCustom.labelOptGoalDescription) configure -text "Choose the best settings for your design based on the best worst-case slack value in your design."
            set selected_decision_function {::quartus::dse::flows::simple_slack_best_worst_analysis}
        }
        {Optimize for Area} {
            $widgets(dlgCustom.labelOptGoalDescription) configure -text "Choose the best settings for your design based on the lowest logic cell count with worst-case slack that is still positive."
            set selected_decision_function {::quartus::dse::flows::simple_area_best_worst_analysis}
        }
        {Optimize for Failing Paths} {
            $widgets(dlgCustom.labelOptGoalDescription) configure -text "Choose the best settings for your design based on the lowest number of failing paths in the design. DSE will stop exploring when zero failing paths are achieved."
            set selected_decision_function {::quartus::dse::flows::simple_failing_paths_best_worst_analysis}
        }
        {Optimize for Power} {
            $widgets(dlgCustom.labelOptGoalDescription) configure -text "Choose the best settings for your design based on the lowest total thermal power dissipation with worst-case slack that is still positive."
            set selected_decision_function {::quartus::dse::flows::simple_power_best_worst_analysis}
        }
        {Optimize for Negative Slack and Failing Paths} {
            $widgets(dlgCustom.labelOptGoalDescription) configure -text "Choose the best settings for your design based on the best average negative slack and lowest number of failing paths for your design. If two points are the same with regard to failing paths and average negative slack then the decision is based on the best worst-case slack instead."
            set selected_decision_function {::quartus::dse::flows::average_slack_for_failing_paths_best_worst_analysis}
        }
        {Optimize for Average Period} {
            $widgets(dlgCustom.labelOptGoalDescription) configure -text "Choose the best settings for your design based on the lowest geometric mean of all clock periods in the design."
            set selected_decision_function {::quartus::dse::flows::simple_geomean_period_best_worst_analysis}
        }
        {Optimize for Quality of Fit} {
            $widgets(dlgCustom.labelOptGoalDescription) configure -text "Choose the best settings for your design based on the highest calculated quality of fit metric for each point."
            set selected_decision_function {::quartus::dse::flows::qof_best_worst_analysis}
        }
        default {
            $widgets(dlgCustom.labelOptGoalDescription) configure -text "No description for selected optimization goal available."
            set selected_decision_function {unknown}
        }
    }

    return 1
}


#############################################################################
##  Procedure:  on_select_exploration_space
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
proc ::quartus::dse::gui::on_select_exploration_space {} {

    set debug_name "::quartus::dse::gui::on_select_exploration_space()"

    # Import global namespace variables
    global widgets
    variable available_exploration_spaces
    variable selected_exploration_space
    variable procGetDescriptionForSpace
	variable advanced_use

	if {$advanced_use} {
		set selected_exploration_space [lindex $available_exploration_spaces [$widgets(dlgCustom.cboxExplorationSpaces) getvalue]]
		::quartus::dse::ccl::dputs "${debug_name}: Found exploration set to \"$selected_exploration_space\" (index [$widgets(dlgCustom.cboxExplorationSpaces) getvalue]) in dialog box"
		::quartus::dse::ccl::dputs "${debug_name}: Had choice from list: $available_exploration_spaces"

		if {$selected_exploration_space != "" && $procGetDescriptionForSpace != ""} {
			$widgets(dlgCustom.labelExplorationSpaceDescription) configure -text [$procGetDescriptionForSpace $selected_exploration_space]
		} else {
			$widgets(dlgCustom.labelExplorationSpaceDescription) configure -text "Please load a project to see available exploration spaces."
		}

		# If they're use a custom space get them to load a file
		if {[string equal -nocase $selected_exploration_space "Custom Space"]} {
			::quartus::dse::gui::on_choose_custom_space_file -parent $widgets(mainframe)
		}
	}

	::quartus::dse::gui::update_approximate_compile_time

    return $selected_exploration_space
}


#############################################################################
##  Procedure:  on_select_quick_optimization
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
proc ::quartus::dse::gui::on_select_quick_optimization {} {

    set debug_name "::quartus::dse::gui::on_select_quick_optimization()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable available_speed_effort_levels
    variable selected_quick_optimization
    variable selected_optimization_goal
    variable selected_exploration_space
    variable selected_decision_function
    variable selected_flow_function
    variable procGetRecipe
	variable advanced_use

    switch -- $selected_quick_optimization {
        "area" {
            ::quartus::dse::ccl::dputs "${debug_name}: User selected area quick opt goal"

            # Get the quick recipe for this family
            set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "area"]
            if {[llength $quick_recipe] == 0} {
                # Wow. This is such a bad error. How did we get here?
                catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous!" -icon error -title "We shouldn't be here!"}
                on_close_project
                close_gui
            }

            set selected_exploration_space [lindex $quick_recipe 0]
            set selected_optimization_goal [lindex $quick_recipe 1]
            set selected_decision_function [lindex $quick_recipe 2]
            set selected_flow_function [lindex $quick_recipe 3]

            # Some widgets need to change now because we're doing an area optimization
            $widgets(cboxEffort) configure -state disabled
            $widgets(labelEffort) configure -state disabled
            $widgets(checkQiiis) configure -state normal
            $widgets(checkLogiclock) configure -state normal
			catch {$widgets(notebook) itemconfigure advanced -state disabled}
            $widgets(notebook) raise config
        }
        "speed" {
            ::quartus::dse::ccl::dputs "${debug_name}: User selected speed quick opt goal"

            switch -- [lindex $available_speed_effort_levels [$widgets(cboxEffort) getvalue]]  {
                {Low (Seed Sweep)} {
                    # Get the quick recipe for this family
                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:low"]
                    if {[llength $quick_recipe] == 0} {
                        # Wow. This is such a bad error. How did we get here?
                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous!" -icon error -title "We shouldn't be here!"}
                        on_close_project
                        close_gui
                    }
                }
                {Medium (Extra Effort Space)} {
                    # Get the quick recipe for this family
                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:medium"]
                    if {[llength $quick_recipe] == 0} {
                        # Wow. This is such a bad error. How did we get here?
                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous!" -icon error -title "We shouldn't be here!"}
                        on_close_project
                        close_gui
                    }
                }
                {High (Physical Synthesis Space)} {
                    # Get the quick recipe for this family
                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:high"]
                    if {[llength $quick_recipe] == 0} {
                        # Wow. This is such a bad error. How did we get here?
                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous!" -icon error -title "We shouldn't be here!"}
                        on_close_project
                        close_gui
                    }
                }
                {Highest (Physical Synthesis with Retiming Space)} {
                    # Get the quick recipe for this family
                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:highest"]
                    if {[llength $quick_recipe] == 0} {
                        # Wow. This is such a bad error. How did we get here?
                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous!" -icon error -title "We shouldn't be here!"}
                        on_close_project
                        close_gui
                    }
                }
                {Selective (Selected Performance Optimizations)} {
                    # Get the quick recipe for this family
                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:selective"]
                    if {[llength $quick_recipe] == 0} {
                        # Wow. This is such a bad error. How did we get here?
                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous!" -icon error -title "We shouldn't be here!"}
                        on_close_project
                        close_gui
                    }
                }
                default {
                    # Wow. This is such a bad error. How did we get here?
                    catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous!" -icon error -title "We shouldn't be here!"}
                    on_close_project
                    close_gui
                }
            }

            set selected_exploration_space [lindex $quick_recipe 0]
            set selected_optimization_goal [lindex $quick_recipe 1]
            set selected_decision_function [lindex $quick_recipe 2]
            set selected_flow_function [lindex $quick_recipe 3]

            # Some widgets need to change now because we're doing an area optimization
            $widgets(cboxEffort) configure -state normal
            $widgets(labelEffort) configure -state normal
            $widgets(checkQiiis) configure -state normal
            $widgets(checkLogiclock) configure -state normal
			catch {$widgets(notebook) itemconfigure advanced -state disabled}
            $widgets(notebook) raise config
        }
        "power" {
            ::quartus::dse::ccl::dputs "${debug_name}: User selected power quick opt goal"

            # Get the quick recipe for this family
            set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "power"]
            if {[llength $quick_recipe] == 0} {
                # Wow. This is such a bad error. How did we get here?
                catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous!" -icon error -title "We shouldn't be here!"}
                on_close_project
                close_gui
            }

            set selected_exploration_space [lindex $quick_recipe 0]
            set selected_optimization_goal [lindex $quick_recipe 1]
            set selected_decision_function [lindex $quick_recipe 2]
            set selected_flow_function [lindex $quick_recipe 3]

            # Some widgets need to change now because we're doing an area optimization
            $widgets(cboxEffort) configure -state disabled
            $widgets(labelEffort) configure -state disabled
            $widgets(checkQiiis) configure -state normal
            $widgets(checkLogiclock) configure -state normal
			catch {$widgets(notebook) itemconfigure advanced -state disabled}
            $widgets(notebook) raise config
        }
        "custom" {
            ::quartus::dse::ccl::dputs "${debug_name}: User selected custom quick opt goal"
            $widgets(cboxEffort) configure -state disabled
            $widgets(labelEffort) configure -state disabled
            $widgets(checkQiiis) configure -state disabled
            $widgets(checkLogiclock) configure -state normal
			catch {$widgets(notebook) itemconfigure advanced -state normal}
            ::quartus::dse::gui::on_select_search_method
            set selected_exploration_space [::quartus::dse::gui::on_select_exploration_space]
        }
        default {
            # Do nothing
        }
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Set selected_optimization_goal to: $selected_optimization_goal"
    ::quartus::dse::ccl::dputs "${debug_name}: Set selected_decision_function to: $selected_decision_function"
    ::quartus::dse::ccl::dputs "${debug_name}: Set selected_flow_function to:     $selected_flow_function"
    ::quartus::dse::ccl::dputs "${debug_name}: Set selected_exploration_space to: $selected_exploration_space"

    ::quartus::dse::gui::update_approximate_compile_time

    return 1
}


#############################################################################
##  Procedure:  on_about_dse
##
##  Arguments:
##
##  Description:
proc ::quartus::dse::gui::on_about_dse {} {

    set debug_name "::quartus::dse::gui::on_about_dse()"

    # Import global namespace variables
    global widgets
    variable app_window_icon
    variable app_icon_path

	# Destroy an existing copy of this widget
	catch {destroy $widgets(dlgAboutDSE)}
	catch {array unset widgets *AboutDSE}

    # Dialog never used before. Create it now.
    addWidget dlgAboutDSE [Dialog $widgets(mainframe).aboutdlg -modal local -title "About DSE" -transient 1 -default 0 -separator 0 -image [Bitmap::get [file join $app_icon_path "dse"]] ]
    wm iconbitmap $widgets(mainframe).aboutdlg $app_window_icon
    $widgets(dlgAboutDSE) add -text "OK"
    set dlgFrame [$widgets(dlgAboutDSE) getframe]
    # Add a Label Entry to the dialog
    Label $dlgFrame.l1 -text "Altera Design Space Explorer" -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 12 bold}
    Label $dlgFrame.l2 -text "Version $::quartus::dse::version" -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 12}
    Label $dlgFrame.l3 -text "[get_quartus_legal_string -product] $::quartus(version)" -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 8} -pady 10
    set msg "$::quartus(copyright). All rights reserved. Quartus II is a registered trademark of Altera Corporation in the US and other countries. Portions of the Quartus II software code, and other portions of the code included in this download or on this CD, are licensed to Altera Corporation and are the copyrighted property of third parties who may include, without limitation, Sun Microsystems, The Regents of the University of California, Softel vdm., and Verific Design Automation Inc."
    Label $dlgFrame.l4 -text $msg -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 8} -pady 10 -wraplength 400
    set msg "Warning: This computer program is protected by copyright law and international treaties. Unauthorized reproduction or distribution of this program, or any portion of it, may result in severe civil and criminal penalties, and will be prosecuted to the maximum extent possible under the law."
    Label $dlgFrame.l5 -text $msg -justify left -anchor w -borderwidth 1 -relief flat -font {helvetica 8} -pady 10 -wraplength 400
    pack $dlgFrame.l1 $dlgFrame.l2 $dlgFrame.l3 $dlgFrame.l4 $dlgFrame.l5 -expand yes -anchor nw -fill x


    # Show the dialog
    set retval [$widgets(dlgAboutDSE) draw]

    catch {destroy $widgets(dlgAboutDSE)}
    catch {array unset widgets *AboutDSE}

    return 1
}


#############################################################################
##  Procedure:  on_help
##
##  Arguments:
##
##  Description:
proc ::quartus::dse::gui::on_help {args} {

    set debug_name "::quartus::dse::gui::on_help()"

    # Import global namespace variables
    global widgets
    variable hh
    variable app_window_icon

    lappend function_opts [list "parent.arg" $widgets(mainframe) "Parent window for dialog"]
    lappend function_opts [list "page.arg" "intro.htm" "Page to open in context-sensitive help module"]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    if {$hh != "" && [$hh isa ::quartus::hh]} {
        catch {$hh getHelp -thread $optshash(page)}
    } else {
        # Fall back on the old help window...
        if {![info exists widgets(mfHelp)]} {

            #
            # BEGIN GUI CREATION CODE
            #

            toplevel .help
            wm iconbitmap .help $app_window_icon
            wm withdraw .help
            wm title .help "DSE Help"
            addWidget mfHelp .help

            # Put a MainFrame in the this window so we have a menu bar
            addWidget dlgHelp [ frame $widgets(mfHelp).dlg ]

            set f $widgets(dlgHelp)

            addWidget swHelp [ScrolledWindow $f.sw -auto none]
            addWidget txtHelp [text $widgets(swHelp).txthelp -relief flat -wrap none]
            $widgets(swHelp) setwidget $widgets(txtHelp)
            if {![catch {open "|\"[file join $::quartus(binpath) quartus_sh]\" --help=dse"} input]} {
                $widgets(txtHelp) insert end [read $input]
                close $input
            } else {
                $widgets(txtHelp) insert end "Could not locate help for DSE.\n"
                $widgets(txtHelp) insert end "Try:\n"
                $widgets(txtHelp) insert end "\tquartus_sh --help=dse\n"
                $widgets(txtHelp) insert end "from a command prompt to view DSE help information.\n"
            }
            $widgets(txtHelp) configure -state disabled

            # Pack it all together now
            pack $widgets(swHelp) -expand yes -fill both
            pack $f -fill both -expand yes -anchor nw
            pack $widgets(dlgHelp) -fill both -expand yes

            # Bind destroy so it does the right thing
            bind $widgets(dlgHelp) <Destroy> {global widgets; if {"%W" == "$widgets(dlgHelp)"} {array unset widgets *Help}}

            # Show the help dialog
            BWidget::place $widgets(mfHelp) 0 0 center
            wm deiconify $widgets(mfHelp)
            focus -force $widgets(mfHelp)

            #
            # END GUI CREATION CODE
            #

        } else {
            wm withdraw $widgets(mfHelp)
            wm deiconify $widgets(mfHelp)
        }
    }


    return 1
}


#############################################################################
##  Procedure:  on_view_report
##
##  Arguments:
##
##  Description:
proc ::quartus::dse::gui::on_view_report {} {

    set debug_name "::quartus::dse::gui::on_view_report()"

    # Import global namespace variables
    global widgets
    variable app_window_icon

    set project_name [$widgets(labentProjectName) cget -text]
    set revision [lindex [$widgets(cboxRevisionName) cget -values] [$widgets(cboxRevisionName) getvalue]]

    if {[regexp -nocase -- {$\s*^} $project_name]} {
        # No project is open: error
        set msg "No project open.\nPlease open a project to view a DSE report."
        ::quartus::dse::ccl::eputs "$msg"
        tk_messageBox -type ok -message $msg -icon error -title "Error Viewing DSE Report"
    } elseif {![file exists ${revision}.dse.rpt]} {
        # No report file exists: error
        set msg "No DSE report file found for project ${project_name}."
        ::quartus::dse::ccl::eputs "$msg"
        tk_messageBox -type ok -message $msg -icon error -title "No DSE Report Available"
    } else {
        # Report file is there. Open it and show it to the user.
        if {![info exists widgets(dlgReportWindow)]} {
            addWidget dlgReportWindow [Dialog $widgets(mainframe).rptdlg -modal none -side bottom -transient 0 -parent $widgets(mainframe) -place center -separator 1 -title "View Last DSE Report for Project" -default 0]
            wm iconbitmap $widgets(mainframe).rptdlg $app_window_icon
            bind $widgets(dlgReportWindow) <Destroy> {global widgets; if {"%W" == "$widgets(dlgReportWindow)"} {array unset widgets *ReportWindow}}
            $widgets(dlgReportWindow) add -text "Close" -command {global widgets; destroy $widgets(dlgReportWindow)}
            set dlgFrame [$widgets(dlgReportWindow) getframe]

            addWidget swReportWindow [ScrolledWindow $dlgFrame.sw -auto none]
            addWidget txtReportWindow [text $widgets(swReportWindow).txt -relief flat -wrap none -font {Courier -12} -exportselection 0]

            # The user should be able to select all the text in the window with Ctrl-A
            $widgets(txtReportWindow) tag config bold -font {helvetica 12 bold}
            bind $widgets(txtReportWindow) <Control-a> {%W tag add sel 1.0 end; break;}

            $widgets(swReportWindow) setwidget $widgets(txtReportWindow)
            pack $widgets(swReportWindow) -expand yes -fill both
            if {![catch {open ${revision}.dse.rpt} input]} {
                $widgets(txtReportWindow) insert end [read $input]
                close $input
            } else {
                $widgets(txtReportWindow) insert end "Could not locate a DSE report for this project.\n"
            }

			#
			# START SPR 248297
			#
			# Make this a read-only text box without resorting
			# to disabling the text widget because this doesn't work
			# uniformly on all platforms. This lets the user cut from
			# the window to the system clipboard.
			rename "::$widgets(txtReportWindow)" "::$widgets(txtReportWindow).internal"
			proc "::$widgets(txtReportWindow)" {args} {
				global widgets
				switch -- [lindex $args 0] {
					"insert" {}
					"delete" {}
					"default" { return [eval "::$widgets(txtReportWindow).internal" $args] }
				}
			}
			#
			# END SPR 248297
			#

            # The user should be able to get window-specific help by hitting the F1 key.
            bind $widgets(dlgReportWindow) <F1> {::quartus::dse::gui::on_help -page /dse/dse_db_view_last_report.htm}

            # Show the dialog
            $widgets(dlgReportWindow) draw
        } else {
            $widgets(dlgReportWindow) withdraw
            $widgets(dlgReportWindow) draw
        }
    }

    return 1
}


#############################################################################
##  Procedure:  on_stop_after_time
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Use a nice little window to to get the time value and
##      check it for correctness.
proc ::quartus::dse::gui::on_stop_after_time {} {

    set debug_name "::quartus::dse::gui::on_stop_after_time()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable app_window_icon

	# Destroy and existing copy of this widget
	catch {destroy $widgets(dlgSAT)}
	catch {array unset widgets *SAT}

    addWidget dlgSAT [Dialog $widgets(mainframe).satdlg -modal local -side bottom -transient 1 -parent $widgets(mainframe) -place center -separator 1 -title "Stop Flow After Time" -default 0]
    wm iconbitmap $widgets(mainframe).satdlg $app_window_icon
    $widgets(dlgSAT) add -text "OK" -helptext "Accept changes" -helptype balloon -command {
        global widgets
        set end_dialog 0

        # Value must be in the form \d\d:\d\d:\d\d
        if {[regexp -nocase -- {(\d\d:\d\d:\d\d)} $global_dse_options(gui-stop-after-time) => global_dse_options(gui-stop-after-time)]} {
            set end_dialog 1
        }

        # Or the default value dd:hh:mm
        if {[regexp -nocase -- {(dd:hh:mm)} $global_dse_options(gui-stop-after-time) => global_dse_options(gui-stop-after-time)]} {
            set end_dialog 1
        }

        if {$end_dialog} {
            $widgets(dlgSAT) enddialog 1
        } else {
            MessageDlg $widgets(dlgSAT).errmsg -type ok -icon error -message "Time value must be the form dd:hh:mm." -parent $widgets(dlgSAT)
        }
    }

    $widgets(dlgSAT) add -text "Default" -helptext "Set to default value and continue" -helptype balloon -command {
        global widgets
        set global_dse_options(gui-stop-after-time) $global_dse_options(gui-stop-after-time-default)
        $widgets(dlgSAT) enddialog 1
    }

    $widgets(dlgSAT) add -text "Cancel" -helptext "Cancel" -helptype balloon -command {
        global widgets
        $widgets(dlgSAT) enddialog 0
    }

    set dlgFrame [$widgets(dlgSAT) getframe]
    # Add a Label Entry to the dialog
    addWidget labentSAT [LabelEntry $dlgFrame.sag -label "Elapsed Time:" -textvariable {global_dse_options(gui-stop-after-time)} -padx 2 -pady 2 -editable 1]
    pack $dlgFrame $widgets(labentSAT) -anchor nw -side top -expand yes

    # Save the current value
    set curr_val $global_dse_options(gui-stop-after-time)

    # The user should be able to get window-specific help by hitting the F1 key.
    bind $widgets(dlgSAT) <F1> {::quartus::dse::gui::on_help -page /dse/dse_db_stop_flow_after_time.htm}

    # Show the dialog
    set retval [$widgets(dlgSAT) draw $widgets(labentSAT)]

    if {$retval <= 0} {
        # User cancled. Restore original value.
        set global_dse_options(gui-stop-after-time) $curr_val
        if {$retval < 0} {
            # User killed dialog instead of pressing a button
            # so dialog doesn't exist anymore. We won't be
            # redrawing it anytime soon.
        }
    }

    catch {destroy $widgets(dlgSAT)}
    catch {array unset widgets *SAT}

    return 1
}




#############################################################################
##  Procedure: on_choose_custom_space_file
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Use a nice little window to to get the name of a custom
##      space file that should be used during the custom flow
proc ::quartus::dse::gui::on_choose_custom_space_file {args} {

    set debug_name "::quartus::dse::gui::on_choose_custom_space_file()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable app_window_icon

	# Destroy an existing copy of this widget
	catch {destroy $widgets(dlgCSF)}
	catch {array unset widgets *CSF}

    lappend function_opts [list "parent.arg" $widgets(mainframe) "Parent window for dialog"]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    addWidget dlgCSF [Dialog $optshash(parent).csfdlg -modal local -side bottom -transient 1 -parent $optshash(parent) -place center -separator 1 -title "Custom Space File" -default 0]
    wm iconbitmap $optshash(parent).csfdlg $app_window_icon
    $widgets(dlgCSF) add -text "OK" -helptext "Accept changes" -helptype balloon -command {
        global widgets
        set end_dialog 0

        if {$global_dse_options(gui-custom-space-file) != $global_dse_options(gui-custom-space-file-default)} {
            # File must exist and be a file
            if {[file exists $global_dse_options(gui-custom-space-file)] && [file isfile $global_dse_options(gui-custom-space-file)]} {
                set end_dialog 1
            }
        } else {
            set end_dialog 1
        }

        if {$end_dialog} {
            $widgets(dlgCSF) enddialog 1
        } else {
            MessageDlg $widgets(dlgCSF).errmsg -type ok -icon error -message "The file you specified was not found." -parent $widgets(dlgCSF)
        }
    }

    $widgets(dlgCSF) add -text "Find..." -helptext "Find a custom space file using a file browser" -helptype balloon -command {set global_dse_options(gui-custom-space-file) [tk_getOpenFile -filetypes {{"DSE Custom Space Files" {".dse" ".xml"}} {"All Files" {"*.*"}}} -parent $widgets(mainframe) -title "Find"];}

    $widgets(dlgCSF) add -text "Default" -helptext "Set to default value and continue" -helptype balloon -command {
        global widgets
        set global_dse_options(gui-custom-space-file) $global_dse_options(gui-custom-space-file-default)
        $widgets(dlgCSF) enddialog 1
    }

    $widgets(dlgCSF) add -text "Cancel" -helptext "Cancel" -helptype balloon -command {
        global widgets
        $widgets(dlgCSF) enddialog 0
    }

    set dlgFrame [$widgets(dlgCSF) getframe]
    # Add a Label Entry to the dialog
    addWidget labentCSF [LabelEntry $dlgFrame.csf -label "Custom File:" -textvariable {global_dse_options(gui-custom-space-file)} -padx 2 -pady 2 -editable 1]
    pack $dlgFrame $widgets(labentCSF) -anchor nw -side top -expand yes -fill x

    # Save the current value
    set curr_val $global_dse_options(gui-custom-space-file)

    # The user should be able to get window-specific help by hitting the F1 key.
    bind $widgets(dlgCSF) <F1> {::quartus::dse::gui::on_help -page /dse/dse_db_custom_file.htm}

    # Show the dialog
    set retval [$widgets(dlgCSF) draw $widgets(labentCSF)]

    if {$retval <= 0} {
        # User cancled. Restore original value.
        set global_dse_options(gui-custom-space-file) $curr_val
    }

    catch {destroy $widgets(dlgCSF)}
    catch {array unset widgets *CSF}

    return 1
}


#############################################################################
##  Procedure:  on_start_exploration
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Use a nice little window to to get the time value and
##      check it for correctness.
proc ::quartus::dse::gui::on_start_exploration {} {

    set debug_name "::quartus::dse::gui::on_start_exploration()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable app_window_icon
    variable procSetDesignSpace
    variable selected_flow_function
    variable selected_decision_function
    variable selected_optimization_goal
    variable selected_exploration_space
    variable best_results
    variable base_results

    set project_name [$widgets(labentProjectName) cget -text]
    set family [string tolower [$widgets(labentProjectFamily) cget -text]]
    set revision [lindex [$widgets(cboxRevisionName) cget -values] [$widgets(cboxRevisionName) getvalue]]

    # Initialize our libraries for this run
    ::quartus::dse::ccl::init $project_name $revision "${revision}.dse.rpt"
    ::quartus::dse::flows::init

    # Check the format of the seeds option and make a list
    set seedlist [list]
    if {[catch {set seedlist [::quartus::dse::ccl::get_seed_list "$global_dse_options(gui-seeds)"]} status]} {
	    ::quartus::dse::ccl::eputs $status
	    MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message $status -parent $widgets(mainframe)
	    return 0
    }
    regsub -all -- {,} $global_dse_options(gui-seeds) { } seeds

    # Use the cleaned up seed list in the UI
    catch {set global_dse_options(gui-seeds) $seeds}

    # Create an empty results array
    array set results [list]

    # Clear flow opts
    set flops ""

    # Create a list of warning messages that we should print after we clear
    # the GUI up for a new compilation.
    set pre_compile_warning_messages [list]

    # Assume we'll call the flow funciton that was selected automatically
    # by the GUI. We may correct this assumption in a bit...
    set flow_function $selected_flow_function

    # Do things based on family here
    switch -- $family {
        {hardcopy stratix} {
            if {$global_dse_options(gui-project-try-llr-restructuring)} {
                lappend pre_compile_warning_messages "HardCopy Stratix family detected: no LogicLock Region restructuring will be done"
                set global_dse_options(gui-project-try-llr-restructuring) 0
            }
            # Turn on hardcopy flow
            lappend flops "-hardcopy"
			set global_dse_options(flow-hardcopy) 1
        }

        max3000a -
        max7000ae -
        max7000b -
        max7000s {
            lappend pre_compile_warning_messages "MAX 7000 family detected: your seed list will be ignored: seeds are not relevant"
            lappend pre_compile_warning_messages "MAX 7000 family detected: your search method will be ignored: using exhaustive search"
            set global_dse_options(gui-seeds) [list]
            set flow_function {::quartus::dse::flows::exhaustive_flow}
        }

        flex6000 -
        {flex 6000} {
            lappend pre_compile_warning_messages "FLEX 6000 family detected: your seed list will be ignored: seeds are not relevant"
            lappend pre_compile_warning_messages "FLEX 6000 family detected: your search method will be ignored: using exhaustive search"
            set global_dse_options(gui-seeds) [list]
            set flow_function {::quartus::dse::flows::exhaustive_flow}
        }

    }

	# If the user told us to create revisions than we're going to use a
	# special flow to make this happen.
	if {$global_dse_options(gui-revisions-only)} {
		set flow_function {::quartus::dse::flows::create_revisions}
	}

    # Create the designspace
    set designspace [uplevel #0 ::quartus::dse::designspace #auto $project_name $revision]
    if {$designspace == ""} {
        ::quartus::dse::ccl::eputs "Could not create design space object!"
        MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message "Could not create design space object!"  -parent $widgets(mainframe)
        return 0
    }

    # Load the appropriate logiclock space into the design space
    if {$global_dse_options(gui-project-try-llr-restructuring)} {
        ::quartus::dse::ccl::iputs "Loading space: LogicLock Restructuring Space"
        if {![::quartus::dse::logiclock::set_design_space $designspace -soften -remove]} {
            ::quartus::dse::ccl::eputs "Could not load LogicLock space."
            MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message "Could not load LogicLock space." -parent $widgets(mainframe)
            return 0
        }
    } else {
        # Just create an empty LogicLock space
        if {![::quartus::dse::logiclock::set_design_space $designspace]} {
            ::quartus::dse::ccl::eputs "Could not load an empty LogicLock space."
            MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message "Could not load an empty LogicLock space." -parent $widgets(mainframe)
            return 0
        }
    }

    # Load the appropriate map and fit spaces into the design space
    ::quartus::dse::ccl::iputs "Loading space: $selected_exploration_space"
    if {![$procSetDesignSpace $designspace $selected_exploration_space $global_dse_options(gui-custom-space-file)]} {
        ::quartus::dse::ccl::eputs "Could not load space \"$selected_exploration_space\"."
        MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message "Could not load selected space \"$selected_exploration_space\"." -parent $widgets(mainframe)
        return 0
    }

    # Load the seeds into the design space
    ::quartus::dse::ccl::iputs "Loading space: Seeds"
    if {![::quartus::dse::seed::set_design_space $designspace $seedlist]} {
        ::quartus::dse::ccl::eputs "Could not load seed space."
        MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message "Could not load seed space." -parent $widgets(mainframe)
        return 0
    }

    # If the user is running a custom space load it now
    if {[string equal $selected_exploration_space "Custom Space"]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Checking for custom space file: $global_dse_options(gui-custom-space-file)"
        if {![file exists $global_dse_options(gui-custom-space-file)] || ![file isfile $global_dse_options(gui-custom-space-file)]} {
            ::quartus::dse::ccl::eputs "Custom space file $global_dse_options(gui-custom-space-file) does not exist"
            MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message "Custom space file $global_dse_options(gui-custom-space-file) does not exist" -parent $widgets(mainframe)
            return 0
        }
        ::quartus::dse::ccl::dputs "${debug_name}: Custom space file exists"
        ::quartus::dse::ccl::dputs "${debug_name}: Opening custom space file: $global_dse_options(gui-custom-space-file)"
        if {[catch {open $global_dse_options(gui-custom-space-file)} xmlfh]} {
            ::quartus::dse::ccl::eputs "Error opening custom space file $global_dse_options(gui-custom-space-file)"
            ::quartus::dse::ccl::eputs "$xmlfh"
            MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message "Error opening custom space file $global_dse_options(gui-custom-space-file)\n$xmlfh" -parent $widgets(mainframe)
            return 0
        } else {
            ::quartus::dse::ccl::dputs "${debug_name}: Loading custom space from file"
            if {[catch {$designspace loadXML $xmlfh} emsg]} {
                close $xmlfh
                ::quartus::dse::ccl::eputs "Error loading custom space file $global_dse_options(gui-custom-space-file)"
                ::quartus::dse::ccl::eputs "$emsg"
                MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message "Error loading custom space file $global_dse_options(gui-custom-space-file)\n$emsg" -parent $widgets(mainframe)
                return 0
            }
            close $xmlfh
            ::quartus::dse::ccl::iputs "Custom space file $global_dse_options(gui-custom-space-file) loaded successfully"
        }
    }

    if {$global_dse_options(gui-dump-space-to-file)} {
        set fname ${project_name}.dse
        if {[catch {open $fname {WRONLY CREAT TRUNC}} xmlfh]} {
            ::quartus::dse::ccl::eputs "Could not dump exploration space to file $fname"
        } else {
            $designspace dumpXML $xmlfh
            close $xmlfh
            ::quartus::dse::ccl::iputs "Saved exploration space to file $fname"
        }
    }

    # Build up flow options
    lappend flops "-space"
    lappend flops $designspace
	set global_dse_options(flow-space) $designspace
    lappend flops "-results"
    lappend flops "results"
	set global_dse_options(flow-results) "results"

    # Did the user ask us to stop after a particular time?
    if {$global_dse_options(gui-stop-after-time) != $global_dse_options(gui-stop-after-time-default)} {
        regexp -nocase -- {0?(\d+):0?(\d+):0?(\d+)} $global_dse_options(gui-stop-after-time) => days hours minutes
        set minutes [expr {$minutes + ($hours * 60)}]
        set minutes [expr {$minutes + ($days * 24 * 60)}]
        lappend flops "-stop-after-time"
        lappend flops $minutes
		set global_dse_options(flow-stop-after-time) $minutes
        ::quartus::dse::ccl::dputs "${debug_name}: Stopping exploration after $minutes minutes"
    }

    # Archive every compile?
    if {$global_dse_options(gui-archive)} {
        lappend flops "-archive"
		set global_dse_options(flow-archive) 1
    }

    # Ignore a failing base compile?
    if {$global_dse_options(gui-ignore-failed-base)} {
        lappend flops "-ignore-failed-base"
		set global_dse_options(flow-ignore-failed-base) 1
    }

    # Run the power analyze during the flow if the user said
    # or if they're evaluating for power.
    if {$global_dse_options(gui-run-power) || [string equal $selected_optimization_goal "Optimize for Power"]} {
        lappend flops "-run-power"
		set global_dse_options(flow-run-power) 1
    }

    # How many concurrent compiles should we do?
    lappend flops "-concurrent-compiles"
    lappend flops $global_dse_options(gui-concurrent-compiles)
	set global_dse_options(flow-concurrent-compiles) $global_dse_options(gui-concurrent-compiles)

    # Add clients for the distributed DSE flow
    if {$global_dse_options(gui-distribute-compiles)} {
		if { [string match -nocase $global_dse_options(gui-distribute-using) "lsf"] } {
            lappend flops "-lsfmode"
            lappend flops "-lsf-queue"
            lappend flops $global_dse_options(gui-lsf-queue)
			set global_dse_options(flow-lsfmode) 1
			set global_dse_options(flow-lsf-queue) $global_dse_options(gui-lsf-queue)
        } elseif { [string match -nocase $global_dse_options(gui-distribute-using) "abc"] } {
			::quartus::dse::ccl::wputs "ABC integration is not complete. Compilations will run locally."
		} else {
			lappend flops "-slaves"
			lappend flops $global_dse_options(gui-slave-machine-list)
			set global_dse_options(flow-slaves) $global_dse_options(gui-slave-machine-list)
		}
    }

	#
    # START SPR:287960- Make sure all the partitions have their appropriate
    # source if DSE is being used in any sort of parallel or distributed
    # capacity.
    if { $global_dse_options(gui-concurrent-compiles) > 1 || $global_dse_options(gui-distribute-compiles) } {
		project_open -force -revision $revision $project_name
        ::quartus::dse::ccl::dputs "${debug_name}: User is performing some form of parallel or distributed compilation -- checking partitions in design..."
        array set missing_partitions [list]
        foreach {partition} [get_partition] {
            set netlist_type [get_partition -partition $partition -netlist_type]
            # Skip missing Source File netlists -- that's okay
            if {[regexp -nocase -- {source file} $netlist_type]} {
                continue
            }
            set value [partition_netlist_exists -partition $partition -netlist_type $netlist_type]
            if {$value} {
                ::quartus::dse::ccl::dputs "${debug_name}:    $partition, $netlist_type - EXISTS"
            } else {
                ::quartus::dse::ccl::dputs "${debug_name}:    $partition, $netlist_type - MISSING"
                lappend missing_partitions([string tolower $netlist_type]) $partition
            }
        }
		project_close
        # We found partitions that were missing their netlists. This is not
        # allowed. Error here with some information for the user.
        if { [llength [array names missing_partitions]] > 0 } {
            set msg ""
            foreach {netlist_type} [array names missing_partitions] {
                append msg "The following $netlist_type partitions are missing netlists:\n\n"
                foreach {partition} $missing_partitions($netlist_type) {
                    append msg "    $partition\n"
                }
                append msg "\n"
                append msg "Before you can compile this design in DSE you must ensure all\n"
                append msg "$netlist_type partition netlists exist.\n"
                append msg "\n"
            }
            append msg "Please perform a full compilation of the design with the Quartus II\n"
            append msg "software before attempting to use DSE with the design"
            if { $global_dse_options(gui-concurrent-compiles) > 1 } {
                append msg " or reduce the\nconcurrent compilation setting from $global_dse_options(gui-concurrent-compiles) to 1.\n"
            } elseif { $global_dse_options(gui-distribute-compiles) && [string match -nocase $global_dse_options(gui-distribute-using) "lsf"] } {
                append msg " or do not\ndistribute the DSE search to LSF.\n"
            } elseif { $global_dse_options(gui-distribute-compiles) } {
                append msg " or do not\ndistribute the DSE search to Quartus II slaves.\n"
            } else {
                append msg ".\n"
            }
            append msg "\n"
            append msg "For more information, refer to Troubleshooting Design Space Explorer in\n"
            append msg "the Quartus II Help."
            ::quartus::dse::ccl::eputs $msg
			MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message $msg -parent $widgets(mainframe)
            return 0
        }
    }
    # END SPR:287960
    #

    # Append the decision function
    ::quartus::dse::ccl::dputs "${debug_name}: Using decision function: $selected_decision_function"
    lappend flops "-best-worst-function"
    lappend flops $selected_decision_function
	set global_dse_options(flow-best-worst-function) $selected_decision_function
    # And the column to use for slack
    ::quartus::dse::ccl::dputs "${debug_name}: Using slack column: $global_dse_options(gui-slack-column)"
    lappend flops "-slack-column"
    lappend flops [list $global_dse_options(gui-slack-column)]
	set global_dse_options(flow-slack-column) [list $global_dse_options(gui-slack-column)]

    # Maybe stop the flow if zero failing paths are achieved
    if {$global_dse_options(gui-stop-after-zero-failing-paths)} {
        lappend flops "-stop-after-zero-failing-paths"
		set global_dse_options(flow-stop-after-zero-failing-paths) 1
    }

    # And what about lowering the priority of the threads
    if {$global_dse_options(gui-lower-priority)} {
        lappend flops "-lower-priority"
		set global_dse_options(flow-lower-priority) 1
    }

    # Maybe try and skip a few steps here and there
    if {$global_dse_options(gui-skip-base)} {
        lappend flops "-skip-base"
		set global_dse_options(flow-skip-base) 1
    }

    # Should we be performing a combined timing analysis?
    if {$global_dse_options(gui-do-combined-analysis)} {
        lappend flops "-do-combined-analysis"
		set global_dse_options(flow-do-combined-analysis) 1
    }

    # Is TimeQuest in use?
    if {$global_dse_options(gui-sta-mode)} {
        lappend flops "-timequest"
		set global_dse_options(flow-timequest) 1
    }

	# Are we reporting all resource usage information?
	if {$global_dse_options(gui-report-all-resource-usage)} {
        set global_dse_options(flow-report-all-resource-usage) 1
    }

    #
    # CLEAN UP BEFORE WE EVEN START
    #
    # Delete an existing dse directory
    if {[file exists dse] && [file isdirectory dse]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Deleting existing result directory"
        if {[catch {file delete -force -- dse} err]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Unabled to delete [file join [pwd] dse] ($err) - trying to delete individual files"
            # We couldn't delete the directory, try deleting the files
            foreach f [glob -nocomplain -directory [file join [pwd] dse] -- {*.{xml,qar,qarlog,csv}}]  {
                if {[catch {file delete -force -- $f} err]} {
                    set msg "Unable to delete $f\nPlease remove the directory [file join [pwd] dse] and try starting your search again."
                    ::quartus::dse::ccl::eputs $msg
                    MessageDlg $widgets(mainframe).errmsg -type ok -icon error -message $msg -parent $widgets(mainframe)
                    return 0
                }
            }

        }
        ::quartus::dse::ccl::dputs "${debug_name}: Cleaned up successfully!"
    }

    # Init some variables
    set best_results(point) "unknown"
    set best_results(timing-model) "unknown"
    set best_results(qof) "unknown"
    set best_results(slack) "unknown"
    set best_results(period) "unknown"
    set best_results(failingpaths) "unknown"
    set best_results(logiccells) "unknown"
    set best_results(power) "unknown"
    set base_results(qof) "unknown"
    set base_results(slack) "unknown"
    set base_results(timing-model) "unknown"
    set base_results(period) "unknown"
    set base_results(failingpaths) "unknown"
    set base_results(logiccells) "unknown"
    set base_results(power) "unknown"

    # Make the main window look disabled
    update_gui -compilation-started

    # Are there any pre-compile warning messages to report?
    foreach {m} $pre_compile_warning_messages {
        ::quartus::dse::ccl::wputs $m
    }

    # Note the time that exploration started and call our timer
    # function to being updating the timer at regular intervals
    variable exploration_start_time [clock clicks -milliseconds]
    variable exploration_timer [after 1000 ::quartus::dse::gui::update_elapsed_timer]

    # Explore it
    ::quartus::dse::ccl::dputs "${debug_name}: Calling: $flow_function"
	if {$global_dse_options(dse-debug)} {
		eval $flow_function
	} else {
		if {[catch {eval $flow_function} flow_result]} {
			# Clean up the flow_result
			regsub -nocase -all -- {error:\s*} $flow_result {} flow_err_msg
			regsub -nocase -all -- {\n\s*$} $flow_err_msg {} flow_err_msg
			::quartus::dse::ccl::eputs "Flow exited with an error:\n$flow_err_msg"
		}
		::quartus::dse::ccl::dputs "${debug_name}: Flow result: $flow_result"
	}

    # Cancel the exploration timer and note the elapsed time
    after cancel $exploration_timer
    set ttext [::quartus::dse::ccl::elapsed_time_string [expr {[clock clicks -milliseconds] - $exploration_start_time}]]

    # Change the text of the dialog box
    catch {focus -force .}

    # Display a pop-up to let user know exploration is done
    set wcnt [::quartus::dse::ccl::get_msg_count -warnings]
    set ecnt [::quartus::dse::ccl::get_msg_count -errors]
    set guimsg "Exploration has finished\n($ecnt "
    set msg "Exploration has finished. $ecnt "
    if {$ecnt == 1} {
        append guimsg "error, $wcnt"
        append msg "error, $wcnt"
    } else {
        append guimsg "errors, $wcnt"
        append msg "errors, $wcnt"

    }
    if {$wcnt == 1} {
        append guimsg " warning)           "
        append msg " warning"
    } else {
        append guimsg " warnings)          "
        append msg " warnings"
    }
    ::quartus::dse::ccl::iputs $msg
    ::quartus::dse::ccl::iputs "Exploration ended: [clock format [clock scan now]]"
    ::quartus::dse::ccl::iputs "Elapsed time: $ttext"
    set progress_text "Done"
    # We should also make sure the progress indicator says
    # 100% finished.
    update_progress -update-pbar -update-pbar-amount "max"
    catch {tk_messageBox \
        -message $guimsg \
        -type ok \
        -icon info \
        -title "Altera Design Space Explorer" \
        -parent .}
    catch {unset msg}

    # Make the main window look enabled
    update_gui -compilation-ended

    catch {unset designspace}
    catch {unset results}

    return 1
}


#############################################################################
##  Procedure:  update_progress
##
##  Arguments:
##      -update-pbar
##          Tells the function to update the progress bar variable
##          that controls how much of the progress has elapsed.
##
##      -update-pbar-amount <int>
##          Amount to add to the progress bar variable if the user
##          also said -update-pbar. The default is 1.
##
##      -update-pbar-maximum <int>
##          Changes the maximum integer amount of the progress
##          bar. Not sure what happens if you call this mid-exploration
##          but you should definitly set this when you know how
##          man -update-pbar calls your flow will be making.
##
##      -update-progress-status
##          Updates the text that's shown to the user in the
##          bottom left corner of the exploration window.
##
##  Description:
##      Used to update the flow progress information being
##      displayed to the user during the execution of a flow.
proc ::quartus::dse::gui::update_progress {args} {

    set debug_name "::quartus::dse::gui::update_progress()"

    # Import global namespace variables
    global widgets
    global global_dse_options
    variable progress_variable
    variable progress_max
    variable progress_text

    if {$global_dse_options(dse-gui) != 1} {
        return 1
    }

    # Command line options to this function we require
    lappend function_opts [list "update-pbar" 0 ""]
    lappend function_opts [list "update-pbar-amount.arg" "1" ""]
    lappend function_opts [list "update-pbar-maximum.arg" "#_optional_#" ""]
    lappend function_opts [list "update-progress-status.arg" "#_optional_#" ""]

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "Missing required option: -$opt"
        }
    }

    # Do the right thing based on the user's options

    if {$optshash(update-pbar)} {
        # Increment the progress bar variable by some amount
        if {$optshash(update-pbar-amount) == "max"} {
            set progress_variable [$widgets(mainframe) cget -progressmax]
        } else {
            incr progress_variable $optshash(update-pbar-amount)
        }
        update_elapsed_timer -one-time
    }

    if {$optshash(update-pbar-maximum) != "#_optional_#"} {
        # Update the max value of the progress bar
        set progress_max $optshash(update-pbar-maximum)
        catch {$widgets(mainframe) configure -progressmax $optshash(update-pbar-maximum)}
    }

    if {$optshash(update-progress-status) != "#_optional_#" } {
        # Update the point status text
        set progress_text $optshash(update-progress-status)
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
proc ::quartus::dse::gui::print_msg {args} {

    set debug_name "::quartus::dse::gui::print_msg()"

    # Import global namespace variables
    global widgets
    global global_dse_options

    if {!$global_dse_options(dse-gui)} {
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
        set tagname "infotag"
    } elseif {$optshash(debug)} {
        set tagname "debugtag"
    } elseif {$optshash(error)} {
        set tagname "errortag"
    } elseif {$optshash(warning)} {
        set tagname "warningtag"
    }

    catch {$widgets(txtMessagesExploration) configure -state normal}
    catch {$widgets(txtMessagesExploration) insert end [lindex $args 0] $tagname}
    catch {$widgets(txtMessagesExploration) insert end "\n"}
    catch {$widgets(txtMessagesExploration) see end}
    catch {$widgets(txtMessagesExploration) configure -state disabled}

    return 1
}


#############################################################################
##  Procedure:  update_base_result
##
##  Arguments:
##
##
##  Description:
##      <description>
proc ::quartus::dse::gui::update_base_result {result} {

    set debug_name "::quartus::dse::gui::update_base_result()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable base_results
    variable selected_optimization_goal

    if {!$global_dse_options(dse-gui)} {
        return 1
    }

    if {![$result isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: $result is not a result object!"
        return 0
    }

    set slack_clock "unknown"
    set units ""
    if {$global_dse_options(gui-slack-column) == "#_default_#"} {
        set slack_column "Worst-case Slack"
    } else {
        set slack_column $global_dse_options(gui-slack-column)
    }
    set slack 1000000000
    foreach {key val} [$result getResults -glob $slack_column] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => newslack units]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for base results worst-case slack"
            if {$newslack < $slack} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new base results worst-case slack"
                set slack $newslack
                if {![regexp -- {\((.*)\)} $val => slack_clock]} {
                    set slack_clock $key
                }
            }
        }
    }
    if {$slack == 1000000000} {
        set slack "unknown"
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found worst-case slack: $slack $units ($slack_clock)"

    set period -1
    set period_clock "unknown"
    # Show the Geometric Mean period if the optimization goal
    # is "Optimize for Average Period. Otherwise show the slowest
    # clock period and filter out the geometric mean period.
    switch -- $selected_optimization_goal {
        {Optimize for Average Period} {
            foreach {key val} [$result getResults -glob "Clock Period: Geometric Mean"] {
                if {![string equal -nocase $val "unknown"]} {
                    if {$val > $period} {
                        set period $val
                        regexp -- {Clock Period:\s*(.*)} $key => period_clock
                    }
                }
            }
        }
        default {
            foreach {key val} [$result getResults -glob "Clock Setup:*: Actual Time"] {
                if {![string equal -nocase $key "Clock Period: Geometric Mean"] && ![string equal -nocase $val "unknown"]} {
                    if {$val > $period} {
                        set period $val
                        regexp -- {Clock Setup:\s+'(.*)':\s+Actual Time} $key => period_clock
                    }
                }
            }
        }
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found highest period: $period ($period_clock)"

    #
    # STA_MODE START
    # NB: When sta-mode is on there is no clock period to report
    #     so we'll show the user End Point TNS instead.
#    if { $global_dse_options(gui-sta-mode) } {
#		unset -nocomplain -- key val
#		set period "unknown"
#		set period_clock "unknown"
#        foreach {key val} [$result getResults "${slack_clock}: End Point TNS"] {
#			::quartus::dse::ccl::dputs "${debug_name}: STA MODE:     $key = $val"
#            set period $val
#            set period_clock $slack_clock
#        }
#        ::quartus::dse::ccl::dputs "${debug_name}: STA MODE: Found End Point TNS $period for $period_clock"
#    }
    # STA_MODE END
    #

    set fpaths "unknown"
    foreach {key val} [$result getResults -exact "All Failing Paths"] {
        set fpaths $val
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found failing paths: $fpaths"

    set lcells "unknown"
    foreach {key val} [$result getResults -regexp "^(Total logic elements|Logic utilization|Total HCells)$"] {
        set lcells $val
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found logic cell count: $lcells"

    # Make friendly display strings out of the information we recieved
    if {$slack != "unknown"} {
        set slack "$slack $units ($slack_clock)"
    }

    if {$period != -1} {
        set period "$period ($period_clock)"
    } else {
        set period "unknown"
    }

    set qof [lindex [$result getResults -exact "Quality of Fit"] 1]

    set power [lindex [$result getResults -exact "Total Thermal Power Dissipation"] 1]

    set timing_model [lindex [$result getResults -exact "Timing Model"] 1]

    # Update what the user sees
    set base_results(qof) $qof
    set base_results(slack) $slack
    set base_results(period) $period
    set base_results(failingpaths) $fpaths
    set base_results(logiccells) $lcells
    set base_results(power) $power
    set base_results(timing-model) $timing_model

    return 1
}


#############################################################################
##  Procedure:  update_best_result
##
##  Arguments:
##
##
##  Description:
##      <description>
proc ::quartus::dse::gui::update_best_result {point result} {

    set debug_name "::quartus::dse::gui::update_best_result()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable best_results
    variable selected_optimization_goal

    if {!$global_dse_options(dse-gui)} {
        return 1
    }

    if {![$result isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: $result is not a result object!"
        return 0
    }

    set slack_clock "unknown"
    set units ""
    if {$global_dse_options(gui-slack-column) == "#_default_#"} {
        set slack_column "Worst-case Slack"
    } else {
        set slack_column $global_dse_options(gui-slack-column)
    }
    set slack 1000000000
    foreach {key val} [$result getResults -glob $slack_column] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => newslack units]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for best results worst-case slack"
            if {$newslack < $slack} {
                set slack $newslack
                if {![regexp -- {\((.*)\)} $val => slack_clock]} {
                    ::quartus::dse::ccl::dputs "${debug_name}: Found new best results worst-case slack"
                    set slack_clock $key
                }
            }
        }
    }
    if {$slack == 1000000000} {
        set slack "unknown"
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found worst-case slack: $slack $units ($slack_clock)"

    set period -1
    set period_clock "unknown"
    # Show the Geometric Mean period if the optimization goal
    # is "Optimize for Average Period. Otherwise show the slowest
    # clock period and filter out the geometric mean period.
    switch -- $selected_optimization_goal {
        {Optimize for Average Period} {
            ::quartus::dse::ccl::dputs "${debug_name}: User is optimizing for average period -- searching only geomean periods"
            foreach {key val} [$result getResults -glob "Clock Period: Geometric Mean"] {
                if {![string equal -nocase $val "unknown"]} {
                    if {$val > $period} {
                        set period $val
                        regexp -- {Clock Period:\s*(.*)} $key => period_clock
                    }
                }
            }
        }
        default {
            ::quartus::dse::ccl::dputs "${debug_name}: User is NOT optimizing for average period -- searching all except geomean periods"
            foreach {key val} [$result getResults -glob "Clock Setup:*: Actual Time"] {
                if {![string equal -nocase $key "Clock Period: Geometric Mean"] && ![string equal -nocase $val "unknown"]} {
                    if {$val > $period} {
                        set period $val
                        regexp -- {Clock Setup:\s+'(.*)':\s+Actual Time} $key => period_clock
                    }
                }
            }
        }
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found highest period: $period ($period_clock)"

    #
    # STA_MODE START
    # NB: When sta-mode is on there is no clock period to report
    #     so we'll show the user End Point TNS instead.
#    if { $global_dse_options(gui-sta-mode) } {
#		unset -nocomplain -- key val
#		set period "unknown"
#		set period_clock "unknown"
#        foreach {key val} [$result getResults "${slack_clock}: End Point TNS"] {
#            set period $val
#            set period_clock $slack_clock
#        }
#        ::quartus::dse::ccl::dputs "${debug_name}: STA MODE: Found End Point TNS $period for $period_clock"
#    }
    # STA_MODE END
    #

    set fpaths "unknown"
    foreach {key val} [$result getResults -exact "All Failing Paths"] {
        set fpaths $val
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found failing paths: $fpaths"

    set lcells "unknown"
    foreach {key val} [$result getResults -regexp "^(Total logic elements|Logic utilization|Total HCells)$"] {
        set lcells $val
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found logic cell count: $lcells"

    # Make friendly display strings out of the information we recieved
    if {$slack != "unknown"} {
        set slack "$slack $units ($slack_clock)"
    }

    if {$period != -1} {
        set period "$period ($period_clock)"
    } else {
        set period "unknown"
    }

    set qof [lindex [$result getResults -exact "Quality of Fit"] 1]

    set power [lindex [$result getResults -exact "Total Thermal Power Dissipation"] 1]

    set timing_model [lindex [$result getResults -exact "Timing Model"] 1]
    ::quartus::dse::ccl::dputs "${debug_name}: Got timing model: $timing_model"
    # Munge the point a bit based on the timing model
    ::quartus::dse::ccl::dputs "${debug_name}: Point before munging: $point"
    if {[string equal -nocase $timing_model "slow"]} {
        [regsub -nocase -- {-slow} $point {} point]
    } else {
        [regsub -nocase -- {-fast} $point {} point]
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Point after munging: $point"



    # Update what the user sees
    set best_results(point) $point
    set best_results(qof) $qof
    set best_results(slack) $slack
    set best_results(period) $period
    set best_results(failingpaths) $fpaths
    set best_results(logiccells) $lcells
    set best_results(power) $power
    set best_results(timing-model) $timing_model

    return 1
}


#############################################################################
##  Procedure:  on_configure_resources
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Use a nice little window to to enter the available slave
##      machines for the distributed flow.
proc ::quartus::dse::gui::on_configure_resources {args} {

    set debug_name "::quartus::dse::gui::on_configure_resources()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable app_window_icon

	# Destroy an existing copy of this widget
	catch {destroy $widgets(dlgEnterSlaves)}
	catch {array unset widgets *EnterSlaves}
	catch {array unset widgets *LSF}
	catch {array unset widgets *ABC}

    lappend function_opts [list "parent.arg" $widgets(mainframe) "Parent window for dialog"]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

	# Set to "on" if we're in internal use mode
	set dse_internal_use [get_ini_var -name "dse_internal_use"]

    # All systems go: create a dialog to show the user the results
    addWidget dlgEnterSlaves [Dialog $optshash(parent).enterslavesdlg -modal local -side bottom -transient 1 -parent $optshash(parent) -place center -separator 1 -title "Configure Resources" -default 0 -cancel 0]
    wm iconbitmap $optshash(parent).enterslavesdlg $app_window_icon
    $widgets(dlgEnterSlaves) add -text "OK" -helptext "Accept changes" -helptype balloon -command {
        global widgets
        set end_dialog 1

        # We only have to check the LSF queue list if the user is trying to use LSF resources
		if { [string match -nocase $global_dse_options(gui-distribute-using) "lsf"] } {

            # Value must be a non-empty string
            if {[regexp -nocase -- {^\s*$} $global_dse_options(gui-lsf-queue)]} {
                set end_dialog 0
                set msg "LSF queue not specified.\nYou must select an LSF queue name from the list or enter your own.\nIf you wish to keep the current settings press the Cancel button.\nTo use the default LSF queue select <default> from the list."
            }

            if {$end_dialog} {

				#
				# Save any new LSF queue names to the persistent list
				#
                ::quartus::dse::ccl::dputs "${debug_name}: User has changed the lsf-queue to \"$global_dse_options(gui-lsf-queue)\""
                # First, check and see if the new LSF queue value they want to use
                # is already in the list of LSF queue values. If it is set the
                # index to this value so we show this selection the next time the dialog
                # is loaded by the user.
                ::quartus::dse::ccl::dputs "${debug_name}: Checking lsf-queue-list to see if change is there already"
                set is_in_list 0
                for {set i 0} {$i < [llength $global_dse_options(gui-lsf-queue-list)]} {incr i} {
                    ::quartus::dse::ccl::dputs "${debug_name}:      Checking against: @$i = [lindex $global_dse_options(gui-lsf-queue-list) $i]"
                    if {[string equal [lindex $global_dse_options(gui-lsf-queue-list) $i] $global_dse_options(gui-lsf-queue)]} {
                        ::quartus::dse::ccl::dputs "${debug_name}:      Found match in lsf-queue-list at index @$i!"
                        set is_in_list 1
                        set global_dse_options(gui-lsf-queue-index) "@$i"
                        # No need to check any further, we've memorized the index in
                        # the list for the next time the dialog is opened.
                        break
                    }

                }
                # If we didn't find this value in the list already we need to
                # add it to the list and set the index to the end.
                if {!$is_in_list} {
                    ::quartus::dse::ccl::dputs "${debug_name}: Couldn't find \"$global_dse_options(gui-lsf-queue)\" in lsf-queue-list"
                    ::quartus::dse::ccl::dputs "${debug_name}: Appending \"$global_dse_options(gui-lsf-queue)\" to the end of lsf-queue-list"
                    lappend global_dse_options(gui-lsf-queue-list) $global_dse_options(gui-lsf-queue)
                    set global_dse_options(gui-lsf-queue-index) "last"
                }
            }

        } elseif { [string match -nocase $global_dse_options(gui-distribute-using) "abc"] } {

            # Value must be a non-empty string
            if {[regexp -nocase -- {^\s*$} $global_dse_options(gui-abc-group)]} {
                set end_dialog 0
                set msg "ABC group not specified.\nYou must select an ABC group name from the list or enter your own."
            }

            if {$end_dialog} {
				#
				# Save any new ABC group names to the persistent list
				#
				::quartus::dse::ccl::dputs "${debug_name}: User has changed the abc-group to \"$global_dse_options(gui-abc-group)\""
				::quartus::dse::ccl::dputs "${debug_name}: Checking abc-group-list to see if change is there already"
				set is_in_list 0
				for {set i 0} {$i < [llength $global_dse_options(gui-abc-group-list)]} {incr i} {
					::quartus::dse::ccl::dputs "${debug_name}:      Checking against: @$i = [lindex $global_dse_options(gui-abc-group-list) $i]"
					if {[string equal [lindex $global_dse_options(gui-abc-group-list) $i] $global_dse_options(gui-abc-group)]} {
						::quartus::dse::ccl::dputs "${debug_name}:      Found match in abc-group-list at index @$i!"
						set is_in_list 1
						set global_dse_options(gui-abc-group-index) "@$i"
						# No need to check any further, we've memorized the index in
						# the list for the next time the dialog is opened.
						break
					}

				}
				# If we didn't find this value in the list already we need to
				# add it to the list and set the index to the end.
				if {!$is_in_list} {
					::quartus::dse::ccl::dputs "${debug_name}: Couldn't find \"$global_dse_options(gui-abc-group)\" in abc-group-list"
					::quartus::dse::ccl::dputs "${debug_name}: Appending \"$global_dse_options(gui-abc-group)\" to the end of abc-group-list"
					lappend global_dse_options(gui-abc-group-list) $global_dse_options(gui-abc-group)
					set global_dse_options(gui-abc-group-index) "last"
				}
			}
		}

        if {$end_dialog} {
            $widgets(dlgEnterSlaves) enddialog 1
        } else {
            MessageDlg $widgets(dlgEnterSlaves).errmsg -type ok -icon error -message $msg -parent $widgets(dlgEnterSlaves)
        }
    }

    $widgets(dlgEnterSlaves) add -text "Cancel" -helptext "Discard changes" -helptype balloon -command {
        global widgets
        $widgets(dlgEnterSlaves) enddialog -1
    }

    #
    # GET THE MAIN FRAME FOR THIS DIALOG BOX
    #
    set dlgFrame [$widgets(dlgEnterSlaves) getframe]

        #
        # CREATE A NOTEBOOK TO HOLD THE DIFFERENT PANES
        #
        set notebook [NoteBook $dlgFrame.nb -font Tabs]

			#
			# CREATE THE NOTEBOOK PAGE TO HOLD QSLAVE SETTINGS
			#
			set qslavetab [$notebook insert end qslave -text "  QSlave  " -raisecmd {set global_dse_options(gui-distribute-using) "qslave"; ::quartus::dse::gui::on_select_distributed_dse_method}]

				#
				# CREATE A SUB FRAME TO HOLD A scrolledwindow + buttonbox FOR QUARTUS QSLAVE LIST
				#
				set temp_frame [frame $qslavetab.tf2 -pady 2]
				pack $temp_frame -fill both -expand yes
				addWidget messageUseEnterSlaves [message $temp_frame.msguseqlsave -text {Use Quartus II QSlave resources to run DSE jobs on remote machines. Do not add the host name you are running DSE on to this list. For more information on creating a QSlave system please see the Quartus II help.} -width 400 -anchor w]
				pack $widgets(messageUseEnterSlaves) -expand no -fill none -anchor nw
				set separator [Separator $temp_frame.qslavesep]
				pack $separator -expand yes -fill x -pady 10 -anchor nw

				addWidget swEnterSlaves [ScrolledWindow $temp_frame.sw -relief groove -auto both]
				addWidget lbEnterSlaves [listbox $widgets(swEnterSlaves).lb -height 8 -width 50 -highlightthickness 0 -selectmode extended]
				$widgets(swEnterSlaves) setwidget $widgets(lbEnterSlaves)
				pack $widgets(swEnterSlaves) -fill both -expand yes -anchor nw

				# Update the list of slaves shown
				foreach c $global_dse_options(gui-slave-machine-list) {
					$widgets(lbEnterSlaves) insert end $c
				}

				set bbox [ButtonBox $temp_frame.bbox -spacing 5 -padx 2 -pady 2]
				addWidget butAddEnterSlaves [$bbox add -text "Add" -highlightthickness 0 -takefocus 0  -borderwidth 1 -padx 2 -pady 2 -command {::quartus::dse::gui::on_add_slave_machine} -helptext "Add a new client" -helptype balloon -underline 0]
				addWidget butDeleteEnterSlaves [$bbox add -text "Delete" -highlightthickness 0 -takefocus 0  -borderwidth 1 -padx 2 -pady 2 -command {::quartus::dse::gui::on_delete_slave_machines} -helptext "Delete selected clients" -helptype balloon -underline 0]
				pack $bbox -side top -anchor e

			#
			# CREATE THE NOTEBOOK PAGE TO HOLD LSF SETTINGS
			#
			set lsftab [$notebook insert end lsf -text "  LSF  " -raisecmd {set global_dse_options(gui-distribute-using) "lsf"; ::quartus::dse::gui::on_select_distributed_dse_method}]

				#
				# CREATE A SUB FRAME TO HOLD A radiobutton + Label + ComboBox FOR LSF QUEUE NAMES
				#
				set temp_frame [frame $lsftab.tf1 -pady 2]
				pack $temp_frame -fill x -expand no -anchor nw
				addWidget messageUseLSF [message $temp_frame.msguselsf -text {Use LSF resources to run DSE jobs on remote machines.} -width 400 -anchor w]
				pack $widgets(messageUseLSF) -expand no -fill none -anchor nw
				set separator [Separator $temp_frame.lsfsep]
				pack $separator -expand yes -fill x -pady 10 -anchor nw


					#
					# CREATE A SUB FRAME TO HOLD A Label + ComboBox FOR LSF QUEUE NAME
					#
					set sub_frame [frame $temp_frame.subframe1]
					pack $sub_frame -fill both -expand yes -anchor nw -pady 2
					addWidget labelLSF [Label $sub_frame.lbllsfq -text "LSF Queue:" -relief flat -padx 10 -width 10 -anchor w]
					pack $widgets(labelLSF) -side left -anchor nw
					addWidget cboxLSF [ComboBox $sub_frame.lsfqueue -values $global_dse_options(gui-lsf-queue-list) -editable 1 -width 25 -textvariable {global_dse_options(gui-lsf-queue)}]
					$widgets(cboxLSF) setvalue $global_dse_options(gui-lsf-queue-index)
					pack $widgets(cboxLSF) -expand yes -fill x -anchor nw

			if { [string match -nocase $dse_internal_use "on"] } {
				#
				# CREATE THE NOTEBOOK PAGE TO HOLD ABC SETTINGS
				#
				set abctab [$notebook insert end abc -text "  ABC  " -raisecmd {set global_dse_options(gui-distribute-using) "abc"; ::quartus::dse::gui::on_select_distributed_dse_method}]

					#
					# CREATE A SUB FRAME TO HOLD WIDGETS FOR QUARTUS ABC CONFIGURATION
					#
					set temp_frame [frame $abctab.tf2 -pady 2]
					pack $temp_frame -fill x -expand no
					addWidget messageUseABC [message $temp_frame.msguseabc -text {Use The Altera Batch Computing (ABC) System to run DSE jobs on remote machines. For more information on using a local ABC system please see your local administrator.} -width 400 -anchor w]
					pack $widgets(messageUseABC) -expand no -fill none -anchor nw
					set separator [Separator $temp_frame.abcsep]
					pack $separator -expand yes -fill x -pady 10 -anchor nw


						#
						# CREATE A SUB FRAME TO HOLD A Label + ComboBox FOR SYSTEM
						#
						set sub_frame [frame $temp_frame.subframe1]
						pack $sub_frame -fill both -expand yes -anchor nw -pady 2
						addWidget labelSystemABC [Label $sub_frame.lblsystemabc -text "System:" -relief flat -padx 10 -width 10 -anchor w]
						pack $widgets(labelSystemABC) -side left -anchor nw
						addWidget cboxSystemABC [ComboBox $sub_frame.abcsystem -values $global_dse_options(gui-abc-system-list) -editable 0 -width 25 -textvariable {global_dse_options(gui-abc-system)}]
						$widgets(cboxSystemABC) setvalue $global_dse_options(gui-abc-system-index)
						pack $widgets(cboxSystemABC) -expand yes -fill x -anchor nw


						#
						# CREATE A SUB FRAME TO HOLD A Label + ComboBox FOR GROUP
						#
						set sub_frame [frame $temp_frame.subframe2]
						pack $sub_frame -fill both -expand yes -anchor nw -pady 2
                        addWidget labelGroupABC [Label $sub_frame.lblgroupabc -text "Group:" -relief flat -padx 10 -width 10 -anchor w]
						pack $widgets(labelGroupABC) -side left -anchor nw
						addWidget cboxGroupABC [ComboBox $sub_frame.abcgroup -values $global_dse_options(gui-abc-group-list) -editable 1 -width 25 -textvariable {global_dse_options(gui-abc-group)}]
						$widgets(cboxGroupABC) setvalue $global_dse_options(gui-abc-group-index)
						pack $widgets(cboxGroupABC) -expand yes -fill x -anchor nw

						#
						# CREATE A SUB FRAME TO HOLD A Label + SpinBox FOR PRIORITY
						#
						set sub_frame [frame $temp_frame.subframe3]
						pack $sub_frame -fill both -expand yes -anchor nw -pady 2
						addWidget labelPriorityABC [Label $sub_frame.lblprioabc -text "Priority:" -relief flat -padx 10 -width 10 -anchor w]
						pack $widgets(labelPriorityABC) -side left -anchor nw
						addWidget spinboxPriorityABC [SpinBox $sub_frame.abcprio -values {50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1} -editable 0 -textvariable {global_dse_options(gui-abc-priority)} -width 10]
                        $widgets(spinboxPriorityABC) setvalue @10
						pack $widgets(spinboxPriorityABC) -expand no -fill none -anchor nw -side left
						addWidget labelPriorityTipABC [Label $sub_frame.lblpriohelpabc -text "(50 = lowest, 1 = highest)" -relief flat -padx 5 -anchor w]
						pack $widgets(labelPriorityTipABC) -expand yes -fill x -anchor nw

						#
						# CREATE A SUB FRAME TO HOLD A CheckBox FOR DESKTOPS
						#
						set sub_frame [frame $temp_frame.subframe4]
						pack $sub_frame -fill both -expand yes -anchor nw -pady 2
						addWidget checkboxUseDesktopsABC [checkbutton $sub_frame.checkdesktops -text "Use Desktop Computers" -variable {global_dse_options(gui-abc-use-desktops)} -anchor w -padx 10]
						pack $widgets(checkboxUseDesktopsABC) -expand no -fill none -anchor nw
			}

		#
		# PACK THE NOTEBOOK THAT HOLDS EVERYTHING
		#
		$notebook compute_size
		pack $notebook -fill both -expand yes

	#
	# PACK THE TOPLEVEL WINDOW FOR ALL THE CONFIGURATION
	#
	pack $dlgFrame -padx 7 -pady 7

	# Pick the notebook tab the user is currently using
	if { [string match -nocase $dse_internal_use "on"] && [string match -nocase $global_dse_options(gui-distribute-using) "abc"] } {
		$notebook raise abc
	} elseif { [string match -nocase $global_dse_options(gui-distribute-using) "lsf"] } {
		$notebook raise lsf
	} else {
		$notebook raise qslave
	}

    # The user should be able to get window-specific help by hitting the F1 key.
    bind $widgets(dlgEnterSlaves) <F1> {::quartus::dse::gui::on_help -page /dse/dse_db_configure_clients.htm}

    # Show the dialog
    set result [$widgets(dlgEnterSlaves) draw]

    # If the user didn't cancel update the list of clients
    if {$result != -1} {
        set global_dse_options(gui-slave-machine-list) ""
        set num_entries [$widgets(lbEnterSlaves) size]
        for { set i 0 } { $i < $num_entries } { incr i } {
            lappend global_dse_options(gui-slave-machine-list) [$widgets(lbEnterSlaves) get $i]
        }
    }

    # Destory widgets
    catch {destroy $widgets(dlgEnterSlaves)}
    catch {array unset widgets *EnterSlaves}
    catch {array unset widgets *LSF}
	catch {array unset widgets *ABC}

    return 1
}


#############################################################################
##  Procedure:  on_create_or_merge_revision
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##		Tabbed dialog box that lets the user create a new revision
##		by merging DSE settings with an existing revision, or just
##		merge DSE settings into an existing revision.
proc ::quartus::dse::gui::on_create_or_merge_revision {args} {

    set debug_name "::quartus::dse::gui::on_create_or_merge_revision()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable app_window_icon

	# Destroy an existing copy of this widget
	catch {destroy $widgets(dlgCNR)}
	catch {array unset widgets *CNR}

    lappend function_opts [list "parent.arg" $widgets(mainframe) "Parent window for dialog"]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

	# Set to "on" if we're in internal use mode
	set dse_internal_use [get_ini_var -name "dse_internal_use"]


	# Get the project name, the list of revisions and the
	# current revision being used. We can trust this because
	# this command should only be called if a project is
	# loaded in the DSE GUI. The on_open_project callback ensures
	# these values are filled in for us.
	set project_name [$widgets(labentProjectName) cget -text]
	set project_revision_list [$widgets(cboxRevisionName) cget -values]
	set project_revision_index [$widgets(cboxRevisionName) getvalue]

	# Get the available DSE results to use as new points. If
	# there are no results available display and error message.
	if {![file isdirectory [file join dse]]} {
		# Error: no DSE result directory found
		set msg "No DSE results could be found for this project!"
		::quartus::dse::ccl::eputs "$msg"
		catch { tk_messageBox -type ok -message $msg -icon error -title "Error No DSE Results Found"}
		return 0
	}
	# Filter out the -fast results
	set result_file_list [list]
	foreach {i} [lsort [glob -nocomplain -dir [file join dse] -- {*-result.xml}]] {
		::quartus::dse::ccl::dputs "${debug_name}: Found: $i"
		if {[regexp -nocase -- {(\\|/)(best|base|\d+)-result.xml} $i]} {
			::quartus::dse::ccl::dputs "${debug_name}: Added to list: $i"
			lappend result_file_list $i
		}
	}
	if {[llength $result_file_list] == 0} {
		# Error: no DSE result files found
		set msg "No DSE results could be found for this project!"
		::quartus::dse::ccl::eputs "$msg"
		catch { tk_messageBox -type ok -message $msg -icon error -title "Error No DSE Results Found"}
		return 0
	}
	# Make a list of points out of the revisions found. Put
	# the "best" revision at the top if it exists. Omit the
	# "base" revision and sort all other revisions by their
	# index number.
	set dse_revision_list [list]
	set found_best 0
	foreach resultfile $result_file_list {
		# Only add this to the list of available DSE points if
		# we can verify that we'll be able to open the file
		# later to read the settings from it.
		if {[file readable $resultfile]} {
			regsub -nocase -- {-result.xml} [lindex [file split $resultfile] end] {} point
			if {$point == "base" || $point == "base-fast" || $point == "base-slow"} {
				# Skip it...
			} elseif {$point == "best"} {
				set found_best 1
			} else {
				lappend dse_revision_list $point
			}
		}
	}
	if {$found_best} {
		set dse_revision_list [linsert [lsort -dictionary -increasing $dse_revision_list] 0 "best" ]
	} else {
		set dse_revision_list [lsort -dictionary -increasing $dse_revision_list]
	}

    # All systems go: create a dialog to show the user the results
    addWidget dlgCNR [Dialog $optshash(parent).cnrdlg -modal local -side bottom -transient 1 -parent $optshash(parent) -place center -separator 1 -title "Create & Merge Revisions" -default 0 -cancel 0]
    wm iconbitmap $optshash(parent).cnrdlg $app_window_icon
    $widgets(dlgCNR) add -text "OK" -helptype balloon -command {
        global widgets
        set end_dialog 1

		# What type of revision manipulation are we doing? A merge into an existing
		# revision or a creation of a completely new revision?
		if { [string match -nocase $global_dse_options(gui-revision-merge-mode) "merge"] } {

			# We're doing a new merge-into-existing-revision action

			# Gather up the information we need
			set project_name [$widgets(labentProjectName) cget -text]
			set base_revision_name [lindex [$widgets(cboxBasedOnMergeCNR) cget -values] [$widgets(cboxBasedOnMergeCNR) getvalue]]
			set point [lindex [$widgets(cboxDSEPointMergeCNR) cget -values] [$widgets(cboxDSEPointMergeCNR) getvalue]]

			if { $end_dialog} {
				# Load the results from the file
				set results [uplevel #0 ::quartus::dse::result #auto $project_name $base_revision_name]
				if {[catch {open [file join dse ${point}-result.xml]} xmlfh]} {
					set msg "Unable to open DSE results for point ${point}"
					set end_dialog 0
				}
			}

			if { $end_dialog } {
				# Load the results from the file into the results object
				$results loadXML $xmlfh
				close $xmlfh

				# Get the current revision name
				set original_revision_name [get_current_revision $project_name]
				upvar 0 [$widgets(checkCurrentNewCNR) cget -variable] set_current_to_new

				# Open the project up to the revision we're going to merge with
				if {[catch {project_open -force -revision $base_revision_name $project_name} msg]} {
					project_close
					regsub -all -- {(ERROR: |\n)} $msg {} msg
					::quartus::dse::ccl::eputs $msg
					regsub -all -- {\. } $msg ".\n" msg
					set end_dialog 0
				}
			}

			if { $end_dialog } {

				# Now merge in the DSE point settings
				foreach {param value} [$results getAllSettings] {
					if {[regexp -nocase {^-} $param]} {
						# Ignore settings that begin with a '-'
					} else {
						# It's a Quartus II ACF setting...
						# Try to apply as a global setting, if that doesn't work
						# make a leap-of-faith and assume the project_name is the
						# same as the top level entity.  The other thing to try is
						# to use wildcards but it seems not everything supports this.
						# Is that true?
						if {[catch {set_global_assignment -name $param $value} msg]} {
							# Not sure if this should be an error or not...
						}
					}
				}
				export_assignments

				# Do we make this new revision the current revision?
				if {!$set_current_to_new} {
					set_current_revision $original_revision_name
				}

				project_close

				# Now run special actions
				foreach {param value} [$results getAllSettings] {
					if {[regexp -nocase {^-} $param]} {
						# Do any setup actions
						switch -- $param {
							{-setup-script} {
								if {[regexp -- {([a-zA-Z_]+):(.*)} $value => e f]} {
									set input "\"[file join $::quartus(binpath) $e]\" -t \"$f\" $project_name $base_revision_name"
									set output "${e}.out"
									set result [::quartus::dse::ccl::dse_exec $input $output]
								}
							}
						}
					}
				}
			}

			if { $end_dialog } {
				set msg "Settings from point $point merged into revision $base_revision_name.\nPlease recompile this revision in Quartus II."
			}

		} else {
			# Assume we're doing a traditional create-new-revision style operation

			# Gather up the information we need
			set project_name [$widgets(labentProjectName) cget -text]
			set new_revision_name [$widgets(labentNewRevNameNewCNR) cget -text]
			set base_revision_name [lindex [$widgets(cboxBasedOnNewCNR) cget -values] [$widgets(cboxBasedOnNewCNR) getvalue]]
			set point [lindex [$widgets(cboxDSEPointNewCNR) cget -values] [$widgets(cboxDSEPointNewCNR) getvalue]]

			# Test the new revision name. Make sure it doesn't contain
			# any illegal characters. Stip start/end whitespace too.
			regsub -- {^\s+} $new_revision_name {} new_revision_name
			regsub -- {\s+$} $new_revision_name {} new_revision_name
			if {[regexp -nocase -- {[\s\\/:~!@#\$%\^&\*\(\)+={}\[\]\|<>,\.;`\']} $new_revision_name]} {
				set msg "Illegal characters found in revision name $new_revision_name"
				set end_dialog 0
			}
			if {[regexp -nocase -- {^\s*$} $new_revision_name]} {
				set msg "New revision name cannot be empty"
				set end_dialog 0
			}

			if { $end_dialog} {
				# Load the results from the file
				set results [uplevel #0 ::quartus::dse::result #auto $project_name $base_revision_name]
				if {[catch {open [file join dse ${point}-result.xml]} xmlfh]} {
					set msg "Unable to open DSE results for point ${point}"
					set end_dialog 0
				}
			}

			if { $end_dialog } {
				# Load the results from the file into the results object
				$results loadXML $xmlfh
				close $xmlfh

				# Get the current revision name
				set original_revision_name [get_current_revision $project_name]
				upvar 0 [$widgets(checkCurrentNewCNR) cget -variable] set_current_to_new

				# Create the new revision based on the old revision
				project_open -force -revision $base_revision_name $project_name
				if {[catch {create_revision -copy_results -based_on $base_revision_name -set_current $new_revision_name} msg]} {
					project_close
					regsub -all -- {(ERROR: |\n)} $msg {} msg
					::quartus::dse::ccl::eputs $msg
					regsub -all -- {\. } $msg ".\n" msg
					set end_dialog 0
				}
			}

			if { $end_dialog } {

				set_current_revision $new_revision_name
				# Now merge in the DSE point settings
				foreach {param value} [$results getAllSettings] {
					if {[regexp -nocase {^-} $param]} {
						# Ignore settings that begin with a '-'
					} else {
						# It's a Quartus II ACF setting...
						# Try to apply as a global setting, if that doesn't work
						# make a leap-of-faith and assume the project_name is the
						# same as the top level entity.  The other thing to try is
						# to use wildcards but it seems not everything supports this.
						# Is that true?
						if {[catch {set_global_assignment -name $param $value} msg]} {
							# Not sure if this should be an error or not...
						}
					}
				}
				export_assignments

				# Do we make this new revision the current revision?
				if {!$set_current_to_new} {
					set_current_revision $original_revision_name
				}

				project_close

				# Now run special actions
				foreach {param value} [$results getAllSettings] {
					if {[regexp -nocase {^-} $param]} {
						# Do any setup actions
						switch -- $param {
							{-setup-script} {
								if {[regexp -- {([a-zA-Z_]+):(.*)} $value => e f]} {
									set input "\"[file join $::quartus(binpath) $e]\" -t \"$f\" $project_name $new_revision_name"
									set output "${e}.out"
									set result [::quartus::dse::ccl::dse_exec $input $output]
								}
							}
						}
					}
				}
			}

			if { $end_dialog } {
				set msg "New revision $new_revision_name created.\nPlease compile this revision in Quartus II."
			}
		}

        if {$end_dialog} {
			# Display the success message and destroy this dialog
			MessageDlg $widgets(dlgCNR).infomsg -type ok -icon info -title "Success" -message $msg -parent $widgets(dlgCNR)
            $widgets(dlgCNR) enddialog 1
        } else {
			# Display the error message and don't destroy the dialog
            MessageDlg $widgets(dlgCNR).errmsg -type ok -icon error -message $msg -parent $widgets(dlgCNR)
        }
    }

    $widgets(dlgCNR) add -text "Cancel" -helptext "Discard changes" -helptype balloon -command {
        global widgets
        $widgets(dlgCNR) enddialog -1
    }

    #
    # GET THE MAIN FRAME FOR THIS DIALOG BOX
    #
    set dlgFrame [$widgets(dlgCNR) getframe]

        #
        # CREATE A NOTEBOOK TO HOLD THE DIFFERENT PANES
        #
        set notebook [NoteBook $dlgFrame.nb -font Tabs]

			#
			# CREATE THE NOTEBOOK PAGE TO MAKE A NEW REVISION
			#
			set qslavetab [$notebook insert end new -text "  New  " -raisecmd {set global_dse_options(gui-revision-merge-mode) "new"}]

				#
				# CREATE A SUB FRAME TO HOLD STUFF
				#
				set temp_frame [frame $qslavetab.tf2 -pady 2]
				pack $temp_frame -fill both -expand yes

				addWidget lfDSEPointNewCNR [LabelFrame $temp_frame.lfdsepointnewcnr -side left -text "Merge Settings from DSE Point:" -justify left -state normal -anchor w -padx 2 -pady 2 -relief flat -bd 0 -width 28]
				addWidget cboxDSEPointNewCNR [ComboBox [$widgets(lfDSEPointNewCNR) getframe].cboxdsepointnewcnr -values $dse_revision_list -editable 0 -width 25]
				$widgets(cboxDSEPointNewCNR) setvalue first
				pack $widgets(lfDSEPointNewCNR) $widgets(cboxDSEPointNewCNR) -expand yes -fill x -anchor nw -pady 2

                # Add a LabelFrame to hold the existing revision combobox
				addWidget lfBasedOnNewCNR [LabelFrame $temp_frame.lfbasedonnewcnr -side left -text "With Existing Revision:" -justify left -state normal -anchor w -padx 2 -pady 2 -relief flat -bd 0 -width 28]
				addWidget cboxBasedOnNewCNR [ComboBox [$widgets(lfBasedOnNewCNR) getframe].cboxbasedonnewcnr -values $project_revision_list -editable 0 -width 25]
				$widgets(cboxBasedOnNewCNR) setvalue "@${project_revision_index}"
				pack $widgets(lfBasedOnNewCNR) $widgets(cboxBasedOnNewCNR) -expand yes -fill x -anchor nw -pady 2

				# Add a LabelEntry to hold the new revision name text box
				addWidget labentNewRevNameNewCNR [LabelEntry $temp_frame.newrevnamenewcnr -labelwidth 28 -label "To Create the New Revision:" -text "DSE" -padx 2 -pady 2 -editable 1]
                pack $widgets(labentNewRevNameNewCNR) -anchor nw -side top -expand yes -fill x -anchor nw -pady 2

				# Add a checkbutton to let the user pick this as the default revision or not
				addWidget checkCurrentNewCNR [checkbutton $temp_frame.cbcurrentnewcnr -text "Make new revision the current revision" -offvalue 0 -onvalue 1 -justify left -anchor w]
				$widgets(checkCurrentNewCNR) select
				pack $widgets(checkCurrentNewCNR) -anchor w -side top -expand yes -fill x -padx 10 -pady 5

			#
			# CREATE THE NOTEBOOK PAGE TO MERGE WITH AN EXISTING REVISION
			#
			set lsftab [$notebook insert end merge -text "  Merge  " -raisecmd {set global_dse_options(gui-revision-merge-mode) "merge"}]

				#
				# CREATE A SUB FRAME TO HOLD STUFF
				#
				set temp_frame [frame $lsftab.tf1 -pady 2]
				pack $temp_frame -fill x -expand no -anchor nw

				addWidget lfDSEPointMergeCNR [LabelFrame $temp_frame.lfdsepointmergecnr -side left -text "Merge Settings from DSE Point:" -justify left -state normal -anchor w -padx 2 -pady 2 -relief flat -bd 0 -width 28]
				addWidget cboxDSEPointMergeCNR [ComboBox [$widgets(lfDSEPointMergeCNR) getframe].cboxdsepointmergecnr -values $dse_revision_list -editable 0 -width 25]
				$widgets(cboxDSEPointMergeCNR) setvalue first
				pack $widgets(lfDSEPointMergeCNR) $widgets(cboxDSEPointMergeCNR) -expand yes -fill x -anchor nw -pady 2

				# Add a LabelFrame to hold the existing revision combobox
				addWidget lfBasedOnMergeCNR [LabelFrame $temp_frame.lfbasedonmergecnr -side left -text "With Existing Revision:" -justify left -state normal -anchor w -padx 2 -pady 2 -relief flat -bd 0 -width 28]
				addWidget cboxBasedOnMergeCNR [ComboBox [$widgets(lfBasedOnMergeCNR) getframe].cboxbasedonmergecnr -values $project_revision_list -editable 0 -width 25]
				$widgets(cboxBasedOnMergeCNR) setvalue "@${project_revision_index}"
				pack $widgets(lfBasedOnMergeCNR) $widgets(cboxBasedOnMergeCNR) -expand yes -fill x -anchor nw -pady 2

				# Add a checkbutton to let the user pick this as the default revision or not
				addWidget checkCurrentMergeCNR [checkbutton $temp_frame.cbcurrentmergecnr -text "Make this revision the current revision" -offvalue 0 -onvalue 1 -justify left -anchor w]
				$widgets(checkCurrentMergeCNR) select
				pack $widgets(checkCurrentMergeCNR) -anchor w -side top -expand yes -fill x -padx 10 -pady 5

		#
		# PACK THE NOTEBOOK THAT HOLDS EVERYTHING
		#
		$notebook compute_size
		pack $notebook -fill both -expand yes

	#
	# PACK THE TOPLEVEL WINDOW FOR ALL THE CONFIGURATION
	#
	pack $dlgFrame -padx 7 -pady 7

	# Pick the notebook tab the user is currently using
	if { [string match -nocase $global_dse_options(gui-revision-merge-mode) "merge"] } {
		$notebook raise merge
	} else {
		$notebook raise new
	}

    # The user should be able to get window-specific help by hitting the F1 key.
    bind $widgets(dlgCNR) <F1> {::quartus::dse::gui::on_help -page /dse/dse_db_create_revision.htm}

    # Show the dialog
    set result [$widgets(dlgCNR) draw]

	if {$result == 1} {
		# New revision was created, we need to reload
		# the project's revision settings in the main UI.
		#set current_revision [lindex $project_revision_list $project_revision_index]
		set current_revision [get_current_revision $project_name]
		# Refresh the list of revisions
		set project_revision_list [get_project_revisions $project_name]
		# Get the new index of the current_revision in this list
		set project_revision_index 0
		for {set i 0} {$i < [llength $project_revision_list]} {incr i} {
			set rev [lindex $project_revision_list $i]
			if {[string equal $rev $current_revision]} {
				set project_revision_index $i
				break
			}
		}
		# And make sure the GUI is reporting the new state of affairs
		$widgets(cboxRevisionName) configure -values $project_revision_list
		$widgets(cboxRevisionName) setvalue "@${project_revision_index}"
	}

    # Destory widgets
    catch {destroy $widgets(dlgCNR)}
    catch {array unset widgets *CNR}

    return 1
}


proc ::quartus::dse::gui::on_select_distributed_dse_method {args} {

    set debug_name "::quartus::dse::gui::on_select_distributed_dse_method()"

    # Import global namespace variables
    global widgets
	global global_dse_options

	# If this is not internal-only use the user can never select "abc"
	# so make sure we don't accidentally try and use "abc".
	set dse_internal_use [get_ini_var -name "dse_internal_use"]
	if { [string match -nocase $dse_internal_use "off"] && [string match $global_dse_options(gui-distribute-using) "abc"] } {
		set global_dse_options(gui-distribute-using) "qslave"
    }

	if { [string match -nocase $global_dse_options(gui-distribute-using) "lsf"] } {
		# Disable ABC configuration options (if they exist)

		# Disable QSlave configuration options
        $widgets(lbEnterSlaves) configure -state disabled;
		$widgets(butAddEnterSlaves) configure -state disabled;
		$widgets(butDeleteEnterSlaves) configure -state disabled;

		# Enable LSF configuration options
		$widgets(labelLSF) configure -state normal;
		$widgets(cboxLSF) configure -state normal;
	} elseif { [string match -nocase $global_dse_options(gui-distribute-using) "qslave"] } {
		# Disable ABC configuration options (if they exist)

		# Enable QSlave configuration options
        $widgets(lbEnterSlaves) configure -state normal;
		$widgets(butAddEnterSlaves) configure -state normal;
		$widgets(butDeleteEnterSlaves) configure -state normal;

		# Disable LSF configuration options
		$widgets(labelLSF) configure -state disabled;
		$widgets(cboxLSF) configure -state disabled;
	} elseif { [string match -nocase $global_dse_options(gui-distribute-using) "abc"] } {
		# Enable ABC configuration options

		# Disable QSlave configuration options
        $widgets(lbEnterSlaves) configure -state disabled;
		$widgets(butAddEnterSlaves) configure -state disabled;
		$widgets(butDeleteEnterSlaves) configure -state disabled;

		# Disable LSF configuration options
		$widgets(labelLSF) configure -state disabled;
		$widgets(cboxLSF) configure -state disabled;
	} else {
		# How did we end up here? This is bad.
	}

	return 1;
}


#############################################################################
##  Procedure:  on_add_slave_machine
##
##  Arguments:
##      <none>
##
##  Description:
##      Adds a new slave machine to the list.
proc ::quartus::dse::gui::on_add_slave_machine {} {

    set debug_name "::quartus::dse::gui::on_add_slave_machine()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable app_window_icon

	# Destroy an existing copy of this widget
	catch {destroy $widgets(dlgNewClient)}
	catch {array unset widgets *NewClient}

    addWidget dlgNewClient [Dialog $widgets(dlgEnterSlaves).clientdlg -modal local -side bottom -transient 1 -parent $widgets(dlgEnterSlaves) -place center -separator 1 -title "Add Client" -default 0 -cancel 1]
    wm iconbitmap $widgets(dlgEnterSlaves).clientdlg $app_window_icon
    $widgets(dlgNewClient) add -text "OK" -helptext "Accept changes" -helptype balloon -command {
        global widgets
        $widgets(dlgNewClient) enddialog [$widgets(entNewClient) cget -text]
    }
    $widgets(dlgNewClient) add -text "Cancel" -helptext "Discard changes" -helptype balloon -command {
        global widgets
        $widgets(dlgNewClient) enddialog ""
    }

    set dlgFrame [$widgets(dlgNewClient) getframe]
    addWidget entNewClient [Entry $dlgFrame.ent -width 50]
    pack $widgets(entNewClient) -expand yes -fill x
    pack $dlgFrame -expand yes -fill both

    # The user should be able to get window-specific help by hitting the F1 key.
    bind $widgets(dlgNewClient) <F1> {::quartus::dse::gui::on_help -page /dse/dse_db_add_client.htm}

    set newclient [$widgets(dlgNewClient) draw $widgets(entNewClient)]

    if {$newclient != -1} {

        set noadd 0

        # Remove leading and trailing white space
        regsub -all -nocase -- {^[ \t]+|[ \t]+$} $newclient {} newclient

        # Examine the slave names to make sure they are legit
        ::quartus::dse::ccl::dputs "${debug_name}: Examining slave: \"$newclient\""



        # If the client is just an empty string skip the add...
        if {![regexp -nocase -- {^\s*$} $newclient]} {
            # It cannot have any spaces in it, it cannot be an empty string
            if {[regexp -nocase -- {\s+} $newclient]} {
                set noadd 1
            }
            if {!$noadd} {
                set num_entries [$widgets(lbEnterSlaves) size]

                # Check if client is already there
                for { set i 0 } { $i < $num_entries } { incr i } {
                    set client [$widgets(lbEnterSlaves) get $i]
                    if {[string equal -nocase $newclient $client]} {
                        set noadd 1
                    }
                }

                if {$noadd} {
                    MessageDlg $widgets(dlgEnterSlaves).errmsg -parent $widgets(dlgEnterSlaves) -icon error -message "Slave $newclient is already in the list" -type ok -parent $widgets(dlgEnterSlaves)
                } else {
                    $widgets(lbEnterSlaves) insert end $newclient
                }
            } else {
                MessageDlg $widgets(dlgEnterSlaves).errmsg -parent $widgets(dlgEnterSlaves) -icon error -message "Slave \"$newclient\" is not a valid slave name" -type ok -parent $widgets(dlgEnterSlaves)
            }
        }
    }

    catch {destroy $widgets(dlgNewClient)}
    catch {array unset widgets *NewClient}

    return 1
}


#############################################################################
##  Procedure:  on_delete_slave_machines
##
##  Arguments:
##      <none>
##
##  Description:
##      Removes selected slave machines from the list.
proc ::quartus::dse::gui::on_delete_slave_machines {} {

    set debug_name "::quartus::dse::gui::on_delete_slave_machines()"


    # Import global namespace variables
    global widgets
	global global_dse_options

    foreach fi [lsort -integer -decreasing [$widgets(lbEnterSlaves) curselection]] {
        $widgets(lbEnterSlaves) delete $fi
    }

    return 1
}


#############################################################################
##  Procedure:  update_elapsed_timer
##
##  Arguments:
##      <none>
##
##  Description:
##      Updates the percent complete and elapsed timer that shows
##      the user how long the exploration has been running for.
##      The function automatically schedules itself to run every
##      second. This auto-run scheduling can be cancelled when the
##      exploration is finished by calling:
##
##          variable exploration_timer\
##          after cancel $exploration_timer
##
##      Function returns true always.
proc ::quartus::dse::gui::update_elapsed_timer {args} {

    set debug_name "::quartus::dse::gui::update_elapsed_timer()"

    # Import global namespace variables
    global widgets
    global global_dse_options
    variable exploration_start_time
    variable exploration_timer
    variable progress_variable
    variable progress_max

    if {!$global_dse_options(dse-gui)} {
        return 1
    }

    # Command line options to this function we require
    lappend function_opts [list "one-time" 0 "A one-time call, do not reschedule"]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Get the elapsed time string for exploration
    set ttext [::quartus::dse::ccl::elapsed_time_string [expr {[clock clicks -milliseconds] - $exploration_start_time}]]

    # Round percentage to the nearest integer
    set percent [expr {round(100 * $progress_variable / $progress_max)}]

    # Set the text so the user can see the progress and elapsed time
    catch {$widgets(elapsedTimeStatusExploration) configure -text "$percent%     $ttext"}

    # Schedule function to run again in exactly one second
    if {!$optshash(one-time)} {
        set exploration_timer [after 1000 ::quartus::dse::gui::update_elapsed_timer]
    }

    return 1
}


#############################################################################
##  Procedure:  on_change_decision_column
##
##  Arguments:
##      <none>
##
##  Description:
##      Displays a nice little UI that lets the user change the
##      name of the column used to extract slack information
##      from for the best/worst decision functions. Lets the
##      user make the best/worst functions target something
##      other than the Worst-case Slack for the design (like
##      the slack for a clock in the design).
proc ::quartus::dse::gui::on_change_decision_column {args} {

    set debug_name "::quartus::dse::gui::on_change_decision_column()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable app_window_icon

	# Destroy an existing copy of this widget
	catch {destroy $widgets(dlgCDC)}
	catch {array unset widgets *CDC}

    # Save the current value
    set curr_val $global_dse_options(gui-slack-column)

    addWidget dlgCDC [Dialog $widgets(mainframe).cdcdlg -modal local -side bottom -transient 1 -parent $widgets(mainframe) -place center -separator 1 -title "Change Decision Column" -default 0]
    wm iconbitmap $widgets(mainframe).cdcdlg $app_window_icon
    $widgets(dlgCDC) add -text "OK" -helptext "Accept changes" -helptype balloon -command {
        global widgets
        set end_dialog 1

        # Value must be a non-empty string
        if {[regexp -nocase -- {^\s*$} $global_dse_options(gui-slack-column)]} {
            set end_dialog 0
            set msg "Column name not specified.\nYou must select a column name from the list or enter your own.\nIf you wish to keep the current settings press the Cancel button.\nTo use the default column name press the Default button."
        }

        # Value must not say <any column name>
        if {[regexp -nocase -- {^<any column name>$} $global_dse_options(gui-slack-column)]} {
            set end_dialog 0
            set msg "Column name not specified.\nPlease replace the text <any column name> with a column name of your choice.\nIf you wish to keep the current settings press the Cancel button.\nTo use the default column name press the Default button."
        }

        # Value must not say <clock name> in it
        if {[regexp -nocase -- {<clock name>} $global_dse_options(gui-slack-column)]} {
            set end_dialog 0
            set msg "No clock name entered.\nPlease replace the text <clock name> with a valid clock name from your design.\nIf you wish to keep the current settings press the Cancel button.\nTo use the default column name press the Default button."
        }

        # If the value isn't set to #_default_# we need to make sure the GUI
        # shows the update. Only do this if we're going to end this dialog.
        if {![string equal -nocase $global_dse_options(gui-slack-column) "#_default_#"] && $end_dialog} {
            ::quartus::dse::ccl::dputs "${debug_name}: User has changed the slack-column to \"$global_dse_options(gui-slack-column)\""
            # First, check and see if the new slack column value they want to use
            # is already in the list of slack column values. If it is set the
            # index to this value so we show this selection the next time the dialog
            # is loaded by the user.
            ::quartus::dse::ccl::dputs "${debug_name}: Checking slack-column-list to see if change is there already"
            set is_in_list 0
            for {set i 0} {$i < [llength $global_dse_options(gui-slack-column-list)]} {incr i} {
                ::quartus::dse::ccl::dputs "${debug_name}:      Checking against: @$i = [lindex $global_dse_options(gui-slack-column-list) $i]"
                if {[string equal [lindex $global_dse_options(gui-slack-column-list) $i] $global_dse_options(gui-slack-column)]} {
                    ::quartus::dse::ccl::dputs "${debug_name}:      Found match in slack-column-list at index @$i!"
                    set is_in_list 1
                    set global_dse_options(gui-slack-column-index) "@$i"
                    # No need to check any further, we've memorized the index in
                    # the list for the next time the dialog is opened.
                    break
                }

            }
            # If we didn't find this value in the list already we need to
            # add it to the list and set the index to the end.
            if {!$is_in_list} {
                ::quartus::dse::ccl::dputs "${debug_name}: Couldn't find \"$global_dse_options(gui-slack-column)\" in slack-column-list"
                ::quartus::dse::ccl::dputs "${debug_name}: Appending \"$global_dse_options(gui-slack-column)\" to the end of slack-column-list"
                lappend global_dse_options(gui-slack-column-list) $global_dse_options(gui-slack-column)
                set global_dse_options(gui-slack-column-index) "last"
            }
        }

        if {$end_dialog} {
            $widgets(dlgCDC) enddialog 1
        } else {
            MessageDlg $widgets(dlgCDC).errmsg -type ok -icon error -message $msg -parent $widgets(dlgCDC)
        }
    }

    $widgets(dlgCDC) add -text "Default" -helptext "Set to default value and continue" -helptype balloon -command {
        global widgets
        set global_dse_options(gui-slack-column) "#_default_#"
        set global_dse_options(gui-slack-column-index) "first"
        $widgets(dlgCDC) enddialog 1
    }

    $widgets(dlgCDC) add -text "Cancel" -helptext "Cancel" -helptype balloon -command {
        global widgets
        $widgets(dlgCDC) enddialog 0
    }

    set dlgFrame [$widgets(dlgCDC) getframe]

    # Add a Label
    addWidget labelCDC [Label $dlgFrame.lcdc -width 15 -text "Column Name:" -justify left -state normal -anchor w -padx 0]

    # And a combobox to hold some suggested label names
    addWidget cboxSuggestionsCDC [ComboBox $dlgFrame.cname -values $global_dse_options(gui-slack-column-list) -editable 1 -width 25 -textvariable {global_dse_options(gui-slack-column)}]
    $widgets(cboxSuggestionsCDC) setvalue $global_dse_options(gui-slack-column-index)
    pack $widgets(labelCDC) -anchor nw -expand no -side left
    pack $widgets(cboxSuggestionsCDC) -anchor nw -expand no -fill none
    pack $dlgFrame -anchor nw -side top -expand yes

    # The user should be able to get window-specific help by hitting the F1 key.
    bind $widgets(dlgCDC) <F1> {::quartus::dse::gui::on_help -page /dse/dse_db_chg_decision_col.htm}

    # Show the dialog
    set retval [$widgets(dlgCDC) draw $widgets(cboxSuggestionsCDC)]

    if {$retval <= 0} {
        # User cancled. Restore original value.
        set global_dse_options(gui-slack-column) $curr_val
    }

    catch {destroy $widgets(dlgCDC)}
    catch {array unset widgets *CDC}

    return 1
}


#############################################################################
##  Procedure:  on_open_project_in_quartus
##
##  Arguments:
##      <none>
##
##  Description:
##      Closes down DSE and opens the current project in
##      the Quartus II GUI. Makes the user confirm that they
##      want to close DSE and do this first.
proc ::quartus::dse::gui::on_open_project_in_quartus {args} {

    set debug_name "::quartus::dse::gui::on_open_project_in_quartus()"

    # Import global namespace variables
    global widgets

    # Function options
    lappend function_opts [list "parent.arg" $widgets(mainframe) "Parent window for dialog"]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    #
    # BEGIN GUI CREATION CODE
    #

    set msg "Close DSE and open this project in Quartus II?"
    set answer [ tk_messageBox -type yesno -message $msg -icon question -title "Open Project in Quartus II" -parent $optshash(parent)]

    #
    # END GUI CREATION CODE
    #

    if {$answer == "yes"} {
        # User wants to close DSE and open the project
        # in the Quartus II GUI.
        set pname [$widgets(labentProjectName) cget -text]
        on_close_project
        if {[catch {exec -- [file join $::quartus(binpath) quartus] $pname &}]} {
            # Error
        } else {
            close_gui
        }
    }

    return 1
}


#############################################################################
##  Procedure:  on_open_project_in_timequest
##
##  Arguments:
##      <none>
##
##  Description:
##      Closes down DSE and opens the current project in
##      the TimeQuest Timing Analyzer. Makes the user confirm
##      that they want to close DSE and do this first.
proc ::quartus::dse::gui::on_open_project_in_timequest {args} {

    set debug_name "::quartus::dse::gui::on_open_project_in_timequest()"

    # Import global namespace variables
    global widgets

    # Function options
    lappend function_opts [list "parent.arg" $widgets(mainframe) "Parent window for dialog"]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    #
    # BEGIN GUI CREATION CODE
    #

    set msg "Close DSE and open this project in the TimeQuest Timing Analyzer?"
    set answer [ tk_messageBox -type yesno -message $msg -icon question -title "Open Project in TimeQuest Timing Analyzer" -parent $optshash(parent)]

    #
    # END GUI CREATION CODE
    #

    if {$answer == "yes"} {
        # User wants to close DSE and open the project
        # in the Quartus II GUI.
        set pname [$widgets(labentProjectName) cget -text]
        on_close_project
        if {[catch {exec -- [file join $::quartus(binpath) quartus_staw] $pname &}]} {
            # Error
        } else {
            close_gui
        }
    }

    return 1
}


#############################################################################
##  Procedure:  update_approximate_compile_time
##
##  Arguments:
##      <none>
##
##  Description:
##		Displays a little message in the bottom-left corner of the GUI that
##      shows roughly (VERY roughly) how long an exploration with the current
##      settings would take in terms of the base compile (i.e. 2X as long as
##      the base compilation).
##
proc ::quartus::dse::gui::update_approximate_compile_time {} {
    set debug_name "::quartus::dse::gui::update_approximate_compile_time()"

    # Import global namespace variables
    global widgets
	global global_dse_options
    variable available_exploration_spaces
    variable selected_quick_optimization
	variable progress_text
	variable advanced_use

	# This is the multiplier, which, if exceeded, causes the text to turn
	# blue for the estimated time
    set estimated_time_warning_threshold 40

    # Find the space library for this family
    regsub -nocase -all -- {\s+} [string tolower [$widgets(labentProjectFamily) cget -text]] {} modified_family
    switch -exact -- $modified_family {
        stratix -
        stratixgx {
            package require ::quartus::dse::stratix
            set procGetCompileTimeMultiplier  ::quartus::dse::stratix::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::stratix::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::stratix::get_quick_recipe_for
        }
        cyclone {
            package require ::quartus::dse::cyclone
            set procGetCompileTimeMultiplier  ::quartus::dse::cyclone::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::cyclone::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::cyclone::get_quick_recipe_for
        }
        maxii {
            package require ::quartus::dse::maxii
            set procGetCompileTimeMultiplier  ::quartus::dse::maxii::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::maxii::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::maxii::get_quick_recipe_for
        }
        stratixii -
        stratixiigx {
            package require ::quartus::dse::stratixii
            set procGetCompileTimeMultiplier  ::quartus::dse::stratixii::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::stratixii::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::stratixii::get_quick_recipe_for
        }
		arriagx -
        arria {
            package require ::quartus::dse::arria
            set procGetCompileTimeMultiplier  ::quartus::dse::arria::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::arria::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::arria::get_quick_recipe_for
        }
        stratixiii {
            package require ::quartus::dse::stratixiii
            set procGetCompileTimeMultiplier  ::quartus::dse::stratixiii::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::stratixiii::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::stratixiii::get_quick_recipe_for
        }
		stratixiv -
		arriaii -
		arriaiigx {
            package require ::quartus::dse::stratixiv
            set procGetCompileTimeMultiplier  ::quartus::dse::stratixiv::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::stratixiv::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::stratixiv::get_quick_recipe_for
        }
        cycloneiii {
            package require ::quartus::dse::cycloneiii
            set procGetCompileTimeMultiplier  ::quartus::dse::cycloneiii::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::cycloneiii::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::cycloneiii::get_quick_recipe_for
        }
        cycloneii {
            package require ::quartus::dse::cycloneii
            set procGetCompileTimeMultiplier  ::quartus::dse::cycloneii::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::cycloneii::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::cycloneii::get_quick_recipe_for
        }
        flex6000 {
            package require ::quartus::dse::flex6000
            set procGetCompileTimeMultiplier  ::quartus::dse::flex6000::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::flex6000::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::flex6000::get_quick_recipe_for
        }
        max3000a -
        max7000ae -
        max7000b -
        max7000s {
            package require ::quartus::dse::max7000
            set procGetCompileTimeMultiplier  ::quartus::dse::max7000::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::max7000::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::max7000::get_quick_recipe_for
        }
        hardcopyii {
            package require ::quartus::dse::hardcopyii
            set procGetCompileTimeMultiplier  ::quartus::dse::hardcopyii::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::hardcopyii::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::hardcopyii::get_quick_recipe_for
        }
        default {
            package require ::quartus::dse::genericfamily
            set procGetCompileTimeMultiplier  ::quartus::dse::genericfamily::get_multiplier_for_type
            set procHasRecipe                 ::quartus::dse::genericfamily::has_quick_recipe_for
            set procGetRecipe                 ::quartus::dse::genericfamily::get_quick_recipe_for
        }
    }

    #  Determine which exploration space we're using here
   	set selected_exploration_space ""

   	#  If its the 'Advanced' mode, then just grab the setting from the dialog box
    if {[string compare -nocase $::quartus::dse::gui::selected_quick_optimization "custom"] == 0} {
    	set selected_exploration_space [lindex $::quartus::dse::gui::available_exploration_spaces [$widgets(dlgCustom.cboxExplorationSpaces) getvalue]]
    #  If it's a 'quick recipe', get the recipe and set the exploration space accordingly
	} else {
	    switch -- $::quartus::dse::gui::selected_quick_optimization {
	        "area" {
	            # Get the quick recipe for this family
	            if {[$procHasRecipe "area"]} {
		            set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "area"]

		            if {[llength $quick_recipe] == 0} {
		                # Wow. This is such a bad error. How did we get here?
		                catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous! 1" -icon error -title "We shouldn't be here!"}
		                on_close_project
		                close_gui
		            }
	            	set selected_exploration_space [lindex $quick_recipe 0]
            	} else {
	            	set selected_exploration_space ""
        		}
	        }
	        "speed" {
		        set found_quick_recipe 0
	            switch -- [lindex $::quartus::dse::gui::available_speed_effort_levels [$widgets(cboxEffort) getvalue]]  {
	                {Low (Seed Sweep)} {
	                    # Get the quick recipe for this family
	                    if {[$procHasRecipe "speed:low"]} {
		                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:low"]
		                    if {[llength $quick_recipe] == 0} {
		                        # Wow. This is such a bad error. How did we get here?
		                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous! 2" -icon error -title "We shouldn't be here!"}
		                        on_close_project
		                        close_gui
		                    }
		                    set found_quick_recipe 1
	                    }
	                }
	                {Medium (Extra Effort Space)} {
	                    # Get the quick recipe for this family
	                    if {[$procHasRecipe "speed:medium"]} {
		                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:medium"]
		                    if {[llength $quick_recipe] == 0} {
		                        # Wow. This is such a bad error. How did we get here?
		                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous! 3" -icon error -title "We shouldn't be here!"}
		                        on_close_project
		                        close_gui
		                    }
		                    set found_quick_recipe 1
	                    }
	                }
	                {High (Physical Synthesis Space)} {
	                    # Get the quick recipe for this family
	                    if {[$procHasRecipe "speed:high"]} {
		                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:high"]
		                    if {[llength $quick_recipe] == 0} {
		                        # Wow. This is such a bad error. How did we get here?
		                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous! 4" -icon error -title "We shouldn't be here!"}
		                        on_close_project
		                        close_gui
		                    }
		                    set found_quick_recipe 1
	                    }
	                }
	                {Highest (Physical Synthesis with Retiming Space)} {
	                    # Get the quick recipe for this family
	                    if {[$procHasRecipe "speed:highest"]} {
		                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:highest"]
		                    if {[llength $quick_recipe] == 0} {
		                        # Wow. This is such a bad error. How did we get here?
		                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous! 5" -icon error -title "We shouldn't be here!"}
		                        on_close_project
		                        close_gui
		                    }
		                    set found_quick_recipe 1
	                    }
	                }
	                {Selective (Selected Performance Optimizations)} {
	                    # Get the quick recipe for this family
	                    if {[$procHasRecipe "speed:selective"]} {
		                    set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "speed:selective"]
		                    if {[llength $quick_recipe] == 0} {
		                        # Wow. This is such a bad error. How did we get here?
		                        catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous! 5" -icon error -title "We shouldn't be here!"}
		                        on_close_project
		                        close_gui
		                    }
		                    set found_quick_recipe 1
	                    }
	                }
	                default {
		                set found_quick_recipe 0
						set dse_verbose_msg [get_ini_var -name "dse_verbose_warnings"]
						if { [string match -nocase $dse_verbose_msg "on"] } {
							::quartus::dse::ccl::wputs "Warning:  Unknown speed optimization in update_approximate_compile_time"
						}
	                }
	            }
	            if {$found_quick_recipe == 1} {
	            	set selected_exploration_space [lindex $quick_recipe 0]
            	} else {
	            	set selected_exploration_space ""
            	}
	        }
	        "power" {
	            # Get the quick recipe for this family
	            if {[$procHasRecipe "power"]} {
		            set quick_recipe [$procGetRecipe -qii-synthesis $global_dse_options(gui-project-uses-qiiis) -recipe "power"]
		            if {[llength $quick_recipe] == 0} {
		                # Wow. This is such a bad error. How did we get here?
		                catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous! 7" -icon error -title "We shouldn't be here!"}
		                on_close_project
		                close_gui
		            }
		            set selected_exploration_space [lindex $quick_recipe 0]
	            } else {
		            set selected_exploration_space ""
	            }
	        }
	        "custom" {
	            set selected_exploration_space "Custom"
	        }
	        default {
	            # Wow. This is such a bad error. How did we get here?
	            catch { tk_messageBox -type ok -message "We shouldn't be here! It's dangerous! 8" -icon error -title "We shouldn't be here!"}
	            on_close_project
	            close_gui
	        }
	    }
	}

	if {$selected_exploration_space == 0} {
		set selected_exploration_space ""
	}

	#  Now that we know what space we're using, get the multiplier
	set multiplier -1
	set num_points -1

	#  The custom pane no longer exists by default, only with a special INI var
	set custom_pane_exists [info exists widgets(dlgCustom.cboxSearchMethod)]

	#  This function can be called before the GUI has been set up, so make sure it is, and report "unknown" if
	#  it's not yet.  Also report unknown if they're using 'custom' but the pane doesn't exist
    if {$selected_exploration_space != "" && $procGetCompileTimeMultiplier != "" &&
    	[info exists ::quartus::dse::base_point_options(base-placement-effort-multiplier)]} {

		#  Pass in whether we're in accelerated or exhaustive search mode
		if {[string compare -nocase $::quartus::dse::gui::selected_quick_optimization "custom"] == 0 && $custom_pane_exists} {
			set ::quartus::dse::base_point_options(using-advanced-settings) 1
		    set ::quartus::dse::base_point_options(selected-search-method) [lindex $::quartus::dse::gui::available_search_methods [$widgets(dlgCustom.cboxSearchMethod) getvalue]]
		} elseif {[string compare -nocase $::quartus::dse::gui::selected_quick_optimization "custom"] != 0} {
			set ::quartus::dse::base_point_options(using-advanced-settings) 0
			set ::quartus::dse::base_point_options(selected-search-method) "Accelerated Search of Exploration Space"
		} else {
			set ::quartus::dse::base_point_options(using-advanced-settings) 0
			set ::quartus::dse::base_point_options(selected-search-method) ""
		}

		set ::quartus::dse::base_point_options(get-number-of-points-only) 0
        set multiplier [$procGetCompileTimeMultiplier $selected_exploration_space "global_dse_options" "::quartus::dse::base_point_options"]
		set ::quartus::dse::base_point_options(get-number-of-points-only) 1
        set num_points [$procGetCompileTimeMultiplier $selected_exploration_space "global_dse_options" "::quartus::dse::base_point_options"]
    }

    #  Show the string in the window, we piggy-back on the progress text.
    if {[info exists widgets(estimatedTime)]} {
	    set time_widget_created 1
    } else {
	    set time_widget_created 0
    }

    set colour "black"

    if {$multiplier >= $estimated_time_warning_threshold} {
		set ::quartus::dse::gui::estimated_time_text "Estimated worst-case exploration time: ${multiplier} × Base compilation time"
	    if { $num_points > 1 } {
			::quartus::dse::gui::update_progress -update-progress-status "${num_points} Points"
		} else {
			::quartus::dse::gui::update_progress -update-progress-status "${num_points} Point"
		}
	    set colour "blue"
	} elseif {$multiplier >= 0} {
	    set ::quartus::dse::gui::estimated_time_text "Estimated worst-case exploration time: ${multiplier} × Base compilation time"
		if { $num_points > 1 } {
			::quartus::dse::gui::update_progress -update-progress-status "${num_points} Points"
		} else {
			::quartus::dse::gui::update_progress -update-progress-status "${num_points} Point"
		}
    } else {
	    set ::quartus::dse::gui::estimated_time_text "Estimated worst-case exploration time: N/A"
		if { $num_points > 1 } {
			::quartus::dse::gui::update_progress -update-progress-status "${num_points} Points"
		} else {
			::quartus::dse::gui::update_progress -update-progress-status "${num_points} Point"
		}
    }

    if {$time_widget_created != 0} {
    	$widgets(estimatedTime) configure -fg $colour
	}
    return 1
}
