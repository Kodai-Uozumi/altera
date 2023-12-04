::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_misc_panel.tcl
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
namespace eval dtw_misc {
#
# Description: Namespace to encapsulate the Miscellaneous Data panel
#
# ----------------------------------------------------------------
	variable s_misc_data_types
	# List of data_types:
	# <variable_name> <display_text> <optional> <data_entry_args>
	variable VARIABLE_NAME 0
	variable DISPLAY_TEXT 1
	variable OPTIONAL 2
	variable DATA_ENTRY_ARGS 3

	variable s_data_array_list

    variable s_time_units
    set s_time_units {"ms" "us" "ns" "ps"}

    variable s_percent_with_time_units
    set s_percent_with_time_units {"%" "ms" "us" "ns" "ps"}

	variable s_use_explicit_pll_errors 0
    variable s_timing_model "combined_fast_and_slow"

    variable s_clock_uncertainties_path
    variable s_is_clk_fedback_in 1

	# Source everything to get the latest version date
	source ${::dtw::s_dtw_dir}dtw_extract_tco.tcl
}

# ----------------------------------------------------------------
#
proc dtw_misc::panel { misc_window next_button args } {
#
# Description: Show the wizard panel for entering misc parameters
#
# ----------------------------------------------------------------
	variable s_misc_data_types
    variable s_time_units
    variable s_percent_with_time_units

	# Format of entries:
	# <variable_name> <display_text> <optional> <data_entry_args>
	set s_misc_data_types [list \
		[list {sys_clk_slow_min_tco sys_clk_max_tco} "Estimated slow model tco to the CK/CK# system clock output pins" 0 [list -entry0width 8 -entrylabel "to" -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list {sys_clk_min_tco sys_clk_fast_max_tco} "Estimated fast model tco to the CK/CK# system clock output pins" 0 [list -entry0width 8 -entrylabel "to" -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list {fb_clk_slow_min_tco fb_clk_max_tco} "Estimated slow model tco to the feedback clock output pin" 0 [list -entry0width 8 -entrylabel "to" -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list {fb_clk_min_tco fb_clk_fast_max_tco} "Estimated fast model tco to the feedback clock output pin" 0 [list -entry0width 8 -entrylabel "to" -comboboxunits $s_time_units -comboboxdefaultunit @2]] \
		[list pll_dc_distortion "Duty cycle distortion error of DDIO output clocks with PLL" 0 [list -comboboxunits $s_percent_with_time_units -comboboxdefaultunit @0 -entrydefault "5" -entrylabel "+/-"]] \
		[list fpga_tSHIFT_ERROR "DQS phase shift error" 0 [list -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.038" -entrylabel "+/-"]] \
		[list fpga_tJITTER "Estimated DQS phase jitter" 0 [list -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.150" -entrylabel "+/-"]] \
		[list fpga_tSKEW "Estimated DQS bus skew" 0 [list -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.035" -entrylabel "+/-"]] \
		[list use_explicit_pll_errors "Use explicit clock uncertainties" 1 0] \
		[list fpga_tCLOCK_SKEW_ADDER "Clock skew adder (skew between two dedicated clock networks feeding I/O banks on the same side of the FPGA)" 0 [list -indent 20 -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.050" -entrylabel "+/-"]] \
		[list fpga_tOUTJITTER "PLL jitter" 0 [list -indent 20 -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.125" -entrylabel "+/-"]] \
		[list fpga_tPLL_COMP_ERROR "PLL compensation error" 0 [list -indent 20 -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.100" -entrylabel "+/-"]] \
		[list fpga_tPLL_PSERR "PLL phase shift error" 0 [list -indent 20 -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.030" -entrylabel "+/-"]] \
		[list {fpga_tCK_ADDR_CTRL_SETUP_ERROR fpga_tCK_ADDR_CTRL_HOLD_ERROR} "Clock uncertainty for address/control transfers" 0 [list -indent 20 -entry0width 8 -entry0default "0.205" -entrylabel "," -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.205"]] \
		[list {fpga_tCK_WRDQS_SETUP_ERROR fpga_tCK_WRDQS_HOLD_ERROR} "Clock uncertainty for tDQSS" 0 [list -indent 20 -entry0width 8 -entry0default "0.205" -entrylabel "," -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.205"]] \
		[list {fpga_tD_WRDQS_SETUP_ERROR fpga_tD_WRDQS_HOLD_ERROR} "Clock uncertainty of write data transfers" 0 [list -indent 20 -entry0width 8 -entry0default "0.080" -entrylabel "," -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.080"]] \
		[list {fpga_tREAD_CAPTURE_SETUP_ERROR fpga_tREAD_CAPTURE_HOLD_ERROR} "Clock uncertainty for the read data capture" 0 [list -indent 20 -entry0width 8 -entry0default "0" -entrylabel "," -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0"]] \
		[list {fpga_tRDDQS_FBPLL_SETUP_ERROR fpga_tRDDQS_FBPLL_HOLD_ERROR} "Clock uncertainty for the data transfers from the read DQS clocks to a Feedback PLL clock" 0 [list -indent 20 -entry0width 8 -entry0default "0.255" -entrylabel "," -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.255"]] \
		[list {fpga_tFBPLL_SYSPLL_SETUP_ERROR fpga_tFBPLL_SYSPLL_HOLD_ERROR} "Clock uncertainty for the data transfers from the Feedback PLL clock to a System PLL clock" 0 [list -indent 20 -entry0width 8 -entry0default "0.255" -entrylabel "," -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.255"]] \
		[list {fpga_tRDDQS_SYSPLL_SETUP_ERROR fpga_tRDDQS_SYSPLL_HOLD_ERROR} "Clock uncertainty for the data transfers from the read DQS clocks to a System PLL clock" 0 [list -indent 20 -entry0width 8 -entry0default "0.155" -entrylabel "," -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.155"]] \
		[list {fpga_tQ_FBPLL_SETUP_ERROR fpga_tQ_FBPLL_HOLD_ERROR} "Clock uncertainty for read data transfers to the Feedback PLL clock" 0 [list -indent 20 -entry0width 8 -entry0default "0.255" -entrylabel "," -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.255"]] \
		[list {fpga_tQ_SYSPLL_SETUP_ERROR fpga_tQ_SYSPLL_HOLD_ERROR} "Clock uncertainty for read data transfers to a System PLL clock" 0 [list -indent 20 -entry0width 8 -entry0default "0.155" -entrylabel "," -comboboxunits $s_time_units -comboboxdefaultunit @2 -entrydefault "0.155"]] \
		]

	# TAN doesn't support intra-die variations yet....
    # [list ocv "On-die delay variation" 0 "%" @0 "33"]

	frame $misc_window -borderwidth 12
	labelframe ${misc_window}.data_frame -text "FPGA timing parameters" -labelanchor nw -pady 2
	label ${misc_window}.data_frame.label -text "Note that the following parameters should be adjusted after the first full compilation to match what is reported by the Timing Analyzer.  Use the \"Extract tcos\" button to adjust the tcos after the first compile so that accurate latencies are used for the read input clocks." -anchor w -justify left -pady 4 -padx 4

	variable VARIABLE_NAME
	variable DISPLAY_TEXT
	variable OPTIONAL
	variable DATA_ENTRY_ARGS
	variable s_use_explicit_pll_errors

	foreach data_type $s_misc_data_types {
		set min_max_data_enums [lindex $data_type $VARIABLE_NAME]
		set data_enum [lindex $min_max_data_enums 0]
		set data_label [lindex $data_type $DISPLAY_TEXT]
		set data_entry_args [lindex $data_type $DATA_ENTRY_ARGS]
		if {$data_enum == "use_explicit_pll_errors"} {
			frame ${misc_window}.data_frame.${data_enum}_frame -padx 8 -pady 1
			label ${misc_window}.data_frame.${data_enum}_frame.label -text $data_label
			checkbutton ${misc_window}.data_frame.${data_enum}_frame.checkbutton -variable [namespace which -variable s_use_explicit_pll_errors] -command "[namespace code on_check] $misc_window $next_button"
			Button ${misc_window}.data_frame.${data_enum}_frame.import_clock_uncertainties_button -text "Import clock uncertainties" -helptext "Import clock uncertainties from a Hardcopy II Clock Uncertainty (.CSV file)" -command "[namespace code on_import_clock_uncertainties] $misc_window" -pady 2

			# For now, store the indent in DATA_ENTRY_ARGS
			grid columnconfigure ${misc_window}.data_frame.${data_enum}_frame 0 -weight 0 -minsize $data_entry_args
			grid columnconfigure ${misc_window}.data_frame.${data_enum}_frame.checkbutton 1 -weight 0
			grid columnconfigure ${misc_window}.data_frame.${data_enum}_frame 2 -weight 1
			grid columnconfigure ${misc_window}.data_frame.${data_enum}_frame 3 -weight 0
			grid configure ${misc_window}.data_frame.${data_enum}_frame.checkbutton -row 0 -column 1 -sticky w
			grid configure ${misc_window}.data_frame.${data_enum}_frame.label -row 0 -column 2 -sticky w	
			grid configure ${misc_window}.data_frame.${data_enum}_frame.import_clock_uncertainties_button -row 0 -column 3 -sticky e
		} else {
			eval [list ::dtw::dtw_data_entry::dtw_data_entry ${misc_window}.data_frame.${data_enum}_frame $data_label -comboboxwidth 4 -entrywidth 8 -validatecommand "[namespace code validate_float] %P %V"] $data_entry_args
		}
	}
	frame ${misc_window}.data_frame.button_frame -borderwidth 4
	Button ${misc_window}.data_frame.button_frame.set_defaults_button -text "Defaults" -helptext "Set default values for all parameters" -command "[namespace code on_set_defaults] $misc_window $next_button" -pady 2
	Button ${misc_window}.data_frame.button_frame.extract_tcos_button -text "Extract tcos" -helptext "Set the tco parameters according to the results of the previous compilation" -command "[namespace code on_extract_tcos] $misc_window $next_button" -width 15 -pady 2

	pack ${misc_window}.data_frame -side top -fill both -expand 0
	pack ${misc_window}.data_frame.label -side top -fill x -anchor w
	pack ${misc_window}.data_frame.button_frame -side top -fill x
	pack ${misc_window}.data_frame.button_frame.set_defaults_button -side left -padx 4 -pady 4 -anchor w
	pack ${misc_window}.data_frame.button_frame.extract_tcos_button -side right -padx 4 -pady 4 -anchor e
	foreach data_type $s_misc_data_types {
		set min_max_data_enums [lindex $data_type $VARIABLE_NAME]
		set data_enum [lindex $min_max_data_enums 0]
		set data_optional [lindex $data_type $OPTIONAL]
		pack ${misc_window}.data_frame.${data_enum}_frame -side top -fill x -expand 0
		if {$data_optional == 0} {
			::dtw::dtw_data_entry::bind_to_entry ${misc_window}.data_frame.${data_enum}_frame <KeyRelease> "[namespace code on_entry_keyrelease] $misc_window $next_button"
			if {[lindex $min_max_data_enums 1] != ""} {
				::dtw::dtw_data_entry::bind_to_entry0 ${misc_window}.data_frame.${data_enum}_frame <KeyRelease> "[namespace code on_entry_keyrelease] $misc_window $next_button"
			}
		}
	}
	labelframe ${misc_window}.radio_frame
	radiobutton ${misc_window}.radio_frame.fast_and_slow_radio -anchor w -justify left -text "Both fast and slow timing model tcos (easiest to use, but will generate very conservative constraints because the entire range of tcos cannot exist on the same device)" -variable [namespace which -variable s_timing_model] -value "combined_fast_and_slow" -command "[namespace code on_radio] $misc_window $next_button"
	radiobutton ${misc_window}.radio_frame.slow_only_radio -anchor w -justify left -text "Slow timing model tcos (will require a separate DTW and timing analysis iteration with Fast timing model tcos)" -variable [namespace which -variable s_timing_model] -value "slow" -command "[namespace code on_radio] $misc_window $next_button"
	radiobutton ${misc_window}.radio_frame.fast_only_radio -anchor w -justify left -text "Fast timing model tcos (should only be used for final timing analysis, not for constraining the Quartus II fitter)" -variable [namespace which -variable s_timing_model] -value "fast" -command "[namespace code on_radio] $misc_window $next_button"
	pack ${misc_window}.radio_frame.fast_and_slow_radio -side top -fill x -padx 8
	pack ${misc_window}.radio_frame.slow_only_radio -side top -fill x -padx 8
	pack ${misc_window}.radio_frame.fast_only_radio -side top -fill x -padx 8
	pack ${misc_window}.radio_frame -side top -fill x -pady 4
	set radio_width 20
	bind ${misc_window}.radio_frame.fast_and_slow_radio <Configure> "${misc_window}.radio_frame.fast_and_slow_radio configure -wraplength \[expr %w - $radio_width\]"
	bind ${misc_window}.radio_frame.slow_only_radio <Configure> "${misc_window}.radio_frame.slow_only_radio configure -wraplength \[expr %w - $radio_width\]"
	bind ${misc_window}.radio_frame.fast_only_radio <Configure> "${misc_window}.radio_frame.fast_only_radio configure -wraplength \[expr %w - $radio_width\]"

	bind $misc_window <Map> "[namespace code update_next_state] $misc_window $next_button"
	bind ${misc_window}.data_frame.label <Configure> "${misc_window}.data_frame.label configure -wraplength %w"

	return $misc_window
}

# ----------------------------------------------------------------
#
proc dtw_misc::save_data {misc_window data_array_name} {
#
# Description: Save the data in this panel in the data_array
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	variable VARIABLE_NAME
	variable s_misc_data_types
    variable s_use_explicit_pll_errors
    variable s_timing_model

	# Data in the panel is saved in array:
	# set data_array(data_enum0) = {value0}
	# set data_array(data_enum1) = {value1}
	# ...
	foreach data_type $s_misc_data_types {
		set min_max_data_enums [lindex $data_type $VARIABLE_NAME]
		set data_enum [lindex $min_max_data_enums 0]
		if {$data_enum == "use_explicit_pll_errors"} {
			set data_array($data_enum) $s_use_explicit_pll_errors
		} elseif {[winfo exists ${misc_window}.data_frame.${data_enum}_frame] && [::dtw::dtw_data_entry::get_labels_state ${misc_window}.data_frame.${data_enum}_frame] == "normal" && [::dtw::dtw_data_entry::is_data_valid ${misc_window}.data_frame.${data_enum}_frame]} {
			set max_data_enum [lindex $min_max_data_enums 1]
			if {$max_data_enum != ""} {
				set data [::dtw::dtw_data_entry::get_data ${misc_window}.data_frame.${data_enum}_frame]
				if {[llength $data] == 3} {
					set data_array($data_enum) [list [lindex $data 0] [lindex $data 2]]
					set data_array($max_data_enum) [list [lindex $data 1] [lindex $data 2]]
				} elseif {[llength $data] == 2} {
					set data_array($data_enum) [lindex $data 0]
					set data_array($max_data_enum) [lindex $data 1]
				} else {
					error "Unexpected data retrieved for $data_enum and $max_data_enum"
				}
			} else {
				set data_array($data_enum) [::dtw::dtw_data_entry::get_data ${misc_window}.data_frame.${data_enum}_frame]
			}
		} else {
			# Remove invalid values from the array
			array unset data_array $data_enum
			set max_data_enum [lindex $min_max_data_enums 1]
			if {$max_data_enum != ""} {
				array unset data_array $max_data_enum
			}
		}
	}
	set data_array(timing_model) $s_timing_model

	return
}

# ----------------------------------------------------------------
#
proc dtw_misc::get_min_max_data {min_value max_value} {
#
# Description: Get the setting for dtw_data_entry with the 2 values
#
# ----------------------------------------------------------------
	set max_value_num [lindex $max_value 0]
	set min_value_num [lindex $min_value 0]
	set max_value_units [lindex $max_value 1]
	set min_value_units [lindex $min_value 1]

	# All min/max data has time units
	if {$max_value_units != $min_value_units && [string is double -strict $min_value_num] && [string is double -strict $max_value_num] && $min_value_units != "" && $max_value_units != ""} {
		set min_value_num [::dtw::dtw_timing::get_ns $min_value]
		set max_value_num [::dtw::dtw_timing::get_ns $max_value]
		set value_units "ns"
	} elseif {$max_value_units != $min_value_units} {
		if {[string is double -strict $min_value_num] && $min_value_units != ""} {
			set value_units $min_value_units
		} elseif {[string is double -strict $max_value_num] && $max_value_units != ""} {
			set value_units $max_value_units
		} else {
			set value_units "ns"
		}
	} elseif {$min_value_units != ""} {
		set value_units $min_value_units
	} else {
		set value_units "ns"
	}
	return [list $min_value_num $max_value_num $value_units]
}

# ----------------------------------------------------------------
#
proc dtw_misc::load_data {misc_window data_array_name} {
#
# Description: Load the data in this panel from the data_array
#
# ----------------------------------------------------------------
	variable s_misc_data_types
	variable s_data_array_list
	variable s_timing_model
    variable s_is_clk_fedback_in
	variable s_clock_uncertainties_path
	upvar $data_array_name data_array

	if {[array names data_array -exact "clock_uncertainties_path"] != ""} {
		set s_clock_uncertainties_path $data_array(clock_uncertainties_path)
	} else {
		set s_clock_uncertainties_path ""
	}

	# Get list of data enums need for timing analysis
	set s_data_array_list [array get data_array]
	set mode_name [::dtw::dtw_timing::get_ddr_interface_mode data_array]
	set data_enum_list [list]
	if {[::dtw::dtw_device_get_family_parameter $data_array(family) ${mode_name}_misc_parameters data_enum_list] == 0} {
		::dtw::dtw_device_get_family_parameter "_default" ${mode_name}_misc_parameters data_enum_list
	}

	# Set memory-specific labels
	::dtw::dtw_device_get_family_parameter "_default" $data_array(memory_type)_user_terms mem_user_term_list
	array set mem_user_term $mem_user_term_list
	unset mem_user_term_list
	if {[lsearch -exact $data_enum_list "fb_clk_max_tco"] == -1 && [lsearch -exact $data_enum_list "fb_clk_max_tco"] == -1 } {
		${misc_window}.radio_frame configure -text "Generate $mem_user_term(read_dqs) input clock latencies using"
	} else {
		${misc_window}.radio_frame configure -text "Generate fedback/$mem_user_term(read_dqs) input clock latencies using"
	}
	::dtw::dtw_data_entry::set_label ${misc_window}.data_frame.sys_clk_slow_min_tco_frame "Estimated slow model tco to the $mem_user_term(ck)/$mem_user_term(ckn) system clock output pins"
	::dtw::dtw_data_entry::set_label ${misc_window}.data_frame.sys_clk_min_tco_frame "Estimated fast model tco to the $mem_user_term(ck)/$mem_user_term(ckn) system clock output pins"
	::dtw::dtw_data_entry::set_label ${misc_window}.data_frame.pll_dc_distortion_frame "Duty cycle distortion error of $mem_user_term(ck)/$mem_user_term(ckn) system clock output pins with PLL"

	# Remove all const enums
	set const_term_list [list]
	if {[::dtw::dtw_device_get_family_parameter $data_array(family) const_terms const_term_list] == 0} {
		::dtw::dtw_device_get_family_parameter "_default" const_terms const_term_list
	}
	array set const_term_array $const_term_list
	unset const_term_list
	set const_enum_list [array names const_term_array]
	foreach const_enum $const_enum_list {
		set const_index [lsearch -exact $data_enum_list $const_enum]
		if {$const_index != -1} {
			set data_enum_list [lreplace $data_enum_list $const_index $const_index]
		}
	}
	unset const_enum_list

	::dtw::dtw_device_get_family_parameter "_default" user_terms user_term_list
	if {[::dtw::dtw_device_get_family_parameter $data_array(family) user_terms family_user_term_list]} {
		set user_term_list [concat $user_term_list $family_user_term_list]
	}
	array set user_term_array $user_term_list
	unset user_term_list

	# Hide lines for unused/const enums; for the rest, set data
	variable VARIABLE_NAME
	variable s_use_explicit_pll_errors
	foreach data_type $s_misc_data_types {
		set min_max_data_enums [lindex $data_type $VARIABLE_NAME]
		set data_enum [lindex $min_max_data_enums 0]
		if {$data_enum == "use_explicit_pll_errors"} {
			if {[array names data_array -exact $data_enum] != ""} {
				set s_use_explicit_pll_errors $data_array($data_enum)
			}
		} elseif {[lsearch -exact $data_enum_list $data_enum] == -1} {
			pack forget ${misc_window}.data_frame.${data_enum}_frame
			destroy ${misc_window}.data_frame.${data_enum}_frame
		} else {
			set max_data_enum [lindex $min_max_data_enums 1]
			if {$max_data_enum != ""} {
				# min/max entry row
				if {[array names user_term_array -exact $data_enum] != ""} {
					::dtw::dtw_data_entry::set_user_term_label_text ${misc_window}.data_frame.${data_enum}_frame "($user_term_array($data_enum), $user_term_array($max_data_enum))"
				} else {
					::dtw::dtw_data_entry::set_user_term_label_text ${misc_window}.data_frame.${data_enum}_frame "(${data_enum}, ${max_data_enum})"
				}
				if {[array names data_array -exact $max_data_enum] == ""} {
					set max_value [get_default_parameter data_array $max_data_enum]
				} else {
					set max_value $data_array($max_data_enum)
				}
				if {[array names data_array -exact $data_enum] == ""} {
					set min_value [get_default_parameter data_array $data_enum]
				} else {
					set min_value $data_array($data_enum)
				}
				if {$max_value != ""} {
					::dtw::dtw_data_entry::set_data ${misc_window}.data_frame.${data_enum}_frame [get_min_max_data $min_value $max_value]
				}
				unset min_value
				unset max_value
			} else {
				# single entry row
				if {[array names user_term_array -exact $data_enum] != ""} {
					::dtw::dtw_data_entry::set_user_term_label_text ${misc_window}.data_frame.${data_enum}_frame "($user_term_array($data_enum))"
				} else {
					::dtw::dtw_data_entry::set_user_term_label_text ${misc_window}.data_frame.${data_enum}_frame "(${data_enum})"
				}
				if {[array names data_array -exact $data_enum] == ""} {
					set value [get_default_parameter data_array $data_enum]
				} else {
					set value $data_array($data_enum)
				}
				if {$value != ""} {
					::dtw::dtw_data_entry::set_data ${misc_window}.data_frame.${data_enum}_frame $value
				}
				unset value
			}
		}
	}
	if {[array names data_array -exact timing_model] != ""} {
		set s_timing_model $data_array(timing_model)
	}
	if {[array names data_array -exact is_clk_fedback_in] != ""} {
		set s_is_clk_fedback_in $data_array(is_clk_fedback_in)
	}

	if {$data_array(device) != ""} {
		${misc_window}.data_frame.button_frame.set_defaults_button configure -text "Defaults for [string toupper $data_array(device)]"
	} else {
		# No defaults available for unknown devices
		${misc_window}.data_frame.button_frame.set_defaults_button configure -state disabled
	}

	if {([lsearch -exact $data_enum_list "sys_clk_max_tco"] == -1 && [lsearch -exact $data_enum_list "sys_clk_min_tco"] == -1 && [lsearch -exact $data_enum_list "fb_clk_max_tco"] == -1 && [lsearch -exact $data_enum_list "fb_clk_min_tco"] == -1) || $data_array(timing_model) == "separate_slow_and_fast"} {
		pack forget ${misc_window}.data_frame.label
		pack forget ${misc_window}.data_frame.button_frame.extract_tcos_button
		pack forget ${misc_window}.radio_frame

		set tco_list [list sys_clk_slow_min_tco sys_clk_min_tco fb_clk_slow_min_tco fb_clk_min_tco]
		foreach data_enum $tco_list {
			pack forget ${misc_window}.data_frame.${data_enum}_frame
			destroy ${misc_window}.data_frame.${data_enum}_frame
		}
	} elseif {$::dtw::s_auto_extract_tcos} {
		do_extract_tcos $misc_window
	}


	if {$::dtw::s_auto_import_clock_uncertainties} {
		do_clock_uncertainties_import $misc_window $s_clock_uncertainties_path
	}
	on_check $misc_window ""

	return
}

# ----------------------------------------------------------------
#
proc dtw_misc::validate_float {number validation_type} {
#
# Description: Get the data in this panel
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
proc dtw_misc::on_set_defaults { misc_window next_button } {
#
# Description: Sets all parameters to their default values
#
# ----------------------------------------------------------------
	variable VARIABLE_NAME
    variable s_misc_data_types
	variable s_data_array_list
	variable s_use_explicit_pll_errors

	array set data_array $s_data_array_list
	set s_use_explicit_pll_errors 0
	on_check $misc_window $next_button
	foreach data_type $s_misc_data_types {
		set min_max_data_enums [lindex $data_type $VARIABLE_NAME]
		set data_enum [lindex $min_max_data_enums 0]
		if {$data_enum != "use_explicit_pll_errors" && [winfo exists ${misc_window}.data_frame.${data_enum}_frame]} {
			set max_data_enum [lindex $min_max_data_enums 1]
			if {$max_data_enum != ""} {
				# min/max entry row
				set default_min_value [get_default_parameter data_array $data_enum]
				set default_max_value [get_default_parameter data_array $max_data_enum]
				
				::dtw::dtw_data_entry::set_data ${misc_window}.data_frame.${data_enum}_frame [get_min_max_data $default_min_value $default_max_value]
			} else {
				# single entry row
				set default_value [get_default_parameter data_array $data_enum]
				::dtw::dtw_data_entry::set_data ${misc_window}.data_frame.${data_enum}_frame $default_value
			}
		}
	}

	update_next_state $misc_window $next_button
}

# ----------------------------------------------------------------
#
proc dtw_misc::on_extract_tcos { misc_window next_button } {
#
# Description: "Extract tcos" button processing
#
# ----------------------------------------------------------------
	do_extract_tcos $misc_window
	update_next_state $misc_window $next_button
	::dtw::msg_wait_end $misc_window
}

# ----------------------------------------------------------------
#
proc dtw_misc::do_extract_tcos { misc_window } {
#
# Description: Extract tcos based on previously compiled fit
#
# ----------------------------------------------------------------
	variable s_data_array_list
	array set data_array $s_data_array_list

	set tmp_file_name "$data_array(output_filename).tmp"

	package require ::quartus::dtw_dwz

	::dtw::msg_wait_begin "Extracting tcos...." $misc_window
	::quartus::dtw_dwz::write_dwz data_array "$tmp_file_name"

	# Run the extract_tco script under quartus_tan
	package require ::quartus::flow
	if {[is_project_open] == 1} {
		# SPR 224267 - make sure all assignments are committed to disk first
		export_assignments
	}
	if {[catch "exec -keepnewline -- ${::dtw::s_quartus_dir}quartus_tan -t ${::dtw::s_dtw_dir}dtw_extract_tco.tcl \"$tmp_file_name\"" tco_result]} {
		puts $tco_result
	} else {
		puts $tco_result
		::quartus::dtw_dwz::read_dwz data_array "$tmp_file_name"

		# set the UI values
		set extracted_enums_list [list sys_clk_slow_min_tco sys_clk_max_tco sys_clk_min_tco sys_clk_fast_max_tco]
		if {$data_array(is_clk_fedback_in)} {
			lappend extracted_enums_list fb_clk_slow_min_tco fb_clk_max_tco fb_clk_min_tco fb_clk_fast_max_tco 
		}
		foreach {min_data_enum max_data_enum} $extracted_enums_list {
			if {[array names data_array -exact "$min_data_enum"] != "" && [array names data_array -exact "$max_data_enum"] != ""} {
				set min_value $data_array($min_data_enum)
				set max_value $data_array($max_data_enum)
				::dtw::dtw_data_entry::set_data ${misc_window}.data_frame.${min_data_enum}_frame [get_min_max_data $min_value $max_value]
			}
		}
	}
	::dtw::msg_wait_end $misc_window
}

# ----------------------------------------------------------------
#
proc dtw_misc::on_entry_keyrelease { misc_window next_button } {
#
# Description: Get the data in this panel
#
# ----------------------------------------------------------------
	update_next_state $misc_window $next_button
}

# ----------------------------------------------------------------
#
proc dtw_misc::update_next_state { misc_window next_button } {
#
# Description: Tells if the "Next" button should be enabled and changes its
#              state accordingly.
#
# ----------------------------------------------------------------
	variable s_misc_data_types
	variable s_timing_model

	set enable 1
	variable VARIABLE_NAME
	variable OPTIONAL 2
	foreach data_type $s_misc_data_types {
		set min_max_data_enums [lindex $data_type $VARIABLE_NAME]
		set data_enum [lindex $min_max_data_enums 0]
		if {$data_enum != "use_explicit_pll_errors" && [winfo exists ${misc_window}.data_frame.${data_enum}_frame] && [::dtw::dtw_data_entry::get_labels_state ${misc_window}.data_frame.${data_enum}_frame] == "normal"} {
			set data_optional [lindex $data_type $OPTIONAL]
			if {$data_optional == 1 || [::dtw::dtw_data_entry::is_data_valid ${misc_window}.data_frame.${data_enum}_frame]} {
				# data good
			} else {
				# data required - disable Next button
				set enable 0
			}
		}
	}
	if {$next_button != "" } {
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
proc dtw_misc::on_next { misc_window } {
#
# Description: Handles the "Next" button event
#
# ----------------------------------------------------------------
	if {[update_next_state $misc_window ""]} {
		set result "next"
	} else {
		::dtw::msg_o "Error" "Missing required data"
		set result "none"
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_misc::get_default_parameter { data_array_name data_enum } {
#
# Description: Sets defaults for all parameters
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array

	set default_value ""
	if {$data_enum == "sys_clk_slow_min_tco" || $data_enum == "fb_clk_slow_min_tco"} {
		set data_enum "sys_clk_max_tco"
	} elseif {$data_enum == "sys_clk_fast_max_tco" || $data_enum == "fb_clk_fast_max_tco"} {
		set data_enum "sys_clk_min_tco"
	}
	if {$data_enum == "sys_clk_min_tco" || $data_enum == "fb_clk_min_tco"} {
		::dtw::dtw_device_get_timing_parameter $data_array(family) "m" $data_enum default_value
	} elseif {$data_enum == "fpga_tCLOCK_SKEW_ADDER"} {
		set default_value ""
		if {[::dtw::dtw_device_get_family_parameter $data_array(family) fpga_tCLOCK_SKEW_ADDER_$data_array(density) default_value] == 0} {
			::dtw::dtw_device_get_family_parameter $data_array(family) fpga_tCLOCK_SKEW_ADDER default_value
		}
	} elseif {$data_enum == "pll_dc_distortion"} {
		set default_value ""
		if {[::dtw::dtw_device_get_timing_parameter $data_array(family) $data_array(speed_grade) pll_dc_distortion_$data_array(memory_type) default_value] == 0} {
			if {[::dtw::dtw_device_get_timing_parameter $data_array(family) $data_array(speed_grade) pll_dc_distortion default_value] == 0} {
				if {[::dtw::dtw_device_get_family_parameter $data_array(family) pll_dc_distortion_$data_array(memory_type) default_value] == 0} {
					::dtw::dtw_device_get_family_parameter $data_array(family) pll_dc_distortion default_value
				}
			}
		}
	} else {
		if {[::dtw::dtw_device_get_timing_parameter $data_array(family) $data_array(speed_grade) $data_enum default_value] == 0} {
			::dtw::dtw_device_get_family_parameter $data_array(family) $data_enum default_value
		}
	}
	return [split $default_value]
}


# ----------------------------------------------------------------
#
proc dtw_misc::on_radio {misc_window next_button} {
#
# Description: Called when a radio button is selected
#
# Returns:     nothing
#
# ----------------------------------------------------------------
	update_next_state $misc_window $next_button
	return
}

# ----------------------------------------------------------------
#
proc dtw_misc::on_check { misc_window next_button } {
#
# Description: Called when the user clicks a checkbutton
#
# ----------------------------------------------------------------
	variable s_use_explicit_pll_errors
	variable s_misc_data_types
	set basic_pll_errors {\
			fpga_tCLOCK_SKEW_ADDER \
			fpga_tOUTJITTER \
			fpga_tPLL_COMP_ERROR \
			fpga_tPLL_PSERR}
	set advanced_pll_errors {\
			fpga_tREAD_CAPTURE_SETUP_ERROR \
			fpga_tREAD_CAPTURE_HOLD_ERROR \
			fpga_tRDDQS_FBPLL_SETUP_ERROR \
			fpga_tRDDQS_FBPLL_HOLD_ERROR \
			fpga_tFBPLL_SYSPLL_SETUP_ERROR \
			fpga_tFBPLL_SYSPLL_HOLD_ERROR \
			fpga_tRDDQS_SYSPLL_SETUP_ERROR \
			fpga_tRDDQS_SYSPLL_HOLD_ERROR \
			fpga_tQ_FBPLL_SETUP_ERROR \
			fpga_tQ_FBPLL_HOLD_ERROR \
			fpga_tQ_SYSPLL_SETUP_ERROR \
			fpga_tQ_SYSPLL_HOLD_ERROR \
			fpga_tD_WRDQS_SETUP_ERROR \
			fpga_tD_WRDQS_HOLD_ERROR \
			fpga_tCK_ADDR_CTRL_SETUP_ERROR \
			fpga_tCK_ADDR_CTRL_HOLD_ERROR \
			fpga_tCK_WRDQS_SETUP_ERROR \
			fpga_tCK_WRDQS_HOLD_ERROR \
		}
	if {$s_use_explicit_pll_errors} {
		${misc_window}.data_frame.use_explicit_pll_errors_frame.import_clock_uncertainties_button configure -state normal
		set hide_list $basic_pll_errors
		set show_list $advanced_pll_errors
	} else {
		${misc_window}.data_frame.use_explicit_pll_errors_frame.import_clock_uncertainties_button configure -state disabled
		set show_list $basic_pll_errors
		set hide_list $advanced_pll_errors
	}
	foreach data_enum $hide_list {
		if {[winfo exists ${misc_window}.data_frame.${data_enum}_frame]} {
			pack forget ${misc_window}.data_frame.${data_enum}_frame
			::dtw::dtw_data_entry::set_labels_state ${misc_window}.data_frame.${data_enum}_frame disabled
		}
	}
	foreach data_enum $show_list {
		if {[winfo exists ${misc_window}.data_frame.${data_enum}_frame]} {
			pack ${misc_window}.data_frame.${data_enum}_frame -side top -fill x -expand 0
			::dtw::dtw_data_entry::set_labels_state ${misc_window}.data_frame.${data_enum}_frame normal
		}
	}
	if {$next_button != ""} {
		update_next_state $misc_window $next_button
	}
}

# ----------------------------------------------------------------
#
proc dtw_misc::on_import_clock_uncertainties { misc_window } {
#
# Description: Called when the user Clicks the import uncertainties button
#
# ----------------------------------------------------------------
	variable s_clock_uncertainties_path
	set file_types {
		{{Comma Separated Files} {.csv}}
		{{All Files}        *             }
	}

	set current_import "$s_clock_uncertainties_path"
	if {$current_import != ""} {
		if {[file isdirectory "$current_import"]} {
			set import_dir $current_import
			set import_filename ""
		} else {
			set import_dir "[file dirname $current_import]"
			set import_filename "[file tail $current_import]"
			if {[file isdirectory "$import_dir"] == 0} {
				set import_dir ""
			}
		}
	} else {
		set import_dir ""
		set import_filename ""
	}
	if {$import_dir != ""} {
		set import_file [tk_getOpenFile -title "Open Clock Uncertainties spreadsheet (*.csv)" -defaultextension .csv -filetypes $file_types -initialdir "$import_dir" -initialfile $import_filename]
	} else {
		set import_file [tk_getOpenFile -title "Open Clock Uncertainties spreadsheet (*.csv)" -defaultextension .csv -filetypes $file_types]
	}

	if {$import_file != ""} {
		do_clock_uncertainties_import $misc_window $import_file
	} else {
		# User cancelled the import operation
	}
}

# ----------------------------------------------------------------
#
proc dtw_misc::get_csv_cell { csv_file_id cell_coord } {
#
# Description: Called to import a cell from the given file
#
# ----------------------------------------------------------------
	set col_num [lindex $cell_coord 0]
	set row_num [lindex $cell_coord 1]
	set result ""

	if {[string is integer -strict $col_num] && [string is integer -strict $row_num]} {
		# Go to row_num,col_num
		seek $csv_file_id 0 start
		set str_length 0
		for {set row_index 0} {$row_index != $row_num && $str_length != -1} {incr row_index} {
			set str_length [gets $csv_file_id line]
		}
		if {$row_index == $row_num} {
			set col_list [split $line ","]
			set result [lindex $col_list [expr $col_num - 1]]
		}
	}

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_misc::get_csv_coord { cell_location } {
#
# Description: Called to get the cell coordinates of the given spreadsheet
#              location
#
# Returns:     Pair [list col row] of 1-based numbers for the given cell
#              location, or empty list if unknown
#
# ----------------------------------------------------------------
	set result [list]
	if {[regexp -- {^([a-z]+)([0-9]+)} $cell_location -> col row_num]} {
		# Convert col letters to a 1-based number
		set str_length [string length $col]
		set col_num 0
		set alphabet "abcdefghijklmnopqrstuvwxyz"
		for {set i 0} {$i != $str_length} {incr i} {
			set char [string index $col $i]
			set col_num [expr 26 * $col_num + [string first $char $alphabet] + 1]
		}
		set result [list $col_num $row_num]
	}
	return $result
}
# ----------------------------------------------------------------
#
proc dtw_misc::find_csv_cell { csv_file_id begin_cell_coord end_cell_coord target} {
#
# Description: Called to find a cell with the given string in the given file
#
# Returns:     Pair [list col row] of 1-based numbers for the given cell
#              location, or empty list if unknown
#
# ----------------------------------------------------------------
	set result [list]
	if {[llength $begin_cell_coord] == 2 && [llength $end_cell_coord] == 2} {
		# Go to row_num,col_num
		# Adjust inputs to be 0-based
		set begin_col [expr [lindex $begin_cell_coord 0] - 1]
		set begin_row [expr [lindex $begin_cell_coord 1] - 1]
		set end_col [expr [lindex $end_cell_coord 0] - 1]
		set end_row [expr [lindex $end_cell_coord 1] - 1]
		seek $csv_file_id 0 start
		set str_length 0
		for {set row_index 0} {$row_index != $begin_row && $str_length != -1} {incr row_index} {
			set str_length [gets $csv_file_id line]
		}
		if {$row_index == $begin_row} {
			for {} {$row_index != $end_row && $str_length != -1 && [llength $result] != 2} {incr row_index} {
				set str_length [gets $csv_file_id line]
				set col_list [split $line ","]
				set col_list_length [llength $col_list]
				if {$end_col < $col_list_length} {
					set col_list_length $end_col
				}
				# Search columns
				for {set col_index $begin_col} {$col_index < $col_list_length && [lindex $col_list $col_index] != $target} {incr col_index} {
				}
				if {$col_index != $col_list_length} {
					# Return 1-based col value
					set result [list [expr $col_index + 1] [expr $row_index + 1]]
				}
			}
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_misc::set_explicit_clock_uncertainties { misc_window setup_data_enum setup_uncertainty_value hold_data_enum hold_uncertainty_value} {
#
# Description: Sets the given uncertainty to the given value
#
# ----------------------------------------------------------------
	if {![string is integer -strict $setup_uncertainty_value]} {
		set setup_uncertainty_value ""
	}
	if {![string is integer -strict $hold_uncertainty_value]} {
		set hold_uncertainty_value ""
	}
	if {[winfo exists ${misc_window}.data_frame.${setup_data_enum}_frame]} {
		::dtw::dtw_data_entry::set_data ${misc_window}.data_frame.${setup_data_enum}_frame [list $setup_uncertainty_value $hold_uncertainty_value "ps"]
		set success 1
	} else {
		set success 0
	}
	return $success
}

# ----------------------------------------------------------------
#
proc dtw_misc::do_clock_uncertainties_import {misc_window csv_file} {
#
# Description: Called to import the given file
#
# Returns:     1 if successful, 0 if failed
#
# ----------------------------------------------------------------
	variable s_is_clk_fedback_in

	if {[catch "open \"$csv_file\" r" csv_file_id]} {
		::dtw::msg_o "Error: $csv_file" "Cannot open file $csv_file.  Please enter a valid filename for the data file and make sure you have read access permission"
		set result 0
	} else {
		set result 1
		# Read the CSV file
		set cell_map [list]

		# Search for the top left corner of the table
		set read_coord [find_csv_cell $csv_file_id [get_csv_coord "a1"] [get_csv_coord "f15"] "Read"]
		if {[llength $read_coord] == 2 && [get_csv_cell $csv_file_id $read_coord] == "Read"} {
			set setup_col [expr [lindex $read_coord 0] + 1]
			set hold_col [expr [lindex $read_coord 0] + 2]
			set read_row_index [lindex $read_coord 1]
			lappend cell_map \
					fpga_tREAD_CAPTURE_SETUP_ERROR [list $setup_col [expr $read_row_index + 1]] fpga_tREAD_CAPTURE_HOLD_ERROR [list $hold_col [expr $read_row_index + 1]]
			if {$s_is_clk_fedback_in == 1} {
				lappend cell_map \
					fpga_tRDDQS_FBPLL_SETUP_ERROR [list $setup_col [expr $read_row_index + 2]] fpga_tRDDQS_FBPLL_HOLD_ERROR [list $hold_col [expr $read_row_index + 2]] \
					fpga_tFBPLL_SYSPLL_SETUP_ERROR [list $setup_col [expr $read_row_index + 4]] fpga_tFBPLL_SYSPLL_HOLD_ERROR [list $hold_col [expr $read_row_index + 4]] \
			} else {
				lappend cell_map \
						fpga_tRDDQS_SYSPLL_SETUP_ERROR [list $setup_col [expr $read_row_index + 2]] fpga_tRDDQS_SYSPLL_HOLD_ERROR [list $hold_col [expr $read_row_index + 2]]
			}
			lappend cell_map \
					fpga_tD_WRDQS_SETUP_ERROR [list $setup_col [expr $read_row_index + 8]] fpga_tD_WRDQS_HOLD_ERROR [list $hold_col [expr $read_row_index + 8]] \
					fpga_tCK_ADDR_CTRL_SETUP_ERROR [list $setup_col [expr $read_row_index + 9]] fpga_tCK_ADDR_CTRL_HOLD_ERROR [list $hold_col [expr $read_row_index + 9]] \
					fpga_tCK_WRDQS_SETUP_ERROR [list $setup_col [expr $read_row_index + 10]] fpga_tCK_WRDQS_HOLD_ERROR [list $hold_col [expr $read_row_index + 10]]
		}
		if {$cell_map == [list]} {
			::dtw::msg_o "Error: $csv_file" "No uncertainties found"
			set result 0
		} else {
			foreach {setup_data_enum setup_cell hold_data_enum hold_cell} $cell_map {
				if {[set_explicit_clock_uncertainties $misc_window $setup_data_enum [get_csv_cell $csv_file_id $setup_cell] $hold_data_enum [get_csv_cell $csv_file_id $hold_cell]] == 0} {
					set result 0
				} else {
				}
			}
			if {$result == 0} {
				::dtw::msg_o "Error" "Clock uncertainty importing not supported for the current memory interface configuration"
			}
		}
	}
	return $result
}
