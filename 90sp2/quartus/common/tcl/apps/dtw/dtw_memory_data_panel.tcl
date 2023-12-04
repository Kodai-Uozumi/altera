::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_memory_data_panel.tcl
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
namespace eval dtw_memory_data {
#
# Description: Namespace to encapsulate the Memory Data panel
#
# ----------------------------------------------------------------
	# Time units displayed in the comboboxes next to the time entries
    variable s_time_units
    set s_time_units {"ms" "us" "ns" "ps"}

    variable s_time_units_with_tCK
    set s_time_units_with_tCK {"ms" "us" "ns" "ps" "tCK"}

    variable s_cycles
    set s_cycles {"cycles"}

	# Listing of entries in s_memory_data_types
	# <variable_name> <display_text> <data_entry_args>
	variable VARIABLE_NAME 0
	variable DISPLAY_TEXT 1
	variable DATA_ENTRY_ARGS 2

	variable s_memory_data_types

	# Listing of memory types (DDR, QDR2, RLDRAM2)
	variable s_memory_types_list

	variable s_custom_memory ""

	variable s_visible_data_enums
	variable s_rl2_is_cio 0

	# Source everything to get the latest version date
	source ${::dtw::s_dtw_dir}dtw_memory_presets.tcl
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::panel { memory_window next_button args } {
#
# Description: Show the wizard panel for entering memory parameters
#              widget-specific commands are:
#              load
#              save
#
# ----------------------------------------------------------------
	variable VARIABLE_NAME
	variable DISPLAY_TEXT
	variable DATA_ENTRY_ARGS

	variable s_cycles
	variable s_time_units
    variable s_time_units_with_tCK
	variable s_memory_data_types
	variable s_memory_types_list
	variable s_rl2_is_cio

	# Format of entries:
	# <variable_name> <display_text> <data_entry_args>

	set s_memory_data_types [list \
		[list mem_CL "CAS Latency" [list -comboboxunits $s_cycles -comboboxdefaultunit @0]] \
		[list mem_tCK "Clock period" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list mem_tAC "DQ output access time from CK/CK#" [list -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrylabel "+/-"]] \
		[list mem_tDQSCK "DQS output Access time from CK/CK#" [list -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrylabel "+/-"]] \
		[list mem_tDH "DQ and DM input hold time relative to DQS" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list mem_tDS "DQ and DM input setup time relative to DQS" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list mem_tDQSQ "DQS-DQ skew (for DQS and associated signals)"  [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list mem_min_tDQSS "Minimum write command to first DQS latching transition" [list -comboboxunits $s_time_units_with_tCK -comboboxdefaultunit @4]] \
		[list mem_max_tDQSS "Maximum write command to first DQS latching transition" [list -comboboxunits $s_time_units_with_tCK -comboboxdefaultunit @4]] \
		[list mem_tQHS "Data hold skew factor" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list mem_tIH "Address and Control input hold time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list mem_tIS "Address and Control input setup time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list mem_tHP "CK half period" [list -comboboxunits $s_time_units_with_tCK -comboboxdefaultunit @2]] \
		[list mem_tRPST "Read postamble" [list -comboboxunits $s_time_units_with_tCK -comboboxdefaultunit @2]] \
		[list q2_tKHKH "K Clock and C Clock Cycle Time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tKHKnH "K Clock Rise to K# Clock Rise" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tCHQV "Clock High to Data Valid" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tCHQX "Clock High to Data Invalid" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tCHCQV "Clock High to Echo Clock Valid" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tCHCQX "Clock High to Echo Clock Invalid" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tCQHQV "Echo Clock High to Data Valid" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tCQHQX "Echo Clock High to Data Invalid" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tSA "Address Setup time to Clock Rise" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tSC "Control Setup time to Clock Rise" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tSD "D\[X:0\] Setup to Clock Rise" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tHA "Address Hold after Clock Rise" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tHC "Control Hold after Clock Rise" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list q2_tHD "D\[X:0\] Hold after Clock Rise" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list rl2_is_cio "Uses common I/O for read/write data" ""] \
		[list rl2_tRL "Read latency" [list -comboboxunits $s_cycles -comboboxdefaultunit @0]] \
		[list rl2_tCK "Clock cycle time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list rl2_tQKH "Minimum output data clock high time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list rl2_tCKQK "QK edge to clock edge skew" [list -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrylabel "+/-"]] \
		[list rl2_tQKQ0_tQKQ1 "QK edge to output data edge time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrylabel "+/-"]] \
		[list rl2_tQKQ "QK edge to any output data edge time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrylabel "+/-"]] \
		[list rl2_tAS "Address input setup time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list rl2_tAH "Address input hold time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list rl2_tCS "Control input setup time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list rl2_tCH "Control input hold time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list rl2_tDS "Data-in and data mask to DK setup time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list rl2_tDH "Data-in and data mask to DK hold time" [list -comboboxunits $s_time_units -comboboxdefaultunit @2]]]

	frame $memory_window -borderwidth 12
	frame ${memory_window}.type_combobox_frame
	label ${memory_window}.type_combobox_frame.l -text "Select Your Memory Type:  " -pady 6
	set memory_type_list [list]
	foreach memory_type $s_memory_types_list {
		array set type_info_array $memory_type
		lappend memory_type_list $type_info_array(type_name)
		array unset type_info_array
	}
	ComboBox ${memory_window}.type_combobox_frame.combobox -editable 0 -values $memory_type_list -modifycmd "[namespace code on_type_combobox_select] $memory_window $next_button"
	frame ${memory_window}.preset_combobox_frame
	label ${memory_window}.preset_combobox_frame.l -text "Select Your Memory:  " -pady 6
	ComboBox ${memory_window}.preset_combobox_frame.combobox -editable 0 -values [list] -modifycmd "[namespace code on_preset_combobox_select] $memory_window $next_button"

	labelframe ${memory_window}.data_frame -text "Memory Parameters" -labelanchor nw -pady 2
	foreach data_type $s_memory_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		set data_label [lindex $data_type $DISPLAY_TEXT]
		set data_entry_args [lindex $data_type $DATA_ENTRY_ARGS]
		if {$data_enum == "rl2_is_cio"} {
			# Checkbutton
			frame ${memory_window}.data_frame.${data_enum}_frame -padx 4 -pady 2
			label ${memory_window}.data_frame.${data_enum}_frame.label -text $data_label
			label ${memory_window}.data_frame.${data_enum}_frame.user_term_label
			checkbutton ${memory_window}.data_frame.${data_enum}_frame.checkbutton -variable [namespace which -variable s_$data_enum]
		} else {
			# Time entry
			eval [list ::dtw::dtw_data_entry::dtw_data_entry ${memory_window}.data_frame.${data_enum}_frame $data_label -comboboxwidth 6 -entrywidth 10 -validatecommand "[namespace code validate_float] $memory_window %P %V"] $data_entry_args
		}
	}

	pack ${memory_window}.type_combobox_frame.l -side left
	pack ${memory_window}.type_combobox_frame.combobox -side left -fill x -expand true
	pack ${memory_window}.type_combobox_frame -side top -fill both
	pack ${memory_window}.preset_combobox_frame.l -side left
	pack ${memory_window}.preset_combobox_frame.combobox -side left -fill x -expand true
	pack ${memory_window}.preset_combobox_frame -side top -fill both
	
	pack ${memory_window}.data_frame -side top -fill both -expand 0
	foreach data_type $s_memory_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]		
		if {$data_enum == "rl2_is_cio"} {
			# Checkbutton
			pack ${memory_window}.data_frame.${data_enum}_frame.checkbutton -side left
			pack ${memory_window}.data_frame.${data_enum}_frame.label -side left
			pack ${memory_window}.data_frame.${data_enum}_frame.user_term_label -side left
		} else {
			::dtw::dtw_data_entry::bind_to_entry ${memory_window}.data_frame.${data_enum}_frame <KeyRelease> "[namespace code on_entry_keyrelease] $memory_window $next_button" 
		}
		pack ${memory_window}.data_frame.${data_enum}_frame -side top -fill x -expand 1
	}

	bind $memory_window <Map> "[namespace code update_next_state] $memory_window $next_button"

	return $memory_window
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::save_data {memory_window data_array_name} {
#
# Description: Save the data in this panel in the data_array
#
# ----------------------------------------------------------------
	variable s_visible_data_enums
	variable s_memory_types_list
	variable s_rl2_is_cio
	upvar $data_array_name data_array

	# Data in the panel is saved in array:
	# set data_array(data_enum0) = {value0 units0}
	# set data_array(data_enum1) = {value1 units1}
	# ...
	foreach data_enum $s_visible_data_enums {
		if {$data_enum == "rl2_is_cio"} {
			set data_array($data_enum) $s_rl2_is_cio
		} else {
			set data_array($data_enum) [::dtw::dtw_data_entry::get_data ${memory_window}.data_frame.${data_enum}_frame]
		}
	}
	set selected_type_index [${memory_window}.type_combobox_frame.combobox getvalue]
	array set type_info [lindex $s_memory_types_list $selected_type_index]
	set data_array(memory_type) $type_info(type)
	set data_array(memory_preset) [${memory_window}.preset_combobox_frame.combobox cget -text]
	return
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::load_data {memory_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_memory_data_types
	variable s_custom_memory
	variable s_visible_data_enums
	variable s_rl2_is_cio
	upvar $data_array_name data_array

	if {[array names data_array -exact custom_memory] != ""} {
		set s_custom_memory $data_array(custom_memory)
	}
	if {[array names data_array -exact memory_type] != ""} {
		set type_info_list [get_memory_type_info $data_array(memory_type)]
	} else {
		# Default to DDR
		set type_info_list [get_memory_type_info ddr]
	}
	array set type_info $type_info_list
	${memory_window}.type_combobox_frame.combobox configure -text "$type_info(type_name)"
	on_type_combobox_select $memory_window ""

	if {[array names data_array -exact memory_preset] != ""} {
		${memory_window}.preset_combobox_frame.combobox configure -text "$data_array(memory_preset)"
		on_preset_combobox_select $memory_window ""
	}

	foreach data_enum $s_visible_data_enums {
		if {[array names data_array -exact $data_enum] != ""} {
			if {$data_enum == "rl2_is_cio"} {
				set s_$data_enum $data_array($data_enum)
			} else {
				::dtw::dtw_data_entry::set_data ${memory_window}.data_frame.${data_enum}_frame $data_array($data_enum)
			}
		}
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::validate_float {memory_window number validation_type} {
#
# Description: Validate the number is a float
#
# Returns: true if it is, false otherwise
#
# ----------------------------------------------------------------
	if {$number == "" || (($number == "-" || $number == "." || $number == "-.") && $validation_type == "key")} {
		set valid 1
	} else {
		set valid [string is double $number]
	}
	return $valid
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::on_entry_keyrelease { memory_window next_button } {
#
# Description: Get the data in this panel
#
# ----------------------------------------------------------------
	${memory_window}.preset_combobox_frame.combobox setvalue first
	update_next_state $memory_window $next_button
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::update_next_state { memory_window next_button } {
#
# Description: Tells if the "Next" button should be enabled and changes its
#              state accordingly.
#
# ----------------------------------------------------------------
	variable s_visible_data_enums

	set enable 1
	foreach data_enum $s_visible_data_enums {
		if {$data_enum != "rl2_is_cio"} {
			set data_value [::dtw::dtw_data_entry::get_entry_text ${memory_window}.data_frame.${data_enum}_frame]
			if {$data_value != "" && [string is double $data_value]} {
				# data good
			} else {
				# disable Next button
				set enable 0
			}
		}
	}
	if {$next_button != ""} {
		if {$enable == 0} {
			$next_button configure -state disabled
		} else {
			$next_button configure -state normal
		}
	}
	return $enable
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::on_next { memory_window } {
#
# Description: Handles the "Next" button event
#
# ----------------------------------------------------------------
	if {[update_next_state $memory_window ""]} {
		set result "next"
	} else {
		::dtw::msg_o "Error" "Missing required memory data"
		set result "none"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::get_memory_type_info { mem_type } {
#
# Description: Get the type info list for the given type
#
# ----------------------------------------------------------------
	variable s_memory_types_list

	set found 0
	for {set i 0} {$i != [llength $s_memory_types_list] && $found == 0} {incr i} {
		array set type_info [lindex $s_memory_types_list $i]
		if {$type_info(type) == $mem_type} {
			set found 1
			set result [lindex $s_memory_types_list $i]
		}
	}
	if {$found == 0} {
		error "Invalid memory type $mem_type"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::on_type_combobox_select { memory_window next_button } {
#
# Description: Get the data in this panel
#
# ----------------------------------------------------------------
	variable s_memory_types_list
	variable s_memory_data_types
	variable s_visible_data_enums
	variable s_custom_memory

	set selected_index [${memory_window}.type_combobox_frame.combobox getvalue]
	array set type_info [lindex $s_memory_types_list $selected_index]
	set presets_list [list]
	foreach preset $type_info(presets) {
		# Assume memory_name is always the first stat
		lappend presets_list [lindex $preset 1]
	}
	if {$s_custom_memory != ""} {
		array set custom_memory $s_custom_memory
		if {[array names custom_memory -exact custom_memory_type] == ""} {
			set custom_memory_type "ddr"
		} else {
			set custom_memory_type $custom_memory(custom_memory_type)
		}
		if {$custom_memory_type == $type_info(type)} {
			if {[array names custom_memory -exact memory_name] != ""} {
				# Add custom memory to the presets combobox
				lappend presets_list $custom_memory(memory_name)
			}
		}
	}

	# Clear and add presets
	# TODO: detect if the type is unchanged
	${memory_window}.preset_combobox_frame.combobox configure -values $presets_list
	${memory_window}.preset_combobox_frame.combobox setvalue first

	# Change visible parameters
	set s_visible_data_enums [list]
	set mem_term_list [list]
	::dtw::dtw_device_get_family_parameter "_default" ${type_info(type)}_terms mem_term_list
	array set mem_term_array $mem_term_list

	variable VARIABLE_NAME
	foreach data_type $s_memory_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		if {[array names mem_term_array -exact $data_enum] == ""} {
			pack forget ${memory_window}.data_frame.${data_enum}_frame
		} else {
			lappend s_visible_data_enums $data_enum
			pack ${memory_window}.data_frame.${data_enum}_frame -side top -fill x -expand 1
			::dtw::dtw_data_entry::set_user_term_label_text ${memory_window}.data_frame.${data_enum}_frame "($mem_term_array($data_enum))"
		}
	}

	on_preset_combobox_select $memory_window $next_button

	return
}

# ----------------------------------------------------------------
#
proc dtw_memory_data::on_preset_combobox_select { memory_window next_button } {
#
# Description: Get the data in this panel
#
# ----------------------------------------------------------------
	variable s_memory_data_types
	variable s_memory_types_list
	variable s_custom_memory
	variable s_rl2_is_cio

	set selected_type_index [${memory_window}.type_combobox_frame.combobox getvalue]
	array set type_info [lindex $s_memory_types_list $selected_type_index]

	set selected_preset_index [${memory_window}.preset_combobox_frame.combobox getvalue]
	if {$selected_preset_index < [llength $type_info(presets)]} {
		set mem_info_list [lindex $type_info(presets) $selected_preset_index]
	} elseif {$s_custom_memory != ""} {
		set mem_info_list $s_custom_memory
	} else {
		set mem_info_list [list]
	}
	array set mem_info $mem_info_list
	variable VARIABLE_NAME
	foreach data_type $s_memory_data_types {
		set data_enum [lindex $data_type $VARIABLE_NAME]
		if {[winfo exists ${memory_window}.data_frame.${data_enum}_frame.checkbutton] && [array names mem_info -exact $data_enum] != ""} {
			set s_$data_enum $mem_info($data_enum)
		} elseif {[array names mem_info -exact $data_enum] != ""} {
			::dtw::dtw_data_entry::set_data ${memory_window}.data_frame.${data_enum}_frame $mem_info($data_enum)
		}
	}
	update_next_state $memory_window $next_button

	return
}
