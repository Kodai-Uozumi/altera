set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]

# *************************************************************
#
# File: hcii_astro_routing.tcl
#
# Usage: quartus_cdb project -c revision --hc_astro_routing
# Or: quartus_sh -t Q:\quartus\common\tcl\internal\hardcopy\hc_astro_routing.tcl circuitname.qref		
#
# Description: 
#   Generates routing in Astro format based on 
#	Quartus qref file. Depending on the value of contact 
#   and wire actions able to generate a number of different 
#   subformats.
#	Also able to produce output for the "fly"gif generation 
#   utility.
#
# *************************************************************

# ---------------------------------------------------------------
# Available User Options
# ---------------------------------------------------------------
# None are available now

# --------------------------------------
# Other Global variables
# --------------------------------------
set hc_output "hc_output"
# Assign net to elements or not
set assign_net_to_elements 1
# What to do with contact: contact | axcontact | none | draw
set contact_action axcontact
# What to do with wire: glink | path | wire | draw | none
set wire_action glink
# Enable/disable debug info
set debug_messages 0
# Layer assignments
set default_layer(horizontal) 35
set default_layer(vertical) 36
# Architecture-specific defines:
set contact_id 6
# Init static vars
set wiremasters_created 0

# By the default there are no hard zones
set hard_zones [list]
set crosses_hard_zone 0
set check_hard_zone_crossing 0

set project_already_opened [is_project_open]


# Prepare for drawing, if required
set layer_colour($default_layer(horizontal)) "0,0,255"
set layer_colour($default_layer(vertical)) "255,0,0"
set draw_scale 500

# Flipping this to 1 will force script to generate 
# graphics output instead of Astro output
set do_draw 0
if {$contact_action == "draw" || $wire_action == "draw"} {
	set do_draw 1
}
if {$do_draw} {
	set contact_action draw
	set wire_action draw
	set do_draw 1
} 

# ------------------------------
# Load Required Quartus Packages
# ------------------------------
load_package report


# -------------------------------------------------
# -------------------------------------------------
proc print_help_and_abort {} {
# -------------------------------------------------
# -------------------------------------------------
	post_message -type error "Usage: quartus_cdb project -c revision --hc_astro_routing"
	post_message -type error "Alternative Usage: quartus_sh -t [info script] \[-hardzone hardzonefile\] infile.qref"
	qexit -error
}

# -------------------------------------------------
# -------------------------------------------------
proc ipc_restrict_percent_range {min max} {
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
proc ipc_set_percent_range {low high} {
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
proc ipc_report_status {percent} {
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
proc display_banner {} {
# Display start banner
# -------------------------------------------------
# -------------------------------------------------

	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "[file tail [info script]] version $::pvcs_revision(main)"
	post_message -type info "----------------------------------------------------------"
	post_message -type info "----------------------------------------------------------"

	##---- 0% - 15% progress ----##
	ipc_set_percent_range 0 15

	ipc_report_status 0
}



# -------------------------------------------------
# -------------------------------------------------
proc plunk_wire { out_script layer last_point point } {
# Generate command to put down a wire
# -------------------------------------------------
# -------------------------------------------------
	global wire_action
	global wiremasters_created
	global h_layer
	global v_layer
	global layer_colour
	global draw_scale

	debug_puts "last point: $last_point \npoint: $point"
	# This is what we can do with wire:
	# dbCreateGLink	cellId netId layerNumber firstX firstY secondX secondY
	# dbCreatePath cellId "layerName" pathType width routeType dataType PointArray 
	# dbCreateHorizontalWire cellId masterWireId wireLength  xPoint yPoint  
	# dbCreateVerticalWire cellId masterWireId wireLength  xPoint yPoint  	

	set do_connect 0

	switch -exact $wire_action {
		glink {
			set x1 [lindex $last_point 0]
			set y1 [lindex $last_point 1]
			set x2 [lindex $point 0]
			set y2 [lindex $point 1]

			puts $out_script "dbCreateGLink \$cell \$net $layer $x1 $y1 $x2 $y2"
		}
		path {
			if {[lindex $last_point 1] == [lindex $point 1] || \
					[lindex $last_point 0] == [lindex $point 0]} {
				puts $out_script "catch { unset obj_id }"
				puts $out_script "set obj_id \[dbCreatePath \$cell \[dbGetLayerNameFromNumber \[dbGetCurrentLibId\] $layer\] 2 200 2 0 [list [list $last_point $point] ]\]"
				set do_connect 1
			}
		}
		wire {
			# Wires need wire masters
			if {!$wiremasters_created} {
				puts $out_script "set wm_h \[dbMakeWireMasterId \$cell $h_layer \[dbCreateWireMaster \$cell 2 0 200 $h_layer\]\]"
				puts $out_script "set wm_v \[dbMakeWireMasterId \$cell $v_layer \[dbCreateWireMaster \$cell 2 0 200 $v_layer\]\]"
				set wiremasters_created 1
			}

			set x [lindex $last_point 0]
			set y [lindex $last_point 1]

			if {[lindex $last_point 1] == [lindex $point 1]} {
				# horizontal wire
				set length [expr [lindex $point 0] - [lindex $last_point 0] ]
				puts $out_script "catch { unset obj_id }"
				puts $out_script "set obj_id \[dbCreateHorizontalWire \$cell \$wm_h $length $x $y\]"
				set do_connect 1
			} elseif {[lindex $last_point 0] == [lindex $point 0]} {
				# vertical wire
				set length [expr [lindex $point 1] - [lindex $last_point 1]]
				puts $out_script "catch { unset obj_id }"
				puts $out_script "set obj_id \[dbCreateVerticalWire \$cell \$wm_v $length $x $y\]"
				set do_connect 1
			} else {
				# diagonal segment, do nothing
			}
		}
		draw {
			set x1 [expr [lindex $last_point 0] / $draw_scale]
			set y1 [expr [lindex $last_point 1] / $draw_scale]
			set x2 [expr [lindex $point 0] / $draw_scale]
			set y2 [expr [lindex $point 1] / $draw_scale]
			puts $out_script "line ${x1},${y1},${x2},${y2},$layer_colour($layer)"
		}
		default {
			error "Unknown wire treatment method. Accepted methods are glink, path, wire"
		}
	}
	
	if {$do_connect} {
		# The command did not connect element to a net, do it manually
		puts $out_script "dbConnect \$cell \$net \$obj_id"
	}
}


# -------------------------------------------------
# -------------------------------------------------
proc plunk_contact { out_script point } {
# Generate command to put down a contact
# -------------------------------------------------
# -------------------------------------------------
	global contact_action
	global draw_scale

	# There are only two things we can do for contacts:
	# put them down as normal contacts:
	# dbCreateContact cellId contactNumber point
	# or do nothing and hope that track assignment or 
	# detail router would be able to do the connection
	
	switch -exact $contact_action {
		contact {
			# puts "Contact $net_name $point
 			puts $out_script "catch { unset obj_id }"
			puts $out_script "set obj_id \[dbCreateContact \$cell \$contact_id \{$point\}\]"
			puts $out_script "dbConnect \$cell \$net \$obj_id"
		}
		axcontact {
			set micr_point [list [expr [lindex $point 0] / 1000.0] [expr [lindex $point 1] / 1000.0] ]
			# Example: axCreateContact cell_id "net_name" contact_id transform flag point
			puts $out_script "axCreateContact \$cell \$net_name \$contact_id 0 2 \{$micr_point\}"
		}
		none {
			# do nothing
		}
		draw {
			set x [expr ([lindex $point 0] / $draw_scale) - 2]
			set y [expr ([lindex $point 1] / $draw_scale) - 2]
			puts $out_script "square ${x},${y},4,0,0,0"
		}
		default {
			error "Unknown contact treatment method. Accepted methods are contact, axcontact, none"
		}
	}
}


# -------------------------------------------------
# -------------------------------------------------
proc advance_to_point {from to} {
# Generate routing between two points
# -------------------------------------------------
# -------------------------------------------------
	global out_file
	global default_layer
	global existing_net_contacts
	global crosses_hard_zone
	global check_hard_zone_crossing

	set x1 [lindex $from 0]
	set y1 [lindex $from 1]
	set layer1 [lindex $from 2]

	set x2 [lindex $to 0]
	set y2 [lindex $to 1]
	set layer2 [lindex $to 2]
	
	if {$y1 == $y2 && $x1 == $x2} {
		if {$layer2 == -1} {
			set layer2 $layer1
		}
	}
	if {$x1 != $x2} {
		set direction horizontal
	} else {
		set direction vertical
	}
	if {$layer2 == -1} {
		set layer2 $default_layer($direction)
	}

	if {$layer1 == -1} {
		set layer1 $layer2
	}

	debug_puts "Advancing from $from to $to, chose layer $layer2"

	if {$check_hard_zone_crossing} {
		# We are just doing traversal to check the crossing
		if {$y1 != $y2 || $x1 != $x2} {
			set hard_zone [find_hard_zone $x1 $y1 $x2 $y2]
			if {$hard_zone != ""} {
				set crosses_hard_zone 1
			}
		}
	} else {
		if {$layer1 != $layer2} {
			set point [list $x1 $y1]
			if {![info exists existing_net_contacts($point)]} {
				plunk_contact $out_file $point
			}
			set existing_net_contacts($point) 1
		}
	
		if {$y1 != $y2 || $x1 != $x2} {
			plunk_wire $out_file $layer2 [list $x1 $y1] [list $x2 $y2]
		}
	}

	return [list $x2 $y2 $layer2]
}


# -------------------------------------------------
# -------------------------------------------------
proc find_hard_zone { x1 y1 x2 y2 } {
# Find hard zone that this wire intersects, if any
# -------------------------------------------------
# -------------------------------------------------
	global hard_zones

	if {$x1 > $x2} {
		set temp $x1
		set x1 $x2
		set x2 $temp
	}
	if {$y1 > $y2} {
		set temp $y1
		set y1 $y2
		set y2 $temp
	}

	foreach rect $hard_zones {
		if {$x1 <= [lindex $rect 2] && $x2 >= [lindex $rect 0] &&
			$y1 <= [lindex $rect 3] && $y2 >= [lindex $rect 1]} {
			return $rect
		}
	}
	return ""
}


# -------------------------------------------------
# -------------------------------------------------
proc debug_puts { message } {
# Debug output. Do not useruse as the message is
# still created even if debug output is disabled
# -------------------------------------------------
# -------------------------------------------------
	global debug_messages
	if {$debug_messages} {
		post_message -type info $message
	}		
}


# -------------------------------------------------
# -------------------------------------------------
proc recursive_net_route { last_point args } {
# Recursively traverse net couring and convert it 
# into sequence of wires and contacts
# -------------------------------------------------
# -------------------------------------------------
	global out_file
	
	set num_entry 0
	set current_point $last_point
	debug_puts "args are $args"
	foreach entry $args {
		debug_puts "Current point is $current_point"
		debug_puts "Entry is $entry"
		if {[llength $entry] == 0} {
			error "Empty path"
		}
		if {[llength $entry] == 1} {
			# Simple point, just add it and move on
			set point [split $entry ","]
			if {[llength $point] != 3} {
				error "Format error in point $entry"
			}
			if {[llength $current_point] != 0} {
				# do the connection
				set current_point [advance_to_point $current_point $point]
			} else {
				# this is just beginning
				set current_point $point
			} 
		} else {
			# This is a branching point, should be the last 
			# entry in the list
			if {$num_entry != [llength $args] - 1} {
				error "Trailing data after branching point in $args"
			}
			if {[llength $current_point] == 0} {
				error "Branch without head"
			}

			foreach branch $entry {
				# First entry in the branch should be a simple point
				set branch_head [lindex $branch 0]
				debug_puts "Branch head is $branch_head"
				debug_puts "Rest of the branch is [lrange $branch 1 end]"
				if {[llength $branch_head] != 1} {
					error "Branch head is missing"
				}
				set branch_head_point [split $branch_head ","]
				set elaborated_head [advance_to_point $current_point $branch_head_point]
				eval recursive_net_route \{$elaborated_head\} [lrange $branch 1 end]
			}
		}
		incr num_entry
	}
}


# -------------------------------------------------
# -------------------------------------------------
proc quartus_net_route { net_name args } {
# Top level routine for converting quartus routing
# for a given net
# -------------------------------------------------
# -------------------------------------------------
	global out_file
	global existing_net_contacts
	global do_draw
	global out_nets_file

	regsub -all [string repeat "\\" 4] $net_name "\\" out_net_name
	regsub -all [string repeat "\\" 4] $net_name "" printed_net_name

	puts $out_nets_file $printed_net_name

	if {!$do_draw} {
		puts $out_file "set net_name \"$out_net_name\""
		puts $out_file "set net \[dbGetNetByName \$cell \$net_name\]"
	}

	array unset existing_net_contacts
	eval recursive_net_route {[list]} $args
}


# -------------------------------------------------
# -------------------------------------------------
proc print_astro_script_banner { out_file in_filename} {
# -------------------------------------------------
# -------------------------------------------------
	global contact_id
	global default_layer
	global do_draw
	global draw_scale
	
	if {!$do_draw} {
		puts $out_file "#----------------------------------------------------------"
		puts $out_file "# Astro Tcl Routing file"
		puts $out_file "# Converted from Quartus routing file $in_filename"
		puts $out_file "# Converted on: [clock format [clock seconds]]"
		puts $out_file "# Converted by: [file tail [info script]] version $::pvcs_revision(main)"
		puts $out_file "#----------------------------------------------------------"
		puts $out_file ""
		puts $out_file "#----------------------------------------------------------"
		puts $out_file "# Global Variables:"
		puts $out_file "#----------------------------------------------------------"
		puts $out_file "# Cell under processing is the currently selected cell"
		puts $out_file "set cell \[geGetEditCell\]"
		puts $out_file "# This is the id of the contact used to connect layers $default_layer(horizontal) and $default_layer(vertical)"
		puts $out_file "set contact_id $contact_id"
		puts $out_file "#----------------------------------------------------------"
		puts $out_file ""
	} else {
		puts $out_file "new"
		set size [expr 20000000 / $draw_scale]
		puts $out_file "size $size,$size"
		puts $out_file "fill 1,1,255,255,255"
	}
}


# -------------------------------------------------
# -------------------------------------------------
proc print_routednets_script_banner { out_file in_filename} {
# -------------------------------------------------
# -------------------------------------------------
	puts $out_file "#----------------------------------------------------------"
	puts $out_file "# List of routed nets for Astro"
	puts $out_file "# Converted from Quartus routing file $in_filename"
	puts $out_file "# Converted on: [clock format [clock seconds]]"
	puts $out_file "# Converted by: [file tail [info script]] version $::pvcs_revision(main)"
	puts $out_file "#----------------------------------------------------------"
	puts $out_file ""
}



# -------------------------------------------------
# -------------------------------------------------
proc convert_to_astro_routing { in_filename out_filename out_routed_nets } {
# Actually does the conversion by reading the input
# from input file, result is saved in the output file
# -------------------------------------------------
# -------------------------------------------------
	global out_file
	global out_nets_file
	global hard_zones

	set use_hard_zones [expr [llength $hard_zones] != 0]

	if {[catch {
		set out_file [open $out_filename w]
	} result]} {
		post_message -type error "Unable to create output file $out_filename"
		msg_vdebug $result
		return
	}		

	if {[catch {
		set out_nets_file [open $out_routed_nets w]
	} result]} {
		post_message -type error "Unable to create output file $out_routed_nets "
		msg_vdebug $result
		return
	}		

	if {$use_hard_zones} {
		set out_hard_zones_filename "[file rootname $out_filename].hard[file extension $out_filename]"
		if {[catch {
			set out_hard_file [open $out_hard_zones_filename w]
		} result]} {
			post_message -type error "Unable to create output file $out_hard_zones_filename"
			msg_vdebug $result
			return
		}

		set out_hard_nets_filename "[file rootname $out_routed_nets].hard[file extension $out_routed_nets]"
		if {[catch {
			set out_hard_nets [open $out_hard_nets_filename w]
		} result]} {
			post_message -type error "Unable to create output file $out_hard_nets_filename"
			msg_vdebug $result
			return
		}
		post_message -type info "Writing Astro routing within hard zones to $out_hard_zones_filename"
		post_message -type info "Writing list of routed nets within hard zones to $out_hard_nets_filename"

		print_astro_script_banner $out_hard_file $in_filename
		print_routednets_script_banner $out_hard_nets $in_filename
	}

	print_astro_script_banner $out_file $in_filename
	print_routednets_script_banner $out_nets_file $in_filename

	set infile [open $in_filename r]
	set line_num 0
	while {![eof $infile]} {
		set line [gets $infile]
		# Check if the line is a comment, if yes, 
		# just repeat it in the ourput file
		if {[string index $line 0] == ";"} {
			post_message -type error "QREF file $in_filename is in the old Scheme format."
			msg_vdebug "Looks like a Scheme line: $line"
			break
		} elseif {[string index $line 0] == "\#" || [string trim $line] == ""} {
			puts $out_file $line
		} else {
			if {[catch {
				if {$use_hard_zones && [net_crosses_hard_zone $line]} {
					# Redirect this net into "hard" file
					set normal_out $out_file
					set out_file $out_hard_file
					set normal_nets $out_nets_file
					set out_nets_file $out_hard_nets

					eval $line

					set out_file $normal_out
					set out_nets_file $normal_nets
				} else {
					# Just normal execution
					eval $line
				}
			} err_info]} {
				post_message -type error "Failed processing $in_filename on line ${line_num}."
				msg_vdebug "Internal Tcl Error: $err_info"
				break
			}
		}
		incr line_num
	}

	close $infile
	close $out_file
	close $out_nets_file 
	if {$use_hard_zones} {
		close $out_hard_file
		close $out_hard_nets
	}
}


# -------------------------------------------------
# -------------------------------------------------
proc net_crosses_hard_zone { line } {
# Function checks if specific net routing crosses 
# any of the hard zones
# -------------------------------------------------
# -------------------------------------------------
	global hard_zones
	global crosses_hard_zone
	global check_hard_zone_crossing

	set crosses_hard_zone 0
	set check_hard_zone_crossing 1

	eval $line 
	set check_hard_zone_crossing 0

	return $crosses_hard_zone
}


# -------------------------------------------------
# -------------------------------------------------
proc load_hard_zones { hard_zone_file } {
# Functions loads the route guides from the input 
# file
# Expected format: 
# H|V (lx ly) (hx hy)
# This implies that routing with the specified direction
# should use the opposite layer within the specified 
# bbox
# -------------------------------------------------
# -------------------------------------------------
	global hard_zones

	set pattern {\(([0-9.]+)[ \t]+([0-9.]+)\)[ \t]+\(([0-9.]+)[ \t]+([0-9.]+)\)}
	set infile [open $hard_zone_file]
	while {![eof $infile]} {
		set line [gets $infile]
		if {[string trim $line] == ""} {
			continue
		}
		if {[string index $line 0] == "#"} {
			# It's a comment
			continue
		}
		if {![regexp $pattern $line whole lx ly hx hy]} {
			error "Unable to parse hard zone line \"$line\""
		}
		lappend hard_zones [list [expr int(1000 * $lx)] \
								[expr int(1000 * $ly)] \
								[expr int(1000 * $hx)] \
								[expr int(1000 * $hy)]]
	}
	close $infile
}

# -------------------------------------------------
# -------------------------------------------------
proc main {} {
# Main entry point
# -------------------------------------------------
# -------------------------------------------------

	global info_map
	global project_already_opened
	global quartus
	global hc_output
	global argv

	set argument_list $quartus(args)

	display_banner

	set binary [file rootname [file tail [info nameofexecutable]]]
	if {$quartus(nameofexecutable) == "quartus_sh"} {
		# Input file name should be provided as an argument
		if {[llength $argv] == 3} {
			set option [lindex $argv 0]
			if {$option != "-hardzone"} {
				print_help_and_abort
			}
			set hard_zone_file [lindex $argv 1]
			if {[file pathtype $hard_zone_file] == "relative"} {
				set hard_zone_file [file join [pwd] $hard_zone_file]
			}
			set resolved_filename [lindex $argv 2]
		} elseif {[llength $argv] == 1} {
			set resolved_filename [lindex $argv 0]
		} else {
			print_help_and_abort
		}
		if {[file pathtype $resolved_filename] == "relative"} {
			set resolved_filename [file join [pwd] $resolved_filename]
		}
	} elseif {$quartus(nameofexecutable) == "quartus_cdb"} {
		# Get intput from opened project: safer and nicer
		load_package atoms
		load_package advanced_device

		if {!$project_already_opened} {
			post_message -type error "The project is not opened!"
			print_help_and_abort
		}

		set current_revision [get_current_revision]
		set in_filename [file join $hc_output "${current_revision}.qref"]
		set resolved_filename [resolve_file_path $in_filename]
	} else {
		print_help_and_abort
	}

	post_message -type info "Reading Quartus routing from $resolved_filename"

	if {![file exists $resolved_filename]} {
		post_message -type error "Input quartus routign file $resolved_filename does not exist."
		post_message -type info "Did you run quartus_cdb --generate_hardcopy_files?"
		qexit -error
	}
	if {![file readable $resolved_filename]} {
		post_message -type error "Input file $resolved_filename is not readable."
		qexit -error
	}

	if {[info exists hard_zone_file]} {
		if {![file readable $hard_zone_file]} {
			post_message -type error "Input hard zones file $hard_zone_file is not readable."
			qexit -error
		}
		load_hard_zones $hard_zone_file
	}

	set is_compressed [is_file_compressed $resolved_filename]

	set decrypted_filename $resolved_filename
	if {$is_compressed} {
		if {[catch {
			set decrypted_filename "${resolved_filename}.tmp"
			decode_file $resolved_filename -hc_netlist -output $decrypted_filename
		} err_info]} {
			post_message -type error "Failed decompressing $resolved_filename."
			msg_vdebug "Internal Tcl Error: $err_info"
			qexit -error
		}
	}
	
	ipc_report_status 5

	set out_filename "${resolved_filename}.tcl"
	post_message -type info "Writing Astro routing to $out_filename"
	set out_routed_nets "${resolved_filename}.nets"
	post_message -type info "Writing list of routed nets to $out_routed_nets"

	if {[catch {
		convert_to_astro_routing $decrypted_filename $out_filename $out_routed_nets 
	} err]} {
		if {$is_compressed} {
			file delete -force $decrypted_filename
		}
		error $err
	}

 	ipc_report_status 10

	if {$is_compressed} {
		file delete -force $decrypted_filename
	}

 	ipc_report_status 15
}

# -------------------------------------------------
# -------------------------------------------------

if [catch {load_package crypt} result] {
	post_message -type error "You are not authorized to use this option or script."
	msg_vdebug $result
} else {
	main
}

# -------------------------------------------------
# -------------------------------------------------
