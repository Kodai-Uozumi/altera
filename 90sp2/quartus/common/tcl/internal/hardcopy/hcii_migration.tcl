set pvcs_revision(main) [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #3 $} {\1}]

# *************************************************************
#
# File: hcii_migration.tcl
#
# Usage: quartus_cdb --migrate_to_hcii [options] <project>
#
#		where [options] are described below. Search for available_options
#			
#
# Description:
#		Create HardCopy II companion revision.
#		If one exist, overwrite
#		Copy all basic assignments
#		Iterate though IOC atoms and create pin location
#		assignments for each
#
#		The script only knows how to convert a subset of all
#		Quartus assignments.
#
# *************************************************************

set builtin_dir [file dirname [info script]]

set supported_family {stratixii hardcopyii}

array set migration_family {
    stratixii       {{HardCopy II}}
    hardcopyii      {{Stratix II}}
}

array set default_companion_extension {
    stratixii       _fpga
    hardcopyii      _hc
}

if { [string equal -nocase [get_ini_var -name hcx_pass_through_flow] ""] || [string equal -nocase [get_ini_var -name hcx_pass_through_flow] "ON"] } {
    lappend supported_family stratixiii
    lappend supported_family stratixiv
    lappend supported_family hardcopyiii
    lappend supported_family hardcopyiv
    set migration_family(stratixiii)  {{HardCopy III}}
    set migration_family(hardcopyiii) {{Stratix III}}
    set migration_family(stratixiv) {{HardCopy IV}}
    set migration_family(hardcopyiv) {{Stratix IV}}
    set default_companion_extension(stratixiii)  _fpga
    set default_companion_extension(stratixiv)   _fpga
    set default_companion_extension(hardcopyiv)  _hc
    set default_companion_extension(hardcopyiii) _hc
}

# ---------------------------------------------------------------
# Available User Options for:
#    quartus_cdb --write_timing_constraint [options] <project>
# ---------------------------------------------------------------

set available_options {
	{ from_rev.arg "#_ignore_#" "The name of the source Quartus II project revision" }
	{ to_rev.arg "#_ignore_#" "The name of the new migrated Quartus II project revision" }
	{ verbose "Show Extra Info with additional information" }
	{ keep_current_rev "Option to keep original revision as current revision" }
	{ no_asl "Option to disable resource backannotation (Internal Use Only)" }
}

# --------------------------------------
# Other Global variables
# --------------------------------------

# ------------------------------
# Load Required Quartus Packages
# ------------------------------
load_package atoms
load_package advanced_device
load_package report
load_package backannotate
load_package device
package require cmdline
source [file join [file dirname [info script]] hardcopy_msgs.tcl]

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

proc initialize_ioc_to_pin_map { part } {
	#
	# This function uses the device database
	# to store a global map with all the
	# IOC_X?_Y?_N? to PIN_??? mapping
	#
	# Generate global ioc2pin_db array
	# where key = IOC name and value = pin name
# -------------------------------------------------
# -------------------------------------------------

	load_device -part $part
	set count 0
	set total_pads [get_pad_data INT_PAD_COUNT]
	for { set pad 0 } { $pad < $total_pads } { incr pad } {

		if ![catch {set pin_name [get_pad_data STRING_USER_PIN_NAME -pad $pad]}] {

			set pin_name "PIN_$pin_name"

			set mcf_name 0
			if [catch {set mcf_name [get_pad_data STRING_MCF_NAME -pad $pad]}] {
				hardcopy_msgs::internal_error "Pad \"$pad\" has no MCF name"
			}

			if {[scan $mcf_name "X%dY%dSUB_LOC%d" x y n] == 3} {

				set loc_pair1 "X=$x"
				set loc_pair2 "Y=$y"
				set loc_pair3 "N=$n"

				set ioc_name "IOC_X${x}_Y${y}_N${n}"

				set ::ioc2pin_db($ioc_name) $pin_name

				incr count
			}
		}
	}

	msg_vdebug "Processed $count pads from device database"

	unload_device
}


# ---------------------------------------------------------------------
# ---------------------------------------------------------------------

proc initialize_nonsocket_pin_map { part migration_part } {
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------

      set mig_path_list "$migration_part $part"
      load_device -part $part -migrating_to $mig_path_list

      set has_nonsocket_mig [get_migration_info has_nonsocket_migration]

      if {$has_nonsocket_mig} {
           set total_pads [get_pad_data INT_PAD_COUNT]
           for { set pad 0 } { $pad < $total_pads } { incr pad } {

                 if ![catch {set pin_name [get_pad_data STRING_USER_PIN_NAME -pad $pad]}] {

                       if ![catch {set mig_pin_name [get_migration_info pin_mapping -pin_name $pin_name]}] {

                          set pin_name_db "PIN_$pin_name"
                          set mig_pin_name_db "PIN_$mig_pin_name"
                          set ::nonsocket2pinmap_db($pin_name_db) $mig_pin_name_db
                       }
                 }
           }
      }
      unload_device
}



# -------------------------------------------------
# -------------------------------------------------

proc get_pkg_location { iocell_atom_id } {
	#
	# This function returns the location of the
	# given IOCell atom. 
	# Due to the fact that the device may have
	# NO_PIN_OUT, the function may need to map
	# the IOC_X?_Y?_N? location stored on the atom
	# to the hidden PIN_??? location
# -------------------------------------------------
# -------------------------------------------------

	set atom_location [get_atom_node_info -key LOCATION -node $iocell_atom_id]

	if [string match "IOC_*" $atom_location] {
		# Need to get the PKG_INFO manually
		# and get the actual pin location

		if [info exists ::ioc2pin_db($atom_location)] {
			set atom_location $::ioc2pin_db($atom_location)
		} else {
			msg_vdebug "No IOC mapping found for \'$atom_location\'"
		}
	}

	return $atom_location
}

# -------------------------------------------------
# -------------------------------------------------

proc get_pin_locations_from_atoms { } {
	#
	# This is the function that knows how to
	# read pin locations from the atom database
	# All locations and names are stored on a
	# global ::locations_db array for later access
	# PLL clock counters are stored in ::clk_counters_db.
# -------------------------------------------------
# -------------------------------------------------

	hardcopy_msgs::post I_READ_PIN_LOCATIONS

	initialize_ioc_to_pin_map $::source_device

        initialize_nonsocket_pin_map $::source_device $::target_device

	foreach_in_collection atom_id [get_atom_nodes] {

		set atom_type [get_atom_node_info -key TYPE -node $atom_id]
		switch -exact -- $atom_type {
			"PIN" {
                                # This is mainly for SII --> HCII
				if [catch {set reserved_type [get_atom_node_info -key ENUM_IO_RESERVED_TYPE -node $atom_id]}] {
					hardcopy_msgs::internal_error "Not able to access ENUM_IO_RESERVED_TYPE"
				}

 				if {[string equal $reserved_type "NONE"] || [string equal $reserved_type "USER"]} {

					set atom_location [get_pkg_location $atom_id]

 					# Get actual pin name from PADIO oterm
					set padio [get_atom_oport_by_type -node $atom_id -type PADIO]
					set padio_name [get_atom_port_info -node $atom_id -type oport -port_id $padio -key name]
					# Store location, name map as an array.
					# Key is location. Value is name
					set ::locations_db($atom_location) "$padio_name"
				}
			}
			"PLL" {
				set atom_location [get_atom_node_info -key LOCATION -node $atom_id]
				set atom_name [get_atom_node_info -key NAME -node $atom_id]

				# Store location, name map as an array.
				# Key is location. Value is name
				set ::locations_db($atom_location) "$atom_name"

				set clk_index 0
				foreach clk_counter [get_atom_node_info -key OBJECT_REAL_INTERNAL_PARAMETERS -node $atom_id -feature OBJECT_ENUM_VEC_CLK_COUNTER] {

					if {[string compare $clk_counter ""] != 0} {

						set clk_id [get_atom_oport_by_type -node $atom_id -type CLK -index $clk_index]
						set clk_name [get_atom_port_info -node $atom_id -type oport -port_id $clk_id -key NAME]
							# clock names are unique
						set ::clk_counters_db($clk_name) $clk_counter
					}
					incr clk_index
				}
			}
			"IO_PAD"
			{
			        # This is mainly to handle SIII --> HCIII due to the way we model IO cells in SIII/HCIII
			        # Please refer to SPR 274458 for more detail
			        if [catch {set reserved_type [get_atom_node_info -key ENUM_IO_RESERVED_TYPE -node $atom_id]}] {
					hardcopy_msgs::internal_error "Not able to access ENUM_IO_RESERVED_TYPE"
				}

 				if {[string equal $reserved_type "NONE"] || [string equal $reserved_type "USER"]} {
                                        
                                        set atom_location [get_pkg_location $atom_id]
                                        set padio_name [get_atom_node_info -node $atom_id -key name]
                                        
                                        if {[array exists ::nonsocket2pinmap_db]} {
                                                
                                                if [info exists ::nonsocket2pinmap_db($atom_location)] {
                                                        set atom_location $::nonsocket2pinmap_db($atom_location)
                                                } else {
                                                        post_message -type error "No Non-socket pin mapping found for \'$atom_location\'" 
                                                }
                                        }

                                        set ::locations_db($atom_location) "$padio_name"
				}                                                       
			}
			default { }
		}
	}

}

# -------------------------------------------------
# -------------------------------------------------

proc cache_back_annotation_assignments { } {
	#
	# This is the function that knows how to
	# call ASL to get resource backannotation
	# data. All assignments get stored in
	# global ::backannotation_assignment_db array for later access
# -------------------------------------------------
# -------------------------------------------------

	hardcopy_msgs::post I_READ_BACK_ANNOTATION

	if [catch {set asgn_list [get_back_annotation_assignments]} result] {
		hardcopy_msgs::post W_FAIL_BACK_ANNOTATION
		return
	}

	set id 0
	foreach_in_collection asgn $asgn_list {

		## Each element in the collection has the following
		## format: { {<Source>} {<Destination>} {<Assignment name>} {<Assignment value>} {<Entity name>} }
		set from   [lindex $asgn 0]
		set to     [lindex $asgn 1]
		set name   [lindex $asgn 2]
		set value  [lindex $asgn 3]
		set entity [lindex $asgn 4]

		set ::backannotation_assignments_db([list $name $from $to $entity $id]) $value

		incr id
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc cache_source_files {} {
	#
	# This function uses get_all_global_assignments
	# to get all source files and store them
	# in a global ::source_files_db list.
	# It uses list instead of arrays to ensure the
	# order is preserved
	# NOTE that this function will special process
	# ALL global assignments that match "*_FILE"
	# But that is ok as any non-source-file processed
	# by this function will still be processed
	# correctly.
# -------------------------------------------------
# -------------------------------------------------
	global options

	set copy_sdc_file 1
	set ::source_files_db ""
	array set exclude_files_map {}
	array set md_src_files_map {}
	array set md_src_files_v_map {}
	
	set id 0

	foreach_in_collection migrate [get_all_global_assignments -name MIGRATION_DIFFERENT_SOURCE_FILE] {
		# Get a list of all the file names of MIGRATION_DIFFERENT_SOURCE_FILE
		# If they exist, put them in a list
		
		set value [lindex $migrate 2]
		if {[string length $migrate] > 0} {
			set md_src_files_v_map($value) SOURCE_FILE
		}
	}
	
	foreach_in_collection asgn [get_all_assignments -name *_FILE -type "global"] {
		set qip		[get_assignment_info $asgn -qip]
		if {[get_assignment_info $asgn -is_default] || [string compare $qip ""] != 0} {
          		# ignore the default global assignments or qip file assignments.
        	} else {
			set section_id   [get_assignment_info $asgn -section_id]
			set name    [get_assignment_info $asgn -name]
			set value   [get_assignment_info $asgn -value]
			set entity  [get_assignment_info $asgn -entity]
			set tag     [get_assignment_info $asgn -tag]
                        set library [get_assignment_info $asgn -library]
                        set hdl_version [get_assignment_info $asgn -hdl_version]

                        #SPR 257048: Handle the -library and -hdl_version options
                        set library_option ""
			if [string compare $library ""] {
				set library_option "-library $library"
			}
			set hdl_version_option ""
	                if [string compare $hdl_version ""] {
        	      		set hdl_version_option "-hdl_version $hdl_version"
                      	}

			set cmd_args "-name $name"
			if [string compare $tag ""] {
				append cmd_args " -tag \"$tag\""
			}

			switch -exact -- $name {
				"MIGRATION_DIFFERENT_SOURCE_FILE" {
					set froot [file rootname $value]
					set fext [file extension $value]
					set md_src_file ${froot}_$options(to_rev)

					if {[string length $fext] > 0} {
						set md_src_file $md_src_file$fext
					}

					if {[file isfile $md_src_file]} {
						hardcopy_msgs::post W_DEST_FILE_EXISTS $value $md_src_file
					} elseif {[file isdirectory $md_src_file]} {
						hardcopy_msgs::post E_NO_COPY_DEST_DIRECTORY $value $md_src_file
						qexit -error
					} elseif {[file isfile $value]} {
						if [catch {file copy -force $value $md_src_file}] {
							hardcopy_msgs::post E_NO_COPY_PERMISSION $value $md_src_file
							qexit -error
						} else {
							hardcopy_msgs::post I_COPIED_FILE $value $md_src_file
						}
					} elseif {[file isdirectory $value]} {
						hardcopy_msgs::post E_NO_COPY_SRC_DIRECTORY $value $md_src_file
						qexit -error
					} else {
						hardcopy_msgs::post E_SRC_FILE_MISSING $value $md_src_file
						qexit -error
					}

					# Add later in case we find the real file type from the user
					# E.g. If the original file was set as
					#   "set_global_assignment fpga.tdf -name AHDL_FILE"
					# we should also use AHDL_FILE instead of the default
					# SOURCE_FILE.
					set md_src_files_map($md_src_file) SOURCE_FILE
					# Exclude old file from the list of source files
					set exclude_files_map($value) $md_src_file
				}
				"DEFAULT_SDC_FILE" { set copy_sdc_file 0 } 
				"SDC_FILE" { set copy_sdc_file 0 } 
				default { }
			}

			# EDA_*_FILE should be handled using ::global_assignments_db
			# Moreover, source files shouldn't have entity names
			if {![string match "EDA_*" $name] && ![string compare $entity ""]} {
				if {[string length [array names exclude_files_map $value]] == 0} {
					# Don't add excluded files
					if {[string length [array names md_src_files_v_map $value]] > 0} {
						# If the file is found under MIGRATION_DIFFERENT_SOURCE_FILE
						# we replace the HDL source file assignment to match the MIGRATION_DIFFERENT_SOURCE_FILE assigment
						set froot [file rootname $value]
						set fext [file extension $value]
						set v_src_file ${froot}_$options(to_rev)
						if {[string length $fext] > 0} {
							set v_src_file $v_src_file$fext
						}
						if {[string match "VERILOG_FILE" $name]} {
							lappend ::source_files_db "-name VERILOG_FILE {$v_src_file} $library_option $hdl_version_option"
	                  			} elseif {[string match "VHDL_FILE" $name]} {
							lappend ::source_files_db "-name VHDL_FILE {$v_src_file} $library_option $hdl_version_option"
						} else {
                                           		lappend ::source_files_db "$cmd_args {$v_src_file} $library_option $hdl_version_option"
						}
					} else {
						lappend ::source_files_db "$cmd_args {$value} $library_option $hdl_version_option"
					} 
				} else {
					set buddy_file $exclude_files_map($value)
					if {[string length [array names md_src_files_map $buddy_file]] > 0} {
						# Rename the file type
						set md_src_files_map($buddy_file) $name
					}
				}
			}
		}
	}

	# Add migration different source files
	foreach src_file [array names md_src_files_map] {
		lappend ::source_files_db "-name MIGRATION_DIFFERENT_SOURCE_FILE {$src_file}"

		if {[string length [array names exclude_files_map $src_file]] == 0} {
			# Don't add if the file was already added by the user
			lappend ::source_files_db "-name $md_src_files_map($src_file) {$src_file}"
		}
	}

	# Copy over the SDC file if necessary
	if {$copy_sdc_file && [file exists $::options(from_rev).sdc]} {
        	if [catch {file copy -force $::options(from_rev).sdc $::options(to_rev).sdc}] {
			hardcopy_msgs::post E_NO_COPY_PERMISSION $::options(from_rev).sdc $::options(to_rev).sdc
			qexit -error
        	} else {
			hardcopy_msgs::post I_COPIED_FILE_GENERIC $::options(from_rev).sdc $::options(to_rev).sdc
        	}
	}
}
	
# -------------------------------------------------
# -------------------------------------------------

proc cache_global_assignments {} {
	# 
	# This function uses get_all_global_assignments
	# to get all assignments and stores them
	# in a global ::global_assignments_db array
	# where the key = <assignment_name-section_id-entity-tag-id> 
	# and value = <assignment_value>
# -------------------------------------------------
# -------------------------------------------------

	global target_family
	global target_device
	global source_device

	set id 0
	set add_physical_synthesis_log_file 0
	array set ignored_asgns {}
	
	# Hardcoding like this is bad. We will get the default temps through DEV.
	# SPR 277070 Corner Junction Temperature
	#set default_max_temp 85
    #set default_min_temp 0
	
	# Get the list of available IO Banks for Target Device
	load_device -part $::target_device
	set io_bank_list [get_pad_data VEC_STRING_IOBANK_NAMES]
	unload_device

	foreach_in_collection asgn [get_all_assignments -name * -type "global"] {

                set section_id   [get_assignment_info $asgn -section_id]
                set name    [get_assignment_info $asgn -name]
                set value   [get_assignment_info $asgn -value]
                set entity  [get_assignment_info $asgn -entity]
                set tag     [get_assignment_info $asgn -tag]
                set qip     [get_assignment_info $asgn -qip]

		if {[string compare "" $qip] == 0} {
                if {![test_assignment_trait -name $name -trait DONT_COPY_TO_CREATED_COMPANION_REVISION]} {

            		switch -glob -- $name {
            			"FAMILY" { set ::global_assignments_db([list $name $section_id "" $tag $id]) $::target_family }
            			"DEVICE" { set ::global_assignments_db([list $name $section_id "" $tag $id]) $::target_device }
            			"TOP_LEVEL_ENTITY" { set ::global_assignments_db([list $name $section_id $entity $tag $id]) $value }
            			"ENABLE_DRC_SETTINGS" { set ::global_assignments_db([list $name $section_id "" $tag $id]) ON }
            			"DEVICE_TECHNOLOGY_MIGRATION_LIST" { set ::global_assignments_db([list $name $section_id "" $tag $id]) $source_device }
            			"EDA_RUN_TOOL_AUTOMATICALLY" {
            				if {[string compare $section_id "eda_design_synthesis"] != 0} {
                                                if {![get_assignment_info $asgn -is_default]} {
            					        set ::global_assignments_db([list $name $section_id $entity $tag $id]) $value
            				         }
            			          }
            			}
            			"NOMINAL_CORE_SUPPLY_VOLTAGE" {
								#SPR 274501: The SIII support Voltage 1.1 and 0.9. HCIII only support 0.9
								#Always migrate the HCIII voltage to 0.9
								# *** This is incorrect.  Do not ignore the voltage assignment.  Core voltage should always be printed out.
								if {[string compare $::target_family "HardCopy III"] == 0 || [string compare $::target_family "Stratix III"] } {																														
									set ::global_assignments_db([list $name $section_id $entity $tag $id]) $value																				
								}
            			}
            			"MAX_CORE_JUNCTION_TEMP" {																
            			        #SPR 277070: The SIII Industrial Package support temperature of 85 and 100 degree celcius
            			        #But the HCIII only supports max temperature of 85 degree celcius

								# ***This is incorrect. HCIII will support the industrial temperature grades [-40,100].
								#    We will update this line if need be later in the flow.
            			        set ::global_assignments_db([list $name $section_id $entity $tag $id]) $value
                        }
						"MIN_CORE_JUNCTION_TEMP" {
							#SPR 277070: The SIII Industrial Package support temperature of 0 and -40 degree celcius
							#But the HCIII only supports min temperature of 0 degree celcius
							 
							# ***This is incorrect. HCIII will support the industrial temperature grades [-40,100].
							#    We will update this line if need be later in the flow.
								set ::global_assignments_db([list $name $section_id $entity $tag $id]) $value
						}
            			"IOBANK_VCCIO" {
                                           # SPR 276189: Some of the IO Bank is not available for the companion revision.
                                           # Before migration MUST check the avaiability of the IO Bank before migration
                                           if {[lsearch $io_bank_list $section_id] != -1} {
                                                set ::global_assignments_db([list $name $section_id $entity $tag $id]) $value
                                           } else {
                                                  hardcopy_msgs::post I_IOBANK_NO_SUPPORTED_PART $::target_device $section_id $name $value

                                           }

            			}            			
            			"OPTIMIZE_SSN" {
	            						# SPR 303542: "Optimise_SSN" not supported for HardCopy.
	            						if {[string length [array names ignored_asgns $name]] == 0} {
                                                #Post unique names
                                            	set ignored_asgns($name) 1
                                                hardcopy_msgs::post I_SKIPPING_GLOBAL $name                                                                                        	
            			        		}
            			}
            			"EDA_FORMAL_VERIFICATION_TOOL" {
	            						# SPR 303163: "FV EDA tools" for HC IV is not supported in Conformal LEC yet.	
	            						if {[string compare $::target_family "HardCopy II"] == 0 || [string compare $::target_family "Stratix II"] == 0} {
		            						if {![get_assignment_info $asgn -is_default]} {
            				        		set ::global_assignments_db([list $name $section_id $entity $tag $id]) $value
    				        				}    				        				            						
	            						} else {	            						
	            							if {[string length [array names ignored_asgns $name]] == 0} {
                                                #Post unique names
                                            	set ignored_asgns($name) 1
                                                hardcopy_msgs::post I_SKIPPING_GLOBAL $name                                                                                        	
            			        			}
        			        			}
            			}
            			"EDA_*" {
            				# Same as default.
            				# We need to do this to avoid any "EDA_*_FILE" from
            				# getting ignored (see next rule)
                                        if {![get_assignment_info $asgn -is_default]} {
            				        set ::global_assignments_db([list $name $section_id $entity $tag $id]) $value
            			        }
            			}
            			"*_FILE" { }
            			default {
            				# Some of the ACF variables may be multi-value, meaning
        				# multiple variables of the same type may exist (e.g.
            				# SOURCE_FILE). Because the Tcl array is using the variable
        				# itself as the key, we need to do something to avoid
            				# collitions:
            				# Simply add a unique ID to break any collitions.
            				# The ID will then be removed when making the assignment
            				if {![get_assignment_info $asgn -is_default]} {
            				        set ::global_assignments_db([list $name $section_id $entity $tag $id]) $value
            			         }
            		          }
            		}
            		incr id
        
              } elseif {[string length [array names ignored_asgns $name]] == 0} {
        
      			# Post unique names
      			set ignored_asgns($name) 1
      			hardcopy_msgs::post I_SKIPPING_GLOBAL $name
          	}
	}
	}
	# Copy ORIGINAL_QUARTUS_REVISION
	set original_qsf_version [get_global_assignment -name ORIGINAL_QUARTUS_VERSION]
	if [string compare $original_qsf_version ""] {
		msg_vdebug "Copy ORIGINAL_QUARTUS_VERSION = $original_qsf_version"
		set ::global_assignments_db([list ORIGINAL_QUARTUS_VERSION "" "" "" $id]) $original_qsf_version
	} else {
		msg_vdebug "ORIGINAL_QUARTUS_VERSION not found"
	}
}
	
# -------------------------------------------------
# -------------------------------------------------

proc cache_instance_assignments {} {
	# 
	# This function uses get_all_instance_assignments
	# to get all assignments and stores them
	# in a global ::instance_assignments_db array
	# where the key = <assignment_value-from-to-section_id-entity-tag-id> 
	# and value = <assignment_value>
# -------------------------------------------------
# -------------------------------------------------

	set id 0
	array set ignored_asgns {}


	foreach_in_collection asgn [get_all_instance_assignments -name *] {

		## Each element in the collection has the following
		## format: {SECTION_ID} {SOURCE} {TARGET} {NAME} {VALUE} {ENTITY} {TAG}
		set section_id [lindex $asgn 0]
		set from [lindex $asgn 1]
		set to [lindex $asgn 2]
		set name [lindex $asgn 3]
		set value [lindex $asgn 4]
		set entity [lindex $asgn 5]
		set tag [lindex $asgn 6]

		if {![test_assignment_trait -name $name -trait DONT_COPY_TO_CREATED_COMPANION_REVISION]} {

		switch -exact -- $name {
			"LOCATION" { }
			"PARTITION_HIERARCHY" {
				# For each partition that we migrate, create an assignment to force the partition
				# to use NETLIST_TYPE = SOURCE
				set ::instance_assignments_db([list $name $from $to $section_id $entity $tag $id]) $value
				set ::global_assignments_db([list PARTITION_NETLIST_TYPE $section_id $entity $tag $id]) SOURCE
			}			
			default { 
				# Some of the ACF variables may be multi-value, meaning
				# multiple variables of the same type may exist (e.g. 
				# SOURCE_FILE). Because the Tcl array is using the variable
				# itself as the key, we need to do something to avoid 
				# collitions:
				# Simply add a unique ID to break any collitions.
				# The ID will then be removed when making the assignment
				set ::instance_assignments_db([list $name $from $to $section_id $entity $tag $id]) $value
			}
		}
		incr id

		} elseif {[string length [array names ignored_asgns $name]] == 0} {

				# Post unique names
			set ignored_asgns($name) 1
			hardcopy_msgs::post I_SKIPPING_INSTANCE $name
		}
	}

	# Enforce following variables
}
	
# -------------------------------------------------
# -------------------------------------------------

proc cache_parameters {} {
	# 
	# This function uses get_all_parameters
	# to get all user parameters and store them
	# in a global ::parameters_db array
# -------------------------------------------------
# -------------------------------------------------

	set id 0

	foreach_in_collection parameter [get_all_parameters -name *] {

		## Each element in the collection has the following
		## format: {TARGET} {NAME} {VALUE} {ENTITY} {TAG}
		set to [lindex $parameter 0]
		set name [lindex $parameter 1]
		set value [lindex $parameter 2]
		set entity [lindex $parameter 3]
		set tag [lindex $parameter 4]

		# Simply add a unique ID to break any collitions.
		# The ID will then be removed when making the assignment
		set ::parameters_db([list $name $to $entity $tag $id]) $value

		incr id
	}
	foreach_in_collection parameter [get_all_parameters -name * -to *] {

		## Each element in the collection has the following
		## format: {TARGET} {NAME} {VALUE} {ENTITY} {TAG}
		set to [lindex $parameter 0]
		set name [lindex $parameter 1]
		set value [lindex $parameter 2]
		set entity [lindex $parameter 3]
		set tag [lindex $parameter 4]

		# Simply add a unique ID to break any collitions.
		# The ID will then be removed when making the assignment
		set ::parameters_db([list $name $to $entity $tag $id]) $value

		incr id
	}
}
	
# -------------------------------------------------
# -------------------------------------------------

proc make_global_assignments {} {
	# 
	# This function uses the global ::global_assignments_db
	# array to make global assignments in the new
	# revision
	# It will also use the global ::source_files_db list
	# to make source file assignments (preserving the
	# original order)
# -------------------------------------------------
# -------------------------------------------------

	hardcopy_msgs::post I_MIGRATING_GLOBAL
	set command "set_global_assignment -name PROJECT_MIGRATION_TIMESTAMP [clock seconds]"
	eval $command
	
	#SPR 287944: Need to set the Family Enum first 
	#Else warning will be prompt when setting the device.
    # SPR:298695 device must in preceding before other evaluation to the db is made
    set precedence_acf {
        FAMILY
        DEVICE
        DEVICE_TECHNOLOGY_MIGRATION_LIST
    }

    foreach acf $precedence_acf {
        set acf_info [array get ::global_assignments_db "$acf *"]
    	if {[llength $acf_info] > 0} {
            set key [lindex $acf_info 0]
            set value [lindex $acf_info 1]

                set name [lindex $key 0]
		set section_id [lindex $key 1]
		set entity [lindex $key 2]
		set tag [lindex $key 3]

                set command "set_global_assignment -name $name {$value}"

                if [string compare $section_id ""] {
			append command " -section_id \{$section_id\}"
		}
		if [string compare $entity ""] {
			append command " -entity \{$entity\}"
		}
		if [string compare $tag ""] {
			append command " -tag \{$tag\}"
		}

		if {$::options(verbose)} {post_message -type extra_info "--> $command"}
		# Make actual assignment
		eval $command
	}
	}
	set device_info [array get ::global_assignments_db "DEVICE*"]
	if {[llength $device_info] > 0} {
		set key [lindex $device_info 0]
		set value [lindex $device_info 1]

		set name [lindex $key 0]
		set section_id [lindex $key 1]
		set entity [lindex $key 2]
		set tag [lindex $key 3]

		set command "set_global_assignment -name $name {$value}"

        if [string compare $section_id ""] {
			append command " -section_id \{$section_id\}"
		}
		if [string compare $entity ""] {
			append command " -entity \{$entity\}"
		}
		if [string compare $tag ""] {
			append command " -tag \{$tag\}"
		}

		if {$::options(verbose)} {post_message -type extra_info "--> $command"}
		# Make actual assignment
		eval $command
	}
    

	foreach key [array names ::global_assignments_db] {
		# Key is constructed using "<name>-<section_id>-<entity>-<tag>-<id>"
		# where section_id & entity are likely ""
		set name [lindex $key 0]
		set section_id [lindex $key 1]
		set entity [lindex $key 2]
		set tag [lindex $key 3]
		# Ignore [lindex $key 4] which is the ID		
		set value $::global_assignments_db($key)

		set command "set_global_assignment -name $name {$value}"

		# 189427: We need to escape all "\}" sequences for
		# assignments, such as USER_LIBRARIES, which take values
		# that can end in a back-slash. Tcl will confuse the
		# back-slash as an escape, thereby escaping the closing brace.
		set count [regsub -all {\\[\}]} $command "\\;\}" command] 

		if {$count > 0} {
			msg_vdebug "Added \";\" to end of $name value"
		}

		if [string compare $section_id ""] {
			append command " -section_id \{$section_id\}"
		}
		if [string compare $entity ""] {
			append command " -entity \{$entity\}"
		}
		if [string compare $tag ""] {
			append command " -tag \{$tag\}"
		}

		if { [string compare $name "USER_LIBRARIES"] == 0 || [string compare $name "SEARCH_PATH"] == 0} {
                            # SPR 275933: This is to maintain backward compatibility
                            # Avoid converting the USER_LIBRARIES from converting to SEARCH_PATH
                            append command " -no_auto"
		}
		
		# The following is to update the VT corner information in the QSF.
		if { [string compare $name "NOMINAL_CORE_SUPPLY_VOLTAGE"] == 0 } {						
						# Do not ignore the voltage assignment.  Core voltage should always be printed out.
						if {[string compare $::target_family "HardCopy III"] == 0 || [string compare $::target_family "Stratix III"]} {																
							set_hc_assignments -voltage_temperature	
							foreach_in_collection asgn [get_all_assignments -name "NOMINAL_CORE_SUPPLY_VOLTAGE" -type "global"] {		
								set value [get_assignment_info $asgn -value]
							}												
							set command "set_global_assignment -name $name {$value}"								
						}
		}		
		if { [string compare $name "MAX_CORE_JUNCTION_TEMP"] == 0 } {	
						if {[string compare $::target_family "HardCopy III"] == 0 || [string compare $::target_family "Stratix III"]} {
							if { $value > 100 } {
								# Change the Max Core Junction Temperature to default value
								set_hc_assignments -voltage_temperature
								foreach_in_collection asgn [get_all_assignments -name "MAX_CORE_JUNCTION_TEMP" -type "global"] {		
									set value [get_assignment_info $asgn -value]
								}	
								set command "set_global_assignment -name $name {$value}"								
								hardcopy_msgs::post I_UPDATE_CORE_MAX_JUNCTION_TEMP $::target_family $value
							}
						}
		}      
		if { [string compare $name "MIN_CORE_JUNCTION_TEMP"] == 0 } {	
						if {[string compare $::target_family "HardCopy III"] == 0 || [string compare $::target_family "Stratix III"]} {
							if { $value < -40 } {
								# Change the Max Core Junction Temperature to default value
								set_hc_assignments -voltage_temperature
								foreach_in_collection asgn [get_all_assignments -name "MIN_CORE_JUNCTION_TEMP" -type "global"] {		
									set value [get_assignment_info $asgn -value]
								}	
								set command "set_global_assignment -name $name {$value}"								
								hardcopy_msgs::post I_UPDATE_CORE_MAX_JUNCTION_TEMP $::target_family $value
							}
						}
		}           		
		
		if {$::options(verbose)} {post_message -type extra_info "--> $command"}
		# Make actual assignment
		eval $command		
	}	
	foreach file_asgn $::source_files_db {

		if [string compare "" $file_asgn] {
			# Note that file_asgn will be of the form:
			#	<variable_name> <tag> <value>
			set command "set_global_assignment $file_asgn"
			if {$::options(verbose)} {post_message -type extra_info "--> $command"}
			# Make actual assignment
			eval $command
		}
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc make_default_global_assignments {} {
	#
	# This will copy the qdf file if it is existed
	# for the companion
# -------------------------------------------------
# -------------------------------------------------

    set qdf_file "assignment_defaults.qdf"

    if {[file exists $::options(from_rev)_$qdf_file]} {
        if [catch {file copy -force $::options(from_rev)_$qdf_file $::options(to_rev)_$qdf_file}] {
			hardcopy_msgs::post E_NO_COPY_PERMISSION $::options(from_rev)_$qdf_file $::options(to_rev)_$qdf_file
			qexit -error
        } else {
			hardcopy_msgs::post I_COPIED_FILE_GENERIC $::options(from_rev)_$qdf_file $::options(to_rev)_$qdf_file
        }
    }
}

# -------------------------------------------------
# -------------------------------------------------

proc make_instance_assignments {} {
	# 
	# This function uses the global ::instance_assignments_db
	# array to make instance assignments in the new
	# revision
# -------------------------------------------------
# -------------------------------------------------

	hardcopy_msgs::post I_MIGRATING_INSTANCE
	foreach key [array names ::instance_assignments_db] {
		# Key is constructed using "<name>-<from>-<to>-<section_id>-<entity>-<tag>-<id>"
		# where section_id & entity are likely ""
		set name [lindex $key 0]
		set from [lindex $key 1]
		set to [lindex $key 2]
		set section_id [lindex $key 3]
		set entity [lindex $key 4]
		set tag [lindex $key 5]
		# Ignore [lindex $key 6] which is the ID
		set value $::instance_assignments_db($key)		
								
		set command "set_instance_assignment -to {$to} -name $name {$value}"
		if [string compare $from ""] {
			append command " -from {$from}"
		}
		if [string compare $section_id ""] {
			append command " -section_id \{$section_id\}"
		}
		if [string compare $entity ""] {
			append command " -entity \{$entity\}"
		}
		if [string compare $tag ""] {
			append command " -tag \{$tag\}"
		}

		if {$::options(verbose)} {post_message -type extra_info "--> $command"}
		# Make actual assignment
		eval $command
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc make_back_annotation_assignments {} {
	# 
	# This function uses the global ::backannotation_assignments_db
	# array to make global and instance assignments in the new
	# revision
# -------------------------------------------------
# -------------------------------------------------

	hardcopy_msgs::post I_MIGRATING_BACK_ANNOTATION
	foreach key [array names ::backannotation_assignments_db] {
		# Key is constructed using "<name>-<from>-<to>-<entity>-<id>"
		set name [lindex $key 0]
		set from [lindex $key 1]
		set to [lindex $key 2]
		set entity [lindex $key 3]
		# Ignore [lindex $key 4] which is the ID
		set value $::backannotation_assignments_db($key)

		if [string compare $to ""] {
			set command "set_instance_assignment -to {$to}"
		} else {
			set command "set_global_assignment"
		}
		append command " -name $name {$value}"
		if [string compare $from ""] {
			append command " -from {$from}"
		}
		if [string compare $entity ""] {
			append command " -entity \{$entity\}"
		}

		if {$::options(verbose)} {post_message -type extra_info "--> $command"}
		# Make actual assignment
		eval $command
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc make_parameter_assignments {} {
	#
	# This function uses the global ::parameters_db
	# array to make parameter settings in the new
	# revision
# -------------------------------------------------
# -------------------------------------------------

	hardcopy_msgs::post I_MIGRATING_PARAMETER
	foreach key [array names ::parameters_db] {
		# Key is constructed using "<name>-<to>-<entity>-<tag>-<id>" where entity is likely ""
		set name [lindex $key 0]
		set to [lindex $key 1]
		set entity [lindex $key 2]
		set tag [lindex $key 3]
		# Ignore [lindex $key 4] which is the ID
		set value $::parameters_db($key)

		set command "set_parameter -name $name {$value}"
		if [string compare $to ""] {
			append command " -to {$to}"
		}
		if [string compare $entity ""] {
			append command " -entity \{$entity\}"
		}
		if [string compare $tag ""] {
			append command " -tag \{$tag\}"
		}

		if {$::options(verbose)} {post_message -type extra_info "--> $command"}
		# Make actual assignment
		eval $command
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc make_location_assignments {} {
	# 
	# This function uses the global ::location_assignments_db
	# array to make location assignments in the new
	# revision
# -------------------------------------------------
# -------------------------------------------------

	hardcopy_msgs::post I_MIGRATING_PIN_LOCATION
	foreach location [array names ::locations_db] {
		if {$::options(verbose)} {post_message -type extra_info "--> set_location_assignment -to $::locations_db($location) $location"}
		set_location_assignment -to $::locations_db($location) $location
	}
	foreach clk_name [array names ::clk_counters_db] {

	        if { [string equal -nocase $::source_family "StratixII"] || [string equal -nocase $::source_family "HardCopyII"] } {

		if {$::options(verbose)} {post_message -type extra_info "--> set_instance_assignment -name PLL_FORCE_OUTPUT_COUNTER -to $clk_name $::clk_counters_db($clk_name)"}
		set_instance_assignment -name PLL_FORCE_OUTPUT_COUNTER -to $clk_name $::clk_counters_db($clk_name)

		} else {

                   if {$::options(verbose)} {post_message -type extra_info "--> set_instance_assignment -name PLL_FORCE_OUTPUT_COUNTER_HARDCOPY_REPLAY -to $clk_name $::clk_counters_db($clk_name)"}
		   set_instance_assignment -name PLL_FORCE_OUTPUT_COUNTER_HARDCOPY_REPLAY -to $clk_name $::clk_counters_db($clk_name)

	        }
	}
}

# -------------------------------------------------
# -------------------------------------------------

proc setup_originating_companion_revision {} {
	# Determine the original companion revision
# -------------------------------------------------
# -------------------------------------------------

	global originating_revisions_db

	set from_rev_originating [get_global_assignment -name ORIGINATING_COMPANION_REVISION]
	set to_rev_originating ""

	if {[revision_exists $::options(to_rev)]} {

			# set to_rev as current
		set_current_revision $::options(to_rev)

			# get the assignment
		set to_rev_originating [get_global_assignment -name ORIGINATING_COMPANION_REVISION]

			# Reset revision
		set_current_revision $::options(from_rev)
	}

	if {[string length $from_rev_originating] == 0} {
		set from_rev_originating -1
	} elseif {[string compare -nocase $from_rev_originating "off"] == 0} {
		set from_rev_originating 0
	} else {
		set from_rev_originating 1
	}
	if {[string length $to_rev_originating] == 0} {
		set to_rev_originating -1
	} elseif {[string compare -nocase $to_rev_originating "off"] == 0} {
		set to_rev_originating 0
	} else {
		set to_rev_originating 1
	}

	if {$from_rev_originating == -1 && $to_rev_originating == -1} {

			# neither revisions have the assignment
		set from_rev_originating 1
		set to_rev_originating 0

	} elseif {$from_rev_originating == -1 && $to_rev_originating != -1} {

			# only to_rev has the assignment
		set from_rev_originating [expr !$to_rev_originating]

	} else {

			# only from_rev has the assignment
			#   or
			# both revisions have the assignment
		set to_rev_originating [expr !$from_rev_originating]
	}

	set originating_revisions_db(from_rev) [expr {$from_rev_originating ? "ON" : "OFF"}]
	set originating_revisions_db(to_rev) [expr {$to_rev_originating ? "ON" : "OFF"}]

	msg_vdebug "originating(from_rev): $originating_revisions_db(from_rev)"
	msg_vdebug "originating(to_rev):   $originating_revisions_db(to_rev)"
}

# -------------------------------------------------
# -------------------------------------------------

proc check_that_project_is_migratable {} {
	# Check that the Family, Device and Migration
	# Device is legal
# -------------------------------------------------
# -------------------------------------------------

	global source_device
	global target_device
	global source_family
	global target_family
	global migration_family
	set is_migratable 0

    set family [get_global_assignment -name FAMILY]
	hardcopy_msgs::post I_SOURCE_FAMILY $family
	# Need to remove all blanks to ensure we catch a hand edited QSF
	regsub -all {\s+} $family "" source_family

    if { [lsearch -exact $::supported_family [string tolower $source_family]] == -1 } {
		hardcopy_msgs::post E_ILLEGAL_SOURCE_FAMILY $source_family
		qexit -error
    }

	set source_device [get_global_assignment -name DEVICE]
	if [string equal -nocase $source_device "AUTO"] {
		hardcopy_msgs::post E_ILLEGAL_SOURCE_DEVICE $source_device
		qexit -error
	} elseif [string equal -nocase [get_part_info -family_variant $source_device] "GX"] {
	        hardcopy_msgs::post E_ILLEGAL_SOURCE_FAMILY $source_device
	        qexit -error
	} else {
		hardcopy_msgs::post I_SOURCE_DEVICE $source_device
	}

	set target_device [get_global_assignment -name DEVICE_TECHNOLOGY_MIGRATION_LIST]
	if [string equal $target_device ""] {
		hardcopy_msgs::post E_UNDEFINED_MIG_DEVICE
		qexit -error
	}

	if [catch {set target_family [lindex [get_part_info -family $target_device] 0]}] {
	   hardcopy_msgs::post E_ILLEGAL_MIG_DEVICE $target_device
	   qexit -error
	}

	hardcopy_msgs::post I_TARGET_FAMILY $target_family
	hardcopy_msgs::post I_SEPARATOR
	hardcopy_msgs::post I_SEPARATOR

    set current_source_family [string tolower $source_family]
    if { [ info exists migration_family($current_source_family) ] } {
        set expected_migration_family_list $migration_family($current_source_family)

        foreach expected_migration_family $expected_migration_family_list {
            if { [string equal -nocase $expected_migration_family $target_family] } {
                set is_migratable 1
                break
            }
        }
    } else {
        hardcopy_msgs::internal_error "$source_family is defined under supported family, but does not exist in migration family mapping"
    }

    if { $is_migratable == 0 } {
        hardcopy_msgs::post E_WRONG_FAMILY_MIG_DEVICE $target_device [join $expected_migration_family_list "/"]
    	qexit -error
    }

    if { $is_migratable == 1 } {
        # the part may have new names, get it first before compare.
        # both source and target must get the new name, in case of HCX first migration
        set source_device_new_name [get_dstr_string -part $source_device]
        set target_device_new_name [get_dstr_string -part $target_device]

        set part $source_device_new_name
        regsub -nocase "{" $migration_family($current_source_family) "" mig_family
        regsub -nocase "}" $mig_family "" mig_family
		set mig_parts [get_migration_path $part -within $mig_family -all_speed_grades]
        regsub -nocase "mig:" $mig_parts "" mig_parts

        for {set i 0} {$i < [llength $mig_parts]} {incr i}  {
            set is_migratable 0
		    set mig_dev [lindex $mig_parts $i]

            if [string equal -nocase $mig_dev $target_device_new_name] {
                set is_migratable 1
            } elseif [string match "$target_device_new_name*" $mig_dev] {
                set is_migratable 1
            }

            if { $is_migratable == 1 } {
                set i [llength $mig_parts]
            }
        }

        if { $is_migratable == 0 } {
            hardcopy_msgs::post E_ILLEGAL_MIG_DEVICE $target_device
	        qexit -error
        }
    }
      
        # 303666:All HCX wirebond devices are not supported in QII 9.0 SP1 for HardCopy migration and compilation
        if {[catch {set target_device_enum [lindex [get_part_info $target_device -device] 0]}] ||
                        [test_device_trait_of -device $target_device_enum -trait DISABLE_COMPILER_SUPPORT] ==1} {
                        
	        hardcopy_msgs::post E_ILLEGAL_HC_COMPANION_DEVICE $target_device
	        qexit -error
       }

	hardcopy_msgs::post I_TARGET_DEVICE $target_device
}

# -------------------------------------------------
# -------------------------------------------------
proc clean_up_hc_report_folders {} {
	# Remove old HardCopy folders
# -------------------------------------------------
# -------------------------------------------------

	global options_map

	set success 1

	foreach revision [list $::options(from_rev) $::options(to_rev)] {

			# set the revision as current, if necessary
		set prev_revision [get_current_revision]
		if {[string compare $prev_revision $revision] == 0} {
			set prev_revision ""
		} else {
			set_current_revision $revision
		}

			# Remove report folders
		if {![catch {load_report $revision}]} {

			set do_save_rdb 0
			foreach folder {"HardCopy*Companion Revision Comparison"
							"Archive HardCopy*Handoff Files"
							"HardCopy*Handoff Report"} {

				set folder_id [get_report_panel_id $folder]
				if {$folder_id != -1} {
					# delete report folder
					delete_report_panel -id $folder_id
					msg_vdebug "Deleted: $folder ($revision)"
					set do_save_rdb 1
				}
			}

			if {$do_save_rdb} {

				# Save the changes to the report database
				save_report_database
			}

			unload_report $revision
		}

			# Reset revision to the previous one
		if {[string length $prev_revision] > 0} {
			set_current_revision $prev_revision
		}
	}

	return $success
}

# -------------------------------------------------
# -------------------------------------------------
proc get_default_companion_extension {} {
# -------------------------------------------------
# -------------------------------------------------

    global default_companion_extension
    global target_family
    set companion_extension ""

    regsub -all {\s+} $target_family "" current_target_family
    set current_target_family [string tolower $current_target_family]

    if { [info exists default_companion_extension($current_target_family)] } {
        set companion_extension $default_companion_extension($current_target_family)
    } else {
        hardcopy_msgs::internal_error "$current_target_family is not recognized as a supported family. This should be captured earlier."
    }

    return $companion_extension
}

# -------------------------------------------------
# -------------------------------------------------

proc main {} {
	# Script starts here
	# 1.- Process command-line arguments
	# 2.- Open project
	# 3.- Read Atom Netlist and get pin locations
	# 4.- Create new revision
	# 5.- Copy required assignments
	# 6.- Make pin location assignments based on 3.
	# 7.- Close Atom Netlist and Project
# -------------------------------------------------
# -------------------------------------------------

	global quartus
	global options


#---------
	ipc_restrict_percent_range 5 93
#---------

	# ---------------------------------
	# Print some useful infomation
	# ---------------------------------
	hardcopy_msgs::post I_SEPARATOR
	hardcopy_msgs::post I_SEPARATOR
	hardcopy_msgs::post I_SCRIPT "[file tail [info script]] version: $::pvcs_revision(main)"
	hardcopy_msgs::post I_SEPARATOR
	hardcopy_msgs::post I_SEPARATOR

	# Check arguments
	# Need to define argv for the cmdline package to work
	set argv0 "quartus_cdb -t [info script]"
	set usage "\[<options>\] <project_name>:"

	set argument_list $quartus(args)

	# Use cmdline package to parse options
	if [catch {array set options [cmdline::getoptions argument_list $::available_options]} result] {
		if {[llength $argument_list] > 0 } {
			# This is not a simple -? or -help but an actual error condition
			post_message -type error "Illegal Options"
			post_message -type error  [::cmdline::usage $::available_options $usage]
			qexit -error
		} else {
			post_message -type info  "Usage:"
			post_message -type info  [::cmdline::usage $::available_options $usage]
			qexit -success
		}
	}

	ipc_report_status 5

	# cmdline::getoptions is going to modify the argument_list.
	# Note however that the function will ignore any positional arguments
	# We are only expecting one and only one positional argument (the project)
	# so give an error if the list has more than one element
	if {[llength $argument_list] == 1 } {

		# The first argument MUST be the project name
		set options(project_name) [lindex $argument_list 0]

		if [string compare [file extension $options(project_name)] ""] {
			set project_name [file rootname $options(project_name)]
		}

		set project_name [file normalize $options(project_name)]
	
		msg_vdebug  "Project = $project_name"

	} else {
		post_message -type error "Project name is missing"
		post_message -type info [::cmdline::usage $::available_options $usage]
		post_message -type info "For more details, use \"quartus_cdb --help=hcii_pt_script\""
		qexit -error
	}

	ipc_report_status 10

	# Script may be called from Quartus or another script where the project
	# is already open
	if ![is_project_open] {

		# Create new project if needed and open
		if { ![project_exists $project_name] } {
			post_message -type error "Project $project_name does not exist"

		} else {

			# Get the revision name first if the user didn't give us one
			if {$options(from_rev) == "#_ignore_#"} {
				msg_vdebug "Opening Project: $project_name (Current Revision)"
				if [catch {project_open $project_name -current_revision}] {
					post_message -type error "Project $options(project_name) (Current Revision) cannot be opened" 
					qexit -error
				}
				set options(from_rev) $::quartus(settings)
			} else {
				msg_vdebug "Opening Project: $project_name (Rev = $options(from_rev))" 
				if [catch {project_open $project_name -revision $options(from_rev)}] {
					post_message -type error "Project $options(project_name) ($options(from_rev).qsf) cannot be opened" 
					qexit -error
				}
			}
		}
	}

	if [is_project_open] {

		if {!$options(verbose)} {
			if {[string compare -nocase [get_ini_var -name hcii_migration_verbose] on] == 0} {
				set options(verbose) 1
			}
		}

		# Check that FAMILY, DEVICE and other assignments
		# are migratable before we start
		# This fucntion will qexit on its own if needed
		check_that_project_is_migratable

		if {$options(to_rev) == "#_ignore_#"} {
			if [catch {set options(to_rev) [get_global_assignment -name COMPANION_REVISION_NAME]}] {
				msg_vdebug "No COMPANION_REVISION_NAME or -to_rev defined. Using default target"
				set options(to_rev) "$options(from_rev)[get_default_companion_extension]"

			} else {
				if {$options(to_rev) == ""} {
					msg_vdebug "COMPANION_REVISION_NAME=\"\". Using default target"
					set options(to_rev) "$options(from_rev)[get_default_companion_extension]"

				} else {
					msg_vdebug "COMPANION_REVISION_NAME=$options(to_rev)"
				}
			}
		}

        # 1. Keep the illegal charactor in illegal_char
        set illegal_char ""
        regexp {[ \r\t\n:~!@\\#\/$%^&*?()+={}|<>,.;`'\[\]"]+} $options(to_rev) illegal_char

        #Report Error Message if the revision contains any illegal character
        set length [string length $illegal_char]
        if {$length > 0} {
            regsub -all {\\} $illegal_char "\\\\\\" illegal_char
            regsub -all {[\[]} $illegal_char "\\\[" illegal_char
            regsub -all {[\"]} $illegal_char "\\\"" illegal_char
			hardcopy_msgs::post E_ILLEGAL_CHARACTER $illegal_char
            qexit -error
		}

		hardcopy_msgs::post I_SEPARATOR
		hardcopy_msgs::post I_SOURCE_REVISION $options(from_rev)
		hardcopy_msgs::post I_TARGET_REVISION $options(to_rev)
		hardcopy_msgs::post I_SEPARATOR

		if [string equal -nocase $options(from_rev) $options(to_rev)] {
			hardcopy_msgs::post E_SAME_REVISION
			qexit -error
		}

		ipc_report_status 18

			# Determine who's the original companion revision.
		setup_originating_companion_revision

		hardcopy_msgs::post I_SEPARATOR

		if [revision_exists $options(to_rev)] {
            if { [catch {delete_revision $options(to_rev)}] } {
                 hardcopy_msgs::post E_OVERRIDE_REVISION_FAILED $options(to_rev)
                 qexit -error
            } else {
                hardcopy_msgs::post I_OVERRIDE_REVISION $options(to_rev)
            }
		}

		# Open Post-Fitter Netlist
		# Assume fitter has been run
		# if not, skip location back-annotation
		if {![catch {read_atom_netlist -type cmp}] && [get_chip_info -key BOOL_FIT_SUCCESSFUL]} {

			# Check that the Fitter created a successful fit for Base Family
			set fit_family [get_chip_info -key ENUM_USER_FAMILY]
			regsub -all {\s+} $fit_family "" fit_family

			msg_vdebug "FIT_FAMILY = $fit_family"

			set fit_ok 0
			if [string equal -nocase $fit_family $::source_family] {
				
				# Read IOCell atoms and get pin locations
				# Function will initialize locations_db and clk_counters_db arrays
				if [catch {get_pin_locations_from_atoms}] {

					if {[array exists ::locations_db]} {
						unset ::locations_db
					}
					if {[array exists ::clk_counters_db]} { unset ::clk_counters_db }
				} else {

					set fit_ok 1
				}
			}

			if {!$fit_ok} {

				hardcopy_msgs::post W_NOT_COMPILED_WITH_FAMILY $options(from_rev) $::source_family
				hardcopy_msgs::post W_PIN_NOT_MIGRATED
			}

			# clean up
			unload_atom_netlist
		} else {
			hardcopy_msgs::post W_NOT_COMPILED $options(from_rev)
			hardcopy_msgs::post W_PIN_NOT_MIGRATED
			set fit_ok 0
		}

		ipc_report_status 27

		hardcopy_msgs::post I_READ_QSF

		# Read all parameters in current FPGA revision
		# and store them in a global ::parameters_db
		# variable for later use
		cache_parameters

		# Special handle SOURCE_FILE type assignments
		# The files are cached using a global list (instead of
		# an array). This is done to ensure that the order
		# is preserved
		cache_source_files

		ipc_report_status 36

		# Read all assignments in current FPGA revision
		# and store them in a global ::global_assignments_db
		# variable for later access
		cache_global_assignments

		ipc_report_status 41

		# Read all instance assignments in current FPGA revision
		# and store them in a global ::instance_assignments_db
		# variable for later access
		cache_instance_assignments

		ipc_report_status 52

		if { $fit_ok } {
			# Use back-annotation infrastructure to get all assignments
			# needed to reproduce the same packing and global buffers in
			# HardCopy II
			set dont_use_asl [get_ini_var -name hcii_migration_dont_use_asl]
			if { [string compare -nocase $dont_use_asl ON] } {
				cache_back_annotation_assignments
			} else {
				hardcopy_msgs::post EI_SKIPPING_BACK_ANNOTATION
			}
		} else {
			hardcopy_msgs::post W_FAIL_RESOURCE_ALLCATION
		}



			# Need to make assignment telling FPGA about HCII companion
		set_global_assignment -name COMPANION_REVISION_NAME $options(to_rev)
			# Make assignment for HardCopy II Advisor
		set_global_assignment -name ORIGINATING_COMPANION_REVISION $::originating_revisions_db(from_rev)
			# Export from_rev assignments
		export_assignments

		ipc_report_status 67

		# Create new HCII Revision
		create_revision $options(to_rev) -ignore_family -delete_qsf

		# Set target revision as the current one
		set_current_revision $options(to_rev)

			# Need to make assignment telling FPGA about HCII companion
		set_global_assignment -name COMPANION_REVISION_NAME $options(from_rev)
			# Make assignment for HardCopy II Advisor
		set_global_assignment -name ORIGINATING_COMPANION_REVISION $::originating_revisions_db(to_rev)
		
		ipc_report_status 71

		# Used cached global assignments to make assignments in new revision
		make_parameter_assignments

        # copy over qdf file if it exists in the companion revision
        make_default_global_assignments

		# Used cached global assignments to make assignments in new revision
		make_global_assignments

		ipc_report_status 76

		# Used cached instance assignments to make assignments in new revision
		# Also used cached backannotation assignments to make required assignments
		# to maintain same resource counts
		make_instance_assignments

		# Used cached back-annotation assignments to make assignments in new revision
		make_back_annotation_assignments

		ipc_report_status 83

		if {$fit_ok} {
			# Used cached locations to make location assignments in new revision
			make_location_assignments
		}

		ipc_report_status 91

		# Delete previous reports related to hcii
		clean_up_hc_report_folders

		if { $options(keep_current_rev) } {
				# Export to_rev assignments
				# before setting to from_rev
			export_assignments
				# If this option is set, do not mark new revision as current
				# This option will be used by the GUI. The GUI will manually
				# change to the new revision once the migration is done
			set_current_revision $options(from_rev)
		}

		project_close

		ipc_report_status 100
	}

#---------
	ipc_restrict_percent_range 93 100
#---------
}

# -------------------------------------------------
# -------------------------------------------------
main
# -------------------------------------------------
# -------------------------------------------------

