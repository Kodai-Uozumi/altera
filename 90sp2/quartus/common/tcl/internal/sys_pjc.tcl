
# Copyright (c) Altera Corporation
# All rights reserved

package require Itcl 3.0

# Try to load package statically first
if [ catch { load "" Sys_pjc_tcl } load_result ] {
	# If static load fails, load dynamic lib
	if { $::tcl_platform(platform) == "unix" } {
		if { $::tcl_platform(os) == "HP-UX" } {
			load [file join $::quartus(binpath) libsys_pjc_tcl.sl]
		} else {
			load [file join $::quartus(binpath) libsys_pjc_tcl.so]
		}
	} else {
		load [file join $::quartus(binpath) sys_pjc_tcl.dll]
	}
}

::itcl::class ::quartus::Project {

	public method exists { path } @pjc_tcl_project_exists
	public method open { path }   @pjc_tcl_project_open
	public method create { path } @pjc_tcl_project_create
	public method close {}        @pjc_tcl_project_close
	public method archive { path }        @pjc_tcl_project_archive
	public method restore { path path }   @pjc_tcl_project_restore
	public method start_batch { entity }  @pjc_tcl_project_start_batch
	public method end_batch { entity }  @pjc_tcl_project_end_batch
	public method generate_tcl_file { path }  @pjc_tcl_project_generate_tcl_file
	public method get_current_project_name {} @pjc_tcl_project_get_current_project_name

	#cmp
	public method cmp_exists  { cmp }   @pjc_tcl_project_cap_exists
	public method create_cmp  { cmp }   @pjc_tcl_project_create_cap
	public method set_active_cmp { cmp } @pjc_tcl_project_set_active_cap
	public method get_active_cmp_name {} @pjc_tcl_project_get_active_cap_name

	#sim
	public method sim_exists  { sim }   @pjc_tcl_project_sap_exists
	public method create_sim  { sim }   @pjc_tcl_project_create_sap
	public method set_active_sim { sim } @pjc_tcl_project_set_active_sap
	public method get_active_sim_name {} @pjc_tcl_project_get_active_sap_name

	#swb
	public method swb_exists  { swb }   @pjc_tcl_project_fap_exists
	public method create_swb  { swb }   @pjc_tcl_project_create_fap
	public method set_active_swb { swb } @pjc_tcl_project_set_active_fap
	public method get_active_swb_name {} @pjc_tcl_project_get_active_fap_name

	#assignments
	public method add_assignment { entity section_identifier source target variable value } @pjc_tcl_project_add_assignment
	public method remove_assignment { entity section_identifier source target variable value } @pjc_tcl_project_remove_assignment
	public method get_all_assignments { entity section_identifier source target } @pjc_tcl_project_get_assignments
	public method get_assignment_count { entity section_identifier source target } @pjc_tcl_project_get_assignment_count
	public method get_assignment_value { entity section_identifier source target variable } @pjc_tcl_project_get_assignment_value
	public method get_all_default_parameters {} @pjc_tcl_project_get_all_default_parameters
	public method get_default_parameter_value { name } @pjc_tcl_project_get_default_parameter_value
	public method add_default_parameter { name value } @pjc_tcl_project_add_default_parameter
	public method remove_default_parameter { name } @pjc_tcl_project_remove_default_parameter
	public method get_all_parameters { entity } @pjc_tcl_project_get_all_parameters
	public method get_parameter_value { entity target name } @pjc_tcl_project_get_parameter_value
	public method add_parameter { entity target name value } @pjc_tcl_project_add_parameter
	public method remove_parameter { entity target name } @pjc_tcl_project_remove_parameter
}

::itcl::class ::quartus::Device {

	public method set_timing_variable {env_var_name env_var_value} @pjc_tcl_device_set_env_variable
	public method reset_timing_variables {} @pjc_tcl_device_reset_env_variable
	public method display_timing_variables {} @pjc_tcl_device_display_env_variable
	public method get_family_count {} @pjc_tcl_device_get_family_count
	public method get_family_name_by_index { index }   @pjc_tcl_device_get_family_name_by_index
	public method get_device_count { family_name } @pjc_tcl_device_get_device_count
	public method get_device_name_by_index {family_name index}        @pjc_tcl_device_get_device_name_by_index
	public method get_die_name {family_name device_name} @pjc_tcl_device_get_die_name
	public method get_package_name {family_name device_name} @pjc_tcl_device_get_package_name
	public method get_speed_grade {family_name device_name} @pjc_tcl_device_get_speed_grade
	public method get_timing {family_name device_name cell_type src_type dest_type } @pjc_tcl_device_get_timing
	public method get_dmf_info {family_name device_name node_type src_type dest_type node_path } @pjc_tcl_device_get_dmf_info
	public method get_clock_ic_delay {family_name device_name dst_row dst_gol_col dst_col global_clock } @pjc_tcl_device_get_clock_ic_delay
	public method get_local_line_delay {family_name device_name lut_type use_pia from_gh } @pjc_tcl_device_get_local_line_delay
	public method get_row_type {family_name device_name row } @pjc_tcl_device_get_row_type
	public method get_timingex {family_name device_name hierarchy } @pjc_tcl_device_get_timingex
	public method get_routing_line_length {family_name device_name routing_line_type } @pjc_tcl_device_get_routing_line_length
	public method get_routing_line_delay {family_name device_name fanout_array_string src_location routing_line_type } @pjc_tcl_device_get_routing_line_delay
	public method get_routing_line_to_line_delay {family_name device_name src_routing_line destination_routing_line } @pjc_tcl_device_get_routing_line_to_line_delay
	public method get_timing_variable {variable_name} @pjc_tcl_device_get_timing_variable
	public method get_estimated_timing {family_name device_name fanout_num region_type} @pjc_tcl_device_get_estimated_timing
	public method get_device_resource_count {family_name device_name resource_type} @pjc_tcl_device_get_device_resource_count
	public method validate_family_and_device {family_name device_name} @pjc_tcl_device_validate_family_and_device
	public method start_placer_delay_matrix {family_name device_name} @pjc_tcl_device_start_placer_delay_matrix
	public method stop_placer_delay_matrix {} @pjc_tcl_device_stop_placer_delay_matrix
	public method get_point_to_point_delay {x1 y1 x2 y2} @pjc_tcl_device_get_point_to_point_delay
	public method set_operating_conditions {voltage max_temp min_temp} @pjc_tcl_device_set_operating_conditions

}

::itcl::class ::quartus::ActiveCompilerActionPoint {

	public method start { misc task_option filename } @pjc_tcl_cap_start
	public method stop { }       @pjc_tcl_cap_stop
	public method is_running {}   @pjc_tcl_cap_is_running
	public method start_batch {}  @pjc_tcl_cap_start_batch
	public method end_batch {}  @pjc_tcl_cap_end_batch
	public method add_assignment { section_identifier source target variable value } @pjc_tcl_cap_add_assignment
	public method remove_assignment { section_identifier source target variable value } @pjc_tcl_cap_remove_assignment
	public method add_locations { section_identifier location_list list_size } @pjc_tcl_cap_add_locations
	public method get_all_assignments { source target } @pjc_tcl_cap_get_assignments
	public method get_assignment_count { source target } @pjc_tcl_cap_get_assignment_count
	public method get_assignment_value { section_identifier source target variable } @pjc_tcl_cap_get_assignment_value
	public method get_locations { } @pjc_tcl_cap_get_location
	public method full_back_annotate { demotion_type demote_option} @pjc_tcl_cap_full_back_annotate
	public method logiclock_back_annotate { logiclock_region demote_to_lab back_annotate_nodes lock_regions back_annotate_routing} @pjc_tcl_cap_xacto_back_annotate
	public method logiclock_list_nodes {source dest exclude_source exclude_dest exclude_node} @pjc_tcl_cap_logiclock_list_nodes
	public method logiclock_import {do_pins do_ll do_non_ll do_update allow_create region_name do_rcf} @pjc_tcl_cap_xacto_import
	public method logiclock_export { filename export_focus } @pjc_tcl_cap_xacto_export
	public method logiclock_get_flat_locations_map { only_do_physical_elements } @pjc_tcl_cap_xacto_get_flat_locations_map
	public method logiclock_get_composite_block_extents { } @pjc_tcl_cap_xacto_get_composite_block_extents
	public method get_selected_nodes { format } @pjc_tcl_cap_get_selected_node_names
	public method locate_to_floorplan { name } @pjc_tcl_cap_locate_to_floorplan
	public method locate_to_current_assignment_floorplan { name } @pjc_tcl_cap_locate_to_current_assignment_floorplan
	public method locate_to_text      { name } @pjc_tcl_cap_locate_to_text
	public method locate  { name editor_type } @pjc_tcl_cap_locate_with_type	
	public method purge_compiler_results { } @pjc_tcl_cap_purge_compiler_results
	public method write_output_netlists {} @pjc_tcl_cap_write_output_netlists
	public method write_vqm_netlist { filename } @pjc_tcl_cap_write_vqm_netlist
	public method run_simulation_tool {} @pjc_tcl_cap_run_simulation_tool
	public method last_compilation_successful {} @pjc_tcl_cap_last_compilation_successful
	public method get_focus_entity { } @pjc_tcl_cap_get_focus_entity
	public method get_names { look_in named node_type include_subentities creator} @pjc_tcl_cap_get_names
	public method get_name_info { name_id info_type asgn_type} @pjc_tcl_cap_get_name_info

	# Timing Analysis API
	public method get_timing_nodes { node_type } @pjc_tcl_cap_get_timing_nodes
	public method get_delays_from_keepers { node_id } @pjc_tcl_cap_get_delays_from_keepers
	public method get_delays_from_clocks { node_id } @pjc_tcl_cap_get_delays_from_clocks
	public method get_timing_node_info { type node_id } @pjc_tcl_cap_get_timing_node_info
	public method get_timing_node_fanin { type node_id } @pjc_tcl_cap_get_timing_node_fanin
	public method get_timing_node_fanout { node_id } @pjc_tcl_cap_get_timing_node_fanout
	public method get_timing_edges { } @pjc_tcl_cap_get_timing_edges
	public method get_timing_edge_info { type edge_id } @pjc_tcl_cap_get_timing_edge_info
	public method get_delay_path { type src_id dst_id } @pjc_tcl_cap_get_delay_path
	public method get_clock_delay_path { type clk_id reg_id } @pjc_tcl_cap_get_clock_delay_path
	public method find_period { type dst_id dst_clk_id src_id src_clk_id} @pjc_tcl_cap_find_period
	public method find_tsu { pin_id reg_id clk_id} @pjc_tcl_cap_find_tsu
	public method find_th { pin_id reg_id clk_id} @pjc_tcl_cap_find_th
	public method find_tco { pin_id reg_id clk_id} @pjc_tcl_cap_find_tco
	public method find_dqs_read_capture { dqs_id dq_id reg_id} @pjc_tcl_cap_find_dqs_read_capture
	public method get_report_data { name row col } @pjc_tcl_cap_get_report_data

	# ATOM API
	public method get_atom_nodes { } @pjc_tcl_cap_get_atom_nodes
	public method get_atom_node_info { type atom_id } @pjc_tcl_cap_get_atom_node_info
	public method get_atom_iport_info { type atom_id itype index } @pjc_tcl_cap_get_atom_iport_info
	public method get_atom_oport_info { type atom_id otype index } @pjc_tcl_cap_get_atom_oport_info

	# Routing Element API
	public method get_re_nodes { } @pjc_tcl_cap_get_re_nodes
	public method get_re_node_info { type re_id } @pjc_tcl_cap_get_re_node_info
	public method get_re_iport_info { type re_id iport_id } @pjc_tcl_cap_get_re_iport_info
	public method get_re_oport_info { type re_id oport_id } @pjc_tcl_cap_get_re_oport_info
	public method write_routing_constraints { file_path options } @pjc_tcl_cap_write_routing_constraints

}

::itcl::class ::quartus::ActiveSimulatorActionPoint {

	public method is_initialized { }    @pjc_tcl_sap_is_initialized
	public method start { misc } @pjc_tcl_sap_start
	public method initialize {}  @pjc_tcl_sap_initialize
	public method dbg {command}  @pjc_tcl_sap_dbg
	public method stop { }       @pjc_tcl_sap_stop
	public method is_running {}   @pjc_tcl_sap_is_running
	public method add_assignment { section_identifier source target variable value } @pjc_tcl_sap_add_assignment
	public method remove_assignment { section_identifier source target variable value } @pjc_tcl_sap_remove_assignment
	public method start_batch {}  @pjc_tcl_sap_start_batch
	public method end_batch {}  @pjc_tcl_sap_end_batch
	public method get_all_assignments { source target } @pjc_tcl_sap_get_assignments
	public method get_assignment_count { source target } @pjc_tcl_sap_get_assignment_count
	public method get_assignment_value { section_identifier source target variable } @pjc_tcl_sap_get_assignment_value
	public method testbench_mode { mode }			@pjc_tcl_sap_testbench_mode
	public method get_time	{ }						@pjc_tcl_sap_get_time
	public method get_value	  { hpath }				@pjc_tcl_sap_get_value
	public method force_value { hpath value }		@pjc_tcl_sap_force_value
	public method release_value { hpath }			@pjc_tcl_sap_release_value
	public method read_from_memory { hpath addr }		@pjc_tcl_sap_read_memory
	public method write_to_memory { hpath addr data}	@pjc_tcl_sap_write_memory
	public method get_memory_width { hpath }		@pjc_tcl_sap_get_memory_width
	public method get_memory_depth { hpath }		@pjc_tcl_sap_get_memory_depth
	public method run { time }						@pjc_tcl_sap_run_for
	public method print { level message }			@pjc_tcl_sap_print

}

::itcl::class ::quartus::ActiveSoftwareActionPoint {

	public method add_assignment { section_identifier source target variable value } @pjc_tcl_fap_add_assignment
	public method remove_assignment { section_identifier source target variable value } @pjc_tcl_fap_remove_assignment
	public method get_assignment_value { section_identifier source target variable } @pjc_tcl_fap_get_assignment_value
	public method get_all_assignments { source target } @pjc_tcl_fap_get_assignments
	public method get_assignment_count { source target } @pjc_tcl_fap_get_assignment_count
	public method start { } @pjc_tcl_fap_start
	public method stop { }       @pjc_tcl_fap_stop
	public method is_running {}   @pjc_tcl_fap_is_running
	public method purge_intermediate_files { } @pjc_tcl_fap_purge_intermediate_files

}

::itcl::class ::quartus::SystemLevelDebugging {

	public method create_session { } @pjc_tcl_sld_create_session
	public method open_session { } @pjc_tcl_sld_open_session
	public method close_session { } @pjc_tcl_sld_close_session
	public method enable_trigger { } @pjc_tcl_sld_enable_trigger
	public method run { } @pjc_tcl_sld_run
	public method stop { } @pjc_tcl_sld_stop
	public method run_multiple_start { } @pjc_tcl_sld_run_multiple_start
	public method run_multiple_end { } @pjc_tcl_sld_run_multiple_end

}

::quartus::Project project
::quartus::Device device
::quartus::ActiveCompilerActionPoint cmp
::quartus::ActiveSimulatorActionPoint sim
::quartus::ActiveSoftwareActionPoint swb
::quartus::SystemLevelDebugging sld

set ::quartus::foobar ""

if {[info exists ::quartus(exclude_old_timing_commands)] && $::quartus(exclude_old_timing_commands)} {
	# currently, we exclude timing commands for quartus.tcl
} else {
	proc create_clock { args } { ::quartus::pjc_tcl_sdc_create_clock $args }
	proc create_generated_clock { args } { ::quartus::pjc_tcl_sdc_create_generated_clock $args }
	proc set_multicycle_path { args } { ::quartus::pjc_tcl_sdc_set_multicycle_path $args }
	proc set_clock_latency { args } { ::quartus::pjc_tcl_sdc_set_clock_latency $args }
	proc set_input_delay { args } { ::quartus::pjc_tcl_sdc_set_input_delay $args }
	proc set_output_delay { args } { ::quartus::pjc_tcl_sdc_set_output_delay $args }
	proc set_max_delay { args } { ::quartus::pjc_tcl_sdc_set_max_delay $args }
	proc set_min_delay { args } { ::quartus::pjc_tcl_sdc_set_min_delay $args }
	proc set_false_path { args } { ::quartus::pjc_tcl_sdc_set_false_path $args }
	proc set_propagated_clock { args } { ::quartus::pjc_tcl_sdc_set_propagated_clock $args }
	proc get_ports { args } { ::quartus::pjc_tcl_sdc_get_ports $args }
	proc get_clocks { args } { ::quartus::pjc_tcl_sdc_get_clocks $args }
	proc remove_clock { args } { ::quartus::pjc_tcl_sdc_remove_clock $args }
	proc reset_path { args } { ::quartus::pjc_tcl_sdc_reset_path $args }
	proc remove_input_delay { args } { ::quartus::pjc_tcl_sdc_remove_input_delay $args }
	proc remove_output_delay { args } { ::quartus::pjc_tcl_sdc_remove_output_delay $args }
}

proc FlushEventQueue {} { ::quartus::pjc_tcl_flush_event_queue }
proc hide_main_window {} {	::quartus::pjc_tcl_hide_main_window }
proc init_tk {} { ::quartus::pjc_tcl_init_tk }
proc show_main_window { misc } { ::quartus::pjc_tcl_show_main_window }
proc get_version {} { ::quartus::pjc_tcl_get_version }
proc is_command_line_mode {} { ::quartus::pjc_tcl_is_command_line_mode }
proc old_help {} { ::quartus::pjc_tcl_show_help }
proc ls { {path1 ""} {path2 ""} {path3 ""} {path4 ""} {path5 ""} } { ::quartus::pjc_tcl_ls $path1 $path2 $path3 $path4 $path5 }
proc show_message { message_type text } { quartus::pjc_tcl_show_message $message_type $text }
proc get_ini_value { variable_name } { quartus::pjc_tcl_get_ini_value $variable_name}
proc set_ini_value { variable_name value } { quartus::pjc_tcl_set_ini_value $variable_name $value}
proc cksum { file_name {read_option ""}} { ::quartus::pjc_tcl_cksum $file_name $read_option }

#  Rename the exit command so that it calls return instead. This enables
#  quartus having a chance to cleanup instead of exiting the process
#  immediately.
rename exit exit.old
proc exit { {status 0} } {	::quartus::pjc_tcl_exit_handler $status }

