::dtw::add_version_date {$Date: 2009/04/01 $}

##############################################################################
#
# File Name:    dtw_import_panel.tcl
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
namespace eval dtw_import {
#
# Description: Namespace to encapsulate the title panel
#
# ----------------------------------------------------------------
	variable s_import_path
	variable s_data_array_list
	variable s_use_timequest_names

	# Source everything to get the latest version date
	source ${::dtw::s_dtw_dir}dtw_ip_import.tcl
}


# ----------------------------------------------------------------
#
proc dtw_import::panel { import_window next_button args } {
#
# Description: Show the wizard panel
#
# ----------------------------------------------------------------
	variable s_use_timequest_names

	frame $import_window -padx 12 -pady 12

	labelframe ${import_window}.import_frame -text "Import Wizard Data" -pady 3 -padx 4
	label ${import_window}.import_frame.import_label -text "Would you like to import data from the DDR/DDR2 SDRAM, QDRII/QDRII+ SRAM, or RLDRAM II Controller Megawizard?" -anchor w -justify left
	frame ${import_window}.import_frame.import_entry_frame
	radiobutton ${import_window}.import_frame.use_timequest_names_radiobutton -variable [namespace which -variable s_use_timequest_names] -value 0 -text "Import Classic Timing Analyzer names" -anchor w -justify left
	radiobutton ${import_window}.import_frame.use_tan_names_radiobutton -variable [namespace which -variable s_use_timequest_names] -value 1 -text "Import TimeQuest Timing Analyzer names (this will disable requirement generation for the Classic Timing Analyzer)" -anchor w -justify left
	Button ${import_window}.import_frame.import_entry_frame.button -text "Import...." -helptext "Import data from DDR SDRAM/DDR2 SDRAM/QDRII SRAM/RLDRAM II Controller Megawizard *_settings.txt output" -command "[namespace code on_import_explore] $import_window" -width 12 -pady 2

	pack ${import_window}.import_frame.import_entry_frame.button

	pack ${import_window}.import_frame.import_label -side top -fill x
	pack ${import_window}.import_frame.use_timequest_names_radiobutton -side top -fill x
	pack ${import_window}.import_frame.use_tan_names_radiobutton -side top -fill x
	pack ${import_window}.import_frame.import_entry_frame -side top -fill x -padx 24
	pack ${import_window}.import_frame -side top -fill x -ipadx 4 -ipady 3

	$next_button configure -state normal

	bind ${import_window}.import_frame.import_label <Configure> "${import_window}.import_frame.import_label configure -wraplength %w"
	bind ${import_window}.import_frame.use_tan_names_radiobutton <Configure> "${import_window}.import_frame.use_tan_names_radiobutton configure -wraplength %w"

	return $import_window
}


# ----------------------------------------------------------------
#
proc dtw_import::save_data {import_window data_array_name} {
#
# Description: Get the data in this panel into the data_array
#
# ----------------------------------------------------------------
	variable s_import_path
	variable s_data_array_list
	variable s_use_timequest_names
	upvar $data_array_name data_array

	array set data_array $s_data_array_list
	set data_array(import_path) "[::dtw::get_relative_filename [pwd] $s_import_path]"

	foreach var $::dtw::s_get_list {
		if {[array names data_array -exact $var] != ""} {
			puts "DTW get($var)=$data_array($var)"
		}
	}

	set number_of_sets [llength $::dtw::s_set_list]
	foreach {var value} $::dtw::s_set_list {
		set data_array($var) $value
		puts "DTW set($var,$value)"
	}
	set data_array(use_timequest_names) $s_use_timequest_names
	if {$data_array(use_timequest_names)} {
		# Get into TimeQuest-only mode with TimeQuest only names
		set data_array(timing_model) "separate_slow_and_fast"
	} elseif {!$data_array(use_timequest) && $data_array(timing_model) == "separate_slow_and_fast"} {
		# Using TAN names and project is not using TimeQuest.
		# If in TimeQuest-only mode, get out of it
		set data_array(timing_model) "combined_fast_and_slow"
	}

	return
}

# ----------------------------------------------------------------
#
proc dtw_import::load_data {import_window data_array_name} {
#
# Description: Set the data in this panel according to get_data
#
# ----------------------------------------------------------------
	variable s_import_path
	variable s_data_array_list
	variable s_use_timequest_names
	upvar $data_array_name data_array

	if {[array names data_array -exact "import_path"] != ""} {
		set s_import_path $data_array(import_path)
	} else {
		set s_import_path ""
	}
	set s_data_array_list [array get data_array]
	if {$data_array(input_source) == "edit"} {
		${import_window}.import_frame.import_label configure -text "Would you like to update data from the DDR SDRAM, DDR2 SDRAM, QDRII SRAM, or RLDRAM II Controller Megawizard?"
	}
	array set set_array $::dtw::s_set_list
	if {[array names set_array -exact "use_timequest_names"] != ""} {
		set s_use_timequest_names $set_array(use_timequest_names)
	} elseif {[array names data_array -exact "use_timequest_names"] != ""} {
		set s_use_timequest_names $data_array(use_timequest_names)
	} else {
		set s_use_timequest_names 0
	}
	if {$::dtw::s_auto_import} {
		puts "Importing data from $s_import_path...."
		do_import $s_import_path
	}
	return
}

# ----------------------------------------------------------------
#
proc dtw_import::on_import_explore { import_window } {
#
# Description: Show explorer for the import file
#
# ----------------------------------------------------------------
	variable s_import_path
	set file_types {
		{{Text Files} {.txt}}
		{{All Files}        *             }
	}

	set current_import "$s_import_path"
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
		set import_file [tk_getOpenFile -title "Open Megawizard data file (*_settings.txt)" -defaultextension .txt -filetypes $file_types -initialdir "$import_dir" -initialfile $import_filename]
	} else {
		set import_file [tk_getOpenFile -title "Open Megawizard data file (*_settings.txt)" -defaultextension .txt -filetypes $file_types]
	}

	if {[winfo exists ${import_window}.import_frame.done_label]} {
		destroy ${import_window}.import_frame.done_label
	}
		
	::dtw::msg_wait_begin "Processing...." $import_window
	do_import $import_file
	::dtw::msg_wait_end $import_window
	if {[winfo exists ${import_window}.import_frame.done_label] == 0} {
		label ${import_window}.import_frame.done_label -text "Import processing complete"
		pack ${import_window}.import_frame.done_label -side bottom -fill x
	}
}

# ----------------------------------------------------------------
#
proc dtw_import::do_import { import_file } {
#
# Description: Perform the data import
#
# ----------------------------------------------------------------
	variable s_import_path
	variable s_data_array_list
	variable s_use_timequest_names

	array set data_array $s_data_array_list
	if {[file exists "$import_file"] && [file isfile "$import_file"]} {
		set s_import_path $import_file
		set data_array(use_timequest_names) $s_use_timequest_names
		catch {dtw_ddr_ip_import::import_data $s_import_path data_array} import_result
		puts $import_result
		set s_data_array_list [array get data_array]
	}
}
