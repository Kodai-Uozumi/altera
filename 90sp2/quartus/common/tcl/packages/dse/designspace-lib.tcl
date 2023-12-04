
#############################################################################
##  designspace-lib.tcl
##
##  Provides the design space object code for DSE.
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

package provide ::quartus::dse::designspace 1.0


#############################################################################
##  Additional Packages Required
package require Itcl
package require xmlgen
package require xml
package require report
package require ::quartus::dse::ccl
package require ::quartus::dse::result
package require ::quartus::misc
load_package project


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse::designspace {
    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
}


#############################################################################
##  Class:  designspace
##
##  Description:
##      The designspace object holds a complete definition of design space.
##      It provides methods to save and load a design space to and from
##      the file system. Methods for retrieving information about a design
##      space. Methods for pruning and itterating through a design space.
##      And methods for setting up design space points before calling
##      the Quartus tools to map and compile the point.
itcl::class ::quartus::dse::designspace {

    constructor {_project_name {_cmp_name "#unknown"}} {
        ::quartus::dse::ccl::dputs "class designspace $this constructor"
        set strProjectName $_project_name
        if {$_cmp_name == "#unknown"} {
            set strCmpName $_project_name
        } else {
            set strCmpName $_cmp_name
        }

        # Make some of our variable arrays
        array set arraySpace [list]
        array set arraySpaceEnable [list]
        array set arraySpaceItterator [list]
    }

    destructor {
        ::quartus::dse::ccl::dputs "class designspace $this destructor"

        catch {unset strProjectName strCmpName strArchiveDir boolSaveMaps boolSaveFits}
        catch {array unset arraySpace}
        catch {array unset arraySpaceEnable}
        catch {array unset arraySpaceItterator}
    }

    #########################################################################
    ##  Private Class Variables
    ##
    private variable arraySpace

    private variable arraySpaceEnable

    private variable arraySpaceItterator

    private variable strArchiveDir "dse"

    private variable boolSaveMaps 1
    private variable boolSaveFits 1

    private variable listSpaceTraversalOrder

    # Variables used by loadXML to store data and context state.
    private variable _xml_context
    private variable _xml_context_object
    private variable _xml_content_buildup
    private variable _xml_point_buildup


    #########################################################################
    ##  Public Class Variables
    ##
    public variable strProjectName
    public variable strCmpName


    #########################################################################
    ##  Private Class Methods
    ##
    #private method archiveCurrentMap {_arcname}
    #private method archiveCurrentFit {_arcname}

    # Methods using by dumpXML to handle internal data dumping.
    private method _xmlDumpPoints {channel space}


    #########################################################################
    ##  Public Class Methods
    ##
    public method addPoint {space ind args}

    public method deletePoints {space args}

    public method enablePoints {space args}

    public method disablePoints {space args}

    public method resetItterator {space}

    public method getItterator {space}

    public method nextPoint {space}

    public method prevPoint {space}

    public method morePoints {space}

    public method clearDesignSpace {{space "#_all_#"}}

    public method getSpaces {}

    public method getSizeOfSpace {space}

    public method getParams {space {ind "#_current_#"}}

    public method getAllParams {space}

    public method getPointsWithParams {space args}

    public method getPointsWithParamsExactly {space args}

    public method createPoint {space {ind "#_current_#"}}

    public method savePoint {space {ind "#_current_#"}}

    public method restorePoint {space {ind "#_current_#"}}

    public method getTraversalOrder {}

    public method setTraversalOrder {args}

    # Read and write data from file handles
    public method dumpXML {{channel stdout}}
    public method loadXML {{channel stdin} {test 0}}

    # Methods using by loadXML to handle events fired by parser.
    # They're public because the parse needs access to them. You
    # probably shouldn't ever call these yourself.
    public method _xmlCharacterData {data}
    public method _xmlElementStart {name attlist args}
    public method _xmlElementEnd {name args}
    public method _xmlError {errorcode errormsg}

}


#############################################################################
##  Method:  designspace::loadXML
##
##  Arguments:
##      channel
##          Optional channel to gather XML information from. If no
##          channel is specified the method tries to use stdin.
##
##      test
##          Optional boolean. If true we use the test set of functions
##          when parsing the XML instead of the "regular" set of
##          functions. Lets you try out XML parsing stuff without
##          messing with the complicated regular functions that work
##          already.
##
##  Description:
##      Loads information from an XML file. Returns true
##      if loading was successful, false if it wasn't. This
##      function does not destroy existing data in the design
##      space object, rather it adds it to the current design
##      space.
itcl::body ::quartus::dse::designspace::loadXML {{channel stdin} {test 0}} {

    # Reference to commands the parser calls to deal with events
    if {$test} {
        set cdata       "$this  _xmlCharacterDataTest"
        set elemstart   "$this  _xmlElementStartTest"
        set elemend     "$this  _xmlElementEndTest"
        set err         "$this  _xmlErrorTest"
    } else {
        set cdata       "$this  _xmlCharacterData"
        set elemstart   "$this  _xmlElementStart"
        set elemend     "$this  _xmlElementEnd"
        set err         "$this  _xmlError"
    }

    # Clear parsing state variables
    catch {unset _xml_content_buildup _xml_context _xml_context_object _xml_point_buildup}
    set _xml_context [list]
    set _xml_context_object [list]

    # Create a new xml::parser. Kind of messy because I have to write
    # the commands for each tag in-line. As the objects we save
    # in the x2a object grow you'll need to grow the
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
    ::quartus::dse::ccl::dputs "designspace::loadXML(): finished successfully in [expr {$load_end_time - $load_start_time}] seconds"
    return 1
}


#############################################################################
##  Method:  designspace::dumpXML
##
##  Arguments:
##      channel
##          Optional channel to dump the XML. If none is given
##          defaults to stdout.
##
##  Description:
##      Dumps an XML representation of the designspace object
##      to $channel. If no channel is specified then it dumps
##      to stdout. Calls some private helper functions to
##      accomplish this goal. This function can throw a Tcl/Tk
##      error if something goes wrong so catch it if you want
##      to recover gracefully. It returns 1 on success.
itcl::body ::quartus::dse::designspace::dumpXML {{channel stdout}} {
    ::xmlgen::declaretag _xml_designspace DESIGNSPACE
    ::xmlgen::declaretag _xml_copyright COPYRIGHT
    ::xmlgen::declaretag _xml_map MAP
    ::xmlgen::declaretag _xml_fit FIT

    set copyright "\n\n$::quartus(copyright). All rights reserved.\n"
    append copyright "This information and code is highly confidential and proprietary\n"
    append copyright "information and code of Altera and is being provided in accordance\n"
    append copyright "with and subject to the protections of a non-disclosure agreement\n"
    append copyright "which governs its use and disclosure.  Altera products and services\n"
    append copyright "are protected under numerous U.S. and foreign patents, maskwork rights\n"
    append copyright "copyrights and other intellectual property laws.  Altera assumes no\n"
    append copyright "responsibility or liability arising out of the application or use\n"
    append copyright "of this information and code. This notice must be retained and\n"
    append copyright "reprinted on any copies of this information and code that are\n"
    append copyright "permitted to be made.\n\n"

    ::xmlgen::channel $channel {
        _xml_designspace ! {
            _xml_copyright - [::xmlgen::esc ${copyright}]
            foreach space [$this getTraversalOrder] {
                _xmlDumpPoints $channel $space
            }
        }
    }
    puts $channel "\n"
    return 1
}


#############################################################################
##  Method:  designspace::_xmlDumpPoints
##
##  Arguments:
##      channel
##          Optional channel to dump the XML. If none is given
##          defaults to stdout.
##
##      space
##          The type of points you want dumped.
##
##  Description:
##      Dumps an XML representation of the Map points in
##      this designspace object.
itcl::body ::quartus::dse::designspace::_xmlDumpPoints {channel space} {
    ::xmlgen::declaretag _xml_point POINT
    ::xmlgen::declaretag _xml_param PARAM

    # Space has to exist. If not, error...
    if {![info exists arraySpace($space)] || ![info exists arraySpaceEnable($space)]} {
        return -code error "Space $space not found in the designspace object"
    }

    set dumpList $arraySpace($space)
    set dumpListEnable $arraySpaceEnable($space)

    ::xmlgen::channel $channel {
        for {set i 0} {$i < [llength $dumpList]} {incr i} {
            _xml_point space=${space} enabled=[lindex $dumpListEnable $i] ! {
                foreach {param val} [lindex $dumpList $i] {
                    _xml_param name=[::xmlgen::esc ${param}] - [::xmlgen::esc ${val}]
                }
            }
        }
    }

    return 1
}


#############################################################################
##  Method:  designspace::_xmlCharacterData
##
##  Arguments:
##      data
##
##  Description:
##      Handler function used by the loadXML routine to deal with
##      character data as it's encountered in the XML file stream.
##      Register this handler with the XML parser.
itcl::body ::quartus::dse::designspace::_xmlCharacterData {data} {

    # Get the current context and context_object
    set context [lindex $_xml_context end]
    set context_object [lindex $_xml_context_object end]

    switch -- $context {
        COPYRIGHT {
            append _xml_content_buildup $data
        }
        PARAM {
            append _xml_content_buildup $data
        }
        default {
            # Do nothing
        }
    }
}


#############################################################################
##  Method:  designspace::_xmlElementStart
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
itcl::body ::quartus::dse::designspace::_xmlElementStart {name attlist args} {
    ##::quartus::dse::ccl::dputs "$this _xml_element_start $name $attlist $args"
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
        DESIGNSPACE {
            # DESIGNSPACE tags can have optional project and revname
            # attributes. If they don't exist don't set $this stuff.
            if {[info exists atthas(project)]} {
                $this configure -strProjectName $atthash(project)
            }
            if {[info exists atthash(revname)]} {
                $this configure -strCmpName $atthash(revname)
            }
            lappend _xml_context_object $this
        }
        COPYRIGHT {
            lappend _xml_context_object $context_object
        }
        POINT {
            # POINT tags require a space attribute
            if {![info exists atthash(space)]} {
                return -code error "<POINT> tag without a space attribute was found!"
            }
            # space tag must be one of the following:
            if {![regexp -- {(?:llr|map|fit|seed)} $atthash(space)]} {
                return -code error "<POINT> tag has illegal space name!"
            }
            # And optionally an enabled attribute
            if {![info exists atthash(enabled)]} {
                set atthash(enabled) 1
            }
            lappend _xml_context_object [list $atthash(space) $atthash(enabled)]
            set _xml_point_buildup [list]
        }
        PARAM {
            # PARAM tags require a name attribute
            if {![info exists atthash(name)]} {
                return -code error "<PARAM> without a name attribute was found!"
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
##  Method:  designspace::_xmlElementEnd
##
##  Arguments:
##      name
##      args
##
##  Description:
##      Handler function used by the loadXML routine to deal with
##      an ending element tag. Register this handler with the XML
##      parser.
itcl::body ::quartus::dse::designspace::_xmlElementEnd {name args} {

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
        DESIGNSPACE {
            # Do nothing
        }
        COPYRIGHT {
            # Do nothing
        }
        POINT {
            if {[$parent_context_object isa ::quartus::dse::designspace]} {
                set space [lindex $current_context_object 0]
                set enabled [lindex $current_context_object 1]
                $this addPoint $space end $_xml_point_buildup
                if {$enabled != 1} {
                    $this disablePoints $space end
                }
                catch {unset _xml_point_buildup}
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing POINT tag and expected its parent"
                puts stderr "to be a DESIGNSPACE object. But it was not!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                return -code error "XML file was malformed!"
            }
        }
        PARAM {
            lappend _xml_point_buildup $current_context_object $_xml_content_buildup
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
##  Method:  designspace::_xmlError
##
##  Arguments:
##      errorcode
##      errormsg
##
##  Description:
##      Handler function used by the loadXML routine to deal with
##      an errors in the stream. Register this handler with the XML
##      parser.
itcl::body ::quartus::dse::designspace::_xmlError {errorcode errormsg} {
    return -code error $errormsg
}


#############################################################################
##  Method:  designspace::addPoint
##
##  Arguments:
##      space
##          Space into which point should be inserted.
##
##      ind
##          Location index to add map point at. Use 'end' to add it to
##          the end of existing points.
##
##      args
##          A list of parameters and thier values that can be used to
##          rebuild an array with [array set]
##
##  Description:
##      Adds a point to the Map space with a particular set of
##      parameter/value options.
itcl::body ::quartus::dse::designspace::addPoint {space ind args} {

    set debug_name "designspace::addPoint()"

    # Create an array out of the key/value list pairs
    # the user passed us. Throws an error if they goofed
    # the input to the function.
    array set _parameter_hash [join $args]

    # Make sure the space exists already
    if {![info exists arraySpace($space)]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Created arraySpace($space)"
        set arraySpace($space) [list]
        # Push this space on to the end of the traversal list
        lappend listSpaceTraversalOrder $space
    }
    if {![info exists arraySpaceEnable($space)]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Created arraySpaceEnable($space)"
        set arraySpaceEnable($space) [list]
    }

    # Append the hash of parameters to the list of Map points
    #::quartus::dse::ccl::dputs "${debug_name}: size of arraySpace($space) before is [llength $arraySpace($space)]: $arraySpace($space)"
    set arraySpace($space) [linsert $arraySpace($space) $ind [array get _parameter_hash]]
    #::quartus::dse::ccl::dputs "${debug_name}: size of arraySpace($space) after is [llength $arraySpace($space)]: $arraySpace($space)"

    # Append an enable flag for this point
    #::quartus::dse::ccl::dputs "${debug_name}: size of arraySpaceEnable($space) before is [llength $arraySpaceEnable($space)]: $arraySpaceEnable($space)"
    set arraySpaceEnable($space) [linsert $arraySpaceEnable($space) $ind 1]
    #::quartus::dse::ccl::dputs "${debug_name}: size of arraySpaceEnable($space) after is [llength $arraySpaceEnable($space)]: $arraySpaceEnable($space)"

    ::quartus::dse::ccl::dputs "${debug_name}: Added point to space $space in position $ind"
    return 1
}


#############################################################################
##  Method:  designspace::deletePoints
##
##  Arguments:
##      space
##          Space from which point should be deleted
##
##      args
##          Points to be deleted from this space. Can be integer
##          indices or the word "end" (last point in the list).
##
##  Description:
##      Deletes points and all data associated with the points from
##      the design space. Deletion is permanent and cannot be undone!
##      If you just want to skip a point during an itteration use the
##      disablePoints method instead. Always returns 1.
itcl::body ::quartus::dse::designspace::deletePoints {space args} {

    set debug_name "designspace::deletePoints()"

    foreach ind [join $args] {
        if {[info exists arraySpace($space)]} {
            # Remove the index from the list
            ::quartus::dse::ccl::dputs "${debug_name}: Removing point $ind from arraySpace($space)"
            set arraySpace($space) [lreplace $arraySpace($space) $ind $ind]
        }

        if {[info exists arraySpaceEnable($space)]} {
            # Remove the index from the enable list
            ::quartus::dse::ccl::dputs "${debug_name}: Removing point $ind from arraySpaceEnable($space)"
            set arraySpaceEnable($space) [lreplace $arraySpaceEnable($space) $ind $ind]
        }

    }

    return 1
}


#############################################################################
##  Method:  designspace::enablePoints
##
##  Arguments:
##      space
##          Space in which point should be enabled
##
##      args
##          Points to be enabled in this space. Can be integer
##          indices or the word "end" (last point in the list) or
##          the word "all" (meaning all points in the list).
##
##  Description:
##      Enables points so itteration through the space
##      includes these point. Always returns 1.
itcl::body ::quartus::dse::designspace::enablePoints {space args} {

    set indices [list]

    set debug_name "designspace::enablePoints()"

    if {[info exists arraySpace($space)]} {

        # Do we enable a certain set of points or all points?
        foreach a [join $args] {
            if {[string equal -nocase "all" $a]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found all keyword in \$args. Enabling all points."
                ::quartus::dse::ccl::dputs "${debug_name}: A total of [llength arraySpace($space)] points should get enabled"
                catch {unset indices}
                for {set i 0} {$i < [llength $arraySpace($space)]} {incr i} {
                    lappend indices $i
                }
            } else {
                lappend indices $a
            }
        }

        foreach ind $indices {
            # enable the points
            ::quartus::dse::ccl::dputs "${debug_name}: Enabling point $ind in space $space"
            set arraySpaceEnable($space) [lreplace $arraySpaceEnable($space) $ind $ind 1]
        }
    }

    return 1
}


#############################################################################
##  Method:  designspace::disablePoints
##
##  Arguments:
##      space
##          Space in which point should be disabled
##
##      args
##          Points to be disabled in this space. Can be integer
##          indices or the word "end" (last point in the list) or
##          the word "all" (meaning all points in the list).
##
##  Description:
##      Disables points so itteration through the space
##      does not include these point. Always returns 1.
itcl::body ::quartus::dse::designspace::disablePoints {space args} {

    set debug_name "designspace::disablePoints()"

    if {[info exists arraySpace($space)]} {

        # Do we disable a certain set of points or all points?
        foreach a [join $args] {
            if {[string equal -nocase "all" $a]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Found all keyword in \$args. Disabling all points."
                catch {unset indices}
                for {set i 0} {$i < [llength $arraySpace($space)]} {incr i} {
                    lappend indices $i
                }
            } else {
                lappend indices $a
            }
        }

        foreach ind $indices {
            # disable the points
            ::quartus::dse::ccl::dputs "${debug_name}: Disabling point $ind in space $space"
            set arraySpaceEnable($space) [lreplace $arraySpaceEnable($space) $ind $ind 0]
        }
    }

    return 1
}


#############################################################################
##  Method:  designspace::resetItterator
##
##  Arguments:
##      space
##          Space for which you want to reset itterator.
##
##  Description:
##      Resets the itterator used to step through the currently
##      enabled points in the Map space.
itcl::body ::quartus::dse::designspace::resetItterator {space} {

    set debug_name "designspace::resetItterator()"

    set retval 0

    # Easy to do...
    if {[info exists arraySpaceEnable($space)]} {
        for {set i 0} {$i < [llength $arraySpaceEnable($space)]} {incr i} {
            if {[lindex $arraySpaceEnable($space) $i]} {
                ::quartus::dse::ccl::dputs "${debug_name}: Reset itterator for $space to $i"
                set arraySpaceItterator($space) $i
                set retval 1
                break
            }
        }
        if {!$retval} {
            ::quartus::dse::ccl::dputs "${debug_name}: Reset itterator for $space to 0"
            set arraySpaceItterator($space) 0
            set retval 1
        }
    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: No space named $space found"
    }

    return $retval
}


#############################################################################
##  Method:  designspace::nextPoint
##
##  Arguments:
##      space
##          Space to search for next point.
##
##  Description:
##      Advance Map space itterator and return the next point
##      in the space. Returns a integer in the range [0:inf]
##      if there are more points in the space. Returns -1 if
##      there are no more points in the space.
itcl::body ::quartus::dse::designspace::nextPoint {space} {

    set debug_name "designspace::nextPoint()"
    set retval -1

    # Where we are...and where we're going...
    if {![info exists arraySpaceItterator($space)]} {
        set arraySpaceItterator($space) 0
        set curr 0
    } else {
        set curr [expr {$arraySpaceItterator($space) + 1}]
    }

    # Find one enabled point
    foreach point [lrange $arraySpaceEnable($space) $curr end] {
        if {$point} {
            set retval $curr
            break
        }
        incr curr
    }

    if {$retval != -1} {
        # We found the next enabled point!
        ::quartus::dse::ccl::dputs "${debug_name}: Found next point: $curr"
        ::quartus::dse::ccl::dputs "${debug_name}: [lindex $arraySpace($space) $curr]"
        set arraySpaceItterator($space) $curr
    } else {
        # No more enabled points. Put the itterator past the
        # end of the array.
        ::quartus::dse::ccl::dputs "${debug_name}: No next point was found"
        ::quartus::dse::ccl::dputs "${debug_name}: Setting itterator to [llength $arraySpace($space)]"
        set arraySpaceItterator($space) [llength $arraySpace($space)]
    }

    return $retval
}


#############################################################################
##  Method:  designspace::prevPoint
##
##  Arguments:
##      space
##          Space to search for previous point.
##
##  Description:
##      Decrement Map space itterator and return the previous
##      point in the space. Returns a integer in the range
##      [0:inf] if there are previous points in the space.
##      Returns -1 if there are no previous points in the
##      space.
itcl::body ::quartus::dse::designspace::prevPoint {space} {

    set debug_name "designspace::prevPoint()"

    # Where we are...and where we're going...
    if {![info exists arraySpaceItterator($space)]} {
        set arraySpaceItterator($space) 0
        set curr 0
    } else {
        set curr [expr {$arraySpaceItterator($space) - 1}]
    }

    set retval -1

    # Find one enabled point
    foreach point [::quartus::dse::ccl::reverseList [lrange $arraySpaceEnable($space) 0 $curr]] {
        if {$point} {
            set retval $curr
            break
        }
        set curr [expr {$curr - 1}]
    }

    if {$retval != -1} {
        # We found the next enabled point!
        ::quartus::dse::ccl::dputs "${debug_name}: Found previous point: $curr"
        ::quartus::dse::ccl::dputs "${debug_name}: [lindex $arraySpace($space) $curr]"
        set arraySpaceItterator($space) $curr
    } else {
        # No more enabled points. Put the itterator before start of space.
        ::quartus::dse::ccl::dputs "${debug_name}: No next point was found"
        ::quartus::dse::ccl::dputs "${debug_name}: Setting itterator to -1"
        set arraySpaceItterator($space) -1
    }

    return $retval
}


#############################################################################
##  Method:  designspace::morePoints
##
##  Arguments:
##      space
##          Space to check for more enabled points
##
##  Description:
##      Returns true (1) if there are more Map points that be
##      reached with the nextMapPoint method. Returns false (0)
##      if there are no more Map points that can be reached
##      with nextMapPoint. This is faster than calling nextMapPoint
##      and testing for -1 to stop an itteration loop.
itcl::body ::quartus::dse::designspace::morePoints {space} {

    set debug_name "designspace::morePoints()"

    if {![info exists arraySpaceItterator($space)]} {
        set arraySpaceItterator($space) 0
    }

    set retval 0
    ::quartus::dse::ccl::dputs "${debug_name}: Assuming there are no more enabled points"

    # Find one enabled point
    ::quartus::dse::ccl::dputs "${debug_name}: Searching from point $arraySpaceItterator($space) to end for an enabled point"
    set temp_counter $arraySpaceItterator($space)
    foreach point [lrange $arraySpaceEnable($space) $arraySpaceItterator($space) end]  {
        if {$point} {
            ::quartus::dse::ccl::dputs "${debug_name}: Found an enabled point at $temp_counter"
            set retval 1
            break
        }
        incr temp_counter
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Returning $retval"
    return $retval
}


#############################################################################
##  Method:  designspace::clearDesignSpace
##
##  Arguments:
##      space
##          Optional. Only clears one space if present.
##
##  Description:
##      Deletes all the points in a space (if space argument is
##      provided). Otherwise it deletes all points in all spaces
##      essentially emptying this designspace object of any space
##      information whatsoever. Returns true if it works, errors
##      out if it encounters problems.
itcl::body ::quartus::dse::designspace::clearDesignSpace {{space "#_all_#"}} {

    set debug_name "designspace::clearDesignSpace()"

    # These are itterator lists we'll use to clean up
    set listofSpace [list]
    set listofSpaceEnable [list]
    set listofSpaceItterator [list]
    set listofPointCount [list]

    if {[string equal $space "#_all_#"]} {
        ::quartus::dse::ccl::dputs "${debug_name}: No arguments passed: clearing all spaces"
        # Gather a list of all the design spaces
        set listofSpace [array names arraySpace]
        set listofSpaceEnable [array names arraySpaceEnable]
        set listofSpaceItterator [array names arraySpaceItterator]
    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Clearing space: $space"
        # Form lists using space we were passed
        if {[info exists arraySpace($space)]} {
            set listofSpace [list $space]
        }
        if {[info exists arraySpaceEnable($space)]} {
            set listofSpaceEnable [list $space]
        }
        if {[info exists arraySpaceItterator($space)]} {
            set listofSpaceItterator [list $space]
        }
    }

    # Now clean...
    foreach s $listofSpace {
        catch {array unset arraySpace $s}
        # Remove this space from the traversal list
        set tempT [list]
        foreach t [$this getTraversalOrder] {
            if {![string equal $t $s]} {
                lappend tempT $t
            }
        }
        $this setTraversalOrder $tempT
    }
    foreach s $listofSpaceEnable {
        catch {array unset arraySpaceEnable $s}
    }
    foreach s $listofSpaceItterator {
        catch {array unset arraySpaceItterator $s}
    }

    return 1
}


#############################################################################
##  Method:  designspace::getSpaces
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns a list of all the spaces available.
itcl::body ::quartus::dse::designspace::getSpaces {} {

    set debug_name "designspace::getSpaces()"

    ::quartus::dse::ccl::dputs "${debug_name}: Returning: [array names arraySpace]"
    return [array names arraySpace]
}


#############################################################################
##  Method:  designspace::getSizeOfSpace
##
##  Arguments:
##      space
##          Space you want the size of.
##
##  Description:
##      Returns a count of the current number of enabled points
##      in a space. Returns 0 if the space doesn't exist.
itcl::body ::quartus::dse::designspace::getSizeOfSpace {space} {

    set debug_name "designspace::getSizeOfSpace()"

    set retval 0

    if {[info exists arraySpaceEnable($space)]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Calculating size of space $space"
        foreach p $arraySpaceEnable($space) {
            if {$p} {
                incr retval
            }
        }
    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: Space $space not found"
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Returning: $retval"
    return $retval
}


#############################################################################
##  Method:  designspace::getParams
##
##  Arguments:
##      space
##          Space you want the params for.
##
##      ind
##          Optional index you want the params for. Default is current
##          itterator.
##
##  Description:
##      Returns list suitable for turning into an array with [array set]
##      that holds key/value parameter pairs set at this point. If no
##      index is given it uses the current itterator for this space.
itcl::body ::quartus::dse::designspace::getParams {space {ind "#_current_#"}} {

    set debug_name "designspace::getParams()"

    array set params [list]

    if {[info exists arraySpace($space)]} {

        if {$ind == "#_current_#"} {
            set ind $arraySpaceItterator($space)
        }

        array set params [lindex $arraySpace($space) $ind]

    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: Space $space not found"
    }

    return [array get params]
}


#############################################################################
##  Method:  designspace::getAllParams
##
##  Arguments:
##      space
##          Space you want the params for.
##
##  Description:
##      Returns list suitable for turning into an array with [array set]
##      that holds key/value parameter pairs for this space. The array
##      holds parameter names as keys and all possible values as lists
##      at those keys. The lists of values are normalized so there are
##      no duplicates.
itcl::body ::quartus::dse::designspace::getAllParams {space} {

    set debug_name "designspace::getAllParams()"

    array set allparams [list]

    if {[info exists arraySpace($space)]} {

        foreach point $arraySpace($space) {
            foreach {key value} $point {
                lappend allparams($key) $value
            }
        }

        # Normalize allparams now
        foreach key [array names allparams] {
            catch {array unset values}
            foreach val $allparams($key) {
                set values($val) 1
            }
            set allparams($key) [array names values]
            catch {array unset values}
        }


    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: Space $space not found"
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Returning: [array get allparams]"
    return [array get allparams]
}


#############################################################################
##  Method:  designspace::getPointsWithParams
##
##  Arguments:
##      space
##          Space from which you would like the points.
##
##      args
##          Key value parameter pairs that will be matched
##          against points in the space.
##
##  Description:
##      Returns a list of all the point indices in the space that
##      have parameters that match the ones you pass. The points
##      returned may have MORE parameters than your set, but they
##      will at least have ALL the parameters in your set and their
##      values will match. It does not check to see if these points
##      are enabled or disabled.
itcl::body ::quartus::dse::designspace::getPointsWithParams {space args} {

    set debug_name "designspace::getPointsWithParams()"

    set plist [list]

    # Test args. It should be in a format we can make an
    # array out of. If not, no point searching...
    if {![catch {array set params [join $args]}]} {

        # How many parameters are we trying to match?
        set params_to_match [llength [array names params]]

        # Test that the space exists. No point continuing if
        # it doesn't exist, right?
        if {[info exists arraySpace($space)]} {

            ::quartus::dse::ccl::dputs "${debug_name}: Searching space $space for matching points:"

            # Space exists, search it...
            for {set pcount 0} {$pcount < [llength $arraySpace($space)]} {incr pcount} {

                # Get the parameters at this point
                array set point_params [lindex $arraySpace($space) $pcount]

                # If we can find all the parameters and values on
                # our params array at this point then we push it
                # on to our list. If we get a mismatch at any
                # param we can stop, it doesn't meet our criteria.
                set matched_params 0
                foreach p [array names params] {

                    if {![info exists point_params($p)]} {
                        # Stop searching. This point is missing a required param.
                        ::quartus::dse::ccl::dputs "${debug_name}:    Point $pcount is missing required parameter: $p: $params($p)"
                        set matched_params -1
                        break
                    }

                    if {[string equal -nocase $point_params($p) $params($p)]} {
                        # Matched a parameter and value! Increment counter!
                        ::quartus::dse::ccl::dputs "${debug_name}:    Point $pcount matched parameter: $p: Required: $params($p) Found: $point_params($p)"
                        incr matched_params
                    } else {
                        # Stop searching. This point has the required param,
                        # but its value differs from the required value.
                        ::quartus::dse::ccl::dputs "${debug_name}:    Point $pcount failed parameter match: $p: Required: $params($p) Found: $point_params($p)"
                        set match_params -1
                        break
                    }

                }

                catch {array unset point_params}

                # If we matched all the params push this point
                # on to the list.
                if {$matched_params == $params_to_match} {
                    ::quartus::dse::ccl::dputs "${debug_name}:    Success! Point $pcount matched all requirements!"
                    lappend plist $pcount
                } else {
                    ::quartus::dse::ccl::dputs "${debug_name}:    Failure! Point $pcount did not match all the requirements!"
                }

            }

        } else {
            ::quartus::dse::ccl::dputs "${debug_name}: Error: Couldn't find space $space!"
        }

    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: \$args was malformed! Could not make array out it!"
    }

    return $plist
}


#############################################################################
##  Method:  designspace::getPointsWithParamsExactly
##
##  Arguments:
##      space
##          Space from which you would like the points.
##
##      args
##          Key value parameter pairs that will be matched
##          against points in the space.
##
##  Description:
##      Returns a list of all the point indices in the space that
##      have parameters that match the ones you pass. The points
##      returned may have MORE parameters than your set, but they
##      will at least have ALL the parameters in your set and their
##      values will match. It does not check to see if these points
##      are enabled or disabled.
itcl::body ::quartus::dse::designspace::getPointsWithParamsExactly {space args} {

    set debug_name "designspace::getPointsWithParamsExactly()"

    set plist [list]

    # Test args. It should be in a format we can make an
    # array out of. If not, no point searching...
    if {![catch {array set params [join $args]}]} {

        # How many parameters are we trying to match?
        set params_to_match [llength [array names params]]

        # Test that the space exists. No point continuing if
        # it doesn't exist, right?
        if {[info exists arraySpace($space)]} {

            ::quartus::dse::ccl::dputs "${debug_name}: Searching space $space for matching points:"

            # Space exists, search it...
            for {set pcount 0} {$pcount < [llength $arraySpace($space)]} {incr pcount} {

                # Get the parameters at this point
                array set point_params [lindex $arraySpace($space) $pcount]

                # If we can find all the parameters and values on
                # our params array at this point then we push it
                # on to our list. If we get a mismatch at any
                # param we can stop, it doesn't meet our criteria.
                set matched_params 0

                if {$params_to_match == [llength [array names point_params]]} {

                    foreach p [array names params] {

                        if {![info exists point_params($p)]} {
                            # Stop searching. This point is missing a required param.
                            ::quartus::dse::ccl::dputs "${debug_name}:    Point $pcount is missing required parameter: $p: $params($p)"
                            set matched_params -1
                            break
                        }

                        if {[string equal -nocase $point_params($p) $params($p)]} {
                            # Matched a parameter and value! Increment counter!
                            ::quartus::dse::ccl::dputs "${debug_name}:    Point $pcount matched parameter: $p: Required: $params($p) Found: $point_params($p)"
                            incr matched_params
                        } else {
                            # Stop searching. This point has the required param,
                            # but its value differs from the required value.
                            ::quartus::dse::ccl::dputs "${debug_name}:    Point $pcount failed parameter match: $p: Required: $params($p) Found: $point_params($p)"
                            set match_params -1
                            break
                        }

                    }

                } else {
                    # Stop searching. This point has different number of required
                    # params
                    ::quartus::dse::ccl::dputs "${debug_name}:    Failure! Point $pcount did not have the same number of parameters!"
                    set matched_params -1
                }

                catch {array unset point_params}

                # If we matched all the params push this point
                # on to the list.
                if {$matched_params == $params_to_match} {
                    ::quartus::dse::ccl::dputs "${debug_name}:    Success! Point $pcount matched all requirements!"
                    lappend plist $pcount
                } else {
                    ::quartus::dse::ccl::dputs "${debug_name}:    Failure! Point $pcount did not match all the requirements!"
                }

            }

        } else {
            ::quartus::dse::ccl::dputs "${debug_name}: Error: Couldn't find space $space!"
        }

    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: \$args was malformed! Could not make array out it!"
    }

    return $plist
}


#############################################################################
##  Method:  designspace::getItterator
##
##  Arguments:
##      space
##          Space in which you would like current itterator value for
##
##  Description:
##      Returns the current itterator value for this space. Returns -1
##      if space doesn't exist.
itcl::body ::quartus::dse::designspace::getItterator {space} {

    set debug_name "designspace::getItterator()"

    set retval -1

    if {![info exists arraySpaceItterator($space)]} {
        # There is no space by this name
        ::quartus::dse::ccl::dputs "${debug_name}: Error: No space named $space found"
    } else {
        ::quartus::dse::ccl::dputs "${debug_name}: Returning itterator value $arraySpaceItterator($space)"
        set retval $arraySpaceItterator($space)
    }

    return $retval
}


#############################################################################
##  Method:  designspace::createPoint
##
##  Arguments:
##      space
##          Space from which you would like the points.
##
##      ind
##          Optional. A point number to create, can be an integer
##          value or "end". If you omit this the method uses the
##          current itterator for this space.
##
##  Description:
##      Opens the project and sets the settings for this point effectivily
##      "creating" the point on disk. Once this method is done you can
##      call the different Quartus II executables to map, fit and tan the
##      point. If you give it an index it will create that point, otherwise
##      it will use the itterator for this space and create whatever point
##      the itterator is pointing to on disk. Returns true if creation
##      was successfull; false if there was trouble.
itcl::body ::quartus::dse::designspace::createPoint {space {ind "#_current_#"}} {

    set debug_name "designspace::createPoint()"

    set retval 0

    set cont 1
    if {![info exists arraySpace($space)]} {
        # There are no points for this space
        ::quartus::dse::ccl::dputs "${debug_name}: Error: No space named $space found"
        set cont 0
    }

    if {$cont} {
        # Use current itterator maybe?
        if {[string equal -nocase $ind "#_current_#"]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating point using current itterator for space $space: $arraySpaceItterator($space)"
            set ind $arraySpaceItterator($space)
        }

        # Does the point exists
        set point [lindex $arraySpace($space) $ind]
        if {$ind <= [llength $arraySpace($space)]} {
            # For each key/value pair in the point set the
            # appropriate Quartus II setting.

            ::quartus::dse::ccl::dputs "${debug_name}: Opening project $strProjectName"
            project_open -force -revision $strCmpName $strProjectName

            foreach {param value} $point {

                if {[regexp -nocase {^-} $param]} {
                    # Ignore settings that begin with a '-'
                } else {
                    # It's a Quartus II ACF setting...
                    # Try to apply as a global setting, if that doesn't work
                    # make a leap-of-faith and assume the project_name is the
                    # same as the top level entity.  The other thing to try is
                    # to use wildcards but it seems not everything supports this.
                    # Is that true?
                    ::quartus::dse::ccl::dputs "${debug_name}: $param is an ACF setting: attempting global assignment"
                    set aok [catch {set_global_assignment -name $param $value}]
                    if {$aok == 1} {
                        set_instance_assignment -name $param -to $strProjectName $value
                        set_instance_assignment -name $param -to $strCmpName $value
                        ::quartus::dse::ccl::dputs "${debug_name}: Warning: $param is not a globally assignable"
                        ::quartus::dse::ccl::dputs "${debug_name}:          Attempted to assign it to $strProjectName and $strCmpName sections instead"
                    }
                }
            }

            project_close
            ::quartus::dse::ccl::dputs "${debug_name}: Point created successfully"
            set retval 1

        } else {
           ::quartus::dse::ccl::dputs "${debug_name}: Error: Point $ind does not exist in space $space"
           ::quartus::dse::ccl::dputs "${debug_name}:        $arraySpace($space)"
        }
    }

    return $retval
}


#############################################################################
##  Method:  designspace::savePoint
##
##  Arguments:
##      space
##          Space from which you would like the points.
##
##      ind
##          Optional. A point number to create, can be an integer
##          value or "end". If you omit this the method uses the
##          current itterator for this space.
##
##  Description:
itcl::body ::quartus::dse::designspace::savePoint {space {ind "#_current_#"}} {

    set debug_name "designspace::savePoint()"

    set retval 0
    set cont 1

    if {![info exists arraySpace($space)]} {
        # There is no space by this name
        ::quartus::dse::ccl::dputs "${debug_name}: Error: No space named $space found"
        set cont 0

    }

    if {$cont} {
        if {[string equal -nocase $ind "#_current_#"]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Saving point using current itterator for space $space: $arraySpaceItterator($space)"
            set ind $arraySpaceItterator($space)
        }

        # Archive this point
        set arcdir [file join $strArchiveDir $space]
        set arcfile "${strProjectName}_${strCmpName}_${ind}"
        ::quartus::dse::ccl::dputs "${debug_name}: Attempting to save [file join $arcdir ${arcfile}.qar]"
        project_open -force -revision $strCmpName $strProjectName
        if {[::quartus::dse::ccl::archive $arcfile $arcdir] > 0} {
            set retval 1
        }
        ::quartus::dse::ccl::dputs "${debug_name}: Got back $retval from archive command"
        project_close
    }

    return $retval
}


#############################################################################
##  Method:  designspace::restorePoint
##
##  Arguments:
##      space
##          Space from which you would like the points.
##
##      ind
##          Optional. A point number to create, can be an integer
##          value or "end". If you omit this the method uses the
##          current itterator for this space.
##
##  Description:
itcl::body ::quartus::dse::designspace::restorePoint {space {ind "#_current_#"}} {

    set debug_name "designspace::restorePoint()"

    set retval 0
    set cont 1

    if {![info exists arraySpace($space)]} {
        # There is no space by this name
        ::quartus::dse::ccl::dputs "${debug_name}: Error: No space named $space found"
        set cont 0

    }


    if {$cont} {
        if {[string equal -nocase $ind "#_current_#"]} {
            ::quartus::dse::ccl::dputs "${debug_name}: Restoring point using current itterator for space $space: $arraySpaceItterator($space)"
            set ind $arraySpaceItterator($space)
        }

        # Unarchive this point
        set arcdir [file join $strArchiveDir $space]
        set arcfile "${strProjectName}_${strCmpName}_${ind}"
        ::quartus::dse::ccl::dputs "${debug_name}: Attempting to restore [file join $arcdir ${arcfile}.qar]"
        set retval [::quartus::dse::ccl::unarchive $arcfile $arcdir]
    }

    return $retval
}


#############################################################################
##  Method:  designspace::getTraversalOrder
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns a list of space names in the order that they
##      should be traversed. For an accelerated flow you would
##      traverse element 0, then 1, etc.
itcl::body ::quartus::dse::designspace::getTraversalOrder {} {

    set debug_name "designspace::getTraversalOrder()"

    return $listSpaceTraversalOrder
}


#############################################################################
##  Method:  designspace::setTraversalOrder
##
##  Arguments:
##      args - the list of space names, in the order you
##             want them traversed.
##
##  Description:
##
##      The function checks that all the spaces named in args
##      exist. If even one does not exist the set is not done
##      and nothing in the object is changed. Returns true if
##      the order was set. Returns false if the order was not
##      set.
itcl::body ::quartus::dse::designspace::setTraversalOrder {args} {

    set debug_name "designspace::setTraversalOrder()"

    # Make sure all the space in args exist
    foreach space [join $args] {
        if {![info exists arraySpace($space)]} {
            # Stop now, don't make any changes
            return 0
        }
    }

    # Set the traversal order
    set listSpaceTraversalOrder [join $args]

    return 1
}

#############################################################################
##  Procedure:  get_base_point_options
##
##  Arguments:
##      <none>
##
##  Description:
##      Loads the global ::quartus::dse::base_point_options with the correct
##      values, should be called from the on_open_project and on_change_revision
##      basically any time the project settings could have changed.  This
##      function assumes a project is open!!!
##
proc ::quartus::dse::designspace::get_base_point_options {} {

    set debug_name "::quartus::dse::designspace::get_base_point_options"

    # Only call this on an open project
    if { ![is_project_open] } {
        return 0
    }

    ::quartus::dse::ccl::dputs "${debug_name}: Extracting base point options from open project"

    #  Find the placement effort multiplier in the base compilation
    set temp [get_global_assignment -name PLACEMENT_EFFORT_MULTIPLIER]
    if {$temp <= 0} {
        set temp 0.1
    }
    set ::quartus::dse::base_point_options(base-placement-effort-multiplier) $temp

    #  Find the FSYN settings in the base compilation
    set temp [get_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC]
    if {$temp == ""} {
        set temp "OFF"
    }
    if {[string equal -nocase $temp "on"]} {
	    set ::quartus::dse::base_point_options(fsyn-comb-logic) 1
	} else {
	    set ::quartus::dse::base_point_options(fsyn-comb-logic) 0
	}

    set temp [get_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION]
    if {$temp == ""} {
        set temp "OFF"
    }
    if {[string equal -nocase $temp "on"]} {
	    set ::quartus::dse::base_point_options(fsyn-duplication) 1
	} else {
	    set ::quartus::dse::base_point_options(fsyn-duplication) 0
	}

    set temp [get_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING]
    if {$temp == ""} {
        set temp "OFF"
    }
    if {[string equal -nocase $temp "on"]} {
	    set ::quartus::dse::base_point_options(fsyn-retiming) 1
	} else {
	    set ::quartus::dse::base_point_options(fsyn-retiming) 0
	}

    set temp [get_global_assignment -name PHYSICAL_SYNTHESIS_EFFORT]
    if {$temp == ""} {
        set temp "NORMAL"
    }
    if {[string equal -nocase $temp "fast"]} {
	    set ::quartus::dse::base_point_options(fsyn-effort-level) "fast"
	} elseif {[string equal -nocase $temp "extra"]} {
	    set ::quartus::dse::base_point_options(fsyn-effort-level) "extra"
	} else {
	    set ::quartus::dse::base_point_options(fsyn-effort-level) "normal"
	}

	#  Find the fast-fit related settings
    set temp [get_global_assignment -name FAST_FIT_COMPILATION]
    if {$temp == ""} {
        set temp "Standard Fit"
    }
    if {[string equal -nocase $temp "Fast Fit"]} {
	    set ::quartus::dse::base_point_options(fast-fit-compilation) 1
	} else {
	    set ::quartus::dse::base_point_options(fast-fit-compilation) 0
	}

    set temp [get_global_assignment -name FIT_ONLY_ONE_ATTEMPT]
    if {$temp == ""} {
        set temp "OFF"
    }
    if {[string equal -nocase $temp "off"]} {
	    set ::quartus::dse::base_point_options(fit-one-attempt) 0
	} else {
	    set ::quartus::dse::base_point_options(fit-one-attempt) 1
	}

    set temp [get_global_assignment -name AUTO_PACKED_REGISTERS_STRATIXII]
    if {$temp == ""} {
	    set ::quartus::dse::base_point_options(stratixii-register-packing) "auto"
    } else {
	    set ::quartus::dse::base_point_options(stratixii-register-packing) $temp
    }

    set temp [get_global_assignment -name AUTO_PACKED_REGISTERS_STRATIXII]
    if {$temp == ""} {
	    set ::quartus::dse::base_point_options(arria-register-packing) "auto"
    } else {
	    set ::quartus::dse::base_point_options(arria-register-packing) $temp
    }

    set temp [get_global_assignment -name AUTO_PACKED_REGISTERS_STRATIX]
    if {$temp == ""} {
	    set ::quartus::dse::base_point_options(stratix-register-packing) "auto"
    } else {
	    set ::quartus::dse::base_point_options(stratix-register-packing) $temp
    }

    set temp [get_global_assignment -name AUTO_PACKED_REGISTERS_CYCLONE]
    if {$temp == ""} {
	    set ::quartus::dse::base_point_options(cyclone-register-packing) "auto"
    } else {
	    set ::quartus::dse::base_point_options(cyclone-register-packing) $temp
    }

    set temp [get_global_assignment -name STRATIXII_OPTIMIZATION_TECHNIQUE]
    if {$temp == ""} {
        set ::quartus::dse::base_point_options(stratixii-map-optimization-technique) "BALANCED"
    } else {
        set ::quartus::dse::base_point_options(stratixii-map-optimization-technique) $temp
    }

    set temp [get_global_assignment -name STRATIXII_OPTIMIZATION_TECHNIQUE]
    if {$temp == ""} {
        set ::quartus::dse::base_point_options(arria-map-optimization-technique) "BALANCED"
    } else {
        set ::quartus::dse::base_point_options(arria-map-optimization-technique) $temp
    }

    set temp [get_global_assignment -name STRATIX_OPTIMIZATION_TECHNIQUE]
    if {$temp == ""} {
        set ::quartus::dse::base_point_options(stratix-map-optimization-technique) "BALANCED"
    } else {
        set ::quartus::dse::base_point_options(stratix-map-optimization-technique) $temp
    }

    set temp [get_global_assignment -name CYCLONEII_OPTIMIZATION_TECHNIQUE]
    if {$temp == ""} {
        set ::quartus::dse::base_point_options(cycloneii-map-optimization-technique) "BALANCED"
    } else {
        set ::quartus::dse::base_point_options(cycloneii-map-optimization-technique) $temp
    }

    set temp [get_global_assignment -name CYCLONE_OPTIMIZATION_TECHNIQUE]
    if {$temp == ""} {
        set ::quartus::dse::base_point_options(cyclone-map-optimization-technique) "BALANCED"
    } else {
        set ::quartus::dse::base_point_options(cyclone-map-optimization-technique) $temp
    }

    foreach {k} [array names ::quartus::dse::base_point_options] {
        ::quartus::dse::ccl::dputs "${debug_name}:    $k = $::quartus::dse::base_point_options($k)"
    }
    ::quartus::dse::ccl::dputs "${debug_name}: Extraction complete"
    return 1
}
