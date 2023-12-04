package provide ::qpm::lib::self_test 1.0

#############################################################################

# -------------------------------------------------
# Load Required Packages
# -------------------------------------------------
package require ::qpm::lib::ccl
load_package flow

#############################################################################
##  Export Functions & Declare Global Namespace Variables
namespace eval ::qpm::lib::self_test {

    namespace export main

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

	variable compile_results
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::self_test::do_write_file { file lines } {
# -------------------------------------------------
# -------------------------------------------------

	set file_name [file normalize $file]
	set file_dir  [file dirname $file_name]

	if {![catch {file mkdir $file_dir} result] && [file isdirectory $file_dir]} {
		if {[catch {open $file_name w} out_file]} {
			::qpm::lib::ccl::print_message -error "Couldn't write to: $file_name"
		} else {
			foreach line $lines {
				puts $out_file $line
			}
			close $out_file
			puts "Wrote: $file"
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::self_test::do_compile {input output} {
# -------------------------------------------------
# -------------------------------------------------

	variable compile_results

	set qar [file normalize $input]
	set compile_result 0
	set cnt 0
	while {[file isdirectory [file join $output $cnt]]} {
		incr cnt
	}
	set output [file join $output $cnt]

	if {![catch {file mkdir $output} result] && [file isdirectory $output]} {

		set odir [pwd]
		cd $output

		set cmd [concat [file join $::quartus(binpath) quartus_sh] --unqar "\"$qar\""]
		if {[catch {qexec $cmd} result]} {
			::qpm::lib::ccl::print_message -error "Failed to restore $qar -- $result"
		} else {
			::qpm::lib::ccl::print_message -info "Successfully restored $qar"

			set found_project 0
			set project_already_open [is_project_open]
			if {$project_already_open} {
				set projects [list $::quartus(project)]
				set revisions($::quartus(project)) [list $::quartus(settings)]
				set found_project 1
			} else {
				set projects [::qpm::lib::ccl::nocase_glob [list *.qpf]]
				if {[llength $projects] > 0} {
					set found_project 1
				} else {
					set projects [::qpm::lib::ccl::nocase_glob [list *.qsf]]
					if {[llength $projects] > 0} {
						set found_project 1
					}
				}
				if {$found_project} {
					foreach project $projects {
						set revisions($project) [get_project_revisions $project]
					}
				}
			}
			if {$found_project} {
				foreach project [array names revisions] {
					foreach revision $revisions($project) {
						set is_project_open 1
						if {!$project_already_open} {
							set is_project_open [::qpm::lib::ccl::open_project $project $revision]
						}
						if {$is_project_open} {
							::qpm::lib::ccl::print_message -info "Compiling: $output"
							if {[string compare -nocase [get_global_assignment -name STA_MODE] on] == 0} {
								set tan_tool sta
							} else {
								set tan_tool tan
							} 
							if {![catch {execute_module -tool map} result] && ![catch {execute_module -tool $tan_tool -args --post_map} result]} {
								set compile_result 1
							}
							if {!$project_already_open} {
								::qpm::lib::ccl::close_project
							}
						}
					}
				}
			}
		}
		cd $odir
	}
	if {$compile_result} {
		lappend compile_results(pass) $input
	} else {
		lappend compile_results(fail) $input
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::self_test::test_compile { qars_to_test } {
# -------------------------------------------------
# -------------------------------------------------

	set test_directory "__self_test_tmp_dir"

	foreach qar $qars_to_test {
		set dest_dir [file join $test_directory [file rootname [file tail $qar]]]
		::qpm::lib::self_test::do_compile [::qpm::lib::ccl::get_archive_filename $qar 0] $dest_dir
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc ::qpm::lib::self_test::main { qars } {
	# Main function
# -------------------------------------------------
# -------------------------------------------------

	variable compile_results

	array set compile_results {}
	array unset compile_results
	array set compile_results {}

	::qpm::lib::self_test::test_compile $qars

	foreach result [lsort [array names compile_results]] {

		set files $compile_results($result)
		set passed [expr {[string compare -nocase $result pass] == 0}]

		puts "* ---------------- Test result[::qpm::lib::ccl::pluralize $files] ($result) ---------------- *"
		foreach qar $files {
			if ($passed) {
				::qpm::lib::ccl::print_message -info "'$qar' passed the compile test and is ready to go"
			} else {
				::qpm::lib::ccl::print_message -error "'$qar' failed the compile test. Make sure the design files can compile successfully and try archiving again."
			}
		}
		puts "* ---------------------------------------------------- *"
	}
}
