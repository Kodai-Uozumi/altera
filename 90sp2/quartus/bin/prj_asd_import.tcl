#############################################################################
##  prj_asd_import.tcl
##
##  Import acf file to quartus assignment files
##

lappend auto_path [file join ${::quartus(binpath)} tcl_packages]
package require report
package require struct

proc convert { filename args } { import_assignments_from_maxplus2 $filename $args }

proc import_assignments_from_maxplus2 { filename args } {

	set lowercase_file [string tolower $filename]
	if { [string match {*.acf} $lowercase_file] == 0 } {
		show_message error "Wrong file extension!"
		return -1
	}

	#	Initialize variables
	global old_tcl
	set old_tcl 0
	if { [string compare $::quartus(nameofexecutable) "quartus_cmd"] == 0 } {
		set old_tcl 1
	}
	global comment_flag
	set comment_flag 0
	set start	"BEGIN"
	set stop	"END;"
	set first_node_warning	"TRUE"
	set first_col_eab_warning "TRUE"
	set first_multichip_warning "TRUE"
	set first_ioc_warning "TRUE"
	set no_array "FALSE"
	set do_bus_warn_msg ""
	set bus_mapping_file_name "maxplusii_to_quartus_name_mapping.txt"
	set ignore_node_list {}

	###################################################################################################
	# process the procedure's arguments and set variables
	set do_device_opt	"FALSE"
	set do_location		"FALSE"
	set do_tim_req		"FALSE"
	set do_clique		"FALSE"
	set do_logic_opt	"FALSE"
	set do_local_rout	"FALSE"
	set do_cmp_proc_cfg "FALSE"
	set do_param		"FALSE"
	set do_prj_synth	"FALSE"
	set do_eda_input	"FALSE"
	set do_eda_output	"FALSE"
	set do_tan			"FALSE"
	set do_sim			"FALSE"
	set do_chip			"FALSE"

	if { [string compare $args ""] == 0 } {
		set args "ALL"
	}
	foreach sect $args {
		switch -exact $sect {
			DEVICE_OPTIONS		{ set do_device_opt "TRUE"
								  set do_chip "TRUE"
								}
			CHIP_LOCATION		{ set do_location "TRUE" 
								  set do_chip "TRUE"
								}
			TIMING_REQUIREMENTS	{ set do_tim_req "TRUE" }
			CLIQUE				{ set do_clique "TRUE" }
			LOGIC_OPTIONS		{ set do_logic_opt "TRUE" }
			LOCAL_ROUTING		{ set do_local_rout "TRUE" }
			COMPILER_PROCESSING_CONFIGURATION	{ set do_cmp_proc_cfg "TRUE" }
			PROJECT_PARAMETERS	{ set do_param "TRUE" }
			PROJECT_SYNTHESIS_OPTIONS			{ set do_prj_synth "TRUE" }
			EDA_INPUT			{ set do_eda_input "TRUE" }
			EDA_OUTPUT			{ set do_eda_output "TRUE" }
			TIMING_ANALYZER		{ set do_tan "TRUE" }
			SIMULATION			{ set do_sim "TRUE" }
			ALL					{ set do_device_opt "TRUE"
								  set do_location "TRUE"
								  set do_tim_req "TRUE"
								  set do_clique "TRUE"
								  set do_logic_opt "TRUE"
								  set do_local_rout "TRUE"
								  set do_cmp_proc_cfg "TRUE"
								  set do_param "TRUE"
								  set do_prj_synth "TRUE"
								  set do_eda_input "TRUE"
								  set do_eda_output "TRUE"
								  set do_tan "TRUE"
								  set do_sim "TRUE"
								  set do_chip "TRUE"
								}
		}
	}	

	###################################################################################################
	# variables to remember if the corresponding variables have been added to the CHIP section already
	set chip_user_clock		"FALSE"
	set chip_auto_restart	"FALSE"
	set chip_rel_clears		"FALSE"
	set chip_wide_rst		"FALSE"
	set chip_wide_oe		"FALSE"
	set chip_init_done		"FALSE"
	set chip_config_scm6k	"FALSE"
	set chip_config_scm10k	"FALSE"
	set chip_nws_nrs		"FALSE"
	set chip_rdynbusy		"FALSE"
	set	chip_data7_1		"FALSE"
	set chip_jtag_bst		"FALSE"
	set chip_nceo			"FALSE"
	set chip_low_volt_6k	"FALSE"
	set	chip_config_dev		"FALSE"
	set chip_jtag_10k		"FALSE"
	set chip_config_jtag	"FALSE"
	set chip_low_volt_10k	"FALSE"
	set chip_pullup_res		"FALSE"
	set chip_multivolt		"FALSE"
	set chip_lock_output	"FALSE"
	set chip_security_bit	"FALSE"
	set chip_security_val	"FALSE"
	set chip_vrefa_pin		"FALSE"
	set chip_vrefb_pin		"FALSE"
	set chip_usercode_7ks	"FALSE"
	set chip_jtag_7k		"FALSE" 
	set chip_jtag_7kae		"FALSE" 
	set chip_jtag_on		"FALSE"
	set chip_iobank1		"FALSE"
	set chip_iobank2		"FALSE"

	# project synthesis variables
	set auto_global_clr		"FALSE"
	set auto_global_prst	"FALSE"

	# timing requirements variables
	set tim_req_cut_clear	"FALSE"
	set tim_req_cut_io		"FALSE"
	set registered_performance_options ""

	# eda input variables
	set edif_use_lmf1		"FALSE"
	set edif_lmf_file1		""
	set edif_use_lmf2		"FALSE"
	set	edif_lmf_file2		""
	set eda_synth_tool		""
	set eda_add_lmf			"FALSE"
	set eda_add_info		"FALSE"
	set vhdl_lib_logical	""
	set vhdl_lib_physical	""
	set vhdl_add_input		"FALSE"
	set vhdl_version		""
	
	# eda output variables
	set eda_output_format	""
	set verilog_map_char	""
	set verilog_flat_bus	""
	set verilog_trun_hier	""
	set verilog_time_scale	""
	set vhdl_output_version ""
	set vhdl_config_decl	""
	set vhdl_trun_hier		""
	set vhdl_flat_bus		""

	set entity [ string range $lowercase_file [ expr [string last "/" $lowercase_file] + 1 ] [ expr [string last ".acf" $lowercase_file] - 1 ] ]
	set file [open $filename r]
	set chip_group ""
	set cur_family ""
	set prj_cmp_batch ""
	set family_name ""
	set device_name "AUTO"
	set found_device "FALSE"

	#####################################################################################################
	#	search the file for the device family first

	while { [gets $file line] >= 0 } {
		if { [string first DEVICE_FAMILY $line] != -1 } {
			if { [string first FLEX10K $line] != -1 } {
				set cur_family "FLEX10K"
			} elseif { [string first FLEX6000 $line] != -1 } {
				set cur_family "FLEX6K"
			} elseif { [string first ACEX1K $line] != -1 } {
				set cur_family "FLEX10K"
			} elseif { [string first MAX7000B $line] != -1} {
				set cur_family "MAX7000B"
			} elseif { [string first MAX7000AE $line] != -1 } {
				set cur_family "MAX7000AE"
			} elseif { [string first MAX3000A $line] != -1 } {
				set cur_family "MAX3000A"
			} elseif { [string first MAX7000S $line] != -1 } {
				set cur_family "MAX7000S"
			}

			scan $line { %[^{ ;}] = %[^{ ;}] } fam_string family_name
			set fam_string
			set family_name
		}

		if { [string first DEVICE $line] != -1 } {
			if { [string compare $found_device "FALSE"] == 0 } {
				scan $line { %[^{ ;}] = %[^{ ;}] } dstring device_name
				set dstring
				set device_name
				if { [string compare $dstring "DEVICE"] != 0 } {
					set device_name "AUTO"
				} else {
					set found_device "TRUE"
				}
			}
		}
	}
	close $file


	# validate the family and device selected before attempting to import any assignments
	# have to append the speed-grade to the device name, otherwise it'll considered to be invalid.
	set device_name [string toupper $device_name]
	set speedgrade ""
	if { [string first "-" $device_name] != -1 } {
		if { [validate_family_and_device $family_name $device_name] != 0 } {
			scan $device_name { %[^-]%s } device_name speedgrade
			set device_name
			set speedgrade
		}
	}

	if { [string first "-" $device_name] == -1 } {
		if { [string compare $device_name "AUTO"] != 0 } {
			if { [string first "EPF6016" $device_name] == 0 } {
				set device_name $device_name-2
			} elseif { [string compare $cur_family "MAX7000B"] == 0  } {
				set device_name $device_name-7
			}  elseif { [string compare $cur_family "MAX7000AE"] == 0  } {
				set device_name $device_name-7
			}  elseif { [string compare $cur_family "MAX3000A"] == 0  } {
				set device_name $device_name-7
			} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
				set device_name $device_name-7
			} elseif { [string compare $cur_family "FLEX10K"] == 0 } {
				set device_name $device_name-3
			} else { 
				set device_name $device_name-1
			}
		}
	}

	if { [validate_family_and_device $family_name $device_name] != 0 } {
		if { [string first "MAX7000" $family_name] == 0 } {
			set head ""
			set tail ""
			set new_device_name ""
			if { [string compare $family_name "MAX7000"] == 0 } {
				scan $device_name { EPM%[0-9]%[^-] } head tail
				set head
				set tail
			} elseif { [string compare $family_name "MAX7000E"] == 0 } {
				scan $device_name { EPM%[0-9]E%[^-] } head tail
				set head
				set tail
			}

			set new_device_name "EPM${head}S$tail"

			if { [validate_family_and_device "MAX7000S" "$new_device_name$speedgrade"] == 0 } {
				set family_name "MAX7000S"
				set device_name "$new_device_name$speedgrade"
				show_message warning "Unsupported or illegal device or device family specified in $entity.acf -- setting device family to device family $family_name."
			} elseif { [validate_family_and_device "MAX7000S" "$new_device_name-7"] == 0 } {
				set family_name "MAX7000S"
				set device_name "$new_device_name-7"
				show_message warning "Unsupported or illegal device or device family specified in $entity.acf -- setting device family to device family $family_name."
			} elseif { [validate_family_and_device "MAX7000S" "AUTO"] == 0 } {
				set family_name "MAX7000S"
				set device_name "AUTO"
				set do_location "FALSE"
				show_message warning "Can't import device assignments. Unsupported or illegal device or device family specified in $entity.acf -- setting device family to device family $family_name."
			} else {
				set do_location "FALSE"
				show_message warning "Can't import device assignments. Unsupported or illegal device or device family specified in $entity.acf."
			}
		} else {
			show_message error "Can't import assignments. Unsupported or illegal device or device family specified in $entity.acf."
			return -1;
		}
	} 
	
	if { [string compare $do_clique "TRUE"] == 0 } {
		if { [string compare $cur_family "FLEX10K"] == 0 } {
			show_message info "Quartus II does not support clique assignments in the same manner as MAX+PLUS II for FLEX 10K/ACEX 1K devices. Will not import any clique assignments found in $entity.acf."
			set do_clique "FALSE"
		}
	}

	set file [open $filename r]
	set line ""

	#####################################################################################################
	#	process each line in the file 
	global old_tcl
	if { $old_tcl == 1 } {
	while { [gets $file line] >= 0 } {

		#	check for empty line and comments
		if { [string length $line] == 0 } {
			continue
		} elseif { [string first "--" $line] != -1 } {
			set line [process_single $line]
		} elseif { [string first "/*" $line] != -1 } {
			set line [process_multi_start $line]
		} elseif { [string first "*/" $line] != -1 } {
			set line [process_multi_stop $line]
		} elseif { $comment_flag == 1 } {
			set line ""
		}

		if { [string compare [string toupper $line] $start] == 0 } {
			while { [gets $file line] >= 0 } {

				#	check for empty line and comments
				if { [string length $line] == 0 } {
					continue
				} elseif { [string first "--" $line] != -1 } {
					set line [process_single $line]
				} elseif { [string first "/*" $line] != -1 } {
					set line [process_multi_start $line]
				} elseif { [string first "*/" $line] != -1 } {
					set line [process_multi_stop $line]
				} elseif { $comment_flag == 1 } {
					set line ""
				}

				if { [string compare [string toupper $line] $stop] == 0 } {
					break
				} elseif { [string length $line] != 0 } {
					
					set no_array "FALSE"
					#	extract assignment
					set node ""
					set variable ""
					set value ""
					set source ""
					if { [string first " :" $line] == -1 } {
						scan $line { %[^{ ;}] = %[^{ ;}] %[^;] }  variable value source
					} else {
						scan $line { %s : %[^{ ;}] = %[^{ ;}] %[^;] }  node variable value source
						set node
					}
					set variable
					set value
					set source
					set orig_node $node
					if { [string first "{edif}" $line] != -1 } {
						set no_array "TRUE"
					}

					#	to remove {}
				#	set source [ string trim [ string range $source 1 [ expr [ string length $source ] - 2 ] ] ]

					#	to ignore synthesis generated name
					if {[string first "~" $node] != -1} {
						if { [lsearch $ignore_node_list $node] == -1 } {
							lappend ignore_node_list $node
						}
						continue
					}

					#	to change |node to node
					if { [string first "|" $node] == 0 } {
						set node [string range $node 1 end]
					} elseif { [string first "\"|:" $node] == 0 } {
						if { [string compare FREQUENCY $variable] != 0 } {
							set node [string range $node 3 [expr [string length $node] - 2]]
						}
					} elseif { [string first "\"|" $node] == 0 } {
						set node [string range $node 2 [expr [string length $node] - 2]]
					} elseif { [string first "\"" $node] == 0 } {
						set node [string range $node 1 [expr [string length $node] - 2]]
					}

					# to remove the ":" from the string "*|:*"
					set node [string map { |: | } $node]

					####################################################################################################
					#	to change node* to node[*] or node*_* to node[*][*] 

					set do_bus_warn_msg ""
					set bus_notation_node ""
					if { [string compare $no_array "FALSE"] == 0 } {
						set dump ""
						set convert_node ""
						set temp $node
						set acf_node_name $temp
						set unsc_cnt 0
                        set do_bus "FALSE"
						set has_do_bus 0

						while { [string length $temp] > 0 } {
							set do_bus "TRUE"
							set char ""
							set num ""
							scan $temp { %[0-9] } num
							set num
							set extra_char ""

							if { $num == "" } {
								scan $temp { %[^{0-9}]%[0-9]%[:~_a-zA-Z0-9]$ } char num extra_char
								set char
								set num
							} else {
								set do_bus "FALSE"
							}
							set dump $dump$char$num
							set temp [ string range $node [string length $dump] end ]

							# Specific cases where the number should not be converted to an array format
							if { [string length $num] == [string length $node] } {
								set do_bus "FALSE"
							}
							if { $num == "" } {
								set do_bus "FALSE"
							}
							if { $num != "" } {
								set first_char [string index $temp 0]
								if { [string match {[a-zA-Z]} $first_char] == 1 } {
									set do_bus "FALSE"			
								}
								set second_char [string index $temp 1]
								if { [string compare "_" $first_char] == 0 } {
									if { [string match {[a-zA-Z]} $second_char] == 1 } {
										set do_bus "FALSE"
									}
								}
								
								#spr89101
								if { $extra_char != ""} {
									set first_char [string range $extra_char 0 0]
									if { [string compare "_" $first_char] == 0 } {
										if { [string length $extra_char] == 1 } {
											set do_bus "FALSE"
										}
										set extra_char [string range $extra_char  1  end]
										if { ![string is integer $extra_char] } {
											if { [string first "_" $extra_char] == -1 }  {
												set do_bus "FALSE"
											}
										}
										if { $extra_char != "" } {
											if { [string first "_" $extra_char] != -1} {
												if { [string is integer [string range $extra_char 0 [expr [string first "_" $extra_char] -1 ] ] ] } {
													set do_bus "TRUE"
												} else {
													set do_bus "FALSE"
												}
												set extra_char [string range $extra_char [expr [string first "_" $extra_char] + 1]  end]
												if { $extra_char != "" } {
													if { ![string is integer $extra_char] } {
														set do_bus "FALSE"
													}
												} else {
													set do_bus "FALSE"
												}
											}
										}
									}
									if { [string compare "~" $first_char] == 0 } {
										set do_bus "FALSE"
									}
									if { [string compare ":" $first_char] == 0 } {
										set do_bus "FALSE"
									}
								}
							}
							if { $char != "" } {
								set last_char [ string range $char [expr [string length $char] - 1 ] end ]
								if { [string compare ":" $last_char] == 0 } {
									set pen_char [ string index $char [expr [string length $char] - 2] ]
									if { [string compare "|" $pen_char] == 0} {
										if { [string compare FREQUENCY $variable] != 0 } {
											set char [string range $char 0 [expr [string length $char] - 2] ]
										}
									}
									set do_bus "FALSE"
								}
								if { [string compare "|" $last_char] == 0 } {
									set do_bus "FALSE"
								}
								if { [string compare "~" $last_char] == 0 } {
									set do_bus "FALSE"
								}
								if { [string compare "\[" $last_char] == 0 } {
									set do_bus "FALSE"
								}
								if { [string compare "_" $char] == 0 } {
									set char ""
									set unsc_cnt [expr $unsc_cnt + 1]
									if { [string compare "FALSE" $do_bus] == 0} {
										set unsc_cnt 0
										set char "_"
									}
									
								}
								if { [string compare "~" $char] == 0 } {
									set do_bus "FALSE"
									set unsc_cnt 0
								}
								if { [string length $extra_char] > 0 } {
									if  { [string compare "_" $last_char] == 0 } {
										set str_len [string length $char]
										if { $str_len != "0" } {
											set prev_char [string range $char 0 [expr $str_len - 1] ]
											if { [string last "_" $prev_char] != -1 } {
												if { [string length $prev_char] > 0 } {
													set prev_char [string range $prev_char 0 [string last "_" $prev_char] ]
													if { $prev_char != ""} {
														set ind  [string length $prev_char]
														if { $ind != 0 } {
															set last_char [string range $prev_char [expr $ind - 1] end]
															if { ![string is integer $last_char] } {
																set do_bus "FALSE"
															}
														}
													}
												} 
											}
										} 
									}
								}
							}

							# Do conversion to bus format
							if { [string compare "TRUE" $do_bus] == 0 } {
								set acf_node_name $convert_node$char$num
								set convert_node "$convert_node$char\[$num\]"
								set has_do_bus 1
							} else {
								set convert_node $convert_node$char$num
							}
						}

						# There can be, at most, 2-dimensional buses, if more, then a number has been misconverted to a bus
						# type notation
						while { [string first "\]\[" $convert_node] != [string last "\]\[" $convert_node] } {
							set index1 [string first "\[" $convert_node ]
							set index2 [string first "\]" $convert_node ]
							set str_tmp1 [string range $convert_node 0 [expr $index1 - 1] ]
							set str_tmp2 [string range $convert_node [expr $index1 + 1] [expr $index2 - 1]]
							set str_tmp3 [string range $convert_node [expr $index2 + 1] end]
							if { $unsc_cnt > 1 } {
								set convert_node "$str_tmp1$str_tmp2\_$str_tmp3"
							} else {
								set convert_node $str_tmp1$str_tmp2$str_tmp3
							}
						}
						if { [string compare $has_do_bus 1] == 0 } {
							#spr91834
							if { [string compare $acf_node_name ""] != 0 } {
								if { [string compare $convert_node ""] != 0 } {
									set do_bus_warn_msg "1"
								}
							}
						}
						set bus_notation_node $convert_node
					}

					#######################################################################################################
					#	start importing variables

					#	parameters
					if { [string compare "GLOBAL_PARAMETERS" $section] == 0 } {
						project add_default_parameter $variable $value
					} else {

					switch -exact $variable {	
						BEST_CLIQUE {
							if { [string compare "FALSE" [synth_text_hier_name $node]] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity $group "" "" CLIQUE_TYPE_FLEX6K BEST
								project add_assignment $entity $group "" $node MEMBER_OF $group
								project add_assignment $entity $group "" $bus_notation_node MEMBER_OF $group
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
							
						}
						LAB_CLIQUE {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $cur_family "FLEX6K"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity $group "" "" CLIQUE_TYPE_FLEX6K LAB
								project add_assignment $entity $group "" $node MEMBER_OF $group
								project add_assignment $entity $group "" $bus_notation_node MEMBER_OF $group
							} elseif { [string compare $cur_family "MAX7000B"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity $group "" "" CLIQUE_TYPE_MAX7K LAB
								project add_assignment $entity $group "" $node MEMBER_OF $group
								project add_assignment $entity $group "" $bus_notation_node MEMBER_OF $group
							} elseif { [string compare $cur_family "MAX7000AE"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity $group "" "" CLIQUE_TYPE_MAX7K LAB
								project add_assignment $entity $group "" $node MEMBER_OF $group
								project add_assignment $entity $group "" $bus_notation_node MEMBER_OF $group
							} elseif { [string compare $cur_family "MAX3000A"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity $group "" "" CLIQUE_TYPE_MAX7K LAB
								project add_assignment $entity $group "" $node MEMBER_OF $group
								project add_assignment $entity $group "" $bus_notation_node MEMBER_OF $group
							} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
 								project add_assignment $entity $group "" "" CLIQUE_TYPE_MAX7K LAB
								project add_assignment $entity $group "" $node MEMBER_OF $group
								project add_assignment $entity $group "" $bus_notation_node MEMBER_OF $group
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						ROW_CLIQUE {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity $group "" "" CLIQUE_TYPE_FLEX6K ROW
								project add_assignment $entity $group "" $node MEMBER_OF $group
								project add_assignment $entity $group "" $bus_notation_node MEMBER_OF $group
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CLIQUE {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								if { [string compare $cur_family "FLEX6K"] == 0} {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									project add_assignment $entity $group "" "" CLIQUE_TYPE_FLEX6K BEST
									project add_assignment $entity $group "" $node MEMBER_OF $group
									project add_assignment $entity $group "" $bus_notation_node MEMBER_OF $group
								} elseif { [string compare $cur_family "MAX7000B"] == 0 } {
									show_message info "Quartus II does not support clique assignments for MAX7000B/7000AE/3000A/MAX7000S devices. Will not import any clique assignments found in $entity.acf."
								} elseif { [string compare $cur_family "MAX7000AE"] == 0 } {
									show_message info "Quartus II does not support clique assignments for MAX7000B/7000AE/3000A/MAX7000S devices. Will not import any clique assignments found in $entity.acf."
								} elseif { [string compare $cur_family "MAX3000A"] == 0 } {
									show_message info "Quartus II does not support clique assignments for MAX7000B/7000AE/3000A/MAX7000S devices. Will not import any clique assignments found in $entity.acf."
								} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
									show_message info "Quartus II does not support clique assignments for MAX7000B/7000AE/3000A/MAX7000S devices. Will not import any clique assignments found in $entity.acf."								
								}
                            } else {
                            	show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
	                        }
						}
						DEVICE_FAMILY { 
							cmp add_assignment $group $source $node FAMILY $family_name
						}
						INCREASE_INPUT_DELAY {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set value [string toupper $value] 
							if { [string compare $value "ON"] == 0 } {
								set value OFF
							} else {
 								set value ON
							}
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							add_bool_project_assignment $entity $group $source $node DELAY_SETTING_TO_CORE_FLEX6K $value
							add_bool_project_assignment $entity $group $source $node DELAY_SETTING_TO_CORE_FLEX10K $value
							add_bool_project_assignment $entity $group $source $bus_notation_node DELAY_SETTING_TO_CORE_FLEX6K $value
							add_bool_project_assignment $entity $group $source $bus_notation_node DELAY_SETTING_TO_CORE_FLEX10K $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CLKLOCKX1_INPUT_FREQ { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set value ${value}MHZ
								project add_assignment $entity $group $source $node X1_PLL_FREQUENCY $value
								project add_assignment $entity $group $source $bus_notation_node X1_PLL_FREQUENCY $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						INPUT_REFERENCE { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set value [string toupper $value]
							if { [string compare $value "VREFA"] == 0 } {
								set value {AS VREFA}
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity "" "" $node INPUT_REFERENCE $value
								project add_assignment $entity "" "" $bus_notation_node INPUT_REFERENCE $value
							} elseif { [string compare $value "VREFB"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set value {AS VREFB}
								project add_assignment $entity "" "" $node INPUT_REFERENCE $value
								project add_assignment $entity "" "" $bus_notation_node INPUT_REFERENCE $value
							}
				        	} else {
				        		show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
					        }
						}

						IO_STANDARD { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set correct_value [get_correct_value $value]
								cmp add_assignment $chip_group $source $node IO_STANDARD $correct_value 
								cmp add_assignment $chip_group $source $bus_notation_node IO_STANDARD $correct_value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						INSERT_ADDITIONAL_LOGIC_CELL { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity "" "" $node INSERT_ADDITIONAL_LOGIC_CELL $value 
								add_bool_project_assignment $entity "" "" $bus_notation_node INSERT_ADDITIONAL_LOGIC_CELL $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						NORMAL_LCELL_INSERT {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $section "OTHER_CONFIGURATION" ] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node AUTO_LCELL_INSERTION $value
								add_bool_project_assignment $entity $group $source $bus_notation_node AUTO_LCELL_INSERTION $value
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}

						PARALLEL_EXPANDERS { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									add_bool_project_assignment $entity $group $source $node AUTO_PARALLEL_EXPANDERS $value 
									add_bool_project_assignment $entity $group $source $bus_notation_node AUTO_PARALLEL_EXPANDERS $value 
								}
                           } else {
	                           show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
                           }
                                                }
										
						ENABLE_BUS_HOLD { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity "" "" $node ENABLE_BUS_HOLD_CIRCUITRY $value 
								add_bool_project_assignment $entity "" "" $bus_notation_node ENABLE_BUS_HOLD_CIRCUITRY $value 
							}
						    } else {
							    show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
						    }
						}
						
						POWER_UP_HIGH { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
                                                        if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
                                                               project add_assignment $entity "" "" $node POWER_UP_LEVEL $value 
                                                        }
	                        } else {
		                        show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
	                        }
						}
						
                        			TURBO_BIT { 
	                        if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $section "CHIP"] == 0 } {
								if { [string compare $cur_family "MAX7000B"] == 0 } {
									add_bool_project_assignment "" "" "" "" AUTO_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX7000AE"] == 0 } {
									add_bool_project_assignment "" "" "" "" AUTO_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX3000A"] == 0 } {
									add_bool_project_assignment "" "" "" "" AUTO_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
									add_bool_project_assignment "" "" "" "" AUTO_TURBO_BIT $value
								} else {
									add_bool_project_assignment "" "" "" "" TURBO_BIT $value 
								}
							} elseif { [string compare $section "LOGIC_OPTIONS"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								if { [string compare $cur_family "MAX7000B"] == 0 } {
									add_bool_project_assignment $entity "" "" $node MAX7000_INDIVIDUAL_TURBO_BIT $value
									add_bool_project_assignment $entity "" "" $bus_notation_node MAX7000_INDIVIDUAL_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX7000AE"] == 0 } {
									add_bool_project_assignment $entity "" "" $node MAX7000_INDIVIDUAL_TURBO_BIT $value
									add_bool_project_assignment $entity "" "" $bus_notation_node MAX7000_INDIVIDUAL_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX3000A"] == 0 } {
									add_bool_project_assignment $entity "" "" $node MAX7000_INDIVIDUAL_TURBO_BIT $value
									add_bool_project_assignment $entity "" "" $bus_notation_node MAX7000_INDIVIDUAL_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
									add_bool_project_assignment $entity "" "" $node MAX7000_INDIVIDUAL_TURBO_BIT $value
									add_bool_project_assignment $entity "" "" $bus_notation_node MAX7000_INDIVIDUAL_TURBO_BIT $value
								} else {
									add_bool_project_assignment $entity "" "" $node TURBO_BIT $value
									add_bool_project_assignment $entity "" "" $bus_notation_node TURBO_BIT $value
								}
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
                                                
						XOR_SYNTHESIS { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									add_bool_project_assignment $entity $group $source $node XOR_SYNTHESIS $value 
									add_bool_project_assignment $entity $group $source $bus_notation_node XOR_SYNTHESIS $value
								}
	                        } else {
		                        show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
	                        }
                                                }

						ENABLE_PULLUP_RESISTOR { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
                                                         if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
                                                             add_bool_project_assignment $entity $group $source $node WEAK_PULL_UP_RESISTOR $value 
                                                         }
	                        } else {
	                        	show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
		                    }
                                                }
						

						CARRY_CHAIN_LENGTH { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity $group $source $node CARRY_CHAIN_LENGTH $value 
								project add_assignment $entity $group $source $bus_notation_node CARRY_CHAIN_LENGTH $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CASCADE_CHAIN_LENGTH {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity $group $source $node CASCADE_CHAIN_LENGTH $value 
								project add_assignment $entity $group $source $bus_notation_node CASCADE_CHAIN_LENGTH $value 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						REGISTER_OPTIMIZATION { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node DUP_REG_EXTRACTION $value 
								add_bool_project_assignment $entity $group $source $bus_notation_node DUP_REG_EXTRACTION $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						NOT_GATE_PUSH_BACK { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node NOT_GATE_PUSH_BACK $value 
								add_bool_project_assignment $entity $group $source $bus_notation_node NOT_GATE_PUSH_BACK $value 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						ONE_HOT_STATE_MACHINE_ENCODING { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $section "GLOBAL_PROJECT_SYNTHESIS_ASSIGNMENT_OPTIONS"] == 0 } {
							     set value [string toupper $value]
							     if { [string compare $value "ON"] == 0 } {
									set value ONE-HOT
									project add_assignment "" $group $source "" STATE_MACHINE_PROCESSING $value
							     } else {
                                    set value AUTO                 
									project add_assignment "" $group $source "" STATE_MACHINE_PROCESSING $value
                                 } 		
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						DUPLICATE_LOGIC_EXTRACTION { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node DUP_LOGIC_EXTRACTION $value 
								add_bool_project_assignment $entity $group $source $bus_notation_node DUP_LOGIC_EXTRACTION $value 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CARRY_CHAIN	{
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							if { [string compare [string toupper $value] "IGNORE"] == 0 } {
								add_bool_project_assignment $entity $group $source $node IGNORE_CARRY ON
								add_bool_project_assignment $entity $group $source $node AUTO_CARRY OFF
								add_bool_project_assignment $entity $group $source $bus_notation_node IGNORE_CARRY ON
								add_bool_project_assignment $entity $group $source $bus_notation_node AUTO_CARRY OFF
							} else {
								add_bool_project_assignment $entity $group $source $node AUTO_CARRY ON
								add_bool_project_assignment $entity $group $source $node IGNORE_CARRY OFF
								add_bool_project_assignment $entity $group $source $bus_notation_node AUTO_CARRY ON
								add_bool_project_assignment $entity $group $source $bus_notation_node IGNORE_CARRY OFF
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CASCADE_CHAIN {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							if { [string compare [string toupper $value] "AUTO"] == 0 } {
								add_bool_project_assignment $entity $group $source $node AUTO_CASCADE ON
								add_bool_project_assignment $entity $group $source $node IGNORE_CASCADE OFF
								add_bool_project_assignment $entity $group $source $bus_notation_node AUTO_CASCADE ON
								add_bool_project_assignment $entity $group $source $bus_notation_node IGNORE_CASCADE OFF
							} elseif { [string compare [string toupper $value] "IGNORE"] == 0 } {
								add_bool_project_assignment $entity $group $source $node IGNORE_CASCADE ON
								add_bool_project_assignment $entity $group $source $node AUTO_CASCADE OFF
								add_bool_project_assignment $entity $group $source $bus_notation_node IGNORE_CASCADE ON
								add_bool_project_assignment $entity $group $source $bus_notation_node AUTO_CASCADE OFF
							} else {
								add_bool_project_assignment $entity $group $source $node IGNORE_CASCADE OFF
								add_bool_project_assignment $entity $group $source $node AUTO_CASCADE OFF
								add_bool_project_assignment $entity $group $source $bus_notation_node IGNORE_CASCADE OFF
								add_bool_project_assignment $entity $group $source $bus_notation_node AUTO_CASCADE OFF
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						IMPLEMENT_IN_EAB { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare [string toupper $value] "ON"] ==  0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment $entity $group $source $node TECH_MAPPER_FLEX10K ROM
								project add_assignment $entity $group $source $bus_notation_node TECH_MAPPER_FLEX10K ROM
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						PCI_IO { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node PCI_IO $value 
								add_bool_project_assignment $entity $group $source $bus_notation_node PCI_IO $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
						}
						}
						GLOBAL_SIGNAL { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node GLOBAL $value 
								add_bool_project_assignment $entity $group $source $bus_notation_node GLOBAL $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						IMPLEMENT_AS_OUTPUT_OF_LOGIC_CELL { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node IMPLEMENT_AS_LCELL $value 
								add_bool_project_assignment $entity $group $source $bus_notation_node IMPLEMENT_AS_LCELL $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						HIERARCHICAL_SYNTHESIS { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							if { [string compare [string toupper $value] "ON"] == 0 } {
								project add_assignment $entity $group $source $node HIERARCHICAL_COMPILE RELAXED
								project add_assignment $entity $group $source $bus_notation_node HIERARCHICAL_COMPILE RELAXED
							} else {
								project add_assignment $entity $group $source $node HIERARCHICAL_COMPILE OFF
								project add_assignment $entity $group $source $bus_notation_node HIERARCHICAL_COMPILE OFF
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}							 					
						FAST_IO { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node OUTPUT_REGISTER $value
								add_bool_project_assignment $entity $group $source $node INPUT_REGISTER $value
								add_bool_project_assignment $entity $group $source $bus_notation_node OUTPUT_REGISTER $value
								add_bool_project_assignment $entity $group $source $bus_notation_node INPUT_REGISTER $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						IO_CELL_REGISTER {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node OUTPUT_REGISTER $value
								add_bool_project_assignment $entity $group $source $node INPUT_REGISTER $value
								add_bool_project_assignment $entity $group $source $bus_notation_node OUTPUT_REGISTER $value
								add_bool_project_assignment $entity $group $source $bus_notation_node INPUT_REGISTER $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						IGNORE_SOFT_BUFFERS { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node IGNORE_SOFT $value 
								add_bool_project_assignment $entity $group $source $bus_notation_node IGNORE_SOFT $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						SLOW_SLEW_RATE { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node SLOW_SLEW_RATE $value 
								add_bool_project_assignment $entity $group $source $bus_notation_node SLOW_SLEW_RATE $value 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
						}
						}
						
						DEVICE {
							#node name does not require checking for invalid synthesized symbol ~
							cmp add_assignment $group $source $node DEVICE $device_name
						}
						
						CHECK_OUTPUTS { 
							#node name does not require checking for invalid synthesized symbol ~
							add_bool_sim_assignment $group $source $node CHECK_OUTPUTS $value 
						}
						
						SETUP_HOLD { 
							#node name does not require checking for invalid synthesized symbol ~
							add_bool_sim_assignment $group $source $node SETUP_HOLD_DETECTION $value 
						}
						
						SIMULATION_INPUT_FILE { 
							sim add_assignment $group $source $node VECTOR_FILE	$value
						}
						
						END_TIME { 
							#node name does not require checking for invalid synthesized symbol ~
							sim add_assignment $group $source $node END_TIME $value 
						}
						
						START_TIME { 
							#node name does not require checking for invalid synthesized symbol ~
							sim add_assignment $group $source $node START_TIME $value
						}
						GLITCH_TIME { 
							#node name does not require checking for invalid synthesized symbol ~
							sim add_assignment $group $source $node GLITCH_DETECTION_PULSE $value 
						}
						GLITCH { 
							#node name does not require checking for invalid synthesized symbol ~
							add_bool_sim_assignment $group $source $node GLITCH_DETECTION $value 
						}
						LIST_PATH_FREQUENCY { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare NUMBER_OF_PATHS $registered_performance_options] != 0 } {
								project add_assignment "" $group $source $node INCLUDE_PATHS_LESS_THAN_FMAX $value
							}
						}
						LIST_PATH_COUNT { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare FREQUENCY_OF_PATHS $registered_performance_options] != 0 } {
								project add_assignment "" $group $source $node SOURCES_PER_DESTINATION_INCLUDE_COUNT $value
							}
						}
						REGISTERED_PERFORMANCE_OPTIONS {
							set registered_performance_options $value
							if { [string compare FREQUENCY_OF_PATHS $value] == 0 } {
								project remove_assignment "" $group $source $node SOURCES_PER_DESTINATION_INCLUDE_COUNT ""
							} elseif { [string compare NUMBER_OF_PATHS $value] == 0 } {
								project remove_assignment "" $group $source $node INCLUDE_PATHS_LESS_THAN_FMAX ""
							}
						}
						INCLUDE_PATHS_GREATER_THAN_VALUE { 
							#node name does not require checking for invalid synthesized symbol ~
							project add_assignment "" $group $source $node INCLUDE_PATHS_GREATER_THAN_TPD $value 
						}
						CUT_OFF_CLEAR_AND_PRESET_PATHS { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare $tim_req_cut_clear "FALSE"] == 0 } {
								add_bool_project_assignment "" $group $source $node CUT_OFF_CLEAR_AND_PRESET_PATHS $value
							}
						}
						CUT_OFF_IO_PIN_FEEDBACK { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare $tim_req_cut_io "FALSE"] == 0 } {
								add_bool_project_assignment "" $group $source $node CUT_OFF_IO_PIN_FEEDBACK $value
							}
						}
						CUT_OFF_RAM_REGISTERED_WE_PATHS { 
							#node name does not require checking for invalid synthesized symbol ~
							add_bool_project_assignment "" $group $source $node CUT_OFF_READ_DURING_WRITE_PATH $value 
						}
						CUT_ALL_BIDIR { 
							#node name does not require checking for invalid synthesized symbol ~
							set tim_req_cut_io "TRUE"
							add_bool_project_assignment "" $group $source $node CUT_OFF_IO_PIN_FEEDBACK $value 
						}
						CUT_ALL_CLEAR_PRESET { 
							#node name does not require checking for invalid synthesized symbol ~
							set tim_req_cut_clear "TRUE"
							add_bool_project_assignment "" $group $source $node CUT_OFF_CLEAR_AND_PRESET_PATHS $value
						}
						TPD {
							if { [string compare "\"\"" $value] != 0 } {
								if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									if { [string compare $node ""] == 0 } {
										project add_assignment "" $group $source $node TPD_REQUIREMENT $value
									} else {
										project add_assignment $entity $group $source $node TPD_REQUIREMENT $value
										project add_assignment $entity $group $source $bus_notation_node TPD_REQUIREMENT $value
									}
								} else {
									show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
								}
							}
						}
						TCO {
							if { [string compare "\"\"" $value] != 0 } {
								if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									if { [string compare $node ""] == 0 } {
										project add_assignment "" $group $source $node TCO_REQUIREMENT $value
									} else {
										project add_assignment $entity $group $source $node TCO_REQUIREMENT $value
										project add_assignment $entity $group $source $bus_notation_node TCO_REQUIREMENT $value
									}
								} else {
									show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
								}
							}
						}
						TSU {
							if { [string compare "\"\"" $value] != 0 } {
								if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									if { [string compare $node ""] == 0 } {
										project add_assignment "" $group $source $node TSU_REQUIREMENT $value
									} else {
										project add_assignment $entity $group $source $node TSU_REQUIREMENT $value
										project add_assignment $entity $group $source $bus_notation_node TSU_REQUIREMENT $value
									}
								} else {
									show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
								}
							}
						}
						FREQUENCY { 
							if { [string compare "\"\"" $value] != 0 } {
								if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
									if { [string compare $node ""] == 0 } {
										project add_assignment "" $group $source $node REQUIRED_FMAX $value
									} else {
										if { [string first "|" $node] == -1 } {
											if { [string first ":" $node] == -1 } {
												set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
												project add_assignment "" $node "" "" BASE_CLOCK $node
												project add_assignment "" $node "" "" REQUIRED_FMAX $value
												project add_assignment $entity "" "" $node USE_CLOCK $node
												project add_assignment "" $bus_notation_node "" "" BASE_CLOCK $bus_notation_node
												project add_assignment "" $bus_notation_node "" "" REQUIRED_FMAX $value
												project add_assignment $entity "" "" $bus_notation_node USE_CLOCK $bus_notation_node
											} else {
												show_message info "Fmax assignment to any logic function (e.g a register or a node) other than a pin will not be imported. Will ignore the assignment $node : FREQUENCY = $value"
											}
										} else {
											show_message info "Fmax assignment to any logic function (e.g a register or a node) other than a pin will not be imported. Will ignore the assignment $node : FREQUENCY = $value"
										}
									}
								} else {
									show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
								}
							}
						}
						CUT { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group "*" $node CUT $value
								add_bool_project_assignment $entity $group "*" $bus_notation_node CUT $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						SMART_RECOMPILE { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare [string toupper $value] "ON"] == 0 } {
								cmp add_assignment $group $source $node SPEED_DISK_USAGE_TRADEOFF SMART
							} else {
								cmp add_assignment $group $source $node SPEED_DISK_USAGE_TRADEOFF NORMAL
							}
						}
						PRESERVE_ALL_NODE_NAME_SYNONYMS { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare [string toupper $value] "ON"] == 0 } {
								set value "OFF"
							} else {
								set value "ON"
							}
							add_bool_cmp_assignment $group $source $node SAVE_DISK_SPACE $value
						}
						FUNCTIONAL_SNF_EXTRACTOR {
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare [string toupper $value] "ON"] == 0 } {
								sim add_assignment $group $source $node SIMULATION_TYPE FUNCTIONAL
							} else {
								sim add_assignment $group $source $node SIMULATION_TYPE TIMING
							}
						}
						
						LOCAL_DEST { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment $entity $group $source $node USE_LOCAL_FLEX6K "ON" 
								add_bool_project_assignment $entity $group $source $bus_notation_node USE_LOCAL_FLEX6K "ON" 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						FLEX_10K_MAX_PERIPHERAL_OE { 
							#node name does not require checking for invalid synthesized symbol ~
							cmp add_assignment "" "" "" FLEX10K_MAX_PERIPHERAL_OE $value 
						}
						
						LOW_CAP {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							add_bool_project_assignment $entity "" "" $node LOW_CAP_ADJUST_FLEX10KE $value
							add_bool_project_assignment $entity "" "" $bus_notation_node LOW_CAP_ADJUST_FLEX10KE $value
							# Not switching PCI_IO to ON  follows Maxplus+II
							# add_bool_project_assignment $entity "" "" $node PCI_IO $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
					}
					if { [string compare $do_device_opt "TRUE"] == 0 } {
						switch -exact $variable {
							#device option does not include node names assignments
							#checking for synthesized symbols ~ is not required
							MAX7000AE_ENABLE_JTAG {
								if { [string compare $cur_family "MAX7000AE"] == 0 } {
									if { [string compare $chip_jtag_on "FALSE" ] == 0 } {
										if { [string compare $chip_jtag_7kae "FALSE"] == 0 } {
											#puts "MAX7000AE_ENABLE_JTAG"
											if { [string compare $section "CHIP"] == 0 } {
												set chip_jtag_7kae "TRUE"
												add_bool_cmp_assignment $group $source $node JTAG_BST_SUPPORT_MAX7000 $value
												add_bool_cmp_assignment $chip_group $source $node JTAG_BST_SUPPORT_MAX7000 $value
												if { [string compare $value "ON"] == 0 } {
													set chip_jtag_on "TRUE"
												} else {
													set chip_jtag_on "FALSE"
												}
											} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
												 if { [string compare $chip_jtag_7kae "FALSE"] == 0 } {
													add_bool_cmp_assignment $group $source $node JTAG_BST_SUPPORT_MAX7000 $value
													add_bool_cmp_assignment $chip_group $source $node JTAG_BST_SUPPORT_MAX7000 $value									
													if { [string compare $value "ON"] == 0 } {
														set chip_jtag_on "TRUE"
													} else {
														set chip_jtag_on "FALSE"
													}
												}				
											}
										}
									}
								}
							}
														
							MAX7000S_ENABLE_JTAG {
								if { [string compare $cur_family "MAX7000S"] == 0 } {
									if { [string compare $chip_jtag_on "FALSE" ] == 0 } {
										if { [string compare $chip_jtag_7kae "FALSE"] == 0 } {
											if { [string compare $section "CHIP"] == 0 } {
												set chip_jtag_7kae "TRUE"
												add_bool_cmp_assignment $group $source $node JTAG_BST_SUPPORT_MAX7000 $value
												add_bool_cmp_assignment $chip_group $source $node JTAG_BST_SUPPORT_MAX7000 $value
												if { [string compare $value "ON"] == 0 } {
													set chip_jtag_on "TRUE"
												} else {
													set chip_jtag_on "FALSE"
												}
											} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
										   		if { [string compare $chip_jtag_7kae "FALSE"] == 0 } {
													add_bool_cmp_assignment $group $source $node JTAG_BST_SUPPORT_MAX7000 $value
													add_bool_cmp_assignment $chip_group $source $node JTAG_BST_SUPPORT_MAX7000 $value									
													if { [string compare $value "ON"] == 0 } {
														set chip_jtag_on "TRUE"
													} else {
														set chip_jtag_on "FALSE"
													}
												}				
											}
										}
									}
								}
							}

							
							SECURITY {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_security_val "TRUE"
									add_bool_cmp_assignment $group $source $node SECURITY_BIT $value
									add_bool_cmp_assignment "" $source $node SECURITY_BIT $value
								}
							}

							SECURITY_BIT {
								if {[ string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0} {
									if { [string compare $chip_security_val "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node SECURITY_BIT $value
										add_bool_cmp_assignment $chip_group $source $node SECURITY_BIT $value
									}
								}
							}

							MAX7000B_ENABLE_VREFA {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_vrefa_pin "TRUE"
									add_bool_cmp_assignment $group $source $node ENABLE_VREFA_PIN $value
									add_bool_cmp_assignment "" $source $node ENABLE_VREFA_PIN $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_vrefa_pin "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node ENABLE_VREFA_PIN $value
										add_bool_cmp_assignment $chip_group $source $node ENABLE_VREFA_PIN $value
									}
								}
							}

							MAX7000B_ENABLE_VREFB {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_vrefb_pin "TRUE"
									add_bool_cmp_assignment $group $source $node ENABLE_VREFB_PIN $value
									add_bool_cmp_assignment "" $source $node ENABLE_VREFB_PIN $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_vrefb_pin "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node ENABLE_VREFB_PIN $value
										add_bool_cmp_assignment $chip_group $source $node ENABLE_VREFB_PIN $value
									}
								}
							}

							MAX7000AE_USER_CODE {
								if { [string compare $cur_family "MAX7000AE"] == 0 } {
									if { [string compare $section "CHIP"] == 0 } {
										set chip_jtag_7k "TRUE"
										cmp add_assignment $group $source $node USER_JTAG_CODE_MAX7000 $value
										#cmp add_assignment $"" $source $node USER_JTAG_CODE_MAX7000 $value
									} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
										if { [string compare $chip_jtag_7k "FALSE"] == 0 } {
											cmp add_assignment $group $source $node USER_JTAG_CODE_MAX7000 $value
											cmp add_assignment $chip_group $source $node USER_JTAG_CODE_MAX7000 $value
										}
									}
								}
							}

							MAX7000S_USER_CODE {
								if { [string compare $cur_family "MAX7000S"] == 0 } {
									if { [string compare $section "CHIP"] == 0 } {
										set chip_usercode_7ks "FALSE"
										cmp add_assignment $group $source $node USER_JTAG_CODE_MAX7000 $value
									} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
										if { [string compare $chip_usercode_7ks "FALSE"] == 0 } {
											cmp add_assignment $group $source $node USER_JTAG_CODE_MAX7000 $value
											cmp add_assignment $chip_group $source $node USER_JTAG_CODE_MAX7000 $value
										}	
									}
								} 
							}

							MAX7000B_VCCIO_IOBANK1 {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_iobank1 "TRUE"
									cmp add_assignment $chip_group $source $node VCCIO_IOBANK1_MAX7000B $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_iobank1 "FALSE"] == 0 } {
                                                                                cmp add_assignment $chip_group $source $node VCCIO_IOBANK1_MAX7000B $value
									}
								}
							}

							MAX7000B_VCCIO_IOBANK2 {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_iobank2 "TRUE"
									cmp add_assignment $chip_group $source $node VCCIO_IOBANK2_MAX7000B $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_iobank2 "FALSE"] == 0 } {
										cmp add_assignment $chip_group $source $node VCCIO_IOBANK2_MAX7000B $value
									}
								}
							}

							USER_CLOCK { 
								if { [string compare $section "CHIP"] == 0 } {
									set chip_user_clock "TRUE"
									add_bool_cmp_assignment $group $source $node START_UP_CLOCK $value
									add_bool_cmp_assignment "" $source $node START_UP_CLOCK $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_user_clock "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node START_UP_CLOCK $value
										add_bool_cmp_assignment $chip_group $source $node START_UP_CLOCK $value
									}
								}
							}
							AUTO_RESTART {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_auto_restart "TRUE"
									add_bool_cmp_assignment $group $source $node AUTO_RESTART $value
									add_bool_cmp_assignment "" $source $node AUTO_RESTART $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_auto_restart "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node AUTO_RESTART $value
										add_bool_cmp_assignment $chip_group $source $node AUTO_RESTART $value
									}
								}
							}
							RELEASE_CLEARS {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_rel_clears "TRUE"
									add_bool_cmp_assignment $group $source $node RELEASE_CLEARS_BEFORE_TRI $value
									add_bool_cmp_assignment "" $source $node RELEASE_CLEARS_BEFORE_TRI $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_rel_clears "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node RELEASE_CLEARS_BEFORE_TRI $value
										add_bool_cmp_assignment $chip_group $source $node RELEASE_CLEARS_BEFORE_TRI $value
									}
								}
							}
							ENABLE_CHIP_WIDE_RESET {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_wide_rst "TRUE"
									add_bool_cmp_assignment $group $source $node CHIP_WIDE_RESET $value
									add_bool_cmp_assignment "" $source $node CHIP_WIDE_RESET $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_wide_rst "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node CHIP_WIDE_RESET $value
										add_bool_cmp_assignment $chip_group $source $node CHIP_WIDE_RESET $value
									}
								}
							}
							ENABLE_CHIP_WIDE_OE {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_wide_oe "TRUE"
									add_bool_cmp_assignment $group $source $node CHIP_WIDE_OE $value
									add_bool_cmp_assignment "" $source $node CHIP_WIDE_OE $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_wide_oe "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node CHIP_WIDE_OE $value
										add_bool_cmp_assignment $chip_group $source $node CHIP_WIDE_OE $value
									}
								}
							}
							ENABLE_INIT_DONE_OUTPUT {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_init_done "TRUE"
									add_bool_cmp_assignment $group $source $node INIT_DONE_OUTPUT $value
									add_bool_cmp_assignment "" $source $node INIT_DONE_OUTPUT $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_init_done "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node INIT_DONE_OUTPUT $value
										add_bool_cmp_assignment $chip_group $source $node INIT_DONE_OUTPUT $value
									}
								}
							}
							FLEX10K_ENABLE_LOCK_OUTPUT {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_lock_output "TRUE"
									add_bool_cmp_assignment $group $source $node PLL_LOCK_10K $value
									add_bool_cmp_assignment "" $source $node PLL_LOCK_10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_lock_output "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node PLL_LOCK_10K $value
										add_bool_cmp_assignment $chip_group $source $node PLL_LOCK_10K $value
									}
								}
							}
							MULTIVOLT_IO {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_multivolt "TRUE"
									if { [string compare [string toupper $value] "ON"] == 0 } {
										if { [string compare $cur_family "FLEX10K"] == 0 } {
											cmp add_assignment $group $source $node DEVICE_IO_STANDARD_FLEX10K "LVTTL/LVCMOS"
										} elseif { [string compare $cur_family "MAX3000A"] == 0 || [string compare $cur_family "MAX7000AE"] == 0 } {
											cmp add_assignment $group $source $node DEVICE_IO_STANDARD_MAX7000 "2.5 V"
										} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
											cmp add_assignment $group $source $node DEVICE_IO_STANDARD_MAX7000 "LVTTL"
										}
									}
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_multivolt "FALSE"] == 0 } {
										if { [string compare $chip_group ""] != 0 } {
											if { [string compare [string toupper $value] "ON"] == 0 } {
												if { [string compare $cur_family "FLEX10K"] == 0 } {
													cmp add_assignment $chip_group $source $node DEVICE_IO_STANDARD_FLEX10K "LVTTL/LVCMOS"
												} elseif { [string compare $cur_family "MAX3000A"] == 0 || [string compare $cur_family "MAX7000AE"] == 0 } {
													cmp add_assignment $chip_group $source $node DEVICE_IO_STANDARD_MAX7000 "2.5 V"
												} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
													cmp add_assignment $chip_group $source $node DEVICE_IO_STANDARD_MAX7000 "LVTTL"
												}
											}
										}
									}
								}
							}
							CONFIG_SCHEME_FLEX_6000 {
								if { [string compare [string toupper $value] "PASSIVE_SERIAL_ASYNCHRONOUS"] == 0 } {
									set value "Passive Serial Asynchronous"
								} else {
									set value "Passive Serial"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_config_scm6k "TRUE"
									cmp add_assignment $group $source $node PROGRAMMING_MODE_FLEX6K $value
									cmp add_assignment "" $source $node PROGRAMMING_MODE_FLEX6K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_config_scm6k "FALSE"] == 0 } {
										cmp add_assignment $group $source $node PROGRAMMING_MODE_FLEX6K $value
										cmp add_assignment $chip_group $source $node PROGRAMMING_MODE_FLEX6K $value
									}
								}
							}
							CONFIG_SCHEME_10K {
								if { [string compare [string toupper $value] "PASSIVE_PARALLEL_ASYNCHRONOUS"] == 0 } {
									set value "Passive Parallel Asynchronous"
								} elseif { [string compare [string toupper $value] "PASSIVE_PARALLEL_SYNCHRONOUS"] == 0 } {
									set value "Passive Parallel Synchronous"
								} else {
									set value "Passive Serial"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_config_scm10k "TRUE"
									cmp add_assignment $group $source $node PROGRAMMING_MODE_FLEX10K $value
									cmp add_assignment "" $source $node PROGRAMMING_MODE_FLEX10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_config_scm10k "FALSE"] == 0 } {
										cmp add_assignment $group $source $node PROGRAMMING_MODE_FLEX10K $value
										cmp add_assignment $chip_group $source $node PROGRAMMING_MODE_FLEX10K $value
									}
								}
							}
							nWS_nRS_nCS_CS {
								set value [string toupper $value]
								if { [string compare $value "RESERVED_TRI_STATED"] == 0 } {
									set value "As input tri-stated"
								} elseif { [string compare $value "RESERVED_DRIVES_OUT"] == 0 } {
									set value "As output driving an unspecified signal"
								} else {
									set value "Off"
								}							
								if { [string compare $section "CHIP"] == 0 } {
									set chip_nws_nrs "TRUE"
									cmp add_assignment $group $source $node NWS_NRS_NCS_CS_RESERVED $value
									cmp add_assignment "" $source $node NWS_NRS_NCS_CS_RESERVED $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_nws_nrs "FALSE"] == 0 } {
										cmp add_assignment $group $source $node NWS_NRS_NCS_CS_RESERVED $value
										cmp add_assignment $chip_group $source $node NWS_NRS_NCS_CS_RESERVED $value
									}
								}
							}
							DATA1_TO_DATA7 {
								set value [string toupper $value]
								if { [string compare $value "RESERVED_TRI_STATED"] == 0 } {
									set value "As input tri-stated"
								} elseif { [string compare $value "RESERVED_DRIVES_OUT"] == 0 } {
									set value "As output driving an unspecified signal"
								} else {
									set value "Off"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_data7_1 "TRUE"
									cmp add_assignment $group $source $node DATA7_1_RESERVED $value
									cmp add_assignment "" $source $node DATA7_1_RESERVED $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_data7_1 "FALSE"] == 0 } {
										cmp add_assignment $group $source $node DATA7_1_RESERVED $value
										cmp add_assignment $chip_group $source $node DATA7_1_RESERVED $value
									}
								}
							}
							RDYnBUSY {
								set value [string toupper $value]
								if { [string compare $value "RESERVED_TRI_STATED"] == 0 } {
									set value "As input tri-stated"
								} elseif { [string compare $value "RESERVED_DRIVES_OUT"] == 0 } {
									set value "As output driving an unspecified signal"
								} else {
									set value "Off"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_rdynbusy "TRUE"
									cmp add_assignment $group $source $node RDYNBUSY_RESERVED $value
									cmp add_assignment "" $source $node RDYNBUSY_RESERVED $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_rdynbusy "FALSE"] == 0 } {
										cmp add_assignment $group $source $node RDYNBUSY_RESERVED $value
										cmp add_assignment $chip_group $source $node RDYNBUSY_RESERVED $value
									}
								}
							}
							nCEO {
								if { [string compare [string toupper $value] "UNRESERVED"] == 0 } {
									set value "Off"
								} else {
									#this is the default for nCEO
									set value "As output driving ground"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_nceo "TRUE"
									cmp add_assignment $group $source $node NCEO_RESERVED $value
									cmp add_assignment "" $source $node NCEO_RESERVED $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_nceo "FALSE"] == 0 } {
										cmp add_assignment $group $source $node NCEO_RESERVED $value
										cmp add_assignment $chip_group $source $node NCEO_RESERVED $value
									}
								}
							}
							FLEX10K_JTAG_USER_CODE { 
								if { [string compare $section "CHIP"] == 0 } {
									set chip_jtag_10k "TRUE"
									cmp add_assignment $group $source $node USER_JTAG_CODE_FLEX10K $value
									cmp add_assignment "" $source $node USER_JTAG_CODE_FLEX10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_jtag_10k "FALSE"] == 0 } {
										cmp add_assignment $group $source $node USER_JTAG_CODE_FLEX10K $value
										cmp add_assignment $chip_group $source $node USER_JTAG_CODE_FLEX10K $value
									}
								}
							}
							CONFIG_EPROM_USER_CODE { 
								if { [string compare $section "CHIP"] == 0 } {
									set chip_config_jtag "TRUE"
									cmp add_assignment $group $source $node EPROM_JTAG_CODE_FLEX10K $value
									cmp add_assignment "" $source $node EPROM_JTAG_CODE_FLEX10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_config_jtag "FALSE"] == 0 } {
										cmp add_assignment $group $source $node EPROM_JTAG_CODE_FLEX10K $value
										cmp add_assignment $chip_group $source $node EPROM_JTAG_CODE_FLEX10K $value
									}
								}
							}									
							FLEX10KA_USE_LOW_VOLTAGE_CONFIGURATION_EPROM { 
								if { [string compare $section "CHIP"] == 0 } {
									set chip_low_volt_10k "TRUE"
									add_bool_cmp_assignment $group $source $node ENABLE_LOW_VOLT_MODE_FLEX10K $value
									add_bool_cmp_assignment "" $source $node ENABLE_LOW_VOLT_MODE_FLEX10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_low_volt_10k "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node ENABLE_LOW_VOLT_MODE_FLEX10K $value
										add_bool_cmp_assignment $chip_group $source $node ENABLE_LOW_VOLT_MODE_FLEX10K $value
									}
								}
							}
							FLEX6000_ENABLE_JTAG {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_jtag_bst "TRUE"
									add_bool_cmp_assignment $group $source $node JTAG_BST_SUPPORT $value
									add_bool_cmp_assignment "" $source $node JTAG_BST_SUPPORT $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_jtag_bst "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node JTAG_BST_SUPPORT $value
										add_bool_cmp_assignment $chip_group $source $node JTAG_BST_SUPPORT $value
									}
								}
							}
							FLEX6000_USE_LOW_VOLTAGE_CONFIGURATION_EPROM {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_low_volt_6k "TRUE"
									add_bool_cmp_assignment $group $source $node ENABLE_LOW_VOLT_MODE_FLEX6K $value
									add_bool_cmp_assignment "" $source $node ENABLE_LOW_VOLT_MODE_FLEX6K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_low_volt_6k "FALSE"] == 0 } {
										add_bool_cmp_assignment $group $source $node ENABLE_LOW_VOLT_MODE_FLEX6K $value
										add_bool_cmp_assignment $chip_group $source $node ENABLE_LOW_VOLT_MODE_FLEX6K $value
									}
								}
							}
							CONFIG_EPROM_PULLUP_RESISTOR {
								#puts "CONFIG_EPROM_PULLUP_RESISTOR = $value"
								if { [string compare [string toupper $value] "ON"] == 0 } {
									set value "OFF"
								} else {
									set value "ON"
								}
								if { [string compare $section "CHIP"] == 0 } {
									#puts "Section chip"
									set chip_pullup_res "TRUE"
									add_bool_cmp_assignment $group $source $node DISABLE_NCS_AND_OE_PULLUPS_ON_CONFIG_DEVICE $value
									add_bool_cmp_assignment "" $source $node DISABLE_NCS_AND_OE_PULLUPS_ON_CONFIG_DEVICE $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_pullup_res "FALSE"] == 0 } {
										#puts "Section Project"
										add_bool_cmp_assignment $group $source $node DISABLE_NCS_AND_OE_PULLUPS_ON_CONFIG_DEVICE $value
										add_bool_cmp_assignment $chip_group $source $node DISABLE_NCS_AND_OE_PULLUPS_ON_CONFIG_DEVICE $value
									}
								}
							}
							FLEX_CONFIGURATION_EPROM {
								if { [string compare [string toupper $value] "AUTO"] == 0 } {
									# do nothing
								} else { 
									if { [string compare $section "CHIP"] == 0 } {
										set chip_config_dev "TRUE"
										cmp add_assignment $group $source $node USE_CONFIGURATION_DEVICE_NAME_FLEX6K $value
										cmp add_assignment "" $source $node USE_CONFIGURATION_DEVICE_NAME_FLEX6K $value
										cmp add_assignment $group $source $node USE_CONFIGURATION_DEVICE_NAME_FLEX10K $value
										cmp add_assignment "" $source $node USE_CONFIGURATION_DEVICE_NAME_FLEX10K $value
									} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
										if { [string compare $chip_config_dev "FALSE"] == 0 } {
											cmp add_assignment $group $source $node USE_CONFIGURATION_DEVICE_NAME_FLEX6K $value
											cmp add_assignment $chip_group $source $node USE_CONFIGURATION_DEVICE_NAME_FLEX6K $value
											cmp add_assignment $group $source $node USE_CONFIGURATION_DEVICE_NAME_FLEX10K $value
											cmp add_assignment $chip_group $source $node USE_CONFIGURATION_DEVICE_NAME_FLEX10K $value
										}
									}
								}
							}
						}
					}
					if { [string compare $do_location "TRUE"] == 0 } {
						switch -exact $variable {
							PIN { 
                                                                if { [string compare "ANY" $value] != 0 } {
								set value "Pin_$value"
								# put into list to pass back to the batch add_locations procedure
								set temp_value [list $node $value]				
								lappend location_list $temp_value
								set temp_value [list $bus_notation_node $value]				
								lappend location_list $temp_value

								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								if { [llength $location_list] > 500 } {
									cmp add_locations $chip_group $location_list [llength $location_list]
									unset location_list
								}
                                                        }				
							}
							OUTPUT_PIN { 
								if { [string compare "ANY" $value] != 0 } {
								set value "Pin_$value"
								# put into list to pass back to the batch add_locations procedure
								set temp_value [list $node $value]				
								lappend location_list $temp_value
								set temp_value [list $bus_notation_node $value]				
								lappend location_list $temp_value

								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								if { [llength $location_list] > 500 } {
									cmp add_locations $chip_group $location_list [llength $location_list]
									unset location_list
								}							
							}
							}
							INPUT_PIN { 
								if { [string compare "ANY" $value] != 0 } {
								set value "Pin_$value"
								# put into list to pass back to the batch add_locations procedure
								set temp_value [list $node $value]				
								lappend location_list $temp_value
								set temp_value [list $bus_notation_node $value]				
								lappend location_list $temp_value

								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								if { [llength $location_list] > 500 } {
									cmp add_locations $chip_group $location_list [llength $location_list]
									unset location_list
								}				
							}
							}
							BIDIR_PIN { 
								if { [string compare $section "CHIP"] == 0 } {
									if { [string compare "ANY" $value] != 0 } {
									set value "Pin_$value"
									# put into list to pass back to the batch add_locations procedure
									set temp_value [list $node $value]				
									lappend location_list $temp_value
									set temp_value [list $bus_notation_node $value]				
									lappend location_list $temp_value

									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]	
									if { [llength $location_list] > 500 } {
										cmp add_locations $chip_group $location_list [llength $location_list]
										unset location_list
									}				
								}
							}
							}
							LOCATION {
								if { [string first "|:" $node] == -1 } {
									set value [string toupper $value]
									if { [string compare "ANY" $value] != 0 } {
										if { [string first "IOC" $value] == -1 } {
											if { [string first "COL" $value] == -1 } {
												# make sure there are no invalid location indices
												set dont_import "FALSE"
												if { [string first "ROW" $value] == -1 } {
													set loc_temp $value
													set loc_dump ""
													while { [string length $loc_temp] > 0 } {
														set loc_char ""
														set loc_num ""
														scan $loc_temp { %[^{0-9}]%[0-9] } loc_char loc_num
														set loc_char
														set loc_num
														set loc_dump $loc_dump$loc_char$loc_num
														set loc_temp [ string range $value [string length $loc_dump] end ]
														if { $loc_num == 0 } {
															set dont_import "TRUE"
														}
													}
												}
										
												if { [string compare "FALSE" $dont_import] == 0 } { 
													if { [string compare "ROW_ANY" $value] == 0 } {
														set value "Any_Row"
													} elseif { [string compare "COL_ANY" $value] == 0 } {
														set value "Any_Col"
													}	

													# put into list to pass back to the batch add_locations procedure
													set temp_value [list $node $value]				
													lappend location_list $temp_value
													set temp_value [list $bus_notation_node $value]				
													lappend location_list $temp_value

													set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
													if { [llength $location_list] > 500 } {
														cmp add_locations $chip_group $location_list [llength $location_list]
														unset location_list
													}

												} else {
													show_message info "Invalid location index -- $value. All location indices begin with 1. Will not import this location assignment."
												}
											} else {
												if { [string first "EAB" $value] == -1 } {
													if { [string compare "COL_ANY" $value] == 0 } {
														set value "Any_Col"
													}	
													set col_value [list $node $value]
													lappend column_list $col_value
													set col_value [list $bus_notation_node $value]
													lappend column_list $col_value
												} else {
													if { [string compare $first_col_eab_warning "TRUE"] == 0 } {
														show_message info "COL_EAB is not a valid location type. Will not import this location assignment."
														set first_col_eab_warning "FALSE"
													}
												}
											}
										} else {
											set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
											add_bool_project_assignment $entity "" "" $node INPUT_REGISTER ON
											add_bool_project_assignment $entity "" "" $node OUTPUT_REGISTER ON
											add_bool_project_assignment $entity "" "" $bus_notation_node INPUT_REGISTER ON
											add_bool_project_assignment $entity "" "" $bus_notation_node OUTPUT_REGISTER ON
											if { [string compare $first_ioc_warning "TRUE"] == 0 } {
												show_message info "IOC location assignments are not supported by Quartus II. Will automatically translate an IOC location assignment to the Fast Input/Output Register logic assignment, but exact I/O placement will be lost."
												set first_ioc_warning "FALSE"
											}
										}
									}
								}
							}
						}
					}							
					if { [string compare $do_prj_synth "TRUE"] == 0 } {
						switch -exact $variable {
							AUTO_IMPLEMENT_IN_EAB {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment "" $group $source $node AUTO_ROM $value
								add_bool_project_assignment "" $group $source $bus_notation_node AUTO_ROM $value
							}
							AUTO_OPEN_DRAIN_PINS {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment "" $group $source $node AUTO_OPEN_DRAIN $value
								add_bool_project_assignment "" $group $source $bus_notation_node AUTO_OPEN_DRAIN $value
							}
							AUTO_REGISTER_PACKING { 
								if { [string compare [string toupper $value] "ON"] == 0 } {
									set value "Minimize Area"
								}
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment "" $group $source $node REGISTER_PACKING $value
								project add_assignment "" $group $source $bus_notation_node REGISTER_PACKING $value
							}
							AUTO_FAST_IO { 
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment "" $group $source $node AUTO_INPUT_REGISTER $value 
								add_bool_project_assignment "" $group $source $node AUTO_OUTPUT_REGISTER $value 
								add_bool_project_assignment "" $group $source $bus_notation_node AUTO_INPUT_REGISTER $value 
								add_bool_project_assignment "" $group $source $bus_notation_node AUTO_OUTPUT_REGISTER $value 
							}
							AUTO_IO_CELL_REGISTERS {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment "" $group $source $node AUTO_INPUT_REGISTER $value 
								add_bool_project_assignment "" $group $source $node AUTO_OUTPUT_REGISTER $value 
								add_bool_project_assignment "" $group $source $bus_notation_node AUTO_INPUT_REGISTER $value 
								add_bool_project_assignment "" $group $source $bus_notation_node AUTO_OUTPUT_REGISTER $value 
							}
							AUTO_GLOBAL_OE {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment "" $group $source $node AUTO_GLOBAL_OE $value
								add_bool_project_assignment "" $group $source $bus_notation_node AUTO_GLOBAL_OE $value
							}
							AUTO_GLOBAL_PRESET {
								if { [string compare [string toupper $value] "ON"] == 0 } {
									set auto_global_prst ON
									if { [string compare $auto_global_clr "ON"] == 0 } {
										set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
										add_bool_project_assignment "" $group $source $node AUTO_GLOBAL_REG_CTRL ON
										add_bool_project_assignment "" $group $source $bus_notation_node AUTO_GLOBAL_REG_CTRL ON
									} 
								} else { 
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									add_bool_project_assignment "" $group $source $node AUTO_GLOBAL_REG_CTRL OFF
									add_bool_project_assignment "" $group $source $bus_notation_node AUTO_GLOBAL_REG_CTRL OFF
								}
							}
							AUTO_GLOBAL_CLEAR {
								if { [string compare [string toupper $value] "ON"] == 0 } {
									set auto_global_clr ON
									if { [string compare $auto_global_prst "ON"] == 0 } {
										set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
										add_bool_project_assignment "" $group $source $node AUTO_GLOBAL_REG_CTRL ON
										add_bool_project_assignment "" $group $source $bus_notation_node AUTO_GLOBAL_REG_CTRL ON
									}
								} else {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									add_bool_project_assignment "" $group $source $node AUTO_GLOBAL_REG_CTRL OFF
									add_bool_project_assignment "" $group $source $bus_notation_node AUTO_GLOBAL_REG_CTRL OFF
								}
							}
							AUTO_GLOBAL_CLOCK {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								add_bool_project_assignment "" $group $source $node AUTO_GLOBAL_CLOCK $value
								add_bool_project_assignment "" $group $source $bus_notation_node AUTO_GLOBAL_CLOCK $value
							}
							OPTIMIZE_FOR_SPEED {
								if { $value > 5 } {
									set value "SPEED"
								} else {
									set value "AREA"
								}
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								project add_assignment "" $group $source $node OPTIMIZATION_TECHNIQUE_FLEX6K $value
								project add_assignment "" $group $source $node OPTIMIZATION_TECHNIQUE_FLEX10K $value
								project add_assignment "" $group $source $bus_notation_node OPTIMIZATION_TECHNIQUE_FLEX6K $value
								project add_assignment "" $group $source $bus_notation_node OPTIMIZATION_TECHNIQUE_FLEX10K $value
							}
						}
					}
					if { [string compare $do_eda_input "TRUE"] == 0 } {
						switch -exact $variable {
							EDIF_INPUT_USE_LMF1 {
								set value [string toupper $value]
								set edif_use_lmf1 $value
								if { [string compare $value "ON"] == 0 } {
									if { [string compare $edif_lmf_file1 ""] != 0 } {
										if { [string compare $eda_add_lmf "FALSE"] == 0 } {
											project add_assignment "" eda_design_synthesis "" "" EDA_USE_LMF $edif_lmf_file1
											set eda_add_lmf "TRUE"
										} else {
											show_message info "Quartus II can only accept one LMF file. Using the second LMF file $edif_lmf_file2, and ignoring the first LMF file $edif_lmf_file1."
										}
									}
								}
							}
							EDIF_INPUT_LMF1 {
								set edif_lmf_file1 $value
								set upper_value [string toupper $value]

								# from the lmf filename, figure out the synthesis tool used
								if { [string first "EXEMPLAR" $upper_value] != -1 } {
									set eda_synth_tool "LEONARDO SPECTRUM"
								} elseif { [string first "MNT8_BAS" $upper_value] != -1 } {
									set eda_synth_tool "DESIGN ARCHITECT"
								} elseif { [string first "ORC2ALT" $upper_value] != -1 } {
									set eda_synth_tool "CUSTOM"
								} elseif { [string first "ALTSYN" $upper_value] != -1 } {
									set eda_synth_tool "DESIGN COMPILER"
								} elseif { [string first "SYNPLCTY" $upper_value] != -1 } {
									set eda_synth_tool "SYNPLIFY"
								} elseif { [string first "VWL_BAS" $upper_value] != -1 } {
									set eda_synth_tool "VIEWDRAW"
								} elseif { [string compare "" $upper_value] != 0 } {
									if { [file isfile $value] } {
										set eda_synth_tool "CUSTOM"
									} else {
										set edif_lmf_file1 ""
										set value ""
									}
								}

								if { [string compare $edif_use_lmf1 "ON"] == 0 } {
									if { [string compare $value ""] != 0 } {
										if { [string compare $eda_add_lmf "FALSE"] == 0 } {
											project add_assignment "" eda_design_synthesis "" "" EDA_USE_LMF $value
											set eda_add_lmf "TRUE"
										} else {
											show_message info "Quartus II can only accept one LMF file. Using the second LMF file $edif_lmf_file2, and ignoring the first LMF file $edif_lmf_file1."
										}
									}
								}
							}
							EDIF_INPUT_USE_LMF2 {
								set value [string toupper $value]
								set edif_use_lmf2 $value
								if { [string compare $value "ON"] == 0 } {
									if { [string compare $edif_lmf_file2 ""] != 0 } {
										if { [string compare $eda_add_lmf "FALSE"] == 0 } {
											project add_assignment "" eda_design_synthesis "" "" EDA_USE_LMF $edif_lmf_file2
											set eda_add_lmf "TRUE"
										} else {
											show_message info "Quartus II can only accept one LMF file. Using the first LMF file $edif_lmf_file1, and ignoring the second LMF file $edif_lmf_file2."
										}
									}
								}
							}
							EDIF_INPUT_LMF2 {
								set edif_lmf_file2 $value
								if { [string compare $edif_use_lmf2 "ON"] == 0 } {
									if { [string compare $value ""] != 0 } {
										if { [string compare $eda_add_lmf "FALSE"] == 0 } {
											project add_assignment "" eda_design_synthesis "" "" EDA_USE_LMF $value
											set eda_add_lmf "TRUE"
										} else {
											show_message info "Quartus II can only accept one LMF file. Using the first LMF file $edif_lmf_file1, and ignoring the second LMF file $edif_lmf_file2."
										}
									}
								}
							}
							EDIF_INPUT_SHOW_LMF_MAPPING_MESSAGES { add_bool_project_assignment "" eda_design_synthesis "" "" EDA_SHOW_LMF_MAPPING_MSGS $value }
							EDIF_INPUT_VCC { project add_assignment "" eda_design_synthesis "" "" EDA_INPUT_VCC $value }
							EDIF_INPUT_GND { project add_assignment "" eda_design_synthesis "" "" EDA_INPUT_GND $value }
							VHDL_USER_LIB_PHYSICAL_NAMES {
								# to get rid of the double quotes and the semi colon at the end of the name
								set value [string range $value 1 [expr [string length $value] - 1]]

								if { [string compare $vhdl_lib_logical ""] != 0 } {
									project add_assignment "" eda_design_synthesis "" $vhdl_lib_logical EDA_VHDL_LIBRARY $value
									project add_assignment "" "" "" $vhdl_lib_logical VHDL_INPUT_LIBRARY $value
									
									if { [string compare $vhdl_version ""] != 0 } {
										project add_assignment "" "" "" "" VHDL_INPUT_VERSION $vhdl_version
									}
									set vhdl_add_input "TRUE"
								} else {
									set vhdl_lib_physical $value
								}
							}
							VHDL_USER_LIB_LOGICAL_NAMES {
								# to get rid of the double quotes and the semi colon at the end of the name
								set value [string range $value 1 [expr [string length $value] - 1]]

								if { [string compare $vhdl_lib_physical ""] != 0 } {
									project add_assignment "" eda_design_synthesis "" $value EDA_VHDL_LIBRARY $vhdl_lib_physical
									project add_assignment "" "" "" $value VHDL_INPUT_LIBRARY $vhdl_lib_physical
									if { [string compare $vhdl_version ""] != 0 } {
										project add_assignment "" "" "" ""	VHDL_INPUT_VERSION $vhdl_version
									}
									set vhdl_add_input "TRUE"
								} else {
									set vhdl_lib_logical $value
								}
							}
							VHDL_READER_VERSION {
								if { [string compare $vhdl_add_input "TRUE"] == 0 } {
									project add_assignment "" "" "" ""	VHDL_INPUT_VERSION $value
								} else {
									set vhdl_version $value
								}
							}	
						}
						if { [string compare $eda_add_info "FALSE"] == 0 } {
							if { [string compare $eda_add_lmf "TRUE"] == 0 } {
								if { [string compare $eda_synth_tool ""] != 0 } {
									if { [string compare $chip_group ""] != 0 } {
										project add_assignment "" $chip_group "" "" EDA_DESIGN_ENTRY_SYNTHESIS_TOOL $eda_synth_tool
										show_message info "Setting EDA input tool to $eda_synth_tool. To select a different EDA tool, choose the EDA Tool Settings command in the Project menu."
										project add_assignment "" eda_design_synthesis "" "" EDA_DATA_FORMAT EDIF
										set eda_add_info "TRUE"
									}
								}
							} elseif { [string compare $vhdl_add_input "TRUE"] == 0 } {
								if { [string compare $chip_group ""] != 0 } {
									project add_assignment "" $chip_group "" "" EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "CUSTOM"
									show_message info "Settings EDA input tool to CUSTOM. To select a different EDA tool, choose the EDA Tool Settings command in the Project menu."
									project add_assignment "" eda_design_synthesis "" "" EDA_DATA_FORMAT VHDL
									set eda_add_info "TRUE"
								}
							}
						}
					}
					if { [string compare $do_eda_output "TRUE"] == 0 } {
						switch -exact $variable {
							VERILOG_NETLIST_WRITER {
								if { [string compare [string toupper $value] "ON"] == 0 } {
									if { [string compare $eda_output_format ""] == 0 } {
										set eda_output_format "VERILOG"
										project add_assignment "" eda_simulation "" "" EDA_NETLIST_TYPE VERILOG
										project add_assignment "" eda_timing_analysis "" "" EDA_NETLIST_TYPE VERILOG

										if { [string compare $chip_group ""] != 0 } {
											project add_assignment "" $chip_group "" "" EDA_SIMULATION_TOOL "CUSTOM VERILOG HDL"
											project add_assignment "" $chip_group "" "" EDA_TIMING_ANALYSIS_TOOL "CUSTOM VERILOG HDL"
											show_message info "Setting EDA output tool to Custom Verilog HDL. To select a different EDA tool, choose the EDA Tool Settings command in the Project menu."
										}
																				
										if { [string compare $verilog_map_char ""] != 0 } {
											add_bool_project_assignment "" eda_simulation "" "" EDA_MAP_ILLEGAL $verilog_map_char
											add_bool_project_assignment "" eda_timing_analysis "" "" EDA_MAP_ILLEGAL $verilog_map_char
										}
										if { [string compare $verilog_flat_bus ""] != 0 } {
											add_bool_project_assignment "" eda_simulation "" "" EDA_FLATTEN_BUSES $verilog_flat_bus
											add_bool_project_assignment "" eda_timing_analysis "" "" EDA_FLATTEN_BUSES $verilog_flat_bus
										}
										if { [string compare $verilog_trun_hier ""] != 0 } {
											add_bool_project_assignment "" eda_simulation "" "" EDA_TRUNCATE_HPATH $verilog_trun_hier
											add_bool_project_assignment "" eda_timing_analysis "" "" EDA_TRUNCATE_HPATH $verilog_trun_hier
										}		
										if { [string compare $verilog_time_scale ""] != 0 } {
											project add_assignment "" eda_simulation "" "" EDA_TIMESCALE $verilog_time_scale
											project add_assignment "" eda_timing_analysis "" "" EDA_TIMESCALE $verilog_time_scale
										}
												
									} else {
										show_message info "Quartus II can only generate one netlist format at one time. Selecting VHDL output."
									}
								}
							}
							VERILOG_OUTPUT_MAP_ILLEGAL_CHAR {
								if { [string compare $eda_output_format "VERILOG"] == 0 } {
									add_bool_project_assignment "" eda_simulation "" "" EDA_MAP_ILLEGAL $value
									add_bool_project_assignment "" eda_timing_analysis "" "" EDA_MAP_ILLEGAL $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set verilog_map_char $value
								}
							}
							VERILOG_FLATTEN_BUS {
								if { [string compare $eda_output_format "VERILOG"] == 0 } {
									add_bool_project_assignment "" eda_simulation "" "" EDA_FLATTEN_BUSES $value
									add_bool_project_assignment "" eda_timing_analysis "" "" EDA_FLATTEN_BUSES $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set verilog_flat_bus $value
								}
							}
							VERILOG_TRUNCATE_HIERARCHY_PATH {
								if { [string compare $eda_output_format "VERILOG"] == 0 } {
									add_bool_project_assignment "" eda_simulation "" "" EDA_TRUNCATE_HPATH $value
									add_bool_project_assignment "" eda_timing_analysis "" "" EDA_TRUNCATE_HPATH $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set verilog_trun_hier $value
								}
							}
							NETLIST_OUTPUT_TIME_SCALE {
								switch -exact $value {
									0.000001us	{ set value "1 ps" }
									0.00001us	{ set value "10 ps" }
									0.0001us	{ set value "100 ps" }
									0.001us		{ set value "1 ns" }
									0.01us		{ set value "10 ns" }
									0.001ns		{ set value "1 ps" }
									0.01ns		{ set value "10 ps" }
									0.1ns		{ set value "100 ps" }
									1ns			{ set value "1 ns" }
									10ns		{ set value "10 ns" }
								}
								if { [string compare $eda_output_format "VERILOG"] == 0 } {
									project add_assignment "" eda_simulation "" "" EDA_TIMESCALE $value
									project add_assignment "" eda_timing_analysis "" "" EDA_TIMESCALE $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set verilog_time_scale $value
								}
							}
							VHDL_NETLIST_WRITER {
								if { [string compare [string toupper $value] "ON"] == 0 } {	
									if { [string compare $eda_output_format ""] == 0 } {
										set eda_output_format "VHDL"
										project add_assignment "" eda_simulation "" "" EDA_NETLIST_TYPE VHDL
										project add_assignment "" eda_timing_analysis "" "" EDA_NETLIST_TYPE VHDL
									
										if { [string compare $chip_group ""] != 0 } {
											project add_assignment "" $chip_group "" "" EDA_SIMULATION_TOOL "CUSTOM VHDL"
											project add_assignment "" $chip_group "" "" EDA_TIMING_ANALYSIS_TOOL "CUSTOM VHDL"
											show_message info "Setting EDA output tool to Custom VHDL. To select a different EDA tool, choose the EDA Tool Settings command in the Project menu."
										}	
									
										if { [string compare $vhdl_output_version ""] != 0 } {
											add_bool_project_assignment "" eda_simulation "" "" EDA_MAP_ILLEGAL $vhdl_output_version
											add_bool_project_assignment "" eda_timing_analysis "" "" EDA_MAP_ILLEGAL $vhdl_output_version
										}
										if { [string compare $vhdl_config_decl ""] != 0 } {
											add_bool_project_assignment "" eda_simulation "" "" EDA_WRITE_CONFIG $vhdl_config_decl
											add_bool_project_assignment "" eda_timing_analysis "" "" EDA_WRITE_CONFIG $vhdl_config_decl
										}
										if { [string compare $vhdl_trun_hier ""] != 0 } {
											add_bool_project_assignment "" eda_simulation "" "" EDA_TRUNCATE_HPATH $vhdl_trun_hier
											add_bool_project_assignment "" eda_timing_analysis "" "" EDA_TRUNCATE_HPATH $vhdl_trun_hier
										}
										if { [string compare $vhdl_flat_bus ""] != 0 } {
											add_bool_project_assignment "" eda_simulation "" "" EDA_FLATTEN_BUSES $vhdl_flat_bus
											add_bool_project_assignment "" eda_timing_analysis "" "" EDA_FLATTEN_BUSES $vhdl_flat_bus
										}
									
									} else {
										show_message info "Quartus II can only generate one netlist format at one time. Selecting VERILOG format."
									}
								}
							}
							VHDL_WRITER_VERSION {
								if { [string compare [string toupper $value] "VHDL87"] == 0 } {
									if { [string compare $eda_output_format "VHDL"] == 0 } {
										add_bool_project_assignment "" eda_simulation "" "" EDA_MAP_ILLEGAL ON
										add_bool_project_assignment "" eda_timing_analysis "" "" EDA_MAP_ILLEGAL ON
									} elseif { [string compare $eda_output_format ""] == 0 } {
										set vhdl_output_version "ON"
									}
								}
							}
							VHDL_GENERATE_CONFIGURATION_DECLARATION {
								if { [string compare $eda_output_format "VHDL"] == 0 } {
									add_bool_project_assignment "" eda_simulation "" "" EDA_WRITE_CONFIG $value
									add_bool_project_assignment "" eda_timing_analysis "" "" EDA_WRITE_CONFIG $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set vhdl_config_decl $value
								}
							}
							VHDL_TRUNCATE_HIERARCHY_PATH {
								if { [string compare $eda_output_format "VHDL"] == 0 } {
									add_bool_project_assignment "" eda_simulation "" "" EDA_TRUNCATE_HPATH $value
									add_bool_project_assignment "" eda_timing_analysis "" "" EDA_TRUNCATE_HPATH $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set vhdl_trun_hier $value
								}
							}
							VHDL_FLATTEN_BUS {	
								if { [string compare $eda_output_format "VHDL"] == 0 } {
									add_bool_project_assignment "" eda_simulation "" "" EDA_FLATTEN_BUSES $value
									add_bool_project_assignment "" eda_timing_analysis "" "" EDA_FLATTEN_BUSES $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set vhdl_flat_bus $value
								}
							}
							EDIF_NETLIST_WRITER {
								if { [string compare [string toupper $value] "ON"] == 0 } {
									show_message info "Quartus II cannot generate EDIF files. Only Verilog or VHDL formats can be generated."
								}
							}
						}
					}							 
					} 
				}
			}
		} elseif { [string length $line] != 0 } {
			set section ""
			set group ""
			scan $line { %s%s } section group
			set section
			set group
			if { [string compare $section "CHIP"] == 0 } {
				if { [string compare $do_chip "TRUE"] == 0 } {
					if { [string compare $chip_group ""] != 0 } {
						if { [string compare $chip_group $group] != 0 } {
							if { [string compare $first_multichip_warning "TRUE"] == 0 } {
								show_message info "Multiple CHIP sections found, but Quartus II does not support multidevice partitioning. Will import assignments in the CHIP $chip_group section and ignore the rest of the CHIP sections."
								set do_chip "FALSE"
								set first_multichip_warning "FALSE"
							}
						} 
					} else {
						if { [project cmp_exists $group] == 1 } {
							set chip_group $group
							project set_active_cmp $chip_group
						} else {
							if { [string compare $first_multichip_warning "TRUE"] == 0 } {
								show_message warning "The CHIP name ($group) found in $entity.acf does not match any of the project's Compiler Settings name. Will NOT import any device options or chip/location/pin assignments."
								set do_chip "FALSE"
								set do_device_opt "FALSE"
							}
						}
					}
				}
			}
			if { [string compare $prj_cmp_batch "PRJ"] == 0 } {
				project end_batch $entity
				set prj_cmp_batch ""
			} elseif { [string compare $prj_cmp_batch "CMP"] == 0 } {
				cmp end_batch
				set prj_cmp_batch ""
			}

			#	skip unsupported/de-selected sections
			switch -exact $section {
				CLIQUE {
					if { [string compare $do_clique "FALSE"] == 0 } {
						skip_until $file $stop
					} else {
						set prj_cmp_batch "PRJ"
						project start_batch $entity
					}
				}
				COMPILER_INTERFACES_CONFIGURATION { 
					if { [string compare $do_eda_input "FALSE"] == 0 } {
						if { [string compare $do_eda_output "FALSE"] == 0 } {
							skip_until $file $stop 
						}
					}
				}
				COMPILER_PROCESSING_CONFIGURATION { 
					if { [string compare $do_cmp_proc_cfg "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
				CONNECTED_PINS { skip_until $file $stop }
				CUSTOM_DESIGN_DOCTOR_RULES { skip_until $file $stop }
				GLOBAL_PROJECT_DEVICE_OPTIONS {
					if { [string compare $do_device_opt "FALSE"] == 0 } {
						skip_until $file $stop
					} else {
						set prj_cmp_batch "CMP"
						cmp start_batch
					}
				}
				GLOBAL_PARAMETERS {
					if { [string compare $do_param "FALSE"] == 0 } {
						skip_until $file $stop
					} 
				}
				#IGNORED_ASSIGNMENTS { 
				#	if { [string compare $do_ignore "FALSE"] == 0 } {
				#		skip_until $file $stop
				#	} else {
				#		set prj_cmp_batch "CMP"
				#		cmp start_batch
				#	}
				#}
				INTERNAL_INFO { skip_until $file $stop }
				LOCAL_ROUTING {
					if { [string compare $do_local_rout "FALSE"] == 0 } {
						skip_until $file $stop
					} else {
						set prj_cmp_batch "PRJ"
						project start_batch $entity
					}
				}
				LOGIC_OPTIONS {
					if { [string compare $do_logic_opt "FALSE"] == 0 } {
						skip_until $file $stop
					} else {
						set prj_cmp_batch "PRJ"
						project start_batch $entity
					}
				}
				DEFINE_LOGIC_SYNTHESIS_STYLE { skip_until $file $stop }
				OTHER_CONFIGURATION { 
					if { [string compare $cur_family "FLEX10K"] != 0 } {
						skip_until $file $stop 
					}
				}
				CHIP {
					if { [string compare $do_chip "FALSE"] == 0 } {
						skip_until $file $stop
					} else {
						set prj_cmp_batch "CMP"
						cmp start_batch
					}
				}
				PROBES { skip_until $file $stop }
				SIMULATOR_CONFIGURATION { 
					if { [string compare $do_sim "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
				TIMING_ANALYZER_CONFIGURATION { 
					if { [string compare $do_tan "FALSE"] == 0 } {
						skip_until $file $stop 
					} 
				}
				TIMING_POINT {
					if { [string compare $do_tim_req "FALSE"] == 0 } {
						skip_until $file $stop
					} else {
						set prj_cmp_batch "PRJ"
						project start_batch $entity
					}
				}
			}
		}

	}
	# end batch modes before exiting procedure
	if { [string compare $prj_cmp_batch "PRJ"] == 0 } {
		project end_batch $entity
		set prj_cmp_batch ""
	} elseif { [string compare $prj_cmp_batch ""] == 0 } {
		 cmp start_batch
		 set prj_cmp_batch "CMP"
	}

	# before closing file, check if any assignments have not been added & add them
	if [info exists location_list] {
		cmp add_locations $chip_group $location_list [llength $location_list]
	}
	if { [string compare $cur_family "FLEX6K"] != 0 } {
		if [info exists column_list] {
			cmp add_locations $chip_group $column_list [llength $column_list]
		}
	} else {
		if [info exists column_list] {
			show_message info "Column location assignments are not supported for FLEX 6000 devices. Will not import column location assignments."
		}
	}
	if { [string compare $prj_cmp_batch "CMP"] == 0 } {
		cmp end_batch
	}
	} else {
	while { [gets $file line] >= 0 } {

		#	check for empty line and comments
		if { [string length $line] == 0 } {
			continue
		} elseif { [string first "--" $line] != -1 } {
			set line [process_single $line]
		} elseif { [string first "/*" $line] != -1 } {
			set line [process_multi_start $line]
		} elseif { [string first "*/" $line] != -1 } {
			set line [process_multi_stop $line]
		} elseif { $comment_flag == 1 } {
			set line ""
		}

		if { [string compare [string toupper $line] $start] == 0 } {
			while { [gets $file line] >= 0 } {

				#	check for empty line and comments
				if { [string length $line] == 0 } {
					continue
				} elseif { [string first "--" $line] != -1 } {
					set line [process_single $line]
				} elseif { [string first "/*" $line] != -1 } {
					set line [process_multi_start $line]
				} elseif { [string first "*/" $line] != -1 } {
					set line [process_multi_stop $line]
				} elseif { $comment_flag == 1 } {
					set line ""
				}

				if { [string compare [string toupper $line] $stop] == 0 } {
					break
				} elseif { [string length $line] != 0 } {
					
					set no_array "FALSE"
					#	extract assignment
					set node ""
					set variable ""
					set value ""
					set source ""
					if { [string first " :" $line] == -1 } {
						scan $line { %[^{ ;}] = %[^{ ;}] %[^{ ;}] }  variable value source
					} else {
						scan $line { %s : %[^{ ;}] = %[^{ ;}] %[^{ ;}] }  node variable value source
						set node
					}
					set variable
					set value
					set source
					set orig_node $node
					#	skip assignment with empty string value
					if { [string compare $value "\"\""] == 0 } {
						continue
					}
					if { [string first "{edif}" $line] != -1 } {
						set no_array "TRUE"
					}

					#	to remove {}
				#	set source [ string trim [ string range $source 1 [ expr [ string length $source ] - 2 ] ] ]

					#	to ignore synthesis generated name
					if {[string first "~" $node] != -1} {
						if { [lsearch $ignore_node_list $node] == -1 } {
							lappend ignore_node_list $node
						}
						continue
					}

					#	to change |node to node
					if { [string first "|" $node] == 0 } {
						set node [string range $node 1 end]
					} elseif { [string first "\"|:" $node] == 0 } {
						if { [string compare FREQUENCY $variable] != 0 } {
							set node [string range $node 3 [expr [string length $node] - 2]]
						}
					} elseif { [string first "\"|" $node] == 0 } {
						set node [string range $node 2 [expr [string length $node] - 2]]
					} elseif { [string first "\"" $node] == 0 } {
						set node [string range $node 1 [expr [string length $node] - 2]]
					}

					# to remove the ":" from the string "*|:*"
					set node [string map { |: | } $node]

					####################################################################################################
					#	to change node* to node[*] or node*_* to node[*][*] 

					set do_bus_warn_msg ""
					set bus_notation_node $node
					if { [string compare $no_array "FALSE"] == 0 } {
						set dump ""
						set convert_node ""
						set temp $node
						set acf_node_name $temp
						set unsc_cnt 0
                        set do_bus "FALSE"
						set has_do_bus 0

						while { [string length $temp] > 0 } {
							set do_bus "TRUE"
							set char ""
							set num ""
							scan $temp { %[0-9] } num
							set num
							set extra_char ""

							if { $num == "" } {
								scan $temp { %[^{0-9}]%[0-9]%[:~_a-zA-Z0-9]$ } char num extra_char
								set char
								set num
							} else {
								set do_bus "FALSE"
							}
							set dump $dump$char$num
							set temp [ string range $node [string length $dump] end ]

							# Specific cases where the number should not be converted to an array format
							if { [string length $num] == [string length $node] } {
								set do_bus "FALSE"
							}
							if { $num == "" } {
								set do_bus "FALSE"
							}
							if { $num != "" } {
								set first_char [string index $temp 0]
								if { [string match {[a-zA-Z]} $first_char] == 1 } {
									set do_bus "FALSE"			
								}
								set second_char [string index $temp 1]
								if { [string compare "_" $first_char] == 0 } {
									if { [string match {[a-zA-Z]} $second_char] == 1 } {
										set do_bus "FALSE"
									}
								}
								
								#spr89101
								if { $extra_char != ""} {
									set first_char [string range $extra_char 0 0]
									if { [string compare "_" $first_char] == 0 } {
										if { [string length $extra_char] == 1 } {
											set do_bus "FALSE"
										}
										set extra_char [string range $extra_char  1  end]
										if { ![string is integer $extra_char] } {
											if { [string first "_" $extra_char] == -1 }  {
												set do_bus "FALSE"
											}
										}
										if { $extra_char != "" } {
											if { [string first "_" $extra_char] != -1} {
												if { [string is integer [string range $extra_char 0 [expr [string first "_" $extra_char] -1 ] ] ] } {
													set do_bus "TRUE"
												} else {
													set do_bus "FALSE"
												}
												set extra_char [string range $extra_char [expr [string first "_" $extra_char] + 1]  end]
												if { $extra_char != "" } {
													if { ![string is integer $extra_char] } {
														set do_bus "FALSE"
													}
												} else {
													set do_bus "FALSE"
												}
											}
										}
									}
									if { [string compare "~" $first_char] == 0 } {
										set do_bus "FALSE"
									}
									if { [string compare ":" $first_char] == 0 } {
										set do_bus "FALSE"
									}
								}
							}
							if { $char != "" } {
								set last_char [ string range $char [expr [string length $char] - 1 ] end ]
								if { [string compare ":" $last_char] == 0 } {
									set pen_char [ string index $char [expr [string length $char] - 2] ]
									if { [string compare "|" $pen_char] == 0} {
										if { [string compare FREQUENCY $variable] != 0 } {
											set char [string range $char 0 [expr [string length $char] - 2] ]
										}
									}
									set do_bus "FALSE"
								}
								if { [string compare "|" $last_char] == 0 } {
									set do_bus "FALSE"
								}
								if { [string compare "~" $last_char] == 0 } {
									set do_bus "FALSE"
								}
								if { [string compare "\[" $last_char] == 0 } {
									set do_bus "FALSE"
								}
								if { [string compare "_" $char] == 0 } {
									set char ""
									set unsc_cnt [expr $unsc_cnt + 1]
									if { [string compare "FALSE" $do_bus] == 0} {
										set unsc_cnt 0
										set char "_"
									}
									
								}
								if { [string compare "~" $char] == 0 } {
									set do_bus "FALSE"
									set unsc_cnt 0
								}
								if { [string length $extra_char] > 0 } {
									if  { [string compare "_" $last_char] == 0 } {
										set str_len [string length $char]
										if { $str_len != "0" } {
											set prev_char [string range $char 0 [expr $str_len - 1] ]
											if { [string last "_" $prev_char] != -1 } {
												if { [string length $prev_char] > 0 } {
													set prev_char [string range $prev_char 0 [string last "_" $prev_char] ]
													if { $prev_char != ""} {
														set ind  [string length $prev_char]
														if { $ind != 0 } {
															set last_char [string range $prev_char [expr $ind - 1] end]
															if { ![string is integer $last_char] } {
																set do_bus "FALSE"
															}
														}
													}
												} 
											}
										} 
									}
								}
							}

							# Do conversion to bus format
							if { [string compare "TRUE" $do_bus] == 0 } {
								set acf_node_name $convert_node$char$num
								set convert_node "$convert_node$char\[$num\]"
								set has_do_bus 1
							} else {
								set convert_node $convert_node$char$num
							}
						}

						# There can be, at most, 2-dimensional buses, if more, then a number has been misconverted to a bus
						# type notation
						while { [string first "\]\[" $convert_node] != [string last "\]\[" $convert_node] } {
							set index1 [string first "\[" $convert_node ]
							set index2 [string first "\]" $convert_node ]
							set str_tmp1 [string range $convert_node 0 [expr $index1 - 1] ]
							set str_tmp2 [string range $convert_node [expr $index1 + 1] [expr $index2 - 1]]
							set str_tmp3 [string range $convert_node [expr $index2 + 1] end]
							if { $unsc_cnt > 1 } {
								set convert_node "$str_tmp1$str_tmp2\_$str_tmp3"
							} else {
								set convert_node $str_tmp1$str_tmp2$str_tmp3
							}
						}
						if { [string compare $has_do_bus 1] == 0 } {
							#spr91834
							if { [string compare $acf_node_name ""] != 0 } {
								if { [string compare $convert_node ""] != 0 } {
									set do_bus_warn_msg "1"
								}
							}
						}
						set bus_notation_node $convert_node
					}

					#######################################################################################################
					#	start importing variables

					#	parameters
					if { [string compare "GLOBAL_PARAMETERS" $section] == 0 } {
						set_parameter -name $variable $value
					} else {

					switch -exact $variable {	
						BEST_CLIQUE {
							if { [string compare "FALSE" [synth_text_hier_name $node]] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_global $entity $group CLIQUE_TYPE_FLEX6K BEST
								set_instance $entity $group "" $node MEMBER_OF $group
								set_instance $entity $group "" $bus_notation_node MEMBER_OF $group
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
							
						}
						LAB_CLIQUE {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $cur_family "FLEX6K"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_global $entity $group CLIQUE_TYPE_FLEX6K LAB
								set_instance $entity $group "" $node MEMBER_OF $group
								set_instance $entity $group "" $bus_notation_node MEMBER_OF $group
							} elseif { [string compare $cur_family "MAX7000B"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_global $entity $group CLIQUE_TYPE_MAX7K LAB
								set_instance $entity $group "" $node MEMBER_OF $group
								set_instance $entity $group "" $bus_notation_node MEMBER_OF $group
							} elseif { [string compare $cur_family "MAX7000AE"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_global $entity $group CLIQUE_TYPE_MAX7K LAB
								set_instance $entity $group "" $node MEMBER_OF $group
								set_instance $entity $group "" $bus_notation_node MEMBER_OF $group
							} elseif { [string compare $cur_family "MAX3000A"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_global $entity $group  CLIQUE_TYPE_MAX7K LAB
								set_instance $entity $group "" $node MEMBER_OF $group
								set_instance $entity $group "" $bus_notation_node MEMBER_OF $group
							} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
 								set_global$entity $group  CLIQUE_TYPE_MAX7K LAB
								set_instance $entity $group "" $node MEMBER_OF $group
								set_instance $entity $group "" $bus_notation_node MEMBER_OF $group
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						ROW_CLIQUE {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_global $entity $group CLIQUE_TYPE_FLEX6K ROW
								set_instance $entity $group "" $node MEMBER_OF $group
								set_instance $entity $group "" $bus_notation_node MEMBER_OF $group
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CLIQUE {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								if { [string compare $cur_family "FLEX6K"] == 0} {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									set_global $entity $group CLIQUE_TYPE_FLEX6K BEST
									set_instance $entity $group "" $node MEMBER_OF $group
									set_instance $entity $group "" $bus_notation_node MEMBER_OF $group
								} elseif { [string compare $cur_family "MAX7000B"] == 0 } {
									show_message info "Quartus II does not support clique assignments for MAX7000B/7000AE/3000A/MAX7000S devices. Will not import any clique assignments found in $entity.acf."
								} elseif { [string compare $cur_family "MAX7000AE"] == 0 } {
									show_message info "Quartus II does not support clique assignments for MAX7000B/7000AE/3000A/MAX7000S devices. Will not import any clique assignments found in $entity.acf."
								} elseif { [string compare $cur_family "MAX3000A"] == 0 } {
									show_message info "Quartus II does not support clique assignments for MAX7000B/7000AE/3000A/MAX7000S devices. Will not import any clique assignments found in $entity.acf."
								} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
									show_message info "Quartus II does not support clique assignments for MAX7000B/7000AE/3000A/MAX7000S devices. Will not import any clique assignments found in $entity.acf."								
								}
                            } else {
                            	show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
	                        }
						}
						DEVICE_FAMILY { 
							set_global "" "" FAMILY $family_name
						}
						INCREASE_INPUT_DELAY {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set value [string toupper $value] 
							if { [string compare $value "ON"] == 0 } {
								set value OFF
							} else {
 								set value ON
							}
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							set_bool_instance $entity $group $source $node DELAY_SETTING_TO_CORE_FLEX6K $value
							set_bool_instance $entity $group $source $node DELAY_SETTING_TO_CORE_FLEX10K $value
							set_bool_instance $entity $group $source $bus_notation_node DELAY_SETTING_TO_CORE_FLEX6K $value
							set_bool_instance $entity $group $source $bus_notation_node DELAY_SETTING_TO_CORE_FLEX10K $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CLKLOCKX1_INPUT_FREQ { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set value ${value}MHZ
								set_instance $entity $group $source $node X1_PLL_FREQUENCY $value
								set_instance $entity $group $source $bus_notation_node X1_PLL_FREQUENCY $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						INPUT_REFERENCE { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set value [string toupper $value]
							if { [string compare $value "VREFA"] == 0 } {
								set value {AS VREFA}
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_instance $entity "" "" $node INPUT_REFERENCE $value
								set_instance $entity "" "" $bus_notation_node INPUT_REFERENCE $value
							} elseif { [string compare $value "VREFB"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set value {AS VREFB}
								set_instance $entity "" "" $node INPUT_REFERENCE $value
								set_instance $entity "" "" $bus_notation_node INPUT_REFERENCE $value
							}
				        	} else {
				        		show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
					        }
						}

						IO_STANDARD { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set correct_value [get_correct_value $value]
								set_instance "" $chip_group $source $node IO_STANDARD $correct_value 
								set_instance "" $chip_group $source $bus_notation_node IO_STANDARD $correct_value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						INSERT_ADDITIONAL_LOGIC_CELL { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity "" "" $node INSERT_ADDITIONAL_LOGIC_CELL $value 
								set_bool_instance $entity "" "" $bus_notation_node INSERT_ADDITIONAL_LOGIC_CELL $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						NORMAL_LCELL_INSERT {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $section "OTHER_CONFIGURATION" ] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node AUTO_LCELL_INSERTION $value
								set_bool_instance $entity $group $source $bus_notation_node AUTO_LCELL_INSERTION $value
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}

						PARALLEL_EXPANDERS { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									set_bool_instance $entity $group $source $node AUTO_PARALLEL_EXPANDERS $value
									set_bool_instance $entity $group $source $bus_notation_node AUTO_PARALLEL_EXPANDERS $value
								}
                           } else {
	                           show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
                           }
						}
										
						ENABLE_BUS_HOLD { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity "" "" $node ENABLE_BUS_HOLD_CIRCUITRY $value
								set_bool_instance $entity "" "" $bus_notation_node ENABLE_BUS_HOLD_CIRCUITRY $value
							}
						    } else {
							    show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
						    }
						}
						
						POWER_UP_HIGH { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
									set_instance $entity "" "" $node POWER_UP_LEVEL $value 
								}
	                        } else {
		                        show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
	                        }
						}
						
                        TURBO_BIT { 
	                        if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $section "CHIP"] == 0 } {
								if { [string compare $cur_family "MAX7000B"] == 0 } {
									set_bool_global "" "" AUTO_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX7000AE"] == 0 } {
									set_bool_global "" "" AUTO_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX3000A"] == 0 } {
									set_bool_global "" "" AUTO_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
									set_bool_global "" "" AUTO_TURBO_BIT $value
								} else {
									set_bool_global "" "" TURBO_BIT $value 
								}
							} elseif { [string compare $section "LOGIC_OPTIONS"] == 0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								if { [string compare $cur_family "MAX7000B"] == 0 } {
									set_bool_instance $entity "" "" $node MAX7000_INDIVIDUAL_TURBO_BIT $value
									set_bool_instance $entity "" "" $bus_notation_node MAX7000_INDIVIDUAL_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX7000AE"] == 0 } {
									set_bool_instance $entity "" "" $node MAX7000_INDIVIDUAL_TURBO_BIT $value
									set_bool_instance $entity "" "" $bus_notation_node MAX7000_INDIVIDUAL_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX3000A"] == 0 } {
									set_bool_instance $entity "" "" $node MAX7000_INDIVIDUAL_TURBO_BIT $value
									set_bool_instance $entity "" "" $bus_notation_node MAX7000_INDIVIDUAL_TURBO_BIT $value
								} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
									set_bool_instance $entity "" "" $node MAX7000_INDIVIDUAL_TURBO_BIT $value
									set_bool_instance $entity "" "" $bus_notation_node MAX7000_INDIVIDUAL_TURBO_BIT $value
								} else {
									set_bool_instance $entity "" "" $node TURBO_BIT $value
									set_bool_instance $entity "" "" $bus_notation_node TURBO_BIT $value
								}
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
                                                
						XOR_SYNTHESIS { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									set_bool_instance $entity $group $source $node XOR_SYNTHESIS $value 
									set_bool_instance $entity $group $source $bus_notation_node XOR_SYNTHESIS $value
								}
	                        } else {
		                        show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
	                        }
						}

						ENABLE_PULLUP_RESISTOR { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								if { [string compare $section "LOGIC_OPTIONS"] == 0 } {
									set_bool_instance $entity $group $source $node WEAK_PULL_UP_RESISTOR $value 
								}
	                        } else {
	                        	show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
		                    }
                                                }
						

						CARRY_CHAIN_LENGTH { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_instance $entity $group $source $node CARRY_CHAIN_LENGTH $value 
								set_instance $entity $group $source $bus_notation_node CARRY_CHAIN_LENGTH $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CASCADE_CHAIN_LENGTH {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_instance $entity $group $source $node CASCADE_CHAIN_LENGTH $value 
								set_instance $entity $group $source $bus_notation_node CASCADE_CHAIN_LENGTH $value 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						REGISTER_OPTIMIZATION { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node DUP_REG_EXTRACTION $value 
								set_bool_instance $entity $group $source $bus_notation_node DUP_REG_EXTRACTION $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						NOT_GATE_PUSH_BACK { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node NOT_GATE_PUSH_BACK $value 
								set_bool_instance $entity $group $source $bus_notation_node NOT_GATE_PUSH_BACK $value 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						ONE_HOT_STATE_MACHINE_ENCODING { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare $section "GLOBAL_PROJECT_SYNTHESIS_ASSIGNMENT_OPTIONS"] == 0 } {
							     set value [string toupper $value]
							     if { [string compare $value "ON"] == 0 } {
									set value ONE-HOT
									set_instance "" $group $source "" STATE_MACHINE_PROCESSING $value
							     } else {
                                    set value AUTO                 
									set_instance "" $group $source "" STATE_MACHINE_PROCESSING $value
                                 } 		
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						DUPLICATE_LOGIC_EXTRACTION { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node DUP_LOGIC_EXTRACTION $value 
								set_bool_instance $entity $group $source $bus_notation_node DUP_LOGIC_EXTRACTION $value 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CARRY_CHAIN	{
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							if { [string compare [string toupper $value] "IGNORE"] == 0 } {
								set_bool_instance $entity $group $source $node IGNORE_CARRY ON
								set_bool_instance $entity $group $source $node AUTO_CARRY OFF
								set_bool_instance $entity $group $source $bus_notation_node IGNORE_CARRY ON
								set_bool_instance $entity $group $source $bus_notation_node AUTO_CARRY OFF
							} else {
								set_bool_instance $entity $group $source $node AUTO_CARRY ON
								set_bool_instance $entity $group $source $node IGNORE_CARRY OFF
								set_bool_instance $entity $group $source $bus_notation_node AUTO_CARRY ON
								set_bool_instance $entity $group $source $bus_notation_node IGNORE_CARRY OFF
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						CASCADE_CHAIN {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							if { [string compare [string toupper $value] "AUTO"] == 0 } {
								set_bool_instance $entity $group $source $node AUTO_CASCADE ON
								set_bool_instance $entity $group $source $node IGNORE_CASCADE OFF
								set_bool_instance $entity $group $source $bus_notation_node AUTO_CASCADE ON
								set_bool_instance $entity $group $source $bus_notation_node IGNORE_CASCADE OFF
							} elseif { [string compare [string toupper $value] "IGNORE"] == 0 } {
								set_bool_instance $entity $group $source $node IGNORE_CASCADE ON
								set_bool_instance $entity $group $source $node AUTO_CASCADE OFF
								set_bool_instance $entity $group $source $bus_notation_node IGNORE_CASCADE ON
								set_bool_instance $entity $group $source $bus_notation_node AUTO_CASCADE OFF
							} else {
								set_bool_instance $entity $group $source $node IGNORE_CASCADE OFF
								set_bool_instance $entity $group $source $node AUTO_CASCADE OFF
								set_bool_instance $entity $group $source $bus_notation_node IGNORE_CASCADE OFF
								set_bool_instance $entity $group $source $bus_notation_node AUTO_CASCADE OFF
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						IMPLEMENT_IN_EAB { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							if { [string compare [string toupper $value] "ON"] ==  0 } {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_instance $entity $group $source $node TECH_MAPPER_FLEX10K ROM
								set_instance $entity $group $source $bus_notation_node TECH_MAPPER_FLEX10K ROM
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						PCI_IO { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node PCI_IO $value 
								set_bool_instance $entity $group $source $bus_notation_node PCI_IO $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
						}
						}
						GLOBAL_SIGNAL { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node GLOBAL $value 
								set_bool_instance $entity $group $source $bus_notation_node GLOBAL $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						IMPLEMENT_AS_OUTPUT_OF_LOGIC_CELL { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node IMPLEMENT_AS_LCELL $value 
								set_bool_instance $entity $group $source $bus_notation_node IMPLEMENT_AS_LCELL $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						HIERARCHICAL_SYNTHESIS { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							if { [string compare [string toupper $value] "ON"] == 0 } {
								set_instance $entity $group $source $node HIERARCHICAL_COMPILE RELAXED
								set_instance $entity $group $source $bus_notation_node HIERARCHICAL_COMPILE RELAXED
							} else {
								set_instance $entity $group $source $node HIERARCHICAL_COMPILE OFF
								set_instance $entity $group $source $bus_notation_node HIERARCHICAL_COMPILE OFF
							}
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}							 					
						FAST_IO { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node OUTPUT_REGISTER $value
								set_bool_instance $entity $group $source $node INPUT_REGISTER $value
								set_bool_instance $entity $group $source $bus_notation_node OUTPUT_REGISTER $value
								set_bool_instance $entity $group $source $bus_notation_node INPUT_REGISTER $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						IO_CELL_REGISTER {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node OUTPUT_REGISTER $value
								set_bool_instance $entity $group $source $node INPUT_REGISTER $value
								set_bool_instance $entity $group $source $bus_notation_node OUTPUT_REGISTER $value
								set_bool_instance $entity $group $source $bus_notation_node INPUT_REGISTER $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						IGNORE_SOFT_BUFFERS { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node IGNORE_SOFT $value 
								set_bool_instance $entity $group $source $bus_notation_node IGNORE_SOFT $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						SLOW_SLEW_RATE { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node SLOW_SLEW_RATE $value 
								set_bool_instance $entity $group $source $bus_notation_node SLOW_SLEW_RATE $value 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
						}
						}
						
						DEVICE {
							#node name does not require checking for invalid synthesized symbol ~
							set_global "" "" DEVICE $device_name
						}
						
						CHECK_OUTPUTS { 
							#node name does not require checking for invalid synthesized symbol ~
							set_bool_global "" $group CHECK_OUTPUTS $value 
						}
						
						SETUP_HOLD { 
							#node name does not require checking for invalid synthesized symbol ~
							set_bool_global "" $group SETUP_HOLD_DETECTION $value 
						}
						
						SIMULATION_INPUT_FILE { 
							set_global "" $group VECTOR_FILE $value
						}
						
						END_TIME { 
							#node name does not require checking for invalid synthesized symbol ~
							set_global "" $group END_TIME $value 
						}
						
						START_TIME { 
							#node name does not require checking for invalid synthesized symbol ~
							set_global "" $group START_TIME $value
						}
						GLITCH_TIME { 
							#node name does not require checking for invalid synthesized symbol ~
							set_global "" $group GLITCH_DETECTION_PULSE $value 
						}
						GLITCH { 
							#node name does not require checking for invalid synthesized symbol ~
							set_bool_global "" $group GLITCH_DETECTION $value 
						}
						LIST_PATH_FREQUENCY { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare NUMBER_OF_PATHS $registered_performance_options] != 0 } {
								set_global "" $group INCLUDE_PATHS_LESS_THAN_FMAX $value
							}
						}
						LIST_PATH_COUNT { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare FREQUENCY_OF_PATHS $registered_performance_options] != 0 } {
								set_global "" $group SOURCES_PER_DESTINATION_INCLUDE_COUNT $value
							}
						}
						REGISTERED_PERFORMANCE_OPTIONS {
							set registered_performance_options $value
							if { [string compare FREQUENCY_OF_PATHS $value] == 0 } {
								remove_global "" $group SOURCES_PER_DESTINATION_INCLUDE_COUNT
							} elseif { [string compare NUMBER_OF_PATHS $value] == 0 } {
								remove_global "" $group INCLUDE_PATHS_LESS_THAN_FMAX
							}
						}
						INCLUDE_PATHS_GREATER_THAN_VALUE { 
							#node name does not require checking for invalid synthesized symbol ~
							set_global "" $group INCLUDE_PATHS_GREATER_THAN_TPD $value 
						}
						CUT_OFF_CLEAR_AND_PRESET_PATHS { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare $tim_req_cut_clear "FALSE"] == 0 } {
								set_bool_global "" $group CUT_OFF_CLEAR_AND_PRESET_PATHS $value
							}
						}
						CUT_OFF_IO_PIN_FEEDBACK { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare $tim_req_cut_io "FALSE"] == 0 } {
								set_bool_global "" $group CUT_OFF_IO_PIN_FEEDBACK $value
							}
						}
						CUT_OFF_RAM_REGISTERED_WE_PATHS { 
							#node name does not require checking for invalid synthesized symbol ~
							set_bool_global "" $group CUT_OFF_READ_DURING_WRITE_PATH $value 
						}
						CUT_ALL_BIDIR { 
							#node name does not require checking for invalid synthesized symbol ~
							set tim_req_cut_io "TRUE"
							set_bool_global "" $group CUT_OFF_IO_PIN_FEEDBACK $value 
						}
						CUT_ALL_CLEAR_PRESET { 
							#node name does not require checking for invalid synthesized symbol ~
							set tim_req_cut_clear "TRUE"
							set_bool_global "" $group CUT_OFF_CLEAR_AND_PRESET_PATHS $value
						}
						TPD {
							if { [string compare "\"\"" $value] != 0 } {
								if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									if { [string compare $node ""] == 0 } {
										set_instance "" $group $source $node TPD_REQUIREMENT $value
									} else {
										set_instance $entity $group $source $node TPD_REQUIREMENT $value
										set_instance $entity $group $source $bus_notation_node TPD_REQUIREMENT $value
									}
								} else {
									show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
								}
							}
						}
						TCO {
							if { [string compare "\"\"" $value] != 0 } {
								if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									if { [string compare $node ""] == 0 } {
										set_instance "" $group $source $node TCO_REQUIREMENT $value
									} else {
										set_instance $entity $group $source $node TCO_REQUIREMENT $value
										set_instance $entity $group $source $bus_notation_node TCO_REQUIREMENT $value
									}
								} else {
									show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
								}
							}
						}
						TSU {
							if { [string compare "\"\"" $value] != 0 } {
								if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									if { [string compare $node ""] == 0 } {
										set_instance "" $group $source $node TSU_REQUIREMENT $value
									} else {
										set_instance $entity $group $source $node TSU_REQUIREMENT $value
										set_instance $entity $group $source $bus_notation_node TSU_REQUIREMENT $value
									}
								} else {
									show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
								}
							}
						}
						FREQUENCY { 
							if { [string compare "\"\"" $value] != 0 } {
								if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
									if { [string compare $node ""] == 0 } {
										set_global "" $group REQUIRED_FMAX $value
									} else {
										if { [string first "|" $node] == -1 } {
											if { [string first ":" $node] == -1 } {
												set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
												set_global "" $node BASE_CLOCK $node
												set_global "" $node REQUIRED_FMAX $value
												set_instance $entity "" "" $node USE_CLOCK $node
												set_global "" $bus_notation_node BASE_CLOCK $bus_notation_node
												set_global "" $bus_notation_node REQUIRED_FMAX $value
												set_instance $entity "" "" $bus_notation_node USE_CLOCK $bus_notation_node
											} else {
												show_message info "Fmax assignment to any logic function (e.g a register or a node) other than a pin will not be imported. Will ignore the assignment $node : FREQUENCY = $value"
											}
										} else {
											show_message info "Fmax assignment to any logic function (e.g a register or a node) other than a pin will not be imported. Will ignore the assignment $node : FREQUENCY = $value"
										}
									}
								} else {
									show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
								}
							}
						}
						CUT { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group "*" $node CUT $value
								set_bool_instance $entity $group "*" $bus_notation_node CUT $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						SMART_RECOMPILE { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare [string toupper $value] "ON"] == 0 } {
								set_global "" $group SPEED_DISK_USAGE_TRADEOFF SMART
							} else {
								set_global "" $group SPEED_DISK_USAGE_TRADEOFF NORMAL
							}
						}
						PRESERVE_ALL_NODE_NAME_SYNONYMS { 
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare [string toupper $value] "ON"] == 0 } {
								set value "OFF"
							} else {
								set value "ON"
							}
							set_bool_global "" $group SAVE_DISK_SPACE $value
						}
						FUNCTIONAL_SNF_EXTRACTOR {
							#node name does not require checking for invalid synthesized symbol ~
							if { [string compare [string toupper $value] "ON"] == 0 } {
								set_global "" $group SIMULATION_TYPE FUNCTIONAL
							} else {
								set_global "" $group SIMULATION_TYPE TIMING
							}
						}
						
						LOCAL_DEST { 
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance $entity $group $source $node USE_LOCAL_FLEX6K "ON" 
								set_bool_instance $entity $group $source $bus_notation_node USE_LOCAL_FLEX6K "ON" 
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
						
						FLEX_10K_MAX_PERIPHERAL_OE { 
							#node name does not require checking for invalid synthesized symbol ~
							set_global "" "" FLEX10K_MAX_PERIPHERAL_OE $value 
						}
						
						LOW_CAP {
							if {[string compare "FALSE" [synth_text_hier_name $node]] == 0} {
							set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							set_bool_instance $entity "" "" $node LOW_CAP_ADJUST_FLEX10KE $value
							set_bool_instance $entity "" "" $bus_notation_node LOW_CAP_ADJUST_FLEX10KE $value
							# Not switching PCI_IO to ON  follows Maxplus+II
							# add_bool_project_assignment $entity "" "" $node PCI_IO $value
							} else {
								show_message warning "Assignment $variable is ignored due to unsupported hierarchical node name: $node"
							}
						}
					}
					if { [string compare $do_device_opt "TRUE"] == 0 } {
						switch -exact $variable {
							#device option does not include node names assignments
							#checking for synthesized symbols ~ is not required
							MAX7000AE_ENABLE_JTAG {
								if { [string compare $cur_family "MAX7000AE"] == 0 } {
									if { [string compare $chip_jtag_on "FALSE" ] == 0 } {
										if { [string compare $chip_jtag_7kae "FALSE"] == 0 } {
											#puts "MAX7000AE_ENABLE_JTAG"
											if { [string compare $section "CHIP"] == 0 } {
												set chip_jtag_7kae "TRUE"
												set_bool_global "" $group JTAG_BST_SUPPORT_MAX7000 $value
												set_bool_global "" $chip_group JTAG_BST_SUPPORT_MAX7000 $value
												if { [string compare $value "ON"] == 0 } {
													set chip_jtag_on "TRUE"
												} else {
													set chip_jtag_on "FALSE"
												}
											} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
												 if { [string compare $chip_jtag_7kae "FALSE"] == 0 } {
													set_bool_global "" $group JTAG_BST_SUPPORT_MAX7000 $value
													set_bool_global "" $chip_group JTAG_BST_SUPPORT_MAX7000 $value									
													if { [string compare $value "ON"] == 0 } {
														set chip_jtag_on "TRUE"
													} else {
														set chip_jtag_on "FALSE"
													}
												}				
											}
										}
									}
								}
							}
														
							MAX7000S_ENABLE_JTAG {
								if { [string compare $cur_family "MAX7000S"] == 0 } {
									if { [string compare $chip_jtag_on "FALSE" ] == 0 } {
										if { [string compare $chip_jtag_7kae "FALSE"] == 0 } {
											if { [string compare $section "CHIP"] == 0 } {
												set chip_jtag_7kae "TRUE"
												set_bool_global "" $group JTAG_BST_SUPPORT_MAX7000 $value
												set_bool_global "" $chip_group JTAG_BST_SUPPORT_MAX7000 $value
												if { [string compare $value "ON"] == 0 } {
													set chip_jtag_on "TRUE"
												} else {
													set chip_jtag_on "FALSE"
												}
											} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
										   		if { [string compare $chip_jtag_7kae "FALSE"] == 0 } {
													set_bool_global "" $group JTAG_BST_SUPPORT_MAX7000 $value
													set_bool_global "" $chip_group JTAG_BST_SUPPORT_MAX7000 $value									
													if { [string compare $value "ON"] == 0 } {
														set chip_jtag_on "TRUE"
													} else {
														set chip_jtag_on "FALSE"
													}
												}				
											}
										}
									}
								}
							}

							
							SECURITY {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_security_val "TRUE"
									set_bool_global "" $group SECURITY_BIT $value
									set_bool_global "" "" SECURITY_BIT $value
								}
							}

							SECURITY_BIT {
								if {[ string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0} {
									if { [string compare $chip_security_val "FALSE"] == 0 } {
										set_bool_global "" $group SECURITY_BIT $value
										set_bool_global "" $chip_group SECURITY_BIT $value
									}
								}
							}

							MAX7000B_ENABLE_VREFA {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_vrefa_pin "TRUE"
									set_bool_global "" $group ENABLE_VREFA_PIN $value
									set_bool_global "" "" ENABLE_VREFA_PIN $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_vrefa_pin "FALSE"] == 0 } {
										set_bool_global "" $group ENABLE_VREFA_PIN $value
										set_bool_global "" $chip_group ENABLE_VREFA_PIN $value
									}
								}
							}

							MAX7000B_ENABLE_VREFB {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_vrefb_pin "TRUE"
									set_bool_global "" $group ENABLE_VREFB_PIN $value
									set_bool_global "" "" ENABLE_VREFB_PIN $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_vrefb_pin "FALSE"] == 0 } {
										set_bool_global "" $group ENABLE_VREFB_PIN $value
										set_bool_global "" $chip_group ENABLE_VREFB_PIN $value
									}
								}
							}

							MAX7000AE_USER_CODE {
								if { [string compare $cur_family "MAX7000AE"] == 0 } {
									if { [string compare $section "CHIP"] == 0 } {
										set chip_jtag_7k "TRUE"
										set_global "" $group USER_JTAG_CODE_MAX7000 $value
									} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
										if { [string compare $chip_jtag_7k "FALSE"] == 0 } {
											set_global "" $group USER_JTAG_CODE_MAX7000 $value
											set_global "" $chip_group USER_JTAG_CODE_MAX7000 $value
										}
									}
								}
							}

							MAX7000S_USER_CODE {
								if { [string compare $cur_family "MAX7000S"] == 0 } {
									if { [string compare $section "CHIP"] == 0 } {
										set chip_usercode_7ks "FALSE"
										set_global "" $group USER_JTAG_CODE_MAX7000 $value
									} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
										if { [string compare $chip_usercode_7ks "FALSE"] == 0 } {
											set_global "" $group USER_JTAG_CODE_MAX7000 $value
											set_global "" $chip_group USER_JTAG_CODE_MAX7000 $value
										}	
									}
								} 
							}

							MAX7000B_VCCIO_IOBANK1 {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_iobank1 "TRUE"
									set_global "" $chip_group VCCIO_IOBANK1_MAX7000B $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_iobank1 "FALSE"] == 0 } {
										set_global "" $chip_group VCCIO_IOBANK1_MAX7000B $value
									}
								}
							}

							MAX7000B_VCCIO_IOBANK2 {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_iobank2 "TRUE"
									set_global "" $chip_group VCCIO_IOBANK2_MAX7000B $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_iobank2 "FALSE"] == 0 } {
										set_global "" $chip_group VCCIO_IOBANK2_MAX7000B $value
									}
								}
							}

							USER_CLOCK { 
								if { [string compare $section "CHIP"] == 0 } {
									set chip_user_clock "TRUE"
									set_bool_global "" $group START_UP_CLOCK $value
									set_bool_global "" "" START_UP_CLOCK $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_user_clock "FALSE"] == 0 } {
										set_bool_global "" $group START_UP_CLOCK $value
										set_bool_global "" $chip_group START_UP_CLOCK $value
									}
								}
							}
							AUTO_RESTART {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_auto_restart "TRUE"
									set_bool_global "" $group AUTO_RESTART $value
									set_bool_global "" "" AUTO_RESTART $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_auto_restart "FALSE"] == 0 } {
										set_bool_global "" $group AUTO_RESTART $value
										set_bool_global "" $chip_group AUTO_RESTART $value
									}
								}
							}
							RELEASE_CLEARS {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_rel_clears "TRUE"
									set_bool_global "" $group RELEASE_CLEARS_BEFORE_TRI $value
									set_bool_global "" "" RELEASE_CLEARS_BEFORE_TRI $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_rel_clears "FALSE"] == 0 } {
										set_bool_global "" $group RELEASE_CLEARS_BEFORE_TRI $value
										set_bool_global "" $chip_group RELEASE_CLEARS_BEFORE_TRI $value
									}
								}
							}
							ENABLE_CHIP_WIDE_RESET {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_wide_rst "TRUE"
									set_bool_global "" $group CHIP_WIDE_RESET $value
									set_bool_global "" "" CHIP_WIDE_RESET $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_wide_rst "FALSE"] == 0 } {
										set_bool_global "" $group CHIP_WIDE_RESET $value
										set_bool_global "" $chip_group CHIP_WIDE_RESET $value
									}
								}
							}
							ENABLE_CHIP_WIDE_OE {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_wide_oe "TRUE"
									set_bool_global "" $group CHIP_WIDE_OE $value
									set_bool_global "" "" CHIP_WIDE_OE $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_wide_oe "FALSE"] == 0 } {
										set_bool_global "" $group CHIP_WIDE_OE $value
										set_bool_global "" $chip_group CHIP_WIDE_OE $value
									}
								}
							}
							ENABLE_INIT_DONE_OUTPUT {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_init_done "TRUE"
									set_bool_global "" $group INIT_DONE_OUTPUT $value
									set_bool_global "" "" INIT_DONE_OUTPUT $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_init_done "FALSE"] == 0 } {
										set_bool_global "" $group INIT_DONE_OUTPUT $value
										set_bool_global "" $chip_group INIT_DONE_OUTPUT $value
									}
								}
							}
							FLEX10K_ENABLE_LOCK_OUTPUT {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_lock_output "TRUE"
									set_bool_global "" $group PLL_LOCK_10K $value
									set_bool_global "" "" PLL_LOCK_10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_lock_output "FALSE"] == 0 } {
										set_bool_global "" $group PLL_LOCK_10K $value
										set_bool_global "" $chip_group PLL_LOCK_10K $value
									}
								}
							}
							MULTIVOLT_IO {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_multivolt "TRUE"
									if { [string compare [string toupper $value] "ON"] == 0 } {
										if { [string compare $cur_family "FLEX10K"] == 0 } {
											set_global "" $group DEVICE_IO_STANDARD_FLEX10K "LVTTL/LVCMOS"
										} elseif { [string compare $cur_family "MAX3000A"] == 0 || [string compare $cur_family "MAX7000AE"] == 0 } {
											set_global "" $group DEVICE_IO_STANDARD_MAX7000 "2.5 V"
										} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
											set_global "" $group DEVICE_IO_STANDARD_MAX7000 "LVTTL"
										}
									}
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_multivolt "FALSE"] == 0 } {
										if { [string compare $chip_group ""] != 0 } {
											if { [string compare [string toupper $value] "ON"] == 0 } {
												if { [string compare $cur_family "FLEX10K"] == 0 } {
													set_global "" $chip_group DEVICE_IO_STANDARD_FLEX10K "LVTTL/LVCMOS"
												} elseif { [string compare $cur_family "MAX3000A"] == 0 || [string compare $cur_family "MAX7000AE"] == 0 } {
													set_global "" $chip_group DEVICE_IO_STANDARD_MAX7000 "2.5 V"
												} elseif { [string compare $cur_family "MAX7000S"] == 0 } {
													set_global "" $chip_group DEVICE_IO_STANDARD_MAX7000 "LVTTL"
												}
											}
										}
									}
								}
							}
							CONFIG_SCHEME_FLEX_6000 {
								if { [string compare [string toupper $value] "PASSIVE_SERIAL_ASYNCHRONOUS"] == 0 } {
									set value "Passive Serial Asynchronous"
								} else {
									set value "Passive Serial"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_config_scm6k "TRUE"
									set_global "" $group PROGRAMMING_MODE_FLEX6K $value
									set_global "" "" PROGRAMMING_MODE_FLEX6K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_config_scm6k "FALSE"] == 0 } {
										set_global "" $group PROGRAMMING_MODE_FLEX6K $value
										set_global "" $chip_group PROGRAMMING_MODE_FLEX6K $value
									}
								}
							}
							CONFIG_SCHEME_10K {
								if { [string compare [string toupper $value] "PASSIVE_PARALLEL_ASYNCHRONOUS"] == 0 } {
									set value "Passive Parallel Asynchronous"
								} elseif { [string compare [string toupper $value] "PASSIVE_PARALLEL_SYNCHRONOUS"] == 0 } {
									set value "Passive Parallel Synchronous"
								} else {
									set value "Passive Serial"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_config_scm10k "TRUE"
									set_global "" $group PROGRAMMING_MODE_FLEX10K $value
									set_global "" "" PROGRAMMING_MODE_FLEX10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_config_scm10k "FALSE"] == 0 } {
										set_global "" $group PROGRAMMING_MODE_FLEX10K $value
										set_global "" $chip_group PROGRAMMING_MODE_FLEX10K $value
									}
								}
							}
							nWS_nRS_nCS_CS {
								set value [string toupper $value]
								if { [string compare $value "RESERVED_TRI_STATED"] == 0 } {
									set value "As input tri-stated"
								} elseif { [string compare $value "RESERVED_DRIVES_OUT"] == 0 } {
									set value "As output driving an unspecified signal"
								} else {
									set value "Off"
								}							
								if { [string compare $section "CHIP"] == 0 } {
									set chip_nws_nrs "TRUE"
									set_global "" $group NWS_NRS_NCS_CS_RESERVED $value
									set_global "" "" NWS_NRS_NCS_CS_RESERVED $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_nws_nrs "FALSE"] == 0 } {
										set_global "" $group NWS_NRS_NCS_CS_RESERVED $value
										set_global "" $chip_group NWS_NRS_NCS_CS_RESERVED $value
									}
								}
							}
							DATA1_TO_DATA7 {
								set value [string toupper $value]
								if { [string compare $value "RESERVED_TRI_STATED"] == 0 } {
									set value "As input tri-stated"
								} elseif { [string compare $value "RESERVED_DRIVES_OUT"] == 0 } {
									set value "As output driving an unspecified signal"
								} else {
									set value "Off"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_data7_1 "TRUE"
									set_global "" $group DATA7_1_RESERVED $value
									set_global "" "" DATA7_1_RESERVED $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_data7_1 "FALSE"] == 0 } {
										set_global "" $group DATA7_1_RESERVED $value
										set_global "" $chip_group DATA7_1_RESERVED $value
									}
								}
							}
							RDYnBUSY {
								set value [string toupper $value]
								if { [string compare $value "RESERVED_TRI_STATED"] == 0 } {
									set value "As input tri-stated"
								} elseif { [string compare $value "RESERVED_DRIVES_OUT"] == 0 } {
									set value "As output driving an unspecified signal"
								} else {
									set value "Off"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_rdynbusy "TRUE"
									set_global "" $group RDYNBUSY_RESERVED $value
									set_global "" "" RDYNBUSY_RESERVED $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_rdynbusy "FALSE"] == 0 } {
										set_global "" $group RDYNBUSY_RESERVED $value
										set_global "" $chip_group RDYNBUSY_RESERVED $value
									}
								}
							}
							nCEO {
								if { [string compare [string toupper $value] "UNRESERVED"] == 0 } {
									set value "Off"
								} else {
									#this is the default for nCEO
									set value "As output driving ground"
								}
								if { [string compare $section "CHIP"] == 0 } {
									set chip_nceo "TRUE"
									set_global "" $group NCEO_RESERVED $value
									set_global "" "" NCEO_RESERVED $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_nceo "FALSE"] == 0 } {
										set_global "" $group NCEO_RESERVED $value
										set_global "" $chip_group NCEO_RESERVED $value
									}
								}
							}
							FLEX10K_JTAG_USER_CODE { 
								if { [string compare $section "CHIP"] == 0 } {
									set chip_jtag_10k "TRUE"
									set_global "" $group USER_JTAG_CODE_FLEX10K $value
									set_global "" "" USER_JTAG_CODE_FLEX10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_jtag_10k "FALSE"] == 0 } {
										set_global "" $group USER_JTAG_CODE_FLEX10K $value
										set_global "" $chip_group USER_JTAG_CODE_FLEX10K $value
									}
								}
							}
							CONFIG_EPROM_USER_CODE { 
								if { [string compare $section "CHIP"] == 0 } {
									set chip_config_jtag "TRUE"
									set_global "" $group EPROM_JTAG_CODE_FLEX10K $value
									set_global "" "" EPROM_JTAG_CODE_FLEX10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_config_jtag "FALSE"] == 0 } {
										set_global "" $group EPROM_JTAG_CODE_FLEX10K $value
										set_global "" $chip_group EPROM_JTAG_CODE_FLEX10K $value
									}
								}
							}									
							FLEX10KA_USE_LOW_VOLTAGE_CONFIGURATION_EPROM { 
								if { [string compare $section "CHIP"] == 0 } {
									set chip_low_volt_10k "TRUE"
									set_bool_global "" $group ENABLE_LOW_VOLT_MODE_FLEX10K $value
									set_bool_global "" "" ENABLE_LOW_VOLT_MODE_FLEX10K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_low_volt_10k "FALSE"] == 0 } {
										set_bool_global "" $group ENABLE_LOW_VOLT_MODE_FLEX10K $value
										set_bool_global "" $chip_group ENABLE_LOW_VOLT_MODE_FLEX10K $value
									}
								}
							}
							FLEX6000_ENABLE_JTAG {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_jtag_bst "TRUE"
									set_bool_global "" $group JTAG_BST_SUPPORT $value
									set_bool_global "" "" JTAG_BST_SUPPORT $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_jtag_bst "FALSE"] == 0 } {
										set_bool_global "" $group JTAG_BST_SUPPORT $value
										set_bool_global "" $chip_group JTAG_BST_SUPPORT $value
									}
								}
							}
							FLEX6000_USE_LOW_VOLTAGE_CONFIGURATION_EPROM {
								if { [string compare $section "CHIP"] == 0 } {
									set chip_low_volt_6k "TRUE"
									set_bool_global "" $group ENABLE_LOW_VOLT_MODE_FLEX6K $value
									set_bool_global "" "" ENABLE_LOW_VOLT_MODE_FLEX6K $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_low_volt_6k "FALSE"] == 0 } {
										set_bool_global "" $group ENABLE_LOW_VOLT_MODE_FLEX6K $value
										set_bool_global "" $chip_group ENABLE_LOW_VOLT_MODE_FLEX6K $value
									}
								}
							}
							CONFIG_EPROM_PULLUP_RESISTOR {
								#puts "CONFIG_EPROM_PULLUP_RESISTOR = $value"
								if { [string compare [string toupper $value] "ON"] == 0 } {
									set value "OFF"
								} else {
									set value "ON"
								}
								if { [string compare $section "CHIP"] == 0 } {
									#puts "Section chip"
									set chip_pullup_res "TRUE"
									set_bool_global "" $group DISABLE_NCS_AND_OE_PULLUPS_ON_CONFIG_DEVICE $value
									set_bool_global "" "" DISABLE_NCS_AND_OE_PULLUPS_ON_CONFIG_DEVICE $value
								} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
									if { [string compare $chip_pullup_res "FALSE"] == 0 } {
										#puts "Section Project"
										set_bool_global "" $group DISABLE_NCS_AND_OE_PULLUPS_ON_CONFIG_DEVICE $value
										set_bool_global "" $chip_group DISABLE_NCS_AND_OE_PULLUPS_ON_CONFIG_DEVICE $value
									}
								}
							}
							FLEX_CONFIGURATION_EPROM {
								if { [string compare [string toupper $value] "AUTO"] == 0 } {
									# do nothing
								} else { 
									if { [string compare $section "CHIP"] == 0 } {
										set chip_config_dev "TRUE"
										set_global "" $group USE_CONFIGURATION_DEVICE_NAME_FLEX6K $value
										set_global "" "" USE_CONFIGURATION_DEVICE_NAME_FLEX6K $value
										set_global "" $group USE_CONFIGURATION_DEVICE_NAME_FLEX10K $value
										set_global "" "" USE_CONFIGURATION_DEVICE_NAME_FLEX10K $value
									} elseif { [string compare $section "GLOBAL_PROJECT_DEVICE_OPTIONS"] == 0 } {
										if { [string compare $chip_config_dev "FALSE"] == 0 } {
											set_global "" $group USE_CONFIGURATION_DEVICE_NAME_FLEX6K $value
											set_global "" $chip_group USE_CONFIGURATION_DEVICE_NAME_FLEX6K $value
											set_global "" $group USE_CONFIGURATION_DEVICE_NAME_FLEX10K $value
											set_global "" $chip_group USE_CONFIGURATION_DEVICE_NAME_FLEX10K $value
										}
									}
								}
							}
						}
					}
					if { [string compare $do_location "TRUE"] == 0 } {
						switch -exact $variable {
							PIN { 
							if { [string compare "ANY" $value] != 0 } {
								set value "Pin_$value"
								set_location_assignment -to $node $value
								set_location_assignment -to $bus_notation_node $value

								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							}				
							}
							OUTPUT_PIN { 
							if { [string compare "ANY" $value] != 0 } {
								set value "Pin_$value"
								set_location_assignment -to $node $value
								set_location_assignment -to $bus_notation_node $value

								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							}
							}
							INPUT_PIN { 
							if { [string compare "ANY" $value] != 0 } {
								set value "Pin_$value"
								set_location_assignment -to $node $value
								set_location_assignment -to $bus_notation_node $value

								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
							}
							}
							BIDIR_PIN { 
							if { [string compare $section "CHIP"] == 0 } {
								if { [string compare "ANY" $value] != 0 } {
									set value "Pin_$value"
									set_location_assignment -to $node $value
									set_location_assignment -to $bus_notation_node $value

									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								}
							}
							}
							LOCATION {
								if { [string first "|:" $node] == -1 } {
									set value [string toupper $value]
									if { [string compare "ANY" $value] != 0 } {
										if { [string first "IOC" $value] == -1 } {
											if { [string first "COL" $value] == -1 } {
												# make sure there are no invalid location indices
												set dont_import "FALSE"
												if { [string first "ROW" $value] == -1 } {
													set loc_temp $value
													set loc_dump ""
													while { [string length $loc_temp] > 0 } {
														set loc_char ""
														set loc_num ""
														scan $loc_temp { %[^{0-9}]%[0-9] } loc_char loc_num
														set loc_char
														set loc_num
														set loc_dump $loc_dump$loc_char$loc_num
														set loc_temp [ string range $value [string length $loc_dump] end ]
														if { $loc_num == 0 } {
															set dont_import "TRUE"
														}
													}
												}
										
												if { [string compare "FALSE" $dont_import] == 0 } { 
													if { [string compare "ROW_ANY" $value] == 0 } {
														set value "Any_Row"
													} elseif { [string compare "COL_ANY" $value] == 0 } {
														set value "Any_Col"
													}	

													set_location_assignment -to $node $value
													set_location_assignment -to $bus_notation_node $value

													set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
												} else {
													show_message info "Invalid location index -- $value. All location indices begin with 1. Will not import this location assignment."
												}
											} else {
												if { [string first "EAB" $value] == -1 } {
													if { [string compare "COL_ANY" $value] == 0 } {
														set value "Any_Col"
													}
													if { [string compare $cur_family "FLEX6K"] != 0 } {
														set_location_assignment -to $node $value
														set_location_assignment -to $bus_notation_node $value
													} else {
														show_message info "Column location assignments are not supported for FLEX 6000 devices. Will not import column location assignments."
													}	
												} else {
													if { [string compare $first_col_eab_warning "TRUE"] == 0 } {
														show_message info "COL_EAB is not a valid location type. Will not import this location assignment."
														set first_col_eab_warning "FALSE"
													}
												}
											}
										} else {
											set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
											set_bool_instance $entity "" "" $node INPUT_REGISTER ON
											set_bool_instance $entity "" "" $node OUTPUT_REGISTER ON
											set_bool_instance $entity "" "" $bus_notation_node INPUT_REGISTER ON
											set_bool_instance $entity "" "" $bus_notation_node OUTPUT_REGISTER ON
											if { [string compare $first_ioc_warning "TRUE"] == 0 } {
												show_message info "IOC location assignments are not supported by Quartus II. Will automatically translate an IOC location assignment to the Fast Input/Output Register logic assignment, but exact I/O placement will be lost."
												set first_ioc_warning "FALSE"
											}
										}
									}
								}
							}
						}
					}							
					if { [string compare $do_prj_synth "TRUE"] == 0 } {
						switch -exact $variable {
							AUTO_IMPLEMENT_IN_EAB {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance "" $group $source $node AUTO_ROM $value
								set_bool_instance "" $group $source $bus_notation_node AUTO_ROM $value
							}
							AUTO_OPEN_DRAIN_PINS {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance "" $group $source $node AUTO_OPEN_DRAIN $value
								set_bool_instance "" $group $source $bus_notation_node AUTO_OPEN_DRAIN $value
							}
							AUTO_REGISTER_PACKING { 
								if { [string compare [string toupper $value] "ON"] == 0 } {
									set value "Minimize Area"
								}
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_instance "" $group $source $node REGISTER_PACKING $value
								set_instance "" $group $source $bus_notation_node REGISTER_PACKING $value
							}
							AUTO_FAST_IO { 
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance "" $group $source $node AUTO_INPUT_REGISTER $value 
								set_bool_instance "" $group $source $node AUTO_OUTPUT_REGISTER $value 
								set_bool_instance "" $group $source $bus_notation_node AUTO_INPUT_REGISTER $value 
								set_bool_instance "" $group $source $bus_notation_node AUTO_OUTPUT_REGISTER $value 
							}
							AUTO_IO_CELL_REGISTERS {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance "" $group $source $node AUTO_INPUT_REGISTER $value 
								set_bool_instance "" $group $source $node AUTO_OUTPUT_REGISTER $value 
								set_bool_instance "" $group $source $bus_notation_node AUTO_INPUT_REGISTER $value 
								set_bool_instance "" $group $source $bus_notation_node AUTO_OUTPUT_REGISTER $value 
							}
							AUTO_GLOBAL_OE {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance "" $group $source $node AUTO_GLOBAL_OE $value
								set_bool_instance "" $group $source $bus_notation_node AUTO_GLOBAL_OE $value
							}
							AUTO_GLOBAL_PRESET {
								if { [string compare [string toupper $value] "ON"] == 0 } {
									set auto_global_prst ON
									if { [string compare $auto_global_clr "ON"] == 0 } {
										set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
										set_bool_instance "" $group $source $node AUTO_GLOBAL_REG_CTRL ON
										set_bool_instance "" $group $source $bus_notation_node AUTO_GLOBAL_REG_CTRL ON
									} 
								} else { 
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									set_bool_instance "" $group $source $node AUTO_GLOBAL_REG_CTRL OFF
									set_bool_instance "" $group $source $bus_notation_node AUTO_GLOBAL_REG_CTRL OFF
								}
							}
							AUTO_GLOBAL_CLEAR {
								if { [string compare [string toupper $value] "ON"] == 0 } {
									set auto_global_clr ON
									if { [string compare $auto_global_prst "ON"] == 0 } {
										set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
										set_bool_instance "" $group $source $node AUTO_GLOBAL_REG_CTRL ON
										set_bool_instance "" $group $source $bus_notation_node AUTO_GLOBAL_REG_CTRL ON
									}
								} else {
									set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
									set_bool_instance "" $group $source $node AUTO_GLOBAL_REG_CTRL OFF
									set_bool_instance "" $group $source $bus_notation_node AUTO_GLOBAL_REG_CTRL OFF
								}
							}
							AUTO_GLOBAL_CLOCK {
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_bool_instance "" $group $source $node AUTO_GLOBAL_CLOCK $value
								set_bool_instance "" $group $source $bus_notation_node AUTO_GLOBAL_CLOCK $value
							}
							OPTIMIZE_FOR_SPEED {
								if { $value > 5 } {
									set value "SPEED"
								} else {
									set value "AREA"
								}
								set first_node_warning [bus_notation_warning $do_bus_warn_msg $first_node_warning bus_notation_array $orig_node $bus_notation_node]
								set_instance "" $group $source $node OPTIMIZATION_TECHNIQUE_FLEX6K $value
								set_instance "" $group $source $node OPTIMIZATION_TECHNIQUE_FLEX10K $value
								set_instance "" $group $source $bus_notation_node OPTIMIZATION_TECHNIQUE_FLEX6K $value
								set_instance "" $group $source $bus_notation_node OPTIMIZATION_TECHNIQUE_FLEX10K $value
							}
						}
					}
					if { [string compare $do_eda_input "TRUE"] == 0 } {
						switch -exact $variable {
							EDIF_INPUT_USE_LMF1 {
								set value [string toupper $value]
								set edif_use_lmf1 $value
								if { [string compare $value "ON"] == 0 } {
									if { [string compare $edif_lmf_file1 ""] != 0 } {
										if { [string compare $eda_add_lmf "FALSE"] == 0 } {
											set_global "" eda_design_synthesis EDA_USE_LMF $edif_lmf_file1
											set eda_add_lmf "TRUE"
										} else {
											show_message info "Quartus II can only accept one LMF file. Using the second LMF file $edif_lmf_file2, and ignoring the first LMF file $edif_lmf_file1."
										}
									}
								}
							}
							EDIF_INPUT_LMF1 {
								set edif_lmf_file1 $value
								set upper_value [string toupper $value]

								# from the lmf filename, figure out the synthesis tool used
								if { [string first "EXEMPLAR" $upper_value] != -1 } {
									set eda_synth_tool "LEONARDO SPECTRUM"
								} elseif { [string first "MNT8_BAS" $upper_value] != -1 } {
									set eda_synth_tool "DESIGN ARCHITECT"
								} elseif { [string first "ORC2ALT" $upper_value] != -1 } {
									set eda_synth_tool "CUSTOM"
								} elseif { [string first "ALTSYN" $upper_value] != -1 } {
									set eda_synth_tool "DESIGN COMPILER"
								} elseif { [string first "SYNPLCTY" $upper_value] != -1 } {
									set eda_synth_tool "SYNPLIFY"
								} elseif { [string first "VWL_BAS" $upper_value] != -1 } {
									set eda_synth_tool "VIEWDRAW"
								} elseif { [string compare "" $upper_value] != 0 } {
									if { [file isfile $value] } {
										set eda_synth_tool "CUSTOM"
									} else {
										set edif_lmf_file1 ""
										set value ""
									}
								}

								if { [string compare $edif_use_lmf1 "ON"] == 0 } {
									if { [string compare $value ""] != 0 } {
										if { [string compare $eda_add_lmf "FALSE"] == 0 } {
											set_global "" eda_design_synthesis EDA_USE_LMF $value
											set eda_add_lmf "TRUE"
										} else {
											show_message info "Quartus II can only accept one LMF file. Using the second LMF file $edif_lmf_file2, and ignoring the first LMF file $edif_lmf_file1."
										}
									}
								}
							}
							EDIF_INPUT_USE_LMF2 {
								set value [string toupper $value]
								set edif_use_lmf2 $value
								if { [string compare $value "ON"] == 0 } {
									if { [string compare $edif_lmf_file2 ""] != 0 } {
										if { [string compare $eda_add_lmf "FALSE"] == 0 } {
											set_global "" eda_design_synthesis EDA_USE_LMF $edif_lmf_file2
											set eda_add_lmf "TRUE"
										} else {
											show_message info "Quartus II can only accept one LMF file. Using the first LMF file $edif_lmf_file1, and ignoring the second LMF file $edif_lmf_file2."
										}
									}
								}
							}
							EDIF_INPUT_LMF2 {
								set edif_lmf_file2 $value
								if { [string compare $edif_use_lmf2 "ON"] == 0 } {
									if { [string compare $value ""] != 0 } {
										if { [string compare $eda_add_lmf "FALSE"] == 0 } {
											set_global "" eda_design_synthesis EDA_USE_LMF $value
											set eda_add_lmf "TRUE"
										} else {
											show_message info "Quartus II can only accept one LMF file. Using the first LMF file $edif_lmf_file1, and ignoring the second LMF file $edif_lmf_file2."
										}
									}
								}
							}
							EDIF_INPUT_SHOW_LMF_MAPPING_MESSAGES { set_bool_global "" eda_design_synthesis EDA_SHOW_LMF_MAPPING_MSGS $value }
							EDIF_INPUT_VCC { set_bool_global "" eda_design_synthesis EDA_INPUT_VCC $value }
							EDIF_INPUT_GND { set_bool_global "" eda_design_synthesis EDA_INPUT_GND $value }
							VHDL_USER_LIB_PHYSICAL_NAMES {
								# to get rid of the double quotes and the semi colon at the end of the name
								set value [string range $value 1 [expr [string length $value] - 1]]

								if { [string compare $vhdl_lib_logical ""] != 0 } {
									set_instance "" eda_design_synthesis "" $vhdl_lib_logical EDA_VHDL_LIBRARY $value
									set_instance "" "" "" $vhdl_lib_logical VHDL_INPUT_LIBRARY $value
									
									if { [string compare $vhdl_version ""] != 0 } {
										set_global "" "" VHDL_INPUT_VERSION $vhdl_version
									}
									set vhdl_add_input "TRUE"
								} else {
									set vhdl_lib_physical $value
								}
							}
							VHDL_USER_LIB_LOGICAL_NAMES {
								# to get rid of the double quotes and the semi colon at the end of the name
								set value [string range $value 1 [expr [string length $value] - 1]]

								if { [string compare $vhdl_lib_physical ""] != 0 } {
									set_instance "" eda_design_synthesis "" $value EDA_VHDL_LIBRARY $vhdl_lib_physical
									set_instance "" "" "" $value VHDL_INPUT_LIBRARY $vhdl_lib_physical
									if { [string compare $vhdl_version ""] != 0 } {
										set_global "" "" VHDL_INPUT_VERSION $vhdl_version
									}
									set vhdl_add_input "TRUE"
								} else {
									set vhdl_lib_logical $value
								}
							}
							VHDL_READER_VERSION {
								if { [string compare $vhdl_add_input "TRUE"] == 0 } {
									set_global "" "" VHDL_INPUT_VERSION $value
								} else {
									set vhdl_version $value
								}
							}	
						}
						if { [string compare $eda_add_info "FALSE"] == 0 } {
							if { [string compare $eda_add_lmf "TRUE"] == 0 } {
								if { [string compare $eda_synth_tool ""] != 0 } {
									if { [string compare $chip_group ""] != 0 } {
										set_global "" $chip_group EDA_DESIGN_ENTRY_SYNTHESIS_TOOL $eda_synth_tool
										show_message info "Setting EDA input tool to $eda_synth_tool. To select a different EDA tool, choose the EDA Tool Settings command in the Project menu."
										set_global "" eda_design_synthesis EDA_DATA_FORMAT EDIF
										set eda_add_info "TRUE"
									}
								}
							} elseif { [string compare $vhdl_add_input "TRUE"] == 0 } {
								if { [string compare $chip_group ""] != 0 } {
									set_global "" $chip_group EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "CUSTOM"
									show_message info "Settings EDA input tool to CUSTOM. To select a different EDA tool, choose the EDA Tool Settings command in the Project menu."
									set_global "" eda_design_synthesis EDA_DATA_FORMAT VHDL
									set eda_add_info "TRUE"
								}
							}
						}
					}
					if { [string compare $do_eda_output "TRUE"] == 0 } {
						switch -exact $variable {
							VERILOG_NETLIST_WRITER {
								if { [string compare [string toupper $value] "ON"] == 0 } {
									if { [string compare $eda_output_format ""] == 0 } {
										set eda_output_format "VERILOG"
										set_global "" eda_simulation EDA_NETLIST_TYPE VERILOG
										set_global "" eda_timing_analysis EDA_NETLIST_TYPE VERILOG

										if { [string compare $chip_group ""] != 0 } {
											set_global "" $chip_group EDA_SIMULATION_TOOL "CUSTOM VERILOG HDL"
											set_global "" $chip_group EDA_TIMING_ANALYSIS_TOOL "CUSTOM VERILOG HDL"
											show_message info "Setting EDA output tool to Custom Verilog HDL. To select a different EDA tool, choose the EDA Tool Settings command in the Project menu."
										}
																				
										if { [string compare $verilog_map_char ""] != 0 } {
											set_bool_global "" eda_simulation EDA_MAP_ILLEGAL $verilog_map_char
											set_bool_global "" eda_timing_analysis EDA_MAP_ILLEGAL $verilog_map_char
										}
										if { [string compare $verilog_flat_bus ""] != 0 } {
											set_bool_global "" eda_simulation EDA_FLATTEN_BUSES $verilog_flat_bus
											set_bool_global "" eda_timing_analysis EDA_FLATTEN_BUSES $verilog_flat_bus
										}
										if { [string compare $verilog_trun_hier ""] != 0 } {
											set_bool_global "" eda_simulation EDA_TRUNCATE_HPATH $verilog_trun_hier
											set_bool_global "" eda_timing_analysis EDA_TRUNCATE_HPATH $verilog_trun_hier
										}		
										if { [string compare $verilog_time_scale ""] != 0 } {
											set_global "" eda_simulation EDA_TIMESCALE $verilog_time_scale
											set_global "" eda_timing_analysis EDA_TIMESCALE $verilog_time_scale
										}
												
									} else {
										show_message info "Quartus II can only generate one netlist format at one time. Selecting VHDL output."
									}
								}
							}
							VERILOG_OUTPUT_MAP_ILLEGAL_CHAR {
								if { [string compare $eda_output_format "VERILOG"] == 0 } {
									set_bool_global "" eda_simulation EDA_MAP_ILLEGAL $value
									set_bool_global "" eda_timing_analysis EDA_MAP_ILLEGAL $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set verilog_map_char $value
								}
							}
							VERILOG_FLATTEN_BUS {
								if { [string compare $eda_output_format "VERILOG"] == 0 } {
									set_bool_global "" eda_simulation EDA_FLATTEN_BUSES $value
									set_bool_global "" eda_timing_analysis EDA_FLATTEN_BUSES $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set verilog_flat_bus $value
								}
							}
							VERILOG_TRUNCATE_HIERARCHY_PATH {
								if { [string compare $eda_output_format "VERILOG"] == 0 } {
									set_bool_global "" eda_simulation EDA_TRUNCATE_HPATH $value
									set_bool_global "" eda_timing_analysis EDA_TRUNCATE_HPATH $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set verilog_trun_hier $value
								}
							}
							NETLIST_OUTPUT_TIME_SCALE {
								switch -exact $value {
									0.000001us	{ set value "1 ps" }
									0.00001us	{ set value "10 ps" }
									0.0001us	{ set value "100 ps" }
									0.001us		{ set value "1 ns" }
									0.01us		{ set value "10 ns" }
									0.001ns		{ set value "1 ps" }
									0.01ns		{ set value "10 ps" }
									0.1ns		{ set value "100 ps" }
									1ns			{ set value "1 ns" }
									10ns		{ set value "10 ns" }
								}
								if { [string compare $eda_output_format "VERILOG"] == 0 } {
									set_global "" eda_simulation EDA_TIMESCALE $value
									set_global "" eda_timing_analysis EDA_TIMESCALE $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set verilog_time_scale $value
								}
							}
							VHDL_NETLIST_WRITER {
								if { [string compare [string toupper $value] "ON"] == 0 } {	
									if { [string compare $eda_output_format ""] == 0 } {
										set eda_output_format "VHDL"
										set_global "" eda_simulation EDA_NETLIST_TYPE VHDL
										set_global "" eda_timing_analysis EDA_NETLIST_TYPE VHDL
									
										if { [string compare $chip_group ""] != 0 } {
											set_global "" $chip_group EDA_SIMULATION_TOOL "CUSTOM VHDL"
											set_global "" $chip_group EDA_TIMING_ANALYSIS_TOOL "CUSTOM VHDL"
											show_message info "Setting EDA output tool to Custom VHDL. To select a different EDA tool, choose the EDA Tool Settings command in the Project menu."
										}	
									
										if { [string compare $vhdl_output_version ""] != 0 } {
											set_bool_global "" eda_simulation EDA_MAP_ILLEGAL $vhdl_output_version
											set_bool_global "" eda_timing_analysis EDA_MAP_ILLEGAL $vhdl_output_version
										}
										if { [string compare $vhdl_config_decl ""] != 0 } {
											set_bool_global "" eda_simulation EDA_WRITE_CONFIG $vhdl_config_decl
											set_bool_global "" eda_timing_analysis EDA_WRITE_CONFIG $vhdl_config_decl
										}
										if { [string compare $vhdl_trun_hier ""] != 0 } {
											set_bool_global "" eda_simulation EDA_TRUNCATE_HPATH $vhdl_trun_hier
											set_bool_global "" eda_timing_analysis EDA_TRUNCATE_HPATH $vhdl_trun_hier
										}
										if { [string compare $vhdl_flat_bus ""] != 0 } {
											set_bool_global "" eda_simulation EDA_FLATTEN_BUSES $vhdl_flat_bus
											set_bool_global "" eda_timing_analysis EDA_FLATTEN_BUSES $vhdl_flat_bus
										}
									
									} else {
										show_message info "Quartus II can only generate one netlist format at one time. Selecting VERILOG format."
									}
								}
							}
							VHDL_WRITER_VERSION {
								if { [string compare [string toupper $value] "VHDL87"] == 0 } {
									if { [string compare $eda_output_format "VHDL"] == 0 } {
										set_bool_global "" eda_simulation EDA_MAP_ILLEGAL ON
										set_bool_global "" eda_timing_analysis EDA_MAP_ILLEGAL ON
									} elseif { [string compare $eda_output_format ""] == 0 } {
										set vhdl_output_version "ON"
									}
								}
							}
							VHDL_GENERATE_CONFIGURATION_DECLARATION {
								if { [string compare $eda_output_format "VHDL"] == 0 } {
									set_bool_global "" eda_simulation EDA_WRITE_CONFIG $value
									set_bool_global "" eda_timing_analysis EDA_WRITE_CONFIG $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set vhdl_config_decl $value
								}
							}
							VHDL_TRUNCATE_HIERARCHY_PATH {
								if { [string compare $eda_output_format "VHDL"] == 0 } {
									set_bool_global "" eda_simulation EDA_TRUNCATE_HPATH $value
									set_bool_global "" eda_timing_analysis EDA_TRUNCATE_HPATH $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set vhdl_trun_hier $value
								}
							}
							VHDL_FLATTEN_BUS {	
								if { [string compare $eda_output_format "VHDL"] == 0 } {
									set_bool_global "" eda_simulation EDA_FLATTEN_BUSES $value
									set_bool_global "" eda_timing_analysis EDA_FLATTEN_BUSES $value
								} elseif { [string compare $eda_output_format ""] == 0 } {
									set vhdl_flat_bus $value
								}
							}
							EDIF_NETLIST_WRITER {
								if { [string compare [string toupper $value] "ON"] == 0 } {
									show_message info "Quartus II cannot generate EDIF files. Only Verilog or VHDL formats can be generated."
								}
							}
						}
					}							 
					} 
				}
			}
		} elseif { [string length $line] != 0 } {
			set section ""
			set group ""
			scan $line { %s%s } section group
			set section
			set group
			if { [string compare $section "CHIP"] == 0 } {
				if { [string compare $do_chip "TRUE"] == 0 } {
					set revision_name [get_current_revision]
					if { [string compare -nocase $revision_name $group] == 0 } {
						set group $revision_name
					}
					if { [string compare $chip_group ""] != 0 } {
						if { [string compare $chip_group $group] != 0 } {
							if { [string compare $first_multichip_warning "TRUE"] == 0 } {
								show_message info "Multiple CHIP sections found, but Quartus II does not support multidevice partitioning. Will import assignments in the CHIP $chip_group section and ignore the rest of the CHIP sections."
								set do_chip "FALSE"
								set first_multichip_warning "FALSE"
							}
						} 
					} else {
						if { [revision_exists $group] == 1 } {
							set chip_group $group
						} else {
							if { [string compare $first_multichip_warning "TRUE"] == 0 } {
								show_message warning "The CHIP name ($group) found in $entity.acf does not match the revision name. Will NOT import any device options or chip/location/pin assignments."
								set do_chip "FALSE"
								set do_device_opt "FALSE"
							}
						}
					}
				}
			}

			#	skip unsupported/de-selected sections
			switch -exact $section {
				CLIQUE {
					if { [string compare $do_clique "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
				COMPILER_INTERFACES_CONFIGURATION { 
					if { [string compare $do_eda_input "FALSE"] == 0 } {
						if { [string compare $do_eda_output "FALSE"] == 0 } {
							skip_until $file $stop 
						}
					}
				}
				COMPILER_PROCESSING_CONFIGURATION { 
					if { [string compare $do_cmp_proc_cfg "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
				CONNECTED_PINS { skip_until $file $stop }
				CUSTOM_DESIGN_DOCTOR_RULES { skip_until $file $stop }
				GLOBAL_PROJECT_DEVICE_OPTIONS {
					if { [string compare $do_device_opt "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
				GLOBAL_PARAMETERS {
					if { [string compare $do_param "FALSE"] == 0 } {
						skip_until $file $stop
					} 
				}
				#IGNORED_ASSIGNMENTS { 
				#	if { [string compare $do_ignore "FALSE"] == 0 } {
				#		skip_until $file $stop
				#	}
				#}
				INTERNAL_INFO { skip_until $file $stop }
				LOCAL_ROUTING {
					if { [string compare $do_local_rout "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
				LOGIC_OPTIONS {
					if { [string compare $do_logic_opt "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
				DEFINE_LOGIC_SYNTHESIS_STYLE { skip_until $file $stop }
				OTHER_CONFIGURATION { 
					if { [string compare $cur_family "FLEX10K"] != 0 } {
						skip_until $file $stop 
					}
				}
				CHIP {
					if { [string compare $do_chip "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
				PROBES { skip_until $file $stop }
				SIMULATOR_CONFIGURATION { 
					if { [string compare $do_sim "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
				TIMING_ANALYZER_CONFIGURATION { 
					if { [string compare $do_tan "FALSE"] == 0 } {
						skip_until $file $stop 
					} 
				}
				TIMING_POINT {
					if { [string compare $do_tim_req "FALSE"] == 0 } {
						skip_until $file $stop
					}
				}
			}
		}

	}
	}
	close $file

	if { [array size bus_notation_array] > 0 || [llength $ignore_node_list] > 0 } {
		# Print report
		print_report $bus_mapping_file_name bus_notation_array $entity $ignore_node_list
	}

	return
}

proc add_bool_project_assignment { entity group source node variable value } {
	
	if { [string compare $value "1"] == 0 } {
		set value ON
	} elseif { [string compare $value "0"] == 0 } {
		set value OFF
	}
	project add_assignment $entity $group $source $node $variable $value

}

proc add_bool_cmp_assignment { group source node variable value } {
	
	if { [string compare $value "1"] == 0 } {
		set value ON
	} elseif { [string compare $value "0"] == 0 } {
		set value OFF
	}
	cmp add_assignment $group $source $node $variable $value

}

proc add_bool_sim_assignment { group source node variable value } {
	
	if { [string compare $value "1"] == 0 } {
		set value ON
	} elseif { [string compare $value "0"] == 0 } {
		set value OFF
	}
	sim add_assignment $group $source $node $variable $value

}

proc set_bool_global { entity group variable value } {
	
	if { [string compare $value "1"] == 0 } {
		set value ON
	} elseif { [string compare $value "0"] == 0 } {
		set value OFF
	}
	set_global $entity $group $variable $value

}

proc set_bool_instance { entity group source node variable value } {
	
	if { [string compare $value "1"] == 0 } {
		set value ON
	} elseif { [string compare $value "0"] == 0 } {
		set value OFF
	}
	set_instance $entity $group $source $node $variable $value

}

proc process_single { singleline } {

	return [ string trim [ string range $singleline 0 [ expr [string first "--" $singleline] - 1 ] ] ]

}

proc process_multi_start { line } {

	global comment_flag
	if { [string first "*/" $line] != -1 } {
		if { [string first "/*" $line] > [string first "*/" $line] } {
			set line [process_multi_stop $line]
		}
	}
	if { $comment_flag == 1 } {
		set line ""
	}
	while { [string first "/*" $line] != -1 } {
		if { [ string first "*/" [string range $line [string first "/*" $line] end ] ] > 1 } {	
			set temp1 [ string range $line 0 [ expr [string first "/*" $line] - 1 ] ]
			set temp2 [ string range $line [ expr [string first "*/" [string range $line [string first "/*" $line] end]] + 2 + [string first "/*" $line] ] end ]
			set line "$temp1$temp2"
		} else {
			set comment_flag 1
			set line [ string range $line 0 [ expr [string first "/*" $line] - 1 ] ]
			break
		}
	}
	return [string trim $line]

}

proc process_multi_stop { line } {

	global comment_flag
	if { $comment_flag == 0 } {
		return $line
	} else {
		set comment_flag 0
		return [string trim [ string range $line [ expr [string first "*/" $line] + 2 ] end ] ]
	}

}

proc skip_until { file stop_string } {

	while { [gets $file line] >= 0 } {
		if { [string compare [string toupper $line] $stop_string] == 0 } {
			break
		}
	}

}

proc get_correct_value { value } {
	set result $value
	set tmp_ind [string last "_" $value]
	set first 	[string range $value 0 [expr $tmp_ind - 1]]
	set empty	" "
	set second	[string range $value [expr $tmp_ind + 1] end]
	
	if { [string last "CLASS1" $second] != -1 } {
		set temp [string range $second 0 [expr [string length $second] - 2]]
		set num " I"
		set second $temp$num
	}
	if { [string last "CLASS2" $second] != -1 } {
		set temp [string range $second 0 [expr [string length $second] - 2]]
		set num " II"
		set second $temp$num
	}
	if { [string last "CLASS3" $second] != -1 } {
		set temp [string range $second 0 [expr [string length $second] - 2]]
		set num " III"
		set second $temp$num
	}
	
	if { [string length $first] > 0 } {
	set result $first$empty$second
	} elseif {[string length $first] <= 0 } {
		set result $second
	}
	
	return $result
}  

### spr125432
### if there exist ~ in hierarchy name, ignore the conversion
proc synth_text_hier_name { node } {
	
	set result "FALSE"
	set count_elem 0
	set index_elem 0
	set str_elem ""
	set list_elem ""
	
	set line $node
	set list_elem [split $line :]
	
	if { [llength $list_elem] > 1 }	{
		set count_elem [expr [llength $list_elem] - 1 ]
	}
	
	set index_elem 0

		while { $index_elem != $count_elem } {
			if {[string equal "FALSE" $result] == 1 } {
				set str_elem [lindex $list_elem $index_elem]

				if { [string first "~" $str_elem] != -1 } {
					## found the ~ in the hierarchy name
					## set result to TRUE
					set result "TRUE"
				}
			}
			set index_elem [expr $index_elem + 1]
		}
	return $result
		
}

proc bus_notation_warning { do_bus_warn_msg first_node_warning array orig_node bus_notation_node } {
	upvar 1 $array bus_notation_array

	if { [string length $do_bus_warn_msg] != 0 } {
		if { [string compare $first_node_warning "TRUE"] == 0 } {
			set first_node_warning "FALSE"
			set msg "Due to differences in the way the Quartus II software interprets bus notation, conversion of your MAX+PLUS II project can create obsolete assignments. "
			append msg "To remove obsolete assignments, turn on Remove obsolete assignments in the Remove Assignments dialog box (Assignments menu) and click OK. "
			append msg "Deleted and changed assignments are reported in the maxplusii_to_quartus_name_mapping.txt file."
			show_message warning $msg
		}
		set bus_notation_array($orig_node) $bus_notation_node
	}
	return $first_node_warning
}

proc print_report { bus_mapping_file_name array entity ignore_node_list } {
	upvar 1 $array bus_notation_array

	set rt ""
	set mapping_file [open $bus_mapping_file_name w]

	# Configure report formats
    catch {::report::rmstyle simpletable}
    ::report::defstyle simpletable {} {
        data set [split "[string repeat "| " [columns]]|"]
		top set [split "[string repeat "+ - " [columns]]+"]
		bottom set [top get]
		top enable
		bottom enable
    }
    catch {::report::rmstyle captionedtable}
    ::report::defstyle captionedtable {{n 1}} {
        simpletable
        topdata   set [data get]
        topcapsep set [top get]
		topcapsep enable
        tcaption $n
    }

	# Print Legal Notice
	append rt " -- Copyright (C) 1991-2004 Altera Corporation\n"
	append rt " -- Any  megafunction  design,  and related netlist (encrypted  or  decrypted),\n"
	append rt " -- support information,  device programming or simulation file,  and any other\n"
	append rt " -- associated  documentation or information  provided by  Altera  or a partner\n"
	append rt " -- under  Altera's   Megafunction   Partnership   Program  may  be  used  only\n"
	append rt " -- to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any\n"
	append rt " -- other  use  of such  megafunction  design,  netlist,  support  information,\n"
	append rt " -- device programming or simulation file,  or any other  related documentation\n"
	append rt " -- or information  is prohibited  for  any  other purpose,  including, but not\n"
	append rt " -- limited to  modification,  reverse engineering,  de-compiling, or use  with\n"
	append rt " -- any other  silicon devices,  unless such use is  explicitly  licensed under\n"
	append rt " -- a separate agreement with  Altera  or a megafunction partner.  Title to the\n"
	append rt " -- intellectual property,  including patents,  copyrights,  trademarks,  trade\n"
	append rt " -- secrets,  or maskworks,  embodied in any such megafunction design, netlist,\n"
	append rt " -- support  information,  device programming or simulation file,  or any other\n"
	append rt " -- related documentation or information provided by  Altera  or a megafunction\n"
	append rt " -- partner, remains with Altera, the megafunction partner, or their respective\n"
	append rt " -- licensors. No other licenses, including any licenses needed under any third\n"
	append rt " -- party's intellectual property, are provided herein.\n\n"

	# Print timestamp
	append rt " -- VERSION \"$::quartus(version)\"\n"
	append rt " -- DATE \"[clock format [clock seconds] -format "%m/%d/%Y %T"]\"\n\n"

	if { [array size bus_notation_array] > 0 } {
		# Create conversion mapping matrix
		::struct::matrix mtx
		mtx add columns 2
		mtx add row [list "MAX+PLUS II node name" "Quartus II node name"]
		foreach element [lsort -dictionary [array names bus_notation_array]] {
			if { [string first ":" $element] == -1 } {
				mtx add row [list $element $bus_notation_array($element)]
				unset bus_notation_array($element)
			}
		}
		foreach element [lsort -dictionary [array names bus_notation_array]] {
			mtx add row [list $element $bus_notation_array($element)]
			unset bus_notation_array($element)
		}
		# Print conversion result
		::report::report rpt 2 style captionedtable 1
		rpt pad 0 both
		rpt pad 1 both
		append rt "Conversion results for $entity\n"
		append rt [rpt printmatrix mtx]
		append rt "\n"
		rpt destroy
		mtx destroy
	}

	if { [llength $ignore_node_list] > 0 } {
		# Print ignored node list
		append rt "Ignored node name\n"
		append rt "-----------------\n"
		foreach element $ignore_node_list {
			append rt "$element\n"
		}
	}

    puts $mapping_file $rt

	close $mapping_file
    catch {unset rt}

    return 1
}

proc validate_family_and_device { family device } {
	global old_tcl
	if { $old_tcl == 1 } {
		return [device validate_family_and_device $family $device]
	} else {
		package require ::quartus::device

		if { [string compare $device "AUTO"] == 0 } {
			if { [llength [get_part_list -family $family]] != 0 } {
				return 0
			}
		} else {
			if { [string compare [get_part_info -family $device] $family] == 0 } {
				return 0
			}
		}
	}
	return 1
}

proc set_global { entity group name value } {
	set command "set_global_assignment -name $name {$value}"
	if { [string length $entity] != 0 } {
		append command " -entity {$entity}"
	} 
	if { [string length $group] != 0 } {
		append command " -section_id {$group}"
	}
	eval $command
}

proc remove_global { entity group name } {
	set command "set_global_assignment -name $name -remove"
	if { [string length $entity] != 0 } {
		append command " -entity {$entity}"
	} 
	if { [string length $group] != 0 } {
		append command " -section_id {$group}"
	}
	eval $command
}

proc set_instance { entity group source node name value } {
	if { [string length $source] != 0 || [string length $node] != 0 } {
		set command "set_instance_assignment -name $name {$value}"
		if { [string length $entity] != 0 } {
			append command " -entity {$entity}"
		} 
		if { [string length $group] != 0 } {
			append command " -section_id {$group}"
		}
		if { [string length $source] != 0 } {
			append command " -from {$source}"
		}
		if { [string length $node] != 0 } {
			append command " -to {$node}"
		}
		eval $command
	} else {
		set_global $entity $group $name $value
	}
}

if { [string length [info procs show_message]] == 0 } {
proc show_message { message_type text } { post_message -type $message_type $text }
}
