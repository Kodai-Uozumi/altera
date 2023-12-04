###################################################################################
#                                                                                 #
# File Name:    oaw_qic_process_timing.tcl                                        #
#                                                                                 #
# Summary:      This script is called by the Incremental Compilation Advisor      #
#               on the user's command.  It checks the status of each of the       #
#               recommendations that DO need timing information.  These           #
#               recommendations are defined in the Advisor's XML file.  It also   #
#               writes out the status of each recommendation.  Once               #
#               parsed, the icon next to each of the recommendations reflects the #
#               outcome of each check.  The script will also create a table of    #
#				results that is displayed on the appropriate recommendation's     #
#               panel.                                                            #
#                                                                                 #
# Version:      Quartus II 6.1                                                    #
#                                                                                 #
# Note:         This script is run from the Incremental Compilation Advisor.      #
#               This script is evaluated by quartus_tan executable.               #
#               This script is passed in <project_name>, <revision_name>,         #
#               arguments by default.                                             #
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

#  Packages required by this script
package require ::quartus::project
package require ::quartus::misc
package require ::quartus::qic_project_utilities
package require report
package require struct

#  Several global variables are used
global partition_array
global port_hash
global partition_name_array
global edge_list
global sorted_edge_list
global hierarchy_edge_count_array
global hierarchy_wc_slack_array
global path_list
global sorted_path_list
global partition_cost
global partition_edge_count_array
global partition_wc_slack_array
global partition_path_count_array
global partition_delay_array
global num_critical_intrapartition_edges_array
global num_critical_interpartition_edges_array
global wc_interpartition_slack
global wc_intrapartition_slack
global big_slack

###################################################################################
##  Procedure:  populate_partition_info
##
##  Arguments:  None
##
##  Description:
##  	Looks at the PARTITION_HIERARCHY assignments to create a list of modules
##      in partitions and a list of partition names.
##
###################################################################################
proc populate_partition_info {} {
    array set ::partition_array {}
    set ::big_slack 9999999
    set partition_asgns [get_all_instance_assignments -name PARTITION_HIERARCHY]
    foreach_in_collection asgn $partition_asgns {
      set from   [lindex $asgn 1]
      set to     [lindex $asgn 2]
      set name   [lindex $asgn 3]
      set value  [lindex $asgn 4]
      set entity [lindex $asgn 5]
      set tag    [lindex $asgn 6]
      set ::partition_array($to) 1
      set ::partition_name_array($to) [lindex $asgn 0]
      set ::num_critical_intrapartition_edges_array($to) 0
      set ::num_critical_interpartition_edges_array($to) 0
      set ::wc_intrapartition_slack($to) $::big_slack
      set ::wc_interpartition_slack($to) $::big_slack
    }
}

###################################################################################
##  Procedure:  populate_edge_info
##
##  Arguments:  None
##
##  Description:
##		Get a list of all of the timing edges in the design and sort them by slack
##
###################################################################################
proc populate_edge_info {} {

    set ::edge_list {}
    foreach_in_collection edge [get_timing_edges] {
        lappend ::edge_list [list $edge [lindex [get_timing_edge_info -info slack $edge] 0]]
    }
    #  Each member of the sorted edge list is of the form (<timing_edge>, <slack>)
    set ::sorted_edge_list [lsort -real -index 1 $::edge_list]
}

###################################################################################
##  Procedure:  get_hierarchy
##
##  Arguments:  hpath of the module whose hierarchy we're getting
##
##  Description:
##		Given an hpath, return the design hierarchy it falls under.
##
###################################################################################
proc get_hierarchy {hpath} {
    set tmp [string last "|" $hpath]
    set hierarchy [string range $hpath 0 [expr $tmp - 1]]
    
    if {[string length $hierarchy] > 0} {
        return $hierarchy
    } else {
        return "|"
    }
}

###################################################################################
##  Procedure:  get_partition
##
##  Arguments:  hpath of the module whose partition we're getting
##
##  Description:
##		Given an hpath, return the partition it belongs to.
##
###################################################################################
proc get_partition {hpath} {
    if {[array size ::partition_array] > 0} {
        set hierarchy [get_hierarchy $hpath]
        if {[catch {set ::partition_array($hierarchy)}]} {
            return [get_partition $hierarchy]
        } else {
            return $hierarchy
        }
    } else {
        return
    }
}

###################################################################################
##  Procedure:  populate_port_hash
##
##  Arguments:  None.
##
##  Description:
##		Calls into the API provided in the LogicLock II package to get a list of
##      boundary connection information that includes the src/dst ports of the
##      connection as well as the src/dst oterm names and the input port type. 
##      Having all of this information allows us to map a timing edge to a
##      boundary connection by verifying the src/dst oterms match as well as the
##      iterm type.  This, in turn, allows us to get the src/dst port names to
##      display in the table.
##
###################################################################################
proc populate_port_hash {} {
	
	set conn_table [get_boundary_connection_list]
	
	foreach table_entry $conn_table {		
		set src_name ""
		set destinations {}
		set input_port ""
		set output_port ""
		set iterm_type ""
		
		foreach element $table_entry {			
	        set identifier ""
	        set value ""
			regexp {([A-Za-z_]+)=(\S+)} $element dummy identifier value
	
			if {[string compare -nocase "$identifier" "SOURCE"] == 0} {
				set src_name $value
			}
			if {[string compare -nocase "$identifier" "DESTINATION"] == 0} {
				lappend destinations $value
			}
			if {[string compare -nocase "$identifier" "INPUT_PORT_NAME"] == 0} {
				set input_port $value
			}
			if {[string compare -nocase "$identifier" "OUTPUT_PORT_NAME"] == 0} {
				set output_port $value
			}
			if {[string compare -nocase "$identifier" "ITERM_TYPE"] == 0} {
				set iterm_type $value
			}
		}
		
		#  We store the information in a hash based on the src name, potential
		#  destination name (note that each src can have more than one dst oterm)
		#  and the iterm type.  If these 3 things match the src/dst/iterm type of
		#  a timing edge, then the hash_value contains the src/destination port
		#  names for the timing edge.
		set hash_value [list $input_port $output_port]
		foreach dst $destinations {
			set hash_key "$src_name*$dst*$iterm_type"
			set ::port_hash($hash_key) $hash_value
		}
	}		
}

###################################################################################
##  Procedure:  populate_edge_stats_info
##
##  Arguments:  Max number of edges to get information on.
##
##  Description:
##		Goes through the edge info we got earlier and identifies all of the edges
##      with oterms in different partitions where the edge is critical.  It then
##      adds the inter-partition edge to the wc-slack / number of edge arrays,
##      which are indexed by src/dst partition.
##
###################################################################################
proc populate_edge_stats_info {num_edges} {
    set slack_threshold 0
    array set ::hierarchy_edge_count_array {}
    array set ::hierarchy_wc_slack_array {}
    array set ::partition_edge_count_array {}
    array set ::partition_wc_slack_array {}
        
    for {set i 0} {$i < $num_edges && $i < [llength $::sorted_edge_list]} {incr i} {

        set edge_pair [lindex $::sorted_edge_list $i]
        set edge  [lindex $edge_pair 0]
        set slack [lindex $edge_pair 1]

        #  Skip non-critical edges
        if {$slack >= $slack_threshold} {
            break
        }

        #  Get the src/destination partitions
        set src_node [get_timing_edge_info -info src_node $edge]
        set dst_node [get_timing_edge_info -info dst_node $edge]
        set src_name [get_timing_node_info -info name $src_node]
        set dst_name [get_timing_node_info -info name $dst_node]

        set src_partition [get_partition $src_name]
        set dst_partition [get_partition $dst_name]
                
        if {[string length $src_partition] > 0 &&
                [string length $dst_partition] > 0} {
	                
	        #  The arrays are indexed on a hash of the src/dst partition names. We
	        #  don't want to have the order matter (since we don't care about the
	        #  direction of the connection) so we sort the informatio to ensure
	        #  it maps to the same value both ways
	        if {[string compare $src_partition $dst_partition] < 0} {
		        set rindex [list $src_partition $dst_partition $edge]
		        set rindex_no_edge [list $src_partition $dst_partition]
	        } else {
		        set rindex [list $dst_partition $src_partition $edge]
		        set rindex_no_edge [list $dst_partition $src_partition]
	        }
	        
            if {[catch {set ::partition_edge_count_array($rindex_no_edge)}]} {
                set ::partition_edge_count_array($rindex_no_edge) 1
            } else {
                incr ::partition_edge_count_array($rindex_no_edge)
            }
            
            #  The hash for the wc slack has to have the edge as part of its
            #  index, since there can be multiple edges between the partitions and
            #  they need to be reported uniquely.
            if {[catch {set ::partition_wc_slack_array($rindex)}]} {
                set ::partition_wc_slack_array($rindex) $slack
            }
            
            #  This means this was an inter-partition edge
 			if {[string compare $src_partition $dst_partition] != 0} {
	 			if {[catch {set ::num_critical_interpartition_edges_array($src_partition)}]} {
	 				set ::num_critical_interpartition_edges_array($src_partition) 1
	 				set ::wc_interpartition_slack($src_partition) $slack
 				} else {
	 				incr ::num_critical_interpartition_edges_array($src_partition)
	 				if {$slack < $::wc_interpartition_slack($src_partition)} {
		 				set ::wc_interpartition_slack($src_partition) $slack
	 				}
 				} 				
 				
 				if {[catch {set ::num_critical_interpartition_edges_array($dst_partition)}]} {
	 				set ::num_critical_interpartition_edges_array($dst_partition) 1
	 				set ::wc_interpartition_slack($dst_partition) $slack
 				} else {
	 				incr ::num_critical_interpartition_edges_array($dst_partition)				
	 				if {$slack < $::wc_interpartition_slack($dst_partition)} {
		 				set ::wc_interpartition_slack($dst_partition) $slack
	 				}
				}
	 		#  This was an intra-partition edge, add 1
 			} else {
 				if {[catch {set ::num_critical_intrapartition_edges_array($dst_partition)}]} {
	 				set ::num_critical_intrapartition_edges_array($dst_partition) 1
	 				set ::wc_intrapartition_slack($dst_partition) $slack
 				} else {
	 				incr ::num_critical_intrapartition_edges_array($dst_partition)
	 				if {$slack < $::wc_intrapartition_slack($dst_partition)} {
		 				set ::wc_intrapartition_slack($dst_partition) $slack
	 				}
				}	 			
 			}
		}
    }
}

###################################################################################
##  Procedure:  generate_advisor_output
##
##  Arguments:  Recommendation key of the panel the advisor should write to.
##
##  Description:
##		Goes through all of the critical inter-partition connections and writes
##      out the appropriate information to the proper recommendation panel in the
##      advisor.
##
###################################################################################
proc generate_advisor_output {rec_key1 rec_key2} {
    set array_names [array names ::partition_wc_slack_array]
    set sorted_array_names [lsort $array_names]
    
	puts "oaw_add_header_internal {{Slack (ns)}{Source Partition}{Destination Partition}{Source Node}{Destination Node}{Source Port}{Destination Port}} -child {$rec_key1}"
	puts "oaw_set_sort_column_internal {0:d:a} -child {$rec_key1}"	    
	puts "oaw_set_icon_type_internal {c} -child {$rec_key1}"
		
    foreach array_name $sorted_array_names {
	    if {[string compare [lindex $array_name 0] [lindex $array_name 1]] != 0} {
		    set edge   [lindex $array_name 2]
	        set src_node [get_timing_edge_info -info src_node $edge]
	        set dst_node [get_timing_edge_info -info dst_node $edge]
		    set port_type [get_timing_edge_info -info wysiwyg_port_type $edge]
	        set src_name [get_timing_node_info -info name $src_node]
	        set dst_name [get_timing_node_info -info name $dst_node]
		    set part_1 $::partition_name_array([get_partition $src_name])
		    set part_2 $::partition_name_array([get_partition $dst_name])
		    set slack_val $::partition_wc_slack_array($array_name)		    
		    set input_port_name "N/A"
		    set output_port_name "N/A"
		    
		    set hash_key "$src_name*$dst_name*$port_type"		  
		    if {[catch {set ::port_hash($hash_key)}] == 0} {
			    set input_port_name [lindex $::port_hash($hash_key) 0]
			    set output_port_name [lindex $::port_hash($hash_key) 1]			    
		    }
		    
			puts "oaw_add_row_internal {{$slack_val}{$part_1}{$part_2}{$src_name}{$dst_name}{$output_port_name}{$input_port_name}} -child {$rec_key1}"	    
			puts "oaw_set_icon_type_internal {w} -child {$rec_key1}"
			puts "oaw_set_icon_type_internal {w} -child {TIMING}"
			puts "oaw_set_icon_type_internal {w}"			
    	}
    }
    
	puts "oaw_add_header_internal {{Partition}{# Critical Intrapartition Edges}{# Critical Interpartition Edges}{Worst Intrapartition Slack (ns)}{Worst Interpartition Slack (ns)}} -child {$rec_key2}"
	puts "oaw_set_icon_type_internal {c} -child {$rec_key2}"
	
	set partition_names [array names ::partition_name_array]
	foreach partition $partition_names {
		set inter $::num_critical_interpartition_edges_array($partition)
		set intra $::num_critical_intrapartition_edges_array($partition)
		set wc_inter $::wc_interpartition_slack($partition)
		set wc_intra $::wc_intrapartition_slack($partition)
		
		if {$wc_inter == $::big_slack} {
			set wc_inter "N/A"
		}
		
		if {$wc_intra == $::big_slack} {
			set wc_intra "N/A"
		}
		puts "oaw_add_row_internal {{$::partition_name_array($partition)}{$intra}{$inter}{$wc_intra}{$wc_inter}} -child {$rec_key2}"		
		
		if {$inter > 0 || $intra > 0} {
			puts "oaw_set_icon_type_internal {w} -child {$rec_key2}"
			puts "oaw_set_icon_type_internal {w} -child {TIMING}"
			puts "oaw_set_icon_type_internal {w}"
		}
	}
    
}

###################################################################################
##  Procedure:  qic_statistics
##
##  Arguments:  Maximum number of edges to report
##
##  Description:
##		Calls the procedures we've outlined here to generate the advisor output
##
###################################################################################
proc qic_statistics {{num_edges 1000000}} {

	set ok 1
	
	if {[catch {create_timing_netlist} err]} {
		set ok 0
	}
	
	if {$ok == 1} {
	    compute_slack_on_edges
	    create_p2p_delays
	
	    populate_port_hash
	    populate_partition_info
	    populate_edge_info
	    populate_edge_stats_info $num_edges
	
		generate_advisor_output CRIT_PATH CAPTURE_CRIT_PATH
	    
	    delete_timing_netlist
    } else {
		puts "oaw_add_header_internal {{Error}} -child {CRIT_PATH}"
		puts "oaw_add_row_internal {{Please place and route your design to see timing dependent rules}} -child {CRIT_PATH}"		
		puts "oaw_set_icon_type_internal {w} -child {CRIT_PATH}"		
		puts "oaw_add_header_internal {{Error}} -child {CAPTURE_CRIT_PATH}"
		puts "oaw_add_row_internal {{Please place and route your design to see timing dependent rules}} -child {CAPTURE_CRIT_PATH}"		
		puts "oaw_set_icon_type_internal {w} -child {CAPTURE_CRIT_PATH}"								
		puts "oaw_set_icon_type_internal {w} -child {TIMING}"	    
    }
}


###################################################################################
##  Procedure:  do_auto_check
##
##  Arguments:  None
##
##  Description:
##      Main function.
##
###################################################################################
proc do_auto_check {} {

	global quartus
	
	load_package flow
	load_package device
	
	set project_name ""
	set revision_name ""
	
	# Get the args
	set project_name  [lindex $quartus(args) 0]
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

    set sta_on 0
    if {[get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] == ""} {
		if {[test_family_trait_of -family [get_global_assignment -name FAMILY] -trait USE_STA_BY_DEFAULT]} {
			set sta_on 1
		}
	} else {
		if {[string equal -nocase [get_global_assignment -name USE_TIMEQUEST_TIMING_ANALYZER] "on"]} {
			set sta_on 1
		}
	}  
	
	set qic_on [string equal -nocase [get_global_assignment -name INCREMENTAL_COMPILATION] "FULL_INCREMENTAL_COMPILATION"]
    
    # STA is not supported here
    if {$sta_on} {	
		puts "oaw_add_header_internal {{Error}} -child {CRIT_PATH}"
		puts "oaw_add_row_internal {{Design uses TimeQuest Timing Analyzer, please use \"TimeQuest Timing Analyzer - Check Timing Dependent Recommendations\"}} -child {CRIT_PATH}"
		puts "oaw_set_icon_type_internal {w} -child {CRIT_PATH}"		
		puts "oaw_add_header_internal {{Error}} -child {CAPTURE_CRIT_PATH}"
		puts "oaw_add_row_internal {{Design uses TimeQuest Timing Analyzer, please use \"TimeQuest Timing Analyzer - Check Timing Dependent Recommendations\"}} -child {CAPTURE_CRIT_PATH}"
		puts "oaw_set_icon_type_internal {w} -child {CAPTURE_CRIT_PATH}"						
		puts "oaw_set_icon_type_internal {w} -child {TIMING}"
	} elseif {!$qic_on} {
		puts "oaw_add_header_internal {{Error}} -child {CRIT_PATH}"
		puts "oaw_add_row_internal {{Advisor requires Full Incremental Compilation to be enabled}} -child {CRIT_PATH}"		
		puts "oaw_set_icon_type_internal {w} -child {CRIT_PATH}"		
		puts "oaw_add_header_internal {{Error}} -child {CAPTURE_CRIT_PATH}"
		puts "oaw_add_row_internal {{Advisor requires Full Incremental Compilation to be enabled}} -child {CAPTURE_CRIT_PATH}"		
		puts "oaw_set_icon_type_internal {w} -child {CAPTURE_CRIT_PATH}"								
		puts "oaw_set_icon_type_internal {w} -child {TIMING}"
	} else {

		# SPR:283558
		package require ::quartus::timing
		package require ::quartus::advanced_timing

		# Default the icon to the checker, it will be set to a warning if
		# appropriate
		puts "oaw_set_icon_type_internal {c}"
		puts "oaw_set_icon_type_internal {c} -child {TIMING}"			
			
		set num_edges 1000000	
		qic_statistics $num_edges
	}
	
	project_close

}

# Execute the procedure
do_auto_check
