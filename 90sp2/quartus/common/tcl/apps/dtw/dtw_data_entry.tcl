::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_data_entry.tcl
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

# ----------------------------------------------------------------
#
namespace eval dtw_data_entry {
#
# Description: Namespace to encapsulate a data entry
#
# ----------------------------------------------------------------
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::dtw_data_entry { data_window label_text args } {
#
# Description: A frame of controls for entering numbers/time
#
# ----------------------------------------------------------------
	# General options:
    #  -updatenextstatecommand <update next state command>
	#
	# Combobox options:
	#  -comboboxunits <list_of_combobox_contents>
    #  -comboboxdefaultunit <@index into list_of_combobox_contents>
    #  -comboboxwidth <#chars width>
	#
    # Entry options:
    #  -entrydefault <default entry value>
    #  -entrywidth <#chars widget>
    #  -entryjustify <left|right>
    #  -validatecommand <entry validation command>
	#
    # Entry0 options:
    #  -entry0default <default entry value>
    #  -entry0width <#chars widget>
    #  -entry0validatecommand <entry validation command>
	#
    # User label (not with Node Name):
    #  -usertermlabel <equation term>
	#
    # Entry label (not with Node Name):
    #  -entrylabel <entry prefix label>
	#
    # Node Name options:
    #  -rows <2 if label is on first line and entry is on the second; else 1>
    #  -namebrowsercommand <name browser command>
	#  -entryvariable <variable to store entry contents>
	#
	array set options [list "-comboboxunits" "" "-comboboxdefaultunit" "" "-comboboxwidth" 4 "-entrydefault" "" "-entrywidth" 8 "-entryjustify" "right" "-entry0default" "" "-entry0width" 0 "-usertermlabel" "" "-entrylabel" "" "-validatecommand" "" "-entry0validatecommand" "" "-indent" 0 "-rows" 1 "-namebrowsercommand" "" "-updatenextstatecommand" "" "-entryvariable" "" ]
	foreach {option value} $args {
		if {[array names options -exact "$option"] != ""} {
			set options($option) $value
		} else {
			error "ERROR: Unknown option $option (with value $value)"
		}
	}

	frame $data_window -padx 4 -pady 2
	label $data_window.label -text $label_text -justify left -anchor w
	if {$options(-namebrowsercommand) != ""} {
		# Data is a node name
		entry ${data_window}.entry -width $options(-entrywidth) -textvariable $options(-entryvariable)
		Button ${data_window}.browser_button -text "..." -helptext "Select names in the name browser" -width 3 -command $options(-namebrowsercommand)
	} else {
		# Random Data
		label $data_window.user_term_label -justify left -anchor e
		if {$options(-entry0width) > 0} {
			if {$options(-entry0validatecommand) == ""} {
				set options(-entry0validatecommand) $options(-validatecommand)
			}
			entry $data_window.entry0 -width $options(-entry0width) -justify $options(-entryjustify) -validate all -validatecommand $options(-entry0validatecommand)
			$data_window.entry0 insert 0 $options(-entry0default)
		}
		label $data_window.entry_label -text $options(-entrylabel) -justify right
		if {$options(-entrywidth) > 0} {
			entry $data_window.entry -width $options(-entrywidth) -justify $options(-entryjustify) -validate all -validatecommand $options(-validatecommand)
		}
	}
	$data_window.entry insert 0 $options(-entrydefault)

	if {$options(-comboboxunits) != ""} {
		ComboBox $data_window.units -width $options(-comboboxwidth) -values $options(-comboboxunits) -editable 0
		$data_window.units setvalue $options(-comboboxdefaultunit)
	}

	#### Layout the items in the frame ####

	# Indent column
	grid columnconfigure $data_window 0 -weight 0 -minsize $options(-indent)
	# Label column
	grid columnconfigure $data_window 1 -weight 2
	if {$options(-rows) == 2} {
		# Button column
		grid columnconfigure $data_window 2 -weight 0
		# Label row
		grid rowconfigure $data_window 0 -weight 1
		# Entry row
		grid rowconfigure $data_window 1 -weight 1

		grid configure ${data_window}.label -row 0 -column 1 -columnspan 2 -sticky ew
		grid configure ${data_window}.entry -row 1 -column 1 -sticky ew
		
		grid configure ${data_window}.browser_button -row 1 -column 2 -sticky e
	} else {
		# User term label column
		grid columnconfigure $data_window 2 -weight 1
		# Entry2 column
		grid columnconfigure $data_window 3 -weight 0
		# Entry label column
		grid columnconfigure $data_window 4 -weight 0
		# Entry column
		grid columnconfigure $data_window 5 -weight 0
		# Combobox/browser_button column
		grid columnconfigure $data_window 6 -weight 0

		# Column 0 is just for indenting
		grid configure ${data_window}.label -row 0 -column 1 -sticky ew
		if {$options(-namebrowsercommand) == ""} {
			grid configure ${data_window}.user_term_label -row 0 -column 2 -sticky ew
			grid configure ${data_window}.entry_label -row 0 -column 4 -sticky e
		}
		if {$options(-entry0width) > 0} {
			grid configure ${data_window}.entry0 -row 0 -column 3 -sticky e
		}
		if {$options(-entrywidth) > 0} {
			grid configure ${data_window}.entry -row 0 -column 5 -sticky e
		}
		if {$options(-comboboxunits) != ""} {
			grid configure ${data_window}.units -row 0 -column 6 -sticky e
		} elseif {$options(-namebrowsercommand) != ""} {
			grid configure ${data_window}.browser_button -row 0 -column 6 -sticky e
		}
	}

	bind $data_window.label <Configure> "$data_window.label configure -wraplength %w"
	if {[winfo exists $data_window.user_term_label]} {
		set_user_term_label_text $data_window $options(-usertermlabel)
	}

	if {$options(-updatenextstatecommand) != ""} {
		bind $data_window <Map> "eval $options(-updatenextstatecommand)"
	}

	return $data_window
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::set_label { data_window entry_label} {
#
# Description: Set the label
#
# ----------------------------------------------------------------
	${data_window}.label configure -text "$entry_label"
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::set_user_term_label_text { data_window user_term_label_text} {
#
# Description: Set the label
#
# ----------------------------------------------------------------
	${data_window}.user_term_label configure -text "$user_term_label_text"
	if {[llength $user_term_label_text] > 1} {
		bind $data_window.user_term_label <Configure> "$data_window.user_term_label configure -wraplength %w"
	}
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::set_entry_label_text { data_window entry_label_text} {
#
# Description: Set the label
#
# ----------------------------------------------------------------
	${data_window}.entry_label configure -text "$entry_label_text"
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::get_label { data_window} {
#
# Description: Set the label
#
# ----------------------------------------------------------------
	return [${data_window}.label cget -text]
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::set_data { data_window data } {
#
# Description: Set the entry
#
# ----------------------------------------------------------------
	if {[winfo exists ${data_window}.entry0]} {
		set entry0_value "[lindex $data 0]"
		${data_window}.entry0 delete 0 end
		${data_window}.entry0 insert 0 "$entry0_value"
		set entry_value "[lindex $data 1]"
		${data_window}.entry delete 0 end
		${data_window}.entry insert 0 "$entry_value"
		if {[winfo exists ${data_window}.units]} {
			set data_units "[lindex $data 2]"
			${data_window}.units configure -text "$data_units"
		}
	} elseif {[winfo exists ${data_window}.units]} {
		set data_value "[lindex $data 0]"
		set data_units "[lindex $data 1]"
		${data_window}.entry delete 0 end
		${data_window}.entry insert 0 "$data_value"
		${data_window}.units configure -text "$data_units"
	} else {
		${data_window}.entry delete 0 end
		${data_window}.entry insert 0 "$data"
	}
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::get_entry_text { data_window } {
#
# Description: Set the entry
#
# ----------------------------------------------------------------
	return [$data_window.entry get]
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::get_entry0_text { data_window } {
#
# Description: Set the entry
#
# ----------------------------------------------------------------
	return [$data_window.entry0 get]
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::get_data { data_window } {
#
# Description: Get the entry and units
#
# ----------------------------------------------------------------
	set data_value [get_entry_text $data_window]
	if {[winfo exists ${data_window}.entry0]} {
		set data0_value [get_entry0_text $data_window]
		set result [list $data0_value $data_value]
		if {[winfo exists ${data_window}.units]} {
			set data_units [$data_window.units cget -text]
			lappend result $data_units
		}
	} elseif {[winfo exists ${data_window}.units]} {
		set data_units [$data_window.units cget -text]
		set result [list $data_value $data_units]
	} else {
		set result $data_value
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::is_data_valid { data_window } {
#
# Description: Tells whether the data is valid (using the validation command)
#
# ----------------------------------------------------------------
	set result [$data_window.entry validate]
	if {$result && [winfo exists $data_window.entry0]} {
		set result [$data_window.entry0 validate]
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::bind_to_entry0 { data_window event event_command } {
#
# Description: Binds an event handler to an entry event
#
# ----------------------------------------------------------------
	bind ${data_window}.entry0 $event "$event_command"
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::bind_to_entry { data_window event event_command } {
#
# Description: Binds an event handler to an entry event
#
# ----------------------------------------------------------------
	bind ${data_window}.entry $event "$event_command"
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::set_labels_state { data_window state } {
#
# Description: Set the enable/disabled state of the labels
#
# ----------------------------------------------------------------
	${data_window}.label configure -state $state
	${data_window}.user_term_label configure -state $state
	${data_window}.entry_label configure -state $state
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::get_labels_state { data_window } {
#
# Description: Get the enable/disabled state of the labels
#
# ----------------------------------------------------------------
	return [${data_window}.label cget -state]
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::set_entry_state { data_window state } {
#
# Description: Set the enable/disabled state of the entry boxes
#
# ----------------------------------------------------------------
	${data_window}.entry configure -state $state
	if {[winfo exists ${data_window}.entry0]} {
		${data_window}.entry0 configure -state $state
	}
	if {[winfo exists ${data_window}.units]} {
		${data_window}.units configure -state $state
	}
	if {[winfo exists ${data_window}.browser_button]} {
		${data_window}.browser_button configure -state $state
	}
}

# ----------------------------------------------------------------
#
proc dtw_data_entry::get_entry_state { data_window } {
#
# Description: Get the enable/disabled state of the entry boxes
#
# ----------------------------------------------------------------
	return [${data_window}.entry cget -state]
}
