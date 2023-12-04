set pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

##################################################################
#
# File name:	qsh_hcii_decode.tcl
#
#	Description: Internal decryptor utility for HardCopy II netlists
#			Script can be used by quartus_sh
#			Don't send it to people outside Altera.
#
# Authors:		Evgenii Puchkaryov
#
#				Copyright (c) Altera Corporation 2005 - ...
#				All rights reserved.
#
##################################################################

package require cmdline

##################################################################
#				cry_help
# Description:	report help info and terminate
#
##################################################################
proc cry_help {} {
	# Need to define argv for the cmdline package to work
	global available_options
	global argv0
	set usage "<file_or_directory_name> \[-output <output_file>\]:\n"

	puts "\nInternal decoding utility for HardCopy files for quartus_sh."
	puts [::cmdline::usage $available_options $usage]
	puts "For more details, use \"quartus_sh --help=hc_decode\""
	qexit -error
}

##################################################################
#				decode_file
# Description:	Call Tcl interface to QTL for decoding
#
##################################################################
proc decode_hcii_file { infile outfile } {

	if [catch {decode_file $infile -hc_netlist -output $outfile} result] {
		post_message -type Error "Failed decoding $infile."
		puts stderr $result
		qexit -error
	} else {
		post_message -type Info "Wrote $outfile"
	}
}

post_message -type info "[info script] version $pvcs_revision"

# BEGIN MAIN ----------------------------------------------------------------

# List of available options. 
# This array is used by the cmdline package
set available_options {
	{ output.arg "./decoded/" "Output file name or path" }
}
set argv0 "quartus_sh --hc_decode"

set argument_list $quartus(args)

if [catch {load_package crypt} result] {
	post_message -type Warning "You may not be authorized to use this option or script."
	puts stderr $result
	cry_help
}

# Use cmdline package to parse options
if [catch {array set optshash [cmdline::getoptions argument_list $available_options]} result] {
	puts ""
	if {[llength $argument_list] > 0 } {
		# This is not a simple -? or -help but an actual error condition
		post_message -type error "Illegal Options"
	}
	cry_help
}

# cmdline::getoptions is going to modify the argument_list
# leaving off all arguments after the first one with no option
# The first one is always the input file. The rest depends on 
# how user called the command.
set argc [ llength $argument_list ]

if { $argc == 0 } {
	post_message -type error "Missing file_name argument."
	cry_help
}

if { $argc >= 1 } {
	set infile [lindex $argument_list 0]
}

set outfile $optshash(output)

if { $argc >= 3 } {
	# If due to argument ordering getoptions missed -output flag
	set outfile [lindex $argument_list 2]

} elseif { $outfile == "./decoded/" } {

	# If our default was not reassigned, use it.
	set outfile "$optshash(output)${infile}"
}

# Batch directory decode support (SPR 187170)
if {[file isdirectory $infile]} {
	
	# cd $infile
	foreach filename [glob -nocomplain -types f -path $infile/ "*"] {
	
		# puts "File checked: $filename"
		if { ![catch { set compressed [is_file_compressed $filename] } result] \
			&& ![catch { set encrypted [is_file_encrypted $filename] } result] } {
			
			if { $compressed || $encrypted } {
			
				# We can't use the same file name, so change name to tmp, decode, delete old file
				file rename -force  $filename $filename.tmp
				decode_hcii_file "$filename.tmp" $filename
				file delete -force  $filename.tmp
			}
		} else {
			puts "Not encoded: $filename ($result)"
		}
	}
} else {
	decode_hcii_file $infile $outfile
}


# END MAIN ----------------------------------------------------------------
