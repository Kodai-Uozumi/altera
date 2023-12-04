
#############################################################################
##  ccl-lib.tcl
##
##  A common code library for DSE.
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

package provide ::quartus::dse::ccl 1.0

#############################################################################
##  Additional Packages Required
package require math
package require report
package require struct::matrix
package	require ::quartus::flow
package require ::quartus::misc
package require ::quartus::dse::gui
load_package project

#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse::ccl {
    namespace export init
    namespace export dse_exec
    namespace export bputs
    namespace export dputs
    namespace export iputs
    namespace export wputs
    namespace export eputs
    namespace export reverseList
    namespace export archive
    namespace export unarchive
    namespace export stop_tool
    namespace export quartus_map
    namespace export quartus_fit
    namespace export quartus_tan
    namespace export qslave
    namespace export pgain
    namespace export absgain
    namespace export time_d
    namespace export time_h
    namespace export time_m
    namespace export time_s
    namespace export elapsed_time_string
    namespace export get_seed_list
    namespace export get_global_option
    namespace export save_state_to_disk
    namespace export read_state_from_disk
    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable debugmsgs_count 0
    variable infomsgs  1
    variable infomsgs_count 0
    variable warningmsgs 1
    variable warningmsgs_count 0
    variable errormsgs 1
    variable errormsgs_count 0
    variable putsfname "#unknown"
    variable init_date_and_time "#unknown"
}


#############################################################################
##  Procedure:  init
##
##  Arguments:
##      _project
##          Name of the project
##
##      _cmp
##          Name of the compiler settings
##
##      _fname
##          Output of the internal *puts commands for debug, info and
##          warning messages will go to _file. If you don't
##          pass a file name the library does all it's putting
##          to stdout.
##
##  Description:
##      Does basic initialization for everything else in this library.
##      Should be called by any DSE as early as possible so that calls
##      *puts are logged to a file.
proc ::quartus::dse::ccl::init {_project _cmp {_fname "#unknown"}} {

    global global_dse_options
    variable putsfname $_fname
    variable debugmsgs_count
    variable infomsgs_count
    variable warningmsgs_count
    variable errormsgs_count

    if {$global_dse_options(dse-debug)} {
        #::quartus::project::set_ini_var -name debug_msg on
    }

    # Reset message counters
    set debugmsgs_count 0
    set infomsgs_count 0
    set warningmsgs_count 0
    set errormsgs_count 0


    set timestamp [clock format [clock scan now]]
    msg_vdebug "### Started: $timestamp ###\n"
    variable init_date_and_time $timestamp

    catch {file delete -force -- $putsfname}

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

    # Write header information in the output file -- build up a string
    # and then call bputs on the whole string so we don't open and
    # close the file multiple times
    set str "\n"
    append str "Design Space Explorer Report\n"
    append str "-------------------------------------------------------------------------------\n"
    append str "\n"

    ::struct::matrix mtx
    mtx add columns 2
    mtx add row [list "Start Date & Time" $init_date_and_time]
    mtx add row [list "Working Directory" [pwd]]
    mtx add row [list "Project Name" $_project]
    mtx add row [list "Revision Name" $_cmp]
    mtx add row [list "Quartus II Version" $::quartus(version)]
    append str "+------------------------------------------------------------------------+\n"
    append str "| Report Information                                                     |\n"
    append str "+------------------------------------------------------------------------+\n"
    ::report::report rpt 2 style simpletable
    rpt pad 0 both
    rpt pad 1 both
	append str [mtx format 2string rpt]
    rpt destroy
    mtx destroy
    append str "\n"

    append str "Table of Contents\n"
    append str "    Report Information\n"
    append str "    Legal Notice\n"
    append str "    Flow Messages\n"
    append str "    Flow Summary\n"
    append str "\n"

    append str "+-----------------------------------------------------------------------------+\n"
    append str "| Legal Notice                                                                |\n"
    append str "+-----------------------------------------------------------------------------+\n"
    append str "$::quartus(copyright). All rights reserved.\n"
    append str "Any  megafunction  design,  and related netlist (encrypted  or  decrypted),\n"
    append str "support information,  device programming or simulation file,  and any other\n"
    append str "associated  documentation or information  provided by  Altera  or a partner\n"
    append str "under  Altera's   Megafunction   Partnership   Program  may  be  used  only\n"
    append str "to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any\n"
    append str "other  use  of such  megafunction  design,  netlist,  support  information,\n"
    append str "device programming or simulation file,  or any other  related documentation\n"
    append str "or information  is prohibited  for  any  other purpose,  including, but not\n"
    append str "limited to  modification,  reverse engineering,  de-compiling, or use  with\n"
    append str "any other  silicon devices,  unless such use is  explicitly  licensed under\n"
    append str "a separate agreement with  Altera  or a megafunction partner.  Title to the\n"
    append str "intellectual property,  including patents,  copyrights,  trademarks,  trade\n"
    append str "secrets,  or maskworks,  embodied in any such megafunction design, netlist,\n"
    append str "support  information,  device programming or simulation file,  or any other\n"
    append str "related documentation or information provided by  Altera  or a megafunction\n"
    append str "partner, remains with Altera, the megafunction partner, or their respective\n"
    append str "licensors. No other licenses, including any licenses needed under any third\n"
    append str "party's intellectual property, are provided herein.\n"
    append str "\n"

    append str "+-----------------------------------------------------------------------------+\n"
    append str "| Flow Messages                                                               |\n"
    append str "+-----------------------------------------------------------------------------+\n"

    ::report::rmstyle captionedtable
    ::report::rmstyle simpletable

    bputs $str

    catch {unset str}

    return 1
}


#############################################################################
##  Procedure:  debug
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns true if DSE is running in debug mode. Otherwise false.
proc ::quartus::dse::ccl::debug {} {
    set retval 0
    if {[get_global_option "dse-debug"] == 1} {
        set retval 1
    }
    return $retval
}


#############################################################################
##  Procedure:  fputs
##
##  Arguments:
##      args
##          String to put.
##
##  Description:
##      Puts stuff to the report file, prefixes it with nothing at
##      all. Returns 1 if fputs put something, otherwise returns 0.
proc ::quartus::dse::ccl::fputs {args} {

    variable putsfname

    if {$putsfname != "#unknown"} {
        catch {set putsfh [open $putsfname {WRONLY CREAT APPEND}]}
        catch {puts $putsfh [join $args]}
        catch {close $putsfh}
    }
    return 1
}


#############################################################################
##  Procedure:  bputs
##
##  Arguments:
##      args
##          String to put.
##
##  Description:
##      Puts stuff, prefixes it with nothing at all. Returns 1 if
##      bputs put something, otherwise returns 0.  Writes to putsfh which
##      defaults to stdout unless you change it when you init the library.
proc ::quartus::dse::ccl::bputs {args} {

    variable putsfname

    catch {puts stdout [join $args]}
    catch {fputs [join $args]}
    return 1
}


#############################################################################
##  Procedure:  dputs
##
##  Arguments:
##      str
##          String to put.
##
##  Description:
##      Puts stuff, prefixes it with Debug: just like Quartus. Returns 1 if
##      dputs put something, otherwise returns 0.  Writes to putsfh which
##      defaults to stdout unless you change it when you init the library.
##      Only puts if debug flag is set.
proc ::quartus::dse::ccl::dputs {args} {

    set newArgs [join $args]

    global global_dse_options
    variable debugmsgs_count
    variable putsfname

    regsub -all -line -- {^} $newArgs {Debug: } newArgs

    if {[debug]} {
        catch {puts stdout $newArgs}
        catch {fputs $newArgs}
        incr debugmsgs_count
        return 1
    }
    return 0
}


#############################################################################
##  Procedure:  iputs
##
##  Arguments:
##      str
##          String to put.
##
##  Description:
##      Puts stuff, prefixes it with Info: just like Quartus. Returns 1 if
##      iputs put something, otherwise returns 0.  Writes to putsfh which
##      defaults to stdout unless you change it when you init the library.
proc ::quartus::dse::ccl::iputs {args} {

    set newArgs [join $args]

    variable infomsgs
    variable infomsgs_count
    variable putsfname

    if {$infomsgs} {
        foreach line [split $newArgs "\n"] {
            catch {post_message -type info $line}
        }
        regsub -all -line -- {^} $newArgs {Info: } newArgs
        if {[get_global_option "dse-gui"] == 1} {
            catch {::quartus::dse::gui::print_msg -info $newArgs}
        }
        catch {fputs $newArgs}
        incr infomsgs_count
        return 1
    }
    return 0
}


#############################################################################
##  Procedure:  wputs
##
##  Arguments:
##      str
##          String to put.
##
##  Description:
##      Puts stuff, prefixes it with Warning: just like Quartus. Returns 1 if
##      wputs put something, otherwise returns 0.  Writes to putsfh which
##      defaults to stdout unless you change it when you init the library.
proc ::quartus::dse::ccl::wputs {args} {

    set newArgs [join $args]

    global global_dse_options
    variable warningmsgs
    variable warningmsgs_count
    variable putsfname

    if {$warningmsgs} {
        foreach line [split $newArgs "\n"] {
            catch {post_message -type warning $line}
        }
        regsub -all -line -- {^} $newArgs {Warning: } newArgs
        if {[get_global_option "dse-gui"] == 1} {
            catch {::quartus::dse::gui::print_msg -warning $newArgs}
        }
        catch {fputs $newArgs}
        incr warningmsgs_count
        return 1
    }
    return 0
}


#############################################################################
##  Procedure:  eputs
##
##  Arguments:
##      str
##          String to put.
##
##  Description:
##      Puts stuff, prefixes it with Error: just like Quartus. Returns 1 if
##      wputs put something, otherwise returns 0.  Writes to putsfh which
##      defaults to stdout unless you change it when you init the library.
proc ::quartus::dse::ccl::eputs {args} {

    set newArgs [join $args]

    variable errormsgs
    variable errormsgs_count
    variable putsfname

    if {$errormsgs} {
        foreach line [split $newArgs "\n"] {
            catch {post_message -type error $line}
        }
        regsub -all -line -- {^} $newArgs {Error: } newArgs
        if {[get_global_option "dse-gui"] == 1} {
            catch {::quartus::dse::gui::print_msg -error $newArgs}
        }
        catch {fputs $newArgs}
        incr errormsgs_count
        return 1
    }
    return 0
}


#############################################################################
##  Procedure: reverseList
##
##  Arguments:
##      list
##
##  Description:
##      Returns a new list that is the reverse of $list.
proc ::quartus::dse::ccl::reverseList { list } {
    set i 0
    set j [expr { [llength $list] - 1 }]
    while { $j > $i } {
        set temp [lindex $list $i]
        lset list $i [lindex $list $j]
        lset list $j $temp
        incr i
        incr j -1
    }
    return $list
}


#############################################################################
##  Procedure:  dse_exec
##
##  Arguments:
##      input
##          The input command
##
##      output
##          The output command
##
##  Description:
##      Opens an input channel using the input command and dumps to output
##      channel using the output command.
proc ::quartus::dse::ccl::dse_exec {input output} {

    variable qtool_pid
    variable qtool_error_count
    global channel_dump_is_done
    set debug_name "::quartus::dse::ccl::dse_exec()"

    set retval 1

    # Reset error counter
    set qtool_error_count 0

    set infd [open "|$input" "r+"]
    set outfd [open "$output" "w"]

    # Mark PID of qtool running
    set qtool_pid [pid $infd]

    fconfigure $infd -blocking 0

    fileevent $infd readable [list ::quartus::dse::ccl::dump_from_channel_to_channel $infd $outfd]

    vwait channel_dump_is_done

    if {[catch {close $infd}] || [catch {close $outfd}] || $qtool_error_count > 0} {
        set retval 0
    }

    # Clear PID of qtool running
    set qtool_pid ""

    return $retval
}


#############################################################################
##  Procedure:  stop_tool
##
##  Arguments:
##      <none>
##
##  Description:
##      Kills the currently running Quartus II tool (if one is running).
##      Returns nothing.
proc ::quartus::dse::ccl::stop_tool {} {

    variable qtool_pid

    if {[info exists qtool_pid] && $qtool_pid != ""} {
        if {[string equal -nocase $::tcl_platform(platform) "unix"]} {
            catch { exec -- kill $qtool_pid } result
        } else {
            catch { exec -- [file join $::quartus(binpath) killqw] -t $qtool_pid } result
        }
    }

    # Clear PID of qtool running
    set qtool_pid ""
}


#############################################################################
##  Procedure:  dump_from_channel_to_channel
##
##  Arguments:
##      ichan
##          The channel to read date from
##
##      ochan
##          The channel to write the read data to
##
##  Description:
##      Reads data on ichan as it becomes available and writes it to ochan.
##      When ichan no longer has data available it sets global variable to
##      let you know its done.
proc ::quartus::dse::ccl::dump_from_channel_to_channel {ichan ochan} {

    variable qtool_error_count
    global channel_dump_is_done

    if {[eof $ichan]} {
        set channel_dump_is_done 1
        return
    }

    if { [gets $ichan line] < 0 } {
        return
    } else {
        if {[string match "Error:*" $line]} {
            incr qtool_error_count
        }
    }

    puts $ochan $line

    return
}


#############################################################################
##  Procedure:  quartus_sh
##
##  Arguments:
##      args
##          Additional arguments to send quartus_sh
##
##  Description:
##      Runs quartus_sh on a project.
proc ::quartus::dse::ccl::quartus_sh {args} {

    global global_dse_options
    set start_time [clock seconds]

    switch -exact -- [llength $args] {
        0 {
            # We require at least one argument...
            eputs "quartus_sh: wrong number of arguments"
            return -code error "quartus_sh: wrong number of arguments"
        }
    }

    set input "\"[file join $::quartus(binpath) quartus_sh]\" [join $args]"
    set output "quartus_sh.out"
    set ret_val [dse_exec $input $output]
    set end_time [clock seconds]
    catch {file delete -force -- $output}

    if {$ret_val} {
        return [math::max [expr {$end_time - $start_time}] 1]
    } else {
        return 0
    }
}


#############################################################################
##  Procedure:  smart_action
##
##  Arguments:
##      project
##          The project
##
##      revision
##          The revision
##
##  Description:
##      Determine the smart action for this project. Produces a set of
##      *.chg files on disk. Use this proc instead of the quartus_sh
##      project because this can happen so fast that the standard
##      dse_exec method for running quartus_sh hangs, thinking the
##      process is still executing.
proc ::quartus::dse::ccl::smart_action {project revision} {

    set debug_name "::quartus::dse::ccl::smart_action()"

    set start_time [clock seconds]

	if {![is_project_open]} {
		if {[catch {project_open -force -revision $revision $project} rmsg]} {
			::quartus::dse::ccl::dputs "${debug_name}: Caught an error opening project: $rmsg"
			return "SOURCE"
		}
	}

    set_project_settings -cmp $revision
	set_project_settings -sim $revision

	if {[catch {set smart [determine_smart_action]} result]} {
		catch {project_close}
		::quartus::dse::ccl::dputs "${debug_name}: Caught an error calling determine_smart_action: $result"
		return "SOURCE"
	}

	::quartus::dse::ccl::dputs "${debug_name}: Smart action is: $smart"
    return $smart
}

#############################################################################
##  Procedure:  quartus_map
##
##  Arguments:
##
##  Description:
##      Runs quartus_map on a project.
proc ::quartus::dse::ccl::quartus_map {args} {

    global global_dse_options
    set start_time [clock seconds]

    switch -exact -- [llength $args] {
        0 {
            # We require at least one argument...
            eputs "quartus_map: wrong number of arguments"
            return -code error "quartus_map: wrong number of arguments"
        }
    }

    set input "\"[file join $::quartus(binpath) quartus_map]\" [join $args]"
    set output "quartus_map.out"
    set ret_val [dse_exec $input $output]
    set end_time [clock seconds]
    catch {file delete -force -- $output}

    if {$ret_val} {
        return [math::max [expr {$end_time - $start_time}] 1]
    } else {
        return 0
    }
}


#############################################################################
##  Procedure:  quartus_fit
##
##  Arguments:
##
##  Description:
##      Runs quartus_fit on a project.
proc ::quartus::dse::ccl::quartus_fit {args} {

    global global_dse_options
    set start_time [clock seconds]

    switch -exact -- [llength $args] {
        0 {
            # We require at least one argument...
            eputs "quartus_fit: wrong number of arguments"
            return -code error "quartus_fit: wrong number of arguments"
        }
    }

    set input "\"[file join $::quartus(binpath) quartus_fit]\" [join $args]"
    set output "quartus_fit.out"
    set ret_val [dse_exec $input $output]
    set end_time [clock seconds]
    catch {file delete -force -- $output}

    if {$ret_val} {
        return [math::max [expr {$end_time - $start_time}] 1]
    } else {
        return 0
    }
}


#############################################################################
##  Procedure:  quartus_asm
##
##  Arguments:
##
##  Description:
##      Runs quartus_asm on a project.
proc ::quartus::dse::ccl::quartus_asm {args} {

    global global_dse_options
    set start_time [clock seconds]

    switch -exact -- [llength $args] {
        0 {
            # We require at least one argument...
            eputs "quartus_asm: wrong number of arguments"
            return -code error "quartus_asm: wrong number of arguments"
        }
    }

    set input "\"[file join $::quartus(binpath) quartus_asm]\" [join $args]"
    set output "quartus_asm.out"
    set ret_val [dse_exec $input $output]
    set end_time [clock seconds]
    catch {file delete -force -- $output}

    if {$ret_val} {
        return [math::max [expr {$end_time - $start_time}] 1]
    } else {
        return 0
    }
}


#############################################################################
##  Procedure:  quartus_pow
##
##  Arguments:
##
##  Description:
##      Runs quartus_pow on a project.
proc ::quartus::dse::ccl::quartus_pow {args} {

    global global_dse_options
    set start_time [clock seconds]

    switch -exact -- [llength $args] {
        0 {
            # We require at least one argument...
            eputs "quartus_pow: wrong number of arguments"
            return -code error "quartus_pow: wrong number of arguments"
        }
    }

    set input "\"[file join $::quartus(binpath) quartus_pow]\" [join $args]"
    set output "quartus_pow.out"
    set ret_val [dse_exec $input $output]
    set end_time [clock seconds]
    catch {file delete -force -- $output}

    if {$ret_val} {
        return [math::max [expr {$end_time - $start_time}] 1]
    } else {
        return 0
    }
}


#############################################################################
##  Procedure:  quartus_tan
##
##  Arguments:
##
##  Description:
##      Runs quartus_tan on a project
proc ::quartus::dse::ccl::quartus_tan {args} {

    global global_dse_options
    set start_time [clock seconds]

    switch -exact -- [llength $args] {
        0 {
            # We require at least one argument...
            eputs "quartus_tan: wrong number of arguments"
            return -code error "quartus_tan: wrong number of arguments"
        }
    }

    # If we got a --compute_slack_for_tdc argument we should delete .edge files
    switch -regexp -- $args {
        --compute_slack_for_tdc {
            set proj [lindex $args 0]
            file delete -force -- ${proj}-1-qtan.edge
        }
    }

    set input "\"[file join $::quartus(binpath) quartus_tan]\" [join $args]"
    set output "quartus_tan.out"
    set ret_val [dse_exec $input $output]
    set end_time [clock seconds]
    catch {file delete -force -- $output}

    if {$ret_val} {
        return [math::max [expr {$end_time - $start_time}] 1]
    } else {
        return 0
    }
}


#############################################################################
##  Procedure:  qslave
##
##  Arguments:
##      -gui
##          Show the qSlave GUI
##
##      -jobs <#>
##          Set the concurrent number of jobs this instance can
##          run. The default is 1.
##
##      -workdir <filepath>
##          Working directory path of this qslave instance.
##          The default is ./dse/qslave.
##
##  Description:
##      Starts a qslave instance on this machine. Optionally it will
##      set the number of concurrent jobs the machine can run and
##      whether or not you should be shown the qSlave GUI (the default
##      is not to show the GUI). Returns the process ID of the qSlave
##      instance if one was successfully started. Throws an error
##      if something goes wrong so you might want to catch your
##      calls to this function.
proc ::quartus::dse::ccl::qslave {args} {

    set debug_name "::quartus::dse::ccl::qslave()"

    set newArgs [join $args]

    # Command line options to this function we require
    set         tlist       "jobs.arg"
    lappend     tlist       1
    lappend     tlist       "Number of concurrent jobs"
    lappend function_opts $tlist

    # Command line options to this function we require
    set         tlist       "workdir.arg"
    lappend     tlist       [file join . dse qslave]
    lappend     tlist       "Working directory for qslave"
    lappend function_opts $tlist

    # Command line options to this function we require
    set         tlist       "gui"
    lappend     tlist       0
    lappend     tlist       "Show the qSlave GUI"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions newArgs $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            return -code error "${debug_name}: Missing required option: -${opt}"
        }
    }

    # Negate the gui selection of the user
    set optshash(gui) [expr { !$optshash(gui) }]

    # Delete an existing working directory
    #catch {file delete -force -- $optshash(workdir)}
    if {[catch {file mkdir $optshash(workdir)} msg]} {
        return -code error "${debug_name}: Unable to create directory: $optshash(workdir): $msg"
    }

    # Build up a qslave command line based on the options we were passed
    set input "\"[file join $::quartus(binpath) quartus_sh]\" --qslave jobslimit=$optshash(jobs) workdir=$optshash(workdir) nogui=$optshash(gui)"
    ::quartus::dse::ccl::dputs "${debug_name}: Starting qslave with: $input"

	if {$::tcl_platform(platform) == "unix"} {
		# Make sure we can open the qslave instance
		if {[catch {open "|$input" "r+"} infd]} {
			return -code error "${debug_name}: Unable to create qslave instance on [info hostname]"
		}
		set mypid [pid $infd]
		::quartus::dse::ccl::dputs "${debug_name}: qSlave is running as process $mypid on [info hostname]"
		fconfigure $infd -blocking 0
	} else {
		if {[catch {set infd [open [concat | $input] r]} errMsg]} {
			return -code error "${debug_name}: Unable to create qslave instance on [info hostname]"
		}

		fconfigure $infd -buffering none -blocking 0
		set mypid [pid $infd]

		::quartus::dse::ccl::dputs "${debug_name}: qSlave is running as process $mypid on [info hostname]"

		fileevent $infd readable [list ::quartus::dse::ccl::qslaveCallback $infd]
	}


    # Wait for 5 seconds
    ::quartus::dse::ccl::dputs "${debug_name}: Sleeping for 5 seconds while qslave initializes"
    after [expr {5 * 1000}]

    return $mypid
}


#############################################################################
##  Procedure:  qslaveCallBack
##
##  Arguments:
##      pipe
##          Name of the pipe
##
##  Description:
##		This callback prevents the qslave process from hanging up when it
##		is launched on a Windows machine. It should not be used to run
##		a qslave thread on Linux, Solaris or HP-UX 11.
proc ::quartus::dse::ccl::qslaveCallback {pipe} {

    if {[eof $pipe]} {
        catch {fileevent $pipe readable {}}
        catch {close $pipe}
        return
    }

    if {[catch {gets $pipe output} errMsg]} {
        catch {fileevent $pipe readable {}}
        catch {close $pipe}
        return
    }
    return
}


#############################################################################
##  Procedure:  archive
##
##  Arguments:
##      archive_name
##          The name of the archive. Don't include the the '.qar' extension
##          please!
##
##      archive_dir
##          The directory to save the .qar file in. Default is dse.
##
##  Description:
##      Archives the current project and its state to a <name>.qar file
##      for you. Saves space by compressing stuff and such. Returns 1 if
##      the archive was sucessfull; 0 otherwise. Assumes you have the
##      project open!
proc ::quartus::dse::ccl::archive {archive_name {archive_dir "dse"}} {

    set debug_name "::quartus::dse::ccl::archive()"

    set start_time [clock seconds]

    # Stip .qar incase they passed us a file like that
    regsub -nocase -- {\.qar$} $archive_name {} munged_archive_name

    # Build up the options to use with the archive command
    set pa_opts [list "-overwrite" "-use_file_subsets" [list rpt out]]
    if {![string equal -nocase [get_ini_var -name dse_qar_include_outputs] "off"]} {
        lappend pa_opts "-include_outputs"
    }
    if {[string equal -nocase [get_ini_var -name dse_qar_trim_file_list] "on"]} {
        lappend pa_opts "-restrict_file_selection"
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Calling: project_archive ${munged_archive_name} $pa_opts"
    if {[catch {eval project_archive ${munged_archive_name} $pa_opts} result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Archive failed: $result"
        set ret_val 0
    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Archive was created successfully"
        set ret_val 1
        # Store all the archives in a subdirectory
        if {![file exists $archive_dir]} {
            file mkdir $archive_dir
        }

        set from ${munged_archive_name}.qar
        set to [file join $archive_dir ${munged_archive_name}.qar]
        file copy -force -- $from $to
        file delete -force -- $from

        set from ${munged_archive_name}.qarlog
        set to [file join $archive_dir ${munged_archive_name}.qarlog]
        file copy -force -- $from $to
        file delete -force -- $from
    }

    set end_time [clock seconds]
    if {$ret_val} {
        return [math::max [expr {$end_time - $start_time}] 1]
    }
    return 0
}


#############################################################################
## Procedure:  unarchive
##
## Arguments:
##      archive_name
##          The name of the archive. Don't include the the '.qar' extension
##          please!
##
##      archive_dir
##          The directory to save the .qar file in. Default is dse.
##
## Description:
##      Unarchives the current project and its state to a <name>.qar file
##      for you. Restores the saved project to the current working directory
##      possibly overwriting project information that is there already --
##      you've been warned!
proc ::quartus::dse::ccl::unarchive {archive_name {archive_dir "dse"}} {

    global global_dse_options

    set start_time [clock seconds]

    # Stip .qar incase they passed us a file like that
    regsub -nocase -- {\.qar$} $archive_name {} munged_archive_name

    # Project better not be open
    if {[is_project_open]} {
        return -code error "unarchive not possible: project is open"
    }

    # Find and copy the file from the $archive_dir
    # directory to our working directory.
    file delete -force -- ${munged_archive_name}.qar
    set f [file join $archive_dir ${munged_archive_name}.qar]
    if {![file exists $f]} {
        return 0
    }
    file copy -force -- $f .

    # Fix for project_archive problem -- it includes *.rpt files
    # in the archive. We need to save the putsfname before we
    # unarchive to a different file name and then restore it
    # after we unarchive the project.
    variable putsfname
    if {$putsfname != "#unknown"} {
        set f ${putsfname}.saved
        file rename -force -- $putsfname $f
    }
    project_restore ${munged_archive_name}.qar -overwrite
    if {$putsfname != "#unknown"} {
        file rename -force -- $f $putsfname
    }
    # If we get here the restore was successfull so just
    # set 'results' to ""
    set ret_val 1
    # Clean up the copied archive
    file delete -force -- ${munged_archive_name}.qar
    file delete -force -- ${munged_archive_name}.qarlog

    set end_time [clock seconds]

    # Note: we need a way to check and see that the process completed
    # successfully!
    if {$ret_val} {
        return [math::max [expr {$end_time - $start_time}] 1]
    } else {
        return 0
    }
}


#############################################################################
## Procedure:  pgain
##
## Arguments:
##      a: experimental value
##      b: base value
##
## Description:
##      Returns percent gain of a over b
proc ::quartus::dse::ccl::pgain {a b} {
    set diff [expr {$a - $b}]
    set absb [expr {abs($b)}]
    if {$absb == 0} {
        if {$diff == 0} {
            return 0
        } else {
            return "unknown"
        }
    }
    return [expr {($diff* 100) / $absb}]
}


#############################################################################
## Procedure:  absgain
##
## Arguments:
##      a: experimental value
##      b: base value
##
## Description:
##      Returns absolute gain (i.e. a - b)
proc ::quartus::dse::ccl::absgain {a b} {
    return [expr {$a - $b}]
}


#############################################################################
## Procedure:  get_msg_count
##
## Arguments:
##      -warnings
##          Get number of warning messages
##
##      -errors
##          Get number of errors
##
## Description:
##      Returns the number of message types issued.
proc ::quartus::dse::ccl::get_msg_count {args} {

    variable warningmsgs_count
    variable errormsgs_count

    lappend function_opts [list "warnings" 0 "Warning messages"]
    lappend function_opts [list "errors" 0 "Error messages"]
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    if {$optshash(warnings)} {
        set retval $warningmsgs_count
    } elseif {$optshash(errors)} {
        set retval $errormsgs_count
    } else {
        set retval -1
    }

    return $retval
}

#############################################################################
## Procedure:  time_d
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      number of days elapsed.
proc ::quartus::dse::ccl::time_d {msecs} {
    return [expr {$msecs/86400000}]
}

#############################################################################
## Procedure:  time_h
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      number of hours elapsed.
proc ::quartus::dse::ccl::time_h {msecs} {
    return [expr {(($msecs/1000)%86400)/3600}]
}

#############################################################################
## Procedure:  time_m
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      number of minutes elapsed.
proc ::quartus::dse::ccl::time_m {msecs} {
    return [expr {(($msecs/1000)%3600)/60}]

}

#############################################################################
## Procedure:  time_s
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      number of seconds elapsed.
proc ::quartus::dse::ccl::time_s {msecs} {
    return [expr {($msecs/1000)%60}]
}

#############################################################################
## Procedure:  elapsed_time_string
##
## Arguments:
##      msecs - elapsed number of milliseconds
##
## Description:
##      Given an elapsed number of milliseconds this function returns the
##      time string that represents the elapsed in the format
##      [dd]:[hh]:[mm]:[ss] -- the [dd] portion is optional, it is not
##      part of the string if the elapsed time has zero days.
proc ::quartus::dse::ccl::elapsed_time_string {msecs} {
    set days [time_d $msecs]
    set hours [time_h $msecs]
    set minutes [time_m $msecs]
    set seconds [time_s $msecs]
    if {$days == 0} {
        set ttext [format "%02u:%02u:%02u" $hours $minutes $seconds]
    } else {
        set ttext [format "%u:%02u:%02u:%02u" $days $hours $minutes $seconds]
    }
    return $ttext
}

#############################################################################
##  Procedure:  get_seed_list
##
##  Arguments:
##      <none>
##
##  Description:
##		Looks at the input string and determines the seeds that should be
##      run from it.  The function will throw an error if an illegal seed
##      specification is found.
##
proc ::quartus::dse::ccl::get_seed_list {input_seed_list} {

    set error_found 0

    # Check the format of the seeds option and make a list
    set seedlist [list]
    regsub -all -- {,} $input_seed_list { } seeds
    foreach s [split $seeds] {
        set s [string trim $s]
        # Throw away empty strings
        if {[regexp -- {^\s*$} $s]} {
            continue
        }
        # Is it a range?
        if {[regexp -- {^(\d+)-(\d+)$} $s => s1 s2]} {
            # Is the range specified low to high?
            if {$s1 <= $s2} {
                # Expand the range
                for {} {$s1 <= $s2} {incr s1} {
                    lappend seedlist $s1
                }
            } else {
				return -code error "Seed range \"$s\" is not a legal seed range.\nRange must be specifed from lowest to highest value."
              	set error_found 1
            }
        } elseif {[regexp -- {^\d+$} $s]} {
            # Add the seed
            lappend seedlist $s
        } else {
			return -code error "Illegal seed: $s\nSeeds must be positive integers."
        }
    }

    return $seedlist
}

#############################################################################
##  Procedure:  get_global_option
##
##  Arguments:
##      optionName - name of the option to retrieve
##
##  Description:
##      Safe way to access the global_dse_options array. It'll always return
##      "" if the option isn't set or isn't found in the array. Otherwise
##      it'll return the value it's set to you. Saves you from having to
##      write a lot if-not-defined-else-defined code when trying to use
##      global_dse_options.
proc ::quartus::dse::ccl::get_global_option {optionName} {
    global global_dse_options

    set foundOptionName [array names global_dse_options -exact $optionName]
    if {[string equal $foundOptionName $optionName]} {
        set optionValue $global_dse_options($optionName)
    } else {
        set optionValue ""
    }

    return $optionValue
}

#############################################################################
##  Procedure:  read_state_from_disk
##
##  Arguments:
##      <none>
##
##  Description:
##      Loads up the state of DSE from a file on disk.
##      If you add new options to menus and so on you should
##      make sure you're initializing them in this routine.
proc ::quartus::dse::ccl::read_state_from_disk {} {

    set debug_name "::quartus::dse::ccl::read_state_from_disk()"

    global global_dse_options

    set fpath [file join [file normalize ~] .altera.quartus]
    set fname "dse.conf"

    if {$::tcl_platform(platform) == "windows" && [info exists ::env(APPDATA)]} {
        # Use %APPDATA%/Altera instead
        set fpath [file join [file normalize $::env(APPDATA)] Altera]
    }

    if {[file exists [file join $fpath $fname]]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Reading conf file: [file join $fpath $fname]"
        #catch {source [file join $fpath $fname]} result
        set result [source [file join $fpath $fname]]
    } else {
        set result 0
    }

    if {$result} {
        ::quartus::dse::ccl::dputs "${debug_name}: Conf file read successfully"
    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Error reading conf file: $result"
    }

    return $result
}

#############################################################################
##  Procedure:  save_state_to_disk
##
##  Arguments:
##      <none>
##
##  Description:
##      Saves the state of DSE to a file on disk. The file
##      is a Tcl script and is overwritten completely when this
##      function is called. Returns true if state was saved,
##      false otherwise.
proc ::quartus::dse::ccl::save_state_to_disk {} {

    set debug_name "::quartus::dse::ccl::save_state_to_disk()"

    # Import globals we need to write out state for
    global global_dse_options
    global widgets

    set fpath [file join [file normalize ~] .altera.quartus]
    set fname "dse.conf"

    if {$::tcl_platform(platform) == "windows" && [info exists ::env(APPDATA)]} {
        # Use %APPDATA%/Altera instead
        set fpath [file join [file normalize $::env(APPDATA)] Altera]
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Writing conf file: [file join $fpath $fname]"

    catch {file mkdir $fpath}

    if {![file exists $fpath] && ![file isdirectory $fpath]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: Could not create conf file dir $fpath"
        return 0
    }

    if {[catch {open [file join $fpath $fname] {WRONLY CREAT TRUNC}} fh]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: Could not open conf file file for writing: $fh"
        return 0
    }

    # Write the standard Altera header and warning into the conf
    # file -- suggest the user not modify the contents. This
    # formatting is similar to the standard Quartus II qsf header.
    puts $fh "# $::quartus(copyright)"
    puts $fh "# Any  megafunction  design,  and related netlist (encrypted  or  decrypted),"
    puts $fh "# support information,  device programming or simulation file,  and any other"
    puts $fh "# associated  documentation or information  provided by  Altera  or a partner"
    puts $fh "# under  Altera's   Megafunction   Partnership   Program  may  be  used  only"
    puts $fh "# to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any"
    puts $fh "# other  use  of such  megafunction  design,  netlist,  support  information,"
    puts $fh "# device programming or simulation file,  or any other  related documentation"
    puts $fh "# or information  is prohibited  for  any  other purpose,  including, but not"
    puts $fh "# limited to  modification,  reverse engineering,  de-compiling, or use  with"
    puts $fh "# any other  silicon devices,  unless such use is  explicitly  licensed under"
    puts $fh "# a separate agreement with  Altera  or a megafunction partner.  Title to the"
    puts $fh "# intellectual property,  including patents,  copyrights,  trademarks,  trade"
    puts $fh "# secrets,  or maskworks,  embodied in any such megafunction design, netlist,"
    puts $fh "# support  information,  device programming or simulation file,  or any other"
    puts $fh "# related documentation or information provided by  Altera  or a megafunction"
    puts $fh "# partner, remains with Altera, the megafunction partner, or their respective"
    puts $fh "# licensors. No other licenses, including any licenses needed under any third"
    puts $fh "# party's intellectual property, are provided herein."
    puts $fh ""
    puts $fh ""
    puts $fh "# Altera recommends that you do not modify this file. This"
    puts $fh "# file is updated automatically by the Quartus II software"
    puts $fh "# and any changes you make may be lost or overwritten."
    puts $fh ""
    puts $fh "# [clock format [clock scan now]]"
    puts $fh ""
    puts $fh "# Design Space Explorer GUI Settings"
    puts $fh "# =================================="

    # We can only load this state information if the DSE version it was
    # written from is the same as the DSE version it's being loaded
    # with. Add this if to guard against mismatched DSE version loads.
    # All the GUI state information should go between these guards.

    # BEGIN STATE INFO GUARD
    puts $fh "if \{\$::quartus::dse::version == $::quartus::dse::version\} \{\n"
    puts $fh "   global global_dse_options\n"

    # GUI Options
    puts $fh "   # GUI Options"
    puts $fh "   # ============"
    foreach {key} [array names global_dse_options -glob "gui-*"] {
        # Is this a list?
        if {[regexp -nocase -- {.*-list} $key]} {
            # Wipe out an existing list
            puts $fh "   set global_dse_options($key) \[list\]"
            foreach {val} $global_dse_options($key) {
                puts $fh "   lappend global_dse_options($key) \"${val}\""
            }

        } else {
            puts $fh "   ::quartus::dse::ccl::dputs \"${fname}: Setting global_dse_options($key) to: $global_dse_options($key)\""
            puts $fh "   set global_dse_options($key) \"$global_dse_options($key)\""
        }
    }
    puts $fh ""

    puts $fh "\n\}\n"
    # END STATE INFO GUARD

    # End of DSE configuration file
    puts $fh "return 1"
    puts $fh ""

    close $fh

    ::quartus::dse::ccl::dputs "${debug_name}: Wrote conf file successfully to disk"
    return 1
}
