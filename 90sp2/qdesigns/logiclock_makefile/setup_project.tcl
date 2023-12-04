
# Load all required Quartus Tcl packages
load_package flow
load_package project
load_package logiclock
load_package atoms

# Hard code top level project/revison name
set project chiptrip
set top_revision chiptrip

# Define modules to be compiled independently
set sub_revisions "auto_max speed_ch time_cnt tick_cnt"

# This is the origin of Logiclock region for each module
# ------------------------------------------------------
set origin(auto_max) LAB_X1_Y30
set origin(speed_ch) LAB_X1_Y29
set origin(time_cnt) LAB_X1_Y28
set origin(tick_cnt) LAB_X1_Y27

# These are the heights/widths for the LogicLock regions
# ------------------------------------------------------
set width(auto_max) 4
set height(auto_max) 1

set width(speed_ch) 4
set height(speed_ch) 1

set width(time_cnt) 4
set height(time_cnt) 1

set width(tick_cnt) 4
set height(tick_cnt) 1


# This is the name of the instance corresponding to each
# entity
# ------------------------------------------------------
set instance_name(auto_max) auto_max
set instance_name(speed_ch) speed_ch
set instance_name(time_cnt) time_cnt
set instance_name(tick_cnt) tick_cnt

# ------------------------------------------------------

# ------------------------------------------------------
proc create_project { project_name } {
# ------------------------------------------------------

	# Make sure everybody is compiling for same part
	project_new $project_name -overwrite

	set_global_assignment -name FAMILY Stratix
	set_global_assignment -name DEVICE EP1S10B672C6
	set_global_assignment -name TOP_LEVEL_ENTITY $project_name
}

# ------------------------------------------------------
proc create_logiclock_region { name origin height width } {
# ------------------------------------------------------

	initialize_logiclock

	set_logiclock -region region_$name -height $height -width $width -origin $origin -floating false -auto_size false
	set_logiclock_contents -region region_$name -to *

	uninitialize_logiclock
}

# ------------------------------------------------------
proc execute { command } {
# ------------------------------------------------------
	puts stderr "$command"
	qexec "$command"
}

# ------------------------------------------------------
proc compile_modules { sub_revisions } {
# ------------------------------------------------------

	global origin
	global height
	global width
	
	# ----------------------------------------------------------------------
	# Compile each module on its own
	foreach sub_revision $sub_revisions {
		puts stderr ""
		puts stderr "** Setting up: $sub_revision $origin($sub_revision)"
		create_project $sub_revision
		create_logiclock_region $sub_revision $origin($sub_revision) $height($sub_revision) $width($sub_revision)
		# If low level Tcl file exist (with low level assignments) source it
		if [file exists asgn_${sub_revision}.tcl] { source asgn_${sub_revision}.tcl }
		project_close

		# Do MAP and FIT and then create ATM/HDBX file
		execute "quartus_map $sub_revision"
		execute "quartus_fit $sub_revision"
		execute "quartus_cdb -t modular_output.tcl $sub_revision"
	}
}

puts stderr "**************************************************************"
set do_modules 1
if { $argc == 1 } {
	set do_modules $argv
}
puts stderr "do_modules (compile sub modules) = $do_modules"
puts stderr "**************************************************************"

if { $do_modules } {

	compile_modules $sub_revisions
}
puts stderr ""

# ----------------------------------------------------------------------
# Now create and compile top level
create_project $project

foreach sub_revision $sub_revisions {
	set_global_assignment -name VQM_FILE "./atom_netlists/${sub_revision}.vqm"
	set_instance_assignment -name LL_IMPORT_FILE "./atom_netlists/${sub_revision}.qsf" -to "$sub_revision:$instance_name($sub_revision)"
	set_instance_assignment -name LL_RCF_IMPORT_FILE "./atom_netlists/${sub_revision}.rcf" -to "$sub_revision:$instance_name($sub_revision)"
}

create_base_clock -fmax 10ns clock
export_assignments

# Run MAP on top level with the above black boxes
execute "quartus_map $top_revision --export=on"
# Merge low level ATM/HDBX databases
execute "quartus_cdb -t merge.tcl $top_revision"
# Finish compile
execute "quartus_fit $top_revision --import=on --export=on"
execute "quartus_tan $top_revision --import=on --export=on"

project_close
