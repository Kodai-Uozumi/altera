## Generated SDC file "tr_sdi.out.sdc"

## Copyright (C) 1991-2009 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 9.0 Build 131 02/18/2009 SJ Full Version"

## DATE    "Thu Feb 26 17:36:14 2009"

##
## DEVICE  "EP2AGX260FF35C4"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

derive_pll_clocks -create_base_clocks

#**************************************************************
# Create Clock
#**************************************************************
create_clock -name {clk_fpga} -period 10.000 -waveform { 0.000 5.000 } [get_ports {clk_fpga}]

#**************************************************************
# Create Generated Clock
#**************************************************************
create_generated_clock -name {count[4]} -source [get_ports {clk_fpga}] -divide_by 16 -master_clock {clk_fpga} [get_registers {count[4]}] 
create_generated_clock -name {count[1]} -source [get_ports {clk_fpga}] -divide_by 2 -master_clock {clk_fpga} [get_registers {count[1]}] 

create_generated_clock -name {DV_CLK} -source [get_pins {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|receive_pcs0|clkout}] -divide_by 6 -master_clock {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|receive_pcs0|clkout} [get_registers {sdi_duplex*data_a_valid}] 
create_generated_clock -name {PFD_REFCLK_27m} -source [get_registers {sdi_duplex*data_a_valid}] -duty_cycle 16.670 -multiply_by 1 -master_clock {DV_CLK} [get_pins {pfd_refclk|combout}] -add
create_generated_clock -name {PFD_REFCLK_148m} -source [get_pins {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|receive_pcs0|clkout}] -master_clock {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|receive_pcs0|clkout} [get_pins {pfd_refclk|combout}] -add
create_generated_clock -name {REFCLK_DIV_27m} -source [get_pins {pfd_refclk|combout}] -divide_by 64 -master_clock {PFD_REFCLK_27m} [get_registers {pfd_inst|refclk_div}] -add
create_generated_clock -name {REFCLK_DIV_148m} -source [get_pins {pfd_refclk|combout}] -divide_by 64 -master_clock {PFD_REFCLK_148m} [get_registers {pfd_inst|refclk_div}] -add

create_generated_clock -name {TR_TX_PCLK_27m} -source [get_pins {pll_pclks_inst|altpll_component|pll|clk[0]}] -master_clock {pll_pclks_inst|altpll_component|pll|clk[0]} [get_pins {tr_tx_pclk|combout}] -add
create_generated_clock -name {TR_LB_PCLK_27m} -source [get_pins {pll_pclks_inst|altpll_component|pll|clk[0]}] -master_clock {pll_pclks_inst|altpll_component|pll|clk[0]} [get_pins {tr_lb_pclk|combout}] -add
create_generated_clock -name {PFD_VCOCLK_27m} -source [get_pins {tr_lb_pclk|combout}] -master_clock {TR_LB_PCLK_27m} [get_pins {pfd_vcoclk|combout}] -add
create_generated_clock -name {VCOCLK_DIV_27m} -source [get_pins {pfd_vcoclk|combout}] -divide_by 64 -master_clock {PFD_VCOCLK_27m} [get_registers {pfd_inst|vcoclk_div}] -add

create_generated_clock -name {TR_TX_PCLK_74m25} -source [get_pins {pll_pclks_inst|altpll_component|pll|clk[1]}] -master_clock {pll_pclks_inst|altpll_component|pll|clk[1]} [get_pins {tr_tx_pclk|combout}] -add
create_generated_clock -name {TR_LB_PCLK_74m25} -source [get_pins {pll_pclks_inst|altpll_component|pll|clk[1]}] -master_clock {pll_pclks_inst|altpll_component|pll|clk[1]} [get_pins {tr_lb_pclk|combout}] -add
create_generated_clock -name {PFD_VCOCLK_74m25} -source [get_pins {tr_lb_pclk|combout}] -master_clock {TR_LB_PCLK_74m25} [get_pins {pfd_vcoclk|combout}] -add
create_generated_clock -name {VCOCLK_DIV_74m25} -source [get_pins {pfd_vcoclk|combout}] -divide_by 64 -master_clock {PFD_VCOCLK_74m25} [get_registers {pfd_inst|vcoclk_div}] -add

create_generated_clock -name {TR_TX_PCLK_148m} -source [get_pins {sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout}] -master_clock {sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout} [get_pins {tr_tx_pclk|combout}] -add
create_generated_clock -name {TR_LB_PCLK_148m} -source [get_pins {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout}] -master_clock {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout} [get_pins {tr_lb_pclk|combout}] -add
create_generated_clock -name {PFD_VCOCLK_148m_DUPLEX} -source [get_pins {tr_lb_pclk|combout}] -master_clock {TR_LB_PCLK_148m} [get_pins {pfd_vcoclk|combout}] -add
create_generated_clock -name {PFD_VCOCLK_148m_TXONLY} -source [get_pins {sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout}] -master_clock {sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout} [get_pins {pfd_vcoclk|combout}] -add
create_generated_clock -name {VCOCLK_DIV_148m_DUPLEX} -source [get_pins {pfd_vcoclk|combout}] -divide_by 64 -master_clock {PFD_VCOCLK_148m_DUPLEX} [get_registers {pfd_inst|vcoclk_div}] -add
create_generated_clock -name {VCOCLK_DIV_148m_TXONLY} -source [get_pins {pfd_vcoclk|combout}] -divide_by 64 -master_clock {PFD_VCOCLK_148m_TXONLY} [get_registers {pfd_inst|vcoclk_div}] -add


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************
set_clock_groups -exclusive -group [get_clocks {TR_TX_PCLK_148m}] -group [get_clocks {TR_TX_PCLK_27m}] -group [get_clocks {TR_TX_PCLK_74m25}] 
set_clock_groups -exclusive -group [get_clocks {TR_LB_PCLK_148m}] -group [get_clocks {TR_LB_PCLK_27m}] -group [get_clocks {TR_LB_PCLK_74m25}] 
set_clock_groups -exclusive -group [get_clocks {PFD_VCOCLK_27m}] -group [get_clocks {PFD_VCOCLK_74m25}] -group [get_clocks {PFD_VCOCLK_148m_DUPLEX}] -group [get_clocks {PFD_VCOCLK_148m_TXONLY}] 
set_clock_groups -exclusive -group [get_clocks {VCOCLK_DIV_27m}] -group [get_clocks {VCOCLK_DIV_74m25}] -group [get_clocks {VCOCLK_DIV_148m_DUPLEX}] -group [get_clocks {VCOCLK_DIV_148m_TXONLY}] 
set_clock_groups -exclusive -group [get_clocks {PFD_REFCLK_27m}] -group [get_clocks {PFD_REFCLK_148m}] 
set_clock_groups -exclusive -group [get_clocks {REFCLK_DIV_27m}] -group [get_clocks {REFCLK_DIV_148m}] 
set_clock_groups -asynchronous -group [get_clocks {clk_fpga  count[1]  count[4]}] -group [get_clocks {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|receive_pcs0|clkout  DV_CLK  PFD_REFCLK_27m  REFCLK_DIV_27m  PFD_REFCLK_148m  REFCLK_DIV_148m  TR_LB_PCLK_27m}] -group [get_clocks {sdi_refclk1_cp[0]  pll_pclks_inst|altpll_component|pll|clk[0]  TR_LB_PCLK_27m  PFD_VCOCLK_27m  VCOCLK_DIV_27m  TR_TX_PCLK_27m  pll_pclks_inst|altpll_component|pll|clk[1]  TR_LB_PCLK_74m25  PFD_VCOCLK_74m25  VCOCLK_DIV_74m25  TR_TX_PCLK_74m25  sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout  TR_LB_PCLK_148m  PFD_VCOCLK_148m_DUPLEX  VCOCLK_DIV_148m_DUPLEX sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout  PFD_VCOCLK_148m_TXONLY  VCOCLK_DIV_148m_TXONLY  TR_TX_PCLK_148m  PFD_REFCLK_27m}] -group [get_clocks {{tr_rx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_rx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|receive_pcs0|clkout}}] 
set_clock_groups -exclusive -group [get_clocks {TR_TX_PCLK_27m TR_TX_PCLK_74m25 TR_TX_PCLK_148m TR_LB_PCLK_27m TR_LB_PCLK_74m25 TR_LB_PCLK_148m}] -group [get_clocks {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout}] 
set_clock_groups -exclusive -group [get_clocks {VCOCLK_DIV_148m_TXONLY}] -group [get_clocks {PFD_VCOCLK_74m25}] -group [get_clocks {PFD_VCOCLK_27m}]


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
#set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_fd9:dffpipe8|dffe9a*}]
#set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_ed9:dffpipe5|dffe6a*}]
#set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_hd9:dffpipe11|dffe12a*}]
set_false_path -from [get_registers {*tr_std_reg[*]}] -to [get_clocks {TR_TX_PCLK_27m}]
set_false_path -from [get_registers {*tr_std_reg[*]}] -to [get_clocks {TR_TX_PCLK_74m25}]
set_false_path -from [get_registers {*tr_std_reg[*]}] -to [get_clocks {TR_TX_PCLK_148m}]
set_false_path -from [get_registers {*sdi_duplex*t_rx_std.STD_HD}] -to [get_clocks {TR_LB_PCLK_27m TR_LB_PCLK_74m25 TR_LB_PCLK_148m}]
set_false_path -from [get_registers {*sdi_duplex*t_rx_std.STD_3G}] -to [get_clocks {TR_LB_PCLK_27m TR_LB_PCLK_74m25 TR_LB_PCLK_148m}]
set_false_path -from [get_registers {*sdi_duplex*t_stored_trs_a_bn}] -to [get_clocks {TR_LB_PCLK_27m TR_LB_PCLK_74m25 TR_LB_PCLK_148m}]
set_false_path -from [get_registers {*sdi_duplex*t_rx_std.STD_HD}] -to [get_clocks {PFD_VCOCLK_27m PFD_VCOCLK_74m25 PFD_VCOCLK_148m_DUPLEX PFD_VCOCLK_148m_TXONLY}]
set_false_path -from [get_registers {*sdi_duplex*t_rx_std.STD_3G}] -to [get_clocks {PFD_VCOCLK_27m PFD_VCOCLK_74m25 PFD_VCOCLK_148m_DUPLEX PFD_VCOCLK_148m_TXONLY}]
set_false_path -from [get_registers {*sdi_duplex*t_stored_trs_a_bn}] -to [get_clocks {PFD_VCOCLK_27m PFD_VCOCLK_74m25 PFD_VCOCLK_148m_DUPLEX PFD_VCOCLK_148m_TXONLY}]
set_false_path -from [get_registers {*sdi_duplex*t_rx_std.STD_HD}] -to [get_clocks {PFD_REFCLK_27m PFD_REFCLK_148m}]
set_false_path -from [get_registers {*sdi_duplex*t_rx_std.STD_3G}] -to [get_clocks {PFD_REFCLK_27m PFD_REFCLK_148m}]
set_false_path -from [get_registers {*sdi_duplex*t_stored_trs_a_bn}] -to [get_clocks {PFD_REFCLK_27m PFD_REFCLK_148m}]


#**************************************************************
# Set Multicycle Path
#**************************************************************
set_multicycle_path -setup -start -from  [get_clocks {clk_fpga}]  -to  [get_clocks {count[4]}] 32
set_multicycle_path -hold -start -from  [get_clocks {clk_fpga}]  -to  [get_clocks {count[4]}] 31
set_multicycle_path -setup -end -from  [get_clocks {count[1]}]  -to  [get_clocks {clk_fpga}] 2
set_multicycle_path -hold -end -from  [get_clocks {count[1]}]  -to  [get_clocks {clk_fpga}] 1
set_multicycle_path -setup -end -from  [get_clocks {count[4]}]  -to  [get_clocks {clk_fpga}] 16
set_multicycle_path -hold -end -from  [get_clocks {count[4]}]  -to  [get_clocks {clk_fpga}] 15
set_multicycle_path -setup -end -from  [get_clocks {count[4]}]  -to  [get_clocks {count[1]}] 8
set_multicycle_path -hold -end -from  [get_clocks {count[4]}]  -to  [get_clocks {count[1]}] 7
set_multicycle_path -setup -start -from  [get_clocks {DV_CLK}]  -to  [get_clocks {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|receive_pcs0|clkout}] 5
set_multicycle_path -hold -start -from  [get_clocks {DV_CLK}]  -to  [get_clocks {sdi_duplex_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_duplex_alt4gxb.u_gxb|alt4gxb_component|auto_generated|receive_pcs0|clkout}] 4
set_multicycle_path -setup -end -from  [get_clocks {REFCLK_DIV_27m}]  -to  [get_clocks {PFD_REFCLK_27m}] 64
set_multicycle_path -hold -end -from  [get_clocks {REFCLK_DIV_27m}]  -to  [get_clocks {PFD_REFCLK_27m}] 63
set_multicycle_path -setup -end -from  [get_clocks {REFCLK_DIV_148m}]  -to  [get_clocks {PFD_REFCLK_148m}] 64
set_multicycle_path -hold -end -from  [get_clocks {REFCLK_DIV_148m}]  -to  [get_clocks {PFD_REFCLK_148m}] 63
set_multicycle_path -setup -end -from  [get_clocks {VCOCLK_DIV_27m}]  -to  [get_clocks {PFD_VCOCLK_27m}] 64
set_multicycle_path -hold -end -from  [get_clocks {VCOCLK_DIV_27m}]  -to  [get_clocks {PFD_VCOCLK_27m}] 63
set_multicycle_path -setup -end -from  [get_clocks {TR_TX_PCLK_27m}]  -to  [get_clocks {sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout}] 5
set_multicycle_path -hold -end -from  [get_clocks {TR_TX_PCLK_27m}]  -to  [get_clocks {sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout}] 4
set_multicycle_path -setup -end -from  [get_clocks {VCOCLK_DIV_74m25}]  -to  [get_clocks {PFD_VCOCLK_74m25}] 64
set_multicycle_path -hold -end -from  [get_clocks {VCOCLK_DIV_74m25}]  -to  [get_clocks {PFD_VCOCLK_74m25}] 63
set_multicycle_path -setup -end -from  [get_clocks {TR_TX_PCLK_74m25}]  -to  [get_clocks {sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout}] 2
set_multicycle_path -hold -end -from  [get_clocks {TR_TX_PCLK_74m25}]  -to  [get_clocks {sdi_tx_inst|sdi_megacore_top_inst|sdi_txrx_port_gen[0].u_txrx_port|gen_tx_alt4gxb.u_gxb|alt4gxb_component|auto_generated|transmit_pcs0|clkout}] 1
set_multicycle_path -setup -end -from  [get_clocks {VCOCLK_DIV_148m_DUPLEX}]  -to  [get_clocks {PFD_VCOCLK_148m_DUPLEX}] 64
set_multicycle_path -hold -end -from  [get_clocks {VCOCLK_DIV_148m_DUPLEX}]  -to  [get_clocks {PFD_VCOCLK_148m_DUPLEX}] 63
set_multicycle_path -setup -end -from  [get_clocks {VCOCLK_DIV_148m_TXONLY}]  -to  [get_clocks {PFD_VCOCLK_148m_TXONLY}] 64
set_multicycle_path -hold -end -from  [get_clocks {VCOCLK_DIV_148m_TXONLY}]  -to  [get_clocks {PFD_VCOCLK_148m_TXONLY}] 63


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

