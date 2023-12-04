
################################################################
## POS-PHY Level 2 and 3 SDC File, used by Quartus II Timequest
################################################################
##
## Copyright (C) 1991-2007 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions
## and other software and tools, and its AMPP partner logic
## functions, and any output files any of the foregoing
## (including device programming or simulation files), and any
## associated documentation or information are expressly subject
## to the terms and conditions of the Altera Program License
## Subscription Agreement, Altera MegaCore Function License
## Agreement, or other applicable license agreement, including,
## without limitation, that your use is for the sole purpose of
## programming logic devices manufactured by Altera and sold by
## Altera or its authorized distributors.  Please refer to the
## applicable agreement for further details.
##
################################################################
#   This script is intended to be a guide. It is highly possible
#   that due how the design is instantiated and other designs 
#   in your project, may require some edits to this script in 
#   order to ensure proper timing constraints.
################################################################


# ------------------------------------------
# Create generated clocks based on PLLs
# ------------------------------------------
derive_pll_clocks


# ------------------------------------------
# Create clock settings
#   The clocks below are at the core top level.
#   You may need to adjust this section accordingly
#   once this design is part of a larger design.
# ------------------------------------------

create_clock -period 9.6 -name {a_tfclk}  [get_ports *a_tfclk]
create_clock -period 9.6 -name {a_rfclk}  [get_ports *a_rfclk]
create_clock -period 9.6 -name {b_clk}    [get_ports *b_clk]
create_clock -period 9.6 -name {b0_clk}   [get_ports *b0_clk]
create_clock -period 9.6 -name {b1_clk}   [get_ports *b1_clk]
create_clock -period 9.6 -name {b2_clk}   [get_ports *b2_clk]
create_clock -period 9.6 -name {b3_clk}   [get_ports *b3_clk]
create_clock -period 9.6 -name {b4_clk}   [get_ports *b4_clk]
create_clock -period 9.6 -name {b5_clk}   [get_ports *b5_clk]
create_clock -period 9.6 -name {b6_clk}   [get_ports *b6_clk]
create_clock -period 9.6 -name {b7_clk}   [get_ports *b7_clk]

#**************************************************************
# Set Clock Latency
#**************************************************************

#**************************************************************
# Set Clock Uncertainty
#**************************************************************

#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -rise -clock [get_clocks {a_rfclk}]  0.000 [get_ports {a_rdat[*]}]
set_input_delay -add_delay -rise -clock [get_clocks {a_rfclk}]  0.000 [get_ports {a_reop}]
set_input_delay -add_delay -rise -clock [get_clocks {a_rfclk}]  0.000 [get_ports {a_rerr}]
set_input_delay -add_delay -rise -clock [get_clocks {a_rfclk}]  0.000 [get_ports {a_rmod}]
set_input_delay -add_delay -rise -clock [get_clocks {a_rfclk}]  0.000 [get_ports {a_rsop}]
set_input_delay -add_delay -rise -clock [get_clocks {a_rfclk}]  0.000 [get_ports {a_rsx}]
set_input_delay -add_delay -rise -clock [get_clocks {a_rfclk}]  0.000 [get_ports {a_rval}]

set_input_delay  -clock [get_clocks {b_clk}]  0.000 [get_ports {b_ena}]
set_input_delay  -clock [get_clocks {b_clk}]  0.000 [get_ports {b_ena}]
set_input_delay  -clock [get_clocks {b_clk}]  0.000 [get_ports {b_dat}]
set_input_delay  -clock [get_clocks {b_clk}]  0.000 [get_ports {b_sop}]
set_input_delay  -clock [get_clocks {b_clk}]  0.000 [get_ports {b_eop}]
set_input_delay  -clock [get_clocks {b_clk}]  0.000 [get_ports {b_err}]
set_input_delay  -clock [get_clocks {b_clk}]  0.000 [get_ports {b_par}]
set_input_delay  -clock [get_clocks {b_clk}]  0.000 [get_ports {b_mty}]
set_output_delay -clock [get_clocks {b_clk}]  0.000 [get_ports {b_dav}]

set_input_delay  -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_ena}]
set_input_delay  -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_ena}]
set_input_delay  -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_dat}]
set_input_delay  -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_sop}]
set_input_delay  -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_eop}]
set_input_delay  -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_err}]
set_input_delay  -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_par}]
set_input_delay  -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_mty}]
set_output_delay -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_dav}]
set_input_delay  -clock [get_clocks {b1_clk}]  0.000 [get_ports {b1_reset_n}]

set_input_delay  -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_ena}]
set_input_delay  -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_ena}]
set_input_delay  -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_dat}]
set_input_delay  -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_sop}]
set_input_delay  -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_eop}]
set_input_delay  -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_err}]
set_input_delay  -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_par}]
set_input_delay  -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_mty}]
set_output_delay -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_dav}]
set_input_delay  -clock [get_clocks {b2_clk}]  0.000 [get_ports {b2_reset_n}]

set_input_delay  -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_ena}]
set_input_delay  -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_ena}]
set_input_delay  -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_dat}]
set_input_delay  -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_sop}]
set_input_delay  -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_eop}]
set_input_delay  -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_err}]
set_input_delay  -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_par}]
set_input_delay  -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_mty}]
set_output_delay -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_dav}]
set_input_delay  -clock [get_clocks {b3_clk}]  0.000 [get_ports {b3_reset_n}]

set_input_delay  -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_ena}]
set_input_delay  -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_ena}]
set_input_delay  -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_dat}]
set_input_delay  -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_sop}]
set_input_delay  -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_eop}]
set_input_delay  -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_err}]
set_input_delay  -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_par}]
set_input_delay  -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_mty}]
set_output_delay -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_dav}]
set_input_delay  -clock [get_clocks {b4_clk}]  0.000 [get_ports {b4_reset_n}]

set_input_delay  -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_ena}]
set_input_delay  -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_ena}]
set_input_delay  -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_dat}]
set_input_delay  -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_sop}]
set_input_delay  -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_eop}]
set_input_delay  -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_err}]
set_input_delay  -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_par}]
set_input_delay  -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_mty}]
set_output_delay -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_dav}]
set_input_delay  -clock [get_clocks {b5_clk}]  0.000 [get_ports {b5_reset_n}]

set_input_delay  -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_ena}]
set_input_delay  -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_ena}]
set_input_delay  -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_dat}]
set_input_delay  -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_sop}]
set_input_delay  -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_eop}]
set_input_delay  -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_err}]
set_input_delay  -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_par}]
set_input_delay  -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_mty}]
set_output_delay -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_dav}]
set_input_delay  -clock [get_clocks {b6_clk}]  0.000 [get_ports {b6_reset_n}]

set_input_delay  -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_ena}]
set_input_delay  -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_ena}]
set_input_delay  -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_dat}]
set_input_delay  -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_sop}]
set_input_delay  -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_eop}]
set_input_delay  -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_err}]
set_input_delay  -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_par}]
set_input_delay  -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_mty}]
set_output_delay -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_dav}]
set_input_delay  -clock [get_clocks {b7_clk}]  0.000 [get_ports {b7_reset_n}]

set_input_delay  -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_ena}]
set_input_delay  -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_ena}]
set_input_delay  -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_dat}]
set_input_delay  -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_sop}]
set_input_delay  -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_eop}]
set_input_delay  -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_err}]
set_input_delay  -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_par}]
set_input_delay  -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_mty}]
set_output_delay -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_dav}]
set_input_delay  -clock [get_clocks {b8_clk}]  0.000 [get_ports {b8_reset_n}]


#**************************************************************
# Set Output Delay
#**************************************************************
# set_output_delay -clock clk 5 [get_ports *]

#**************************************************************
# Set Clock Groups
#**************************************************************

#**************************************************************
# Set False Path
#**************************************************************
# set_clock_groups -asynchronous -group { xclk } -group { yclk }
set_false_path  -from  [get_clocks {a_tfclk}]  -to  [get_clocks {b_clk}]
set_false_path  -from  [get_clocks {a_tfclk}]  -to  [get_clocks {b0_clk}]
set_false_path  -from  [get_clocks {a_tfclk}]  -to  [get_clocks {b1_clk}]
set_false_path  -from  [get_clocks {a_tfclk}]  -to  [get_clocks {b2_clk}]
set_false_path  -from  [get_clocks {a_tfclk}]  -to  [get_clocks {b3_clk}]
set_false_path  -from  [get_clocks {a_tfclk}]  -to  [get_clocks {b4_clk}]
set_false_path  -from  [get_clocks {a_tfclk}]  -to  [get_clocks {b5_clk}]
set_false_path  -from  [get_clocks {a_tfclk}]  -to  [get_clocks {b6_clk}]
set_false_path  -from  [get_clocks {a_tfclk}]  -to  [get_clocks {b7_clk}]

set_false_path  -from  [get_clocks {b_clk}]   -to   [get_clocks {a_tfclk}]
set_false_path  -from  [get_clocks {b0_clk}]  -to   [get_clocks {a_tfclk}]
set_false_path  -from  [get_clocks {b1_clk}]  -to   [get_clocks {a_tfclk}]
set_false_path  -from  [get_clocks {b2_clk}]  -to   [get_clocks {a_tfclk}]
set_false_path  -from  [get_clocks {b3_clk}]  -to   [get_clocks {a_tfclk}]
set_false_path  -from  [get_clocks {b4_clk}]  -to   [get_clocks {a_tfclk}]
set_false_path  -from  [get_clocks {b5_clk}]  -to   [get_clocks {a_tfclk}]
set_false_path  -from  [get_clocks {b6_clk}]  -to   [get_clocks {a_tfclk}]
set_false_path  -from  [get_clocks {b7_clk}]  -to   [get_clocks {a_tfclk}]

set_false_path  -from  [get_clocks {a_rfclk}]  -to  [get_clocks {b_clk}]
set_false_path  -from  [get_clocks {a_rfclk}]  -to  [get_clocks {b0_clk}]
set_false_path  -from  [get_clocks {a_rfclk}]  -to  [get_clocks {b1_clk}]
set_false_path  -from  [get_clocks {a_rfclk}]  -to  [get_clocks {b2_clk}]
set_false_path  -from  [get_clocks {a_rfclk}]  -to  [get_clocks {b3_clk}]
set_false_path  -from  [get_clocks {a_rfclk}]  -to  [get_clocks {b4_clk}]
set_false_path  -from  [get_clocks {a_rfclk}]  -to  [get_clocks {b5_clk}]
set_false_path  -from  [get_clocks {a_rfclk}]  -to  [get_clocks {b6_clk}]
set_false_path  -from  [get_clocks {a_rfclk}]  -to  [get_clocks {b7_clk}]

set_false_path  -from  [get_clocks {b_clk}]   -to   [get_clocks {a_rfclk}]
set_false_path  -from  [get_clocks {b0_clk}]  -to   [get_clocks {a_rfclk}]
set_false_path  -from  [get_clocks {b1_clk}]  -to   [get_clocks {a_rfclk}]
set_false_path  -from  [get_clocks {b2_clk}]  -to   [get_clocks {a_rfclk}]
set_false_path  -from  [get_clocks {b3_clk}]  -to   [get_clocks {a_rfclk}]
set_false_path  -from  [get_clocks {b4_clk}]  -to   [get_clocks {a_rfclk}]
set_false_path  -from  [get_clocks {b5_clk}]  -to   [get_clocks {a_rfclk}]
set_false_path  -from  [get_clocks {b6_clk}]  -to   [get_clocks {a_rfclk}]
set_false_path  -from  [get_clocks {b7_clk}]  -to   [get_clocks {a_rfclk}]


#**************************************************************
# Set Multicycle Path
#**************************************************************
# set_multicycle_path -setup -end -from "*x:x|xsig" -to "*y|*y|ysig" 2
# set_multicycle_path -hold  -end -from "*x:x|xsig" -to "*y|*y|ysig" 1


#**************************************************************
# Set Maximum Delay
#**************************************************************
# # Generically Constrain the input I/O path
# set_max_delay -from [all_inputs] -to [all_registers] 10
# # Generically Constrain the Output I/O path
# set_max_delay -from [all_registers] -to [all_outputs] 10

#**************************************************************
# Set Minimum Delay
#**************************************************************

