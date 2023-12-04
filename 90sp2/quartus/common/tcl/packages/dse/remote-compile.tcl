
#############################################################################
##  remote-compile.tcl
##
##  Design Space Explorer remote compilation script for parallel and
##  distributed exploration flows.
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
package require xml
package require ::quartus::dse::result
package require ::quartus::dse::ccl
package require ::quartus::flow
package require ::quartus::misc
package require ::quartus::project


#############################################################################
##  Export Functions & Declare Global Namespace Variables


#############################################################################
##  Command Line Options for Script
set         tlist       "run-power.arg"
lappend     tlist       0
lappend     tlist       "Run Quartus II PowerPlay Power Analyzer as part of compile"
lappend function_opts $tlist

set         tlist       "hardcopy.arg"
lappend     tlist       0
lappend     tlist       "Run Quartus II Hardcopy flow"
lappend function_opts $tlist

set         tlist       "save-rpt-files.arg"
lappend     tlist       0
lappend     tlist       "Save the rpt files even if the compile succeeds"
lappend function_opts $tlist

set         tlist       "point.arg"
lappend     tlist       "#_required_#"
lappend     tlist       "DSE point we're compiling with this remote call"
lappend function_opts $tlist

set         tlist       "project.arg"
lappend     tlist       "#_required_#"
lappend     tlist       "Name of project we're compiling with this remote call"
lappend function_opts $tlist

set         tlist       "revision.arg"
lappend     tlist       "#_required_#"
lappend     tlist       "Name of revision we're compiling with this remote call"
lappend function_opts $tlist

set         tlist       "lower-priority.arg"
lappend     tlist       0
lappend     tlist       "Lower the priority of compiles"
lappend function_opts $tlist

set         tlist       "do-combined-analysis.arg"
lappend     tlist       0
lappend     tlist       "True if we are doing a combined analysis and need to return two result objects"
lappend function_opts $tlist

set         tlist       "timequest.arg"
lappend     tlist       0
lappend     tlist       "True if TimeQuest is in use. Otherwise false."
lappend function_opts $tlist

set         tlist       "report-all-usage.arg"
lappend     tlist       0
lappend     tlist       "True if we should report all resource usage. Otherwise false."
lappend function_opts $tlist

array set optshash [cmdline::getFunctionOptions ::quartus(args) $function_opts]

# Check that we got all our options
foreach opt [array names optshash] {
    post_message -type info "Check option $opt = $optshash($opt)"
    if {$optshash($opt) == "#_required_#"} {
        post_message -type error "Missing required option: -$opt"
        exit 1
    }
}

# Create a ::dse::result object that holds the settings
post_message "Creating result object for setting and data storage"
set resultobj [uplevel #0 ::quartus::dse::result #auto $optshash(project) $optshash(revision)]

# Load the XML for this result that contains all the settings.
# Skip the load if the point is "base".
set xmlfile "$optshash(point)-result.xml"
if {![string equal $optshash(point) "base"]} {
    if {![file exists $xmlfile]} {
        post_message -type error "Missing required XML file: $xmlfile"
        exit 1
    }
    post_message "Loading result settings from $xmlfile"
    set xmlfh [open $xmlfile "r"]
    $resultobj loadXML $xmlfh
    close $xmlfh
}

# Make sure we have a base.qar file
if {![file exists base.qar]} {
    post_message -type error "Missing required Quartus II Archive file: base.qar"
    exit 1
}

post_message "Unarchiving base.qar"
project_restore -overwrite -update_included_file_info "base"
# Skip this part if the point is "base"
if {![string equal $optshash(point) "base"]} {
    # We can always use makeHardCopyRevision to apply the settings
    # to the project because we don't have to concern ourselves
    # with restoring the base results at the end since this compile
    # is being done on a unique instance of the project.
    post_message "Applying settings from result object to project"
    $resultobj makeHardCopyRevision
}
# Delete any existing .rpt files before we start
catch {file delete -force -- [glob -nocomplain -- {*.rpt}]}
post_message "Opening project $optshash(project) with revision $optshash(revision)"
project_open -force -revision $optshash(revision) $optshash(project)

# Remote compiles should turn off Quartus' internal parallelization in
# case we're parallelizing this DSE run on the local machine.
set max_procs [get_global_assignment -name NUM_PARALLEL_PROCESSORS]
set_global_assignment -name NUM_PARALLEL_PROCESSORS 1

post_message "Compling project"
set save_rpt_files $optshash(save-rpt-files)
if {[catch {execute_flow -compile} result]} {
    post_message -type error "Error compiling project"
    post_message -type error $result
    set save_rpt_files 1
} else {
    post_message "Compilation successful"
}
if {$optshash(run-power)} {
    post_message "Running PowerPlay power analyzer on project"
    if {[catch {execute_module -tool pow} result]} {
        post_message -type error "Error running quartus_pow on project"
        post_message -type error $result
        set save_rpt_files 1
    } else {
        post_message "Power analysis successful"
    }
}

# Return NUM_PARALLEL_PROCESSORS back to the original value. Don't let
# errors here interrupt the script.
if {[string length $max_procs] == 0} {
    # It wasn't set to begin with so unset it...
    catch {set_global_assignment -remove -name NUM_PARALLEL_PROCESSORS}
} else {
    catch {set_global_assignment -name NUM_PARALLEL_PROCESSORS $max_procs}
}

post_message "Achiving project as $optshash(point).qar"
project_archive -include_outputs -overwrite -use_file_subsets [list rpt out] $optshash(point).qar
project_close

# Should we save the report files?
if {$save_rpt_files} {
    set repat "$optshash(revision)\\.(\[a-z\]+)(\\.rpt.*)"
    foreach {f} [lsort [glob -nocomplain -- {*}]] {
        if {[regexp -nocase -- $repat $f => rtype ext]} {
            # Skip the .dse.rpt file
            if {![string equal -nocase $rtype "dse"]} {
                set newf "$optshash(revision).$optshash(point).${rtype}${ext}"
                catch {file copy -force -- $f $newf}
                lappend flist $newf
            }
        }
    }
    if {[llength $flist] > 0} {
        post_message -type warning "Output from failed compilation has been saved as:"
        foreach f $flist {
            post_message -type warning "   $f"
        }
    } else {
        post_message -type warning "No output from failed compilation was found"
    }
}

# Save the results back to the XML file
post_message "Parsing results from project"
if {$optshash(do-combined-analysis)} {
    set model_list [list]
    if {$optshash(timequest)} {
        # Extract the results from the project
        post_message "Extracting results from STA"
        ::quartus::dse::result::extract_results_from_sta -project "$optshash(project)" -revision "$optshash(revision)" -point "$optshash(point)"
        # Figure out what models are in use for this TimeQuest compile.
        set staargs [list "--script" "\"[file join $::quartus(tclpath) packages dse sta-helper.tcl]\"" "-project" "\"$optshash(project)\"" "-revision" "\"$optshash(revision)\"" "-command" "get_available_operating_conditions"]
        set input "\"[file join $::quartus(binpath) quartus_sta]\" [join $staargs]"
        set output "sta-helper.out"
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
    } else {
        set model_list [list "slow" "fast"]
    }
    post_message "Project is using the following models: $model_list"
    array set results [list]
    if {$optshash(point) == 0} {
        set point "base"
    } else {
        set point $optshash(point)
    }
    set results($point) $resultobj
    # Duplicate the existing result object
    for {set i 1} {$i < [llength $model_list]} {incr i} {
        set key "${point}-${i}"
        post_message "Duplicating $resultobj -> $key"
        set results(${point}-${i}) [$resultobj duplicate]
    }
    for {set i 0} {$i < [llength $model_list]} {incr i} {
        if { $i == 0 } {
            set key $point
        } else {
            set key "${point}-${i}"
        }
        set model [lindex $model_list $i]
        $results($key) setName "${point}-$model"
        post_message "Recording results for point $point ([$results($key) getName])"
        if {![$results($key) getResultsFromProject -report-all-resource-usage $optshash(report-all-usage) -model $model -point $optshash(point)]} {
            post_message -type warning "Unable to parse results for point $point ([$results($key) getName])"
        } else {
            $results($key) setCompiled 1
        }
        # Make sure dse/result exists
        set xmlfilename "${key}-result.xml"
        if {![catch {open ${xmlfilename} {WRONLY CREAT TRUNC}} xmlfh]} {
            post_message "Dumping results for point $point ([$results($key) getName]) to: ${xmlfilename}"
            $results($key) dumpXML $xmlfh
            close $xmlfh
        }
    }
} else {
    $resultobj getResultsFromProject -report-all-resource-usage $optshash(report-all-usage) -point $optshash(point)
    $resultobj setCompiled 1
    post_message "Dumping parsed results back to $xmlfile"
    set xmlfh [open $xmlfile {WRONLY CREAT TRUNC}]
    $resultobj dumpXML $xmlfh
    close $xmlfh
}

post_message "Done"
exit 0
