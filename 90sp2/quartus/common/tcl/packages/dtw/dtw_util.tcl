##############################################################################
#
# File Name:    dtw_util.tcl
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

package provide ::quartus::dtw_util 1.0
# ----------------------------------------------------------------
#
namespace eval ::quartus::::dtw_util {
#
# Description: Namespace to encapsulate the messaging code
#
# ----------------------------------------------------------------
	namespace export lexcmp
	namespace export lexcmp_list_bsearch
	namespace export lexcmp_list_insert
	namespace export lexcmp_list_merge
	namespace export get_dtw_util_version
	namespace export get_relative_filename
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_util::get_relative_filename { base_dir filename } {
#
# Description: Get the relative filename for the absolute filename from the
#              given base directory
#
# ----------------------------------------------------------------
	set base_dir_list "[file split [file normalize $base_dir]]"
	set filename_list "[file split [file normalize $filename]]"

	set result $filename_list
	if {[lindex $base_dir_list 0] != [lindex $filename_list 0]} {
		# Different drives - just use absolute path
	} else {
		for {set i 0} {$i != [llength $base_dir_list] && $i != [llength $filename_list]} {incr i} {
			if {[lindex $base_dir_list $i] == [lindex $filename_list $i]} {
				# matching base
				set result [lrange $result 1 end]
			} else {
				# no match, so prepend .. to result for all remaining base dir
				break;
			}
		}
		if {$i != [llength $base_dir_list]} {
			# no match, so prepend .. to result for all remaining base dir
			for {} {$i != [llength $base_dir_list]} {incr i} {
				set result [concat .. $result]
			}		
		} else {
			# full match to base dir, just use remaining path
		}
	}
	if {$result == ""} {
		set result [list "."]
	}
	return [eval file join $result]
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_util::get_dtw_util_version { } {
#
# Description: Get the package version
#
# ----------------------------------------------------------------
	return {$Date: 2009/04/01 $}
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_util::lexcmp { str1 str2} {
#
# Description: lexcmp of 2 strings
#
# Returns: integer <0 if less, =0 if equal, >0 if greater
#
# ----------------------------------------------------------------
	set result 0
	set i 0
	set j 0
	while {$i != [string length $str1] && $j != [string length $str2] && $result == 0} {
		set str1_int [string range $str1 $i end]
		set str2_int [string range $str2 $j end]
		set str1_int_end 0
		set str2_int_end 0
		# Compare characters/numbers
		if {([string is integer -failindex str1_int_end -strict $str1_int] || $str1_int_end > 0) && ([string is integer -failindex str2_int_end -strict $str2_int] || $str2_int_end > 0)} {
			if {$str1_int_end > 0} {
				set str1_int [string range $str1_int 0 [expr "$str1_int_end - 1"]]
				incr i $str1_int_end
			} else {
				set i [string length $str1]
			}
			if {$str2_int_end > 0} {
				set str2_int [string range $str2_int 0 [expr "$str2_int_end - 1"]]
				incr j $str2_int_end
			} else {
				set j [string length $str2]
			}
			# Do numeric comparison
			set result [expr "$str1_int - $str2_int"]
		} else {
			# Do a character comparison
			set s1_ch [string index $str1 $i]
			set s2_ch [string index $str2 $j]
			set result [string compare $s1_ch $s2_ch]
			incr i
			incr j
		}
	}

	if {$result == 0} {
		# Longer string is larger
		set result [expr "[string length $str1] - [string length $str2]"]
	}
	return $result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_util::lexcmp_list_bsearch { lexcmp_list str } {
#
# Description: Binary search into a list of lexcmp-sorted strings
#
# Returns:     List index where the string can be inserted to maintain
#              sortedness
#
# ----------------------------------------------------------------
	set top 0
	set bottom [llength $lexcmp_list]
	set mid [expr "($top + $bottom) / 2"]

	while {$top < $bottom} {
		if {[lexcmp $str [lindex $lexcmp_list $mid]] < 0} {
			set bottom $mid
		} else {
			set top [expr "$mid + 1"]
		}
		set mid [expr "($top + $bottom) / 2"]
	}
	return $mid
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_util::lexcmp_list_insert { lexcmp_list str } {
#
# Description: Inserts a string into a list of lexcmp-sorted strings
#
# Returns: The new list
#
# ----------------------------------------------------------------
	set insert_index [lexcmp_list_bsearch $lexcmp_list $str]
	set result [linsert $lexcmp_list $insert_index $str]
	return $result
}

# ----------------------------------------------------------------
#
proc ::quartus::dtw_util::lexcmp_list_merge { list1 list2 } {
#
# Description: Merges 2 lexcmp-sorted lists
#
# Returns: The new list
#
# ----------------------------------------------------------------
	if {[llength $list1] < [llength $list2]} {
		set short_list $list1
		set long_list $list2
	} else {
		set short_list $list2
		set long_list $list1
	}
	foreach str $short_list {
		set long_list [lexcmp_list_insert $long_list $str]
	}
	return $long_list
}

