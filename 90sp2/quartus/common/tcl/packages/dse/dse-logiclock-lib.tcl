
####################################################################################
## dse-logiclock-lib.tcl - v1.0
##
## A set of library routines used to power the Design Space Explorer script that
## are specific to all families that can use LogicLock regions.
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

package provide ::quartus::dse::logiclock 1.0

#############################################################################
##  Additional Packages Required
package require ::quartus::dse::ccl
package require ::quartus::misc


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse::logiclock {
    namespace export set_design_space

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!

}


#############################################################################
##  Procedure:  set_design_space
##
##  Arguments:
##      dse_object
##          A pass-by-reference DSE object. This is the objec that will
##          have its space filled in with the appropriate points for
##          the requested space type. Nothing will be deleted in this
##          object. Points will only be added. A "base" point will
##          be added at (seed,0) for you.
##
##      args
##          If no additional args are passed a single 0 point is
##          created in the llr space.
##
##          The following options create additional points:
##
##              -soften
##              Creates a point that softens all the regions in
##              a design.
##
##              -remove
##              Creates a point that removes all the regions in
##              a design.
##
##  Description:
##      Sets up all the values for the LogicLock space for us.
##
##      Returns true (1) if setup was successfull and your _dse_object
##      that you passed by reference has the llr space configured properly.
##      Returns false (0) if something went wrong.
proc ::quartus::dse::logiclock::set_design_space { designspace args } {

    set debug_name "logiclock::set_design_space()"

    # Flatten arguments
    set args [join $args]

    lappend function_opts [list "soften" 0 "Create a point that softens regions"]
    lappend function_opts [list "remove" 0 "Create a point that removes regions"]

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Make sure $designspace is a dse object!
    if {![$designspace isa ::quartus::dse::designspace]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: $designspace is not a ::quartus::dse::designspace object!"
        return 0
    }

    # Set the "base" point
    ::quartus::dse::ccl::dputs "${debug_name}: Adding base point at {llr 0}"
    $designspace addPoint llr 0 {}

    if {$optshash(soften)} {
        ::quartus::dse::ccl::dputs "${debug_name}: Adding a softener point"
        set options ""
        lappend options -setup-script "quartus_cdb:[file join $::quartus(tclpath) packages dse llr_softener.tcl]"
        $designspace addPoint llr end $options
        unset options
    }

    if {$optshash(remove)} {
        ::quartus::dse::ccl::dputs "${debug_name}: Adding a remover point"
        set options ""
        lappend options -setup-script "quartus_cdb:[file join $::quartus(tclpath) packages dse llr_remover.tcl]"
        $designspace addPoint llr end $options
        unset options
    }

    # Return successfully
    return 1
}
