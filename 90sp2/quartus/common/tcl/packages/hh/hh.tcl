#############################################################################
##  hh.tcl - v1.0
##
##  Provides a Tcl/Tk interface to context-sensitive Quartus help.
##
##
##  __ScriptLicense__
##
##
##  __ContactInformation__
##


package provide ::quartus::hh 1.0


#############################################################################
##  Additional Packages Required
package require cmdline


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::hh {
    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
}


#############################################################################
##  Class:  hh
##
##  Description:
##      This is the interface class you use to gain access to 
##      context-sensitive help from your Tcl/Tk scripts. Create
##      a new hh class instance in your script with:
##
##          set hh [::quartus::hh #auto]
##
##      and call up context-sensitive help pages with:
##
##          $hh getHelp <help page to retrieve>
##
itcl::class ::quartus::hh {

    constructor {{_chm "#_auto_#"} {_hh "#_auto_#"}} {

        set debug_name "::quartus::hh()"
        msg_vdebug "${debug_name}: Constructing ::quartus::hh object $this"

        # Auto-assign the OS and platform
        set os $::tcl_platform(os)
        msg_vdebug "${debug_name}:   Auto-discovered OS: $os"
        set platform $::tcl_platform(platform)
        msg_vdebug "${debug_name}:   Auto-discovered platform: $platform"

        # The prefix is the protol hh uses to open the compiled
        # help module. You can add finer-grained prefix control
        # by looking at $os instead of $platform if you need it.
        switch -- $platform {
            "unix" {
                set prefix "ms-its:"
            }
            "windows" {
                set prefix "mk:@MSITStore:"
            }
            default {
                return -code error "${debug_name}: Unsupported platform: $tcl_platform(platform)"
            }
        }

        # Did the user tell us which compiled help module
        # to use for context-sensitive help?
        if {[string equal $_chm "#_auto_#"]} {
            # Use the default chm module
            set chm [file join $::quartus(binpath) .. common help quartus.chm]
            msg_vdebug "${debug_name}:   Using default chm: $chm"
        } else {
            # Use the user's chm
            set chm $_chm
            msg_vdebug "${debug_name}:   Using user-specified chm: $chm"
        }

        # Make sure the chm exists
        if {![file exists $chm]} {
            return -code error "${debug_name}: Unable to locate compiled help module"
        }

        # Did the user tell us which hh executable to use?
        if {[string equal $_hh "#_auto_#"]} {
            # Try and find an hh executable to use
            set hh [auto_execok "hh"]
            if {$hh == ""} {
                # Try the quartus/bin directory just in case
                if {[llength [glob -path [file join $::quartus(binpath) hh] -type {f x} -nocomplain .*]]} {
                    set hh [lindex [glob -path [file join $::quartus(binpath) hh] -type {f x} -nocomplain .*] 0]
                } else {
                    return -code error "${debug_name}: No suitable hh executable could be found"
                }
            }
            msg_vdebug "${debug_name}:   Found suitable hh: $hh"
        } else {
            # Use the user's hh executable
            set hh $_hh
            msg_vdebug "${debug_name}:   Using user-specified hh: $hh"
        }

        # Init inst to "" so closeHelp works the first
        # time it gets called from getHelp
        set inst ""
    }

    destructor {
        closeHelp
        # If inst is set, should we try and end that process?
        catch {unset chm hh platform os inst prefix}
    }

    private variable chm;       # The compiled help module to use
    private variable hh;        # The hh executable to call
    private variable platform;  # The platform we're on
    private variable os;        # The OS we're using
    private variable inst;      # The open instance of help
    private variable prefix;    # The prefix to use when opening
    
    public method getHelp {args}
    public method closeHelp {args}
}


#############################################################################
##  Method:  hh::getHelp
##
##  Arguments:
##      -thread
##          Optional. Places the hh processes in its own execution
##          thread using Tcl's & operator at the end of the
##          exec command. Without this command the help opens
##          on top of your current app and remains there, blocking
##          access to your app until the user closes the help
##          window. With this option your app is free to 
##
##  Description:
##      Calls up the standard context-sensitive help interface
##      for the appropriate page. If no page is given it
##      brings up the top-level page in the module.
itcl::body ::quartus::hh::getHelp {args} {

    set debug_name "::quartus::hh getHelp()"

    # Command line options to this proc
    set         tlist       "thread"
    lappend     tlist       0
    lappend     tlist       "Place help in its own exec thread"
    lappend proc_opts $tlist
    
    array set options [cmdline::getFunctionOptions args $proc_opts]

    # There should be at least one thing left in args
    # and that's the help page path to open. We ignore
    # more than the first thing left and we error if
    # there isn't at least one thing left.
    if {[llength $args] == 0} {
        set page ""
    } else {
        # Make sure \'s are /'s for all platforms
        regsub -all -- {\\} [lindex $args 0] {/} page
        # And prefix it with ::
        set page "::${page}"
    }

    # Form the complete argument string to pass to hh
    set hharg "${prefix}${chm}${page}"
    msg_vdebug "${debug_name}: Calling hh with: $hharg"

    # Close any already open help window associated with this
    # help object otherwise we end up with more and more
    # help windows open.
    closeHelp

    # Do we run the hh process in its own thread or do
    # we stall this app until the user closes the hh window?
    # Not sure what stalling will do in a Tk app right now.
    # It may or may not freeze up the Tk UI.
    if {$options(thread)} {
        # NOTE: For now we do the same thing always
        set inst [exec $hh $hharg &]
        msg_vdebug "${debug_name}: Created hh instance $inst"
    } else {
        exec $hh $hharg
    }

    return 1
}


#############################################################################
##  Method:  hh::closeHelp
##
##  Arguments:
##      <none>
##
##  Description:
##      Closes help if it's currently open. Returns true always.
itcl::body ::quartus::hh::closeHelp {args} {
    if {$inst != ""} {
        switch -- $platform {
            windows {
                catch {exec [file join $::quartus(binpath) killqw] $inst}
            }
            default {
                catch {exec kill -9 $inst}
            }
        }
        set inst ""
    }
    return 1
}
