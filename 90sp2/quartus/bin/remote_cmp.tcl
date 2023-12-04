#//START_MODULE_HEADER///////////////////////////////////////////////////////
#
#  Filename:    tcl_client.tcl
#
#  Description: Sample tcl script to compile quartus netlist from 
#               another application.
#               This script also demonstrates how to pipe in quartus 
#               messages while the compilation is in progress.
#
#  Note:        To disable all GUI prompts, quartus.exe should be 
#               invoked with -nmb option 
#
#  Authors:     Altera Corporation
#
#               Copyright (c)  Altera Corporation 1999 - 2002
#               All rights reserved.
#
#//END_MODULE_HEADER/////////////////////////////////////////////////////////


## setup command and message connections to quartus tcl server
q_attach  1  
       ## 0 for connecting only to tcl command server
       ## add extra server name argument if server is on a different machine.
       ## example: q_attach 1 137.23.45.33 
       ##          q_attach 0 donald ## where donald is the machine name

if { ![q_project_exists d:/designs/edf/bm1/bm1.quartus] } {
## create new project. This call should NOT be made for an existing project
q_project_create d:/designs/edf/bm1/bm1.quartus
}

q_project_open d:/designs/edf/bm1/bm1.quartus

q_project_add_assignment "" "" "" "" "SOURCE_FILE" "bm1.edf"

q_project_add_assignment "" "bm1" "" "" "EDA_DESIGN_ENTRY_SYNTHESIS_TOOL" "FPGA EXPRESS"
q_project_add_assignment "" "eda_design_synthesis" "" "" "EDA_USE_LMF" "altsyn.lmf"
q_project_add_assignment "" "eda_design_synthesis" "" "" "EDA_INPUT_VCC" "VDD"

q_project_add_assignment "bm1" "" "" "|IN4" "TPD_REQUIREMENT" "10ns"

if { ![q_project_cmp_exists bm1] } {
## create new cmp. This call should NOT be made for an existing cmp
q_project_create_cmp bm1
}

q_project_set_active_cmp bm1

q_cmp_add_assignment "bm1" "" "|clk" "LOCATION" "PIN_187"

q_cmp_start

set last_info_msg_cnt 0
set last_warn_msg_cnt 0
set last_err_msg_cnt 0

set ok_to_quit_loop 0

## 'do while' loop
while { 1 } {

	set got_new_msgs 0
	## Display any new messages that came in since last time we checked msgs

	set q_cur_info_msg_cnt $q_info_msg_cnt
	if { $last_info_msg_cnt < $q_cur_info_msg_cnt } {
		set got_new_msgs 1
		for { set i $last_info_msg_cnt} { $i < $q_cur_info_msg_cnt } { incr i } {
			puts "SERVER INFO MSG: $q_info_msgs($i)"
		}
		set last_info_msg_cnt $q_cur_info_msg_cnt
	}
	set q_cur_warn_msg_cnt $q_warn_msg_cnt
	if { $last_warn_msg_cnt < $q_cur_warn_msg_cnt } {
		set got_new_msgs 1
		for { set i $last_warn_msg_cnt} { $i < $q_cur_warn_msg_cnt } { incr i } {
			puts "SERVER WARN MSG: $q_warn_msgs($i)"
		}
		set last_warn_msg_cnt $q_cur_warn_msg_cnt
	}
	set q_cur_err_msg_cnt $q_err_msg_cnt
	if { $last_err_msg_cnt < $q_cur_err_msg_cnt } {
		set got_new_msgs 1
		for { set i $last_err_msg_cnt} { $i < $q_cur_err_msg_cnt } { incr i } {
			puts "SERVER ERR MSG: $q_err_msgs($i)"
		}
		set last_err_msg_cnt $q_cur_err_msg_cnt
	}

	set cmp_is_running [q_cmp_is_running]

	## do atleast one more loop after compilation has finished 
	##  to pipe in messages recieved after compilation has stopped.
	if { !$cmp_is_running && !$ok_to_quit_loop } {
		set ok_to_quit_loop 1; ## OK to quit after one more loop
	} elseif { !$cmp_is_running && $ok_to_quit_loop && !$got_new_msgs} {
		break; ## Break out of loop
	}

	# keep event loop active while we 'sleep' before 
	# checking compilation status
	set trigger 0
	after 100 { set trigger 1}
	vwait trigger
}

if { $q_err_msg_cnt > 0 } {
	puts "QUARTUS COMPILATION FAILED!!"
} else {
	puts "QUARTUS COMPILATION SUCCESSFUL!!"
}

##  detach connection with quartus tcl server(s)
q_detach
