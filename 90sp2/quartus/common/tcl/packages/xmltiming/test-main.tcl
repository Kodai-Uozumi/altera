
#############################################################################
##  test-main.tcl
##
##  This script tests the main ::quartus::xmltiming interface. It exercises
##  every function available in the API. It takes a single argument: the
##  name of a device as you would see it appear in the Quartus II GUI. So
##  an example of using this script would look like:
##
##      quartus_sh -t test-main.tcl EP1S10F780C6
##
##  The script output should be self-explanatory. I highly recommend using
##  this script as a starting point if you're writing your own scripts that
##  use the ::quartus::xmltiming API.
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

package require ::quartus::xmltiming
package require ::quartus::xmltiming::db

proc genrandint {high} {
    return [expr {round(rand() * ($high - 1))}]
}

if {[llength $q_args] < 1} {
    puts stderr "Error: Script requires one argument: a device name!"
    exit 1
}

set device [lindex $q_args 0]


# Use the API to get a list of valid block type/subtype combinations
# for this device. This loads the cache so after this call things
# should speed up considerably.
set block_list [::quartus::xmltiming::get_block_types -part $device]
puts "\nFound the following blocks for $device:"
foreach b $block_list {
    puts "\t[lindex $b 0], [lindex $b 1]"
}
puts ""

# Use the API to get valid locations for one of the blocks.
set blockrint [genrandint [llength $block_list]]
set block_type [lindex [lindex $block_list $blockrint] 0]
set block_subtype [lindex [lindex $block_list $blockrint] 1]
set locations_list [::quartus::xmltiming::get_locations -part $device -blocktype $block_type -blocksubtype $block_subtype]
puts "\nFound the following locations for [lindex $block_list $blockrint]:"
foreach l $locations_list {
    puts "\t$l"
}
puts ""

# Use the API to get valid attributes for each mode.
set locationrint [genrandint [llength $locations_list]]
set x_coord [lindex [lindex $locations_list $locationrint] 0]
set y_coord [lindex [lindex $locations_list $locationrint] 1]
set z_coord [lindex [lindex $locations_list $locationrint] 2]
set attributes_list [::quartus::xmltiming::get_attributes -part $device -blocktype $block_type -blocksubtype $block_subtype -x $x_coord -y $y_coord -subloc $z_coord]
puts "\nFound the following attribute combinatsion for [lindex $block_list $blockrint] at [lindex $locations_list $locationrint]:"
set mode_counter 0
foreach a $attributes_list {
    puts "\tMode $mode_counter:"
    foreach {key value} $a {
        puts "\t\t${key} -> ${value}"
    }
    incr mode_counter
}
puts ""
puts "NOTE: Mode numbers are rather arbitrary and just there to"
puts "      give the clusters of attributes some coherence. You"
puts "      shouldn't rely on a mode number to always return the"
puts "      same cluster of attributes because clusters are"
puts "      returned from get_attributes in any random order and"
puts "      then mode numbers are assigned by this script."
puts ""

# Use the API to get valid input/ouput pairs for a single mode.
set attributesrint [genrandint [llength $attributes_list]]
set inputs_list [::quartus::xmltiming::get_inputs -part $device -blocktype $block_type -blocksubtype $block_subtype -x $x_coord -y $y_coord -subloc $z_coord -attributes [lindex $attributes_list $attributesrint]]
puts "\nFound the following input/output combinations for Mode $attributesrint:"
foreach input $inputs_list {
    foreach output [::quartus::xmltiming::get_outputs -part $device -blocktype $block_type -blocksubtype $block_subtype -x $x_coord -y $y_coord -subloc $z_coord -attributes [lindex $attributes_list $attributesrint] -input $input] {
        set delay [::quartus::xmltiming::get_delay -part $device -blocktype $block_type -blocksubtype $block_subtype -x $x_coord -y $y_coord -subloc $z_coord -attributes [lindex $attributes_list $attributesrint] -input $input -output $output -withunits]
        puts "\t${input} -> ${output} has a delay of $delay"
    }
}
puts ""


# Use the API to get valid mode/microparamter pairs for a single mode.
set attributesrint [genrandint [llength $attributes_list]]
set microparameter_list [::quartus::xmltiming::get_general_microparameters -part $device -blocktype $block_type -blocksubtype $block_subtype -x $x_coord -y $y_coord -subloc $z_coord -attributes [lindex $attributes_list $attributesrint]]
puts "\nFound the following mode/microparameter combinations for Mode $attributesrint:"
foreach microparameter $microparameter_list {
    set delay [::quartus::xmltiming::get_general_microparameter -part $device -blocktype $block_type -blocksubtype $block_subtype -x $x_coord -y $y_coord -subloc $z_coord -attributes [lindex $attributes_list $attributesrint] -microparameter $microparameter -withunits]
    puts "\t${attributesrint} -> ${microparameter} has a delay of $delay"
}

# Use the API to get valid register/microparamter pairs for a single mode.
set attributesrint [genrandint [llength $attributes_list]]
set inputs_list [::quartus::xmltiming::get_inputs -part $device -blocktype $block_type -blocksubtype $block_subtype -x $x_coord -y $y_coord -subloc $z_coord -attributes [lindex $attributes_list $attributesrint]]
puts "\nFound the following register/microparameter combinations for Mode $attributesrint:"
foreach input $inputs_list {
    foreach output [::quartus::xmltiming::get_register_microparameters -part $device -blocktype $block_type -blocksubtype $block_subtype -x $x_coord -y $y_coord -subloc $z_coord -attributes [lindex $attributes_list $attributesrint] -register $input] {
        set delay [::quartus::xmltiming::get_register_microparameter -part $device -blocktype $block_type -blocksubtype $block_subtype -x $x_coord -y $y_coord -subloc $z_coord -attributes [lindex $attributes_list $attributesrint] -register $input -microparameter $output -withunits]
        puts "\t${input} -> ${output} has a delay of $delay"
    }
}
puts ""
