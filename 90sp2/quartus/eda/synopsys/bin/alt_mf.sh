#!/bin/sh
if [ ! -d ../mf/lib ]; then
  mkdir ../mf/lib
fi
dc_shell  <<!
define_design_lib altera -path ../mf/lib
analyze -library altera -f vhdl ../mf/src/mf.vhd
analyze -library altera -f vhdl ../mf/src/mf_components.vhd
quit
!
rm -f command.log
