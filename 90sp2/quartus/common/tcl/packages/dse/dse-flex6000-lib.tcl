
####################################################################################
## dse-flex6000-lib.tcl - v1.0
##
## A set of library routines used to power the Design Space Explorer script that
## are specific to the Altera Flex 7000 family of devices and its derivatives.
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

package provide ::quartus::dse::flex6000 1.0

#############################################################################
##  Additional Packages Required
package require ::quartus::dse::ccl 1.0
package require ::quartus::misc 1.0
package require cmdline


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse::flex6000 {
    namespace export is_valid_type
    namespace export get_valid_types
    namespace export get_description_for_type
    namespace export set_design_space
    namespace export has_quick_recipe_for
    namespace export get_quick_recipe_for

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!

    # NOTE: If you want this family to support additional exploration
    #       types you need to update this list! "Custom Space" should
    #       ALWAYS be LAST on this list please!
    variable valid_types [list "Synthesis Space" "Custom Space"]
}


#############################################################################
##  Procedure:  is_valid_type
##
##  Arguments:
##      _t
##          The type you want to test for validity.
##
##  Description:
##      Tells you if a type of exploration is supported by this family or not.
##      If this type is supported then the function returns 1, otherwise it
##      returns 0.
proc ::quartus::dse::flex6000::is_valid_type {_t} {

    # Get our global list of valid exploration types
    variable valid_types

    foreach {t} $valid_types {
        if {[string equal $_t $t]} {
            return 1
        }
    }
    return 0
}


#############################################################################
##  Procedure:  get_valid_types
##
##  Arguments:
##      <none>
##
##  Description:
##      Returns a list of valid exploration types for this family.
proc ::quartus::dse::flex6000::get_valid_types {} {

    # Get our global list of valid exploration types
    variable valid_types
    return $valid_types
}


#############################################################################
##  Procedure:  get_description_for_type
##
##  Arguments:
##      _t
##
##  Description:
##      Returns a string that holds a paragraph description of the
##      type $_t. Returns an empty string if $_t is not a valid
##      type.
proc ::quartus::dse::flex6000::get_description_for_type {_t} {

    set debug_name "flex6000::get_description_for_type()"

    set retstr ""

    # You need to keep this up to date!
    switch -exact -- $_t {
        {Synthesis Space} {
            set retstr "Various synthesis optimizations that try different "
            append retstr "encoding techniques and synthesis options."
        }
        {Custom Space} {
            set retstr "Use a custom exploration space defined in a file. "
            append retstr "Use the \"Options -> Custom Space file...\" dialog to choose "
            append retstr "a file to load. Your seeds in the main window will be added to "
            append retstr "any existing seeds in the file."
        }
        default {
            # Huh? How'd we get here?
            ::quartus::dse::ccl::dputs "${debug_name}: Error: No description for \"$_t\" found"
        }
    }

    return $retstr
}


#############################################################################
##  Procedure:  has_quick_recipe_for
##
##  Arguments:
##      _t
##
##  Description:
##      Checks this family library to see if it contains a quick
##      recipie for type _t. You can pass it anything at all for
##      _t but really it should be a string like "power" or
##      "area" or "speed: low".
##
##      The GUI uses this method to contruct the appropriate user
##      interface experience when ever a design is loaded into DSE.
##
##      Returns 1 if a quick recipie exists. 0 otherwise.
proc ::quartus::dse::flex6000::has_quick_recipe_for {_t} {
    set debug_name "flex6000::has_quick_recipe_for()"

    # This library supports the following quick reipes:
    switch -- $_t {
        default {
            ::quartus::dse::ccl::dputs "${debug_name}: There is no quick recipie for $_t in this library"
            set retval 0
        }
    }
    return $retval
}


#############################################################################
##  Procedure:  get_quick_recipe_for
##
##  Arguments:
##      -recipe <name>
##          The name of the recipie you want the secret sauce for
##
##      -qii-synthesis [0|1]
##          Set this to true if the user has indicated their design
##          takes advantage of QII native synthesis. It defaults
##          to 0 (or off).
##
##  Description:
##      If the recipe is supported by this library it returns a list
##      with four elements in it. The first element is the name of
##      the design space to load. The second element is optimization
##      goal method to use. The third element is the optimization
##      function to use. The fourth element is the search method
##      to use.
##
##      If this recipe is not supported it returns an empty list.
proc ::quartus::dse::flex6000::get_quick_recipe_for {args} {
    set debug_name "flex6000::get_quick_recipe_for()"

    set         tlist       "qii-synthesis.arg"
    lappend     tlist       0
    lappend     tlist       "True if the circuit is using QII integrated synthesis"
    lappend function_opts $tlist

    set         tlist       "recipe.arg"
    lappend     tlist       "unknown"
    lappend     tlist       "Name of the secret sauce recipe you seek"
    lappend function_opts $tlist

    array set optshash [cmdline::getFunctionOptions args $function_opts]

    # This library supports the following quick reipes:
    switch -- $optshash(recipe) {
        default {
            ::quartus::dse::ccl::dputs "${debug_name}: There is no quick recipie for $_t in this library"
            set secret_sauce [list]
        }
    }
    return $secret_sauce
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
##          be added at (map,0) for you.
##
##      space_type
##          The name of the space you want created. Should match one
##          of the names you get from calling the get_valid_types()
##          function for this family.
##
##      custom_file
##          The name of a custom space file to load if the space is
##          a custom space. If you're not running a custom_space it
##          doesn't matter what you pass us for this value.
##
##      args
##          Additional key/value pairs you want to add. For every pair
##          you pass you'll get each point in the pre-determined space
##          with the pair. For example, if you pass:
##              {SEED 5}
##          As the $args list then you'll get all the points in the
##          space with SEED=5 as well. If you pass:
##              {SEED 5 SEED 10}
##          You'll get all the points with SEED=5 and then all the
##          points with SEED=10. Get it? All the points will show
##          up in the "fit" space. The "map" space is unavailable
##          to you from this interface because I'm expecting you'll
##          only ever use this to sweep SEED values.
##
##  Description:
##      Sets up all the values for the design space for us.
##
##      Returns true (1) if setup was successfull and your _dse_object
##      that you passed by reference has the space configured properly.
##      Returns false (0) if something went wrong.
proc ::quartus::dse::flex6000::set_design_space { designspace space_type custom_file args } {

    set debug_name "flex6000::set_design_space()"

    # Flatten arguments
    set args [join $args]

    # Make sure they're asking for a valid type
    if {![is_valid_type $space_type]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: Type $space_type is not a valid space type"
        return 0
    }

    # Make sure $designspace is a dse object!
    if {![$designspace isa ::quartus::dse::designspace]} {
        ::quartus::dse::ccl::dputs "${debug_name}: Error: $designspace is not a ::quartus::dse::designspace object!"
        return 0
    }

    # Set the "base" point
    ::quartus::dse::ccl::dputs "${debug_name}: Adding base point at {map 0, fit 0}"
    $designspace addPoint map 0 {}
    $designspace addPoint fit 0 {}

    switch -exact $space_type {
        {Synthesis Space} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Synthesis Space"

# TEMP            # MAP: Balanced optimization
# TEMP            set options ""
# TEMP            lappend options FLEX6K_OPTIMIZATION_TECHNIQUE BALANCED
# TEMP            $designspace addPoint map end $options
# TEMP            unset options

            # MAP: Speed optimization
            set options ""
            lappend options FLEX6K_OPTIMIZATION_TECHNIQUE SPEED
            $designspace addPoint map end $options
            unset options

            # MAP: Area optimization
            set options ""
            lappend options FLEX6K_OPTIMIZATION_TECHNIQUE AREA
            $designspace addPoint map end $options
            unset options

            # FIT: Optimize timing compilation off
            set options ""
            lappend options OPTIMIZE_TIMING OFF
            $designspace addPoint fit end $options
            unset options

            # FIT: Optimize timing compilation normal
            set options ""
            lappend options OPTIMIZE_TIMING "NORMAL COMPILATION"
            $designspace addPoint fit end $options
            unset options

            # FIT: Optimize timing compilation normal
            set options ""
            lappend options OPTIMIZE_TIMING "EXTRA EFFORT"
            $designspace addPoint fit end $options
            unset options

        }
        {Custom Space} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Custom Space"
        }
        default {
            # Huh? How'd we get here?
            ::quartus::dse::ccl::dputs "${debug_name}: Error: switch encountered an unknown type: $space_type"
            return 0
        }
    }

    # Return successfully
    return 1
}

#############################################################################
##  Procedure:  get_multiplier_for_type
##
##  Arguments:
##      _t
##
##  Description:
##		Given a flow type, returns how long the type will take compared to
##      a 'vanilla' compile.  The idea is to check this for the base
##      compilation, and then check this for a particular flow type, and
##      by dividing the results, you can tell how long the flow will take
##      compared to a base compile.
##
proc ::quartus::dse::flex6000::get_multiplier_for_type {_t _flowopts _multopts} {
    set debug_name "flex6000::get_multiplier_for_type()"

    upvar $_flowopts flow_options
    upvar $_multopts multiplier_options

    #  We can account for fitter_effort, router_effort being higher too,
    #  but they're the same in all DSE compilations, so just check it in
    #  the base and increase if needed

    #  First determine how many 'vanilla' compiles the base settings will
    #  require, then calculate the same for the type and the ratio will be
    #  the multiplier
    set base_settings(placement-effort-multiplier) $multiplier_options(base-placement-effort-multiplier)
    set base_settings(fsyn-comb-logic) $multiplier_options(fsyn-comb-logic)
    set base_settings(fsyn-retiming) $multiplier_options(fsyn-retiming)
    set base_settings(fsyn-duplication) $multiplier_options(fsyn-duplication)
    set base_settings(fsyn-effort-level) $multiplier_options(fsyn-effort-level)
    set base_settings(fast-fit-compilation) $multiplier_options(fast-fit-compilation)
    set base_settings(fit-one-attempt) $multiplier_options(fit-one-attempt)
    set base_settings(get-number-of-points-only) $multiplier_options(get-number-of-points-only)
    set base_compilation_multiplier [get_multiplier_for_settings "base_settings"]

	if {[catch {set num_seeds [llength [::quartus::dse::ccl::get_seed_list "$flow_options(gui-seeds)"]]}]} {
		set num_seeds 0
	}

	set worst_multiplier $base_compilation_multiplier
	set num_synthesis_points 0

	#  Determine if we want the have the get-mult function return unity for all of the
	#  points or not
    set temp_settings(get-number-of-points-only) $multiplier_options(get-number-of-points-only)

    switch -exact $_t {
        {Synthesis Space} {
	        #  There's just 3 base-equivalent fit points and a lot of map points
	        set retval [expr 3*$base_compilation_multiplier]

        	set num_synthesis_points 2
        }
        {Custom Space} {
            return -1
        }
        default {
            # Huh? How'd we get here?
            ::quartus::dse::ccl::dputs "${debug_name}: Error: switch encountered an unknown type: $_t"
            return -1
        }
    }

    #  Must run each of the fit points with each synthesis point (+ base)
    set retval [expr $retval*($num_synthesis_points + 1) + ($num_synthesis_points)*$base_compilation_multiplier]

    #  Could add 2 more per point, including 2 more at base, for LLR restructuring
	if {$flow_options(gui-project-try-llr-restructuring)} {
		set retval [expr 3*$retval + 2*$base_compilation_multiplier]
	}

    return [expr round ($retval/$base_compilation_multiplier)]
}

#############################################################################
##  Procedure:  get_multiplier_for_settings
##
##  Arguments:
##      _settings
##
##  Description:
##		Given some settings pertaining to compilation time (i.e. FSYN
##      settings, placer effort, etc.) returns how long this compile would
##      take compared to a compilation with default, or 'vanilla' settings.
##
proc ::quartus::dse::flex6000::get_multiplier_for_settings {_settings} {
	set ret_val 0
    upvar $_settings settings

	#  If we only wanted the number of points, we just return 1 here
    if {$settings(get-number-of-points-only)} {
    	return 1
	}

    #  These are some constants we determine experimentally and use to
    #  determine approximate compilation times
    set fast_fit_compilation_multiplier 0.5
    set fit_one_attempt_multiplier 1.0

    #  Basically, for every multiple increase in effort multiplier, how
    #  much compile time hit do you take?  This value is used to account
    #  for placement effort multipliers that are non-unity as follows:
    #
    #  compile_time = 1 + (multiplier - 1)*inner_num_constant
    set inner_num_constant 0.25

    #  These are the multipliers for the various FSYN modes compared to
    #  FSYN off.  They represent how much EXTRA compile time you add, so
    #  a value of 1.0 means 100% extra time, or double the base.
    set fsyn_normal_multiplier 1.0
    set fsyn_extra_multiplier 2.0
    set fsyn_fast_multiplier 0.5

    #  These are the compile time hits for each of the fsyn algorithms.
    #  Basically we add up these components depending on what's turned
    #  on, and then multiply by the appropriate multiplier to get the
    #  total fsyn factor
    set fsyn_comb_component 0.4
    set fsyn_retiming_component 0.4
    set fsyn_duplication_component 0.2

    #  Add up the fsyn components depending on what was turned on
    set fsyn_component_sum 0
    set fsyn_component_sum [expr $fsyn_component_sum + $fsyn_comb_component*$settings(fsyn-comb-logic)]
    set fsyn_component_sum [expr $fsyn_component_sum + $fsyn_retiming_component*$settings(fsyn-retiming)]
    set fsyn_component_sum [expr $fsyn_component_sum + $fsyn_duplication_component*$settings(fsyn-duplication)]

    switch -- [string tolower $settings(fsyn-effort-level)] {
	    {normal} {
		    set fsyn_multiplier $fsyn_normal_multiplier
	    }
	    {extra} {
		    set fsyn_multiplier $fsyn_extra_multiplier
	    }
	    {fast} {
		    set fsyn_multiplier $fsyn_fast_multiplier
	    }
	    default {
		    set fsyn_multiplier 0
	    }
    }

    #  This is the amount of time added to a base compile due to FSYN being on
    set additional_time_due_to_fsyn [expr $fsyn_multiplier*$fsyn_component_sum]

    #  This is the amount of time added to a base compile due to a non-unity
    #  placement effort multiplier
    set additional_time_due_to_placement_effort [expr ($settings(placement-effort-multiplier)-1)*$inner_num_constant]

    set ret_val [expr 1 + $additional_time_due_to_placement_effort + $additional_time_due_to_fsyn]

    #  Adjust for fast-fit
 	if {$settings(fast-fit-compilation) == 1} {
	 	set ret_val [expr $ret_val * $fast_fit_compilation_multiplier]
 	}

 	#  Adjust for one attempt only
 	if {$settings(fit-one-attempt) == 1} {
	 	set ret_val [expr $ret_val * $fit_one_attempt_multiplier]
 	}

 	return $ret_val
}
