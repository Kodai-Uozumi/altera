
#############################################################################
##  llr_remover.tcl
##
##  This script removes LogicLock regions from a design
##  automatically. It is meant to be assigned to the ACF
##  variable POST_MODULE_SCRIPT like this:
##
##      set_global_assignment -name POST_MODULE_SCRIPT_FILE "quartus_cdb:[file join $::quartus(tclpath) packages dse llr_remover.tcl]"
##
##  After each module the script will be called by quartus_cdb.
##  If the module that just completed is quartus_map then the
##  script will strip all logic lock regions from the design.
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

package require ::quartus::logiclock
package require ::quartus::misc


# We can be certain the arguments to this script are:
#   <executable_that_just_run> <project_name> <revision_name>
# This is how the POST_MODULE_SCRIPT ACF variable works.

set project [lindex $::quartus(args) 0]
set revision [lindex $::quartus(args) 1]

# Returns true if it thinks we can do what we want to do. Prints out
# some nice messages explaining why we can't do what we want to do
# before returning false.
proc can_do {project revision} {
	return 1
}

if {[can_do $project $revision]} {
	post_message -type info "Removing regions in project $project, revision $revision"
	project_open -force -revision $revision $project
	initialize_logiclock

	# Remove all the LogicLock regions in the project
	foreach region [get_logiclock] {
		if {[catch {logiclock_delete -region $region} msg]} {
			regsub -- {ERROR} $msg {} msg
			post_message -type error "Could not delete $region: $msg"
		} else {
			post_message -type info "Successfully deleted region $region"
		}
	}

	initialize_logiclock
	project_close
	post_message -type info "Finished running llr_remover.tcl script"
} else {
	post_message -type info "Unable to remove regions in this project"
}

# All done.
exit 0;
