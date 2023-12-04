##############################################################################
#
# File Name:    dtw_msg.tcl
#
# Summary:      This TK script is a simple Graphical User Interface to
#               generate timing requirements for DDR memory interfaces
#
# Licencing:
#               ALTERA LEGAL NOTICE
#               
#               This script is  pursuant to the following license agreement
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
#               FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
#               California, USA.  Permission is hereby granted, free of
#               charge, to any person obtaining a copy of this software and
#               associated documentation files (the "Software"), to deal in
#               the Software without restriction, including without limitation
#               the rights to use, copy, modify, merge, publish, distribute,
#               sublicense, and/or sell copies of the Software, and to permit
#               persons to whom the Software is furnished to do so, subject to
#               the following conditions:
#               
#               The above copyright notice and this permission notice shall be
#               included in all copies or substantial portions of the Software.
#               
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#               OTHER DEALINGS IN THE SOFTWARE.
#               
#               This agreement shall be governed in all respects by the laws of
#               the State of California and by the laws of the United States of
#               America.
#
#               
#
# Usage:
#
#               You can run this script from a command line by typing:
#                     quartus_sh --dtw
#
###############################################################################

package provide ::quartus::dtw_msg 1.0
# ----------------------------------------------------------------
#
namespace eval ::quartus::dtw_msg {
#
# Description: Namespace to encapsulate the messaging code
#
# ----------------------------------------------------------------
	namespace export msg_o
	namespace export msg_oc
	namespace export msg_co
	namespace export msg_yn
	namespace export msg_ynyana
	namespace export msg_ny
	namespace export msg_nyc
	namespace export msg_wait_begin
	namespace export msg_wait_end
	namespace export get_dtw_msg_version
	namespace export msg_set_show_gui
	namespace export msg_make_foreground

	variable s_show_gui 1

	variable s_prompt_result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::get_dtw_msg_version { } {
#
# Description: Get the package version
#
# ----------------------------------------------------------------
	return {$Date: 2009/04/01 $}
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_set_show_gui {show_gui} {
#
# Description: Get the package version
#
# ----------------------------------------------------------------
	variable s_show_gui
	set s_show_gui $show_gui
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_o { title message {parent_window ""}} {
#
# Description: Used to display error and warning messages
#
# ----------------------------------------------------------------
	variable s_show_gui
	if {$s_show_gui} {
		set result [tk_messageBox -default "ok" -type ok -title $title -message $message]
		if {$parent_window != ""} {
			msg_make_foreground $parent_window
		}
	} else {
		puts "${title}: $message"
		set result "ok"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_oc { title message {parent_window ""}} {
#
# Description: Used to display error and warning messages with "ok" and
# "cancel" results (default is ok)
#
# ----------------------------------------------------------------
	variable s_show_gui
	if {$s_show_gui} {
		set result [tk_messageBox -default "ok" -type okcancel -title $title -message $message]
		if {$parent_window != ""} {
			msg_make_foreground $parent_window
		}
	} else {
		puts "${title}: $message OK"
		set result "ok"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_co { title message {parent_window ""}} {
#
# Description: Used to display error and warning messages with "ok" and
# "cancel" results (default is cancel)
#
# ----------------------------------------------------------------
	variable s_show_gui
	if {$s_show_gui} {
		set result [tk_messageBox -default "cancel" -type okcancel -title $title -message $message]
		if {$parent_window != ""} {
			msg_make_foreground $parent_window
		}
	} else {
		puts "${title}: $message Cancel"
		set result "cancel"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_yn { title message {parent_window ""}} {
#
# Description: Used to display error and warning messages with "yes" and
# "no" results (default is yes)
#
# ----------------------------------------------------------------
	variable s_show_gui
	if {$s_show_gui} {
		set result [tk_messageBox -default "yes" -type yesno -title $title -message $message]
		if {$parent_window != ""} {
			msg_make_foreground $parent_window
		}
	} else {
		puts "${title}: $message Yes"
		set result "yes"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::get_message_icon_type {title} {
#
# Description: Used to display error and warning messages with "yes",
# "no", "yes to all" and "no to all" results (default is yes)
#
# ----------------------------------------------------------------
	if {[string first "Warning" $title] == 0} {
		set icon_type "warning"
	} elseif {[string first "Error" $title] == 0} {
		set icon_type "error"
	} elseif {[string first "Info" $title] == 0} {
		set icon_type "info"
	} else {
		set icon_type "question"
	}
	return $icon_type
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_user { title message button_list default_button parent_window } {
#
# Description: Used to display error and warning messages with user-defined
#              buttons.  default_button indicates the text of the default
#              button
#
# ----------------------------------------------------------------
	variable s_prompt_result
	set s_prompt_result ""

	set popup_window [toplevel .dtw_msg_user]
	wm title $popup_window $title
	wm resizable $popup_window 0 0

	# Construct and pack widgets
	frame ${popup_window}.msg_frame
	frame ${popup_window}.buttons
	set i 0
	foreach button_name $button_list {
		if {$button_name == $default_button} {
			set state active
		} else {
			set state normal
		}
		button ${popup_window}.buttons.b$i -pady 2 -width 12 -text $button_name -default $state -command "set [namespace which -variable s_prompt_result] \"$button_name\""
		pack ${popup_window}.buttons.b$i -side left -padx 4
		incr i
	}
	label ${popup_window}.msg_frame.label -text $message -anchor center -justify left -pady 20 -padx 10 -width 100

	pack ${popup_window}.msg_frame.label -side top -fill x -expand 1
	pack ${popup_window}.msg_frame -side top -fill x -expand 1
	pack ${popup_window}.buttons -side bottom -ipadx 10 -ipady 10

	bind ${popup_window}.msg_frame.label <Configure> "${popup_window}.msg_frame.label configure -wraplength %w"

	# ** Make Modal Dialog **
	# Must make window visible before putting it in the foreground
	# or making it transient
	update

	# Make foreground window with focus
	grab set $popup_window

	if {$parent_window != ""} {
		# "transient" means the window is only a popup (no taskbar icon, 
		# same active state as the parent window, and hidden when the parent
		# is hidden)
		# Note that "wm transient" can only work on existing windows, so
		# the above update should make sure it exists
		wm transient $popup_window $parent_window
	}
	# Make foreground window with focus (doesn't seem withdraw is needed...)
	#wm withdraw $popup_window
	wm deiconify $popup_window

	# Override the WM_DELETE_WINDOW protocol
	wm protocol $popup_window WM_DELETE_WINDOW "set [namespace which -variable s_prompt_result] \"$default_button\""

	# Wait until button is pressed (or window is closed)
	vwait [namespace which -variable s_prompt_result]
	grab release $popup_window
	destroy $popup_window

	return $s_prompt_result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_ynyana { title message parent_window } {
#
# Description: Used to display error and warning messages with "Yes",
# "No", "Yes to All" and "No to All" results (default is Yes)
#
# ----------------------------------------------------------------
	variable s_show_gui
	set default_answer "Yes"
	if {$s_show_gui} {
		set button_list [list "Yes" "No" "Yes to All" "No to All"]
		set result [msg_user $title $message $button_list $default_answer $parent_window]
		if {$parent_window != ""} {
			msg_make_foreground $parent_window
		}
	} else {
		puts "${title}: $message $default_answer"
		set result $default_answer
	}
	return $result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_ny { title message {parent_window ""}} {
#
# Description: Used to display error and warning messages with "yes" and
# "no" results (default is no)
#
# ----------------------------------------------------------------
	variable s_show_gui
	if {$s_show_gui} {
		set result [tk_messageBox -default "no" -type yesno -title $title -message $message]
		if {$parent_window != ""} {
			msg_make_foreground $parent_window
		}
	} else {
		puts "${title}: $message No"
		set result "no"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_nyc { title message {parent_window ""}} {
#
# Description: Used to display error and warning messages with "yes",
# "no", and "cancel" results (default is no)
#
# ----------------------------------------------------------------
	variable s_show_gui
	if {$s_show_gui} {
		set result [tk_messageBox -default "no" -type yesnocancel -title $title -message $message]
		if {$parent_window != ""} {
			msg_make_foreground $parent_window
		}
	} else {
		puts "${title}: $message No"
		set result "no"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_wait_begin { str waiting_window } {
#
# Description: Show a message popup and return the widget path
#
# ----------------------------------------------------------------
	variable s_show_gui
	if {$s_show_gui} {
		# This centers a popup on the toplevel window of the waiting window
		set main_window [winfo toplevel $waiting_window]

		set popup_window [toplevel .dtw_waiting_window]
		wm overrideredirect $popup_window 1
		labelframe ${popup_window}.frame
		label ${popup_window}.frame.wait_label -text $str
		pack ${popup_window}.frame.wait_label -side top -fill both -expand 1
		pack ${popup_window}.frame -side top -ipadx 10 -ipady 4

		# SPR 225432 - note that window geometry could be missing if the
		# window doesn't fit on the screen
		set waiting_window_geometry [wm geometry $main_window]
		if {[regexp -- {([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)} $waiting_window_geometry -> \
				width height left top]} {

			# Update so that the popup width and height are computed by the window mgr
			update
			set popup_window_geometry [wm geometry $popup_window]
			if {[regexp -- {([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)} $popup_window_geometry -> \
					popup_width popup_height popup_left popup_top]} {

				# Now center the popup with that info
				set popup_left [expr "$left + $width / 2 - $popup_width / 2"]
				set popup_top [expr "$top + $height / 2 - $popup_height / 2"]
				wm geometry $popup_window "+${popup_left}+${popup_top}"
			}
		}
		update
	} else {
		puts "$str"
	}
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_wait_end { waiting_window } {
#
# Description: Show a message popup and return the widget path
#
# ----------------------------------------------------------------
	variable s_show_gui
	if {$s_show_gui} {
		destroy .dtw_waiting_window
	}
	msg_make_foreground $waiting_window
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_msg::msg_make_foreground { w } {
#
# Description: Moves the parent window of the given widget to the foreground
#
# ----------------------------------------------------------------
	if {[winfo exists $w]} {
		wm deiconify [winfo toplevel $w]
	}
}
