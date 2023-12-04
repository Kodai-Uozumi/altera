package provide ::qboard::cc 1.0

# ----------------------------------------------------------------
#
namespace eval ::qboard::cc {
#
# Description: DE2 Configuration
#
# ----------------------------------------------------------------


	namespace export get_name
	namespace export get_revision
	namespace export set_default_assignments 

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
    variable board_name "Cubic Cyclonium"
}

# ----------------------------------------------------------------
#
proc ::qboard::cc::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qboard::cc::get_name { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable board_name
	return $board_name
}

# ----------------------------------------------------------------
#
proc ::qboard::cc::set_default_assignments { } {
	#
	# Description: Make all required QSF assignments
	#
	# ----------------------------------------------------------------

	# Set QBOARD's Family and Device
	set_global_assignment -name FAMILY "Cyclone"
	set_global_assignment -name DEVICE "EP1C6F256C6"

	# Pin & Location Assignments
	# ==========================
	set_instance_assignment -name FAST_INPUT_REGISTER ON -to sdram_fast_input_register_instance -entity sdram_fast_input_register -tag qboard
	set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to sdram_fast_output_register_instance -entity sdram_fast_output_register -tag qboard

	set_instance_assignment -name IO_STANDARD LVTTL -to INIT_DONE -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SDRAM_CLK -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to led_MATRIX[*] -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to userIO_en_n -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to userIO_in[*] -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to userIO_in[1] -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to userIO_out[*] -tag qboard

	set_location_assignment PIN_G1 -to CLOCKINPUT -tag qboard
	set_location_assignment PIN_B2 -to PLD_RESET_N -tag qboard
	set_location_assignment PIN_A15 -to SDRAM_A[0] -tag qboard
	set_location_assignment PIN_D5 -to SDRAM_A[10] -tag qboard
	set_location_assignment PIN_B15 -to SDRAM_A[1] -tag qboard
	set_location_assignment PIN_B14 -to SDRAM_A[2] -tag qboard
	set_location_assignment PIN_D6 -to SDRAM_A[3] -tag qboard
	set_location_assignment PIN_D7 -to SDRAM_A[4] -tag qboard
	set_location_assignment PIN_D8 -to SDRAM_A[5] -tag qboard
	set_location_assignment PIN_D9 -to SDRAM_A[6] -tag qboard
	set_location_assignment PIN_D10 -to SDRAM_A[7] -tag qboard
	set_location_assignment PIN_D11 -to SDRAM_A[8] -tag qboard
	set_location_assignment PIN_D12 -to SDRAM_A[9] -tag qboard
	set_location_assignment PIN_C5 -to SDRAM_BA[0] -tag qboard
	set_location_assignment PIN_C4 -to SDRAM_BA[1] -tag qboard
	set_location_assignment PIN_C8 -to SDRAM_CAS_N -tag qboard
	set_location_assignment PIN_C12 -to SDRAM_CKE -tag qboard
	set_location_assignment PIN_C6 -to SDRAM_CS_N -tag qboard
	set_location_assignment PIN_C10 -to SDRAM_DQM[0] -tag qboard
	set_location_assignment PIN_C13 -to SDRAM_DQM[1] -tag qboard
	set_location_assignment PIN_B13 -to SDRAM_DQM[2] -tag qboard
	set_location_assignment PIN_C11 -to SDRAM_DQM[3] -tag qboard
	set_location_assignment PIN_B16 -to SDRAM_DQ[0] -tag qboard
	set_location_assignment PIN_E7 -to SDRAM_DQ[10] -tag qboard
	set_location_assignment PIN_E8 -to SDRAM_DQ[11] -tag qboard
	set_location_assignment PIN_E9 -to SDRAM_DQ[12] -tag qboard
	set_location_assignment PIN_E10 -to SDRAM_DQ[13] -tag qboard
	set_location_assignment PIN_E11 -to SDRAM_DQ[14] -tag qboard
	set_location_assignment PIN_E12 -to SDRAM_DQ[15] -tag qboard
	set_location_assignment PIN_A9 -to SDRAM_DQ[16] -tag qboard
	set_location_assignment PIN_A8 -to SDRAM_DQ[17] -tag qboard
	set_location_assignment PIN_A6 -to SDRAM_DQ[18] -tag qboard
	set_location_assignment PIN_A4 -to SDRAM_DQ[19] -tag qboard
	set_location_assignment PIN_C14 -to SDRAM_DQ[1] -tag qboard
	set_location_assignment PIN_A13 -to SDRAM_DQ[20] -tag qboard
	set_location_assignment PIN_A11 -to SDRAM_DQ[21] -tag qboard
	set_location_assignment PIN_B3 -to SDRAM_DQ[22] -tag qboard
	set_location_assignment PIN_B4 -to SDRAM_DQ[23] -tag qboard
	set_location_assignment PIN_B5 -to SDRAM_DQ[24] -tag qboard
	set_location_assignment PIN_B6 -to SDRAM_DQ[25] -tag qboard
	set_location_assignment PIN_B7 -to SDRAM_DQ[26] -tag qboard
	set_location_assignment PIN_B8 -to SDRAM_DQ[27] -tag qboard
	set_location_assignment PIN_B9 -to SDRAM_DQ[28] -tag qboard
	set_location_assignment PIN_B10 -to SDRAM_DQ[29] -tag qboard
	set_location_assignment PIN_C15 -to SDRAM_DQ[2] -tag qboard
	set_location_assignment PIN_B11 -to SDRAM_DQ[30] -tag qboard
	set_location_assignment PIN_B12 -to SDRAM_DQ[31] -tag qboard
	set_location_assignment PIN_D13 -to SDRAM_DQ[3] -tag qboard
	set_location_assignment PIN_D14 -to SDRAM_DQ[4] -tag qboard
	set_location_assignment PIN_D15 -to SDRAM_DQ[5] -tag qboard
	set_location_assignment PIN_D16 -to SDRAM_DQ[6] -tag qboard
	set_location_assignment PIN_E13 -to SDRAM_DQ[7] -tag qboard
	set_location_assignment PIN_E5 -to SDRAM_DQ[8] -tag qboard
	set_location_assignment PIN_E6 -to SDRAM_DQ[9] -tag qboard
	set_location_assignment PIN_C7 -to SDRAM_RAS_N -tag qboard
	set_location_assignment PIN_C9 -to SDRAM_WE_N -tag qboard
	set_location_assignment PIN_M4 -to led_MATRIX[0] -tag qboard
	set_location_assignment PIN_M1 -to led_MATRIX[10] -tag qboard
	set_location_assignment PIN_L5 -to led_MATRIX[11] -tag qboard
	set_location_assignment PIN_L4 -to led_MATRIX[12] -tag qboard
	set_location_assignment PIN_L3 -to led_MATRIX[13] -tag qboard
	set_location_assignment PIN_L2 -to led_MATRIX[14] -tag qboard
	set_location_assignment PIN_L1 -to led_MATRIX[15] -tag qboard
	set_location_assignment PIN_K5 -to led_MATRIX[16] -tag qboard
	set_location_assignment PIN_K1 -to led_MATRIX[17] -tag qboard
	set_location_assignment PIN_H5 -to led_MATRIX[18] -tag qboard
	set_location_assignment PIN_G5 -to led_MATRIX[19] -tag qboard
	set_location_assignment PIN_N1 -to led_MATRIX[1] -tag qboard
	set_location_assignment PIN_G3 -to led_MATRIX[20] -tag qboard
	set_location_assignment PIN_G2 -to led_MATRIX[21] -tag qboard
	set_location_assignment PIN_F5 -to led_MATRIX[22] -tag qboard
	set_location_assignment PIN_F4 -to led_MATRIX[23] -tag qboard
	set_location_assignment PIN_F3 -to led_MATRIX[24] -tag qboard
	set_location_assignment PIN_F2 -to led_MATRIX[25] -tag qboard
	set_location_assignment PIN_F1 -to led_MATRIX[26] -tag qboard
	set_location_assignment PIN_E4 -to led_MATRIX[27] -tag qboard
	set_location_assignment PIN_E3 -to led_MATRIX[28] -tag qboard
	set_location_assignment PIN_N2 -to led_MATRIX[2] -tag qboard
	set_location_assignment PIN_N3 -to led_MATRIX[3] -tag qboard
	set_location_assignment PIN_N4 -to led_MATRIX[4] -tag qboard
	set_location_assignment PIN_P2 -to led_MATRIX[5] -tag qboard
	set_location_assignment PIN_P3 -to led_MATRIX[6] -tag qboard
	set_location_assignment PIN_R1 -to led_MATRIX[7] -tag qboard
	set_location_assignment PIN_M3 -to led_MATRIX[8] -tag qboard
	set_location_assignment PIN_M2 -to led_MATRIX[9] -tag qboard
	set_location_assignment PIN_P4 -to miso_spi_sec_flash -tag qboard
	set_location_assignment PIN_T4 -to mosi_spi_sec_flash -tag qboard
	set_location_assignment PIN_P10 -to rtc_data_io -tag qboard
	set_location_assignment PIN_P11 -to rtc_reset_n -tag qboard
	set_location_assignment PIN_R11 -to rtc_sclk -tag qboard
	set_location_assignment PIN_R4 -to sclk_spi_sec_flash -tag qboard
	set_location_assignment PIN_R3 -to ss_n_spi_sec_flash -tag qboard
	set_location_assignment PIN_M9 -to userIO_en_n -tag qboard
	set_location_assignment PIN_T13 -to userIO_in[0] -tag qboard
	set_location_assignment PIN_R12 -to userIO_in[1] -tag qboard
	set_location_assignment PIN_P12 -to userIO_in[2] -tag qboard
	set_location_assignment PIN_M12 -to userIO_in[3] -tag qboard
	set_location_assignment PIN_M11 -to userIO_in[4] -tag qboard
	set_location_assignment PIN_R15 -to userIO_out[0] -tag qboard
	set_location_assignment PIN_T15 -to userIO_out[1] -tag qboard
	set_location_assignment PIN_P13 -to userIO_out[2] -tag qboard
	set_location_assignment PIN_R14 -to userIO_out[3] -tag qboard
	set_location_assignment PIN_R13 -to userIO_out[4] -tag qboard
	set_location_assignment PIN_H13 -to vga_BLANK_n -tag qboard
	set_location_assignment PIN_F16 -to vga_B[0] -tag qboard
	set_location_assignment PIN_F15 -to vga_B[1] -tag qboard
	set_location_assignment PIN_F14 -to vga_B[2] -tag qboard
	set_location_assignment PIN_F13 -to vga_B[3] -tag qboard
	set_location_assignment PIN_F12 -to vga_B[4] -tag qboard
	set_location_assignment PIN_E16 -to vga_B[5] -tag qboard
	set_location_assignment PIN_E15 -to vga_B[6] -tag qboard
	set_location_assignment PIN_E14 -to vga_B[7] -tag qboard
	set_location_assignment PIN_G15 -to vga_CLOCK -tag qboard
	set_location_assignment PIN_M14 -to vga_G[0] -tag qboard
	set_location_assignment PIN_M13 -to vga_G[1] -tag qboard
	set_location_assignment PIN_L16 -to vga_G[2] -tag qboard
	set_location_assignment PIN_L15 -to vga_G[3] -tag qboard
	set_location_assignment PIN_L14 -to vga_G[4] -tag qboard
	set_location_assignment PIN_L13 -to vga_G[5] -tag qboard
	set_location_assignment PIN_L12 -to vga_G[6] -tag qboard
	set_location_assignment PIN_K16 -to vga_G[7] -tag qboard
	set_location_assignment PIN_G12 -to vga_HSYNC -tag qboard
	set_location_assignment PIN_P15 -to vga_R[0] -tag qboard
	set_location_assignment PIN_P14 -to vga_R[1] -tag qboard
	set_location_assignment PIN_N16 -to vga_R[2] -tag qboard
	set_location_assignment PIN_N15 -to vga_R[3] -tag qboard
	set_location_assignment PIN_N14 -to vga_R[4] -tag qboard
	set_location_assignment PIN_N13 -to vga_R[5] -tag qboard
	set_location_assignment PIN_M16 -to vga_R[6] -tag qboard
	set_location_assignment PIN_M15 -to vga_R[7] -tag qboard
	set_location_assignment PIN_H12 -to vga_SYNC_n -tag qboard
	set_location_assignment PIN_G13 -to vga_VSYCN -tag qboard


	# Other Assignments
	# =====================
	set_global_assignment -name CYCLONE_CONFIGURATION_DEVICE EPCS4 -tag qboard
	set_global_assignment -name CYCLONE_CONFIGURATION_SCHEME "ACTIVE SERIAL" -tag qboard
	set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION ON -tag qboard
	set_global_assignment -name RESERVE_PIN "AS INPUT TRI-STATED" -tag qboard
	set_global_assignment -name AUTO_RESTART_CONFIGURATION OFF -tag qboard
	set_global_assignment -name GENERATE_HEX_FILE ON -tag qboard

}
