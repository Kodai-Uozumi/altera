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
# the NCO Frequency Hopping Example Design (Verilog version)

set current_dir [pwd]
if {[file exist [project env]] > 0} {project close}
if {[file exist freq_hopping_example.v] ==0} {
   error "Please change directory to NCO Frequency hopping reference design"  }

if {[file exist "$current_dir/freq_hopping_example.mpf"] == 0} {
      project new [pwd] freq_hopping_example
} else	{
	project open freq_hopping_example
}

# Create default work directory if not exist
if {[file exist work] ==0} 	{
  exec vlib work
  exec vmap work work}      

# Map lpm library
if {[file exist lpm] ==0} 	{
  exec vlib lpm
  exec vmap lpm lpm}  
vlog -93 -work lpm $env(QUARTUS_ROOTDIR)/eda/sim_lib/220model.v

# Map altera_mf library
if {[file exist altera_mf] ==0} 	{
  exec vlib altera_mf
  exec vmap altera_mf altera_mf}      
vlog -93 -work altera_mf $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_mf.v

# Map sgate library
if {[file exist sgate] ==0} 	{
  exec vlib sgate
  exec vmap sgate sgate}      
vlog -93 -work sgate $env(QUARTUS_ROOTDIR)/eda/sim_lib/sgate.v

# Compile IP Functional Simulation Model of the core's variant
vlog nco.vo

# Compile the top level of the Frequency Hopping Example Design
vlog freq_hopping_example.v

# Compile Testbench		 
vlog freq_hopping_example_tb.v

# Ignore warning messages 
set IgnoreWarning  1

# Simulate the design in Modelsim
vsim -L lpm -L altera_mf -L sgate -novopt freq_hopping_example_tb 

# Run script to add signals to wave window
do freq_hopping_example_wave.do

# Run for 90,000 ns (90 us)
run 900000 ns
