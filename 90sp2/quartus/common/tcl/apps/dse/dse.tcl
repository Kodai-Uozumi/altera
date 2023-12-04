
#############################################################################
##  dse.tcl
##
##  The Design Space Explorer Tcl Script
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

#############################################################################
##  Additional Packages Required
package require cmdline
package require ::quartus::dse::gui
package require ::quartus::dse::flows
package require ::quartus::dse::designspace
package require ::quartus::dse::ccl
package require ::quartus::dse::seed
package require ::quartus::dse::logiclock
package require ::quartus::misc
package require ::quartus::incremental_compilation


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse {

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!

    # This is the version of Quartus II that DSE is being run with
    variable quartus_version

    # This is the version of Quartus II we require for this version of DSE
    variable require_quartus_version 9.0

    # This is the version of DSE
    variable version 9.0

    # This is an array that stores a bunch of base point settings used by
    # the compilation time estimation and by the Selective Optimization
    # spaces
    variable base_point_options

    # Optimization goals and search methods available from the command line
    variable available_optimization_goals [list "Optimize for Speed" "Optimize for Area" "Optimize for Power" "Optimize for Negative Slack and Failing Paths" "Optimize for Average Period" "Optimize for Quality of Fit"]
    variable available_search_methods [list "Exhaustive Search of Exploration Space" "Accelerated Search of Exploration Space"]

}


#############################################################################
##  Start of Script

# For debug messages
set debug_name "DSE()"

# This is a global array that's used all over the place to do option passing
# between the various DSE modules. We'll declare it here. And put in some
# top-level DSE-wide array settings. All the top-level settings are prefixed
# with dse-*. We won't load the stored settings from disk yet. We'll leave that
# up to the flow (gui or cmdline) to do because really only the GUI flow should
# be loading saved values.
global global_dse_options
set global_dse_options(dse-debug) 0
set global_dse_options(dse-gui) 0

# Figure out how this script is being run
if {![array exists ::quartus]} {
    # Couldn't find a $::quartus array!
    ::quartus::dse::ccl::eputs "DSE must be run through quartus_sh"
    ::quartus::dse::ccl::eputs "For more help see: quartus_sh --help=dse"
    exit 1
}

# Make sure this version of Quartus is high enough for this
# version of DSE.
if {![regexp -nocase -- {Version\s+(\d+\.\d+)} $::quartus(version) => quartus_version]} {
    ::quartus::dse::ccl::eputs "Unable to get Quartus II version from \$::quartus(version) array"
    ::quartus::dse::ccl::eputs "Your version of Quartus II probably isn't high enough to run"
    ::quartus::dse::ccl::eputs "this version of Design Space Explorer!"
    ::quartus::dse::ccl::eputs "You need Quartus II $::quartus::dse::require_quartus_version or higher for this"
    ::quartus::dse::ccl::eputs "version of Design Space Explorer."
    exit 1
} else {
    if {$quartus_version < $::quartus::dse::require_quartus_version} {
        ::quartus::dse::ccl::eputs "You need Quartus II $::quartus::dse::require_quartus_version or higher for this"
        ::quartus::dse::ccl::eputs "version of Design Space Explorer."
        exit 1
    }
}

::quartus::dse::ccl::iputs "Design Space Explorer is being run by [get_quartus_legal_string -product] $::quartus(version)"

# Command line options to this script
set         tlist       "nogui"
lappend     tlist       0
lappend     tlist       "Runs DSE is command line mode instead of GUI mode"
lappend function_opts $tlist

set         tlist       "project.arg"
lappend     tlist       "#_required_#"
lappend     tlist       "The name of the Quartus II project"
lappend function_opts $tlist

set         tlist       "revision.arg"
lappend     tlist       "#_ignore_#"
lappend     tlist       "The name of the revision to use"
lappend function_opts $tlist

set         tlist       "seeds.arg"
lappend     tlist       "3,5,7,11"
lappend     tlist       "A comma-separated list of seeds to sweep"
lappend function_opts $tlist

set         tlist       "exploration-space.arg"
lappend     tlist       "#_default_#"
lappend     tlist       "The type of space you want to explore"
lappend function_opts $tlist

set         tlist       "optimization-goal.arg"
lappend     tlist       "Optimize for Speed"
lappend     tlist       "The optimization goal for the this DSE run"
lappend function_opts $tlist

set         tlist       "search-method.arg"
lappend     tlist       "Accelerated Search of Exploration Space"
lappend     tlist       "The search method to use for the this DSE run"
lappend function_opts $tlist

set         tlist       "custom-file.arg"
lappend     tlist       "#_ignore_#"
lappend     tlist       "The XML file to load the custom space from if you use -space {Custom Space}"
lappend function_opts $tlist

set         tlist       "stop-after-time.arg"
lappend     tlist       "#_ignore_#"
lappend     tlist       "Stop exploration after time has elapsed (time format should be dd:hh:mm)"
lappend function_opts $tlist

set         tlist       "stop-after-zero-failing-paths"
lappend     tlist       0
lappend     tlist       "Stop exploration after zero failing paths have been achieved"
lappend function_opts $tlist

set         tlist       "ignore-failed-base"
lappend     tlist       0
lappend     tlist       "Ignore a failing base compile and continue with exploration"
lappend function_opts $tlist

set         tlist       "archive"
lappend     tlist       0
lappend     tlist       "If set script should archive every compile, not just base/best compiles"
lappend function_opts $tlist

set         tlist       "run-power"
lappend     tlist       0
lappend     tlist       "Run the Quartus II PowerPlay Power Analyzer during exploration"
lappend function_opts $tlist

set         tlist       "dump-xml"
lappend     tlist       0
lappend     tlist       "If true dumps XML space file to disk"
lappend function_opts $tlist

set         tlist       "decision-column.arg"
lappend     tlist       "#_default_#"
lappend     tlist       "An alternate column name to use for slack values"
lappend function_opts $tlist

set         tlist       "slaves.arg"
lappend     tlist       ""
lappend     tlist       "A comma-separated list of additional slave machines to use for parallel compiles"
lappend function_opts $tlist

set         tlist       "concurrent-compiles.arg"
lappend     tlist       1
lappend     tlist       "Integer number of concurrent parallel compiles to perform on this machine"
lappend function_opts $tlist

set         tlist       "llr-restructuring"
lappend     tlist       0
lappend     tlist       "Allow DSE to change, add or delete regions from your existing LogicLock hierarchy to improve performance"
lappend function_opts $tlist

set         tlist       "use-lsf"
lappend     tlist       0
lappend     tlist       "Use LSF resources for parallel compiles"
lappend function_opts $tlist

set         tlist       "lsf-queue.arg"
lappend     tlist       "#_default_#"
lappend     tlist       "Use a non-default LSF queue"
lappend function_opts $tlist

set         tlist       "lower-priority"
lappend     tlist       0
lappend     tlist       "Lower the priority of compiles"
lappend function_opts $tlist

set         tlist       "report-all-resource-usage"
lappend     tlist       0
lappend     tlist       "Report all resource usage numbers in the DSE output and reports"
lappend function_opts $tlist

set         tlist       "skip-base"
lappend     tlist       0
lappend     tlist       "Skip the base compile if at all possible"
lappend function_opts $tlist

set         tlist       "revisions-only"
lappend     tlist       0
lappend     tlist       "Create revisions in the project, but don't compile them"
lappend function_opts $tlist

set         tlist       "debug"
lappend     tlist       0
lappend     tlist       "If true turns on debug messages and debugging code"
lappend function_opts $tlist

set         tlist       "help"
lappend     tlist       0
lappend     tlist       "True if user wants help message printed"
lappend function_opts $tlist

array set optshash [cmdline::getFunctionOptions ::quartus(args) $function_opts]

# Does the user just want help
if {$optshash(help)} {
    ::quartus::dse::ccl::dputs "${debug_name}: User asked for help"
    puts [exec -- [file join $::quartus(binpath) quartus_sh] --help=dse]
    exit 1
}

# There is is anything left in ::quartus(args) it was an
# unrecognized option. That should be an error.
if {[llength $::quartus(args)] != 0} {
    ::quartus::dse::ccl::eputs "Unrecognized option(s): $::quartus(args)"
    ::quartus::dse::ccl::eputs "Use: quartus_sh --help=dse to see valid command line options"
    exit 1
}

# Load up some default top-level global_dse_options
set global_dse_options(dse-debug) $optshash(debug)
if {!$optshash(nogui)} {
    set global_dse_options(dse-gui) 1
} else {
    set global_dse_options(dse-gui) 0
}

# Start the GUI unless the user said -nogui on the command line
if {$global_dse_options(dse-gui)} {

    # Run DSE in GUI mode
    global exit_dse_gui
    set exit_dse_gui 0

    # We need to init_tk
    if {[catch {init_tk}]} {
        puts "Error: Could not initialize Tk engine -- init_tk failed"
        puts "Error: Are you sure you're running with quartus_sh?"
        exit 1
    }

    # This script must be run using the Quartus II Shell
    if {[info exist ::quartus]} {
        if { ![string equal $::quartus(nameofexecutable) quartus_sh] } {
            set msg "DSE should be invoked from the command line using the Quartus II Shell.\nUsage: quartus_sh --dse \[<options>\]"
            puts $msg
            catch { tk_messageBox -type ok -message $msg -icon error -title "DSE Error"}
            exit 1
        }
    } else {
        set msg "DSE should be invoked using the Quartus II Shell.\nUsage: quartus_sh --dse \[<options>\]"
        puts $msg
        catch { tk_messageBox -type ok -message $msg -icon error }
        exit 1
    }

    # Invoke main proc to start the application
    set mainopts [list]
    if {$optshash(project) != "#_required_#"} {
        lappend mainopts "-project"
        lappend mainopts $optshash(project)
        if {$optshash(revision) != "#_ignore_#"} {
            lappend mainopts "-revision"
            lappend mainopts $optshash(revision)
        }
    }

    eval ::quartus::dse::gui::main $mainopts

    # And wait to exit
    vwait exit_dse_gui
    exit 0

} else {

    # Command line mode

    # This script must be run using the Quartus II Shell
    if {[info exist ::quartus]} {
        if { ![string equal $::quartus(nameofexecutable) quartus_sh] } {
            set msg "DSE should be invoked from the command line using the Quartus II Shell.\nUsage: quartus_sh --dse \[<options>\]"
            puts $msg
            exit 1
        }
    } else {
        set msg "DSE should be invoked using the Quartus II Shell.\nUsage: quartus_sh --dse \[<options>\]"
        puts $msg
        exit 1
    }

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            ::quartus::dse::ccl::eputs "Missing required option: -$opt"
            exit 1
        }
    }

    # If they're using -space=Custom then the -file=<file> argument is required
    if {[string equal -nocase $optshash(exploration-space) "Custom Space"]} {
        # Did they forget to give us a file?
        if {$optshash(custom-file) == "#_ignore_#"} {
            ::quartus::dse::ccl::eputs "Custom exploration requested but no file was specified"
            ::quartus::dse::ccl::eputs "If you say -exploration-space {Custom Space} you have to"
            ::quartus::dse::ccl::eputs "provide an XML file that defines the custom space"
            ::quartus::dse::ccl::eputs "with -custom-file <filename>"
            exit 1
        }
        # Does the file exist?
        if {![file exists $optshash(custom-file)] || ![file isfile $optshash(custom-file)]} {
            ::quartus::dse::ccl::eputs "Custom exploration space file was not found"
            ::quartus::dse::ccl::eputs "Are you sure $optshash(custom-file) exists?"
            exit 1
        }
    }

    # Check the format of the seeds option and make a list
    set seeds [list]
    if {[catch {set seeds [::quartus::dse::ccl::get_seed_list "$optshash(seeds)"]} status]} {
     	::quartus::dse::ccl::eputs $status
     	exit 1
 	}

    # Stop after time has to be dd:hh:mm
    if {$optshash(stop-after-time) != "#_ignore_#"} {
        if {[regexp -nocase -- {0?(\d+):0?(\d+):0?(\d+)} $optshash(stop-after-time) => days hours minutes]} {
            # Figure out how many minutes to stop after
            set minutes [expr {$minutes + ($hours * 60)}]
            set minutes [expr {$minutes + ($days * 24 * 60)}]
            set optshash(stop-after-time) $minutes
        } else {
            ::quartus::dse::ccl::eputs "the -stop-after-time value must be in the"
            ::quartus::dse::ccl::eputs "form <dd:hh:mm>"
            exit 1
        }
        ::quartus::dse::ccl::dputs "${debug_name}: Stopping exploration after $optshash(stop-after-time) minutes"
    }

    # Check write permissions on the working directory and the .qpf file
    set file_name [file normalize $optshash(project)]
	set working_dir [file dirname $file_name]
    regexp -nocase -- {\.(\w+?)$} [file tail $file_name] => file_ext
	if {![regexp -nocase -- {\.(\w+?)$} [file tail $file_name] => file_ext]} {
		set file_ext "qpf"
		set file_name "${file_name}.qpf"
	}
	::quartus::dse::ccl::dputs "${debug_name}: Devined file name for project: $file_name"
	::quartus::dse::ccl::dputs "${debug_name}: Devined working dir for project: $working_dir"
	if { ![file writable $file_name] } {
		::quartus::dse::ccl::eputs "Project file $file_name is not writeable.\nPlease make $file_name writeable and try opening it in DSE again."
		exit 1
	}

    # The project directory has to be user writeable otherwise DSE doesn't
	# work the way it should.
	if { ![file writable $working_dir] } {
		::quartus::dse::ccl::eputs "Project diretory $working_dir is not writeable.\nPlease make $working_dir writeable and try opening the project in DSE again."
		exit 1
	}

    # Project has to exist
    if {![project_exists $optshash(project)]} {
        ::quartus::dse::ccl::eputs "Unable to open project $optshash(project)"
        ::quartus::dse::ccl::eputs "Are you sure this project exists?"
        exit 1
    }

    # Get the revision name first if the user didn't give us one
    if {$optshash(revision) == "#_ignore_#"} {
        if { [llength [get_project_revisions $optshash(project)]] > 0 } {
            set optshash(revision) [lindex [get_project_revisions $optshash(project)] 0]
        }
    }

    # Open the project
    if {$optshash(revision) == "#_ignore_#"} {
        project_open -force "$optshash(project)"
        set optshash(revision) [get_current_revision]
    } else {
        project_open -force -revision "$optshash(revision)" "$optshash(project)"
    }

    # Figure out the family for this project
    set optshash(family) [get_global_assignment -name family]

    # Check for DO_COMBINED_ANALYSIS in the design. We need to note
    # if combined analysis is off or on in order to parse the results
    # of this design in an appropriate fashion.
    set temp [get_global_assignment -name DO_COMBINED_ANALYSIS]
    if {$temp == ""} {
        set temp "OFF"
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found DO_COMBINED_ANALYSIS = $temp for this project"
    if {[string equal -nocase $temp "on"]} {
        set optshash(do-combined-analysis) 1
    } else {
        set optshash(do-combined-analysis) 0
    }

    # Check for STA_MODE in this design. If the user is doing timing
    # analysis with the TimeQuest Static Timing Analyzer we will
    # collect data slightly differently. Also, if TimeQuest is in use
    # we don't need to worry about fast/slow timing models from the
    # DO_COMBINED_ANALYSIS setting.
    set optshash(timequest) 0
    if {[get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] == ""} {
        if {[test_family_trait_of -family [get_global_assignment -name FAMILY] -trait USE_STA_BY_DEFAULT]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Project is using TimeQuest"
            set optshash(timequest) 1
        }
    } else {
        if {[string equal -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] "on"]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Project is using TimeQuest"
            set optshash(timequest) 1
        }
    }
    # If TimeQuest is in use check to see if the multicorner analysis is in use.
    if { $optshash(timequest) } {
        set temp [get_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS]
        if {$temp == ""} {
            set temp "OFF"
        }
        ::quartus::dse::ccl::dputs "${debug_name}: Found TIMEQUEST_MULTICORNER_ANALYSIS = $temp for this project"
        if {[string equal -nocase $temp "on"]} {
            set optshash(do-combined-analysis) 1
        } else {
            set optshash(do-combined-analysis) 0
        }
    }

    # If TimeQuest is being used we need to make sure the user has specified
    # some constraints. Otherwise running DSE doesn't make any sense.
    if { $optshash(timequest) } {
        # Check to see if an SDC_FILE setting exists. If it doesn't check
        # to see if a <revision>.sdc file exists. If both these checks
        # fail don't allow the user to run DSE on this project because it
        # has no timing constraints and is using TimeQuest.
        set sdc_file_list [list]
        foreach_in_collection instance [get_all_global_assignments -name SDC_FILE] {
            lappend sdc_file_list [lindex $instance 2]
        }
        if { [llength $sdc_file_list] == 0 || [file exists [get_current_revision].sdc] } {
            lappend sdc_file_list [get_current_revision].sdc
        }
        foreach {sdc_file} $sdc_file_list {
            if { ![file exists $sdc_file] } {
                ::quartus::dse::ccl::eputs "Unable to find SDC file:"
                ::quartus::dse::ccl::eputs "\t$sdc_file"
                ::quartus::dse::ccl::eputs "You cannot use Design Space Explorer and TimeQuest without"
                ::quartus::dse::ccl::eputs "a valid set of timing constraints for your design."
                project_close
                exit 1
            } else {
                ::quartus::dse::ccl::dputs "${debug_name}: Found SDC file $sdc_file"
            }
        }
    }

    #
    # START SPR:287960 - Make sure all the partitions have their appropriate
    # source if DSE is being used in any sort of parallel or distributed
    # capacity.
    if { $optshash(concurrent-compiles) > 1 || $optshash(use-lsf) || [llength [split $optshash(slaves) ","]] > 0 } {
        ::quartus::dse::ccl::dputs "${debug_name}: User is performing some form of parallel or distributed compilation -- checking partitions in design..."
        array set missing_partitions [list]
        foreach {partition} [get_partition] {
            set netlist_type [get_partition -partition $partition -netlist_type]
            # Skip missing Source File netlists -- that's okay
            if {[regexp -nocase -- {source file} $netlist_type]} {
                continue
            }
            set value [partition_netlist_exists -partition $partition -netlist_type $netlist_type]
            if {$value} {
                ::quartus::dse::ccl::dputs "${debug_name}:    $partition, $netlist_type - EXISTS"
            } else {
                ::quartus::dse::ccl::dputs "${debug_name}:    $partition, $netlist_type - MISSING"
                lappend missing_partitions([string tolower $netlist_type]) $partition
            }
        }
        # We found partitions that were missing their netlists. This is not
        # allowed. Error here with some information for the user.
        if { [llength [array names missing_partitions]] > 0 } {
            set msg ""
            foreach {netlist_type} [array names missing_partitions] {
                append msg "The following $netlist_type partitions are missing netlists:\n\n"
                foreach {partition} $missing_partitions($netlist_type) {
                    append msg "    $partition\n"
                }
                append msg "\n"
                append msg "Before you can compile this design in DSE you must ensure all\n"
                append msg "$netlist_type partition netlists exist.\n"
                append msg "\n"
            }
            append msg "Please perform a full compilation of the design with the Quartus II\n"
            append msg "software before attempting to use DSE with the design"
            if { $optshash(concurrent-compiles) > 1 } {
                append msg " or omit the\n-concurrent-compiles option when calling DSE.\n"
            } elseif { $optshash(use-lsf) } {
                append msg " or omit the\n-use-lsf option when calling DSE.\n"
            } elseif { [llength [split $optshash(slaves) ","]] > 0 } {
                append msg " or omit the\n-slaves option when calling DSE.\n"
            } else {
                append msg ".\n"
            }
            append msg "\n"
            append msg "For more information, refer to Troubleshooting Design Space Explorer in\n"
            append msg "the Quartus II Help."
            ::quartus::dse::ccl::eputs $msg
            project_close
            exit 1
        }
    }
    # END SPR:287960
    #

    # Get some of the base point options used in the Selective Optimization spaces
    ::quartus::dse::designspace::get_base_point_options

    # Close the project and start the flow
    project_close

    # Call the init functions
    ::quartus::dse::ccl::init $optshash(project) $optshash(revision) "${optshash(revision)}.dse.rpt"
    ::quartus::dse::flows::init

    # Figure out the decision function to use
    switch -- $optshash(optimization-goal) {
        {Optimize for Speed} {
            set decision_function {::quartus::dse::flows::simple_slack_best_worst_analysis}
        }
        {Optimize for Area} {
            set decision_function {::quartus::dse::flows::simple_area_best_worst_analysis}
        }
        {Optimize for Failing Paths} {
            set decision_function {::quartus::dse::flows::simple_failing_paths_best_worst_analysis}
        }
        {Optimize for Power} {
            set decision_function {::quartus::dse::flows::simple_power_best_worst_analysis}
            # Ensure the user is running quartus_pow or else this option is nearly useless
            set optshash(run-power) 1
        }
        {Optimize for Negative Slack and Failing Paths} {
            set decision_function {::quartus::dse::flows::average_slack_for_failing_paths_best_worst_analysis}
        }
        {Optimize for Average Period} {
            set decision_function {::quartus::dse::flows::simple_geomean_period_best_worst_analysis}
        }
        {Optimize for Quality of Fit} {
            set decision_function {::quartus::dse::flows::qof_best_worst_analysis}
        }
        default {
            ::quartus::dse::ccl::eputs "The optimization goal \"$optshash(optimization-goal)\""
            ::quartus::dse::ccl::eputs "was not recognized. Valid -optimization-goal options are:"
            foreach goal $::quartus::dse::available_optimization_goals {
                ::quartus::dse::ccl::eputs "\t\t-optimization-goal \"$goal\""
            }
            exit 1
        }
    }

    # Figure out the flow function to use
    switch -- $optshash(search-method) {
        {Exhaustive Search of Exploration Space} {
            set flow_function {::quartus::dse::flows::exhaustive_flow}
        }
        {Accelerated Search of Exploration Space} {
            set flow_function {::quartus::dse::flows::accelerated_flow}
        }
        default {
            ::quartus::dse::ccl::eputs "The search method \"$optshash(search-method)\""
            ::quartus::dse::ccl::eputs "was not recognized. Valid -search-method options are:"
            variable available_search_methods
            foreach sm $::quartus::dse::available_search_methods {
                ::quartus::dse::ccl::eputs "\t\t-search-method \"$sm\""
            }
            exit 1
        }
    }

    # If the user passed -revisions-only the only type of flow function we
    # can use is create_revisions.
    if {$optshash(revisions-only)} {
        set flow_function {::quartus::dse::flows::create_revisions}
    }

    # Print a warning if the user is trying to do more than one
    # concurrent compile so they know about resource issues.
    if {$optshash(concurrent-compiles) > 1} {
        ::quartus::dse::ccl::wputs "You are specifying that this computer perform more than one compilation\nsimultaneously. Performing more than one compilation requires significant\ncomputing power, memory resources, and additional Quartus II licenses. If you\nexperience problems exploring $optshash(concurrent-compiles) points\nsimultaneously, reduce the number of concurrent compilations to free resources\nand improve performance."
    }

    # Clear flow options
    set flowopts ""
    global global_dse_options

    # Find the space library for this family
    regsub -all -nocase -- {\s+} [string tolower $optshash(family)] {} family_modified
    switch -exact -- $family_modified {
        stratix -
        stratixgx {
            ::quartus::dse::ccl::iputs "Using stratix family space library"
            package require ::quartus::dse::stratix
            set get_description_for_space   ::quartus::dse::stratix::get_description_for_type
            set get_valid_spaces            ::quartus::dse::stratix::get_valid_types
            set is_valid_space              ::quartus::dse::stratix::is_valid_type
            set set_design_space            ::quartus::dse::stratix::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
        cyclone {
            ::quartus::dse::ccl::iputs "Using cyclone family space library"
            package require ::quartus::dse::cyclone
            set get_description_for_space   ::quartus::dse::cyclone::get_description_for_type
            set get_valid_spaces            ::quartus::dse::cyclone::get_valid_types
            set is_valid_space              ::quartus::dse::cyclone::is_valid_type
            set set_design_space            ::quartus::dse::cyclone::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
        maxii {
            ::quartus::dse::ccl::iputs "Using max ii family space library"
            package require ::quartus::dse::maxii
            set get_description_for_space   ::quartus::dse::maxii::get_description_for_type
            set get_valid_spaces            ::quartus::dse::maxii::get_valid_types
            set is_valid_space              ::quartus::dse::maxii::is_valid_type
            set set_design_space            ::quartus::dse::maxii::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
        max3000a -
        max7000ae -
        max7000b -
        max7000s {
            ::quartus::dse::ccl::iputs "Using max 7000 family space library"
            ::quartus::dse::ccl::wputs "MAX7000 family detected: your -seeds option will be ignored: seeds are not relevant"
            ::quartus::dse::ccl::wputs "MAX7000 family detected: your -search-method will be ignored: using exhaustive search"
            set seeds [list]
            package require ::quartus::dse::max7000
            set get_description_for_space   ::quartus::dse::max7000::get_description_for_type
            set get_valid_spaces            ::quartus::dse::max7000::get_valid_types
            set is_valid_space              ::quartus::dse::max7000::is_valid_type
            set set_design_space            ::quartus::dse::max7000::set_design_space
            set flow_function {::quartus::dse::flows::exhaustive_flow}
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Synthesis Space"
            }
        }
        flex6000 {
            ::quartus::dse::ccl::iputs "Using flex 6000 family space library"
            ::quartus::dse::ccl::wputs "FLEX6000 family detected: your -seeds option will be ignored: seeds are not relevant"
            ::quartus::dse::ccl::wputs "FLEX6000 family detected: your -search-method will be ignored: using exhaustive search"
            set seeds [list]
            package require ::quartus::dse::flex6000
            set get_description_for_space   ::quartus::dse::flex6000::get_description_for_type
            set get_valid_spaces            ::quartus::dse::flex6000::get_valid_types
            set is_valid_space              ::quartus::dse::flex6000::is_valid_type
            set set_design_space            ::quartus::dse::flex6000::set_design_space
            set flow_function {::quartus::dse::flows::exhaustive_flow}
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Synthesis Space"
            }
        }
        stratixii -
        stratixiigx {
            ::quartus::dse::ccl::iputs "Using stratix ii family space library"
            package require ::quartus::dse::stratixii
            set get_description_for_space   ::quartus::dse::stratixii::get_description_for_type
            set get_valid_spaces            ::quartus::dse::stratixii::get_valid_types
            set is_valid_space              ::quartus::dse::stratixii::is_valid_type
            set set_design_space            ::quartus::dse::stratixii::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
		arriagx -
        arria {
            ::quartus::dse::ccl::iputs "Using arria family space library"
            package require ::quartus::dse::arria
            set get_description_for_space   ::quartus::dse::arria::get_description_for_type
            set get_valid_spaces            ::quartus::dse::arria::get_valid_types
            set is_valid_space              ::quartus::dse::arria::is_valid_type
            set set_design_space            ::quartus::dse::arria::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
        stratixiii {
            ::quartus::dse::ccl::iputs "Using stratix iii family space library"
            package require ::quartus::dse::stratixiii
            set get_description_for_space   ::quartus::dse::stratixiii::get_description_for_type
            set get_valid_spaces            ::quartus::dse::stratixiii::get_valid_types
            set is_valid_space              ::quartus::dse::stratixiii::is_valid_type
            set set_design_space            ::quartus::dse::stratixiii::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
		stratixiv -
        arriaii -
        arriaiigx {
			::quartus::dse::ccl::iputs "Using stratix iv family space library"
            package require ::quartus::dse::stratixiv
            set get_description_for_space   ::quartus::dse::stratixiv::get_description_for_type
            set get_valid_spaces            ::quartus::dse::stratixiv::get_valid_types
            set is_valid_space              ::quartus::dse::stratixiv::is_valid_type
            set set_design_space            ::quartus::dse::stratixiv::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
		}
        cycloneiii {
            ::quartus::dse::ccl::iputs "Using cyclone iii family space library"
            package require ::quartus::dse::cycloneiii
            set get_description_for_space   ::quartus::dse::cycloneiii::get_description_for_type
            set get_valid_spaces            ::quartus::dse::cycloneiii::get_valid_types
            set is_valid_space              ::quartus::dse::cycloneiii::is_valid_type
            set set_design_space            ::quartus::dse::cycloneiii::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
        cycloneii {
            ::quartus::dse::ccl::iputs "Using cyclone ii family space library"
            package require ::quartus::dse::cycloneii
            set get_description_for_space   ::quartus::dse::cycloneii::get_description_for_type
            set get_valid_spaces            ::quartus::dse::cycloneii::get_valid_types
            set is_valid_space              ::quartus::dse::cycloneii::is_valid_type
            set set_design_space            ::quartus::dse::cycloneii::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
        hardcopystratix {
            ::quartus::dse::ccl::iputs "Using generic family space library"
            if {$optshash(llr-restructuring)} {
                ::quartus::dse::ccl::wputs "HardCopy Stratix family detected: your -llr-restructuring option will be ignored: no llr restructuring will be done"
                set optshash(llr-restructuring) 0
            }
            package require ::quartus::dse::genericfamily
            set get_description_for_space   ::quartus::dse::genericfamily::get_description_for_type
            set get_valid_spaces            ::quartus::dse::genericfamily::get_valid_types
            set is_valid_space              ::quartus::dse::genericfamily::is_valid_type
            set set_design_space            ::quartus::dse::genericfamily::set_design_space
            # Make sure the flow options include the -hardcopy flag
            lappend flowopts "-hardcopy"
            set global_dse_options(flow-hardcopy) 1
        }
        hardcopyii {
            ::quartus::dse::ccl::iputs "Using hardcopy ii family space library"
            package require ::quartus::dse::hardcopyii
            set get_description_for_space   ::quartus::dse::hardcopyii::get_description_for_type
            set get_valid_spaces            ::quartus::dse::hardcopyii::get_valid_types
            set is_valid_space              ::quartus::dse::hardcopyii::is_valid_type
            set set_design_space            ::quartus::dse::hardcopyii::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
        default {
            # Every other family can probably use this
            ::quartus::dse::ccl::iputs "Using generic family space library"
            package require ::quartus::dse::genericfamily
            set get_description_for_space   ::quartus::dse::genericfamily::get_description_for_type
            set get_valid_spaces            ::quartus::dse::genericfamily::get_valid_types
            set is_valid_space              ::quartus::dse::genericfamily::is_valid_type
            set set_design_space            ::quartus::dse::genericfamily::set_design_space
            if {$optshash(exploration-space) == "#_default_#"} {
                set optshash(exploration-space) "Seed Sweep"
            }
        }
    }

    # Create the designspace object
    set designspace [::quartus::dse::designspace #auto $optshash(project) $optshash(revision)]
    if {$designspace == ""} {
        ::quartus::dse::ccl::eputs "Couldn't create a designspace object for you!"
        exit 1
    }

    # Create an empty results array
    array set results [list]

    # Check that the type of space they want to explore is valid
    if {![$is_valid_space $optshash(exploration-space)]} {
        ::quartus::dse::ccl::eputs "Exploration space \"$optshash(exploration-space)\""
        ::quartus::dse::ccl::eputs "was not recognized. Available exploration spaces for"
        ::quartus::dse::ccl::eputs "this family are:"
        foreach space [$get_valid_spaces] {
            ::quartus::dse::ccl::eputs "\t\t-exploration-space \"${space}\""
        }
        exit 1
    }

    # Load the LogicLock space
    if {$optshash(llr-restructuring)} {
        ::quartus::dse::ccl::iputs "Loading space: LogicLock"
        if {![::quartus::dse::logiclock::set_design_space $designspace -soften -remove]} {
            ::quartus::dse::ccl::eputs "Could not load LogicLock space."
            exit 1
        }
    } else {
        if {![::quartus::dse::logiclock::set_design_space $designspace]} {
            ::quartus::dse::ccl::eputs "Could not load an empty LogicLock space."
            exit 1
        }
    }

    # Load the space
    ::quartus::dse::ccl::iputs "Loading space: $optshash(exploration-space)"
    if {![$set_design_space $designspace $optshash(exploration-space) $optshash(custom-file)]} {
        ::quartus::dse::ccl::eputs "Could not load space $optshash(exploration-space)"
        exit 1
    }

    # Load the seed space
    ::quartus::dse::ccl::iputs "Loading space: Seeds"
    if {![::quartus::dse::seed::set_design_space $designspace $seeds]} {
        ::quartus::dse::ccl::eputs "Could not load seed space."
        exit 1
    }

    # If the user is running a custom space load it now
    if {[string equal $optshash(exploration-space) "Custom Space"]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Checking for custom space file: $optshash(custom-file)"
        if {![file exists $optshash(custom-file)] || ![file isfile $optshash(custom-file)]} {
            ::quartus::dse::ccl::eputs "Custom space file $optshash(custom-file) does not exist"
            exit 1
        }
        ::quartus::dse::ccl::dputs "${debug_name}: Custom space file exists"
        ::quartus::dse::ccl::dputs "${debug_name}: Opening custom space file: $optshash(custom-file)"
        if {[catch {open $optshash(custom-file)} xmlfh]} {
            ::quartus::dse::ccl::eputs "Error opening custom space file $optshash(custom-file)"
            ::quartus::dse::ccl::eputs "$xmlfh"
            exit 1
        } else {
            ::quartus::dse::ccl::dputs "${debug_name}: Loading custom space from file"
            if {[catch {$designspace loadXML $xmlfh} emsg]} {
                close $xmlfh
                ::quartus::dse::ccl::eputs "Error loading custom space file $optshash(custom-file)"
                ::quartus::dse::ccl::eputs "$emsg"
                exit 1
            }
            close $xmlfh
            ::quartus::dse::ccl::iputs "Custom space file $optshash(custom-file) loaded successfully"
        }
    }

    # Dump XML file if user asked for it
    if {$optshash(dump-xml)} {
        set fname $optshash(project).dse
        if {[catch {open $fname {WRONLY CREAT TRUNC}} xmlfh]} {
            ::quartus::dse::ccl::eputs "Could not dump exploration space to file $fname"
        } else {
            $designspace dumpXML $xmlfh
            close $xmlfh
            ::quartus::dse::ccl::iputs "Saved exploration space to file $fname"
        }
    }

    # Build up family-independent flow options
    lappend flowopts "-space"
    lappend flowopts $designspace
    set global_dse_options(flow-space) $designspace
    lappend flowopts "-results"
    lappend flowopts "results"
    set global_dse_options(flow-results) "results"
    lappend flowopts "-best-worst-function"
    lappend flowopts $decision_function
    set global_dse_options(flow-best-worst-function) $decision_function
    lappend flowopts "-slack-column"
    lappend flowopts [list $optshash(decision-column)]
    set global_dse_options(flow-slack-column) [list $optshash(decision-column)]
    lappend flowopts "-concurrent-compiles"
    lappend flowopts $optshash(concurrent-compiles)
    set global_dse_options(flow-concurrent-compiles) $optshash(concurrent-compiles)

    if {$optshash(use-lsf)} {
        # User wants to use LSF for the distributed compiles
        lappend flowopts "-lsfmode"
        lappend flowopts "-lsf-queue"
        lappend flowopts $optshash(lsf-queue)
        set global_dse_options(flow-lsfmode) 1
        set global_dse_options(flow-lsf-queue) $optshash(lsf-queue)
    } else {
        # User must have given us some slaves with -slaves
        set slavelist [list]
        foreach ts [split $optshash(slaves) ","] {
            # Remove leading and trailing white space
            regsub -all -nocase -- {^[ \t]+|[ \t]+$} $ts {} tsstripped
            # Examine the slave names to make sure they are legit
            ::quartus::dse::ccl::dputs "${debug_name}: Examining slave: \"$tsstripped\""
            # It cannot be an empty string
            if {[regexp -nocase -- {^\s*$|\s+} $tsstripped]} {
                ::quartus::dse::ccl::wputs "Slave \"$tsstripped\" is not a valid slave name -- ignoring"
                continue
            }
            # Accept the slave, put it on the list
            ::quartus::dse::ccl::dputs "${debug_name}: Accepted slave. $tsstripped is a valid slave name."
            lappend slavelist $tsstripped
        }
        if {[llength $slavelist] > 0} {
            lappend flowopts "-slaves"
            lappend flowopts $slavelist
            set global_dse_options(flow-slaves) $slavelist
        }
    }

    if {$optshash(stop-after-time) != "#_ignore_#"} {
        lappend flowopts "-stop-after-time"
        lappend flowopts $optshash(stop-after-time)
        set global_dse_options(flow-stop-after-time) $optshash(stop-after-time)
    }
    if {$optshash(stop-after-zero-failing-paths)} {
        lappend flowopts "-stop-after-zero-failing-paths"
        set global_dse_options(flow-stop-after-zero-failing-paths) 1
    }
    if {$optshash(archive)} {
        lappend flowopts "-archive"
        set global_dse_options(flow-archive) 1
    }
    if {$optshash(lower-priority)} {
        lappend flowopts "-lower-priority"
        set global_dse_options(flow-lower-priority) 1
    }
    if {$optshash(ignore-failed-base)} {
        lappend flowopts "-ignore-failed-base"
        set global_dse_options(flow-ignore-failed-base) 1
    }
    if {$optshash(run-power)} {
        lappend flowopts "-run-power"
        set global_dse_options(flow-run-power) 1
    }
    if {$optshash(skip-base)} {
        lappend flowopts "-skip-base"
        set global_dse_options(flow-skip-base) 1
    }
    if {$optshash(do-combined-analysis)} {
        lappend flowopts "-do-combined-analysis"
        set global_dse_options(flow-do-combined-analysis) 1
    }
    if {$optshash(timequest)} {
        lappend flowopts "-timequest"
        set global_dse_options(flow-timequest) 1
    }
    if {$optshash(report-all-resource-usage)} {
        set global_dse_options(flow-report-all-resource-usage) 1
    }

    #
    # CLEAN UP BEFORE WE EVEN START
    #
    # Delete an existing dse directory
    if {[file exists dse] && [file isdirectory dse]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Deleting existing result directory"
        if {[catch {file delete -force -- dse} err]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Unable to delete [file join [pwd] dse] ($err) - trying to delete individual files"
            # We couldn't delete the directory, try deleting the files
            foreach f [glob -nocomplain -directory [file join [pwd] dse] -- {*.{xml,qar,qarlog,csv}}]  {
                if {[catch {file delete -force -- $f} err]} {
                    set msg "Unable to delete $f\nPlease remove the directory [file join [pwd] dse] and try starting your search again."
                    ::quartus::dse::ccl::eputs $msg
                    exit 1
                }
            }

        }
        ::quartus::dse::ccl::dputs "${debug_name}: Cleaned up successfully!"
    }

    # Explore it
    set exploration_start_time [clock clicks -milliseconds]
    ::quartus::dse::ccl::dputs "${debug_name}: Calling: $flow_function"
    if {$optshash(debug)} {
        eval $flow_function
    } else {
        if {[catch {eval $flow_function} flow_result]} {
            # Clean up the flow_result
            regsub -nocase -all -- {error:\s*} $flow_result {} flow_err_msg
            regsub -nocase -all -- {\n\s*$} $flow_err_msg {} flow_err_msg
            ::quartus::dse::ccl::eputs "Flow exited with an error:\n$flow_err_msg"
        }
        ::quartus::dse::ccl::dputs "${debug_name}: Flow result: $flow_result"
    }

    # Note the elapsed time
    set ttext [::quartus::dse::ccl::elapsed_time_string [expr {[clock clicks -milliseconds] - $exploration_start_time}]]

    # Display a pop-up to let user know exploration is done
    set wcnt [::quartus::dse::ccl::get_msg_count -warnings]
    set ecnt [::quartus::dse::ccl::get_msg_count -errors]
    set msg "Exploration has finished. $ecnt "
    if {$ecnt == 1} {
        append msg "error, $wcnt"
    } else {
        append msg "errors, $wcnt"

    }
    if {$wcnt == 1} {
        append msg " warning"
    } else {
        append msg " warnings"
    }
    ::quartus::dse::ccl::iputs $msg
    ::quartus::dse::ccl::iputs "Exploration ended: [clock format [clock scan now]]"
    ::quartus::dse::ccl::iputs "Elapsed time: $ttext"

    # All done
    exit 0

}
