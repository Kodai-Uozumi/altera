if {[namespace exists ::dtw]} {
	::dtw::add_version_date {$Date: 2009/04/01 $}
}

##############################################################################
#
# File Name:    dtw_sta_names.tcl
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

package require ::quartus::dtw_dwz

# ----------------------------------------------------------------
#
namespace eval dtw_sta_names {
#
# Description: Top-level namespace for the auto-detection code
#
# ----------------------------------------------------------------
	variable s_dtw_dir ${quartus(tclpath)}apps/dtw/

	# Force auto-loading packages to load immediately by sourcing them,
    # otherwise their namespaces will be empty and nothing will import.
    # This is a common Tcl 8.0 bug documented in
    # http://www.wjduquette.com/tcl/namespaces.html
	source ${quartus(tclpath)}packages/dtw/dtw_dwz.tcl
	namespace import ::quartus::dtw_dwz::*
}

# ----------------------------------------------------------------
#
proc dtw_sta_names::net_to_sta { net_name } {
#
# Description: Translates a net name to a TimeQuest name
#
# ----------------------------------------------------------------
	set sta_name $net_name
	foreach_in_collection net_id [get_nets -nowarn $net_name] {
		set pin_id [get_net_info -pin $net_id]
		set sta_name [get_pin_info -name $pin_id]
	}
	return $sta_name
}

# ----------------------------------------------------------------
#
proc dtw_sta_names::do_translations { data_array_name } {
#
# Description: Do the work to translate all names to TimeQuest names
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array

	# Get clocks needing translation
	set dwz_keys [array names data_array]
	set translate_keys [list]
	foreach key $dwz_keys {
		if {[string range $key 0 3] == "clk_"} {
			lappend translate_keys $key
		}
	}

	# Do clock translations
	foreach key $translate_keys {
		set data_array($key) [net_to_sta $data_array($key)]
	}

	if {[array names data_array -exact dqs_postamble_list] != ""} {
		# Do postamble reg translations
		set translated_dqs_postamble_list [list]
		foreach {dqs postamble_list} $data_array(dqs_postamble_list) {
			set translated_reg_list [list]
			foreach reg $postamble_list {
				lappend translated_reg_list [net_to_sta $reg]
			}
			lappend translated_dqs_postamble_list $dqs $translated_reg_list
		}
		set data_array(dqs_postamble_list) $translated_dqs_postamble_list
	}
}

# ----------------------------------------------------------------
#
proc dtw_sta_names::translate_to_sta_names { argv } {
#
# Description: Main entry point to translates all clock and register names
#              to TimeQuest names
#
# ----------------------------------------------------------------
	global quartus
	package require ::quartus::sta

	set dwz_file [lindex $argv 0]
	set msg_list [list]

	array set data_array [list]
	read_dwz data_array $dwz_file
	set project_name [file tail [file rootname "$data_array(project_path)"]]
	set revision_name $data_array(project_revision)

	# Open project
	project_open $project_name -revision $revision_name
	create_timing_netlist -post_map
	
	do_translations data_array

	# All done - Clean up
	delete_timing_netlist
	project_close

	# Return result is written to the dwz file
	write_dwz data_array $dwz_file
	return
}

if {[namespace exists ::dtw] == 0} {
	dtw_sta_names::translate_to_sta_names $quartus(args)
}
