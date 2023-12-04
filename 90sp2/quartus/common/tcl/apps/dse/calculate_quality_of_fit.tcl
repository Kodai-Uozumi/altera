
#############################################################################
##  calculate_quality_of_fit.tcl
##
##  Calculates the Quality of Fit metric using the ::quartus::dse::qof
##  library for a given design. Useful for figuring out what your
##  DSE-reported QoF value would be for the current revision of a
##  design without having to run DSE.
##
##  This calculator is intended to be run in the Quartus II GUI. If
##  you would like a command-line based calculator consider calling
##  the function ::quartus::dse::qof::quality_of_fit directly. The
##  main function of this script can be bound to button in the Quartus
##  II GUI and it will produce a nice GUI response when it's clicked.
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

# This must be run from a Quartus II executable
if {![info exists ::quartus]} {
    error "This must be run from a Quartus II executable"
}

# Even more strict: this must be run from the Quartus II GUI
if {![string equal -nocase $::quartus(nameofexecutable) "quartus"]} {
    error "This script must be run from the Quartus II GUI"
}

catch {init_tk}

# Include some useful packages
package require Tk
package require ::quartus::dse::qof
package require ::quartus::report
package require ::quartus::project

proc calculate_qof {} {
    # Make sure timing analysis panel exists
    if {[catch {get_report_panel_column_index -name "Timing Analyzer||Timing Analyzer Summary" "Slack"} err]} {
        set msg "Quality of fit calculation failed: No timing analysis report found.\nRun a full compilation on your design."
        post_message -type error $msg
        catch { tk_messageBox -type ok -message $msg -icon error }
    } else {
        # Try and calculate the QoF for this design
        if {[catch {::quartus::dse::qof::quality_of_fit} qof]} {
            set msg "Quality of fit calculation failed: $qof."
            post_message -type error $msg
            catch { tk_messageBox -type ok -message $msg -icon error }
        } else {
            set msg "Quality of fit is $qof"
            post_message -type info $msg
            catch { tk_messageBox -type ok -message $msg -icon info }
        }
    }
}

# What's the project and the revision?
set project $::quartus(project)
set revision $::quartus(settings)

if {[regexp -- {^\s*$} $project]} {
    # User does not have a project open
    set msg "Quality of fit calculation failed: No project open."
    post_message -type error $msg
    catch { tk_messageBox -type ok -message $msg -icon error }
} else {
    # Try and load the reports
    if {![is_report_loaded]} {
        if {[catch {load_report} msg]} {
            set msg "Quality of fit calculation failed: Unable to load reports.\nRun a full compilation on your design."
            post_message -type error $msg
            catch { tk_messageBox -type ok -message $msg -icon error }
        } else {
            calculate_qof
        }
    } else {
        calculate_qof
    }
}

# Don't exit. Just end. If you exit you take the Quartus II GUI with you.



