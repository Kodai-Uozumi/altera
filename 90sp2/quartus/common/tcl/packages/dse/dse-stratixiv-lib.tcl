
####################################################################################
## dse-stratixiv-lib.tcl - v1.0
##
## A set of library routines used to power the Design Space Explorer script that
## are specific to the Altera Stratix IV family of devices and its derivatives.
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

package provide ::quartus::dse::stratixiv 1.0

#############################################################################
##  Additional Packages Required
package require ::quartus::dse::ccl 1.0
package require ::quartus::misc 1.0
package require cmdline


#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::dse::stratixiv {
    namespace export is_valid_type
    namespace export get_valid_types
    namespace export get_description_for_type
    namespace export set_design_space
    namespace export has_quick_recipe_for
    namespace export get_quick_recipe_for
    namespace export get_multiplier_for_type

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!

    # NOTE: If you want this family to support additional exploration
    #       types you need to update this list! "Custom Space" should
    #       ALWAYS be LAST on this list please!
#    variable valid_types [list "Seed Sweep" "Extra Effort Space" "Physical Synthesis Space" "Physical Synthesis with Retiming Space" "Extra Effort Space for Quartus II Integrated Synthesis Projects" "Physical Synthesis Space for Quartus II Integrated Synthesis Projects" "Physical Synthesis with Retiming Space for Quartus II Integrated Synthesis Projects" "Area Optimization Space" "Power Optimization Space" "Signature: Placement Effort Multiplier" "Signature: Netlist Optimizations" "Signature: Fast Fit" "Signature: Register Packing" "Custom Space"]
    variable valid_types [list "Seed Sweep" "Extra Effort Space" "Physical Synthesis Space" "Physical Synthesis with Retiming Space" "Extra Effort Space for Quartus II Integrated Synthesis Projects" "Physical Synthesis Space for Quartus II Integrated Synthesis Projects" "Physical Synthesis with Retiming Space for Quartus II Integrated Synthesis Projects" "Selective Performance Optimization Space" "Selective Performance Optimization Space for Quartus II Integrated Synthesis Projects" "Area Optimization Space" "Power Optimization Space" "Signature: Placement Effort Multiplier" "Signature: Netlist Optimizations" "Signature: Fast Fit" "Custom Space"]

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
proc ::quartus::dse::stratixiv::is_valid_type {_t} {

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
proc ::quartus::dse::stratixiv::get_valid_types {} {

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
proc ::quartus::dse::stratixiv::get_description_for_type {_t} {

    set debug_name "stratixiv::get_description_for_type()"

    set retstr ""

    # You need to keep this up to date!
    switch -exact -- $_t {
        {Seed Sweep} {
            append retstr "A simple seed sweep."
        }
        {Extra Effort Space} {
            append retstr "A seed sweep plus an increase in the fitting effort level with "
            append retstr "and without register packing."
        }
        {Physical Synthesis Space} {
            append retstr "A seed sweep combined with various netlist optimization "
            append retstr "algorithms that do not move registers in your design "
            append retstr "and an increase in the fitting effort level with and "
            append retstr "without register packing."
        }
        {Physical Synthesis with Retiming Space} {
            append retstr "A seed sweep combined with various netlist optimization "
            append retstr "algorithms that may move registers in your design "
            append retstr "and an increase in the fitting effort level with and "
            append retstr "without register packing."
        }
        {Extra Effort Space for Quartus II Integrated Synthesis Projects} {
            append retstr "A seed sweep plus an increase in the fitting "
            append retstr "effort level with and without register packing "
            append retstr "and various Quartus II Integrated Synthesis optimizations."
        }
        {Physical Synthesis Space for Quartus II Integrated Synthesis Projects} {
            append retstr "A seed sweep combined with various netlist "
            append retstr "optimization algorithms that do not move registers in your "
            append retstr "design and an increase in the fitting effort level with and "
            append retstr "without register packing "
            append retstr "and various Quartus II Integrated Synthesis optimizations."
        }
        {Physical Synthesis with Retiming Space for Quartus II Integrated Synthesis Projects} {
            append retstr "A seed sweep combined with various netlist "
            append retstr "optimization algorithms that may move registers in your "
            append retstr "design and an increase in the fitting effort level with and "
            append retstr "without register packing "
            append retstr "and various Quartus II Integrated Synthesis optimizations."
        }
        {Area Optimization Space} {
            set retstr "A seed sweep combined with various synthesis settings "
            append retstr "and fitter register packing designed to minimize area. This "
            append retstr "exploration space should be run with an optimization goal that "
            append retstr "determines the best results based on area."
        }
        {Power Optimization Space} {
            set retstr "A seed sweep combined with various synthesis settings "
            append retstr "and fitter settings designed to minimize power consumption "
            append retstr "in your design. This exploration space should be run with "
            append retstr "an optimization goal that determines the best results based "
            append retstr "on power use in a design."
        }
        {Selective Performance Optimization Space} {
            set retstr "A seed sweep combined with various fitter settings "
            append retstr "designed to improve timing in your design. The number of "
            append retstr "points in the space is limited and tries not to replicate base "
            append retstr "settings. This exploration space is ideal for large designs "
            append retstr "where other exploration spaces are too large to use. "
        }
        {Selective Performance Optimization Space for Quartus II Integrated Synthesis Projects} {
            set retstr "A seed sweep combined with various synthesis and fitter settings "
            append retstr "designed to improve timing in your design. The number of "
            append retstr "points in the space is limited and tries not to replicate base "
            append retstr "settings. This exploration space is ideal for large designs "
            append retstr "where other exploration spaces are too large to use. "
        }
        {Signature: Placement Effort Multiplier} {
			set retstr "An exploration of Fitter placement effort. Each of the following levels "
			append retstr "are explored for each seed you provide: 1.0, 3.0, 5.0, "
			append retstr  "and 10.0. Higher Placement Effort Multiplier values increase "
			append retstr  "compilation time, but may improve placement quality. This "
			append retstr  "exploration space should be run with an Exhaustive search method."
        }
        {Signature: Netlist Optimizations} {
            set retstr "An exploration of the available netlist optimization algorithms. "
            append retstr "Each of the following groups of netlist algorithms are applied "
            append retstr "for each seed you provide: Off, On and On with Register Moves. "
            append retstr "This exploration type should be run with an Exhaustive "
            append retstr "search method."
        }
        {Signature: Fast Fit} {
            set retstr "An exploration of the available fast fit options. "
            append retstr "Each of the following fast fit options are applied "
            append retstr "for each seed you provide: Off and On. "
            append retstr "This exploration type should be run with an Exhaustive "
            append retstr "search method."
        }
        {Signature: Register Packing} {
            set retstr "An exploration of the available register packing options. "
            append retstr "Each of the following register packing options are applied "
            append retstr "for each seed you provide: Off, Normal, Minimize Area, and Minimize Area with Chains. "
            append retstr "This exploration type should be run with an Exhaustive "
            append retstr "search method."
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
proc ::quartus::dse::stratixiv::has_quick_recipe_for {_t} {
    set debug_name "stratixiv::has_quick_recipe_for()"

    # This library supports the following quick reipes:
    switch -- $_t {
        "area" -
        "speed:low" -
        "speed:medium" -
        "speed:high" -
        "speed:highest" -
        "speed:selective" -
        "power" {
            set retval 1
        }
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
proc ::quartus::dse::stratixiv::get_quick_recipe_for {args} {
    set debug_name "stratixiv::get_quick_recipe_for()"

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
        "area" {
            set s {Area Optimization Space}
            set a {Optimize for Area}
            set g {::quartus::dse::flows::simple_area_best_worst_analysis}
            set m {::quartus::dse::flows::accelerated_flow}
            set secret_sauce [list $s $a $g $m]
        }
        "speed:low" {
            set s {Seed Sweep}
            set a {Optimize for Speed}
            set g {::quartus::dse::flows::simple_slack_best_worst_analysis}
            set m {::quartus::dse::flows::exhaustive_flow}
            set secret_sauce [list $s $a $g $m]
        }
        "speed:medium" {
            if {$optshash(qii-synthesis)} {
                set s {Extra Effort Space for Quartus II Integrated Synthesis Projects}
            } else {
                set s {Extra Effort Space}
            }
            set a {Optimize for Speed}
            set g {::quartus::dse::flows::simple_slack_best_worst_analysis}
            set m {::quartus::dse::flows::accelerated_flow}
            set secret_sauce [list $s $a $g $m]
        }
        "speed:high" {
            if {$optshash(qii-synthesis)} {
                set s {Physical Synthesis Space for Quartus II Integrated Synthesis Projects}
            } else {
                set s {Physical Synthesis Space}
            }
            set a {Optimize for Speed}
            set g {::quartus::dse::flows::simple_slack_best_worst_analysis}
            set m {::quartus::dse::flows::accelerated_flow}
            set secret_sauce [list $s $a $g $m]
        }
        "speed:highest" {
            if {$optshash(qii-synthesis)} {
                set s {Physical Synthesis with Retiming Space for Quartus II Integrated Synthesis Projects}
            } else {
                set s {Physical Synthesis with Retiming Space}
            }
            set a {Optimize for Speed}
            set g {::quartus::dse::flows::simple_slack_best_worst_analysis}
            set m {::quartus::dse::flows::accelerated_flow}
            set secret_sauce [list $s $a $g $m]
        }
        "speed:selective" {
            if {$optshash(qii-synthesis)} {
                set s {Selective Performance Optimization Space for Quartus II Integrated Synthesis Projects}
            } else {
                set s {Selective Performance Optimization Space}
            }
            set a {Optimize for Speed}
            set g {::quartus::dse::flows::simple_slack_best_worst_analysis}
            set m {::quartus::dse::flows::accelerated_flow}
            set secret_sauce [list $s $a $g $m]
        }
        "power" {
            set s {Power Optimization Space}
            set a {Optimize for Power}
            set g {::quartus::dse::flows::simple_power_best_worst_analysis}
            set m {::quartus::dse::flows::accelerated_flow}
            set secret_sauce [list $s $a $g $m]
        }
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
proc ::quartus::dse::stratixiv::set_design_space { designspace space_type custom_file args } {

    set debug_name "stratixiv::set_design_space()"

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
        {Seed Sweep} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Seed Sweep"

        }
        {Extra Effort Space} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Extra Effort Space"

            # FIT: increase in fitter effort level
            set options ""
            lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
            lappend options FITTER_EFFORT "STANDARD FIT"
            lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
            lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
            $designspace addPoint fit end $options
            unset options

        }
        {Physical Synthesis Space} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Physical Synthesis Space"

            foreach {pmr} [list "OFF" "ON"] {
                # MAP: Advanced netlist optimizations
                set options ""
                lappend options ADV_NETLIST_OPT_SYNTH_WYSIWYG_REMAP ON
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options
            }

            # FIT: Try the standard best effort settings first
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
            lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
            lappend options FITTER_EFFORT "AUTO FIT"
            lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
            lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION ON
            lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION ON
            $designspace addPoint fit end $options
            unset options

			foreach {bskew} [list "OFF" "ON"] {
				# FIT: increase in fitter effort level + physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
				lappend options PHYSICAL_SYNTHESIS_EFFORT EXTRA
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options

				# FIT: increase in fitter effort level + physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options

				# FIT: increase in fitter effort level + no physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options
			}
			
			# FIT: Try a flat fit
			set options ""
			lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
			lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
			lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
			lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
			$designspace addPoint fit end $options
			unset options
        }
        {Physical Synthesis with Retiming Space} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Physical Synthesis with Retiming Space"

            foreach {pmr} [list "OFF" "ON"] {
                # MAP: Advanced netlist optimizations
                set options ""
                lappend options ADV_NETLIST_OPT_SYNTH_WYSIWYG_REMAP ON
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options
            }

            # FIT: Try the standard best effort settings first
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
            lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
            lappend options FITTER_EFFORT "AUTO FIT"
            lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
            lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION ON
            lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION ON
            $designspace addPoint fit end $options
            unset options

			foreach {bskew} [list "OFF" "ON"] {
				# FIT: increase in fitter effort level + physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
				lappend options PHYSICAL_SYNTHESIS_EFFORT EXTRA
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options

				# FIT: increase in fitter effort level + physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options

				# FIT: increase in fitter effort level + no physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options				
			}
			
			# FIT: Try a flat fit
			set options ""
			lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
			lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
			lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
			lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
			$designspace addPoint fit end $options
			unset options
        }
        {Extra Effort Space for Quartus II Integrated Synthesis Projects} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Extra Effort Space for Quartus II Integrated Synthesis Projects"

            # MAP: Optimize for area
            set options ""
            lappend options OPTIMIZATION_TECHNIQUE AREA
            lappend options STATE_MACHINE_PROCESSING AUTO
            lappend options MUX_RESTRUCTURE ON
            $designspace addPoint map end $options
            unset options

            # MAP: Optimize for area
            set options ""
            lappend options OPTIMIZATION_TECHNIQUE AREA
            lappend options STATE_MACHINE_PROCESSING AUTO
            lappend options MUX_RESTRUCTURE OFF
            $designspace addPoint map end $options
            unset options

            # MAP: Optimize for speed
            set options ""
            lappend options OPTIMIZATION_TECHNIQUE SPEED
            lappend options STATE_MACHINE_PROCESSING AUTO
            lappend options MUX_RESTRUCTURE OFF
            $designspace addPoint map end $options
            unset options

            # MAP: Optimize for balanced
            set options ""
            lappend options OPTIMIZATION_TECHNIQUE BALANCED
            lappend options STATE_MACHINE_PROCESSING AUTO
            lappend options MUX_RESTRUCTURE OFF
            $designspace addPoint map end $options
            unset options

            # MAP: Optimize for speed
            set options ""
            lappend options OPTIMIZATION_TECHNIQUE SPEED
            lappend options STATE_MACHINE_PROCESSING "USER-ENCODED"
            lappend options MUX_RESTRUCTURE OFF
            $designspace addPoint map end $options
            unset options

            # FIT: increase in fitter effort level
            set options ""
            lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
            lappend options FITTER_EFFORT "STANDARD FIT"
            lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
            lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
            $designspace addPoint fit end $options
            unset options

        }
        {Physical Synthesis Space for Quartus II Integrated Synthesis Projects} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Physical Synthesis Space for Quartus II Integrated Synthesis Projects"

            foreach {pmr} [list "OFF" "ON"] {
                # MAP: Try the standard best effort settings first
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE SPEED
                lappend options MUX_RESTRUCTURE OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for balanced
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE BALANCED
                lappend options STATE_MACHINE_PROCESSING AUTO
                lappend options MUX_RESTRUCTURE OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for speed
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE SPEED
                lappend options STATE_MACHINE_PROCESSING "USER-ENCODED"
                lappend options MUX_RESTRUCTURE ON
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for speed
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE SPEED
                lappend options STATE_MACHINE_PROCESSING AUTO
                lappend options MUX_RESTRUCTURE OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for speed and disable removing duplicate logic
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE SPEED
                lappend options STATE_MACHINE_PROCESSING "USER-ENCODED"
                lappend options MUX_RESTRUCTURE OFF
                lappend options REMOVE_DUPLICATE_LOGIC OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for area
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE AREA
                lappend options STATE_MACHINE_PROCESSING AUTO
                lappend options MUX_RESTRUCTURE ON
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options
            }

            # FIT: Try the standard best effort settings first
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
            lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
            lappend options FITTER_EFFORT "AUTO FIT"
            lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
            lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION ON
            lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION ON
            $designspace addPoint fit end $options
            unset options

			foreach {bskew} [list "OFF" "ON"] {
				# FIT: increase in fitter effort level + physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
				lappend options PHYSICAL_SYNTHESIS_EFFORT EXTRA
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options

				# FIT: increase in fitter effort level + physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options

				# FIT: increase in fitter effort level + no physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options
			}
			
			# FIT: Try a flat fit
			set options ""
			lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
			lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
			lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
			lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
			$designspace addPoint fit end $options
			unset options
        }
        {Physical Synthesis with Retiming Space for Quartus II Integrated Synthesis Projects} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Physical Synthesis with Retiming Space for Quartus II Integrated Synthesis Projects"

            foreach {pmr} [list "OFF" "ON"] {
                # MAP: Try the standard best effort settings first
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE SPEED
                lappend options MUX_RESTRUCTURE OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for balanced
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE BALANCED
                lappend options STATE_MACHINE_PROCESSING AUTO
                lappend options MUX_RESTRUCTURE OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for speed
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE SPEED
                lappend options STATE_MACHINE_PROCESSING "USER-ENCODED"
                lappend options MUX_RESTRUCTURE ON
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for speed
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE SPEED
                lappend options STATE_MACHINE_PROCESSING AUTO
                lappend options MUX_RESTRUCTURE OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for speed and disable removing duplicate logic
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE SPEED
                lappend options STATE_MACHINE_PROCESSING "USER-ENCODED"
                lappend options MUX_RESTRUCTURE OFF
                lappend options REMOVE_DUPLICATE_LOGIC OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for area
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE AREA
                lappend options STATE_MACHINE_PROCESSING AUTO
                lappend options MUX_RESTRUCTURE ON
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options
            }

            # FIT: Try the standard best effort settings first
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
            lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
            lappend options FITTER_EFFORT "AUTO FIT"
            lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
            lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION ON
            lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION ON
            $designspace addPoint fit end $options
            unset options

			foreach {bskew} [list "OFF" "ON"] {
				# FIT: increase in fitter effort level + physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
				lappend options PHYSICAL_SYNTHESIS_EFFORT EXTRA
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options

				# FIT: increase in fitter effort level + physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options

				# FIT: increase in fitter effort level + no physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER 3.0
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options
			}
			
			# FIT: Try a flat fit
			set options ""
			lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
			lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
			lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
			lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
			$designspace addPoint fit end $options
			unset options
        }
        {Selective Performance Optimization Space} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Selective Performance Optimization Space"

            #  Figure out what the base settings were for some key variables
            set base_mult $::quartus::dse::base_point_options(base-placement-effort-multiplier)
            set fsyn_comb $::quartus::dse::base_point_options(fsyn-comb-logic)
            set fsyn_rtm $::quartus::dse::base_point_options(fsyn-retiming)
            set fsyn_rep $::quartus::dse::base_point_options(fsyn-duplication)
            set fsyn_effort $::quartus::dse::base_point_options(fsyn-effort-level)
            if {$fsyn_comb && $fsyn_rtm && $fsyn_rep} {
	            set all_fsyn_algorithms_enabled 1
            } else {
	            set all_fsyn_algorithms_enabled 0
        	}
        	set register_packing $::quartus::dse::base_point_options(stratixii-register-packing)

            #  We will only increase the placement effort multiplier if it was <= unity in the base, if it
            #  was not unity, scale it back to 1 to save compile time, the user will be better off using
            #  this space with a seed sweep rather than increasing the placement effort too high
            if {$base_mult > 1} {
	            set new_effort_multiplier 1
            } else {
	            set new_effort_multiplier 1.5
            }

            #  If register packing was set to normal, try sparse auto, otherwise, try normal
            if {[string equal -nocase $register_packing "normal"]} {
	            set new_register_packing "SPARSE AUTO"
            } else {
	            set new_register_packing "NORMAL"
            }

            #  If FSYN was on before, and in normal mode, try it in Extra effort, otherwise, try turning
            #  it on in normal.
            if {$all_fsyn_algorithms_enabled && [string equal -nocase $fsyn_effort "normal"]} {
	            set new_fsyn_effort "extra"
            } else {
	            set new_fsyn_effort "normal"
            }

            # FIT: Try the standard best effort settings first
            set options ""
            lappend options PRE_MAPPING_RESYNTHESIS ON
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
            lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
            lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
            lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION ON
            lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION ON
            $designspace addPoint fit end $options
            unset options

			foreach {bskew} [list "OFF" "ON"] {
				# FIT: new fsyn + new placement effort
				set options ""
                lappend options PRE_MAPPING_RESYNTHESIS ON
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
				lappend options PHYSICAL_SYNTHESIS_EFFORT $new_fsyn_effort
				lappend options PLACEMENT_EFFORT_MULTIPLIER $new_effort_multiplier
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options

				# FIT: no FSYN + new placement effort
				set options ""
                lappend options PRE_MAPPING_RESYNTHESIS OFF
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER $new_effort_multiplier
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options
			}
        }
        {Selective Performance Optimization Space for Quartus II Integrated Synthesis Projects} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Selective Performance Optimization Space for Quartus II Integrated Synthesis Projects"

            #  Figure out what the base setting were for some key variables
        	set register_packing $::quartus::dse::base_point_options(stratixii-register-packing)
        	set map_technique $::quartus::dse::base_point_options(stratixii-map-optimization-technique)
            set base_mult $::quartus::dse::base_point_options(base-placement-effort-multiplier)

            #  Out of area/speed/balanced, try the 2 that aren't tried in the base
            if {[string equal -nocase $map_technique "BALANCED"]} {
	            set new_map_1 "AREA"
	            set new_map_2 "SPEED"
            } elseif {[string equal -nocase $map_technique "SPEED"]} {
	            set new_map_1 "BALANCED"
	            set new_map_2 "AREA"
            } else {
	            set new_map_1 "BALANCED"
	            set new_map_2 "SPEED"
            }

            foreach {pmr} [list "OFF" "ON"] {
                # MAP: Try the standard best effort settings first
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE SPEED
                lappend options MUX_RESTRUCTURE OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for area
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE $new_map_1
                lappend options STATE_MACHINE_PROCESSING AUTO
                lappend options MUX_RESTRUCTURE AUTO
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options

                # MAP: Optimize for balanced
                set options ""
                lappend options OPTIMIZATION_TECHNIQUE $new_map_2
                lappend options STATE_MACHINE_PROCESSING AUTO
                lappend options MUX_RESTRUCTURE OFF
                lappend options PRE_MAPPING_RESYNTHESIS $pmr
                $designspace addPoint map end $options
                unset options
            }

            #  We will only increase the placement effort multiplier if it was <= unity in the base, if it
            #  was not unity, scale it back to 1 to save compile time, the user will be better off using
            #  this space with a seed sweep rather than increasing the placement effort too high
            if {$base_mult > 1} {
	            set new_effort_multiplier 1
            } else {
	            set new_effort_multiplier 1.5
            }

            #  If register packing was set to normal, try sparse auto, otherwise, try normal
            if {[string equal -nocase $register_packing "normal"]} {
	            set new_register_packing "SPARSE AUTO"
            } else {
	            set new_register_packing "NORMAL"
            }

            # FIT: Try the standard best effort settings first
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
            lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
            lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
            lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION ON
            lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION ON
            $designspace addPoint fit end $options
            unset options

			foreach {bskew} [list "OFF" "ON"] {
				# FIT: increase in fitter effort level + physical synthesis (no register moves)
				set options ""
				lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
				lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
				lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
				lappend options PLACEMENT_EFFORT_MULTIPLIER $new_effort_multiplier
				lappend options FITTER_EFFORT "STANDARD FIT"
				lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
				lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
				lappend options ENABLE_BENEFICIAL_SKEW_OPTIMIZATION "$bskew"
				$designspace addPoint fit end $options
				unset options
			}

        }
        {Area Optimization Space} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Area Optimization Space"

            # MAP: Try wysiwyg remapping and mux restructuring with area mapping
            foreach {M} [list "OFF" "ON"] {
                foreach {N} [list "OFF" "ON"] {
                    set options ""
                    lappend options OPTIMIZATION_TECHNIQUE AREA
                    lappend options MUX_RESTRUCTURE $M
                    lappend options ADV_NETLIST_OPT_SYNTH_WYSIWYG_REMAP $N
                    $designspace addPoint map end $options
                    unset options
                }
            }
        }
        {Power Optimization Space} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Power Optimization Space"

            foreach {mux} [list "OFF" "ON"] {
                foreach {synth} [list "Extra Effort" "Normal Compilation" "OFF"] {
                    foreach {tech} [list "Balanced" "Area"] {
                        set options ""
                        lappend options MUX_RESTRUCTURE $mux
                        lappend options OPTIMIZE_POWER_DURING_SYNTHESIS $synth
                        lappend options OPTIMIZATION_TECHNIQUE $tech
                        $designspace addPoint map end $options
                        unset options
                    }
                }
            }

            foreach {power} [list "Extra Effort" "Normal Compilation"] {
                set options ""
                lappend options OPTIMIZE_POWER_DURING_FITTING $power
                $designspace addPoint fit end $options
                unset options
            }

            # Try one compilation with power optimizations set to normal and turn on
            # FSYN since better performance can lead to lower power, especially on S3,
            # where we can stick to low power mode for more things
            set options ""
            lappend options OPTIMIZE_POWER_DURING_FITTING "Normal Compilation"
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
            lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
            lappend options FITTER_EFFORT "STANDARD FIT"
            lappend options ROUTER_TIMING_OPTIMIZATION_LEVEL "MAXIMUM"
            lappend options ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION "ON"
            $designspace addPoint fit end $options
            unset options

            # Set everything to low-power
            set options ""
            lappend options OPTIMIZE_POWER_DURING_FITTING "Normal Compilation"
			lappend options PROGRAMMABLE_POWER_TECHNOLOGY_SETTING "MINIMIZE POWER ONLY"
            $designspace addPoint fit end $options
            unset options

        }
        {Signature: Placement Effort Multiplier} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Fitting Effort Level Signature"

            # "NORMAL" fitting effort
            $designspace addPoint fit end PLACEMENT_EFFORT_MULTIPLIER  1.0 FITTER_EFFORT {"STANDARD FIT"}

            # "MEDIUM" fitting effort
            $designspace addPoint fit end PLACEMENT_EFFORT_MULTIPLIER  3.0 FITTER_EFFORT {"STANDARD FIT"}

            # "HARD" fitting effort
            $designspace addPoint fit end PLACEMENT_EFFORT_MULTIPLIER  5.0 FITTER_EFFORT {"STANDARD FIT"}

            # "HARDER" fitting effort
            $designspace addPoint fit end PLACEMENT_EFFORT_MULTIPLIER  10.0 FITTER_EFFORT {"STANDARD FIT"}
        }
        {Signature: Fast Fit} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Fast Fit Signature"

            # No fast fit
            $designspace addPoint fit end FAST_FIT_COMPILATION OFF FIT_ONLY_ONE_ATTEMPT OFF

            # Fast fit
            $designspace addPoint fit end FAST_FIT_COMPILATION ON FIT_ONLY_ONE_ATTEMPT ON
        }
        {Signature: Netlist Optimizations} {
            ::quartus::dse::ccl::dputs "${debug_name}: Creating Netlist Optimizations Signature"

            # OFF
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC OFF
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
            $designspace addPoint fit end $options
            unset options

            # ON
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
            lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
            $designspace addPoint fit end $options
            unset options

            # ON
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION OFF
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING OFF
            lappend options PHYSICAL_SYNTHESIS_EFFORT EXTRA
            $designspace addPoint fit end $options
            unset options

            # ON w/Register Moves
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
            lappend options PHYSICAL_SYNTHESIS_EFFORT NORMAL
            $designspace addPoint fit end $options
            unset options

            # ON w/Register Moves
            set options ""
            lappend options PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
            lappend options PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
            lappend options PHYSICAL_SYNTHESIS_EFFORT EXTRA
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
proc ::quartus::dse::stratixiv::get_multiplier_for_type {_t _flowopts _multopts} {
    set debug_name "stratixiv::get_multiplier_for_type()"

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
        {Seed Sweep} {
			set retval [expr $num_seeds*$base_compilation_multiplier]
			if {$flow_options(gui-project-try-llr-restructuring)} {
				if {[string equal -nocase $multiplier_options(selected-search-method) "Exhaustive Search of Exploration Space"] ||
				    $multiplier_options(using-advanced-settings) == 0} {
					set retval [expr ($num_seeds+1)*3 - 1]
				} else {
					set retval [expr ($num_seeds+1)*2 - 1]
				}
			}
        }
        {Extra Effort Space} {
	        #  In extra effort mode we do 3 compiles with effort level 3, and one with
	        #  base effort level
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) $base_settings(fsyn-comb-logic)
	        set temp_settings(fsyn-retiming) $base_settings(fsyn-retiming)
	        set temp_settings(fsyn-duplication) $base_settings(fsyn-duplication)
	        set temp_settings(fsyn-effort-level) $base_settings(fsyn-effort-level)
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0
	        set multiplier_for_effort_3 [get_multiplier_for_settings "temp_settings"]

	        set retval [expr 3*$multiplier_for_effort_3 + $base_compilation_multiplier]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_effort_3 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_effort_3
        	}
        	set num_synthesis_points 0
        }
        {Physical Synthesis Space} {
	        set retval 0

	        #  Common settings
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0

	        #  First compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "extra"
	        set multiplier_for_fsyn_1 [get_multiplier_for_settings "temp_settings"]

	        #  We now try this with Sparse Auto register packing as well, so X4
	        set retval [expr 4*$multiplier_for_fsyn_1 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_1 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_1
	        }

	        #  Second compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_2 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_2 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_2 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_2
	        }

	        #  Third compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 0
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_3 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_3 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_3 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_3
        	}

        	set num_synthesis_points 1
        }
        {Physical Synthesis with Retiming Space} {
	        #  Same as Physical Synthesis space, but with retiming turned on
	        set retval 0

	        #  Common settings
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0

	        #  First compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) "extra"
	        set multiplier_for_fsyn_1 [get_multiplier_for_settings "temp_settings"]

	        #  We now try this with Sparse Auto register packing as well so X4
	        set retval [expr 4*$multiplier_for_fsyn_1 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_1 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_1
	        }

	        #  Second compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_2 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_2 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_2 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_2
	        }

	        #  Third compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 0
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_3 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_3 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_3 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_3
        	}

        	set num_synthesis_points 1
        }
        {Extra Effort Space for Quartus II Integrated Synthesis Projects} {

	        #  Common settings
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0

	        #  In extra effort mode we do 3 compiles with effort level 3, and one with
	        #  base effort level
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) $base_settings(fsyn-comb-logic)
	        set temp_settings(fsyn-retiming) $base_settings(fsyn-retiming)
	        set temp_settings(fsyn-duplication) $base_settings(fsyn-duplication)
	        set temp_settings(fsyn-effort-level) $base_settings(fsyn-effort-level)
	        set multiplier_for_effort_3 [get_multiplier_for_settings "temp_settings"]

	        set retval [expr 3*$multiplier_for_effort_3 + $base_compilation_multiplier]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_effort_3 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_effort_3
	        }

        	set num_synthesis_points 5
        }
        {Physical Synthesis Space for Quartus II Integrated Synthesis Projects} {
	        #  Same as FSYN space, but with up to 5 map points to search
	        set retval 0

	        #  Common settings
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0

	        #  First compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "extra"
	        set multiplier_for_fsyn_1 [get_multiplier_for_settings "temp_settings"]

	        #  We now try this with Sparse Auto register packing as well so X4
	        set retval [expr 4*$multiplier_for_fsyn_1 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_1 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_1
	        }

	        #  Second compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_2 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_2 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_2 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_2
	        }

	        #  Third compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 0
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_3 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_3 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_3 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_3
        	}

        	set num_synthesis_points 5
        }
        {Physical Synthesis with Retiming Space for Quartus II Integrated Synthesis Projects} {
	        #  Same as Physical Synthesis space, but with retiming turned on
	        set retval 0

	        #  Common settings
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0

	        #  First compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) "extra"
	        set multiplier_for_fsyn_1 [get_multiplier_for_settings "temp_settings"]

	        #  We now try this with Sparse Auto register packing as well so X4
	        set retval [expr 4*$multiplier_for_fsyn_1 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_1 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_1
	        }

	        #  Second compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_2 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_2 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_2 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_2
	        }

	        #  Third compilation
	        set temp_settings(placement-effort-multiplier) 3
	        set temp_settings(fsyn-comb-logic) 0
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_3 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_3 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_3 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_3
        	}

        	set num_synthesis_points 5
        }
        {Selective Performance Optimization Space for Quartus II Integrated Synthesis Projects} {
	        set retval 0

	        #  Common settings
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0

            #  Figure out what the base setting were for some key variables
        	set register_packing $multiplier_options(stratixii-register-packing)
        	set map_technique $multiplier_options(stratixii-map-optimization-technique)
            set base_mult $base_settings(placement-effort-multiplier)

            #  We will only increase the placement effort multiplier if it was <= unity in the base, if it
            #  was not unity, scale it back to 1 to save compile time, the user will be better off using
            #  this space with a seed sweep rather than increasing the placement effort too high
            if {$base_mult > 1} {
	            set new_effort_multiplier 1
            } else {
	            set new_effort_multiplier 1.5
            }

	        #  First compilation
	        set temp_settings(placement-effort-multiplier) $new_effort_multiplier
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_1 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_1 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_1 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_1
	        }

        	set num_synthesis_points 2
        }
        {Selective Performance Optimization Space} {
	        set retval 0

	        #  Common settings
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0

		    #  Figure out some base settings that dictate what we do in this space
            set base_mult $multiplier_options(base-placement-effort-multiplier)
            set fsyn_comb $multiplier_options(fsyn-comb-logic)
            set fsyn_rtm $multiplier_options(fsyn-retiming)
            set fsyn_rep $multiplier_options(fsyn-duplication)
            set fsyn_effort $multiplier_options(fsyn-effort-level)

            if {$fsyn_comb && $fsyn_rtm && $fsyn_rep} {
	            set all_fsyn_algorithms_enabled 1
            } else {
	            set all_fsyn_algorithms_enabled 0
        	}
        	set register_packing $multiplier_options(stratixii-register-packing)

            #  We will only increase the placement effort multiplier if it was <= unity in the base, if it
            #  was not unity, scale it back to 1 to save compile time, the user will be better off using
            #  this space with a seed sweep rather than increasing the placement effort too high
            if {$base_mult > 1} {
	            set new_effort_multiplier 1
            } else {
	            set new_effort_multiplier 1.5
            }

            #  If register packing was set to normal, try sparse auto, otherwise, try normal
            if {[string equal -nocase $register_packing "normal"]} {
	            set new_register_packing "SPARSE AUTO"
            } else {
	            set new_register_packing "NORMAL"
            }

            #  If FSYN was on before, and in normal mode, try it in Extra effort, otherwise, try turning
            #  it on in normal.
            if {$all_fsyn_algorithms_enabled && [string equal -nocase $fsyn_effort "normal"]} {
	            set new_fsyn_effort "extra"
            } else {
	            set new_fsyn_effort "normal"
            }

	        #  First compilation
	        set temp_settings(placement-effort-multiplier) $new_effort_multiplier
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) $fsyn_effort
	        set multiplier_for_fsyn_1 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_1 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_1 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_1
	        }

	        #  Second compilation
	        set temp_settings(placement-effort-multiplier) $new_effort_multiplier
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) $new_fsyn_effort
	        set multiplier_for_fsyn_2 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_2 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_2 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_2
	        }

	        #  Third compilation
	        set temp_settings(placement-effort-multiplier) $new_effort_multiplier
	        set temp_settings(fsyn-comb-logic) 0
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_3 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr 2*$multiplier_for_fsyn_3 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_3 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_3
	        }

        	set num_synthesis_points 0
        }
        {Area Optimization Space} {
	        set retval 0
	        #  There are 4 fit points, but they can all be considered base points since
	        #  they do not affect fsyn or placement effort at all
	        set retval [expr 3*$base_compilation_multiplier]
	        set num_synthesis_points 4
        }
        {Power Optimization Space} {
	        set retval 0

	        #  There are 3 fit points equivalent to base and one with FSYN on
	        set retval [expr 3*$base_compilation_multiplier]

		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0
	        set temp_settings(placement-effort-multiplier) $base_settings(placement-effort-multiplier)
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_fsyn + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn
	        }

	        set num_synthesis_points 12
        }
        {Signature: Placement Effort Multiplier} {
	        set retval 0
	        #  We try 4 values of the placement effort multiplier here

	        #  Settings common to all runs
	        set temp_settings(fsyn-comb-logic) $base_settings(fsyn-comb-logic)
	        set temp_settings(fsyn-retiming) $base_settings(fsyn-retiming)
	        set temp_settings(fsyn-duplication) $base_settings(fsyn-duplication)
	        set temp_settings(fsyn-effort-level) $base_settings(fsyn-effort-level)
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0

	        #  Effort 1
	        set temp_settings(placement-effort-multiplier) 1
	        set multiplier_for_effort_1 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_effort_1 + $retval]

	        #  Effort 3
	        set temp_settings(placement-effort-multiplier) 3
	        set multiplier_for_effort_3 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_effort_3 + $retval]

	        #  Effort 5
	        set temp_settings(placement-effort-multiplier) 5
	        set multiplier_for_effort_5 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_effort_5 + $retval]

	        #  Effort 10
	        set temp_settings(placement-effort-multiplier) 10
	        set multiplier_for_effort_10 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_effort_10 + $retval]

	        #  Check if this is the worst multiplier we've seen	(only check 10, it's the worst of these)
	        if {$multiplier_for_effort_10 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_effort_10
	        }

	        set num_synthesis_points 0
        }
        {Signature: Register Packing} {
	        set retval 0
	        #  This is just 5 fit points, all equivalent to base
	        set retval [expr 5*$base_compilation_multiplier]
	        set num_synthesis_points 0
        }
        {Signature: Fast Fit} {
	        set retval 0

	        #  Common Settings
	        set temp_settings(placement-effort-multiplier) $base_settings(placement-effort-multiplier)
	        set temp_settings(fsyn-comb-logic) $base_settings(fsyn-comb-logic)
	        set temp_settings(fsyn-retiming) $base_settings(fsyn-retiming)
	        set temp_settings(fsyn-duplication) $base_settings(fsyn-duplication)
	        set temp_settings(fsyn-effort-level) $base_settings(fsyn-effort-level)

	        #  Compilation 1:  Fast fit on
		    set temp_settings(fast-fit-compilation) 1
		    set temp_settings(fit-one-attempt) 1
	        set multiplier_for_fast_fit [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_fast_fit + $retval]

	        #  Compilation 2:  Fast fit off
		    set temp_settings(fast-fit-compilation) 0
		    set temp_settings(fit-one-attempt) 0
	        set multiplier_for_no_fast_fit [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_no_fast_fit + $retval]

	        set num_synthesis_points 0

        }
        {Signature: Netlist Optimizations} {
	        set retval 0

	        #  Common settings
		    set temp_settings(fast-fit-compilation) $base_settings(fast-fit-compilation)
		    set temp_settings(fit-one-attempt) $base_settings(fit-one-attempt)
	        set temp_settings(placement-effort-multiplier) $base_settings(placement-effort-multiplier)

	        #  First compilation, fsyn off
	        set temp_settings(fsyn-comb-logic) 0
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "extra"
	        set multiplier_for_fsyn_1 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_fsyn_1 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_1 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_1
	        }

	        #  Second compilation, comb only, 'normal'
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_2 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_fsyn_2 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_2 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_2
	        }

	        #  Third compilation, comb only, 'extra
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 0
	        set temp_settings(fsyn-duplication) 0
	        set temp_settings(fsyn-effort-level) "extra"
	        set multiplier_for_fsyn_3 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_fsyn_3 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_3 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_3
	        }

	        #  Fourth compilation, all on, normal
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) "normal"
	        set multiplier_for_fsyn_4 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_fsyn_4 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_4 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_4
	        }

	        #  Fifth compilation, all on, extra
	        set temp_settings(fsyn-comb-logic) 1
	        set temp_settings(fsyn-retiming) 1
	        set temp_settings(fsyn-duplication) 1
	        set temp_settings(fsyn-effort-level) "extra"
	        set multiplier_for_fsyn_5 [get_multiplier_for_settings "temp_settings"]
	        set retval [expr $multiplier_for_fsyn_5 + $retval]

	        #  Check if this is the worst multiplier we've seen
	        if {$multiplier_for_fsyn_5 > $worst_multiplier} {
		        set worst_multiplier $multiplier_for_fsyn_5
        	}

        	set num_synthesis_points 0
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

    if {[string compare $_t "Seed Sweep"] != 0} {
	    switch -- $multiplier_options(selected-search-method) {
	        {Exhaustive Search of Exploration Space} {
		        #  Must run each of the fit points with each synthesis point (+ base) and each
		        #  seed (+ base seed) plus the base compilation must be run with each of the seeds
		        set retval [expr $retval*($num_synthesis_points + 1)*($num_seeds + 1) + (($num_seeds+1)*($num_synthesis_points+1)-1)*$base_compilation_multiplier]

		        #  Could add 2 more per point, including 2 more at base, for LLR restructuring
				if {$flow_options(gui-project-try-llr-restructuring)} {
					set retval [expr 3*$retval + 2*$base_compilation_multiplier]
				}
	        }
	        {Accelerated Search of Exploration Space} {
		        #  Must run each of the fit points + the worst fit point with each of the seeds and each of the synthesis points
		        #  (NOTE:  Worst means in terms of compile time, this gives us a worst-case number)
		        set retval [expr $retval + $num_seeds*$worst_multiplier + $num_synthesis_points*$worst_multiplier]

		        #  Could add 2 more for LLR restructuring
				if {$flow_options(gui-project-try-llr-restructuring)} {
					set retval [expr $retval + 2*$worst_multiplier]
				}

	        }
	        default {
		        return -1
	        }
	    }
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
proc ::quartus::dse::stratixiv::get_multiplier_for_settings {_settings} {
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
