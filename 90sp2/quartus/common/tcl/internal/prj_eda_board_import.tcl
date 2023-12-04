################################################################################
##  prj_eda_board_import.tcl
##
## Licensing:    This script is  pursuant to the following license agreement
##               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
##               FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,
##               California, USA.  Permission is hereby granted, free of
##               charge, to any person obtaining a copy of this software and
##               associated documentation files (the "Software"), to deal in
##               the Software without restriction, including without limitation
##               the rights to use, copy, modify, merge, publish, distribute,
##               sublicense, and/or sell copies of the Software, and to permit
##               persons to whom the Software is furnished to do so, subject to
##               the following conditions:
##
##               The above copyright notice and this permission notice shall be
##               included in all copies or substantial portions of the Software.
##
##               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
##               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
##               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
##               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
##               OTHER DEALINGS IN THE SOFTWARE.
##
##               This agreement shall be governed in all respects by the laws of
##               the State of California and by the laws of the United States of
##               America.
##
################################################################################

lappend auto_path [file join ${::quartus(binpath)} tcl_packages]

if { [string compare $::quartus(nameofexecutable) "quartus_cmd"] == 0 } {
	error "Import of Assignments from Board Tools not supported for quartus_cmd"
}

################################################################################
#
proc import_fx { filename args }  {
#
# Description : 
#         A shortcut to import_assignments_from_fx_file.
#
################################################################################
   if [catch {import_assignments_from_fx_file $filename $args } result ] {
       puts $result
       return -1
   } else {
       return 0
   }
}

################################################################################
#
proc import_assignments_from_fx_file { filename args } {
#
# Description:
#       The function to import Quartus II pin Location assignments in FPGA Xchange
#	File format.
#
# Arguments: 
#	filename - FPGA Xchagne file name
#	args	- other arguments
#
# Returns: 
#	0 - on successful import of FPGA Xchange assginments
#	1 - on errors
#
################################################################################
    package require ::quartus::device

    global overwrite_assignments
    global errorInfo
    global errorCode

    set overwrite_assignments 0
    set header_parsed 0

    set lowercase_file [string tolower $filename]
    if { [string match {*.fx} $lowercase_file] == 0 } {
	post_message -type  error "Wrong file extension!"
	return -1
    }

    #	Initialize variables
    if [ catch { open $filename r} file_id ] {
	error "Can't open file -- $filename"
    }
    set prj_family [get_global_assignment -name FAMILY]
    set prj_part [get_global_assignment -name DEVICE]
    set fx_device ""
    set fx_package ""
    set fx_speed ""

    ##########################################################################
    #	search the file for the device family first

    set line_no 0
    while { [gets $file_id line] >= 0 } {
	incr line_no
	if [regexp {^[  ]*$} $line] {
	    #Ignore empty lines
	} elseif [regexp {^[    ]*#} $line] {
	    #Look for device wide data in comments
	    if [regexp -nocase {#[ 	]*DESIGN\=(.*)} $line match design] {
		set fx_design $design
	    } elseif [regexp -nocase {#[ 	]*DEVICE\=(.*)} $line match device] {
		set fx_device $device
	    } elseif [regexp -nocase {#[ 	]*PACKAGE\=(.*)} $line match package] {
		set fx_package $package
	    } elseif [regexp -nocase {#[ 	]*SPEEDGRADE\=(.*)} $line match speedgrade] {
		set fx_speed $speedgrade
	    }
	    #otherwise this is a comment, ignore

	#Look for device wide data as well as I/O specific information in all lines that are not comments
	} elseif [regexp -nocase {^[ 	]*DESIGN\=(.*)} $line match design] {
	    set fx_design $design
	} elseif [regexp -nocase {^[ 	]*DEVICE\=(.*)} $line match device] {
	    set fx_device $device
	} elseif [regexp -nocase {^[ 	]*PACKAGE\=(.*)} $line match package] {
	    set fx_package $package
	} elseif [regexp -nocase {^[ 	]*SPEEDGRADE\=(.*)} $line match speedgrade] {
	    set fx_speed $speedgrade
	} else {

	    #Parse pin assignments -  These are not device wide data.
	    # The I/O specific data starts with a header row, so we will assume the first row is header row.
	    set fields [split $line ,]
	    if {$header_parsed == 0} {
		if { ($fx_device != "") && ($fx_package != "") && ($fx_speed != "")} {
		    set fx_part "${fx_device}${fx_package}${fx_speed}"
		    if { [get_part_info -family $fx_part] == "" } {
			post_message -type error "Error: The device specified in FPGA Xchange file is not a valid device - Assignments will not be imported"
			return 1
		    }
		}

		# validate the family and device selected before attempting to import any assignments
		# have to append the speed-grade to the device name, otherwise it'll considered to be invalid.
		#before proceding verify if the parts match, if they do not, original assignments will be overwritten?
		if [catch {compare_device_wide_data $fx_design $fx_part} result ] {
		    error "$errorInfo" "$errorCode"
		}

		set signal_name_field [lsearch -regexp $fields "(?i)Signal Name"]
		set pin_number_field [lsearch -regexp $fields "(?i)Pin Number"]
		set io_standard_field [lsearch -regexp $fields "(?i)IO Standard"]
		set diff_type_field [lsearch -regexp $fields "(?i)Diff Type"]
		set direction [lsearch -regexp $fields "(?i)Direction"]
		set drive [lsearch -regexp $fields "(?i)Drive (mA)"]
		set slew_rate [lsearch -regexp $fields "(?i)Slew Rate"]
		set termination [lsearch -regexp $fields "(?i)Termination"]
		set iob_delay [lsearch -regexp $fields "(?i)IOB Delay"]
		set header_parsed 1
		if {$signal_name_field == -1 } {
		    #this is error as all pin assignments require signal name.
		    error  "File $filename, Line $line_no - no column found for signal_name"
		    break
		}
		if {($pin_number_field == -1) && ($io_standard_field == -1) } {
		    error "File $filename, Line $line_no - No useful properties found to make assignments."
		    break
		}
	    } else {
		set signal_name [lindex $fields $signal_name_field]
		regsub -all {\<} $signal_name {[} signal_name
		regsub -all {\>} $signal_name {]} signal_name
		if {$signal_name == ""} {
		    continue
		}
		set diff_type [string toupper [lindex $fields $diff_type_field]]

		#Differential pins are always in pairs, only assignment to positive pin is allowed
		#The negative pin is automatically set to the corresponding negative differential pin
		#Hence skip if this is negative of differential pin.
		if {$diff_type != "" } {
			regsub  {_P(\[[0-9]+\])?$} $signal_name {\1} signal_name
			regsub  {_N(\[[0-9]+\])?$} $signal_name {\1(n)} signal_name
		}

		if {$pin_number_field != -1 } {
		    set fx_pin_number [lindex $fields $pin_number_field]
		    set asgn_pin_number [get_location_assignment -to $signal_name]	
		    if { $asgn_pin_number != "PIN_$fx_pin_number"} {
			if {$asgn_pin_number != ""} { 
			    post_message -type info "Info: Changed pin location for $signal_name changed to PIN_$fx_pin_number from $asgn_pin_number"
			}
			set_location_assignment PIN_$fx_pin_number -to $signal_name
		    }
		}
		if {$io_standard_field != -1 } {
		    set fx_io_standard [lindex $fields $io_standard_field]
		    set asgn_io_standard [get_instance_assignment -to $signal_name -name IO_STANDARD]	
		    if { $asgn_io_standard != "$fx_io_standard"} {
			if {$asgn_io_standard != "" } {
			    post_message -type info "Info: IO Standard for $signal_name changed from $asgn_io_standard to $fx_io_standard"
			}
			set_instance_assignment -name IO_STANDARD $fx_io_standard -to $signal_name
		    }
		}

	    }
	}
    }
    close $file_id
    return
}

################################################################################
#
proc compare_device_wide_data { fx_design fx_device } {
#
# Description:
#
# Arguments: 
#    fx_device     - The device specified in the FPGA Xchange file
#    fx_design  - The design name speficied in FPGA Xchange file.
# 	does not match the current Quartus II project.
#
# Returns: 
#    0 - if fx_device matches the device for current project and fx_design
# 	 the name of current project
#    1 - otherwise 
#
################################################################################

    global overwrite_assignments

    set prj_device [get_global_assignment -name DEVICE]
    set prj_family [get_global_assignment -name FAMILY]


    set fx_family [lindex [get_part_info $fx_device -family] 0]
    if {[regexp -nocase $fx_device $prj_device]} {
	return
    }

    #The device in fx and project did not match exacly , so lets check if family matches
    if { [regexp -nocase $fx_family $prj_family] } {
	post_message -type warning "Info: The device in FPGA Xchange file does not match the device selected in current project - Existing assignments may no longer be valid" 
	set_global_assignment -name DEVICE $fx_device
	post_message -type info "Info: Changed the target device to $fx_device"
	set overwrite_assignments 1
	return
    } 

    #The part in FX file is different family than the part in current project.  This is an error
    post_message -type error "Error: The device in FPGA Xchange file does not match the device selected in current project - Asssignments will not be imported " 
    return -code error 
}

################################################################################
#
proc import_orcad_exp { filename args }  {
#
# Description : 
#         A shortcut to import_assignments_from_orcad_exp_file.
#
################################################################################
   if [catch {import_assignments_from_orcad_exp_file $filename $args } result ] {
       puts $result
       return -1
   } else {
       return 0
   }
}

################################################################################
#
proc import_assignments_from_orcad_exp_file { filename args } {
#
# Description:
#       The function to import Quartus II pin Location assignments from Orcad Export
#	File.
#
# Arguments: 
#	filename - Orcad Export file name
#	args	- other arguments
#
# Returns: 
#	0 - on successful import of FPGA Xchange assginments
#	1 - on errors
#
################################################################################
    package require ::quartus::device
    global overwrite_assignments
    global errorInfo
    global errorCode

    if {[llength $args] != "1"} {
	post_message -type  error "Wrong number of arguments $args!"
	post_message -type  error "Usage: import_assignments_from_orcad_exp_file <filename> <part_reference>!"
	return
    }
    set expected_part_name [lindex $args 0]

    set header_parsed 0

    set lowercase_file [string tolower $filename]
    if { [string match {*.exp} $lowercase_file] == 0 } {
	post_message -type  error "Wrong file extension!"
	return -1
    }

    #	Initialize variables
    if [ catch { open $filename r} file_id ] {
	error "Can't open file -- $filename"
    }
    set prj_family [get_global_assignment -name FAMILY]
    set prj_part [get_global_assignment -name DEVICE]

    ##########################################################################
    #	search the file for the device family first

    set line_no 0
    while { [gets $file_id line] >= 0 } {
	incr line_no
	if [regexp {^[  ]*$} $line] {
	    #Ignore empty lines
	} elseif [regexp {^[    ]*#} $line] {
	    #Does EXP file has comments?
	    #If so ignore these
	} else {
	    #Skip to the header row
	    set fields [split $line \t]
	    if [regexp -nocase {"HEADER"} [lindex $fields 0]] {

		set signal_name_field [lsearch -regexp $fields "(?i)ID"]
		set pin_number_field [lsearch -regexp $fields "(?i)Number"]
		set header_parsed 1

	    }  elseif {$header_parsed == "1"} {
		set object [lindex $fields 0]
		regsub -all {\"} $object {} object
		set object_fields [split $object :]
	    	#We process only pin properties, the pin properties have the following format
	        # PIN:

		if {[lindex $object_fields 0] != "PININST"} {
		    continue
		}
		set signal_id [lindex $fields $signal_name_field]
		regsub -all {\"} $signal_id {} signal_id
		set signal_name_parts [split $signal_id :]
		set orcad_part_ref [lindex $signal_name_parts 0]
		set signal_name [lindex $signal_name_parts 1]
		
		if {$orcad_part_ref == $expected_part_name} {
		    if {$pin_number_field != -1 } {
			set exp_pin_number [lindex $fields $pin_number_field]
			regsub -all {\"} $exp_pin_number {} exp_pin_number
			set asgn_pin_number [get_location_assignment -to $signal_name]	
			if { $asgn_pin_number != "PIN_$exp_pin_number"} {
			    if {$asgn_pin_number != ""} { 
				post_message -type info "Info: Changed pin location for $signal_name changed to PIN_$exp_pin_number from $asgn_pin_number"
			    }
			    set_location_assignment PIN_$exp_pin_number -to $signal_name
			    #puts "set_location_assignment PIN_$exp_pin_number -to $signal_name"
			}
		    }
		}
	    } 
	    #If header is not parsed then skip till header nothing
	    #Although you should see header pretty soon. (Line 2)
	}
    }
    close $file_id
    return
}


################################################################################
#
proc import_sdc { filename args }  {
#
# Description : 
#         A shortcut to import_assignments_from_synplicity_sdc_file.
#
################################################################################
   if [catch {import_assignments_from_synplicity_sdc_file $filename $args } result ] {
       puts $result
       return -1
   } else {
       return 0
   }
}

################################################################################
#
proc import_assignments_from_synplicity_sdc_file { filename args } {
#
# Description:
#       The function to import Quartus II pin Location assignments in FPGA Xchange
#	File format.
#
# Arguments: 
#	filename - Synplify SDC file name
#	args	- other arguments
#
# Returns: 
#       0 when synplify SDC assignments were found
#       2 when no synplify SDC assignments were found - the file may be Quartus SDC file
#
################################################################################
    set synplify_sdc_asgn_found  0
    set lowercase_file [string tolower $filename]
    if { [string match {*.sdc} $lowercase_file] == 0 } {
	post_message -type  error "Wrong file extension!"
	return -1
    }
    
    if [ catch { open $filename r} file_id ] {
	error "Can't open file -- $filename"
    }
    while { [gets $file_id line] >= 0 } {
	string trim $line
	if {$line == ""} { #empty line after removing spaces
	} elseif [regexp {^#} $line] { # Comment lines starting with # character
	} elseif {[lindex $line 0] == "define_attribute"} {
	    #this is a synplify SDC file. define_attribute is not valid SDC
	    set synplify_sdc_asgn_found 1
	    #process attributes
	    if {[lindex $line 2] == "altera_chip_pin_lc"} {
		set target_list [lindex $line 1]
		set locations   [split [lindex $line 3] ,]
		if [regexp {^([a-zA-Z0-9]+)\[([0-9]+):([0-9]+)\]} $target_list match signal msb lsb] {
    		    #The signal is a bus. In this case the number of pin locations specified should 
    		    #be same as the bus width, its error if these are not equal
		    set range [expr abs($msb - $lsb)+1]
		    if {$range != [llength $locations]} {
			#warning --- this is not allowed and should be ignored with warning
		    }

		    for {set idx 0} {$idx < abs($msb - $lsb)} {incr idx} {
			set signal_bit "$signal\[$idx\]"
		    	set sdc_pin_number [string trimleft [lindex $locations $idx] @]
			#First check if the target signal is already assigned to a pin, if so, 
			#issue a warning before making new assignment
			set asgn_pin_number [get_location_assignment -to $signal_bit]	
			if { $asgn_pin_number != "PIN_$sdc_pin_number"} {
			    if {$asgn_pin_number != ""} { 
				post_message -type info "Info: Changed pin location for $signal_bit changed to PIN_$sdc_pin_number from $asgn_pin_number"
			    }
			    set_location_assignment -value PIN_$sdc_pin_number -to $signal_bit
			}
		    }
		} else {
		    #The signal is not a bus, in this case synplify only allows single bit 
		    #signals in  altera_chip_pin_lc attribute
		    #The pin location may be prepended with "@" for older families, we need to 
		    #remove the leading @
		    set signal [lindex $target_list 0]
		    set sdc_pin_number [string trimleft [lindex $locations 0] @]
		    #First check if the target signal is already assigned to a pin, if so, 
		    #issue a warning before making new assignment
		    set asgn_pin_number [get_location_assignment -to $signal]	
		    if { $asgn_pin_number != "PIN_$sdc_pin_number"} {
			if {$asgn_pin_number != ""} { 
			    post_message -type info "Info: Changed pin location for $signal changed to PIN_$sdc_pin_number from $asgn_pin_number"
			}
			set_location_assignment -value PIN_$sdc_pin_number -to $signal
		    }
		}
	    }
	}
    }
    if {$synplify_sdc_asgn_found  == 0} {
	return 2
    }
    return 0
}
