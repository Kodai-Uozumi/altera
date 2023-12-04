
#############################################################################
##  result-lib.tcl
##
##  Provides the result object code for DSE.
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

package provide ::quartus::dse::result 1.0


#############################################################################
##  Additional Packages Required
package require Itcl
package require xmlgen
package require xml
package require cmdline
package require md5
package require ::quartus::dse::ccl
package require ::quartus::dse::qof
package require ::quartus::misc
load_package report
load_package project


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse::result {

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
}


#############################################################################
##  Class:  result
##
##  Description:
##      The result object holds all your results for a single point in your
##      design space. Every point has a result objec that may, or may not,
##      get filled in after the point has been operated on by Quartus.
##      Typically only "fit" points have their result objects filled in
##      althougth there may be useful stuff that happens in "map" points
##      at some time in the future. Results are not saved the design space
##      object dump.
itcl::class ::quartus::dse::result {

    constructor {_proj _cmp} {
        set strProjectName $_proj
        set strCmpName $_cmp
        set strArchiveName ""
        set boolIsBest 0
        set fingerprint ""
        set boolWasCompiled 0
	set staMode 0
        set strName ""
        array set arrayResults [list]
        array set arraySettings [list]
    }

    destructor {
        catch {array unset arrayResults}
        catch {array unset arraySettings}
    }

    #########################################################################
    ##  Private Class Variables
    ##
    private variable arrayResults

    private variable arraySettings

    private variable boolIsBest

    private variable fingerprint

    private variable boolWasCompiled

    private variable staMode

    private variable strName


    #########################################################################
    ##  Public Class Variables
    ##
    public variable strProjectName

    public variable strCmpName

    public variable strArchiveName

    # Variables used by loadXML to store data and context state.
    private variable _xml_context
    private variable _xml_context_object
    private variable _xml_content_buildup
    private variable _xml_point_buildup


    #########################################################################
    ##  Private Class Methods
    ##

    # Private helper methods that get various bits of data for us
    private method __get_resource_usage_for {rname}
	private method __get_all_resource_usage_information {}
    private method __get_clock_setup_results {args}
    private method __get_clock_hold_results {args}
    private method __get_clock_recovery_results {args}
    private method __get_clock_removal_results {args}
    private method __get_worst_case_slack {args}
    private method __get_number_of_failing_paths {args}
    private method __get_average_slack_of_failing_paths {args}
    private method __get_number_of_clock_hold_failing_paths {args}
    private method __get_number_of_clock_setup_failing_paths {args}
    private method __get_number_of_clock_recovery_failing_paths {args}
    private method __get_number_of_clock_removal_failing_paths {args}
    private method __get_steps_and_times {}
    private method __get_power_estimates {}
	private method __expand_report_panel_name_list {args}


    #########################################################################
    ##  Public Class Methods
    ##
    public method getResultsFromProject {args}

    public method getAllResults {}

    public method getResults {args}

    public method addResult {args}

    public method deleteResults {{pattern "#_all_#"}}

    public method getAllSettings {}

    public method getSetting {sname}

    public method getFingerPrint {}

    public method setFingerPrint {fp}

    public method generateFingerPrint {args}

    public method addSettings {args}

    public method archive {arcfile}

    public method unarchive {}

    public method makeRevision {args}

    public method makeHardCopyRevision {args}

    public method restoreRevision {args}

    public method isBest {}

    public method setBest {int}

    public method isCompiled {}

    public method setCompiled {int}

    public method getName {}

    public method setName {name}

    # Read and write data from file handles
    public method dumpXML {{channel stdout}}
    public method loadXML {{channel stdin}}

    # Methods using by loadXML to handle events fired by parser.
    # They're public because the parse needs access to them. You
    # probably shouldn't ever call these yourself.
    public method _xmlCharacterData {data}
    public method _xmlElementStart {name attlist args}
    public method _xmlElementEnd {name args}
    public method _xmlError {errorcode errormsg}

    # Lets you create a copy of this object
    public method duplicate
}


#############################################################################
##  Method:  result::loadXML
##
##  Arguments:
##      channel
##          Optional channel to gather XML information from. If no
##          channel is specified the method tries to use stdin.
##
##  Description:
##      Loads information from an XML file. Returns true
##      if loading was successful, false if it wasn't. This
##      function does not destroy existing data in the result
##      object, rather it adds it to the current result object.
itcl::body ::quartus::dse::result::loadXML {{channel stdin}} {

    # Reference to commands the parser calls to deal with events
    set cdata       "$this  _xmlCharacterData"
    set elemstart   "$this  _xmlElementStart"
    set elemend     "$this  _xmlElementEnd"
    set err         "$this  _xmlError"

    # Clear parsing state variables
    catch {unset _xml_content_buildup _xml_context _xml_context_object _xml_point_buildup}
    set _xml_context [list]
    set _xml_context_object [list]

    # Create a new xml::parser. Kind of messy because I have to write
    # the commands for each tag in-line. As the objects we save
    # in the result object grow you'll need to grow the
    # list of tags supported by the parser. Always use a pure tcl
    # parser because you never know what Quartus will ship with.
    set parser [xml::parser \
            -reportempty 1 \
            -ignorewhitespace 1 \
            -errorcommand $err \
            -elementstartcommand $elemstart \
            -elementendcommand $elemend \
            -characterdatacommand $cdata ]
    set load_start_time [clock seconds]
#    if {[catch {$parser parse [read $channel]} err]} {
#        error $err
#    }
    $parser parse [read $channel]
    set load_end_time [clock seconds]
    ::quartus::dse::ccl::dputs "result::loadXML(): finished successfully in [expr {$load_end_time - $load_start_time}] seconds"
    return 1
}


#############################################################################
##  Method:  result::dumpXML
##
##  Arguments:
##      channel
##          Optional channel to dump the XML. If none is given
##          defaults to stdout.
##
##  Description:
##      Dumps an XML representation of the result object
##      to $channel. If no channel is specified then it dumps
##      to stdout. Calls some private helper functions to
##      accomplish this goal.
itcl::body ::quartus::dse::result::dumpXML {{channel stdout}} {
    ::xmlgen::declaretag _xml_results RESULTS
    ::xmlgen::declaretag _xml_copyright COPYRIGHT
    ::xmlgen::declaretag _xml_setting SETTING
    ::xmlgen::declaretag _xml_result RESULT

    ::xmlgen::channel $channel {
        _xml_results project=[::xmlgen::esc ${strProjectName}] revname=[::xmlgen::esc ${strCmpName}] isbest=[::xmlgen::esc ${boolIsBest}] arcname=[::xmlgen::esc ${strArchiveName}] wasCompiled=[::xmlgen::esc ${boolWasCompiled}] name=[::xmlgen::esc ${strName}] ! {
            _xml_copyright - {
                Copyright (C) 2002 Altera Corporation. All rights reserved.
                This information and code is highly confidential and proprietary
                information and code of Altera and is being provided in accordance
                with and subject to the protections of a non-disclosure agreement
                which governs its use and disclosure.  Altera products and services
                are protected under numerous U.S. and foreign patents, maskwork rights
                copyrights and other intellectual property laws.  Altera assumes no
                responsibility or liability arising out of the application or use
                of this information and code. This notice must be retained and
                reprinted on any copies of this information and code that are
                permitted to be made.
            }
            foreach setting [array names arraySettings] {
                _xml_setting name=[::xmlgen::esc ${setting}] - [::xmlgen::esc $arraySettings($setting)]
            }
            foreach result [array names arrayResults] {
                _xml_result name=${result} - [::xmlgen::esc $arrayResults($result)]
            }
        }
    }
    puts $channel "\n"
    return 1
}


#############################################################################
##  Method:  result::_xmlCharacterData
##
##  Arguments:
##      data
##
##  Description:
##      Handler function used by the loadXML routine to deal with
##      character data as it's encountered in the XML file stream.
##      Register this handler with the XML parser.
itcl::body ::quartus::dse::result::_xmlCharacterData {data} {

    # Get the current context and context_object
    set context [lindex $_xml_context end]
    set context_object [lindex $_xml_context_object end]

    switch -- $context {
        COPYRIGHT {
            append _xml_content_buildup $data
        }
        SETTING {
            append _xml_content_buildup $data
        }
        RESULT {
            append _xml_content_buildup $data
        }
        default {
            # Do nothing
        }
    }
}


#############################################################################
##  Method:  result::_xmlElementStart
##
##  Arguments:
##      name
##      attlist
##      args
##
##  Description:
##      Handler function used by the loadXML routine to deal with
##      a starting element tag. Register this handler with the XML
##      parser.
itcl::body ::quartus::dse::result::_xmlElementStart {name attlist args} {
    # Unset the build-up variable
    if {[info exists _xml_content_buildup]} {
        unset _xml_content_buildup
    }

    # A hash of attributes is smarter than a list
    array set atthash $attlist

    # A hash of extra arguments is good too
    set argshash(-empty) 0
    foreach {a v} $args {
        set argshash($a) $v
    }

    # Get the current context and context_object
    set context [lindex $_xml_context end]
    set context_object [lindex $_xml_context_object end]

    # If this isn't an empty tag push it on to the context
    if {!$argshash(-empty)} {
        lappend _xml_context $name
    }

    # If you add new elements to the XML spec you'll need
    # to add code to deal with them in this switch statement
    switch -- $name {
        RESULTS {
            # RESULT tags can have a bunch of optional
            # attributes. If they're set override this
            # objects attributes.
            if {[info exists atthash(project)]} {
                set strProjectName $atthash(project)
            }
            if {[info exists atthash(revname)]} {
                set strCmpName $atthash(revname)
            }
            if {[info exists atthash(isbest)]} {
                set boolIsBest $atthash(isbest)
            }
            if {[info exists atthash(arcname)]} {
                set strArchiveName $atthash(arcname)
            }
            if {[info exists atthash(wasCompiled)]} {
                set boolWasCompiled $atthash(wasCompiled)
            }
            if {[info exists atthash(skip)]} {
                set boolSkip $atthash(skip)
            }
            if {[info exists atthash(name)]} {
                set strName $atthash(name)
            }
            lappend _xml_context_object $this
        }
        COPYRIGHT {
            lappend _xml_context_object $context_object
        }
        SETTING {
            # SETTING tags require a name attribute
            if {![info exists atthash(name)]} {
                return -code error "<SETTING> without a name attribute was found!"
            }
            lappend _xml_context_object $atthash(name)
        }
        RESULT {
            # RESULT tags require a name attribute
            if {![info exists atthash(name)]} {
                return -code error "<RESULT> without a name attribute was found!"
            }
            lappend _xml_context_object $atthash(name)
        }
        default {
            # Error. Unknown tag!
            puts stderr "Error parsing XML!"
            puts stderr "Unknown tag encountered: <${name}>"
            return -code error "Unknown tag encoutered"
        }
    }
}


#############################################################################
##  Method:  result::_xmlElementEnd
##
##  Arguments:
##      name
##      args
##
##  Description:
##      Handler function used by the loadXML routine to deal with
##      an ending element tag. Register this handler with the XML
##      parser.
itcl::body ::quartus::dse::result::_xmlElementEnd {name args} {

    set debug_name "::quartus::dse::result::_xmlElement_End()"

    # A hash of extra arguments is good too
    set argshash(-empty) 0
    foreach {a v} $args {
        set argshash($a) $v
    }

    # If this isn't an empty tag pop the context and the context_object
    # and then set the current context to be the parent
    if {!$argshash(-empty)} {
        set current_context [lindex $_xml_context end]
        set _xml_context [lrange $_xml_context 0 [expr {[llength $_xml_context]} - 2]]
        set parent_context [lindex $_xml_context end]

        set current_context_object [lindex $_xml_context_object end]
        set _xml_context_object [lrange $_xml_context_object 0 [expr {[llength $_xml_context_object]} - 2]]
        set parent_context_object [lindex $_xml_context_object end]
    } else {
        set current_context $name
        set parent_context [lindex $_xml_context end]

        set current_context_object ""
        set parent_context_object [lindex $_xml_context_object end]
    }

    # If you add new elements to the XML spec you'll need
    # to add code to deal with them in this switch statement
    switch -- $current_context {
        RESULTS {
            # Do nothing
        }
        COPYRIGHT {
            # Do nothing
        }
        SETTING {
            if {[info exists _xml_content_buildup]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Adding setting: $current_context_object $_xml_content_buildup"
                addSettings [list "$current_context_object"] [list "$_xml_content_buildup"]
            } else {
                ::quartus::dse::ccl::dputs "${debug_name}: Skipping setting: $current_context_object because it is an empty tag"
            }
        }
        RESULT {
            if {[info exists _xml_content_buildup]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Adding result: $current_context_object $_xml_content_buildup"
                addResult -nocomplain -name $current_context_object -value $_xml_content_buildup
            } else {
                ::quartus::dse::ccl::dputs "${debug_name}: Skipping result: $current_context_object because it is an empty tag"
            }
        }
        default {
            # Error. Unknown tag!
            puts stderr "Error parsing XML!"
            puts stderr "Unknown tag encountered: <${name}>"
            return -code error "Unknown tag encountered"
        }
    }
    # Unset the build-up variable
    catch {unset _xml_content_buildup}
}


#############################################################################
##  Method:  result::_xmlError
##
##  Arguments:
##      errorcode
##      errormsg
##
##  Description:
##      Handler function used by the loadXML routine to deal with
##      an errors in the stream. Register this handler with the XML
##      parser.
itcl::body ::quartus::dse::result::_xmlError {errorcode errormsg} {
    return -code error $errormsg
}


#############################################################################
##  Method:  result::getResultsFromProject
##
##  Arguments:
##      <none>
##
##  Description:
##      Parses an open Quartus II 3.1 project for information and fills
##      in the arrayResults array. This function assumes it a project
##      is currently open and compiled so there are results to look at.
##      It returns true if it was able to get through the find and fill-in
##      flow and false if it encounters a snag. Having returned true though
##      doesn't guaruntee though that all the expected values were found.
##      Only that the flow didn't hit some big snag (like not having an
##      open project for example).
itcl::body ::quartus::dse::result::getResultsFromProject {args} {

    set debug_name "::quartus::dse::result::getResultsFromProject()"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

	set         tlist       "point.arg"
    lappend     tlist       "#_optional_#"
    lappend     tlist       "Point to which these results apply"
    lappend function_opts $tlist

	set         tlist       "report-all-resource-usage.arg"
    lappend     tlist       0
    lappend     tlist       "True if you want all the Fitter usage report stuff duplicated in the DSE report."
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    set retval 0

    ::quartus::dse::ccl::dputs "${debug_name}: Opening project $strProjectName with revision $strCmpName"
    project_open -force -revision $strCmpName $strProjectName

    if {[is_project_open]} {

        set family [string tolower [get_global_assignment -name FAMILY]]

        load_report

        # Check and see if STA is being used as the timing engine
        set staMode 0
        if {[get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] == ""} {
            if {[test_family_trait_of -family [get_global_assignment -name FAMILY] -trait USE_STA_BY_DEFAULT]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Project is using TimeQuest for timing analysis"
                set staMode 1
            }
        } else {
            if {[string equal -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] "on"]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Project is using TimeQuest for timing analysis"
                set staMode 1
            }
        }

		# If STA is in use we're going to look and see if maybe all the relevant
		# timing information was already extracted for us. If it is we'll just
		# load up that information. If not we'll fall back on the old
		# parse-the-report-files flow.
		if { $staMode } {
			set use_old_report_panel_extraction_flow 1
			# The name of the XML file is:

			set xmlfilename "$optshash(point)-$optshash(model).xml"
			::quartus::dse::ccl::dputs "${debug_name}: Looking for pre-parsed result file $xmlfilename"
			if {[file exists $xmlfilename]} {
				::quartus::dse::ccl::dputs "${debug_name}: Found pre-parsed result file: $xmlfilename"
				if {[catch {open $xmlfilename} xmlfh]} {
					::quartus::dse::ccl::dputs "${debug_name}: Unable to open $xmlfilename: $xmlfh"
					continue
				}
				::quartus::dse::ccl::dputs "${debug_name}: Loading pre-parsed results for point $optshash(point), model $optshash(model)"
				if {[catch {$this loadXML $xmlfh} err]} {
					::quartus::dse::ccl::dputs "${debug_name}: Unable to load pre-parsed results from $xmlfilename: $xmlfh"
				} else {
					::quartus::dse::ccl::dputs "${debug_name}: Successfully loaded pre-parsed results from $xmlfilename: $xmlfh"
					set use_old_report_panel_extraction_flow 0
				}
				close $xmlfh
				catch { file delete -force $xmlfilename }
			}

			if { $use_old_report_panel_extraction_flow } {
				# We tried but we couldn't load the pre-extracted STA timing
				# information for this project. Fall back on the old report
				# panel extraction methods.
				::quartus::dse::ccl::dputs "${debug_name}: Falling back on report panel extraction method"
			}
		} else {
			set use_old_report_panel_extraction_flow 1
			# This project isn't using STA. No problem. We can handle that.
			# Calculate geomean of periods while we're gathering them up
		}


		# If we're using the old report panel extraction flow do this
		# stuff to pull timing information for this project from the
		# report tables
		if { $use_old_report_panel_extraction_flow } {
			::quartus::dse::ccl::dputs "${debug_name}: Extracting timing results using report panel method"
			set geomean 0.00
			set geomean_count 0
			foreach {key value} [__get_clock_setup_results -model $optshash(model)] {
				addResult -nocomplain -name $key -value $value
				if {[regexp -nocase -- {Clock Setup:\s+'(.*)':\s+Actual Time} $key => clk_name]} {
					if {[regexp -- {(\d+[\.]?\d*)} $value => number]} {
						set geomean [expr {$geomean + log($number)}]
						incr geomean_count
						::quartus::dse::ccl::dputs "${debug_name}: Calculated new geomean accumulation to be $geomean, count $geomean_count"
					}
				}
				catch {unset key value}
			}
			# Now calculate and store the true geomean two dpoints
			if {$geomean_count != 0} {
				set geomean [expr {double(round(exp($geomean/$geomean_count) * 100))/100}]
			} else {
				set geomean "unknown"
			}
			::quartus::dse::ccl::dputs "${debug_name}: Adding geomean of clock periods $geomean for model $optshash(model)"
			addResult -nocomplain -name "Clock Period: Geometric Mean" -value "$geomean ns"

			catch {unset geomean geomean_count}

			foreach {key value} [__get_clock_hold_results -model $optshash(model)] {
				addResult -nocomplain -name $key -value $value
				catch {unset key value}
			}

			foreach {key value} [__get_clock_recovery_results -model $optshash(model)] {
				addResult -nocomplain -name $key -value $value
				catch {unset key value}
			}

			foreach {key value} [__get_clock_removal_results -model $optshash(model)] {
				addResult -nocomplain -name $key -value $value
				catch {unset key value}
			}

			set result [__get_worst_case_slack -model $optshash(model)]
			::quartus::dse::ccl::dputs "${debug_name}: Adding worst-case slack $result for model $optshash(model)"
			addResult -nocomplain -name "Worst-case Slack" -value "[lindex $result 1] ns ([lindex $result 0])"
			catch {unset result}

			# We can now show the DSE Quality of Fit -- users may find
			# this a more even-handed way to choose best/worst settings
			# than relying on worst-case slack.
			if {![catch {::quartus::dse::qof::quality_of_fit -model $optshash(model)} result]} {
				::quartus::dse::ccl::dputs "${debug_name}: Adding QoF metric $result for model $optshash(model)"
				addResult -nocomplain -name "Quality of Fit" -value "$result"
			} else {
				::quartus::dse::ccl::dputs "${debug_name}: Error: Unable to calculate QoF metric: $result"
			}
			catch {unset result}

			#
			# The following metrics are only useful if Classic Timing Analyzer is
			# in use. They do not apply to TimeQuest timing analyzed projects.
			#
			addResult -nocomplain -name "All Failing Paths" -value [__get_number_of_failing_paths -model $optshash(model)]
			if { !$staMode } {
				addResult -nocomplain -name "Average Slack for Failing Paths" -value [__get_average_slack_of_failing_paths -model $optshash(model)]
				addResult -nocomplain -name "All Clock Hold Failing Paths" -value [__get_number_of_clock_hold_failing_paths -model $optshash(model)]
				addResult -nocomplain -name "All Clock Setup Failing Paths" -value [__get_number_of_clock_setup_failing_paths -model $optshash(model)]
				addResult -nocomplain -name "All Clock Recovery Failing Paths" -value [__get_number_of_clock_recovery_failing_paths -model $optshash(model)]
				addResult -nocomplain -name "All Clock Removal Failing Paths" -value [__get_number_of_clock_removal_failing_paths -model $optshash(model)]
			}
			::quartus::dse::ccl::dputs "${debug_name}: Done extracting timing results using report panel method"
		}

        foreach {step etime} [__get_steps_and_times] {
            ::quartus::dse::ccl::dputs "${debug_name}: Adding elapsed time $etime for step $step"
            addResult -nocomplain -name "Elapsed Time: $step" -value $etime
            catch {unset step etime}
        }

        foreach {key value} [__get_power_estimates] {
            if {[string equal $key "Total Thermal Power Dissipation"]} {
                addResult -nocomplain -name $key -value $value
            } else {
                addResult -nocomplain -skip-unknown -name $key -value $value
            }
        }
        catch {unset key value}

        #
        # RESOURCE PARSING
        # We parse the resource differently depending on the family.
        # There are a couple of resource that DSE depends on to be
        # family-independant. In these cases we make copies so DSE
        # can always find (and compare) what it's looking for.
        #
        regsub -nocase -all -- {\s+} $family {} modified_family
        ::quartus::dse::ccl::dputs "${debug_name}: Gathering resource usage for family $family ($modified_family)"
        switch -exact -- $modified_family {
            cyclone {
                addResult -nocomplain -name "Total logic elements" -value [__get_resource_usage_for "Total logic elements"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
            cycloneii {
                addResult -nocomplain -name "Total logic elements" -value [__get_resource_usage_for "Total logic elements"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
            cycloneiii {
                addResult -nocomplain -name "Total logic elements" -value [__get_resource_usage_for "Total logic elements"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
            maxii {
                addResult -nocomplain -name "Total logic elements" -value [__get_resource_usage_for "Total logic elements"]
            }
            stratix {
                addResult -nocomplain -name "Total logic elements" -value [__get_resource_usage_for "Total logic elements"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
            stratixgx {
                addResult -nocomplain -name "Total logic elements" -value [__get_resource_usage_for "Total logic elements"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
            stratixii {
                addResult -nocomplain -name "Logic utilization" -value [__get_resource_usage_for "Logic utilization"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
            stratixiigx {
                addResult -nocomplain -name "Logic utilization" -value [__get_resource_usage_for "Logic utilization"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
            arriagx -
            arria {
                addResult -nocomplain -name "Logic utilization" -value [__get_resource_usage_for "Logic utilization"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
            stratixiii {
                addResult -nocomplain -name "Logic utilization" -value [__get_resource_usage_for "Logic utilization"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
			stratixiv -
			arriaii -
			arriaiigx {
                addResult -nocomplain -name "Logic utilization" -value [__get_resource_usage_for "Logic utilization"]
                addResult -nocomplain -name "Total block memory bits" -value [__get_resource_usage_for "Total block memory bits"]
            }
            hardcopyii {
                addResult -nocomplain -name "Total HCells" -value [__get_resource_usage_for "Total HCells"]
                addResult -nocomplain -name "Total memory bits" -value [__get_resource_usage_for "Total memory bits"]
            }
            default {
                # This is what we fall back on for all other families. It's
                # a pretty safe default and it's been is use for a number of
                # years now.
                ::quartus::dse::ccl::dputs "${debug_name}: Using DEFAULT resource gathering for family $family"
                addResult -nocomplain -name "Total logic elements" -value [__get_resource_usage_for "Total logic elements"]
                addResult -nocomplain -name "Total memory bits" -value [__get_resource_usage_for "Total memory bits"]
            }
        }

		# If the user wants all the resource usage information in the DSE report
		# we should fetch it for them here.
		if { $optshash(report-all-resource-usage) } {
			::quartus::dse::ccl::dputs "${debug_name}: User said report all resource usage: $optshash(report-all-resource-usage)"
			__get_all_resource_usage_information
		}

        # Add a fast/slow timing model entry to the results
        switch -- $optshash(model) {
            "fast" {
                addResult -nocomplain -name "Timing Model" -value "Fast"
            }
            "slow" {
                addResult -nocomplain -name "Timing Model" -value "Slow"
            }
            default {
                # Try and extract stuff out of the model string
                if {[regexp -nocase -- {(fast)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                    addResult -nocomplain -name "Timing Model" -value "Fast ${volts}mV ${temp}C"
                } elseif {[regexp -nocase -- {(slow)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                    addResult -nocomplain -name "Timing Model" -value "Slow ${volts}mV ${temp}C"
                }
            }
        }

        ::quartus::dse::ccl::dputs "${debug_name}: Finished gathering results"
        ::quartus::dse::ccl::dputs "${debug_name}: Closing report"
        unload_report

        set retval 1

    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: No project open!"
    }

    project_close

    return $retval
}


#############################################################################
##  Method:  result::__expand_report_panel_name_list
##
##  Arguments:
##      list of panel patterns to expand
##
##  Description:
##		Turns a list of patterns into a list of fully qualified panel
##		names suitable for passing into functions like
##		::quartus::report::get_report_panel_id. The list is normalized
##		so there's no duplicates on it.
itcl::body ::quartus::dse::result::__expand_report_panel_name_list {args} {

	set debug_name "::quartus::dse::result::__expand_report_panel_name_list()"
	set match_list [join $args]
	set full_panel_list [get_report_panel_names]
	array set marray [list]

	::quartus::dse::ccl::dputs "${debug_name}: Matching against expressions:"
	foreach {panel_expr} $match_list {
		::quartus::dse::ccl::dputs "${debug_name}:    $panel_expr"
	}

	foreach {panel_name} $full_panel_list {
		foreach {panel_expr} $match_list {
			if {[regexp -- $panel_expr $panel_name]} {
				set marray($panel_name) 1
			}
		}
	}
	::quartus::dse::ccl::dputs "${debug_name}: Returning list of report panels names:"
	foreach {panel_name} [array names marray] {
		::quartus::dse::ccl::dputs "${debug_name}:    $panel_name"
	}
	return [array names marray]
}


#############################################################################
##  Method:  result::__get_clock_setup_results
##
##  Arguments:
##      <none>
##
##  Description:
##      Gets a list of settings for the Clock Setup fields from
##      the Timing Summary report panel. Assumes there is
##      currently a project open and a report loaded.
itcl::body ::quartus::dse::result::__get_clock_setup_results {args} {

    set debug_name "::quartus::dse::result::__get_clock_setup_results()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    array set rarray [list]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            if { $staMode } {
                set panels [list "TimeQuest Timing Analyzer.*Fast Model Setup Summary" "TimeQuest Timing Analyzer.*Fast Model Fmax Summary"]
            } else {
                set panels [list "Timing Analyzer.*Fast Model Timing Analyzer Summary"]
            }
            set key_prefix "Fast Model "
        }
        "slow" {
            if { $staMode } {
                set panels [list "TimeQuest Timing Analyzer.*Slow Model Setup Summary" "TimeQuest Timing Analyzer.*Slow Model Fmax Summary"]
            } else {
                set panels [list "Timing Analyzer.*Slow Model Timing Analyzer Summary"]
            }
            set key_prefix "Slow Model "
        }
        "normal" {
			if { $staMode } {
				set panels [list "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Setup Summary" "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Fmax Summary"]
			} else {
				set panels [list "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"]
			}
			set key_prefix ""
        }
        default {
            # Try and extract stuff out of the model string
            if {[regexp -nocase -- {(fast)-(\d+)mV-(\-?	\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panels [list "TimeQuest Timing Analyzer.*Fast ${volts}mV ${temp}C Model Setup Summary" "TimeQuest Timing Analyzer.*Fast ${volts}mV ${temp}C Model Fmax Summary"]
                } else {
                    set panels [list "Timing Analyzer.*Fast ${volts}mV ${temp}C Model Timing Analyzer Summary"]
                }
                set key_prefix "Fast ${volts}mV ${temp}C Model "
            } elseif {[regexp -nocase -- {(slow)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panels [list "TimeQuest Timing Analyzer.*Slow ${volts}mV ${temp}C Model Setup Summary" "TimeQuest Timing Analyzer.*Slow ${volts}mV ${temp}C Model Fmax Summary"]
                } else {
                    set panels [list "Timing Analyzer.*Slow ${volts}mV ${temp}C Model Timing Analyzer Summary"]
                }
                set key_prefix "Slow ${volts}mV ${temp}C Model "
            } else {
                if { $staMode } {
                    set panels [list "TimeQuest Timing Analyzer.*Fmax Summary"]
                } else {
                    set panels [list "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"]
                }
                set key_prefix ""
            }
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panels [__expand_report_panel_name_list $panels]

	foreach {panel_name} $panels {
		::quartus::dse::ccl::dputs "${debug_name}: Looking for panel $panel_name"
		set panel_id [get_report_panel_id $panel_name]
		if { $panel_id != -1 } {
			if {[catch {get_number_of_rows -id $panel_id} row_count]} {
				set row_count 0
			}
			for {set i 0} {$i < $row_count} {incr i} {
				if { $staMode } {
					# START STA MODE
					# Skip the first row
					if { $i == 0 } {
						continue
					}

					if { [catch {get_report_panel_data -id $panel_id -row $i -col_name "Clock"} row_name] } {
						if { [catch {get_report_panel_data -id $panel_id -row $i -col_name "Clock Name"} row_name] } {
							::quartus::dse::ccl::dputs "${debug_name}: $row_name"
							::quartus::dse::ccl::dputs "${debug_name}: Assuming clock is called 'N/A'"
							set row_name "N/A"
						}
					}

					set key "Clock Setup: '${row_name}': Slack"
					if { ! [info exists rarray($key)] } {
						set rarray($key) "unknown"
					}
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => val]} {
						set rarray($key) "$val ns"
					}

					set key "Clock Setup: '${row_name}': End Point TNS"
					if { ! [info exists rarray($key)] } {
						set rarray($key) "unknown"
					}
					catch {get_report_panel_data -id $panel_id -row $i -col_name "End Point TNS"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => val]} {
						set rarray($key) "$val ns"
					}

					set key "Clock Setup: '${row_name}': Fmax"
					if { ! [info exists rarray($key)] } {
						set rarray($key) "unknown"
					}
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Fmax"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => val units]} {
						set rarray($key) "$val $units"
						# Convert this to nano seconds for an actual time value
						set newkey "Clock Setup: '${row_name}': Actual Time"
						switch -exact -- [string tolower $units] {
							{ghz} {
								if {[catch {format "%.3f" [expr { 1 / $val }]} ns]} {
									::quartus::dse::ccl::dputs "${debug_name}: Error converting Fmax $val GHz to nanoseconds: $ns"
									set rarray($newkey) "unknown"
								} else {
									set rarray($newkey) "$ns ns"
								}
							}
							{mhz} {
								if {[catch {format "%.3f" [expr { 1000 / $val }]} ns]} {
									::quartus::dse::ccl::dputs "${debug_name}: Error converting Fmax $val MHz to nanoseconds: $ns"
									set rarray($newkey) "unknown"
								} else {
									set rarray($newkey) "$ns ns"
								}
							}
							{khz} {
								if {[catch {format "%.3f" [expr { 1000000 / $val }]} ns]} {
									::quartus::dse::ccl::dputs "${debug_name}: Error converting Fmax $val kHz to nanoseconds: $ns"
									set rarray($newkey) "unknown"
								} else {
									set rarray($newkey) "$ns ns"
								}
							}
							{hz} {
								if {[catch {format "%.3f" [expr { 1000000000 / $val }]} ns]} {
									::quartus::dse::ccl::dputs "${debug_name}: Error converting Fmax $val Hz to nanoseconds: $ns"
									set rarray($newkey) "unknown"
								} else {
									set rarray($newkey) "$ns ns"
								}
							}
							default {
								set rarray($newkey) "unknown"
							}
						}
					}

					set key "Clock Setup: '${row_name}': Restricted Fmax"
					if { ! [info exists rarray($key)] } {
						set rarray($key) "unknown"
					}
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Fmax"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)\s+(\S+)} $val => val units]} {
						set rarray($key) "$val $units"
					}
					# END STA MODE
				} else {
					if { ![catch {get_report_panel_data -id $panel_id -row $i -col 0} row_name] } {
						if {[regexp -nocase -- {Clock Setup.*:} $row_name]} {
							# Get the slack for this clock
							set key "${row_name}: Slack"
							regsub -- $key_prefix $key {} key
							catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
							if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => slack]} {
								set rarray($key) "$slack ns"
							} else {
								set rarray($key) "unknown"
							}
							# Now get the actual time for this clock
							set key "${row_name}: Actual Time"
							regsub -- $key_prefix $key {} key
							catch {get_report_panel_data -id $panel_id -row $i -col_name "Actual Time"} val
							if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => actual_time]} {
								set rarray($key) "$actual_time ns"
							} else {
								set rarray($key) "unknown"
							}
							# Now get the number of failing paths for this clock
							set key "${row_name}: Failed Paths"
							regsub -- $key_prefix $key {} key
							catch {get_report_panel_data -id $panel_id -row $i -col_name "Failed Paths"} val
							if {[regexp -nocase -- {(\d+)} $val => failed_paths]} {
								set rarray($key) "$failed_paths"
							} else {
								set rarray($key) "unknown"
							}
						} elseif {[regexp -nocase -- {Worst-case\s+} $row_name]} {
							# Get the slack for this clock
							set key "${row_name}: Slack"
							catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
							if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => slack]} {
								set rarray($key) "$slack ns"
							} else {
								set rarray($key) "unknown"
							}
							# Now get the actual time for this clock
							set key "${row_name}: Actual Time"
							catch {get_report_panel_data -id $panel_id -row $i -col_name "Actual Time"} val
							if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => actual_time]} {
								set rarray($key) "$actual_time ns"
							} else {
								set rarray($key) "unknown"
							}
							# Now get the number of failing paths for this clock
							set key "${row_name}: Failed Paths"
							catch {get_report_panel_data -id $panel_id -row $i -col_name "Failed Paths"} val
							if {[regexp -nocase -- {(\d+)} $val => failed_paths]} {
								set rarray($key) "$failed_paths"
							} else {
								set rarray($key) "unknown"
							}
						}
					}

				}
			}
		}
	}

	return [array get rarray]
}


#############################################################################
##  Method:  result::__get_steps_and_times
##
##  Arguments:
##      <none>
##
##  Description:
##      Gets a list of steps that were run and their elapsed
##      times as calculated by Quartus internally.
itcl::body ::quartus::dse::result::__get_steps_and_times {} {

    set debug_name "::quartus::dse::result::__get_steps_and_times()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting"

    array set rarray [list]

    # Get the run time for each piece of the flow
    set panid [get_report_panel_id "Flow Elapsed Time"]
    # Catch this call because HardCopy projects don't include
    # this panel...
    if {![catch {set rows [get_number_of_rows -id $panid]}]} {
        if {[llength $rows] > 0} {
            for {set x 1} {$x < $rows} {incr x} {
                set row [get_report_panel_row -id $panid -row $x]
                set key [lindex $row 0]
                set val [lindex $row 1]
                set rarray($key) $val
            }
        }
    }

    return [array get rarray]
}


#############################################################################
##  Method:  result::__get_number_of_failing_paths
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns the number of failing paths in a design. This is ALL
##      the failing paths mind you.
itcl::body ::quartus::dse::result::__get_number_of_failing_paths {args} {

    set debug_name "::quartus::dse::result::__get_number_of_failing_paths()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            set panel_name  "Timing Analyzer.*Fast Model Timing Analyzer Summary"
        }
        "slow" {
            set panel_name  "Timing Analyzer.*Slow Model Timing Analyzer Summary"
        }
        default {
            set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

    if { $staMode } {
		# Right now we're not counting the number of failing paths when STA is
		# use. Rather we're just detecting if the *are* failing paths or there
		# are *not* failing paths in the design. This is easier and can be done
		# using only the report tables produced by STA and existing
		# DSE result object methods.
		set counter 0
		foreach {key value} [__get_clock_setup_results -model $optshash(model)] {
            if {[regexp -nocase -- {Slack} $key => clk_name]} {
                if {[regexp -- {\d+[\.]?\d*} $value => number]} {
					if { $value < 0 } {
						::quartus::dse::ccl::dputs "${debug_name}: Found a failing path: $key = $value"
						incr counter
					}
                }
            }
            catch {unset key value}
        }

		foreach {key value} [__get_clock_hold_results -model $optshash(model)] {
            if {[regexp -nocase -- {Slack} $key => clk_name]} {
                if {[regexp -- {\d+[\.]?\d*} $value => number]} {
					if { $value < 0 } {
						::quartus::dse::ccl::dputs "${debug_name}: Found a failing path: $key = $value"
						incr counter
					}
                }
            }
            catch {unset key value}
        }

        foreach {key value} [__get_clock_recovery_results -model $optshash(model)] {
            if {[regexp -nocase -- {Slack} $key => clk_name]} {
                if {[regexp -- {\d+[\.]?\d*} $value => number]} {
					if { $value < 0 } {
						::quartus::dse::ccl::dputs "${debug_name}: Found a failing path: $key = $value"
						incr counter
					}
                }
            }
            catch {unset key value}
        }

        foreach {key value} [__get_clock_removal_results -model $optshash(model)] {
            if {[regexp -nocase -- {Slack} $key => clk_name]} {
                if {[regexp -- {\d+[\.]?\d*} $value => number]} {
					if { $value < 0 } {
						::quartus::dse::ccl::dputs "${debug_name}: Found a failing path: $key = $value"
						incr counter
					}
                }
            }
            catch {unset key value}
        }

        set result [__get_worst_case_slack -model $optshash(model)]
		if { [lindex $result 1] < 0 } {
			::quartus::dse::ccl::dputs "${debug_name}: Found a failing path (worst-case slack): [lindex $result 0] = [lindex $result 1]"
			incr counter
		}
        catch {unset result}

		::quartus::dse::ccl::dputs "${debug_name}: Counted at least $counter failing paths"
		if { $counter > 0 } {
			set num_path ">0"
		} else {
			set num_path 0
		}
    } else {
		if {[catch {get_report_panel_data -name $panel_name -row_name "Total number of failed paths" -col_name "Failed Paths"} num_path]} {
			set num_path 0
		}
	}

    return $num_path
}


#############################################################################
##  Method:  result::__get_average_slack_of_failing_paths
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns the average slack of all the failing paths in the design.
##      Uses the number returned by __get_number_of_failing_paths as the
##      divisor for the accumulated negative slack value. Assumes a
##      report database is already open.
itcl::body ::quartus::dse::result::__get_average_slack_of_failing_paths {args} {

    set debug_name "::quartus::dse::result::__get_average_slack_of_failing_paths()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            set panel_prefix  "Timing Analyzer||Fast Model||Fast Model "
        }
        "slow" {
            set panel_prefix  "Timing Analyzer||Slow Model||Slow Model "
        }
        default {
            set panel_prefix  "Timing Analyzer||"
        }
    }

    if { $staMode } {
        # Stop here. This isn't something we can calculate if STA is
        # being used to do timing analysis.
        return "unknown"
    }

    set parsed_num_path [__get_number_of_failing_paths]
    set num_path 0
    set tot_neg_slack 0

    foreach panel_name [get_report_panel_names] {
        if { [string match "${panel_prefix}Clock Setup*" [escape_brackets $panel_name]] } {
            set panel_id [get_report_panel_id $panel_name]
			if {[catch {get_number_of_rows -id $panel_id} num_of_rows]} {
				set num_of_rows 0
			}
            for {set row 0} {$row < $num_of_rows} {incr row} {
                set row_info [get_report_panel_row -row $row -id $panel_id]
                set slack [lindex [split $row_info] 0]
                regsub -all {\{} $slack {} slack
                regsub -all {\}} $slack {} slack
                if { $slack < 0 } {
                    set tot_neg_slack [expr {$tot_neg_slack + $slack}]
                    incr num_path
                }
            }
        } elseif { [string match "${panel_prefix}tsu" $panel_name] || \
                   [string match "${panel_prefix}tco" $panel_name] || \
                   [string match "${panel_prefix}tpd" $panel_name] || \
                   [string match "${panel_prefix}th" $panel_name] || \
                   [string match "${panel_prefix}Minimum tco" $panel_name] || \
                   [string match "${panel_prefix}Minimum tpd" $panel_name]
        } {
            set panel_id [get_report_panel_id $panel_name]
			if {[catch {get_number_of_rows -id $panel_id} num_of_rows]} {
				set num_of_rows 0
			}
            for {set row 0} {$row < $num_of_rows} {incr row} {
                set row_info [get_report_panel_row -row $row -id $panel_id]
                set slack [lindex [split $row_info] 0]
                regsub -all {\{} $slack {} slack
                regsub -all {\}} $slack {} slack
                if { $slack < 0 } {
                    set tot_neg_slack [expr {$tot_neg_slack + $slack}]
                    incr num_path
                }
            }
        }
    }

    # For debugging sanity compare parsed_num_path to num_path
    ::quartus::dse::ccl::dputs "${debug_name}: Counted failing paths: $num_path"
    ::quartus::dse::ccl::dputs "${debug_name}: Parsed failing paths:  $parsed_num_path"

    if {$parsed_num_path == 0} {
        set avg_neg_slack 0
    } else {
        set avg_neg_slack [format {%.3f} [expr {$tot_neg_slack / $parsed_num_path}]]
    }

    return $avg_neg_slack
}


#############################################################################
##  Method:  result::__get_number_of_clock_hold_failing_paths
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns the number of failing paths for 'Clock Hold' entries in
##      the TAN summary table. Assumes the report is already open.
itcl::body ::quartus::dse::result::__get_number_of_clock_hold_failing_paths {args} {

    set debug_name "::quartus::dse::result::__get_number_of_clock_hold_failing_paths()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            set panel_name  "Timing Analyzer.*Fast Model Timing Analyzer Summary"
        }
        "slow" {
            set panel_name  "Timing Analyzer.*Slow Model Timing Analyzer Summary"
        }
        default {
            set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

    if { $staMode } {
        # Stop here. This isn't something we can calculate if STA is
        # being used to do timing analysis.
        return "unknown"
    }

    set total_failed_paths 0

	catch {get_report_panel_id $panel_name} panel
	if {[catch {get_number_of_rows -id $panel} row_count]} {
		set row_count 0
	}
	for {set i 0} {$i < $row_count} {incr i} {
		if { ![catch {get_report_panel_data -id $panel -row $i -col 0} row_name] } {
			if {[regexp -nocase -- {Clock Hold.*:} $row_name]} {
				if {![catch {get_report_panel_data -id $panel -row $i -col_name "Failed Paths"} failed_paths]} {
					if {[regexp -- {^\d+$} $failed_paths]} {
						set total_failed_paths [expr {$total_failed_paths + $failed_paths}]
					}
				}
			}
		}
	}

    return $total_failed_paths
}


#############################################################################
##  Method:  result::__get_number_of_clock_setup_failing_paths
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns the number of failing paths for 'Clock Setup' entries in
##      the TAN summary table. Assumes the report is already open.
itcl::body ::quartus::dse::result::__get_number_of_clock_setup_failing_paths {args} {

    set debug_name "::quartus::dse::result::__get_number_of_clock_setup_failing_paths()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            set panel_name  "Timing Analyzer.*Fast Model Timing Analyzer Summary"
        }
        "slow" {
            set panel_name  "Timing Analyzer.*Slow Model Timing Analyzer Summary"
        }
        default {
            set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

    if { $staMode } {
        # Stop here. This isn't something we can calculate if STA is
        # being used to do timing analysis.
        return "unknown"
    }

    set total_failed_paths 0

    catch {get_report_panel_id $panel_name} panel
	if {[catch {get_number_of_rows -id $panel} row_count]} {
		set row_count 0
	}
	for {set i 0} {$i < $row_count} {incr i} {
		if { ![catch {get_report_panel_data -id $panel -row $i -col 0} row_name] } {
			if {[regexp -nocase -- {Clock Setup.*:} $row_name]} {
				if {![catch {get_report_panel_data -id $panel -row $i -col_name "Failed Paths"} failed_paths]} {
					if {[regexp -- {^\d+$} $failed_paths]} {
						set total_failed_paths [expr {$total_failed_paths + $failed_paths}]
					}
				}
			}
		}
	}

    return $total_failed_paths
}


#############################################################################
##  Method:  result::__get_number_of_clock_recovery_failing_paths
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns the number of failing paths for 'Recovery' entries in
##      the TAN summary table. Assumes the report is already open.
itcl::body ::quartus::dse::result::__get_number_of_clock_recovery_failing_paths {args} {

    set debug_name "::quartus::dse::result::__get_number_of_clock_recovery_failing_paths()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            set panel_name  "Timing Analyzer.*Fast Model Timing Analyzer Summary"
        }
        "slow" {
            set panel_name  "Timing Analyzer.*Slow Model Timing Analyzer Summary"
        }
        default {
            set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

    if { $staMode } {
        # Stop here. This isn't something we can calculate if STA is
        # being used to do timing analysis.
        return "unknown"
    }

    set total_failed_paths 0

    catch {get_report_panel_id $panel_name} panel
	if {[catch {get_number_of_rows -id $panel} row_count]} {
		set row_count 0
	}
	for {set i 0} {$i < $row_count} {incr i} {
		if { ![catch {get_report_panel_data -id $panel -row $i -col 0} row_name] } {
			if {[regexp -nocase -- {Recovery:} $row_name]} {
				if {![catch {get_report_panel_data -id $panel -row $i -col_name "Failed Paths"} failed_paths]} {
					if {[regexp -- {^\d+$} $failed_paths]} {
						set total_failed_paths [expr {$total_failed_paths + $failed_paths}]
					}
				}
			}
		}
	}

    return $total_failed_paths
}


#############################################################################
##  Method:  result::__get_number_of_clock_removal_failing_paths
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns the number of failing paths for 'Removal' entries in
##      the TAN summary table. Assumes the report is already open.
itcl::body ::quartus::dse::result::__get_number_of_clock_removal_failing_paths {args} {

    set debug_name "::quartus::dse::result::__get_number_of_clock_removal_failing_paths()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            set panel_name  "Timing Analyzer.*Fast Model Timing Analyzer Summary"
        }
        "slow" {
            set panel_name  "Timing Analyzer.*Slow Model Timing Analyzer Summary"
        }
        default {
            set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

    if { $staMode } {
        # Stop here. This isn't something we can calculate if STA is
        # being used to do timing analysis.
        return "unknown"
    }

    set total_failed_paths 0

    catch {get_report_panel_id $panel_name} panel
	if {[catch {get_number_of_rows -id $panel} row_count]} {
		set row_count 0
	}
	for {set i 0} {$i < $row_count} {incr i} {
		if { ![catch {get_report_panel_data -id $panel -row $i -col 0} row_name] } {
			if {[regexp -nocase -- {Removal:} $row_name]} {
				if {![catch {get_report_panel_data -id $panel -row $i -col_name "Failed Paths"} failed_paths]} {
					if {[regexp -- {^\d+$} $failed_paths]} {
						set total_failed_paths [expr {$total_failed_paths + $failed_paths}]
					}
				}
			}
		}
	}

    return $total_failed_paths
}


#############################################################################
##  Method:  result::__get_worst_case_slack
##
##  Arguments:
##      <none>
##
##  Description:
##      Gets the worst case slack and the clock name for the design.
##      Returns a list where the 0 element is the name of the clock
##      and the 1 element is the worst-case slack value. Assumes you
##      have a Quartus project open already.
itcl::body ::quartus::dse::result::__get_worst_case_slack {args} {

    set debug_name "::quartus::dse::result::__get_worst_case_slack()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            if { $staMode } {
                set panel_name "TimeQuest Timing Analyzer.*Fast Model Setup Summary"
            } else {
                set panel_name  "Timing Analyzer.*Fast Model Timing Analyzer Summary"
            }
            set key_prefix "Fast Model "
        }
        "slow" {
            if { $staMode } {
                set panel_name "TimeQuest Timing Analyzer.*Slow Model Setup Summary"
            } else {
                set panel_name  "Timing Analyzer.*Slow Model Timing Analyzer Summary"
            }
            set key_prefix "Slow Model "
        }
        "normal" {
            if { $staMode } {
				set panel_name "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Setup Summary"
			} else {
				set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
			}
            set key_prefix ""
        }
        default {
            # Try and extract stuff out of the model string
            if {[regexp -nocase -- {(fast)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer.*Fast ${volts}mV ${temp}C Model Setup Summary"
                } else {
                    set panel_name  "Timing Analyzer.*Fast ${volts}mV ${temp}C Model Timing Analyzer Summary"
                }
                set key_prefix "Fast ${volts}mV ${temp}C Model "
            } elseif {[regexp -nocase -- {(slow)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer.*Slow ${volts}mV ${temp}C Model Setup Summary"
                } else {
                    set panel_name  "Timing Analyzer.*Slow ${volts}mV ${temp}C Model Timing Analyzer Summary"
                }
                set key_prefix "Slow ${volts}mV ${temp}C Model "
            } else {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Setup Summary"
                } else {
                    set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
                }
                set key_prefix ""
            }
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]
    set rlist [list "unknown" "unknown"]

	catch {get_report_panel_id $panel_name} panel_id
	::quartus::dse::ccl::dputs "${debug_name}: Got panel id: $panel_id"
	if {[catch {get_number_of_rows -id $panel_id} row_count]} {
		set row_count 0
	}
	for {set i 1} {$i < $row_count} {incr i} {
		if { $staMode } {
			# START STA MODE
			# Skip the first row
			if { $i == 0 } {
				continue
			}

			if { [catch {get_report_panel_data -id $panel_id -row $i -col_name "Clock"} row_name] } {
				::quartus::dse::ccl::dputs "${debug_name}: $row_name"
				::quartus::dse::ccl::dputs "${debug_name}: Assuming clock is called 'N/A'"
				set row_name "N/A"
			}

			set key "Clock Setup: '${row_name}'"
			catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
			if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => slack]} {
				if {[string equal [lindex $rlist 0] "unknown"]} {
					set rlist [list $key $slack]
				} elseif {$slack < [lindex $rlist 1]} {
					set rlist [list $key $slack]
				}
			}
			# END STA MODE
		} else {
			if { ![catch {get_report_panel_data -id $panel_id -row $i -col 0} row_name] } {
				if {![catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} pstring]} {
					# Munge the name of the key
					if {[regexp -nocase -- {Clock Setup:\s+('\S+')} $row_name => clk_name]} {
						set key "Clock Slack: ${clk_name}"
					} elseif {[regexp -nocase -- {Clock Hold:\s+('\S+')} $row_name => clk_name]} {
						set key "Clock Hold: ${clk_name}"
					} elseif {[regexp -nocase -- {Worst-case\s+(.*)} $row_name => setting_name]} {
						set key "Worst-case ${setting_name}"
					} else {
						set key $row_name
					}
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $pstring => slack]} {
						if {[string equal [lindex $rlist 0] "unknown"]} {
							set rlist [list $key $slack]
						} elseif {$slack < [lindex $rlist 1]} {
							set rlist [list $key $slack]
						}
					}
				}
			}
		}
	}

    return $rlist
}


#############################################################################
##  Method:  result::__get_clock_hold_results
##
##  Arguments:
##      <none>
##
##      Gets the clock hold results for all the clocks in the design
##      using the Timing Summary table. Returns a list that holds key/value
##      pairs ready for entry into the result db for this compile. Assumes
##      you have a Quartus project open already.
itcl::body ::quartus::dse::result::__get_clock_hold_results {args} {

    set debug_name "::quartus::dse::result::__get_clock_hold_results()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    array set rarray [list]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            if { $staMode } {
                set panel_name "TimeQuest Timing Analyzer.*Fast Model Hold Summary"
            } else {
                set panel_name  "Timing Analyzer.*Fast Model Timing Analyzer Summary"
            }
            set key_prefix "Fast Model "
        }
        "slow" {
            if { $staMode } {
                set panel_name "TimeQuest Timing Analyzer.*Slow Model Hold Summary"
            } else {
                set panel_name  "Timing Analyzer.*Slow Model Timing Analyzer Summary"
            }
            set key_prefix "Slow Model "
        }
        "normal" {
            if { $staMode } {
				set panel_name "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Hold Summary"
		    } else {
				set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
		    }
            set key_prefix ""
        }
        default {
            # Try and extract stuff out of the model string
            if {[regexp -nocase -- {(fast)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer.*Fast ${volts}mV ${temp}C Model Hold Summary"
                } else {
                    set panel_name  "Timing Analyzer.*Fast ${volts}mV ${temp}C Model Timing Analyzer Summary"
                }
                set key_prefix "Fast ${volts}mV ${temp}C Model "
            } elseif {[regexp -nocase -- {(slow)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer.*Slow ${volts}mV ${temp}C Model Hold Summary"
                } else {
                    set panel_name  "Timing Analyzer.*Slow ${volts}mV ${temp}C Model Timing Analyzer Summary"
                }
                set key_prefix "Slow ${volts}mV ${temp}C Model "
            } else {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Hold Summary"
                } else {
                    set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
                }
                set key_prefix ""
            }
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

	catch {get_report_panel_id $panel_name} panel_id
	if {[catch {get_number_of_rows -id $panel_id} row_count]} {
		set row_count 0
	}
	for {set i 1} {$i < $row_count} {incr i} {
		if { $staMode } {
			# START STA MODE
			# Skip the first row
			if { $i == 0 } {
				continue
			}

			if { [catch {get_report_panel_data -id $panel_id -row $i -col_name "Clock"} row_name] } {
				::quartus::dse::ccl::dputs "${debug_name}: $row_name"
				::quartus::dse::ccl::dputs "${debug_name}: Assuming clock is called 'N/A'"
				set row_name "N/A"
			}

			set key "Clock Hold: '${row_name}': Slack"
			catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
			if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => val]} {
				set rarray($key) "$val ns"
			} else {
				set rarray($key) "unknown"
			}

			set key "Clock Hold: '${row_name}': End Point TNS"
			catch {get_report_panel_data -id $panel_id -row $i -col_name "End Point TNS"} val
			if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => val]} {
				set rarray($key) "$val ns"
			} else {
				set rarray($key) "unknown"
			}
			# END STA MODE
		} else {
			if { ![catch {get_report_panel_data -id $panel_id -row $i -col 0} row_name] } {
				if {[regexp -nocase -- {Clock Hold.*:} $row_name]} {
					# Get the slack for this clock
					set key "${row_name}: Slack"
					regsub -- $key_prefix $key {} key
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => slack]} {
						set rarray($key) "$slack ns"
					} else {
						set rarray($key) "unknown"
					}
					# Now get the actual time for this clock
					set key "${row_name}: Actual Time"
					regsub -- $key_prefix $key {} key
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Actual Time"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => actual_time]} {
						set rarray($key) "$actual_time ns"
					} else {
						set rarray($key) "unknown"
					}
					# Now get the number of failing paths for this clock
					set key "${row_name}: Failed Paths"
					regsub -- $key_prefix $key {} key
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Failed Paths"} val
					if {[regexp -nocase -- {(\d+)} $val => failed_paths]} {
						set rarray($key) "$failed_paths"
					} else {
						set rarray($key) "unknown"
					}
				}
			}
		}
	}

    return [array get rarray]
}


#############################################################################
##  Method:  result::__get_clock_recovery_results
##
##  Arguments:
##      <none>
##
##      Gets the clock recovery result values for all the clocks in the design
##      using the Timing Summary table. Returns a list that holds key/value
##      pairs ready for entry into the result db for this compile. Assumes
##      you have a Quartus project open already.
itcl::body ::quartus::dse::result::__get_clock_recovery_results {args} {

    set debug_name "::quartus::dse::result::__get_clock_recovery_results()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    array set rarray [list]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            if { $staMode } {
                set panel_name "TimeQuest Timing Analyzer.*Fast Model Recovery Summary"
            } else {
                set panel_name  "Timing Analyzer.*Fast Model Timing Analyzer Summary"
            }
            set key_prefix "Fast Model "
        }
        "slow" {
            if { $staMode } {
                set panel_name "TimeQuest Timing Analyzer.*Slow Model Recovery Summary"
            } else {
                set panel_name  "Timing Analyzer.*Slow Model Timing Analyzer Summary"
            }
            set key_prefix "Slow Model "
        }
        "normal" {
            if { $staMode } {
				set panel_name "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Recovery Summary"
			} else {
				set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
			}
            set key_prefix ""
        }
        default {
            # Try and extract stuff out of the model string
            if {[regexp -nocase -- {(fast)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer.*Fast ${volts}mV ${temp}C Model Recovery Summary"
                } else {
                    set panel_name  "Timing Analyzer.*Fast ${volts}mV ${temp}C Model Timing Analyzer Summary"
                }
                set key_prefix "Fast ${volts}mV ${temp}C Model "
            } elseif {[regexp -nocase -- {(slow)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer.*Slow ${volts}mV ${temp}C Model Recovery Summary"
                } else {
                    set panel_name  "Timing Analyzer.*Slow ${volts}mV ${temp}C Model Timing Analyzer Summary"
                }
                set key_prefix "Slow ${volts}mV ${temp}C Model "
            } else {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Recovery Summary"
                } else {
                    set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
                }
                set key_prefix ""
            }
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

	catch {get_report_panel_id $panel_name} panel_id
	if {[catch {get_number_of_rows -id $panel_id} row_count]} {
		set row_count 0
	}
	for {set i 1} {$i < $row_count} {incr i} {
		if { $staMode } {
			# START STA MODE
			# Skip the first row
			if { $i == 0 } {
				continue
			}

			if { [catch {get_report_panel_data -id $panel_id -row $i -col_name "Clock"} row_name] } {
				::quartus::dse::ccl::dputs "${debug_name}: $row_name"
				::quartus::dse::ccl::dputs "${debug_name}: Assuming clock is called 'N/A'"
				set row_name "N/A"
			}

			set key "Clock Recovery: '${row_name}': Slack"
			catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
			if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => val]} {
				set rarray($key) "$val ns"
			} else {
				set rarray($key) "unknown"
			}

			set key "Clock Recovery: '${row_name}': End Point TNS"
			catch {get_report_panel_data -id $panel_id -row $i -col_name "End Point TNS"} val
			if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => val]} {
				set rarray($key) "$val ns"
			} else {
				set rarray($key) "unknown"
			}
			# END STA MODE
		} else {
			if { ![catch {get_report_panel_data -id $panel_id -row $i -col 0} row_name] } {
				if {[regexp -nocase -- {Recovery:} $row_name]} {
					# Get the slack for this clock
					set key "${row_name}: Slack"
					regsub -- $key_prefix $key {} key
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => slack]} {
						set rarray($key) "$slack ns"
					} else {
						set rarray($key) "unknown"
					}
					# Now get the actual time for this clock
					set key "${row_name}: Actual Time"
					regsub -- $key_prefix $key {} key
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Actual Time"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => actual_time]} {
						set rarray($key) "$actual_time ns"
					} else {
						set rarray($key) "unknown"
					}
					# Now get the number of failing paths for this clock
					set key "${row_name}: Failed Paths"
					regsub -- $key_prefix $key {} key
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Failed Paths"} val
					if {[regexp -nocase -- {(\d+)} $val => failed_paths]} {
						set rarray($key) "$failed_paths"
					} else {
						set rarray($key) "unknown"
					}
				}
			}
		}
	}

    return [array get rarray]
}


#############################################################################
##  Method:  result::__get_clock_removal_results
##
##  Arguments:
##      <none>
##
##      Gets the clock removal result values for all the clocks in the design
##      using the Timing Summary table. Returns a list that holds key/value
##      pairs ready for entry into the result db for this compile. Assumes
##      you have a Quartus project open already.
itcl::body ::quartus::dse::result::__get_clock_removal_results {args} {

    set debug_name "::quartus::dse::result::__get_clock_removal_results()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $args"

    set         tlist       "model.arg"
    lappend     tlist       "normal"
    lappend     tlist       "Which timing model are we using for this search?"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]
    array set rarray [list]
    # Use the proper timing panel depending on the model we're searching
    switch -- $optshash(model) {
        "fast" {
            if { $staMode } {
                set panel_name "TimeQuest Timing Analyzer.*Fast Model Removal Summary"
            } else {
                set panel_name  "Timing Analyzer.*Fast Model Timing Analyzer Summary"
            }
            set key_prefix "Fast Model "
        }
        "slow" {
            if { $staMode } {
                set panel_name "TimeQuest Timing Analyzer.*Slow Model Removal Summary"
            } else {
                set panel_name  "Timing Analyzer.*Slow Model Timing Analyzer Summary"
            }
            set key_prefix "Slow Model "
        }
        "normal" {
            if { $staMode } {
				set panel_name "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Removal Summary"
			} else {
				set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
			}
			set key_prefix ""
		}
        default {
            # Try and extract stuff out of the model string
            if {[regexp -nocase -- {(fast)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer.*Fast ${volts}mV ${temp}C Model Removal Summary"
                } else {
                    set panel_name  "Timing Analyzer.*Fast ${volts}mV ${temp}C Model Timing Analyzer Summary"
                }
                set key_prefix "Fast ${volts}mV ${temp}C Model "
            } elseif {[regexp -nocase -- {(slow)-(\d+)mV-(\-?\d+)C} $optshash(model) => speed volts temp]} {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer.*Slow ${volts}mV ${temp}C Model Removal Summary"
                } else {
                    set panel_name  "Timing Analyzer.*Slow ${volts}mV ${temp}C Model Timing Analyzer Summary"
                }
                set key_prefix "Slow ${volts}mV ${temp}C Model "
            } else {
                if { $staMode } {
                    set panel_name "TimeQuest Timing Analyzer\\s*\\|\\|\\s*Removal Summary"
                } else {
                    set panel_name  "Timing Analyzer\\s*\\|\\|\\s*Timing Analyzer Summary"
                }
                set key_prefix ""
            }
        }
    }
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

	catch {get_report_panel_id $panel_name} panel_id
	if {[catch {get_number_of_rows -id $panel_id} row_count]} {
		set row_count 0
	}
	for {set i 1} {$i < $row_count} {incr i} {
		if { $staMode } {
			# START STA MODE
			# Skip the first row
			if { $i == 0 } {
				continue
			}

			if { [catch {get_report_panel_data -id $panel_id -row $i -col_name "Clock"} row_name] } {
				::quartus::dse::ccl::dputs "${debug_name}: $row_name"
				::quartus::dse::ccl::dputs "${debug_name}: Assuming clock is called 'N/A'"
				set row_name "N/A"
			}

			set key "Clock Removal: '${row_name}': Slack"
			catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
			if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => val]} {
				set rarray($key) "$val ns"
			} else {
				set rarray($key) "unknown"
			}

			set key "Clock Removal: '${row_name}': End Point TNS"
			catch {get_report_panel_data -id $panel_id -row $i -col_name "End Point TNS"} val
			if {[regexp -nocase -- {([\-]?\d+[\.]?\d*)} $val => val]} {
				set rarray($key) "$val ns"
			} else {
				set rarray($key) "unknown"
			}
			# END STA MODE
		} else {
			if { ![catch {get_report_panel_data -id $panel_id -row $i -col 0} row_name] } {
				if {[regexp -nocase -- {Removal:} $row_name]} {
					# Get the slack for this clock
					set key "${row_name}: Slack"
					regsub -- $key_prefix $key {} key
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Slack"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => slack]} {
						set rarray($key) "$slack ns"
					} else {
						set rarray($key) "unknown"
					}
					# Now get the actual time for this clock
					set key "${row_name}: Actual Time"
					regsub -- $key_prefix $key {} key
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Actual Time"} val
					if {[regexp -nocase -- {([\-]?\d+[\.]?\d*) ns} $val => actual_time]} {
						set rarray($key) "$actual_time ns"
					} else {
						set rarray($key) "unknown"
					}
					# Now get the number of failing paths for this clock
					set key "${row_name}: Failed Paths"
					regsub -- $key_prefix $key {} key
					catch {get_report_panel_data -id $panel_id -row $i -col_name "Failed Paths"} val
					if {[regexp -nocase -- {(\d+)} $val => failed_paths]} {
						set rarray($key) "$failed_paths"
					} else {
						set rarray($key) "unknown"
					}
				}
			}
		}
	}

    return [array get rarray]
}


#############################################################################
##  Procedure:  result::__get_resource_usage_for
##
##  Arguments:
##      res
##          Name of the resource you want the value for.
##
##  Description:
##      Searches the current RDB table space for the resource usage for
##      any resource in the last compile. Returns the usage count or unknown
##      if none could be found. Assumes there is already an open project
##      an RDB database.
itcl::body ::quartus::dse::result::__get_resource_usage_for {res} {

    set debug_name "::quartus::dse::result::__get_resource_usage_for()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting: $res"

    set rcount "unknown"
    set plls_found 0

	set panel_name "Fitter\\s*\\|\\|\\s*Resource Section\\s*\\|\\|\\s*Fitter Resource Usage Summary"
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

	catch {get_report_panel_id $panel_name} panel_id
	if {[catch {get_number_of_rows -id $panel_id} rows]} {
		set rows 0
	}
	for {set x 1} {$x < $rows} {incr x} {
		# Hopefully the format of this column doesn't change!
		set subsystem [lindex [get_report_panel_row -id $panel_id -row $x] 0]
		# Trim white space off the end of the subsystem name
		regsub -- {\s+$} $subsystem {} subsystem
		# Strip leading -'s and spaces from the system name
		regsub -- {^\s*-*\s*} $subsystem {} subsystem
		if {[string equal -nocase $subsystem $res]} {
			# Replace any commas that might be in the digits
			regsub -all {,} [lindex [get_report_panel_row -id $panel_id -row $x] 1] {} tstring
			if {[regexp  {[-+]?(\d+\.?\d*|\.\d+)([eE][-+]?\d+)?} $tstring substring count junk]} {
				set rcount $count
			}
			if {[string equal -nocase $res "Maximum fan-out node"] && [regexp {([\w:\[\]_|]+)} $tstring substring node_name]} {
				set rcount $node_name
			}
			break
		}
	}
	if {[string equal -nocase $res "PLLs"]} {
		set panel_name [lindex [__expand_report_panel_name_list [list "Fitter\\s*\\|\\|\\s*Resource Section\\s*\\|\\|\\s*PLL Summary"]] 0]
		catch {get_report_panel_row -name $panel_name -row 1} first_row
		if {[llength $first_row] > 0} {
			set rcount [llength $first_row]
			set rcount [expr {$rcount} - 1]
		} else {
			set rcount 0
		}
	}

    return $rcount
}


#############################################################################
##  Procedure:  result::__get_all_resource_usage_information
##
##  Arguments:
##		<none>
##
##  Description:
##		Fill in the exist result object with all the resource usage
##		information it can glean from the RDB database. It does not
##		alter the value for each resource usage field so you get all
##		fractions and what not. And it does very little processing
##		on the keys. It adds resource usage information using the
##		non-clobbering addResult call so existing resource information
##		in the object is preserved. Returns true always.
itcl::body ::quartus::dse::result::__get_all_resource_usage_information {} {

    set debug_name "::quartus::dse::result::__get_all_resource_usage_information()"

    set rcount "unknown"
    set plls_found 0

	set panel_name "Fitter\\s*\\|\\|\\s*Resource Section\\s*\\|\\|\\s*Fitter Resource Usage Summary"
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

	catch {get_report_panel_id $panel_name} panel_id
	if {[catch {get_number_of_rows -id $panel_id} rows]} {
		set rows 0
	}
	set section_name ""
	for {set x 1} {$x < $rows} {incr x} {
		# Hopefully the format of this column doesn't change!
		set subsystem [lindex [get_report_panel_row -id $panel_id -row $x] 0]
		# Trim white space off the start/end of the subsystem name
		regsub -- {\s+$} $subsystem {} subsystem
		regsub -- {^\s+} $subsystem {} subsystem
		# Some have * on the end of them...
		regsub -- {\*\s*$} $subsystem {} subsystem

		# Only do this if the subsystem isn't an empty string
		if { ![regexp -- {^\s*$} $subsystem] } {
			# If this subsystem doesn't start with -- it's may be a section name
			# so we should remember it.
			if { ![regexp -- {^\s*--} $subsystem] } {
				set section_name $subsystem
			} else {
				# This is sub-section so we should munge it a little more. First
				# we should lose the --'s:
				regsub -- {^\s*-*\s*} $subsystem {} subsystem
				# And then we should append the section name to this sub-section
				# so it all sorts near each other in the DSE report.
				set subsystem "${section_name}: $subsystem"
			}
			regsub -- {^\s*-*\s*} $subsystem {} subsystem
			# We're doing no manipulations to resource count string for this
			# system/sub-system. So add it as we find it...but don't add
			# something that has no actual value for its resource count
			set rcount [lindex [get_report_panel_row -id $panel_id -row $x] 1]
			if { ![regexp -- {^\s*$} $rcount] } {
				addResult -name $subsystem -value $rcount
			}
		}
	}

    return 1
}


#############################################################################
##  Procedure:  result::__get_power_estimates
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns a list of the power estimations for this design. Fields
##      will be set to "unknown" if no estimate can be found.
itcl::body ::quartus::dse::result::__get_power_estimates {} {

    set debug_name "::quartus::dse::result::__get_power_estimates()"
	::quartus::dse::ccl::dputs "${debug_name}: Starting"

    array set powest [list]
    foreach {key} [list "Total Thermal Power Dissipation" "Core Dynamic Thermal Power Dissipation" "Core Static Thermal Power Dissipation" "I/O Thermal Power Dissipation" "Power Estimation Confidence"] {
        set powest($key) "unknown"
        set powest($key) "unknown"
        set powest($key) "unknown"
    }

	set panel_name "PowerPlay Power Analyzer\\s*\\|\\|\\s*PowerPlay Power Analyzer Summary"
	# Turn our panel names, which contain patterns, into fully qualified panel names
	set panel_name [lindex [__expand_report_panel_name_list [list $panel_name]] 0]

	catch {get_report_panel_id $panel_name} panel
	if {[catch {get_number_of_rows -id $panel} rows]} {
		set rows 0
	}
	for {set x 1} {$x < $rows} {incr x} {
		# Hopefully the format of this column doesn't change!
		set subsystem [lindex [get_report_panel_row -id $panel -row $x] 0]
		foreach powkey [array names powest] {
			if {[string equal -nocase $subsystem $powkey]} {
				::quartus::dse::ccl::dputs "${debug_name}: Found row key: $powkey"
				# Replace any commas that might be in the digits
				regsub -all {,} [lindex [get_report_panel_row -id $panel -row $x] 1] {} tstring
				if {[regexp  {[-+]?(\d+\.?\d*|\.\d+)([eE][-+]?\d+)?} $tstring substring estimate junk]} {
					::quartus::dse::ccl::dputs "${debug_name}: Found row value: $estimate"
					set powest($powkey) "$estimate mW"
				} elseif {![regexp {^\s*$} $tstring]} {
					# If it's not an empty string don't fiddle with it
					::quartus::dse::ccl::dputs "${debug_name}: Found row value: $estimate"
					set powest($powkey) "$tstring"
				}
			}
		}
	}
    return [array get powest]
}


#############################################################################
##  Method:  result::getAllResults
##
##  Arguments:
##
##  Description:
itcl::body ::quartus::dse::result::getAllResults {} {

    set debug_name "::quartus::dse::result::getAllResults()"

    return [array get arrayResults]
}


#############################################################################
##  Method:  result::getResults
##
##  Arguments:
##      Choose one of the following type of matching ways to get
##      the list of results:
##
##          -regexp <pattern>
##              Use regular-expression matching to get a list
##              of results.
##
##          -exact <string>
##              Use [string equal] type matching to get a
##              list of results.
##
##          -glob <pattern>
##              Use [string match] type matching to get a
##              list of results. This is the default way to
##              match if no type is specified.
##
##  Description:
itcl::body ::quartus::dse::result::getResults {args} {

    set debug_name "::quartus::dse::result::getResults()"

    set retval [list]

    # Command line options to this function we require
    set         tlist       "regexp"
    lappend     tlist       0
    lappend     tlist       "Use regular expression matching"
    lappend function_opts $tlist

    set         tlist       "exact"
    lappend     tlist       0
    lappend     tlist       "Use string equal matching"
    lappend function_opts $tlist

    set         tlist       "glob"
    lappend     tlist       1
    lappend     tlist       "Use string match matching"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    set cont 1
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            ::quartus::dse::ccl::dputs "${debug_name}: Error: Missing required option: -$opt"
            set cont 0
        }
    }

    # $args should have one thing left: a pattern of some sort
    if {[llength $args] < 1} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: Missing a pattern to match"
        set cont 0
    }

    if {$cont} {
        # First argument on args is the first of the unknown
        # arguments that getFunctionOptions encountered, so
        # that's our pattern we should be matching against.
        set pattern [lindex $args 0]
        set keylist [list]
        if {$optshash(regexp)} {
            #::quartus::dse::ccl::dputs "${debug_name}: Using regexp matching"
            set keylist [array names arrayResults -regexp $pattern]
        } elseif {$optshash(exact)} {
            #::quartus::dse::ccl::dputs "${debug_name}: Using \[string equal\] matching"
            set keylist [array names arrayResults -exact $pattern]
        } else {
            #::quartus::dse::ccl::dputs "${debug_name}: Using \[string match\] matching"
            set keylist [array names arrayResults -glob $pattern]
        }

        # For every key we found get the value and put the
        # key and the value on the retval list.
        foreach key $keylist {
            lappend retval $key
            lappend retval $arrayResults($key)
        }
    }

    return $retval
}


#############################################################################
##  Method:  result::addResult
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -name <name>
##              Required. The name to add the value as in the results
##              hash.
##
##          -value <value>
##              Required. The value to add under <name> in the results
##              hash
##
##          -nocomplain
##              Optional. If true then existing values in the results
##              hash are overwritten. If this option is not supplied
##              then the function does not overwrite existing values.
##
##          -skip-unknown
##              Optional. If true then a result with -value equal to
##				to the string "unknown" is quietly skipped and not
##				added to the result hash for this object.
##
##  Description:
##      Sets a value in the results hash for this object. Does not
##      overwrite existing values unless the -nocomplain option is
##      passed to the function. Returns true (1) if the value is
##      written, returns (0) otherwise. Throw and error if a required
##      option is missing.
itcl::body ::quartus::dse::result::addResult {args} {

    set debug_name "::quartus::dse::result::addResult()"

    set retval 0

    # Command line options to this function we require
    set         tlist       "name.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The name of the value to add"
    lappend function_opts $tlist

    set         tlist       "value.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The value to add"
    lappend function_opts $tlist

    set         tlist       "nocomplain"
    lappend     tlist       0
    lappend     tlist       "If true, overwrite existing otherwise existing not overwritten"
    lappend function_opts $tlist

	set         tlist       "skip-unknown"
	lappend     tlist       0
	lappend     tlist       "If true, don't add this result if the value is unknown"
	lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    set cont 1
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            ::quartus::dse::ccl::dputs "${debug_name}: Error: Missing required option: -$opt"
            set cont 0
        }
    }

    if {$cont} {
		if { $optshash(skip-unknown) && [string equal -nocase $optshash(value) "unknown"] } {
			::quartus::dse::ccl::dputs "${debug_name}: Skipping unknown result $optshash(name) = $optshash(value)"
			set retval 1
		} else {
			if {![info exists arrayResults($optshash(name))] || $optshash(nocomplain)} {
				::quartus::dse::ccl::dputs "${debug_name}: Adding result $optshash(name) = $optshash(value)"
				set arrayResults($optshash(name)) $optshash(value)
				set retval 1
			} else {
				::quartus::dse::ccl::dputs "${debug_name}: Error: Result with name $optshash(name) found in array already."
				::quartus::dse::ccl::dputs "${debug_name}:        Delete existing result before adding result or use"
				::quartus::dse::ccl::dputs "${debug_name}:        the -nocomplain option to overwrite existing result."
			}
		}
    }

    return $retval

}


#############################################################################
##  Method:  result::addSettings
##
##  Arguments:
##      args
##          A set of name/value pairs suitable for array-ifying.
##
##  Description:
itcl::body ::quartus::dse::result::addSettings {args} {

    set debug_name "::quartus::dse::result::addSettings()"

    set retval 1

    # Turn args into an array
    array set ta [join $args]

    # Add these settings to the existing settings
    foreach key [array names ta] {
        ::quartus::dse::ccl::dputs "${debug_name}: Adding setting: $key = $ta($key)"
        set arraySettings($key) $ta($key)
    }

    # Generate a new finger print for this object using the new
    # settings that were added. Generate it relative to itself.
    # This ensures the fingerprint doesn't go stale.
    $this setFingerPrint [$this generateFingerPrint -base $this]

    return $retval
}


#############################################################################
##  Method:  result::getAllSettings
##
##  Arguments:
##
##  Description:
itcl::body ::quartus::dse::result::getAllSettings {} {

    set debug_name "::quartus::dse::result::getAllSettings()"

    return [array get arraySettings]

}


#############################################################################
##  Method:  result::getFingerPrint
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns the fingerprint for this results
itcl::body ::quartus::dse::result::getFingerPrint {} {

    set debug_name "::quartus::dse::result::getFingerPrint()"

    return $fingerprint

}


#############################################################################
##  Method:  result::setFingerPrint
##
##  Arguments:
##      fingerprint
##          The fingerprint to set.
##
##  Description:
##      Returns the old fingerprint value.
itcl::body ::quartus::dse::result::setFingerPrint {fp} {

    set debug_name "::quartus::dse::result::setFingerPrint()"

    set fp_save $fingerprint
    set fingerprint $fp
    return $fp_save

}


#############################################################################
##  Method:  result::deleteResults
##
##  Arguments:
##      pattern
##          Optional. A [string match] glob-style pattern to match. All
##          keys in the results hash matching this pattern will be
##          deleted, along with their values. If no pattern is supplied
##          then all keys are deleted.
##
##  Description:
##      Quietly deletes all keys matching $pattern -OR- if $pattern is
##      omitted it deletes EVERYTHING in the results hash, so do be
##      carefully okay? Returns 1 always.
itcl::body ::quartus::dse::result::deleteResults {{pattern "#_all_#"}} {

    set debug_name "::quartus::dse::result::addResult()"

    if {[string equal $pattern "#_all_#"]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Deleted all results"
        catch {array unset arrayResults}
    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Deleting results that match $pattern"
        catch {array unset arrayResults $pattern}
    }

    $this setFingerPrint [$this generateFingerPrint -base $this]

    return 1
}


#############################################################################
##  Method:  result::archive
##
##  Arguments:
##      arcfile
##          The name of the archive, without a directory, to archive
##          the results in.
##
##  Description:
##      Archives the current results for you.
itcl::body ::quartus::dse::result::archive {arcfile} {

    set debug_name "::quartus::dse::result::archive()"

    regsub -nocase -- {\.qar$} $arcfile {} arcfile

    set retval 0
    set cont 1

    # Archive
    set arcdir [file join dse]
    # Make arcdir if it doesn't exist already
    if {![file isdirectory $arcdir]} {
        if {[catch {file mkdir $arcdir}]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Archiving failed: couldn't make archive directory $arcdir"
            set cont 0
            set retval 0
        }
    }
    if {$cont} {
        ::quartus::dse::ccl::dputs "${debug_name}: Attempting to save [file join $arcdir ${arcfile}.qar]"
        project_open -force -revision $strCmpName $strProjectName
        if {[::quartus::dse::ccl::archive $arcfile $arcdir] > 0} {
            ::quartus::dse::ccl::dputs "${debug_name}: Success"
            set strArchiveName "${arcfile}.qar"
            set retval 1
        }
        project_close
    }

    return $retval
}


#############################################################################
##  Method:  result::unarchive
##
##  Arguments:
##      <none>
##
##  Description:
##      Unarchives the result if it was archived already. Returns true if
##      it was able to unarchive the result. False if no archive exists.
##      It errors if unarchiving fails.
itcl::body ::quartus::dse::result::unarchive {} {

    set debug_name "::quartus::dse::result::unarchive()"

    set retval 0
    set cont 1

    if {$strArchiveName == ""} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: No archive for this result was ever made"
        set cont 0
    }

    if {![file exists [file join dse ${strArchiveName}]]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: Archive [file join dse ${strArchiveName}] not found"
        set cont 0
    }

    if {$cont} {
        # Unarchive this point
        set arcdir [file join dse]
        set arcfile $strArchiveName
        ::quartus::dse::ccl::dputs "${debug_name}: Attempting to restore [file join $arcdir ${arcfile}]"
        set retval [::quartus::dse::ccl::unarchive $arcfile $arcdir]
    }

    return $retval
}


#############################################################################
##  Method:  result::restoreRevision
##
##  Arguments:
##      <none>
##
##  Description:
##      Restores the result as the default revision. Returns
##      true if restoration was successfull. False if it was not.
itcl::body ::quartus::dse::result::restoreRevision {args} {

    set debug_name "::quartus::dse::result::restoreRevision()"

    set tlist [list "delete.arg" "#_optional_#" "Optional revision to delete"]
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    if {$strCmpName == "" || ![revision_exists -project $strProjectName $strCmpName]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: No revision for this result was ever made"
        return 0
    }

    if {[string equal $optshash(delete) $strCmpName]} {
        return 0
    }

    # Make the revision the current revision
    project_open -force -revision $strCmpName $strProjectName
    set_current_revision $strCmpName
    ::quartus::dse::ccl::dputs "${debug_name}: Restored revision $strCmpName"
    if {$optshash(delete) != "#_optional_#"} {
        # User wants to delete a revision that exists
        catch {delete_revision $optshash(delete)}
        catch {eval file delete -force [glob -nocomplain -dir . "$optshash(delete).*"]}
        catch {eval file delete -force [glob -nocomplain -dir db "$optshash(delete).*"]}
        ::quartus::dse::ccl::dputs "${debug_name}: Deleted revision $optshash(delete)"
    }
    project_close

    return 1
}


#############################################################################
##  Method:  result::makeRevision
##
##  Arguments:
##      -name <name>
##          Required. Name of the revision to create.
##
##      -default
##          If passed sets the new revision created as
##          the default revision. Otherwise it keeps
##          the current default revision.
##
##  Description:
##      Creates a new revision for this result using the
##      settings stored at this result and based on the
##      existing revision for this result. Returns true
##      if revision was created successfully. Otherwise
##      false.
itcl::body ::quartus::dse::result::makeRevision {args} {

    set debug_name "::quartus::dse::result::makeRevision()"

    set tlist [list "make-default" 0 "Makes new revision the default revision"]
    lappend function_opts $tlist
    set tlist [list "name.arg" "#_required_#" "Name of new revision to create"]
    lappend function_opts $tlist
	set tlist [list "comment.arg" "" "Optional comment for the new revision"]
	lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            ::quartus::dse::ccl::dputs "${debug_name}: Error: Missing required option: -$opt"
            return -code error "Missing required option: -${opt}"
        }
    }

    if {![project_exists $strProjectName]} {
        # Project can't be found
        return -code error "ERROR: Project $strProjectName not found"
    }

    if {$strCmpName == "" || ![revision_exists -project $strProjectName $strCmpName]} {
        # Base new revision on current default revision
        set strCmpName [get_current_revision $strProjectName]
    }

    # Get the current revision name
    set original_revision_name [get_current_revision $strProjectName]

    project_open -force -revision $strCmpName $strProjectName

    if {[catch {create_revision -based_on $strCmpName -copy_results -set_current $optshash(name)} msg]} {
        # Error creating revision. That's not good!
        project_close
        return -code error $msg
    }
    set_current_revision $optshash(name)
    # Now merge in the settings
    foreach {param value} [array get arraySettings] {
        if {[regexp -nocase {^-} $param]} {
            # Ignore settings that begin with a '-'
        } else {
            # It's a Quartus II ACF setting...
            # Try to apply as a global setting, if that doesn't work
            # make a leap-of-faith and assume the project_name is the
            # same as the top level entity.  The other thing to try is
            # to use wildcards but it seems not everything supports this.
            # Is that true?
            if {[catch {set_global_assignment -name $param $value} msg]} {
                # Not sure if this should be an error or not...
            }
        }
    }

        if {![regexp -nocase -- {^\s*$} $optshash(comment)]} {
                set_revision_description -description $optshash(comment) $optshash(name)
        }

        export_assignments

    # Do we make this new revision the current revision?
    if {!$optshash(make-default)} {
        set_current_revision $original_revision_name
        ::quartus::dse::ccl::dputs "${debug_name}: Set new revision $optshash(name) as current revision"
    }

    project_close

    # Now change the revision for this result
    set strCmpName $optshash(name)

    # Now run special actions
    foreach {param value} [array get arraySettings] {
        if {[regexp -nocase {^-} $param]} {
            # Do any setup actions
            switch -- $param {
                {-setup-script} {
                    if {[regexp -- {([a-zA-Z_]+):(.*)} $value => e f]} {
                        set input "\"[file join $::quartus(binpath) $e]\" -t \"$f\" $strProjectName $strCmpName"
                        set output "${e}.out"
                        set result [::quartus::dse::ccl::dse_exec $input $output]
                    }
                }
            }
        }
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Made revision $optshash(name) from result settings"

    return 1
}


#############################################################################
##  Method:  result::makeHardCopyRevision
##
##  Arguments:
##      <none>
##
##  Description:
##      Doesn't actually make a revision since revisions
##      are not supported by the hardcopy flow. Instead
##      it applies the settings to this design and
##      leave it at that. Returns true if settings are
##      applied successfully. Otherwise false.
itcl::body ::quartus::dse::result::makeHardCopyRevision {args} {

    set debug_name "::quartus::dse::result::makeHardCopyRevision()"

    set tlist [list "make-default" 0 "Does not apply to this function"]
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            ::quartus::dse::ccl::dputs "${debug_name}: Error: Missing required option: -$opt"
            return -code error "Missing required option: -${opt}"
        }
    }

    if {![project_exists $strProjectName]} {
        # Project can't be found
        return -code error "ERROR: Project $strProjectName not found"
    }

    if {$strCmpName == "" || ![revision_exists -project $strProjectName $strCmpName]} {
        # Base new revision on current default revision
        set strCmpName [get_current_revision $strProjectName]
    }

    # Get the current revision name
    set original_revision_name [get_current_revision $strProjectName]

    project_open -force -revision $strCmpName $strProjectName

    # Now merge in the settings
    foreach {param value} [array get arraySettings] {
        if {[regexp -nocase {^-} $param]} {
            # Ignore settings that begin with a '-'
        } else {
            # It's a Quartus II ACF setting...
            # Try to apply as a global setting, if that doesn't work
            # make a leap-of-faith and assume the project_name is the
            # same as the top level entity.  The other thing to try is
            # to use wildcards but it seems not everything supports this.
            # Is that true?
            if {[catch {set_global_assignment -name $param $value} msg]} {
                # Not sure if this should be an error or not...
            }
        }
    }
    export_assignments

    project_close

    # Now run special actions
    foreach {param value} [array get arraySettings] {
        if {[regexp -nocase {^-} $param]} {
            # Do any setup actions
            switch -- $param {
                {-setup-script} {
                    if {[regexp -- {([a-zA-Z_]+):(.*)} $value => e f]} {
                        set input "\"[file join $::quartus(binpath) $e]\" -t \"$f\" $strProjectName $strCmpName"
                        set output "${e}.out"
                        set result [::quartus::dse::ccl::dse_exec $input $output]
                    }
                }
            }
        }
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Made HardCopy revision from result settings"

    return 1
}


#############################################################################
##  Method:  result::isBest
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns true (1) if this result object is tagged as the best result
##      otherwise it returns false (0).
itcl::body ::quartus::dse::result::isBest {} {

    set debug_name "::quartus::dse::result::isBest()"

    return $boolIsBest
}


#############################################################################
##  Method:  result::setBest
##
##  Arguments:
##      int
##          Pass 1 if you want to make this the best result, 0 if you
##          don't want this to be the best result.
##
##  Description:
##      Sets the best result flag to 0 or 1 depending on what you pass.
itcl::body ::quartus::dse::result::setBest {int} {

    set debug_name "::quartus::dse::result::setBest()"

    if {$int != 0 && $int != 1} {
        return -code error "result::isBest(): requires either 0 or 1 as argument"
    }

    set boolIsBest $int

    return 1
}


#############################################################################
##  Method:  result::isCompiled
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns true (1) if this result object is compiled otherwise
##      it returns false (0).
itcl::body ::quartus::dse::result::isCompiled {} {

    set debug_name "::quartus::dse::result::isCompiled()"

    return $boolWasCompiled
}


#############################################################################
##  Method:  result::setCompiled
##
##  Arguments:
##      int
##          Pass 1 if you want to tag result as having been compiled, 0
##          if you want to tag it as not having been compiled.
##
##  Description:
##      Sets the compiled flag on this result.
itcl::body ::quartus::dse::result::setCompiled {int} {

    set debug_name "::quartus::dse::result::setCompiled()"

    if {$int != 0 && $int != 1} {
        return -code error "${debug_name}: requires either 0 or 1 as argument"
    }

    set boolWasCompiled $int

    return 1
}


#############################################################################
##  Method:  result::getName
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns the name for this result object. An empty string if the
##      name has never been set.
itcl::body ::quartus::dse::result::getName {} {

    set debug_name "::quartus::dse::result::getName()"

    return $strName
}


#############################################################################
##  Method:  result::setName
##
##  Arguments:
##      string
##          Name for this result object.
##
##  Description:
##      Sets the name for this result object.
itcl::body ::quartus::dse::result::setName {name} {

    set debug_name "::quartus::dse::result::setName()"

    set strName $name

    return 1
}


#############################################################################
##  Method:  generateFingerPrint
##
##  Arguments:
##      -base <result>
##          The base result object
##
##  Description:
##      Generates a fingerprint by taking the base settings and applying
##      the settings from this result object to the base settings to
##      get a final setting group. It uses these merged settings to
##      create a fingerprint for this object.
itcl::body ::quartus::dse::result::generateFingerPrint {args} {

    set debug_name "::quartus::dse::result::generateFingerPrint()"

    set         tlist       "base.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The base result object"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            ::quartus::dse::ccl::dputs "${debug_name}: Error: Missing required option: -$opt"
            return -code error "Missing required option: -${opt}"
        }
    }

    # Make sure base is a result object
    if {$optshash(base) == "" || ![$optshash(base) isa ::quartus::dse::result]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: -base is not a result object"
        return -code error "-base is not a result object"
    }

    # Make an array of the base settings, but upper case all keys and vals
    foreach {key val} [$optshash(base) getAllSettings] {
        set ta([string toupper $key]) [string toupper $val]
    }

    # And now apply the settings from $this, upper case everything
    foreach {key val} [$this getAllSettings] {
        set ta([string toupper $key]) [string toupper $val]
    }

    # Generate the fingerprint for this temp array by sorting the keys
    # in the array and making a long key = value string.
    set fpstr ""
    foreach key [lsort -ascii [array names ta]] {
        set fpstr [concat $fpstr "$key = $ta($key)"]
    }
    set tf [md5::md5 -- $fpstr]

    return $tf
}


#############################################################################
##  Method:  duplicate
##
##  Arguments:
##      <none>
##
##  Description:
##      Creates a duplicate instance of this object and returns a pointer
##      to the duplicate instance. Useful if you want to generate two
##      result objects from one revision instance and store two different
##      result sets (like when we do fast and slow timing analysis).
##
##      Example use:
##          set r1 [::quartus::dse::result #auto $proj $cmp]
##          set r2 [$r1 duplicate]
##
##      Now $r2 is a duplicate of $r1 but NOT THE SAME OBJECT as $r1. So
##      changes to $r1 are not reflected in $r2 and vice versa.
itcl::body ::quartus::dse::result::duplicate {} {

    set debug_name "::quartus::dse::result::duplicate()"

    # Create a new result object
    set that [uplevel #0 ::quartus::dse::result #auto [$this cget -strProjectName] [$this cget -strCmpName]]
    ::quartus::dse::ccl::dputs "${debug_name}: Creating duplicate of result object $this as $that"

    # Copy the project settings from this object to the new one
    foreach {key val} [$this getAllSettings] {
        $that addSettings [list $key $val]
    }

    # Copy the results from this object to the new one
    foreach {key val} [$this getAllResults] {
        $that addResult -name $key -value $val -nocomplain
    }

    # Copy some of the flags and stuff to the new object
    $that setBest [$this isBest]
    $that setFingerPrint [$this getFingerPrint]
    $that setCompiled [$this isCompiled]

    return $that
}

#############################################################################
##  Procedure:  get_all_compile_groups
##
##  Arguments:
##      -results <arrayname>
##          The name of an array of result objects. These are searched
##          to gather compile groups. The result whose key is "base" in
##          the array is ignored. This is a pass by reference.
##
##  Description:
##      Returns a list, suitable for turning into an array with [array set]
##      that holds keys that represent compile groups and values that are
##      lists of all the keys in the results array you passed that
##      have results in this compile group. Compile groups are all the
##      results that have the same settings when you EXCLUDE the SEED
##      setting.
proc ::quartus::dse::result::get_all_compile_groups {args} {

    set debug_name "::quartus::dse::result::get_all_compile_groups()"


    set         tlist       "results.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The results array"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            ::quartus::dse::ccl::dputs "${debug_name}: Error: Missing required option: -$opt"
            return -code error "Missing required option: -${opt}"
        }
    }

    # Bring their results into our namespace
    upvar 1 $optshash(results) results

    array set cary [list]
    array set fprinttocgroup [list]
    set cgroup_counter 1

    foreach r [array names results] {
        if {$results($r) == "" || ![$results($r) isa ::quartus::dse::result]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Skipping $r -- not a result"
        } else {
            # Skip base
            if {[regexp -nocase -- {base} $r]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Skipping $r -- base result"
            } else {
                # Get all the settings for this result
                array set tary [$results($r) getAllSettings]
				# Remove the SEED setting
				array unset tary SEED
				# Duplicate this result object with SEED omitted
				set newresultobj [uplevel #0 ::quartus::dse::result #auto [$results($r) cget -strProjectName] [$results($r) cget -strCmpName]]
				$newresultobj addSettings [array get tary]
				set fingerprint [$newresultobj getFingerPrint]

                if {[info exists fprinttocgroup($fingerprint)]} {
                    ::quartus::dse::ccl::dputs "${debug_name}: Finger print found -- appending to existing compile group"
                    set cgroup $fprinttocgroup($fingerprint)
                } else {
                    ::quartus::dse::ccl::dputs "${debug_name}: Finger print not found -- creating new compile group"
                    set cgroup $cgroup_counter
                    set fprinttocgroup($fingerprint) $cgroup
                    incr cgroup_counter
                }
                ::quartus::dse::ccl::dputs "${debug_name}: Adding result $r to compile group $cgroup"
                lappend cary($cgroup) $r
                catch {array unset tary}
            }
        }
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Returning [array get cary]"
    return [array get cary]
}

#############################################################################
##  Procedure:  extract_results_from_sta
##
##  Arguments:
##
##  Description:
##
proc ::quartus::dse::result::extract_results_from_sta {args} {

    set debug_name "::quartus::dse::result::extract_results_from_sta()"

    set         tlist       "project.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The results array"
    lappend function_opts $tlist

	set         tlist       "revision.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The results array"
    lappend function_opts $tlist

	set         tlist       "point.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The results array"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            ::quartus::dse::ccl::dputs "${debug_name}: Error: Missing required option: -$opt"
            return -code error "Missing required option: -${opt}"
        }
    }

	set staargs [list "--script" "\"[file join $::quartus(tclpath) packages dse sta-helper.tcl]\"" "-project" "\"$optshash(project)\"" "-revision" "\"$optshash(revision)\"" "-command" "extract_timing" "-point" "\"$optshash(point)\""]
	set input "\"[file join $::quartus(binpath) quartus_sta]\" [join $staargs]"
    set output "sta-helper.out"
	set ret_val [::quartus::dse::ccl::dse_exec $input $output]
	catch {file delete -force -- $output}
	# TDB: Check to see if the XML files were produced or not...
	::quartus::dse::ccl::dputs "${debug_name}: Returning 1"
	return 1
}
