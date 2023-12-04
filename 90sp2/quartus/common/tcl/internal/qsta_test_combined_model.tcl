set pvcs_revision(test_combined) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: qsta_test_combined_model.tcl
#
# Usage: quartus_sta --test_combined <project>
#
# Description:
#		This script compares results from
#         create_timing_netlist
#         create_timing_netlist -fast
# and
#         create_timing_netlist
#         set_operating_conditions -fast
#
#
# *************************************************************

# -------------------------------------------------
# -------------------------------------------------

proc register_result { model type } {

	# Cache all results for model (fast/slow) and 
	# type (setup/hold/recovery/removal)
	#
	# -------------------------------------------------
	# -------------------------------------------------

	set domain_list [get_clock_domain_info -$type]
	foreach domain $domain_list {
		set name [lindex $domain 0]
		set slack [lindex $domain 1]
		set ::results(${model}-${type}-${name}) $slack
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc check_result { model type } {

	# Compare slack for model (fast/slow) and
	# type (setup/hold/recovery/removal)
	# Give ERROR if expected and actual slacks are not
	# the same, and set the global not_ok variable to 1
	#
	# -------------------------------------------------
	# -------------------------------------------------

	set domain_list [get_clock_domain_info -$type]
	foreach domain $domain_list {
		set name [lindex $domain 0]
		set slack [lindex $domain 1]
		if [expr $::results(${model}-${type}-${name}) == $slack] {
		} else {
			post_message -type error "NOT OK : $model $type $name"
			post_message -type error "       : Expected Slack = $::results(${model}-${type}-${name})"
			post_message -type error "       : Actual Slack   = $slack"
			incr ::combined_test_error_count
		}
	}
}

set ::combined_test_error_count 0

create_timing_netlist
read_sdc
update_timing_netlist
register_result slow setup
register_result slow hold
register_result slow recovery
register_result slow removal
delete_timing_netlist

create_timing_netlist -fast
read_sdc
update_timing_netlist
register_result fast setup
register_result fast hold
register_result fast recovery
register_result fast removal
delete_timing_netlist

# Now Test Combined Mode using set_operating_conditions
create_timing_netlist
read_sdc
update_timing_netlist
check_result slow setup
check_result slow hold
check_result slow recovery
check_result slow removal

# Load fast model here
set_operating_conditions -fast
update_timing_netlist
check_result fast setup
check_result fast hold
check_result fast recovery
check_result fast removal

delete_timing_netlist

post_message -type info "---------------------------------------"
if { $::combined_test_error_count > 0 } {
	post_message -type info "Number of errors: $::combined_test_error_count"
	post_message -type info "Combined Model Test Status: Fail"
} else {
	post_message -type info "Combined Model Test Status: Pass"
}
post_message -type info "---------------------------------------"
