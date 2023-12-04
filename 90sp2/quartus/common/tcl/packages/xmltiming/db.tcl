
#############################################################################
##  db.tcl - v1.0
##
##  This Tcl/Tk library provides a hierarchical object structure that
##  functions as a very lightweigth timing database. It it meant to be
##  used with the xmltiming package.
##
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

package provide ::quartus::xmltiming::db 1.0


#############################################################################
##  Additional Packages Required
package require Itcl                3.1
package require xml                 2.0
package require xmlgen              1.4


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::xmltiming::db {
    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
}


#############################################################################
##  Class:  db::icd
##
##  Description:
##      Top level class that holds all the information pertaining to
##      intracell delays. This class can load itself from an XML file
##      if you like. Or be generated on the fly.
itcl::class ::quartus::xmltiming::db::icd {

    constructor {{_name "#_unknown_#"} {_delay_units "PS"}} {
        set name $_name
        set delay_units $_delay_units
        set speed_list [list]
        set _xml_context ""
        set _xml_context_object ""
        set _xml_indent ""
        set _xml_content_buildup ""
    }

    destructor {
        catch {eval delete object $speed_list}
        catch {unset name delay_units device_list _xml_context _xml_context_object _xml_indent _xml_content_buildup}
    }

    public variable name
    public variable delay_units
    private variable speed_list
    private variable _xml_context
    private variable _xml_context_object
    private variable _xml_indent
    private variable _xml_content_buildup

    #public method dumpXML {{channel stdout}}
    public method loadXML {{channel stdin} {test 0}}
    public method cadd {{option -value} args}
    public method getAllSpeedNames {}
    public method getSpeed {spdname}

    # Methods using by loadXML to handle events fired by parser.
    # Their public because the parse needs access to them. You
    # probably shouldn't ever call these yourself.
    public method _xml_characterdata {data}
    public method _xml_elementstart {name attlist args}
    public method _xml_elementend {name args}
    public method _xml_error {errorcode errormsg}

    # Test methods for XML parsing
    public method _xml_characterdata_test {data}
    public method _xml_elementstart_test {name attlist args}
    public method _xml_elementend_test {name args}
    public method _xml_error_test {errorcode errormsg}

}


#############################################################################
##  Method:  db::icd::cadd
##
##  Arguments:
##      option
##          Add option
##
##      val
##          Add value
##
## Description:
##      Adds $value to a private list in the class depending on what -option
##      is. Returns true if option was added successfully, otherwise it calls
##      error.
itcl::body ::quartus::xmltiming::db::icd::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::xmltiming::db::icd::cadd requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -speed { lappend speed_list $val }
        default { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  db::icd::getAllSpeedNames
##
##  Arguments:
##      None
##
## Description:
##      Returns a list of all the speeds that are available for this
##      device. You can use this list to pattern match against a users
##      request if you want to prempt searching the DB for illegal
##      device names.
itcl::body ::quartus::xmltiming::db::icd::getAllSpeedNames {} {
    
    set tmplist {}

    foreach speed $speed_list {
        lappend tmplist [$speed cget -grade]
    }

    return $tmplist
}


#############################################################################
##  Method:  db::icd::getSpeed
##
##  Arguments:
##      spdname
##          Name of the speed to search for in the speed list.
##
## Description:
##      Returns a pointer to the first speed object whose name matches
##      the $spdname argument passed to the function. Returns an empty
##      string if no match is made against speeds in the list. Name
##      matching is done with [string equal -nocase].
itcl::body ::quartus::xmltiming::db::icd::getSpeed {spdname} {

    set retval ""

    foreach speed $speed_list {
        if {[string equal -nocase [$speed cget -grade] $spdname]} {
            set retval $speed
            break
        }
    }

    return $retval
}


#############################################################################
##  Method:  db::icd::loadXML
##
##  Arguments:
##      channel
##          Optional channel to gather XML information from. If no
##          channel is specified the method tries to use stdin.
##
##  Description:
##      Loads information from an XML file. Returns true
##      if loading was successful, false if it wasn't. This
##      destroys data that already exists in the ICD object
##      unfortunatly so you cannot use it to merge data into
##      an existing object. Use the db::icd::merge_data function
##      instead to do that.
itcl::body ::quartus::xmltiming::db::icd::loadXML {{channel stdin} {test 0}} {

    # Reference to commands the parser calls to deal with events
    if {$test} {
        set cdata       "$this  _xml_characterdata_test"
        set elemstart   "$this  _xml_elementstart_test"
        set elemend     "$this  _xml_elementend_test"
        set err         "$this  _xml_error_test"
    } else {
        set cdata       "$this  _xml_characterdata"
        set elemstart   "$this  _xml_elementstart"
        set elemend     "$this  _xml_elementend"
        set err         "$this  _xml_error"
    }
    
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
#    if {[catch {$parser parse [read $channel]} err]} {
#        error $err
#    }
    set load_start_time [clock seconds]
    $parser parse [read $channel]
    set load_end_time [clock seconds]
    #msg_vdebug "${this} loadXML finished successfully in [expr {$load_end_time - $load_start_time}] seconds"
    return 1
}


#############################################################################
##  Class:  db::speed
##
##  Description:
##      Speed-level information. Holds a set of blocks, etc.
itcl::class ::quartus::xmltiming::db::speed {

    constructor {{_grade "COMMON"}} {
        set grade $_grade
        set device_list [list]
    }

    destructor {
        catch {eval delete object $device_list}
        catch {unset grade device_list}
    }

    public variable grade
    private variable device_list

    public method cadd {{option -value} args}
    public method getAllDeviceNames {}
    public method getDevice {devname}
    
}


#############################################################################
##  Method:  db::speed::cadd
##
##  Arguments:
##      option
##          Add option
##
##      val
##          Add value
##
## Description:
##      Adds $value to a private list in the class depending on what -option
##      is. Returns true if option was added successfully, otherwise it calls
##      error.
itcl::body ::quartus::xmltiming::db::speed::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::xmltiming::db::speed::cadd requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -device  { lappend device_list $val }
        default { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  db::speed::getAllDeviceNames
##
##  Arguments:
##      None
##
## Description:
##      Returns a list of all the devices that are available from this
##      SPEED. You can use this list to pattern match against a users
##      request if you want to prempt searching the DB for illegal
##      device names.
itcl::body ::quartus::xmltiming::db::speed::getAllDeviceNames {} {
    
    set tmplist {}

    foreach device $device_list {
        lappend tmplist [$device cget -name]
    }

    return $tmplist
}


#############################################################################
##  Method:  db::speed::getDevice
##
##  Arguments:
##      devname
##          Name of the device to search for in the device list.
##
## Description:
##      Returns a pointer to the first device object whose name matches
##      the $devname argument passed to the function. Returns an empty
##      string if no match is made against devices in the list. Name
##      matching is done with [string equal -nocase].
itcl::body ::quartus::xmltiming::db::speed::getDevice {devname} {

    set retval ""
    
    foreach device $device_list {
        if {[string equal -nocase [$device cget -name] $devname]} {
            set retval $device
            break
        }
    }

    return $retval
}


#############################################################################
##  Class:  db::device
##
##  Description:
##      Device-level information. Holds a set of speed grades, etc.
itcl::class ::quartus::xmltiming::db::device {

    constructor {{_name "#_unknown_#"}} {
        set name $_name
        set block_list [list]
    }

    destructor {
        catch {eval delete object $block_list}
        catch {unset name block_list}
    }

    public variable name
    private variable block_list

    public method cadd {{option -value} args}
    public method getAllBlockNames {}
    public method getBlock {blktype {blksubtype "DEFAULT"}}

}


#############################################################################
##  Method:  db::device::cadd
##
##  Arguments:
##      option
##          Add option
##
##      val
##          Add value
##
## Description:
##      Adds $value to a private list in the class depending on what -option
##      is. Returns true if option was added successfully, otherwise it calls
##      error.
itcl::body ::quartus::xmltiming::db::device::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::xmltiming::db::device::cadd requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -block  { lappend block_list $val }
        default { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  db::device::getAllBlockNames
##
##  Arguments:
##      None
##
## Description:
##      Returns a list of all the blocks that are available for this
##      device. You can use this list to pattern match against a users
##      request if you want to prempt searching the DB for illegal
##      device names.
itcl::body ::quartus::xmltiming::db::device::getAllBlockNames {} {
    
    set tmplist {}

    foreach block $block_list {
        lappend tmplist [list [$block cget -blocktype] [$block cget -blocksubtype]]
    }

    return $tmplist
}


#############################################################################
##  Method:  db::device::getBlock
##
##  Arguments:
##      blktype
##          Name of the block to search for in the speed list.
##
##      blksubtype
##          Optional. Sub-type of the block to look for. Default is "DEFAULT"
##          if you don't specify a sub-type value.
##
## Description:
##      Returns a pointer to the first block object whose name matches
##      the $blktype and $blksubtype arguments passed to the function.
##      Returns an empty string if no match is made against blocks in 
##      the list. Name matching is done with [string equal -nocase].
itcl::body ::quartus::xmltiming::db::device::getBlock {blktype {blksubtype "DEFAULT"}} {
    
    set retval ""
    
    foreach block $block_list {
        if {[string equal -nocase [$block cget -blocktype] $blktype] && [string equal -nocase [$block cget -blocksubtype] $blksubtype]} {
            set retval $block
            break
        }
    }

    return $retval
}


#############################################################################
##  Class:  db::block
##
##  Description:
##      Block-level information. Holds a set of locations, etc.
itcl::class ::quartus::xmltiming::db::block {

    constructor {{_blocktype "#_unknown_#"} {_blocksubtype "DEFAULT"}} {
        set blocktype $_blocktype
        set blocksubtype $_blocksubtype
        set location_list [list]
    }

    destructor {
        catch {eval delete object $location_list}
        catch {unset blocktype blocksubtype location_list}
    }

    public variable blocktype
    public variable blocksubtype
    private variable location_list

    public method cadd {{option -value} args}
    public method getAllLocations {}
    public method getLocation {{x 0} {y 0} {subloc 0}}

}


#############################################################################
##  Method:  db::block::cadd
##
##  Arguments:
##      option
##          Add option
##
##      val
##          Add value
##
## Description:
##      Adds $value to a private list in the class depending on what -option
##      is. Returns true if option was added successfully, otherwise it calls
##      error.
itcl::body ::quartus::xmltiming::db::block::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::xmltiming::db::block::cadd requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -location   { lappend location_list $val }
        default     { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  db::block::getAllLocations
##
##  Arguments:
##      None
##
## Description:
##      Returns a list of all the locations that are available for this
##      block. You can use this list to pattern match against a users
##      request if you want to prempt searching the DB for illegal
##      device names.
itcl::body ::quartus::xmltiming::db::block::getAllLocations {} {
    
    set tmplist {}

    foreach location $location_list {
        lappend tmplist [list [$location cget -x] [$location cget -y] [$location cget -subloc]]
    }

    return $tmplist
}


#############################################################################
##  Method:  db::block::getLocation
##
##  Arguments:
##      x
##          X coord of location to retrieve
##
##      y
##          Y coord of the location to retrieve
##
##      subloc
##          Sub-location coord of the location to retrieve
##
## Description:
##      Returns a pointer to the first location object whose coordinates
##      match the {$x, $y, $subloc} arguments passed to the function.
##      Returns an empty string if no match is made against locations in 
##      the list.
itcl::body ::quartus::xmltiming::db::block::getLocation {{x 0} {y 0} {subloc 0}} {
    
    set retval ""
    
    foreach location $location_list {
        if {[$location cget -x] == $x && [$location cget -y] == $y && [$location cget -subloc] == $subloc} {
            set retval $location
            break
        }
    }

    return $retval
}


#############################################################################
##  Class:  db::location
##
##  Description:
##      Location-level information. Holds a set of modes, etc.
itcl::class ::quartus::xmltiming::db::location {

    constructor {{_x 0} {_y 0} {_subloc 0}} {
        set x $_x
        set y $_y
        set subloc $_subloc
        set mode_list [list]
    }

    destructor {
        catch {eval delete object $mode_list}
        catch {unset x y subloc mode_list}
    }

    public variable x
    public variable y
    public variable subloc
    private variable mode_list

    public method cadd {{option -value} args}
    public method getMode {_hash}
    public method getAllModeSettings {_hash}
    public method getAllLegalModeSettings {}

}


#############################################################################
##  Method:  db::location::cadd
##
##  Arguments:
##      option
##          Add option
##
##      val
##          Add value
##
## Description:
##      Adds $value to a private list in the class depending on what -option
##      is. Returns true if option was added successfully, otherwise it calls
##      error.
itcl::body ::quartus::xmltiming::db::location::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::xmltiming::db::location::cadd requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -mode       { lappend mode_list $val }
        default     { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  db::location::getAllModeSettings
##
##  Arguments:
##      _hash
##          This is a passed-by-reference hash that you want filled
##          in with all the available mode settings. If the function
##          returns successfully this hash has the format:
##              <key: setting name> = <list: legal values>
##
## Description:
##      Fills in the _hash variable with all the settings and their
##      legal values that can be used to access the modes of this
##      block at this location. Returns true if at least one mode
##      was found at this location and there are settings filled in
##      your _hash variable; returns false if no modes are found and
##      no settings were added to your _hash variable. Please note
##      that not all combinations are LEGAL when you go searching
##      for a particular mode. If you want only LEGAL combinations
##      of mode attributes use the getAllLegalModeSettings method
##      instead.
itcl::body ::quartus::xmltiming::db::location::getAllModeSettings {_hash} {
    
    upvar 1 $_hash hash

    set retval 0

    foreach mode $mode_list {
        array set matts [$mode getAttributes]
        foreach att [array names matts] {
            lappend hash($att) $matts($att)
        }
    }
    # Now normalize hash() in case there are duplicates
    foreach key [array names hash] {
        catch {unset normal}
        foreach val $hash($key) {
            set normal($val) 1
        }
        # normal() is now a normalized list of values for hash($key)
        set hash($key) [array names normal]
        catch {unset normal}
    }
    set retval 1

    return $retval
}


#############################################################################
##  Method:  db::location::getAllLegalModeSettings
##
##  Arguments:
##      None
##
## Description:
##      Returns a list of lists. The list contains list of valid
##      key/value attribute pairs for each mode available at this
##      location. You can use this list of list to reconstruct
##      valid mode attribute arrays and retrieve specific modes from
##      the database. Returns "" if there are no modes.
itcl::body ::quartus::xmltiming::db::location::getAllLegalModeSettings {} {
    
    set tmplist ""

    foreach mode $mode_list {
        lappend tmplist [$mode getAttributes]
    }

    return $tmplist
}


#############################################################################
##  Method:  db::location::getMode
##
##  Arguments:
##      args
##          A list of key/value pairs that will be used to locate a
##          specific mode.
##
## Description:
##      Returns a pointer to the first mode object whose attributes 
##      match the attribute key/value parir arguments passed to the function.
##      Returns an empty string if no match is made against modes in 
##      the list.
itcl::body ::quartus::xmltiming::db::location::getMode {args} {

    # We use a foreach loop to build up our attributes array
    # because we want all the keys in upper case for easy
    # comparison.
    foreach {key value} [join $args] {
        set uatts([string toupper $key]) $value
    }

    set retval ""
    
    foreach mode $mode_list {
        set mode_match 1
        array set matts [$mode getAttributes]
        # If all of the attributes in uatts are found and have
        # (case-insensitive) values equal to those same attributes
        # in matts then this is our mode.
        foreach uatt [array names uatts] {
            if {![info exists matts($uatt)] || ![string equal -nocase $matts($uatt) $uatts($uatt)]} {
                set mode_match 0
                # Stop searching this mode. It doesn't match.
                break
            }
        }
        # If $mode_match is true then we found a mode that has all
        # of our uatts and the values all match. Stop searching.
        if {$mode_match} {
            set retval $mode
            break
        }

    }

    return $retval
}


#############################################################################
##  Class:  db::mode
##
##  Description:
##      Mode-level information. Holds a set of attributes, I's, etc.
itcl::class ::quartus::xmltiming::db::mode {

    constructor {{_name "#_unknown_#"}} {
        set name $_name
        array set attribute_list [list]
        set input_list [list]
        
        #jchoi: Code for supporting microparameters STARTS
        array set microparameter_list [list]
        #jchoi: Code for supporting microparameters ENDS
    }

    destructor {
        ##msg_vdebug "Class ::quartus::xmltiming::db::mode $this destructor"
        catch {eval delete object $input_list}
        catch {unset name input_list}
        catch {array unset attribute_list}     
        
        #jchoi: Code for supporting microparameters STARTS
        catch {array unset microparameter_list}
        #jchoi: Code for supporting microparameters ENDS
    }

    public variable name
    private variable attribute_list
    private variable input_list
    
    #jchoi: Code for supporting microparameters STARTS
    private variable microparameter_list
    #jchoi: Code for supporting microparameters ENDS

    public method cadd {{option -value} args}
    public method getAttributes
    public method getAllInputNames
    public method getInput {iname}
    
    #jchoi: Code for supporting microparameters STARTS
    public method getAllMicroparameterNames
    public method getMicroparameter {pname}
    #jchoi: Code for supporting microparameters ENDS

}


#############################################################################
##  Method:  db::mode::cadd
##
##  Arguments:
##      option
##          Add option
##
##      val
##          Add value
##
## Description:
##      Adds $value to a private list in the class depending on what -option
##      is. Returns true if option was added successfully, otherwise it calls
##      error.
itcl::body ::quartus::xmltiming::db::mode::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::xmltiming::db::mode::add requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -input      { lappend input_list $val }
        -attribute  {
            if {[llength $args] < 2} {
                error "::quartus::xmltiming::db::mode::add -attribute requires a key/value pair"
            }
            set key [lindex $args 0]
            set val [lindex $args 1]
            set attribute_list($key) $val
        }        
        #jchoi: Code for supporting microparameters STARTS
        -microparameter  {
            if {[llength $args] < 2} {
                error "::quartus::xmltiming::db::mode::add -microparameter requires a key/value pair"
            }
            set key [lindex $args 0]
            set val [lindex $args 1]
            set microparameter_list($key) $val
        }
        #jchoi: Code for supporting microparameters ENDS
        
        default     { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  db::mode::getAttributes
##
##  Arguments:
##      None
##
## Description:
##      Returns a list that represents the key/value pairs found in this
##      modes attribute list. The list is formed with [array get] so you
##      can use [array set] to rebuild the attribute list as an array
##      after you retrieve it.
itcl::body ::quartus::xmltiming::db::mode::getAttributes {} {
    return [array get attribute_list]
}


#############################################################################
##  Method:  db::mode::getAllInputNames
##
##  Arguments:
##      None
##
## Description:
##      Returns a list of all the inputs that are available for this
##      mode. You can use this list to pattern match against a users
##      request if you want to prempt searching the DB for illegal
##      device names.
itcl::body ::quartus::xmltiming::db::mode::getAllInputNames {} {

    set tmplist {}

    foreach input $input_list {
        lappend tmplist [$input cget -name]
    }
    
    return $tmplist

}


#############################################################################
##  Method:  db::mode::getInput
##
##  Arguments:
##      $iname
##          The name of the input to search list for
##
## Description:
##      Returns a pointer to the first input object whose name
##      matches the $iname argument passed to the function.
##      Returns an empty string if no match is made against inputs in 
##      the list.
itcl::body ::quartus::xmltiming::db::mode::getInput {iname} {
    
    set retval ""
    
    foreach input $input_list {
        if {[$input cget -name] == $iname} {
            set retval $input
            break
        }
    }

    return $retval
}


#jchoi: Code for supporting microparameters STARTS

#############################################################################
##  Method:  db::mode::getAllMicroparameterNames
##
##  Arguments:
##      None
##
## Description:
##      Returns a list of all the micoparameters that are available 
##      for this mode. You can use this list to pattern match against 
##      a users request if you want to prempt searching the DB for illegal
##      device names.
itcl::body ::quartus::xmltiming::db::mode::getAllMicroparameterNames {} {
    return [array names microparameter_list]
}

#############################################################################
##  Method:  db::mode::getMicroparameter
##
##  Arguments:
##      pname
##          Name of the microparameter
##
## Description:
##      Looks for a microparameter named $pname and returns the delay value
##      for this microparameter delay associated with this mode. 
##      Microparameter names are searched for in a case-insensitive 
##      manner. Returns -1 if output with $pname is not found.
itcl::body ::quartus::xmltiming::db::mode::getMicroparameter {pname} {
    set retval -1
    if {[info exists microparameter_list([string tolower $pname])]} {
        set retval $microparameter_list([string tolower $pname])
    }
    return $retval
}


#jchoi: Code for supporting microparameters ENDS

#############################################################################
##  Class:  db::input
##
##  Description:
##      I-level information. Holds a set of O's, etc.
itcl::class ::quartus::xmltiming::db::input {

    constructor {_name} {
        set name $_name
        array set output_list [list]
        
        #jchoi: Code for supporting microparameters STARTS
        array set microparameter_list [list]
        #jchoi: Code for supporting microparameters ENDS
    }

    destructor {
        catch {unset name}
        catch {array unset output_list}
        
        #jchoi: Code for supporting microparameters STARTS
        catch {array unset microparameter_list}
        #jchoi: Code for supporting microparameters ENDS
    }

    public variable name
    private variable output_list
    private variable microparameter_list

    public method cadd {{option -value} args}
    public method getAllOutputNames
    public method getDelayToOutput {oname}
    
    #jchoi: Code for supporting microparameters STARTS
    public method getAllMicroparameterNames
    public method getMicroparameter {pname}
    #jchoi: Code for supporting microparameters ENDS
}


#############################################################################
##  Method:  db::input::cadd
##
##  Arguments:
##      option
##          Add option
##
##      val
##          Add value
##
## Description:
##      Adds $value to a private list in the class depending on what -option
##      is. Returns true if option was added successfully, otherwise it calls
##      error.
itcl::body ::quartus::xmltiming::db::input::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::xmltiming::db::input::add requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -output {
            if {[llength $args] < 2} {
                error "::quartus::xmltiming::db::input::add -output requires a key/value pair"
            }
            set key [lindex $args 0]
            set val [lindex $args 1]
            set output_list($key) $val
        }
        
        #jchoi: Code for supporting microparameters STARTS
        -microparameter {
            if {[llength $args] < 2} {
                error "::quartus::xmltiming::db::input::add -microparameter requires a key/value pair"
            }
            set key [lindex $args 0]
            set val [lindex $args 1]
            set microparameter_list($key) $val
        }
        #jchoi: Code for supporting microparameters ENDS
        
        default     { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  db::input::getAllOutputNames
##
##  Arguments:
##      None
##
## Description:
##      Returns a list of all the outputs that are available for this
##      input. You can use this list to pattern match against a users
##      request if you want to prempt searching the DB for illegal
##      device names.
itcl::body ::quartus::xmltiming::db::input::getAllOutputNames {} {
    return [array names output_list]
}


#############################################################################
##  Method:  db::input::getDelayToOutput
##
##  Arguments:
##      oname
##          Name of the output
##
## Description:
##      Looks for an output named $oname and returns the delay value
##      from this input to the $oname output. Output names are searched
##      for in a case-insensitive manner. Returns -1 if output with
##      $oname is not found.
itcl::body ::quartus::xmltiming::db::input::getDelayToOutput {oname} {
    set retval -1
    if {[info exists output_list([string tolower $oname])]} {
        set retval $output_list([string tolower $oname])
    }
    return $retval
}


#jchoi: Code for supporting microparameters STARTS

#############################################################################
##  Method:  db::input::getAllMicroparameterNames
##
##  Arguments:
##      None
##
## Description:
##      Returns a list of all the microparameters that are available for this
##      input (which is actually representing a register here). 
##      You can use this list to pattern match against a users
##      request if you want to prempt searching the DB for illegal
##      device names.
itcl::body ::quartus::xmltiming::db::input::getAllMicroparameterNames {} {
    return [array names microparameter_list]
}


#############################################################################
##  Method:  db::input::getMicroparameter
##
##  Arguments:
##      pname
##          Name of the microparameter
##
## Description:
##      Looks for a microparameter named $pname and returns the delay value
##      for this microparameter delay of this register represented by the 
##      input. Microparameter names are searched for in a case-insensitive 
##      manner. Returns -1 if output with $pname is not found.
itcl::body ::quartus::xmltiming::db::input::getMicroparameter {pname} {
    set retval -1
    if {[info exists microparameter_list([string tolower $pname])]} {
        set retval $microparameter_list([string tolower $pname])
    }
    return $retval
}

#jchoi: Code for supporting microparameters ENDS

#############################################################################
##  Method:  db::icd::_xml_characterdata
##
##  Arguments:
##      data
##
##  Description:
##      Handler function used by the loadXML routine to deal with
##      character data as it's encountered in the XML file stream.
##      Register this handler with the XML parser.
itcl::body ::quartus::xmltiming::db::icd::_xml_characterdata {data} {
    
    # Get the current context and context_object
    set context [lindex $_xml_context end]
    set context_object [lindex $_xml_context_object end]

    switch -- $context {
        COPYRIGHT {
            append _xml_content_buildup $data
        }
        DELAY_UNITS {
            append _xml_content_buildup $data
        }
        O {
            append _xml_content_buildup $data
        }
        #jchoi: Code to support microparameters STARTS
        MICROPARAMETER {
            append _xml_content_buildup $data
        }
        #jchoi: Code to support microparameters ENDS
        default {
            # Do nothing
        }
    }
}


#############################################################################
## Method:  db::icd::_xml_elementstart
##
## Arguments:
##      name
##      attlist
##      args
##
## Description:
##      Handler function used by the loadXML routine to deal with
##      a starting element tag. Register this handler with the XML
##      parser.
itcl::body ::quartus::xmltiming::db::icd::_xml_elementstart {name attlist args} {
    ##msg_vdebug "$this _xml_element_start $name $attlist $args"
    # Unset the build-up variable
    if {[info exists _xml_content_buildup]} {
        unset _xml_content_buildup
    }
    
    # A hash of attributes is smarter than a list
    foreach {a v} $attlist {
        set atthash($a) $v
    }

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
        INTRACELLDELAYS {
            set name $atthash(name)
            lappend _xml_context_object $this
        }
        COPYRIGHT {
            #lappend _xml_context_object "COPYRIGHT"
            lappend _xml_context_object $context_object
        }
        DELAY_UNITS {
            #lappend _xml_context_object "DELAY_UNITS"
            lappend _xml_context_object $context_object
        }
        DEVICE {
            if {![info exists atthash(name)]} {
                set atthash(name) "COMMON"
            }
            set _device [uplevel #0 ::quartus::xmltiming::db::device #auto $atthash(name)]
            lappend _xml_context_object $_device
        }
        SPEED {
            if {![info exists atthash(grade)]} {
                set atthash(grade) "COMMON"
            }
            set _speed [uplevel #0 ::quartus::xmltiming::db::speed #auto $atthash(grade)]
            lappend _xml_context_object $_speed
        }
        BLOCK {
            if {![info exists atthash(subtype)]} {
                set atthash(subtype) "DEFAULT"
            }
            set _block [uplevel #0 ::quartus::xmltiming::db::block #auto $atthash(type) $atthash(subtype)]
            lappend _xml_context_object $_block
        }
        LOCATION {
            foreach key {x y subloc} {
                if {![info exists atthash($key)]} {
                    set atthash($key) 0
                }
            }
            set _location [uplevel #0 ::quartus::xmltiming::db::location #auto $atthash(x) $atthash(y) $atthash(subloc)]
            lappend _xml_context_object $_location
        }
        MODE {
            if {![info exists atthash(name)]} {
                set _mode [uplevel #0 ::quartus::xmltiming::db::mode #auto]
            } else {
                set _mode [uplevel #0 ::quartus::xmltiming::db::mode #auto $atthash(name)]
            }
            lappend _xml_context_object $_mode
        }
        ATTRIBUTE {
            $context_object cadd -attribute [string toupper $atthash(name)] $atthash(value)
            # If this isn't an empty tag push a dummy obj on to context
            if {!$argshash(-empty)} {
                lappend _xml_context_object "ATTRIBUTE"
            }
        }
        I {
            set _input [uplevel #0 ::quartus::xmltiming::db::input #auto $atthash(name)]
            lappend _xml_context_object $_input
        }
        O {
            lappend _xml_context_object $atthash(name)
        }      
        #jchoi: Code for supporting microparameters STARTS
        MICROPARAMETER {
            lappend _xml_context_object $atthash(name)
        }        
        #jchoi: Code for supporting microparameters ENDS
        default {
            # If this isn't an empty tag push a dummy obj on to context
            if {!$argshash(-empty)} {
                lappend _xml_context_object ""
            }
        }
    }
}


#############################################################################
## Method:  db::icd::_xml_elementend
##
## Arguments:
##      name
##      args
##
## Description:
##      Handler function used by the loadXML routine to deal with
##      an ending element tag. Register this handler with the XML
##      parser.
itcl::body ::quartus::xmltiming::db::icd::_xml_elementend {name args} {
    
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
        INTRACELLDELAYS {
            # Do nothing
        }
        COPYRIGHT {
            # Do nothing
        }
        DELAY_UNITS {
            if {[info exists _xml_content_buildup]} {
                $this configure -delay_units $_xml_content_buildup
            }
        }
        DEVICE {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::speed]} {
                $parent_context_object cadd -device $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing DEVICE tag and expected its parent to be"
                puts stderr "a SPEED object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        SPEED {
            $this cadd -speed $current_context_object
        }
        BLOCK {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::device]} {
                $parent_context_object cadd -block $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing BLOCK tag and expected its parent to be"
                puts stderr "a DEVICE object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        LOCATION {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::block]} {
                $parent_context_object cadd -location $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing LOCATION tag and expected its parent to be"
                puts stderr "a BLOCK object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        MODE {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::location]} {
                $parent_context_object cadd -mode $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing MODE tag and expected its parent to be"
                puts stderr "a LOCATION object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        ATTRIBUTE {
            # Do nothing
        }
        I {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::mode]} {
                $parent_context_object cadd -input $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing I tag and expected its parent to be"
                puts stderr "a MODE object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        O {
            if {[info exists _xml_content_buildup]} {
                if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::input]} {
                    # Ian's note: should we massage the content and make sure it's only an
                    #             integer value before we assign it?
                    $parent_context_object cadd -output [string tolower $current_context_object] $_xml_content_buildup
                } else {
                    puts stderr "Error parsing XML!"
                    puts stderr "We found a closing O tag and expected its parent to be"
                    puts stderr "an I object. But that was not the case!"
                    puts stderr "The parent was of the following class:"
                    puts stderr [$parent_context_object info class]
                    error "XML file was malformed!"
                }
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing O tag but there was no delay"
                puts stderr "value found in between the tags!"
                error "XML file was malformed!"
            }
        }
        
        #jchoi: Code for supporting microparameters STARTS
        MICROPARAMETER {
            if {[info exists _xml_content_buildup]} {
                if {$parent_context_object != ""} {
                    if {[$parent_context_object isa ::quartus::xmltiming::db::input]} {
                        $parent_context_object cadd -microparameter [string tolower $current_context_object] $_xml_content_buildup
                    } elseif {[$parent_context_object isa ::quartus::xmltiming::db::mode]} {
                        $parent_context_object cadd -microparameter [string tolower $current_context_object] $_xml_content_buildup
                    } else {
                        puts stderr "Error parsing XML!"
                        puts stderr "We found a closing MICROPARAMETER tag and expected its parent to be"
                        puts stderr "an I or MODE object. But that was not the case!"
                        puts stderr "The parent was of the following class:"
                        puts stderr [$parent_context_object info class]
                        error "XML file was malformed!"
                    }
                } else {
                    puts stderr "Error parsing XML!"
                    puts stderr "We found a closing MICROPARAMETER tag that has no parent!"
                    error "XML file was malformed!"
                }
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing MICROPARAMETER tag but there was no delay"
                puts stderr "value found in between the tags!"
                error "XML file was malformed!"
            }
        }
        #jchoi: Code for supporting microparameters ENDS
        
        default {
            # Do nothing
        }
    }
    # Unset the build-up variable
    catch {unset _xml_content_buildup}
}


#############################################################################
## Method:  db::icd::_xml_error
##
## Arguments:
##      errorcode
##      errormsg
##
## Description:
##      Handler function used by the loadXML routine to deal with
##      an errors in the stream. Register this handler with the XML
##      parser.
itcl::body ::quartus::xmltiming::db::icd::_xml_error {errorcode errormsg} {
    error $errormsg $errorcode
}


itcl::body ::quartus::xmltiming::db::icd::_xml_characterdata_test {data} {
    
    # Get the current context and context_object
    set context [lindex $_xml_context end]
    set context_object [lindex $_xml_context_object end]

    switch -- $context {
        COPYRIGHT {
            #append _xml_content_buildup $data
        }
        DELAY_UNITS {
            #append _xml_content_buildup $data
        }
        O {
            #append _xml_content_buildup $data
        }
        default {
            # Do nothing
        }
    }
}


itcl::body ::quartus::xmltiming::db::icd::_xml_elementstart_test {name attlist args} {
    
    # Unset the build-up variable
    if {[info exists _xml_content_buildup]} {
        unset _xml_content_buildup
    }
    
    # A hash of attributes is smarter than a list
    foreach {a v} $attlist {
        set atthash($a) $v
    }

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
        INTRACELLDELAYS {
# test            set name $atthash(name)
            lappend _xml_context_object "INTRACELLDELAYS"
        }
        COPYRIGHT {
            lappend _xml_context_object "COPYRIGHT"
# test            lappend _xml_context_object $context_object
        }
        DELAY_UNITS {
            lappend _xml_context_object "DELAY_UNITS"
# test            lappend _xml_context_object $context_object
        }
        DEVICE {
            if {![info exists atthash(name)]} {
                set atthash(name) "COMMON"
            }
# test            set _device [uplevel #0 ::quartus::xmltiming::db::device #auto $atthash(name)]
# test            lappend _xml_context_object $_device
            lappend _xml_context_object "DEVICE"
        }
        SPEED {
            if {![info exists atthash(grade)]} {
                set atthash(grade) "COMMON"
            }
# test            set _speed [uplevel #0 ::quartus::xmltiming::db::speed #auto $atthash(grade)]
# test            lappend _xml_context_object $_speed
            lappend _xml_context_object "SPEED"
        }
        BLOCK {
            if {![info exists atthash(subtype)]} {
                set atthash(subtype) "DEFAULT"
            }
# test            set _block [uplevel #0 ::quartus::xmltiming::db::block #auto $atthash(type) $atthash(subtype)]
# test            lappend _xml_context_object $_block
            lappend _xml_context_object "BLOCK"
        }
        LOCATION {
            foreach key {x y subloc} {
                if {![info exists atthash($key)]} {
                    set atthash($key) 0
                }
            }
# test            set _location [uplevel #0 ::quartus::xmltiming::db::location #auto $atthash(x) $atthash(y) $atthash(subloc)]
# test            lappend _xml_context_object $_location
            lappend _xml_context_object "LOCATION"
        }
        MODE {
# test            if {![info exists atthash(name)]} {
# test                set _mode [uplevel #0 ::quartus::xmltiming::db::mode #auto]
# test            } else {
# test                set _mode [uplevel #0 ::quartus::xmltiming::db::mode #auto $atthash(name)]
# test            }
# test            lappend _xml_context_object $_mode
            lappend _xml_context_object "MODE"
        }
        ATTRIBUTE {
# test            $context_object cadd -attribute [string toupper $atthash(name)] $atthash(value)
            # If this isn't an empty tag push a dummy obj on to context
            if {!$argshash(-empty)} {
                lappend _xml_context_object "ATTRIBUTE"
            }
        }
        I {
# test            set _input [uplevel #0 ::quartus::xmltiming::db::input #auto $atthash(name)]
# test            lappend _xml_context_object $_input
            lappend _xml_context_object "INPUT"
        }
        O {
            lappend _xml_context_object $atthash(name)
        }
        default {
            # If this isn't an empty tag push a dummy obj on to context
            if {!$argshash(-empty)} {
                lappend _xml_context_object ""
            }
        }
    }
}


itcl::body ::quartus::xmltiming::db::icd::_xml_elementend_test {name args} {
    
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
        INTRACELLDELAYS {
            # Do nothing
        }
        COPYRIGHT {
            # Do nothing
        }
        DELAY_UNITS {
            if {[info exists _xml_content_buildup]} {
                $this configure -delay_units $_xml_content_buildup
            }
        }
        DEVICE {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::speed]} {
                $parent_context_object cadd -device $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing DEVICE tag and expected its parent to be"
                puts stderr "a SPEED object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        SPEED {
            $this cadd -speed $current_context_object
        }
        BLOCK {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::device]} {
                $parent_context_object cadd -block $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing BLOCK tag and expected its parent to be"
                puts stderr "a DEVICE object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        LOCATION {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::block]} {
                $parent_context_object cadd -location $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing LOCATION tag and expected its parent to be"
                puts stderr "a BLOCK object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        MODE {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::location]} {
                $parent_context_object cadd -mode $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing MODE tag and expected its parent to be"
                puts stderr "a LOCATION object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        ATTRIBUTE {
            # Do nothing
        }
        I {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::mode]} {
                $parent_context_object cadd -input $current_context_object
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing I tag and expected its parent to be"
                puts stderr "a MODE object. But that was not the case!"
                puts stderr "The parent was of the following class:"
                puts stderr [$parent_context_object info class]
                error "XML file was malformed!"
            }
        }
        O {
            if {[info exists _xml_content_buildup]} {
                if {$parent_context_object != "" && [$parent_context_object isa ::quartus::xmltiming::db::input]} {
                    # Ian's note: should we massage the content and make sure it's only an
                    #             integer value before we assign it?
                    $parent_context_object cadd -output [string tolower $current_context_object] $_xml_content_buildup
                } else {
                    puts stderr "Error parsing XML!"
                    puts stderr "We found a closing O tag and expected its parent to be"
                    puts stderr "an I object. But that was not the case!"
                    puts stderr "The parent was of the following class:"
                    puts stderr [$parent_context_object info class]
                    error "XML file was malformed!"
                }
            } else {
                puts stderr "Error parsing XML!"
                puts stderr "We found a closing O tag but there was no delay"
                puts stderr "value found in between the tags!"
                error "XML file was malformed!"
            }
        }
        default {
            # Do nothing
        }
    }
    # Unset the build-up variable
    catch {unset _xml_content_buildup}
}


itcl::body ::quartus::xmltiming::db::icd::_xml_error_test {errorcode errormsg} {
    error $errormsg $errorcode
}
