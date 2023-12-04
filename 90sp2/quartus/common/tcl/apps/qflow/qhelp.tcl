
###################################################################################
#                                                                                 #
# File Name:    qhelp.tcl                                                	  #
#                                                                                 #
# Version:      1.1                                                               #
#                                                                                 #
# Summary:      This Tk script as a simple Graphical User Interface to browse     #
#               the command-line and Tcl on-line help                             #
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
#                     quartus_sh --qhelp                                          #
#                                                                                 #
#                                                                                 #
###################################################################################

# Only qflow exes can interpret this script
if [info exist quartus] {
	if { ![string equal $quartus(nameofexecutable) quartus_sh] } {
        set msg "QHelp should be invoked from the command line.\nusage: quartus_sh --qhelp"
		puts $msg
		catch { tk_messageBox -type ok -message $msg -icon error -title "QHelp Error"}
		return
	}
} else {
    set msg "QHelp should be invoked using the Quartus II Shell.\nusage: quartus_sh --qhelp"
	puts $msg
	catch { tk_messageBox -type ok -message $msg -icon error -title "QHelp Error"}
	exit -1
}

# Initialize TK library
init_tk



package require BWidget

###########################################################################
# getExtraArgs
#
# getExtraArgs returns extra arguments to pass to cmd line.
#  
###########################################################################

proc getExtraArgs { } {

	set extra_args ""
	if {$::quartus(internal_use)} {
		set extra_args "--ini=qexe_internal_use=on"
	} elseif {$::quartus(advanced_use)} {
		set extra_args "--ini=tcl_advanced_mode=on"
	}
	return $extra_args
}

###########################################################################
# getHelp
#
# getHelp responds to clicks on the tree widget to populate the list box
# with options, packages, or other help topics, and the message window with
# exe, api information, or other help detail.
# While it runs, it locks out other mouse clicks by setting a global variable.
#  
###########################################################################

proc getHelp { tree list msg node } {

    global scriptStatus cache d_title mainframe

    set ret 0

    # If the script is not not idle, return
    if { ![string equal -nocase $scriptStatus "Status"] } {
	return
    }

    # Because someone clicked on an item in the tree, we can enable
    # the export help to file menu entry
    $mainframe setmenustate export enabled

    # If someone clicked on any of the top topic folders, return
    if { [string equal -nocase [$tree parent $node] "root"] } {
	$tree selection set $node
	update
	return
    }

    # These three commands help provide visual feedback during the export
    # process by highlighting the selected node and scrolling the tree to
    # make it visible
    $tree selection set $node
    update
    $tree see $node

    # Set the title of the list. There's no title for other help topics
    switch -exact -- [$tree parent $node] {
	cmd {
	    $d_title configure -text "[$tree itemcget $node -text] command-line options"
	}
	tcl {
	    $d_title configure -text "::quartus::[$tree itemcget $node -text] package commands"
	}
	hlp {
	    $d_title configure -text ""
	}
    }
#    if {[string equal -nocase [$tree parent $node] "cmd"]} {
#	$d_title configure -text "[$tree itemcget $node -text] command-line options"
#    } elseif {[string equal -nocase [$tree parent $node] "tcl"]} {
#	$d_title configure -text "::quartus::[$tree itemcget $node -text] package commands"
#    }
#
    # Check to see if we already have the information cached
    # The llength check makes sure there are options or commands
    # that exist in the list window. This window might not contain
    # anything if there's no valid license, and if there wasn't a valid
    # license, retry instead of relying on cached license error message
    if { ![info exists cache(description,$node)] ||  \
	     [expr { [info exists cache(options,$node)] && \
			 0 == [llength $cache(options,$node)]}]} {
	set ret [ runHelp $node [$tree parent $node] simple $msg \
		     [$tree itemcget $node -text] ]
    }

    # If runHelp didn't have any errors...
    if { 2 != $ret } {

	# Delete any text in the help text area and put in the new text
	$msg delete 1.0 end 
	$msg insert end $cache(description,$node) black

	# Delete any items in the list box...
	$list delete [$list items]

	# ... and put in the new items
	if { [info exists cache(options,$node)] } {
	    set count 0
	    foreach o $cache(options,$node) {
		$list insert end [$tree itemcget $node -text]:$count -text \
		    "$o" -fill black
		incr count
	    }

		$list see [lindex [$list items] 0]
	}
    }
}

###########################################################################
# getMoreHelp
#
# getMoreHelp responds to clicks on the listbox widget to populate the 
# message window with detailed help information about the option or package
#  
###########################################################################

proc getMoreHelp { tree list msg node} {

    global cache scriptStatus
    
    set ret 0

    # If the script is not not idle, return
    if { ![string equal -nocase $scriptStatus Status] } {
	return
    }

    # These three commands help provide visual feedback during the export
    # process by highlighting the selected node and scrolling the list to
    # make it visible
    $list selection set $node
    update
    $list see $node

    # Check to see if we already have the text
    if { ![info exists cache(description,$node)] } {
	set ret [ runHelp $node [$tree parent [$tree selection get]] detail \
		      $msg [$tree itemcget [$tree selection get] -text] \
		      [$list itemcget $node -text] ]
    }

    # If runHelp didn't have any errors...
    if {2 != $ret} {

	# Delete any text in the help text area and put in the new text
	$msg delete 1.0 end 

	# If it's Tcl help, run it through the filter to allow the user to
	# control the sections that get displayed (set through the option
	# menu. If it's not Tcl help, just insert it.
	if { [string equal "tcl" [getType $tree [$tree selection get]]] } {
	    $msg insert end [filterTclHelpText $cache(description,$node)] black
	} else {
	    $msg insert end $cache(description,$node) black
	}
    }
}

###########################################################################
# runHelp
#
# runHelp dispatches different commands based on exe or TCL API items,
# and the level of detail required.
# While it runs, it locks out other mouse clicks by
# setting a global variable. The click-handling routines check this
# variable.
# It returns 2 if it couldn't run a command
#
###########################################################################

proc runHelp { node which detail msg cmd args } {

    global flag scriptStatus done cache i_tree
	global quartus cache_changed

    set flag run
    set done 0

    set scriptStatus "Status: Processing Command"
    . configure -cursor watch

    switch -exact -- $which {

	cmd {
	    # We're running a command-line executable

	    if { [string equal -nocase $detail "simple"] } {
		# Just looking for the simple overview
	    
		if [catch {open "|[file join $quartus(binpath) $cmd] -?"} input] {
		    $msg insert end $input\n black
		    set done 2
		} else {
		    set cache(description,$node) ""
		    set cache(options,$node) {}
		    fileevent $input readable [list GetExeInfo $node $input ]
		}
	    } else {
		# Looking for detail

		if {[regexp {^[-]{1,2}([\w]*)} [lindex $args 0] match opt]} {
		    
		    if {[catch {open "|[file join $quartus(binpath) $cmd] [getExtraArgs] --help=$opt"} input]} {
			$msg insert end $input\n black
			set done 2
		    } else {
			set cache(description,$node) ""
			fileevent $input readable [list GetDetail $node $input]
		    }
		}
	    }
	}

	tcl {
	    # We're running a tcl command

	    if { [string equal -nocase $detail "simple"] } {
		# Just looking for the simple overview

		if [catch {open "|[file join $quartus(binpath) [$i_tree itemcget $node -data]] [getExtraArgs] --tcl_eval help -pkg $cmd"} input] {
		    $msg insert end $input\n black
		    set done 2
		} else {
		    set cache(description,$node) ""
		    set cache(options,$node) {}
		    fileevent $input readable [list GetTclInfo $node $input ]
		}
	    } else {
		# Looking for the whole thing
					   
		# If the line is an option, run it to get the help to print
		if {[regexp {^([\w]*)} [lindex $args 0] match pkg]} {
	    
		    if [catch {open "|[file join $quartus(binpath) [$i_tree itemcget [$i_tree selection get] -data]] [getExtraArgs] --tcl_eval package require ::quartus::$cmd\; $pkg -long_help"} input] {
			$msg insert end $input\n black
			set done 2
		    } else {
			set cache(description,$node) ""
			fileevent $input readable [list GetDetail $node $input]
		    }
		}
	    }
	}

	hlp {
	    # We're running an other help topic
	    if [catch {open "|[file join $quartus(binpath) [$i_tree itemcget $node -data]]"} input ] {
		$msg insert end $input\n black
		set done 2
	    } else {
		set cache(description,$node) ""
		fileevent $input readable [list GetHlpInfo $node $input]
	    }
	}
    }
    # end of switch statement

    if { 2 != $done } {
	set cache_changed 1
	vwait done
    }

    # We're done processing, so go back to "Status" so we can process mouse
    # clicks again
    set scriptStatus "Status"
    . configure -cursor ""

    return $done
}

###########################################################################
# getExeInfo
#
# getExeInfo reads the input stream from the command-line executable and
# populates the cache with the description and command-line options
#
###########################################################################

proc GetExeInfo { node inp } {

    global cache flag done

    if { [eof $inp] } {
	catch {close $inp}
	set done 1
	return
    } else {
	gets $inp line

	# Skip any DEBUG lines
	if { [regexp -nocase {^DEBUG} $line] } {
	    return
	}

	# State machine to parse through the different sections of the 
	# help and split the information into the appropriate places
	switch -exact -- $flag {
	    run {
		# Look for other sections and append lines
		if {[regexp {^Options:} $line]} {
		    set flag options
		} else {
		    if {[regexp {^Usage:} $line]} {
			set flag usage
		    }
		    append cache(description,$node) $line\n
		}
	    }
	    usage {
		if {[regexp {^[a-z_]+\s+\[*([-]+.*)\]*$} $line match option]} {
		    lappend cache(options,$node) $option
		}
		if {[regexp {^Description:} $line]} {
		    set flag run
		}

		# This if/else condition currently deals with quartus_stp
		# which has no description section
		if {[regexp {^Options:} $line]} {
		    set flag options
		} else {
		    append cache(description,$node) $line\n
		}
	    }
	    options {
		# Add things to the array for future list box population
		if {[regexp {^\s+([-]+.*)$} $line match option]} {
		    lappend cache(options,$node) $option
		}

	    }

	} 
	# End of switch statement
    }
}

###########################################################################
# GetTclInfo
#
# getTclInfo reads the input stream from quartus_sh and
# populates the cache with the description and package commands
#  
###########################################################################

proc GetTclInfo { node inp } {

    global cache flag done

    if { [eof $inp] } {
	catch {close $inp}
	set done 1
	return
    } else {
	gets $inp line

	# Skip any DEBUG lines
	if { [regexp -nocase {^DEBUG} $line] } {
	    return
	}

	# State machine to parse through the different sections of the 
	# help and split the information into the appropriate places
	switch -exact -- $flag {
	    run {
		# Look for other sections and append lines
		if {[regexp {^Tcl Commands:} $line]} {
		    set flag commands
		} else {
		    append cache(description,$node) $line\n
		}
	    }
	    commands {
		# Add things to the array for future list box population
		if {[regexp {^\s+([\w]*)$} $line match option]} {
		    lappend cache(options,$node) $option
		}
	    }
	}
	# End of switch statement
    }
}

###########################################################################
# GetHlpInfo
#
# GetHlpInfo reads the input stream from quartus_sh and
# populates the cache with the description and package commands
#  
###########################################################################

proc GetHlpInfo { node inp } {

    global cache done

    if [eof $inp] {
	catch {close $inp}
	set done 1
	return
    } else {
	gets $inp line

	# Skip any DEBUG lines
	if {[regexp -nocase {^DEBUG} $line]} {
	    return
	}

	append cache(description,$node) $line\n
    }
}

###########################################################################
# getDetail
#
# getDetail reads the input stream for both the command-line executable
# option help and TCL package command help and populates the cache
#
###########################################################################

proc GetDetail { node inp } {

    global cache done

    if [eof $inp] {
	catch {close $inp}
	set done 1
	return
    } else {
	gets $inp line

	# Skip any DEBUG lines
	if {[regexp -nocase {^DEBUG} $line]} {
	    return
	}

	append cache(description,$node) $line\n
    }
}

###########################################################################
# modList
#
# modList toggles the folder image when the tree is opened or closed
# idx is the list index to use - the open command passes in 1 and the 
# close command passes in 0
###########################################################################

proc modList { idx tree node } {
	$tree itemconfigure $node \
	    -image [Bitmap::get [lindex {folder openfold} $idx]]
}

###########################################################################
# exitApp
#
# exitApp works with vwait to quit out of the script. It will attempt to
# write out the cache variable to disk.
#
###########################################################################

proc ExitApp {} {

    global quitting mainframe

    writeCachedData [ cachedDataFileName ]

    destroy $mainframe
    set $quitting 1

    exit
}

###########################################################################
# ShowAbout
#
# ShowAbout displays an About dialog
#
###########################################################################

proc ShowAbout {} {

    global quartus

    MessageDlg .about -type ok -title "About QHelp" \
	-message "QHelp $quartus(version)\n\n$quartus(copyright)"

}
###########################################################################
# writeCachedData
#
# writeCachedData saves out the cache data structure to a file
#
###########################################################################

proc writeCachedData { cfile } {

    global cache dont_write_cache env cache_changed

    # If data in the cache is changed, this variable is set too. If you 
    # don't click anything new then there's no need to write the file out
    # again
    if { 1 != $cache_changed } {
	return
    }

    # Can be set manually in the script for development purposes
    if { 1 == $dont_write_cache } {
	return 
    }

    # You can also set an environment variable to prevent it from writing
    if {[info exists env(QUARTUS_DONT_WRITE_CACHE)]} {
	if { 1 == $env(QUARTUS_DONT_WRITE_CACHE) } {
	    return
	}
    }

    if { 0 == [string length $cfile] } {
	return
    }

    if {![catch {open $cfile w} cacheFile]} {
	foreach a [array names cache] {
	    catch {puts $cacheFile [list set cache([list $a]) $cache($a)]\n}
	}
	catch {close $cacheFile}
    }
}

###########################################################################
# readCachedData
#
# readCachedData restores the cache data structure from a file
# If you specify a command-line argument of delete, it fakes an 
# unsuccessful read so the cache will be reinitialized.
# It returns 0 if the read was successful, 1 if it was not
#
###########################################################################

proc readCachedData { cfile } {

    global cache quartus q_args hi_text

    if { 0 == [string length $cfile ] } {
	return 1
    }

    if { [string length [lindex $q_args 0]] } {
	return 1
    }

    if {[string compare -nocase [get_ini_var -name qhelp_clear_cache] on] == 0} {
		post_message "Clearing the cache since INI variable \"qhelp_clear_cache\" is turned on"
		return 1
    }

    if {[file readable $cfile]} {
	if {[catch { source $cfile }]} {
	    # There was an error reading it in
	    return 1
	} else {
	    # Compare the version string in the cache with $quartus(version)
	    # If the versions are different, return unsuccessful so the cache
	    # will be reinitialized
	    if {![info exists cache(version)]} {
		return 1
	    }
	    if { [ string equal -nocase $quartus(version) $cache(version)] } {
		return 0
	    } else {
		return 1
	    }
	}
    } else {
	return 1
    }
}

###########################################################################
# cachedDataFileName
#
# cachedDataFileName returns the file name where cached data might be
# It puts it in ~/.altera.quartus on UNIX and $TEMP or $TMP if it exists on
# Windows
#
###########################################################################

proc cachedDataFileName {} {

    global tcl_platform env

    if { [string equal -nocase $tcl_platform(platform) windows] } {
	if { [info exists env(TEMP)] } {
	    return [file join $env(TEMP) ihelp.cache]
	} elseif { [info exists env(TMP)] } {
	    return [file join $env(TMP) ihelp.cache]
	}
    } elseif { [string equal -nocase $tcl_platform(platform) unix] } {
	return [file join ~ .altera.quartus ihelp.cache]
    }

    return ""
}

###########################################################################
# sortTclAPI
#
# sortTclAPI is a custom sort function to put the packages in alphabetical
# order, given that they're stored in a data structure with the executable
# to run for help
#
###########################################################################

proc sortTclAPI { a b } {

    set afirst [lindex $a 0]
    set bfirst [lindex $b 0]
    set res [string compare $afirst $bfirst]
    if {$res != 0} {
	return $res
    } else {
	return [string compare $a $b]
    }
}

###########################################################################
# toggleFolders
#
# toggleFolders opens and closes folders in the tree view in response
# to double-clicks
#
###########################################################################

proc toggleFolders { tree node } {

    set parent [$tree parent $node]
    if { ![string equal -nocase $parent root] } {
	return
    }

    set isopen [$tree itemcget $node -open]
    $tree itemconfigure $node -open [lindex { 1 0 } $isopen ]
    $tree itemconfigure $node \
	-image [ Bitmap::get [lindex { openfold folder } $isopen ] ]
}

###########################################################################
# flyMenu
#
# flyMenu displays the right-click pop-up menu for exporting help to a file
#
###########################################################################

proc flyMenu { tree pm x y selected } {

    global mainframe

    # Right-clicking on an item will enable the export to text file 
    # item in the File menu
    $mainframe setmenustate export enabled

    $tree selection set $selected
    set sel_text [$tree itemcget $selected -text]
    $pm entryconfigure 0 -label "Export to text file..."
    tk_popup $pm $x $y
}

###########################################################################
# exportHelp
#
# exportHelp manages saving help topics to a file specified by the user.
# The export process can be cleanly interrupted
#
###########################################################################

proc exportHelp { top tree } {

    global d_list hi_text cache exp_prg exit_exp export_name

    # The selected node
    set selected [$tree selection get]

    # If there are no selected nodes, return without doing anything
    if { 0 == [llength $selected] } {
	return
    }

    # Children of the selected node
    set children [$tree nodes $selected]

    # If there are children -- if the user clicked on a folder -- run the
    # export on those nodes. If there aren't children, the user clicked on
    # a single exe/api/help topic
    if { [llength $children] } {
	set nodes $children
    } else {
	set nodes $selected
    }


    # How many things are there to export help for?
    set num_steps [llength $nodes]
    # Which one are we on?
    set on_step 0
    # Global progress variable
    set exp_prg 0
    # Not exiting yet
    set exit_exp 0
    # What are we exporting? Tcl, cmd, or hlp info?
    set export_type [getType $tree $selected]

    set export_name "Exporting help for [$tree itemcget $selected -text]"

    set ftypes {
	{ {Text files} { .txt} }
	{ {All files}  *       }
    }

    set fname [tk_getSaveFile -parent $top -filetypes $ftypes -initialfile \
		   "[string map { \u0020 _ } [$tree itemcget $selected -text]].txt"]
    if { [string length $fname] } {

	if { [catch { open $fname w } fileid ] } {
	    MessageDlg $top.mb -type ok -icon error \
		-title "Error" -message "Error: $fileid"
	    return
	} else {

	    # Open all the subtrees of the selected item
	    if { 1 != $num_steps } {
		$tree opentree $selected 0
	    }

	    set pd [ ProgressDlg .pd -variable exp_prg \
			 -title "Export Progress" \
			 -stop "Stop Export" \
			 -textvariable export_name \
			 -command [list set exit_exp 1 ] \
			 -width 50]

	    # If we're exporting other help topics, we know the maximum
	    # up front.
	    if {[string equal "hlp" $export_type]} {
		$pd configure -maximum $num_steps
	    }

	    # Walk through $nodes and do the help
	    foreach node $nodes {

		# Gracefully stop if the dialog is destroyed
		if { $exit_exp } {
		    break
		}

		getHelp $tree $d_list $hi_text $node

		catch {

		    # Add a custom header to "other help topics" pages
		    # because they're inconsistent in what they have
		    if { [string equal "hlp" $export_type] } {
			puts $fileid "Help topic: [$tree itemcget $node -text]"
			puts $fileid "----------------------------\n"
		    }

		    puts $fileid $cache(description,$node)

		    switch -exact -- $export_type {
			tcl {
			    puts $fileid "Tcl Commands:\n-------------\n"
			}
			cmd {
			    puts $fileid "Options:\n--------"
			}
			hlp {
			}
		    }
		    # End of switch statement

		}

		# Get the list of command-line exe options or Tcl commands
		set opts [$d_list items]

		foreach opt $opts {
		    catch {puts $fileid "\t[$d_list itemcget $opt -text]"}
		}


		switch -exact -- $export_type {
		    tcl {
			catch {puts $fileid "\n\nQuartus II $cache(version)"}
		    }
		    cmd {
			catch {puts $fileid "\n\nDetailed Option Help:\n---------------------\n"}
		    }
		    hlp {
		    }
		}

		# If the export is for tcl or cmd, reconfigure the maximum
		# for the progress bar and rejigger the progress variable
		if { [string equal "hlp" $export_type] } {

		    set exp_prg $on_step
		} else {

		    # Reset the maximum of the progress bar so the option-
		    # printing loop can do a by-one-increment
		    $pd configure -maximum \
			[expr {$num_steps * [llength $opts] } ]
		    set exp_prg [expr {$on_step * [llength $opts]}]
		}

		# Get more help on each option or command
		foreach opt $opts {

		    # Gracefully stop if the dialog is destroyed
		    if { $exit_exp } {
			break
		    }

		    getMoreHelp $tree $d_list $hi_text $opt
		    incr exp_prg

		    catch {
			if { [string equal "tcl" $export_type] } {
			    puts $fileid \u000C
			    puts $fileid [$d_list itemcget $opt -text]\n
			}
			puts $fileid $cache(description,$opt)
			if { [string equal "tcl" $export_type] } {
			    puts $fileid "Quartus II $cache(version)\n"
			} else {
			    puts $fileid "----------------------------------------"
			}
		    }

		}

		if { [string equal "hlp" $export_type] } {
		    puts $fileid "Quartus II $cache(version)\n"
		}

		# Add a ^L to force a page break before the next topic
		if { 1 != $num_steps } {
		    catch {puts $fileid \u000C}
		}

		incr on_step
	    }

	    if { $exit_exp } {
		catch { puts $fileid "Help export cancelled - this file may be incomplete" }
	    }
	    catch {close $fileid}

	    # Get rid of the progress dialog
	    destroy $pd 
	}
    }
}


###########################################################################
# getType
# 
# getType returns one of the string cmd, tcl, or hlp based on the branch 
# of the tree that an item is highlighted in
#
###########################################################################

proc getType { tree sel } {

    set parent [$tree parent $sel]

    if {[string equal "root" $parent]} {
	return $sel
    } else {
	return $parent
    }

}

###########################################################################
# initDisplayOptions
# 
# initDisplayOptions transfers values from the display_options variable
# to the cache data structure. This is done to initialize the cache if no
# data file can be found to read in, and also so that the Option menu
# entries will have valid variables to point to
#
###########################################################################

proc initDisplayOptions { } {

    global cache display_options

    foreach option [array names display_options] {
	set cache($option) $display_options($option)
    }
}


###########################################################################
# DisplayOptionClicked
# 
# DisplayOptionClicked is called whenever the Tcl Help display options
# are changed
#
###########################################################################

proc DisplayOptionClicked { } {

    global cache_changed i_tree d_list hi_text

    if { [string equal "tcl" [getType $i_tree [$i_tree selection get]]] } {
	if { [llength [$d_list selection get]] } {
	    getMoreHelp $i_tree $d_list $hi_text [$d_list selection get]
	}
    }

    set cache_changed 1
}

###########################################################################
# filterTclHelpText
# 
# filterTclHelpText walks through a string of text from the help output to
# allow for filtering out certain parts of the help, specifically the
# description, examples, and return values. This procedure uses a
# convoluted way of working line-by-line instead of splitting on \n 
# because you shouldn't use list operations on arbitrary data.
#
###########################################################################

proc filterTclHelpText { input } {

    global cache

    set flag 1
    set section "normal"

    while { $flag } {

	set split_index [string first "\n" $input]

	# If there are no more new-lines in the string,
	# set line to the string. Also last time through the loop
	if { $split_index == -1 } {

	    set line $input
	    set flag 0
	} else {

	    set line [string range $input 0 $split_index]
	    set input [string replace $input 0 $split_index]
	}

	# State machine to keep track of what section of the detailed info
	# we're in
	switch -regexp -- $line {
	    "^Description:" {
		set section "description"
	    }
	    "^Example Usage:" {
		set section "examples"
	    }
	    "^Return Value:" {
		set section "return_val"
	    }
	}

	# Append the string to return it only if the appropriate display 
	# option from the Options menu is checked
	if { [string equal $section "description"] && $cache(display_description) == 1 } {
	    append to_return $line
	} elseif { [string equal $section "examples"] && $cache(display_examples) == 1 } {
	    append to_return $line
	} elseif { [string equal $section "return_val"] && $cache(display_return_val) == 1 } {
	    append to_return $line
	} elseif { [string equal $section "normal"] } {
	    append to_return $line
	}

    }

    return $to_return
}

###########################################################################
#
# Variable declarations
#
###########################################################################

# Window title
set wm_title "Quartus II Command-Line and Tcl API Help"

# A list of each command-line executable
set quartus_cmds { quartus_map quartus_fit quartus_tan quartus_drc \
		       quartus_asm quartus_cdb quartus_eda quartus_pgm \
		       quartus_cpf quartus_sim quartus_sh \
		       quartus_stp quartus_pow quartus_sta \
		       quartus_si quartus_jli quartus_jbcc }

array set quartus_hlp {
    tcl "quartus_sh --help=tcl" \
	arguments "quartus_sh --help=arguments" \
	makefiles "quartus_sh --help=makefiles" \
	"return codes" "quartus_sh --help=return_codes" \
	examples "quartus_sh --tcl_eval help -examples" \
	"quartus array" "quartus_sh --tcl_eval help -quartus" \
	"TimeQuestInfo array" "quartus_sh --tcl_eval help -timequestinfo" \
    }

# Status string for Main window also functions as global variable
# to lock out click handling
set scriptStatus "Status"

# Cache structure to hold help information
array set cache {}

# Flag for blocking on command execution
set done 0

# Flag to quit the program via vwait
set quitting 0

# Flag to prevent writing the cache data structure to disk on exit
set dont_write_cache 0

# Flag to skip writing the cache data structure to disk on exit
# if it hasn't changed during this run
set cache_changed 0

# Flag to stop export process
set exit_exp 0

# Display tree folders open (1) or closed (0)?
set open_status 1

# Font specification
set text_font {Courier 10}

# Widget sizes
array set widget_sizes {
    wm_width    600 \
    wm_height   600 \
    msg_height  10 \
    msg_width   80 \
    list_width  20 \
    tree_width  20 \
}

# Which options will we show by default? Names must match the checkbutton
# variables in the descmenu variable
array set display_options {
    display_description 1
    display_examples 1
    display_return_val 0
}


###########################################################################
#
# Create and assemble the GUI
#
###########################################################################

set descmenu {
    "&File" all file 0 {
	{command "&Export to text file..." export "Export to text file" {} \
	     -command { exportHelp $mainframe $i_tree } -state disabled }
	{separator}
	{command "E&xit" {} "Exit" {} -command ExitApp}

    }
    "&Options" all options 0 {
	{checkbutton "Show Tcl &Description" {} "Show Tcl Description" {} \
	     -variable cache(display_description) -command \
	     DisplayOptionClicked }
	{checkbutton "Show Tcl &Examples" {} "Show Tcl Examples" {} \
	     -variable cache(display_examples) -command \
	     DisplayOptionClicked }
	{checkbutton "Show Tcl &Return Values" {} "Show Tcl Return Values" {} \
	     -variable cache(display_return_val) -command \
	     DisplayOptionClicked }
    }
    "&Help" all help 0 {
	{command "&About QHelp" {} "About QHelp" {} -command ShowAbout}
    }
}

set mainframe [MainFrame .mainframe \
                   -menu         $descmenu ]
$mainframe addindicator -textvariable scriptStatus
$mainframe addindicator -text "Quartus II $quartus(version)"
set frame [$mainframe getframe]
set mainpane [PanedWindow $frame.mp -side left]

# Adds and splits the top pane
set tp [PanedWindow [$mainpane add -weight 1].mp -side top]

# Adds the left (info) pane
set ip [$tp add -weight 1]
set i_title [TitleFrame $ip.dt -text "Help Topics"]
set sw [ScrolledWindow [$i_title getframe].sw -auto both]
set i_tree [Tree $sw.tree -relief sunken -showlines true \
		-redraw 1 -background white  \
		-opencmd "modList 1 $sw.tree" \
		-closecmd "modList 0 $sw.tree" \
	       ]
$sw setwidget $i_tree
pack $ip $i_title $sw $i_tree -fill both -expand yes

# Create the pop-up export to file menu
set pm [menu .mb -tearoff 0]
$pm add command -label "Export help" -command "exportHelp $mainframe $i_tree"

# Adds the right (detail) pane
set dp [$tp add -weight 1]
set d_title [TitleFrame $dp.dt -text ""]
set sw [ScrolledWindow [$d_title getframe].sw -auto both]
set d_list [ListBox $sw.ht -selectmode single -multicolumn 0 \
		-padx 2 -background white\
		-font $text_font -foreground black ]
$sw setwidget $d_list
pack $sw $dp $d_title $d_list -fill both -expand yes

# Add and populate the Help Information Pane
set hip [$mainpane add -weight 1]
set hi_title   [TitleFrame $hip.ht -text "Help Details"]
set sw [ScrolledWindow [$hi_title getframe].sw -auto both]
set hi_text [text $sw.ht -relief sunken -font $text_font \
		  -background white \
		 -foreground black]
$sw setwidget $hi_text
pack $sw $hip $hi_title $hi_text -fill both -expand yes

pack $tp -fill both -expand yes
pack $mainpane -fill both -expand yes
pack $mainframe -fill both -expand yes

# Bind mouse-clicks
$i_tree bindText <Button-1> "getHelp $i_tree $d_list $hi_text"
$i_tree bindText <Double-1> "toggleFolders $i_tree"
$d_list bindText <Button-1> "getMoreHelp $i_tree $d_list $hi_text"
$i_tree bindText <Button-3> "flyMenu $i_tree $pm %X %Y"

# bind keystrokes to move around
$i_tree bindText <Tab> {tk_focusNext %W}
$i_tree bindText <Shift-Tab> {tk_focusPrev %W}
$d_list bindText <Tab> {tk_focusNext %W}
$d_list bindText <Shift-Tab> {tk_focusPrev %W}
bind $hi_text  <Tab> { focus [tk_focusNext %W]; break }
bind $hi_text  <Shift-Tab> { focus [tk_focusPrev %W]; break }

bind $d_list <Up> {
    set s [$d_list selection get]
    set si [lsearch [$d_list items] $s]
	if {$si > 0} {
		incr si -1
	    $d_list selection set [lindex [$d_list items] $si]
		getMoreHelp $i_tree $d_list $hi_text [$d_list selection get]
	}
}
bind $d_list <Down> {
    set s [$d_list selection get]
    set si [lsearch [$d_list items] $s]
    set mi [expr { [llength [$d_list items]] - 1 } ]
    if { $si < $mi  } { incr si }
    $d_list selection set [lindex [$d_list items] $si]
	getMoreHelp $i_tree $d_list $hi_text [$d_list selection get]
}

# Make sure we can close the App when clicking 'X'
bind $mainframe <Destroy> { ExitApp }

###########################################################################
#
# Populate the GUI with command-line executable names and TCL packages
#
###########################################################################

# Throw in two top-level elements in the tree
$i_tree insert end root cmd -text "Command-Line Executables" \
    -image [Bitmap::get folder] -open $open_status -drawcross auto \
    -font $text_font -fill black
$i_tree insert end root tcl -text "Tcl API Packages" \
    -image [Bitmap::get folder] -open $open_status -drawcross auto \
    -font $text_font -fill black
$i_tree insert end root hlp -text "Other Help Topics" \
    -image [Bitmap::get folder] -open $open_status -drawcross auto \
    -font $text_font -fill black

# Add in the exe names and package names
set count 0
foreach c [lsort -ascii $quartus_cmds] {
	$i_tree insert end "cmd" t:$count -text $c -image [Bitmap::get file] \
	    -drawcross never -font $text_font -fill black
	incr count
}

foreach a [lsort -command sortTclAPI $quartus(package_table)] {
	if { ( "generic" eq [lindex $a 2] ) \
		 || \
		 ( ("advanced" eq [lindex $a 2]) \
		   && \
		   ($quartus(advanced_use) || $quartus(internal_use)) ) \
		 || \
		 ( ("hidden" eq [lindex $a 2]) \
		   && \
		   ($quartus(internal_use)) ) } {
    $i_tree insert end "tcl" t:$count -text [lindex $a 0] \
	-image [Bitmap::get file] -drawcross never -font $text_font \
	-data [lindex $a 1] -fill black
	incr count
	}
}

foreach h [lsort -dictionary [array names quartus_hlp]] {
    $i_tree insert end "hlp" h:$count -text $h -data $quartus_hlp($h) \
	-image [Bitmap::get file] -drawcross never -font $text_font \
	-fill black
    incr count
}

###########################################################################
#
# Delete the cache file if the user wants to (specify "delete" on the
# command line as an argument)
# Read in previously cached data from file
#
###########################################################################

foreach arg $q_args {
    if { -1 != [string first $arg "delete"] } {
	# Get the cache file name if we try to delete it
	set fn [ cachedDataFileName ]
	if { 0 < [string length $fn] } {
	    # If a name is returned, try to delete it.
	    if { [catch { file delete $fn } err ]} {
		$hi_text insert end "Could not delete help cache file $fn"
		$hi_text insert end $err
	    } else {
		$hi_text insert end "Successfully deleted help cache file $fn"
	    }
	}
    }
}

# readCachedData returns 1 if it was not successful
if { [ readCachedData [ cachedDataFileName ] ] } {
    unset cache
    array set cache [list version $quartus(version) ]
    initDisplayOptions
}


###########################################################################
#
# Size the GUI
#
###########################################################################

wm geom . ${widget_sizes(wm_width)}x${widget_sizes(wm_height)}
$hi_text configure -height $widget_sizes(msg_height)
$d_list configure -width $widget_sizes(list_width)
$i_tree configure -width $widget_sizes(tree_width)


###########################################################################
#
# Display the GUI and wait to quit
#
###########################################################################

wm title . $wm_title
wm deiconify .
raise .
focus -force .

vwait $quitting
