
#############################################################################
##  qof-lib.tcl
##
##  Library for the Quartus Quality of Fit calculation.
##
##  ALTERA LEGAL NOTICE
##  
##  This script is  pursuant to the following license agreement
##  (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
##  FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
##  California, USA.  Permission is hereby granted, free of
##  charge, to any person obtaining a copy of this software and
##  associated documentation files (the "Software"), to deal in
##  the Software without restriction, including without limitation
##  the rights to use, copy, modify, merge, publish, distribute,
##  sublicense, and/or sell copies of the Software, and to permit
##  persons to whom the Software is furnished to do so, subject to
##  the following conditions:
##  
##  The above copyright notice and this permission notice shall be
##  included in all copies or substantial portions of the Software.
##  
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
##  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
##  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
##  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
##  OTHER DEALINGS IN THE SOFTWARE.
##  
##  This agreement shall be governed in all respects by the laws of
##  the State of California and by the laws of the United States of
##  America.
##
##
##  CONTACTING ALTERA
##  
##  You can contact Altera through one of the following ways:
##  
##  Mail:
##     Altera Corporation
##     Applications Department
##     101 Innovation Drive
##     San Jose, CA 95134
##  
##  Altera Website:
##     www.altera.com
##  
##  Online Support:
##     www.altera.com/mysupport
##  
##  Troubshooters Website:
##     www.altera.com/support/kdb/troubleshooter
##  
##  Technical Support Hotline:
##     (800) 800-EPLD or (800) 800-3753
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##     (408) 544-7000
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##  
##     From other locations, call (408) 544-7000 or your local
##     Altera distributor.
##  
##  The mySupport web site allows you to submit technical service
##  requests and to monitor the status of all of your requests
##  online, regardless of whether they were submitted via the
##  mySupport web site or the Technical Support Hotline. In order to
##  use the mySupport web site, you must first register for an
##  Altera.com account on the mySupport web site.
##  
##  The Troubleshooters web site provides interactive tools to
##  troubleshoot and solve common technical problems.
##

package provide ::quartus::dse::qof 1.0


#############################################################################
##  Additional Packages Required
package require cmdline
load_package report
load_package project


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse::qof {

    namespace export quality_of_fit

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
}


#############################################################################
##  Procedure:  ::quartus::dse::qof::quality_of_fit
##
##  Arguments:
##      -model [fast | slow | normal]
##          If you're doing a combined timing analysis you'll need to
##          tell this function which timing summary panel (the Fast Model
##          or the Slow Model) you want to use to extract timing info
##          from for the QoF calculation. If this argument is omitted
##          the function assumes you're not doing combined analysis
##          and seeks out a normal timing summary panel.
##
##  Description:
##      Finds the slack of each domain in the timing report.
##      Computes an overall design slack considering the domain
##      slacks. Domains with lower slack are weighted more
##      heavily. Returns the overall quality of fit metric.
##
##      Requires that a Quartus II project be open already and
##      that timing analysis has already been performed on
##      the design. The function will load the reports for the
##      open revision if they are not already loaded.
proc ::quartus::dse::qof::quality_of_fit {args} {

    set debug_name "::quartus::dse::qof::quality_of_fit()"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            set panel_name  "Timing Analyzer||Fast Model||Fast Model Timing Analyzer Summary"
        }
        "slow" {
            set panel_name  "Timing Analyzer||Slow Model||Slow Model Timing Analyzer Summary"
        }
        default {
            set panel_name  "Timing Analyzer||Timing Analyzer Summary"
        }
    }

    # Start with an rvalue of 0
    set rvalue 0

    # Error if there isn't a Quartus II project open.
    if {![is_project_open]} {
        return -code error "No project open"
    }

    # Check and see if STA is being used as the timing engine
    set sta_mode 0
    if {[string equal -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] "on"]} {
        set sta_mode 1
    }

    # Load the reports if they're not already
    if {![is_report_loaded]} {
        if {[catch {load_report} msg]} {
            return -code error "Unable to load report for project"
        }
    }

    if { $sta_mode } {

        foreach {panel_name} [list "TimeQuest Timing Analyzer||TimeQuest Timing Analyzer Summary (Setup)" "TimeQuest Timing Analyzer||TimeQuest Timing Analyzer Summary (Hold)"] {
            set panel_id [get_report_panel_id $panel_name]
            if { $panel_id != -1 } {

                for {set x 1} {$x < [get_number_of_rows -id $panel_id]} {incr x} {

                    set slack_value_found 0

                    if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} [get_report_panel_data -id $panel_id -row $x -col_name "Slack"] => slack]} {
                        set slack_value_found $slack
                    }

                    if {$slack_value_found < 0} {
                        set rvalue [expr {$rvalue + $slack_value_found }]
                    } elseif {$slack_value_found < 0.250} {
                        set rvalue [expr {$rvalue + $slack_value_found * 0.5}]
                    } elseif {$slack_value_found < 0.500} {
                        set rvalue [expr {$rvalue + 0.250 * 0.5}]
                        set slack_value_found [expr {$slack_value_found - 0.250}]
                        set rvalue [expr {$rvalue + $slack_value_found * 0.25}]
                    } elseif {$slack_value_found < 2.000} {
                        set rvalue [expr {$rvalue + 0.250 * 0.5}]
                        set slack_value_found [expr {$slack_value_found - 0.250}]
                        set rvalue [expr {$rvalue + 0.250 * 0.25}]
                        set slack_value_found [expr {$slack_value_found - 0.250}]
                        set rvalue [expr {$rvalue + $slack_value_found * 0.0625}]
                    } else {
                        set rvalue [expr {$rvalue + 0.250 * 0.5}]
                        set slack_value_found [expr {$slack_value_found - 0.250}]
                        set rvalue [expr {$rvalue + 0.250 * 0.25}]
                        set slack_value_found [expr {$slack_value_found - 0.250}]
                        set rvalue [expr {$rvalue + 1.500 * 0.0625}]
                        set slack_value_found [expr {$slack_value_found - 1.500}]
                        set rvalue [expr {$rvalue + $slack_value_found * 0.00625}]
                    }
                }
            }
        }

    } else {

        # Look for a column with the column_name title. If we can't
        # find a column with this name then the user probably hasn't
        # run timing analysis on the design yet so error.
        if {[catch {get_report_panel_column_index -name $panel_name "Slack"} slack_column]} {
            return -code error "Unable to get slack column from timing analyzer summary panel"
        }

        # Find all the 'Clock Setup'/'Clock Hold'/'Worst-case' lines and
        # process the relevant slacks.
        for {set x 1} {$x < [get_number_of_rows $panel_name]} {incr x} {

            # If the first column holds a "Clock Setup"/"Clock Hold"/"Worst-case"
            # string keep going.

            set row [get_report_panel_row $panel_name -row $x]
            set cstring [lindex $row 0]

            set slack_value_found 0

            if {[regexp -nocase -- {Clock Setup:\s+'(\S+)'} $cstring => clk_name]} {
                set pstring [lindex $row $slack_column]
                if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $pstring => slack]} {
                    # Found a clock with a slack
                    set slack_value_found $slack
                }
            } elseif {[regexp -nocase -- {Clock Hold:\s+'(\S+)'} $cstring => clk_name]} {
                set pstring [lindex $row $slack_column]
                if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $pstring => slack]} {
                    # Found a clock with a slack
                    set slack_value_found $slack
                }
            } elseif {[regexp -nocase -- {Worst-case\s+(.*)} $cstring => setting_name]} {
                set pstring [lindex $row $slack_column]
                if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $pstring => slack]} {
                    # Found a timing setting with a slack
                    set slack_value_found $slack
                }
            }

            if {$slack_value_found < 0} {
                set rvalue [expr {$rvalue + $slack_value_found }]
            } elseif {$slack_value_found < 0.250} {
                set rvalue [expr {$rvalue + $slack_value_found * 0.5}]
            } elseif {$slack_value_found < 0.500} {
                set rvalue [expr {$rvalue + 0.250 * 0.5}]
                set slack_value_found [expr {$slack_value_found - 0.250}]
                set rvalue [expr {$rvalue + $slack_value_found * 0.25}]
            } elseif {$slack_value_found < 2.000} {
                set rvalue [expr {$rvalue + 0.250 * 0.5}]
                set slack_value_found [expr {$slack_value_found - 0.250}]
                set rvalue [expr {$rvalue + 0.250 * 0.25}]
                set slack_value_found [expr {$slack_value_found - 0.250}]
                set rvalue [expr {$rvalue + $slack_value_found * 0.0625}]
            } else {
                set rvalue [expr {$rvalue + 0.250 * 0.5}]
                set slack_value_found [expr {$slack_value_found - 0.250}]
                set rvalue [expr {$rvalue + 0.250 * 0.25}]
                set slack_value_found [expr {$slack_value_found - 0.250}]
                set rvalue [expr {$rvalue + 1.500 * 0.0625}]
                set slack_value_found [expr {$slack_value_found - 1.500}]
                set rvalue [expr {$rvalue + $slack_value_found * 0.00625}]
            }
        }

    }

    return $rvalue
}
