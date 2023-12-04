
#############################################################################
##  sta-helper.tcl
##
##  Provides an interface to extract TimeQuest netlist information from a
##  design into DSE.
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

package require cmdline
package require ::quartus::sta
package require ::quartus::sdc
package require ::quartus::misc
package require ::quartus::dse::result

##
## FUNCTIONS
##

proc __is_number {value} {
	return [expr {! [catch {expr {int($value)}}]}]
}

proc __add_data {result field value units} {
    upvar 1 $result resultobj
    if {[regexp -nocase {n\/a} $value]} {
        set real_value "unknown"
    } else {
        set real_value "$value $units"
    }
    post_message "\t $field = $real_value"
    $resultobj addResult -nocomplain -name "$field" -value "$real_value"
    return 1
}

proc __track_worst_case_slack {current_wc_slack current_wc_slack_field new_slack new_slack_field} {

    # Default is to keep the current worst-case slack candidate
    set wc_slack $current_wc_slack
    set wc_slack_field $current_wc_slack_field

    # If current is NaN and new is a number then new is automatically the
    # worst-case slack.
    if {[__is_number $current_wc_slack] != 1 && [__is_number $new_slack] == 1} {
        set wc_slack $new_slack
        set wc_slack_field $new_slack_field
    }

    # If current is a number and new is a number and new is less than current
    # then new is the new new worst-case slack value.
    if {[__is_number $current_wc_slack] == 1 && [__is_number $new_slack] == 1} {
        if { $new_slack < $current_wc_slack } {
            set wc_slack $new_slack
            set wc_slack_field $new_slack_field
        }
    }

    return [list $wc_slack $wc_slack_field]
}

proc extract_timing {project revision point} {

    project_open -force -revision $revision $project
    create_timing_netlist -no_report

    # Loop over all the operating conditions and create XML representations
    # of DSE result objects that can be loaded directly by DSE for analysis.
    foreach_in_collection op [get_available_operating_conditions -all] {
        # Load up the timing netlist for this operating condition
        set_operating_conditions $op
		read_sdc
        update_timing_netlist
        set wc_slack_tracer [list "unknown" "unknown"]

		# Create a new DSE result object. We'll fill this object in
        # with all kinds of timing information and then use it to
        # dump out a XML representation of the object to disk that
        # DSE will load in.
        set resultobj [uplevel #0 ::quartus::dse::result #auto $project $revision]
        $resultobj addResult -nocomplain -name "Timing Model" [get_operating_conditions_info $op -display_name]

		# This might seem like a round-about way to derive the name of the
		# file to use but this is what DSE has to use because it has to
		# take in strings from STA to represent them models. We'll do it the
		# same way here so everything lines up.
		set model "[get_operating_conditions_info $op -model]_[get_operating_conditions_info $op -voltage]mV_[get_operating_conditions_info $op -temperature]C"
		if {[regexp -nocase -- {(fast|slow)_(\d+)mv_(\-?\d+)c} $model => speed volts temp]} {
            set speed [string tolower $speed]
            set dse_model_name "${speed}-${volts}mV-${temp}C"
        } elseif {[regexp -nocase -- {(fast|slow)} $model => speed]} {
            set dse_model_name [string tolower $speed]
        } else {
            set dse_model_name $model
        }
        post_message "Mapped model $model to DSE model name $dse_model_name"

        # Reset some counters we use along the way...
        set total_setup_keeper_tns    0
        set total_hold_keeper_tns     0
        set total_recovery_keeper_tns 0
        set total_removal_keeper_tns  0

        set setup_domain_list [get_clock_domain_info -setup]
        post_message "Inspecting clock setup domains: $setup_domain_list"
        foreach domain $setup_domain_list {
            post_message "Inspecting clock setup domain: $domain"
            # Format is { <clk_name> <slack> <keeper tns> <edge tns> }
            set clk_name    [lindex $domain 0]
            set setup_slack [lindex $domain 1]
            set keeper_tns  [lindex $domain 2]
            set edge_tns    [lindex $domain 3]

            if {![regexp -nocase -- {^\s*$} $clk_name]} {
                post_message "Reporting clock setup results for $clk_name"
                __add_data resultobj "Clock Setup: '$clk_name': Worst-case Slack" "$setup_slack" "ns"
                set wc_slack_tracer [__track_worst_case_slack [lindex $wc_slack_tracer 0] [lindex $wc_slack_tracer 1] $setup_slack "Clock Setup: '$clk_name'"]
                __add_data resultobj "Clock Setup: '$clk_name': Per-clock Keeper TNS" "$keeper_tns" "ns"
                __add_data resultobj "Clock Setup: '$clk_name': Per-clock Edge TNS" "$edge_tns" "ns"

                if { [__is_number $keeper_tns] == 1 } {
                    set total_setup_keeper_tns [expr {$total_setup_keeper_tns + $keeper_tns}]
                }
            }
        }

        set hold_domain_list [get_clock_domain_info -hold]
        post_message "Inspecting clock hold domains: $hold_domain_list"
        foreach domain $hold_domain_list {
            post_message "Inspecting clock hold domain: $domain"
            # Format is { <clk_name> <slack> <keeper tns> <edge tns> }
            set clk_name    [lindex $domain 0]
            set hold_slack  [lindex $domain 1]
            set keeper_tns  [lindex $domain 2]
            set edge_tns    [lindex $domain 3]

            if {![regexp -nocase -- {^\s*$} $clk_name]} {
                post_message "Reporting clock hold results for $clk_name"
                __add_data resultobj "Clock Hold: '$clk_name': Worst-case Slack" "$hold_slack" "ns"
                set wc_slack_tracer [__track_worst_case_slack [lindex $wc_slack_tracer 0] [lindex $wc_slack_tracer 1] $hold_slack "Clock Hold: '$clk_name'"]
                __add_data resultobj "Clock Hold: '$clk_name': Per-clock Keeper TNS" "$keeper_tns" "ns"
                __add_data resultobj "Clock Hold: '$clk_name': Per-clock Edge TNS" "$edge_tns" "ns"

                if { [__is_number $keeper_tns] == 1 } {
                    set total_hold_keeper_tns [expr {$total_hold_keeper_tns + $keeper_tns}]
                }
            }
        }

        set recovery_domain_list [get_clock_domain_info -recovery]
        post_message "Inspecting clock recovery domains: $recovery_domain_list"
        foreach domain $recovery_domain_list {
            post_message "Inspecting clock recovert domain: $domain"
            # Format is { <clk_name> <slack> <keeper tns> <edge tns> }
            set clk_name        [lindex $domain 0]
            set recovery_slack  [lindex $domain 1]
            set keeper_tns      [lindex $domain 2]
            set edge_tns        [lindex $domain 3]

            if {![regexp -nocase -- {^\s*$} $clk_name]} {
                post_message "Reporting clock recovery results for $clk_name"
                __add_data resultobj "Clock Recovery: '$clk_name': Worst-case Slack" "$recovery_slack" "ns"
                set wc_slack_tracer [__track_worst_case_slack [lindex $wc_slack_tracer 0] [lindex $wc_slack_tracer 1] $recovery_slack "Clock Recovery: '$clk_name'"]
                __add_data resultobj "Clock Recovery: '$clk_name': Per-clock Keeper TNS" "$keeper_tns" "ns"
                __add_data resultobj "Clock Recovery: '$clk_name': Per-clock Edge TNS" "$edge_tns" "ns"

                if { [__is_number $keeper_tns] == 1 } {
                    set total_recovery_keeper_tns [expr {$total_recovery_keeper_tns + $keeper_tns}]
                }
            }
        }

        set removal_domain_list [get_clock_domain_info -removal]
        post_message "Inspecting clock removal domains: $removal_domain_list"
        foreach domain $removal_domain_list {
            post_message "Inspecting clock removal domain: $domain"
            # Format is { <clk_name> <slack> <keeper tns> <edge tns> }
            set clk_name [lindex $domain 0]
            set removal_slack [lindex $domain 1]
            set keeper_tns [lindex $domain 2]
            set edge_tns [lindex $domain 3]

            if {![regexp -nocase -- {^\s*$} $clk_name]} {
                __add_data resultobj "Clock Removal: '$clk_name': Worst-case Slack" "$removal_slack" "ns"
                set wc_slack_tracer [__track_worst_case_slack [lindex $wc_slack_tracer 0] [lindex $wc_slack_tracer 1] $removal_slack "Clock Removal: '$clk_name'"]
                __add_data resultobj "Clock Removal: '$clk_name': Per-clock Keeper TNS" "$keeper_tns" "ns"
                __add_data resultobj "Clock Removal: '$clk_name': Per-clock Edge TNS" "$edge_tns" "ns"

                if { [__is_number $keeper_tns] == 1 } {
                    set total_removal_keeper_tns [expr {$total_removal_keeper_tns + $keeper_tns}]
                }
            }
        }

        # What did the worst case slack turn out to be?
        if {[__is_number [lindex $wc_slack_tracer 0]] == 1} {
            __add_data resultobj "Worst-case Slack" "[lindex $wc_slack_tracer 0] ns ([lindex $wc_slack_tracer 1])" ""
        } else {
            __add_data resultobj "Worst-case Slack" "unknown" ""
        }

        # If the worst-case slack was < 0 we have failing paths
        if {[__is_number [lindex $wc_slack_tracer 0]] == 1} {
            if {[lindex $wc_slack_tracer 0] < 0 } {
                __add_data resultobj "All Failing Paths" ">0" ""
            } else {
                __add_data resultobj "All Failing Paths" "0" ""
            }
        } else {
            __add_data resultobj "All Failing Paths" "unknown" ""
        }

        # Compute System Fmax and Period
		set geomean 0.00
        set geomean_count 0
        set fmax_list [get_clock_fmax_info]
        post_message "Inspecting clock Fmax list: $fmax_list"
        foreach element $fmax_list {
            post_message "Inspecting clock fmax: $element"
            # Format is { <clk_name> <slack> <keeper tns> <edge tns> }
            set clk_name [lindex $element 0]
            set fmax [lindex $element 1]
            set restricted_fmax [lindex $element 2]
			# Calculate the period using fmax
			if { [catch {format "%.3f" [expr { 1000 / $fmax }]} period] } {
				set period "unknown"
			}

            __add_data resultobj "Clock Setup: '$clk_name': Fmax" "$fmax" "MHz"
            __add_data resultobj "Clock Setup: '$clk_name': Restricted Fmax" "$restricted_fmax" "MHz"
			__add_data resultobj "Clock Setup: '$clk_name': Actual Time" "$period" "ns"
			if {[__is_number $period]} {
				set geomean [expr {$geomean + log($period)}]
				incr geomean_count
			}
        }
		# Finish the geometric mean of all the clock periods calculation
        if {$geomean_count != 0} {
            set geomean [expr {double(round(exp($geomean/$geomean_count) * 100))/100}]
        } else {
            set geomean "unknown"
        }
		__add_data resultobj "Clock Period: Geometric Mean" "$geomean" "ns"

        # TNS totals
        post_message "Generating TNS totals"
        set total_keeper_tns [expr { $total_setup_keeper_tns + $total_hold_keeper_tns + $total_removal_keeper_tns + $total_recovery_keeper_tns }]
        __add_data resultobj "Clock Setup: Total Keeper TNS" "$total_setup_keeper_tns" "ns"
        __add_data resultobj "Clock Hold: Total Keeper TNS" "$total_keeper_tns" "ns"
        __add_data resultobj "Clock Recovery: Total Keeper TNS" "$total_recovery_keeper_tns" "ns"
        __add_data resultobj "Clock Removal: Total Keeper TNS" "$total_removal_keeper_tns" "ns"
        __add_data resultobj "Total Keeper TNS" "$total_keeper_tns" "ns"

        #
        # DUMP THE RESULTS TO XML
        #
        # The name of the XML file is ${point}-$dse_model_name -- this
        # lines it up with with DSE uses internally as the name of the model.
        $resultobj setName "${point}-${dse_model_name}"
        $resultobj setCompiled 1
        set xmlfilename "${point}-${dse_model_name}.xml"
        if {[file exists $xmlfilename]} {
            catch {file delete -force $xmlfilename}
        }
        if {![catch {open ${xmlfilename} {WRONLY CREAT TRUNC}} xmlfh]} {
            post_message "Dumping results for point $point ([$resultobj getName]) to: ${xmlfilename}"
            $resultobj dumpXML $xmlfh
            close $xmlfh
        }
		
		# Reset the design
		reset_design
    }
    project_close
}

##
## COMMAND LINE ARGUMENT PARSING, SETUP
##

# Command line options to this script
set         tlist       "project.arg"
lappend     tlist       "#_required_#"
lappend     tlist       "The name of the Quartus II project"
lappend options $tlist

set         tlist       "revision.arg"
lappend     tlist       "#_required_#"
lappend     tlist       "The name of the revision to use"
lappend options $tlist

set         tlist       "command.arg"
lappend     tlist       "#_required_#"
lappend     tlist       "The command to execute"
lappend options $tlist

set         tlist       "point.arg"
lappend     tlist       "#_optional_#"
lappend     tlist       "The point we're gathering timing results for (for -command extract_timing)"
lappend options $tlist

array set optshash [cmdline::getFunctionOptions ::quartus(args) $options]

# Check that we got all our options
foreach opt [array names optshash] {
    if {$optshash($opt) == "#_required_#"} {
        ::quartus::dse::ccl::eputs "Missing required option: -$opt"
        exit 1
    }
}

##
## MAIN SCRIPT SECTION BEGINS HERE!
##

# Do what ever the user asked us to do
switch -- $optshash(command) {
    get_available_operating_conditions {
        post_message -type info "Executing command: get_avaiable_operating_conditions"
        project_open -force -revision $optshash(revision) $optshash(project)
        create_timing_netlist -no_report
		set op_list [list]
		foreach_in_collection {op} [get_available_operating_conditions] {
			lappend op_list "[get_operating_conditions_info $op -model]_[get_operating_conditions_info $op -voltage]mV_[get_operating_conditions_info $op -temperature]C"
		}
        post_message -type info "Operating conditions: $op_list"
        project_close
    }

    extract_timing {
        if {$optshash(point) == "#_optional_#"} {
            ::quartus::dse::ccl::eputs "Missing required option: -point"
            exit 1
        }
        post_message -type info "Executing command: extract_timing"
        extract_timing $optshash(project) $optshash(revision) $optshash(point)
    }

    default {
        post_message -type error "Unrecognized command: $optshash(command)"
        exit 1
    }
}

exit 0
