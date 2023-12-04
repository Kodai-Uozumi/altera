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
# Description: This script is used for adding relevant signals to the wave window

onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider -height 30 {Input}
add wave -noupdate -format Logic -radix binary /freq_hopping_example_tb/clk
add wave -noupdate -format Logic -radix binary /freq_hopping_example_tb/clken
add wave -noupdate -format Logic -radix binary /freq_hopping_example_tb/reset_n

add wave -noupdate -divider -height 30 {Avalon-MM}
add wave -noupdate -format Logic -radix binary /freq_hopping_example_tb/write
add wave -noupdate -format Logic -radix unsigned /freq_hopping_example_tb/address
add wave -noupdate -format Literal -radix decimal /freq_hopping_example_tb/write_data

add wave -noupdate -divider -height 30 {Phase increment}
add wave -noupdate -format Logic -radix unsigned /freq_hopping_example_tb/freq_sel
add wave -noupdate -format Logic -radix decimal /freq_hopping_example_tb/freq_hopping_example_inst/phi_inc_i

add wave -noupdate -divider -height 30 {Output value}
add wave -noupdate -format Logic -radix binary /freq_hopping_example_tb/out_valid
add wave -noupdate -format Literal -radix decimal /freq_hopping_example_tb/fsin_o
add wave -noupdate -format Literal -radix decimal /freq_hopping_example_tb/fcos_o

add wave -noupdate -divider -height 80 {sine waveform}
add wave -noupdate -color Yellow -format Analog-Step -radix decimal -scale 2.5E-4 /freq_hopping_example_tb/fsin_o

add wave -noupdate -divider -height 80 {cosine waveform}
add wave -noupdate -color Cyan -format Analog-Step -radix decimal -scale 2.5E-4 /freq_hopping_example_tb/fcos_o

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {356 ns}
WaveRestoreZoom {0 ns} {2132 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
