onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {SDI MegaCore ports}
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/enable_crc
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/enable_ln
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/rst
add wave -noupdate -format Literal /tb_sdi_megacore_top/hd_duplex_inst/rx_anc_data
add wave -noupdate -format Literal /tb_sdi_megacore_top/hd_duplex_inst/rx_anc_error
add wave -noupdate -format Literal /tb_sdi_megacore_top/hd_duplex_inst/rx_anc_valid
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/rx_AP
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/rx_clk
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/rx_data_valid_out
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/rx_F
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/rx_H
add wave -noupdate -format Literal /tb_sdi_megacore_top/hd_duplex_inst/rx_ln
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/rx_serial_refclk
add wave -noupdate -format Literal /tb_sdi_megacore_top/hd_duplex_inst/rx_status
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/rx_V
add wave -noupdate -format Literal /tb_sdi_megacore_top/hd_duplex_inst/rxdata
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/sdi_rx
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/sdi_tx
add wave -noupdate -format Literal /tb_sdi_megacore_top/hd_duplex_inst/tx_ln
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/tx_pclk
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/tx_serial_refclk
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/tx_status
add wave -noupdate -format Logic /tb_sdi_megacore_top/hd_duplex_inst/tx_trs
add wave -noupdate -format Literal /tb_sdi_megacore_top/hd_duplex_inst/txdata
add wave -noupdate -divider {Pattern Gen Ports}
add wave -noupdate -format Logic /tb_sdi_megacore_top/u_gen/clk
add wave -noupdate -format Logic /tb_sdi_megacore_top/u_gen/rst
add wave -noupdate -format Logic /tb_sdi_megacore_top/u_gen/hd_sdn
add wave -noupdate -format Logic /tb_sdi_megacore_top/u_gen/bar_75_100n
add wave -noupdate -format Logic /tb_sdi_megacore_top/u_gen/enable
add wave -noupdate -format Logic /tb_sdi_megacore_top/u_gen/patho
add wave -noupdate -format Logic /tb_sdi_megacore_top/u_gen/blank
add wave -noupdate -format Logic /tb_sdi_megacore_top/u_gen/no_color
add wave -noupdate -format Literal /tb_sdi_megacore_top/u_gen/dout
add wave -noupdate -format Logic /tb_sdi_megacore_top/u_gen/trs
add wave -noupdate -format Literal /tb_sdi_megacore_top/u_gen/ln
add wave -noupdate -format Literal /tb_sdi_megacore_top/u_gen/select_std
add wave -noupdate -divider {Testbench waves}
add wave -noupdate -format Literal /tb_sdi_megacore_top/CLK75_PERIOD
add wave -noupdate -format Literal /tb_sdi_megacore_top/CLK27_PERIOD
add wave -noupdate -format Literal /tb_sdi_megacore_top/SERIAL_PERIOD
add wave -noupdate -format Logic /tb_sdi_megacore_top/gen_trs
add wave -noupdate -format Literal /tb_sdi_megacore_top/trs_count
add wave -noupdate -format Logic /tb_sdi_megacore_top/refclk
add wave -noupdate -format Logic /tb_sdi_megacore_top/ref27
add wave -noupdate -format Logic /tb_sdi_megacore_top/rst
add wave -noupdate -color Coral -format Logic -itemcolor Black /tb_sdi_megacore_top/serial_rx
add wave -noupdate -color Coral -format Logic -itemcolor Black /tb_sdi_megacore_top/serial_tx
add wave -noupdate -format Logic /tb_sdi_megacore_top/align_locked
add wave -noupdate -format Logic /tb_sdi_megacore_top/trs_locked
add wave -noupdate -format Literal /tb_sdi_megacore_top/rx_ln
add wave -noupdate -format Literal /tb_sdi_megacore_top/gen_data
add wave -noupdate -format Literal /tb_sdi_megacore_top/gen_ln
add wave -noupdate -format Literal /tb_sdi_megacore_top/rx_status
add wave -noupdate -format Logic /tb_sdi_megacore_top/tx_status
add wave -noupdate -format Event /tb_sdi_megacore_top/tx_sclk
add wave -noupdate -format Logic /tb_sdi_megacore_top/sample
add wave -noupdate -format Literal /tb_sdi_megacore_top/tx_lfsr
add wave -noupdate -format Logic /tb_sdi_megacore_top/tx_nrzi
add wave -noupdate -format Logic /tb_sdi_megacore_top/last_sample
add wave -noupdate -format Logic /tb_sdi_megacore_top/descrambled
add wave -noupdate -format Literal /tb_sdi_megacore_top/shiftreg
add wave -noupdate -format Logic /tb_sdi_megacore_top/aligned
add wave -noupdate -format Literal /tb_sdi_megacore_top/bit
add wave -noupdate -format Literal /tb_sdi_megacore_top/t_txword
add wave -noupdate -format Literal /tb_sdi_megacore_top/txword
add wave -noupdate -format Event /tb_sdi_megacore_top/word_tick
add wave -noupdate -format Literal /tb_sdi_megacore_top/last_ln
add wave -noupdate -format Literal /tb_sdi_megacore_top/expected_ln
add wave -noupdate -format Logic /tb_sdi_megacore_top/bad_ln
add wave -noupdate -format Logic /tb_sdi_megacore_top/bad_align_locked
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {462805000 fs} 0}
configure wave -namecolwidth 193
configure wave -valuecolwidth 76
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 fs} {263792967900 fs}
