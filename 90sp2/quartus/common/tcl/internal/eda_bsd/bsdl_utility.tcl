package provide bsdl_gen 1.0

# **************************************************************************
#
#	Namespace bsdl_util
#
# **************************************************************************


namespace eval bsdl_util {
# --------------------------------------------------------------------------
#
# Description:	Define the utility namespace and APIs.
#
# Warning:      All defined variables are not allowed to be accessed outside
#		this namespace!!! To access them, use the defined accessors.
#
# --------------------------------------------------------------------------
#	No variable defined.
}


proc bsdl_util::formatted_write { ostream text } {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_util::formatted_write
#    Description  : Procedure to write the formatted text to specified ostream. The formatted text
#                   is parsed by eda_pt_util::parse_formatted_text.
#    Input        : ostream
#                      output stream
#                   text
#                      Text to output to ostream
#    Output       : None
# -------------------------------------------------------------------------------------------------

	bsdl_util::parse_formatted_text "text"
	puts -nonewline $ostream $text
}
# End bsdl_util::formatted_write ------------------------------------------------------------------

proc bsdl_util::parse_formatted_text { text_ref } {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_util::parse_formatted_text
#    Description  : Procedure to parse the formatted text.
#                   - Ignore the first line;
#                   - Ignore the last line;
#                   - Filter off leading white spaces (spaces and tabs) from each line;
#                   - Filter off the leading '^' character from each line;
#                   - Return the result via reference.
#    Input        : text_ref
#                      Formatted text that need to parse
#    Output       : Return the result via reference.
# -------------------------------------------------------------------------------------------------

	upvar $text_ref text

	set lines [split $text "\n"]
	set cnt [llength $lines]
	set max_line_num [expr $cnt - 1]
	set text ""
	for {set i 1} {$i < $max_line_num} {incr i} {
		set tmp_str [string trimleft [lindex $lines $i]]
		if {[string range $tmp_str 0 0] == "^"} {
			append text [string replace $tmp_str 0 0] "\n"
		} else {
			append text $tmp_str "\n"
		}
	}
}
# End bsdl_util::parse_formatted_text -------------------------------------------------------------

proc bsdl_util::wordwrap_write { ostream text {head_symbol ""} {tail_symbol ""} {split_char " "} {split_length 10} } {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_util::wordwrap_write
#    Description  : Procedure to write the wordwrapped formatted text to specified ostream. The formatted text
#                   is wordwrap by bsdl_util::wordwrap_text.
#    Input        : ostream
#                      output stream
#                   text
#                      Text to output to ostream
#                   head_symbol
#                      Option argument. symbol add to front of each line
#                      Default is empty
#                   tail_symbol
#                      Option argument. Symbol add to end of each line
#                      Defaul is empty
#                   split_char
#                      Pattern character use to split line
#                      Default is white space
#                   split_legth
#                      Split line at string specified by this variable
#                      Default is 10
#    Output       : None
# -------------------------------------------------------------------------------------------------
        bsdl_util::wordwrap_text "text" $head_symbol $tail_symbol $split_char $split_length
        puts -nonewline $ostream $text
}
# End bsdl_util::wordwrap_write -------------------------------------------------------------------

proc bsdl_util::wordwrap_text { text_ref {head_symbol ""} {tail_symbol ""} {split_char " "} {split_length 10} } {
# -------------------------------------------------------------------------------------------------
#    Function Name: bsdl_util::wordwrap_text
#    Description  : Procedure to wordwrap formatted text.
#    Input        : text_ref
#                      Text that need to perform wordwrap
#                   head_symbol
#                      Option argument. symbol add to front of each line
#                      Default is empty
#                   tail_symbol
#                      Option argument. Symbol add to end of each line
#                      Defaul is empty
#                   split_char
#                      Pattern character use to split line
#                      Default is white space
#                   split_legth
#                      Split line at string specified by this variable
#                      Default is 10
#    Output       : None
# -------------------------------------------------------------------------------------------------

     upvar $text_ref text

     set words [split $text $split_char]
     set word_cnt [llength $words]
     set max_word_num [expr $word_cnt - 1]
     set text ""

     for {set i 0} {$i < $max_word_num} {set i [expr $i + $split_length]} {
             set word_range [lrange $words $i [expr $i + $split_length - 1]]
             # Get rid of "{}" which added by split command
             set word_range [string map -nocase {"{" "" "}" ""} $word_range]
             append text $head_symbol $word_range $tail_symbol "\n"
     }
}
# End bsdl_util::wordwrap_text --------------------------------------------------------------------

proc bsdl_util::split_lst_return_item { text split_char {list_index ""} } {

     set words [split $text "$split_char" ]
     if {[string compare $list_index ""] == 0} {
        return $words
     } else {
       return [lindex $words $list_index]
     }
}

proc bsdl_util::replace_last_char {text_ref replace_char char} {

     upvar $text_ref text

     set str_length [string length $text]

     # Handle "\n" as garbage
     #set garbage_index [string last "\n" $text $str_length]
     #set text [string replace $text $garbage_index $garbage_index ""]
     # Replace character
     set char_index [string last $replace_char $text]
     set text [string replace $text $char_index $char_index $char]

}

proc bsdl_util::replace_first_char {text_ref replace_char char} {

     upvar $text_ref text

     # Replace character
     set char_index [string first $replace_char $text]
     set text [string replace $text $char_index $char_index $char]

}


# **************************************************************************
#
#	Namespace bsdl_lib
#
# **************************************************************************

# --------------------------------------------------------------------------
#
namespace eval bsdl_lib {
#
# Description:	Namespace that defines APIs about BSDL library files.
#
# Warning:	All defined variables are not allowed to be accessed outside
#		this namespace!!! To access them, use the defined accessors.
#
# --------------------------------------------------------------------------

     # Boundary Scan Cell Type
     set BSC_IO_TYPE "I/O"
     set BSC_IO_INTEST_TYPE "IO_INTEST"
     # This applied to IO_LINKAGE as well
     set BSC_IO_UNBOUND_TYPE "IO_UNBOUND"
     set BSC_INPUT_INTEST_TYPE "INPUT_INTEST"
     set BSC_INPUT_TYPE "INPUT"
     set BSC_CLK_TYPE "CLOCK"
     set BSC_HIDE_PIN_TYPE "HIDE_PIN"
     set BSC_FAMILY_IN_TYPE "FAMILY_IN"
     set BSC_FAMILY_IN_INTEST_TYPE "FAMILY_IN_INTEST"
     set BSC_FAMILY_OUT_TYPE "FAMILY_OUT"
     set BSC_FAMILY_OUT_PULL_1_TYPE "FAMILY_OUT_PULL1"
     set BSC_FAMILY_IO_TYPE "FAMILY_IO"
     set BSC_FAMILY_IO_INTEST_TYPE "FAMILY_IO_INTEST"
     set BSC_FAMILY_LINKAGE_TYPE "FAMILY_LINKAGE"

     # Boundary Scan Cell Group
     array set bsc_group_lib [list IO_INTEST {I/O PLL_OUT CLKUSR CRC_ERROR DEV_CLRn DEV_OE INIT_DONE} \
                               FAMILY_IN {CLK MSEL DATA0 PLL_ENA VCCSEL PORSEL nIO_PULLUP FPLLCLKp/n} \
                               FAMILY_LINKAGE {CONF_DONE DCLK nCE nCEO nCONFIG nSTATUS TEMPDIODEp/n VREF} \
                               FAMILY_OUT {ASDO nCSO} \
                               IO_UNBOUND {NC} \
                         ]

     # BST Behaviour - Pin Category Mapping
     array set pin_cat_lib [list IN {INPUT_INTEST INPUT CLOCK FAMILY_IN FAMILY_IN_INTEST} \
                               OUT {FAMILY_OUT} \
                               INOUT {IO IO_INTEST FAMILY_IO FAMILY_IO_INTEST} \
                               LINKAGE {IO_UNBOUND IO_LINKAGE HIDE_PIN FAMILY_LINKAGE} \
                         ]                    
     
     # Safe Bits
     # list sequence
     # Input, IO, Internal, Config In, Config out, Double Bonded Pin
     # CUDA (CycloneIII), TITAN (Stratix III), TSUNAMI(MaxII)
     array set bsc_safe_bit_lib [list TGX {X 1 1 X 1 NA} \
                                      HCX {X 1 1 X 1 NA} \
                                      HCXIV {X 1 1 X 1 NA} \
				      TARPON {X 1 1 X 1 NA} \
                                ]

     # version: follow ICD name
     # e.g. TGX - C0 C1 C2 C3 C4 C5 C6                           
     array set file_version_lib [list TGX {1.0 1.0 1.0 1.0 1.0 1.0 1.0} \
                                      HCX {1.0 1.0 1.0 1.0 1.0 1.0 1.0} \
                                      HCXIV {1.0 1.0 1.0 1.0 1.0 1.0 1.0} \
				      TARPON {1.0 1.0 1.0 1.0 1.0 1.0 1.0} \
                            ]                           
                                
     # Other
     set BSC_NOT_AVAIL "NA"
}


proc bsdl_lib::get_bsc_group {list} {

     variable bsc_group_lib

     set pin_name [lindex $list 1]
     set category [lindex $list 2]
     set function_name [lindex $list 3]
     set group ""

     # if pin_name is "NA" and function name is I/O, then is IO_UNBOUND
     # assumption, else is FAMILY_LINKAGE
     if {[string compare $pin_name $bsdl_lib::BSC_NOT_AVAIL] == 0 } {
        if {[string compare $function_name $bsdl_lib::BSC_IO_TYPE] == 0} {
           return $bsdl_lib::BSC_IO_UNBOUND_TYPE
        } else {
           return $bsdl_lib::BSC_FAMILY_LINKAGE_TYPE
        }
     } elseif {[string compare $pin_name $bsdl_lib::BSC_NOT_AVAIL] != 0} {

           # search which group its belongs to
           foreach {group member} [array get bsc_group_lib] {
              foreach list_item $member {
                 if {[string match "$list_item*" $function_name] == 1 } {
                    return $group
                 }
              }
           }
     }
}
# End bsdl_lib::get_bsc_group -----------------------------------------------

proc bsdl_util::pin_behaviour_check {pin_name function_name pin_bst_behaviour} {

	# if pin_name is "NA" and function name is I/O, then is IO_UNBOUND
     # assumption, else is FAMILY_LINKAGE
     if {[string compare $pin_name $bsdl_lib::BSC_NOT_AVAIL] == 0 } {
        if {[string match "*$bsdl_lib::BSC_IO_TYPE" $function_name] == 1} {
           return $bsdl_lib::BSC_IO_UNBOUND_TYPE
        } else {
           return $bsdl_lib::BSC_FAMILY_LINKAGE_TYPE
        }
 	} elseif {[string compare $pin_name $bsdl_lib::BSC_NOT_AVAIL] != 0} {
		return $pin_bst_behaviour
	}		 
}
# End bsdl_util::pin_behavior_check --------------------------------------------

proc bsdl_lib::get_pin_cat {pin_bst_behaviour} {
	
	variable pin_cat_lib
	
	set group ""
	
	if {[string compare $pin_bst_behaviour $bsdl_lib::BSC_NOT_AVAIL] != 0 } {
		# search which pin category its belongs to
      	foreach {group member} [array get pin_cat_lib] {
       		foreach list_item $member {
           		if {[string match "$list_item" $pin_bst_behaviour] == 1 } {
                	return $group
               	}
           	}
       	}
	} elseif {[string compare $pin_bst_behaviour $bsdl_lib::BSC_NOT_AVAIL] == 0 } {
			return $bsdl_lib::BSC_NOT_AVAIL
	} 
	 
}
# End bsdl_lib::get_pin_cat -----------------------------------------------

proc bsdl_lib::get_version {device_list} {
	
	variable file_version_lib
	
	set family [lindex $device_list 0]
	set family_dbg [get_dstr_string -debug -family $family]
	
	set current_device [lindex $device_list 4]
	set part [get_part_info -device $current_device]
    set device_debug [get_dstr_string -debug -device $part]
	
    #Get the first digit from device debug name
    regexp -- {[0-9]} $device_debug result
    set in_name $result
    
    if {![info exists file_version_lib($family_dbg)]} {
        post_message -type error "bsdl_lib::get_version - Unsupported family: $family."
        qexit -error 
     }

     set version_list "$file_version_lib($family_dbg)"
     return "[lindex $version_list $in_name]"
}

proc bsdl_lib::get_version_all {family} {
	
	variable file_version_lib
	
	set family_dbg [get_dstr_string -debug -family $family]
	
	if {![info exists file_version_lib($family_dbg)]} {
        post_message -type error "bsdl_lib::get_version - Unsupported family: $family."
        qexit -error 
     }
     
     return "$file_version_lib($family_dbg)"
}

# End bsdl_lib::get_pin_cat -----------------------------------------------

proc bsdl_lib::bsc_type_write {ostream list group number family last_item} {

     set txt ""

     set pin_name [lindex $list 1]
     set function_name [lindex $list 3]

     # For IO
     if {[string compare $group $bsdl_lib::BSC_IO_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 1]"
        append txt "  --BSC group $number for I/O pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_4, $function_name, input, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_1, *, control, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, output3, X, [expr $number*3+1], 1, Z),\" &" [expr $number*3+2]] "\n"
     }

     # For IO_INTEST
     if {[string compare $group $bsdl_lib::BSC_IO_INTEST_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 1]"
        append txt "  --BSC group $number for I/O pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, input, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_1, *, control, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, output3, X, [expr $number*3+1], 1, Z),\" &" [expr $number*3+2]] "\n"
     }

     # For IO_UNBOUNDED
     if {[string compare $group $bsdl_lib::BSC_IO_UNBOUND_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 1]"
        append txt "  --BSC group $number for unused pad" "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3+2]] "\n"
     }

     # For INPUT_INTEST
     if {[string compare $group $bsdl_lib::BSC_INPUT_INTEST_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 0]"
        append txt "  --BSC group $number for I/O pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, input, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3+2]] "\n"
     }

     # For INPUT
     if {[string compare $group $bsdl_lib::BSC_INPUT_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 0]"
        append txt "  --BSC group $number for I/O pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_4, $function_name, input, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3+2]] "\n"
     }

     # For CLK
     if {[string compare $group $bsdl_lib::BSC_CLK_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 0]"
        append txt "  --BSC group $number for CLK $pin_name" "\n"
        append txt [format "  \"%-5s (BC_4, $function_name, input, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3+2]] "\n"
     }
     
     # For HIDE_PIN
     if {[string compare $group $bsdl_lib::BSC_HIDE_PIN_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 0]"
        append txt "  --BSC group $number for CLK $pin_name" "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3+2]] "\n"
     }

     # For FAMILY_IN
     if {[string compare $group $bsdl_lib::BSC_FAMILY_IN_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 0]"
        append txt "  --BSC group $number for Family-specific input pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_4, $function_name, input, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3+2]] "\n"
     }

     # For FAMILY_IN_INTEST
     if {[string compare $group $bsdl_lib::BSC_FAMILY_IN_INTEST_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 0]"
        append txt "  --BSC group $number for Family-specific input pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, input, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3+2]] "\n"
     }

     # For FAMILY_OUT
     if {[string compare $group $bsdl_lib::BSC_FAMILY_OUT_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 1]"
        append txt "  --BSC group $number for Family-specific output pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_1, *, control, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, output3, X, [expr $number*3+1], 1, Z),\" &" [expr $number*3+2]] "\n"
     }

     # For FAMILY_OUT_PULL_1_TYPE
     if {[string compare $group $bsdl_lib::BSC_FAMILY_OUT_PULL_1_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 1]"
        append txt "  --BSC group $number for Family-specific output pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_1, *, control, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, output3, X, [expr $number*3+1], 1, PULL1),\" &" [expr $number*3+2]] "\n"
     }
     
     # For FAMILY_IO
     if {[string compare $group $bsdl_lib::BSC_FAMILY_IO_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 1]"
        append txt "  --BSC group $number for Family-specific input pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_4, $function_name, input, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_1, *, control, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, output3, X, [expr $number*3+1], 1, Z),\" &" [expr $number*3+2]] "\n"
     }
     
     # For FAMILY_IO_INTEST
     if {[string compare $group $bsdl_lib::BSC_FAMILY_IO_INTEST_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 1]"
        append txt "  --BSC group $number for Family-specific input pin $pin_name" "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, input, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_1, *, control, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_1, $function_name, output3, X, [expr $number*3+1], 1, Z),\" &" [expr $number*3+2]] "\n"
     }
     
     # For FAMILY_LINKAGE
     if {[string compare $group $bsdl_lib::BSC_FAMILY_LINKAGE_TYPE] == 0 } {

        set safe_bit "[bsdl_lib::get_safe_bit $family 1]"
        append txt "  --BSC group $number for untestable Family-specific pin" "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, $safe_bit),\" &" [expr $number*3+1]] "\n"
        append txt [format "  \"%-5s (BC_4, *, internal, X),\" &" [expr $number*3+2]] "\n"
     }

     if {$last_item} {
         bsdl_util::replace_last_char txt "," ""
         bsdl_util::replace_last_char txt "&" ";"
         bsdl_util::replace_last_char txt "\n" ""
     }

     puts $ostream $txt

}
# End bsdl_lib::get_bsc_type ------------------------------------------------

proc bsdl_lib::get_safe_bit {family index} {

     variable bsc_safe_bit_lib
     
     set family_dbg [get_dstr_string -debug -family $family]
     #puts "Family_dbg: $family_dbg"

     if {![info exists bsc_safe_bit_lib($family_dbg)]} {
        post_message -type error "bsdl_lib::get_safe_bit - Unsupported family: $family."
        qexit -error 
     }

     set safe_list "$bsc_safe_bit_lib($family_dbg)"
     return "[lindex $safe_list $index]"

}
# End bsdl_lib::get_safe_bit ----------------------------------------------------------------------

proc bsdl_lib::get_design_warning {family} {

     set family_dbg [get_dstr_string -debug -family $family]
     set txt ""

     switch $family_dbg {

         TGX {
	           append txt "&
	           	\"The following private instructions must not be used as they\"&
  			   	\"may render the device inoperable:\"&
  			   	\" \"&
  				\"  1100010000  \"&
  				\"  0110101101  \"& 
  				\"  0011001001  \"&
  				\"  1100010011  \"&
  				\"  1100010111  \"&
  				\"  0111100000  \"&
  				\"  1110110011  \"&
  				\" \"&
  				\"Customer should take precautions not to invoke these instructions\"& 
  				\"at any time. Contact Altera Applications for further assistance.\";
	           "
	     }
	     HCX -
	     HCXIV {
		      append txt "&
	           	\"The following private instructions must not be used as they\"&
  			   	\"may render the device inoperable:\"&
  			   	\" \"&
  				\"  1100010000  \"&
  				\"  0011001001  \"& 
  				\"  1100010011  \"&
  				\"  1100010111  \"&
  				\" \"&
  				\"Customer should take precautions not to invoke these instructions\"& 
  				\"at any time. Contact Altera Applications for further assistance.\";
	           "
		 }
		 TARPON {
		 	  append txt "&
	           	\"The following private instructions must not be used as they\"&
                \"may render the device inoperable:\"&
                \" \"&
                \"  1000010000  \"&
                \"  1001000000  \"& 
                \"  1011100000  \"&
                \" \"&
                \"Customer should take precautions not to invoke these instructions\"& 
                \"at any time. Contact Altera Applications for further assistance.\";
	           "
		 }
	     default {
      		   append txt ";"
	     }
     }

     return $txt
}
#End bsdl_lib::get_design_warning -----------------------------------------------------------------

proc bsdl_lib::get_tgx_reg_instruction {device_debug device} {

     set txt ""
     set part_number ""
     
     append txt "
                attribute INSTRUCTION_LENGTH of $device : entity is 10;
                attribute INSTRUCTION_OPCODE of $device : entity is
                \"BYPASS            (1111111111), \"&
                \"EXTEST            (0000001111), \"&
                \"SAMPLE            (0000000101), \"&
                \"IDCODE            (0000000110), \"&
                \"USERCODE          (0000000111), \"&
                \"CLAMP             (0000001010), \"&
                \"HIGHZ             (0000001011), \"&
                \"PRIVATE           (1100010000, 0110101101, 0011001001, 1100010011, 1100010111, 0111100000, 1110110011), \"&
                \"CONFIG_IO         (0000001101)\";

                attribute INSTRUCTION_CAPTURE of $device : entity is \"0101010101\";

                attribute INSTRUCTION_PRIVATE of $device : entity is \"PRIVATE\";
                "

     switch $device_debug {
	     
	     TGX1 { append txt "
                           attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             \"0010010000000000\"&   --16-bit Part Number (hex 2400)
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                           attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                           attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE),\"&
                             \"IOCSR[130175]      (CONFIG_IO)\";
                      " }
		TGX2 -
		TGT2 -
		TGT2_40 -
		TGX2_V1 -
		T2 { 
				if {[string compare $device_debug "T2"] == 0} {
			 		set part_number "\"0010010000010001\"&   --16-bit Part Number (hex 2411)"
		 	  	} elseif {[string compare $device_debug "TGX2_V1"] == 0} {
		 	  		set part_number "\"0010010000100001\"&   --16-bit Part Number (hex 2421)"	
			 	} elseif {[string compare $device_debug "TGX2"] == 0} {
		 	  		set part_number "\"0010010000001001\"&   --16-bit Part Number (hex 2409)"
	 	  		} else {
			 	 	set part_number "\"0010010000000001\"&   --16-bit Part Number (hex 2401)"
		 	  	}
			
				append txt "
                           attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             $part_number
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                           attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                           attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE), \"&
                             \"IOCSR[194787]      (CONFIG_IO)\";
                      " }
	     TGX4 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             \"0010010000000010\"&   --16-bit Part Number (hex 2402)
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE), \"&
                             \"IOCSR[223271]      (CONFIG_IO)\";
                      " }
		 TGX5 -
		 TGT5 -
		 TGT5_40 -
		 T5 { 	 
			 	if {[string compare $device_debug "T5"] == 0} {
			 		set part_number "\"0010010000010011\"&   --16-bit Part Number (hex 2413)"
		 	  	} else {
			 	 	set part_number "\"0010010000000011\"&   --16-bit Part Number (hex 2403)"
		 	  	}
			 
			  	append txt "                    
                           attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             $part_number
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                           attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                           attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE), \"&
                             \"IOCSR[255089]      (CONFIG_IO)\";
                      " }
	      EP4SE720* { append txt "                     
                           attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             \"0010010000000100\"&   --16-bit Part Number (hex 2404)
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                           attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                           attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE),\"&
                             \"IOCSR[227225]      (CONFIG_IO)\";
                      " }
		 TGX0 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010010000100000\"&   --16-bit Part Number (hex 2420)
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE),\"&
                             \"IOCSR[130175]      (CONFIG_IO)\";
                      " }
		 TGX3 { append txt "
                           attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             \"0010010000100010\"&   --16-bit Part Number (hex 2422)
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                           attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                           attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE),\"&
                             \"IOCSR[223271]      (CONFIG_IO)\";
                      " }	
         default {
	         		append txt "
                        Information Not Available!!!!!
                      "
	         	}

     }

     bsdl_util::parse_formatted_text txt
     return $txt
}

proc bsdl_lib::get_hcx_reg_instruction {device_debug device} {
	
	set txt ""
   	set part_number ""
     
     append txt "
                attribute INSTRUCTION_LENGTH of $device : entity is 10;
                attribute INSTRUCTION_OPCODE of $device : entity is
                \"BYPASS            (1111111111), \"&
                \"EXTEST            (0000001111), \"&
                \"SAMPLE            (0000000101), \"&
                \"IDCODE            (0000000110), \"&
                \"USERCODE          (0000000111), \"&
                \"CLAMP             (0000001010), \"&
                \"HIGHZ             (0000001011)\";

                attribute INSTRUCTION_CAPTURE of $device : entity is \"0101010101\";
                "

     switch $device_debug {
	     
	     HCXA0 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001001100000\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
        HCXA0_V1 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001000010000\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
     	HCXA0_V2 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001000100000\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
  		HCXA0_V3 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001000110000\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
        HCXA0_V4 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001001010000\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
        HCXA1 -
        HCXA1W { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001001110001\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
        HCXA1_V1 -
        HCXA1W_V1 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001000010001\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
        HCXA1_V2 -
        HCXA1W_V2 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001000100001\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
        HCXA1_V3 -
        HCXA1W_V3 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001000110001\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
		HCXA1_V4 -
		HCXA1W_V4 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001001010001\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
		HCXA1_V5 -
		HCXA1W_V5 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001001100001\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
        
        HCXA3 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001001110010\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
		HCXA3_V1 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001000100010\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
        HCXA3_V2 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001001010010\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
		HCXA3_V3 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001001100010\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
        HCXA3_V4 { append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                             \"0010001000110010\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
     	default {
	     	append txt "
                       Information Not Available!!!!!
                      "
     	}
	 }
	 
	 bsdl_util::parse_formatted_text txt
     return $txt
}

proc bsdl_lib::get_hcxiv_reg_instruction {device_debug device} {

	set txt ""
   	set part_number ""
     
     append txt "
                attribute INSTRUCTION_LENGTH of $device : entity is 10;
                attribute INSTRUCTION_OPCODE of $device : entity is
                \"BYPASS            (1111111111), \"&
                \"EXTEST            (0000001111), \"&
                \"SAMPLE            (0000000101), \"&
                \"IDCODE            (0000000110), \"&
                \"USERCODE          (0000000111), \"&
                \"CLAMP             (0000001010), \"&
                \"HIGHZ             (0000001011)\";

                attribute INSTRUCTION_CAPTURE of $device : entity is \"0101010101\";
                "

    switch $device_debug {
	
	HCXA1_4E_V1 -
	HCXA1_4E_V1W
	 { 	 # HC4E21, HC4E21W
		 append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                            \"0010011000100001\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
	HCXA1_4E_V2 -
	HCXA1_4E_V2W
	 {   # HC4E31, HC4E31W
		 append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                            \"0010011000110001\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
    HCXA1_4E_V3 -
    HCXA1_4E_V3W
	 {   # HC4E41, HC4E41W
		 append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                            \"0010011001000001\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }
    HCXA3_4E_V1
	 {   # HC4E62
		 append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                            \"0010011001100010\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }              
	HCXA3_4E_V2
	 {   # HC4E72
		 append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                            \"0010011001110010\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }              
	HCXA3_4E_V3
	 {   # HC4E42
		 append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                            \"0010011001000010\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }              
	HCXA3_4E_V4
	 {   # HC4E52
		 append txt "
                          attribute IDCODE_REGISTER of $device : entity is
                            \"0000\"&               --4-bit Version
                            \"0010011001010010\"&   --16-bit Part Number
                            \"00001101110\"&        --11-bit Manufacturer's Identity
                            \"1\";                  --Mandatory LSB
                          attribute USERCODE_REGISTER of $device : entity is
                            \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                          attribute REGISTER_ACCESS of $device : entity is
                            \"DEVICE_ID        (IDCODE)\";
                      " }              
	default {
	     	append txt "
                       Information Not Available!!!!!
                      "
     	}
	 }
	
	 bsdl_util::parse_formatted_text txt
     return $txt
	
}

proc bsdl_lib::get_tarpon_reg_instruction {device_debug device} {

     set txt ""
     set part_number ""
     
     append txt "
                attribute INSTRUCTION_LENGTH of $device : entity is 10;
                attribute INSTRUCTION_OPCODE of $device : entity is
                \"BYPASS            (1111111111), \"&
                \"EXTEST            (0000001111), \"&
                \"SAMPLE            (0000000101), \"&
                \"IDCODE            (0000000110), \"&
                \"USERCODE          (0000000111), \"&
                \"CLAMP             (0000001010), \"&
                \"HIGHZ             (0000001011), \"&
                \"ACTIVE_ENGAGE     (1010110000), \"&
                \"ACTIVE_DISENGAGE  (1011010000), \"&
                \"PRIVATE           (1000010000, 1001000000, 1011100000), \"&
                \"CONFIG_IO         (0000001101)\";

                attribute INSTRUCTION_CAPTURE of $device : entity is \"0101010101\";

                attribute INSTRUCTION_PRIVATE of $device : entity is 
                \"PRIVATE, \"&
                \"ACTIVE_ENGAGE, \"& 
                \"ACTIVE_DISENGAGE\";
                "

     switch $device_debug {
	     
	     TARPON1 
	     { 	 # LPS100
		     append txt "
                           attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             \"0010011100000000\"&   --16-bit Part Number (hex 2700)
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                           attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                           attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE),\"&
                             \"IOCSR[17488]      (CONFIG_IO)\";
                      " }
         TARPON1_V1 
	     { 	 # LPS70
		     append txt "
                           attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             \"0010011100000001\"&   --16-bit Part Number (hex 2701)
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                           attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                           attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE),\"&
                             \"IOCSR[17488]      (CONFIG_IO)\";
                      " }
         TARPON2 
	     { 	 # LPS200
		     append txt "
                           attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             \"0010011100000010\"&   --16-bit Part Number (hex 2702)
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                           attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                           attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE),\"&
                             \"IOCSR[17488]      (CONFIG_IO)\";
                      " }
         TARPON2_V1 
	     { 	 # LPS200
		     append txt "
                           attribute IDCODE_REGISTER of $device : entity is
                             \"0000\"&               --4-bit Version
                             \"0010011100000011\"&   --16-bit Part Number (hex 2703)
                             \"00001101110\"&        --11-bit Manufacturer's Identity
                             \"1\";                  --Mandatory LSB
                           attribute USERCODE_REGISTER of $device : entity is
                             \"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\";  --All 32 bits are programmable
                           attribute REGISTER_ACCESS of $device : entity is
                             \"DEVICE_ID        (IDCODE),\"&
                             \"IOCSR[17488]      (CONFIG_IO)\";
                      " }
    	default {
	     	append txt "
                       Information Not Available!!!!!
                      "
     	}
	 }
	
	 bsdl_util::parse_formatted_text txt
     return $txt
}