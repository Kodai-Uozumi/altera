if {[namespace exists ::dtw]} {
	::dtw::add_version_date {$Date: 2009/04/01 $}
}

##############################################################################
#
# File Name:    dtw_device.tcl
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

package require ::quartus::project
# ----------------------------------------------------------------
#
namespace eval dtw_device {
#
# Description: Namespace to encapsulate the messaging code
#
# ----------------------------------------------------------------
	namespace export get_dtw_family
	namespace export dtw_device_get_device
	namespace export dtw_device_get_density
	namespace export dtw_device_get_temp_grade
	namespace export dtw_device_get_speed_grade
	namespace export dtw_device_get_part_spec
	namespace export dtw_device_get_family_parameter
	namespace export dtw_device_get_timing_parameter

	variable s_device_timing_parameters_list
	variable s_family_parameters_list
	# Source everything to get the latest version date
	# Note that pkg_mkIndex can't source from quartus(tclpath), so
	# we can't make dtw_device a Tcl library.
	source ${quartus(tclpath)}apps/dtw/dtw_device_parameters.tcl
}

# ----------------------------------------------------------------
#
proc dtw_device::strip_whitespace { str } {
#
# Description: Removes all spaces from the given string
#
# ----------------------------------------------------------------
	set result ""
	for {set i 0} {$i != [string length $str]} {incr i} {
		set c [string index $str $i]
		if {$c != " "} {
			append result $c
		}
	}
	return $result
}

# ----------------------------------------------------------------
#
proc dtw_device::get_dtw_family {} {
#
# Description: Gets the active device family in the currently open project
#
# ----------------------------------------------------------------
	set timing_model ""
	
	set family [string tolower [get_global_assignment -name FAMILY]]
	if {[dtw_device_get_family_parameter $family "timing_model" timing_model] == 0} {
		set timing_model $family
	}

	return $timing_model
}

# ----------------------------------------------------------------
#
proc dtw_device::dtw_device_get_part_spec {part_spec} {
#
# Description: Gets the active device family in the currently open project.
#
# ----------------------------------------------------------------
	set family [string tolower [get_global_assignment -name FAMILY]]
	set device [string tolower [get_global_assignment -name DEVICE]]
	set spec_regexp ""
	set spec "unknown"

	dtw_device_get_family_parameter $family ${part_spec}_regexp spec_regexp
	if {$spec_regexp != ""} {
		if {[regexp -nocase -- $spec_regexp $device -> spec] == 0} {
			set spec_regexp ""
		}
	}
	if {$spec_regexp == ""} {
		dtw_device_get_family_parameter $family "default_${part_spec}" spec
		puts "Using default $part_spec $spec"
	}

	return $spec
}

# ----------------------------------------------------------------
#
proc dtw_device::dtw_device_get_speed_grade {} {
#
# Description: Gets the active device family in the currently open project.
#
# ----------------------------------------------------------------
	set spec [dtw_device_get_part_spec speed_grade]
	return $spec
}

# ----------------------------------------------------------------
#
proc dtw_device::dtw_device_get_density {} {
#
# Description: Gets the active device family in the currently open project.
#
# ----------------------------------------------------------------
	set spec [dtw_device_get_part_spec density]

	return $spec
}

# ----------------------------------------------------------------
#
proc dtw_device::dtw_device_get_device {} {
#
# Description: Gets the active part in the currently open project.
#
# ----------------------------------------------------------------
	set device [string tolower [get_global_assignment -name DEVICE]]

	return $device
}

# ----------------------------------------------------------------
#
proc dtw_device::dtw_device_get_temp_grade {} {
#
# Description: Gets the active device family in the currently open project.
#
# ----------------------------------------------------------------
	set spec [dtw_device_get_part_spec temp_grade]

	return $spec
}

# ----------------------------------------------------------------
#
proc dtw_device::dtw_device_get_family_parameter { family parameter value_name } {
#
# Description: Sets value_name to the value of the given family-specific
#              parameter.
#
# ----------------------------------------------------------------
	upvar 1 $value_name value
	variable s_family_parameters_list
	set found 0

	set family [strip_whitespace $family]
	foreach family_parameters $s_family_parameters_list {
		array unset family_info 
		array set family_info $family_parameters
		if {[lsearch -exact $family_info(family) $family] != -1 && [array names family_info -exact $parameter] != ""} {
			set value $family_info($parameter)
			set found 1
			break
		}
	}

	return $found
}

# ----------------------------------------------------------------
#
proc dtw_device::dtw_device_get_timing_parameter { family speed_grade parameter value_name} {
#
# Description: Returns the parameter
#
# ----------------------------------------------------------------
	upvar 1 $value_name value
	variable s_device_timing_parameters_list
	set found 0

	foreach device_parameters $s_device_timing_parameters_list {
		array unset device_info
		array set device_info $device_parameters
		if {$device_info(family) == $family && "$device_info(speed_grade)" == "$speed_grade" && [array names device_info -exact $parameter] != ""} {
			set value $device_info($parameter)
			set found 1
			break
		}
	}

	return $found
}
