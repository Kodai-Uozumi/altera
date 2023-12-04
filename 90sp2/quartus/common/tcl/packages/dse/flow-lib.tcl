
#############################################################################
##  flow-lib.tcl
##
##  Design Space Explorer flows. Various ways of walking through and
##  evaluating a space.
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

package provide ::quartus::dse::flows 1.0


#############################################################################
##  Additional Packages Required
package require report
package require struct::matrix
package require math
package require md5
package require cmdline
package require ::quartus::dse::ccl
package require ::quartus::dse::gui
package require ::quartus::misc
package require ::quartus::project
package require ::quartus::qMaster


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse::flows {

    namespace export init
    namespace export stop_flow

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!

    # Tracks if a distributed DSE flow is running or not
    variable ddse_is_running 0
    variable ddse_using_lsf 0
}


#############################################################################
##  Procedure:  init
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##  Description:
##      Does basic initialization for everything in this library.
##      Should be called by DSE as early as possible. Returns
##      true (1) if init is successful; otherwise false (0).
proc ::quartus::dse::flows::init {args} {

    set debug_name "::quartus::dse::flows::init()"

    # Import global namespace variables
    global global_dse_options

    set retval 0

    # Set up environment based on some option flags
    if {$global_dse_options(dse-gui)} {
        ::quartus::dse::ccl::dputs "${debug_name}: Enabling GUI-mode code"
    }

    # Reset the qMasterObj for distributed compiles
    catch {qMasterObj clearJobsID}
    catch {qMasterObj clearSlavesID}

    # Configure report formats
    catch {::report::rmstyle simpletable}
    ::report::defstyle simpletable {} {
        data set [split "[string repeat "| "   [columns]]|"]
        top set [split "[string repeat "+ - " [columns]]+"]
        bottom set [top get]
        top enable
        bottom enable
    }

    catch {::report::rmstyle captionedtable}
    ::report::defstyle captionedtable {{n 1}} {
        simpletable
        topdata   set [split "[string repeat "| "   [columns]]|"]
        topcapsep set [top get]
        topcapsep enable
        tcaption $n
    }

    catch {::report::rmstyle boxedtable}
    ::report::defstyle boxedtable {} {
        simpletable
        datasep   set [top get]
        datasep enable
    }

    #
    # START: Initialize the flow section of the global options hash
    #
    # Unset all the existing flow options
    array unset global_dse_options "flow-*"
    # Now set all the defaults
    set global_dse_options(flow-space) "#_required_#"
    set global_dse_options(flow-results) "#_required_#"
    set global_dse_options(flow-stop-after-time) "#_ignore_#"
    set global_dse_options(flow-stop-after-zero-failing-paths) 0
    set global_dse_options(flow-archive) 0
    set global_dse_options(flow-best-worst-function) "::quartus::dse::flows::simple_slack_best_worst_analysis"
    set global_dse_options(flow-ignore-failed-base) 0
    set global_dse_options(flow-run-power) 0
    set global_dse_options(flow-slack-column) "#_default_#"
    set global_dse_options(flow-hardcopy) 0
    set global_dse_options(flow-concurrent-compiles) 1
    set global_dse_options(flow-slaves) [list]
    set global_dse_options(flow-lsfmode) 0
    set global_dse_options(flow-lsf-queue) "#_default_#"
    set global_dse_options(flow-lower-priority) 0
    set global_dse_options(flow-skip-base) 0
    set global_dse_options(flow-do-combined-analysis) 0
    set global_dse_options(flow-timequest) 0
    set global_dse_options(flow-report-all-resource-usage) 0
    #
    # END: Initialize the flow section of the global options hash
    #

    return $retval
}


#############################################################################
##  Procedure:  stop_flow
##
##  Arguments:
##      <none>
##
##  Description:
##      Sets the stop_flow variable to true. Flows query this variable
##      periodically to decide if they should stop running. If this
##      variable is true then the flow stops at the next convient stop.
##      Otherwise the flow flows flowingly on.
proc ::quartus::dse::flows::stop_flow {} {

    set debug_name "::quartus::dse::flows::stop_flow()"

    # Import global namespace variables
    variable ddse_is_running
    variable ddse_using_lsf
    global stop_flow

    ::quartus::dse::ccl::stop_tool

    set stop_flow 1

    ::quartus::dse::ccl::dputs "${debug_name}: Touching stop variable"
    ::quartus::dse::ccl::iputs "Halting exploration"

    if {$ddse_is_running} {
        if {$ddse_using_lsf} {
            ::quartus::dse::ccl::wputs "You are running a distributed DSE flow using LSF\nYour flow will not stop until all jobs have completed"
        }
        catch {qMasterObj stopJobs}
    }

    return $stop_flow
}


#############################################################################
##  Procedure:  put_report
##
##  Arguments:
##      rpt
##          The report to put
##
##      mtx
##          The matrix of data
##
##      title
##          Title of the report (optional)
##
##  Description:
##      Puts stuff to a file as well as the screen at the same time. If the
##      file exists already it'll be appended to, otherwise it'll get
##      created. The file written to is defined by the global $log_file
##      variable in the ::quartus::dse namespace.
proc ::quartus::dse::flows::put_report {rpt mtx {title "<none>"}} {

    # First form the title if we were given one
    if {$title != "<none>"} {
        set printtitle 1
        set rt "+-----------------------------------------------------------------------------+\n| "
        set tl [string length $title]
        if {$tl > 75} {
            # Truncate titles longer than 75 characters
            set title [string range $title 0 74]
            set tl 75
        }
        append rt $title
        for {set i $tl} {$i < 75} {incr i} {
            append rt " "
        }
        append rt " |\n+-----------------------------------------------------------------------------+\n"
    }
	append rt [$mtx format 2string $rpt]
    ::quartus::dse::ccl::bputs $rt
    catch {unset rt}

    return 1
}


#############################################################################
##  Procedure:  print_settings_table
##
##  Arguments:
##      title
##          -title <string>
##              Required. Title to put on the table.
##
##          -results <array_name>
##              Required. This is a pass-by-reference reference to
##              an array where all your result objects are
##              stored. There must be a "base" result object
##              in the array as well as any number of integer result
##              objects.
##
##          -relative-to-base
##              Optional. Instructs the function to print a
##              three-column table that lists all the base
##              settings and the new settings next to each other.
##              The function assumes that the base settings
##              are a super-set of the new settings.
##
##  Description:
##      Prints settings in a table with the appropriate title.
proc ::quartus::dse::flows::print_settings_table {args} {

    set debug_name "::quartus::dse::flows::print_settings_table()"

    ::quartus::dse::ccl::dputs "${debug_name}: Got args: $args"

    # Command line options to this function we require
    set         tlist       "title.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The title string for the table"
    lappend function_opts $tlist

    set         tlist       "results.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The array your results are in"
    lappend function_opts $tlist

    set         tlist       "relative-to-base"
    lappend     tlist       0
    lappend     tlist       "If true prints changes from base"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Bring their results into our namespace
    upvar 1 $optshash(results) results

    if {!$optshash(relative-to-base)} {
        # Create our matrix structure
        ::struct::matrix mtx
        mtx add columns 2
        mtx add row [list "Setting" "Value"]
        foreach {key val} [join $args] {
            mtx add row [list $key $val]
        }
        # Create our report structure
        ::report::report rpt 2 style captionedtable 1
        rpt pad 0 both
        rpt pad 1 both
    } else {
        array set newsettings [join $args]
        if {[info exists results(base)]} {
            array set basesettings [$results(base) getAllSettings]
        } elseif {[info exists results(base-1)]} {
            array set basesettings [$results(base-1) getAllSettings]
        } elseif {[info exists results(base-2)]} {
            array set basesettings [$results(base-2) getAllSettings]
        }

        # Create our matrix structure
        ::struct::matrix mtx
        mtx add columns 3
        mtx add row [list "Setting" "New Value" "Base Value"]
        foreach {key} [array names basesettings] {
            if {[info exists newsettings($key)]} {
                mtx add row [list $key $newsettings($key) $basesettings($key)]
            } else {
                mtx add row [list $key $basesettings($key) $basesettings($key)]
            }
        }
        foreach {key} [array names newsettings] {
            if {![info exists basesettings($key)]} {
                mtx add row [list $key $newsettings($key) ""]
            }
        }
        # Create our report structure
        ::report::report rpt 3 style captionedtable 1
        rpt pad 0 both
        rpt pad 1 both
        rpt pad 2 both
    }

    # Print it
    ::quartus::dse::ccl::bputs ""
    put_report rpt mtx $optshash(title)

    # Destroy it
    rpt destroy
    mtx destroy

    return 1
}


#############################################################################
##  Procedure:  print_compile_results_table
##
##  Arguments:
##      title
##          Title to put on the table
##
##      args
##          key/value result pairs.
##
##  Description:
##      Prints results in a table with the appropriate title.
proc ::quartus::dse::flows::print_compile_results_table {title args} {

    # Flatten args
    #set args [join $args]

    # Create an array out of args
    array set argary [join $args]

    # Create an ascii sorted list of keys in the array
    set keys [lsort -dictionary [array names argary]]

    # Create our matrix structure
    ::struct::matrix mtx
    mtx add columns 2
    foreach key $keys {
        mtx add row [list $key $argary($key)]
    }
    # Create our report structure
    ::report::report rpt 2 style simpletable
    rpt pad 0 both
    rpt pad 1 both

    # Print it
    ::quartus::dse::ccl::bputs ""
    put_report rpt mtx $title

    # Destroy it
    rpt destroy
    mtx destroy

    return 1
}


#############################################################################
##  Procedure:  print_all_results_table
##
##  Arguments:
##      title
##          -title <string>
##              Required. Title to put on the table.
##
##          -results <array_name>
##              Required. This is a pass-by-reference reference to
##              an array where all your result objects are
##              stored. There must be a "base" result object
##              in the array as well as any number of integer result
##              objects.
##
##          -exclude-failures
##              Tells the function to exclude points that
##              don't have a result object or have no results
##              stored in their result object. Otherwise "unknown"
##              is printed in the table. The default behaviour
##              is to print everything found in the array.
##
##          -mark-best
##              Tells the function to mark the best result (if any)
##              in the array. The default behaviour is not to mark
##              the best result.
##
##          -ignore-no-base
##              Option for use with parallel flows where we may get
##              data returned from other points before we get the
##              data for the base point. This just keeps the function
##              from printing anything in this case and/or throwing
##              an error.
##
##  Description:
##      Prints all the results in the result array to a table. The column
##      headers will always be "Compile" followed by a alphabetical list
##      of result names found at the "base" compile position. The rows
##      will first be the base result followed by each additional result
##      in the array sorted numerically (because their keys should be
##      numbers -- except for base).
proc ::quartus::dse::flows::print_all_results_table {args} {

    set debug_name "::quartus::dse::flows::print_all_results_table()"

    ::quartus::dse::ccl::dputs "${debug_name}: Got args: $args"

    #set args [join $args]

    # Command line options to this function we require
    set tlist [list "title.arg" "#_required_#" "The title string for the table"]
    lappend function_opts $tlist

    set tlist [list "results.arg" "#_required_#" "The array your results are in"]
    lappend function_opts $tlist

    set tlist [list "exclude-failures" "0" "Exclude result keys that don't have a valid object"]
    lappend function_opts $tlist

    set tlist [list "mark-best" "0" "Mark the best result found"]
    lappend function_opts $tlist

    set tlist [list "generate-csv" 1 "Print a CSV representation of the table as well"]
    lappend function_opts $tlist

    set tlist [list "csv-channel.arg" "stdout" "Channel to print CSV representation on"]
    lappend function_opts $tlist

    set tlist [list "ignore-no-base" 0 "Ignore the fact that there is no base compile present"]
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Bring their results into our namespace
    upvar 1 $optshash(results) results

    # Get the keys for all the results available
    set rowkeylist [lsort -dictionary -increasing [array names results]]
    # But remove the "base" key and add it again at the head of the list
    set newrowkeylist [list]
    ::quartus::dse::ccl::dputs "${debug_name}: Removing instances that match /^base/ from $rowkeylist"
    for {set i 0} {$i < [llength $rowkeylist]} {incr i} {
        if {![regexp -- {^base} [lindex $rowkeylist $i]]} {
            lappend newrowkeylist [lindex $rowkeylist $i]
        }
    }
    set rowkeylist $newrowkeylist
    catch {unset newrowkeylist}
    ::quartus::dse::ccl::dputs "${debug_name}: New key list is $rowkeylist"

    #
    # We're assuming that there can be up to three "base" instances in the
    # results hash for now: base, base-1 and base-2. This might
    # change in the future so monitor it closely.
    #
    if {[info exists results(base-2)]} {
        set rowkeylist [linsert $rowkeylist 0 base-2]
    }
    if {[info exists results(base-1)]} {
        set rowkeylist [linsert $rowkeylist 0 base-1]
    }
    if {[info exists results(base)]} {
        set rowkeylist [linsert $rowkeylist 0 base]
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Printing results in this order: $rowkeylist"

    # Create a column keys list for the table. Start with the base
    # results but if they failed move on to other results and see
    # if keys can be found at another result point.
    set columnkeylist [list]
    foreach r $rowkeylist {
        if {$results($r) != "" && [$results($r) isa ::quartus::dse::result]} {
            array set tarray [$results($r) getAllResults]
            set columnkeylist [lsort -dictionary [array names tarray]]
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at results for $r for column names: [array names tarray]"
            if {[llength $columnkeylist] > 0} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found column names at results $r"
                break
            }
        }
    }

    # Create our matrix structure
    ::struct::matrix mtx
    mtx add columns [expr {1 + [llength $columnkeylist]}]

    # Add the header row
    set headers "Point"
    foreach h $columnkeylist {
        lappend headers $h
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Using these headers: $headers"
    mtx add row $headers
    catch {unset headers}

    foreach r $rowkeylist {
        set resultname [$results($r) getName]
        if {[regexp -nocase -- {^\s*$} $resultname]} {
            set resultname $r
        }
        if {$results($r) == "" || ![$results($r) isa ::quartus::dse::result]} {
            if {$optshash(exclude-failures)} {
                # Don't print this point
                ::quartus::dse::ccl::dputs "${debug_name}: Skipping empty result: $r"
                continue
            } else {
                # Print "unknown" for every value
                set rl $resultname
                foreach c $columnkeylist {
                    lappend rl "unknown"
                }
                mtx add row $rl
                catch {unset rl}
            }
        } else {
            array set ra [$results($r) getAllResults]
            if {$optshash(mark-best) && [$results($r) isBest]} {
                set rl [list "$resultname (Best)"]
            } else {
                set rl $resultname
            }
            foreach c $columnkeylist {
                if {[info exists ra($c)]} {
                    lappend rl $ra($c)
                } else {
                    lappend rl "unknown"
                }
            }
            mtx add row $rl
            catch {unset rl}
            catch {array unset ra}
        }
    }
    # Create our report structure
    ::report::report rpt [expr {1 + [llength $columnkeylist]}] style captionedtable 1
    for {set i 0} {$i < [expr {1 + [llength $columnkeylist]}]} {incr i} {
        rpt pad $i both
    }

    # Print it
    ::quartus::dse::ccl::bputs ""
    put_report rpt mtx $optshash(title)

    if {$optshash(generate-csv)} {
        puts $optshash(csv-channel) $optshash(title)
        for {set r 0} {$r < [mtx columns]} {incr r} {
			set mungeddata [list]
			foreach data [mtx get column $r] {
				if  {[regexp -- {,} $data]} {
					set data "\"$data\""
				}
				lappend mungeddata $data
			}
			puts $optshash(csv-channel) [join $mungeddata ","]
			#puts $optshash(csv-channel) [join [mtx get column $r] ","]
        }
    }

    # Destroy it
    rpt destroy
    mtx destroy

    return 1
}


#############################################################################
##  Procedure:  print_compile_groups_table
##
##  Arguments:
##      title
##          -title <string>
##              Required. Title to put on the table.
##
##          -results <array_name>
##              Required. This is a pass-by-reference reference to
##              an array where all your result objects are
##              stored. There must be a "base" result object
##              in the array as well as any number of integer result
##              objects.
##
##          -compilegroups <list>
##              Required. A list suitable for turning into an
##              array that holds all the compile group "names"
##              and the result names that belong to each
##              group.
##
##  Description:
proc ::quartus::dse::flows::print_compile_groups_table {args} {

    set debug_name "::quartus::dse::flows::print_compile_groups_table()"

    ::quartus::dse::ccl::dputs "${debug_name}: Got args: $args"

    #set args [join $args]

    # Command line options to this function we require
    set         tlist       "title.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The title string for the table"
    lappend function_opts $tlist

    set         tlist       "results.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The array your results are in"
    lappend function_opts $tlist

    set         tlist       "compilegroups.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The list of compile groups"
    lappend function_opts $tlist

    set         tlist       "best-worst-function.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The function to use to choose between base-fast and base-slow results"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Bring their results into our namespace
    upvar 1 $optshash(results) results

    if {[info exists results(base)]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Found base results $results(base)"
        set base "base"
    } else {
        ::quartus::dse::ccl::wputs "No base results available -- skipping signature table printing"
        return 0
    }

    # Create an array out of the compilegroups list
    array set cgroups $optshash(compilegroups)

    # Create our matrix structure
    ::struct::matrix mtx
    mtx add columns 3

    # Add the header row
    mtx add row [list "Group Name" "Group Members" "Group Settings"]

    foreach cg [lsort -integer [array names cgroups]] {
        set members $cgroups($cg)

        array set tary [$results([lindex $cgroups($cg) 0]) getAllSettings]
        array unset tary SEED

        # If there are no results then these compiles have the
        # same settings as the base compile
        set settings ""
        if {[llength [array names tary]] == 0} {
            array set tary [$results($base) getAllSettings]
            array unset tary SEED
            # We should let the user know these are the base settings
            append settings "<Base Settings>\n"
        }

        foreach s [lsort [array names tary]] {
            append settings "$s = $tary($s)\n"
        }
        catch {unset tary}

        # Turn the members list into the real names of each point
        set realmembers [list]
        foreach {m} $members {
            set _t [$results($m) getName]
            if {[regexp -nocase -- {^\s*$} $_t]} {
                lappend realmembers $m
            } else {
                lappend realmembers $_t
            }
        }

        set members [join [lsort $realmembers]]
        if {[string length $members] > 20} {
            set members [join [lsort $members] "\n"]
        }

        mtx add row [list "Compile Group $cg" $members $settings]
    }

    # Create our report structure
    ::report::report rpt 3 style boxedtable
    rpt pad 0 both
    rpt pad 1 both
    rpt pad 2 both

    # Print it
    ::quartus::dse::ccl::bputs ""
    put_report rpt mtx $optshash(title)

    # Destroy it
    rpt destroy
    mtx destroy

    return 1
}


#############################################################################
##  Procedure:  print_signature_table
##
##  Arguments:
##      title
##          -title <string>
##              Required. Title to put on the table.
##
##          -results <array_name>
##              Required. This is a pass-by-reference reference to
##              an array where all your result objects are
##              stored. There must be a "base" result object
##              in the array as well as any number of integer result
##              objects.
##
##          -compilegroups <list>
##              Required. A list suitable for turning into an
##              array that holds all the compile group "names"
##              and the result names that belong to each
##              group.
##
##  Description:
proc ::quartus::dse::flows::print_signature_table {args} {

    set debug_name "::quartus::dse::flows::print_signature_table()"

    ::quartus::dse::ccl::dputs "${debug_name}: Got args: $args"

    #set args [join $args]

    # Command line options to this function we require
    set         tlist       "title.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The title string for the table"
    lappend function_opts $tlist

    set         tlist       "results.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The array your results are in"
    lappend function_opts $tlist

    set         tlist       "compilegroups.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The list of compile groups"
    lappend function_opts $tlist

    set         tlist       "best-worst-function.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The function to use to choose between base-fast and base-slow results"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Bring their results into our namespace
    upvar 1 $optshash(results) results

    if {[info exists results(base)]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Found base results $results(base)"
        set base "base"
    } else {
        ::quartus::dse::ccl::wputs "No base results available -- skipping signature table printing"
        return 0
    }

    # Test: If there are no base results then this table cannot
    # be printed. Stop proc right here.
    array set tarray [$results($base) getAllResults]
    set tlist [lsort -dictionary [array names tarray]]
    if {[llength $tlist] == 0} {
        ::quartus::dse::ccl::wputs "No base results available -- skipping signature table printing"
        return 0
    }

    # Create an array out of the compilegroups list
    array set cgroups $optshash(compilegroups)

    # Create our matrix structure
    ::struct::matrix mtx
    mtx add columns 4

    # Find base worst-case slack
    set base_worst_case_slack "unknown"
    foreach {key val} [$results($base) getResults -glob "Worst-case Slack"] {
        regexp -- {([\-]?\d+[\.]?\d*)} $val => base_worst_case_slack
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found worst-case slack for base: $base_worst_case_slack"

    # Find lowest clock period in the base results
    set base_lowest_period 1000000
    foreach {key val} [$results($base) getResults -glob "Clock Period:*"] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)} $val => period]} {
            if {$period < $base_lowest_period} {
                set base_lowest_period $period
            }
        }
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found lowest period for base: $base_lowest_period"

    # Find base logic cell count -- and decide if we're using Total logic elements or Logic utilization or Total HCells
    set base_logic_cells "unknown"
    foreach {key val} [$results($base) getResults -regexp "^(Total logic elements|Logic utilization|Total HCells)$"] {
        set base_logic_cells $val
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Found logic cell count for base: $base_logic_cells"

    # Add the header row for rest of table
    mtx add row [list "" "Average Slack Gain" "Average Period Gain" "Average Logic Count"]

    # For each compile group we need to compute the average gains
    foreach cg [lsort [array names cgroups]] {
        ::quartus::dse::ccl::dputs "${debug_name}: Computing results for compile group $cg"
        catch {unset slacks periods lcells}
        set slacks [list]
        set periods [list]
        set lcells [list]
        foreach r $cgroups($cg) {
            # Get the worst-case slack
            if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} [lindex [$results($r) getResults -exact "Worst-case Slack"] 1] => val]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found worst-case slack for result $r: $val"
                lappend slacks [::quartus::dse::ccl::absgain $val $base_worst_case_slack]
            }

            # Get the lowest clock period
            set temphp 1000000
            foreach {key val} [$results($r) getResults -glob "Clock Period:*"] {
                if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => period] && $period < $temphp} {
                    set temphp $period
                    unset period
                }
            }
            if {$temphp != 1000000} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found lowest period for result $r: $temphp"
                lappend periods [::quartus::dse::ccl::pgain $temphp $base_lowest_period]
            }
            catch {unset temphp}

            # Get the lcell count
            if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} [lindex [$results($r) getResults -regexp "^(Total logic elements|Logic utilization|Total HCells)$"] 1] => val]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found logic cell count for result $r: $val"
                lappend lcells [::quartus::dse::ccl::pgain $val $base_logic_cells]
            }
        }

        # Formats for averages and stddev values
        set favg {%.3f}
        set fstdev {%.1f}

        # Compute means and stddevs
        if {[catch {eval math::mean [lindex $slacks 0] [lrange $slacks 1 end]} slack_mean]} {
            set slack_mean_str "unknown"
        } else {
            set slack_mean_str "[format $favg $slack_mean] ns"
        }

        if {$slack_mean_str == "unknown" || [catch {eval math::sigma [lindex $slacks 0] [lindex $slacks 1] [lrange $slacks 2 end]} slack_stddev]} {
            set slack_stddev_str ""
        } else {
            set slack_stddev_str "+/- [format $fstdev $slack_stddev] ns"
        }

        if {[catch {eval math::mean [lindex $periods 0] [lrange $periods 1 end]} period_mean]} {
            set period_mean_str "unknown"
        } else {
            set period_mean_str "[format $favg $period_mean]%"
        }

        if {$period_mean_str == "unknown" || [catch {eval math::sigma [lindex $periods 0] [lindex $periods 1] [lrange $periods 2 end]} period_stddev]} {
            set period_stddev_str ""
        } else {
            set period_stddev_str "+/- [format $fstdev $period_stddev]%"
        }

        if {[catch {eval math::mean [lindex $lcells 0] [lrange $lcells 1 end]} lcell_mean]} {
            set lcell_mean_str "unknown"
        } else {
            set lcell_mean_str "[format $favg $lcell_mean]%"
        }

        if {$lcell_mean_str == "unknown" || [catch {eval math::sigma [lindex $lcells 0] [lindex $lcells 1] [lrange $lcells 2 end]} lcell_stddev]} {
            set lcell_stddev_str ""
        } else {
            set lcell_stddev_str "+/- [format $fstdev $lcell_stddev]%"
        }

        mtx add row [list "Compile Group $cg ([llength $cgroups($cg)] seeds)" "$slack_mean_str $slack_stddev_str" "$period_mean_str $period_stddev_str" "$lcell_mean_str $lcell_stddev_str "]

    }

    # Create our report structure
    ::report::report rpt 4 style captionedtable 1
    rpt pad 0 both
    rpt pad 1 both
    rpt pad 2 both
    rpt pad 3 both

    # Print it
    ::quartus::dse::ccl::bputs ""
    put_report rpt mtx $optshash(title)

    # Destroy it
    rpt destroy
    mtx destroy

    return 1
}


#############################################################################
##  Procedure:  simple_slack_best_worst_analysis
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -best <resultobject>
##              Required. This is a result object that holds your
##              current best results.
##
##          -new <resultobject>
##              Required. This is a result object that holds your
##              new results that you want to compare against
##              your best results.
##
##  Description:
##      Compares the worst-case slacks of two results for best/worst
##      analysis. Returns true if -new is better than -best; returns
##      false if -new is worse than or equal to -best. There are
##      some special cases:
##          - If -best does not have a worst-case slack
##            result and -new does it returns true;
##          - If -new does not have a worst-case slack
##            result it returns false;
proc ::quartus::dse::flows::simple_slack_best_worst_analysis {args} {

    set debug_name "::quartus::dse::flows::simple_slack_best_worst_analysis()"

    set args [join $args]

    # Command line options to this function we require
    set         tlist       "best.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The current best result object"
    lappend function_opts $tlist

    set         tlist       "new.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The new result object"
    lappend function_opts $tlist

    set         tlist       "slack-column.arg"
    lappend     tlist       "#_default_#"
    lappend     tlist       "The name of the column to use for the slack value"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Make sure -new is a result object
    if {$optshash(new) == "" || ![$optshash(new) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -new object is not a result object: $optshash(new)"
        # -new can never be better than -best then!
        return 0
    }

    # Make sure -best is a result object
    if {$optshash(best) == "" || ![$optshash(best) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -best object is not a result object: $optshash(best)"
        # -new is always better than best then!
        return 1
    }

    # If the user wants the default slack column set it now
    if {$optshash(slack-column) == "#_default_#"} {
        set optshash(slack-column) "Worst-case Slack"
    } else {
        set optshash(slack-column) [join $optshash(slack-column)]
    }

    # Get the results we will compare
    ::quartus::dse::ccl::dputs "${debug_name}: Using name for slack column: $optshash(slack-column)"
    ::quartus::dse::ccl::dputs "${debug_name}: Got:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => [$optshash(new) getResults -glob $optshash(slack-column)]"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => [$optshash(best) getResults -glob $optshash(slack-column)]"

    # Since this might be a list of more than one pair of key/value terms we
    # need to narrow it down a little.
    set slack 1000000000
    set slack_column "unknown"
    foreach {key val} [$optshash(new) getResults -glob $optshash(slack-column)] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => newslack units]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for current results worst-case slack"
            if {$newslack < $slack} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new current results worst-case slack at $key ($newslack < $slack)"
                set slack $newslack
                set slack_column $key
            }
        }
    }
    if {$slack == 1000000000} {
        set crlist [list "unknown" "unknown"]
    } else {
        set crlist [list $slack_column $slack]
    }
    # And repeat for the best results
    set slack 1000000000
    set slack_column "unknown"
    foreach {key val} [$optshash(best) getResults -glob $optshash(slack-column)] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => newslack units]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for best results worst-case slack"
            if {$newslack < $slack} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new best results worst-case slack at $key ($newslack < $slack)"
                set slack $newslack
                set slack_column $key
            }
        }
    }
    if {$slack == 1000000000} {
        set brlist [list "unknown" "unknown"]
    } else {
        set brlist [list $slack_column $slack]
    }
    catch {unset slack slack_column}

    ::quartus::dse::ccl::dputs "${debug_name}: After pruning for the absolute worst case slack we now have:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => $crlist"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => $brlist"

    if {[llength $crlist] < 2 || [string match -nocase "unknown*" [lindex $crlist 1]]} {
        # If the new results are "unknown" in value then the best results
        # are still our best results
        ::quartus::dse::ccl::dputs "${debug_name}: New results have no value for $optshash(slack-column)"
        ::quartus::dse::ccl::dputs "${debug_name}: New results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 0
    } elseif {[llength $brlist] < 2 ||  [string match -nocase "unknown*" [lindex $brlist 1]]} {
        # If the best results are "unknown" in value and the new results
        # have a value then the new results are better
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have no value for $optshash(slack-column)"
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have value [lindex $brlist 1] but new results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 1
    } else {
        # Compare their result values to figure out which is best
        ::quartus::dse::ccl::dputs "${debug_name}: Evaluating expression: [lindex $crlist 1] > [lindex $brlist 1]"
        if {[expr {[lindex $crlist 1] > [lindex $brlist 1]}]} {
            set is_best 1
        } else {
            set is_best 0
        }
    }

    return $is_best
}

#############################################################################
##  Procedure:  qof_best_worst_analysis
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -best <resultobject>
##              Required. This is a result object that holds your
##              current best results.
##
##          -new <resultobject>
##              Required. This is a result object that holds your
##              new results that you want to compare against
##              your best results.
##
##  Description:
##      Compares the Quality of Fit metric of two results for best/worst
##      analysis. Returns true if -new is better than -best; returns
##      false if -new is worse than or equal to -best. There are
##      some special cases:
##          - If -best does not have a QoF metric
##            result and -new does it returns true;
##          - If -new does not have a QoF metric
##            result it returns false;
proc ::quartus::dse::flows::qof_best_worst_analysis {args} {

    set debug_name "::quartus::dse::flows::qof_best_worst_analysis()"

    set args [join $args]

    # Command line options to this function we require
    set         tlist       "best.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The current best result object"
    lappend function_opts $tlist

    set         tlist       "new.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The new result object"
    lappend function_opts $tlist

    set         tlist       "slack-column.arg"
    lappend     tlist       "#_ignored_#"
    lappend     tlist       "Not used in this best/worst function"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Make sure -new is a result object
    if {$optshash(new) == "" || ![$optshash(new) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -new object is not a result object: $optshash(new)"
        # -new can never be better than -best then!
        return 0
    }

    # Make sure -best is a result object
    if {$optshash(best) == "" || ![$optshash(best) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -best object is not a result object: $optshash(best)"
        # -new is always better than best then!
        return 1
    }

    set qof_column_pattern "Quality of Fit"

    # Get the results we will compare
    ::quartus::dse::ccl::dputs "${debug_name}: Using name for QoF column: $qof_column_pattern"
    ::quartus::dse::ccl::dputs "${debug_name}: Got:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => [$optshash(new) getResults -glob $qof_column_pattern]"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => [$optshash(best) getResults -glob $qof_column_pattern]"

    # Since this might be a list of more than one pair of key/value terms we
    # need to narrow it down a little.
    set qof 10000000000000
    set qof_column "unknown"
    foreach {key val} [$optshash(new) getResults -glob $qof_column_pattern] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)} $val => newqof]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for current results QoF"
            if {$newqof < $qof} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new current results worst-case QoF at $key ($newqof < $qof)"
                set qof $newqof
                set qof_column $key
            }
        }
    }
    if {$qof == 10000000000000} {
        set crlist [list "unknown" "unknown"]
    } else {
        set crlist [list $qof_column $qof]
    }
    # And repeat for the best results
    set qof 10000000000000
    set qof_column "unknown"
    foreach {key val} [$optshash(best) getResults -glob $qof_column_pattern] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)} $val => newqof]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for best results QoF"
            if {$newqof < $qof} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new best results worst-case QoF at $key ($newqof < $qof)"
                set qof $newqof
                set qof_column $key
            }
        }
    }
    if {$qof == 10000000000000} {
        set brlist [list "unknown" "unknown"]
    } else {
        set brlist [list $qof_column $qof]
    }
    catch {unset qof qof_column}

    ::quartus::dse::ccl::dputs "${debug_name}: After pruning for the absolute worst case QoF we now have:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => $crlist"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => $brlist"

    if {[llength $crlist] < 2 || [string match -nocase "unknown*" [lindex $crlist 1]]} {
        # If the new results are "unknown" in value then the best results
        # are still our best results
        ::quartus::dse::ccl::dputs "${debug_name}: New results have no value for $qof_column_pattern"
        ::quartus::dse::ccl::dputs "${debug_name}: New results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 0
    } elseif {[llength $brlist] < 2 ||  [string match -nocase "unknown*" [lindex $brlist 1]]} {
        # If the best results are "unknown" in value and the new results
        # have a value then the new results are better
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have no value for $qof_column_pattern"
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have value [lindex $brlist 1] but new results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 1
    } else {
        # We don't expect QoF to be a list of value. There should only
        # ever be one QoF returned for each best/worst object. And it's
        # just a number, no units, so we don't have to test for number
        # and strip units.
        set crqof [lindex $crlist 1]
        set brqof [lindex $brlist 1]
        ::quartus::dse::ccl::dputs "${debug_name}: Evaluating expression: $crqof > $brqof"
        if {[expr {$crqof > $brqof}]} {
            set is_best 1
        } else {
            set is_best 0
        }
    }

    return $is_best
}

#############################################################################
##  Procedure:  simple_geomean_period_best_worst_analysis
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -best <resultobject>
##              Required. This is a result object that holds your
##              current best results.
##
##          -new <resultobject>
##              Required. This is a result object that holds your
##              new results that you want to compare against
##              your best results.
##
##  Description:
##      Compares the geomean period of two results for best/worst
##      analysis. Returns true if -new is better than -best; returns
##      false if -new is worse than or equal to -best. There are
##      some special cases:
##          - If -best does not have a geomean period
##            result and -new does it returns true;
##          - If -new does not have a geomean period
##            result it returns false;
proc ::quartus::dse::flows::simple_geomean_period_best_worst_analysis {args} {

    set debug_name "::quartus::dse::flows::simple_geomean_period_best_worst_analysis()"

    set args [join $args]

    # Command line options to this function we require
    set         tlist       "best.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The current best result object"
    lappend function_opts $tlist

    set         tlist       "new.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The new result object"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Make sure -new is a result object
    if {$optshash(new) == "" || ![$optshash(new) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -new object is not a result object: $optshash(new)"
        # -new can never be better than -best then!
        return 0
    }

    # Make sure -best is a result object
    if {$optshash(best) == "" || ![$optshash(best) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -best object is not a result object: $optshash(best)"
        # -new is always better than best then!
        return 1
    }

    set period_column_pattern "Clock Period: Geometric Mean"

    # Get the results we will compare
    ::quartus::dse::ccl::dputs "${debug_name}: Using name for period column: $period_column_pattern"
    ::quartus::dse::ccl::dputs "${debug_name}: Got:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => [$optshash(new) getResults -glob $period_column_pattern]"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => [$optshash(best) getResults -glob $period_column_pattern]"

    # Since this might be a list of more than one pair of key/value terms we
    # need to narrow it down a little.
    set period 0
    set period_column "unknown"
    foreach {key val} [$optshash(new) getResults -glob $period_column_pattern] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)} $val => newperiod]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for current results period"
            if {$newperiod > $period} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new current results worst-case average period at $key ($newperiod > $period)"
                set period $newperiod
                set period_column $key
            }
        }
    }
    if {$period == 0} {
        set crlist [list "unknown" "unknown"]
    } else {
        set crlist [list $period_column $period]
    }
    # And repeat for the best results
    set period 0
    set period_column "unknown"
    foreach {key val} [$optshash(best) getResults -glob $period_column_pattern] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)} $val => newperiod]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for best results period"
            if {$newperiod > $period} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new best results worst-case average period at $key ($newperiod > $period)"
                set period $newperiod
                set period_column $key
            }
        }
    }
    if {$period == 0} {
        set brlist [list "unknown" "unknown"]
    } else {
        set brlist [list $period_column $period]
    }
    catch {unset period period_column}

    ::quartus::dse::ccl::dputs "${debug_name}: After pruning for the absolute worst case average periods we now have:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => $crlist"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => $brlist"

    if {[llength $crlist] < 2 || [string match -nocase "unknown*" [lindex $crlist 1]]} {
        # If the new results are "unknown" in value then the best results
        # are still our best results
        ::quartus::dse::ccl::dputs "${debug_name}: New results have no value for $period_column_pattern"
        ::quartus::dse::ccl::dputs "${debug_name}: New results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 0
    } elseif {[llength $brlist] < 2 ||  [string match -nocase "unknown*" [lindex $brlist 1]]} {
        # If the best results are "unknown" in value and the new results
        # have a value then the new results are better
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have no value for $period_column_pattern"
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have value [lindex $brlist 1] but new results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 1
    } else {
        set crperiod [lindex $crlist 1]
        set brperiod [lindex $brlist 1]
        ::quartus::dse::ccl::dputs "${debug_name}: Evaluating expression: $crperiod < $brperiod"
        if {[expr {$crperiod < $brperiod}]} {
            set is_best 1
        } else {
            set is_best 0
        }
    }

    return $is_best
}


#############################################################################
##  Procedure:  simple_area_best_worst_analysis
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -best <resultobject>
##              Required. This is a result object that holds your
##              current best results.
##
##          -new <resultobject>
##              Required. This is a result object that holds your
##              new results that you want to compare against
##              your best results.
##
##  Description:
##      Compares the lcell count of two results for best/worst
##      analysis. Returns true if -new is better than -best; returns
##      false if -new is worse than or equal to -best. There are
##      some special cases:
##          - If -best does not have postive slack but -new
##            does than new is better than best automatically;
##          - If -new does not have postive slack but -best
##            does than best is better than new automatically;
##          - If both -best and -new have negative slack than
##            the one less area is the better result;
##          - If both -best and -new have positive slack than
##            the one with less area is the better result.
##      This gives you the compile that always has the lowest
##      area but with an emphasis that low area is useless if
##      the design isn't meeting timing.
proc ::quartus::dse::flows::simple_area_best_worst_analysis {args} {

    set debug_name "::quartus::dse::flows::simple_area_best_worst_analysis()"

    set args [join $args]

    # Command line options to this function we require
    set         tlist       "best.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The current best result object"
    lappend function_opts $tlist

    set         tlist       "new.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The new result object"
    lappend function_opts $tlist

    set         tlist       "slack-column.arg"
    lappend     tlist       "#_default_#"
    lappend     tlist       "The name of the column to use for the slack value"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Make sure -new is a result object
    if {$optshash(new) == "" || ![$optshash(new) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -new object is not a result object: $optshash(new)"
        # -new can never be better than -best then!
        return 0
    }

    # Make sure -best is a result object
    if {$optshash(best) == "" || ![$optshash(best) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -best object is not a result object: $optshash(best)"
        # -new is always better than best then!
        return 1
    }

    # If the user wants the default slack column set it now
    if {$optshash(slack-column) == "#_default_#"} {
        set optshash(slack-column) "Worst-case Slack"
    } else {
        set optshash(slack-column) [join $optshash(slack-column)]
    }

    # Get the results we will compare
    ::quartus::dse::ccl::dputs "${debug_name}: Using name for slack column: $optshash(slack-column)"
    ::quartus::dse::ccl::dputs "${debug_name}: Got:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => [$optshash(new) getResults -glob $optshash(slack-column)]"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => [$optshash(best) getResults -glob $optshash(slack-column)]"

    # Since this might be a list of more than one pair of key/value terms we
    # need to narrow it down a little.
    set slack 1000000000
    set slack_column "unknown"
    foreach {key val} [$optshash(new) getResults -glob $optshash(slack-column)] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => newslack units]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for current results worst-case slack"
            if {$newslack < $slack} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new current results worst-case slack at $key ($newslack < $slack)"
                set slack $newslack
                set slack_column $key
            }
        }
    }
    if {$slack == 1000000000} {
        set crlist [list "unknown" "unknown"]
    } else {
        set crlist [list $slack_column $slack]
    }
    # And repeat for the best results
    set slack 1000000000
    set slack_column "unknown"
    foreach {key val} [$optshash(best) getResults -glob $optshash(slack-column)] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => newslack units]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for best results worst-case slack"
            if {$newslack < $slack} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new best results worst-case slack at $key ($newslack < $slack)"
                set slack $newslack
                set slack_column $key
            }
        }
    }
    if {$slack == 1000000000} {
        set brlist [list "unknown" "unknown"]
    } else {
        set brlist [list $slack_column $slack]
    }
    catch {unset slack slack_column}

    ::quartus::dse::ccl::dputs "${debug_name}: After pruning for the absolute worst case slack we now have:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => $crlist"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => $brlist"

    # If we couldn't find a slack for new than best is still best
    if {[lindex $crlist 1] == "unknown"} {
        return 0
    }

    # If we couldn't find a slack for the best than new is better
    if {[lindex $brlist 1] == "unknown"} {
        return 1
    }

    # If best has postive slack but new does not, best is better
    if {[lindex $brlist 1] >= 0 && [lindex $crlist 1] < 0} {
        return 0
    }

    # If new has positive slack and best does not, new is better
    if {[lindex $crlist 1] >= 0 && [lindex $brlist 1] < 0} {
        return 1
    }
    catch {unset brlist crlist}

    # Timing is either met in both best & new or timing is failing
    # in both best & new - let's look at logic cell count now.
    set crlist [$optshash(new) getResults -regexp "^(Total logic elements|Logic utilization|Total HCells)$"]
    set brlist [$optshash(best) getResults -regexp "^(Total logic elements|Logic utilization|Total HCells)$"]

    ::quartus::dse::ccl::dputs "${debug_name}: Got the following for (Total logic elements|Logic utilization|Total HCells) in design:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => $crlist"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => $brlist"

    if {[llength $crlist] < 2 || [string match -nocase "unknown*" [lindex $crlist 1]]} {
        # If the new results are "unknown" in value then the best results
        # are still our best results
        ::quartus::dse::ccl::dputs "${debug_name}: New results have no value for Total logic elements or Logic utilization or Total HCells"
        ::quartus::dse::ccl::dputs "${debug_name}: New results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 0
    } elseif {[llength $brlist] < 2 ||  [string match -nocase "unknown*" [lindex $brlist 1]]} {
        # If the best results are "unknown" in value and the new results
        # have a value then the new results are better
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have no value for Total logic elements or Logic utilization or Total HCells"
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have value [lindex $brlist 1] but new results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 1
    } else {
        # Compare their result values to figure out which is best
        ::quartus::dse::ccl::dputs "${debug_name}: Evaluating expression: [lindex $crlist 1] < [lindex $brlist 1]"
        if {[expr {[lindex $crlist 1] < [lindex $brlist 1]}]} {
            set is_best 1
        } elseif {[expr {[lindex $crlist 1] == [lindex $brlist 1]}]} {
            set is_best [::quartus::dse::flows::simple_slack_best_worst_analysis -best $optshash(best) -new $optshash(new)]
        } else {
            set is_best 0
        }
    }

    return $is_best
}


#############################################################################
##  Procedure:  simple_power_best_worst_analysis
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -best <resultobject>
##              Required. This is a result object that holds your
##              current best results.
##
##          -new <resultobject>
##              Required. This is a result object that holds your
##              new results that you want to compare against
##              your best results.
##
##  Description:
##      Compares the static power consumption of two results for
##      best/worst analysis. Returns true if -new is better than
##      -best; returns false if -new is worse than or equal to
##      -best. There are some special cases:
##          - If -best does not have postive slack but -new
##            does than new is better than best automatically;
##          - If -new does not have postive slack but -best
##            does than best is better than new automatically;
##          - If both -best and -new have negative slack than
##            the one that uses less power is the better result;
##          - If both -best and -new have positive slack than
##            the one that uses less power is the better result.
##      This gives you the compile that always has the lowest
##      power but with an emphasis that low power is useless if
##      the design isn't meeting timing.
##
##      This function also issues a warning message if the
##      confidence level of the power analysis is low for
##      either the best or the new results.
proc ::quartus::dse::flows::simple_power_best_worst_analysis {args} {

    set debug_name "::quartus::dse::flows::simple_power_best_worst_analysis()"

    set args [join $args]

    # Command line options to this function we require
    set         tlist       "best.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The current best result object"
    lappend function_opts $tlist

    set         tlist       "new.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The new result object"
    lappend function_opts $tlist

    set         tlist       "slack-column.arg"
    lappend     tlist       "#_default_#"
    lappend     tlist       "The name of the column to use for the slack value"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Make sure -new is a result object
    if {$optshash(new) == "" || ![$optshash(new) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -new object is not a result object: $optshash(new)"
        # -new can never be better than -best then!
        return 0
    }

    # Make sure -best is a result object
    if {$optshash(best) == "" || ![$optshash(best) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -best object is not a result object: $optshash(best)"
        # -new is always better than best then!
        return 1
    }

    # If the user wants the default slack column set it now
    if {$optshash(slack-column) == "#_default_#"} {
        set optshash(slack-column) "Worst-case Slack"
    } else {
        set optshash(slack-column) [join $optshash(slack-column)]
    }

    # Get the results we will compare
    ::quartus::dse::ccl::dputs "${debug_name}: Using name for slack column: $optshash(slack-column)"
    ::quartus::dse::ccl::dputs "${debug_name}: Got:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => [$optshash(new) getResults -glob $optshash(slack-column)]"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => [$optshash(best) getResults -glob $optshash(slack-column)]"

    # Since this might be a list of more than one pair of key/value terms we
    # need to narrow it down a little.
    set slack 1000000000
    set slack_column "unknown"
    foreach {key val} [$optshash(new) getResults -glob $optshash(slack-column)] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => newslack units]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for current results worst-case slack"
            if {$newslack < $slack} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new current results worst-case slack at $key ($newslack < $slack)"
                set slack $newslack
                set slack_column $key
            }
        }
    }
    if {$slack == 1000000000} {
        set crlist [list "unknown" "unknown"]
    } else {
        set crlist [list $slack_column $slack]
    }
    # And repeat for the best results
    set slack 1000000000
    set slack_column "unknown"
    foreach {key val} [$optshash(best) getResults -glob $optshash(slack-column)] {
        if {[regexp -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => newslack units]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Looking at key = $key, val = $val for best results worst-case slack"
            if {$newslack < $slack} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found new best results worst-case slack at $key ($newslack < $slack)"
                set slack $newslack
                set slack_column $key
            }
        }
    }
    if {$slack == 1000000000} {
        set brlist [list "unknown" "unknown"]
    } else {
        set brlist [list $slack_column $slack]
    }
    catch {unset slack slack_column}

    ::quartus::dse::ccl::dputs "${debug_name}: After pruning for the absolute worst case slack we now have:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => $crlist"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => $brlist"

	# Skip the section of this comparison that requires positive slack on
	# both points before we compare power if the ini variable is set.
	if {![string equal -nocase [get_ini_var -name "dse_ignore_slack_during_search_for_power"] "on"]} {
		# If we couldn't find a slack for new than best is still best
		if {[lindex $crlist 1] == "unknown"} {
			::quartus::dse::ccl::wputs "Current point has no worst-case slack information\nDSE power analysis requires points to have positive slack before power performance is compared"
			return 0
		}

		# If we couldn't find a slack for the best than new is better
		if {[lindex $brlist 1] == "unknown"} {
			::quartus::dse::ccl::wputs "Best point has no worst-case slack information\nDSE power analysis requires points to have positive slack before power performance is compared"
			return 1
		}

		# If best has postive slack but new does not, best is better
		if {[lindex $brlist 1] >= 0 && [lindex $crlist 1] < 0} {
			::quartus::dse::ccl::wputs "Current point has negative worst-case slack information\nDSE power analysis requires points to have positive slack before power performance is compared\nComparing slacks to determine the best point"
			return 0
		}

		# If new has positive slack and best does not, new is better
		if {[lindex $crlist 1] >= 0 && [lindex $brlist 1] < 0} {
			::quartus::dse::ccl::wputs "Best point has negative worst-case slack information\nDSE power analysis requires points to have positive slack before power performance is compared\nComparing slacks to determine the best point"
			return 1
		}
	} else {
		::quartus::dse::ccl::dputs "${debug_name}: Found dse_ignore_slack_during_search_for_power = on -- skipping slack tests, comparing power results"
	}
	catch {unset brlist crlist}

    # Check the confidence level of the best and new power analysis
    # results. Warn if either of them are low.
    set crclevel [lindex [$optshash(new) getResults -exact "Power Estimation Confidence"] 1]
    set brclevel [lindex [$optshash(best) getResults -exact "Power Estimation Confidence"] 1]
    if { [regexp -nocase -- {^\s*low:\s+(.*)} $crclevel => msg] || [regexp -nocase -- {^\s*low:\s+(.*)} $brclevel => msg] } {
        ::quartus::dse::ccl::wputs "Your power estimation confidence level is low: $msg"
    }

    # Timing is either met in both best & new or timing is failing
    # in both best & new - let's look at power consumption.
    set crlist [$optshash(new) getResults -exact "Total Thermal Power Dissipation"]
    set brlist [$optshash(best) getResults -exact "Total Thermal Power Dissipation"]

    ::quartus::dse::ccl::dputs "${debug_name}: Got the following for Total Thermal Power Dissipation:"
    ::quartus::dse::ccl::dputs "${debug_name}: \tCurrent => $crlist"
    ::quartus::dse::ccl::dputs "${debug_name}: \tBest    => $brlist"

    if {[llength $crlist] < 2 || [string match -nocase "unknown*" [lindex $crlist 1]]} {
        # If the new results are "unknown" in value then the best results
        # are still our best results
        ::quartus::dse::ccl::dputs "${debug_name}: New results have no value for Total Thermal Power Dissipation"
        ::quartus::dse::ccl::dputs "${debug_name}: New results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 0
    } elseif {[llength $brlist] < 2 ||  [string match -nocase "unknown*" [lindex $brlist 1]]} {
        # If the best results are "unknown" in value and the new results
        # have a value then the new results are better
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have no value for Total Thermal Power Dissipation"
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have value [lindex $brlist 1] but new results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        set is_best 1
    } else {
        # Compare their result values to figure out which is best
        regexp -- {([\-]?\d+[\.]?\d*)} [lindex $crlist 1] => crpower
        regexp -- {([\-]?\d+[\.]?\d*)} [lindex $brlist 1] => brpower
        ::quartus::dse::ccl::dputs "${debug_name}: Evaluating expression: $crpower < $brpower"
        if {[expr {$crpower < $brpower}]} {
            set is_best 1
        } elseif {[expr {$crpower == $brpower}]} {
            # Fall back on pure slack best/worst analysis
            set is_best [::quartus::dse::flows::simple_slack_best_worst_analysis -best $optshash(best) -new $optshash(new)]
        } else {
            set is_best 0
        }
    }

    return $is_best
}


#############################################################################
##  Procedure:  average_slack_for_failing_paths_best_worst_analysis
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -best <resultobject>
##              Required. This is a result object that holds your
##              current best results.
##
##          -new <resultobject>
##              Required. This is a result object that holds your
##              new results that you want to compare against
##              your best results.
##
##  Description:
##      Compares the average slack for all failing paths of two results
##      for best/worst analysis. Returns true if -new is better than
##      -best; returns false if -new is worse than or equal to -best.
##      There are some special cases:
##          - If -best does not have an average slack for all failing
##            paths result and -new does it returns true;
##          - If -new does not have an average slack for all failing
##            paths result it returns false;
proc ::quartus::dse::flows::average_slack_for_failing_paths_best_worst_analysis {args} {

    set debug_name "::quartus::dse::flows::average_slack_for_failing_paths_best_worst_analysis()"

    set args [join $args]

    # Command line options to this function we require
    set         tlist       "best.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The current best result object"
    lappend function_opts $tlist

    set         tlist       "new.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The new result object"
    lappend function_opts $tlist

    set         tlist       "slack-column.arg"
    lappend     tlist       "#_default_#"
    lappend     tlist       "THIS OPTION HAS NO EFFECT FOR THIS BEST/WORST FUNCTION"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Make sure -new is a result object
    if {$optshash(new) == "" || ![$optshash(new) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -new object is not a result object: $optshash(new)"
        # -new can never be better than -best then!
        return 0
    }

    # Make sure -best is a result object
    if {$optshash(best) == "" || ![$optshash(best) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: -best object is not a result object: $optshash(best)"
        # -new is always better than best then!
        return 1
    }

    # Get the results we will compare
    set crlist [$optshash(new) getResults "Average Slack for Failing Paths"]
    set brlist [$optshash(best) getResults "Average Slack for Failing Paths"]

    if {[llength $crlist] < 2 || [string match -nocase "unknown*" [lindex $crlist 1]]} {
        # If the new results are "unknown" in value then the best results
        # are still our best results
        ::quartus::dse::ccl::dputs "${debug_name}: New results have no value for Average Slack for Failing Paths"
        ::quartus::dse::ccl::dputs "${debug_name}: New results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        return 0
    }

    set new_avg_slack [lindex $crlist 1]

    if {[llength $brlist] < 2 ||  [string match -nocase "unknown*" [lindex $brlist 1]]} {
        # If the best results are "unknown" in value and the new results
        # have a value then the new results are better
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have no value for Average Slack for Failing Paths"
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have value [lindex $brlist 1] but new results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        return 1
    }

    set best_avg_slack [lindex $brlist 1]

    # Get the results we will compare
    set crlist [$optshash(new) getResults "All Failing Paths"]
    set brlist [$optshash(best) getResults "All Failing Paths"]

    if {[llength $crlist] < 2 || [string match -nocase "unknown*" [lindex $crlist 1]] || [string match -nocase ">0" [lindex $crlist 1]]} {
        # If the new results are "unknown" in value then the best results
        # are still our best results
        ::quartus::dse::ccl::dputs "${debug_name}: New results have no value for All Failing Paths"
        ::quartus::dse::ccl::dputs "${debug_name}: New results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        return 0
    }

    set new_fpaths [lindex $crlist 1]

    if {[llength $brlist] < 2 || [string match -nocase "unknown*" [lindex $brlist 1]] || [string match -nocase ">0" [lindex $brlist 1]]} {
        # If the best results are "unknown" in value and the new results
        # have a value then the new results are better
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have no value for All Failing Paths"
        ::quartus::dse::ccl::dputs "${debug_name}: Best results have value [lindex $brlist 1] but new results have value [lindex $crlist 1] for result [lindex $crlist 0]"
        return 1
    }

    set best_fpaths [lindex $brlist 1]

    # If both the best and new results have no failing paths base the
    # best/worst decision on the worst-case slack.
    if {[expr {$best_fpaths * $best_avg_slack}] == [expr {$new_fpaths * $new_avg_slack}]} {
        ::quartus::dse::ccl::dputs "${debug_name}: [expr {$best_fpaths * $best_avg_slack}] == [expr {$new_fpaths * $new_avg_slack}]"
        ::quartus::dse::ccl::dputs "${debug_name}: Using best worst-case slack as metric for best/worst analysis instead"
        set is_best [simple_slack_best_worst_analysis -best $optshash(best) -new $optshash(new)]
    } else {
        # Otherwise choose the lower of the two muplications
        ::quartus::dse::ccl::dputs "${debug_name}: Evaluating expression: [expr {$new_fpaths * $new_avg_slack}] > [expr {$best_fpaths * $best_avg_slack}]"
        if {[expr {$new_fpaths * $new_avg_slack}] > [expr {$best_fpaths * $best_avg_slack}]} {
            set is_best 1
        } else {
            set is_best 0
        }
    }

    return $is_best
}


#############################################################################
##  Procedure:  get_settings_for_base
##
##  Arguments:
##      project
##          Name of the Quartus II project to open.
##
##      cmp
##          Name of the compiler settings to use.
##
##      args
##          A list of settings used by all the points in the space.
##          We will query the base compilation for its current
##          setting values for each of these settings found.
##
##  Description:
##      <description>
proc ::quartus::dse::flows::get_settings_for_base {project cmp args} {

    set debug_name "flow::get_settings_for_base()"

    array set settings [join $args]

    project_open -force -revision $cmp $project

    foreach setting [array names settings] {
        if {[regexp -nocase {^-} $setting]} {
            # Remove this setting
            array unset settings $setting
        } else {
            set val "unknown"
            ::quartus::dse::ccl::dputs "${debug_name}: Checking setting: $setting"
            if {[catch {get_global_assignment -name $setting} val]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Setting not found globally. Checking project-level $project..."
                if {[catch {get_instance_assignment -name $setting -to $project} val]} {
                    ::quartus::dse::ccl::dputs "${debug_name}: Setting not found a project level. Checking revision-level $cmp..."
                    if {[catch {get_instance_assignment -name $setting -to $cmp} val]} {
                        # Couldn't find it!
                        ::quartus::dse::ccl::dputs "${debug_name}: Couldn't find a setting called $setting"
                    }
                }
            }
            set settings($setting) $val
        }
    }

    project_close

    return [array get settings]
}

#############################################################################
##  Procedure:  get_family
##
##  Arguments:
##      project
##          Name of the Quartus II project to open.
##
##      cmp
##          Name of the compiler settings to use.
##
##  Description:
##      Gets the family in use for project/cmp.
proc ::quartus::dse::flows::get_family {project cmp} {
    set debug_name "::quartus::dse::flows::get_family()"
    global global_dse_options
    if {![info exists global_dse_options(flow-family)]} {
        project_open -force -revision $cmp $project
        regsub -all -nocase -- {\s+} [string tolower [get_global_assignment -name FAMILY]] {} family
        project_close
        set global_dse_options(flow-family) $family
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Returning family $global_dse_options(flow-family) for project $project, revision $cmp"
    return $global_dse_options(flow-family)
}

#############################################################################
##  Procedure:  set_model_list
##
##  Arguments:
##      project
##          Name of the Quartus II project to open.
##
##      cmp
##          Name of the compiler settings to use.
##
##  Description:
##      Sets the list of voltage/temperature models that are in use for
##      this design. The first model in the list the default model to use
##      for comparisons.
proc ::quartus::dse::flows::set_model_list {project cmp} {

    global global_dse_options
    set debug_name "::quartus::dse::flows::set_model_list()"
    set staargs [list "--script" "\"[file join $::quartus(tclpath) packages dse sta-helper.tcl]\"" "-project" "\"$project\"" "-revision" "\"$cmp\"" "-command" "get_available_operating_conditions"]
    set input "\"[file join $::quartus(binpath) quartus_sta]\" [join $staargs]"
    set output "sta-helper.out"
    set model_list [list]

    set ret_val [::quartus::dse::ccl::dse_exec $input $output]
    if {![catch {open $output "r"} fh]} {
        # Scan the output for the line:
        #   Info: Operating conditions: <list>
        #
        while {[gets $fh line] >= 0} {
            if {[regexp -nocase -- {Info:\s+Operating conditions:\s+(.*)} $line => opstr]} {
                # Massage the values so they look sane
                foreach {model} [split $opstr] {
                    if {[regexp -nocase -- {(fast|slow)_(\d+)mv_(\-?\d+)c} $model => speed volts temp]} {
                        set speed [string tolower $speed]
                        lappend model_list "${speed}-${volts}mV-${temp}C"
                    } elseif {[regexp -nocase -- {(fast|slow)} $model => speed]} {
                        lappend model_list [string tolower $speed]
                    } else {
                        lappend model_list $model
                    }
                }
                break
            }
        }
        close $fh
    }
    catch {file delete -force -- $output}

    ::quartus::dse::ccl::dputs "${debug_name}: Returning model list: $model_list"
    set global_dse_options(flow-model-list) $model_list
    return $model_list
}

#############################################################################
##  Procedure:  compile_base
##
##  Description:
##      Assume that what is currently on disk is the base case
##      and compiles it.
proc ::quartus::dse::flows::compile_base {args} {

    set debug_name "::quartus::dse::flows::compile_base()"

    # Import global namespace variables
    global stop_flow
    global global_dse_options

    # Check to make sure we got a valid designspace object
    set designspace [::quartus::dse::ccl::get_global_option "flow-space"]
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    # Bring their results into our namespace
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-results"] results

    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
        ::quartus::dse::gui::update_progress -update-progress-status "Exploring Base"
    }

    # Are we lowering the priority on our quartus_sh calls?
    if {[::quartus::dse::ccl::get_global_option "flow-lower-priority"]} {
        set lower_priority "--lower_priority"
    } else {
        set lower_priority ""
    }

    # Assume that what is currently on disk is the base case
    # so we need to map/fit/tan/tan this stuff
    set ignore_failed_base 0
    set retval 1

    # Zero out the model list in the flow options
    set global_dse_options(flow-model-list) [list]

    if {[::quartus::dse::ccl::get_global_option "flow-skip-base"] && [can_skip_compile [$designspace cget -strProjectName] [$designspace cget -strCmpName]]} {
        ::quartus::dse::ccl::iputs "Revision [$designspace cget -strCmpName] has been compiled successfully already\nSkipping compilation of revision [$designspace cget -strCmpName]"
    } else {
        if {!$stop_flow && !$ignore_failed_base} {
            ::quartus::dse::ccl::iputs "Compiling revision [$designspace cget -strCmpName]"
            if {![::quartus::dse::ccl::quartus_sh $lower_priority --flow compile [$designspace cget -strProjectName] -c [$designspace cget -strCmpName]]} {
                set flist [list]
                set repat "[$designspace cget -strCmpName]\\.(\[a-z\]+)(\\.rpt.*)"
                foreach {f} [lsort [glob -nocomplain -- {*}]] {
                    # Make sure we're not double-saving files
                    if {[regexp -nocase -- $repat $f => rtype ext]} {
                        # Skip the .dse.rpt file
                        if {![string equal -nocase $rtype "dse"]} {
                            set newf "[file join dse [$designspace cget -strCmpName].base.${rtype}${ext}]"
                            catch {file copy -force -- $f $newf}
                            # Keep a list of files we've saved so we can
                            # tell the user about this later with the error
                            # or warning message about base failing.
                            lappend flist $newf
                        }
                    }
                }

                if {[::quartus::dse::ccl::get_global_option "flow-ignore-failed-base"]} {
                    ::quartus::dse::ccl::wputs "Base compilation failed -- ignoring failed base compilation"
                    if {[llength $flist] > 0} {
                        ::quartus::dse::ccl::wputs "Output from failed base compilation has been saved as:"
                        foreach f $flist {
                            ::quartus::dse::ccl::wputs "   $f"
                        }
                    } else {
                        ::quartus::dse::ccl::wputs "No output from failed base compilation was found"
                    }
                    set ignore_failed_base 1
                    set retval 0
                } else {
                    ::quartus::dse::ccl::eputs "Base compilation failed -- halting exploration"
                    if {[llength $flist] > 0} {
                        ::quartus::dse::ccl::eputs "Output from failed base compilation has been saved as:"
                        foreach f $flist {
                            ::quartus::dse::ccl::eputs "   $f"
                        }
                    } else {
                        ::quartus::dse::ccl::eputs "No output from failed base compilation was found"
                    }
                    stop_flow
                    set retval 0
                }
            }
        }
    }

    if {!$stop_flow && !$ignore_failed_base && [::quartus::dse::ccl::get_global_option "flow-run-power"]} {
        ::quartus::dse::ccl::iputs "Running PowerPlay power analysis on revision [$designspace cget -strCmpName]"
        if {![::quartus::dse::ccl::quartus_pow $lower_priority [$designspace cget -strProjectName] -c [$designspace cget -strCmpName]]} {
            set flist [list]
            set repat "[$designspace cget -strCmpName]\\.(pow)(\\.rpt.*)"
            foreach {f} [lsort [glob -nocomplain -- {*}]] {
                # Make sure we're not double-saving files
                if {[regexp -nocase -- $repat $f => rtype ext]} {
                    # Skip the .dse.rpt file
                    if {![string equal -nocase $rtype "dse"]} {
                        set newf "[file join dse [$designspace cget -strCmpName].base.${rtype}${ext}]"
                        catch {file copy -force -- $f $newf}
                        # Keep a list of files we've saved so we can
                        # tell the user about this later with the error
                        # or warning message about base failing.
                        lappend flist $newf
                    }
                }
            }

            if {[::quartus::dse::ccl::get_global_option "flow-ignore-failed-base"]} {
                ::quartus::dse::ccl::wputs "PowerPlay power analysis failed -- ignoring failed power analysis"
                if {[llength $flist] > 0} {
                    ::quartus::dse::ccl::wputs "Output from failed PowerPlay power analysis has been saved as:"
                    foreach f $flist {
                        ::quartus::dse::ccl::wputs "   $f"
                    }
                } else {
                    ::quartus::dse::ccl::wputs "No output from failed PowerPlay power analysis was found"
                }
                set ignore_failed_base 1
                set retval 0
            } else {
                ::quartus::dse::ccl::eputs "PowerPlay power analysis failed -- halting exploration"
                if {[llength $flist] > 0} {
                    ::quartus::dse::ccl::eputs "Output from failed PowerPlay power analysis has been saved as:"
                    foreach f $flist {
                        ::quartus::dse::ccl::eputs "   $f"
                    }
                } else {
                    ::quartus::dse::ccl::eputs "No output from failed PowerPlay power analysis was found"
                }
                stop_flow
                set retval 0
            }
        }
    }

    if {!$stop_flow && !$ignore_failed_base} {
        # If this project is using TimeQuest prepare the result files
        if {[::quartus::dse::ccl::get_global_option flow-timequest]} {
            ::quartus::dse::result::extract_results_from_sta -project [$designspace cget -strProjectName] -revision [$designspace cget -strCmpName] -point "base"
        }
        if {[::quartus::dse::ccl::get_global_option "flow-do-combined-analysis"]} {
            if {[::quartus::dse::ccl::get_global_option "flow-timequest"]} {
                # We need to capture results for each model that's in use in
                # design. The number varies from device to device and family
                # to family.
                set_model_list [$designspace cget -strProjectName] [$designspace cget -strCmpName]
            } else {
                set global_dse_options(flow-model-list) [list slow fast]
            }
            if {[llength $global_dse_options(flow-model-list)] == 0} {
                # Admittedly this is kind of a wierd place to end up. But
                # we'll run with it an see where it takes us...there is just
                # one model in use at this point.
                ::quartus::dse::ccl::iputs "Recording base results"
                if {![$results(base) getResultsFromProject -report-all-resource-usage [::quartus::dse::ccl::get_global_option flow-report-all-resource-usage] -point "base"]} {
                    ::quartus::dse::ccl::eputs "Unable to parse base results -- halting exploration"
                    stop_flow
                    set retval 0
                } else {
                    $results(base) setCompiled 1
                }
                # Make sure dse/result exists
                catch {file mkdir [file join dse]}
                if {![catch {open [file join dse base-result.xml] {WRONLY CREAT TRUNC}} xmlfh]} {
                    ::quartus::dse::ccl::dputs "${debug_name}: Dumping results to: [file join dse base-result.xml]"
                    $results(base) dumpXML $xmlfh
                    close $xmlfh
					catch {file copy -force -- [file join dse base-result.xml] [file join dse best-result.xml]}
                }
            } else {
                # First make copies of the (empty) 'base' results
                for {set i 1} {$i < [llength $global_dse_options(flow-model-list)]} {incr i} {
                    set model [lindex $global_dse_options(flow-model-list) $i]
                    set results(base-$i) [$results(base) duplicate]
                    $results(base-$i) setName "base-$model"
                }
                # Now record the results
                for {set i 0} {$i < [llength $global_dse_options(flow-model-list)]} {incr i} {
                    if { $i == 0 } {
                        set key "base"
                    } else {
                        set key "base-$i"
                    }
                    set model [lindex $global_dse_options(flow-model-list) $i]
                    $results($key) setName "base-$model"
                    ::quartus::dse::ccl::iputs "Recording [$results($key) getName] results"
                    if {![$results($key) getResultsFromProject -report-all-resource-usage [::quartus::dse::ccl::get_global_option flow-report-all-resource-usage] -model $model -point "base"]} {
                        ::quartus::dse::ccl::eputs "Unable to parse [$results($key) getName] results -- halting exploration"
                        stop_flow
                        set retval 0
                        break
                    } else {
                        $results($key) setCompiled 1
                    }
                    # Make sure dse/result exists
                    catch {file mkdir [file join dse]}
                    set xmlfilename "${key}-result"
                    if {![catch {open [file join dse ${xmlfilename}.xml] {WRONLY CREAT TRUNC}} xmlfh]} {
                        ::quartus::dse::ccl::dputs "${debug_name}: Dumping results to: [file join dse ${xmlfilename}.xml]"
                        $results($key) dumpXML $xmlfh
                        close $xmlfh
                    }
                }
            }
        } else {
            # There is just one model in use at this point.
            ::quartus::dse::ccl::iputs "Recording base results"
            set global_dse_options(flow-model-list) [list]
            if {![$results(base) getResultsFromProject -report-all-resource-usage [::quartus::dse::ccl::get_global_option flow-report-all-resource-usage] -point "base"]} {
                ::quartus::dse::ccl::eputs "Unable to parse base results -- halting exploration"
                stop_flow
                set retval 0
            } else {
                $results(base) setCompiled 1
            }
            # Make sure dse/result exists
            catch {file mkdir [file join dse]}
            if {![catch {open [file join dse base-result.xml] {WRONLY CREAT TRUNC}} xmlfh]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Dumping results to: [file join dse base-result.xml]"
                $results(base) dumpXML $xmlfh
                close $xmlfh
				catch {file copy -force -- [file join dse base-result.xml] [file join dse best-result.xml]}
            }
        }
    }

    if {!$stop_flow && !$ignore_failed_base} {
        # The base results are currently our best results
        # so we should archive them as the best results
        ::quartus::dse::ccl::iputs "Archiving base results"
        if {![$results(base) archive "best.qar"]} {
            ::quartus::dse::ccl::eputs "Unable to archive base results -- halting exploration?"
            ::quartus::dse::ccl::eputs "Maybe you're out of disk space?"
            stop_flow
            set retval 0
        }
        # And if the user told us to archive ALL results
        # than we should make a copy of best.qar as base.qar
        # so they have an archive of their base results.
        if {[::quartus::dse::ccl::get_global_option "flow-archive"]} {
            catch {file copy -force -- [file join dse best.qar] [file join dse base.qar]}
        }
    }

    # Call the restore function here with the intention of
    # not restoring the revision but just cleaning up
    # an existing $optshash(temp-revision) revision so the explore_space
    # function doesn't fail.
    $results(base) restoreRevision -delete [::quartus::dse::ccl::get_global_option "flow-temp-revision"]
    return $retval
}


#############################################################################
##  Procedure:  analyze_base
##
##  Description:
##      Assume that what is currently on disk is the base case
##      and analyzes it. If analysis is successful it creates
##      a base.qar file for you to use as a basis for all your
##      other compilations.
proc ::quartus::dse::flows::analyze_base {args} {

    set debug_name "::quartus::dse::flows::analyze_base()"

    # Import global namespace variables
    global global_dse_options
    global stop_flow

    # Check to make sure we got a valid designspace object
    set designspace [::quartus::dse::ccl::get_global_option "flow-space"]
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    # Bring some stuff into our local namespace
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-results"] results
    ::quartus::dse::ccl::dputs "${debug_name}: results is an array = [array exists results]"
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-point-counter"] point_counter
    ::quartus::dse::ccl::dputs "${debug_name}: point_counter = $point_counter"
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-points-to-submit"] points_to_submit
    ::quartus::dse::ccl::dputs "${debug_name}: points_to_submit = $points_to_submit"

    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
        ::quartus::dse::gui::update_progress -update-progress-status "Analyzing Revision"
    }

    # Are we lowering the priority on our quartus_sh calls?
    if {[::quartus::dse::ccl::get_global_option "flow-lower-priority"]} {
        set lower_priority "--lower_priority"
    } else {
        set lower_priority ""
    }

    # Zero out the model list in the flow options
    set global_dse_options(flow-model-list) [list]

    # Run analysis and elaboration before creating the qar file otherwise
    # design files in sub-directories will be missed by the qar utility.
    # Only need to do this for non-hardcopy designs.
    if { ![::quartus::dse::ccl::get_global_option "flow-hardcopy"] } {
        if {[::quartus::dse::ccl::get_global_option "flow-skip-base"] && [can_skip_analysis [$results(base) cget -strProjectName] [$results(base) cget -strCmpName]]} {
            ::quartus::dse::ccl::iputs "Revision [$designspace cget -strCmpName] has been analyzed successfully already\nSkipping analysis of revision [$results(base) cget -strCmpName]"
        } else {
            ::quartus::dse::ccl::iputs "Analyzing revision [$results(base) cget -strCmpName]"
            if {![::quartus::dse::ccl::quartus_map $lower_priority --analyze_project [$results(base) cget -strProjectName] -c [$results(base) cget -strCmpName]]} {
                ::quartus::dse::ccl::eputs "Unable to analyze revision [$results(base) cget -strCmpName]: exploration will be stopped"
                stop_flow
            }
        }
    }

    # Create a qar file for the base compile
    if {!$stop_flow} {
        ::quartus::dse::ccl::iputs "Creating archive of base settings"
        if {![$results(base) archive "base.qar"]} {
            ::quartus::dse::ccl::eputs "Unable to archive base settings: exploration will be stopped"
            stop_flow
        }
    }

    # Mark base point to submit to cluster
    if {!$stop_flow} {
        lappend points_to_submit 0
    }

    # Reset the counter for our points to 1
    if {!$stop_flow} {
        set point_counter 1
    }

    return 1
}


#############################################################################
##  Procedure:  explore_space
##
##  Description:
##      Explores design space by itterating through every combination
##      of enabled MAP and FIT points.
proc ::quartus::dse::flows::explore_space {args} {

    set debug_name "::quartus::dse::flows::explore_space()"

    # Import global namespace variables
    global stop_flow
    global global_dse_options

    # Check to make sure we got a valid designspace object
    set designspace [::quartus::dse::ccl::get_global_option "flow-space"]
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    # Are we lowering the priority on our quartus_sh calls?
    if {[::quartus::dse::ccl::get_global_option "flow-lower-priority"]} {
        set lower_priority "--lower_priority"
    } else {
        set lower_priority ""
    }

    # Bring their results into our namespace
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-results"] results
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-best-result"] best_result
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-best-point"] best_point
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-point-counter"] point_counter

    # Get number of points in design space
    set number_of_points [::quartus::dse::ccl::get_global_option "flow-number-of-points"]

    # Reset the seed space itterator
    ::quartus::dse::ccl::dputs "${debug_name}: Resetting the seed space itterator"
    $designspace resetItterator seed

    # For every seed point and every map point and every fit
    # point compile and evaluate the results.
    if {!$stop_flow} {

        while {[$designspace morePoints seed]} {

            # Set the seed itterator
            set seeditterator [$designspace getItterator seed]

            # Reset the map space itterator
            ::quartus::dse::ccl::dputs "${debug_name}: Resetting the map space itterator"
            $designspace resetItterator map

            while {[$designspace morePoints map]} {

                # Set the map itterator
                set mapitterator [$designspace getItterator map]

                # Reset the fit space itterator
                ::quartus::dse::ccl::dputs "${debug_name}: Resetting the fit space itterator"
                $designspace resetItterator fit

                while {[$designspace morePoints fit]} {

                    # Set the fit itterator
                    set fititterator [$designspace getItterator fit]

                    # Reset the llr space itterator
                    ::quartus::dse::ccl::dputs "${debug_name}: Resetting the llr space itterator"
                    $designspace resetItterator llr

                    while {[$designspace morePoints llr]} {

                        # Set the llr itterator
                        set llritterator [$designspace getItterator llr]

                        # Check and see if this is a skip point
                        if {[::quartus::dse::ccl::get_global_option "flow-skip-points"] != ""} {
                            set str "${seeditterator},${mapitterator},${fititterator},${llritterator}"
                            set skip_this_point 0
                            foreach skippoint [::quartus::dse::ccl::get_global_option "flow-skip-points"] {
                                ::quartus::dse::ccl::dputs "${debug_name}: Comparing skip point $skippoint against current point $str"
                                if {[string equal $str $skippoint]} {
                                    ::quartus::dse::ccl::dputs "${debug_name}: Matched skip point against current point"
                                    set skip_this_point 1
                                    break
                                }
                            }
                            catch {unset str skippoint}
                            if {$skip_this_point} {
                                # Increment llr space itterator
                                ::quartus::dse::ccl::dputs "${debug_name}: Incrementing llr space itterator"
                                $designspace nextPoint llr
                                # And skip to next point
                                ::quartus::dse::ccl::dputs "${debug_name}: Skipping to next point"
                                continue
                            }
                        }

                        ::quartus::dse::ccl::iputs "Exploring point $point_counter of $number_of_points"
                        if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                            ::quartus::dse::gui::update_progress -update-progress-status "Exploring Point $point_counter of $number_of_points"
                        }

                        # Create a new result object(s) for this point
                        set robjind "${point_counter}"
                        ::quartus::dse::ccl::dputs "${debug_name}: Using result object index for this pass: $robjind"

                        set results($robjind) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
                        # Add the settings for this result to the result object
                        $results($robjind) addSettings [$designspace getParams llr $llritterator] [$designspace getParams seed $seeditterator] [$designspace getParams map $mapitterator] [$designspace getParams fit $fititterator]
                        $results($robjind) setFingerPrint [$results($robjind) generateFingerPrint -base $results(base)]

                        # Check the fingerprint of this point against all the other
                        # results to see if this point possible duplicates another point
                        ::quartus::dse::ccl::dputs "${debug_name}: Starting fingerprint check for point $point_counter"
                        set skip_this_point 0
                        set this_fingerprint [$results(${robjind}) getFingerPrint]
                        foreach r [lsort [array names results]] {
                            # Don't check point against itself...
                            if {$r == $robjind} {
                                continue
                            }
                            if {$results($r) != "" && [$results($r) isa ::quartus::dse::result]} {
                                set that_fingerprint [$results($r) getFingerPrint]
                                if {[string equal $this_fingerprint $that_fingerprint]} {
                                    ::quartus::dse::ccl::dputs "${debug_name}: Matching fingerprint found at point $r"
                                    set skip_this_point "Skipping point $point_counter because it duplicates the settings at point $r"
                                    break
                                }
                            }
                        }
                        ::quartus::dse::ccl::dputs "${debug_name}: Done fingerprint check for point $point_counter"
                        # Before we (possibly) skip this point duplicate the results
                        for {set i 0} {$i < [llength $global_dse_options(flow-model-list)]} {incr i} {
                            set model [lindex $global_dse_options(flow-model-list) $i]
                            if { $i == 0 } {
                                $results(${robjind}) setName "${robjind}-${model}"
                            } else {
                                set results(${robjind}-${i}) [$results($robjind) duplicate]
                                $results(${robjind}-${i}) setName "${robjind}-${model}"
                            }
                        }
                        if {$skip_this_point != 0} {
                            # Let the user know why we skipped this point
                            ::quartus::dse::ccl::wputs $skip_this_point

                            # Print cumulative results table, include a dump to a CSV
                            # file if we can open the file otherwise just screen dump
                            if {[catch {open [file join dse "results.csv"] {WRONLY CREAT TRUNC}} csvfh]} {
                                ::quartus::dse::ccl::dputs "${debug_name}: Unable to open dse/result/results.csv -- no CSV data dumped for this run"
                                print_all_results_table -title "Detailed Cumulative Results" -results results -exclude-failures -mark-best
                            } else {
                                ::quartus::dse::ccl::dputs "${debug_name}: CSV results will be dumped to dse/result/results.csv"
                                # Add a timestamp as the first line in the CSV file
                                puts $csvfh "Project: [$designspace cget -strProjectName]"
                                puts $csvfh "Revision: [$designspace cget -strCmpName]"
                                puts $csvfh "Flow Start Date: [regsub -all -- {,} $::quartus::dse::ccl::init_date_and_time " "]"
                                puts $csvfh "Flow End Date: [regsub -all -- {,} [clock format [clock scan now]] " "]"
                                puts $csvfh ""
                                print_all_results_table -title "Detailed Cumulative Results" -results results -exclude-failures -mark-best -generate-csv -csv-channel $csvfh
                                close $csvfh
                            }

                            # Update GUI
                            if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                                ::quartus::dse::gui::update_progress -update-pbar
                            }
                            # Increment point counter
                            incr point_counter
                            # Increment llr space itterator
                            ::quartus::dse::ccl::dputs "${debug_name}: Incrementing llr space itterator"
                            $designspace nextPoint llr
                            # And skip to next point
                            ::quartus::dse::ccl::dputs "${debug_name}: Skipping to next point"
                            continue
                        }

                        print_settings_table -title "Settings for Point $point_counter of $number_of_points" -results results -relative-to-base [$results(${robjind}) getAllSettings]

                        # Create the llr & seed & map & fit space
                        if {![::quartus::dse::ccl::get_global_option "flow-hardcopy"]} {
                            ::quartus::dse::ccl::iputs "Creating temporary revision [::quartus::dse::ccl::get_global_option flow-temp-revision] for point $robjind"
                            $results($robjind) makeRevision -make-default -name [::quartus::dse::ccl::get_global_option "flow-temp-revision"]

                        } else {
                            $results($robjind) makeHardCopyRevision
                        }
                        #
                        # SPR:295947
                        # Make sure the temp rev name is set in the duplicates.
                        for {set i 0} {$i < [llength $global_dse_options(flow-model-list)]} {incr i} {
                            set model [lindex $global_dse_options(flow-model-list) $i]
                            if { $i == 0 } {
                                $results(${robjind}) setName "${robjind}-${model}"
                            } else {
                                set results(${robjind}-${i}) [$results($robjind) duplicate]
                                $results(${robjind}-${i}) setName "${robjind}-${model}"
                            }
                        }
                        # END SPR:295947
                        #

                        # Should we stop the flow?
                        if {$stop_flow} {
                            break
                        }

                        # We should stop this specific point if we encounter
                        # any errors with a piece of the map/fit/tan/tan flow
                        set continue_point 1

                        # Run --flow compile on this design now
                        ::quartus::dse::ccl::iputs "Compiling point $point_counter of $number_of_points"
                        if {![::quartus::dse::ccl::quartus_sh $lower_priority --flow compile [$results($robjind) cget -strProjectName] -c [$results($robjind) cget -strCmpName]]} {
                            set flist [list]
                            set repat "[$results($robjind) cget -strCmpName]\\.(\[a-z\]+)(\\.rpt.*)"
                            foreach {f} [lsort [glob -nocomplain -- {*}]] {
                                # Make sure we're not double-saving files
                                if {[regexp -nocase -- $repat $f => rtype ext]} {
                                    # Skip the .dse.rpt file
                                    if {![string equal -nocase $rtype "dse"]} {
                                        set newf "[file join dse [$designspace cget -strCmpName].${point_counter}.${rtype}${ext}]"
                                        catch {file copy -force -- $f $newf}
                                        # Keep a list of files we've saved so we can
                                        # tell the user about this later with the error
                                        # or warning message about base failing.
                                        lappend flist $newf
                                    }
                                }
                            }

                            ::quartus::dse::ccl::wputs "Point ${point_counter} compilation failed -- skipping this point"
                            if {[llength $flist] > 0} {
                                ::quartus::dse::ccl::wputs "Output from failed compilation has been saved as:"
                                foreach f $flist {
                                    ::quartus::dse::ccl::wputs "   $f"
                                }
                            } else {
                                ::quartus::dse::ccl::wputs "No output from failed compilation was found"
                            }
                            set continue_point 0
                        }

                        # Should we stop the flow?
                        if {$stop_flow} {
                            break
                        }

                        # Power analysis
                        if {[::quartus::dse::ccl::get_global_option "flow-run-power"] && $continue_point} {
                            ::quartus::dse::ccl::iputs "Running PowerPlay power analysis on point $point_counter of $number_of_points"
                            if {![::quartus::dse::ccl::quartus_pow $lower_priority [$results($robjind) cget -strProjectName] -c [$results($robjind) cget -strCmpName]]} {
                                set flist [list]
                                set repat "[$results($robjind) cget -strCmpName]\\.(pow)(\\.rpt.*)"
                                foreach {f} [lsort [glob -nocomplain -- {*}]] {
                                    # Make sure we're not double-saving files
                                    if {[regexp -nocase -- $repat $f => rtype ext]} {
                                        # Skip the .dse.rpt file
                                        if {![string equal -nocase $rtype "dse"]} {
                                            set newf "[file join dse [$designspace cget -strCmpName].${point_counter}.${rtype}${ext}]"
                                            catch {file copy -force -- $f $newf}
                                            # Keep a list of files we've saved so we can
                                            # tell the user about this later with the error
                                            # or warning message about base failing.
                                            lappend flist $newf
                                        }
                                    }
                                }

                                ::quartus::dse::ccl::wputs "Point ${point_counter} PowerPlay power analysis failed -- skipping this point"
                                if {[llength $flist] > 0} {
                                    ::quartus::dse::ccl::wputs "Output from failed power analysis has been saved as:"
                                    foreach f $flist {
                                        ::quartus::dse::ccl::wputs "   $f"
                                    }
                                } else {
                                    ::quartus::dse::ccl::wputs "No output from failed power analysis was found"
                                }
                                set continue_point 0
                            }
                        }

                        # Should we stop the flow?
                        if {$stop_flow} {
                            break
                        }

                        # Parse results
                        if {$continue_point} {
                            # If this project is using TimeQuest prepare the result files
                            if {[::quartus::dse::ccl::get_global_option flow-timequest]} {
                                ::quartus::dse::result::extract_results_from_sta -project [$results($robjind) cget -strProjectName] -revision [$results($robjind) cget -strCmpName] -point $point_counter
                            }
                            if {[::quartus::dse::ccl::get_global_option "flow-do-combined-analysis"]} {
                                if {[llength [::quartus::dse::ccl::get_global_option "flow-model-list"]] == 0} {
                                    # Admittedly this is kind of a wierd place to end up. But
                                    # we'll run with it an see where it takes us...there is just
                                    # one model in use at this point.
                                    ::quartus::dse::ccl::iputs "Recording results for point $point_counter of $number_of_points"
                                    if {![$results($robjind) getResultsFromProject -report-all-resource-usage [::quartus::dse::ccl::get_global_option flow-report-all-resource-usage] -point $point_counter]} {
                                        ::quartus::dse::ccl::wputs "Unable to parse results for point $point_counter"
                                    } else {
                                        $results($robjind) setCompiled 1
                                    }
                                    # Make sure dse/result exists
                                    if {![catch {open [file join dse ${point_counter}-result.xml] {WRONLY CREAT TRUNC}} xmlfh]} {
                                        ::quartus::dse::ccl::dputs "${debug_name}: Dumping results to: [file join dse ${point_counter}-result.xml]"
                                        catch {file mkdir [file join dse]}
                                        $results($robjind) dumpXML $xmlfh
                                        close $xmlfh
                                    }
                                } else {
                                    # Record the results for each model
                                    for {set i 0} {$i < [llength [::quartus::dse::ccl::get_global_option "flow-model-list"]]} {incr i} {
                                        if { $i == 0 } {
                                            set key $robjind
                                        } else {
                                            set key "${robjind}-${i}"
                                        }
                                        set model [lindex [::quartus::dse::ccl::get_global_option "flow-model-list"] $i]
                                        $results($key) setName "${robjind}-$model"
                                        ::quartus::dse::ccl::iputs "Recording results for point $point_counter ([$results($key) getName]) of $number_of_points"
                                        if {![$results($key) getResultsFromProject -report-all-resource-usage [::quartus::dse::ccl::get_global_option flow-report-all-resource-usage] -model $model -point $point_counter]} {
                                            ::quartus::dse::ccl::wputs "Unable to parse results for point $point_counter ([$results($key) getName])"
                                        } else {
                                            $results($key) setCompiled 1
                                        }
                                        # Make sure dse/result exists
                                        catch {file mkdir [file join dse]}
                                        set xmlfilename "${key}-result"
                                        if {![catch {open [file join dse ${xmlfilename}.xml] {WRONLY CREAT TRUNC}} xmlfh]} {
                                            ::quartus::dse::ccl::dputs "${debug_name}: Dumping results to: [file join dse ${xmlfilename}.xml]"
                                            $results($key) dumpXML $xmlfh
                                            close $xmlfh
                                        }
                                    }
                                }
                            } else {
                                # There is just one model in use at this point.
                                ::quartus::dse::ccl::iputs "Recording results for point $point_counter of $number_of_points"
                                if {![$results($robjind) getResultsFromProject -report-all-resource-usage [::quartus::dse::ccl::get_global_option flow-report-all-resource-usage] -point $point_counter]} {
                                    ::quartus::dse::ccl::wputs "Unable to parse results for point $point_counter"
                                } else {
                                    $results($robjind) setCompiled 1
                                }
                                # Make sure dse/result exists
                                if {![catch {open [file join dse ${point_counter}-result.xml] {WRONLY CREAT TRUNC}} xmlfh]} {
                                    ::quartus::dse::ccl::dputs "${debug_name}: Dumping results to: [file join dse ${point_counter}-result.xml]"
                                    catch {file mkdir [file join dse]}
                                    $results($robjind) dumpXML $xmlfh
                                    close $xmlfh
                                }
                            }
                        }

                        # Best/Worst analysis
                        if {$continue_point} {

                            # Call helper function to do best/worst analysis
                            ::quartus::dse::ccl::dputs "${debug_name}: Doing best/worst analysis with [::quartus::dse::ccl::get_global_option flow-best-worst-function]"
                            set is_best [[::quartus::dse::ccl::get_global_option "flow-best-worst-function"] -best $results($best_result) -new $results($robjind) -slack-column [list [::quartus::dse::ccl::get_global_option "flow-slack-column"]]]

                            # If we found a new best result, memorize it
                            if {$is_best} {
                                ::quartus::dse::ccl::iputs "Found new best results at point $point_counter"
                                $results($best_result) setBest 0
                                set best_result $robjind
                                $results($best_result) setBest 1
                                set best_point [list {seed} $seeditterator {map} $mapitterator {fit} $fititterator {llr} $llritterator]
                            } else {
                                ::quartus::dse::ccl::dputs "${debug_name}: Keeping old best results"
                            }
                        }

                        # Archive
                        if {$continue_point} {
                            # Archive if this is the new best result
                            if {$is_best} {
                                ::quartus::dse::ccl::iputs "Archiving new best results at point $point_counter"
                                if {![$results($robjind) archive "best.qar"]} {
                                    ::quartus::dse::ccl::eputs "Unable to archive new best results -- halting exploration"
                                    ::quartus::dse::ccl::eputs "Maybe you're out of disk space?"
                                    stop_flow
                                }
                                catch {file copy -force -- [file join dse ${robjind}-result.xml] [file join dse best-result.xml]}
                            }
                            # User wants all points archived
                            if {[::quartus::dse::ccl::get_global_option "flow-archive"]} {
                                ::quartus::dse::ccl::iputs "Archiving results at point $point_counter"
                                if {![$results($robjind) archive "${point_counter}.qar"]} {
                                    ::quartus::dse::ccl::eputs "Unable to archive results -- halting exploration"
                                    ::quartus::dse::ccl::eputs "Maybe you're out of disk space?"
                                }
                            }
                        }

                        # Print cumulative results table, include a dump to a CSV
                        # file if we can open the file otherwise just screen dump
                        if {[catch {open [file join dse "results.csv"] {WRONLY CREAT TRUNC}} csvfh]} {
                            ::quartus::dse::ccl::dputs "${debug_name}: Unable to open dse/result/results.csv -- no CSV data saved for this run"
                            print_all_results_table -title "Detailed Cumulative Results" -results results -exclude-failures -mark-best
                        } else {
                            ::quartus::dse::ccl::dputs "${debug_name}: CSV results will be saved to dse/result/results.csv"
                            # Add a timestamp as the first line in the CSV file
                            puts $csvfh "Project: [$designspace cget -strProjectName]"
                            puts $csvfh "Revision: [$designspace cget -strCmpName]"
                            puts $csvfh "Flow Start Date: [regsub -all -- {,} $::quartus::dse::ccl::init_date_and_time " "]"
                            puts $csvfh "Flow End Date: [regsub -all -- {,} [clock format [clock scan now]] " "]"
                            puts $csvfh ""
                            print_all_results_table -title "Detailed Cumulative Results" -results results -exclude-failures -mark-best -generate-csv -csv-channel $csvfh
                            close $csvfh
                        }

                        # Update GUI
                        if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                            ::quartus::dse::gui::update_progress -update-pbar
                            ::quartus::dse::gui::update_best_result $best_result $results($best_result)
                        }

                        # Check and see if we have zero failing paths. This may
                        # be where the user has asked us to stop exploration.
                        if {[::quartus::dse::ccl::get_global_option "flow-stop-after-zero-failing-paths"]} {
                            set total_failing_paths 0
                            set result_list [list $robjind]
                            for {set i 1} {$i < [llength [::quartus::dse::ccl::get_global_option "flow-model-list"]]} {incr i} {
                                set key "${robjind}-${i}"
                                lappend result_list $key
                            }
                            foreach {point} $result_list {
                                ::quartus::dse::ccl::dputs "${debug_name}: Checking failing paths at $point"
                                set fpaths [lindex [$results($point) getResults -exact "All Failing Paths"] 1]
                                if {![regexp -nocase -- {\d+} $fpaths]} {
                                        set fpaths 0
                                }
                                if {[string match -nocase ">0" $fpaths]} {
                                    # STA is in use -- just make sure at least 1 failing path is counted
                                    set fpaths 1
                                }
                                ::quartus::dse::ccl::dputs "${debug_name}: Found $fpaths failing paths at $point"
                                set total_failing_paths [expr {$total_failing_paths + $fpaths}]
                            }
                            ::quartus::dse::ccl::dputs "${debug_name}: Found $total_failing_paths failing paths"
                            if { $total_failing_paths == 0 } {
                                ::quartus::dse::ccl::iputs "Zero failing paths achieved -- halting exploration"
                                stop_flow
                            }
                        }

                        # Increment point counter
                        incr point_counter

                        # Increment llr space itterator
                        $designspace nextPoint llr

                        # Restore base
                        if {![::quartus::dse::ccl::get_global_option "flow-hardcopy"]} {
                            ::quartus::dse::ccl::iputs "Restoring base settings"
                            if {![$results(base) restoreRevision -delete [::quartus::dse::ccl::get_global_option "flow-temp-revision"]]} {
                                ::quartus::dse::ccl::eputs "Could not restore base settings -- halting exploration"
                                stop_flow
                            }
                        }

                        # Should we stop the flow?
                        if {$stop_flow} {
                            break
                        }

                    }

                    # Increment fit space itterator
                    $designspace nextPoint fit

                    # Should we stop the flow?
                    if {$stop_flow} {
                        break
                    }

                }

                # Increment map space itterator
                $designspace nextPoint map

                # Should we stop the flow?
                if {$stop_flow} {
                    break
                }

            }

            # Increment seed space itterator
            $designspace nextPoint seed

            # Should we stop the flow?
            if {$stop_flow} {
                break
            }

        }

        ::quartus::dse::ccl::dputs "${debug_name}: All points have been explored"

    }

    return 1
}


#############################################################################
##  Procedure:  explore_space_in_parallel
##
##  Description:
##      Explores design space by itterating through every combination
##      of enabled MAP and FIT points.
proc ::quartus::dse::flows::explore_space_in_parallel {args} {

    set debug_name "::quartus::dse::flows::explore_space_in_parallel()"

    # Import global namespace variables
    global stop_flow
    global global_dse_options
    variable stop_after_zero_failing_paths
    variable ddse_is_running
    variable ddse_using_lsf

    # Check to make sure we got a valid designspace object
    set designspace [::quartus::dse::ccl::get_global_option "flow-space"]
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    # Bring their results into our namespace
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-results"] results
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-best-result"] best_result
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-best-point"] best_point
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-point-counter"] point_counter
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-points-to-submit"] points_to_submit

    # Get number of points in design space
    set number_of_points [::quartus::dse::ccl::get_global_option "flow-number-of-points"]

    # Reset the seed space itterator
    ::quartus::dse::ccl::dputs "${debug_name}: Resetting the seed space itterator"
    $designspace resetItterator seed

    # Propagate the fact that users may want to stop after finding
    # zero failing paths at any one point to the package-wide
    # variable.
    set stop_after_zero_failing_paths [::quartus::dse::ccl::get_global_option "flow-stop-after-zero-failing-paths"]

    # For every seed point and every map point and every fit
    # point create an XML file that represents the settings
    # at that point and push it onto a list of points that
    # we'll need to farm off for evaluation.
    if {!$stop_flow} {

        while {[$designspace morePoints seed]} {

            # Set the seed itterator
            set seeditterator [$designspace getItterator seed]

            # Reset the map space itterator
            ::quartus::dse::ccl::dputs "${debug_name}: Resetting the map space itterator"
            $designspace resetItterator map

            while {[$designspace morePoints map]} {

                # Set the map itterator
                set mapitterator [$designspace getItterator map]

                # Reset the fit space itterator
                ::quartus::dse::ccl::dputs "${debug_name}: Resetting the fit space itterator"
                $designspace resetItterator fit

                while {[$designspace morePoints fit]} {

                    # Set the fit itterator
                    set fititterator [$designspace getItterator fit]

                    # Reset the llr space itterator
                    ::quartus::dse::ccl::dputs "${debug_name}: Resetting the llr space itterator"
                    $designspace resetItterator llr

                    while {[$designspace morePoints llr]} {

                        # Set the llr itterator
                        set llritterator [$designspace getItterator llr]

                        # Check and see if this is a skip point
                        if {[::quartus::dse::ccl::get_global_option "flow-skip-points"] != ""} {
                            set str "${seeditterator},${mapitterator},${fititterator},${llritterator}"
                            set skip_this_point 0
                            foreach skippoint [::quartus::dse::ccl::get_global_option "flow-skip-points"] {
                                ::quartus::dse::ccl::dputs "${debug_name}: Comparing skip point $skippoint against current point $str"
                                if {[string equal $str $skippoint]} {
                                    ::quartus::dse::ccl::dputs "${debug_name}: Matched skip point against current point"
                                    set skip_this_point 1
                                    break
                                }
                            }
                            catch {unset str skippoint}
                            if {$skip_this_point} {
                                # Increment llr space itterator
                                ::quartus::dse::ccl::dputs "${debug_name}: Incrementing llr space itterator"
                                $designspace nextPoint llr
                                # And skip to next point
                                ::quartus::dse::ccl::dputs "${debug_name}: Skipping to next point"
                                continue
                            }
                        }

                        ::quartus::dse::ccl::iputs "Setting up point $point_counter of $number_of_points"
                        if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                            ::quartus::dse::gui::update_progress -update-progress-status "Setting Up Point $point_counter of $number_of_points"
                        }

                        # Create a new result object(s) for this point
                        set robjind "${point_counter}"
                        ::quartus::dse::ccl::dputs "${debug_name}: Using result object index for this pass: $robjind"

                        set results($robjind) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
                        # Add the settings for this result to the result object
                        $results($robjind) addSettings [$designspace getParams llr $llritterator] [$designspace getParams seed $seeditterator] [$designspace getParams map $mapitterator] [$designspace getParams fit $fititterator]
                        $results($robjind) setFingerPrint [$results($robjind) generateFingerPrint -base $results(base)]

                        # Check the fingerprint of this point against all the other
                        # results to see if this point possible duplicates another point
                        ::quartus::dse::ccl::dputs "${debug_name}: Starting fingerprint check for point $point_counter"
                        set skip_this_point 0
                        set this_fingerprint [$results($point_counter) getFingerPrint]
                        foreach r [lsort [array names results]] {
                            # Don't check point against itself...
                            if {$r == $robjind} {
                                continue
                            }
                            if {$results($r) != "" && [$results($r) isa ::quartus::dse::result]} {
                                set that_fingerprint [$results($r) getFingerPrint]
                                if {[string equal $this_fingerprint $that_fingerprint]} {
                                    ::quartus::dse::ccl::dputs "${debug_name}: Matching fingerprint found at point $r"
                                    set skip_this_point "Skipping point $point_counter because it duplicates the settings at point $r"
                                    break
                                }
                            }
                        }
                        ::quartus::dse::ccl::dputs "${debug_name}: Done fingerprint check for point $point_counter"
                        if {$skip_this_point != 0} {
                            # Let the user know why we skipped this point
                            ::quartus::dse::ccl::wputs $skip_this_point

                            # Update GUI
                            # We are skipping this point so count it now in the progress
                            # bar. This ensures we end up with a full progress bar even
                            # if we skip all the point in a design space.
                            if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                                ::quartus::dse::gui::update_progress -update-pbar
                            }
                            # Increment point counter
                            incr point_counter
                            # Increment llr space itterator
                            ::quartus::dse::ccl::dputs "${debug_name}: Incrementing llr space itterator"
                            $designspace nextPoint llr
                            # And skip to next point
                            ::quartus::dse::ccl::dputs "${debug_name}: Skipping to next point"
                            continue
                        }

                        print_settings_table -title "Settings for Point $point_counter of $number_of_points" -results results -relative-to-base [$results($robjind) getAllSettings]

                        # Create the XML result file for this point
                        catch {file delete -force -- [file join dse ${robjind}-result.xml]}
                        ::quartus::dse::ccl::dputs "${debug_name}: Generating XML result file [file join dse ${robjind}-result.xml]"
                        set xmlfh [open [file join dse ${robjind}-result.xml] {WRONLY CREAT TRUNC}]
                        $results($robjind) dumpXML $xmlfh
                        close $xmlfh

                        # Make mapping of point # to space indices so we can return the appropriate
                        # information to the flow function that called us later, after we do
                        # the best/worst analysis.
                        set point_mapping($robjind) [list {seed} $seeditterator {map} $mapitterator {fit} $fititterator {llr} $llritterator]
                        set point_mapping(${robjind}-1) [list {seed} $seeditterator {map} $mapitterator {fit} $fititterator {llr} $llritterator]
                        set point_mapping(${robjind}-2) [list {seed} $seeditterator {map} $mapitterator {fit} $fititterator {llr} $llritterator]

                        # Mark this point for submission to cluster
                        lappend points_to_submit $point_counter

                        # Increment point counter
                        incr point_counter

                        # Increment llr space itterator
                        $designspace nextPoint llr

                        # Should we stop the flow?
                        if {$stop_flow} {
                            break
                        }

                    }

                    # Increment fit space itterator
                    $designspace nextPoint fit

                    # Should we stop the flow?
                    if {$stop_flow} {
                        break
                    }

                }

                # Increment map space itterator
                $designspace nextPoint map

                # Should we stop the flow?
                if {$stop_flow} {
                    break
                }

            }

            # Increment seed space itterator
            $designspace nextPoint seed

            # Should we stop the flow?
            if {$stop_flow} {
                break
            }

        }

    }

    # Submit all the points we successfully created QAR files for...
    if {!$stop_flow} {

        # Reset the number of jobs we are submitting
        ::quartus::dse::ccl::dputs "${debug_name}: Clearing any existing jobs from qMasterObj"
        catch {qMasterObj clearJobsID}
        ::quartus::dse::ccl::dputs "${debug_name}: Setting total number of jobs to [llength $points_to_submit]"

        # This is the tcl file we use to drive our remote compiles
        set tclfname [file join $::quartus(tclpath) packages dse remote-compile.tcl]

        foreach p $points_to_submit {
            if {$p == 0} {
                # Deal with the base point a little differently
                ::quartus::dse::ccl::iputs "Preparing base compile for submission"
                catch {file delete -force -- [file join dse base-result.xml]}
                ::quartus::dse::ccl::dputs "${debug_name}: Generating empty XML result file [file join dse base-result.xml]"
                set xmlfh [open [file join dse base-result.xml] {WRONLY CREAT TRUNC}]
                close $xmlfh
                set jid 0
            } else {
                # Numbered point -- easy to submit
                ::quartus::dse::ccl::iputs "Preparing point $p for submission"
                set jid $p
            }

            # We can now call a generic set of submit commands regardless
            # of which point (base or otherwise) we're submitting because
            # qnetwork no longer requires consecutive integers as the
            # job ID.
            qMasterObj addUploadFile $jid "[file join dse base.qar]"
            if {$p == 0} {
                qMasterObj addUploadFile $jid "[file join dse base-result.xml]"
            } else {
                qMasterObj addUploadFile $jid "[file join dse ${jid}-result.xml]"
            }
            qMasterObj addUploadFile $jid "$tclfname"
            # Now because we don't know if the design is using multiple corners
            # in timing analysis we have assume there are a few download files
            # we have to pull back. For now we're going to guess it's three
            # which covers all known cases as of Quartus II 7.2.
            if {$p == 0} {
                qMasterObj addDownloadFile $jid "base-result.xml"
                qMasterObj addDownloadFile $jid "base-1-result.xml"
                qMasterObj addDownloadFile $jid "base-2-result.xml"
            } else {
                qMasterObj addDownloadFile $jid "${jid}-result.xml"
                qMasterObj addDownloadFile $jid "${jid}-1-result.xml"
                qMasterObj addDownloadFile $jid "${jid}-2-result.xml"
            }
			# Always return the QAR file. We'll delete it later if the user
			# didn't ask for all compiles to be archived.
			if {$p == 0} {
				qMasterObj addDownloadFile $jid "base.qar"
			} else {
				qMasterObj addDownloadFile $jid "${jid}.qar"
			}
            # Add these files in case the base compile fails.
            # These files are saved and the user can figure out
            # what went wrong with the compile
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.flow.rpt"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.flow.rpt.htm"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.flow.rpt.html"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.map.rpt"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.map.rpt.htm"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.map.rpt.html"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.fit.rpt"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.fit.rpt.htm"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.fit.rpt.html"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.asm.rpt"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.asm.rpt.htm"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.asm.rpt.html"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.tan.rpt"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.tan.rpt.htm"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.tan.rpt.html"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.pow.rpt"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.pow.rpt.htm"
            qMasterObj addDownloadFile $jid "[$designspace cget -strCmpName].${jid}.pow.rpt.html"
            if {$p == 0} {
                qMasterObj addJobCommand $jid "quartus_sh -t remote-compile.tcl -point base -project [$designspace cget -strProjectName] -revision [$designspace cget -strCmpName] -hardcopy [::quartus::dse::ccl::get_global_option flow-hardcopy] -run-power [::quartus::dse::ccl::get_global_option flow-run-power] -lower-priority [::quartus::dse::ccl::get_global_option flow-lower-priority] -do-combined-analysis [::quartus::dse::ccl::get_global_option flow-do-combined-analysis] -timequest [::quartus::dse::ccl::get_global_option flow-timequest] -report-all-usage [::quartus::dse::ccl::get_global_option flow-report-all-resource-usage]"
            } else {
                qMasterObj addJobCommand $jid "quartus_sh -t remote-compile.tcl -point ${jid} -project [$designspace cget -strProjectName] -revision [$designspace cget -strCmpName] -hardcopy [::quartus::dse::ccl::get_global_option flow-hardcopy] -run-power [::quartus::dse::ccl::get_global_option flow-run-power] -lower-priority [::quartus::dse::ccl::get_global_option flow-lower-priority] -do-combined-analysis [::quartus::dse::ccl::get_global_option flow-do-combined-analysis] -timequest [::quartus::dse::ccl::get_global_option flow-timequest] -report-all-usage [::quartus::dse::ccl::get_global_option flow-report-all-resource-usage]"
            }

        }

        ::quartus::dse::ccl::iputs "All points are ready for submission"
    }

    # Run the distributed compile
    if {!$stop_flow} {
        ::quartus::dse::ccl::iputs "Exploring space"
        if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
            ::quartus::dse::gui::update_progress -update-progress-status "Exploring Space"
        }
        set ddse_is_running 1
        set ddse_using_lsf [qMasterObj getLSFMode]
        qMasterObj submitJobs -statusCallback ::quartus::dse::flows::_status_callback -outputCallback ::quartus::dse::flows::_output_callback
        set ddse_using_lsf 0
        set ddse_is_running 0
    }

    # Load the results from the distributed compile
    set points_to_compare [list]
    foreach p $points_to_submit {
        if {$p == 0} {
            # Deal with the base point a little differently
            set jid_list [list "base" "base-1" "base-2"]
            foreach {tmp} $jid_list {
                if {![info exists results($tmp)]} {
                    set results($tmp) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
                }
                if {[catch {open [file join dse ${tmp}-result.xml]} xmlfh]} {
                    ::quartus::dse::ccl::dputs "${debug_name}: No $tmp results were found"
                    array unset results $tmp
                } else {
                    ::quartus::dse::ccl::iputs "Loading results for base ($tmp)"
                    $results($tmp) loadXML $xmlfh
                    close $xmlfh
                }
            }
            # Assume we start with base as the best point
            catch {$results(base) setBest 1}
            lappend points_to_compare "base"
        } else {
            # Numbered point -- standard method to deal with these
            set jid_list [list $p "${p}-1" "${p}-2"]
            foreach {tmp} $jid_list {
                if {![info exists results($tmp)]} {
                    set results($tmp) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
                }
                if {[catch {open [file join dse ${tmp}-result.xml]} xmlfh]} {
                    ::quartus::dse::ccl::dputs "${debug_name}: No $tmp results were found"
                    array unset results $tmp
                } else {
                    ::quartus::dse::ccl::iputs "Loading results for point $p ($tmp)"
                    $results($tmp) loadXML $xmlfh
                    close $xmlfh
                }
            }
            lappend points_to_compare $p
        }
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Comparing points: $points_to_compare"

    # Analyze the results from the distributed compile
    foreach p $points_to_compare {
        # TDB: I don't think we even have to check for this anymore...
        # Skip the points that are (base-#|#-#) because these are models we
        # don't look at when doing DSE comparisons.
        if {[regexp -nocase -- {(?:base|\d+)-(?:\d+)} $p] || $p == "base"} {
            # We skip fast model points during comparisons
            ::quartus::dse::ccl::dputs "${debug_name}: Skipping best/worst comparison at point $p"
            continue
        } else {
            # Call helper function to do best/worst analysis
            ::quartus::dse::ccl::dputs "${debug_name}: Doing best/worst analysis with [::quartus::dse::ccl::get_global_option flow-best-worst-function]"
            set is_best [[::quartus::dse::ccl::get_global_option "flow-best-worst-function"] -best $results($best_result) -new $results($p) -slack-column [list [::quartus::dse::ccl::get_global_option "flow-slack-column"]]]

            # If we found a new best result, memorize it
            if {$is_best} {
                ::quartus::dse::ccl::iputs "Found new best results at point $p"
                $results($best_result) setBest 0
                set best_result $p
                $results($best_result) setBest 1
                set best_point $point_mapping($p)
                if {[file exists [file join dse ${p}.qar]]} {
                    file copy -force -- [file join dse ${p}.qar] [file join dse best.qar]
                }
                catch {file copy -force -- [file join dse ${p}-result.xml] [file join dse best-result.xml]}
            } else {
                ::quartus::dse::ccl::dputs "${debug_name}: Keeping old best results"
            }
            if {![::quartus::dse::ccl::get_global_option "flow-archive"]} {
                catch {file delete -force -- [file join dse ${p}.qar]}
            }
        }

        # Update GUI
        if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
            ::quartus::dse::gui::update_base_result $results(base)
            ::quartus::dse::gui::update_best_result $best_result $results($best_result)
        }
    }

    ::quartus::dse::ccl::dputs "${debug_name}: All points have been explored"

    return 1
}


#############################################################################
##  Procedure:  basic_exploration
##
##  Description:
##      The very simplest of flows available. Performs a point-by-point
##      search through your design space. It assumes a few things:
##
##          1. There is a fully-qualified space to explore;
##          2. That there exists a 'map' space and a 'fit' space
##             in your designspace object;
##          3. That the point {map,0} in is the "base" case which is
##             the starting point for the best/worst analysis.
##
##      When its finished it returns a list suitable for turning into
##      an array with [array set]. The list is pairs of space names
##      and the best point in that space. Restoring all of these points
##      rebuilds the settings you need to recreate the best results.
##      An empty list means no point in the space (not even the base
##      point) could be compiled properly. An example of a return
##      value would be: {map 0 fit 1} -- which means the best settings
##      were found at map point 0 and fit point 1.
##
##      This function throws an error if something goes wrong
##      along the way.
##
##      The flow always restores your 'base' when it is finished.
proc ::quartus::dse::flows::basic_exploration {args} {

    set debug_name "::quartus::dse::flows::basic_exploration()"

    # Import global namespace variables
    global stop_flow
    global global_dse_options
    set stop_flow 0

    # Check to make sure we got a valid designspace object
    set designspace [::quartus::dse::ccl::get_global_option "flow-space"]
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    # Set the result directory
    set result_directory [file join [pwd] dse]
    catch {file delete -force -- $result_directory}
    catch {file mkdir $result_directory}

    # Bring their results into our namespace
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-results"] results
    array set results [list]

    # Set the best point to an empty list
    set best_point [list]

    # If the user wants to stop this flow after time has elapsed register
    # a handler with after that calls stop_flow to touch the stop flag
    # and halt everything in a nice manner.
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] != "#_ignore_#"} {
        ::quartus::dse::ccl::dputs "${debug_name}: Registering a stop-after-time handler for [::quartus::dse::ccl::get_global_option flow-stop-after-time] minutes"
        set after_id [after [expr {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] * 60000}] ::quartus::dse::flows::stop_flow]
    }

    # Make sure all the points in the seed/map/fit spaces are enabled
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all points in the llr & seed & map & fit spaces"
    $designspace enablePoints seed all
    $designspace enablePoints map all
    $designspace enablePoints fit all
    $designspace enablePoints llr all

    # Calculate the number of compiles we'll have to do
    set number_of_points [expr {[$designspace getSizeOfSpace llr] * [$designspace getSizeOfSpace seed] * [$designspace getSizeOfSpace map] * [$designspace getSizeOfSpace fit] - 1}]
    # There are number_of_points + base checkpoints
    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
        ::quartus::dse::gui::update_progress -update-pbar-maximum [expr {$number_of_points + 1}]
    }
    ::quartus::dse::ccl::iputs "Design space contains $number_of_points points"

    # Record the settings for the base compile
    set results(base) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
    $results(base) addSettings [get_settings_for_base [$designspace cget -strProjectName] [$designspace cget -strCmpName] [$designspace getAllParams seed] [$designspace getAllParams map] [$designspace getAllParams fit] [$designspace getAllParams llr]]
    $results(base) setFingerPrint [$results(base) generateFingerPrint -base $results(base)]
    $results(base) setName "base"
    print_settings_table -title "Settings for base" -results results [$results(base) getAllSettings]

    # Compile base case
    compile_base

    # We store a reference to the current best results.
    # Initialize it to the base results.
    set best_result "base"
    $results(base) setBest 1

    # We also store a reference to the current best point in our best_point
    # structure. It takes the form of a list with the 0 element as the space
    # and the 1 element as the point number. Initialize it to the base point.
    set best_point [list {seed} {0} {map} {0} {fit} {0} {llr} {0}]

    # Print the base results
    print_compile_results_table "Results for base" [$results(base) getAllResults]
    if {[::quartus::dse::ccl::get_global_option "flow-do-combined-analysis"]} {
        print_all_results_table -title "Detailed Cumulative Results" -results results -exclude-failures -mark-best
    }

    # Update GUI
    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
        ::quartus::dse::gui::update_progress -update-pbar
        ::quartus::dse::gui::update_base_result $results(base)
        ::quartus::dse::gui::update_best_result $best_result $results(base)
    }

    # Reset the counter for our point
    set point_counter 1

    # Check and see if we have zero failing paths. This may
    # be where the user has asked us to stop exploration.
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-zero-failing-paths"]} {
        ::quartus::dse::ccl::dputs "${debug_name}: User asked us to stop after zero failing paths -- checking..."
        set total_failing_paths 0
        foreach {point} [array names results] {
            ::quartus::dse::ccl::dputs "${debug_name}: Checking failing paths at $point"
            set fpaths [lindex [$results($point) getResults -exact "All Failing Paths"] 1]
            if {![regexp -nocase -- {\d+} $fpaths]} {
                    set fpaths 0
            }
            if {[string match -nocase ">0" $fpaths]} {
                # STA is in use -- just make sure at least 1 failing path is counted
                set fpaths 1
            }
            ::quartus::dse::ccl::dputs "${debug_name}: Found $fpaths failing paths at $point"
            set total_failing_paths [expr {$total_failing_paths + $fpaths}]
        }
        ::quartus::dse::ccl::dputs "${debug_name}: Found $total_failing_paths failing paths"
        if { $total_failing_paths == 0 } {
            ::quartus::dse::ccl::iputs "Zero failing paths achieved -- halting exploration"
            stop_flow
        }
    }

    set global_dse_options(flow-best-result) best_result
    set global_dse_options(flow-best-point) best_point
    set global_dse_options(flow-point-counter) point_counter
    set global_dse_options(flow-number-of-points) $number_of_points
    set global_dse_options(flow-skip-points) [list "0,0,0,0"]

    # Explore enabled design space
    if {!$stop_flow} {
        explore_space
    }

    # Clean up: Remove after_time if user had set a stop-after-time value
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] != "#_ignore_#" && [info exists after_id]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Unregistering stop-after-time call"
        catch {after cancel $after_id}
    }

    # Try and restore the base results if we were stopped prematurely
    if {$stop_flow} {
        if {![::quartus::dse::ccl::get_global_option "flow-hardcopy"]} {
            ::quartus::dse::ccl::iputs "Restoring base settings at end of flow"
            catch {$results(base) restoreRevision -delete [::quartus::dse::ccl::get_global_option "flow-temp-revision"]}
        }
    }

    # Print the flow summary
    generate_final_flow_report -space $designspace -results results -signature -best-worst-function [::quartus::dse::ccl::get_global_option "flow-best-worst-function"]

    ::quartus::dse::ccl::dputs "${debug_name}: Returning: $best_result"
    return $best_point
}


#############################################################################
##  Procedure:  exhaustive_flow
##
##  Description:
##      The very simplest of flows available. Performs a point-by-point
##      search through your design space. It assumes a few things:
##
##          1. There is a fully-qualified space to explore;
##          2. That there exists a 'map' space and a 'fit' space
##             in your designspace object;
##          3. That the point {map,0} in is the "base" case which is
##             the starting point for the best/worst analysis.
##
##      When its finished it returns a list suitable for turning into
##      an array with [array set]. The list is pairs of space names
##      and the best point in that space. Restoring all of these points
##      rebuilds the settings you need to recreate the best results.
##      An empty list means no point in the space (not even the base
##      point) could be compiled properly. An example of a return
##      value would be: {map 0 fit 1} -- which means the best settings
##      were found at map point 0 and fit point 1.
##
##      This function throws an error if something goes wrong
##      along the way.
##
##      The flow always restores your 'base' when it is finished.
##
##      The flow can perform multiple concurrent compiles using a qslave
##      listener started on this machine in conjunction with qslave
##      listeners started on other machines. This allows you to explore
##      the space in parallel.
proc ::quartus::dse::flows::exhaustive_flow {args} {

    set debug_name "::quartus::dse::flows::exhaustive_flow()"

    # Import global namespace variables
    global stop_flow
    global global_dse_options
    set stop_flow 0

    # That that the global_dse_options array is set up properly for us.
    foreach opt [array names global_dse_options -regexp "^flow\-.*"] {
        ::quartus::dse::ccl::dputs "${debug_name}: Checking validity of global_dse_options: $opt = $global_dse_options($opt)"
        if {$global_dse_options($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required global_dse_options: ${opt}"
        }
    }

    # Check to make sure we got a valid designspace object
    set designspace [::quartus::dse::ccl::get_global_option "flow-space"]
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    # Check to make sure the user hasn't done something strange like
    # zeroed concurrent compiles, not selected LSF mode and not
    # supplied a list of remote clients to use.
    if {[llength [::quartus::dse::ccl::get_global_option "flow-slaves"]] == 0 && ![::quartus::dse::ccl::get_global_option "flow-lsfmode"] && [::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"] < 1} {
        ::quartus::dse::ccl::dputs "${debug_name}: Forcing concurrent compiles to 1"
        set global_dse_options(flow-concurrent-compiles) 1
    }

    # Create a temporary revision name to hold all the DSE settings
    # in during our exploration.
    set temp_revision [::quartus::dse::flows::create_temporary_revision_name [$designspace cget -strProjectName] "__dse_temp_rev"]
    set global_dse_options(flow-temp-revision) $temp_revision

    # Make decision now if we'll be using the new concurrent flow
    # or if we'll stick with the old one-at-a-time flow.
    if {[llength [::quartus::dse::ccl::get_global_option "flow-slaves"]] == 0 && ![::quartus::dse::ccl::get_global_option "flow-lsfmode"] && [::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"] == 1} {
        ::quartus::dse::ccl::dputs "${debug_name}: Using old one-at-a-time flow"
        return [::quartus::dse::flows::basic_exploration]
    }

    # Clear existing slaves
    ::quartus::dse::ccl::dputs "${debug_name}: Clearing any existing slaves from qMasterObj"
    catch {qMasterObj clearSlavesID}

    # Register slaves with qMasterObj or set LSF mode
    if {[::quartus::dse::ccl::get_global_option "flow-lsfmode"]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Enabling LSF mode"
        qMasterObj setLSFMode 1
        # Use a non-default queue?
        if {![string equal [::quartus::dse::ccl::get_global_option "flow-lsf-queue"] "#_default_#"] && ![string equal [::quartus::dse::ccl::get_global_option "flow-lsf-queue"] "<default>"]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Setting LSF to queue [::quartus::dse::ccl::get_global_option flow-lsf-queue]"
            qMasterObj setLSFQueue [::quartus::dse::ccl::get_global_option "flow-lsf-queue"]
        }
    } else {
        qMasterObj setLSFMode 0

        # The user wants to run compiles on this machine if they have
        # set concurrent-compiles to greater than 0. Otherwise we're
        # just using other clients in the pool to do the work. We
        # can only use this machine for concurrent compiles if the user
        # is NOT using the tool in LSF or Condor mode.
        if {[::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"] > 0} {
            # Get the hostname and the domain name for this machine
            regexp -nocase -- {([a-z0-9_-]+)(.*)} [info hostname] => hostname domain
            ::quartus::dse::ccl::dputs "${debug_name}: Parsed host = ${hostname} and domain = ${domain} from [info hostname]"
            # If we couldn't get the hostname of this machine and the slaves
            # list is empty try using localhost as the hostname. It's bit
            # ugly but it should work just fine.
            if { [regexp -- {$\s*^} $hostname] && [llength [::quartus::dse::ccl::get_global_option "flow-slaves"]] == 0 } {
                set hostname "localhost"
                set domain ""
            }
            # We need to make sure we don't add this host to the list of
            # slaves twice. This causes problems with the qMaster API.
            # So check the hostname against every host name in the slave
            # list.
            set tempslaves [list]
            foreach slave [::quartus::dse::ccl::get_global_option "flow-slaves"] {
                regexp -nocase -- {([a-z0-9_-]+)(.*)} $slave => slavehostname domain
                if {[string equal -nocase $hostname $slavehostname]} {
                    ::quartus::dse::ccl::dputs "${debug_name}: Pruning slave $slave from the slave list"
                } else {
                    ::quartus::dse::ccl::dputs "${debug_name}: Keeping slave $slave on the slave list"
                    lappend tempslaves $slave
                }
            }
            set global_dse_options(flow-slaves) $tempslaves

            # Create a qslave instance on this machine that will run the jobs
            # for us, perhaps even in parallel. Depending on our -debug state
            # hide or unhide the qslave terminal interface.
			file mkdir [file join dse qslave]
            if {[::quartus::dse::ccl::get_global_option "dse-debug"]} {
                if {[catch {::quartus::dse::ccl::qslave -jobs [::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"] -gui} qslave_pid]} {
                    return -code error "${debug_name}: Unable to create qslave instance on [info hostname]: $qslave_pid"
                }
            } else {
                if {[catch {::quartus::dse::ccl::qslave -jobs [::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"]} qslave_pid]} {
                    return -code error "${debug_name}: Unable to create qslave instance on [info hostname]: $qslave_pid"
                }
            }

            ::quartus::dse::ccl::dputs "${debug_name}: Registering slave [info hostname] with qMasterObj"
			::quartus::dse::ccl::iputs "Registered slave [info hostname] with DSE"
            qMasterObj addSlaveID [info hostname]
        }

        # Now add any additional slaves they had in their remote slave list
        foreach slave [::quartus::dse::ccl::get_global_option "flow-slaves"] {
			# SPR 263684: Only add slaves we can ping
			if {[qMasterObj pingSlaveID $slave]} {
				::quartus::dse::ccl::dputs "${debug_name}: Registering slave ${slave} with qMasterObj"
				::quartus::dse::ccl::iputs "Registered slave ${slave} with DSE"
				qMasterObj addSlaveID $slave
			} else {
				::quartus::dse::ccl::wputs "Could not contact slave ${slave} -- it will not be used during this search"
			}
        }
    }

    # Set the result directory
    set result_directory [file join [pwd] dse]
    catch {file delete -force -- $result_directory}
    catch {file mkdir $result_directory}
    ::quartus::dse::ccl::dputs "${debug_name}: Setting cluster result directory to $result_directory"
    qMasterObj setResultDir $result_directory

    # Bring their results into our namespace
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-results"] results
    array set results [list]

    # Set the best point to an empty list
    set best_point [list]

    # Setup a list that we'll use to pass around the points that
    # should be compiled in parallel.
    set points_to_submit [list]
    set point_counter 0

    # If the user wants to stop this flow after time has elapsed register
    # a handler with after that calls stop_flow to touch the stop flag
    # and halt everything in a nice manner.
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] != "#_ignore_#"} {
        ::quartus::dse::ccl::dputs "${debug_name}: Registering a stop-after-time handler for [::quartus::dse::ccl::get_global_option "flow-stop-after-time"] minutes"
        set after_id [after [expr {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] * 60000}] ::quartus::dse::flows::stop_flow]
    }

    # Make sure all the points in the seed/map/fit spaces are enabled
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all points in the llr & seed & map & fit spaces"
    $designspace enablePoints seed all
    $designspace enablePoints map all
    $designspace enablePoints fit all
    $designspace enablePoints llr all

    # Calculate the number of compiles we'll have to do
    set number_of_points [expr {[$designspace getSizeOfSpace llr] * [$designspace getSizeOfSpace seed] * [$designspace getSizeOfSpace map] * [$designspace getSizeOfSpace fit] - 1}]
    # There are number_of_points + base checkpoints
    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
        ::quartus::dse::gui::update_progress -update-pbar-maximum [expr {$number_of_points + 1}]
    }
    ::quartus::dse::ccl::iputs "Design space contains $number_of_points points"

    # Record the settings for the base compile
    set results(base) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
    $results(base) addSettings [get_settings_for_base [$designspace cget -strProjectName] [$designspace cget -strCmpName] [$designspace getAllParams seed] [$designspace getAllParams map] [$designspace getAllParams fit] [$designspace getAllParams llr]]
    $results(base) setFingerPrint [$results(base) generateFingerPrint -base $results(base)]
    $results(base) setName "base"
    print_settings_table -title "Settings for base" -results results [$results(base) getAllSettings]

    # We store a reference to the current best results.
    # Initialize it to the base results.
    set best_result "base"
    $results(base) setBest 1

    # We also store a reference to the current best point in our best_point
    # structure. It takes the form of a list with the 0 element as the space
    # and the 1 element as the point number. Initialize it to the base point.
    set best_point [list {seed} {0} {map} {0} {fit} {0} {llr} {0}]

    # Analyze the base case. Generate a base.qar file for use by all
    # our point compiles and add our base compile to the list of
    # compiles to perform during the next explore_space_in_parallel
    # call.
    set global_dse_options(flow-best-result) best_result
    set global_dse_options(flow-best-point) best_point
    set global_dse_options(flow-point-counter) point_counter
    set global_dse_options(flow-number-of-points) $number_of_points
    set global_dse_options(flow-skip-points) [list "0,0,0,0"]
    set global_dse_options(flow-points-to-submit) points_to_submit
    analyze_base

    # Explore enabled design space
    explore_space_in_parallel

    # Clean up: Remove after_time if user had set a stop-after-time value
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] != "#_ignore_#" && [info exists after_id]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Unregistering stop-after-time call"
        catch {after cancel $after_id}
    }

    # Clean up: Stop qSlave that we started
    catch {::quartus::dse::ccl::dputs "${debug_name}: Killing qslave process $qslave_pid"}
    if {[string equal -nocase $::tcl_platform(platform) "unix"]} {
        catch {exec -- kill $qslave_pid}
    } else {
        catch {exec -- [file join $::quartus(binpath) killqw] -t $qslave_pid}
    }

    # Clean up: Delete qslave output directory
    catch {file delete -force -- [file join dse qslave]}

    # Print the flow summary
    generate_final_flow_report -space $designspace -results results -signature -best-worst-function [::quartus::dse::ccl::get_global_option "flow-best-worst-function"]

    ::quartus::dse::ccl::dputs "${debug_name}: Returning: $best_result"
    return $best_point
}


#############################################################################
##  Procedure:  accelerated_flow
##
##  Description:
##      An accelerated search of a design space. Not completely rigorous
##      but generally finds the best point in the space because the best
##      points tend to lie along well known n-dimensional paths.
##
##      The accelerated search traverses each dimension and finds the
##      best settings in each dimension. Fixes that dimension and then
##      moves on to the next dimension until all n-dimensions have been
##      searched. This is a considerably time savings over the exhaustive
##      flow.
##
##      It assumes a few things:
##
##          1. There is a fully-qualified space to explore;
##          2. That there exists a 'map' space and a 'fit' space
##             in your designspace object;
##          3. That the point {map,0} in is the "base" case which is
##             the starting point for the best/worst analysis.
##
##      When its finished it returns a list suitable for turning into
##      an array with [array set]. The list is pairs of space names
##      and the best point in that space. Restoring all of these points
##      rebuilds the settings you need to recreate the best results.
##      An empty list means no point in the space (not even the base
##      point) could be compiled properly. An example of a return
##      value would be: {map 0 fit 1} -- which means the best settings
##      were found at map point 0 and fit point 1.
##
##      This function throws an error if something goes wrong
##      along the way.
##
##      The flow always restores your 'base' when it is finished.
##
##      The flow can perform multiple concurrent compiles using a qslave
##      listener started on this machine in conjunction with qslave
##      listeners started on other machines. This allows you to explore
##      the space in parallel.
proc ::quartus::dse::flows::accelerated_flow {args} {

    set debug_name "::quartus::dse::flows::accelerated_flow()"

    # Import global namespace variables
    global stop_flow
    global global_dse_options
    set stop_flow 0

    # That that the global_dse_options array is set up properly for us.
    foreach opt [array names global_dse_options -regexp "^flow\-.*"] {
        ::quartus::dse::ccl::dputs "${debug_name}: Checking validity of global_dse_options: $opt = $global_dse_options($opt)"
        if {$global_dse_options($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required global_dse_options: ${opt}"
        }
    }

    # Check to make sure we got a valid designspace object
    set designspace [::quartus::dse::ccl::get_global_option "flow-space"]
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    # Check to make sure the user hasn't done something strange like
    # zeroed concurrent compiles, not selected LSF mode and not
    # supplied a list of remote clients to use.
    if {[llength [::quartus::dse::ccl::get_global_option "flow-slaves"]] == 0 && ![::quartus::dse::ccl::get_global_option "flow-lsfmode"] && [::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"] < 1} {
        ::quartus::dse::ccl::dputs "${debug_name}: Forcing concurrent compiles to 1"
        set global_dse_options(flow-concurrent-compiles) 1
    }

    # Create a temporary revision name to hold all the DSE settings
    # in during our exploration.
    set temp_revision [::quartus::dse::flows::create_temporary_revision_name [$designspace cget -strProjectName] "__dse_temp_rev"]
    set global_dse_options(flow-temp-revision) $temp_revision

    # Make decision now if we'll be using the new concurrent flow
    # or if we'll stick with the old one-at-a-time flow.
    if {[llength [::quartus::dse::ccl::get_global_option "flow-slaves"]] == 0 && ![::quartus::dse::ccl::get_global_option "flow-lsfmode"] && [::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"] == 1} {
        ::quartus::dse::ccl::dputs "${debug_name}: Using old one-at-a-time flow"
        return [::quartus::dse::flows::basic_exploration_with_advanced_pruning]
    }

    # Clear existing slaves
    ::quartus::dse::ccl::dputs "${debug_name}: Clearing any existing slaves from qMasterObj"
    catch {qMasterObj clearSlavesID}

    # Register slaves with qMasterObj or set LSF mode
    if {[::quartus::dse::ccl::get_global_option "flow-lsfmode"]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Enabling LSF mode"
        qMasterObj setLSFMode 1
        # Use a non-default queue?
        if {![string equal [::quartus::dse::ccl::get_global_option "flow-lsf-queue"] "#_default_#"] && ![string equal [::quartus::dse::ccl::get_global_option "flow-lsf-queue"] "<default>"]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Setting LSF to queue [::quartus::dse::ccl::get_global_option "flow-lsf-queue"]"
            qMasterObj setLSFQueue [::quartus::dse::ccl::get_global_option "flow-lsf-queue"]
        }
    } else {
        qMasterObj setLSFMode 0

        # The user wants to run compiles on this machine if they have
        # set concurrent-compiles to greater than 0. Otherwise we're
        # just using other clients in the pool to do the work. We
        # can only use this machine for concurrent compiles if the user
        # is NOT using the tool in LSF or Condor mode.
        if {[::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"] > 0} {
            # Get the hostname and the domain name for this machine
            regexp -nocase -- {([a-z0-9_-]+)(.*)} [info hostname] => hostname domain
            ::quartus::dse::ccl::dputs "${debug_name}: Parsed host = ${hostname} and domain = ${domain} from [info hostname]"
            # If we couldn't get the hostname of this machine and the slaves
            # list is empty try using localhost as the hostname. It's bit
            # ugly but it should work just fine.
            if { [regexp -- {$\s*^} $hostname] && [llength [::quartus::dse::ccl::get_global_option "flow-slaves"]] == 0 } {
                set hostname "localhost"
                set domain ""
            }
            # We need to make sure we don't add this host to the list of
            # slaves twice. This causes problems with the qMaster API.
            # So check the hostname against every host name in the slave
            # list.
            set tempslaves [list]
            foreach slave [::quartus::dse::ccl::get_global_option "flow-slaves"] {
                regexp -nocase -- {([a-z0-9_-]+)(.*)} $slave => slavehostname domain
                if {[string equal -nocase $hostname $slavehostname]} {
                    ::quartus::dse::ccl::dputs "${debug_name}: Pruning slave $slave from the slave list"
                } else {
                    ::quartus::dse::ccl::dputs "${debug_name}: Keeping slave $slave on the slave list"
                    lappend tempslaves $slave
                }
            }
            set global_dse_options(flow-slaves) $tempslaves

            # Create a qslave instance on this machine that will run the jobs
            # for us, perhaps even in parallel. Depending on our -debug state
            # hide or unhide the qslave terminal interface.
			file mkdir [file join dse qslave]
            if {[::quartus::dse::ccl::get_global_option "dse-debug"]} {
                if {[catch {::quartus::dse::ccl::qslave -jobs [::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"] -gui} qslave_pid]} {
                    return -code error "${debug_name}: Unable to create qslave instance on [info hostname]: $qslave_pid"
                }
            } else {
                if {[catch {::quartus::dse::ccl::qslave -jobs [::quartus::dse::ccl::get_global_option "flow-concurrent-compiles"]} qslave_pid]} {
                    return -code error "${debug_name}: Unable to create qslave instance on [info hostname]: $qslave_pid"
                }
            }

            ::quartus::dse::ccl::dputs "${debug_name}: Registering slave [info hostname] with qMasterObj"
			::quartus::dse::ccl::iputs "Registered slave [info hostname] with DSE"
            qMasterObj addSlaveID [info hostname]
        }

        # Now add any additional slaves they had in their remote slave list
        foreach slave [::quartus::dse::ccl::get_global_option "flow-slaves"] {
            # SPR 263684: Only add slaves we can ping
			if {[qMasterObj pingSlaveID $slave]} {
				::quartus::dse::ccl::dputs "${debug_name}: Registering slave ${slave} with qMasterObj"
				::quartus::dse::ccl::iputs "Registered slave ${slave} with DSE"
				qMasterObj addSlaveID $slave
			} else {
				::quartus::dse::ccl::wputs "Could not contact slave ${slave} -- it will not be used during this search"
			}
        }
    }

    # Set the result directory
    set result_directory [file join [pwd] dse]
    catch {file delete -force -- $result_directory}
    catch {file mkdir $result_directory}
    ::quartus::dse::ccl::dputs "${debug_name}: Setting cluster result directory to $result_directory"
    qMasterObj setResultDir $result_directory

    # Bring their results into our namespace
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-results"] results
    array set results [list]

    # Set the best point to an empty list
    set best_point [list]

    # Setup a list that we'll use to pass around the points that
    # should be compiled in parallel.
    set points_to_submit [list]
    set point_counter 0

    # If the user wants to stop this flow after time has elapsed register
    # a handler with after that calls stop_flow to touch the stop flag
    # and halt everything in a nice manner.
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] != "#_ignore_#"} {
        ::quartus::dse::ccl::dputs "${debug_name}: Registering a stop-after-time handler for [::quartus::dse::ccl::get_global_option "flow-stop-after-time"] minutes"
        set after_id [after [expr {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] * 60000}] ::quartus::dse::flows::stop_flow]
    }

    # Make sure all the points in the seed/map/fit spaces are enabled
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all points in the llr & seed & map & fit spaces"
    $designspace enablePoints seed all
    $designspace enablePoints map all
    $designspace enablePoints fit all
    $designspace enablePoints llr all

    # Calculate the number of compiles we'll have to do
    set number_of_points [expr {[$designspace getSizeOfSpace llr] + [$designspace getSizeOfSpace map] + [$designspace getSizeOfSpace fit] + [$designspace getSizeOfSpace seed] - 4}]
    # There are number_of_points + base checkpoints
    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
        ::quartus::dse::gui::update_progress -update-pbar-maximum [expr {$number_of_points + 1}]
    }
    ::quartus::dse::ccl::iputs "Design space contains $number_of_points points"

    # Record the settings for the base compile
    set results(base) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
    $results(base) addSettings [get_settings_for_base [$designspace cget -strProjectName] [$designspace cget -strCmpName] [$designspace getAllParams seed] [$designspace getAllParams map] [$designspace getAllParams fit] [$designspace getAllParams llr]]
    $results(base) setFingerPrint [$results(base) generateFingerPrint -base $results(base)]
    $results(base) setName "base"
    print_settings_table -title "Settings for base" -results results [$results(base) getAllSettings]

    # We store a reference to the current best results.
    # Initialize it to the base results.
    set best_result "base"
    $results($best_result) setBest 1

    # We also store a reference to the current best point in our best_point
    # structure. It takes the form of a list with the 0 element as the space
    # and the 1 element as the point number. Initialize it to the base point.
    set best_point [list {seed} {0} {map} {0} {fit} {0} {llr} {0}]

    # Analyze the base case. Generate a base.qar file for use by all
    # our point compiles and add our base compile to the list of
    # compiles to perform during the next explore_space_in_parallel
    # call.
    set global_dse_options(flow-best-result) best_result
    set global_dse_options(flow-best-point) best_point
    set global_dse_options(flow-point-counter) point_counter
    set global_dse_options(flow-number-of-points) $number_of_points
    set global_dse_options(flow-skip-points) [list "0,0,0,0"]
    set global_dse_options(flow-points-to-submit) points_to_submit
    analyze_base

    # Find the best logiclock settings first
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing seed space at point 0"
    $designspace disablePoints seed all
    $designspace enablePoints seed 0
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing map space at point 0"
    $designspace disablePoints map all
    $designspace enablePoints map 0
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing fit space at point 0"
    $designspace disablePoints fit all
    $designspace enablePoints fit 0
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all but point 0 in the llr space"
    $designspace enablePoints llr all
    $designspace disablePoints llr 0

    # Explore enabled design space
    explore_space_in_parallel

    # Make a hash of the best settings at this point
    array set best_array $best_point

    # Enable the best point only in the map space
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing llr at the best llr point: $best_array(llr)"
    $designspace disablePoints llr all
    $designspace enablePoints llr $best_array(llr)

    # Find the best fit settings
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all but point 0 in the fit space"
    $designspace enablePoints fit all
    $designspace disablePoints fit 0

    # Empty the list of points to submit
    set points_to_submit [list]

    # Explore enabled design space
    if {!$stop_flow && [$designspace getSizeOfSpace fit] > 0} {

        set global_dse_options(flow-best-result) best_result
        set global_dse_options(flow-best-point) best_point
        set global_dse_options(flow-point-counter) point_counter
        set global_dse_options(flow-number-of-points) $number_of_points
        set global_dse_options(flow-skip-points) [list "0,0,0,0"]

        explore_space_in_parallel
    }


    # Make a hash of the best settings at this point
    array set best_array $best_point

    # Enable the best point only in the map space
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing fit at the best fit point: $best_array(fit)"
    $designspace disablePoints fit all
    $designspace enablePoints fit $best_array(fit)

    # Find the best map settings
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all but point 0 in the map space"
    $designspace enablePoints map all
    $designspace disablePoints map 0

    # Empty the list of points to submit
    set points_to_submit [list]

    if {!$stop_flow && [$designspace getSizeOfSpace map] > 0} {

        set global_dse_options(flow-best-result) best_result
        set global_dse_options(flow-best-point) best_point
        set global_dse_options(flow-point-counter) point_counter
        set global_dse_options(flow-number-of-points) $number_of_points
        set global_dse_options(flow-skip-points) [list "0,0,0,0"]

        # Explore enabled design space
        explore_space_in_parallel
    }

    # Make a hash of the best settings at this point
    catch {array unset best_array}
    array set best_array $best_point

    # Enable the best point only in the map space
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing map at the best map point: $best_array(map)"
    $designspace disablePoints map all
    $designspace enablePoints map $best_array(map)

    # Find the best seed
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all but point 0 in the seed space"
    $designspace enablePoints seed all
    $designspace disablePoints seed 0

    # Empty the list of points to submit
    set points_to_submit [list]

    if {!$stop_flow && [$designspace getSizeOfSpace seed] > 0} {

        set global_dse_options(flow-best-result) best_result
        set global_dse_options(flow-best-point) best_point
        set global_dse_options(flow-point-counter) point_counter
        set global_dse_options(flow-number-of-points) $number_of_points
        set global_dse_options(flow-skip-points) [list "0,0,0,0"]

        # Explore enabled design space
        explore_space_in_parallel
    }

    # Clean up: Remove after_time if user had set a stop-after-time value
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] != "#_ignore_#" && [info exists after_id]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Unregistering stop-after-time call"
        catch {after cancel $after_id}
    }

    # Clean up: Stop qSlave that we started
    catch {::quartus::dse::ccl::dputs "${debug_name}: Killing qslave process $qslave_pid"}
    if {[string equal -nocase $::tcl_platform(platform) "unix"]} {
        catch {exec -- kill $qslave_pid}
    } else {
        catch {exec -- [file join $::quartus(binpath) killqw] -t $qslave_pid}
    }

    # Print the flow summary
    generate_final_flow_report -space $designspace -results results -signature -best-worst-function [::quartus::dse::ccl::get_global_option "flow-best-worst-function"]

    ::quartus::dse::ccl::dputs "${debug_name}: Returning: $best_result"
    return $best_point
}


#############################################################################
##  Procedure:  create_revisions
##
##  Description:
##		Very similar to the basic_exploration proc. This proc doesn't
##		actually perform any compiles, it just sweeps through the
##		space and exhaustivily creates a whole bunch of revisions
##		for you in your project. You can then use something like
##		a compute grid to compile all the revisions in parallel.
proc ::quartus::dse::flows::create_revisions {args} {

    set debug_name "::quartus::dse::flows::create_revisions()"

    set args [join $args]

    # Import global namespace variables
    global global_dse_options
    global stop_flow
    set stop_flow 0

    # That that the global_dse_options array is set up properly for us.
    foreach opt [array names global_dse_options -regexp "^flow\-.*"] {
        ::quartus::dse::ccl::dputs "${debug_name}: Checking validity of global_dse_options: $opt = $global_dse_options($opt)"
        if {$global_dse_options($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required global_dse_options: ${opt}"
        }
    }

    # Check to make sure we got a valid designspace object
    set designspace [::quartus::dse::ccl::get_global_option "flow-space"]
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    set point_counter 1

    # Make sure all the points in the seed/map/fit spaces are enabled
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all points in the llr & seed & map & fit spaces"
    $designspace enablePoints seed all
    $designspace enablePoints map all
    $designspace enablePoints fit all
    $designspace enablePoints llr all
	# But skip the first point
	set global_dse_options(flow-skip-points) [list "0,0,0,0"]

    # Calculate the number of compiles we'll have to do
    set number_of_points [expr {[$designspace getSizeOfSpace llr] * [$designspace getSizeOfSpace seed] * [$designspace getSizeOfSpace map] * [$designspace getSizeOfSpace fit] - 1}]
    # There are number_of_points + base checkpoints
    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
        ::quartus::dse::gui::update_progress -update-pbar-maximum [expr {$number_of_points + 1}]
    }
    ::quartus::dse::ccl::iputs "Design space contains $number_of_points points"

    # Record the settings for the base compile
    set results(base) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
    $results(base) addSettings [get_settings_for_base [$designspace cget -strProjectName] [$designspace cget -strCmpName] [$designspace getAllParams seed] [$designspace getAllParams map] [$designspace getAllParams fit] [$designspace getAllParams llr]]
    $results(base) setFingerPrint [$results(base) generateFingerPrint -base $results(base)]

	#
	# START
	#

    # Reset the seed space itterator
    ::quartus::dse::ccl::dputs "${debug_name}: Resetting the seed space itterator"
    $designspace resetItterator seed

	while {[$designspace morePoints seed]} {

		# Set the seed itterator
		set seeditterator [$designspace getItterator seed]

		# Reset the map space itterator
		::quartus::dse::ccl::dputs "${debug_name}: Resetting the map space itterator"
		$designspace resetItterator map

		while {[$designspace morePoints map]} {

			# Set the map itterator
			set mapitterator [$designspace getItterator map]

			# Reset the fit space itterator
			::quartus::dse::ccl::dputs "${debug_name}: Resetting the fit space itterator"
			$designspace resetItterator fit

			while {[$designspace morePoints fit]} {

				# Set the fit itterator
				set fititterator [$designspace getItterator fit]

				# Reset the llr space itterator
				::quartus::dse::ccl::dputs "${debug_name}: Resetting the llr space itterator"
				$designspace resetItterator llr

				while {[$designspace morePoints llr]} {

					# Set the llr itterator
					set llritterator [$designspace getItterator llr]

					# Check and see if this is a skip point
					if {[::quartus::dse::ccl::get_global_option "flow-skip-points"] != ""} {
						set str "${seeditterator},${mapitterator},${fititterator},${llritterator}"
						set skip_this_point 0
						foreach skippoint [::quartus::dse::ccl::get_global_option "flow-skip-points"] {
							::quartus::dse::ccl::dputs "${debug_name}: Comparing skip point $skippoint against current point $str"
							if {[string equal $str $skippoint]} {
								::quartus::dse::ccl::dputs "${debug_name}: Matched skip point against current point"
								set skip_this_point 1
								break
							}
						}
						catch {unset str skippoint}
						if {$skip_this_point} {
							# Increment llr space itterator
							::quartus::dse::ccl::dputs "${debug_name}: Incrementing llr space itterator"
							$designspace nextPoint llr
							# And skip to next point
							::quartus::dse::ccl::dputs "${debug_name}: Skipping to next point"
							continue
						}
					}

					::quartus::dse::ccl::iputs "Creating revision for point $point_counter of $number_of_points"
                    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                        ::quartus::dse::gui::update_progress -update-progress-status "Creating Revision For Point $point_counter of $number_of_points"
                    }

					# Create a new result object for this point
					set results($point_counter) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
					# Add the settings for this result to the result object
					$results($point_counter) addSettings [$designspace getParams llr $llritterator] [$designspace getParams seed $seeditterator] [$designspace getParams map $mapitterator] [$designspace getParams fit $fititterator]
					$results($point_counter) setFingerPrint [$results($point_counter) generateFingerPrint -base $results(base)]
					set robjind "${point_counter}"
					::quartus::dse::ccl::dputs "${debug_name}: Using result object index for this pass: $robjind"


					# Check the fingerprint of this point against all the other
					# results to see if this point possible duplicates another point
					::quartus::dse::ccl::dputs "${debug_name}: Starting fingerprint check for point $point_counter"
					set skip_this_point 0
					set this_fingerprint [$results(${robjind}) getFingerPrint]
					foreach r [lsort [array names results]] {
						# Don't check point against itself...
						if {$r == $robjind} {
							continue
						}
						if {$results($r) != "" && [$results($r) isa ::quartus::dse::result]} {
							set that_fingerprint [$results($r) getFingerPrint]
							if {[string equal $this_fingerprint $that_fingerprint]} {
								::quartus::dse::ccl::dputs "${debug_name}: Matching fingerprint found at point $r"
								set skip_this_point "Skipping point $point_counter because it duplicates the settings at point $r"
								break
							}
						}
					}
					::quartus::dse::ccl::dputs "${debug_name}: Done fingerprint check for point $point_counter"
					if {$skip_this_point != 0} {
						# Let the user know why we skipped this point
						::quartus::dse::ccl::wputs $skip_this_point

						# Update GUI
                        if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                            ::quartus::dse::gui::update_progress -update-pbar
                        }
						# Increment point counter
						incr point_counter
						# Increment llr space itterator
						::quartus::dse::ccl::dputs "${debug_name}: Incrementing llr space itterator"
						$designspace nextPoint llr
						# And skip to next point
						::quartus::dse::ccl::dputs "${debug_name}: Skipping to next point"
						continue
					}

					print_settings_table -title "Settings for Point $point_counter of $number_of_points" -results results -relative-to-base [$results(${robjind}) getAllSettings]

					# Create the llr & seed & map & fit space
					set temp_revision [::quartus::dse::flows::create_temporary_revision_name [$designspace cget -strProjectName] "dse_point_$robjind"]
					::quartus::dse::ccl::iputs "Creating revision $temp_revision for point $robjind"
					$results($robjind) makeRevision -make-default -name $temp_revision -comment "DSE point $robjind"

					# Update GUI
                    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                        ::quartus::dse::gui::update_progress -update-pbar
                        #::quartus::dse::gui::update_best_result $best_result $results($best_result)
                    }

					# Increment point counter
					incr point_counter

					# Increment llr space itterator
					$designspace nextPoint llr

					# Restore base
					::quartus::dse::ccl::iputs "Restoring base settings"
					if {![$results(base) restoreRevision]} {
						::quartus::dse::ccl::eputs "Could not restore base settings -- halting exploration"
						stop_flow
					}

					# Should we stop the flow?
					if {$stop_flow} {
						break
					}

				}

				# Increment fit space itterator
				$designspace nextPoint fit

				# Should we stop the flow?
				if {$stop_flow} {
					break
				}

			}

			# Increment map space itterator
			$designspace nextPoint map

			# Should we stop the flow?
			if {$stop_flow} {
				break
			}

		}

		# Increment seed space itterator
		$designspace nextPoint seed

		# Should we stop the flow?
		if {$stop_flow} {
			break
		}

	}

	::quartus::dse::ccl::dputs "${debug_name}: All revisions have been created"

	#
	# END
	#

	# Nothing to return so an empty list will have to suffice
    return [list]
}


#############################################################################
##  Procedure:  basic_exploration_with_advanced_pruning
##
##  Description:
##      The very simplest of flows available. Performs a point-by-point
##      search through your design space. It assumes a few things:
##
##          1. There is a fully-qualified space to explore;
##          2. That there exists a 'map' space and a 'fit' space
##             and a 'seed' space and an 'llr' space in your
##             designspace object;
##          3. That the point {map,0} in is the "base" case which is
##             the starting point for the best/worst analysis.
##
##      When its finished it returns a list suitable for turning into
##      an array with [array set]. The list is pairs of space names
##      and the best point in that space. Restoring all of these points
##      rebuilds the settings you need to recreate the best results.
##      An empty list means no point in the space (not even the base
##      point) could be compiled properly. An example of a return
##      value would be: {map 0 fit 1} -- which means the best settings
##      were found at map point 0 and fit point 1.
##
##      This function throws an error if something goes wrong
##      along the way.
##
##      The flow always restores your 'base' when it is finished.
proc ::quartus::dse::flows::basic_exploration_with_advanced_pruning {args} {

    set debug_name "::quartus::dse::flows::basic_exploration_with_advanced_pruning()"

    # Import global namespace variables
    global stop_flow
    global global_dse_options
    set stop_flow 0

    # Check to make sure we got a valid designspace object
    set designspace [::quartus::dse::ccl::get_global_option "flow-space"]
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    # Set the result directory
    set result_directory [file join [pwd] dse]
    catch {file delete -force -- $result_directory}
    catch {file mkdir $result_directory}

    # Bring their results into our namespace
    upvar 1 [::quartus::dse::ccl::get_global_option "flow-results"] results
    array set results [list]

    # Set the best point to an empty list
    set best_point [list]

    # If the user wants to stop this flow after time has elapsed register
    # a handler with after that calls stop_flow to touch the stop flag
    # and halt everything in a nice manner.
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] != "#_ignore_#"} {
        ::quartus::dse::ccl::dputs "${debug_name}: Registering a stop-after-time handler for [::quartus::dse::ccl::get_global_option flow-stop-after-time] minutes"
        set after_id [after [expr {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] * 60000}] ::quartus::dse::flows::stop_flow]
    }

    # Enable all the llr/seed/map/fit points
    $designspace enablePoints seed all
    $designspace enablePoints map all
    $designspace enablePoints fit all
    $designspace enablePoints llr all

    # Calculate the number of compiles we'll have to do
    set number_of_points [expr {[$designspace getSizeOfSpace llr] + [$designspace getSizeOfSpace map] + [$designspace getSizeOfSpace fit] + [$designspace getSizeOfSpace seed] - 4}]
    # There are number_of_points + base checkpoints
    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
        ::quartus::dse::gui::update_progress -update-pbar-maximum [expr {$number_of_points + 1}]
    }
    ::quartus::dse::ccl::iputs "Design space contains $number_of_points points"

    # Record the settings for the base compile
    set results(base) [uplevel #0 ::quartus::dse::result #auto [$designspace cget -strProjectName] [$designspace cget -strCmpName]]
    $results(base) addSettings [get_settings_for_base [$designspace cget -strProjectName] [$designspace cget -strCmpName] [$designspace getAllParams seed] [$designspace getAllParams map] [$designspace getAllParams fit] [$designspace getAllParams llr]]
    $results(base) setFingerPrint [$results(base) generateFingerPrint -base $results(base)]
    $results(base) setName "base"
    print_settings_table -title "Settings for base" -results results [$results(base) getAllSettings]

    # Compile base case
    compile_base

    # We store a reference to the current best results.
    # Initialize it to the base results.
    set best_result "base"
    $results(base) setBest 1

    # We also store a reference to the current best point in our best_point
    # structure. It takes the form of a list with the 0 element as the space
    # and the 1 element as the point number. Initialize it to the base point.
    set best_point [list {seed} {0} {map} {0} {fit} {0} {llr} {0}]

    # Print the base results
    print_compile_results_table "Results for base" [$results(base) getAllResults]
    if {[::quartus::dse::ccl::get_global_option "flow-do-combined-analysis"]} {
        print_all_results_table -title "Detailed Cumulative Results" -results results -exclude-failures -mark-best
    }

    # Update GUI
    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
        ::quartus::dse::gui::update_progress -update-pbar
        ::quartus::dse::gui::update_base_result $results(base)
        ::quartus::dse::gui::update_best_result $best_result $results(base)
    }

    # Check and see if we have zero failing paths. This may
    # Reset the counter for our point
    set point_counter 1

    # Check and see if we have zero failing paths. This may
    # be where the user has asked us to stop exploration.
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-zero-failing-paths"]} {
        ::quartus::dse::ccl::dputs "${debug_name}: User asked us to stop after zero failing paths -- checking..."
        set total_failing_paths 0
        foreach {point} [array names results] {
            ::quartus::dse::ccl::dputs "${debug_name}: Checking failing paths at $point"
            set fpaths [lindex [$results($point) getResults -exact "All Failing Paths"] 1]
            if {![regexp -nocase -- {\d+} $fpaths]} {
                    set fpaths 0
            }
            if {[string match -nocase ">0" $fpaths]} {
                # STA is in use -- just make sure at least 1 failing path is counted
                set fpaths 1
            }
            ::quartus::dse::ccl::dputs "${debug_name}: Found $fpaths failing paths at $point"
            set total_failing_paths [expr {$total_failing_paths + $fpaths}]
        }
        ::quartus::dse::ccl::dputs "${debug_name}: Found $total_failing_paths failing paths"
        if { $total_failing_paths == 0 } {
            ::quartus::dse::ccl::iputs "Zero failing paths achieved -- halting exploration"
            stop_flow
        }
    }

    # Find the best logiclock settings first
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing seed space at point 0"
    $designspace disablePoints seed all
    $designspace enablePoints seed 0
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing map space at point 0"
    $designspace disablePoints map all
    $designspace enablePoints map 0
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing fit space at point 0"
    $designspace disablePoints fit all
    $designspace enablePoints fit 0
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all but point 0 in the llr space"
    $designspace enablePoints llr all
    $designspace disablePoints llr 0

    if {!$stop_flow && [$designspace getSizeOfSpace llr] > 0} {

        set global_dse_options(flow-best-result) best_result
        set global_dse_options(flow-best-point) best_point
        set global_dse_options(flow-point-counter) point_counter
        set global_dse_options(flow-number-of-points) $number_of_points
        set global_dse_options(flow-skip-points) [list "0,0,0,0"]

        # Explore enabled design space
        explore_space
    }

    # Make a hash of the best settings at this point
    array set best_array $best_point

    # Enable the best point only in the map space
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing llr at the best llr point: $best_array(llr)"
    $designspace disablePoints llr all
    $designspace enablePoints llr $best_array(llr)

    # Find the best fit settings
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all but point 0 in the fit space"
    $designspace enablePoints fit all
    $designspace disablePoints fit 0

    if {!$stop_flow && [$designspace getSizeOfSpace fit] > 0} {

        set global_dse_options(flow-best-result) best_result
        set global_dse_options(flow-best-point) best_point
        set global_dse_options(flow-point-counter) point_counter
        set global_dse_options(flow-number-of-points) $number_of_points
        set global_dse_options(flow-skip-points) [list "0,0,0,0"]

        # Explore enabled design space
        explore_space
    }

    # Make a hash of the best settings at this point
    array set best_array $best_point

    # Enable the best point only in the map space
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing fit at the best fit point: $best_array(fit)"
    $designspace disablePoints fit all
    $designspace enablePoints fit $best_array(fit)

    # Find the best map settings
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all but point 0 in the map space"
    $designspace enablePoints map all
    $designspace disablePoints map 0

    if {!$stop_flow && [$designspace getSizeOfSpace map] > 0} {

        set global_dse_options(flow-best-result) best_result
        set global_dse_options(flow-best-point) best_point
        set global_dse_options(flow-point-counter) point_counter
        set global_dse_options(flow-number-of-points) $number_of_points
        set global_dse_options(flow-skip-points) [list "0,0,0,0"]

        # Explore enabled design space
        explore_space
    }

    # Make a hash of the best settings at this point
    catch {array unset best_array}
    array set best_array $best_point

    # Enable the best point only in the map space
    ::quartus::dse::ccl::dputs "${debug_name}: Fixing map at the best map point: $best_array(map)"
    $designspace disablePoints map all
    $designspace enablePoints map $best_array(map)

    # Find the best seed
    ::quartus::dse::ccl::dputs "${debug_name}: Enabling all but point 0 in the seed space"
    $designspace enablePoints seed all
    $designspace disablePoints seed 0

    if {!$stop_flow && [$designspace getSizeOfSpace seed] > 0} {

        set global_dse_options(flow-best-result) best_result
        set global_dse_options(flow-best-point) best_point
        set global_dse_options(flow-point-counter) point_counter
        set global_dse_options(flow-number-of-points) $number_of_points
        set global_dse_options(flow-skip-points) [list "0,0,0,0"]

        # Explore enabled design space
        explore_space
    }

    # Clean up: Remove after_time if user had set a stop-after-time value
    if {[::quartus::dse::ccl::get_global_option "flow-stop-after-time"] != "#_ignore_#" && [info exists after_id]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Unregistering stop-after-time call"
        catch {after cancel $after_id}
    }

    # Try and restore the base results if we were stopped prematurely
    if {$stop_flow} {
        if {![::quartus::dse::ccl::get_global_option "flow-hardcopy"]} {
            ::quartus::dse::ccl::iputs "Restoring base settings at end of flow"
            catch {$results(base) restoreRevision -delete [::quartus::dse::ccl::get_global_option "flow-temp-revision"]}
        }
    }

    # Print the flow summary
    generate_final_flow_report -space $designspace -results results -signature -best-worst-function [::quartus::dse::ccl::get_global_option "flow-best-worst-function"]

    ::quartus::dse::ccl::dputs "${debug_name}: Returning: $best_result"
    return $best_point
}


#############################################################################
##  Procedure:  create_temporary_revision_name
##
##  Arguments:
##		project
##			The project to create the unique revision name for.
##
##		name
##			Base to use for the name of the revision.
##
##  Description:
##		Creates a temporary revision name that DSE can use to store
##		it's settings during exploration. This name will not collide
##		with any existing revision names in the project. Returns a
##		unique revision name
proc ::quartus::dse::flows::create_temporary_revision_name {project name} {

    set debug_name "::quartus::dse::flows::create_temporary_revision_name()"

	if {![project_exists $project]} {
		return -code error "Project $project does not exist"
	}
	set project_revisions [get_project_revisions $project]
	set temp_revision $name
	set ind 1
	while {[lsearch -exact $project_revisions $temp_revision] != -1} {
		incr ind
		set temp_revision "${temp_revision}_${ind}"
	}
	::quartus::dse::ccl::dputs "${debug_name}: Created temporary revision name $temp_revision for $project"

	return $temp_revision
}


#############################################################################
##  Procedure:  generate_final_flow_report
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -space <designspace_object>
##              Required. This is a pass-by-reference reference
##              to your design space object that holds the points
##              you have already explored. The points you want
##              included in the final statistical analysis reported
##              should be enabled. The points you want excluded
##              should be disabled.
##
##          -results <array_name>
##              Required. This is a pass-by-reference reference to
##              an array where all your result objects are
##              stored. There must be a "base" result object
##              in the array as well as any number of integer result
##              objects.
##
##          -signature
##              Optional. Generate a signature report table using
##              the supplied results.
##
##  Description:
##      Prints a flow report section to the screen and dse.rpt
##      file for you. Alerts the GUI to the final best result if
##      the GUI is enabled.
proc ::quartus::dse::flows::generate_final_flow_report {args} {

    set debug_name "::quartus::dse::flows::generate_final_flow_report()"

    # Import global namespace variables
    global stop_flow
    set stop_flow 0

    set best_point [list]

    # Command line options to this function we require
    set         tlist       "space.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The designspace object explored"
    lappend function_opts $tlist

    set         tlist       "results.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The results array"
    lappend function_opts $tlist

    set         tlist       "signature"
    lappend     tlist       0
    lappend     tlist       "Print a signature table"
    lappend function_opts $tlist

    set         tlist       "best-worst-function.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The function to use to choose between base-fast and base-slow results"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Check to make sure we got a valid designspace object
    set designspace $optshash(space)
    if {![$designspace isa ::quartus::dse::designspace]} {
        return -code error "${debug_name}: Reference passed with -space option is not a designspace object"
    }

    # Bring their results into our namespace
    upvar 1 $optshash(results) results

    # Find the best settings
    set best_result "base"
    foreach r [array names results] {
        if {$results($r) != "" && [$results($r) isa ::quartus::dse::result]} {
            if {[$results($r) isBest]} {
                set best_result $r
            }
        }
    }

    # str holds all the stuff we'll eventually print to the screen
    set str "\n"
    append str "+-----------------------------------------------------------------------------+\n"
    append str "| Flow Summary                                                                |\n"
    append str "+-----------------------------------------------------------------------------+"
    ::quartus::dse::ccl::bputs "$str"

    # Print cumulative results table, include a dump to a CSV
    # file if we can open the file otherwise just screen dump
    if {[catch {open [file join dse "results.csv"] {WRONLY CREAT TRUNC}} csvfh]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Unable to open dse/result/results.csv -- no CSV data dumped for this run"
        print_all_results_table -title "Detailed Results" -results results -mark-best
    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: CSV results will be dumped to dse/result/results.csv"
        # Add a timestamp as the first line in the CSV file
        puts $csvfh "Project: [$designspace cget -strProjectName]"
        puts $csvfh "Revision: [$designspace cget -strCmpName]"
        puts $csvfh "Flow Start Date: [regsub -all -- {,} $::quartus::dse::ccl::init_date_and_time " "]"
        puts $csvfh "Flow End Date: [regsub -all -- {,} [clock format [clock scan now]] " "]"
        puts $csvfh ""
        print_all_results_table -title "Detailed Results" -results results -mark-best -generate-csv -csv-channel $csvfh
        close $csvfh
    }

    # Print base results - adjust for combined analysis flow
    if {[info exists results(base)]} {
        print_compile_results_table "Results for Base" [$results(base) getAllResults]
    } else {
        ::quartus::dse::ccl::wputs "Missing results for base"
    }

    # Only print "best" stuff if best != base
    if {$best_result != "base"} {
        ::quartus::dse::ccl::iputs "Best results were found at point $best_result"

        # Print best settings
        print_settings_table -title "Settings for Point $best_result (Best)" -results results -relative-to-base [$results($best_result) getAllSettings]

        # Print best results
        print_compile_results_table "Results for Point $best_result (Best)" [$results($best_result) getAllResults]
    } else {
        ::quartus::dse::ccl::iputs "Best results were your $best_result results"
    }

    # If the user wanted a signature table printed, do it
    if {$optshash(signature)} {
        array set compilegroups [::quartus::dse::result::get_all_compile_groups -results results]

        print_signature_table -title "Circuit Signature Report" -results results -compilegroups [array get compilegroups] -best-worst-function $optshash(best-worst-function)

        print_compile_groups_table -title "Circuit Signature Compile Groups" -results results -compilegroups [array get compilegroups] -best-worst-function $optshash(best-worst-function)
    }

    return 1
}


#############################################################################
##  Procedure:  _status_callback
##
##  Arguments:
##      jobid
##
##      networkid
##
##      hostname
##
##      remotecmd
##
##      status
##
##      args
##
##  Description:
##      Registered callback function for qMasterObj -statusCallback option.
##      For more information see the ::quartus::qMaster documentation.
proc ::quartus::dse::flows::_status_callback {args} {

    set debug_name "::quartus::dse::flows::_status_callback()"

    global global_dse_options

    # For testing purposes only print out the contents of global_dse_options
    ::quartus::dse::ccl::dputs "${debug_name}: Check the contents of global_dse_options:"
    foreach {key} [array names global_dse_options] {
        ::quartus::dse::ccl::dputs "${debug_name}:    $key = $global_dse_options($key)"
    }

    catch {set jobid [lindex $args 0]}
    catch {set networkid [lindex $args 1]}
    catch {set hostname [lindex $args 2]}
    catch {set remotecmd [lindex $args 3]}
    catch {set status [lindex $args 4]}
    catch {set reason [lindex $args 5]}
    catch {set therest [lrange $args 6 end]}

    catch {::quartus::dse::ccl::dputs "${debug_name}: args      = $args"}
    catch {::quartus::dse::ccl::dputs "${debug_name}: jobid     = $jobid"}
    catch {::quartus::dse::ccl::dputs "${debug_name}: networkid = $networkid"}
    catch {::quartus::dse::ccl::dputs "${debug_name}: hostname  = $hostname"}
    catch {::quartus::dse::ccl::dputs "${debug_name}: remotecmd = $remotecmd"}
    catch {::quartus::dse::ccl::dputs "${debug_name}: status    = $status"}

    set job "Point $jobid"

    switch -- [string tolower $status] {
        start {
            ::quartus::dse::ccl::iputs "$job is being started on client $hostname"
        }

        download {
            ::quartus::dse::ccl::iputs "$job is downloading results files from client $hostname"
        }

        run {
            ::quartus::dse::ccl::iputs "$job is running on client $hostname"
        }

        upload {
            ::quartus::dse::ccl::iputs "$job is uploading files to client $hostname"
        }

        stop {
            # Count this point as being done in the GUI by pushing
            # the progress bar ahead by 1 unit.
            if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                ::quartus::dse::gui::update_progress -update-pbar
            }
            ::quartus::dse::ccl::iputs "$job has been stopped on client $hostname"
        }

        done {
            # Count this point as being done in the GUI by pushing
            # the progress bar ahead by 1 unit.
            if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                ::quartus::dse::gui::update_progress -update-pbar
            }
            ::quartus::dse::ccl::iputs "$job has finished"
            # Try and report some results to the user even if they
            # aren't coming back in a linear fashion.
            array set results [list]
            foreach f [glob -nocomplain -directory [file join [pwd] dse] -- {*-result.xml}]  {
                # Don't load a best-result.xml file
                if {[regexp -nocase -- {best-result\.xml} $f]} {
                    continue
                }
                if {[regexp -nocase -- {([a-zA-Z0-9\-]+)-result.xml} $f => p]} {
                    # Load the results
                    if {[catch {open $f} xmlfh]} {
                        #::quartus::dse::ccl::dputs "${debug_name}: Warning: Could not open results found for ${p}: $xmlfh"
                        continue
                    }
                    ::quartus::dse::ccl::dputs "${debug_name}: Loading results for point $p"
                    set results($p) [uplevel #0 ::quartus::dse::result #auto "unknown" "unknown"]
                    if {[catch {$results($p) loadXML $xmlfh}]} {
                        # XML file is probably being written
                        # back to disk -- just skip this point
                        array unset results $p
                    }
                    close $xmlfh
                }
            }

            # Only update results if we actually have results
            if {[llength [array names results]] > 0} {

                # Start out by assuming we have no best results to show
                set best_result "#_unknown_#"

                # This is a list of potential points to compare
                # for best/worst analysis. These are all the points
                # that were compiled already on remote clients, so
                # they should have valid results to compare against.
                set points_to_compare [list]
                foreach p [array names results] {
                    # Skip points that didn't compile and any point who's index
                    # matches (base|\d+)-(\d+) because this is a model we don't
                    # look at when doing DSE best/worst comparisons.
                    if {[$results($p) isCompiled] && ![regexp -nocase -- {(?:base|\d+)-(?:\d+)} $p]} {
                        ::quartus::dse::ccl::dputs "${debug_name}: Found point $p with compiled results"
                        lappend points_to_compare $p
                    }
                }

                # OLD START

                # Use the base results as a starting point for our best/worst
                # comparison. If we don't have a base result pick the first
                # item on the list of points_to_compare.
                if {[lsearch -regexp $points_to_compare {^base$}]} {
                    set best_result "base"
                } else {
                    # There are no base results so we need to make one of our
                    # points_to_compare the current best setting. We may not
                    # actually have any points to compare at this time so be
                    # carefully about trying to shift things off the list.
                    if {[llength $points_to_compare] > 0} {
                        set best_result [lindex $points_to_compare 0]
                        set points_to_compare [lrange $points_to_compare 1 end]
                    }
                }
                catch {$results($best_result) setBest 1}

                if {$best_result != "#_unknown_#"} {
                    foreach p $points_to_compare {
                        # Call helper function to do best/worst analysis
                        ::quartus::dse::ccl::dputs "${debug_name}: Doing best/worst analysis with $global_dse_options(flow-best-worst-function)"
                        set is_best [$global_dse_options(flow-best-worst-function) -best $results($best_result) -new $results($p) -slack-column [list $global_dse_options(flow-slack-column)]]

                        # If we found a new best result, memorize it
                        if {$is_best} {
                            ::quartus::dse::ccl::iputs "Found best results at point $p"
                            $results($best_result) setBest 0
                            set best_result $p
                            $results($best_result) setBest 1
                            if {[file exists [file join dse ${p}.qar]]} {
                                # Delete an existing best.qar file
                                if {[file exists [file join dse best.qar]]} {
                                    catch {file delete -force -- [file join dse best.qar]}
                                }
                                catch {file copy -force -- [file join dse ${p}.qar] [file join dse best.qar]}
                            }
                            catch {file copy -force -- [file join dse ${p}-result.xml] [file join dse best-result.xml]}
                        } else {
							# This point isn't the best results. If the user
							# archive all the compiles we need to delete this
							# point's qar file. But don't delete base.qar.
							if {![regexp -- $p {^base$}] && [file exists [file join dse ${p}.qar]] && !$global_dse_options(flow-archive)} {
								catch {file delete -force -- [file join dse ${p}.qar]}
							}
						}
                    }

                    # Update GUI
                    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                        catch {::quartus::dse::gui::update_base_result $results(base)}
                        catch {::quartus::dse::gui::update_best_result $best_result $results($best_result)}
                    }
                }

                # Check and see if we have zero failing paths. This may
                # be where the user has asked us to stop exploration.
                # We have to check every single result we got back that
                # was compiled in order to make this call.
                if {$global_dse_options(flow-stop-after-zero-failing-paths)} {
                    ::quartus::dse::ccl::dputs "${debug_name}: User asked us to stop after zero failing paths"
                    foreach p $points_to_compare {
                        set total_failing_paths 0
                        set result_list [list $p "${p}-1" "${p}-2"]
                        foreach {point} $result_list {
                            if {[info exists results($point)]} {
                                ::quartus::dse::ccl::dputs "${debug_name}: Checking failing paths at $point"
                                set fpaths [lindex [$results($point) getResults -exact "All Failing Paths"] 1]
                                if {![regexp -nocase -- {^\d+$} $fpaths]} {
                                    set fpaths 0
                                }
                                if {[string match -nocase ">0" $fpaths]} {
                                    # STA is in use -- just make sure at least 1 failing path is counted
                                    set fpaths 1
                                }
                                ::quartus::dse::ccl::dputs "${debug_name}: Found $fpaths failing paths at $point"
                                set total_failing_paths [expr {$total_failing_paths + $fpaths}]
                            }
                        }
                        ::quartus::dse::ccl::dputs "${debug_name}: Found $total_failing_paths failing paths"
                        if { $total_failing_paths == 0 } {
                            ::quartus::dse::ccl::iputs "Zero failing paths achieved -- halting exploration"
                            stop_flow
                        }
                    }
                }

                # Print cumulative results table, include a dump to a CSV
                # file if we can open the file otherwise just screen dump
                if {[catch {open [file join dse "results.csv"] {WRONLY CREAT TRUNC}} csvfh]} {
                    ::quartus::dse::ccl::dputs "${debug_name}: Unable to open dse/result/results.csv -- no CSV data dumped for this run"
                    print_all_results_table -title "Detailed Cumulative Results" -results results -exclude-failures -ignore-no-base
                } else {
                    ::quartus::dse::ccl::dputs "${debug_name}: CSV results will be dumped to dse/result/results.csv"
                    # Add a timestamp as the first line in the CSV file
                    set ind [lindex [array names results] 0]
                    puts $csvfh "Project: [$results($ind) cget -strProjectName]"
                    puts $csvfh "Revision: [$results($ind) cget -strCmpName]"
                    puts $csvfh "Flow Start Date: [regsub -all -- {,} $::quartus::dse::ccl::init_date_and_time " "]"
                    puts $csvfh "Flow End Date: [regsub -all -- {,} [clock format [clock scan now]] " "]"
                    puts $csvfh ""
                    print_all_results_table -title "Detailed Cumulative Results" -results results -exclude-failures -ignore-no-base -generate-csv -csv-channel $csvfh
                    close $csvfh
                }
            }

            array set results [list]
        }

        fail {
            switch -- $reason {
                slaveDown {
                    ::quartus::dse::ccl::wputs "$job failed to run: Slave $hostname is not responding"
                }
                slaveBusy {
                    ::quartus::dse::ccl::wputs "$job failed to run: Slave $hostname is busy"
                }
                invalidVer {
		    set quartusVer $::quartus(version)
		    set slaveVer [qMasterObj getSlaveQuartusVer $hostname]
                    ::quartus::dse::ccl::wputs "$job failed to run: Slave $hostname is running a different version of Quartus II\n\
						Master is running $quartusVer\n\
						Slave $hostname is running $slaveVer"
                }
                remoteCmd {
                    ::quartus::dse::ccl::wputs "$job failed to run: Slave $hostname could not execute the remote command"
                }
                noResultFile {
                    ::quartus::dse::ccl::wputs "$job failed to run: No result files were returned from slave $hostname"
                }
                failLimit {
                    ::quartus::dse::ccl::eputs "$job failed to run: Failure limit for job was reached"
                    # Count this point as being done in the GUI by pushing
                    # the progress bar ahead by 1 unit.
                    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                        ::quartus::dse::gui::update_progress -update-pbar
                    }
                }
                noAvailSlaves {
                    ::quartus::dse::ccl::eputs "$job failed to run: Master could not find any slaves"
                    # Count this point as being done in the GUI by pushing
                    # the progress bar ahead by 1 unit.
                    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                        ::quartus::dse::gui::update_progress -update-pbar
                    }
                }
                noAvailLSF {
                    ::quartus::dse::ccl::eputs "$job failed to run: Master could not find any LSF resources"
                    # Count this point as being done in the GUI by pushing
                    # the progress bar ahead by 1 unit.
                    if {[::quartus::dse::ccl::get_global_option "dse-gui"]} {
                        ::quartus::dse::gui::update_progress -update-pbar
                    }
                }
                ftpTimeout {
                    ::quartus::dse::ccl::wputs "$job failed to run: FTP connection with $hostname timed out"
                }
                ftpTerminated {
                    ::quartus::dse::ccl::wputs "$job failed to run: FTP connection with $hostname was terminated"
                }
                ftpUnexpected {
                    ::quartus::dse::ccl::wputs "$job failed to run: There was an unexpected FTP connection error with $hostname"
                }
                ftpError {
                    ::quartus::dse::ccl::wputs "$job failed to run: There was an FTP connection error with $hostname"
                }
                ftpConnect {
                    ::quartus::dse::ccl::wputs "$job failed to run: FTP connection with $hostname failed"
                }
                default {
                    ::quartus::dse::ccl::wputs "$job failed to run: $reason"
                }
            }
        }

        default {
            ::quartus::dse::ccl::dputs "${debug_name}: Unrecognized status flag: $status"
        }
    }

    return 1
}


#############################################################################
##  Procedure:  _output_callback
##
##  Arguments:
##      severity
##
##      msg
##
##  Description:
##      Registered callback function for qMasterObj -outputCallback option.
##      For more information see the ::quartus::qMaster documentation.
proc ::quartus::dse::flows::_output_callback {args} {

    set debug_name "::quartus::dse::flows::_output_callback()"

    catch {set severity [lindex $args 0]}
    catch {set msg [join [lrange $args 1 end]]}

    switch -- $severity {
        Info {
            ::quartus::dse::ccl::iputs "$msg"
        }
        Warning {
            ::quartus::dse::ccl::wputs "$msg"
        }
        Error {
            ::quartus::dse::ccl::eputs "$msg"
        }
    }

    return 1
}


#############################################################################
##  Procedure:  can_skip_analysis
##
##  Arguments:
##      project
##          - name of the project we want to consider skipping
##            analysis & elaboration step for
##
##      revision
##          - name of the revision we want to consider skipping
##           analysis & elaborbation step for
##
##  Description:
##      Analyze the situation and lets you know if you can skip the
##      analysis and elaboration step for a revision. In order to
##      skip this step a design must have a table with the name:
##
##          Analysis & Synthesis||Analysis & Elaboration Summary
##              -or-
##          Analysis & Synthesis||Analysis & Synthesis Summary
##
##      And the panel must report that this step was succesful.
##      The timestamp on the $revision.qsf file must also be
##      older than or the same as the timestamp on the
##      $revision.map.rpt file. Otherwise the user may have
##      changed settings in their design since the last time
##      A&S or A&E was run.
##
##      If these criteria are met the function returns true
##      indicating that you could skip a analysis of this
##      design if you so desire. Otherwise it returns false and
##      you should really consider analyzing this design before
##      trying to use it.
proc ::quartus::dse::flows::can_skip_analysis {project revision} {

    set debug_name "::quartus::dse::flows::can_skip_analysis()"

    set found_chg_file 0
    set retval 0

    #
    # First check and see if perhaps something has changed in the project
    # that warrants a new call to the mapper. Smart action can figure this
    # out for us, we just need to query if the file exists or not.
    #
	set smart [::quartus::dse::ccl::smart_action $project $revision]
	::quartus::dse::ccl::dputs "${debug_name}: Got smart action : $smart"

	switch -glob -- $smart {
		SOURCE 	{ set retval 0 }
		MLS 	{ set retval 0 }
		FIT* 	{ set retval 1 }
		DAT 	{ set retval 1 }
		TAN 	{ set retval 1 }
		ASM 	{ set retval 1 }
		DRC 	{ set retval 1 }
		EDA 	{ set retval 1 }
		DONE 	{ set retval 1 }
		default {
			set retval 0
		}
	}

	::quartus::dse::ccl::dputs "${debug_name}: Return $retval"
    return $retval
}

#############################################################################
##  Procedure:  can_skip_compile
##
##  Arguments:
##      project
##          - name of the project we want to consider skipping
##            full compile step for
##
##      revision
##          - name of the revision we want to consider skipping
##           full compile step for
##
##  Description:
##      Analyze the situation and lets you know if you can skip the
##      full compile step for a revision. In order to skip this step
##      a design must have a table with the name:
##
##          Fitter||Fitter Summary
##
##      And the panel must report that this step was succesful.
##      The timestamp on the $revision.qsf file must also be
##      older than or the same as the timestamp on the
##      $revision.tan.rpt file. Otherwise the user may have
##      changed settings in their design since the last time
##      fitting was run.
##
##      If these criteria are met the function returns true
##      indicating that you could skip a full compile of this
##      design if you so desire. Otherwise it returns false and
##      you should really consider compiling this design before
##      trying to use it.
proc ::quartus::dse::flows::can_skip_compile {project revision} {

    set debug_name "::quartus::dse::flows::can_skip_compile()"

    set retval 0

    #
    # First check and see if perhaps something has changed in the project
    # that warrants a new call to the fitter and tan. Smart action can figure
    # this out for us, we just need to query if the file exists or not.
    #
	set smart [::quartus::dse::ccl::smart_action $project $revision]
	::quartus::dse::ccl::dputs "${debug_name}: Got smart action : $smart"

	switch -glob -- $smart {
		SOURCE 	{ set retval 0 }
		MLS 	{ set retval 0 }
		FIT* 	{ set retval 0 }
		DAT 	{ set retval 0 }
		TAN 	{ set retval 0 }
		ASM 	{ set retval 1 }
		DRC 	{ set retval 1 }
		EDA 	{ set retval 1 }
		DONE 	{ set retval 1 }
		default {
			set retval 0
		}
	}

	::quartus::dse::ccl::dputs "${debug_name}: Return $retval"
    return $retval
}
