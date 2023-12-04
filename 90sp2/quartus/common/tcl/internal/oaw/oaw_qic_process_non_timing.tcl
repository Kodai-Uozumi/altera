###################################################################################
#                                                                                 #
# File Name:    oaw_qic_process_non_timing.tcl                                    #
#                                                                                 #
# Summary:      This script is called by the Incremental Compilation Advisor      #
#               on the user's command.  It checks the status of each of the       #
#               recommendations that don't need timing information.  These        #
#               recommendations are defined in the Advisor's XML file.  It also   #
#               writes out the status of each recommendation.  Once               #
#               parsed, the icon next to each of the recommendations reflects the #
#               outcome of each check.  The script also populates a result table  #
#               for each of the recommendations it checks.                        #
#                                                                                 #
# Version:      Quartus II 6.1                                                    #
#                                                                                 #
# Note:         This script is run from the Incremental Compilation Advisor.      #
#               This script is evaluated by quartus_cdb executable.               #
#               This script is passed in <project_name>, <revision_name>	      #
#               arguments by default.                           				  #
#                                                                                 #
# Author:       Shawn Malhotra (8/1/2006)                                        #
#                                                                                 #
# Licensing:    This script is  pursuant to the following license agreement       #
#               (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE               #
#               FOLLOWING): Copyright (c) 2004 Altera Corporation, San Jose,      #
#               California, USA.  Permission is hereby granted, free of           #
#               charge, to any person obtaining a copy of this software and       #
#               associated documentation files (the "Software"), to deal in       #
#               the Software without restriction, including without limitation    #
#               the rights to use, copy, modify, merge, publish, distribute,      #
#               sublicense, and/or sell copies of the Software, and to permit     #
#               persons to whom the Software is furnished to do so, subject to    #
#               the following conditions:                                         #
#                                                                                 #
#               The above copyright notice and this permission notice shall be    #
#               included in all copies or substantial portions of the Software.   #
#                                                                                 #
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,   #
#               EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES   #
#               OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND          #
#               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT       #
#               HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,      #
#               WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
#               FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR     #
#               OTHER DEALINGS IN THE SOFTWARE.                                   #
#                                                                                 #
#               This agreement shall be governed in all respects by the laws of   #
#               the State of California and by the laws of the United States of   #
#               America.                                                          #
#                                                                                 #
###################################################################################

###################################################################################
##  Procedure:  list_soft_regions
##
##  Arguments:  Recommendation key
##
##  Description:
##     Reports all logiclock regions set to Soft
##      
###################################################################################
proc list_soft_regions {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# the soft regions in the design.  The first row is the header
	set result_table [get_soft_regions]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {BOT_UP}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
}


###################################################################################
##  Procedure:  list_floating_regions
##
##  Arguments:  None
##
##  Description:
##     Reports all floating or auto-sized LogicLock regions in the design.
##      
###################################################################################
proc list_floating_regions {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# the floating regions in the design.  The first row is the header
	set result_table [get_floating_regions]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {BOT_UP}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
	
}

###################################################################################
##  Procedure:  list_partitions_with_unregisterd_ports
##
##  Arguments:  Recommendation key
##
##  Description:
##		Reports all unregistered ports on the design's partitioned modules.
##      
###################################################################################
proc list_partitions_with_unregistered_ports {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# the unregistered ports in the design.  The first row is the header
	set result_table [get_all_unregistered_ports]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {GEN}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
	
}

###################################################################################
##  Procedure:  list_partitions_with_unconnected_ports
##
##  Arguments:  Recommendation key
##
##  Description:
##    Reports all unconnected ports on the design's partitioned modules.
##      
###################################################################################
proc list_partitions_with_unconnected_ports {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# the unconnected ports in the design.  The first row is the header
	set result_table [get_all_unconnected_ports]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {GEN}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
}

###################################################################################
##  Procedure:  list_partitions_with_constant_ports
##
##  Arguments:  Recommendation key
##
##  Description:
##		Lists all ports on the design's partitioned modules connected to VCC/GND
##      
###################################################################################
proc list_partitions_with_constant_ports {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# the ports in the design connected to VCC or GND. The first row is the header.
	set result_table [get_all_constant_ports]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {GEN}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
}

###################################################################################
##  Procedure:  list_regions_with_bad_sizes
##
##  Arguments:  Recommendation key
##
##  Description:
##   Finds all partitions that consume <70% of used resources 
##   or > 95% of one type of resource
##      
###################################################################################
proc list_regions_with_bad_sizes {rec_key} {
	
	# This Tcl API passes back a properly formatted result table showing all of
	# the regions in the design that may be improperly sized.  The first row is
	# the header.
	set result_table [get_regions_with_bad_utilization]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {GEN}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
}

###################################################################################
##  Procedure:  list_overlapping_regions
##
##  Arguments:  Recommendation key
##
##  Description:  
##  	Finds all overlapping LogicLock regions.  They are reported pair-wise, so
##      if 3 regions overlap, it will be reported as 3 pairs of overlaps
##      
###################################################################################
proc list_overlapping_regions {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# the overlapping regions in the design.  The first row is the header
	set result_table [get_overlapping_regions]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {BOT_UP}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
}

###################################################################################
##  Procedure:  list_regions_containing_multiple_partitions
##
##  Arguments:  Recommendation key
##
##  Description:  
##  	Checks if a single LogicLock region contains logic from more than one
##      partition.
##      
###################################################################################
proc list_regions_containing_multiple_partitions {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# regions with more than one partition in the design.  The first row is the header
	set result_table [get_regions_containing_multiple_partitions]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {BOT_UP}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}	
}

###################################################################################
##  Procedure:  list_regions_to_move_closer
##
##  Arguments:  Recommendation key
##
##  Description:  Finds highly connected regions that are far apart and lists them.
##      
###################################################################################
proc list_regions_to_move_closer {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# the regions that are highly connected by relatively far apart from one 
	# another.  The first row is the header.
	set result_table [get_regions_to_move_closer_to_one_other]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {GEN}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
}

###################################################################################
##  Procedure:  list_partitions_with_multi_port_drivers
##
##  Arguments:  Recommendation key
##
##  Description: 
##		Lists all partitions that have a single driver feeding more than one
##      input port.  This can be problematic as it prohibits potential 
##      optimizations.
##      
###################################################################################
proc list_partitions_with_multi_port_drivers {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# partitions with a multi-port driver.  The first row is the header
	set result_table [get_partitions_with_multi_port_drivers]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {GEN}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
}

###################################################################################
##  Procedure:  list_partitions_with_directly_connected_ports
##
##  Arguments:  Recommendation key
##
##  Description: 
##		Lists all partitions that have ports directly connected to one another.
##      
###################################################################################
proc list_partitions_with_directly_connected_ports {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# partitions with a multi-port driver.  The first row is the header
	set result_table [get_partitions_with_directly_connected_ports]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {GEN}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
}

###################################################################################
##  Procedure:  list_partitions_that_need_dsp_budgeting
##
##  Arguments:  Recommendation key
##
##  Description: 
##		Lists all partitions that may need their DSP usage constrained.
##      
###################################################################################
proc list_partitions_that_need_dsp_budgeting {rec_key} {

	# This Tcl API passes back a properly formatted result table showing all of
	# partitions that may need DSP budgeting.  The first row is the header
	set result_table [get_partitions_that_need_dsp_budgeting]

	# Set the data table header in the Incremental Compilation Advisor.	
	set count 0

	foreach row $result_table {
		incr count
		if {$count == 1} {
			puts "oaw_add_header_internal {$row} -child {$rec_key}"
			puts "oaw_set_sort_column_internal {-1} -child {$rec_key}"	
			puts "oaw_set_icon_type_internal {c} -child {$rec_key}"
		} else {
			puts "oaw_add_row_internal {$row} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {$rec_key}"
			puts "oaw_set_icon_type_internal {w} -child {GEN}"
			puts "oaw_set_icon_type_internal {w}"			
		}
	}
}

###################################################################################
##  Procedure:  do_auto_check
##
##  Arguments:  None
##
##  Description:
##      Main function that calls all the others and takes care of some basic 
##      checks.
##
###################################################################################
proc do_auto_check {} {

	global quartus

	# Load necessary packages
	load_package report
	load_package flow
	load_package logiclock
	load_package qic_project_utilities
		
	set project_name ""
	set revision_name ""

	# Get the args
	set project_name [lindex $quartus(args) 0]
	set revision_name [lindex $quartus(args) 1]

	# Check if project_name is set
	if {$project_name == ""} {
		 return -code error "ERROR: No project name specified"
	}

	# Check if revision_name is set
	if {$revision_name == ""} {
		set revision_name [get_current_revision $project_name]
	}

	# Open project
	project_open $project_name -revision $revision_name

	puts "oaw_set_icon_type_internal {c}"
	puts "oaw_set_icon_type_internal {c} -child {BOT_UP}"
	puts "oaw_set_icon_type_internal {c} -child {GEN}"
	
	initialize_logiclock
	list_soft_regions SOFT_REG
	list_floating_regions LOCKED_REG
	list_partitions_with_unregistered_ports	REG_PORTS
	list_partitions_with_unconnected_ports UNCONN_PORTS
	list_partitions_with_constant_ports	CONST_PORTS
	list_regions_with_bad_sizes REGION_SIZE
	list_overlapping_regions OVERLAP_REG
	list_regions_containing_multiple_partitions LLR_OVERFLOW
	list_regions_to_move_closer CONNECTED_REG
	list_partitions_with_multi_port_drivers MULTI_PORT_DRIVER
	list_partitions_with_directly_connected_ports DIRECT_PORTS
	list_partitions_that_need_dsp_budgeting DSP_BUDGET
	uninitialize_logiclock
}

# Execute the procedure
do_auto_check
