## *************************************************************
##
## Usage:       quartus_sh --archive [<options>] <project>
## Description: This script allows a user to easily archive project files.
##
##  ALTERA LEGAL NOTICE
##  
##  This script is  pursuant to the following license agreement
##  (BY VIEWING AND USING THIS SCRIPT, YOU AGREE TO THE
##  FOLLOWING): Copyright (c) 2009-2010 Altera Corporation, San Jose,
##  California, USA.  Permission is hereby granted, free of
##  charge, to any person obtaining a copy of this software and
##  associated documentation files (the "Software"), to deal in
##  the Software without restriction, including without limitation
##  the rights to use, copy, modify, merge, publish, distribute,
##  sublicense, and/or sell copies of the Software, and to permit
##  persons to whom the Software is furnished to do so, subject to
##  the following conditions:
##  
##  The above copyright notice and this permission notice shall be
##  included in all copies or substantial portions of the Software.
##  
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
##  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
##  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
##  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
##  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
##  OTHER DEALINGS IN THE SOFTWARE.
##  
##  This agreement shall be governed in all respects by the laws of
##  the State of California and by the laws of the United States of
##  America.
##
##
##  CONTACTING ALTERA
##  
##  You can contact Altera through one of the following ways:
##  
##  Mail:
##     Altera Corporation
##     Applications Department
##     101 Innovation Drive
##     San Jose, CA 95134
##  
##  Altera Website:
##     www.altera.com
##  
##  Online Support:
##     www.altera.com/mysupport
##  
##  Troubshooters Website:
##     www.altera.com/support/kdb/troubleshooter
##  
##  Technical Support Hotline:
##     (800) 800-EPLD or (800) 800-3753
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##     (408) 544-7000
##        7:00 a.m. to 5:00 p.m. Pacific Time, M-F
##  
##     From other locations, call (408) 544-7000 or your local
##     Altera distributor.
##  
##  The mySupport web site allows you to submit technical service
##  requests and to monitor the status of all of your requests
##  online, regardless of whether they were submitted via the
##  mySupport web site or the Technical Support Hotline. In order to
##  use the mySupport web site, you must first register for an
##  Altera.com account on the mySupport web site.
##  
##  The Troubleshooters web site provides interactive tools to
##  troubleshoot and solve common technical problems.
##
## *************************************************************

# -------------------------------------------------
# Available User Options for:
#    quartus_sh --archive [<options>] <project>
# -------------------------------------------------
set availableOptions {
	{ use_file_set.arg "#_ignore_#" "Option to specify the archive template to use\n                            \
-- Run -list_file_sets option to get\n                             a list of possible templates" }
	{ list_file_sets "Option to list archive templates to choose from when archiving a design" }
	{ use_file_subset.arg "#_ignore_#" "Option to specify the archive file subset to use\n                            \
-- Run -list_file_subsets option to get\n                             a list of possible file subsets" }
	{ list_file_subsets "Option to list archive packages to choose from when archiving a design" }
	{ list_files "Option to list files to archive" }
	{ include_export "Option to include version-compatible database" }
	{ include_export_all "Option to include version-compatible database" }
	{ include_export_post_map "Option to include post-mapping version-compatible database" }
	{ force "Option to force quartus_map to run even when database exists" }
	{ readme "Option to display readme" }
	{ export "Option to export version-compatible database" }
	{ export_all "Option to export version-compatible database" }
	{ export_post_map "Option to export post-mapping version-compatible database" }
	{ revision.arg "#_ignore_#" "Option to specify the revision name" }
	{ input.arg "#_ignore_#" "Option to specify the input file name containing new-line separated list of files to archive" }
	{ output.arg "#_ignore_#" "Option to specify the output file name" }
	{ content "Option to display the content of the specified Quartus II Archive File (.qar)" }
	{ ascii.arg "#_ignore_#" "Option to output the list of files to be archived into the specified text file" }
	{ self_test "self test mode" }
	{ no_discover "Option not to run quartus_map to discover source files" }
	{ fix_qsf "Option to fix the .qsf file by adding a <revision>.archive.qip to the project so that the project archives properly" }
	{ exclude_file_subset.arg "#_ignore_#" "Option to specify the archive file subset to exclude\n                            \
-- Run -list_file_subsets option to get\n                             a list of possible file subsets" }
	{ all_revisions "Option to create an archive for each revision" }
	{ no_overwrite "Option not to overwrite files" }
	{ overwrite "Option to overwrite files" }
	{ disable_search_path_update "Option not to update included file information" }
	{ include_output "Include the compilation database" }
	{ ui "Option to automatically open the project in the Quartus II UI after restoring the .qar file" }
	{ discover "Option to run quartus_map to discover source files" }
	{ internal_test "internal test mode" }
	{ redo_qic_designs "internal test mode" }
	{ compile_after_restore "internal test mode" }
	{ smart "Option to automatically detect and create an archive for each revision (.qsf) in all projects (.qpf) in the current directory" }
	{ auto "Option to automatically detect source files to archive" }
	{ no_auto "Option not to automatically detect source files to archive" }
	{ old "old mode" }
	{ tcl "tcl mode" }
	{ qda "qda mode" }
	{ qar "qar mode" }

	{ hcii.secret "Option to restore HardCopy Handoff Files Archive" }
	{ hc.secret "Option to restore HardCopy Handoff Files Archive" }
	{ password.arg.secret "#_ignore_#" "Option to specify the password" }
	{ unqar "unqar mode" }
}

# -------------------------------------------------
# Other Global variables
# -------------------------------------------------
array set info_map {}

# -------------------------------------------------
# Load Required Packages
# -------------------------------------------------
package require cmdline
package require ::qpm::lib::ccl
package require ::qpm::lib::rpt
package require ::qpm::lib::self_test
package require ::qpm::lib::old_restore
load_package flow
load_package file_manager

# ----------------------------------------------------------------
#
namespace eval ::qpm::qar {
#
# Description: Configuration
#
# ----------------------------------------------------------------

    namespace export main

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!

    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

    variable is_qar_mode 0
	variable use_templates ""
	variable use_packages ""
	variable exclude_packages
	variable use_custom_template 0
    variable app_name ""
	variable is_only_input_file 0
	variable restore_status_is_posted 0
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::ipc_restrict_percent_range {min max} {
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
proc ::qpm::qar::ipc_set_percent_range {low high} {
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
proc ::qpm::qar::ipc_report_status {percent} {
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
proc ::qpm::qar::display_banner {} {
	# Display start banner
# -------------------------------------------------
# -------------------------------------------------

	variable pvcs_revision

	post_message -type info "[file tail [info script]] version $pvcs_revision"

	##---- 0% - 18% progress ----##
	::qpm::qar::ipc_set_percent_range 0 18

	::qpm::qar::ipc_report_status 0
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::process_special_options {argument_list} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global info_map

	variable is_qar_mode
	variable use_custom_template
	variable use_templates
	variable use_packages
	variable exclude_packages

	set new_argument_list [list]

	set last_is_use_template 0
	set last_is_use_package 0
	set last_is_exclude_package 0

	array set templates_used {}
	array set pkgs_used {}
	array set exclude_packages {}

    foreach current_argument $argument_list {
		# post_message "-> $current_argument"
		if {$last_is_use_template} {
			set last_is_use_template 0
			set template [string tolower $current_argument]

			if {[info exists templates_used($template)] && $templates_used($template)} {
				# remove duplicates
			} else {
				set templates_used($template) 1
				lappend use_templates $template
				if {[string compare -nocase $template "custom"] == 0} {
					set use_custom_template 1
				}
			}
		} elseif {$last_is_use_package} {
			set last_is_use_package 0
			set pkg [string tolower $current_argument]

			if {[info exists pkgs_used($pkg)] && $pkgs_used($pkg)} {
				# remove duplicates
			} else {
				set pkgs_used($pkg) 1
				lappend use_packages $pkg
			}
		} elseif {$last_is_exclude_package} {
			set last_is_exclude_package 0
			set pkg [string tolower $current_argument]
			set exclude_packages($pkg) 1
		} elseif { [string match -nocase "-qar" $current_argument] } {
			set is_qar_mode 1
		} elseif { [string match -nocase "-unqar" $current_argument] } {
			set is_qar_mode 0
		} elseif { [string match -nocase "-use_file_set" $current_argument] } {
			set last_is_use_template 1
		} elseif { [string match -nocase "-use_file_subset" $current_argument] } {
			set last_is_use_package 1
		} elseif { [string match -nocase "-exclude_file_subset" $current_argument] } {
			set last_is_exclude_package 1
        } else {
			lappend new_argument_list $current_argument
		}
    }

    return $new_argument_list
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::get_usage {} {
	# Get usage
# -------------------------------------------------
# -------------------------------------------------

	variable is_qar_mode

	if {$is_qar_mode} {
		set usage "\[<options>\] <project_name>:"
	} else {
		set usage "\[<options>\] <archive_file>:"
	}

	return $usage
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::get_mode {} {
	# Get mode
# -------------------------------------------------
# -------------------------------------------------

	variable is_qar_mode

	if {$is_qar_mode} {
		set mode "archive"
	} else {
		set mode "restore"
	}

	return $mode
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::process_options {} {
	# Process user entered options
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global quartus

	variable is_qar_mode
	variable use_templates
	variable app_name
	variable is_only_input_file

	set argument_list $quartus(args)
    set argument_list [::qpm::qar::process_special_options $argument_list]

	# Define argv0 for the cmdline package to work properly
	set usage [::qpm::qar::get_usage]
	set mode [::qpm::qar::get_mode]
	set argv0 "quartus_sh --$mode"

	# Use cmdline package to parse options
	if [catch {array set info_map [cmdline::getoptions argument_list $::availableOptions]} result] {
		if {[llength $argument_list] > 0} {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Found illegal or missing options: $argument_list"
		}
		post_message -type error "For more details, use 'quartus_sh --help=$mode'"
		return 0
	}

	if {[::qpm::lib::ccl::is_user_entered $info_map(input)]} {
		set is_only_input_file 1
	}

	if {!$info_map(tcl)} {
		if {[llength $use_templates] > 1} {
			post_message -type error "More than one -use_file_set option was specified -- specify one and only one -use_file_set option"
			return 0
		}
		if {[::qpm::lib::ccl::is_user_entered $info_map(all_revisions)]} {
			foreach key [array names info_map] {
				set option_is_okay 0
				foreach allowed_option [list all_revisions use_file_set use_file_subset output] {
					if {[string compare -nocase $key $allowed_option] == 0} {
						set option_is_okay 1
					}
				}
				if {!$option_is_okay} {
					if {[::qpm::lib::ccl::is_user_entered $info_map($key)]} {
						post_message -type error "Options -all_revisions and -$key are mutually exclusive -- specify one and only one option"
						return 0
					}
				}
			}
		}
	}

	# cmdline::getoptions modifies the argument_list.
	# However, it ignores positional arguments.
	# One and only one positional argument (the project) is expected.
	# Issue an error if otherwise.
	if {[llength $argument_list] == 1} {

		if {$is_qar_mode} {
			set project_file_name [lindex $argument_list 0]
			set project_file_dir [file dirname $project_file_name]
			cd $project_file_dir
			set project_file_name [file tail $project_file_name]
			while {[string compare [file extension $project_file_name] ""] != 0} {
				set project_file_name [file rootname $project_file_name]
			}
			set info_map(project) $project_file_name
			if {$is_only_input_file} {
				set is_only_input_file 0
			}
		} else {
			set qar_file [::qpm::lib::ccl::get_archive_filename [lindex $argument_list 0] $info_map(qda)]
			if {[file exists $qar_file]} {
					# we must normalize file so that 'add_row_to_table -id $table_id $row' works
				set info_map(project) [file normalize $qar_file]
				#set info_map(project) $qar_file
			} else {
				post_message -type Error "Archive file '$qar_file' does not exist"
				return 0
			}
		}

	} elseif {!$is_only_input_file && !$info_map(readme) && !$info_map(list_file_sets) && !$info_map(list_file_subsets)} {

		set success 0
		if {$is_qar_mode} {
			if {[llength $argument_list] == 0} {
				set found_project 0
				if {[::qpm::lib::ccl::is_user_entered $info_map(internal_test)] || [::qpm::lib::ccl::is_user_entered $info_map(smart)]} {
					set info_map(project) [::qpm::lib::ccl::nocase_glob [list *.qpf]]
					if {[llength $info_map(project)] > 0} {
						set found_project 1
					} else {
						set info_map(project) [::qpm::lib::ccl::nocase_glob [list *.qsf]]
						if {[llength $info_map(project)] > 0} {
							set found_project 1
						}
					}
				}
				if {$found_project} {
					set success 1
				} else {
					post_message -type error "Project name is missing"
				}
			} else {
				post_message -type error "More than one project name specified: $argument_list"
			}
		} else {
			if {[llength $argument_list] == 0} {
				post_message -type error "Archive file name is missing"
			} else {
				post_message -type error "More than one archive file name specified: $argument_list"
			}
		}
		if {!$success} {
			post_message -type info "For more details, use 'quartus_sh --help=$mode'"
			return 0
		}
	}

	set xor_pairs [list \
					[list include_export include_export_post_map] \
					[list export export_post_map] \
					[list include_export_all include_export_post_map] \
					[list export_all export_post_map] \
					[list overwrite no_overwrite] \
					[list list_files output]]

	if {[::qpm::lib::ccl::is_user_entered $info_map(export)]} {
		set info_map(export_all) $info_map(export)
	}
	if {[::qpm::lib::ccl::is_user_entered $info_map(export_all)]} {
		set info_map(include_export) $info_map(export_all)
	}
	if {[::qpm::lib::ccl::is_user_entered $info_map(include_export)]} {
		set info_map(include_export_all) $info_map(include_export)
	}

	foreach xor_pair $xor_pairs {
		set p1 [lindex $xor_pair 0]
		set p2 [lindex $xor_pair 1]
		if {[::qpm::lib::ccl::is_user_entered $info_map($p1)] && [::qpm::lib::ccl::is_user_entered $info_map($p2)]} {
			post_message -type error "Options -$p1 and -$p2 are mutually exclusive -- specify one and only one option"
			return 0
		}
	}

	if {[::qpm::lib::ccl::is_user_entered $info_map(revision)]} {
		while {[string compare [file extension $info_map(revision)] ""] != 0} {
			set info_map(revision) [file rootname $info_map(revision)]
		}
	}

	if {$is_qar_mode} {
		set app_name [lindex [get_all_builtin_flows -debug_name archive_project -pretty] 0]
	} else {
		set app_name [lindex [get_all_builtin_flows -debug_name restore_project -pretty] 0]
	}
	ipc_report_status 40

	return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::open_project { project_name revision_name } {
	# Open project if necessary
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global quartus

	if {![project_exists $project_name]} {
		if {$info_map(old)} {
				# Create new project if needed and open
			msg_vdebug "Creating Project: $project_name (Rev = $revision_name)" 
			if {[::qpm::lib::ccl::is_user_entered $revision_name]} {
				project_new $project_name -revision $revision_name
			} else {
				project_new $project_name
			}
			project_close
		} else {
			post_message -type error "Project '$project_name' does not exist"
			return 0
		}
	}

	if {[::qpm::lib::ccl::is_user_entered $revision_name]} {
		if {![revision_exists $revision_name -project $project_name]} {
			post_message -type error "Project '$project_name' with revision '$revision_name' does not exist"
			return 0
		}
	}

		# Open the project and create one if necessary
	msg_vdebug "Opening project: $project_name (revision = $revision_name)" 

	if {[::qpm::lib::ccl::is_user_entered $revision_name]} {
		if [catch {project_open $project_name -revision $revision_name -force}] {
			post_message -type error "Project $project_name (using $revision_name.qsf) could not be opened"
			return 0
		}
	} else {
		if [catch {project_open $project_name -current_revision -force}] {
			post_message -type error "Project $project_name (using the current revision's .qsf file) could not be opened"
			return 0
		}
		set revision_name $quartus(settings)
		set info_map(revision) $revision_name
	}

	if {[is_project_open] == 0} {

		post_message -type error "Failed to open project: $project_name"
		return 0
	}

	msg_vdebug "project   = $project_name"
	msg_vdebug "revision  = $revision_name"

	::qpm::qar::ipc_report_status 100

	return 1
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::close_project {} {
	# Close project if necessary
# -------------------------------------------------
# -------------------------------------------------

	::qpm::qar::ipc_report_status 100

	# Close project before exiting
	project_close
}

#############################################################################
##  Procedure:  ::qpm::qar::load_plugins
##
##  Arguments:
##      None
##
##  Description:
##		HACK: Need to centralize this into a namespace!! (pwu)
##
##      Look for all files of the form qpm-<ID>-template.tcl under
##      the QPM packages directory, and for each one, package require
##      it and get its name.
##      Build the archive_template_info and archive_template_ids with it
proc ::qpm::qar::load_plugins {} {

	global archive_template_info
	global archive_template_ids
	global archive_template_default_id
	global archive_package_info

	variable use_custom_template

	set archive_packages [::qpm::lib::ccl::get_ordered_list_of_pkgs 0]

	foreach archive_id [::qpm::lib::ccl::get_ordered_list_of_templates 0] {

		set archive_desc [::qpm::template::${archive_id}::get_title]
		set archive_template_info($archive_id) $archive_desc

		if {[::qpm::template::${archive_id}::is_default]} {
			set archive_template_default_id $archive_id
		}
		lappend archive_template_ids $archive_id
	}

	foreach pkg $archive_packages {
		if {[::qpm::pkg::${pkg}::is_hidden] && !$use_custom_template} {
            # post_message "Hidden: $pkg"
		} else {
				# allow all pkgs when using "custom" template
			set archive_package_info($pkg) 1
		}
	}
}

#############################################################################
##  Procedure:  ::qpm::qar::do_pretty_print
##
##  Arguments:
##      None
##
##  Description:
##		HACK: Need to centralize this into a namespace!! (pwu)
##
##      List all templates.
proc ::qpm::qar::do_pretty_print { lines } {

		# Subtract 5 for padding
		# 80 is typical size of console
	set max_length [expr {80 - 5}]
		# Now print
	foreach line $lines {
		if {[string compare "" $line] == 0} {
			puts ""
		} else {
			set words [split $line]
			set msg ""
			foreach word $words {
				set is_msg_empty [expr {[string compare "" $msg] == 0}]
				if {!$is_msg_empty} {
					set potential "$msg $word"
				} else {
					set potential $word
				}
				if {!$is_msg_empty && [string length $potential] >= $max_length} {
					puts $msg
					set msg $word
				} else {
					set msg $potential
				}
			}
				# finish up with the last line
			if {[string compare "" $msg]} {
				puts $msg
			}
		}
	}
}

#############################################################################
##  Procedure:  ::qpm::qar::list_file_subsets
##
##  Arguments:
##      None
##
##  Description:
##		HACK: Need to centralize this into a namespace!! (pwu)
##
##      List all templates.
proc ::qpm::qar::list_file_subsets { pkgs } {

	global archive_template_info
	global archive_template_ids
	global archive_package_info

	set pkgs [lsort -dictionary $pkgs]

	array set id2desc {}

	# Set up the column widths
	set col1 "File Subset ID"
	set col2 "Description"
	set w1 [expr {[string length $col1] + 2}]
	set w2 [expr {[string length $col2] + 2}]

	foreach pkg $pkgs {
		set temp_id $pkg
		if {[string length $pkg] > $w1} {
			set w1 [string length $pkg]
		}
	}
		# Subtract 5 for "|  |  |"
	set max_length [expr {80 - $w1 - 7}]
	# puts "max_length : $max_length"

		# Set up template description
	foreach pkg $pkgs {

			# get description
		set paragraphs [list "The '[::qpm::pkg::${pkg}::get_title]' file subset" ""]
		foreach line [::qpm::lib::ccl::get_package_description $pkg] {
			lappend paragraphs $line
		}

		foreach paragraph $paragraphs {

			if {[string compare "" $paragraph] == 0} {
				lappend id2desc($pkg) ""
			}

			set words [split $paragraph]
			set msg ""
			foreach word $words {

				set is_msg_empty [expr {[string compare "" $msg] == 0}]

				if {!$is_msg_empty} {
					set potential "$msg $word"
				} else {
					set potential $word
				}

				if {!$is_msg_empty && [string length $potential] >= $max_length} {
					lappend id2desc($pkg) $msg
					if {[string length $msg] > $w2} {
						set w2 [string length $msg]
						# puts "w2 : $w2"
					}
					set msg $word
					# puts "msg : $word : $msg"
				} else {
					set msg $potential
					# puts "potential : [string length $potential] : $potential"
				}
			}
				# finish up with the last line
			if {[string compare "" $msg]} {
				lappend id2desc($pkg) $msg
				# puts "id2desc : $id2desc($pkg)"
				if {[string length $msg] > $w2} {
					set w2 [string length $msg]
					# puts "w2 : $w2"
				}
			}
		}
	}

		# Set title
	set title "File Subsets"

		# add 3 for the middle " | "
	set total_w [expr {$w1+$w2+3}]
	set title_w [string length $title]
		# puts "$total_w : $title_w"
		# puts "w1 : $w1"
		# puts "w2 : $w2"
	set tw [expr {($total_w/2)-($title_w/2)}]
	set title_sep_before [string repeat " " $tw]
	set title_sep_after [string repeat " " [expr {$total_w - $tw - $title_w}]]

		# Make a nice header (with separator) for the table first
	set sep +-[string repeat - $w1]-+-[string repeat - $w2]-+
	puts $sep
		# Add 5 for the spaces between the bars, | and |, and for the middle bar, |.
	puts "| $title_sep_before$title$title_sep_after |"

		# Headers
	puts $sep
	puts [format "| %-*s | %-*s |" $w1 $col1 $w2 $col2]
	puts $sep

		# Print the contents of the table
	foreach pkg $pkgs {
		set temp_id $pkg
		foreach temp_desc $id2desc($pkg) {
			puts [format "| %-*s | %-*s |" $w1 $temp_id $w2 $temp_desc]
			set temp_id ""
		}
		puts $sep
	}
}

#############################################################################
##  Procedure:  ::qpm::qar::list_file_sets
##
##  Arguments:
##      None
##
##  Description:
##		HACK: Need to centralize this into a namespace!! (pwu)
##
##      List all templates.
proc ::qpm::qar::list_file_sets {} {

	global archive_template_info
	global archive_template_ids
	array set id2desc {}
	array set listed_pkgs {}

	# Set up the column widths
	set col1 "File Set ID"
	set col2 "Description"
	set w1 [expr {[string length $col1] + 2}]
	set w2 [expr {[string length $col2] + 2}]
	foreach archive_id $archive_template_ids {
		set temp_id $archive_id
#		if {[::qpm::template::${archive_id}::is_default]} {
#			set temp_id "* $archive_id *"
#		}
		if {[string length $archive_id] > $w1} {
			set w1 [string length $archive_id]
		}
	}
		# Subtract 5 for "|  |  |"
	set max_length [expr {80 - $w1 - 7}]
	# puts "max_length : $max_length"

		# Set up template description
	foreach archive_id $archive_template_ids {

			# get description
		set paragraphs [list "The '$archive_template_info($archive_id)' file set" ""]

			# get packages title
		foreach line [::qpm::lib::ccl::get_composed_of_packages_string [::qpm::template::${archive_id}::get_packages]] {
			lappend paragraphs $line
		}

			# get packages description
		foreach pkg [::qpm::template::${archive_id}::get_packages] {
			set listed_pkgs($pkg) 1
		}

		foreach paragraph $paragraphs {

			if {[string compare "" $paragraph] == 0} {
				lappend id2desc($archive_id) ""
			}

			set words [split $paragraph]
			set msg ""
			foreach word $words {

				set is_msg_empty [expr {[string compare "" $msg] == 0}]

				if {!$is_msg_empty} {
					set potential "$msg $word"
				} else {
					set potential $word
				}

				if {!$is_msg_empty && [string length $potential] >= $max_length} {
					lappend id2desc($archive_id) $msg
					if {[string length $msg] > $w2} {
						set w2 [string length $msg]
						# puts "w2 : $w2"
					}
					set msg $word
					# puts "msg : $word : $msg"
				} else {
					set msg $potential
					# puts "potential : [string length $potential] : $potential"
				}
			}
				# finish up with the last line
			if {[string compare "" $msg]} {
				lappend id2desc($archive_id) $msg
				# puts "id2desc : $id2desc($archive_id)"
				if {[string length $msg] > $w2} {
					set w2 [string length $msg]
					# puts "w2 : $w2"
				}
			}
		}
	}

		# Set title
	set title "File Sets"

		# add 3 for the middle " | "
	set total_w [expr {$w1+$w2+3}]
	set title_w [string length $title]
		# puts "$total_w : $title_w"
		# puts "w1 : $w1"
		# puts "w2 : $w2"
	set tw [expr {($total_w/2)-($title_w/2)}]
	set title_sep_before [string repeat " " $tw]
	set title_sep_after [string repeat " " [expr {$total_w - $tw - $title_w}]]

		# Make a nice header (with separator) for the table first
	set sep +-[string repeat - $w1]-+-[string repeat - $w2]-+
	puts $sep
		# Add 5 for the spaces between the bars, | and |, and for the middle bar, |.
	puts "| $title_sep_before$title$title_sep_after |"

		# Headers
	puts $sep
	puts [format "| %-*s | %-*s |" $w1 $col1 $w2 $col2]
	puts $sep

		# Print the contents of the table
	foreach archive_id $archive_template_ids {
		set temp_id $archive_id
#		if {[::qpm::template::${archive_id}::is_default]} {
#			set temp_id "* $archive_id *"
#		}
		foreach temp_desc $id2desc($archive_id) {
			puts [format "| %-*s | %-*s |" $w1 $temp_id $w2 $temp_desc]
			set temp_id ""
		}
		puts $sep
	}

	puts ""
	::qpm::qar::list_file_subsets [array names listed_pkgs]
}

#############################################################################
##  Procedure:  ::qpm::qar::check_templates
##
##  Arguments:
##      None
##
##  Description:
##		HACK: Need to centralize this into a namespace!! (pwu)
##
##      Init the archive template.
proc ::qpm::qar::check_templates {} {

	global archive_template_info
	global archive_template_ids
	global archive_template_default_id
	global archive_package_info
	global info_map

	variable use_custom_template
	variable use_templates
	variable use_packages
	variable exclude_packages

	set success 1

	foreach pkg [concat $use_packages [array names exclude_packages]] {
		if {![::qpm::lib::ccl::pkg_exists $pkg]} {
			post_message -type error "Illegal archive file subset: $pkg. Run -list_file_subsets option to get a list of possible file subsets."
			set success 0
		}
	}

	if {[string compare "" $use_templates]} {
		if {!$use_custom_template} {
			foreach template $use_templates {
				if {![::qpm::lib::ccl::template_exists $template]} {
					post_message -type error "Illegal file set: $template. Run -list_file_sets option to get a list of possible templates."
					set success 0
				}
			}
		}
	}
	if {$info_map(include_output)} {
		lappend use_templates full_db
	}
	if {[string compare "" $use_templates] == 0} {
		post_message "Including '-use_file_set $archive_template_default_id' by default"
		set use_templates $archive_template_default_id
	}

	return $success
}

# ----------------------------------------------------------------
#
proc ::qpm::qar::begin_restrict_files {} {
#
# Description: In UI, user selects to remove or add files.
#
# ----------------------------------------------------------------
	variable m_excludeFiles
	variable m_includeFiles
	variable m_orig_directory

	set m_orig_directory [pwd]
	array set m_excludeFiles {}
	array unset m_excludeFiles
	array set m_excludeFiles {}
	array set m_includeFiles {}
	array unset m_includeFiles
	array set m_includeFiles {}
}

# ----------------------------------------------------------------
#
proc ::qpm::qar::get_normalized_file { file } {
#
# Description: In UI, user selects to remove or add files.
#
# ----------------------------------------------------------------
	variable m_excludeFiles
	variable m_includeFiles
	variable m_orig_directory

	set file_name [file normalize $file]
	set file_tail [file tail $file_name]
	set file_dir  [file dirname $file_name]
	return [file join [::qpm::lib::ccl::make_file_path_relative $m_orig_directory $file_dir] $file_tail]
}

# ----------------------------------------------------------------
#
proc ::qpm::qar::is_files_equal { file_a file_b } {
#
# Description: In UI, user selects to remove or add files.
#
# ----------------------------------------------------------------
	return [expr {[string compare [::qpm::qar::get_normalized_file $file_a] [::qpm::qar::get_normalized_file $file_b]] == 0}]
}

# ----------------------------------------------------------------
#
proc ::qpm::qar::add_excluded_file { file } {
#
# Description: In UI, user selects to remove or add files.
#
# ----------------------------------------------------------------
	variable m_excludeFiles
	variable m_includeFiles
	variable m_orig_directory

	set m_excludeFiles([::qpm::qar::get_normalized_file $file]) 1
}

# ----------------------------------------------------------------
#
proc ::qpm::qar::is_excluded_file { file } {
#
# Description: In UI, user selects to remove or add files.
#
# ----------------------------------------------------------------
	variable m_excludeFiles
	variable m_includeFiles
	variable m_orig_directory

	return [info exists m_excludeFiles([::qpm::qar::get_normalized_file $file])]
}

#############################################################################
##  Procedure:  ::qpm::qar::get_archive_files
##
##  Arguments:
##      None
##
##  Description:
##		HACK: Need to centralize this into a namespace!! (pwu)
##
##      Get the list of archive files.
proc ::qpm::qar::get_archive_files { do_prepare_report } {

	global info_map
    variable app_name

	variable use_templates
	variable use_packages
	variable use_custom_template
	variable is_only_input_file
	variable exclude_packages

	array set archiveFiles {}

	if {[::qpm::lib::ccl::is_user_entered $info_map(content)]} {
		set qar_file_name $info_map(project)
		if {[catch {set files [unqar -content $qar_file_name]} result]} {
			if {[string length $result] > 0} {
				post_message -type error $result
			}
			post_message -type Error "Failed to display the content of $qar_file_name -- make sure you specified a valid archive file"
			qexit -error
		} else {
			post_message -type Info "Successfully read $qar_file_name"
			foreach file $files {
				set archiveFiles($file) 1
			}
		}
	} else {

		::qpm::qar::begin_restrict_files

		if {[::qpm::lib::ccl::is_user_entered $info_map(input)]} {

			set log $info_map(input)
			if {![file exists $log]} {
				post_message -type error "Input file '$log' does not exist"
				qexit -error
			} elseif {[catch {open $log r} logid]} {
				post_message -type error "Couldn't open input file '$log' for reading"
				qexit -error
			} else {
				while {[gets $logid file] >= 0} {
					if {[string length $file] > 0} {
						set archiveFiles([::qpm::qar::get_normalized_file $file]) 1
					}
				}
				close $logid
			}
		}

		if {!$is_only_input_file} {

				# include other packages
			array set pkgs_used {}
			array set is_template_pkg {}
			foreach pkg $use_packages {
				set pkgs_used($pkg) 1
				::qpm::lib::ccl::print_message -info "Including: [::qpm::pkg::${pkg}::get_title]"
			}

				# when using the hidden custom template,
				# user is required to specify the -use_file_subset option.
			if {!$use_custom_template} {
				foreach template $use_templates {
					foreach pkg [::qpm::template::${template}::get_packages] {
						set pkgs_used($pkg) 1
						set is_template_pkg($pkg) 1
					}
				}
			}

			if {$info_map(hc)} {
				set pkgs_used(export_db_hc) 1
				if {[::qpm::pkg::export_db_hc::is_legal]} {
					::qpm::lib::ccl::print_message -info "Including: [::qpm::pkg::export_db_hc::get_title]"
				}
			}

			if {$info_map(no_auto)} {
					# disable
				::qpm::pkg::auto::set_auto 0
				unset pkgs_used(auto)
			} elseif {$info_map(auto)} {
				set pkgs_used(auto) 1
				::qpm::lib::ccl::print_message -info "Including: [::qpm::pkg::auto::get_title]"
			}

			if {$info_map(include_export_all)} {
				set pkgs_used(export_db_all) 1
				::qpm::lib::ccl::print_message -info "Including: [::qpm::pkg::export_db_all::get_title]"
			} elseif {$info_map(include_export_post_map)} {
				set pkgs_used(export_db_post_map) 1
				::qpm::lib::ccl::print_message -info "Including: [::qpm::pkg::export_db_post_map::get_title]"
			}

			foreach pkg [array names pkgs_used] {
				if {[info exists exclude_packages($pkg)]} {
					::qpm::lib::ccl::set_excluded_archive_package $pkg
				}
			}

			if {[::qpm::lib::ccl::is_user_entered $info_map(input)]} {
				array set tmp_pkgs_used {}

					# SPR:292527 - GUI archiver adds removed file
				if {!$use_custom_template} {
						# when using the hidden custom template,
						# user is required to specify the -use_file_subset option.
					foreach template $use_templates {
						foreach pkg [::qpm::template::${template}::get_packages] {
							set tmp_pkgs_used($pkg) 1
						}
					}
				}

				foreach pkg [array names pkgs_used] {
					if {![info exists is_template_pkg($pkg)] || !$is_template_pkg($pkg)} {
						set tmp_pkgs_used($pkg) 1
					}
				}

				::qpm::lib::ccl::set_mimick_gui_mode 1
				foreach pkg [array names tmp_pkgs_used] {
					foreach file [::qpm::pkg::${pkg}::get_archive_files] {
						if {![info exists archiveFiles([::qpm::qar::get_normalized_file $file])]} {
							add_excluded_file $file
						}
					}
				}
				::qpm::lib::ccl::set_mimick_gui_mode 0
			}

				# Run A & S if:
				#	1) -discover was specified OR
				#	2) 'auto' package is enabled and -no_discover is not specified
			if {$info_map(discover) || (!$info_map(no_discover) && [info exists pkgs_used(auto)] && $pkgs_used(auto))} {
				set do_run_discover 0
				if {[::qpm::lib::ccl::is_hardcopy_stratix]} {
					# No need to run Elaboration when the old archiver is used
				} elseif {[::qpm::lib::ccl::is_mapper_required]} {
					# the revision doesn't contain db/ files. ok to continue.
					set do_run_discover 1
				} elseif {$info_map(force)} {
					::qpm::lib::ccl::print_message -warning "-force option was specified. Overwriting compiler database by running 'quartus_map' to discover source files."
					set do_run_discover 1
				} elseif {$info_map(discover)} {
					::qpm::lib::ccl::print_message -warning "Not running 'quartus_map' to discover source files since the compiler database for revision '$info_map(revision)' already exists."
				}
				if {$do_run_discover} {
						# need to unload the report so we don't lose the results
						# for this run when writing the report in ::qpm::lib::rpt::prepare
					catch {unload_report}
					::qpm::lib::ccl::run_discover_source_files [expr {$info_map(export_all) || $info_map(export_post_map)}]
				}
			}

			if {$do_prepare_report} {
					# update the report database
				::qpm::lib::rpt::prepare $app_name
			}

			if {$info_map(export_all)} {
				::qpm::lib::ccl::run_export_database 0
			} elseif {$info_map(export_post_map)} {
				::qpm::lib::ccl::run_export_database 1
			}

				# when using the hidden custom template,
				# user is required to specify the -use_file_subset option.
			if {!$use_custom_template} {
				foreach template $use_templates {
					foreach file [::qpm::template::${template}::get_archive_files] {
						if {![is_excluded_file $file]} {
							set archiveFiles($file) 1
						}
					}
				}
			}

			set all_pkgs_used [array names pkgs_used]

			if {[llength $all_pkgs_used] > 0} {
				if {$use_custom_template} {
					post_message "File Set '[::qpm::template::custom::get_title]' contains:" -submsgs [::qpm::lib::ccl::get_tcl_list_of_pkg_titles [array names pkgs_used]]
				}
				foreach pkg $all_pkgs_used {
					if {![info exists is_template_pkg($pkg)] || !$is_template_pkg($pkg)} {
						foreach file [::qpm::pkg::${pkg}::get_archive_files] {
							if {![is_excluded_file $file]} {
								set archiveFiles($file) 1
							}
						}
					}
				}
			}

			if {$info_map(no_auto)} {
					# re-enable
				::qpm::pkg::auto::set_auto 1
			}
		}
	}

	set files_to_archive [lsort -dictionary [array names archiveFiles]]

	if {![::qpm::lib::ccl::is_user_entered $info_map(content)]} {
		if {[string compare "" $files_to_archive] == 0} {
			::qpm::lib::ccl::print_message -error "No files to archive"
		}
	}

	return $files_to_archive
}

#############################################################################
##  Procedure:  ::qpm::qar::list_files
##
##  Arguments:
##      None
##
##  Description:
##		HACK: Need to centralize this into a namespace!! (pwu)
##
##      List the archive files.
proc ::qpm::qar::list_files {} {

	global info_map

	set archive_files [::qpm::qar::get_archive_files 0]

	if {[::qpm::lib::ccl::is_user_entered $info_map(ascii)]} {
		set content_file $info_map(ascii)
		set fext .txt
		if {![string equal [file extension [string tolower $content_file]] $fext]} {
			append content_file $fext
		}
		set of [open $content_file "w"]
		foreach file $archive_files {
			puts $of $file
		}
		close $of
		post_message "Generated: $content_file"
	} else {
		# Set up the column widths
		set col1 "File name"
		set w1 [expr {[string length $col1] + 2}]
		foreach file $archive_files {
			if {[string length $file] > $w1} {
				set w1 [string length $file]
			}
		}

		# Make a nice header (with separator) for the table first
		set sep +-[string repeat - $w1]-+
		puts $sep
		puts [format "| %-*s |" $w1 $col1]
		puts $sep

		# Print the contents of the table
		foreach file $archive_files {
			puts [format "| %-*s |" $w1 $file]
		}

		# Finish off by printing the separator again
		puts $sep
	}
}

#############################################################################
##  Procedure:  ::qpm::qar::commit_to_archive_tcl
##
##  Arguments:
##      None
##
##  Description:
proc ::qpm::qar::commit_to_archive_tcl { revision lines } {

	set use_separate_file 0

	if {[llength $lines] > 0} {
		if {$use_separate_file} {
			set tcl_file $revision.archive.tcl
			set lines_to_commit [list]
			if {[file exists $tcl_file] && ![catch {open $tcl_file r} logid]} {
				while {[gets $logid line] >= 0} {
					lappend lines_to_commit $line
				}
				close $logid
			}
			if {[catch {open $tcl_file w} out_file]} {
				::qpm::lib::ccl::print_message -error "Couldn't write to: $tcl_file"
			} else {
				foreach line $lines {
					lappend lines_to_commit $line
				}
				array set unique_lines {}
				foreach line $lines_to_commit {
					if {![info exists unique_lines($line)]} {
							# only write unique lines
						set unique_lines($line) 1
						puts $out_file $line
					}
				}
				close $out_file
				set_global_assignment -name SOURCE_TCL_SCRIPT_FILE $tcl_file
				::qpm::lib::ccl::print_message -info "Generated $tcl_file"
			}
		} else {
			foreach line $lines {
				set real_cmd $line
				append real_cmd " -tag from_archive"
				eval $real_cmd
			}
		}
	}
}

#############################################################################
##  Procedure:  ::qpm::qar::fix_qsf
##
##  Arguments:
##      None
##
##  Description:
##      Fix the QSF file
proc ::qpm::qar::fix_qsf { } {

	global info_map

	set archive_files [::qpm::qar::get_archive_files 0]

	array set files_to_fix {}
	array set files_to_exclude {}
	foreach file [::qpm::pkg::qsf::get_archive_files] {
		set fullpath [string tolower [file normalize $file]]
		set files_to_exclude($fullpath) $file
	}
	foreach pkg [list required auto] {
		foreach file [::qpm::pkg::${pkg}::get_archive_files] {
			set fullpath [string tolower [file normalize $file]]
			if {![info exists files_to_exclude($fullpath)]} {
				set files_to_fix($fullpath) $file
			}
		}
	}
	set all_files [array names files_to_fix]
	if {[llength $all_files] > 0} {
		set lines [list]
		foreach fullpath $all_files {
			set name [get_file_info -filename $fullpath -get_qsf_name_from_extension]
			set file $files_to_fix($fullpath)
			lappend lines "set_global_assignment -name $name [list $file]"
		}
		::qpm::qar::commit_to_archive_tcl $info_map(revision) $lines
	}
}

#############################################################################
##  Procedure:  ::qpm::qar::generate_archive
##
##  Arguments:
##      None
##
##  Description:
##		HACK: Need to centralize this into a namespace!! (pwu)
##
##      Generate the archive files.
proc ::qpm::qar::generate_archive { qar_file_name archive_files } {

	global info_map
    variable app_name
    variable use_templates

	set success 1

	set qar_file_name [::qpm::lib::ccl::get_archive_filename $qar_file_name $info_map(qda)]

	if {[::qpm::lib::ccl::is_user_entered $info_map(no_overwrite)] && [file exists $qar_file_name]} {

		post_message -type error "Quartus II Archive File '$qar_file_name' already exists -- use the -overwrite option to overwrite it, or specify a different file name"
		set success 0

	} else {

			# Create database of files to be archived
		load_package file_manager
		if {[llength $archive_files] == 0} {
			set archive_files [::qpm::qar::get_archive_files 1]
			set do_create_report 1
		} else {
			set do_create_report 0
		}
		set report_arc_files [list]
		foreach file $archive_files {
			qar -add $file
			if {$do_create_report} {
				lappend report_arc_files [list $file]
			}
		}

		catch {file delete -force $qar_file_name}

		if {[catch {qar $qar_file_name} result] || ![file exists $qar_file_name]} {
			if {[string length $result] > 0} {
				post_message -type error $result
			}
			post_message -type error "Failed to generate '$qar_file_name'"
			set success 0
		} else {
			post_message -type info "----------------------------------------------------------"
			post_message -type info "----------------------------------------------------------"
			post_message -type info "Generated archive '$qar_file_name'"
			post_message -type info "----------------------------------------------------------"
			post_message -type info "----------------------------------------------------------"
		}

			# clear the list of files to archive
		qar -reset

		if {$do_create_report} {
				# update the report database
			if {![catch {load_report -skip_database_check}]} {
				post_message "Generated report '[get_current_revision].[::qpm::qar::get_mode].rpt'"
				::qpm::lib::rpt::update_report $app_name "Files Archived" [list "File Name"] $report_arc_files
				::qpm::lib::rpt::commit $app_name $success
				foreach file_set $use_templates {
					::qpm::lib::rpt::add_to_summary $app_name "File Set Used" [::qpm::template::${file_set}::get_title]
				}
				::qpm::lib::rpt::add_to_summary $app_name "Output File" [expr {$success ? $qar_file_name : "N/A"}]
				::qpm::lib::rpt::save_report
				catch {unload_report}
			}
		}

		if {$info_map(self_test)} {
			::qpm::lib::self_test::main [list $qar_file_name]
		}
	}

	return [list $success $qar_file_name]
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::do_content {} {
	# Restore
# -------------------------------------------------
# -------------------------------------------------
	::qpm::qar::list_files
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::do_restore_status { success qar_file_name output_directory } {
	# Restore
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	variable restore_status_is_posted

	if {!$restore_status_is_posted} {
		set restore_status_is_posted 1
		if {$success} {
			if {[::qpm::lib::ccl::is_user_entered $info_map(output)]} {
				post_message -type Info "Successfully restored '$qar_file_name' into the '$output_directory' directory"
			} else {
				post_message -type Info "Successfully restored '$qar_file_name'"
			}
		} else {
			post_message -type Error "Failed to restore $qar_file_name"
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::do_restore { qar_file_name } {
	# Restore
# -------------------------------------------------
# -------------------------------------------------

	global info_map
    variable app_name

	set success 1
	set orig_dir [pwd]

	if {[::qpm::lib::ccl::is_user_entered $info_map(output)]} {
		set output_directory $info_map(output)
	} else {
		set output_directory $orig_dir
	}

	if {![catch {file mkdir $output_directory} result] && [file isdirectory $output_directory] && ![catch {cd $output_directory} result]} {

		set content_base_name "__tmp.[file tail $qar_file_name]"
		set restored_ascii $content_base_name.restored.txt
		set failed_ascii $content_base_name.failed.txt
		set search_paths_ascii $content_base_name.search_paths.txt
		set ascii_files [list $restored_ascii $failed_ascii $search_paths_ascii]

		foreach ascii_file $ascii_files {
			catch {file delete -force $ascii_file}
		}

		set unqar_cmd "unqar [list $qar_file_name] -search_paths_ascii $search_paths_ascii -restored_ascii $restored_ascii -failed_ascii $failed_ascii"
		set failure_to_restore_is_okay 0
		set no_overwrite_enabled 0
		if {[::qpm::lib::ccl::is_user_entered $info_map(no_overwrite)]} {
			set no_overwrite_enabled 1
			append unqar_cmd " -no_overwrite"
			set failure_to_restore_is_okay 1
		}
		if {[::qpm::lib::ccl::is_user_entered $info_map(disable_search_path_update)]} {
			append unqar_cmd " -disable_search_path_update"
		}

		if {[catch {eval $unqar_cmd} result]} {
			if {[string length $result] > 0} {
				#post_message -type error $result
			}
			set success 0
		} else {
			set success 1
		}

		set restored_files [list]
		set qpf_files [list]
		set qsf_files [list]
		if {[file isfile $restored_ascii]} {
			foreach file [::qpm::lib::ccl::get_lines $restored_ascii] {
				lappend restored_files [list $file]
				if {[file isfile $file]} {
					if {[string match -nocase *.qpf $file]} {
						lappend qpf_files $file
					} elseif {[string match -nocase *.qsf $file]} {
						lappend qsf_files $file
					}
				}
			}
		}
		set not_overwritten [list]
		set failed_files [list]
		if {[file isfile $failed_ascii]} {
			foreach file [::qpm::lib::ccl::get_lines $failed_ascii] {
				lappend failed_files [list $file]
				if {[file isfile $file]} {
					if {$no_overwrite_enabled} {
						lappend not_overwritten $file
					}
					if {[string match -nocase *.qpf $file]} {
						lappend qpf_files $file
					} elseif {[string match -nocase *.qsf $file]} {
						lappend qsf_files $file
					}
				} else {
					set failure_to_restore_is_okay 0
					post_message -type error "Failed to restore: $file"
					set success 0
				}
			}
			set success $failure_to_restore_is_okay
		}
		
		if {[llength $not_overwritten] > 0} {
			post_message -type warning "The following files were not overwritten" -submsgs $not_overwritten
		} elseif {[llength $failed_files] > 0} {
			post_message -type error "The following files were not restored" -submsgs $failed_files
			set success 0
		}
		
		if {[llength $qpf_files] > 0} {
			set projects $qpf_files
		} else {
			set projects $qsf_files
		}
		array set unique_qpfs {}
		foreach project $projects {
			while {[string compare [file extension $project] ""] != 0} {
				set project [file rootname $project]
			}
			set unique_qpfs($project) 1
		}
		set projects [array names unique_qpfs]
			# bypass failures when opening the project
		set_acf_manager -bypass_project_open_failure enable
		set_acf_manager -enable_bool_data ignore_filepath_error_in_qsf
		set first_project ""
		foreach project $projects {
			if {[project_exists $project]} {
				set revision_index 0
				set revisions [get_project_revisions $project]
				set first_revision [lindex $revisions 0]
				#puts "revisions($revisions)"
				foreach revision $revisions {
						# project_open -force removes db/<revision>.* files
					if {[catch {revision_exists $revision -project $revision} result] || [catch {project_open $project -revision $revision -force} result]} {
						#puts "result : $result"
					} elseif {[is_project_open]} {
						if {[string compare "" $first_project] == 0} {
							set first_project $project
						}
						if {$revision_index == 0} {
							# puts "$revision_index : $revision"
								# update the report database
							::qpm::lib::rpt::prepare $app_name
							if {![catch {load_report -skip_database_check}]} {
								::qpm::qar::do_restore_status $success $qar_file_name $output_directory
								post_message "Generated report '[get_current_revision].[::qpm::qar::get_mode].rpt'"
								::qpm::lib::rpt::update_report $app_name "Files Restored" [list "File Name"] $restored_files
								::qpm::lib::rpt::update_report $app_name "Files Not Restored" [list "File Name"] $failed_files
								::qpm::lib::rpt::commit $app_name $success
								::qpm::lib::rpt::add_to_summary $app_name "Input File" [expr {$success ? $qar_file_name : "N/A"}]
								::qpm::lib::rpt::save_report
								catch {unload_report}
							}
						}
							# Add SEARCH_PATH assignments
						set lines [list]
						foreach search_path [::qpm::lib::ccl::get_lines $search_paths_ascii] {
							#puts "search_path($search_path)"
							lappend lines "set_global_assignment -name SEARCH_PATH [list $search_path]"
						}
						::qpm::qar::commit_to_archive_tcl $revision $lines
						export_assignments
						catch {set_current_revision $first_revision}
						project_close
						incr revision_index
					}
				}
			}
		}

		foreach ascii_file $ascii_files {
			catch {file delete -force $ascii_file}
		}

		::qpm::qar::do_restore_status $success $qar_file_name $output_directory

		if {[info exists info_map(ui)] && $info_map(ui) && [string compare "" $first_project] != 0} {
			puts "Executing: $::quartus(binpath)/quartus $first_project &"
			eval exec "$::quartus(binpath)/quartus" $first_project &
		}

		cd $orig_dir
	} else {
		post_message -type error "Can't restore files to directory '$output_directory' -- make sure you have permission to write to the directory"
		set success 0
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::qar::main {} {
	# Script starts here
	# 1.- Process command-line arguments
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global archive_package_info

	variable is_qar_mode
	variable is_only_input_file
	variable use_templates
	variable use_packages

#---------
	::qpm::qar::ipc_restrict_percent_range 5 91
#---------

	::qpm::qar::display_banner

	if {[::qpm::qar::process_options]} {

		if {$info_map(all_revisions)} {
			::qpm::qar::load_plugins
			if {[::qpm::qar::check_templates]} {
				if {[::qpm::lib::ccl::is_user_entered $info_map(output)]} {
						# do combined qar
					array set archiveFiles {}
					foreach project $info_map(project) {
						set revisions [get_project_revisions $project]
						set first_revision [lindex $revisions 0]
						foreach revision $revisions {
							if {[::qpm::qar::open_project $project $revision]} {
								post_message "Initializing files for '$revision' revision"
								foreach file [::qpm::qar::get_archive_files 0] {
									set archiveFiles($file) 1
								}
								::qpm::qar::close_project
							}
						}
						if {[::qpm::qar::open_project $project $first_revision]} {
							::qpm::qar::close_project
						}
					}
					set files_to_archive [array names archiveFiles]
					if {[llength $files_to_archive] > 0} {
						set results [::qpm::qar::generate_archive $info_map(output) $files_to_archive]
						if {[lindex $results 0]} {
							lappend all_qars [lindex $results 1]
						}
					}
				} else {
					set use_template [lindex $use_templates 0]
					set cmd_args [list -use_file_set $use_template]
					foreach pkg $use_packages {
						::qpm::lib::ccl::print_message -info "Including: [::qpm::pkg::${pkg}::get_title]"
						lappend cmd_args -use_file_subset
						lappend cmd_args $pkg
					}
					set revision_qars [list]
					foreach project $info_map(project) {
						set revisions [get_project_revisions $project]
						set first_revision [lindex $revisions 0]
						foreach revision $revisions {
							if {[::qpm::qar::open_project $project $revision]} {
								if {[catch {execute_flow -flow archive_project_internal -internal_file $revision.qar -internal_args $cmd_args} result]} {
									if {[string length $result] > 0} {
										post_message -type error $result
									}
								} else {
									lappend revision_qars $revision.qar
								}
								::qpm::qar::close_project
							}
						}
						if {[::qpm::qar::open_project $project $first_revision]} {
							::qpm::qar::close_project
						}
					}
				}
			}
		} elseif {$info_map(smart)} {
			foreach project $info_map(project) {
				set revisions $info_map(revision)
				if {![::qpm::lib::ccl::is_user_entered $revisions]} {
					set revisions [get_project_revisions $project]
				}
				foreach revision $revisions {
					if {[::qpm::qar::open_project $project $revision]} {
						catch {execute_flow -flow archive_project -internal_file __smart.$revision.qar}
						::qpm::qar::close_project
					}
				}
			}
		} elseif {$info_map(internal_test)} {
			package require ::qpm::lib::internal_test
			post_message "Running internal test mode"
			if {$info_map(redo_qic_designs)} {
				::qpm::lib::internal_test::set_redo_qic_designs 1
			}
			foreach exclude_hc_output [list 0 1] {
				puts "Exclude HC output => $exclude_hc_output"
				if {$info_map(compile_after_restore)} {
					if ($exclude_hc_output) {
						::qpm::lib::internal_test::set_compile_after_restore 0
					} else {
						::qpm::lib::internal_test::set_compile_after_restore 1
					}
				}
				::qpm::lib::internal_test::set_exclude_hc_output $exclude_hc_output
				foreach project $info_map(project) {
					set revisions $info_map(revision)
					if {![::qpm::lib::ccl::is_user_entered $revisions]} {
						set revisions [get_project_revisions $project]
					}
					foreach revision $revisions {
						if {[::qpm::qar::open_project $project $revision]} {
							::qpm::lib::internal_test::main
							::qpm::qar::close_project
						}
					}
				}
			}
		} elseif {$info_map(readme)} {
			puts ""
			::qpm::qar::do_pretty_print [::qpm::lib::ccl::get_readme]
			qexit
		} elseif {$is_qar_mode} {

			set do_continue 1
			if {[::qpm::lib::ccl::is_user_entered $info_map(input)]} {
				if {![file exists $info_map(input)]} {
					set do_continue 0
					post_message -type Error "Input file '$info_map(input)' does not exist"
				} elseif {$is_only_input_file} {
					set do_continue 0
					if {[::qpm::lib::ccl::is_user_entered $info_map(output)]} {
					} else {
						#post_message -type Error "The -output option must be specified"
						set info_map(output) [::qpm::lib::ccl::get_archive_filename [file root $info_map(input)] $info_map(qda)]
						post_message -type warning "The -output option wasn't specified -- using the default value: $info_map(output)"
					}
					::qpm::qar::generate_archive $info_map(output) [list]
				}
			}
			if {$do_continue} {
				::qpm::qar::load_plugins
				if {$info_map(list_file_sets)} {
					::qpm::qar::list_file_sets
				} elseif {$info_map(list_file_subsets)} {
					::qpm::qar::list_file_subsets [array names archive_package_info]
				} elseif {[::qpm::qar::check_templates]} {

					if {[::qpm::qar::open_project $info_map(project) $info_map(revision)]} {

						if {![::qpm::lib::ccl::is_user_entered $info_map(output)]} {
							if {$info_map(old)} {
								set info_map(output) [::qpm::lib::ccl::get_archive_filename $info_map(project) $info_map(qda)]
							} else {
								set info_map(output) [::qpm::lib::ccl::get_archive_filename $info_map(revision) $info_map(qda)]
							}
						}

						if {$info_map(list_files)} {
							::qpm::qar::list_files
						} elseif {$info_map(fix_qsf)} {
							::qpm::qar::fix_qsf
						} else {
							::qpm::qar::generate_archive $info_map(output) [list]
						}

						::qpm::qar::close_project
					}
				}
			}

		} else {

			if {$info_map(content)} {
				::qpm::qar::do_content
			} elseif {$info_map(hcii) || $info_map(hc) || [::qpm::lib::ccl::is_user_entered $info_map(password)]} {
				::qpm::lib::old_restore::do_restore $info_map(project) $info_map(hcii) $info_map(hc) $info_map(password)
			} else {
				::qpm::qar::do_restore $info_map(project)
			}

		}
	}

#---------
	::qpm::qar::ipc_restrict_percent_range 91 100
#---------
}

# -------------------------------------------------
# -------------------------------------------------
::qpm::qar::main
# -------------------------------------------------
# -------------------------------------------------
