# This script is used as a wrapper for lfp_report_timing_script.tcl.  
#
# Usage:
#    quartus_sta -t lfp_report_timing_script_wrapper.tcl {project}

 package require ::quartus::project

 set project [lindex $quartus(args) 0]

 puts "INFO: Script:         lfp_report_timing_script_wrapper.tcl"
 puts "INFO: Project:        $project"

 set dir [file dirname [info script]]
 set ok [catch { source [file join $dir lfp_report_timing_script.tcl] } errMsg]

 if {$ok == 0} { 
 	puts "QIC INFO: Sucessfully loaded package lfp_report_timing_script.tcl..."
 } else {
 	puts "QIC INFO: Error: Couldn't load package lfp_report_timing_script.tcl..."
	puts "QIC INFO: lfp_report_timing_script_wrapper.tcl: Finished with errors."
 	error $errMsg
 	return $ok
 }

 # Open project 
 project_open $project

 set db_dir [file join [get_project_directory] "db"]
 
 # Make the db directory if it doesn't exist already exist.
 file mkdir $db_dir
 set dat_file_name [file join $db_dir "edge_slack-tdc.edge"]				

 set file [ open $dat_file_name "w+" ]
 if {$ok == 0} { 
	set ok [catch { lfp_get_top_failing_paths 0 10000 $file } errMsg] 
 }
 close $file
 
 if {$ok != 0} { 
 	puts "QIC INFO: lfp_report_timing_script_wrapper.tcl: Finished with errors."
 	set savedInfo $errorInfo
 	error $errMsg $savedInfo
 	return $ok
 }

 # Close project 
 project_close

 return $ok
