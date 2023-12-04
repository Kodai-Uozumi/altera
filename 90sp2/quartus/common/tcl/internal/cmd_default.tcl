##################################################################
#
# File name:	CMD_DEFAULT.TCL
#
#	Description: Default script use by quartus_cmd when "-f" is 
#			not use.
#			quartus_cmd will call this script when a "-c" "-s" and "w"
#			option is used. The script is called with the project name as
#			the first argument, and then a collection of action point to
#			process:
#
#				CMP=<name>	For "-c <name>"
#				SIM=<name>	For "-s <name>"
#				SWB=<name>	For "-w <name>"
#
# Authors:		David Krchmer
#
#				Copyright (c) Altera Corporation 2001-.
#				All rights reserved.
#
##################################################################

# ----------------------------------------------------------------
proc do_cmp { cmp_name } {

#	Description: Create Compiler Setting if needed and Compile
# ----------------------------------------------------------------
	if { ! [project cmp_exists $cmp_name] } { 
		project create_cmp $cmp_name 
	}
	project set_active_cmp $cmp_name
	cmp start "compile"
	while { [cmp is_running] } { 
		FlushEventQueue 
	}
}

# ----------------------------------------------------------------
proc do_sim { sim_name } {

#	Description: Create Simulation Setting if needed and Simulate
# ----------------------------------------------------------------
	if { ! [project sim_exists $sim_name] } { 
		project create_sim $sim_name ;   
		# Just in case, make sure the Comiler Setting was already created
		# Note that we are assuming that the simulator is compiling a
		# Compiler setting of the same name, which may not be true. HINT_DK
		if { ! [project cmp_exists $sim_name] } { 
			project create_cmp $sim_name
		}
	}
	project set_active_sim $sim_name
	sim start "Simulator"
	while { [sim is_running] } { 
		FlushEventQueue 
	}
}

# ----------------------------------------------------------------
proc do_swb { swb_name } {

#	Description: Create Software mode if needed and execute
# ----------------------------------------------------------------
	if { ! [project swb_exists $swb_name] } { 
		project create_swb $swb_name
	}
	project set_active_swb $swb_name
	swb start
	while { [swb is_running] } { 
		FlushEventQueue 
	}
}



# BEGIN MAIN ----------------------------------------------------------------

# Check arguments
if { [ llength $q_args ] <=4 } {
	set project_name [lindex $q_args 0]
} else {
	puts "INTERNAL ERROR: Expected arguments are <project_name> cmp_name sim_name swb_name"
	puts "--> but got: $q_args"
	exit
}

# Create new project if needed and open
if { ! [project exists $project_name] } { 
	project create $project_name
}
project open $project_name

# Other than the first argument, which represents the project name
# all other arguments represent an action to take, and are of the form:
# "CMP=<cmp_name>", "SIM=<sim_name>", "SWB=<swb_name>"
foreach action $q_args {
	if [string match *=* $action] {
		set name_value [split $action "="]
		set action_type [lindex $name_value 0]
		set action_name [lindex $name_value 1]
		switch -exact $action_type {
			CMP { do_cmp $action_name }
			SIM { do_sim $action_name }
			SWB { do_swb $action_name }
		}
	}
}

# Close Project before leaving
project close
# END MAIN ----------------------------------------------------------------

