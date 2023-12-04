#//START_MODULE_HEADER///////////////////////////////////////////////////////
#
#  Filename:    tcl_client.tcl
#
#  Description: Tcl package for quartus-tcl client
#         
#
#  Authors:     Altera Corporation
#
#               Copyright (c)  Altera Corporation 1999 - 2002
#               All rights reserved.
#
#
#//END_MODULE_HEADER/////////////////////////////////////////////////////////

package provide quartus_client 1.0

# Conventions:
#  * All user functions and variables begin with q_
#  * All internal variables and functions begin with _q_



set q_info_msg_cnt 0
set q_err_msg_cnt 0
set q_warn_msg_cnt 0

## maximum time to wait for server to respond(in milliseconds)
#set q_max_wait 30000

# infinite wait time( this is the default now)
set q_max_wait -1

## polling delay in checking for server output(in milliseconds)
set q_polling_delay 100

## socket command
set q_socket_cmd_name socket

set _q_srvr_didnt_respond 0
set _q_server_connection_broken 0
set _q_initiated_shutdown 0

proc q_project_exists { path } {
	_q_helper "project exists {$path}"
}
proc q_project_open { path } {
	_q_helper "project open {$path}"
}
proc q_project_create { path } {
	_q_helper "project create {$path}"
}
proc q_project_close { } {
	_q_helper "project close"
}
proc q_project_archive { path } {
	_q_helper "project archive {$path}"
}
proc q_project_restore { name path} {
	_q_helper "project archive {$name} {$path}"
}
proc q_project_start_batch { entity } {
	_q_helper "project start_batch {$entity}"
}
proc q_project_end_batch { entity } {
	_q_helper "project end_batch {$entity}"
}
proc q_project_cmp_exists { cmp } {
	_q_helper "project cmp_exists {$cmp}"

}
proc q_project_create_cmp { cmp } {
	_q_helper "project create_cmp {$cmp}"

}
proc q_project_set_active_cmp { cmp } {
	_q_helper "project set_active_cmp {$cmp}"

}
proc q_project_sim_exists { sim } {
	_q_helper "project sim_exists {$sim}"

}
proc q_project_create_sim { sim } {
	_q_helper "project create_sim {$sim}"

}
proc q_project_set_active_sim { sim } {
	_q_helper "project set_active_sim {$sim}"

}
proc q_project_add_assignment { entity sect_id src target variable value } {
	_q_helper "project add_assignment {$entity} {$sect_id} {$src} {$target} {$variable} {$value}"

}
proc q_project_remove_assignment { entity sect_id src target variable value } {
	_q_helper "project remove_assignment {$entity} {$sect_id} {$src} {$target} {$variable} {$value}"
}

proc q_project_get_all_assignments { entity sect_id src target } {
	_q_helper "project get_all_assignments {$entity} {$sect_id} {$src} {$target}"
}

proc q_project_get_assignment_count { entity sect_id src target } {
	_q_helper "project get_assignment_count {$entity} {$sect_id} {$src} {$target}"
}
proc q_project_get_assignment_value { entity sect_id src target variable } {
	_q_helper "project get_assignment_value {$entity} {$sect_id} {$src} {$target} {$variable}"
}
proc q_project_get_all_default_parameters { } {
	_q_helper "project get_all_default_parameters"
}
proc q_project_get_default_parameter_value { name } {
	_q_helper "project get_default_parameter_value {$name}"
}
proc q_project_add_default_parameter { name value } {
	_q_helper "project add_default_parameter_value {$name} {$value}"
}
proc q_project_remove_default_parameter { name } {
	_q_helper "project remove_default_parameter_value {$name}"
}



proc q_device_set_timing_variable { env_var_name env_var_value} {
	_q_helper "device set_timing_variable {$env_var_name} {$env_var_value}"
}
proc q_device_reset_timing_variables {} {
	_q_helper "device reset_timing_variables"
}
proc q_device_display_timing_variables {} {
	_q_helper "device display_timing_variables"
}
proc q_device_get_family_count { } {
	_q_helper "device get_family_count"
}
proc q_device_get_family_name_by_index { index } {
	_q_helper "device get_family_name_by_index {$index}"
}
proc q_device_get_device_count { family_name } {
	_q_helper "device get_device_count {$family_name}"
}
proc q_device_get_device_name_by_index {family_name index} {
	_q_helper "device get_device_name_by_index {$family_name} {$index}"
}
proc q_device_get_die_name {family_name device_name} {
	_q_helper "device get_die_name {$family_name} {$device_name}"
}
proc q_device_get_package_name {family_name device_name} {
	_q_helper "device get_package_name {$family_name} {$device_name}"
}
proc q_device_get_speed_grade {family_name device_name} {
	_q_helper "device get_speed_grade {$family_name} {$device_name}"
}
proc q_device_get_dmf_info {family_name device_name node_type src_type dest_type node_path } {
_q_helper "device get_dmf_info {$family_name} {$device_name} {$node_type} {$src_type} {$dest_type} {$node_path}"
}
proc q_device_get_timing {family_name device_name cell_type src_type dest_type } { 
	_q_helper "device get_timing {$family_name} {$device_name} {$cell_type} {$src_type} {$dest_type}"
}
proc q_device_get_timingex {family_name device_name hierarchy } {
	_q_helper "device get_timingex {$family_name} {$device_name} {$hierarchy}"
}
proc q_device_get_routing_line_length {family_name device_name routing_line_type } {
	_q_helper "device get_routing_line_length {$family_name} {$device_name} {$routing_line_type}"
}
proc q_device_get_clock_ic_delay {family_name device_name dst_row dst_gol_col dst_col global_clock } {
_q_helper "device get_clock_ic_delay {$family_name} {$device_name} {$dst_row} {$dst_gol_col} {$dst_col} {$global_clock}"
}
proc q_device_get_routing_line_delay {family_name device_name fanout_array_string src_location routing_line_type } {
	_q_helper "device get_routing_line_delay {$family_name} {$device_name} {$fanout_array_string} {$src_location} {$routing_line_type}"
}
proc q_device_get_routing_line_to_line_delay {family_name device_name src_routing_line dest_routing_line } {
	_q_helper "device get_routing_line_to_line_delay {$family_name} {$device_name} {$src_routing_line} {$dest_routing_line}"
}
proc q_device_get_local_line_delay {family_name device_name lut_type use_pia from_gh} {
	_q_helper "device get_local_line_delay {$family_name} {$device_name} {$lut_type} {$use_pia} {$from_gh}"
}
proc q_device_get_row_type {family_name device_name row } {
_q_helper "device get_row_type {$family_name} {$device_name} {$row}"
}
proc q_device_get_timing_variable {variable_name} {
	_q_helper "device get_timing_variable {$variable_name}"
}
proc q_device_get_estimated_timing {family_name device_name fanout_num region_type} {
	_q_helper "device get_estimated_timing {$family_name} {$device_name} {$fanout_num} {$region_type}"
}
proc q_device_get_device_resource_count {family_name device_name resource_type} { 
	_q_helper "device get_device_resource_count {$family_name} {$device_name} {$resource_type}"
}


proc q_cmp_start { } {
	_q_helper "cmp start"
}
proc q_cmp_stop { }       {
	_q_helper "cmp stop"
}
proc q_cmp_is_running { }   {
	_q_helper "cmp is_running"
}
proc q_cmp_start_batch { }   {
	_q_helper "cmp start_batch"
}
proc q_cmp_end_batch { }   {
	_q_helper "cmp end_batch"
}
proc q_cmp_add_assignment { sect_id src target variable value } {
	_q_helper "cmp add_assignment {$sect_id} {$src} {$target} {$variable} {$value}"
}
proc q_cmp_add_locations { sect_id location_list list_size } {
	_q_helper "cmp add_locations {$sect_id} {$location_list} {$list_size}"
}
proc q_cmp_remove_assignment { sect_id src target variable value } {
	_q_helper "cmp remove_assignment {$sect_id} {$src} {$target} {$variable} {$value}"
}
proc q_cmp_get_all_assignments { src target } {
	_q_helper "cmp get_all_assignments {$src} {$target}"
}
proc q_cmp_get_assignment_count { src target } {
	_q_helper "cmp get_assignment_count {$src} {$target}"
}
proc q_cmp_get_assignment_value { sect_id src target variable } {
	_q_helper "cmp get_assignment_value {$sect_id} {$src} {$target} {$variable}"
}
proc q_cmp_get_locations { } {
	_q_helper "cmp get_locations"
}
proc q_cmp_full_back_annotate {demotion_type } {
	_q_helper "cmp full_back_annotate {$demotion_type}"
}
proc q_cmp_logiclock_back_annotate { logiclock_region demote_to_lab back_annotate_nodes} {
	_q_helper "cmp logiclock_back_annotate {$xrname} {$demote_to_lab} {$back_annotate_nodes}"
}
proc q_cmp_logiclock_import { } {
	_q_helper "cmp logiclock_import"
}
proc q_cmp_logiclock_export { filename } {
	_q_helper "cmp logiclock_export {$filename}"
}
proc q_cmp_locate_to_floorplan { name } {
	_q_helper "cmp locate_to_floorplan {$name}"
}
proc q_cmp_locate_to_current_assignment_floorplan { name } {
	_q_helper "cmp locate_to_current_assignment_floorplan {$name}"
}
proc q_cmp_locate_to_text { name } {
	_q_helper "cmp locate_to_text {$name}"
}
proc q_cmp_locate { name editor_type } {
	_q_helper "cmp locate {$name} {$editor_type}"
}
proc q_cmp_purge_compiler_results { } {
	_q_helper "cmp purge_compiler_results"
}
proc q_cmp_write_output_netlists { } {
	_q_helper "cmp write_output_netlists"
}
proc q_cmp_get_timing_nodes {node_type } {
	_q_helper "cmp get_timing_nodes {$node_type}"
}
proc q_cmp_get_delays_from_keepers { node_id } {
	_q_helper "cmp get_delays_from_keepers {$node_id}"
}
proc q_cmp_get_delays_from_clocks { node_id } {
	_q_helper "cmp get_delays_from_clocks {$node_id}"
}
proc q_cmp_get_timing_node_info { type node_id } {
	_q_helper "cmp get_timing_node_info {$type} {$node_id}"
}
proc q_cmp_get_timing_node_fanin { type node_id } {
	_q_helper "cmp get_timing_node_fanin {$type} {$node_id}"
}
proc q_cmp_get_timing_node_fanout { node_id } {
	_q_helper "cmp get_timing_node_fanout {$node_id}"
}
proc q_cmp_get_delay_path { type src_name dst_name } {
	_q_helper "cmp get_delay_path {$type} {$src_name} {$dst_name}"
}
proc q_cmp_get_clock_delay_path { type src_name dst_name } {
	_q_helper "cmp get_clock_delay_path {$type} {$src_name} {$dst_name}"
}
proc q_cmp_find_period { type dst_id dst_clk_id src_id src_clk_id} {
    _q_helper "cmp find_period {$type} {$dst_id} {$dst_clk_id} {$src_id} {$src_clk_id}"
}
proc q_cmp_find_tsu { pin_id reg_id clk_id} {
	_q_helper "cmp find_tsu {$pin_id} {$reg_id} {$clk_id}"
}
proc q_cmp_find_th { pin_id reg_id clk_id} {
	_q_helper "cmp find_th {$pin_id} {$reg_id} {$clk_id}"
}
proc q_cmp_find_tco { pin_id reg_id clk_id} {
	_q_helper "cmp find_tco {$pin_id} {$reg_id} {$clk_id}"
}
proc q_cmp_get_report_data { name row col } {
	_q_helper "cmp get_report_data {$name} {$row} {$col}"
}
proc q_cmp_get_atom_nodes { } {
	_q_helper "cmp get_atom_nodes"
}
proc q_cmp_get_atom_node_info { type atom_id } {
_q_helper "cmp get_atom_node_info {$type} {$atom_id}"
}
proc q_cmp_get_atom_iport_info { type atom_id itype index} {
_q_helper "cmp get_atom_iport_info {$type} {$atom_id} {$itype} {$index}"
}
proc q_cmp_get_atom_oport_info { type atom_id otype index} {
_q_helper "cmp get_atom_oport_info {$type} {$atom_id} {$otype} {$index}"
}
proc q_cmp_get_re_nodes { } {
	_q_helper "cmp get_re_nodes"
}
proc q_cmp_get_re_node_info { type re_id } {
_q_helper "cmp get_re_node_info {$type} {$re_id}"
}
proc q_cmp_get_re_iport_info { type re_id iport_id} {
_q_helper "cmp get_re_iport_info {$type} {$re_id} {$iport_id}"
}
proc q_cmp_get_re_oport_info { type re_id oport_id} {
_q_helper "cmp get_re_oport_info {$type} {$re_id} {$oport_id}"
}
proc q_sim_is_initialized { } {
	_q_helper "sim is_initialized "
}
proc q_sim_start { misc } {
	_q_helper "sim start {$misc}"
}
proc q_sim_initialize { } {
	_q_helper "sim initialize "
}
proc q_sim_dbg { } {
	_q_helper "sim dbg "
}
proc q_sim_stop { }       {
	_q_helper "sim stop "
}
proc q_sim_is_running { }   {
	_q_helper "sim is_running"
}
proc q_sim_add_assignment { sect_id src target variable value } {
	_q_helper "sim add_assignment {$sect_id} {$src} {$target} {$variable} {$value}"
}
proc q_sim_remove_assignment { sect_id src target variable value } {
	_q_helper "sim remove_assignment {$sect_id} {$src} {$target} {$variable} {$value}"
}
proc q_sim_start_batch { }   {
	_q_helper "sim start_batch"
}
proc q_sim_end_batch { }   {
	_q_helper "sim end_batch"
}
proc q_sim_get_all_assignments { src target } {
	_q_helper "sim get_all_assignments {$src} {$target}"
}
proc q_sim_get_assignment_count { src target } {
	_q_helper "sim get_assignment_count {$src} {$target}"
}
proc q_sim_get_assignment_value { sect_id src target variable } {
	_q_helper "sim get_assignment_value {$sect_id} {$src} {$target} {$variable}"
}
proc q_sim_testbench_mode { mode } {
	_q_helper "sim testbench_mode {$mode}"
}
proc q_sim_get_time	{ } {
	_q_helper "sim get_time"
}
proc q_sim_get_value { hpath } {
	_q_helper "sim get_value {$hpath}"
}
proc q_sim_force_value { hpath value } {
	_q_helper "sim force_value {$hpath} {$value}"
}
proc q_sim_release_value { hpath } {
	_q_helper "sim release_value {$hpath}"
}
proc q_sim_read_from_memory { hpath addr } {
	_q_helper "sim read_from_memory {$hpath} {$addr}"
}
proc q_sim_write_to_memory { hpath addr data} {
	_q_helper "sim write_to_memory {$hpath} {$addr} {$data}"
}
proc q_sim_get_memory_width { hpath } {
	_q_helper "sim get_memory_width {$hpath}"
}
proc q_sim_get_memory_depth { hpath } {
	_q_helper "sim get_memory_depth {$hpath}"
}
proc q_sim_run { time } {
	_q_helper "sim run {$time}"
}
proc q_sim_print { level message } {
	_q_helper "sim print {$level} {$message}"
}
proc q_show_main_window { {misc ""} }  {
	_q_helper "show_main_window {$misc}"
}
proc q_hide_main_window { }  {
	_q_helper "hide_main_window"
}
proc q_get_version { }  {
	_q_helper "get_version"
}
proc q_help { }  {
	_q_helper "help"
}
proc q_convert { filename args } {
	q_import_assignments_from_maxplus2 $filename $args
}
proc q_import_assignments_from_maxplus2 { filename args } {
	if { $args != "" } {
		_q_helper "import_assignments_from_maxplus2 {$filename} {$args}"
	} else {
		_q_helper "import_assignments_from_maxplus2 {$filename}"
	}
}

## misc functions

proc _q_helper {command} {
	global _q_cmd_sock
	global _q_srvr_didnt_respond;
	set e_occured 0
	if {![info exists _q_cmd_sock]} {
		set result "Please setup quartus server connection using function q_attach or q_remote_attach before using quartus functions"
		error $result
	}
	if { $command == "" } {
		error "Error: Sorry, atleast one argument is necessary"
	}

	## if server didnt respond in last call, then flush input from server
	##   as it might have responded later.
	if { $_q_srvr_didnt_respond == 1 } {
		flush $_q_cmd_sock
		set _q_srvr_didnt_respond 0
	}
	puts $_q_cmd_sock $command
	set first_line [_q_get_cmd_line ]
   set nlines [lindex $first_line 0]
   set line [lrange $first_line 1 end]
	if [regexp  ^Error: $line] {
		set e_occured 1
	} elseif { $line == ""  && $nlines == 1} {
		set result ""
		return $result
	}

	set lix 1
	set result $line
	while { $lix < $nlines } {
		append result "\n"
		append result [_q_get_cmd_line]
		incr lix
	}
	if { $e_occured == 0 } {
		return $result
	} else {
		error $result
	}
}

proc _q_get_cmd_line { } {
	global q_max_wait;
	global q_polling_delay;
	global _q_cmd_sock;
	global _q_msg_sock;
	global _q_srvr_didnt_respond;
	global _q_server_connection_broken;
	set wcnt 0
	while {[set result [gets $_q_cmd_sock]] == ""} {
		if {[eof $_q_cmd_sock]} {
			catch { close $_q_cmd_sock }
			if { [info exists _q_msg_sock] } {
				catch { close $_q_msg_sock }
			}
			error "Error: Quartus tcl server connection is broken"
		}
		set trigger 0
		after $q_polling_delay {set trigger 1}
		vwait trigger
		incr wcnt $q_polling_delay
		if { $wcnt >= $q_max_wait && $q_max_wait != -1 } {
			set result "Error: Quartus tcl server is not responding"
			set _q_srvr_didnt_respond 1
			error $result
			break;
		} elseif { $_q_server_connection_broken } {
			set result "Error: Quartus tcl server connection is broken"
			error $result
			
		}
	}
	return $result
}

proc quartus {args } {
	_q_helper $args
}
		
proc _q_connect_to_server {host port} {
	global q_socket_cmd_name
	set s [eval $q_socket_cmd_name $host $port]
	fconfigure $s -buffering line
	fconfigure $s -blocking 0
	return $s
}

proc q_attach { {want_msg_server 1} {server_name ""} } {
	global _q_cmd_sock;
	global _q_msg_sock;
	global _q_remote_srvr;
	global env;
	if [info exists _q_cmd_sock] {
		catch { close $_q_cmd_sock }
		unset _q_cmd_sock;
	}
	if [info exists _q_msg_sock] {
		catch { close $_q_msg_sock }
		unset _q_msg_sock;
	}
	if [info exists env(QUARTUS_TCL_PORT)] {
		set q_port $env(QUARTUS_TCL_PORT)
	} else {
		set q_port 2589  
	}
	if { $server_name != "" } {
		set _q_remote_srvr $server_name
		set hname $server_name
		set place "remote"
	} else {
		set hname "localhost"
		set place "local"
	}
	puts "Setting up $place quartus command tcl server connection.."
	set _q_cmd_sock [_q_connect_to_server $hname $q_port]
	fileevent $_q_cmd_sock readable [list _q_exec_check_eof $_q_cmd_sock]
	if { $want_msg_server != 0 } {
		puts "Setting up message server connection..\n";
		set _q_msg_sock [_q_connect_to_server $hname $q_port]
		fileevent $_q_msg_sock readable [list _q_exec_get_msg $_q_msg_sock]
	}
}

proc q_remote_attach { server_name { want_msg_server 1} } {
	q_attach $want_msg_server $server_name
}

proc q_detach { } {
	global _q_srvr_didnt_respond
	global _q_server_connection_broken
	global _q_initiated_shutdown
	global _q_cmd_sock
	global _q_msg_sock;
	global q_info_msg_cnt
	global q_warn_msg_cnt
	global q_err_msg_cnt
	global q_info_msgs
	global q_warn_msgs
	global q_err_msgs

	set _q_srvr_didnt_respond 0
	set _q_server_connection_broken 0
	set _q_initiated_shutdown 0

	if [info exists _q_cmd_sock] {
		puts "Closing quartus command tcl server connection.."
		catch { close $_q_cmd_sock }
		unset _q_cmd_sock;
		
	}
	if [info exists _q_msg_sock] {
		puts "Closing message server connection.."
		catch { close $_q_msg_sock }
		unset _q_msg_sock;
		if [array exists q_info_msgs] {
			unset q_info_msgs
			set q_info_msgs(0) ""
			set q_info_msg_cnt 0
		}
		if [array exists q_warn_msgs] {
			unset q_warn_msgs
			set q_warn_msgs(0) ""
			set q_warn_msg_cnt 0
		}
		if [array exists q_err_msgs] {
			unset q_err_msgs
			set q_err_msgs(0) ""
			set q_err_msg_cnt 0
		}
	}
	return;
}


proc _q_exec_get_msg {sock} {
	global _q_cmd_sock
	global _q_msg_sock
	global q_info_msg_cnt
	global q_warn_msg_cnt
	global q_err_msg_cnt
	global q_info_msgs
	global q_warn_msgs
	global q_err_msgs
	if {![info exists _q_cmd_sock]} {
		catch { close $sock }
		unset _q_msg_sock
		return;
	}
	if {[eof $sock]} {
		puts "Closing message server connection.." 
		close $sock
		unset _q_msg_sock;
		return;
	}
	set qmsg [gets $sock]
	set qmsg_type [string tolower [lindex $qmsg 0]]
	
	if (![string compare $qmsg_type "error"]) {
		set q_err_msgs($q_err_msg_cnt) [lindex $qmsg 3]
		incr q_err_msg_cnt
	} elseif (![string compare $qmsg_type "warning"]) {
		set q_warn_msgs($q_warn_msg_cnt) [lindex $qmsg 3]
		incr q_warn_msg_cnt
	} else {
		set q_info_msgs($q_info_msg_cnt) [lindex $qmsg 3]
		incr q_info_msg_cnt
	}

	return;
}

proc _q_exec_check_eof {sock} {
	global _q_cmd_sock
	global _q_server_connection_broken
	global _q_initiated_shutdown
	if {[eof $sock]} {
		if { !$_q_initiated_shutdown } {
			puts "Quartus server connection broken! ..." 
		}
		close $sock
		unset _q_cmd_sock;
		set _q_server_connection_broken 1
		return;
	}
	return;
}

puts "sourced [info script] ..."
