package provide ::qpm::lib::rpt 1.0

#############################################################################
##  Additional Packages Required
load_package qcu
load_package report

# ----------------------------------------------------------------
#
namespace eval ::qpm::lib::rpt {
#
# Description: Configuration
#
# ----------------------------------------------------------------

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::rpt::ipc_restrict_percent_range {min max} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "restrict_percent_range -min $min -max $max"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::rpt::ipc_set_percent_range {low high} {
	# Update progress bar range
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "set_percent_range -low $low -high $high"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::rpt::ipc_report_status {percent} {
	# Update progress bar
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "report_status $percent"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::rpt::ipc_refresh_report {} {
	# Update progress bar
# -------------------------------------------------
# -------------------------------------------------

	global quartus

	if {$quartus(ipc_mode)} {
		puts "refresh_report"
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::rpt::update_report { app_name table header_row rows } {
	# Creates table if necessary
	# > app_name - Archive HardCopy Handoff Files
	# > table - Files Archived
	# > header_row - [list n1 n2 ...]
	# > rows - [list [list a1 a2] [list b1 b2] ...]
# -------------------------------------------------
# -------------------------------------------------

	set table "$app_name||$table"
	set table_id [get_report_panel_id $table]
	if {$table_id == -1} {
   		set table_id [create_report_panel -table $table]
		add_row_to_table -id $table_id $header_row
	}
	foreach row $rows {
		add_row_to_table -id $table_id $row
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::rpt::add_to_summary { app_name name value } {
	# Add name / value pair to Summary
# -------------------------------------------------
# -------------------------------------------------
	# Set panel name
	set panel "$app_name||$app_name Summary"
	# Get the panel id
	set id [get_report_panel_id $panel]

	if {$id != -1} {
		# If panel exists, add a row to it
		add_row_to_table -id $id [list $name $value]
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::rpt::prepare { app_name } {
	# Prepares the flow folder
	# > app_name - Archive HardCopy Handoff Files
# -------------------------------------------------
# -------------------------------------------------

	qcu_report_framework -prepare -app_name $app_name
	catch {save_report_database -skip_project_open_check}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::rpt::commit { app_name status } {
	# Prepares the flow folder
	# > app_name - Archive HardCopy Handoff Files
# -------------------------------------------------
# -------------------------------------------------
	set cmd "qcu_report_framework -commit -app_name \"$app_name\""
	if {$status} {
		append cmd " -status"
	}
	eval $cmd
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::rpt::save_report { } {
	# Save and refresh report
# -------------------------------------------------
# -------------------------------------------------
	catch {save_report_database}
	::qpm::lib::rpt::ipc_refresh_report
}
