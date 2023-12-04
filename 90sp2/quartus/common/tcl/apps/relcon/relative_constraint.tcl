##############################################################################
#
# File Name:    relative_contraint.tcl
#
# Summary:      This Tcl script generates location constraints for logic 
#               that needs to be placed close to fixed location objects
#               (like pins)
#
# Licencing:
#               ALTERA LEGAL NOTICE
#               
#               This script is  pursuant to the following license agreement
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
#               FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
#               California, USA.  Permission is hereby granted, free of
#               charge, to any person obtaining a copy of this software and
#               associated documentation files (the "Software"), to deal in
#               the Software without restriction, including without limitation
#               the rights to use, copy, modify, merge, publish, distribute,
#               sublicense, and/or sell copies of the Software, and to permit
#               persons to whom the Software is furnished to do so, subject to
#               the following conditions:
#               
#               The above copyright notice and this permission notice shall be
#               included in all copies or substantial portions of the Software.
#               
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#               OTHER DEALINGS IN THE SOFTWARE.
#               
#               This agreement shall be governed in all respects by the laws of
#               the State of California and by the laws of the United States of
#               America.
#
#               
#
# Usage:
#
#               You can run this script from the command line by typing:
#                     quartus_sh -t relative_constraint.tcl <arguments>
#               This script should only be run in the directory of a
#               compiled project.  See Chapter A of the DDR Timing Wizard
#               User Guide for usage instructions.
#
###############################################################################
load_package report
package require cmdline

set version 12

# Get names of what I'll call anchor points
# Get locations of those names
# add the offset value
# Make location assignment to new location

proc verify_versions_match { revision } {

    if { [catch { open db/${revision}.db_info } fh] } {
        return -code error "Compile your project before running the script"
    }

    global quartus
    set versions_match 1
    set found_project_version 0

    # Read through the file to find the version it was last opened in.
    while { [gets $fh line] >= 0 } {

        if { [regexp -nocase -- {\s*Quartus_Version = (.*?)\s*$} \
            $line -> project_version] } {

            set found_project_version 1
            if { ! [string equal $project_version $quartus(version)] } {
                set versions_match 0
            }
            # We found the version line
            break
        }
    }
    catch { close $fh }
    if { ! $versions_match } {
        post_message -type warning "Software version: $quartus(version)"
        post_message -type warning "Project version:  $project_version"
    }
    return $versions_match
}

set options {
    { "project.arg" "" "Name of project" }
    { "revision.arg" "" "Name of revision" }
    { "pin_name.arg" "" "Name of items that are fixed" }
    { "reg_name.arg" "" "Name of floating items to position"}
    { "row_offset.arg" 0 "Row offset relative to anchor location" }
    { "column_offset.arg" 0 "Column offset relative to anchor location" }
    { "apply" "Apply the actual constraints" }
    { "show_regs" "Print out the matching register names" }
    { "show_pins" "Print out the matching pin names" }
    { "pin_range.arg" "" "Pin bus slice to process, specify like 71:0" }
    { "reg_range.arg" "" "Register bus slice to process, specify like 71:0" }
    { "bidir" "Check bidirectional pins" }
    { "input" "Check input pins" }
    { "output" "Check output pins" }
    { "by" "8" "By 4 or by 8" }
}
array set opts [::cmdline::getoptions quartus(args) $options]
set show_settings [expr { ! ($opts(show_regs) || $opts(show_pins)) }]

# Allow the user to check bidirectional, input, and/or output pins
# in any combination. If none of the 3 options are chosen, check only
# bidir. If any of the 3 options are chosen, check only the chosen ones.
if { $opts(bidir) || $opts(input) || $opts(output) } {
    # Analyze only the chosen ones
} else {
    set opts(bidir) 1
}
array set dir_to_panel_name [list \
    input   "Input Pins" \
    output  "Output Pins" \
    bidir   "Bidir Pins" ]
set panels_to_check [list]
foreach direction [list "input" "output" "bidir" ] {
    if { $opts($direction) } {
        lappend panels_to_check $dir_to_panel_name($direction)
    }
}

array set bit_index_to_reg_name [list]

# Figure out how much of the pin range to analyze
if { [string equal "" $opts(pin_range)] } {
    set pin_index_start 0
    set pin_index_stop -1
} else {
    foreach { pin_index_stop pin_index_start } [split $opts(pin_range) ":"] { break }
}

# Figure out how much of the reg range to analyze
if { [string equal "" $opts(reg_range)] } {
    set reg_index_start 0
    set reg_index_stop -1
} else {
    foreach { reg_index_stop reg_index_start } [split $opts(reg_range) ":"] { break }
}

# What's the revision? If it's blank, it's the same as the project name
if { [string equal "" $opts(revision)] } {
    set opts(revision) $opts(project)
}

post_message "Script version $version"

# Make sure the right version is being used
if { [catch { verify_versions_match $opts(revision) } match ] } {
    post_message -type error $match
    exit
} elseif { ! $match } {
    post_message -type error "The project version and software\
        version are different. Use the correct version of the software to\
        run the script."
    exit
}

project_open $opts(project) -revision $opts(revision)
load_report

# Find names matching the register pattern
post_message "Searching for registers matching $opts(reg_name)"
set num_matching_reg_names 0
set floating_name_collection [get_names -filter $opts(reg_name) -node_type reg -observable_type all]

foreach_in_collection floating_name_id $floating_name_collection {

    set reg_name [get_name_info -info full_path $floating_name_id]
    if { [regexp {^.*\[(\d+)\]} $reg_name -> bit_index] } {
    
        # Is it within the bit range?
        if { $bit_index < $reg_index_start } {
            continue
        } elseif { ($reg_index_stop != -1) && ($bit_index > $reg_index_stop) } {
            continue
        } 
        
        set bit_index_to_reg_name($bit_index) $reg_name
    } else {
        post_message -type warning "Couldn't determine bit index for $reg_name"
        continue
    }
    # Optionally show the regs that match in case something is caught inadvertently
    if { $opts(show_regs) } { post_message "   $reg_name" }
    incr num_matching_reg_names
}

foreach panel $panels_to_check {

    # Find names matching the pin pattern
    post_message "Searching for [string tolower $panel] that match $opts(pin_name)"
    
    set panel_id [get_report_panel_id "Fitter||Resource Section||$panel"]
    set name_index [get_report_panel_column_index -id $panel_id "Name"]
    set pin_index [get_report_panel_column_index -id $panel_id {Pin #}]
    set x_coord_index [get_report_panel_column_index -id $panel_id "X coordinate"]
    set y_coord_index [get_report_panel_column_index -id $panel_id "Y coordinate"]
    set assigned_by_index [get_report_panel_column_index -id $panel_id "Location assigned by"]
    set num_rows [get_number_of_rows -id $panel_id]
    set on_row 1
    set num_matching_pin_names 0
    set num_user_assigned_pins 0
    
    while { $on_row < $num_rows } {
    
        set user_name [get_report_panel_data -id $panel_id -row $on_row -col $name_index]
        if { [string match [escape_brackets $opts(pin_name)] $user_name] } {
        
            if { [regexp {^.*\[(\d+)\]} $user_name -> bit_index] } {
    
                # Is it within the bit range?
                if { $bit_index < $pin_index_start } {
                    incr on_row
                    continue
                } elseif { ($pin_index_stop != -1) && ($bit_index > $pin_index_stop) } {
                    incr on_row
                    continue
                } 
    
            } else {
                post_message -type warning "Couldn't determine bit index for $user_name"
                incr on_row
                continue
            }
            
            # We have a matching name
            incr num_matching_pin_names
            
            set pin [get_report_panel_data -id $panel_id -row $on_row -col $pin_index]
            set x_coord [get_report_panel_data -id $panel_id -row $on_row -col $x_coord_index]
            set y_coord [get_report_panel_data -id $panel_id -row $on_row -col $y_coord_index]
            set assigned_by [get_report_panel_data -id $panel_id -row $on_row -col $assigned_by_index]
    
            # Optionally show the pins are that match in case something is caught inadvertently
            if { $opts(show_pins) } {
                post_message "$user_name\tpin $pin\trow $y_coord\tcol $x_coord"
            }
            
            # Is the pin user-assigned?
            if { [string match "User" $assigned_by] } { incr num_user_assigned_pins }
            
            # Now, what's the relative offset?
            set new_x_coord [expr { $x_coord + $opts(column_offset) }]
            set new_y_coord [expr { $y_coord + $opts(row_offset) }]
            
            # Handle a bit offset
            set bit_index [expr { $bit_index - $pin_index_start + $reg_index_start } ]
            
            if { $show_settings } {
                post_message "   $user_name\tpin $pin\tLAB_X${new_x_coord}_Y${new_y_coord}\t$bit_index_to_reg_name($bit_index)"
            }
             
            # If we're actually applying the location assignment
            if { $opts(apply) } {
                set_location_assignment -to $bit_index_to_reg_name($bit_index) -tag "Added by [info script]" LAB_X${new_x_coord}_Y${new_y_coord}
            }
        }
        incr on_row
    }

}
post_message "Found $num_matching_reg_names registers that match $opts(reg_name)"
post_message "Found $num_matching_pin_names pins that match $opts(pin_name)"

if { $num_matching_pin_names != $num_user_assigned_pins } {
    set num_fitter_placed_pins [expr { $num_matching_pin_names - $num_user_assigned_pins }]
    post_message -type warning "$num_fitter_placed_pins of the $num_matching_pin_names pins that match have locations assigned by the fitter."
    post_message -type warning "The locations could change during another place and route. Consider making location assignments to the pins."
}

if { $num_matching_reg_names != $num_matching_pin_names } {
    post_message -type warning "Unequal number of pins and registers. Ensure your patterns are correct."
    post_message -type warning "Use the -show_regs and/or -show_pins options to show matching registers and pins."
} elseif { ! $opts(apply) } {
    post_message "Rerun the script with the -apply option to make the new assignments"
}

unload_report
project_close
