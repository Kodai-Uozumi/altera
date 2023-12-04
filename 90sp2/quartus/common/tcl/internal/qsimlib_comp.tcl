
#############################################################################
##  qsimlib_comp.tcl
##
##  The EDA Simulation Library Compiler Tcl Script
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
package require ::quartus::qsimlib_comp::gui
package require ::quartus::qsimlib_comp::database


##### MAIN script starts here


global global_options

## handle command-line options
set         tlist       "project.arg"
lappend     tlist       "#_optional_#"
lappend     tlist       "The name of the Quartus II project"
lappend function_opts $tlist

set         tlist       "revision.arg"
lappend     tlist       "#_optional_#"
lappend     tlist       "The name of the revision to use"
lappend function_opts $tlist

set         tlist       "debug"
lappend     tlist       0
lappend     tlist       "If true turns on debug messages and debugging code"
lappend function_opts $tlist


## get all command-line options into optshash
array set optshash [cmdline::getFunctionOptions ::quartus(args) $function_opts]

# non-empty ::quartus(args) implies presence of extra option not processed by cmdline::getFunctionOptions, which is an error
if { [llength $::quartus(args)] != 0 } {
    puts "Unrecognized option(s): $::quartus(args)"
    exit 1
}


# this script should only be called by quartus_sh
if { ![string equal $::quartus(nameofexecutable) quartus_sh] } {
	puts "$name_of_script should be invoked using Quartus II Shell"
	exit 1 
}

global exit_qsimlib_comp
set exit_qsimlib_comp 0

# We need to init_tk
if {[catch {init_tk}]} {
    puts "Error: Could not initialize Tk engine -- init_tk failed"
    puts "Error: Are you sure you're running with quartus_sh?"
    exit 1
}

# This script must be run using the Quartus II Shell
if {[info exist ::quartus]} {
	if { ![string equal $::quartus(nameofexecutable) quartus_sh] } {
		set msg "EDA Simulation Library Compiler should be invoked from the\
					command line using the Quartus II Shell.\nUsage:\
					quartus_sh -t qsimlib_comp.tcl \[<options>\]"
		puts $msg
		catch { tk_messageBox -type ok -message $msg -icon error -title "Error"}
		exit 1
	}
} else {
	set msg "EDA Simulation Library Compiler should be invoked using the Quartus II Shell.\
				\nUsage: quartus_sh -t qsimlib_comp.tcl \[<options>\]"
	puts $msg
	catch { tk_messageBox -type ok -message $msg -icon error }
	exit 1
}

eval ::quartus::qsimlib_comp::database::init_data "{$optshash(project)}" "{$optshash(revision)}" $optshash(debug)

eval ::quartus::qsimlib_comp::gui::main

# And wait to exit
vwait exit_qsimlib_comp

eval ::quartus::qsimlib_comp::database::export_data

exit 0
	
