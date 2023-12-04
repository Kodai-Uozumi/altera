#############################################################################
##  qinstall.tcl
##
##  Qinstall Graphical User Interface
##  This script allows a user to easily manage device family package files
##  Used to install Quartus support for device families
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

load_package device

#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::qpm::install_ui {
    
    namespace export main
    namespace export print_msg
    
    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

    variable app_name "Quartus Device Family Installer"
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

    variable package_info

    set package_info(name)  "<Select>"


}



#############################################################################
##  Procedure:  start_ui
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Creates the GUI for you. You should call this function and
##      run a vwait on the exit_qinstall_gui variable. This is touched
##      when the GUI destroys itself.
proc ::qpm::install_ui::start_ui {} {
    
    set debug_name "::qpm::install_ui::start_ui()"

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

    #
    # TURN ON GUI CODE
    #
    set gui_mode 1

    #
    # CONFIGURE SOME PATHS USED BY THE SCRIPT
    #
#    set app_path [file join $::quartus(tclpath) "apps" "qboard"]
#    set app_package_path [file join $::quartus(tclpath) "packages" "qboard"]
#    set app_icon_path [file join $::quartus(tclpath) "packages" "qboard"]

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
#	set app_window_icon "@[file join $app_icon_path qpm.xbm]"
    } else {
#	set app_window_icon "[file join $app_icon_path qpm.ico]"
    }
#    wm iconbitmap . $app_window_icon

    #
    # CREATE THE USER MENUS AND MENU GROUPS FOR THE MAIN WINDOW
    #
    set menu_desc {
        "&File" all file 0 {
	    {command "&Install Package..." {DISABLE_DURING_COMPILE} {} {Ctrl N} -command "eval ::qpm::install_ui::on_install_package_dlg" }
            {separator}
            {command "E&xit" {DISABLE_DURING_COMPILE} {} {Alt F4} -command {global widgets; destroy $widgets(mainframe)}}
        }
    }

    #
    # CREATE THE MAINFRAME FOR THE APPLICATION
    #
    addWidget mainframe [MainFrame .mainframe \
        -menu $menu_desc \
        -progressmax $::qpm::install_ui::progress_max \
        -progresstype normal \
        -progressvar ::qinstall::progress_variable \
        -textvariable ::qpm::install_ui::progress_text ]

    #
    # ADD A STATUS LABEL
    #
    addWidget VersionLabel [$widgets(mainframe) addindicator -text " Quartus II $::quartus(version) "]


        #
        # CREATE A NOTEBOOK TO HOLD THE DIFFERENT PANES
        #
        set pane [$widgets(mainframe) getframe]
        addWidget notebook [NoteBook $pane.nb -font Tabs]
    
            #
            # CREATE THE NOTEBOOK PAGE TO HOLD SETTINGS
            #
#            addWidget configtab [$widgets(notebook) insert end config -text "  Settings  "]

                    
            #
            # CREATE THE NOTEBOOK PAGE TO HOLD FILE LISTS
            #
            addWidget filestab [$widgets(notebook) insert end family_tab -text "  Device Families  "]

                #
                # CREATE A FRAME FOR THE MESSAGES
                #
                addWidget frameFiles [TitleFrame $widgets(filestab).tfMessages -text "Family List" -ipad 2]
                pack $widgets(frameFiles) -anchor nw -expand yes -fill both


                    # 
                    # ADD THE LIST FILE AREA. (FOR NOW)
                    #
                    set f [$widgets(frameFiles) getframe]
                    addWidget swFiles [ScrolledWindow $f.sw -auto none]
                    addWidget FTree [Tree $widgets(swFiles).tree -relief flat -borderwidth 0 \
                                -width 15 -highlightthickness 0 -redraw 0 -dropenabled 1 \
                                -dragenabled 1 -dragevent 3 \
				-opencmd "::qpm::install_ui::moddir 1 $widgets(swFiles).tree" \
				-closecmd "::qpm::install_ui::moddir 0 $widgets(swFiles).tree" ] 
                    $widgets(swFiles) setwidget $widgets(FTree)
                    pack $widgets(swFiles) -expand yes -fill both


            #
            # CREATE THE NOTEBOOK PAGE TO HOLD MESSAGES
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
        $widgets(notebook) raise family_tab

	#
    # CREATE GENERATE BUTTON
    #


#     addWidget FramePackageEntry [frame $widgets(mainframe).packageentry]
#     addWidget labentPackageName [LabelEntry $widgets(FramePackageEntry).pname -labelwidth 19 -label "Device Family Package:" -text "" -padx 1 -editable 0 -relief flat]
#     $widgets(labentPackageName) configure -entrybg [$widgets(labentPackageName) cget -background]

#     set foo pp
#     addWidget entryPackageName [Entry $widgets(FramePackageEntry).entry -text "<enter package name>" -textvariable foo -helptext "Entry widget"]
 
#     addWidget PackageDotDotDot [Button $widgets(FramePackageEntry).gen_button -text "..." -repeatdelay 300 -command  {::qpm::install_ui::on_generate} -helptext "Select Device Family Package"]
#     pack $widgets(labentPackageName) -anchor nw -side left
#     pack $widgets(entryPackageName) -anchor nw -side left
#     pack $widgets(PackageDotDotDot) -anchor nw
#     pack $widgets(FramePackageEntry) -fill both -expand yes -padx 200 -pady 20




    #
    # PACK THE TOPLEVEL WINDOW FOR EVERYTHING
    #
    pack $widgets(mainframe) -fill both -expand yes

    ::qpm::install_ui::update_family_list

    update idletasks

    # Make sure when the user destroys the application
    # the project settings are stored in qflow project file
    bind $widgets(mainframe) <Destroy> {::qpm::install_ui::close_gui}

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
proc ::qpm::install_ui::addWidget {_wname _truename} {

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
proc ::qpm::install_ui::print_msg {args} {

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
proc ::qpm::install_ui::close_gui {args} {
    global exit_qinstall_gui

    set exit_qinstall_gui 1
    return $exit_qinstall_gui
}

# ---------------------------------------------------------------------------
#
proc ::qpm::install_ui::moddir { idx tree node } {
#
# Description:	This function handles closing and opening of tree node.
#
# ----------------------------------------------------------------------------

	if { $idx && [$tree itemcget $node -drawcross] == "allways" } {
		getdir $tree $node [$tree itemcget $node -data]
		if { [llength [$tree nodes $node]] } {
			$tree itemconfigure $node -image [Bitmap::get openfold]
		} else {
			$tree itemconfigure $node -iamge [Bitmap::get folder]
		}
	} else {
		$tree itemconfigure $node -image [Bitmap::get [lindex {folder openfold} $idx]]
	}
}


# ----------------------------------------------------------------
#
proc ::qpm::install_ui::update_family_list {} {
#
# Description:	Update Family List
#
# ----------------------------------------------------------------

    # Import global namespace variables
    global widgets

    # First delete all entries
    $widgets(FTree) delete [$widgets(FTree) nodes root] 

    set installed_title "Installed Families"
    set foo [$widgets(FTree) insert end root install_folder -text $installed_title  -image [Bitmap::get folder] -open 0]
	$widgets(FTree) configure -redraw 1

    set family_list [get_family_list]

    set i 0
    foreach family $family_list {

	$widgets(FTree) insert end install_folder  family$i -text "$family" -image [Bitmap::get file] -open 1
	$widgets(FTree) configure -redraw 1

	incr i
    }

    update
}

# ----------------------------------------------------------------
#
proc ::qpm::install_ui::on_install_package_dlg {} {
#
# Description:	Dialog Box to open project
#
# ----------------------------------------------------------------

	variable package_info
	variable app_name

	set typelist {
		{"TXT Files" {".txt"}}
		{"ZIP Files" {".zip"}}
		{"TAR Files" {".tar"}}
		{"QAR Files" {".qar"}}
	}

	set package_info(name) [tk_getOpenFile -filetypes $typelist -title "Open Device Package File"]
	if { $package_info(name) == "" } {
	    ::qpm::install_ui::print_msg -debug "No project was open"
	} else {

	    ::qpm::install_ui::on_generate

	    ::qpm::install_ui::update_family_list
	}

}

# ----------------------------------------------------------------
#
proc ::qpm::install_ui::on_generate {} {
#
# Description:	Make default assignments
#
# ----------------------------------------------------------------

    variable package_info
    global widgets

    set ::qpm::install_ui::progress_text "Generating..."
    $widgets(mainframe) showstatusbar progression
    set ::qpm::install_ui::progress_variable 10


    ::qpm::install_ui::print_msg -info "========================================="
    ::qpm::install_ui::print_msg -info "Installing $package_info(name)"
    ::qpm::install_ui::print_msg -info ""

    # Get location of Quartus device files
    # ------------------------------------
    # Note that we should really ask Quartus for it, but until we can do this
    # we need to build it assuming <quartus root>/common/devinfo

    # First Get Quartus EXE location. This is something like d:/quartus/bin
    set bin_path $::quartus(binpath)
    ::qpm::install_ui::print_msg -info "Quartus Bin Path is : $bin_path"

    # Now, remove the /bin
    set root_path [file dirname $bin_path]
    ::qpm::install_ui::print_msg -info "Quartus Root Path is : $root_path"

    # Now get to device location. Assume /common/devinfo
    set devinfo_path [file join $root_path common devinfo]
    ::qpm::install_ui::print_msg -info "Quartus DevInfo Path is : $devinfo_path"

    # Check path is a DirName
    if [file isdirectory $devinfo_path] {
	::qpm::install_ui::print_msg -info "DevInfo is directory (Excellent)"
    } else {
	::qpm::install_ui::print_msg -error "DevInfo is NOT a directory"
	return
    }

    ::qpm::install_ui::print_msg -info "Installation may take a few minutes ..."

    update
    
    # Now we are ready to start installation
    # -------------------------------------
    
    # First, copy package to devinfo (note we are assuming we have write permision. TODO: don't)
    set new_package_file [file join $devinfo_path [file tail $package_info(name)]]
    file copy -force $package_info(name) $new_package_file

    ::qpm::install_ui::print_msg -debug [string tolower [file extension $package_info(name)]] 
    switch [string tolower [file extension $package_info(name)]]  {
	.tar {
	    set original_pwd [pwd]
	    cd $devinfo_path
	    catch {exec tar -xf $new_package_file} result
	    ::qpm::install_ui::print_msg -info "$result"
	    cd $original_pwd
	}
	.qar {
	    ::qpm::install_ui::print_msg -info "QAR file unsupported"
	}
	.zip {
	    ::qpm::install_ui::print_msg -info "ZIP file unsupported"
	}
	.txt {
	    ::qpm::install_ui::print_msg -info "You don't really think a TXT has anything to install, right?"
	}
    }


    file delete -force $new_package_file

    ::qpm::install_ui::print_msg -info "Installation completed"
    ::qpm::install_ui::print_msg -info "========================================="

    set ::qpm::install_ui::progress_variable 100
    set ::qpm::install_ui::progress_text "Done"

}	


#############################################################################
##  Procedure:  main
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      The main function.
proc ::qpm::install_ui::main {} {

	set debug_name "::qpm::install_ui::main()"

	set exit_qinstall_gui 0
	::qpm::install_ui::start_ui
	# And wait to exit
	vwait exit_qinstall_gui
}
