set pvcs_revision(hcdc_report) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# **************************************************************************
#
# File: qsta_hcdc_report.tcl
#
# Usage:
#                "quartus_sta --hcdc_report <rev>"
#
# Description:
#                This script will automatically generate all the reports for both
#                fast and slow timing models.
#                Key elements of the design that are collected and reported in the TimeQuest
#                run will be compiled into a general report file:
#                <project_revision>_hardcopy_review_<slow_model | fast_model>.sta.rpt
#
#                THIS IS FOR INTERNAL USE ONLY
#
# **************************************************************************


# ----------------------------------------------------------------
#
namespace eval qsta_hcdc {
#
# Description: Helper functions to implement TimeQuest functionality
#
# ----------------------------------------------------------------

	variable quartus_version ""
        variable contents ""
        variable filecontent ""
        variable temp_file ""
        variable project_name ""
}



#############################################################################
## Method: qsta_hcdc::initialize_timing_netlist
##
## Arguments: model
##
## Description: general timing netlist setup
##
#############################################################################

proc qsta_hcdc::initialize_timing_netlist { } {

	post_message -type info "==========================================="
	post_message -type info "Creating Netlist"
	post_message -type info "==========================================="

    if [catch {create_timing_netlist} ] {
       post_message -type error "Can't run TimeQuest Timing Analyzer (quartus_sta) -- Fitter (quartus_fit) failed or was not run. Run the Fitter (quartus_fit) successfully before running the TimeQuest analyzer (create_timing_netlist)."
       qexit -error
    }
    read_sdc
    update_timing_netlist
}

#############################################################################
## Method: qsta_hcdc::change_operating_conditions
##
## Arguments: model
##
## Description: Use set_operating_conditions to switch model
##
#############################################################################

proc qsta_hcdc::change_operating_conditions { model } {

	post_message -type info "==========================================="
	post_message -type info "Switching Operating Conditions: $model"
	post_message -type info "==========================================="

    set_operating_conditions -model $model
	# No need to re-read SDC
    update_timing_netlist
}


#############################################################################
## Method: qsta_hcdc::general_reporting
##
## Arguments: none
##
## Description: general reports needed by the HCDC
##
#############################################################################

proc qsta_hcdc::general_reporting { } {
     variable temp_file
     # no append option because this is the first report call
     # open a new file for writing
     report_clocks -file $temp_file
     report_clock_transfers -append -file $temp_file
     report_sdc -append -file $temp_file
     report_sdc -ignored -append -file $temp_file
     check_timing -append -file $temp_file
     report_ucp -append -file $temp_file
}


#############################################################################
## Method: qsta_hcdc::create_timing
##
## Arguments: none
##
## Description: creates timing summary with different options:
##              - setup
##              - hold
##              - recovery
##              - removal
##
#############################################################################

proc qsta_hcdc::report_timing_summary { } {
     variable temp_file
     create_timing_summary -setup -append -file $temp_file
     create_timing_summary -hold -append -file $temp_file
     create_timing_summary -recovery -append -file $temp_file
     create_timing_summary -removal -append -file $temp_file
}


#############################################################################
## Method: qsta_hcdc::other_reports
##
## Arguments: none
##
## Description: other reports as specified including ignored constraints
##
#############################################################################

proc qsta_hcdc::other_reports { } {
     variable temp_file
     variable version_six_one

     report_datasheet -append -file $temp_file

     if { $version_six_one == 0 } {
        report_tccs -append -file $temp_file -quiet
        report_rskm -append -file $temp_file -quiet
     }
}


#############################################################################
## Method: qsta_hcdc::generate_all_core_timing_reports
##
## Arguments: none
##
## Description: all core timing reports for first 1000 paths
##
#############################################################################

proc qsta_hcdc::generate_all_core_timing_reports { } {

    # Generate all Core timing reports
    #
    # -------------------------------------------------
    # -------------------------------------------------
    variable temp_file

    delete_folder "Report Timing (Core)"
    report_timing -setup -from [all_registers] -to [all_registers] -panel "Registers to Registers (Setup)" -parent_folder "Report Timing (Core)" -parent_folder_cmd "generate_all_core_timing_reports" -npaths 1000 -summary -append -file $temp_file
    report_timing -hold -from [all_registers] -to [all_registers] -panel "Registers to Registers (Hold)" -parent_folder "Report Timing (Core)" -parent_folder_cmd "generate_all_core_timing_reports" -npaths 1000 -summary -append -file $temp_file
    report_timing -recovery -from [all_registers] -to [all_registers] -panel "Registers to Registers (Recovery)" -parent_folder "Report Timing (Core)" -parent_folder_cmd "generate_all_core_timing_reports" -npaths 1000 -summary -append -file $temp_file
    report_timing -removal -from [all_registers] -to [all_registers] -panel "Registers to Registers (Removal)" -parent_folder "Report Timing (Core)" -parent_folder_cmd "generate_all_core_timing_reports" -npaths 1000 -summary -append -file $temp_file
}


#############################################################################
## Method: qsta_hcdc::generate_all_io_timing_reports
##
## Arguments: none
##
## Description: IO timing reports for first 10,000 paths
##
#############################################################################

proc qsta_hcdc::generate_all_io_timing_reports { } {
     variable temp_file

    # Generate all Core timing reports
    #
    # -------------------------------------------------
    # -------------------------------------------------
   	delete_folder "Report Timing (I/O)"
	report_timing -setup -from [all_inputs] -to [all_registers] -panel "Inputs to Registers (Setup)" -parent_folder "Report Timing (I/O)" -parent_folder_cmd "generate_all_io_timing_reports" -npaths 10000 -summary -append -file $temp_file
	report_timing -hold -from [all_inputs] -to [all_registers] -panel "Inputs to Registers (Hold)" -parent_folder "Report Timing (I/O)" -parent_folder_cmd "generate_all_io_timing_reports" -npaths 10000 -summary -append -file $temp_file
	report_timing -recovery -from [all_inputs] -to [all_registers] -panel "Inputs to Registers (Recovery)" -parent_folder "Report Timing (I/O)" -parent_folder_cmd "generate_all_io_timing_reports" -npaths 10000 -summary -append -file $temp_file
	report_timing -removal -from [all_inputs] -to [all_registers] -panel "Inputs to Registers (Removal)" -parent_folder "Report Timing (I/O)" -parent_folder_cmd "generate_all_io_timing_reports" -npaths 10000 -summary  -append -file $temp_file
	report_timing -setup -from [all_registers] -to [all_outputs] -panel "Registers to Outputs (Setup)" -parent_folder "Report Timing (I/O)" -parent_folder_cmd "generate_all_io_timing_reports" -npaths 10000 -summary -append -file $temp_file
	report_timing -hold -from [all_registers] -to [all_outputs] -panel "Registers to Outputs (Hold)" -parent_folder "Report Timing (I/O)" -parent_folder_cmd "generate_all_io_timing_reports" -npaths 10000 -summary  -append -file $temp_file
	report_timing -setup -from [all_inputs] -to [all_outputs] -panel "Inputs to Outputs (Setup)" -parent_folder "Report Timing (I/O)" -parent_folder_cmd "generate_all_io_timing_reports" -npaths 10000 -summary  -append -file $temp_file
	report_timing -hold -from [all_inputs] -to [all_outputs] -panel "Inputs to Outputs (Hold)" -parent_folder "Report Timing (I/O)" -parent_folder_cmd "generate_all_io_timing_reports" -npaths 10000 -summary -append -file $temp_file

}

#############################################################################
## Method: qsta_hcdc::print_header
##
## Arguments: outfile handler
##
## Description: prints Quartus Version and Copyright info
##
#############################################################################

proc qsta_hcdc::print_header { outfile } {
     variable quartus_version
     variable project_name
     puts $outfile "TimeQuest report for $project_name"
     puts $outfile "[clock format [clock seconds]]"
     puts $outfile "$quartus_version\n"
     puts $outfile "$::quartus(copyright)\n\n"
}


#############################################################################
## Method: qsta_hcdc::cleanup
##
## Arguments: none
##
## Description: performs the necessary cleaning up before exiting
##
#############################################################################

proc qsta_hcdc::cleanup { } {

	post_message -type info "Deleting Netlist"
	post_message -type info "==========================================="

    catch {delete_timing_netlist}

    return 1
}


#############################################################################
## Method: qsta_hcdc::write_file_with_toc
##
## Arguments: file_name
##
## Description: function to print output with a pretty TOC
##
#############################################################################
proc qsta_hcdc::write_file_with_toc { file_name } {
     variable contents
     variable filecontent

     set outfile [open $file_name w]
     print_header $outfile

     puts $outfile "---------------------"
     puts $outfile "; Table of Contents ;"
     puts $outfile "---------------------\n"
     set n 1
     foreach item $contents {
 	puts $outfile " $n.  $item"
 	incr n
     }
     puts $outfile "\n"

     # dump all output after printing TOC
     foreach content $filecontent {
	puts $outfile "$content"
     }
     puts $outfile "\n"
     close $outfile
}

#############################################################################
## Method: qsta_hcdc::process_file
##
## Arguments: none
##
## Description: function to extract all headers
##
#############################################################################
proc qsta_hcdc::process_file { } {
     variable temp_file
     variable filecontent
     variable contents
     set filecontent ""
     set contents ""
     set readFile [open $temp_file r]
         while {[gets $readFile line] != -1} {
             lappend filecontent "$line"
             if { [regexp {^[+][-]+[+]$} $line] == 1 && [regexp -all {[+]} $line] == 2 } {
	        gets $readFile line
                lappend filecontent "$line"
	        if { [regexp -all {[;]} $line] == 2 } {
	           set temp [string trim $line ";"]
	           set trimmed [string trim $temp]
	           if { [regexp -all {[.]} $trimmed] == 0 } {
                      lappend contents "$trimmed"
     	           }
                 }
              }
         }
         close $readFile
}
#############################################################################
## Method: qsta_hcdc::generate_report
##
## Arguments: none
##
## Description: driver function
##
#############################################################################

proc qsta_hcdc::generate_report { } {

    variable quartus_version
    variable version_six_one
    variable project_name
    variable temp_file

	post_message -type info "Using qsta_hcdc_report.tcl Ver. $::pvcs_revision(hcdc_report)"

        set project_name [lindex $::quartus(settings) 0]
        set quartus_version $::quartus(version)
        set version_six_one [regexp "6\\.1" $quartus_version]

	initialize_timing_netlist

	foreach model { fast slow } {

		set file_name "${project_name}_hardcopy_review_${model}.sta.rpt"
		# open a temporary file to dump all the reports
		set temp_file "${model}_temp.rpt"

		change_operating_conditions $model
		general_reporting
		report_timing_summary
		generate_all_core_timing_reports
		generate_all_io_timing_reports
		other_reports

		# proces temp_file and write it out to the actual file with a nice TOC
		if { [file exists $temp_file] } {
                    process_file
                    write_file_with_toc $file_name
                    file delete $temp_file
		}
	}

	cleanup
}

