#############################################################################
##  io.tcl - v1.0
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


package provide ::quartus::io 1.0

#############################################################################
## Additional Packages Required
package require ::quartus::device
package require ::quartus::advanced_device 2.0

#############################################################################
## Export Functions & Declare Global Namespace Variables
namespace eval ::quartus::io {

	#device/package functions
	namespace export load_device
	namespace export unload_device
	namespace export get_pin_count
	namespace export get_io_bank_count

	#pin/signal names
	namespace export get_pin_loc_name
	namespace export get_pin_func_name
	namespace export get_secondary_func_name
	namespace export get_pin_other_name

	#properties of the pin
	namespace export get_io_bank

	namespace export is_vccio_pin
	namespace export is_vcc_pin
	namespace export is_gnd_pin
	namespace export is_dedicated_input
	namespace export is_dedicated_clock
	namespace export is_fast_clock
	namespace export is_oct_io
	namespace export is_pll_related
	namespace export is_pll_enable
	namespace export is_generic_io
	namespace export is_programming_io
	namespace export is_ram_io
	namespace export is_jtag_io
	namespace export is_secondary_signal
	namespace export is_hssi_in
	namespace export is_hssi_out
	namespace export is_hssi_pos
	namespace export is_lvds_in
	namespace export is_lvds_out
	namespace export is_lvds_pos
	namespace export is_dev_oe
	namespace export is_dev_clrn
	namespace export is_jtag_tck
	namespace export is_jtag_tms
	namespace export is_jtag_trst
	namespace export is_jtag_tdi
	namespace export is_jtag_tdo
	namespace export is_dqs

	#iostandards
	namespace export get_io_standards
	namespace export get_drive_strength
	namespace export get_voltage
	namespace export operation_modes
	namespace export io_standard_supports_open_drain

	#Utility functions
	namespace export get_vref_pin
	namespace export get_vref_pin_name
	namespace export get_vref_name
	namespace export get_io_type
	namespace export get_ss_type
	namespace export get_oct_type
	namespace export get_diff_complement

	#These functions are to be used only by power user.
	namespace export get_first_pad
	namespace export get_pad_list
	namespace export get_pin_id

	namespace export is_bus_hold
	namespace export has_week_pullup
	namespace export has_open_drain
	namespace export get_electromigration_current_limits
	namespace export get_distance_to_differential_signals
	namespace export output_to_vref_distance
	namespace export max_outputs_per_vref_bank
	namespace export has_pci_clamp_diode
	namespace export allow_single_ended_inputs_in_dpa_banks
	namespace export allow_single_ended_outputs_in_dpa_banks
	# Declare Global Variables Here!
	# DO NOT EXPORT ANY OF THESE!
	
}

#############################################################################
##
proc ::quartus::io::load_device {part} {
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
	return [::load_device -part $part]
}

#############################################################################
##
proc ::quartus::io::unload_device {} {
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
	return [::unload_device]
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
##	This function can be used to get the total pins in the device currently in memory.
##
##  Returns:
##	TCL_OK    - whenthe device is successfully loaded
##	TCL_ERROR - on error
################################################################################
	return [::get_pkg_data INT_PIN_COUNT]
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
	return [::get_pad_data INT_IO_BANK_COUNT]
}


#############################################################################
##
proc ::quartus::io::get_pin_loc_name {pin} {
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
proc ::quartus::io::get_pin_func_name {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
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
	set pad [get_first_pad $pin]
	if {$pad == ""} {
		if [ catch {::get_pkg_data -pin $pin STRING_TYPE_NAME} name ] {
			set name ""
		}
	} else {
		if [ catch {::get_pad_data -pad $pad STRING_TYPE_NAME} name ] {
			set name ""
		}
	}
	return $name
}

#############################################################################
##
proc ::quartus::io::get_secondary_func_name {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##      A pin can be refered to by the location on the package, the function name, the
##	secondary function supported by pin or other internal name.
##	This function returns the pin number (i.e pin name by position).
##
##  Returns:
##	name -  Secondary function name of the pin.
##	-1   - on Error
################################################################################
	set name ""
	set pad [get_first_pad $pin]
	if [ catch {::get_pad_data -pad $pad STRING_AUXILIARY_FUNCTION_NAME} name ] {
		set name ""
	}
	return $name
}

#############################################################################
##
proc ::quartus::io::get_pin_other_name {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##      A pin can be refered to by the location on the package, the function name, the
##	secondary function supported by pin or other internal name.
##
##  Returns:
##	name -  Secondary function name of the pin.
##	-1  - on Error
################################################################################
	set name ""
	set pad [get_first_pad $pin]
	if [ catch {::get_pad_data -pad $pad STRING_MCF_NAME} name ] {
		set name ""
	}
	return $name
}


#############################################################################
##
proc ::quartus::io::get_io_bank {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       Get the IO bank of the given pin.
##
##  Returns:
##      <io_bank>  - The IO bank of the current pin (PAD connected to current pin)
##	-1         - if Error occurs
################################################################################
	set io_bank -1
	set pad [get_first_pad $pin]
	if {$pad == ""} {
		if [ catch {::get_pkg_data -pin $pin INT_IO_BANK_ID } io_bank] {
			set io_bank -1;
		}
	} else {
		if [ catch {::get_pad_data -pad $pad INT_IO_BANK_ID } io_bank] {
			set io_bank -1;
		}
	}

	# add 1 to all io_bank values except when its of type VCCINT or GND
	set pin_func [ ::quartus::io::get_pin_func_name $pin ]
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
	if [catch {::get_pkg_data -pin $pin BOOL_IS_VCCN } is_vccio] {
		set is_vccio -1
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
	set is_vcc 0
	if [catch {::get_pkg_data -pin $pin BOOL_IS_VCC } is_vcc] {
		set is_vcc -1
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
	set is_vss 0
	if [catch {::get_pkg_data -pin $pin BOOL_IS_VSS } is_vss] {
		set is_vccio -1
	}
	return $is_vss
}
#############################################################################
##
proc ::quartus::io::is_dedicated_input {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function is used to find out if a given pin a dedicated input pin
##
##  Returns:
##      1   - if the current pin is dedicated input
##	0   - if the pin is not a dedicated input pin 
##	-1  - on error.
################################################################################
	set is_input 0
	set pad [get_first_pad $pin]
	if [ catch {::get_pad_data -pad $pad BOOL_IS_DEDICATED_INPUT_PAD  } is_input] {
		set is_input -1
	}
	return $is_input
}

#############################################################################
##
proc ::quartus::io::is_dedicated_clock {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function can be used to find out if the given pin is a dedicated clock pin.
##
##  Returns:
##      1  - if the current pin is dedicated clock pin
##	0  - if the pin is not a dedicated clock pin
##	-1 - if error occurs
################################################################################
	set is_clk 0
	set pad [get_first_pad $pin]
	if [ catch {::get_pad_data -pad $pad BOOL_IS_CLOCK_PAD  } is_clk] {
		set is_clk -1
	}
	return $is_clk
}

#############################################################################
##
proc ::quartus::io::is_fast_clock {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function can be used to find out if the given pin a FAST (regional?) Clock pad
##
##  Returns:
##      1  - if the current pin is fast clock pin
##	0  - if the pin is not a fast clock pin
##	-1 - if error occurs
################################################################################
	set is_fast_clk 0
	set pad [get_first_pad $pin]
	if [ catch {::get_pad_data -pad $pad BOOL_IS_FCLKIN_PAD  } is_fast_clk] {
		set is_fast_clk -1
	}
	return $is_fast_clk
}

#############################################################################
##
proc ::quartus::io::is_oct_io {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##      This function can be used to find out if the given pin is OCT pin.
##	The OCT pins are the pins to which pullup or pulldown values are applied.
##
##  Returns:
##      1  - if the current pin is OCT pin
##	0  - if the pin is not a OCT pin
##	-1 - if error occurs
################################################################################
	set is_oct_io 0
	set pad [get_first_pad $pin]
	set oct_enums { {BOOL_IS_OCTRUP_PAD}
		{BOOL_IS_OCTRDN_PAD}
	}		
	foreach bool_enum $oct_enums {
		if [catch {::get_pad_data -pad $pad $bool_enum} is_oct_io] {
			set is_oct_io 0
		}
		if {$is_oct_io == 1} {
			break;
		}
	}
	return $is_oct_io
}

#############################################################################
##
proc ::quartus::io::is_pll_related {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function can be used to find out if the pin is a PLL pin
##
##  Returns:
##      1  - if the current pin is PLL pin
##	0  - if the pin is not a PLL pin
##	-1 - if error occurs
################################################################################
	set is_pll_related 0
	#individual variables that may be tested are 
	#BOOL_IS_CLOCKOUT_PAD
	#BOOL_IS_LVDSCLKIN_PAD
	#BOOL_IS_FEEDBACKIN_PAD
	set pad [get_first_pad $pin]
	if [ ::get_pad_data -pad $pad BOOL_IS_PLLRELATED_PAD ] {
		set is_pll_related 1
	} elseif [::get_pad_data -pad $pad BOOL_IS_CLOCKOUT_PAD ] {
		set is_pll_related 1
	}
	return $is_pll_related
}

#############################################################################
##
proc ::quartus::io::is_generic_io {pin} {
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
	set pad [get_first_pad $pin]
	if [ catch {::get_pad_data -pad $pad BOOL_IS_USABLE_AS_REGULAR_IO  } is_io] {
		set is_io -1
	}
	return $is_io
}

#############################################################################
##
proc ::quartus::io::is_programming_io {pin} {
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
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_DEDICATED_PROGRAMMING_PAD} is_prog] {
		set is_prog -1
	}
	return $is_prog
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
proc ::quartus::io::is_jtag_io {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       This function is used to determine if the given pin is a dedicated JTAG pin.
##
##  Returns:
##      1  - if the pin is a JTAG pin
##      0  - if the pin is not a JTAG pin.
##      -1 - if there is an erorr.
################################################################################
	set is_jtag 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_JTAG_PAD} is_jtag] {
		set is_jtag -1
	}
	return $is_jtag
}

#############################################################################
##
proc ::quartus::io::is_secondary_signal {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##      This function is used to find out if the given pin has a secondary function.
##	The secondary functions recognized by this function are
##	INIT_DONE
##	DEV_OE
##	DEV_CLRn
##	CLKUSR
##	RUnLU
##	CS
##	nCS
##	nWS
##	nRS
##	DATA[1..7]
##	RDYnBSY
##	CRC_ERROR
##	PGM[0..2]
##
##  Returns:
##      1  - if the pin can supports the function described above.
##	0  - if the pin does not support the functions described above
##	-1 - if there is an error
################################################################################
	set is_secondary_signal 0
	set secondary_sig_bools { {BOOL_IS_INIT_DONE_PAD}
				  {BOOL_IS_DEV_CLRN_PAD}
				  {BOOL_IS_DEV_OE_PAD}
				  {BOOL_IS_CLKUSR_PAD}
				  {BOOL_IS_RUNLU_PAD}
				  {BOOL_IS_CS_NCS_NWS_NRS_PAD}
				  {BOOL_IS_DATA_7_1_PAD}
				  {BOOL_IS_DATA_0_PAD}
				  {BOOL_IS_READY_AND_BUSY_PAD}
				  {BOOL_IS_CRCERROR_PAD}
				  {BOOL_IS_PGM_PAD}
			  }
	set pad [get_first_pad $pin]
	foreach bool_enum $secondary_sig_bools {
		if [catch {::get_pad_data -pad $pad $bool_enum} is_secondary_signal] {
			set is_secondary_signal -1
		}
		if {$is_secondary_signal == 1} {
			break;
		}
	}
	return $is_secondary_signal
}


#############################################################################
##
proc ::quartus::io::get_io_standards {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
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
	set pad [get_first_pad $pin]
	if [ catch {::get_pad_data -pad $pad LIST_IO_STANDARDS  } ios_list] {
		set io_standards -1
	}
	foreach ios $ios_list {
		lappend io_standards [get_user_name -io_standard $ios]
	}
	return $io_standards
}

#############################################################################
##
proc ::quartus::io::get_drive_strength {io_standard} {
##
##  Arguments:
##      <io_standard> - IO Standard
##
##  Description:
##      This function is used to find out the drive_strengths supported by 
##	a given IO Standard. The list may also contain predefined drivestrengths "MIN_MA" and "MAX_MA"
##
##  Returns:
##      TCL List - drive strengths (with Units) for a given IO standard.
##	-1       - on Error
################################################################################
	set drive_levels 0
	if [ catch {::get_pad_data -io_standard $io_standard  LIST_CURRENT_SET} drive_levels] {
		set drive_levels -1
	}
	return $drive_levels
}



#############################################################################
##
proc ::quartus::io::get_vref_pin {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##      Each pin is related to a VREF pin. This function returns the pin id of the VREF
##	to which a given pin is related	
##
##  Returns:
##      pin_id - of the VREF pin related to given pin.
##	-1     - if there is an error or pin does not support this property (e.g. VREF pin)
################################################################################
	set vref_id -1
	set pad [get_first_pad $pin]
	if [ catch {::get_pad_data -pad $pad INT_VREF_PAD_ID} vref_pad_id] {
			return -1;
	}
	if [ catch {::get_pad_data -pad $vref_pad_id INT_PIN_ID} vref_id] {
			return -1;
	}
	return $vref_id;
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
	set vref_name [::quartus::io::get_pin_func_name $pin]
	#We need the full VREF Name (of the form VREFxBy which signifies 
        #that this is VREF no x of Bank y. If this is not available from 
        #primiary function name of pin, check AUXILIARY_FUNCTION_NAME.
	#If AUXILIARY_FUNCTION_NAME does not provide this info, check MCF_NAME.
	if ![ regexp -nocase {^vref} $vref_name] {
		if [ catch {::quartus::io::get_secondary_func_name $pin } vref_name] {
			#Auxiliary function was not found so we will other internal name
			set vref_name [::quartus::io::get_pin_other_name $pin ]

		} 
		if ![ regexp -nocase {^vref} $vref_name] {
			set vref_name [::quartus::io::get_pin_other_name $pin ]
		}

		if ![ regexp -nocase {^vref} $vref_name] {
			set vref_name ""
		}

	}
	if ![ regexp -nocase {^vref} $vref_name] {
		set vref_name ""
	}
	return $vref_name
}

#############################################################################
##
proc ::quartus::io::get_vref_pin_name {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##      Each pin is related to a VREF pin. This information may be available 
##	in different forms for different families. This function provides a 
##	technology independent interface to get the name of the VREF pin 
##	associated with the given pin in the format "VREF1B0". 
##
##  Returns:
##	-1  - on Error
################################################################################
	set vref_pin [get_vref_pin $pin]
	##For stratix II family we do not get VREF name using the normal methods,
	##In such cases the related POWER BONDED VREF pin name is directly available
	if {$vref_pin == -1} {
		set pad [get_first_pad $pin]
		if [ catch {::get_pad_data -pad $pad STRING_POWER_BONDED_VREF_NAME} vref_name] {
			return -1;
		}
	} else {
		set vref_name [::quartus::io::get_pin_func_name $vref_pin]
		#We need the full VREF Name (of the form VREFxBy which signifies that this is VREF no x of Bank y.
		#If this is not available from TYPE, check AUXILIARY_FUNCTION_NAME.
		#If AUXILIARY_FUNCTION_NAME does not provide this info, check MCF_NAME.
		if ![ regexp -nocase {^vref} $vref_name] {
			if [ catch {::quartus::io::get_secondary_func_name $vref_pin } vref_name] {
				#Auxiliary function was not found so we will other internal name
				set vref_name [::quartus::io::get_pin_other_name $vref_pin ]

			} 
			if ![ regexp -nocase {^vref} $vref_name] {
				set vref_name [::quartus::io::get_pin_other_name $pin ]
			}
		}
	}
	if ![ regexp -nocase {^vref} $vref_name] {
		set vref_name ""
	}
	return $vref_name
}



#############################################################################
##
proc ::quartus::io::get_io_type {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##       Find out the type of pin 
##
##  Returns:
##      OCT			- Pin for applying pullup and pulldown values for OCT.
##	JTAG_INPUT              - jtag input
##	JTAG_OUTPUT             - jtag output
##	PROGRAMMING_BIDIR	- programming pin - bidir
##	PROGRAMMING_INPUT	- programming pin - input
##	PROGRAMMING_OUTPUT	- programming pin - output
##	RAM			- RAM interfacing pin
##	CLOCK			- Clock pin (Dedicated or FCLK)
##	PLL			- PLL pin
##	INPUT                   - Dedicated input
##	IO                      - For general purpose IO
##	HSSI_BIDIR              - Differential Signal Input 
##	HSSI_INPUT              - Differential Signal Input 
##	HSSI_OUTPUT             - Differential Signal Output 
##	DIFF_BIDIR              - Differential Signal Input 
##	DIFF_INPUT              - Differential Signal Input 
##	DIFF_OUTPUT             - Differential Signal Output 
##	Unknown                 - Pin is not of known types.
################################################################################
	set type "Unknown"
	set pad [get_first_pad $pin]
	if [is_secondary_signal $pin] {
		set type [get_ss_type $pin]
	} elseif [is_oct_io $pin] {
		set type "OCT"
	} elseif [is_jtag_io $pin] {
		if [::get_pad_data -pad $pad BOOL_IS_JTAG_TDO] {
			set type  "JTAG_OUTPUT"
		} else {
			set type  "JTAG_INPUT"
		}
	} elseif [is_programming_io $pin] {
		set pin_name [::get_pad_data -pad $pad STRING_AUXILIARY_FUNCTION_NAME]
		if { $pin_name == "CONF_DONE" } {
			set type "PROGRAMMING_BIDIR"
		} elseif { $pin_name == "nSTATUS" } {
			set type "PROGRAMMING_BIDIR"
		} elseif { $pin_name == "nCEO" } {
			set type "PROGRAMMING_OUTPUT"
		} else {
			set type "PROGRAMMING_INPUT"
		}
	} elseif [is_dedicated_clock $pin] {
		set type  "CLOCK"
	} elseif [is_lvds_in $pin] {
		if [is_lvds_out $pin] {
			set type  "DIFF_BIDIR"
		} else {
			set type  "DIFF_INPUT"
		}
	} elseif [is_lvds_out $pin] {
		if [is_lvds_in $pin] {
			set type  "DIFF_BIDIR"
		} else {
			set type  "DIFF_OUTPUT"
		}
	} elseif [is_hssi_in $pin] {
		if [is_hssi_out $pin] {
			set type  "HSSI_BIDIR"
		} else {
			set type  "HSSI_INPUT"
		}
	} elseif [is_hssi_out $pin] {
		if [is_hssi_in $pin] {
			set type  "HSSI_BIDIR"
		} else {
			set type  "HSSI_OUTPUT"
		}
	} elseif [is_ram_io $pin] {
		set type  "RAM"
	} elseif [is_fast_clock $pin] {
		set type  "CLOCK"
	} elseif [is_pll_related $pin] {
		set type  "PLL"
	} elseif [is_dedicated_input $pin] {
		#Can be a dedicated clock!!! so check known for types
		set type_name [::get_pad_data -pad $pad STRING_TYPE_NAME]
		switch -exact $type_name {
			{Dedicated Clock} 
				{
					set type "CLOCK"
				}
			{Vref} 
				{
					set type "INPUT"
				}
			{Dedicated Programming} 
				{
					set type "PROGRAMMING_INPUT"
				}
			default 
				{
					set type  "INPUT"
				}
		}
	} elseif [is_generic_io $pin] {
		set type  "IO"
	}
	return $type
}


#############################################################################
##
proc ::quartus::io::get_ss_type {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##      This function can be used to find out the type (direction) of the seconday
##	configuration signals. 
##	This function does not check that the pin suppied by user is valid secondary signal.
##	user should check if the pin is valid secondary signal using function is_secondary_signal
##
##  Returns:
##      "SS_INPUT"  - if the secondary signal is an input
##	"SS_OUTPUT" - if the secondary signal is output
##	"SS_BIDIR"  - if the seconardy signal is neither input nor output.
################################################################################
	set type "SS_BIDIR"
	set ss_inputs { {BOOL_IS_DEV_CLRN_PAD}
			{BOOL_IS_DEV_OE_PAD}
			{BOOL_IS_CLKUSR_PAD}
			{BOOL_IS_RUNLU_PAD}
			{BOOL_IS_CS_NCS_NWS_NRS_PAD}
			{BOOL_IS_DATA_7_1_PAD}
			{BOOL_IS_DATA_0_PAD}
			{BOOL_IS_CRCERROR_PAD}
	}

	set ss_outputs { {BOOL_IS_INIT_DONE_PAD}
			{BOOL_IS_READY_AND_BUSY_PAD}
			{BOOL_IS_PGM_PAD}
	}
	set pad [get_first_pad $pin]
	foreach bool_enum $ss_inputs {
		if [::get_pad_data -pad $pad $bool_enum] {
			return "SS_INPUT"
		}
	}
	foreach bool_enum $ss_outputs {
		if [::get_pad_data -pad $pad $bool_enum] {
			return "SS_OUTPUT"
		}
	}
	return $ss_type
}

#############################################################################
##
proc ::quartus::io::get_oct_type {pin} {
##
##  Arguments:
##      <pin> - Pin id. This is the pin id of the pin and lies between 1 and maximum
##		number of pins
##
##  Description:
##	This function can be used to determine the type of on chip termination supported 
##	by a given pin
##
##  Returns:
##      Returns a string with following values.
##      SERIES       -  if the pin supports series termination
##      PARALLEL     -  if the pin supports parallel termination
##      DIFFERENTIAL -  if the pin supports differential termination
##      NONE         -  if the pin does not support any OCT, 
##			or supports some type other than SERIES, PARALLEL or DIFFERENTIAL
################################################################################
	#Series termination
	set pad [get_first_pad $pin]
	set termination "NONE"
	if [::get_pad_data -pad $pad BOOL_IS_OCT_RS_PAD] {
		set termination  "SERIES"
	}
	#Parallel Termination
	 if [::get_pad_data -pad $pad BOOL_IS_OCT_RT_PAD] {
		set termination  "PARALLEL"
	}
	#Differential Termination
	 if [::get_pad_data -pad $pad BOOL_IS_OCT_RD_PAD] {
		set termination  "DIFFERENTIAL"
	}
	return $termination
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
	return [lindex [::get_pkg_data LIST_PAD_IDS -pin $pin] 0]
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
proc ::quartus::io::get_pin_id {pin_name} {
##
##  Arguments:
##      <pin_name> - Pin name by location. This is same as location of the pin on the package
##              
##
##  Description:
##      Get Quartus pin_id for the pin given its location. All the functions 
##      in package IO require the pin_id as argument.
##
##  Returns:
##      List of Pad Ids    - List of Pad ids bonded to current pin.
##	TCL_ERROR          - on error
################################################################################
	set pin_id -1;
	set pad [lindex [::get_pkg_data LIST_PAD_IDS -pin_name $pin_name] 0]
	if {$pad == ""} {

		set pin_count [get_pin_count]
		for { set pin_idx 0 } { $pin_idx <= $pin_count } { incr pin_idx } {
			set pin_loc_name [get_pin_loc_name $pin_idx] 
			if { [string compare -nocase $pin_loc_name $pin_name] == 0 } {
				set pin_id $pin_idx
				break
			}
		}
	} else {
		set pin_id [::get_pad_data INT_PIN_ID -pad $pad]
	}
	return $pin_id
}

#############################################################################
##
proc ::quartus::io::is_dqs {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_dqs 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_DQS_PAD} is_dqs] {
		set is_dqs -1
	}
	return $is_dqs
}

#############################################################################
##
proc ::quartus::io::is_vref {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_vref 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_VREF_PAD} is_vref] {
		set is_vref -1
	}
	return $is_vref
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
	set is_lvdsin 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_LVDS_INPUT} is_lvdsin] {
		set is_lvdsin -1
	}
	return $is_lvdsin
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
	set is_lvdsout 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_LVDS_OUTPUT} is_lvdsout] {
		set is_lvdsout -1
	}
	return $is_lvdsout
}

#############################################################################
##
proc ::quartus::io::is_lvds_pos {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_lvdspos 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_LVDS_POSITIVE} is_lvdspos] {
		set is_lvdspos -1
	}
	return $is_lvdspos
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
	set is_hssi_in 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_HSSI_INPUT} is_hssi_in] {
		set is_hssi_in -1
	}
	return $is_hssi_in
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
	set is_hssi_out 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_HSSI_OUTPUT} is_hssi_out] {
		set is_hssi_out -1
	}
	return $is_hssi_out
}

#############################################################################
##
proc ::quartus::io::is_hssi_pos {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_hssi_pos 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_HSSI_POSITIVE} is_hssi_pos] {
		set is_hssi_pos -1
	}
	return $is_hssi_pos
}

#############################################################################
##
proc ::quartus::io::is_dev_oe {pin} {
##
##  Arguments:
##      pin - Pin id
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_dev 0
	if [catch {::get_pad_data -pad $pad BOOL_IS_DEV_OE_PAD} is_dev] {
		set is_dev -1
	}
	return $is_dev
}

#############################################################################
##
proc ::quartus::io::is_other_pll {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_pll 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_PLLRELATED_PAD} is_pll] {
		set is_pll -1
	}
	return $is_pll
}

#############################################################################
##
proc ::quartus::io::is_jtag_tms {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_tms 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_JTAG_TMS} is_tms] {
		set is_tms -1
	}
	return $is_tms
}

#############################################################################
##
proc ::quartus::io::is_jtag_trst {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_trst 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_JTAG_NTRST} is_trst] {
		set is_trst -1
	}
	return $is_trst
}

#############################################################################
##
proc ::quartus::io::is_jtag_tdi {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_tdi 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_JTAG_TDI} is_tdi] {
		set is_tdi -1
	}
	return $is_tdi
}

#############################################################################
##
proc ::quartus::io::is_jtag_tdo {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_tdo 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_JTAG_TDO} is_tdo] {
		set is_tdo -1
	}
	return $is_tdo
}

#############################################################################
##
proc ::quartus::io::is_jtag_tck {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_tck 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_JTAG_TCK} is_tck] {
		set is_tck -1
	}
	return $is_tck
}

#############################################################################
##
proc ::quartus::io::is_pll_enable {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_ena 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_PLL_ENABLE_PAD} is_ena] {
		set is_ena -1
	}
	return $is_ena
}

#############################################################################
##
proc ::quartus::io::get_diff_complement {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set comp_pin -1
	set comp_pad 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad INT_LVDS_COMPLEMENT_PAD_ID} comp_pad] {
		set comp_pad -1
	} 

	if {$comp_pad != -1} {
		if [ catch {::get_pad_data -pad $comp_pad INT_PIN_ID} comp_pin] {
			set comp_pin -1;
		}
	}
	return $comp_pin
}


#############################################################################
##
proc ::quartus::io::is_dev_clrn {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_devclrn 0
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_DEV_CLRN_PAD} is_devclrn] {
		set is_devclrn -1
	}
	return $is_devclrn
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
proc ::quartus::io::is_bus_hold {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_bus_hold_missing 0
	set bus_hold 1
	set pad [get_first_pad $pin]
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
proc ::quartus::io::has_week_pullup {pin} {
##
##  Arguments:
##      Pin - Pin id 
##              
##
##  Description:
##
##  Returns:
################################################################################
	set is_week_pullup_missing 0
	set week_pullup 1
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_WEEK_PULLUP_MISSING} is_week_pullup_missing] {
		set is_week_pullup_missing -1
	}
	if {$is_week_pullup_missing == -1} {
		set week_pullup -1
	} elseif {$is_week_pullup_missing == 1} {
		set week_pullup 0
	}
	return $week_pullup
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
	set is_week_open_drain_missing 0
	set open_drain 1
	set pad [get_first_pad $pin]
	if [catch {::get_pad_data -pad $pad BOOL_IS_WEEK_PULLUP_MISSING} is_open_drain_missing] {
		set is_open_drain_missing -1
	}
	if {$is_open_drain_missing == -1} {
		set open_drain -1
	} elseif {$is_open_drain_missing == 1} {
		set open_drain 0
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
	set return_val 0
	#We should validate io standard specified?
	if [catch {::get_pad_data -io_standard $iostd BOOL_IS_DIFFERENTIAL} is_diff_io ] {
		set is_diff_io 0
	}
	if {$is_diff_io == 0 } {
		set return_val 1 
	} 

	return $return_val
}

#############################################################################
##
proc ::quartus::io::get_electromigration_current_limits {} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      {MAX HIO_Count MAX_HIO_Current} {MAX_VIO_Count MAX_VIO_Current}
#############################################################################

	set return_val ""
	if [catch {::get_pad_data INT_MAX_CURRENT_OF_CONSECUTIVE_PADS} max_hio_current ] {
		set max_hio_current "NA"
	}
	if [catch {::get_pad_data INT_MAX_CURRENT_OF_CONSECUTIVE_VIO_PADS} max_vio_current ] {
		set max_vio_current "NA"
	}
	if [catch {::get_pad_data INT_CONSECUTIVE_OUTPUT_COUNT} max_hio_count ] {
		set max_vio_count "NA"
	}
	if [catch {::get_pad_data INT_CONSECUTIVE_VIO_OUTPUT_COUNT} max_vio_count ] {
		set max_vio_count "NA"
	}
	set return_val {{$max_hio_count $max_hio_current} {$max_vio_count $max_vio_current}}
	return $return_val
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
	if [ catch {::get_pad_data -io_standard $io_standard  INT_VOLTAGE_TYPE} voltage] {
		set voltage -1
	}
	regsub {([0-9])_([0-9])_(.*)} $voltage {\1.\2 \3} voltage
	return $voltage
}

#############################################################################
##
proc ::quartus::io::get_distance_to_differential_signals {} {
##
##  Arguments:
##     
##              
##
##  Description:
##
##  Returns:
##      {input_to_diff_dist output_to_diff_dist}
#############################################################################
	set input_to_diff_dist "NA"
	set output_to_diff_dist "NA"
	if [ catch {::get_pkg_data INT_INPUT_TO_DIFERENTIAL_PAD_DISTANCE} input_to_diff_dist] {
		set input_to_diff_dist "NA"
	}
	if [ catch {::get_pkg_data INT_OUTPUT_TO_DIFERENTIAL_PAD_DISTANCE} output_to_diff_dist] {
		set output_to_diff_dist "NA"
	}
	
	set return_val "$input_to_diff_dist $output_to_diff_dist"
	return $return_val
}

#############################################################################
##
proc ::quartus::io::output_to_vref_distance {} {
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
	set return_val "NA"
	if [ catch {::get_pad_data INT_OUTPUT_TO_VREF_DISTANCE_IN_PADS} return_val] {
		set return_val "NA"
	}
	return $return_val
}

#############################################################################
##
proc ::quartus::io::max_outputs_per_vref_bank {} {
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
	set return_val "NA"
	if [ catch {::get_pkg_data INT_MAX_OUTPUT_COUNT_PER_VREF_BANK} return_val] {
		set return_val "NA"
	}
	return $return_val
}

#############################################################################
##
proc ::quartus::io::operation_modes {io_standard pin} {
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
	set pad [get_first_pad $pin]
	set operation_mode "BIDIR"
	if [ catch {::get_pad_data -pad $pad BOOL_INPUT_OPERATION_ONLY} input_only] {
		if [ catch {::get_pad_data -pad $pad BOOL_OUTPUT_OPERATION_ONLY} output_only] {
			set operaion_mode "BIDIR"
		} else {
			set operation_mode "OUTPUT"
		}
	} else {
		set operation_mode "INPUT"
	}
	return $operation_mode
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
	set has_pci_clamp_diode 0 
	set pad [get_first_pad $pin]
	if [ catch {::get_pad_data -pad $pad BOOL_HAS_PCI_CLAMP_DIODE} has_pci_clamp_diode] {
		set
	}
	return $has_pci_clamp_diode
}
