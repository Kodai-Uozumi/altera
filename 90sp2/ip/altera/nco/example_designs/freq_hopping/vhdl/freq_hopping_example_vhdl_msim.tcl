# Copyright (C) 1988-2009 Altera Corporation

# Any megafunction design, and related net list (encrypted or decrypted),
# support information, device programming or simulation file, and any other
# associated documentation or information provided by Altera or a partner
# under Altera's Megafunction Partnership Program may be used only to
# program PLD devices (but not masked PLD devices) from Altera.  Any other
# use of such megafunction design, net list, support information, device
# programming or simulation file, or any other related documentation or
# information is prohibited for any other purpose, including, but not
# limited to modification, reverse engineering, de-compiling, or use with
# any other silicon devices, unless such use is explicitly licensed under
# a separate agreement with Altera or a megafunction partner.  Title to
# the intellectual property, including patents, copyrights, trademarks,
# trade secrets, or maskworks, embodied in any such megafunction design,
# net list, support information, device programming or simulation file, or
# any other related documentation or information provided by Altera or a
# megafunction partner, remains with Altera, the megafunction partner, or
# their respective licensors.  No other licenses, including any licenses
# needed under any third party's intellectual property, are provided herein.

# NCO Frequency Hopping Example Design 
# Description: Modelsim TCL script for simulating 
# the NCO Frequency Hopping Example Design (VHDL version)  

set current_dir [pwd]
if {[file exist [project env]] > 0} {project close}
if {[file exist freq_hopping_example.vhd] ==0} {
   error "Please change directory to NCO Frequency hopping reference design"  }

if {[file exist "$current_dir/freq_hopping_example.mpf"] == 0} {
      project new [pwd] freq_hopping_example
} else	{
	project open freq_hopping_example
}

# Create default work directory if not present
if {[file exist work] ==0} 	{
  exec vlib work
  exec vmap work work}      

# Map lpm library
if {[file exist lpm] ==0} 	{
  exec vlib lpm
  exec vmap lpm lpm}      
vcom -93 -work lpm $env(QUARTUS_ROOTDIR)/eda/sim_lib/220pack.vhd 
vcom -93 -work lpm $env(QUARTUS_ROOTDIR)/eda/sim_lib/220model.vhd 

# Map altera_mf library
if {[file exist altera_mf] ==0} 	{
  exec vlib altera_mf
  exec vmap altera_mf altera_mf}      
vcom -93 -work altera_mf $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_mf_components.vhd 
vcom -93 -work altera_mf $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_mf.vhd 

# Map sgate library
if {[file exist sgate] ==0} 	{
  exec vlib sgate
  exec vmap sgate sgate}      
vcom -93 -work sgate $env(QUARTUS_ROOTDIR)/eda/sim_lib/sgate_pack.vhd 
vcom -93 -work sgate $env(QUARTUS_ROOTDIR)/eda/sim_lib/sgate.vhd 

# Compile IP Functional Simulation Model of the core's variant
vcom nco.vho

# Compile the top level of the Frequency Hopping Example Design
vcom -93 freq_hopping_example.vhd

# Compile Testbench
vcom -93 freq_hopping_example_tb.vhd

# Ignore warning messages 
set IgnoreWarning  1

# Simulate the design in Modelsim
vsim -t 1ps -novopt freq_hopping_example_tb 

# Run script to add signals to wave window
do freq_hopping_example_wave.do

# Run for 900,000 ns (900 us)
run 900000 ns
