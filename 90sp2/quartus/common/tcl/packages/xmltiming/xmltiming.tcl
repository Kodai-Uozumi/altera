#############################################################################
##  xmltiming.tcl - v1.0
##
##  This Tcl/Tk library provides access to the Quartus II EDA Toolkit XML
##  intracell delays files.
##
##  To use these functions in your own Tcl/Tk scripts just add:
##
##      package require ::quartus::xmltiming
##
##  to the top of your scripts. You'll also need the *.icd files from an
##  EDA toolkit. These files should be placed someplace on your $auto_path
##  and the script will find them automatically as it needs to load data.
##
##  These functions look a lot like the functions found in the quartus_cmd
##  Tcl timing API, but they are different. Read the interface descriptions
##  above each function and check out the test-main.tcl script that came
##  with this package. It's a good example of how to use this API (and also
##  an excellent example of how to build a data-driven method for extracting
##  data from XML files).
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


package provide ::quartus::xmltiming 1.0


#############################################################################
##  Additional Packages Required
package require ::quartus::xmltiming::db
package require Itcl 3.1
package require xml 2.0
package require cmdline 1.2


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::xmltiming {

    namespace export get_delay
    namespace export get_block_types
    namespace export get_locations
    namespace export get_inputs
    namespace export get_outputs
    namespace export get_attributes
    namespace export build_cache
    namespace export clear_cached_data
    namespace export get_general_microparameters
    namespace export get_general_microparameter
    namespace export get_register_microparameters
    namespace export get_register_microparameter

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
                            
    # Name: cached_families
    # Type: array
    # Description: An array of family names and timestamps on the XML files
    #              that have already had thier timing data cached by the
    #              API. A check is always made when a user calls get_timing
    #              to see if:
    #                 1) The timing data has already been cached;
    #                 2) The cache date in this array is greater than or
    #                    equal to the file mod time from which the cache
    #                    data came from on disk.
    variable cached_families

    # Name: cache
    # Type: complex data structure
    # Description: This is a complicated data structure that contains
    #              cached data read in from the XML files on disk.
    #              It is loaded by the load_xml_data function and really
    #              should only ever be accessed by get_timing or one of
    #              the querying functions. No direct access to the cache
    #              should ever be provided.
    variable cache

    # Name: no_cache_data
    # Type: boolean
    # Description: Lets the user turn off data caching if memory usage
    #              is a concern. Not recommend you ever change this from
    #              the default, which is to cache the data. But who am
    #              I to try and stop you? To make it difficult I'm not
    #              giving you an easy way to change this variable. You
    #              want no caching -- you figure out how to disable it.
    variable no_cache_data 0

}


#############################################################################
##  Procedure: get_block_types
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##
##  Description:
##      Returns a list of lists. The list contains valid block type/subtype
##      combinations for this part. For example:
##
##          % puts [get_block_types -part FAKEDEVICE]
##          {LE DEFAULT} {LE REGISTER_ONLY}
##
##      See how that's a list of lists?
proc ::quartus::xmltiming::get_block_types {args} {
    
    # For debug messages
    set proc_name "get_cell_types()"

    # Bring global namespace variables into proc space
    variable no_cache_data

    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }
    
    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    # Now use myDeviceList to find all the blocks available
    set myblocklist [list]
    foreach mydevice $myDeviceList {
        foreach pair [$mydevice getAllBlockNames] {
            lappend myblocklist $pair
        }
        unset mydevice
    }

    # If myblocklist doesn't exist then we didn't find any blocks in
    # the speed-grade specific or COMMON section of the database.
    # Issue an error.
    if {[llength $myblocklist] == 0} {
        error "No blocks found for part"
    }

    # Normalize the block list in case there are duplicates
    array set t [list]
    foreach pair $myblocklist {
        set t($pair) 1
    }
    set myblocklist [array names t]
    catch {array unset t}

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the block list
    return $myblocklist
}


#############################################################################
##  Procedure: get_locations
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##          -blocktype <blocktype>
##              The block type for which you would like locations.
##              Not optional.
##
##          -blocksubtype <subtype>
##              The block subtype to use. Optional. The default value
##              is "DEFAULT" if the user does not set this option.
##
##  Description:
##      Returns a list of lists. The list contains valid locations
##      for this block's type/subtype combination. The list contains
##      lists of co-ordinate triplicates in the form {x y subloc}.
##      For example:
##
##          % puts [get_locations -part FAKEDEVICE -blocktype LE -blocksubtype REGISTER_ONLY]
##          {0 0 0} {0 0 1} {0 0 2} {0 0 3} {0 0 4} {0 0 5} {0 0 6} {0 0 7}
##
##      See how that's a list of lists?
proc ::quartus::xmltiming::get_locations {args} {
    
    # For debug messages
    set proc_name "get_locations()"

    # Bring global namespace variables into proc space
    variable no_cache_data

    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    set         tlist       "blocktype.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The block type"
    lappend function_opts $tlist

    set         tlist       "blocksubtype.arg"
    lappend     tlist       "DEFAULT"
    lappend     tlist       "The block sub-type"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            #msg_vdebug "Error: ${proc_name}: Missing required option -${opt}"
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }

    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    foreach mydevice $myDeviceList {
        set myblock [$mydevice getBlock $optshash(blocktype) $optshash(blocksubtype)]
        if {$myblock != ""} {
            break
        }
    }

    # If myblock doesn't exist then we didn't find the block
    # issue an error.
    if {![info exists myblock] || $myblock == ""} {
        error "Block not found"
    }

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the locations list
    return [$myblock getAllLocations]
}


#############################################################################
##  Procedure: get_attributes
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##          -blocktype <blocktype>
##              The block type for which you would like locations.
##              Not optional.
##
##          -blocksubtype <subtype>
##              The block subtype to use. Optional. The default value
##              is "DEFAULT" if the user does not set this option.
##
##          -x <x_coord>
##              The X location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -y <y_coord>
##              The Y location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -subloc <subloc_coord>
##              The Subloc location co-ordinate of the block. Optional.
##              Default value is 0.
##
##  Description:
##      Returns a list of lists. The list contains sets of valid
##      attributes that represent configuration modes of the block
##      at this location. You can make arrays out of these sets
##      with [array set] or pass a set directly to the get_delay
##      function's -attributes setting.
proc ::quartus::xmltiming::get_attributes {args} {
    
    # For debug messages
    set proc_name "get_attributes()"

    # Bring global namespace variables into proc space
    variable no_cache_data

    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    set         tlist       "blocktype.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The block type"
    lappend function_opts $tlist

    set         tlist       "blocksubtype.arg"
    lappend     tlist       "DEFAULT"
    lappend     tlist       "The block sub-type"
    lappend function_opts $tlist

    set         tlist       "x.arg"
    lappend     tlist       "0"
    lappend     tlist       "The X co-ordinate"
    lappend function_opts $tlist
    
    set         tlist       "y.arg"
    lappend     tlist       "0"
    lappend     tlist       "The Y co-ordinate"
    lappend function_opts $tlist

    set         tlist       "subloc.arg"
    lappend     tlist       "0"
    lappend     tlist       "The SUBLOC co-ordinate"
    lappend function_opts $tlist
    
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            #msg_vdebug "Error: ${proc_name}: Missing required option -${opt}"
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }

    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    foreach mydevice $myDeviceList {
        set myblock [$mydevice getBlock $optshash(blocktype) $optshash(blocksubtype)]
        if {$myblock != ""} {
            break
        }
    }

    # If myblock doesn't exist then we didn't find the block
    # issue an error.
    if {![info exists myblock] || $myblock == ""} {
        error "Block not found"
    }

    # Get the location now
    set mylocation [$myblock getLocation $optshash(x) $optshash(y) $optshash(subloc)]
    if {$mylocation == ""} {
        error "Location not found for block"
    }

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the valid attibute combinations.
    return [$mylocation getAllLegalModeSettings]
}


#############################################################################
##  Procedure: get_inputs
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##          -blocktype <blocktype>
##              The block type for which you would like locations.
##              Not optional.
##
##          -blocksubtype <subtype>
##              The block subtype to use. Optional. The default value
##              is "DEFAULT" if the user does not set this option.
##
##          -x <x_coord>
##              The X location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -y <y_coord>
##              The Y location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -subloc <subloc_coord>
##              The Subloc location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -attributes <attribute_list>
##              A list of attributes that can be read in with [array set]
##              to form a hash table of key/value attribute pairs. To
##              find valid lists of attributes for a cell use the
##              get_attributes function.
##
##  Description:
##      Returns a list. The list contains all the valid inputs that this
##      block has, at this location, when its configured with these attributes.
proc ::quartus::xmltiming::get_inputs {args} {
    
    # For debug messages
    set proc_name "get_inputs()"

    # Bring global namespace variables into proc space
    variable no_cache_data
    
    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    set         tlist       "blocktype.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The block type"
    lappend function_opts $tlist

    set         tlist       "blocksubtype.arg"
    lappend     tlist       "DEFAULT"
    lappend     tlist       "The block sub-type"
    lappend function_opts $tlist

    set         tlist       "x.arg"
    lappend     tlist       "0"
    lappend     tlist       "The X co-ordinate"
    lappend function_opts $tlist
    
    set         tlist       "y.arg"
    lappend     tlist       "0"
    lappend     tlist       "The Y co-ordinate"
    lappend function_opts $tlist

    set         tlist       "subloc.arg"
    lappend     tlist       "0"
    lappend     tlist       "The SUBLOC co-ordinate"
    lappend function_opts $tlist

    set         tlist       "attributes.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The list of attributes"
    lappend function_opts $tlist
    
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            #msg_vdebug "Error: ${proc_name}: Missing required option -${opt}"
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }

    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    foreach mydevice $myDeviceList {
        set myblock [$mydevice getBlock $optshash(blocktype) $optshash(blocksubtype)]
        if {$myblock != ""} {
            break
        }
    }

    # If myblock doesn't exist then we didn't find the block
    # issue an error.
    if {![info exists myblock] || $myblock == ""} {
        error "Block not found"
    }

    # Get the location now
    set mylocation [$myblock getLocation $optshash(x) $optshash(y) $optshash(subloc)]
    if {$mylocation == ""} {
        error "Location not found for block"
    }

    # Get the mode now
    set mymode [$mylocation getMode $optshash(attributes)]
    if {$mymode == ""} {
        error "Mode not found for given attributes"
    }

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the inputs.
    return [$mymode getAllInputNames]
}

#############################################################################
##  Procedure: get_general_microparameters
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##          -blocktype <blocktype>
##              The block type for which you would like locations.
##              Not optional.
##
##          -blocksubtype <subtype>
##              The block subtype to use. Optional. The default value
##              is "DEFAULT" if the user does not set this option.
##
##          -x <x_coord>
##              The X location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -y <y_coord>
##              The Y location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -subloc <subloc_coord>
##              The Subloc location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -attributes <attribute_list>
##              A list of attributes that can be read in with [array set]
##              to form a hash table of key/value attribute pairs. To
##              find valid lists of attributes for a cell use the
##              get_attributes function.
##
##  Description:
##      Returns a list. The list contains all the valid general microparameters 
##      that this block has, at this location, when its configured with 
##      these attributes.
proc ::quartus::xmltiming::get_general_microparameters {args} {
    
    # For debug messages
    set proc_name "get_general_microparameters()"

    # Bring global namespace variables into proc space
    variable no_cache_data
    
    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    set         tlist       "blocktype.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The block type"
    lappend function_opts $tlist

    set         tlist       "blocksubtype.arg"
    lappend     tlist       "DEFAULT"
    lappend     tlist       "The block sub-type"
    lappend function_opts $tlist

    set         tlist       "x.arg"
    lappend     tlist       "0"
    lappend     tlist       "The X co-ordinate"
    lappend function_opts $tlist
    
    set         tlist       "y.arg"
    lappend     tlist       "0"
    lappend     tlist       "The Y co-ordinate"
    lappend function_opts $tlist

    set         tlist       "subloc.arg"
    lappend     tlist       "0"
    lappend     tlist       "The SUBLOC co-ordinate"
    lappend function_opts $tlist

    set         tlist       "attributes.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The list of attributes"
    lappend function_opts $tlist
    
    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            #msg_vdebug "Error: ${proc_name}: Missing required option -${opt}"
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }

    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    foreach mydevice $myDeviceList {
        set myblock [$mydevice getBlock $optshash(blocktype) $optshash(blocksubtype)]
        if {$myblock != ""} {
            break
        }
    }

    # If myblock doesn't exist then we didn't find the block
    # issue an error.
    if {![info exists myblock] || $myblock == ""} {
        error "Block not found"
    }

    # Get the location now
    set mylocation [$myblock getLocation $optshash(x) $optshash(y) $optshash(subloc)]
    if {$mylocation == ""} {
        error "Location not found for block"
    }

    # Get the mode now
    set mymode [$mylocation getMode $optshash(attributes)]
    if {$mymode == ""} {
        error "Mode not found for given attributes"
    }

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the inputs.
    return [$mymode getAllMicroparameterNames]
}


#############################################################################
##  Procedure: get_outputs
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##          -blocktype <blocktype>
##              The block type for which you would like locations.
##              Not optional.
##
##          -blocksubtype <subtype>
##              The block subtype to use. Optional. The default value
##              is "DEFAULT" if the user does not set this option.
##
##          -x <x_coord>
##              The X location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -y <y_coord>
##              The Y location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -subloc <subloc_coord>
##              The Subloc location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -attributes <attribute_list>
##              A list of attributes that can be read in with [array set]
##              to form a hash table of key/value attribute pairs. To
##              find valid lists of attributes for a cell use the
##              get_attributes function.
##
##          -input <input_name>
##              The name of the input to get all the outputs for.
##              Required.
##
##  Description:
##      Returns a list. The list contains all the valid outputs that
##      this input has when this when this block, at this location, is
##      configured with these attributes.
proc ::quartus::xmltiming::get_outputs {args} {
    
    # For debug messages
    set proc_name "get_outputs()"

    # Bring global namespace variables into proc space
    variable no_cache_data

    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    set         tlist       "blocktype.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The block type"
    lappend function_opts $tlist

    set         tlist       "blocksubtype.arg"
    lappend     tlist       "DEFAULT"
    lappend     tlist       "The block sub-type"
    lappend function_opts $tlist

    set         tlist       "x.arg"
    lappend     tlist       "0"
    lappend     tlist       "The X co-ordinate"
    lappend function_opts $tlist
    
    set         tlist       "y.arg"
    lappend     tlist       "0"
    lappend     tlist       "The Y co-ordinate"
    lappend function_opts $tlist

    set         tlist       "subloc.arg"
    lappend     tlist       "0"
    lappend     tlist       "The SUBLOC co-ordinate"
    lappend function_opts $tlist

    set         tlist       "attributes.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The list of attributes"
    lappend function_opts $tlist
    
    set         tlist       "input.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The input"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            #msg_vdebug "Error: ${proc_name}: Missing required option -${opt}"
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }

    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    foreach mydevice $myDeviceList {
        set myblock [$mydevice getBlock $optshash(blocktype) $optshash(blocksubtype)]
        if {$myblock != ""} {
            break
        }
    }

    # If myblock doesn't exist then we didn't find the block
    # issue an error.
    if {![info exists myblock] || $myblock == ""} {
        error "Block not found"
    }

    # Get the location now
    set mylocation [$myblock getLocation $optshash(x) $optshash(y) $optshash(subloc)]
    if {$mylocation == ""} {
        error "Location not found for block"
    }

    # Get the mode now
    set mymode [$mylocation getMode $optshash(attributes)]
    if {$mymode == ""} {
        error "Mode not found for given attributes"
    }

    # Get the input now
    set myinput [$mymode getInput $optshash(input)]
    if {$myinput == ""} {
        #msg_vdebug "Error: ${proc_name}: Could not find an input named $optshash(input)"
        #msg_vdebug "Error: ${proc_name}: Are you sure this is a valid input?"
        error "Input not found"
    }

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the inputs.
    return [$myinput getAllOutputNames]
}

#############################################################################
##  Procedure: get_register_microparameters
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##          -blocktype <blocktype>
##              The block type for which you would like locations.
##              Not optional.
##
##          -blocksubtype <subtype>
##              The block subtype to use. Optional. The default value
##              is "DEFAULT" if the user does not set this option.
##
##          -x <x_coord>
##              The X location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -y <y_coord>
##              The Y location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -subloc <subloc_coord>
##              The Subloc location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -attributes <attribute_list>
##              A list of attributes that can be read in with [array set]
##              to form a hash table of key/value attribute pairs. To
##              find valid lists of attributes for a cell use the
##              get_attributes function.
##
##          -register <input_name>
##              The name of the register to get the microparameters.
##              Required.
##
##  Description:
##      Returns a list. The list contains all the valid register
##      microparameters that this register has when this when this 
##      block, at this location, is configured with these attributes.
proc ::quartus::xmltiming::get_register_microparameters {args} {
    
    # For debug messages
    set proc_name "get_register_microparameters()"

    # Bring global namespace variables into proc space
    variable no_cache_data

    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    set         tlist       "blocktype.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The block type"
    lappend function_opts $tlist

    set         tlist       "blocksubtype.arg"
    lappend     tlist       "DEFAULT"
    lappend     tlist       "The block sub-type"
    lappend function_opts $tlist

    set         tlist       "x.arg"
    lappend     tlist       "0"
    lappend     tlist       "The X co-ordinate"
    lappend function_opts $tlist
    
    set         tlist       "y.arg"
    lappend     tlist       "0"
    lappend     tlist       "The Y co-ordinate"
    lappend function_opts $tlist

    set         tlist       "subloc.arg"
    lappend     tlist       "0"
    lappend     tlist       "The SUBLOC co-ordinate"
    lappend function_opts $tlist

    set         tlist       "attributes.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The list of attributes"
    lappend function_opts $tlist
    
    set         tlist       "register.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The register"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            #msg_vdebug "Error: ${proc_name}: Missing required option -${opt}"
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }

    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    foreach mydevice $myDeviceList {
        set myblock [$mydevice getBlock $optshash(blocktype) $optshash(blocksubtype)]
        if {$myblock != ""} {
            break
        }
    }

    # If myblock doesn't exist then we didn't find the block
    # issue an error.
    if {![info exists myblock] || $myblock == ""} {
        error "Block not found"
    }

    # Get the location now
    set mylocation [$myblock getLocation $optshash(x) $optshash(y) $optshash(subloc)]
    if {$mylocation == ""} {
        error "Location not found for block"
    }

    # Get the mode now
    set mymode [$mylocation getMode $optshash(attributes)]
    if {$mymode == ""} {
        error "Mode not found for given attributes"
    }

    # Get the register now
    set myinput [$mymode getInput $optshash(register)]
    if {$myinput == ""} {
        #msg_vdebug "Error: ${proc_name}: Could not find a register named $optshash(register)"
        #msg_vdebug "Error: ${proc_name}: Are you sure this is a valid register?"
        error "Register not found"
    }

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the inputs.
    return [$myinput getAllMicroparameterNames]
}


#############################################################################
##  Procedure: get_delay
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##          -blocktype <blocktype>
##              The block type for which you would like locations.
##              Not optional.
##
##          -blocksubtype <subtype>
##              The block subtype to use. Optional. The default value
##              is "DEFAULT" if the user does not set this option.
##
##          -x <x_coord>
##              The X location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -y <y_coord>
##              The Y location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -subloc <subloc_coord>
##              The Subloc location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -attributes <attribute_list>
##              A list of attributes that can be read in with [array set]
##              to form a hash table of key/value attribute pairs. To
##              find valid lists of attributes for a cell use the
##              get_attributes function.
##
##          -input <input_name>
##              The name of the input. Required.
##
##          -output <output_name>
##              The name of the output. Required.
##
##          -withunits
##              A boolean option. If present on the command line then
##              the string returned will contain the delay value
##              and the units for the delay value. Without this
##              option you just get the integer delay value.
##
##  Description:
##      Returns the delay value for a particular input/output pair
##      on a block at a location with a specific configuration. The
##      delay value returned is an integer value unless the -withunits
##      option is used and then you get a string back that has the
##      delay value, a space and then the units of the delay value
##      in it.
proc ::quartus::xmltiming::get_delay {args} {
    
    # For debug messages
    set proc_name "get_delay()"

    # Bring global namespace variables into proc space
    variable no_cache_data

    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    set         tlist       "blocktype.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The block type"
    lappend function_opts $tlist

    set         tlist       "blocksubtype.arg"
    lappend     tlist       "DEFAULT"
    lappend     tlist       "The block sub-type"
    lappend function_opts $tlist

    set         tlist       "x.arg"
    lappend     tlist       "0"
    lappend     tlist       "The X co-ordinate"
    lappend function_opts $tlist
    
    set         tlist       "y.arg"
    lappend     tlist       "0"
    lappend     tlist       "The Y co-ordinate"
    lappend function_opts $tlist

    set         tlist       "subloc.arg"
    lappend     tlist       "0"
    lappend     tlist       "The SUBLOC co-ordinate"
    lappend function_opts $tlist

    set         tlist       "attributes.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The list of attributes"
    lappend function_opts $tlist
    
    set         tlist       "input.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The input"
    lappend function_opts $tlist

    set         tlist       "output.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The output"
    lappend function_opts $tlist

    set         tlist       "withunits"
    lappend     tlist       0
    lappend     tlist       "Append units to the return string or not"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            #msg_vdebug "Error: ${proc_name}: Missing required option -${opt}"
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }

    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    foreach mydevice $myDeviceList {
        set myblock [$mydevice getBlock $optshash(blocktype) $optshash(blocksubtype)]
        if {$myblock != ""} {
            break
        }
    }

    # If myblock doesn't exist then we didn't find the block
    # issue an error.
    if {![info exists myblock] || $myblock == ""} {
        error "Block not found"
    }

    # Get the location now
    set mylocation [$myblock getLocation $optshash(x) $optshash(y) $optshash(subloc)]
    if {$mylocation == ""} {
        error "Location not found for block"
    }

    # Get the mode now
    set mymode [$mylocation getMode $optshash(attributes)]
    if {$mymode == ""} {
        error "Mode not found for given attributes"
    }

    # Get the input now
    set myinput [$mymode getInput $optshash(input)]
    if {$myinput == ""} {
        #msg_vdebug "Error: ${proc_name}: Could not find an input named $optshash(input)"
        #msg_vdebug "Error: ${proc_name}: Are you sure this is a valid input?"
        error "Input not found"
    }

    # Get the delay now
    set mydelay [$myinput getDelayToOutput $optshash(output)]
    if {$mydelay < 0} {
        #msg_vdebug "Error: ${proc_name}: Could not get a delay for $optshash(input) -> $optshash(output) pair"
        #msg_vdebug "Error: ${proc_name}: Are you sure this is a valid input/output pair?"
        error "No delay found for input/output pair"
    }
    
    # Append units?
    if {$optshash(withunits)} {
        set mydelay "${mydelay} [$myCache cget -delay_units]"
    }

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the delay.
    return $mydelay
}

#############################################################################
##  Procedure: get_register_microparameter
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##          -blocktype <blocktype>
##              The block type for which you would like locations.
##              Not optional.
##
##          -blocksubtype <subtype>
##              The block subtype to use. Optional. The default value
##              is "DEFAULT" if the user does not set this option.
##
##          -x <x_coord>
##              The X location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -y <y_coord>
##              The Y location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -subloc <subloc_coord>
##              The Subloc location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -attributes <attribute_list>
##              A list of attributes that can be read in with [array set]
##              to form a hash table of key/value attribute pairs. To
##              find valid lists of attributes for a cell use the
##              get_attributes function.
##
##          -register <register_name>
##              The name of the register. Required.
##
##          -microparameter <microparameter_name>
##              The name of the microparameter. Required.
##
##          -withunits
##              A boolean option. If present on the command line then
##              the string returned will contain the delay value
##              and the units for the delay value. Without this
##              option you just get the integer delay value.
##
##  Description:
##      Returns the delay value for a particular register/uParam pair
##      on a block at a location with a specific configuration. The
##      delay value returned is an integer value unless the -withunits
##      option is used and then you get a string back that has the
##      delay value, a space and then the units of the delay value
##      in it.
proc ::quartus::xmltiming::get_register_microparameter {args} {
    
    # For debug messages
    set proc_name "get_register_microparamter()"

    # Bring global namespace variables into proc space
    variable no_cache_data

    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    set         tlist       "blocktype.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The block type"
    lappend function_opts $tlist

    set         tlist       "blocksubtype.arg"
    lappend     tlist       "DEFAULT"
    lappend     tlist       "The block sub-type"
    lappend function_opts $tlist

    set         tlist       "x.arg"
    lappend     tlist       "0"
    lappend     tlist       "The X co-ordinate"
    lappend function_opts $tlist
    
    set         tlist       "y.arg"
    lappend     tlist       "0"
    lappend     tlist       "The Y co-ordinate"
    lappend function_opts $tlist

    set         tlist       "subloc.arg"
    lappend     tlist       "0"
    lappend     tlist       "The SUBLOC co-ordinate"
    lappend function_opts $tlist

    set         tlist       "attributes.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The list of attributes"
    lappend function_opts $tlist
    
    set         tlist       "register.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The register"
    lappend function_opts $tlist

    set         tlist       "microparameter.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The microparameter"
    lappend function_opts $tlist

    set         tlist       "withunits"
    lappend     tlist       0
    lappend     tlist       "Append units to the return string or not"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            #msg_vdebug "Error: ${proc_name}: Missing required option -${opt}"
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }

    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    foreach mydevice $myDeviceList {
        set myblock [$mydevice getBlock $optshash(blocktype) $optshash(blocksubtype)]
        if {$myblock != ""} {
            break
        }
    }

    # If myblock doesn't exist then we didn't find the block
    # issue an error.
    if {![info exists myblock] || $myblock == ""} {
        error "Block not found"
    }

    # Get the location now
    set mylocation [$myblock getLocation $optshash(x) $optshash(y) $optshash(subloc)]
    if {$mylocation == ""} {
        error "Location not found for block"
    }

    # Get the mode now
    set mymode [$mylocation getMode $optshash(attributes)]
    if {$mymode == ""} {
        error "Mode not found for given attributes"
    }

    # Get the register now
    set myinput [$mymode getInput $optshash(register)]
    if {$myinput == ""} {
        #msg_vdebug "Error: ${proc_name}: Could not find a register named $optshash(register)"
        #msg_vdebug "Error: ${proc_name}: Are you sure this is a valid register?"
        error "Register not found"
    }

    # Get the microparameter now
    set mydelay [$myinput getMicroparameter $optshash(microparameter)]
    if {$mydelay < 0} {
        #msg_vdebug "Error: ${proc_name}: Could not get a delay for $optshash(register) -> $optshash(microparameter) pair"
        #msg_vdebug "Error: ${proc_name}: Are you sure this is a valid register/microparameter pair?"
        error "No delay found for register/microparameter pair"
    }
    
    # Append units?
    if {$optshash(withunits)} {
        set mydelay "${mydelay} [$myCache cget -delay_units]"
    }

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the delay.
    return $mydelay
}



#############################################################################
##  Procedure: get_general_microparameter
##
##  Arguments:
##      The available arguments and their defaults are as follows:
##
##          -part <part>
##              The part to use for timing numbers. Not optional.
##
##          -blocktype <blocktype>
##              The block type for which you would like locations.
##              Not optional.
##
##          -blocksubtype <subtype>
##              The block subtype to use. Optional. The default value
##              is "DEFAULT" if the user does not set this option.
##
##          -x <x_coord>
##              The X location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -y <y_coord>
##              The Y location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -subloc <subloc_coord>
##              The Subloc location co-ordinate of the block. Optional.
##              Default value is 0.
##
##          -attributes <attribute_list>
##              A list of attributes that can be read in with [array set]
##              to form a hash table of key/value attribute pairs. To
##              find valid lists of attributes for a cell use the
##              get_attributes function.
##
##          -microparameter <microparameter_name>
##              The name of the microparameter. Required.
##
##          -withunits
##              A boolean option. If present on the command line then
##              the string returned will contain the delay value
##              and the units for the delay value. Without this
##              option you just get the integer delay value.
##
##  Description:
##      Returns the delay value for a particular block/uParam pair
##      on a block at a location with a specific configuration. The
##      delay value returned is an integer value unless the -withunits
##      option is used and then you get a string back that has the
##      delay value, a space and then the units of the delay value
##      in it.
proc ::quartus::xmltiming::get_general_microparameter {args} {
    
    # For debug messages
    set proc_name "get_general_microparamter()"

    # Bring global namespace variables into proc space
    variable no_cache_data

    # Command line options to this function we require
    set         tlist       "part.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The part"
    lappend function_opts $tlist

    set         tlist       "blocktype.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The block type"
    lappend function_opts $tlist

    set         tlist       "blocksubtype.arg"
    lappend     tlist       "DEFAULT"
    lappend     tlist       "The block sub-type"
    lappend function_opts $tlist

    set         tlist       "x.arg"
    lappend     tlist       "0"
    lappend     tlist       "The X co-ordinate"
    lappend function_opts $tlist
    
    set         tlist       "y.arg"
    lappend     tlist       "0"
    lappend     tlist       "The Y co-ordinate"
    lappend function_opts $tlist

    set         tlist       "subloc.arg"
    lappend     tlist       "0"
    lappend     tlist       "The SUBLOC co-ordinate"
    lappend function_opts $tlist

    set         tlist       "attributes.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The list of attributes"
    lappend function_opts $tlist
    
    set         tlist       "microparameter.arg"
    lappend     tlist       "#_required_#"
    lappend     tlist       "The microparameter"
    lappend function_opts $tlist

    set         tlist       "withunits"
    lappend     tlist       0
    lappend     tlist       "Append units to the return string or not"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # Check that we got all our options
    foreach opt [array names optshash] {
        if {$optshash($opt) == "#_required_#"} {
            #msg_vdebug "Error: ${proc_name}: Missing required option -${opt}"
            error "Missing required option"
        }
    }

    set massaged_device_info [massage_device_name $optshash(part)]
    set family [lindex $massaged_device_info 0]
    set device [lindex $massaged_device_info 1]
    set speed [lindex $massaged_device_info 2]

    # Build the cache for this family
    set myCache [build_cache $family]

    # Get the speed
    set mySpeedList [list]
    set mySpeed       [$myCache getSpeed $speed]
    set myCommonSpeed [$myCache getSpeed COMMON]
    if {$mySpeed != ""} {
        lappend mySpeedList $mySpeed
    }
    if {![string equal -nocase $speed "COMMON"] && $myCommonSpeed != ""} {
        lappend mySpeedList $myCommonSpeed
    }

    # If mySpeedList is empty we couldn't find this speed grade, or
    # a COMMON speed grade in this database
    if {[llength $mySpeedList] == 0} {
        error "No speed grade information found for this family"
    }

    # For each speed in mySpeedList look for device-specific
    # and common sections.
    set myDeviceList [list]
    foreach myspeed $mySpeedList {
        # Get the device-specific section and the common section for this speed
        set myDevice        [$myspeed getDevice $device]
        set myCommonDevice  [$myspeed getDevice COMMON]
        if {$myDevice != ""} {
            lappend myDeviceList $myDevice
        }
        if {![string equal -nocase $device "COMMON"] && $myCommonDevice != ""} {
            lappend myDeviceList $myCommonDevice
        }
        unset myspeed
    }

    # If myDeviceList is empty we couldn't find any device info
    # at this speed grade
    if {[llength $myDeviceList] == 0} {
        error "No device information found for this part"
    }

    foreach mydevice $myDeviceList {
        set myblock [$mydevice getBlock $optshash(blocktype) $optshash(blocksubtype)]
        if {$myblock != ""} {
            break
        }
    }

    # If myblock doesn't exist then we didn't find the block
    # issue an error.
    if {![info exists myblock] || $myblock == ""} {
        error "Block not found"
    }

    # Get the location now
    set mylocation [$myblock getLocation $optshash(x) $optshash(y) $optshash(subloc)]
    if {$mylocation == ""} {
        error "Location not found for block"
    }

    # Get the mode now
    set mymode [$mylocation getMode $optshash(attributes)]
    if {$mymode == ""} {
        error "Mode not found for given attributes"
    }
    
    # Get the microparameter now
    set mydelay [$mymode getMicroparameter $optshash(microparameter)]
    if {$mydelay < 0} {
        #msg_vdebug "Error: ${proc_name}: Could not get a delay for $optshash(blocktype) -> $optshash(microparameter) pair"
        #msg_vdebug "Error: ${proc_name}: Are you sure this is a valid block/microparameter pair?"
        error "No delay found for block/microparameter pair"
    }
    
    # Append units?
    if {$optshash(withunits)} {
        set mydelay "${mydelay} [$myCache cget -delay_units]"
    }

    # Clear cache
    if {$no_cache_data} {
        clear_cached_data $family
    }
        
    # Done. Return the delay.
    return $mydelay
}


#############################################################################
##  Procedure: massage_device_name
##
##  Arguments:
##      part_name
##          A proper, from quartus, type of part name. For example:
##              EP1S25F780C5
##
##  Description:
##      Massages a proper, from quartus, type of part name into just the
##      bare essentials needed to get timing information. This basically
##      amounts to removing the package and pin information. Returns a list
##      that contains: the "timing" device name and the speed grade. Throws
##      an error if it can't break down a device name. Nice, ehh?
proc ::quartus::xmltiming::massage_device_name {part_name} {

    # For debug messages
    set proc_name "massage_device_name()"

    # Trim leading/trailing whitespace on part_name
    regsub -- {^\s+} $part_name {} part_name
    regsub -- {\s+$} $part_name {} part_name

    # This API supports the following families and the devices
    # have the following format:
    #   Armstrong:      AM6 F1508
    #   Cyclone:        EP1C20 F324 C8
    #   Stratix:        EP1S80 B956 C6
    #   Stratix GX:     EP1SGX40 DF1020 C7
    #   Stratix II:     EP2S15 F484 C3
    #   Cyclone II:     EP2C5 Q208 C6
    #   MAX II:         EPM240 T100 C3
    if {[regexp -nocase -- {(AM\d+)} $part_name => device]} {
        set family "Armstrong"
        set speed  "COMMON"
    } elseif {[regexp -nocase -- {(EP1C\d+)\D.*(\S\d+)} $part_name => device speed]} {
        set family "Cyclone"
    } elseif {[regexp -nocase -- {(EP1S\d+)\D.*(\S\d+)} $part_name => device speed]} {
        set family "Stratix"
    } elseif {[regexp -nocase -- {(EP1SGX\d+)\D.*(\S\d+)} $part_name => device speed]} {
        set family "Stratix GX"
    } elseif {[regexp -nocase -- {(EP2S\d+)\D.*(\S\d+)} $part_name => device speed]} {
        set family "Stratix II"
    } elseif {[regexp -nocase -- {(EP2C\d+)\D.*(\S\d+)} $part_name => device speed]} {
        set family "Cyclone II"
    } elseif {[regexp -nocase -- {(EPM\d+)\D.*(\S\d+)} $part_name => device speed]} {
        set family "MAXII"
    } elseif {[regexp -nocase -- {(FOO\d+)} $part_name => device]} {
        set family "Foo"
        set speed "COMMON"
    } else {
        #msg_vdebug "Error: ${proc_name}: Unrecognized part: $part_name"
        error "Unrecognized part"
    }
    ##msg_vdebug  "${proc_name}: $part_name => $family $device $speed"
    return [list $family $device $speed]
}


#############################################################################
##  Procedure: glob_auto_path
##
##  Arguments:
##      fglob
##          The glob pattern to search for on the auto_path
##
##  Description:
##      Searches . and $auto_path in a manner similar to the "package require"
##      command. This lets you keep data files on your auto_path and find
##      and load them just like packages are found. The function first 
##      looks in . for the files because the pwd overrides files found in
##      your path. Then it searches $auto_path. It returns a list of all
##      the files found that match the $fglob argument. $fglob can be any
##      type of glob string you'd pass to Tcl's glob function. It is important
##      to note that this function returns ALL the files it finds. It doesn't
##      stop after the first match. So you get a list of all the fglob
##      matches on every auto_path directory. The list is in the order they
##      were found. So if you want the very first match take lindex 0.
##      You'll get an empty list if nothing is found, so check for it!
proc ::quartus::xmltiming::glob_auto_path {fglob} {

    # For debug messages
    set proc_name "glob_auto_path()"

    set files {}
    ##msg_vdebug "${proc_name}: Using pattern: $fglob"

    # Search . first
    foreach tf [glob -nocomplain -type f -directory [pwd] -- $fglob] {
        ##msg_vdebug "${proc_name}: Found: $tf"
        lappend files $tf
    }
    foreach path $::auto_path {
        # First check this directory
        foreach tf [glob -nocomplain -directory $path -- $fglob] {
            ##msg_vdebug "${proc_name}: Found: $tf"
            lappend files $tf
        }
        # Search each sub-dir
        if {![catch {glob -nocomplain -type d -directory $path -- *} dirs]} {
            foreach dir $dirs {
                foreach tf [glob -nocomplain -type f -directory $dir -- $fglob] {
                    ##msg_vdebug "${proc_name}: Found: $tf"
                    lappend files $tf
                }
            }
        }
    }
    # Return the list of files we found
    return $files
}


#############################################################################
##  Procedure: clear_cached_data
##
##  Arguments:
##      family
##          The name of the family to clear cached data for
##
##  Description:
##      Removes cached data for a particular family. If no family is
##      passed it removes cached data for ALL the families!
proc ::quartus::xmltiming::clear_cached_data {{family "#_all_#"}} {

    # Bring global namespace variables into proc space
    variable cached_families
    variable cache

    # For debug messages
    set proc_name "clear_cached_data()"

    if {![string equal "#_all_#" $family]} {
        lappend family_list $family
    } else {
        set family_list [array names cache]
    }

    foreach family $family_list {
        set _family [string tolower $family]
        ##msg_vdebug "${proc_name}: Clearing cache for ${family} (${_family})"
    
        if {[info exists cached_families($_family)]} {
    
            array unset cached_families $_family
            #delete object $cache($_family)
            array unset cache $_family
    
            # This can go away once we're certain array unset is
            # working properly for us. It just double checks
            # that the cached data was cleard properly.
            if {[info exists cached_families($_family)]} {
                error "Could not clear cache state"
            }
            if {[info exists cache($_family)]} {
                error "Could not clear cached intracell delays"
            }
        }
    }

    ##msg_vdebug "${proc_name}: Cached information for $family successfully cleared"
    return 1
}


#############################################################################
##  Procedure: build_cache
##
##  Arguments:
##      family
##          The name of the family to build cache for.
##
##  Description:
##      Builds up a cache of intracell delay data for a family. First check
##      to see if cache is exists already. If cache exists checks the file
##      mtime of the file used to build existing cache to make sure file
##      hasn't changed. If file has changed or cache doesn't exist it
##      builds the cache from scratch. If everything is successfull this
##      function returns 1 (true). But it throws a Tcl error if anything
##      at all goes wrong so you may want to catch {} it if you don't want
##      your program interrupted.
proc ::quartus::xmltiming::build_cache {family} {
    
    # Bring global namespace variables into proc space
    variable cached_families
    variable cache

    # For debug messages
    set proc_name "build_cache()"

    # True if we need to cache the data
    set we_need_to_cache_data 1

    # If the data isn't already cached we have to cache
    # the data. If it's already cached then we need to
    # make sure the file from which it was cached hasn't
    # been updated. If it's been updated then we need to
    # recache the data.
    if {[info exists cached_families([string tolower $family])]} {
        # Data is cached. Verify cache is up-to-date.
        set fname [lindex $cached_families([string tolower $family]) 0]
        set fmtime [lindex $cached_families([string tolower $family]) 1]
        ##msg_vdebug "${proc_name}: Found existing cache for $family: $fname"

        # If the file exists get is stat data
        if {[file exists $fname]} {
            # Get the current mtime on the data file used for cache
            file stat $fname statdata
        } else {
            # Otherwise fake the statdata we need and unset the fname
            # -- this will force the caching portion of this routine
            # to re-find a suitable ICD file for this family.
            set statdata(mtime) -1
            unset fname
        }

        # Compare mtime times
        if {$statdata(mtime) != $fmtime} {
            #msg_vdebug "${proc_name}: Existing cache is out of date: $statdata(mtime) != $fmtime"
            clear_cached_data $family
            #msg_vdebug"${proc_name}: Cache has been cleared and will be rebuilt"
            set we_need_to_cache_data 1
        } else {
            ##msg_vdebug "${proc_name}: Existing cache is up-to-date: $statdata(mtime) == $fmtime"
            set we_need_to_cache_data 0
        }
    } 

    # Do we need to build a cache for this family?
    if {$we_need_to_cache_data} {
        # Data has not been cached. Cache it.
        # Form the file name we're looking for if fname doesn't exist already.
        if {![info exists fname]} {
            set fname [string tolower $family]
            regsub -all -- {\s+} $fname {} fname
            set fname "${fname}.icd"

            # Find the file now. First item in list is the one
            # we should be using as our data.
            set icd_files [glob_auto_path $fname]
            if {[llength $icd_files] < 1} {
                error "Could not find a suitable ICD data file for your family!"
            }
            set fname [lindex $icd_files 0]
            file stat $fname statdata
            set fmtime $statdata(mtime)
        }
        #msg_vdebug "${proc_name}: Using ICD file ${fname} as source for cache"

        # Open the file. Just let it error if we can't...
        set icdfd [open $fname "r"]

        # Parse the file. Let the parser error if it encounters an error...
        set cache([string tolower $family]) [::quartus::xmltiming::db::icd #auto]
        #msg_vdebug "${proc_name}: Created new ICD DB object: $cache([string tolower $family])"
        #msg_vdebug "${proc_name}: Loading timing data into ICD DB object..."
        $cache([string tolower $family]) loadXML $icdfd
        
        # Close the file.
        close $icdfd

        # Make a note of this cached data in the cached_families array
        set cached_families([string tolower $family])  [list $fname $fmtime]
        #msg_vdebug "${proc_name}: Data for $family has been cached"
    }

    # All the data for $family is cached now.
    ##msg_vdebug "${proc_name}: Done"
    return $cache([string tolower $family])
}


