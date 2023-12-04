#!/bin/sh
## This script doesn't take any arguments and has to be run 
## from the directory in which it resides.

dw_src_path=../dw/src

dw_lib_path=../dw

dw_lib=lib

dw_logical_lib=DW_FLEX

cd $dw_src_path
if [ ! -d ../$dw_lib ]; then
   mkdir -p ../$dw_lib
fi
dc_shell  <<!
define_design_lib $dw_logical_lib -path ../$dw_lib
analyze -w $dw_logical_lib -f vhdl flex_add.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_count.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_inc.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_sub.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_dec.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_gt.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_sgt.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_gteq.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_sgteq.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_lt.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_slt.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_lteq.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_slteq.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_add_sub.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_inc_dec.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_umult.vhd.e -update
analyze -w $dw_logical_lib -f vhdl flex_smult.vhd.e -update
quit
!
rm -f command.log ../$dw_lib/*.sim ../$dw_lib/*.mra
