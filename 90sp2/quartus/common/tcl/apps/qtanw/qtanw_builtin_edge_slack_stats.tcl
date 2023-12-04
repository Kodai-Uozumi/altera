###################################################################################
#                                                                                 #
# File Name:    qtanw_builtin_edge_slack_stats.tcl                                #
#                                                                                 #
# Summary:      This builtin plugin displays edge slack statistics as a           #
#               histogram                                                         #
#                                                                                 #
# Licensing:    This script is  pursuant to the following license agreement       #
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE               #
#               FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,      #
#               California, USA.  Permission is hereby granted, free of           #
#               charge, to any person obtaining a copy of this software and       #
#               associated documentation files (the "Software"), to deal in       #
#               the Software without restriction, including without limitation    #
#               the rights to use, copy, modify, merge, publish, distribute,      #
#               sublicense, and/or sell copies of the Software, and to permit     #
#               persons to whom the Software is furnished to do so, subject to    #
#               the following conditions:                                         #
#                                                                                 #
#               The above copyright notice and this permission notice shall be    #
#               included in all copies or substantial portions of the Software.   #
#                                                                                 #
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,   #
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES   #
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND          #
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT       #
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,      #
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR     #
#               OTHER DEALINGS IN THE SOFTWARE.                                   #
#                                                                                 #
#               This agreement shall be governed in all respects by the laws of   #
#               the State of California and by the laws of the United States of   #
#               America.                                                          #
#                                                                                 #
###################################################################################

global quartus

# Only qtanw exes can interpret this script
if [info exist quartus] {
	if { ![string equal $quartus(nameofexecutable) quartus_tan] } {
		set msg "QTANW should be invoked from the command line.\nUsage: quartus_tan -g \[<project_name>\]"
		puts $msg
		catch { tk_messageBox -type ok -message $msg -icon error }
		return
	}
} else {
	set msg "QTANW should be invoked using the Quartus II Shell.\nUsage: quartus_tan -g \[<project_name>\]"
	puts $msg
	catch { tk_messageBox -type ok -message $msg -icon error }
	exit -1
}

package require math::statistics

namespace eval edge_slack_stats {
	variable name "Report Edge Slack Statistics"
}

qtanw::install_builtin $edge_slack_stats::name edge_slack_stats::on_report_edge_statistics

#############################################################################
## Procedure: on_report_edge_statistics
##
## Arguments: None
##		
## Description: Calls compute slack for TDC and reports statistics on
##				edge slack, including a histogram
##
#############################################################################
proc edge_slack_stats::on_report_edge_statistics { } {

	set max_slack "2147483.647"

	# This is the main function call to have TAN compute slacks
	qtanw::set_compiler_status disabled

	set command compute_slack_on_edges

	qtanw::print_cmd $command
	qtanw::print_msg "This command can take several minutes"

	update
	if {[catch {eval $command} result]} {
		qtanw::print_error "$command failed."
	}
	qtanw::print_msg "-> DONE"
	qtanw::print_msg "Generating Statistics"
	qtanw::print_msg "This command can take several minutes"
	update

	set values {}
	set neg_values {}
	set number_of_edges 0
set exc_time [time {
	foreach_in_collection edge [get_timing_edges] {	
		set slack [lindex [get_timing_edge_info -info slack $edge] 0]

		incr number_of_edges
	
		if { $slack < $max_slack } {

			lappend values $slack		

			if { $slack < 0 } {

				lappend neg_values $slack		
			}
		}
	}
}]
	puts "foreach_in_collection : $exc_time"

	qtanw::print_msg ""
	qtanw::print_msg ""
	qtanw::print_msg "===================================================================="
	qtanw::print_msg ""
	qtanw::print_msg "Number of Edges           : $number_of_edges"
	qtanw::print_msg ""

	if {[llength $values] == 0} {
		
		qtanw::print_error "No timing constraints and therefore no slack"
		qtanw::set_compiler_status waiting
		return
	}
	qtanw::print_msg "Statistics for all edges with Slack"
	qtanw::print_msg "-----------------------------------"
	qtanw::print_msg ""
set exc_time [time {
	qtanw::print_msg "==> Number        : [::math::statistics::number $values]"
	qtanw::print_msg "==> Percent       : [expr 100 * [::math::statistics::number $values] / $number_of_edges ] %"
	qtanw::print_msg  "==> Mean          : [::math::statistics::mean   $values]"
	qtanw::print_msg "==> Min           : [::math::statistics::min    $values]"
	qtanw::print_msg "==> Max           : [::math::statistics::max    $values]"
	qtanw::print_msg "==> STDev         : [::math::statistics::stdev  $values]"
	qtanw::print_msg "==> Var           : [::math::statistics::var    $values]"
	qtanw::print_msg ""
}]
	puts "Generating Statistics 1 : $exc_time"

	qtanw::print_msg ""
	qtanw::print_msg "Statistics for all edges with Negative Slack"
	qtanw::print_msg "-----------------------------------"
	qtanw::print_msg ""
	if {[llength $neg_values] > 0} {

	qtanw::print_msg "==> Number        : [::math::statistics::number $neg_values]"
	qtanw::print_msg "==> Percent       : [expr 100 * [::math::statistics::number $neg_values] / $number_of_edges ] %"
	qtanw::print_msg  "==> Mean          : [::math::statistics::mean   $neg_values]"
	qtanw::print_msg "==> Min           : [::math::statistics::min    $neg_values]"
	qtanw::print_msg "==> Max           : [::math::statistics::max    $neg_values]"
	qtanw::print_msg "==> STDev         : [::math::statistics::stdev  $neg_values]"
	qtanw::print_msg "==> Var           : [::math::statistics::var    $neg_values]"
	qtanw::print_msg ""


	qtanw::qhist::initHist $neg_values  -linemarker 0 -title "Negative Slack Histogram" \
										-xlabel "Slack (ns)" -ylabel "Number of Edges" \
										-num_bins 20
	qtanw::qhist::drawHist
	} else {
		qtanw::print_msg "==> Number        : 0"
		qtanw::print_msg "==> Percent       : 0 %"
		qtanw::print_msg ""
		qtanw::print_msg "==> No Histogram will be shown"
		qtanw::print_msg ""
	}

	qtanw::set_compiler_status waiting
	qtanw::print_msg "-> DONE"
	update
}

