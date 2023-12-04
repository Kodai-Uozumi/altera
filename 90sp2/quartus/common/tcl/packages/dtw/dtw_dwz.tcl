##############################################################################
#
# File Name:    dtw_dwz.tcl
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

package provide ::quartus::dtw_dwz 1.0

# ----------------------------------------------------------------
#
namespace eval ::quartus::dtw_dwz {
#
# Description: Initialize all internal variables
#
# ----------------------------------------------------------------
	namespace export read_dwz
	namespace export write_dwz
	namespace export get_dtw_dwz_version
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_dwz::get_dtw_dwz_version { } {
#
# Description: Get the package version
#
# ----------------------------------------------------------------
	return {$Date: 2009/04/01 $}
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_dwz::write_dwz { data_array_name output_filename } {
#
# Description: Save wizard state in file
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array
	
	# Save the results in data_array
	set output_file [open "$output_filename" w]

	# Don't bother saving new timing requirements (in .tcl.out and .sdc)
	array unset data_array "new_req_list"
	array unset data_array "sdc_req_list"
	array unset data_array "other_new_req_list"
	array unset data_array "other_sdc_req_list"

	# Don't bother saving temporaries
	array unset data_array "check_list"
	array unset data_array "reason_list"
	array unset data_array "sdc_reason_list"
	array unset data_array "failure_info"
	array unset data_array "other_check_list"
	array unset data_array "other_reason_list"
	array unset data_array "other_sdc_reason_list"
	array unset data_array "other_failure_info"

	package require ::quartus::dtw_util
	set data_array_names [lsort -command ::quartus::dtw_util::lexcmp -increasing [array names data_array]]
	set data_array_list [list]
	foreach data_array_name $data_array_names {
		lappend data_array_list $data_array_name
		lappend data_array_list $data_array($data_array_name)
	}
	puts $output_file "set data_list \[list \\"
	foreach data_array_name $data_array_names {
		puts $output_file "  $data_array_name [list $data_array($data_array_name)] \\"
	}	
	puts $output_file "\]"
	close $output_file
	return
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_dwz::read_dwz { data_array_name data_file_name } {
#
# Description: Read wizard state from file
#
# ----------------------------------------------------------------
	upvar 1 $data_array_name data_array

	set data_list [list]
	if {[catch "source \"$data_file_name\""]} {
		# Error
		if {[namespace exists ::dtw]} {
			::dtw::msg_o "Error" "Corrupted data file $data_file_name"
		} else {
			puts "Error: Corrupted data file $data_file_name"
		}
		set result 0
	} else {
		if {[llength $data_list] == 0} {
			set msg "Missing data in $data_file_name.  Will continue as if creating new assignments."
			if {[namespace exists ::dtw]} {
				::dtw::msg_o "Warning" $msg
			} else {
				puts $msg
			}
		}
		array unset data_array
		array set data_array $data_list
		set result 1
	}

	return $result
}
