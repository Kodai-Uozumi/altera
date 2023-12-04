###################################################################################
#                                                                                 #
# File Name:    oaw_check_stratixii.tcl                                           #
#                                                                                 #
# Summary:      This script is called by HardCopy II advisor.                     #
#               This script checks the following:                                 #
#               1. Check for Device Resource Guide to see if the column	          # 			  
#                  corresponding to the MIGRATION_DEVICE is set to high.          #
#               2. Check for Design Assistant Summary to see if the status        #
#                  is successful.                                                 #
#               3. Check for Timing Constraint Check to see if there are any 	  #
#                  unconstrained clocks/paths. If found an unconstrained clock 	  #
#                  or path (a non-zero value), report as failed.                  #
#                                                                                 #
#               This script produces the following table:                         #
#               Checking Area                       Status                        #		
#               -----------------------------------------------------             #
#               Timing Constraint Check             Failed/Successful	          #
#               Device Resource Guide Check         Failed/Successful             #
#               Design Assistant Check              Failed/Successful             #
#                                                                                 #
# Version:      Quartus II 5.0                                                    #
#                                                                                 #
# Note:         This script is run from the Quartus Optimization Advisor.         #
#               This script is evaluated by quartus_sh executable.                #
#               This script is passed in <project_name> and <revision_name> as    #
#               arguments by default.                                             #
#                                                                                 #
# Author:       Jim Dong (12/01/2004)                                             #
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
##  Procedure:  do_stratixii_check
##
##  Arguments:  None
##
##  Description:
##      Checks the following from compilation report:
##        Timing Constraint Check 
##        Device Resource Guide Check 
##        Design Assistant Check 
##      
###################################################################################
proc do_stratixii_check {} {

	set result 1

	global quartus

	# Load necessary packages
	load_package report
	load_package flow
	load_package misc
	
	set project_name ""
	set revision_name ""

	# Get the args
	set project_name [lindex $quartus(args) 0]
	set revision_name [lindex $quartus(args) 1]
	

	# Check if project_name is set
	if {$project_name == ""} {
		 return -code error "ERROR: No project name specified"
	}

	# check if revision_name is set
	if {$revision_name == ""} {
		set revision_name [get_current_revision $project_name]
	}

	# Open project
	project_open $project_name -revision $revision_name

	# Set the data table header in the Optimization Advisor.
	puts "oaw_add_header_internal {{Checking Area} {Status} {Reason}}"
	puts "oaw_set_sort_column_internal {-1}"

	set device_check 0
	set assistant_check 0
	set timing_check 0
	set timequest_is_on 0
	set io_check 0
	
	set timequest_setting [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER]
	if {[string equal -nocase "ON" $timequest_setting] == 1} {
		
		set timequest_is_on 1
	}

	# load report
	if [catch {load_report} err_stat] {
	    
	    # load_report failed, don't check the report
		puts "oaw_add_row_internal {{Device Resource Guide Check} {Report Unavailable} {}}"
		puts "oaw_add_row_internal {{Design Assistant Check} {Report Unavailable} {}}"
		if { $timequest_is_on } {
			puts "oaw_add_row_internal {{Timing Constraint Check} {Report Unavailable} {}}"
		} else {
			puts "oaw_add_row_internal {{TimeQuest Checks} {Report Unavailable} {}}"
		}	
	        puts "oaw_add_row_internal {{HardCopy Design Readiness Check} {Report Unavailable} {}}"
	
		set result 0
		
	} else {

	    # Check Device Resource Guide
	    set panel_name "Device Resource Guide"
	    
	    foreach panel [get_report_panel_names] {
			if {[string match "*$panel_name*" $panel] == 1} {
				
				set device_check 1
				
				# check the Device Resource Guide
				set check_status [check_device_resource_guide $panel]
				
				if { $check_status == 0 } {
					set result 0
				}
				break
			}
		}

		if { $device_check == 0 } {
			puts "oaw_add_row_internal {{Device Resource Guide Check} {Report Unavailable} {}}"
			set result 0
		}

	    # Check Design Assistant
	    set panel_name "Design Assistant Summary"
	    foreach panel [get_report_panel_names] {
			if {[string match "*$panel_name" $panel] == 1} {
				
				set assistant_check 1
				
				# check the Device Resource Guide
				set check_status [check_design_assistant $panel]

				if { $check_status == 0 } {
					set result 0
				}
				break
			}
	    }

		if { $assistant_check == 0 } {
			puts "oaw_add_row_internal {{Design Assistant Check} {Report Unavailable} {}}"
			set result 0
		}
		
	    # Check Timing Constraints
		if { $timequest_is_on == 1 } {	
			# USE_TIMEQUEST_TIMING_ANALYZER is ON
			check_timequest_ucp
			check_timequest_slack
			
		} else {

			set panel_name "Timing Constraint Check Summary"
			foreach panel [get_report_panel_names] {
				if {[string match "*$panel_name" $panel] == 1} {
					
					set timing_check 1
					
					# check the Device Resource Guide
					set check_status [check_timing_constraints $panel]
					
					if { $check_status == 0 } {
						set result 0
					}
					break
				}
			}
			
			if { $timing_check == 0 } {
				puts "oaw_add_row_internal {{Timing Constraint Check} {Report Unavailable} {}}"
				set result 0
			}
		}

	    # HardCopy Design Readiness Check
            foreach panel [get_report_panel_names] {

                    if {[string match "*Setting Check Summary" $panel] == 1 || [string match "*I/O Check Summary" $panel] == 1 || [string match "*PLL Usage Check Summary" $panel] == 1 || [string match "*RAM Usage Check Summary" $panel] == 1} {
                             set io_check 1

                             # check Summary Panel in HardCopy Design Readiness Check
                             set check_status [expr $check_status + [check_hardcopy_design_readiness $panel]]

                             if { $check_status == 0 } {
					set result 0
				}
			}
            }
            if { $io_check == 0 } {

                    puts "oaw_add_row_internal {{HardCopy Design Readiness Check} {Report Unavailable} {}}"
                    set result 0

            } elseif {$check_status == 0} {

                puts "oaw_add_row_internal {{HardCopy Design Readiness Check} {Successful} {}}"

            } else {

                  puts "oaw_add_row_internal {{HardCopy Design Readiness Check} {Failed} {$check_status Warning(s)}}"
            }
		
	    # Unload report
	    unload_report
	}
	
	project_close

	if { $result == 0 } {

		puts "oaw_set_icon_type_internal {w}"

	} else {

		if { $timequest_is_on == 1 } {

			puts "oaw_set_icon_type_internal {i}"

		} else {

			puts "oaw_set_icon_type_internal {c}"
		}
	}
	return 0;
}

###################################################################################
##  Procedure:  check_device_resource_guide
##
##  Arguments:  panel
##
##  Description:
##      Check for Device Resource Guide to see if the column
##      corresponding to the MIGRATION_DEVICE is set to high.
##
###################################################################################
proc check_device_resource_guide {panel} {

	set migration_device [get_global_assignment -name DEVICE_TECHNOLOGY_MIGRATION_LIST]

	set panel_id [get_report_panel_id $panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	set target_col_index 0
	set result 0

	# the first row is the header, so the row_cnt needs to be larger than 1
	if {$row_cnt > 1} {

		# go through all the column headers, find the column that matches the MIGRATION_DEIVCE
		for {set current_col_index 0} {$current_col_index < $col_cnt} {incr current_col_index} {
			set header [get_report_panel_data -row 0 -col $current_col_index -id $panel_id]

			set header [string trimleft $header]
			set header [string trimright $header]

			# if found a column that matches the MIGRATION_DEIVCE, check the 2nd row
			if {[string match "*$header*" $migration_device] == 1} {

				# check the 2nd row, see if it is set to "High"
				set current_row_index 1

				set target_cell [get_report_panel_data -row $current_row_index -col $current_col_index -id $panel_id]

				# if it is set to "High", means we found it.
				if {[string equal -nocase "High" $target_cell] == 1} {

					set target_col_index $current_col_index
					break

				}
			}
		}
	}

	# if $target_col_index > 0, means we found a successful match
	if {$target_col_index > 0} {
				
		puts "oaw_add_row_internal {{Device Resource Guide Check} {Successful} {}}"
		set result 1
		
	} else {
		
		puts "oaw_add_row_internal {{Device Resource Guide Check} {Failed} {Device Selected is Not Migratable}}"
		set result 0
	}

	return $result
}

###################################################################################
##  Procedure:  check_design_assistant
##
##  Arguments:  panel
##
##  Description:
##      Check for Design Assistant Summary to see if the status
##      is successful and has no critical and high violations.
##
###################################################################################
proc check_design_assistant {panel} {

	set panel_id [get_report_panel_id $panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	set critical_violations_row 0
	set high_violations_row 0
	set critical_violations 0
	set high_violations 0

	set da_check_good 0

	if {$row_cnt > 0} {

		if {$col_cnt > 1} {

			# go through all the rows, find the row shows "Total Critical Violations"
			for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
				
				set header [get_report_panel_data -row $current_row_index -col 0 -id $panel_id]

				set header [string trimleft $header]
				set header [string trimright $header]

				if {[string equal -nocase "Total Critical Violations" $header] == 1} {
				
					set critical_violations_row $current_row_index
				}

				if {[string equal -nocase "Total High Violations" $header] == 1} {
				
					set high_violations_row $current_row_index
				}
			}

			if {$critical_violations_row > 0 } {
			
				# get the status and check if the status is non-zero
				set status [get_report_panel_data -row $critical_violations_row -col 1 -id $panel_id]

				set status [string trimleft $status]
				set status [string trimright $status]
			
				if {$status == 0} {
				
					set da_check_good 1
					
				} else {
				
					# if found a non-zero value, means some violations are found
					set da_check_good 0
					set critical_violations $status
				}
			}

			# if there is no critical violation
			if {$da_check_good == 1 } {

				if {$high_violations_row > 0 } {
			
					# get the status and check if the status is non-zero
					set status [get_report_panel_data -row $high_violations_row -col 1 -id $panel_id]

					set status [string trimleft $status]
					set status [string trimright $status]

					if {$status == 0} {
						
						set da_check_good 1
						
					} else {
				
						# if found a non-zero value, means some violations are found
						set da_check_good 0
						set high_violations $status
					}
				}
			}
		}
	}
	
	if {$da_check_good == 1} {
		
		puts "oaw_add_row_internal {{Design Assistant Check} {Successful} {}}"
		
	} else {
		
		if {$critical_violations > 0 } {
			
			puts "oaw_add_row_internal {{Design Assistant Check} {Failed} {$critical_violations Critical Warning(s)}}"

		} elseif {$high_violations > 0 } {

			puts "oaw_add_row_internal {{Design Assistant Check} {Failed} {$high_violations High Warning(s)}}"
		} else {
			
			puts "oaw_add_row_internal {{Design Assistant Check} {Failed} {}}"
		}
	}

	return $da_check_good
}

###############################################################################################
##  Procedure:  check_hardcopy_design_readiness
##
##  Arguments:  panel
##
##  Description:
##      Check for All HCDR Summary Panel to see if the status
##      is successful and has no warning/error/failed messages
################################################################################################
proc check_hardcopy_design_readiness {panel} {

        set panel_id [get_report_panel_id $panel]

        set row_cnt [get_number_of_rows -id $panel_id]
        set col_cnt [get_number_of_columns -id $panel_id]

        set io_check_good 0

        # the first row is the header, so the row_cnt needs to be larger than 1
        if {$row_cnt > 1} {

                if {$col_cnt > 1} {

                        for {set current_row_index 1} {$current_row_index < $row_cnt} {incr current_row_index} {

                               set status_type [get_report_panel_data -row $current_row_index -col 1 -id $panel_id]

                               set status_type [string trimleft $status_type]
                               set status_type [string trimright $status_type]

                               if {![string equal -nocase "Successful" $status_type] == 1} {

                                     set io_check_good [expr $io_check_good + 1]
                               }
                        }
                }
        }
        return $io_check_good
}

###################################################################################
##  Procedure:  check_timing_constraints
##
##  Arguments:  panel
##
##  Description:
##      Check for Timing Constraint Check to see if there are any
##      unconstrained clocks/paths. If found an unconstrained clock
##      or path (a non-zero value), report as failed.
##
###################################################################################
proc check_timing_constraints {panel} {

	set panel_id [get_report_panel_id $panel]
	
	set row_cnt [get_number_of_rows -id $panel_id]
	set col_cnt [get_number_of_columns -id $panel_id]

	set timing_check_good 0
	set header ""
	set status 0

	if {$row_cnt > 0} {

		if {$col_cnt > 1} {

			set timing_check_good 1

			# go through all the rows, find the row shows "Unconstrained"
			for {set current_row_index 0} {$current_row_index < $row_cnt} {incr current_row_index} {
				
				set header [get_report_panel_data -row $current_row_index -col 0 -id $panel_id]

				set header [string trimleft $header]
				set header [string trimright $header]

				if {[string match "*Unconstrained*" $header] == 1} {
				
					set status [get_report_panel_data -row $current_row_index -col 1 -id $panel_id]

					set status [string trimleft $status]
					set status [string trimright $status]

					if {$status == 0} {
						
						# do nothing

					} else {

						# if found a non-zero value, means some paths are not unconstrained.
						set timing_check_good 0
						
						break
					}
				}
			}
		}
	}

	if {$timing_check_good == 1} {

		puts "oaw_add_row_internal {{Timing Constraint Check} {Successful} {}}"
		
	} else {

		if {$status > 0} {
			
			puts "oaw_add_row_internal {{Timing Constraint Check} {Failed} {$status $header}}"
		} else {

			puts "oaw_add_row_internal {{Timing Constraint Check} {Failed} {}}"
		}
	}

	return $timing_check_good
}

###################################################################################
##  Procedure:  check_timequest_ucp
##
##  Description:
##      Check for TimeQuest panels to see if design is fully constraint
##
###################################################################################
proc check_timequest_ucp {} {

	set panel "*TimeQuest Timing Analyzer*Unconstrained Paths*Summary"
	set panel_id [get_report_panel_id $panel]

	if { $panel_id == -1 } {
		set panel "*TimeQuest Timing Analyzer*Unconstrained Paths"
		set panel_id [get_report_panel_id $panel]
	}
		
	if { $panel_id != -1 } {
		
		set row_cnt [get_number_of_rows -id $panel_id]

		set check_hold 0
		set check_setup 0

		# go through all the rows, find the row shows "Unconstrained"
		for {set current_row_index 1} {$current_row_index < $row_cnt} {incr current_row_index} {
			
			set value [get_report_panel_data -row $current_row_index -col_name "Setup"  -id $panel_id]

			if {$value == 0} {

				# do nothing

			} else {

				# if found a non-zero value, means some paths are not unconstrained.
				set check_setup [expr $check_setup + $value]

			}

			set value [get_report_panel_data -row $current_row_index -col_name "Hold"  -id $panel_id]

			if {$value == 0} {

				# do nothing

			} else {

				# if found a non-zero value, means some paths are not unconstrained.
				set check_hold [expr $check_hold + $value]
			}
		}

		if {$check_setup == 0 && $check_hold == 0} {

			puts "oaw_add_row_internal {{Unconstrained Paths Check} {Successful} {}}"
			
		} elseif {$check_setup == 0 && $check_hold != 0} {

                        puts "oaw_add_row_internal {{Unconstrained Paths Check} {Failed} {$check_hold Hold Unconstrained Paths}}"

                } elseif {$check_setup != 0 && $check_hold == 0} {

                        puts "oaw_add_row_internal {{Unconstrained Paths Check} {Failed} {$check_setup Setup Unconstrained Paths}}"
                } else {

                        puts "oaw_add_row_internal {{Unconstrained Paths Check} {Failed} {$check_setup Setup and $check_hold Hold Unconstrained Paths}}"
                }
        } else {
                puts "oaw_add_row_internal {{Unconstrained Paths Check} {Report Unavailable} {}}"
	}
}

###################################################################################
##  Procedure:  check_timequest_slack
##
##  Description:
##      Check for TimeQuest panels to see if timing is met
##
###################################################################################
proc check_timequest_slack {} {

	set panel_type_list "Setup Hold Recovery Removal"
	foreach panel_type $panel_type_list {

		set timing_check_good 0
		set panel_name "*TimeQuest Timing Analyzer*${panel_type} Summary"
		set found_panel 0

                foreach panel [get_report_panel_names] {
                        if {[string match $panel_name $panel] == 1} {

                           set found_panel 1
		           set panel_id [get_report_panel_id $panel]
                           set row_cnt 0

		           if { $panel_id != -1 } {
                              if { [ catch {set row_cnt [get_number_of_rows -id $panel_id]} ]} {
                                 set row_cnt 0
                              }
                           }

                           if { $row_cnt > 0 } {

			      # go through all the rows, find the row shows "non-positive value"
			      for {set current_row_index 1} {$current_row_index < $row_cnt} {incr current_row_index} {

                                  set value [get_report_panel_data -row $current_row_index -col_name "Slack"  -id $panel_id]

    				if [expr double($value) > 0.0] {
    					# do nothing

    				} else {

    					# if found a non-positive value.
    					set timing_check_good [expr $timing_check_good + 1]
    				}
                              }
                           }
                        }
                }
                if {$timing_check_good == 0 && $found_panel == 1} {

                   puts "oaw_add_row_internal {{$panel_type Slack Check} {Successful} {}}"

                } elseif {$found_panel == 1} {

                   puts "oaw_add_row_internal {{$panel_type Slack Check} {Failed} {$timing_check_good Slack Violation(s)}}"
                
                } else {

                   puts "oaw_add_row_internal {{$panel_type Slack Check} {Report Unavailable} {}}"
                }

	}
}

###################################################################################
##  Procedure:  get_all_pins
##
##  Arguments: type
##
##  Description:
##      Get the Input, Output, and Bidir Pins
##
###################################################################################
proc get_all_pins {type pins} {

	set pin_name_id [get_names -filter * -node_type $type -observable_type post_synthesis]
	foreach_in_collection name_id $pin_name_id {

		# Get the full path name of the node
		set target [get_name_info -info full_path $name_id]

		lappend pins $target
	}

	return $pins
}

###################################################################################
##  Procedure:  check_io_assignments
##
##  Arguments: pins, acf
##
##  Description:
##      Go through all the pins to see if they all have the required I/O assignments.
##
###################################################################################
proc check_io_assignments {pins acf} {

	set result 0
	
	set acfval [get_all_instance_assignments -name $acf]
	set num [llength $acfval]

	if {$num > 0} {
		
		foreach pin $pins {
			
			if {$pin == "*"} {

				continue
			}

			set result 0

			foreach_in_collection asgn $acfval {

				## Each element in the collection has the following
				## format: { {} {<Source>} {<Destination>} {<Assignment name>} 
				##         {<Assignment value>} {<Entity name>} {<Tag data>} }
				set to_pin     [lindex $asgn 2]

				if {$to_pin == $pin} {
					
					set result 1
					
					break

				} elseif {[string match -nocase "$to_pin" "$pin"] == 1} {
					
					set result 1
					
					break
				}

				# if a pin doesn't have an assignment, but if the pin belongs to a bus,
				# check if the bus has an assignment.
				if {$result == 0} {

					set bus_name [get_bus_name $pin]
					
					if {[string length $bus_name] > 0} {
						
						if {[string match $to_pin $bus_name] == 1} {
					
							set result 1
							
							break
						}
					}
				}
			}
	
			if {$result == 0} {
				#puts "oaw_add_row_internal {{$pin} {has no} {$acf}}"
				
				break
			}
		}
	}

	return $result
}

##################################################################################
##  Procedure:  get_bus_name
##
##  Arguments: pin
##
##  Description:
##      parse the pin name to get the bus name if it belongs to a bus.
##
###################################################################################
proc get_bus_name {pin} {

	set bus_name ""
	
	if {[string match "*\]" $pin] == 1} {
		
		set idx [string first "\[" $pin 0]
		
		set bus_name [string range $pin 0 [expr $idx - 1]]
	}
	
	return $bus_name
}

# Execute the procedure
do_stratixii_check
