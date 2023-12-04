######################################################################
# 
# LogicLock2 Makefile Example
# Script To Build Project Directories and Move Source/Make Files
#
######################################################################


# Create Top-Level Project
package require ::quartus::project
package require ::quartus::flow

# Set up the appropriate directory structure and move the files to their places
set partitions "auto_max speed_ch tick_cnt time_cnt chiptrip"
set chiptrip_dir [file join [pwd] chiptrip]

foreach partition $partitions {
	if { [file exists $partition] == 0 } {
		file mkdir $partition
	}
}

foreach partition $partitions {
	set target_dir [file join [pwd] $partition]
	if { [file exists $partition.v] } {
		file rename $partition.v [file join $target_dir $partition.v]
	}
}

foreach partition $partitions {
	set target_dir [file join [pwd] $partition]
	set makefile $partition
	append makefile "_makefile"
	if { [file exists $makefile] } {
		file rename $makefile [file join $target_dir makefile.mak]
	}
}


# Set up the projects and run quartus_map on the top-level
set base_dir [pwd]

cd chiptrip

if {[project_exists chiptrip]} {
	project_open -revision chiptrip chiptrip
} else {
	project_new -revision chiptrip chiptrip
}

set_global_assignment -name INCREMENTAL_COMPILATION FULL_INCREMENTAL_COMPILATION
set_global_assignment -name SMART_RECOMPILE ON
set_global_assignment -name VERILOG_FILE chiptrip.v
set_global_assignment -name VERILOG_FILE ../auto_max/auto_max.v
set_global_assignment -name VERILOG_FILE ../speed_ch/speed_ch.v
set_global_assignment -name VERILOG_FILE ../tick_cnt/tick_cnt.v
set_global_assignment -name VERILOG_FILE ../time_cnt/time_cnt.v
set_global_assignment -name DEVICE_FILTER_SPEED_GRADE FASTEST
set_global_assignment -name FAMILY Stratix
set_global_assignment -name DEVICE EP1S10B672C6
set_global_assignment -name PARTITION_NETLIST_TYPE IMPORTED -section_id "auto_max:auto_max"
set_global_assignment -name PARTITION_NETLIST_TYPE IMPORTED -section_id "speed_ch:speed_ch"
set_global_assignment -name PARTITION_NETLIST_TYPE IMPORTED -section_id "tick_cnt:tick_cnt"
set_global_assignment -name PARTITION_NETLIST_TYPE IMPORTED -section_id "time_cnt:time_cnt"
set_global_assignment -name PARTITION_IMPORT_FILE "../auto_max/auto_max.qxp" -section_id "auto_max:auto_max"
set_global_assignment -name PARTITION_IMPORT_FILE "../speed_ch/speed_ch.qxp" -section_id "speed_ch:speed_ch"
set_global_assignment -name PARTITION_IMPORT_FILE "../tick_cnt/tick_cnt.qxp" -section_id "tick_cnt:tick_cnt"
set_global_assignment -name PARTITION_IMPORT_FILE "../time_cnt/time_cnt.qxp" -section_id "time_cnt:time_cnt"
set_global_assignment -name PARTITION_IMPORT_EXISTING_LOGICLOCK_REGIONS REPLACE_CONFLICTING -section_id "auto_max:auto_max"
set_global_assignment -name PARTITION_IMPORT_EXISTING_LOGICLOCK_REGIONS REPLACE_CONFLICTING -section_id "speed_ch:speed_ch"
set_global_assignment -name PARTITION_IMPORT_EXISTING_LOGICLOCK_REGIONS REPLACE_CONFLICTING -section_id "tick_cnt:tick_cnt"
set_global_assignment -name PARTITION_IMPORT_EXISTING_LOGICLOCK_REGIONS REPLACE_CONFLICTING -section_id "time_cnt:time_cnt"
set_instance_assignment -name PARTITION_HIERARCHY db/autom_1 -to "auto_max:auto_max" -section_id "auto_max:auto_max"
set_instance_assignment -name PARTITION_HIERARCHY db/speed_1 -to "speed_ch:speed_ch" -section_id "speed_ch:speed_ch"
set_instance_assignment -name PARTITION_HIERARCHY db/tickc_1 -to "tick_cnt:tick_cnt" -section_id "tick_cnt:tick_cnt"
set_instance_assignment -name PARTITION_HIERARCHY db/timec_1 -to "time_cnt:time_cnt" -section_id "time_cnt:time_cnt"
set_instance_assignment -name PARTITION_HIERARCHY no_file_for_top_partition -to | -section_id Top

# Commit assignments
export_assignments

project_close

cd $base_dir
cd auto_max

if {[project_exists auto_max]} {
	project_open -revision auto_max auto_max
} else {
	project_new -revision auto_max auto_max
}

set_global_assignment -name INCREMENTAL_COMPILATION FULL_INCREMENTAL_COMPILATION
set_global_assignment -name SMART_RECOMPILE ON
set_global_assignment -name VERILOG_FILE auto_max.v
set_global_assignment -name QIC_EXPORT_FILE auto_max.qxp
set_global_assignment -name DEVICE_FILTER_SPEED_GRADE FASTEST
set_global_assignment -name FAMILY Stratix
set_global_assignment -name DEVICE EP1S10B672C6
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
set_global_assignment -name LL_ORIGIN LAB_X25_Y1 -section_id auto_max
set_global_assignment -name LL_HEIGHT 4 -section_id auto_max
set_global_assignment -name LL_WIDTH 4 -section_id auto_max
set_global_assignment -name LL_STATE LOCKED -section_id auto_max
set_global_assignment -name LL_AUTO_SIZE OFF -section_id auto_max
set_global_assignment -name LL_RESERVED OFF -section_id auto_max
set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id auto_max
set_global_assignment -name LL_SOFT OFF -section_id auto_max
set_global_assignment -name LL_MEMBER_OF auto_max -section_id auto_max
set_global_assignment -name QIC_EXPORT_FILE auto_max.qxp
set_global_assignment -name QIC_EXPORT_NETLIST_TYPE POST_FIT
set_global_assignment -name QIC_EXPORT_ROUTING OFF
set_instance_assignment -name CUT ON -from * -to *
set_instance_assignment -name VIRTUAL_PIN ON -to accel
set_instance_assignment -name VIRTUAL_PIN ON -to at_altera
set_instance_assignment -name VIRTUAL_PIN ON -to clk
set_instance_assignment -name VIRTUAL_PIN ON -to dir
set_instance_assignment -name VIRTUAL_PIN ON -to dir[0]
set_instance_assignment -name VIRTUAL_PIN ON -to dir[1]
set_instance_assignment -name VIRTUAL_PIN ON -to get_ticket
set_instance_assignment -name VIRTUAL_PIN ON -to reset
set_instance_assignment -name VIRTUAL_PIN ON -to speed_too_fast

# Commit assignments
export_assignments

project_close

cd $base_dir
cd time_cnt

if {[project_exists time_cnt]} {
	project_open -revision time_cnt time_cnt
} else {
	project_new -revision time_cnt time_cnt
}

set_global_assignment -name INCREMENTAL_COMPILATION FULL_INCREMENTAL_COMPILATION
set_global_assignment -name SMART_RECOMPILE ON
set_global_assignment -name VERILOG_FILE time_cnt.v
set_global_assignment -name QIC_EXPORT_FILE time_cnt.qxp
set_global_assignment -name FAMILY Stratix
set_global_assignment -name DEVICE EP1S10B672C6
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
set_global_assignment -name LL_ORIGIN LAB_X5_Y5 -section_id time_cnt
set_global_assignment -name LL_HEIGHT 4 -section_id time_cnt
set_global_assignment -name LL_WIDTH 4 -section_id time_cnt
set_global_assignment -name LL_STATE LOCKED -section_id time_cnt
set_global_assignment -name LL_AUTO_SIZE OFF -section_id time_cnt
set_global_assignment -name LL_RESERVED OFF -section_id time_cnt
set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id time_cnt
set_global_assignment -name LL_SOFT OFF -section_id time_cnt
set_global_assignment -name LL_MEMBER_OF time_cnt -section_id time_cnt
set_global_assignment -name QIC_EXPORT_FILE time_cnt.qxp
set_global_assignment -name QIC_EXPORT_NETLIST_TYPE POST_FIT
set_global_assignment -name QIC_EXPORT_ROUTING OFF
set_instance_assignment -name VIRTUAL_PIN ON -to clk
set_instance_assignment -name VIRTUAL_PIN ON -to enable
set_instance_assignment -name VIRTUAL_PIN ON -to timeo
set_instance_assignment -name VIRTUAL_PIN ON -to timeo[0]
set_instance_assignment -name VIRTUAL_PIN ON -to timeo[1]
set_instance_assignment -name VIRTUAL_PIN ON -to timeo[2]
set_instance_assignment -name VIRTUAL_PIN ON -to timeo[3]
set_instance_assignment -name VIRTUAL_PIN ON -to timeo[4]
set_instance_assignment -name VIRTUAL_PIN ON -to timeo[5]
set_instance_assignment -name VIRTUAL_PIN ON -to timeo[6]
set_instance_assignment -name VIRTUAL_PIN ON -to timeo[7]

# Commit assignments
export_assignments

project_close

cd $base_dir
cd tick_cnt

if {[project_exists tick_cnt]} {
	project_open -revision tick_cnt tick_cnt
} else {
	project_new -revision tick_cnt tick_cnt
}

set_global_assignment -name INCREMENTAL_COMPILATION FULL_INCREMENTAL_COMPILATION
set_global_assignment -name SMART_RECOMPILE ON
set_global_assignment -name VERILOG_FILE tick_cnt.v
set_global_assignment -name QIC_EXPORT_FILE tick_cnt.qxp
set_global_assignment -name FAMILY Stratix
set_global_assignment -name DEVICE EP1S10B672C6
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
set_global_assignment -name LL_ORIGIN LAB_X1_Y5 -section_id tick_cnt
set_global_assignment -name LL_HEIGHT 4 -section_id tick_cnt
set_global_assignment -name LL_WIDTH 4 -section_id tick_cnt
set_global_assignment -name LL_STATE LOCKED -section_id tick_cnt
set_global_assignment -name LL_AUTO_SIZE OFF -section_id tick_cnt
set_global_assignment -name LL_RESERVED OFF -section_id tick_cnt
set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id tick_cnt
set_global_assignment -name LL_SOFT OFF -section_id tick_cnt
set_global_assignment -name LL_MEMBER_OF tick_cnt -section_id tick_cnt
set_global_assignment -name QIC_EXPORT_FILE tick_cnt.qxp
set_global_assignment -name QIC_EXPORT_NETLIST_TYPE POST_FIT
set_global_assignment -name QIC_EXPORT_ROUTING OFF
set_instance_assignment -name VIRTUAL_PIN ON -to clk
set_instance_assignment -name VIRTUAL_PIN ON -to get_ticket1
set_instance_assignment -name VIRTUAL_PIN ON -to get_ticket2
set_instance_assignment -name VIRTUAL_PIN ON -to ticket
set_instance_assignment -name VIRTUAL_PIN ON -to ticket[0]
set_instance_assignment -name VIRTUAL_PIN ON -to ticket[1]
set_instance_assignment -name VIRTUAL_PIN ON -to ticket[2]
set_instance_assignment -name VIRTUAL_PIN ON -to ticket[3]

# Commit assignments
export_assignments

project_close

cd $base_dir
cd speed_ch

if {[project_exists speed_ch]} {
	project_open -revision speed_ch speed_ch
} else { 
	project_new -revision speed_ch speed_ch
}


set_global_assignment -name INCREMENTAL_COMPILATION FULL_INCREMENTAL_COMPILATION
set_global_assignment -name SMART_RECOMPILE ON
set_global_assignment -name VERILOG_FILE speed_ch.v
set_global_assignment -name QIC_EXPORT_FILE speed_ch.qxp
set_global_assignment -name FAMILY Stratix
set_global_assignment -name DEVICE EP1S10B672C6
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
set_global_assignment -name LL_ORIGIN LAB_X1_Y1 -section_id speed_ch
set_global_assignment -name LL_HEIGHT 4 -section_id speed_ch
set_global_assignment -name LL_WIDTH 4 -section_id speed_ch
set_global_assignment -name LL_STATE LOCKED -section_id speed_ch
set_global_assignment -name LL_AUTO_SIZE OFF -section_id speed_ch
set_global_assignment -name LL_RESERVED OFF -section_id speed_ch
set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id speed_ch
set_global_assignment -name LL_SOFT OFF -section_id speed_ch
set_global_assignment -name LL_MEMBER_OF speed_ch -section_id speed_ch
set_global_assignment -name QIC_EXPORT_FILE speed_ch.qxp
set_global_assignment -name QIC_EXPORT_NETLIST_TYPE POST_FIT
set_global_assignment -name QIC_EXPORT_ROUTING OFF
set_instance_assignment -name VIRTUAL_PIN ON -to accel_in
set_instance_assignment -name VIRTUAL_PIN ON -to clk
set_instance_assignment -name VIRTUAL_PIN ON -to get_ticket
set_instance_assignment -name VIRTUAL_PIN ON -to reset

# Commit assignments
export_assignments

project_close