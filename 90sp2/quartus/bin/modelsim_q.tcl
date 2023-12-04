# ADD Quartus MENU TO WAVE WINDOW
# This Tcl/Tk file will add a "Quartus" menu (and right mouse button
# popup window) to the Wave window. 
# ***From this menu, individual
# or multiple signal attributes can be changed. 
# Saving of these settings is not supported but since the
# ".signals.tree itemconfig ..." command is echoed, they could 
# be used in conjunction with the "environment" command to
# to configure the signals each time ModelSim is run.

# Setting the following variable will cause the procedure 
# "AddSignalsPropMenu" to be called every time a ModelSim 
# Signals window is created. It will be called with a single 
# argument which is the name of the Signals window (".signals" ,
# ".signals1" , ".signals2"  etc).

set PrefWave(user_hook) "AddQuartusMenu"

# source the Quartus Tcl client

regsub -all {\\} $env(QUARTUS_ROOTDIR) / quartus_root

if [catch {source "$quartus_root/bin/tcl_client.tcl"} result] {
	puts stderr "source result is $result"
} 

proc AddQuartusMenu {wname {for_popup_menu ""}} {
	bind $wname.tree <ButtonPress-3> \
		"SignalsPopup $wname.tree %x %X %y %Y"
	if {$for_popup_menu == ""} {
		set menu_name "quartus"
		add_menu $wname $menu_name
	} else {
		set menu_name $for_popup_menu
	}

#	add_menuitem $wname $menu_name "Launch Quartus" \
#		"InvokeQuartus $wname" 
	add_submenu $wname $menu_name locate
  add_menuitem $wname $menu_name.locate "Locate in Design File" \
		"LocateBack $wname.tree text"
  add_menuitem $wname $menu_name.locate "Locate in Last Compilation Floorplan" \
		"LocateBack $wname.tree floorplanner"
	InvokeQuartus $wname
}

# This is the procedure bound to the right-mouse-button.
proc SignalsPopup {w x X y Y} {
global vsimPriv
if {$vsimPriv(Dragging)} {
    set vsimPriv(cancelDragDrop) 1
    EndDragSelection $w Drag_TreeItems $x $y Drag_TreeItemsConfig
}
set wid [$w cget -width]
set x1 [$w cget -wavesplit]
set x1 [expr 1.0 - $x1]
set w1 [expr $x1 * $wid]
set parent [winfo parent $w]
tk_popup $parent.mBar.prop.mb $X $Y
}

# This applies the selected menu pick to the highlighted signals
 proc SignalsApplyToSelection {args} {
global vsimPriv
set treename [lindex $args 0]
set rest [lrange $args 1 end]
set sel_list [$treename curselection]
foreach sel $sel_list {
    echo "$treename itemconfig $sel $rest"
    eval $treename itemconfig $sel $rest
}
 }

# Parser for the cross reference file
proc ParseXrfFile {xrf_name} {
	global xrf_array

	# initialize array
	foreach index [array names xrf_array] {
		set xrf_array($index) {}
	}

	if {[catch {set file [eval open $xrf_name r]}] != 0} {
		puts stderr "Error opening $xrf_name"
		return
	}

	while {[gets $file line] >= 0} {
		if [regexp {(^vendor_name)|(^source_file)|(^design_name)} $line] {
			#skip lines
#puts stdout "skipped line is $line"
			continue
		} else {
			set out_name "|"
			set tmp [lindex [split $line ,] 3]
			append out_name $tmp
			append out_name "|"
			set q_name $out_name
			set tmp [lindex [split $line ,] 1]
			append out_name $tmp
			regsub -all {\ } $out_name {} out_name
#puts stdout "out_name is $out_name"
			set tmp [lindex [split $line ,] 2]
			append q_name $tmp
			regsub -all {\ } $q_name {} q_name
#puts stdout "q_name is $q_name"
			set xrf_array($out_name) $q_name 
#puts stdout "xrf_array index is $out_name, content is $xrf_array($out_name)"
		}
	}

#puts stdout "xrf_array has [array size xrf_array] elements"
#	foreach index [array names xrf_array] {
#		puts stdout "index is $index"
#		puts stdout "content is $xrf_array($index)"
#	}

	if {[catch {close $file}] != 0} {
		puts stderr "Error closing $xrf_name"
		return
	}
}

# Invoke Quartus from the d:\quartus\bin directory
proc InvokeQuartus {wname} {
	global env
	global quartus_root
	global prj_name
	global s_attach

	#set exe_name "$quartus_root/bin/quartus.exe" 
	#puts stdout $exe_name
	#set prj_name [GetValue $wname "Project Name"]
	set prj_full_name [file tail [glob -nocomplain ../../*.quartus]]
	if {[string compare $prj_full_name ""] == 0} {
		set prj_full_name [file tail [glob -nocomplain ../../*.qpf]]
	}
	if {[string compare $prj_full_name ""] == 0} {
		puts stderr "Unable to locate Quartus project file"
	}
	set prj_name [file rootname $prj_full_name]
#puts stdout "prj_name is $prj_name"
	set xrf_name $prj_name
	append xrf_name "_modelsim.xrf"
#puts stdout "xrf_name is $xrf_name"
	ParseXrfFile $xrf_name

	if [catch {q_attach 1} result] {
		puts stderr "attach result is $result"
	} else {
		set s_attach 1
#puts stdout "attach is successful"
	}
}
	
# Procedure for locating back to Quartus, flag is the argument indicating
# whether to locate back to the original source or the floor planner

proc LocateBack {treename flag} {
	global s_attach
	global xrf_array
#puts stdout "s_attach is $s_attach"
	set sel_list [$treename curselection]
	foreach sel $sel_list {
		set sel_name [$treename get $sel]
		regsub -nocase {([a-z]+):/([a-z]+)/} $sel_name [ ] sig_name
		regsub -all / $sig_name | sig_name
		puts stdout "Locate signal \"$sig_name\" back to $flag"
		if {[string compare $flag "text"] == 0} {
			if {$s_attach == 1} {
#puts stdout TEXT
				if {[regexp {\([0-9]+\)} $sig_name] == 1} {
					regsub -all {\(} $sig_name {\[} sig_name
					regsub -all {\)} $sig_name {\]} sig_name
				} elseif {[regexp {\\$} $sig_name] == 1} {
					regsub -all {\\$} $sig_name {} sig_name
				} else {
#puts stdout "no name changed"
				} 
#puts stdout "sig_name is $sig_name"

				set ignore_xrf 1
				foreach index [array names xrf_array] {
#puts stdout "index is $index"
					if {$index == $sig_name} {
						set ignore_xrf 0
						break
					}
				}
#puts stdout "ignore_xrf(2) is $ignore_xrf"
				if {$ignore_xrf == 1} {
#puts stdout "name not in xrf file "
					set qsig_name $sig_name
				} else {
#puts stdout "name in xrf file"
#puts stdout "xrf_array index is $sig_name, content is $xrf_array($sig_name)"
					set qsig_name $xrf_array($sig_name)
				}
#puts stdout "qsig_name-- $qsig_name"
#puts stdout "Located signals name $qsig_name"
				if [catch {q_cmp_locate_to_text $qsig_name} result] {
					puts stderr "_to_text result is $result"
				}
			}
		} else {
			if {$s_attach == 1} {
#puts stdout FLOORPLAN
				if {[regexp {\([0-9]+\)} $sig_name] == 1} {
					regsub -all {\(} $sig_name {\[} sig_name
					regsub -all {\)} $sig_name {\]} sig_name
				} elseif {[regexp {\\$} $sig_name] == 1} {
					regsub -all {\\$} $sig_name {} sig_name
				} else {
#puts stdout "no name changed"
				} 

				set ignore_xrf 1
				foreach index [array names xrf_array] {
					if {$index == $sig_name} {
						set ignore_xrf 0
						break
					}
				}
#puts stdout "ignore_xrf(2) is $ignore_xrf"
				if {$ignore_xrf == 1} {
#puts stdout "name not in xrf file "
					set qsig_name $sig_name
				} else {
#puts stdout "name in xrf file"
#puts stdout "xrf_array index is $sig_name, content is $xrf_array($sig_name)"
					set qsig_name $xrf_array($sig_name)
				}
#puts stdout "qsig_name-- $qsig_name"
#puts stdout "Located signals name $qsig_name"
#puts stdout "***Located signals name $qsig_name"
				if [catch {q_cmp_locate_to_floorplan $qsig_name} result] {
					puts stderr "_to_floorplan result is $result"
				} else {
#puts stdout "Signal $qsig_name located to floorplaner"
				}
			}
		}
	}
}
