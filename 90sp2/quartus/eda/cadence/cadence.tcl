###############################################################################
#
#	File Name	: CADENCE.TCL
#
#	Description	: This is script for the end user to convert pin 
#			  assignment from SDC format to Quartus QSF file.
#			  
#	Functionality	: Given a SDC file name and Quartus 
#			  project name, this tcl script add pin assignments into 
#			  Quartus CSF file. 
#			  Executable tclsh84 required to run this script.
#
#	Author		: Kok Fatt Chan
#
#	Last Update	: October 13, 2003
#
###############################################################################

################################################################################
#
proc process_arguments {} {
#
# Description:
# Process the arguments passed in.
#
# Arguments:
# None
#
# Returns:
# Nothing
#
################################################################################

	global proj_name
	global sdc_file
	global argv
	global argc

	if { $argc == 2 } {
		set icount 1
		foreach arg $argv {
			if { $icount == 1 } {
				set sdc_file $arg
			}
			if { $icount == 2 } {
				set proj_name $arg
			}
			incr icount
		}

	} else {
		puts "Not enough parameters given!"
		puts "Usage: tclsh84 cadence.tcl <SDC_File> <Project Name>"
		return -1
	}
}

################################################################################
#
proc main {} {
#
# Description:
# Entry point for this mini program
#
# Arguments:
# None
#
# Returns:
# Nothing
#
################################################################################
	global sdc_file

	if { [process_arguments] != -1 } {

	  if { [file exists $sdc_file] == 0 } {
		  puts "Error: SDC file, $sdc_file does not exist!"
		  return -1
	  } else {
		  process_sdc		  
	  }
	}
}

################################################################################
#
proc process_sdc {} {
#
# Description:
# Read & process SDC file.
#
# Arguments:
# None
#
# Returns:
# Nothing
#
################################################################################
	global sdc_file
	global proj_name
	
	# Open <project>_concept.tcl file. Always create this file.
	set out_file_nm $proj_name
	append out_file_nm "_concept.tcl"
	set quartus_file [open $out_file_nm w]	
	
	set file_id ""
	set name_list ""
	set pin_list ""
	set key_search "altera_chip_pin_lc"
	set key_len [string length $key_search]
	set file_id [open $sdc_file r 0444]
	append key_search "*"
        set input_num [gets $file_id input_text]
        puts $quartus_file "project_open $proj_name"
	while { $input_num >= 0 } {
		string trim $input_text
		
		set search_index [string first "altera_chip_pin_lc" $input_text ]
		
		if { $search_index != -1 } {
			lappend name_list [string range $input_text [expr [string first "{" $input_text ]+1] [expr [string first "}" $input_text ]-1]]
			lappend pin_list [string range $input_text [expr [string last  "{" $input_text ]+1] [expr [string last "}" $input_text ]-1]]		
		}
		
		set input_num [gets $file_id input_text]
	}
	set count_name 0
	set pin ""
	foreach name $name_list {
		set count_pin 0
		foreach pin_loc $pin_list {
			if { $count_pin == $count_name } {
				set pin $pin_loc				
				set search_alias [string first "@" $pin ]
				if { $search_alias != -1 } {
					set pin [string range $pin [expr [string first "@" $pin ]+1] [string length $pin]]
				}
			}
			set count_pin [expr $count_pin + 1]
		}
		if {[ string first ":" $name ] != -1 } {
			set from [string range $name [expr [string first ":" $name ]+1] [expr [string first "\]" $name ]-1]]
			if { $from !="" } {
				set name [string range $name 0 [expr [string first "\[" $name ] -1 ]]
				set array_pin [split $pin ","]
				foreach pin_id $array_pin {
					set name_tmp $name
					append name_tmp "\\\[$from\\\]"
					set search_alias [string first "@" $pin_id ]
					if { $search_alias != -1 } {
						set pin_id [string range $pin_id [expr [string first "@" $pin_id ]+1] [string length $pin_id]]
					}
					set temp "set_location_assignment -value PIN_$pin_id -to $name_tmp"
					puts $quartus_file $temp
					set from [expr $from + 1]
				}
			}
				
		} else {
			set index [string range $name [expr [string first "\[" $name ]+1] [expr [string first "\]" $name ]-1]]
			if {$index != ""} {
				 set name [string range $name 0 [expr [string first "\[" $name ] -1 ]]
				 append name "\\\[$index\\\]"
			}
			set temp "set_location_assignment -value PIN_$pin -to $name"
			puts $quartus_file $temp
		
		}
		set count_name [expr $count_name + 1]
	}
	
	puts $quartus_file "project_close"
	close $quartus_file
	
	set cmd "exec ../../bin/quartus_sh -t "
	append cmd $out_file_nm
	catch {eval $cmd} result
	puts $result
	
}


main

	
