
# This file contains the list of paramters to be used for the UTOPIA2 testbench
# Please refer to the manual to get the list correct values.

# uses the atlantic interface when 1
# uses the default interface when set to 0
set use_atlantic_interface 0



set parameter_list ""
lappend parameter_list UtCellSize          54
lappend parameter_list UtBusWidth          16
lappend parameter_list MasterUserCellSize  54
lappend parameter_list UserCellSize        54
lappend parameter_list UserBusWidth        16
lappend parameter_list ParityEnable        true
lappend parameter_list UtopiaClockPeriod   "20ns"
lappend parameter_list PhyClockPeriod      "20ns"  
lappend parameter_list PHYMode             "MPHY"        
lappend parameter_list num_slaves          2

set modelsim_parameters ""
foreach {i j} $parameter_list {
	append modelsim_parameters "-G${i}=${j} "
}

if {$use_atlantic_interface} {
	set top_level_name master_atlantic_example_tb
} else {
	set top_level_name master_example_tb
}
