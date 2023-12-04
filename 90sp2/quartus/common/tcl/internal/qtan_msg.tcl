# ***************************************************************
# ***************************************************************
#
# Description:	Timing TCL utilities.
#
# Version:		1.0
#
# Authors:	    Altera Corporation
#
#               Copyright (c)  Altera Corporation 1999 - 2002
#               All rights reserved.
#
# ***************************************************************
# ***************************************************************

#--------------------------------------------------------------------------------------------
#
proc print_report_timing_message_recursive { current_list recursion_level out_file } {
#
# Description:	Dump the messagese.
#				 
#               This function accepts a message represented as a TCL string.
#               "Info"  "ITDB_FULL_SLACK_RESULT" params "actual text" { list of submessages } 
#
#               The third list element is the actual message.
#               The fourth list element is a list of submessages.
#
# -------------------------------------------------------------------------------------------
	
    # get the message
	set actual_message [lindex $current_list 3]

    # create left margin for the message
	set str ""
	for { set i 0 } { $i < $recursion_level } { incr i 1 } {
		set str "    $str"
	}

	# dump the message
	
	puts $out_file "$str $actual_message"
	
	if { $recursion_level == 0 } {
		puts $out_file  "----------------------------------------------------------------------------------------------";
	}
	
	# call the function for the submessages
	set new_rec_l [expr $recursion_level + 1]
	
	foreach sub_msg [lindex $current_list 4] {
		print_report_timing_message_recursive $sub_msg $new_rec_l $out_file
	}		
}

set qtan_path_count 0

#--------------------------------------------------------------------------------------------
#
proc print_report_timing_message { msg { stream_name "" } } {
#
# Description:	Entry point for printing message to the screen/file.
#				 
#               This function accepts a message represented as a TCL string:
#               "Info"  "ITDB_FULL_SLACK_RESULT" params "actual text" { list of submessages } 
#
#               If stream_name is specified assume this is the file name 
#               user whants to add paths to.
# -------------------------------------------------------------------------------------------

	global qtan_path_count

    # be default assume stdout
	set out_file stdout

    # open file is stream_name is specified
    if { [string compare $stream_name ""] != 0 } {
		if [ catch { set out_file [open $stream_name a] } result ] {
			puts stderr $result
			return
		}		
	}

	# convert the string into the list
	set list $msg

	# Increase path counter
	incr qtan_path_count

	puts $out_file  "----------------------------------------------------------------------------------------------";
	puts $out_file  "Path Number: $qtan_path_count"
	# recursivly dump the message
	print_report_timing_message_recursive $list 0 $out_file
	puts $out_file  "----------------------------------------------------------------------------------------------";

	# open file is stream_name is specified
	if { [string compare $stream_name ""] != 0 } {
		close $out_file
	}	
}
