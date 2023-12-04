
#############################################################################
##  psdf.tcl
##
##  This Tcl/Tk library provides a hierarchical object structure that
##  functions as a very lightweigth psdf database. It it meant to be
##  used to read in psdf XML files and query the information contained
##  within the file using a sane API.
##
##  To get started with this API create a ::quartus::psdf object
##  in your script like this:
##
##      set psdfobj [::quartus::psdf #auto]
##
##  and use this object to read PSDF placement information from
##  a psdf file like this:
##
##      $psdfobj loadXML $xmlfh
##
##  The public methods in the psdf class can now be used to
##  operate on the PSDF data stored in the $psdfobj object.
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

package provide ::quartus::psdf 1.0


#############################################################################
##  Additional Packages Required
package require Itcl
package require xml
package require xmlgen
package require cmdline


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::psdf {
    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
}


#############################################################################
##  Procedure:  ::quartus::psdf::node_compare
##
##  Arguments:
##      node1
##          The first node
##
##      node2
##          The second node
##
##  Description:
##      Used to compare two nodes, based on their IDs, for less than,
##      equal too, or greater than status. Don't use this by itself.
##      It's meant to be used to sort the node_list in the psdf
##      object. See the psdf::getAllNodes for an example.
proc ::quartus::psdf::node_compare {n1 n2} {
    # n1 and n2 had better be node objects
    foreach {node} [list $n1 $n2] {
        if {![$node isa ::quartus::psdf::node]} {
            error "Trying to call node_compare on non-node object $node!"
        }
    }
    return [expr {[$n1 cget -id] - [$n2 cget -id]}]
}


#############################################################################
##  Class:  psdf
##
##  Description:
##      Top level class that holds all the information pertaining to
##      the PSDF file. This class can load itself from an XML file
##      if you like. Or be generated on the fly.
itcl::class ::quartus::psdf {

    constructor {} {
        msg_vdebug "Constructing ::quartus::psdf object $this"
        set version ""
        set delay_units ""
        set vendor ""
        set program ""
        set program_version ""
        set architecture ""
        set device ""
        set date ""
        set node_list_is_sorted 0
        set node_list [list]
        set pin_list [list]
        set oterm_list [list]
        set iterm_list [list]
        set _xml_context ""
        set _xml_context_object ""
        set _xml_indent ""
        set _xml_content_buildup ""
    }

    destructor {
        msg_vdebug "Destroying ::quartus::psdf object $this"
        catch {eval delete object $node_list}
        catch {eval delete object $pin_list}
        catch {eval delete object $oterm_list}
        catch {eval delete object $iterm_list}
        catch {unset version delay_units vendor program program_version architecture device _xml_context _xml_context_object _xml_indent _xml_content_buildup}
    }

    public variable version
    public variable delay_units
    public variable vendor
    public variable program
    public variable program_version
    public variable architecture
    public variable device
    public variable date
    private variable node_list_is_sorted
    private variable node_list
    private variable pin_list
    private variable oterm_list
    private variable iterm_list
    private variable llr_list
    private variable _xml_context
    private variable _xml_context_object
    private variable _xml_indent
    private variable _xml_content_buildup

    public method loadXML {{channel stdin} {test 0}}
    public method cadd {{option -value} args}

    # Node-level methods
    public method getAllNodes {args}
    public method getNode {args}

    # Pin-level methods
    public method getAllPins {}
    public method getPin {args}

    # LLR methods
    public method getAllLogicLockRegions {}
    public method getLogicLockRegion {args}

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
##  Method:  psdf::cadd
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
itcl::body ::quartus::psdf::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::psdf::cadd requires a -option and a value"
    }
    set val [lindex $args 0]
    msg_vdebug "psdf::cadd(): $option $val"
    switch -- $option {
        -node {
            if {[$val isa ::quartus::psdf::node]} {
                lappend node_list $val
                set node_list_is_sorted 0
                msg_vdebug "psdf::cadd(): Marking node list as unsorted" 
            } else {
                error "::quartus::psdf::cadd -node passed non-node object"
            }
        }
        -pin {
            if {[$val isa ::quartus::psdf::pin]} {
                lappend pin_list $val
            } else {
                error "::quartus::psdf::cadd -pin passed non-pin object"
            }
        }
        -oterm {
            if {[$val isa ::quartus::psdf::oterm]} {
                lappend oterm_list $val
            } else {
                error "::quartus::psdf::cadd -oterm passed non-oterm object"
            }
        }
        -iterm {
            if {[$val isa ::quartus::psdf::iterm]} {
                lappend iterm_list $val
            } else {
                error "::quartus::psdf::cadd -iterm passed non-iterm object"
            }
        }
        -llr {
            if {[$val isa ::quartus::psdf::llr]} {
                lappend llr_list $val
            } else {
                error "::quartus::psdf::cadd -llr passed non-llr object"
            }
        }
        default { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  psdf::getAllNodes
##
##  Arguments:
##      -sorted
##          Optional. Returns the list of nodes sorted by their
##          node IDs in ascending order. Turns this very quick
##          O(n) function into roughly an O(n log n) function so
##          use this option only if you really need the list
##          returned pre-sorted by ID. We do save the sorted
##          node list but adding new nodes unsorts it and it
##          must be resorted again. So be wary of how you use
##          this option.
##
## Description:
##      Returns a list of node objects, all the nodes that were
##      found in this design. The list is not sorted in any way.
itcl::body ::quartus::psdf::getAllNodes {args} {
    
    # Command line options to this proc
    set         tlist       "sorted"
    lappend     tlist       0
    lappend     tlist       "Sort by ID before returning"
    lappend proc_opts $tlist
    
    array set options [cmdline::getFunctionOptions args $proc_opts]

    # Does the user want us to sort 
    if {$options(sorted) && !$node_list_is_sorted} {
        msg_vdebug "psdf::getAllNodes(): User wants node list sorted"
        if {!$node_list_is_sorted} {
            msg_vdebug "psdf::getAllNodes(): List is not sorted. Sorting..."
            set node_list [lsort -command {::quartus::psdf::node_compare} $node_list]
            set node_list_is_sorted 1
        } else {
            msg_vdebug "psdf::getAllNodes(): Node list is already sorted"
        }
    }
    msg_vdebug "psdf::getAllNodes(): Returning node list to user"
    return $node_list
}


#############################################################################
##  Method:  psdf::getNode
##
##  Arguments:
##      -id <number>
##          Get the node by ID number. Returns a one-element list
##          if node with <number> exists. Otherwise an empty
##          list is returned.
##
##      -name <pattern> [-nocase]
##          Use [string match] style matching with <pattern> to
##          against node names to make a list of nodes. You can
##          pass the optional -nocase argument to do
##          case-insensitive pattern matching.
##
##      -type <pattern> [-nocase]
##          Use [string match] style matching with <pattern> to
##          against node types to make a list of nodes. You can
##          pass the optional -nocase argument to do
##          case-insensitive pattern matching.
##
## Description:
##      Returns a list of node objects that matched your criteria.
##      The list is not sorted in any way. You must supply either
##      -id, -type or -name, but not both.
itcl::body ::quartus::psdf::getNode {args} {

    # Command line options to this proc
    set         tlist       "id.arg"
    lappend     tlist       "#_optional_#"
    lappend     tlist       "Match nodes by ID"
    lappend proc_opts $tlist

    set         tlist       "name.arg"
    lappend     tlist       "#_optional_#"
    lappend     tlist       "Match nodes by pattern in their names"
    lappend proc_opts $tlist

    set         tlist       "type.arg"
    lappend     tlist       "#_optional_#"
    lappend     tlist       "Match nodes by pattern in their types"
    lappend proc_opts $tlist

    set         tlist       "nocase"
    lappend     tlist       0
    lappend     tlist       "Turn on/off case-insensitive matching"
    lappend proc_opts $tlist

    array set options [cmdline::getFunctionOptions args $proc_opts]

    # Only one of -id, -name or -type can be used at any one time
    set count 0
    foreach {t} [list "id" "name" "type"] {
        if {![string equal $options($t) "#_optional_#"]} {
            incr count
        }
    }
    if {$count == 0} {
        error "::quartus::psdf::getNode requires either -id, -name or -type"
    }
    if {$count > 1} {
        error "::quartus::psdf::getNode takes only one of -id, -name or -type"
    }

    # init an empty list of nodes found
    set found_nodes [list]

    # Find nodes based on an ID
    if {![string equal $options(id) "#_optional_#"]} {
        msg_vdebug "psdf::getNode(): Searching for node with ID $options(id)"
        foreach {node} $node_list {
            if {[$node cget -id] == $options(id)} {
                lappend found_nodes $node
                # Stop, we only promise one node with -id
                msg_vdebug "psdf::getNode(): Found node $node with ID [$node cget -id]"
                break
            }
        }
    }

    # Find nodes based on their name
    if {![string equal $options(name) "#_optional_#"]} {
        msg_vdebug "psdf::getNode(): Searching for node with name matching $options(name)"
        foreach {node} $node_list {
            set temp [$node cget -name]
            if {[info exists temp] && ![regexp -- {^\s*$} $temp]} {
                if {$options(nocase) && [string match -nocase $options(name) $temp]} {
                    msg_vdebug "psdf::getNode(): Matched node $node with match command \[string match -nocase $options(name) $temp\]"
                    lappend found_nodes $node
                } elseif {!$options(nocase) && [string match $options(name) $temp]} {
                    msg_vdebug "psdf::getNode(): Matched node $node with match command \[string match $options(name) $temp\]"
                    lappend found_nodes $node
                }
            }
        }
    }

    # Find nodes based on their type
    if {![string equal $options(type) "#_optional_#"]} {
        msg_vdebug "psdf::getNode(): Searching for node with type matching $options(type)"
        foreach {node} $node_list {
            set temp [$node cget -nodetype]
            if {[info exists temp] && ![regexp -- {^\s*$} $temp]} {
                if {$options(nocase) && [string match -nocase $options(type) $temp]} {
                    msg_vdebug "psdf::getNode(): Matched node $node with match command \[string match -nocase $options(type) $temp\]"
                    lappend found_nodes $node
                } elseif {!$options(nocase) && [string match $options(type) $temp]} {
                    msg_vdebug "psdf::getNode(): Matched node $node with match command \[string match $options(type) $temp\]"
                    lappend found_nodes $node
                }
            }
        }
    }

    msg_vdebug "psdf::getNode(): Returning found node: $found_nodes"
    return $found_nodes
}


#############################################################################
##  Method:  psdf::getAllPins
##
##  Arguments:
##
## Description:
##      Returns a list of pin objects.
itcl::body ::quartus::psdf::getAllPins {} {
    msg_vdebug "psdf::getAllPins(): Returning pin list to user"
    return $pin_list
}


#############################################################################
##  Method:  psdf::getPin
##
##  Arguments:
##      -name <pattern> [-nocase]
##          Use [string match] style matching with <pattern> to
##          against node names to make a list of nodes. You can
##          pass the optional -nocase argument to do
##          case-insensitive pattern matching.
##
## Description:
##      Returns a list of pin objects that matched your criteria.
##      The list is not sorted in any way.
itcl::body ::quartus::psdf::getPin {args} {

    # Command line options to this proc
    set         tlist       "name.arg"
    lappend     tlist       "#_optional_#"
    lappend     tlist       "Match pins by pattern in their names"
    lappend proc_opts $tlist
    set         tlist       "nocase"
    lappend     tlist       0
    lappend     tlist       "Turn on/off case-insensitive matching"
    lappend proc_opts $tlist

    array set options [cmdline::getFunctionOptions args $proc_opts]

    # -name is required
    set count 0
    foreach {t} [list "name"] {
        if {![string equal $options($t) "#_optional_#"]} {
            incr count
        }
    }
    if {$count == 0} {
        error "::quartus::psdf::getPin requires a -name option"
    }
    if {$count > 1} {
        error "::quartus::psdf::getPin takes only one -name option"
    }

    # init an empty list of pins found
    set found_pins [list]

    # Find pins based on their name
    if {![string equal $options(name) "#_optional_#"]} {
        foreach {pin} $pin_list {
            set temp [$pin cget -name]
            if {[info exists temp] && ![regexp -- {^\s*$} $temp]} {
                if {$options(nocase) && [string match -nocase $options(name) $temp]} {
                    msg_vdebug "psdf::getPin(): Matched pin $pin with match command \[string match -nocase $options(name) $temp\]"
                    lappend found_pins $pin
                } elseif {!$options(nocase) && [string match $options(name) $temp]} {
                    msg_vdebug "psdf::getPin(): Matched pin $pin with match command \[string match $options(name) $temp\]"
                    lappend found_pins $pin
                }
            }
        }
    }

    msg_vdebug "psdf::getPin(): Returning found pin: $found_pins"
    return $found_pins
}


#############################################################################
##  Method:  psdf::getAllLogicLockRegions
##
##  Arguments:
##
## Description:
##      Returns a list of LogicLock region objects.
itcl::body ::quartus::psdf::getAllLogicLockRegions {} {
    msg_vdebug "psdf::getAllLogicLockRegions(): Returning LogicLock region list to user"
    return $llr_list
}


#############################################################################
##  Method:  psdf::getLogicLockRegion
##
##  Arguments:
##      -name <pattern> [-nocase]
##          Use [string match] style matching with <pattern> to
##          against LogicLock region names to make a list of regions.
##          You can pass the optional -nocase argument to do
##          case-insensitive pattern matching.
##
## Description:
##      Returns a list of LogicLock region objects that matched your
##      criteria. The list is not sorted in any way.
itcl::body ::quartus::psdf::getLogicLockRegion {args} {

    # Command line options to this proc
    set         tlist       "name.arg"
    lappend     tlist       "#_optional_#"
    lappend     tlist       "Match LogicLock regions by pattern in their names"
    lappend proc_opts $tlist
    set         tlist       "nocase"
    lappend     tlist       0
    lappend     tlist       "Turn on/off case-insensitive matching"
    lappend proc_opts $tlist

    array set options [cmdline::getFunctionOptions args $proc_opts]

    # -name is required
    set count 0
    foreach {t} [list "name"] {
        if {![string equal $options($t) "#_optional_#"]} {
            incr count
        }
    }
    if {$count == 0} {
        error "::quartus::psdf::getLogicLockRegion requires a -name option"
    }
    if {$count > 1} {
        error "::quartus::psdf::getLogicLockRegion takes only one -name option"
    }

    # init an empty list of regions found
    set found_llrs [list]

    # Find pins based on their name
    if {![string equal $options(name) "#_optional_#"]} {
        foreach {llr} $llr_list {
            set temp [$llr cget -name]
            if {[info exists temp] && ![regexp -- {^\s*$} $temp]} {
                if {$options(nocase) && [string match -nocase $options(name) $temp]} {
                    msg_vdebug "psdf::getLogicLockRegion(): Matched region $llr with match command \[string match -nocase $options(name) $temp\]"
                    lappend found_llrs $llr
                } elseif {!$options(nocase) && [string match $options(name) $temp]} {
                    msg_vdebug "psdf::getLogicLockRegions(): Matched region $llr with match command \[string match $options(name) $temp\]"
                    lappend found_llrs $llr
                }
            }
        }
    }

    msg_vdebug "psdf::getLogicLockRegions(): Returning found regions: $found_llrs"
    return $found_llrs
}


#############################################################################
##  Method:  psdf::loadXML
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
##      an existing object.
itcl::body ::quartus::psdf::loadXML {{channel stdin} {test 0}} {

    # Reference to commands the parser calls to deal with events
    if {$test} {
        post_message -type warning "No test parsers implemented for this class"
        post_message -type warning "Falling back on standard parsers"
        set cdata       "$this  _xml_characterdata"
        set elemstart   "$this  _xml_elementstart"
        set elemend     "$this  _xml_elementend"
        set err         "$this  _xml_error"
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
    set load_start_time [clock seconds]
    $parser parse [read $channel]
    set load_end_time [clock seconds]
    msg_vdebug "${this} loadXML finished successfully in [expr {$load_end_time - $load_start_time}] seconds"
    return 1
}


#############################################################################
##  Class:  iterm
##
##  Description:
##      An input on a node. Also sometimes referred to as a 'load' or
##      or a 'sink' in a netlist. An input belongs to a node. It has
##      no children of its own.
itcl::class ::quartus::psdf::iterm {

    constructor { _noderef } {
        set id ""
        set pin ""
        set delay ""
        set noderef $_noderef
        if {[$_noderef isa ::quartus::psdf::node]} {
            $_noderef cadd -iterm $this
        }
    }

    destructor {
        catch {unset id pin delay noderef}
    }

    public variable id     ; # The node ID this iterm belongs to
    public variable pin    ; # The friendly name of this iterm
    public variable delay  ; # The delay from this sink to its source
    private variable noderef; # Reference to node that contains this iterm
}


#############################################################################
##  Class:  oterm
##
##  Description:
##      An output on a node. Also sometimes referred to as a 'driver' or
##      or a 'source' in a netlist. An input belongs to a node. It has
##      no children of its own.
itcl::class ::quartus::psdf::oterm {

    constructor { _noderef } {
        set id ""
        set pin ""
        set location ""
        set ipvector ""
        set noderef $_noderef
        array set information [list]
        set bb ""
        set iterm_list [list]
        if {[$_noderef isa ::quartus::psdf::node]} {
            $_noderef cadd -oterm $this
        }
    }

    destructor {
        # Note: do not delete the iterm objects in the
        #       lists for this oterm. The top-level psdf object
        #       will take care of deleting these objects.
        catch {unset id pin location ipvector noderef iterm_list}
        catch {array unset information}
    }

    public variable id         ; # The node ID this iterm belongs to
    public variable pin        ; # The friendly name of this iterm
    public variable location   ; # The device location of this driver
    public variable ipvector   ; # The rotated input vector for this oterm
    public variable bb         ; # Black box this oterm belongs to
    private variable noderef    ; # Reference to node that contains this iterm
    private variable information; # Hash of information for this oterm
    private variable iterm_list ; # List of iterms fed by this oterm
    
    public method cadd {{option -value} args}
    public method addInformation {key val}
    public method deleteInformation {key}
    public method getInformation {key}
    public method informationExists {key}
    public method getAllInformation {}
}


#############################################################################
##  Method:  oterm::cadd
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
itcl::body ::quartus::psdf::oterm::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::psdf::oterm::cadd requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -iterm {
            if {[$val isa ::quartus::psdf::iterm]} {
                lappend iterm_list $val
            } else {
                error "::quartus::psdf::oterm::cadd -iterm passed non-iterm object"
            }
        }
        -information {
            if {[llength $args] < 2} {
                error "::quartus::psdf::oterm::cadd -information require two additional arguments: <key> <val>"
            }
            set key $val
            set val [lindex $args 1]
            set information($key) $val
        }
        default { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  oterm::addInformation
##
##  Arguments:
##      key
##          Key to add information at
##
##      val
##          Value to store at that key
##
## Description:
##      Adds the information for $key at $value for this oterm.
##      Will not clobber existing information. Returns true if
##      information was added, false if the information already
##      exists (use deleteInformation to remove it first).
itcl::body ::quartus::psdf::oterm::addInformation {key val} {
    set retval 0
    if {![$this informationExists $key]} {
        set retval [$this cadd -information $key $val]
    }
    return $retval
}


#############################################################################
##  Method:  oterm::deleteInformation
##
##  Arguments:
##      key
##          Key to add information at
##
## Description:
##      Deletes the information stored at key. Returns true if
##      the information no longer exists (or never did to begin
##      with). Returns false if the information could not be
##      deleted and still exists in the information hash.
itcl::body ::quartus::psdf::oterm::deleteInformation {key} {
    if {[$this informationExists $key]} {
        catch {array unset information $key}
    }
    return [eval ![$this informationExists $key]]
}


#############################################################################
##  Method:  oterm::getInformation
##
##  Arguments:
##      key
##          Key to add information at
##
## Description:
##      Returns the scalar information stored at $key. Returns
##      an empty string if there is no information for $key.
##      Use informationExists if you want to test for existence.
itcl::body ::quartus::psdf::oterm::getInformation {key} {
    set retval ""
    if {[info exists information($key)]} {
        set retval $information($key)
    }
    return $retval
}


#############################################################################
##  Method:  oterm::informationExists
##
##  Arguments:
##      key
##          Key to test for existence
##
## Description:
##      Returns true if there exists information for the key.
##      Otherwise returns false. Remember: keys are case sensitive.
itcl::body ::quartus::psdf::oterm::informationExists {key} {
    return [info exists information($key)]
}


#############################################################################
##  Method:  oterm::getAllInformation
##
##  Arguments:
##
## Description:
##      Returns the information hash  flattend. Suitable for
##      expansion back into a hash with the [array set] command.
itcl::body ::quartus::psdf::oterm::getAllInformation {} {
    return [array get information]
}


#############################################################################
##  Class:  pin
##
##  Description:
##      A physical pin instance on a device. A pin belongs to a
##      design at the top level but is connected to drivers in 
##      the net that feed the pin signals (output pin) or recieve
##      signals from the pin (input pin), or both (bidir pin).
itcl::class ::quartus::psdf::pin {

    constructor {} {
        set name ""
        set pin ""
        set location ""
    }

    destructor {
        catch {unset name pin location}
    }

    public variable name       ; # The name of this pin in the user's design
    public variable pin        ; # The pin ID on the device
    public variable location   ; # The device location of this driver
}


#############################################################################
##  Class:  node
##
##  Description:
##      A node in the user's design. A node as oterms and iterms
##      that connect up to make the netlist.
itcl::class ::quartus::psdf::node {

    constructor {} {
        set id ""
        set name ""
        set nodetype ""
        set oterm_list [list]
        set iterm_list [list]
        array set oname_hash [list]
    }

    destructor {
        # Note: do not delete the oterm/iterm objects in the
        #       lists for this node. The top-level psdf object
        #       will take care of deleting these objects.
        catch {unset id name nodetype oterm_list iterm_list}
        catch {array unset oname_hash}
    }

    public variable id         ; # ID of the node
    public variable name       ; # The name of this pin in the user's design
    public variable nodetype   ; # The "type" of node
    private variable oterm_list ; # list of oterms attached to this node
    private variable iterm_list ; # list of iterms attached to this node
    private variable oname_hash ; # a hash of output names attached to this node
    
    public method cadd {{option -value} args}
    public method getIterms {}
    public method getOterms {}
    public method getOnames {}
    public method getOnamePinName {oname}
}


#############################################################################
##  Method:  node::cadd
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
itcl::body ::quartus::psdf::node::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::psdf::node::cadd requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -oterm {
            if {[$val isa ::quartus::psdf::oterm]} {
                lappend oterm_list $val
            } else {
                error "::quartus::psdf::node::cadd -oterm passed non-oterm object"
            }
        }
        -iterm {
            if {[$val isa ::quartus::psdf::iterm]} {
                lappend iterm_list $val
            } else {
                error "::quartus::psdf::node::cadd -iterm passed non-iterm object"
            }
        }
        -oname {
            if {[llength $args] < 2} {
                set oname_hash($val) ""
            } else {
                set oname_hash($val) [lindex $args 1]
            }
        }
        default { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  node::getIterms
##
##  Arguments:
##
## Description:
##      Returns a list of iterms associated with this node.
itcl::body ::quartus::psdf::node::getIterms {} {
    return $iterm_list
}


#############################################################################
##  Method:  node::getOterms
##
##  Arguments:
##
## Description:
##      Returns a list of oterms associated with this node.
itcl::body ::quartus::psdf::node::getOterms {} {
    return $oterm_list
}


#############################################################################
##  Method:  node::getOnames
##
##  Arguments:
##
## Description:
##      Returns a list of onames associated with this node.
itcl::body ::quartus::psdf::node::getOnames {} {
    return [array names oname_hash]
}


#############################################################################
##  Method:  node::getOnamePinName
##
##  Arguments:
##
## Description:
##      The string name of the pin on the node associated with
##      this output name. An empty string if oname does not
##      exist on this node (or if no port information is stored
##      for this oname).
itcl::body ::quartus::psdf::node::getOnamePinName {oname} {
    set retval ""

    if {[info exists oname_hash($oname)]} {
        set retval $oname_hash($oname)
    }

    return $retval
}


#############################################################################
##  Class:  llr
##
##  Description:
##      A LogicLock region. Has nodes associated with it as well as
##      some key/value pair information.
itcl::class ::quartus::psdf::llr {

    constructor { _parent } {
        set id -1
        array set information [list]
        if {[$_parent isa ::quartus::psdf]} {
            set parent $_parent
        }
    }

    destructor {
        catch {unset id}
        catch {array unset information}
    }

    public variable id; # The llr ID for this region
    private variable parent; # The ::quartus::psdf parent of this llr region
    private variable information; # Hash of information for this oterm
    
    public method cadd {{option -value} args}
    public method addInformation {key val}
    public method deleteInformation {key}
    public method getInformation {key}
    public method informationExists {key}
    public method getAllInformation {}
    public method getMembers {}
}


#############################################################################
##  Method:  llr::cadd
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
itcl::body ::quartus::psdf::llr::cadd {{option -value} args} {
    if {[llength $args] < 1} {
        error "::quartus::psdf::llr::cadd requires a -option and a value"
    }
    set val [lindex $args 0]
    switch -- $option {
        -information {
            if {[llength $args] < 2} {
                error "::quartus::psdf::llr::cadd -information require two additional arguments: <key> <val>"
            }
            set key $val
            set val [lindex $args 1]
            set information($key) $val
        }
        default { error "unknown setting $option" }
    }
    return 1
}


#############################################################################
##  Method:  llr::addInformation
##
##  Arguments:
##      key
##          Key to add information at
##
##      val
##          Value to store at that key
##
## Description:
##      Adds the information for $key at $value for this llr.
##      Will not clobber existing information. Returns true if
##      information was added, false if the information already
##      exists (use deleteInformation to remove it first).
itcl::body ::quartus::psdf::llr::addInformation {key val} {
    set retval 0
    if {![$this informationExists $key]} {
        set retval [$this cadd -information $key $val]
    }
    return $retval
}


#############################################################################
##  Method:  llr::deleteInformation
##
##  Arguments:
##      key
##          Key to add information at
##
## Description:
##      Deletes the information stored at key. Returns true if
##      the information no longer exists (or never did to begin
##      with). Returns false if the information could not be
##      deleted and still exists in the information hash.
itcl::body ::quartus::psdf::llr::deleteInformation {key} {
    if {[$this informationExists $key]} {
        catch {array unset information $key}
    }
    return [eval ![$this informationExists $key]]
}


#############################################################################
##  Method:  llr::getInformation
##
##  Arguments:
##      key
##          Key to add information at
##
## Description:
##      Returns the scalar information stored at $key. Returns
##      an empty string if there is no information for $key.
##      Use informationExists if you want to test for existence.
itcl::body ::quartus::psdf::llr::getInformation {key} {
    set retval ""
    if {[info exists information($key)]} {
        set retval $information($key)
    }
    return $retval
}


#############################################################################
##  Method:  llr::informationExists
##
##  Arguments:
##      key
##          Key to test for existence
##
## Description:
##      Returns true if there exists information for the key.
##      Otherwise returns false. Remember: keys are case sensitive.
itcl::body ::quartus::psdf::llr::informationExists {key} {
    return [info exists information($key)]
}


#############################################################################
##  Method:  llr::getAllInformation
##
##  Arguments:
##
## Description:
##      Returns the information hash flattend. Suitable for
##      expansion back into a hash with the [array set] command.
itcl::body ::quartus::psdf::llr::getAllInformation {} {
    return [array get information]
}


#############################################################################
##  Method:  llr::getMembers
##
##  Arguments:
##
## Description:
##      Returns a list of oterm objects that belong to this
##      LogicLock region. Returns an empty list if no
##      members can be found.
itcl::body ::quartus::psdf::llr::getMembers {} {

    set member_list [list]

    msg_vdebug "psdf::llr::getMembers(): Searching for oterms belonging to LogicLock region ID $id"
    foreach node [$parent getAllNodes -sorted] {
        foreach oterm [$node getOterms] {
            if {[$oterm informationExists "llr"]} {
                set _rid [$oterm getInformation "llr"]
                if {$_rid == $id} {
                    msg_vdebug "psdf::llr::getMembers(): Found member oterm $oterm"
                    lappend member_list $oterm
                }
            }
        }
    }

    msg_vdebug "psdf::llr::getMembers(): Returning found members: $member_list"
    return $member_list
}


#############################################################################
##  Method:  psdf::_xml_characterdata
##
##  Arguments:
##      data
##
##  Description:
##      Handler function used by the loadXML routine to deal with
##      character data as it's encountered in the XML file stream.
##      Register this handler with the XML parser.
itcl::body ::quartus::psdf::_xml_characterdata {data} {
    
    # Get the current context and context_object
    set context [lindex $_xml_context end]
    set context_object [lindex $_xml_context_object end]

    switch -- $context {
        COPYRIGHT -
        VENDOR -
        PROGRAM -
        DATE -
        ARCHITECTURE -
        DEVICE -
        DELAY_UNITS -
        INFO -
        BB {
            append _xml_content_buildup $data
        }
        default {
            append _xml_content_buildup $data
        }
    }
}


#############################################################################
## Method:  psdf::_xml_elementstart
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
itcl::body ::quartus::psdf::_xml_elementstart {name attlist args} {
    ##msg_vdebug "$this _xml_element_start $name $attlist $args"
    # Unset the build-up variable
    if {[info exists _xml_content_buildup]} {
        set _xml_content_buildup ""
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
        PSDF {
            set version $atthash(version)
            lappend _xml_context_object $this
        }
        COPYRIGHT {
            if {!$argshash(-empty)} {
                lappend _xml_context_object $context_object
            }
        }
        VENDOR {
            if {!$argshash(-empty)} {
                lappend _xml_context_object $context_object
            }
        }
        PROGRAM {
            set program_version $atthash(version)
            if {!$argshash(-empty)} {
                lappend _xml_context_object $context_object
            }
        }
        DATE {
            if {!$argshash(-empty)} {
                lappend _xml_context_object $context_object
            }
        }
        ARCHITECTURE {
            if {!$argshash(-empty)} {
                lappend _xml_context_object $context_object
            }
        }
        DEVICE {
            if {!$argshash(-empty)} {
                lappend _xml_context_object $context_object
            }
        }
        DELAY_UNITS {
            if {!$argshash(-empty)} {
                lappend _xml_context_object $context_object
            }
        }
        N {
            set _node [uplevel #0 ::quartus::psdf::node #auto]
            $_node configure -id $atthash(id)
            $_node configure -name $atthash(name)
            $_node configure -nodetype $atthash(type)
            $this cadd -node $_node
            if {!$argshash(-empty)} {
                lappend _xml_context_object $_node
            }
        }
        O {
            # Try and find the node that contains this output name
            if {$context_object != "" && [$context_object isa ::quartus::psdf::node]} {
                if {[info exists atthash(pin)]} {
                    $context_object cadd -oname $atthash(name) $atthash(pin)
                } else {
                    $context_object cadd -oname $atthash(name)
                }
            }
            if {!$argshash(-empty)} {
                lappend _xml_context_object $context_object
            }
        }
        P {
            set _pin [uplevel #0 ::quartus::psdf::pin #auto ]
            $_pin configure -name $atthash(name)
            $_pin configure -pin $atthash(pin)
            $_pin configure -location $atthash(location)
            $this cadd -pin $_pin
            if {!$argshash(-empty)} {
                lappend _xml_context_object $_pin
            }
        }
        D {
            # Try and find the node to which this oterm belongs
            set noderef [lindex [$this getNode -id $atthash(id)] 0]
            set _oterm [uplevel #0 ::quartus::psdf::oterm #auto $noderef]
            $_oterm configure -id $atthash(id) 
            $_oterm configure -pin $atthash(pin) 
            $_oterm configure -location $atthash(location)
            $_oterm configure -ipvector $atthash(ipvector) 
            $this cadd -oterm $_oterm
            if {!$argshash(-empty)} {
                lappend _xml_context_object $_oterm
            }
        }
        LOGICLOCK_REGION {
            # Create a new llr region object
            set _llr [uplevel #0 ::quartus::psdf::llr #auto $this]
            $_llr configure -id $atthash(id)
            $this cadd -llr $_llr
            if {!$argshash(-empty)} {
                lappend _xml_context_object $_llr
            }
        }
        INFO {
            if {!$argshash(-empty)} {
                lappend _xml_context_object $atthash(name)
            } else {
                # Hmm...an empty <INFO> tag? This could be bad...
                set _xml_content_buildup ""
            }
        }
        BB {
            if {!$argshash(-empty)} {
                lappend _xml_context_object $context_object
            }
        }
        L {
            # Try and find the node to which this iterm belongs
            set noderef [lindex [$this getNode -id $atthash(id)] 0]
            set _iterm [uplevel #0 ::quartus::psdf::iterm #auto $noderef]
            $_iterm configure -id $atthash(id) 
            $_iterm configure -pin $atthash(pin) 
            $_iterm configure -delay $atthash(delay) 
            $this cadd -iterm $_iterm
            # Try and find the driver that connects to this load
            if {$context_object != "" && [$context_object isa ::quartus::psdf::oterm]} {
                $context_object cadd -iterm $_iterm
            }
            if {!$argshash(-empty)} {
                lappend _xml_context_object $_iterm
            }
        }
        default {
            # If this isn't an empty tag push a dummy obj on to context
            if {!$argshash(-empty)} {
                lappend _xml_context_object ""
            }
        }
    }
}


#############################################################################
## Method:  psdf::_xml_elementend
##
## Arguments:
##      name
##      args
##
## Description:
##      Handler function used by the loadXML routine to deal with
##      an ending element tag. Register this handler with the XML
##      parser.
itcl::body ::quartus::psdf::_xml_elementend {name args} {
    
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
        PSDF {
            # Do nothing
        }
        COPYRIGHT {
            # Do nothing
        }
        VENDOR {
            if {[info exists _xml_content_buildup]} {
                $this configure -vendor $_xml_content_buildup
            }
        }
        PROGRAM {
            if {[info exists _xml_content_buildup]} {
                $this configure -program $_xml_content_buildup
            }
        }
        DATE {
            if {[info exists _xml_content_buildup]} {
                $this configure -date $_xml_content_buildup
            }
        }
        ARCHITECTURE {
            if {[info exists _xml_content_buildup]} {
                $this configure -architecture $_xml_content_buildup
            }
        }
        DEVICE {
            if {[info exists _xml_content_buildup]} {
                $this configure -architecture $_xml_content_buildup
            }
        }
        DELAY_UNITS {
            if {[info exists _xml_content_buildup]} {
                $this configure -architecture $_xml_content_buildup
            }
        }
        N {
            # Do nothing
        }
        O {
            # Do nothing
        }
        P {
            # Do nothing
        }
        D {
            # Do nothing
        }
        LOGICLOCK_REGION {
            # Do nothing
        }
        INFO {
            if {$parent_context_object != "" && ([$parent_context_object isa ::quartus::psdf::oterm] || [$parent_context_object isa ::quartus::psdf::llr])} {
                $parent_context_object addInformation $current_context_object $_xml_content_buildup
            } else {
                post_message -type error "Error parsing XML!"
                post_message -type error "We found a closing INFO tag and expected its parent to be"
                post_message -type error "a D (oterm) object. But that was not the case!"
                post_message -type error "The parent was of the following class:"
                post_message -type error "[$parent_context_object info class]"
                error "XML file was malformed!"
            }
        } 
        BB {
            if {$parent_context_object != "" && [$parent_context_object isa ::quartus::psdf::oterm]} {
                $parent_context_object configure -bb $_xml_content_buildup
            } else {
                post_message -type error "Error parsing XML!"
                post_message -type error "We found a closing BB tag and expected its parent to be"
                post_message -type error "a D (oterm) object. But that was not the case!"
                post_message -type error "The parent was of the following class:"
                post_message -type error "[$parent_context_object info class]"
                error "XML file was malformed!"
            }
        }
        L {
            # Do nothing
        }
        default {
            # Do nothing
        }
    }
    # Unset the build-up variable
    catch {set _xml_content_buildup ""}
}


#############################################################################
## Method:  psdf::_xml_error
##
## Arguments:
##      errorcode
##      errormsg
##
## Description:
##      Handler function used by the loadXML routine to deal with
##      an errors in the stream. Register this handler with the XML
##      parser.
itcl::body ::quartus::psdf::_xml_error {errorcode errormsg} {
    error $errormsg $errorcode
}
