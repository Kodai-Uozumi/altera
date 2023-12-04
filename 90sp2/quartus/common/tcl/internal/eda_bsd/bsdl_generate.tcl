package provide bsdl_gen 1.0

# *************************************************************************************************
#
# File: bsdl_generate.tcl
#
# Used by bsdl_main.tcl
#
# Description:
#               This file defines bsdl_generate namespace that generates BSDL file.
#               All data needed are taken from advanced_device package which source
#               from pin table.
#
#               Commands:
#
#                 - get_pkg_data
#                           Get the general package or the specific pin information - the package
#                           properties of the loaded device.
#
#                 - get_pad_data
#                          Get the general or pad-specific device information - the I/O die
#                          properties of the loaded device.
#
# *************************************************************************************************

namespace eval bsdl_generate {
# ----------------------------------------------------------------------------------------
#
# Description:	Define the namespace and internal variables.
#
# Warning:	All defined variables are not allowed to be accessed outside
#		this namespace!!! To access them, use the defined accessors.
#
# ----------------------------------------------------------------------------------------
	# array to store the pin information
	# array set pin_db [list {Type} [list {JTAG_Sequence Pin_Name Category Function_Name Pin Behaviour}]]
	# Type - I/O, Dedicated Pin, JTAG Ports, VCC, GND and OTHER
	# Category - in bits, out bits, inout bits or linkage bits
	# Function_Name - IO (Default for all IO pin), MSEL, CLK, TDI...etc
    #                 (Dedicated and JTAG pin - get from pin table).
    # Pin Behaviour - FAMILY_IN, FAMILY_LINKAGE, FAMILY_OUT or IO_INTEST 
	# e.g. array set pin_db [list {IO} [list {1 D4 inout IO IO_INTEST}]]
        array set pin_db {}

        # Pin Type
        set IO_STRING "I/O"
        set DEDICATED_PIN "DPIN"
        set DEDICATED_PROGRAM "Dedicated Programming"
        set DEDICATED_CLK "Dedicated Clock"
        set HSSI "Dedicated Transceiver"
        set UDCLK "UDCLK"
        set JTAG "JTAG"
        set VCC "VCC"
        set GND "GND"
        set NC "NC"
        set POST_CONFIG "Post-configuration"

        # Pin Category
        set INOUT_BIT "inout bit"
        set IN_BIT "in bit"
        set OUT_BIT "out bit"
        set LINKAGE_BIT "linkage bit"

        # List Split Character for Auxiliary Name (dedicated clk)
        set DCLK_SPLIT_CHAR ","
        set PIN_MAP_CHAR ":"

        # For Not Available
        set NOT_AVAIL "NA"
        
        # For Repeated Pin
        set OTHER "OTHER"

}

proc bsdl_generate::generate_bsdl_file { output_bsdl_file device_info_list operation} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::generate_bsdl_file
#    Description  : Core procedure to generate BSDL File
#    Input        : output_bsdl_file
#                      Output file where the content write out to
#                   device
#                      Selected device (e.g. EP3C5F256C7)
#                   device_info_list
#                      A list with device part information
#                      (0 - Family; 1 - Package; 2- Pin Count; 3 - Device without speed grade
#    Output       : None
#    Called By    : bsdl_main::main
# -------------------------------------------------------------------------------------------------
     global quartus
     global outfile

      # proses raw data and put into a list of array - pin_db
      bsdl_generate::process_data
      # process post-config data
   	  if {[string compare $operation "POST_CONFIG"] == 0 } {	
      		bsdl_generate::process_post_config_data
  	  }
  	  
  	  # Open file to output generated BSDL
  	  # Generate the ouput file only data successfully processed.
      if [catch { set outfile [open $output_bsdl_file w] } result] {
        msg_vdebug $result
        bsdl_msg::post_msg "" E_CANNOT_OPEN_OUTPUT_FILE $output_pt_script
        exit
      }
  	  
      # Generate BSDL Header
      bsdl_generate::generate_header $device_info_list
      # Generate Important Notice
      bsdl_generate::generate_notice $operation
      # Generate Port Definition
      bsdl_generate::generate_port_def $device_info_list
      # Generate Pin Mapping
      bsdl_generate::generate_pin_mapping $device_info_list
      # Generate Tap Ports Definition
      bsdl_generate::generate_tap_port
      # Generate Instruction And Register Access
      bsdl_generate::generate_instruc_reg_acc $device_info_list
      # Generate Boundary Scan Cell Information
      bsdl_generate::generate_bsc_info $device_info_list
      # Generate Design Warning
      bsdl_generate::generate_design_warning $device_info_list
}
# End bsdl_generate::generate_bsdl_file -----------------------------------------------------------

proc bsdl_generate::process_data {} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::process_data
#    Description  : Procedure to process necessary data taken from pin table. Categoried them
#                   into group IO, dedicated pin, JTAG, VCC and GND. Construct the data
#                   into a list of array - pin_db
#    Input        : None
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------
   variable pin_db

   # initial list. Pin will put into its correspond list
   set io_list ""
   set jtag_list ""
   set dedicated_list ""
   set hssi_list ""
   set nc_list ""
   set vcc_list ""
   set gnd_list ""
   set other_list ""
   set repeat_item ""

   set pin_cnt 0
   if [ catch { set pkg_cnt [get_pkg_data INT_PIN_COUNT] } result ] {
      msg_vdebug "bsdl_generate::process_data: $result"
   }
   if [ catch { set pad_cnt [get_pad_data INT_PAD_COUNT] } result ] {
      msg_vdebug "bsdl_generate::process_data: $result"
   }
   # Get the biggest for pin count
   if {[expr $pkg_cnt > $pad_cnt]} {
		set pin_cnt $pkg_cnt   
   } else {
		set pin_cnt $pad_cnt   
   }
 
   msg_vdebug "*** START bsdl_generate::process_data ***"
   
   # Traverse the whole pin list and put them into respective list
   for {set i 0} {$i < $pin_cnt} {incr i} {

       # Get JTAG Sequence (1, 2, 3...)
       set jtag_seq "$bsdl_generate::NOT_AVAIL"
       if [ catch { set jtag_seq [get_pad_data INT_JTAG_BSR_INDEX -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

       # Get User Pin Name (D1, C4, H7...)
       # For VCC and GND, pin name get by using get_pkg_data instead
       set usr_pname "$bsdl_generate::NOT_AVAIL"
       if [ catch { set usr_pname [get_pad_data STRING_USER_PIN_NAME -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }
 
       # Get User Pin Function. Used by dedicated pin and JTAG pin only
       set usr_pfunction "$bsdl_generate::NOT_AVAIL"
       if [ catch { set usr_pfunction [get_pad_data STRING_AUXILIARY_FUNCTION_NAME -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

       # Get Pin Type (Row I/O, JTAG, Dedicated Programming...)
       # For VCC and GND, get from get_pkg_data
       set pin_type "$bsdl_generate::NOT_AVAIL"
       if [ catch { set pin_type [get_pad_data STRING_TYPE_NAME -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

        # Get BST Behaviour for the pin (FAMILY_IN, FAMILY_LINKAGE, FAMILY_OUT or IO_INTEST)
        set bst_behaviour "$bsdl_generate::NOT_AVAIL"
       if [ catch { set bst_behaviour [get_pad_data INT_JTAG_BST_BEHAVIOUR_TYPE -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }
      
       set bst_behaviour "[bsdl_util::pin_behaviour_check $usr_pname $pin_type $bst_behaviour]"
        
       # By getting the BST behaviour above, map the pin category (in, inout, out, likage)
       set pin_cat [bsdl_lib::get_pin_cat $bst_behaviour]
       
       switch $pin_cat {
		
		   INOUT {
			   		set pin_cat $bsdl_generate::INOUT_BIT
				 }   
		   IN 	 {
			   		set pin_cat $bsdl_generate::IN_BIT
			     }
		   OUT   {
			   		set pin_cat $bsdl_generate::OUT_BIT
			     }   
		   LINKAGE {
			   		 set pin_cat $bsdl_generate::LINKAGE_BIT
			       }  
     	   default {
	    	   		set pin_cat $bsdl_generate::NOT_AVAIL
	    	   	   }	
		}
		
       
       # For IO pin
       if {[string match "*$bsdl_generate::IO_STRING" $pin_type]} {
          set repeat_item "[bsdl_generate::search_list $io_list $usr_pname]"
          if {$repeat_item == "-1"} {
             set function_name "IO$usr_pname"
             lappend io_list "$jtag_seq $usr_pname {$pin_cat} $function_name  $bst_behaviour"
          } else {
              lappend other_list "$jtag_seq $usr_pname {$bsdl_generate::LINKAGE_BIT} $bsdl_generate::IO_STRING $bst_behaviour"
          }
       }

       #for Dedicated pin - family specific pins
       if {[string match "$bsdl_generate::DEDICATED_PROGRAM" $pin_type] || [string match "$bsdl_generate::DEDICATED_CLK" $pin_type] ||
           [string match "$bsdl_generate::UDCLK" $pin_type] } {
           set repeat_item "[bsdl_generate::search_list $dedicated_list $usr_pname]"
           if {$repeat_item == "-1"} {
              # User pin function name for dedicated clk is embedded together with its other function name, with "," as separator
              # if found "," in usr_pfunction, get the first word for dedicated clk
              # e.g. CLK0, DIFFCLK_0p
              if {[string match "*$bsdl_generate::DCLK_SPLIT_CHAR*" $usr_pfunction]} {
                 set usr_pfunction [bsdl_util::split_lst_return_item $usr_pfunction $$bsdl_generate::DCLK_SPLIT_CHAR 0]
              }
              lappend dedicated_list "$jtag_seq $usr_pname {$pin_cat} $usr_pfunction $bst_behaviour"
           } else {
              lappend other_list "$jtag_seq $usr_pname {$bsdl_generate::LINKAGE_BIT} $usr_pfunction $bst_behaviour"
           }
       }

       # For HSSI
       if {[string match "$bsdl_generate::HSSI" $pin_type]} {
	       
	       # Take care only HSSI with bonded pin 
	       set hssi_bonded [get_pad_data BOOL_IS_BONDED -pad $i]
       	   if {$hssi_bonded} {
	       	   
	       	   if {[string match "*$bsdl_generate::DCLK_SPLIT_CHAR*" $usr_pfunction]} {
                    set usr_pfunction [bsdl_util::split_lst_return_item $usr_pfunction $$bsdl_generate::DCLK_SPLIT_CHAR 1]
                }
                
	       	   	if {[string match $jtag_seq "$bsdl_generate::NOT_AVAIL"]} {
			       	set repeat_item "[bsdl_generate::search_list $hssi_list $usr_pname]"
		           	if {$repeat_item == "-1"} {
		              	lappend hssi_list "$bsdl_generate::NOT_AVAIL $usr_pname {$bsdl_generate::LINKAGE_BIT} $usr_pfunction $bsdl_generate::NOT_AVAIL"
		           	} else {
		              	lappend other_list "$bsdl_generate::NOT_AVAIL $usr_pname {$bsdl_generate::LINKAGE_BIT} $usr_pfunction $bsdl_generate::NOT_AVAIL"
		           	}
		       	} else {
					set repeat_item "[bsdl_generate::search_list $hssi_list $usr_pname]"
		           	if {$repeat_item == "-1"} {
		              	lappend hssi_list "$jtag_seq $usr_pname {$pin_cat} $usr_pfunction $bst_behaviour"
		           	} else {
		              	lappend other_list "$jtag_seq $usr_pname {$bsdl_generate::LINKAGE_BIT} $usr_pfunction $bst_behaviour"
		           	}	       	   
			    }
		  }	       
	   }
       
       # For JTAG pin - use BOOL_IS_JTAG_PAD instead STRING_TYPE_NAME, because is unique for JTAG pin
       set is_jtag 0
       if [ catch { set is_jtag [get_pad_data BOOL_IS_JTAG_PAD -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

       set is_jtag_tms 0
       if [ catch { set is_jtag_tms [get_pad_data BOOL_IS_JTAG_TMS -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

       set is_jtag_tdi 0
       if [ catch { set is_jtag_tdi [get_pad_data BOOL_IS_JTAG_TDI -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

       set is_jtag_tck 0
       if [ catch { set is_jtag_tck [get_pad_data BOOL_IS_JTAG_TCK -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

       set is_jtag_ntrst 0
       if [ catch { set is_jtag_ntrst [get_pad_data BOOL_IS_JTAG_NTRST -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

       set is_jtag_tdo 0
       if [ catch { set is_jtag_tdo [get_pad_data BOOL_IS_JTAG_TDO -pad $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

       if { $is_jtag } {
          set repeat_item "[bsdl_generate::search_list $jtag_list $usr_pname]"
          if {$repeat_item == "-1"} {
             if { $is_jtag_tms || $is_jtag_tdi || $is_jtag_tck || $is_jtag_ntrst } {
                lappend jtag_list "$jtag_seq $usr_pname {$bsdl_generate::IN_BIT} $usr_pfunction $bst_behaviour"
             } elseif { $is_jtag_tdo } {
                lappend jtag_list "$jtag_seq $usr_pname {$bsdl_generate::OUT_BIT} $usr_pfunction $bst_behaviour"
             }
          } else {
              lappend other_list "$jtag_seq $usr_pname {$bsdl_generate::LINKAGE_BIT} $usr_pfunction $bst_behaviour"
          }
       }

       # FOR VCC, GND and NC pin
       set is_vcc 0
       if [ catch { set is_vcc [get_pkg_data BOOL_IS_VCC -pin $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }

       set is_gnd 0
       if [ catch { set is_gnd [get_pkg_data BOOL_IS_VSS -pin $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }
       
       set is_nc 0
       set nc_pin "$bsdl_generate::NOT_AVAIL"
       if [ catch { set nc_pin [get_pkg_data STRING_TYPE_NAME -pin $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       } else {
	   		if {[string match "$bsdl_generate::NC" $nc_pin]} {
                 set is_nc 1
               }
	   }
       
	  set is_bonded 1
	   if [ catch { set is_bonded [get_pkg_data BOOL_IS_BONDED -pin $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }
       
       set is_power_vref 0
	   if [ catch { set is_bonded [get_pkg_data BOOL_IS_POWER_BONDED_VREF -pin $i] } result ] {
          msg_vdebug "bsdl_generate::process_data: $result"
       }
	   
       if { $is_vcc } {
           set repeat_item "[bsdl_generate::search_list $vcc_list $usr_pname]"
           if {$repeat_item == "-1"} {
              if [ catch { set usr_pname [get_pkg_data STRING_USER_PIN_NAME -pin $i] } result ] {
                 msg_vdebug "bsdl_generate::process_data: $result"
              }
              lappend vcc_list "$bsdl_generate::NOT_AVAIL $usr_pname $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL"
           } else {
              lappend other_list "$bsdl_generate::NOT_AVAIL $usr_pname $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL"
           }
       } elseif { $is_gnd } {
           set repeat_item "[bsdl_generate::search_list $gnd_list $usr_pname]"
           if {$repeat_item == "-1"} {
              if [ catch { set usr_pname [get_pkg_data STRING_USER_PIN_NAME -pin $i] } result ] {
                 msg_vdebug "bsdl_generate::process_data: $result"
              }
              lappend gnd_list "$bsdl_generate::NOT_AVAIL $usr_pname $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL"
           } else {
              lappend other_list "$bsdl_generate::NOT_AVAIL $usr_pname $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL"
           }
       } elseif { $is_nc } {
           set repeat_item "[bsdl_generate::search_list $nc_list $usr_pname]"
           if {$repeat_item == "-1"} {
              if [ catch { set usr_pname [get_pkg_data STRING_USER_PIN_NAME -pin $i] } result ] {
                 msg_vdebug "bsdl_generate::process_data: $result"
              }
              lappend nc_list "$bsdl_generate::NOT_AVAIL $usr_pname $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL"
           } else {
              lappend other_list "$bsdl_generate::NOT_AVAIL $usr_pname $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL"
           }
       } elseif { !$is_bonded && !$is_power_vref } {
	       if [ catch { set usr_pname [get_pkg_data STRING_USER_PIN_NAME -pin $i] } result ] {
                 msg_vdebug "bsdl_generate::process_data: $result"
           }
           
           set repeat_item "[bsdl_generate::search_list $dedicated_list $usr_pname]"
           if {$repeat_item == "-1"} {
               if [ catch { set pin_function [get_pkg_data STRING_TYPE_NAME -pin $i] } result ] {
                 msg_vdebug "bsdl_generate::process_data: $result"
              }
              lappend dedicated_list "$bsdl_generate::NOT_AVAIL $usr_pname {$bsdl_generate::LINKAGE_BIT} $pin_function $bsdl_generate::NOT_AVAIL"
           } else {
              lappend other_list "$bsdl_generate::NOT_AVAIL $usr_pname {$bsdl_generate::LINKAGE_BIT} $pin_function $bsdl_generate::NOT_AVAIL"
           }
	   }
       
   
       msg_vdebug "$i. Pin Name: $usr_pname"
       msg_vdebug "--  Jtag Sequence:$jtag_seq; Type:$pin_type; Function:$usr_pfunction"
   }
   # End for loop
   
   # append to array pin_db
   array set pin_db [list $bsdl_generate::IO_STRING $io_list]
   array set pin_db [list $bsdl_generate::DEDICATED_PIN $dedicated_list]
   array set pin_db [list $bsdl_generate::HSSI $hssi_list]
   array set pin_db [list $bsdl_generate::JTAG $jtag_list]
   array set pin_db [list $bsdl_generate::VCC $vcc_list]
   array set pin_db [list $bsdl_generate::GND $gnd_list]
   array set pin_db [list $bsdl_generate::NC $nc_list]
   array set pin_db [list $bsdl_generate::OTHER $other_list]


   msg_vdebug "*** END bsdl_generate::process_data ***"
}
# End bsdl_generate::process_data -----------------------------------------------------------------

proc bsdl_generate::process_post_config_data {} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::process_post_config_data
#    Description  : Procedure to process data from pin file that will
#                   use to generate post-configuration BSDL file
#    Input        : None
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------
	
	variable pin_db
	 
	load_report
	 
	# Set panel name and get the panel id
	set panel {Fitter||Resource Section||All Package Pins}
	set panel_id    [get_report_panel_id $panel]
	
	if {$panel_id != -1} {
		# get the total number of rows for the panel
		set row_cnt [get_number_of_rows -id $panel_id]
		
		# Set the wanted column id
		# Location = user pin name
		set col_location_id [get_report_panel_column_index -id $panel_id {Location}]
		set col_pin_usage_id [get_report_panel_column_index -id $panel_id {Pin Name/Usage}]
		# Pin direction: input, output, bidir, gnd, power...etc
		set col_direction_id [get_report_panel_column_index -id $panel_id {Dir.}]
		set col_io_standard_id [get_report_panel_column_index -id $panel_id {I/O Standard}]
		
		# traverse each row of the report panel and 
		# put the data into a list: post_data_list.
		# Member of the list:{0-location, 1-pin_usage, 2-direction, 3-IO_standard}
		# e.g. {A1, ~ALTERA_DATA0~ / RESERVED_INPUT_WITH_WEAK_PULLUP, input, 2.5 V}
		set pin_file_data_list ""
		
		for {set index 1} {$index < $row_cnt} {incr index} {
		
			set location "$bsdl_generate::NOT_AVAIL"
	       	if [ catch { set location [get_report_panel_data -id $panel_id -col $col_location_id -row $index] } result ] {
	          msg_vdebug "bsdl_generate::process_post_config_data: $result"
			}
			
			set pin_usage "$bsdl_generate::NOT_AVAIL"
	       	if [ catch { set pin_usage [get_report_panel_data -id $panel_id -col $col_pin_usage_id -row $index] } result ] {
	          msg_vdebug "bsdl_generate::process_post_config_data: $result"
			}
			
			set direction "$bsdl_generate::NOT_AVAIL"
	       	if [ catch { set direction [get_report_panel_data -id $panel_id -col $col_direction_id -row $index] } result ] {
	          msg_vdebug "bsdl_generate::process_post_config_data: $result"
			}
			
			set io_standard "$bsdl_generate::NOT_AVAIL"
	       	if [ catch { set io_standard [get_report_panel_data -id $panel_id -col $col_io_standard_id -row $index] } result ] {
	          msg_vdebug "bsdl_generate::process_post_config_data: $result"
			}
			
			# set the data to the list
			lappend pin_file_data_list "$location {$pin_usage} $direction {$io_standard}"
		}
		
		# Hipothesis: post_config only involved io pin and dedicated pin. Hope this right :)
		# The idea is if the pin is affected or changed behavior, remove it from the respective list 
		# and put the modified behavior into a new list - post_list.
		
		# Get the IO list from pin_db
		set io_list "$pin_db($bsdl_generate::IO_STRING)"
		set post_list ""
		foreach io_member $io_list {
			bsdl_generate::post_config_rules_checker io_list $io_member $pin_file_data_list post_list
		}
		
		# Get the Dedicated pin list from pin_db
		set dedicated_list "$pin_db($bsdl_generate::DEDICATED_PIN)"
		foreach dpin_member $dedicated_list {
			bsdl_generate::post_config_rules_checker dedicated_list $dpin_member $pin_file_data_list post_list	
		}
		
		#puts "io_list: $io_list"
		#puts "dpin_list: $dedicated_list"
		#puts "post: $post_list"
		
		array set pin_db [list $bsdl_generate::IO_STRING $io_list]
	   	array set pin_db [list $bsdl_generate::DEDICATED_PIN $dedicated_list]
		array set pin_db [list $bsdl_generate::POST_CONFIG $post_list]
		
		unload_report
	} else {
		 bsdl_msg::post_msg "" W_NO_PIN_OUT_FILE
		 qexit
 	}
}
# End bsdl_generate::process_post_config_data -----------------------------------------------------------------
 
proc bsdl_generate::post_config_rules_checker { list_ref member pin_file_list post_config_list_ref } {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::post_config_rules_checker
#    Description  : Procedure to assign new pin behavior to the pin
#                   if rules are appied to the pin.
#    Input        : list_ref
#						One of the member of pin_db
#					member
#						member of the list_ref
#					pin_file_list
#						List consists of pin data from Quartus's pin file
#					post_config_list_ref
#						List of pin that affected by the changes                  		
#    Output       : None
#    Called By    : bsdl_generate::process_post_config_data
# -------------------------------------------------------------------------------------------------	
	upvar $list_ref main_list
	upvar $post_config_list_ref post_list
	
	set is_change 0
	
	set pin_name [lindex $member 1] 
	# See if the IO list member appear in pin file
	if {[string compare $pin_name $bsdl_generate::NOT_AVAIL] != 0 } {
		set is_in_list [lsearch $pin_file_list $pin_name*]
		# Yes, you are in the list.
		if {$is_in_list != -1} {
			# get the data from pin file
			set pin_file_data [lindex $pin_file_list $is_in_list]
			# start applying the rules	
			# #1 check the usage to the pin. pf = pin file
			# All of the following set the pin's category to LINKAGE_BIT and 
			# pin's behavior to BSC_IO_UNBOUND_TYPE
			set pf_pin_usage [lindex $pin_file_data 1]
			if { [string match "RESERVED*" $pf_pin_usage] == 1 || 
				 [string match "GND\*" $pf_pin_usage] == 1 || 
			     [string match "GND\+" $pf_pin_usage] == 1 || 
			     [string match "NC" $pf_pin_usage] == 1 || 
				 [string match "DNU" $pf_pin_usage] == 1 || 
				 [string match "VREF*" $pf_pin_usage] == 1 } {
					
					# Replace pin's category to LINKAGE
					set member [lreplace $member 2 2 "$bsdl_generate::LINKAGE_BIT"]
					# Replace pin's behaviour to BSC_IO_UNBOUND_TYPE
					set member [lreplace $member 4 4 "$bsdl_lib::BSC_IO_UNBOUND_TYPE"]	
					
					set is_change 1
			} else {
					# Get the pin's direction and IO Standard
					set pf_pin_direction [lindex $pin_file_data 2]
					set pf_io_standard [lindex $pin_file_data 3]
					# Determine the pin is positive pin or negative pin. This will use for differential IO Standard
					set is_pos_pin 1
					if {[string match "*(n)" $pf_pin_usage] == 1} {
						set is_pos_pin 0
					}
					
					if {[string compare $pf_pin_direction $bsdl_generate::NOT_AVAIL] != 0} {
						# Rules:
						# 1) For all single ended, AND All differential IO Standard on positive pin,
						#    category follow the direction.
						# 2) For mini-LVDS (LVDS, LVDS_E_1R, LVDS_E_3R), RSDS (RSDS, RSDS_E_1R, RSDS_E_3R)
						#    , AND all differential IO Standard, set the pin category to LINKAGE_BIT
						if { [string match "LVDS*" $pf_io_standard] == 1 || 
							 [string match "mini-LVDS*" $pf_io_standard] == 1 || 
							 [string match "PPDS*" $pf_io_standard] == 1 || 
							 [string match "RSDS*" $pf_io_standard] == 1 || 
							 ([string match "Differential*" $pf_io_standard] == 1 && $is_pos_pin == 0) } {
								# Replace pin's category to LINKAGE
								set member [lreplace $member 2 2 "$bsdl_generate::LINKAGE_BIT"]
								# Replace pin's behaviour to BSC_IO_UNBOUND_TYPE
								set member [lreplace $member 4 4 "$bsdl_lib::BSC_IO_UNBOUND_TYPE"]
								
								set is_change 1
						} elseif {[string match "BUS LVDS" [string toupper $pf_io_standard]] == 1} {
								# Replace pin's category to OUT_BIT
								set member [lreplace $member 2 2 "$bsdl_generate::OUT_BIT"]
								# Replace pin's behaviour to BSC_IO_UNBOUND_TYPE
								set member [lreplace $member 4 4 "$bsdl_lib::BSC_FAMILY_OUT_TYPE"]
								
								set is_change 1
						} else {
							# For Input
							if { [string match "input" $pf_pin_direction] == 1 } {
								# Replace pin's category to IN
								set member [lreplace $member 2 2 "$bsdl_generate::IN_BIT"]
								# Replace pin's behaviour to BSC_INPUT_TYPE
								set member [lreplace $member 4 4 "$bsdl_lib::BSC_INPUT_TYPE"]
								
								set is_change 1
							} elseif { [string match "output" $pf_pin_direction] == 1 } {
								# For Output
								# Replace pin's category to OUT
								set member [lreplace $member 2 2 "$bsdl_generate::OUT_BIT"]
								# Replace pin's behaviour to BSC_FAMILY_OUT_TYPE
								set member [lreplace $member 4 4 "$bsdl_lib::BSC_FAMILY_OUT_TYPE"]
								
								set is_change 1
							} elseif { [string match "bidir" $pf_pin_direction] == 1 } {
								# For Bidir
								# Replace pin's category to INOUT
								set member [lreplace $member 2 2 "$bsdl_generate::INOUT_BIT"]
								# Replace pin's behaviour to BSC_FAMILY_OUT_TYPE
								set member [lreplace $member 4 4 "$bsdl_lib::BSC_IO_TYPE"]
								
								set is_change 1
							}
						}
					}
			}
		}				
	}
	
	if {$is_change == 1} {
		# Remove item from main list
		set item_index [lsearch $main_list *$pin_name*]

		if {$item_index >= 0} {
			set main_list [lreplace $main_list $item_index $item_index]
		}
		
		# Append modified item to post_list
		lappend post_list "$member"
	}
	
}

proc bsdl_generate::generate_header { device_list } {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::generate_header
#    Description  : Procedure to print BSDL file header information, such as Copyright,
#                   BSDL version and Device.
#    Input        : device_list
#                      A list with device part information
#                      (0 - Family; 1 - Package; 2- Pin Count; 3 - Device without speed grade
#                       4 - Part)
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------

     global quartus
     global outfile

     set current_device [lindex $device_list 4]
     
     set version [bsdl_lib::get_version $device_list]
     
     # SPR270612: To have it own version control
     bsdl_util::formatted_write $outfile "
        -- $quartus(copyright)
        --
        -- This BSDL file is preliminary.
        -- BSDL Version : $version
        -- Device       : $current_device
        -- 
        -- This file is generated by Quartus $::quartus(version).
        -- This BSDL file version is as stated in the BSDL Version section above.
        --
    "
}
# End bsdl_generate::generate_header --------------------------------------------------------------

proc bsdl_generate::generate_notice {operation} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::generate_notice
#    Description  : Procedure to print BSDL file important notice, such as Altera legal statement
#    Input        : None
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------
	global quartus
	global outfile

	bsdl_util::formatted_write $outfile "
	     -- ***********************************************************************************
	     -- *                                  IMPORTANT NOTICE                               *
	     -- ***********************************************************************************
	     --
	"

	bsdl_util::wordwrap_write $outfile [get_quartus_legal_string -banner] "-- "

	# pre and post has different important notice
	if {[string compare $operation "PRE_CONFIG"] == 0 } {	
	
	    bsdl_util::formatted_write $outfile "
	             --
	             --                    **Testing After Configuration**
	             --  This file supports boundary scan testing (BST) before device
	             --  configuration.  After configuration, you should use the 
	             --  Quartus II tool to create a post-configuration BSDL file.
	             --
	        "
	} else {
			        
	    bsdl_util::formatted_write $outfile "
	             --
	             --  This file supports boundary scan testing (BST) after device
	             --  configuration.
	             --
	        "
	}	    
}
# End bsdl_generate::generate_notice --------------------------------------------------------------

proc bsdl_generate::generate_port_def { device_list} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::generate_port_def
#    Description  : Procedure to print BSDL file entity definition with ports. Get data from
#                   pin database. For each list, category them into group in bits, out bits
#                   inout bits or linkage bits. Print to output file.
#    Input        : device_list
#                      A list with device part information
#                      (0 - Family; 1 - Package; 2- Pin Count; 3 - Device without speed grade
#                       4 - Part)
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------
	global outfile
        variable pin_db

        set device_family [lindex $device_list 0]
        set device_pack [lindex $device_list 1]
        set device_pin_cnt [lindex $device_list 2]
        set device_part [lindex $device_list 3]

        bsdl_util::formatted_write $outfile "
             --
             -- ***********************************************************************************
             -- *                            ENTITY DEFINITION WITH PORTS                         *
             -- ***********************************************************************************

             entity $device_part is
                    generic (PHYSICAL_PIN_MAP : string := \"$device_pack$device_pin_cnt\");

             port (
       "
       
       # Get each item from pin_db
       # Category item into in bits, out bit, inout bit or linkage bit
       set io_in ""
       set io_out ""
       set io_inout ""
       set io_linkage ""
        
       set dpin_in ""
       set dpin_out ""
       set dpin_inout ""
       set dpin_linkage ""
       
       set hssi_in ""
       set hssi_out ""
       set hssi_inout ""
       set hssi_linkage ""
       
       set post_in ""
       set post_out ""
       set post_inout ""
       set post_linkage ""
       
       set jtag_in ""
       set jtag_out ""
       set jtag_inout ""
       set jtag_linkage ""
       
       set nc_cnt 0
       set vcc_cnt 0
       set gnd_cnt 0
       
       foreach {group member} [array get pin_db] {
           # for IO
           if {[string compare $group $bsdl_generate::IO_STRING] == 0} {
              bsdl_generate::get_cat_list io_in io_out io_inout io_linkage $member
           }

           # for Dedicated Pin
           if {[string compare $group $bsdl_generate::DEDICATED_PIN] == 0} {
               bsdl_generate::get_cat_list dpin_in dpin_out dpin_inout dpin_linkage $member
           }
           
           # for HSSI Pin
           if {[string compare $group $bsdl_generate::HSSI] == 0} {
               bsdl_generate::get_cat_list hssi_in hssi_out hssi_inout hssi_linkage $member
           }

           # for Modified Pins
           if {[string compare $group $bsdl_generate::POST_CONFIG] == 0} {
               bsdl_generate::get_cat_list post_in post_out post_inout post_linkage $member
           }

           # for JTAG
           if {[string compare $group $bsdl_generate::JTAG] == 0} {
               bsdl_generate::get_cat_list jtag_in jtag_out jtag_inout jtag_linkage $member
           }
           
           # for NC - get the total number of NC pin. that's it
           if {[string compare $group $bsdl_generate::NC] == 0} {
              set nc_cnt [llength $member]
           }
           
           # for VCC - get the total number of VCC pin. that's it
           if {[string compare $group $bsdl_generate::VCC] == 0} {
              set vcc_cnt [llength $member]
           }

           # for gnd - get the total number of GND pin, that's it
           if {[string compare $group $bsdl_generate::GND] == 0} {
              set gnd_cnt [llength $member]
           }
           
       }
       # End foreach

       # Write to output file
       # For IO
       if {[string compare $io_inout ""] !=0  || [string compare $io_in ""] != 0 ||
           [string compare $io_out ""] !=0 || [string compare $io_linkage ""] != 0 } {
          bsdl_util::formatted_write $outfile "
                         --I/O Pins
          "

          if {[string compare $io_inout ""] != 0} {
             bsdl_util::wordwrap_text io_inout "\t" "" "." "6"
             bsdl_util::replace_last_char io_inout "," ": $bsdl_generate::INOUT_BIT;"
             bsdl_util::replace_last_char io_inout "\n" ""
             puts $outfile $io_inout
          }

          if {[string compare $io_in ""] != 0} {
             bsdl_util::wordwrap_text io_in "\t" "" "." "6"
             bsdl_util::replace_last_char io_in "," ": $bsdl_generate::IN_BIT;"
             bsdl_util::replace_last_char io_in "\n" ""
             puts $outfile $io_in
          }

          if {[string compare $io_out ""] != 0} {
            bsdl_util::wordwrap_text io_out "\t" "" "." "6"
            bsdl_util::replace_last_char io_out "," ": $bsdl_generate::OUT_BIT;"
            bsdl_util::replace_last_char io_out "\n" ""
            puts $outfile $io_out
          }

          if {[string compare $io_linkage ""] != 0} {
             bsdl_util::wordwrap_text io_linkage "\t" "" "." "6"
             bsdl_util::replace_last_char io_linkage "," ": $bsdl_generate::LINKAGE_BIT;"
             bsdl_util::replace_last_char io_linkage "\n" ""
             puts $outfile $io_linkage
          }
       }

       # For family specific pin
       if {[string compare $dpin_inout ""] != 0 || [string compare $dpin_in ""] != 0 ||
            [string compare $dpin_out ""] != 0 || [string compare $dpin_linkage ""] != 0 } {

           bsdl_util::formatted_write $outfile "
                         --[string toupper device_family] Family-Specific Pins
           "

           if {[string compare $dpin_inout ""] != 0} {
             bsdl_util::wordwrap_text dpin_inout "\t" "" "." "6"
             bsdl_util::replace_last_char dpin_inout "," ": $bsdl_generate::INOUT_BIT;"
             bsdl_util::replace_last_char dpin_inout "\n" ""
             puts $outfile $dpin_inout
          }

          if {[string compare $dpin_in ""] != 0} {
             bsdl_util::wordwrap_text dpin_in "\t" "" "." "6"
             bsdl_util::replace_last_char dpin_in "," ": $bsdl_generate::IN_BIT;"
             bsdl_util::replace_last_char dpin_in "\n" ""
             puts $outfile $dpin_in
          }

          if {[string compare $dpin_out ""] != 0} {
            bsdl_util::wordwrap_text dpin_out "\t" "" "." "6"
            bsdl_util::replace_last_char dpin_out "," ": $bsdl_generate::OUT_BIT;"
            bsdl_util::replace_last_char dpin_out "\n" ""
            puts $outfile $dpin_out
          }

          if {[string compare $dpin_linkage ""] != 0} {
             bsdl_util::wordwrap_text dpin_linkage "\t" "" "." "6"
             bsdl_util::replace_last_char dpin_linkage "," ": $bsdl_generate::LINKAGE_BIT;"
             bsdl_util::replace_last_char dpin_linkage "\n" ""
             puts $outfile $dpin_linkage
          }
       }

       # For HSSI pin
       if {[string compare $hssi_inout ""] != 0 || [string compare $hssi_in ""] != 0 ||
            [string compare $hssi_out ""] != 0 || [string compare $hssi_linkage ""] != 0 } {

           bsdl_util::formatted_write $outfile "
                         --HSSI Pins
           "

           if {[string compare $hssi_inout ""] != 0} {
             bsdl_util::wordwrap_text hssi_inout "\t" "" "." "6"
             bsdl_util::replace_last_char hssi_inout "," ": $bsdl_generate::INOUT_BIT;"
             bsdl_util::replace_last_char hssi_inout "\n" ""
             puts $outfile $hssi_inout
          }

          if {[string compare $hssi_in ""] != 0} {
             bsdl_util::wordwrap_text hssi_in "\t" "" "." "6"
             bsdl_util::replace_last_char hssi_in "," ": $bsdl_generate::IN_BIT;"
             bsdl_util::replace_last_char hssi_in "\n" ""
             puts $outfile $hssi_in
          }

          if {[string compare $hssi_out ""] != 0} {
            bsdl_util::wordwrap_text hssi_out "\t" "" "." "6"
            bsdl_util::replace_last_char hssi_out "," ": $bsdl_generate::OUT_BIT;"
            bsdl_util::replace_last_char hssi_out "\n" ""
            puts $outfile $hssi_out
          }

          if {[string compare $hssi_linkage ""] != 0} {
             bsdl_util::wordwrap_text hssi_linkage "\t" "" "." "6"
             bsdl_util::replace_last_char hssi_linkage "," ": $bsdl_generate::LINKAGE_BIT;"
             bsdl_util::replace_last_char hssi_linkage "\n" ""
             puts $outfile $hssi_linkage
          }
       }
       
        # For Modified Pins
       if {[string compare $post_inout ""] != 0 || [string compare $post_in ""] != 0 ||
            [string compare $post_out ""] != 0 || [string compare $post_linkage ""] != 0 } {

           bsdl_util::formatted_write $outfile "
                         --Modified input-output pins
           "

           if {[string compare $post_inout ""] != 0} {
             bsdl_util::wordwrap_text post_inout "\t" "" "." "6"
             bsdl_util::replace_last_char post_inout "," ": $bsdl_generate::INOUT_BIT;"
             bsdl_util::replace_last_char post_inout "\n" ""
             puts $outfile $post_inout
          }

          if {[string compare $post_in ""] != 0} {
             bsdl_util::wordwrap_text post_in "\t" "" "." "6"
             bsdl_util::replace_last_char post_in "," ": $bsdl_generate::IN_BIT;"
             bsdl_util::replace_last_char post_in "\n" ""
             puts $outfile $post_in
          }

          if {[string compare $post_out ""] != 0} {
            bsdl_util::wordwrap_text post_out "\t" "" "." "6"
            bsdl_util::replace_last_char post_out "," ": $bsdl_generate::OUT_BIT;"
            bsdl_util::replace_last_char post_out "\n" ""
            puts $outfile $post_out
          }

          if {[string compare $post_linkage ""] != 0} {
             bsdl_util::wordwrap_text post_linkage "\t" "" "." "6"
             bsdl_util::replace_last_char post_linkage "," ": $bsdl_generate::LINKAGE_BIT;"
             bsdl_util::replace_last_char post_linkage "\n" ""
             puts $outfile $post_linkage
          }
       }
       
       # For JTAG
       if {[string compare $jtag_inout ""] != 0 || [string compare $jtag_in ""] != 0 ||
            [string compare $jtag_out ""] != 0 || [string compare $jtag_linkage ""] != 0 } {

           bsdl_util::formatted_write $outfile "
                         --JTAG Ports
           "

           if {[string compare $jtag_inout ""] != 0} {
             bsdl_util::wordwrap_text jtag_inout "\t" "" "." "6"
             bsdl_util::replace_last_char jtag_inout "," ": $bsdl_generate::INOUT_BIT;"
             bsdl_util::replace_last_char jtag_inout "\n" ""
             puts $outfile $jtag_inout
          }

          if {[string compare $jtag_in ""] != 0} {
             bsdl_util::wordwrap_text jtag_in "\t" "" "." "6"
             bsdl_util::replace_last_char jtag_in "," ": $bsdl_generate::IN_BIT;"
             bsdl_util::replace_last_char jtag_in "\n" ""
             puts $outfile $jtag_in
          }

          if {[string compare $jtag_out ""] != 0} {
            bsdl_util::wordwrap_text jtag_out "\t" "" "." "6"
            bsdl_util::replace_last_char jtag_out "," ": $bsdl_generate::OUT_BIT;"
            bsdl_util::replace_last_char jtag_out "\n" ""
            puts $outfile $jtag_out
          }

          if {[string compare $jtag_linkage ""] != 0} {
             bsdl_util::wordwrap_text jtag_linkage "\t" "" "." "6"
             bsdl_util::replace_last_char jtag_linkage "," ": $bsdl_generate::LINKAGE_BIT;"
             bsdl_util::replace_last_char jtag_linkage "\n" ""
             puts $outfile $jtag_linkage
          }
       }

       # For Not Connected Pins
       if { [string compare $nc_cnt 0] != 0 } {

           bsdl_util::formatted_write $outfile "
                         --No Connect Pins
           "
           puts $outfile "\t$bsdl_generate::NC\t: ${bsdl_generate::LINKAGE_BIT}_vector (1 to $nc_cnt);"
        }
        
       # For Power Pins
       if { [string compare $vcc_cnt 0] != 0 } {

           bsdl_util::formatted_write $outfile "
                         --Power Pins
           "
           puts $outfile "\t$bsdl_generate::VCC\t: ${bsdl_generate::LINKAGE_BIT}_vector (1 to $vcc_cnt);"
        }
       
       # For Ground Pins
       if { [string compare $gnd_cnt 0] != 0 } {

           bsdl_util::formatted_write $outfile "
                         --Ground Pins
           "
           puts $outfile "\t$bsdl_generate::GND\t: ${bsdl_generate::LINKAGE_BIT}_vector (1 to $gnd_cnt)"
        }

       # End of port
       bsdl_util::formatted_write $outfile "
                         );

                         use STD_1149_1_1994.all;
                         
                         attribute COMPONENT_CONFORMANCE of $device_part :
                                   entity is \"STD_1149_1_1993\";

       "

}
# End bsdl_generate::generate_port_def ------------------------------------------------------------

proc bsdl_generate::generate_pin_mapping {device_list} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::generate_pin_mapping
#    Description  : Procedure to print BSDL file pin mapping. Get data from pin database.
#                   map each element in each list to its element's pin name. Mapping
#                   is 1 to 1. Except VCC and GND, mapping is 1 to many
#    Input        : device_list
#                      A list with device part information
#                      (0 - Family; 1 - Package; 2- Pin Count; 3 - Device without speed grade
#                       4 - Part)
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------
       global outfile
       variable pin_db

       set device_family [lindex $device_list 0]
       set device_pack [lindex $device_list 1]
       set device_pin_cnt [lindex $device_list 2]
       set device_part [lindex $device_list 3]

       bsdl_util::formatted_write $outfile "
            -- ***********************************************************************************
            -- *                                    PIN MAPPING                                  *
            -- ***********************************************************************************

            attribute PIN_MAP of $device_part : entity is PHYSICAL_PIN_MAP;
            constant $device_pack$device_pin_cnt : PIN_MAP_STRING :=
       "

       # For IO
       if [info exist pin_db($bsdl_generate::IO_STRING)] {
       		set member "$pin_db($bsdl_generate::IO_STRING)"
       		if {[string compare $member ""] != 0} {

          		set pin_map ""

          		bsdl_generate::map_pin pin_map $member
          		if {$pin_map != ""} {
	          
          				bsdl_util::formatted_write $outfile "
                        		--I/O Pins
          				"
          				bsdl_util::wordwrap_write $outfile $pin_map "\t\"" " \"&" "." "4"
      	  		}
       		}
	   }
	   
	   # For Family Specific Pins
	   if [info exist pin_db($bsdl_generate::DEDICATED_PIN)] {
	      
	       set member "$pin_db($bsdl_generate::DEDICATED_PIN)"
	       if {[string compare $member ""] != 0} {
	
	          set pin_map ""
	
	          bsdl_generate::map_pin pin_map $member
	          if {$pin_map != ""} {
					bsdl_util::formatted_write $outfile "
	                        --[lindex $device_list 0] Family-Specific Pins
	          		"
		      		bsdl_util::wordwrap_write $outfile $pin_map "\t\"" " \"&" "." "3"    
	          }
	       }
       }
       
       # For HSSI Pins
	   if [info exist pin_db($bsdl_generate::HSSI)] {
	      
	       set member "$pin_db($bsdl_generate::HSSI)"
	       if {[string compare $member ""] != 0} {
	
	          set pin_map ""
	
	          bsdl_generate::map_pin pin_map $member
	          if {$pin_map != ""} {
					bsdl_util::formatted_write $outfile "
	                        --HSSI Pins
	          		"
		      		bsdl_util::wordwrap_write $outfile $pin_map "\t\"" " \"&" "." "3"    
	          }
	       }
       }

       # For Modified Pins
       if [info exist pin_db($bsdl_generate::POST_CONFIG)] {
	       set member "$pin_db($bsdl_generate::POST_CONFIG)"
	       if {[string compare $member ""] != 0} {
	
	          set pin_map ""
	
	          bsdl_generate::map_pin pin_map $member
	          if {$pin_map != ""} {
					bsdl_util::formatted_write $outfile "
	                        --Modified input-output pins
	          		"	          
		          	bsdl_util::wordwrap_write $outfile $pin_map "\t\"" " \"&" "." "3"
	      	  }
	       }
	   }
	   
       # For JTAG
       if [info exist pin_db($bsdl_generate::JTAG)] {
	       set member "$pin_db($bsdl_generate::JTAG)"
	       if {[string compare $member ""] != 0} {
	
	          set pin_map ""
	
	          bsdl_generate::map_pin pin_map $member
	          if {$pin_map != ""} {
					bsdl_util::formatted_write $outfile "
	                        --JTAG ports
	          		"      
		          	bsdl_util::wordwrap_write $outfile $pin_map "\t\"" " \"&" "." "4"
	      	  }
	       }
	   }
	   
       # For NC
       if [info exist pin_db($bsdl_generate::NC)] {
	       set member "$pin_db($bsdl_generate::NC)"
	       if {[string compare $member ""] != 0} {
	
	          set pin_map ""
	
	          bsdl_generate::get_pin_name_list pin_map $member
	          if {$pin_map != ""} {
	          		bsdl_util::formatted_write $outfile "
	                        --No Connect Pins
	          		"
	          
	          		bsdl_util::wordwrap_text pin_map "\t\"" " \"&" "." "7"
	          		bsdl_util::replace_first_char pin_map "\"" "\"NC    : ("
	          		bsdl_util::replace_last_char pin_map "," "),"
	          		bsdl_util::replace_last_char pin_map "\n" ""
	          		puts $outfile $pin_map
	      	  }
	       }
   	   }
   	   
       # For VCC
       if [info exist pin_db($bsdl_generate::VCC)] {
	       set member "$pin_db($bsdl_generate::VCC)"
	       if {[string compare $member ""] != 0} {
	
	          set pin_map ""
	
	          
	
	          bsdl_generate::get_pin_name_list pin_map $member
	          if {$pin_map != ""} {
	          
		          	bsdl_util::formatted_write $outfile "
	                        --Power Pins
	          		"
		          
		          	bsdl_util::wordwrap_text pin_map "\t\"" " \"&" "." "7"
	          		bsdl_util::replace_first_char pin_map "\"" "\"VCC    : ("
	         	 	bsdl_util::replace_last_char pin_map "," "),"
	          		bsdl_util::replace_last_char pin_map "\n" ""
	          		puts $outfile $pin_map
	      	  }
	       }
       }
       
       # For GND
       if [info exist pin_db($bsdl_generate::GND)] {
	       set member "$pin_db($bsdl_generate::GND)"
	       if {[string compare $member ""] != 0} {
	
	          set pin_map ""
	
	          
	
	          bsdl_generate::get_pin_name_list pin_map $member
	          if {$pin_map != ""} {
	          
		          	bsdl_util::formatted_write $outfile "
	                        --GROUND Pins
	          		"
	          		
	          		bsdl_util::wordwrap_text pin_map "\t\"" " \"&" "." "7"
	          		bsdl_util::replace_first_char pin_map "\"" "\"GND    : ("
	          		bsdl_util::replace_last_char pin_map "," ")"
	          		bsdl_util::replace_last_char pin_map "&" ";"
	          		bsdl_util::replace_last_char pin_map "\n" ""
	          		puts $outfile $pin_map
	      	  }
	       }
       }
}
# End bsdl_generate::generate_pin_mapping ---------------------------------------------------------

proc bsdl_generate::generate_tap_port {} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::generate_tap_port
#    Description  : Procedure to print BSDL file IEEE 1149.1 Tap Ports. Get the JTAG ports
#                   from pin database. Print out its IEEE standard port.
#    Input        : None
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------
     global outfile
     variable pin_db

     bsdl_util::formatted_write $outfile "

          -- ***********************************************************************************
          -- *                              IEEE 1149.1 TAP PORTS                              *
          -- ***********************************************************************************

     "

     set jtag_member "$pin_db($bsdl_generate::JTAG)"

     if {[lsearch $jtag_member "*TDI*"] >= 0} {
        bsdl_util::formatted_write $outfile "
                       attribute TAP_SCAN_IN of TDI     : signal is true;
        "
     }
     if {[lsearch $jtag_member "*TMS*"] >= 0} {
        bsdl_util::formatted_write $outfile "
                       attribute TAP_SCAN_MODE of TMS   : signal is true;
        "
     }
     if {[lsearch $jtag_member "*TDO*"] >= 0} {
        bsdl_util::formatted_write $outfile "
                       attribute TAP_SCAN_OUT of TDO    : signal is true;
        "
     }
     if {[lsearch $jtag_member "*TCK*"] >= 0} {
        bsdl_util::formatted_write $outfile "
                       attribute TAP_SCAN_CLOCK of TCK  : signal is (10.00e6,BOTH);
        "
     }
     if {[lsearch $jtag_member "*TRST*"] >= 0} {
        bsdl_util::formatted_write $outfile "
                       attribute TAP_SCAN_RESET of TRST : signal is true;
        "
     }
}
# End bsdl_generate::generate_tap_port ------------------------------------------------------------

proc bsdl_generate::generate_instruc_reg_acc {device_list} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::generate_instruc_reg_acc
#    Description  : Procedure to print BSDL file instruction and register access.
#    Input        : device_list
#                      A list with device part information
#                      (0 - Family; 1 - Package; 2- Pin Count; 3 - Device without speed grade
#                       4 - Part
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------
     global outfile

     bsdl_util::formatted_write $outfile "

          -- ***********************************************************************************
          -- *                          INSTRUCTIONS AND REGISTER ACCESS                       *
          -- ***********************************************************************************

     "

     set current_device [lindex $device_list 4]
     set part [get_part_info -device $current_device]
     set device_debug [get_dstr_string -debug -device $part]
     
     # Device without speed grade
     set device [lindex $device_list 3]
     
     # Get family debug name
     set family [lindex $device_list 0]
     set family_dbg [get_dstr_string -debug -family $family]
     
     switch $family_dbg {
	     TGX 
	     { 
		     set txt "[bsdl_lib::get_tgx_reg_instruction $device_debug $device]" 
		 }
		 
		 HCX
		 {
			 set txt "[bsdl_lib::get_hcx_reg_instruction $device_debug $device]" 
		 }
		 
		 HCXIV
		 {
			 set txt "[bsdl_lib::get_hcxiv_reg_instruction $device_debug $device]" 
		 }
 		 TARPON
		 {
			 set txt "[bsdl_lib::get_tarpon_reg_instruction $device_debug $device]" 
		 }
		 
		 default
		 {
			 set txt "This information is currently not available for $family."
		 }
	 }
     
     
     puts $outfile $txt

}
# End bsdl_generate::generate_instruc_reg_acc -----------------------------------------------------

proc bsdl_generate::generate_bsc_info {device_list} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::generate_bsc_info
#    Description  : Procedure to print BSDL file boundary scan cell information. Get data from
#                   pin database. For each element in the list, print out the bsc information
#                   in descensing order of JTAG sequence
#    Input        : device_list
#                      A list with device part information
#                      (0 - Family; 1 - Package; 2- Pin Count; 3 - Device without speed grade
#                       4 - Part)
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------
     global outfile
     variable pin_db

     set jtag_bsc_cnt 0
     if [ catch { set jtag_bsc_cnt [get_pad_data INT_JTAG_BSR_COUNT] } result ] {
        msg_vdebug "bsdl_generate::process_data: $result"
     }

     set family [lindex $device_list 0]
     set device [lindex $device_list 3]

     bsdl_util::formatted_write $outfile "

          -- ***********************************************************************************
          -- *                           BOUNDARY SCAN CELL INFORMATION                        *
          -- ***********************************************************************************

                      attribute BOUNDARY_LENGTH of $device : entity is [expr $jtag_bsc_cnt*3];
                      attribute BOUNDARY_REGISTER of $device : entity is
     "

     # Combine pin that has jtag sequence into a list
     set all_pin_list ""
     foreach {group member} [array get pin_db] {
        foreach list_item $member {
           set jtag_seq_avail [lindex $list_item 0]
           if {[string compare $jtag_seq_avail $bsdl_generate::NOT_AVAIL] != 0} {
              lappend all_pin_list $list_item
           }
        }
     }
     
      # Sort the list in descending order based on JTAG Sequence
     set all_pin_list [lsort -decreasing -integer -index 0 $all_pin_list]
     
     set index 0
     set list_length [llength $all_pin_list]
     set is_last 0
	
     # get the JTAG sequence for first item 
     set previous_sequence [lindex [lindex $all_pin_list 0] 0]
     
     foreach item $all_pin_list {
      
        set bsc_group [lindex $item 4]
        set current_sequence [lindex $item 0]
        
        if {[string compare $index [expr $list_length-1]] == 0} {
           set is_last 1
        }
        
        if {!$is_last} {
	        if {[expr $previous_sequence <= [expr $current_sequence+1]]} {
	        	set previous_sequence [lindex $item 0]
        	} else {
	        	# Handle missing JTAG sequence, treat as linkage
	        	# Possible more than one in a row
	        	set previous_sequence [expr $previous_sequence-1]
	        	while {$previous_sequence != $current_sequence} {	
	        		# Create one for it
	        		set temp_list "{[expr $previous_sequence-1] $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL}"
	    			set temp_grp $bsdl_lib::BSC_IO_UNBOUND_TYPE
	        		bsdl_lib::bsc_type_write $outfile $temp_list $temp_grp $index $family $is_last    	
	    			incr index
	    			incr list_length
	    			set previous_sequence [expr $previous_sequence-1]
    			}
	        }
	        
	        bsdl_lib::bsc_type_write $outfile $item $bsc_group $index $family $is_last
        	incr index
	    } else {
	    	# This is to handle case where the JTAG sequence not end with 1
			if {![expr $current_sequence == 1]} {
				# Reset the is_last counter
				set is_last 0
				
				bsdl_lib::bsc_type_write $outfile $item $bsc_group $index $family $is_last
		    		incr index
		    
				# Set the current sequence to 1
				set current_sequence 1
				set previous_sequence [expr $previous_sequence-1]
	        		while {$previous_sequence != $current_sequence} {	
	        			if ([expr [expr $previous_sequence-1] == $current_sequence]) {
	        				set is_last 1
		        		}
		        		# Create one for each
	       				set temp_list "{[expr $previous_sequence-1] $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL $bsdl_generate::NOT_AVAIL}"
	    				set temp_grp $bsdl_lib::BSC_IO_UNBOUND_TYPE
	       				bsdl_lib::bsc_type_write $outfile $temp_list $temp_grp $index $family $is_last    	
	    				incr index
	    				incr list_length
	    				set previous_sequence [expr $previous_sequence-1]
    				}
			} else {
				# Add the last one
		    		bsdl_lib::bsc_type_write $outfile $item $bsc_group $index $family $is_last
		    		incr index
			}
			
		} 
     }
}
# End bsdl_generate::generate_bsc_info ------------------------------------------------------------

proc bsdl_generate::generate_design_warning {device_list} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::generate_design_warning
#    Description  : Procedure to print BSDL file design warning.
#    Input        : device_list
#                      A list with device part information
#                      (0 - Family; 1 - Package; 2- Pin Count; 3 - Device without speed grade
#                       4 - Part)
#    Output       : None
#    Called By    : bsdl_generate::generate_bsdl_file
# -------------------------------------------------------------------------------------------------
     global outfile

     set family [lindex $device_list 0]
     set device [lindex $device_list 3]

     set warn_str "[bsdl_lib::get_design_warning $family]"

     bsdl_util::formatted_write $outfile "

          -- ***********************************************************************************
          -- *                                   DESIGN WARNING                                *
          -- ***********************************************************************************

          attribute DESIGN_WARNING of $device : entity is
          \"This $device BSDL file supports 1149.1 testing before device\"&
          \"configuration.  Boundary scan testing with differential pin\"&
          \"pairs after configuration requires changes to this file.  Please\"&
          \"read the comments at the top of the file for further instruction.\"$warn_str

          end $device;
     "
}
# End bsdl_generate::generate_design_warning ------------------------------------------------------

proc bsdl_generate::get_cat_list {in_ref out_ref inout_ref linkage_ref list {option_index 3} {option_text ""} {width 10} } {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::get_cat_list
#    Description  : Procedure to append the list element into its respective list.
#    Input        : in_ref
#                      A list for in bits pin.
#                   out_ref
#                      A list for out bits pin
#                   inout_ref
#                      A list for inout bits pin
#                   linkage_ref
#                      A list for linkage bits pin
#                   list
#                      A input list
#                   option_index
#                      Index to get list element. Default is 3
#                   option_text
#                      Text. Default is empty
#                   width
#                      String width for string format. Default is 10
#    Output       : Result return via reference
# -------------------------------------------------------------------------------------------------
     upvar $in_ref in
     upvar $out_ref out
     upvar $inout_ref inout
     upvar $linkage_ref linkage

     foreach list_item $list {
        if {[string compare [lindex $list_item 1] $bsdl_generate::NOT_AVAIL] != 0} {
            set function_name "$option_text[lindex $list_item $option_index]"
            set pin_cat [lindex $list_item 2]
            # "." added to the end of the txt. Used by wordwrap_write later
            set txt [format "%-*s%0s." $width $function_name $bsdl_generate::DCLK_SPLIT_CHAR]

            if {[string compare $pin_cat $bsdl_generate::INOUT_BIT] == 0} {
               append inout $txt
            } elseif {[string compare $pin_cat $bsdl_generate::IN_BIT] == 0} {
               append in $txt
            } elseif {[string compare $pin_cat $bsdl_generate::OUT_BIT] == 0} {
               append out $txt
            } elseif {[string compare $pin_cat $bsdl_generate::LINKAGE_BIT] == 0} {
               append linkage $txt
            }
        }
    }
}
# End bsdl_generate::get_cat_list -----------------------------------------------------------------

proc bsdl_generate::map_pin { map_ref list {option_index 3} {option_text ""} {width 10} {width2 5}} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::map_pin
#    Description  : Procedure to map pin to its pin name or function name.
#    Input        : map_ref
#                      A list for mapped pin.
#                   list
#                      A input list
#                   option_index
#                      Index to get list element. Default is 3
#                   option_text
#                      Text. Default is empty
#                   width
#                      String width for string format. Default is 10
#                   width2
#                      String width for string format. Default is 5
#    Output       : Result return via reference
# -------------------------------------------------------------------------------------------------
     upvar $map_ref map

     foreach list_item $list {
        if {[string compare [lindex $list_item 1] $bsdl_generate::NOT_AVAIL] != 0} {
           set function_name "$option_text[lindex $list_item $option_index]"
           set pin_name "[lindex $list_item 1]"
           set txt [format "%-*s%0s %-*s%0s." $width $function_name $bsdl_generate::PIN_MAP_CHAR \
                                              $width2 $pin_name $bsdl_generate::DCLK_SPLIT_CHAR]

           append map $txt
        }
     }
}
# End bsdl_generate::map_pin ----------------------------------------------------------------------

proc bsdl_generate::get_pin_name_list {text_ref list {width 5} } {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::get_pin_name_list
#    Description  : Procedure to get the pin name of the input item.
#    Input        : text_ref
#                      A list of pin name.
#                   list
#                      A input list
#                   width
#                      String width for string format. Default is 5
#    Output       : Result return via reference
# -------------------------------------------------------------------------------------------------
     upvar $text_ref text

     foreach list_item $list {
        set pin_name [lindex $list_item 1]
        set txt [format "%-*s%0s." $width $pin_name $bsdl_generate::DCLK_SPLIT_CHAR]

        append text $txt
     }
}
# End bsdl_generate::get_pin_name_list ------------------------------------------------------------

proc bsdl_generate::search_list {list item} {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_generate::search_list
#    Description  : Procedure to search item in provided list. Return the index of the item 
#                   in the list
#    Input        : list
#                      A list.
#                   item
#                      A search item
#    Output       : Return the index of the item searched, else return -1
# -------------------------------------------------------------------------------------------------
     
     foreach list_item $list {
        set result [lsearch $list_item $item]
        if { ![string match $item $bsdl_generate::NOT_AVAIL]} {
            if {[lsearch $list_item $item] >= 0 } {
                 return $result
            }
        }
     }

     return -1
}
# End bsdl_generate::search_list ------------------------------------------------------------------