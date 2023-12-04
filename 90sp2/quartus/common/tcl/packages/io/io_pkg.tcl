#############################################################################
##  io.tcl - v2.0
##
##  This Tcl/Tk library provides access to the I/O properties for ALTERA 
##  devices
##
##  To use these functions in your own Tcl/Tk scripts just add:
##
##      package require ::quartus::io
##
##  to the top of your scripts. 
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
#############################################################################


package provide ::quartus::io 2.0

#############################################################################
## Additional Packages Required
package require ::quartus::device
package require ::quartus::advanced_device 2.0

#############################################################################
## Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::io {

	#device/package functions
	namespace export load_device_database
	namespace export unload_device_database
	namespace export get_pin_count
	namespace export get_io_bank_count
	namespace export get_pin_names

	#properties of the pin
	namespace export get_io_bank
	namespace export is_bonded 
	namespace export is_row_io_pin
	namespace export is_column_io_pin
	namespace export get_pad_number_of_pin
	namespace export get_pad_coordinates
	namespace export get_distance_in_pads 
	namespace export get_distance_in_labs
	namespace export get_pin_functions
	namespace export is_general_purpose_single_ended_pin

	namespace export is_vccio_pin
	namespace export is_vref_pin
	namespace export is_vcc_pin
	namespace export is_gnd_pin
	namespace export is_input_pin
	namespace export is_output_pin
	namespace export is_bidir_pin
	namespace export is_clock_input_pin
	namespace export is_clock_output_pin
	namespace export is_fast_clock_pin
	namespace export is_dedicated_configuration_pin
	namespace export is_dual_purpose_configuration_pin
	namespace export is_global_clear_pin
	namespace export is_global_oe_pin
	namespace export is_dclk_pin

	namespace export get_vref_pin
	namespace export has_bus_hold
	namespace export has_weak_pullup
	namespace export has_open_drain

	# Properties of the pad
	namespace export get_pad_data_by_pin_id
	namespace export get_pad_data_by_pin_name
	namespace export get_pad_data_by_pad_id
	namespace export get_pad_data_by_io_standard

	#JTAG pin information
	namespace export is_jtag_tck_pin
	namespace export is_jtag_tms_pin
	namespace export is_jtag_trst_pin
	namespace export is_jtag_tdi_pin
	namespace export is_jtag_tdo_pin
	
	#PLL pin information
	namespace export is_pll_enable_pin
	namespace export is_pll_clock_output_pin
	namespace export is_pll_feedback_pin

	#Memory interfaces pins
	namespace export is_dqs_pin
	namespace export is_dq_pin
	namespace export is_dqvld_pin
	namespace export is_dm_pin
	namespace export get_dq_group
	namespace export get_all_dq_groups 
	namespace export get_dqs_complement_pin 

	#On chip termination functions
	namespace export is_termination_rup_pin
	namespace export is_termination_rdn_pin
	namespace export has_pci_clamp_diode
	namespace export has_series_termination
	namespace export has_series_termination_with_calibration
	namespace export has_parallel_termination
	namespace export has_differential_termination

	#Differntial IO
	namespace export is_transceiver_pin
	namespace export is_differential_input_pin
	namespace export is_differential_output_pin
	namespace export is_differential_bidir_pin
	namespace export is_differential_positive_pin
	namespace export get_differential_complement_pin

	#IO Standards
	namespace export get_io_standards
	namespace export get_drive_strength
	namespace export get_voltage
	namespace export get_voltage_of_pin
	namespace export get_operation_modes
	namespace export get_slew_rates
	namespace export io_standard_supports_open_drain
	namespace export io_standard_supports_bus_hold
	namespace export io_standard_supports_weak_pullup

	#IO Rules
	namespace export get_max_outputs_per_vref_bank
	namespace export get_output_to_vref_distance
	namespace export get_output_to_dclk_distance
	namespace export get_min_single_ended_to_differential_distance
	namespace export is_single_inputs_allowed_when_dpa_enabled
	namespace export is_single_outputs_allowed_when_dpa_enabled
	namespace export get_row_dc_current_limits 
	namespace export get_column_dc_current_limits 
	namespace export is_sso_limit_vref_bank_based
	namespace export is_single_io_allowed_with_differential_io_in_pll_output_bank
	#namespace export is_single_outputs_allowed_with_differential_io_in_bank 

	#Utility functions
	namespace export get_vref_name

	namespace export is_top_io_pin 
	namespace export is_bottom_io_pin 
	namespace export is_left_io_pin 
	namespace export is_right_io_pin 

	variable current_family

}

#############################################################################
##
proc ::quartus::io::print_error_message {function_name error_msg func_error} {
##
##  Arguments:
##      <function_name> - Name of the function called that caused an error
##      <error_msg> - Error Message returned by the command in the 
##							 device/advanced_device package
##      <func_error> - errorInfo corresponding to the io function called
##              
##
##  Description: Print out error message defined for the IO package
##
##  Returns:
##		Nothing
################################################################################

	set illegal_part {ERROR: Illegal part name:*}
	set device_not_loaded {ERROR: No device database is loaded.*}
	set bad_iostd {"*The IO Standard specified is not valid*"}
	set another_error {ERROR: *}

	if {[string match $illegal_part $error_msg] == 1} {
		set errorCode "INVALID_PART"
		set errorInfo "The part name specified is not valid"
	} elseif {[string match $device_not_loaded $error_msg] == 1} {
		set errorCode "DEVICE_NOT_LOADED"
		set errorInfo "The device is not loaded"
	} elseif {[string match $bad_iostd $error_msg] == 1} {
		set errorCode "INVALID_IOSTANDARD"
		set errorInfo "The IO Standard specified is not valid"
	} else {
		set errorCode "NOT_APPLICABLE"
		set errorInfo $func_error
	}
	set errorMsg "Error: $function_name: $errorInfo"
	error $errorMsg $errorInfo $errorCode
}

#############################################################################
##
proc ::quartus::io::is_family_pre_iii_gen {} {
##
##  Arguments:
##      none - function checks the family of part loaded
##
##  Description:
##      This function checks if the family that the loaded part belongs 
##		  to is pre titan/cuda
##
##  Returns:
##      1 for pre_titan/cuda, 0 otherwise
################################################################################
	variable current_family
	set is_old 0

	set old_families {"Stratix II" "Stratix GX" "Cyclone II" "HardCopy II" "HardCopy Stratix" "Stratix II GX" "Arria GX" "Cyclone" "MAX II" "Stratix"}

	if [ regexp -nocase (\"$current_family\") $old_families ] {
			# old family
		set is_old 1
	}
	return $is_old
}

#############################################################################
##
proc ::quartus::io::pin_supports_io_standard {pin io_standard} {
##
##  Arguments:
##      <io_standard> - IO Standard
##
##  Description:
##      This function checks if a pin supports an IO Standard
##
##  Returns:
##      Supported or not
################################################################################
	set is_supported 0
	set errorInfo ""

	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		set ios_list [::get_pad_data -pad $pad LIST_IO_STANDARDS]
		foreach ios $ios_list {
			set user_ios [get_user_name -io_standard $ios]
      	if {[string equal $user_ios $io_standard] == 1} {
				set is_supported 1
				break
			}
		}
	}
	return $is_supported
}

#############################################################################
##
proc ::quartus::io::get_internal_io_standard_name {pin io_standard} {
##
##  Arguments:
##      <io_standard> - IO Standard
##
##  Description:
##      This function converts a user io standard name in the corresponding
##      quartus I/O standard name.  The use of this function is to capture 
##      any pin specific I/O standard name mapping such as the difference
##      between HIO and VIO.
##
##  Returns:
##      Supported or not
################################################################################
	set result 0
	set errorInfo ""

	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		set ios_list [::get_pad_data -pad $pad LIST_IO_STANDARDS]
		foreach ios $ios_list {
			set user_ios [get_user_name -io_standard $ios]
      	if {[string equal $user_ios $io_standard] == 1} {
				set result $ios
				break
			}
		}
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::family_supports_calibration { user_family } {
##
##  Arguments:
##      <family> - device family
##
##  Description:
##      This function checks if a given family supports calibration
##
##  Returns:
##      0 - cannot be found out - ERROR condition
##		  1 - if calibration is not supported on any pin
##	 	  2 - if calibration is supported on all pins
##		  3 - if calibration is supported on some pins (additional checks may 
##				be required for the specific pin)
##
################################################################################

	set calib_support 0
	set errorInfo ""
	set group_num 0

	set fam_with_no_calib {}
	lappend fam_with_no_calib {MAX II}
	lappend fam_with_no_calib {Stratix}
	lappend fam_with_no_calib {Stratix GX} 
	lappend fam_with_no_calib {HardCopy Stratix} 
	lappend fam_with_no_calib {Cyclone} 
	lappend fam_with_no_calib {Cycone II}

	set fam_with_calib {}
	lappend fam_with_calib {Cyclone III} 
	lappend fam_with_calib {Stratix III}

	set fam_with_conditional_calib {}
	lappend fam_with_conditional_calib {Stratix II}
	lappend fam_with_conditional_calib {HardCopy II}
	lappend fam_with_conditional_calib {Stratix II GX}
	lappend fam_with_conditional_calib {Arria GX}

	incr group_num
	foreach fam $fam_with_no_calib {
      if {[string equal $user_family $fam] == 1} {
			set calib_support $group_num
			break
		}
	}
	if {$calib_support == 0} {
		incr group_num
		foreach fam $fam_with_calib {
      	if {[string equal $user_family $fam] == 1} {
				set calib_support $group_num
				break
			}
		}
	}
	if {$calib_support == 0} {
		incr group_num
		foreach fam $fam_with_conditional_calib {
      	if {[string equal $user_family $fam] == 1} {
				set calib_support $group_num
				break
			}
		}
	}
	return $calib_support
}
#############################################################################
##
proc ::quartus::io::load_device_database {part} {
##
##  Arguments:
##      <part> - Part Name in the format EP1S80F1020C6
##              
##
##  Description:
##	This function is used to load the device database in memory.
##	Device must be successfully loaded in the memory before any of the io properties
##	are accessed
##	If the device in memory is different than the requested device, then unload the 
##	device in memory and load the requested device.
##
##  Returns:
##	TCL_OK    - whenthe device is successfully loaded
##	TCL_ERROR - on error
################################################################################
	#Call the load device from ::quartus::advanced_device package

	set errorInfo ""
	variable current_family

	if [ catch {::load_device -part $part} return_val] {
		set errorInfo $return_val
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_name "load_device_database $part"
		set func_error "The part name specified is not valid"
		print_error_message $func_name $errorInfo $func_error
	} else {
		set family_of_part [ get_part_info -family $part ]
		set current_family [ lindex $family_of_part 0 ]
	}
	return $return_val
}
#############################################################################
##
proc ::quartus::io::unload_device_database {} {
##
##  Arguments:
##      None
##              
##
##  Description:
##	This function is used to unload the device database in memory.
##
##  Returns:
##	TCL_OK    - whenthe device is successfully loaded
##	TCL_ERROR - on error
################################################################################
	#Call the unload device from ::quartus::advanced_device package

	set errorInfo ""
	variable current_family

	if [catch {::unload_device} return_val] {
		set errorInfo $return_val
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_name "unload_device_database $part"
		set func_error "The device database is not loaded"
		print_error_message $func_name $errorInfo $func_error
	}
	return $return_val
}

#############################################################################
##
proc ::quartus::io::get_pin_count {} {
##
##  Arguments:
##      None
##              
##
##  Description:
##	This function can be used to get the total pins in the device 
##	currently in memory.
##
##  Returns:
##	TCL_OK    - whenthe device is successfully loaded
##	TCL_ERROR - on error
################################################################################

	set errorInfo ""
	if [ catch {::get_pkg_data INT_PIN_COUNT} pincount ] {
		set errorInfo $pincount
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_name "get_pin_count"
		set func_error "The I/O Rule does not apply for the current device"
		print_error_message $func_name $errorInfo $func_error
	}
	return $pincount
}

#############################################################################
##
proc ::quartus::io::get_io_bank_count {} {
##
##  Arguments:
##      None
##              
##
##  Description:
##	This function can be used to get the number of IO banks in the device currently in memory.
##
##  Returns:
##	TCL_OK    - whenthe device is successfully loaded
##	TCL_ERROR - on error
################################################################################

	set errorInfo ""
	if [catch {::get_pad_data INT_IO_BANK_COUNT} iobankcnt] {
		set errorInfo $iobankcnt
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_name "get_io_bank_count"
		set func_error "The I/O Rule does not apply for the current device"
		print_error_message $func_name $errorInfo $func_error
	}
	return $iobankcnt
}


#############################################################################
##
proc ::quartus::io::get_pin_location_name {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##      A pin can be refered to by the location on the package, the function name, the
##	secondary function supported by pin or other internal name.
##	This function returns the pin number (i.e pin name by position). i.e A11, etc.
##
##  Returns:
##	pin_num -  The pin number of the current pin.
##	-1      - on Error
################################################################################
	set name ""
	set pad [get_first_pad $pin]
	if {$pad == ""} {
		if [ catch {::get_pkg_data -pin $pin STRING_USER_PIN_NAME} name ] {
			set name ""
		}
	} else {
		if [ catch {::get_pad_data -pad $pad STRING_USER_PIN_NAME} name ] {
			set name ""
		}
	}
	return $name
}


#############################################################################
##
proc ::quartus::io::get_pin_type {pinname} {
##
##  Arguments:
##      <pinname> - Pin Name
##
##  Description:
##      A pin can be refered to by the location on the package, the function name, the
##	secondary function supported by pin or other internal name.
##	This function returns the function name of the pin.
##
##  Returns:
##	name -  Function name of the pin.
##	-1   - on Error
################################################################################
	set name ""
	if {[is_bonded $pinname] == 1} {
		set pad [get_first_pad_of_pinname $pinname]
		if {$pad == ""} {
			if [ catch {::get_pkg_data -pin_name $pin STRING_TYPE_NAME} name ] {
				set name ""
			}
		} else {
			if [ catch {::get_pad_data -pad $pad STRING_TYPE_NAME} name ] {
				set name ""
			}
		}
	}
	return $name
}

#############################################################################
##
proc ::quartus::io::get_pin_functions {pinname} {
##
##  Arguments:
##      <pinname> - Pin location Name
##
##  Description:
##      A pin can be refered to by the location on the package, the function name, the
##	secondary function supported by pin or other internal name.
##	This function returns the function name of the pin.
##
##
##  Returns:
##	name -  List of function names of the pin.
##	-1   - on Error
################################################################################
	set name_list ""
	set name ""
	set errorInfo ""
	if {[is_bonded $pinname] == 1} {
		set is_vref false
		set pad [get_first_pad_of_pinname $pinname]
		if [ catch {::get_pad_data -pad $pad BOOL_IS_VREF_PAD} is_vref ] {
			set is_vref 0
		}
		if {$is_vref != 0} {
			if [ catch {::get_pad_data -pad $pad STRING_MCF_NAME} name ] {
				set name ""
			} else {
				lappend name_list $name
			}
		} else {
			if [ catch {::get_pad_data -pad $pad STRING_TYPE_NAME} name ] {
				set name ""
			} else {
				if ![ regexp -nocase {^(row|column|dedicated|jtag)} $name] {
					lappend name_list $name
				}
			}
		}
		if [ catch {::get_pad_data -pad $pad STRING_AUXILIARY_FUNCTION_NAME} name ] {
			set name ""
		} else {
			set name [regsub -all {[,/][ 	]*} $name " "]
			lappend name_list $name
		}

	} else {
		if [ catch {::get_pkg_data -pin_name $pinname STRING_TYPE_NAME} name ] {
			set name ""
		} else {
			if ![ regexp -nocase {^(row|column|dedicated|jtag)} $name] {
				lappend name_list $name
			}
		}
	}

	if {[string equal "" $errorInfo] == 0} {
		set func_name "get_pin_functions $pinname"
		set func_error "The property is not valid for the current pin"
		print_error_message $func_name $errorInfo $func_error
	}
	return $name_list
}

#############################################################################
##
proc ::quartus::io::get_io_bank {pin} {
##
##  Arguments:
##      <pin> - Pin Name
##
##  Description:
##       Get the IO bank of the given pin.
##
##  Returns:
##      <io_bank>  - The IO bank of the current pin (PAD connected to current pin)
##	-1         - if Error occurs
################################################################################

	set io_bank -1
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]

	if {$pad == -1} {
		if [ catch {::get_pkg_data -pin_name $pin INT_IO_BANK_ID } io_bank] {
			set errorInfo $io_bank
			set io_bank -1;
		}
	} else {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_BONDED } bonded] {
			set errorInfo $bonded
			set io_bank 0
		} else {
			if [ catch {::get_pad_data -pad $pad INT_IO_BANK_ID } io_bank] {
				set errorInfo $io_bank
				set io_bank -1;
			}
		}
	}
	set empty_string ""
	set is_empty [string equal $empty_string $errorInfo]
	if {$is_empty == 0} {
		set errorMsg "get_io_bank: $pin"
		set this_func_error "The property is not valid for the current pin"
		print_error_message $errorMsg $errorInfo $this_func_error
	}

	# add 1 to all io_bank values except when its of type VCCINT or GND
	set pin_func [ ::quartus::io::get_pin_type $pin ]
	if { [ string match -nocase $pin_func "VCCINT" ] || [ string match -nocase $pin_func "GND" ] } {

	} else {
		if {$io_bank != -1} {
			incr io_bank
		}
	}

	return $io_bank
}


#############################################################################
##
proc ::quartus::io::is_vccio_pin {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function can be used to check it the given pin is a VCCIO pin.
##
##  Returns:
##      1  - if the current pin is VCCIO
##	0  - if the current pin is not a VCCIO pin
##	-1 - if Error occurs
################################################################################
	set is_vccio 0
	set errorInfo ""

	if {[is_bonded $pin] == 1} {
		if [catch {::get_pkg_data -pin_name $pin BOOL_IS_VCCN } is_vccio] {
			set errorInfo $is_vccio
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set this_func_error "The property is not valid for the current pin"
		print_error_message "is_vccio_pin: $pin" $errorInfo $this_func_error
	}
		
	return $is_vccio
}
#############################################################################
##
proc ::quartus::io::is_vcc_pin {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function can be used to check it the given pin is a VCC pin.
##
##  Returns:
##      1  - if the current pin is VCC
##	0  - if the current pin is not a VCC pin
##	-1 - if Error occurs
################################################################################
	set errorInfo ""
	set is_vcc 0

	if {[is_bonded $pin] == 1} {
		if [catch {::get_pkg_data -pin_name $pin BOOL_IS_VCC } is_vcc] {
			set errorInfo $is_vcc
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_vcc_pin: $pin" $errorInfo $func_error
	}
	return $is_vcc
}

#############################################################################
##
proc ::quartus::io::is_gnd_pin {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function can be used to check it the given pin is a ground (GND) pin.
##
##  Returns:
##      1  -  if the current pin is GND
##	0  -  if the current pin is not a GND pin
##	-1 - if Error occurs
################################################################################
	set errorInfo ""
	set is_vss 0

	if {[is_bonded $pin] == 1} {
		if [catch {::get_pkg_data -pin_name $pin BOOL_IS_VSS } is_vss] {
			set errorInfo $is_vss
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_gnd_pin: $pin" $errorInfo $func_error
	}
	return $is_vss
}
#############################################################################
##
proc ::quartus::io::is_input_pin {pin} {
##
##  Arguments:
##      <pin> - Pin Name
##
##  Description:
##       This function is used to find out if a given pin an input only pin
##
##  Returns:
##      1   - if the current pin is dedicated input
##	0   - if the pin is not a dedicated input pin 
##	-1  - on error.
################################################################################

	set is_input 0
	set errorInfo ""
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if [catch {::get_pad_data -pad $pad BOOL_IS_DEDICATED_INPUT_PAD} is_input] {
			if {[string match "ERROR: Data for variable BOOL_IS_DEDICATED_INPUT_PAD for current device does not exist.*" $is_input] == 1} {
				set is_input 0
			} else {
				set errorInfo $is_input
			}
		}
	} else {
		set errorInfo "ERROR"
	}

	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_input_pin: $pin" $errorInfo $func_error
	}
	return $is_input
}

#############################################################################
##
proc ::quartus::io::is_output_pin {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function is used to find out if a given pin a dedicated output pin
##
##  Returns:
##      1   - if the current pin is dedicated output
##	0   - if the pin is not a dedicated output pin 
##	-1  - on error.
################################################################################

	set is_output 0
	set errorInfo ""
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if [ catch {::get_pad_data -pad $pad BOOL_IS_DEDICATED_OUTPUT_PAD} is_output] {
			if {[string match "ERROR: Data for variable BOOL_IS_DEDICATED_OUTPUT_PAD for current device does not exist.*" $is_output] == 1} {
				set is_output 0
			} else {
				set errorInfo $is_output
			}
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		set func_name "is_output_pin: $pin"
		print_error_message $func_name $errorInfo $func_error
	}
	return $is_output
}

#############################################################################
##
proc ::quartus::io::is_bidir_pin {pin} {
##
##  Arguments:
##      <pin> - Pin Name
##
##  Description:
##       This function is used to find out if a given pin a bidir pin
##
##  Returns:
##      1   - if the current pin is bidir output
##		  0   - if the pin is not a bidir
##	
################################################################################

	set is_bidir 0
	set errorInfo ""
	set in_only 1
	set out_only 1

	if {[is_bonded $pin]} {
		if [ catch {is_input_pin $pin} in_only ] {
			set errorInfo $in_only
		}
		if [ catch {is_output_pin $pin} out_only ] {
			set errorInfo $out_only
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		set func_name "is_bidir_pin: $pin"
		print_error_message $func_name $errorInfo $func_error
	}
	if { $in_only == 0 && $out_only == 0 } {
		set is_bidir 1
	}
	return $is_bidir
}

#############################################################################
##
proc ::quartus::io::is_clock_input_pin {pin} {
##
##  Arguments:
##      <pin> - Pin Name
##
##  Description:
##       This function can be used to find out if the given pin is a (dedicated?) clock pin.
##
##  Returns:
##      1  - if the current pin is clock pin
##	0  - if the pin is not a clock pin
##	-1 - if error occurs
################################################################################
	set is_clk 0
	set errorInfo ""
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if [ catch {::get_pad_data -pad $pad BOOL_IS_CLOCK_PAD  } is_clk] {
			set errorInfo $is_clk
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_clock_input_pin: $pin" $errorInfo $func_error
	}
	return $is_clk
}

#############################################################################
##
proc ::quartus::io::is_clock_output_pin {pin} {
##
##  Arguments:
##      <pin> - Pin Name
##
##  Description:
##       This function can be used to find out if the given pin 
##			can be used as a clock out pin
##
##  Returns:
##      1  - if the current pin is clockout pin
##		0  - if the pin is not a clockout pin
################################################################################
	set is_clk 0
	set errorInfo ""
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if [ catch {::get_pad_data -pad $pad BOOL_IS_CLOCKOUT_PAD  } is_clk] {
			set errorInfo $is_clk
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_clock_output_pin: $pin" $errorInfo $func_error
	}
	return $is_clk
}

#############################################################################
##
proc ::quartus::io::is_fast_clock_pin {pin} {
##
##  Arguments:
##      <pin> - Pin Name
##
##  Description:
##       This function can be used to find out if the given pin a FAST (regional?) Clock pad
##
##  Returns:
##      1  - if the current pin is fast clock pin
##	0  - if the pin is not a fast clock pin
##	-1 - if error occurs
################################################################################
	set is_clk 0
	set errorInfo ""
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if [ catch {::get_pad_data -pad $pad BOOL_IS_FCLKIN_PAD } is_clk] {
			set errorInfo $is_clk
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_fast_clock_pin: $pin" $errorInfo $func_error
	}
	return $is_clk
}

#############################################################################
##
proc ::quartus::io::is_generic_io { pin_id } {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       Tells if a given pin a general purpose IO pin, use this function with caution as
##       Normal general purpose I/O pin may have a secondary function of some control signal
##       of importance (e.g. clock, etc).
##
##  Returns:
##      1  - if the current pin can be used as general purpose IO
##	0  - if the current pin cannot be used as general purpose IO
##	-1 - if there is an Error
################################################################################
	set is_io 0
	set pad [get_first_pad $pin_id]
	if [ catch {::get_pad_data -pad $pad BOOL_IS_USABLE_AS_REGULAR_IO  } is_io] {
		set is_io -1
	}
	return $is_io
}

#############################################################################
##
proc ::quartus::io::is_general_purpose_single_ended_pin {pin} {
##
##  Arguments:
##      <pin> - Pin name (location name)
##
##  Description:
##       Tells if a given pin a general purpose IO pin, use this function 
##			with caution as normal general purpose I/O pin may have a 
##			secondary function of some control signal of importance 
##			(e.g. clock, etc).
##
##  Returns:
##      1  - if the current pin can be used as general purpose IO
##	0  - if the current pin cannot be used as general purpose IO
##	-1 - if there is an Error
################################################################################
	set is_io 0
	set errorInfo ""
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if [ catch {::get_pad_data -pad $pad BOOL_IS_USABLE_AS_REGULAR_IO } is_io] {
			set errorInfo $is_io
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_general_purpose_single_ended_pin: $pin" $errorInfo $func_error
	}
	return $is_io
}
#############################################################################
##
proc ::quartus::io::is_dedicated_configuration_pin {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function can be used to find out if the given pin is a dedicated programming pin.
##
##  Returns:
##      1  - if the current pin is a dedicated programming pin.
##	0  - if the current pin is not a dedicated programming
##	-1 - if there was an Error.
################################################################################
	set is_prog 0
	set errorInfo ""
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if [ catch {::get_pad_data -pad $pad BOOL_IS_DEDICATED_PROGRAMMING_PAD} is_prog] {
			set errorInfo $is_prog
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_dedicated_configuration_pin: $pin" $errorInfo $func_error
	}
	return $is_prog
}

#############################################################################
##
proc ::quartus::io::is_dual_purpose_configuration_pin {pin} {
##
##  Arguments:
##      <pin> - Pin name
##
##  Description:
##       This function can be used to find out if the given pin is 
##			a configuration pin that can be programmed for another function
##
##  Returns:
##      1  - if the current pin is a dual purpose programming pin.
##	0  - if the current pin is not a dual purpose programming
##	-1 - if there was an Error.
################################################################################
	set result 0
	set errorInfo ""
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if [ catch {::get_pad_data -pad $pad BOOL_IS_DUAL_PURPOSE_PROGRAMMING_PAD} result] {
			set errorInfo $result
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_dual_purpose_configuration_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_global_clear_pin {pin} {
##
##  Arguments:
##      <pin> - Pin name
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		set global_clr [::get_pad_data -pad $pad BOOL_IS_GLOBAL_CLEAR_PAD]
		set dev_clrn [::get_pad_data -pad $pad BOOL_IS_DEV_CLRN_PAD]
		if {$global_clr == 1 || $dev_clrn == 1} {
			set result 1
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_global_clear_pin: $pin" $errorInfo $func_error
	}
	return $result
}
#############################################################################
##
proc ::quartus::io::is_global_oe_pin {pin} {
##
##  Arguments:
##      <pin> - Pin name
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		set global_oe [::get_pad_data -pad $pad BOOL_IS_GLOBAL_OE_PAD] 
		set dev_oe [::get_pad_data -pad $pad BOOL_IS_DEV_OE_PAD]
		if {$global_oe == 1 || $dev_oe == 1} {
			set result 1
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_global_oe_pin: $pin" $errorInfo $func_error
	}
	return $result
}
#############################################################################
##
proc ::quartus::io::is_dclk_pin {pin} {
##
##  Arguments:
##      <pin> - Pin name
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		set dclk_pin [::get_pad_data -pad $pad BOOL_IS_DCLK_PAD] 
		set errorInfo $dclk_pin
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_dclk_pin: $pin" $errorInfo $func_error
	}
	return $result
}


#############################################################################
##
proc ::quartus::io::is_ram_io {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function can be used to find our if the pin is a RAM interfacing pin.
##
##  Returns:
##      1  - if the current pin supports RAM interfacing functionality
##	0  - if the current pin does not support RAM interfacing functionality
##	-1 - if there is an error
################################################################################
	set is_ram 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_DQ_PAD} is_ram] {
		set is_ram -1
	}
	return $is_ram
	#[::get_pad_data -pad $pad BOOL_IS_DQS_PAD]
}

#############################################################################
##
proc ::quartus::io::get_io_standards {pin} {
##
##  Arguments:
##      <pin> - Pin name
##
##  Description:
##       Get the list of IO standards supported by a given pin.
##
##  Returns:
##      TCL List - List of IO Standards supported by a given pin.
##	-1       - if there is an error
################################################################################
	set io_standards ""
	set ios_list 0
	set errorInfo ""

	set pad [get_first_pad_of_pinname $pin]

	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad LIST_IO_STANDARDS  } ios_list] {
			set errorInfo $ios_list
		}
	} else {
		set errorInfo "ERROR:"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "get_io_standards: $pin" $errorInfo $func_error
	}
	foreach ios $ios_list {
		set user_ios [get_user_name -io_standard $ios]
		lappend io_standards $user_ios
	}
	return $io_standards
}

###############################################################################
##
proc ::quartus::io::get_vref_pin {pin} {
##
##  Arguments:
##      <pin> - Pin Name
##
##  Description:
##      Each pin is related to a VREF pin. This function returns the pin name of the VREF
##	to which a given pin is related	
##
##  Returns:
##      function name of the related vref pin
################################################################################
	set result ""
	set vref_pad_id 0
	set errorInfo ""
	set vref_name ""
	set vref_pin ""
	set found 0

	if {[is_bonded $pin]} {
		set pad [get_first_pad_of_pinname $pin]
		# get the vref pad associated with $pad
		if [ catch {::get_pad_data -pad $pad INT_VREF_PAD_ID} vref_pad_id] {
			#Some new families have unbonded VREFs, in such cases VREF_PAD_ID is not 
			#available, we should look for POWER BONDED VREF
			if [ catch {::get_pad_data -pad $pad STRING_POWER_BONDED_VREF_NAME} result] {
				set errorInfo $result
			} else {
				set vref_name $result
			}

			#Got VREF function name - we now check all pins to find the pin name of VREF pin
			if [ catch {get_pin_names} pinnames ] {
				set errorInfo $pinnames
			} else {
				foreach tmp_pin $pinnames {
					set funct_names [::quartus::io::get_pin_functions $tmp_pin]
					foreach name $funct_names {
						if [ string equal -nocase $name $vref_name] {
							set found 1
							break
						}
					}
					if {$found == 1} {
						set vref_pin $tmp_pin
						break
					}
				}
			}
		} else {
			if [ catch {::get_pad_data -pad $vref_pad_id INT_PIN_ID} result] {
				set errorInfo $result
			} else {
				set vref_pin [get_pin_location_name $result]
			}
		}
	} else {
		set errorInfo "ERROR"
	}

	if {[string equal "" $vref_pin] == 1} {
		set errorInfo "ERROR"
	}

	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "get_vref_pin: $pin" $errorInfo $func_error
	}

	return $vref_pin
}

#############################################################################
##
proc ::quartus::io::get_vref_name {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the vref pin 
##
##  Description:
##      This function returns the vref name of the pin. A seperate function is
##      is provided to get the vref name of pin because.
##       1. Some VREF pins may not be bonded.
##       2. Some VREF pins may also be usable as general I/O.
##
##  Returns:
##	-1  - on Error
################################################################################
	set vref_name ""
	set funct_names [::quartus::io::get_pin_functions $pin]
	foreach name $funct_names {
		if [ regexp -nocase {^vref} $name] {
			set vref_name $name
			break
		}
	}
	return $vref_name
}

#############################################################################
##
proc ::quartus::io::get_first_pad {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##              
##
##  Description:
##	This function will provide the first pad connected to the pin.
##
##  Returns:
##      Pad Id    - The first pad in the list of pads bonded to this pin.
##	TCL_ERROR - on error
################################################################################
	
	set the_pad ""
	set padlist [::get_pkg_data -pin $pin LIST_PAD_IDS]

	if { [llength $padlist] > 0 } {
		foreach pad $padlist {
			append the_pad "$pad "
		}
	} else {
		set the_pad "No PAD for pin $pin"
	}
	#puts "$pin : PAD ID : $the_pad"
	return $the_pad
}

#############################################################################
##
proc ::quartus::io::get_first_pad_of_pinname {pin_name} {
##
##  Arguments:
##      <pin_name> - Pin Name (STRING_USER_PIN_NAME)
##              
##  Description:
##	This function will provide the first pad connected to the pin.
##
##  Returns:
##      Pad Id    - The first pad in the list of pads bonded to this pin.
##	TCL_ERROR - on error
################################################################################
	
	set the_pad -1
	set padlist [::get_pkg_data -pin_name $pin_name LIST_PAD_IDS]

	if { [llength $padlist] > 0 } {
		foreach pad $padlist {
			set the_pad $pad 
		}
	}
	return $the_pad
}
#############################################################################
##
proc ::quartus::io::get_pad_list {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##              
##
##  Description:
##      Get the pads on the silicon that are connected to this pin. The IO properties
##	Supported by the pin are the properties of the pad it is bonded to. 
##      Generally a pin will be bonded to a single pad, but in some instances a pin
##	can be bonded to multiple pads
##
##  Returns:
##      List of Pad Ids    - List of Pad ids bonded to current pin.
##	TCL_ERROR          - on error
################################################################################
	return [::get_pkg_data LIST_PAD_IDS -pin $pin]
}


#############################################################################
##
proc ::quartus::io::is_dqs_pin {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_DQS_PAD} result] {
			#set errorInfo $result
			set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_dqs_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_dq_pin {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_DQ_PAD} result] {
			#set errorInfo $result
			set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_dq_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_dqvld_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_DQVLD_PAD} result] {
			#set errorInfo $result
			set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_dqvld_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_termination_rup_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_OCTRUP_PAD} result] {
			#set errorInfo $result
			set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_termination_rup_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_termination_rdn_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_OCTRDN_PAD} result] {
			#set errorInfo $result
			set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_termination_rdn_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_vref_pin {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##
##  Returns:
##      1  - if the current pin is VREF
##	0  - if the current pin is not a VREF
##	-1 - if Error occurs
################################################################################
	set errorInfo ""
	set is_vref 0
	set pad [get_first_pad_of_pinname $pin]

	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_VREF_PAD } is_vref] {
			set errorInfo $is_vref
		}
	} else {
		# find out if unbonded pin is vref (power bonded vref pin)
		if [ catch {::get_pkg_data -pin_name $pin BOOL_IS_POWER_BONDED_VREF} pwrbond ] {
			set errorInfo $pwrbond
		} else {
			if { $pwrbond == 1 } {
				set name [::get_pkg_data -pin_name $pin STRING_TYPE_NAME]
				if [ regexp -nocase {^(vref)} $name] {
					set is_vref 1
				}
			}
		}
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_vref_pin: $pin" $errorInfo $func_error
	}
	return $is_vref
}

#############################################################################
##
proc ::quartus::io::is_differential_input_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as INPUT pin 
################################################################################

	set result 0
	set errorInfo ""

	set is_input1 0
	set is_input2 0
	set err_count 0

	if [ catch {is_lvds_input_pin $pin} is_input1] {
		set errorInfo $is_input1
		incr err_count
	} 
	if [ catch {is_transceiver_input_pin $pin} is_input2] {
		set errorInfo $is_input2
		incr err_count
	} 
	if {$is_input1 == 1 || $is_input2 == 1} {
		set result 1
		set errorInfo ""
	} 
	if {$err_count != 2} {
		set errorInfo ""
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_differential_input_pin: $pin" $errorInfo $func_error
	}
	return $result
}
#############################################################################
##
proc ::quartus::io::is_differential_output_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as OUTPUT pin 
################################################################################

	set result 0
	set errorInfo ""

	set is_output1 0
	set is_output2 0
	set err_count 0

	if [ catch {is_lvds_output_pin $pin} is_output1] {
		set errorInfo $is_output1
		incr err_count
	} 
	if [ catch {is_transceiver_output_pin $pin} is_output2] {
		set errorInfo $is_output2
		incr err_count
	} 
	if {$is_output1 == 1 || $is_output2 == 1} {
		set result 1
		set errorInfo ""
	}
	if {$err_count != 2} {
		set errorInfo ""
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_differential_output_pin: $pin" $errorInfo $func_error
	}
	return $result
}
#############################################################################
##
proc ::quartus::io::is_differential_bidir_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as BIDIR pin 
################################################################################
	set result 0
	set errorInfo ""
	set is_bidir1 0
	set is_bidir1 0
	set err_count 0

	if [ catch {is_lvds_bidir_pin $pin} is_bidir1] {
		set errorInfo $is_bidir1
		incr err_count
	} 
	if [ catch {is_transceiver_bidir_pin $pin} is_bidir2] {
		set errorInfo $is_bidir2
		incr err_count
	} 
	if {$is_bidir1 == 1 || $is_bidir2 == 1} {
		set result 1
		set errorInfo ""
	}
	if {$err_count != 2} {
		set errorInfo ""
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_differential_bidir_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_differential_positive_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set lvds_pos 0
	set hssi_pos 0
	set err_count 0

	if [ catch {is_lvds_positive_pin $pin} lvds_pos] {
		set errorInfo $lvds_pos
		incr err_count
	} else {
		if { $lvds_pos == 1} {	
			set result 1
		}
	}
	if [ catch {is_transceiver_positive_pin $pin} hssi_pos] {
		set errorInfo $hssi_pos
		incr err_count
	} else {
		if { $hssi_pos == 1} {	
			set result 1
		}
	}
	if { $result == 1 || $err_count != 2 } {
		set errorInfo ""
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_differential_positive_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_lvds_input_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as INPUT pin 
################################################################################
	set result 0
	set errorInfo ""
	if [ catch {is_lvds_in $pin} is_input] {
		set errorInfo $is_input
	} 
	if [ catch {is_lvds_out $pin} is_output] {
		set errorInfo $is_output
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_lvds_input_pin: $pin" $errorInfo $func_error
	}
	if {$is_input == 1 && $is_output == 0} {
		set result 1
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_lvds_output_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as OUTPUT pin 
################################################################################
	set result 0
	set errorInfo ""
	if [ catch {is_lvds_in $pin} is_input] {
		set errorInfo $is_input
	} 
	if [ catch {is_lvds_out $pin} is_output] {
		set errorInfo $is_output
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_lvds_output_pin: $pin" $errorInfo $func_error
	}
	if {$is_input == 0 && $is_output == 1} {
		set result 1
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_lvds_bidir_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as BIDIR pin 
################################################################################
	set result 0
	set errorInfo ""
	if [ catch {is_lvds_in $pin} is_input] {
		set errorInfo $is_input
	} 
	if [ catch {is_lvds_out $pin} is_output] {
		set errorInfo $is_output
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_lvds_bidir_pin: $pin" $errorInfo $func_error
	}
	if {$is_input == 1 && $is_output == 1} {
		set result 1
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_lvds_in {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_LVDS_INPUT} result] {
			#set errorInfo $result
			set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_lvds_in: $pin" $errorInfo $func_error
	}
	return $result
}
#############################################################################
##
proc ::quartus::io::is_lvds_out {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_LVDS_OUTPUT} result] {
			#set errorInfo $result
			set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_lvds_out: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_lvds_positive_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_LVDS_POSITIVE} result] {
			set errorInfo $result
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_lvds_positive_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_transceiver_input_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as INPUT pin 
################################################################################
	set result 0
	set errorInfo ""
	if [ catch {is_hssi_in $pin} is_input] {
		set errorInfo $is_input
	} 
	if [ catch {is_hssi_out $pin} is_output] {
		set errorInfo $is_output
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_transceiver_input_pin: $pin" $errorInfo $func_error
	}
	if {$is_input == 1 && $is_output == 0} {
		set result 1
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_transceiver_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as a transceiver pin
################################################################################
	set result 0
	set errorInfo ""
	if [ catch {is_hssi_in $pin} is_input] {
		set errorInfo $is_input
	} 
	if [ catch {is_hssi_out $pin} is_output] {
		set errorInfo $is_output
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_transceiver_pin: $pin" $errorInfo $func_error
	} else {
		if { $is_input || $is_output } {
			set result 1
		}
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_transceiver_output_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as OUTPUT pin 
################################################################################
	set result 0
	set errorInfo ""
	if [ catch {is_hssi_in $pin} is_input] {
		set errorInfo $is_input
	} 
	if [ catch {is_hssi_out $pin} is_output] {
		set errorInfo $is_output
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_transceiver_input_pin: $pin" $errorInfo $func_error
	}
	if {$is_input == 0 && $is_output == 1} {
		set result 1
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_transceiver_bidir_pin {pin} {
##
##  Arguments:
##      pin - Pin Name
##              
##
##  Description: 
##
##  Returns: 1 if pin can only be used as BIDIR pin 
################################################################################
	set result 0
	set errorInfo ""
	if [ catch {is_hssi_in $pin} is_input] {
		set errorInfo $is_input
	} 
	if [ catch {is_hssi_out $pin} is_output] {
		set errorInfo $is_output
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_transceiver_bidir_pin: $pin" $errorInfo $func_error
	}
	if {$is_input == 1 && $is_output == 1} {
		set result 1
	}
	return $result
}


#############################################################################
##
proc ::quartus::io::is_hssi_in {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_HSSI_INPUT} result] {
			set errorInfo $result
			#set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_hssi_in: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_hssi_out {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_HSSI_OUTPUT} result] {
			set errorInfo $result
			#set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_hssi_out: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_transceiver_positive_pin {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_HSSI_POSITIVE} result] {
			set errorInfo $result
			#set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_transceiver_positive_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_pll_enable_pin {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_PLL_ENABLE_PAD} result] {
			#set errorInfo $result
			set result 0
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_pll_enable_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_pll_clock_output_pin {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_CLOCKOUT_PAD} result] {
			set errorInfo $result
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_pll_clock_output_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_pll_feedback_pin {pin} {
##
##  Arguments:
##      Pin - Pin Name
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_FEEDBACKIN_PAD} result] {
			set errorInfo $result
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_pll_feedback_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::get_pkg_width {} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	return [::get_pkg_data INT_WIDTH]
}

#############################################################################
##
proc ::quartus::io::get_pkg_length {} {
##
##  Arguments:
##      None 
##              
##
##  Description:
##
##  Returns:
################################################################################
	return [::get_pkg_data INT_LENGTH]
}


#############################################################################
##
proc ::quartus::io::has_bus_hold {pin} {
##
##  Arguments:
##     Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_bus_hold_missing 0
	set bus_hold 1
	set pad [get_first_pad_of_pinname $pin]

	if [catch {::get_pad_data -pad $pad BOOL_IS_BUS_HOLD_MISSING} is_bus_hold_missing] {
		set is_bus_hold_missing -1
	}
	if {$is_bus_hold_missing == -1} {
		set bus_hold -1
	} elseif {$is_bus_hold_missing == 1} {
		set bus_hold 0
	}
	return $bus_hold
}

#############################################################################
##
proc ::quartus::io::has_weak_pullup {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_weak_pullup_missing 0
	set weak_pullup 0
	set errorInfo ""

	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [catch {::get_pad_data -pad $pad BOOL_IS_WEAK_PULLUP_MISSING} is_weak_pullup_missing] {
			set errorInfo $is_weak_pullup_missing 
		}
	} else {
		set errorInfo "ERROR"
	}

	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		set func_name "has_weak_pullup: $pin"
		print_error_message $func_name $errorInfo $func_error
	}
	if {$is_weak_pullup_missing == 1} {
		set weak_pullup 0
	} elseif {$is_weak_pullup_missing == 0} {
		set weak_pullup 1
	}
	return $weak_pullup
}

#############################################################################
##
proc ::quartus::io::has_open_drain {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_open_drain_missing 0
	set open_drain 0
	set errorInfo ""

	set pad [get_first_pad_of_pinname $pin]
	set old_family [is_family_pre_iii_gen]

	if {$pad != -1} {
		if { $old_family != 1 } {
			if [catch {::get_pad_data -pad $pad BOOL_IS_OPEN_DRAIN_MISSING} is_open_drain_missing] {
				set is_open_drain_missing 0
			}
		}
	} else {
		set errorInfo "ERROR"
	}

	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		set func_name "has_open_drain: $pin"
		print_error_message $func_name $errorInfo $func_error
	}
	if {$is_open_drain_missing == 1} {
		set open_drain 0
	} elseif {$is_open_drain_missing == 0} {
		set open_drain 1
	}
	return $open_drain
}


#############################################################################
##
proc ::quartus::io::io_standard_supports_open_drain {iostd} {
##
##  Arguments:
##      io_standard - Name of IO Standard 
##              
##
##  Description:
##
##  Returns:
##      1 if IO Standard is compatible with open_drain, false otherwise
################################################################################
	set result 0
	set errorInfo ""
	
	set old_family [is_family_pre_iii_gen]
	if {$old_family != 1} {
		if [catch {::get_pad_data -io_standard $iostd BOOL_IS_OPEN_DRAIN_MISSING} result] {
			set result 0
		}
	}
	
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The IO Standard specified is not valid"
		set func_name "io_standard_supports_open_drain: $iostd"
		print_error_message $func_name $errorInfo $func_error
	}
	if {$result == 0 } {
		set open_drain 1
	} else {
		set open_drain 0
	}

	return $open_drain
}

#############################################################################
##
proc ::quartus::io::io_standard_supports_bus_hold {iostd} {
##
##  Arguments:
##      iostd - Name of IO Standard 
##              
##
##  Description:
##
##  Returns:
##      1 if IO Standard supports bus_hold, 0 otherwise
################################################################################
	set result 0
	set errorInfo ""
	
	set old_family [is_family_pre_iii_gen]
	if {$old_family != 1} {
		if [catch {::get_pad_data -io_standard $iostd BOOL_IS_BUS_HOLD_MISSING} result] {
			set result 0
		}
	}
	
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The IO Standard specified is not valid"
		set func_name "io_standard_supports_bus_hold: $iostd"
		print_error_message $func_name $errorInfo $func_error
	}
	if {$result == 0 } {
		set bus_hold 1
	} else {
		set bus_hold 0
	}

	return $bus_hold
}

#############################################################################
##
proc ::quartus::io::io_standard_supports_weak_pullup {iostd} {
##
##  Arguments:
##      iostd - Name of IO Standard 
##              
##
##  Description:
##
##  Returns:
##      1 if IO Standard supports weak pullup, 0 otherwise
################################################################################
	set result 0
	set errorInfo ""
	
	set old_family [is_family_pre_iii_gen]
	if {$old_family != 1} {
		if [catch {::get_pad_data -io_standard $iostd BOOL_IS_WEAK_PULLUP_MISSING} result] {
			set result 0
		}
	}
	
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The IO Standard specified is not valid"
		set func_name "io_standard_supports_weak_pullup: $iostd"
		print_error_message $func_name $errorInfo $func_error
	}
	if {$result == 0 } {
		set weak_pullup 1
	} else {
		set weak_pullup 0
	}

	return $weak_pullup
}

#############################################################################
##
proc ::quartus::io::get_max_outputs_per_vref_bank {} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##      
#############################################################################
	set errorInfo ""
	if [ catch {::get_pkg_data INT_MAX_OUTPUT_COUNT_PER_VREF_BANK} result] {
		set errorInfo $result
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		set func_name "get_max_outputs_per_vref_bank"
		print_error_message $func_name $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::get_operation_modes {pin io_standard} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      
#############################################################################
	set op_mode 0
	set errorInfo ""
	set bonded [is_bonded $pin]
	set supported [pin_supports_io_standard $pin $io_standard]
	set input_only 0
	set output_only 0

	if {$bonded == 1 && $supported == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if {$pad != -1} {
			if [catch {::get_pad_data -io_standard $io_standard BOOL_INPUT_OPERATION_ONLY} input_only] {
				set errorInfo ""
					# this IOStandard is not INPUT_ONLY
				set input_only 0 
			}
			if [catch {::get_pad_data -io_standard $io_standard BOOL_OUTPUT_OPERATION_ONLY} output_only] {
				set errorInfo ""
					# this IOStandard is not OUTPUT_ONLY
				set output_only 0
			}
		}
	} else {
		set errorInfo "ERROR:"
	}

	if {[string equal "" $errorInfo] == 1} {
		if {$input_only == 1 && $output_only == 0} {
			set op_mode "INPUT"
		} elseif {$input_only == 0 && $output_only == 1} {
			set op_mode "OUTPUT"
		} else {
			set op_mode "BIDIR"
		}
	} else {	
		set func_error "The property is not valid for the current pin"
		print_error_message "get_operation_modes: $pin $io_standard" $errorInfo $func_error
	}
				
	return $op_mode
}

#############################################################################
##
proc ::quartus::io::get_voltage {iostandard} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      
#############################################################################
	set voltage 0
	set vio_voltage 0
	set vtg_list {}
	set errorInfo ""

	if [catch {::get_pad_data -io_standard $iostandard INT_VOLTAGE_TYPE} voltage] {
		set errorInfo $voltage 
		set voltage 0
	}
	if [catch {::get_pad_data -io_standard $iostandard INT_VIO_VOLTAGE_TYPE} vio_voltage] {
		if {$voltage == 0} { # set errorInfo only if both voltage and vio_voltage
									# couldn't be read
			set errorInfo $vio_voltage 
		}
		set vio_voltage 0
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The IO Standard specified is not valid"
		print_error_message "get_voltage $iostandard" $errorInfo $func_error
	}
	regsub {([0-9])_([0-9])_(.*)} $voltage {\1.\2 \3} voltage
	lappend vtg_list $voltage

	if {$vio_voltage != 0} {
		regsub {([0-9])_([0-9])_(.*)} $vio_voltage {\1.\2 \3} vio_voltage
		if {[string equal $vio_voltage $voltage] == 0} {
			lappend vtg_list $vio_voltage
		}
	}
	return $vtg_list
}
#############################################################################
##
proc ::quartus::io::get_voltage_of_pin {pin_name iostandard} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      
#############################################################################
	set hio_voltage 0
	set vio_voltage 0
	set errorInfo ""
	set voltage {}

	catch {is_row_io_pin $pin_name} is_row
	catch {is_column_io_pin $pin_name} is_col
	
	if [catch {::get_pad_data -io_standard $iostandard INT_VOLTAGE_TYPE} hio_voltage] {
		set errorInfo $hio_voltage 
		set hio_voltage 0
	}
	if [catch {::get_pad_data -io_standard $iostandard INT_VIO_VOLTAGE_TYPE} vio_voltage] {
		set errorInfo $vio_voltage 
		set vio_voltage 0
	}
	if { $is_row == 1 && $hio_voltage != 0} {
		lappend voltage $hio_voltage
		set errorInfo ""
	} elseif { $is_col == 1 && $vio_voltage != 0} {
		lappend voltage $vio_voltage
		set errorInfo ""
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The IO Standard specified is not valid"
		set func_name "get_voltage_of_pin $pin_name $iostandard" 
		print_error_message $func_name $errorInfo $func_error
	}
	regsub {([0-9])_([0-9])_(.*)} $voltage {\1.\2 \3} voltage

	return $voltage
}
#############################################################################
##
proc ::quartus::io::get_drive_strength {pin io_standard} {
##
##  Arguments:
##      <io_standard> - IO Standard
##
##  Description:
##      This function is used to find out the drive_strengths supported by 
##      a given IO Standard.
##
##  Returns:
##      TCL List - drive strengths (with Units) for a given IO standard.
##	-1       - on Error
################################################################################
	set drive_levels 0
	set is_supported 0
	set errorInfo ""
	set current_list {}

	if [ catch {::get_pkg_data -pin_name $pin BOOL_IS_BONDED} bonded ] {
		set errorInfo $bonded
	}

	if {$bonded == 1} {
		set internal_iostd_name [get_internal_io_standard_name $pin $io_standard]
		if {$internal_iostd_name != 0} {
			if [ catch {::get_pad_data LIST_CURRENT_SET -io_standard $internal_iostd_name} drive_levels] {
				set errorInfo $io_standard
			} else {
				set drv_list [ split $drive_levels " " ]
				foreach drv $drv_list {
					set x1 [string equal "MIN_MA" $drv]
					set x2 [string equal "MAX_MA" $drv]
					if [expr ($x1 == 0 && $x2 == 0)] {
						lappend current_list $drv
					}
				}
			}
		}
	}

	if { [llength $current_list] == 0 } {
        lappend current_list ""
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		set func_name "get_drive_strength: $pin $io_standard"
		print_error_message $func_name $errorInfo $func_error
	}
	return $current_list
}

#############################################################################
##
proc ::quartus::io::get_pad_data_by_pin_name { pin_name data } {
##
##  Arguments:
##      pin_name - The pin name
##      data     - The data key
##
################################################################################
	set result 0

	set pad_id [get_first_pad_of_pinname $pin_name]
	if { $pad_id != -1 } {
		catch { ::get_pad_data -pad $pad_id $data } result
	}

	return $result
}

#############################################################################
##
proc ::quartus::io::get_pad_data_by_pad_id { pad_id data } {
##
##  Arguments:
##      pad_id - The pad ID
##      data   - The data key
##
################################################################################

	if { [catch { ::get_pad_data -pad $pad_id $data } result] } {
		return 0
	}

	return $result
}

#############################################################################
##
proc ::quartus::io::get_pad_data_by_io_standard { io_standard data } {
##
##  Arguments:
##      io_standard - The I/O standard
##      data   - The data key
##
################################################################################

	if { [catch { ::get_pad_data -io_standard $io_standard $data } result] } {
		return 0
	}

	return $result
}

#############################################################################
##
proc ::quartus::io::is_jtag_tck_pin {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_JTAG_TCK} result] {
			set errorInfo $result
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_jtag_tck_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_jtag_tms_pin {pin} {
##
##  Arguments:
##      <pin> - Pin name
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_JTAG_TMS} result] {
			set errorInfo $result
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_jtag_tms: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_jtag_trst_pin {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_JTAG_NTRST} result] {
			set errorInfo $result
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_jtag_trst_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_jtag_tdi_pin {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_JTAG_TDI} result] {
			set errorInfo $result
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_jtag_tdi_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_jtag_tdo_pin {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad BOOL_IS_JTAG_TDO} result] {
			set errorInfo $result
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_jtag_tdo_pin: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::get_dqs_complement_pin {pin} {
##
##  Arguments:
##      Pin - Pin location name
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result ""
	set comp_pad 0
	set errorInfo ""
	set dqs_pin [ is_dqs_pin $pin ]
	set dqsb_pin [ is_dqsb_pin $pin ]

	if { $dqs_pin == 1 || $dqsb_pin == 1 } {
		if [ catch {::get_pad_data -pad $pad INT_DQS_COMPLEMENT_PAD_ID} comp_pad] {
			set errorInfo $comp_pad
		}
	} else {
		set errorInfo "ERROR: Not a dqs pin"
	}
	if {[string equal "" $errorInfo] == 1} {
		# get the pin name associated with the comp pad
		if [ catch {::get_pad_data -pad $comp_pad INT_PIN_ID} result] {
			set errorInfo $result
		} else {
			if {$result == -1} {
				set errorInfo "ERROR"
			}
		}
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "get_dqs_complement_pin: $pin" $errorInfo $func_error
	}
	set result [get_pin_location_name $result]
	return $result
}
#############################################################################
##
proc ::quartus::io::get_differential_complement_pin {pin} {
##
##  Arguments:
##      Pin - Pin location name 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set result ""
	set comp_pad 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad INT_LVDS_COMPLEMENT_PAD_ID} comp_pad] {
			set errorInfo $comp_pad
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 1} {
		# get the pin name associated with the comp pad
		if [ catch {::get_pad_data -pad $comp_pad INT_PIN_ID} result] {
			set errorInfo $result
		} else {
			if {$result == -1} {
				set errorInfo "ERROR"
			}
		}
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "get_differential_complement_pin: $pin" $errorInfo $func_error
	}
	set result [get_pin_location_name $result]
	return $result
}


#############################################################################
##
proc ::quartus::io::get_output_to_vref_distance {} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      
#############################################################################
	set return_val ""
	set errorInfo ""

	if [ catch {::get_pad_data INT_OUTPUT_TO_VREF_DISTANCE_IN_PADS} return_val] {
		set errorInfo $return_val
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The IO Rule does not apply for the current device"
		print_error_message "get_output_to_vref_distance" $errorInfo $func_error
	}
	
	return "$return_val PAD"
}

#############################################################################
##
proc ::quartus::io::get_output_to_dclk_distance {} {
##
##  Arguments: Nothing
##
##  Description:  This is currently (10/2007) only applicable to select 
##						packages for CIII.  For most devices this will be 
##						NOT_APPLICABLE
##
##  Returns: Distance in # of PADs or NOT_APPLICABLE
##      
#############################################################################
	set return_val ""
	set errorInfo ""

	if [ catch {::get_pkg_data INT_SE_OUTPUT_TO_DCLK_DISTANCE} return_val] {
		set errorInfo $return_val
	} 
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The IO Rule does not apply for the current device"
		print_error_message "get_output_to_dclk_distance" $errorInfo $func_error
	}
	
	return "$return_val PAD"
}


#############################################################################
##
proc ::quartus::io::has_pci_clamp_diode {pin} {
##
##  Arguments:
##	pin - pin_id
##
##  Description:
##
##  Returns:
##      
#############################################################################
	set result 0
	set errorInfo ""
	set pad [get_first_pad_of_pinname $pin]
	variable current_family
	set old_family [is_family_pre_iii_gen]

	if {$pad != -1} {
		if {$old_family == 1} {
			# old family
			if [ catch { get_io_standards $pin } iostd_list ] {
				set errorInfo $iostd_list
			} else {
				if [ regexp -nocase (PCI) $iostd_list ] {
					set result 1
				} else {
					set result 0
				}
			}
			
		} else {
			# new family
			if [ catch {::get_pad_data -pad $pad BOOL_HAS_PCI_CLAMP_DIODE} result] {
				set errorInfo $result
			}
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "has_pci_clamp_diode: $pin" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::get_min_single_ended_to_differential_distance {} {
##
##  Arguments:
##
##  Description:
##
##  Returns:
##      
#############################################################################

	set errorInfo ""
	if [ catch {::get_pkg_data INT_INPUT_TO_DIFERENTIAL_PAD_DISTANCE} intodiffl] {
		set errorInfo $intodiffl
	} 
	if [ catch {::get_pkg_data INT_OUTPUT_TO_DIFERENTIAL_PAD_DISTANCE} outtodiffl] {
		set errorInfo $outtodiffl
	} 
	if {[string equal "" $errorInfo] == 1} {
		[ catch {::get_pad_data BOOL_LVDS_DISTANCE_RULE_IS_LAB_ROW_BASED} x1 ]
		[ catch {::get_pad_data BOOL_LVDS_DISTANCE_RULE_IS_HC_ROW_COL_BASED} x2 ]
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The I/O Rule does not apply for the current device"
		print_error_message "get_min_single_ended_to_differential_distance" $errorInfo $func_error
	}

	if { $x1 == 1 || $x2 == 1 } {
		lappend intodiffl "LAB"
		lappend outtodiffl "LAB"
	} else {
		lappend intodiffl "PAD"
		lappend outtodiffl "PAD"
	}
	return "$intodiffl $outtodiffl"
}

#############################################################################
##
proc ::quartus::io::is_single_inputs_allowed_when_dpa_enabled {} {
##
##  Arguments:
##
##  Description:
##
##  Returns:
##      
#############################################################################

	set allowed 0
	set errorInfo ""
	if [ catch {::get_pad_data BOOL_SINGLE_ENDED_INPUTS_ALLOWED_IN_DPA_BANKS} allowed] {
		set errorInfo $allowed
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The I/O Rule does not apply for the current device"
		print_error_message "is_single_inputs_allowed_when_dpa_enabled" $errorInfo $func_error
	}
	return $allowed
}
#############################################################################
##
proc ::quartus::io::is_single_outputs_allowed_when_dpa_enabled {} {
##
##  Arguments:
##
##  Description:
##
##  Returns:
##      
#############################################################################

	set allowed 0
	set errorInfo ""
	if [ catch {::get_pad_data BOOL_SINGLE_ENDED_OUTPUTS_ALLOWED_IN_DPA_BANKS} allowed] {
		set errorInfo $allowed
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The I/O Rule does not apply for the current device"
		print_error_message "is_single_outputs_allowed_when_dpa_enabled" $errorInfo $func_error
	}
	return $allowed
}

#############################################################################
##
proc ::quartus::io::is_single_io_allowed_with_differential_io_in_pll_output_bank {} {
##
##  Arguments:
##
##  Description:
##
##  Returns:
##      
#############################################################################

	## CHECK IMPL (this key checks se/diffl iostds)
	set allowed 1
	set not_allowed 0
	set errorInfo ""
	if [ catch {::get_pad_data BOOL_CANT_MIX_DIFF_AND_SE_IOSTDS_IN_PLL_OUTPUT_IOBANKS} not_allowed ] {
		set errorInfo $not_allowed
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The I/O Rule does not apply for the current device"
		print_error_message "is_single_io_allowed_with_differential_io_in_pll_output_bank" $errorInfo $func_error
	}
	if {$not_allowed == 1} {
		$allowed = 0
	} 
	return $allowed
}
#############################################################################
##
proc ::quartus::io::get_row_dc_current_limits {} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      {MAX HIO_Count MAX_HIO_Current} 
#############################################################################

	set return_val ""
	set errorInfo ""
	if [catch {::get_pad_data INT_MAX_CURRENT_OF_CONSECUTIVE_PADS} max_hio_current ] {
		set errorinfo $max_hio_current
	}
	if [catch {::get_pad_data INT_CONSECUTIVE_OUTPUT_COUNT} max_hio_count ] {
		set errorInfo $max_hio_count
	}
	if {[string match "" $errorInfo] == 0} {
		set func_error "The I/O Rule does not apply for the current device"
		print_error_message "get_row_dc_current_limits" $errorInfo $func_error
	}
	set return_val [list $max_hio_count $max_hio_current]
	return $return_val
}


#############################################################################
##
proc ::quartus::io::get_column_dc_current_limits {} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      {MAX_VIO_Count MAX_VIO_Current}
#############################################################################

	set return_val ""
	set errorInfo ""
	if [catch {::get_pad_data INT_MAX_CURRENT_OF_CONSECUTIVE_VIO_PADS} max_vio_current ] {
		set errorInfo $max_vio_current
	}
	if [catch {::get_pad_data INT_CONSECUTIVE_VIO_OUTPUT_COUNT} max_vio_count ] {
		set errorInfo $max_vio_count
	}
	if {[string match "" $errorInfo] == 0} {
		# Couldn't get Column values. In this case, it is the same as 
		# the Row values for current_limits

		if  [ catch {get_row_dc_current_limits} hio_vals ] {
			set errorInfo $hio_vals
			set func_error "The I/O Rule does not apply for the current device"
			print_error_message "get_column_dc_current_limits" $errorInfo $func_error
		} else {
			set return_val $hio_vals
		}
	} else {
		set return_val [list $max_vio_count $max_vio_current]
	}
	return $return_val
}

#############################################################################
##
proc ::quartus::io::get_distance_in_pads {pin_name1 pin_name2} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      distance between the two pins
#############################################################################

	set errorInfo ""
	set pad1 [get_first_pad_of_pinname $pin_name1]
	set pad2 [get_first_pad_of_pinname $pin_name2]

	if { $pad1 == -1 || $pad2 == -1 } {
		set func_error "The I/O Rule does not apply for the current device"
		set errorInfo "ERROR"
		print_error_message "get_distance_in_pads: $pin_name1 $pin_name2" $errorInfo $func_error
	} else {
		set dist [expr abs($pad1 - $pad2)]
	}

	return $dist
}
#############################################################################
##
proc ::quartus::io::get_distance_in_labs {pin_name1 pin_name2} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      distance between the two pins in LABs.  
##			-1 if this distance is not defined
#############################################################################

	
	set dist -1
	set errorInfo ""

	if [ catch {get_pad_coordinates $pin_name1} pin1_coords ] {
		set errorInfo $pin1_coords
	}
	if [ catch {get_pad_coordinates $pin_name2} pin2_coords ] {
		set errorInfo $pin2_coords
	}
	
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The I/O Rule does not apply for the current device"
		set func_name "get_distance_in_labs: $pin_name1 $pin_name2"
		print_error_message $func_name $errorInfo $func_error
	}

	set x1 [lindex $pin1_coords 0]
	set y1 [lindex $pin1_coords 1]
	set x2 [lindex $pin2_coords 0]
	set y2 [lindex $pin2_coords 1]

	if {$x1 == $x2} {
		set dist [expr abs($y1 - $y2)]
	} elseif {$y1 == $y2} {
		set dist [expr abs($x1 - $x2)]
	} else {
		set dist -1
	}

	return $dist
}
#############################################################################
##
proc ::quartus::io::get_pad_number_of_pin {pin_name} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      pad id of the pin
#############################################################################

	set pad 0
	set errorInfo ""

	if {[is_bonded $pin_name]} {
		set pad [get_first_pad_of_pinname $pin_name]
	} else {
		set errorInfo "ERROR:"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		set func_name "get_pad_number_of_pin: $pin_name"
		print_error_message $func_name $errorInfo $func_error
	}
	
	return $pad
}
#############################################################################
##
proc ::quartus::io::get_pad_coordinates {pin_name} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##       The X and Y co ordinates of the pin_name
#############################################################################

	set coords ""
	set x 0
	set y 0
	set errorInfo ""

	set pad [get_first_pad_of_pinname $pin_name]
	if {$pad != -1} {
		if [ catch {::get_pad_data -pad $pad INT_LOC_X} x ] {
			set errorInfo $x
		} 
		
		if [ catch {::get_pad_data -pad $pad INT_LOC_Y} y ] {
			set errorInfo $y
		}
	} else {
		set errorInfo "ERROR:"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		set func_name "get_pad_coordinates: $pin_name"
		print_error_message $func_name $errorInfo $func_error
	} else {
		set coords [list $x $y]
	}
	
	return $coords
}

#############################################################################
##
proc ::quartus::io::get_pin_names {} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      list of valid pin names in this device
#############################################################################

	set total_pins [get_pin_count]
	set pin_list ""
	
	for { set pin 0 } { $pin < $total_pins } { incr pin } {
		set pin_name [get_pkg_data STRING_USER_PIN_NAME -pin $pin]
		lappend pin_list $pin_name
	}
	return $pin_list
}

#############################################################################
##
proc ::quartus::io::is_bonded {pin} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      1 if pin is bonded : 0 otherwise
#############################################################################

	set errorInfo ""
	if [ catch {::get_pkg_data -pin_name $pin BOOL_IS_BONDED} bonded ] {
		set errorInfo $bonded
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_bonded: $pin" $errorInfo $func_error
	}
	return $bonded
}

#############################################################################
##
proc ::quartus::io::is_row_io_pin {pin} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##      1 if pin is row I/O : 0 otherwise
#############################################################################

	set errorInfo ""
	set is_row 0

	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if { [::get_pad_data -pad $pad BOOL_IS_LEFT] ||
			[::get_pad_data -pad $pad BOOL_IS_RIGHT]} {
			set is_row 1
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_row_io_pin: $pin" $errorInfo $func_error
	}
	return $is_row
}

#############################################################################
##
proc ::quartus::io::is_left_io_pin {pin} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##      1 if pin is row I/O : 0 otherwise
#############################################################################

	set errorInfo ""
	set is_left 0
	if { [::get_pkg_data -pin_name $pin BOOL_IS_BONDED] } {
		set pad [get_first_pad_of_pinname $pin]
		if { [::get_pad_data -pad $pad BOOL_IS_LEFT] } {
			set is_left 1
		} else {
			set is_left 0
		}
	}
	return $is_left
}

#############################################################################
##
proc ::quartus::io::is_right_io_pin {pin} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##      1 if pin is row I/O : 0 otherwise
#############################################################################

	set errorInfo ""
	set is_right 0
	if { [::get_pkg_data -pin_name $pin BOOL_IS_BONDED] } {
		set pad [get_first_pad_of_pinname $pin]
		if { [::get_pad_data -pad $pad BOOL_IS_RIGHT]} {
			set is_right 1
		} else {
			set is_right 0
		}
	}
	return $is_right
}

#############################################################################
##
proc ::quartus::io::is_column_io_pin {pin} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##      1 if pin is column I/O : 0 otherwise
#############################################################################

	set errorInfo ""
	set is_col 0
	if {[is_bonded $pin] == 1} {
		set pad [get_first_pad_of_pinname $pin]
		if { [::get_pad_data -pad $pad BOOL_IS_TOP] ||
			[::get_pad_data -pad $pad BOOL_IS_BOTTOM]} {
			set is_col 1
		}
	} else {
		set errorInfo "ERROR"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "is_col_io_pin: $pin" $errorInfo $func_error
	}
	return $is_col
}

#############################################################################
##
proc ::quartus::io::is_bottom_io_pin {pin} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##      1 if pin is column I/O : 0 otherwise
#############################################################################

	set errorInfo ""
	set is_bottom 0
	if { [::get_pkg_data -pin_name $pin BOOL_IS_BONDED] } {
		set pad [get_first_pad_of_pinname $pin]
		if { [::get_pad_data -pad $pad BOOL_IS_BOTTOM]} {
			set is_bottom 1
		} else {
			set is_bottom 0
		}
	}
	return $is_bottom
}

#############################################################################
##
proc ::quartus::io::is_top_io_pin {pin} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##      1 if pin is column I/O : 0 otherwise
#############################################################################

	set errorInfo ""
	set is_top 0
	if { [::get_pkg_data -pin_name $pin BOOL_IS_BONDED] } {
		set pad [get_first_pad_of_pinname $pin]
		if { [::get_pad_data -pad $pad BOOL_IS_TOP] } {
			set is_top 1
		} else {
			set is_top 0
		}
	}
	return $is_top
}

#############################################################################
##
proc ::quartus::io::has_series_termination {pin ios term_value} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##
#############################################################################

	set errorInfo ""
	set bonded [is_bonded $pin]
	set supported [pin_supports_io_standard $pin $ios]
	set result 0

	if { $bonded && $supported } {
		set pad [get_first_pad_of_pinname $pin]
		if {$term_value == 25} {
		 	if [catch {::get_pad_data -pad $pad BOOL_IS_OCT_RS_25_OHM_PAD} result] {
				set errorInfo $result
			}
		} elseif {$term_value == 50} {
		 	if [catch {::get_pad_data -pad $pad BOOL_IS_OCT_RS_50_OHM_PAD} result] {
				set errorInfo $result
			}
		} else {
			set errorInfo "ERROR:"
		}
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "has_series_termination: $pin $ios $term_value" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::has_series_termination_with_calibration {pin ios} {
##
##  Arguments:
##     
##  Description:
##
##  Returns: 1 if this pin has series termination with calibration
##
#############################################################################

	set errorInfo ""
	set bonded [is_bonded $pin]
	set supported [pin_supports_io_standard $pin $ios]
	set result 0
	set is_top_bottom 0
	variable current_family
	
	if { $bonded && $supported } {
		set calib_support [::quartus::io::family_supports_calibration $current_family]
		if {$calib_support == 1} {	# No calibration
			set result 0
		} elseif {$calib_support == 2} {	# calibration on all pins
			set result 1
		} elseif { $calib_support == 3} { # calibraiton on top or bottom pins only
			if [catch {is_column_io_pin $pin} is_top_bottom] {
				set errorInfo $is_top_bottom
			} else {
				if {$is_top_bottom == 1} {
					set result 1
				} else {
					set result 0
				}
			}
		} else {
			set errorInfo "ERROR"
		}
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "has_series_termination_with_calibration: $pin $ios" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::has_parallel_termination {pin ios} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##
#############################################################################

	set errorInfo ""
	set bonded [is_bonded $pin]
	set supported [pin_supports_io_standard $pin $ios]
	set result 0

	if { $bonded && $supported } {
		set pad [get_first_pad_of_pinname $pin]
		 if [catch {::get_pad_data -pad $pad BOOL_IS_OCT_RT_PAD} result] {
				set errorInfo $result
		}
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "has_parallel_termination: $pin $ios" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::has_differential_termination {pin ios} {
##
##  Arguments:
##     
##  Description:
##
##  Returns:
##
#############################################################################

	set errorInfo ""
	set bonded [is_bonded $pin]
	set supported [pin_supports_io_standard $pin $ios]
	set result 0

	if { $bonded && $supported } {
		set pad [get_first_pad_of_pinname $pin]
		 if [catch {::get_pad_data -pad $pad BOOL_IS_OCT_RD_PAD} result] {
				set errorInfo $result
		}
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "has_differential_termination: $pin $ios" $errorInfo $func_error
	}
	return $result
}

#############################################################################
##
proc ::quartus::io::is_sso_limit_vref_bank_based {} {
##
##  Arguments: Simultaneously Switching Outputs # is vref bank based 
##					and not power pin pair based
##     
##  Description:
##
##  Returns:
##
#############################################################################
	set errorInfo ""
	if [catch {::get_pad_data BOOL_VREF_SSO_CHECK_PER_POWER_PIN_PAIR} result] {
		set errorInfo $result
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The I/O Rules does not apply for the current device"
		set func_name "is_sso_limit_vref_bank_based"
		print_error_message $func_name $errorInfo $func_error
	}
	if {$result == 1} {
		set vrefbased 0
	} else {
		set vrefbased 1
	}
	return $vrefbased
}


#############################################################################
##
proc ::quartus::io::get_dq_group {input_pin dq_group_width} {
##
##  Arguments: input_pin: Pin location Name of the DQS pin or DQ pin whose
##								group we want to find
##			dq_group_width: int representing width of the group we want to find
##     
##  Description:
##					Find all the DQ pins sharing the same Data Strobe
##				   in the dq_group_width pin group
## 				Currently dq_group_width can be 4,8,9, 16,18 or 32,36
##
##  Returns:
##
#############################################################################
	set errorInfo ""
	set dq_group_list {}
	set is_dqs 0
	set is_dq 0
	set dqs_pad ""
	set dqs_pin ""

	# Setup the key we're going to look for
	switch $dq_group_width {
		4 { set thekey "INT_CORRESPONDING_X4_DQS_PAD_ID" }
		8 { set thekey "INT_CORRESPONDING_X8_DQS_PAD_ID" }
		9 { set thekey "INT_CORRESPONDING_X9_DQS_PAD_ID" }
		16 { set thekey "INT_CORRESPONDING_X16_DQS_PAD_ID" }
		18 { set thekey "INT_CORRESPONDING_X18_DQS_PAD_ID" }
		32 { set thekey "INT_CORRESPONDING_X32_DQS_PAD_ID" }
		36 { set thekey "INT_CORRESPONDING_X36_DQS_PAD_ID" }
	default { set errorInfo "Not a valid number" }
	}

	puts "PIN NAME: $input_pin"
	# Check if the input pin is a DQS pin
	if [ catch {is_dqs_pin $input_pin} is_dqs ] {
		set errorInfo $is_dqs
	} else {
		#puts "IS DQS: $is_dqs"
		if { $is_dqs == 0 } {
			# Not a DQS pin - maybe a DQ?
			if [ catch {is_dq_pin $input_pin} is_dq ] {
				set errorInfo $is_dq
			} else {
				if { $is_dq == 1 } {
					if [ catch {get_pkg_data -pin_name $input_pin $thekey } corr_dqs_pad ] {
						#puts "Couldn't find corresponding DQS PAD $corr_dqs_pad"
						set errorInfo $corr_dqs_pad
					} else {
						set dqs_pad $corr_dqs_pad
						set dqs_pin [get_pad_data -pad $dqs_pad STRING_USER_PIN_NAME]
						#puts "DQS PAD: $dqs_pad"
						#puts "DQS PIN: $dqs_pin"
					}
				}
			}
		} else { # this is a dqs pin
			set dqs_pin $input_pin
			set dqs_pad [ get_pad_number_of_pin $input_pin ]
			#puts "DQS PAD: $dqs_pad"
			#puts "DQS PIN: $dqs_pin"
		}
	}

	if {$is_dqs == 1 || $is_dq == 1} {
		# reset this since we have a good starting point
		set errorInfo ""	
		set pinlist [ get_pin_names ]
		foreach pin $pinlist {
			if [ catch {get_pkg_data -pin_name $pin $thekey} is_in_dq ] {
				# ok for thekey not to be defined for $pin
			} else {
				if {$is_in_dq == $dqs_pad} {
					lappend dq_group_list $pin
				}
			}
		}
		lappend dq_group_list $dqs_pin
		if [ catch {get_dqs_complement_pin $dqs_pin} dqsb_pin ] {
			# No DQSB pin defined.
		} else {
			lappend dq_group_list $dqsb_pin
		}
	} else {
		set errorInfo "$input_pin is not a valid DQ or DQS pin"
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "get_dq_group: $dqs_pin $dq_group_width" $errorInfo $func_error
	}
	return $dq_group_list
}

#############################################################################
##
proc ::quartus::io::get_all_dq_groups {dq_group_width} {
##
##  Arguments: 
##			dq_group_width: int representing width of the group we want to find
##     
##  Description:
##					Find all the DQ groups sharing the same DQS pin
## 				Currently dq_group_width can be 4,8,9, 16,18 or 32,36
##
##  Returns: A list containing {{dqs_pin} {dq_pin_group}}
##
#############################################################################
	set errorInfo ""
	array set dq_group_ary {}
	set dqs_pad ""
	set dqs_pin ""
	set dq_groups_list {}

	# Setup the key we're going to look for
	switch $dq_group_width {
		4 { set thekey "INT_CORRESPONDING_X4_DQS_PAD_ID" }
		8 { set thekey "INT_CORRESPONDING_X8_DQS_PAD_ID" }
		9 { set thekey "INT_CORRESPONDING_X9_DQS_PAD_ID" }
		16 { set thekey "INT_CORRESPONDING_X16_DQS_PAD_ID" }
		18 { set thekey "INT_CORRESPONDING_X18_DQS_PAD_ID" }
		32 { set thekey "INT_CORRESPONDING_X32_DQS_PAD_ID" }
		36 { set thekey "INT_CORRESPONDING_X36_DQS_PAD_ID" }
	default { set errorInfo "Not a valid number" }
	}

	set pinlist [ get_pin_names ]
	foreach pin $pinlist {
		if [ catch {get_pkg_data -pin_name $pin $thekey} is_in_dq ] {
			# ok for thekey not to be defined for $pin
		} else {
			if {$is_in_dq != -1 } {
				lappend dq_group_ary($is_in_dq) $pin
			}
		}
	}
	if {[string equal "" $errorInfo] == 0} {
		set func_error "The property is not valid for the current pin"
		print_error_message "get_all_dq_groups: $dq_group_width" $errorInfo $func_error
	}
	foreach {dqs_pad dq_group} [ array get dq_group_ary ] {
		set dqs_pin [get_pad_data -pad $dqs_pad STRING_USER_PIN_NAME]
		#puts "$dqs_pin: $dq_group"
		lappend dq_groups_list $dqs_pin
		lappend dq_groups_list $dq_group
	}
	return $dq_groups_list
}

#############################################################################
##
proc ::quartus::io::get_slew_rates { io_standard } {
##
##  Arguments: io_std : IO Standard for which we want to get slew rates
##     
##  Description: 
##
##  Returns:
##
#############################################################################
	set errorInfo ""
	set slewrates [list [list ""]]

	catch { set slewrates [::get_pad_data -io_standard $io_standard 2D_INT_VALID_SLEW_RATE_VALUES] }
	set slewrates [lindex $slewrates 0]

	if { [llength $slewrates] == 0 } {
		lappend slewrates ""
	}

	return $slewrates
}
