if {[namespace exists ::dtw]} {
	::dtw::add_version_date {$Date: 2009/04/01 $}
}

##############################################################################
#
# File Name:    dtw_extract_tco.tcl
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

package require ::quartus::dtw_msg
package require ::quartus::dtw_dwz

# ----------------------------------------------------------------
#
namespace eval dtw_extract_tco {
#
# Description: Top-level namespace for the auto-detection code
#
# ----------------------------------------------------------------
	source ${quartus(tclpath)}packages/dtw/dtw_msg.tcl
	namespace import ::quartus::dtw_msg::*

	source ${quartus(tclpath)}packages/dtw/dtw_dwz.tcl
	namespace import ::quartus::dtw_dwz::*
}

# ----------------------------------------------------------------
#
proc dtw_extract_tco::extract { argv } {
#
# Description: Extracts tcos
#              First argument is the dwz file name
#
# ----------------------------------------------------------------
	set dwz_file [lindex $argv 0]

	init_tk
	package require ::quartus::timing
	package require ::quartus::report
	package require ::quartus::advanced_timing

	array set data_array [list]
	read_dwz data_array $dwz_file
	set project_name [file tail [file rootname "$data_array(project_path)"]]
	set revision_name $data_array(project_revision)
	set success 1

	# Open project
	set project_is_open [is_project_open]
	if {$project_is_open == 0} {
		project_open $project_name -revision $revision_name
	}

	if {[was_fit_successful]} {
		# Extract from the Fast Timing Model first
		create_timing_netlist -fast_model

		get_min_max_reported_tcos $data_array(clk_pll_in) [concat $data_array(ck_list) $data_array(ckn_list)] min_tco max_tco
		if {$min_tco != [get_illegal_delay_value]} {
			set data_array(sys_clk_min_tco) "$min_tco ns"
		} else {
			set data_array(sys_clk_min_tco) ""
			puts "Cannot find fast min tco for CK/CK# clocks"
		}
		if {$max_tco != [get_illegal_delay_value]} {
			set data_array(sys_clk_fast_max_tco) "$max_tco ns"
		} else {
			set data_array(sys_clk_fast_max_tco) ""
			puts "Cannot find fast max tco for CK/CK# clocks"
		}
		unset min_tco
		unset max_tco

		if {$data_array(is_clk_fedback_in)} {
			get_min_max_reported_tcos $data_array(clk_pll_in) [list $data_array(clk_feedback_out)] fb_min_tco fb_max_tco
			if {$fb_min_tco != [get_illegal_delay_value]} {
				set data_array(fb_clk_min_tco) "$fb_min_tco ns"
			} else {
				set data_array(fb_clk_min_tco) ""
				puts "Cannot find fast min tco for feedback output clock"
			}
			if {$fb_max_tco != [get_illegal_delay_value]} {
				set data_array(fb_clk_fast_max_tco) "$fb_max_tco ns"
			} else {
				set data_array(fb_clk_fast_max_tco) ""
				puts "Cannot find fast max tco for feedback output clock"
			}
		}
		delete_timing_netlist

		# Extract from the Slow Timing Model
		create_timing_netlist

		get_min_max_reported_tcos $data_array(clk_pll_in) [concat $data_array(ck_list) $data_array(ckn_list)] min_tco max_tco
		if {$min_tco != [get_illegal_delay_value]} {
			set data_array(sys_clk_slow_min_tco) "$min_tco ns"
		} else {
			set data_array(sys_clk_slow_min_tco) ""
			puts "Cannot find slow min tco for CK/CK# clocks"
		}
		if {$max_tco != [get_illegal_delay_value]} {
			set data_array(sys_clk_max_tco) "$max_tco ns"
		} else {
			set data_array(sys_clk_max_tco) ""
			puts "Cannot find slow max tco for CK/CK# clocks"
		}
		if {$data_array(is_clk_fedback_in)} {
			get_min_max_reported_tcos $data_array(clk_pll_in) [list $data_array(clk_feedback_out)] fb_min_tco fb_max_tco
			if {$fb_min_tco != [get_illegal_delay_value]} {
				set data_array(fb_clk_slow_min_tco) "$fb_min_tco ns"
			} else {
				set data_array(fb_clk_slow_min_tco) ""
				puts "Cannot find slow min tco for feedback output clock"
			}
			if {$fb_max_tco != [get_illegal_delay_value]} {
				set data_array(fb_clk_max_tco) "$fb_max_tco ns"
			} else {
				set data_array(fb_clk_max_tco) ""
				puts "Cannot find slow max tco for feedback output clock"
			}
		}
		delete_timing_netlist
	} else {
		msg_o "Sorry" "Cannot extract tcos until you have a successfully compiled fit."
		set success 0
	}
	# All done - Clean up
	if {$project_is_open == 0} {
		project_close
	}

	if {$success} {
		# Auto-detect successful
		write_dwz data_array $dwz_file
		set return_code 0
	} else {
		set return_code 1
	}
	return $return_code
}

# ----------------------------------------------------------------
#
proc dtw_extract_tco::read_report_timing {report_timing_file report_type clock dest_list} {
#
# Description: Gets the max tco report timing result in the given file
#
# ----------------------------------------------------------------
	set result [get_illegal_delay_value]
	set tmp_file [open $report_timing_file r]

	# Array to check everything worked
	foreach dest $dest_list {
		set found_dest 0
		# Note that report_timing for tcos outputs in 1 of 2 formats.
		# 1. If the output pin does not have a TCO_REQUIREMENT assignment, then
		# it outputs the tco in the top line:
		#  tco from clock "$clock" to destination pin "$dest" is <tco>
		# 2. If the output pin does have a TCO_REQUIREMENT assignment, then
		# we need to look at the first 4 lines:
		#  Slack is <t> from clock "$clock" between source clock "<x>" and destination pin "$dest"
		# ---------------------------------------------------------------------
		#      + tco requirement for source clock and destination pin is <r>
		#      - tco from clock to output pin is <tco>
		if {$report_type == "tco"} {
			set report1_tco_prefix " tco from clock \"$clock\" to destination pin \"$dest\""
			set report2_slack_prefix " for clock \"$clock\""
			set report2_slack_suffix " and destination pin \"$dest\""
			set report2_tco_prefix "     - tco from clock to output pin"
			set get_max 1
		} elseif {$report_type == "min_tco"} {
			set report1_tco_prefix " Minimum tco from clock \"$clock\" to destination pin \"$dest\""
			set report2_slack_prefix " for clock \"$clock\""
			set report2_slack_suffix " and destination pin \"$dest\""
			set report2_tco_prefix "     + Minimum tco from clock to output pin"
			set get_max 0
		} else {
			error "Unknown report_type $report_type"
		}
		set report1_tco_prefix_length [string length $report1_tco_prefix]
		set report2_tco_prefix_length [string length $report2_tco_prefix]

		set search_str {is ([-0-9.]+) ([pn]s)}

		# Read the report_timing result in the given file
		seek $tmp_file 0 start
		while {![eof $tmp_file] && !$found_dest} {
			set line [gets $tmp_file]
			if {[string compare -length $report1_tco_prefix_length $line $report1_tco_prefix] == 0} {
				# Format 1
				# tco is on the first line
				if {[regexp -start $report1_tco_prefix_length -- $search_str $line -> line_result_value line_result_units]} {
					set found_dest 1
				}
			} elseif {[string first $report2_slack_prefix $line] != -1 && [string first $report2_slack_suffix $line] != -1} {
				# Format 2
				# Skip down 3 lines to the tco
				if {![eof $tmp_file]} {
					gets $tmp_file
				}
				if {![eof $tmp_file]} {
					gets $tmp_file
				}
				if {![eof $tmp_file]} {
					set line [gets $tmp_file]
					if {[string compare -length $report2_tco_prefix_length $line $report2_tco_prefix] == 0 && [regexp -start $report2_tco_prefix_length -- $search_str $line -> line_result_value line_result_units]} {
						set found_dest 1
					}
				}
			}
		}
		if {$found_dest == 0} {
			# Failed to find tco for dest - we need to try again
			set result [get_illegal_delay_value]
			break;
		} else {
			if {$line_result_units == "ps"} {
				# Convert ps to ns
				set line_result_value [expr "$line_result_value / 1000.0"]
			}
			if {$get_max} {
				if {$result == [get_illegal_delay_value] || $line_result_value > $result} {
					set result $line_result_value
				}
			} else {
				if {$result == [get_illegal_delay_value] || $line_result_value < $result} {
					set result $line_result_value
				}
			}
		}
	}
	close $tmp_file

	return $result
}

# ----------------------------------------------------------------
#
proc dtw_extract_tco::report_tco_timing {clock output_pin_list} {
#
# Description: Displays the setup/hold margins
#
# ----------------------------------------------------------------
	set tmp_filename "_dtw_report_timing_tco.tmp"

	eval report_timing -tco -clock_filter $clock -to [join $output_pin_list] -npaths 100 -file $tmp_filename
	set max_tco [read_report_timing $tmp_filename "tco" $clock $output_pin_list]
	if {$max_tco == [get_illegal_delay_value]} {
		# HACK: Try again.  Sometimes, the first call does not filter correctly
		eval report_timing -tco -clock_filter $clock -to [join $output_pin_list] -npaths 100 -file $tmp_filename
		set max_tco [read_report_timing $tmp_filename "tco" $clock $output_pin_list]
	}
	file delete $tmp_filename

	set tmp_filename "_dtw_report_timing_min_tco.tmp"
	eval report_timing -min_tco -clock_filter $clock -to [join $output_pin_list] -npaths 100 -file $tmp_filename
	set min_tco [read_report_timing $tmp_filename "min_tco" $clock $output_pin_list]
	if {$min_tco == [get_illegal_delay_value]} {
		# HACK: Try again.  Sometimes, the first call does not filter correctly
		eval report_timing -min_tco -clock_filter $clock -to [join $output_pin_list] -npaths 100 -file $tmp_filename
		set min_tco [read_report_timing $tmp_filename "min_tco" $clock $output_pin_list]
	}
	file delete $tmp_filename

	return [list $min_tco $max_tco]
}

# ----------------------------------------------------------------
#
proc dtw_extract_tco::get_min_max_reported_tcos { clk output_list min_tco_name max_tco_name } {
#
# Description: Get the min and max tcos for the given outputs through the given
#              clock
#
# ----------------------------------------------------------------
	upvar 1 $min_tco_name min_tco
	upvar 1 $max_tco_name max_tco

	set output_pin_tcos [report_tco_timing $clk $output_list]
	set min_tco [lindex $output_pin_tcos 0]
	set max_tco [lindex $output_pin_tcos 1]
}

# ----------------------------------------------------------------
#
proc dtw_extract_tco::was_fit_successful { } {
#
# Description: Tells if the previous fit attempt was successful or not
#
# ----------------------------------------------------------------
	set fit_ok 0

	if {[catch "load_report" res]} {
		# No reports to load, so fit was not successful
		puts "No previous compile detected"
	} else {
		set fitter_summary_id [get_report_panel_id {Fitter||Fitter Summary}]
		if {$fitter_summary_id != -1} {
			set fitter_status [split [lindex [get_report_panel_row -id $fitter_summary_id -row 0] 1]]
			if {[lindex $fitter_status 0] == "Successful"} {
				set fit_ok 1
			} else {
				puts "Fitter not Successful"
			}
		} else {
			puts "No previous fit detected"
		}
		unload_report
	}

	return $fit_ok
}

if {[namespace exists ::dtw] == 0} {
	dtw_extract_tco::extract $quartus(args)
}
